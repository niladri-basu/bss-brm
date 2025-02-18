#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

use POSIX;
use pcmif;
my $PATH;


#sub get_holiday($,$,$);
#=========================================#
# Database number
#=========================================#

$DB_NO="0.0.0.1";

print "Started @ : ";
print scalar localtime()."\n";

print "Reading Configuration File \n";
my %ConfVarTable;
my $conf = "pin.conf";

#######################################
#readConfigFile();
#######################################
if ( -e $conf )
{
   	$days_after = `grep '^-' $conf | grep days_after | awk '{print \$4}'`;
	print "days_after: $days_after";
    	chomp($days_after);
}
else
{
    print "\n $conf configuration file not found!\n\n";
    exit(1);
}

################################################################################
#	Get Weekend/Weekday
################################################################################
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

my $wk = is_weekend($wday);
print "\nWeekend/Weekday : $wk";

################################################################################
#	Function call to check the holiday
################################################################################
my $flag = 0;
my $file = "tmp.data";

$flag = is_holiday($mday,$mon,$year,$wk);

if ($flag == 0)
{
	exit;
}
else
{
	$mon -=1;
	$year -= 1900;

	my $unixtime = mktime ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday);
	print "\nSysdate:   $unixtime";

	#Generate due_date
	my $due_date = $unixtime + ($days_after * 86400);
	print "\nDue_date:   $due_date ";

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($due_date);

#$mon +=1;
#$year += 1900;
#print "$mday-$mon-$year\n";

	################################################################################
	open (MYFILE, ">$file")|| die "couldnt open file.txt: $!";
	print MYFILE "$due_date\n";
	close (MYFILE);

	################################################################################
	# Invoke pymt_reminder mta
	################################################################################
	print "\nInvoked pymt_reminder mta\n";
	system(td_inv_pymt_reminder_mta);
	################################################################################
}

open (MYFILE, ">$file")|| die "couldnt open file.txt: $!";
while (1){
	$mday +=1;
	$due_date = mktime ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday);
	print "\nDue_date:   $due_date";

	$wk = is_weekend($wday);
	print "\nWeekend/Weekday : $wk";

	$flag = 0;
	$flag = is_holiday($mday,$mon,$year,$wk);

	if ($flag == 0 ){
		#open (MYFILE, ">$file")|| die "couldnt open file.txt: $!";
		print MYFILE "$due_date\n";
		#close (MYFILE);
	
		system(td_inv_pymt_reminder_mta);
		print "\nInvoked pymt_reminder mta\n";
	}
	else{
		print "Exiting:\n";
		last;
	}
}
close (MYFILE);
#system(td_inv_pymt_reminder_mta);

print "\nFinished @ : ";
print scalar localtime()."\n";






#============================================#
# Subroutine to Check Holiday
#============================================#
sub is_holiday($,$,$,$){

print "\nin get holiday()\n";

my @dom = (0,0,0,0,0,0,0,0,0,0);
my @moy = (0,0,0,0,0,0,0,0,0,0);
my @year = (0,0,0,0,0,0,0,0,0,0);

my $i = 0;
my $j = 0;
my $k = 0;


$ebufp = pcmif::pcm_perl_new_ebuf();
$pcm_ctxp = pcmif::pcm_perl_connect($db_no, $ebufp);

my $cal_name ="td_collections_calendar";
my $template = "select X from /config/calendar where F1 = V1 ";
my $f1=<<"XXX";
        0 PIN_FLD_POID        POID [0] $DB_NO /search -1 0
        0 PIN_FLD_FLAGS       INT [0] 256
        0 PIN_FLD_TEMPLATE     STR [0] "$template"
        0 PIN_FLD_RESULTS    ARRAY [0] allocated 1, used 1
        1        PIN_FLD_POID   POID [0] NULL
        1 PIN_FLD_CALENDAR_DATE  ARRAY [*] allocated 20, used 3
        2     PIN_FLD_CALENDAR_DOM    INT [0] 0
        2     PIN_FLD_CALENDAR_MOY    INT [0] 0
        2     PIN_FLD_CALENDAR_YEAR    INT [0] 0
        0 PIN_FLD_ARGS          ARRAY [1] allocated 1, used 1
        1        PIN_FLD_NAME   STR [0] "$cal_name"
XXX

#print ("Input flist:\n$f1\n");
my $search_iflist = pcmif::pin_perl_str_to_flist($f1, $DB_NO, $ebufp);

my $search_oflist = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_SEARCH", 0, $search_iflist, $ebufp);
my $search_out = pcmif::pin_perl_flist_to_str($search_oflist, $ebufp);

if (pcmif::pcm_perl_is_err($ebufp)) {
        print "\n Error processing input flist, please check logs...";
}
else{
#print ("Output flist:\n$search_out\n");

my @value = split(/\n/,$search_out);
$value_count = $#value;
       foreach $val_array_element(@value)
                {       chomp($val_array_element);

                        if ( $val_array_element =~ "PIN_FLD_CALENDAR_DOM" )
                        {       #print "\n i value: $i";
                                #print "\n Line:\n       $val_array_element";
                                my @return_value = split(/\s/, $val_array_element);
                                $dom[$i] = $return_value[$#return_value];
                                #print "\n Calendar DOM $i: $dom[$i]\n";
                                $i++;
                        }
                        if ( $val_array_element =~ "PIN_FLD_CALENDAR_MOY" )
                        {
                                #print "\n Line:\n       $val_array_element";
                                my @return_value = split(/\s/, $val_array_element);
                                $moy[$j] = $return_value[$#return_value];
                                #print "\n Calendar MOY: $moy[$j]\n";
                                $j++;
                        }
                        if ( $val_array_element =~ "PIN_FLD_CALENDAR_YEAR" )
                        {
                                #print "\n Line:\n       $val_array_element";
                                my @return_value = split(/\s/, $val_array_element);
                                $year[$k] = $return_value[$#return_value];
                                #print "\n Calendar YEAR: $year[$k]\n";
                                $k++;
                        }


                }
}

print "\nDate: $mday-$mon-$year";
print "\nWeekday/end: $wk\n";

$i = $i - 1;
while($i > -1){

        if (( $wk eq "weekend") || ( $mday == $dom[$i] && $mon == $moy[$i] && $year == $year[$i] )){
                print "\nDate $mday-$mon-$year is $wk and $dom[$i]-$moy[$i]-$year[$i] is Holiday in Calendar\n";
                print "Exiting...........\n";
                $flag = 0;
		last;
                #exit;
        }
$i = $i - 1;
$flag = 1;
}

print "\nDate $mday-$mon-$year is $wk but NOT Holiday in Calendar\n";

return $flag;
}
#################################################################################
# Subroutine is_weekend to get weekend or weekday
#################################################################################
sub is_weekend{

my $wday = @_;
$wk = $wday >= 1 && $wday <= 5 ? "weekday" : "weekend";

$mon +=1;
$year += 1900;

print "\nDate passed: $mday-$mon-$year \n";
return $wk
}
