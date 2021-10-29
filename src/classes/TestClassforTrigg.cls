@isTest
private class TestClassforTrigg {

   public static testMethod void testocc()
   {
   
        Test.startTest();
       
        Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='BGA';
        insert pf;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
       
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        insert acc;
        
       Opportunity opp=new Opportunity();
       
        opp.Satcom_Direct_Customer__c='Yes';
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
          
        insert opp;
       
        opp.Sales_Type__c='Completion';
        opp.Satcom_Direct_Customer__c='No';
        
        update opp;
       
        Test.stopTest(); 
   }
}