/* file information --- @(#)%Portal Version: pin_cc_patterns.h:BillingVelocityInt:4:2008-Jul-07 21:56:31 % */
/*
 * Copyright (c) 1999, 2008, Oracle. All rights reserved.  
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */
#ifndef PIN_CC_PATTERNS_H
#define PIN_CC_PATTERNS_H

#include "pin_cc.h"
#include "pcm.h"

#ifdef WIN32
#ifdef PIN_CC_DLL
#define PIN_CC_EXTERN __declspec(dllexport)
#else
#define PIN_CC_EXTERN __declspec(dllimport)
#endif
#else
#define PIN_CC_EXTERN extern
#endif

PIN_CC_EXTERN int pin_cc_pattern_match(char *cardnum, char *format, 
		pin_errbuf_t *ebuf);

/*******************************************************************
 * Credit card number patterns - these are used to determine what
 *   kind of credit card it is.  
 *******************************************************************/

#define CC_AMERICAN_EXPRESS_PATTERN	"^37[0-9]{13}$|^34[0-9]{13}$"
#define CC_CARTE_BLANCHE_PATTERN	"^94[0-9]{12}$|^95[0-9]{12}$|^389[0-9]{11}$"
#define CC_DINERS_CLUB_PATTERN		"^30[0-9]{12}$|^36[0-9]{12}$|^38[1-8][0-9]{11}$"
/*******************************************************************
*
* Following are the different range for DISCOVER CARD numbers
*
*        60110000 - 60110999
*        60112000 - 60114999
*        60117400 - 60117499
*        60117700 - 60117999
*        60118600 - 60119999
*        62212600 - 62292599
*        64400000 - 64499999
*        65000000 - 65999999
*
* The patterns given below match these range of numbers assuming
* that total length of all these numbers is 16 digit, i.e., the
* 8 digit No.s as specified in range plus additional 8 digits.
*
***********************************************************************/

#define CC_DISCOVER_CARD_PATTERN	"^60110[0-9]{11}$|\
^6011[2-4][0-9]{11}$|\
^601174[0-9]{10}$|\
^60117[7-9][0-9]{10}$|\
^60118[6-9][0-9]{10}$|\
^60119[0-9]{11}$|\
^62212[6-9][0-9]{10}$|\
^6221[3-9][0-9]{11}$|\
^622[2-8][0-9]{12}$|\
^6229[01][0-9]{11}$|\
^62292[0-5][0-9]{10}$|\
^644[0-9]{13}$|\
^65[0-9]{14}$"
/**Following Numbers commenting presently as per E-mail from PaymentTech 
^624518[0-9]{10}$|^638888[0-9]{10}$|^685800[0-9]{10}$\
^940078[0-9]{10}$|\
^95555[4-9][0-9]{10}$|^95559[0-3][0-9]{10}$|^955998[0-9]{10}$|\
^96880[0-5][0-9]{10}$|^98430[2-3][0-9]{10}$|^99880[1-2][0-9]{10}$"
******************/
#define CC_JCB_PATTERN			"^3528[0-9]{12}$|\
^3529[0-9]{12}$|^3530[0-9]{12}$|^3531[0-9]{12}$|\
^3532[0-9]{12}$|^3533[0-9]{12}$|^3534[0-9]{12}$|\
^3535[0-9]{12}$|^3536[0-9]{12}$|^3537[0-9]{12}$|\
^3538[0-9]{12}$|^3539[0-9]{12}$|^3540[0-9]{12}$|\
^3541[0-9]{12}$|^3542[0-9]{12}$|^3543[0-9]{12}$|\
^3544[0-9]{12}$|^3545[0-9]{12}$|^3546[0-9]{12}$|\
^3547[0-9]{12}$|^3548[0-9]{12}$|^3549[0-9]{12}$|\
^3550[0-9]{12}$|^3551[0-9]{12}$|^3552[0-9]{12}$|\
^3553[0-9]{12}$|^3554[0-9]{12}$|^3555[0-9]{12}$|\
^3556[0-9]{12}$|^3557[0-9]{12}$|^3558[0-9]{12}$|\
^3559[0-9]{12}$|^3560[0-9]{12}$|^3561[0-9]{12}$|\
^3562[0-9]{12}$|^3563[0-9]{12}$|^3564[0-9]{12}$|\
^3565[0-9]{12}$|^3566[0-9]{12}$|^3567[0-9]{12}$|\
^3568[0-9]{12}$|^3569[0-9]{12}$|^3570[0-9]{12}$|\
^3571[0-9]{12}$|^3572[0-9]{12}$|^3573[0-9]{12}$|\
^3574[0-9]{12}$|^3575[0-9]{12}$|^3576[0-9]{12}$|\
^3577[0-9]{12}$|^3578[0-9]{12}$|^3579[0-9]{12}$|\
^3580[0-9]{12}$|^3581[0-9]{12}$|^3582[0-9]{12}$|\
^3583[0-9]{12}$|^3584[0-9]{12}$|^3585[0-9]{12}$|\
^3586[0-9]{12}$|^3587[0-9]{12}$|^3588[0-9]{12}$|\
^3589[0-9]{12}$"
#define CC_MASTER_CARD_PATTERN		"^5[1-5][0-9]{14}$"
#define CC_OPTIMA_PATTERN		"^37[1-9]7[0-9]{11}$"
#define CC_SWITCH_PATTERN		"^49[0-9]{14}$|^49[0-9]{16}$|^49[0-9]{17}$|^56[0-9]{14}$|^56[0-9]{16}$|^56[0-9]{18}$|^6[0-9]{15}$|^6[0-9]{17}$|^6[0-9]{18}$"
#define CC_VISA_PATTERN			"^4[0-9]{12}$|^4[0-9]{15}$"

#endif /* PIN_CC_PATTERNS_H */
