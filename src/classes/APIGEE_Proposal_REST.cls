@RestResource(urlMapping='/proposal/*') 
global class APIGEE_Proposal_REST {
    @HttpGET
    global static void proposalGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String mode = req.params.get('mode');
        String name = req.params.get('name');
        String id = req.params.get('id');
        
        APIGEE_Result result = new APIGEE_Result();
        
        if(String.isNotBlank(name) || String.isNotBlank(id)){
            String query = '';
            if(String.isNotBlank(id)){
                //query = 'Select Apttus_QPConfig__PODate__c,Apttus_QPConfig__PricingDate__c,Name,Apttus_QPConfig__PaymentTermId__r.APTS_External_Id__c, Apttus_Proposal__Account__r.Apttus_Config2__PaymentTermId__r.APTS_External_Id__c,APTS_Price_List_Currecy__c, Apttus_Proposal__Account__r.APTS_Fuel_Efficiency_Sales_Org__c, Apttus_Proposal__Description__c,Id,  Apttus_Proposal__Account__r.SAP_Sold_To__c,Apttus_Proposal__Account__r.Name,  Apttus_QPConfig__BillToAccountId__r.SAP_Sold_To__c,Apttus_QPConfig__BillToAccountId__r.Name,   Apttus_QPConfig__ShipToAccountId__r.SAP_Sold_To__c,Apttus_QPConfig__ShipToAccountId__r.Name ,(Select  Apttus_QPConfig__LineNumber__c ,Id,Name,Apttus_QPConfig__ItemSequence__c,Apttus_QPConfig__BillingRule__c,Apttus_QPConfig__OptionId__r.ProductCode,Apttus_QPConfig__Quantity2__c, Integration_Item_Number__c,APTS_Customer_Description__c ,Apttus_Proposal__Product__r.ProductCode,Apttus_QPConfig__BillToAccountId__r.SAP_Sold_To__c,  Apttus_QPConfig__ShipToAccountId__r.SAP_Sold_To__c, Apttus_QPConfig__PriceListItemId__r.Apttus_Config2__PriceType__c, Apttus_QPConfig__StartDate__c, Apttus_QPConfig__EndDate__c, Apttus_QPConfig__NetPrice__c,Apttus_QPConfig__BasePrice__c, CurrencyIsoCode from Apttus_Proposal__R00N70000001yUfBEAU__r where (Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c = \'Standalone\') OR(Apttus_Proposal__Product__r.Apttus_Config2__BundleInvoiceLevel__c = \'Bundle\' AND Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c = \'Bundle\' AND Apttus_QPConfig__OptionId__c = NULL) OR  (Apttus_Proposal__Product__r.Apttus_Config2__BundleInvoiceLevel__c = \'Detail\' AND Apttus_QPConfig__OptionId__c != NULL)) from Apttus_Proposal__Proposal__c WHERE id=:id';
                query = 'Select Apttus_QPConfig__PODate__c,Apttus_QPConfig__PricingDate__c,Name,Apttus_QPConfig__PaymentTermId__r.APTS_External_Id__c, Apttus_Proposal__Account__r.Apttus_Config2__PaymentTermId__r.APTS_External_Id__c,APTS_Price_List_Currecy__c, APTS_Sales_Org__c, Apttus_Proposal__Description__c,Id,  Apttus_Proposal__Account__r.SAP_Sold_To__c,Apttus_Proposal__Account__r.Name,  Apttus_QPConfig__BillToAccountId__r.SAP_Sold_To__c,Apttus_QPConfig__BillToAccountId__r.Name,   Apttus_QPConfig__ShipToAccountId__r.SAP_Sold_To__c,Apttus_QPConfig__ShipToAccountId__r.Name ,(Select  Apttus_QPConfig__LineNumber__c ,Id,Name,Apttus_QPConfig__ItemSequence__c,Apttus_QPConfig__BillingRule__c,Apttus_QPConfig__OptionId__r.ProductCode,Apttus_QPConfig__Quantity2__c, Integration_Item_Number__c,APTS_Customer_Description__c ,Apttus_Proposal__Product__r.ProductCode,Apttus_QPConfig__BillToAccountId__r.SAP_Sold_To__c,  Apttus_QPConfig__ShipToAccountId__r.SAP_Sold_To__c, Apttus_QPConfig__PriceListItemId__r.Apttus_Config2__PriceType__c, Apttus_QPConfig__StartDate__c, Apttus_QPConfig__EndDate__c, Apttus_QPConfig__NetPrice__c,Apttus_QPConfig__BasePrice__c, CurrencyIsoCode from Apttus_Proposal__R00N70000001yUfBEAU__r where (Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c = \'Standalone\') OR(Apttus_Proposal__Product__r.Apttus_Config2__BundleInvoiceLevel__c = \'Bundle\' AND Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c = \'Bundle\' AND Apttus_QPConfig__OptionId__c = NULL) OR  (Apttus_Proposal__Product__r.Apttus_Config2__BundleInvoiceLevel__c = \'Detail\' AND Apttus_QPConfig__OptionId__c != NULL)) from Apttus_Proposal__Proposal__c WHERE id=:id';
            }else if(String.isNotBlank(name)){
                query = 'SELECT Id FROM Apttus_Proposal__Proposal__c WHERE name=:name';
            }
            
            result.data = Database.query(query);
            
        }else{
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Proposal Name or Proposal Id');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPOST
    global static void proposalCreate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        try{
            String requestBody = req.requestBody.toString();
            Apttus_Proposal__Proposal__c proposal = (Apttus_Proposal__Proposal__c)JSON.deserialize(requestBody, Apttus_Proposal__Proposal__c.class);
            proposal.Apttus_Proposal__ExpectedEndDate__c = Date.today();
            proposal.Apttus_Proposal__ExpectedStartDate__c = Date.today();
            proposal.Apttus_QPConfig__ReadyForActivationDate__c = Date.today();
            proposal.Apttus_QPConfig__ReadyForBillingDate__c = Date.today();
            insert proposal;
            result.data = proposal;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.Error = new APIGEE_Error(400,System.now(),Null,ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
    
    @HttpPUT
    global static void proposalUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        try{
            String requestBody = req.requestBody.toString();
            Apttus_Proposal__Proposal__c proposal = (Apttus_Proposal__Proposal__c)JSON.deserialize(requestBody, Apttus_Proposal__Proposal__c.class);
            update proposal;
            result.data = proposal;
        }catch(Exception ex){
            res.statusCode = 400;
            result.status = 'FAIL';
            result.StatusCode=400;
            result.error = new APIGEE_Error(400, System.now(), Null, ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}