@isTest
private  class Test_AOG_Red_Out_Report {

 static testmethod void testAOGRedOutReportPage(){
    
   Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
   Account acc= new Account(name='Test Account',Sales_Channel__c='EMEAI AM');
     insert acc;
     Contact con= new Contact(Lastname='Abc',accountid=acc.id);
     insert con;
      Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='24-hour',recordtypeId=RecId,ContactId=con.id,status='in progress',Next_Flight_Out_Date__c=System.TODAY()-1);
     insert cases; 
     Test.setCreatedDate(cases.id, DateTime.newInstance(2019,03,14));
     
     
     
     test.starttest();
          PageReference pageRef = Page.AOG_Red_Out_Report;
          Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(cases);
   AOGRedOut_cls caseCon= new AOGRedOut_cls(sc);
        
        
     caseCon.getAOGRedOutAerospace();
     System.debug( 'The List is:'+caseCon.getAOGRedOutAerospace().size());
     caseCon.getAOGRedOutAPACAM();
     caseCon.getAOGRedOutDivest();
     caseCon.getAOGRedOutElectronicSolutionsOE();
     
     caseCon.getserverUrl();
     caseCon.gethora();
     caseCon.getshowAerospace();
     caseCon.getshowAPACAM();
     caseCon.getshowDivest();
     caseCon.getshowElectronicSolutionsOE();
    
     
     test.stoptest();
     
    }
    
    static testmethod void testAOGRedOutReportPage1(){
    
   Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
   Account acc= new Account(name='Test Account',Sales_Channel__c='Aerospace');
     insert acc;
     Contact con= new Contact(Lastname='Abc',accountid=acc.id);
     insert con;
      Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='4-hour',recordtypeId=RecId,ContactId=con.id,status='in progress',Next_Flight_Out_Date__c=System.TODAY()-1);
     insert cases; 
     Test.setCreatedDate(cases.id, DateTime.newInstance(2019,03,14));
     
     
     
     test.starttest();
          PageReference pageRef = Page.AOG_Red_Out_Report;
          Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(cases);
   AOGRedOut_cls caseCon= new AOGRedOut_cls(sc);
        
        
     
     caseCon.getAOGRedOutAerospace();
     caseCon.getAOGRedOutAPACAM();
     caseCon.getAOGRedOutDivest();
     caseCon.getAOGRedOutElectronicSolutionsOE();
     
     caseCon.getserverUrl();
     caseCon.gethora();
     
     caseCon.getshowAerospace();
     caseCon.getshowAPACAM();
     caseCon.getshowDivest();
     caseCon.getshowElectronicSolutionsOE();
     
     
     test.stoptest();
     
    }
    /*static testmethod void testAOGRedOutReportPage2(){
    
   Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
   Account acc= new Account(name='Test Account',Sales_Channel__c='Electronic Solutions OE');
     insert acc;
     Contact con= new Contact(Lastname='Abc',accountid=acc.id);
     insert con;
      Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='48-hour',recordtypeId=RecId,ContactId=con.id,status='in progress',Next_Flight_Out_Date__c=System.TODAY()-1);
     insert cases; 
     Test.setCreatedDate(cases.id, DateTime.newInstance(2019,03,14));
     
     
     
     test.starttest();
          PageReference pageRef = Page.AOG_Red_Out_Report;
          Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(cases);
   AOGRedOut_cls caseCon= new AOGRedOut_cls(sc);
        
        
    
     caseCon.getAOGRedOutAerospace();
     caseCon.getAOGRedOutAPACAM();
     caseCon.getAOGRedOutDivest();
     caseCon.getAOGRedOutElectronicSolutionsOE();
     
     caseCon.getserverUrl();
     caseCon.gethora();
     caseCon.getshowAerospace();
     caseCon.getshowAPACAM();
     caseCon.getshowDivest();
     caseCon.getshowElectronicSolutionsOE();
     
     
     test.stoptest();
     
    }*/
    
    static testmethod void testAOGRedOutReportPage3(){
    
   Id RecId = [select Id from RecordType where SobjectType = 'Case' and (DeveloperName = 'AOG')].Id;
   Account acc= new Account(name='Test Account',Sales_Channel__c='Mechanical Systems & Components OE');
     insert acc;
     Contact con= new Contact(Lastname='Abc',accountid=acc.id);
     insert con;
      Case cases= new Case (AccountId=acc.Id,X4_Hour_AOG__c='N/A',recordtypeId=RecId,ContactId=con.id,status='in progress',Next_Flight_Out_Date__c=System.TODAY()-1);
     insert cases; 
     Test.setCreatedDate(cases.id, DateTime.newInstance(2019,03,14));
     
     
     
     test.starttest();
          PageReference pageRef = Page.AOG_Red_Out_Report;
          Test.setCurrentPage(pageRef);
     ApexPages.StandardController sc = new ApexPages.StandardController(cases);
   AOGRedOut_cls caseCon= new AOGRedOut_cls(sc);       
     
    
     caseCon.getAOGRedOutAerospace();
     System.debug( 'The List is:'+caseCon.getAOGRedOutAerospace().size());
     caseCon.getAOGRedOutAPACAM();
     caseCon.getAOGRedOutDivest();
     caseCon.getAOGRedOutElectronicSolutionsOE();
     
     caseCon.getserverUrl();
     caseCon.gethora();
     caseCon.getshowAerospace();
     caseCon.getshowAPACAM();
     caseCon.getshowDivest();
     caseCon.getshowElectronicSolutionsOE();
         
     test.stoptest();
     
    }
    }