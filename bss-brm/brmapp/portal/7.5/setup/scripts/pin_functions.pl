#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=======================================================================
#  @(#)%Portal Version: pin_functions.pl:PortalBase7.3.1Int:1:2007-Sep-20 01:52:00 %
# 
# Copyright (c) 2002, 2013, Oracle and/or its affiliates. All rights reserved.
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation helper functions
#
#=========================================================================
use File::Copy;

#
# Save STDOUT and STDERR filehandles.
#
open( SAVEOUT, ">&STDOUT");
open( SAVEERR, ">&STDERR");


#=============================================================
#
#  This function outputs a string in the resource file
#  Arguments	: 
#    $OutFile - Output file
#    $OutString - Output string
#    @<...> Arguments passed to write function
#
#  Returns : 1 if successful
#
#=============================================================
sub Output {
  local( $OutFile ) = shift( @_ );
  local( $OldFile ) = select( $OutFile ); 
  local( $Format ) = shift( @_ );
  local( $OutString ) = sprintf( $Format, @_ );

  #
  # mask the password
  #

  if ($OutString =~ /\/(?!.*\/)(.*?)@/) {
    if ($OutString =~ /-l|-s|-user/i) {
      $OutString =~ s/\/(?!.*\/)(.*?)@/\/***@/;
    }
  } elsif ($OutString =~ /\/(.*?)@/)  {
    if ($OutString =~ /-l|-s|-user/i) {
      $OutString =~ s/\/(.*?)@/\/***@/;
    }
  }

  syswrite ( $OutFile, $OutString, length( $OutString ) );
  select( $OldFile );
}

#=============================================================
#
#  This function opens a file for logging and selects it
#  Arguments	: 
#    $FileName - Name of file to use
#    $OpenType - Open in append mode or overwrite
#
#  Returns : fpLogFile - File Pointer to log file
#
#=============================================================
sub OpenLogFile {
  local( $FileName, $OpenType ) = @_;
  local( $OpenString );
  if ( $OpenType =~ m/^APPEND$/i ) {
    $OpenString = ">> $FileName";
  } else {
    $OpenString = "> $FileName";
  }
  if ( !open( fpLogFile, $OpenString )) {
    &Output( STDERR, $IDS_UNABLETOLOGTO, $FileName );
    exit( 1 );
  }
  select( fpLogFile );
  $|=1;
  select( STDERR );
  $|=1;
  select( STDOUT );
  $|=1;
}

#=============================================================
#
#  This function opens a file for piping and selects it
#  Arguments : 
#    $FileName - Name of file to use
#
#  Returns : fpPipeFile - File Pointer to Piped file
#
#=============================================================
sub OpenPipeFile {
  local( $FileName, $OpenType ) = @_;
  if ( !open( fpPipeFile, "> $FileName" )) {
    &Output( STDERR, $IDS_UNABLETOLOGTO, $FileName );
    exit( 1 );
  }
  select( fpPipeFile );
  $|=1;
  select( STDERR );
  $|=1;
  select( STDOUT );
  $|=1;
}

#=============================================================
#
#  This function executes a shell command and pipes its output
#  to a file pointer.
#  Arguments :
#    $OutputToStdOut - TRUE or FALSE
#    $Cmd - Command to be executed
#    @<...> Arguments passed to execute function
#
#  Returns : the value returned by the system call
#=============================================================
sub ExecuteShell {
  local( $OutputToStdOut ) = shift( @_ );
  local( $Cmd ) = shift( @_ );
  local( $Command );
  local( $result );

  if ( ! ( $OutputToStdOut eq TRUE ) ) {
    open( STDOUT, ">&fpLogFile");
    open( STDERR, ">&fpLogFile");
  }

  $Command = join( " ", $Cmd, @_ );
  &Output( STDOUT, $IDS_EXECUTING_COMMAND, $Command );
  $result = system( $Command );


  if ( ! ( $OutputToStdOut eq TRUE ) ) {
    close( STDOUT );
    close( STDERR );

    open( STDOUT, ">&SAVEOUT" );
    open( STDERR, ">&SAVEERR" );
  }
  return $result;
}

#=============================================================
#
#  This function executes a shell command and pipes its output
#  to another file pointer.
#  Arguments:
#    $FileName - FileName to pipe to 
#    $Echo - Display command to be executed ?
#    $Cmd - Command to be executed
#    @<...> Arguments passed to execute function
#
#  Returns:the value returned by the system call
#=============================================================
sub ExecuteShell_Piped {
  local( $FileName ) = shift( @_ );
  local( $Echo ) = shift( @_ );
  local( $Cmd ) = shift( @_ );
  local( $Command );
  local( $result );
	
  $Command = join( " ", $Cmd, @_ );
  if ( $Echo eq TRUE ) {
    &Output( STDOUT, $IDS_EXECUTING_COMMAND, $Command );
  } 

  &OpenPipeFile( $FileName );
  open( STDOUT, ">&fpPipeFile");
  open( STDERR, ">&fpPipeFile");

  &Output( fpPipeFile, $IDS_EXECUTING_COMMAND, $Command );
	
  $result = system( $Command );

  close( fpPipedFile );

  close( STDOUT );
  close( STDERR );

  open( STDOUT, ">&SAVEOUT" );
  open( STDERR, ">&SAVEERR" );

  return $result;
}


#=============================================================
#
#  This function Executes a SQL statement read from a file. 
#  This assumes that the username, password, and Alias have 
#  already been verified.
#
#  Arguments:
#    $FileName - SQL Filename to execute
#    $bOutputStatement - Display the statement
#    $bOutputResult - Display the resulting output
#    %DB- Associative array for db
#
#  Returns : Return value of ExecuteSQL statement
#=============================================================
sub ExecuteSQL_Statement_From_File {
  local( $FileName ) = shift( @_ );
  local( $bOutputStatement ) = shift( @_ );
  local( $bOutputResult ) = shift( @_ );
  local( %DB ) = @_;
  local( $Statement );

  # Display a message of creating indexes
  &Output( STDOUT, $IDS_CREATE_INDEXES_FILE,
                       $FileName ); 

  open( TMPFILE, "< $FileName" );
  $Statement = join( "", <TMPFILE> );
  close( TMPFILE );
  return ExecuteSQL_Statement( $Statement, 
                               $bOutputStatement, 
                               $bOutputResult, 
                               %DB );
}
#=============================================================
#
#  This function Executes a SQL statement read from a file.
#  This functions is similar to the above but is currently used
#  for db2 where the delimiter might be different and the call
#  to load such a file involves a different function.
#  This assumes that the username, password, and Alias have
#  already been verified.
#
#  Arguments:
#    $FileName - SQL Filename to execute
#    $bOutputStatement - Display the statement
#    $bOutputResult - Display the resulting output
#    %DB- Associative array for db
#
#  Returns : Return value of ExecuteSQL statement
#=============================================================
sub ExecuteSQL_Statement_From_File_with_delimiter {
  local( $FileName ) = shift( @_ );
  local( $bOutputStatement ) = shift( @_ );
  local( $bOutputResult ) = shift( @_ );
  local( %DB ) = @_;
  local( $Statement );

  open( TMPFILE, "< $FileName" );
  $Statement = join( "", <TMPFILE> );
  close( TMPFILE );
  return ExecuteSQL_Statement_with_delimiter( $Statement,
                               $bOutputStatement,
                               $bOutputResult,
                               %DB );
}

#=============================================================
#
# This function drops the Portal objects from the database
#
#  Arguments:
#    %DB- Associative array for db
#
#  Returns : Return value of ExecuteSQL statement
#=============================================================
sub DropTables {
  local ( %DB ) = @_;
  
  # Display a message of drop table
  &Output( STDOUT, $IDS_DD_DROP_FILE,
                       $SPECIAL_DD_DROP_FILE ); 
  
  if ( $USE_SPECIAL_DD_FILE !~ /^YES$/i ) {
    &ExecuteSQL_Statement_From_File( "$PIN_HOME/sys/dm_$DB{'vendor'}/data/drop_snapshots.source",
				   TRUE, TRUE, %DB );
    &ExecuteSQL_Statement_From_File( "$PIN_HOME/sys/dm_$DB{'vendor'}/data/drop_tables.source",
				   TRUE, TRUE, %DB );
  } else {
    &ExecuteSQL_Statement_From_File( "$SPECIAL_DD_DROP_FILE",
				   TRUE, TRUE, %DB );
  }
}

#=============================================================
#
# This function drops the Portal procedures from the database
# (Called only from dm_odbc install right now).
#
#  Arguments:
#    %DB- Associative array for db
#
#  Returns : Return value of ExecuteSQL statement
#=============================================================
sub DropProcedures {
  local ( %DB ) = @_;
  &ExecuteSQL_Statement_From_File( "$PIN_HOME/sys/dm_$DB{'vendor'}/data/drop_procedures.source",
				   TRUE, TRUE, %DB );
}

#=============================================================
#
#  This function reads a "pin.conf" perl script and evals it
#
#  Arguments:
#    $filename - Name of the perl script for the pin.conf file
#
#  Returns :  whether or not the eval succeeded
#=============================================================
sub ReadIn_PinCnf {
  local( $PinConfPerlFile ) = shift( @_ );
  local( @ReadInArray );
  local( $ReadInStatement );
  open ( PINCONFFILE, "< $PinConfPerlFile" ) || die( "Can't open $PinConfPerlFile" );
  @readInArray = <PINCONFFILE>;
  close( PINCONFFILE );
  $ReadInStatement = join( "", @readInArray );
  return eval( $ReadInStatement );
}

#=============================================================
#
#  This function adds an array to a second array
#
#  Arguments:
#    $pSRC_ARRAY - pointer to the source array
#    $pDST_ARRAY - pointer to the destination array
#
#=============================================================
sub AddArrays {
  local( $pSRC_ARRAY ) = shift(@_);
  local( $pDST_ARRAY ) = shift(@_);
  local( $entry );
  foreach $entry (sort keys( %$pSRC_ARRAY) ) {
    $$pDST_ARRAY{"$entry"} = $$pSRC_ARRAY{"$entry"};
  }
}
	
#=============================================================
#
#  This function creates a pin.cnf file with the parameters
#  passed. Do not use this if this is an upgrade (it will
#  overwrite the current pin.cnf file
#
#  Arguments:
#    $PinConfFile- pin.cnf file to modify
#    $Header- Header statement to display
#    %PINCONF_ENTRIES - pin.cnf entries
#
#  Returns: true 
#=============================================================
sub Configure_PinCnf {
  local( $PinConfFile ) = shift( @_ );
  local( $Header ) = shift( @_ );
  local( %PINCONF_ENTRIES ) = @_;
  local( $entry );
  local( $description );

  # Display a message of generating pin.conf
  &Output( STDOUT, $IDS_CONFIGURING_PIN_CONF, $CurrentComponent );
  &Output( fpLogFile, $IDS_CONFIGURING_PIN_CONF, $CurrentComponent );

  &Output( STDOUT, $IDS_PIN_CONF_GENERATE,
                       $PinConfFile ); 
  &Output( fpLogFile, $IDS_PIN_CONF_GENERATE, $PinConfFile );

  #Checks for the existence and takes backup of that file.
  if(-e "$PinConfFile") {
     copy($PinConfFile, "$PinConfFile.bak");
  }
  

  if (open( PINCONFFILE, "> $PinConfFile" )) {
  	print PINCONFFILE $Header."\n\n";
  	print PINCONFFILE $IDS_GENERIC_PIN_CONF_HEADER."\n"; 
  	print PINCONFFILE "#=======================================================================\n";
  	print PINCONFFILE "# ptr_virtual_time\n";
  	print PINCONFFILE "# \n";
  	print PINCONFFILE "# Enables the use of pin_virtual_time to advance Portal time, and \n";
  	print PINCONFFILE "# specifies the shared file for use by all Portal mangers.\n";
  	print PINCONFFILE "#\n";
  	print PINCONFFILE "# The entry has 2 values\n";
  	print PINCONFFILE "#\n";
  	print PINCONFFILE "# #/Empty     	to disable / enable pin_virtual_time in all pin.conf files\n";
  	print PINCONFFILE "#		default = #	(disable)\n";
  	print PINCONFFILE "#\n";
  	print PINCONFFILE "# <filepath> 	location and name of the pin_virtual_time file shared by all Portal managers.\n";
  	print PINCONFFILE "#		default = \$\{PIN_HOME\}/lib/pin_virtual_time_file\n";
  	print PINCONFFILE "#\n";
  	print PINCONFFILE "#=======================================================================\n";
  	print PINCONFFILE "$CM{'pin_virtual_time_commented'} - - pin_virtual_time $CM{'pin_virtual_time_path'}\n\n";
  	foreach $entry (sort keys( %PINCONF_ENTRIES ) ) {
    		if ( $entry !~ /_description$/i ) {
      			$description = $entry."_description";
      			print PINCONFFILE "\n\n";
      			print PINCONFFILE $PINCONF_ENTRIES{ $description } ;
      			print PINCONFFILE $PINCONF_ENTRIES{ $entry }."\n" ;
    		}
  	}
  	close( PINCONFFILE );
  } else {
	print STDOUT "The file $PinConfFile could not be opened \n";
  }
  return TRUE;
}

#=============================================================
# This function looks for a keyword in a file (1 line after a 
# comment
#
# Arguments:
#    $KeyWord - Keyword to look for
#    @File Array - Array containing the file
#
# $Returns: The array index at which the comment ends (or -1 if
#           not found
#=============================================================
sub LocateEntry {
  local( $Keyword ) = shift( @_ );
  local( @File ) = @_;
  local( $i ) = 0;
 
  # Go through the whole file
  while ( $i < @File ) {
    if ( $File[ $i ] =~ /^\#=+$/ ) {
      if ( ( $i + 1 ) < @File ) {
        if ( $File[ $i + 1 ] =~ /^\#\s+$Keyword\s*$/ ) {
          # Located the entry
          $i = $i + 1;
          while ( $File[ $i ] !~ /^\#=+$/ ) {
            $i = $i + 1;
          }
          $i = $i + 1;
          return $i;
        }
      }
    }
    $i = $i + 1;
  }
  return -1;
}

#=============================================================
# This function looks for the next section in a file 
#
# Arguments:
#    $SearchFrom - Line to search from
#    @File Array - Array containing the file
#
# $Returns: The array index at which the comment begins (or -1 if
#           not found
#=============================================================
sub LocateNextSection {
  local( $SearchFrom ) = shift( @_ );
  local( @File ) = @_;
  
  while ( $SearchFrom < @File ) {
    if (( $File[ $SearchFrom ] =~ /^\#=+$/ ) || ( $File[ $SearchFrom ] =~ /^\#\*+$/ )){
      return $SearchFrom;
    }
    $SearchFrom = $SearchFrom + 1;
  }
  return -1;
}
          


#=============================================================
#
#  This function replaces a pin.conf entry based on a keyword
#  located 1 line under the #====== comment.
#
#  Arguments:
#    $PinConfFile- pin.cnf file to modify
#    $KeyWord - Keyword to look for for replacing the entry
#    $Value   - Value to use for the entry
#
#  Returns: true 
#=============================================================
sub ReplacePinConfEntry {
  local( $PinConfFile ) = shift( @_ );
  local( $KeyWord ) = shift( @_ );
  local( $Value ) = shift( @_ );

  local( @FileReadIn );
  local( @Temp );
  local( $Start );
  local( $End );

  #
  #  Open the file for in place editing
  #
  open( PINCONFFILE, "+< $PinConfFile" );
  @FileReadIn = <PINCONFFILE>;
  $Start = &LocateEntry( $KeyWord, @FileReadIn );
  if ( $Start == -1 ) {
    push( @FileReadIn, "\n#=========\n# $KeyWord\n#=========\n$Value\n");
  } else {
    $End = &LocateNextSection( $Start, @FileReadIn );
    if ( $End == -1 ) {
      @Temp = ( @FileReadIn[ 0 .. ($Start-1)], 
                 $Value."\n\n"  );
      @FileReadIn = @Temp;
    } else {
       @Temp = ( @FileReadIn[ 0 .. ($Start-1)], 
                 $Value."\n\n", 
                 @FileReadIn[ ($End - 1) .. (@FileReadIn - 1) ], "\n" );
       @FileReadIn = @Temp;
    }
  }
  
  seek( PINCONFFILE, 0, 0 );
  print PINCONFFILE @FileReadIn;
  print PINCONFFILE "\n";
  truncate( PINCONFFILE, tell( PINCONFFILE ) );
  close( PINCONFFILE );
}

#=============================================================
#
#  This function adds a pin.conf entry based on a keyword
#  located 1 line under the #====== comment.
#
#  Arguments:
#    $PinConfFile- pin.cnf file to modify
#    $KeyWord - Keyword to look for for replacing the entry
#    $Value   - Value to use for the entry
#
#  Returns: true 
#=============================================================
sub AddPinConfEntry {
   local( $PinConfFile ) = shift( @_ );
   local( $KeyWord ) = shift( @_ );
   local( $Value ) = shift( @_ );

   local( @FileReadIn );
   local( @Temp );
   local( $Start );
   local( $End );
   local( $Tmp );

   #
   #  Open the file for in place editing
   #
   open( PINCONFFILE, "+< $PinConfFile" );
   @FileReadIn = <PINCONFFILE>;
   $Start = &LocateEntry( $KeyWord, @FileReadIn );
   if ( $Start == -1 ) {
     push( @FileReadIn, "\n#=========\n# $KeyWord\n#=========\n$Value\n");
   } else {
     $End = &LocateNextSection( $Start, @FileReadIn );
     if ( $End == -1 ) {
        $Tmp = join( "\n", @FileReadIn[ $Start .. (@FileReadIn - 1)]);
        $Tmp =~ s/\s*$/\n$Value/;
        @Temp = ( @FileReadIn[ 0 .. ($Start-1)], 
                   $Tmp."\n\n"  );
        @FileReadIn = @Temp;
     } else {
        $Tmp = join( "", @FileReadIn[ $Start .. ($End-1) ] )."\n";
        $Tmp =~ s/\s*$/\n$Value/m;
        @Temp = ( @FileReadIn[ 0 .. ($Start-1)], 
                  $Tmp."\n\n", 
                  @FileReadIn[ $End .. (@FileReadIn - 1) ], "\n" );
        @FileReadIn = @Temp;
     }
   }
   
   seek( PINCONFFILE, 0, 0 );
   print PINCONFFILE @FileReadIn;
   print PINCONFFILE "\n";
   truncate( PINCONFFILE, tell( PINCONFFILE ) );
   close( PINCONFFILE );
   return TRUE; 
}

#=============================================================
#
#  This function comments out a pin.conf entry based on a keyword
#  located 1 line under the #====== comment.
#
#  Arguments:
#    $PinConfFile- pin.cnf file to modify
#    $KeyWord - Keyword to look for for commenting out the entry
#
#  Returns: true 
#=============================================================
sub CommentOutPinConfEntry {
   local( $PinConfFile ) = shift( @_ );
   local( $KeyWord ) = shift( @_ );

   local( @FileReadIn );
   local( @Temp );
   local( $Start );
   local( $End );
   local( $Tmp );

   #
   #  Open the file for in place editing
   #
   open( PINCONFFILE, "+< $PinConfFile" );
   @FileReadIn = <PINCONFFILE>;
   $Start = &LocateEntry( $KeyWord, @FileReadIn );
   if ( $Start == -1 ) {
      return -1;
   } else {
     $End = &LocateNextSection( $Start, @FileReadIn );
     if ( $End == -1 ) {
        $End = @FileReadIn - 1;
     }
     $Tmp = $Start;
     while ( $Tmp < $End ) {
        if ( $FileReadIn[ $Tmp ] !~ /^\#/ ) {
           if ( $FileReadIn[ $Tmp ] =~ /[^\s]+/ ) {
             $FileReadIn[ $Tmp ] = "\#".$FileReadIn[ $Tmp ];
           }
        }
        $Tmp = $Tmp + 1;
     }
   }
   seek( PINCONFFILE, 0, 0 );
   print PINCONFFILE @FileReadIn;
   print PINCONFFILE "\n";
   truncate( PINCONFFILE, tell( PINCONFFILE ) );
   close( PINCONFFILE );
   return TRUE; 
}

#=============================================================
#
#  This function uncomments out a pin.conf entry based on a keyword
#  located 1 line under the #====== comment.
#
#  Arguments:
#    $PinConfFile- pin.cnf file to modify
#    $KeyWord - Keyword to look for for uncommenting out the entry
#
#  Returns: true 
#=============================================================
sub UnCommentOutPinConfEntry {
   local( $PinConfFile ) = shift( @_ );
   local( $KeyWord ) = shift( @_ );

   local( @FileReadIn );
   local( @Temp );
   local( $Start );
   local( $End );
   local( $Tmp );

   #
   #  Open the file for in place editing
   #
   open( PINCONFFILE, "+< $PinConfFile" );
   @FileReadIn = <PINCONFFILE>;
   $Start = &LocateEntry( $KeyWord, @FileReadIn );
   if ( $Start == -1 ) {
      return -1;
   } else {
     $End = &LocateNextSection( $Start, @FileReadIn );
     if ( $End == -1 ) {
        $End = @FileReadIn - 1;
     }
     $Tmp = $Start;
     while ( $Tmp < $End ) {
        if ( $FileReadIn[ $Tmp ] =~ /^\#/ ) {
           if ( $FileReadIn[ $Tmp ] =~ /[^\s]+/ ) {
             $FileReadIn[ $Tmp ] =~ s/^\#//; 
           }
        }
        $Tmp = $Tmp + 1;
     }
   }
   seek( PINCONFFILE, 0, 0 );
   print PINCONFFILE @FileReadIn;
   print PINCONFFILE "\n"; 
   truncate( PINCONFFILE, tell( PINCONFFILE ) );
   close( PINCONFFILE );
   return TRUE; 
}

#=============================================================
#
#  This function adds an array of entries to an existing pin.conf
#
#  Arguments:
#    $PinConfFile- pin.cnf file to modify
#    %Values - Array of entries to use
#
#  Returns: true 
#=============================================================
sub AddPinConfEntries {
   local( $PinConfFile ) = shift( @_ );
   local( %Values ) = @_ ;

   local( @FileReadIn );
   local( @Temp );
   local( $Keyword );
   local( $entry );
   local( $End );
   local( $Tmp );

   foreach $entry (sort keys( %Values ) ) {
     if ( $entry =~ /_description$/i ) {

       open( PINCONFFILE, "$PinConfFile" );
       @FileReadIn = <PINCONFFILE>;
       close( PINCONFFILE );

       $entry =~ s/_description//;
       ($Keyword = $Values{$entry.'_description'} ) =~ s/#=+\s*#\s*//mg;
       $Keyword =~ s/\s+.*//mg;
       $Tmp = &LocateEntry( $Keyword, @FileReadIn );
       if ( $Tmp > -1 ) {
         &AddPinConfEntry( $PinConfFile, $Keyword, $Values{$entry} );

       } else {
         open( PINCONFFILE, "+< $PinConfFile" );
         @FileReadIn = <PINCONFFILE>;
         push( @FileReadIn, "\n\n$Values{$entry.'_description'}$Values{$entry}" );
	 seek( PINCONFFILE, 0, 0 );
         print PINCONFFILE @FileReadIn;
	 print PINCONFFILE "\n";
         truncate( PINCONFFILE, tell( PINCONFFILE ) );
         close( PINCONFFILE );
       }
     }
   }

   return TRUE; 
}
#=============================================================
#
#  This function replaces an array of entries to an existing pin.conf
#
#  Arguments:
#    $PinConfFile- pin.cnf file to modify
#    %Values - Array of entries to use
#
#  Returns: true 
#=============================================================
sub ReplacePinConfEntries {
   local( $PinConfFile ) = shift( @_ );
   local( %Values ) = @_ ;

   local( @FileReadIn );
   local( @Temp );
   local( $Keyword );
   local( $entry );
   local( $End );
   local( $Tmp );

   #Checks for the existence and takes backup of that file.
   if(-e "$PinConfFile") {
     copy($PinConfFile, "$PinConfFile.bak");
   }

   foreach $entry (sort keys( %Values ) ) {
     if ( $entry =~ /_description$/i ) {

       open( PINCONFFILE, "$PinConfFile" );
       @FileReadIn = <PINCONFFILE>;
       close( PINCONFFILE );

       $entry =~ s/_description//;
       ($Keyword = $Values{$entry.'_description'} ) =~ s/#=+\s*#\s*//mg;
       $Keyword =~ s/\s+.*//mg;
       $Tmp = &LocateEntry( $Keyword, @FileReadIn );
       if ( $Tmp > -1 ) {
         &ReplacePinConfEntry( $PinConfFile, $Keyword, $Values{$entry} );

       } else {
         open( PINCONFFILE, "+< $PinConfFile" );
         @FileReadIn = <PINCONFFILE>;
         push( @FileReadIn, "\n\n$Values{$entry.'_description'}$Values{$entry}" );
	 seek( PINCONFFILE, 0, 0 );
         print PINCONFFILE @FileReadIn;
	 print PINCONFFILE "\n";
         truncate( PINCONFFILE, tell( PINCONFFILE ) );
         close( PINCONFFILE );
       }
     }
   }

   return TRUE; 
}
  


