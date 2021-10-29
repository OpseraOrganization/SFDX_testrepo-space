/************************************************************************************************************************
* File Name     : Test_PlannedMeetingAircraft_AvoidDuplicates
* Description   : Test Class for the trigger PlannedMeetingAircraft_AvoidDuplicates.
* Company Name  : Honeywell Aero
* Date Of Creation  : 08-Nov-2012
* Version No    :0.01
* Created By    : NTTDATA 
************************************************************************************************************************/

@isTest(SeeAllData=true)
private class Test_PlanMeetAirCraft_AvoidDup
{
    static testMethod void Test_PlanMeetAirCraft_AvoidDup()
    {  
        Planned_Meeting__c objPlanned_Meeting = new Planned_Meeting__c();
        objPlanned_Meeting.name = 'Test';
        insert objPlanned_Meeting;
        
        Platform__c objPlatform = new Platform__c();
        objPlatform.name = 'TestPlatform';
        insert objPlatform;
        
        Planned_Meeting_Aircraft__c objPlanned_Meeting_Aircraft = new Planned_Meeting_Aircraft__c();
        objPlanned_Meeting_Aircraft.Aircraft_Type__c = objPlatform.id;
        objPlanned_Meeting_Aircraft.Planned_Meeting__c = objPlanned_Meeting.id;
        insert objPlanned_Meeting_Aircraft;
    }
}