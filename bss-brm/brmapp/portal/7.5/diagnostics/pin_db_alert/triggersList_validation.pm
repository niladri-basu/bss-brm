#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#====================================================================================
#      Copyright (c) 2007 Oracle. All rights reserved.
#
#      This material is the confidential property of Oracle Corporation or
#      its licensors and may be used, reproduced, stored or transmitted only
#      in accordance with a valid Oracle license or sublicense agreement.
#
# This is the Trigger Validation module
#====================================================================================

package triggersList_validation;
use Env;
require Exporter;

sub validate
{

print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               TRIGGER LIST VALIDATION MODULE                          ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";

$data_file="triggersList_ACTIVETRIGGERS.out";
$data_file1="triggersList_validation_ACTIVETRIGGERS.conf";
$result_file ="triggersList_validation_ACTIVETRIGGERS.out";
open(DAT, $data_file) || die("Could not open file!");
open(DAT1, $data_file1) || die("Could not open file!");
open(WAT, ">$result_file"|| die("Could not open file!"));
@list_data=<DAT>;

foreach $line_var (@list_data)
{
        if($line_var =~ /^$/) {
                #       print "Blnk line";
        }
        else {
                chop ($line_var);
                ($trig_status,$trig_name)=split(/[\s]+/,$line_var);
                $trig_array{$trig_name} = $trig_status;
        }
}

close (DAT);

@list_data1=<DAT1>;

foreach $line_var1 (@list_data1)
{
        if($line_var1 =~ /^$/) {
                #       print "Blnk line";
        }
        else {
                chop ($line_var1);
                ($trig_status1,$trig_name1)=split(/[\s]+/,$line_var1);
                $stat_val1 = $trig_array{$trig_name1};
                if ($stat_val1 eq "") {
                        print WAT "triggersList_ACTIVETRIGGERS:FAIL"."."."MAJOR:TRIGGER ". $trig_name1 ." is missing \n";
                }
                else {
                if ($stat_val1 eq $trig_status1 ) {
                        print WAT "triggersList_ACTIVETRIGGERS:PASS"."."."NORMAL:TRIGGER ".$trig_name1."\n" ;
                } else {
                        print WAT "triggersList_ACTIVETRIGGERS:FAIL"."."."MAJOR:TRIGGER ". $trig_name1 ." is invalid \n";
                }
                }
        }
}
close (WAT);
close (DAT1);
return 0;
}


1;

