/*******************************************************************************
Name                        : UpdateOppProductFldTriggerTestClass 
Created By                  : Haritha Lekkala
Company Name                : HoneyWell
Project                     : Aero Sales  
Created Date                : 3/11/2017    
Usages                      : This is a test class that will do the test coverage for trigger UpdateOppProductFld
Modification History        :
Date            Version No.     Modified by     Brief Description of Modification


*******************************************************************************/
@isTest
private class UpdateOppProductFldTriggerTestClass{
    static testMethod void testUpdateOppProductFldTrigger(){
        //Create an account that is used for inserting opportunity.
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        
        insert objAccount;
        
        //Create an opportunity.
        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Launch';
        objOpporunity.CloseDate = system.Today();
        objOpporunity.Program_Go_Probability__c = 30.00;
        objOpporunity.ATR_Probability__c = 10.0;
        insert objOpporunity;
        system.debug('After insert opp id:'+objOpporunity.id);
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
        
        PriceBook2 pb2Standard = [select Id from Pricebook2];
        PricebookEntry objPBEntry = new PricebookEntry(Pricebook2Id = pb2Standard.Id, Product2Id=objProduct.Id,UnitPrice=500,IsActive=true);
        Insert objPBEntry;
        
        //Insert Product_Line_Item__c record to use in Product Line Item Cross Reference
        Product_Line__c pliRec = new Product_Line__c(name='test');
        insert pliRec;
        
        //Insert Product Line Item Cross Reference that should be used in Opportunity Line Item
        Product_Line_Cross_Ref__c crossRef = new Product_Line_Cross_Ref__c();
        crossRef.Product_Line__c = pliRec.id;
        insert crossRef;
        Test.StartTest();
        OpportunityLineItem objLineItem = new OpportunityLineItem();
        objLineItem.PriceBookEntryId = objPBEntry.Id;
        objLineItem.OpportunityId = objOpporunity.Id;
        objLineItem.Quantity = 1;
        objLineItem.Unitprice = 500;
        objLineItem.Probability__c = 20;
        
        objLineItem.M_PM_Product__c = crossRef.id; 
        objLineItem.M_PM_Product_Line__c = pliRec.id;
        insert objLineItem;
        //update objLineItem;
        
        Opportunity oppRec = [select id,Program_Go_Probability__c,ATR_Probability__c,Combined_Probability__c from Opportunity where id=:objOpporunity.id];
        oppRec.Program_Go_Probability__c = 100.00;
        oppRec.ATR_Probability__c = 100.0;
        system.debug('oppRec old:'+oppRec.Combined_Probability__c);
        update oppRec;
        
        OpportunityProductLineHelper oplh = new OpportunityProductLineHelper();
        Set<String> oppId = new Set<String>();
        oppId.add(oppRec.id);
        oplh.updateLineItemCount(oppId);
        
        Opportunity_Product_Line__c opLc = new Opportunity_Product_Line__c();
        opLc.Opportunity__c = objOpporunity.id;
        insert opLc;
        
        oppId = new Set<String>();
        oppId.add(objOpporunity.id);
        oplh.updateLineItemCount(oppId);
        oplh.updateLineItemCount(null);
        oppId = new Set<String>();
        oplh.updateLineItemCount(oppId);
        
        delete opLc;
        undelete opLc;
        Test.StopTest();
    }
}