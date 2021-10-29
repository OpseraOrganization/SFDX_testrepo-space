/** * File Name: Oppgate_UpdatePlannedMeetingAttendee1 
* Description Trigger to The purpose of the trigger is to add the existing Opportuntiy Team Members to the Planned 
* Meeting Attendee when a Planned Meeting is associated to an Opportunity Phase
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Oppgate_UpdatePlannedMeetingAttendee1 on Opportunity_Gate__c (after update) {
List<Opportunity_Gate__c> opplst = Trigger.new;
List<id> newopplst =new List<id> ();
List<Opportunity> oldopplst =new List<Opportunity> ();
List<Planned_Meeting__c> pmlst =new List<Planned_Meeting__c> ();
List<Planned_Meeting_Attendee__c> pmattlst =new List<Planned_Meeting_Attendee__c> ();
List<ID> pmidlst = new List<ID>();
List<ID> oldpmidlst = new List<ID>();
List<Planned_Meeting_Attendee__c> pmattendeelst =new List<Planned_Meeting_Attendee__c> ();
List<Planned_Meeting_Attendee__c> oldpmattendeelst =new List<Planned_Meeting_Attendee__c> ();
List<Planned_Meeting_Attendee__c> deloldpmattendee =new List<Planned_Meeting_Attendee__c> ();
List<Planned_Meeting_Attendee__c> addoldpmattendee =new List<Planned_Meeting_Attendee__c> ();
Planned_Meeting_Attendee__c pmatt = null;
List<Opportunity_Sales_Team__c> osteamlst = new List<Opportunity_Sales_Team__c>();
Map<id,id> m1 =new Map<ID,ID>();
Map<id,id> m2 =new Map<ID,ID>();

//Creating a list of records for which new Planned Meeting is added or Planned Meeting is changed.Trigger runs for this set of records only
for(integer i=0;i<opplst.size();i++)
{
if(opplst[i].Planned_Meeting__c != Trigger.old[i].Planned_Meeting__c )
{
newopplst.add(opplst[i].opportunity__c);
if(opplst[i].Planned_Meeting__c!=null)
pmidlst.add(opplst[i].Planned_Meeting__c);
if(Trigger.old[i].Planned_Meeting__c!=null)
oldpmidlst.add(Trigger.old[i].Planned_Meeting__c);
}
}
System.debug('*********************oldpmidlst'+oldpmidlst);
System.debug('*********************oldpmidlst.size'+oldpmidlst.size());

//Deleting all existing Plant Meeting Attendees for the related Planned Meeting. Flag field is added so that records which the user  adds manually is not deleted.
if(oldpmidlst.size()>0)
{
oldpmattendeelst = [select user__c,contact__c,Opportunity__c from Planned_Meeting_Attendee__c where Planned_Meeting__c in : oldpmidlst and flag__c = true];
for(integer i=0;i<oldpmattendeelst.size();i++)
{
  for(integer j=0;j<newopplst.size();j++)
       { 
       if( newopplst[j]==oldpmattendeelst[i].Opportunity__c)
          {
              deloldpmattendee.add(oldpmattendeelst[i]);
          }
       }

}
if(deloldpmattendee.size()>0)
      {
           delete deloldpmattendee;
      }     
}

//Querying the existing Attendees for the new Planned Meeting and preparing map of opportunity and Planned Meeting for further processing

if(pmidlst.size()>0)
{
pmattendeelst = [select user__c,contact__c,Opportunity__c from Planned_Meeting_Attendee__c where Planned_Meeting__c in : pmidlst];
for(integer i=0;i<pmattendeelst.size();i++)
{
  for(integer j=0;j<newopplst.size();j++)
       { 
       if( newopplst[j]==pmattendeelst[i].Opportunity__c)
          {
              addoldpmattendee.add(pmattendeelst[i]);
              m1.put(newopplst[j],pmattendeelst[i].contact__c);
              m2.put(newopplst[j],pmattendeelst[i].user__c);
              
          }
       }

}
}

system.debug('m1........'+m1);
system.debug('m2.......'+m2);

//Creating list of Planned Meeting Attendees to  be inserted by ensuring that duplicate Planned Meeting attendee is not inserted for the same Opportunity
if(newopplst.size()>0)
{
osteamlst = [select name,user__c,contact__c,Opportunity__c from Opportunity_Sales_Team__c where Opportunity__c in :newopplst  ];
system.debug('list of opportunity sales team'+osteamlst);
List<Opportunity> ls = [select name,Planned_Meeting__c from Opportunity where id in :newopplst];
system.debug('lsssssssssssssss.......'+ls);
for(integer i=0;i<newopplst.size();i++)
{ 
   for(integer k=0;k<osteamlst.size();k++)
    {
    
    if(osteamlst[k].Opportunity__c == ls[i].id && ((osteamlst[k].user__c != m2.get(newopplst[i]) && osteamlst[k].contact__c != m1.get(newopplst[i]))||( m1.size()==0 && m2.size()==0 )))
      {
    system.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    
    pmatt =new Planned_Meeting_Attendee__c();
    pmatt.user__c = osteamlst[k].user__c;
    pmatt.contact__c = osteamlst[k].contact__c;
    pmatt.Planned_Meeting__c = opplst[0].Planned_Meeting__c;
    pmatt.Opportunity__c = newopplst[i];
    pmatt.flag__c = true;
    pmattlst.add(pmatt);
   
    }
    }
}
}
try
{
//Inserting planned Meeting Attendees
if(pmattlst.size()>0)
{
insert pmattlst;
}

}
catch(Exception e)

{
system.debug('Exception in inserting planned meeting attendees'+e);
}


}