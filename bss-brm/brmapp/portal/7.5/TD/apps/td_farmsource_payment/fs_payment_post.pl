#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
##----------------------------------------------------------------------
##
##Author: Niladri Basu 
##Date: 10-08-2022
##Descr: FarmSource Payment
##----------------------------------------------------------------------
require "fs_payment_control.cfg";
use POSIX qw(strftime);
use pcmif;
use Time::Local;
use File::Copy;
use lib '.' ;
use pcmif;
use Sys::Hostname;
use File::Basename;
use File::Path;
use Cwd;

my $pymt_start_date;
my $pymt_start_date_time;
my $sec;my $min;my $hour;my $mday;my $mon;my $year;my $wday;my $yday;my $isdst;
my $INPUT_DIR;
my $PROCESSED_DIR;
my $REJECT_DIR;
my $AUDIT_DIR;
my $ARCHIVE_DIR;
my $input_file;
my $db_no;
my $error_num = "0 PIN_FLD_ERROR_NUM       INT [0] 1";
#my $conf = "fs_payment_control.cfg";

#if ($#ARGV + 1 < 1)
#{
#        print "Usage : fs_payment_post.pl <INPUT_FILE>";
#        exit;
#}

$LOGIN_DB="0.0.0.1";
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
#$dsc_start_date=$year.$mon.$mday;
$pymt_start_date = strftime "%Y%m%d", localtime;
$pymt_start_date_time = strftime "%Y%m%d%H%M%S", localtime;

$INPUT_DIR="/brmapp/portal/7.5/TD/apps/td_farmsource_payment/fs_payment/payment_input";
$PROCESSED_DIR="/brmapp/portal/7.5/TD/apps/td_farmsource_payment/fs_payment/processed";
$REJECT_DIR="/brmapp/portal/7.5/TD/apps/td_farmsource_payment/fs_payment/reject";
$AUDIT_DIR="/brmapp/portal/7.5/TD/apps/td_farmsource_payment/fs_payment/audit";
$ARCHIVE_DIR="/brmapp/portal/7.5/TD/apps/td_farmsource_payment/fs_payment/archive";
my $FS_BILLING_FILE="/brmapp/portal/7.5/TD/apps/td_farmsource_billing/csv/2DegreesMobileLtd".$pymt_start_date."_payment.csv";
copy("$FS_BILLING_FILE","$INPUT_DIR") or die ("Could not Copy Billing file to the input file");
$input_file = $INPUT_DIR."/2DegreesMobileLtd".$pymt_start_date."_payment.csv";
#$input_file = "/brmapp/portal/7.5/TD/apps/td_farmsource_payment/fs_payment/payment_input/2DegreesMobileLtd20220901_payment.csv";
my $audit_file = $AUDIT_DIR."/audit_2DegreesMobileLtd".$pymt_start_date.".csv";
print $input_file."\n";

$reject_file = $REJECT_DIR."/FS_Payment_Reject_".$pymt_start_date.".csv";
$processed_file = $PROCESSED_DIR."/FS_Payment_processed_".$pymt_start_date.".csv";
print "Started @ : \n";
print scalar localtime()."\n";

$ebufp = pcmif::pcm_perl_new_ebuf();
$db_no='0.0.0.1';
$pcm_ctxp = pcmif::pcm_perl_connect($db_no, $ebufp);

print "$pcm_ctxp \n";
if (pcmif::pcm_perl_is_err($ebufp)) {
        printf("FAILED to Connect to Infranet\n");
        pcmif::pcm_perl_print_ebuf($ebufp);
        exit(1);
}
open (IN_FILE, "$input_file") || die "Cant open input file";
open (REJECT_LOG, ">>$reject_file") || die "Cant open file";
open (PASS_LOG, ">>$processed_file") || die "Cant open file";
open (AUDIT_LOG, ">>$audit_file") || die "Cant open file";
    my $success_count=0;
    my $reject_count=0;
     my $count=1;
    print AUDIT_LOG $loop." Total Records \n";
