/*******************************************************************************
Name         : CaseCreationPortaltoSFDCTest
Created By   : Nandini N
Company Name : NTT Data
Project      : <CaseCreationPortaltoSFDC>
Created Date : 06-April-2015
Usages       : Test Class for CaseCreationPortaltoSFDC
*******************************************************************************/
@isTest
global class CaseCreationPortaltoSFDCTest{ 
   /* @testSetup 
    static void setupForTestData(){
       String rtIdRepairOverhaul = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id;
        Account acc = new Account();
        acc.Name = 'Authorized Service Centers';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Spares';
        acc.REPORT_ACCOUNT_NAME__c = 'Test';
        acc.Market_Name__c = 'Test';
        Insert acc;
             
        Contact con = new Contact();
        con.LastName = 'Tammy';
        con.FirstName = 'Tammy';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'testportal@honeywell.com.qa';
        con.Email='testportal@honeywell.com.qa';
        con.Employee_Number__c = 'h342864';
        Insert con; 
                              
          }*/
   testMethod static void CaseCreationPortaltoSFDCTestForSpares(){
  
        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id,recordTypeId = recId);
        insert cs;
        case cs1 = [select caseNumber from case where id= :cs.id limit 1]; 
       
    CaseCreationPortaltoSFDC.CaseData cas = new CaseCreationPortaltoSFDC.CaseData();    
    cas.Origin = 'web'; 
    cas.AdditionalWebFormInfo='1344_test1_additional webform';
    cas.OrderType= 'Spares';
    cas.OrderStatusInfoRequested='Orderstatus';
    cas.PortalContactEmail='testportal@honeywell.com.qa';
    cas.HoneywellID= 'H187749';
    cas.Priority = 'Normal';
    cas.Classification= 'AIRCRAFT';
    cas.CUSTOMER_PO_RO_WO_NUM = 'TESTING_PO_ARP_MT-1344';
    cas.SALES_ORDER_NUM = '6553';     
    cas.ExportCompliance = 'No';
    cas.GovernmentCompliance = 'No';
    cas.SUBJECT = 'Portal data test';
    cas.Status = 'open';
    cas.DESCRIPTION= 'Test'; 
    cas.AttBody = 'Test attachment';
    cas.AttFileName = 'test.pdf';
    cas.AttContentType = 'application/pdf';
    cas.Contactid = '0031B00002mDYljQAG';   
    cas.TYPE='Quotes Escalation';
    cas.username = 'myaerospace@honeywell.com';
    cas.ICaseNumber = 'CASE-21691822';
 
       
    CaseCreationPortaltoSFDC.CaseDataSFDCtoPortal casetoportal = CaseCreationPortaltoSFDC.createCase(cas);
    

    }
    testMethod static void CaseCreationPortaltoSFDCTestForRepairs(){

         account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id,recordTypeId = recId);
        insert cs;
        case cs1 = [select caseNumber from case where id= :cs.id limit 1];
        
        
    CaseCreationPortaltoSFDC.CaseData cas = new CaseCreationPortaltoSFDC.CaseData();    
    cas.Origin = 'Web'; 
    cas.AdditionalWebFormInfo='1344_test1_additional webform';
    cas.OrderType= 'Repair/Overhaul';
    cas.OrderStatusInfoRequested='Orderstatus';
    cas.PortalContactEmail='testportal@honeywell.com.qa';
    cas.HoneywellID= 'H187749';
    cas.Priority = 'Normal';
    cas.Classification= 'AIRCRAFT';
    cas.CUSTOMER_PO_RO_WO_NUM = 'TESTING_PO_ARP_MT-1344';
    cas.SALES_ORDER_NUM = '6553';     
    cas.ExportCompliance = 'No';
    cas.GovernmentCompliance = 'No';
    cas.SUBJECT = 'Portal data test';
    cas.Status = 'Open';
    cas.DESCRIPTION= 'Test'; 
    cas.AttBody = 'Test attachment';
    cas.AttFileName = 'test.pdf';
    cas.AttContentType = 'application/pdf';
    cas.Contactid = '0031B00002mDYljQAG';   
    cas.TYPE='Quotes Escalation'  ;
    cas.username = 'myaerospace@honeywell.com';
    cas.ICaseNumber = cs1.caseNumber;
    
    CaseCreationPortaltoSFDC.CaseDataSFDCtoPortal casetoportal = CaseCreationPortaltoSFDC.createCase(cas);
    

    }
    testMethod static void CaseCreationPortaltoSFDCTestForRepairsclosed(){

        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id,recordTypeId = recId);
        insert cs;
        try
    {  
      cs.Status='Closed';
      update cs;
    }Catch(Exception e)
    {
                }
        case cs1 = [select caseNumber from case where id= :cs.id limit 1];
        
        
    CaseCreationPortaltoSFDC.CaseData cas = new CaseCreationPortaltoSFDC.CaseData();    
    cas.Origin = 'Web'; 
    cas.AdditionalWebFormInfo='1344_test1_additional webform';
    cas.OrderType= 'Repair/Overhaul';
    cas.OrderStatusInfoRequested='Orderstatus';
    cas.PortalContactEmail='testportal@honeywell.com.qa';
    cas.HoneywellID= 'H187749';
    cas.Priority = 'Normal';
    cas.Classification= 'AIRCRAFT';
    cas.CUSTOMER_PO_RO_WO_NUM = 'TESTING_PO_ARP_MT-1344';
    cas.SALES_ORDER_NUM = '6553';     
    cas.ExportCompliance = 'No';
    cas.GovernmentCompliance = 'No';
    cas.SUBJECT = 'Portal data test';
    cas.Status = 'Open';
    cas.DESCRIPTION= 'Test'; 
    cas.AttBody = 'Test attachment';
    cas.AttFileName = 'test.pdf';
    cas.AttContentType = 'application/pdf';
    cas.Contactid = '0031B00002mDYljQAG';   
    cas.TYPE='Quotes Escalation'  ;
    cas.username = 'myaerospace@honeywell.com';
    cas.ICaseNumber = cs1.caseNumber;
      
   CaseCreationPortaltoSFDC.CaseDataSFDCtoPortal casetoportal = CaseCreationPortaltoSFDC.createCase(cas);
    }
    
    testMethod static void CaseCreationPortaltoSFDCTestForRepairsonhold(){

        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id,recordTypeId = recId);
        insert cs;
        try
    {  
      cs.Status='On Hold';
      update cs;
    }Catch(Exception e)
    {
                }
        case cs1 = [select caseNumber from case where id= :cs.id limit 1];     
        
    CaseCreationPortaltoSFDC.CaseData cas = new CaseCreationPortaltoSFDC.CaseData();    
    cas.Origin = 'Web'; 
    cas.AdditionalWebFormInfo='1344_test1_additional webform';
    cas.OrderType= 'Repair/Overhaul';
    cas.OrderStatusInfoRequested='Orderstatus';
    cas.PortalContactEmail='testportal@honeywell.com.qa';
    cas.HoneywellID= 'H187749';
    cas.Priority = 'Normal';
    cas.Classification= 'AIRCRAFT';
    cas.CUSTOMER_PO_RO_WO_NUM = 'TESTING_PO_ARP_MT-1344';
    cas.SALES_ORDER_NUM = '6553';     
    cas.ExportCompliance = 'No';
    cas.GovernmentCompliance = 'No';
    cas.SUBJECT = 'Portal data test';
    cas.Status = 'On Hold';
    cas.DESCRIPTION= 'Test'; 
    cas.AttBody = 'Test attachment';
    cas.AttFileName = 'test.pdf';
    cas.AttContentType = 'application/pdf';
    cas.Contactid = '0031B00002mDYljQAG';   
    cas.TYPE='Quotes Escalation'  ;
    cas.username = 'myaerospace@honeywell.com';
    cas.ICaseNumber = 'CASE-18952388';
      
    CaseCreationPortaltoSFDC.CaseDataSFDCtoPortal casetoportal = CaseCreationPortaltoSFDC.createCase(cas);
    }
    
    testMethod static void CaseCreationPortaltoSFDCTestForRepairsParentCase(){

        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        String DefaultContId=System.Label.RnO_Automation_Default_Contact;
        //case cs = new case(status = 'New' , subject = 'Test',contactId = con.id,recordTypeId = recId);
        // insert cs;
        String DefaultAcctId=System.Label.RnO_Automation_Default_Account; 
        CaseCreationPortaltoSFDC.CaseData cs = new CaseCreationPortaltoSFDC.CaseData();  
        cs.Origin = 'Web'; 
        cs.AdditionalWebFormInfo='1344_test1_additional webform';
        cs.OrderType= 'Repair/Overhaul';
        cs.OrderStatusInfoRequested='Orderstatus';
        cs.PortalContactEmail='testportal@honeywell.com.qa';
        cs.HoneywellID= 'H187749';
        cs.Priority = 'Normal';
        cs.Classification= 'AIRCRAFT';
        cs.CUSTOMER_PO_RO_WO_NUM = 'TESTING_PO_ARP_MT-1344';
        cs.SALES_ORDER_NUM = '6553';     
        cs.ExportCompliance = 'No';
        cs.GovernmentCompliance = 'No';
        cs.SUBJECT = 'Portal data test';
        cs.Status = 'Closed';
        cs.DESCRIPTION= 'Test'; 
        cs.AttBody = 'Test attachment';
        cs.AttFileName = 'test.pdf';
        cs.AttContentType = 'application/pdf';
        cs.Contactid = '0031B00002mDYljQAG';   
        cs.TYPE='Quotes Escalation'  ;
        cs.username = 'myaerospace@honeywell.com';
        cs.ICaseNumber = 'CASE-20209336';
        
        //cs.ParentId = CaseCreationPortaltoSFDC.GetparentcaseNumer(cas);
        // GetparentcaseNumer(cs1);
        // CaseCreationPortaltoSFDC.CaseDataSFDCtoPortal casetoportal = CaseCreationPortaltoSFDC.createCase(cas);
        
        Case cas = new Case();                              
        // cas.RecordtypeId = Label.Orders_Rec_ID;
        cas.Origin = cs.Origin; 
        cas.Type = cs.TYPE;
        cas.Additional_Web_Form_Info__c=cs.AdditionalWebFormInfo;
        cas.Order_Type__c = cs.OrderType;
        cas.Order_Status_Info_Requested__c=cs.OrderStatusInfoRequested;
        cas.Portal_Contact_Email__c=cs.PortalContactEmail;
        cas.Honeywell_ID__c=cs.HoneywellID;
        cas.Priority= String.isNotBlank(cs.Priority)? cs.Priority:'Normal';//cs.Priority;
        cas.Classification__c = cs.Classification;
        cas.Customer_PO_RO_WONumber__c =  String.isNotBlank(cs.CUSTOMER_PO_RO_WO_NUM)?cs.CUSTOMER_PO_RO_WO_NUM:'';
        cas.Sales_Order_Number__c = cs.SALES_ORDER_NUM;     
        cas.Export_Compliance_Content_ITAR_EAR__c = cs.ExportCompliance;
        cas.Government_Compliance_SM_M_Content__c = cs.GovernmentCompliance;
        cas.Subject = cs.SUBJECT;
        cas.OwnerId = Label.CSO_R_O_Team;
        cas.Description = cs.DESCRIPTION; 
        cas.Type_of_Request__c = cs.TypeOfRequest; 
        if(cs.OrderType != 'Spares' && CaseCreationPortaltoSFDC.GetparentcaseNumer(cs) != null)
        {  
            cas.ParentId = CaseCreationPortaltoSFDC.GetparentcaseNumer(cs); 
        }
        
        if(CaseCreationPortaltoSFDC.isPortalUser(cs)){
            cas.status = 'Open';
            if(cs.OrderType=='Spares'){
                cas.OwnerId=Label.Owner_Order_Status_Team;
            }
        }
        else
        {
            cas.Status = cs.status;
        }
        
        
        if(cs.Contactid != null && cs.Contactid != ''){
            cas.ContactId = cs.Contactid; 
            cas.AccountId = CaseCreationPortaltoSFDC.GET_ACCOUNT_ID(cs.Contactid);           
        }
        else
        {
            cas.AccountId=DefaultAcctId;
            cas.ContactId=DefaultContId;          
        } 
        Boolean isInserted = false;
        try{
            system.debug('------------------------------>in');
            insert cas;
            isInserted = true;
        }catch(DMLException e){
            // cse.message = 'Invalid - '+e.getMessage();
        }
        
        
        if(isInserted == true){
            // cse.caseNumber = getCaseNumber(cas.id);
           //  cse.message = 'Success'; 
        }
        
       }
    testMethod static void CaseCreationPortaltoSFDCTestForRepairsOCA(){

        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id,recordTypeId = recId);
        insert cs;
        try
    {  
      cs.Status='Open';
      update cs;
    }Catch(Exception e)
    {
                }
        case cs1 = [select caseNumber from case where id= :cs.id limit 1];     
        
    CaseCreationPortaltoSFDC.CaseData cas = new CaseCreationPortaltoSFDC.CaseData();    
    cas.Origin = 'Web'; 
    cas.AdditionalWebFormInfo='1344_test1_additional webform';
    cas.OrderType= 'Repair/Overhaul';
    cas.OrderStatusInfoRequested='Orderstatus';
    cas.PortalContactEmail='testportal@honeywell.com.qa';
    cas.HoneywellID= 'H187749';
    cas.Priority = 'Normal';
    cas.Classification= 'AIRCRAFT';
    cas.CUSTOMER_PO_RO_WO_NUM = 'TESTING_PO_ARP_MT-1344';
    cas.SALES_ORDER_NUM = '6553';     
    cas.ExportCompliance = 'No';
    cas.GovernmentCompliance = 'No';
    cas.SUBJECT = 'Portal data test';
    cas.Status = 'Open';
    cas.DESCRIPTION= 'Test'; 
    cas.AttBody = 'Test attachment';
    cas.AttFileName = 'test.pdf';
    cas.AttContentType = 'application/pdf';
    cas.Contactid = '0031B00002mDYljQAG';   
    cas.TYPE='Quotes Escalation'  ;
    cas.username = 'myaerospace@honeywell.com';
    cas.ICaseNumber = 'CASE-21663226';
      
    CaseCreationPortaltoSFDC.CaseDataSFDCtoPortal casetoportal = CaseCreationPortaltoSFDC.createCase(cas);
    }
    testMethod static void CaseCreationPortaltoSFDCForRepairsClosed(){
     Test.startTest();

    CaseCreationPortaltoSFDC.CaseData cas = new CaseCreationPortaltoSFDC.CaseData();    
    cas.Origin = 'web'; 
    cas.AdditionalWebFormInfo='1344_test1_additional webform';
    cas.OrderType= 'Repair/Overhaul';
    cas.OrderStatusInfoRequested='Orderstatus';
    cas.PortalContactEmail='testportal@honeywell.com.qa';
    cas.HoneywellID= 'h342864';
    cas.Priority = 'Normal';
    cas.Classification= 'AIRCRAFT';
    cas.CUSTOMER_PO_RO_WO_NUM = 'Test New Repair';
    cas.SALES_ORDER_NUM = '6553';     
    cas.ExportCompliance = 'No';
    cas.GovernmentCompliance = 'No';
    cas.SUBJECT = 'Portal data test';
    cas.Status = 'Closed';
    cas.DESCRIPTION= 'Test'; 
    cas.AttBody = 'Test atta';
    cas.AttFileName = 'test.pdf';
    cas.AttContentType = 'application/pdf';
    cas.Contactid = '0033000000iRuGCAA0';
    cas.TYPE='Quotes Escalation';
    cas.ICaseNumber = 'CASE-20209336';
  
    CaseCreationPortaltoSFDC.CaseDataSFDCtoPortal casetoportal = CaseCreationPortaltoSFDC.createCase(cas);
    Test.stopTest();
        }
}