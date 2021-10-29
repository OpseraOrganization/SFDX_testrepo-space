@isTest
private class TechnicalIssueControllerTest {
    /*
    static testMethod void myUnitTest() 
    {       
        Test.startTest();       
        PageReference pageRef = Page.TechnicalIssue_Page;
        pageRef.getParameters().put('RecordType','01230000000ZJvU');
        Test.setCurrentPage(pageRef);
        
        Case c1 = new Case();
        ApexPages.StandardController con = new ApexPages.StandardController(c1);
        //Field_Event__c fer= new Field_Event__c(Field_Event_Report__c=true,Case_Number__c=c1.CaseNumber,Engine_APU_Reported_S_N__c='123');
        //insert fer;
        TechnicalIssueController tic= new TechnicalIssueController (con);
        tic.c.FCR__c='No';
        tic.c.No_FCR_Reason__c='Credit Issue';
        //tic.fe.Field_Event_Report__c=true;
        //tic.fe.id=fer.id;
        tic.DateTime_Of_AOG = System.now();
        tic.save1();
        Test.stopTest();
    }
    static testMethod void myUnitTest1() 
    {
        Test.startTest();
        Case c=new Case();
        c.FCR__c='No';
        c.No_FCR_Reason__c='Credit Issue';
        c.RecordTypeId = label.TechnicalIssue_RecordTypeID;
        
        insert c;
        
        PageReference pageRef1 = Page.TechnicalIssue_Page;
        pageRef1.getParameters().put('Id',c.Id);
        pageRef1.getParameters().put('type','Edit');
        Test.setCurrentPage(pageRef1);
        ApexPages.StandardController con1 = new ApexPages.StandardController(c);
        TechnicalIssueController tic1= new TechnicalIssueController (con1);
        
        tic1.edit1();
        tic1.save1();
        
        
        PageReference pageRef2 = Page.TechnicalIssue_Page;
        pageRef2.getParameters().put('Id',c.Id);
        pageRef2.getParameters().put('type','Clone');
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController con2 = new ApexPages.StandardController(c);
        TechnicalIssueController tic2= new TechnicalIssueController (con2);
        
        tic2.clone1();
        //tic.closecase();
        
        //tic.cancelcase(); 
        Test.stopTest();
    }*/
}