#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#====================================================================================
#      Copyright (c) 2007 Oracle. All rights reserved.
#
#      This material is the confidential property of Oracle Corporation or
#      its licensors and may be used, reproduced, stored or transmitted only
#      in accordance with a valid Oracle license or sublicense agreement.
#
# This is the procedure Validation module
#====================================================================================

package proceduresList_validation;
use Env;
require Exporter;

sub validate
{

print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               PROCEDURE LIST VALIDATION MODULE                        ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";

    $data_file="proceduresList_PROCEDURES.out";
    $data_file1="proceduresList_validation_PROCEDURES.conf";
    $result_file ="proceduresList_validation_PROCEDURES.out";

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
                ($proc_name,$proc_status)=split(/[\s]+/,$line_var);
                $proc_array{$proc_name} = $proc_status;
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
                ($proc_name1,$proc_status1)=split(/[\s]+/,$line_var1);
                $stat_val1 = $proc_array{$proc_name1};
                if ($stat_val1 eq "") {
                        print WAT "proceduresList_PROCEDURES:FAIL"."."."MAJOR:PROCEDURE ". $proc_name1 ." is missing \n";
                }
                else {
                if ($stat_val1 eq $proc_status1 ) {
                        print WAT "proceduresList_PROCEDURES:PASS"."."."NORMAL:PROCEDURE ".$proc_name1."\n" ;
                } else {
                if ($stat_val1 ne $proc_status1 )
                   {
                        print WAT "proceduresList_PROCEDURES:FAIL"."."."MAJOR:PROCEDURE ". $proc_name1 ." is invalid \n";
                   }
                }
               }
        }
}
close (WAT);
close (DAT1);
return 0;
}


1;

