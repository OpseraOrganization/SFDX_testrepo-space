@isTest(SeeAllData=true)
public class OpportunityTeam_AvoidDuplicates_Test{
    public static TestMethod void OpportunityTeam_AvoidDuplicates_Test1(){    
        List<user> userList = new List<user>();
        List<opportunity> oppList = new List<opportunity>();
        List<Opportunity_Sales_Team__c> insertOppTeamList = new List<Opportunity_Sales_Team__c>();  
        test.startTest();       
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        Profile pf1= [select id from Profile where name = 'Sales ATR'];  
        User testUser =new user(Functional_Role__c = 'Engineer',firstName='TestOppTeamRole',lastName='TestLN',CommunityNickname='Test01',Alias='TU01',TimeZoneSidKey='America/Los_Angeles',Email='test01@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,ProfileID=pf1.id,USername='Test01@test455.com',localesidkey='en_US'); 
        userList.add(testUser);
        User testUser2 =new user(Functional_Role__c = 'Developer',firstName='TestOppTeamRole2',lastName='TestLN2',CommunityNickname='Test02',Alias='TU02',TimeZoneSidKey='America/Los_Angeles',Email='test02@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,ProfileID=pf1.id,USername='Test02@test455.com',localesidkey='en_US'); 
        userList.add(testUser2);
        insert userList;
        oppList=  [select id from Opportunity where RecordType.id=:Label.AM_Catalog limit 2];
        Id oppTamATRID = [select id from RecordType where Name='Record' and SobjectType='Opportunity_Sales_Team__c'].id;
        
        Opportunity_Sales_Team__c testOppTeam = new Opportunity_Sales_Team__c();
        testOppTeam.Opportunity__c = oppList[0].id;
        testOppTeam.User__c = userList[0].id;
        testOppTeam.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam);
        Opportunity_Sales_Team__c testOppTeam2 = new Opportunity_Sales_Team__c();
        testOppTeam2.Opportunity__c = oppList[1].id;
        testOppTeam2.User__c = userList[1].id;
        testOppTeam2.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam2);
        insert insertOppTeamList;
        system.assertEquals(Null,[select Opportunity_Team_Role__c from Opportunity_Sales_Team__c where id =: insertOppTeamList[0].id].Opportunity_Team_Role__c);
        system.assertEquals(Null,[select Opportunity_Team_Role__c from Opportunity_Sales_Team__c where id =: insertOppTeamList[1].id].Opportunity_Team_Role__c);
        insertOppTeamList[0].User__c = userList[1].id;
        insertOppTeamList[1].User__c = userList[0].id;             
        update insertOppTeamList;
        
        /*Opportunity_Sales_Team__c testOppTeam4 = new Opportunity_Sales_Team__c();
        testOppTeam4.Opportunity__c = oppList[1].id;
        testOppTeam4.User__c = userList[1].id;
        testOppTeam4.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam4);
        insert insertOppTeamList;
        system.assertEquals(Null,[select Opportunity_Team_Role__c from Opportunity_Sales_Team__c where id =: insertOppTeamList[0].id].Opportunity_Team_Role__c);
        system.assertEquals('C&PS',[select Opportunity_Team_Role__c from Opportunity_Sales_Team__c where id =: insertOppTeamList[1].id].Opportunity_Team_Role__c);
        insertOppTeamList[0].User__c = userList[1].id;
        insertOppTeamList[1].User__c = userList[0].id;             
        update insertOppTeamList;*/
        try{
         Opportunity_Sales_Team__c testOppTeam3 = new Opportunity_Sales_Team__c();
        testOppTeam3.Opportunity__c = oppList[1].id;        
        testOppTeam3.User__c = userList[1].id;
        testOppTeam3.RecordTypeId = oppTamATRID;        
            insert testOppTeam3;
            testOppTeam3.User__c = userList[0].id;
            update testOppTeam3;
            
        }
        catch(Exception e){
            System.Assert(e.getMessage().contains('This User is already an Opportunity Team Member'));
        }  
        try{
          Opportunity_Sales_Team__c testOppTeam5 = new Opportunity_Sales_Team__c();
            testOppTeam5.Opportunity__c = oppList[1].id; 
            testOppTeam5.User__c = userList[1].id;
            testOppTeam5.Opportunity_Team_Role__c = 'C&PS';
            testOppTeam5.RecordTypeId = oppTamATRID;
            insert testOppTeam5;
        }
        catch(Exception e){
            System.Assert(e.getMessage().contains('This User is already an Opportunity Team Member'));
        } 
       
        test.stopTest();
    }
    /*public static TestMethod void OpportunityTeam_AvoidDuplicates_Test1234(){
        List<user> userList = new List<user>();
        List<opportunity> oppList = new List<opportunity>();
        List<Opportunity_Sales_Team__c> insertOppTeamList = new List<Opportunity_Sales_Team__c>();        
        test.startTest();       
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        Profile pf1= [select id from Profile where name = 'Sales ATR'];  
        User testUser =new user(Functional_Role__c = 'Engineer',firstName='TestOppTeamRole',lastName='TestLN',CommunityNickname='Test01',Alias='TU01',TimeZoneSidKey='America/Los_Angeles',Email='test01@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,ProfileID=pf1.id,USername='Test01@test455.com',localesidkey='en_US'); 
        userList.add(testUser);
        User testUser2 =new user(Functional_Role__c = 'Developer',firstName='TestOppTeamRole2',lastName='TestLN2',CommunityNickname='Test02',Alias='TU02',TimeZoneSidKey='America/Los_Angeles',Email='test02@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,ProfileID=pf1.id,USername='Test02@test455.com',localesidkey='en_US'); 
        userList.add(testUser2);
        insert userList;
        oppList=  [select id from Opportunity where RecordType.id=:Label.AM_Catalog limit 2];
        Id oppTamATRID = [select id from RecordType where Name='Record' and SobjectType='Opportunity_Sales_Team__c'].id;
        Opportunity_Sales_Team__c testOppTeam = new Opportunity_Sales_Team__c();
        testOppTeam.Opportunity__c = oppList[0].id;
        testOppTeam.User__c = userList[0].id;
        testOppTeam.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam);
        Opportunity_Sales_Team__c testOppTeam2 = new Opportunity_Sales_Team__c();
        
    }   */ 
    public static TestMethod void OpportunityTeam_AvoidDuplicates_Test123(){
        List<opportunity> oppList = new List<opportunity>();
        List<Opportunity_Sales_Team__c> insertOppTeamList = new List<Opportunity_Sales_Team__c>();
        List<Contact> conList = new List<Contact>();
        test.startTest();       
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        Contact testContact = new contact();
        testContact.LastName = 'Test Contact';        
        testContact.Account = testAccount;        
        testContact.SBU_Contact__c = 'D&S';        
        testContact.CBT__c = 'DAA';        
        testContact.CBT_Team__c = 'CBMS';        
        testContact.Primary_Email_Address__c = 'test@hh.com';        
        testContact.Functional_Role__c = 'Sales';
        testContact.Phone_3__c = '12311111';
        conList.add(testContact);        
        insert conList;       
        oppList=  [select id from Opportunity where RecordType.id=:Label.AM_Catalog limit 2];
        System.debug('oppList :' +oppList);        
        Id oppTamATRID = [select id from RecordType where Name='Record' and SobjectType='Opportunity_Sales_Team__c'].id;
        Opportunity_Sales_Team__c testOppTeam = new Opportunity_Sales_Team__c();
        testOppTeam.Opportunity__c = oppList[0].id;
        testOppTeam.Contact__c = conList[0].id;
        testOppTeam.RecordTypeId = oppTamATRID;        
        insertOppTeamList.add(testOppTeam);
        Opportunity_Sales_Team__c testOppTeam2 = new Opportunity_Sales_Team__c();
        testOppTeam2.Opportunity__c = oppList[1].id;
        testOppTeam2.Contact__c = conList[0].id;
        testOppTeam2.RecordTypeId = oppTamATRID;        
        insertOppTeamList.add(testOppTeam2);                      
        insert insertOppTeamList;        
        try{
        Opportunity_Sales_Team__c testOppTeam3 = new Opportunity_Sales_Team__c();
        testOppTeam3.Opportunity__c = oppList[1].id;
        testOppTeam3.Contact__c = conList[0].id;
        testOppTeam3.RecordTypeId = oppTamATRID;        
        insert testOppTeam3;
        }
        catch(Exception e){
            System.Assert(e.getMessage().contains('This Contact is already an Opportunity Team Member with this Role'));
        }                
        } 
}