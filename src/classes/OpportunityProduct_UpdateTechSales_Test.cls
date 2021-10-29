@isTest(SeeAllData=False)
private class OpportunityProduct_UpdateTechSales_Test{
static testmethod void OpportunityProduct_UpdateTechSales_Test(){
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Contact con1 = new Contact();
            con1.LastName = 'user1';
            con1.FirstName = 'Test1';
            con1.Account = acc;
            con1.Primary_Email_Address__c = 'test.user@testorg.com';
            con1.Email='test.user@testorg.com';
            con1.Phone_1__c = '1234567890';
            con1.Phone_5__c = '9876543210';
            insert con1;
            
            Contact con2 = new Contact();
            con2.LastName = 'user12';
            con2.FirstName = 'Test12';
            con2.Account = acc;
            con2.Primary_Email_Address__c = 'test.user@testorg.com';
            con2.Email='test.user@testorg.com';
            con2.Phone_1__c = '1234567890';
            con2.Phone_5__c = '9876543210';
            insert con2;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'BGA';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
            opp5.Tech_Sales__c = 'AT:';
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
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            opp5.Ship_Set_Delivery_Period__c= 'test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            
            Product_Line__c pl = new Product_Line__c();
            pl.Name ='testpl';
            insert pl;
            pl.Product_Line_Finance_POC__c = con2.id;
            update pl;
            
            Product_Line__c pl2 = new Product_Line__c();
            pl2.Name ='testpl2';
            insert pl2;
            
            Product_Line_Tech_Sales__c plts = new Product_Line_Tech_Sales__c();
            plts.Product_Line__c = pl.id;
            plts.CBT__c= 'BGA Aftermarket';
            plts.SBU__c = 'BGA';
            plts.Region__c = 'Americas';
            plts.Country__c = 'USA';
            insert plts;
            
            Product_Line_Cross_Ref__c plcr = new Product_Line_Cross_Ref__c();
            plcr.Name= 'testpl';
            plcr.Product_Line__c = pl.id;
            plcr.Product_Leader__c = con.id;
            insert plcr;
            plcr.Product_Line_Chief_Engineer__c = con1.id;
            update plcr;
            
            Product_Line_Cross_Ref__c plcr2 = new Product_Line_Cross_Ref__c();
            plcr2.Name= 'testplcr';
            plcr2.Product_Line__c = pl2.id;
            insert plcr2;
            
            Plant_Code_Master__c plant = new Plant_Code_Master__c();
            plant.Name ='Test Plant';
            insert plant;
            
            Product2 newProd = new Product2(Name = 'test product', family = 'test family');
            insert newProd;
            PriceBookEntry pbEntry = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id  = Test.getStandardPricebookId(),
            Product2Id = newProd.Id,
            IsActive = true);
            insert pbEntry ;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Opportunityid =opp5.id;
            oli.Revenue_Type__c = 'Engineering';
            oli.ServiceDate = system.today();
            oli.UnitPrice = 0;
            oli.Quantity = 2;
            oli.Probability__c = 20;
            oli.Plant__c = plant.id;
            system.debug('111' +oli.Plant__c);
            oli.M_PM_Product__c = plcr.id;
            oli.pricebookentryid = pbEntry.id;
            oli.Tech_Sales_Product__c='APU';
            
