/** * File Name: PlannedMeeting_Share2Coordinator
* Description Trigger to give access to a Planned Meeting for all Event coordinators associated to the event
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* Code commented on 28 Feb 2013 for Ticket #338307 since the OWD setings for Planned Meeting has been changed to Public Read/Write 
* and this trigger is no longer needed.
* */ 

trigger PlannedMeeting_Share2Coordinator on Planned_Meeting__c (after insert,before update) {
/*

//Variable Declaration
List<Planned_Meeting__c> lstpm = Trigger.new;
List<Id> eventid = new List<ID>();
List<Id> neweventid = new List<ID>();
List<Id> oldeventid = new List<ID>();
List<Planned_Meeting__c> pm = new List<Planned_Meeting__c>();
List<Planned_Meeting__Share> sharelst = new List<Planned_Meeting__Share>();
List<Event_Team__c> elst = new List<Event_Team__c>();
List<Event_Team__c> oldelst = new List<Event_Team__c>();
List<String> userlst = new List<String>();
List<Planned_Meeting__Share> dlist = new List<Planned_Meeting__Share>();
List<Planned_Meeting__Share> dellst = new List<Planned_Meeting__Share>();

if(Trigger.ISInsert)
{
for(integer i=0;i<lstpm.size();i++)
{
//Filtering out to have only Planned Meetings with Event associated to it for processing 
if(lstpm[i].Event__c!=null)
{
pm.add(lstpm[i]);
eventid.add(lstpm[i].Event__c);
}
}
//Querying the Event Coordinators from Event team object for the events associated to the planned meeting
if(eventid.size()>0)
{
 elst = [select id,name,user__c,Event__c from Event_Team__c where Event__c in :eventid and Event_Coordinator_Flag__c = true ];
}

//Creating list of Planned Meeting Share records for the event coordinators
for(integer k=0;k<pm.size();k++)
{
for(integer i=0;i<elst.size();i++)
{
if(pm[k].Event__c == elst[i].event__c)
{
Planned_Meeting__Share s = new Planned_Meeting__Share();
s.UserOrGroupId = elst[i].User__c;
s.AccessLevel = 'Edit' ;
s.parentId =pm[k].id;
sharelst.add(s);
}
}
}
if(sharelst.size()>0)
{
try{
insert sharelst;
}
catch(Exception e)
{
System.debug('EXCEPTION*************************'+e);
}
}
}

if(Trigger.ISUpdate)
{
for(integer i=0;i<lstpm.size();i++)
{
//Condition check so that code runs only when event in Planned Meeting is updated
if(lstpm[i].Event__c!= Trigger.old[i].Event__c)
{
pm.add(lstpm[i]);
neweventid.add(lstpm[i].Event__c);
oldeventid.add(Trigger.old[i].Event__c);
}
}
//Querying Event Coordinators for the new and old event associated with the planned Meeting
if(neweventid.size()>0)
{
 elst = [select id,name,user__c,Event__c from Event_Team__c where Event__c in :neweventid and Event_Coordinator_Flag__c = true ];
}
if(oldeventid.size()>0)
{
 oldelst = [select id,name,user__c,Event__c from Event_Team__c where Event__c in :oldeventid and Event_Coordinator_Flag__c = true ];
}
for(integer i=0;i<oldelst.size();i++)
{
userlst.add(oldelst[i].User__c);
}
if(oldeventid.size()>0)
{
dellst = [select id,parentId,UserOrGroupId from Planned_Meeting__Share where UserOrGroupId in :userlst  ];
}

for(integer i=0;i<pm.size();i++)
{
for(integer k=0;k<dellst.size();k++)
{
if(dellst[k].parentid == pm[i].Id)
{
dlist.add(dellst[k]);
}
}
}

//Creating list of Planned Meeting Share records for the coordinators of the updated event
for(integer k=0;k<pm.size();k++)
{
for(integer i=0;i<elst.size();i++)
{
if(pm[k].Event__c == elst[i].event__c)
{
Planned_Meeting__Share s = new Planned_Meeting__Share();
s.UserOrGroupId = elst[i].User__c;
s.AccessLevel = 'Edit' ;
s.parentId =pm[k].id;
sharelst.add(s);
}
}
}

if(sharelst.size()>0)
{
try{
insert sharelst;
}
catch(Exception e)
{
System.debug('EXCEPTION sharelst*************************'+e);
}
}

//Deleting access to the Planned Meetings  for the coordinators of the previous event
if(dlist.size()>0)
{
try{
delete dlist;
}
catch(Exception e)
{
System.debug('EXCEPTION dlist*************************'+e);
}
}
}
*/
}