#!/usr/bin/perl
#===============================================================================
#
# Copyright (c) 1998, 2009, Oracle and/or its affiliates. All rights reserved. 
#      This material is the confidential property of Oracle Corporation. or its
#      subsidiaries or licensors and may be used, reproduced, stored or transmitted
#      only in accordance with a valid Oracle license or sublicense agreement.
#
#
#-------------------------------------------------------------------------------
# Block: TLS
#-------------------------------------------------------------------------------
# Module Description:
#   Imports one Ruleset to the datase from an XML file.
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
# $RCSfile: irules2db.pl $
# $Revision: /cgbubrm_7.3.2.pipeline/1 $
# $Author: smujumda $
# $Date: 2009/06/10 02:07:00 $
# $Locker:  $
#-------------------------------------------------------------------------------
# $Log: irules2db.pl,v $
# Log  2002/08/22   cdiab
# - modified sub CharHandler so that the passing of the $temp reference is done
#   in a way that is also accepted by older versions of PERL (ie 5.004)
#
# Revision 1.1  2002/06/17 13:16:52  cdiab
# - v6.3.2
#
# Revision 1.0  2002/05/24 17:16:52  nbrizzee
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

require "PerlParser.pm";
use File::Spec;
use DBI;
use DBI qw(:sql_types);
use Getopt::Std;

# ###############################################################
# These flags can be freely changed by the user
# ###############################################################
my $DEBUG = 0; # set to 1 to turn on debugging statements


# ###############################################################
# These variables are for the program - Please don't alter them.
# ###############################################################
my $parentTag     = "";
my $currentTag    = "";
my $currentEndTag = "";
my $forceInsert   = 0;
my $numberOfRules = 0; # Number of rules exported successfully

# ###############################################################
# IFW_RULESET values
# ###############################################################
my $ruleset_ruleset     = "";
my $ruleset_name        = "";
my $ruleset_description = "";

# ###############################################################
# IFW_RULESETLIST values
# ###############################################################
my $rulesetlist_ruleset = "";
my $rulesetlist_rank    = 1;
my $rulesetlist_rule    = "";
my $rulesetlist_name    = "";

# ###############################################################
# IFW_RULE values
# ###############################################################
my $rule_rule        = "";
my $rule_name        = "";
my $rule_init_script = "";

# ###############################################################
# IFW_RULEITEM values
# ###############################################################
my $ruleitem_rule      = "";
my $ruleitem_rank      = 1;
my $ruleitem_name      = "";
my $ruleitem_condition = "";
my $ruleitem_result    = "";