            Test.startTest();
            insert oli;
            oli.M_PM_Product__c =plcr2.id;
            update oli;
            Test.stopTest();
        }
    }
    
    static testmethod void OpportunityProduct_UpdateTechSales_Test1(){
        
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'D&S';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
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
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Default_Tech_Sales__c = 'Integrated Systems';
            opp5.Default_Tech_Sales_Product__c = 'Lighting';
            opp5.Ship_Set_Delivery_Period__c= 'test';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            
            Plant_Code_Master__c plant = new Plant_Code_Master__c();
            plant.Name ='Test Plant';
            insert plant;
            
            Product_Line__c pl = new Product_Line__c();
            pl.Name ='testpl';
            insert pl;
            
            Product_Line_Cross_Ref__c plcr = new Product_Line_Cross_Ref__c();
            plcr.Name= 'testpl';
            plcr.Product_Line__c = pl.id;
            insert plcr;
            
            Product_Line_Cross_Ref__c plcr2 = new Product_Line_Cross_Ref__c();
            plcr2.Name= 'testplcr';
            plcr2.Product_Line__c = pl.id;
            insert plcr2;
            
            Product2 newProd = new Product2(Name = 'test product', family = 'test family');
            insert newProd;
            PriceBookEntry pbEntry = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id  = Test.getStandardPricebookId(),
            Product2Id = newProd.Id,
            IsActive = true);
            insert pbEntry ;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Opportunityid =opp5.id;
            oli.Revenue_Type__c = 'Engineering';
            oli.ServiceDate = system.today();
            oli.UnitPrice = 0;
            oli.Quantity = 2;
            oli.Probability__c = 20;
            oli.Plant__c = plant.id;
            oli.M_PM_Product__c = plcr.id;
            oli.pricebookentryid = pbEntry.Id;
            
            Test.startTest();
            insert oli;
            oli.M_PM_Product__c = plcr2.id;
            update oli;
            delete oli;
            Test.stopTest();
        }
    }
    static testmethod void OpportunityProduct_UpdateTechSales_Test2(){
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Contact con1 = new Contact();
            con1.LastName = 'user1';
            con1.FirstName = 'Test1';
            con1.Account = acc;
            con1.Primary_Email_Address__c = 'test.user@testorg.com';
            con1.Email='test.user@testorg.com';
            con1.Phone_1__c = '1234567890';
            con1.Phone_5__c = '9876543210';
            insert con1;
            
            Contact con2 = new Contact();
            con2.LastName = 'user12';
            con2.FirstName = 'Test12';
            con2.Account = acc;
            con2.Primary_Email_Address__c = 'test.user@testorg.com';
            con2.Email='test.user@testorg.com';
            con2.Phone_1__c = '1234567890';
            con2.Phone_5__c = '9876543210';
            insert con2;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'BGA';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
            opp5.Tech_Sales__c = 'AT:';
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
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            opp5.Ship_Set_Delivery_Period__c= 'test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            
            Product_Line__c pl = new Product_Line__c();
            pl.Name ='testpl';
            insert pl;
            pl.Product_Line_Finance_POC__c = con2.id;
            update pl;
            
            Product_Line__c pl2 = new Product_Line__c();
            pl2.Name ='testpl2';
            insert pl2;
            
            Product_Line_Tech_Sales__c plts = new Product_Line_Tech_Sales__c();
            plts.Product_Line__c = pl.id;
            plts.CBT__c= 'BGA Aftermarket';
            plts.SBU__c = 'BGA';
            plts.Region__c = 'Americas';
            insert plts;
            
            Product_Line_Cross_Ref__c plcr = new Product_Line_Cross_Ref__c();
            plcr.Name= 'testpl';
            plcr.Product_Line__c = pl.id;
            plcr.Product_Leader__c = con.id;
            insert plcr;
            plcr.Product_Line_Chief_Engineer__c = con1.id;
            update plcr;
            
            Product_Line_Cross_Ref__c plcr2 = new Product_Line_Cross_Ref__c();
            plcr2.Name= 'testplcr';
            plcr2.Product_Line__c = pl2.id;
            insert plcr2;
            
            Plant_Code_Master__c plant = new Plant_Code_Master__c();
            plant.Name ='Test Plant';
            insert plant;
            
            Product2 newProd = new Product2(Name = 'test product', family = 'test family');
            insert newProd;
            PriceBookEntry pbEntry = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id  = Test.getStandardPricebookId(),
            Product2Id = newProd.Id,
            IsActive = true);
            insert pbEntry ;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Opportunityid =opp5.id;
            oli.Revenue_Type__c = 'Engineering';
            oli.ServiceDate = system.today();
            oli.UnitPrice = 0;
            oli.Quantity = 2;
            oli.Probability__c = 20;
            oli.Plant__c = plant.id;
            system.debug('111' +oli.Plant__c);
            oli.M_PM_Product__c = plcr.id;
            oli.pricebookentryid = pbEntry.id;
            oli.Tech_Sales_Product__c='APU';
            
            Test.startTest();
            insert oli;
            oli.M_PM_Product__c =plcr2.id;
            update oli;
            Test.stopTest();
        }
    }
    static testmethod void OpportunityProduct_UpdateTechSales_Test3(){
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Contact con1 = new Contact();
            con1.LastName = 'user1';
            con1.FirstName = 'Test1';
            con1.Account = acc;
            con1.Primary_Email_Address__c = 'test.user@testorg.com';
            con1.Email='test.user@testorg.com';
            con1.Phone_1__c = '1234567890';
            con1.Phone_5__c = '9876543210';
            insert con1;
            
            Contact con2 = new Contact();
            con2.LastName = 'user12';
            con2.FirstName = 'Test12';
            con2.Account = acc;
            con2.Primary_Email_Address__c = 'test.user@testorg.com';
            con2.Email='test.user@testorg.com';
            con2.Phone_1__c = '1234567890';
            con2.Phone_5__c = '9876543210';
            insert con2;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'BGA';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
            opp5.Tech_Sales__c = 'AT:';
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
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            opp5.Ship_Set_Delivery_Period__c= 'test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            
            Product_Line__c pl = new Product_Line__c();
            pl.Name ='testpl';
            insert pl;
            pl.Product_Line_Finance_POC__c = con2.id;
            update pl;
            
            Product_Line__c pl2 = new Product_Line__c();
            pl2.Name ='testpl2';
            insert pl2;
            
            Product_Line_Tech_Sales__c plts = new Product_Line_Tech_Sales__c();
            plts.Product_Line__c = pl.id;
            plts.SBU__c = 'BGA';
            plts.Region__c = 'Americas';
            plts.Country__c = 'USA';
            insert plts;
            
            Product_Line_Cross_Ref__c plcr = new Product_Line_Cross_Ref__c();
            plcr.Name= 'testpl';
            plcr.Product_Line__c = pl.id;
            plcr.Product_Leader__c = con.id;
            insert plcr;
            plcr.Product_Line_Chief_Engineer__c = con1.id;
            update plcr;
            
            Product_Line_Cross_Ref__c plcr2 = new Product_Line_Cross_Ref__c();
            plcr2.Name= 'testplcr';
            plcr2.Product_Line__c = pl2.id;
            insert plcr2;
            
            Plant_Code_Master__c plant = new Plant_Code_Master__c();
            plant.Name ='Test Plant';
            insert plant;
            
            Product2 newProd = new Product2(Name = 'test product', family = 'test family');
            insert newProd;
            PriceBookEntry pbEntry = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id  = Test.getStandardPricebookId(),
            Product2Id = newProd.Id,
            IsActive = true);
            insert pbEntry ;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Opportunityid =opp5.id;
            oli.Revenue_Type__c = 'Engineering';
            oli.ServiceDate = system.today();
            oli.UnitPrice = 0;
            oli.Quantity = 2;
            oli.Probability__c = 20;
            oli.Plant__c = plant.id;
            system.debug('111' +oli.Plant__c);
            oli.M_PM_Product__c = plcr.id;
            oli.pricebookentryid = pbEntry.id;
            oli.Tech_Sales_Product__c='APU';
            
            Test.startTest();
            insert oli;
            oli.M_PM_Product__c =plcr2.id;
            update oli;
            Test.stopTest();
        }
    }
     static testmethod void OpportunityProduct_UpdateTechSales_Test4(){
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Contact con1 = new Contact();
            con1.LastName = 'user1';
            con1.FirstName = 'Test1';
            con1.Account = acc;
            con1.Primary_Email_Address__c = 'test.user@testorg.com';
            con1.Email='test.user@testorg.com';
            con1.Phone_1__c = '1234567890';
            con1.Phone_5__c = '9876543210';
            insert con1;
            
            Contact con2 = new Contact();
            con2.LastName = 'user12';
            con2.FirstName = 'Test12';
            con2.Account = acc;
            con2.Primary_Email_Address__c = 'test.user@testorg.com';
            con2.Email='test.user@testorg.com';
            con2.Phone_1__c = '1234567890';
            con2.Phone_5__c = '9876543210';
            insert con2;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'BGA';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
            opp5.Tech_Sales__c = 'AT:';
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
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            opp5.Ship_Set_Delivery_Period__c= 'test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            
            Product_Line__c pl = new Product_Line__c();
            pl.Name ='testpl';
            insert pl;
            pl.Product_Line_Finance_POC__c = con2.id;
            update pl;
            
            Product_Line__c pl2 = new Product_Line__c();
            pl2.Name ='testpl2';
            insert pl2;
            
            Product_Line_Tech_Sales__c plts = new Product_Line_Tech_Sales__c();
            plts.Product_Line__c = pl.id;
            plts.SBU__c = 'BGA';
            plts.Region__c = 'Americas';
            insert plts;
            
            Product_Line_Cross_Ref__c plcr = new Product_Line_Cross_Ref__c();
            plcr.Name= 'testpl';
            plcr.Product_Line__c = pl.id;
            plcr.Product_Leader__c = con.id;
            insert plcr;
            plcr.Product_Line_Chief_Engineer__c = con1.id;
            update plcr;
            
            Product_Line_Cross_Ref__c plcr2 = new Product_Line_Cross_Ref__c();
            plcr2.Name= 'testplcr';
            plcr2.Product_Line__c = pl2.id;
            insert plcr2;
            
            Plant_Code_Master__c plant = new Plant_Code_Master__c();
            plant.Name ='Test Plant';
            insert plant;
            
            Product2 newProd = new Product2(Name = 'test product', family = 'test family');
            insert newProd;
            PriceBookEntry pbEntry = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id  = Test.getStandardPricebookId(),
            Product2Id = newProd.Id,
            IsActive = true);
            insert pbEntry ;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Opportunityid =opp5.id;
            oli.Revenue_Type__c = 'Engineering';
            oli.ServiceDate = system.today();
            oli.UnitPrice = 0;
            oli.Quantity = 2;
            oli.Probability__c = 20;
            oli.Plant__c = plant.id;
            system.debug('111' +oli.Plant__c);
            oli.M_PM_Product__c = plcr.id;
            oli.pricebookentryid = pbEntry.id;
            oli.Tech_Sales_Product__c='Engine Valves';
            
            Test.startTest();
            insert oli;
            oli.M_PM_Product__c =plcr2.id;
            update oli;
            Test.stopTest();
            
            
         List<OpportunityLineItemSchedule> schedules = [select Id,ScheduleDate from OpportunityLineItemSchedule where OpportunityLineItemId = :oli.Id];
       // System.assert(!schedules.isEmpty()); 
       // System.assertEquals(newProd.NumberOfRevenueInstallments, schedules.size());
  
        }
        
    }
    static testmethod void OpportunityProduct_UpdateTechSales_Test5(){
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Contact con1 = new Contact();
            con1.LastName = 'user1';
            con1.FirstName = 'Test1';
            con1.Account = acc;
            con1.Primary_Email_Address__c = 'test.user@testorg.com';
            con1.Email='test.user@testorg.com';
            con1.Phone_1__c = '1234567890';
            con1.Phone_5__c = '9876543210';
            insert con1;
            
            Contact con2 = new Contact();
            con2.LastName = 'user12';
            con2.FirstName = 'Test12';
            con2.Account = acc;
            con2.Primary_Email_Address__c = 'test.user@testorg.com';
            con2.Email='test.user@testorg.com';
            con2.Phone_1__c = '1234567890';
            con2.Phone_5__c = '9876543210';
            insert con2;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'BGA';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
            opp5.Tech_Sales__c = 'AT:';
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
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            opp5.Ship_Set_Delivery_Period__c= 'test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            
            Product_Line__c pl = new Product_Line__c();
            pl.Name ='All';
            pl.Product_Line_ePAC__c = 'Mechanical';
            insert pl;
            pl.Product_Line_Finance_POC__c = con2.id;
            update pl;
            
            Product_Line__c pl2 = new Product_Line__c();
            pl2.Name ='All';
            insert pl2;
            
            Product_Line_Tech_Sales__c plts = new Product_Line_Tech_Sales__c();
            plts.Product_Line__c = pl.id;
            plts.SBU__c = 'BGA';
            plts.CBT__c = 'BGA Aftermarket';
            plts.Region__c = 'Americas';
            insert plts;
            plts.Product_Type__c = 'Mechanical';
            plts.Country__c = 'USA';
            update plts;
            
            Product_Line_Cross_Ref__c plcr = new Product_Line_Cross_Ref__c();
            plcr.Name= 'testpl';
            plcr.Product_Line__c = pl.id;
            plcr.Product_Leader__c = con.id;
            insert plcr;
            plcr.Product_Line_Chief_Engineer__c = con1.id;
            update plcr;
            
            Product_Line_Cross_Ref__c plcr2 = new Product_Line_Cross_Ref__c();
            plcr2.Name= 'testplcr';
            plcr2.Product_Line__c = pl2.id;
            insert plcr2;
            
            Plant_Code_Master__c plant = new Plant_Code_Master__c();
            plant.Name ='Test Plant';
            insert plant;
            
            Product2 newProd = new Product2(Name = 'test product', family = 'test family');
            insert newProd;
            PriceBookEntry pbEntry = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id  = Test.getStandardPricebookId(),
            Product2Id = newProd.Id,
            IsActive = true);
            insert pbEntry ;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Opportunityid =opp5.id;
            oli.Revenue_Type__c = 'Engineering';
            oli.ServiceDate = system.today();
            oli.UnitPrice = 0;
            oli.Quantity = 2;
            oli.Probability__c = 20;
            oli.Plant__c = plant.id;
            system.debug('111' +oli.Plant__c);
            oli.M_PM_Product__c = plcr.id;
            oli.pricebookentryid = pbEntry.id;
            oli.Tech_Sales_Product__c='APU';
            
            Test.startTest();
            insert oli;
            oli.M_PM_Product__c =plcr2.id;
            update oli;
            Test.stopTest();
        }
    }
       //Added for code coverage in BeforeupdateHelper class - draft priority flag
        /*static testmethod void OpportunityProduct_UpdateTechSales_Test6(){
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            Id ortid = [select id from recordtype where name  ='M&PM SIM Licensing'].id;
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'BGA';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
            opp5.Tech_Sales__c = 'AT:';
            opp5.Prime_Sub__c = 'Prime';
            opp5.opportunity_Type__c = 'M&PM SIM Licensing';
            opp5.StageName = 'Offer/Negotiate/Close';
            opp5.RecordtypeId = ortid ;
            opp5.CUSTOMER_LICENSE_NEED_DATE__c = system.today();
            opp5.CloseDate = System.today();
            opp5.Revenue_Type__c = 'ENG';
            opp5.Bid_Type_Name__c = 'LTA';
            opp5.International_Code__c = 'FMS';
            opp5.Incumbent__c = 'Incumbent';
            opp5.RMU__c = 'YES';
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            opp5.Ship_Set_Delivery_Period__c= 'test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            }
    }*/
    
    /* static testmethod void OpportunityProduct_UpdateTechSales_Test7(){
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            Id ortid = [select id from recordtype where name  ='M&PM SIM Licensing'].id;
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'BGA';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
            opp5.Tech_Sales__c = 'AT:';
            opp5.Prime_Sub__c = 'Prime';
            opp5.opportunity_Type__c = 'M&PM SIM Licensing';
            opp5.StageName = 'Offer/Negotiate/Close';
            opp5.RecordtypeId = ortid;
            opp5.CUSTOMER_LICENSE_NEED_DATE__c = system.today()+90;
            opp5.CloseDate = System.today();
            opp5.Revenue_Type__c = 'ENG';
            opp5.Bid_Type_Name__c = 'LTA';
            opp5.International_Code__c = 'FMS';
            opp5.Incumbent__c = 'Incumbent';
            opp5.RMU__c = 'YES';
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            opp5.Ship_Set_Delivery_Period__c= 'test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            }
    }*/
    
     static testmethod void OpportunityProduct_UpdateTechSales_Test9(){
        User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            Account acc= new account();
            acc.Name = 'Testweb';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'BGA';
            acc.CBT__c = 'BGA Aftermarket';
            acc.Region_Name__c = 'Americas';
            acc.Report_Country_Name__c = 'USA';
            insert acc;
            
            Contact con = new Contact();
            con.LastName = 'user';
            con.FirstName = 'Test';
            con.Account = acc;
            con.Primary_Email_Address__c = 'test.user@testorg.com';
            con.Email='test.user@testorg.com';
            con.Phone_1__c = '1234567890';
            con.Phone_5__c = '9876543210';
            insert con;
            
            Contact con1 = new Contact();
            con1.LastName = 'user1';
            con1.FirstName = 'Test1';
            con1.Account = acc;
            con1.Primary_Email_Address__c = 'test.user@testorg.com';
            con1.Email='test.user@testorg.com';
            con1.Phone_1__c = '1234567890';
            con1.Phone_5__c = '9876543210';
            insert con1;
            
            Contact con2 = new Contact();
            con2.LastName = 'user12';
            con2.FirstName = 'Test12';
            con2.Account = acc;
            con2.Primary_Email_Address__c = 'test.user@testorg.com';
            con2.Email='test.user@testorg.com';
            con2.Phone_1__c = '1234567890';
            con2.Phone_5__c = '9876543210';
            insert con2;
            
            Platform__c p = new Platform__c();
            p.Name = 'Test Paltform';
            p.Model__c = '36-16A';
            p.Make__c = 'VARIOUS OEMS';
            p.SAP_External_System__c=True;
            insert p;
            
            Opportunity opp5 = new Opportunity();
            opp5.Name = 'Test Method Opportunity';
            opp5.SBU__c = 'BGA';
            opp5.CBT_Tier_2__c = 'DAA';
            opp5.CBT_Team_Tier_3__c = 'CBMS';
            opp5.AccountId = acc.Id;
            opp5.End_User__c = acc.Id;
            opp5.Tech_Sales_Product_Area__c = 'testpl';
            opp5.Tech_Sales__c = 'AT:';
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
            opp5.Platform__c = p.Id; 
            opp5.Active__c = TRUE;
            opp5.Certification_Requirements__c = 'FAR 15 Tina';
            opp5.Proposal_Complexity__c ='Pre-work initiated';
            opp5.Ship_Set_Quantity__c = 1;
            opp5.Ship_Set_Parts__c ='1234';
            opp5.Proposal_Complexity_Description__c = 'test';
            opp5.RFP_Expected_Date__c =System.today(); 
            opp5.Ship_Set_Delivery_Period__c= 'test';
            triggerinactive.TestOppUpdate_UpdateStage = false;
            insert opp5;
            
            Product_Line__c pl = new Product_Line__c();
            pl.Name ='*All*';
            pl.Product_Line_ePAC__c = 'Mechanical';
            insert pl;
            pl.Product_Line_Finance_POC__c = con2.id;
            update pl;
            
            Product_Line__c pl2 = new Product_Line__c();
            pl2.Name ='*All*';
            insert pl2;
            
            Product_Line_Tech_Sales__c plts = new Product_Line_Tech_Sales__c();
            plts.Product_Line__c = pl.id;
            plts.SBU__c = 'BGA';
            plts.CBT__c = 'BGA Aftermarket';
            plts.Region__c = 'Americas';
            insert plts;
            plts.Product_Type__c = 'Mechanical';            
            update plts;
            
            Product_Line_Cross_Ref__c plcr = new Product_Line_Cross_Ref__c();
            plcr.Name= 'testpl';
            plcr.Product_Line__c = pl.id;
            plcr.Product_Leader__c = con.id;
            insert plcr;
            plcr.Product_Line_Chief_Engineer__c = con1.id;
            update plcr;
            
            Product_Line_Cross_Ref__c plcr2 = new Product_Line_Cross_Ref__c();
            plcr2.Name= 'testplcr';
            plcr2.Product_Line__c = pl2.id;
            insert plcr2;
            
            Plant_Code_Master__c plant = new Plant_Code_Master__c();
            plant.Name ='Test Plant';
            insert plant;
            
            Product2 newProd = new Product2(Name = 'test product', family = 'test family');
            insert newProd;
            PriceBookEntry pbEntry = new PriceBookEntry(
            UnitPrice = 300,
            PriceBook2Id  = Test.getStandardPricebookId(),
            Product2Id = newProd.Id,
            IsActive = true);
            insert pbEntry ;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Opportunityid =opp5.id;
            oli.Revenue_Type__c = 'Engineering';
            oli.ServiceDate = system.today();
            oli.UnitPrice = 0;
            oli.Quantity = 2;
            oli.Probability__c = 20;
            oli.Plant__c = plant.id;
            system.debug('111' +oli.Plant__c);
            oli.M_PM_Product__c = plcr.id;
            oli.pricebookentryid = pbEntry.id;
            oli.Tech_Sales_Product__c='APU';
            //oli.Tech_Sales_Product_Type__c = 'Mechanical';
            //oli.SBU__c = 'BGA';
            //oli.CBT__c = 'DAA';
            //oli.Tech_Sales_Region__c = 'Americas';
            Test.startTest();
            insert oli;
            oli.M_PM_Product__c =plcr2.id;
            update oli;
            Test.stopTest();
        }
    }

     
}