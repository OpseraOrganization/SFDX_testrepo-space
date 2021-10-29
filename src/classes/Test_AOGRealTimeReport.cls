/** * File Name: Test_AOGRealTimeReport
* Description Test Method
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
Date            Version No.     Modified by     Brief Description of Modification
03 May 2018     1.0             NTT DATA        INC0000580048 - Added the code to remove AR report information                                               

* */ 
@isTest
private  class Test_AOGRealTimeReport {
    static testmethod void testAOGRealTimeReportPage(){
    
Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
     
     Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='BGA');
     insert acc;
     Contact con= new Contact(Lastname='Abc',accountid=acc.id);
     insert con;
    
     Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='24-hour',recordtypeId=RecId,ContactId=con.id,status='in progress',Next_Flight_Out_Date__c=System.TODAY()-1);
     insert cases;
     
     Case cases3= new Case (AccountId=acc.Id,X4_Hour_AOG__c='48-hour',AOG_Process_Type__c='Accelerated Repair',recordtypeId=RecId,ContactId=con.id,status='in progress',Next_Flight_Out_Date__c=System.TODAY()-1);
     insert cases3;
     
     System.debug('acc:'+acc.Strategic_Business_Unit__c);
      System.debug('SBU:'+cases.SBU__c);
        case c=[select id,SBU__c,AOG_Service_level_Value__c,CreatedDate from case where id=:cases.id];
         System.debug('StraBU:'+c.SBU__c);
        System.debug('Service Level value:'+c.AOG_Service_level_Value__c);
        System.debug('Record value:'+c.CreatedDate);
          PageReference pageRef = Page.AOGRealTimeReport;
          Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(cases);
   AOGRealTimeReport  caseCon= new AOGRealTimeReport();
    test.starttest();
     caseCon.getcases();
     caseCon.getcount();
     caseCon.getFourCount();
     caseCon.getTwentyFourCount();
     caseCon.getFourCountabove72();
     caseCon.getFourtyEightCount();
     caseCon.getFourtyEightCountabove72();
     caseCon.getTwentyFourCountabove72();
     caseCon.gettotalcount();
     caseCon.getsla4hr();
     caseCon.getsla24hr();
     caseCon.getsla48hr();
     caseCon.getQueryString();
     caseCon.getSelectedType();
     caseCon.getSelectedSite();
     caseCon.getSelectedSBU();
     CaseCon.getSelectedSub();
     caseCon.getMyRegions();
     caseCon.getMySBUs();
     caseCon.getMySubs();
     
system.debug('limitzzzzzzzz' +Limits.getQueries());
      

     caseCon.getMySite();
     caseCon.getAllTypes();
     caseCon.getontest();
     caseCon.SetFilters();
     caseCon.getSelectedReg();
     caseCon.getserverUrl();
     
     caseCon.getTechnicalCount();
     caseCon.getClosedTechnicalCount();
     
     caseCon.getcurrentId();
     caseCon.getscroll(); 
     caseCon.getAllCases();
     caseCon.getAll48Cases();
     caseCon.getcountclosed();
     caseCon.getAll4Cases();
     caseCon.scrollOff();
     caseCon.scrollOn();
     
     
     
    }
    
   
    static testmethod void testAOGRedOutReportPage(){
   Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
   Account acc= new Account(name='Test Account',Sales_Channel__c='Mechanical Systems & Components OE');
     insert acc;
     Contact con= new Contact(Lastname='Abc',accountid=acc.id);
     insert con;
      Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='24-hour',recordtypeId=RecId,ContactId=con.id,status='in progress',Next_Flight_Out_Date__c=System.TODAY()-1);
     insert cases;
     
          System.debug('acc1:'+acc.Strategic_Business_Unit__c);
          System.debug('SBU1:'+cases.SBU__c);
 
          PageReference pageRef = Page.AOG_Red_Out_Report;
          Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(cases);
   AOGRedOut_cls caseCon= new AOGRedOut_cls(sc);
        
 
    // caseCon.getAOGRedOutMechanicalSystemsComponentsOE();
   //  System.debug( 'The List is:'+caseCon.getAOGRedOutMechanicalSystemsComponentsOE().size());
     caseCon.getAOGRedOutAerospace();
     caseCon.getAOGRedOutAPACAM();
     caseCon.getAOGRedOutDivest();
     caseCon.getAOGRedOutElectronicSolutionsOE();
     //caseCon.getAOGRedOutAmericasAM();
    // caseCon.getAOGRedOutEMEAIAM();
                 
