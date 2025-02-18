#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# 
#@(#)$Id: modify_schema_75ps6.pl /cgbubrm_7.5.0.rwsmod/2 2013/11/14 01:54:26 mkothari Exp $
#
# modify_columns_75ps6.pl
# 
# Copyright (c) 2010, 2013, Oracle and/or its affiliates. All rights reserved.
#
#    NAME
#      modify_columns_75ps6.pl - This module will result in creating missing indexes . 
#
#    DESCRIPTION

#	These scripts will be called one by one by this Perl File
#	modify_columns_75ps6.pl for execution.
#
#    NOTES
#	The Driver File for upgrade which is the script "pin_upgrade_pipeline_75ps6.pl"
#	will call this perl script (modify_columns_75ps6.pl)  through one of its wrappers APIs
#	named modify_columns_75ps6() .

#    ERROR HANDLING
#	The Error Handling will be done by logging the error messages in the log file.
#	This log file is modify_columns_75ps6.log which will be generated in $IFW_HOME/log directory.

#    MODIFIED   (MM/DD/YY)
#    mkothari    08/26/13 - Creation
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
our $statusflag = "TRUE";

our @ALL_MODIFY_SCRIPTS_75PS6 = ("pipeline_modify_fk_constraint.source");

sub modify_columns_75ps6 {
        my $file = "";
        my $time_stamp = "";
        my $addnewindfile = "$IFW_LOG_DIR/modify_columns_75ps6.log";
        my $ReadString = "";
        my $Result    = 0;
        my $FirstElem = $ALL_MODIFY_SCRIPTS_75PS6[0];
        my $writestatement = "";

        %DM = %MAIN_DM;

        if ( $FirstElem eq "" ) {
                $Result = 3;
                $writestatement = "No files to process \n";
                open( TMPFILE3, ">$addnewindfile " )|| die "cannot read $addnewindfile \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
        } else {
                $SETUP_LOG_FILENAME = "$IFW_LOG_DIR/tmp_modify_columns_75ps6.log";
                $SETUP_LOG_ACCESS_TYPE = "WRITE";
                &OpenLogFile( $SETUP_LOG_FILENAME, $SETUP_LOG_ACCESS_TYPE );
        
	        foreach $file (@ALL_MODIFY_SCRIPTS_75PS6) {

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
