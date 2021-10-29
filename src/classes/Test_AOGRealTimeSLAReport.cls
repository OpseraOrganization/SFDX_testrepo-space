/** * File Name: Test_AOGRealTimeSLAReport
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
@isTest
private  class Test_AOGRealTimeSLAReport {
    static testmethod void testAOGRealTimeSLAReportPage(){
    
Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
      Account acc= new Account(name='Test Account');
     insert acc;
     Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='4-hour',recordtypeId=RecId);
     insert cases;
          PageReference pageRef = Page.AOGRealTimeSLAReport;
          Test.setCurrentPage(pageRef);
     //ApexPages.StandardController sc = new ApexPages.StandardController(cases);
   AOGRealTimeSLAReport  caseCon= new AOGRealTimeSLAReport();
     caseCon.getcases();
     caseCon.getcount();
     caseCon.getFourCount();
     caseCon.getTwentyFourCount();
     caseCon.getFourCountabove72();
     caseCon.getTwentyFourCountabove72();
     caseCon.gettotalcount();
     caseCon.getsla4hr();
     caseCon.getsla24hr();
     caseCon.getcurrentId();
     caseCon.getAllCases();
     caseCon.getAll4Cases();
    }
}