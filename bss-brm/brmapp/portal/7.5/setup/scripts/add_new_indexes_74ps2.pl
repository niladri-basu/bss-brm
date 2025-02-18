#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# 
# @(#)$Id: add_new_indexes_74ps2.pl /cgbubrm_7.5.0.rwsmod/1 2013/03/07 22:17:39 hsnagpal Exp $
# $Header: bus_platform_vob/upgrade/upgrade_74ps2/oracle/add_new_indexes_74ps2.pl /cgbubrm_7.5.0.rwsmod/1 2013/03/07 22:17:39 hsnagpal Exp $
#
# add_new_indexes_74ps2.pl
# 
# Copyright (c) 2009, 2013, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      add_new_indexes_74ps2.pl -This module will result in creating new indexes and views. 
#
#    DESCRIPTION
#      This File will contain subroutines to create new indexes or views on the objects/tables
#      This file will be called from pin_upgrade_74ps2.pl .

#      Each of the Features will have their own set of index creation scripts
#      [These scripts will be having .source extension].
#      These scripts will be called one by one by this Perl File
#      add_new_indexes_74ps2.pl for execution and there by result in creating
#      the new indexes.
#
#    NOTES
#
#      This Script will be used to execute all the scripts which are creating
#      new indexes or views in the Database.

#      The Driver File for upgrade which is the script "pin_upgrade_74ps2.pl"
#      will call this perl script (add_new_indexes_74ps2.pl) through one of its wrappers APIs
#      named "optional_managers_index_upgrade".

#      How this script will work

#      This script will use the API "ExecuteShell_Piped"
#      to execute each of the index creation script [called one by one from add_new_indexes_74ps2.pl].
#      Each of the Index Creation Script will invoke suitable database APIs
#      (APIs exposed from pin_upg_common.source) to validate the index presence before going ahead
#      to creating the index.

#      This API takes as input each of the index creation file [.source file] and will return a result
#      based on the execution status of the file. Using the result value
#      a message will be printed on the prompt whether the particular scripts' [index creation script]
#      execution was a success or failure and the place where it failed.

#       Error Handling
#
#       The Error Handling will be done by logging the error messages in the log file.
#       This log file is add_new_optional_manager_indexes_74ps2.log which will be generated in $PIN_HOME/tmp directory.
#       So whenever there will be an error as part of execution of this script, there will
#       a value returned at the end of this script. Based on that return value, it will
#       be easier to track, the point of failure [in terms of name of feature scripts],
#       when this script is called by the wrapper API [optional_managers_index_upgrade()] from
#       the driver file "pin_upgrade_74ps2.pl". So in case a failed result value is returned,
#       the further execution process of upgrade will be stopped.
#       This stopping of the further execution will be handled in the driver file.

#
#    MODIFIED   (MM/DD/YY)
#    rasarka     12/30/09 - Creation
# 
#======================================================================================
use warnings;
use Env;

our %MAIN_DM;
our %MAIN_CM;


our %MAIN_DB;
our %DD;

our $UPG_DIR   = "$DD{'location'}";
our $StartTime = "";
our %DM;
our $PIN_TEMP_DIR;
our $SETUP_LOG_FILENAME;
our $SETUP_LOG_ACCESS_TYPE;
our $IDS_LOG_TIME;
our $IDS_SHOW_TIME;
# these variables are used by the api ExecuteShell_Piped(). Hence needed to initialize them.
our $DB_USER = $MAIN_DB{'user'};
our $DB_PWD = $MAIN_DB{'password'};
our $DB_ALIAS = $MAIN_DB{'alias'};

our $statusflag = "TRUE";

our @ALL_OPTIONAL_MANAGER_INDEX_SCRIPTS = (     "7.4PS2_create_indexes_collections_AIA.source",
                                                "7.4PS2_create_collections_view_AIA.source",
                                                "7.4PS2_modify_event_ordering_index.source"
                                          );

