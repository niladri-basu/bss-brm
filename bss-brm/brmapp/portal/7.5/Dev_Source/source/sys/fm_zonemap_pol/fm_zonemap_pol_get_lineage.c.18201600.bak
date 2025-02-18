/*
 * Copyright (c) 1999, 2009, Oracle and/or its affiliates. 
 * All rights reserved. 
 *
 *      This material is the confidential property of Oracle Corporation
 *      or licensors and may be used, reproduced, stored or transmitted
 *      only in accordance with a valid Oracle license or sublicense agreement.
 */

#ifndef lint
static  char    Sccs_id[] = "@(#)$Id: fm_zonemap_pol_get_lineage.c /cgbubrm_7.3.2.idcmod/2 2009/06/05 04:43:33 lnandi Exp $";
#endif

/*******************************************************************
 * Contains the PCM_OP_ZONEMAP_POL_GET_LINEAGE operation. 
 *******************************************************************/

#include <malloc.h>
#include <stdio.h>
#include <string.h>

#include "pcm.h"
#include "ops/zonemap.h"
#include "pin_errs.h"
#include "pinlog.h"

#include "cm_fm.h"

#include "pin_zonemap.h"
#include "fm_zonemap_pol.h"

/* IPT_STUB can be defined to exercise the code with 
 * a stub driver.
 */
#ifndef IPT_STUB
#include "pin_os_pthread.h"
#else
#define cm_set_global_heap() NULL
#define cm_reset_global_heap(x) NULL
#define pthread_mutex_unlock(x)
#define pthread_mutex_lock(x)
#define pthread_mutex_init(x,y)
#define pthread_mutex_destroy(x)
#define pthread_mutex_t void*
#endif

#define FILE_LOGNAME "fm_zonemap_pol_get_lineage.c(7)"

/***************************************************
 * Defaults
 ***************************************************/

/* PIN_DEFAULT_SEARCH_MODE defines whether to use 
 * a prefix or exact match search when the search 
 * mode isn't specified either on the input flist 
 * or in the matrix itself.
 */
#define PIN_DEFAULT_SEARCH_MODE	PIN_ZONEMAP_PREFIX

/***************************************************
 * Mutex Defines/types
 ***************************************************/

#ifdef WIN32
#define MutexLock(x)	pthread_mutex_lock(&(x))
#define MutexUnlock(x)	pthread_mutex_unlock(&(x))
#define MutexInit(x)	pthread_mutex_init(&(x), PTHREAD_MUTEXATTR_DEFAULT)
#define MutexDestroy(x)	pthread_mutex_destroy(&(x))
#else
/* On Unix, the CM uses multiple processes, not multiple threads.
 * No data here is shared between the processes, so there's no
 * need for any mutual exclusion.
 */
#define MutexLock(x)
#define MutexUnlock(x)
#define MutexInit(x)
#define MutexDestroy(x)
#endif /* WIN32 */

#define Mutex_t pthread_mutex_t

/***************************************************
 * Local/Global Heap Defines/types
 ***************************************************/

#ifdef WIN32
	/*
	 * Use the global heap under NT,
	 * instead of the default local heap to ensure MT safe
	 */

#define PIN_HEAP_VAR		HANDLE local_thd_heap_hdl
#define PIN_SET_GLOBAL_HEAP	(local_thd_heap_hdl = cm_set_global_heap())
#define PIN_RESET_GLOBAL_HEAP	(cm_reset_global_heap(local_thd_heap_hdl))
#else
#define PIN_HEAP_VAR
#define PIN_SET_GLOBAL_HEAP
#define PIN_RESET_GLOBAL_HEAP
#endif

/***************************************************
 * Hash Table Defines/types
 ***************************************************/

/* TELEPHONY_ZONEMAPHASHTABLESIZE defines the size of  
 * the hash table used for caching the zone maps.
 */
#define TELEPHONY_ZONEMAPHASHTABLESIZE	11

/* ZonemapHashEntry_t is the struct used for the 
 * hash table buckets.
 */
typedef struct TAG_ZonemapHashEntry_t {
	const char		*pszZonemapName;
	poid_t			*pMatrixPoid;
	int32			nDefaultSearchMode;
	struct TAG_ZonemapHashEntry_t	*pNext;
	Blob_t			*pBuffer;
	Mutex_t			Lock;
	time_t			lastUpdate;
} ZonemapHashEntry_t;

/* Zonemap hash table & semaphore */
static ZonemapHashEntry_t *ZonemapHashTable_ap[TELEPHONY_ZONEMAPHASHTABLESIZE];
static Mutex_t HashTableLock;
static time_t interval;

/* Mutex logic on NT:
 * The "HashTableLock" is used to protect the entire Hash Table.  This
 * mutex is always acquired first before accessing or updating the 
 * Hash Table.  Once a Node is found, the Node's mutex is acquired and the
 * "HashTableLock" is released.  This allows multiple threads to work on
 * different Nodes at the same time.
 * The "node mutex" protects an individual node with the exception of the
 * node's "nextp" field.  This field is protected by the "HashTableLock"
 * mutex. The "node mutex" is always acquired after first acquiring the
 * "HashTableLock" mutex.  This prevents a deadlock from happening.
 */

