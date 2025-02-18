#!/brmapp/portal/ThirdParty/perl/5.18.2/bin/perl
# 
# $Header: install_vob/install_odc/Server/ISMP/Portal_Base/scripts/pin_cmp_qm_port.pl /cgbubrm_7.5.0.portalbase/2 2014/11/23 21:15:07 gdehshat Exp $
#
# pin_cmp_qm_port.pl
# 
# Copyright (c) 2013, 2014, Oracle and/or its affiliates. All rights reserved.
#
#    NAME
#      pin_cmp_qm_port.pl - updates pin.conf's qm_port entries to support IPV6
#
#    DESCRIPTION
#      <short description of component this file declares/defines>
#
#    NOTES
#      Old format of qm_port entry 
#               - component qm_port [<hostname or IP>:]port [tag]
#      New format of the qm_port entry
#               - component qm_port <hostname or IP> port [tag]
#      Changes from the old version 
#               the hostname part is not optional any more(we do support -)
#               ':' is not part fo the value string now.
#
#    MODIFIED   (MM/DD/YY)
#    kkatyaya    01/17/13 - Creation
# 
use File::Copy;
# If running stand alone, without pin_setup
if ( ! ( $RUNNING_IN_PIN_SETUP eq TRUE ) )
{
    require "pin_res.pl";
    require "pin_functions.pl";
    require "../pin_setup.values";

    &ConfigureComponentCalledSeparately ( $0 );
    &configure_qm_pin_conf ();
}
#####
#
# Configure pin.conf for all DM's based out of QM Framework
#
#####

sub configure_qm_pin_conf{

    my @comp_list = ('dm_ldap', 'dm_fusa', 'dm_email', 'cm_proxy', 'dm_vertex', 'dm_invoice', 'dm_taxware');
    my $pinpath = "";
    local ($start);
    local ($end);
    my $data ="";
    my $new_data = "";
    my @temp_file;
    foreach my $cur_comp (@comp_list) {
        $pinpath = $PIN_HOME."/sys/".$cur_comp."/pin.conf";
        copy ( $pinpath, $pinpath.".BCKUP" ) or next;
        open(MYPINCONFFILE, "+< $pinpath") or next;
        @FileReadIn = <MYPINCONFFILE>;
        $start = LocateEntry("qm_port", @FileReadIn);
        if ($start != -1) {
            $data = @FileReadIn[$start]; 
            $new_data =  &get_replacement_pinconf_entry($data); 
            $end = LocateNextSection($start, @FileReadIn);
            if ( $end == -1 ) {
                @temp_file = ( @FileReadIn[ 0 .. ($start -1)], $new_data."\n\n" );
                @FileReadIn = @temp_file;
            }
            else {
                @temp_file = ( @FileReadIn[ 0 .. ($start-1)],  
                        $new_data."\n\n", 
                        @FileReadIn[ ($end - 1) .. (@FileReadIn - 1) ], "\n" );
                @FileReadIn = @temp_file;
            }
        }
        else { 
            next;
        }
        seek( MYPINCONFFILE, 0, 0 );
        print MYPINCONFFILE @FileReadIn;
        print MYPINCONFFILE "\n";
        truncate( MYPINCONFFILE, tell(  MYPINCONFFILE) );
        close(MYPINCONFFILE);
    } 
#round 2
    @comp_list = ('simtools', 'sql_loader');
    $pinpath = "";
    $start = -1;
    $end = -1;
    $data = "";
    $new_data = "";
    @temp_file = ();
    foreach my $cur_comp (@comp_list) {
        $pinpath = $PIN_HOME."/apps/perf/".$cur_comp."/pin.conf";
        copy ( $pinpath, $pinpath.".BCKUP" ) or next;
        open(MYPINCONFFILE, "+< $pinpath") or next;
        @FileReadIn = <MYPINCONFFILE>;
        s/qm_port[ \t]+([0-9]+)/qm_port \- \1 /g for @FileReadIn;
        seek( MYPINCONFFILE, 0, 0 );
        print MYPINCONFFILE @FileReadIn;
        print MYPINCONFFILE "\n";
        truncate( MYPINCONFFILE, tell(  MYPINCONFFILE) );
        close(MYPINCONFFILE);
    } 

}

sub get_replacement_pinconf_entry {
    my $data = $_[0]; #the input string for us

    my @k_values = split(':', $data);
    my $total_parts = @k_values;
    my $k_new_string = "";

    if ($total_parts > 2) {
        # incorrect config line. Do not edit.
        $k_new_string = $data;
    }
    elsif ($total_parts == 1) {
        # most probably we have only port number and optionally a tag number. 
        # we do not care about the tag. Just add the hostname part and return.
        # we use the fact that we have to add the hostnbame part between qm_port and the port number
        #sanity check, total number of elements should be either 4 or 5. 
        #we do not edit the line if the number of elements are different.
        @k_values = split(" ", $data);
        $total_parts = @k_values;
        $k_new_string = $data;
        # Check hypen (-) for qm_port entry in pin.conf for 'dm_ldap', 'dm_fusa', 'dm_email', 'cm_proxy', 'dm_vertex','dm_invoice', 'dm_taxware'
        # if exist don't insert it.
        if($total_parts < 5)
        {
          $k_new_string =~ s/qm_port/qm_port \- /g;
        }
        if ($total_parts != 4 && $total_parts != 5) {
            $k_new_string = $data;
        # total number of substrings indicates that the input is invalid. restore the old value
        } 
    }
    else {
        # we have two parts in the input line now. first part probably 
        # has a hostname and a port and optionally a tag number.
        # we simply replace ":" with a space and we are done.
        $k_new_string = $data;
        $k_new_string =~ s/:/ /g;
    }

    return $k_new_string ;
}
