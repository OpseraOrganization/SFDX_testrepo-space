public class CH_DisplayWorkgroupHelper { 

	private final boolean GETONLYFIRSTRULE = true;
	private final boolean GETALLRULES = false;
	private final boolean CALCULATEASSIGNMENTTYPE = true;
	private final boolean ACTIVEASSIGNMENT = false;
	
	// Get the queue for portal case assignment - used by CH_Portal_Case_TriggerHandler
	public CH_CaseAssignment GetQueueToAssign(Id caseId){
		CH_CaseAssignment caseAssignmentDetails = CreateCaseAssignmentObject(caseId);
		// Get the workgroup members for the first workgroup that apply to the case criteria.
		// If the workgroup does not contain any engineers then display the workgroup members of all rules
		// that apply.
		caseAssignmentDetails = GetWorkgroupRules2(caseAssignmentDetails, GETONLYFIRSTRULE);
		caseAssignmentDetails = GetWorkgroupMembersForRules(caseAssignmentDetails, CALCULATEASSIGNMENTTYPE);
		return caseAssignmentDetails; 
	}

	// Get the workgroup members for adding to the case team - used by Lightning component CH_AddMemberInTeam
	// Used for the initial load of the case team member list
	public CH_CaseAssignment GetActiveWorkgroupMembersNoRota(Id caseId){
		CH_CaseAssignment caseAssignmentDetails = CreateCaseAssignmentObject(caseId);
		// If initial assignment and update case team
		if (caseAssignmentDetails.supportCase.status == 'Created'){
			caseAssignmentDetails = GetWorkgroupRules2(caseAssignmentDetails, GETONLYFIRSTRULE);	
		} 
		else{
			caseAssignmentDetails = GetWorkgroupRules2(caseAssignmentDetails, GETALLRULES); 
		}
		caseAssignmentDetails.isCaseTeamAssignment = true;
		caseAssignmentDetails = GetWorkgroupMembersForRules(caseAssignmentDetails, ACTIVEASSIGNMENT);
		return caseAssignmentDetails;
	}
	
	// Get the workgroup members for case assignment - used by Lightning component CH_ViewWorkgroup
	public CH_CaseAssignment GetWorkgroupMembers(Id caseId){
		CH_CaseAssignment caseAssignmentDetails = CreateCaseAssignmentObject(caseId);
		// If the case is created and somebody will be assigned to the case for the first time
		if(caseAssignmentDetails.supportCase.CH_Initial_Assignment__c){
			// Get the workgroup members for the first workgroup that apply to the case criteria.
			// If the workgroup does not contain any engineers then display the workgroup members of all rules
			// that apply.
			caseAssignmentDetails = GetWorkgroupRules2(caseAssignmentDetails, GETONLYFIRSTRULE);
			caseAssignmentDetails = GetWorkgroupMembersForRules(caseAssignmentDetails, CALCULATEASSIGNMENTTYPE);
		}
		// When a case is reassigned 
		else {
			caseAssignmentDetails = GetWorkgroupRules2(caseAssignmentDetails, GETALLRULES);
			caseAssignmentDetails = GetWorkgroupMembersForRules(caseAssignmentDetails, CALCULATEASSIGNMENTTYPE); 
		}
		return caseAssignmentDetails;
	}
	
	// Get the workgroup members to add to case team - used by Lightning component CH_AddTeamMember
	public CH_CaseAssignment GetWorkgroupMembersAllMatchingRules(CH_CaseAssignment caseAssignmentDetails){
		caseAssignmentDetails = GetWorkgroupRules2(caseAssignmentDetails, GETALLRULES);
		caseAssignmentDetails.isCaseTeamAssignment = true;		
		return GetWorkgroupMembersForRules(caseAssignmentDetails, ACTIVEASSIGNMENT);
	}
	
	// Assign the problem to the first queue from the first workgroup that applies to the case criteria
	// - Used by the flow 'Create Problem From Incident'
	@InvocableMethod(label='CH - Problem Assignment' description='Assigns a queue to a newly created problem')
	public static void assignProblemToQueue(List<Id> problemIds) {
		 // Changes added to avoid DML Inside forloop
		List<Case> getCases=new List<Case>();
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		// Get a map of queues by name
		map<string, Group> queueByName = new map<string, Group>();
		for(Group qGroup : [SELECT Name FROM Group Where Type = 'Queue' limit 10000])
			queueByName.put(qGroup.Name, qGroup);
		
		for (Id problemId : problemIds) {
			Id queueId;
			// Need to create the helper again because it's used in a static context
			// Get the first rule
			//CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
			CH_CaseAssignment caseAssignmentDetails = helper.CreateCaseAssignmentObject(problemId);
			// Get the workgroup members for the first workgroup that apply to the case criteria.
			// If the workgroup does not contain any engineers then display the workgroup members of all rules
			// that apply.
			caseAssignmentDetails = helper.GetWorkgroupRules2(caseAssignmentDetails, true);	  
			caseAssignmentDetails = helper.GetWorkgroupMembersForRules(caseAssignmentDetails, true);
			
			Case problem = caseAssignmentDetails.supportCase;
			
			If (caseAssignmentDetails.validWorkgroupRules.size() > 0){
	problem.CH_Workgroup__c = caseAssignmentDetails.validWorkgroupRules[0].CH_Workgroup__c;
			}
			If (caseAssignmentDetails.validWorkgroupMembers.size() > 0){
	System.debug('workgroupMembers ' + caseAssignmentDetails.validWorkgroupMembers.size());
	// Get the a queue
	for (CH_Workgroup_Member__c workgroupMember : caseAssignmentDetails.validWorkgroupMembers){
		if (workgroupMember.CH_Queue__c  != null){
			string queueName = workgroupMember.CH_Queue__c;
			// Get the queue id for the workgroup name
			//Group queue = [SELECT Id FROM Group Where Name = :queueName AND Type = 'Queue' Limit 1];
			if(queueByName.containsKey(queueName))
			queueId = queueByName.get(queueName).Id;
			//queueId = queue.Id;
			system.debug('queue id = ' + queueId);
			problem.OwnerId = queueId;
			break;
		}
	}
	problem.CH_Initial_Assignment__c = false;
	problem.CH_Reassignment__c=false; 
			}
			//update problem;
	getCases.add(problem);
			// Set the problem team 
			//helper.addMembersToCaseTeamAtAssignment(problem);
			// Send out notifications to queue members
			//helper.notifyQueueMembers(queueId, problemId);
		}
		 if(getCases.size()>0){
			update getCases;
			// Set the problem team 
			for(Case lstcase:getCases){
				helper.addMembersToCaseTeamAtAssignment(lstcase);
			}
			
		}
	}
	
	// Send an email to all memebers of a queue
	// Note: This method is duplicated for a quick fix to the class CH_R1_TEMP_QueueNotification
	// This needs to be refactored
	// Used by 
	// - CH_DisplayWorkgroup
	// - CH_R1_TEMP_QueueNotification
	public void notifyQueueMembers(id queueId, id caseId){
		// Get the case
		//Case supportCase = [SELECT Id, CaseNumber, Owner.Name, CH_AssignedDate__c, CH_Stage__c,
		//			CH_ReportedDate__c, CH_ServiceType__c, CH_RecordTypeDevName__c, Severity__c,
		//			CH_Product_Name__c, CH_ExternalBridge__c, Account.Name , Account.Region__c,
		//			CH_Workgroup__r.Name, Contact.CH_ContactTimeZone__c
		//		FROM Case 
		//		WHERE Id =:caseId];	  
 
		// Get the email address from all workgroup members
		//List<User> queueMembers = [SELECT Id, Email FROM User WHERE Id IN (
		//	SELECT UserOrGroupId 
		//	FROM GroupMember 
		//	WHERE GroupId = :queueId)];

		//sendNotificationEmail(supportCase, queueMembers);
		//createNotificationChatterPost(supportCase, queueMembers); Deactivated as part of NOKIASC-15232, 14776	  
	}
	
	// Send emails about case assignment to a list of users
	/*private void sendNotificationEmail(Case supportCase, List<User> queueMembers){
		String subject = 'Case Assigned to ' + supportCase.Owner.Name + ' for ' + 
			supportCase.Account.Name + ', ' + supportCase.CH_Product_Name__c;

		String body = 'Dear User,<br><br><br>';
		body += 'The Case ' + supportCase.CaseNumber + ' has been assigned to ' + 
			supportCase.Owner.Name + '.<br><br>';
		body += 'The Case is within the ' + supportCase.CH_Stage__c + ' process stage.<br><br>';
		body += '<b>Case Details:</b><br>';
		body += 'Reported to Nokia: ' + string.valueOfGmt(supportCase.CH_ReportedDate__c) + '<br>';
		body += 'Service Type: ' + supportCase.CH_ServiceType__c + '<br>';
		body += 'Case Type:  ' + supportCase.CH_RecordTypeDevName__c + '<br>';
		body += 'Severity: ' + supportCase.Severity__c + '<br>';
		body += 'Product: ' + supportCase.CH_Product_Name__c + '<br>';
		body += 'External Bridge Number: ' + (supportCase.CH_ExternalBridge__c == null ? '' : supportCase.CH_ExternalBridge__c) + '<br>';
		body += 'Customer: ' + supportCase.Account.Name + ' ' + (supportCase.Account.Region__c == null ? '' : supportCase.Account.Region__c) + '<br>';
		body += 'Customer Time Zone: ' + (supportCase.Contact.CH_ContactTimeZone__c == null ? '' : supportCase.Contact.CH_ContactTimeZone__c) + '<br>';
		body += 'Current Workgroup: ' + supportCase.CH_Workgroup__r.Name + '<br>';
		body += 'View <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + supportCase.id + '">this Case</a><br><br>';
		body += 'Regards,<br>';
		body += 'Nokia Support Services.';

		List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
		// Create an email for all queue members
		for (User queueMember : queueMembers){
			// Create the email
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			List<String> sendTo = new List<string>();
			sendTo.add(queueMember.Email);
			mail.setToAddresses(sendTo);
			mail.setBccSender(false);
			mail.setSubject(subject);
			mail.setHtmlBody(body);
			mail.setTreatTargetObjectAsRecipient(false);
			emailList.add(mail);
		}
		// Send the emails
		Messaging.sendEmail(emailList);		
	}*/
	
	// Send notifications about case assignment to a list of users
	/*private void createNotificationChatterPost(Case supportCase, List<User> queueMembers){
		
		// Create the chatter text
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = 'The Case ' + supportCase.CaseNumber + ' has been assigned to ' + supportCase.Owner.Name + '\n\n';
	
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		messageBodyInput.messageSegments.add(textSegmentInput);
		// Create an @mention for all queue members  
		for (User queueMember : queueMembers){
			ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
			mentionSegmentInput.id = queueMember.id;
			messageBodyInput.messageSegments.add(mentionSegmentInput);
		} 
  
		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		feedItemInput.body = messageBodyInput;
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = supportCase.id;
		
		ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);		  
	}*/
	
	// Get the workgroup rules for the rule based on the search criteria - Used by lightning component CH_Test_Workgroup_Rules
	public List<CH_Workgroup_Rule__c> GetWorkgroupRules(CH_CaseAssignment caseAssignmentDetails){
		return getAllWorkgroupRules(caseAssignmentDetails);
	}
	
	// When a case is created/updated the ccm and incident managers need to be added to the case team
	public void addMembersToCaseTeamAtCreationUpdate(Case updatedCase){
		
		map<string, CaseTeamRole> allCaseRoles = getAllcaseTeamRoleByName();
		map<id, set<Id>> allCaseMembers = getAllcaseTeamMembersByCase(new list<Id>{updatedCase.Id});
		
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		Id restorationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Incident with Restoration').getRecordTypeId();
		List<CaseTeamMember> incidentManagersForCaseTeam = new List<CaseTeamMember>();
		// When the case recordtype changes to incident with restauration, add the incident manager
		if (updatedCase.RecordTypeId == restorationRecordTypeId){
			List<string> roles = new List<string>();
			roles.add('Incident Manager');
			
			// Get the incident managers
			List<CH_Workgroup_Member__c> incidentManagers = [SELECT Id, CH_Role__c, CH_User__r.Id 
						FROM CH_Workgroup_Member__c 
						WHERE CH_Workgroup__c = :updatedCase.CH_Workgroup__c AND
						CH_Role__c in :roles ORDER BY CH_User__r.Lastname];
			// Add all the found incident managers to the case team
			for (CH_Workgroup_Member__c member : incidentManagers){
	// Add to team
	//CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, member);
	CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, member, allCaseRoles, member.CH_Role__c, allCaseMembers);
	if (newTeamMember != null){
		incidentManagersForCaseTeam.add(newTeamMember);
	}
			}
		}
		
		List<CaseTeamMember> careManagersForCaseTeam = new List<CaseTeamMember>();
		// Add the customer care managers
		if(updatedCase.RecordTypeId != problemRecordTypeId){
			List<CaseTeamMember> newCustomerCareManagers = getCustomerCareManager(updatedCase);
			careManagersForCaseTeam.addAll(newCustomerCareManagers);
		}
		
		List<CaseTeamMember> membersForCaseTeam = new List<CaseTeamMember>();
		membersForCaseTeam.addAll(careManagersForCaseTeam);
		membersForCaseTeam.addAll(incidentManagersForCaseTeam);
			
		insert membersForCaseTeam; 
	}
	
	// When ever a case is assigned/re-assigned, certain members from the workgroup are added to the case team
	public void addMembersToCaseTeamAtAssignment(Case updatedCase){
		try{ 
		// Get all team roles (SOQL reduction)
		map<string, CaseTeamRole> allCaseRoles = getAllcaseTeamRoleByName();
		
		// Get the cases related to the problem
		List<Case> relatedCases = [SELECT Id FROM Case WHERE CH_Problem__c = :updatedCase.Id];

		// Get all team members for this case and all related cases
		List<Id> caseIdsOfCaseTeamsToUpdate = new List<Id>();
		for (Case relatedCase : relatedCases){
			caseIdsOfCaseTeamsToUpdate.add(relatedCase.Id);
		}
		// Add the current case
		caseIdsOfCaseTeamsToUpdate.add(updatedCase.Id);
		map<id, set<Id>> allCaseMembers = getAllcaseTeamMembersByCase(caseIdsOfCaseTeamsToUpdate);
		
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		Id restorationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Nokia Incident with Restoration').getRecordTypeId();

		// Determine per recordtype what roles need to be added to teams
		List<string> roles = new List<string>();
		if (updatedCase.RecordTypeId == problemRecordTypeId){
			roles.add('Problem Manager');
			roles.add('Case Manager');
		}
		else{
			roles.add('Case Manager');
		}
		
		// Get the workgroup members
		List<CH_Workgroup_Member__c> membersForCaseTeam = [SELECT Id, CH_Role__c, CH_User__r.Id 
				 FROM CH_Workgroup_Member__c 
				 WHERE CH_Workgroup__c = :updatedCase.CH_Workgroup__c AND
						CH_Role__c in :roles Order by CH_User__r.Lastname  ];

		List<CaseTeamMember> newCaseTeamMembers = new List<CaseTeamMember>();
		// Case (re)assigned, Add managers to the case team
		// - Case Manager
		if(updatedCase.RecordTypeId != problemRecordTypeId){
			// Add all the found workgroup members to the case team
			for (CH_Workgroup_Member__c member : membersForCaseTeam){
	// Add to team
	//CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, member);
	CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, member, allCaseRoles, member.CH_Role__c, allCaseMembers);
	if (newTeamMember != null){
		newCaseTeamMembers.add(newTeamMember);
	}
			}
		}
		
		// Problem (re)assigned, add managers to the related cases
		// - problem manager added to the related cases
		// - Case Manager
		if (updatedCase.RecordTypeId == problemRecordTypeId){			
			for (Case caseRelatedToProblem : relatedCases){
	// Add all the found workgroup members (problem managers) to the case team
	for (CH_Workgroup_Member__c member : membersForCaseTeam){
		// Add to team
		//CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(caseRelatedToProblem, member);
		CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(caseRelatedToProblem, member, allCaseRoles, member.CH_Role__c, allCaseMembers);
		if (newTeamMember != null){
			newCaseTeamMembers.add(newTeamMember);
		}
	}
			}
			// Add all the found workgroup members to the problem team
			for (CH_Workgroup_Member__c member : membersForCaseTeam){
	// Add to team
	//CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, member);
	CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, member, allCaseRoles, member.CH_Role__c, allCaseMembers);
	if (newTeamMember != null){
		newCaseTeamMembers.add(newTeamMember);
	}
			}
		}
		
		insert newCaseTeamMembers;   
	  }
		catch(exception e){
			System.debug('e'+e);
		}
	}	 
	
	private List<CaseTeamMember> getCustomerCareManager(Case updatedCase){
		
		map<string, CaseTeamRole> allCaseRoles = getAllcaseTeamRoleByName();
		map<id, set<Id>> allCaseMembers = getAllcaseTeamMembersByCase(new list<Id>{updatedCase.Id});
		
		// Get the iPaas userid. This is the default user on the service contract if no customer care manager is assigned
		User iPaasUser = [SELECT Id FROM User Where Name = 'iPAAS User'];
		List<CaseTeamMember> newCaseTeamMembers = new List<CaseTeamMember>();
		
		if (updatedCase.EntitlementId != null){
			//Entitlement entitlement = [SELECT ServiceContractId, (SELECT OwnerId FROM Entitlements ) FROM Entitlement Where Id = :updatedCase.EntitlementId LIMIT 1];
			Entitlement entitlement = [SELECT ServiceContractId FROM Entitlement Where Id = :updatedCase.EntitlementId LIMIT 1];
			ServiceContract serviceContract = [SELECT OwnerId FROM ServiceContract Where Id = :entitlement.serviceContractId LIMIT 1];
			If (serviceContract.OwnerId != iPaasUser.Id){
	//CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, new CH_Workgroup_Member__c(CH_Role__c = 'Customer Care Manager', CH_User__c = serviceContract.OwnerId));
	CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, new CH_Workgroup_Member__c(CH_Role__c = 'Customer Care Manager', CH_User__c = serviceContract.OwnerId), allCaseRoles, 'Customer Care Manager', allCaseMembers);
	if (newTeamMember != null){
		newCaseTeamMembers.add(newTeamMember);
	}
			}
			else {
	List<AccountTeamMember> accountTeamCareManagers = [SELECT UserId From AccountTeamMember WHERE TeamMemberRole = 'Customer Care Manager' AND AccountId = :updatedCase.AccountId];
	for (AccountTeamMember accountTeamMember : accountTeamCareManagers){
		//CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, new CH_Workgroup_Member__c(CH_Role__c = 'Customer Care Manager', CH_User__c = accountTeamMember.UserId));
		CaseTeamMember newTeamMember = addWorkgroupMemberToCaseTeam(updatedCase, new CH_Workgroup_Member__c(CH_Role__c = 'Customer Care Manager', CH_User__c = accountTeamMember.UserId), allCaseRoles, 'Customer Care Manager', allCaseMembers);
		if (newTeamMember != null){
			newCaseTeamMembers.add(newTeamMember);
		}
	}
			}
		}
		
		return newCaseTeamMembers;
	}
	
	public static boolean caseTeamMemberExists(Id ParentId, Id MemberId){
		list<CaseTeamMember> members = new list<CaseTeamMember>([SELECT Id FROM CaseTeamMember WHERE ParentId = :ParentId AND MemberId = :MemberId limit 1]);
		return members.size() > 0; 
	}
	
	/*
	// Add a workgroup member to the case team
	private CaseTeamMember addWorkgroupMemberToCaseTeam(Case updatedCase, CH_Workgroup_Member__c member){		
		CaseTeamRole role = [select Id from CaseTeamRole where Name = :member.CH_Role__c limit 1];
		CaseTeamMember caseTeamMember = new CaseTeamMember();
		caseTeamMember.ParentId = updatedCase.Id;
		caseTeamMember.MemberId = member.CH_User__c;
		caseTeamMember.TeamRoleId = role.Id;
		// Not possible to insert the same user as a member more than once!
		if(caseTeamMemberExists(caseTeamMember.ParentId, caseTeamMember.MemberId)){
			caseTeamMember = null;
		}
		return caseTeamMember;
	}
	*/
	
	// Create a CH_CaseAssignment object based on the case data
	private CH_CaseAssignment CreateCaseAssignmentObject(Id caseId){
		Case supportCase = [SELECT Id, CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c, CH_Originating_Incident_Number__c,
				RecordTypeId, Status, Severity__c, Account.Region__c, Account.Country__c, CH_Reassignment__c,
				AccountId, ProductId, CH_Outage__c, NCP_Service_Contract__r.Name, BusinessHoursId, CH_SystemRestored__c 
				FROM Case 
				WHERE Id =:caseId];

		// Get the all worgroup rules that apply 
		CH_CaseAssignment caseAssignmentDetails;
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		if (supportCase.RecordTypeId == problemRecordTypeId){
			caseAssignmentDetails = createProblemSearchCriteria(supportCase);
		}else {
			caseAssignmentDetails = createIncidentSearchCriteria(supportCase);
		}

		return caseAssignmentDetails;	 
	}

	// Get the workgroup members for the add members to case team component
	private CH_CaseAssignment GetWorkgroupRules2(CH_CaseAssignment caseAssignmentDetails, boolean onlyFirstRule){
		// Get the worgroup rules that apply
		List<CH_Workgroup_Rule__c> allWorkgroupRules = getAllWorkgroupRules(caseAssignmentDetails);
		// If only the first rule needs to be used for getting the workgroup members
		If (onlyFirstRule){
			List<CH_Workgroup_Rule__c> tempValidWorkgroupRules = new List<CH_Workgroup_Rule__c>();
			tempValidWorkgroupRules.add(allWorkgroupRules[0]);
			caseAssignmentDetails.validWorkgroupRules = tempValidWorkgroupRules;
		}
		else {
			caseAssignmentDetails.validWorkgroupRules = allWorkgroupRules;
		}
		return caseAssignmentDetails;
	}
	
	// Get the workgroup members for the add members to case team component
	private CH_CaseAssignment GetWorkgroupMembersForRules(CH_CaseAssignment caseAssignmentDetails, boolean calculateAssignmentType){		
		// default assignment type to determine the workgroup members (used for adding members to the case team)	  
		if (calculateAssignmentType) {		
			caseAssignmentDetails.isActiveAssignment = getAssignmentType(caseAssignmentDetails);
		}
		else {
			caseAssignmentDetails.isActiveAssignment = true;
		}
		
		// Determine if ROTA needs to be retrieved for the members
		if (caseAssignmentDetails.isActiveAssignment && caseAssignmentDetails.supportCase.CH_Initial_Assignment__c){
			caseAssignmentDetails.isAvailableAccordingToRota = true;
		}
		else {
			caseAssignmentDetails.isAvailableAccordingToRota = false;
		}   
		
		// Get the workgroup members
		caseAssignmentDetails.validWorkgroupMembers = getValidWorkgroupMembers(caseAssignmentDetails);
		return caseAssignmentDetails;
	}
	
	// Convert the case fields to rule fields
	@TestVisible 
	private CH_CaseAssignment createIncidentSearchCriteria(Case supportCase){
	
		// Determine the level of support
		List<string> levelOfSupports = new List<string>();
		if (supportCase.Status == 'Created'){
			levelOfSupports.add('Initial Support');
			levelOfSupports.add('Smart Tier 1');
		} else {
			levelOfSupports.add('Initial Support');
			levelOfSupports.add('Advanced Support');
		}
	
		CH_CaseAssignment caseAssignmentDetails = new CH_CaseAssignment();
		caseAssignmentDetails.supportCase = supportCase;
		
		// Create search criteria
		caseAssignmentDetails.contract = supportCase.NCP_Service_Contract__r.Name;
		caseAssignmentDetails.severity = supportCase.Severity__c;
		caseAssignmentDetails.region = supportCase.Account.Region__c;
		caseAssignmentDetails.country = supportCase.Account.Country__c;
		caseAssignmentDetails.levelOfSupport = levelOfSupports;
		caseAssignmentDetails.customerId = supportCase.AccountId;
		caseAssignmentDetails.GetCustomerGroupsForCustomer();
		caseAssignmentDetails.customerGroupId = null; // only used for search screens
		caseAssignmentDetails.productId = supportCase.ProductId;
		caseAssignmentDetails.GetProductGroupsForProduct();
		caseAssignmentDetails.productGroupId = null; // only used for search screens
		caseAssignmentDetails.outage = supportCase.CH_Outage__c;

		return caseAssignmentDetails;
	}
	
	// Convert the case fields to rule fields
	@TestVisible 
	private CH_CaseAssignment createProblemSearchCriteria(Case supportCase){
	
		// Determine the level of support
		List<string> levelOfSupports = new List<string>();
		levelOfSupports.add('Expert Support');
	
		CH_CaseAssignment caseAssignmentDetails = new CH_CaseAssignment();
		caseAssignmentDetails.supportCase = supportCase;
		
		// Create search criteria
		caseAssignmentDetails.contract = '';
		caseAssignmentDetails.severity = supportCase.Severity__c;
		//14488
		if(supportCase.CH_Originating_Incident_Number__c != null){
			caseAssignmentDetails.customerId = supportCase.CH_Originating_Incident_Number__r.AccountId;
			caseAssignmentDetails.country = supportCase.CH_Originating_Incident_Number__r.Country__c;
			caseAssignmentDetails.region = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(supportCase.CH_Originating_Incident_Number__r.Country__c);
		}else{
			caseAssignmentDetails.customerId = null;
			caseAssignmentDetails.country = '';
			caseAssignmentDetails.region = '';
		}   
		caseAssignmentDetails.levelOfSupport = levelOfSupports;
		caseAssignmentDetails.customerGroupId = null; // only used for search screens
		caseAssignmentDetails.productId = supportCase.ProductId;
		caseAssignmentDetails.GetProductGroupsForProduct();
		caseAssignmentDetails.productGroupId = null; // only used for search screens
		caseAssignmentDetails.outage = 'No';

		return caseAssignmentDetails;
	}
	
	// Get all workgroup rules that are according to the rule criteria
	@TestVisible 
	private List<CH_Workgroup_Rule__c> getAllWorkgroupRules(CH_CaseAssignment caseAssignmentDetails) {
		
		// Dynamic SOQL doesn't allow complex binding so this is a workaround
		string contract = caseAssignmentDetails.contract;
		string severity = caseAssignmentDetails.severity;
		string region = caseAssignmentDetails.region;
		string country = caseAssignmentDetails.country;
		List<string> levelOfSupport = caseAssignmentDetails.levelOfSupport;
		string customerId = caseAssignmentDetails.customerId;
		List<Id> customerGroupIds = caseAssignmentDetails.customerGroupIds;
		Id customerGroupId = caseAssignmentDetails.customerGroupId;
		string productId = caseAssignmentDetails.productId;
		List<Id> productGroupIds = caseAssignmentDetails.productGroupIds;
		Id productGroupId = caseAssignmentDetails.productGroupId;
		string outage = caseAssignmentDetails.outage;
		
		String sQuery = 'SELECT Id, Name, CH_Workgroup__r.Name, CH_OrderNumber__c, ' + 
			'  CH_Contract__c, CH_Severity__c, CH_Region1__c, ' +
			'  CH_Country1__c, CH_Level_Of_Support__c, CH_Account__r.Name, ' +
			'  CH_Customer_Group__r.Name, CH_Product__r.Name, ' +
			'  CH_Product_Group__r.Name, CH_Outage__c, CH_BusinessHours__c, CH_Workgroup__r.CH_BusinessHours__c ' +
			'FROM CH_Workgroup_Rule__c WHERE';
		if(!String.isBlank(contract)){
			sQuery += ' (CH_Contract__c= :contract OR CH_Contract__c= NULL)AND';
		}
		if (!String.isBlank(severity)){
			sQuery += ' (CH_Severity__c= :severity OR CH_Severity__c= NULL)AND';
		}
		if (!String.isBlank(region)){
			sQuery += ' (CH_Region1__c= :region OR CH_Region1__c= NULL)AND';
		}
		if (!String.isBlank(country) && !country.equals('--None--')){
			sQuery += ' (CH_Country1__c= :country OR CH_Country1__c= NULL)AND';
		}		
		if (levelOfSupport.size() > 0){
			sQuery += ' (CH_Level_Of_Support__c IN :levelOfSupport OR CH_Level_Of_Support__c= NULL)AND';
		} 
		if (!String.isBlank(customerId) && customerGroupIds.size() == 0){
			sQuery += ' ((CH_Account__c= :customerId OR CH_Account__c= NULL) AND CH_Customer_Group__c= NULL) AND';
		}
		if (!String.isBlank(customerId) && customerGroupIds.size() > 0){
			sQuery += ' ((CH_Account__c= :customerId OR CH_Account__c= NULL) AND (CH_Customer_Group__c IN :customerGroupids OR CH_Customer_Group__c = null))AND'; 
		}
		if (String.isBlank(customerId) && !String.isBlank(customerGroupId)){
			sQuery += ' (CH_Customer_Group__c = :customerGroupId OR CH_Customer_Group__c= NULL)AND';
		}
		if (!String.isBlank(productId) && productGroupIds.size() == 0){
			sQuery += ' ((CH_Product__c= :productId OR CH_Product__c= NULL) AND CH_Product_Group__c= Null) AND';
		}
		if (!String.isBlank(productId) && productGroupIds.size() > 0){
			sQuery += ' ((CH_Product__c= :productId OR CH_Product__c= NULL) AND (CH_Product_Group__c IN :productGroupids OR CH_Product_Group__c = null))AND'; 
		}
		if (String.isBlank(productId) && !String.isBlank(productGroupId)){
			sQuery += ' (CH_Product_Group__c = :productGroupid OR CH_Product_Group__c= Null) AND';
		}
		if (outage != 'Any'){
			sQuery += ' (CH_Outage__c = :outage OR CH_Outage__c = \'Any\') AND';
		}
		else {
			sQuery += ' (CH_Outage__c = \'Any\' OR CH_Outage__c = \'Yes\' OR CH_Outage__c = \'No\') AND';
		}
		integer len1 = sQuery.length();
		if(sQuery.endsWithIgnoreCase('AND')){
			sQuery = sQuery.substring(0, len1 - 3);
		}
		if(sQuery.endsWithIgnoreCase('WHERE')){
			sQuery = sQuery.substring(0, len1 - 5);
		}
		sQuery = ''+sQuery+' ORDER BY CH_OrderNumber__c ASC NULLS LAST';
		System.debug('SOQL: ' + sQuery);
		List<CH_Workgroup_Rule__c> lstOfRecords = Database.query(sQuery);
		
		return lstOfRecords;		
	}	
	
	// Get all workgroup members
	// Active Assignment
	//   - Engineers (with rota)
	//   - Incident manager (with rota)
	//   - Escalation
	// Passive assignment 
	//   - Queues
	//   - Escalation
	// Add Case Team Member
	//   - All except queues and hotlines
	@TestVisible
	private List<CH_Workgroup_Member__c> getValidWorkgroupMembers(CH_CaseAssignment caseAssignmentDetails){
		
		Map<string, List<CH_Workgroup_Member__c>> membersPerWorkgroup = new Map<string, List<CH_Workgroup_Member__c>>();
		List<CH_Workgroup_Member__c> rotaWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		List<CH_Workgroup_Member__c> allWorkgroupMembers = new List<CH_Workgroup_Member__c>();
		List<CH_Workgroup_Member__c> tempworkgroupMembers = new List<CH_Workgroup_Member__c>();
		for (CH_Workgroup_Rule__c rule : caseAssignmentDetails.validWorkgroupRules){
			// **** TODO **** Optimize to 1 SOQL 
			if(caseAssignmentDetails.isActiveAssignment){
	tempworkgroupMembers = getWorkgroupMembersActive(rule, caseAssignmentDetails);
	membersPerWorkgroup.put(rule.CH_Workgroup__r.name, tempworkgroupMembers);
	allworkgroupMembers.addAll(tempworkgroupMembers);
			}
			else{
	tempworkgroupMembers = getWorkgroupMembersPassive(rule);
	membersPerWorkgroup.put(rule.CH_Workgroup__r.name, tempworkgroupMembers);
	allworkgroupMembers.addAll(tempworkgroupMembers);
			}			
		}
		// Remove duplicates. For example if 2 rules to the same workgroup are found
		Set<CH_Workgroup_Member__c> tempset = new Set<CH_Workgroup_Member__c>();
		tempset.addAll(allworkgroupMembers);
		allworkgroupMembers.clear();
		allworkgroupMembers.addAll(tempset);
		
		// Filter users based on rota
		if (caseAssignmentDetails.isAvailableAccordingToRota){
			system.debug('xxx Rota');
			rotaWorkgroupMembers = filterWorkgroupMembersByRota(membersPerWorkgroup, allworkgroupMembers, caseAssignmentDetails);
		}
		else {
			system.debug('xxx NORota');
			rotaWorkgroupMembers = allworkgroupMembers;
		}
		
		return rotaWorkgroupMembers;
	}
	
	// Display only the workgroup members that are scheduled to work now
	private List<CH_Workgroup_Member__c> filterWorkgroupMembersByRota(Map<string, List<CH_Workgroup_Member__c>> membersPerWorkgroup, List<CH_Workgroup_Member__c> WorkgroupMembers, CH_CaseAssignment caseAssignmentDetails){
		List<string> rotaRoles = new List<string> {'Incident Manager', 'Engineer'};
		// Get the schedules for all the members that are working now
		List<CH_Workgroup_Event__c> rotaList = [SELECT CH_WorkgroupMember__c, CH_WorkgroupMember__r.CH_Role__c 
			FROM CH_Workgroup_Event__c 
			WHERE 
			CH_StartDate__c <= :system.now() AND CH_EndDate__c >= :system.now() AND
			CH_WorkgroupMember__c in :WorkgroupMembers AND
			CH_WorkgroupMember__r.CH_Role__c in :rotaRoles];
		
		List<CH_Workgroup_Member__c> tempList = new List<CH_Workgroup_Member__c>();
		// Loop through all the workgroup and loop through all the members
		for (List<CH_Workgroup_Member__c> memberList : membersPerWorkgroup.values()) { 
			// Contains hotline
			boolean workgroupContainsHotline = false;
			for (CH_Workgroup_Member__c member : memberList){
	if (member.CH_Role__c == 'Hotline'){
		workgroupContainsHotline = true;
		break;
	}
			}
			
			for (CH_Workgroup_Member__c member : memberList){
	if (member.CH_Role__c == 'Hotline') {
		tempList.add(member);
	}
	// If engineer has a ROTA for now, then add 
	// If the workgroup contains a hotline, all engineers are added regardless of ROTA
	if ((workgroupContainsHotline && member.CH_Role__c == 'Engineer') || (!workgroupContainsHotline && member.CH_Role__c == 'Engineer' && isMemberInRota(member, rotaList))){
		tempList.add(member);
	}
	// If in incident manager has a ROTA for now, then add
	if (member.CH_Role__c == 'Incident Manager' && isMemberInRota(member, rotaList)){
		tempList.add(member);
	}
	// Add all other members where ROTA does not matter
	if (member.CH_Role__c == 'Manager 1' || member.CH_Role__c == 'Manager 2' || member.CH_Role__c == 'Manager 3'){
		tempList.add(member);
	}
			}
		}
		workgroupMembers = tempList;		
	
		return WorkgroupMembers;		
	}	
	
	// Check if a member is part of a rota list
	private boolean isMemberInRota(CH_Workgroup_Member__c member, List<CH_Workgroup_Event__c> rotaList){
		boolean isMemberInRota = false;
		for (CH_Workgroup_Event__c rota : rotaList){
			if (member.id == rota.CH_WorkgroupMember__c){
	isMemberInRota = true; 
			}
		}
		return isMemberInRota;
	}
	
	// Get the assignment type for the case
	@TestVisible
	private Boolean getAssignmentType(CH_CaseAssignment caseAssignmentDetails){		 
		Boolean isActiveAssignment = false;
		Case supportCase = caseAssignmentDetails.supportCase;
		Id problemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		// If a problem Then passive assignment
		if(supportCase.RecordTypeID == problemRecordTypeId){
			isActiveAssignment =false;
		}
		// If an incident Then 
		if(supportCase.RecordTypeID != problemRecordTypeId)
		{
			if (supportCase.Severity__c == 'Critical' &&
	supportCase.CH_SystemRestored__c == null){
	isActiveAssignment =true;
			}
			else if (supportCase.Severity__c == 'Major' && 
		supportCase.CH_Outage__c == 'Yes' &&
		supportCase.CH_SystemRestored__c == null){
		isActiveAssignment =true;
			}			
			else if (((supportCase.Status == 'Created') || (supportCase.Status == 'Assigned')) &&
		isCaseFirstMilestoneWithinTimeRange(supportCase) && isCaseOutsideWorkgroupBusinessHours(caseAssignmentDetails) &&
		isCaseInsideEntitlementBusinessHours(supportCase)){
		isActiveAssignment =true;
			}			
		}
		System.debug('isActiveAssignment = ' + isActiveAssignment);
		return isActiveAssignment;
	}
	
	// Check if the case is created outisde of the workgroup business hours
	// Return true - if the case creation date is outside the workgroup business hours
	//		false - if the case creation date is inside the workgroup business hours
	private boolean isCaseOutsideWorkgroupBusinessHours(CH_CaseAssignment caseAssignmentDetails){
		Boolean isOutsideBusinessHours = false;
		
		List<CH_Workgroup_Rule__c> caseWorkgroupRule = caseAssignmentDetails.validWorkgroupRules;
		if(caseWorkgroupRule.isEmpty()){
			System.debug('isOutsideBusinessHours ' + isOutsideBusinessHours + ' (no workgroup rules)');
			return isOutsideBusinessHours;
		}
		
		if(caseWorkgroupRule[0].CH_Workgroup__r.CH_BusinessHours__c != Null) {
			system.debug('if ' + caseWorkgroupRule[0].CH_Workgroup__r.CH_BusinessHours__c);
			isOutsideBusinessHours = !(BusinessHours.isWithin(caseWorkgroupRule[0].CH_Workgroup__r.CH_BusinessHours__c, caseAssignmentDetails.supportCase.CreatedDate));
		}
		else {
	 isOutsideBusinessHours = true; 
		}
		
		System.debug('isOutsideBusinessHours ' + isOutsideBusinessHours);
		return isOutsideBusinessHours;
	}
	
	// Check if the case creation date is within the entitlement business hours
	private boolean isCaseInsideEntitlementBusinessHours(Case supportTicket){
		Boolean isOutsideBusinessHours = false;

		if(supportTicket.BusinessHoursId != Null) {
			isOutsideBusinessHours = (BusinessHours.isWithin(supportTicket.BusinessHoursId, supportTicket.CreatedDate));
		}
		else {
	 isOutsideBusinessHours = true; 
		}
		
		System.debug('isOutsideBusinessHours ' + isOutsideBusinessHours);
		return isOutsideBusinessHours;
	}
	
	// Check if the first milestone of the case is within a certian time frame
	// Return true - if a milestone is within 121 minutes of the creation date
	//		false - if a milestone is more then 121 minutes from the creation date
	private boolean isCaseFirstMilestoneWithinTimeRange(Case supportTicket){
		integer TIMERANGE = 121;
		boolean withinTimeRange = false;
		
		List<CaseMilestone> caseMilestones = [SELECT TargetResponseInMins  
			 FROM CaseMilestone 
			 WHERE CaseId =:supportTicket.Id 
			 ORDER BY StartDate DESC NULLS LAST LIMIT 1];
		if(caseMilestones.isEmpty()){
			System.debug('withinTimeRange ' + withinTimeRange + ' (no milestones)');
			return withinTimeRange;
		}
		
		// If the first milestone within 120 minutes
		if (caseMilestones[0].TargetResponseInMins < TIMERANGE) {
			withinTimeRange = true;
		}
		
		System.debug('withinTimeRange ' + withinTimeRange);
		return withinTimeRange;
	}	
	
	
	
	// ******* TO Refactor *******
	
	
	// This method is used to get workgroup members active assignment.
	public static List <CH_Workgroup_Member__c> getWorkgroupMembersActive(CH_Workgroup_Rule__c workgroupRuleObj, CH_CaseAssignment caseAssignmentDetails)
	{
		List<string> roles = new List<string> {'Engineer', 'Manager 1', 'Manager 2',
			  'Manager 3', 'Hotline','Incident Manager'};
				
		if (caseAssignmentDetails.supportCase.CH_Reassignment__c){
	 roles.add('Expert');					
		}
		if (caseAssignmentDetails.isCaseTeamAssignment){
	 roles.add('Expert'); 
	 roles.add('Case Manager'); 
		}
							
		List <CH_Workgroup_Member__c> WorkgroupMembers = new List <CH_Workgroup_Member__c>();
		if(workgroupRuleObj!= Null){
			Id workgroupId= workgroupRuleObj.CH_Workgroup__c;
			WorkgroupMembers = [SELECT Id,CH_RoleOrder__c , CH_User__r.Email,
		CH_User__r.MobilePhone, CH_Queue__c, CH_User__r.Name,
		CH_Role__c ,CH_Workgroup__r.Name,CH_Workgroup__r.CH_Workgroup_Instructions__c,
		CH_Workgroup__r.CH_Level_Of_Support__c, CH_Workgroup__r.Owner.FirstName, CH_Workgroup__r.Owner.LastName, CH_HotlinePhone__c,
		(SELECT CH_SupportType__c 
		 FROM Workgroup_Rotas__r 
		 WHERE CH_StartDate__c <= :system.now() AND CH_EndDate__c >= :system.now() 
		 Limit 1), 
		CH_User__r.CH_LastCaseAssigned__c 
		FROM CH_Workgroup_Member__c 
		where CH_Workgroup__c=:workgroupId 
		AND CH_Role__c in :roles 
		Order by CH_RoleOrder__c, CH_User__r.Email];
		}
		return WorkgroupMembers;
	}
	
	// This method is used to get workgroup members passive.
	public static List <CH_Workgroup_Member__c> getWorkgroupMembersPassive(CH_Workgroup_Rule__c workgroupRuleObj)
	{
		List <CH_Workgroup_Member__c> WorkgroupMembers = new List <CH_Workgroup_Member__c>();
		if(workgroupRuleObj!= Null){
			Id workgroupId= workgroupRuleObj.CH_Workgroup__c;
			WorkgroupMembers = [SELECT Id, CH_Queue__c, CH_User__r.Name, CH_Role__c, 
		CH_Workgroup__r.Name, CH_Workgroup__r.CH_Workgroup_Instructions__c, 
		CH_Workgroup__r.CH_Level_Of_Support__c, CH_Workgroup__r.Owner.FirstName, 
		CH_Workgroup__r.Owner.LastName, CH_Workgroup__r.CH_Owner_MobilePhone__c,
		CH_User__r.MobilePhone, CH_User__r.Email
		FROM CH_Workgroup_Member__c 
		where CH_Workgroup__c=:workgroupId AND CH_Role__c in ('Queue', 'Manager 1', 'Manager 2',
			   'Manager 3')
		Order by CH_RoleOrder__c, CH_Queue__c]; 
		}
		return WorkgroupMembers;
	}
	
	
	public static Id problemOwnerRoleId {
	  get {  
		if(problemOwnerRoleId == null) problemOwnerRoleId = [SELECT Id FROM CaseTeamRole WHERE Name = 'Problem Owner' limit 1].Id;
		return problemOwnerRoleId;
	  }
		set { problemOwnerRoleId = value; }	  
   }
	
	// Cannot insert members if they already exist
   public static void performTeamMembersInsert(list<CaseTeamMember> members){
		set<Id> parentIds = new set<Id>();
		set<Id> teamRoleIds = new set<Id>();
		set<Id> memberIds = new set<Id>();
		map<string, CaseTeamMember> keyToMember = new map<string, CaseTeamMember>();
		for(CaseTeamMember member : members){
			parentIds.add(member.parentId);
			memberIds.add(member.memberId);
			teamRoleIds.add(member.teamRoleId);
			keyToMember.put((string)member.parentId + (string)member.memberId + (string)member.teamRoleId, member);
		}
		for(CaseTeamMember member : [SELECT parentId, teamRoleId, memberId FROM CaseTeamMember WHERE parentId IN : parentIds AND memberId IN :memberIds AND teamRoleId IN :teamRoleIds]){
			string key = (string)member.parentId + (string)member.memberId + (string)member.teamRoleId;
			if(keyToMember.containsKey(key)) keyToMember.remove(key);
		}
	System.debug(Logginglevel.ERROR, '#performTeamMembersInsert: ' + keyToMember.size() + ':' + keyToMember);
		if(!keyToMember.isEmpty()) insert keyToMember.values();
   }
	
	public static void performTeamMembersDelete(list<CaseTeamMember> members){
		list<CaseTeamMember> memToDelete = new list<CaseTeamMember>();
		set<Id> parentIds = new set<Id>();
		set<Id> teamRoleIds = new set<Id>();
		set<Id> memberIds = new set<Id>();
		map<string, CaseTeamMember> keyToMember = new map<string, CaseTeamMember>();
		for(CaseTeamMember member : members){
			parentIds.add(member.parentId);
			memberIds.add(member.memberId);
			teamRoleIds.add(member.teamRoleId);
			keyToMember.put((string)member.parentId + (string)member.memberId + (string)member.teamRoleId, member);
		}
		for(CaseTeamMember member : [SELECT parentId, teamRoleId, memberId FROM CaseTeamMember WHERE parentId IN : parentIds AND memberId IN :memberIds AND teamRoleId IN :teamRoleIds]){
			string key = (string)member.parentId + (string)member.memberId + (string)member.teamRoleId;
			if(keyToMember.containsKey(key)) memToDelete.add(member);
		}
		System.debug(Logginglevel.ERROR, '#performTeamMembersDelete: ' + memToDelete.size() + ':' + memToDelete);
		if(!memToDelete.isEmpty()) delete memToDelete;
   }
	
	
	public static map<Id, list<Id>> getAllProblemIncidents(set<Id> problemIds){
		map<Id, list<Id>> problemIncidents = new map<Id, list<Id>>();
		for(Case aCase : [SELECT CH_Problem__c FROM Case WHERE CH_Problem__c IN : problemIds]){
			if(problemIncidents.containsKey(aCase.CH_Problem__c)){
	problemIncidents.get(aCase.CH_Problem__c).add(aCase.Id);
			}else{
	problemIncidents.put(aCase.CH_Problem__c, new list<Id>{aCase.Id});
			}
		}
		system.debug(Logginglevel.ERROR, '###getAllProblemIncidents:' + problemIncidents.size() +  ':' + problemIncidents); 
		return problemIncidents;
	}
	
	
	public static void handleProblemOwnerOnIncidents(map<Id, Case> oldCases, map<id, Case> newCases){
		
		list<CaseTeamMember> memebersToCreate = new list<CaseTeamMember>();
		list<CaseTeamMember> memebersToDelete = new list<CaseTeamMember>();
		map<Id, Id> problemNewOwner = new map<Id,Id>();
		map<Id, Id> problemOldOwner = new map<Id,Id>();
		set<Id> allProblems = new set<Id>();
		
		if(oldCases != null && !oldCases.isEmpty() && newCases != null && !newCases.isEmpty()){
			for(Case aCase : newCases.values()){
	if(aCase.CH_RecordTypeCheck__c){
		if(aCase.CH_RecordTypeDevName__c == 'CH_Problem'){
			if(aCase.OwnerId != (oldCases.get(aCase.Id)).OwnerId){
				if(aCase.OwnerId.getSobjectType() == Schema.User.SObjectType){
		problemNewOwner.put(aCase.Id, aCase.OwnerId);
				}
				if((oldCases.get(aCase.Id)).OwnerId.getSobjectType() == Schema.User.SObjectType){
		problemOldOwner.put(aCase.Id, (oldCases.get(aCase.Id)).OwnerId);
				}
			}
		}
		else{
			if(aCase.CH_Problem__c != (oldCases.get(aCase.Id)).CH_Problem__c){
				if(aCase.CH_Problem__c != null && ((Id)aCase.CH_IncidentProblemOwner__c).getSobjectType() == Schema.User.SObjectType ){
		memebersToCreate.add(new CaseTeamMember(ParentId = aCase.Id, MemberId = aCase.CH_IncidentProblemOwner__c, TeamRoleId = problemOwnerRoleId));
				}
				if((oldCases.get(aCase.Id)).CH_Problem__c != null && ((Id)(oldCases.get(aCase.Id).CH_IncidentProblemOwner__c)).getSobjectType() == Schema.User.SObjectType){
		memebersToDelete.add(new CaseTeamMember(ParentId = aCase.Id, MemberId = oldCases.get(aCase.Id).CH_IncidentProblemOwner__c, TeamRoleId = problemOwnerRoleId));
				}
			}
		}
	}
			}
			
			
			if(!problemNewOwner.isEmpty()) allProblems.addAll(problemNewOwner.keySet());
			if(!problemOldOwner.isEmpty()) allProblems.addAll(problemOldOwner.keySet());
			if(!allProblems.isEmpty()){
	map<Id, list<Id>> allProblemIncidents = getAllProblemIncidents(allProblems);
	if(!problemNewOwner.isEmpty()){
		for(Id probId : problemNewOwner.keySet()){
			if(allProblemIncidents.containsKey(probId)){
				for(Id incidentId : allProblemIncidents.get(probId)){
		memebersToCreate.add(new CaseTeamMember(ParentId = incidentId, MemberId = problemNewOwner.get(probId), TeamRoleId = problemOwnerRoleId));
				}
			}
		}
	}
	if(!problemOldOwner.isEmpty()){
		for(Id probId : problemOldOwner.keySet()){
			if(allProblemIncidents.containsKey(probId)){
				for(Id incidentId : allProblemIncidents.get(probId)){
		memebersToDelete.add(new CaseTeamMember(ParentId = incidentId, MemberId = problemOldOwner.get(probId), TeamRoleId = problemOwnerRoleId));
				}
			}	   
		}
	}
			}
			
			
			system.debug(Logginglevel.ERROR, '###memebersToCreate:' + memebersToCreate.size() +  ':' + memebersToCreate);
			system.debug(Logginglevel.ERROR, '###getAllProblemIncidents:' + memebersToDelete.size() +  ':' + memebersToDelete);
			if(!memebersToCreate.isEmpty()) performTeamMembersInsert(memebersToCreate);
			if(!memebersToDelete.isEmpty()) performTeamMembersDelete(memebersToDelete);
		}
	}
	
	
	private map<string, CaseTeamRole> getAllcaseTeamRoleByName(){
		map<string, CaseTeamRole> cRoles = new map<string, CaseTeamRole>();
		for(CaseTeamRole cRole : [SELECT Name FROM CaseTeamRole] ){
			cRoles.put(cRole.Name, cRole);
		}
		return cRoles;
	}
	
	private map<id, set<Id>> getAllcaseTeamMembersByCase(list<Id> caseIds){
		
		map<id, set<Id>> allTheSmoke = new map<id, set<Id>>();
		for(CaseTeamMember cMem : [SELECT ParentId, MemberId, TeamRoleId FROM CaseTeamMember WHERE ParentId IN :caseIds]){
			if(allTheSmoke.containsKey(cMem.ParentId)) allTheSmoke.get(cMem.ParentId).add(cMem.MemberId);
			else allTheSmoke.put(cMem.ParentId, new set<Id>{cMem.MemberId});
		}
		return allTheSmoke;
	}
	
	// Improved method, (not using SOQL inside)
	private CaseTeamMember addWorkgroupMemberToCaseTeam(Case updatedCase, CH_Workgroup_Member__c member, map<string, CaseTeamRole> caseTeamRoleByName, string caseTeamRole, map<id, set<Id>> caseTeamMembersByCase){
		
		CaseTeamMember caseTeamMember;
		
		if(caseTeamRoleByName.containsKey(caseTeamRole)){
			CaseTeamRole role = caseTeamRoleByName.get(caseTeamRole);
			caseTeamMember = new CaseTeamMember();
			caseTeamMember.ParentId = updatedCase.Id;
			caseTeamMember.MemberId = member.CH_User__c;
			caseTeamMember.TeamRoleId = role.Id;
		}
		// Not possible to insert the same user as a member more than once!
		if(caseTeamMemberExists(caseTeamMember.ParentId, caseTeamMember.MemberId, caseTeamMembersByCase)){
			caseTeamMember = null;
		}
		return caseTeamMember; 
	}
	
	public static boolean caseTeamMemberExists(Id ParentId, Id MemberId, map<id, set<Id>> caseTeamMembersByCase){
		
		if(caseTeamMembersByCase.containsKey(ParentId)){
			if(caseTeamMembersByCase.get(ParentId) != null && caseTeamMembersByCase.get(ParentId).contains(MemberId))
			return true;
		}
		return false;
		
	}
	
	
}