/* Hash table init done? */
static int32 nInitDone;

/***************************************************
 * Other Defines/types
 ***************************************************/

/* Since a given search string has a potential list of  
 * matching rows, we must store the values in a list.
 * MatchList is a node in this list.
 */
typedef struct TAG_MatchList_t {
	struct TAG_MatchList_t	*pNext;
	char			*pszData;
} MatchList_t;


/*******************************************************************
 * Routines contained within.
 *******************************************************************/

PIN_EXPORT void 
fm_zonemap_pol_get_lineage_init();

EXPORT_OP void
op_zonemap_pol_get_lineage(
	cm_nap_connection_t	*connp,
	u_int			opcode,
	u_int			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp);

static ZonemapHashEntry_t *
fm_zonemap_pol_get_lineage_get_zonemap(
	pcm_context_t		*pCtx, 
	poid_t			*pRoutingPoid, 
	poid_t			*pBrandPoid, 
	ZonemapHashEntry_t	**apHashTable, 
	const char		*pszSearchTarget, 
	pin_errbuf_t		*ebufp);

static
char *
fm_zonemap_pol_get_lineage_search_zonemap(
	Blob_t			*pBuffer, 
	char			*pszString,
	int32			nSearchMode, 
	pin_errbuf_t		*ebufp);

static int32 
fm_zonemap_pol_get_lineage_hash_zone_name(
	const char		*pszZoneName);

static ZonemapHashEntry_t *
fm_zonemap_pol_get_lineage_find_bucket(
	ZonemapHashEntry_t	*pBucket, 
	const char		*pszZoneName, 
	pin_errbuf_t		*ebufp);

static int32
fm_zonemap_pol_get_lineage_load_zonemap(
	pcm_context_t		*pCtx, 
	const char		*pszTarget, 
	poid_t			*pRoutingPoid, 
	poid_t			**ppZonemapPoid,
	poid_t			*pBrandPoid,
	Blob_t			**ppBuffer, 
	int32			*pnSearchMode, 
	pin_errbuf_t		*ebufp);

static int32 
fm_zonemap_pol_get_lineage_rev_changed(
	pcm_context_t		*pCtx, 
	const poid_t		*pMatrixPoid, 
	pin_errbuf_t		*ebufp);

/*******************************************************************
 * Function bodies.
 *******************************************************************/
void fm_zonemap_pol_get_lineage_init()
{
	int32			*i_ptr = NULL;
	int32			error = 0;

	PIN_HEAP_VAR;

	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
		"fm_zonemap_pol_get_lineage_init Enter");
	/*
	 * Init ProductHashArray
	 */
	if (nInitDone == PIN_BOOLEAN_FALSE) {
		nInitDone = PIN_BOOLEAN_TRUE;

		/*
		 * initialize the interval
		 */
	
		interval = 3600;
		/*
		 * read the value of this variable from the pin.conf file. If it
		 * doesn't exist then the default value stays.
		 */
		pin_conf("fm_zonemap_pol", "update_interval", PIN_FLDT_INT,
			(caddr_t *)&i_ptr, &error);
		if (error == PIN_ERR_NONE) {
			interval = *i_ptr;
		}
		if (i_ptr) {
			free(i_ptr);
		}
		PIN_SET_GLOBAL_HEAP;

		/*
		 * Init mutex
		 */
		MutexInit(HashTableLock);

		PIN_RESET_GLOBAL_HEAP;
	}
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
		"fm_zonemap_pol_get_lineage_init Exit");
}


/*******************************************************************
 * Main routine for the PCM_OP_ZONEMAP_POL_GET_LINEAGE operation.
 *******************************************************************/
