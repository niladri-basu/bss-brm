/* continuus file information --- %full_filespec: fm_zonemap_pol_util.c~6:csrc:2 % */
/*************************************************************************
 *  @(#) %full_filespec: fm_zonemap_pol_util.c~6:csrc:2 %
 *
 *      Copyright (c) 1999 - 2008 Oracle. All rights reserved.
 *
 *      This material is the confidential property of Oracle Corporation
 *      or its licensors and may be used, reproduced, stored or transmitted 
 *      only in accordance with a valid Oracle license or sublicense agreement.
 *
 *************************************************************************/

#ifndef lint
static  char    Sccs_id[] = "@(#)%Portal Version: fm_zonemap_pol_util.c:IDCmod7.3.1Int:2:2008-Jan-22 18:57:26 %";
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

#define FILE_LOGNAME "fm_zonemap_pol_util.c(3)"


/*****************************************************************************
 * Routine to retrieve zone lineage in concatenated string format
 * delimited by delimiters based on the ancestor array.
 * The storeage is handled within the function therefore it is
 * also repsponsible for releasing the memory.
 *****************************************************************************/
void
fm_zonemap_pol_get_lineage_from_ancestors(
	telephony_offset_t	bufp, 
	telephony_offset_t	ancestor_p,
	char				**lineage_pp,
	pin_errbuf_t		*ebufp)
{
	telephony_offset_t		zone_start = 0;
	tree_node_data_t		*zonetree_p = NULL;
	tree_node_data_t		*curzone_p = NULL;
	tree_node_data_t		*curparent_p = NULL;
	char					*zonename_p = NULL;
	char					*cur_p = NULL;
	int32					elem = -1;
	int32					*path_a = NULL;

	*lineage_pp = (char *)malloc(PIN_MAX_PATH);
	if (!(*lineage_pp)) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_APPLICATION,
				PIN_ERR_NO_MEM, 0,0,0);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, "Memory allocation error", ebufp);
		return;
	}
	memset(*lineage_pp, 0, PIN_MAX_PATH);
	cur_p = *lineage_pp;

	zone_start = ((Blob_t *)bufp)->zone_start;
	zonetree_p = (tree_node_data_t *)ADDR(bufp, zone_start);
	curzone_p = zonetree_p;
	
	path_a = (int32 *)ADDR(bufp, ancestor_p);
	while (path_a != NULL &&
		(elem = *path_a) != -1) {

		/* Start walking the ancestore array */
		/* For each element id, figure out the zone name */
		curparent_p = curzone_p;
		curzone_p = (tree_node_data_t *)ADDR(bufp, (curparent_p->firstchild_addr));
		curzone_p += elem;
		/******************************************************
		 * Due to the data structure, the current zone node 
		 * might NOT be the one we want!!! Therefore, 
		 * check its parent.
		 ******************************************************/
		if ((telephony_offset_t)curparent_p != ADDR(bufp, curzone_p->parent_addr)) {
			/* this element id does not exist!!! */
			pin_set_err(ebufp, PIN_ERRLOC_FM, 
				PIN_ERRCLASS_APPLICATION, 
				PIN_ERR_BAD_VALUE, 
				PIN_FLD_ZONEMAP_ZONES, 0, 0);
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, 
				"fm_zonemap_pol_get_lineage_from_ancestor_id: Ancestor does not exist!", ebufp);
			break;
		}

		zonename_p = (char *)ADDR(bufp, curzone_p->data_addr);

		if (zonename_p != NULL) {
			/* Copy the zonename to the current place in */
			/* plineage_p */
			strncat(cur_p, zonename_p, (PIN_MAX_PATH - strlen(cur_p) - 1));

			/******************************************************
			 * Add the predefined delimiter. It has to be
			 * the same delimiter used in rating engine.
		 	 ******************************************************/
			strncat(cur_p, PIN_LINEAGE_DELIMITER, (PIN_MAX_PATH - strlen(cur_p) - 1));
		}
		else {
			/* Something is wrong, there is a null zone name */
			/* Exit with error code */
			pin_set_err(ebufp, PIN_ERRLOC_FM, 
				PIN_ERRCLASS_APPLICATION, 
				PIN_ERR_BAD_VALUE, 
				PIN_FLD_ZONEMAP_ZONES, 0, 0);
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, 
				"fm_act_pol_telephony_get_matrix: empty zone name", ebufp);
			break;
		}

		/* Move to next one in the path */
		path_a++;		 
	}

	if (PIN_ERR_IS_ERR(ebufp)) {
		free(*lineage_pp);
		*lineage_pp = NULL;
		return;	
	}
	
}	
