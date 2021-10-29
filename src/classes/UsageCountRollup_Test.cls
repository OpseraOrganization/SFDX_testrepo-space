@istest
public class UsageCountRollup_Test {
    public static testmethod void method1(){
    Id devRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Training Contracts').getRecordTypeId();
	Account acc = new Account();
    acc.Name = 'test account';
    acc.Strategic_Business_Unit__c = 'ATR';
    insert acc;    
    Contract ctr = new Contract();
    ctr.RecordTypeId = devRecordTypeId;
    ctr.Status = 'New';
    ctr.StartDate = system.Today();
    ctr.Type__c = 'APM';
    ctr.AccountId = acc.id;
    //ctr.SBU__c = 'ATR';
    insert ctr;
        
    Entitlement__C etc = new Entitlement__C();
    etc.Contract_Number__c = ctr.id;
    etc.Entitlement_Type__c = 'Escalation';
	etc.Entitlement_Sub_Type__c = 'Other';
    etc.Entitlement_Start_Date__c = System.today();
    etc.Reference__c = 'test';
    //etc.SBU__c = 'ATR';
    insert etc;
    etc.Case_Creation__c = true;
    update etc;
    }
}