system.debug('limitzzzzzzzz' +limits.getqueries());
         test.starttest();
     //caseCon.getAOGRedOutEnginesPowerSystemsOE();
    // caseCon.getAOGRedOutServicesConnectivityOE();
     caseCon.getserverUrl();
     caseCon.gethora();
   //  caseCon.getshowMechanicalSystemsComponentsOE();

     caseCon.getshowAerospace();
     caseCon.getshowAPACAM();
     caseCon.getshowDivest();
     caseCon.getshowElectronicSolutionsOE();
    // caseCon.getshowAmericasAM();
     //caseCon.getshowEMEAIAM();
    // caseCon.getshowEnginesPowerSystemsOE();
   //  caseCon.getshowServicesConnectivityOE();
    // system.debug('limitzzzzzzzz' +limits.getqueries());
     test.stoptest();
     
    }
    
    
      static testmethod void testAOGRedOutReportPage2(){
    Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
     
     Account acc2= new Account(name='Test Account',Strategic_Business_Unit__c='ATR');
     insert acc2;
     
     Contact con2= new Contact(Lastname='Abc',accountid=acc2.id);
     insert con2;
     
     Case cases2= new Case (AccountId=acc2.Id,X4_Hour_AOG__c='24-hour',recordtypeId=RecId,ContactId=con2.id,status='in progress',Next_Flight_Out_Date__c=System.TODAY()-1);
     insert cases2;
    
    
     System.debug('acc2:'+acc2.Strategic_Business_Unit__c);
      System.debug('SBU:'+cases2.SBU__c);
        case c=[select id,SBU__c from case where id=:cases2.id];
         System.debug('StraBU:'+c.SBU__c);
     
          PageReference pageRef = Page.AOGRealTimeReport;
          Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(cases2);
   AOGRealTimeReport  caseCon= new AOGRealTimeReport();
     caseCon.getcases();
     caseCon.getcount();
     caseCon.getFourCount();
     caseCon.getTwentyFourCount();
     caseCon.getFourCountabove72();
     caseCon.getFourtyEightCount();
     caseCon.getFourtyEightCountabove72();
     caseCon.getTwentyFourCountabove72();
     caseCon.gettotalcount();
     caseCon.getsla4hr();
     caseCon.getsla24hr();
     caseCon.getsla48hr();
     caseCon.getQueryString();
     caseCon.getSelectedType();
     caseCon.getSelectedSite();
     caseCon.getSelectedSBU();
     test.starttest();
     CaseCon.getSelectedSub();
     caseCon.getMyRegions();
     caseCon.getMySBUs();
     caseCon.getMySubs();
     caseCon.getMySite();
     caseCon.getAllTypes();
     caseCon.getontest();
     caseCon.SetFilters();
     caseCon.getSelectedReg();
     caseCon.getserverUrl();
     system.debug('limitzzzzzzzz' +limits.getqueries());
      
    
     caseCon.getTechnicalCount();
     caseCon.getClosedTechnicalCount();
     
     caseCon.getcurrentId();
     caseCon.getscroll(); 
     caseCon.getAllCases();
     caseCon.getAll48Cases();
     caseCon.getcountclosed();
     caseCon.getAll4Cases();
     caseCon.scrollOff();
     caseCon.scrollOn();
     system.debug('limitzzzzzzzz' +limits.getqueries());
     
     test.stoptest();
     
    }
 
}