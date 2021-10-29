public with sharing class APTS_AttachmentBulkSubmit {
    private final APTS_PDF_Attachment_Status__c[] invoices;  

    public APTS_AttachmentBulkSubmit(ApexPages.StandardSetController controller) {
        this.invoices = (APTS_PDF_Attachment_Status__c[])controller.getSelected(); 
    }    
    
    public Long getCandidateInvoiceSize(){
        Long candidates = 0;
        for (APTS_PDF_Attachment_Status__c invoice : invoices) {
            if (invoice.APTS_Status__c== 'Error') {
                candidates++;
            }
        }
            
        return candidates;
    }
    
    public PageReference submitInvoices() {
        for (APTS_PDF_Attachment_Status__c invoice : invoices) {
            if (invoice.APTS_Status__c== 'Error') {
                invoice.APTS_Integration_Result__c = '';
                invoice.APTS_Status__c= 'To be Processed';
                invoice.APTS_Integration_Requested__c= system.now();
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select attachments first.'));
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Only Attachments(s) with a Status of Error can be Resubmitted!'));
        return null;
    }  
}