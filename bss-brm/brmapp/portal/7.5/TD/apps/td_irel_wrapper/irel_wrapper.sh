#!/usr/bin/ksh
#############################################################################
# Name          : irel_wrapper
# Purpose       : Runs the command on a dir full of files and merge files if 
#		:  - there are any backlogs
#		:  - run a specified command on every matching file in a 
#		:    specific directory
#		:  - Check the return code for the command
#		:  - Move that file into an 'archive' directory on success
#		:  - Move that file into a 'reject' directory on failure
#		:  - Exit the script with non-zero return code if the rc
#		:    from command is non-zero
# Exit codes	:  0 - Success
#		:  1 - Usage
#		:  0 - Another instance of this script already running
#		: 67 - Move of file to archive directory failed
#		: 68 - File being processed vanished mysteriously
#		: 71 - File already exists in archive directory
#		: 72 - File already appears in reject directory
#		: 73 - Move of processed file to reject directory failed
#		: 74 - Move of CDR failed for processing failed
#		: 77 - Lockfile vanished mysteriously
#		: 78 - Could not find our regional config file
#		: 79 - Template unknown
#		: Anything else is returned from the executed command
# Parameters    : <template_name> [-debug]
# Changes
# ===========================================================================
# Date      Name          Details
# ===========================================================================
# 10/11/16 Arka Chaudhuri  - Initial Version.
#############################################################################

#############################################################################
# Name          : getServiceTemplate
# Purpose       : Executes the service template for the current region
# Parameters    : None
# Changes
# ===========================================================================
# Date      Name          Details
# ===========================================================================
#############################################################################
function getServiceTemplate
{
  if [ $DEBUG -eq 1 ] ; then
    echo "Selecting Service template"
  fi

  # Check for region
  if [[ ! -f ${APPS_DIR}/bin/irel_wrapper.cfg ]]
  then
    echo "Error: Could not find config file ."
    exit 78
  fi

  # Reload the config - Set the mode before executing to ensure it isn't re-written at a bad time
  configFile=${APPS_DIR}/bin/irel_wrapper.cfg
  chmod 444 $configFile
  . $configFile
  chmod 644 $configFile

  # Before we go any further - Is this a disabled template?
  if [ $DISABLE -eq 1 ]
  then
    echo "$TEMPLATE_NAME: Service template has been disabled - Exiting quietly."
    exit 0
  fi
}

#############################################################################
# Name          : showChanges
# Purpose       : Displays config changes after reloading the templates
# Parameters    : None
# Changes
# ===========================================================================
# Date      Name          Details
# ===========================================================================
#############################################################################
function showChanges
{
  # Has anything changed? Let them know if it has
  if [[ $FILE_MASK != $FILE_MASK_OLD ]]
  then
    echo "Config update: FILE_MASK=$FILE_MASK"
    FILE_MASK_OLD=$FILE_MASK
  fi
  if [[ $INPUT_DIR != $INPUT_DIR_OLD ]]
  then
    echo "Config update: INPUT_DIR=$INPUT_DIR"
    INPUT_DIR_OLD=$INPUT_DIR
  fi
  if [[ $ARCHIVE_DIR != $ARCHIVE_DIR_OLD ]]
  then
    echo "Config update: ARCHIVE_DIR=$ARCHIVE_DIR"
    ARCHIVE_DIR_OLD=$ARCHIVE_DIR
  fi
  if [[ $R_EJECT_DIR != $REJECT_DIR_OLD ]]
  then
    echo "Config update: REJECT_DIR=$REJECT_DIR"
    REJECT_DIR_OLD=$REJECT_DIR
  fi
  if [[ $NUM_FILES_TO_MERGE != $NUM_FILES_TO_MERGE_OLD ]]
  then
    echo "Config update: NUM_FILES_TO_MERGE=$NUM_FILES_TO_MERGE"
    NUM_FILES_TO_MERGE_OLD=$NUM_FILES_TO_MERGE
  fi
  if [[ $NUM_CDR_TO_MERGE != $NUM_CDR_TO_MERGE_OLD ]]
  then
    echo "Config update: NUM_CDR_TO_MERGE=$NUM_CDR_TO_MERGE"
    NUM_CDR_TO_MERGE_OLD=$NUM_CDR_TO_MERGE
  fi
  if [[ $PROCESS_DIR != $PROCESS_DIR_OLD ]]
  then
    echo "Config update: PROCESS_DIR=$PROCESS_DIR"
    PROCESS_DIR_OLD=$PROCESS_DIR
  fi
  if [[ $COMMANDTORUN != $COMMANDTORUN_OLD ]]
  then
    echo "Config update: COMMANDTORUN=$COMMANDTORUN"
    COMMANDTORUN_OLD=$COMMANDTORUN
  fi
  if [ -f $SEMFILE ]
  then
    # Clean up temp files
    if [ -f $LOCKFILE ] ; then
	rm $LOCKFILE
    fi
    if [ -f $TMPFILE ] ; then
	rm $TMPFILE
    fi
    if [ $DEBUG -eq 1 ] ; then
        echo "irel_wrapper stopped abnormally.."
    fi
    exit 1
  fi
}

