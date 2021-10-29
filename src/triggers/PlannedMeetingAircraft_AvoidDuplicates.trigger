/************************************************************************************************************************
* File Name     : PlannedMeetingAircraft_AvoidDuplicates
* Description   : Trigger used to avoid duplicate entries for Planned Meeting Aircraft Types for Planned Meeting records.
* Company Name  : Honeywell Aero
* Date Of Creation  : 08-Nov-2012
* Version No    :0.01
* Created By    : NTTDATA 
************************************************************************************************************************/
trigger PlannedMeetingAircraft_AvoidDuplicates on Planned_Meeting_Aircraft__c (before insert,before update) 
{
    Map<String, Planned_Meeting_Aircraft__c> mpPlannedMeet = new Map<String,Planned_Meeting_Aircraft__c>();
    Map<String, id> mpAircraft = new Map<String,id>(); 
    String strAirCraft;

    for (Planned_Meeting_Aircraft__c objPlanAircraft : System.Trigger.New) 
    {
        //Checking for Planned_Meeting_AirCraft duplicate in the list of Contacts to be loaded
        if ((objPlanAircraft.Aircraft_Type__c !=null) && (System.Trigger.isInsert || (objPlanAircraft.Aircraft_Type__c != System.Trigger.oldMap.get(objPlanAircraft.Id).Aircraft_Type__c))) 
        {
            strAirCraft = objPlanAircraft.Aircraft_Type__c;
            if (mpPlannedMeet.containsKey(strAirCraft)) 
            {
                objPlanAircraft.Aircraft_Type__c.addError('This Aircraft type is already a Planned Meeting Aircraft Type');
            } else 
            {
                mpPlannedMeet.put(strAirCraft, objPlanAircraft);
                mpAircraft.put(strAirCraft, objPlanAircraft.Planned_Meeting__c);
            }
        }
    }
    //Checking for Planned_Meeting_AirCraft duplicates from the database
    for (Planned_Meeting_Aircraft__c objPlanAircraft : [SELECT Aircraft_Type__c,Planned_Meeting__c FROM Planned_Meeting_Aircraft__c WHERE Aircraft_Type__c IN :mpPlannedMeet.KeySet() limit 1000]) 
    {
        strAirCraft = objPlanAircraft.Aircraft_Type__c;
        if(objPlanAircraft.Planned_Meeting__c == mpAircraft.get(strAirCraft) && mpAircraft.get(strAirCraft)!=null)
        {
            Planned_Meeting_Aircraft__c objPlmA =mpPlannedMeet.get(strAirCraft);
            objPlmA.Aircraft_Type__c.addError('This Aircraft type is already a Planned Meeting Aircraft Type');
        }
    }
}