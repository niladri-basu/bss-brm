#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: eventData.pm:RWSmod7.3.1Int:2:2007-Sep-28 04:10:52 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.
#
# eventData Perl Module for data extraction of the oldest record in the target table.

package eventData;
use aes;
use Env;
use Cwd;
require readConfigUtility;
$DEBUG = $ENV{'DEBUG'};

sub run(\@) {
print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               EVENT_DATA DATA EXTRACTION MODULE                       ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";
my $myUser=readConfigUtility::readConfigValue('DB_USER');
my $myPassword=readConfigUtility::readConfigValue('DB_PASSWD');
$PSWD = psiu_perl_decrypt_pw($myPassword);
my @myArguments=();
my @myTargetArguments=();
@myArguments= @_;
print "\n";
# for Windows_NT OS  we dont re-direct to /dev/null
my $myOS= $ENV{'OS'};
my $cmd;
if ( $myOS ne "Windows_NT" ) {
$cmd = "mv eventData_OldestEventAge.out eventData_OldestEventAge.out.back 2>/dev/null";
}
else {
$cmd = "mv eventData_OldestEventAge.out eventData_OldestEventAge.out.back";
}
system("$cmd");
my $next_index=0;
for $current_index (0..$#myArguments) {
 # if any argument is without ':' then append to end of the value of previous argument
 # assuming any column value does not have ':'
 if ($myArguments[$current_index] !~ /:/)  {
    $myTargetArguments[$next_index]= $myTargetArguments[$next_index]." ".$myArguments[$current_index];
    if ($myArguments[$current_index] =~ /'$/) {
       $next_index++;
    }
 }
 else
 {
    $myTargetArguments[$next_index]=$myArguments[$current_index] ;
    # in case there is space separated column value then do not do $j++
    if ($myArguments[$current_index] !~ /'/)
    {
     $next_index++;
    }
  }
}
print ("My target arguments: @myTargetArguments \n") if $DEBUG;
for $this_index (0..$#myTargetArguments) {
	($table_name,$column_name,$operator,$column_value) = split(/\:/,$myTargetArguments[$this_index]);
	$sqlcmd = "sqlplus -L  -s $myUser"."/"."$PSWD"."@"."$ORACLE_SID" ." @"."./eventData_OldestEventAge.sql $table_name $column_name $operator $column_value >> eventData_OldestEventAge.out";
	system("$sqlcmd");
}
return 0;
}
1;
