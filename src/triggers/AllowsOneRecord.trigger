trigger AllowsOneRecord on Technical_Issue_Case_Extensions__c (before insert) {
set<Id> tecextid = New Set<Id>(); 
set<id> caseid=new set<id>();
Map<Id,Case> cases = new Map<Id,Case>();
List<Case> listGL = new List<Case>();
Set<Id> setcase = new Set<Id>();
//cases.put(caseid,);
for (Technical_Issue_Case_Extensions__c i : Trigger.new)
 {
  caseid.add(i.Case_object__c);
  system.debug(i.Case_object__c);
  //cases.add();
  }
MAp<id,Technical_Issue_Case_Extensions__c > caxlist = new Map<id,Technical_Issue_Case_Extensions__c >();
MAp<id,Technical_Issue_Case_Extensions__c > calist = new Map<id,Technical_Issue_Case_Extensions__c >();
caxlist=new Map<id,Technical_Issue_Case_Extensions__c >([Select id,Case_object__c from Technical_Issue_Case_Extensions__c  where Case_object__c in:caseid]);
 system.debug(caxlist.size());
 for(Technical_Issue_Case_Extensions__c l :caxlist.values())
 {
 calist .put(l.case_object__c,l);
 }
  for (Technical_Issue_Case_Extensions__c c: Trigger.new )
  {
  System.debug(c.case_object__c);
    if (null!=calist.get(c.Case_object__c) || setcase.contains(c.case_object__c) ) 
    {
      c.adderror('There can be only one child Technical Issue Case Extension record for a Case');
    }
    else if(!setcase.contains(c.case_object__c) )
    {
    setcase.add(c.case_object__c);
    }
    
    
  }
}