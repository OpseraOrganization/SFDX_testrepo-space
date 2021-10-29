@isTest(SeeAllData = true)
Public class Contract_AfterTrigger_classTest{
    Public static testmethod void testmethod1(){
       test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';        
        insert acc;
        
        contract  con = new contract();     
        con.Name = 'test';
        con.accountid=acc.id;
        con.Contract_3_months_Expiry__C=false;
        con.Contract_6_months_Expiry__C=false;
        con.MSP_Customer_Profile_Automation__c='Create Profile';
        //con.status='Active';
        insert con;
        con.Name = 'test1';
        con.Contract_3_months_Expiry__C=true;
        con.Contract_6_months_Expiry__C=true;
        con.MSP_Customer_Profile_Automation__c='Send Profile';
        update con;
        test.stopTest();
    }
    
}