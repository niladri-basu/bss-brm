#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
################################################################################
# Script name : td_cc_reverse
# This utilty does the follwing activities:
# 	- Reads Account_no and Transaction Id from input file 
#	- Check in BRM for the reversal already done or not against the tranx id
#	- Create an entry in the custom table for the reversal to be done
# Written by: Dev/Sukanya	Date: 20-Aug-2014 
# Revision date : 22.01.2015
################################################################################
use File::Copy;
use lib '.' ;
use pcmif;
use Sys::Hostname;
use File::Basename;
use File::Path;
use strict;
use warnings;
use Cwd;

sub process_records($);
sub reject_records($);
sub get_flist_fld_value($);
sub Lpad();

my $script = "TD_CC_REVERSE";
my $PIN_HOME;
my $INPUT_DIR;
my $REJ_DIR;
my $ARCHIVE_DIR;
my $LOG_DIR;
my $LOG_FILE;
my $file_date;
my $reason;
my $in_file;

my $template;
my $flags = 0;
my $in_flistp;
my $outb_flistp;
my $search_iflist;
my $search_oflist;
my @value;
#my $pay_transaction_id = "" ;
my $reject_no = 0;
my $processed_no = 0;
my $total_no = 0;
my $str;
my $len;
my $chr;
my $flag = 0;
my $rev_record;
my $account_obj;

my $account_no ="";
my $payment_id = "";
my $transaction_id = "";
my $service_id;
my $amount = 0;
my $pay_type;
my $trans_id = "";
my $p_transaction_id = "";
my $ser_transaction_id = "";
my $sub_transaction_id = ""; #Added for account_level payment reversal
my $trans_sub_trans_id = "";
#######################################
# Reading Configaration File
#######################################
print "-----Reading Config File------ \n";
print "Reading Configuration File \n\n";
my %ConfVarTable;
my $conf = "config.conf";

#######################################
#readConfigFile();
#######################################
if ( -e $conf )
{
   $PIN_HOME = `grep '^-' $conf | grep PIN_HOME | awk '{print \$NF}'`;
   $INPUT_DIR = `grep '^-' $conf | grep INPUT_DIR | awk '{print \$NF}'`;
   $ARCHIVE_DIR = `grep '^-' $conf | grep ARCHIVE_DIR | awk '{print \$NF}'`;
   $LOG_DIR = `grep '^-' $conf | grep LOG_DIR | awk '{print \$NF}'`;
   $REJ_DIR = `grep '^-' $conf | grep REJ_DIR | awk '{print \$NF}'`;
    chomp($PIN_HOME);
    chomp($INPUT_DIR);
    chomp($ARCHIVE_DIR);
    chomp($LOG_DIR);
    chomp($REJ_DIR);
}
else
{
    print "\n$script: $conf configuration file not found!\n\n";
    exit(1);
}

########################################
# Create log file
########################################
my ($dd, $mm, $yyyy) = (localtime)[3..5];
$mm=$mm+1;
$yyyy=$yyyy+1900;
my $date="$mm/$dd/$yyyy";

if (length $mm ne 2)
	{
	$mm=LPad($mm,2,0);
	}

if (length $dd ne 2)
	{
	$dd=LPad($dd,2,0);
	}

$file_date="$yyyy$mm$dd";

my $log_file = "cc_reverse_$file_date.log";
$log_file = "$PIN_HOME"."$LOG_DIR"."/$log_file";
open(LOG_FILE,">>$log_file") or die "Could not open log file";

print(LOG_FILE "\n\n#####################################\n");
print(LOG_FILE "Starting td_cc_reverse at $date");
print(LOG_FILE "\n#####################################\n");


######################################
# Get context and create error buffer
######################################
my $ebufp = pcmif::pcm_perl_new_ebuf();
my $db_no="0.0.0.1";
my $pcm_ctxp = pcmif::pcm_perl_connect($db_no, $ebufp);

