@isTest(SeeAllData=true)
public class OppBeforeUpdateHelperClassTest
{    
    static Account acc;
    static Planned_Meeting__c pm;
    static Fleet_Asset_Detail__c fleet;
    static   Platform__c pf;
    static Plant_Code_Master__c pcm;
    static Plant_Code_del__c pcd;
    
    public static void insertTestData()
    { 
        acc = new Account();
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
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert acc;
        }
        
        pm = new Planned_Meeting__c();
        pm.RecordTypeid ='01230000000ZIuUAAW';
        insert pm;
        
        pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='BGA';
        insert pf;
        
        fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
        
           
        pcm = new Plant_Code_Master__c();
        pcm.Postal_Code__c='Test Code';
        pcm.Plant_Name__c='Test Name';
        pcm.Public_Plant_Name__c='Test Public Name';
        pcm.City__c='KA';
        pcm.Country_Code__c='IN';
        pcm.SAP_Plant_Code__c='124421';
        insert pcm;
        
          pcd = new Plant_Code_del__c();
        pcd.Name='Test PCD';
        pcd.Plant_Code_Master__c=pcm.Id;
        pcd.SBU__c='ATR';
        pcd.Backup_Account_Opener__c=Userinfo.getUserId();
        pcd.Primary_Account_Opener__c=Userinfo.getUserId();
        insert pcd;
     
    }
 
    
    static testMethod void testOppBeforeUpdateHelperClass()
    {    
        insertTestData();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01213000000AWudAAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        insert opp;      
                
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
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
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
       
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.Is_Restricted_Opportunity__c = true;
            opp.Planned_Meeting__c = pm.id;
            opp.Is_Follow_On_Opportunity__c = true;
            opp.Revenue_Type__c = 'Retrofit';
            opp.Solution_Type__c = 'HAT';
            update opp;
        Test.stopTest();
    }
    
    static testMethod void testOppBeforeUpdateHelperClass1()
    {    
        insertTestData();
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
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
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Propose' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01213000000AWudAAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        insert opp;    
        
        Opportunity opp1 = new opportunity();
        opp1.Name= 'Test Oppty 1';
        opp1.CloseDate=system.today();
        opp1.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp1.AccountId= acc.id;
        opp1.StageName= 'Cultivate' ;   
        opp1.Type= 'BGA Aftermarket';
        opp1.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp1.Sales_Type__c='Retrofit';
        opp1.Aircraft_Ref__c=fleet.id;
        opp1.recordtypeid= label.AM_Catalog;
        opp1.dealer_account__c='0013000000bFxtr';
        opp1.ATR_Probability__c = 90;
        opp1.Is_Restricted_Opportunity__c = false;
        opp1.Is_Follow_On_Opportunity__c = false;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        opp1.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp1.Revenue_Type__c = 'ENG';
        opp1.Solution_Type__c = 'Direct Sales';
        opp1.Parent_Opportunity__c = opp.Id;
        opp1.SBU__c = 'D&S';
        opp1.Type_of_Opportunity__c = 'Spares – LRUs';
        opp1.Lead_Number__c = '12345';
        insert opp1; 
       
        Test.startTest();
          
            OpportunityLineItem lineItem2= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',Solution_Type__c = 'Other',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
            insert lineItem2;
                    
            opp1.Name= 'Test Oppty1';
            opp1.ATR_Probability__c = 98;
            opp1.Is_Restricted_Opportunity__c = true;
            opp1.Planned_Meeting__c = pm.id;
            opp1.Is_Follow_On_Opportunity__c = true;
            opp1.Revenue_Type__c = 'Retrofit';
             opp.Restricted_Opportunity_Name__c =null;
            update opp1;
        Test.stopTest();
    }

    static testMethod void OppBeforeUpdateTest()
    {
        insertTestData();
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.RFP_Expected_Date__c = Date.today();
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';        
        oppList.add(opp);   
        insert oppList;
       
        
        Test.startTest();
        
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            update opp;
        Test.stopTest();
    }
    
    
    static testMethod void OppBeforeUpdateTest1()
    {
        insertTestData();
        List<Opportunity> oppList = new List<Opportunity>();
               
       Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
         opp.StageName= 'Cultivate' ;  
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.RFP_Expected_Date__c = Date.today();
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';        
        oppList.add(opp);       
        insert oppList;
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.StageName= 'Offer/Negotiate/Close' ;   
            update opp;
        Test.stopTest();
    }
    
    static testMethod void OppBeforeUpdateTest2()
    {
        insertTestData();
        List<Opportunity> oppList = new List<Opportunity>();
               
       Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
         opp.StageName= 'Cultivate' ;  
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = true;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.RFP_Expected_Date__c = Date.today();
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';        
        oppList.add(opp);       
        insert oppList;
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98; 
            opp.Is_Restricted_Opportunity__c = true; 
            opp.Is_Follow_On_Opportunity__c = false;
            update opp;
        Test.stopTest();
    }

 static testMethod void testOppBeforeUpdateHelperClassMethod()
 {
        Account acc = new Account();
        acc.Ownerid= '005300000041ohb' ;
        acc.Name = 'Honeywell';
        acc.Customer_Status__c = 'Active';
        acc.CBT__c = 'Intercompany';
        acc.Region_Name__c = 'Asia/Pacific Rim';
        acc.Sub_Region_Name__c = 'China / HKG';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        Acc.Strategic_Business_Unit__c = 'D&S';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell Boyun Aero Systems Hunan Co Ltd';
        Profile ProfRec = [select name,id from Profile where name = 'System Administrator' limit 1];
        User userRec = [select id from user where ProfileId = :ProfRec.Id and isActive=true limit 1];
        system.runas(userRec)
        {
            insert acc;
        }
        Contact con= new Contact();
        con.FirstName = 'TestFirstName';
        con.LastName='TestLastName';
        con.Phone='9998883344';
        con.Email = 'Test@mailinator.com';
        insert con;
         Test.startTest();
        Id rtType = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('M&PM SIM Licensing').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity';
        opp1.SBU__c = 'ATR';
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.RecordTypeid = rtType;
        opp1.CreatedByid = '0051300000BbHC4';
        opp1.License_Draft__c= system.today();
        opp1.BusinessContact__c = '0051300000BbHC4';
        opp1.Engineer_Manager_Review_Date__c = system.today();
        opp1.StageName = 'Phase 2: Detailed Negotiation';   
        opp1.LicenseDraft__c = false;
        opp1.Record_Data_Owner__c = con.id;
        opp1.Final_Review__c =False;
        opp1.Engineer_Manager_Review__c = False;                  
        opp1.WorkbookComplete__c = False;
        opp1.Account_manager_review__c = False;
        opp1.Revenue_Recognized__c = False;
        opp1.InvoiceRequested__c = False;
        opp1.Workstop_Issue_Cleared__c = False;
        opp1.HIPI_CONTRACT_NUMBER__c ='HipiTest88899';
        opp1.CloseDate=system.today();
        insert opp1;
        
        opp1.LicenseDraft__c = true;       
        update opp1;
         Test.stopTest();
 }
 
 
 static testMethod void testOppBeforeUpdateHelperClassMethod1()
 {
       insertTestData();
       Id rtType = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('M&PM SIM Licensing').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity';
        opp1.SBU__c = 'ATR';
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.RecordTypeid = rtType;
        opp1.CreatedByid = '0051300000BbHC4';
        opp1.License_Draft__c= system.today();
        opp1.BusinessContact__c = '0051300000BbHC4';
        opp1.Engineer_Manager_Review_Date__c = system.today();
        opp1.StageName = 'Phase 2: Detailed Negotiation';   
        opp1.LicenseDraft__c = false;
        opp1.Final_Review__c =False;
        opp1.Engineer_Manager_Review__c = False;                  
        opp1.WorkbookComplete__c = False;
        opp1.Account_manager_review__c = False;
        opp1.Revenue_Recognized__c = False;
        opp1.InvoiceRequested__c = False;
        opp1.Workstop_Issue_Cleared__c = False;
        opp1.HIPI_CONTRACT_NUMBER__c ='HipiTest88899';
        opp1.Is_Restricted_Opportunity__c = true;
        opp1.Is_Follow_On_Opportunity__c = false;
        opp1.CloseDate=system.today();
        insert opp1;
        
        Test.startTest();   
         opp1.Is_Restricted_Opportunity__c = false;
         opp1.Is_Follow_On_Opportunity__c= true;
         update opp1;
         Test.stopTest();
 }   
 
 static testMethod void testOppBeforeUpdateHelperClassMethod2()
 {
       insertTestData();
       Id rtType = Schema.SObjectType.Opportunity.getRecordTypeInfosbyName().get('M&PM SIM Licensing').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity';
        opp1.SBU__c = 'ATR';
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.RecordTypeid = rtType;
        opp1.CreatedByid = '0051300000BbHC4';
        opp1.License_Draft__c= system.today();
        opp1.BusinessContact__c = '0051300000BbHC4';
        opp1.Engineer_Manager_Review_Date__c = system.today();
        opp1.StageName = 'Phase 2: Detailed Negotiation';   
        opp1.LicenseDraft__c = false;
        opp1.Final_Review__c =False;
        opp1.Engineer_Manager_Review__c = False;                  
        opp1.WorkbookComplete__c = False;
        opp1.Account_manager_review__c = False;
        opp1.Revenue_Recognized__c = False;
        opp1.InvoiceRequested__c = False;
        opp1.Workstop_Issue_Cleared__c = False;
        opp1.HIPI_CONTRACT_NUMBER__c ='HipiTest88899';
        opp1.Is_Restricted_Opportunity__c = true;
        opp1.Is_Follow_On_Opportunity__c = true;
        opp1.CloseDate=system.today();
        insert opp1;
        
        Test.startTest();   
         opp1.Is_Restricted_Opportunity__c = false;
         opp1.Is_Follow_On_Opportunity__c= false;
         update opp1;
         Test.stopTest();
 }   
 