void
op_zonemap_pol_get_lineage(
	cm_nap_connection_t	*connp,
	u_int			opcode,
	u_int			flags,
	pin_flist_t		*i_flistp,
	pin_flist_t		**r_flistpp,
	pin_errbuf_t		*ebufp)
{
	pcm_context_t		*ctxp = connp->dm_ctx;
	ZonemapHashEntry_t	*ZonemapNode_p = NULL;
	poid_t			*RoutingPoid_p = NULL;
	char			*SearchTarget_psz = NULL;
	char			*ZoneMapName_psz = NULL;
	int32			*SearchMode_np;
	int32			DefaultSearchMode_n = PIN_DEFAULT_SEARCH_MODE;
	MatchList_t		*CurNode_p = NULL;
	char			*Lineage_psz = NULL;
	poid_t			*pBrandPoid = NULL;
	int32			*i_ptr = NULL;
	int32			error = 0;


	if (PIN_ERR_IS_ERR(ebufp))
		return;
	PIN_ERR_CLEAR_ERR(ebufp);

	/*
	 * Sanity check.
	 */
	if (opcode != PCM_OP_ZONEMAP_POL_GET_LINEAGE) {
		pin_set_err(ebufp, PIN_ERRLOC_FM,
			PIN_ERRCLASS_SYSTEM_DETERMINATE,
			PIN_ERR_BAD_OPCODE, 0, 0, opcode);
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_zonemap_pol_get_lineage bad opcode error", 
			ebufp);
		return;
	}

	/*
	 * Debug: What we got.
	 */
	PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
		"op_zonemap_pol_get_lineage input flist", i_flistp);

	/*
	 * Create & init return flist
	 */
	*r_flistpp = PIN_FLIST_CREATE(ebufp);
	RoutingPoid_p = PIN_FLIST_FLD_GET(i_flistp, PIN_FLD_POID, 0, ebufp);
	PIN_FLIST_FLD_SET(*r_flistpp, PIN_FLD_POID, RoutingPoid_p, ebufp);

	pBrandPoid = (poid_t *) PIN_FLIST_FLD_GET(i_flistp,
		PIN_FLD_ACCOUNT_OBJ, 1, ebufp);

	/*
	 * Grab required params from input flist
	 */
	ZoneMapName_psz = (char*) PIN_FLIST_FLD_GET(i_flistp, 
		PIN_FLD_ZONEMAP_NAME, 0, ebufp);

	SearchTarget_psz = (char*) PIN_FLIST_FLD_GET(i_flistp,
		PIN_FLD_ZONEMAP_TARGET, 0, ebufp);

	/* Is everything groovy? */
	if (PIN_ERR_IS_ERR(ebufp)) {
		/* No: quit now */
		goto Done;
	}
	
	if ((SearchTarget_psz == NULL) || (strlen(SearchTarget_psz) == 0)) {
		/*
		 * Target string is empty,
		 * create an empty return flist and exit.
		 */
		Lineage_psz = "";
		/*
		 * Copy data to return flist
		 */
		PIN_FLIST_FLD_SET(*r_flistpp, PIN_FLD_ZONEMAP_LINEAGE,
			Lineage_psz, ebufp);
	}
	else {
		/* Lock entire hash table */
		MutexLock(HashTableLock);
		/*
		 * Can we load matrix?
		 */
		ZonemapNode_p = fm_zonemap_pol_get_lineage_get_zonemap(ctxp, 
			RoutingPoid_p, pBrandPoid,
			ZonemapHashTable_ap, ZoneMapName_psz,
			ebufp);
		if (ZonemapNode_p != NULL) {
	
			/*
			 * Yes: search zone map for lineage
			 */
	
			/* Lock the node */
			MutexLock(ZonemapNode_p->Lock);
			/* Unlock entire hash table */
			MutexUnlock(HashTableLock);
	
			/*
			 * Find search mode (either from matrix or input flist)
			 */
	
			/* First try to grab it from input flist, 
			   as this overrides matrix setting */
			SearchMode_np = (int32*) PIN_FLIST_FLD_GET(i_flistp,
				PIN_FLD_ZONEMAP_SEARCH_TYPE, 1, ebufp);

			/* Did we find it on the input? */
			if (SearchMode_np == NULL) {
				/* No: grab it from matrix */
				SearchMode_np =
					&(ZonemapNode_p->nDefaultSearchMode);

				/* Did we find it in the matrix */
				if (SearchMode_np == NULL) {
					/* No: use default search mode*/
					SearchMode_np = &DefaultSearchMode_n;
				}
			}
	
	
			/*
			 * Do the search (allocates mem)
			 */
			Lineage_psz = 
				fm_zonemap_pol_get_lineage_search_zonemap(
					ZonemapNode_p->pBuffer,
					SearchTarget_psz, 
					*SearchMode_np, ebufp);
	
			/* Unlock the node */
			MutexUnlock(ZonemapNode_p->Lock);
	
			if (Lineage_psz == NULL) {
				Lineage_psz = "";
				/*
				 * Copy data to return flist
			 	*/
				PIN_FLIST_FLD_SET(*r_flistpp,
					PIN_FLD_ZONEMAP_LINEAGE, Lineage_psz, 
					ebufp);
			}
			else {
				/*
				 * Copy data to return flist
			 	*/
				PIN_FLIST_FLD_SET(*r_flistpp, 
					PIN_FLD_ZONEMAP_LINEAGE, Lineage_psz,
					ebufp);
				/*
				 * Clean up memory allocated to lineage string
				 */
				 free(Lineage_psz);  
			}
	
		}
		else {
			/*
			 * No, we can't find a zonemap: error
			 */
			/* Unlock entire hash table */
			MutexUnlock(HashTableLock);

			pin_set_err(ebufp, PIN_ERRLOC_FM,
				PIN_ERRCLASS_APPLICATION, PIN_ERR_NO_MATCH, 
				PIN_FLD_ZONEMAP_NAME, 0, 0);
	
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
				"op_zonemap_pol_get_lineage error: Can't "
				"find requested zonemap in DB", ebufp);
		}
	}
Done:
	/*
	 * Error?
 	 */
	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_FLIST_DESTROY_EX(r_flistpp, NULL);
		*r_flistpp = (pin_flist_t *)NULL;
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"op_zonemap_pol_get_lineage error", ebufp);
	} else {
		PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
			"op_zonemap_pol_get_lineage return flist", 
			*r_flistpp);
	}

	return;
}