if (pcmif::pcm_perl_is_err($ebufp)) {
        print LOG_FILE "FAILED to Connect to Infranet\n";
        pcmif::pcm_perl_print_ebuf($ebufp);
        print "\nLog File $log_file\n\n";
        close(LOG_FILE);
        exit(1);
}
my $DB_NO = $db_no;
###################################
# Process the files in input folder
###################################
my $input_dir = "$PIN_HOME"."$INPUT_DIR";
opendir(INPUT_DIR, $input_dir) or die "Could not open the input directory";
my $file;
my $firstline =1;
while ($file = readdir(INPUT_DIR))
{
    $in_file="$input_dir/$file";
    # Skip directories and swap files
    next if(-d $in_file || $in_file =~ /\/\./);

    # Open input file
    open(IN_FILE,"<$in_file") or die ("Could not open input file");
    print(LOG_FILE "\nProcessing $file\n");
    print LOG_FILE "Reading the input file $file\n";

    # Read all the records from the input file into array
    my @all_rev_records = <IN_FILE>;
    my $arr_size = @all_rev_records;
    my $count=1;
    my $loop=$arr_size-1;
    my @valid_record;
    foreach my $count (1 .. $loop)  
    {
	$valid_record[$count-1] = $all_rev_records[$count];
#print ("valid record $valid_record\n");
	$count++;
    } 
    foreach my $rev_record (@valid_record)
    {
        # Process each record
        process_records($rev_record);
	 #print(LOG_FILE "\nTotal no of records Processed :  $total_no\n");
    }
    $processed_no = $total_no - $reject_no;

    print(LOG_FILE "Total no of records in flie :  $total_no\n");
    print(LOG_FILE "Total no of records Processed :  $processed_no\n");
    print(LOG_FILE "Total no of records Rejected :  $reject_no\n");
    # Close input file
    close(IN_FILE);
    $total_no = 0;
    $reject_no = 0;
    # Archive the input file
    my $archive_dir = "$PIN_HOME"."$ARCHIVE_DIR";
    move("$in_file","$archive_dir") or die ("Could not archive the input file");
    print(LOG_FILE "Archived $file\n");
}

# Close input directory
closedir(INPUT_DIR);

# Close the context
pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);


