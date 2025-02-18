/*
 *	@(#) % %
 *      
 *      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *      
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _pin_os_export_h
#define _pin_os_export_h

/*
 *  This one is for unconditional export from a c/cpp file, which is used
 *  in FMs to export dynamically loaded entry points.
 */
#ifdef WIN32
#ifdef __cplusplus
#define EXPORT_OP extern "C" __declspec(dllexport)
#else
#define EXPORT_OP __declspec(dllexport)
#endif
#else
#ifdef __cplusplus
#define EXPORT_OP extern "C"
#else
#define EXPORT_OP
#endif
#endif

/* For compatibility with various incarnations of this.
 * REVISIT: We need to agree on one name before we ship
 */
#define PORTAL_FM_EXPORT EXPORT_OP
#define PORTAL_FUNCEXPORT EXPORT_OP

#endif
