/***********************************************************************
* Name : HWS_ProcessCaseShareBatch
* Description : batch class to retrofit missing case Share records -  NOKIASC-37383
*Created Date : 4-Aug-2021
***********************************************************************/
global without sharing class HWS_ProcessCaseShareBatch implements Database.Batchable<sObject>, Database.Stateful{
	
	public static final string MANUAL_ROW_CAUSE = 'Manual';
	public static final string READ_ACCESS_LEVEL = 'Read';
	private String CARE_SERVICE_CONTRACT = Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get('CH_ServiceContract').getRecordTypeId();
	private static final set<string> SHARING_ELIGIBLE_REC_TYPES = new set<string>{
		'CH_NokiaStandardCase', 'CH_NokiaIncidentWithRestoration', 'CH_NokiaInformationRequest',
		'HWS_Advance_Exchange_In_Days', 'HWS_Advance_Exchange_In_Hours', 'HWS_Child_Case_Read_Only',
		'HWS_Parent_Case', 'HWS_Parent_Case_Ready_Only', 'HWS_Return_For_Repair', 'HWS_Spare_Part_Sales',
		'HWS_Spare_Part_Sales_Read_only'
	};
		
	private List<Id> serviceContractIdLst;
	private String servContractStatus;

	private static DML_SObject DML_CaseShare = new DML_SObject(CaseShare.sObjectType);
	public static Set<Id> chEntitlementIds {get; set;} 
	public static Set<Id> contactIds {get; set;} 
	/****************************************************************
	* Name : constructor
	* Description : this will initialise all the required variables
	*****************************************************************/
	global HWS_ProcessCaseShareBatch(List<Id> servContractLst,String srvConStatus){
		this.serviceContractIdLst = servContractLst;
		this.servContractStatus = srvConStatus;
	}
	/****************************************************************
	* Name : start
	* Description : this method will contain the SOQL query for the batch 
	*****************************************************************/
	global Database.QueryLocator start(Database.BatchableContext BC){
		System.debug('in start--');
		String queryString ='SELECT Id,EntitlementId,OwnerId FROM Case WHERE Entitlement.ServiceContractId IN: serviceContractIdLst AND ';
		queryString +='RecordType.DeveloperName IN: SHARING_ELIGIBLE_REC_TYPES AND ';
		queryString +='Entitlement.ServiceContract.Status =: servContractStatus  AND ';
		queryString +='Entitlement.ServiceContract.RecordTypeId =: CARE_SERVICE_CONTRACT ';
		return Database.getQueryLocator(queryString);
	}
	/****************************************************************
	* Name : execute
	* Description : Execution of the batch
	*****************************************************************/
	global void execute(Database.BatchableContext BC,List<Case> caseLst){
		System.debug('caseLst--'+caseLst.size());
		Map<Id,Case> caseMap = new Map<Id,Case>();
		for(Case cs : caseLst){
			caseMap.put(cs.Id,cs);
		}
		Map<Id, Id> entitCHentit = getEntitlementFromServiceContract( caseMap.values());
		if(!chEntitlementIds.isEmpty()){
			contactIds = new Set<Id>();
			List<EntitlementContact> entitlementContactList = [SELECT contactId, EntitlementId 
												FROM EntitlementContact WHERE EntitlementId IN :chEntitlementIds];
			Map<Id, Set<Id>> entContacts = getEntitlementContact(entitlementContactList);
			// Get user ids for the provided contacts
			Map<Id, Id> contactuser = new Map<Id, Id>();
			for(User usr :  [SELECT contactId FROM User WHERE contactId IN :contactIds AND IsActive=True ]){
			 if(usr.contactId != null) {
					contactuser.put(usr.contactId, usr.Id);
				}
			}   
			List<CaseShare> caseShares = new List<CaseShare>();
			for(Case aCase : caseMap.values()){
			 if(aCAse.EntitlementId != null && entitCHentit.containsKey(aCAse.EntitlementId)){
					Id chEntitlementId = entitCHentit.get(aCase.EntitlementId);
					if(entContacts.containsKey(chEntitlementId)){
						for(Id contactId : entContacts.get(chEntitlementId)){
							if(contactuser.containsKey(contactId) && aCase.ownerid !=contactuser.get(contactId)){
								caseShares.add(new CaseShare(CaseAccessLevel = READ_ACCESS_LEVEL, CaseId = aCase.Id, RowCause = MANUAL_ROW_CAUSE, UserOrGroupId = contactuser.get(contactId)));  
							}
						}
					}
				}
			}
			System.debug('caseShares-'+caseShares.size());
			if(!caseShares.isEmpty()){
				DML_CaseShare.doUpsert(caseShares, false, true, true);
			}
		}
	}
	/****************************************************************
	* Name : finish
	* Description : Logic to be performed when finished all processing all rows
	*****************************************************************/
	global void finish(Database.BatchableContext BC){}

	public map<Id, Id> getEntitlementFromServiceContract(List<case> casesList){
		map<Id, Id> entitCHentit = new map<Id, Id>();
		chEntitlementIds = new Set<Id>();
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
	public Map<Id, Set<Id>> getEntitlementContact(List<EntitlementContact> entitlementContacts){
		Map<Id, Set<Id>> entContacts = new Map<Id, Set<Id>>();
		for(EntitlementContact entCtt : entitlementContacts){
			if(contactIds ==null){
				contactIds = new set<Id>();
			}
			contactIds.add(entCtt.contactId);
			if(entContacts.containsKey(entCtt.EntitlementId)){
				entContacts.get(entCtt.EntitlementId).add(entCtt.contactId);
			}else{
				entContacts.put(entCtt.EntitlementId, new Set<Id>{entCtt.contactId}); 
			}
		}
		return entContacts;
	}
}