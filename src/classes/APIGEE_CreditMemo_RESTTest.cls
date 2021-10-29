@isTest
public class APIGEE_CreditMemo_RESTTest {
    @testSetup static void generateData(){
        Account acc = APIGEE_TestDataUtility.createAccount();
        insert acc;
        Apttus_Billing__CreditMemo__c creditMemo = APIGEE_TestDataUtility.createCreditMemo(acc.Id);
        insert creditMemo;
    }
    
    static testMethod void creditMemoGETtest1(){
        Apttus_Billing__CreditMemo__c creditMemo = [select id,name from Apttus_Billing__CreditMemo__c LIMIT 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemo/*';  
        req.addParameter('mode', 'detail');
        req.addParameter('name', creditMemo.name);
        req.addParameter('id', creditMemo.id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_CreditMemo_REST.creditMemoGET();
        test.stopTest();
    }
    
    static testMethod void creditMemoGETtest2(){
        Apttus_Billing__CreditMemo__c creditMemo = [select id,name from Apttus_Billing__CreditMemo__c LIMIT 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemo/*';  
        req.addParameter('name', creditMemo.name);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_CreditMemo_REST.creditMemoGET();
        test.stopTest();
    }
    
    static testMethod void creditMemoGETtest3(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemo/*';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_CreditMemo_REST.creditMemoGET();
        test.stopTest();
    }
    
    static testMethod void creditMemoUpdateTest1(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemo/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        Apttus_Billing__CreditMemo__c obj = [select APTS_Integration_Status__c,APTS_CMR_Number__c,APTS_CMR_Status__c,APTS_Billing_Document_Number__c,Apttus_Billing__TotalTaxAmount__c,APTS_Integration_Result__c,Apttus_Billing__CreditAmount__c,Apttus_Billing__TotalCreditAmount__c,Apttus_Billing__Status__c,Apttus_Billing__PaymentStatus__c from Apttus_Billing__CreditMemo__c LIMIT 1];
        
        String jsonReq= JSON.serialize(obj);
        req.requestBody = Blob.valueOf(jsonReq);        
        test.startTest();
        APIGEE_CreditMemo_REST.creditMemoUpdate();
        test.stopTest();
    }
    
    static testMethod void creditMemoUpdateTest2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemo/*';  
        
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
       
        test.startTest();
        APIGEE_CreditMemo_REST.creditMemoUpdate();
        test.stopTest();
    }
}