/**
 * Created by Satya Mohanty on 9/25/2020.
 * OWNED BY THE CRM SALES TEAM.
 */
@isTest(SeeAllData=false)

private class BatchBGAOpptyUpdate_Test  {
    static testMethod void TestMthd_BatchBGAOpptyUpdate (){

        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;

        //Create an opportunity.
        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Prospecting';
        objOpporunity.SBU__c= 'BGA';
        objOpporunity.CloseDate = system.Today();
        Insert objOpporunity;


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
        PricebookEntry objPBEntry = new PricebookEntry(Pricebook2Id = pb2Standard.Id, Product2Id=objProduct.Id,
                                    UnitPrice=500,IsActive=true);
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

        objLineItem.SIOP_Forecast_ID__c = 'CTR 074';
        objLineItem.Probability__c=10;
        objLineItem.Forecast_Factor_AI__c =10;
        update objLineItem;
        Opportunity oppt = [SELECT Id,LastModifiedDate, PWin__c, CloseDate, Probability__c FROM Opportunity WHERE Id=:objOpporunity.Id];
        BatchBGAOpptyUpdate updatesiopproduct = new BatchBGAOpptyUpdate();
        Database.executeBatch(updatesiopproduct);        
    }
    testmethod static void TestMthd_BatchBGAOpptyUpdate1() {
        /*Test.startTest();
            Database.executeBatch(new BatchBGAOpptyUpdate(),10);
        Test.stopTest(); */
        Test.startTest();
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        BatchBGAOpptyUpdate alert1 = new BatchBGAOpptyUpdate();
        QL=alert1.start(BC);
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        List<SObject> SObjectList=new List<SObject>();
        while (QIT.hasNext()){
            SObject obje = (SObject)QIT.next();            
            SObjectList.add(obje);
        }               
        alert1.execute(BC, SObjectList);
        alert1.finish(BC);
        Test.stopTest();
    }
    testmethod static void TestMthd_BatchBGAOpptyUpdate2() {
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new BatchBGAOpptyUpdate());
        test.stopTest();
    }
}