/* Continuus file information --- %full_filespec: pin_gl.h~1:incl:1 % */
/*
 * @(#) %full_filespec: pin_gl.h~1:incl:1 %
 *
 *      Copyright (c) 2000 - 2006 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation or its
 *      licensors and may be used, reproduced, stored or transmitted only in
 *      accordance with a valid Oracle license or sublicense agreement.
 *
 */

#ifndef _PIN_GL_H
#define _PIN_GL_H

/*******************************************************************
 * G/L COA account types.
 *******************************************************************/
#define PIN_GL_COA_ACCT_TYPE_EXPENSE		0x01
#define PIN_GL_COA_ACCT_TYPE_LIABILITY		0x02
#define PIN_GL_COA_ACCT_TYPE_EQUITY		0x04
#define PIN_GL_COA_ACCT_TYPE_REVENUE		0x08
#define PIN_GL_COA_ACCT_TYPE_ASSET		0x10
#define PIN_GL_COA_ACCT_TYPE_UNDEFINED		0x20

/*******************************************************************
 * G/L COA account status.
 *******************************************************************/
#define	PIN_GL_ACCOUNT_ACTIVE			1
#define	PIN_GL_ACCOUNT_INACTIVE			0

/*******************************************************************
 * G/L COA validation status.
 *******************************************************************/
#define	PIN_GL_VALIDATION_PASSED		PIN_BOOLEAN_TRUE
#define	PIN_GL_VALIDATION_FAILED		PIN_BOOLEAN_FALSE

/*******************************************************************
 * G/L COA validation messages.
 *******************************************************************/
#define PIN_GL_ACCT_NOT_FOUND		"Active gl account not found in COA "
#define PIN_GL_OFF_ACCT_NOT_FOUND	"Active gl offset account not found "
#define PIN_GL_INVALID_TYPE_MSG		"Invalid gl account type "
#define PIN_GL_OFF_INVALID_TYPE_MSG	"Invalid gl offset account type "
#define PIN_GL_SAME_ACCOUNT_TYPE_MSG	"Both Credit and Debit accts. are same "

#endif /*_PIN_GL_H*/