#############################################################################
# Name          : showUsage
# Purpose       : Displays our usage syntax
# Parameters    : None
# Changes
# ===========================================================================
# Date      Name          Details
# ===========================================================================
#############################################################################
function showUsage
{
  echo "Usage: $SCRIPTNAME <template_name> [-debug]"
  echo "    <template_name> - Name of the template, to be part of the"
  echo "                      command line arguments for each batch run."
  echo "                      Current options are:"
  echo " 		      POST_TEL, POST_SMS, POST_MMS, POST_DAT,POST_VM,POST_VAP, POST_VAS,"
  echo " 		      PRE_TEL, PRE_SMS, PRE_MMS, PRE_DAT, PRE_VM, PRE_VAP, PRE_VAS"
}

#############################################################################
# Name          : processBatch
# Purpose       : Processes a batch of irel files
# Parameters    : INPUT_FILENAME, NUM_RECORDS
# Changes
# ===========================================================================
# Date      Name          Details
# ===========================================================================
#############################################################################
function processBatch
{

        ((NUM_BATCHS=NUM_BATCHS+1))

        # Process the batch
        echo "Processing Batch $NUM_BATCHS containing $NUM_FILES_MERGED file(s)"
        if [ $DEBUG -eq 1 ] ; then
                echo "Loading file: $1"
        fi

        export PROCESS_DIR
        export SQLLDR_STR
        export ARCHIVE_DIR
        export REJECT_DIR
        export SQL_LOADER_ABORT
        export NUM_RECORDS

        wait $wait_pid
        $COMMANDTORUN $1 &
        wait_pid=$!
        RC=$?
	echo "`date \"+%m/%d/%y %H:%M:%S\"`:PID generated is $wait_pid"
        # This will ensure we exit with any error-level returned higher than 0
        if ((TOTALRC == 0))
        then
                TOTALRC=$RC;
        fi


        # Reset Counter
        NUM_FILES_MERGED=0
	#15060: Reset NUM_FILES_TO_MERGE to 1 only for non-suspense files.
        echo $1|grep suspense
        if [ $? -ne "0" ]
        then
                 NUM_FILES_TO_MERGE=1
        fi

        # Reload the config (ensures we pick up any changes) & show any changes
        getServiceTemplate
        showChanges

}

Dump()
{
        if [ $DEBUG -eq 1 ] ; then
                echo $1
        fi
}

#############################################################################
# Name          : Main
# Purpose       : Main section of the script
# Parameters    : None - Not a function
# Changes
# ===========================================================================
# Date      Name          Details
# ===========================================================================
#############################################################################

# Setup global variables
wait_pid=""
TMPFILE=/tmp/$SCRIPTNAME.$$.tmp	# Location of the tempfile we will use
DEBUG=0					# Turn on debugging
TOTALRC=0				# Default exit code (do not change)
NUM_FILES_MERGED=0			# Init "current file" counter (do not change)
NUM_FILES_PROCESSED=0			# Init "processed files" counter (do not change)
NUM_BATCHS=0				# Init "batch" counter (do not change)
SCRIPTNAME=`basename $0`		# Our script name (do not change)
PID=$$					# Our process ID (do not change)
SQL_LOADER_ABORT=0                      # SQL*Loader-2026: the load was aborted because SQL Loader cannot continue.
SQLLDR_STR=reject_sqlldr_abort          # reject filename will have this string.
SORT_STR=sort_failed			# files that failed sort will have this string
SORT_LOG=$PIN_LOG_DIR/irel/_irel_sort.log # Path of sort application logfile.
MERGE_IN_PROGRESS=0			# Indicate if a merge is in progress (0=false)
MIP_NUM_FILES_MERGED=0			# Stores the current number of files merged
MIP_NUM_FILES_TO_MERGE=0		# Added in DF15565
MIP_INPUT_FILENAME=nomerge		# Stores the destination filename of the current merge

