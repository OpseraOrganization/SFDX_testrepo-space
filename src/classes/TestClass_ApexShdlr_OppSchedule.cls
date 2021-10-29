/** * File Name:  TestClass_ApexShdlr_OppSchedule
* Description Test Method
* Class Tested: OppSchedule 
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
@isTest
private class TestClass_ApexShdlr_OppSchedule {

    static testMethod void oppScheduleTest() {
        
        Profile pf = [select name from Profile where name = 'System Administrator'];
            User testUser = new User(FirstName = 'Trigger', LastName = 'Test User',Username = 'triggertstuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
                'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
            insert testUser;
            
        AOP_For_Sales_Manger__c tstAOPForSalesMngr= new AOP_For_Sales_Manger__c(
         AOP_Year__c = '2011',
         Sales_Manager__c=testUser.Id
        );
        
        insert tstAOPForSalesMngr;
        /*
        Opportunity tstOpp = new Opportunity(
            Name='Test Opp',
            ownerid=testUser.id,
            amount =100.00,
            Type = 'OCM Programs' ,
            closedate = System.today(),
            ForecastCategoryName = 'Pipeline'
        
        );   
        insert tstOpp;
        
       
        Opportunity tstOpp2 = new Opportunity(
            Name='Test Opp2',
            ownerid=testUser.id,
            amount =100.00,
            Type = 'OCM Programs' ,
            closedate = System.today(),
            ForecastCategoryName = 'Pipeline',
            Probability=10.0 
        
        );   
        insert tstOpp2;
        Product2 tstProduct2 = new Product2(name='Test Product2');
        insert tstProduct2;
        Pricebook2 tstPriceBook = [select id from Pricebook2 where IsStandard = true limit 1];       
        PricebookEntry tstPriceBkEntry = new PricebookEntry(product2id = tstProduct2.Id, UnitPrice=10.00 , Pricebook2Id=tstPriceBook.Id ,  IsActive=TRUE, UseStandardPrice=false); 
        insert tstPriceBkEntry;
        OpportunityLineItem tstOppLnItem = new OpportunityLineItem (OpportunityId = tstOpp2.Id , Quantity=10.00,TotalPrice=100.00, PricebookEntryId=tstPriceBkEntry.Id);
        insert tstOppLnItem;
        
        */
        Opportunity tstOpp3 = new Opportunity(
            Name='Test Opp2',
            ownerid=testUser.id,
            amount =100.00,
            Type = 'OCM Programs' ,
            closedate = System.today(),
            ForecastCategoryName = 'Pipeline',
            StageName='Prospecting',
            ATR_Aircraft_Quantity__c=1,
            Probability=10.0
        
        ); 
           
        insert tstOpp3;
        Product2 tstProduct3 = new Product2(name='Test Product3', RMU__c=true,
        CanUseRevenueSchedule=true
        );
        insert tstProduct3;
        Pricebook2 tstPriceBook3 = [select id from Pricebook2 where IsStandard = true limit 1];      
        PricebookEntry tstPriceBkEntry3 = new PricebookEntry(product2id = tstProduct3.Id, UnitPrice=10.00 , Pricebook2Id=tstPriceBook3.Id ,  IsActive=TRUE, UseStandardPrice=false); 
        insert tstPriceBkEntry3;
        OpportunityLineItem tstOppLnItem3 = new OpportunityLineItem (OpportunityId = tstOpp3.Id , Quantity=10.00,TotalPrice=100.00, PricebookEntryId=tstPriceBkEntry3.Id
             );
        insert tstOppLnItem3;
       
         Test.startTest();
        OpportunityLineItemSchedule tstOppLnItemShd = new OpportunityLineItemSchedule (
        OpportunityLineItemId =tstOppLnItem3.Id,
        Revenue=5000.00,
        type='Revenue',
        scheduledate=system.today()
        );
        insert tstOppLnItemShd;
        
       
            DateTime tstDateTime = System.now();
             oppschedule tstOppSchd = new oppschedule(tstDateTime.year());
            String Shdlr='0 0 23 * * ?';  
            System.schedule('Test OppSchedule  Scheduling',Shdlr,tstOppSchd);
        Test.stoptest(); 
        
         
    }
}