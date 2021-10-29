@isTest
public class APTS_Default_ISV_ImpactTest {
	@isTest
    public static void testInsert() {
		Apttus_Config2__LineItem__c lineItem = TestDataFactory.createConfigLineItem();
        lineItem = [Select Id, APTS_ISV_Impact__c From Apttus_Config2__LineItem__c Where Id = :lineItem.Id];
        System.assertEquals(lineItem.APTS_ISV_Impact__c, 'No');
        
        lineItem = TestDataFactory.createConfigLineItemWithISVTrue();
        lineItem = [Select Id, APTS_ISV_Impact__c From Apttus_Config2__LineItem__c Where Id = :lineItem.Id];
        System.assertEquals(lineItem.APTS_ISV_Impact__c, 'Yes');
    }
}