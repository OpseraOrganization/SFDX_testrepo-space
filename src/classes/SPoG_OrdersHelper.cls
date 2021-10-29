/***********************************************
* @Description : Apex Helper class to used to send inputs 
to SAP HANA interface via APIGEE to receive Order Summary data
* 
* ************************************************/
public with Sharing class SPoG_OrdersHelper {
    
    //private static final String SEARCH_BY_PO = 'Purchase Order';
    //private static final String SEARCH_BY_SO = 'Honeywell Sales Order';
    //private static final String SEARCH_BY_PN = 'Honeywell Part Number';
    
    /****************************************************************
* @Decription : Method to get order summary , when user search from the
* order component
* 
* **************************************************************/
   /* public String getOrderSummary(Map<String,Object> mapInputRequest) {
        
        SPoG_InterfaceHelper objHandler = new SPoG_InterfaceHelper(); 
        SummaryResponse objResult = new SummaryResponse(); 
        SPoG_Utility objUtility = new SPoG_Utility(); 
        //add search value headers
        Map<String,String> inputHeaders = mapInputHeaders(mapInputRequest); 
        
        HttpResponse objResponse = objHandler.getOrderSummary(inputHeaders); 
        
        System.debug('Response Received ::: '+objResponse.getBody()); 
        if(objResponse.getStatusCode() == 200) {
            objResult.isSuccess = true ; 
            SummaryResponse objInfo = new SummaryResponse(); 
            System.debug('objResponse.getBody()'+objResponse.getBody());
            objInfo =   (SummaryResponse) JSON.deserialize(objResponse.getBody(), SummaryResponse.Class); 
            
            for(OrderSummary obj : objInfo.OPEN_ORDERS.results) {
                
                if(String.isNotBlank(obj.ESTIMATED_DELIVERY_DATE)){
                    obj.ESTIMATED_DELIVERY_DATE = objUtility.parseDateForOutput(obj.ESTIMATED_DELIVERY_DATE); 
                }
                if(String.isNotBlank(obj.ESTIMATED_SHIPPING_DATE)){
                    obj.ESTIMATED_SHIPPING_DATE = objUtility.parseDateForOutput(obj.ESTIMATED_SHIPPING_DATE); 
                }
            }
            
            objResult.OPEN_ORDERS = objInfo.OPEN_ORDERS ; 
        }
        
        return JSON.serialize(objResult) ; 
    } */
    
    /***********************************************************
* @Description : method to map input values to headers to be 
* used for Interface callout. 
* *********************************************************/
    /* private Map<String,String> mapInputHeaders(Map<String,Object> mapInputValues) {
        Map<String , String> mapResult = new Map<String,String>();
        SPoG_Utility objUtility = new SPoG_Utility(); 
        
        mapResult.put('IP_SOLDTO','ALL');
        mapResult.put('IP_SALES_OFFICE','ALL'); 
        mapResult.put('IP_PART_NO','ALL'); 
        String searchBy = (String) mapInputValues.get('searchBy'); 
        String searchValue = (String) mapInputValues.get('searchKey'); 
        mapResult.put('IP_CUSTOMER_NO','ALL');//change this to current customer.
        if('Honeywell Purchase Order'.equalsIgnoreCase(searchBy)) {
            
            mapResult.put('IP_PO_NO',searchValue);
            mapResult.put('IP_SALES_ORDER','ALL'); 
            mapResult.put('IP_MATERIAL_NO','ALL'); 
        }
        else if('Honeywell Sales Order'.equalsIgnoreCase(searchBy)) {
            searchValue = objUtility.addPrefix(searchValue, objUtility.TYPE_SALES_ORDER);
            mapResult.put('IP_PO_NO','ALL');
            mapResult.put('IP_SALES_ORDER',searchValue); 
            mapResult.put('IP_MATERIAL_NO','ALL'); 
        }
        String materialNumber = (String) mapInputValues.get('materialNumber');
        if(String.isNotBlank(materialNumber)) {
            materialNumber = objUtility.addPrefix(materialNumber, objUtility.TYPE_MAT_NUMBER);
            mapResult.put('IP_MATERIAL_NO',materialNumber); 
        }
        String partNumber = (String) mapInputValues.get('partNumber'); 
        if(String.isNotBlank(partNumber)) {
            mapResult.put('IP_PART_NO',partNumber); 
        }
        
        return mapResult ; 
    }
    
    private with Sharing Class SummaryResponse {
        Boolean isSuccess = false ; 
        SummaryResults OPEN_ORDERS = new SummaryResults(); 
    }
    
    private with Sharing Class SummaryResults {
        List<OrderSummary> results = new List<OrderSummary>(); 
    }
    
    private with Sharing Class OrderSummary {
        String LINE_ITEM_NUMBER ; 
        String MATERIAL_NUMBER ; 
        String MATERIAL_DESCRIPTION ; 
        String CUSTOMER_PART_NO ; 
        String ORDER_QTY ; 
        String SHIPPED_QTY; 
        String REMAINING_QTY ; 
        String DELIVERY_NO;
        String ESTIMATED_SHIPPING_DATE;
        String ACTUAL_SHIPPING_DATE;
        String ESTIMATED_DELIVERY_DATE ; 
        String TRACKING_NO ; 
        String CARRIER_NAME; 
        String ORDER_NO ; 
        String SHIPPING_CH; 
    }*/
    /**************************************************************
* @Description : Method to get order details
* ************************************************************/
    public String getOrderDetails(Map<String,Object> mapInputRequest) {
        SPoG_InterfaceHelper objInterfaceHelper = new SPoG_InterfaceHelper(); 
        //OrderDetailsWrapper objResponse = new OrderDetailsWrapper(); 
        Object response;
        HttpResponse objHttpResponse = objInterfaceHelper.getOrderDetails(mapInputRequest); 
        
        if(objHttpResponse.getStatusCode() == 200) {
            System.debug('sucessfully fetched order details' +  objHttpResponse.getBody());
            response = JSON.deserializeUntyped(objHttpResponse.getBody());
        }
        
        return JSON.serialize(response) ; 
    }
    
    
    public String getDeliverySummary(Map<String,Object> mapInputRequest) {
        SPoG_InterfaceHelper objInterfaceHelper = new SPoG_InterfaceHelper(); 
        Map<String,String> inputHeaders = new Map<String,String>(); 
        SPoG_Utility objUtility = new SPoG_Utility(); 
        String salesOrderNumber = (String) mapInputRequest.get('orderNumber') ; 
        String soldToNumber = (String) mapInputRequest.get('soldToNumber') ;
        salesOrderNumber = objUtility.addPrefix(salesOrderNumber, objUtility.TYPE_SALES_ORDER);
        
        if(soldToNumber!=''){inputHeaders.put('IP_CUSTOMER_NUM',soldToNumber);
                                }else{inputHeaders.put('IP_CUSTOMER_NUM','ALL');}
        inputHeaders.put('IP_ORDER_NUMBER',salesOrderNumber);
        //inputHeaders.put('userType', 'C'); 
        deliverySummary objInfo = new deliverySummary(); 
        HttpResponse objHttpResponse = objInterfaceHelper.getDeliverySummary(inputHeaders); 
        system.debug('****************objHttpResponse'+objHttpResponse);
        if(objHttpResponse.getStatusCode() == 200) {
            objInfo =   (deliverySummary) JSON.deserialize(objHttpResponse.getBody(), deliverySummary.Class); 
        } 
       for(integer i=0 ; i<objInfo.TRACKING_SEARCH.results.size();i++ ){
            if((objInfo.TRACKING_SEARCH.results[i].TRACKING_URL) ==null){objInfo.TRACKING_SEARCH.results[i].TRACKING_URL='';}
        }
        system.debug('*******Response ***'+ objInfo.TRACKING_SEARCH.results);
        return JSON.serialize(objInfo) ;  
     }
    private with Sharing Class deliverySummary {
        deliverySummaryResults TRACKING_SEARCH = new deliverySummaryResults(); 
    }
    private with Sharing Class deliverySummaryResults {
        List<deliverySummaryDetails> results = new List<deliverySummaryDetails>(); 
    }
    private with Sharing Class deliverySummaryDetails {
        String CLIENT ; 
        String DELIVERY_NUMBER ; 
        String DELIVERY_ITEM_NUMBER ; 
        String MATERIAL_PRODUCT ; 
        String SALES_ORDER ; 
        String SALES_ORDER_ITEM_NUMBER; 
        String ACTUAL_GI_DATE ; 
        String TRACKING_NUMBER;
        String CARRIER;
        String TRACKING_URL;
        Decimal DELIVERY_QTY;
        String REQUEST_DELIVERY_DATE ; 
        Decimal ORDER_QTY ; 
        String CUSTOMER_NUMBER; 
        String CLIN ; 
        Decimal REMAINING_QTY;
    }
    /***************************************************************************
* @Description : Utility method to assign all line item response
* 
* ************************************************************************/
   /* private LineItems assignLineItemValue(OrderDetailsResponse objInput) {
        LineItems objLineItem = new LineItems(); 
        
        if(objInput != null) {
            
            objLineItem.SHIP_TO_NAME  = objInput.SHIP_TO_NAME != null ?  objInput.SHIP_TO_NAME : '' + objInput.SHIP_TO_NAME2 !=null ? objInput.SHIP_TO_NAME2 : ''; 
            objLineItem.SHIP_TO_CITY = objInput.SHIP_TO_CITY1 !=null ? objInput.SHIP_TO_CITY1 : '' + objInput.SHIPT_TO_CITY2 != null ?  objInput.SHIPT_TO_CITY2 : ''; 
            objLineItem.BILL_TO_NAME  = objInput.BILL_TO_NAME1 !=null ?  objInput.BILL_TO_NAME1 : ''+ objInput.BILL_TO_NAME2 !=null ? objInput.BILL_TO_NAME2 : ''; 
            objLineItem.BILL_TO_CITY = objInput.BILL_TO_CITY1 !=null ? objInput.BILL_TO_CITY1 : ''+ objInput.BILL_TO_CITY2 !=null ? objInput.BILL_TO_CITY2 : '';  
            objLineItem.SHIP_TO_POST_CODE1 = objInput.SHIP_TO_POST_CODE1 != null ? objInput.SHIP_TO_POST_CODE1 : ''; 
            objLineItem.SHIP_TO_STREET = objInput.SHIP_TO_STREET !=null ?  objInput.SHIP_TO_STREET : ''; 
            objLineItem.SHIP_TO_COUNTRY = objInput.SHIP_TO_COUNTRY !=null ? objInput.SHIP_TO_COUNTRY : ''; 
            objLineItem.SHIP_TO_REGION = objInput.SHIP_TO_REGION != null ? objInput.SHIP_TO_REGION : ''; 
            objLineItem.BILL_POST_CODE1 = objInput.BILL_POST_CODE1 != null ? objInput.BILL_POST_CODE1 : ''; 
            objLineItem.BILL_TO_STREET = objInput.BILL_TO_STREET != null ? objInput.BILL_TO_STREET : ''; 
            objLineItem.BILL_TO_COUNTRY = objInput.BILL_TO_COUNTRY !=null ? objInput.BILL_TO_COUNTRY : ''; 
            objLineItem.BILL_TO_REGION = objInput.BILL_TO_REGION != null ?  objInput.BILL_TO_REGION : ''; 
            
        }
        
        return objLineItem ; 
    } */
    
   /* *******************************************************
    ***************************************************** */
    
    public String getAttachment(Map<String , Object> mapInputRequest) {
        
        SPoG_InterfaceHelper objHandler = new SPoG_InterfaceHelper(); 
        AttachmentInfo objResult = new AttachmentInfo(); 
        HttpResponse objResponse = objHandler.getAttachment(mapInputRequest) ; 
        
        if(objResponse.getStatusCode() == 200 ) {
            System.debug('obj response'+objResponse.getBody()); 
            objResult.isSuccess = true ; 
            Document objDocument = new Document(); 
            objDocument.Name = 'New Doc.pdf'; 
            LIst<Folder> lstSAPTempFolder = [SELECT id FROM Folder WHERE DeveloperName = 'Customer_Service_SAP_Files' LIMIT 1];
            if(lstSAPTempFolder.size() > 0 ) {
                objDocument.FolderId = lstSAPTempFolder[0].Id; 
                objDocument.Body = objResponse.getBodyAsBlob() ; 
                Database.insert(objDocument); 
                objResult.attachmentId = objDocument.Id; 
                
            }
            
        }
        else {
            Error objError = new Error();
            objError = (Error) JSOn.deserialize(objResponse.getBody(), Error.Class); 
            objResult.isSuccess = false ; 
            //objResult.message = objError.error.message.value ;  errorMessage
            objResult.message = objError.error.errorDescription ; 
        }
        
        return JSON.serialize(objResult) ; 
    }
    
    /*****************************************************************
* @Description : Method to delete the attachmed retrieved from 
* SAP. This is ensure residue files do not add up to storage. 
* 
* ************************************************************ */
    public String deleteAttachment(Map<String,Object> mapInputRequest) {
        Id inputId = (Id) mapInputRequest.get('attachmentId'); 
        if(inputId != null) {
            database.delete(inputId); 
        }
        return null ; 
    }
    
    private with Sharing Class AttachmentInfo {
        Boolean isSuccess = false ; 
        String message ; 
        String attachmentId ; 
    }
    /**************************************************
* @Description : Wrapper Classes for de-serializing error message
* 
* *****************************************************/
    private with Sharing Class Error {
        ErrorHandler error = new ErrorHandler(); 
    }
    
    private with Sharing Class ErrorHandler {
        String code ; 
        MessageInfo message = new MessageInfo(); 
        String errorDescription;
    }
    
    private with Sharing Class MessageInfo {
        String lang ; 
        String value ; 
    }
    
    /********************************************************
* 
* *****************************************************/
     private with Sharing Class OrderData {
        OrderResults ORDER_DETAILS = new OrderResults(); 
    }
    private with Sharing Class OrderResults {
        List<OrderDetailsResponse> results = new List<OrderDetailsResponse>(); 
    }
    
    private with Sharing Class OrderDetailsResponse {
        String ACCOUNT_NAME ; 
        String ORDER_TYPE ; 
        String SOLD_TO_NUMBER ; 
        String SHIP_TO_NAME ; 
        String SHIP_TO_NAME2 ; 
        String SHIP_TO_CITY1 ; 
        String SHIPT_TO_CITY2 ; 
        String SHIP_TO_POST_CODE1 ; 
        String SHIP_TO_STREET ; 
        String SHIP_TO_COUNTRY ; 
        String SHIP_TO_REGION ; 
        String BILL_TO_NAME1 ; 
        String BILL_TO_NAME2 ; 
        String BILL_TO_CITY1 ; 
        String BILL_TO_CITY2 ; 
        String BILL_POST_CODE1 ; 
        String BILL_TO_STREET; 
        String BILL_TO_COUNTRY ; 
        String BILL_TO_REGION ; 
        String BACK_ORDERED_VALUE ; 
        String HONEYWELL_CONTACT_EMAIL ; 
        String HONEYWELL_CONTACT_NAME ; 
        String HONEYWELL_CONTACT_PHONE ; 
        String ORDER_GROSS_TOTAL ; 
    }
    
   /* private with Sharing Class LineItems {
        
        String SHIP_TO_NAME ; 
        
        String SHIP_TO_CITY ; 
        
        String SHIP_TO_POST_CODE1 ; 
        String SHIP_TO_STREET ; 
        String SHIP_TO_COUNTRY ; 
        String SHIP_TO_REGION ; 
        
        //Bill to address
        String BILL_TO_NAME ; 
        
        String BILL_TO_CITY ; 
        
        String BILL_POST_CODE1 ; 
        String BILL_TO_STREET; 
        String BILL_TO_COUNTRY ; 
        String BILL_TO_REGION ; 
        
        
    } */
    /************************************************************
* 
* *********************************************************/
  /*  private with Sharing Class OrderDetailsWrapper {
        Boolean isSuccess = false ; 
        String message ; 
        
        String ACCOUNT_NAME ; 
        String ORDER_TYPE ;  
        String SOLD_TO_NUMBER ; 
        
        String ORDER_GROSS_TOTAL ;
        String BACK_ORDERED_VALUE ; 
        
        List<LineItems> lstLineItems = new List<LineItems>(); 
        
    } */
    
    /***********************************************************
* @Description: Method to do an Order Search
* ********************************************************/
    public String searchOrders(Map<String,Object> mapInputRequests) {
        SPoG_InterfaceHelper objUtility = new SPoG_InterfaceHelper(); 
        String searchBy = (String) mapInputRequests.get('searchBy'); 
        String searchValue = (String) mapInputRequests.get('searchKey'); 
        String custNO = (String) mapInputRequests.get('custNO');
        //Boolean isFromCasePage = mapInputRequests.containsKey('isFromCasePage')?(Boolean)mapInputRequests.get('isFromCasePage'):false;
        Map<String,String> mapInputs = new Map<String,String>(); 
        mapInputs.put('userTYPE','C'); 
        //mapInputs.put('statusHDR','CLOSED');
        /*if(isFromCasePage){
            Map<String,Object> custinfo = (Map<String,Object>)mapInputRequests.get('customerInfo');
            custNO = (String)custinfo.get('custNO');
            //mapInputs.put('custPO',(String)custinfo.get('custPO'));
            //mapInputs.put('orderNO',(String)custinfo.get('orderNO'));
            //mapInputs.put('caseNumber',(String)custinfo.get('caseNumber'));
        }*/
        mapInputs.put('custNO',custNO);  
        mapInputs.put(searchBy,searchValue);
        String jsonBody = JSON.serialize(mapInputs);
        HttpResponse objResponse = objUtility.getOrderSearchResult(new Map<String,String>{'headerBody'=>jsonBody}); 
        OrderSearchResult response;
        if(objResponse.getStatusCode() == 200 && objResponse.getStatus() == 'OK'){
            Map<String ,Object> mapData = (Map<String,Object>) JSON.deserializeUntyped(objResponse.getBody());
            if(mapData.containsKey('d')) {
                Map<String,Object> mapResults = (Map<String,Object>) mapData.get('d');
                if(mapResults != null && mapResults.containsKey('results')) {
                        response = new OrderSearchResult(true,'Success',mapResults.get('results'));
                }
            }
        }else{
            response = new OrderSearchResult(false,String.isNotEmpty(custNO)?Label.SPoG_Error_Message:Label.SPoG_ServiceErrorMessage,null);
        }
        return JSON.serialize(response) ; 
    }
    public class OrderSearchResult{
        public Boolean isSuccess;
        public String message;
        public Object results;
        public OrderSearchResult(Boolean isSuccess,String message,Object results){
            this.isSuccess = isSuccess;
            this.message = message;
            this.results = results;
        }
    }
}