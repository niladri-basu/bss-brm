/*
 *	@(#) % %
 *
 *	Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *       
 *	This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _pin_os_signal_h_
#define _pin_os_signal_h_

#if defined(__hpux)
#define _XOPEN_SOURCE_EXTENDED
#endif

#include <signal.h>

#if defined(__unix)

#define HAS_SIGACTION

#endif

#endif