test: while(<IN_FILE>)
{
        $RECORD = $_;
        chomp($RECORD);
	$RECORD =~ s/\s+$//;
        @value = split(/,/,$RECORD);
        $acc_no = $value[0];
        my $bill_no = $value[1];
        $amt = $value[2];
	chomp($amt);
	$amt=~ s/\s+$//;
        $trans_id = $pymt_start_date_time.$count;
	print "Account_No : $acc_no \n";
	print "bill_no: $bill_no \n";
	print "Payment Amount: $amt \n";
	print "Transaction ID :  $trans_id \n";

$f1 = <<"XXX"
0 PIN_FLD_POID           POID [0] 0.0.0.1 /account -1 0
0 PIN_FLD_PAY_TYPE       ENUM [0] 10101
0 PIN_FLD_AMOUNT       DECIMAL [0] $amt 
0 PIN_FLD_SERVICE_ID      STR [0] ""
0 PIN_FLD_PROGRAM_NAME    STR [0] "FarmSource Payment"
0 PIN_FLD_EFFECTIVE_T  TSTAMP [0] (0) <null>
0 PIN_FLD_PAYMENT_TRANS_ID    STR [0] ""
0 PIN_FLD_ACCOUNT_NO      STR [0] ""
0 PIN_FLD_FLAGS           INT [0] 1
0 PIN_FLD_BILLINFO_ID     STR [0] ""
0 PIN_FLD_BILL_NO         STR [0] "$bill_no"
0 PIN_FLD_MSISDN          STR [0] ""
0 PIN_FLD_DESCR           STR [0] "FarmSource Payment"
0 PIN_FLD_CHANNEL_ID      INT [0] 40
0 PIN_FLD_TRANS_ID        STR [0] "$trans_id"
XXX
;
#print $f1;
        $flistp = pcmif::pin_perl_str_to_flist($f1, $LOGIN_DB, $ebufp);

        if (pcmif::pcm_perl_is_err($ebufp)) {
                pcmif::pcm_perl_print_ebuf($ebufp);
                pcmif::pcm_perl_destroy_ebuf($ebufp);
                $ebufp = pcmif::pcm_perl_new_ebuf();
                print REJECT_LOG $RECORD.",Rejected \n";
		$reject_count ++;
                next test;
        }

        #print "INP:  input FLIST: ".pcmif::pin_perl_flist_to_str($flistp, $ebufp)."\n";
        $out_flistp = pcmif::pcm_perl_op($pcm_ctxp, "11003",0, $flistp, $ebufp);
        #$out_flistp = pcmif::pcm_perl_op($pcm_ctxp, TD_OP_PYMT_REVERSE,0, $flistp, $ebufp);

	 if( pcmif::pcm_perl_is_err($ebufp) )
           {
                 pcmif::pcm_perl_print_ebuf($ebufp);
                 pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
                 print REJECT_LOG $RECORD.",Rejected \n";
		$reject_count ++;
                 #close(LOG_FILE);
                 #close(IN_FILE);
                 #closedir(INPUT_DIR);
                 exit(1);
           }

        $out = pcmif::pin_perl_flist_to_str($out_flistp, $ebufp);

        #print "INP:  return FLIST: ".$out."\n";

	if (index($out, $error_num) != -1) {
        	print PASS_LOG $RECORD.",SUCCESS \n";
		$success_count ++;
	}
	else 
	{
		

		 @value = split(/\n/, $out);
                  my $err_line = "";
                  foreach my $val_array_element(@value)
                        {
                              chomp($val_array_element);

                               if ($val_array_element=~ /PIN_FLD_ERROR_NUM/i)
                                {
                                        $error_line = get_flist_fld_value($val_array_element);
        				print "error_line:  ".$error_line."\n";
		                }
                        }
	 
                print REJECT_LOG $RECORD.",Rejected,".$error_line."\n";
		$reject_count ++;
	}

        if (pcmif::pcm_perl_is_err($ebufp)) {
                pcmif::pcm_perl_print_ebuf($ebufp);
                pcmif::pcm_perl_destroy_ebuf($ebufp);
                $ebufp = pcmif::pcm_perl_new_ebuf();
                #pcmif::pin_flist_destroy($w_flistp);
                pcmif::pin_flist_destroy($out_flistp);
                print "Rejected Nil_3\n";
                print REJECT_LOG $RECORD.",Rejected \n";
		$reject_count ++;

        }

CLEANUP:

        pcmif::pin_flist_destroy($flistp);
        pcmif::pin_flist_destroy($out_flistp);
        
        #print "COUNT:  ".$count."\n";
	$count++;
}
move("$input_file","$ARCHIVE_DIR") or die ("Could not archive the input file");
print AUDIT_LOG $reject_count." Records Rejected \n";
print AUDIT_LOG $success_count." Records Success \n";
#print(LOG_FILE "\nArchived $file\n\n");

close(IN_FILE);
close(REJECT_LOG);
close(PASS_LOG);
close(AUDIT_LOG);


print "Finished @ : ";
print scalar localtime()."\n";


sub get_flist_fld_value
{
   my ( $fld, @result );
   $fld = $_[0];
         @result = split /] /, $fld;
         return $result[1];
}


