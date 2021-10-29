/*
* Creates attachmens for approved creditmemos
*/
trigger APTS_CreditMemoApprove on Apttus_Billing__CreditMemo__c (before insert,after update) {
    
    if(trigger.isupdate && trigger.isAfter)
    {
        List<Id> approvedCreditMemos = new List<Id>();
        List<Id> draftCM = new List<Id>();
        for (Apttus_Billing__CreditMemo__c creditMemo : Trigger.new) {
            if(creditMemo.Apttus_Billing__Status__c == 'Approved' && 
               (Trigger.oldMap.get(creditMemo.id).Apttus_Billing__Status__c != 'Approved')){
                   approvedCreditMemos.add(creditMemo.id);
               }
                System.debug('Testdhsbd1234'+ creditMemo.APTS_Integration_Status__c);
               System.debug('Testdhsbd1'+Trigger.oldMap.get(creditMemo.id).APTS_Integration_Status__c);
            if(creditMemo.Apttus_Billing__Status__c == 'Draft' && Trigger.oldMap.get(creditMemo.id).APTS_Integration_Status__c == 'Requested' && creditMemo.APTS_Integration_Status__c=='Completed') {
                System.debug('Testdhsbd1234'+Trigger.oldMap.get(creditMemo.id).APTS_Integration_Status__c);
                draftCM.add(creditMemo.id);
            }
        }
        
        if (!approvedCreditMemos.isEmpty()) {
            Map<String, List<ID>> templateMap = new Map<String, List<ID>>();
            Apttus_Billing__CreditMemo__c[] creditMemos = [Select Id, Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c From Apttus_Billing__CreditMemo__c
                                                           Where Id in :approvedCreditMemos];
            /*
            * group credit memos by template to do bulk attachment create
            */
            for (Apttus_Billing__CreditMemo__c creditMemo : creditMemos) {
                if (!templateMap.containsKey(creditMemo.Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c)) {
                    templateMap.put(creditMemo.Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c, new List<ID>());                
                } 
                templateMap.get(creditMemo.Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c).add(creditMemo.Id);
            }
            
            for (String template : templateMap.keySet()) {
                Apttus_Billing.BillingService.createCreditMemoDocuments(templateMap.get(template), template); 
            }    
        }
        
        if(draftCM!=null && !draftCM.isempty())
        {
            Map<String, List<ID>> templateMap = new Map<String, List<ID>>();
            Apttus_Billing__CreditMemo__c[] creditMemos = [Select Id, Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c From Apttus_Billing__CreditMemo__c
                                                           Where Id in :draftCM];
            
            for (Apttus_Billing__CreditMemo__c creditMemo : creditMemos) {
                if (!templateMap.containsKey(creditMemo.Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c)) {
                    templateMap.put(creditMemo.Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c, new List<ID>());                
                } 
                templateMap.get(creditMemo.Apttus_Billing__BillToAccountId__r.Apttus_Config2__DefaultCreditMemoTemplate__c).add(creditMemo.Id);
            }
            
            for (String template : templateMap.keySet()) {
                Apttus_Billing.BillingService.createCreditMemoDocuments(templateMap.get(template), template); 
            }
        }
    }
    
    if(trigger.isinsert && trigger.isbefore)
    {
        for (Apttus_Billing__CreditMemo__c creditMemo : Trigger.new) {
            creditMemo.APTS_Integration_Status__c = 'To be Processed';
            creditMemo.APTS_Integration_Method__c = 'Simulate Order';
            //creditMemo.APTS_Integration_Result__c = null;
            creditMemo.APTS_Integration_Requested__c = Datetime.now();
            creditMemo.Apttus_Billing__PaymentStatus__c='';
        }
   
    }
    
   
}