@isTest
private class limitrecordsTest{
    static testMethod void myUniTest(){
        Test.startTest();
        List<Case> cases=new List<Case>();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test';
        acc.Market_Name__c = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Dhivya';
        con.FirstName = 'Test';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'test.dhivya@123.com';
        con.Email='test.dhivya@123.com';
        con.Employee_Number__c = 'E000003';
        insert con; 
        
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = con.Id;
        cs.RecordtypeId = label.Account_WebForm_Creation_RecordType;
        cs.Classification__c = 'EMS';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        insert cs;
        
        Case_Extension__c cxe = new Case_Extension__c();
        cxe.case_object__c=cs.id;
        cxe.Record_Code__c='None';
        cxe.Record_Class__c='None';
        cxe.Record_Data_Owner__c=con.id;
        cxe.Retention_Hold__c=true;
        cxe.Retention_Hold_Reason__c='test';
        insert cxe;
        
        Case_Extension__c cxe1 = new Case_Extension__c();
        cxe1.case_object__c=cs.id;
        cxe1.Record_Code__c='None';
        cxe1.Record_Class__c='None';
        cxe1.Record_Data_Owner__c=con.id;
        cxe1.Retention_Hold__c=true;
        cxe1.Retention_Hold_Reason__c='test';
        try{
            insert cxe1;
        }catch(DMLException e1){}
        
        Aircraft_Subscription_Case_Extension__c  cx = new Aircraft_Subscription_Case_Extension__c ();
        cx.Case__c=cs.id;
        insert cx;
        Aircraft_Subscription_Case_Extension__c  cx1 = new Aircraft_Subscription_Case_Extension__c ();
        cx1.Case__c=cs.id;
        try{
            insert cx1;
        }catch(DMLException e){}
    }
}