static testMethod void testOppBeforeUpdateHelperClassMethod3()
    {
        insertTestData();
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        //opp.RFP_Request_Date__c = Date.Today();
        opp.RFP_Expected_Date__c = Date.today();
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason'; 
        //opp.Revenue_End_Date__c=date.today();       
        oppList.add(opp);   
        insert oppList;
       
        
        Test.startTest();
        
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.RFP_Request_Date__c = Date.Today() + 10;
            update opp;
        Test.stopTest();
    }
    
 
 static testMethod void testOppBeforeUpdateHelperClassMethod4()
 {
       insertTestData();
        Opportunity opp = new opportunity();
        opp.Name= 'Test Oppty 1';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid= label.AM_Catalog;
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        opp.Type_of_Opportunity__c = 'Spares – LRUs';
        opp.Lead_Number__c = '12345';
        opp.Sales_Channel__c = 'Aerospace';
        insert opp; 
        
        Opportunity opp1 = new opportunity();
        opp1.Name= 'Test Oppty 1';
        opp1.CloseDate=system.today();
        opp1.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp1.AccountId= acc.id;
        opp1.StageName= 'Cultivate' ;   
        opp1.Type= 'BGA Aftermarket';
        opp1.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp1.Sales_Type__c='Retrofit';
        opp1.Aircraft_Ref__c=fleet.id;
        opp1.recordtypeid= label.AM_Catalog;
        opp1.Sales_Channel__c = 'Aerospace';
        opp1.dealer_account__c='0013000000bFxtr';
        opp1.ATR_Probability__c = 90;
        opp1.Is_Restricted_Opportunity__c = false;
        opp1.Is_Follow_On_Opportunity__c = false;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        opp1.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp1.Revenue_Type__c = 'ENG';
        opp1.Solution_Type__c = 'Direct Sales';
        opp1.Parent_Opportunity__c = opp.Id;
        opp1.SBU__c = 'D&S';
        opp1.Type_of_Opportunity__c = 'Spares – LRUs';
        opp1.Lead_Number__c = '12345';
        insert opp1; 
            
       Test.startTest();         
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.UnitPrice = 100;
            oli.Quantity = 2;
            oli.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            oli.OpportunityId = opp.Id;
            oli.Type__c = 'Booked';
            oli.Solution_Type__c ='Other';
            oli.Revenue_Type__c = 'License';
            oli.Revenue_Start_Date__c = Date.Today();
            oli.Revenue_End_Date__c = Date.Today() + 1;
            oli.Plant__c=pcm.id;
            insert oli;
                  
             opp1.Name = 'Test';
             TriggerInactive.testTrigger = false;
             TriggerInactive.TestCaseCancelled = false;
             TriggerInactive.TestCSMCaseCreation = false;
             TriggerInactive.TestOppRequiredFields = false;
             TriggerInactive.TestOppUpdate_UpdateStage = false;
             TriggerInactive.TestCasValUpdtBasOnOwner = false;
             TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
             TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
             TriggerInactive.TestOpportunity_InsertPhases = false;
            update opp1;
                 
          Test.stopTest();
  }
  
  static testmethod void DLITestMethod1(){
       insertTestData();
        
       test.startTest();
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.RFP_Expected_Date__c = Date.today();
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';        
        insert opp;
        Test.stopTest();
        
        Discretionary__c dc = new Discretionary__c();
        dc.Fiscal_Year__c='2014';
        dc.Opportunity__c=opp.id;
        dc.M_PM_Funded_VOC_Project__c='NO';
        dc.SBU__c='ATR';
        dc.CBT__c='Airbus';
        dc.CBT_Team__c='PPG';
        dc.Type__c='Demo';
        dc.Estimated_Completion_Date__c=system.today();
        //insert dc;
    
        
        
         
          Discretionary_Line_Item__c dli = new Discretionary_Line_Item__c();
        dli.Discretionary_Request__c=dc.Id;
        dli.Plant_Code_Master__c=pcm.Id;
        dli.Cost_Type__c='Travel';
        dli.Plant_Code__c=pcd.Id;
        //insert dli;
        
                       
        
             opp.Name = 'Test';
             opp.RFP_Request_Date__c  = Date.Today() + 10;
             update opp;
         
      }
      
    
    
     static testmethod void DLITestMethod2(){
       insertTestData();  
      Opportunity opp5 = new Opportunity();
        opp5.Name = 'Test Method Opportunity';
        opp5.SBU__c = 'D&S';
        opp5.CBT_Tier_2__c = 'DAA';
        opp5.CBT_Team_Tier_3__c = 'CBMS';
        opp5.AccountId = acc.Id;
        opp5.End_User__c = acc.Id;
        opp5.Tech_Sales_Product_Area__c = 'APU';
        opp5.Tech_Sales__c = 'AT';
        opp5.Prime_Sub__c = 'Prime';
        opp5.opportunity_Type__c = 'D&S Complex';
        opp5.StageName = 'Offer/Negotiate/Close';
        opp5.RecordtypeId=label.D_S_Complex;
        opp5.CloseDate = System.today();
        opp5.Revenue_Type__c = 'ENG';
        opp5.Bid_Type_Name__c = 'LTA';
        opp5.International_Code__c = 'FMS';
        opp5.Incumbent__c = 'Incumbent';
        opp5.RMU__c = 'YES';
        opp5.Platform__c = pf.Id; 
        opp5.Active__c = TRUE;
        opp5.Certification_Requirements__c = 'FAR 15 Tina';
        opp5.Proposal_Complexity__c ='Pre-work initiated';
        opp5.Ship_Set_Delivery_Period__c= 'test';
        opp5.Ship_Set_Quantity__c = 1;
        opp5.Ship_Set_Parts__c ='1234';
        opp5.RFP_Expected_Date__c =System.today(); 
        triggerinactive.TestOppUpdate_UpdateStage = false;
        insert opp5;
        
       
        Test.startTest();
        try
        {
            opp5.Name = ' test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
             TriggerInactive.testTrigger = false;
             TriggerInactive.TestCaseCancelled = false;
             TriggerInactive.TestCSMCaseCreation = false;
             TriggerInactive.TestOppRequiredFields = false;
             TriggerInactive.TestOppUpdate_UpdateStage = false;
             TriggerInactive.TestCasValUpdtBasOnOwner = false;
             TriggerInactive.TestATROpp_ContentDeliveries_Automation = false;
             TriggerInactive.TestOpportunityProduct_UpdateTechSales = false;
             TriggerInactive.TestOpportunity_InsertPhases = false;
         }
         catch(Exception e)
         {
            update opp5;
            }
        Test.stopTest();
 }
 
  static testMethod void testOppBeforeUpdateHelperClassMethod10()
 {
       insertTestData();
        Opportunity opp = new opportunity();
        opp.Name= 'Test Oppty 1';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid= label.AM_Catalog;
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        opp.Type_of_Opportunity__c = 'Spares – LRUs';
        opp.Lead_Number__c = '12345';
        opp.Sales_Channel__c = 'Aerospace';
        insert opp; 
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.UnitPrice = 100;
        oli.Quantity = 2;
        oli.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
        oli.OpportunityId = opp.Id;
        oli.Type__c = 'Booked';
        oli.Solution_Type__c ='Other';
        oli.Revenue_Type__c = 'License';
        oli.Revenue_Start_Date__c = Date.Today();
        oli.Revenue_End_Date__c = Date.Today() + 1;
        oli.Plant__c=pcm.id;
        insert oli;
    }
    
   
    
    static testMethod void testOppBeforeUpdateHelperClassMethod12()
    {    
        insertTestData();
        Opportunity opp = new opportunity();
        opp.Name= 'Test Oppty 1';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid= label.AM_Catalog;
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        opp.Type_of_Opportunity__c = 'Spares – LRUs';
        opp.Lead_Number__c = '12345';
        opp.Sales_Channel__c = 'Aerospace';
        insert opp; 
        
        
        OpportunityLineItem oli1 = new OpportunityLineItem();
        oli1.UnitPrice = 100;
        oli1.Quantity = 2;
        oli1.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
        oli1.OpportunityId = opp.Id;
        oli1.Type__c = 'Booked';
        oli1.Solution_Type__c ='BFE / SSFE';
        oli1.Revenue_Type__c = 'License';
        oli1.Revenue_Start_Date__c = Date.Today();
        oli1.Revenue_End_Date__c = Date.Today() + 1;
        oli1.Plant__c=pcm.id;
        insert oli1;
   }
   
   static testMethod void testOppBeforeUpdateHelperClassMethod13()
   {     
        
        insertTestData();
        Opportunity opp = new opportunity();
        opp.Name= 'Test Oppty 1';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid= label.AM_Catalog;
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        opp.Type_of_Opportunity__c = 'Spares – LRUs';
        opp.Lead_Number__c = '12345';
        opp.Sales_Channel__c = 'Aerospace';
        insert opp; 
        
        
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.UnitPrice = 100;
        oli2.Quantity = 2;
        oli2.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
        oli2.OpportunityId = opp.Id;
        oli2.Type__c = 'Booked';
        oli2.Solution_Type__c ='Direct Sales';
        oli2.Revenue_Type__c = 'License';
        oli2.Revenue_Start_Date__c = Date.Today();
        oli2.Revenue_End_Date__c = Date.Today() + 1;
        oli2.Plant__c=pcm.id;
        insert oli2;
        
        Test.startTest();
        opp.Name = 'Test';
        update opp;
        Test.stopTest();
 }
        static testMethod void testOppBeforeUpdateHelperClassMethod14()
   {     
        
        insertTestData();
        Opportunity opp = new opportunity();
        opp.Name= 'Test Oppty 1';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid= label.AM_Catalog;
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        opp.Type_of_Opportunity__c = 'Spares – LRUs';
        opp.Lead_Number__c = '12345';
        opp.Sales_Channel__c = 'Aerospace';
        opp.Parent_Opportunity_Sales_Channel__c = 'Americas AM';
        opp.Parent_Opportunity_SBU__c = 'D&S';
        opp.Certification_Requirements__c='FAR 15 Tina';
        insert opp; 
        
        
        OpportunityLineItem oli2 = new OpportunityLineItem();
        oli2.UnitPrice = 100;
        oli2.Quantity = 2;
        oli2.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
        oli2.OpportunityId = opp.Id;
        oli2.Type__c = 'Booked';
        oli2.Solution_Type__c ='Direct Sales';
        oli2.Revenue_Type__c = 'License';
        oli2.Revenue_Start_Date__c = Date.Today();
        oli2.Revenue_End_Date__c = Date.Today() + 1;
        oli2.Plant__c=pcm.id;
        insert oli2;
        
        Test.startTest();
        opp.Name = 'Test';        
        Apexpages.currentPage().getparameters().put('id',opp.id);
         update opp;
        Test.stopTest();
 }
  static testMethod void testOppBeforeUpdateHelperClass0()
    {    
        insertTestData();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6AAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        insert opp;      
                
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
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
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
       
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.Is_Restricted_Opportunity__c = true;
            opp.Planned_Meeting__c = pm.id;
            opp.Is_Follow_On_Opportunity__c = true;
            opp.Revenue_Type__c = 'Retrofit';
            opp.Solution_Type__c = 'HAT';
            update opp;
        Test.stopTest();
    }
    
    static testMethod void testOppBeforeUpdateHelperClass11()
    {    
        insertTestData();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6AAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Ti';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        insert opp;      
                
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
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
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
       
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.Is_Restricted_Opportunity__c = true;
            opp.Planned_Meeting__c = pm.id;
            opp.Is_Follow_On_Opportunity__c = true;
            opp.Revenue_Type__c = 'Retrofit';
            opp.Solution_Type__c = 'HAT';
            update opp;
        Test.stopTest();
    }

    static testMethod void testOppBeforeUpdateHelperClass12()
    {    
        insertTestData();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Offer/Negotiate/Close' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6AAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'Offer/Negotiate/Close';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        insert opp;      
                
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
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
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
       
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.Is_Restricted_Opportunity__c = true;
            opp.Planned_Meeting__c = pm.id;
            opp.Is_Follow_On_Opportunity__c = true;
            opp.Revenue_Type__c = 'Retrofit';
            opp.Solution_Type__c = 'HAT';
            update opp;
        Test.stopTest();
    }
    
    static testMethod void testOppBeforeUpdateHelperClass13()
    {    
        insertTestData();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Offer/Negotiate/Close' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6AAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        
        insert opp;      
                
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
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
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
       
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.Is_Restricted_Opportunity__c = true;
            opp.Planned_Meeting__c = pm.id;
            opp.Is_Follow_On_Opportunity__c = true;
            opp.Revenue_Type__c = 'Retrofit';
            opp.Solution_Type__c = 'HAT';
            update opp;
        Test.stopTest();
    } 
    static testMethod void testOppBeforeUpdateHelperClass14()
    {    
        insertTestData();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Closed Won' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6AAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        
        insert opp;      
                
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
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
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
       
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.Is_Restricted_Opportunity__c = true;
            opp.Planned_Meeting__c = pm.id;
            opp.Is_Follow_On_Opportunity__c = true;
            opp.Revenue_Type__c = 'Retrofit';
            opp.Solution_Type__c = 'HAT';
            update opp;
        Test.stopTest();
    } 
    static testMethod void testOppBeforeUpdateHelperClass15()
    {    
        insertTestData();
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Closed Lost' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000ZIv6AAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.Restricted_Opportunity_Name__c =null;
        opp.SBU__c = 'D&S';
        
        insert opp;      
                
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
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
        
        OpportunityLineItem lineItem1= new OpportunityLineItem (Revenue_Start_Date__c = Date.Today(), Revenue_End_Date__c = Date.Today() + 1,OpportunityID=opp.id,PriceBookEntryID=pbe1.id,TotalPrice=100,Revenue_Type__c='RMU',M_PM_Product__c=plcr.id,Probability__c=1.1,Quantity=1,Plant__c=pcm.id);
        insert lineItem1;
       
        
        Test.startTest();
            opp.Name= 'Test Oppty1';
            opp.ATR_Probability__c = 98;
            opp.Is_Restricted_Opportunity__c = true;
            opp.Planned_Meeting__c = pm.id;
            opp.Is_Follow_On_Opportunity__c = true;
            opp.Revenue_Type__c = 'Retrofit';
            opp.Solution_Type__c = 'HAT';
            opp.Restricted_Opportunity_Name__c =null;
            update opp;
        Test.stopTest();
    } 
}