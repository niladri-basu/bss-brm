##!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=======================================================================
#  @(#)%Portal Version: pin_prompts.pl:PortalBase7.2PatchInt:1:2005-Aug-31 20:10:33 %
# 
# Copyright (c) 1999, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#	Main Perl script to display install prompts.
#
#=============================================================

local ( $PinSetupValues ) = "../pin_setup.values";
local ( $PinPromptsValues ) = "pin_prompts.values";  # Contains text and other details on all of the prompts
local ( $NewEntriesFile ) = "./new_entries";         # Temp file containing new entries for pin_setup.values

require "pin_res.pl";
require "pin_functions.pl";
require "$PinSetupValues";
require "$PinPromptsValues";


local ( $i );
local ( $j );
local ( $k );
local ( $ReviewEntries );            # User's choice whether to review entries, either 'y' or 'n'
local ( $EvenPrompts ) = 'yes';      # Set this to 'yes' to display evenly spaced prompts
local ( $BracketDefaults ) = 'yes';  # Set this to 'yes' to surround default values in brackets
local ( $AddNewDirectory );          # User's choice whether to create a directory, either 'y' or 'n'
local ( @NewDirectories ) = ();      # List of new directories entered by the user.
local ( @ArrayPrompt );              # Indexed array containing the sorted prompts for $CurrentComponent
local ( $CurrentPrompt );            # The current entry in @ArrayPrompt.  ie, '_2_PROMPT_user'
local ( $CurrentVar );               # The variable portion of $CurrentPrompt.  ie, 'user' from '_2_PROMPT_user'
local ( $CurrentPri );               # The priority of $CurrentPrompt.  ie, '2' from '_2_PROMPT_user'
local ( $CurrentTag );               # The type of $CurrentPrompt.  ie, 'PROMPT' from '_2_PROMPT_user'
local ( $CurrentValue );             # The value of $CurrentVar, from pin_setup.values.
local ( $NewValue );                 # The value entered by the user (default = $CurrentValue) when prompted.
local ( $CurrentComponent );         # The current entry in @ArrayComponent (which is from @COMPONENT_LIST).
local ( $CurrentComponentAlias );    # The current entry in %ComponentAlias.  Contains 'keyword tags' used in pin_setup.values.
local ( $CurrentComponentHeader );   # The current entry in %ComponentHeader.  This is the header text to display for each component.
local ( $PromptText );               # The actual text of the current prompt
local ( $InRange );                  # Is the current value entered within the range ?  ( 'YES' or 'NO' )
local ( $SkipPrompt );               # Should the current prompt be skipped ?  ( 'YES' or 'NO' )
local ( $HidePrompt );               # From %{%Prompts{}} in $PinPromptsValues.  ie, 'HIDEPROMPT_system_user'
local ( $HidePromptText );           # From %{%Prompts{}} in $PinPromptsValues.  ie, 'CREATE_DATABASE_TABLES NO'
local ( $HidePromptList );           # List containing the contents of $HidePromptText
local ( $HidePromptVar );            # $HidePromptList[0]  ie: 'CREATE_DATABASE_TABLES'
local ( $HidePromptVal );            # $HidePromptList[1]  ie: 'NO'
local ( $IndexPrompt );              # Index of the current prompt, for the current component.
local ( $DebugOn ) = "NO";           # Set this to 'YES' to display debug messages

#
# The following variables defined in $PinPromptsValues :
#
# @ArrayComponent                    # Indexed array containing @COMPONENT_LIST (reversed)
# %ComponentAlias                    # Hashed array containing tags used in pin_setup.values
# %ComponentHeader                   # Hashed array containing text to display for each component
#


unlink ( $NewEntriesFile );  # Remove this file if it currently exists


#
# Text to display once when starting this script.
#
$myHeader = <<END

****************************************************************
                    Portal Installation

Please make any necessary changes to the current values shown.
To choose the [ default ] Current Value, just press ENTER.
Note:  Enter b to move back to the previous prompt, at any time.
****************************************************************

