#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: pin_rel_transform_cdr.pl:UelEaiVelocityInt:1:2006-Sep-05 22:25:00 %
#       pin_rel_transform_cdr.pl
#
#       Copyright (c) 2002-2006 Oracle. All rights reserved.
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#
#===============================================================================
# Perl script to transform the discount files produced by inteGrate to EDR files
# that iREL understands.
#
# CALLING PROGRAM
#    iREL Driver (java program)
#
# CALLED PROGRAMS
#    None
#
# COMMAND LINE ARGUMENTS
#    1. Discount file name (these files have .disc extension)
#    2. Output file name
#    3. Infranet Database number.
#    4. negativeDiscountCarryOver flag.
#
# OUTPUT
#    EDR file (output file name is given by REL driver)
#
#    Exit value of script is 0 on success, -ve value otherwise depending on
#    the error.
#
# LAST MODIFIED
#    2004-03-11
#
#===============================================================================

#
# Needed for time related functions.
#

use Time::Local;
use pcmif;

$USAGE = "\nperl pin_rel_transform_cdr.pl discountFileName " .
                  " outputFileName " .
                  " InfranetDbNumber " .                  
                  " negativeDiscountCarryOver \n";
                  
#
# Define debug flag
#
$debug = 0;

#
# EDR file specification
#
$edr_recfield_delimiter = "\t";
$h_record_type = "010";     # header record type
$bdr_record_type = "020";   # basic detail record type
$ibr_record_type = "900";   # infranet billing record type
$bal_record_type = "600";   # balance record type
$t_record_type = "090";     # trailer record type

#
# Script return values
# 0-99:    Portal reserved range
# 100-255: Customer reserved range
#
$SUCCESS = 0;
$USAGE_ERR = 1;
$CANNOT_OPEN_FILE = 2;
$CANNOT_WRITETO_FILE = 3;
$INVALID_NEGATIVE_DISCOUNT_CARRY_OVER = 4;

#
# There will be eight command line arguments.
# First one is the discount file name, second one is the delimiter for the 
# output EDR file record fields and the third one is the Infranet DB number.
# The next 5 are different record types in the output EDR file.
#

$argn = @ARGV;

if ($argn < 4) {
   exit_err ($USAGE_ERR, "Invalid Usage. Correct usage is \n", $USAGE);
}

#
# The output EDR file name is given by REL driver.
#

$discountFile = @ARGV[0];
$edrFile = @ARGV[1];
print "Discount file : $discountFile\n" if $debug;
print "Output file : $edrFile\n" if $debug;

#
# Parse the command line parameter and get the DB number in the desired format.
#

$db_number = substr(@ARGV[2], rindex (@ARGV[2], ".") + 1, length(@ARGV[2]));
print "Infranet database number : $db_number\n" if $debug;

#
# Dummy poid is 3 spaces, needed for the sql*ldr to work properly
# with the current control files.
#

$dummyPoid = "   ";

#
# Parse the command line parameter and get the negative discount carry over flag.
# Possible values are 0/1/2. Only value 2 will require
# special treatment for transforming the discount files.
# other values are of not much significance to IREL.
# Value 2 indicates pin_rel_transform_cdr.pl to adjust negative unused
# units for non-expired periods as well. This needs to be set only
# if the corresponding parameter is set in the Integrate Registry
# File.
#

$neg_dsczeroout = @ARGV[3];
print "Negative discount carry over flag : $neg_dsczeroout\n" if $debug;
if ($neg_dsczeroout < 0 || $neg_dsczeroout > 2) {
    exit_err($INVALID_NEGATIVE_DISCOUNT_CARRY_OVER, "was $neg_dsczeroout", "valid valus are 0 - 2");
}
$ADJUSTNEGATIVE = "2";

#
# Various Discount file record types.
#

$keyValueRecType = "#10#";
$aggregateCounterRecType = "#20#";
$rolloverPeriodsRecType = "#50#";
$trailerRecType = "#90#";

#
# Delimiter for the discount file fields.
#

$dicount_file_recfield_delimiter = ";";

#
# Find out the UTC offset.
#

$timeHere = timelocal((localtime)[0..5]);
$utcTime = timelocal((gmtime)[0..5]);

$timeDiff = $timeHere - $utcTime;
$utcOffsetHour = int (abs($timeDiff/3600));
$utcOffsetMin = int ((abs($timeDiff) - (abs($utcOffsetHour) * 3600))/60);

