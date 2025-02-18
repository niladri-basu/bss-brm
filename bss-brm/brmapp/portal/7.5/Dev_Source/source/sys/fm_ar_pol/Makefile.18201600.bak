###########
#
# @(#)% Make.user (2) %
#
# Copyright (c) 2004, 2011, Oracle and/or its affiliates. All rights reserved. 
#
#	This material is the confidential property of Oracle Corporation or its
#	licensors and may be used, reproduced, stored or transmitted only in
#	accordance with a valid Oracle license or sublicense agreement.
#
###########

OS=linux
VERSION=7.5

##########
CC_solaris = cc
CC_linux = gcc
CC_hpux = cc
CC_hpux_ia64 = cc
CC_aix = xlc_r
CC = $(CC_$(OS))

##########

CFLAGS_solaris= -g -xcg92
CFLAGS_linux= -m32 -fPIC
CFLAGS_hpux= -g -Ae +Z +DAportable
CFLAGS_hpux_ia64= -g -Ae +Z 
CFLAGS_aix= -g -Drs6000 -D__aix -Dunix -D__unix
CFLAGS= $(CFLAGS_$(OS)) -DFOR_CM -DFM_AR_POL_DLL

CPPFLAGS = -I$(INCDIR) -DPCMCPP_CONST_SAFE -DFOR_CM -DFM_AR_POL_DLL

LDFLAGS_solaris= -G
LDFLAGS_linux= -m elf_i386 -shared -L/usr/lib
LDFLAGS_hpux= -b
LDFLAGS_hpux_ia64= -b
LDFLAGS_aix= -G -bnoentry -bexpall -lc
LDFLAGS = $(LDFLAGS_$(OS))

SL_EXT_solaris= so
SL_EXT_linux= so
SL_EXT_hpux= sl
SL_EXT_hpux_ia64= so
SL_EXT_aix= a
SL_EXT= $(SL_EXT_$(OS))

####

PINDIR=../../..
INCDIR=$(PINDIR)/include

###########

INCFILES= $(INCDIR)/pin_cust.h $(INCDIR)/pcm.h \
	$(INCDIR)/pin_errs.h $(INCDIR)/pinlog.h \
	$(INCDIR)/pin_act.h $(INCDIR)/pin_ar.h \
	$(INCDIR)/pin_bill.h $(INCDIR)/pin_flds.h \
	$(INCDIR)/pin_currency.h

#

FILES= fm_ar_pol_config.c \
	fm_ar_pol_reverse_writeoff.c \
	fm_ar_pol_get_event_rum_charge_details.c 
#	fm_ar_pol_pre_event_adjustment_custom.c

#

OBJECTS= fm_ar_pol_config.o \
	fm_ar_pol_reverse_writeoff.o \
	fm_ar_pol_get_event_rum_charge_details.o 
#	fm_ar_pol_pre_event_adjustment_custom.o


LIBAR=fm_ar_pol_custom.$(SL_EXT)

###########

all: $(LIBAR)

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBAR)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC

###########

$(LIBAR): $(OBJECTS) $(INCFILES) Makefile
	$(LD) -o $(LIBAR) $(LDFLAGS) $(OBJECTS) -lm

$(OBJECTS): $(INCFILES) Makefile 
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $*.c*

FRC:

