#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)$Id: add_new_objects_75ps1.pl /cgbubrm_7.5.0.rwsmod/5 2013/05/10 05:49:12 hsnagpal Exp $
#
# $Header: bus_platform_vob/upgrade/upgrade_75ps1/oracle/add_new_objects_75ps1.pl /cgbubrm_7.5.0.rwsmod/5 2013/05/10 05:49:12 hsnagpal Exp $
#
# add_new_objects_75ps1.pl
#
# Copyright (c) 2008, 2013, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      add_new_objects_75ps1.pl - This module will result in creating new objects or modifying existing ones
#
#    DESCRIPTION
#      This File will contain subroutines to create objects or modify existing object behaviour
#      This file will be called from pin_74_75ps1_upgrade.pl first in the order.

#      For each feature, there will be having their own set of create or modify scripts
#      [These scripts will be having .source extension].
#      There will be one .source per addition of new table object or
#      one .source per addition of set of columns to an existing table object.
#      These scripts will be called one by one by this Perl File
#      add_new_objects_75ps1.pl for execution and updating the DB Schema
#      with new objects or modifying existing objects [tables or columns].
#
#    NOTES
#      This Script will be used to execute all the scripts which are creating
#      new objects/modifying existing objects in the Database and also updating
#      the Data Dictionary with this information.

#      The Driver File for upgrade which is the script "pin_74_75ps1_upgrade.pl"
#      will call this perl script (add_new_objects_75ps1.pl) through one of its wrappers APIs
#      named "create_new_objects()" and "modify_existing_objects()".

#      The execution methodology will be the same as the execution of the other object creation script.

#      How this script will work

#      This Perl file will invoke the API "pin_init()" which in turn calls the function
#      "parse_execute_opcode_file" which takes as input the opcode file [each feature specific
#      create/modify object scripts in this case] and executes the opcode file there by creating
#      the new objects or modifying the existing object in the database as well as updating the
#      data dictionary and returns the execution results for each script executed.
#      Using this result value a suitable message will be printed on the prompt whether the script
#      execution was a success or failure and the place where it failed, in case the execution failed.

#       Error Handling
#
#       The Error Handling will be done by logging the error messages in the log file.
#       This log file is pin_setup.log which will be generated in $PIN_HOME/setup directory.
#       So whenever there will be an error as part of execution of this script, there will
#       a value returned at the end of this script. Based on that return value, it will
#       be easier to track, the point of failure [in terms of name of feature scripts],
#       when this script is called by the wrapper APIs [create_new_objects() and  modify_existing_objects() ] from
#       the driver file "pin_74_75ps1_upgrade.pl". So in case a failed result value is returned,
#       the further execution process of upgrade will be stopped.
#       This stopping of the further execution will be handled in the driver file.
#
#    MODIFIED   (MM/DD/YY)
#    hsnagpal    03/05/12 - ..
#    hsnagpal    07/11/11 - Creation
#======================================================================================
use strict;
use warnings;
use Env;

our %MAIN_CM;
our %MAIN_DM;

our %CM;
our %DM;

our $TMP;

our $SKIP_INIT_OBJECTS = "YES";

our $SPECIAL_DD_FILE;

our $USE_SPECIAL_DD_FILE;

our $PIN_TEMP_DIR;
our $PIN_LOG_DIR;
our $SETUP_LOG_FILENAME;

our %DD;

our @ALL_CREATE_SCRIPTS_PS1 = ("dd_objects_AM_delete.source",
			   "dd_objects_slcm_delete.source",
			   "drop_slm_old_table_from_db.source",
			   "drop_AM_old_table_from_db.source",
			   "slm_business_param.source",
			   "bus_params_AM.source",
			   "full_install_active_med.source",
			   "full_slm_changes.source",
			   "config_object_mod_for_tcf_aaa.source",
			   "dd_active_session.source");

