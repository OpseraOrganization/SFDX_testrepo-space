@isTest(SeeAllData=true)
public class OppAfterUpdateHelperClassTest{    
    static testMethod void TestOpptytocase()    
    { 
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        insert acc;
        
        Contact con= new Contact();
        con.FirstName = 'TestFirstName';
        con.LastName='TestLastName';
        con.Phone='9998883344';
        con.Email = 'Test@mailinator.com';
        insert con;
        
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
        
        
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        //opp.StageName= 'Prospecting';
        opp.StageName= 'Closed Cancelled';   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000bN7l';
        opp.dealer_account__c='0013000000bFxtr';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Record_Data_Owner__c = Con.id;       
        insert opp;
        
        AccountTeamMember actmember = new AccountTeamMember();
        actmember .AccountId = acc.ID;
        actmember .TeamMemberRole = 'Customer Service Manager';
        actmember .UserId = label.Steve_Ferensak_User_Id;
        insert actmember;
        
        Pricebook2 pbk1= new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1');
        insert pbk1;
        
        Product2 prd1= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 1');
        insert prd1;
        
        PricebookEntry stdpbe= new PriceBookEntry(Pricebook2Id=standardPb.id, Product2Id=prd1.id, UnitPrice=50);
        insert stdPbe;
        
        PricebookEntry pbe1= new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50,isActive=true);
        insert pbe1;
        test.startTest();
        Product_Line__c pl=new Product_Line__c(Name='Test');
        insert pl;
        
        Product_Line_Cross_Ref__c plcr=new Product_Line_Cross_Ref__c(Name='Test productlinecrossref', Product_Line__c=pl.id, Product_Line_Cross_Ref_Type__c='Product');
        insert plcr;
        
        Plant_Code_Master__c pcm= new Plant_Code_Master__c(Name='Test Plant Code', Plant_Name__c='Test', Public_Plant_Name__c='Test',City__c='Test',Country_Code__c='US', SAP_Plant_Code__c='Test1');
        insert pcm;
        
      //  OpportunityLineItem lineItem1= new OpportunityLineItem (OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
      //  insert lineItem1;
        
        opp.StageName='Closed Won';
   
