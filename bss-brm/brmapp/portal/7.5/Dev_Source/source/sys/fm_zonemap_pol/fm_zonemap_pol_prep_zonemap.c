/**************************************************************************
*
*	fm_zonemap_pol_prep_zonemap.c
*
* Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
*
*      This material is the confidential property of Oracle Corporation
*      or licensors and may be used, reproduced, stored or transmitted only 
*      in accordance with a valid Oracle license or sublicense agreement.
*
**************************************************************************/
#ifndef lint
static char *_csrc = "@(#)$Id: fm_zonemap_pol_prep_zonemap.c /cgbubrm_7.3.2.idcmod/1 2009/04/12 22:23:36 lnandi Exp $";
#endif

#ifndef WIN32
#include <sys/types.h>
#include <netinet/in.h>
#endif
#include <malloc.h>
#include <stdio.h>
#include <string.h>

#include "pcm.h"
#include "ops/zonemap.h"
#include "pinlog.h"
#include "cm_fm.h"
#include "pin_errs.h"
#include "pin_zonemap.h"
#include "fm_zonemap_pol.h"

#ifdef _DEBUG
#define IPT_DEBUG
#endif

/* global values */
/* base address of the blob */
telephony_offset_t blob_base_addr;
/* current offset of the trie node block */
char *trie_vp;
/* current offset of the data node block */
char *data_vp;
/* current offset of the zones block */
char *zone_vp;
/* current offset of the zones data block */
char *zone_data_vp;

/*****************************************************************
 * Temporary table data structure
 *
 *	| phone number/IP address	| ancestor element id array	|
 *	---------------------------------------------------------
 *	|		415		|	{0, 0, 0, 1}		|
 *****************************************************************/
typedef struct TAG_TmpTableRowData_t {
	char			*content_p;
	int32			*ancestors_a;
} tmp_table_row_data_t;

typedef tmp_table_row_data_t* table_row_t;

/********************************************************************
 * Rountines used within
 ********************************************************************/
static int32 
fm_zonemap_pol_get_num_of_nodes(
	table_row_t		*tablep,
	int32			table_size,
	int32			*node_data_size,
	pin_errbuf_t		*ebufp);

static void 
fm_zonemap_pol_fill_blob(
	table_row_t		*tablep,
	Blob_t			*blobpp,
	pin_flist_t		*error_flistp,
	pin_errbuf_t		*ebufp);

static void 
fm_zonemap_pol_insert_path_to_trie(
	int32			path_a[],
	char			*str,
	telephony_offset_t	*nodep,
	pin_flist_t		*error_flistp,
	pin_errbuf_t		*ebufp);

static void 
fm_zonemap_pol_insert_path(
	int32			path_a[],
	TrieNode_t		*nodep,
	pin_flist_t		*error_flistp,
	pin_errbuf_t		*ebufp);

static int32
fm_util_ipt_canon_phone_number(
	char			*pszIn, 
	char			*pszOut);

static void 
fm_zonemap_pol_create_tmp_table(
	pin_flist_t		*zone_flistp,
	table_row_t		*tablep,
	int32			path_a[],
	int32			size,
	int32			*cur,
	pin_errbuf_t		*ebufp);

static int32	
fm_zonemap_pol_get_tmp_table_size(
	pin_flist_t		*zone_flistp,
	pin_errbuf_t		*ebufp) ;

static int32
fm_util_zonemap_compare_row(
	const void		*arg1_p,
	const void		*arg2_p);

static void
dealloc_tmp_table(table_row_t *tablep);


/*******************************************************************
 * Function bodies.
 *******************************************************************/

/*******************************************************************
 * fm_zonemap_pol_construct_blob
 * save the flist and the trie in a single block of memory
 *******************************************************************/

