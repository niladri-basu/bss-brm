#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)$Id: add_new_pipeline_objects_74ps1.pl /cgbubrm_main.rwsmod/1 2011/09/07 05:59:10 hsnagpal Exp $
#
# $Header: bus_platform_vob/upgrade/Integrate/74_74ps1/oracle/add_new_pipeline_objects_74ps1.pl /cgbubrm_main.rwsmod/1 2011/09/07 05:59:10 hsnagpal Exp $
#
# add_new_pipeline_objects_74ps1.pl
#
# Copyright (c) 2009, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      add_new_pipeline_objects_74ps1.pl - This module will result in creating new tables or modifying existing
#      table to add new columns.
#
#    DESCRIPTION
#      This File will contain subroutine to create objects or modify existing object behaviour
#      This includes adding new tables or adding new columns to the existing table.
#      This file will be called from the driver file pin_74_74ps1_pipeline_upgrade.pl.
#      Apart from that, there is another script "pin_upg_common.source" which will also
#      get executed. This script has some common Database APIs which willbe used by the
#      Feature-Specific Pipeline upgrade scripts, for its internal validations.
#
#      The Pipeline upgrade feature-script is a consolidated file of all schema changes which will
#      result in Pipeline schema upgrade. Files defined in the array ALL_PIPELINE_ADD_OBJECTS
#      will contain all the relevant object modification files for pipeline upgrade.
#
#    NOTES
#      This Script will be used to execute the common api script "pin_upg_common.source" and
#      feature specific pipeline scripts
#      as defined in the array ALL_PIPELINE_ADD_OBJECTS which will result in Pipeline
#      upgrade.

#      The Driver File for pipeline upgrade is the script "pin_74_74ps1_pipeline_upgrade.pl"
#      will call this perl script (add_new_pipeline_objects_74ps1.pl) through one of its wrappers APIs
#      named "upgrade_pipeline_db()".

#      How this script will work

#      This Perl file will invoke the API "ExecuteSQL_Statement_From_File" which will execute
#      Feature-specifc sql files in the order as specified in the array ALL_PIPELINE_ADD_OBJECTS.
#      This will in turn create new objects or modify the existing database object
#      which are necessary for upgrade of Pipeline.
#      For error or exception handling please refer to the Error Handling Section.
#
#       Error Handling
#
#       The Error Handling will be done by logging the error messages in the log file.
#       This log file is add_new_pipeline_objects_74ps1.log which will be generated in $IFW_HOME/log/ directory.
#       The log file will record the error messages from the first instance of the ORA-Error Occurring till
#       the end of the error message to record entire error details.
#       So whenever there will be an error as part of execution of this script,
#       a value is returned at the end of this script. Based on that return value, it will
#       be easier to track, the point of failure [in terms of name of feature scripts],
#       when this script is called by the wrapper APIs [upgrade_pipeline_db()] from
#       the driver file "pin_74_74ps1_pipeline_upgrade.pl". So in case a failed result value is returned,
#       the further execution process of upgrade will be stopped.
#       This stopping of the further execution will be handled in the driver file.

#    MODIFIED   (MM/DD/YY)
#    rasarka     11/11/09 - Creation
#======================================================================================

use warnings;
use Env;

our $IFW_UPGRADE_DIR = "$IFW_HOME/upgrade/scripts";
our $IFW_LOG_DIR     = "$IFW_HOME/log";

require "$IFW_UPGRADE_DIR/pin_res.pl";
require "$IFW_UPGRADE_DIR/pin_functions.pl";
require "$IFW_HOME/upgrade/pipeline_upgrade.cfg";
require "$IFW_UPGRADE_DIR/pipeline_tables.cfg";
require "$IFW_UPGRADE_DIR/pin_oracle_functions.pl";

our $IFW_HOME;
our %MAIN_DM;
our %MAIN_CM;
our %CM;
our %DM;

our $SETUP_LOG_FILENAME        = "$IFW_LOG_DIR/upgrade_pipeline_db_74ps1.log";
our $SETUP_LOG_ACCESS_TYPE     = "WRITE";
our $PIPELINE_ADD_OBJ_LOG_FILE = "$IFW_LOG_DIR/add_new_pipeline_objects_74ps1.log";
our $StatusFlag                = "TRUE";

our @ALL_PIPELINE_ADD_OBJECTS =
    ( "pin_upg_common.source","add_new_tables_74ps1.source", "default_values_74ps1.source" );

sub upgrade_pipeline_db {
	my $ReadString        = "";
	my $Result            = -1;
	my $writestatement    = "";
	my $pipeline_upg_file = "";
	my $FirstElem         = $ALL_PIPELINE_ADD_OBJECTS[0];
	%DM = %MAIN_DM;
	%CM = %MAIN_CM;
	open( TMPFILE1, ">$PIPELINE_ADD_OBJ_LOG_FILE" )
	    || die "cannot read $PIPELINE_ADD_OBJ_LOG_FILE \n";

	if ( $FirstElem eq "" ) {
		$Result = 2;
		print "No files to process. \n";
		$writestatement = "No files to process. \n";
		print TMPFILE1 ("$writestatement \n");

	} else {

		foreach $pipeline_upg_file (@ALL_PIPELINE_ADD_OBJECTS) {

                        print "################################################ \n";
                        &OpenLogFile( $SETUP_LOG_FILENAME, $SETUP_LOG_ACCESS_TYPE ); 
			&ExecuteSQL_Statement_From_File(
				"$IFW_UPGRADE_DIR/$pipeline_upg_file",
				$StatusFlag, $StatusFlag, %{ $DM{"db"} } );
			open( TMPFILE2, "$SETUP_LOG_FILENAME" )
			    || die "cannot read $SETUP_LOG_FILENAME \n";
			while ( $ReadString = <TMPFILE2> ) {
				if ( $ReadString =~
					/ORA-([\d]*):.*|SP2-([\d]*):.*/ )
				{
					$Result = 1;
				}

				if ( $Result == 1 ) {
					$writestatement = "$ReadString \n";
					print TMPFILE1 ("$writestatement \n");
				}

			}
			close(TMPFILE2);
			unlink "$SETUP_LOG_FILENAME";

			if ( $Result == 1 ) {

				print
"Execution of pipeline upgrade script $pipeline_upg_file unsuccessful \n";
				$writestatement =
"Execution of pipeline upgrade script $pipeline_upg_file is unsuccessful \n";
                                print TMPFILE1 ("$writestatement \n"); 
                                print "################################################ \n";
				last;
			}

			elsif ( $Result != 1 )

			{
				$Result = 0;
				print
"Execution of pipeline upgrade script $pipeline_upg_file successful \n";
				$writestatement =
"Execution of pipeline upgrade script $pipeline_upg_file successful  \n";
				print TMPFILE1 ("$writestatement \n");
                                print "################################################ \n";
				next;
			}
		}
	}

	close(TMPFILE1);
	return $Result;
}
1;