IS_SECONDARY_SCHEMA=0                   # Suspense should not be loaded on secondary schema.
if [ $BP_dm_db_no -gt 1 ] ; then
  IS_SECONDARY_SCHEMA=1
fi

# Do we have at least one paramater?  If not - Show our usage
if [ $# -lt 1 ] ; then
  showUsage
  exit 1
fi

# Get & check parameters
while [ $# -gt 0 ] ; do
  case $1 in
    "-debug") DEBUG=1;;
    "-time")  TIME=1;;
    *) TEMPLATE_NAME=$1 ;;
  esac
  shift
done

# Is our debugging on?
if [ $DEBUG -eq 1 ] ; then
  echo "DEBUG MODE ON"
fi

# Selecting Service template
getServiceTemplate

# Init vars so we can detect changes
FILE_MASK_OLD=$FILE_MASK
INPUT_DIR_OLD=$INPUT_DIR
ARCHIVE_DIR_OLD=$ARCHIVE_DIR
REJECT_DIR_OLD=$REJECT_DIR
NUM_FILES_TO_MERGE_OLD=$NUM_FILES_TO_MERGE
NUM_CDR_TO_MERGE_OLD=$NUM_CDR_TO_MERGE
PROCESS_DIR_OLD=$PROCESS_DIR
COMMANDTORUN_OLD=$COMMANDTORUN

# Setup lock filename & Check for an existing process
IREL_USER=`whoami`
LOCKFILE=/tmp/${SCRIPTNAME}_${TEMPLATE_NAME}.${IREL_USER}.lock
SEMFILE=${APPS_DIR}/apps/pin_rel/stop.sem
if [ -f $LOCKFILE ] ; then
  # A lock file exists. See if its process is still running
  OLDPID=`cat $LOCKFILE|awk '{ print $1 }'`
  if [ $DEBUG -eq 1 ] ; then
    echo "DEBUG: Lockfile detected."
  fi
  if [ ! -z "$OLDPID" ] ; then
    # There is a lock. Check if the process is running.
    if [ $DEBUG -eq 1 ] ; then
      echo "DEBUG: Previous PID=$OLDPID"
    fi
    # Now something mildly tricky. Look for the old pid & ensure it runs the current script
    if [ `ps -p $OLDPID | egrep -v "PID" | tail -1 | wc -l` -gt 0 ] ; then
      if [ $DEBUG -eq 1 ] ; then
        echo "Another incarnation of $SCRIPTNAME running. Exiting"
      fi
      exit 0 
    fi
    # Now we know the old PID isn't running, we should remove it from the lock file
    if [ $DEBUG -eq 1 ] ; then
      echo "DEBUG: Old PID not running."
    fi
    # It's possible that the lockfile is gone, so check
    if [ ! -f $LOCKFILE ] ; then
      echo "Lockfile mysteriously vanished. Exiting"
      exit 77
    fi
  fi
fi

# Check if semaphore file exists
if [ -f $SEMFILE ]
then
	echo "IREL wrapper has been disabled - Exiting quietly."
	exit 0
fi

# Now add the current process to the lock file
echo "$PID" > $LOCKFILE

cd $INPUT_DIR
# find out how many files are in the directory for processing
if [ -f $FILE_MASK ] ; then
  # added the redirect of stderr to devnull to deal with a bizarre error
  # which caused a "not found" to appear from time to time.
  ls -1rt $FILE_MASK 2>/dev/null > $TMPFILE
else
  if [ $DEBUG -eq 1 ] ; then
    echo "DEBUG: No matching files to process"
  fi
  cp /dev/null $TMPFILE 2>/dev/null
fi

# Get our file-count
NUMFILES=`cat $TMPFILE | wc -l`

