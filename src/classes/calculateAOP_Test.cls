@isTest (seeAllData=true)
public class calculateAOP_Test {
    static testMethod void CAOP_Method1(){
        test.startTest();
        
        AOP_For_Sales_Manger__c afsm = new AOP_For_Sales_Manger__c();
        afsm.AOP_BGA_AM__c=1.0;
        afsm.Sales_Manager__c=UserInfo.getUserId();
        afsm.Opp_Closed_Won_Amount_for_RMU__c = 0;
        afsm.Pipeline_BGA_AM_Factored__c = 0;
        afsm.Pipeline_BGA_AM__c = 0;
        afsm.Pipeline_RMU__c = 0;
        afsm.Pipeline_RMU_Factored__c = 0;
        insert afsm;
        
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc;
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.ForecastCategoryName = 'Pipeline';
        opp.Ownerid = afsm.Sales_Manager__c;
        opp.recordtypeid='01230000000bN7l';
        opp.dealer_account__c='0013000000bFxtr';
        insert opp;
        
        
        Product2 pdt = [select id,Name from Product2 where Name='unknown' limit 1];
                
        PricebookEntry pb = [SELECT Id,Pricebook2Id,Product2Id FROM PricebookEntry where product2.name = 'unknown' limit 1];
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.opportunityid = opp.id;
        oli.Quantity = 20;
        oli.Revenue_Type__c = 'Engineering';
        oli.ServiceDate = system.today();
        oli.UnitPrice = 30;
        oli.Probability__c = 1;
        oli.Pricebookentryid = pb.id;
        insert oli;
        
        calculateAOP cap = new calculateAOP(afsm.Id,2015);
        cap.calculate();
        
        
        
        /*OpportunityLineItem oli = new OpportunityLineItem();
        oli.opportunityid=opp.Id;
        oli.Quantity=1.0;
        oli.totalPrice = 1.0;
        //oli.UnitPrice=10;
        oli.PricebookEntryId=pbe.Id;
        insert oli;
        */
        
        
        test.stopTest();
    }
}