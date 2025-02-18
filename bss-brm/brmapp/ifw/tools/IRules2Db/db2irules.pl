#!/usr/bin/perl
#===============================================================================
#
# Copyright (c) 1998, 2014, Oracle and/or its affiliates. All rights reserved.
#               This material is the confidential property of
#       Oracle Corporation or its subsidiaries or licensors
#    and may be used, reproduced, stored or transmitted only in accordance
#            with a valid Oracle license or sublicense agreement.
#
#-------------------------------------------------------------------------------
# Block: TLS
#-------------------------------------------------------------------------------
# Module Description:
#   Extracts one or more Rulesets from the datase to an XML file.
#
# Open Points:
#   none
#
# Review Status:
#   <in-work>
#
#-------------------------------------------------------------------------------
# Responsible: Nathan Brizzee
#
# $RCSfile: db2irules.pl $
# $Revision: /cgbubrm_7.5.0.pipeline/2 $
# $Author: gdehshat $
# $Date: 2014/12/10 23:05:26 $
# $Locker:  $
#-------------------------------------------------------------------------------
# $Log: db2irules.pl,v $
# Revision 1.1  2002/06/17 13:16:52  cdiab
# - v6.3.2
#
# Revision 1.0  2002/05/24 17:16:52  nbrizzee
# ClearCase Activity: irules_export_import_tools_TAP3_validation_scripts
#
# Notes:
# If testing on HP, you have to load the library libjava.sl before the script
# will work correctly.
# Here is one way that works.  Set the env variable LD_PRELOAD equal to the
# full path of the library:
# setenv LD_PRELOAD /u01/app/oracle/product/817/JRE/lib/PA_RISC/native_threads/libjava.sl
#===============================================================================

# Make sure they have at least Perl 5.004_00
require 5.00400;

use File::Spec;
use DBI;
use Getopt::Std;

# ###############################################################
# These flags can be freely changed by the user
# ###############################################################
my $DEBUG = 0; # set to 1 to turn on debugging statements
my $writeXMLComments = 0; # Set to 1 to print comments in the XML file


# ###############################################################
# These variables are for the program - Please don't alter them.
# ###############################################################
my @XMLTags; # This is the storage var for the XML tags
my $IndentLevel       = 0; # This is the global indent level for the XML tags
my $deleteAfterExport = 0;
my $deleteErrOccurred = 0;
my $numberOfRules     = 0; # Number of rules exported successfully

