##########
#      @(#)% %
#
# Copyright (c) 2002, 2014, Oracle and/or its affiliates. All rights reserved.
#
#       This material is the confidential property of Oracle Corporation or its
#       licensors and may be used, reproduced, stored or transmitted only in
#       accordance with a valid Oracle license or sublicense agreement.
#
###########

OS=linux
PIN_VERSION=7.5

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
CFLAGS= $(CFLAGS_$(OS)) -DFLIST_HEAP

CPPFLAGS = -I$(INCDIR)

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

###########

INCFILES= $(INCDIR)/pin_cust.h $(INCDIR)/pcm.h \
	$(INCDIR)/pin_errs.h $(INCDIR)/pinlog.h

#
FILES= fm_ifw_sync_pol_config.c \
	fm_ifw_sync_pol_publish_event.c 

OBJECTS= fm_ifw_sync_pol_config.o \
	fm_ifw_sync_pol_publish_event.o 

#

LIBIFWSYNCPOL=fm_ifw_sync_pol_custom.$(SL_EXT)

###########

all: $(LIBIFWSYNCPOL)

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBIFWSYNCPOL)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC

###########

$(LIBIFWSYNCPOL): $(OBJECTS) $(INCFILES) Makefile
	$(LD) -o $(LIBIFWSYNCPOL) $(LDFLAGS) $(OBJECTS) -lm

$(OBJECTS): $(INCFILES) Makefile
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(FILES)

#

FRC:
