/*
Author: NTT Data
Created Date: 2/2/2016
Test Class: ServiceRequest_Aircraft_ClsTest
Description:  To concatinate Aircraft Platforms affected and update Service Request.
*/
trigger UpdatePlatformsAff on Aircraft_Platforms_Affected__c (before update,after delete, after insert, after update) {
    List<Aircraft_Platforms_Affected__c> platformsList = new List<Aircraft_Platforms_Affected__c>();
    List<ID> SRIDlist =new List<ID>();   
    List<Service_Request__c> newSRlist = new List<Service_Request__c>();
    String platformsAff ='',trimPlatforms;
    MAP<ID,string> platformsMap = new MAP<ID,string>();
    MAP<ID,Integer> mapOfSRDSupported = new MAP<ID,Integer>();
    MAP<ID,id> SRMap = new MAP<ID,id>();
    Integer SRDCount = 0;
    Integer SRDFinalCount ;
    
  if(trigger.isAfter && (trigger.isInsert || trigger.isDelete)) 
  { 
    if(Trigger.isDelete){
        platformsList = Trigger.old;
    }
    else{
        platformsList = Trigger.new;
    }
    
    //Getting the Service Request IDs in a list
    for(integer i=0;i<platformsList.size();i++){
        if(platformsList[i].Service_Request__c!=null && !platformsMap.ContainsKey(platformsList[i].Service_Request__c)){
        platformsMap.put(platformsList[i].Service_Request__c,platformsList[i].id);
            SRIDlist.add(platformsList[i].Service_Request__c);
        }  
    }    
   
    //Querying all the Platforms related to the SR
    for(Aircraft_Platforms_Affected__c[] ptsList :[select Id, Aircraft_Platforms_Affected__r.name,Service_Request__c from Aircraft_Platforms_Affected__c where Service_Request__c in :SRIDlist and Service_Request__c!=null]){
        for(ID srl : SRIDlist){
            for(Aircraft_Platforms_Affected__c pts : ptsList){
                if(srl==pts.Service_Request__c){
                    //Constructing the string to update the Aircrafts/Platforms Affected
                    platformsAff  = platformsAff  + pts.Aircraft_Platforms_Affected__r.name + ', '; 
                }
                
            }
            platformsMap.put(srl,platformsAff);
            platformsAff = '';
          
        }
    }
    
    for(integer i=0;i<SRIDlist.size();i++){
        trimPlatforms = platformsMap.get(SRIDlist[i]);
        
        if(trimPlatforms != null && trimPlatforms.length()>0){
            //Removing the comma at the end of the string
            trimPlatforms=trimPlatforms.substring(0,trimPlatforms.length()-2); 
        }
        //Updating the fields   
        service_request__c sr = new service_request__c(id=SRIDlist[i]); 
        sr.Platforms_Affected__c = trimPlatforms;       
        newSRlist.add(sr);           
    }

    if(newSRlist.size()>0){
        try{
            update newSRlist;
        }
        catch(System.DmlException  e){
            for (Aircraft_Platforms_Affected__c a : Trigger.new) {
            a.addError(newSRlist[0].name +e +' Does not meet all validation rules, Please update the Service Request first');
            }
        }
     }
   } 
   // QFD formulate data population
   
     Boolean isRunningUser = AvoidTriggerExecution.whitelistedUsers(); // Returns FALSE if user present in Label 
    
    if((trigger.isBefore && trigger.isUpdate) || (trigger.isAfter && trigger.isInsert) && isRunningUser)
     {
       system.debug('Inside of before update');
       set<Id> platformId = new set<Id>();      
       List<Aircraft_Platforms_Affected__c> lstAirPlats = new List<Aircraft_Platforms_Affected__c>();
       List<Aircraft_Platforms_Affected__c> lstPlatsAff = new List<Aircraft_Platforms_Affected__c>();
       Map<Id,Boolean> mapSRDSupport = new Map<Id,Boolean> ();
       Map<Id,Boolean> mapPltFrmSupport = new Map<Id,Boolean> ();  
       map<Id,Id> mapIds = new Map<Id,Id>();
       for(Aircraft_Platforms_Affected__c  objAirPlat: trigger.new)
       {
         if(objAirPlat.Aircraft_Platforms_Affected__c != null  )
         {
           platformId.add(objAirPlat.Aircraft_Platforms_Affected__c);     
           system.debug('platformId====>'+platformId);      
         }
       } 
       Boolean isRecordType = false;
       for(Aircraft_Platforms_Affected__c apa : [Select Id,Aircraft_Platforms_Affected__c,Service_Request__c,Aircraft_Platforms_Affected__r.SRD_Supported__c From Aircraft_Platforms_Affected__c 
                                                                 Where Aircraft_Platforms_Affected__c IN: platformId AND Service_Request__c !=null
                                                                 AND (Service_Request__r.RecordType.Name = 'Service Request' OR  Service_Request__r.RecordType.Name = 'SR(General)')])
        {
           mapSRDSupport.put(apa.Id, apa.Aircraft_Platforms_Affected__r.SRD_Supported__c);
           isRecordType = true;
        }       
       
        if(!platformId.isEmpty() && isRecordType)
        {         
           for(Platform__c platform : [Select Id, SRD_Supported__c from Platform__c where Id IN : platformId])
           { 
               mapPltFrmSupport.put(platform.Id, platform.SRD_Supported__c );
           }
        }
               
         for(Aircraft_Platforms_Affected__c platAff : trigger.new )
         { 
           if(!mapSRDSupport.isEmpty())
           {
             if(mapSRDSupport.containsKey(platAff.Id) && trigger.isAfter && trigger.isInsert)
             {
                    Aircraft_Platforms_Affected__c apaObj = new Aircraft_Platforms_Affected__c(Id=platAff.Id);
                    apaObj.SRD_Supported__c = Boolean.ValueOf(mapSRDSupport.get(platAff.Id));
                    lstAirPlats.add(apaObj);
               
             }
             if(trigger.isBefore && trigger.isUpdate && !mapPltFrmSupport.isEmpty() && 
                mapPltFrmSupport.containsKey(platAff.Aircraft_Platforms_Affected__c))
              {   
                 platAff.SRD_Supported__c = Boolean.ValueOf(mapPltFrmSupport.get(platAff.Aircraft_Platforms_Affected__c));                 
              } 
            }         
          }  
       if(!lstAirPlats.isEmpty() && trigger.isAfter && trigger.isInsert)
         {            
             update lstAirPlats;               
         } 
     }
  }