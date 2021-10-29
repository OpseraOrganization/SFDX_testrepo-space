/** * File Name: PlannedMeeting_UpdateReport
* Description Trigger to copy the users and contacts's name to Planned Meeting for reporting purpose 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger PlannedMeeting_UpdateReport on Planned_Meeting_Attendee__c (after insert,after update,after delete) {

//Variable declaration
List<Planned_Meeting_Attendee__c> pmattlist = new List<Planned_Meeting_Attendee__c>();
List<ID> pmidlist =new List<ID>();
List<Planned_Meeting__c> pmlist = new List<Planned_Meeting__c>();
List<Planned_Meeting__c> newpmlist = new List<Planned_Meeting__c>();
String userstr='',contactstr='',trimuser,trimcontact;
MAP<ID,string> usermap = new MAP<ID,string>();
MAP<ID,string> contactmap = new MAP<ID,string>();

if(Trigger.isDelete)
{
pmattlist = Trigger.old;
}
else
{
pmattlist = Trigger.new;
}

//Getting the Planned Meeting IDs to a list
for(integer i=0;i<pmattlist.size();i++)
{
    if(pmattlist[i].Planned_Meeting__c!=null)
      {
        pmidlist.add(pmattlist[i].Planned_Meeting__c);
      }  
}
//Querying related Planned Meeting 
if(pmidlist.size()>0)
{
pmlist=[select id, name from Planned_Meeting__c where id in :pmidlist];
}
//Querying all the planned meeting attendee related to the planned meeting
for(Planned_Meeting_Attendee__c[] attslist :[select Id,user__c,contact__c,Planned_Meeting__c,Contact_Name_Formulae__c,Contact_is_employee__c,User_Name_Formulae__c from Planned_Meeting_Attendee__c where Planned_MEeting__c in :pmidlist and Planned_MEeting__c!=null])
{
for(Planned_Meeting__c pms : pmlist)
{
for(Planned_Meeting_Attendee__c atts : attslist)
{
if(pms.Id==atts.Planned_Meeting__C)
{
//Constructing the string to update the fields "Attendee" and "Employees"  based on user and contact.Internal contacts should be updated in the field "Employees"
if(atts.Contact_is_employee__c == 'True'|| atts.user__C!=null)
 {
  if(atts.user__C!=null)
   {
    userstr = userstr + atts.User_Name_Formulae__c;
   }
   if(atts.contact__C!=null)
   {
    userstr = userstr +atts.Contact_Name_Formulae__c;
   }
   userstr = userstr +',';
 }
   else
 {
   contactstr = contactstr +atts.Contact_Name_Formulae__c;
   contactstr = contactstr +',';
 }
  
}
}
usermap.put(pms.Id,userstr);
contactmap.put(pms.Id,contactstr);
userstr='';
contactstr='';
}
}
for(integer i=0;i<pmlist.size();i++)
{
  trimuser = usermap.get(pmlist[i].ID);
  if(trimuser != null && trimuser.length()>0)
      {
         //Removing the comma at the end of the string
          trimuser=trimuser.substring(0,trimuser.length()-1); 
      }
  trimcontact = contactmap.get(pmlist[i].ID);
  if(trimcontact!= null && trimcontact.length()>0)
      {   
          //Removing the comma at the end of the string
          trimcontact=trimcontact.substring(0,trimcontact.length()-1);
      } 
  //Updating the fields    
  pmlist[i].Employees__C = trimuser;
  pmlist[i].Attendees__c = trimcontact;
  newpmlist.add(pmlist[i]);           
}
if(newpmlist.size()>0)
{
update newpmlist;
}
}