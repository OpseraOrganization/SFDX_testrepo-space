@isTest(SeeAllData=true) 
private class Tstcls_CP_Feedback_Form_class { 
 static testMethod void Tstcls_CP_Feedback_Form_class1(){
     Test.StartTest();
     /*Account a = new Account();
     a.Name = 'Test Account';
     insert a;
     Platform__c p = new Platform__c();
     p.Name = 'Test Platform';
     case c = new case();
     c.AccountId = a.id;
     c.Repair_Facility__c = 'Test';
     c.Description = 'test';
     c.Aircraft_Type__c = p.id;
     c.Customer_Name__c = 'TestName';
     c.Requestor_Email_Address__c = 'abcdef@xyz.com';     
     //insert c;
     ApexPages.StandardController sc = new ApexPages.StandardController(c);
     CP_Feedback_Form_class1 cp = new CP_Feedback_Form_class1(sc);
     //PageReference pageRef = Page.CP_Feedback_Form;
     //pageRef.getParameters().put('id', String.valueOf(c.Id));
     
     
     //Test.setCurrentPage(pageRef);
     cp.savecase();
     Test.StopTest();

     
        /*PageReference pageRef1  = Page.CP_Feedback_Form;
        pageRef1.getParameters().put('EmailAddress','harikishore.vutukuri@honeywell.com');
             
        Test.setCurrentPage(pageRef1);
        
        Case cc = new Case();
        //cc.AccountId = 'NTT Offshore Test Account'; 
        //cc.Repair_Facility__c = 'Test'; 
        CP_Feedback_Form_class1 cpa = new CP_Feedback_Form_class1(new ApexPages.StandardController(cc));
     
        //CPAuthorization_class cpa = new CPAuthorization_class(new ApexPages.StandardController(cc));

        cpa.savecase();
        CaseSubmitCPEventclass  cassub = new CaseSubmitCPEventclass();
        cassub.closeform();
        //cpa.cancelform();*/
        PageReference pageRef1  = Page.CP_Feedback_Form;
        pageRef1.getParameters().put('Requestor_Email_Address__c','kayalvizhi.kandasamy@nttdata.com');
        Test.setCurrentPage(pageRef1);
        Case cc = new Case();
     //cc.Origin = 'Web';
     //cc.RecordType = [select Id from RecordType where Name = 'CP Events Record Type' and SobjectType = 'Case'];
     cc.Requestor_Email_Address__c = 'kayalvizhi.kandasamy@nttdata.com';
         system.debug('Case :'+cc);
        CP_Feedback_Form_class1 cpa = new CP_Feedback_Form_class1(new ApexPages.StandardController(cc));
        cpa.savecase();
        Test.StopTest();
    }
    static testMethod void Tstcls_CP_Feedback_Form_class2(){
        Test.StartTest();
        
        PageReference pageRef1  = Page.CP_Feedback_Form;
        pageRef1.getParameters().put('EmailAddress','harikishore.vutukuri@honeywell.com');
        
        Test.setCurrentPage(pageRef1);
        
        Case cc = new Case();
        
        //cc.Case_Record_Type__c = 'CP Events Record Type';
        
        //cc.AccountId = 'NTT Offshore Test Account'; 
        //cc.Repair_Facility__c = 'Test'; 
        CP_Feedback_Form_class1 cpa = new CP_Feedback_Form_class1(new ApexPages.StandardController(cc));
        //CPAuthorization_class cpa = new CPAuthorization_class(new ApexPages.StandardController(cc));        
        cpa.cancelform();
        PageReference pageRef2  = Page.CaseSubmitCPEvent;
        Test.setCurrentPage(pageRef2);
        CaseSubmitCPEventclass cs = new CaseSubmitCPEventclass();
        cs.closeform();
            
        Test.StopTest();
    }
    }