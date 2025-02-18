/*
 *	@(#)%Portal Version: pin_os_random.h:PlatformR2Int:1:2006-Sep-12 03:31:54 %
 *       
 *      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *      	 
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _pin_os_random_h_
#define _pin_os_random_h_

#ifndef _pin_os_types_h_
#include <pin_os_types.h>
#endif

#if defined(__cplusplus)
extern "C" {
#endif

/** Generate a random integral number
  *
  * This function returns a random integral number. In order to be thread
  * safe, this function requires you to provide the seed value, instead of
  * calling a separate seed function. You must set the seed value initially
  * and then pass in the pointer to this seed on each successive call to this
  * function. The seed value will be updated on each call, so basically you
  * are providing the function with a thread safe scratch pad.
  *
  * @param  seed    The ongoing seed value. See the function description for
  *                 details.
  *
  * @return The next available number in the random sequence.
  */
int32 pin_random(int32* const seed);


/** Generate a random floating point number
  *
  * The number returned by this function will be uniformily distributed over
  * the range 0.0 to 1.0. In order to be thread safe, this function requires
  * you to provide the seed value, instead of calling a separate seed function.
  * You must set the seed value initially and then pass in the pointer to this
  * seed on each successive call to this function. The seed value will be
  * updated on each call, so basically you are providing the function with a
  * thread safe scratch pad.
  *
  * @param  p_seed  The seed value. You must initialize it once, then pass it
  *                 back in on each subsequent call to pin_random(). Basically
  *                 you are providing it a scratch pad area, so that it can be
  *                 thread safe.
  *
  * @return The next available number in the random sequence.
  */
double pin_drand48(u_int64* const p_seed);


/** Generate a random floating point number
  *
  * The number returned by this function will be uniformily distributed over
  * the range 0.0 to 1.0. In order to be thread safe, this function requires
  * you to provide the seed value, instead of calling a separate seed function.
  * You must set the seed value initially and then pass in the pointer to this
  * seed on each successive call to this function. The seed value will be
  * updated on each call, so basically you are providing the function with a
  * thread safe scratch pad.
  *
  * @param  p_seed  The seed value. You must initialize it once, then pass it
  *                 back in on each subsequent call to pin_random(). Basically
  *                 you are providing it a scratch pad area, so that it can be
  *                 thread safe.
  *
  * @return The next available number in the random sequence.
  */
u_int32 pin_lrand48(u_int64* const p_seed);

#if defined(__cplusplus)
}
#endif

#endif

