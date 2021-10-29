/*
Created By : Puvaneswari
Created Date : 10-March-2020
Usages : CaseQualityTrigger to validate if case has only one Case Quality Audit and setting value for First_Contact_SLA__c
	     based on Case:Customer Support Frequency
*/
trigger CaseQualityTrigger on Case_Quality_Audit__c (before insert) {
    list<Case_Quality_Audit__c> tasklist = new list<Case_Quality_Audit__c>();
    set<id> caseids = new set<id>();
    map<id,Case_Quality_Audit__c> csqMAP = new map<id,Case_Quality_Audit__c>();
    //map<id,AccountTeamMember > actemmem = new map<id,AccountTeamMember >();
    //map<id,list<task>> tmap = new map<id,list<task>>();
    
    for(Case_Quality_Audit__c casequality : trigger.new)
    {
        if(!string.IsEmpty(casequality.Case__c)){
            caseids.add(casequality.Case__c);
            csqMAP.put(casequality.Case__c,casequality);
        }
    }
    MAp<id,Case_Quality_Audit__c> caxlist = new Map<id,Case_Quality_Audit__c>();
    MAp<id,Case_Quality_Audit__c> calist = new Map<id,Case_Quality_Audit__c>();
    caxlist= new Map<id,Case_Quality_Audit__c>([Select id,Case__c from Case_Quality_Audit__c where Case__c in:caseids]);
    system.debug(caxlist.size());
    for(Case_Quality_Audit__c l :caxlist.values()){
        calist .put(l.case__c,l);
    }
    for (Case_Quality_Audit__c c: Trigger.new )
    {
        System.debug(c.case__c);
        if (null!=calist.get(c.Case__c) ) 
        {
            c.adderror('There can be only one child Case Quality Audit record for a Case');
        }
    }
    list<Case> csList = [Select id,Communication_Channel__c,Customer_Update_Frequency__c,Time_Email_Sent__c,Created_date__c from case where id in : caseids];
    if(csList != null){
        for(Case c : csList){
            If(!string.isEmpty(c.Communication_Channel__c) && c.Communication_Channel__c == 'E-mail' && !string.isEmpty(c.Customer_Update_Frequency__c) &&
               c.Time_Email_Sent__c != null){
                   Integer timeDif = Integer.valueOf((c.Time_Email_Sent__c.getTime() - (c.Created_date__c).getTime())/(1000*60));
                   Integer stdDif = CaseQualityHandler.calcCUFMins(c.Customer_Update_Frequency__c);
                   if(stdDif >= timeDif){
                       csqMAP.get(c.id).First_Contact_SLA__c = '10';
                   } else csqMAP.get(c.id).First_Contact_SLA__c = '0';
               }
        }
    }
}