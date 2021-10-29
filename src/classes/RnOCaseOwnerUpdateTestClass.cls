/**************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : RnOCaseOwnerUpdateTestClass
* Description           : 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* Nov-08-2013      1.0            Anusuy Murugiah       Wrapping the testmethod with Start and Stop
**************************************************************************************************/
@isTest
private class RnOCaseOwnerUpdateTestClass
{
    static testMethod void updateCSR()
    {
        Id rcrdtypeid=[select id from recordtype where name='Repair & Overhaul' 
        and SobjectType='Case' limit 1].Id;
        // Profile pf = [select id from Profile where name = 'CSO Busines Admin (US)'];
        
        Profile pf = [select id from Profile where name = 'System Administrator'];
        List<User> inseruser=new List<User>();
        List<Agent_Contact_Mapping__c> insertACM=new List<Agent_Contact_Mapping__c>();
        Test.startTest();
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
        
        User usr2 = new User(LastName = 'Test UserSol21',Username = 'tu2cso2@test.com',
        Email = 'testuser2@test.com',Alias = 'tu122' ,CommunityNickname= 'tu1sol3' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
       inseruser.add(usr2);
        
        User usr3 = new User(LastName = 'Test UserSol31',Username = 'tu23cso@test.com',
        Email = 'testuser32@test.com',Alias = 'tu3123' ,CommunityNickname= 'tu13sol2' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr3);
        
        User usr4 = new User(LastName = 'Test UserSol14',Username = 'tu2cso4@test.com',
        Email = 'testuser24@test.com',Alias = 'tu124' ,CommunityNickname= 'tu1sol42' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr4);
        
        User usr5 = new User(LastName = 'Test UserSol15',Username = 'tu2cso5@test.com',
        Email = 'testuser25@test.com',Alias = 'tu125' ,CommunityNickname= 'tu1sol25' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr5);
        
        User usr6 = new User(LastName = 'Test UserSol16',Username = 'tu2cso6@test.com',
        Email = 'testuser2@test.com',Alias = 'tu126' ,CommunityNickname= 'tu1sol26' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr6);
        
        User usr7 = new User(LastName = 'Test UserSol71',Username = 'tu2cso7@test.com',
        Email = 'testuser2@test.com',Alias = 'tu127' ,CommunityNickname= 'tu1sol72' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr7);
        
        User usr8 = new User(LastName = 'Test UserSol81',Username = 'tu2c8so@test.com',
        Email = 'testuser2@test.com',Alias = 'tu128' ,CommunityNickname= 'tu1sol28' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr8);
        
        User usr9 = new User(LastName = 'Test UserSol819',Username = 'tu2c8so9@test.com',
        Email = 'testuser2@test.com',Alias = 'tu1289' ,CommunityNickname= 'tu1sol28976' ,
        TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
        ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        inseruser.add(usr9);
        
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
        
        /*Agent_Contact_Mapping__c agenconmap2=new Agent_Contact_Mapping__c(CSR__c=usr3.Id,Contact__c=cont.Id,Process__c='R&O Wheels and Brakes/Greer');
        insertACM.add(agenconmap2);*/
        
        Agent_Contact_Mapping__c agenconmap3=new Agent_Contact_Mapping__c(CSR__c=usr4.Id,Contact__c=cont.Id,Process__c='R&O Engines');
        insertACM.add(agenconmap3);
        
        Agent_Contact_Mapping__c agenconmap4=new Agent_Contact_Mapping__c(CSR__c=usr5.Id,Contact__c=cont.Id,Process__c='R&O Mech Components');
        insertACM.add(agenconmap4);
        
        Agent_Contact_Mapping__c agenconmap5=new Agent_Contact_Mapping__c(CSR__c=usr6.Id,Contact__c=cont.Id,Process__c='ATR R&O Internal');
        insertACM.add(agenconmap5);
        
        Agent_Contact_Mapping__c agenconmap6=new Agent_Contact_Mapping__c(CSR__c=usr7.Id,Contact__c=cont.Id,Process__c='BGA R&O Internal');
        insertACM.add(agenconmap6);
        
        Agent_Contact_Mapping__c agenconmap7=new Agent_Contact_Mapping__c(CSR__c=usr8.Id,Contact__c=cont.Id,Process__c='D&S R&O Internal');
        insertACM.add(agenconmap7);
        
        Agent_Contact_Mapping__c agenconmap8=new Agent_Contact_Mapping__c(CSR__c=usr9.Id,Contact__c=cont.Id,Process__c='R&O Canada');
        insertACM.add(agenconmap8);
        
        insert insertACM;
       
        List<Case> insertCases=new List<Case>();
        DateTime dt=system.today()+1;
        
        Case cases=new Case(AccountId=acc.Id,Classification__c='CSO Repair/Overhaul',subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',recordtypeid=label.Repair_Overhaul_RT_ID,origin='Email-R&O APU',Status='Open',HON_Commit_Date__c=dt);
        insertCases.add(cases);
        
        
        //to enter in to other mail box conditions
         /*Case cases2=new Case(AccountId=acc.Id,Classification__c='CSO Repair/Overhaul',subject='Fax:{9986502495} test1 data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        No_FCR_Reason__c='Not Trained',Type='Order',recordtypeid=label.Repair_Overhaul_RT_ID,origin='Email-R&O Wheels and Brakes/Greer',Status='Open',HON_Commit_Date__c=dt);
        insertCases.add(cases2);*/
        
        //to enter in to other mail box conditions
         Case cases3=new Case(AccountId=acc.Id,Classification__c='CSO Repair/Overhaul',subject='Fax:{9986502495} test1 data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',recordtypeid=label.Repair_Overhaul_RT_ID,origin='Email-R&O Engines',Status='Open',HON_Commit_Date__c=dt);
        insertCases.add(cases3);
        
        //to enter in to other mail box conditions
         Case cases4=new Case(AccountId=acc.Id,Classification__c='CSO Repair/Overhaul',subject='Fax:{9986502495} test1 data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',recordtypeid=label.Repair_Overhaul_RT_ID,origin='Email-R&O Mech Components',Status='Open',HON_Commit_Date__c=dt);
        insertCases.add(cases4);
        
        //to enter in to other mail box conditions
         /*Case cases5=new Case(ownerId=usr.Id,AccountId=acc.Id,Classification__c='CSO Repair/Overhaul',subject='Fax:{9986502495} test1 data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        No_FCR_Reason__c='Not Trained',Type='Order',recordtypeid=rcrdtypeid,origin='Email-ATR R&O Internal');
        insertCases.add(cases5);
        
        //to enter in to other mail box conditions
         Case cases6=new Case(ownerId=usr.Id,AccountId=acc.Id,Classification__c='CSO Repair/Overhaul',subject='Fax:{9986502495} test1 data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        No_FCR_Reason__c='Not Trained',Type='Order',recordtypeid=rcrdtypeid,origin='Email-BGA R&O Internal');
        insertCases.add(cases6);*/
        
        //to enter in to other mail box conditions
         Case cases7=new Case(AccountId=acc.Id,Classification__c='CSO Repair/Overhaul',subject='Fax:{9986502495} test1 data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',recordtypeid=label.Repair_Overhaul_RT_ID,origin='Email-R&O Canada',Status='Open',HON_Commit_Date__c=dt);
        insertCases.add(cases7);
        
        system.debug('Profile system running is'+userinfo.getprofileid());
        
        //system.runas(usr)
        //{
        try{
        insert insertCases;
        }catch(DMLException eee){}
        //}       
            
        Agent_Contact_Mapping__c objAgentConMap=[select CSR__c,id from Agent_Contact_Mapping__c where id=:agenconmap.Id ];
        objAgentConMap.CSR__c=usr1.Id;
        update objAgentConMap;
        Test.stopTest();
        
    }

}