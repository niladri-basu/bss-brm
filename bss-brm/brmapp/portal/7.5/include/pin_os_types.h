/*
 *      @(#)%Portal Version: pin_os_types.h:RWSmod7.3.1Int:1:2007-Oct-09 02:27:45 %
 *
 *      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *      
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _pin_os_types_h_
#define _pin_os_types_h_

#if defined(sparc) || defined(mc68000) || defined(__hp9000s800) || defined(__linux) || defined(BSDI) || defined(rs6000) || defined(__ia64)
    #define HAS_LONGLONG
#elif defined(WIN32)
    #define HAS_INT64
#else
    #error Do not know the int size on your architecture!
#endif

#ifndef _PIN_TYPE_H_
  #include "pin_type.h"
#endif

#endif