if (length($utcOffsetHour) == 1) {
    $utcOffsetHour = "0" . $utcOffsetHour;
}

if (length($utcOffsetMin) == 1) {
    $utcOffsetMin = $utcOffsetMin . "0";
}

if ($timeDiff < 0) {
    $utcOffset = "-" . $utcOffsetHour . $utcOffsetMin;
} else {
    $utcOffset = "+" . $utcOffsetHour . $utcOffsetMin;
}

#
# Open the input discount file for reading.
# Open the output EDR file for writing.
#

open (DISCOUNT_FILE, $discountFile) || exit_err($CANNOT_OPEN_FILE, $discountFile, "$!");
open (EDR_FILE, ">$edrFile") || exit_err($CANNOT_WRITETO_FILE, $edrFile, "$!");

#
# Global variable to keep track of the record number.
#

$record_number = 0;
$event_id = 0;

#
# Keep track of the number of EDRs written to the output EDR file.
#

$t_total_number_of_records = 0;

# 
# Flag to indicate if valid type #50# records are found or not.
#
$noCDRFound = 1;

#
# Every type of record has 2 functions to fill the fields in the records.
# There is an init function that fills the values that will not change
# from one instance of the record to another. Example is field like record type.
# There is another function finalize that will fill in values that will change 
# from one instance to another. For example, in case of a Infranet Billing Record
# the Account POID will change from one instance of the record to another.
# 
# For some records like header record & trailer record that appears only once,
# there is only the init function.
#

#
# Initalize all the record types, except the trailer record.
# Trailer record will be initialized just before writing it, so that
# we will have all the information (like total number of records) needed.
#

&initHeaderRec;
&initBdrRec;
&initIbrRec;
&initBalImpRec;

#
# Set the default filehandle to EDR_FILE.
#

select (EDR_FILE);

#
# Associate the HEADER_REC format to the default filehandle.
# So the next 'write' command will write the HEADER_REC to EDR_FILE.
#

$~ = "HEADER_REC";
write;

#
# Read one record (line) at a time and process the record depending on the record type.
#


while (<DISCOUNT_FILE>) {

    $RECORD_READ = $_;


    # This should read the header and have conditional logic based on the schema version.
    # As the discount file schema changes, this needs to accomodate it...
    # always outputting the most recent schema version.
    #
    # Note: the current schema does not include a record type for the header record.


    ($record_type) = split /$dicount_file_recfield_delimiter/, $RECORD_READ;

    if ( $record_type eq $keyValueRecType ) {

        ($k_rec_type, $k_keyValue, $k_resourceId, $k_accountId, 
         $k_discountStep, $k_discountMaster) = split /$dicount_file_recfield_delimiter/, $RECORD_READ;  
    
        #
        # We have only the account obj id0. Use it to form the account poid.
        #
         
        $accountPoid = $db_number . " /account " . $k_accountId . " 0";  


	#
	# Keep track of the number of balance impact records under each account obj id0.    
        #

        $balance_imp_rec_count = 0;
      
    } elsif ( $record_type eq $aggregateCounterRecType ) {   

        #
        # This record type is unused by iREL.
        #
 
        next;

    } elsif ( $record_type eq $rolloverPeriodsRecType ) {       
  
        #
        # Skip the record if resource_id = 0
        # resource_id = 0 is invalid to Infranet but it is used in IntegRate internally
        #
        next if ($k_resourceId == 0);

        ($rp_rec_type, $rp_periodDate, $rp_itemPoid, $rp_createdDate, $rp_expirationDate, $rp_expired,
         $rp_initialUnits, $rp_creditUnits, $rp_debitUnits, $rp_usedUnits, $rp_unUsedUnits,
         $rp_lostUnits, $rp_uselessUnits) = split /$dicount_file_recfield_delimiter/, $RECORD_READ;


        #
        # Skip the record if the discount is not yet expired and if negative
	# discounts is not to be adjusted (!= 2).
        #
    
	next if (($rp_expired == 0) && ($neg_dsczeroout ne $ADJUSTNEGATIVE));
            
        #
        # Skip the record if the discount is not yet expired and if negative 
	# discounts are to be adjusted, but the unused units is not negative.
        #

	next if (($rp_expired == 0) && ($neg_dsczeroout eq $ADJUSTNEGATIVE) && ($rp_unUsedUnits >= 0));

        #
	# If the period is expired, then the balance impact is negative of the
        # sum of unusedUnits, lostUnits and uselessUnits. Otherwise, it is
	# negative of the unusedUnits only.
        #
    
	if ($rp_expired == 0) {
		$rp_unUsedUnits = $rp_unUsedUnits + $rp_lostUnits + $rp_uselessUnits;
        	$rp_unUsedUnits *= -1;  
	} else {
        	$rp_unUsedUnits *= -1;  
	}

        #
        # Atleast one valid #50# record found.
        #
	$noCDRFound = 0;

        #
        # The DB number in the item format is in the format 0.0.0.x
        # But we need only x
        #
        # rindex function returns the position of the last occurance of the 
        # given substring.
        # 

        $rp_itemPoid = substr ($rp_itemPoid, rindex($rp_itemPoid, ".") + 1, length($rp_itemPoid)); 

	#
        # Increment the balance impact record count.
        # The BDR and IBR records need to be written only once irrespective of the number of 
        # balance impact records. Also BDR and IBR records need to be written only 
        # if there is a balance impact record.
        #

        $balance_imp_rec_count += 1;

        if ($balance_imp_rec_count == 1) {

            &finalizeBdrRec;
            $~ = "BDR_REC";
            write;
    
            &finalizeIbrRec;
            $~ = "IBR_REC";
            write;
        }

        #
        # Now write the balance impact record.
        #

        &finalizeBalImpRec;
        $~ = "BAL_IMP_REC";
        write;     

    } elsif ( $record_type eq $trailerRecType ) {  

        $t_rec_type = $record_type;
        $t_total_number_of_records += 1;   

    } else {

         next;

    }
               
}

