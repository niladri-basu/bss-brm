#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#=======================================================================
#  @(#)%Portal Version: pin_modular_functions.pl:PortalBase7.3.1Int:2:2007-Oct-28 23:48:59 %
# 
# Copyright (c) 2002, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#

#=============================================================
#
#  This function calls edits the eai_js/infranet.properties
#  file, and merges payload config files.
#
#  Arguments:
#    $PayloadConfigFile: Name of new payload_config file to merge.
#    $MergePayloadFile:  Name to call the merged payload config file.
#    $DB_Num:            Number of dm that eai should publish to.
#    $PublishFormat:     This value should be either 'FLIST' or 'XML'.
#
#  Configure_EAI_Payload returns a value of "Yes" if EAI_JS was
#  previously installed, and a value of "No" otherwise.
#
#=============================================================
sub Configure_EAI_Payload
{
  local ( $payloadconfig_file ) = shift @_;
  local ( $merged_payloadconfig_file ) = shift @_;
  local ( $publish_db_num ) = shift @_;
  local ( $publish_format ) = shift @_;
  local ( $XMLFile );
  local ( $EAI_JS_Previously_Installed ) = "No";
  local ( $i );
  local ( $Current_Dir ) = cwd();

  #
  #  Configure Infranet.properties with current values ...
  #
  if ( -f "$EAI{'eai_js_location'}/Infranet.properties" ) {
    # we found Infranet.properties
    # do nothing
    $EAI_JS_Previously_Installed = "Yes";
  } else {
    rename( "$EAI{'eai_js_location'}/Infranet_eai.properties", "$EAI{'eai_js_location'}/Infranet.properties" );
    $EAI_JS_Previously_Installed = "No";
  }

  $i = 0;
  open( PROPFILE, "+< $EAI{'eai_js_location'}/Infranet.properties" ) || die( "Can't open $EAI{'eai_js_location'}/Infranet.properties");
  @Array_PROP = <PROPFILE>;
  seek( PROPFILE, 0, 0 );
  while ( <PROPFILE> )
  {
    $_ =~ s/infranet\.server\.portNR.*/infranet\.server\.portNr=$EAI{'em_port'}/i;
    $_ =~ s/infranet\.log\.file.*/infranet\.log\.file=$PIN_LOG_DIR\/eai_js\/eai_js.pinlog/i;
    if ( $_ =~ /infranet.eai.configFile/ ) {




          if ( $EAI_JS_Previously_Installed =~ /^No$/ ) {
            $_ =~ s/infranet\.eai\.configFile.*/infranet\.eai\.configFile=$PIN_HOME\/sys\/eai_js\/$payloadconfig_file/i;
          } else {

            $XMLFile = $_;
            $XMLFile =~ s/infranet\.eai\.configFile=?\s*(.*)\s*$/$1/i;
          }
    }
    $Array_PROP[$i++] = $_;

  }
  seek( PROPFILE, 0, 0 );
  print PROPFILE @Array_PROP;
  print PROPFILE "\n";
  truncate( PROPFILE, tell( PROPFILE ) );
  close( PROPFILE );

  #
  #  Configure payloadconfig_bmsc.xml with current values ...
  #
  $i = 0;
  open( XML_FILE, "+< $EAI{'eai_js_location'}/$payloadconfig_file" ) || die( "Can't open $EAI{'eai_js_location'}/$payloadconfig_file" );
  @Array_XML = <XML_FILE>;
  seek( XML_FILE, 0, 0 );

  while ( <XML_FILE> )
  {
    $_ =~ s/Publisher DB.*/Publisher DB=\"$publish_db_num\" Format=\"$publish_format\"\>/i;
    $Array_XML[$i++] = $_;
  }
  seek( XML_FILE, 0, 0 );
  print XML_FILE @Array_XML;
  print XML_FILE "\n";
  truncate( XML_FILE, tell( XML_FILE ) );
  close( XML_FILE );

  #
  # Generate the script to merge, and merge the files
  #
   if ( $^O =~ /win/i ) {
     $Sep = ";";
     $wild = "\%*";
     $extension = ".bat";
   } else {
     $Sep = ":";
     $wild = "\$1 \$2 \$3 \$4 \$5 \$6 \$7 \$8 \$9";
     $extension = "";
   }
   $Cmd = &FixSlashes( "$ENV{'BRM_JRE'}/bin/java -cp \"$PIN_HOME/jars/eai.jar".$Sep
                       ."$PIN_HOME/jars/xml4j.jar".$Sep
                       ."$PIN_HOME/jars/pcm.jar".$Sep
                       ."$PIN_HOME/jars/pcmext.jar".$Sep
                       ."$PIN_HOME/jars/js.jar".$Sep
                       ."$EAI{'eai_js_location'}\" com.portal.eai.ConfigMerge $wild" );
   open( BATCHFILE, "> $PIN_HOME/bin/MergeXML$extension" );
   print BATCHFILE $Cmd;
   close( BATCHFILE );
   chmod 0755, "$PIN_HOME/bin/MergeXML$extension";

   $Cmd = &FixSlashes( "$PIN_HOME/bin/MergeXML$extension \"$XMLFile\" \"$payloadconfig_file\" \"$merged_payloadconfig_file\"");
   chdir ( $EAI{'eai_js_location'} );

   if ( $EAI_JS_Previously_Installed =~ /^YES$/i ) {
     $Cmd = &ExecuteShell_Piped( "$PIN_TEMP_DIR/tmp.out", TRUE, $Cmd, "" );
   }

   chdir ( $Current_Dir );

   return $EAI_JS_Previously_Installed;
}

#=============================================================
#  Need to return for "require" statement
#=============================================================
1;
