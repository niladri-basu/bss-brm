/*
 * (#)% %
 *
 * Copyright (c) 2007, 2009, Oracle and/or its affiliates. 
 * All rights reserved. 
 *
 * This material is the confidential property of Oracle Corporation or its
 * licensors and may be used, reproduced, stored or transmitted only in
 * accordance with a valid Oracle license or sublicense agreement.
 *
 */




package oracle.brm.test_client;
import java.util.logging.Logger;

public class BRMLogger 
{
    private static Logger logger =Logger.getLogger("oracle.tip.adapter.brm.BRMAdapterServletClient");
    
    public BRMLogger() {
	
	System.out.println("****************************************************");
    }
    public static void logInfo(String message) {
        logger.info(message);
        System.out.println( "**********"+ message);
        
        }
    public static void logDebug(String message) {
	logger.fine(message);
	System.out.println( "**********"+ message);
	
    }
    public static void logError(String message) {
	// TODO Auto-generated method stub
	logger.warning(message);
	System.out.println( "**********"+ message);
    }
    public static void logError(String message, Exception  e) {
	// TODO Auto-generated method stub
	logger.warning(message+e.getMessage());
	System.out.println( "**********"+ message+ "********" + e.getMessage());
    }
    public static void warning(String message) {
	// TODO Auto-generated method stub
	logger.warning(message);
	System.out.println( "**********"+ message+ "********" );
	
    }
    public static void severe(String message) {
	// TODO Auto-generated method stub
	logger.severe(message);
	System.out.println( "**********"+ message+ "********" );
	
    }
       public static Logger getLogger()
       {
           return logger;
           
       }
}