/*******************************************************************
 * fm_zonemap_pol_get_lineage_get_zonemap():
 *******************************************************************/
static ZonemapHashEntry_t *
fm_zonemap_pol_get_lineage_get_zonemap(
	pcm_context_t		*pCtx, 
	poid_t			*pRoutingPoid, 
	poid_t			*pBrandPoid, 
	ZonemapHashEntry_t	**apHashTable, 
	const char		*pszTarget, 
	pin_errbuf_t		*ebufp) 
{

	int32			nTargetHash;
	int32			nLoadStatus;
	ZonemapHashEntry_t	*pHashEntry;
	ZonemapHashEntry_t	*pBucket;
	ZonemapHashEntry_t	*pCurNode;
	Blob_t			**ppBuffer;
	poid_t			**ppMatrixPoid;
	int32			*pnSearchMode;

	int32			nLoadFromDB;
	int32			nUnlockNode = PIN_BOOLEAN_FALSE;
	time_t			current_time = 0;

	PIN_HEAP_VAR;

	/* The HashTableLock has already been acquired by the time
	 * this procedure is called.
	 */
	pHashEntry = pBucket = NULL;

	if (PIN_ERR_IS_ERR(ebufp)) {
		return NULL;
	}

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_get_zonemap starting");

	/*
	 * Hash zone name
	 */
	nTargetHash = fm_zonemap_pol_get_lineage_hash_zone_name(pszTarget);

	/* Get bucket */
	pBucket = apHashTable[nTargetHash];

	/* Assume we don't have to load from DB */
	nLoadFromDB = PIN_BOOLEAN_FALSE;

	/*
	 * Have we already loaded this matrix?
	 */
	pHashEntry = fm_zonemap_pol_get_lineage_find_bucket(pBucket, 
		pszTarget, ebufp);
	if (pHashEntry != NULL) {
		
		/*
		 * do a revision check only if a certain time has 
		 * elapsed
		 */
		current_time = pin_virtual_time((time_t*)NULL);
		if(current_time > (pHashEntry->lastUpdate + interval)) {

			/*
			 * reset the timer
			 */
			 pHashEntry->lastUpdate = current_time;
			/*
			 * Yes: Has it changed since last load?
			 */
			if (fm_zonemap_pol_get_lineage_rev_changed(pCtx,
				pHashEntry->pMatrixPoid, ebufp)) {

				/*
				 * Yes: Free old data & reload matrix from DB
				 */

				/* Lock the node */
				MutexLock(pHashEntry->Lock);

				/* Remove node from bucket */
				for (pCurNode = pBucket; pCurNode != NULL;
					pCurNode = pCurNode->pNext) {

					if (pCurNode->pNext == pHashEntry) {
						pCurNode->pNext = 
							pHashEntry->pNext;
						break;
					}
				}

				PIN_SET_GLOBAL_HEAP;

				/* Free buffer */
				free(pHashEntry->pBuffer);
				pHashEntry->pBuffer = NULL;

				/* Free matrix poid */
				PIN_POID_DESTROY(pHashEntry->pMatrixPoid,
					NULL);
				pHashEntry->pMatrixPoid = NULL;

				PIN_RESET_GLOBAL_HEAP;

				/* Indicate that we need to load from DB */
				nLoadFromDB = PIN_BOOLEAN_TRUE;

				/* Indicate that we need to unlock the node */
				nUnlockNode = PIN_BOOLEAN_TRUE;
			}
		}
	}
	else {
		/*
		 * No: Add new node to bucket
		 */

		PIN_SET_GLOBAL_HEAP;

		/* Create & init new bucket */
		pHashEntry = (ZonemapHashEntry_t *) 
			malloc(sizeof(ZonemapHashEntry_t));

		/* Verify that memory was allocated */
		if (pHashEntry != NULL) {

			pHashEntry->pszZonemapName =
				malloc(strlen(pszTarget) + 1);
			if (pHashEntry->pszZonemapName == NULL) {
				pin_set_err(ebufp, PIN_ERRLOC_FM, 
					PIN_ERRCLASS_SYSTEM_DETERMINATE, 
					PIN_ERR_NO_MEM, 0, 0, 0);
				PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, 
					"fm_zonemap_pol_get_lineage_get_zonemap: "
					"failed to allocate memory for zonemap name",
					ebufp);
				free(pHashEntry);
				pHashEntry = NULL;

				goto Done;
			}

			strcpy((char*) pHashEntry->pszZonemapName, pszTarget);
			pHashEntry->pNext = NULL;
			pHashEntry->pBuffer = NULL;

			/* Init semaphore */
			MutexInit(pHashEntry->Lock);
		}

		PIN_RESET_GLOBAL_HEAP;

		/* Verify that memory was allocated */
		if (pHashEntry == NULL) {

			pin_set_err(ebufp, PIN_ERRLOC_FM, 
				PIN_ERRCLASS_SYSTEM_DETERMINATE, 
				PIN_ERR_NO_MEM, 0, 0, 0);
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR, 
				"fm_zonemap_pol_get_lineage_get_zonemap: "
				"failed to allocate memory for hash entry",
				ebufp);

			goto Done;
		}

		/* Indicate that we need to load from DB */
		nLoadFromDB = PIN_BOOLEAN_TRUE;
	}

	/* Do we need to load from the database? */
	if (nLoadFromDB == PIN_BOOLEAN_TRUE) {
		/*
		 * Yes: Load matrix from DB
		 */

		/* Copy trie address from global to local mem */
		ppBuffer = &(pHashEntry->pBuffer);
		ppMatrixPoid = &(pHashEntry->pMatrixPoid);
		pnSearchMode = &(pHashEntry->nDefaultSearchMode);
				
		/* Attempt to read matrix from DB */
		nLoadStatus = fm_zonemap_pol_get_lineage_load_zonemap(
			pCtx, pszTarget, pRoutingPoid, ppMatrixPoid,pBrandPoid, 
			ppBuffer, pnSearchMode, ebufp);

		PIN_SET_GLOBAL_HEAP;

		/* Did we load a matrix? */
		if (nLoadStatus == PIN_BOOLEAN_FALSE) {
			/* Failed: set return value */
			/* If this happened on a RELOAD, we have more 
			 * work to do
			 */
			
			if (nUnlockNode == PIN_BOOLEAN_TRUE) {
				/*
				 * Yes: Unlock the node
				 */
				MutexUnlock(pHashEntry->Lock);
				nUnlockNode = PIN_BOOLEAN_FALSE;
			}

			free((char*)pHashEntry->pszZonemapName);
			pHashEntry->pszZonemapName = NULL;
			/* Destroy the mutex */
			MutexDestroy(pHashEntry->Lock);
			free(pHashEntry);
			pHashEntry = NULL;
		}
		else {

			/* 
			 * Add bucket to hash table
			 */
			pHashEntry->pNext = apHashTable[nTargetHash];
			apHashTable[nTargetHash] = pHashEntry;
			pHashEntry->lastUpdate = pin_virtual_time((time_t *)NULL);
			}

		PIN_RESET_GLOBAL_HEAP;

	}