#
# Write TRAILER_REC to the EDR output file.
#
# 

&initTrailerRec;
$~ = "TRAILER_REC";
write;

#
# Close the discount input file and the EDR output file.
#

close (DISCOUNT_FILE);
close (EDR_FILE);

#
# If all the #50# records are skipped, nothing is to be done, so exit.
#
# 
if ($noCDRFound == 1) {
   # just print out a warning message but treat it as a success case
   print "No Valid Balance Records. (Type #50#) \n";
}

exit ($SUCCESS);

#
# Define a format for each type of record to be written to the
# output EDR file. Using formats simplifies and gives better performance.
#

#
# Header Record.
#

format HEADER_REC =
@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*
$h_record_type, $h_record_number, $h_sender, $h_recipient, $h_sequence_number, $h_origin_sequence_number, $h_creation_timestamp, $h_transmission_date, $h_transfer_cutoff_timestamp, $h_utc_time_offset, $h_specification_version_number, $h_release_version, $h_origin_country_code, $h_sender_country_code, $h_data_type_indicator, $h_iac_list, $h_cc_list, $h_creation_process, $h_schema_version, $h_event_type
.


#
# Basic Detail Record.
#


format BDR_REC = 
@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*
$bdr_record_type, $bdr_record_number, $bdr_event_id, $bdr_batch_id, $bdr_original_batch_id, $bdr_discarding, $bdr_chain_reference, $bdr_source_network_type, $bdr_source_network, $bdr_destination_network_type, $bdr_destination_network, $bdr_type_of_a_identification, $bdr_a_modification_indicator, $bdr_a_type_of_number, $bdr_a_numbering_plan, $bdr_a_number, $bdr_b_modification_indicator, $bdr_b_type_of_number, $bdr_b_numbering_plan, $bdr_b_number, $bdr_description, $bdr_c_modification_indicator, $bdr_c_type_of_number, $bdr_c_numbering_plan, $bdr_c_number, $bdr_usage_direction, $bdr_connect_type, $bdr_connect_sub_type, $bdr_basic_service, $bdr_quality_of_service_requested, $bdr_quality_of_service_used, $bdr_call_completion_indicatorclose_cause, $bdr_long_duration_indicator, $bdr_charging_start_timestamp, $bdr_charging_end_timestamp, $bdr_utc_time_offset, $bdr_duration, $bdr_duration_uom, $bdr_volume_sent, $bdr_volume_sent_uom, $bdr_volume_received, $bdr_volume_received_uom, $bdr_number_of_units, $bdr_number_of_units_uom, $bdr_retail_impact_category, $bdr_retail_charged_amount_value, $bdr_retail_charged_amount_currency, $bdr_retail_charged_tax_treatment, $bdr_retail_charged_tax_rate, $bdr_wholesale_impact_category, $bdr_wholesale_charged_amount_value, $bdr_wholesale_charged_amount_currency, $bdr_wholesale_charged_tax_treatment, $bdr_wholesale_charged_tax_rate, $bdr_zone_description, $bdr_ic_description, $bdr_zone_entry_name, $bdr_tariff_class, $bdr_tariff_sub_class, $bdr_usage_class, $bdr_usage_type, $bdr_billcycle_period, $bdr_prepaid_indicator, $bdr_number_associated_records, $bdr_ne_charging_start_t, $bdr_ne_charging_end_t, $bdr_utc_ne_start_t_offset, $bdr_utc_ne_end_t_offset, $bdr_utc_end_t_offset, $bdr_incoming_route, $bdr_routing_category, $bdr_intern_process_status
.


