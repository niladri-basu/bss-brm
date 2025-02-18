#===============================================================================
##
##
##          Copyright (c) 1998 - 2009 Oracle Corporation. All rights reserved.
##               This material is the confidential property of
##       Oracle Corporation or its subsidiaries or licensors
##    and may be used, reproduced, stored or transmitted only in accordance
##            with a valid Oracle license or sublicense agreement.
##
#-------------------------------------------------------------------------------
# Block: TLS
#-------------------------------------------------------------------------------
# Module Description:
#   Perl-Script to fill tables IFW_EDRC_FIELD and IFW_EDRC_DESC. These tables are
#   used by Portal aggreGate and Portal integRate. This script reads the 
#   container description file.
#
# Open Points:
#   none
#
# Review Status:
#   <in-work>
#
#-------------------------------------------------------------------------------
# Responsible: Karl Braemer
#
# $RCSfile: containerDescLoader.pl $
# $Revision: /cgbubrm_7.3.2.pipeline/1 $
# $Author: smujumda $
# $Date: 2009/06/10 02:06:59 $
# $Locker:  $
#-------------------------------------------------------------------------------
# $Log: containerDescLoader.pl,v $
# Revision 1.11  2001/09/25 15:15:35  mgresens
# PETS#39836
# Support for 'Oracle' and 'DB2'.
# Replace 'Oraperl' by 'DBI'.
#
# Revision 1.10  2001/08/29 11:15:47  kb
# PETS #37292 code documentation added
#
# Revision 1.9  2001/08/15 11:08:57  kb
# PETS #38203
#
# Revision 1.8  2001/08/15 10:36:27  kb
# PETS #38203 types are no longer converted to upper case letters
#
# Revision 1.7  2001/07/25 10:59:31  kb
# PETS #37352 library path 'INT_PERL_LIB' evaluated
#
# Revision 1.6  2001/07/12 12:21:17  kb
# PETS #36563 loading blocks, too
#
#===============================================================================

#===============================================================================
# PATHES, LIBS, PACKAGES
#===============================================================================
BEGIN
{
  if(defined $ENV{INT_PERL_LIB})
  {
    $perlLibPath = $ENV{INT_PERL_LIB};
  }
}

use lib "$perlLibPath";
use Getopt::Std;
use Time::localtime;

#===============================================================================
# Differences between databases
#===============================================================================

sub sequenceString
{
  my $db  = shift;
  my $seq = shift;

  if ($db eq "Oracle")
  {
    return "$seq.NEXTVAL";
  }
  else
  {
    die "Unknown database type!\n";
  }
}

#===============================================================================
# START - Program
#===============================================================================
# Options:
#   -c <command file>

printCopyright(); All rights reserved.

#===============================================================================
# PRINT - Copyright All rights reserved.
#===============================================================================
sub printCopyright() All rights reserved.
{

  print("\n     Copyright (c) 1998 - 2009 Oracle Corporation.\n"); All rights reserved.
  print("       This material is the confidential property of\n");
  print("Oracle Corporation or its subsidiaries or licensors\n");
  print("and may be used, reproduced, stored or transmitted only in accordance\n");
  print("     with a valid Oracle license or sublicense agreement.\n\n");
}

#
# gives help
#
sub printUsage
{
  print "$0: wrong arguments\n";
  print "usage: $0 -c <command file>\n";
  exit 1;
}

#
# check command line
#
sub checkOptions
{
  my $version = '$Revision: 1.11 $';

  print "\nThis is $0 ($version)\n\n";
  
  $started = sprintf "%04d/%02d/%02d %02d:%02d:%02d" , 
  (localtime->year()+1900), (localtime->mon()+1), localtime->mday(),
  localtime->hour(), localtime->min(), localtime->sec();
  print "\nstarted at '$started'\n";
  print "\nstarted by '$<' (user groups '$(')\n";
  print "\nrunning by '$>' (run groups  '$)')\n";
  
  print "\nrunning on '$^O' system\n";
  print "\nperl interpreter '$^X'\n";
  print "\nperl version '$]'\n";
  
  getopts('c:');
  if(not defined($opt_c))
  {
    printUsage;
  }
  $goCmdFile = $opt_c;

  print "\nusing command file '$goCmdFile'\n";
}

my $dbType; # Global, stores the database type
my $dbUser; # Global, stores user name
my $dbPass; # Global, stores password
my $dbSource; # Global, stores db name
my $dbServer; # Global, stores db server name (Only for SQL Server)

