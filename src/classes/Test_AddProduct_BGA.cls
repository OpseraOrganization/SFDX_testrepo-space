@isTest(SeeAllData=true)
private class Test_AddProduct_BGA
{
    static testMethod void AddProduct_BGATest()
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
        
        PageReference pageRef = Page.AddOpportunityProduct_VF;
        pageRef.getParameters().put('Opportunityid', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        PageReference pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
        PageReference pageRef3 = Page.AddProduct_BGA;
        pageRef3.getParameters().put('id', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef3);
        sc = new ApexPages.StandardController(opp);
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
        AddProduct_BGA oppPd3 = new AddProduct_BGA(sc);
        oppPd3.exceptionOccurred= false;
        oppPd3.exceptionMessage = null;
        oppPd3.toUnselect= '';
        oppPd3.Total = 0.0;
        oppPd3.Editpage();
        oppPd3.updateAvailableList();
        oppPd3.matchProduct();  
        oppPd3.onSave();
        oppPd3.onSave1();
        oppPd3.onCancel();
        oppPd3.changePricebook();
     }    
     
         static testMethod void AddProduct_BGATestPriceBookNull()
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
        //opp.pricebook2id =pricebookid;
        opp.StageName='Prospecting';
        opp.ATR_Aircraft_Quantity__c=1;
        opp.Tech_Sales_Product_Area__c='APU';
        insert opp;
        
        PageReference pageRef = Page.AddOpportunityProduct_VF;
        pageRef.getParameters().put('Opportunityid', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        AddOpportunityProduct oppPdt = new AddOpportunityProduct(sc);    
        oppPdt.Editpage();
        //oppPdt.save();
        oppPdt.Cancel();      
        PageReference pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
         Test.setCurrentPage(pageRef2);
        AddOpportunityProduct_ATR oppPdt2 = new AddOpportunityProduct_ATR(sc);    
        oppPdt2.Editpage();
        //oppPdt.save();
        //oppPdt2.updateAvailableList();
        //oppPdt2.matchProduct();
        oppPdt2.onSave();
        oppPdt2.OnCancel();
        oppPdt2.changePricebook();
         
        PageReference pageRef3 = Page.AddProduct_BGA;
        pageRef3.getParameters().put('id', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef3);
        sc = new ApexPages.StandardController(opp);
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
        AddProduct_BGA oppPd3 = new AddProduct_BGA(sc);
        oppPd3.Editpage();
        Product2 productSelect = [select id,Default_plant_code__c from Product2 where Default_plant_code__c<>null limit 1];       
        oppPd3.olItem.Plant__c = productSelect.Default_plant_code__c;
        oppPd3.olItem.M_PM_Product__c = productSelect.id;
        oppPd3.onSave();
        oppPd3.onSave1();
         
     } 
     
         static testMethod void AddProduct_BGATestPriceBookNull2()
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
        //opp.pricebook2id =pricebookid;
        opp.StageName='Prospecting';
        opp.ATR_Aircraft_Quantity__c=1;
        opp.Tech_Sales_Product_Area__c='APU';
        insert opp;
        
        PageReference pageRef = Page.AddOpportunityProduct_VF;
        pageRef.getParameters().put('Opportunityid', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        PageReference pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
        PageReference pageRef3 = Page.AddProduct_BGA;
        pageRef3.getParameters().put('id', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef3);
        sc = new ApexPages.StandardController(opp);
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
        AddProduct_BGA oppPd3 = new AddProduct_BGA(sc);
        oppPd3.Editpage();
        Product2 productSelect = [select id,Default_plant_code__c from Product2 where Default_plant_code__c<>null limit 1];       
        oppPd3.olItem.Plant__c = productSelect.Default_plant_code__c;
        oppPd3.olItem.M_PM_Product__c = null;
        oppPd3.olItem.pricebookentryid = customprice.id;
        
        oppPd3.onSave();
        oppPd3.onSave1();
         
     } 
     
              static testMethod void AddProduct_BGATestPriceBookNull3()
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
        //opp.pricebook2id =pricebookid;
        opp.StageName='Prospecting';
        opp.ATR_Aircraft_Quantity__c=1;
        opp.Tech_Sales_Product_Area__c='APU';
        insert opp;
        
        PageReference pageRef = Page.AddOpportunityProduct_VF;
        pageRef.getParameters().put('Opportunityid', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        PageReference pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
        PageReference pageRef3 = Page.AddProduct_BGA;
        pageRef3.getParameters().put('id', String.valueOf(opp.Id)); 
        pageRef3.getParameters().put('rid', '01230000000ZQCb');
        Test.setCurrentPage(pageRef3);
        sc = new ApexPages.StandardController(opp);
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
        
        
        AddProduct_BGA oppPd3 = new AddProduct_BGA(sc);
        
        oppPd3.Editpage();
        Product2 productSelect = [select id,Default_plant_code__c from Product2 where Default_plant_code__c<>null limit 1];       
        oppPd3.olItem.Plant__c = null;
        oppPd3.olItem.M_PM_Product__c = null;
        oppPd3.olItem.pricebookentryid = customprice.id;
        oppPd3.onSave();
        oppPd3.onSave1();
         
        
     } 
     
     
   
       static testMethod void AddProduct_BGATestPriceBookNull4()
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
              
         Opportunity opp = new Opportunity();
        //opp.RecordType=rec;
        opp.RecordTypeId=rec;
        opp.Name='Test Opp unique name';
        opp.closedate=System.today();
        //opp.pricebook2id='01s300000002R2lAAE';

        opp.StageName='Prospecting';
        opp.ATR_Aircraft_Quantity__c =1;
        opp.Tech_Sales_Product_Area__c='APU';
        insert opp;
        
        PageReference pageRef = Page.AddOpportunityProduct_VF;
        pageRef.getParameters().put('Opportunityid', String.valueOf(opp.Id)); 
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        AddOpportunityProduct oppPdt = new AddOpportunityProduct(sc);    
        oppPdt.Editpage();
        //oppPdt.save();
        oppPdt.Cancel();        
        
        //ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        PageReference pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opp.Id)); 
        pageRef2.getParameters().put('rid', '01230000000ZQCb'); 
        Test.setCurrentPage(pageRef2);
        AddOpportunityProduct_ATR oppPdt2 = new AddOpportunityProduct_ATR(sc);   
        oppPdt2.exceptionMessage = null; 
        oppPdt2.Editpage();
        /* OpportunityLineItem olItem1=new OpportunityLineItem();
        olItem1.OpportunityId=opp.id;
        olItem1.Quantity=20;
        insert olItem1; */
        Product2 productt = [select id,default_plant_code__c from product2 where default_plant_code__c<>null limit 1];
        oppPdt2.olitem.M_PM_Product__c = productt.id;
        oppPdt2.olitem.pricebookentryid = Test.getStandardPricebookId();
        oppPdt2.olitem.Plant__c= productt.default_plant_code__c;
        oppPdt2.onSave();
         oppPdt2.onSave1();
   
     AddProduct_BGA oppPd3 = new AddProduct_BGA(sc);
        
        oppPd3.Editpage();
        Product2 productSelect = [select id,Default_plant_code__c from Product2 where Default_plant_code__c<>null limit 1];       
        oppPd3.olItem.Plant__c = null;
        oppPd3.olItem.M_PM_Product__c = null;
       // oppPd3.olItem.pricebookentryid = customprice.id;
        oppPd3.onSave();
        oppPd3.onSave1();
         
      
    }   
}