our @ALL_MODIFY_SCRIPTS_PS1 = ( "PDC_modify_product.source",
			    "dd_objects_slcm_service_t.source",
			    "event_schema_change.source");

our @OPTIONAL_MANAGER_MODIFY_SCRIPTS = (
);

our @OPTIONAL_MANAGER_CREATE_SCRIPTS = (
);

our $UPG_DIR   = "$DD{'location'}";
our $StartTime = "";

sub create_new_objects_75ps1 {
	my $file         = "";
	my $tablename    = "";
	my $time_stamp   = "";
	my $Result       = 0;
	my $objectflag   = "FALSE";
	my $verifyobject = "";
	my $logfile =
	      "$PIN_LOG_DIR" . "/" . "dm_"
	    . "$MAIN_DM{'db'}->{'vendor'}" . "/" . "dm_"
	    . "$MAIN_DM{'db'}->{'vendor'}.pinlog";
	my $FirstElem           = $ALL_CREATE_SCRIPTS_PS1[0];
	my $createobjectspinlog = "$PIN_TEMP_DIR" . "/create_objects_75ps1.log";
	my $writestatement      = "";
        my $sqlstatement        = "";
        my $initobjres          =  1;
        my $statusflags         = "TRUE";
        my $ReadString          = "";

	%CM = %MAIN_CM;
	%DM = %MAIN_DM;

	open( TMPFILE3, ">$createobjectspinlog " )
	    || die "cannot read $createobjectspinlog \n";
        close(TMPFILE3);

	if ( $FirstElem eq "" ) {
		$Result = 3;
	}

	else {
		&pin_pre_modular( %{ $DM{"db"} } );

		foreach $file (@ALL_CREATE_SCRIPTS_PS1) {

                print "################################################ \n";
			if ( !-e "$UPG_DIR/$file" ) {
				print "$UPG_DIR/$file not found \n";
				$Result = 2;
			} else {
				print "$UPG_DIR/$file found \n";
				# get the current time from the environment before 
				# each iteration of upgrade scripts. 
				$StartTime = localtime( time() );
				$time_stamp = "Started $file at " . $StartTime;
				print "$time_stamp \n";

                                $SETUP_LOG_FILENAME = "$PIN_TEMP_DIR/tmp.out";
				if ( $file eq "slm_business_param.source" )
				{
                                	$sqlstatement = "select name from config_t where name like 'customer'; \n";
                                	&ExecuteSQL_Statement( "$sqlstatement", $statusflags, $statusflags, %{$DM{"db"}});
                               		open(TMPFILE, "<$SETUP_LOG_FILENAME " ) || die "cannot read $SETUP_LOG_FILENAME \n";
                                	while( $ReadString = <TMPFILE> ) 
					{
                                    		if ( $ReadString =~ m/no\s+rows\s+selected/ ) {
                                         		$initobjres = 0;
                                         		last;
                                         	}
                                      	}
                          		close(TMPFILE);
                          		unlink($SETUP_LOG_FILENAME);

                                   	if ($initobjres == 0)
                                   	{
                                       		 print "Creating New Business Params for BRM \n";
                                       		 $SKIP_INIT_OBJECTS   = "YES";
                                       		 $USE_SPECIAL_DD_FILE = "YES";
                                       		 $SPECIAL_DD_FILE     = "$UPG_DIR/$file";
                                       		 &pin_init(%DM);

                                       		 open( TMPFILE2, "<$logfile " ) || die "cannot read $logfile\n";
                                                 while ($ReadString = <TMPFILE2> )
                                                 {
                                                        if ( $ReadString =~ /^E/ )
                                                        {
                                                                $Result = 1;
                                                                print "Script Execution is unsuccessful For $file \n";
                                                                last;
                                                        }
                                                 }
                                                 close(TMPFILE2);

                                                 if ($Result == 0)
                                                 {
                                                        open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                                        print "Execution successfull For $file \n";
                                                        $writestatement = "Execution successfull For $file \n";
                                                        print TMPFILE3 ("$writestatement \n") ;
                                                        close(TMPFILE3);
                                                        $USE_SPECIAL_DD_FILE = "NO";
                                                        $SKIP_INIT_OBJECTS = $TMP;
                                                        print "################################################ \n";
                                                        next;
                                                 } 
                                                 else 
						 {
                                                        open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                                        print "Execution unsuccessfull for $file \n";
                                                        $writestatement = "Execution unsuccessfull For $file \n";
                                                        print TMPFILE3 ("$writestatement \n") ;
                                                        close(TMPFILE3);
                                                        last;
                                                 }

                                   	 }
                                         # This code is added to display and log proper messages in case
                                         # the business param activity already exist.
                                         else
                                         {
                                       		print "Business Param activity already exists. \n";
                                       		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                       		$writestatement = "Business Param activity already exists. \n";
                                       		print TMPFILE3 ("$writestatement \n") ;
                                       		close(TMPFILE3);
                                       		print "################################################ \n";
                                       		next;
                                    	 }
                                }
				if ( $file eq "bus_params_AM.source" )
			 	{
                                	$sqlstatement = "select name from config_t where name like 'AAA'; \n";
                                	&ExecuteSQL_Statement( "$sqlstatement", $statusflags, $statusflags, %{$DM{"db"}});
                               		open(TMPFILE, "<$SETUP_LOG_FILENAME " ) || die "cannot read $SETUP_LOG_FILENAME \n";
                                	while( $ReadString = <TMPFILE> ) 
					{
                                    		if ( $ReadString =~ m/no\s+rows\s+selected/ ) {
                                         		$initobjres = 0;
                                         		last;
                                         	}
                                      	}
                          		close(TMPFILE);
                          		unlink($SETUP_LOG_FILENAME);

                                   	if ($initobjres == 0)
                                   	{
                                       		 print "Creating New Business Params for BRM \n";
                                       		 $SKIP_INIT_OBJECTS   = "YES";
                                       		 $USE_SPECIAL_DD_FILE = "YES";
                                       		 $SPECIAL_DD_FILE     = "$UPG_DIR/$file";
                                       		 &pin_init(%DM);

                                       		 open( TMPFILE2, "<$logfile " ) || die "cannot read $logfile\n";
                                                 while ($ReadString = <TMPFILE2> )
                                                 {
                                                        if ( $ReadString =~ /^E/ )
                                                        {
                                                                $Result = 1;
                                                                print "Script Execution is unsuccessful For $file \n";
                                                                last;
                                                        }
                                                 }
                                                 close(TMPFILE2);

                                                 if ($Result == 0)
                                                 {
                                                        open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                                        print "Execution successfull For $file \n";
                                                        $writestatement = "Execution successfull For $file \n";
                                                        print TMPFILE3 ("$writestatement \n") ;
                                                        close(TMPFILE3);
                                                        $USE_SPECIAL_DD_FILE = "NO";
                                                        $SKIP_INIT_OBJECTS = $TMP;
                                                        print "################################################ \n";
                                                        next;
                                                 } 
                                                 else 
						 {
                                                        open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                                        print "Execution unsuccessfull for $file \n";
                                                        $writestatement = "Execution unsuccessfull For $file \n";
                                                        print TMPFILE3 ("$writestatement \n") ;
                                                        close(TMPFILE3);
                                                        last;
                                                 }

                                   	 }
                                         # This code is added to display and log proper messages in case
                                         # the business param activity already exist.
                                         else
                                         {
                                       		print "Business Param activity already exists. \n";
                                       		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                       		$writestatement = "Business Param activity already exists. \n";
                                       		print TMPFILE3 ("$writestatement \n") ;
                                       		close(TMPFILE3);
                                       		print "################################################ \n";
                                       		next;
                                    	 }
                                }
				if ( $file eq "dd_objects_slcm_delete.source" )
				{
					if (VerifyPresenceOfObject ("/config/lifecycle_states",%{ $DM{"db"} }) != 0 
					&& VerifyPresenceOfFieldInDD("PIN_FLD_CALL_ALLOWED","/config/lifecycle_states",%{ $DM{"db"} }) == -1)
					{
						print "Removing Objects in BRM Database for old slm tables \n";
						print "Updating DB Schema\n";
						$SKIP_INIT_OBJECTS   = "YES";
						$USE_SPECIAL_DD_FILE = "YES";
						$SPECIAL_DD_FILE     = "$UPG_DIR/$file";
						&pin_init(%DM);
						open( TMPFILE2, "<$logfile " )
						|| die "cannot read $logfile\n";
						while ( my $ReadString = <TMPFILE2> )
						{
							if ( $ReadString =~ /^E/ )
	                                        	{
                                                      		$Result = 1;
                                                       		print "Script Execution is unsuccessful For $file \n";
                                                       		last;
                                               		}
                                       		}
                                       		close(TMPFILE2);
                                      		if ( $Result == 0 )
                                      		{
                                             		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                	        	print "Execution successfull For $file \n";
                                       		 	$writestatement = "Execution successfull For $file \n";
                                       		 	print TMPFILE3 ("$writestatement \n") ;
                                       		 	close(TMPFILE3);
                                       		 	$USE_SPECIAL_DD_FILE = "NO";
                                      		 	$SKIP_INIT_OBJECTS = $TMP;
                                       		 	print "################################################ \n";
							print "Drop the table for which DD entries are removed \n";
							
                                       		 	next;
                                       		} else {
                                               		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                               		print "Execution unsuccessfull for $file \n";
                                               		$writestatement = "Execution unsuccessfull For $file \n";
                                               		print TMPFILE3 ("$writestatement \n") ;
                                               		close(TMPFILE3);
                                               		last;
                                       		}

                               		}
                               		else
                               		{
                                       		print "config_lcm_states_perm_srvc_t and config_lcm_states_array_t does not exists in the database \n";
						next;
                               		}

				}
				elsif ( $file eq "drop_slm_old_table_from_db.source" )
				{
					&ExecuteSQL_Statement_From_File( "$UPG_DIR/$file", $statusflags, $statusflags, %{$DM{"db"}});
					open(TMPFILE, "<$SETUP_LOG_FILENAME " ) || die "cannot read $SETUP_LOG_FILENAME \n";
					while ( my $ReadString = <TMPFILE> ) {
					 if ( $ReadString =~ /ORA-([\d]*):.*|SP2-([\d]*):.*/)
						{
							$Result = 1;
						}
						if ($Result == 1)
						{
							$writestatement = $ReadString;
							print TMPFILE ("$writestatement \n");
						}
					}

					close(TMPFILE);
					unlink($SETUP_LOG_FILENAME);
					if ( $Result == 0 ) {
						open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
						print "Execution successfull for $file \n";
						$writestatement = "Execution successfull for $file \n";
						print TMPFILE3 ("$writestatement \n");
						close(TMPFILE3);
						print "################################################ \n";
						next;
					}
					else
					{

						print "Execution is unsuccessful for $file \n";
						open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog\n";
						$writestatement = "Execution is unsuccessful for $file \n";
						print TMPFILE3 ("$writestatement \n");
						close(TMPFILE3);
						last;
					}

                                }
				elsif ( $file eq "full_slm_changes.source" )
				{
					if (VerifyPresenceOfObject ("/config/service_state_map",%{ $DM{"db"} }) == 0
                                        && VerifyPresenceOfObject ("/config/lifecycle_states",%{ $DM{"db"} }) == 0 )
					{
						print "Creating Objects in BRM Database \n";
						print "Updating DB Schema\n";
						$SKIP_INIT_OBJECTS   = "YES";
						$USE_SPECIAL_DD_FILE = "YES";
						$SPECIAL_DD_FILE     = "$UPG_DIR/$file";
						&pin_init(%DM);
						open( TMPFILE2, "<$logfile " )
							|| die "cannot read $logfile\n";
						while ( my $ReadString = <TMPFILE2> )
						{
							if ( $ReadString =~ /^E/ )
       		                                       	{
                                                       		$Result = 1;
                                                       		print "Script Execution is unsuccessful For $file \n";
                                                       		last;
                                               		}
                                       		}
                                       		close(TMPFILE2);
                                       		if ( $Result == 0 )
                                       		{
                                               		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                       	        	print "Execution successfull For $file \n";
                                       		 	$writestatement = "Execution successfull For $file \n";
                                           		print TMPFILE3 ("$writestatement \n") ;
                                               		close(TMPFILE3);
                                               		$USE_SPECIAL_DD_FILE = "NO";
                                               		$SKIP_INIT_OBJECTS = $TMP;
                                               		print "################################################ \n";
                                               		next;
                                        	} else {
                                                	open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                                	print "Execution unsuccessfull for $file \n";
                                                	$writestatement = "Execution unsuccessfull For $file \n";
                                                	print TMPFILE3 ("$writestatement \n") ;
                                                	close(TMPFILE3);
                                                	last;
                                        	}

                               		}
                              		else
                               		{
                                       		print "table config_lifecycle_perm_srvc_t,config_lifecycle_rules_t and config_lifecycle_trans_t already exists in the database \n";
						next;
                               		}
				}
				elsif ( $file eq "dd_objects_AM_delete.source")
				{
					if (VerifyPresenceOfTable ("subscriber_prefs_t",%{ $DM{"db"} }) != 0)
					{
						print "Removing Objects in BRM Database for old AM tables \n";
						print "Updating DB Schema\n";
						$SKIP_INIT_OBJECTS   = "YES";
						$USE_SPECIAL_DD_FILE = "YES";
						$SPECIAL_DD_FILE     = "$UPG_DIR/$file";
						&pin_init(%DM);
						open( TMPFILE2, "<$logfile " )
						|| die "cannot read $logfile\n";
						while ( my $ReadString = <TMPFILE2> )
						{
							if ( $ReadString =~ /^E/ )
	                                        	{
                                                      		$Result = 1;
                                                       		print "Script Execution is unsuccessful For $file \n";
                                                       		last;
                                               		}
                                       		}
                                       		close(TMPFILE2);
                                      		if ( $Result == 0 )
                                      		{
                                             		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                	        	print "Execution successfull For $file \n";
                                       		 	$writestatement = "Execution successfull For $file \n";
                                       		 	print TMPFILE3 ("$writestatement \n") ;
                                       		 	close(TMPFILE3);
                                       		 	$USE_SPECIAL_DD_FILE = "NO";
                                      		 	$SKIP_INIT_OBJECTS = $TMP;
                                       		 	print "################################################ \n";
							print "Drop the table for which DD entries are removed \n";
							
                                       		 	next;
                                       		} else {
                                               		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                               		print "Execution unsuccessfull for $file \n";
                                               		$writestatement = "Execution unsuccessfull For $file \n";
                                               		print TMPFILE3 ("$writestatement \n") ;
                                               		close(TMPFILE3);
                                               		last;
                                       		}

                               		}
                               		else
                               		{
                                       		print "preference_values_t and subscriber_prefs_t does not exists in the database \n";
						next;
                               		}

				}
				elsif ( $file eq "drop_AM_old_table_from_db.source")
				{
                                	&ExecuteSQL_Statement_From_File( "$UPG_DIR/$file", $statusflags, $statusflags, %{$DM{"db"}});
                               		open(TMPFILE, "<$SETUP_LOG_FILENAME " ) || die "cannot read $SETUP_LOG_FILENAME \n";
	                                while ( my $ReadString = <TMPFILE> ) {
       		                                if ( $ReadString =~ /ORA-([\d]*):.*|SP2-([\d]*):.*/)
                                        	{
                                                	$Result = 1;
                                        	}
                                        	if ($Result == 1)
                                        	{
                                            		$writestatement = $ReadString;
                                            		print TMPFILE ("$writestatement \n");
                                        	}
                                	}

                          		close(TMPFILE);
                          		unlink($SETUP_LOG_FILENAME);
                                	if ( $Result == 0 ) {
                                       		open( TMPFILE3, ">>$createobjectspinlog" ) || die "cannot read $createobjectspinlog\n";
                                        	print "Execution successfull for $file \n";
                                        	$writestatement = "Execution successfull for $file \n";
                                        	print TMPFILE3 ("$writestatement \n");
                                        	close(TMPFILE3);
                                        	print "################################################ \n";
                                        	next;
                                	}
                                	else
                                	{

                                            print "Execution is unsuccessful for $file \n";
                                            open( TMPFILE3, ">>$createobjectspinlog" ) || die "cannot read $createobjectspinlog\n";
                                            $writestatement = "Execution is unsuccessful for $file \n";
                                            print TMPFILE3 ("$writestatement \n");
                                            close(TMPFILE3);
                                            last;
                                	}
				}
				elsif ( $file eq "full_install_active_med.source" )
				{
					if ( VerifyPresenceOfObject ( "/profile/subscriber_preferences", %{ $DM{"db"} }) == 0)
					{
						print "Creating Objects in BRM Database \n";
						print "Updating DB Schema\n";
						$SKIP_INIT_OBJECTS   = "YES";
						$USE_SPECIAL_DD_FILE = "YES";
						$SPECIAL_DD_FILE     = "$UPG_DIR/$file";
						&pin_init(%DM);
						open( TMPFILE2, "<$logfile " )
							|| die "cannot read $logfile\n";
						while ( my $ReadString = <TMPFILE2> )
						{
							if ( $ReadString =~ /^E/ )
       		                                       	{
                                                       		$Result = 1;
                                                       		print "Script Execution is unsuccessful For $file \n";
                                                      		last;
                                                	}
                                        	}
                                        	close(TMPFILE2);
                                        	if ( $Result == 0 )
                                        	{
                                                	open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                        	        print "Execution successfull For $file \n";
                                               		$writestatement = "Execution successfull For $file \n";
                                               		print TMPFILE3 ("$writestatement \n") ;
                                               		close(TMPFILE3);
                                               		$USE_SPECIAL_DD_FILE = "NO";
                                               		$SKIP_INIT_OBJECTS = $TMP;
                                      		 	print "################################################ \n";
						 		
                                      		 	next;
                                       		} else {
                                               		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                               		print "Execution unsuccessfull for $file \n";
                                               		$writestatement = "Execution unsuccessfull For $file \n";
                                               		print TMPFILE3 ("$writestatement \n") ;
                                               		close(TMPFILE3);
                                               		last;
                                       		}

                               		}
                               		else
                               		{
                                       		print "table config_pref_map_t, config_preference_values_t or profile_subscriber_prefs_t already exists in the database \n";
						next;
                               		}
				
				}
                                elsif ( $file eq "config_object_mod_for_tcf_aaa.source")
                                {
					if ( VerifyPresenceOfTable ( "config_aaa_telco_info_t", %{ $DM{"db"} }) != 0)
                                        {
						$tablename = "config_aaa_scaled_delay_info_t";	
					}
                                        else
                                        {
                                                next;
                                        }
                                }
				elsif ( $file eq "dd_active_session.source" )
				{
					$tablename = "active_session_thresholds_t";
				}

                                if ( VerifyPresenceOfTable ( $tablename, %{ $DM{"db"} }) == 0)
                                {
                                        print "Creating Objects in BRM Database \n";
                                        print "Updating DB Schema\n";
                                        $SKIP_INIT_OBJECTS   = "YES";
                                        $USE_SPECIAL_DD_FILE = "YES";
                                        $SPECIAL_DD_FILE     = "$UPG_DIR/$file";
                                        &pin_init(%DM);
                                        
                                        open( TMPFILE2, "<$logfile " )
                                                      || die "cannot read $logfile\n";
                                        while ( my $ReadString = <TMPFILE2> )
                                        {
                                                 if ( $ReadString =~ /^E/ )
                                                 {
                                                         $Result = 1;
                                                         print "Script Execution is unsuccessful For $file \n";
                                                         last;
                                                 }
                                        }
                                        close(TMPFILE2);
                                        if ( $Result == 0 )
                                        {
                                                open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                                print "Execution successfull For $file \n";
                                                $writestatement = "Execution successfull For $file \n";
                                                print TMPFILE3 ("$writestatement \n") ;
                                                close(TMPFILE3);
                                                $USE_SPECIAL_DD_FILE = "NO";
                                                $SKIP_INIT_OBJECTS = $TMP;
                                                print "################################################ \n";
                                                next;
                                        } else {
                                                open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                                print "Execution unsuccessfull for $file \n";
                                                $writestatement = "Execution unsuccessfull For $file \n";
                                                print TMPFILE3 ("$writestatement \n") ;
                                                close(TMPFILE3);
                                                last;
                                        }

                                }
                                else
                                {
                                        print "table $tablename already exists in the database \n";
                                }
			}
		}
        &pin_post_modular(%DM);
	}

	if ( $Result == 0 ) {
		print "Successfull Execution of create_new_objects \n";
	} elsif ( $Result == 2 ) {
		$writestatement = "File not found at required location \n";
                open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	} elsif ( $Result == 3 ) {
		$writestatement = "There are no files to process \n";
                open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	} else {
		$writestatement = "Script Execution is unsuccessful for create_new_objects. Please check the error in $logfile \n";
                open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	}

	return $Result;
}

