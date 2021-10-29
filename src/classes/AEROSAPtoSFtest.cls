@isTest
public class AEROSAPtoSFtest {
       
    Static testMethod void testMethod1(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'Closed';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.Sales_Order_Number__c ='123456';
        Test.starttest();
        insert cas;
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        insert inv;
        AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'Open';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = 'test123';
        iwWrap.Invoice_Number = 'test123';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        iwWrap.invoice_currency = 'U.S. Dollar';
        iwWrap.SFDCID = Cas.CaseNumber;
        iwWrapLst.add(iwWrap);
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap); 
        Test.stoptest();
              
    }
    Static testMethod void testMethod2(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'Open';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.Sales_Order_Number__c ='123456';
        
        Test.starttest();
        insert cas;
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        insert inv;
        AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'Closed';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = 'test123';
        iwWrap.Invoice_Number = 'test123';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        iwWrap.invoice_currency = 'U.S. Dollar';
        //iwWrap.SFDCID = cas.Id;
        iwWrapLst.add(iwWrap);
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap); 
        Test.stoptest();
              
    }
    Static testMethod void testMethod3(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'Open';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.Sales_Order_Number__c ='123456';
        
        Test.starttest();
        insert cas;
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        insert inv;
        Invoices_for_fscmCase__c inv2 = new Invoices_for_fscmCase__c();
        inv2.FSCM_ID__c = 'Test234';
        inv2.FSCM_Status__c = 'New';
        inv2.Parent_Case__c = cas.Id;
        insert inv2;
        AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'Closed';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = 'test123';
        iwWrap.Invoice_Number = 'test123';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        iwWrap.invoice_currency = 'U.S. Dollar';
        //iwWrap.SFDCID = cas.Id;
        iwWrapLst.add(iwWrap);
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap); 
        Test.stoptest();
              
    }
    Static testMethod void testMethod4(){
       
        
        Test.starttest();
        AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap2 = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'New';
        CsWrap.SoldTo = '00123';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = '1098674';
        iwWrap.Invoice_Number = '12345';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        //iwWrap.invoice_currency = 'U.S. Dollar';
        iwWrapLst.add(iwWrap);
        iwWrap2.FSCM_Id = '23457654';
        iwWrap2.Invoice_Number = '132325778';
        iwWrap2.Invoice_Amount= 123;
        iwWrap2.disputed_Amount = 123;
        //iwWrap2.invoice_currency = 'U.S. Dollar';
        iwWrapLst.add(iwWrap2);
        CsWrap.invwrap = iwWrapLst;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduserForAeroFscm@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserForAeroFscm@testorg.com',User_EID__c='H123456',IsActive = true);
        insert u;
        contact con = new Contact(LastName='test',Employee_Number__c ='H123456');
        insert con;
        account acc= new account(name= 'test',Sbl_Account_Row_Id__c = CsWrap.CRM_ID,Business_Focal__c=con.Id);
        insert acc;
        AEROSAPtoSF.CreateCase(CsWrap);
        Test.stoptest();
              
    }
    Static testMethod void testMethod5(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'Closed';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.Sales_Order_Number__c ='123456';
        
        Test.starttest();
        insert cas;
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'Test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        insert inv;
        Invoices_for_fscmCase__c inv2 = new Invoices_for_fscmCase__c();
        inv2.FSCM_ID__c = 'test234';
        inv2.FSCM_Status__c = 'New';
        inv2.Parent_Case__c = cas.Id;
        insert inv2;
        AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'Closed';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = 'test123';
        iwWrap.Invoice_Number = 'test123';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        iwWrap.invoice_currency = 'U.S. Dollar';
        iwWrap.SFDCID = cas.CaseNumber;
        iwWrapLst.add(iwWrap);
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap); 
        Test.stoptest();
              
    }
    
    Static testMethod void testMethod6(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'Open';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.Sales_Order_Number__c ='123456';
        
        Test.starttest();
        insert cas;
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'Test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        insert inv;
        AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'Open';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = 'Test123';
        iwWrap.Invoice_Number = 'test123';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        iwWrap.invoice_currency = 'U.S. Dollar';
        iwWrap.SFDCID =  cas.CaseNumber;
        iwWrapLst.add(iwWrap);
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap); 
        Test.stoptest();
              
    }
    Static testMethod void testMethod7(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'Open';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.Sales_Order_Number__c ='123456';
        
        Test.starttest();
        insert cas;
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        insert inv;
        Invoices_for_fscmCase__c inv2 = new Invoices_for_fscmCase__c();
        inv2.FSCM_ID__c = 'Test234';
        inv2.FSCM_Status__c = 'Closed';
        inv2.Parent_Case__c = cas.Id;
        insert inv2;
        AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'Closed';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = 'test123';
        iwWrap.Invoice_Number = 'test123';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        iwWrap.invoice_currency = 'U.S. Dollar';
        //iwWrap.SFDCID = cas.Id;
        iwWrapLst.add(iwWrap);
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap); 
        Test.stoptest();
    }         
    Static testMethod void testMethod8(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
    Test.starttest();
       AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
            Case cas = new case();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'Open';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.Sales_Order_Number__c ='123456';
        cas.Notes__c = 'Test';
        insert cas;
        iwWrap.SFDCID =  cas.CaseNumber;
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'Open';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = 'test123';
        iwWrap.Invoice_Number = 'test123';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        iwWrap.invoice_currency = 'U.S. Dollar';
        
        iwWrapLst.add(iwWrap);
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap); 
        Test.stoptest();
    } 
    Static testMethod void testMethod9(){
    Test.starttest();
       AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'Open';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap); 
        Test.stoptest();
    }    
     Static testMethod void testMethod10(){
       
        
        Test.starttest();
        AEROSAPtoSF.CaseWrapper CsWrap = new AEROSAPtoSF.CaseWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap = new AEROSAPtoSF.InvoiceWrapper();
        AEROSAPtoSF.InvoiceWrapper iwWrap2 = new AEROSAPtoSF.InvoiceWrapper();
        list<AEROSAPtoSF.InvoiceWrapper> iwWrapLst = new list<AEROSAPtoSF.InvoiceWrapper>();
        CsWrap.CRM_ID = 'Test123';
        CsWrap.Status = 'New';
        CsWrap.Subject = 'Test';
        CsWrap.Notes = 'Test';
        CsWrap.Dollar_Amounts= 1234;
        CsWrap.ReOpenCheck= True;
        iwWrap.FSCM_Id = '1098674';
        iwWrap.Invoice_Number = '12345';
        iwWrap.Invoice_Amount= 123;
        iwWrap.disputed_Amount = 123;
        //iwWrap.invoice_currency = 'U.S. Dollar';
        iwWrapLst.add(iwWrap);
        iwWrap2.FSCM_Id = '23457654';
        iwWrap2.Invoice_Number = '132325778';
        iwWrap2.Invoice_Amount= 123;
        iwWrap2.disputed_Amount = 123;
        //iwWrap2.invoice_currency = 'U.S. Dollar';
        iwWrapLst.add(iwWrap2);
        CsWrap.invwrap = iwWrapLst;
        AEROSAPtoSF.CreateCase(CsWrap);
        Test.stoptest();
              
    }
   
}