#############################################################################
# Sub          : main
# Description  : Starting point of the program
#--------------+-------------------------------------------------------------
# In           : -d          - (optional)  DELETE - If specified, the 
#              :                           Ruleset(s) will be deleted from 
#              :                           the database after they have 
#              :                           been exported.
# In           : -u          - (optional)  UNIQUE FILENAMES - If specified, 
#              :                           the Ruleset filenames will be 
#              :                           created with unique names so they
#              :                           won't be overwritten.  This is 
#              :                           done by appending the current 
#              :                           date/time to the Ruleset Name.
# In           : dbsn        - (mandatory) The Database connection string.
# In           : username    - (mandatory) The Database username
# In           : password    - (mandatory) The Database password
# In           : filepath    - (optional)  The path to create the files in.
#              :                           If this is blank, the current
#              :                           directory is used.
# In           : RulesetName - (optional)  The RULESET in the IFW_RULESET
#              :                           table to extract.
#--------------+-------------------------------------------------------------
# Returns      : 1 if an error occurs   or 0 if successfull
#############################################################################
#=============================================
# Check and assign the command line arguments
#=============================================
$opt_d = "";
$opt_u = "";
getopts("du");
if ( ($#ARGV != 2) && ($#ARGV != 3) && ($#ARGV != 4) ) {
    print STDERR "usage: db2irules.pl [-d] [-u] <dbsn> <username> <password> [<filepath>] [<RulesetName>]\n\n";
    
    print STDERR "The -d argument will delete the RULESET or RULESETs from the database\n";
    print STDERR "after they have been exported to a file.\n\n";

    print STDERR "The -u argument will create unique XML filenames\n";
    print STDERR "in the format 'RULESET_YYYY-MM-DD_HH-MM-SS.xml.\n\n";

    print STDERR "<dbsn> is the Perl Database Source Name. It is different for each database.\n";
    print STDERR "They all start with dbi: then the name of the driver.  For example,\n";
    print STDERR "the source name for Oracle is dbi:Oracle: and the name of the connection\n";
    print STDERR "descriptor service name.  The source name for DB2 is dbi:DB2: and the\n";
    print STDERR "database name.  Please see the documentation for the different dbi modules\n";
    print STDERR "for the database specific source names.\n\n";

    print STDERR "<username> is the database username.\n\n";

    print STDERR "<password> is the database password.\n\n";

    print STDERR "<filepath> is an optional argument.  If supplied, it is the location where\n";
    print STDERR "the script should export the XML files to.  If not supplied then\n";
    print STDERR "the current directory is used.\n\n";

    print STDERR "<RulesetName> is an optional argument.  If supplied, it is the RULESET\n";
    print STDERR "to export to an XML file.  If not supplied, then all RULESETs in the\n";
    print STDERR "database will be exported.\n\n";

    print STDERR "Example: db2irules.pl dbi:Oracle:orcl scott tiger .. \n";
    print STDERR "Example: db2irules.pl -u dbi:Oracle:orcl scott tiger ./ TAP3_VAL\n";
    print STDERR "Example: db2irules.pl -d -u dbi:Oracle:orcl scott tiger\n\n";

    exit(1);
}

my $dbsn = $ARGV[0];
my $user = $ARGV[1];
my $pass = $ARGV[2];
my $filepath    = "";
my $ruleSetName = "";

if ($#ARGV == 3) {
    $filepath = $ARGV[3];
}

if ($#ARGV == 4) {
    $filepath = $ARGV[3];
    $ruleSetName = $ARGV[4];
}

if ($opt_u) {
    print "Exporting Rulesets with unique filenames.\n";
}

if ($opt_d) {
    $deleteAfterExport = 1;
    print "Delete Ruleset(s) after export enabled.\n";
}

my %attr = (
	PrintError  => 1,  # Log errors to the screen
	RaiseError  => 0,  # Don't die on errors
    AutoCommit  => 0,  # Don't auto commit deletes
    LongReadLen => 256000
);
if ($DEBUG) {
    print "dbsn=$dbsn; user=$user; pass=$pass; filepath=$filepath; ruleSetName=$ruleSetName\n";
}

#=============================================
# Login to the database
#=============================================
print ("Connecting to database $dbsn; user=$user; pass=$pass\n");
my $dbh = DBI->connect($dbsn, $user, $pass, \%attr) 
    or printErrAndExit("Can't connect to database $dbsn: ", $DBI::errstr);

#=============================================
# Prepare the SQL statement
#=============================================
my $ifw_ruleset_table = "IFW_RULESET";
my $sql_select_1 = "SELECT RULESET, NAME, DESCRIPTION "
                 . "FROM $ifw_ruleset_table";
if ($ruleSetName) {
    $sql_select_1 .= " WHERE RULESET = " . $dbh->quote($ruleSetName);
}
if ($DEBUG) {
    print "$sql_select_1\n";
}
my $sth = $dbh->prepare($sql_select_1)
    or printErrAndExit("Unable to prepare SQL statement: ", $sql_select_1, ": ",
        $dbh->errstr(), "\n");

#=============================================
# Execute the FETCH
#=============================================
$sth->execute()
    or printErrAndExit("Unable to execute FETCH: ", $sql_select_1, "\n");

#=============================================
# Fetch all the rows from IFW_RULESET table
# and write them to the XML file.
#=============================================
print ("Fetching rows from table $ifw_ruleset_table\n\n");
my $ifw_rulesets = $sth->fetchall_arrayref(); #fetch all the rows at once.
$sth->finish();
my $loopctr = 0;
my $commitloopctr = 0;

if ($ifw_rulesets) {
    foreach my $row (@$ifw_rulesets ) {
        $loopctr ++; # Keep track of how many we export
        $deleteErrOccurred = 0; #reset the error counter
        $numberOfRules     = 0; #Reset for every row

        # If the RULESET contains any spaces, replace them with '_'
        my $tmpfname = replaceSpaces($$row[0]);
        if ($opt_u) {
            #Force unique filename
            $tmpfname .= "_" . getDateTimeString();
        }
        $tmpfname .= ".xml";

        my $fname = "";
        if ($filepath) {
            $fname = File::Spec->catfile($filepath, $tmpfname);
        } else {
            $fname = File::Spec->catfile(File::Spec->curdir(), $tmpfname);
        }
            
        if ($DEBUG) {
            print "IFW_RULESET: RULESET=$$row[0]; "
            . "NAME=$$row[1]; "
            . "DESCRIPTION=" . DBI::neat($$row[2], 50) . "\n";
        }
        
        # Open the XML file and start writing the tags to it.
        print ("Opening file $fname\n");
        open (XMLFILEHANDLE, ">$fname") 
            or printErrAndExit("Can't open file: ", $fname);

        writeOpeningTag2File("RULESET_ROW", "\n");
        
        writeOpeningTag2File("RULESET_RULESET", $$row[0]);
        if (defined($$row[0])) {
            writeClosingTag2File(0);
        }
        print XMLFILEHANDLE "\n";

        writeOpeningTag2File("RULESET_NAME", $$row[1]);
        if (defined($$row[1])) {
            writeClosingTag2File(0);
        }
        print XMLFILEHANDLE "\n";

        writeOpeningTag2File("RULESET_DESCRIPTION", $$row[2]);
        if (defined($$row[2])) {
            writeClosingTag2File(0);
        }
        print XMLFILEHANDLE "\n";

        #=============================================
        # Fetch all the rows in the IFW_RULESETLIST
        # table and print them
        #=============================================
        fetchIFW_RuleSetLists(@$row);

        writeClosingTag2File(0);
        print XMLFILEHANDLE "\n";
        print ("Closing file $fname\n");
        close(XMLFILEHANDLE) or warn $! ? "Syserr closing $fname: $!.\n"
                                        : "Wait status error $? on $fname.\n";
        if ($loopctr) {
            print ("$$row[0] Ruleset containing $numberOfRules rule(s) exported successfully.\n");

            # Check if we are supposed to delete after we export.
            if ($deleteAfterExport == 1) {
                #=============================================
                # Delete rows from the database.
                #=============================================
                if ($deleteErrOccurred == 0) { # No error so far
                    if (deleteRows("IFW_RULESET", "RULESET", $$row[0]) == 0) {
                        $deleteErrOccurred = 1;
                    }
                }

                if ($deleteErrOccurred == 0) {
                    #=============================================
                    # Commit
                    #=============================================
                    print ("Committing Delete transaction.\n");
                    if ( $dbh->commit() ) {
                        print ("$$row[0] deleted from the database.\n");
                        $commitloopctr ++;
                    } else {
                        $deleteErrOccurred = 1;
                        print STDERR "Delete Commit failed: "
                            . $dbh->errstr() . "\n";
                    } 
                } else {
                    printErrAndRollback ("$$row[0] was not deleted from the database");
                }
            }
            print ("\n");
        }
    }
    if (!$loopctr) {
        print ("No rows found in table $ifw_ruleset_table\n");
    }
} else {
    printErrAndExit("An error occurred selecting rows from ", 
        $ifw_ruleset_table,": ",$dbh->errstr());
}


#=============================================
# Logoff
#=============================================
print ("Disconnecting from database $dbsn\n");
$dbh->disconnect()
    	or warn "Disconnect from database $dbsn failed: ",$dbh->errstr(), "\n";

my $exitCode = 0; # assume success for return.
if ($loopctr) {
    print ("$loopctr Ruleset(s) exported successfully.\n");

    if ($deleteAfterExport == 1) {
        print ("$commitloopctr Ruleset(s) deleted successfully.\n");
        if ($loopctr != $commitloopctr) {
            $exitCode = 1; #An error occurred deleting a Ruleset
        }
    }
}

exit($exitCode);

# ################## END OF SCRIPT MAIN ###############################


#############################################################################
# Sub          : PrintError
# Description  : Prints an error message to STDERR,
#--------------+-------------------------------------------------------------
# In           : An array of values to print to STDERR
#--------------+-------------------------------------------------------------
# Returns      : none - 
#############################################################################
sub PrintError {
    print STDERR "ERROR: ";
    for my $str (@_) {
        print STDERR $str;
    }
    print STDERR "\n";
}

#############################################################################
# Sub          : printErrAndExit
# Description  : Prints an error message to STDERR and exit's the program.
#--------------+-------------------------------------------------------------
# In           : An array of values to print to STDERR
#--------------+-------------------------------------------------------------
# Returns      : none - Exits the progam with exit code 1
#############################################################################
sub printErrAndExit {
    PrintError(@_);
    exit (1);
}

#############################################################################
# Sub          : printErrAndRollback
# Description  : Prints an error message to STDERR, and rolls back 
#              : any changes to the database
#--------------+-------------------------------------------------------------
# In           : An array of values to print to STDERR
#--------------+-------------------------------------------------------------
# Returns      : none - 
#############################################################################
sub printErrAndRollback {
    
    PrintError(@_);

    if ( defined($dbh) ) {
        print "Rolling back transaction\n";
        #=============================================
        # Rollback
        #=============================================
        $dbh->rollback()
           or warn "Transaction rollback failed: ",$dbh->errstr(), "\n";
    }
}

#############################################################################
# Sub          : replaceSpaces
# Description  : Returns a string with all the spaces remove from it 
#              :  and replaces with '_'.
#--------------+-------------------------------------------------------------
# In           : A string with or with spaces in it
#--------------+-------------------------------------------------------------
# Returns      : A new string with the spaces replaced with '_'
#############################################################################
sub replaceSpaces {
    my $retstr = "";

    for my $str (@_) {
        $retstr .= $str;
    }
    if ($retstr) {
        $retstr =~ s/ /_/g; # Replace all ' ' with '_';
    }
    return $retstr;
}

#############################################################################
# Sub          : replaceSpecialChars
# Description  : Returns a string with all the special reserved chars 
#              : replaced with their corresponding HTML equivalents
#              : or vise versa depending on the flag passed to the function.
#              : See: http://www.w3.org/TR/REC-xml#sec-well-formed
#--------------+-------------------------------------------------------------
# In           : A string with special characters in it
# In           : Which way to replace symbols. 
#              :    1 = replace '<','>', '&;' with '&lt;','&gt;','&amp;'
#              :    0 = replace '&lt;','&gt;' with '<','>','&'
#--------------+-------------------------------------------------------------
# Returns      : A new string with the symbols replaced (if any found).
#############################################################################
sub replaceSpecialChars {
    my $retstr = shift;
    my $flag   = shift;

    if ($retstr) {
        if ($flag == 1) {
            $retstr =~ s/&/&amp;/g; # replace '&' with '&amp;' # Do this first.
            $retstr =~ s/</&lt;/g; # replace '<' with '&lt;' # Then these or 
            $retstr =~ s/>/&gt;/g; # replace '>' with '&gt;' # the & will be replaced
        } else {
            $retstr =~ s/&lt;/</g; # replace '&lt;' with '<'
            $retstr =~ s/&gt;/>/g; # replace '&gt;' with '>'
            $retstr =~ s/&amp;/&/g; # replace &amp;' with '&'
        }
    }

    return $retstr;
}

#############################################################################
# Sub          : getIndentSpace
# Description  : Gets the appropriate amount of spaces to indent an XML tag.
#              :  using the global Indent variable.
#--------------+-------------------------------------------------------------
# Returns      : Appropriate amount of indent spaces
#############################################################################
sub getIndentSpace {
    my $spaces ="";

    for (my $count = 0; $count < $IndentLevel; $count ++) {
        $spaces .= "   ";
    }
    
    return $spaces;
}

#############################################################################
# Sub          : writeOpeningTag2File
# Description  : Writes an XML start tag to the open file.
#--------------+-------------------------------------------------------------
# In           : A string to write as an Open XML tag in the form <tag>
# In           : The text to write inside the tag.  If this text is empty ""
#              : then the tag is written as one open/close tag.
#              : example <XML_TAG/>
#--------------+-------------------------------------------------------------
# Returns      : nothing
#############################################################################
sub writeOpeningTag2File {
    my $tag = shift;
    my $txt = shift;

    if ($tag) {
        if (XMLFILEHANDLE) {
            if (defined($txt)) {
                $txt = replaceSpecialChars($txt, 1); # replace any special chars
                print XMLFILEHANDLE getIndentSpace() . "<$tag>";
                print XMLFILEHANDLE $txt;
                push @XMLTags, $tag;
                $IndentLevel ++; #increment by one every time we return
            } else {
                # Print the Open/close tag and be done
                print XMLFILEHANDLE getIndentSpace() . "<$tag/>";
            } 
        } else {
            printErrAndExit("Invalid File handle in writeOpeningTag2File()");
        }
    }
}

#############################################################################
# Sub          : writeClosingTag2File
# Description  : Closes the last XML tag that was opened and writes it
#              : to the open file.
#--------------+-------------------------------------------------------------
# In           : 1 = Auto indent tag, 0 or nothing = do not auto indent tag
#--------------+-------------------------------------------------------------
# Returns      : nothing
#############################################################################
sub writeClosingTag2File {
    my $autoIndent = shift;
    my $tag = pop @XMLTags;

    if ($tag) {
        $IndentLevel --; #Decrement by one every time we close a tag
        if ($autoIndent) {
            if ($autoIndent == 1) {
                print XMLFILEHANDLE getIndentSpace();
            }
        }
        print XMLFILEHANDLE "</$tag>";
    }
}

#############################################################################
# Sub          : writeXMLComment2File
# Description  : Writes an XML comment to the open file.
#--------------+-------------------------------------------------------------
# In           : A string to write as an XML comment
#--------------+-------------------------------------------------------------
# Returns      : nothing
#############################################################################
sub writeXMLComment2File {
    my $comment = shift;

    if ($comment) {
        $comment = replaceSpecialChars($comment, 1);
        print XMLFILEHANDLE getIndentSpace() . "<!-- $comment -->\n";
    }
}

#############################################################################
# Sub          : fetchIFW_RuleSetLists
# Description  : Fetches rows from the IFW_RULESETLIST table that match
#              : the RULESET that's passed in and writes them to an XML file.
#--------------+-------------------------------------------------------------
# In           : RULESET to select rows for
#--------------+-------------------------------------------------------------
# Returns      : nothing
#############################################################################
sub fetchIFW_RuleSetLists {
    my $ruleset = shift;

    if ($ruleset) {
        #=============================================
        # Prepare the SQL statement
        #=============================================
        my $ifw_rulesetlist_table = "IFW_RULESETLIST";
        my $sql_select = "SELECT RULESET, RANK, RULE_ID "
                       . "FROM $ifw_rulesetlist_table "
                       . "WHERE RULESET = " . $dbh->quote($ruleset) 
                       . " ORDER BY RANK";
        
        if ($DEBUG) {
            print "   $sql_select\n";
        }
        my $sth = $dbh->prepare($sql_select)
            or printErrAndExit("Unable to prepare SQL statement: ",
                $sql_select, ": ", $dbh->errstr(), "\n");

        #=============================================
        # Execute the FETCH
        #=============================================
        $sth->execute()
            or printErrAndExit("Unable to execute FETCH: ", $sql_select, "\n");


        #=============================================
        # Fetch all the rows from IFW_RULESETLIST table
        # and write them to the XML file.
        #=============================================
        print ("Exporting all rows from table $ifw_rulesetlist_table\n");
        my $ifw_rulesetslists = $sth->fetchall_arrayref(); #fetch all the rows at once.
        $sth->finish();
        if ($ifw_rulesetslists) {
            foreach my $row ( @$ifw_rulesetslists ) {
                if ($DEBUG) {
                    print "   IFW_RULESETLIST: RULESET=$$row[0]; " 
                        . "RANK=$$row[1]\n";
                }

                writeOpeningTag2File("RULE_ROW", "\n");
                # Only write the XML comment if the flag is true
                if ($writeXMLComments == 1) {
                    writeXMLComment2File("The RANK for this row=$$row[1]");
                }

                writeOpeningTag2File("RULE_RULE", $$row[0]);
                if (defined($$row[0])) {
                    writeClosingTag2File(0);
                }
                print XMLFILEHANDLE "\n";

                #=============================================
                # Fetch all the rows in the IFW_RULE
                # table and print them
                #=============================================
                fetchIFW_Rules(@$row);

                #=============================================
                # Fetch all the rows in the IFW_RULEITEM
                # table and print them
                #=============================================
                fetchIFW_RuleItems(@$row);

                #=============================================
                # Must first delete from IFW_RULEITEM 
                # before we can delete from IFW_RULESETLIST
                #=============================================
                if ($deleteAfterExport == 1) {
                    #=============================================
                    # Delete rows from the database.
                    #=============================================
                    if ($deleteErrOccurred == 0) { #No error so far
                        if (deleteRows("IFW_RULESETLIST", "RULESET", $ruleset) == 0) {
                            $deleteErrOccurred = 1;
                        }
                    }
                }

                #=============================================
                # Must first delete from IFW_RULESETLIST 
                # before we can delete from IFW_RULE
                #=============================================
                if ($deleteAfterExport == 1) {
                    #=============================================
                    # Delete rows from the database.
                    #=============================================
                    if ($deleteErrOccurred == 0) { #No error so far
                        if (deleteRows("IFW_RULE", "RULE_ID", $$row[2]) == 0) {
                            $deleteErrOccurred = 1;
                        }
                    }
                }

                writeClosingTag2File(1); #auto indent this closing tag
                print XMLFILEHANDLE "\n";
            }
        } else {
            printErrAndExit("No rows found in table ", $ifw_ruleset_table);
        }
    } else {
        printErrAndExit("An empty string was passed to fetchIFW_RuleSetLists()\n");
    }
}

#############################################################################
# Sub          : fetchIFW_Rules
# Description  : Fetches rows from the IFW_RULE table that match
#              : the RULE that's passed in and writes them to an XML file.
#--------------+-------------------------------------------------------------
# In           : RULE to select rows for
#--------------+-------------------------------------------------------------
# Returns      : nothing
#############################################################################
sub fetchIFW_Rules {
    my $rule = shift;
    my $rank = shift;
    my $rule_id = shift;

    if ($rule) {
        #=============================================
        # Prepare the SQL statement
        #=============================================
        my $ifw_rule_table = "IFW_RULE";
        my $sql_select = "SELECT RULE_ID, NAME, INIT_SCRIPT "
            . "FROM $ifw_rule_table "
            . "WHERE RULE_ID = " . $dbh->quote($rule_id);
            
        if ($DEBUG) {
            print "   $sql_select\n";
        }
        my $sth = $dbh->prepare($sql_select)
            or printErrAndExit("Unable to prepare SQL statement: ",
                $sql_select, ": ", $dbh->errstr(), "\n");

        #=============================================
        # Execute the FETCH
        #=============================================
        $sth->execute()
            or printErrAndExit("Unable to execute FETCH: ", $sql_select, "\n");

        #=============================================
        # Fetch all the rows from IFW_RULE table
        # and write them to the XML file.
        #=============================================
        # print ("Exporting all rows from table $ifw_rule_table\n");
        my $ifw_rules = $sth->fetchall_arrayref(); #fetch all the rows at once.
        $sth->finish();
        if ($ifw_rules) {
            foreach my $row ( @$ifw_rules ) {
                if ($DEBUG) {
                    print "   IFW_RULE: RULE_ID=$$row[0]; " 
                        . "NAME=$$row[1]; "
                        . "INIT_SCRIPT=" . DBI::neat($$row[2], 50) . "\n";
                }

                writeOpeningTag2File("RULE_NAME", $$row[1]);
                if (defined($$row[1])) {
                    writeClosingTag2File(0);
                }
                print XMLFILEHANDLE "\n";
                $numberOfRules ++; # Keep track of how many rules we export

                writeOpeningTag2File("RULE_INIT_SCRIPT", $$row[2]);
                if (defined($$row[2])) {
                    writeClosingTag2File(0);
                }
                print XMLFILEHANDLE "\n";
            }
        } else {
            printErrAndExit("No rows found in table ", $ifw_rule_table);
        }
    } else {
        printErrAndExit("An empty string was passed to fetchIFW_Rules()\n");
    }
}

#############################################################################
# Sub          : fetchIFW_RuleItems
# Description  : Fetches rows from the IFW_RULEITEM table that match
#              : the RULE that's passed in and writes them to an XML file.
#--------------+-------------------------------------------------------------
# In           : RULE to select rows for
#--------------+-------------------------------------------------------------
# Returns      : nothing
#############################################################################
sub fetchIFW_RuleItems {
    my $ruleItem = shift;
    my $rank = shift;
    my $rule_id = shift;

    if ($ruleItem) {
        #=============================================
        # Prepare the SQL statement
        #=============================================
        my $ifw_ruleitem_table = "IFW_RULEITEM";
        my $sql_select = "SELECT RULE_ID, NAME, CONDITION, RESULT, RANK "
            . "FROM $ifw_ruleitem_table "
            . "WHERE RULE_ID = " . $dbh->quote($rule_id)
            . " ORDER BY RANK";

        if ($DEBUG) {
            print "      $sql_select\n";
        }
        my $sth = $dbh->prepare($sql_select)
            or printErrAndExit("Unable to prepare SQL statement: ",
                $sql_select, ": ", $dbh->errstr(), "\n");

        #=============================================
        # Execute the FETCH
        #=============================================
        $sth->execute()
            or printErrAndExit("Unable to execute FETCH: ", $sql_select, "\n");

        #=============================================
        # Fetch all the rows from IFW_RULEITEM table
        # and write them to the XML file.
        #=============================================
        # print ("Exporting all rows from table $ifw_ruleitem_table\n");
        my $ifw_ruleitems = $sth->fetchall_arrayref(); #fetch all the rows at once.
        $sth->finish();
        if ($ifw_ruleitems) {
            foreach my $row ( @$ifw_ruleitems ) {
                if ($DEBUG) {
                    print "      IFW_RULEITEM: RULE_ID=$$row[0]; " 
                        . "NAME=$$row[1]; "
                        . "CONDITION=" . DBI::neat($$row[2], 25) .";"
                        . "RESULT=" . DBI::neat($$row[3], 25) .";"
                        . "RANK=$$row[4]\n";
                }

                writeOpeningTag2File("RULEITEM_ROW", "\n");

                # Only write the XML comment if the flag is true
                if ($writeXMLComments == 1) {
                    writeXMLComment2File("The RANK for this row=$$row[4]");
                }

                writeOpeningTag2File("RULEITEM_NAME", $$row[1]);
                if (defined($$row[1])) {
                    writeClosingTag2File(0);
                }
                print XMLFILEHANDLE "\n";

                writeOpeningTag2File("RULEITEM_CONDITION", $$row[2]);
                if (defined($$row[2])) {
                    writeClosingTag2File(0);
                }
                print XMLFILEHANDLE "\n";

                writeOpeningTag2File("RULEITEM_RESULT", $$row[3]);
                if (defined($$row[3])) {
                    writeClosingTag2File(0);
                }
                print XMLFILEHANDLE "\n";

                writeClosingTag2File(1); # auto indent the closing tag
                print XMLFILEHANDLE "\n";
            }

            if ($deleteAfterExport == 1) {
                #=============================================
                # Delete rows from the database.
                #=============================================
                if ($deleteErrOccurred == 0) { #No error so far
                    if (deleteRows("IFW_RULEITEM", "RULE_ID", $rule_id) == 0) {
                        $deleteErrOccurred = 1;
                    }
                }
            }
        } else {
            printErrAndExit("No rows found in table ", $ifw_ruleitem_table);
        }
    } else {
        printErrAndExit("An empty string was passed to fetchIFW_RuleItems()\n");
    }
}

#############################################################################
# Sub          : getDateTimeString
# Description  : Returns a string representing the current date and time
#              : in localtime format.  The date will be in ISO-8601
#              : format (YYYY-MM-DD) and the time will be in the format
#              : (HH-MM-SS).
#              : See-> http://perl.about.com/library/weekly/aa051601b.htm
#              : See ->http://www.cs.tut.fi/~jkorpela/iso8601.html
#--------------+-------------------------------------------------------------
# Returns      : A date string in the format YYYY-MM-DD_HH-MM-SS
#############################################################################
sub getDateTimeString {
    my $retstr = "";

    # Get the all the values for current time
    (my $Second,  my $Minute,    my $Hour, my $Day, my $Month, my $Year, 
     my $WeekDay, my $DayOfYear, my $IsDST) = localtime(time);
    
    $retstr = sprintf "%04d-%02d-%02d_%02d-%02d-%02d",
        1900+$Year, $Month+1, $Day, $Hour, $Minute, $Second;

    return $retstr;
}

#############################################################################
# Sub          : deleteRows
# Description  : Generic delete command
#--------------+-------------------------------------------------------------
# In           : Table Name
# In           : Column Name
# In           : Column Value
#--------------+-------------------------------------------------------------
# Returns      : 1 if successful, or 0 if an error occurred.
#############################################################################
sub deleteRows {
    my $tableName    = shift;
    my $columnName   = shift;
    my $columnValue  = shift;

    my $rowsAffected = 0;
    my $retval       = 1;

    #=============================================
    # Prepare the SQL statement
    #=============================================
    if ($tableName && $columnName && $columnValue) {
	my $oprt = "%";
	$columnValue = $columnValue . $oprt;
        my $sql_delete = "DELETE FROM $tableName "
                       . "WHERE $columnName LIKE "
                       . $dbh->quote($columnValue);


        if ($DEBUG) {
            print "\n$sql_delete\n";
        }
        my $sth;
        $sth = $dbh->prepare($sql_delete);
        unless ($sth) {
            PrintError("Unable to prepare SQL statement:\n",
                $sql_delete, ":\n",  $dbh->errstr());
            $retval = 0;
        }

        #=============================================
        # Execute the DELETE
        #=============================================
        if ($DEBUG) {
            print ("Deleting row(s) from $tableName.\n");
        }
        unless ($sth->execute()) {
            PrintError("Unable to execute DELETE:\n",
                $sql_delete, ":\n", $dbh->errstr());
            $retval = 0;
        }

        if ($DEBUG) {
            $rowsAffected = $sth->rows;
            print "$rowsAffected rows deleted from $tableName\n";
        }
    }
    return $retval;
}
