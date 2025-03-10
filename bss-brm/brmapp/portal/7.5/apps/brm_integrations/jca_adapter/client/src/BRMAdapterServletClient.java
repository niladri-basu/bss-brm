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

import java.io.*;
import java.net.URL;
import java.util.Hashtable;
import java.util.logging.Logger;

import javax.naming.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.transaction.xa.XAException;
import javax.transaction.xa.XAResource;

import javax.resource.cci.*;
import javax.resource.ResourceException;
import javax.resource.spi.ManagedConnection;
import javax.xml.transform.dom.DOMSource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.FactoryConfigurationError;
import javax.xml.parsers.ParserConfigurationException;


/* Document to String transformer not working with OAS 10gR3
 import javax.xml.transform.OutputKeys;
 import javax.xml.transform.Result;
 import javax.xml.transform.Source;
 import javax.xml.transform.Transformer;
 import javax.xml.transform.TransformerConfigurationException;
 import javax.xml.transform.TransformerException;
 import javax.xml.transform.TransformerFactory;
 import javax.xml.transform.stream.StreamResult;
 */

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.Document;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

//import org.apache.log4j.Logger;
//import org.apache.log4j.spi.LoggerFactory;

//doc to string serializer
import org.apache.xml.serialize.OutputFormat;
import org.apache.xml.serialize.XMLSerializer;


//import oracle.tip.adapter.api.log.LogManager;
//import oracle.tip.adapter.fw.log.LogManagerImpl;

import oracle.tip.adapter.api.record.RecordElement;
import oracle.tip.adapter.api.record.XMLRecord;
import oracle.tip.adapter.api.record.XMLRecordFactory;
import oracle.tip.adapter.fw.record.XMLRecordFactoryImpl; //BRM Adapter
import oracle.tip.adapter.brm.*;

import org.apache.log4j.Appender;
import org.apache.log4j.Level;

import oracle.brm.test_client.BRMAdapterServletException;
import oracle.brm.test_client.XidImp;

/**
 * Servlet to test the BRM JCA Adapter, deploy this to OC4J and intiate the 
 * test by using the below URL:
 * <p>http://hostname:8888/BRMAdapterServletClient</p>
 * Suppy the interaction spec parameter, opcode name, opcode flag,
 * opcode schema and the input XML data
 * 
 * <p><b>Note:</b> Deploy this only after deploying the BRM Adapter, 
 * otherwise deployment will fail
 * 
 * @author siva
 */

public class BRMAdapterServletClient extends HttpServlet {
    ConnectionFactory cF;

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
    doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
    //   Static logger
        
        brmLogger.info("\n\n\n\n::::::::::::::" + BRM_CLIENT + "Connecting to BRM Adapter...::::::::::::::\n\n\n");