##########################################
# Subroutine to process reverse records
##########################################
sub process_records($)
{
#print LOG_FILE "\nin process_records()";

###########################################
#Reading individual records
###########################################
	$rev_record = $_[0];
    	$total_no = $total_no +1;
        chomp($rev_record);
	print ("Record-> $rev_record\n");
	# Validate the record-  account_no  payment_id   transaction_id   service_id
        if ($rev_record =~ /^([\d\w]+[^, ]*),([^,]*),(.*),([^,]*)$/)
	{
	#	$total_no = $total_no + 1; 	
        	($account_no,$payment_id,$transaction_id,$service_id)=($1,$2,$3,$4);
        	chomp($payment_id);
		chomp($transaction_id);
		chomp($service_id);
		chomp($account_no);

#############################################
#Search account poid for the given account_no
$account_obj = get_account_poid("$account_no");
#print "\nAccount_obj===== $account_obj\n";
#############################################
		#CASE 1:
		if (( $transaction_id eq '') && ($payment_id eq '' )){
print "CASE 1: Both trans_id and payment id is not valid\n";		
			chomp($rev_record);
			$rev_record = "$in_file"." : $rev_record";
			chomp($rev_record);
		        $rev_record = "$rev_record".",Both Payment id and transaction id not valid";
			reject_records($rev_record);

		}
		#CASE 2:
		#####################################################
		#if both trans_id and payment id is not null 
		#search event by using account_no, trns_id,payment_id
		#####################################################
		 if (($transaction_id ne '') && (  $payment_id ne '')){
print "CASE 2: Both trans_id and payment id is not null\n";			
		
			$trans_sub_trans_id = get_trans_sub_trans_id($account_no, $payment_id);
			
			if($transaction_id eq $trans_sub_trans_id)
			{
				print "Validation: OK\n";
			
				$sub_transaction_id = check_recycle_payment($account_obj, $transaction_id);

				if($sub_transaction_id eq ''){
					print "sub_transaction_id is null, go for direct reversal case\n";
					$amount = search_amount_trans_id($account_no, $transaction_id);
					$pay_type = search_pay_type($account_no, $transaction_id);
#print "Amount => $amount\n";
					if ($amount gt 0) {
#print "Amount ======> $amount\n";
						create_recharge_object($account_no, $transaction_id, $service_id, $amount,$pay_type);
					}
				}
                        	else{
print "Recycled payment case\n";
                                	$amount = search_amount_trans_id($account_no, $sub_transaction_id);
					$pay_type = search_pay_type($account_no, $sub_transaction_id);
#print "Amount => $amount\n";
                                	if ($amount gt 0) {
#print "Amount ======> $amount\n";
                                        	create_recharge_object($account_no, $sub_transaction_id, $service_id, $amount,$pay_type);
                                	}

                        	}
			}
		 }
	
		#CASE 3:
		#####################################################
		#if trans_id is not null 
		#search event by using account_no, trns_id
		#####################################################
		 if (($transaction_id ne '') && (  $payment_id eq '')){
print "CASE 3: Trans_id is not null\n";			
			$sub_transaction_id = check_recycle_payment($account_obj, $transaction_id);
#print "sub_transaction_id:::  $sub_transaction_id";
			if($sub_transaction_id eq ''){
				print "sub_transaction_id is null, go for direct reversal case\n";
				$amount = search_amount_trans_id($account_no, $transaction_id);
                                $pay_type = search_pay_type($account_no, $transaction_id);
				print "\n pay type $pay_type \n";
#print "Amount => $amount\n";
				if ($amount gt 0) {
#print "Amount ======> $amount\n";
					create_recharge_object($account_no, $transaction_id, $service_id, $amount,$pay_type);
				}
			}
			else{
print "Recycled payment case\n";
				$amount = search_amount_trans_id($account_no, $sub_transaction_id);
                                $pay_type = search_pay_type($account_no, $sub_transaction_id);
#print "Amount => $amount\n";
                                if ($amount gt 0) {
#print "Amount ======> $amount\n";
                                        create_recharge_object($account_no, $sub_transaction_id, $service_id, $amount,$pay_type);
                                }

			}
		 }

		#CASE 4:
		#####################################################
		#if payment_id is not null 
		#search event by using account_no, payment_id
		#####################################################

		 if (($transaction_id eq '') && (  $payment_id ne '')){
print "CASE 4: Payment id is not null\n";
			#find the trans_id for direct pymt reversal or sub_trans_id as trans_id for 
			# recycle payment reversal
			$trans_sub_trans_id = get_trans_sub_trans_id($account_no, $payment_id);

#print "CASE 4:$trans_sub_trans_id\n";
			$sub_transaction_id = check_recycle_payment($account_obj, $trans_sub_trans_id);
			if($sub_transaction_id eq ''){
				print "sub_transaction_id is null, go for direct reversal case\n";
				my $amount = search_amount_trans_id($account_no, $trans_sub_trans_id);
                                $pay_type = search_pay_type($account_no, $trans_sub_trans_id);
#print "Amount => $amount\n";
				if ($amount gt 0) {
#print "Amount ======> $amount\n";
					create_recharge_object($account_no, $trans_sub_trans_id, $service_id, $amount,$pay_type);
				}
			}
                        else{
print "Recycled payment case\n";                               
 				$amount = search_amount_trans_id($account_no, $sub_transaction_id);
                                $pay_type = search_pay_type($account_no, $sub_transaction_id);
#print "Amount => $amount\n";
                                if ($amount gt 0) {
#print "Amount ======> $amount\n";
                                        create_recharge_object($account_no, $sub_transaction_id, $service_id, $amount,$pay_type);
                                }

                        }


		 }

################################
	}else # validation if ends
    	{
		$reason = "Invalid record";
		chomp($rev_record);
		$rev_record = "$in_file"." : $rev_record";
                chomp($rev_record);
		$rev_record = "$rev_record".",Invalid record";
		chomp($rev_record);	
        	print LOG_FILE "Invalid record --> $rev_record";
		reject_records($rev_record);

    	}

}#end of process
##########################################
# Subroutine to process rejected records
##########################################
sub reject_records($)
{
	$reject_no = $reject_no + 1;
        my $rev_record = $_[0];
        my $rej_file = "cc_reverse_$file_date.rej";
        $rej_file = "$PIN_HOME"."$REJ_DIR"."/$rej_file";
        open(REJ_FILE,">> $rej_file") or die "Could not open reject file";
	print REJ_FILE "\n$rev_record";
	
}