void  
fm_zonemap_pol_construct_blob(
	pin_flist_t		*zonemap_flistp,
	pin_flist_t		*return_flistp,
	pin_errbuf_t		*ebufp)
{
	Blob_t			*blob_base_p = NULL;
	pin_buf_t		*bufp = NULL;
	tree_node_data_t	*zonetreep = NULL;	
	pin_flist_t		*e_flistp = NULL;
	pin_errbuf_t		local_ebuf;

	/* a temporary table created in order to figure out */
	/* the size of trie and to help construct the trie. */
	table_row_t		*tablep = (table_row_t *)NULL;


	int32			node_count = 0;
	int32			zone_count = 0;
	int32			blob_size = 0;
	int32			node_size = 0;
	int32			data_size = 0;
	int32			table_size = 0;
	int32			zone_node_size = 0;
	int32			zone_data_size = 0;
	int32			path_a[PIN_MAX_PATH];
	int32			result = PIN_RESULT_PASS;
	pin_zonemap_err_t	res_code = PIN_ZONEMAP_ERR_NONE;
	int32			i = 0;
	int32			cur_row = 0;


	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERR_CLEAR_ERR(ebufp);	

	/*
	 * Check to see if zonemap_flistp is null or not,
	 * and if it is null, exit without further 
	 * processing. However, it is not considered 
	 * as an error condition.
	 */	
	if (zonemap_flistp == NULL) {
		bufp = (pin_buf_t *)malloc(sizeof(pin_buf_t));
		if (!bufp) {
			pin_set_err(ebufp, PIN_ERRLOC_FM,
				PIN_ERRCLASS_APPLICATION,
				PIN_ERR_NO_MEM, 0, 0, 0);
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
				"Memory allocation error in constructing "
				"zonemap data.", ebufp);
			return;
		}
		bufp->flag = 0;
		bufp->size = 0;
		bufp->offset = 0;
		bufp->data = (char *)NULL;
		bufp->xbuf_file = (char *)NULL;
		PIN_FLIST_FLD_PUT(return_flistp,
			PIN_FLD_ZONEMAP_DATA_DERIVED, (void *)bufp, ebufp);
		return;
	}

	/* Create a tmp table for easy traverse */
	for (i = 0; i < PIN_MAX_PATH; i++) {
		path_a[i] = 0;
	}

	table_size = fm_zonemap_pol_get_tmp_table_size(zonemap_flistp, ebufp);
	
	if (table_size != 0) {
		tablep = (table_row_t *)malloc(sizeof(table_row_t)*
			(table_size + 1));
		if (tablep != NULL) {
			for (i = 0; i < table_size; i++) {
				tablep[i] = (tmp_table_row_data_t *)NULL;
			}
			fm_zonemap_pol_create_tmp_table(zonemap_flistp,
				tablep, path_a, 0, &cur_row, ebufp);
			*(tablep+table_size) = (tmp_table_row_data_t *)NULL;
		}
		else {
			pin_set_err(ebufp, PIN_ERRLOC_FM,
				PIN_ERRCLASS_APPLICATION,
				PIN_ERR_NO_MEM, 0, 0, 0);
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
				"Memory allocation error in constructing "
				"blob.", ebufp);
			return;
		}
	}
	else {
		tablep = (table_row_t *)NULL;
	}

	/* get number of trie nodes and the data size */
	node_count = fm_zonemap_pol_get_num_of_nodes(tablep,
		table_size, &data_size, ebufp);
	
	/*
	 * Get the number of zones and the size of serialized zone tree.
	 */
	zone_count = fm_zonemap_pol_serialize_get_size(zonemap_flistp, 
		&zone_data_size, ebufp);
	zone_node_size = sizeof(tree_node_data_t)*zone_count;

	/***************************************************
	* The format of the blob is:
	* | blob header | trie nodes | data nodes | zones |
	*       
	*	blob header 
	*		|
	*		 ------ | version		|
	*				| blob size	|
	*				| node size	|
	*				| data size	|
	*				| zone size	|
	*				| trie start	|
	*				| data start	|
	*				| zone start	|
	*	trie node
	*		|
	*		 ------ | child node	| 
	*				| child node	| 
	*				| child node	| 
	*					...
	*				| terminal flag	|
	*				| leaf addr	|
	*	trie node
	*		|
	*		 ------ ...
	*		...
	*	data node
	*		|
	*		 ------	| ancestor array  |
	*	data node
	*		|
	*		 ------ ...
	*		...
	*	zone node
	*		|
	*		 ------ ...
	*	zone node
	*		|
	*		 ------ ...
	*	zone data node
	*		|
	*		 ------ ...
	****************************************************/
			
	node_size = node_count * sizeof(TrieNode_t);
	blob_size = sizeof(Blob_t) + 
		node_size + 
		data_size +
		zone_node_size +
		zone_data_size;

	ROUNDUP(blob_size, sizeof(int32));

	/* allocate memory for the block */
	blob_base_p = (Blob_t *)malloc(blob_size + 1);
	
	/* check whether the memory is allocated successfully */
	if (blob_base_p == NULL) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_APPLICATION,
			PIN_ERR_NO_MEM, 0, 0, 0);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_zonemap_pol_construct_trie: \
			failed to allocate memory for blob.", ebufp);
	
		return;
	}
	
	/* initialize the blob */
	memset(blob_base_p, 0, (size_t)blob_size + 1);

	/* fill in the blob data */
	blob_base_addr = (telephony_offset_t)blob_base_p;

	trie_vp = (char *)(blob_base_p);
	data_vp = (char *)(blob_base_p);
	
	/* fill header of this blob */
	/* version number of this blob */
	blob_base_p->version = htonl(ZONEMAP_CURRENT_VERSION);
	blob_base_p->blob_size = blob_size;
	trie_vp += (sizeof(Blob_t));
	MEM_ALIGN(trie_vp, sizeof(int32));
		
	/* debug */
	blob_base_p->trie_start = (telephony_offset_t)trie_vp;
	blob_base_p->node_size = node_size;

	data_vp = trie_vp + node_size;
	MEM_ALIGN(data_vp, sizeof(int32));
	
	/* debug */
	blob_base_p->data_start = (telephony_offset_t)data_vp;
	blob_base_p->data_size = data_size;

	zone_vp = data_vp + data_size;
	MEM_ALIGN(zone_vp, sizeof(int32));

	/* debug */
	blob_base_p->zone_start = (telephony_offset_t)zone_vp;
	blob_base_p->zone_size = zone_node_size;

	zone_data_vp = zone_vp + zone_node_size;
	MEM_ALIGN(zone_data_vp, sizeof(int32));

	blob_base_p->zone_data_start = (telephony_offset_t)zone_data_vp;
	blob_base_p->zone_data_size = zone_data_size;

	/*
	 * Create a result flist that stores the error
	 * information when constructing the trie.
	 * For now, the error is none.
	 */
	e_flistp = PIN_FLIST_CREATE(ebufp);
	PIN_FLIST_FLD_SET(e_flistp, PIN_FLD_RESULT,
		(void *)&result, ebufp);
	PIN_FLIST_FLD_SET(e_flistp, PIN_FLD_RESULT_FORMAT,
		(void *)&res_code, ebufp);

	/*
	 * Now fill the trie part of the blob. At the 
	 * same time the error flist will be set
	 * if anything goes wrong.
	 */ 
	fm_zonemap_pol_fill_blob(tablep,
		blob_base_p,
		e_flistp,
		ebufp);
	
