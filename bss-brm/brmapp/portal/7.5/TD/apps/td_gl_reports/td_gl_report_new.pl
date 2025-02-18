#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

use strict;
use Getopt::Std;

sub usage()
{
        print << "EOF";

        $0 [-r <report_name> -d <YYYYMMDD>]
                -Eg: perl td_gl_report.pl -r gl_bill_cycle_report -d 20150201
                -r : Specify the report name. Possible values are <gl_bill_cycle_report,gl_prepaid_bill_cycle_report,
                                                                   revenue_forecast_report,gl_unbilled_revenue_report>
                -d : Pass DOM date in YYYYMMDD format
EOF

        die ("successfully terminated". "\n");
}

my %opts;
getopts ("r:d:h", \%opts);
usage() if ((!defined $opts{r} or !defined $opts{d}));
usage() if $opts{h};



        my $report_name=$opts{r};
        my $dom_date=$opts{d};

usage() if (length($dom_date) != 8);



my $yy = substr $dom_date,0,4;
my $mm = substr $dom_date,4,2;
my $dd = substr $dom_date,6,2;

usage() if (isvaliddate($yy."-".$mm."-".$dd) != 1);

my $start_mm;
my $start_yy = $yy;

if ($mm eq '01')
	{
	$start_mm = 12;
	$start_yy = $yy - 1;
	}	
else
	{
	$start_mm = $mm - 1;
	}

if (length $start_mm ne 2)
        {
        $start_mm=LPad($start_mm,2,0);
        }

my $start_dom = $start_yy.$start_mm.$dd;

if ( $report_name eq 'gl_bill_cycle_report' )
{
        print "\n"."Starting execution of td_get_billcycle_report.sh for dom date ".$start_dom." ".$dom_date."\n";
        system("./all_scripts/td_get_billcycle_report.sh $start_dom $dom_date");
}


elsif ( $report_name eq 'gl_prepaid_bill_cycle_report' )
{
        print "\n"."Starting execution of td_get_prepaid_billcycle_report.sh for dom date ".$start_dom." ".$dom_date."\n";
        system("./all_scripts/td_get_prepaid_billcycle_report.sh $start_dom $dom_date");
}


elsif ( $report_name eq 'revenue_forecast_report' )
{
        print "\n"."Starting execution of td_revenue_forecast_report.sh for dom date ".$dom_date."\n";
        system("./all_scripts/td_revenue_forecast_report.sh $dom_date");
}

elsif ( $report_name eq 'gl_unbilled_revenue_report' )
{
        print "\n"."Starting execution of td_get_unbilled_revenue_report.sh for dom date ".$start_dom." ".$dom_date."\n";
        system("./all_scripts/td_get_unbilled_revenue_report.sh $start_dom $dom_date");
}

else
{
print "\n"."Incorrect report name"."\n";
usage();
}


sub isvaliddate {
  my $input = shift;
  if ($input =~ m!^((?:19|20)\d\d)[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$!) {
    # At this point, $1 holds the year, $2 the month and $3 the day of the date entered
    if ($3 == 31 and ($2 == 4 or $2 == 6 or $2 == 9 or $2 == 11)) {
      return 0; # 31st of a month with 30 days
    } elsif ($3 >= 30 and $2 == 2) {
      return 0; # February 30th or 31st
    } elsif ($2 == 2 and $3 == 29 and not ($1 % 4 == 0 and ($1 % 100 != 0 or $1 % 400 == 0))) {
      return 0; # February 29th outside a leap year
    } else {
      return 1; # Valid date
    }
  } else {
    return 0; # Not a date
  }
}

sub LPad
{
        (my $str, my $len, my $chr) = @_;
        $chr = "0" unless (defined($chr));
        return substr(($chr x ($len - length $str)).$str, 0, $len);
}
