#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# 
# $Header: bus_platform_vob/upgrade/upgrade_74ps3/oracle/add_new_indexes_74ps3.pl /cgbubrm_main.rwsmod/1 2011/09/15 04:08:34 hsnagpal Exp $
#
# add_new_indexes_74ps3.pl
# 
# Copyright (c) 2010, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      add_new_indexes_74ps3.pl - This module will result in creating missing indexes . 
#
#    DESCRIPTION
#	This File will contain subroutines to create missing indexes on Audit tables
#	AU_PURCHASED_PRODUCT_T,AU_PURCHASED_DISCOUNT_T,AU_GROUP_SHARING_PROFILES_T,
#	AU_GROUP_SHARING_PROFILES_T.

#	These scripts will be called one by one by this Perl File
#	add_new_indexes_74ps3.pl for execution and there by result in creating
#	missing indexes . 
#
#    NOTES
#	This Script will be used to execute all the scripts which are creating
#	missing indexes in the Database.	

#	The Driver File for upgrade which is the script "pin_upgrade_74ps3.pl"
#	will call this perl script (add_new_indexes_74ps3.pl)  through one of its wrappers APIs
#	named add_new_indexes_74ps3() .

#    ERROR HANDLING
#	The Error Handling will be done by logging the error messages in the log file.
#	This log file is add_new_indexes_74_ps3.log which will be generated in $PIN_HOME/tmp directory.

#    MODIFIED   (MM/DD/YY)
#    akchhabr    03/01/10 - Creation
#
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

our @ALL_INDEX_SCRIPTS_PS3 = ("create_missing_indexes_au_tables_ps3.source");

sub add_new_indexes_74ps3 {
        my $file = "";
        my $commonapifile = "$UPG_DIR/pin_upg_common.source";
        my $time_stamp = "";
        my $addnewindfile = "$PIN_TEMP_DIR/add_new_indexes_74_ps3.log";
        my $ReadString = "";
        my $Result    = 0;
        my $FirstElem = $ALL_INDEX_SCRIPTS_PS3[0];
        my $writestatement = "";

        %DM = %MAIN_DM;

        if ( $FirstElem eq "" ) {
                $Result = 3;
                $writestatement = "No files to process \n";
                open( TMPFILE3, ">$addnewindfile " )|| die "cannot read $addnewindfile \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
        } else {
                $SETUP_LOG_FILENAME = "$PIN_TEMP_DIR/tmp_new_indexes_74_ps3.log";
                $SETUP_LOG_ACCESS_TYPE = "WRITE";
                &OpenLogFile( $SETUP_LOG_FILENAME, $SETUP_LOG_ACCESS_TYPE );

                foreach $file (@ALL_INDEX_SCRIPTS_PS3) {

                print "################################################ \n";

                        if (( -e "$UPG_DIR/$file" ) && ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/ ) )
                        {
                                # get the current time from the environment before
                                # each iteration of upgrade scripts.
                                $StartTime = localtime( time() );

                                $time_stamp = "Started $file at " . $StartTime;
                                print "$time_stamp ..... \n";
                                &ExecuteSQL_Statement_From_File("$UPG_DIR/$file",$statusflag,$statusflag, %{$DM{"db"}});
                                                open( TMPFILE2, "<$SETUP_LOG_FILENAME " ) || die "cannot read $SETUP_LOG_FILENAME \n";
                                                open( TMPFILE3, ">>$addnewindfile ") || die "cannot read $addnewindfile \n";
                                                while ($ReadString = <TMPFILE2> )
                                                {
                                                        if ( $ReadString =~ /ORA-([\d]*):.*|SP2-([\d]*):.*/)
                                                        {
                                                                $Result = 1;
                                                        }
                                          # writing the error message till the end of the file.

                                          if ($Result == 1 )
                                                        {
                                                           $writestatement = $ReadString;
                                                           print TMPFILE3 ("$writestatement \n");
                                                        }
                                                }
                                                close(TMPFILE3);
                                                close(TMPFILE2);

                                                if ( $Result == 0 ) {
                                                        print "Execution successful For $file \n";
                                                        $writestatement = "Execution successful For $file \n";
                                                        open( TMPFILE3, ">>$addnewindfile ") || die "cannot read $addnewindfile \n";
                                                        print TMPFILE3 ( "$writestatement \n");
                                                        close(TMPFILE3);
                                                        print "################################################ \n";
                                                        next;
                                                } else {
                                                        print "Script Execution is unsuccessful For $file \n";
                                                        $writestatement = "Script Execution is unsuccessful For $file \n";
                                                        open( TMPFILE3, ">>$addnewindfile ") || die "cannot read $addnewindfile \n";
                                                        print TMPFILE3 ( "$writestatement \n");
                                                        close(TMPFILE3);
                                                        last;
                                                }
                          }
                        else
                         {
                                print "$file not found \n";
                                $Result = 2;
                                $writestatement = "$file not found \n";
                                open(TMPFILE3, ">>$addnewindfile")||die "cannot read $addnewindfile \n";
                                print TMPFILE3 ("$writestatement \n");
                                close(TMPFILE3);
                                last;
                         }
                        }
                        unlink "$SETUP_LOG_FILENAME";
        }

return $Result;
}
