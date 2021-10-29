/*******************************************
 * @Description : Apex class to get claims cases for the current
 * Account
 * 
 * ******************************************/
public with Sharing class SPoG_ClaimsHelper {
    
  /***********************************************************
   * @Description : Method to get return orders
   * **********************************************************/    
    public String getReturnOrders(Map<String,Object> mapInputRequest) {
        System.debug('================>>>'+mapInputRequest);
        String soldTo = (String) mapInputRequest.get('soldTo'); 
        SPoG_Utility objUtility = new SPoG_Utility(); 
        SPoG_InterfaceHelper objHelper = new SPoG_InterfaceHelper(); 
        ResponseClaimOrders objResponse = new ResponseClaimOrders(); 
        if(String.isNotBlank(soldTo)){
            String searchBy = (String) mapInputRequest.get('searchBy'); 
            String searchValue = (String) mapInputRequest.get('searchValue'); 
            soldTo = objUtility.addPrefix(soldTo, objUtility.TYPE_CUSTOMER_NUMBER); 
            Map<String,String> mapInputHeaders = new Map<String,String>(); 
            mapInputHeaders.put('IP_SOLDTO',soldTo);            //'0000008143'); 
            mapInputHeaders.put('IP_SALES_OFFICE','ALL'); 
            
            /*if(String.isBlank(searchBy)) {
                mapInputHeaders.put('IP_PO_NO','ALL'); 
                mapInputHeaders.put('IP_RETURN_DELIVERY_NO','ALL'); 
                mapInputHeaders.put('IP_RETURN_ORDER_NO','ALL'); 
            }
            else*/
            if (String.isNotBlank(searchBy) && 'Return Delivery Number'.equalsIgnoreCase(searchBy)) {
                searchValue = objUtility.addPrefix(searchValue, objUtility.TYPE_DELIVERY_NUMBER); 
                mapInputHeaders.put('IP_PO_NO','ALL'); 
                mapInputHeaders.put('IP_RETURN_DELIVERY_NO',searchValue); 
                mapInputHeaders.put('IP_RETURN_ORDER_NO','ALL'); 
            }
            /*else if (String.isNotBlank(searchBy) && 'Honeywell Return Order Number'.equalsIgnoreCase(searchBy)) {
                searchValue = objUtility.addPrefix(searchValue, objUtility.TYPE_SALES_ORDER);
                mapInputHeaders.put('IP_PO_NO','ALL'); 
                mapInputHeaders.put('IP_RETURN_DELIVERY_NO','ALL'); 
                mapInputHeaders.put('IP_RETURN_ORDER_NO',searchValue); 
            }
            else if (String.isNotBlank(searchBy) && 'Honeywell Purchase Order Number'.equalsIgnoreCase(searchBy)) {
                //searchValue = objUtility.addPrefix(searchValue, objUtility.TYPE_PO_NUMBER);
                mapInputHeaders.put('IP_PO_NO',searchValue); 
                mapInputHeaders.put('IP_RETURN_DELIVERY_NO','ALL'); 
                mapInputHeaders.put('IP_RETURN_ORDER_NO','ALL'); 
            }*/
            
            System.debug('----soldTo '+ soldTo);
            HttpResponse objHttpResponse = objHelper.getClaimsDetails(mapInputHeaders); 
            
            if(objHttpResponse.getStatusCode()==200){
                objResponse.isSuccess = true ; 
                System.debug('====objHttpResponse.getBody()'+objHttpResponse.getBody());
                String httpRespbody = objHttpResponse.getBody();
                SalesOrder resultOrders = (SalesOrder) JSON.deserialize(httpRespbody, SalesOrder.Class); 
                system.debug('resultOrders:::::::'+resultOrders);
                objResponse.lstResults = resultOrders.Claims.results; // Modified on 03/16/2020
            }
            
        }
        
        return JSON.serialize(objResponse) ; 
    }
    
    /***************************************************
     * @Description : 
     * 
     * ************************************************
    private with Sharing Class ResponseClaimCases {
        Boolean isSuccess = false ; 
        List<Case> lstCases = new List<Case>(); 
    }*/
    /******************************************************
     * 
     * ****************************************************/
    private with Sharing Class ResponseClaimOrders {
        Boolean isSuccess = false ; 
        List<Claims> lstResults = new List<Claims>(); 
    }
    
    /*******************************************************
     * @Description : Response for CLaims JSON parsing
     * *****************************************************/
    private with Sharing Class SalesOrder {
        ClaimsResult Claims = new ClaimsResult() ; // Modified on 03/16/2020
    }
    
    private with Sharing Class ClaimsResult {
        List<Claims> results = new List<Claims>(); 
    }
    
    private with Sharing Class Claims {
        String GenID; 
        String SALES_ORDER_NO ; 
        String RETURN_DELIVERY_NO ; 
        String SAP_DOC_CATEGORY ; 
        String DOC_CATEGORY_DESC;            
        String NOTIFICATION_NO;
        String RETURN_ORDER_NUMBER ;
         
        String FOLLOW_ON_DOCUMENTS ; 
    }
 
}