        update opp;
        test.stopTest();
    }
 
 
   
    static testMethod void TestOpptyegreensheet()    
    { 
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Asia/Pacific Rim';
        acc.Sub_Region_Name__c = 'Japan';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        insert acc;
        
       
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
        
        
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting';   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000bN7l';
        opp.dealer_account__c='0013000000bFxtr';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.IC_Scorecard_Opportunity__c =false;
        opp.CBT_Tier_2__c='Airlines';
        insert opp;
        
       
        test.startTest();
        Workflow_details__c WFrec1= new Workflow_details__c();
        WFRec1.Opportunity_Description__c=opp.id;
        insert WFrec1;
        opp.SBU__c='D&S';
        opp.CBT_Tier_2__c='Airbus';
        update opp;
        
         opp.recordtypeid='01230000000bN7l';
        opp.SBU__c='BGA';
        opp.CBT_Tier_2__c='Business Aviation';
        update opp;
        
        opp.recordtypeid='01230000000ZQCM';
        opp.SBU__c='ATR';
        opp.CBT_Tier_2__c='Components Business';
        update opp;
        
        opp.CBT_Tier_2__c='Airlines';
        update opp;
                    
        test.stopTest();
    }
    
    static testMethod void TestOpptyegreensheet1()    
    { 
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airlines';
        acc.Region_Name__c = 'Europe/MiddleEast/Africa/India';
        acc.Sub_Region_Name__c = 'India';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Air Transport';
        insert acc;
        
       /* Contact con= new Contact();
        con.FirstName = 'TestFirstName';
        con.LastName='TestLastName';
        con.Phone='9998883344';
        con.Email = 'Test@mailinator.com';
        insert con;
        */
        Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='ATR';
        insert pf;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
        
        
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'Air Transport';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZQCM';//01230000000bN7l
        opp.dealer_account__c='0013000000bFvoD';
        opp.IC_Scorecard_Opportunity__c =false;
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        
        insert opp;
        
       
        test.startTest();
        Workflow_details__c WFrec1= new Workflow_details__c();
        WFRec1.Opportunity_Description__c=opp.id;
        insert WFrec1;
        opp.recordtypeid='01230000000bN7l';
        opp.SBU__c='BGA';
        opp.CBT_Tier_2__c='Business Aviation';
        
        update opp;
        
        test.stopTest();
    }
    
    static testMethod void TestOpptyegreensheet2()    
    { 
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'Airlines';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'test';
        insert acc;
        
       /* Contact con= new Contact();
        con.FirstName = 'TestFirstName';
        con.LastName='TestLastName';
        con.Phone='9998883344';
        con.Email = 'Test@mailinator.com';
        insert con;
        */
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
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid= label.OE_Complex;
        opp.dealer_account__c='0013000000bFxtr';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.IC_Scorecard_Opportunity__c =false;
        opp.CBT_Tier_2__c='Components Business';
        insert opp;
        user u = [select id from user where profile.name = 'developer administrator' and isactive = true limit 1];
       
        test.startTest();
        Workflow_details__c WFrec1= new Workflow_details__c();
        WFRec1.Opportunity_Description__c=opp.id;
        insert WFrec1;
        //opp.recordtypeid='01230000000ZQCM';
        //opp.SBU__c='ATR';
        opp.CBT_Tier_2__c='Airlines';
        opp.accountid='0013000000bFvoD';
        opp.ownerid = u.id;
        update opp;
        test.stopTest();
    }
    
   
    
         static testMethod void TestOpptytocase1()    
    { 
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        insert acc;
        
        /*Contact con= new Contact();
        con.FirstName = 'TestFirstName';
        con.LastName='TestLastName';
        con.Phone='9998883344';
        con.Email = 'Test@mailinator.com';
        insert con;*/
        
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
        
        
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        user u = [select id from user where profile.name = 'system administrator' and isactive = true limit 1];
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000bN7l';
        opp.dealer_account__c='0013000000bFxtr';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.BusinessContact__c = u.id;  
        opp.Engineer_Manager_Review_Date__c = system.today()-1;
        
        insert opp;
        
        AccountTeamMember actmember = new AccountTeamMember();
        actmember .AccountId = acc.ID;
        actmember .TeamMemberRole = 'Customer Service Manager';
        actmember .UserId = label.Steve_Ferensak_User_Id;
        insert actmember;
        
        
        Pricebook2 pbk1= new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1');
        insert pbk1;
        
        Product2 prd1= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 1');
        insert prd1;
        
        PricebookEntry stdpbe= new PriceBookEntry(Pricebook2Id=standardPb.id, Product2Id=prd1.id, UnitPrice=50);
        insert stdPbe;
        
        PricebookEntry pbe1= new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50,isActive=true);
        insert pbe1;
        
        Product_Line__c pl=new Product_Line__c(Name='Test');
        insert pl;
        
        Product_Line_Cross_Ref__c plcr=new Product_Line_Cross_Ref__c(Name='Test productlinecrossref', Product_Line__c=pl.id, Product_Line_Cross_Ref_Type__c='Product');
        insert plcr;
        
        Plant_Code_Master__c pcm= new Plant_Code_Master__c(Name='Test Plant Code', Plant_Name__c='Test', Public_Plant_Name__c='Test',City__c='Test',Country_Code__c='US', SAP_Plant_Code__c='Test1');
        insert pcm;
        
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
        //lineItem1 = [select id,OpportunityID from OpportunityLineItem where Opportunity.StageName !='Closed Won' limit 1];
        
        test.startTest();
        //opp = [select id from Opportunity where id=:lineItem1.OpportunityID limit 1];
        opp.StageName='Closed Won';
        opp.Engineer_Manager_Review_Date__c = system.today();  
        
        update opp;
        test.stopTest();
        
    }
    static testMethod void TestOpptytocaseClosedDate()    
    {
        Test.startTest();
        
        OpportunityLineItem oppLine = [select OpportunityID from OpportunityLineItem where ServiceDate<>null and Type__c = 'Forecast' limit 1];
        Opportunity opp = [select id,CloseDate from Opportunity where CloseDate<>null and id =:oppLine.OpportunityID];
        opp.CloseDate = opp.CloseDate+1;
        opp.Push_Product_Date__c = true;
        update opp;
        
        Test.stopTest();
    }
    
    static testMethod void updateATRPGO()    
    {
        Test.startTest();
        
        OpportunityLineItem oppLine = [select OpportunityID from OpportunityLineItem where ServiceDate<>null and Type__c = 'Forecast' limit 1];
        Opportunity opp = [select id,CloseDate from Opportunity where CloseDate<>null and id =:oppLine.OpportunityID];
        opp.CloseDate = opp.CloseDate+1;
        opp.Push_Product_Date__c = true;
        opp.ATR_Probability__c = 10;
        opp.Program_Go_Probability__c = 10;
        update opp;
        
        Test.stopTest();
    }
    
    
    static  testMethod void TestOpptyegreensheet3()    
    { 
        try{
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airlines';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'test';
        insert acc;
        
       /* Contact con= new Contact();
        con.FirstName = 'TestFirstName';
        con.LastName='TestLastName';
        con.Phone='9998883344';
        con.Email = 'Test@mailinator.com';
        insert con;
        */
        Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Test';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='ATR';
        insert pf;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
        
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid=label.AM_Catalog;
        opp.IC_Scorecard_Opportunity__c =false;
        opp.dealer_account__c='0013000000bFxtr';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        insert opp;
        
       
        test.startTest();
        Workflow_details__c WFrec1= new Workflow_details__c();
        WFRec1.Opportunity_Description__c=opp.id;
        insert WFrec1;
        
        Opportunity_Gate__c opg = new Opportunity_Gate__c();
        opg.name = 'Solicitation Review';
        opg.Opportunity__c = opp.id;
        insert opg;
        
        opp.recordtypeid='01230000000ZIv6'; //d&s standard
        opp.SBU__c='D&S';
        opp.RFP_Receipt_Date__c  = system.today();
        opp.RFP_Expected_Date__c  = system.today();
        update opp;
        
        
        test.stopTest();
        }catch(Exception e){
            system.debug('Exception at TestOpptyegreensheet3:'+e.getMessage());
        }
    }

    
    
}