#ifdef	IPT_DEBUG
	PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_DEBUG,
			"fm_zonemap_pol_fill_blob: Returned", 
			ebufp);
#endif

	/* Serialize the zonemap tree. */
	zonetreep = (tree_node_data_t *)zone_vp;
	fm_zonemap_pol_serialize_zone_tree(zonemap_flistp, zonetreep, 0,
		ebufp);

	/* if successful */
	if (!PIN_ERR_IS_ERR(ebufp)) {
		/**************************************************
		 * if successful, construct the buffer and put 
		 * it onto return flist.
		 **************************************************/

		/* append null character */
		*((char *)(blob_base_p) + blob_size) = '\0';
		
		/* change the actual address to offset */
		/* and change the byte order from host to network */
		fm_zonemap_pol_post_process_blob(blob_base_p);

		/* No error! Now construct return buffer and return flist */
		bufp = (pin_buf_t *)malloc(sizeof(pin_buf_t));
		if (bufp == NULL) {
			pin_set_err(ebufp, PIN_ERRLOC_FM,
				PIN_ERRCLASS_APPLICATION,
				PIN_ERR_NO_MEM,
				PIN_FLD_ZONEMAP_DATA_DERIVED, 0, 0);
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
				"fm_zonemap_pol_construct_blob:\
				failed to allocate memory", ebufp);
			free((char *)blob_base_p);
			if (e_flistp) {
				PIN_FLIST_DESTROY_EX(&e_flistp, NULL);
			}

			return;
		}
	
		bufp->data = (caddr_t)blob_base_p;
		bufp->size = blob_size + 1;

		bufp->flag = 0;
		bufp->offset = 0;
		bufp->xbuf_file = (char *)NULL;

		 /* Plob buf into flist */
		PIN_FLIST_FLD_PUT(return_flistp, PIN_FLD_ZONEMAP_DATA_DERIVED,
			(void *)bufp, ebufp);
	}
	else {
		free((char *)blob_base_p);
		free((void *)bufp);

		/* Attach the result flist to the output flist. */
		PIN_ERR_CLEAR_ERR(&local_ebuf);
                PIN_FLIST_CONCAT(return_flistp, e_flistp, &local_ebuf);
	}

	/* Clean up. */
	dealloc_tmp_table(tablep);
	if (e_flistp) {
		PIN_FLIST_DESTROY_EX(&e_flistp, NULL);
	}
}

