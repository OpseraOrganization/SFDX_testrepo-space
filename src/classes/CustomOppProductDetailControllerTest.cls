@isTest 
private class CustomOppProductDetailControllerTest{
    static testMethod void validateCustomOppProductDetailController() {
        Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
      User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='honeywellstandarduser@testorg.com');
       Account objAccount = new Account();
      System.runAs(u) {
             //Create an account that is used for inserting opportunity.
            objAccount.Name = 'Test';
            Insert objAccount;
        }
        //Create an opportunity.
        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Closed Won';
        objOpporunity.CloseDate = system.Today();
        objOpporunity.Win_Loss_Reason_Text__c = 'Test';
        objOpporunity.Win_Loss_Reason_Code__c='Best Value Solution';
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
        
        OpportunityLineItem objLineItem = new OpportunityLineItem();
        objLineItem.PriceBookEntryId = objPBEntry.Id;
        objLineItem.OpportunityId = objOpporunity.Id;
        objLineItem.Quantity = 1;
        objLineItem.Unitprice = 500;
        objLineItem.M_PM_Product__c = crossRef.id; 
        objLineItem.M_PM_Product_Line__c = pliRec.id;
        Insert objLineItem;
        ApexPages.currentPage().getParameters().put('retURL','https://login.salesforce.com');
        ApexPages.StandardController sc = new ApexPages.StandardController(objLineItem);
        CustomOppProductDetailController copdc = new CustomOppProductDetailController(sc);
        copdc.deleteRec();
        copdc.save();
        copdc.cancel();
        copdc.passTest();
       // copdc.deleteScheduleRec;
    }
 }