#
# Associated Infranet Billing Record.
#

format IBR_REC =
@*@*@*@*@*@*@*@*@*@*@*
$ibr_record_type, $ibr_record_number, $ibr_account_poid, $ibr_service_poid, $ibr_item_poid, $ibr_original_event_poid, $ibr_pin_tax_locales, $ibr_pin_tax_supplier_id, $ibr_pin_provider_id, $ibr_pin_invoice_data, $ibr_number_of_pin_balance_impact_packets
.


#
# Supplementary Balance Impact Packet Record.
#

format BAL_IMP_REC= 
@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*@*
$bal_record_type, $bal_record_number, $bal_account_poid, $bal_pin_resource_id, $bal_pin_impact_category, $bal_pin_product_poid, $bal_pin_gl_id, $bal_pin_tax_code, $bal_pin_rate_tag, $bal_pin_lineage, $bal_pin_node_location, $bal_pin_quantity, $bal_pin_amount, $bal_pin_amount_deferred, $bal_pin_discount, $bal_pin_info_string
.


#
# Trailer Record.
#

format TRAILER_REC = 
@*@*@*@*@*@*@*@*@*@*@*@*@*
$t_record_type, $t_record_number, $t_sender, $t_recipient, $t_sequence_number, $t_origin_sequence_number, $t_total_number_of_records, $t_first_charging_start_timestamp, $t_first_charging_utc_time_offset, $t_last_charging_start_timestamp, $t_last_charging_utc_time_offset, $t_total_retail_charged_value, $t_total_wholesale_charged_value
.


sub initHeaderRec {
    $record_number += 1;
    
    $h_record_type .= $edr_recfield_delimiter;
    $h_record_number = $record_number . $edr_recfield_delimiter;
    $h_sender .= $edr_recfield_delimiter;
    $h_recipient .= $edr_recfield_delimiter;
    $h_sequence_number = pcmif::pin_perl_time() . $edr_recfield_delimiter;
    $h_origin_sequence_number .= $edr_recfield_delimiter;
    $h_creation_timestamp = pcmif::pin_perl_time() . $edr_recfield_delimiter;
    $h_transmission_date = pcmif::pin_perl_time() . $edr_recfield_delimiter;
    $h_transfer_cutoff_timestamp .= $edr_recfield_delimiter;
    $h_utc_time_offset = $utcOffset . $edr_recfield_delimiter;
    $h_specification_version_number = "6" . $edr_recfield_delimiter;
    $h_release_version = "5" . $edr_recfield_delimiter;
    $h_origin_country_code .= $edr_recfield_delimiter;
    $h_sender_country_code .= $edr_recfield_delimiter;
    $h_data_type_indicator .= $edr_recfield_delimiter;
    $h_iac_list .= $edr_recfield_delimiter;
    $h_cc_list = "" . $edr_recfield_delimiter;
    $h_creation_process = "PIN_REL_TRANSFORM_CDR" . $edr_recfield_delimiter;
    $h_schema_version = "10000" . $edr_recfield_delimiter;
    $h_event_type = "/event/billing/debit"; # no delimiter for last field in the rec.

    $bdr_batch_id = "DiscountBatch_" . pcmif::pin_perl_time() . $edr_recfield_delimiter;
    $bdr_original_batch_id = $bdr_batch_id;
}

