@isTest(SeeAllData=true)
private class  UserChangeCheckWithCoOwnerTest{
    public static TestMethod void UserChangeCheckWithCoOwnerTest1(){
        List<user> userList = new List<user>();
        List<user> updateUserList = new List<user>();
        List<opportunity> oppList = new List<opportunity>();
        List<Opportunity_Sales_Team__c> insertOppTeamList = new List<Opportunity_Sales_Team__c>();
        
        test.startTest();
          Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='honeywellstandarduser@testorg.com');
       Account testAccount = new Account();
      System.runAs(u) {
        
        //Create Test data        
        testAccount.Name = 'Test Account';
        insert testAccount;
        }
        Profile pf1= [select id from Profile where name = 'ATR Sales'];  
            
        
        User testUser =new user(Functional_Role__c = 'Engineer',firstName='TestOppTeamRole',lastName='TestLN',CommunityNickname='Test01',Alias='TU01',TimeZoneSidKey='America/Los_Angeles',Email='test01@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,ProfileID=pf1.id,USername='Test01@test455.com',localesidkey='en_US'); 
        userList.add(testUser);
        
        User testUser2 =new user(Functional_Role__c = 'Developer',firstName='TestOppTeamRole2',lastName='TestLN2',CommunityNickname='Test02',Alias='TU02',TimeZoneSidKey='America/Los_Angeles',Email='test02@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,ProfileID=pf1.id,USername='Test02@test455.com',localesidkey='en_US'); 
        userList.add(testUser2);
        
        insert userList;
        
        
        oppList=  [select id from Opportunity where RecordType.id=:Label.AM_Catalog limit 2];
        Id oppTamATRID = [select id from RecordType where Name='ATR' and SobjectType='Opportunity_Sales_Team__c'].id;
        Opportunity_Sales_Team__c testOppTeam = new Opportunity_Sales_Team__c();
        testOppTeam.Opportunity__c = oppList[0].id;
        testOppTeam.User__c = userList[0].id;
        testOppTeam.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam);
        
        Opportunity_Sales_Team__c testOppTeam2 = new Opportunity_Sales_Team__c();
        testOppTeam2.Opportunity_Team_Role__c = 'Co-Owner';
        testOppTeam2.Opportunity__c = oppList[1].id;
        testOppTeam2.User__c = userList[1].id;
        testOppTeam2.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam2);
        
       
        
        insert insertOppTeamList;    
        testOppTeam2.User__c = userList[0].id;
        try{
        update testOppTeam2;
        }catch(Exception e){
            system.debug('Exception occured:'+e);
        }
    }
}