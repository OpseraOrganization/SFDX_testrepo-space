/** * File Name: PlannedMeeting_UpdateTimezone
* Description: Trigger update the time zone value from the event associated to the Planned Meeting.It also updates the owner custom field when the Planned Meeting owner changes
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
* 18/8/2010 - Modified code to update the owner field
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger PlannedMeeting_UpdateTimezone on Planned_Meeting__c (before insert,before update) {

List<Planned_Meeting__c> pmlst = Trigger.new;

if(Trigger.IsInsert)
{

//Time_Zone_Formulae__c is formula field which holds the value of time zone of the event
for(integer i=0;i<pmlst.size();i++)
{
if (pmlst[i].Time_Zone__c==null && pmlst[i].Event__c!=null )

    {
         pmlst[i].Time_Zone__c =pmlst[i].Time_Zone_Formulae__c;
    }

}
}
if(Trigger.IsUpdate)
{
//Updating Timezone and owner fields for update triggers
for(integer i=0;i<pmlst.size();i++)
{
if (Trigger.old[i].Event__c != pmlst[i].Event__c)

    {
        pmlst[i].Time_Zone__c =pmlst[i].Time_Zone_Formulae__c;
      
    }
if (Trigger.old[i].ownerid != pmlst[i].ownerId)

    {
        pmlst[i].owner_name__c =pmlst[i].ownerId;
      
    }
}
}
}