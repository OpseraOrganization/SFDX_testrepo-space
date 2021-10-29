@isTest()
private class PortalUserRegistrationclsTest{

    static testMethod void myUnitTest() 
    {
     Portal_User_Registration__c p=new Portal_User_Registration__c();
     p.Contact_Creation_in_SFDC__c='';
     p.Honeywell_ID__c='1234';
     insert p;     
     PortalUserRegistrationcls pur= new PortalUserRegistrationcls ();
     integer SFDCUser=1;     
     pur.contactCreatedCount=SFDCUser;     
     pur.firstTryCount=SFDCUser;
     pur.getCases();
 
    }
    
    static testMethod void myUnitTest1() 
    {
     Portal_User_Registration__c p=new Portal_User_Registration__c();
     p.Contact_Creation_in_SFDC__c='';
     p.Honeywell_ID__c='1234';
     insert p;
     Portal_User_Registration__c p1=new Portal_User_Registration__c();
     p1.Contact_Creation_in_SFDC__c='y';
     p1.Honeywell_ID__c='1234';
     insert p1;       
     PortalUserRegistrationcls pur= new PortalUserRegistrationcls ();
     pur.getCases();
 
    }
     static testMethod void myUnitTest2() 
    {
     Portal_User_Registration__c p=new Portal_User_Registration__c();
     p.Contact_Creation_in_SFDC__c='y';
     p.Honeywell_ID__c='1234';
     insert p;  
     
     PortalUserRegistrationcls pur= new PortalUserRegistrationcls ();
     integer SFDCUser=1;     
         
     pur.firstTryCount=SFDCUser;
     pur.getCases();
 
    }
    static testMethod void myUnitTest3() 
    {
     Portal_User_Registration__c p=new Portal_User_Registration__c();
     p.Contact_Creation_in_SFDC__c='';
     p.Honeywell_ID__c='1234';
     insert p;  
     Apexpages.currentPage().getParameters().put('event_start_date_alternate','2016-01-01');
     Apexpages.currentPage().getParameters().put('event_end_date_alternate','2016-12-31');
     PortalUserRegistrationcls pur= new PortalUserRegistrationcls ();
     integer SFDCUser=1;     
     pur.contactCreatedCount=SFDCUser;     
     pur.firstTryCount=SFDCUser;
     pur.getCases();
 
    }
 }