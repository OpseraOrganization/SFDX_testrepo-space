@isTest
public class DSPC_AccReq_controller_test {
    static testMethod void myUnitTest() {
    
    Profile p = [select Id,name from Profile where name like :'System Administrator' limit 1]; 
    User newUser = new User(
        profileId = p.id,
        username = 'newUser@ntttest.com',
        email = 'testuser@test.com',
        emailencodingkey = 'UTF-8',
        localesidkey = 'en_US',
        languagelocalekey = 'en_US',
        timezonesidkey = 'America/Los_Angeles',
        alias='nuser',
        lastname='lastname'
    );
    insert newUser;
    Case cs = new Case();
    cs.Account_Name_web__c = 'Test Account';
    cs.Status = 'Active';
    cs.dealer_distributor__c = newUser.id;
    cs.CSM_Region__c = 'Americas';
    cs.SuppliedPhone = '1112223333';
    cs.Account_Fax_Number__c = '1112223333';
    cs.Company_Website_URL__c = 'www.test.com';
    cs.Address_Line_1__c = 'Test Address 1';
    cs.Address_Line_2__c = 'Test Address 2';
    cs.Address_Line_3__c = 'Test Address 3';
    cs.City_Name__c = 'Test City';
    cs.State_Code__c = 'TS';
    cs.Zip_Postal_Code__c = '12345';
    cs.Country_Name__c = 'Test Country';
    cs.Description = 'Test Description';
    cs.First_Call_Resolution__c = true;
   // cs.RecordTypeId = label.DSPC_Case_RT;
    cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
    cs.Government_Compliance_SM_M_Content__c = 'No';
    insert cs;
    PageReference pageRef = Page.DSPC_Account_Request;
    Test.setCurrentPage(pageRef);
    pageRef.getParameters().put('id',cs.id);
    DSPC_AccReq_controller Cntlr = new DSPC_AccReq_controller();
    Cntlr.Submit();
    Cntlr.Back();
    }
}