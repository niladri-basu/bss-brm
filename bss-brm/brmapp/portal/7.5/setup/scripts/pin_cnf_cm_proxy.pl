#=======================================================================
#  @(#)%Portal Version: pin_cnf_cm_proxy.pl:InstallVelocityInt:1:2005-Mar-25 18:11:58 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
$CM_PROXY_PINCONF_HEADER  =  <<END
#************************************************************************
# Configuration File for the CM Proxy
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

%CM_PROXY_PINCONF_ENTRIES = (
  "cm_oplist_description", <<END
#========================================================================
# oplist
# 
# Specifies a list of opcodes that the front-end processes can run.
#
# The syntax for this entry is:
#
#     - cm_proxy oplist <list_name> <op1>[,op2[,opN...]]
#
# where <list_name> is a name of 1 to 32 characters and 
# <op1...N> is the number of the opcode class as defined in the
# pcm_ops.h file.
# 
# The default opcode lists are:
#
#    mail_ops = all opcodes for the mail FM (fm_mail)
#    mail_deliv_ops = opcodes for mail delivery (mail_deliv_verify)
#    mail_login_verify = opcodes for mail login (mail_login_verify)
#========================================================================
END
  ,"cm_oplist", "- cm_proxy oplist	mail_ops 325,326
- cm_proxy oplist	mail_deliv_ops 325
- cm_proxy oplist	mail_login_ops 326"
  ,"cm_allowed_description", <<END
#========================================================================
# allowed
# 
# Specifies a list of host computers that can use CM Proxy, and the
# opcode lists each one is allowed to use.
#
# The syntax for this entry is:
#
#     - cm_proxy allowed <host_name_or_ip> <list_name1>[,list_nameN...]
#
# where <list_name> is the name of the opcode list you assigned in
# the oplist configuration entry.
# 
# The sample entries below show:
#
#    -- Host "1.2.3.4" can use all opcodes for the mail FM
#    -- Host "somehost" can use only the opcodes for mail delivery
#    -- Host "1.2.3.99" can use opcodes for both mail delivery and mail
#         login
#========================================================================
END
  ,"cm_allowed", "- cm_proxy allowed	1.2.3.4		mail_ops
- cm_proxy allowed	somehost	mail_deliv_ops
- cm_proxy allowed	1.2.3.99	mail_deliv_ops,mail_login_ops" );
  
