@isTest
public class APIGEE_APTS_BillingServiceCM_RESTTest {
    @testsetup static void generateData(){
        Account acc = APIGEE_TestDataUtility.createAccount();
        insert acc;
        Apttus_Billing__CreditMemo__c creditMemo = APIGEE_TestDataUtility.createCreditMemo(acc.Id);
        insert creditMemo;
    }
    
     static testMethod void approveCreditMemo(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/billingservicescm/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        Apttus_Billing__CreditMemo__c creditMemo = [SELECT id FROM Apttus_Billing__CreditMemo__c LIMIT 1];
        APIGEE_APTS_BillingServiceCM_REST.CreditMemoRequest cmReq = new APIGEE_APTS_BillingServiceCM_REST.CreditMemoRequest();
        cmReq.creditMemoIds = new List<String>{creditMemo.Id};
        cmReq.isApprove = true;
        
        req.requestBody = Blob.valueOf(JSON.serialize(cmReq));
        APIGEE_APTS_BillingServiceCM_REST.approveRejectCreditMemo();
    }
    
    static testMethod void rejectCreditMemo(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/billingservicescm/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        Apttus_Billing__CreditMemo__c creditMemo = [SELECT id FROM Apttus_Billing__CreditMemo__c LIMIT 1];
        APIGEE_APTS_BillingServiceCM_REST.CreditMemoRequest cmReq = new APIGEE_APTS_BillingServiceCM_REST.CreditMemoRequest();
        cmReq.creditMemoIds = new List<String>{creditMemo.Id};
        cmReq.isApprove = false;
        
        req.requestBody = Blob.valueOf(JSON.serialize(cmReq));
        APIGEE_APTS_BillingServiceCM_REST.approveRejectCreditMemo();
    }
    
    static testMethod void exceptionCreditMemo(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/billingservicescm/*';
        req.httpMethod = 'PUT';
        RestContext.request = req;
        RestContext.response = res;
        Apttus_Billing__CreditMemo__c creditMemo = [SELECT id FROM Apttus_Billing__CreditMemo__c LIMIT 1];
        APIGEE_APTS_BillingServiceCM_REST.CreditMemoRequest cmReq = new APIGEE_APTS_BillingServiceCM_REST.CreditMemoRequest();
               
        req.requestBody = Blob.valueOf(JSON.serialize(creditMemo));
        APIGEE_APTS_BillingServiceCM_REST.approveRejectCreditMemo();
    }
}