sub modify_existing_objects_75ps1 {

	my $file_mod   = "";
	my $tablename  = "";
	my $columnname = "";
	my $time_stamp = "";
	my $Result     = 0;
	my $logfile =
	      "$PIN_LOG_DIR" . "/" . "dm_"
	    . "$MAIN_DM{'db'}->{'vendor'}" . "/" . "dm_"
	    . "$MAIN_DM{'db'}->{'vendor'}.pinlog";
	my $FirstElem           = $ALL_MODIFY_SCRIPTS_PS1[0];
	my $modifyobjectspinlog = "$PIN_TEMP_DIR" . "/modify_objects_75ps1.log";
	my $writestatement      = "";
	my $column_exist_flag   = "FALSE";
         
        
	%CM = %MAIN_CM;
	%DM = %MAIN_DM;

	open( TMPFILE3, ">$modifyobjectspinlog " )
	    || die "cannot read $modifyobjectspinlog \n";
        close(TMPFILE3);
	if ( $FirstElem eq "" ) {
		$Result = 3;
                print "No files to process \n";
	}
	else {
		&pin_pre_modular( %{ $DM{"db"} } );

		foreach $file_mod (@ALL_MODIFY_SCRIPTS_PS1) 
		{

                	print "################################################ \n"; 

			if ( !-e "$UPG_DIR/$file_mod" ) {
				print "$UPG_DIR/$file_mod not found \n";
				$Result = 2;
			} else {
				# get the current time from the environment before
                                # each iteration of upgrade scripts.
                                $StartTime = localtime( time() );
				$time_stamp = "Started $file_mod at " . $StartTime;
				print "$time_stamp \n";

				if ( $file_mod eq "PDC_modify_product.source")
				{
					$tablename  = "PRODUCT_USAGE_MAP_T";
					$columnname = "RATE_PLAN_CODE";
					$column_exist_flag = "TRUE";
				} 
				elsif ( $file_mod eq "event_schema_change.source")
				{
					$tablename = "event_customer_statuses_t";
					$columnname = "lifecycle_state";
					$column_exist_flag = "FALSE";
				} elsif ( $file_mod eq "dd_objects_slcm_service_t.source" )
                                {
                                        $tablename  = "SERVICE_T";
                                        $columnname = "LIFECYCLE_STATE";
                                        $column_exist_flag = "FALSE";
                                }

				# This check is introduced since there are a few scripts which is modifying
				# existing columns datatype and definition. For those scripts the column_exist_flag will have a
                                # value equal to TRUE. 

                                if($column_exist_flag eq "TRUE")
                                {
                                         if (VerifyPresenceOfFieldName( $columnname, $tablename, %{ $DM{"db"} }) == 0)
                                         {
                                               # column does not exist.
                                               print "$columnname not in $tablename. skipping Script Execution for $file_mod \n";
                                               open( TMPFILE3, ">>$modifyobjectspinlog " )|| die "cannot read $modifyobjectspinlog \n";
                                               $writestatement = "$columnname not in $tablename. skipping script execution for $file_mod \n";
                                               print TMPFILE3 ("$writestatement \n") ;
                                               close(TMPFILE3);
                                               next;
                                         }
                                }
				else  
				{
                                   if (VerifyPresenceOfFieldName( $columnname, $tablename, %{ $DM{"db"} }) != 0)
                                     { 
				            print "Column $columnname already exists in the database for Table $tablename \n";       	
                                            print "################################################ \n";
                                            next;
                                     } 
				}
                                print "Modifying DB Schema...\n";
                                $SKIP_INIT_OBJECTS   = "YES";
                                $USE_SPECIAL_DD_FILE = "YES";

                                $SPECIAL_DD_FILE = "$UPG_DIR/$file_mod";

                                &pin_init(%DM);

                                open( TMPFILE2, "<$logfile " ) || die "cannot read $logfile \n";

                                while ( my $ReadString = <TMPFILE2> ) {
                                        if ( $ReadString =~ /^E/ )
                                        {
                                                $Result = 1;
                                                print "Script Execution is unsuccessful For $file_mod \n";
                                                last;
                                        }
                                }

                                close(TMPFILE2);  

                                if ($Result == 0) 
                                { 
                                       open( TMPFILE3, ">>$modifyobjectspinlog " )|| die "cannot read $modifyobjectspinlog \n";
                                       print "Execution successfull For $file_mod \n"; 
                                       $writestatement = "Execution successfull For $file_mod \n";
                                       print TMPFILE3 ("$writestatement \n") ;
                                       $USE_SPECIAL_DD_FILE = "NO"; 
                                       $SKIP_INIT_OBJECTS   = $TMP; 
                                       print "################################################ \n"; 
                                       next; 
                                }  
                                else 
                                {
                                      open( TMPFILE3, ">>$modifyobjectspinlog " )|| die "cannot read $modifyobjectspinlog \n";
                                      print "Execution unsuccessfull for $file_mod \n";
                                      $writestatement = "Execution unsuccessfull for $file_mod \n"; 
                                      print TMPFILE3 ("$writestatement \n") ;
                                      last;
                                }
                        }
		}
                &pin_post_modular(%DM);
	}

	if ( $Result == 0 ) {
		print "Successfull Execution of modify_existing_objects \n";
	} elsif ( $Result == 2 ) {
		$writestatement = "File is not found at required location \n";
                open( TMPFILE3, ">>$modifyobjectspinlog " ) || die "cannot read $modifyobjectspinlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	} elsif ( $Result == 3 ) {
		$writestatement = "There are no files to process \n";
                open( TMPFILE3, ">>$modifyobjectspinlog " ) || die "cannot read $modifyobjectspinlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	} else {
		$writestatement = "Script Execution is unsuccessful. Please check the error in $logfile \n";
                open( TMPFILE3, ">>$modifyobjectspinlog " ) || die "cannot read $modifyobjectspinlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	}

	return $Result;
}
1;

