trigger PreventDuplicates on Tool_Authorization_Methods_Master__c (before insert,before update) {
 Map<String, Tool_Authorization_Methods_Master__c> authMap =new Map<String, Tool_Authorization_Methods_Master__c>();
    for (Tool_Authorization_Methods_Master__c current: System.Trigger.new){
         
        if ((current.name!=null) && (System.Trigger.isInsert ||(current.name!= System.Trigger.oldMap.get(current.Id).name))){
        
            if (authMap.containsKey(current.name)){
                current.name.addError('Another new lead has the same email address.');
            }else{
                authMap.put(current.name, current);
            }
       }
    }
      
    for (Tool_Authorization_Methods_Master__c lead : [SELECT name FROM Tool_Authorization_Methods_Master__c WHERE name IN :authMap.KeySet()]){
        Tool_Authorization_Methods_Master__c newRec = authMap.get(lead.name);
        newRec.name.addError('\''+newRec.name+'\' already exists.');
    }


}