#############################################################################
# Sub          : main
# Description  : Starting point of the program
#--------------+-------------------------------------------------------------
# In           : -f          - (optional)  If specified, the Ruleset will be 
#              :                           forced into the database by
#              :                           first deleting any matching rows
#              :                           and then importing the new ones.
# In           : dbsn        - (mandatory) The Database connection string.
# In           : username    - (mandatory) The Database username
# In           : password    - (mandatory) The Database password
# In           : filename    - (mandatory) The (optional)path and (mandatory)
#              :                           filename of the XML file to import.
# In           : filepath    - (optional)  The path to create the backup
#              :                           XML files in.  This is only used
#              :                           with the -f option and is passed
#              :                           to the db2irules.pl script.
#--------------+-------------------------------------------------------------
# Returns      : 1 if an error occurs   or 0 if successfull
#############################################################################
#=============================================
# Check and assign the command line arguments
#=============================================
$opt_f = "";
getopts("f");
if ( ($#ARGV != 3) && ($#ARGV != 4) ) {
    print STDERR "usage: irules2db.pl [-f] <dbsn> <username> <password> <filename> [<filepath>]\n\n";

    print STDERR "The -f option will force the RULESET into the database by first exporting\n";
    print STDERR "the RULESET specified in the XML file to an unique filename, then it will\n";
    print STDERR "delete the RULESET from the database, then insert the new RULESET from the\n";
    print STDERR "XML file.\n\n";

    print STDERR "<dbsn> is the Perl Database Source Name. It is different for each database.\n";
    print STDERR "They all start with dbi: then the name of the driver.  For example,\n";
    print STDERR "the source name for Oracle is dbi:Oracle: and the name of the connection\n";
    print STDERR "descriptor service name.  The source name for DB2 is dbi:DB2: and the\n";
    print STDERR "database name.  Please see the documentation for the different dbi modules\n";
    print STDERR "for the database specific source names.\n\n";

    print STDERR "<username> is the database username.\n\n";

    print STDERR "<password> is the database password.\n\n";

    print STDERR "<filename> is the filename of the XML file to import.\n";
    print STDERR "Full path names are supported.\n\n";

    print STDERR "<filepath> is an optional argument.  If supplied, it is the location where\n";
    print STDERR "the script should export the XML files to.  If not supplied then the current\n";
    print STDERR "directory is used.  This argument only applies to the force option.\n\n";

    print STDERR "Example: irules2db.pl dbi:Oracle:pindbservice scott tiger TAP3_VAL.xml\n";
    print STDERR "Example: irules2db.pl -f dbi:Oracle:pindbservice scott tiger ./TAP3_VAL.xml /usr/home/xmlfiles\n\n";
    
    exit(1);
}

my $dbsn     = $ARGV[0];
my $user     = $ARGV[1];
my $pass     = $ARGV[2];
my $filename = $ARGV[3];
my $filepath    = "";
if ($#ARGV == 4) {
    $filepath = $ARGV[4];
}

my %attr = (
	PrintError  => 1,  # Log errors to the screen
	RaiseError  => 0,  # Don't die on errors
    AutoCommit  => 0,  # Don't auto commit inserts
    LongReadLen => 256000
);

if ($opt_f) {
    print "Delete existing Ruleset before importing enabled.\n\n";
    $forceInsert = 1;
}

if ($DEBUG) {
    print "dbsn=$dbsn; user=$user; pass=$pass; filename=$filename;  filepath=$filepath\n";
}

#=============================================
# Login to the database
#=============================================
print ("Connecting to database $dbsn; user=$user; pass=$pass\n");
my $dbh = DBI->connect($dbsn, $user, $pass, \%attr) 
    or printErrAndExit("Can't connect to database $dbsn: ", $DBI::errstr);

#=============================================
# Create the XML parser object
#=============================================
my $Parser = XML::PerlParser->new;

#=============================================
# Set all the callback handlers we are
# interested in being notified of.
#=============================================
eval {
    $Parser->setHandlers( Start => \&StartHandler
                         ,End   => \&EndHandler
                         ,Char  => \&CharHandler
                        );
};
if ($@) {
    printErrAndExit("Unable to set XML handler subroutines:\n", $@, "\n");
}

if ($DEBUG) {
    print "Starting xml parser...\n\n";
}

#=============================================
# Parse directly from file.
#
# Note:  This is an event driven XML parser.
# As pieces of the XML document are discovered,
# different events will be fired.  It is our
# job to be listening for the events we want
# to be notified of and then act accordingly.
#=============================================
eval {
    $Parser->parse_xml_file($filename);
};
if ($@) {
    printErrAndExit("Unable to Parse XML file:\n", $@, "\n");
}

if ($DEBUG) {
    print "Ending xml parser...\n\n";
}

# Assume success
my $retval = 1;

if ($numberOfRules > 0) {
    #=============================================
    # Commit
    #=============================================
    print ("\nCommitting transaction\n");
    unless ( $dbh->commit() ) {
        $retval = 0; # if commit fails, we didn't import successfully.
        print STDERR "Commit to database failed: " . $dbh->errstr() . "\n";
    }
} else {
    print STDERR "\nNo Rows imported. Possible invalid data in XML file.\n";
    doRollback();
    $retval = 0;
}

#=============================================
# Logoff
#=============================================
print ("Disconnecting from database $dbsn\n");
unless ( $dbh->disconnect() ) {
    print STDERR "Disconnect from database $dbsn failed: " . $dbh->errstr() . "\n";
}

if ($retval) {
    print ("Ruleset $ruleset_ruleset containing $numberOfRules rule(s) imported successfully.\n");
} else {
    print ("Ruleset import failed.\n");
}
exit($retval);

# ################## END OF SCRIPT MAIN ###############################


#############################################################################
# Sub          : printErrAndExit
# Description  : Prints an error message to STDERR and exit's the program.
#--------------+-------------------------------------------------------------
# In           : An array of values to print to STDERR
#--------------+-------------------------------------------------------------
# Returns      : none - Exits the progam with exit code 1
#############################################################################
sub printErrAndExit {
    print STDERR "ERROR: ";
    for my $str (@_) {
        print STDERR $str;
    }
    print STDERR "\n";
    
    doRollback();
    exit (1);
}

#############################################################################
# Sub          : doRollback
# Description  : Rolls back a transaction
#--------------+-------------------------------------------------------------
# Returns      : none - 
#############################################################################
sub doRollback {
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
# Sub          : isWhiteSpace
# Description  : Checks a string for whitespace (' ','\n','\r','\t')
#--------------+-------------------------------------------------------------
# In           : Pointer to a string to check
#--------------+-------------------------------------------------------------
# Returns      : 1 if the string is all whitespace, or 0 if it's char data
#############################################################################
sub isWhiteSpace {
    my $buf     = shift; # This get's a pointer to the string
    my $owntext = $$buf; # This is not a local copy of the string
 
    $owntext =~ s/([\ \n\r\t]*)//g; # replace all white space with nothing
     if ($owntext) {
        return 0;
    }

    if (defined($owntext)) {
        if ($owntext eq "0") {
            return 0;
        }
    }

    return 1;
}

#############################################################################
# Sub          : StartHandler
# Description  : Handler for XML Start Tags.  Called when an XML start tag
#              :  is found.
#--------------+-------------------------------------------------------------
# In           : XML tag name
# In           : An array of attributes, if any, for this Start tag.
#--------------+-------------------------------------------------------------
# Returns      : None
#############################################################################
sub StartHandler {
    my $tag = shift;
    my @atts = @_;

    # Keep track of where we are in the tags.
    $parentTag = $currentTag;
    $currentTag = $tag;

    if ($DEBUG) {
       print ("Start Tag->$tag\n");
    }
}

#############################################################################
# Sub          : EndHandler
# Description  : Handler for XML End Tags.  Called when an XML end tag
#              :  is found.
#--------------+-------------------------------------------------------------
# In           : XML tag name
#--------------+-------------------------------------------------------------
# Returns      : None
#############################################################################
sub EndHandler {
    my $tag = shift;

    $currentEndTag = $tag;
    if ($DEBUG) {
       print ("End Tag->$tag\n");
    }
    
    if ($forceInsert == 1) {
        if ($currentEndTag eq "RULESET_RULESET") {
            if ($ruleset_ruleset) {
                my $fname = "";
                if ($filepath) {
                    $fname = $filepath;
                } else {
                    $fname = File::Spec->curdir();
                }

                print "\nCalling export script to save and delete existing Ruleset\n";
                my @comp=('perl','-w','db2irules.pl','-d','-u',"$dbsn","$user",
                    "$pass","$fname","$ruleset_ruleset");
                if (system (@comp)!=0) {
                    printErrAndExit("Unable to delete existing Ruleset from the database\n");
                } else {
                    print "\nSuccessfully saved and deleted existing Ruleset\n\n";
                }
            } else {
                printErrAndExit("Unable to delete existing Ruleset from the database ",
                                "because <RULESET_RULESET> is empty\n");
            }
        }
    }

    if ($currentEndTag eq "RULESET_DESCRIPTION") {
        #=============================================
        # Prepare the SQL statement
        #=============================================
        my $ifw_table = "IFW_RULESET";
        if ($ruleset_ruleset) {
            my $sql_insert = "INSERT INTO $ifw_table "
                           . "(RULESET, NAME, DESCRIPTION) "
                           . "VALUES "
                           . "(" 
                           . $dbh->quote($ruleset_ruleset) . ", "
                           . $dbh->quote($ruleset_name) . ", "
                           . $dbh->quote($ruleset_description)
                           . ")";


            if ($DEBUG) {
                print "$sql_insert\n";
            }
            my $sth = $dbh->prepare($sql_insert)
                or printErrAndExit("Unable to prepare SQL statement: ", $sql_insert, ": ",
                    $dbh->errstr(), "\n");

            #=============================================
            # Execute the INSERT
            #=============================================
            if ($DEBUG) {
                print ("Inserting row into $ifw_table.\n");
            }
            print ("Inserting Ruleset $ruleset_ruleset into the database\n");

            $sth->execute()
                or printErrAndExit("Unable to Insert <RULESET_ROW>:\n", $sql_insert, ":\n",
                    $dbh->errstr(), "\n");
        } else {
            printErrAndExit("Unable to Insert <RULESET_ROW> into $ifw_table.  RULESET is Empty.",
                "\n");
        }
    }

    if ($currentEndTag eq "RULE_INIT_SCRIPT") {
        #=============================================
        # Prepare the SQL statement
        #=============================================
        my $ifw_table = "IFW_RULE";
        if ($rule_rule) {
            my $sql_insert = "INSERT INTO $ifw_table "
                           . "(RULE_ID, NAME, INIT_SCRIPT) "
                           . "VALUES "
                           . "(" 
                           . $dbh->quote($rule_rule) . ", "
                           . $dbh->quote($rule_name) . ", "
                           . "? "
                           . ")";

            if ($DEBUG) {
                print "$sql_insert\n";
            }
            my $sth = $dbh->prepare($sql_insert)
                or printErrAndExit("Unable to prepare SQL statement: ", $sql_insert, ": ",
                    $dbh->errstr(), "\n");

            $sth->bind_param(1, $rule_init_script, SQL_LONGVARCHAR)
                or printErrAndExit("Unable to bind INIT_SCRIPT value to SQL statement: ", $sql_insert, "\n");

            $numberOfRules ++; # Increment the number of Rules imported

            #=============================================
            # Execute the INSERT
            #=============================================
            if ($DEBUG) {
                print ("Inserting row into $ifw_table.\n");
            }
            print (".");  # Print a visual clue that we are doing something.
            $sth->execute()
                or printErrAndExit("Unable to Insert <RULE_ROW>:\n", $sql_insert, ":\n",
                    $dbh->errstr(), "\n");
        } else {
            printErrAndExit("Unable to Insert <RULE_ROW> into $ifw_table.  RULE is Empty.",
                "\n");
        }

        #=============================================
        # Prepare the SQL statement
        #=============================================
        $ifw_table = "IFW_RULESETLIST";
        if ($rulesetlist_ruleset) {
            my $sql_insert = "INSERT INTO $ifw_table "
                           . "(RULESET, RANK, RULE_ID, NAME) "
                           . "VALUES "
                           . "(" 
                           . $dbh->quote($rulesetlist_ruleset) . ", "
                           . "$rulesetlist_rank, "
                           . $dbh->quote($rulesetlist_rule) . ", "
                           . $dbh->quote($rulesetlist_name)
                           . ")";

            $rulesetlist_rank ++; # Increment the Rank by one for the next insert.

            if ($DEBUG) {
                print "$sql_insert\n";
            }
            my $sth = $dbh->prepare($sql_insert)
                or printErrAndExit("Unable to prepare SQL statement: ", $sql_insert, ": ",
                    $dbh->errstr(), "\n");

            #=============================================
            # Execute the INSERT
            #=============================================
            if ($DEBUG) {
                print ("Inserting row into $ifw_table.\n");
            }
            $sth->execute()
                or printErrAndExit("Unable to Insert <RULE_ROW>:\n", $sql_insert, ":\n",
                    $dbh->errstr(), "\n");
        } else {
            printErrAndExit("Unable to Insert <RULE_ROW> into $ifw_table.  RULESET is Empty.",
                "\n");
        }
    }

    if ($currentEndTag eq "RULEITEM_RESULT") {
        #=============================================
        # Prepare the SQL statement
        #=============================================
        my $ifw_table = "IFW_RULEITEM";
        if ($ruleitem_rule) {
            my $sql_insert = "INSERT INTO $ifw_table "
                           . "(RULE_ID, RANK, NAME, CONDITION, RESULT) "
                           . "VALUES "
                           . "(" 
                           . $dbh->quote($ruleitem_rule) . ", "
                           . "$ruleitem_rank, "
                           . $dbh->quote($ruleitem_name) . ", "
                           . "? " . ", "
                           . "? "
                           . ")";
            
            $ruleitem_rank ++; # Increment for the next time.

            if ($DEBUG) {
                print "$sql_insert\n";
            }
            my $sth = $dbh->prepare($sql_insert)
                or printErrAndExit("Unable to prepare SQL statement: ", $sql_insert, ": ",
                    $dbh->errstr(), "\n");

            $sth->bind_param(1, "$ruleitem_condition")
                or printErrAndExit("Unable to bind CONDITION value to SQL statement: ", $sql_insert, "\n");

            $sth->bind_param(2, $ruleitem_result, SQL_LONGVARCHAR)
                or printErrAndExit("Unable to bind RESULT value to SQL statement: ", $sql_insert, "\n");

            #=============================================
            # Execute the INSERT
            #=============================================
            if ($DEBUG) {
                print ("Inserting row into $ifw_table.\n");
            }
            $sth->execute()
                or printErrAndExit("Unable to Insert <RULEITEM_ROW>:\n", $sql_insert, ":\n",
                    $dbh->errstr(), "\n");
        } else {
            printErrAndExit("Unable to Insert <RULEITEM_ROW> into $ifw_table.  RULE is Empty.",
                "\n");
        }
    }
}

#############################################################################
# Sub          : CharHandler
# Description  : Handler for XML data.  Called when any text is found 
#              :  inside an XML tag set.
#--------------+-------------------------------------------------------------
# In           : XML text
#--------------+-------------------------------------------------------------
# Returns      : None
#############################################################################
sub CharHandler {
    my $text = shift;
    my $temp = $text;

    #=============================================
    # If the string is nothing but 
    # whitespace, just return.
    #=============================================
    if (isWhiteSpace(\$temp)) {
        return;
    }
    
    #=============================================
    # Replace any special chars
    #=============================================
    $text = replaceSpecialChars($text, 0); 

    #=============================================
    # Process the char data for each tag
    #=============================================
    if ( ($currentTag eq "RULESET_RULESET") &&
         ($currentEndTag ne "RULESET_RULESET") ) {
        $ruleset_ruleset = $text;
        $rulesetlist_ruleset = $ruleset_ruleset;
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }
    
    if ( ($currentTag eq "RULESET_NAME") && 
              ($currentEndTag ne "RULESET_NAME") ) {
        $ruleset_name = $text;
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }

    if ( ($currentTag eq "RULESET_DESCRIPTION") && 
              ($currentEndTag ne "RULESET_DESCRIPTION") ) {
        $ruleset_description = $text;
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }

    if ( ($currentTag eq "RULE_RULE") && 
              ($currentEndTag ne "RULE_RULE") ) {
        $rule_rule = $text;
        $rulesetlist_rule = $rule_rule;
        $ruleitem_rule = $rule_rule;
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }

    if ( ($currentTag eq "RULE_NAME") && 
              ($currentEndTag ne "RULE_NAME") ) {
        $rule_name = $text;

        # RULESETLIST.NAME is a primary key so it must contain something.
        if ($rule_name && $rule_name ne "") {
            $rulesetlist_name = $rule_name; 
        } else {
            $rulesetlist_name = " ";
        }
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }

    if ( ($currentTag eq "RULE_INIT_SCRIPT") && 
              ($currentEndTag ne "RULE_INIT_SCRIPT") ) {
        $rule_init_script = $text;
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }

    if ( ($currentTag eq "RULEITEM_NAME") && 
              ($currentEndTag ne "RULEITEM_NAME") ) {
        $ruleitem_name = $text;
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }

    if ( ($currentTag eq "RULEITEM_CONDITION") && 
              ($currentEndTag ne "RULEITEM_CONDITION") ) {
        $ruleitem_condition = $text;
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }

    if ( ($currentTag eq "RULEITEM_RESULT") && 
              ($currentEndTag ne "RULEITEM_RESULT") ) {
        $ruleitem_result = $text;
        if ($DEBUG) {
           print ("$currentTag->$text\n");
        }
    }

}
