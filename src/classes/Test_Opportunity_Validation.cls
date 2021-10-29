@isTest(SeeAllData=true)
private class Test_Opportunity_Validation {
static testMethod void myUnitTest() {

            /*Account acc = new Account();
            acc.Name = 'Honeywell Test';
            acc.Customer_Status__c = 'Active';
            acc.Strategic_Business_Unit__c = 'D&S';
            acc.CBT__c = 'DAA';
            acc.Region_Name__c = 'Americas';
            acc.Sub_Region_Name__c = 'Canada';
            acc.Service_Level__c = 'Standard';
            acc.Type = 'OEM';
            acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';       
            insert acc;*/       
           
            Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];

            Opportunity opp = new Opportunity();
            opp.Name = 'Test Method Opportunity';
            opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp.SBU__c = 'D&S';
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'OE Complex';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';
            opp.SBU__c = 'D&S';      
             insert opp;

            OpportunityLineItem oli = new OpportunityLineItem();
            oli.Quantity = 2;
            oli.TotalPrice  = 200;
            oli.pricebookentryid = [Select Id from PricebookEntry where IsActive=TRUE limit 1].Id;
            oli.OpportunityId = opp.Id;
            oli.Type__c = 'Booked'; 
            oli.Solution_Type__c ='RMU';
            oli.Revenue_Type__c = 'License';
            insert oli; 
            OpportunityLineItemSchedule oliSchedule = new OpportunityLineItemSchedule();
            oliSchedule.OpportunityLineItemId=oli.id;
            oliSchedule.Quantity = 4;
            oliSchedule.ScheduleDate=System.today();
            oliSchedule.Revenue=40;
            oliSchedule.Type='Both';
             
               
            Opportunity oppUpdt = new Opportunity(id=opp.id);
                        
            Test.StartTest(); 
                      
            try{
            insert oliSchedule;
            }catch(DMLException e){}
            update oppUpdt;
            Test.stopTest();        
        
 }
}