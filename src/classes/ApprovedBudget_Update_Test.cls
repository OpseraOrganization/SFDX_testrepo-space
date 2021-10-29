@isTest(SeeAllData = true)
Private class ApprovedBudget_Update_Test{
    static testMethod void testMethod_ApprovedBudget_Update(){
        Account acc = new Account();
        acc.Name='Test';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Temporary';
        acc.Sub_Region_Name__c='Temporary';
        acc.Service_Level__c='Refer to Network';
        acc.Strategic_Business_Unit__c='BGA';
        acc.CBT__c='HBC';
        acc.CBT_Team__c='HBC';
        acc.Market_Name__c='General Aviation';
        acc.Business_Owner__c='Cohen, Gregg';
        acc.Type='Parent';
        acc.REPORT_ACCOUNT_NAME__c='Amita';
        insert acc;
        
        Platform__c pf = new Platform__c();
        pf.Name = 'Test23';
        pf.Model__c = 'vnv';
        pf.Make__c = 'dfvd';
        insert pf;
        
        Opportunity opp = [select id,CBT_Tier_2__c,SBU__c from Opportunity where SBU__c='D&S' and CBT_Tier_2__c='Sales Ops Adj' limit 1];
        Test.startTest();
        Discretionary_Plan__c dp = new Discretionary_Plan__c();
        dp.Year__c = '2012';
        dp.Opportunity__c = opp.Id;
        dp.Approved_Budget__c = 123;
        try{
            insert dp;
        }
        catch(Exception e){}
        Test.stopTest();
    }
}