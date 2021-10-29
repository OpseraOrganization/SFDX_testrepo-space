@isTest
private class RedirectToConvertPageTestClass
{
    static testMethod void RedirectToConvertPage()
    {
      Profile pf= [select id from Profile where name = 'System Administrator'];
      User usr = new User(FirstName = 'Test', LastName = 'UserLead',Username = 'testuserlead@test.com',Email = 'testuser@test.com',Alias = 'tuLead' ,CommunityNickname= 'tuld' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
      insert usr;

    //creating account;
    Account acc= new Account(name='TestLead Account', Market_name__c = 'Military');
    insert acc;
     Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
 insert cont;
    //Lead Initiator1 = new Lead(LastName='Test',Lead_converted__c=true,Account__c=acc.Id,Primary_Fax_Number__c='12345',Company='Test Lead Company', status = 'open', Opportunity_Type__c = 'BGA Aftermarket',Regional_Sales_Manager__c = 'Ali Sadoudi',ConvertedAccountID = acc.id);
    Lead leads= new Lead(LastName='Test',Status='Open',Lead_converted__c=true,Company='testComp',Account__c=acc.id , 
    Contact__c = cont.id);
insert leads;
leads.Status ='Sales Qualified Lead';
   update leads; 
    
        
        PageReference pageRef = Page.RedirectToLeadConvertPage;
        pageRef.getParameters().put('id', String.valueOf(leads.Id)); 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(leads);
        RedirectToConvertPage testlead = new RedirectToConvertPage(sc);
        testlead.redirctlead();
    }
    
}