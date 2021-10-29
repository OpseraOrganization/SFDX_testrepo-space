@isTest (seealldata = true)
private class CloneOpportunityProductTest {
    static testMethod void CloneOpportunityProductTest(){
        
     /*   Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        
        insert acc; */
        Account acc = [Select id from account where Type = 'OEM' limit 1];
        
       
          date testdate = date.parse('03/27/2011');
       /* 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex'].Id;
        opp.SBU__c = 'ATR';
        opp.CBT_Tier_2__c = 'Airbus';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Prime_Sub__c = 'Prime';
        opp.StageName = 'Cultivate';
        opp.CloseDate = testdate;
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.IC_Scorecard_Opportunity__c = false;
        insert opp;
        */
        string RecordType = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name like '%D&S PrePriced' limit 1].Id;
         opportunity opp = [Select id from opportunity where RecordTypeId =:RecordType limit 1];
        
        
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.UnitPrice = 100;
        oli.Quantity = 2;
        oli.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE and Pricebook2.id=:label.Standard_Price_Book_Id limit 1].Id;
        oli.OpportunityId = opp.Id;
        Test.StartTest();
        insert oli;
        //oli.UnitPrice = 100;
        
        
        //update oli;
           Test.StopTest();
        
        /*
        OpportunityLineItemSchedule olis = new OpportunityLineItemSchedule();
        olis.ScheduleDate = testdate;
        olis.Quantity = 2;
        olis.OpportunityLineItemId = oli.Id;
        olis.Type = 'Revenue';
        olis.Revenue = 1000;
        olis.Description = 'Test Method';
        insert olis;
        */
        ApexPages.currentPage().getParameters().put('id',oli.Id);
        CloneOpportunityProduct co = new CloneOpportunityProduct();
        ApexPages.StandardController con = new ApexPages.StandardController(oli);
        CloneOpportunityProduct cop = new CloneOpportunityProduct(con);
        //ApexPages.StandardController controller1 = new ApexPages.StandardController(cop); 
        cop.cloneOpportunityLineItem();
        cop.cloneOpportunityLineItemEdit();
         cop.save();
        //String oliID = oli.Id;

        //cop.cloneOpportunityLineItem();
        //ApexPages.CurrentPage().getParameters().put('id', voT.Id); 
        
        //cop.cloneOpportunityLineItem();
        //ApexPages.CurrentPage().getParameters().put('l', locT.Id);     
        //opp.Win_Loss_Reason_Text__c = 'executetestmethod';
        //update opp;
        //OpportunityLineItem oli = new OpportunityLineItem(pricebookentryid = '01u30000004b6etAAA', Quantity = 1, OpportunityId = '0063000000dw1WUAAY',unitprice = 2000);
        //insert oli;
        //pricebookentryid, hasrevenueschedule, createdbyid, lastmodifieddate, id, 
        //external_id__c, unitprice, description, plant__c, isdeleted, quantity, testend__c, 
        //extended_price__c, opportunityid, systemmodstamp, servicedate, listprice, hasschedule, 
        //price__c, createddate, subtotal, active__c, type__c, discount, sortorder, amount_net__c, 
        //description__c, probability__c, hasquantityschedule, lastmodifiedbyid'
        
         
        
       
         
    }
}