END
;

&Output( STDOUT, $myHeader );


#
# Display the complete group of prompts,
# and keep displaying all of these prompts,
# until the user chooses NOT to review the entries.
#
$ReviewEntries = "y";

$ArrayComponentString = join ' ', @ArrayComponent;
if ( $MAIN_DB{'vendor'} =~ /db2/i )
{
	$ArrayComponentString =~ s/dm_oracle//;
	if ( $ArrayComponentString !~ /dm_db2/i )
	{
		$ArrayComponentString =~ s/db1/db1 dm_db2/;
	}
}
# elsif ( $MAIN_DB{'vendor'} == "oracle" )
elsif ( $MAIN_DB{'vendor'} =~ /oracle/i )
{
	$ArrayComponentString =~ s/dm_db2//;
	if ( $ArrayComponentString !~ /dm_oracle/i )
	{
		$ArrayComponentString =~ s/db1/db1 dm_oracle/;
	}
}

while ( $ReviewEntries =~ /^y$/i )
{
	#
	# Display a formatted header if $EvenPrompts == 'yes'
	#
	if ( $EvenPrompts =~ /^yes$/i )
	{
		&Output( STDOUT, "\n                                              Current Value" );
	}

	#
	# Loop through all of the Components in @ArrayComponent,
	# which was generated from @COMPONENT_LIST in pin_setup.values.
	# Display all of the prompts for $CurrentComponent.
	# These prompts (defined in $PinPromptsValues)
	# will first be sorted numerically (ie, _1_*, _2_*, etc.
	#
	for ( $IndexComponent = 0; $IndexComponent < scalar ( @ArrayComponent ); $IndexComponent++ )
	{
		@ArrayComponent = split ' ', $ArrayComponentString;

 		@ArrayPrompt = ();

		$CurrentComponent = $ArrayComponent[$IndexComponent];
		&DebugOutput( STDOUT, "ArrayComponent=[@ArrayComponent]\n" );
		&DebugOutput( STDOUT, "CurrentComponent=[$CurrentComponent]  IndexComponent=[$IndexComponent]\n" );

		$CurrentComponentAlias = $ComponentAlias{$CurrentComponent};
		$CurrentComponentHeader = $ComponentHeader{$CurrentComponent};
		&DebugOutput( STDOUT, "\$CurrentComponentAlias = [%s]\n", $CurrentComponentAlias );

		if ( $CurrentComponentHeader )
		{
			&Output( STDOUT, "\n[ $CurrentComponentHeader ]\n" );
		}

		#
		# Look at all %Prompts entries for $CurrentComponent.
		# Sort the prompts numerically, ie, _1_PROMPT_*, _2_PROMPT_*, etc.,
		# and build the @ArrayPrompt array.
		#
		$i = 0;
		foreach $CurrentPrompt ( sort ( %{$Prompts{$CurrentComponent}} ) )
		{
			$ArrayPrompt[$i++] = $CurrentPrompt;
		}

		#
		# Loop through all of the prompts for $CurrentComponent.
		# Set values for $CurrentVar, $CurrentValue, $CurrentText,
		# and then use these to prompt the user for input (&PromptUser).
		#
		for ( $IndexPrompt = 0; $IndexPrompt < scalar ( @ArrayPrompt ); $IndexPrompt++ )
		{

# The Prompt: tag is only used when the user chooses to go back to previous prompt #
Prompt:

			$CurrentPrompt = $ArrayPrompt[$IndexPrompt];  # ie, '_2_PROMPT_user'
			&DebugOutput( STDOUT, "IndexP=[$IndexPrompt]  IndexC=[$IndexComponent]  CurrentP=[$CurrentPrompt]\n" );

			#
			# Only display the "main prompts", which are in the format _<INTEGER>_<STRING>_*
			# All other prompts only provide additional information on these "main prompts".
			#
			if ( $CurrentPrompt =~ /^_[0-9]+_[A-Z]+_/ )
			{
				($CurrentTag = $CurrentPrompt) =~ s/_[0-9]+_([A-Z]+)_.*/$1/;         # ie, 'PROMPT' from '_2_PROMPT_user'
				($CurrentVar = $CurrentPrompt) =~ s/_[0-9]+_($CurrentTag)_/$2/;      # Variable used in pin_setup.values.  ie, 'user' from '_2_PROMPT_user'
				($CurrentPri = $CurrentPrompt) =~ s/_([0-9]+)_($CurrentTag)_.*/$1/;  # Priority of CurrentPrompt.  ie, '2' from '_2_PROMPT_user'


				#
				# We dont want to set default value for SETUP_CREATE_PARTITIONS. 
				# User needs to know what they select.
				#
				if ( $CurrentVar =~ /^SETUP_CREATE_PARTITIONS$/ )
				{	
					$CurrentValue = "";
				} else {
					#
					# Look up $CurrentValue in pin_setup.values
					#
					if ( $CurrentTag =~ /^PROMPT$/ )
					{
						$CurrentValue = ${$CurrentComponentAlias}{$CurrentVar};
					}
					elsif ( ( $CurrentTag =~ /^PROMPTBASE$/ ) || ( $CurrentTag =~ /^YESNO$/ ) )
					{
						$CurrentValue = ${$CurrentVar};
					}
				}

				#
				# Set the text to be displayed to the user.
				#
				$PromptText   = ${$Prompts{$CurrentComponent}}{$CurrentPrompt};

				&DebugOutput( STDOUT, "Tag=[$CurrentTag]  Var=[$CurrentVar]  Pri=[$CurrentPri]  Value=[$CurrentValue]  CurrentComponentAlias=[$CurrentComponentAlias]  CurrentPrompt=[$CurrentPrompt]\n" );

				#
				# If a 'HIDEPROMPT' entry exists, compare the 2 strings it contains.
				# If they match OR what they evaluate to matches, then SKIP this prompt.
				# The 'HIDEPROMPT' entries are defined in $PinPromptsValues.
				#
				# For example, if the 'HIDEPROMPT' entry = 'CREATE_DATABASE_TABLES NO', and if either
				# 'CREATE_DATABASE_TABLES' == 'NO' OR '$CREATE_DATABASE_TABLES' == 'NO', then SKIP this prompt.
				#
				$SkipPrompt = "NO";
				$HidePrompt = "HIDEPROMPT_$CurrentVar";  # ie: 'HIDEPROMPT_system_user'
				$HidePromptText = ${$Prompts{$CurrentComponent}}{$HidePrompt};  # ie: 'CREATE_DATABASE_TABLES NO'
				if ( $HidePromptText !~ /^$/ )
				{
					@HidePromptList = split ' ', $HidePromptText;
					$HidePromptVar = $HidePromptList[0];
					$HidePromptVal = $HidePromptList[1];
					if ( ( ${$HidePromptVar} =~ /$HidePromptVal/i ) || ( $HidePromptVar =~ /$HidePromptVal/i ) )
					{
						$SkipPrompt = "YES";
					}
				}
				$InRange = "NO";

				#
				# Loop to continue displaying the current user prompt, while not in range.
				#
				while ( $InRange =~ /NO/i )
				{
					$result = &DisplayThisPrompt;
					if ( $result =~ /^prev$/i )
					{
						goto Prompt;
					}
					$InRange  = &CheckRange ( $CurrentPrompt, $CurrentVar );
				}

				if ( $CurrentVar =~ /^vendor$/ )
				{
					#
					# Split the array so as to remove dm_oracle or dm_db2 based on user input
					#
					$ArrayComponentString = join ' ', @ArrayComponent;

					if ( $NewValue =~ /oracle/i )
					{
						if ( $ArrayComponentString =~ /dm_db2/i )
						{
							$ArrayComponentString =~ s/dm_db2/dm_oracle/;
						}
					}
					elsif ( $NewValue =~ /db2/i )
					{
						if ( $ArrayComponentString =~ /dm_oracle/i )
                                               {
                                                        $ArrayComponentString =~ s/dm_oracle/dm_db2/;
                                                }
						# Set values for hiding prompts
						$HIDE_STORAGE_MODEL_PROMPT = "YES";
						$HIDE_CREATE_PARTITIONS_PROMPT = "YES";
						$ENABLE_PARTITION = "NO";
					}
					#
					# Generate the UPDATED @ArrayComponent list.
					#
					@ArrayComponent = split ' ', $ArrayComponentString;
				}

				if ( $CurrentVar =~ /^cdk_protocol$/ )
				{
					#
					# Check the value to display appropriate prompts.
					#
					if ( $NewValue =~ /pcp/i ) 
					{
						$CDK_PROTOCOL = "PCP";
					} 
					else 
					{
						$CDK_PROTOCOL = "HTTP";
					}
				}
					
				#
				# Only update NewEntriesFile if this prompt was not skipped.
				#
				if ( $SkipPrompt =~ /NO/i )
				{
					open( TEMPFILE, ">> $NewEntriesFile" );
					if ( $CurrentTag =~ /^PROMPT$/ )
					{
						print ( TEMPFILE "\$$CurrentComponentAlias\{\'$CurrentVar\'\} = \"$NewValue\"\;\n" );
						eval "\$$CurrentComponentAlias\{\'$CurrentVar\'\} = \"$NewValue\"";
					}
					elsif ( ( $CurrentTag =~ /^PROMPTBASE$/ ) || ( $CurrentTag =~ /^YESNO$/ ) )
					{
						print ( TEMPFILE "\$$CurrentVar = \"$NewValue\"\;\n" );
						eval "\$$CurrentVar = \"$NewValue\"";
					}
					close( TEMPFILE );
					&DebugOutput( STDOUT, "\nrequire NewEntriesFile" );
				}
			}
		}
	}

	# Re-read $NewEntriesFile, so that the current entries are in memory #
	eval qq!require "$NewEntriesFile"!;

	print STDOUT "\n\n";
	do
	{
		print STDOUT "Do you want to review the above entries ?  (y/n)  ";
		$ReviewEntries = <STDIN>;
	}
	while ( $ReviewEntries !~ /^\s*[yn]\s*$/i );
}


