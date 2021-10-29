/*
 * Set ISV impac value based on product for corresponding line item
 */
trigger APTS_Default_ISV_Impact on Apttus_Config2__LineItem__c (before insert) {
    Map<ID, Boolean> productISVMap = new Map<ID, Boolean>();
	for (Apttus_Config2__LineItem__c lineItem : Trigger.new) {
        productISVMap.put(lineItem.Apttus_Config2__ProductId__c, false);
    }
    List<Product2> products = [Select Id, APTS_ISV_Impact__c From Product2
                       Where Id in :productISVMap.keySet()];
    for (Product2 product : products) {
        productISVMap.put(product.Id, product.APTS_ISV_Impact__c);
    }
    
    for (Apttus_Config2__LineItem__c lineItem : Trigger.new) {
        if (productISVMap.containsKey(lineItem.Apttus_Config2__ProductId__c) &&
            productISVMap.get(lineItem.Apttus_Config2__ProductId__c)) {
            	lineItem.APTS_ISV_Impact__c = 'Yes';
            } else {
             	lineItem.APTS_ISV_Impact__c = 'No';
            }
    }
}