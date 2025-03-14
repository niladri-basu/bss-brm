#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)$Id: add_new_objects_75ps2.pl /cgbubrm_7.5.0.rwsmod/4 2013/01/10 03:48:03 hsnagpal Exp $
#
# $Header: bus_platform_vob/upgrade/upgrade_75ps2/oracle/add_new_objects_75ps2.pl /cgbubrm_7.5.0.rwsmod/4 2013/01/10 03:48:03 hsnagpal Exp $
#
# add_new_objects_75ps2.pl
#
# Copyright (c) 2008, 2013, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      add_new_objects_75ps2.pl - This module will result in creating new objects or modifying existing ones
#
#    DESCRIPTION
#      This File will contain subroutines to create objects or modify existing object behaviour
#      This file will be called from pin_74_75ps2_upgrade.pl first in the order.

#      For each feature, there will be having their own set of create or modify scripts
#      [These scripts will be having .source extension].
#      There will be one .source per addition of new table object or
#      one .source per addition of set of columns to an existing table object.
#      These scripts will be called one by one by this Perl File
#      add_new_objects_75ps2.pl for execution and updating the DB Schema
#      with new objects or modifying existing objects [tables or columns].
#
#    NOTES
#      This Script will be used to execute all the scripts which are creating
#      new objects/modifying existing objects in the Database and also updating
#      the Data Dictionary with this information.

#      The Driver File for upgrade which is the script "pin_74_75ps2_upgrade.pl"
#      will call this perl script (add_new_objects_75ps2.pl) through one of its wrappers APIs
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
#       the driver file "pin_74_75ps2_upgrade.pl". So in case a failed result value is returned,
#       the further execution process of upgrade will be stopped.
#       This stopping of the further execution will be handled in the driver file.
#
#    MODIFIED   (MM/DD/YY)
#    hsnagpal    09/07/12 - XbranchMerge hsnagpal_bug-14346231 from
#                           cgbubrm_7.5.0.2.0custfix.portalbase
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

our @ALL_CREATE_SCRIPTS_PS2 = ( "dd_objects_collections_ps2.source",
			   	"dd_objects_group_coll_targets.source",
				"dd_objects_audit_coll_gdtls.source",
				"dd_objects_group_coll_targets_mem.source",
			   	"init_objects_collections.source",
				"localization_init_objects.source");

our @ALL_MODIFY_SCRIPTS_PS2 = ( "dd_objects_pipeline_startup.source",
				"dd_objects_collections_action.source",
				"dd_objects_config_coll_actions.source",
				"update_schema_slm.source",
				"dd_objects_AM_ps2.source");

our @OPTIONAL_MANAGER_MODIFY_SCRIPTS = (
);

our @OPTIONAL_MANAGER_CREATE_SCRIPTS = (
);

our $UPG_DIR   = "$DD{'location'}";
our $StartTime = "";

