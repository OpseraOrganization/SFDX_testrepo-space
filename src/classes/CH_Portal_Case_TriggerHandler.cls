public class CH_Portal_Case_TriggerHandler {
	
	private static final string GWC_QUEUE = 'GWC';
	private static final string COMMUNITY_USERTYPE = 'PowerCustomerSuccess'; 
	
	/***************************************************************** 
	Description:  
	Get the case record for the case id

	Parameters: Id of the case 
	Returns: Case object
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	28/05/2019	 Umesh Shinde		Changes made for US#17226
	*****************************************************************/	
	public static void assignOwner(List<case> caseList) { 
		string standardCaseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();		
		CH_Workgroup_Member__c foundQueue = new CH_Workgroup_Member__c();
		string entitlementException;
		// Loop through all case
		for (Case newCase : caseList) {
		   // String recordTypeName = newCase.RecordType.DeveloperName;
			// Update only process portal cases
		   // if (recordTypeName == 'Nokia Standard Case' && (isCaseCreatedByPortalUser(newCase) || isCaseCreatedByNAIPUser(newCase) || newCase.Origin == 'S2S')) {
	 if (newCase.RecordTypeId == standardCaseRecordTypeId && (isCaseCreatedByPortalUser(newCase) || isCaseCreatedByNAIPUser(newCase) || newCase.Origin == 'S2S')) {
				// Check if entitlment has an entitlment script
				if (hasEntitlementScript(newCase)){
					//Set entitlementException -> Changes for US 17726 starts
					entitlementException = 'Entitlement Script Verification Required';
					// Get GWC queue
					foundQueue.CH_User__c = GetGWCQueue();
					foundQueue.Name = 'GWC';
		foundQueue.CH_Workgroup__c = null;
					foundQueue.CH_Queue_Email__c = null;
					foundQueue.CH_Workgroup_Member_Type__c = 'Queue';

					System.debug('CH_CA: Has Entitlement Script assigned to: ' + foundQueue.Name + ' ' + foundQueue.CH_User__c);
				}
				else {
					//Set entitlementException -> Changes for US 17726 starts
					entitlementException = 'No Exception';
					// Get workgroup queue
					foundQueue = GetQueue(newCase);
					System.debug('CH_CA: Has No Entitlement Script assigned to: ' + foundQueue.Name + ' ' + foundQueue.CH_User__c);
				}
				// Assign case to GWC queue
				CH_CA_Service service = new CH_CA_Service();
				Map<id,CH_Workgroup_Member__c> assignment = new Map<id,CH_Workgroup_Member__c>{newCase.Id => foundQueue};
				service.assignUser(assignment);
				// Set the entitlement exception
				//newCase.CH_EntitlementException__c = entitlementException;
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
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	@TestVisible private static boolean isCaseCreatedByPortalUser(Case newCase) {
		System.debug('CH_CA: Created by: ' + newCase.CreatedById);
		//Using userInfo t get User Type as part of Code Optimization -- 27619 --> Satya Pagadala
		//User caseCreationUser = [SELECT id,name,Profile.Name, userType FROM User WHERE Id = :newCase.CreatedById];
		//System.debug('CH_CA: ProfileName: ' + caseCreationUser.Profile.Name);		
		return (userInfo.getUserType() == COMMUNITY_USERTYPE) ? true : false;   
	}

	/*****************************************************************
	Description:  
	Check if the creator of the case is NAIP User

	Parameters: a case
	Returns: true = creater is NAIP User
	false = creator is not NAIP User
	Throws [Exceptions]: [optional]
	
	History
	DATE		   AUTHOR		   Change
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
	DATE		   AUTHOR		   Change
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
				/*ServiceContract serviceContract = [SELECT Id, CH_EntitlementScript__c  
												   FROM ServiceContract 
												   WHERE Id = :contractLineItems[0].ServiceContractId LIMIT 1];*/
				If (!String.isBlank(contractLineItems[0].ServiceContract.CH_EntitlementScript__c)){
					hasEntitlementScript = true;
				} 
			}
		}
		System.debug('CH_CA: hasEntitlementScript ' + hasEntitlementScript);
		return hasEntitlementScript; 
	} 

	/*****************************************************************
	Description:  
	Get the Id of the GWC queue that is used for default assignment

	Parameters: NA 
	Returns: Id of the GWC queue
	Throws [Exceptions]: [optional]														  
	
	History															
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/
	@TestVisible private static Id GetGWCQueue() {
		Group gwcQueue = [select Id from Group where  Type = 'Queue' AND NAME = :GWC_QUEUE LIMIT 1];
		System.debug('CH_CA: Found SF Queue: ' + GWC_QUEUE + ' Queue Id: ' + gwcQueue.Id);
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
	DATE		   AUTHOR		   Change
	01/08/2018	 Jeroen de Vries  Created
	*****************************************************************/	
	@TestVisible private static CH_Workgroup_Member__c GetQueue(Case newCase) {
		 	
		CH_Workgroup_Member__c foundQueue; 
		
		// Get workgroup members for the case
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = service.getPassiveCaseAssignmentWorkgroupMembers();
		// From the authorized workgroup members get the first workgroup member with the type queue
		// The found queue is a SF user that acts as a queue and is saved in the field CH_User__c
		If (workgroupMembers.size() > 0) { 
			// Get the a queue 
			for (CH_CA_DTO.WorkgroupMemberDTO workgroupMember : workgroupMembers){
				if (workgroupMember.type == 'Queue'){
					foundQueue = new CH_Workgroup_Member__c (
						CH_User__c = workgroupMember.userId,
						CH_Workgroup__c = workgroupMember.workgroupId,
						id = workgroupMember.id,
						Name = workgroupMember.Name,
			CH_Queue_Email__c = workgroupMember.queueEmail,
						CH_Workgroup_Member_Type__c = workgroupMember.type);
					break;
				}
			}
			System.debug('CH_CA: Workgroup Queue found: ' + ((foundQueue == null) ? 'No user with type Queue found' : foundQueue.CH_User__c));
		}
		
		// If no authroized workgroup members were found, get the SF GWC queue
		// The GWC queue is a real SF queue save in field CH_QueueId__c
		if (foundQueue == null){
			foundQueue = new CH_Workgroup_Member__c (
						CH_User__c = null,
						CH_QueueId__c = GetGWCQueue(),
						CH_Workgroup__c = null);			
		 System.debug('CH_CA: No Workgroup Queue found. GWC SF Queue found: ' + foundQueue.CH_User__c);
		}
		
		return foundQueue;
	}
}