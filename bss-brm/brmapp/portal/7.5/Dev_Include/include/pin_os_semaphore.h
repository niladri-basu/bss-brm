/*
 *	@(#) % %
 *
 *      Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *       
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _pin_os_semaphore_h_
#define _pin_os_semaphore_h_

#if defined(WIN32)

#define DLL_SPEC (BUILDING_PINOS == 1)
#include <dlldef.h>
typedef void* sem_t;

PUBLIC int sem_init(sem_t* sem, int pshared, unsigned int value);
PUBLIC int sem_wait(sem_t* sem);
PUBLIC int sem_post(sem_t* sem);

#elif defined(__unix)

#if defined(__hpux)
#define _INCLUDE_POSIX4_SOURCE
#endif

#include <semaphore.h>

#endif

#endif
