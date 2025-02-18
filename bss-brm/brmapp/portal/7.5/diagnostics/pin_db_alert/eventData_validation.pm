#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: eventData_validation.pm:RWSmod7.3.1Int:1:2007-Jul-03 00:51:40 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.
#
# eventData_validation Perl Module for validating age of the oldest record 
# in the target table against the threshold data for that particular table, 
# in the file eventData_validation_OldestEventAge.conf.

package eventData_validation;
use Env;

sub validate(\@) {
print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               EVENT_DATA VALIDATION MODULE                            ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";
$config_file="eventData_validation_OldestEventAge.conf";
$data_infile="eventData_OldestEventAge.out";
$validation_outfile="eventData_validation_OldestEventAge.out";

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
				print VLD_OUT "\neventData_OldestEventAge".":FAIL"."."."WARNING".":"."\"Oldest record in $table_name older than specified threshold."."\"";
			}
			else {
				print VLD_OUT "\neventData_OldestEventAge".":PASS"."."."NORMAL".":"."\"Oldest record in $table_name within the specified threshold of days."."\"";
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
