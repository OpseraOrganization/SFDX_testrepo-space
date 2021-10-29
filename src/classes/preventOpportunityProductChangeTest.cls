@isTest(SeeAllData=true)
private class preventOpportunityProductChangeTest {
    static testMethod void preventOpportunityProductChangeTest(){
   
        Account acc = new Account(
            Name = 'Test Account'            
        );
        //insert acc;
        
        Platform__c pltFrm = new Platform__c(name='Test Platform');
        
        //insert pltFrm;
        //INSERT MAKE AND MODEL
        Fleet_Asset_Detail__c make=new Fleet_Asset_Detail__c(
        name='<Make> <Model> T=2582 S=145-00495',
        Account__c=acc.id, Platform_Name__c=pltFrm.id
        );
        //insert make;
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];

        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        //insert pbk1;
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
        //insert prd1;

        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        //insert pbe1;
        
        
         Test.startTest();
        //Opportunity opp1 = new Opportunity (Name='Opp1',recordtypeid = '01230000000bN7l',StageName='Prospecting',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Tech_Sales_Product_Area__c = 'APU');
        //insert opp1;
        Opportunity opp1 =[select id from Opportunity where recordtypeid = '01230000000bN7l' limit 1];
        //system.debug('pbe1 product Name:'+pbe1.Product2.Name);
        OpportunityLineItem itemRec = [select id,OpportunityID,Opportunity.AccountID,PriceBookEntryID from OpportunityLineItem  where Opportunity.recordtypeid='01230000000bN7l' limit 1];
        pbe1 = [select Product2ID,id,Product2.Name from PricebookEntry where id=:itemRec.PriceBookEntryID and isActive=true limit 1]; 
        Opportunity opp2 =[select id from Opportunity where id != :itemRec.OpportunityID and AccountId =:itemRec.Opportunity.AccountID limit 1];
        
        CustomerStory__c cs = new CustomerStory__c();
        cs.Product__c = pbe1.Product2ID;
        cs.Related_Opportunity__c = opp2.id;
        insert cs;
        
        OpportunityLineItem lineItem1 = new OpportunityLineItem 
        (OpportunityID=itemRec.OpportunityID,PriceBookEntryID=pbe1.id, quantity=4,totalprice=200,Type__c='APO');
        insert lineItem1;
        lineItem1.type__c='Booked';
        update lineItem1;
         Test.stopTest();
    }
        static testMethod void preventOpportunityProductChangeTest1(){
   
        Account acc = new Account(
            Name = 'Test Account'            
        );
        //insert acc;
        
        Platform__c pltFrm = new Platform__c(name='Test Platform');
        
        //insert pltFrm;
        //INSERT MAKE AND MODEL
        Fleet_Asset_Detail__c make=new Fleet_Asset_Detail__c(
        name='<Make> <Model> T=2582 S=145-00495',
        Account__c=acc.id, Platform_Name__c=pltFrm.id
        );
        //insert make;
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];

        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        //insert pbk1;
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
        //insert prd1;

        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        //insert pbe1;
        
        
         Test.startTest();
        //Opportunity opp1 = new Opportunity (Name='Opp1',recordtypeid = '01230000000bN7l',StageName='Prospecting',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Tech_Sales_Product_Area__c = 'APU');
        //insert opp1;
        Opportunity opp1 =[select id from Opportunity where recordtypeid = '01230000000bN7l' limit 1];
        //system.debug('pbe1 product Name:'+pbe1.Product2.Name);
        OpportunityLineItem itemRec = [select id,OpportunityID,Opportunity.AccountID,PriceBookEntryID from OpportunityLineItem  where Opportunity.recordtypeid='01230000000bN7l' limit 1];
        pbe1 = [select Product2ID,id,Product2.Name from PricebookEntry where id=:itemRec.PriceBookEntryID and isActive=true limit 1]; 
        Opportunity opp2 =[select id from Opportunity where id != :itemRec.OpportunityID and AccountId =:itemRec.Opportunity.AccountID limit 1];
        
        CustomerStory__c cs = new CustomerStory__c();
        cs.Product__c = pbe1.Product2ID;
        cs.Related_Opportunity__c = opp2.id;
        insert cs;
        
        OpportunityLineItem lineItem1 = new OpportunityLineItem 
        (OpportunityID=itemRec.OpportunityID,PriceBookEntryID=pbe1.id, quantity=4,totalprice=200);
        insert lineItem1;
        lineItem1.quantity=3;
        update lineItem1;
        Test.stopTest();    
    }
}