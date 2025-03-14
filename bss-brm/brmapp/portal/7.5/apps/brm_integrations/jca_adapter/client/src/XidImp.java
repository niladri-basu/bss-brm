/*
 * (#)% %
 *
* Copyright (c) 2007, 2014, Oracle and/or its affiliates. All rights reserved.
 *
 * This material is the confidential property of Oracle Corporation or its
 * licensors and may be used, reproduced, stored or transmitted only in
 * accordance with a valid Oracle license or sublicense agreement.
 *
 */




package oracle.brm.test_client;

import javax.transaction.xa.*;
import java.util.Arrays;

public class XidImp implements Xid
{
	
    protected int formatId;
    protected byte gtrid[];
    protected byte bqual[];

    public XidImp()
    {
    }

    public XidImp(int formatId, byte gtrid[], byte bqual[])
    {
        this.formatId = formatId;
        this.gtrid = gtrid;
        this.bqual = bqual;
    }


    public int getFormatId()
    {
        return formatId;
    }

    public byte[] getBranchQualifier()
    {
    	  return bqual;
    }

    public byte[] getGlobalTransactionId()
    {
      return gtrid;
    }
    public String toStringLocal(){
    	 return ("TransID from ServletClient:" + Arrays.toString(gtrid)+ Arrays.toString(bqual));
    	 
    }

}



