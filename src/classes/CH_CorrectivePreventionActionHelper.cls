public without sharing class CH_CorrectivePreventionActionHelper {
 
/****************************************
* Class Name : CH_CorrectivePreventionActionHelper
* Method Name: assignQueueAsOwnerOnInsert
* Last Modified by: Gopi Krishna
* Last Modified Date: 24 Feb 2021
* Description : Remove SOQL statements to retrieve the Custom Metadata and add getAll for US 34697. Updated the version to 51.
*****************************************/	
	public static void assignQueueAsOwnerOnInsert(List<CH_Corrective_Preventive_Action__c> newCPAList){
		system.debug('assignQueueAsOwnerOnInsert Method starts here -->'+newCPAList);
	   
		CH_CPA_Queue__mdt mtdCPQ = new CH_CPA_Queue__mdt();
		Map<String,CH_CPA_Queue__mdt> mtdCPQMap = CH_CPA_Queue__mdt.getAll();
		if(!mtdCPQMap.isEmpty()){ 
		   for(string cpaQue : mtdCPQMap.keyset()){
				if(mtdCPQMap.get(cpaQue).QualifiedApiName == 'General')
				mtdCPQ= mtdCPQMap.get(cpaQue);
			}
		  }
		
		Group oGroup = [SELECT DeveloperName,Id,Name,Type FROM Group WHERE Type = 'Queue' AND Name = :mtdCPQ.Queue__c];
		System.debug('groupCPA-->' + oGroup);
		QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name =: mtdCPQ.Queue__c Limit 1];
		system.debug(QueueID.Queue.Name+' QueueID -->'+QueueID.Queue.Id);
		for(CH_Corrective_Preventive_Action__c objCPA : newCPAList){
			objCPA.OwnerId = QueueID.Queue.Id;
		}
		system.debug('assignQueueAsOwnerOnInsert Method ends here -->'+newCPAList);
	}
	
	public static void createSharingAccessToManagerOnInsert(List<CH_Corrective_Preventive_Action__c> newCPAList){
		system.debug('createSharingAccessToManagerOnInsert Method starts here -->'+newCPAList);
		List<CH_Corrective_Preventive_Action__Share> objCPAshareList = new List<CH_Corrective_Preventive_Action__Share>();
		
		for(CH_Corrective_Preventive_Action__c objCPA : newCPAList){
			if(objCPA.CH_CPA_Manager__c != null && objCPA.ownerId!=objCPA.CH_CPA_Manager__c){
				CH_Corrective_Preventive_Action__Share objShare = new CH_Corrective_Preventive_Action__Share();
				objShare.AccessLevel='Edit';
				objShare.ParentId = objCPA.Id;
				objShare.UserOrGroupId = objCPA.CH_CPA_Manager__c;
				objCPAshareList.add(objShare);
			}
			
		}
		if(!objCPAshareList.isempty()){
			upsert objCPAshareList;
		}
		
	}
	
	public static void createSharingAccessToManagerOnChange(List<CH_Corrective_Preventive_Action__c> newCPAList , map<id, CH_Corrective_Preventive_Action__c> oldCPAMap){
		system.debug('createSharingAccessToManager Method starts here -->'+newCPAList);
		List<CH_Corrective_Preventive_Action__Share> objCPAshareList = new List<CH_Corrective_Preventive_Action__Share>();
		map<string, String> mapCPAShareObj = new map<string, String>();
		for(CH_Corrective_Preventive_Action__c objCPA : newCPAList){
			if(objCPA.CH_CPA_Manager__c != oldCPAMap.get(objCPA.Id).CH_CPA_Manager__c || (objCPA.OwnerID != oldCPAMap.get(objCPA.Id).OwnerID) ){
				if(objCPA.CH_CPA_Manager__c != null && objCPA.CH_CPA_Manager__c !=objCPA.OwnerID ){
					CH_Corrective_Preventive_Action__Share objShare = new CH_Corrective_Preventive_Action__Share();
					objShare.AccessLevel='Edit'; 
					objShare.ParentId = objCPA.Id;
					objShare.UserOrGroupId = objCPA.CH_CPA_Manager__c;
					objCPAshareList.add(objShare);
				}
				if(oldCPAMap.get(objCPA.Id).CH_CPA_Manager__c!=null &&
				   (objCPA.OwnerID == oldCPAMap.get(objCPA.Id).OwnerID)){
					mapCPAShareObj.put(objCPA.Id, oldCPAMap.get(objCPA.Id).CH_CPA_Manager__c);
				}
			}
		}
		if(!objCPAshareList.isempty()){
			try{
				upsert objCPAshareList;
			}catch(Exception Ex){
				for(CH_Corrective_Preventive_Action__c objCPA : newCPAList){
					//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
					objCPA.addError(System.Label.CH_Select_Valid_User);
				}
			}
			
		}
		system.debug(' objCPAshareList -->'+objCPAshareList);
		if(!mapCPAShareObj.isempty()){
			removeAccessToManager(mapCPAShareObj);
		}
	}
	
	public static void removeAccessToManager(map<string, String> mapCPAShareObj){
		system.debug('removeAccessToManager Method starts here -->'+mapCPAShareObj);  
		List<CH_Corrective_Preventive_Action__Share> objCPAshareList = new List<CH_Corrective_Preventive_Action__Share>();
		for(CH_Corrective_Preventive_Action__share cpqObj : [select id, parentId, UserOrGroupId from CH_Corrective_Preventive_Action__share 
															 where parentId in :mapCPAShareObj.Keyset() and UserOrGroupId in :mapCPAShareObj.values()]){
																 objCPAshareList.add(cpqObj);	   
															 }
		delete objCPAshareList;
	}
	
	public static void assignCaseToQueueOnRejection(List<CH_Corrective_Preventive_Action__c> newCPAList , map<id, CH_Corrective_Preventive_Action__c> oldCPAMap){
		system.debug('assignCaseToQueueOnRejection Method starts here -->'+newCPAList);
		
		
		CH_CPA_Queue__mdt mtdCPQ = new CH_CPA_Queue__mdt();
		Map<String,CH_CPA_Queue__mdt> mtdCPQMap = CH_CPA_Queue__mdt.getAll();
		   if(!mtdCPQMap.isEmpty()){ 
			for(string cpaQue : mtdCPQMap.keyset()){
			mtdCPQ= mtdCPQMap.get(cpaQue);
			}
		  }
		QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name =: mtdCPQ.Queue__c Limit 1]; 
		for(CH_Corrective_Preventive_Action__c objCPA : newCPAList){
			if(objCPA.CH_CPA_Status__c == 'Rejected' && objCPA.CH_CPA_Status__c != oldCPAMap.get(objCPA.Id).CH_CPA_Status__c){
				objCPA.OwnerID = QueueID.Queue.Id; 
			   
				
			}
		}
		
		system.debug('assignCaseToQueueOnRejection Method starts here -->'+newCPAList);  
	}
	
}