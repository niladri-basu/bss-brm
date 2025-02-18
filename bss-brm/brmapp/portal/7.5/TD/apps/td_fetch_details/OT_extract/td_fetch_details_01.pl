#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# Author :Akshay Bomale
# Date   : 31-March-2021
#
# Wrapper script for Fetch_details_gl.sh
#=============================================================
#require "login.cfg";
#SQLPLUS= "sqlplus";

$PIN_HOME="/brmapp/portal/7.5";
#sub find_dom();
$FETCH_LOG_DIR = "$PIN_HOME/TD/apps/td_fetch_details/LOG_DIR";
$FETCH_EVENT_OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/event_out";
$FETCH_PAY_EVENT_OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/pay_event_out";
$FETCH_EVENT_ZERO_OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/event_zero_out";
$OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/OUT_DIR";
$ARCHIVE_DIR = "$PIN_HOME/TD/apps/td_fetch_details/ARCHIVE_DIR";
$FETCH_ACCOUNT_OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/account_out";
$FETCH_PRODUCT_OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/product_out";
#$FETCH_AMD_OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/amd_out";
#$FETCH_AMP_OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/amp_out";
#$FETCH_DISCOUNT_OUT_DIR = "$PIN_HOME/TD/apps/td_fetch_details/discount_out";
$FETCH_EVENT_OUT_BACKUP_DIR = "$PIN_HOME/TD/apps/td_fetch_details/event_out_backup";
$FETCH_PAY_EVENT_OUT_BACKUP_DIR = "$PIN_HOME/TD/apps/td_fetch_details/pay_event_out_backup";
$FETCH_ACCOUNT_OUT_BACKUP_DIR = "$PIN_HOME/TD/apps/td_fetch_details/account_out_backup";
#$FETCH_PRODUCT_OUT_BACKUP_DIR = "$PIN_HOME/TD/apps/td_fetch_details/product_out_backup";
#$FETCH_AMD_OUT_BACKUP_DIR = "$PIN_HOME/TD/apps/td_fetch_details/amd_out_backup";
#$FETCH_AMP_OUT_BACKUP_DIR = "$PIN_HOME/TD/apps/td_fetch_details/amp_out_backup";
#$FETCH_DISCOUNT_OUT_BACKUP_DIR = "$PIN_HOME/TD/apps/td_fetch_details/discount_out_backup";
$FETCH_EVENT_ZERO_OUT_BACKUP_DIR = "$PIN_HOME/TD/apps/td_fetch_details/event_zero_out_backup";
$datetime = localtime();  
#print "Local Time of the System : $datetime\n"; 
#use Getopt::Std;
#my %opts;
#getopts ("i:h", \%opts);

#
# Create the SAMPLING_LOG_DIR and SAMPLING_LOG_DIR if it doesn't exist.
#
if  ( ! -e $OUT_DIR )
{
        mkdir ("$OUT_DIR", 0777) || die "Unable to create $OUT_DIR directory";
        print "Creating log directory $OUT_DIR \n";
}
if  ( ! -e $FETCH_LOG_DIR )
{
        mkdir ("$FETCH_LOG_DIR", 0777) || die "Unable to create $FETCH_LOG_DIR directory";
        print "Creating log directory $FETCH_LOG_DIR \n";
}

if  ( ! -e $FETCH_EVENT_OUT_DIR )
{
        mkdir ("$FETCH_EVENT_OUT_DIR", 0777) || die "Unable to create $FETCH_EVENT_OUT_DIR directory";
        print "Creating log directory $FETCH_EVENT_OUT_DIR \n";
}
if  ( ! -e $FETCH_PAY_EVENT_OUT_DIR )
{
        mkdir ("$FETCH_PAY_EVENT_OUT_DIR", 0777) || die "Unable to create $FETCH_PAY_EVENT_OUT_DIR directory";
        print "Creating log directory $FETCH_PAY_EVENT_OUT_DIR \n";
}
if  ( ! -e $FETCH_EVENT_ZERO_OUT_DIR )
{
        mkdir ("$FETCH_EVENT_ZERO_OUT_DIR", 0777) || die "Unable to create $FETCH_EVENT_ZERO_OUT_DIR directory";
        print "Creating log directory $FETCH_EVENT_ZERO_OUT_DIR \n";
}
if  ( ! -e $FETCH_ACCOUNT_OUT_DIR )
{
        mkdir ("$FETCH_ACCOUNT_OUT_DIR", 0777) || die "Unable to create $FETCH_ACCOUNT_OUT_DIR directory";
        print "Creating log directory $FETCH_ACCOUNT_OUT_DIR \n";
}

if  ( ! -e $FETCH_EVENT_OUT_BACKUP_DIR)
{
        mkdir ("$FETCH_EVENT_OUT_BACKUP_DIR", 0777) || die "Unable to create $FETCH_EVENT_OUT_BACKUP_DIR directory";
        print "Creating log directory $FETCH_EVENT_OUT_BACKUP_DIR \n";
}
if  ( ! -e $FETCH_EVENT_ZERO_OUT_BACKUP_DIR)
{
        mkdir ("$FETCH_EVENT_ZERO_OUT_BACKUP_DIR", 0777) || die "Unable to create $FETCH_EVENT_ZERO_OUT_BACKUP_DIR directory";
        print "Creating log directory $FETCH_EVENT_ZERO_OUT_BACKUP_DIR \n";
}
if  ( ! -e $FETCH_PAY_EVENT_OUT_BACKUP_DIR)
{
        mkdir ("$FETCH_PAY_EVENT_OUT_BACKUP_DIR", 0777) || die "Unable to create $FETCH_PAY_EVENT_OUT_BACKUP_DIR directory";
        print "Creating log directory $FETCH_PAY_EVENT_OUT_BACKUP_DIR \n";
}
if  ( ! -e $FETCH_ACCOUNT_OUT_BACKUP_DIR)
{
        mkdir ("$FETCH_ACCOUNT_OUT_BACKUP_DIR", 0777) || die "Unable to create $FETCH_ACCOUNT_OUT_BACKUP_DIR directory";
        print "Creating log directory $FETCH_ACCOUNT_OUT_BACKUP_DIR \n";
}

# Create the FETCH_LOG_DIR.log file to append all the messages from deployment
#

open (MAINLOG, ">>$FETCH_LOG_DIR/td_fetch_gl_details_extract.log") || die "Unable to create file $FETCH_LOG_DIR/td_fetch_gl_details_extract.log";

print MAINLOG "\n\n*****************Fetching data extract for GL from BRM DB on  $datetime **********************\n\n" ;
print MAINLOG "Starting database fetch Program on :  $datetime  \n" ;


print MAINLOG "Starting to collect Account data from database on $datetime!!!!\n";

system("sh ./fetch_account_details.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}

print MAINLOG "Fetching of Account data completed on $datetime!\n";
print MAINLOG "Starting archiving and renaming Account data file!!! \n";
system("sh ./td_account_output_formatting.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}
print MAINLOG "Archiving and renaming Account data file and sending to out directory completed! on $datetime!\n";


print MAINLOG "\n\n*****************Data Extraction Compeleted from BRM DB on $datetime! ***********************\n\n";
#print "Recreate database objects for sampling for DOM: ".$ACTG_CYCLE_DOM. "\n";

#my ($ddl, $mml, $yyyyl) = (localtime)[3..5];
#$mml=$mml+1;
#$yyyyl=$yyyyl+1900;


