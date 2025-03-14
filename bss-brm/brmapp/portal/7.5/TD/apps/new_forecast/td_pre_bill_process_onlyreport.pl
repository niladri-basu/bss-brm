#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl


#=============================================================
# Author : Rakesh Nair
# Date   : 1-Jan-2015
#
# Script for generating trial bill prior to billing.
# Also initiates pre-bill checks and pre-bill recon reports.
#=============================================================

require "td_pre_bill_process.cfg";
use Getopt::Std;


sub usage()
{
        print << "EOF";

        $0 [-d <YYYYMMDD>]
                -Eg: perl td_pre_bill_process.pl -d 20150201
                -d : Pass DOM date in YYYYMMDD format
EOF

        die ("successfully terminated". "\n");
}

my %opts;
getopts ("d:h", \%opts);
usage() if ((!defined $opts{d}));
usage() if $opts{h};

my $dom_date=$opts{d};
my $trial_exists=0;

usage() if (length($dom_date) != 8);

        my $dom_year=substr $dom_date,0,4;
        my $dom_mon=substr $dom_date,4,2;
        my $dom_day=substr $dom_date,6,2;


print "Starting Trial bill execution before bill run at:";
print scalar localtime()."\n";


my $trial_bill_file = $TRIAL_INPUT_DIR.$TRIAL_FILE_PREFIX.$dom_mon.$dom_day.$dom_year;
my $trial_out_file = $TRIAL_OUT_DIR.$TRIAL_FILE_PREFIX.$dom_date.".log";

print "$trial_out_file\n";

if (-e $trial_bill_file) 
{ 
	#print "pin_trial_bill_accts -end $dom_mon/$dom_day/$dom_year -verbose -f $trial_bill_file > $trial_out_file \n";
	#`pin_trial_bill_accts -end $dom_mon/$dom_day/$dom_year -verbose -f $trial_bill_file > $trial_out_file`;

	if ($? == 256) {
    	print "Exit\n";
    	exit;
	}
	$trial_exists=1;
	
	print "Completed Trial bill execution at:";
	print scalar localtime()."\n";
} else {
print "Trial bill input file $trial_bill_file does not exist\n";
#exit;
}


if ($trial_exists == 1) {
print "Starting Trial bill PDF generation at: ";
print scalar localtime()."\n";

my $trial_bip_file = $BIP_INPUT_DIR.$DOCGEN_FILE_PREFIX.$dom_mon.$dom_day.$dom_year.$DOCGEN_FILE_SUFFIX;
my $trial_bipout_file = $TRIAL_OUT_DIR.$DOCGEN_FILE_PREFIX.$dom_date.".log";

print "$trial_bip_file \n";
if (-e $trial_bip_file) 
{ 
	#print "cp $trial_bip_file $BIP_INPUT_DIR"."InvoiceList.xml";
#	`cp $trial_bip_file $BIP_INPUT_DIR/InvoiceList.xml`;
#	`sh $BIP_INPUT_DIR/docgen_trial.sh $BIP_INPUT_DIR/InvoiceList.xml > $trial_bipout_file`;
	#print "sh $BIP_INPUT_DIR/docgen_trial.sh $BIP_INPUT_DIR/InvoiceList.xml > $trial_bipout_file\n";


		if ($? == 256) {
		    print "Exit\n";
		    exit;
		}

print "Completed Trial bill PDF generation at: ";
print scalar localtime()."\n";

}  else {
print "Trial bill input file $trial_bip_file for PDF generation does not exist\n";
$trial_exists=0;
#exit;
}
}


#if ($trial_exists == 1) {
print "Starting pre-bill report initiation at: ";
print scalar localtime()."\n";
system("sh ./all_scripts/ac_td_prebill_report.sh ");
	if ($? == 256) {
    	print "Exit\n";
    	exit;
	}

print "Completing pre-bill process at: ";
print scalar localtime()."\n";

#}


