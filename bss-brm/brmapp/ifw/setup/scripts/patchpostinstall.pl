#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#    Copyright (c) 2006-2008 Portal Software, Inc. All rights reserved. 
#
#    This material is the confidential property of Portal Software, Inc. 
#    or its subsidiaries or licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Portal license or
#    sublicense agreement.
#
##########################################################################
# This script does the following
# 
#For Install 
# 1) compares the files present in package with PIN_HOME directory and backsup
#     the existing files present in PIN_HOME dir with the following name
#     <FILENAME>.<patchnumber>.bak
# 2) copies the files present under patch/<Patch_Number> to PIN_HOME directory directory
# 
#For Uninstall 
# 1) removes the files that was installed as part of the patch
#
# 2) moves the backed up file to the original name
#
# 3) creates the dummy patch files under patch/<patch_number> directory for the clear uninstallation
#
# usage:  patchpostinstall.pl <patch_number> <install or uninstall> <product_name>
#
#  patch_number - Patch number 
#  install or uninstall - This post install script called during Install or Uninstall process

use File::Copy;
use File::Find;
use Cwd;
use File::Compare;

# Assign patch number

$PATCH_NUMBER= $ARGV[0];

# perform the function based on the Install or Uninstall process

$PROCESS = $ARGV[1];

# Assign product name ("Portal_Base" or "Portal_SDK" or "Timos" or "Pipeline")

$PRODUCT= $ARGV[2];

$home = "/brmapp/ifw";
$PatchDir = "$home/patch/$PATCH_NUMBER";
chdir $home;

if($PROCESS eq "install") {
  open (PATCHLOGFILE,">patch/patch_$PRODUCT.$PATCH_NUMBER.log.txt");
  print PATCHLOGFILE "patch_$PATCH_NUMBER $PROCESS log: \n";
  &install();
  }
elsif ($PROCESS eq "uninstall") {       
  if(-e "patch/patch_$PRODUCT.$PATCH_NUMBER.lst") {
    open (PATCHLOGFILE,">>patch/patch_$PRODUCT.$PATCH_NUMBER.log.txt");
    print PATCHLOGFILE "\n\n\n-----------------------------------------------------------\n";
    print PATCHLOGFILE "patch_$PATCH_NUMBER $PROCESS log: \n";
    &uninstall();
  }
  else {
    print PATCHLOGFILE "Patch_$PRODUCT.$PATCH_NUMBER.lst file is not exist in $home/Patch directory and patch uninstallation failed \n";
    exit();
  }
}

sub install {
    if(-e "$home/patch/patch_$PRODUCT.$PATCH_NUMBER.lst") {
      open (COPYFILESLIST,"$home/patch/patch_$PRODUCT.$PATCH_NUMBER.lst");
      while(<COPYFILESLIST>) {
        if($_ =~ /INSTALL_HOME/) {
           $_ =~ s/\$INSTALL_HOME/$home/g;		#replace INSTALL_HOME with the pinhome directory
           $_ =~ s/\n//g;				#to remove newline character
           push(@filepath,$_);           
        }
         
      }
      
     }
     foreach $file (@filepath) {           
       
       $Insfile = $file;
       $file =~ s/$home/$PatchDir/g;       
       push(@filelist,$Insfile);
           
       if(compare("$file","$Insfile") != 0 && ! -e "$Insfile.$PATCH_NUMBER.bak") {       #compares the patch file with existing file and checks for the existence of bak file
         if(-e $Insfile) {
           #print "^^^^^^^ file already exist $Insfile\n";
           # If the file is already exist then installer will back up existing file with patch number
           # extension (ex: <file>.563729.bak) before deploying the newer version of the file 
           rename($Insfile, $Insfile.".".$PATCH_NUMBER.".".bak);           
           print PATCHLOGFILE "backing up $Insfile, $Insfile.$PATCH_NUMBER.bak \n";
           &copy_existingfile();
           push(@diffFiles,$Insfile);       
           
         }
         else {        
           &copy_newfile();
           push(@newfiles,$Insfile);           
         }

       }
     
     }

#overlay - update pin_setup.values with entries about new packages DM_AQ and BRM_JCA_ADAPTER.
      if(-e "$home/setup/scripts/pin_setup.update") {
              &pin_setup_update()               
        }
     `rm -rf patch/$PATCH_NUMBER`;
}

