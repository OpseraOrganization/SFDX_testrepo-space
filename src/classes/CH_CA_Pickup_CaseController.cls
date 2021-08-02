public  without sharing class CH_CA_Pickup_CaseController {
	
	public class CaseWrapper {
		@AuraEnabled public Case oCase {get;set;}
		@AuraEnabled public Datetime targetDate {get;set;}
	}
	public class WorkgroupMemberWrapper {
		@AuraEnabled public String Id {get;set;} 
		@AuraEnabled public String Country {get;set;} 
		@AuraEnabled public String Name {get;set;} 
		@AuraEnabled public Datetime LastCaseAssigned {get;set;}
		@AuraEnabled public Integer TotalCaseAssigned {get;set;}
		@AuraEnabled public Integer TotalCaseAssignedInWorkgroup {get;set;}
		@AuraEnabled public Integer TotalCaseAssignedOnPendingCustomer {get;set;}
		
	}
	@AuraEnabled
	public static List<CaseWrapper> getCases(String caseType, String serviceType) {
		Id userId = UserInfo.getUserId();
		List<CH_Workgroup_Member__c> workgroupMembers = [SELECT CH_Workgroup__r.Id FROM CH_Workgroup_Member__c WHERE CH_User__c = :userId];
		Set<Id> workgroupIds = new Set<Id>();
		for(CH_Workgroup_Member__c w : workgroupMembers){
			workgroupIds.add(w.CH_Workgroup__r.Id);
		}
		List<CH_Workgroup_Member__c> queues = [SELECT CH_User__r.Id FROM CH_Workgroup_Member__c WHERE CH_Workgroup__c in :workgroupIds AND CH_Workgroup_Member_Type__c = 'Queue'];
		Set<Id> queuesIds = new Set<Id>();
		for(CH_Workgroup_Member__c q : queues){
			queuesIds.add(q.CH_User__r.Id);
		}
		List<GroupMember> userSecGroupMembers = [SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :userId];
		Set<Id> groupsIds = new Set<Id>();
		for(GroupMember gm : userSecGroupMembers){
			groupsIds.add(gm.GroupId);
		}
		List<Group> userSecGroups = [SELECT Name FROM Group WHERE Id in :groupsIds];
		Set<String> groupNames = new Set<String>();
		for(Group g : userSecGroups){
			groupNames.add(g.Name);
		}
		//Support ticket's service type being recieved from the component - Customer Support / Internal Support
		//based on the service type, unassigned cases would be extracted. 
		String caseServiceType = serviceType ;
		Set<String> caseTypeSet = new Set<String>();
		if(caseType.equals('Incident')) caseTypeSet = new Set<String>{'Nokia Standard Case','Nokia Information Request', 'Nokia Incident with Restoration'};
			else if(caseType.equals('Problem')) caseTypeSet = new Set<String>{'Problem'};
			/*
				List<Case> unassignedCases = [SELECT Id, HWS_Customer_ID__c, ProductId, CH_Product_Name__c, 
											  CH_Product_Release_Name__c, AccountId, CH_Account_Name__c, 
											  CaseNumber, Severity__c, CH_Outage__c, Status, CH_CRStatus__c, 
											  Subject, CreatedDate, CH_Workgroup__r.Name, CH_Workgroup__c, 
											  CH_CurrentQueue__c, CH_ServiceType__c 
											  FROM Case 
											  WHERE (OwnerId in :queuesIds) AND 
											  (CH_Workgroup__c in :workgroupIds) AND 
											  (CH_ServiceType__c = :caseServiceType) AND
											  (RecordType.Name in :caseTypeSet) AND
											  (CH_SecurityGroup__c in :groupNames OR CH_GWC_SecurityGroup__c in :groupNames OR CH_3rdPartySecurityGroup__c in :groupNames) 
											  for update ];
			 */
			
			List<Case> unassignedCases;
		String getQuery;
		//Miguel Silva - changing filters on Status NOKIASC-27003
		String excludeCancelled='Cancelled';
		String excludeCompleted='Completed';
		IF(caseType == 'Incident'){
			getQuery='SELECT Id, HWS_Customer_ID__c, ProductId, CH_Product_Name__c, CH_Product_Release_Name__c, AccountId, CH_Account_Name__c,CaseNumber, Severity__c, CH_Outage__c, Status, CH_CRStatus__c, Subject, CreatedDate, CH_Workgroup__r.Name, CH_Workgroup__c,CH_CurrentQueue__c, CH_ServiceType__c FROM Case WHERE Status !=: excludeCancelled AND Status !=: excludeCompleted AND (OwnerId in :queuesIds) AND (CH_Workgroup__c IN : workgroupIds) AND (CH_ServiceType__c = :caseServiceType )AND (RecordType.Name in :caseTypeSet ) AND (CH_SecurityGroup__c in :groupNames OR CH_GWC_SecurityGroup__c in :groupNames OR CH_3rdPartySecurityGroup__c in :groupNames )  FOR update ';
		}
		ELSE{
			getQuery='SELECT Id, HWS_Customer_ID__c, ProductId, CH_Product_Name__c, CH_Product_Release_Name__c, AccountId, CH_Account_Name__c,CaseNumber, Severity__c, CH_Outage__c, Status, CH_CRStatus__c, Subject, CreatedDate, CH_Workgroup__r.Name, CH_Workgroup__c,CH_CurrentQueue__c, CH_ServiceType__c FROM Case WHERE Status !=: excludeCancelled AND Status !=: excludeCompleted AND (OwnerId in :queuesIds) AND (CH_Workgroup__c IN : workgroupIds) AND (RecordType.Name in :caseTypeSet ) AND (CH_SecurityGroup__c in :groupNames OR CH_GWC_SecurityGroup__c in :groupNames OR CH_3rdPartySecurityGroup__c in :groupNames )  FOR update ';
		}
		
		unassignedCases  =Database.Query(getQuery);
		
		Map<Id, CaseWrapper> unassignedCasesMap = new Map<Id, CaseWrapper>();
		for(Case unassignedCase : unassignedCases){
			CaseWrapper wCase = new CaseWrapper();
			wCase.oCase = unassignedCase;
			wCase.targetDate = null;
			unassignedCasesMap.put(unassignedCase.Id, wCase);
		}
		for(CaseMilestone caseMilestone : [SELECT TargetDate, CaseID FROM CaseMilestone WHERE CaseID in :unassignedCasesMap.keySet() AND IsCompleted = FALSE AND IsDeleted = FALSE ORDER BY TargetDate ASC] ) {
			CaseWrapper unassignedCase = unassignedCasesMap.get(caseMilestone.CaseID);
			if(unassignedCase.targetDate == NULL){
				unassignedCase.targetDate = caseMilestone.TargetDate;
				unassignedCasesMap.put(caseMilestone.CaseID, unassignedCase);				
			}
		}
		//System.debug(unassignedCasesMap.values());
		return unassignedCasesMap.values();
	}
	
	// Assign the selected cases to the logged in user
	// CaseList contains CaseIds and WorkgroupIds
	@AuraEnabled
	public static String saveCases(String casesList, String caseType, String serviceType) {
		
		// Convert the JSON to a list of cases
		set<id> selectedCaseIds = new set<id>();
		List<Case> selectedCases = (List<Case>) JSON.deserialize(casesList, List<Case>.class);
		for (Case selectedCase : selectedCases){
			selectedCaseIds.add(selectedCase.id);
		}
		
		// Get all cases again to make sure that the cases are still unassigned		
		List<CaseWrapper> allCases = getCases(caseType, serviceType);
		List<CaseWrapper> validCases = new List<CaseWrapper>();
		for(CaseWrapper caseToAssign : allCases){
			if(selectedCaseIds.contains(caseToAssign.oCase.Id)) {
				validCases.add(caseToAssign);
			}
		}
		//System.debug('CH_CA: Valid Cases To Reassign ' + validCases.size());
		
		// If no valid cases
		if (validCases.size() == 0){
			return 'No unassigned cases selected. Please refresh the screen and try again';
		}
		
		Set<Id> workgroupIds = new set<Id>();
		for (CaseWrapper validCaseWrapper : validCases){
			workgroupIds.add(validCaseWrapper.oCase.CH_Workgroup__c);
		}
		// Get the workgroup member Ids to assign to the valid cases based on the current logged in user
		List<CH_Workgroup_Member__c> validWorkgroupMembers = 
			[SELECT Id, CH_Workgroup__c, CH_User__c, Name, 
			 CH_Workgroup_Member_Type__c, CH_Queue_Email__c
			 FROM CH_Workgroup_Member__c 
			 WHERE CH_User__c = :UserInfo.getUserId() AND
			 CH_Workgroup__c in :workgroupIds];
		
		// Create a map with caseId and memberId 
		Map<id,CH_Workgroup_Member__c> assignments = new Map<id,CH_Workgroup_Member__c>(); 
		for (CaseWrapper validCaseWrapper : validCases){
			Case validCase = validCaseWrapper.oCase;
			// Get the workgroup member for the case
			for (CH_Workgroup_Member__c validMember : validWorkgroupMembers){
				if (validCase.CH_Workgroup__c == validMember.CH_Workgroup__c){
					assignments.put(validCase.Id, validMember);
				} 
			}
		}
		
		//System.debug('CH_CA: Cases To Reassign ' + assignments.size());
		CH_CA_Service service = new CH_CA_Service(); 
		service.assignUser(assignments);
		return 'The selected cases are reassigned';
	}
	//Get Valid Workgroup Member
	@AuraEnabled
	public static List<WorkgroupMemberWrapper> getValidWorkgroupMembers(String caseId, String workgroupId) {
		Map<Id, WorkgroupMemberWrapper> workgroupMembersUsersType = new Map<Id, WorkgroupMemberWrapper>();
		
		// Get the workgroup members user type
		List<CH_Workgroup_Member__c> workgroupMembersForUser =		
			[SELECT Id, Name, CH_Role__c, CH_User__c,
			 CH_Workgroup__c, CH_Workgroup_Member_Type__c	
			 FROM CH_Workgroup_Member__c 
			 WHERE CH_Workgroup__c = :workgroupId AND CH_Workgroup_Member_Type__c='User' 
			 AND CH_User__r.isActive=true Order by CH_User__r.Lastname];
		
		
		// Create WorkgroupMemberDTO
		List<CH_CA_DTO.WorkgroupMemberDTO> wgTeamMembersDTO = new List<CH_CA_DTO.WorkgroupMemberDTO>();
		for(CH_Workgroup_Member__c member : workgroupMembersForUser){
			CH_CA_DTO.WorkgroupMemberDTO workgroupMemberDTO = new CH_CA_DTO.WorkgroupMemberDTO();
			workgroupMemberDTO.id = member.Id; 
			workgroupMemberDTO.userId = member.CH_User__c;
			workgroupMemberDTO.name = member.Name;
			workgroupMemberDTO.role = member.CH_Role__c;
			workgroupMemberDTO.type = member.CH_Workgroup_Member_Type__c;		  
			wgTeamMembersDTO.add(workgroupMemberDTO);
		}
		System.debug('CH_CA : workgroup Members found' + wgTeamMembersDTO.size());
		
		// Only get WG Members that are authroized
		List<CH_CA_DTO.WorkgroupMemberDTO> authorizedWorkgroupMembers;
		CH_CA_Service service = new CH_CA_Service(caseId); 
		authorizedWorkgroupMembers=service.checkWGMembersSecurityDesktop(wgTeamMembersDTO);
		System.debug('CH_CA : authorized Workgroup Member count  ' + authorizedWorkgroupMembers.size());  
		
		
		Set<Id> usrIds = new Set<Id>();
		for(CH_CA_DTO.WorkgroupMemberDTO userList: authorizedWorkgroupMembers){
			usrIds.add(userList.userId);
		}
		// Get user names ,last case assigned and Country to be displayed on return list		
		map<Id, User> users = new map<Id, User>([SELECT name , CH_LastCaseAssigned__c,Country FROM user where id IN :usrIds]);
		// Get case owner,workgroup and status for not closed nor cancelled nor completed cases aginst workgroup members
		map < Id, Case > CaseMap= new map < Id, Case >([SELECT ownerId,CH_Workgroup__c,Status FROM CASE WHERE ownerId IN :usrIds AND STATUS NOT IN ('Closed','Cancelled','Completed')]);
		//Create return list for valid workgroup member 
		for(CH_CA_DTO.WorkgroupMemberDTO member : authorizedWorkgroupMembers){
			WorkgroupMemberWrapper wgMemmberWrapperDTO = new WorkgroupMemberWrapper();
			wgMemmberWrapperDTO.Id = member.Id;
			wgMemmberWrapperDTO.Name = users.get(member.userId).Name;
			wgMemmberWrapperDTO.Country=users.get(member.userId).Country;
			wgMemmberWrapperDTO.LastCaseAssigned=users.get(member.userId).CH_LastCaseAssigned__c;			
			wgMemmberWrapperDTO.TotalCaseAssigned=getAllCaseAssigned(CaseMap,member.userId);
			wgMemmberWrapperDTO.TotalCaseAssignedInWorkgroup=getAllCaseAssignedInWorkgroup(CaseMap,member.userId,workgroupId);
			wgMemmberWrapperDTO.TotalCaseAssignedOnPendingCustomer=getAllCaseAssignedOnPendingCustomer(CaseMap,member.userId);
			workgroupMembersUsersType.put(member.Id, wgMemmberWrapperDTO);  
		}
		return workgroupMembersUsersType.values();
	}
	//Get No of cases owned by this user in that Workgroup and not closed nor cancelled nor completed
	private static Integer getAllCaseAssignedInWorkgroup(map < Id, Case > CaseMap,String userID,String workgroupId)
	{		
		Integer getAllCaseAssignedInWorkgroupCount =0;
		for (String key : CaseMap.keySet())
		{
			String ownerId = CaseMap.get(key).ownerId;
			if(ownerId==userID && CaseMap.get(key).CH_Workgroup__c==workgroupId){
				getAllCaseAssignedInWorkgroupCount++; 
			}						
		}				
		return getAllCaseAssignedInWorkgroupCount;
	}
	// Get No of cases owned by this user cross Workgroup and not closed nor cancelled nor completed
	private static Integer getAllCaseAssigned(map < Id, Case > CaseMap,String userID)
	{
		Integer getAllCaseAssignedCount =0;
		for (String key : CaseMap.keySet())
		{			
			if(CaseMap.get(key).ownerId==userID){
				getAllCaseAssignedCount++; 
			}			
		}		
		return getAllCaseAssignedCount;
	}
	//Get No of cases owned by this user cross Workgroup in pending customer status
	private static Integer getAllCaseAssignedOnPendingCustomer(map < Id, Case > CaseMap,String userID)
	{
		Integer getAllCaseAssignedCount =0;
		for (String key : CaseMap.keySet())
		{			
			if(CaseMap.get(key).ownerId==userID && CaseMap.get(key).Status =='Pending Customer'){
				getAllCaseAssignedCount++; 
			}			
		}		
		return getAllCaseAssignedCount;
	}
	//Description - This method is used to update case owner 
	@AuraEnabled
	public static void updateSupportTicketOwner(String caseId, String memId, String caseType, String serviceType){
		// Get all cases again to make sure that the cases are still unassigned		
		try{
			List<CaseWrapper> allListOfCases = getCases(caseType, serviceType);
			Boolean isCaseExists = false;
			for(CaseWrapper caseToAssign : allListOfCases){
				if(caseToAssign.oCase.Id == caseId){
					isCaseExists=true;
					break;
				}				
			}
			// If no valid cases			
			if (isCaseExists== false){
				AuraHandledException auraExp = new AuraHandledException('');
				auraExp.setMessage('No unassigned cases selected. Please refresh the screen and try again.');	   
				throw auraExp;			
			}
			CH_Workgroup_Member__c validWorkgroupMember = 
				[SELECT Id, CH_Workgroup__c, CH_User__c, Name, 
				 CH_Workgroup_Member_Type__c, CH_Queue_Email__c,
				 CH_Workgroup__r.Name
				 FROM CH_Workgroup_Member__c   
				 WHERE Id = :memId LIMIT 1];
			
			Map<id,CH_Workgroup_Member__c> assignment = new Map<id,CH_Workgroup_Member__c>{caseId => validWorkgroupMember};
				CH_CA_Service service = new CH_CA_Service(caseId); 
			service.assignUser(assignment);		
			System.debug('CH_CA: LIM CH_CA_Pickup_CaseController.updateSupportTicketOwner SOQL limit: ' + Limits.getQueries());
		}
		catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}	
}