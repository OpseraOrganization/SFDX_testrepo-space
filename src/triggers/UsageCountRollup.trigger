/*
Usage:to update usage count from entitlements (child) to contract (parent)
Testclass Name: TestClass_Reservation_UpdateUsage
*/
trigger UsageCountRollup on Entitlement__c (after delete, after insert, after update) {

    Map<id, string> cntIds = new Map<id, String>();
    Map<String, String> entcasemapclass = new Map<String, String>();
    Map<String, String> entcasemapsubclass = new Map<String, String>();
    List<Case> cslist = new List<Case>();
    List<contract> contractsToUpdate = new List<contract>();
    list<Entitlement__c> entlstupdate = new list<Entitlement__c>();
    Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contract Administration').getRecordTypeId();
    Entitlement_to_Case_mappings__mdt[] entcasemappings = [SELECT Case_Classification__c, Case_Sub_Class__c, Entitlement_Sub_Type__c ,Entitlement_Type__c FROM Entitlement_to_Case_mappings__mdt];
    for(Entitlement_to_Case_mappings__mdt ecmp: entcasemappings){
        entcasemapclass.put(ecmp.Entitlement_Type__c, ecmp.Case_Classification__c);
        entcasemapsubclass.put(ecmp.Entitlement_Type__c+ecmp.Entitlement_Sub_Type__c, ecmp.Case_Sub_Class__c);
    }
    
    if (Trigger.isInsert){
    for (Entitlement__c en : Trigger.new)
        if(en.Contract_Record_Type__c == 'Training Contracts')
        {
        cntIds.put(en.Contract_Number__c, en.SBU__c);
        }
    }
    if(Trigger.isUpdate){
        for (Entitlement__c en : Trigger.new){
            if(en.Case_Creation__c){
                system.debug('trigger.oldmap.get(en.Id).Case_Creation__c-->'+trigger.oldmap.get(en.Id).Case_Creation__c);
                system.debug('trigger.newmap.get(en.Id).Case_Creation__c-->'+trigger.newmap.get(en.Id).Case_Creation__c);
                if((trigger.oldmap.get(en.Id).Case_Creation__c) != (trigger.newmap.get(en.Id).Case_Creation__c)){
                    System.debug('Different Case Creation');
                    for(Contract ctr: [Select OwnerId, Notes__c, Contract_Number_I_Many__c, AccountId from Contract where id=: en.Contract_Number__c]){
                    System.debug('en.Contract_Number__r.OwnerId::'+ctr.Contract_Number_I_Many__c);
                    //en.Case_Creation__c = false;
                    Entitlement__c etl = new Entitlement__c(Id=en.Id, Case_Creation__c=false);
                    entlstupdate.add(etl);
                    Case cs = new Case();
                    cs.Origin = 'CNT Entitlement';
                    cs.RecordTypeId = devRecordTypeId;
                    cs.OwnerId = ctr.OwnerId;
                    cs.status = 'Open';
                    cs.Internal_HW_Action__c = en.Name;
                    cs.Classification__c = entcasemapclass.get(en.Entitlement_Type__c);
                    String typeandsub = en.Entitlement_Type__c+en.Entitlement_Sub_Type__c;
                    System.debug('typeandsub'+typeandsub);
                    cs.Sub_Class__c = entcasemapsubclass.get(typeandsub);
                    //cs.CreatedDate = en.Entitlement_Start_Date__c;
                    cs.Serv_Contract__c = en.Contract_Number__c;
                    cs.Contract_Number__c = ctr.Contract_Number_I_Many__c;
                    cs.Notes__c = ctr.Notes__c;
                    //cs.ContactId = ctr.OwnerId;
                    cs.AccountId = ctr.AccountId;
                    cslist.add(cs);
                    }
                }
            }
        }
        System.debug('cslist::'+cslist);
        insert cslist;
        update entlstupdate;
    }
    if (Trigger.isUpdate || Trigger.isDelete) {
        for (Entitlement__c en : Trigger.old)
        if(en.Contract_Record_Type__c == 'Training Contracts')
        {
            cntIds.put(en.Contract_Number__c, en.SBU__c);
        }
    }
    If(cntIds != null && !cntIds.isEmpty()){
    AggregateResult[] groupedResults = [SELECT Contract_Number__c, Sum(usage_count__c),
      sum(Number_Of_Seats__c),sum(Usage_Cap__c),avg(Number_Of_Seats__c),avg(Usage_Cap__c) FROM Entitlement__c where Contract_Number__c in:cntIds.KeySet()
       GROUP BY Contract_Number__c];
    
    for (AggregateResult ar : groupedResults)  {
    System.debug('Campaign ID' + ar.get('Contract_Number__c'));
    System.debug('Average amount' + ar.get('expr0'));
    contract cn = new contract();
    cn.id = (id)ar.get('Contract_Number__c');
    if(cntIds.get(cn.id)== 'BGA'){
    cn.usage_count__c = (Decimal)ar.get('expr0');
    cn.Number_Of_Seats__c = (Decimal)ar.get('expr1');
    cn.Usage_Cap__c = (Decimal)ar.get('expr2');
    contractsToUpdate.add(cn);
    }
    if(cntIds.get(cn.id)== 'ATR'){
    cn.usage_count__c = (Decimal)ar.get('expr0');
    cn.Number_Of_Seats__c = (Decimal)ar.get('expr3');
    cn.Usage_Cap__c = (Decimal)ar.get('expr4');
    contractsToUpdate.add(cn);
    }
    }
    update contractsToUpdate;
    }

}