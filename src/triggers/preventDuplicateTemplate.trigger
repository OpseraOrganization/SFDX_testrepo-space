trigger preventDuplicateTemplate on Portal_Access_Template__c (before insert,before update) {
Map<String,Portal_Access_Template__c> templateMap=new Map<String,Portal_Access_Template__c>();
Map<String,Portal_Access_Template__c> upperCasetemplateMap=new Map<String,Portal_Access_Template__c>();
for(Portal_Access_Template__c currentObj:Trigger.new){
    if((currentObj.name!=null)&&((Trigger.isInsert) ||(currentObj.name!=Trigger.oldMap.get(currentObj.id).name))){
        templateMap.put(currentObj.name,currentObj);
        upperCasetemplateMap.put(currentObj.name.toUpperCase(),currentObj);
    }
}

for(Portal_Access_Template__c template:[select name from Portal_Access_Template__c where name in : templateMap.keyset()]){
    System.debug('tool.name==== '+template.name);
    Portal_Access_Template__c newTemplate=upperCasetemplateMap.get(template.name.toUpperCase());
    System.debug('newTemplate==== '+newTemplate);
    if(newTemplate!=null && newTemplate.name!=null){
        newTemplate.name.addError('Template is already exist with this name \''+template.name+'\'');
    }
}
}