&UpdatePinSetupValues ( $PinSetupValues, $NewEntriesFile );

unlink ( $NewEntriesFile );  # Remove this file




#=============================================================
#
# This function updates 'pin_setup.values' with the current values.
# It also update the COMPONENTS variable in 'Portal_Base.prod' (which lists
# the Portal core server components) with the correct database component.
#
# Arguments:
#   $PinSetupValues   - Full pathname of 'pin_setup.values'.
#   $NewEntriesFile   - File containing the new entries.
#
#=============================================================
sub UpdatePinSetupValues
{
	local ( $PinSetupValues ) = shift ( @_ );
	local ( $NewEntriesFile ) = @_;
	local ( $PortalProd ) = "../../../../Portal_Base.prod";
        local ( $InvoiceDMComp) = "../../../../comps/Invoice_DM.comp";
	local ( $i );
	local ( $j );
	local ( $k );
	local ( $Left );
	local ( $LeftOrig );
	local ( @Array_NEW );
	local ( @Array_PROD );
	local ( @Array_VALUES );
	local ( @Array_COMP );
	
	&Output( STDOUT, "\nUpdating $PinSetupValues ... " );

	$j = 0;
	open( NEWFILE, "$NewEntriesFile" ) || die( "Can't open $NewEntriesFile" );
	@Array_NEW = <NEWFILE>;
	seek( NEWFILE, 0, 0 );
	while ( <NEWFILE> )
	{
		$j++;
	}
	close( NEWFILE );

	$i = 0;
	open( VALUESFILE, "+< $PinSetupValues" ) || die( "Can't open $PinSetupValues" );
	@Array_VALUES = <VALUESFILE>;
	seek( VALUESFILE, 0, 0 );
	while ( <VALUESFILE> )
	{
		$k = 0;
		# Loop through each line in $NewEntriesFile
		while ( $k < $j )
		{
			$Line = $Array_NEW[$k++];
			if ( ( $_ =~ /.+=.+/ ) && ( $Line =~ /.+=.+/ ) )
			{
				($Left = $Line) =~ s/(\s)+.*$/$1/;   # SET $Left EQUAL TO (LEFT OF 1ST WHITESPACE) IN $Line
				($LeftOrig = $_) =~ s/(\s)+.*$/$1/;  # SET $LeftOrig EQUAL TO (LEFT OF 1ST WHITESPACE) IN $Line

				$Left =~ s/\s*//g;
				$LeftOrig =~ s/\s*//g;

				if ( $LeftOrig eq $Left )
				{
					$_ = "$Line";
				}
			}
		}
		$Array_VALUES[$i++] = $_;
	}

	seek( VALUESFILE, 0, 0 );
	print VALUESFILE @Array_VALUES;
	print VALUESFILE "\n";
	truncate( VALUESFILE, tell( VALUESFILE ) );
	close( VALUESFILE );

	#
	# Update the "Portal_Base.prod" file if it exists.
	# If MAIN_DB == 'db2', then remove the 'Oracle_DM' component and add 'DB2_DM' if it is missing.
	# If MAIN_DB == 'oracle', then remove the 'DB2_DM' component and add 'Oracle_DM' if it is missing.
	#
	if ( -f $PortalProd )
	{
		$i = 0;
		open( PRODFILE, "+< $PortalProd" ) || die( "Can't open $PortalProd" );
		seek( PRODFILE, 0, 0 );
		while ( <PRODFILE> )
		{
			if ( $_ =~ /^COMPONENTS=/ )
			{
				if ( $MAIN_DB{'vendor'} =~ /db2/i )
				{
					if ( $_ !~ / DB2_DM / )
					{
						$_ =~ s/ CM / DB2_DM CM /;
					}
					$_ =~ s/ Oracle_DM / /;
				}
				elsif ( $MAIN_DB{'vendor'} =~ /oracle/i )
				{
					if ( $_ !~ / Oracle_DM / )
					{
						$_ =~ s/ CM / Oracle_DM CM /;
					}
					$_ =~ s/ DB2_DM / /;
				}
			}
			$Array_PROD[$i++] = $_;
		}
		seek( PRODFILE, 0, 0 );
		print PRODFILE @Array_PROD;
		truncate( PRODFILE, tell( PRODFILE ) );
		close( PRODFILE );
	}

	#
	# Update the "Invoice_DM.comp" file if it exists.
	# If MAIN_DB == 'db2', then remove the 'dm_oracle_-_Program_Files' Filegroup.
	# If MAIN_DB == 'oracle', then remove the 'dm_db2_-_Program_Files' Filegroup.
	#
	if ( -f $InvoiceDMComp )
	{
		$i = 0;
		open( COMPFILE, "+< $InvoiceDMComp" ) || die( "Can't open $InvoiceDMComp" );
		seek( COMPFILE, 0, 0 );
		while ( <COMPFILE> )
		{
			if ( $_ =~ /^FILE_GROUPS=/ )
			{
				if ( $MAIN_DB{'vendor'} =~ /db2/i )
				{
					$_ =~ s/\sdm_oracle_-_Program_Files\s/ /;
				}
				elsif ( $MAIN_DB{'vendor'} =~ /oracle/i )
				{
					$_ =~ s/\sdm_db2_-_Program_Files\s/ /;
				}
			}
			$Array_COMP[$i++] = $_;
		}
		seek( COMPFILE, 0, 0 );
		print COMPFILE @Array_COMP;
		truncate( COMPFILE, tell( COMPFILE ) );
		close( COMPFILE );
	}

	&Output( STDOUT, "done.\n\n" );  # Finished updating $PinSetupValues #

}


#=============================================================
#
# Function to display the current prompt, and check the value entered.
#
# If the prompt is not 'hidden', then call PromptUser to display this prompt.
# If 'b' is entered, or was entered previously, then prepare to display
# the previous prompt # by resetting the following variables:
#   $IndexComponent  $IndexPrompt  @ArrayPrompt
#   $CurrentComponent  $CurrentComponentAlias  $CurrentComponentHeader
#
# Returns : 'prev'  if the user chooses to go to the PREVIOUS prompt
#           '0'     if PREVIOUS was not chosen
#
#=============================================================
sub DisplayThisPrompt
{

	if ( $SkipPrompt !~ /YES/i )
	{
		if ( $CurrentVar =~ /^SETUP_CREATE_PARTITIONS$/ )
		{
			print( STDOUT "\nIMPORTANT Enter one of these values after the next question:\nYes - Portal will automatically add 12 monthly partitions to your event tables.\nNo - After installing Portal but BEFORE generating any events, you must add custom partitions to your database.\n" );
		}
		#
		# Prompt the user, and set $NewValue to the result.
		#
		$NewValue = &PromptUser ( $CurrentValue, $PromptText );
	}

	#
	# Go back to the previous prompt, if the user enters 'b'.
	#
	if ( $NewValue =~ /^\s*[bB]\s*$/ )
	{
		&DebugOutput( STDOUT, "BACK0:  IndexP=[$IndexPrompt]  IndexC=[$IndexComponent]  CurrentP=[$CurrentPrompt]\n" );
		# if ( $CurrentPrompt =~ /^_1_.*/ )
		if ( $CurrentPrompt =~ /^_[0]*1_.*/ )
		{
			# User is at the 1st prompt of the current component.
			if ( $IndexComponent == 0 )
			{
				# User is at the 1st prompt of the 1st component.
				print STDOUT "  Cannot choose BACK here\n";
				return ( 'prev' );  # goto Prompt:
			}
			else
			{
				do
				{
					# Change index to point to the previous component.
					$IndexComponent--;
					$CurrentComponent = $ArrayComponent[$IndexComponent];
					&DebugOutput( STDOUT, "BACK:  \$IndexC=[$IndexComponent]  \$CurrentC=[$CurrentComponent]\n");
				}
				while ( ! %{$Prompts{$CurrentComponent}} );

				$CurrentComponent = $ArrayComponent[$IndexComponent];
				$CurrentComponentAlias = $ComponentAlias{$CurrentComponent};
				$CurrentComponentHeader = $ComponentHeader{$CurrentComponent};
				&DebugOutput( STDOUT, "GOING BACK ONE COMPONENT:  \$CurrentComponentAlias = [%s]\n", $CurrentComponentAlias );
				&Output( STDOUT, "\n[ $CurrentComponentHeader ]\n" );
 				@ArrayPrompt = ();
				$i = 0;
				foreach $CurrentPrompt ( sort ( %{$Prompts{$CurrentComponent}} ) )
				{
					$ArrayPrompt[$i++] = $CurrentPrompt;
					$temp = $ArrayPrompt[$i - 1];
					&DebugOutput( STDOUT, "BACK1:  \$ArrayP[%s]=[$temp]\n", $i - 1);
				}
				for ( $IndexPrompt = scalar ( @ArrayPrompt ) - 1; $ArrayPrompt[$IndexPrompt] !~ /^_[0-9]+_.+/ ; $IndexPrompt-- )
				{
					$temp = $ArrayPrompt[$IndexPrompt];
					&DebugOutput( STDOUT, "BACK2:  \$ArrayP[%s]=[$temp]\n", $IndexPrompt);
					&DebugOutput ( 'pause' );
				}
				&DebugOutput( STDOUT, "BACK3:  \$IndexP=[$IndexPrompt]\n" );
				return ( 'prev' );  # goto Prompt:
			}
		}
		else
		{
			$IndexPrompt--;
			return ( 'prev' );  # goto Prompt:
		}
	}
	return ( 0 );
}


#=============================================================
#
# Function to display a prompt and then return the value entered.
#
# Arguments:
#  $Value          - The currrent (default) value, for example "11960"
#  $PromptText     - Text of the current prompt,   for example "Enter the CM port:"
#
#=============================================================
sub PromptUser
{
	local( $Value ) = shift( @_ );
	local( $PromptText ) = @_;
	local( $Input );
	local( $TotalSpaces ) = 46;  # Number of spaces from left of screen to the default values
	local( $Spaces ) = "  ";     # How many spaces between each prompt and the default value
	local( $BracketStart ) = "";
	local( $BracketEnd ) = "";

	if ( $BracketDefaults =~ /^yes$/i )
	{
		$BracketStart = "[ ";
		$BracketEnd = " ]";
		$TotalSpaces = $TotalSpaces - 2;
	}
	if ( $EvenPrompts =~ /^yes$/i )
	{
		if ( length ( $PromptText )  < $TotalSpaces - 1 )
		{
			$Spaces = ' ' x ( $TotalSpaces - length ( $PromptText ) );
		}
	}

	&Output ( STDOUT, "%s$Spaces$BracketStart%s$BracketEnd  ", $PromptText, $Value );
	$Input = <STDIN>;
	chomp ($Input);
	if ( $Input =~ /^(\s)*(.)+/ )
	{
		($Value = $Input) =~ s/^(\s)*/$1/;  # STRIP LEADING WHITESPACES FROM $Input
	}

	if ( $CurrentPrompt =~ /^_[0-9]+_YESNO_/ )
	{
		# Convert 'y' to 'YES' and 'n' to 'NO' if this is a YESNO prompt.
		$Value =~ s/^y$/YES/i;
		$Value =~ s/^n$/NO/i;
	}

	return ( $Value );
}