#=============================================================
#
#  This function verifies if a "pre script" is present and
#  executes it if it is.
#
#=============================================================
sub pre_configure {
  if ( -e "pin_pre_cmp_$CurrentComponent.pl" ) {
    &Output( fpLogFile, $IDS_PRE_FOUND, $CurrentComponent );
    &Output( STDOUT, $IDS_PRE_FOUND, $CurrentComponent );
    require "pin_pre_cmp_$CurrentComponent.pl";
  }
}

#=============================================================
#
#  This function verifies if a "post script" is present and
#  executes it if it is.
#
#=============================================================
sub post_configure {
  if ( -e "pin_post_cmp_$CurrentComponent.pl" ) {
    &Output( fpLogFile, $IDS_POST_FOUND, $CurrentComponent );
    &Output( STDOUT, $IDS_POST_FOUND, $CurrentComponent );
    require "pin_post_cmp_$CurrentComponent.pl";
  }
  if ( -e "pin_gen_classid_values.pl" ) {
    &Output( fpLogFile, $IDS_CLASSIDS_PL_FOUND);
    &Output( STDOUT, $IDS_CLASSIDS_PL_FOUND);
    require "pin_gen_classid_values.pl";
  }
}
			

#=============================================================
#
#   This function parses a file and reads opcodes/input flists
#   and populates an array with them
#
#   Arguments:
#     $fileName : name of the file to parse
#   Uses :
#     @opcode_list : list of opcode/flags/input flist
#  
#=============================================================
sub parse_execute_opcode_file {
  local ( $fileName ) = @_;
  local ( $flist ); 

  open ( FILE, "<$fileName" ) || die "$ME: Unable to open file '$fileName'";

  while ( $lineRead = <FILE> ) {
    #
    # Skip comment lines and blank lines
    #
    next if ( $lineRead =~ /^\s*#/ );
    next if ( $lineRead =~ /^\s*$/ );

    #
    # if we're reading the line with the opcode
    #
    if ( $lineRead =~ m/\s*<PCM_OP\s+((\s*\$\w+\s*=\s*\$?\w+;?)*)\s*>/ ) {
      # Read the variables and set them (PCM_OP=xxx; PIN_OPFLAGS=xxx)

      eval qq!$1!;

      # Read the whole flist till the next opcode
      $/ = "<\/PCM_OP>";
      $lineRead = <FILE>;
      $lineRead =~ s/<\/PCM_OP>$//;
      $flist = eval "qq!$lineRead!";

      $/ = "\n";

      push( @opcode_list,
      join( ',', $PIN_OPNAME, $PIN_OPFLAGS, $flist ) );
    } else {
      print "Invalid Opcode file !!!\n";
      exit ( 1 );
    }
  }
  close( FILE );
}

#=============================================================
#
#   This function Starts an NT service and returns a known 
#   error (hides the method to start the service)
#
#   Arguments:
#     $ServiceName : name of the Service To Start
#  
#=============================================================
sub StartNTService {
  local ( $ServiceName ) = shift( @_ );
  local ( $Cmd ) = "net start $ServiceName";
  $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", FALSE, $Cmd, "" );
}

#=============================================================
#
#   This function Stops an NT service and returns a known 
#   error (hides the method to stop the service)
#
#   Arguments:
#     $ServiceName : name of the Service To Stop
#  
#=============================================================
sub StopNTService {
  local ( $ServiceName ) = shift( @_ );
  local ( $Cmd ) = "net stop $ServiceName";
  $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", FALSE, $Cmd, "" );
}

#=============================================================
#
#   This function Starts a Unix demon and returns a known 
#   error (hides the method to start the demon)
#
#   Arguments:
#     $DemonName : name of the Demon To Start
#  
#=============================================================
sub StartUnixDemon {
  local ( $DemonName ) = shift( @_ );
  &ExecuteShell( FALSE, "start_$DemonName" );
}

#=============================================================
#
#   This function Stops a Unix demon and returns a known 
#   error (hides the method to Stop the demon)
#
#   Arguments:
#     $DemonName : name of the Demon To Stop
#  
#=============================================================
sub StopUnixDemon {
  local ( $DemonName ) = shift( @_ );
  &ExecuteShell( FALSE, "stop_$DemonName" );
}

#=============================================================
#
#   This function Starts a demon and returns a known 
#   error (hides the OS)
#
#   Arguments:
#     $DemonName : name of the Demon To Start
#  
#=============================================================
sub Start {
  local ( $DemonName ) = shift( @_ );
  if ( $^O =~ /win/i ) {
	&StartNTService( $DemonName );
  } else {
	&StartUnixDemon( $DemonName );
  }
  sleep( 10 );
}

#=============================================================
#
#   This function Stops a demon and returns a known 
#   error (hides the OS)
#
#   Arguments:
#     $DemonName : name of the Demon To Stop
#  
#=============================================================
sub Stop {
  local ( $DemonName ) = shift( @_ );
  if ( $^O =~ /win/i ) {
	&StopNTService( $DemonName );
  } else {
	&StopUnixDemon( $DemonName );
  }
  sleep( 2 );
}

#=============================================================
#
#  This function makes sure the slashes are in the right 
#  direction regardless of the OS
#
#  Arguments:
#    $String : String to verify
#
#  Returns: The corrected value
#
#=============================================================
sub FixSlashes {
  local( $String ) = @_;
  if( $^O =~ /win/i) {
    $String =~ s/\//\\/g;
  }
  $String;
}

#=============================================================
#
#  This function wraps the sleep function and displays dots
#
#  Arguments:
#    $ToOutput : String to output before the dots
#    $TimeLeft : Number of seconds to wait
#
#=============================================================
sub WaitWithDots {
  local( $ToOutput ) = shift( @_ );
  local( $TimeLeft ) = shift( @_ );
  &Output ( STDOUT, $ToOutput, $TimeLeft );
  while( $TimeLeft > 0 ) {
    $TimeLeft = $TimeLeft - 1;
    print ".";
    sleep( 1 );
  }
  print "\n";
}

if ( $^O =~ /win/i ) {
  $LIBRARYEXTENSION = "dll";
  $LIBRARYPREFIX = "";
  $LIBRARYPREFIXVAR = "";
  $EXEEXTENSION = ".exe";
} elsif ( $^O =~ /solaris/i ) {
  $LIBRARYEXTENSION = "so";
  $LIBRARYPREFIX = "lib";
  $LIBRARYPREFIXVAR = "\$\{LIBRARYPREFIX\}";
  $EXEEXTENSION = "";
} elsif ( $^O =~ /aix/i ) {
  $LIBRARYEXTENSION = "a";
  $LIBRARYPREFIX = "lib";
  $LIBRARYPREFIXVAR = "\$\{LIBRARYPREFIX\}";
  $EXEEXTENSION = "";
} elsif( $^O =~ /hpux/i && `(/bin/uname -m ) 2>/dev/null` =~ /ia64/i ){
  $LIBRARYEXTENSION = "so";
  $LIBRARYPREFIX = "lib";
  $LIBRARYPREFIXVAR = "\$\{LIBRARYPREFIX\}";
  $EXEEXTENSION = "";
} elsif( $^O =~ /hpux/i ){
  $LIBRARYEXTENSION = "sl";
  $LIBRARYPREFIX = "lib";
  $LIBRARYPREFIXVAR = "\$\{LIBRARYPREFIX\}";
  $EXEEXTENSION = "";
} else {
  $LIBRARYEXTENSION = "so";
  $LIBRARYPREFIX = "lib";
  $LIBRARYPREFIXVAR = "\$\{LIBRARYPREFIX\}";
  $EXEEXTENSION = "";
}


#=============================================================
#
#  This function wraps the pin_setup.values to simplify 
#  multi_user installation
#
#  Arguments:
#    $SourceFileName : Source name of the pin_setup.values
#    $DestFileName : Name to use for the stub file
#
#=============================================================
sub GenerateStubFile {
  local( $SourceFileName ) = shift( @_ );
  local( $DestFileName ) = shift( @_ );
  local( $Ignore ) = 0;

  if ( !open( STUB_SOURCE, "< $SourceFileName" )) {
    # Really shouldn't happen !!!
    &Output( STDERR, $IDS_FILE_NOT_FOUND, $SourceFileName );
    exit( 1 );
  }
  if ( !open( STUB_DEST, "> $DestFileName" )) {
    &Output( STDERR, $IDS_UNABLE_TO_OPEN, $DestFileName );
    exit( 1 );
  }
  $Ignore=0;
  while ( $read = <STUB_SOURCE> ) {
    if ( $read =~ /\#\/\*/g ) {
      $Ignore=1;
    }
    if ( $Ignore == 0 ) {
      if ( $read =~ /^\s*(\$)([^=]*)=(.*)/ ) {
	$Prefix = $1;
	$Suffix = $2;
	$String = $2;
        $Value = $3;
	$String =~ s/(\{|\'|\})/_/g;
	$String =~ s/\s//g;
	print STUB_DEST "if ( \$ENV\{\'PIN_$String\'\} \!~ /^\$/ ) \{ \n";
	print STUB_DEST "\t$Prefix$Suffix= \$ENV\{\'PIN_$String\'\};\n";
        print STUB_DEST "} else {\n";
        print STUB_DEST "\t$Prefix$Suffix= $Value\n}\n";
      } else {
        print STUB_DEST $read;
      }
    }
    if ( $read =~ /\#\*\//g ) {
      $Ignore=0;
    }
  }	
  print STUB_DEST "1;\n";
  close( STUB_SOURCE );
  close( STUB_DEST );
  chmod( 0777, $DestFileName );
}


#=============================================================
#
#  This function prepares the environment for calling pin_init
#  and other functions, in order to update the Portal database
#  during Optional Product installs.
#  NOTE:  After calling pin_init and related functions,
#         PostModularConfigureDatabase should be called.
#
#  Arguments:
#    $CM : Current CM
#    $DM : Current DM
#
#=============================================================
sub PreModularConfigureDatabase {

  local( $CM ) = shift( @_ );
  local( $DM ) = shift( @_ );

  # If the CM is running, then stop it !
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    &Stop( $ServiceName{ "cm" } );
    sleep ( 10 );
  }

  # If the DM is running, then stop it !
  if ( -f $DM{'location'}."/".$PINCONF )
  {
    &Stop( $ServiceName{ "dm_$MAIN_DM{'db'}->{'vendor'}" } );
    sleep ( 10 );

    #
    # Make sure everything is writeable
    #
    &ReplacePinConfEntry( $DM{'location'}."/".$PINCONF, 
			"dd_write_enable_fields",
			"- dm dd_write_enable_fields 1" );
    &ReplacePinConfEntry( $DM{'location'}."/".$PINCONF, 
			"dd_write_enable_objects",
			"- dm dd_write_enable_objects 1" );
    &ReplacePinConfEntry( $DM{'location'}."/".$PINCONF, 
			"dd_write_enable_portal_objects",
			"- dm dd_write_enable_portal_objects 1" );
  }

}


#=============================================================
#
#  This function returns the environment to its original state,
#  after calling pin_init and other functions which update the
#  Portal database during Optional Product installs.
#  NOTE:  This function assumes that
#         PreModularConfigureDatabase was called earlier.
#
#  Arguments:
#    $CM : Current CM
#    $DM : Current DM
#
#=============================================================
sub PostModularConfigureDatabase {

  local( $CM ) = shift( @_ );
  local( $DM ) = shift( @_ );

  if ( -f $DM{'location'}."/".$PINCONF )
  {
    #
    # Make sure everything is back to normal
    #
    &ReplacePinConfEntry( $DM{'location'}."/".$PINCONF, 
			"dd_write_enable_fields",
			"- dm dd_write_enable_fields $DM{'enable_write_fields'}" );
    &ReplacePinConfEntry( $DM{'location'}."/".$PINCONF, 
			"dd_write_enable_objects",
			"- dm dd_write_enable_objects $DM{'enable_write_objects'}" );
    &ReplacePinConfEntry( $DM{'location'}."/".$PINCONF, 
			"dd_write_enable_portal_objects",
			"- dm dd_write_enable_portal_objects $DM{'enable_write_portal_objects'}" );


    sleep ( 10 );
    &Start ( $ServiceName{'dm_'.$DM{'db'}->{'vendor'}} );
    sleep ( 10 );
  }

  if ( -f $CM{'location'}."/".$PINCONF )
  {
    &Start( $ServiceName{ "cm" } );
    sleep( 20 );
  }

}


#=============================================================
#
#  This function calls functions which configure components.
#  It is called when 'pin_cmp_*' files are run independently.
#
#  Arguments:
#    $SourceFileName : Name of the calling 'pin_cmp_*' file.
#
#=============================================================
sub ConfigureComponentCalledSeparately {
  local( $SourceFileName ) = shift( @_ );

  ($ME = $SourceFileName) =~ s/.*\///;
  $ME =~ s/.*\\//;
  ($CurrentComponent = $ME) =~ s/pin_cmp_(.*)\.pl/$1/;

   &OpenLogFile( $SETUP_LOG_FILENAME, "APPEND" );
   #
   # If the pre-configure script is there, run it.
   #
   &pre_configure;

   $skip = eval '$setup_execute_pin_cmp_'.$CurrentComponent;

   if ( $skip eq TRUE ) {
      &Output( fpLogFile, $IDS_SCRIPT_SKIPPED, "pin_cmp_$CurrentComponent.pl" );
      &Output( STDOUT, $IDS_SCRIPT_SKIPPED, "pin_cmp_$CurrentComponent.pl" );
   } else {

      # Make sure the component is stopped
      if ( $ServiceName{ $CurrentComponent } !~ /^$/ ) {
          &Stop( $ServiceName{ $CurrentComponent } );
      }

      #
      # Call any functions for configure_$CurrentComponent_* which are defined
      #
      $function_name = "configure_$CurrentComponent"."_config_files";
      if ( ( $SETUP_CONFIGURE =~ /^YES$/i ) &&
           ( defined ( &$function_name ) ) ) {
         eval "&configure_$CurrentComponent"."_config_files;";
      }
      $function_name = "configure_$CurrentComponent"."_database";
      if ( ( $SETUP_INIT_DB =~ /^YES$/i ) &&
           ( defined( &$function_name ) ) ) {
         &Output( STDOUT, $IDS_CONFIGURING_DATABASE, $CurrentComponent );
         &Output( fpLogFile, $IDS_CONFIGURING_DATABASE, $CurrentComponent );
         eval '&configure_'.$CurrentComponent.'_database;';
      }

      # Make sure the service is restarted
      if ( $ServiceName{ $CurrentComponent } !~ /^$/ ) {
          &Stop  ( $ServiceName{ $CurrentComponent } );
          &Start ( $ServiceName{ $CurrentComponent } );
      }

      $function_name = "configure_$CurrentComponent"."_post_restart";
      if ( ( $SETUP_INIT_DB =~ /^YES$/i ) && 
	   ( defined( &$function_name ) ) ) {
         eval '&configure_'.$CurrentComponent.'_post_restart;';
      }
      #
      # Do any final configuration for all components
      #
      $function_name = "configure_$CurrentComponent"."_post_configure";
      if ( defined( &$function_name ) ) {
         eval '&configure_'.$CurrentComponent.'_post_configure;';
      }
   }
   #
   # If there is a post-install script there, run it
   #
   &post_configure;

}

#########################
# This function updates the pin_ctl.conf port tag file with deamon/service port
#########################
sub ReplacePinCtlConfEntries
{
    local( $PinConfFile ) = shift( @_ );
    local( $KeyWord ) = shift( @_ );
    local( $Value ) = shift( @_ );
    my @TMP_ARRAY = ();
  
  	        open( BATCHFILE, "$PinConfFile" );
  	  
  	   	while ( <BATCHFILE> ){	   	
  	   	      
  	   	      $_ =~ s/$KeyWord/$Value/;
  		      push(@TMP_ARRAY,$_);		      
  		}
  		
  		close( BATCHFILE );
  		open( BATCHFILE, ">$PinConfFile" );
  		print BATCHFILE @TMP_ARRAY;		
  		print BATCHFILE "\n";		
		close( BATCHFILE );	
}

#########################
# This function generates $PIN_HOME/apps/multidb/config_dist.conf.
#########################
sub ConfigDist
{
   local $CONFIGDIST = $MULTI_DB{'pin_cnf_location'}."/".$CONFIGDISTCONF;
   if ( -f $CONFIGDIST ) {
     $CONFIGDIST = "$CONFIGDIST.$CONFIGDISTEXT";
     # if the file already exists, it does not change it and makes a raw version for
     # users references
   }

   print STDOUT "Generating $CONFIGDIST\n";
   open(CONFILE, ">> $CONFIGDIST") || die("Can not open $CONFIGDIST");
   print CONFILE $MULTIDB_CONFIGDIST_HEADER;
   print CONFILE "\n\n";
   print CONFILE $MULTIDB_CONFIGDIST_ENTRIES;
   close(CONFILE);
   chmod(0644, $CONFIGDIST);
}

#=============================================================
#  Need to return for "require" statement
#=============================================================
1;
