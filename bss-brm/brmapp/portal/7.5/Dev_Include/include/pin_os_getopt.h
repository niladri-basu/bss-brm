/*
 *	@(#)%Portal Version: pin_os_getopt.h:PlatformR2Int:1:2006-Sep-12 03:31:44 %
 *
 *      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *       
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _pin_os_getopt_h_
#define _pin_os_getopt_h_

/* NOTE: getopt() is not MT-safe */
#if defined(WIN32)

#if defined(__cplusplus)
extern "C" {
#endif

#define DLL_SPEC (BUILDING_PINOS == 1)
#include <dlldef.h>

/* Note that opterr, optind and optarg are accessible via
 * functions here since global variables are not
 * properly accessible in a DLL
 */

PUBLIC int getopt(int argc, char **argv, const char *opts);
extern char *optarg;  /* for imitation unix getopt () */
extern int optind;
extern int opterr;
extern int optopt;

#if defined(__cplusplus)
}
#endif

#elif defined(__unix)
#include <stdlib.h>
#include <unistd.h>
#endif

#endif
