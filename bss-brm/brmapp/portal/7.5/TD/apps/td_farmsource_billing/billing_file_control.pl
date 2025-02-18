#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# Author : Akshay Bomale
# Date   : 10-Aug-2022
#
# Wrapper script for FS Billing file .
#=============================================================
require "fs_billing_control.cfg";

#sub find_dom();

use Getopt::Std;
my %opts;
getopts ("i:h", \%opts);
my $ACTG_CYCLE_DOM;
my $dom_in;


#
# Create the FS_BILLING_LOG_DIR and FS_BILLING_LOG_DIR if it doesn't exist.
#

if  ( ! -e $FS_BILLING_LOG_DIR )
{
        mkdir ("$FS_BILLING_LOG_DIR", 0777) || die "Unable to create $FS_BILLING_LOG_DIR directory";
        print "Creating log directory $FS_BILLING_LOG_DIR \n";
}
if  ( ! -e $FS_BILLING_OUT_DIR )
{
        mkdir ("$FS_BILLING_OUT_DIR", 0777) || die "Unable to create $FS_BILLING_OUT_DIR directory";
        print "Creating log directory $FS_BILLING_OUT_DIR \n";
}

#
# Create the consumer_roaming.log file to append all the messages from deployment
#

open (MAINLOG, ">>$FS_BILLING_LOG_DIR/fs_billing.log") || die "Unable to create file $FS_BILLING_LOG_DIR/fs_billing.log";

#Check for script execution and perform cleanup##



if (defined $opts{i})
{
        $dom_in=$opts{i};
        my $find = "ACTG_CYCLE_DOM_CONF";
        my $domval = "";
        $ACTG_CYCLE_DOM = $dom_in;
        open FILE, "<fs_billing_control.cfg";
        my @lines = <FILE>;
        for (@lines) {
            if ($_ =~ /$find/) {
                #print "$_\n";
                $domval = $_;
            }
        }


        my $new_domval = "ACTG_CYCLE_DOM_CONF = \"$dom_in\";";
        $domval = substr $domval,1,(length $domval) -3;

        open(FILE, "<fs_billing_control.cfg") || die "File not found";
        @lines = <FILE>;
        close(FILE);


        my @newlines;
        foreach(@lines) {
           $_ =~ s/$domval/$new_domval/g;
           push(@newlines,$_);
        }

        open(FILE, ">fs_billing_control.cfg") || die "File not found";
        print FILE @newlines;
        close(FILE);

}

else
{
$ACTG_CYCLE_DOM = $ACTG_CYCLE_DOM_CONF;
$ACTG_CYCLE_DOM = find_dom();
}

##Create the IOT tables to select all billinfos and items in scope##


print "Starting fs_billing Program...... \n";
print "Dropping fs_billing objects from database.... \n";

system("sh ./td_fs_billing_extract_drop.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}

print "Check if the objects have been dropped in DR database... \n";

system("sh ./td_fs_billing_extract_dropcheck.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}

#print "Recreate database objects for roaming for DOM: ".$ACTG_CYCLE_DOM. "\n";

my ($ddl, $mml, $yyyyl) = (localtime)[3..5];
my ($mon) = (localtime)[4];
$mon=$mon+1;
$mml=$mml+1;
$yyyyl=$yyyyl+1900;
$actg_dom=$ACTG_CYCLE_DOM;
  print "value MM1 is ".$mm1. "  mm1 \n" ;
  print "value MON is ".$mon. "  mon \n" ;
($day, $month, $year) = (localtime)[3,4,5];
printf("The current date is %04d %02d %02d\n", $year+1900, $month+1, $day);
  print "value day is ".$day. "  day \n" ;
  print "value MONTH is ".$month. "  month \n" ;
    print "value year is ".$year. "  year \n" ;
if ($ddl >= $actg_dom)
        {
		
        $mml=$mml+1;
        if ($mml == 13)
                {$mml = 1;
                 $yyyyl = $yyyyl+1;
				 $mon = 1;
                }
        }
		

if (length $mml ne 2)
        {
        $mml=LPad($mml,2,0);
        }
		{
        $mon=LPad($mon,2,0);
        }

if (length $actg_dom ne 2)
        {
        $actg_dom=LPad($actg_dom,2,0);
        }
  print "value is ".$mm1. "  mm1 \n" ;
  print "value is ".$mon. "  mon \n" ;
print "Recreate database objects for fsbilling for DOM: ".$yyyyl.$mml.$actg_dom."\n";
system("sh ./td_billing_file_create.sh $yyyyl$mml$actg_dom");
if ($? == 256) {
    print "Exit\n";
    exit;
}

print "Check if the objects have been recreated in DR database... \n";

system("sh ./td_billing_file_create_check.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}

print "CSV generation in progress... \n";
print " $yyyyl$mon$actg_dom  \n";
print "create csv file DOM: ".$yyyyl.$mon.$actg_dom. "\n";
system("sh ./td_billing_extract_csv.sh $yyyyl$mon$actg_dom");
if ($? == 256) {
    print "Exit\n";
    exit;
}


sub find_dom
{

my $find = "ACTG_CYCLE_DOM_CONF";
my $domval = "";
open FILE, "<fs_billing_control.cfg";
my @lines = <FILE>;
for (@lines) {
    if ($_ =~ /$find/) {
        #print "$_\n";
        $domval = $_;
    }
}

my $dom_count = 0;
my $RECORD;
my @value_list;
my @sort_value_list;
my @dom_array;
my $dom_length;
my @dom_array_unsort;
my $dom_value = 1;
my ($dd, $mm, $yyyy) = (localtime)[3..5];


        $RECORD = $LIST_DOM;
        chomp($RECORD);
        @value_list = $RECORD;
        @dom_array_unsort = split(',',$value_list[0]);
        @dom_array = sort {$a <=> $b} @dom_array_unsort;
        $dom_length = @dom_array;
        $dom_value = $dom_array_unsort[0];

        OUT: while ($dom_length > $dom_count)
        {
                if ($dd < $dom_array[$dom_count])
                {
                        $dom_value = $dom_array[$dom_count];
                        last OUT;
                }
                $dom_count=$dom_count+1;

        }

my $new_domval = "ACTG_CYCLE_DOM_CONF = \"$dom_value\";";
print "NEW DOM VALUE IS \n";
print "\n $new_domval";
$domval = substr $domval,1,(length $domval) -3;


open(FILE, "<fs_billing_control.cfg") || die "File not found";
@lines = <FILE>;
close(FILE);


my @newlines;
foreach(@lines) {
   $_ =~ s/$domval/$new_domval/g;
   push(@newlines,$_);
}

open(FILE, ">fs_billing_control.cfg") || die "File not found";
print FILE @newlines;
close(FILE);

return $dom_value;

}

sub LPad
{
        ($str, $len, $chr) = @_;
        $chr = "0" unless (defined($chr));
        return substr(($chr x ($len - length $str)).$str, 0, $len);
}
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
F,
