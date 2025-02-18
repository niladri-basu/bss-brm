#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: auditSize_validation.pm:RWSmod7.3.1Int:1:2007-Jul-03 00:51:48 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.
#

# auditSize validation Perl module which validates the size of the
# target audit tables against the values specified for those tables in the file
# auditSize_validation_AuditTableSize.conf.

package auditSize_validation;
use Env;

sub validate(\@) {
print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               AUDIT_SIZE VALIDATION MODULE                            ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";
$config_file="auditSize_validation_AuditTableSize.conf";
$data_infile="auditSize_AuditTableSize.out";
$validation_outfile="auditSize_validation_AuditTableSize.out";

open(CFG_IN,"<",$config_file) || die "cannot open configuration file : $config_file";
open(DAT_IN,"<",$data_infile) || die "cannot open data input file    : $data_infile";
open(VLD_OUT,">",$validation_outfile) || die "cannot open validation file : $!";

@ConfigData=<CFG_IN>;

foreach $line_data (@ConfigData) {

	if($line_data =~ /^$/) {
        }
	else {
		chop($line_data);
		($plugin_KPID,$config_table_name,$config_num_rows)=split(/\:/,$line_data);
		$config{$config_table_name}=$config_num_rows;
	}

}
		
@InputData=<DAT_IN>;

foreach $line_data (@InputData) {
	
	if($line_data =~ /^$/) {
	}
	else {
		$config_num_rows = 0;
		chop($line_data);
		($table_name,$num_rows)=split(/\|/,$line_data);
		$config_num_rows = $config{$table_name};
		if($config_num_rows != 0) {
			if ($config_num_rows < $num_rows) {
				print VLD_OUT "\nauditSize_AuditTableSize".":FAIL"."."."WARNING".":"."\"$table_name size larger than specified threshold."."\"";
			}
			else {
				print VLD_OUT "\nauditSize_AuditTableSize".":PASS"."."."NORMAL".":"."\"$table_name size within specified threshold."."\"";
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