    //intialise the result and response writer
    String result = null;
    PrintWriter wr = response.getWriter();
    Connection con = null;
    long currentTime = System.currentTimeMillis();
    try {

        String jndiLocation = request.getParameter("jndiLocation");
        String message = request.getParameter("message");
        String opcodeName = request.getParameter("opcodeName");
        String opcodeFlag = request.getParameter("opcodeFlag");
        String opcodeSchema = request.getParameter("opcodeSchema");
        String isBaseOpcode = request.getParameter("baseOpcode");
        String inputValidation = request.getParameter("inputValidation");
        String outputValidation = request.getParameter("outputValidation");
        String t_Mode =request.getParameter("tmode");
 	
	String filePath =request.getParameter("multiOpcodes");
        String NumberOfOpcodes = request.getParameter("NumberOfOpcodes");
        Integer msgnum = Integer.parseInt(NumberOfOpcodes.trim());
        String opCodes[]= new String[msgnum];
        String inXml[] = new String[msgnum];
	Boolean filePathFlag = false;
        if((filePath != null)&&(!filePath.equalsIgnoreCase("Default")))
        {
            brmLogger.fine(BRM_CLIENT + "Processing multiOpcodes from the test file =" + filePath);
		filePathFlag =true;
            getOpcodesAndInputXml(opCodes, inXml, filePath);
        }
        brmLogger.fine(BRM_CLIENT + "JNDI location: " + jndiLocation);
        brmLogger.fine(BRM_CLIENT + "Opcode name: " + opcodeName);
        brmLogger.fine(BRM_CLIENT + "Opcode flag: " + opcodeFlag);
        brmLogger.fine(BRM_CLIENT + "Opcode schema: " + opcodeSchema);
        brmLogger.fine(BRM_CLIENT + "Base opcode: "
            + (isBaseOpcode == null ? "false" : "true"));
        brmLogger.fine(BRM_CLIENT + "Input Validation Not Required: "
            + (inputValidation == null ? "false" : "true"));
        brmLogger.fine(BRM_CLIENT + "Output Validation Not Required: "
            + (outputValidation == null ? "false" : "true"));

        brmLogger.fine(BRM_CLIENT + "Input message: " + message + "\n");

        boolean err = false;
        if (jndiLocation != null) {
        jndiLocation = jndiLocation.trim();
        if (jndiLocation.equals(""))
            err = true;
        } else {
        err = true;
        }

        if (err) {
        throw new BRMAdapterServletException("JNDI location name cannot be empty or null, <p>"
            + "pls correct it by, use the browser back button</p>");
        }
            
        //Get context for JNDI lookup
        Context iC = new InitialContext();
        brmLogger.fine(BRM_CLIENT + "Got the AS context ");
        //System.out.println("Got the AS context ");

        //JNDI lookup
        
         currentTime = System.currentTimeMillis();
         
         brmLogger.fine(BRM_CLIENT + "Getting JNDI  " +jndiLocation);
        
            
        String name = "java:comp/env/" + jndiLocation;
        cF = (ConnectionFactory) iC.lookup(jndiLocation);

        
        brmLogger.fine(BRM_CLIENT
            + "Look up succeeded.. creating a connection ");

        XMLRecordFactory xRF = new XMLRecordFactoryImpl();
    //    cF.setXMLRecordFactory(xRF);

        //BRMAdapter does not support ConnectionSpec
        /* ConnectionSpec needs to be created and sent
         * need to create an Interface for BRMConnectionSpec
           ConnectionSpec cS = new BRMConnectionSpec();
           cS.setUsername("root.0.0.0.1");
           cS.setPassword("password");0
           Connection con = (Connection)cF.getConnection(cS);
         */

        //Get the Connection 
        brmLogger.fine("Getting the Connection Con ");
        con = cF.getConnection();
        brmLogger.fine("Got the Connection Con ");
        
        if(t_Mode.equals("XAT"))
        {
            	Integer i=0;
		byte[] gid = Double.toString(Math.random()).getBytes();
		byte[] bqual = Double.toString(Math.random()).getBytes();
		
		XidImp xid = new XidImp(100, gid, bqual);	
		brmLogger.fine(" here is xid.toString from servlet  = "+xid.toString() );
		brmLogger.fine(" here is local implementation; xid in byteArray   = "+xid.toStringLocal() );
		Boolean closeConnection = false;
		if(filePathFlag) {
			String result_temp= "--Result of "+ msgnum+" Opcodes Execution--";
			while( msgnum>i)
			{
                            String opcode = opCodes[i];
                            String opcodeXmlMsg= inXml[i];
                            ++i;
                            closeConnection = ((i== msgnum)?true:false);
                            result =executeXARequest((IBRMConnection) con, opcodeXmlMsg, opcode, isBaseOpcode, inputValidation, outputValidation,xid,closeConnection);
			    result_temp += System.getProperty("line.separator") + "*********   Ouput XML " + i + "  ********"+ System.getProperty("line.separator")+ result;
                            if(closeConnection){
				String outFile = filePath+".out";
				PrintWriter out = new PrintWriter(outFile);
				out.println(result_temp);
				out.close();
                           }
			}
		}	
                else
                {
                       result =executeXARequest((IBRMConnection) con, message, opcodeName, isBaseOpcode, inputValidation, outputValidation,xid, true);

                }
        }
            
        if (t_Mode.equals("LCT"))
        {

        	int i =0;
        	Boolean closeConnection = false;
        	
    		if(filePathFlag) {
            	LocalTransaction tx = con.getLocalTransaction();
                tx.begin();
    			String result_temp= "--Result of "+ msgnum+" Opcodes Execution-- Local Transaction";
    			while( msgnum>i)
    			{
                                String opcode = opCodes[i];
                                String opcodeXmlMsg= inXml[i];
                                ++i;
                                closeConnection = ((i== msgnum)?true:false);
                                result = executeLCTRequest((IBRMConnection) con, opcodeXmlMsg, opcode, isBaseOpcode, inputValidation, outputValidation, tx);
    			    result_temp += System.getProperty("line.separator") + "*********   Ouput XML " + i + "  ********"+ System.getProperty("line.separator")+ result;
                    if(closeConnection){
                                	con.close();
                                    tx.commit();
                                    String outFile = filePath+".out";
                                    PrintWriter out = new PrintWriter(outFile);
                                    out.println(result_temp);
                                    out.close();
                    }
    			}
    			
    		}	else 
            result = executeLCTRequest((IBRMConnection) con, message, opcodeName, isBaseOpcode, inputValidation, outputValidation);
        }
            
        if (t_Mode.equals("NOT"))
        {
            int i =0;
            Boolean closeConnection = false;
            String PCM_OP_TRANS_COMMIT=null,PCM_OP_TRANS_OPEN=null;
            if(filePathFlag) {
               PCM_OP_TRANS_OPEN = "<PCM_OP_TRANS_OPEN_inputFlist xmlns=\"http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes\">"
            + "<POID>0.0.0.1 /poid -1 0</POID></PCM_OP_TRANS_OPEN_inputFlist>";
               PCM_OP_TRANS_COMMIT = "<PCM_OP_TRANS_COMMIT_inputFlist xmlns=\"http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes\">"
            + "<POID>0.0.0.1 /poid -1 0</POID></PCM_OP_TRANS_COMMIT_inputFlist>";
            boolean multiOpcode = true;
            String result_temp= "--Result of "+ msgnum+" Opcodes Execution-- No Transaction";
            executeOpcode((IBRMConnection) con, PCM_OP_TRANS_OPEN, "PCM_OP_TRANS_OPEN", isBaseOpcode, inputValidation, outputValidation);
            while( msgnum>i) {
             String opcode = opCodes[i];
             String opcodeXmlMsg= inXml[i];
             ++i;
             closeConnection = ((i== msgnum)?true:false);
             result = executeNOTRequest((IBRMConnection) con, opcodeXmlMsg, opcode, isBaseOpcode, inputValidation, outputValidation, multiOpcode);
             result_temp += System.getProperty("line.separator") + "*********   Ouput XML " + i + "  ********"+ System.getProperty("line.separator")+ result;
             if(closeConnection){
               executeOpcode((IBRMConnection) con, PCM_OP_TRANS_COMMIT, "PCM_OP_TRANS_COMMIT", isBaseOpcode, inputValidation, outputValidation);
               con.close();
               String outFile = filePath+".out";
               PrintWriter out = new PrintWriter(outFile);
               out.println(result_temp);
               out.close();
             }
            }
           }
           else{
            result = executeNOTRequest((IBRMConnection) con, message, opcodeName, isBaseOpcode, inputValidation, outputValidation);
          }
        }
    }
    catch(Exception ex){
        String errMsg = null;
        if (ex instanceof BRMAdapterServletException) {
        errMsg = "<HTML><HEAD><TITLE>Client Error"
            + "</TITLE></HEAD><BODY>Error in Adapter client, "
            + "err: <p>" +  ex.getMessage()
            + "</p><p>check the client and opmn log "
            + "</p>Press the browser back button to correct and "
            + "re-test</BODY></HTML>";
        } else {
        errMsg = "<HTML><HEAD><TITLE>Error calling the adapter"
            + "</TITLE></HEAD><BODY>Error calling the Adapter, "
            + "err: <p>" + ex.getMessage()
            + "</p><p>check the adapter(opmn) log "
            + "and the BRM logs"
            + "</p>Press the browser back button to "
            + "re-test</BODY></HTML>";
        }
        brmLogger.info("\n\n\n\n::::::::::::::" + BRM_CLIENT + "DISConnecting FROM  BRM Adapter...::::::::::::::\n\n\n");
        wr.println(errMsg);
                //response.sendError(response.SC_BAD_REQUEST);
        }
        wr.println(result);
    }

    public String executeNOTRequest(IBRMConnection con, String message, String opcodeName, String isBaseOpcode, String inputValidation, String outputValidation, boolean multiOpcode) throws Exception {
           String PCM_OP_TRANS_ABORT = null;
           PCM_OP_TRANS_ABORT = "<PCM_OP_TRANS_ABORT_inputFlist xmlns=\"http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes\">"
        + "<POID>0.0.0.1 /poid -1 0</POID></PCM_OP_TRANS_ABORT_inputFlist>";
            try{
                   return  executeOpcode((IBRMConnection) con, message, opcodeName, isBaseOpcode, inputValidation, outputValidation);
            }
            catch(Exception ex)
            {
               brmLogger.severe(executeOpcode((IBRMConnection) con, PCM_OP_TRANS_ABORT, "PCM_OP_TRANS_ABORT", isBaseOpcode, inputValidation, outputValidation));
               con.close();
               throw ex;
            }
    }

    public String executeNOTRequest(IBRMConnection con, String message, String opcodeName, String isBaseOpcode, String inputValidation, String outputValidation) throws Exception { 
        
        String not_Result=null,PCM_OP_TRANS_COMMIT=null,PCM_OP_TRANS_ABORT=null,PCM_OP_TRANS_OPEN=null;
        PCM_OP_TRANS_OPEN = "<PCM_OP_TRANS_OPEN_inputFlist xmlns=\"http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes\">"
            + "<POID>0.0.0.1 /poid -1 0</POID></PCM_OP_TRANS_OPEN_inputFlist>";

        PCM_OP_TRANS_COMMIT = "<PCM_OP_TRANS_COMMIT_inputFlist xmlns=\"http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes\">"
            + "<POID>0.0.0.1 /poid -1 0</POID></PCM_OP_TRANS_COMMIT_inputFlist>";
        PCM_OP_TRANS_ABORT = "<PCM_OP_TRANS_ABORT_inputFlist xmlns=\"http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes\">"
        + "<POID>0.0.0.1 /poid -1 0</POID></PCM_OP_TRANS_ABORT_inputFlist>";
        try{
        executeOpcode((IBRMConnection) con, PCM_OP_TRANS_OPEN, "PCM_OP_TRANS_OPEN", isBaseOpcode, inputValidation, outputValidation);
        not_Result = executeOpcode((IBRMConnection) con, message, opcodeName, isBaseOpcode, inputValidation, outputValidation);
        executeOpcode((IBRMConnection) con, PCM_OP_TRANS_COMMIT, "PCM_OP_TRANS_COMMIT", isBaseOpcode, inputValidation, outputValidation);
        con.close();
        }
        catch(Exception ex)
        {
            // brmLogger.severe(executeOpcode((IBRMConnection) con, PCM_OP_TRANS_ABORT, "PCM_OP_TRANS_ABORT", isBaseOpcode, inputValidation, outputValidation));
             con.close();
             throw ex;
        }
        return not_Result;
        
    }

public String executeLCTRequest(IBRMConnection con, String message, String opcodeName, String isBaseOpcode, String inputValidation, String outputValidation, LocalTransaction tx) throws Exception {
        
        String lct_Result=null;
        try {
            lct_Result = executeOpcode((IBRMConnection) con, message, opcodeName, isBaseOpcode, inputValidation, outputValidation);
        }
        catch(Exception ex)
        {
            con.close();
            tx.rollback();
            throw ex;
        }
        
        return lct_Result;
    }
    
    public String executeLCTRequest(IBRMConnection con, String message, String opcodeName, String isBaseOpcode, String inputValidation, String outputValidation) throws Exception {
        
        String lct_Result=null;
        LocalTransaction tx = con.getLocalTransaction();
        try {
            tx.begin();
            lct_Result = executeOpcode((IBRMConnection) con, message, opcodeName, isBaseOpcode, inputValidation, outputValidation);
            con.close();
            tx.commit();
        }
        catch(Exception ex)
        {
            con.close();
            tx.rollback();
            throw ex;
        }
        
        return lct_Result;
    }
    public String executeXARequest(IBRMConnection con, String message, String opcodeName, String isBaseOpcode, String inputValidation, 
				String outputValidation,XidImp xid, Boolean closeConFlag) throws Exception
    {
       // byte[] gid = Double.toString(Math.random()).getBytes();
        //byte[] bqual = Double.toString(Math.random()).getBytes();
        //XidImp xid = null;
        XAResource xar = null;
        String xa_Result = null;
        try
        {
            xar = ((IBRMConnection) con).getManagedConnection().getXAResource();
            String result = null;
            brmLogger.fine("Managed Connection 1 ID@BRMTESTClient " + ((IBRMConnection) con).getManagedConnection() + "\n ID :: " + Thread.currentThread().getId());
            
            // Initialize the Transaction ID (XId)
            
            //   xid = new XidImp(100, gid, bqual);
            brmLogger.fine("" + xid.getGlobalTransactionId() + ":" + xid.getFormatId() + "  :" + xid.getBranchQualifier());
            // set the transaction Time
            xar.setTransactionTimeout(3000);  //increased as with 60 sec, db could not commit, and turned it into inDoubt trans
            
            // start the transaction
            
            xar.start(xid, XAResource.TMNOFLAGS);
            
            // execute the Opcode
            
            xa_Result = executeOpcode((IBRMConnection) con, message, opcodeName, isBaseOpcode, inputValidation, outputValidation);
            
            brmLogger.fine(result + "\n ID :: " + Thread.currentThread().getId());
	   
	    xar.end(xid, 1); 
	    // send prepare ( commit 1)
	    int ret = xar.prepare(xid);
            brmLogger.fine("retcode at prepare" + ret + Thread.currentThread().getId());
		            
            
            // close the connection , the connection doesnt gets automatically
            // closed .
  	if(closeConFlag)
        {
                con.close();
		if (ret!=3) //3 is xa code, to indicate that commit has been done already!
                xar.commit(xid, false);
        }
            // return the result
            return xa_Result;
        } catch (Exception ex)
        {
            brmLogger.severe(BRM_CLIENT + "caught exception: " + ex);
            ex.printStackTrace();
            try
            {
                xar.end(xid, 1);
                con.close();
                xar.rollback(xid); //if exception then anyway rollback is required, 
                throw ex;
            } catch (Exception e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            throw ex;
        }
       
    }
    public String executeOpcode(IBRMConnection con, String message,String opcodeName,String isBaseOpcode, String inputValidation,String outputValidation
        ) throws BRMAdapterServletException,
        ResourceException, InstantiationException, IllegalAccessException,
        ClassNotFoundException {

    String result = null;
    String opcodeFlag = null;
    String opcodeSchema = opcodeName + ".xsd";
    
    boolean err = false;

    if (message != null) {
        message = message.trim();
        if (message.equals(""))
        err = true;
    } else {
        err = true;
    }

    if (opcodeName != null) {
        opcodeName = opcodeName.trim();
        if (opcodeName.equals(""))
        err = true;
    } else {
        err = true;
    }

    if (err) {
        throw new BRMAdapterServletException("JNDI location or "
            + "message or opcode name cannot be empty or null, <p>"
            + "pls correct it by, use the browser back button</p>");
    }
     // Set the Configurations , Base opcode, Validation of the Input and Output XMLs
    boolean baseOp = (isBaseOpcode == null ? false : true);
    boolean inValidation = (inputValidation != null ? true : false);
    boolean outValidation = (outputValidation != null ? true : false);
    //create records 
    XMLRecord inXR = createXMLRecordFromString(message);
    XMLRecord outXR = createXMLRecordFromString();

    // valid
    RecordElement inPayload = inXR.getPayloadRecordElement();

    Element elem = inPayload.getDataAsDOMElement();

    if (elem == null) {
        throw new BRMAdapterServletException(
            "Bad document in input payload");
    }

    BRMInteractionSpec iS = (BRMInteractionSpec) Class.forName(
        "oracle.tip.adapter.brm.BRMInteractionSpec").newInstance();
    iS.setConnectionFactory(cF);
    iS.setOpcodeFlags(0);
    iS.setOpcodeName(opcodeName);
    iS.setOpcodeSchema(opcodeSchema);

    if (baseOp) {
        iS.setIsBase("true");
    } else {
        iS.setIsBase("false");
    }

    iS.setValidation("ValidationRequired");
    if (inValidation == false)
        iS.setValidationAttr("InputValidationNotRequired");

    if (outValidation == false)
        iS.setValidationAttr("OutputValidationNotRequired");

    if (inValidation == false && outValidation == false)
        iS.setValidation("ValidationNotRequired");

    // if (inValidation) {
    // iS.setValidation("ValidationRequired");
    // } else {
    // iS.setValidation("ValidationRequired");
    // iS.setValidationAttr("InputValidationNotRequired");
    // }
    // if (outValidation) {
    // iS.setValidation("ValidationRequired");
    // } else {
    // iS.setValidation("ValidationRequired");
    // iS.setValidationAttr("OutputValidationNotRequired");
    // }
    //
    // if(inValidation && outValidation)
    // iS.setValidation("ValidationNotRequired");

    // Populate InteractionSpec
    Interaction intr = con.createInteraction();

    if (intr == null) {
        brmLogger.severe(BRM_CLIENT
            + "Error createInteraction returns null");
        // System.out.println("Error createInteraction returns null");
        throw new ResourceException("Error createInteraction returns null");
    }

    // Execute

    intr.execute(iS, inXR, outXR);

    if (outXR != null) {
        result = getStringFromXMLRecord(outXR);
    }
    return result;

    }

    /**
     * Close the underlying physical handle and Connection
     * 
     * @param con Connection handle
    */
/*    private void closeConnection(Connection con) {

    try {
        brmLogger.fine("Closing the Connection and Context");
        if (con != null) {
        ManagedConnection mCon = ((IBRMConnection) con)
            .getManagedConnection();

        if (mCon != null) { //destroy the connection handle
             This should not be done in case connection pooling is enabled,
             * the AS takes care of maintaining the connections
             
            mCon.destroy();
            brmLogger.fine(BRM_CLIENT + "Context closed...");
        }

        if (con != null) { //close the Connection
            con.close();
            brmLogger.fine(BRM_CLIENT + "Connection closed...");
        }
        }
    } catch (ResourceException ex) {
        System.out.println(BRM_CLIENT
            + "Error closing the Connection or Context"
            + ex.getMessage());
        brmLogger.severe(BRM_CLIENT
            + "Error closing the Connection or Context");

    }
    }
*/
    /**
     * Create a XMLRecord to be sent to the Adpater
     * 
     * @return XMLRecord
     * @throws BRMAdapterServletException
     */
    private XMLRecord createXMLRecordFromString()
        throws BRMAdapterServletException {

    XMLRecordFactory xRF = new XMLRecordFactoryImpl();

    RecordElement rEH = xRF.createHeaderRecordElement();
    RecordElement rEP = xRF.createPayloadRecordElement();

    XMLRecord xR = xRF.createXMLRecord();

    if (xR == null) {
        throw new BRMAdapterServletException("Error creating XMLRecord");
    }

    xR.setHeaderRecordElement(rEH);
    xR.setPayloadRecordElement(rEP);

    return xR;
    }

    /**
     * Create a XMLRecord to be sent to the Adpater from the passed-in String
     * 
     * @param inXML input XML String
     * @return XMLRecord
     * @throws BRMAdapterServletException
     */
    private XMLRecord createXMLRecordFromString(String inXML)
        throws BRMAdapterServletException {

    Document doc = createDocFromStr(inXML);

    brmLogger.fine(BRM_CLIENT + "Input doc: [" + getStringFromDoc(doc)
        + "]");
    //System.out.println("Input doc: [" + getStringFromDoc(doc) + "]");

    XMLRecordFactory xRF = new XMLRecordFactoryImpl();

    RecordElement rEH = xRF.createHeaderRecordElement();
    RecordElement rEP = xRF.createPayloadRecordElement();

    rEH.setData(null);

    DOMSource payloadData = new DOMSource((Node) doc.getDocumentElement());
    rEP.setData(payloadData);

    /*
    rEP.setData(inXML);

    String str = (String)rEP.getData();
    if(str != null) {
        System.out.println("record element get data: [" + str + "]");
    }
     */
    if (rEP.getDataAsDOMElement() == null) {
        throw new BRMAdapterServletException(
            "Bad document in input payload");
    }

    XMLRecord xR = xRF.createXMLRecord();

    if (xR == null) {
        throw new BRMAdapterServletException("Error creating XMLRecord");
    }

    xR.setHeaderRecordElement(rEH);
    xR.setPayloadRecordElement(rEP);

    return xR;
    }

    /**
     * Method to create a Document from passed-in String
     * 
     * @param str XML in String format
     * @return w3c Document
     * @throws BRMAdapterServletException
     */
    private Document createDocFromStr(String str)
        throws BRMAdapterServletException {

    String errMsg = null;
    try {
        if (str == null) {
        System.err.println(BRM_CLIENT + "Error: Invalid input string");
        return null;
        }

        StringReader sR = new StringReader(str);
        InputSource is = new InputSource(sR);

        //javax.xml.parsers.
        DocumentBuilderFactory factory = DocumentBuilderFactory
            .newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(is);

        return doc;
    } catch (FactoryConfigurationError e) {
        errMsg = "Unable to get a document builder factory: ";
        brmLogger.severe(errMsg);
        throw new BRMAdapterServletException(errMsg + e.getMessage());
       
    } catch (ParserConfigurationException e) {
        errMsg = "Parser was unable to be configured: ";
        brmLogger.severe(errMsg + e);
        throw new BRMAdapterServletException(errMsg + e.getMessage());
       
    } catch (SAXException e) {
        errMsg = "Parsing error: ";
        brmLogger.severe(errMsg + e);
        throw new BRMAdapterServletException(errMsg + e.getMessage());
       
    } catch (IOException e) {
        errMsg = "I/O error: ";
        brmLogger.severe(errMsg + e);
        throw new BRMAdapterServletException(errMsg + e.getMessage());

    }
    }

    /**
     * Method to get String from XMLRecord
     * 
     * @param inRecord XMLRecord
     * @return String XMLRecord content
     * @throws BRMAdapterServletException
     */
    private String getStringFromXMLRecord(XMLRecord inRecord)
        throws BRMAdapterServletException {

    RecordElement headers = ((XMLRecord) inRecord).getHeaderRecordElement();
    RecordElement payload = ((XMLRecord) inRecord)
        .getPayloadRecordElement();

    Element elem = payload.getDataAsDOMElement();

    Document inDoc = null;
    if (elem == null) {
        throw new BRMAdapterServletException(
            "Bad document in output payload");
    } else {
        inDoc = elem.getOwnerDocument();
    }

    String str = getStringFromDoc(inDoc);

    return str;
    }
   /* read opcodes and Input xml from a file
     * @ params filePath
     * returns opCodes array
     * returns inXml array
     */
    public void getOpcodesAndInputXml(String opCodes[], String inXml[], String filePath) {

        String strLine;
        //String opcodes[]= new String[3];
        //String opcodeXml[] = new String[3];
        //Integer msgnum =0;
        Integer j=0;
        Integer l =0;
        BufferedReader br =null;
        String str1 ="FLIST";

        try{
                 //Open  file
                 FileReader fstream = new FileReader(filePath);
                 br = new BufferedReader(fstream);
                 //Read File Line By Line
                 while ((strLine = br.readLine()) != null)
                 {
                        Integer index =0;
                         if(strLine.indexOf('#')== 0)
                            continue;
                         if (!str1.equals("FLIST_PART"))
                         {
                                index=strLine.indexOf('=');
                                str1 =strLine.substring(0,index);
                         }
                         if(str1.equals("OPCODE"))
                         {
                                 l=strLine.lastIndexOf(';');
                                 String s = strLine.substring(index+1,l);
                                 opCodes[j] = s;

                         }
                        else if(str1.equals("MESSAGE"))
                        {
                                l=strLine.lastIndexOf(';');
                                String t;
                                if (l<0)
                                {
                                    String s= strLine.substring(index+1);
                                    inXml[j] =s;
                                    //flist is not complete, we should read remaining Flist
                                    str1 ="FLIST_PART";
                                }
                                else {

                                    String s= strLine.substring(index+1,l);
                                    inXml[j] =s;
                                    ++j;
                                }

                        }
                        else
                        {
                                l=strLine.lastIndexOf(';');
                                String xml=null;
                                String newline = System.getProperty("line.separator");
                                if (l < 0)
                                {

                                    //xml = strLine.substring(index+1);
                                    inXml[j] =inXml[j]+newline+strLine;
                                        str1 ="FLIST_PART";
                                }
                                else {
                                    xml = strLine.substring(0,l);
                                    inXml[j] =inXml[j]+newline+xml;
                                        ++j;
                                         str1 ="FLIST:";

                                }

                        }
                    }
                 }
      	catch (Exception e){//Catch exception if any
              System.err.println("Error: " + e.getMessage());
      	}
        finally {
                                try {
                                        if (br != null)br.close();
                                } catch (IOException ex) {
                                        ex.printStackTrace();
                                }
                }
        }//getOPcodeAndInputXml


    /**
     * Utility method to convert XML document as a string.
     * 
     * @return String of the XML document created from the flist or null
     * if problems are encountered.
     */
    /* Transformation does not work with AS, may be xalan not found
    private String getStringFromDoc(Document doc) {

        System.out.println("Generating String from XML");

        StringWriter sW = new StringWriter();
        TransformerFactory tFactory = TransformerFactory.newInstance();

        if (tFactory.getFeature(DOMSource.FEATURE) &&
            tFactory.getFeature(StreamResult.FEATURE)) {

            Source src = new DOMSource(doc);
            Result result = new StreamResult(sW);

            try {
                Transformer trans = tFactory.newTransformer();
                trans.setOutputProperty(OutputKeys.METHOD, "xml");
                trans.setOutputProperty(OutputKeys.INDENT, "yes");
                trans.setOutputProperty(
                    "{http://xml.apache.org/xslt}indent-amount", "4");
                trans.transform(src, result);
            } catch (TransformerConfigurationException ex) {
                System.out.println("Transformer Configuration Exception, err: " +
                               ex);
                return null;
            } catch (TransformerException ex) {
                System.out.println("Transformer Exception, err: " + ex);
                return null;
            }
        }

            System.out.println("XML Document to String: \n" + sW.toString());

        return sW.toString();
    }
     */
    private String getStringFromDoc(Document doc)
        throws BRMAdapterServletException {

    if (doc == null) {
        throw new BRMAdapterServletException(
            "Null document in String to Document");
    }
    OutputFormat format = new OutputFormat(doc);
    // as a String
    StringWriter stringOut = new StringWriter();
    XMLSerializer serial = new XMLSerializer(stringOut, format);
    try {
        serial.serialize(doc);
    } catch (java.io.IOException ie) {
        brmLogger.warning(BRM_CLIENT            + "Error getting the string from doc " + ie);
        throw new BRMAdapterServletException("Error getting the string "
            + "from doc " + ie.getMessage());
        //System.out.println("ie: " + ie);
    }
    // Display the XML
    brmLogger.fine(BRM_CLIENT + "converted str: " + stringOut.toString());
    //System.out.println("converted str: " + stringOut.toString());

    return stringOut.toString();
    }

    //Logging name
    private static final Logger brmLogger =  BRMLogger.getLogger();
    private static final String BRM_CLIENT = "BRMAdapterServletClient: ";

}
