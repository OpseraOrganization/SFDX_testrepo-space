/** * File Name: Userstatus  Update
* Description :Trigger is used to send userstatus updates to SAP .
* Copyright : NTTDATA Copyright (c) 2016 *
* @author : NTTDATA
 ==================================================================================*/
trigger UserstatusUpdate  on Activitiy_Line_Item__c (after update) 
{
    if (Trigger.Isupdate)
    {
        Boolean taskupdate = false;            
        set<id> Userstatusid=new set<id>();
        List<id> NewUserstatus = new List<id>();       
        for (Activitiy_Line_Item__c  Userstatus : Trigger.new) 
        {           
            if((Userstatus.lastmodifiedbyid != label.DeniedPartyScreening_APIUser_ID  
            && ((Trigger.newMap.get(Userstatus.id).Status__c != Trigger.oldMap.get(Userstatus.id).Status__c))
            && ((Trigger.newMap.get(Userstatus.id).Status__c == 'Closed')))
            && (Trigger.newMap.get(Userstatus.id).Task_Status_Close__c == false)
            )           
            {                 
                system.debug('inside update');
                system.debug('inside update>>>>>'+Userstatus.id);
                NewUserstatus.add(Userstatus.id);
                system.debug('inside NewUserstatus>>>>>'+NewUserstatus);
                SI_UserstatusStatustoSAP1.SendTaskStatus(NewUserstatus);               
                taskupdate = true;
                system.debug('inside taskupdate>>>>>'+taskupdate);
            }           
        }       
    }
}