Done:
	/* Do we need to unlock the node? */
	if (nUnlockNode == PIN_BOOLEAN_TRUE) {
		/*
		 * Yes: Unlock the node
		 */
		MutexUnlock(pHashEntry->Lock);
	}

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_get_zonemap returning");

	return pHashEntry;
}

/*******************************************************************
 * fm_zonemap_pol_get_lineage_rev_changed():
 *
 *	Determine whether the matrix has changed since we loaded it.
 *
 *******************************************************************/
static int32
fm_zonemap_pol_get_lineage_rev_changed(
	pcm_context_t		*pCtx, 
	const poid_t		*pMatrixPoid, 
	pin_errbuf_t		*ebufp) 
{
	pin_flist_t		*pReadPoidInFlist = NULL;
	pin_flist_t		*pReadPoidOutFlist = NULL;
	poid_t			*pNewPoid = NULL;
	int32			nRetVal;
	int64			in_db_no;

	/* Sanity check */
	if (PIN_ERR_IS_ERR(ebufp)) {
		return PIN_BOOLEAN_FALSE;
	}

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_rev_changed starting");

	/*
	 * Create flist for reading the zonemap poid
	 */
	pReadPoidInFlist = PIN_FLIST_CREATE(ebufp);

	/* In multi-db case the input context DB number may be different than the one earlier cached in pMatrixPoid.
         * So do READ_FLDS on the DB from input context for cached zonemap poid to avoid error from CM that
         * a transaction is already open.
        */

        pNewPoid = PIN_POID_COPY((poid_t *)pMatrixPoid, ebufp);
        in_db_no = cm_fm_get_current_db_no(pCtx);

        PIN_POID_SET_DB(pNewPoid, in_db_no);

        PIN_FLIST_FLD_PUT(pReadPoidInFlist, PIN_FLD_POID, pNewPoid, ebufp);

        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                "fm_zonemap_pol_get_lineage_rev_changed zonemap read_flds input flist", pReadPoidInFlist);

	/*
	 * Read current poid from DB
	 */
	PCM_OP(pCtx, PCM_OP_READ_FLDS, 0, pReadPoidInFlist, 
		&pReadPoidOutFlist, ebufp);

        PIN_ERR_LOG_FLIST(PIN_ERR_LEVEL_DEBUG,
                "fm_zonemap_pol_get_lineage_rev_changed zonemap read_flds output flist", pReadPoidOutFlist);

	/*
	 * Compare poid revs
	 */

	/* Get new poid from flist */
	pNewPoid = (poid_t*) PIN_FLIST_FLD_GET(pReadPoidOutFlist,
		PIN_FLD_POID, 0, ebufp);

	/* To compare poids for revision check and in multi-db case just set back the
         * pMatrixPoid cached zonemap poid DB number to the  newly read poid
         * to just compare poid_id, type and revision and not db number
        */
        in_db_no = PIN_POID_GET_DB((poid_t *)pMatrixPoid);
        PIN_POID_SET_DB(pNewPoid, in_db_no);

	/* Is db rev newer than stored rev? */
	if (PIN_POID_COMPARE(pNewPoid, (poid_t*)pMatrixPoid,
		PIN_BOOLEAN_TRUE, ebufp)) {

		/* Yes: set return to true */
		nRetVal = PIN_BOOLEAN_TRUE;
	}
	else {
		/* No: set return to false */
		nRetVal = PIN_BOOLEAN_FALSE;
	}

	/*
	 * Clean up
	 */
	PIN_FLIST_DESTROY_EX(&pReadPoidInFlist, NULL);
	PIN_FLIST_DESTROY_EX(&pReadPoidOutFlist, NULL);		

	if (PIN_ERR_IS_ERR(ebufp)) {
		PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			"fm_zonemap_pol_get_lineage_rev_changed() error",
			ebufp);

		/* Set return value to error */
		nRetVal = PIN_BOOLEAN_FALSE;
	}

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_rev_changed returning");
	return nRetVal;
}

