#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=============================================================
#  @(#)%Portal Version: pin_cmp_formatter.pl:InstallVelocityInt:1:2005-Mar-25 18:13:39 %
# 
# Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
# Portal installation for the Invoice Formatter Component
#
#=============================================================

# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
   require "pin_res.pl";
   require "pin_functions.pl";
   require "../pin_setup.values";

   &ConfigureComponentCalledSeparately ( $0 );
}


#####
#
# Configure Invoice Formatter files
#
#####
sub configure_formatter_config_files {

  %CM = %MAIN_CM;

  &ReadIn_PinCnf( "pin_cnf_formatter.pl" );

  #
  #  Configure Infranet.properties with current port ...
  #
  $i = 0;
  open( PROPFILE, "+< $PIN_HOME/sys/formatter/Infranet.properties" ) || die( "Can't open $PIN_HOME/sys/formatter/Infranet.properties" );
  @Array_PROP = <PROPFILE>;
  seek( PROPFILE, 0, 0 );
  while ( <PROPFILE> )
  {
    $_ =~ s/infranet\.pxslt\.logfile.*/infranet\.pxslt\.logfile=$PIN_LOG_DIR\/formatter\/pxslt.pinlog/i;
    $_ =~ s/infranet\.server\.portNR.*/infranet\.server\.portNr=$FORMATTER{'port'}/i;
    $_ =~ s/infranet\.log\.file.*/infranet\.log\.file=$PIN_LOG_DIR\/formatter\/formatter.pinlog/i;
    $_ =~ s/infranet\.log\.js\.file.*/infranet\.log\.js\.file=$PIN_LOG_DIR\/formatter\/formatter.pinlog/i;
    $Array_PROP[$i++] = $_;
  }
  seek( PROPFILE, 0, 0 );
  print PROPFILE @Array_PROP;
  print PROPFILE "\n";
  truncate( PROPFILE, tell( PROPFILE ) );
  close( PROPFILE );

  #
  # If the CM is there, add the entries to it.
  # If not, add the entries to the temporary pin.conf file.
  #
  if ( -f $CM{'location'}."/".$PINCONF )
  {
    &AddPinConfEntries( $CM{'location'}."/".$PINCONF, %FORMATTER_CM_PINCONF_ENTRIES );
    
    # Display a message current component entries are appended to cm/pin.conf file.
    &Output( STDOUT, $IDS_CM_PIN_CONF_APPEND_SUCCESS,
    			$CurrentComponent,
   			$CM{'location'}."/".$PINCONF);
    
  }
  else
  {
    # Create temporary file, if it does not exist.
    $TEMP_PIN_CONF_FILE = $PIN_HOME."/".$IDS_TEMP_PIN_CONF;
    open( PINCONFFILE, ">> $TEMP_PIN_CONF_FILE" );
    close( PINCONFFILE );

    &AddPinConfEntries( "$TEMP_PIN_CONF_FILE", %FORMATTER_CM_PINCONF_ENTRIES );

    # Display a message saying to append this file to cm/pin.conf file.
    &Output( STDOUT, $IDS_APPEND_PIN_CONF_MESSAGE,
                        $CM{'location'}."/".$PINCONF,
                        $CurrentComponent,
                        $TEMP_PIN_CONF_FILE );
  };

}

#######
#
# Configuring database for Invoice Formatter
#
#######
#sub configure_formatter_database {
#}
