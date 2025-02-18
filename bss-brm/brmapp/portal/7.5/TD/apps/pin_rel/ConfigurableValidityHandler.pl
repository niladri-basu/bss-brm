#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# @(#)%Portal Version: ConfigurableValidityHandler.pl:UelEaiVelocityInt:4:2006-Sep-05 22:24:56 %
#
#       Copyright (c) 2006 Oracle. All rights reserved.
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license
#       or sublicense agreement.
#

#
# File:  ConfigurableValidityHandler.pl
# Title: configurable validity batch handler script
#
# Description:
#       This script is responsible for:
#       calling the batch application to load the rated CDR using REL
#       and then load the corresponding first usage products and discounts file(if any) and the 
#	first usage resources file(if any) using UEL.Also , it loads Out of order files 
#       (if any) associated with the rated CDR.
#======================================================================================


require "ConfigurableValidityHandler_config.values";
require "getopts.pl";

use Sys::Hostname;
use File::Copy;
use File::Basename;
use File::Path;
use pcmif;
use Fcntl;

# REL handler would act as any other handler and its states
# would be used to update the database.However, the REL handler status
# would be recorded based on the exit status of the other two UEL instances(if any)
# and OOD instances(if any).
# Below are some scenarios:
# (1) If REL succeeds and there are no corresponding first usage files or OOD files,
# this handler object would be updated with success status in the database.
# (2) If REL succeeds and if loading any of the first usage files or OOD files fails, 
# the handler object would be marked failed in the database.
# (3) If REL succeeds and the  loading of corresponding first usage files and OOD files also
# succeeds, handler object would be marked as success in the database.
# (4) If REL fails, the handler object would be marked failed, and the handler would 
# exit without  checking for the presence of first usage files or OOD files.



# Define the Rel Handler status variables that return
# to the database.

$NO_ERROR = 0;
$HANDLER_STARTED = 1;                   # Handler started properly.
$COMPLETED_NO_ERROR = 19;               # The file was processed by the batch
                                        # application with no error.
$DEAD_STATUS = 100;                     # Status of a previously failed handler.
$WITH_ERROR = 101;                      # The file was processed by the batch
                                        # application with error.
$REJECTED = 102;                        # The file was rejected by the batch
                                        # application.
$PILOT_ERROR = 103;                     # Batch application failed with
                                        # pilot error.
$NO_FILE_TYPE = 104;                    # File does not exist.
$FAIL_TO_MOVE_FILE = 105;               # Failed to move the file to the
                                        # processing directory.
$NO_REL_EXEC = 106;                     # Batch application executable does
                                        # not exit.
$FAIL_TO_START_REL = 107;               # Failed to start batch application.

$FAILED_TO_OPEN_LOG_FILE = 108;

# UEL application exit codes.

$FILE_CHECK_ERROR = -1;
$MEMORY_ERROR = -2;
$DISK_SPACE_ERROR = -3;
$TEMPLATE_ERROR = -4;
$BAD_INF_CONNECTION = -100;
$FIELD_PARSE_ERROR = 1;
$ACCT_FORMAT_ERROR = 2;
$LOAD_FORMAT_ERROR = 3;
$PREV_PARSE_ERROR = 4;
$TOO_MANY_LOAD_ERROR = 5;
$COMMAND_LINE_ARG_ERROR = 10;
$FILE_NOT_FOUND_ERROR = 11;
$ACCT_OPCODE_ERROR = 100 ;
$LOAD_OPCODE_ERROR = 101;

# OOD application exit codes

$PROCESS_ERROR = 1;
$OOD_FIELD_PARSE_ERROR = 2;

#
# Value to massage negative batch application exit codes under Unix.
$UNIX_SHIFT = 8;

# REL error codes that are used here.
#
$PROCESS_IS_RUNNING = 1030;

#
# Get the current time.
$localtime = localtime();

#
# Command line argument.
&Getopts('p:d:') || &usage;

if (!defined $opt_p) {
        &usage;
}
$current_poid = $opt_p;

#
# Check if there is a log file associated with the handler
open(LOG, ">>$LOGFILE") or &HandlerDie($FAILED_TO_OPEN_LOG_FILE, $current_poid);


#
# Get the current handler process id (PID)
$PID = $$;


#
# Log a debugging message in the handler log file
if ($DEBUG) {
        print LOG "Handler associated with '$current_poid' started\n";
        print LOG "at $localtime with PID = $PID.\n";
}

#
# setup and connect
my $db_no = "";
$ebufp = pcmif::pcm_perl_new_ebuf();
$pcm_ctxp = pcmif::pcm_perl_connect($db_no, $ebufp);
if (pcmif::pcm_perl_is_err($ebufp)) {
        pcmif::pcm_perl_print_ebuf($ebufp);
        clean_exit(1);
} else {
        $my_session = pcmif::pcm_perl_get_session($pcm_ctxp);
        if ($DEBUG) {
                print LOG "$PID: Default DB is: $db_no\n";
                print LOG "$PID: Session poid is: ", $my_session, "\n";
        }
}


#
# Create the input Flist to update object status to STARTED.
$T_time = pcmif::pin_perl_time();
$hostname = hostname();
$f1 = << "END"
0 PIN_FLD_POID                               POID [0] $current_poid
0 PIN_FLD_START_T                          TSTAMP [0] ($T_time)
0 PIN_FLD_HOSTNAME                            STR [0] "$hostname"
0 PIN_FLD_PID                                 INT [0] $$
0 PIN_FLD_STATUS                             ENUM [0] $HANDLER_STARTED
END
;


#
# Convert the flist string into an actual FList
$flistp = pcmif::pin_perl_str_to_flist($f1, $db_no, $ebufp);
if (pcmif::pcm_perl_is_err($ebufp)) {
        print LOG "$PID: Flist conversion failed:\n$f1\n";
        pcmif::pcm_perl_print_ebuf($ebufp);
        clean_exit(1);
}


#
# Call opcode to set status to STARTED.
$out_flistp = pcmif::pcm_perl_op($pcm_ctxp, "PCM_OP_WRITE_FLDS",
                                     0, $flistp, $ebufp);


#
# If there is an error, log a message and die.
if (pcmif::pcm_perl_is_err($ebufp)) {
        print LOG "$PID: Failed to update handler object.\n";
        pcmif::pcm_perl_print_ebuf($ebufp);
        pcmif::pin_flist_destroy($flistp);
        pcmif::pin_flist_destroy($out_flistp);
        clean_exit(1);
}


#
# Upon success, destroy the input and return flists.
pcmif::pin_flist_destroy($flistp);
pcmif::pin_flist_destroy($out_flistp);


#
# Perform housekeeping tasks if the -d commandline option was used.
if (defined $opt_d) {
        $dead_poid = $opt_d;
        print LOG "$PID: Previously started handler associated with "
                        . "$dead_poid has died.\n";

        #
        # Update the handler status of that handler's object to DEAD.
        $T_time = pcmif::pin_perl_time();
        $f1 = << "END"
        0 PIN_FLD_POID                               POID [0] $dead_poid
        0 PIN_FLD_END_T                            TSTAMP [0] ($T_time)
        0 PIN_FLD_STATUS                             ENUM [0] $DEAD_STATUS
END
;


        #
        # Convert the flist string into an actual FList
        $flistp = pcmif::pin_perl_str_to_flist($f1, $db_no, $ebufp);
        if (pcmif::pcm_perl_is_err($ebufp)) {
                print LOG "$PID: Flist conversion failed:\n$f1\n";
                pcmif::pcm_perl_print_ebuf($ebufp);
                clean_exit(1);
        }


        #
        # Call the opcode PCM_OP_WRITE_FLDS to update status.
        $out_flistp = pcmif::pcm_perl_op($pcm_ctxp,
                        "PCM_OP_WRITE_FLDS", 0, $flistp, $ebufp);

        #
        # If there is an error, print a message and die.
        if (pcmif::pcm_perl_is_err($ebufp)) {
                print LOG "$PID: PCM_OP_WRITE_FLDS failed.\n";
                pcmif::pcm_perl_print_ebuf($ebufp);
                $out = pcmif::pin_perl_flist_to_str($out_flistp, $ebufp);
                clean_exit(1);
        }

        #
        # Destroy the input and return flists.
        pcmif::pin_flist_destroy($flistp);
        pcmif::pin_flist_destroy($out_flistp);
}


#
# Find input file associated with the handler.
# Get the list of files in the staging directory; skip all beginning with '.'

$error_flag = 0;
opendir STAGING_DIR, "$REL_STAGING" or $error_flag = 1;
if ($error_flag == 1)
{
	print LOG "$PID: Cannot open directory $REL_STAGING";
	&HandlerDie($WITH_ERROR, $current_poid);
}

@allfiles = grep !/^$REL_STAGING\/\./, map "$REL_STAGING/$_", readdir(STAGING_DIR);
closedir(STAGING_DIR);

#
# Ensure the user is not passing the directory path name
# within the file type.
$FILETYPE = basename ($FILETYPE);

#
# Find files matching specified pattern in the staging dir.

$FILETYPE =~ s/\./\\\./g;
$FILETYPE =~ s/\*/\.*/g;

@file_type = grep /^$REL_STAGING.$FILETYPE$/, @allfiles;

$numelements = @file_type;

