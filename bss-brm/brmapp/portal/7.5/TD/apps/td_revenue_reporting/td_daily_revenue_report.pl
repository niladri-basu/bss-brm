#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

#
# ==> One limitation: This script is not tested for dates before 1st Jan 1970 <==
#
use Time::Piece;
use pcmif;
my( $from_date, $to_date , $fromep, $toep) ;
my $CurTime = localtime();
if ($#ARGV < 1)
   { print STDERR "This program $0 must get 2 input parameters\n"; &usage ; exit(1) ;}

$from_date = $ARGV[0] ;
$to_date   = $ARGV[1] ;

if ( $from_date > $to_date )
{
   print STDERR "From_date must be less than or equal to To_date. Both dates must be in YYYYMMDD format and not be greater than today's date\n"; &usage; exit(1); }

$_ = $from_date ;
if (!/([0-9]){8}/)
{  print STDERR "Check if From_date is in YYYYMMDD format\n"; &usage; exit(1); }

$_ = $to_date ;
if (!/([0-9]){8}/)
{  print STDERR "Check if To_date is in YYYYMMDD format\n"; &usage; exit(1); }

print "Starting roaming Program...... $CurTime \n";
print "Dropping roaming objects from database.... \n";

system("sh ./td_revenue_rpt_drop.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}

print "Check if the objects have been dropped in DR database... \n";

system("sh ./td_revenue_monthly_drop_check.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
}
print "Check if the objects are created in DR database... \n";



print "calling Monthly report... \n";
&showDaysBetween ( $from_date , $to_date ) ;
system("sh ./td_revenue_rpt_monthly_create_check.sh");
if ($? == 256) {
    print "Exit\n";
    exit;
} 
print "Revenue Reporting is complete... $CurTime\n";
exit;
sub showDaysBetween {
    my( $from_date, $to_date , $fromep, $toep, $currdate, $currep, $sqldate, $sql_fromdate, $sql_todate) ;
    ( $from_date, $to_date) = @_ ;
    
    $fromep = &getEpochForGivenDate( "$from_date" ) ;
   #  print "Epoch for $from_date is $fromep\n" ;
    $currdate = $from_date ;
    $currep = $fromep ;
	$sql_fromdate= `date --date="$from_date" +"%d-%b-%Y"`;
	$sql_todate= `date --date="$to_date" +"%d-%b-%Y"`;
		
	if ($? == 256) {
			print "Exit\n";
			exit;
		}
	#print "sql_fromdate = $sql_fromdate\n" ;
	#print "sql_todate = $sql_todate\n" ;
	print "Calling script to generate monthly report: ".$sql_fromdate." ".$sql_todate;
	#system("sh","./td_revenue_report_script.sh","$sql_fromdate","$sql_todate");
	system("sh","./td_revenue_report_monthly.sh","$sql_fromdate","$sql_todate");
    $toep = &getEpochForGivenDate( "$to_date" ) ;
    #print "Epoch for $to_date is $toep\n" ;

    #print "Day = $currdate\n" ;
    while ( $currdate != $to_date )
        {
			$sqldate= `date --date="$currdate" +"%d-%b-%Y"`;
			#print "SQLDate = $sqldate\n" ;
			$currep += 86400 ;
			#print "Day_epoch = $currep\n" ;
			$currdate = &getYYYYMMDDforEpoch( $currep ) ;
			#print "Day = $currdate\n" ;
			##$tosqldate = &ConvertDateinSql( "$currdate" ) ;
			#print "Calling script to generate daily report: ".$sqldate."\n";
			system("sh","./td_revenue_rpt_daily.sh","$sqldate");
			if ($? == 256) {
			print "Exit\n";
			exit;
		  }
		    
        }
}

## Get the epoch value for given day. Current system date is the reference for this.
## We can get the epoch for current date-time using the time() function, the by adding or substracting 86400 seconds
## (i.e. seconds in one day) we will find out the epoch number for any given day
sub getEpochForGivenDate {
    my ($indate, $today, $day, $month, $year, $nowtime, $newday, $newtime) ;
    ($indate) = @_ ; ## Input date must be in YYYYMMDD format

    $nowtime = time ;
    ($day, $month, $year) = (localtime($nowtime))[3,4,5] ;
    $year = $year + 1900 ; $month ++ ;
    $today="$year$month$day" ;
	#print "today = $today\n" ;
	#print "nowtime = $nowtime\n" ;
    if ( $indate == $today )
         { return $nowtime ; }
    elsif ( $indate lt $today )
         {
			$nowday = &getYYYYMMDDforEpoch( $nowtime ) ;
		#	print "nowday = $nowday\n" ;
           $newtime = $nowtime - 86400 ;
           $newday = &getYYYYMMDDforEpoch( $newtime ) ;
           print "Indate=$indate Newday=$newday\n" if ($ENV{DETAIL_DEBUG} eq "1") ;
           while ( $newday != $indate )
                 {
                   $newtime = $newtime - 86400 ;
                   $newday = &getYYYYMMDDforEpoch( $newtime ) ;
                   print "Indate=$indate Newday=$newday\n" if ($ENV{DETAIL_DEBUG} eq "1") ;
                 }
           return $newtime ;
         }
    else
         {
           $newtime = $nowtime + 86400 ;
           $newday = &getYYYYMMDDforEpoch( $newtime ) ;
           print "Indate=$indate Newday=$newday\n" if ($ENV{DETAIL_DEBUG} eq "1") ;
           while ( $newday != $indate )
                 {
                   $newtime = $newtime + 86400 ;
                   $newday = &getYYYYMMDDforEpoch( $newtime ) ;
                   print "Indate=$indate Newday=$newday\n" if ($ENV{DETAIL_DEBUG} eq "1") ;
                 }
           return $newtime ;
         }
}

sub usage {
    print STDERR "\nUsage : $0 <from_date in YYYYMMDD> <to_date in YYYYMMDD>\n\n( Purpose of this script is to revenuw details between 2 given dates, dates should not be in future )\n\n" ;
}

sub getYYYYMMDDforEpoch {

   my $stamp ;
  ($stamp) = @_ ;
  ## Given a epoch number, using localtime function, compose the date string in YYYYMMDD
  return ( (localtime($stamp))[5] + 1900 ) . ( (length(( (localtime($stamp))[4] + 1 )) < 2)? "0".( (localtime($stamp))[4] + 1 ) : ( (localtime($stamp))[4] + 1 ) ) . ( ( length((localtime($stamp))[3]) < 2)? "0".(localtime($stamp))[3] : (localtime($stamp))[3] );

}
