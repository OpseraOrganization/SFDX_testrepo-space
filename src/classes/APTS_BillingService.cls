global class APTS_BillingService {
    
    webservice static APTS_InvoiceActionResult approveInvoice(List<Id> invoiceIds){
        return APTS_BillingService.changeInvoiceStatus(invoiceIds, 'Approved', 'Approved', 'Invoiced');
    }
    
    webservice static APTS_InvoiceActionResult cancelInvoice(List<Id> invoiceIds){
        return APTS_BillingService.changeInvoiceStatus(invoiceIds, 'Cancelled', 'Cancelled', 'Pending Billing');
    }
    
    private static APTS_InvoiceActionResult changeInvoiceStatus(List<Id> invoiceIds, String invoiceStatus, String lineItemStatus, String billingScheduleStatus){
        if(invoiceIds==null || invoiceIds.isEmpty()){
            return APTS_InvoiceActionResult.withFailure('invoice Id list is empty');
        }
        Apttus_Billing__Invoice__c[] invoices = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__Invoice__c Where Id in :invoiceIds];
        if(invoices.isEmpty()){
            return APTS_InvoiceActionResult.withFailure('Invoice not found');
        }
        for(Apttus_Billing__Invoice__c invoice : invoices){
            invoice.Apttus_Billing__Status__c = invoiceStatus;
        }
        
        Apttus_Billing__InvoiceLineItem__c[] invoiceLineItems = [Select Id, Apttus_Billing__Status__c, Apttus_Billing__BillingScheduleId__c From Apttus_Billing__InvoiceLineItem__c Where Apttus_Billing__InvoiceId__c in :invoiceIds];
        if(!invoiceLineItems.isEmpty()){
            Set<Id> scheduleIds = new Set<Id>();
            for(Apttus_Billing__InvoiceLineItem__c lineItem : invoiceLineItems){
                lineItem.Apttus_Billing__Status__c = lineItemStatus;
                if(lineItem.Apttus_Billing__BillingScheduleId__c!=NULL){
                    scheduleIds.add(lineItem.Apttus_Billing__BillingScheduleId__c);
                }
            }
            
            if(!scheduleIds.isEmpty()){
                Apttus_Billing__BillingSchedule__c[] schedules = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__BillingSchedule__c Where Id in :scheduleIds];
        		if(!schedules.isEmpty()){
            		for(Apttus_Billing__BillingSchedule__c schedule : schedules){
                		schedule.Apttus_Billing__Status__c = billingScheduleStatus;
            		}
            		update schedules;
        		}
            }
            update invoiceLineItems;
        }
        
        update invoices;
        
        return APTS_InvoiceActionResult.withSuccess();
    }
    
    webservice static APTS_CreditMemoActionResult approveCreditMemo(List<Id> creditMemoIds){
        return APTS_BillingService.changeCreditMemoStatus(creditMemoIds, 'Approved', 'Approved', 'CreditMemod');
    }
    
    webservice static APTS_CreditMemoActionResult cancelCreditMemo(List<Id> creditMemoIds){
        return APTS_BillingService.changeCreditMemoStatus(creditMemoIds, 'Cancelled', 'Cancelled', 'Pending Billing');
    }
    
    private static APTS_CreditMemoActionResult changeCreditMemoStatus(List<Id> creditMemoIds, String creditMemoStatus, String lineItemStatus, String billingScheduleStatus){
        if(creditMemoIds==null || creditMemoIds.isEmpty()){
            return APTS_CreditMemoActionResult.withFailure('creditMemo Id list is empty');
        }
        Apttus_Billing__CreditMemo__c[] creditMemos = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__CreditMemo__c Where Id in :creditMemoIds];
        if(creditMemos.isEmpty()){
            return APTS_CreditMemoActionResult.withFailure('CreditMemo not found');
        }
        for(Apttus_Billing__CreditMemo__c creditMemo : creditMemos){
            creditMemo.Apttus_Billing__Status__c = creditMemoStatus;
        }
        
        
        Apttus_Billing__CreditMemoLineItem__c[] creditMemoLineItems = [Select Id, Apttus_Billing__Status__c, Apttus_Billing__BillingScheduleId__c From Apttus_Billing__CreditMemoLineItem__c Where Apttus_Billing__CreditMemoId__c in :creditMemoIds];
        if(!creditMemoLineItems.isEmpty()){
            Set<Id> scheduleIds = new Set<Id>();
            for(Apttus_Billing__CreditMemoLineItem__c lineItem : creditMemoLineItems){
                lineItem.Apttus_Billing__Status__c = lineItemStatus;
                if(lineItem.Apttus_Billing__BillingScheduleId__c!=NULL){
                    scheduleIds.add(lineItem.Apttus_Billing__BillingScheduleId__c);
                }
            }
            
            if(!scheduleIds.isEmpty()){
                Apttus_Billing__BillingSchedule__c[] schedules = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__BillingSchedule__c Where Id in :scheduleIds];
        		if(!schedules.isEmpty()){
            		for(Apttus_Billing__BillingSchedule__c schedule : schedules){
                		schedule.Apttus_Billing__Status__c = billingScheduleStatus;
            		}
            		update schedules;
        		}
            }
            update creditMemoLineItems;
        }
        
        update creditMemos;
        
        return APTS_CreditMemoActionResult.withSuccess();
    }
}