if ($numelements <=  0) {
        print LOG "$PID: No files match specified pattern, exiting.\n";
       	&HandlerDie($NO_FILE_TYPE, $current_poid);
}

#
# Sort matching files based on creation date.
foreach $file(@file_type){
        $age{$file} = -M$file;
}
@sorted_allfiles = sort byage @file_type;

#
# Reformat directory path name based on operating system type.
# Lets assume its unix
$pinRELDir =~ s/\\/\//g;

#
# Prepare input files for processing.
$moved_a_file = 0; # Set to 1 when a file is successfully moved.

foreach $file(@sorted_allfiles) {
       	#
       	# Move file from the staging directory to the processing directory.
	$lock_file = $REL_PROCESSING . "/" . basename($file) . ".lock";
	if (sysopen (FILE, $lock_file , O_RDWR|O_EXCL|O_CREAT, 0755)) {
       		$retval = &callTheMoveToProcessing($file, $REL_PROCESSING, *LOG);

		close(FILE);
        	# Remove the lock file
        	unlink $lock_file;

       		if (!$retval) {
			# The directory does not exist or some other error.
               		&HandlerDie($FAIL_TO_MOVE_FILE, $current_poid);
       		} elsif ($retval == -1) {
               		#
			# If the move failed on a 'file not found' error, it means
			# another parallel handler took that file.  This handler
			# will try to get another file.
               		next;

		}

		$moved_a_file = 1;
        	if ($DEBUG) {
                	print LOG "$PID: File $file moved to the "
                        . "processing directory.\n";
        	}
	}
	else {
	   if($DEBUG) {
		print LOG "$PID: File already processed by another batch handler. \n";
	   }
		next;
	}	

	# Logic to process first usage files(if any) starts here.

	$ret_val_rel = 0;
	$ret_val_prod_disc = 0;
	$ret_val_resources = 0;
	$prod_disc_file_name = "";
	$resources_file_name = "";
	$first_usage_or_ood_file_found = 0;
	$irel_file_name = "";
	$sys_cmd_ret_value = 0;
	
	$ret_val_rel = &ExecuteRELInstance($file);
	if ($ret_val_rel == $NO_ERROR)
	{
		
        	# REL file name would have been appended with .bc by BC
        	# To get the corresponding  first usage files we have to strip it off and also
        	# strip off the prefix and suffix(if any) to get the base name which can then be used to
        	# match against the corresponding first usage files.


		$irel_file_name = rel_base_name(basename($file));

		# Check if there is a log file associated with the handler
		open (CVLOG, ">>$CV_LOGFILE")  or &HandlerDie($FAILED_TO_OPEN_LOG_FILE, $current_poid);


                $prod_disc_file_name = $PROD_DISC_UEL_STAGING . "/" . $PROD_DISC_FILE_PREFIX . $irel_file_name
                                        . $PROD_DISC_FILE_SUFFIX;

		if (-e $prod_disc_file_name) 
		{
			$first_usage_or_ood_file_found = 1;
                        print CVLOG "$PID : Loading First Usage Products/Discounts file for rated cdr : basename($file)\n";
                        print CVLOG "-----------------------------------------------------------------------------------\n";
			$ret_val_prod_disc = &ExecuteUELInstance($prod_disc_template, basename($prod_disc_file_name), 
						$PROD_DISC_UEL_STAGING, $PROD_DISC_UEL_PROCESSING,
						$PROD_DISC_UEL_ARCHIVE, $PROD_DISC_UEL_REJECT);
		}

                $resources_file_name = $RESOURCES_UEL_STAGING . "/" . $RESOURCES_FILE_PREFIX . $irel_file_name
                                        . $RESOURCES_FILE_SUFFIX;


		if (-e $resources_file_name)
		{
			$first_usage_or_ood_file_found = 1;
                        print CVLOG "$PID : Loading First Usage Resources file for rated cdr : basename($file)\n";
                        print CVLOG "-------------------------------------------------------------------------\n";
			$ret_val_resources = &ExecuteUELInstance($resources_template, basename($resources_file_name), 
						$RESOURCES_UEL_STAGING, $RESOURCES_UEL_PROCESSING,
						$RESOURCES_UEL_ARCHIVE, $RESOURCES_UEL_REJECT);
		}

                # process OOD files if any
                # get all the files matching the OOD file pattern
                $OOD_FILES_PATTERN = "";
                $ret_val_ood = $NO_ERROR;
                $ret_val_ood_for_each_file = $NO_ERROR;
                $ood_file = "";

                $OOD_FILES_PATTERN = $OOD_STAGING . "/" . $OOD_PREFIX . "_" . $PIPELINE_NAME . "_*_" .
                                          $irel_file_name . "_*." . $OOD_SUFFIX;
                @OOD_FILES = <${OOD_FILES_PATTERN}>;
                $first_usage_or_ood_file_found = 1 &&
                print CVLOG "$PID : Loading @OOD_FILES OOD files for rated cdr : basename($file)\n" if (@OOD_FILES);

                # More than one OOD file can be generated for a single CDR to be loaded by REL.
                foreach $ood_file(@OOD_FILES)
                {
                        $ret_val_ood_for_each_file = &ExecuteOODInstance(basename($ood_file), $OOD_STAGING, $OOD_PROCESSING,
                                                $OOD_ARCHIVE, $OOD_REJECT);
                        $ret_val_ood = $ret_val_ood_for_each_file if $ret_val_ood_for_each_file != $NO_ERROR;
                }


                # We dont want to keep the configurable validity log file if only rated CDR was loaded.
                if ($first_usage_or_ood_file_found == 0)
                {
                        &HandlerDie($COMPLETED_NO_ERROR, $current_poid);
                        unlink $CV_LOGFILE;
                }
                else {

                        # The else condition below indicates that REL succeeded but some other first usage
                        # or OOD processing failed.So we update the batch object with the $WIH_ERROR.
                        if ($ret_val_prod_disc == $NO_ERROR && $ret_val_resources == $NO_ERROR && $ret_val_ood == $NO_ERROR)
                        {
                                &HandlerDie($COMPLETED_NO_ERROR, $current_poid);
                        }
                        else {
                                $CV_LOGFILE_KEEP = $CV_LOGFILE  . "_" . time();
                                $sys_cmd_ret_value = system("mv $CV_LOGFILE  $CV_LOGFILE_KEEP");
                                if ($sys_cmd_ret_value != $NO_ERROR)
                                {
                                        print CVLOG "couldnt move $CV_LOGFILE to $CV_LOGFILE_KEEP" . "\n";
                                }
                                &HandlerDie($WITH_ERROR, $current_poid);
                        }
                }
	}

	last;

}