/*******************************************************************
 * dealloc_tmp_table
 * Deallocates all memory in temporary table.
 *******************************************************************/
static void
dealloc_tmp_table(table_row_t *tablep)
{
	table_row_t		*row;

	if (tablep == (table_row_t *)NULL) {
		return;
	}

	for (row = tablep; *row != (table_row_t)NULL; row++) {
		tmp_table_row_data_t *row_data = *row;
		free(row_data->content_p);
		free(row_data->ancestors_a);
		free(row_data);
	}
	free(tablep);
}
	
/*******************************************************************
 * fm_zonemap_pol_fill_blob
 * converts the zonemap into a trie
 *******************************************************************/
static void 
fm_zonemap_pol_fill_blob(
	table_row_t		*tablep,
	Blob_t			*blobp,
	pin_flist_t		*error_flistp,
	pin_errbuf_t		*ebufp)
{
	tmp_table_row_data_t	*datap = NULL;
	table_row_t		*cur_rowp = NULL;
	char			*bufp = NULL;
	char			canon_bufp[PIN_MAX_PATH];

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERR_CLEAR_ERR(ebufp);

	if (tablep == NULL) {
		return;
	}
	
	cur_rowp = tablep;
	while ((*cur_rowp) != NULL) {
		datap = *cur_rowp;
		bufp = datap->content_p;
		/* Canonicalize numbers */
		fm_util_ipt_canon_phone_number(bufp, canon_bufp);
		fm_zonemap_pol_insert_path_to_trie(
			datap->ancestors_a, 
			canon_bufp,	
			&(blobp->trie_start), 
			error_flistp,
			ebufp);  

		cur_rowp++;
	}
}

/*******************************************************************
 * fm_zonemap_pol_insert_path_to_trie
 * insert the zone to the right place of the trie
 *******************************************************************/
