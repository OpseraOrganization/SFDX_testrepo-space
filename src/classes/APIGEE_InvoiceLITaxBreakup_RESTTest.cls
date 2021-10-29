@isTest
public class APIGEE_InvoiceLITaxBreakup_RESTTest {
    @testSetup static void generateData(){
        Apttus_Billing__Invoice__c invoice = APIGEE_TestDataUtility.createInvoice();
        insert invoice;
        
        Apttus_Billing__InvoiceLineItem__c invLineItem = APIGEE_TestDataUtility.createInvoiceLineItem(invoice.Id);
        insert invLineItem;
        
        Apttus_Billing__InvoiceLineItemTaxBreakup__c invoiceTaxBreakUp = APIGEE_TestDataUtility.createInvoiceTaxBreakup(invLineItem.Id);
        insert invoiceTaxBreakUp;
    }
    
    @isTest static Void invoiceTaxGETTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_Billing__InvoiceLineItem__c invLineItem = [SELECT id, Name FROM Apttus_Billing__InvoiceLineItem__c LIMIT 1];
        req.httpMethod = 'GET';
        req.requestURI = '/invoicetaxbreakup';
        RestContext.request = req;
        RestContext.response = res;
        APIGEE_InvoiceLineItemTaxBreakup_REST.invoiceLineItemTaxBreakupGET();
        req.addParameter('lineitemid', invLineItem.Id);
        Test.startTest();
        APIGEE_InvoiceLineItemTaxBreakup_REST.invoiceLineItemTaxBreakupGET();
        req.addParameter('externalid', invLineItem.Id);
        APIGEE_InvoiceLineItemTaxBreakup_REST.invoiceLineItemTaxBreakupGET();
        Test.stopTest();
    }
    
    @isTest static Void invoiceTaxDeleteTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_Billing__InvoiceLineItemTaxBreakup__c invoiceTaxBreakup = [SELECT id, Name FROM Apttus_Billing__InvoiceLineItemTaxBreakup__c LIMIT 1];
        req.httpMethod = 'DELETE';
        req.requestURI = '/invoicetaxbreakup';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf('{}');
        APIGEE_InvoiceLineItemTaxBreakup_REST.invoiceLineTaxDELETE();
        req.requestBody = Blob.valueOf('{"taxid":"'+invoiceTaxBreakup.Id+'"}');
        Test.startTest();
            APIGEE_InvoiceLineItemTaxBreakup_REST.invoiceLineTaxDELETE();
        Test.stopTest();
    }
    
    @isTest static Void invoiceTaxDeleteExceptionTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'DELETE';
        req.requestURI = '/invoicetaxbreakup';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf('{"taxid":"invalid"}');
        Test.startTest();
            APIGEE_InvoiceLineItemTaxBreakup_REST.invoiceLineTaxDELETE();
        Test.stopTest();
    }
    
    @isTest static Void invoiceTaxCreateTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestURI = '/invoicetaxbreakup';
        Apttus_Billing__InvoiceLineItem__c invLineItem = [SELECT id, Name FROM Apttus_Billing__InvoiceLineItem__c LIMIT 1];
        Apttus_Billing__InvoiceLineItemTaxBreakup__c invoiceTaxBreakUp = APIGEE_TestDataUtility.createInvoiceTaxBreakup(invLineItem.Id);
        req.requestBody = Blob.valueOf(JSON.serialize(invoiceTaxBreakUp));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_InvoiceLineItemTaxBreakup_REST.createInvoiceLineItemTaxBreakup();
        Test.stopTest();
    }
    
    @isTest static Void invoiceTaxCreateExceptionTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestURI = '/invoicetaxbreakup';
        Apttus_Billing__InvoiceLineItemTaxBreakup__c taxbreakup = [SELECT id, Name FROM Apttus_Billing__InvoiceLineItemTaxBreakup__c LIMIT 1];
        req.requestBody = Blob.valueOf(JSON.serialize(taxbreakup));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_InvoiceLineItemTaxBreakup_REST.createInvoiceLineItemTaxBreakup();
        Test.stopTest();
    }
}