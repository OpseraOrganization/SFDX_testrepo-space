@isTest(SeeAllData=true)
    private class Test_OpportunityLevelchanges
    {      
       
        static testMethod void OpportunityLevelchangestest() 
        {
         //    User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        //System.runAs(u) 
       // {
            Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
            ID prdID = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Method Opportunity';
            opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp.SBU__c = 'D&S';
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'OE Complex';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';
            opp.SBU__c = 'D&S';      
            insert opp;
            
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Quantity = 2;
            oli.TotalPrice  = 200;
            oli.pricebookentryid = prdID;
            oli.OpportunityId = opp.Id;
            oli.Type__c = 'Booked'; 
            oli.Solution_Type__c ='RMU';
            oli.Revenue_Type__c = 'License';
            oppLineList.add(oli);
            
            OpportunityLineItem oli1 = new OpportunityLineItem();
            oli1.Quantity = 3;
            oli1.TotalPrice  = 200;
            oli1.pricebookentryid = prdID;
            oli1.OpportunityId = opp.Id;
            oli1.Type__c = 'Booked'; 
            oli1.Solution_Type__c ='BFE/SSFE';
            oli1.Revenue_Type__c = 'ENG';
            oppLineList.add(oli1);
                        
            OpportunityLineItem oli2 = new OpportunityLineItem();
            oli2.Quantity = 2;
            oli2.TotalPrice  = 300;
            oli2.pricebookentryid = prdID;
            oli2.OpportunityId = opp.Id;
            oli2.Type__c = 'Booked'; 
            oli2.Solution_Type__c ='Other';
            oli2.Revenue_Type__c = 'Services';
            oppLineList.add(oli2);
                   
            OpportunityLineItem oli3 = new OpportunityLineItem();
            oli3.Quantity = 2;
            oli3.TotalPrice  = 200;
            oli3.pricebookentryid = prdID;
            oli3.OpportunityId = opp.Id;
            oli3.Type__c = 'Booked'; 
            oli3.Solution_Type__c ='Direct Sales';
            oli3.Revenue_Type__c = 'Repairs / Overhaul';
            oppLineList.add(oli3);
              
                      
            Test.StartTest();        
            /*insert oli;
            insert oli1;
            insert oli2;
            insert oli3;*/
            insert oppLineList;
            Test.stopTest();
       // }
        }
        static testMethod void OpportunityLevelchangestest1() 
        {
            //User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        //System.runAs(u) 
        //{
            ID prdID = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
            List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Method Opportunity';
            opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp.SBU__c = 'D&S';
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'OE Complex';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';
            opp.SBU__c = 'D&S';      
            insert opp;
          
            OpportunityLineItem oli4 = new OpportunityLineItem();
            oli4.Quantity = 2;
            oli4.TotalPrice  = 200;
            oli4.pricebookentryid = prdID;
            oli4.OpportunityId = opp.Id;
            oli4.Type__c = 'Booked'; 
            oli4.Solution_Type__c ='OE - Original Equipment';
            oli4.Revenue_Type__c = 'Retrofit';
            oppLineList.add(oli4);
            
            OpportunityLineItem oli5 = new OpportunityLineItem();
            oli5.Quantity = 2;
            oli5.TotalPrice  = 200;
            oli5.pricebookentryid = prdID;
            oli5.OpportunityId = opp.Id;
            oli5.Type__c = 'Booked'; 
            oli5.Solution_Type__c ='Repair and Overhaul';
            oli5.Revenue_Type__c = 'Spares / AM';
            oppLineList.add(oli5);
            
            OpportunityLineItem oli6 = new OpportunityLineItem();
            oli6.Quantity = 2;
            oli6.TotalPrice  = 200;
            oli6.pricebookentryid = prdID;
            oli6.OpportunityId = opp.Id;
            oli6.Type__c = 'Booked'; 
            oli6.Solution_Type__c ='Spares - LRU and APU';
            oli6.Revenue_Type__c = 'OEM';
            oppLineList.add(oli6);
            
            OpportunityLineItem oli7 = new OpportunityLineItem();
            oli7.Quantity = 2;
            oli7.TotalPrice  = 200;
            oli7.pricebookentryid = prdID;
            oli7.OpportunityId = opp.Id;
            oli7.Type__c = 'Booked'; 
            oli7.Solution_Type__c ='Spares Repair Details';
            oli7.Revenue_Type__c = 'OEM';
            oppLineList.add(oli7);
            
            OpportunityLineItem oli13 = new OpportunityLineItem();
            oli13.Quantity = 3;
            oli13.TotalPrice  = 200;
            oli13.pricebookentryid = prdID;
            oli13.OpportunityId = opp.Id;
            oli13.Type__c = 'Booked'; 
            oli13.Solution_Type__c ='Services';
            oli13.Revenue_Type__c = 'OEM';
            oppLineList.add(oli13);
            
            Test.StartTest();
            /*insert oli4;
            system.assertEquals(oli4.Quantity,2);
            oli4.Quantity = 3;
            upsert oli4;
            insert oli5;
            insert oli6;
            insert oli7;   
            insert oli13;*/
            insert oppLineList;
            Test.stopTest();
        //}
        }
        static testMethod void OpportunityLevelchangestest2() 
        {
            User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
            System.runAs(u) 
            {
            system.debug('inside Test_OpportunityLevelchangestest2');
            ID prdID = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            //Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
            Account acc=new Account(Name='Honeywell Test Account');
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Method Opportunity';
            //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            //opp.RecordTypeId='01230000000ZQCb';
            opp.RecordTypeId=Label.OE_Complex;
            opp.SBU__c = 'ATR';
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'ATR';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';     
            insert opp;
                                  
            OpportunityLineItem oli10 = new OpportunityLineItem();
            oli10.Quantity = 2;
            oli10.TotalPrice  = 200;
            oli10.pricebookentryid = prdID ;
            oli10.OpportunityId = opp.Id;
            oli10.Type__c = 'Booked'; 
            oli10.Solution_Type__c ='OE - Original Equipment';
            oli10.Revenue_Type__c = 'Spares / AM';
            oli10.Probability__c=1;
            //oppLineList.add(oli10);
            //oli10.Amount_Net__c=10000;
            system.debug('oli10.TotalPrice'+oli10.TotalPrice);
            system.debug('oli10.Probability__c'+oli10.Probability__c);
            system.debug('Amount_Net__c TestOpplevelchanges '+oli10.Amount_Net__c);
            
                       
            Test.StartTest();
            //insert oli8; 
            //insert oli9;
            insert oli10;
            //insert oppLineList;
            system.debug('Amount_Net__c TestOpplevelchanges '+oli10.Amount_Net__c);
            oli10.Solution_Type__c ='Repair and Overhaul';
            update oli10;
            oli10.Solution_Type__c ='RMU';
            update oli10;
            //delete oli10;
            Test.stopTest();
            }
        } 
        static testMethod void OpportunityLevelchangestest3() 
        {
            User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            system.debug('inside Test_OpportunityLevelchangestest2');
            ID prdID = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            //Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
            Account acc=new Account(Name='Honeywell Test Account');
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Method Opportunity';
            //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            //opp.RecordTypeId='01230000000ZQCb';
            opp.RecordTypeId=Label.OE_Complex;
            opp.SBU__c = 'ATR';
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'ATR';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';     
            insert opp;
          
            List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
            OpportunityLineItem oli10 = new OpportunityLineItem();
            oli10.Quantity = 2;
            oli10.TotalPrice  = 200;
            oli10.pricebookentryid = prdID ;
            oli10.OpportunityId = opp.Id;
            oli10.Type__c = 'Booked'; 
            oli10.Solution_Type__c ='Spares Repair Details';
            oli10.Revenue_Type__c = 'Spares / AM';
            oli10.TotalPrice=123.0;
            oli10.Probability__c=1;
            system.debug('Amount_Net__c TestOpplevelchanges '+oli10.Amount_Net__c);
            
                    
            Test.StartTest();
            insert oli10;
            oli10.Solution_Type__c ='Spares - LRU and APU';
            update oli10;
            oli10.Solution_Type__c ='Other';
            update oli10;
            //delete oli10;
            Test.stopTest();
        }
        }
            static testMethod void OpportunityLevelchangestest4() 
        {
            User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
            system.debug('inside Test_OpportunityLevelchangestest2');
            ID prdID = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            //Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
            Account acc=new Account(Name='Honeywell Test Account');
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Method Opportunity';
            //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            //opp.RecordTypeId='01230000000ZQCb';
            opp.RecordTypeId=Label.OE_Complex;
            opp.SBU__c = 'ATR';
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.Amount=1234.0;
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'ATR';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';     
            insert opp;
          
            OpportunityLineItem oli10 = new OpportunityLineItem();
            oli10.Quantity = 2;
            oli10.TotalPrice  = 200;
            oli10.pricebookentryid = prdID ;
            oli10.OpportunityId = opp.Id;
            oli10.Type__c = 'Booked'; 
            oli10.Solution_Type__c ='Direct Sales';
            oli10.Revenue_Type__c = 'Spares / AM';
            oli10.Probability__c=1;
            oppLineList.add(oli10);
            
                    
            Test.StartTest();
            
           // insert oli10;
            OpportunityLineItem oli11 = new OpportunityLineItem();
            oli11.Quantity = 2;
            oli11.TotalPrice  = 200;
            oli11.pricebookentryid = prdID ;
            oli11.OpportunityId = opp.Id;
            oli11.Type__c = 'Booked'; 
            oli11.Solution_Type__c ='RMU';
            oli11.Revenue_Type__c = 'Spares / AM';
            oli11.Probability__c=1;
            system.debug('oli10.TotalPrice'+oli11.TotalPrice);
            system.debug('oli10.Probability__c'+oli11.Probability__c);
            system.debug('Amount_Net__c TestOpplevelchanges '+oli11.Amount_Net__c);
            oli11.Solution_Type__c ='Spares Repair Details';
            oppLineList.add(oli11);
            insert oppLineList;
            oli10.Solution_Type__c ='BFE / SSFE';
            update oli10;
            oli10.Solution_Type__c ='Spares Repair Details';
            update oli10;
            //update oli10;
            /*oli10.Solution_Type__c ='Other';
            update oli10;*/
            //insert oli11;
            delete oppLineList[0];
            Test.stopTest();            
        } 
        }
        
        static testMethod void OpportunityLevelchangestest5() 
        {
            User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
            system.debug('inside Test_OpportunityLevelchangestest2');
            ID prdID = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            //Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
            Account acc=new Account(Name='Honeywell Test Account');
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Method Opportunity';
            opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            //opp.RecordTypeId='01230000000ZQCb';
            opp.SBU__c = 'ATR';
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'ATR';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'Direct Sales';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';     
            insert opp;
          
            OpportunityLineItem oli10 = new OpportunityLineItem();
            oli10.Quantity = 2;
            oli10.TotalPrice  = 200;
            oli10.pricebookentryid = prdID ;
            oli10.OpportunityId = opp.Id;
            oli10.Type__c = 'Booked'; 
            oli10.Solution_Type__c ='Spares - LRU and APU';
            oli10.Revenue_Type__c = 'Spares / AM';
            oli10.TotalPrice=123.0;
            oli10.Probability__c=1;
            oppLineList.add(oli10);
            system.debug('Amount_Net__c TestOpplevelchanges '+oli10.Amount_Net__c);
            
                               
            Test.StartTest();
            //insert oli10;
            insert oppLineList;
            oli10.Solution_Type__c ='Services';
            update oli10;
            oli10.Solution_Type__c ='Direct Sales';
            update oli10;
            Test.stopTest();            
        } 
        }
        static testMethod void OpportunityLevelchangestest6() 
        {
            User u= [select id,profileid from user where profile.name ='system administrator' and IsActive=true limit 1];
        System.runAs(u) 
        {
            List<OpportunityLineItem> oppLineList = new List<OpportunityLineItem>();
            system.debug('inside Test_OpportunityLevelchangestest2');
            ID prdID = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            //Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
            Account acc=new Account(Name='Honeywell Test Account');
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Method Opportunity';
            opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            //opp.RecordTypeId='01230000000ZQCb';
            opp.SBU__c = 'ATR';
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'ATR';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'Direct Sales';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';     
            insert opp;
          
            OpportunityLineItem oli10 = new OpportunityLineItem();
            oli10.Quantity = 2;
            oli10.TotalPrice  = 200;
            oli10.pricebookentryid = prdID ;
            oli10.OpportunityId = opp.Id;
            oli10.Type__c = 'Booked'; 
            oli10.Solution_Type__c ='Spares - Repair Details';
            oli10.Revenue_Type__c = 'Spares / AM';
            oli10.TotalPrice=123.0;
            oli10.Probability__c=1;
            oppLineList.add(oli10);
            system.debug('Amount_Net__c TestOpplevelchanges '+oli10.Amount_Net__c);
            
             OpportunityLineItem oli11 = new OpportunityLineItem();
            oli11.Quantity = 2;
            oli11.TotalPrice  = 200;
            oli11.pricebookentryid = prdID ;
            oli11.OpportunityId = opp.Id;
            oli11.Type__c = 'Booked'; 
            oli11.Solution_Type__c ='Services';
            oli11.Revenue_Type__c = 'Spares / AM';
            oli11.TotalPrice=123.0;
            oli11.Probability__c=1;
            oppLineList.add(oli11);
          
            
            Test.StartTest();
            //insert oli10;
            
            insert oppLineList;
            oli10.Solution_Type__c ='Spares - Repair Details';
            update oppLineList;
            delete oli11;
            Test.stopTest();   
        }
        } 



    }