/** * File Name: PlannedMeeting_PMAttendeeFlag
* Description Trigger to reset Planned Meeting status to  Requested when meeting time or location changes. It also updates the Accept or Decline flag in Attendee
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger  PlannedMeeting_PMAttendeeFlag on Planned_Meeting__c (after insert,before update,after update) {

//Variable Declaration
List<Planned_Meeting__c> pmlst = Trigger.new;
List<ID> pmids = new List<ID>();
List<ID> pmids1 = new List<ID>();
List<Planned_Meeting_Attendee__c> pmattlst = new List<Planned_Meeting_Attendee__c>();
List<Planned_Meeting_Attendee__c> pmattlst1 = new List<Planned_Meeting_Attendee__c>();

if(Trigger.IsBefore)
{
for(integer i=0;i<pmlst.size();i++)
{
// Code to reset Meeting status field and resources field after condition check
//Commented by Kapil on 25/Jan/2011
//if(pmlst[i].Meeting_Status__c != 'Planning' && (Trigger.old[i].Start__c !=  pmlst[i].Start__c || Trigger.old[i].End__c !=  pmlst[i].End__c || Trigger.old[i].Location__c !=  pmlst[i].Location__c))
//Modified by Kapil on 25/Feb/2011 : Field API Name has been changed & Conditions Modified for Defect # 2136
if((pmlst[i].Meeting_Status__c == 'Scheduled' || pmlst[i].Meeting_Status__c == 'Approved' ||
 pmlst[i].Meeting_Status__c == 'Cancelled' ) && (Trigger.old[i].Start_Date__c !=  pmlst[i].Start_Date__c || Trigger.old[i].End_Date__c !=  pmlst[i].End_Date__c || Trigger.old[i].Location__c !=  pmlst[i].Location__c || Trigger.old[i].Start_Time__c !=  pmlst[i].Start_Time__c || Trigger.old[i].End_Time__c !=  pmlst[i].End_Time__c ))

{
pmlst[i].Meeting_Status__c = 'Requested';
pmlst[i].Resources__c = null;
}
}
}

//************** Code to update Planned Meeting Attendees*******************************
if(Trigger.IsAfter)
{
for(integer i=0;i<pmlst.size();i++)
{
//Checking for old and new value for update trigger and placing it in different lists
if(Trigger.Isupdate)
{
if(Trigger.old[i].Meeting_Status__c != 'Requested' && pmlst[i].Meeting_Status__c== 'Requested')
{
pmids.add(pmlst[i].id);
}
if(Trigger.old[i].Meeting_Status__c == 'Requested' && pmlst[i].Meeting_Status__c!= 'Requested')
{
pmids1.add(pmlst[i].id);
}
}
if(Trigger.IsInsert)
{
if(pmlst[i].Meeting_Status__c== 'Requested')
{
pmids.add(pmlst[i].id);
}
}
}
//Querying Planned Meeting Attendee based on the Planned Meeting Id
if(pmids.size()>0)
{
pmattlst = [select name from Planned_Meeting_Attendee__c where Planned_Meeting__c in :pmids];
}
if(pmids1.size()>0)
{
pmattlst1 = [select name from Planned_Meeting_Attendee__c where Planned_Meeting__c in :pmids1];
}
//Updating fields in Planned Meeting Attendee
for(integer i=0;i<pmattlst.size();i++)
{
pmattlst[i].Email_Flag__c = true ;
pmattlst[i].Accepted__c = False ;
pmattlst[i].Declined__c = False ;
}
for(integer i=0;i<pmattlst1.size();i++)
{
pmattlst1[i].Email_Flag__c = false ;

}
try
{
if(pmattlst.size()>0)
update pmattlst ;
}
catch(Exception e)
{
System.debug('Exception in updating planned meeting attendees*********'+pmattlst);
}
try
{
if(pmattlst1.size()>0)
update pmattlst1 ;
}
catch(Exception e)
{
System.debug('Exception in updating planned meeting attendees*********'+pmattlst1);
}
}
}