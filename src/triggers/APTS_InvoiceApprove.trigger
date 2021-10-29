trigger APTS_InvoiceApprove on Apttus_Billing__Invoice__c (before update,after update) {
    if(trigger.isupdate && trigger.isafter){
        //APTS_Invoice_Trigger.sendinvoiceapproveemail(trigger.newmap,trigger.oldmap);
    }
    if(trigger.isupdate && trigger.isbefore)
    {
    
       try{
        List<Id> approvedInvoices = new List<Id>();
        List<Id> approvedInvoicesAspire = new List<Id>();
        for (Apttus_Billing__Invoice__c invoice : Trigger.new) {
            if(invoice.Apttus_Billing__Status__c == 'Approved' && 
               Trigger.oldMap.get(invoice.id).Apttus_Billing__Status__c != 'Approved') {
               
               if(invoice.Price_List__c != Null && invoice.Price_List__c.containsIgnoreCase('Aspire')){
                    system.debug('In If -approvedInvoicesAspire'+approvedInvoicesAspire);
                    
                    IF(invoice.Apttus_Billing__TotalInvoiceAmount__c != 0)
                    {
                    approvedInvoicesAspire.add(invoice.id);
                    }
                    Else
                    {
                      invoice.Apttus_Billing__PaymentStatus__c = 'Paid';
                    }
               }
               else{
                   system.debug('In Else -approvedInvoices'+approvedInvoices);
                   approvedInvoices.add(invoice.id);
               }
           } 
        }
        
        /*
         * Set jira transaction date for applicable invoices
         */ 
        if (!approvedInvoices.isEmpty()) {
            AggregateResult[] jiraInvoices = [Select Apttus_Billing__InvoiceId__c From Apttus_Billing__InvoiceLineItem__c 
                                                Where Apttus_Billing__InvoiceId__c in :approvedInvoices and 
                                                  Apttus_Billing__AssetLineItemId__r.APTS_External_Id__c <> '' and
                                                  Apttus_Billing__AssetLineItemId__r.APTS_External_Source__c = 'JIRA'
                                                Group By Apttus_Billing__InvoiceId__c];
            if (jiraInvoices != null && jiraInvoices.size() > 0) {
                for (AggregateResult jiraInvoice : jiraInvoices) {
                    Trigger.newMap.get((ID)jiraInvoice.get('Apttus_Billing__InvoiceId__c')).APTS_JIRA_Transaction_Date__c = Datetime.now();
                }
            }
        }
        
        /*
         * Create attachments for approved invoices 
         */
         system.debug('approvedInvoices'+approvedInvoices);
         system.debug('approvedInvoicesAspire'+approvedInvoicesAspire);
         
        if(!approvedInvoices.isEmpty()){
            Apttus_Billing.BillingService.createInvoiceDocuments(approvedInvoices);
        }
        
        if(!approvedInvoicesAspire.isEmpty()){
            
         /* List<APTS_PDF_Attachment_Status__c> PdfList = [select id,APTS_Attachment_Id__c,APTS_Invoice__c from APTS_PDF_Attachment_Status__c where APTS_Invoice__c =:approvedInvoicesAspire];   
            if(PdfList.Size()>0)
            {
              Delete PdfList;
            }  */   
            Apttus_Billing.BillingService.createInvoiceDocuments(approvedInvoicesAspire,'FE Invoice 1000 (USD)');
        }
      }
      catch(Exception e){
          system.debug('APTS_InvoiceApprove exception '+e.getMessage() + ' '+e.getLineNumber());
      }
    }
    //shiva--create draft atachment
    if(trigger.isupdate && trigger.isbefore)
    {
       try{
        List<Id> draftInvoices = new List<Id>();
        List<Id> draftInvoicesAspire  = new List<Id>();
        for (Apttus_Billing__Invoice__c invoice : Trigger.new) {
           
            if(invoice.Apttus_Billing__Status__c == 'Draft' && Trigger.oldMap.get(invoice.id).APTS_Integration_Status__c == 'Requested' && invoice.APTS_Integration_Status__c=='Completed' && invoice.Price_List__c == Null && (invoice.Price_List__c == 'Aspire PriceList' || invoice.Price_List__c == 'Aspire PriceList_SAPOrders')) {
                   
                   system.debug('If - Invoice id'+ invoice.id);
                   draftInvoices.add(invoice.id);
              } 
             /* else if(invoice.Apttus_Billing__Status__c == 'Draft' && (invoice.Price_List__c != Null && invoice.Price_List__c.containsIgnoreCase('Aspire')) && (invoice.APTS_Integration_Status__c == 'To be Processed')&& Trigger.oldMap.get(invoice.id).APTS_Integration_Status__c  != 'To be Processed'){
                   system.debug('Else If - Invoice id'+ invoice.id);
                   draftInvoicesAspire.add(invoice.id);
               } */
           
           
         }
        
         system.debug('draftInvoices '+ draftInvoices);
         system.debug('draftInvoicesAspire '+ draftInvoicesAspire);
        
        /*
         * Create attachments for draft invoices 
         */
        if(!draftInvoices.isEmpty()){
            Apttus_Billing.BillingService.createInvoiceDocuments(draftInvoices);
        }
       /* if(!draftInvoicesAspire.isEmpty()){
            Apttus_Billing.BillingService.createInvoiceDocuments(draftInvoicesAspire,'FE Invoice 1000 (USD)');
        } */
  
       }
       catch(Exception e){
           system.debug('APTS_InvoiceApprove exception '+e.getMessage() + ' '+e.getLineNumber());
       }
    } 
}