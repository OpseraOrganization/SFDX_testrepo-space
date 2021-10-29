@isTest(SeeAllData = true)
Private class TestCls_ApexTrgr_ErrorMessageOnNewDp{
    static testMethod void testMethod_ErrorMessageOnNewDp(){
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
        acc.REPORT_ACCOUNT_NAME__c='Hari';
        insert acc;
        
        Platform__c pf = new Platform__c();
        pf.Name = 'Test23';
        pf.Model__c = 'vnv';
        pf.Make__c = 'dfvd';
        insert pf;
        
        Opportunity opp = new Opportunity();
        opp.Name='Test';
        opp.Account = acc;
        opp.End_User__c = acc.id;
        opp.amount =55.00;
        opp.closedate = System.today();
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DSI';
        opp.CBT_Team_Tier_3__c = 'India Defense';
        opp.StageName = 'Prospecting';
        opp.Prime_Sub__c = 'Sub';
        opp.Revenue_Type__c = 'Eng';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'Domestic';
        opp.Platform__c = pf.id;
        opp.Incumbent__c = 'Incumbent';
        opp.Tech_Sales_Product_Area__c = 'AT';
        opp.RMU__c = 'Yes';
        insert opp;
        
        Discretionary_Plan__c dp = new Discretionary_Plan__c();
        dp.Year__c = '2012';
        dp.Opportunity__c = opp.Id;
        insert dp;
    }
}