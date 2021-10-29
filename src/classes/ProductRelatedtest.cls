@isTest(SeeAllData=true)
private class ProductRelatedtest{
    static testMethod void ProductRelatedtest(){
        ID rec = label.D_S_PrePriced;
            Product_Line__c lin = new Product_Line__c   (Name='test');
        insert lin;
        
        Product2 prod = new Product2(Name = 'Laptop X200',
        Family = 'Hardware',IsActive=true,Description='test',CanUseQuantitySchedule=true,CanUseRevenueSchedule=true,Comments__c='test',Product_Line__c=lin.id,RMU__c=false,Product_Number__c='12345');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',
        Family = 'Hardware',IsActive=true,Description='test prod 2',CanUseQuantitySchedule=true,CanUseRevenueSchedule=true,Comments__c='test prod2',Product_Line__c=lin.id,RMU__c=true,Product_Number__c='12343345');
        insert prod1;
        
        Id pricebookId = Test.getStandardPricebookId();
        Id pricebookId1 = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prod.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
         
        PricebookEntry customprice = new PricebookEntry(
        Pricebook2Id = pricebookId1, Product2Id = prod1.Id,
        UnitPrice = 20000, IsActive = true);
        insert customprice;
        
        Opportunity opp = new Opportunity();
        opp.Name='Test Opp unique name';
        opp.closedate=System.today();  
        opp.pricebook2id =pricebookid;
        opp.StageName='Prospecting';
        opp.ATR_Aircraft_Quantity__c =1;
        opp.Tech_Sales_Product_Area__c='APU';
        insert opp;
        
        OpportunityLineItem ooli = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id, TotalPrice=10, PriceBookEntryId=customprice.id); 
        insert ooli;
        String fieldNames ='Quantity, OpportunityId, TotalPrice, PriceBookEntryId';
        ProductRelated.getRecordList('ASC', fieldNames, 'OpportunityLineItem');
        ProductRelated.deleteRecord(opp.Id);
        ProductRelated.getRecordListWithAll('ASC', fieldNames, 'OpportunityLineItem', rec);
        ProductRelated.getRecordListWithId('ASC', fieldNames, 'OpportunityLineItem', rec);
        ProductRelated.getUIThemeDescription();
    }
    static testMethod void ProductRelatedtesta(){
        ID rec = label.D_S_PrePriced;
            Product_Line__c lin = new Product_Line__c   (Name='test');
        insert lin;
        
        Product2 prod = new Product2(Name = 'Laptop X200',
        Family = 'Hardware',IsActive=true,Description='test',CanUseQuantitySchedule=true,CanUseRevenueSchedule=true,Comments__c='test',Product_Line__c=lin.id,RMU__c=false,Product_Number__c='12345');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',
        Family = 'Hardware',IsActive=true,Description='test prod 2',CanUseQuantitySchedule=true,CanUseRevenueSchedule=true,Comments__c='test prod2',Product_Line__c=lin.id,RMU__c=true,Product_Number__c='12343345');
        insert prod1;
        
        Id pricebookId = Test.getStandardPricebookId();
        Id pricebookId1 = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = prod.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
         
        PricebookEntry customprice = new PricebookEntry(
        Pricebook2Id = pricebookId1, Product2Id = prod1.Id,
        UnitPrice = 20000, IsActive = true);
        insert customprice;
        
        Opportunity opp = new Opportunity();
        opp.Name='Test Opp unique name';
        opp.closedate=System.today();  
        opp.pricebook2id =pricebookid;
        opp.StageName='Prospecting';
        opp.ATR_Aircraft_Quantity__c =1;
        opp.Tech_Sales_Product_Area__c='APU';
        insert opp;
        
        OpportunityLineItem ooli = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id, TotalPrice=10, PriceBookEntryId=customprice.id); 
        insert ooli;
        String fieldNames ='Quantity, OpportunityId, TotalPrice, PriceBookEntryId';
        ProductRelated.getRecordList('DSC', fieldNames, 'OpportunityLineItem');
        ProductRelated.getRecordListWithAll('DSC', fieldNames, 'OpportunityLineItem', rec);
        ProductRelated.getRecordListWithId('DSC', fieldNames, 'OpportunityLineItem', rec);
    }
  }