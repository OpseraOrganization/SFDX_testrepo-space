trigger deleteTool on Portal_Tools_Master__c (after delete){
List<Portal_Tools_Master__c> deletedItems =Trigger.old;
System.debug('deletedItems ==========  '+deletedItems);
//Map<String,Portal_Tools_Master__c> mapTools=new Map<String,Portal_Tools_Master__c>();
List<String> mapTools=new List<String>();
String strVal='';
for(Portal_Tools_Master__c currentObj:deletedItems){
    strVal='\''+currentObj.name+'\'';
    mapTools.add(strVal);
}
BulkClassForCustReg bulkDelObj=new BulkClassForCustReg();
bulkDelObj.deleteToolFromTemplate(mapTools);
bulkDelObj.deleteToolFromAccount(mapTools);
bulkDelObj.deleteToolFromContact(mapTools);

//delete templates;
}