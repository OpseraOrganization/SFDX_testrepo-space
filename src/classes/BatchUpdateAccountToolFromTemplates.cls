global class BatchUpdateAccountToolFromTemplates implements Database.Batchable<SObject>{
    global final String gStrQuery;
    global final String toolName;
    global final String authorizationMethod;
    global final String portalToolMasterId;
    global BatchUpdateAccountToolFromTemplates(String query,String pToolName,String pAuthorizationMethod,String pPortalToolMasterId){
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
        Map<String,sObject> mapAccounts=new Map<String,sObject>();
        for(sObject currentSObj:scope){
            mapAccounts.put(currentSObj.id,currentSObj);
        }
        List<sObject> accountToolsList=[select id from Account_Tools__c where Account_Name__c in :mapAccounts.keyset() and Portal_Tool_Master_Name__c=:portalToolMasterId];
        Database.delete(accountToolsList);
        for(sObject sObj:scope){
            Account_Tools__c newAccountTool=new Account_Tools__c();
            newAccountTool.name=toolName;
            newAccountTool.Account_Name__c=sObj.id;
            newAccountTool.Authorization_Method__c=authorizationMethod;
            newAccountTool.Portal_Tool_Master_Name__c=portalToolMasterId;
            lstAccountTools.add(newAccountTool);
        }
        Database.insert(lstAccountTools);
    }
    global void finish(Database.BatchableContext BC){
    }

}