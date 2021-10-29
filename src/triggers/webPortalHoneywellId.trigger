trigger webPortalHoneywellId on Portal_Honeywell_ID__c (before insert, before update) {

   // List<portal_Honeywell_ID__c> PortalHonids = trigger.new;
   
   // List<portal_Honeywell_ID__c> existingPortalHonId = new list<portal_Honeywell_ID__c>();
   // system.debug('Trigger.newMap.keySet()*****' +Trigger.newMap.keySet());
   // existingPortalHonId =[select name, Id from portal_Honeywell_ID__c where name in :name];
    
    switch on trigger.operationType
    {
        when BEFORE_INSERT{
           // if(!existingPortalHonId.isEmpty() ){
            system.debug('before insert' );
            webPortalHoneywellIdHandler.beforeInsert(trigger.new);
                //PortalHonids[0].addError('Provided Honeywell Id is already available in the Org. Please provide different one');
           
        }
        when BEFORE_UPDATE{
           // if(!existingPortalHonId.isEmpty() && existingPortalHonId[0].Id != PortalHonids[0].Id){
                 system.debug('before update' );
                 webPortalHoneywellIdHandler.beforeUpdate(trigger.new, trigger.oldMap );
                 //PortalHonids[0].addError('Provided Honeywell Id is already available in the Org. Please provide different one');
           // }
        }
    }
}