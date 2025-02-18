#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl

###############################################################################
#
# Copyright (c) 2008, Oracle. All rights reserved.
#
#       This material is the confidential property of Oracle Corporation
#       or its licensors and may be used, reproduced, stored or transmitted
#       only in accordance with a valid Oracle license or sublicense agreement.
#
#########################################################################
# Description: This script is used to purge the NumberPortability Data
#########################################################################

use File::Copy;

my %table = ();
my $debug = 0;
my $TRUE=1;
my $FALSE=0;
my $prn_usage = $FALSE;
my $is_back_up = 0;
my $backup_file; 
my $is_number_sorting = 0;
my $sort_column = 1;
my %table_4_num_sort = ();

   &parse_cmd_line;
   @arr = split(' ',$arg_str);
   print " $prn_usage is prn_usage .$#arr is no of args. $arr[0] $arr[1] \n" if $debug; 
   if($#arr == 1 && $prn_usage == $FALSE && $arr[1] !~ /\d{14}/) {
	print "\n TimeStamp $arr[1] is not a 14 digit number. It should be in the 14 digit YYYYMMDDHHMMSS format.\n";
        $prn_usage = $TRUE;
   }
   if( $#arr != 1 || $prn_usage) {
        print "\nusage : purge_np_data.pl <NP_FileName> <TimeStamp(YYYYMMDDHHMMSS)> [OPTIONAL PARAMETERS]\n\n";
        print "\nusage : OPTIONAL PARAMETERS\n";
        print "\n -b   : [-b backup filename]. Name of the file where the original data has to be backed up.\n";
        print "\n -n   : Sort in the ascending order of the \"CLI\". Default sorting is in the ascending order of the \"TimeStamp\".\n\n";
        exit(1);
   }
   my ($filename) = $arr[0];
   my ($deleteBeforeVar) = $arr[1];
   open (INFILE, $filename) || die "\nFailed to find the file $filename. Please provide the correct NumberPortability filename.\n\n";
   if($is_back_up == 1) {
   	copy($filename,$backup_file);
	print "\n Original file \"$filename\" is backed up in the filename \"$backup_file\".\n";
   }
   my $flag = 0;
   my @lines =  <INFILE>;
   foreach (@lines ) {

        chop($_);
        $_ = trim($_);
        print"The line read is $_ \n" if $debug;
        @columns = split(/ +/);
        print"The columns are $columns[1] \n" if $debug;
        $table{$columns[1].$columns[2]} = $_;
        print"The table is $table{$columns[1].$columns[2]} \n" if $debug;
   }

   @mykeys = keys %table;
   foreach (@myKeys) {
        print "$_ \n" if $debug;
   }
   @mykeys = sort @mykeys;
   foreach $key (@mykeys) {
        print "$table{$key}\n" if $debug;
   }
   close(INFILE);
	
   print "The sorted list is \n:" if $debug;
   foreach $i (@mykeys) {
	print "$table{$i}\n" if $debug;
   }
   print "============================\n" if $debug;
   &printAftter($deleteBeforeVar);


sub printAftter
{
        open (OUTFILE, ">tst") || die "Failed to find the $filename \n";
        my($deleteBefore) = $_[0];
        my $flag = 0;
	my $count = 0;
        foreach $key1 (@mykeys) {
                if ($key1 =~ /$deleteBefore/) {
                        $flag = 1;
                        $count = $count + 1;
                        next;
                }
                if ($flag !=1) {
			$count = $count + 1;
                        next;
                }
                print OUTFILE  "$table{$key1}\n";
       }
       close(OUTFILE);

        if($flag == 1) {
		if($is_number_sorting == 1) {
	                &sortFileByColumn("tst",1);	
                        print "\n Sorted the NumberPortability data in the ascending order of the CLI.\n";
		}
                else {
	                &sortFileByColumn("tst",2);	
                        print "\n Sorted the NumberPortability data in the ascending order of the TimeStamp.\n";
                }
                rename("tst",$filename);
         	print "\n Purged <$count> NumberPortability Data entries. \n\n";
        } else {
		print "\n TimeStamp $deleteBefore given as input is not present in the NumberPortability data.\n";
                print "\n Please give the exact TimeStamp to purge the entries.\n\n";
	}

}


sub trim($)
{
  my $string = shift;
  $string =~ s/^\s+//;
  $string =~ s/\s+$//;
  return $string;
}

sub parse_cmd_line
{
        my $option;

        while ($option = shift @ARGV) {
                if (lc($option) eq '-debug') {
                        # Set debug
                        $debug = $TRUE;
                        next;
                }elsif(lc($option) eq '-b') {
			$is_back_up = 1;
			$backup_file = shift @ARGV;
			print "\n The backup filename is \"$backup_file\".\n";
		}elsif (lc($option) eq '-help') {
                        # Set help
                        $prn_usage = $TRUE;
                        next;
                } elsif(lc($option) eq '-n') {
			$is_number_sorting = 1; 
		}else {
			 $arg_str = $arg_str.' '.lc($option);
		}
        }
}

sub sortFileByColumn {

        my $file = $_[0];
        my $column = $_[1];
        $column .= "n";
        my $cmdSort = `sort -t ' ' -k $column $file`;
        open(OUTPUT, ">$file") ||  die "\nFailed to find the $file";
        print OUTPUT $cmdSort;
        close(OUTPUT);

}

