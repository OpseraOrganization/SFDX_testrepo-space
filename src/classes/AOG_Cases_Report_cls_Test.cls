/*******************************************************************************
Name            :   AOG_Cases_Report_cls_Test 
Created By      :   NTT DATA
Company Name    :   NTT DATA
Project         :   <CSO Bundle Project - Req No 16 - D&S AOG MICAPS identification> 
Created Date    :   27-June-2017
Usages          :   Test Class for AOG Cases Report Cls
Modified By     :   NTT DATA
*******************************************************************************/
@isTest(SeeAllData = True)
private  class AOG_Cases_Report_cls_Test {
    static testmethod void testAOG_Cases_Report_cls(){       
        Id RecId = schema.sobjecttype.case.getRecordtypeInfosByName().get('AOG').getRecordtypeId();//FOUNDSNEHA
        Account acc= new Account(name='Test Account');
        insert acc;
        Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='24-hour',recordtypeId=RecId,Type='MICAP');
        insert cases;
        test.starttest();
        PageReference pageRef = Page.AOG_Cases_Report;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(cases);
        AOG_Cases_Report_cls  caseCon= new AOG_Cases_Report_cls(sc);
        caseCon.getMICAPAOGCasesRecords();
        caseCon.getserverUrl();
        caseCon.gethora();
        caseCon.getshowMICAPcases();    
        test.stoptest();       
    }
    static testmethod void testSPEX_Cases_Report_cls(){ //added for AOG/Spex Case Record Type Split      
        Id RecId = schema.sobjecttype.case.getRecordtypeInfosByName().get('Exchange').getRecordtypeId();//FOUNDSNEHA
        Account acc= new Account(name='Test Account');
        insert acc;
        Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='24-hour',recordtypeId=RecId,Type='MICAP');
        insert cases;
        test.starttest();
        PageReference pageRef = Page.AOG_Cases_Report;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(cases);
        AOG_Cases_Report_cls  caseCon= new AOG_Cases_Report_cls(sc);
        caseCon.getMICAPAOGCasesRecords();
        caseCon.getserverUrl();
        caseCon.gethora();
        caseCon.getshowMICAPcases();    
        test.stoptest();       
    }
}