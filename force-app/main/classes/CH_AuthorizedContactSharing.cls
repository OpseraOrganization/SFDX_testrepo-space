/****************************************
 * Class Name : CH_AuthorizedContactSharing
 * Created Date: 10 Sept 2018
 * Created By : Marwan Boutaleb (mboutaleb@salesforce.com)
 * Last Modified by: 30 Oct 2018
 * Last Modified Date: 10 Sept 2018
 * Description : Grant access of authorized contacts to case records (User Story NOKIASC-345, NOKIASC-1306)
 * Test Class: CH_AuthorizedContactSharingTest
 * Last modified By - Rajeshwari : NOKIASC-31970
 *****************************************/
 
 public without sharing class CH_AuthorizedContactSharing implements Queueable {
  private static DML_SObject DML_CaseShare = new DML_SObject(CaseShare.sObjectType);
  
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
  //Below Variables are create : NOKIASC-31970
  public static set<Id> contactIds {get; set;} 
  public static set<Id> chEntitlementIds {get; set;} 
   
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
	System.enqueueJob(authSharing);
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
	if(aCase.ownerId != oldmap.get(aCase.Id).ownerId && aCase.entitlementId != null){
  newMapUpdatedEntitl.put(aCase.Id, aCase);
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
	System.enqueueJob(authSharing);
	authorizedContactSharingCalculated = true;
	  
	  }
	  
	}
  }
  
  public void execute(QueueableContext context){
	
	if(entitlementContactsToUnshare != null && !entitlementContactsToUnshare.isEmpty())
	  unshareAuthorizedContacts(entitlementContactsToUnshare);
	if(casesToUnshare != null && !casesToUnshare.isEmpty()){
	  unshareAuthorizedContacts(casesToUnshare);
	}
	if(casesToShare != null && !casesToShare.isEmpty())
	  shareAuthorizedContacts(casesToShare);
	if(entitlementContactsToShare != null && !entitlementContactsToShare.isEmpty())
	  shareAuthorizedContacts(entitlementContactsToShare);
  }
  
  public static void shareAuthorizedContacts(map<Id,EntitlementContact> entitlementContacts){
	 // Get the authorised contacts from the entitlement contacts:- Added below code NOKIASC-31970
	contactIds = new set<Id>();
	map<id, set<Id>> entContacts = getEntitlementContact(EntitlementContacts.Values());
	// Get the related cases based on the retrieved entitlement
	map<Id,Id> caseEntitIds = new map<Id,Id>();
	for(Case aCase : [SELECT Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c 
  FROM Case 
  WHERE Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c IN :entContacts.keySet()
  AND CH_RecordTypeDevName__c  IN : SHARING_ELIGIBLE_REC_TYPES]){
	  caseEntitIds.put(aCase.Id, aCase.Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c); 
	}
	if(!caseEntitIds.isEmpty()){
	  map<id, id> contactuser = new map<id, id>();
	  for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds AND IsActive=True]){
  if(usr.contactId != null) contactuser.put(usr.contactId, usr.Id);
	  }
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
	  if(!caseShares.isEmpty()){
		DML_CaseShare.doUpsert(caseShares, false, true, true);
	  }   
	}
	
  }
  
  public static void unshareAuthorizedContacts(map<Id,EntitlementContact> EntitlementContacts){
	// Get the authorised contacts from the entitlement contacts:- Added below code NOKIASC-31970
	contactIds = new set<Id>();
	map<id, set<Id>> entContacts = getEntitlementContact(EntitlementContacts.Values());
	
	map<Id,Id> caseEntitIds = new map<Id,Id>();
	for(Case aCase : [SELECT Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c FROM Case WHERE Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c IN :entContacts.keyset()]){
	  caseEntitIds.put(aCase.Id, aCase.Entitlement.ContractLineItem.ServiceContract.CH_Entitlement__c);
	}
	if(!caseEntitIds.isEmpty()){
	  map<id, id> contactuser = new map<id, id>();
	  for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds AND IsActive=True ]){
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
	  if(!dCaseShares.isEmpty()){
		DML_SObject.doDelete(dCaseShares, false, true, true);
	  }   
	}
  }
  
  public void shareAuthorizedContacts(map<Id,Case> cases){
	// Get entitement list based on the related service contract
	map<Id, Id> entitCHentit = getEntitlementFromServiceContract( cases.values());
	if(!chEntitlementIds.isEmpty()){
	  //Modified Below Mentined code : NOKIASC-31970
	  contactIds = new set<Id>();
	  List<EntitlementContact> EntitlementContactList = [SELECT contactId, EntitlementId FROM EntitlementContact WHERE EntitlementId IN :chEntitlementIds];
	  map<id, set<Id>> entContacts = getEntitlementContact(EntitlementContactList);
	  // Get user ids for the provided contacts
	  map<id, id> contactuser = new map<id, id>();
	  for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds AND IsActive=True ]){
  if(usr.contactId != null) contactuser.put(usr.contactId, usr.Id);
	  }   
	  
	  list<CaseShare> caseShares = new list<CaseShare>();
	  
	  for(Case aCase : cases.values()){
  if(aCAse.EntitlementId != null && entitCHentit.containsKey(aCAse.EntitlementId)){
	Id chEntitlementId = entitCHentit.get(aCase.EntitlementId);
	if(entContacts.containsKey(chEntitlementId)){
	  for(Id contactId : entContacts.get(chEntitlementId)){
		if(contactuser.containsKey(contactId) && aCase.ownerid !=contactuser.get(contactId)){
			caseShares.add(new CaseShare(CaseAccessLevel = READ_ACCESS_LEVEL, CaseId = aCase.Id, RowCause = MANUAL_ROW_CASE, UserOrGroupId = contactuser.get(contactId)));  
		}
	  }
	}
  }
	  }
	  if(!caseShares.isEmpty()){
		DML_CaseShare.doUpsert(caseShares, false, true, true);
	  }
	  
	}
  }
  
  public void unshareAuthorizedContacts(map<Id, Case> cases){
	// Get entitement list based on the related service contract-  //Modified Below Mentined code : NOKIASC-31970
	map<Id, Id> entitCHentit = getEntitlementFromServiceContract( cases.values());
	if(!chEntitlementIds.isEmpty()){
	  //Modified Below Mentined code : NOKIASC-31970
	  contactIds = new set<Id>();
	  List<EntitlementContact> EntitlementContactList = [SELECT contactId, EntitlementId FROM EntitlementContact WHERE EntitlementId IN :chEntitlementIds];
	  map<id, set<Id>> entContacts = getEntitlementContact(EntitlementContactList);
	  // Get user ids for the provided contacts
	  map<id, id> contactuser = new map<id, id>();
	  set<Id> userIds = new set<Id>();
	  for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds AND IsActive=True ]){
  if(usr.contactId != null) {
	contactuser.put(usr.contactId, usr.Id);
	userIds.add(usr.Id);
  }
	  }
	  
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
	  list<CaseShare> dCaseShares = new list<CaseShare>();
	  for(CaseShare cShare : [SELECT CaseId, UserOrGroupId FROM CaseShare WHERE UserOrGroupId IN :userIds AND CaseId IN :cases.keySet() AND RowCause = :MANUAL_ROW_CASE AND CaseAccessLevel = :READ_ACCESS_LEVEL]){
	if(caseUserSig.contains((string)cShare.CaseId + (string)cShare.UserOrGroupId))
	dCaseShares.add(new CaseShare(Id = cShare.Id));
	  }
	  if(!dCaseShares.isEmpty()){
		DML_SObject.doDelete(dCaseShares, false, true, true);
	  }   
	}
  }
   
	public static  map<id, set<Id>> getEntitlementContact(List<EntitlementContact> entitlementContacts){
  map<id, set<Id>> entContacts = new map<id, set<Id>>();
	 for(EntitlementContact entCtt : entitlementContacts){
  if(contactIds ==null){
   contactIds = new set<ID>();
  }
  contactIds.add(entCtt.contactId);
  if(entContacts.containsKey(entCtt.EntitlementId)){
   entContacts.get(entCtt.EntitlementId).add(entCtt.contactId);
  }else{
   entContacts.put(entCtt.EntitlementId, new set<Id>{entCtt.contactId}); 
  }
	 }
	 return entContacts;
   }
   
   public static map<Id, Id> getEntitlementFromServiceContract(List<case> casesList){
	map<Id, Id> entitCHentit = new map<Id, Id>();
	chEntitlementIds = new set<Id>();
	// Get list of case netitlements
	list<Id> entitlmentIds = new list<Id>();
	for(Case aCase : casesList){
	  if(aCAse.EntitlementId != null) entitlmentIds.add(aCAse.EntitlementId);
	}
	for(Entitlement entit : [SELECT ContractLineItem.ServiceContract.CH_Entitlement__c FROM Entitlement WHERE Id IN :entitlmentIds]){
	  if(entit.ContractLineItem.ServiceContract.CH_Entitlement__c != null){
  entitCHentit.put(entit.Id, entit.ContractLineItem.ServiceContract.CH_Entitlement__c);
  chEntitlementIds.add(entit.ContractLineItem.ServiceContract.CH_Entitlement__c); 
	  }
	}
	 return entitCHentit;
   }

}