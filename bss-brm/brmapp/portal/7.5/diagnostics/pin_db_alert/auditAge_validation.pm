#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: auditAge_validation.pm:RWSmod7.3.1Int:1:2007-Jul-03 00:51:56 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.

# auditAge validation Perl module which validates the age of the oldest record in the 
# target audit tables against the values specified for those tables in the file 
# auditAge_validation_AuditHistoryAge.conf.

package auditAge_validation;
use Env;

sub validate(\@) {
print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               AUDIT_AGE VALIDATION MODULE                             ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";
$config_file="auditAge_validation_AuditHistoryAge.conf";
$data_infile="auditAge_AuditHistoryAge.out";
$validation_outfile="auditAge_validation_AuditHistoryAge.out";

open(CFG_IN,"<",$config_file) || die "cannot open configuration file : $config_file";
open(DAT_IN,"<",$data_infile) || die "cannot open data input file    : $data_infile";
open(VLD_OUT,">",$validation_outfile) || die "cannot open validation file : $!";

@ConfigData=<CFG_IN>;

foreach $line_data (@ConfigData) {

	if($line_data =~ /^$/) {
        }
	else {
		chop($line_data);
		($plugin_KPID,$config_table_name,$config_num_days)=split(/\:/,$line_data);
		$config{$config_table_name}=$config_num_days;
	}

}
		
@InputData=<DAT_IN>;

foreach $line_data (@InputData) {
	
	if($line_data =~ /^$/) {
	}
	else {
		$config_num_days = 0;
		chop($line_data);
		($table_name,$num_days)=split(/\|/,$line_data);
		$config_num_days = $config{$table_name};
		if($config_num_days != 0) {
			if ($config_num_days < $num_days) {
				print VLD_OUT "\nauditAge_AuditHistoryAge".":FAIL"."."."WARNING".":"."\"Oldest record in audit table $table_name older than specified threshold."."\"";
			}
			else {
				print VLD_OUT "\nauditAge_AuditHistoryAge".":PASS"."."."NORMAL".":"."\"Oldest record in audit table $table_name within the specified threshold of days."."\"";
			}
		}
	}
}
print VLD_OUT "\n";
print "\n";
close CFG_IN;
close DAT_IN;
close VLD_OUT;

return 0;
}

1;
