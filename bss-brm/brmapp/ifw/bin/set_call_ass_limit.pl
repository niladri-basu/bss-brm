#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

###############################################################################
#
#       Copyright (c) 2003 - 2006 Oracle. All rights reserved.
#
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored or transmitted
#       only in accordance with a valid Oracle license or sublicense agreement.
#	
#########################################################################################
# Utility script for PipeLine ---> Set The New Flush Limit For Call Assembly
#########################################################################################

if("a$ENV{'IFW_HOME'}" ne "a")
{
  $ENV{"IFW_HOME_PATH"} = $ENV{'IFW_HOME'};
}
else 
{
  if ("a$ENV{'INTEGRATE_HOME'}" ne "a") {
     $ENV{"IFW_HOME_PATH"} = $ENV{'INTEGRATE_HOME'};
  }
}

sub set_call_ass_limit {
  if("a$ENV{'IFW_HOME_PATH'}" eq "a")
  {
    print "Pipeline home not found, aborting....\n";
    return 1;
  }
  open(INSTRM, "$ENV{'IFW_HOME_PATH'}/semaphore/set_call_ass_limit.reg") || die "Cannot open file :$!";
  open(OUTSTRM, ">>$ENV{'IFW_HOME_PATH'}/semaphore/semaphore.reg") || die "Cannot open file :$!";
  @lines = <INSTRM>;
  close(INSTRM);
  print OUTSTRM @lines;
  close(OUTSTRM);

  print "Semaphore for set_call_ass_limit is sent \n";
}

set_call_ass_limit;

exit 0;