# Get the number of batches and round it up
NUM_CDRS=0
NUM_FILES=0
BATCH=1
COUNTER=0
COUNT=`cat $TMPFILE | wc -l`

for CURRENT_FILE in `cat $TMPFILE`
do
   echo "CURRENT_FILE=$CURRENT_FILE"
   #15060: Update NUM_CDRS for non-suspense files, update NUM_FILES for suspense files
   echo $CURRENT_FILE|grep suspense
   if [ $? -ne "0" ]
   then
       ((NUM_CDRS = NUM_CDRS + `tail -1 $CURRENT_FILE|cut -f 7`))
       ((NUM_FILES_TO_MERGE=1))
   else
       ((NUM_FILES = NUM_FILES + 1))
       ((NUM_CDR_TO_MERGE=1))
   fi

((COUNTER = COUNTER + 1))
#15060: Add one more condition to check if NUM_FILES has exceeded the num of files to be merged
if ((NUM_CDRS >= NUM_CDR_TO_MERGE)) || ((NUM_FILES >= NUM_FILES_TO_MERGE))
then
   NUM_CDRS=0
   NUM_FILES=0
   if ((COUNTER != COUNT))
   then   
    ((BATCH = BATCH + 1))
   fi
fi

done

# Display some output for our fans
echo "$TEMPLATE_NAME: Starting to process $NUMFILES file(s) in $BATCH batch(s)"
echo "--------------------------------------------------------------"