###########################################
# Subroutine to get field value from flist
###########################################
sub get_flist_fld_value($)
{
         my $out_flist_string_row = shift;
         my @return_value = split(/\s/, $out_flist_string_row);
         my $temp_value = $return_value[$#return_value];
         if ($temp_value =~ /\"/){
                my @temp_array = split(/\"/, $temp_value);
                $temp_value = $temp_array[1];
         }
        my $ret_flist_fld_value = $temp_value;
}
###########################################
# Subroutine to get field value from flist
###########################################
sub get_flist_fld_value_1
{
   my ( $fld, @result );
   $fld = $_[0];
         @result = split /] /, $fld;
         return $result[1];
}

###########################################
# Subroutine to get poid from flist
###########################################
sub get_flist_poid_value($)
{
         my $out_flist_string_row = shift;
		 my @return_value = split(/\s/, $out_flist_string_row);
		 my $temp_value = $return_value[$#return_value -1];
		 if ($temp_value =~ /\"/){
                	my @temp_array = split(/\"/, $temp_value);
                	$temp_value = $temp_array[0];
         	}
         my $ret_flist_fld_value = $temp_value;
}
###########################################
# Subroutine to get Month value in 2 digit
###########################################
sub LPad 
{
	($str, $len, $chr) = @_;
	$chr = "0" unless (defined($chr));
	return substr(($chr x ($len - length $str)).$str, 0, $len);
} 

###########################################
# Subroutine to get account poid
###########################################
sub get_account_poid
{
	$account_no = $_[0];
			$template = "select X from /account where F1 = V1 ";

                        $search_iflist=<<"XXX";
                        0 PIN_FLD_POID        POID [0] $DB_NO /search -1 0
                        0 PIN_FLD_FLAGS       INT [0] 256
                        0 PIN_FLD_TEMPLATE     STR [0] "$template"
                        0 PIN_FLD_RESULTS    ARRAY [0] allocated 1, used 1
                        1        PIN_FLD_POID          POID [0] NULL
                        0 PIN_FLD_ARGS                ARRAY [1] allocated 1, used 1
						1     PIN_FLD_ACCOUNT_NO        STR [0] "$account_no"
XXX

			$in_flistp = pcmif::pin_perl_str_to_flist($search_iflist,$DB_NO,$ebufp);
	                $outb_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_SEARCH",$flags, $in_flistp, $ebufp);
       
                	$search_oflist = pcmif::pin_perl_flist_to_str($outb_flistp, $ebufp);

				@value = split(/\n/, $search_oflist);
				foreach my $val_array_element(@value)
				{
					chomp($val_array_element);
					if ($val_array_element=~ /account/i)
					{
						$account_obj = get_flist_poid_value($val_array_element);
					}

				}
			return $account_obj;
}
###########################################
# Subroutine to check_recycle_payment object
###########################################
sub check_recycle_payment
{
			my ($account_obj, $transaction_id) = @_;
#print "check_recycle_payment transaction_id: $transaction_id\n";
 			
			$in_flistp=<<"XXX";
			0 PIN_FLD_POID           POID [0] $DB_NO /account $account_obj 0
			0  PIN_FLD_PROGRAM_NAME    STR [0] "Payment reverse"
			0 PIN_FLD_TRANS_ID        STR [0] "$transaction_id"
			0 PIN_FLD_RESULTS       ARRAY [0] allocated 20, used 2
			1     PIN_FLD_POID           POID [0] NULL poid pointer
			1     PIN_FLD_PAYMENT      SUBSTRUCT [0] allocated 20, used 2
			2         PIN_FLD_TRANS_ID        STR [0] NULL str ptr
			2         PIN_FLD_PAY_TYPE       ENUM [0] 0
XXX
		
#print "check_recycle_payment input: $in_flistp\n";		
        		my $i_flistp = pcmif::pin_perl_str_to_flist($in_flistp,$DB_NO,$ebufp);
						
        		$outb_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_PYMT_RECYCLED_PAYMENTS_SEARCH",$flags, $i_flistp, $ebufp);
					if( pcmif::pcm_perl_is_err($ebufp) )
					{	
							pcmif::pcm_perl_print_ebuf($ebufp);
							pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
							print "\nLog File $log_file\n\n";
							close(LOG_FILE);
							close(IN_FILE);
							closedir(INPUT_DIR);
							exit(1);
					}
	        
			$search_oflist = pcmif::pin_perl_flist_to_str($outb_flistp, $ebufp);
#print "check_recycle_payment output: $search_oflist\n";
				
				@value = split(/\n/, $search_oflist);
				my $sub_trans_id = "";
        	        foreach my $val_array_element(@value)
			{
                		chomp($val_array_element);
						
 	               			if ($val_array_element=~ /PIN_FLD_SUB_TRANS_ID/i)
	                       	{
                                	$sub_trans_id = get_flist_fld_value($val_array_element);
                       		}

			}#loop ends

#print "\n ---->> $sub_trans_id \n";
			return $sub_trans_id;
}

###########################################
# Subroutine to trans_id or sub_trans_id
###########################################
sub get_trans_sub_trans_id
{
	($account_no, $payment_id) = @_;


        $transaction_id = "";
        my $s_trans_id = "";

	$template = "select X from /event/billing/payment 1, /item/payment 2 where  2.F1 = V1 and 1.F2 = 2.F3 and 1.F4 = V4 ";

        my $search_flist=<<"XXX";
                        0 PIN_FLD_POID        POID [0] $DB_NO /search -1 0
                        0 PIN_FLD_FLAGS       INT [0] 256
                        0 PIN_FLD_TEMPLATE     STR [0] "$template"
                        0 PIN_FLD_RESULTS    ARRAY [0] allocated 1, used 1
                        1        PIN_FLD_PAYMENT          SUBSTRUCT [0] allocated 1, used 1
                        2                PIN_FLD_TRANS_ID   STR [0] NULL
                        2                PIN_FLD_SUB_TRANS_ID   STR [0] NULL
                        0 PIN_FLD_ARGS                     ARRAY [1] allocated 1, used 1
			1     PIN_FLD_ITEM_NO                STR [0] "$payment_id"
			0 PIN_FLD_ARGS                     ARRAY [2] allocated 1, used 1
			1     PIN_FLD_ITEM_OBJ              POID [0] NULL
			0 PIN_FLD_ARGS                     ARRAY [3] allocated 1, used 1
			1     PIN_FLD_POID                  POID [0] NULL
			0 PIN_FLD_ARGS                     ARRAY [4] allocated 1, used 1
			1        PIN_FLD_PAYMENT          SUBSTRUCT [0] allocated 1, used 1
			2                PIN_FLD_ACCOUNT_NO   STR [0] "$account_no"
XXX

#print "Input result------------>\n $search_flist\n";
                        $in_flistp = pcmif::pin_perl_str_to_flist($search_flist,$DB_NO,$ebufp);
	                $outb_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_SEARCH",$flags, $in_flistp, $ebufp);
	 		if(pcmif::pcm_perl_is_err($ebufp))
                	{
	                        pcmif::pcm_perl_print_ebuf($ebufp);
        	                pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
                        	print "\nLog File $log_file\n\n";
	                        close(LOG_FILE);
        	                close(IN_FILE);
                	        closedir(INPUT_DIR);
                        	exit(1);
                	}
           		$search_oflist = pcmif::pin_perl_flist_to_str($outb_flistp, $ebufp);

#print "Output result------------> $search_oflist\n";	
	 		@value = split(/\n/, $search_oflist);

				foreach my $val_array_element(@value)
				{
					chomp($val_array_element);

					if ($val_array_element=~ /PIN_FLD_TRANS_ID/i)
					{
						$transaction_id = get_flist_fld_value($val_array_element);
					}
					if ($val_array_element=~ /PIN_FLD_SUB_TRANS_ID/i)
					{
						$s_trans_id = get_flist_fld_value_1($val_array_element);
					}
				}

#print "trans :: $transaction_id\n";
#print "Sub ::::: $s_trans_id\n";
				if (($transaction_id ne '') && ($s_trans_id ne '""'))
				{
					$s_trans_id = get_flist_fld_value($s_trans_id);
					$transaction_id = $s_trans_id;
				}
				
				if(($transaction_id ne '') && ($s_trans_id eq '""'))
				{
					$transaction_id = $transaction_id;
				}			

return $transaction_id;
}

###########################################
# Subroutine to search /event/billing/payment
# based on trans_id, account_no
###########################################
sub search_amount_trans_id
{
		($account_no, $trans_id) = @_;
			
			$template = "select X from /event/billing/payment where F1 = V1 and F2 = V2 ";

		        $search_iflist=<<"XXX";
       			0 PIN_FLD_POID        POID [0] $DB_NO /search -1 0
       			0 PIN_FLD_FLAGS       INT [0] 256
	       		0 PIN_FLD_TEMPLATE     STR [0] "$template"
	        	0 PIN_FLD_RESULTS    ARRAY [0] allocated 1, used 1
		        1        PIN_FLD_PAYMENT          SUBSTRUCT [0] allocated 1, used 1
	        	2                PIN_FLD_TRANS_ID   STR [0] NULL
                        2                PIN_FLD_AMOUNT   DECIMAL [0] NULL
	        	0 PIN_FLD_ARGS                     ARRAY [1] allocated 1, used 1
		        1       PIN_FLD_PAYMENT          SUBSTRUCT [0] allocated 1, used 1
        		2                PIN_FLD_TRANS_ID           STR [0] "$trans_id"
	       		0 PIN_FLD_ARGS                     ARRAY [2] allocated 1, used 1
				1       PIN_FLD_PAYMENT          SUBSTRUCT [0] allocated 1, used 1
        		2		        PIN_FLD_ACCOUNT_NO             STR [0] "$account_no"
XXX

#print "input flist $search_iflist\n";
         		$in_flistp = pcmif::pin_perl_str_to_flist($search_iflist,$DB_NO,$ebufp);

	                $outb_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_SEARCH",$flags, $in_flistp, $ebufp);
                	if( pcmif::pcm_perl_is_err($ebufp) )
        	        {
	                	pcmif::pcm_perl_print_ebuf($ebufp);
                        	pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
                	        print "\nLog File $log_file\n\n";
        	                close(LOG_FILE);
	                        close(IN_FILE);
                        	closedir(INPUT_DIR);
                	        exit(1);
        	        }
	                $search_oflist = pcmif::pin_perl_flist_to_str($outb_flistp, $ebufp);

			@value = split(/\n/, $search_oflist);
					my $amt = 0;
        	        foreach my $val_array_element(@value)
					{
                		chomp($val_array_element);
						
        	               	if ($val_array_element=~ /PIN_FLD_TRANS_ID/i)
	                       	{
                                	my $ser_transaction_id = get_flist_fld_value($val_array_element);
                       		}
	                        if ($val_array_element=~ /PIN_FLD_AMOUNT/i)
                                {
                                       $amt = get_flist_fld_value($val_array_element);
                                }

					}#loop ends
return $amt;
}
###########################################
# Subroutine to search /event/billing/payment
# based on trans_id, account_no
###########################################
sub search_pay_type
{
                ($account_no, $trans_id) = @_;
print "In paytype search\n";
                        $template = "select X from /event/billing/payment where F1 = V1 and F2 = V2 ";

                        $search_iflist=<<"XXX";
                        0 PIN_FLD_POID        POID [0] $DB_NO /search -1 0
                        0 PIN_FLD_FLAGS       INT [0] 256
                        0 PIN_FLD_TEMPLATE     STR [0] "$template"
                        0 PIN_FLD_RESULTS    ARRAY [0] allocated 1, used 1
                        1        PIN_FLD_PAYMENT          SUBSTRUCT [0] allocated 1, used 1
                        2                PIN_FLD_PAY_TYPE   ENUM [0] 0
                        0 PIN_FLD_ARGS                     ARRAY [1] allocated 1, used 1
                        1       PIN_FLD_PAYMENT          SUBSTRUCT [0] allocated 1, used 1
                        2                PIN_FLD_TRANS_ID           STR [0] "$trans_id"
                        0 PIN_FLD_ARGS                     ARRAY [2] allocated 1, used 1
                                1       PIN_FLD_PAYMENT          SUBSTRUCT [0] allocated 1, used 1
                        2                       PIN_FLD_ACCOUNT_NO             STR [0] "$account_no"
XXX

                        $in_flistp = pcmif::pin_perl_str_to_flist($search_iflist,$DB_NO,$ebufp);

                        $outb_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_SEARCH",$flags, $in_flistp, $ebufp);
                        if( pcmif::pcm_perl_is_err($ebufp) )
                        {
                                pcmif::pcm_perl_print_ebuf($ebufp);
                                pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
                                print "\nLog File $log_file\n\n";
                                close(LOG_FILE);
                                close(IN_FILE);
                                closedir(INPUT_DIR);
                                exit(1);
                        }
                        $search_oflist = pcmif::pin_perl_flist_to_str($outb_flistp, $ebufp);
        #                print "\nsearch out: $search_oflist\n\n";
                        @value = split(/\n/, $search_oflist);
                        foreach my $val_array_element(@value)
                                        {
                                chomp($val_array_element);
                                if ($val_array_element=~ /PIN_FLD_PAY_TYPE/i)
                                {
                                       $pay_type = get_flist_fld_value($val_array_element);
                                }

                                        }#loop ends
return $pay_type;
}

###########################################
# Subroutine to create object
###########################################
sub create_recharge_object
{	
	
	my ($account_no, $trans_id, $service_id, $amount,$pay_type)= @_;
#	print "Transaction _id::: $pay_type";
	my $type;
        if($pay_type eq '10020'){
                $type = 'CCA';
        }
        if($pay_type eq '10019'){
                $type = 'POLI';
        }
	if($pay_type eq '10003'){
		$type = 'CCA';
	}
        if($pay_type eq '10005'){
                $type = 'DDA';
        }
       # if($pay_type eq '10013'){
       #         $type = 'EFT';
       # }
	#####################################
	#Check if entry exists in custom
	#table; if not duplicate
	#Create obj in custom table 
	#################################### 
		    $p_transaction_id = "";
	            $template = "select X from /td_payment_refund_reverse where F1 = V1 and F2 = V2 ";
        	    my $search_in_flist=<<"XXX";
                        	0 PIN_FLD_POID        POID [0] $DB_NO /search -1 0
                	        0 PIN_FLD_FLAGS       INT [0] 256
        	                0 PIN_FLD_TEMPLATE     STR [0] "$template"
	                        0 PIN_FLD_RESULTS    ARRAY [0] allocated 1, used 1
                        	1      PIN_FLD_TRANS_ID    STR [0]
                	        0 PIN_FLD_ARGS       ARRAY [1] allocated 1, used 1
        	                1       PIN_FLD_TRANS_ID      STR [0] "$trans_id"
	                        0 PIN_FLD_ARGS       ARRAY [2] allocated 1, used 1
	                        1       PIN_FLD_TRACKING_ID      STR [0] "Reversal"
XXX
	                      my $in_flistp = pcmif::pin_perl_str_to_flist($search_in_flist,$DB_NO,$ebufp);

                	      my $out_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_SEARCH",$flags, $in_flistp, $ebufp);

        	              if( pcmif::pcm_perl_is_err($ebufp) )
	                        {
                                	pcmif::pcm_perl_print_ebuf($ebufp);
                        	        pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
                	                print "\nLog File $log_file\n\n";
        	                        close(LOG_FILE);
	                                close(IN_FILE);
                                	closedir(INPUT_DIR);
                        	        exit(1);
                	        }
 			      $search_oflist = pcmif::pin_perl_flist_to_str($out_flistp, $ebufp);
#print "output flist $search_oflist\n";
		                @value = split(/\n/, $search_oflist);
        	        	foreach my $val_array_element(@value)
						{
        	        	        chomp($val_array_element);
	                        	if ($val_array_element=~ /PIN_FLD_TRANS_ID/i)
                        		{
                        	        	$p_transaction_id = get_flist_fld_value($val_array_element);
#print "p_transaction_id:: $p_transaction_id\n";
                	        	}
        	        	}

	            if($p_transaction_id ne '')
    	            {			#my @valid_record;
	                	        chomp($rev_record);
        		                $rev_record = "$in_file"." : $rev_record";
        	        	        chomp($rev_record);
	                        	$rev_record = "$rev_record"." : Duplicate entry";
                        		reject_records($rev_record);
print "Duplictae record: Rejected\n";
        	    }
	   	    else{
#print "\n Craeting object \n";
				##########################################
				#Create /td_payment_refund_reverse object 
				#change made for bss-transformation1649 line no 6 in flist
				##########################################
					my $cus_in_flistp=<<"XXX";
	        		         0 PIN_FLD_POID                 POID [0] $DB_NO /td_payment_refund_reverse -1 0
                			 0 PIN_FLD_TRACKING_ID           STR [0] "Reversal"
            				 0 PIN_FLD_ACCOUNT_NO            STR [0] "$account_no"
			                 0 PIN_FLD_TRANS_ID              STR [0] "$trans_id"
        			         0 PIN_FLD_DEFAULT               STR [0] "N"
					 0 PIN_FLD_PAYMENT_EVENT_TYPE    STR [0] "$type"
	                		 0 PIN_FLD_SERVICE_ID            STR [0] "$service_id"
					 0 PIN_FLD_AMOUNT   		 DECIMAL [0] $amount
XXX
                 			if( pcmif::pcm_perl_is_err($ebufp) )
                 			{
                	        		pcmif::pcm_perl_print_ebuf($ebufp);
		                            	pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
	        	                    	print "\nLog File $log_file\n\n";
                	            		close(LOG_FILE);
                        		    	close(IN_FILE);
                        	    		closedir(INPUT_DIR);
	        	                   	exit(1);
        		          	}
#print "------------ $cus_in_flistp";
					my $cus_flistp = pcmif::pin_perl_str_to_flist($cus_in_flistp,$DB_NO, $ebufp);
	        		        my $cus_out_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_CREATE_OBJ",$flags, $cus_flistp, $ebufp);
        		        	
							$search_oflist = pcmif::pin_perl_flist_to_str($cus_out_flistp, $ebufp);
							
							if( pcmif::pcm_perl_is_err($ebufp) )
        	        	  	{
	                       			 pcmif::pcm_perl_print_ebuf($ebufp);
                            			 pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
	        		                 print "\nLog File $log_file\n\n";
        		        	         close(LOG_FILE);
        	        	        	 close(IN_FILE);
	                                      	 closedir(INPUT_DIR);
	                        		 exit(1);
            	       		}

				} # if else ends
}
