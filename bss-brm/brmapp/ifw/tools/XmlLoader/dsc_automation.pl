#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

use File::Basename;
use File::Path;
use strict;
use warnings;
use POSIX qw(strftime);
use File::Copy;
#######################################
# Files and Directory
#######################################
my $INPUT_DIR;
my $IN_FILE;
my $ERR_DIR;
my $ARCHIVE_DIR;
my $LOG_DIR;
my $LOG_FILE;
my $TMPL_FILE;

$LOG_DIR="./logs";
$ARCHIVE_DIR="./archive";
$TMPL_FILE="dsc_input_tmpl.xml";
$LOG_FILE="$LOG_DIR/LoadIfwConfig_automation.log";
#######################################
# Input Parameters
#######################################
my $dsc_start_date;
my $dsc_start_date_ts;
my $dsc_code;
my $dsc_bal_imp_glid;
my $dsc_grant_unit;
my $dsc_unit;
my $dsc_valid_from;
my $dsc_type;
my $sec;my $min;my $hour;my $mday;my $mon;my $year;my $wday;my $yday;my $isdst;
#######################################
# Script Usage
#######################################
print "\nDiscount Automation Script Begins \n";
print "Please enter Discount Type Percent or Amount[P or A]: ";
$dsc_type=<>;
chomp($dsc_type);
if (( $dsc_type eq 'P' ) or ( $dsc_type eq 'A' ))
{
        print "\nPlease enter Discount Value for percent/amount: ";
        $dsc_grant_unit=<>;
        chomp($dsc_grant_unit);
        $dsc_unit = $dsc_grant_unit;
        if ( $dsc_type eq 'P' )
        {
                if ($dsc_unit > 100)
                {
                        die "\nInput given $dsc_unit% However, Percent Discount cannot be > 100% ";
                }
                else
                {
                        $dsc_unit = $dsc_unit/100;
                }
        }
}
else
{
        die "\n$dsc_type Not a Valid Discount Type ";
}
print "\nPlease enter GLID: ";
$dsc_bal_imp_glid=<>;
chomp($dsc_bal_imp_glid);
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
#$dsc_start_date=$year.$mon.$mday;
$dsc_start_date = strftime "%Y%m%d", localtime;
$dsc_start_date_ts = strftime "%Y-%m-%dT00:00:00",localtime;
print "checking date $dsc_start_date";
print "checking date ts $dsc_start_date_ts";
print "\nyou have entered $dsc_type and $dsc_grant_unit\n";
#######################################
# Create IP xml and load using LoadIfwConfig
#######################################
$IN_FILE="dsc_auto_$dsc_start_date.xml";
$dsc_code="DSC_".$dsc_type."_".$dsc_grant_unit."_".$dsc_start_date;
#copy($TMPL_FILE, $IN_FILE) or die "Unable to create input xml for LoadIfwConfig\n";
open (FILE,'>',$IN_FILE) or die $!;
open (TMPL,'<',$TMPL_FILE) or die $!;
my $line;
while ($line = <TMPL>) {
    $line =~ s/dsc_code/$dsc_code/g;
    $line =~ s/dsc_unit/-$dsc_unit/g;
    $line =~ s/dsc_start_date_ts/$dsc_start_date_ts/g;
    $line =~ s/dsc_start_date/$dsc_start_date/g;
    $line =~ s/dsc_type/$dsc_type/g;
    $line =~ s/dsc_bal_imp_glid/$dsc_bal_imp_glid/g;
    print FILE $line;
    print $line;

}

    #print $line >$IN_FILE;
close (FILE);
close (TMPL);
open (LOG,'>',$LOG_FILE) or die $!; 
print LOG qx(LoadIfwConfig -v -I -c -i $IN_FILE);

