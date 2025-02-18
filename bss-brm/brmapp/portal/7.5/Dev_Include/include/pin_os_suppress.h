/*
 *	@(#) % %
 *      
 *      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *      
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

//
//  This file contains some standard error suppression pragmas, to get rid
//  of some warnings that are beyond our control, and which are littering the
//  build output. If this file is included into any of your files, then its
//  something that you should revisit occiasionally, by removing it and seeing
//  what warnings you are still getting. If it is no longer needed, then remove
//  it from your code.
//


#ifndef _pin_os_suppress_h_
#define _pin_os_suppress_h_

#ifdef WIN32

//
//  Disable the 'id truncated' error, which is caused by the MS STL collections,
//  but shows up in our build because the error is in templatized code.
//
#pragma warning(disable : 4786 4503)

#endif

#endif

