/* continuus file information --- %full_filespec: fm_price_pol.h~3:incl:1 % */
/*******************************************************************
 *
 *  @(#) %full_filespec: pin_ipt.h~1:incl:1 %
 *
 *	
 *	Copyright (c) 1996 - 2006 Oracle. All rights reserved.
 *	
 *	This material is the confidential property of Oracle Corporation or its
 *	licensors and may be used, reproduced, stored or transmitted only in
 *	accordance with a valid Oracle license or sublicense agreement.
 *
 *******************************************************************/


#ifndef _PIN_IPT_H_
#define _PIN_IPT_H_

#ifdef __cplusplus
extern "C" {
#endif

/*******************************************************************
 * IPT FM Definitions.
 *******************************************************************/

/* The values below are used in the PIN_FLD_MODE field.
 * This field defines the mode of the list  PIN_FLD_FILTER_LIST
 */

#define         PIN_IPT_MODE_UNDEFINED	0
#define		PIN_IPT_MODE_ALLOW	1
#define		PIN_IPT_MODE_BLOCK	2

/*
 * Warning codes used by PCM_OP_IPT_SET_CALL_FEATURES
 */
#define	PIN_IPT_NO_CONFLICT				0x00
#define	PIN_IPT_SPEED_DIAL_CONFLICT_WITH_FILTER_LIST	0x01
#define	PIN_IPT_REDIRECT_CONFLICT_WITH_FILTER_LIST	0x02
#define	PIN_IPT_DUPLICATE_FILTER_ENTRIES		0x04
#define	PIN_IPT_DUPLICATE_REDIRECT_ENTRIES		0x08
/*
 * Error codes used by PCM_OP_IPT_AUTHORIZE
 */
/* */

typedef u_int32	ipt_matrix_offset_t;
	
/* The set of trie character nodes */
#define IPT_CAAR_CHARSETSIZE	12

/* The value of the first valid character in the character set 
 * "./0123456789"
*/

#define IPT_CAAR_CHARSET_OFFSET '.'

/* VALIDCHARSET is a string that contains the actual valid
 * characters.
 */
#define IPT_CAAR_VALID_CHARS "0123456789."

/* data structures */
/* structure of a single matrix row */
typedef struct TAG_MatrixRowData_t {
	ipt_matrix_offset_t pszOrig;
	ipt_matrix_offset_t pszDest;
	ipt_matrix_offset_t pszRate;
	ipt_matrix_offset_t pszImpact;
	ipt_matrix_offset_t pQos; 
} MatrixRowData_t;

/* a list of matrix row */

typedef struct TAG_MatrixRowList_t {
	ipt_matrix_offset_t next_p;
	ipt_matrix_offset_t data_p;
} MatrixRowList_t;

/* trie node */

typedef struct TAG_TrieNode_t {
	ipt_matrix_offset_t children[IPT_CAAR_CHARSETSIZE];
	int isTerminal;
	ipt_matrix_offset_t datalist_p;
} TrieNode_t;

typedef struct TAG_Blob_t {
	u_int32	version;
	u_int32	blob_size;
	u_int32	node_size;
	u_int32 list_size;
	u_int32	data_size;
	ipt_matrix_offset_t	trie_start;
	ipt_matrix_offset_t	list_start;
	ipt_matrix_offset_t	data_start;
} Blob_t;

#ifdef __cplusplus
}
#endif

#endif /*_PIN_IPT_H_*/
