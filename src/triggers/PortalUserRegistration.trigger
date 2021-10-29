/*
*File Name : PortalUserRegistration
*Description : Purpose of this trigger is updating created date and last modified date fields.
*Company :NTTDATA
*/
trigger PortalUserRegistration on Portal_User_Registration__c (before insert,before update){
    
    for(Portal_User_Registration__c portalreg :Trigger.New)
    {
        if(Trigger.isInsert)
        {
            portalreg.Created_Date__c=system.now();
        }
        if(Trigger.isUpdate)
        {
            portalreg.Last_Updated_del__c=system.now();
        }
    }
}