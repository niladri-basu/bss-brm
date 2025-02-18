###########
#
# @(#)% %
#
# Copyright (c) 1999, 2014, Oracle and/or its affiliates. All rights reserved.
#
#      This material is the confidential property of Oracle Corporation
#      or its licensors and may be used, reproduced, stored or transmitted
#      only in accordance with a valid Oracle license or sublicense agreement.
#
###########

OS=linux
VERSION=7.5

##########

PINDIR=../../..
INCDIR=$(PINDIR)/include

##########
CC_solaris = cc
CC_hpux = cc
CC_hpux_ia64 = cc
CC_aix = xlc_r
CC_linux = gcc
CC = $(CC_$(OS))

##########
CFLAGS_solaris= -g -xcg92
CFLAGS_linux= -m32 -fPIC
CFLAGS_hpux= -g -Ae +Z +DAportable
CFLAGS_hpux_ia64= -g -Ae +Z 
CFLAGS_aix= -g -Drs6000 -D__aix -Dunix -D__unix
CFLAGS= $(CFLAGS_$(OS)) -DFOR_CM -DFM_RESERVE_POL_DLL

CPPFLAGS = -I$(INCDIR) -DPCMCPP_CONST_SAFE -DFOR_CM -DFM_RESERVE_POL_DLL

LDFLAGS_solaris= -G
LDFLAGS_linux= -m elf_i386 -shared
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

###########

INCFILES= $(INCDIR)/pin_cust.h $(INCDIR)/pcm.h $(INCDIR)/pin_errs.h \
	$(INCDIR)/pinlog.h $(INCDIR)/pin_reserve.h

#

FILES= fm_reserve_pol_config.c \
	fm_reserve_pol_prep_create.c \
	fm_reserve_pol_pre_release.c \
	fm_reserve_pol_prep_extend.c \
	fm_reserve_pol_post_dispute.c \
	fm_reserve_pol_post_settlement.c

OBJECTS= fm_reserve_pol_config.o \
	fm_reserve_pol_prep_create.o \
	fm_reserve_pol_pre_release.o \
	fm_reserve_pol_prep_extend.o \
	fm_reserve_pol_post_dispute.o \
	fm_reserve_pol_post_settlement.o

#

LIBRATE=fm_reserve_pol_custom.$(SL_EXT)

###########

all: $(LIBRATE)

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBRATE)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC

###########

$(LIBRATE): $(OBJECTS) $(INCFILES) Makefile 
	$(LD) -o $(LIBRATE) $(LDFLAGS) $(OBJECTS) -lm 

$(OBJECTS): $(INCFILES) Makefile
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(FILES)

#

FRC:






