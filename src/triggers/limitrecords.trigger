/***********************************************************************************************************
* Company Name          : NTT Data
* Name                  : Limit Records
* Description           : Trigger to limit one Case Extension Record for a Case 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* JAN-28-2015      1.1            NTTData               SR# INC000008137607- Addition of new fields to the Case extension object and limiting one record for Case
***********************************************************************************************************/
trigger limitrecords on Case_Extension__c (before insert) {
set<Id> extid = New Set<Id>(); 
set<id> caseid=new set<id>();
Map<Id,Case> cases = new Map<Id,Case>();
List<Case> listGL = new List<Case>();
Set<Id> setcase = new Set<Id>();
//cases.put(caseid,);
for (Case_Extension__c i : Trigger.new) {
  caseid.add(i.Case_object__c);
  system.debug(i.Case_object__c);
  //cases.add();
  }
MAp<id,Case_Extension__c> caxlist = new Map<id,Case_Extension__c>();
MAp<id,Case_Extension__c> calist = new Map<id,Case_Extension__c>();
caxlist=new Map<id,Case_Extension__c>([Select id,Case_object__c from Case_Extension__c where Case_object__c in:caseid]);
 system.debug(caxlist.size());
 for(Case_Extension__c l :caxlist.values()){
 calist .put(l.case_object__c,l);
 }
  for (Case_Extension__c c: Trigger.new )
  {
  System.debug(c.case_object__c);
    if (null!=calist.get(c.Case_object__c) || setcase.contains(c.case_object__c) ) 
    {
      c.adderror('There can be only one child Case Extension record for a Case');
    }
    else if(!setcase.contains(c.case_object__c) ){
    setcase.add(c.case_object__c);
    }
    
    
  }
}