#!/bin/sh
#
# @(#)%encrypt_password.sh %
#
# encrypt_password.sh
#
# Copyright (c) 2011 Oracle and/or its affiliates. All rights reserved.
#
# This material is the confidential property of Oracle Corporation or its
# licensors and may be used, reproduced, stored or transmitted only in
# accordance with a valid Oracle license or sublicense agreement.
#
# Usage: encrypt_password.sh <option>
# Options:
#
# ISMP -  encrypt only pin_setup.values
# pin_setup - encrypt all config files without bouncing dm_oracle
# pin_setup_chmod - set config file permission only
# (no value) - perform all functions
#
. /brmapp/portal/7.5/source.me.sh

if [ "$1" != "" ]
then
  $PIN_HOME/setup/scripts/encryptpassword.pl $1
  if [ $? -ne 0 ]
  then
    echo "encryptpassword.pl $1 failed."
    echo $?
    exit 1
  fi
else
  $PIN_HOME/setup/scripts/encryptpassword.pl
  if [ $? -ne 0 ]
  then
    echo "encryptpassword.pl failed."
    echo $?
    exit 1
  fi
fi
exit 0

