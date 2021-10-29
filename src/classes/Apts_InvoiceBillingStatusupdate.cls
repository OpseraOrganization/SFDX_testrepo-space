/**************************************************************
Name         : Apts_InvoiceBillingStatusupdate class
Created BY   : Siva
Company Name : Nttdata
Project      : Aviaso
Created Date : 24th April 2019
Class        : Apts_InvoiceBillingStatusupdate
Test Class:  : Apts_InvoiceBillingStatusupdateTest
Description : Update the Invoice & Billing Schedule  Status once the Invoice integration status  is completed.
***************************************************************/
public class Apts_InvoiceBillingStatusupdate {
    @InvocableMethod
    public static void approveInvoice(List<Id> invoiceIds){
        System.debug('Invoice Ids>>>>'+invoiceIds);
        Apts_InvoiceBillingStatusupdate.changeInvoicebillingStatus(invoiceIds, 'Approved', 'Approved', 'Invoiced');
    }
    
    public static  void changeInvoicebillingStatus(List<Id> invoiceIds, String invoiceStatus, String lineItemStatus, String billingScheduleStatus){
        Apttus_Billing__Invoice__c[] invoices = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__Invoice__c Where Id in :invoiceIds];
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
    }
    
   
}