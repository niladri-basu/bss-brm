#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl


#=============================================================
# Author : Rakesh Nair
# Date   : 1-Jan-2015
#
# The script initiates post-bill recon reports.
#=============================================================

require "td_post_bill_process.cfg";
use Getopt::Std;


sub usage()
{
        print << "EOF";

        $0 [-d <YYYYMMDD>]
                -Eg: perl td_post_bill_process.pl -d 20150201
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


print "Starting post-bill report initiation at: ";
print scalar localtime()."\n";
system("sh td_postbill_report.sh $dom_date");
	if ($? == 256) {
    	print "Exit\n";
    	exit;
	}

print "Completing post-bill process at: ";
print scalar localtime()."\n";