# Make sure a file was moved.
if ($moved_a_file != 1)
{
        &HandlerDie($FAIL_TO_MOVE_FILE, $current_poid);
}

#
# This point should not be reached...
exit;


#
#------------------------------------------------------------------
# callTheMoveToProcessing - move the file from the staging directory to
# the processing directory.
#
# Parameter: the file name in the staging directory
#
# Returns: file not found or move failed = -1, any other failure = 0, success = 1
#
sub callTheMoveToProcessing {


        local($processingFile, $processing, $log) = @_;

        if (! -e $processingFile) {
		print $log "$PID: $processingFile does not exist.\n";
                return (-1);
        }
        if (! -d $processing) {
                print $log "$PID: Processing directory $processing does "
                        . "not exist.\n";
                return (0);
        }
        $baseProcessingFile = basename($processingFile);
        $ret = system("mv $processingFile $processing/$baseProcessingFile");
        if ($ret != $NO_ERROR ) {
                print $log "$PID: Failed to move $processingFile to ".
					"$processing.\n";
                return (-1); # Could have been moved by another handler
			     # since these ops are non-atomic;
			     # this would not occur with other move subroutines
			     # since they have a known file in use.
        }

        if ($DEBUG) {
                print $log "$PID: Moved $processingFile to $processing.\n";
        }

        return (1);
}


#
#------------------------------------------------------------------
# callTheMoveToArchive - move the file from the processing directory to
# the archive directory.
#
# Parameter: the file name in the processing directory
#
# Returns: failure = 0 and success = 1
#
sub callTheMoveToArchive {
        local($archiveFile, $archive, $log) = @_;

        if (! -e $archiveFile) {
                print $log "$PID: $archiveFile does not exist.\n";
                return (0);
        }
        if (! -d $archive) {
                if (!createPath($archive, 0, 0755)) {
                        print $log "$PID: Failed to create archive directory "
                                . "$archive: $!\n";
                        return (0);
                }
        }
        $baseArchiveFile = basename($archiveFile);
        $ret = system("mv $archiveFile $archive/$baseArchiveFile");
        if ($ret != $NO_ERROR){
                print $log "$PID: Failed to move $archiveFile to $archive.\n";
                return (0);
        }
        if ($DEBUG){
                print $log "$PID: Moved $archiveFile to $archive.\n";
        }
        return (1);
}


#
#------------------------------------------------------------------
# callTheMoveToReject - move the file from the processing directory to
# the reject directory.
#
# Parameter: the file name in the processing directory
#
# Returns: failure = 0 and success = 1
#
sub callTheMoveToReject {
        local($rejectFile, $reject, $log) = @_;


        if (! -e $rejectFile) {
                print $log "$PID: $rejectFile does not exist.\n";
                return (0);
        }
        if (! -d $reject) {
                if (!createPath($reject, 0, 0755)) {
                        print $log "$PID: Failed to create reject directory "
                                . "$reject: $!\n";
                        return (0);
                }
        }
        $baseRejectFile = basename($rejectFile);
        $ret = system("mv $rejectFile $reject/$baseRejectFile");
        if ($ret != $NO_ERROR) {
                print $log "$PID: Failed to move $rejectFile to $reject.\n";
                return (0);
        }
        if ($DEBUG) {
                print $log "$PID: Moved $rejectFile to $reject.\n";
        }
        return (1);
}

