@isTest
private class ConverttoLeadclassTest {
    private Static testMethod void validateLead(){
        //public string psiid{get;set;}          
         test.startTest();
        Contact c = new Contact();
        id cntrecordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('ATR Contacts').getRecordTypeId();
        c.LastName='Test Contact';
        c.CurrencyIsoCode='USD';
        c.Contact_Function__c='Agent';
        c.RecordTypeId=cntrecordtypeid;
        insert c;
        
        Potential_Sales_Ideas__c psi = new Potential_Sales_Ideas__c();        
        id leadrecordtypeid = Schema.SObjectType.Potential_Sales_Ideas__c.getRecordTypeInfosByName().get('Potential Sales Ideas').getRecordTypeId();
        psi.RecordTypeId=leadrecordtypeid;
        psi.Name='Test Potential Sales Idea';
        psi.Status__c='In Progress';
        psi.Source__c='Bank';
        psi.Estimated_Value__c=2000;
        //psi.Aircraft_Type__c='';
        psi.Aircraft_Tail_Number__c='12345';
        psi.GBE__c='Engines';
        psi.CurrencyIsoCode='USD';
        psi.Contact__c=c.Id;
        insert psi;    
        
        PageReference pageRef = Page.ConverttoLead;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', psi.Id);
        
        ConverttoLeadclass controller = new ConverttoLeadclass();
        PageReference PageRefs = controller.Convertion();
         test.stopTest();
        }

}