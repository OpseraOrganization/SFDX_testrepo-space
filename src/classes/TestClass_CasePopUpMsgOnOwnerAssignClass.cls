@isTest(SeeAllData=true)
private class TestClass_CasePopUpMsgOnOwnerAssignClass{ 
    static testMethod void TestClass_CasePopUpMsgOnOwnerAssignClass(){
        List<User> usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias = 'sadmin' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%WESTJET AIRLINES LTD%' limit 1];
        
        Contact con = new Contact();
        con.LastName = 'Testcon';
        con.FirstName = '112014';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'H287751'; 
        con.User_Primary_Manager_Name__c = usr[0].Primary_Manager_Name__c;   
        con.User_Primary_Manager_EID__c = usr[0].Primary_Manager_EID__c;     
        insert con;
        
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = con.Id;
        cs.RecordtypeId = label.Orders_Rec_ID;
        cs.Classification__c = 'CSO Spares';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.CaseOwnerChanged__c  = '005';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        //cs.OwnerId = usr[0].id;
        cs.OwnerId= usr[0].id;
        try{
            insert cs;
        }catch(DMLException e){}
        
        Test.StartTest(); 
        //cs.OwnerId = usr[1].id;
        cs.OwnerId = usr[0].id;
        cs.CaseOwnerChanged__c = '005';
        update cs;
        test.setCurrentPage(new PageReference('Page.CasePopUpMsgOnOwnerAssign')); 
        ApexPages.StandardController sc = new ApexPages.standardController(cs);
        ApexPages.currentPage().getParameters().put('id',cs.id);
        CasePopUpMsgOnOwnerAssignClass controller = new CasePopUpMsgOnOwnerAssignClass(sc);
        CasePopUpMsgOnOwnerAssignClass.getCase(cs.id);
        cs.CaseOwnerChanged__c  = '';
        update cs;
        Test.StopTest();
    }
    static testMethod void TestClass_CasePopUpMsgOnOwnerAssignClass1(){
        List<User> usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where  alias = 'sadmin' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%CHINA NATIONAL AERO TECHNOLOGY IMPORT & EXPORT CORP%' limit 1];
        
        Contact con = new Contact();
        con.LastName = 'Testcon';
        con.FirstName = '122014';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'H287751'; 
        con.User_Primary_Manager_Name__c = usr[0].Primary_Manager_Name__c;   
        con.User_Primary_Manager_EID__c = usr[0].Primary_Manager_EID__c;     
        insert con;
        
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = con.Id;
        cs.RecordtypeId = label.Orders_Rec_ID;
        cs.Classification__c = 'CSO Spares';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.CaseOwnerChanged__c  = '';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.OwnerId = usr[0].id;
        try{
            insert cs;
        }catch(DMLException e){}
        
        Test.StartTest(); 
        cs.OwnerId = usr[0].id;
        cs.CaseOwnerChanged__c = '005 CHINA NAT ACC';
        update cs;
        test.setCurrentPage(new PageReference('Page.CasePopUpMsgOnOwnerAssign')); 
        ApexPages.StandardController sc = new ApexPages.standardController(cs);
        ApexPages.currentPage().getParameters().put('id',cs.id);
        CasePopUpMsgOnOwnerAssignClass controller = new CasePopUpMsgOnOwnerAssignClass(sc);
        CasePopUpMsgOnOwnerAssignClass.getCase(cs.id);
        cs.CaseOwnerChanged__c  = '';
        update cs;
        Test.StopTest();
    }
}