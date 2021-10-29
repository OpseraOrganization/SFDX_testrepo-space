trigger updateAllAssociatesObject on Portal_Tools_Master__c (after update){
    
        Portal_Tools_Master__c oldObj = Trigger.old[0];
        Portal_Tools_Master__c newObj = Trigger.new[0];
        
        System.debug('Tool id before update----- '+oldObj.id);
        System.debug('Tool id after update----- '+newObj.id);
        System.debug('Tool name before update ----- ' + oldObj.name); 
        System.debug('Tool name after update ----- ' + newObj.name);
        System.debug('Tool name before update $$$$$$  ' + Trigger.old[0].name);
        System.debug('Tool name after update $$$$$$  ' + Trigger.new[0].name);
        
        if(oldObj.name != newObj.name)
        {
            String ToolId=oldObj.id;
            BulkClassForCustReg bulkDelObj=new BulkClassForCustReg();
        
            bulkDelObj.updateToolNameInTempTools(ToolId,newObj.name);
            bulkDelObj.updateToolNameInAccTools(ToolId,newObj.name);
            bulkDelObj.updateToolNameInConTools(ToolId,newObj.name);
        }
        
}