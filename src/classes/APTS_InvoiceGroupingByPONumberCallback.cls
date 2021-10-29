global class APTS_InvoiceGroupingByPONumberCallback implements Apttus_Billing.CustomClass.IInvoiceGroupingCallback {
    public String getKeyComponentForInvoiceGrouping(Apttus_Billing.CustomClass.Parameters params) {
        ID orderLineItemId = params.billingScheduleSO.Apttus_Billing__OrderLineItemId__c;
        Apttus_Config2__OrderLineItem__c orderLineItem = 
            [Select Id, Apttus_Config2__OrderId__r.Apttus_Config2__PONumber__c From  Apttus_Config2__OrderLineItem__c
            Where Id = :orderLineItemId];
        
        return orderLineItem.Apttus_Config2__OrderId__r.Apttus_Config2__PONumber__c;
    }
}