static void 
fm_zonemap_pol_insert_path_to_trie(
	int32			path_a[],
	char			*str,
	telephony_offset_t	*triep,
	pin_flist_t		*error_flistp,
	pin_errbuf_t		*ebufp)
{
	char			current;
	int32			index = -1;
	TrieNode_t		*nodep;
	int32			result = PIN_RESULT_PASS;
	pin_zonemap_err_t	res_code = PIN_ZONEMAP_ERR_NONE;   

	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERR_CLEAR_ERR(ebufp);

	current = *str;
	if (*triep == 0) {
			/* allocate the next node in the blob */
			trie_vp += sizeof(TrieNode_t);
			*triep = (telephony_offset_t)trie_vp;
	}

	/* insert current character */
	if (current != '\0') {
		/* there is more input in the string */
		index = EXTENDED_CHARSET_INDEX(current);
		
		if (index >= EXTENDED_CHARSETSIZE || 
			index < 0) {
			result = PIN_RESULT_FAIL;
			res_code = PIN_ZONEMAP_ERR_ILLEGAL_DATA;
			PIN_FLIST_FLD_SET(error_flistp,
				PIN_FLD_RESULT,
				(void *)&result, ebufp);
			PIN_FLIST_FLD_SET(error_flistp,
				PIN_FLD_RESULT_FORMAT,
				(void *)&res_code, ebufp);
			PIN_FLIST_FLD_SET(error_flistp,
				PIN_FLD_DESCR,
				(void *)"Ilegal data in zonemap.", ebufp);
			pin_set_err(ebufp, PIN_ERRLOC_FM,
				PIN_ERRCLASS_APPLICATION,
				PIN_ERR_BAD_VALUE, 
				PIN_FLD_ZONEMAP_DATA_DATA, 0, 0);
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
				"Zonemap data contains illegal character.",
				ebufp);
			return;
		}
		
		nodep = (TrieNode_t *)(*triep);
		fm_zonemap_pol_insert_path_to_trie(
			path_a,
			++str, 
			&(nodep->children[index]), 
			error_flistp,
			ebufp);
	}
	else {
		/* end of the string */
		/* initialize data node */
		nodep = (TrieNode_t *)(*triep);
		nodep->isTerminal = PIN_BOOLEAN_TRUE;
		fm_zonemap_pol_insert_path(
			path_a,
			nodep,
			error_flistp,
			ebufp);
	}
}

/*******************************************************************
 * fm_zonemap_pol_insert_path
 * insert the ancestors to the leaf data of the trie node
 *******************************************************************/
static void 
fm_zonemap_pol_insert_path(
	int32			path_a[],
	TrieNode_t		*nodep,
	pin_flist_t		*error_flistp,
	pin_errbuf_t		*ebufp) 
{
	LeafData_t		*leafp = NULL;
	int32			cur = 0;
	int32			*ances_listp = NULL;
	int32			result = PIN_RESULT_PASS;
	pin_zonemap_err_t	res_code = PIN_ZONEMAP_ERR_NONE;


	if (PIN_ERR_IS_ERR(ebufp)) {
		return; 
	}
	PIN_ERR_CLEAR_ERR(ebufp);
	
	if (nodep->leafdata_p != 0) {
		/* duplicate happens! Quit immediately!!! */
		result = PIN_RESULT_FAIL;
		res_code = PIN_ZONEMAP_ERR_DUPLICATE;
		PIN_FLIST_FLD_SET(error_flistp,
			PIN_FLD_RESULT,
			(void *)&result, ebufp);
		PIN_FLIST_FLD_SET(error_flistp,
			PIN_FLD_RESULT_FORMAT,
			(void *)&res_code, ebufp);
		PIN_FLIST_FLD_SET(error_flistp,
			PIN_FLD_DESCR,
			(void *)"Duplicate data in zonemap.", ebufp);
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_APPLICATION,
			PIN_ERR_BAD_VALUE, 
			PIN_FLD_ZONEMAP_DATA_DATA, 0, 0);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"Zonemap data contains duplicates.", ebufp);
		return;
	}

	leafp = (LeafData_t *)data_vp;
	data_vp += sizeof(LeafData_t);

	leafp->ancestors_p = (telephony_offset_t)data_vp;
	ances_listp = (int32 *)leafp->ancestors_p;
	while (path_a[cur] != -1) {
		*(ances_listp++) = path_a[cur++];
		data_vp += sizeof(int32);
	}
	*((int32 *)data_vp) = -1;
	data_vp += sizeof(int32);
	MEM_ALIGN(data_vp, sizeof(int32));
	
	nodep->leafdata_p = (telephony_offset_t)leafp;
}

