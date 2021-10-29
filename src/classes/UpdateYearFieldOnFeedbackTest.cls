@isTest(SeeAllData=true)
private class UpdateYearFieldOnFeedbackTest{ 
    static testMethod void UpdateYearFieldOnFeedbackTest(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'Effortless';
        objContact.FirstName = 'Orders';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;  
        objContact.Employee_number__c = 'E123123';   
        insert objContact;
        
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Classification__c = 'EMS';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.OwnerId = usr.id;
        try{
            insert cs;
        }catch(DMLException e){}
        
        Feedback__c fb = new Feedback__c();
        fb.Account__c = acc.id;
        fb.Case__c = cs.id;
        fb.Year__c = '';
        insert fb;
        
        Test.StartTest();                
        fb.Year__c = '2014';
        update fb;        
        Test.StopTest();
    }
}