#!/brmapp/portal/ThirdParty/perl/5.8.0/bin/perl
my $DatabaseName = "<Database Name>";
my $UserName     = "<User Name>";
$cmd = "sqlldr $UserName\@$DatabaseName control=zoneLoader.ctl log=zoneLoader.log bad=zoneLoader.bad";
system($cmd);

exit 0;
