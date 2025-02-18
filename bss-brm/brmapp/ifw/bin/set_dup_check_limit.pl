#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

###############################################################################
#
#       Copyright (c) 2003 - 2006 Oracle. All rights reserved.
#
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored or transmitted
#       only in accordance with a valid Oracle license or sublicense agreement.
#	
#########################################################################################
# Utility script for PipeLine ---> Set The Duplicate Check Limit
# To set the duplicate check limit, set # of days days in the variable $No_OF_Days which is defind
# in this script. This script will calclate the exact date based on the # of days set in the
# variable $No_OF_Days. Please note, the exact date will be calculated by deducting the # of days
# from the current date.
##################################################################################################
#ifw.Pipelines.ALL_RATE.Functions.PreProcessing.FunctionPool.DuplicateCheck.BufferLimit = 20020601
#ifw.Pipelines.ALL_RATE.Functions.PreProcessing.FunctionPool.DuplicateCheck.StoreLimit = 20020601
##################################################################################################

use Switch;

my $No_Of_Days_BufferLimit = 7;
my $No_Of_Days_StoreLimit = 10;
my $No_OF_Days=0;

if (@ARGV == 2) {
  $No_Of_Days_BufferLimit = $ARGV[0];
  $No_Of_Days_StoreLimit = $ARGV[1];
}

if("a$ENV{'IFW_HOME'}" ne "a")
{
   $ENV{"IFW_HOME_PATH"} = $ENV{'IFW_HOME'};
}
else 
{ if ("a$ENV{'INTEGRATE_HOME'}" ne "a") {
   $ENV{"IFW_HOME_PATH"} = $ENV{'INTEGRATE_HOME'};  
  }
}

# This function is to calculate the exact date based on the # of days 
# set in the variable $No_OF_Days
sub calculate_date {
  @now = localtime(time());
  $month = $now[4]+1;
  $day = $now[3];
  $year = $now[5]+1900;

  # Subtrace No_OF_Days from the current day.
  $day = $day - $No_OF_Days;

  # While the day is less than or equal to 0, deincrement the month.
  while ($day <= 0) {
    $month = $month -1;
    if($month == 0){
      $year = $year -1;
      $month = 12;
    }
    # Add the number of days appropriate to the month
    switch ($month) {
      case [1,3,5,7,8,10,12] { $day =$day + 31;}
      case [4,6,9,11] { $day =$day + 30;}
      case [2] {
        if (($year %4) == 0) {
          if(($year %400) == 0) {
             $day = $day + 29;
          }
          else {
            if (($year %100) == 0) {
              $day = $day + 28;
            }
            else {
              $day = $day + 29;
            }
          }
        }
        else {$day = $day + 28;}
      }
    }
  }
}

sub set_dup_check_limit {
  if("a$ENV{'IFW_HOME_PATH'}" eq "a")
  {
     print "Pipeline home not found, aborting....\n";
     return 1;
  }

  # Here dynamically created the set_dup_check_limit.reg
  $No_OF_Days = $No_Of_Days_BufferLimit;
  if (($No_OF_Days =~ m/\D/g)) {
    print "Error: No_OF_Days_BufferLimit must be a positive integer.\n";
    exit 1;
  }
  calculate_date;
  $bufLimit = sprintf("%d%02d%02d",$year, $month, $day);  
  $sem_buf_entry = "ifw.Pipelines.ALL_RATE.Functions.PreProcessing.FunctionPool.DuplicateCheck.BufferLimit = $bufLimit\n";

  $No_OF_Days = $No_Of_Days_StoreLimit;
  if (($No_OF_Days =~ m/\D/g)) {
    print "Error: No_OF_Days_StoreLimit must be a positive integer.\n";
    exit 1;
  }
  calculate_date;
  $storeLimit = sprintf("%d%02d%02d", $year, $month, $day);
  $sem_store_entry="ifw.Pipelines.ALL_RATE.Functions.PreProcessing.FunctionPool.DuplicateCheck.StoreLimit = $storeLimit\n";

  open(INSTRM, ">$ENV{'IFW_HOME_PATH'}/semaphore/set_dup_check_limit.reg") || die "Cannot open file :$!";
  print INSTRM $sem_buf_entry;
  print INSTRM $sem_store_entry;
  close (INSTRM);
  open(OUTSTRM, ">>$ENV{'IFW_HOME_PATH'}/semaphore/semaphore.reg") || die "Cannot open file :$!";
  print OUTSTRM $sem_buf_entry;
  print OUTSTRM $sem_store_entry;
  close(OUTSTRM);
  
  print "Semaphore for set_dup_check_limit is sent\n";
}

set_dup_check_limit;

exit 0;
