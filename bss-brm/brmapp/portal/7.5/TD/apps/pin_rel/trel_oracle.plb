CREATE OR REPLACE AND COMPILE
JAVA SOURCE NAMED "TrelStoredProcHelper"
AS
/*
 *     Copyright (c) 2006 Oracle. All rights reserved.
 *     This material is the confidential property of Oracle Corporation
 *     or its licensors and may be used, reproduced, stored
 *     or transmitted only in accordance with a valid Oracle license
 *     or sublicense agreement.
 */
package com.portal.trel;
import java.util.*;
import java.io.*;
import java.sql.*;
import oracle.sql.*;
import oracle.jdbc.*;
import oracle.jdbc.driver.*;
import com.portal.pcm.*;
import com.portal.pcm.fields.*;
/**
 * ComparePoid is used to compare two poid strings to determine 
 * their orderings.  It will first sort by poid type and then
 * poid id.
 */
class ComparePoid implements Comparator
{
	/**
	 * Compares its two arguments for order.
	 * @param o1 the first poid string to be compared.
	 * @param o2 the second poid string to be compared.
	 * @return a negative integer, zero, or a positive integer as the
	 * first poid string is less than, equal to, or greater than the
	 * second.
	 */
	public int compare(Object o1, Object o2)
	{
		String s1 = (String)o1;
		String s2 = (String)o2;
		// the poid string has the format as 
		// "<poid_db> <poid_type> <poid_id>"
		// NOTE: <poid_db> is constant in the same REL process
		// and there is no revision number in the poid string
		int pos1 = s1.lastIndexOf(' ');
		String type1 = s1.substring(0, pos1);
		String id1 = s1.substring(pos1+1);
		int pos2 = s2.lastIndexOf(' ');
		String type2 = s2.substring(0, pos2);
		String id2 = s2.substring(pos2+1);
		// to be generic, first compare the poid type
		int ret = type1.compareTo(type2);
		if (ret != 0)
		{
			return ret;
		}
		else
		{
			// if both have the same poid type, 
			// compare the poid id next
			return Long.valueOf(id1).compareTo(Long.valueOf(id2));
		}
	}
	/**
	 * Indicates whether some other object is "equal to" this Comparator.
	 * @param obj the reference object with which to compare.
	 * @return true only if the specified object is also a comparator and
	 * it imposes the same ordering as this comparator.
	 */
	public boolean equals(Object o)
	{
		String s = (String)o;
		return (compare(this, o)==0);
	}
}
public class TrelStoredProcHelper
{
	static final int RETRYCOUNT = 3;
	static final int SUCCESS = 0;
	static final int FAIL = 1;
	static final String NL = System.getProperty("line.separator", "\n");
	static private Hashtable contexts;
	static private Hashtable transids;
	static
	{
		contexts = new Hashtable();
		transids = new Hashtable();
	}
	/** Utility function: Make thread id out of two passed parameters */
	private static long makeThreadId(long session_id, long thread_id)
	{
		String tmp = String.valueOf(session_id) +
			     String.valueOf(thread_id);
		return (Long.parseLong(tmp));
	}
	/** Utility function: Retrieve context for the specified thread */
	private PortalContext getContext(long threadid)
	throws Exception
	{
		Long key = new Long(threadid);
		return ((PortalContext)(contexts.get(key)));
	}
	/** Utility function: Connect to the CM. */
	private static PortalContext connect(long threadid)
	throws EBufException, Exception
	{
		PortalContext value = null;
		Long key = new Long(threadid);
		value = ((PortalContext)(contexts.get(key)));
		if (value == null)
		{
			// create the connection
			value = new PortalContext();
			// login into the server
			value.connect();
			// save the context for this threadid
			contexts.put(key, value);
		}
		return value;
	}
	/** Utility function: Reconnect to the CM.<p>
	 *  This better be called *after* the connection died...
	 */
	private static PortalContext reconnect(long threadid)
	throws EBufException, Exception
	{
		Long key = new Long(threadid);
		// delete the dead connection context
		contexts.remove(key);
		// recreate the connection, etc.
		return connect(threadid);
	}
	/** Utility function: Create an flist from a set of poids.<p>
	 *  Return an flist with these fields, where the poids are passed in.
	 *  <pre>
	 *  0 PIN_FLD_POID      POID [0] 0.0.0.1 /dummy -1 0
	 *  0 PIN_FLD_POIDS    ARRAY [0]
	 *  1    PIN_FLD_POID   POID [0] <poid_1>
	 *  1    PIN_FLD_OPCODE  INT [0] 8		// i.e. PCM_OP_INC_FLDS
	 *  0 PIN_FLD_POIDS    ARRAY [1]
	 *  1    PIN_FLD_POID   POID [0] <poid_2>
	 *  1    PIN_FLD_OPCODE  INT [0] 8
	 *  etc.
	 *  </pre>
	 */
	private static FList createFlistBodyForPreCommit(String[] poids)
	throws EBufException, Exception
	{
		// poids array may contain duplicate poid with different
		// revision numbers, however, we just want to send it
		// once with the highest revision number which is always
		// the last one with the same poid id in the array
		// we also want to sort them by poid id to avoid
		// potential deadlock in TIMOS when sending pre-commit 
		// poid lists from multiple TREL processes
		TreeMap uniquePoids = new TreeMap(new ComparePoid());
		String poidId;
		String poidRev;
		for (int i = 0; i < poids.length; i++)
		{
			if (poids[i].length() == 0) // skip empty strings
			{
				continue;
			}
			String poid = poids[i];
			int pos = poid.lastIndexOf(' ');
			poidId = poid.substring(0, pos);
			poidRev = poid.substring(pos);
			// it will overwrite the old poid id with higher 
			// revision number if poid id already exists
			uniquePoids.put(poidId, poidRev);
		}
		FList retFlist = new FList();
		// build PIN_FLD_POIDS arrary with unique and sorted poid id's
		Set set = uniquePoids.entrySet();
		Iterator iterator = set.iterator();
		int elementId = 0;
		while (iterator.hasNext())
		{
			Map.Entry entry = (Map.Entry)iterator.next();
			poidId = (String)entry.getKey();
			poidRev = (String)entry.getValue();
			FList pFlist = new FList();
			Poid poid = Poid.valueOf(poidId + poidRev);
			pFlist.set(FldPoid.getInst(), poid);
			pFlist.set(FldOpcode.getInst(), 8);
						// PCM_OP_INC_FLDS
			retFlist.setElement(
				FldPoids.getInst(), elementId, pFlist);
			elementId++;
		}
		return retFlist; // will be empty if passed array was empty
	}
	/** Disconnect from the CM. */
	public static int disconnect(long s_id, long t_id)
	throws EBufException, Exception
	{
		long threadid = makeThreadId(s_id, t_id);
		Long key = new Long(threadid);
		// does thread have a connection?
		PortalContext pCtx = ((PortalContext)(contexts.get(key)));
		if (pCtx != null) // if null, something is wrong, but we're okay
		{
			// logout and end the connection
			pCtx.close(true);
			// clean up
			contexts.remove(key);
		}
		// clean up
		FList transid = ((FList)(transids.get(key)));
		if (transid != null)
		{
			transids.remove(key);
		}
		return SUCCESS;
	}
	/** Pre-commit changes to a bunch of objects */
	public static int precommit(long s_id, long t_id, oracle.sql.ARRAY allpoids)
	throws EBufException, Exception
	{
		return precommit(s_id, t_id, (String[])(allpoids.getArray()));
	}
	/** Pre-commit changes to a bunch of objects */
	public static int precommit(long s_id, long t_id, String[] poids)
	throws EBufException, Exception
	{
		long db, id, rev;
		String type;
		boolean retried = false;
		long threadid = makeThreadId(s_id, t_id);
		Long key = new Long(threadid);
		// if thread doesn't have a connection yet, create it
		PortalContext pCtx = connect(threadid);
		// brute-force attempt to remove the transid entry
		transids.remove(key);
		// create the input flist
		FList inFlist = createFlistBodyForPreCommit(poids);
		// set the routing poid
		Poid dummy = new Poid(pCtx.getCurrentDB(), -1, "/dummy");;
		inFlist.set(FldPoid.getInst(), dummy);
		for (int retries = 0; retries < RETRYCOUNT; retries++)
		{
			try
			{
				FList outFlist = pCtx.opcode(
					PortalOp.SYNC_PRE_COMMIT, 0, inFlist);
				// the return flist has this format:
				// 0 PIN_FLD_POID POID [0] 0.0.0.1 /dummy -1 0
				// 0 PIN_FLD_TRANS_ID STR [] <transid string>
				// the return flist has the same format as input
				// flist for postcommit and rollback opcodes, therefore,
				// save the entire output flist that contains transaction id
				// into transids hashtable
				transids.put(key, outFlist);
				// if we got here, it means we
				// interacted with the CM okay
				return SUCCESS;
			}
			catch (EBufException ebe)
			{
				DefaultLog.log(ErrorLog.Error,
							ebe.getErrorString());
				int err = ebe.getError();
				if ((err == PortalConst.ERR_CONNECTION_LOST) ||
				    (err == PortalConst.ERR_NAP_CONNECT_FAILED) ||
				    (err == PortalConst.ERR_STREAM_EOF) ||
				    (err == PortalConst.ERR_STREAM_IO))
				{
					// if we lost the CM, reconnect
					// and try again
					pCtx = reconnect(threadid);
					continue;
				}
				else if (err == PortalConst.ERR_RETRYABLE)
				{
					// we'll only retry once on a
					// RETRYABLE error
					if (retries <= (RETRYCOUNT - 2))
					{
						retries = RETRYCOUNT - 2;
						DefaultLog.log(ErrorLog.Debug,
							"Will retry...");
						continue;
					}
					// oh well, the retry failed too...
					throw ebe;
				}
				else
				{
					throw ebe;
				}
			}
			catch (Exception exe)
			{
				// so "new Long(threadid)" failed -- now what?
				DefaultLog.log(ErrorLog.Error,
							exe.getMessage());
				throw exe;
			}
		}
		return FAIL;
	}
	/** Post-commit changes to a bunch of objects */
	public static int postcommit(long s_id, long t_id)
	throws EBufException, Exception
	{
		try
		{
			long threadid = makeThreadId(s_id, t_id);
			Long key = new Long(threadid);
			FList inFlist = (FList)transids.get(key);
			// if thread doesn't have a connection yet, create it
			PortalContext pCtx = connect(threadid);
			if (inFlist == null)
			{
				String errmsg = "post-commit: The corresponding " +
						"pre-commit was not called";
				DefaultLog.log(ErrorLog.Error, errmsg);
				throw new Exception(errmsg);
			}
			else
			{
				for (int retries = 0; retries < RETRYCOUNT; retries++)
				{
					try
					{
						FList outFlist = pCtx.opcode(
							PortalOp.SYNC_POST_COMMIT, 0, inFlist);
						// if we got here, we interacted with the CM okay
						return SUCCESS;
					}
					catch (EBufException ebe)
					{
						DefaultLog.log(ErrorLog.Error, ebe.getErrorString());
						int err = ebe.getError();
						if ((err == PortalConst.ERR_CONNECTION_LOST) ||
							(err == PortalConst.ERR_NAP_CONNECT_FAILED) ||
							(err == PortalConst.ERR_STREAM_EOF) ||
							(err == PortalConst.ERR_STREAM_IO))
						{
							// if we lost the CM, reconnect and try again
							pCtx = reconnect(threadid);
							continue;
						}
						else
						{
							// this could be a RETRYABLE error... or not.
							// let the caller decide how to handle it.
							throw ebe;
						}
					}
				}
			}
		}
		catch (Exception exe)
		{
			// is there anything we can do to recover from this error?
			DefaultLog.log(ErrorLog.Error, exe.getMessage());
			throw exe;
		}
		return FAIL;
	}
	/** Rollback changes to a bunch of objects */
	public static int rollback(long s_id, long t_id)
	throws EBufException, Exception
	{
		try
		{
			long threadid = makeThreadId(s_id, t_id);
			Long key = new Long(threadid);
			FList inFlist = ((FList)(transids.remove(key)));
			// if thread doesn't have a connection yet, create it
			PortalContext pCtx = connect(threadid);
			if (inFlist == null)
			{
				String errmsg = "rollback: The corresponding " +
								"pre-commit was not called";
				DefaultLog.log(ErrorLog.Error, errmsg);
				throw new Exception(errmsg);
			}
			else
			{
				for (int retries = 0; retries < RETRYCOUNT; retries++)
				{
					try
					{
						FList outFlist = pCtx.opcode(
							PortalOp.SYNC_ROLLBACK, 0, inFlist);
						// if we got here, we interacted with the CM okay
						return SUCCESS;
					}
					catch (EBufException ebe)
					{
						DefaultLog.log(ErrorLog.Error, ebe.getErrorString());
						int err = ebe.getError();
						if ((err == PortalConst.ERR_CONNECTION_LOST) ||
						    (err == PortalConst.ERR_NAP_CONNECT_FAILED) ||
						    (err == PortalConst.ERR_STREAM_EOF) ||
						    (err == PortalConst.ERR_STREAM_IO))
						{
							// if we lost the CM, reconnect and try again
							pCtx = reconnect(threadid);
							continue;
						}
						else
						{
							// let the caller decide how to handle it.
							throw ebe;
						}
					}
				}
			}
		}
		catch (Exception exe)
		{
			// is there anything we can do to recover from this error?
			DefaultLog.log(ErrorLog.Error, exe.getMessage());
			throw exe;
		}
		return FAIL;
	}
//	---------------------------------------------------------------------
	public static void main(String args[])
	{
		String errmsg = null;
		String[] poidarray = new String[20];
		try
		{
			// this is terribly silly - we need a database connection
			// here just so we can make an ARRAY out of a String[].
			DriverManager.registerDriver(
				  new oracle.jdbc.driver.OracleDriver());
			Connection conn = DriverManager.getConnection(
						"jdbc:oracle:thin:@disteng.portal.com:1521:pindb",
						"pin9", "pin9");
			// assumes that the PIN user has run this sql command earlier:
			//    create or replace type poidarray as table of varchar2(255);
			oracle.sql.ArrayDescriptor descriptor =
				oracle.sql.ArrayDescriptor.createDescriptor("PIN9.POIDARRAY", conn);
			long start = System.currentTimeMillis();
			File file = new File("./test.poids");
			FileReader fr = new FileReader(file);
			BufferedReader br = new BufferedReader(fr);
			boolean hasMore = true;
			int ret = 0;
			while (hasMore)
			{
				for (int i = 0; i < 20; i++)
				{
					poidarray[i] = br.readLine();
					if (poidarray[i] == null)
					{
						// reach end of file
						hasMore = false;
						break;
					}
				}
				// for now, do not send if number of poids in list
				// is less than 20
				if (!hasMore)
				{
					break;
				}
				oracle.sql.ARRAY poids = 
					new oracle.sql.ARRAY(descriptor, conn, poidarray);
				// collect and dump how long the steps took.
				// (note: there is no COMMIT between the pre and post steps!)
				ret = precommit(1, 7, poids);
				if (ret == 1)
				{
					System.out.println("precommit failed");
				}
				ret = postcommit(1, 7);
				if (ret == 1)
				{
					System.out.println("postcommit failed");
				}
			}
			ret = disconnect(1, 7);
			if (ret == 1)
			{
				System.out.println("disconnect failed");
			}
			System.out.println("time to complete: "
				+ (System.currentTimeMillis() - start)
				+ " millisecs");
		}
		catch (EBufException ebe)
		{
			errmsg = ebe.getErrorString();
			DefaultLog.log(ErrorLog.Error, errmsg);
			System.out.println(errmsg);
			try
			{
			    System.out.println("rollback: " + rollback(1, 7));
			    System.out.println("disconnect: " + disconnect(1, 7));
			}
			catch (EBufException iebe)
			{
			    errmsg = iebe.getErrorString();
			    DefaultLog.log(ErrorLog.Error, errmsg);
			    System.out.println(errmsg);
			}
			catch (Exception iexe)
			{
			    errmsg = iexe.getMessage();
			    DefaultLog.log(ErrorLog.Error, errmsg);
			    System.out.println(errmsg);
			}
		}
		catch (Exception exe)
		{
			errmsg = exe.getMessage();
			DefaultLog.log(ErrorLog.Error, errmsg);
			System.out.println(errmsg);
		}
		System.out.println("see the default.pinlog file for details");
	}
//	---------------------------------------------------------------------
}
/
SHOW errors;
