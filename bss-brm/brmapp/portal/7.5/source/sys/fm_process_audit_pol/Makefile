########### 
#
# Copyright (c) 2003, 2014, Oracle and/or its affiliates. All rights reserved.
#
#     This material is the confidential property of Oracle Corporation
#     or licensors and may be used, reproduced, stored or transmitted
#     only in accordance with a valid Oracle license or sublicense agreement.
#
#
###########

# this is the Make.user for All_Server/fm_policy/fm_process_audit_pol

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
CFLAGS_aix= -Drs6000 -Dunix -D__unix -D__aix
CFLAGS_hpux= -g -Ae +Z +DAportable
CFLAGS_hpux_ia64= -g -Ae +Z 
CFLAGS= $(CFLAGS_$(OS)) -DFLIST_HEAP

CPPFLAGS = -I$(INCDIR)

LDFLAGS_solaris= -G
LDFLAGS_linux= -m elf_i386 -shared
LDFLAGS_aix= -G -bexpall -bnoentry
LDFLAGS_hpux= -b
LDFLAGS_hpux_ia64= -b
LDFLAGS = $(LDFLAGS_$(OS))

SL_EXT_solaris= so
SL_EXT_linux= so
SL_EXT_aix= a 
SL_EXT_hpux= sl
SL_EXT_hpux_ia64= so
SL_EXT= $(SL_EXT_$(OS))

OS_LIBS_solaris= -lm
OS_LIBS_hpux= -lsec -lm
OS_LIBS_hpux_ia64= -lm
OS_LIBS_aix= -lm -lc
OS_LIBS_linux= -lm
OS_LIBS= $(OS_LIBS_$(OS))

INCFILES= $(INCDIR)/pcm.h $(INCDIR)/pin_errs.h $(INCDIR)/pinlog.h \
	$(INCDIR)/pin_flds.h

############

FILES= fm_process_audit_pol_config.c \
	fm_process_audit_pol_create.c \
	fm_process_audit_pol_create_and_link.c \
	fm_process_audit_pol_alert.c \
	fm_process_audit_pol_create_writeoff_summary.c

OBJECTS= fm_process_audit_pol_config.o \
	fm_process_audit_pol_create.o \
	fm_process_audit_pol_create_and_link.o \
	fm_process_audit_pol_alert.o \
	fm_process_audit_pol_create_writeoff_summary.o

############

LIBPUBLISH=fm_process_audit_pol_create_custom.$(SL_EXT)

###########

all: $(LIBPUBLISH) 

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBPUBLISH) 

lint:
	$(LINT) $(CPPFLAGS) $(FILES)

###########

$(LIBPUBLISH): $(OBJECTS)
	$(LD) -o $(LIBPUBLISH) $(LDFLAGS) $(OS_LIBFLGS) $(OBJECTS) $(OS_LIBS)

$(OBJECTS): $(INCFILES) Makefile
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(FILES) 

###########

FRC:


