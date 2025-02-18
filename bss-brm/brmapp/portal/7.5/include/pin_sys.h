/*
 *	@(#) % %
 *	
 *	Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *	
 *	This material is the confidential property of Oracle Corporation or its
 *	licensors and may be used, reproduced, stored or transmitted only in
 *	accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef _pin_sys_h_
#define _pin_sys_h_

#ifdef WIN32
  #define PIN_EXPORT  __declspec(dllexport)
  #define PIN_IMPORT  __declspec(dllimport)
  #define PIN_THD_VAR __declspec(thread)

  /* other */
  #define pin_popen			_popen
  #define pin_pclose			_pclose

  /* #define sleep(x)			Sleep(x * 1000) */

#else /* WIN32 */
  #define PIN_EXPORT

  #define PIN_IMPORT extern

  #define PIN_THD_VAR

  /* tempnam */
  #define _tempnam(dir, pfx)		tempnam((dir), (pfx))

  /* other */
  #define pin_popen			popen
  #define pin_pclose			pclose

#endif /* WIN32 */

/* sockets */
#ifndef _pin_os_network_h_
  #include <pin_os_network.h>
#endif

/* threads */
#ifndef _pin_os_thread_h_
  #include <pin_os_thread.h>
#endif

#endif /* PIN_SYS_H */
