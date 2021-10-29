public with sharing class APTS_CreditMemoBulkCancel {
    private final Apttus_Billing__CreditMemo__c[] creditmemos;  

    public APTS_CreditmemoBulkCancel(ApexPages.StandardSetController controller) {
        this.creditmemos = (Apttus_Billing__CreditMemo__c[])controller.getSelected(); 
    }    
    
    public Long getCandidateCreditMemoSize(){
        Long candidates = 0;
        for (Apttus_Billing__CreditMemo__c creditmemo : creditmemos) {
            if (creditmemo.Apttus_Billing__Status__c == 'Draft') {
                candidates++;
            }
        }
            
        return candidates;
    }
    
    public PageReference cancelCreditMemo() {
        List<ID> creditmemoIds = new List<ID>();
        for (Apttus_Billing__CreditMemo__c creditmemo : creditmemos) {
            if (creditmemo.Apttus_Billing__Status__c == 'Draft') {
               creditmemoIds.add(creditmemo.Id);
            }
        }
        APTS_BillingService.cancelCreditMemo(creditmemoIds);
        return new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
    }
    
    public PageReference selectedCreditMemos() {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String MyProflieName = PROFILE[0].Name;
        if(MyProflieName=='Fuel Efficiency Customer Care')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary.'));
            return null;
        }
        
        if (creditmemos ==  null || creditmemos.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one credit memo to continue...'));
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Only CreditMemo(s) with a Status of Draft can be Cancelled!'));
        return null;
    }  
}