@isTest
private class TestclassforUpdateProduct{
    static testMethod void TestUpdateProbability(){        
        //get standard pricebook
         //Create an account that is used for inserting opportunity.
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;
        
         //Create an opportunity.
        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Launch';
        objOpporunity.SBU__c= 'ATR';        
        objOpporunity.CloseDate = system.Today();
      
        //objOpporunity.IsClosed = FALSE ;
        Insert objOpporunity;
        
         
        //Create Product
        Product2 objProduct = new Product2();
        objProduct.Name = 'Test';
        objProduct.Description = 'Test';
        Insert objProduct;
        //Create standard price book this is needed for creation of pricebook entry.
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = objProduct.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pb = new Pricebook2(name='testPricebook');
        insert pb;
        
        list<PriceBook2> pb2StandardList = [select Id from Pricebook2];
        PriceBook2 pb2Standard = pb2StandardList.get(0);
        PricebookEntry objPBEntry = new PricebookEntry(Pricebook2Id = pb2Standard.Id, Product2Id=objProduct.Id,UnitPrice=500,IsActive=true);
        Insert objPBEntry;
        
        //Insert Product_Line_Item__c record to use in Product Line Item Cross Reference
        Product_Line__c pliRec = new Product_Line__c(name='test');
        insert pliRec;
           
         OpportunityLineItem objLineItem = new OpportunityLineItem();
        objLineItem.PriceBookEntryId = objPBEntry.Id;
        objLineItem.OpportunityId = objOpporunity.Id;
       objLineItem.Probability__c= 10;
        objLineItem.Quantity = 1;
        objLineItem.Forecast_Factor_AI__c =30.0;
         objLineItem.Type__c = 'Forecast';
          objLineItem.Revenue_Type__c= 'RMU';
       // objLineItem.Has_Schedule__c = 'yes';
          //objLineItem.Revenue_Start_Range__c = -245;
        objLineItem.Unitprice = 500;
       // objLineItem.M_PM_Product__c = crossRef.id; 
        objLineItem.M_PM_Product_Line__c = pliRec.id;
        Test.startTest();
        insert objLineItem;
        Test.stopTest();
    }
    static testMethod void TestUpdateProbability1(){        
        //get standard pricebook
        //Create an account that is used for inserting opportunity.
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;
        
         //Create an opportunity.
        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Launch';
        objOpporunity.SBU__c= 'ATR';        
        objOpporunity.CloseDate = system.Today();
      
        //objOpporunity.IsClosed = FALSE ;
        Insert objOpporunity;
        
          //List<SIOP_Forecast__mdt> siopForecasts = [SELECT MasterLabel, Close_Date_Range_Max__c, Close_Date_Range_Min__c, Has_Product__c, Has_Schedule__c, Last_Modified_Owner_Range_Max__c, Last_Modified_Owner_Range_Min__c, Last_Modified_Range_Max__c, Last_Modified_Range_Min__c, OLI_Revenue_Type__c, Opp_Stage__c, Revenue_Start_Range_Max__c, Revenue_Start_Range_Min__c, Vertical__c, Win_Probability_Cap__c FROM SIOP_Forecast__mdt where siopForecast.Vertical__c != 'Any' and siopForecast.Opp_Stage__c = 'Any' and  objLineItem.Opportunity.SBU__c = siopForecast[0].Vertical__c and objLineItem.Type__c = 'Forecast' and objLineItem.Opportunity.HasOpportunityLineItem = siopForecast.Has_Product__c  and objLineItem.Has_Schedule__c = siopForecast.Has_Schedule__c and objLineItem.Revenue_Type__c == siopForecast.OLI_Revenue_Type__c  and  objLineItem.closeddifferent_days__c <= siopForecast.Close_Date_Range_Max__c and  objLineItem.closeddifferent_days__c >= siopForecast.Close_Date_Range_Min__c and objLineItem.Opportunity.Last_Modified_User_Range__c <= siopForecast.Last_Modified_Range_Max__c and  objLineItem.Opportunity.Last_Modified_User_Range__c >= siopForecast.Last_Modified_Range_Min__c and objLineItem.Revenue_Start_Range__c <= siopForecast.Revenue_Start_Range_Max__c and  objLineItem.Revenue_Start_Range__c >= siopForecast.Revenue_Start_Range_Min__c and  objLineItem.Opportunity.Last_Modified_Owner_Range__c <= siopForecast.Last_Modified_Owner_Range_Max__c and  objLineItem.Opportunity.Last_Modified_Owner_Range__c >= siopForecast.Last_Modified_Owner_Range_Min__c ]; 
        //Create Product
        Product2 objProduct = new Product2();
        objProduct.Name = 'Test';
        objProduct.Description = 'Test';
        Insert objProduct;
        //Create standard price book this is needed for creation of pricebook entry.
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = objProduct.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 pb = new Pricebook2(name='testPricebook');
        insert pb;
        
        list<PriceBook2> pb2StandardList = [select Id from Pricebook2];
        PriceBook2 pb2Standard = pb2StandardList.get(0);
        PricebookEntry objPBEntry = new PricebookEntry(Pricebook2Id = pb2Standard.Id, Product2Id=objProduct.Id,UnitPrice=500,IsActive=true);
        Insert objPBEntry;
        
        //Insert Product_Line_Item__c record to use in Product Line Item Cross Reference
        Product_Line__c pliRec = new Product_Line__c(name='test');
        insert pliRec;
           
         OpportunityLineItem objLineItem = new OpportunityLineItem();
        objLineItem.PriceBookEntryId = objPBEntry.Id;
        objLineItem.OpportunityId = objOpporunity.Id;
       objLineItem.Probability__c= 10;
        objLineItem.Quantity = 1;
        objLineItem.Forecast_Factor_AI__c =30.0;
         objLineItem.Type__c = 'Forecast';
          objLineItem.Revenue_Type__c= 'RMU';
       // objLineItem.Has_Schedule__c = 'yes';
          //objLineItem.Revenue_Start_Range__c = -245;
        objLineItem.Unitprice = 500;
       // objLineItem.M_PM_Product__c = crossRef.id; 
        objLineItem.M_PM_Product_Line__c = pliRec.id;
        Test.startTest();
        insert objLineItem;
        System.assertNotEquals(0, objLineItem.Quantity); 
        Test.stopTest();
               
        
    }
}