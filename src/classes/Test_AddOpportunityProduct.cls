@isTest(SeeAllData=true)
private class Test_AddOpportunityProduct
{
    static testMethod void addOpportunityProductTest()
    {  
    
         //RecordType rec = [select id from recordtype where name = 'Catalog'];
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
        //opp.RecordType=rec;
        opp.RecordTypeId=rec;
        opp.Name='Test Opp unique name';
        opp.closedate=System.today();
        //opp.pricebook2id='01s300000002R2lAAE';
        opp.pricebook2id =pricebookid;
        opp.StageName='Prospecting';
        opp.ATR_Aircraft_Quantity__c =1;
        opp.Tech_Sales_Product_Area__c='APU';
        insert opp;
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        sc = new ApexPages.StandardController(opp);
        
        PageReference pageRef = Page.AddOpportunityProduct_VF;
        pageRef.getParameters().put('Opportunityid', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef);
        AddOpportunityProduct ap = new AddOpportunityProduct(sc);
        ap.Editpage();
        ap.save();
       ap.saveNewF();
        ap.Cancel();
    }
    static testMethod void addOpportunityProductTest1()
    {  
    
         //RecordType rec = [select id from recordtype where name = 'Catalog'];
        ID rec = label.D_S_PrePriced;
            Product_Line__c lin = new Product_Line__c   (Name='test');
        insert lin;
        
        Product2 prod = new Product2(Name = 'Laptop X200',
        Family = 'Hardware',IsActive=true,Description='test',CanUseQuantitySchedule=true,CanUseRevenueSchedule=true,Comments__c='test',Product_Line__c=lin.id,RMU__c=false,Product_Number__c='12345');
        insert prod;
        Plant_Code_Master__c pc=[select id from Plant_Code_Master__c limit 1];
        Product2 prod1 = new Product2(Name = 'Laptop X200',
        Family = 'Hardware',IsActive=true,Default_plant_code__c=pc.id,Description='test prod 2',CanUseQuantitySchedule=true,CanUseRevenueSchedule=true,Comments__c='test prod2',Product_Line__c=lin.id,RMU__c=true,Product_Number__c='12343345');
        insert prod1;
        
        Id pricebookId = Test.getStandardPricebookId();
        Id pricebookId1 = Test.getStandardPricebookId();
        
     
        Opportunity opp = new Opportunity();
        //opp.RecordType=rec;
        opp.RecordTypeId=rec;
        opp.Name='Test Opp unique name';
        opp.closedate=System.today();
        //opp.pricebook2id='01s300000002R2lAAE';
        opp.pricebook2id =pricebookid;
        opp.StageName='Prospecting';
        opp.ATR_Aircraft_Quantity__c =1;
        opp.Tech_Sales_Product_Area__c='APU';
        insert opp;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        sc = new ApexPages.StandardController(opp);
        
        PageReference pageRef = Page.AddOpportunityProduct_VF;
        pageRef.getParameters().put('Opportunityid', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef);
        AddOpportunityProduct ap = new AddOpportunityProduct(sc);
        ap.Editpage();
        ap.save();
        ap.saveNewF();
        ap.Cancel();
    }
  }