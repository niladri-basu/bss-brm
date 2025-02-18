#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
# @(#)$Id: pin_gen_classid_values.pl /cgbubrm_7.5.0.portalbase/2 2014/04/23 17:18:07 vivilin Exp $
# 
# Copyright (c) 2012, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Generate classid_values.txt from db for REL
#
#=============================================================

use Cwd;


require "pin_res.pl";
require "pin_functions.pl";
require "../pin_setup.values";

&generate_rel_classid_values ( $0 );




#########################################
# Configure database for the Rated Event Loader
#########################################
sub generate_rel_classid_values {

  require "pin_".$MAIN_DM{'db'}->{'vendor'}."_functions.pl";
  require "pin_cmp_dm_db.pl";
  local ( %DM ) = %MAIN_DM;

  # Call the routine which generates a "classid_values.txt" file containing the storable class names along with their classid
  # values required by the REL pre-processing script.
  #
  &GenerateClassIdValues(%{$DM{"db"}});

 }
 

#The routine generates a file containing the storable class names and their classid values in the form of an associative array
#required by the REL preprocess script.This script was needed to ensure that the preprocessor script always received
#the latest classid values from the db.

sub GenerateClassIdValues {

  local( %DB ) = @_;
  #the file will contain the result set of our query.
  local( $tmpFile ) = $PIN_TEMP_DIR."/tmp.out";
  local( $ReadString );
  local( %classIds); #associative array used to hold storable class names and their values.
  local( $storable_class_name);
  local( $storable_class_value);

  &ExecuteSQL_Statement(
    "select name,obj_id0 from dd_objects_t union all select name,obj_id0 from dd_types_t order by name asc;",
     TRUE, TRUE, %DB);


  open( TMPFILE, $tmpFile ) || die "$ME: cannot read $tmpFile\n";

  while ($ReadString = <TMPFILE>){
        chomp($ReadString);
        #trim white spaces.
        $ReadString =~ s/^\s+//;
        $ReadString =~ s/\s+$//;

        #get the storable class name.
        if  ($ReadString =~ /^\//) {
                $storable_class_name= $ReadString;
        }
	#get the corresponding storable class id value
        elsif  ($ReadString =~ /^[0-9]+$/){
                $classIds{$storable_class_name} = $ReadString;
        }
  }
  close(TMPFILE);

  #Create file "classid_values.txt" containing an associative array with storable class name as the key and
  #classid as the value.

  $tmpFile = $RATED_EVENT_LOADER{'pin_cnf_location'} . "/classid_values.txt";

  open(TMPFILE, ">$tmpFile") || die "$ME: cannot open $tmpFile\n"; ;
  print TMPFILE "%classIds = (";
  while (($storable_class_name, $storable_class_value) = each(%classIds)){
        print TMPFILE "\"". $storable_class_name."\",".$storable_class_value.",\n";
  }
  print TMPFILE ");"."\n";
  close(TMPFILE);
}
