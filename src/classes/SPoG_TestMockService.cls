/****************************************************
* @Description: Mock Callout services to test Http Callouts in SPoG. 
* ****************************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_TestMockService implements HttpCalloutMock {
    /****************************************************************
    * @description: Callout Mock Service for SPoG Test Classes. 
    * Method identifies each type of request using unique REST Endpoints, 
    * which is sent by respective class to get the mock response body. 
    * ************************************************************/
    public HttpResponse respond(HttpRequest objRequest) {
        HttpResponse objResponse = new HttpResponse(); 
        String testEndPoint = (String) objRequest.getEndpoint(); // get the end point 
        objResponse.setStatusCode(200); 
        objResponse.setStatus('OK');
        if(testEndPoint.endsWithIgnoreCase('client_credentials')) {//Access token response
            objResponse.setBody('{"access_token":"test"}');
        }
        if(testEndPoint.endsWithIgnoreCase('order-search')) {//Order Search response
            objResponse.setBody('{"d":{"results":[{"custNO":"test"}]}}');
        }
        /*if(testEndPoint.endsWithIgnoreCase('user-tools')) {//User Status response
            objResponse.setBody('[{"access":{"lastLoginDate":"2020-06-08T09:12:21.000Z","status":"Approved","grantedDate":"2020-06-08T06:20:58.000Z","requestedDate":"2020-06-08T06:20:53.000Z"}}]');
        }
        if(testEndPoint.endsWithIgnoreCase('user-tools')) {//User Status response
            objResponse.setStatusCode(400);
            objResponse.setBody('[{"access":{"lastLoginDate":"2020-06-08T09:12:21.000Z","status":"Approved","grantedDate":"2020-06-08T06:20:58.000Z","requestedDate":"2020-06-08T06:20:53.000Z"}}]');
        }*/
        if(testEndPoint.endsWithIgnoreCase('openorders')) {//open orders dashboard metric response
            objResponse.setBody(
                JSON.serialize(new DashboardMock()) 
            );
            
        }
        else if(testEndPoint.endsWithIgnoreCase('shipment-details')){
            objResponse.setBody(
                JSON.serialize(new ShipmentMetric()) 
            );
        }
        else if(testEndPoint.endsWithIgnoreCase('Plant=test')) {
            //plant stock
            objResponse.setBody('{"d":{"results":[{"PlantOutNav":{"results":[]},"MaterialOutNav":{"results":[]},"CagecodeOutNav":{"results":[]},"ManfCageCodeOutNav":{"results":[]},"StockOutNav":{"results":[]}}]}}');
             objResponse.setStatusCode(200); 

        }
        else if(testEndPoint.endsWithIgnoreCase('Plant=test')) {
            //global stock
            objResponse.setBody('{"d":{"results":[{"PlantOutNav":{"results":[]},"MaterialOutNav":{"results":[]},"CagecodeOutNav":{"results":[]},"ManfCageCodeOutNav":{"results":[]},"StockOutNav":{"results":[]}}]}}');
            //objResponse.setStatusCode(400); 

        }
        else if(testEndPoint.endsWithIgnoreCase('price-details')){
            //pricing response
            objResponse.setBody(
                JSON.serialize(new OP_Response())
            );
            objResponse.setStatusCode(201); 
        }
        else if(testEndPoint.endsWithIgnoreCase('order-delivery')) {
            objResponse.setBody(
                JSON.serialize(new SummaryResponse())
            );
        }
        else if(testEndPoint.endsWithIgnoreCase('orderdetails')) {
            objResponse.setBody(
                JSON.serialize(new OrderData())
            );
                      //  objResponse.setStatusCode(200); 

        }
        else if(testEndPoint.endsWithIgnoreCase('order-details')) {
            objResponse.setBody(
                JSON.serialize(new OrderData())
            );
                      //  objResponse.setStatusCode(200); 

        }
        else if(testEndPoint.endsWithIgnoreCase('attachment')) {
            objResponse.setBody(
                'TestData'
            );
                        objResponse.setStatusCode(200); 

        }
        else if(testEndPoint.endsWithIgnoreCase('documents')) {
            objResponse.setBody(
                'TestData'
            );
                        objResponse.setStatusCode(200); 

        }
        else if(testEndPoint.endsWithIgnoreCase('claims')) {
            
            objResponse.setBody(
                JSON.serialize(new SalesOrder())
            );
        }
        
        return objResponse ; 
    }
    
    /*************************************************************
* DO NOT MODIFY BELOW MOCK RESPONSE CLASSES
* **********************************************************/
public with Sharing Class DashboardMock {
        DashboardOpenOrder OPEN_ORDERS = new DashboardOpenOrder(); 
    }
    public with Sharing Class DashboardOpenOrder {
        List<DashboardMockResult> results = new List<DashboardMockResult>{ new DashboardMockResult()}; 
    }
    
    public with Sharing Class DashboardMockResult  {
        public String GenID;
        public String SOLD_TO_NUMBER;
        public String ACCOUNT_NAME = 'Test Account';
        public String HW_ORDER_NUMBER = '8390022';
        public String PO_NUMBER;
        public String ITEM_NUMBER;
        public String MATERIAL;
        public String CRM_CASE;
        public String SERIAL_NUMBER;
        public String EDD_DATE;
        public String BLOCK_TYPE = 'SBU';
        public String SCHEDULE_LINE;
        public String SCHEDULE_LINE_BLOCK = 'Z8 - cust req';
        public String DELIVERY_HEADER_BLOCK;
    }
    
    /*************************************************
* @Description : De-serialize class for JSON response.
* Do Not modify variable names
* *************************************************/
    private with Sharing Class ShipmentMetric {
        ShipmentMetricResult SHIPMENTS = new ShipmentMetricResult(); 
    }
    /*************************************************
* @Description : De-serialize class for JSON response.
* Do Not modify variable names
* *************************************************/
    private with Sharing Class ShipmentMetricResult {
        List<ShipmentMetricInfo> results = new List<ShipmentMetricInfo>{ new ShipmentMetricInfo()}; 
    }
    /*************************************************
* @Description : De-serialize class for JSON response.
* Do Not modify variable names
* *************************************************/
    private with Sharing Class ShipmentMetricInfo {
        public String GenID;
        public String SOLD_TO_NAME = 'Test Account';
        public String SALES_ORDER_NUMBER = '8368393';
        public String PURCHASE_ORDER_NUMBER;
        public String SERIAL_NUMBER;
        public String CLIN;
        public String PLANT;
        public String MATERIAL;
        public String AWB;
        public String ACTUAL_GI_DATE;
        public String DELIVERY_NUMBER;
        public String DELIVERY_DATE;
        public String DELIVERY_CATEGORY = 'PAST 24 HR DELIVERY';
    }
    
    
    private with Sharing Class ResponseWrapper {
        ResultWrapper d = new ResultWrapper(); 
    }
    
    private with Sharing Class ResultWrapper {
        List<StockResult> results = new List<StockResult>{new StockResult()}; 
    }
    private with Sharing Class StockResult {
        String Matnr = 'test'; 
        String Maktx = 'test' ; 
        String Mtart = 'test' ; 
        String Meins = 'test' ; 
        String Meinh = 'test' ; 
        String Werks = 'test' ; 
        String Name1 = 'test' ; 
        String Lgort = 'test' ; 
        String Charg = 'test' ; 
        String Vfdat = '20200224' ; 
        String AvailDate = '20200224' ; 
        Integer TotCount= 10 ; 
    }
    
    private with Sharing Class OP_Response {
        OP_Builder d = new OP_Builder(); 
    }
    private with Sharing Class OP_Builder {
        String SoldTo ; 
        String SalesOrg ; 
        String DistChnl ; 
        String Division ; 
        String SalesDocTyp ; 
        String PricingDate ; 
        String PricingPartner ; 
        String ShipTo ; 
        OP_Info PricingToItmOut = new OP_Info(); 
        OP_Info PricingToItmIn = new OP_Info(); 
    }
    
    private with Sharing Class OP_Info {
        List<OP_Pricing> results = new List<OP_Pricing>{ new OP_Pricing()}; 
            }
    
    private with Sharing Class OP_Pricing {
        String PriceType ='' ; 
        String Item =''; 
        String Material = '' ; 
        String Amount = '0'; 
        
        String Unit = '0'; 
        String Uom = ''; 
        String BaseValue = '0' ; 
        String TotValue = '0'; 
        String TotPriceCurr = ''; 
        String TotPriceUom = ''; 
        String CurrencyCode = '';
        
        String Angdt = '20200224'; 
        String Bnddt = '20200224'; 
    }
    
    private with Sharing Class SummaryResponse {
        Boolean isSuccess = false ; 
        SummaryResults OPEN_ORDERS = new SummaryResults(); 
    }
    
    private with Sharing Class SummaryResults {
        List<OrderSummary> results = new List<OrderSummary>{new OrderSummary()}; 
            }
    
    private with Sharing Class OrderSummary {
        String LINE_ITEM_NUMBER = 'test'; 
        String MATERIAL_NUMBER  = 'test'; 
        String MATERIAL_DESCRIPTION = 'test'; 
        String CUSTOMER_PART_NO = 'test'; 
        String ORDER_QTY = 'test'; 
        String SHIPPED_QTY = 'test'; 
        String REMAINING_QTY = 'test' ; 
        String DELIVERY_NO = 'test';
        String ESTIMATED_SHIPPING_DATE = '20200224';
        String ACTUAL_SHIPPING_DATE  = '20200224';
        String ESTIMATED_DELIVERY_DATE = '20200224' ; 
        String TRACKING_NO = 'test' ; 
        String CARRIER_NAME = 'test'; 
        String ORDER_NO = 'test'; 
        String SHIPPING_CH = 'test'; 
    }
    
    /********************************************************
* 
* *****************************************************/
    private with Sharing Class OrderData {
        OrderResults OPEN_ORDERS = new OrderResults(); 
    }
    private with Sharing Class OrderResults {
        List<OrderDetailsResponse> results = new List<OrderDetailsResponse>{ new OrderDetailsResponse() }; 
            }
    
    private with Sharing Class OrderDetailsResponse {
        String ACCOUNT_NAME = 'test' ; 
        String ORDER_TYPE = 'test' ; 
        String SOLD_TO_NUMBER = 'test'  ; 
        String SHIP_TO_NAME = 'test' ; 
        String SHIP_TO_NAME2 = 'test' ; 
        String SHIP_TO_CITY1= 'test' ; 
        String SHIPT_TO_CITY2 = 'test'; 
        String SHIP_TO_POST_CODE1 = 'test'; 
        String SHIP_TO_STREET = 'test'; 
        String SHIP_TO_COUNTRY = 'test'; 
        String SHIP_TO_REGION = 'test'; 
        String BILL_TO_NAME1 = 'test'; 
        String BILL_TO_NAME2 = 'test'; 
        String BILL_TO_CITY1 = 'test'; 
        String BILL_TO_CITY2 = 'test'; 
        String BILL_POST_CODE1 = 'test'; 
        String BILL_TO_STREET= 'test'; 
        String BILL_TO_COUNTRY = 'test'; 
        String BILL_TO_REGION = 'test'; 
        String BACK_ORDERED_VALUE = 'test'; 
        String HONEYWELL_CONTACT_EMAIL = 'test'; 
        String HONEYWELL_CONTACT_NAME = 'test'; 
        String HONEYWELL_CONTACT_PHONE = 'test'; 
        String ORDER_GROSS_TOTAL = 'test'; 
    }
    
    private with Sharing Class SalesOrder {
        ClaimsResult OPEN_ORDERS = new ClaimsResult() ; 
    }
    
    private with Sharing Class ClaimsResult {
        List<Claims> results = new List<Claims>{ new Claims() }; 
    }
    
    private with Sharing Class Claims {
        String GenID = 'test'; 
        String SALES_ORDER_NO = 'test' ; 
        String RETURN_DELIVERY_NO = 'test' ; 
        String SAP_DOC_CATEGORY = 'test' ; 
        String DOC_CATEGORY_DESC = 'test';            
        String NOTIFICATION_NO = 'test';
        String RETURN_ORDER_NUMBER  = 'test';
         
        String FOLLOW_ON_DOCUMENTS  = 'test' ;
    }
}