@isTest
public class aircraftOppOLIControllerTest{
    public static testmethod void testmethod1(){
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

    Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='BGA';
        pf.OEM_Name__c = acc.Id;
        insert pf;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
    
    Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CBT_Team_Tier_3__c = 'APAC BGA';
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        //opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000bN7l';
       // opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;        
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'BGA';
        opp.Package_Product__c = 'Test PP';
        insert opp;
        
        Opportunity_Sales_Team__c ost = new Opportunity_Sales_Team__c();
        ost.Opportunity__c = opp.Id;
        ost.User__c = [Select Id,IsActive from User where IsActive=true limit 1].Id;
        insert ost;
                
        //Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
        Pricebook2 pbk1= new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1');
        insert pbk1;
        
        Product2 prd1= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 1');
        insert prd1;
        Product2 prd2= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 2');
        insert prd2;
        Product2 prd3= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 3');
        insert prd3;
        Product2 prd4 = new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 4');
        insert prd4;
        Product2 prd5 = new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 5');
        insert prd5;
        
        PricebookEntry stdpbe= new PriceBookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=prd1.id, UnitPrice=50);
        insert stdPbe;
        
        PricebookEntry pbe1= new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50,isActive=true);
        insert pbe1;
        
        Product_Line__c pl=new Product_Line__c(Name='Test');
        insert pl;
        
        Product_Line_Cross_Ref__c plcr=new Product_Line_Cross_Ref__c(Name='Test productlinecrossref', Product_Line__c=pl.id, Product_Line_Cross_Ref_Type__c='Product');
        insert plcr;
        
        Plant_Code_Master__c pcm= new Plant_Code_Master__c(Name='Test Plant Code', Plant_Name__c='Test', Public_Plant_Name__c='Test',City__c='Test',Country_Code__c='US', SAP_Plant_Code__c='Test1');
        insert pcm;
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Product2Id = prd1.Id, Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,PriceBookEntryID=pbe1.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
        //OpportunityLineItem lineItem2= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Product2Id = prd2.Id, Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,PriceBookEntryID=pbe1.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        //insert lineItem2;
        //OpportunityLineItem lineItem3= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Product2Id = prd3.Id, Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,PriceBookEntryID=pbe1.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        //insert lineItem3;
        //OpportunityLineItem lineItem4= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Product2Id = prd4.Id, Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,PriceBookEntryID=pbe1.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        //insert lineItem4;
        //OpportunityLineItem lineItem5= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Product2Id = prd5.Id, Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,PriceBookEntryID=pbe1.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        //insert lineItem5;
        
        Packaged_Products__c pprod = new Packaged_Products__c();
           pprod.Name = 'Test PP';
           pprod.Product_1__c = prd1.Id;
           pprod.Product_2__c = prd2.Id;
           pprod.Product_3__c = prd3.Id;
           pprod.Product_4__c = prd4.Id;
           pprod.Product_5__c = prd5.Id;
           pprod.CBT_Team1__c = 'APAC BGA';
           pprod.Aircraft_Platform__c = pf.Id;
        insert pprod;            
        
        Test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id', opp.Id);
        //PageReference pageRef = Page.showAircraftProduct;      
        //Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        aircraftOppOLIController testopp = new aircraftOppOLIController(sc);        
        testopp.updtevale();
        
        Test.StopTest();
   }
   public static testmethod void testmethod2(){
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

    Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='ATR';
        pf.OEM_Name__c = acc.Id;
        insert pf;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
    
    Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CBT_Team_Tier_3__c = 'APAC BGA';
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        //opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000bN7l';
        //opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;        
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'BGA';
        opp.Package_Product__c = 'Test PP';
        insert opp;
        
        Opportunity_Sales_Team__c ost = new Opportunity_Sales_Team__c();
        ost.Opportunity__c = opp.Id;
        ost.User__c = [Select Id,IsActive from User where IsActive=true limit 1].Id;
        insert ost;
        
        Pricebook2 pbk1= new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1');
        insert pbk1;
        
        Product2 prd1= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 1');
        insert prd1;
        Product2 prd2= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 2');
        insert prd2;
        Product2 prd3= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 3');
        insert prd3;
        Product2 prd4 = new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 4');
        insert prd4;
        Product2 prd5 = new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 5');
        insert prd5;
        
        PricebookEntry stdpbe= new PriceBookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=prd1.id, UnitPrice=50);
        insert stdPbe;
        
        PricebookEntry pbe1= new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50,isActive=true);
        insert pbe1;
        
        Product_Line__c pl=new Product_Line__c(Name='Test');
        insert pl;
        
        Product_Line_Cross_Ref__c plcr=new Product_Line_Cross_Ref__c(Name='Test productlinecrossref', Product_Line__c=pl.id, Product_Line_Cross_Ref_Type__c='Product');
        insert plcr;
        
        Plant_Code_Master__c pcm= new Plant_Code_Master__c(Name='Test Plant Code', Plant_Name__c='Test', Public_Plant_Name__c='Test',City__c='Test',Country_Code__c='US', SAP_Plant_Code__c='Test1');
        insert pcm;
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Product2Id = prd1.Id, Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,PriceBookEntryID=pbe1.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
        
        Packaged_Products__c pprod = new Packaged_Products__c();
           pprod.Name = 'Test PP';
           pprod.Product_1__c = prd1.Id;
           pprod.Product_2__c = prd2.Id;
           pprod.Product_3__c = prd3.Id;
           pprod.Product_4__c = prd4.Id;
           pprod.Product_5__c = prd5.Id;
           pprod.CBT_Team1__c = 'APAC BGA';
           pprod.Aircraft_Platform__c = pf.Id;
        insert pprod;            
        
        Test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id', opp.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        aircraftOppOLIController testopp = new aircraftOppOLIController(sc);        
        testopp.updtevale();
        
        Test.StopTest();
   }
   public static testmethod void testmethod3(){
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

    Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='ATR';
        pf.OEM_Name__c = acc.Id;
        insert pf;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
    
    Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CBT_Team_Tier_3__c = 'APAC BGA';
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        //opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000bN7l';
       // opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;        
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'BGA';
        opp.Package_Product__c = 'Test PP';
        insert opp;
        
        Opportunity_Sales_Team__c ost = new Opportunity_Sales_Team__c();
        ost.Opportunity__c = opp.Id;
        ost.User__c = [Select Id,IsActive from User where IsActive=true limit 1].Id;
        insert ost;
        
        Pricebook2 pbk1= new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1');
        insert pbk1;
        
        Product2 prd1= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 1');
        insert prd1;
        Product2 prd2= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 2');
        insert prd2;
        Product2 prd3= new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 3');
        insert prd3;
        Product2 prd4 = new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 4');
        insert prd4;
        Product2 prd5 = new Product2 (Name='Easy II Baseline (HW/SW)',Description='Test Product Entry 5');
        insert prd5;
        
        PricebookEntry stdpbe= new PriceBookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id=prd1.id, UnitPrice=50);
        insert stdPbe;
        
        PricebookEntry pbe1= new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=pbk1.id,UnitPrice=50,isActive=true);
        insert pbe1;
        
        Product_Line__c pl=new Product_Line__c(Name='Test');
        insert pl;
        
        Product_Line_Cross_Ref__c plcr=new Product_Line_Cross_Ref__c(Name='Test productlinecrossref', Product_Line__c=pl.id, Product_Line_Cross_Ref_Type__c='Product');
        insert plcr;
        
        Plant_Code_Master__c pcm= new Plant_Code_Master__c(Name='Test Plant Code', Plant_Name__c='Test', Public_Plant_Name__c='Test',City__c='Test',Country_Code__c='US', SAP_Plant_Code__c='Test1');
        insert pcm;
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Product2Id = prd1.Id, Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,PriceBookEntryID=pbe1.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
        
        Packaged_Products__c pprod = new Packaged_Products__c();
           pprod.Name = 'Test PP';
           pprod.Product_1__c = prd1.Id;
           pprod.Product_2__c = prd2.Id;
           pprod.Product_3__c = prd3.Id;
           pprod.Product_4__c = prd4.Id;
           pprod.Product_5__c = prd5.Id;
           pprod.CBT_Team1__c = 'ATR Airlines Asia Pacific';
           pprod.Aircraft_Platform__c = pf.Id;
        insert pprod;            
            pprod.CBT_Team1__c = 'APAC BGA';
        update pprod;
        Test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id', opp.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        aircraftOppOLIController testopp = new aircraftOppOLIController(sc);        
        testopp.updtevale();
        
        Test.StopTest();
   }
}