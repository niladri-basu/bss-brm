###########
#
# Copyright (c) 2005, 2010, Oracle and/or its affiliates. All rights reserved. 
#
#      This material is the confidential property of Oracle Corporation or its
#      licensors and may be used, reproduced, stored or transmitted only in
#      accordance with a valid Oracle license or sublicense agreement.
#
###########

OS=linux
VERSION=7.5

####

PINDIR=../../..
INCDIR=$(PINDIR)/include
LIBDIR=$(PINDIR)/lib

##########
CC_solaris = cc
CC_hpux = cc
CC_hpux_ia64 = cc
CC_aix = xlc_r
CC_linux = gcc
CC = $(CC_$(OS))

##########

CFLAGS_solaris= -g -xcg92
CFLAGS_hpux= -g -Ae +Z +DAportable
CFLAGS_hpux_ia64= -g -Ae +Z 
CFLAGS_aix= -g -Drs6000 -D__aix -Dunix -D__unix
CFLAGS_linux=  -m32 -fPIC
CFLAGS= $(CFLAGS_$(OS)) -DFOR_CM -DFM_BAL_POL_DLL

CPPFLAGS = -I$(INCDIR) -DPCMCPP_CONST_SAFE -DFOR_CM -DFM_BAL_POL_DLL

LDFLAGS_solaris= -G
LDFLAGS_hpux= -b
LDFLAGS_hpux_ia64= -b
LDFLAGS_aix= -G -bnoentry -bexpall -lc
LDFLAGS_linux=  -m elf_i386 -shared -L/usr/lib
LDFLAGS = $(LDFLAGS_$(OS)) -L$(LIBDIR)

SL_EXT_solaris= so
SL_EXT_hpux= sl
SL_EXT_hpux_ia64= so
SL_EXT_aix= a
SL_EXT_linux= so
SL_EXT= $(SL_EXT_$(OS))

###########

INCFILES= $(INCDIR)/pin_cust.h $(INCDIR)/pcm.h \
	$(INCDIR)/pin_errs.h $(INCDIR)/pinlog.h \
	$(INCDIR)/pin_act.h $(INCDIR)/pin_bill.h \
	$(INCDIR)/pin_flds.h $(INCDIR)/pin_currency.h

#

FILES= fm_bal_pol_config.c \
	fm_bal_pol_get_bal_grp_and_svc.c


#

OBJECTS= fm_bal_pol_config.o \
	fm_bal_pol_get_bal_grp_and_svc.o

LIBBAL=fm_bal_pol.$(SL_EXT)

###########

all: $(LIBBAL)

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBBAL)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC


###########

$(LIBBAL): $(OBJECTS) $(INCFILES) Makefile
	$(LD) -o $(LIBBAL) $(LDFLAGS) $(OBJECTS) -lm -lpsiu_for_cm

$(OBJECTS): $(INCFILES) Makefile $(FILES)
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $*.c

#

FRC:

