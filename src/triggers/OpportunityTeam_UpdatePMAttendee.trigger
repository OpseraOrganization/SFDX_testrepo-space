/** * File Name: OpportunityTeam_UpdatePMAttendee
* Description This trigger is to Update the Planned Meeting Attendee object.When a new Opportunity Team member is added to the 
Opportunity ,those members gets added to the attendee list of Planned Meeeting associated to the Phase records of the 
Opportunity 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger OpportunityTeam_UpdatePMAttendee on Opportunity_Sales_Team__c (after insert,after update,after delete) {
List<Opportunity_Sales_Team__c> oppteam ;
if(Trigger.isdelete)
oppteam = Trigger.old;
else
oppteam = Trigger.new ;
List<ID> oppidlst = new List<ID>();
List<ID> pmidlst = new List<ID>();
List<Opportunity> lstopp = new List<Opportunity>();
List<Opportunity_Sales_Team__c> allteam = new List<Opportunity_Sales_Team__c> ();
List<Opportunity_Gate__c> phaselst =new List<Opportunity_Gate__c>();
List<Planned_Meeting_Attendee__c> pmattlstnew = new List<Planned_Meeting_Attendee__c>();
List<Planned_Meeting_Attendee__c> pmattlstdel = new List<Planned_Meeting_Attendee__c>();
List<Planned_Meeting_Attendee__c> attlst = new List<Planned_Meeting_Attendee__c>();
MAP <Id,ID> m2 = new MAP<ID,ID>();
Planned_Meeting_Attendee__c pmattn;

map<id,string> userFunctionalRoleMap = new map<id,string>();
String prof = Userinfo.getProfileId();
String profname = [Select name from Profile where Id=:prof].name;
profname = profname.tolowercase();
set<id> allteamForUpdate = new set<id> ();
for(integer i=0;i<oppteam.size();i++)
{
system.debug('Testing to Find the error at stage1');
//Added logic to push the User Functional Role to User object.
if((profname == 'system administrator')||(profname == 'sales admin')||(profname == 'sales analyst')||(profname == 'sales developer')){
    if(oppteam[i].Push_User_Functional_Role__c){
        userFunctionalRoleMap.put(oppteam[i].user__c,oppteam[i].Opportunity_Team_Role__c);
        allteamForUpdate.add(oppteam[i].id);
    }
    oppidlst.add(oppteam[i].Opportunity__c);
    }
}
if(oppidlst.size()>0)
{
allteam = [select name,Opportunity__c,User__c,Contact__c from Opportunity_Sales_Team__c where Opportunity__c in :oppidlst limit 1];
phaselst=[select name,planned_Meeting__c,Opportunity__c from Opportunity_Gate__c where Opportunity__c in :oppidlst and actual_Date__c =null and planned_Meeting__c !=null order by serial_no__c desc limit 1];
}
for(integer i=0;i<phaselst.size();i++)
{
pmidlst.add(phaselst[i].Planned_Meeting__C);
m2.put(phaselst[i].Opportunity__c ,phaselst[i].Planned_Meeting__C);
}
if(pmidlst.size()>0)
{
pmattlstdel = [select name,Opportunity__c from Planned_Meeting_Attendee__c where Planned_Meeting__c in :pmidlst and Opportunity__c in :oppidlst limit 1];
}
System.debug('******************************pmattlstdel  '+pmattlstdel);
//Deleting the existing Planned Meeting attendee for the Opportunity
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
    pmattn.user__c = allteam[i].user__c;
    pmattn.contact__c = allteam[i].contact__c;
    pmattn.Opportunity__c = allteam[i].Opportunity__c;
    pmattn.Planned_Meeting__c = m2.get(allteam[i].Opportunity__c);
    pmattn.flag__c = true;
    pmattlstnew.add(pmattn);
 
 }
 }
//Inserting Planned Meeting Attendee
 if(pmattlstnew.size()>0)
 {
 insert pmattlstnew;
 }
 if(userFunctionalRoleMap.size()>0){
    list<User> userList = new list<User>([select id,Functional_Role__c from User where id in :userFunctionalRoleMap.keySet()]);
    
    for(User usrRec:userList){
        if(userFunctionalRoleMap.get(usrRec.id) != null){
            usrRec.Functional_Role__c = userFunctionalRoleMap.get(usrRec.id);
            system.debug('User role updated to'+userFunctionalRoleMap.get(usrRec.id));
        }
    }
    if(allteamForUpdate.size()>0){
        list<Opportunity_Sales_Team__c> ostlist = new list<Opportunity_Sales_Team__c>([select id,Push_User_Functional_Role__c from Opportunity_Sales_Team__c where id in :allteamForUpdate]);
        for(Opportunity_Sales_Team__c ost:ostlist){
            ost.Push_User_Functional_Role__c = false;
        }
        update ostList;
    }
    if(userList.size()>0){
        update userList;
    }
 }
}