/***********************************************************************
 * fm_zonemap_pol_get_tmp_table_size
 * returns the size of the temporary table that needs to be created
 ***********************************************************************/
static int32	
fm_zonemap_pol_get_tmp_table_size(
	pin_flist_t		*zone_flistp,
	pin_errbuf_t		*ebufp) 
{
	pin_flist_t		*subzone_flistp = NULL;
	int32			count = 0;
	int32			subzone_elem = 0;
	pin_cookie_t		z_cookie = NULL;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return 0;
	}
	PIN_ERR_CLEAR_ERR(ebufp);

	while((subzone_flistp = PIN_FLIST_ELEM_GET_NEXT(zone_flistp,
			PIN_FLD_ZONEMAP_ZONES, &subzone_elem, 1, &z_cookie,
			ebufp)) != NULL) {
		count += fm_zonemap_pol_get_tmp_table_size(subzone_flistp,
			ebufp);
	}
	
	count += PIN_FLIST_ELEM_COUNT(zone_flistp,
			PIN_FLD_ZONEMAP_DATA_SET, ebufp);

	return count;
}
/***********************************************************************
 * fm_zonemap_pol_create_tmp_tables
 * creates a temporary table to store phone numbers/IP address
 * and their ancestors for easier construction of the trie
 ***********************************************************************/
static void 
fm_zonemap_pol_create_tmp_table(
	pin_flist_t		*zone_flistp,
	table_row_t		*tablep,
	int32			path_a[],
	int32			size,
	int32			*cur,
	pin_errbuf_t		*ebufp)
{
	pin_flist_t		*subzone_flistp = NULL;
	pin_flist_t		*data_flistp = NULL;
	void			*vp = NULL;
	int32			data_elem = 0;
	int32			subzone_elem = 0;
	int32			elem = 0;
	pin_cookie_t		z_cookie = NULL;
	pin_cookie_t		d_cookie = NULL;
	tmp_table_row_data_t	*row_p = NULL;
	int32			i = 0;
	
	if (PIN_ERR_IS_ERR(ebufp)) {
		return;
	}
	PIN_ERR_CLEAR_ERR(ebufp);

	/************************************************************
	 * Traverse zones array, for each zone, do such:
	 *	while (zone still has data) {
	 *		put data in the temporary table;
	 *	};
	 *	if (zone has children) {
	 *		create temp table for all its children;
	 *	};
	 * Repeat until the zone array is empty.
	 ************************************************************/

	/* Is there data? */
	while ((data_flistp = PIN_FLIST_ELEM_GET_NEXT(zone_flistp,
			PIN_FLD_ZONEMAP_DATA_SET, &data_elem, 1, &d_cookie,
			ebufp)) != NULL) {
		vp = PIN_FLIST_FLD_GET(data_flistp,
					PIN_FLD_ZONEMAP_DATA_DATA, 1, ebufp);
		if (vp) {
			/* There is data, create a row in the table! */
			row_p = (tmp_table_row_data_t *)malloc(
				sizeof(tmp_table_row_data_t));
			if (NULL == row_p) {
				pin_set_err(ebufp, PIN_ERRLOC_FM,
					PIN_ERRCLASS_APPLICATION,
					PIN_ERR_NO_MEM,
					PIN_FLD_ZONEMAP_DATA_SET, 0, 0);
				PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
					"fm_zonemap_pol_create_tmp_table:\
					failed to allocate memory", ebufp);
				return;
			}

			row_p->content_p = strdup((char *)vp);
			row_p->ancestors_a = 
				(int32 *)malloc(sizeof(int32)*(size+1));
			if (row_p->ancestors_a == NULL) {
				pin_set_err(ebufp, PIN_ERRLOC_FM,
					PIN_ERRCLASS_APPLICATION,
					PIN_ERR_NO_MEM,
					PIN_FLD_ZONEMAP_DATA_SET, 0, 0);
				PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
					"fm_zonemap_pol_create_tmp_table:\
					failed to allocate memory", ebufp);
                                return;
                        }

			i = 0;
			while(i < size) {
				row_p->ancestors_a[i] = path_a[i];
				i++;
			}
			row_p->ancestors_a[i] = -1;
		}
		*(tablep+*cur) = row_p;
		(*cur)++;
	}

	elem = 0;
	/* Are there subzones? */
	while((subzone_flistp = PIN_FLIST_ELEM_GET_NEXT(zone_flistp,
			PIN_FLD_ZONEMAP_ZONES, &subzone_elem, 1, &z_cookie,
			ebufp)) != NULL) {
		/* Append this element id to the end of the current path */
		path_a[size] = elem;
		fm_zonemap_pol_create_tmp_table(subzone_flistp, tablep,
			path_a, size+1, cur, ebufp);
		elem++;
	}
}	

