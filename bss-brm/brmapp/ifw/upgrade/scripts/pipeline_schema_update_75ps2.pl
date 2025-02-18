#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# 
#@(#)$Id: pipeline_schema_update_75ps2.pl /cgbubrm_7.5.0.rwsmod/2 2012/09/17 06:10:13 hsnagpal Exp $
#
# modify_columns_75ps2.pl
# 
# Copyright (c) 2010, 2012, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      modify_columns_75ps2.pl - This module will result in creating missing indexes . 
#
#    DESCRIPTION
#	This File will contain subroutines to increase the columns size on IFW_DUPLICATECHECK table

#	These scripts will be called one by one by this Perl File
#	modify_columns_75ps2.pl for execution.
#
#    NOTES
#	The Driver File for upgrade which is the script "pin_74_75ps2_pipeline_upgrade.pl"
#	will call this perl script (modify_columns_75ps2.pl)  through one of its wrappers APIs
#	named modify_columns_75ps2() .

#    ERROR HANDLING
#	The Error Handling will be done by logging the error messages in the log file.
#	This log file is modify_columns_75ps2.log which will be generated in $IFW_HOME/log directory.

#    MODIFIED   (MM/DD/YY)
#    hsnagpal    07/20/11 - Creation
#
use warnings;
use Env;

our %MAIN_DM;
our %MAIN_CM;


our %MAIN_DB;
our %DD;
our $IFW_LOG_DIR     = "$IFW_HOME/log";
our $UPG_DIR   = "$IFW_HOME/upgrade/scripts";
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

our @ALL_INDEX_SCRIPTS_75PS = ( "pipeline_tapinfo_upgrade.source",
				"schema_change_pdc_migration.source",
				"pcc_enhancement_ps2.source");

sub modify_columns_75ps2 {
        my $file = "";
        my $time_stamp = "";
        my $addnewindfile = "$IFW_LOG_DIR/modify_columns_75ps2.log";
        my $ReadString = "";
        my $Result    = 0;
        my $FirstElem = $ALL_INDEX_SCRIPTS_75PS[0];
        my $writestatement = "";
	my $opt_mgr_tablename = "";


        %DM = %MAIN_DM;

        if ( $FirstElem eq "" ) {
                $Result = 3;
                $writestatement = "No files to process \n";
                open( TMPFILE3, ">$addnewindfile " )|| die "cannot read $addnewindfile \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
        } else {
                $SETUP_LOG_FILENAME = "$IFW_LOG_DIR/tmp_modify_columns_75ps2.log";
                $SETUP_LOG_ACCESS_TYPE = "WRITE";
                &OpenLogFile( $SETUP_LOG_FILENAME, $SETUP_LOG_ACCESS_TYPE );
        
	        foreach $file (@ALL_INDEX_SCRIPTS_75PS) {

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
