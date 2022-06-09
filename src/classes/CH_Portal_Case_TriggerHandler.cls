public without sharing class CH_Portal_Case_TriggerHandler {
	
	private static final string GWC_QUEUE = 'GWC';
	private static final string COMMUNITY_USERTYPE = 'PowerCustomerSuccess';
	private static final string PARTNER_USERTYPE = 'PowerPartner';	
	
	/***************************************************************** 
	Description:  
	Get the case record for the case id

	Parameters: Id of the case 
	Returns: Case object
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	28/05/2019	 Umesh Shinde	Changes made for US#17226
	*****************************************************************/	
	public static void assignOwner(Set<Id> caseLst) { 
	 List<Case>   caseList = [SELECT Id, CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c, CH_ServiceType__c, origin,CreatedById,
								 RecordTypeId, RecordType.developername, Status, Severity__c, Account.Region__c, Account.Country__c,CH_Reassignment__c,
								 AccountId, ProductId, CH_Outage__c, NCP_Service_Contract__r.Name, BusinessHoursId, CH_SystemRestored__c,
								 CH_CaseMilestoneTargetDate__c, CH_MilestoneSLA_Start__c, AssetId,CH_ProductVariant__c, CH_Solution__c,
								 CH_Workgroup__r.CH_Type__c, Country__c,EntitlementId, CH_Product_Module__c, ParentId,
								 CH_GWC_SecurityGroup__c, CH_SecurityGroup__c,CH_Rep_CDBContractType__c,OwnerId,CH_3rdPartySecurityGroup__c,
								 Entitlement.ServiceContractId, CH_Originating_Incident_Number__r.Country__c, CH_Originating_Incident_Number__r.AccountId,
								 CH_Originating_Incident_Number__r.CH_Rep_CDBContractType__c
								 FROM Case  
								 WHERE Id IN :caseLst];
		string standardCaseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
	//Get Nokia Incident with Restoration record type for US-29467
		string incientWithRestorationRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaIncidentWithRestoration').getRecordTypeId(); 	
	//Adding Nodia Information Request record type for US-30114 
		string informationRequestRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaInformationRequest').getRecordTypeId(); 
		CH_Workgroup_Member__c foundQueue = new CH_Workgroup_Member__c();
		string entitlementException;
		// Loop through all case
		for (Case newCase : caseList) {	 
			// Update only process portal cases
	 if ((newCase.RecordTypeId == standardCaseRecordTypeId || newCase.RecordTypeId == incientWithRestorationRecordTypeId || newCase.RecordTypeId == informationRequestRecordTypeId) && (isCaseCreatedByPortalUser(newCase) || isCaseCreatedByNAIPUser(newCase) || newCase.Origin == 'S2S')) {
	 // Check if entitlment has an entitlment script
	 if (hasEntitlementScript(newCase)){
		//Set entitlementException -> Changes for US 17726 starts
		entitlementException = 'Entitlement Script Verification Required';
	  // Get GWC queue
		foundQueue.CH_User__c = getGWCQueue();
		foundQueue.Name = 'GWC';
	foundQueue.CH_Workgroup__c = null;
		foundQueue.CH_Queue_Email__c = null;
		foundQueue.CH_Workgroup_Member_Type__c = 'Queue';

	 }
	else {
		//Set entitlementException -> Changes for US 17726 starts
		entitlementException = 'No Exception';
		// Get workgroup queue
		foundQueue = getQueue(newCase);
		
	}
	// Assign case to GWC queue
	CH_CA_Service service = new CH_CA_Service();
			Map<id,CH_Workgroup_Member__c> assignment = new Map<id,CH_Workgroup_Member__c>{newCase.Id => foundQueue};
	service.assignUser(assignment);
	// Set the entitlement exception
	//update newCase;
			}		 
		}
	}

	/*****************************************************************
	Description:  
	Check if the creator of the case has the profile of a community user

	Parameters: a case 
	Returns: true = creater has a community profile
	false = creator does not have a community profile
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	@TestVisible private static boolean isCaseCreatedByPortalUser(Case newCase) {
		//Using userInfo t get User Type as part of Code Optimization -- 27619 --> Satya Pagadala   
	Boolean isPortalUser;
		if(userInfo.getUserType() == COMMUNITY_USERTYPE || userInfo.getUserType() == PARTNER_USERTYPE){
			isPortalUser=True;
		}
		else{
			isPortalUser=false;
		}
			return isPortalUser;
	}

	/*****************************************************************
	Description:  
	Check if the creator of the case is NAIP User

	Parameters: a case
	Returns: true = creater is NAIP User
	false = creator is not NAIP User
	Throws [Exceptions]: [optional]
	
	History
	DATE	 AUTHOR	 Change
	22/05/2019	 TCS		Created
	*****************************************************************/
   @TestVisible private static boolean isCaseCreatedByNAIPUser(Case newCase) {
		boolean isNaipUser=false;
	//User naipUser = [SELECT ID, Username FROM User WHERE Username LIKE 'NAIP.USER%' AND Name = 'NAIP User' LIMIT 1];
		//To fix 101 soql issue, using custom label to get naip user Id instead of querying it
		//By Satya on 20th Feb 2020
		String naipUserId = System.Label.CH_NaipUserId;
		if(newCase.CreatedById == naipUserId && newCase.Origin == 'S2S')
			isNaipUser=true;
		return isNaipUser;   
	}
	
	/*****************************************************************
	Description:  
	Check if entilement assigned to the case has an entitlement script. 
	First check if the entitlement script is on the contract line item. 
	If not cechk if there's a entitlement script on the service contract header.

	Parameters: a case 
	Returns: true = The entitlement on the case has an entitlement script 
	false = The entitlement on the case has no entitlement script
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	@TestVisible private static boolean hasEntitlementScript(Case newCase) {
		boolean hasEntitlementScript = false;
		//Condition added for 28466
		Id serviceContractId;
		if(newCase.EntitlementId != null){
			Entitlement[] entitlementOnCase = [Select Id,Name,ServiceContractId FROM Entitlement where Id=:newCase.EntitlementId];   
			if(entitlementOnCase.size()>0 && entitlementOnCase[0].ServiceContractId!= null){
	serviceContractId=entitlementOnCase[0].ServiceContractId;
			}
		} 
		// Check if there is an entitlement script on the contract line item
		List<ContractLineitem> contractLineItems = [SELECT Id, CH_LineItemEntitlementScript__c, ServiceContractId, ServiceContract.CH_EntitlementScript__c
				FROM ContractLineitem 
				WHERE AssetId = :newCase.AssetId AND ServiceContractId=:serviceContractId LIMIT 1];

		// IF no contract line items found then assign to GWC
		if (contractLineItems.size() == 0) {
			hasEntitlementScript = true; 
		}
		else {
			// If the contract lineitem or header has an entitlement script assign to GWC
			If (!String.isBlank(contractLineItems[0].CH_LineItemEntitlementScript__c)){
	hasEntitlementScript = true; 
			}
			else {
	//Removed below query and Merged it in above query as part of code optimization --> 27620 -- By Satya
	// Check if there is an entitlement script on the service contract header	
	If (!String.isBlank(contractLineItems[0].ServiceContract.CH_EntitlementScript__c)){
		hasEntitlementScript = true;
	} 
			}
		}
		return hasEntitlementScript; 
	} 

	/*****************************************************************
	Description:  
	Get the Id of the GWC queue that is used for default assignment

	Parameters: NA 
	Returns: Id of the GWC queue
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	Public static Id getGWCQueue() {
		Group gwcQueue = [select Id from Group where  Type = 'Queue' AND NAME = :GWC_QUEUE LIMIT 1];
		return gwcQueue.Id;
	}

	/*****************************************************************
	Description:  
	Get the Id of the queue that is a workgroup member of the workgroup. 
	The workgroup is determined based on the workgroup rules.

	Parameters: a case 
	Returns: Id of the workgroup member queue
	Throws [Exceptions]: [optional]				
	
	History						
	DATE	 AUTHOR	 Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	@TestVisible private static CH_Workgroup_Member__c getQueue(Case newCase) {
			
		CH_Workgroup_Member__c foundQueue; 
		
		// Get workgroup members for the case
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		foundQueue = service.getPortalOrS2SCaseAssignmentWorkgroupMembers();
		// If no authroized workgroup members were found, get the SF GWC queue
		// The GWC queue is a real SF queue save in field CH_QueueId__c
		if (foundQueue == null){
	foundQueue = new CH_Workgroup_Member__c (CH_User__c = getGWCQueue(),Name = 'GWC',CH_Workgroup__c = null,CH_Queue_Email__c = null,
				 CH_Workgroup_Member_Type__c = 'Queue'
				);		
	
		}
		
		return foundQueue;
	}
}