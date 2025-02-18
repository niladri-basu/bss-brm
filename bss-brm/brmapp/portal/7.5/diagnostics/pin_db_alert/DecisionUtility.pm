#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: DecisionUtility.pm:RWSmod7.3.1Int:2:2007-Oct-06 10:58:56 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.
#
# The purpose of the file is to send mail alert for each type of 
# status/severity combination configured in pin_db_alert.conf for 
# @STATUS variable
# Alerts will be sent only for the KPIs specified in @KPI_IDS 
# mentioned in pin_db_alert.conf

package DecisionUtility;
use  Env;
use  Switch;
require readConfigUtility;
$DEBUG = $ENV{'DEBUG'};

our @ISA =qw(Exporter);
our @EXPORT =qw(decideAction);

#supported KPI based information structure
$myFailMajorList="";
$myFailMinorList="";
$myFailCriticalList="";
$myFailWarningList="";
$myPassNormalList="";
$myPassWarningList="";

# supported alert modules  . Currently only unix/linux mail is supported
require mail_unix;


sub decideAction() {
  print ("Enter DecisionUtility::decideAction() \n") if $DEBUG;
  my $myStatusCount=0;
  my @myValidationFileContentLines = ();
  my $myStatus;
  # go through list of validation o/p files for the KPI
  my $myKPIList = readConfigUtility::readConfigValue('KPI_IDS');
  my @myKPI_IDs = split(/\"/ , $myKPIList);
  print (" my KPI: $myKPI \n") if $DEBUG;
  for $i (1 .. $#myKPI_IDs)
  {
      $myKPI=$myKPI_IDs[$i];
      print (" my KPI: $myKPI \n") if $DEBUG;
      if ( $myKPI =~ /^\s*,/ )
      {
      # do nothing
      }
      else
      {
      my $myFileContentLines=();
      my $myFilePattern = '*_validation_'."$myKPI.out";
      my $myFileContent=`cat $myFilePattern`;
      # read through each line 
      @myFileContentLines = split ( /\n/, $myFileContent);
      push @myValidationFileContentLines, [@myFileContentLines];
      for $i ( 0 .. $#myValidationFileContentLines) {
          for $j ( 0 .. $#{$myValidationFileContentLines[$i]} ) {
            print ("element  $i $j is $myValidationFileContentLines[$i][$j] \n") if $DEBUG;
        }
      }
    }
   }
   # for each entry process the staus array to find match of the VALIDATION_STATUS
   for $i ( 0 .. $#myValidationFileContentLines) {
       for $j ( 0 .. $#{$myValidationFileContentLines[$i]} ) {
           my $myValidationLine =$myValidationFileContentLines[$i][$j];
           # might need to strip extra  leading/trailing space - will be addressed later
           print ("$myValidationLine\n") if $DEBUG;
           my @myValidationStatus= split(/:/, $myValidationLine);
  
           my $myTempStatus = readConfigUtility::readConfigValue('STATUS');
           my @mySTATUSList = split (/'/ , $myTempStatus);

           for $i ( 0 .. $#mySTATUSList)
           {
               my $myStatus = $mySTATUSList[$i];
               print ("myStatus var $i : $myStatus \n") if $DEBUG;
               if ( $myStatus =~ /^\s*,/ ) 
               {
               #print STDOUT "nothing to do \n";
               }
               else
               {
               my @myStatusList=();
               @myStatusList = split(/:/, $myStatus);
               print ("myStatus in loop proceed $i : $myStatusList[0] \n") if $DEBUG;
               print ("validation in loop proceed $i : $myValidationStatus[1] \n") if $DEBUG;
               if ( $myStatusList[0] eq $myValidationStatus[1] ) {
                  switch ($myStatusList[0]) {     
                    case "FAIL.MAJOR" { $myFailMajorList .= "\n".$myValidationLine; }
                    case "FAIL.CRITICAL" {$myFailCriticalList .="\n".$myValidationLine;}
                    case "FAIL.MINOR" {$myFailMinorList .="\n".$myValidationLine; }
                    case "FAIL.WARNING" { $myFailWarningList .= "\n".$myValidationLine; }
                    case "PASS.NORMAL" { $myPassNormalList .= "\n".$myValidationLine; }
                    case "PASS.WARNING" { $myPassWarningList .= "\n".$myValidationLine; }
                  }
               }
            }
          }
        }
   }
   alertResultsOnActionList();
   print ("Exit DecisionUtility::decideAction() \n") if $DEBUG;
}

sub alertResultsOnActionList()
{
   my $myTempStatus = readConfigUtility::readConfigValue('STATUS');
   my @mySTATUSList = split (/'/ , $myTempStatus);

   for $i ( 0 .. $#mySTATUSList)
   {
        my $myActionStatus = $mySTATUSList[$i];
        if ( $myActionStatus =~ /^\s*,/ )
        {
        #print STDOUT "nothing to do \n";
        }
        else
        {
        print (" action status $i : $myActionStatus \n") if $DEBUG;
        my @myStatusList=();
        @myStatusList = split(/:/, $myActionStatus);
        # extract the  action
        my $myAction = $myStatusList[1];
        print (" action : $myAction \n") if $DEBUG;
        print (" action : $myPassNormalList \n") if $DEBUG;
        print (" action : $myFailWarningList \n") if $DEBUG;
        print (" action : $myFailMajorList \n") if $DEBUG;
        print (" action : $myFailMinorList \n") if $DEBUG;
        #check the possible actions list if entries to be alerted are there
        switch ($myStatusList[0]) {
          case "PASS.NORMAL" { if ( $myPassNormalList ne "") {
                                  if( $myAction eq "MAIL_ALERT") {
                                  #print STDOUT " GOING FOR MAIL : $myStatusList[2]\n";
                                    sendMailAlert($myPassNormalList,$myStatusList[2]);
                                  } 
                                } 
                             ;}
          case "PASS.WARNING" { if ( $myPassWarningList ne "") {
                                  if( $myAction eq "MAIL_ALERT") {
                                    sendMailAlert($myPassWarningList,$myStatusList[2]);
                                  } 
                                } 
                             ;}
          case "FAIL.WARNING" { if ( $myFailWarningList ne "") {
                                  if( $myAction eq "MAIL_ALERT") {
                                    
                                    sendMailAlert($myFailWarningList,$myStatusList[2]);
                                  } 
                                } 
                             ;}
          case "FAIL.MAJOR" { if ( $myFailMajorList ne "") {
                                  if( $myAction eq "MAIL_ALERT") {
                                    sendMailAlert($myFailMajorList,$myStatusList[2]);
                                  } 
                                } 
                             ;}
          case "FAIL.MINOR" { if ( $myFailMinorList ne "") {
                                  if( $myAction eq "MAIL_ALERT") {
                                    sendMailAlert($myFailMinorList,$myStatusList[2]);
                                  } 
                                } 
                             ;}
          case "FAIL.CRITICAL" { if ( $myFailCriticalList ne "") {
                                  if( $myAction eq "MAIL_ALERT") {
                                    sendMailAlert($myFailCriticalList,$myStatusList[2]);
                                  } 
                                } 
                             ;}
        }
     }
   }
}


sub sendMailAlert()
{
    my  ($myValidationResults) = $_[0];
    my  ($mayActionList) = $_[1];
    print "SENDING MAIL sendMailAlert\n";
    print ("SENDING MAIL $myValidationResults \n") if $DEBUG;
    print ("SENDING MAIL $mayActionList \n") if $DEBUG;
    #invoke sendmail utility from appropriate platform specific modules
    #check unix platform
    # its is expected in the deployment environment the variable OS needs to
    # be set
    # OS=>solaris  for SunOS machine
    # OS=>hpux     for HP-UX machine
    # OS=>linux    for linux machine
    # OS=>Winows_NT for Windows machine
    #print "\n$ENV{'OS'}";
    my $myOS= $ENV{'OS'};
    if ( $myOS ne "Windows_NT" ) {
       print STDOUT  "Invoking mail_unix::sendMailAlert\n";
       my $myReturnValue=mail_unix::sendMailAlert($myValidationResults,$mayActionList);
       if ( $myReturnValue != 0 ) {
          # log error in sending mail 
       }
       else {
          # log success
       }
     }
     else {
          if ( $myOS eq  "Windows_NT") {
             # invoke mail_windows::sendMailAlert();
             my $myReturnValue=mail_unix::sendMailAlert($myValidationResults,$mayActionList);
          }
          else {
             # un supported  OS
             print "SENDING MAIL sendMailAlert FAIL: attempted on un-supported OS\n";
          }
     }
     print STDOUT "ATTEMPTED MAIL ALERT \n";
}

1;