#
#------------------------------------------------------------------
# callTheMoveToStaging - move the file from the processing directory to
# the staging directory.
#
# Parameter: the file name in the processing directory
#
# Returns: failure = 0 and success = 1
#
sub callTheMoveToStaging {
        local($procfile, $staging, $log) = @_;
        local($ret);
        local($baseProcFile);

        if (! -e $procfile) {
                print $log "$PID: $procfile does not exist.\n";
                return (0);
        }
        if (! -d $staging) {
                print $log "$PID: $staging does not exist.\n";
                return (0);
        }
        $baseProcFile = basename($procfile);
        $ret = system("mv $procfile $staging/$baseProcFile");

        if ($ret != $NO_ERROR) {
                print $log "$PID: Failed to move $procfile to $staging.\n";
                return (0);
        }

        if ($DEBUG) {
                print $log "$PID: Moved $procfile to $staging.\n";
        }
        return (1);
}

#
#
#------------------------------------------------------------------
# createPath - create the directory specified by the path arg, including
#              all intermediate directories.
#
# Parameters:
#       $paths   -- either a path string or ref to list of paths
#       $verbose -- optional print "mkdir $path" for each directory created
#       $mode    -- optional permissions, defaults to 0777
#
# Returns: failure = 0 and success = 1
#
sub createPath {
        my($paths, $verbose, $mode) = @_;
        local($")="/";
        $mode = 0777 unless defined($mode);
        $paths = [$paths] unless ref $paths;
        my(@created,$path);
        foreach $path (@$paths) {
                next if -d $path;
                # Logic wants Unix paths, so go with the flow.
                my $parent = File::Basename::dirname($path);
                push(@created, createPath($parent, $verbose, $mode))
                        unless (-d $parent);
                print "mkdir $path\n" if $verbose;
                mkdir($path,$mode) || return 0;
                push(@created, $path);
        }
        @created;
}

#
#------------------------------------------------------------------
# HandlerDie - update the status object and exit.
#
sub HandlerDie() {
        $T_time = pcmif::pin_perl_time();
        local($status, $POID) = @_;

        # Create the flist to update the status to the passed arg.
        $f1 = << "END"
        0 PIN_FLD_POID                               POID [0] $POID
        0 PIN_FLD_END_T                            TSTAMP [0] ($T_time)
        0 PIN_FLD_STATUS                             ENUM [0] $status
END
;

        # Convert the flist string into the input flist
        $flistp = pcmif::pin_perl_str_to_flist($f1, $db_no, $ebufp);
        if (pcmif::pcm_perl_is_err($ebufp)) {
                print LOG "$PID: Flist conversion failed:\n$f1\n";
                pcmif::pcm_perl_print_ebuf($ebufp);
                clean_exit(1);
        }

        # Call opcode to set the status.
        $out_flistp = pcmif::pcm_perl_op($pcm_ctxp,
                        "PCM_OP_WRITE_FLDS", 0, $flistp, $ebufp);

        # If there is an error, log a message and terminate.
        if (pcmif::pcm_perl_is_err($ebufp)) {
                print LOG "$PID: Failed to update handler object.\n";
                pcmif::pcm_perl_print_ebuf($ebufp);
                $out = pcmif::pin_perl_flist_to_str($out_flistp, $ebufp);
                pcmif::pin_flist_destroy($flistp);
                pcmif::pin_flist_destroy($out_flistp);
                clean_exit(1);
        }

        # These are the RelHandler exit codes.
        if ($status == $COMPLETED_NO_ERROR) {
                $exitval = 0;
        }
        elsif ($status == $WITH_ERROR) {
                $exitval = 2;
        }
        elsif ($status == $REJECTED) {
                $exitval = 3;
        }
        elsif ($status == $PILOT_ERROR) {
                $exitval = 4;
        }
        elsif ($status == $NO_FILE_TYPE) {
                $exitval = 5;
        }
        elsif (($status == $FAIL_TO_MOVE_FILE) || ($status  == $FAILED_TO_OPEN_FILE)) {
                $exitval = 6;
        }
        elsif ($status == $NO_REL_EXEC) {
                $exitval = 7;
        }

        # Destroy the input and return flists.
        pcmif::pin_flist_destroy($flistp);
        pcmif::pin_flist_destroy($out_flistp);

        # Close the connection to the CM.
        pcmif::pcm_context_close($pcm_ctxp, 0, $ebufp);
        if (pcmif::pcm_perl_is_err($ebufp)) {
                print LOG "$PID: Error while closing CM connection.\n";
                pcmif::pcm_perl_print_ebuf($ebufp);
                clean_exit($exitval);
        }

        # Terminate this handler application.
        if ($DEBUG) {
                print LOG "$PID: Handler completed operations, exiting...\n";
        }
        clean_exit($exitval);
}


#
#------------------------------------------------------------------
# UpdatePIDBatchApplication - store the batch application PID in the database.
#
sub UpdatePIDBatchApplication() {
        $T_time = pcmif::pin_perl_time();
        local($PID, $POID) = @_;

        # Create the flist to store the PID value.
        $f1 = << "END"
        0 PIN_FLD_POID                               POID [0] $POID
        0 PIN_FLD_BATCH_HANDLER_INFO            SUBSTRUCT [0]
        1   PIN_FLD_BATCH_APPLICATION_PID             INT [0] $PID
END
;

        # Convert the flist string into the input flist.
        $flistp = pcmif::pin_perl_str_to_flist($f1, $db_no, $ebufp);
        if (pcmif::pcm_perl_is_err($ebufp)) {
                print LOG "$PID: Flist conversion failed:\n$f1\n";
                pcmif::pcm_perl_print_ebuf($ebufp);
                clean_exit(1);
        }

        # Call opcode to set the PID.
        $out_flistp = pcmif::pcm_perl_op($pcm_ctxp,
                        "PCM_OP_WRITE_FLDS", 0, $flistp, $ebufp);

        # If there is an error, log a message and terminate.
        if (pcmif::pcm_perl_is_err($ebufp)) {
                print LOG "$PID: PCM_OP_WRITE_FLDS failed.\n";
                pcmif::pcm_perl_print_ebuf($ebufp);
                $out = pcmif::pin_perl_flist_to_str($out_flistp, $ebufp);
                pcmif::pin_flist_destroy($flistp);
                pcmif::pin_flist_destroy($out_flistp);
                clean_exit(1);
        }

        # Destroy the input and return flists.
        pcmif::pin_flist_destroy($flistp);
        pcmif::pin_flist_destroy($out_flistp);

        return(1);
}


#
#------------------------------------------------------------------
# Usage: Print usage message and exit.
sub usage {
        print STDERR "Usage: $0 -p <handler_poid> { -d <dead_handler_poid> }\n";
        clean_exit(-1);
}

#
#------------------------------------------------------------------
# We don't want to leave any open files laying around,
# so close them here.
#
sub clean_exit {
        local($exitcode) = @_;
        close(LOG); # doesn't matter if it was opened or not.
	close(CVLOG);
        exit($exitcode);
}

#
#------------------------------------------------------------------
# Find the oldest file.
#
sub byage {
        $age{$b}<=>$age{$a}
}

#
#------------------------------------------------------------------
# Convert the unsigned int to signed value.
#
sub convertUnsignedToSignedInt {
        local($exitcode) = @_;

        # Number of bits in Unix other than the sign bit
        $valueBitLength = 7;
        # Decimal for binary 1 followed by 7 zeroes
        $decrementValue = 256;

        $lastBit = $exitcode >> $valueBitLength;
        if ($lastBit == 1) {
                $relstatus = ($exitcode - $decrementValue);
        }
        else {
                $relstatus = $exitcode;
        }
        return ($relstatus);
}

# The subroutine below executes the REL application.
# It returns  -1 value if REL fails and 0 if REL succeeds.

sub ExecuteRELInstance()
{
	local($file) = @_;
	local($basefile);
	local($procfile);
	local($relCmd);
	local($relpid);
	local($Command);
	local($exitcode);
	local($exitcode);
	local($relstatus);


        # Check to see if the batch executable exists.
        if (! -e $pinREL) {
                print LOG "$PID: Executable for batch application does "
                        . "not exist\n";
                &HandlerDie($NO_REL_EXEC, $current_poid);
		return -1;
        }

        #
        # Start the batch application.
        #

        #
        # Use the base filename.
        $basefile = basename ($file);

        # Form full pathname of file to be passed to pin_rel.
        $procfile = $REL_PROCESSING . "/" . $basefile;

        $relCmd = basename($pinREL) . " " . $procfile;
        if (!defined($relpid = fork())) {
            print LOG "$$: Cannot start batch application: $!";
	    &HandlerDie($NO_REL_EXEC, $current_poid);
        } elsif ($relpid == 0) {
           $Command = "cd $pinRELDir; $relCmd";
           exec($Command);
           print LOG "$$: Cannot execute batch application: $!";
	   &HandlerDie($WITH_ERROR, $current_poid);
        } else {
           # Record PID of batch application in the database.
           &UpdatePIDBatchApplication($relpid, $current_poid);

           # Wait for the batch application to finish.
           waitpid($relpid, 0);

           # Get the exit code and convert to a signed number.
           $exitcode = ($? >> $UNIX_SHIFT);
           $relstatus = &convertUnsignedToSignedInt($exitcode);
        }
        #
        # Log a debugging message in the handler log file.
        if ($DEBUG) {
                print LOG "$PID: The batch application returned $relstatus.\n";
        }

        #
        # Move files based on the return status.
        #

        $localtime = localtime();
        if ($relstatus == $NO_ERROR) {
                if ($DEBUG) {
                        print LOG "$PID: File ". basename ($procfile)." "
                                . "processed successfully by the "
                                . "batch application at $localtime.\n";
                }
		&callTheMoveToArchive($procfile, $REL_ARCHIVE, *LOG);	
		# As REL has successfully completed, we will return a success status
		# so that the first usage files have a chance to be loaded.
		return 0;
        }
        else {
                #
                # Move the files, but not if the rel process is already running.
                # in this case the return code will be 1030 (PROCESS_IS_RUNNING)
                #
                if ($relstatus != $PROCESS_IS_RUNNING) {
                        print LOG "$PID: Failed to start the batch application "
                                . "at $localtime\n";
                        &callTheMoveToReject($procfile, $REL_REJECT, *LOG);
			&HandlerDie($FAIL_TO_START_REL, $current_poid);
			return -1;
                }
		return 0;
        }
}

# The sub routine below executes UEL instances to load the first usage files
# for products/discounts and resources.It returns 0 if UEL succeeds else returns -1;

sub ExecuteUELInstance()
{
	
	local($template, $basefile, $staging, $processing, $archive, $reject) = @_;
	local($ret_val); 
	local($uelCmd);
	local($uelpid);
	local($Command);
	local($exitcode);
	local($uelstatus);
	local($procfile);
	local($localtime);

	$ret_val = &callTheMoveToProcessing($staging . "/" .$basefile, $processing, *CVLOG);

	if ($ret_val == 0 || $ret_val == -1)
	{
		return -1;
	}

        $uelCmd = basename($pinUEL) . " -t "
                          . $template . " " . $basefile;

        if (!defined($uelpid = fork())) {
            print CVLOG "$$: Cannot start UEL application: $!";
	    return -1;
        } elsif ($uelpid == 0) {
            $Command = "cd $pinUELDir; $uelCmd";
            exec($Command);
            print CVLOG  "$$: Cannot execute UEL application: $!";
	    return -1;
        } else {
            # Record PID of batch application in the database.

            # Wait for the batch application to finish.
            waitpid($uelpid,0);

            # Get the exit code and convert to a signed number.
            $exitcode = ($? >> $UNIX_SHIFT);
            $uelstatus = &convertUnsignedToSignedInt($exitcode);
        }

        # Log a debugging message in the handler log file.
        print CVLOG "$PID: the UEL application to load $basefile returned $uelstatus.\n";

        #
        # Move files based on the return status.
        #

        # Form full pathname of file to be moved.
        $procfile = $processing . "/" . $basefile;

        $localtime = localtime();
        if ($uelstatus == $NO_ERROR) {
                print CVLOG "$PID: File ". basename ($procfile)." "
                                . "processed successfully by the "
                                . "UEL application at $localtime.\n";
                &callTheMoveToArchive($procfile, $archive, *CVLOG);
		return 0;
        }

        elsif ($uelstatus == $FILE_CHECK_ERROR) {
                print CVLOG "$PID: File ". basename ($procfile)." was rejected "
                        . "by the UEL application at $localtime.\n";
                &callTheMoveToReject($procfile, $reject, *CVLOG);
		
        }

        elsif ($uelstatus == $FIELD_PARSE_ERROR
                || $uelstatus == $ACCT_FORMAT_ERROR
                || $uelstatus == $LOAD_FORMAT_ERROR
                || $uelstatus == $PREV_PARSE_ERROR
                || $uelstatus == $TOO_MANY_LOAD_ERROR
                || $uelstatus == $ACCT_OPCODE_ERROR
                || $uelstatus == $LOAD_OPCODE_ERROR) {
                print CVLOG "$PID: File ". basename ($procfile)." was "
                      . "processed by the UEL application at "
                      . "$localtime with errors.\n";
                &callTheMoveToArchive($procfile, $archive, *CVLOG);
        }

        elsif ($uelstatus == $MEMORY_ERROR
                || $uelstatus == $DISK_SPACE_ERROR
                || $uelstatus == $TEMPLATE_ERROR
                || $uelstatus == $COMMAND_LINE_ARG_ERROR
                || $uelstatus == $FILE_NOT_FOUND_ERROR
                || $uelstatus == $BAD_INF_CONNECTION) {
                print CVLOG "$PID: The file ". basename ($procfile)." was "
                        . "not processed by the UEL application at "
                        . "$localtime.\n";
                &callTheMoveToStaging($procfile, $staging, *CVLOG);
        }

        else {
                print CVLOG "$PID: Failed to start the batch application "
                        . "at $localtime\n";
                print CVLOG "$PID: Unexpected uel exit code: $uelstatus.\n";
                &callTheMoveToReject($procfile, $reject, *CVLOG);
        }
return -1;
}

# The sub routine below returns the base REL file name.
# For example if the input to this sub routine is "begin_ratedcdr_end.bc",
# where begin_ and _end are prefix and suffix respectively, 
# the return value would be "ratedcdr".
sub rel_base_name()
{
	local($file) = @_;

	$_ = $file;
	/$BC_EXT/;
	$file =  $`;

	if($REL_SUFFIX)
	{
		$_ = $file;
		/$REL_SUFFIX/;
		$file =  $`;
	}

	# The if loop strips off the sequence number from the file name.
	# For example if the file name (after stripping off the .bc extension and suffix)
	# is "test_TEL_XYZ_123", where "123" is the sequence number, the file name after stripping
	# off the  sequence number will be test_TEL_XYZ.
	if ($SEQUENCE_GEN_ON)
	{
		$file = substr($`, 0, rindex($`, "_"));
	}

	if($REL_PREFIX)
	{
	$_ = $file;
	/$REL_PREFIX/;
	$file = $';
	}
