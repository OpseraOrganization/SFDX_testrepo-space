@isTest
public class APIGEE_CreditTaxBreakup_RESTTest {
    
     @testSetup static void generateData(){
        Account acc = APIGEE_TestDataUtility.createAccount();
        insert acc;
        Apttus_Billing__CreditMemo__c creditMemo = APIGEE_TestDataUtility.createCreditMemo(acc.Id);
        insert creditMemo;
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = APIGEE_TestDataUtility.createCreditMemoLineItem(creditMemo.Id);
        insert creditMemoLineItem;
        Apttus_Billing__CreditMemoLineItemTaxBreakup__c creditMemoTaxBreakup = APIGEE_TestDataUtility.createCreditMemoTaxBreakup(creditMemoLineItem.Id);
        insert creditMemoTaxBreakup;
    }
    
    static testMethod void creditMemoLineItemTaxBreakupGETtest1(){
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = [select id,name from Apttus_Billing__CreditMemoLineItem__c LIMIT 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemolineitem/*';  
        req.addParameter('creditlineitemid', creditMemoLineItem.Id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_CreditMemoLineItemTaxBreakup_REST.creditMemoLineItemTaxBreakupGET();
        req.addParameter('lineitemid', creditMemoLineItem.Id);
        APIGEE_CreditMemoLineItemTaxBreakup_REST.creditMemoLineItemTaxBreakupGET();
        test.stopTest();
    }
    
    static testMethod void creditMemoLineItemTaxBreakupGETtest2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemolineitem/*';  
        
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_CreditMemoLineItemTaxBreakup_REST.creditMemoLineItemTaxBreakupGET();
        test.stopTest();
    }
    
    @isTest static Void creditMemoTaxDeleteTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        Apttus_Billing__CreditMemoLineItemTaxBreakup__c creditMemoTaxBreakup = [SELECT id, Name FROM Apttus_Billing__CreditMemoLineItemTaxBreakup__c LIMIT 1];
        req.httpMethod = 'DELETE';
        req.requestURI = '/creditmemolineitem';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf('{}');
        APIGEE_CreditMemoLineItemTaxBreakup_REST.creditMemoLITaxDELETE();
        req.requestBody = Blob.valueOf('{"taxid":"'+creditMemoTaxBreakup.Id+'"}');
        Test.startTest();
            APIGEE_CreditMemoLineItemTaxBreakup_REST.creditMemoLITaxDELETE();
        Test.stopTest();
    }
    
    @isTest static Void creditMemoTaxDeleteExceptionTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'DELETE';
        req.requestURI = '/creditmemolineitem';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf('{"taxid":"invalid"}');
        Test.startTest();
            APIGEE_CreditMemoLineItemTaxBreakup_REST.creditMemoLITaxDELETE();
        Test.stopTest();
    }
    
    @isTest static Void creditMemoTaxCreateTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestURI = '/invoicetaxbreakup';
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = [SELECT id, Name FROM Apttus_Billing__CreditMemoLineItem__c LIMIT 1];
        Apttus_Billing__CreditMemoLineItemTaxBreakup__c creditMemoTaxBreakup = APIGEE_TestDataUtility.createCreditMemoTaxBreakup(creditMemoLineItem.Id);
        req.requestBody = Blob.valueOf(JSON.serialize(creditMemoTaxBreakup));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_CreditMemoLineItemTaxBreakup_REST.creditMemoLineItemTaxBreakupCreate();
        Test.stopTest();
    }
    
    @isTest static Void creditMemoTaxCreateExceptionTest(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.httpMethod = 'POST';
        req.requestURI = '/invoicetaxbreakup';
        Apttus_Billing__CreditMemoLineItemTaxBreakup__c taxbreakup = [SELECT id, Name FROM Apttus_Billing__CreditMemoLineItemTaxBreakup__c LIMIT 1];
        req.requestBody = Blob.valueOf(JSON.serialize(taxbreakup));
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
            APIGEE_CreditMemoLineItemTaxBreakup_REST.creditMemoLineItemTaxBreakupCreate();
        Test.stopTest();
    }
}