@isTest
public class APIGEE_CreditMemoLineItem_RESTTest {
    @testSetup static void generateData(){
        Account acc = APIGEE_TestDataUtility.createAccount();
        insert acc;
        Apttus_Billing__CreditMemo__c creditMemo = APIGEE_TestDataUtility.createCreditMemo(acc.Id);
        insert creditMemo;
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = APIGEE_TestDataUtility.createCreditMemoLineItem(creditMemo.Id);
        insert creditMemoLineItem;
    }
    
    static testMethod void creditMemoLineItemGETtest1(){
        
        Apttus_Billing__CreditMemoLineItem__c p = [select id,name from Apttus_Billing__CreditMemoLineItem__c LIMIT 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemolineitem/*';  
        req.addParameter('name', p.name);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_CreditMemoLineItem_REST.creditMemoLineItemGET();
        test.stopTest();
    }
    
    static testMethod void creditMemoLineItemGETtest2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemolineitem/*';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        APIGEE_CreditMemoLineItem_REST.creditMemoLineItemGET();
        test.stopTest();
    }
    
     static testMethod void creditMemoLineItemUpdateTest1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemo/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        Apttus_Billing__CreditMemoLineItem__c obj = [select id,Apttus_Billing__TaxAmount__c from Apttus_Billing__CreditMemoLineItem__c LIMIT 1];
        String jsonReq= JSON.serialize(obj);
        req.requestBody = Blob.valueOf(jsonReq);
        test.startTest();
            APIGEE_CreditMemoLineItem_REST.creditMemoLineItemUpdate();
        test.stopTest();
    }
    
     static testMethod void creditMemoLineItemUpdateTest2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/creditmemo/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
            APIGEE_CreditMemoLineItem_REST.creditMemoLineItemUpdate();
        test.stopTest();
    }

}