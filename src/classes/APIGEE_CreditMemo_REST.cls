@RestResource(urlMapping='/creditmemo/*') 
global class APIGEE_CreditMemo_REST {
    @HttpGET
    global static void creditMemoGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String id = req.params.get('id');
        String name = req.params.get('name');
        
        
        APIGEE_Result result = new APIGEE_Result();
        
        if(String.isNotBlank(name) || String.isNotBlank(id)){
            String query = '';
            if(String.isNotBlank(id)){
                //query = 'Select Apttus_Billing__Description__c,Apttus_Billing__InvoiceID__r.APTS_PO_Date__c,CurrencyIsoCode,Apttus_Billing__CreditMemoDate__c,Apttus_Billing__InvoiceID__r.APTS_SAP_Invoice_Number__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__PONumber__c,Name,Id,Apttus_Billing__InvoiceID__r.Apttus_Billing__SoldToAccountId__r.APTS_Fuel_Efficiency_Sales_Org__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__SoldToAccountId__r.SAP_Sold_To__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__SoldToAccountId__r.name,Apttus_Billing__InvoiceID__r.Name,Apttus_Billing__InvoiceID__r.Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__BillToAccountId__r.name,Apttus_Billing__InvoiceID__r.APTS_Billing_Document_Number__c,APTS_ACAT_Number__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__ShipToAccountId__r.name,Apttus_Billing__CreditAmount__c, (Select Name,Integration_Sequence_Line_Number__c,Apttus_Billing__Description__c,Apttus_Billing__AssetLineItemId__r.APTS_Customer_Description__c, Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__r.ProductCode ,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__BillingRule__c ,Apttus_Billing__StartDate__c,Apttus_Billing__EndDate__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.ProductCode,Apttus_Billing__InvoiceLineItemId__r.Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__InvoiceLineItemId__r.Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c,Apttus_Billing__Amount__c,CurrencyIsoCode from Apttus_Billing__CreditMemoLineItems__r) From Apttus_Billing__CreditMemo__c where  id=:id';
                query = 'Select Apttus_Billing__Description__c,Apttus_Billing__InvoiceID__r.APTS_PO_Date__c,CurrencyIsoCode,Apttus_Billing__CreditMemoDate__c,Apttus_Billing__InvoiceID__r.APTS_SAP_Invoice_Number__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__PONumber__c,Name,Id, APTS_Sales_Org__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__SoldToAccountId__r.SAP_Sold_To__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__SoldToAccountId__r.name,Apttus_Billing__InvoiceID__r.Name,Apttus_Billing__InvoiceID__r.Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__BillToAccountId__r.name,Apttus_Billing__InvoiceID__r.APTS_Billing_Document_Number__c,APTS_ACAT_Number__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c,Apttus_Billing__InvoiceID__r.Apttus_Billing__ShipToAccountId__r.name,Apttus_Billing__CreditAmount__c, (Select Name,Integration_Sequence_Line_Number__c,Apttus_Billing__Description__c,Apttus_Billing__AssetLineItemId__r.APTS_Customer_Description__c, Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__r.ProductCode ,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__BillingRule__c ,Apttus_Billing__StartDate__c,Apttus_Billing__EndDate__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.ProductCode,Apttus_Billing__InvoiceLineItemId__r.Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__InvoiceLineItemId__r.Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c,Apttus_Billing__Amount__c,CurrencyIsoCode from Apttus_Billing__CreditMemoLineItems__r) From Apttus_Billing__CreditMemo__c where  id=:id';
            }else if(String.isNotBlank(name)){
                query = 'select Id from Apttus_Billing__CreditMemo__c where Name =:name';
            }
            
            result.data = Database.query(query);
            
        }else{
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Credit Memo Name Or Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPUT
    global static void creditMemoUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        try{
            String requestBody = req.requestBody.toString();
            Apttus_Billing__CreditMemo__c creditMemo = (Apttus_Billing__CreditMemo__c)JSON.deserialize(requestBody, Apttus_Billing__CreditMemo__c.class);
            update creditMemo;
            result.data = creditMemo;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
   }