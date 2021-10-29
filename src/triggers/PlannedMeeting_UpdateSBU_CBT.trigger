/** * File Name: PlannedMeeting_UpdateSBU_CBT
* Description Trigger to fetch the SBU,CBT,CBT Team values from the user records who creates the Planned Meeting
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
* 18/8/2010 - Added code to update the owner field . This will be used to get the email id for sending mail to planned meeting owner
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger PlannedMeeting_UpdateSBU_CBT on Planned_Meeting__c (after insert) {

//Variable Declaration
List<Planned_Meeting__c> PMlist=Trigger.new;
List<Planned_Meeting__c> UpdatePMlist=new List<Planned_Meeting__c>();

//SBU_Formulae__c,CBT_Formulae__c,CBT_Team_Formulae__c are formula fields which hold the SBU,CBT nad CBT team values of the creator  
//Owner custom  field is also updated with Planned Meeting owner id
for(Integer i=0;i<PMlist.size();i++){
  
    Planned_meeting__c pm=new Planned_meeting__c(ID=PMList[i].Id);
    if(PMlist[i].SBU__c==null)
        {
        pm.SBU__c=PMlist[i].SBU_Formulae__c;
        }
    if(PMlist[i].CBT__c==null)
        {  
        pm.CBT__c=PMlist[i].CBT_Formulae__c;
        }
    if(PMlist[i].CBT_Team__c ==null)
        {
         pm.CBT_Team__c=PMlist[i].CBT_Team_Formulae__c;
        }
     pm.Owner_Name__c = PMlist[i].OwnerId;  
    UpdatePMlist.add(pm);
}

if(UpdatePMlist.size()>0)
{
try
{
    Update UpdatePMlist;
    }
    catch(Exception e)
    {
    system.debug('Exception...............'+e);
    }
    }
}