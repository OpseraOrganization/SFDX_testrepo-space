/** * File Name: Event_UpdatePlannedMeeting
* Description Trigger to Update Planned Meeting when related Event is updated 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Event_UpdatePlannedMeeting on Event(before update)
{
//Declaring variables
//List<Event> evelst =Trigger.new;

List<Event> evelst = new List<Event>();
    for(Event nevent : Trigger.new){
        if(nevent.recordtypeid != label.BGA_Event){
            evelst.add(nevent);
        }
    }

List<Id> idlist = new List<ID>();
List<Planned_Meeting__c> pmlst = new List<Planned_Meeting__c>();
List<Planned_Meeting__c> newpmlst = new List<Planned_Meeting__c>();

//Adding Planned Meeting IDs
for(integer i=0;i<evelst.size();i++)
{
idlist.add(evelst[i].whatid);
}

//Querying related Planned Meeting
if(idlist.size()>0)
{
pmlst =[select name from Planned_Meeting__c where id in :idlist];
}

//Updating Planned Meeting with changes in Event
for(integer i=0;i<evelst.size();i++)
{
     for(integer k=0;k<pmlst.size();k++)
     {
     if(pmlst[k].id==evelst[i].whatid)
     {
     pmlst[k].Assigned_To__c = evelst[i].Ownerid;
     pmlst[k].location__c = evelst[i].Location;
     pmlst[k].Meeting_Status__c = evelst[i].Meeting_Status__c;
     pmlst[k].start__c = evelst[i].StartDateTime;
     pmlst[k].end__c =evelst[i].enddateTime;
     pmlst[k].Meeting_Status_Notes__c = evelst[i].Meeting_Status_Notes__c;
     pmlst[k].subject__c = evelst[i].subject; 
     pmlst[k].Meeting_Proposed_Timeframe__c = evelst[i].Meeting_Proposed_Timeframe__c;
     pmlst[k].Meeting_Meal_Required__c =evelst[i].Meeting_Meal_Required__c;
     pmlst[k].Meeting_Outcome__c = evelst[i].Meeting_Outcome__c;
     newpmlst.add(pmlst[k]);
     }
     }
}
try
{
if(newpmlst.size()>0)
{
update newpmlst;
}
}
catch(Exception e)
{
System.debug('Exception...........'+e);
}
}