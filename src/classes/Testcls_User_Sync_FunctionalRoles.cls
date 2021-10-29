/*************************************************************************************************************
Name                 : Testcls_User_Sync_FunctionalRoles
Created By         : Latha Priya S
Company Name  : NTT Data
Project/SR         : SR#430239
Created Date      : 11 November 2013
Usages              : This   is a test Class for the trigger User_Sync_FunctionalRoles
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification
11 Nov 2013   1.0             NTTDATA         To send an email notification when a  D&S user is Activated
                                                              or Inactivated  for D&S Admins. 
**************************************************************************************************************/


// Created a test class for SR#430239

@isTest(SeeAllData=true)
Public class Testcls_User_Sync_FunctionalRoles
{
    /* static testMethod void Testcls_User_Sync_FunctionalRoles()
    { 
       test.starttest();  
      
      Profile pf1= [select id from Profile where name = 'D&S Sales eGreensheet Approver'];       
      Profile pf2= [select id from Profile where name = 'D&S Sales (Non US)'];  
      
      Map<String,DS_Sales_Profilelist__c> mapDSprofile = DS_Sales_Profilelist__c.getALL();
    
     //user usr1=new user(firstName='Test888',lastName='user888',CommunityNickname='Test888User888',Alias='Tu888',TimeZoneSidKey='America/Los_Angeles',Email='test888@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,Functional_Role__c='Business Analyst',ProfileID=pf1.id,USername='TEst455@test455.com',localesidkey='en_US');
     //insert usr1;
        
     user usr2=new user(firstName='Test555',lastName='user555',CommunityNickname='Test555User555',Alias='Tu555',TimeZoneSidKey='America/Los_Angeles',Email='testu555@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=false,ProfileID=pf2.id,Functional_Role__c='Contract Manager',USername='TEst555@test11.com',localesidkey='en_US',Primary_Manager_EID__c='E0938488',Primary_Manager_Name__c='Test magr');
     insert usr2;
       
     //usr1.IsActive=false;
     //Update usr1; 
     
     usr2.IsActive=true;
     usr2.Functional_Role__c='Business Manager';
     usr2.Primary_Manager_Name__c='Test magr12';
    
     Update usr2; 
        
     test.stoptest();
       
     }
    
    //SR#437524 - Test for updating the Opportunity Team Role for the Opportunity Teams 
    static testMethod void Testcls_User_Sync_FunctionalRoles2()
    { 
        List<user> userList = new List<user>();
        List<user> updateUserList = new List<user>();
        List<opportunity> oppList = new List<opportunity>();
        List<Opportunity_Sales_Team__c> insertOppTeamList = new List<Opportunity_Sales_Team__c>();
        
        test.startTest();
       
        
        
        Profile pf3= [select id from Profile where name = 'ATR Sales'];  
            
        
        User testUser =new user(firstName='TestOppTeamRole',lastName='TestLN',CommunityNickname='Test01',Alias='TU01',TimeZoneSidKey='America/Los_Angeles',Email='test01@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,ProfileID=pf3.id,USername='Test01@test455.com',localesidkey='en_US'); 
        userList.add(testUser);
        
        User testUser2 =new user(firstName='TestOppTeamRole2',lastName='TestLN2',CommunityNickname='Test02',Alias='TU02',TimeZoneSidKey='America/Los_Angeles',Email='test02@test.com',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',IsPortalSelfRegistered=true,IsActive=true,ProfileID=pf3.id,USername='Test02@test455.com',localesidkey='en_US'); 
        userList.add(testUser2);
        
        insert userList; */
        /*
        
        //Create Test data
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
        Campaign testCampaign = new Campaign();
        testCampaign.Name = 'Test Campaign';
        testCampaign.CampaignPrimarySBU__c = 'ATR';
        testCampaign.CampaignPrimaryCBTTier2__c = 'Airbus';
        testCampaign.CBT_Team__c = 'Airbus Companies';
        testCampaign.Status = 'Planned';
        testCampaign.Type = 'Competative';
        testCampaign.RMU__c = 'No';
        testCampaign.ExpectedRevenue = 33000000;
        testCampaign.Tech_Sales__c = 'Integrated Systems';
        testCampaign.Tech_Sales_Product_Area__c = 'CBM';
        testCampaign.StartDate = Date.newInstance(2014,2,1);
        
        insert testCampaign;
        
        Opportunity testAmCatalogOpp = new Opportunity();
        testAmCatalogOpp.Name = 'Test AM Catalog';
        testAmCatalogOpp.recordtypeid = Label.AM_Catalog;
        testAmCatalogOpp.SBU__c= 'ATR';
        testAmCatalogOpp.CBT_Tier_2__c = 'Airbus';
        testAmCatalogOpp.Revenue_Type__c = 'ENG';
        testAmCatalogOpp.Solution_Type__c = 'Exchnage';
        testAmCatalogOpp.CloseDate = Date.newInstance(2014,2,1);
        testAmCatalogOpp.Amount = 11110;
        testAmCatalogOpp.ATR_Proposal_Type__c = 'AGMT';
        testAmCatalogOpp.Description = 'Test';
        testAmCatalogOpp.StageName = 'Cultivate';
        testAmCatalogOpp.Status_Next_Steps__c = 'Test';
        testAmCatalogOpp.Campaign = testCampaign;
        testAmCatalogOpp.ATR_Review_Org__c = 'APU';
        testAmCatalogOpp.Account = testAccount;
        testAmCatalogOpp.Probability = 50;
        testAmCatalogOpp.ATR_Probability__c = 12;
        testAmCatalogOpp.IC_Scorecard_Opportunity__c = false;
        
        oppList.add(testAmCatalogOpp);
                
        Opportunity testAmCatalogOpp2 = new Opportunity();
        testAmCatalogOpp2.Name = 'Test AM Catalog';
        testAmCatalogOpp2.recordtypeid = Label.AM_Catalog;
        testAmCatalogOpp2.SBU__c= 'ATR';
        testAmCatalogOpp2.CBT_Tier_2__c = 'Airbus';
        testAmCatalogOpp2.Revenue_Type__c = 'ENG';
        testAmCatalogOpp2.Solution_Type__c = 'Exchnage';
        testAmCatalogOpp2.CloseDate = Date.newInstance(2014,2,1);
        testAmCatalogOpp2.Amount = 11110;
        testAmCatalogOpp2.ATR_Proposal_Type__c = 'AGMT';
        testAmCatalogOpp2.Description = 'Test';
        testAmCatalogOpp2.StageName = 'Cultivate';
        testAmCatalogOpp2.Status_Next_Steps__c = 'Test';
        testAmCatalogOpp2.Campaign = testCampaign;
        testAmCatalogOpp2.ATR_Review_Org__c = 'APU';
        testAmCatalogOpp2.Account = testAccount;
        testAmCatalogOpp2.Probability = 50;
        testAmCatalogOpp2.ATR_Probability__c = 12;
        testAmCatalogOpp2.IC_Scorecard_Opportunity__c = false;
        oppList.add(testAmCatalogOpp2);
        
        insert oppList; */
        
        /* oppList=  [select id from Opportunity where RecordType.id=:Label.AM_Catalog limit 2];
        Id oppTamATRID = [select id from RecordType where Name='ATR' and SobjectType='Opportunity_Sales_Team__c'].id;
        Opportunity_Sales_Team__c testOppTeam = new Opportunity_Sales_Team__c();
        testOppTeam.Opportunity__c = oppList[0].id;
        testOppTeam.User__c = userList[0].id;
        testOppTeam.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam);
        
        Opportunity_Sales_Team__c testOppTeam2 = new Opportunity_Sales_Team__c();
        testOppTeam2.Opportunity__c = oppList[1].id;
        testOppTeam2.User__c = userList[0].id;
        testOppTeam2.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam2);
        
        Opportunity_Sales_Team__c testOppTeam3 = new Opportunity_Sales_Team__c();
        testOppTeam3.Opportunity__c = oppList[0].id;
        testOppTeam3.User__c = userList[1].id;
        testOppTeam3.RecordTypeId = oppTamATRID;
        insertOppTeamList.add(testOppTeam3);
        
        insert insertOppTeamList;
        
        //Test the scenario
        system.assertEquals(null,[select Opportunity_Team_Role__c from Opportunity_Sales_Team__c where id =: insertOppTeamList[0].id].Opportunity_Team_Role__c);
        
        //Update the user with Functional Role
        userList[0].Functional_Role__c = 'Engineer';
        updateUserList.add(userList[0]);
        userList[1].Functional_Role__c = 'Developer';
        updateUserList.add(userList[1]);
        update updateUserList;
        test.stopTest();
        //Test the scenario
        system.assertEquals('Engineer',[select Opportunity_Team_Role__c from Opportunity_Sales_Team__c where id =: insertOppTeamList[0].id].Opportunity_Team_Role__c);
        system.assertEquals('Engineer',[select Opportunity_Team_Role__c from Opportunity_Sales_Team__c where id =: insertOppTeamList[1].id].Opportunity_Team_Role__c);
        system.assertEquals('Developer',[select Opportunity_Team_Role__c from Opportunity_Sales_Team__c where id =: insertOppTeamList[2].id].Opportunity_Team_Role__c);        
    }
  }  
} */
}