/*****************************************************
 * @Description : Apex Class to handle all Callout to External System for 
 * Customer Service Agent requirements.
 * ******************************************************/
public with Sharing class SPoG_InterfaceHelper {
    
    
    private static SPoG_General_Settings__mdt objGeneralSetting = new SPoG_General_Settings__mdt(); 
    
    public SPoG_InterfaceHelper(){
        SPoG_Utility objUtility = new SPoG_Utility(); 
        
        objGeneralSetting = objUtility.getSystemSetting() ; 
        
    }

    /*********************************************************************
     * @Description: 
     * added for Order Details
     * *******************************************************************/
    public String getAccessTokenForOrderDetails() {
        String accessToken ; 
        String clientId = objGeneralSetting.APIGEE_Client_ID__c ;
        String clientSecret = objGeneralSetting.APIGEE_Client_Secret__c ;
        String accessEndPath = objGeneralSetting.APIGEE_Access_Token_Path__c+'?grant_type=client_credentials';
        Map<String,String> mapHeaders = new Map<String,String>(); 
        String authToken = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(clientId+':'+clientSecret)) ; //for Base64 conversion
        mapHeaders.put('Authorization',authToken); 
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+accessEndPath,'GET',mapHeaders); 
        Map<String,Object> deconstructedResponse = (Map<String,Object>) JSON.deserializeUntyped(objResponse.getBody());
        if(deconstructedResponse.containsKey('access_token')) {
            accessToken = (String) deconstructedResponse.get('access_token'); 
        }
        System.debug('Received Access Token :::::'+accessToken); 
        return accessToken ; 
    }


    /*********************************************************************
     * @Description: 
     * 
     * *******************************************************************/
    public String getAccessToken(Boolean isAeroApiInstance) {
        String accessToken ; 
        String clientId = objGeneralSetting.APIGEE_Access_Token_Client_Id__c ;
        String clientSecret = objGeneralSetting.APIGEE_Access_Token_Client_Secret__c ;
        String accessEndPath = objGeneralSetting.APIGEE_Access_Token_Path__c+'?grant_type=client_credentials';
        Map<String,String> mapHeaders = new Map<String,String>(); 
        String authToken = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(clientId+':'+clientSecret)) ; //for Base64 conversion
        mapHeaders.put('Authorization',authToken); 
        HttpResponse objResponse = sendCallout(isAeroApiInstance?'Callout:AEROSFDCforSFDCtoSAP'+accessEndPath:'Callout:SPoG_APIGEE_Instance'+accessEndPath,'GET',mapHeaders); 
        Map<String,Object> deconstructedResponse = (Map<String,Object>) JSON.deserializeUntyped(objResponse.getBody());
        if(deconstructedResponse.containsKey('access_token')) {
            accessToken = (String) deconstructedResponse.get('access_token'); 
        }
        System.debug('Received Access Token :::::'+accessToken); 
        return accessToken ; 
    }
     /************************************************************
   * @Description : 
   * **********************************************************/    
    public HttpResponse getUserStatusDetails(String honid) {
        String access_token = getAccessToken(true);
        Map<String,String> inputHeaders = new Map<String,String>();
        inputHeaders.put('Authorization','Bearer '+access_token);
        String toolid = Label.SPoG_UserStatusAPIToolId;
        String urlpath = '/'+honid+'/tools/'+toolid;
        //https://aero.api-beta.honeywell.com/reg/v1/user-tools/H092144/tools/a0Gm0000002s8DsEAI
        HttpResponse response = sendCallout('Callout:AEROSFDCforSFDCtoSAP'+objGeneralSetting.APIGEE_UserStatus_Path__c+urlpath,'GET',inputHeaders);
        return response;
    }
    /************************************************************
   * @Description : 
   * **********************************************************/    
    public HttpResponse getOrderDetails(Map<String,Object> mapInputRequest) {
        String access_token = getAccessTokenForOrderDetails();
        Map<String,String> inputHeaders = new Map<String,String>(); 
        SPoG_Utility objUtility = new SPoG_Utility(); 
        String salesOrderNumber = (String) mapInputRequest.get('orderNumber') ; 
        String soldToNumber = (String) mapInputRequest.get('soldToNumber') ;
        String orderurl = '/portal/services';
        salesOrderNumber = objUtility.addPrefix(salesOrderNumber, objUtility.TYPE_SALES_ORDER);
        //Integer salesOrder = Integer.valueOf(mapInputRequest.get('soldToNumber')); 
        inputHeaders.put('orderNumber',salesOrderNumber);  // '0004287657'
        inputHeaders.put('soldToNumber',soldToNumber);
        inputHeaders.put('userType', 'C'); 
        inputHeaders.put('HON-ORG-Id','AERO'); 
        inputHeaders.put('Authorization','Bearer '+access_token);
        //add default header values
        //inputHeaders = addDefaultHeaders(inputHeaders); 
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+orderurl+objGeneralSetting.APIGEE_Order_Details_Path__c,'GET',inputHeaders); 
        
        return objResponse ; 
        
    }
     
    /****************************************************************
     * @Description : 
     * **************************************************************/
    public HttpResponse getDeliverySummary(Map<String,String> inputHeaders) { 
        //add default header values
        
       //inputHeaders = addDefaultHeaders(inputHeaders); 
        inputHeaders.put('client_id',objGeneralSetting.APIGEE_Client_ID__c);
        inputHeaders.put('client_secret',objGeneralSetting.APIGEE_Client_Secret__c);
        inputHeaders.put('HonOrg','Aero'); 
        //String access_token = getAccessTokenForOrderDetails();
        //inputHeaders.put('Authorization','Bearer '+access_token);
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Delivery_Path__c,'GET',inputHeaders); 
        
        return objResponse ;  
    }
    
    /**************************************************
     * @Description : method to get claims(return order) from SAP
     * ***********************************************/
    public HttpResponse getClaimsDetails(Map<String,String> inputHeaders) {
        //add default header values
        inputHeaders = addDefaultHeaders(inputHeaders); 
        
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Claims_Path__c,'GET',inputHeaders); 
        
        return objResponse ; 
    }
    
    /***********************************************
     * @Description : Method to get attachment
     * ******************************************* */
    public HttpResponse getAttachment(Map<String,Object> mapInputRequest) {
        Map<String,String> inputHeaders = new Map<String,String>();
        String documentId = (String) mapInputRequest.get('documentId') ;
        String componentId = (String) mapInputRequest.get('componentId') ;
        String access_token = getAccessTokenForOrderDetails();
        String Documenturlpath = '/portal/services';
        
        System.debug('documentId ---- '+ documentId);
        System.debug('componentId ---- '+ componentId);
        inputHeaders.put('Authorization','Bearer '+access_token); 
        inputHeaders.put('documentId',documentId);        
        inputHeaders.put('componentId',componentId); 
        inputHeaders.put('HON-ORG-Id','AERO');
        
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+Documenturlpath+objGeneralSetting.APIGEE_Attachment_Path__c,'GET',inputHeaders); 
        
        return objResponse;
        
    }
    
    /****************************************************************
     * @Description : 
     * **************************************************************/
    public HttpResponse getSearchResult(Map<String,String> inputHeaders) {
        inputHeaders = addDefaultHeaders(inputHeaders); //add default headers
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Customer_Search_Path__c,'GET',inputHeaders);
        System.debug('getSearchResult** -- '+ 'Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Customer_Search_Path__c);
        //String searchcustomer = '/spog/v1/searchcustomer';
        //HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+searchcustomer,'GET',inputHeaders);
        return objResponse;
    }
    
    /****************************************************************
     * @Description : 
     * **************************************************************/
    public HttpResponse getOrderSearchResult(Map<String,String> inputHeaders) {
        String access_token = getAccessToken(false);
        inputHeaders.put('Authorization','Bearer '+access_token);
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Search_Path__c,'POST',inputHeaders); 
        System.debug('Response***'+objResponse);
        return objResponse;
    }
    
    /****************************************************************
     * @Description : 
     * **************************************************************/
    public HttpResponse getSearchResultHANA(Map<String,String> inputHeaders) {
        
        inputHeaders.put('Content-Type','application/json');
        
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Search_Path__c,'GET',inputHeaders); 
        
        return objResponse;
        
    }
    
    /*******************************************************
     * @Description : 
     * *****************************************************/
    public HttpResponse getOrderSummary(Map<String,String> inputHeaders) {
         
        //add default header values
        inputHeaders = addDefaultHeaders(inputHeaders); 
        
        inputHeaders.put('Content-Type','application/json');
        //inputHeaders.put('HonOrg','SPS-IS'); //- added
        inputHeaders.remove('IP_SOLDTO');     //- removed
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Order_Summary_Path__c,'GET',inputHeaders); 
        
        return objResponse;
    }
    
    /******************************************************
     * @Description : 
     * ******************************************************/
    public HttpResponse getPricingInfo(String headerBody) {
        Integer length = headerBody.length();
        length = length/12;
        System.debug('$$$debug1='+headerBody.subString(0, length));
        System.debug('$$$debug1='+headerBody.subString(length, (length * 2)));
        System.debug('$$$debug1='+headerBody.subString((length * 2), (length*3)));
        System.debug('$$$debug1='+headerBody.subString((length * 3), (length*4)));
        System.debug('$$$debug1='+headerBody.subString((length * 4), (length*5)));
        System.debug('$$$debug1='+headerBody.subString((length * 5), (length*6)));
        System.debug('$$$debug1='+headerBody.subString((length * 6), (length*7)));
        System.debug('$$$debug1='+headerBody.subString((length * 7), (length*8)));
        System.debug('$$$debug1='+headerBody.subString((length * 8), (length*9)));
        System.debug('$$$debug1='+headerBody.subString((length * 9), (length*10)));
        System.debug('$$$debug1='+headerBody.subString((length * 10), (length*11)));
        System.debug('$$$debug1='+headerBody.subString((length * 11), (length*12)));
        String access_token = getAccessTokenForOrderDetails();
        Map<String,String> inputHeaders = new Map<String,String>(); 
        String Pricingurlpath = '/portal/services';
        //add default header values
       // inputHeaders = addDefaultHeaders(inputHeaders); 
        inputHeaders.put('HON-ORG-Id','AERO'); 
       // inputHeaders.put('X-Requested-With','X');
        system.debug('pricingheaderBody:::::'+headerBody);
        inputHeaders.put('Authorization','Bearer '+access_token);
        inputHeaders.put('headerBody',headerBody); 
        inputHeaders.put('Content-Type','application/json');
        system.debug('inputHeaders:::::'+inputHeaders);
         
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+Pricingurlpath+objGeneralSetting.APIGEE_Pricing_Path__c,'POST',inputHeaders); 
        
        return objResponse; 
    }
    
    /***************************************************
     * @Description : 
     * ************************************************
    public HttpResponse getStockResponse(Map<String,String> inputHeaders){
        
        //add default header values
        inputHeaders = addDefaultHeaders(inputHeaders); 
        inputHeaders.put('X-Requested-With','X');
        
        inputHeaders.put('Content-Type','application/json');
        
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Stocks_Path__c, 'GET', inputHeaders); 
        
        return objResponse; 
    }*/
    
    /***************************************************
     * @Description : Method to get the Stock Availability data.
     * *************************************************/
    public HttpResponse getGlobalStockResponse(Map<String,String> inputHeaders,String plant){
        //add default header values
        inputHeaders = addDefaultHeaders(inputHeaders); 
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Stocks_Overview_Path__c+'?Plant='+plant,'GET',inputHeaders); 
        return objResponse; 
    }

  /*************************************************************
   * @Description : Method to get the Order metrics for dashboard components
   * for open orders
   * ***********************************************************/    
    public HttpResponse getOrderMetrics(String custVal,String assignVal, String segVal,String regionVal,String typeVal ){
        Map<String,String> inputHeaders = new Map<String,String>(); 
        inputHeaders = addDefaultHeaders(inputHeaders);
        inputHeaders.put('IP_CUSTOMER_NAME',String.isNotEmpty(custVal)?custVal:'ALL');
        inputHeaders.put('IP_ASSIGNMENT',String.isNotEmpty(assignVal)?assignVal:'ALL');
        inputHeaders.put('IP_CUSTOMER_SEGMENT',String.isNotEmpty(segVal)?segVal:'ALL');
        inputHeaders.put('IP_REGION',String.isNotEmpty(regionVal)?regionVal:'ALL');
        inputHeaders.put('IP_TYPE',String.isNotEmpty(typeVal)?typeVal:'ALL');
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Order_Metric_Path__c,'GET',inputHeaders); 
        System.debug('::=objResponse =:: '+objResponse);
        return objResponse; 
    }
    
    /*************************************************************
    * @Description : Method to get the Shipments metrics for dashboard components
    * for open orders
    * ***********************************************************/
    public HttpResponse getShipmentMetrics(String custVal,String assignVal, String segVal,String regionVal,String typeVal ) {
        Map<String,String> inputHeaders = new Map<String,String>(); 
        inputHeaders = addDefaultHeaders(inputHeaders);
        inputHeaders.put('IP_CUSTOMER_NAME',String.isNotEmpty(custVal)?custVal:'ALL');
        inputHeaders.put('IP_ASSIGNMENT',String.isNotEmpty(assignVal)?assignVal:'ALL');
        inputHeaders.put('IP_CUSTOMER_SEGMENT',String.isNotEmpty(segVal)?segVal:'ALL');
        inputHeaders.put('IP_REGION',String.isNotEmpty(regionVal)?regionVal:'ALL');
        inputHeaders.put('IP_TYPE',String.isNotEmpty(typeVal)?typeVal:'ALL');
        HttpResponse objResponse = sendCallout('Callout:SPoG_APIGEE_Instance'+objGeneralSetting.APIGEE_Shipment_Metric_Path__c,'GET',inputHeaders); 
        System.debug('::=objResponse =:: '+objResponse);
        return objResponse; 
    }
    

    
    /*****************************************************
     * @Description : Method to add default headers
     * ***************************************************/
    private static Map<String,String> addDefaultHeaders(Map<String,String> mapInput) {
        if(objGeneralSetting != null) {
            mapInput.put('client_id',objGeneralSetting.APIGEE_Access_Token_Client_Id__c);
            mapInput.put('client_secret',objGeneralSetting.APIGEE_Access_Token_Client_Secret__c);
            mapInput.put('HonOrg','AERO'); 
        }
        system.debug('mapInputaddDefaultHeaders::::::'+mapInput);
        return mapInput ; 
    }
    
    /*****************************************************************************
     * @Description : Method to send callout information to external system
     * It returns to HttpResponse object received from the request. 
     * *****************************************************************************/
    private HttpResponse sendCallout(String endPoint , String methodType , Map<String,String> mapHeaders) {
        system.debug('endpoint>>>'+endPoint);
        HttpRequest objRequest = new HttpRequest(); 
        objRequest.setEndpoint(endpoint); 
        objRequest.setMethod(methodType); 
        if(mapHeaders.containsKey('headerBody')){
            objRequest.setBody(mapHeaders.get('headerBody')); 
        }
        System.debug(':::::::::::::::::: APIGEE CALLOUT START :::::::::::::::'); 
        for(String headerKey : mapHeaders.keySet()) {
            System.debug('Key :: '+headerKey+'  Value :: '+mapHeaders.get(headerKey));
            if(!headerKey.equalsIgnoreCase('headerBody')){
              objRequest.setHeader(headerKey, mapHeaders.get(headerKey));     
            }
        } 
        Http objHttp = new Http(); 
        objRequest.setTimeout(60000); 
        System.debug('---SendCallout '+objRequest);
        HttpResponse objResponse = objHttp.send(objRequest); 
        System.debug(':::: Response Received from APIGE :::'+objResponse.getBody()); 
         
        return objResponse ; 
   }
}