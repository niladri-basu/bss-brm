#=============================================================
#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#
# Author : Rakesh Nair
# Date   : 12-Aug-2015
#
# My right to trace!
#=============================================================


my $total = $#ARGV + 1;
my $counter = 1;
my $cmd = "";
my $space="";

$home =  $ENV{'PIN_HOME'};


$argn = @ARGV;

if ($argn < 1)
{
exit 0;
}


open (MAINLOG, ">>$home/bin/tracepvtchanges.log") || die "Unable to create file $home/bin/tracepvtchanges.log";

print MAINLOG ( "Execution date: " . `date` );
print MAINLOG ( "User details: " . `who am i` );
print MAINLOG ( "Execution Cmd: ");

foreach my $a(@ARGV) {
if ($counter ne 1)
{$space=" ";}

        $cmd = $cmd.$space.$a;
        $counter++;
}

print MAINLOG ( $cmd );
print MAINLOG ("\n");

close (MAINLOG);
$cmd =~ s/pvt/pin_virtual_time/g;
$out = `$cmd`;
print $out;
