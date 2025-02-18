###########
#      @(#)% %
#
# Copyright (c) 1999, 2010, Oracle and/or its affiliates. All rights reserved. 
#      This material is the confidential property of Oracle Corporationi.
#      or its subsidiaries or licensors and may be used, reproduced, stored
#      or transmitted only in accordance with a valid Oracle license or
#      sublicense agreement.
#

###########

OS=linux
PIN_VERSION=7.5

##########

PINDIR=../../..
INCDIR=$(PINDIR)/include

##########
CFLAGS_solaris= -g -xcg92
CFLAGS_linux= -m32 -fPIC
CFLAGS_hpux= -g -Ae +Z +DAportable
CFLAGS_hpux_ia64= -g -Ae +Z 
CFLAGS_aix= -g -Drs6000 -D__aix -Dunix -D__unix -w -q32
CFLAGS= $(CFLAGS_$(OS)) -DFOR_CM -DFM_TRANS_POL_DLL

CPPFLAGS = -I$(INCDIR) -DPCMCPP_CONST_SAFE -DFOR_CM -DFM_TRANS_POL_DLL

LDFLAGS_solaris= -G
LDFLAGS_linux= -m elf_i386 -shared -L/usr/lib
LDFLAGS_hpux= -b
LDFLAGS_hpux_ia64= -b
LDFLAGS_aix= -G -bnoentry -bexpall -lc
LDFLAGS = $(LDFLAGS_$(OS))

SL_EXT_solaris= so
SL_EXT_linux= so
SL_EXT_hpux= sl
SL_EXT_aix= a
SL_EXT_hpux_ia64= so
SL_EXT= $(SL_EXT_$(OS))


###########

INCFILES= $(INCDIR)/pcm.h $(INCDIR)/pin_errs.h $(INCDIR)/pinlog.h

#

FILES= fm_trans_pol_config.c \
	fm_trans_pol_open.c \
	fm_trans_pol_prep_commit.c \
	fm_trans_pol_commit.c \
	fm_trans_pol_abort.c

OBJECTS= fm_trans_pol_config.o \
	fm_trans_pol_open.o \
	fm_trans_pol_prep_commit.o \
	fm_trans_pol_commit.o \
	fm_trans_pol_abort.o

#

DEP_linux=$(FILES)
DEP=$(DEP_$(OS))
LIBTRANS=fm_trans_pol.$(SL_EXT)

###########

all: $(LIBTRANS)

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBTRANS)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC

###########

$(LIBTRANS): $(OBJECTS) $(INCFILES) Makefile
	$(LD) -o $(LIBTRANS) $(LDFLAGS) $(OBJECTS) -lm

$(OBJECTS): $(INCFILES) Makefile $(DEP)
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $*.c

#

FRC:






