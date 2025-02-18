#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)$Id: pin_75ps6_upgrade.pl /cgbubrm_7.5.0.rwsmod/2 2013/08/30 04:59:40 mkothari Exp $
#
# $Header: bus_platform_vob/upgrade/upgrade_75ps6/oracle/pin_75ps6_upgrade.pl /cgbubrm_7.5.0.rwsmod/2 2013/08/30 04:59:40 mkothari Exp $
#
# pin_75ps6_upgrade.pl
# 
# Copyright (c) 2009, 2013, Oracle and/or its affiliates. All rights reserved.
#
#    NAME
#      pin_75ps6_upgrade.pl - this script is the main driver file
#      for upgrading the BRM PORTALBASE DB to 7.5 PS5
#
#    DESCRIPTION
#	This script is the main driver file for upgrading the BRM Database to 7.5 PS5
#      	This script will call various exposed APIs from within itself.
#      	This exposed APIs will call perl scripts internally to do a Database Upgrade.
#      	This exposed APIs are as following.
# 	1) create_new_objects_75ps1()
#       2) modify_existing_objects_75ps1()
#       3) default_values_75ps1()
#       4) create_new_objects_75ps2()
#       5) modify_existing_objects_75ps2()
#       6) default_values_75ps2()
#       7) create_new_objects_75ps3()
#       8) modify_existing_objects_75ps3()
#       9) default_values_75ps3()
#       10) create_new_objects_75ps4()
#       11) modify_existing_objects_75ps4()
#       12) default_values_75ps4()
#       13) create_new_objects_75ps5()
#       14) default_values_75ps5()
#       15) create_new_objects_75ps6()
#       16) default_values_75ps6()

#      	In the Notes Section a more detailed explanation will be given as to what the
#      	API will do.
#    NOTES
#     	Here are the details of the APIs which are called by the Driver Perl File.
#
#       e.g. In the Driver file "pin_74_75_upgrade.pl" there will be a subroutine like
#       upgrade_75() which will be the main function for upgrade. This will call the
#       wrapper APIs from within itself.
#
#       default_values_74ps1() and optional_managers_index_upgrade()

#       $api_result = eval($upgrade_api);
#       In this case upgrade_api array consists of  default_values_74ps1(),optional_managers_index_upgrade(), 
#	add_new_indexes_74_ps3() , default_values_74ps4(), default_values_74ps5() , add_new_indexes_74_ps5(), default_values_74ps6(),default_values_74ps7()
#       default_values_75()

#       if the value of ret_val is 0 continue execution, if value of ret_val is 1, then one of the or all required optional managers
#  	are not installed, however execution will continue, else
#       stop the execution of the optional_managers_index_upgrade() and exit
#       out of the function upgrade_75() giving appropriate error message.
#       Error Messages will be logged in upgrade_75.log in $PIN_HOME/setup directory.

#       The Wrapper API optional_managers_index_upgrade() is defined in the script add_new_indexes_74ps2.pl
#       which will execute various index creation scripts defined in the array list ALL_OPTIONAL_MANAGER_INDEX_SCRIPTS[].
#	This script will also execute the pin_rel stored procedure.

#       Error Logging in the Driver Script

#       All the errors that will be encountered, during execution of the
#       wrapper APIs will be handled  through an entry into the respective log files
#       defined for each perl files called from the wrapper API.

#       The Log File will be generated in the directory $PIN_HOME/tmp/
#       The name of the log file for the driver perl file will be upgrade_74_to_75.log
#       So going through that logfile will make it quite clear why the upgrade process
#       exeution failed.
#       So whenever a script fails, there will be suitable message printed on the screen
#       as to which API failed and which underlying perl script got failed. This will give a clear
#       picture as to which upgrade script errored out.
#
#    MODIFIED   (MM/DD/YY)
#    mkothari	08/23/13 - Creation
#======================================================================
use strict;
use warnings;
use Env;

require "pin_res.pl";
require "pin_functions.pl";
require "pin_oracle_functions.pl";
require "../pin_setup.values";
require "pin_cmp_dm_db.pl";
require "pin_tables.values";
require "default_values_74ps1.pl";
require "add_new_indexes_74ps2.pl";
require "add_new_indexes_74ps3.pl";
require "default_values_74ps4.pl";
require "add_new_indexes_74ps5.pl";
require "default_values_74ps5.pl";
require "default_values_74ps6.pl";
require "default_values_74ps7.pl";
require "default_values_74ps8.pl";
require "default_values_74ps10.pl";
require "add_new_objects_75.pl";
require "default_values_75.pl";
require "add_new_objects_75ps1.pl";
require "default_values_75ps1.pl";
require "add_new_objects_75ps2.pl";
require "default_values_75ps2.pl";
require "add_new_objects_75ps3.pl";
require "default_values_75ps3.pl";
require "add_new_objects_75ps4.pl";
require "default_values_75ps4.pl";
require "add_new_objects_75ps5.pl";
require "default_values_75ps5.pl";
require "add_new_objects_75ps6.pl";
require "default_values_75ps6.pl";

require "timezone.cfg";
our %MAIN_DM;
our %MAIN_CM;


our %CM;
our %DM;
our $ret_val = 0;
our $PIN_TEMP_DIR;
our $PIN_LOG_DIR;
our $dmpinlog = "$PIN_LOG_DIR/dm_oracle/dm_oracle.pinlog";
our $cmpinlog = "$PIN_LOG_DIR/cm/cm.pinlog";
our $pinlog = "$PIN_HOME/setup/pin_setup.log";
our $UPG_DIR = "$PIN_HOME/sys/dd/data";
our $LIBRARYEXTENSION = "";
our $upgrade75pinlog = "$PIN_TEMP_DIR" . "/" . "upgrade_75ps6.log";
our $msgstring = "";
our $return_status  = 0;
our $writestatement = "";
our $SETUP_LOG_FILENAME = "";
our $SETUP_LOG_ACCESS_TYPE = "";
our $statusflag = "TRUE";

our @EXECUTE_ALL_UPGRADE_SCRIPTS = (
	"default_values_74ps1()",
        "optional_managers_index_upgrade()",
	"add_new_indexes_74ps3()",
	"default_values_74ps4()",
	"default_values_74ps5()",
	"add_new_indexes_74ps5()",
	"default_values_74ps6()",
	"default_values_74ps7()",
        "default_values_74ps8()",
        "default_values_74ps10()",
        "create_new_objects()",
        "modify_existing_objects()",
	"default_values_75()",
	"create_new_objects_75ps1()",
	"modify_existing_objects_75ps1()",
	"default_values_75ps1()",
	"create_new_objects_75ps2()",
	"modify_existing_objects_75ps2()",
	"default_values_75ps2()",
	"create_new_objects_75ps3()",
	"modify_existing_objects_75ps3()",
	"default_values_75ps3()",
	"create_new_objects_75ps4()",
	"modify_existing_objects_75ps4()",
	"default_values_75ps4()",
	"create_new_objects_75ps5()",
	"default_values_75ps5()",
	"modify_existing_objects_75ps6()",
	"default_values_75ps6()"
        );

# make sure I/O is flushed

select STDERR; $|=1;
select STDOUT; $|=1;

# setting the libraryextension to a proper value

if ( $^O =~ /win/i ) {
  $LIBRARYEXTENSION = ".dll";
} elsif ( $^O =~ /solaris/i ) {
  $LIBRARYEXTENSION = ".so";
} elsif ( $^O =~ /aix/i ) {
  $LIBRARYEXTENSION = ".a";
} elsif( $^O =~ /hpux/i && `(/bin/uname -m ) 2>/dev/null` =~ /ia64/i ){
  $LIBRARYEXTENSION = ".so";
} elsif( $^O =~ /hpux/i ){
  $LIBRARYEXTENSION = ".sl";
} else {
  $LIBRARYEXTENSION = ".so";
}

%CM = %MAIN_CM;
%DM = %MAIN_DM;

# This block of code is added to clean up the pin_setup.log file
# before stopping the services.

print "cleaning up the $pinlog file before starting upgrade process \n";

open (TMPFILE,">$pinlog ")|| die "cannot read $pinlog \n";
close (TMPFILE);

# Stopping the CM/DM Services

print "Stopping the Services before upgrade \n";
&PreModularConfigureDatabase( %CM, %DM );
sleep ( 20 );

# cleaning all the CM/DM logs before restarting services.

open (TMPFILE,">$dmpinlog ")|| die "cannot open $dmpinlog for writing. \n";
close (TMPFILE);

open (TMPFILE,">$cmpinlog ")|| die "cannot open $cmpinlog for writing. \n";
close (TMPFILE);

# Executing this file to create table dd_types_t required for dm_oracle startup
if ( -e "$UPG_DIR/pin_upg_common.source" ) {
	&ExecuteSQL_Statement_From_File("$UPG_DIR/pin_upg_common.source",$statusflag,$statusflag, %{$DM{"db"}});
}

if ( -e "$UPG_DIR/virtual_columns_upgrade_ps3.source" ) {
	&ExecuteSQL_Statement_From_File("$UPG_DIR/virtual_columns_upgrade_ps3.source",$statusflag,$statusflag, %{$DM{"db"}});
}
else {
	print "File $UPG_DIR/virtual_columns_upgrade_ps3.source not found... \n";
	exit;
}

$ret_val = upgrade_75();

if ( $ret_val == 0 || $ret_val == -1) {
	my $rel_opt_flag = "false";
	my $rel_opt_mgr_table = "BATCH_REL_T";
        my $pinsetuplog = "$PIN_HOME" . "/setup/pin_setup.log";
        my $procfiles = "";
	my $collection_opt_mgr_table = "collections_action_t";
	my $service_start_flag = 0;

        open (TMPFILE,">$pinsetuplog") || die "cannot open $pinsetuplog for writing \n";
        open (UPGRADE_PINLOG_FILE_HANDLER, ">>$upgrade75pinlog" ) || die "cannot open $upgrade75pinlog for writing. \n";

	# executing the partition util procedure .
	 if (-e "$PIN_HOME/apps/partition_utils/sql_utils/oracle/partition_utils.plb")  {
                        if ( $DM{'db'}->{'vendor'} =~ /^oracle$/ )      {
                                $procfiles = "$PIN_HOME/apps/partition_utils/sql_utils/oracle/partition_utils.plb";
                                $rel_opt_flag = "true";
                                print "Executing $procfiles  \n";
                                $msgstring = "Executing $procfiles \n";
                                print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                                &ExecutePLB_file ( "$procfiles", "Partition Stored Procedures", %DM );
                                print "Executed $procfiles \n";
                                $msgstring = "Executed $procfiles \n";
                                print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                        }
                }

	# executing the pin virtual column procedure.
         if (-e "$PIN_HOME/apps/pin_virtual_columns/oracle/create_pkg_pin_virtual_columns.plb")  {
                        if ( $DM{'db'}->{'vendor'} =~ /^oracle$/ )      {
                                $procfiles = "$PIN_HOME/apps/pin_virtual_columns/oracle/create_pkg_pin_virtual_columns.plb";
                                $rel_opt_flag = "true";
                                print "Executing $procfiles  \n";
                                $msgstring = "Executing $procfiles \n";
                                print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                                &ExecutePLB_file ( "$procfiles", "virtual column Procedures", %DM );
                                print "Executed $procfiles \n";
                                $msgstring = "Executed $procfiles \n";
                                print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                        }
                }

	# executing the create Procedure .
	 if (-e "$DM{'location'}/data/create_procedures_$DM{'sm_charset'}.plb" )
         {

                if ( $DM{'db'}->{'vendor'} =~ /^oracle$/ )
                {
                        $procfiles = "$DM{'location'}/data/create_procedures_$DM{'sm_charset'}.plb";
                        print "Executing $procfiles \n";
                        $msgstring = "Executing $procfiles \n";
                        print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                        &ExecutePLB_file ( "$procfiles", "Portal Stored Procedures", %DM );
                        print "Executed $procfiles \n";
                        $msgstring = "Executed $procfiles \n";
                        print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                }
         }
	# executing the pin_rel stored procedure finally.

        if (VerifyPresenceOfTable($rel_opt_mgr_table, %{ $DM{"db"} }) != 0)     {
                if (-e "$PIN_HOME/apps/pin_rel/pin_rel_updater_sp_oracle.plb")  {
                        if ( $DM{'db'}->{'vendor'} =~ /^oracle$/ )      {
                                $procfiles = "$PIN_HOME/apps/pin_rel/pin_rel_updater_sp_oracle.plb";
                               	$rel_opt_flag = "true"; 
				print "Executing $procfiles  \n";
                                $msgstring = "Executing $procfiles \n";
                                print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                                &ExecutePLB_file ( "$procfiles", "REL Stored Procedures", %DM );
                                print "Executed $procfiles \n";
                                $msgstring = "Executed $procfiles \n";
                                print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                        }
                }
		if( -e "$PIN_HOME/setup/scripts/pin_cmp_rel.pl" )
		{
			print "Executing $PIN_HOME/setup/scripts/pin_cmp_rel.pl \n";
			system("$PIN_HOME/setup/scripts/pin_cmp_rel.pl");
        	}
        }

        $msgstring = "For any error in stored procedures upgrade, please see $pinsetuplog \n";
        print UPGRADE_PINLOG_FILE_HANDLER $msgstring;

	# Calling the cmp file for virtual columns for generating Infranet.properties 
	if( -e "$PIN_HOME/setup/scripts/pin_cmp_virtual_col.pl" )
	{
		print "Executing $PIN_HOME/setup/scripts/pin_cmp_virtual_col.pl \n";
        	$msgstring = "Executing $PIN_HOME/setup/scripts/pin_cmp_virtual_col.pl \n";
        	print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
		system("$PIN_HOME/setup/scripts/pin_cmp_virtual_col.pl");
	}

	# Calling the cmp file for qm_port changes in pin.conf
	if( -e "$PIN_HOME/setup/scripts/pin_cmp_qm_port.pl" )
	{
		print "Executing $PIN_HOME/setup/scripts/pin_cmp_qm_port.pl \n";
        	$msgstring = "Executing $PIN_HOME/setup/scripts/pin_cmp_qm_port.pl \n";
        	print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
		system("$PIN_HOME/setup/scripts/pin_cmp_qm_port.pl");
	}

	if ( $rel_opt_flag eq "false") {
		print "Rated Event Loader Not Installed. \n";
		print "################################################ \n";
	}
	if (VerifyPresenceOfTable($collection_opt_mgr_table, %{ $DM{"db"} }) == 0) {
                print "Collection Manager Not Installed. \n";
		print "################################################ \n";
        }
        else
        {
                print "Collection Manager is Installed. \n";
                print "################################################ \n";

                if( -e "$PIN_HOME/setup/scripts/pin_cmp_pin_collections.pl" )
                {
                        print "Executing $PIN_HOME/setup/scripts/pin_cmp_pin_collections.pl \n";
        		$msgstring = "Executing $PIN_HOME/setup/scripts/pin_cmp_pin_collections.pl \n";
        		print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                        system("$PIN_HOME/setup/scripts/pin_cmp_pin_collections.pl");
                        $service_start_flag = 1;
                }
        }

        close(UPGRADE_PINLOG_FILE_HANDLER);
        close(TMPFILE);

        print "PortalBase Schema upgrade to BRM 75ps6 is successful. \n";
        open(UPGRADE_PINLOG_FILE_HANDLER, ">>$upgrade75pinlog " ) || die "cannot open $upgrade75pinlog for writing. \n";
        $msgstring ="PortalBase Schema upgrade to BRM 75ps6 is successful. \n";

        print UPGRADE_PINLOG_FILE_HANDLER $msgstring;

        print "Calling application upgrade script... \n";
        $msgstring =  "Calling application upgrade script... \n";
        print UPGRADE_PINLOG_FILE_HANDLER $msgstring;

        if( -e "$PIN_HOME/setup/scripts/pin_cmp_load_config.pl" )
        {
                print "Executing $PIN_HOME/setup/scripts/pin_cmp_load_config.pl \n";
        	$msgstring =  "Executing $PIN_HOME/setup/scripts/pin_cmp_load_config.pl \n";
        	print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                system("$PIN_HOME/setup/scripts/pin_cmp_load_config.pl");
        }
        else
        {
                print "$PIN_HOME/setup/scripts/pin_cmp_load_config.pl  not executed \n";
        	$msgstring =  "$PIN_HOME/setup/scripts/pin_cmp_load_config.pl  not executed \n";
        	print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                print "Please make sure pin_cmp_load_config.pl exist then run the upgrade script again \n";
        	$msgstring =  "Please make sure pin_cmp_load_config.pl exist then run the upgrade script again \n";
        	print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
        }

        if( -e "$PIN_HOME/setup/scripts/pin_cmp_dm_fusa.pl" )
        {
                print "Executing $PIN_HOME/setup/scripts/pin_cmp_dm_fusa.pl \n";
        	$msgstring =  "Executing $PIN_HOME/setup/scripts/pin_cmp_dm_fusa.pl \n";
        	print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                system("$PIN_HOME/setup/scripts/pin_cmp_dm_fusa.pl");
        }
        
	if( -e "$PIN_HOME/setup/scripts/pin_cmp_upgrade.pl" )
        {
	# Flag to check if the entry is already there in cm pin.conf
		my $tempflag =0;
                open(TMPFILE,"<$PIN_HOME/sys/cm/pin.conf ")|| die "cannot read $PIN_HOME/sys/cm/pin.conf \n";
                while ( my $cmpinconf = <TMPFILE> )
                {
                        if ( $cmpinconf =~ m/fm_offer_profile_config/ )
                        {
                                $tempflag = 1;
				last;
                        }
                }
                if ($tempflag != 1)
                {
                        print "Executing $PIN_HOME/setup/scripts/pin_cmp_upgrade.pl \n";
                        $msgstring =  "Executing $PIN_HOME/setup/scripts/pin_cmp_upgrade.pl \n";
                        print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                        system("$PIN_HOME/setup/scripts/pin_cmp_upgrade.pl");
                }
                close TMPFILE;
        }
	#Executing the perl file and creating the file classid_values.txt
	 if( -e "$PIN_HOME/setup/scripts/pin_gen_classid_values.pl" )
        {
                print "Executing $PIN_HOME/setup/scripts/pin_gen_classid_values.pl \n";
        	$msgstring =  "Executing $PIN_HOME/setup/scripts/pin_gen_classid_values.pl \n";
        	print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                system("$PIN_HOME/setup/scripts/pin_gen_classid_values.pl");
        }

        print "please see the upgrade log file at $upgrade75pinlog \n";
        $msgstring =  "please see the upgrade log file at $upgrade75pinlog \n";
        print UPGRADE_PINLOG_FILE_HANDLER $msgstring;

	#Flag to check to restart dm_oracle or not.
        print "Starting the Services after upgrade \n";
        if( $service_start_flag != 1 )
        {
                &PostModularConfigureDatabase( %CM, %DM );
                sleep ( 20 );
        }

        # Calling application load utility only for primary schema
	if($DM{'db_num'} eq "0.0.0.1" )
	{
		print "Calling the load utility for localize change \n";
		$msgstring =  "Calling the load utility for localize change \n";
		print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
		load_utilities();
	}

	if ((-e "$PIN_HOME/sys/eai_js/payloadconfig_crm_sync.xml") && (-e "$PIN_HOME/sys/eai_js/payloadconfig_ifw_sync.xml"))  {
		print "Executing $PIN_HOME/bin/MergeXML $PIN_HOME/sys/eai_js/payloadconfig_ifw_sync.xml $PIN_HOME/sys/eai_js/payloadconfig_crm_sync.xml $PIN_HOME/sys/eai_js/payloadconfig_MergedWithCRMSync.xml";
        	$msgstring =  "Executing $PIN_HOME/bin/MergeXML $PIN_HOME/sys/eai_js/payloadconfig_ifw_sync.xml $PIN_HOME/sys/eai_js/payloadconfig_crm_sync.xml $PIN_HOME/sys/eai_js/payloadconfig_MergedWithCRMSync.xml";
        	print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
                system("$PIN_HOME/bin/MergeXML $PIN_HOME/sys/eai_js/payloadconfig_ifw_sync.xml $PIN_HOME/sys/eai_js/payloadconfig_crm_sync.xml $PIN_HOME/sys/eai_js/payloadconfig_MergedWithCRMSync.xml");
        }


        print "please see the upgrade log file at $upgrade75pinlog \n";
        $msgstring =  "please see the upgrade log file at $upgrade75pinlog \n";
        print UPGRADE_PINLOG_FILE_HANDLER $msgstring;
        close ( UPGRADE_PINLOG_FILE_HANDLER ) ;

        # Check whether there are any errors in the CM and DM logs.
	if($DM{'db_num'} eq "0.0.0.1" )
	{
		open(TMPFILE,"<$dmpinlog ")|| die "cannot read $dmpinlog \n";
		while ( my $ReadString = <TMPFILE> )
		       {
			     if ( $ReadString =~ /^E/ )
				    {
					   print "Error occurred in $dmpinlog \n";
					   print "Please open the $dmpinlog to see the errors \n";
					   last;
				    }
		       }
		close(TMPFILE);

		open(TMPFILE, "<$cmpinlog ")|| die "cannot read $cmpinlog \n";
		while ( my $ReadString = <TMPFILE> )
		    {
			 if ( $ReadString =~ /^E/ )
				 {
					   print "Error occurred in $cmpinlog \n";
					   print "Please open the $cmpinlog to see the errors \n";
					   last;
				    }
		       }
		close(TMPFILE);
	}

}
elsif ( $ret_val == 2 ) {
        print "there are no function apis to process. upgrades will not continue. \n";
        print "please see the upgrade log file at $upgrade75pinlog \n";

} else {
        print "the upgrade did not run successfully \n";
        print "please see the upgrade log file at $upgrade75pinlog to find out the error \n";
}

