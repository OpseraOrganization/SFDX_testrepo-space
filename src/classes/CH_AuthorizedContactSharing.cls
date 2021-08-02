/****************************************
 * Class Name : CH_AuthorizedContactSharing
 * Created Date: 10 Sept 2018
 * Created By : Marwan Boutaleb (mboutaleb@salesforce.com)
 * Last Modified by: 30 Oct 2018
 * Last Modified Date: 10 Sept 2018
 * Description : Grant access of authorized contacts to case records (User Story NOKIASC-345, NOKIASC-1306)
 * Test Class: CH_AuthorizedContactSharingTest
 *****************************************/
 
 public class CH_AuthorizedContactSharing implements Queueable {
	
	public static final string MANUAL_ROW_CASE = 'Manual';
	public static final string READ_ACCESS_LEVEL = 'Read';
	public static final string CASE_TYPE_INTERNAL = 'Internal Support';
	static final set<string> SHARING_ELIGIBLE_REC_TYPES = new set<string>{'CH_NokiaStandardCase', 'CH_NokiaIncidentWithRestoration', 'CH_NokiaInformationRequest',
																		  'HWS_Advance_Exchange_In_Days', 'HWS_Advance_Exchange_In_Hours', 'HWS_Child_Case_Read_Only',
																		  'HWS_Parent_Case', 'HWS_Parent_Case_Ready_Only', 'HWS_Return_For_Repair', 'HWS_Spare_Part_Sales',
																		   'HWS_Spare_Part_Sales_Read_only'};	

	// To ensure the sharing calculations will be performed only one time per transaction
	public static boolean authorizedContactSharingCalculated = false;
	
	public map<Id, Case> casesToShare {get; set;}
	public map<Id, Case> casesToUnshare {get; set;}
	public map<Id,EntitlementContact> entitlementContactsToShare {get; set;}
	public map<Id,EntitlementContact> entitlementContactsToUnshare {get; set;}
	
	public static void handleSharing(map<Id,EntitlementContact> newmap, map<Id,EntitlementContact> oldmap, boolean isInsert, boolean isDelete){

		if(!authorizedContactSharingCalculated){
			
			CH_AuthorizedContactSharing authSharing = new CH_AuthorizedContactSharing();
			if(isInsert)
				authSharing.entitlementContactsToShare = newmap;
			if(isDelete)
				authSharing.entitlementContactsToUnshare = oldmap;
			
			if( (authSharing.entitlementContactsToShare != null && !authSharing.entitlementContactsToShare.isEmpty()) || 
				(authSharing.entitlementContactsToUnshare != null && !authSharing.entitlementContactsToUnshare.isEmpty()) ){
					
					// enqueue the job for processing
					ID jobId = System.enqueueJob(authSharing);
					system.debug('###handleSharing:JobId:' + jobId);
					authorizedContactSharingCalculated = true;  
			}
			
		}
	}
	
	public static void handleSharing(map<Id,Case> newmap, map<Id,Case> oldmap, boolean isInsert, boolean isUpdate){
		
		if(!authorizedContactSharingCalculated){
			CH_AuthorizedContactSharing authSharing = new CH_AuthorizedContactSharing();
			if(isInsert){  
				map<Id,Case> newMapUpdatedEntitl = new map<Id,Case>();
				for(Case aCase : newmap.values()){
					if(aCase.CH_ServiceType__c != CASE_TYPE_INTERNAL && aCase.entitlementId != null && SHARING_ELIGIBLE_REC_TYPES.contains(aCase.CH_RecordTypeDevName__c)) //Removed it for NOKIASC-26448 && String.isBlank(aCase.CH_LegacyCaseNumber__c))
					{
						newMapUpdatedEntitl.put(aCase.Id, aCase);
					}
				}
				authSharing.casesToShare = newMapUpdatedEntitl;
			}
			if(isUpdate){
				// Consider only cases where the entitlements have been changed
				map<Id,Case> newMapUpdatedEntitl = new map<Id,Case>();
				map<Id,Case> oldMapUpdatedEntitl = new map<Id,Case>(); 
				for(Case aCase : newmap.values()){
					if(aCase.CH_ServiceType__c != CASE_TYPE_INTERNAL && SHARING_ELIGIBLE_REC_TYPES.contains(aCase.CH_RecordTypeDevName__c)){
						if(aCase.ownerId != oldmap.get(aCase.Id).ownerId){
							if(aCase.entitlementId != null) newMapUpdatedEntitl.put(aCase.Id, aCase);
						}
						if(aCase.entitlementId != oldmap.get(aCase.Id).entitlementId){
							if(aCase.entitlementId != null) newMapUpdatedEntitl.put(aCase.Id, aCase);
							if(oldmap.get(aCase.Id).entitlementId != null) oldMapUpdatedEntitl.put(aCase.Id, oldmap.get(aCase.Id));
					}   
					}
					
				}
				authSharing.casesToShare = newMapUpdatedEntitl;
				authSharing.casesToUnshare = oldMapUpdatedEntitl;
			}
			
			if( (authSharing.casesToShare != null && !authSharing.casesToShare.isEmpty()) ||
				(authSharing.casesToUnshare != null && !authSharing.casesToUnshare.isEmpty())){
					
					// enqueue the job for processing
					ID jobId = System.enqueueJob(authSharing);
					system.debug('###handleSharing:JobId:' + jobId);
					authorizedContactSharingCalculated = true;
						
			}
			
		}
	}
	
	public void execute(QueueableContext context){
		
		if(casesToShare != null && !casesToShare.isEmpty())
			shareAuthorizedContacts(casesToShare);
		if(entitlementContactsToShare != null && !entitlementContactsToShare.isEmpty())
			shareAuthorizedContacts(entitlementContactsToShare);
		if(entitlementContactsToUnshare != null && !entitlementContactsToUnshare.isEmpty())
			unshareAuthorizedContacts(entitlementContactsToUnshare);
		if(casesToUnshare != null && !casesToUnshare.isEmpty()){
			unshareAuthorizedContacts(casesToUnshare);
		}
		
	}
	
	public static void shareAuthorizedContacts(map<Id,EntitlementContact> entitlementContacts){
		
		system.debug('###shareAuthorizedContacts:entitlementContacts:' + entitlementContacts.size());
		// Get for each entitlement a list of related contacts
		map<id, set<Id>> entContacts = new map<id, set<Id>>();
		set<Id> contactIds = new set<Id>(); 
		for(EntitlementContact entCtt : entitlementContacts.values()){
			contactIds.add(entCtt.contactId);
			if(entContacts.containsKey(entCtt.EntitlementId)){
				entContacts.get(entCtt.EntitlementId).add(entCtt.contactId);
			}else{
				entContacts.put(entCtt.EntitlementId, new set<Id>{entCtt.contactId}); 
			}
		}
		system.debug('###shareAuthorizedContacts:contactIds:' + contactIds.size());
		
		// Get the related cases based on the retrieved entitlement
		map<Id,Id> caseEntitIds = new map<Id,Id>();
		for(Case aCase : [SELECT Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c 
				FROM Case 
				WHERE Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c IN :entContacts.keySet()
				AND CH_RecordTypeDevName__c  IN : SHARING_ELIGIBLE_REC_TYPES]){
			caseEntitIds.put(aCase.Id, aCase.Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c); 
		}
		system.debug('###shareAuthorizedContacts:caseEntitIds:' + caseEntitIds.size());
		
		if(!caseEntitIds.isEmpty()){
			// Get user ids for the provided contacts
			map<id, id> contactuser = new map<id, id>();
			for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds]){
				if(usr.contactId != null) contactuser.put(usr.contactId, usr.Id);
			}
			system.debug('###shareAuthorizedContacts:contactuser:' + contactuser.size());
			
			// Create share records
			list<CaseShare> caseShares = new list<CaseShare>();
			for(Id caseId : caseEntitIds.keySet()){
				Id entitlmentId = caseEntitIds.get(caseId);
				if(entContacts.containsKey(entitlmentId)){
					for(Id contactId : entContacts.get(entitlmentId)){
						if(contactuser.containsKey(contactId)){
							caseShares.add(new CaseShare(CaseAccessLevel = READ_ACCESS_LEVEL, CaseId = caseId, RowCause = MANUAL_ROW_CASE, UserOrGroupId = contactuser.get(contactId)));	
						}		   
					}   
				}
				
			}
			
			system.debug('###shareAuthorizedContacts:CaseShares:' + caseShares.size());
			if(!caseShares.isEmpty()){
				insert caseShares;
			}   
		}
		
	}
	
	public static void unshareAuthorizedContacts(map<Id,EntitlementContact> EntitlementContacts){
		
		system.debug('###unshareAuthorizedContacts:entitlementContacts:' + entitlementContacts.size());
		
		// Get the authorised contacts from the entitlement contacts:
		map<id, set<Id>> entContacts = new map<id, set<Id>>();
		set<Id> contactIds = new set<Id>(); 
		for(EntitlementContact entCtt : entitlementContacts.values()){
			contactIds.add(entCtt.contactId);
			if(entContacts.containsKey(entCtt.EntitlementId)){
				entContacts.get(entCtt.EntitlementId).add(entCtt.contactId);
			}else{
				entContacts.put(entCtt.EntitlementId, new set<Id>{entCtt.contactId}); 
			}
		}
		
		// Get the authorised contacts from the entitlement contacts:
		map<Id,Id> caseEntitIds = new map<Id,Id>();
		for(Case aCase : [SELECT Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c FROM Case WHERE Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c IN :entContacts.keyset()]){
			caseEntitIds.put(aCase.Id, aCase.Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c);
		}
		 
		system.debug('###unshareAuthorizedContacts:caseEntitIds:' + caseEntitIds.size());
		if(!caseEntitIds.isEmpty()){
			// Get user ids for the provided contacts
			map<id, id> contactuser = new map<id, id>();
			for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds]){
				if(usr.contactId != null) contactuser.put(usr.contactId, usr.Id);
			}
			
			set<string> caseUserSig = new set<string>();
			set<Id> userIds = new set<Id>();
			for(Id caseId : caseEntitIds.keySet()){
				Id entitlmentId = caseEntitIds.get(caseId);
				if(entContacts.containsKey(entitlmentId)){
					for(Id contactId : entContacts.get(entitlmentId)){
						if(contactuser.containsKey(contactId)){
							userIds.add(contactuser.get(contactId));
							caseUserSig.add((string)caseId + (string)contactuser.get(contactId));   
						}
						
					}   
				}
			}
			
			list<CaseShare> dCaseShares = new list<CaseShare>();
			for(CaseShare cShare : [SELECT CaseId, UserOrGroupId FROM CaseShare WHERE UserOrGroupId IN :userIds AND CaseId IN :caseEntitIds.keySet() AND RowCause = :MANUAL_ROW_CASE AND CaseAccessLevel = :READ_ACCESS_LEVEL]){
				if(caseUserSig.contains((string)cShare.CaseId + (string)cShare.UserOrGroupId))
					dCaseShares.add(new CaseShare(Id = cShare.Id));
			}
			
			system.debug('###unshareAuthorizedContacts:dCaseShares:' + dCaseShares.size());
			if(!dCaseShares.isEmpty()){
				delete dCaseShares;
			}   
		}
	}
	
	public void shareAuthorizedContacts(map<Id,Case> cases){
		
		system.debug('###shareAuthorizedContacts:cases:' + cases.size());
		
		// Get list of case netitlements
		list<Id> entitlmentIds = new list<Id>();
		for(Case aCase : cases.values()){
			if(aCAse.EntitlementId != null) entitlmentIds.add(aCAse.EntitlementId);
		}
		system.debug('###shareAuthorizedContacts:EntitlementId:' + entitlmentIds.size());
		
		// Get entitement list based on the related service contract
		map<Id, Id> entitCHentit = new map<Id, Id>();
		set<Id> chEntitlementIds = new set<Id>();
		for(Entitlement entit : [SELECT ContractLineItem.ServiceContract.CH_Entitlement__c FROM Entitlement WHERE Id IN :entitlmentIds]){
			if(entit.ContractLineItem.ServiceContract.CH_Entitlement__c != null){
				entitCHentit.put(entit.Id, entit.ContractLineItem.ServiceContract.CH_Entitlement__c);
				chEntitlementIds.add(entit.ContractLineItem.ServiceContract.CH_Entitlement__c); 
			}
		}
		system.debug('###shareAuthorizedContacts:entitCHentit:' + entitCHentit.size());
		
		// Get entitlement contacts
		if(!chEntitlementIds.isEmpty()){
			map<id, set<Id>> entContacts = new map<id, set<Id>>();
			set<Id> contactIds = new set<Id>(); 
			for(EntitlementContact entCtt : [SELECT contactId, EntitlementId FROM EntitlementContact WHERE EntitlementId IN :chEntitlementIds]){
				contactIds.add(entCtt.contactId);
				if(entContacts.containsKey(entCtt.EntitlementId)){
					entContacts.get(entCtt.EntitlementId).add(entCtt.contactId);
				}else{
					entContacts.put(entCtt.EntitlementId, new set<Id>{entCtt.contactId}); 
				}
			}
			system.debug('###shareAuthorizedContacts:contactIds:' + contactIds.size());
			
			// Get user ids for the provided contacts
			map<id, id> contactuser = new map<id, id>();
			for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds]){
				if(usr.contactId != null) contactuser.put(usr.contactId, usr.Id);
			}   
			
			// Create share records
			list<CaseShare> caseShares = new list<CaseShare>();
			
			for(Case aCase : cases.values()){
				if(aCAse.EntitlementId != null && entitCHentit.containsKey(aCAse.EntitlementId)){
					Id chEntitlementId = entitCHentit.get(aCase.EntitlementId);
					if(entContacts.containsKey(chEntitlementId)){
						for(Id contactId : entContacts.get(chEntitlementId)){
							if(contactuser.containsKey(contactId)){
								caseShares.add(new CaseShare(CaseAccessLevel = READ_ACCESS_LEVEL, CaseId = aCase.Id, RowCause = MANUAL_ROW_CASE, UserOrGroupId = contactuser.get(contactId)));  
							}
						}
					}
				}
			}
			
			system.debug('###shareAuthorizedContacts:CaseShares:' + caseShares);
			if(!caseShares.isEmpty()){
				insert caseShares;
			}
			
		}
	}
	
	public void unshareAuthorizedContacts(map<Id, Case> cases){
		
		system.debug('###unshareAuthorizedContacts:cases:' + cases.size());
		
		// Get list of case netitlements
		list<Id> entitlmentIds = new list<Id>();
		for(Case aCase : cases.values()){
			if(aCAse.EntitlementId != null) entitlmentIds.add(aCAse.EntitlementId);
		}
		system.debug('###unshareAuthorizedContacts:EntitlementId:' + entitlmentIds.size());
		
		// Get entitement list based on the related service contract
		map<Id, Id> entitCHentit = new map<Id, Id>();
		set<Id> chEntitlementIds = new set<Id>();
		for(Entitlement entit : [SELECT ContractLineItem.ServiceContract.CH_Entitlement__c FROM Entitlement WHERE Id IN :entitlmentIds]){
			if(entit.ContractLineItem.ServiceContract.CH_Entitlement__c != null){
				entitCHentit.put(entit.Id, entit.ContractLineItem.ServiceContract.CH_Entitlement__c);
				chEntitlementIds.add(entit.ContractLineItem.ServiceContract.CH_Entitlement__c); 
			}
		}
		
		if(!chEntitlementIds.isEmpty()){
			map<id, set<Id>> entContacts = new map<id, set<Id>>();
			set<Id> contactIds = new set<Id>(); 
			for(EntitlementContact entCtt : [SELECT contactId, EntitlementId FROM EntitlementContact WHERE EntitlementId IN :chEntitlementIds]){
				contactIds.add(entCtt.contactId);
				if(entContacts.containsKey(entCtt.EntitlementId)){
					entContacts.get(entCtt.EntitlementId).add(entCtt.contactId);
				}else{
					entContacts.put(entCtt.EntitlementId, new set<Id>{entCtt.contactId}); 
				}
			}
			system.debug('###unshareAuthorizedContacts:contactIds:' + contactIds.size());
			
			// Get user ids for the provided contacts
			map<id, id> contactuser = new map<id, id>();
			set<Id> userIds = new set<Id>();
			for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds]){
				if(usr.contactId != null) {
					contactuser.put(usr.contactId, usr.Id);
					userIds.add(usr.Id);
				}
			}
			system.debug('###unshareAuthorizedContacts:contactuser:' + contactuser.size());
			
			
			set<string> caseUserSig = new set<string>();
			for(Case aCase: cases.values()){
				if(aCase.entitlementId != null && entitCHentit.containsKey(aCase.entitlementId)){
					Id chEntitl = entitCHentit.get(aCase.entitlementId);
					if(entContacts.containsKey(chEntitl)){
						for(Id contactId : entContacts.get(chEntitl)){
							if(contactuser.containskey(contactId)){
								caseUserSig.add((string)aCase.Id + (string)contactuser.get(contactId)); 
							}
							
						}
					}   
				}
			}
			system.debug('###unshareAuthorizedContacts:caseUserSig:' + caseUserSig);
			
			list<CaseShare> dCaseShares = new list<CaseShare>();
			for(CaseShare cShare : [SELECT CaseId, UserOrGroupId FROM CaseShare WHERE UserOrGroupId IN :userIds AND CaseId IN :cases.keySet() AND RowCause = :MANUAL_ROW_CASE AND CaseAccessLevel = :READ_ACCESS_LEVEL]){
				system.debug('>' + (string)cShare.CaseId + (string)cShare.UserOrGroupId);
				if(caseUserSig.contains((string)cShare.CaseId + (string)cShare.UserOrGroupId))
					dCaseShares.add(new CaseShare(Id = cShare.Id));
			}
			
			system.debug('###unshareAuthorizedContacts:dCaseShares:' + dCaseShares.size());
			if(!dCaseShares.isEmpty()){
				delete dCaseShares;
			}   
		}
		
		
		
		
	}

}