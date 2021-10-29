trigger preventDuplicateTool on Portal_Tools_Master__c (before insert,before update) {
Map<String,Portal_Tools_Master__c> toolMap=new Map<String,Portal_Tools_Master__c>();
Map<String,Portal_Tools_Master__c> upperCasetoolMap=new Map<String,Portal_Tools_Master__c>();
for(Portal_Tools_Master__c currentObj:Trigger.new){
    if((currentObj.name!=null)&&((Trigger.isInsert) ||(currentObj.name!=Trigger.oldMap.get(currentObj.id).name))){
        toolMap.put(currentObj.name,currentObj);
        upperCasetoolMap.put(currentObj.name.toUpperCase(),currentObj);
    }
}

for(Portal_Tools_Master__c tool:[select name from Portal_Tools_Master__c where name in : toolMap.keyset()]){
    System.debug('tool.name==== '+tool.name);
    Portal_Tools_Master__c newTool=upperCasetoolMap.get(tool.name.toUpperCase());
    System.debug('newTool==== '+newTool);
    if(newTool!=null && newTool.name!=null){
        newTool.name.addError('Tool is already exist with this name \''+tool.name+'\'');
    }
}
}