sub create_new_objects_75ps2 {
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
	my $FirstElem           = $ALL_CREATE_SCRIPTS_PS2[0];
	my $createobjectspinlog = "$PIN_TEMP_DIR" . "/create_objects_75ps2.log";
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

		foreach $file (@ALL_CREATE_SCRIPTS_PS2) {

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
				if ( $file eq "init_objects_collections.source" && VerifyPresenceOfTable ("collections_action_t",%{ $DM{"db"} }) != 0 )
				{
                                	$sqlstatement = "select ACTION_NAME from config_collections_action_t where ACTION_NAME like 'Promise to Pay'; \n";
                                	&ExecuteSQL_Statement( "$sqlstatement", $statusflags, $statusflags, %{$DM{"db"}});
                               		open(TMPFILE, "<$SETUP_LOG_FILENAME " ) || die "cannot read $SETUP_LOG_FILENAME \n";
					$initobjres = 1;
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
                                       		 print "Creating collection_action object\n";
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
                                       		print "Collection Action object already exists. \n";
                                       		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                       		$writestatement = "Collection Action object already exists. \n";
                                       		print TMPFILE3 ("$writestatement \n") ;
                                       		close(TMPFILE3);
                                       		print "################################################ \n";
                                       		next;
                                    	 }
                                }
				elsif ( $file eq "localization_init_objects.source")
				{
                                	$sqlstatement = "select NAME from config_t where NAME like 'PaymentTool payment Types: Russian( Russia )'; \n";
                                	&ExecuteSQL_Statement( "$sqlstatement", $statusflags, $statusflags, %{$DM{"db"}});
                               		open(TMPFILE, "<$SETUP_LOG_FILENAME " ) || die "cannot read $SETUP_LOG_FILENAME \n";
					$initobjres = 1;
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
                                       		 print "Creating paymentTool object\n";
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
                                       		print "Localization object already exists. \n";
                                       		open( TMPFILE3, ">>$createobjectspinlog " ) || die "cannot read $createobjectspinlog \n";
                                       		$writestatement = "Localization object already exists. \n";
                                       		print TMPFILE3 ("$writestatement \n") ;
                                       		close(TMPFILE3);
                                       		print "################################################ \n";
                                       		next;
                                    	 }
                                }
				elsif ( $file eq "dd_objects_collections_ps2.source" && VerifyPresenceOfTable ("collections_action_t",%{ $DM{"db"} }) != 0 )
				{
                                        if (VerifyPresenceOfTable ("event_act_coll_repl_scen_t",%{ $DM{"db"} }) == 0
                                        && VerifyPresenceOfTable ("event_act_coll_prmstopay_t",%{ $DM{"db"} }) == 0)
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
                                       		print "table event_act_coll_prmstopay_t,event_act_coll_repl_scen_t already exists in the database \n";
						next;
                               		}
				}
				elsif ( $file eq "dd_objects_group_coll_targets.source" && VerifyPresenceOfTable ("collections_action_t",%{ $DM{"db"} }) != 0 )
				{
					$tablename = "group_collections_targets_t";
				}
                                elsif ( $file eq "dd_objects_group_coll_targets_mem.source" && VerifyPresenceOfTable ("collections_action_t",%{ $DM{"db"} }) != 0)
                                {
					$tablename = "event_group_coll_targets_mem_t";	
                                }
                                elsif ( $file eq "dd_objects_audit_coll_gdtls.source" && VerifyPresenceOfTable ("collections_action_t",%{ $DM{"db"} }) != 0)
                                {
					$tablename = "event_audit_coll_gdtls_t";	
                                }
				else
				{
					print "Collection optional manager is not installed, Moving ahead \n";
					print "################################################ \n";
					next;
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

sub modify_existing_objects_75ps2 {

	my $file_mod   = "";
	my $tablename  = "";
	my $classname  = "";
	my $columnname = "";
	my $time_stamp = "";
	my $Result     = 0;
	my $logfile =
	      "$PIN_LOG_DIR" . "/" . "dm_"
	    . "$MAIN_DM{'db'}->{'vendor'}" . "/" . "dm_"
	    . "$MAIN_DM{'db'}->{'vendor'}.pinlog";
	my $FirstElem           = $ALL_MODIFY_SCRIPTS_PS2[0];
	my $modifyobjectspinlog = "$PIN_TEMP_DIR" . "/modify_objects_75ps2.log";
	my $writestatement      = "";
	my $column_exist_flag   = "FALSE";
	my $present_in_all_schema   = 1;
         
        
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

		foreach $file_mod (@ALL_MODIFY_SCRIPTS_PS2) 
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


                                if ( $file_mod eq "dd_objects_pipeline_startup.source")
                                {
                                        $classname  = "/config/beid";
                                        $columnname = "PIN_FLD_VALIDITY_IN_DAYS";
                                        $column_exist_flag = "FALSE";
                                        $present_in_all_schema = 0;
                                }
                                elsif ( $file_mod eq "dd_objects_collections_action.source" && VerifyPresenceOfTable ("collections_action_t",%{ $DM{"db"} }) != 0 )
                                {
                                        $tablename  = "collections_action_t";
                                        $columnname = "target_action";
                                        $column_exist_flag = "FALSE";
                                        $present_in_all_schema = 1;
                                }
                                elsif ( $file_mod eq "dd_objects_config_coll_actions.source" && VerifyPresenceOfTable ("collections_action_t",%{ $DM{"db"} }) != 0 )
                                {
                                        $classname = "/config/collections/action";
                                        $columnname = "PIN_FLD_TARGET_ACTION";
                                        $column_exist_flag = "FALSE";
                                        $present_in_all_schema = 0;
                                }
                                elsif ( $file_mod eq "update_schema_slm.source" )
                                {
                                        $classname  = "/config/lifecycle_states";
                                        $columnname = "PIN_FLD_STRING_ID";
                                        $column_exist_flag = "FALSE";
                                        $present_in_all_schema = 0;
                                }
                                elsif ( $file_mod eq "dd_objects_AM_ps2.source" )
                                {
                                        $classname  = "/config/subscriber_preferences_map";
                                        $columnname = "PIN_FLD_STR_VERSION";
                                        $column_exist_flag = "FALSE";
                                        $present_in_all_schema = 0;
                                }
                                else
                                {
                                        print "Collection optional manager is not installed, Moving ahead \n";
                                        print "################################################ \n";
                                        next;
                                }

				# This check is introduced since there are a few scripts which is modifying
				# existing columns datatype and definition. For those scripts the column_exist_flag will have a
                                # value equal to TRUE. 

                                if($column_exist_flag eq "FALSE" && $present_in_all_schema == 0 )
                                {

                                        if (VerifyPresenceOfFieldInDD( $columnname, $classname, %{ $DM{"db"} }) == -1)
                                        {
                                                print "Column $columnname already exists in the database for object  $classname \n";
                                                print "################################################ \n";
                                                next;
                                        }
                                }
                                elsif($column_exist_flag eq "TRUE")
                                {
                                         if (VerifyPresenceOfFieldName( $columnname, $tablename, %{ $DM{"db"} }) == 0)
                                         {
                                               # column does not exist.
                                               $Result = 1;
                                               print "$columnname not in $tablename. Script Execution is unsuccessful for $file_mod \n";
                                               open( TMPFILE3, ">>$modifyobjectspinlog " )|| die "cannot read $modifyobjectspinlog \n";
                                               $writestatement = "$columnname not in $tablename. Script Execution is unsuccessful for $file_mod \n";
                                               print TMPFILE3 ("$writestatement \n") ;
                                               close(TMPFILE3);
                                               last; 
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

sub optional_managers_schema_creation_upgrade_75ps2 {
        my $file_mod   = "";
        my $tablename  = "";
    	my $base_table_existence = "";
        my $Result     = 0;
        my $logfile =
              "$PIN_LOG_DIR" . "/" . "dm_"
            . "$MAIN_DM{'db'}->{'vendor'}" . "/" . "dm_"
            . "$MAIN_DM{'db'}->{'vendor'}.pinlog";

    	my $FirstElem           = $OPTIONAL_MANAGER_CREATE_SCRIPTS[0];
        my $optionalmanagercreateobjlog = "$PIN_TEMP_DIR" . "/optional_manager_objects_creation_75.log";
        my $writestatement      = "";

        %CM = %MAIN_CM;
        %DM = %MAIN_DM;

        open( TMPFILE3, ">$optionalmanagercreateobjlog" ) || die "cannot read $optionalmanagercreateobjlog \n";
        close(TMPFILE3);

        open( TMPFILE2, ">$logfile" ) || die "cannot read $logfile \n";
        close(TMPFILE2);

        if ( $FirstElem eq "" ) {
                $Result = 3;
                print "No files to process \n";
        }
        else {
                &pin_pre_modular( %{ $DM{"db"} } );
                open( TMPFILE3, ">>$optionalmanagercreateobjlog" ) || die "cannot read $optionalmanagercreateobjlog \n";
                foreach $file_mod (@OPTIONAL_MANAGER_CREATE_SCRIPTS)
                {
                                if ($file_mod eq "731_74_create_recycle_suspended_usage.source")
                                {
                                    $tablename  = "RECYCLE_SUSPENDED_USAGE_T";
                                    $base_table_existence = "SUSP_USAGE_TELCO_INFO_T";
                                }
                                if (VerifyPresenceOfTable( $tablename, %{ $DM{"db"} }) == 0 && VerifyPresenceOfTable( $base_table_existence, %{ $DM{"db"} }) != 0)
                                {
                                 # Here the validation is being done that if the base table exists for that optional manager, which
                                 # indicates that the optional manager is present and the new table to be created is not present
                                 # will only the optional manager schema object creation script gets executed.

                                       if ( -e "$UPG_DIR/$file_mod")
                                       {
                                                print "################################################ \n";
                                                print "Creating Objects in DB Schema...\n";
                                                $SKIP_INIT_OBJECTS   = "YES";
                                                $USE_SPECIAL_DD_FILE = "YES";

                                                $SPECIAL_DD_FILE = "$UPG_DIR/$file_mod";
                                                # get the current time from the environment before
                                                # each iteration of upgrade scripts.
                                                $StartTime = localtime( time() );
                                                print "Started Executing $file_mod at " . $StartTime;
                                                $writestatement = "Executing the file $file_mod \n";
                                                print TMPFILE3 ("$writestatement \n");
                                                &pin_init(%DM);

                                                open( TMPFILE2, "<$logfile " ) || die "cannot read $logfile \n";

                                                while ( my $ReadString = <TMPFILE2> ) {
                                                if ( $ReadString =~ /^E/ )

                                                {
                                                        $Result = 1;
                                                        print "Script Execution is unsuccessful For $file_mod \n";
                                                        $writestatement = "Script Execution is unsuccessful For $file_mod \n";
                                                        print TMPFILE3 ("$writestatement \n");
                                                        last;
                                                }
                                                else
                                                {
                                                        $Result = 0;
                                                }
                                        }

                                        close(TMPFILE2);

                                        }
                                        else
                                        {
                                                print "The optional manager file $file_mod is not present in $PIN_HOME/sys/dd/data \n";
                                                $writestatement = "The optional manager file $file_mod is not present in $PIN_HOME/sys/dd/data \n";
                                                print TMPFILE3 ("$writestatement \n");
                                                $Result = 2;
                                        }

                                }

                                else
                                {
                                        #This when any of the optional manager is not installed
                                        $Result = -1;
 				}

                                 # if $Result is 1 or 2, this indicates failure or file not found. So it should exit out of the foreach loop and
                                 # stop further execution of the optional manager schema upgrade files.

                                 if ( $Result == 1 || $Result == 2)
                                 {
                                     last;
                                 }

                }
                &pin_post_modular(%DM);
                close(TMPFILE3);

        }
        if ( $Result == 0 ) {
                print "Successful Execution of the function optional_managers_schema_creation_upgrade \n";
                $writestatement = "Successful Execution of the function optional_managers_schema_creation_upgrade \n";
                open( TMPFILE3, ">>$optionalmanagercreateobjlog" ) || die "cannot read $optionalmanagercreateobjlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);

        } elsif ( $Result == 2) {

                print "Corresponding schema creation source file is not present in $PIN_HOME/sys/dd/data \n";
                $writestatement = "Corresponding schema creation source file is not present in $PIN_HOME/sys/dd/data \n";
                open( TMPFILE3, ">>$optionalmanagercreateobjlog" ) || die "cannot read $optionalmanagercreateobjlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);

        } elsif ( $Result == 1 ) {
                print "Schema Creation Script Execution is unsuccessful. Please check the error in $optionalmanagercreateobjlog \n";
                $writestatement = "Schema Creation Script Execution is unsuccessful. Please check the error in $logfile \n";
                open( TMPFILE3, ">>$optionalmanagercreateobjlog" ) || die "cannot read $optionalmanagercreateobjlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
        }

        return $Result;
}

sub optional_managers_schema_upgrade_75ps2 {
	my $file_mod   = "";
        my $tablename  = "";
        my $Result     = 0;
        my $logfile =
              "$PIN_LOG_DIR" . "/" . "dm_"
            . "$MAIN_DM{'db'}->{'vendor'}" . "/" . "dm_"
            . "$MAIN_DM{'db'}->{'vendor'}.pinlog";
	
	
        my $FirstElem           = $OPTIONAL_MANAGER_MODIFY_SCRIPTS[0];
        my $optionalmanagerlog = "$PIN_TEMP_DIR" . "/optional_manager_objects_74.log";
        my $writestatement      = "";

        %CM = %MAIN_CM;
        %DM = %MAIN_DM;

        open( TMPFILE3, ">$optionalmanagerlog" )
            || die "cannot read $optionalmanagerlog \n";
        close(TMPFILE3);

	open( TMPFILE2, ">$logfile" )
            || die "cannot read $logfile \n";
        close(TMPFILE2);

	if ( $FirstElem eq "" ) {
                $Result = 3;
                print "No files to process \n";
        }
        else {
                &pin_pre_modular( %{ $DM{"db"} } );

		open( TMPFILE3, ">>$optionalmanagerlog" ) || die "cannot read $optionalmanagerlog \n";
                foreach $file_mod (@OPTIONAL_MANAGER_MODIFY_SCRIPTS) 
                { 


                                if ($file_mod eq "7.3_7.3Patch_dd_objects_device_voucher.source")
                                {
				    $tablename  = "DEVICE_VOUCHER_T";
                                }
                                elsif ($file_mod eq "731_74_dd_objects_network_session_id.source")
                                {
                                    $tablename  = "ACTIVE_SESSION_TELCO_T";
                                } 

				# Here the checking is being done that if the table exists for that optional manager will
                                # only then the respective upgrade file existence be checked.
                                # This will ensure that execution will happen only when both the table and the
                                # respective schema modification file is present. 

				if (VerifyPresenceOfTable($tablename, %{ $DM{"db"} }) != 0) 
								
                               	{ 
                                       if ( -e "$UPG_DIR/$file_mod") 
                                       {   	
                                            	print "################################################ \n";
						print "Modifying DB Schema...\n";
                                        	$SKIP_INIT_OBJECTS   = "YES";
                                        	$USE_SPECIAL_DD_FILE = "YES";

                                        	$SPECIAL_DD_FILE = "$UPG_DIR/$file_mod";
						# get the current time from the environment before
                                		# each iteration of upgrade scripts.
                                		$StartTime = localtime( time() );
						print "Started Executing $file_mod at " . $StartTime;
						$writestatement = "Executing the file $file_mod \n";
						print TMPFILE3 ("$writestatement \n");	
                                        	&pin_init(%DM);

                                        	open( TMPFILE2, "<$logfile " ) || die "cannot read $logfile \n";

                                        	while ( my $ReadString = <TMPFILE2> ) {
                                                if ( $ReadString =~ /^E/ )

                                                {
                                                        $Result = 1;
                                                        print "Script Execution is unsuccessful For $file_mod \n";
							$writestatement = "Script Execution is unsuccessful For $file_mod \n";
							print TMPFILE3 ("$writestatement \n");
                                                        last;
                                                }
						else
						{
							$Result = 0;
						}
                                        }

                                        close(TMPFILE2);
	
                                        }
			                else 
                                        {
				                print "The optional manager file $file_mod is not present in $PIN_HOME/sys/dd/data \n";
				                $writestatement = "The optional manager file $file_mod is not present in $PIN_HOME/sys/dd/data \n";
				                print TMPFILE3 ("$writestatement \n");
			 	                $Result = 2;
			                }	 	 
				}
				else
				{
					#This when any of the optional manager is not installed
					$Result = -1;
				}

                                 # if $Result is 1 or 2, this indicates failure or file not found. So it should exit out of the foreach loop and 
                                 # stop further execution of the optional manager schema upgrade files.

                                 if ( $Result == 1 || $Result == 2)
                                 {
                                     last;
                                 }	

	        }
		&pin_post_modular(%DM);
		close(TMPFILE3);

	}
	if ( $Result == 0 ) {
        	print "Successful Execution of the function optional_managers_schema_upgrade \n";
               	$writestatement = "Successful Execution of the function optional_managers_schema_upgrade \n";
               	open( TMPFILE3, ">>$optionalmanagerlog" ) || die "cannot read $optionalmanagerlog \n";
               	print TMPFILE3 ("$writestatement \n");
               	close(TMPFILE3);

       	} elsif ( $Result == 2) {

		print "Corresponding source file is not present in $PIN_HOME/sys/dd/data \n";
		$writestatement = "Corresponding source file is not present in $PIN_HOME/sys/dd/data \n";
		open( TMPFILE3, ">>$optionalmanagerlog" ) || die "cannot read $optionalmanagerlog \n";
		print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);

	} elsif ( $Result == 1 ) {
		print "Script Execution is unsuccessful. Please check the error in $optionalmanagerlog \n";
               	$writestatement = "Script Execution is unsuccessful. Please check the error in $logfile \n";
               	open( TMPFILE3, ">>$optionalmanagerlog" ) || die "cannot read $optionalmanagerlog \n";
               	print TMPFILE3 ("$writestatement \n");
               	close(TMPFILE3);
       	}

       	return $Result;

}
1;

