#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
################################################################################
# Script name : td_bulk_adjustment
# This utilty does the follwing activities:
#       - Reads Account_no ,Balance_group, amount, flag, reason_code_domain
#	  reason_code and description from input file
#       - Checks the flag is Credit or Debit and prepares the input file for 
#	  OOB application pin_apply_bulk_adjustment
#       - Passes the adjustment in the account through the MTA
# Written by: Sukanya      Date: 20-Aug-2014
# Revision date : 29.01.2015
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

#my $ebufp = pcmif::pcm_perl_new_ebuf();
#my $db_no='0.0.0.1';


my $script = "TD_BULK_ADJUSTMENT";
my $INPUT_DIR;
my $INPUT_FINAL_DIR;
my $ARCHIVE_DIR;
my $LOG_DIR;
my $LOG_FILE;
my $REJ_DIR;
my $ADJ_DIR;
my $in_file;
my $PIN_HOME;
my $reason;
my $str;
my $len;
my $chr;

sub display_date($);
sub process_records($);
sub reject_records($);
sub Lpad();

#########################################
#Check if the script is already running##
#########################################
my $cmd = q( id | awk -F"\(" '{print $2}' | awk -F"\)" '{print $1}');
my $USER = `$cmd`;

my $count = `ps -ef | grep "$USER" | grep "td_bulk_adjustment.pl" | grep -v grep | wc -l`;

if ( $count > 1 )
{
	print "\nProcess already running... ";
	exit (1);
}
print "Starting the process\n\n";
#######################################
# Reading Configaration File
#######################################
print "Reading Configuration File \n\n";
my %ConfVarTable;
my $conf = "config.conf";
#readConfigFile();