#=============================================================
#
#  This function checks the range of a given entry input by the user.
#
#  Arguments	: 
#    $CurrentPrompt   ie: 'PROMPT_port'
#    $CurrentVar      ie: 'port' if $CurrentPrompt = 'PROMPT_port'
#    $Value           ie: '11960' from $MAIN_CM{'port'} in pin_setup.values
#
#  Possible entries in $PinPromptsValues
#  (either a keyword such as 'port', or else a list of acceptable values) :
#	 "RANGE_port",        "port"
#	 "RANGE_sm_charset",  "UTF8 AL32UTF8"
#
#  Returns : 'yes'  if within the range,
#            'no'   if outside of the range,
#            ''     if range is not defined.
#
#=============================================================
sub CheckRange
{

	local( $CurrentPrompt ) = shift ( @_ );
	local( $CurrentVar ) = shift ( @_ );
	local( $Value ) = $NewValue;
	local( @Range );
	local( $RangeText );
	local( $RangeValue );
	local( $RangePrompt ) = "RANGE_$CurrentVar";  # ie: 'RANGE_port'

	if ( $SkipPrompt =~ /YES/i )
	{
		return ( 'yes' );
	}

	$RangeText = ${$Prompts{$CurrentComponent}}{$RangePrompt};
	if ( $CurrentPrompt =~ /^_[0-9]+_YESNO_/ )
	{
		@Range = ( 'YES', 'NO' );
		$RangeText = "YES or NO";
	}
	elsif ( $RangeText =~ /[a-zA-Z]+/ )
	{
		if ( $RangeText eq 'port' )
		{
			@Range = ( 1000, 999999 );
		}
		elsif ( $RangeText eq 'full_pathname' )
		{
			# Make sure the first non-whitespace character entered is a forward slash,
			# and also that there are no whitespaces within the pathname.
			if ( ( $Value =~ /^\s*\// ) && ( $Value !~ /\S+\s+\S/ ) )
			{
				if ( -d $Value )
				{
					# OK, since this is a directory which already exists.
					return ( 'yes' );
				}
				elsif ( -f $Value )
				{
					# NOT OK, since this is a file.
					print STDOUT "**  Please enter a Directory, instead of a File\n\n";
					return ( 'no' );
				}
				else
				{
					# A directory pathname was entered which does not yet exist.
					# Check the list of directories already entered by the user.
					# If found, return 'yes' because the user already confirmed this pathname is OK.
					foreach $NextDirectory ( @NewDirectories )
					{
						if ( $Value =~ /$NextDirectory/ )
						{
							return ( 'yes' );
						}
					}

					# Prompt the user to confirm that this directory pathname is OK.
					# If 'y', then add pathname to @NewDirectories and return 'yes' (in Range).
					# If 'n', then return 'no' (out of Range).
					# The directory entered is NOT created at this time.
					# That will happen outside of the install prompts, if necessary.
					do
					{
						print STDOUT "**  This Directory does not exist.  Do you want to create it ? (y/n) ";
						$AddNewDirectory = <STDIN>;
					}
					while ( $AddNewDirectory !~ /^\s*[yn]\s*$/i );
					print STDOUT "\n";

					if ( $AddNewDirectory =~ /y/i )
					{
						push ( @NewDirectories, $Value );
						return ( 'yes' );
					}
					else
					{
						return ( 'no' );
					}
				}
			}
			else
			{
				print STDOUT "**  Please enter a FULL PATHNAME\n\n";
				return ( 'no' );
			}
		}
		elsif ( $RangeText eq 'db_num' )
		{
			if ( $Value =~ /^[0-9]\.[0-9]\.[0-9]\.[0-9]$/ )
			{
				return ( 'yes' );
			}
			else
			{
				print STDOUT "**  Please enter in this format:  #.#.#.#\n\n";
				return ( 'no' );
			}
		}
		else
		{
			# Set @Range equal to the list of acceptable values.
			@Range = split ' ', $RangeText;
		}
	}
	else  # Range is not defined #
	{
		return ( '' );
	}

	if ( $Range[0] =~ /^[0-9]+$/ )
	{
		# Range is between 2 numbers.
		if ( $Value >= $Range[0] && $Value <= $Range[1] )
		{
			return ( 'yes' );
		}
		else
		{
			print STDOUT "**  Must be within the range $Range[0] - $Range[1]\n\n";
			return ( 'no' );
		}
	}
	else
	{
		# Range is a list of strings containing acceptable values.
		foreach $RangeValue ( @Range )
		{
			if ( $Value =~ /^$RangeValue$/i )
			{
				# Set $NewValue to $RangeValue, if they match exactly EXCEPT for the case.
				# This will convert 'utf8' (entered by the user) to 'UTF8', for example.
				if ( $Value !~ /^$RangeValue$/ )
				{
					$NewValue = $RangeValue;
				}
				return ( 'yes' );
			}
		}
		print STDOUT "**  Please choose from:  $RangeText\n\n";
		return ( 'no' );
	}

}


#=============================================================
#
#  This function is a wrapper for &Output
#  and only displays the message if $DebugOn == 'YES'.
#
#  Arguments	: 
#    $OutHandle  -  either 'pause' or the output handle
#    $Message    -  text of the message to print
#    $Variables  -  any variables to be passed to @Output
#
#=============================================================
sub DebugOutput
{
	local( $OutHandle ) = shift( @_ );
	local( $Message ) = shift( @_ );
	local( $Variables ) = ( @_ );

	if ( $DebugOn =~ /YES/i )
	{
		if ( $OutHandle =~ /^pause$/i )
		{
			$pause = <STDIN>;
		}
		else
		{
			&Output( $OutHandle, $Message, $Variables );
		}
	}
}
