###########
#
# (#)Make.user (1.1)
#
# Copyright (c) 1999, 2010, Oracle and/or its affiliates. All rights reserved. 
#
#       This material is the confidential property of Oracle Corporation
#       or its subsidiaries or licensors and may be used, reproduced, stored
#       or transmitted only in accordance with a valid Oracle license or
#       sublicense agreement.
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
LDFLAGS_aix= -G -bexpall -bnoentry
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

FILES= fm_price_pol_config.c \
	fm_price_pol_delete_deal.c \
	fm_price_pol_delete_product.c \
	fm_price_pol_delete_dependency.c \
	fm_price_pol_delete_transition.c \
	fm_price_pol_delete_discount.c \
	fm_price_pol_prep_deal.c \
	fm_price_pol_prep_product.c \
	fm_price_pol_prep_dependency.c \
	fm_price_pol_prep_transition.c \
	fm_price_pol_prep_discount.c \
	fm_price_pol_valid_deal.c \
	fm_price_pol_valid_product.c \
	fm_price_pol_valid_dependency.c \
	fm_price_pol_valid_transition.c \
	fm_price_pol_valid_discount.c 

OBJECTS= fm_price_pol_config.o \
	fm_price_pol_delete_deal.o \
	fm_price_pol_delete_product.o \
	fm_price_pol_delete_discount.o \
	fm_price_pol_delete_dependency.o \
	fm_price_pol_delete_transition.o \
	fm_price_pol_prep_deal.o \
	fm_price_pol_prep_product.o \
	fm_price_pol_prep_dependency.o \
	fm_price_pol_prep_transition.o \
	fm_price_pol_prep_discount.o \
	fm_price_pol_valid_deal.o \
	fm_price_pol_valid_product.o \
	fm_price_pol_valid_dependency.o \
	fm_price_pol_valid_transition.o \
	fm_price_pol_valid_discount.o 

#

LIBPRICE=fm_price_pol_custom.$(SL_EXT)

###########

all: $(LIBPRICE)

clean:
	rm -f $(OBJECTS) core

clobber: clean
	rm -f $(LIBPRICE)

lint:
	lint $(CPPFLAGS) $(FILES)

tags: FRC

###########

$(LIBPRICE): $(OBJECTS) $(INCFILES) Makefile
	$(LD) -o $(LIBPRICE) $(LDFLAGS) $(OBJECTS) -lm

$(OBJECTS): $(INCFILES) Makefile
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $(FILES)

#

FRC:
