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
public class BRMAdapterServletException extends Exception {
        BRMAdapterServletException() {
            super();
        }

        public BRMAdapterServletException(String str) {
            super();
            errMsg = str;
        }

        public String getMessage() {
            return errMsg;
        }
        private String errMsg = null;
    }
