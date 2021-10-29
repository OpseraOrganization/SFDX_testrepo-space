/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_BGAContractUpdate
* Description           : Test Class to test the functionality of the trigger BGAContractUpdate
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 14-Nov-2013      0.1               NTTData               Initial Version
***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_BGAContractUpdate{
    static testMethod void TestClass_BGAContractUpdatetest(){  
        Account acc = new Account();
        acc.Name='Accountss2355';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Americas';
        acc.Sub_Region_Name__c='Africa';
        acc.Service_Level__c='Standard';
        acc.Strategic_Business_Unit__c='D&S';
        acc.CBT__c='Airbus';
        acc.CBT_Team__c='Airbus';
        acc.Market_Name__c='Air Transport';
        acc.Business_Owner__c='Ryan, Justin';
        acc.Type='Air Cargo Transporter';
        acc.REPORT_ACCOUNT_NAME__c='Test Reports2355';
        acc.Team_Member__c = '';
        acc.BGA_Contract_Test__c = false;
        acc.BGA_COntract__c = '';
        insert acc;
        
        Platform__c pf = new Platform__c();
        pf.Name = 'Test Platform';
        pf.Model__c = 'Test model';
        pf.Make__c = 'Test Make';
        pf.Platform_Type__c = 'Space';
        insert pf;
        
        Fleet_Asset_Aggregate__c fa = new Fleet_Asset_Aggregate__c();
        fa.Account_Name__c = acc.id;
        fa.BGA_Contract__c = true;
        fa.Status__c = 'Active';
        fa.Platform_Name__c = pf.Id;
        insert fa;
        
        test.startTest();
        acc.BGA_Contract_Test__c = true;
        update acc;
        test.stopTest();
    }
}