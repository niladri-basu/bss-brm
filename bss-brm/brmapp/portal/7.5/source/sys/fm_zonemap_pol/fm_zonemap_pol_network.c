/* continuus file information --- %full_filespec: fm_zonemap_pol_network.c~10:csrc:1 % */
/**********************************************************************
*
*	C Source:		fm_zonemap_pol_network.c
*	Instance:		1
*	Description:	
*	%created_by:	gmartin %
*	%date_created:	Fri Jul 21 17:07:27 2000 %
*
* Copyright (c) 2000, 2009, Oracle and/or its affiliates. All rights reserved. 
*
*      This material is the confidential property of Oracle Corporation
*      or its subsidiaries or licensors and may be used, reproduced, stored
*      or transmitted only in accordance with a valid Oracle license or
*      sublicense agreement.
*
**********************************************************************/
#ifndef lint
static char *_csrc = "@(#)$Id: fm_zonemap_pol_network.c /cgbubrm_7.3.2.idcmod/1 2009/06/05 04:43:33 lnandi Exp $";
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
#include "fm_zonemap_pol.h"

#ifdef _DEBUG
#define IPT_DEBUG
#endif

extern telephony_offset_t		blob_base_addr;

/*******************************************************************
 * Function prototypes
 *******************************************************************/
void 
fm_zonemap_pol_pre_process_blob(			
	Blob_t			*blobp);

void
fm_zonemap_pol_post_process_blob(
	Blob_t			*blobp);


/*******************************************************************
 * fm_zonemap_pol_pre_process_blob
 * change the network byte order to host byte order
 *******************************************************************/
void 
fm_zonemap_pol_pre_process_blob(			
	Blob_t *blobp)
{
	TrieNode_t		*trie_vp = (TrieNode_t *)NULL;
	LeafData_t		*data_vp = (LeafData_t *)NULL;
	tree_node_data_t	*zone_vp = (tree_node_data_t *)NULL;
	char			*vp = NULL;
	int32			*pathp = NULL;
	int32			index = 0;
	telephony_offset_t	end = 0;
	char			acLogBuf[512];
	
	NTOHL(blobp->blob_size);
	NTOHL(blobp->node_size);
	NTOHL(blobp->data_size);
	NTOHL(blobp->zone_size);
	NTOHL(blobp->zone_data_size);
	NTOHL(blobp->version);

	if (blobp->version != ZONEMAP_CURRENT_VERSION) {
		sprintf(acLogBuf, "fm_zonemap_pol_pre_process_blob: "
			"Wrong version of Zonemap.  Found %i, "
			"expecting %i. Ignoring zonemap. Use Configuration "
			"Center IPT to fix this problem.", blobp->version,
			ZONEMAP_CURRENT_VERSION);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, acLogBuf);
		return;
	}
	
	NTOHL(blobp->trie_start);
	NTOHL(blobp->data_start);
	NTOHL(blobp->zone_start);
	NTOHL(blobp->zone_data_start);
			
	trie_vp = (TrieNode_t *)ADDR(blobp, blobp->trie_start);
	data_vp = (LeafData_t *)ADDR(blobp, blobp->data_start);
	zone_vp = (tree_node_data_t *)ADDR(blobp, blobp->zone_start);
	vp = (char *)ADDR(blobp, blobp->zone_data_start);

	while ((telephony_offset_t)trie_vp < (telephony_offset_t)data_vp) {
		NTOHL(trie_vp->leafdata_p);
		NTOHL(trie_vp->isTerminal);
		for(index = 0; index < EXTENDED_CHARSETSIZE; index++ ) {
			NTOHL(trie_vp->children[index]);
		}
		trie_vp++;
	}

	/* The pointers should be equal.  If not, log an error */
	if ((telephony_offset_t)trie_vp != (telephony_offset_t)data_vp) {
		sprintf(acLogBuf, "fm_zonemap_pol_pre_process_blob: "
			"Bad zonemap data. TRIE ptr (%08x) is not "
			"equal to DATA ptr (%08x). Ignoring zonemap.", 
			(u_int32)trie_vp, (u_int32)data_vp);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, acLogBuf);
		return;
	}
	
	while ((telephony_offset_t)data_vp < (telephony_offset_t)zone_vp) {
		NTOHL(data_vp->ancestors_p);
		pathp = (int32 *)ADDR(blobp, data_vp->ancestors_p);
		while (*pathp != -1) {
			NTOHL(*pathp);
			pathp++;
		}
		/* convert the last element -1 */
		NTOHL(*pathp);
		pathp++;
		data_vp = (LeafData_t *)pathp;
	}

	/* The pointers should be equal.  If not, log an error */
	if ((telephony_offset_t)data_vp != (telephony_offset_t)zone_vp) {
		sprintf(acLogBuf, "fm_zonemap_pol_pre_process_blob: "
			"Bad zonemap data. DATA ptr (%08x) is not "
			"equal to ZONE ptr (%08x). Ignoring zonemap.", 
			(u_int32)data_vp, (u_int32)zone_vp);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, acLogBuf);
		return;
	}

	/* convert the zone nodes */
	while ((telephony_offset_t)zone_vp < (telephony_offset_t)vp) {
		NTOHL(zone_vp->data_addr);
		NTOHL(zone_vp->firstchild_addr);
		NTOHL(zone_vp->parent_addr);
		NTOHL(zone_vp->elem_id);
		zone_vp++;
	}

	/* The pointers should be equal.  If not, log an error */
	if ((telephony_offset_t)zone_vp != (telephony_offset_t)vp) {
		sprintf(acLogBuf, "fm_zonemap_pol_pre_process_blob: "
			"Bad zonemap data. ZONE ptr (%08x) is not "
			"equal to VP ptr (%08x). Ignoring zonemap.", 
			(u_int32)zone_vp, (u_int32)vp);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, acLogBuf);
		return;
	}
	
	/* Don't need to convert zone node data since it is string data */
}

