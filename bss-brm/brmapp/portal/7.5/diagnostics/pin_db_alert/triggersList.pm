#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=========================================================
#      Copyright (c) 2007 Oracle. All rights reserved.
#
#      This material is the confidential property of Oracle Corporation or
#      its licensors and may be used, reproduced, stored or transmitted only
#      in accordance with a valid Oracle license or sublicense agreement.
#
#
# creates the list of valid triggers in a given schema.
#
#=============================================================

package triggersList;
require Exporter;
use aes;
use Env;

require readConfigUtility;

sub run {

print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               TRIGGER LIST DATA EXTRACTION MODULE                     ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";

my $myPassword=readConfigUtility::readConfigValue('DB_PASSWD');
my $myUser=readConfigUtility::readConfigValue('DB_USER');
$DB_PWD = psiu_perl_decrypt_pw($myPassword);
$DB_USER = $myUser;
$sqlcmd = "sqlplus -L -s $DB_USER/$DB_PWD"."@"."$ORACLE_SID < triggersList.sql";
system("$sqlcmd");
return 0;
}
1;