sub initBdrRec {
    $bdr_record_type .= $edr_recfield_delimiter;
    
    $bdr_discarding .= $edr_recfield_delimiter;
    $bdr_chain_reference .= $edr_recfield_delimiter;
    $bdr_source_network_type .= $edr_recfield_delimiter;
    $bdr_source_network .= $edr_recfield_delimiter;
    $bdr_destination_network_type .= $edr_recfield_delimiter;
    $bdr_destination_network .= $edr_recfield_delimiter;
    $bdr_type_of_a_identification .= $edr_recfield_delimiter;
    $bdr_a_modification_indicator .= $edr_recfield_delimiter;
    $bdr_a_type_of_number .= $edr_recfield_delimiter;
    $bdr_a_numbering_plan .= $edr_recfield_delimiter;
    $bdr_a_number .= $edr_recfield_delimiter;
    $bdr_b_modification_indicator .= $edr_recfield_delimiter;
    $bdr_b_type_of_number .= $edr_recfield_delimiter;
    $bdr_b_numbering_plan .= $edr_recfield_delimiter;
    $bdr_b_number .= $edr_recfield_delimiter;
    $bdr_description .= $edr_recfield_delimiter;
    $bdr_c_modification_indicator .= $edr_recfield_delimiter;
    $bdr_c_type_of_number .= $edr_recfield_delimiter;
    $bdr_c_numbering_plan .= $edr_recfield_delimiter;
    $bdr_c_number .= $edr_recfield_delimiter;
    $bdr_usage_direction .= $edr_recfield_delimiter;
    $bdr_connect_type .= $edr_recfield_delimiter;
    $bdr_connect_sub_type .= $edr_recfield_delimiter;
    $bdr_basic_service .= $edr_recfield_delimiter;
    $bdr_quality_of_service_requested .= $edr_recfield_delimiter;
    $bdr_quality_of_service_used .= $edr_recfield_delimiter;
    $bdr_call_completion_indicatorclose_cause .= $edr_recfield_delimiter;
    $bdr_long_duration_indicator .= $edr_recfield_delimiter;


    $bdr_utc_time_offset = $utcOffset . $edr_recfield_delimiter;
    $bdr_duration = "0" . $edr_recfield_delimiter;
    $bdr_duration_uom .= $edr_recfield_delimiter;
    $bdr_volume_sent = "0" . $edr_recfield_delimiter;
    $bdr_volume_sent_uom .= $edr_recfield_delimiter;
    $bdr_volume_received .= $edr_recfield_delimiter;
    $bdr_volume_received_uom .= $edr_recfield_delimiter;
    $bdr_number_of_units .= $edr_recfield_delimiter;
    $bdr_number_of_units_uom .= $edr_recfield_delimiter;
    $bdr_retail_impact_category .= $edr_recfield_delimiter;
    $bdr_retail_charged_amount_value .= $edr_recfield_delimiter;
    $bdr_retail_charged_amount_currency .= $edr_recfield_delimiter;
    $bdr_retail_charged_tax_treatment .= $edr_recfield_delimiter;
    $bdr_retail_charged_tax_rate .= $edr_recfield_delimiter;
    $bdr_wholesale_impact_category .= $edr_recfield_delimiter;
    $bdr_wholesale_charged_amount_value .= $edr_recfield_delimiter;
    $bdr_wholesale_charged_amount_currency .= $edr_recfield_delimiter;
    $bdr_wholesale_charged_tax_treatment .= $edr_recfield_delimiter;
    $bdr_wholesale_charged_tax_rate .= $edr_recfield_delimiter;
    $bdr_zone_description .= $edr_recfield_delimiter;
    $bdr_ic_description .= $edr_recfield_delimiter;
    $bdr_zone_entry_name .= $edr_recfield_delimiter;
    $bdr_tariff_class .= $edr_recfield_delimiter;
    $bdr_tariff_sub_class .= $edr_recfield_delimiter;
    $bdr_usage_class .= $edr_recfield_delimiter;
    $bdr_usage_type .= $edr_recfield_delimiter;

    $bdr_prepaid_indicator .= $edr_recfield_delimiter;
    $bdr_number_associated_records .= $edr_recfield_delimiter;
    $bdr_ne_charging_start_t .= $edr_recfield_delimiter;
    $bdr_ne_charging_end_t .= $edr_recfield_delimiter; 
    $bdr_utc_ne_start_t_offset .= $edr_recfield_delimiter; 
    $bdr_utc_ne_end_t_offset .= $edr_recfield_delimiter; 
    $bdr_utc_end_t_offset .= $edr_recfield_delimiter;
    $bdr_incoming_route .= $edr_recfield_delimiter;
    $bdr_routing_category .= $edr_recfield_delimiter;
    $bdr_intern_process_status = ""; # no delimiter for last field in the rec.
}

