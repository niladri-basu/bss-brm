#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: auditAge.pm:RWSmod7.3.1Int:2:2007-Sep-28 04:10:55 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.
#
# auditAge Perl module for data extraction of the oldest record in the audit tables
# as specified in the file pin_db_alert.conf.

package auditAge;
use aes;
use Env;
use Cwd;
require readConfigUtility;

sub run(\@) {
print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               AUDIT_AGE DATA EXTRACTION MODULE                        ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";
my $myUser=readConfigUtility::readConfigValue('DB_USER');
my $myPassword=readConfigUtility::readConfigValue('DB_PASSWD');
$PSWD = psiu_perl_decrypt_pw($myPassword);

my @ArgumentList=();
my @myArguments=();
$def_aud_tab_names = readConfigUtility::readConfigValue('DEFAULT_AUDIT_TABLES');
@ArgumentList = split(/\,/,$def_aud_tab_names);
@myArguments= @_;

$myDefaultCount=$#ArgumentList;

for $i (0 .. $#myArguments) {
  $ArgumentList[$i+1+$myDefaultCount]=$myArguments[$i];
}

print "\n";
# for Windows_NT OS  we dont re-direct to /dev/null
my $myOS=$ENV{'OS'};
my $cmd;
if ( $myOS ne "Windows_NT" ) {
$cmd = "mv auditAge_AuditHistoryAge.out auditAge_AuditHistoryAge.out.back 2> /dev/null";
}
else {
$cmd = "mv auditAge_AuditHistoryAge.out auditAge_AuditHistoryAge.out.back"; 
}
system("$cmd");
for $i (0..$#ArgumentList) {
	$table_name="";
	$table_name=$ArgumentList[$i];
	$dbh = "sqlplus -L -s $myUser"."/"."$PSWD"."@"."$ORACLE_SID" ." @"."./auditAge_AuditHistoryAge.sql $table_name >> auditAge_AuditHistoryAge.out";
	system("$dbh");
	}
return 0;
}

1;
