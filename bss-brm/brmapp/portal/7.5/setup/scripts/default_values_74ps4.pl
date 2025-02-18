#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)$Id: default_values_74ps4.pl /cgbubrm_7.3.2.rwsmod/1 2010/05/05 11:30:18 akchhabr Exp $ 
#
# $Header: bus_platform_vob/upgrade/upgrade_74ps4/oracle/default_values_74ps4.pl /cgbubrm_7.3.2.rwsmod/1 2010/05/05 11:30:18 akchhabr Exp $
#
# default_values_74ps4.pl
#
# Copyright (c) 2009, 2010, Oracle and/or its affiliates. All rights reserved. 
#
#    NAME
#      default_values_74ps4.pl -  This module will result in modyfying existing Business Params or
#                              doing Data Reorganization
#
#    DESCRIPTION
#      This File will contain subroutines to modifying existing Business Params or
#      doing Data Reorganization
#      This file will be called from pin_upgrade_74ps4.pl third in the order.
#
#    NOTES
#
#	This Script will be used to execute the script "default_values_74ps4.source"
#	The script "default_values_74ps4.source" will be containing the logic for
#	data reorganization of all 7.4ps4 Features having upgrade impact and also modification of the
#	existing business params. This is the only file which will be called
#	from this script.
#       The Driver File for upgrade which is the script "pin_upgrade_74ps4.pl" will call this
#       perl script (default_values_74ps4.pl) through one of its wrappers named "default_values_74ps4()"

#       This script will use the API "ExecuteShell_Piped" [which is a part of default installation]
#       to execute the contents in "default_values_74ps4.source". This API takes as
#       input the script "default_values_74ps4.source" file and will return the result based on the
#       execution status in an outfile generated at $PIN_HOME/tmp directory.
#       This output file is "tmp_default_values.out". Reading this file, there will be a search
#       for any error occurred and a result value returned. Using the result value
#       a message will be printed on the prompt whether the script execution was a success
#       or failure and the place where it failed.

#       Error Handling
#
#       The Error Handling will be done by logging the error messages in the log file.
#       This log file is "tmp_default_values.out" which will be generated in $HOME/tmp directory.
#       So whenever there will be an error as part of execution of this script, there will
#       a value returned at the end of this script based on the contenets in "tmp_default_values.out".
#       Based on that return value, it will
#       be easier to track the error, while executing the default_values_74ps4.source script called from
#       the wrapper API [default_values_74ps4()] which in turn is called from the pin_upgrade_74ps4.pl.
#       So in case a failed result value is returned,
#       the further execution process of upgrade will be stopped.
#       This stopping of the further execution will be handled in the driver file.
#
#    MODIFIED   (MM/DD/YY)
#    akchhabr     04/30/10 - Creation
#======================================================================================
use warnings;
use Env;

our %MAIN_DM;
our %MAIN_CM;


our %MAIN_DB;

our %DB;

our $StartTime = "";
our %DM;
our %CM;
our $SETUP_LOG_FILENAME;
our $SETUP_LOG_ACCESS_TYPE;

our $statusflag = "TRUE";

our $PIN_TEMP_DIR;
our $UPG_DIR = "$PIN_HOME/sys/dd/data";

our @DEFAULT_VALUES_SCRIPTS_PS4 = ("default_values_74ps4.source");

