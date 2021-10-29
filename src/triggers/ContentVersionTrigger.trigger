/*****************************************************************
Name            :   ContentVersionTrigger
Company Name    :   NTTData
Created Date    :   27-Mar-2021
Usages          :   1. RAPD - 7779 - Calls checkifCPNispending
Test Class		:	
******************************************************************/

trigger ContentVersionTrigger on ContentVersion (After insert) {
    if(trigger.isafter && trigger.isInsert){
        ContentVersionTriggerHandler.checkifCPNispending(trigger.newMap);
    }
}