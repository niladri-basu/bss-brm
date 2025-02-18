###########
#
# @(#)Make.user (1.13)
#
# Copyright (c) 1999, 2010, Oracle and/or its affiliates. All rights reserved. 
#
#       This material is the confidential property of Oracle Corporation
#       or its subsidiaries or licensors and may be used, reproduced,
#       stored or transmitted only in accordance with a valid Oracle
#       license or sublicense agreement.
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
CFLAGS_aix= -Drs6000 -Dunix -D__unix -D__aix
CFLAGS_hpux= -g -Ae +Z +DAportable
CFLAGS_hpux_ia64= -g -Ae +Z
CFLAGS_linux= -m32 -fPIC
CFLAGS= $(CFLAGS_$(OS)) -DFLIST_HEAP

CPPFLAGS = -I$(INCDIR)

LDFLAGS_solaris= -G
LDFLAGS_aix= -G -bexpall -bnoentry -lc
LDFLAGS_hpux= -b
LDFLAGS_hpux_ia64= -b
LDFLAGS_linux= -m elf_i386 -shared -L/usr/lib
LDFLAGS = $(LDFLAGS_$(OS))

SL_EXT_solaris= so
SL_EXT_aix= a
SL_EXT_hpux= sl
SL_EXT_hpux_ia64= so
SL_EXT_linux= so
SL_EXT= $(SL_EXT_$(OS))

###########

INCFILES= $(INCDIR)/pin_cust.h $(INCDIR)/pcm.h \
	$(INCDIR)/pin_errs.h $(INCDIR)/pinlog.h

#

FILES= fm_zonemap_pol_config.c \
	fm_zonemap_pol_prep_zonemap.c \
	fm_zonemap_pol_storage.c \
	fm_zonemap_pol_serialize.c \
	fm_zonemap_pol_network.c \
	fm_zonemap_pol_get_lineage.c \
	fm_zonemap_pol_util.c 

OBJECTS= fm_zonemap_pol_config.o \
	fm_zonemap_pol_prep_zonemap.o \
	fm_zonemap_pol_storage.o \
	fm_zonemap_pol_serialize.o \
	fm_zonemap_pol_network.o \
	fm_zonemap_pol_get_lineage.o \
	fm_zonemap_pol_util.o 

#

LIBZONEMAP=fm_zonemap_pol.$(SL_EXT)

###########

all: $(LIBZONEMAP)

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBZONEMAP)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC

###########

$(LIBZONEMAP): $(OBJECTS) $(INCFILES) Makefile
	$(LD) -o $(LIBZONEMAP) $(LDFLAGS) $(OBJECTS) -lm

$(OBJECTS): $(INCFILES) Makefile
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(FILES)

#

FRC:
