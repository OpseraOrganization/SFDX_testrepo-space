global class BatchUpdateAccntTlFrmTemToolEdit implements Database.Batchable<SObject>{
    global final String gStrQuery;
    global final String toolName;
    global final String authorizationMethod;
    global final String portalToolMasterId;
    global BatchUpdateAccntTlFrmTemToolEdit(String query,String pToolName,String pAuthorizationMethod,String pPortalToolMasterId){
        gStrQuery=query;
        toolName=pToolName;
        authorizationMethod=pAuthorizationMethod;
        portalToolMasterId=pPortalToolMasterId;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('gStrQuery====   '+gStrQuery);
        return Database.getQueryLocator(gStrQuery);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Account_Tools__c> lstAccountTools=new List<Account_Tools__c>();
        Map<String,String> mapAccIds=new Map<String,String>();
        for(sObject sObj:scope){
            mapAccIds.put(sObj.id,sObj.id);
        }
        System.debug('mapAccIds.keyset() ====== '+mapAccIds.keyset());
        System.debug('toolName ====== '+toolName);
        List<Account_Tools__c> updatedAccTools=[select id,Authorization_Method__c,Portal_Tool_Master_Name__c from Account_Tools__c where Account_Name__c in :mapAccIds.keyset() and Portal_Tool_Master_Name__c=: portalToolMasterId];
        for(Account_Tools__c accTool:updatedAccTools){
              accTool.Authorization_Method__c=authorizationMethod;
              lstAccountTools.add(accTool);      
        }
        if(lstAccountTools!=null && lstAccountTools.size()>0){
            Database.update(lstAccountTools);
        }
        
    }
    global void finish(Database.BatchableContext BC){
    }

}