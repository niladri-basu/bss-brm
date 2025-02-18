#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
#    Copyright (c) 2008 Portal Software, Inc. All rights reserved. 
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
# 1) compares the files present in package with PIN_HOME directory 
# 
# 2) Writes the list of files that has been installed as part of this patch in the file 
#     called patch_<patch_number>.lst
#
# usage:  PatchPostInstaller.pl <patch_number> <install> <product_name>
#
#  patch_number - Patch number 
#
# 11-Oct-2007-  Rajesh- Included pin_setup update function for the new packages(DM_AQ,JCA) on overlay
# 10-Nov-2008-  Rajesh- Split the patch installer script to display a log file (file list)before deploying it.


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
$vpdhome = "/home/integrate";

chdir $home;


# Flag to check for the existence of "RRF","MultiDB and "TCF"

$RRF_Installed = "True";
$MultiDB_Installed = "False";
$TCF_Installed = "False";


if($PROCESS eq "install") {
  &install();
}

sub install {
  if(-e "$home/patch/newFiles.txt") { 
    open (NEWFILESLIST,"$home/patch/newFiles.txt");
    @list = <NEWFILESLIST>;
    chomp(@list);
    close (NEWFILESLIST);

## Exception for 7.3.1 - remove new file element from new files list array when the corresponding product is not present in user home registry (vpd.properties) file.

    &vpdquery();


## Exception for removing fm_tcf_pol (makfile,fm_tcf_pol_apply_parameter.c,fm_tcf_pol_config.c) files from newFiles list array,if TCF is not installed.
      
    if ($TCF_Installed =~ /False/i ) {
      for($i=0;$i<=$#list;$i++) {
        if($list[$i] =~ /fm\_tcf\_pol\/Makefile|fm\_tcf\_pol\/fm\_tcf\_pol\_apply\_parameter\.c|fm\_tcf\_pol\/fm\_tcf\_pol\_config\.c/) {
        #rajesh temp setting #delete($list[$i]);
        }
      }
    }                      
	## Exception ends here      
  }

  find(\&edits, $PatchDir);
    sub edits() {
    if (-f) {
      #print "File name is $_\n\t\tFull path is $File::Find::name\n";
      push (@files,$_);              
      push (@filepath,$File::Find::name);              
    }
  }                 
  foreach $file (@filepath) {
    $Insfile = $file;
    $Insfile =~ s/$PatchDir\///i;
    push(@filelist,$Insfile);

   #Exception - if fm_global_search_stub is a new file then copy stub as 'fm_global_search' and deploy 'fm_global_search' as a changed file
   $fm_global = grep(/fm\_global\_search\_stub/,@list);       # check if new file array contains fm_global_search_stub
   if($fm_global && $Insfile =~ /fm\_global\_search\.so/  && $MultiDB_Installed =~ /False/i) {        
     $fm_global_search_stub = $Insfile;                        
     $fm_global_search_stub =~s/\.so/\_stub\.so/;                    
     chdir $PatchDir;                                
     copy($fm_global_search_stub,$Insfile);     # copy fm_global_search_stub as fm_global_search in patch cache area ( 'PINHOME/patch/<patch_number>/lib/')
     chdir $home;
     push(@diffFiles,$Insfile);                 #install fm_global_search as a changed file
   }
           
    if(compare("$file","$Insfile") != 0 && ! -e "$Insfile.$PATCH_NUMBER.bak") {       #compares the patch file with existing file and checks for the existence of bak file
                  
      if(-e $Insfile) {
        #If the file name is not fm_reserve or fm_reserve_stub fm_global_search or fm_global_search_stub, go ahead and back them up
        # File name can be fm_reserve_pol. so match it upto dot at the end
        if($Insfile !~ /lib\/fm\_reserve\./ && $Insfile !~ /lib\/fm\_global_search\./ && $Insfile !~ /lib\/fm\_reserve\_stub/ && $Insfile !~ /lib\/fm\_global_search\_stub/) {
          #rename($Insfile, $Insfile.".".$PATCH_NUMBER.".".bak);
          #&copy_existingfile();
          push(@diffFiles,$Insfile);
        }
        else {
          if($RRF_Installed =~ /True/i && $Insfile =~ /fm\_reserve\./) {
            #rename($Insfile, $Insfile.".".$PATCH_NUMBER.".".bak);
            #&copy_existingfile();
            push(@diffFiles,$Insfile);
          }
          elsif ($MultiDB_Installed =~ /True/i && $Insfile =~ /fm\_global\_search\./) {   
          #rename($Insfile, $Insfile.".".$PATCH_NUMBER.".".bak);
          #&copy_existingfile();
          push(@diffFiles,$Insfile);
          }
	 #If RRF was not installed and fm_reserve_stub was installed with this patch, 
	 #create a copy of fm_reserve_stub as fm_reserve
          elsif($RRF_Installed =~ /False/i && $Insfile =~ /fm\_reserve\_stub/) {
            $fm_reserve = $Insfile;
            $fm_reserve =~s/fm_reserve_stub/fm_reserve/;
            chdir $PatchDir;
            copy($Insfile,$fm_reserve);
            chdir $home;
            push(@diffFiles,$Insfile);
            push(@diffFiles,$fm_reserve);
          }
	 #If MultiDB was not installed and fm_global_search_stub was installed with this patch, 
	 #create a copy of fm_global_search_stub as fm_global_search
          elsif($MultiDB_Installed =~ /False/i && $Insfile =~ /fm\_global\_search\_stub/) {
            $fm_global_search = $Insfile;
            $fm_global_search =~s/fm_global_search_stub/fm_global_search/;
            chdir $PatchDir;
            copy($Insfile,$fm_global_search);
            chdir $home;
            push(@diffFiles,$Insfile);
            push(@diffFiles,$fm_global_search);
          }   
        }
                  
      }
      else {
        if(-e "$home/patch/newFiles.txt") {                      
          @matchfound = grep(/^$Insfile$/,@list);
          if(@matchfound) {                         
            push(@newfiles,@matchfound);
            #&copy_newfile();
          }
          else {                              
            push(@matchfail,$Insfile);                         
          }                                                          
        }                      
        else {              
          push(@newfiles,$Insfile);
          #&copy_newfile();
        }
                                          
      }
    }
    else {
      push(@existFiles,$Insfile);
    }
  }
              
  if(-e "$home/patch/newFiles.txt") {
    #push(@existFiles,@matchfail);
    foreach $item(@diffFiles) {
      $foundflag = "false";
        foreach $newitem(@matchfail) {
          if( $item eq $newitem ) {
            $foundflag = "true";
          }
        }
        if( $foundflag eq "false" )
        {
          push( @finalDiff, $item );
        }
     }
     `rm patch/newFiles.txt`;
   }
   else {
     @finalDiff= @diffFiles;
   }
             
           
   open (FILESLIST,">patch/patch_$PRODUCT.$PATCH_NUMBER.lst");
   #@filelist = join ("\n",@filelist);
   push(@finalDiff,@newfiles);                                          #pushing new files array into diff files array
   @newfiles = join ("\n",@newfiles);
   @existFiles = join ("\n",@existFiles);       
   @prodchkfail = join ("\n",@prodchkfail);       
   #@diffFiles = join ("\n",@finalDiff);

=comment
       print FILESLIST "----------------IMPORTANT--------------------\n";
       print FILESLIST "# Please do not modify or delete this file\n";
       print FILESLIST "# Modifying this file or deleting the file will result\n";
       print FILESLIST "# in an incomplete patch installation and uninstallation\n";
       print FILESLIST "---------------------------------------------\n";
=cut
       print FILESLIST "-----------------IMPORTANT-------------------\n";
       print FILESLIST "# The following files will be installed \n";
       print FILESLIST "# with this patch \n";
       print FILESLIST "---------------------------------------------\n";
       if (@finalDiff) {
             @diffFiles = join ("\n\$INSTALL_HOME/",@finalDiff);
              print FILESLIST "\$INSTALL_HOME/@diffFiles\n";
       }

       print FILESLIST "---------------------------------------------\n";
       print FILESLIST "# The following files were packaged with \n";
       print FILESLIST "# this patch, However only the applicable \n";
       print FILESLIST "# files will be installed \n";
       print FILESLIST "---------------------------------------------\n";
       if (@filelist) {
             @filelist = join ("\n\$PATCH_HOME/",@filelist);
              print FILESLIST "\$PATCH_HOME/@filelist\n";
       }
       
       print FILESLIST "---------------------------------------------\n";
       print FILESLIST "# The following files will not be installed\n";
       print FILESLIST "# because the latest version exists in the \n";
       print FILESLIST "# system \n";
       print FILESLIST "---------------------------------------------\n";
       print FILESLIST "@existFiles\n";

       print FILESLIST "---------------------------------------------\n";
       print FILESLIST "# The following files will not be installed\n";
       print FILESLIST "# because the prerequisite product is not\n";
       print FILESLIST "# installed in the system \n";
       print FILESLIST "---------------------------------------------\n";
       print FILESLIST "@prodchkfail\n";

       print FILESLIST "---------------------------------------------\n";
       print FILESLIST "# The following are the new files were \n";
       print FILESLIST "# packaged with this patch \n";
       print FILESLIST "---------------------------------------------\n";
       print FILESLIST "@newfiles\n";

       close (FILESLIST);

}

sub vpdquery {
  open (VPDREG,"$vpdhome/vpd.properties");
  @vpdlist = <VPDREG>;
  for($i=0;$i<=$#list;$i++) {
    @objectkey =(split(/\,/,$list[$i]));
    $queryreturn = "0";
    for($j=1;$j<=$#objectkey;$j++) {                          
      $prodmatch = grep(/$objectkey[$j]/, @vpdlist);
      if($prodmatch != "0" || $objectkey[$j] =~ /Common/) {
        $queryreturn = "1";
      }    
      else {
        push(@prodchkfail,$list[$i]);
        #print "product $objectkey[$j] not installed for the file $objectkey[$j-1]\narray= @prodchkfail \n";
      }
    }                
    if($queryreturn eq "1") {
      push(@newlist,$objectkey[0]);
    }
  }  
  @list = @newlist;              
  close(VPDREG);
}
