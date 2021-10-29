/***********************************************************************************************************
* Company Name          : NTT Data
* Name                  : FSSTechIssuelimitrecords 
* Description           : Trigger to limit one Aircraft & Subscription Case Extension Record for a Case 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
***********************************************************************************************************/
trigger FSSTechIssuelimitrecords on Aircraft_Subscription_Case_Extension__c (before insert) {
    set<id> caseid=new set<id>();
    Set<Id> setcase = new Set<Id>();
    for(Aircraft_Subscription_Case_Extension__c i : Trigger.new) {
        caseid.add(i.Case__c);
        system.debug(i.Case__c);
    }
    MAp<id,Aircraft_Subscription_Case_Extension__c> caxlist = new Map<id,Aircraft_Subscription_Case_Extension__c>();
    MAp<id,Aircraft_Subscription_Case_Extension__c> calist = new Map<id,Aircraft_Subscription_Case_Extension__c>();
    caxlist=new Map<id,Aircraft_Subscription_Case_Extension__c>([Select id,Case__c from Aircraft_Subscription_Case_Extension__c where Case__c in:caseid]);
    system.debug(caxlist.size());
    for(Aircraft_Subscription_Case_Extension__c l :caxlist.values()){
        calist.put(l.Case__c,l);
    }
    for (Aircraft_Subscription_Case_Extension__c c: Trigger.new )
    {
        System.debug(c.Case__c);
        if (null!=calist.get(c.Case__c) || setcase.contains(c.Case__c) ) 
        {
            c.adderror('There can be only one child Case Extension record for a Case');
        }
        else if(!setcase.contains(c.Case__c) ){
            setcase.add(c.Case__c);
        }
    }
}