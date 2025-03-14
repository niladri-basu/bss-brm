###########
#
# @(#)% Make.user (3) %
#
# Copyright (c) 2004, 2013, Oracle and/or its affiliates. All rights reserved. 
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

C++_solaris = CC
C++_hpux = aCC
C++_hpux_ia64 = aCC
C++_aix = xlC
C++_linux = gcc
C++ = $(C++_$(OS))
##########

CFLAGS_solaris= -g -xcg92
CFLAGS_hpux= -g -Ae +Z +DAportable
CFLAGS_hpux_ia64= -g -Ae +Z 
CFLAGS_aix= -g -Drs6000 -D__aix -Dunix -D__unix
CFLAGS_linux= -m32 -fPIC
CFLAGS= $(CFLAGS_$(OS)) -D_REENTRANT -DFOR_CM -DFM_BILL_POL_DLL

C++FLAGS_solaris= -g -library=%none -DPIN_NOT_USING_OSTREAM
C++FLAGS_hpux= -g -AA +Z +DAportable +nostl -DPIN_NOT_USING_OSTREAM -I/usr/include -I/opt/aCC/include -I/usr
C++FLAGS_hpux_ia64= -g -AA +Z +nostl -DPIN_NOT_USING_OSTREAM -I/usr/include -I/opt/aCC/include -I/usr
C++FLAGS_aix= -g -Drs6000 -D__aix -Dunix -D__unix
C++FLAGS_linux = -x c++ -m32 -DPIN_NOT_USING_OSTREAM
C++FLAGS= $(C++FLAGS_$(OS)) -DPCMCPP_CONST_SAFE


CPPFLAGS = -I$(INCDIR) -DPCMCPP_CONST_SAFE -DFOR_CM -DFM_BILL_POL_DLL

LDFLAGS_solaris= -G
LDFLAGS_hpux= -b
LDFLAGS_hpux_ia64= -b
LDFLAGS_aix= -G -bnoentry -bexpall -brtl -lc
LDFLAGS_linux= -m32 -shared
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

FILES= fm_bill_pol_config.c \
	fm_bill_pol_init.c \
	fm_bill_pol_spec_billno.c \
	fm_bill_pol_valid_dispute.c \
	fm_bill_pol_valid_settlement.c \
	fm_bill_pol_valid_adjustment.c \
	fm_bill_pol_valid_transfer.c \
	fm_bill_pol_valid_writeoff.c \
	fm_bill_pol_bill_pre_commit.c \
	fm_bill_pol_spec_future_cycle.c \
	fm_bill_pol_get_pending_items.c \
	fm_bill_pol_get_event_specific_details.c \
	fm_bill_pol_post_billing.c \
	fm_bill_pol_check_suppression.c \
	fm_bill_pol_calc_pymt_due_t.c \
	fm_bill_pol_event_search.c \
	fm_bill_pol_reverse_payment.c \
	fm_bill_pol_config_billing_cycle.c

#

OBJECTS= fm_bill_pol_config.o \
	fm_bill_pol_init.o \
	fm_bill_pol_spec_billno.o \
	fm_bill_pol_valid_dispute.o \
	fm_bill_pol_valid_settlement.o \
	fm_bill_pol_valid_adjustment.o \
	fm_bill_pol_valid_transfer.o \
	fm_bill_pol_valid_writeoff.o \
	fm_bill_pol_bill_pre_commit.o \
	fm_bill_pol_spec_future_cycle.o \
	fm_bill_pol_get_pending_items.o \
	fm_bill_pol_get_event_specific_details.o \
	fm_bill_pol_post_billing.o \
	fm_bill_pol_check_suppression.o \
	fm_bill_pol_calc_pymt_due_t.o \
	fm_bill_pol_event_search.o \
	fm_bill_pol_reverse_payment.o \
	fm_bill_pol_config_billing_cycle.o

#

C++_FILES= fm_bill_pol_get_item_tag.cpp

C++_OBJECTS= fm_bill_pol_get_item_tag.o

LIBBILL=fm_bill_pol_custom.$(SL_EXT)

###########

all: $(LIBBILL)

clean:
	rm -f $(OBJECTS) $(C++_OBJECTS) core

clobber: clean
	rm -f $(LIBBILL)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC


###########

$(LIBBILL): $(OBJECTS) $(C++_OBJECTS) $(INCFILES) Makefile
	$(C++) -o $(LIBBILL) $(LDFLAGS) $(OBJECTS) $(C++_OBJECTS) -lm -lpsiu_for_cm

$(OBJECTS): $(INCFILES) Makefile $(FILES)
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(FILES)

$(C++_OBJECTS): $(INCFILES) Makefile $(C++_FILES)
	$(C++) -c $(C++FLAGS) $(CPPFLAGS) $(C++_FILES)

#

FRC:

