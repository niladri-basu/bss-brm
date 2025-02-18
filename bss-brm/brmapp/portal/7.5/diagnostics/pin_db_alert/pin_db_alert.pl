#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: pin_db_alert.pl:RWSmod7.3.1Int:1:2007-Jul-03 00:52:18 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.
#

use Env;
use Cwd;
$myPWD=getcwd();
use lib ".";
$DEBUG = $ENV{'DEBUG'};
print ("\@INC is @INC\n") if $DEBUG;
require "./pin_db_alert.conf";
require DecisionUtility;

my $pluginPos=0;
foreach $myPlugin (@DATA_PLUGINS)
{
  @myPluginArgumentList=();
  @myArgumentListParams=();
  @myPluginArgumentList = split(/ /, $myPlugin);
  my $myPluginName;

  # extract arguments specified in configuration in myArgumentListParams
  if ( $#myPluginArgumentList) {
      $myPluginName = $myPluginArgumentList[0];
      for $i ( 1 .. $#myPluginArgumentList) {
          $myArgumentListParams[$i-1] = $myPluginArgumentList[$i];
          print (" argument # $myArgumentListParams[$i-1] \n") if $DEBUG;
      }
  }
  else{
      $myPluginName = $myPlugin;
  }

  # append .pm to the data plugin name
  my $myPluginpm = $myPluginName . ".pm";

  # check for existence of the data plug-in file
  if ( ! -e "$myPWD/$myPluginpm" )
  {
     print "$myPWD/$myPluginpm not found \n";
     $pluginPos++;
     # continue to process next plug-in
     next;
  }
  require $myPluginpm;
  # invoke the cmd on the  plugin instance
  my $myPluginCmdString= $myPluginName."::run";
  print ("myPluginCmdString : $myPluginCmdString \n") if $DEBUG;
  $retVal=0;
  $retVal=&$myPluginCmdString(@myArgumentListParams);
  if ( $retVal != 0 ) {
     print ("data plug-in failed:  $myPluginCmdString \n");
  }
  else {
     print ("data plug-in executed:  $myPluginCmdString \n");
     # read corresponding entry from @VALIDATION_PLUGINS
     $myValidation = $VALIDATION_PLUGINS[$pluginPos];

     @myPluginArgumentList=();
     @myArgumentListParams=();
     my $myValidationName;
     @myPluginArgumentList = split(/ /, $myValidation);

     # extract arguments specified in configuration in myArgumentListParams
     if ( $#myPluginArgumentList)
     {
        $myValidationName  = $myValidation[0];
        print "$myValidationName \n" ;
        for $i ( 1 .. $#myPluginArgumentList) {
            $myArgumentListParams[$i-1] = $myPluginArgumentList[$i];
            print " argument # $myArgumentListParams[$i-1] \n";
        }
     }
     else{
        $myValidationName  =  $myValidation;
     }

     # check for existence of the validaion plug-in
     # append .pm to the validation plugin name
     my $myValidationpm = $myValidationName . ".pm";

     # check for existence of the data plug-in file
     if ( ! -e "$myPWD/$myValidationpm" )
     {
        print "$myPWD/$myValidationpm not found \n";
        # continue to process next plug-in
        $pluginPos++;
        next;
     }
     require $myValidationpm;
     print "$myValidationName \n" ;
     # invoke validation module plugin instance
     my $myPluginCmdString= $myValidationName."::validate";
     print ("myPluginCmdString : $myPluginCmdString \n") if $DEBUG;
     $retVal=0;
     $retVal=&$myPluginCmdString(@myArgumentListParams);
     if ( $retVal != 0 ) {
        print ("validation plugin failed:  $myPluginCmdString \n");
     }
     else {
        print ("validation plugin executed:  $myPluginCmdString \n");
     }
  }
  $pluginPos++;
}
DecisionUtility::decideAction();
