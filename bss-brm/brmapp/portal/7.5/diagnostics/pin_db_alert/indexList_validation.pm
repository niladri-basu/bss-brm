#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

#====================================================================================
#
#      Copyright (c) 2007 Oracle. All rights reserved.
#
#      This material is the confidential property of Oracle Corporation or
#      its licensors and may be used, reproduced, stored or transmitted only
#      in accordance with a valid Oracle license or sublicense agreement.
#
# This is the Index Validation module
#====================================================================================

package indexList_validation;
use Env;
require Exporter;

sub validate
{

print "\n#######################################################################################";
print "\n########                                                                       ########";
print "\n########               INDEX LIST VALIDATION MODULE                            ########";
print "\n########                                                                       ########";
print "\n#######################################################################################";
print "\n";

$data_file="indexList_INDEXES.out";
$data_file1="indexList_validation_INDEXES.conf";
$result_file ="indexList_validation_INDEXES.out";
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
                        ($table_name,$column_name,$index_id,$index_type)=split(/[\s]+/,$line_var);
                        $index_val=$ideal_arr{$index_id};
                        if ($index_val eq "") {
                                $ideal_arr{$index_id} = $table_name.":".$column_name.":".$index_type;
                        }
                        else {
                                ($table_name1,$column_name1,$index_type1)=split(/:/,$index_val);
                                $column_name = $column_name1 . "," . $column_name;
                                $ideal_arr{$index_id} = $table_name.":".$column_name.":".$index_type;
                        }
                }
        }

        @ideal_values = %ideal_arr;

close (DAT);

@list_data1=<DAT1>;

        foreach $line_var1 (@list_data1)
        {
                if($line_var1 =~ /^$/) {
                                #       print "Blnk line";
                }
                else {
                                        chop ($line_var1);
                                        ($table_name11,$column_name11,$index_id11,$index_type11)=split(/[\s]+/,$line_var1);
                                        $index_val1=$ideal_arr11{$index_id11};
                        if ($index_val1 eq "") {
                        $ideal_arr11{$index_id11} = $table_name11.":".$column_name11.":".$index_type11;
                                                }
                        else {
                                        ($table_name12,$column_name12,$index_type12)=split(/:/,$index_val1);
                                        $column_name11 = $column_name12.",".$column_name11;
                                        $ideal_arr11{$index_id11} = $table_name11.":".$column_name11.":".$index_type11;
                                                }
                }
        }
        @upg_values = %ideal_arr11;


               foreach $key_val (keys(%ideal_arr11)) {
                 $ind_val_chk = $ideal_arr{$key_val};
                   chop ($ind_val_chk);
                   if ($ind_val_chk eq "") {
                   print WAT "indexList_INDEXES:FAIL.MAJOR: "."$key_val"." INDEX MISSING \n";
                        }
                  else {
                       if ($ideal_arr11{$key_val} eq $ideal_arr{$key_val}) {
                        print WAT "indexList_INDEXES".":"."PASS"."."."NORMAL:"."$key_val"."\n";
                            }
                       else {
                        print WAT "indexList_INDEXES:FAIL.MAJOR: "."$key_val"." NON-MATCHING POSITION OF COLUMNS OR NON-MATCHING UNIQUENESS \n";
                           }


                     }
                  }


close (DAT1);
close (WAT);

return 0;
}


1;