#
# reads all lines from command file and dispatches them
#
sub processCmdFile
{
  local ($cmdFile) = @_;
  my $line = "";

  open(SOURCE, $cmdFile) || die "\n\nError: cannot open ", $cmdFile, "\n";
  # read all lines
  while(defined($line = <SOURCE>))
  {
    chomp($line); # get rid of line feed
    
    if(($line =~ /^\#/) || length($line) <= 0)
    {
      # ignore empty lines and comments
    }
    else
    {
      if($line =~ /^DEBUG=/)
      {
        #
        # the global debug flag defines that we see what this script does
        #
        $line =~ s/^DEBUG=//; # get value
        if($line eq "TRUE")
        {
          $goDebug = "TRUE";
        }
        else
        {
          $goDebug = "FALSE";
        }
      }
      elsif($line =~ /^SOURCE=/)
      {
        # get database source
        $line =~ s/^SOURCE=//;
        $dbSource = $line;
      }
      elsif($line =~ /^TYPE=/)
      {
        # get database type
        $line =~ s/^TYPE=//;
        $dbType = $line;
      }
      elsif($line =~ /^USER=/)
      {
        # get database username
        $line =~ s/^USER=//;
        $dbUser = $line;
      }
      elsif($line =~ /^PASS=/)
      {
        # get database password
        $line =~ s/^PASS=//;
        $dbPass = $line;
      }
      elsif($line =~ /^RUN=/)
      {
        # get command 
        $line =~ s/^RUN=//;
        # execute the command
        &executeCommand($line);
      }
      elsif($line =~ /^INIT=/)
      {
        $line =~ s/^INIT=//;  # get value
        if($line eq "TRUE")
        {
          $goInit = "TRUE";
        }
        else
        {
          $goInit = "FALSE";
        }
      }
      elsif($line =~ /^ECHO=/)
      {
        # logging
        $line =~ s/^ECHO=//;
        print "$line\n";
      }
      elsif($line =~ /^EDRC_DESC_FILE=/)
      {
        $line =~ s/^EDRC_DESC_FILE=//; # get the container description file location
        $goEdrcDescFile = $line;
      }
      elsif($line =~ /^EDRC_DESC=/)
      {
        $line =~ s/^EDRC_DESC=//; # get the edr container description name
        $goEdrcDesc = $line;
      }
      elsif($line =~ /^EDRC_DESCRIPTION=/)
      {
        $line =~ s/^EDRC_DESCRIPTION=//;  # get the edr container description
        $goEdrcDescription = $line;
      }
      elsif($line =~ /^SERVER=/)
      {
        $line =~ s/^SERVER=//;
        $dbServer = $line;
      }
      else
      {
        die "\n\n$0 interpreter received unknown command line '$line'\n";
      }
    }
  }
  close(SOURCE);

  if ($goInit eq "TRUE")
  {
    &deleteEdrcField; # delete table IFW_EDRC_FIELD
    &deleteEdrcDesc;  # delete table IFW_EDRC_DESC
    
    print("\ndeleting of $goEdrcDesc successfully processed.\n");
  }

}

#
# process all lines from description file
#
sub processDescFile
{
  local ($descFile) = @_;

  my $blockName = "";
  my $fieldName = "";
  my $fieldType = "";
  my $description = "";
  my $line = "";
  my $leftBracket = 0;
  my $rightBracket = 0;
  my $orgLine;
  my $fullFieldName = "";
  my $blockProcessed = 0;
       
  print "\nstart to process '$descFile' ...\n";
  
  print "\nnow insert into IFW_EDRC_DESC ...\n";
  
  # fill parent table IFW_EDRC_DESC
  insertEdrcDesc($goEdrcDesc,$goEdrcDescription);

  print "\nnow insert into IFW_EDRC_FIELD ...\n";

  open(SOURCE, $descFile) || die "\n\nERROR: cannot open ", $descFile, "\n";
  # read all lines from container description file 
  while(defined($orgLine = <SOURCE>))
  {
    
    #
    # syntactical step
    #
    
    if ($goDebug eq "TRUE")
    {
      # log just read line
      print("have read: " . $orgLine . "\n");
    }
      
    # separate read line into logical parts (type identifier comment)
    $line = &buildList($orgLine, ";");

    if ($goDebug eq "TRUE")
    {
      # log the built list
      print("after delimiter " . "'" . $line . "'" . "\n");
    } 

    # split built list into token array
    my @tokens = split(/;/, $line);
             
    if ($goDebug eq "TRUE")
    {
      # log the evaluated tokens
      for (my $i=0; $i <= $#tokens; $i++)
      {
        print("token" . "'" . $tokens[$i]. "'" . "\n");
      }
    }   
    
    #
    # grammar step
    #
    
    # check if current context is block or bracket
    if ( $#tokens == 0) # first case: only one token
    {
      if ($rightBracket == 1)
      {
        $rightBracket = 0;
        $blockName = "";
      }
      
      if ($tokens[0] eq "{" && $rightBracket == 0)
      {
        $leftBracket = 1;
        $rightBracket = 0;
        $blockProcessed = 0;
      }
      elsif($tokens[0] eq "}" && $leftBracket == 1)
      {
        $rightBracket = 1;
        $leftBracket = 0;
        $blockProcessed = 0;
      }
      elsif($leftBracket == 0 && $rightBracket == 0)
      {
        if ($blockProcessed == 1)
        {
          die "\nError: grammar at line '$line'\n";
        }
        # this should be a block
        $blockName = $tokens[0];
        $blockProcessed = 1;
        
        # put found block into hash map if it does not exist
        if (&setBlockName($blockName) == 1)
        {
          # block was already in hash
          if ($goDebug eq "TRUE")
          {
            print("block $blockName found!");
          }
        }
      }
      else
      {
        # unexpected token or wrong grammar
        die "\n\nError: grammar token: " . $tokens[0] . " at line: " . $orgLine . "\n";
      }
    }
    elsif ($#tokens == 2) # second case: three tokens
    {  
      $fieldType   = $tokens[0]; # data type
      $fieldName   = $tokens[1]; # identifier
      $description = $tokens[2]; # field description
      $blockProcessed = 0;
      
      # final type reached (String, Decimal, Integer or Date)?
      if (&ordinaryType($fieldType) == 1)
      {
        my $namesStr;
        $namesStr = "";

        # get the complex block(s) which are belonging to current block
        # if $blockName is CUSTOMER this would be 'DETAIL.CUST_A;DETAIL.CUST_B'
        $namesStr = &getComplexName($blockName);
 
        # build array to evaluate all blocks
        my @names = split(/;/, $namesStr);
        
        for (my $i = 0; $i <= $#names; $i++)
        { 
          # insert block name into hash; the map value 'found' will effect nothing
          $goBlockNames{$names[$i]} = "found";
          
          # build complete field name (first DETAIL.CUST_A.ACCOUNT_NO and then DETAIL.CUST_B.ACCOUNT_NO)
          $fullFieldName = $names[$i] . "." . $fieldName;

          # set up field type
          $type = $fieldType;
          
          # fill table IFW_EDRC_FIELD
          insertEdrcField($goEdrcDesc, $fullFieldName, $type, $description);
        }

        &execSqlCommand("","TRUE");
      }
      else
      {
        # this have to be a Block type
        my $namesStr = &getComplexName($blockName);
        my @names = split(/;/, $namesStr);
         
        for (my $i = 0; $i <= $#names; $i++)
        {
          # build comlete block DETAIL.CUST_A (next line could be DETAIL.CUST_B)
          $fullName = $names[$i] . "." . $fieldName;
          
          # put into hash if fieldType (CUSTOMER) already exists append the fullName
          &setComplexName($fieldType, $fullName, "TRUE");
        }
      }
    }
    else
    {
      if (length($line) != 0)
      {
        die "\n\ngrammar error: unexpected token counter at line: $orgLine \n";
      }
    }
  }
  close(SOURCE);

  # after the container description file is read and all fields with ordinary types are filled
  # all Blocks will be inserted into IFW_EDRC_FIELD, too.
  &insertBlockNames;

  print "\nprocessing of '$descFile' finished.\n";
}

#
# preparation for init 
#

# delete ifw_edrc_field
sub deleteEdrcField
{
  print("\nnow deleting IFW_EDRC_FIELD (container description: $goEdrcDesc) ...\n");

  my $dbCmd = "DELETE FROM IFW_EDRC_FIELD WHERE EDRC_DESC = $goEdrcDesc";
  if($goDebug eq "TRUE") { print "$dbCmd\n"; }
  
  # execute the sql statement
  &execSqlCommand($dbCmd,"FALSE");
}

# delete ifw_edrc_desc
sub deleteEdrcDesc
{
  print("\nnow deleting IFW_EDRC_DESC (container description: $goEdrcDesc) ...\n");

  my $dbCmd = "DELETE FROM IFW_EDRC_DESC WHERE EDRC_DESC = $goEdrcDesc";
  if($goDebug eq "TRUE") { print "$dbCmd\n"; }
  
  # execute the sql statement
  &execSqlCommand($dbCmd,"FALSE");
}

#
# insert fields into ifw_edrc_field
#
sub insertEdrcField
{
  local ($edrc_desc, $field_name, $type, $description) = @_;
  my $dbCmd = "";

  if ($dbType eq "SqlServer")
  {
    $dbCmd = "INSERT INTO ifw_edrc_field (edrc_desc, field_name, type, description) VALUES ($edrc_desc, '$field_name', '$type', '$description')";
  }
  else
  {
    my $seqStr = sequenceString($dbType, 'ifw_seq_field_id');

    $dbCmd = "INSERT INTO ifw_edrc_field (field_id, edrc_desc, field_name, type, description) VALUES ($seqStr, $edrc_desc, '$field_name', '$type', '$description')";
  }

  if($goDebug eq "TRUE") { print "$dbCmd\n"; }
 
  local ($tmpfile) = "./pintmp$$.sql";

  # Create a temporary file with the sqlplus input.
  open(TMPFILE, ">>$tmpfile") || die "Error: cannot create or append $tmpfile\n";
  print TMPFILE "$dbCmd;\n";
  close(TMPFILE);

  # increment counter
  $goInsertedFields++;
}

#
# insert container name and description into ifw_edrc_desc
#
sub insertEdrcDesc
{
  local ($edrc_desc, $name) = @_;

  my $dbCmd = "INSERT INTO ifw_edrc_desc (edrc_desc, name) VALUES ($edrc_desc, $name)";
                
  if($goDebug eq "TRUE") { print "$dbCmd\n"; }

  # execute sql statement
  &execSqlCommand($dbCmd,"FALSE");

  # increment counter
  $goInsertedDesc++;
}

#
# analyse one line of the container description file
# separate found tokens
#      
sub buildList
{
  local ($line, $delimiter) = @_;
  
  $newLine = "";
  my $char;
  my $tokenStart = 0;
  my $tokenFound = 0;
  
  chomp($line); # get rid of line feed
    
  for (my $i=0; $i < length($line); $i++)
  {
    # character by character
    $char = substr($line, $i, 1);
        
    # allow only blanks as white spaces    
    if ($char eq "\t" || $char eq "\r" || $char eq "\f" || $char eq "\e")
    {
      $char = " ";
    }
      
    #comment reached => escape
    if ($char eq "/")
    {
      return $newLine;
    }

    #delimiter reached: take comment as description
    if ($char eq $delimiter)
    {
      $newLine .= $char;

      # prepare the possible comment part for description  
      $newLine .= &prepareDesc(substr($line, $i+1));
      
      # return token list
      return $newLine;
    }
    
    # curent token
    if ($char ne " ")
    {  
      if ($tokenStart == 0 && $tokenFound == 1)
      {
        # prepend the separator to the token (starting with the second token)
        $tokenFound = 0;
        $newLine .= ";";
      }
      
      $tokenStart = 1;
      $newLine .= $char;
    }  
    elsif ($tokenStart == 1)
    {
      # token finished
      $tokenFound = 1;
      $tokenStart = 0;
    }
  }
  
  return $newLine;
}  

#
# build out of the field comment a nice description
#
sub prepareDesc
{
  local ($line) = @_;
  
  my $newLine = "";
  my $char;
  my $tokenStart = 0;
  
  for (my $i=0; $i < length($line); $i++)
  {
    $char = substr($line, $i, 1);
        
    # allow only blanks as white spaces and eliminate slashes
    if ($char eq "\t" || $char eq "\r" || $char eq "\f" || $char eq "\e" || $char eq "/")
    {
      $char = " ";
    }
    elsif ($char eq "'")
    {
      # add additional "'" to satisfy oracle string termination
      $newLine .= $char;
    }
    
    if ($tokenStart == 1 || $char ne " ")
    {
      $tokenStart = 1;
      $newLine .= $char;
    }
  }
  
  if (length($newLine) <= 0)
  {
    # no comment found
    $newLine = "no description found";
    return $newLine;
  }

  return $newLine;    
}
#---------------------------
# determines an ordinary type
#---------------------------
sub ordinaryType
{
  local ($type) = @_;
  
  for(my $i=0; $i <= $#goFieldTypes; $i++)
  {
    if ($goFieldTypes[$i] eq  $type)
    {
      return 1;
    }
  }
  
  if ($goDebug eq "TRUE")
  {
    print(" haven't found searched: " . $type . "\n");
  }
  return 0;
}

#
# insert a new block into hash if it doesn't exist (DETAIL or CUSTOMER or TRAILER etc.)
# returns 1 if the type already exist
# returns 0 if the was inserted
#
sub setBlockName
{
  local ($block) = @_;

  # reset iterator
  keys %goNewFieldTypes;

  # iterate trough hash
  while (my @keyValue = each(%goNewFieldTypes))
  {
    if ($block eq $keyValue[0])
    {
      if ($goDebug eq "TRUE")
      {
        print("block already in hash: " . $block . " block value " .  $goNewFieldTypes{$block} . "\n");
      }
      return 1;
    }
  }
  
  # insert key value map
  $goNewFieldTypes{$block} = $block;
  if ($goDebug eq "TRUE")
  {
    print("block inserted: " . $block . " block value " .  $goNewFieldTypes{$block} . "\n");
  }
  
  return 0; 
}      

#
# insert a new field type with corresponding value into hash
# e.g. key CUSTOMER value(s) DETAIL.CUST_A;DETAIL.CUST_B
# appends value if related flag is TRUE
#
sub setComplexName
{
  local ($type, $value, $append) = @_;

  my $found = 0;

  # reset iterator
  keys %goNewFieldTypes;

  # iterate trough hash
  while (my @keyValue = each(%goNewFieldTypes))
  {
    if ($type eq $keyValue[0])
    {
      if ($append eq "TRUE")
      {
        # add it (; delimited list)
        $goNewFieldTypes{$type} = $keyValue[1] . ";" . $value;
      }
      $found = 1;
    }
  }
  
  if ($found == 0)
  {
    # insert key value map
    $goNewFieldTypes{$type} = $value;
  }
   
  if ($goDebug eq "TRUE")
  {
    print("complex type: " . $type . " ass. value(s) " .  $goNewFieldTypes{$type} . "\n");
  }
}      

#
# finds a complex field type in hash
# and returns mapped value else program dies
#
sub getComplexName
{
  local ($type) = @_;

  if ($goDebug eq "TRUE")
  {
    print("get complex searching: " . $type . "\n");
  }
  
  # reset iterator
  keys %goNewFieldTypes;

  # iterate trough hash
  while (my @keyValue = each(%goNewFieldTypes))
  {
    if ($type eq $keyValue[0])
    {
      # remember used datatype
      $goUsedNewFieldTypes{$type} = "used"; # currently without function
      return $keyValue[1];
    }
  }

  die "\n\nError: could not find $type in hash\n";
}      

#
# obsolete function !!!
# evaluates the used new field types 
#
sub checkUsedNewFieldTypes
{
  print "\nnow checking the correctness of block definition ...\n";

  # reset iterator
  keys %goNewFieldTypes;

  my $error = 0;
  
  # iterate trough hash
  while (my @keyValue = each(%goNewFieldTypes))
  {
    if (0 == &getNewUsedFieldType($keyValue[0]))
    {
      $error = 1;
      print("\nError: Unused complex type '$keyValue[0]'\n");
    }
  }
  
  if (1 == $error)
  {
    die "\n\nError: There are unused complex types!\n\n";
  }

  print "\nchecking finished without errors.\n";
}

#
# obsolete function
# called by former function
#
sub getNewUsedFieldType
{
  local ($type) = @_;

  # reset iterator
  keys %goUsedNewFieldTypes;

  # iterate trough hash
  while (my @keyValue = each(%goUsedNewFieldTypes))
  {
    if ($type eq $keyValue[0])
    {
      return 1;
    }
  }
  
  return 0;
}      

#
# this function insert all block names with type 'Block' into ifw_edrc_field
#
sub insertBlockNames
{
  local ($type) = @_;

  print "\nnow inserting all blocks into IFW_EDRC_FIELD ...\n";

  # reset iterator
  keys %goBlockNames;

  # iterate trough hash
  while (my @keyValue = each(%goBlockNames))
  {
    if ($goDebug eq "TRUE")
    {
      print "\nnow inserting block: '$keyValue[0]' ...";
    }
    insertEdrcField($goEdrcDesc, $keyValue[0], "Block", "");
    
    # increment statistical counter
    $goInsertedBlocks++;
  }
  
  &execSqlCommand("","TRUE");

  return 0;
}      

#
# prints statistical information
#
sub showStatistic
{
  print("\nRows inserted into IFW_EDRC_DESC : $goInsertedDesc\n");
  print("\nRows inserted into IFW_EDRC_FIELD: $goInsertedFields (including: $goInsertedBlocks blocks)\n\n");

  $ended = sprintf "%04d/%02d/%02d %02d:%02d:%02d" , 
  (localtime->year()+1900), (localtime->mon()+1), localtime->mday(),
  localtime->hour(), localtime->min(), localtime->sec();

  print("\n\n$0 successfully finished at $ended.\n\n");
}

#
# interpretes the RUN command
#
sub executeCommand
{
  local($cmd) = @_;

  if($goDebug eq "TRUE")
  {
    print("now execute '$cmd'\n");
  }
  `$cmd`;
}

#
# execute sql command
#

sub execSqlCommand {
  local ($cmd,$fileexists) = @_;
  local ($status) = 0;
  local ($exitcode) = 0;
  local ($tmpfile) = "./pintmp$$.sql";

  if($fileexists eq "FALSE")
  {
    # Create a temporary file with the sqlplus input.
    open(TMPFILE, ">$tmpfile") || die "Error: cannot create $tmpfile\n";
    print TMPFILE "$cmd;\n";
  }
  else
  {
    # Open temporary file in append mode.
    open(TMPFILE, ">>$tmpfile") || die "Error: cannot create $tmpfile\n";
  }

  if ($dbType eq "SqlServer")
  {
    close(TMPFILE);

    $sqlout = `osql -U $dbUser -P $dbPass -S $dbServer -d $dbSource -i "$tmpfile"`;
  }
  else
  {
    print TMPFILE "commit;\n";
    print TMPFILE "exit;\n";
    close(TMPFILE);

    # SQLPLUS gives a zero status back if the user/passwd is
    # wrong. So, instead of using system(), we need to capture the output
    # of SQLPLUS and parse it to see if there was an error.

    $sqlout = `sqlplus $dbUser/$dbPass\@$dbSource < $tmpfile`;

    $exitcode = $?;
    $status = ($? >> 8);
  }

  if ($goDebug eq "TRUE")
  {
    print("\n$sqlout\n");
  }

  unlink "$tmpfile";
  
  if ($dbType eq "SqlServer")
  {
    if ($sqlout =~ m/Msg/ || $sqlout =~ m/Error/)
    {
      if ($goDebug eq "TRUE")
      {
        print("\nError: OSQL failed (exitcode = $exitcode)\n");
      }

      exit(1);
    }
  }
  else
  {
    if ($sqlout =~ m/ERROR: /)
    {
      if ($goDebug eq "TRUE")
      {
        print("\nError: SQLPLUS failed (exitcode = $exitcode)\n");
      }

      exit(1);
    }

    # On NT, we are getting the exit status as is in $?...
    # so, $status after right shifting becomes 0! So, check for
    # non-zero $? even though it is not "absolutely" right on unix.

    if ($status || $exitcode)
    {
      if ($goDebug eq "TRUE")
      {
        print("\nError: SQLPLUS failed with status $status\n");
      }

      exit (1);
    }
  }
}


##------------------------------------------------------------------------------
## main
##------------------------------------------------------------------------------
#
# initialize
#
$newLine    = "";
$goDebug    = "FALSE";
$goInit     = "FALSE";
$goCmdFile  = "";
$goEdrcDescFile = "";
$goEdrcDesc = "";
$goEdrcDescription = "";
@goFieldTypes = ("String", "Date", "Integer", "Decimal");
%goNewFieldTypes = ();
%goUsedNewFieldTypes = ();
%goBlockNames = ();
$goInsertedFields = 0;
$goInsertedDesc = 0;
$goInsertedBlocks = 0;

#
# check usage
#
&checkOptions;

#
# process the command file
#
&processCmdFile($goCmdFile);

#
# process the container description file
#
&processDescFile($goEdrcDescFile);

## do not check empty /unused blocks PETS #38203
##&checkUsedNewFieldTypes;

#
# before ending show statistical information
#
&showStatistic;
# END
