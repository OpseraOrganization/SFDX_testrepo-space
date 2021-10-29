/*******************************************************************************
Name         : updatefleetparentplatform 
Company Name : NTT Data
Project      : SR INC000009288177
Created Date : 28 October 2015

************Added for SR INC000009288177 to update platform name in fleet asset*********************/
trigger updatefleetparentplatform on Platform__c(after insert, after update) {

   if(Trigger.isupdate && Trigger.isAfter)
   { 
       List < Fleet_Asset_Detail__c > fleetup = new List < Fleet_Asset_Detail__c > ();
       Boolean isFleetAsst = false;
       Boolean isUpdate = false;
        Map < id, Platform__c > platmap = new Map < id, Platform__c > ();
        for (Platform__c plat: Trigger.new) {
            if (Trigger.isupdate && (Trigger.OldMap.get(plat.id).Parent_Platform__c != Trigger.NewMap.get(plat.id).Parent_Platform__c)) {
                platmap.put(plat.id, plat);
            }
        }
        if (platmap.size() > 0)
            fleetup = [select id, Platform_name__c, Platform_Parent_Name__c from Fleet_Asset_Detail__c where Platform_name__c in: platmap.keyset()];
    
        for (Fleet_Asset_Detail__c flee : fleetup) {
            if (platmap.get(flee.Platform_name__c).Parent_Platform__c != null)
                flee.Platform_Parent_Name__c = platmap.get(flee.Platform_name__c).Parent_Platform__c;
            else
                flee.Platform_Parent_Name__c = platmap.get(flee.Platform_name__c).id;
        }
        update fleetup;
   } 
    
/*************Added for SR INC000009288177 to update platform name in fleet asses ends*********************/

/*** SRD Support count ***/
   Boolean isRunningUser = AvoidTriggerExecution.whitelistedUsers(); // Returns FALSE if user present in Label
    
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate ) && isRunningUser)
    {
     
      set<Id> platfromId = new set<Id>();
      Boolean isCheck = false;
      Boolean isPlatform = false;
      List<Aircraft_Platforms_Affected__c> lstAirPlat = new List<Aircraft_Platforms_Affected__c>(); 
      
      for(Platform__c objPlatform : trigger.new)
      {
         platfromId.add(objPlatform.Id);         
      }
      system.debug('PlatformId::::'+platfromId);
      
      List<Aircraft_Platforms_Affected__c> airPlatList = [Select Id,Aircraft_Platforms_Affected__c,Service_Request__c,Aircraft_Platforms_Affected__r.SRD_Supported__c From Aircraft_Platforms_Affected__c 
                                                          Where Aircraft_Platforms_Affected__c IN: platfromId AND Service_Request__c != null AND
                                                          (Service_Request__r.RecordType.Name = 'Service Request' OR  Service_Request__r.RecordType.Name = 'SR(General)')];
           if(airPlatList.size()>0) 
           {                       
             for(Aircraft_Platforms_Affected__c objAirPlat : airPlatList)
             {
                 objAirPlat.SRD_Supported__c = objAirPlat.Aircraft_Platforms_Affected__r.SRD_Supported__c ; 
                 lstAirPlat.add(objAirPlat);
             }                      
           }                         
           if(!lstAirPlat.isEmpty())
           {      
               update lstAirPlat;
           }            
     }   
}