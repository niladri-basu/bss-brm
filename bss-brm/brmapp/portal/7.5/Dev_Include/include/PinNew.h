/*
 *      @(#) % %
 *      
 *      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *      
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _PinNew_H_
#define _PinNew_H_

#ifndef WIN32
#ifndef _RWSTD_NEW_INCLUDED
    #include <new>
#endif
#endif

class PinBadAlloc {
public:
	PinBadAlloc() 
	{}
};


#endif /*_PinNew_H_*/