/*******************************************************************
 * fm_zonemap_pol_get_lineage_load_zonemap():
 *
 *	Retrieve and process the named zonemap.
 *
 *******************************************************************/
static int32 
fm_zonemap_pol_get_lineage_load_zonemap(
	pcm_context_t		*pCtx, 
	const char		*pszTarget, 
	poid_t			*pRoutingPoid, 
	poid_t			**ppZonemapPoid,
	poid_t			*pBrandPoid, 
	Blob_t			**ppBuffer, 
	int32			*pnDefaultSearchMode, 
	pin_errbuf_t		*ebufp) 
{

	pin_flist_t		*pGetZonemapInFlist = NULL;
	pin_flist_t		*pGetZonemapOutFlist = NULL;
	pin_flist_t		*pZonemaps = NULL;
	poid_t			*pSearchPoid = NULL;
	pin_buf_t		*pBuf = NULL;
	Blob_t			*pTempBufAddr = NULL;
	int32			nRetVal = PIN_BOOLEAN_TRUE;
	pin_zonemap_data_type_t	dt = PIN_ZONEMAP_DATA_BINARY;
	int32			*pnSearchMode;
	
	PIN_HEAP_VAR;

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_load_zonemap starting");

	/*
	 * Create flist for retrieving matrix
	 */
	pGetZonemapInFlist = PIN_FLIST_CREATE(ebufp);

	pSearchPoid = PIN_POID_CREATE(PIN_POID_GET_DB((poid_t *) pRoutingPoid), 
		"/zonemap", -1, ebufp);
	PIN_FLIST_FLD_PUT(pGetZonemapInFlist, PIN_FLD_POID, 
		(void *)pSearchPoid, ebufp);

	PIN_FLIST_FLD_SET(pGetZonemapInFlist, PIN_FLD_NAME, 
		(void *) pszTarget, ebufp);

	PIN_FLIST_FLD_SET(pGetZonemapInFlist, PIN_FLD_ZONEMAP_DATA_TYPE, 
		(void *) &dt, ebufp);

	PIN_FLIST_FLD_SET(pGetZonemapInFlist, PIN_FLD_ACCOUNT_OBJ,
		(void *) pBrandPoid, ebufp);

	/* 
	 * Call zonemap loading opcode (automatically seaches)
	 */
	PCM_OP(pCtx, PCM_OP_ZONEMAP_GET_ZONEMAP, 0, pGetZonemapInFlist, 
		&pGetZonemapOutFlist, ebufp);

	/*
	 * Process matrix
	 */
	pZonemaps = PIN_FLIST_ELEM_GET(pGetZonemapOutFlist,
				PIN_FLD_ZONEMAPS, 
				PIN_ELEMID_ANY, 1, ebufp);

	if (pZonemaps != NULL) {
		/*
		 * Found a zonemap, set current matrix poid 
		 */	
		PIN_SET_GLOBAL_HEAP;

		*ppZonemapPoid = PIN_POID_COPY((poid_t*) 
			PIN_FLIST_FLD_GET(pZonemaps,PIN_FLD_POID, 0, ebufp),
			ebufp);

		PIN_RESET_GLOBAL_HEAP;

		/*
		 * Grab default search mode (NULL means no default)
		 */
		pnSearchMode = (int32*) PIN_FLIST_FLD_GET(pZonemaps,
					PIN_FLD_ZONEMAP_SEARCH_TYPE, 1, ebufp);

		/* Did we find a default search mode? */
		if (pnSearchMode != NULL) {
			/* Yes: copy value to input */
			*pnDefaultSearchMode = *pnSearchMode;
		}
		else {
			/* No: indicate no default search mode */
			pnDefaultSearchMode = NULL;
		}

		/*
		 * Get address of buffer
		 */
		pBuf = (pin_buf_t *)PIN_FLIST_FLD_GET(pZonemaps, 
				PIN_FLD_ZONEMAP_DATA_DERIVED, 1, ebufp);

		if (pBuf != NULL &&
			(pBuf->data != NULL)) { 
			/* get the actual blob */
			pTempBufAddr = (Blob_t *)(pBuf->data);
	
			PIN_SET_GLOBAL_HEAP;

			/* Allocate memory to hold buffer on global heap */
			*ppBuffer = (Blob_t*) malloc(pTempBufAddr->blob_size);

			/* Copy buffer to global mem */
			memcpy(*ppBuffer, pTempBufAddr, 
				pTempBufAddr->blob_size);

			PIN_RESET_GLOBAL_HEAP;

		}
		else {
			*ppBuffer = NULL;
		
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_WARNING,
				    "fm_zonemap_pol_get_lineage_load_zonemap: "
				    "zonemap is empty!", ebufp);
		}
	}
	else {
		/*
		 * No zonemap found
		 */
		nRetVal = PIN_BOOLEAN_FALSE;
	}

	/*
	 * Clean up
	 */
	PIN_FLIST_DESTROY_EX(&pGetZonemapInFlist, NULL);
	PIN_FLIST_DESTROY_EX(&pGetZonemapOutFlist, NULL);

	if (PIN_ERR_IS_ERR(ebufp)) {
		nRetVal = PIN_BOOLEAN_FALSE;

		if (ebufp->pin_err == PIN_ERR_NO_MATCH) {

			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG,
			   "fm_zonemap_pol_get_lineage_load_zonemap: "
			   "no matrix");

			PIN_ERR_CLEAR_ERR(ebufp);

		} else {

			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
			    "fm_zonemap_pol_get_lineage_load_zonemap: error", 
			    ebufp);

		}

	}

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_load_zonemap returning");

	return nRetVal;
}