if ( -e $conf )
{
   $PIN_HOME = `grep '^-' $conf | grep PIN_HOME | awk '{print \$NF}'`;
   $INPUT_DIR = `grep '^-' $conf | grep INPUT_DIR | awk '{print \$NF}'`;
   $ARCHIVE_DIR = `grep '^-' $conf | grep ARCHIVE_DIR | awk '{print \$NF}'`;
   $LOG_DIR = `grep '^-' $conf | grep LOG_DIR | awk '{print \$NF}'`;
   $ADJ_DIR = `grep '^-' $conf | grep ADJ_DIR | awk '{print \$NF}'`;
   $REJ_DIR = `grep '^-' $conf | grep REJ_DIR | awk '{print \$NF}'`;
   chomp($INPUT_DIR);
   chomp($ARCHIVE_DIR);
   chomp($LOG_DIR);
   chomp($ADJ_DIR);
   chomp($REJ_DIR);
   chomp($PIN_HOME);
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

my $file_date="$yyyy$mm$dd";
print "$file_date \n";
my $log_file = "bulk_adjustment_$file_date.log";
$log_file = "$PIN_HOME"."$LOG_DIR"."/$log_file";
open(LOG_FILE,">> $log_file") or die "Could not open log file";

#print(LOG_FILE "Starting bulk_adjustment at $date");
display_date("started");

# Process the files in input folder
###################################
my $input_dir = "$PIN_HOME"."$INPUT_DIR";
opendir(INPUT_DIR, $input_dir) or die "Could not open the input directory";
my $file;

my $adj_file="pin_initial_bulk_adjust_$file_date.csv";
$adj_file = "$PIN_HOME"."$ADJ_DIR"."/$adj_file";
open(ADJ_FILE,">$adj_file") or die "Could not open initial bulk adjustment file";
close(ADJ_FILE);

#my $in_final_file = "bulk_adjustment_final_input_$file_date.csv";
while ($file = readdir(INPUT_DIR))
{
    $in_file="$input_dir/$file";

    # Skip directories and swap files
    next if(-d $in_file || $in_file =~ /\/\./);

    # Open input file
    open(IN_FILE,"<$in_file") or die ("Could not open input file");
    print("\nProcessing $in_file\n");
    print LOG_FILE "\nReading the input file $in_file\n";

    # Read all the records from the input file into array
    my @all_adj_records = <IN_FILE>;
    foreach my $adj_record (@all_adj_records)
    {
        # Process each record
        process_records($adj_record);
    }

    # Close input file
    close(IN_FILE);

    # Archive the input file
    my $archive_dir = "$PIN_HOME"."$ARCHIVE_DIR";
    move("$in_file","$archive_dir") or die ("Could not archive the input file");
    print("Archived $in_file\n");

}

# Close input directory
closedir(INPUT_DIR);



if( -s $adj_file )
{
    print "\n\nLoading adjustment file...\n";
 #   print "pin_apply_bulk_adjustment -v -f $adj_file\n";
    print LOG_FILE "\nLoading the adjustment file\n";
    print LOG_FILE "pin_apply_bulk_adjustment -v -f $adj_file\n";

    `pin_apply_bulk_adjustment -v -f $adj_file >> $log_file 2>&1`;

    if( $? != 0 )
    {
        print LOG_FILE "Utility pin_apply_bulk_adjustment failed\n";
    }
    else
    {
       # print "Completed\n";
        print LOG_FILE "Completed\n";
    }

}
else
{
   # print "\n\nAdjustment file is empty. Exiting.\n";
    print LOG_FILE "\n\nAdjustment file $adj_file is empty. Exiting.\n";
}

display_date("finished");

# Print log file name
print "\nLog File $log_file\n\n";
close(LOG_FILE);



sub display_date($){
    print LOG_FILE "\n";
    print LOG_FILE "#" x 60;
    print LOG_FILE "\n$script $_[0] at ".`date`;
    print LOG_FILE "#" x 60;
    print LOG_FILE "\n";

    print "\n";
    print "#" x 60;
    print "\n$script $_[0] at ".`date`;
    print "#" x 60;
    print "\n";
}

##########################################
# Subroutine to process adjustment records
##########################################
sub process_records($)
{
	my $adj_record = $_[0];

	if ($adj_record =~ /^([\d\w]+[^, ]*),([+-]?\d+[^, ]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),([^,]*),(.*)$/)
	
	{

	        my ($acct_poid ,$bal_poid ,$amount ,$flag ,$tax_flag,$tax_code,$tax_supplier_ID,$reasom_code_domain ,$reason_code ,$resource, $end_date ,$description)=($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12);
		
		my $account_poid = "0.0.0.1 \/account $acct_poid 0";
		my $bal_grp_poid = "0.0.0.1 \/balance_group $bal_poid 0";

		#my $resource = 554 ;

		if (( $bal_poid == 0) || ( $bal_poid eq ''))
		{
                	chomp($adj_record);
	                $adj_record = "$in_file"." : $adj_record";
        	        chomp($adj_record);
                	$adj_record = "$adj_record".",Balance group not passed!";
	                chomp($adj_record);
                	reject_records($adj_record);

		}
	        
		if (( $acct_poid == 0)|| ( $acct_poid eq ''))
        	{
                	chomp($adj_record);
	                $adj_record = "$in_file"." : $adj_record";
        	        chomp($adj_record);
                	$adj_record = "$adj_record".",Account not passed!";
	                chomp($adj_record);
                	reject_records($adj_record);

        	}
               
		if ((( $reasom_code_domain ne '') && ($reason_code eq '')) || (( $reasom_code_domain eq '') && ($reason_code ne '')))
                {
                        chomp($adj_record);
                        $adj_record = "$in_file"." : $adj_record";
                        chomp($adj_record);
                        $adj_record = "$adj_record".",Reason_code_domain and Reason should be both present or absent!";
                        chomp($adj_record);
                        reject_records($adj_record);

                }

		if($end_date eq '')
		{
			$end_date = $date;
		}
		
		if ( $flag eq 'Credit')
	    	{
      		  	my $adj_amount = -$amount;
	         	
                  	open(ADJ_FILE,">>$adj_file");
                  	print ADJ_FILE "$account_poid,$adj_amount,$bal_grp_poid,$tax_flag,$tax_code,$tax_supplier_ID,$resource,$end_date,$reasom_code_domain,$reason_code,\"$description\"\n";

		  	close(ADJ_FILE);
	    	}
	    	elsif ( $flag eq 'Debit')
	    	{
		 	my $adj_amount = $amount;

	                  open(ADJ_FILE,">>$adj_file");
        	          print "$account_poid,$adj_amount,$bal_grp_poid,$tax_flag,$tax_code,$tax_supplier_ID,$resource,$end_date,$reasom_code_domain,$reason_code,\"$description\"\n";
        	          print ADJ_FILE "$account_poid,$adj_amount,$bal_grp_poid,$tax_flag,$tax_code,$tax_supplier_ID,$resource,$end_date,$reasom_code_domain,$reason_code,\"$description\"\n";

		  	  close(ADJ_FILE);
            	}
	    	else
		{
		#	print LOG_FILE "Credit or Debit flag not available!";
		        chomp($adj_record);
		        $adj_record = "$in_file"." : $adj_record";
		        chomp($adj_record);
		        $adj_record = "$adj_record".",Credit or Debit flag not available!";
		        chomp($adj_record);
		        reject_records($adj_record);
		}

	   
    }
    else
    {
	#Validation failed        
        chomp($adj_record);
        $adj_record = "$in_file"." : $adj_record";
        chomp($adj_record);
        $adj_record = "$adj_record".",Invalid record";
        chomp($adj_record);
        reject_records($adj_record);
    }

}
##########################################
# Subroutine to process rejected records
##########################################
sub reject_records($)
{
        my $adj_record = $_[0];
        my $rej_file = "Bulk_adjustment_$file_date.rej";
        $rej_file = "$PIN_HOME"."$REJ_DIR"."/$rej_file";
	print "\n$rej_file\n";
        open(REJ_FILE,">> $rej_file") or die "Could not open reject file";
        print REJ_FILE "\n$adj_record";

}
###############################################
# Subroutine to process month number in 2 digit
###############################################

sub LPad
{
        ($str, $len, $chr) = @_;
        $chr = "0" unless (defined($chr));
        return substr(($chr x ($len - length $str)).$str, 0, $len);
}
