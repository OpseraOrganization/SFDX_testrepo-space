@isTest
public class APIGEE_Invoice_RESTTest {
    
    @testSetup static void generateData(){
        Apttus_Billing__Invoice__c invoice = APIGEE_TestDataUtility.createInvoice();
        insert invoice;
    }

   @isTest static void testInvoiceGET() {
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/invoice/*';  
       
       req.httpMethod = 'GET';
       RestContext.request = req;
       RestContext.response = res;
       Apttus_Billing__Invoice__c invoice = [SELECT id, Name FROm Apttus_Billing__Invoice__c LIMIT 1];
       APIGEE_Invoice_REST.invoiceGET();
       req.params.put('name',invoice.Name);
       APIGEE_Invoice_REST.invoiceGET();
       req.params.put('id',invoice.Id);
       APIGEE_Invoice_REST.invoiceGET();
       System.assert(RestContext.response.responseBody != Null);
   }
    
    @isTest static void testInvoicePUT() {
        RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/invoice/*';  
       
       req.httpMethod = 'PUT';
       RestContext.request = req;
       RestContext.response = res;
       Apttus_Billing__Invoice__c invoice = [SELECT id, Name FROm Apttus_Billing__Invoice__c LIMIT 1];
       invoice.Apttus_Billing__Status__c = 'Approved';
       String jsonStr = JSON.serialize(invoice);
       req.requestBody = Blob.valueof(jsonStr);
       Test.startTest();        
          APIGEE_Invoice_REST.invoiceUpdate();
       Test.stopTest();
       Apttus_Billing__Invoice__c invoiceUpdated = [SELECT id, Name,Apttus_Billing__Status__c FROm Apttus_Billing__Invoice__c WHERE id=:invoice.Id];
       System.assert(invoiceUpdated.Apttus_Billing__Status__c == 'Approved');
    }
    @isTest static void testInvoicePUTInvalid() {
        RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       req.requestURI = '/services/invoice/*';  
       
       req.httpMethod = 'PUT';
       RestContext.request = req;
       RestContext.response = res;
       Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c();
       invoice.Apttus_Billing__Status__c = 'Approved';
       String jsonStr = JSON.serialize(invoice);
       req.requestBody = Blob.valueof(jsonStr);
       Test.startTest();        
          APIGEE_Invoice_REST.invoiceUpdate();
       Test.stopTest();
       System.assert(RestContext.response.responseBody != Null);
    }
}