#post restart load utilities
sub load_utilities {
   my $TempDir = "$PIN_HOME" . "/sys/data/config";
   my $CurrentDir = "$PIN_HOME" . "/setup/scripts";


   eval qq!require "pin_cmp_pin_billd.pl"!;

   chdir $TempDir;
   eval "&load_localized_strings_lifecycle_states_en();";
   eval "&load_localized_strings_active_mediation_en();";
   chdir $CurrentDir;

}

sub upgrade_75 {
        %CM = %MAIN_CM;
        %DM = %MAIN_DM;
        my $upgrade_api ="";
        my $firstelem = $EXECUTE_ALL_UPGRADE_SCRIPTS[0];
        my $api_result = -1;
        my $Result = 0;
        my $upgrade75pinlog = "$PIN_TEMP_DIR" . "/" . "upgrade_75ps6.log";
        my $writestatement = "";
        my $flag_for_user_input = 0;
	# cleaning up the upgrade log file before executing upgrade scripts.

        open( TMPFILE3, ">$upgrade75pinlog" ) || die "cannot open $upgrade75pinlog for writing. \n";
        close(TMPFILE3);
        if ( $firstelem eq "" ) {
                $Result = 2;
        } else {

                foreach $upgrade_api (@EXECUTE_ALL_UPGRADE_SCRIPTS) {
                                print "################################################ \n";
                                print "Upgrade BRM 75ps6 is now executing $upgrade_api \n";

                                $api_result = eval($upgrade_api);

                                if ( $api_result == 0 ) {
                                $Result = 0;
                                print "execution was successful for $upgrade_api \n";
                                open( TMPFILE3, ">>$upgrade75pinlog" ) || die "cannot open $upgrade75pinlog for writing. \n";
                                $writestatement = "Successfully executed the function $upgrade_api \n";
                                print TMPFILE3 $writestatement;
                                close(TMPFILE3);
                                print "################################################ \n";
                                next;
                        }
                                elsif ($api_result == -1) {
                                $Result = -1;
                                next;
                        }
                                else {
                                $Result = $api_result;
                                open( TMPFILE3, ">>$upgrade75pinlog" ) || die "cannot open $upgrade75pinlog for writing. \n";
                                print "Execution failed for $upgrade_api. Please see the respective log file at $PIN_TEMP_DIR. \n";
                                $writestatement = "Execution failed for $upgrade_api. Please see the respective log file at $PIN_TEMP_DIR. \n";
                                print TMPFILE3 $writestatement;
                                close(TMPFILE3);
                                print "################################################ \n";
                                last;
                        }

	}

        }


        if ( $Result == 2 ) {
                $writestatement = "There are no functions to process \n";
                open( TMPFILE3, ">>$upgrade75pinlog" ) || die "cannot open $upgrade75pinlog for writing. \n";
                print TMPFILE3 $writestatement;
                close(TMPFILE3);
        }

        print "################################################ \n";
        return $Result;
}
1;
 