/*******************************************************************
 * fm_zonemap_pol_get_num_of_nodes
 * get the total number of trie nodes
 *******************************************************************/	
static int32
fm_zonemap_pol_get_num_of_nodes(
	table_row_t		*tablep,
	int32			table_size,
	int32			*node_data_size,
	pin_errbuf_t		*ebufp)
{
	table_row_t		*cur_rowp = NULL;
	char			*content = NULL;
	char			*previous = NULL;
	char			*cur = NULL;
	int32			*path_a = NULL;
	int32			total = 1;
	int32			sz = 0;
	int32			count;
	int32			i_row = 0;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return 0;
	}
	PIN_ERR_CLEAR_ERR(ebufp);

	/* 
	 * If the table is null, number of nodes is zero.
	 */
	if (tablep == NULL) {
		return 0;
	}

	/**********************************************************
	 * qsort the table based on the phone number/IP address
	 **********************************************************/
	qsort((void *)tablep, (size_t)table_size, sizeof(table_row_t),
		fm_util_zonemap_compare_row);
	
	cur_rowp = tablep;
	for (i_row = 0; i_row < table_size; i_row++) {
		previous = content;
		content = (char *)((*cur_rowp)->content_p);
		cur = content;
		/* look for the common substring, then start counting */
		while (cur != NULL &&
			*cur != '\0' &&
			previous != NULL &&
			*previous != '\0') {
			if (*cur == *previous) {
				cur++;
				previous++;
			}
			else {
				break;
			}
		}
		while (cur != NULL && *cur != '\0') {
			cur++;
			total++;
		}

		path_a = (*cur_rowp)->ancestors_a;
		count = 0;
		while (path_a[count++] != -1);
		
		sz += sizeof(LeafData_t);
		sz += count * sizeof(int32);
		ROUNDUP(sz, sizeof(int32));

		cur_rowp++;

	}

	*node_data_size = sz;
	return total;
}
		
static int32
fm_util_ipt_canon_phone_number(
	char			*pszIn,
	char			*pszOut)
{

	char			*pszCurChar;

	/* For each character in the input... */
	for ( ; *pszIn != '\0'; pszIn++) {

		/* Find current input char in valid charset */
		for (pszCurChar = EXTENDED_VALID_CHARS; 
				*pszCurChar != '\0'; pszCurChar++) {
			if (*pszCurChar == tolower(*pszIn)) {
				/* Found it, copy to output */
				*pszOut = *pszIn;
				pszOut++;
				break;
			}
		}
	}

	/* Add terminating NULL */
	*pszOut = '\0';

	/* Return success! */
	return 1;
}

static int32
fm_util_zonemap_compare_row(
	const void		*arg1_p,
	const void		*arg2_p) 
{
	table_row_t		*row1_p;
	table_row_t		*row2_p;
	tmp_table_row_data_t	*rowdata1_p;
	tmp_table_row_data_t	*rowdata2_p;
	char			*str1;
	char			*str2;

	row1_p = (table_row_t *)arg1_p;
	row2_p = (table_row_t *)arg2_p;
	rowdata1_p = (tmp_table_row_data_t *)(*row1_p);
	rowdata2_p = (tmp_table_row_data_t *)(*row2_p);
	str1 = rowdata1_p->content_p;
	str2 = rowdata2_p->content_p;

	return strcasecmp(str1, str2);
}
