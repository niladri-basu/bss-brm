#=============================================================
#  @(#)%Portal Version: pin_cnf_pin_cfg_bpdump.pl:PortalBase7.3.1Int:1:2007-Aug-29 21:48:08 %
# 
# Copyright (c) 2007, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#=============================================================
$PIN_CFG_BPDUMP_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for Portal with PIN_CRYPT_UPGRADE
#
#
# This configuration file is automatically installed and configured with
# default values during Portal installation. You can edit this file to:
#   -- change the default values of the entries.
#   -- disable an entry by inserting a crosshatch (#) at the start of
#        the line.
#   -- enable a commented entry by removing the crosshatch (#).
# 
# Before you make any changes to this file, save a backup copy.
#
# When editing this file, follow the instructions in each section.
# For more information on the general syntax of configuration entries,
# see "Reference Guide to Portal Configuration Files" in the Portal
# online documentation.
#************************************************************************
END
;

%PIN_CFG_BPDUMP_PINCONF_ENTRIES= (

  "pin_cfg_bpdump_description", <<END
#========================================================================
# internal option
# specify to disable the NAGLE algorithm for sockets.
# default 0 is to enable the NAGLE algorithm
#========================================================================
END
	,"pin_cfg_bpdump", "- - pcp_nagle_disable 0"

);