sub default_values_74ps4 {

	my $file = "";
	my $time_stamp = "";
	my $tmpOutFile          = "$PIN_TEMP_DIR" . "/tmp_default_values74ps4.log";
	my $defaultvaluespinlog = "$PIN_TEMP_DIR" . "/default_values_74ps4.log";
	my $CMD = "";
	my $Result = 0;
	my $FirstElem = $DEFAULT_VALUES_SCRIPTS_PS4[0];
	my $writestatement = "";
	my $return_status = -1;

	%DM = %MAIN_DM;
     	%CM = %MAIN_CM;
	%DB = %MAIN_DB;		

	if ( $FirstElem eq "" ) {
		$Result = 3;
	} else {
		$SETUP_LOG_FILENAME = "$tmpOutFile";
                	$SETUP_LOG_ACCESS_TYPE = "WRITE";
		&OpenLogFile( $SETUP_LOG_FILENAME, $SETUP_LOG_ACCESS_TYPE );
		foreach $file (@DEFAULT_VALUES_SCRIPTS_PS4) {

                print "################################################ \n";
		print "filename is $UPG_DIR/$file \n";

			if (       ( -e "$UPG_DIR/$file" )
				&& ( $MAIN_DM{'db'}->{'vendor'} =~ /oracle/ ) )
			{
				# get the current time from the environment before
                                # each iteration of upgrade scripts.
                                $StartTime = localtime( time() );

				$time_stamp = "Started $file at " . $StartTime;

				print "$time_stamp ..... \n";

				# use the api ExecuteSQL_Statement_From_File () to execute the default_values script 
				&ExecuteSQL_Statement_From_File("$UPG_DIR/$file",$statusflag,$statusflag, %{$DM{"db"}});
				open( TMPFILE2, "<$SETUP_LOG_FILENAME") || die "cannot read $SETUP_LOG_FILENAME \n";
				open( TMPFILE3, ">$defaultvaluespinlog") || die "cannot read $defaultvaluespinlog \n";
				while ( my $ReadString = <TMPFILE2> ) {
					if ( $ReadString =~ /ORA-([\d]*):.*|SP2-([\d]*):.*/)
					{
						$Result = 1;
					}
                                        if ($Result == 1)
                                        {
                                            $writestatement = $ReadString;
                                            print TMPFILE3 ("$writestatement \n");
                                        }
				}
                                close(TMPFILE3);
				close(TMPFILE2);

				if ( $Result == 0 ) {
                                        open( TMPFILE3, ">>$defaultvaluespinlog " ) || die "cannot read $defaultvaluespinlog \n";
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
                                            open( TMPFILE3, ">>$defaultvaluespinlog " ) || die "cannot read $defaultvaluespinlog \n";
                                            $writestatement = "Execution is unsuccessful for $file \n";
                                            print TMPFILE3 ("$writestatement \n");
                                            close(TMPFILE3);
                                            last;
                                }

			} else {
				print "File $file not found \n";
				$Result = 2;
                                # This code is added to record the file non-existant message into the 
                                # log file for default values.
                                open( TMPFILE3, ">>$defaultvaluespinlog " ) || die "cannot read $defaultvaluespinlog \n";
                                $writestatement = "File $file not found \n";
                                print TMPFILE3 ("$writestatement \n");
                                close(TMPFILE3);

			}
                     
		}
		unlink "$SETUP_LOG_FILENAME";
	}

	if ( $Result == 0 ) {

                # If execution of the default values module is successfull, then record the success message 
                # into the log file for default values. 

	        open( TMPFILE3, ">>$defaultvaluespinlog " ) || die "cannot read $defaultvaluespinlog \n";
                $writestatement = "Successfull Execution of the function default_values_74ps4 \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	} elsif ( $Result == 2 ) {
                print "File default_values_74ps4.source file is not found under $PIN_HOME/sys/dd/data directory. \n";
	} elsif ( $Result == 3 ) {
		$writestatement = "There are no files to process \n";
                open( TMPFILE3, ">>$defaultvaluespinlog " ) || die "cannot read $defaultvaluespinlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	} else {
		$writestatement = "Script Execution is unsuccessful. Please check the error in $defaultvaluespinlog \n";
                open( TMPFILE3, ">>$defaultvaluespinlog " ) || die "cannot read $defaultvaluespinlog \n";
                print TMPFILE3 ("$writestatement \n");
                close(TMPFILE3);
	}

	return $Result;
}
1;