/*******************************************************************
 * fm_zonemap_pol_get_lineage_find_bucket():
 *
 *	Given a bucket in the hash table, this function returns 
 *	the matching entry in that bucket.
 *
 *******************************************************************/
static ZonemapHashEntry_t *
fm_zonemap_pol_get_lineage_find_bucket(
	ZonemapHashEntry_t	*pBucket, 
	const char		*pszTarget, 
	pin_errbuf_t		*ebufp) 
{

	ZonemapHashEntry_t	*pCurNode;

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_find_poid_in_bucket starting");

	/* For each node in list... */
	for (pCurNode = pBucket; pCurNode != NULL; 
		pCurNode = pCurNode->pNext) {
		/* Is this the one we want? */

		if (!strcmp(pszTarget, pCurNode->pszZonemapName)) {
			/* Yes: return */
			break;
		}
	}

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_find_poid_in_bucket returning");

	return pCurNode;
}

/*******************************************************************
 * fm_zonemap_pol_get_lineage_hash_zone_name():
 *
 *	Returns the hash value for the given zone name (a string)
 *
 *******************************************************************/
static int32 
fm_zonemap_pol_get_lineage_hash_zone_name(
	const char		*pszTarget) 
{

	unsigned long		nHashVal = 0;
	unsigned long		nCount;
	unsigned long		nMask = 0xF0000000;

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_hash_zone_name starting");

	/*
	 * Use your basic ELF hash
	 */
	while (*pszTarget) {
		nHashVal = (nHashVal << 4) + *pszTarget++;
		if (nCount = nHashVal & nMask) {
			nHashVal ^= nCount >> 24;
		}

		nHashVal &= ~nCount;
	}

	nHashVal %= TELEPHONY_ZONEMAPHASHTABLESIZE;

	/* Debug */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_hash_zone_name returning");

	return (int32) nHashVal;
}


/*******************************************************************
 * fm_zonemap_pol_get_lineage_search_zonemap():
 *
 *	Finds the lineage of the given string
 *
 *******************************************************************/
static
char *
fm_zonemap_pol_get_lineage_search_zonemap(
	Blob_t			*pBuffer, 
	char			*pszString,
	int32			nSearchMode, 
	pin_errbuf_t		*ebufp)
{

	/* Even though it's less readable than a recursive approach, 
	 * an iterative approach is used for performance reasons.
	 * This function is entered twice for every call, and thus must
	 * be sensitive to performance.
	 */

	TrieNode_t		*pCurNode = NULL;
	TrieNode_t		*pLastTerminal = NULL;
	LeafData_t		*pCurData = NULL;
	char			*pCur = NULL;
	char			*pszLabel = NULL;
	char			*pszResult = NULL;
	int32			nDone = 0;
	int32			nIndex = 0;
	int32			nDepth = 0;
	char			acLogBuf[512];

	/* Debug: Enter function */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_search_zonemap starting");

	/* Verify inputs */
	if (pBuffer == NULL) {
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
			"fm_zonemap_pol_get_lineage_search_zonemap called "
			"with no data: returning");
		return NULL;
	}
	/* Verify Blob version number */	
	if (pBuffer->version != ZONEMAP_CURRENT_VERSION) {
		sprintf(acLogBuf, "fm_zonemap_pol_get_lineage_search_zonemap: "
			"Wrong version of Zonemap.  Found %i, "
			"expecting %i. Ignoring zonemap. Use Configuration "
			"Center IPT to fix this problem.", pBuffer->version,
			ZONEMAP_CURRENT_VERSION);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, acLogBuf);
		return NULL;
	}

	/*
	 * Get a pointer to the target string as a cursor.
	 */
	pCur = pszString;
 
	/* Grab trie root & init flag */
	pCurNode = (TrieNode_t *) ((u_int32)pBuffer + 
		(u_int32)pBuffer->trie_start);

	pLastTerminal = NULL;
	nDone = PIN_BOOLEAN_FALSE;
	while (!nDone) {

		/*
		 * Pickup any applicable parent impact categories
		 */

		/* Is the current node a terminator? */
		if (pCurNode && pCurNode->isTerminal == PIN_BOOLEAN_TRUE) {
			/* Yes: Place bookmark */
			pLastTerminal = pCurNode;		
			/*
			 * Get the length of string we have searched.
			 */
			nDepth = pCur - pszString;
		}

		/*
		 * Check for more work & move forward
		 */

#ifdef IPT_DEBUG
		sprintf(acLogBuf, "String: '%s', Index: %d, Max %d", pCur, 
			EXTENDED_CHARSET_INDEX(*pCur), 
			EXTENDED_CHARSETSIZE);
		PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, acLogBuf);
