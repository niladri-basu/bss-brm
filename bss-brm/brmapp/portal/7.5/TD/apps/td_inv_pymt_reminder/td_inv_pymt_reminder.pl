#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
##----------------------------------------------------------------------
##
##  Author                 :  Dev Sharma
##  Date                   :  15-01-15
##  Script	           :  Pre-bill due date reminder Script
##  Description            :  To execute on business days and on  
##                            consequetive days either holiday or weekend.
##----------------------------------------------------------------------
use POSIX;
use pcmif;
my $PATH;


#sub get_holiday($,$,$);
#=========================================#
# Database number
#=========================================#
my $ebufp;
my $profile_id;
my @days_after_a;
my @profile_id_ar;
my $days_after;
my $sysdate;
my $wk;
my $flag;
my @cmd = ('td_inv_pymt_reminder_mta');
sub get_flist_fld_value($);

$DB_NO="0.0.0.1";


print "Started @ : ";
print scalar localtime()."\n";

#--------------------------------------------------------
# Get the script execution date i.e. pvt time
# if the script execution date falls on Weekend or Holiday
# then exit from the script.
#--------------------------------------------------------
my $unix_t = pin_perl_time(); 
print "Unix time $unix_t\n";
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($unix_t);

$mon = $mon + 1;
$year = $year + 1900;
print "System date: $mday-$mon-$year:$hour:$min:$sec\n";

$wk = is_weekend($wday);
print "Weekend/Weekday in main: $wk";

$flag = is_holiday($mday,$mon,$year,$wk);

if($wk eq "weekend" || $flag == 0)
{
	print "Exited becuase Sysdate is either weekend or holiday\n";
        exit;
}

#=========================================================#
#	Today is either Weekday or not a Holiday
#=========================================================# 
$ebufp = pcmif::pcm_perl_new_ebuf();
$db_no='0.0.0.1';
$pcm_ctxp = pcmif::pcm_perl_connect($db_no, $ebufp);

if (pcmif::pcm_perl_is_err($ebufp)) {
        print LOG_FILE "FAILED to Connect to Infranet\n";
        pcmif::pcm_perl_print_ebuf($ebufp);
        #display_date("finished");
        print "\nLog File $log_file\n\n";
        close(LOG_FILE);
        exit(1);
}

my $template = "select X from /config/td_collections_profile where F1.type = V1 ";
my $s_in_flist=<<"XXX";
                0 PIN_FLD_POID        POID [0] $DB_NO /search -1 0
                0 PIN_FLD_FLAGS       INT [0] 256
                0 PIN_FLD_TEMPLATE     STR [0] "$template"
                0 PIN_FLD_RESULTS    ARRAY [0] allocated 1, used 1
                1        PIN_FLD_PROFILES          ARRAY [*] allocated 1, used 1
		2                PIN_FLD_PROFILE_ID   STR [0] NULL
                2                PIN_FLD_DAYS   INT [0] 0
                0 PIN_FLD_ARGS                     ARRAY [1] allocated 1, used 1
                1     PIN_FLD_POID                  POID [0] 0.0.0.1 /config/td_collections_profile -1 0
XXX
my $search_in_flistp = pcmif::pin_perl_str_to_flist($s_in_flist,$DB_NO,$ebufp);
my $flag = 0;
my $search_out_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_SEARCH",$flag, $search_in_flistp, $ebufp);

if( pcmif::pcm_perl_is_err($ebufp) )
	{
        	pcmif::pcm_perl_print_ebuf($ebufp);
                pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
                print "\nLog File $log_file\n\n";
                close(LOG_FILE);
                close(IN_FILE);
                closedir(INPUT_DIR);
                exit(1);
        }
my $search_oflist = pcmif::pin_perl_flist_to_str($search_out_flistp, $ebufp);
#print " output : $search_oflist";

my @value = split(/\n/, $search_oflist);
my ($val_array_element);
my $i =1;
my $j =1;
my $k=1;
my $cnt=1;
my $lcnt=1;

