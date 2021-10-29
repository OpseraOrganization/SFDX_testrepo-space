/*
*File Name : updateAccountTools
*Description : Purpose of this trigger is updating account tools object with tools available in associated template
*Company :Honeywell
*/
trigger updateAccountTools on Account (after insert,after update){
String profid=(UserInfo.getProfileId().substring(0,15));
if(profid!=label.DeniedpartyAPIuserprofile){
List<Account_Tools__c> accTools=new List<Account_Tools__c>();
List<Account> updatesAccountsList=Trigger.new;
Set<Id> templateIds=new Set<Id>();
Set<Id> accIds=new Set<Id>();
Set<Id> accIds1=new Set<Id>();
Set<Id> tempIds1=new Set<Id>();
Map<Id,Id> mapAccTemplate=new Map<Id,Id>();
Map<Id,Id> mapAccTemplate1=new Map<Id,Id>();
Account objOldAcct;
String accId='';
//List<Account> oldAccountsList=Trigger.old;
if(updatesAccountsList!=null && updatesAccountsList.size()>0){
    /*
    for(Account acc:updatesAccountsList){
        if(acc.Customer_Status__c!='Inactive'){       
            accIds.add(acc.id);
            if(acc.ATR_Portal_Access_Template__c!=null){
                templateIds.add(acc.ATR_Portal_Access_Template__c);
                mapAccTemplate.put(acc.ATR_Portal_Access_Template__c,acc.id);
                mapAccTemplate1.put(acc.id,acc.ATR_Portal_Access_Template__c);
             }
         }
        //accId=acc.id;
    }
    */
    /*Code modified for Certido 329320 to execute trigger only when Portal Access Template is modified*/
    Id newVal, oldVal;
    if(updatesAccountsList.size()>0){
    for(Account acc:updatesAccountsList){
        if(Trigger.isUpdate){
            if(acc.ATR_Portal_Access_Template__c != NULL){
                newVal = acc.ATR_Portal_Access_Template__c;
            }
            objOldAcct = Trigger.oldMap.get(acc.Id);
            if(objOldAcct.ATR_Portal_Access_Template__c != NULL){
                oldVal = objOldAcct.ATR_Portal_Access_Template__c;
            }
            
        }
        try {
            if(Trigger.isInsert){
            if(acc.Customer_Status__c!='Inactive'){       
                accIds.add(acc.id);
                if(acc.ATR_Portal_Access_Template__c!=null){
                    templateIds.add(acc.ATR_Portal_Access_Template__c);
                    mapAccTemplate.put(acc.ATR_Portal_Access_Template__c,acc.id);
                    mapAccTemplate1.put(acc.id,acc.ATR_Portal_Access_Template__c);
                 }
             }
             }else{     
             if(acc.Customer_Status__c!='Inactive' && (newVal != oldVal)){       
                accIds.add(acc.id);
                if(acc.ATR_Portal_Access_Template__c!=null){
                    templateIds.add(acc.ATR_Portal_Access_Template__c);
                    mapAccTemplate.put(acc.ATR_Portal_Access_Template__c,acc.id);
                    mapAccTemplate1.put(acc.id,acc.ATR_Portal_Access_Template__c);
                 }
             }
             }
         }catch(Exception ex){}
    }
    }
    /////////////////////
    
    if(mapAccTemplate1!=null && mapAccTemplate1.size()>0){
        accIds1=mapAccTemplate1.keyset();
    }
    if(mapAccTemplate!=null && mapAccTemplate.size()>0){
        tempIds1=mapAccTemplate.keyset();
    }
    List<Account_Tools__c> delAccTools = new List<Account_Tools__c>();
    
    if(Trigger.isUpdate){
    if(accIds.size()>0){
        delAccTools=[select id from Account_Tools__c where Account_Name__c in :accIds];
    }
    if(delAccTools!=null && delAccTools.size()>0){
        try {
            Database.delete(delAccTools);
        }catch(Exception ex){}
    }
    }
    if(templateIds!=null && templateIds.size()>0){
        
        List<Template_Tools__c> tempTools=[select Portal_Tools_Master__c,Portal_Tools_Master__r.name,Authorization_Method__c,Portal_Access_Templates__c,Portal_Access_Templates__r.id from Template_Tools__c where Portal_Access_Templates__c in :templateIds];
        Map<Id,List<Template_Tools__c>> mapTempTools=new Map<Id,List<Template_Tools__c>>();
        for(Id ti:tempIds1){
            List<Template_Tools__c> toolsListForTemplate=new List<Template_Tools__c>();
            for(Template_Tools__c tt: tempTools){
                if(ti==tt.Portal_Access_Templates__r.id){
                    toolsListForTemplate.add(tt);
                }
            }
            mapTempTools.put(ti,toolsListForTemplate);           
        }
        for(Id i:accIds1){
            Id tempIdForAccId=mapAccTemplate1.get(i);
            List<Template_Tools__c> lstTempTools=mapTempTools.get(tempIdForAccId);
            for(Template_Tools__c tempTool:lstTempTools){
                Account_Tools__c accTool=new Account_Tools__c();
                accTool.Account_Name__c=i;
                accTool.name=tempTool.Portal_Tools_Master__r.name;
                accTool.Authorization_Method__c=tempTool.Authorization_Method__c;
                accTool.Portal_Tool_Master_Name__c=tempTool.Portal_Tools_Master__c;
                accTools.add(accTool);
            }
        }
        if(accTools!=null && accTools.size()>0){
            try {
                Database.insert(accTools);
            }catch(Exception ex){}
        }
    
    }
    //////////////////
}
}
}