/*******************************************************************
 * fm_zonemap_pol_process_blob
 * change the actual address to offset
 * and change the byte order from host to network 
 *******************************************************************/
void
fm_zonemap_pol_post_process_blob(
	Blob_t			*blobp)
{
	TrieNode_t		*trie_vp = NULL;
	LeafData_t		*data_vp = NULL;
	tree_node_data_t	*zone_vp = NULL;
	int32			*pathp = NULL;
	char			*vp = NULL;
	int32			index = 0;
	char			acLogBuf[512];

	trie_vp = (TrieNode_t *)(blobp->trie_start);
	data_vp = (LeafData_t *)(blobp->data_start);
	zone_vp = (tree_node_data_t *)(blobp->zone_start);
	
	while ((telephony_offset_t)trie_vp < (telephony_offset_t)data_vp) {
		/* convert the byte order one by one */
		OFFSET(blob_base_addr, trie_vp->leafdata_p);
		HTONL(trie_vp->leafdata_p);
		HTONL(trie_vp->isTerminal);
		/* walk the children list */
		for(index = 0; index < EXTENDED_CHARSETSIZE; index++ ) {
			OFFSET(blob_base_addr, trie_vp->children[index]);
			NTOHL(trie_vp->children[index]);
		}
		
		trie_vp++; 
	}

	/* The pointers should be equal.  If not, log an error */
	if ((telephony_offset_t)trie_vp != (telephony_offset_t)data_vp) {
		sprintf(acLogBuf, "fm_zonemap_pol_post_process_blob: "
			"Bad zonemap data. TRIE ptr (%08x) is not "
			"equal to DATA ptr (%08x). Ignoring zonemap.", 
			(u_int32)trie_vp, (u_int32)data_vp);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, acLogBuf);
		return;
	}
	
	/* convert trie node data */
	while ((telephony_offset_t)data_vp < (telephony_offset_t)blobp->zone_start) {
		/* Get to first element of the ancestor array */
		pathp = (int32 *)(data_vp->ancestors_p);
		while(*pathp != -1) {
			HTONL(*pathp);
			pathp++;
		}
		/* convert the last element -1 */
		HTONL(*pathp);
		pathp++;
		OFFSET(blob_base_addr, data_vp->ancestors_p);
		HTONL(data_vp->ancestors_p);
		data_vp = (LeafData_t *)pathp;	
	}

	/* The pointers should be equal.  If not, log an error */
	if ((telephony_offset_t)data_vp != (telephony_offset_t)blobp->zone_start) {
		sprintf(acLogBuf, "fm_zonemap_pol_post_process_blob: "
			"Bad zonemap data. DATA ptr (%08x) is not "
			"equal to ZONE ptr (%08x). Ignoring zonemap.", 
			(u_int32)data_vp, (u_int32)zone_vp);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, acLogBuf);
		return;
	}

	/* convert zone nodes */
	while ((telephony_offset_t)zone_vp < (telephony_offset_t)blobp->zone_data_start) {
		OFFSET(blob_base_addr, zone_vp->data_addr);
		HTONL(zone_vp->data_addr);
		OFFSET(blob_base_addr, zone_vp->firstchild_addr);
		HTONL(zone_vp->firstchild_addr);
		OFFSET(blob_base_addr, zone_vp->parent_addr);
		HTONL(zone_vp->parent_addr);
		HTONL(zone_vp->elem_id);
		zone_vp++;
	}

	/* The pointers should be equal.  If not, log an error */
	if ((telephony_offset_t)zone_vp < (telephony_offset_t)blobp->zone_data_start) {
		sprintf(acLogBuf, "fm_zonemap_pol_post_process_blob: "
			"Bad zonemap data. ZONE ptr (%08x) is not "
			"equal to ZONE DATA START ptr (%08x). Ignoring "
			"zonemap.", 
			(u_int32)zone_vp, blobp->zone_data_start);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, acLogBuf);
		return;
	}
	
	/* Don't need to convert zone node data since it is string data */

	HTONL(blobp->blob_size);
	OFFSET(blob_base_addr, blobp->trie_start);
	HTONL(blobp->trie_start);
	HTONL(blobp->node_size);
	
	OFFSET(blob_base_addr, blobp->data_start);
	HTONL(blobp->data_start);
	HTONL(blobp->data_size);

	OFFSET(blob_base_addr, blobp->zone_start);
	HTONL(blobp->zone_start);
	HTONL(blobp->zone_size);

	OFFSET(blob_base_addr, blobp->zone_data_start);
	HTONL(blobp->zone_data_start);
	HTONL(blobp->zone_data_size);

}

