public with sharing class APULicenseController 
{
  public Id orderId {get;set;}
    public List<CPQ_Platform__c> getcpqs()
    {
        List<CPQ_Platform__c> cpq;
        List<Apttus_Config2__OrderLineItem__c> lstACOL = [Select id,Apttus_Config2__OrderId__c,Apttus_Config2__OptionId__c from Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c =: orderId AND Apttus_Config2__OptionId__c != Null AND Apttus_Config2__OptionId__r.License_Type__c = 'APU'];
        Set<id> OrderLineitemids = New Set<id>();
        For(Apttus_Config2__OrderLineItem__c OL : lstACOL)
        {
            OrderLineitemids.Add(OL.id);
        }
        
        cpq = [SELECT Name,Activation_Key__c FROM CPQ_Platform__c WHERE Order_Line_Item__c IN : OrderLineitemids];
        return cpq;
    }
}