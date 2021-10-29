@RestResource(urlMapping='/invoice/*') 
global class APIGEE_Invoice_REST {
    
    @HttpGET
    global static void invoiceGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String id = req.params.get('id');
        String name = req.params.get('name');
        APIGEE_Result result = new APIGEE_Result();
        
        if(String.isNotBlank(id)){
            //String query = 'Select Id,APTS_Invoice_Description__c, APTS_PO_Date__c,Apttus_Billing__Invoice__c.Name,Apttus_Billing__SoldToAccountId__r.APTS_Fuel_Efficiency_Sales_Org__c, Apttus_Billing__PONumber__c,Apttus_Billing__InvoiceDate__c,CurrencyIsoCode , Apttus_Billing__InvoiceNumber__c,  Apttus_Billing__SoldToAccountId__r.SAP_Sold_To__c, Apttus_Billing__SoldToAccountId__r.name, Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__BillToAccountId__r.name, Apttus_Billing__PaymentTermId__r.APTS_External_Id__c,   Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c, Apttus_Billing__ShipToAccountId__r.name,Apttus_Billing__TotalFeeAmount__c, ( Select  Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__c,Name,Integration_Sequence_Line_Number__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__BillingRule__c,Apttus_Billing__AssetLineItemId__r.APTS_Customer_Description__c, Apttus_Billing__Quantity__c,  Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.ProductCode,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__r.ProductCode,Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c, Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceType__c, Apttus_Billing__StartDate__c, Apttus_Billing__EndDate__c, Apttus_Billing__Amount__c, CurrencyIsoCode from Apttus_Billing__InvoiceLineItems__r) from Apttus_Billing__Invoice__c where Id = :id';
            String query = 'Select Id,APTS_Invoice_Description__c, APTS_PO_Date__c,Apttus_Billing__Invoice__c.Name, APTS_Sales_Org__c, Apttus_Billing__PONumber__c,Apttus_Billing__InvoiceDate__c,CurrencyIsoCode , Apttus_Billing__InvoiceNumber__c,  Apttus_Billing__SoldToAccountId__r.SAP_Sold_To__c, Apttus_Billing__SoldToAccountId__r.name, Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__BillToAccountId__r.name, Apttus_Billing__PaymentTermId__r.APTS_External_Id__c,   Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c, Apttus_Billing__ShipToAccountId__r.name,Apttus_Billing__TotalFeeAmount__c, ( Select  Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__c,Name,Integration_Sequence_Line_Number__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__BillingRule__c,Apttus_Billing__AssetLineItemId__r.APTS_Customer_Description__c, Apttus_Billing__Quantity__c,  Apttus_Billing__AssetLineItemId__r.Apttus_Config2__ProductId__r.ProductCode,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__OptionId__r.ProductCode,Apttus_Billing__ShipToAccountId__r.SAP_Sold_To__c, Apttus_Billing__BillToAccountId__r.SAP_Sold_To__c,Apttus_Billing__AssetLineItemId__r.Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceType__c, Apttus_Billing__StartDate__c, Apttus_Billing__EndDate__c, Apttus_Billing__Amount__c, CurrencyIsoCode from Apttus_Billing__InvoiceLineItems__r) from Apttus_Billing__Invoice__c where Id = :id';
            result.data = Database.query(query);
            
        }else if(String.isNotBlank(name)){
            String query1 = '';
            query1 = 'select Id from Apttus_Billing__Invoice__c where Name = :name';
            result.data = database.query(query1);
        }else{
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide Id/Name');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPUT
    global static void invoiceUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        try{
            String requestBody = req.requestBody.toString();
            Apttus_Billing__Invoice__c invoice = (Apttus_Billing__Invoice__c)JSON.deserialize(requestBody, Apttus_Billing__Invoice__c.class);
            update invoice;
            result.data = invoice;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}