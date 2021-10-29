@isTest
public class UpdateSalesChannelTest{    
    static testMethod void testUpdateSalesChannel(){ 
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert acc;
        }
        
        Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='BGA';
        insert pf;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Tech_Sales__c ='AT';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01213000000AWudAAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Restricted_Opportunity_Name__c ='RANAQAA';
        insert opp;
        
        opp.Name = 'Test Opp 1'; 
        update opp;
    }
  }