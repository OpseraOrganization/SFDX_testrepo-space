/** * File Name: PlannedMeeting_UpdateEvent
* Description Trigger to related Event when changes are made to Planned Meeting 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger PlannedMeeting_UpdateEvent on Planned_Meeting__c(before  update)
{
//Variable Declaration
List<Planned_Meeting__c> pmlst =Trigger.new;
List<Id> idlist = new List<ID>();
List<Event> evelst = new List<Event>();
List<Event> newevelst = new List<Event>();
List<Event> lsevent = new List<Event>();

//Adding Planned Meeting IDs
for(integer i=0;i<pmlst.size();i++)
{
idlist.add(pmlst[i].id);
}
//Querying related Event
if(idlist.size()>0)
evelst =[select  Ownerid,whatid from Event where whatid in :idlist];
//Updating Event
if(evelst.size()>0)
{
for(integer i=0;i<pmlst.size();i++)
{
     for(integer k=0;k<evelst.size();k++)
     {
     if(evelst[k].whatid==pmlst[i].id)
     {
     evelst[k].location = pmlst[i].Location__c;
     evelst[k].Meeting_Status__c =pmlst[i].Meeting_Status__c;
     evelst[k].StartDateTime = pmlst[i].start__c;
     evelst[k].enddateTime = pmlst[i].end__c;
     evelst[k].Meeting_Status_Notes__c = pmlst[i].Meeting_Status_Notes__c;
     evelst[k].subject = pmlst[i].subject__c;
     evelst[k].Meeting_Proposed_Timeframe__c =pmlst[i].Meeting_Proposed_Timeframe__c;
     evelst[k].Meeting_Meal_Required__c = pmlst[i].Meeting_Meal_Required__c ;
     evelst[k].Meeting_Outcome__c = pmlst[i].Meeting_Outcome__c;
     newevelst.add(evelst[k]);
     }
     }
  
}
}
try
{
if(newevelst.size()>0)
update newevelst;
}
catch(Exception e)
{
System.debug('Exception...........'+e);
}
}