# Run through the gathered list of files running the command
NUM_CDRS=0
NUM_FILES=0
TRAILER_STRING=""
cd $PROCESS_DIR
for CURRENT_FILE in `cat $TMPFILE`
do
   Dump "\nProcessing CURRENT_FILE=$CURRENT_FILE"
   echo $CURRENT_FILE|grep suspense
   if [ $? -ne "0" ]
   then
	#DF15565-This is adding reject file cdr count also which is incorrect. This should be fixed later.
       ((NUM_CDRS = NUM_CDRS + `tail -1 $INPUT_DIR/$CURRENT_FILE|cut -f 7`))
   else
       ((NUM_FILES = NUM_FILES + 1))
   fi

	if (( MERGE_IN_PROGRESS == 1))
	then
		Dump "MERGE_IN_PROGRESS=1, NUM_FILES_MERGED=$NUM_FILES_MERGED, NUM_FILES_TO_MERGE=$NUM_FILES_TO_MERGE"
		NUM_FILES_MERGED=$MIP_NUM_FILES_MERGED
		NUM_FILES_TO_MERGE=$MIP_NUM_FILES_TO_MERGE
		INPUT_FILENAME=$MIP_INPUT_FILENAME
	fi	
	if (( NUM_FILES_MERGED < NUM_FILES_TO_MERGE ))
	then
		Dump "NUM_FILES_MERGED=$NUM_FILES_MERGED is less than NUM_FILES_TO_MERGE=$NUM_FILES_TO_MERGE"
		if (( NUM_FILES_MERGED == 0))
		then
			Dump "NUM_FILES_MERGED == 0"
			INPUT_FILENAME=$CURRENT_FILE;
			##  TD 28065 & 4895 Make sure there is no file with this name in processing dir.
			if [ -f $PROCESS_DIR/$INPUT_FILENAME ] ; then
				rm $PROCESS_DIR/$INPUT_FILENAME 2>/dev/null
			fi
		fi

		((NUM_FILES_PROCESSED = NUM_FILES_PROCESSED + 1))
		Dump "Incremented NUM_FILES_PROCESSED to $NUM_FILES_PROCESSED"
		echo $CURRENT_FILE|grep reject
		if [ $? -ne "0" ]
		then
			Dump "Checking if $CURRENT_FILE is sort failed file"
			echo $CURRENT_FILE|grep sort_failed
                        if [ $? -ne "0" ]
                        then
				Dump "Not sort failed file. Concatenating current file $CURRENT_FILE to input file $INPUT_FILENAME"
				# Concatenate current file to input file
				`cat $INPUT_DIR/$CURRENT_FILE >> $INPUT_FILENAME`

				if [ ! -d $INPUT_DIR/merge ] ; then
					echo "Creating dir: $INPUT_DIR/merge"
					`mkdir $INPUT_DIR/merge`
				fi
   
				# Write CURRENT_FILE name to control file
				echo $INPUT_DIR/$CURRENT_FILE >> $INPUT_DIR/merge/$INPUT_FILENAME.ctl

				# Move current file to merge dir
				`mv $INPUT_DIR/$CURRENT_FILE $INPUT_DIR/merge`

				((NUM_FILES_MERGED = NUM_FILES_MERGED + 1))
				Dump "$CURRENT_FILE Moved to merge dir. NUM_FILES_MERGED=$NUM_FILES_MERGED"
			
				# Update the trailer with correct number of CDRS
				NUM_RECORDS=`grep ^020 $INPUT_FILENAME|wc -l`
	                        NUM_RECORDS="${NUM_RECORDS##+([[:space:]])}"
               			if (( NUM_FILES_MERGED > 0 ))
	                        then
       		               		TRAILER_STRING=`tail -1 $INPUT_FILENAME | awk -v WCOUNT=$NUM_RECORDS -F"\\\t" '{\$7=WCOUNT;OFS="'\\\t'";print}'`
	       		               	`perl -pi -e "s/^090.*\$/$TRAILER_STRING/g" $INPUT_FILENAME`
       	        		       	Dump "NUM_FILES_MERGED ($NUM_FILES_MERGED) > 0. Updated the trailer of $INPUT_FILENAME with correct number of CDRs which is $NUM_RECORDS"
                       		fi


				#15060: Modify the NUM_FILES_TO_MERGE only for non-suspense files
				echo $CURRENT_FILE|grep suspense
				if [ $? -ne "0" ]
				then
					((NUM_FILES_TO_MERGE = NUM_FILES_TO_MERGE + 1))
					Dump "Incremented NUM_FILES_TO_MERGE to $NUM_FILES_TO_MERGE"
				fi

				#Store data so we can recover this merge if reject or sort_error file found
				MERGE_IN_PROGRESS=1
				MIP_NUM_FILES_MERGED=$NUM_FILES_MERGED
				MIP_NUM_FILES_TO_MERGE=$NUM_FILES_TO_MERGE
				MIP_INPUT_FILENAME=$INPUT_FILENAME

				if(( NUM_CDRS >= NUM_CDR_TO_MERGE))
				then
					Dump "NUM_CDRS($NUM_CDRS) >= NUM_CDR_TO_MERGE($NUM_CDR_TO_MERGE). Setting NUM_CDRS = 0 and NUM_FILES_TO_MERGE = 0"
					(( NUM_CDRS = 0))
					((NUM_FILES_TO_MERGE = 0))
				fi
 
                               if (( NUM_FILES_PROCESSED < NUMFILES)) && (( NUM_FILES_MERGED < NUM_FILES_TO_MERGE ))
                               then 
					Dump "NUM_FILES_PROCESSED($NUM_FILES_PROCESSED) is less than NUMFILES($NUMFILES) and NUM_FILES_MERGED($NUM_FILES_MERGED) is less than NUM_FILES_TO_MERGE($NUM_FILES_TO_MERGE). Continuing with next file"
					continue;
				else
					Dump "Finished merge. NUM_FILES_PROCESSED=$NUM_FILES_PROCESSED, NUMFILES=$NUMFILES, NUM_FILES_MERGED=$NUM_FILES_MERGED, NUM_FILES_TO_MERGE=$NUM_FILES_TO_MERGE"
					Dump "INPUT_FILENAME=$INPUT_FILENAME. Setting MERGE_IN_PROGRESS=0"
					MERGE_IN_PROGRESS=0
				fi
			else
				Dump "This is a CDR outfile which failed sort. Set NUM_FILES_MERGED=1 "
				# This is a CDR outfile which failed sort.
				NUM_FILES_MERGED=1;
                                INPUT_FILENAME=`echo $CURRENT_FILE|sed "s/.$SORT_STR//g"`;
                        	`mv $INPUT_DIR/$CURRENT_FILE $INPUT_FILENAME`
			fi

			if [ $NUM_RECORDS -gt $MIN_CDRS_TO_SORT ] 
			then
				#arka#vf_irel_sort -i $INPUT_FILENAME -o $INPUT_FILENAME.sorted -l $SORT_LOG
				echo "sort -i $INPUT_FILENAME -o $INPUT_FILENAME.sorted -l $SORT_LOG"
				if [ $? -eq 0 ]
				then
					Dump "DEBUG:Sort Successful. Moved $INPUT_FILENAME.sorted to $INPUT_FILENAME"
					#`mv $INPUT_FILENAME.sorted $INPUT_FILENAME`
				else
					Dump "Sort failed, moving $INPUT_FILENAME to reject folder with filename $SORT_FAIL_FILENAME and continuing with next file"
					SORT_FAIL_FILENAME=`echo $INPUT_FILENAME|sed "s/out/$SORT_STR.out/g"`
					#`mv $INPUT_FILENAME $REJECT_DIR/$SORT_FAIL_FILENAME`
					continue;
				fi
			fi
		else
			# This is a recycled CDR outfile.
			
			Dump "This is a recycled CDR outfile."
			NUM_FILES_MERGED=1;
			echo $CURRENT_FILE|grep $SQLLDR_STR
			if [ $? -ne "0" ]
			then
				INPUT_FILENAME=`echo $CURRENT_FILE|sed "s/.reject//g"`;
			else
				INPUT_FILENAME=`echo $CURRENT_FILE|sed "s/.$SQLLDR_STR//g"`;
				#arka#$APPS_DIR/apps/pin_rel/vf_pin_rel_delete_events.pl $PROCESS_DIR/$INPUT_FILENAME
				if [ $? -ne "0" ]
				then
					`mv $INPUT_DIR/$CURRENT_FILE $REJECT_DIR`
					continue;
				fi
			fi
			`mv $INPUT_DIR/$CURRENT_FILE $INPUT_FILENAME`
			NUM_RECORDS=`grep ^020 $INPUT_FILENAME|wc -l`
			NUM_RECORDS="${NUM_RECORDS##+([[:space:]])}"
			# DF 15565- There is no need to update trailor of reject file since we fixed it above but for backlog rejects not removing this.
			TRAILER_STRING=`tail -1 $INPUT_FILENAME | awk -v WCOUNT=$NUM_RECORDS -F"\\\t" '{\$7=WCOUNT;OFS="'\\\t'";print}'`
			`perl -pi -e "s/^090.*\$/$TRAILER_STRING/g" $INPUT_FILENAME`
			Dump "Moved $INPUT_DIR/$CURRENT_FILE to $INPUT_FILENAME and updated trailer with $NUM_RECORDS"
		fi
	else
		Dump "Setting MERGE_IN_PROGRESS = 0"
		MERGE_IN_PROGRESS=0
	fi

	Dump "\nCalling first processBatch for $INPUT_FILENAME NUM_RECORDS=$NUM_RECORDS"
	processBatch $INPUT_FILENAME $NUM_RECORDS

	if (( NUM_FILES_PROCESSED == NUMFILES)) && (( MERGE_IN_PROGRESS == 1))
	then
		NUM_FILES_MERGED=$MIP_NUM_FILES_MERGED
		NUM_FILES_TO_MERGE=$MIP_NUM_FILES_TO_MERGE
		INPUT_FILENAME=$MIP_INPUT_FILENAME
		NUM_RECORDS=`grep ^020 $INPUT_FILENAME|wc -l`
		Dump "\nCalling second processBatch for $INPUT_FILENAME NUM_RECORDS=$NUM_RECORDS"
		processBatch $INPUT_FILENAME $NUM_RECORDS
	fi

done

echo "`date \"+%m/%d/%y %H:%M:%S\"`:Waiting for PID $wait_pid"
while [ 1 -eq 1 ]
do
        if [ `ps -fu \`whoami\` | grep $wait_pid | grep -v grep |grep pin_rel | wc -l` -gt 0 ]
        then
                Dump "`date \"+%m/%d/%y %H:%M:%S\"`:vf_pin_rel PID=$wait_pid is running still...sleeping..."
                sleep 5;
                continue;
        else
                echo "`date \"+%m/%d/%y %H:%M:%S\"`:vf_pin_rel PID=$wait_pid finished."
                break
        fi
done


# Remove the lockfile
if [ -f $LOCKFILE ] ; then
  rm $LOCKFILE
fi

# Clean up temp files
if [ $DEBUG -eq 1 ] ; then
  echo "DEBUG: Would have run: rm $TMPFILE"
else
  rm $TMPFILE
fi

exit $TOTALRC


