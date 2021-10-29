@isTest
public class AeroSFtoSAPOnInsertNdUpdateTest {
    Static testMethod void testMethod1(){
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        Map<id,case> oldmap = new Map<id,case>();
        List<Case> newCase = new List<Case>();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'New';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.ownerId = Label.AERODEFAULTUSER;
        cas.Sales_Order_Number__c ='123456';
        cas.Estimated_Resolution_Date__c= system.today();
        Test.starttest();
        insert cas;
        
        
        oldmap.put(cas.id, cas.clone(true, true, true, true));
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        inv.Disputed_Amount__c=800;
        inv.Invoice_Amount__c=500;
        inv.Invoice_Number__c='10986453';
        insert inv;
        
        AEROSAPtoSF.triggerNotRunningFromAPI = True;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User usr = new User(Alias = 'standt', Email='standarduserfortest@testaero.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserfortest@testaero.com');
        insert usr ;
        
        cas.ownerId = usr.id;
        cas.Estimated_Resolution_Date__c = System.today() + 5;
        cas.status = 'Closed';
        cas.Notes__c = 'New Note';
        cas.Resolution__c= 'Resolved';
        update cas;
        System.debug('cas.ownerId '+cas.ownerId);
        newCase.add(cas);
        AeroSFtoSAPOnInsertNdUpdate.afterUpdateofFscm(newCase,oldmap);
        Test.stoptest();
    }
    Static testMethod void testMethod2(){
           Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        Map<id,case> oldmap = new Map<id,case>();
        List<Case> newCase = new List<Case>();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'New';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Notes__c ='Test';
        cas.Resolution__c='Resolved';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.ownerId = Label.AERODEFAULTUSER;
        cas.Sales_Order_Number__c ='123456';
        cas.Estimated_Resolution_Date__c= system.today();
        Test.starttest();
        insert cas;
        oldmap.put(cas.id, cas.clone(true, true, true, true));
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        inv.Disputed_Amount__c=800;
        inv.Invoice_Amount__c=500;
        inv.Invoice_Number__c='10986453';
        insert inv;
        AEROSAPtoSF.triggerNotRunningFromAPI = True;
        cas.Resolution__c='Resolved again';
        cas.Notes__c=oldMap.get(cas.Id).Notes__c+'Test Note';
        update cas;
        newCase.add(cas);
        AeroSFtoSAPOnInsertNdUpdate.afterUpdateofFscm(newCase,oldmap);
        Test.stoptest();
        
    }
    Static testMethod void testMethod3(){
           Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        Map<id,case> oldmap = new Map<id,case>();
        List<Case> newCase = new List<Case>();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'New';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Notes__c ='Test';
        cas.Resolution__c='Resolved';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.ownerId = Label.AERODEFAULTUSER;
        cas.Sales_Order_Number__c ='123456';
        cas.Estimated_Resolution_Date__c= system.today();
        Test.starttest();
        insert cas;
        oldmap.put(cas.id, cas.clone(true, true, true, true));
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        inv.Disputed_Amount__c=800;
        inv.Invoice_Amount__c=500;
        inv.Invoice_Number__c='10986453';
        insert inv;
        AEROSAPtoSF.triggerNotRunningFromAPI = True;
        cas.Resolution__c='Resolved again';
        //cas.Notes__c='Test Note';
        update cas;
        newCase.add(cas);
        AeroSFtoSAPOnInsertNdUpdate.afterUpdateofFscm(newCase,oldmap);
        Test.stoptest();
        
    }
    Static testMethod void testMethod4(){
           Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(System.label.Invoice_FSCM_Disputes).getRecordTypeId();
        Case cas = new case();
        Map<id,case> oldmap = new Map<id,case>();
        List<Case> newCase = new List<Case>();
        cas.SuppliedEmail = 'abc@gmail.com';
        cas.Additional_Web_Form_Info__c = 'test';
        cas.Origin = 'web';
        cas.Priority = 'normal';
        cas.Type = 'Orders';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Status = 'New';
        cas.Description = 'Test';
        cas.Subject = 'Test';
        cas.Notes__c ='Test';
        cas.Resolution__c='Resolved';
        cas.Customer_PO_RO_WONumber__c= '121';
        cas.RecordTypeId= devRecordTypeId;
        cas.ownerId = Label.AERODEFAULTUSER;
        cas.Sales_Order_Number__c ='123456';
        cas.Estimated_Resolution_Date__c= system.today();
        Test.starttest();
        insert cas;
        oldmap.put(cas.id, cas.clone(true, true, true, true));
        Invoices_for_fscmCase__c inv = new Invoices_for_fscmCase__c();
        inv.FSCM_ID__c = 'test123';
        inv.FSCM_Status__c = 'New';
        inv.Parent_Case__c = cas.Id;
        inv.Disputed_Amount__c=800;
        inv.Invoice_Amount__c=500;
        inv.Invoice_Number__c='10986453';
        insert inv;
        AEROSAPtoSF.triggerNotRunningFromAPI = True;
        //cas.Resolution__c='Resolved again';
        cas.Notes__c='Test Note';
        update cas;
        newCase.add(cas);
        AeroSFtoSAPOnInsertNdUpdate.afterUpdateofFscm(newCase,oldmap);
        Test.stoptest();
        
    }
}