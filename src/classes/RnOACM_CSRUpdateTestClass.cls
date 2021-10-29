@isTest
private class RnOACM_CSRUpdateTestClass
{
    static testMethod void updateACM_CSR()
    {
    
        Profile pf = [select id from Profile where name = 'System Administrator'];
        List<User> inseruser=new List<User>();
        List<Agent_Contact_Mapping__c> insertACM=new List<Agent_Contact_Mapping__c>();
        
        User usr = new User(LastName = 'Test UserSol',Username = 'tu1cso@test.com',
        Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1sol' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr);
        
        User usr1 = new User(LastName = 'Test UserSol1',Username = 'tu2cso@test.com',
        Email = 'testuser2@test.com',Alias = 'tu12' ,CommunityNickname= 'tu1sol2' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr1);
        
       insert inseruser;
        
        //creating account;
         Account acc= new Account(name='Test Account');
         insert acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
        insert cont;
        
        //inserting mapping record
        Agent_Contact_Mapping__c agenconmap=new Agent_Contact_Mapping__c(CSR__c=usr.Id,Contact__c=cont.Id,Process__c='R&O APU');
        insertACM.add(agenconmap);
        
        insert insertACM;
        
        List<Case> insertCases=new List<Case>();

       system.runas(usr)
       {        
         Case cases=new Case(ownerId=usr.Id,AccountId=acc.Id,Classification__c='CSO Repair/Overhaul',subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No',Government_Compliance_SM_M_Content__c='No', 
                             //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
                             Type='Order',origin='Email-R&O APU');
          insertCases.add(cases);
       }
       system.debug('Profile system running is'+userinfo.getprofileid());
        
       insert insertCases;
                
       Agent_Contact_Mapping__c objAgentConMap=[select CSR__c,id from Agent_Contact_Mapping__c where id=:agenconmap.Id ];
       objAgentConMap.CSR__c=usr1.Id;
       update objAgentConMap;
        
        
    }

}