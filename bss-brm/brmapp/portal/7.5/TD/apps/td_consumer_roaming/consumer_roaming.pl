#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# Author : Akshay Bomale
# Date   : 02-Sep-2021
#
# Wrapper script for consumer_roaming.
#=============================================================
require "consumer_roaming_control.cfg";

#sub find_dom();

use Getopt::Std;
my %opts;
getopts ("i:h", \%opts);
my $ACTG_CYCLE_DOM;
my $dom_in;


#
# Create the CONSUMER_ROAMING_LOG_DIR and CONSUMER_ROAMING_LOG_DIR if it doesn't exist.
#

if  ( ! -e $CONSUMER_ROAMING_LOG_DIR )
{
        mkdir ("$CONSUMER_ROAMING_LOG_DIR", 0777) || die "Unable to create $CONSUMER_ROAMING_LOG_DIR directory";
        print "Creating log directory $CONSUMER_ROAMING_LOG_DIR \n";
}
if  ( ! -e $CONSUMER_LOG_DIR )
{
        mkdir ("$CONSUMER_LOG_DIR", 0777) || die "Unable to create $CONSUMER_LOG_DIR directory";
        print "Creating log directory $CONSUMER_LOG_DIR \n";
}

#
# Create the consumer_roaming.log file to append all the messages from deployment
#

open (MAINLOG, ">>$CONSUMER_ROAMING_LOG_DIR/consumer_roaming.log") || die "Unable to create file $CONSUMER_ROAMING_LOG_DIR/consumer_roaming.log";

#Check for script execution and perform cleanup##



if (defined $opts{i})
{
        $dom_in=$opts{i};
        my $find = "ACTG_CYCLE_DOM_CONF";
        my $domval = "";
        $ACTG_CYCLE_DOM = $dom_in;
        open FILE, "<consumer_roaming_control.cfg";
        my @lines = <FILE>;
        for (@lines) {
            if ($_ =~ /$find/) {
                #print "$_\n";
                $domval = $_;
            }
        }


        my $new_domval = "ACTG_CYCLE_DOM_CONF = \"$dom_in\"";
        $domval = substr $domval,1,(length $domval) -3;

        open(FILE, "<consumer_roaming_control.cfg") || die "File not found";
        @lines = <FILE>;
        close(FILE);


        my @newlines;
        foreach(@lines) {
           $_ =~ s/$domval/$new_domval/g;
           push(@newlines,$_);
        }

        open(FILE, ">consumer_roaming_control.cfg") || die "File not found";
        print FILE @newlines;
        close(FILE);

}

else
{
$ACTG_CYCLE_DOM = $ACTG_CYCLE_DOM_CONF;
$ACTG_CYCLE_DOM = find_dom();
}

##Create the IOT tables to select all billinfos and items in scope##


print "Starting roaming Program...... \n";
print "Dropping roaming objects from database.... \n";

system("sh ./iot_roaming_drop.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}

print "Check if the objects have been dropped in DR database... \n";

system("sh ./iot_roaming_drop_check.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}

#print "Recreate database objects for roaming for DOM: ".$ACTG_CYCLE_DOM. "\n";

my ($ddl, $mml, $yyyyl) = (localtime)[3..5];
$mml=$mml+1;
$yyyyl=$yyyyl+1900;
$actg_dom=$ACTG_CYCLE_DOM;


if ($ddl > $actg_dom)
        {
        $mml=$mml+1;
        if ($mml == 13)
                {$mml = 1;
                 $yyyyl = $yyyyl+1;
                }
        }

if (length $mml ne 2)
        {
        $mml=LPad($mml,2,0);
        }

if (length $actg_dom ne 2)
        {
        $actg_dom=LPad($actg_dom,2,0);
        }

print "Recreate database objects for roaming for DOM: ".$yyyyl.$mml.$actg_dom. "\n";
#system("sh ./iot_billinfo_create.sh $ACTG_CYCLE_DOM");
system("sh ./iot_roaming_billinfo_create.sh $yyyyl$mml$actg_dom");
if ($? == 256) {
    print "Exit\n";
    exit;
}

print "Check if the objects have been recreated in DR database... \n";

system("sh ./iot_roaming_billinfo_create_check.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
} 




sub find_dom 
{

my $find = "ACTG_CYCLE_DOM_CONF";
my $domval = "";
open FILE, "<consumer_roaming_control.cfg";
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

my $new_domval = "ACTG_CYCLE_DOM_CONF = \"$dom_value\"";

$domval = substr $domval,1,(length $domval) -3;


open(FILE, "<consumer_roaming_control.cfg") || die "File not found";
@lines = <FILE>;
close(FILE);


my @newlines;
foreach(@lines) {
   $_ =~ s/$domval/$new_domval/g;
   push(@newlines,$_);
}

open(FILE, ">consumer_roaming_control.cfg") || die "File not found";
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