sub optional_managers_index_upgrade
{
        my $file = "";
        my $time_stamp = "";
        my $indexname = "";
        my $addnewindfile = "$PIN_TEMP_DIR/add_new_optional_manager_indexes_74ps2.log";
        my $commonapifile = "$UPG_DIR/pin_upg_common.source";
        my $ReadString = "";
        my $Result    = 0;
        my $FirstElem = $ALL_OPTIONAL_MANAGER_INDEX_SCRIPTS[0];
        my $writestatement = "";
        my $opt_mgr_tablename = "";
        my $return_status = -1;
        my $optionalmanagerflag = "no";

        %DM = %MAIN_DM;
        # execute the common api file.

        open( TMPFILE3, ">$addnewindfile " ) || die "cannot open $addnewindfile for writing. \n";
        if ( ($ENABLE_ENCRYPTION eq "Yes") && ($DB_PWD=~m/aes/)){
                $DB_PWD = psiu_perl_decrypt_pw($DB_PWD);
        }
        $CMD = "sqlplus -s $DB_USER/$DB_PWD\@$DB_ALIAS < " . "$commonapifile";
        $return_status = &ExecuteShell_Piped("$addnewindfile", $statusflag, $CMD, "" );
        close(TMPFILE3);

        if ( $return_status != 0 ) {
                open( TMPFILE3, ">>$addnewindfile " ) || die "cannot open $addnewindfile for writing. \n";
                $writestatement = "Execution failed for the file $commonapifile \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
                $Result = 4;
        }

        if ($Result != 4)
        {
                $SETUP_LOG_FILENAME = "$PIN_TEMP_DIR/tmp_new_optional_manager_indexes_74ps2.log";
                $SETUP_LOG_ACCESS_TYPE = "WRITE";
                &OpenLogFile( $SETUP_LOG_FILENAME, $SETUP_LOG_ACCESS_TYPE );

                foreach $file(@ALL_OPTIONAL_MANAGER_INDEX_SCRIPTS) {


                if ($file eq "7.4PS2_create_indexes_collections_AIA.source") {
                        $opt_mgr_tablename = "COLLECTIONS_SCENARIO_T";
                }
                elsif ($file eq "7.4PS2_create_collections_view_AIA.source") {
                        $opt_mgr_tablename = "CONFIG_COLLECTIONS_ACTION_T";
                }
                elsif ($file eq "7.4PS2_modify_event_ordering_index.source")     {
                        $opt_mgr_tablename = "TMP_PROFILE_EVENT_ORDERING_T";
                }
                if (VerifyPresenceOfTable($opt_mgr_tablename, %{ $DM{"db"} }) != 0) {
			$optionalmanagerflag = "yes";
                }
                else    {
                        $optionalmanagerflag = "no";
                }

                        if (( -e "$UPG_DIR/$file" ) && ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/ ) )     {
				$Result = 0;

                                if ($optionalmanagerflag eq "yes")      {

                                # get the current time from the environment before
                                # each iteration of upgrade scripts.
                                $StartTime = localtime( time() );

                                $time_stamp = "Started $file at " . $StartTime;
                		print "################################################ \n";
                                print "$time_stamp ..... \n";
                                &ExecuteSQL_Statement_From_File("$UPG_DIR/$file",$statusflag,$statusflag, %{$DM{"db"}});
                                    open( TMPFILE2, "<$SETUP_LOG_FILENAME " ) || die "cannot read $SETUP_LOG_FILENAME \n";
                                    open( TMPFILE3, ">>$addnewindfile ") || die "cannot open $addnewindfile for writing. \n";
                                    while ($ReadString = <TMPFILE2> )
                                                {
                                                        if ( $ReadString =~ /ORA-([\d]*):.*|SP2-([\d]*):.*/)
                                                        {
                                                                $Result = 1;
                                                                # writing the error message till the end of the file.
                                                                $writestatement = $ReadString;
                                                                print TMPFILE3 ("$writestatement \n");
                                                        }
                                                }
                                                close(TMPFILE3);
                                                close(TMPFILE2);

                                                if ( $Result == 0 ) {
                                                        print "Execution successfull For $file \n";
                                                        $writestatement = "Execution successfull For $file \n";
                                                        open( TMPFILE3, ">>$addnewindfile ") || die "cannot open $addnewindfile for writing. \n";
                                                        print TMPFILE3 ( "$writestatement \n");
                                                        close(TMPFILE3);
                                                        print "################################################ \n";
                                                        next;
                                                } else {
                                                        print "Script Execution is unsuccessful For $file \n";
                                                        $writestatement = "Script Execution is unsuccessful For $file \n";
                                                        open( TMPFILE3, ">>$addnewindfile ") || die "cannot open $addnewindfile for writing. \n";
                                                        print TMPFILE3 ( "$writestatement \n");
                                                        close(TMPFILE3);
                                                        last;
                                                }
                                }
                                else    {
                                                $Result = -1;
                                                next;
                                }


                          }

                        else
                         {
                                print "$file not found \n";
                                $Result = 2;
                                $writestatement = "$file not found \n";
                                open(TMPFILE3, ">>$addnewindfile")||die "cannot open $addnewindfile for writing. \n";
                                print TMPFILE3 ("$writestatement \n");
                                close(TMPFILE3);
                                last;
                         }
                }
	}

unlink "$SETUP_LOG_FILENAME";
return $Result;
}
1;

