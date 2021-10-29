/*******************************************************************************
Name                        : UpdateproductProductLineTriggerTestClass 
Created By                  : Haritha Lekkala
Company Name                : HoneyWell
Project                     : Aero Sales  
Created Date                : 2/15/2017    
Usages                      : This is a test class that will do the test coverage for trigger UpdateProductProductLine
Modification History        :
Date            Version No.     Modified by     Brief Description of Modification


*******************************************************************************/
@isTest
private class UpdateproductProductLineTriggerTestClass{
    static testMethod void testUpdateproductTrigger(){
        //Create an account that is used for inserting opportunity.
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;
        
        //Create an opportunity.
        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Closed Won';
        objOpporunity.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        objOpporunity.CloseDate = system.Today();
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
        
        //Insert Product Line Item Cross Reference that should be used in Opportunity Line Item
        Product_Line_Cross_Ref__c crossRef = new Product_Line_Cross_Ref__c();
        crossRef.Product_Line__c = pliRec.id;
        insert crossRef;
        
        RMU_VALUE__c rmuval = new RMU_VALUE__c();
        insert rmuval;
        RMU_Product__c rmuProd = new RMU_Product__c();
        rmuProd.RMU_Product__c = objProduct.id;
        rmuProd.RMU__c = rmuval.id;
        rmuProd.RMU_Product_Primary__c = true;
        insert rmuProd;
        
        OpportunityLineItem objLineItem = new OpportunityLineItem();
        objLineItem.PriceBookEntryId = objPBEntry.Id;
        objLineItem.OpportunityId = objOpporunity.Id;
        objLineItem.Quantity = 1;
        objLineItem.Unitprice = 500;
        objLineItem.M_PM_Product__c = crossRef.id; 
        objLineItem.M_PM_Product_Line__c = pliRec.id;
        Test.startTest();
        insert objLineItem;
        Test.stopTest();
        
        
        objLineItem.M_PM_Product__c = null;
        objLineItem.M_PM_Product_Line__c = null;
        update objLineItem;
        
       
              
    }
}