return $file;
}

# The sub routine below loads OOD files using pin_load_rerate_jobs.
# It returns 0 if pin_load_rerate_jobs succeeds else returns -1;
sub ExecuteOODInstance()
{
        
        local($basefile, $staging, $processing, $archive, $reject) = @_;
        local($ret_val); 
        local($loadreratejobsCmd);
        local($loadreratejobspid);
        local($Command);
        local($exitcode);
        local($loadreratejobsstatus);
        local($procfile);
        local($localtime);

        $ret_val = &callTheMoveToProcessing($staging . "/" .$basefile, $processing, *CVLOG);

        if ($ret_val == 0 || $ret_val == -1)
        {
                return -1;
        }

        $loadreratejobsCmd = basename($pinLoadRerateJobs). "  " . $processing . "/" . $basefile ;

        if (!defined($loadreratejobspid = fork())) {
            print CVLOG "$$: Cannot start OOD application: $!";
	    return -1;
        } elsif ($loadreratejobspid == 0) {
            $Command = "cd $pinLoadRerateJobsDir;$loadreratejobsCmd";
            exec($Command);
            print CVLOG "$$: Cannot execute OOD application: $!";
	    return -1;
        } else {
            # Record PID of batch application in the database.

            # Wait for the batch application to finish.
            waitpid($loadreratejobspid, 0);

            # Get the exit code and convert to a signed number.
            $exitcode = ($? >> $UNIX_SHIFT);
            $loadreratejobsstatus = &convertUnsignedToSignedInt($exitcode);
        }

        # Log a debugging message in the handler log file.
        print CVLOG "$PID: the OOD application to load $basefile returned $loadreratejobsstatus.\n";

        #
        # Move files based on the return status.
        #

        # Form full pathname of file to be moved.
        $procfile = $processing . "/" . $basefile;

        $localtime = localtime();
        if ($loadreratejobsstatus == $NO_ERROR) {
                print CVLOG "$PID: File ". basename ($procfile)." "
                                . "processed successfully by the "
                                . "OOD application at $localtime.\n";
                &callTheMoveToArchive($procfile, $archive, *CVLOG);
                return 0;
        }
        elsif ($loadreratejobsstatus == $PROCESS_ERROR) {
                print CVLOG "$PID: File ". basename ($procfile)." was rejected "
                        . "by the OOD application at $localtime.\n";
                &callTheMoveToReject($procfile, $reject, *CVLOG);
        }
        elsif ($loadreratejobsstatus == $FIELD_PARSE_ERROR) {
                 print CVLOG "$PID: File ". basename ($procfile)." was "
                         . "processed by the OOD application at "
                         . "$localtime with errors.\n";
                &callTheMoveToReject($procfile, $reject, *CVLOG);
        }
        else {
                print CVLOG "$PID: Failed to start the OOD application "
                        . "at $localtime\n";
                print CVLOG "$PID: Unexpected OOD exit code: $loadreratejobsstatus.\n";
                &callTheMoveToReject($procfile, $reject, *CVLOG);
        }
return -1;
}
