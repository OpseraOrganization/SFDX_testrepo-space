public with sharing class APTS_InvoiceBulkSubmit {
    private final Apttus_Billing__Invoice__c[] invoices;  

    public APTS_InvoiceBulkSubmit(ApexPages.StandardSetController controller) {
        this.invoices = (Apttus_Billing__Invoice__c[])controller.getSelected(); 
    }    
    
    public Long getCandidateInvoiceSize(){
        Long candidates = 0;
        for (Apttus_Billing__Invoice__c invoice : invoices) {
            if (invoice.Apttus_Billing__Status__c == 'Draft') {
                candidates++;
            }
        }
            
        return candidates;
    }
    
    public PageReference submitInvoices() {
        for (Apttus_Billing__Invoice__c invoice : invoices) {
            if (invoice.Apttus_Billing__Status__c == 'Draft') {
                invoice.Apttus_Billing__Status__c = 'Submitted';
                invoice.APTS_Integration_Method__c = 'Debit Memo Request';
                invoice.APTS_Integration_Result__c = '';
                invoice.APTS_Integration_Status__c = '';
            }
        }
        update invoices;
        return new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
    }
    
    public PageReference selectedInvoices() {
        
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        if(MyProflieName=='Fuel Efficiency Customer Care')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.'));
            return null;
        }
        
        if (invoices ==  null || invoices.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select invoices first.'));
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Only Invoice(s) with a Status of Draft can be Submitted!'));
        return null;
    }  
}