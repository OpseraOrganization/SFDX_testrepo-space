/*
 * moving ponumber/podate on invoice level from line item level
 * updates integration status fields
 */
trigger APTS_OnInvoiceRunComplete on Apttus_Billing__InvoiceRunResult__c (after insert, after update) {
    List<Id> runReultIds = new List<Id>();
    for (Apttus_Billing__InvoiceRunResult__c runResult : Trigger.new) {
        if(runResult.Apttus_Billing__Status__c == 'Completed' && 
          (Trigger.isInsert || Trigger.oldMap.get(runResult.id).Apttus_Billing__Status__c != 'Completed')){
            runReultIds.add(runResult.id);
        }
    }
    if(!runReultIds.isEmpty()){
        /*
         * agreagating ponumber, podate, will be same for all line items under same invoice 
         */
        Apttus_Billing__Invoice__c[] invoices = [Select Id, APTS_Integration_Status__c,Apttus_Billing__Status__c, APTS_Integration_Requested__c, APTS_Integration_Result__c, APTS_Integration_Method__c From Apttus_Billing__Invoice__c Where Apttus_Billing__InvoiceRunResultId__c in :runReultIds];
        AggregateResult[] groupedResults = [Select Apttus_Billing__InvoiceId__c, MAX(APTS_PO_Date__c), MAX(APTS_PO_Number__c) From Apttus_Billing__InvoiceLineItem__c
                                            Where Apttus_Billing__InvoiceId__r.Apttus_Billing__InvoiceRunResultId__c in :runReultIds 
                                            Group By Apttus_Billing__InvoiceId__c];
        Map<ID, Date> poDates = new Map<ID, Date>();
        Map<ID, String> poNumbers = new Map<ID, String>();
        if (groupedResults != null && groupedResults.size() > 0)  {
            for (AggregateResult ar : groupedResults)  {
                poDates.put((ID)ar.get('Apttus_Billing__InvoiceId__c'), (Date)ar.get('expr0'));
                poNumbers.put((ID)ar.get('Apttus_Billing__InvoiceId__c'), (String)ar.get('expr1'));
            }
        }
        if(!invoices.isEmpty()){
            for(Apttus_Billing__Invoice__c invoice : invoices){
                invoice.APTS_Integration_Status__c = 'To be Processed';
                invoice.APTS_Integration_Method__c = 'Simulate Order';
                invoice.APTS_Integration_Result__c = null;
                invoice.APTS_Integration_Requested__c = Datetime.now();
                invoice.Apttus_Billing__PONumber__c = poNumbers.get(invoice.Id);
                invoice.APTS_PO_Date__c = poDates.get(invoice.Id);
            }

            update invoices;
        }
    }   
}