sub finalizeBdrRec {
    $record_number += 1;
    $event_id += 1;
    $bdr_event_id = $event_id . $edr_recfield_delimiter;
    
    $bdr_record_number = $record_number . $edr_recfield_delimiter;    
    $bdr_charging_start_timestamp = pcmif::pin_perl_time() . $edr_recfield_delimiter;   
    $bdr_charging_end_timestamp = pcmif::pin_perl_time() . $edr_recfield_delimiter;  
    
    $bdr_billcycle_period = $rp_periodDate . $edr_recfield_delimiter;     
}

sub initIbrRec {
    $ibr_record_type .= $edr_recfield_delimiter;

    $ibr_service_poid = $dummyPoid . $edr_recfield_delimiter;
    $ibr_item_poid = $dummyPoid . $edr_recfield_delimiter;  

    $ibr_original_event_poid = $dummyPoid . $edr_recfield_delimiter;
    $ibr_pin_tax_locales .= $edr_recfield_delimiter;
    $ibr_pin_tax_supplier_id .= $edr_recfield_delimiter;
    $ibr_pin_provider_id .= $edr_recfield_delimiter;
    $ibr_pin_invoice_data .= $edr_recfield_delimiter;
    $ibr_number_of_pin_balance_impact_packets = ""; # no delimiter for last field in the rec.
}

sub finalizeIbrRec {
    $record_number += 1;
    
    $ibr_record_number = $record_number . $edr_recfield_delimiter;    
    $ibr_account_poid = $accountPoid . $edr_recfield_delimiter;  
    
}

sub initBalImpRec {
    $bal_record_type .= $edr_recfield_delimiter;

    $bal_pin_impact_category .= $edr_recfield_delimiter;
    $bal_pin_product_poid = $dummyPoid . $edr_recfield_delimiter;
    $bal_pin_gl_id .= $edr_recfield_delimiter;
    $bal_pin_tax_code .= $edr_recfield_delimiter;
    $bal_pin_rate_tag .= $edr_recfield_delimiter;
    $bal_pin_lineage .= $edr_recfield_delimiter;
    $bal_pin_node_location .= $edr_recfield_delimiter;
    $bal_pin_quantity .= $edr_recfield_delimiter;

    $bal_pin_discount = "0" . $edr_recfield_delimiter;
    $bal_pin_info_string = ""; # no delimiter for last field in the rec.
}

sub finalizeBalImpRec {
    $record_number += 1;
    
    $bal_record_number = $record_number . $edr_recfield_delimiter;    
    $bal_account_poid = $accountPoid . $edr_recfield_delimiter;  
    $bal_pin_resource_id = $k_resourceId . $edr_recfield_delimiter;   
    $bal_pin_amount = $rp_unUsedUnits . $edr_recfield_delimiter;     
    $bal_pin_amount_deferred = $rp_unUsedUnits . $edr_recfield_delimiter; # same value as amount
}

sub initTrailerRec {
    $record_number += 1;
    
    $t_record_type .= $edr_recfield_delimiter;
    $t_record_number = $record_number . $edr_recfield_delimiter;
    $t_sender .= $edr_recfield_delimiter;
    $t_recipient .= $edr_recfield_delimiter;
    $t_sequence_number .= $edr_recfield_delimiter;
    $t_origin_sequence_number .= $edr_recfield_delimiter;
    $t_total_number_of_records .= $edr_recfield_delimiter;
    $t_first_charging_start_timestamp .= $edr_recfield_delimiter;
    $t_first_charging_utc_time_offset .= $edr_recfield_delimiter;
    $t_last_charging_start_timestamp .= $edr_recfield_delimiter;
    $t_last_charging_utc_time_offset .= $edr_recfield_delimiter;
    $t_total_retail_charged_value .= $edr_recfield_delimiter;
    $t_total_wholesale_charged_value = ""; # no delimiter for last field in the rec.
}

sub exit_err {
    local ($errCode, $msg1, $msg2) = @_;
   
    select (STDOUT);
    print "$errCode : $msg1 : $msg2";
    
    #
    # Close the discount input file and the EDR output file.
    #
    close (DISCOUNT_FILE);
    close (EDR_FILE);
    exit( $errCode);
}
