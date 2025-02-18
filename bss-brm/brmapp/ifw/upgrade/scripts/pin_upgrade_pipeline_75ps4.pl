#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)$Id: pin_upgrade_pipeline_75ps4.pl /cgbubrm_7.5.0.rwsmod/2 2013/01/23 07:40:21 hsnagpal Exp $
#
# $Header: bus_platform_vob/upgrade/Integrate/75_75ps4/oracle/pin_upgrade_pipeline_75ps4.pl /cgbubrm_7.5.0.rwsmod/2 2013/01/23 07:40:21 hsnagpal Exp $
#
# pin_75ps4_pipeline_upgrade.pl
#
# Copyright (c) 2009, 2013, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      pin_75ps4_pipeline_upgrade.pl - this script is the main driver file
#      for upgrading the BRM PIPELINE DB from 74 to 75
#
#    DESCRIPTION
#      This script is the main driver file for upgrading the the BRM PIPELINE DB from 74 to 74ps10
#      This script will call the exposed API pipeline_db_upgrade_75_() which will do the Pipeline Upgrade.

#      The exposed APIs will be called from this file.
#      The API will handle the success and failure of its operation individually.
#
#    NOTES
#
#      Here are the details of the Function which are called by the Driver Perl File.
#      pipeline_db_upgrade_75(): This Subrotine will call the function upgrade_pipeline_db from within.
#      This function , upgrade_pipeline_db() & modify_columns_75(), which will result in upgrading the Pipeline Database.
#      The upgrade_pipeline_db()  & modify_columns_75() will return an execution result value as part of its execution.
#      This pipeline_db_upgrade_75 will then use the result value to validate
#      the success or failure of the execution of the driver script and write appropriate message into the log file
#      "pin_75_pipeline_upgrade.log".
#

#       For example

#       e.g. In the Driver file "pin_75_pipeline_upgrade.pl" there will be a subroutine named
#       pipeline_db_upgrade_75() which will be the main function for upgrade. This will call the
#       wrapper API ,upgrade_pipeline_db()  & modify_columns_75() which will result in calling feature-specific pipleine scripts
#       and upgrade the Pipleine Database . An example is shown as how we will utilize the result value.

#      1) If the value of ret_val is 0 continue execution,
#      2) If that is non-zero, indicating an error stop the execution of the API upgrade_pipeline_db()  or modify_columns_75() and exit
#      out of the function pipeline_db_upgrade_75() giving appropriate error message. Print the error function
#      in the log file.
#      3) Please refer section Error Logging to know where error logs are generated.
#

#	Error Logging
#	----------------

#	Error logging will happen in the following file
#       "$IFW_HOME/log/pin_75_pipeline_upgrade.log"

#      Additional Information :

#    MODIFIED   (MM/DD/YY)
#    hsnagpal    07/20/11 - Creation
#======================================================================

use strict;
use warnings;
use Env;

our $IFW_UPGRADE_DIR = "$IFW_HOME/upgrade/scripts";
our $IFW_LOG_DIR     = "$IFW_HOME/log";

require "$IFW_UPGRADE_DIR/pin_res.pl";
require "$IFW_UPGRADE_DIR/add_new_pipeline_objects_74ps1.pl";
require "$IFW_UPGRADE_DIR/modify_column_74ps6.pl";
require "$IFW_UPGRADE_DIR/modify_column_75.pl";
require "$IFW_UPGRADE_DIR/modify_column_75ps1.pl";
require "$IFW_UPGRADE_DIR/pipeline_schema_update_75ps2.pl";

our %MAIN_DM;
our %MAIN_CM;

our %CM;
our %DM;
our $ret_val = -1;

%DM = %MAIN_DM;
%CM = %MAIN_CM;


our @EXECUTE_ALL_PIPELINE_UPGRADE_SCRIPTS = ("upgrade_pipeline_db()",
					     "modify_columns_74ps6()",
					     "modify_columns_75()",
					     "modify_columns_75ps1",
					     "modify_columns_75ps2");

print "now executing pipeline upgrade module ... \n";

	$ret_val = &pipeline_db_upgrade_75();

	if ( $ret_val == 0 ) {
		print "pipeline upgrade to BRM 75ps4 is successful. \n";
		print
	"please see the pipeline upgrade log file at $IFW_LOG_DIR/pin_75ps4_pipeline_upgrade.log \n";
		print "################################################ \n";
	} elsif ( $ret_val == 2 ) {
		print
	"there are no function apis to process. Pipeline upgrades will not continue. \n";
		print
	"please see the pipeline upgrade log file at $IFW_LOG_DIR/pin_75ps4_pipeline_upgrade.log \n";
		print "################################################ \n";
	} else {
		print "the pipeline upgrade did not happen successfully \n";
		print
	"please see the pipeline upgrade log file at $IFW_LOG_DIR/pin_75ps4_pipeline_upgrade.log \n";
		print "################################################ \n";  
	}

sub pipeline_db_upgrade_75 {
	my $upgrade_api = "";
	my $firstelem   = $EXECUTE_ALL_PIPELINE_UPGRADE_SCRIPTS[0];
	my $api_result  = -1;
	my $Result      = -1;
	my $pipelineupgrade75pinlog = "$IFW_LOG_DIR/pin_75ps4_pipeline_upgrade.log";
	my $writestatement = "";

	open( TMPFILE1, ">$pipelineupgrade75pinlog" )
	    || die "cannot write into $pipelineupgrade75pinlog \n";

	if ( $firstelem eq "" ) {
		$Result         = 2;
		$writestatement = "There are no functions to process \n";
		print TMPFILE1 $writestatement;
		close(TMPFILE1);
	} else {
		foreach $upgrade_api (@EXECUTE_ALL_PIPELINE_UPGRADE_SCRIPTS) {
                        print "################################################ \n";
                    
			print "pipeline upgrade from 75ps4 is now executing api:$upgrade_api \n";

			$api_result = eval($upgrade_api);
			if ( $api_result == 0 ) {
				$Result = 0;
				$writestatement = "Successfully executed the function $upgrade_api";
				open( TMPFILE1, ">>$pipelineupgrade75pinlog " )
				    || die
				    "cannot read $pipelineupgrade75pinlog \n";
				print TMPFILE1 $writestatement;
				close(TMPFILE1);
                                print "################################################ \n";
				next;
			} else {
				$Result = $api_result;
				open( TMPFILE1, ">>$pipelineupgrade75pinlog " )
				    || die
				    "cannot read $pipelineupgrade75pinlog \n";
				print TMPFILE1 "execution failed for $upgrade_api, Please see the log file at $IFW_LOG_DIR. \n";
				close(TMPFILE1);
                                print "################################################ \n";
				last;
			}

		}

	}

	return $Result;
}
1;


