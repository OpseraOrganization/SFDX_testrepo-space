@isTest
public class APTS_InvoiceByPONumberCallback_Test
{
    @isTest
    public static void testSelect() {
        APTS_InvoiceGroupingByPONumberCallback obj= new APTS_InvoiceGroupingByPONumberCallback();
        
        Apttus_Billing.CustomClass.Parameters obj2= new Apttus_Billing.CustomClass.Parameters();
        
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        insert objOrder;
        
        Apttus_Config2__OrderLineItem__c objLineitem = new Apttus_Config2__OrderLineItem__c();
        objLineitem.Apttus_Config2__LineNumber__c=1;
        objLineitem.Apttus_Config2__ItemSequence__c=1;
        objLineitem.CurrencyIsoCode='EUR';
        objLineitem.Apttus_Config2__OrderId__c=objOrder.id;
        insert objLineitem;
        
        Apttus_Billing__BillingSchedule__c objBS= new Apttus_Billing__BillingSchedule__c();
        objBS.CurrencyIsoCode='EUR';
        objBS.Apttus_Billing__OrderLineItemId__c=objLineitem.Id;
        insert objBS;
        
        obj2.billingScheduleSO=objBS;
        
        obj.getKeyComponentForInvoiceGrouping(obj2);
    }
}