#================================================================
# Looping for each profile_id and no. of days before
#================================================================
foreach my $val_array_element(@value){
	chomp($val_array_element);
	$lcnt=$lcnt+1;

        if ($val_array_element=~ /PIN_FLD_DAYS/i)
       	{	
		$i=$i+1;
		#print "\n i value: ".$i;
 	     	@days_after_a = get_flist_fld_value($val_array_element);
		#my $d =$days_after_a[i];
		#print"\n days : $d\n";
		$cnt=$lcnt;
        }
	if ($val_array_element=~ /PIN_FLD_PROFILE_ID/i)
        {
		
		$j=$j+1;
		#print "\n j value: ".$j;
               @profile_id_ar = get_flist_fld_value_id($val_array_element);
		#my $p = $profile_id_ar[j];
		#print"\n profile : $p\n";
        }

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($unix_t);

$mon = $mon + 1;
$year = $year + 1900;
#print "\nSystem date: $mday-$mon-$year:$hour:$min:$sec Unixtime $unix_t";
#=========================================================#

if ($i==$j && $i!=1 && $cnt == $lcnt) {
	print "\nLoop: ".$k." ---------------------------------------------";        
	$days_after = $days_after_a[i];
	$profile_id = $profile_id_ar[i];

	chomp($days_after);
	chomp($profile_id);

	print"\n days_after :$days_after\n";
	print" profile_id :$profile_id\n";
			

	#Generate due_date
	$due_date = $unix_t + ($days_after * 86400);
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($due_date);
	$mon = $mon + 1;
	$year = $year + 1900;
	print "\nDuedate $mday-$mon-$year:$hour:$min:$sec Unixtime $due_date\n";

	$wk = is_weekend($wday);
	$flag = is_holiday($mday,$mon,$year,$wk);

	#========================================================================
	# If duedate (sysdate + days_after) is weekend/holiday then loop until
	# business day is reached else invoke payment reminder mta
	#========================================================================
	if($wk eq "weekend" || $flag == 0)
	{

		while (1){
			#Generate due_date
			print "\nDuedate is either weekend or holiday, Checking the next dates\n";
			$due_date = $due_date + (1 * 86400);
			($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($due_date);
	        	 $mon = $mon + 1;
	                 $year = $year + 1900;

			 print "\nDuedate+1: $mday-$mon-$year:$hour:$min:$sec Unixtime: $due_date";

			 $wk = is_weekend($wday);
			 $flag = 0;
			 $flag = is_holiday($mday,$mon,$year,$wk);

			 if ($wk eq "weekend" || $flag == 0 ){
				print "looping for next due date";
			 }
			 else{	
		        	################################################################################
        			# Invoke pymt_reminder mta
		        	################################################################################
			        push @cmd, '-profilename';
			        push @cmd, $profile_id;
			        push @cmd, '-reminderdate';
			        push @cmd, $due_date;
				system(@cmd);
				print "\nInvoked pymt_reminder mta\n";
				last;
			}	
		}#while
	}
	else{
	        ################################################################################
        	# Invoke pymt_reminder mta
	        ################################################################################
	        push @cmd, '-profilename';
       		push @cmd, $profile_id;
	        push @cmd, '-reminderdate';
        	push @cmd, $due_date;
	        system(@cmd);
        	print "\nInvoked pymt_reminder mta_1\n";
	        ################################################################################

	}
 $k=$k+1; 
   }
 
}
print "\nFinished @ : ";
print scalar localtime()."\n";






#============================================#
# Subroutine to Check Holiday
#============================================#
sub is_holiday($,$,$,$){

#print "\nin get holiday()\n";

my @dom = (0,0,0,0,0,0,0,0,0,0);
my @moy = (0,0,0,0,0,0,0,0,0,0);
my @year = (0,0,0,0,0,0,0,0,0,0);

my $i = 0;
my $j = 0;
my $k = 0;

$ebufp = pcmif::pcm_perl_new_ebuf();
$pcm_ctxp = pcmif::pcm_perl_connect($db_no, $ebufp);

my $cal_name ="td_billing_calendar";
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

$i = $i - 1;
$j = $j - 1;
$k = $k - 1;
while($i > -1){
        if ( $mday == $dom[$i] && $mon == $moy[$j] && $year == $year[$k] ){
                print "\nDate $mday-$mon-$year is $wk and $dom[$i]-$moy[$j]-$year[$k] is Holiday in Calendar\n";
                $flag = 0;
		return $flag;
		#last;
        }
$i = $i - 1;
$j = $j - 1;
$k = $k - 1;
}
$flag = 1;

print "\n****Date $mday-$mon-$year is $wk and not a Holiday in Calendar****\n";
return $flag;

}
#################################################################################
# Subroutine is_weekend to get weekend or weekday
#################################################################################
sub is_weekend($){

#print "\nIn is_weekend() function, wday: $wday\n";
$wk = $wday >= 1 && $wday <= 5 ? "weekday" : "weekend";

return $wk;
}
###########################################
# Subroutine to get field value from flist
###########################################
sub get_flist_fld_value($)
{
         my $out_flist_string_row = shift;
         my @return_value = split(/\s/, $out_flist_string_row);
         my $temp_value = $return_value[$#return_value];
         if ($temp_value =~ /\"/){
                my @temp_array = split(/\"/, $temp_value);
                $temp_value = $temp_array[1];
         }
#	print "value : $temp_value\n";
        my $ret_flist_fld_value = $temp_value;

}

sub get_flist_fld_value_id($)
{
         my $out_flist_string_row = shift;
         my @return_value = split(/\s/, $out_flist_string_row);
         my $temp_value = $return_value[$#return_value-1];
	 my $temp_value1 = $return_value[$#return_value];

         if ($temp_value =~ /\"/){
                my @temp_array = split(/\"/, $temp_value);
                $temp_value = $temp_array[1];
         }
	if ($temp_value1 =~ /\"/){
                my @temp_array1 = split(/\"/, $temp_value1);
                $temp_value1 = $temp_array1[0];
         }

        $temp_value = "$temp_value"." $temp_value1";
        my $ret_flist_fld_value = $temp_value;

}
