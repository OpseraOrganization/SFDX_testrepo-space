@isTest(SeeAllData=true)
private class Test_Customerstorypagecls{
   static testMethod void Customerstorypagecls(){
    
       //creating new profile and user                  
        Profile ProfRec = [select name from Profile where name = 'System Administrator'];
        User userRec = new User(LastName = 'venkat',Username = 'venkat@test.com.four',Email = 'venkat@test55.com',Alias = 'venkat4' ,CommunityNickname= 'venkat4' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US');
        insert userRec;
       //customer story
        CustomerStory__c cs=new CustomerStory__c();        
        cs.Name='test';
        //cs.Product__c='';
        cs.Story_Type__c='Win';
        cs.Status__c='Backlog';
        cs.Sales_Reference__c='Yes';
        cs.Sharing_Restriction__c='Educational Use Only - Do Not Mention Customer Name';
        cs.Region1__c='APAC';
        cs.SBU__c='BGA';
        cs.Story_Owner__c=userRec.id;
        insert cs;
       
       ApexPages.StandardController sc = new ApexPages.standardController(cs);
       Customerstorypagecls controller = new Customerstorypagecls (sc);
       controller.loadEvent();
   }
   }