#endif

		if (pCurNode == NULL) {
			PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, 
				"fm_zonemap_pol_get_lineage_search_zonemap: "
				"illegal memory access! Exiting");
			return NULL;
		}

		/* Does the string have more input? */
		if (*pCur != '\0') {
			/* Yes. Examine the current character */

			/* Convert the current character to an index */
			nIndex = EXTENDED_CHARSET_INDEX(*pCur);

			/* Is this index valid? */
			if (nIndex >= EXTENDED_CHARSETSIZE ||
				nIndex < 0) {
				/* No. Error condition, exit. */
				PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_ERROR, 
				    "fm_zonemap_pol_get_lineage_search_zonemap: "
				    "illegal input string! Exiting");
				return NULL;
			}
			
			/* Does the current node have children? */
			if (pCurNode->children[nIndex] != 0) {
				/* Yes: move forward */
				pCurNode = (TrieNode_t *) ((u_int32)pBuffer + 
					(u_int32)pCurNode->children[nIndex]);
				pCur++;
			}
			else {
				/* No: we're done */
				nDone = PIN_BOOLEAN_TRUE;
			}
		}
		else {
			/* No: we're done */
			nDone = PIN_BOOLEAN_TRUE;
		}
	}

	/* Are we in exact match mode? */
	if (nSearchMode == PIN_ZONEMAP_EXACT) {
		/* Yes: Are we at the end of the string & at a terminal node? */
		/* Note: DeMorgans laws applied to simplify boolean logic */
		if ((*pCur != '\0') || (pLastTerminal != pCurNode)) {
			/* No: set return value */
			pLastTerminal = NULL;
		}
	}

	/* Did we manage to find data? */
	if (pLastTerminal != NULL) {
		/* Yes: Grab data & set return value */
		pCurData = (LeafData_t*) ((u_int32)pBuffer + 
			(u_int32)pLastTerminal->leafdata_p);
				
		/* Yes: For each row in the list... */
		fm_zonemap_pol_get_lineage_from_ancestors((long) pBuffer,
			pCurData->ancestors_p, &pszLabel, ebufp);

		if (!PIN_ERR_IS_ERR(ebufp)) {
			/*
			 * Craft a return string that has both the lineage and 
			 * the data we just did the search based upon.
			 */


			if (pszLabel != NULL) {
				pszResult = (char *)malloc(strlen(pszLabel) + 
					nDepth + 1);
			}
			else {
				/*
				 * Only get the part of string based on which
				 * we did a search.
				 */
				*pCur = '\0';
				pszResult = (char *)malloc(nDepth + 1);
			}
				
			/*
			 * Check the memory allocation
			 */
			if (pszResult != NULL) {
				if (pszLabel != NULL) {
					strcpy(pszResult, pszLabel);
					strncat(pszResult, pszString, nDepth);
				}		
				else {
					strncpy(pszResult, pszString, nDepth);
				}
			}
			else {
				pin_set_err(ebufp, PIN_ERRLOC_FM,
					PIN_ERRCLASS_APPLICATION,
					PIN_ERR_NO_MEM, 0, 0, 0);
				PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
					"Memory allocation error in get "
					"lineage.", ebufp);
			}
		}
		else {
			/*
			 * Something went wrong.
			 */
			PIN_ERR_LOG_EBUF(PIN_ERR_LEVEL_ERROR,
				"Search lineage error.", ebufp);
			pszResult = (char *)NULL;
		}
	}
	else {
		/*
		 * No match
		 */
		pszResult = NULL;
	}

	/*
	 * Clean up memory because it is allocated elsewhere.
	 */
	if (pszLabel) {
		free(pszLabel);
	}

	/* Debug: Exit function */
	PIN_ERR_LOG_MSG(PIN_ERR_LEVEL_DEBUG, 
		"fm_zonemap_pol_get_lineage_search_zonemap returning");

	return pszResult;
}
