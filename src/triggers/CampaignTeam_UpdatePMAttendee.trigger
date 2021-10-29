/** * File Name: CampaignTeam_UpdatePMAttendee
* Description This trigger is to Update the Planned Meeting Attendee object.When a new Campaign Team member is added to the 
Campaign ,those members gets added to the attendee list of Planned Meeeting associated to the Phase records of the 
campaign
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger CampaignTeam_UpdatePMAttendee on Campaign_Team__c (after delete, after insert, after update) {

//Declaration of variables    
List<Campaign_Team__c> oppteam ;
List<ID> oppidlst = new List<ID>();
List<ID> pmidlst = new List<ID>();
List<Campaign> lstopp = new List<Campaign>();
List<Campaign_Team__c> allteam = new List<Campaign_Team__c> ();
List<Campaign_Gate__c> phaselst =new List<Campaign_Gate__c>();
List<Planned_Meeting_Attendee__c> pmattlstnew = new List<Planned_Meeting_Attendee__c>();
List<Planned_Meeting_Attendee__c> pmattlstdel = new List<Planned_Meeting_Attendee__c>();
List<Planned_Meeting_Attendee__c> attlst = new List<Planned_Meeting_Attendee__c>();
MAP <Id,ID> m1 = new MAP<ID,ID>();
MAP <Id,ID> m2 = new MAP<ID,ID>();
Planned_Meeting_Attendee__c pmattn;

if(Trigger.isdelete)
oppteam = Trigger.old;
else
oppteam = Trigger.new ;

for(integer i=0;i<oppteam.size();i++)
{
oppidlst.add(oppteam[i].Campaign__c);
}
if(oppidlst.size()>0)
{
allteam = [select name,Campaign__c,Team_User__c,Contact__c from Campaign_Team__c where Campaign__c in :oppidlst];
phaselst=[select name,planned_Meeting__c,Campaign__c from Campaign_Gate__c where Campaign__c in :oppidlst and actual_Date__c =null and planned_Meeting__c !=null order by serial_no__c desc];
}
for(integer i=0;i<allteam.size();i++)
{
m1.put(allteam[i].Id,allteam[i].Campaign__c);
}
for(integer i=0;i<phaselst.size();i++)
{
pmidlst.add(phaselst[i].Planned_Meeting__C);
m2.put(phaselst[i].Campaign__c ,phaselst[i].Planned_Meeting__C);
}
if(pmidlst.size()>0)
{
pmattlstdel = [select name,Campaign__c from Planned_Meeting_Attendee__c where Planned_Meeting__c in :pmidlst and Campaign__c in :oppidlst];
}
System.debug('******************************pmattlstdel  '+pmattlstdel);
//Deleting the existing Planned Meeting attendee for the Campaign
 if(pmattlstdel.size()>0)
 {
 try
 {
 delete pmattlstdel;
 }
 catch(Exception e)
 {
 System.debug('******************************Exception e  '+e);
 }
 }
 //Creating a list of Planned Meeting Attendee to be inserted
 if(phaselst.size()>0)
 {
 for(integer i=0;i<allteam.size();i++)
 {
    pmattn =new Planned_Meeting_Attendee__c();
    pmattn.user__c = allteam[i].team_user__c;
    pmattn.contact__c = allteam[i].contact__c;
    pmattn.Campaign__c = m1.get(allteam[i].Id);
    pmattn.Planned_Meeting__c = m2.get(m1.get(allteam[i].Id));
    pmattn.flag__c = true;
    pmattlstnew.add(pmattn);
 
 }
 }
//Inserting Planned Meeting Attendee
 if(pmattlstnew.size()>0)
 {
 insert pmattlstnew;
 }
}