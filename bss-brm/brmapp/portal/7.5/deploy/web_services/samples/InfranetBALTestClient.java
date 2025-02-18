package com.portal.webservices;

import com.portal.webservices.generated.InfranetBALWebservices;
import com.portal.webservices.generated.InfranetBALWebservicesService;
import com.portal.webservices.generated.InfranetBALWebservicesServiceLocator;


public class InfranetBALTestClient {
    public static void main(String[] args) {
        try {

            String wsdlUrl = "http://localhost:8099/infranetwebsvc/services/BRMBalServices?wsdl"; 
            InfranetBALWebservicesService service = new InfranetBALWebservicesServiceLocator();
            InfranetBALWebservices port = service.getBRMBalServices();

            // convert flist to XML representation
            String XMLInput="<PCM_OP_BAL_GET_BALANCES_inputFlist xmlns=\"http://xmlns.oracle.com/BRM/schemas/BusinessOpcodes\"><POID>0.0.0.1 /account 1 0</POID></PCM_OP_BAL_GET_BALANCES_inputFlist>";
            System.out.println("Input: " + XMLInput);
            // invoke web service opcode method
            String result = port.pcmOpBalGetBalances(0, XMLInput);
    
            System.out.println("result: "+ result);

        } catch (Exception ex) {
            ex.printStackTrace();    
        }
    }

}
