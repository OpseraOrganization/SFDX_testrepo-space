@isTest (SeeAllData = true)
public class Test_updateSAPSoldTo {
static testMethod void Method1(){
    test.startTest();
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    
    User usr = new User();
        usr.LastName='Test';
        usr.Alias = 'Test';
        usr.Email='standarduser@test.com';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.EmailEncodingKey='UTF-8';
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.UserName='sumit13@ntt.com';
        usr.SBG__c=Label.GH_Aero; 
        usr.SBU_User__c=Label.GH_D_S;
        usr.ProfileId = p.Id;
        insert usr;
    
    System.runAs(usr){
Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        acc.Do_Not_Send_to_Portal__c=False;
        insert acc;
    
Account_Cross_Ref__c xref = new Account_Cross_Ref__c();
    xref.Account_Name__c=acc.id;
    xref.XREF_Type__c='SAP_SOLD_TO';
    xref.XREF_Name__c ='SAP';
    xref.External_Account_Name__c='test Account';
    xref.External_Account_ID__c='123456';
    xref.site_Code__c='1243';
    insert xref;
    test.stoptest();
    }   
}
}