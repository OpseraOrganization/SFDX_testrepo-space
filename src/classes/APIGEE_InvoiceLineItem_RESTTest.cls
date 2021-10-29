@isTest
public class APIGEE_InvoiceLineItem_RESTTest {
    @testSetup static void generateData(){
        Apttus_Billing__Invoice__c invoice = APIGEE_TestDataUtility.createInvoice();
        insert invoice;
        
        Apttus_Billing__InvoiceLineItem__c invLineItem = APIGEE_TestDataUtility.createInvoiceLineItem(invoice.Id);
        insert invLineItem;
    }
    
    @isTest static void testInvoiceLineItemGET() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/invoicelineitem/*';  
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Apttus_Billing__InvoiceLineItem__c invoiceLItem = [SELECT id, Name, Apttus_Billing__InvoiceId__c FROm Apttus_Billing__InvoiceLineItem__c LIMIT 1];
        APIGEE_InvoiceLineItem_REST.invoiceLineItemGET();        
        req.params.put('invoiceid',invoiceLItem.Apttus_Billing__InvoiceId__c);
        APIGEE_InvoiceLineItem_REST.invoiceLineItemGET();
        req.params.put('name',invoiceLItem.Name);
        APIGEE_InvoiceLineItem_REST.invoiceLineItemGET();
    }
    
    @isTest static void testInvoiceLineItemPut() {
        RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/invoicelineitem/*';  
       
       req.httpMethod = 'PUT';
       RestContext.request = req;
       RestContext.response = res;
       Apttus_Billing__InvoiceLineItem__c invLineItem = [SELECT id, Name, Apttus_Billing__InvoiceId__c FROm Apttus_Billing__InvoiceLineItem__c LIMIT 1];
       
       String jsonStr = JSON.serialize(invLineItem);
       req.requestBody = Blob.valueof(jsonStr);
       Test.startTest();        
          APIGEE_InvoiceLineItem_REST.invoiceLineItemUpdate();
       Test.stopTest();
    }
    
     @isTest static void testInvoiceLineItemPutInvalid() {
        RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/invoicelineitem/*';  
       
       req.httpMethod = 'PUT';
       RestContext.request = req;
       RestContext.response = res;
       Apttus_Billing__InvoiceLineItem__c invLineItem = new Apttus_Billing__InvoiceLineItem__c();
       
       String jsonStr = JSON.serialize(invLineItem);
       req.requestBody = Blob.valueof(jsonStr);
       Test.startTest();        
          APIGEE_InvoiceLineItem_REST.invoiceLineItemUpdate();
       Test.stopTest();
    }
}