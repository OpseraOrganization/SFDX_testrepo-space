/*
Created By : Vinod T
Created Date : March-26-2018
Usages : Test class for CaseLineItemExport_cls      
*/
@isTest
private class CaseLineItemExport_Testcls {

    static testMethod void exportmethod() {
        
        Test.startTest();
        
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('D&S Clearing House Proposal').getRecordTypeId();
        List<Case> list_CaseOrder= SObjectFactory.create(
                1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Ownerid => Label.NavDB_Accts_Team,
                    Case.SuppliedEmail=>'CTSEFTCW@HONEYWELL.COM',
                    Case.RecordTypeId=> RecordTypeIdCase ,
                    Case.Priority => 'Medium',
                    Case.UFR_Standard_Price_Amount__c =>12,
                    Case.Type =>'Reapir Inquiry',
                    Case.Subject => 'QNext'
                });
            Case caseRelatedToCLI = new Case();
            caseRelatedToCLI = list_CaseOrder[0];
            Case_Line_Item__c caseLookupRec = (Case_Line_Item__c) SObjectFactory.create(
                Case_Line_Item__c.SObjectType, new Map<SObjectField, Object>{
                    Case_Line_Item__c.Case_Number__c=> list_CaseOrder[0].Id,
                    Case_Line_Item__c.Price__c => 20,
                    Case_Line_Item__c.Quantity__c => 2
                });   
                List<Case_Line_Item__c> lst = new List<Case_Line_Item__c>();
                lst.add(caseLookupRec);
                Test.setCurrentPage(Page.Honeywell_Case_Line_Item_Export);
                System.currentPageReference().getparameters().put('id',list_CaseOrder[0].id);
               // ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(lst);
                CaseLineItemExport_cls ext = new CaseLineItemExport_cls();

        
        Test.stopTest();
    }
    
}