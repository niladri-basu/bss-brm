#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# @(#)%Portal Version: mail_unix.pm:RWSmod7.3.1Int:1:2007-Jul-03 00:52:21 %
#
# Copyright (c) 2007 Oracle. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or
# its licensors and may be used, reproduced, stored or transmitted only
# in accordance with a valid Oracle license or sublicense agreement.
#

package mail_unix;
use Env;
use Net::SMTP;
$DEBUG = $ENV{'DEBUG'};
#

our @ISA =qw(Exporter);
our @EXPORT =qw(sendMailAlert);

sub sendMailAlert()
{
   my ($myValidationResults) = $_[0];
   my  ($mayActionList) = $_[1];
   print STDOUT " sendMailAlert:  $myValidationResults  \n";
   print STDOUT " sendMailAlert:  $mayActionList  \n";
# to send mail it is expected SMTP server is runnig on that host in port 25
print ("\n Host: $ENV{'OS'} \n") if $DEBUG;
my $myhostname=`hostname`;
chomp($myhostname);
print ("$myhostname \n") if $DEBUG;
my $SMTP_SERVER = $myhostname;
print ("$SMTP_SERVER \n") if $DEBUG;
my $DEFAULT_SENDER = 'False';
my $DEFAULT_RECIPIENT = 'False';
my $DEFAULT_SUBJECT = 'False';
#
my $myUser = $ENV{'USER'};
chomp($myUser);
$o{f} ='pin@oracle.com';
$o{s} = "DB ALERT TOOL REPORT";
my $content =$myValidationResults;
print ("$content\n") if $DEBUG;

@myActionListArray=();
# parse the action list and send mail to each user
@myActionListArray = split(/,/, $mayActionList);
foreach   $myRecipient (@myActionListArray)
{ 
chomp($myRecipient);
print (" Recipient:   $myRecipient\n") if $DEBUG;
$o{t} = $myRecipient;
#
#
$mailmsg=Net::SMTP->new($SMTP_SERVER);
$mailmsg->mail($o{f});
$mailmsg->to($o{t});
$mailmsg->data();
$mailmsg->datasend("To: $o{t}\n");
$mailmsg->datasend("Subject: $o{s}\n\n");
$mailmsg->datasend($content);
$mailmsg->dataend();
$mailmsg->quit;
#
}
return 0;
}

1;