sub uninstall {              
  open (FILESLIST,"patch/patch_$PRODUCT.$PATCH_NUMBER.lst");       
  @files =<FILESLIST>;           
  `mkdir -p $home/patch/$PATCH_NUMBER`;
  foreach $file (@files) {            
    chomp ($file);
    if($file !~ /^#/ && $file !~ /^[ \t]*$/) {
      $Insfile = $file;
      if($file =~ /^\$INSTALL_HOME/) {                   
        $Insfile =~ s/\$INSTALL_HOME\///i;
        chdir $home;
                                                  
        if(-e $Insfile) {                           
          `rm $Insfile`;                   
          rename($Insfile.".".$PATCH_NUMBER.".".bak, $Insfile);
          print PATCHLOGFILE "Uninstalling $Insfile\n";            
        }
      }                
      if($Insfile =~ /^\$PATCH_HOME/) {                
        $Insfile =~ s/\$PATCH_HOME\///i;                
        @array = split(/\//,$Insfile);
        chdir $PatchDir;
        for ($i=0;$i<$#array;$i++) {                  
          if(! -e $array[$i]) {
            `mkdir -p $array[$i]`;                                   
          }
          chdir $array[$i];
        }
        chdir $PatchDir;
        if(! -e $Insfile) {          
          `touch $Insfile`;
        }
      }
    }                 
  }
  chdir $home; 
  close (FILESLIST);
  `rm patch/patch_$PRODUCT.$PATCH_NUMBER.lst`;
  print PATCHLOGFILE "\nUninstallation for this Patch($PATCH_NUMBER) has completed successfully\n";
}


sub copy_newfile {
  chdir $home;
  @array = split(/\//,$Insfile);
  delete($array[$#array]);
  $createnewdir=join("/",@array);
  if(! -e createnewdir) {      #create a new direcotory if it not already exist
    `mkdir -p $createnewdir`;
  }
  chdir $home;
  my $mode = (stat $file)[2];
  copy($file, $Insfile);
  print PATCHLOGFILE "deploying new file $Insfile \n";
  chmod $mode, $Insfile;
}

sub copy_existingfile { 
  my $mode = (stat $file)[2];  
  copy($file, $Insfile);   
  print PATCHLOGFILE "deploying affected file $Insfile \n";
  chmod $mode, $Insfile;

}


#backup exising pin_setup.values and append new package entries and avoiding duplications.
sub pin_setup_update {
  $pin_setup = "$home/setup/pin_setup.values";
  $pin_setupbak = "$home/setup/pin_setup.values.updbak";
  open (EXIST_ENT,"$pin_setup");
  @existentries = <EXIST_ENT>;
  close(EXIST_ENT);
  rename($pin_setup,$pin_setupbak);
  open (UPDATE,"$home/setup/scripts/pin_setup.update");
  open (PIN_SETUPBAK,"$pin_setupbak");
  open (PIN_SETUP,">$pin_setup");
  @newentries = <UPDATE>;

  while (<PIN_SETUPBAK>) {
    if(eof(PIN_SETUPBAK)) {
      foreach $entry (@newentries) {
        chomp($entry);
        $pinpat = $entry;
        if($entry =~ /\$/) {
          $entry= (split(/\$/,$entry))[1];
          $entry= (split(/\=/,$entry))[0];
        }
        $entrymatch = grep(/$entry/, @existentries);
        if($entrymatch == "0") {
          print PIN_SETUP "$pinpat\n";
        }
      }
    }
    print PIN_SETUP $_;
  }
  close(UPDATE);
  close(PIN_SETUPBAK);
  close(PIN_SETUP);
  `rm $home/setup/scripts/pin_setup.update`;
}
