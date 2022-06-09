global class UpdatewithoutDLEBatch implements Database.Batchable<sObject>, Database.Stateful{
	
	global String Query;
	global Set<String> parentList= new Set<String>();
	global Map<string,string> customerVsLE;
	global Map<String, String> excludeParent;
	
	global UpdatewithoutDLEBatch(Set<String> accList){
		parentList = accList;
		customerVsLE = new Map<string,string>();
		excludeParent = new Map<String, String>();
	} 
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<Account> scope){
		Set<String> parentAccList = new Set<String>();
		for(Account LE : scope){
			parentAccList.add(LE.parentId);
		}
		List<Account>  les= [select Id,name,Default_Legal_Entity__c,parentId,Active__c from Account where recordType.Name = 'Legal Entity' and parentid IN: parentAccList];
		for(Account acc: les){
			if(acc.Default_Legal_Entity__c == true && acc.Active__c == true){
				excludeParent.put(acc.ParentId, acc.ParentId);
			}
		}
		List<Account> actualLEs =  new  List<Account>();
		for(Account lEntity : scope){
			// for(String excludeParentIds : excludeParent){
			if(!excludeParent.containsKey(lEntity.parentId)){
				actualLEs.add(lEntity);
				//}
			}
		}
		
		List<Account> accList = new List<Account>();
		for(Account legalEntity : actualLEs){
			if(!customerVsLE.containsKey(legalEntity.parentId) ){
				customerVsLE.put(legalEntity.parentId,legalEntity.Id);
				legalEntity.Default_Legal_Entity__c = true;
				accList.add(legalEntity);
			}
		}
		Database.update(acclist,false);  
	}
	global void finish(Database.BatchableContext BC){
	}
}