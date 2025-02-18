##############################################################################
#
# Copyright (c) 2008, 2010, Oracle and/or its affiliates. All rights reserved. 
#
#      This material is the confidential property of Oracle Corporation
#      or its licensors and may be used, reproduced, stored or transmitted
#      only in accordance with a valid Oracle license or sublicense agreement.
#
###############################################################################

OS=linux
VERSION=7.5

###########

PINDIR=../../..
INCDIR=$(PINDIR)/include
LIBDIR=$(PINDIR)/lib

###########

CC_solaris = cc
CC_hpux = cc
CC_hpux_ia64 = cc
CC_aix = xlc_r
CC_linux = gcc
CC = $(CC_$(OS))

###########

CFLAGS_solaris= -g -xcg92
CFLAGS_hpux= -g -Ae +Z +DAportable
CFLAGS_hpux_ia64= -g -Ae +Z
CFLAGS_aix= -g -Drs6000 -D__aix -Dunix -D__unix
CFLAGS_linux= -m32 -fPIC
CFLAGS= $(CFLAGS_$(OS)) -DFOR_CM

CPPFLAGS = -I$(INCDIR) -DPCMCPP_CONST_SAFE -DFOR_CM

LDFLAGS_solaris= -G
LDFLAGS_hpux= -b
LDFLAGS_hpux_ia64= -b
LDFLAGS_aix= -G -bnoentry -bexpall -lc
LDFLAGS_linux= -m elf_i386 -shared -L/usr/lib
LDFLAGS = $(LDFLAGS_$(OS)) -L$(LIBDIR)

SL_EXT_solaris= so
SL_EXT_hpux= sl
SL_EXT_hpux_ia64= so
SL_EXT_aix= a
SL_EXT_linux= so
SL_EXT= $(SL_EXT_$(OS))

###########

INCFILES= $(INCDIR)/pcm.h

###########

FILES=	fm_adu_pol_validate.c \
	fm_adu_pol_dump.c \
	fm_adu_pol_config.c

OBJECTS= fm_adu_pol_validate.o \
	 fm_adu_pol_dump.o \
	 fm_adu_pol_config.o

###########

LIBADU=fm_adu_pol.$(SL_EXT)

###########

all: $(LIBADU)

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBADU)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC

###########

$(LIBADU): $(OBJECTS) $(INCFILES) Makefile
	$(LD) -o $(LIBADU) $(LDFLAGS) $(OBJECTS) -lpin_cc -lm -lpsiu_for_cm -lregex

$(OBJECTS): $(INCFILES) Makefile
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $*.c* 

###########

FRC:
