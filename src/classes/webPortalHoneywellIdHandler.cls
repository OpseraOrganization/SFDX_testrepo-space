Public class webPortalHoneywellIdHandler{
    
    
    Public static void beforeInsert(List<portal_Honeywell_ID__c> PortalHonids){
        List<portal_Honeywell_ID__c> existingPortalHonId = new list<portal_Honeywell_ID__c>();
        List<string> existingName = new list<string>();
        List<string> name = new List<string>();
        for(portal_Honeywell_ID__c por: PortalHonids){
            name.add(por.name);
            system.debug('name*****' +name);
        }    
        existingPortalHonId =[select name, Id from portal_Honeywell_ID__c where name in :name];    
        for(portal_Honeywell_ID__c porName: existingPortalHonId ){
            existingName.add(porName.name);
        }
        for(portal_Honeywell_ID__c  por:PortalHonids){
            if(existingName.contains(por.name)){
                por.addError('Provided Honeywell Id is already available in the Org. Please provide different one');
            }
        }    
    }
     
    Public static void beforeUpdate(List<portal_Honeywell_ID__c> PortalHonids, Map<Id,portal_Honeywell_ID__c> OldPortalHonidsMap){
        List<string> name = new List<string>();
        List<portal_Honeywell_ID__c> existingPortalHonId = new list<portal_Honeywell_ID__c>();
        List<string> existingName = new list<string>();
        Map<Id, String> newNameMap = new Map<Id, String>();
        Map<Id, String> oldNameMap = new Map<Id, String>();
            
        for(portal_Honeywell_ID__c por: PortalHonids){
            name.add(por.name);
            newNameMap.put(por.id, por.name);
            system.debug('name*****' +name);
        }    
           
        existingPortalHonId =[select name, Id from portal_Honeywell_ID__c where name in :name]; 
        system.debug('existingPortalHonId *****' +existingPortalHonId );
        for(portal_Honeywell_ID__c porName: existingPortalHonId ){
            oldNameMap.put(porName.id, porName.name);
            existingName.add(porName.name);
        }
        for(portal_Honeywell_ID__c por: PortalHonids){
        system.debug('por*****' +por);
            if(newNameMap.get(por.id) != OldPortalHonidsMap.get(por.id).name && existingName.contains(por.name)){
                por.addError('Provided Honeywell Id is already available in the Org. Please provide different one');
            }
        }
           
    }
}