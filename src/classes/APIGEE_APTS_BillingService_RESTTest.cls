@isTest
public class APIGEE_APTS_BillingService_RESTTest {
    @testsetup static void generateData(){
        Apttus_Billing__Invoice__c inv = APIGEE_TestDataUtility.createInvoice();
        insert inv;
    }
    
    static testMethod void approveInvoice(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/billingservices/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        Apttus_Billing__Invoice__c inv = [SELECT id FROM Apttus_Billing__Invoice__c LIMIT 1];
        APIGEE_APTS_BillingService_REST.InvoiceRequest invReq = new APIGEE_APTS_BillingService_REST.InvoiceRequest();
        invReq.invoiceIds = new List<String>{inv.Id};
            invReq.isApprove = true;
        
        req.requestBody = Blob.valueOf(JSON.serialize(invReq));
        APIGEE_APTS_BillingService_REST.approveRejectInvoice();
    }
    static testMethod void rejectInvoice(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/billingservices/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        Apttus_Billing__Invoice__c inv = [SELECT id FROM Apttus_Billing__Invoice__c LIMIT 1];
        APIGEE_APTS_BillingService_REST.InvoiceRequest invReq = new APIGEE_APTS_BillingService_REST.InvoiceRequest();
        invReq.invoiceIds = new List<String>{inv.Id};
            invReq.isApprove = false;
        
        req.requestBody = Blob.valueOf(JSON.serialize(invReq));
        APIGEE_APTS_BillingService_REST.approveRejectInvoice();
    }
    static testMethod void exceptionInvoice(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/billingservices/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        Apttus_Billing__Invoice__c inv = [SELECT id FROM Apttus_Billing__Invoice__c LIMIT 1];
        APIGEE_APTS_BillingService_REST.InvoiceRequest invReq = new APIGEE_APTS_BillingService_REST.InvoiceRequest();
               
        req.requestBody = Blob.valueOf(JSON.serialize(inv));
        APIGEE_APTS_BillingService_REST.approveRejectInvoice();
    }
}