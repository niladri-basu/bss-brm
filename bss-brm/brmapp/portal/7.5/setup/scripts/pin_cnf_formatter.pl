#=======================================================================
#  @(#)%Portal Version: pin_cnf_formatter.pl:InstallVelocityInt:1:2005-Mar-25 18:12:57 %
# 
# Copyright (c) 2005, 2009, Oracle and/or its affiliates. All rights reserved. 
#
#    This material is the confidential property of Oracle Corporation 
#    or its licensors and may be used, reproduced, stored
#    or transmitted only in accordance with a valid Oracle license or
#    sublicense agreement.
#
#========================================================================
#************************************************************************
# Configuration File for the Invoice Formatter
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
%FORMATTER_CM_PINCONF_ENTRIES = (

        "formatter_em_group_description", <<END
#========================================================================
# Invoice_formatter_em_group
#
# Defines a member opcode in a group of opcodes provided by an External
# Manager. The group tag needs to match the tag in the "em_pointer"
# entries.
# 
# Each group includes two values:
#
#  -- em tag, a string of up to 15 characters, that matches the em_pointer
#       tags
#  -- the opcode name or number
#========================================================================
END
        ,"formatter_em_group", "- cm em_group formatter 960"

        ,"formatter_em_pointer_description", <<END
#========================================================================
# Invoice_formatter_em_pointer
#
# Specifies where to find the External Manager(s) that provide other
# opcodes to the CM. Use a separate pointer for each EM on your system.
#
# Each pointer includes four values:
#
#     <em tag>           = a string of 1 to 15 characters that matches
#                            the em_group keys
#     <address type tag> = "ip", for this release
#     <host>             = the name or IP address of the computer running
#                            the EM
#     <port>             = the TCP port number of the EM on this computer
#========================================================================
END
        ,"formatter_em_pointer", "- cm em_pointer formatter ip $FORMATTER{'hostname'} $FORMATTER{'port'}"
);
