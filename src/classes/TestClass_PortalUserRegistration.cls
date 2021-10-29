@isTest
Public Class TestClass_PortalUserRegistration{
    static testmethod void TestClass_PortalUserRegistration(){
        Test.startTest();
        Portal_User_Registration__c pur = new Portal_User_Registration__c();
        pur.Created_Date__c = system.now();
        pur.Last_Updated_del__c = null;
        pur.Contact_Match__c = 'Y';
        insert pur;
        pur.Contact_Match__c = 'N';
        pur.Last_Updated_del__c = system.now();
        update pur;
        Test.stopTest();
    }
}