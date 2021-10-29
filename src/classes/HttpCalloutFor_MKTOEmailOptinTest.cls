@isTest
private class HttpCalloutFor_MKTOEmailOptinTest{

    static testMethod void myUnitTest() {
        
         Test.startTest();
        
        RestRequest req = new RestRequest();
        req.params.put('email', 'test@test.com');
        req.params.put('Lp', 'Americas');
        req.params.put('St', 'true');
        RestResponse res = new RestResponse();
       
        RestContext.request = req;
        RestContext.response = res;
        
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse_MKTOEmailOptin());
        MKTO_Email_Optin_Callout.cls_result result = new MKTO_Email_Optin_Callout.cls_result(1,'test@test.com',1,'test');
        list<MKTO_Email_Optin_Callout.cls_result> listResult = new list<MKTO_Email_Optin_Callout.cls_result>(); 
        MKTO_Email_Optin_Callout.fromJSON resultJson = new MKTO_Email_Optin_Callout.fromJSON('685e#15ebdc2a093',listResult,true);
        MKTO_Email_Optin_Callout.updateOptInLeads('maheshbabu11.kayala@nttdata.com','True');
        
        Test.stopTest();
         
    }
    
   
 }