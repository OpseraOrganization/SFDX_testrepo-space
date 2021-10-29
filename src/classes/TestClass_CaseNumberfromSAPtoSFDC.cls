@isTest(SeeAllData=true)
global class TestClass_CaseNumberfromSAPtoSFDC{
    testMethod static void testCaseNumberfromSAPtoSFDC() {
        test.startTest();
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc;
        
        Contact objContact = new Contact();
        objContact.LastName = 'hariiii';
        objContact.FirstName = 'testweb';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        objContact.Employee_Number__c = 'H287751';      
        insert objContact;
        
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cs.Customer_Type__c = 'MSP';
        cs.Part_Status__c = 'Outright';
        cs.Customer_PO_RO_WONumber__c = '352312345';
        cs.Sales_Order_Number__c = '21100463';
        cs.Part_Number_Needed__c = 'Test';
        cs.Quote_Number__c = '23648623';
        cs.Proposed_Supplier__c = 'Test1';
        cs.Price__c = '123';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.Part_Number__c = 'Test';
        cs.Subject = 'Test Cases';
        insert cs;        
        
        CaseNumberfromSAPtoSFDC.CaseFieldsToRetrieve sapData = new CaseNumberfromSAPtoSFDC.CaseFieldsToRetrieve();                  
        sapData.SalesOrderNum = '21100463';
        
        List<CaseNumberfromSAPtoSFDC.CaseNumSFDCtoSAP> retunData = CaseNumberfromSAPtoSFDC.getCaseNumbers(sapData);
        List<CaseNumberfromSAPtoSFDC.CaseNumSFDCtoSAP> cs1 = new List<CaseNumberfromSAPtoSFDC.CaseNumSFDCtoSAP>();
        for(integer i=0;i<cs1.size();i++){
            cs1[i].salesordernum = cs.Sales_Order_Number__c;
            cs1[i].quotenum = cs.Quote_Number__c;
            cs1[i].caserefid = cs.Case_Ref_Id__c;
            cs1[i].caseNumbers = cs.CaseNumber;
            cs1[i].cassub = cs.Subject;
        }    
        test.stopTest();
    }    
}