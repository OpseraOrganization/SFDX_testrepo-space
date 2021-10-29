trigger DrAppList_update_oppteam on DR_Approvers_List__c (after update) {
map<Id,Id> oldmap= New Map<Id,Id>();
Set<Id> appid= New Set<Id>();
string sbu, cbt;
list<Opportunity_Sales_Team__c> oppTeam=New list<Opportunity_Sales_Team__c>();
list<Opportunity_Sales_Team__c> toCreate=New list<Opportunity_Sales_Team__c>();
List<Id> userIdList = new List<Id>();
List<Id> OppIdList = new List<Id>();
Id newApprover,oldapprover;
for(DR_Approvers_List__c dr:Trigger.new){
    if(Trigger.oldMap.get(dr.Id).Approver__c!=Trigger.newMap.get(dr.Id).Approver__c){
    newApprover=Trigger.newMap.get(dr.Id).Approver__c;
    oldapprover=Trigger.oldMap.get(dr.Id).Approver__c;
    sbu = Trigger.newMap.get(dr.Id).sbu__c;
    cbt = Trigger.newMap.get(dr.Id).cbt__c;
    userIdList.add(Trigger.newMap.get(dr.Id).Approver__c);
    }
}
System.debug('&&&&&&&&&&&&&'+oldApprover+'&&&&&&&'+newApprover);

if(userIdList.size()>0){
oppTeam=[select id,User__c,opportunity__c from Opportunity_Sales_Team__c where User__c =:oldApprover and
Created_due_to_CBT__c=true  and opportunity__r.sbu__c =:sbu and opportunity__r.cbt_tier_2__c =:cbt
and opportunity__r.active__C = true];
integer oppTeamsize=oppTeam.size();
System.debug('&&&&&&&&&oppTeam'+oppTeam);
  for(integer i=0;i<oppTeamsize;i++){
  OppIdList.add(oppTeam[i].opportunity__c);
  }
}

if(oppTeam.size()>0)
delete oppTeam;

if(oppIdList.size()>0){
integer oppSize=OppIdList.size();
    for(integer j=0;j<oppSize;j++){
    Opportunity_Sales_Team__c ost= new Opportunity_Sales_Team__c();
    ost.User__c=newApprover;
    ost.opportunity__c=OppIdList[j];
    ost.Created_due_to_CBT__c=true;
    toCreate.add(ost);   
    }
  try{
    if(toCreate.size()>0)
    insert toCreate;
    }catch(Exception e){}
}


}