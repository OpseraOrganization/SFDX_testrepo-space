/**
 * @name	NF_TL_UpdateRequestRCode
 * @author  Jamal Rida
 * @since   Dec 29, 2016
 * @desc	This class used to serve as Trigger Logic for implementing roleName/Code/Organization in the ARRequests.
 * @history
 */
public with sharing class NF_TL_UpdateRequestRCode {
	@TestVisible  private Static  	List<user> backup_Admin =new List<user>();
	@TestVisible  private Static  	Integer count = 0;
	@TestVisible  private Static  	Integer total_count = 0;
	@TestVisible  private Static  	List<Apttus_Approval__Approval_Request__c> parentReqUpdate = new list<Apttus_Approval__Approval_Request__c>();
	@TestVisible  public static 	Map<String,String> mapRoleCodeHierCode = new Map<String,String>{'2' => 'NSNA', '3' => 'NSNB', '4' => 'NSNC', '5' => 'NSND', '6' => 'NSNE', '7' => 'NSNG'} ;

	/**
	*   @desc   : Method used to update approvalRuleRequest Fields based on the appropriate AssigneeRule Table
	*   @param  : List<Apttus_Approval__Approval_Request__c>
	*/
	public static void updateRequestRcodeM(List<Apttus_Approval__Approval_Request__c> appRequests){
		Savepoint sp = Database.setSavepoint();
		try{
			Set<String> assignedUsers = new set<String>();
			Set<String> arulesSet = new set<String>();
			Set<Id> opportunityIds = new Set<Id>();
			Map<String,Apttus_Approval__Approval_Request__c> appRequestSubStepMap = new Map<String,Apttus_Approval__Approval_Request__c>();
			//Fetch  assignedTo Users + ApprovalRuleAssignees Name
			for(Apttus_Approval__Approval_Request__c request : appRequests){
	arulesSet.add(request.Apttus_Approval__SubstepName__c);
	appRequestSubStepMap.put(request.Apttus_Approval__SubstepName__c, request);
	assignedUsers.add(request.Apttus_Approval__Assigned_To_Id__c);
	opportunityIds.add(request.Apttus_Approval__Related_Opportunity__c);
			}
			system.debug('arulesSet:'+arulesSet);
			set<String> orgsSet = new set<String>();
			set<String> bgSet = new set<String>();
			set<String> codesSet = new set<String>();
			Map<String, Set<String>> arAssigneeToOrgndCodeMap = new Map<String, Set<String>>();
			Map<String, String> arAssigneeToType = new Map<String, String>();
			Map<String, String> arAssigneeValue = new Map<String, String>();
			Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([Select Id,  Lead_BG__c, Lead_BU__c, OwnerID, Org_L2__c, Org_L3__c, Org_L4__c, Org_L5__c, Org_L6__c, Org_L7__c from Opportunity where Id in :opportunityIds]);

			//Loop Through assignees and construct : Org, roles, Map for each assigneeName relatedOrg+Code
			for(Apttus_Approval__ApprovalRuleAssignee__c arAssignee :[SELECT Id,Apttus_Approval__AssigneeValue__c, Apttus_Approval__AssigneeDescription__c,Name FROM Apttus_Approval__ApprovalRuleAssignee__c WHERE Name in :arulesSet ]){
	String code='';

	List<String> codList = new List<String>();
	List<String> org_codList = new List<String>();
	List<String> bg_List = new List<String>();

	String bg_Val = '';
	String bu_Val = '';

	System.debug('Asignee Rule ID --->'+arAssignee.Id);

	//Map for unique AssigneeNAme to Description which can be : Approver, Validator, Stackholder to be used for ValidatorComments.
	if(!arAssigneeToType.containsKey(arAssignee.Name) && String.isNotBlank(arAssignee.Apttus_Approval__AssigneeDescription__c))
		arAssigneeToType.put(arAssignee.Name, arAssignee.Apttus_Approval__AssigneeDescription__c.subString(arAssignee.Apttus_Approval__AssigneeDescription__c.lastIndexOf(',')+1, arAssignee.Apttus_Approval__AssigneeDescription__c.length()));
	if(!arAssigneeValue.containsKey(arAssignee.Name) && String.isNotBlank(arAssignee.Apttus_Approval__AssigneeValue__c))
		arAssigneeValue.put(arAssignee.Name, arAssignee.Apttus_Approval__AssigneeValue__c);

	//Check wether the Record has a valid value in  the field assigneeValue, if yes then split.
	if(arAssignee.Apttus_Approval__AssigneeValue__c != null && arAssignee.Apttus_Approval__AssigneeValue__c.contains('AND'))
	{
		codList = arAssignee.Apttus_Approval__AssigneeValue__c.split('AND');
		org_codList = codList[1].split('OR');
		if(codlist.size()== 4 && codList[3].contains('OR'))
			bg_List = codList[3].split('OR');
	}
	system.debug('org_codList:'+org_codList);
	system.debug('codList:'+codList);
	//Get the Organization Level from Salesrole, then get the value from the opportunity by Dynamic Apex.
	Apttus_Approval__Approval_Request__c request = appRequestSubStepMap.containsKey(arAssignee.Name) ? appRequestSubStepMap.get(arAssignee.Name) : null;

	if(request != null && request.Apttus_Approval__Related_Opportunity__c != null && !codList.isEmpty())
	{
		code = codList[0].subString(codList[0].lastIndexOf('%')+2, codList[0].length()-2).remove(' ');
		Opportunity opptyAR = opportunityMap.get(request.Apttus_Approval__Related_Opportunity__c);

		if(!bg_List.isEmpty())
		{
			bg_Val = opptyAR.Lead_BG__c;
			bgSet.add(bg_Val);
			if(opptyAR.Lead_BU__c != null)
			{
	bu_Val = opptyAR.Lead_BU__c;
	bgSet.add(bu_Val);
			}
		}
		else if(codList.size() == 4)
		{
			bg_Val = codList[3].subString(codList[3].lastIndexOf('=')+2,codList[3].IndexOf(')')-1);
			bgSet.add(bg_Val);
		}

		//Map for Unique Assignee name to (Code + BG) and (Code + BU)
		if(!arAssigneeToOrgndCodeMap.containsKey(arAssignee.Name) && String.isNotBlank(code) ){
			arAssigneeToOrgndCodeMap.put(arAssignee.Name,new Set<String>{(code+bg_Val).touppercase(),(code+bu_Val).touppercase()});
		}

		if(!org_codList.isEmpty())
		{
			for(String orgCode : org_codList)
			{
	String org1 = orgCode.subString(orgCode.lastIndexOf(':')+1, orgCode.lastIndexOf('\'')).remove(' ');
	orgsSet.add(String.valueOf(opptyAR.get(org1)));
	String roleCodeLevel = orgCode.subString(orgCode.lastIndexOf('L')+1, orgCode.lastIndexOf('_')-1).remove(' ');
	if(mapRoleCodeHierCode.containsKey(roleCodeLevel))
		codesSet.add(mapRoleCodeHierCode.get(roleCodeLevel)+code);
			}
		}
	}
			}
			system.debug('code:'+codesSet);
			system.debug('OrsSet:'+orgsSet);
			system.debug('bgSet:'+bgSet);
			Map<String, Sales_role__c> rolendOrgToSalesroleMap = new Map<String, Sales_role__c>();

			for(Sales_role__c srole :[ SELECT Id, User__c, BG__c, role_Name__c, Organisation__c, role_Code__c FROM Sales_role__c
	 	WHERE (BG__c = :bgSet or BG__c = '') AND role_Code__c in :codesSet AND Organisation__c in :orgsSet AND User__c in :assignedUsers ]
	  ){
	//Map for unique Code+Organization to the relevant record srole.
	string role = srole.role_Code__c;
	String role_Map_Key ='';
	if(srole.BG__c!=null)
		role_Map_Key = role.subString(role.lastIndexOf('_'))+srole.BG__c;
	else
		role_Map_Key = role.subString(role.lastIndexOf('_'));
	if(!rolendOrgToSalesroleMap.containsKey(role_Map_Key.touppercase())){
		rolendOrgToSalesroleMap.put(role_Map_Key.touppercase(), srole);
		system.debug('srole:'+srole);
	}
	  }

			//Loop throught historyRequest list and update the relevant data.
			for(Apttus_Approval__Approval_Request__c request : appRequests){
	Opportunity opptyAR = opportunityMap.get(request.Apttus_Approval__Related_Opportunity__c);
	Set<String> roleBGVal = new Set<String>();
	if(arAssigneeToOrgndCodeMap.get(request.Apttus_Approval__SubstepName__c) != null )
		roleBGVal = arAssigneeToOrgndCodeMap.get(request.Apttus_Approval__SubstepName__c);

	for(String option : roleBGVal){
		if(rolendOrgToSalesroleMap.containsKey(option)){
			Sales_role__c srole = rolendOrgToSalesroleMap.get(option);
			if(srole != null){
	request.NF_Organization_Level__c = srole.Organisation__c;
	request.NF_role_Code__c = srole.role_Code__c;
	request.NF_role_Name__c = srole.role_Name__c;
	request.Related_Sales_role__c = srole.ID;
	system.debug('sroleCode: '+ srole.role_Code__c);
			}
			break;
		}
	}

	if(arAssigneeToType.get(request.Apttus_Approval__SubstepName__c) != null){
		System.debug('---->'+arAssigneeToType.get(request.Apttus_Approval__SubstepName__c));
		request.NF_Assignee_Type__c = arAssigneeToType.get(request.Apttus_Approval__SubstepName__c);
	}
	if(arAssigneeValue.get(request.Apttus_Approval__SubstepName__c) != null){
		request.NF_Assignee_Value__c = arAssigneeValue.get(request.Apttus_Approval__SubstepName__c);
	}
	if (request.Apttus_Approval__Assigned_To_Type__c<>Null && request.Apttus_Approval__Assigned_To_Type__c.equalsignorecase(GlobalConstants.QUEUE)) {
		request.NF_Assignee_Type__c = GlobalConstants.STAKEHOLDER_INFORMATION;
	}
	if(request.Apttus_Approval__Assigned_To_Type__c<>Null && request.Apttus_Approval__Assigned_To_Id__c<>NUll && request.Apttus_Approval__Notify_Only__c<>True && request.Apttus_Approval__Send_Email__c<>True && request.Apttus_Approval__Assigned_To_Id__c.equalsignorecase(opptyAR.OwnerID))
		request.NF_Assignee_Type__c = GlobalConstants.STAKEHOLDER_INFORMATION;
			}

		}catch(DmlException e){
			if (sp != null) Database.rollback(sp);
			system.debug('###Exception from NF_TL_UpdateRequestRCode : '+e.getMessage() + 'Stack Trace : '+e.getStackTraceString());
			throw e;
		}
	}

	/**
	*   @desc   : Method used to update  the Approval Date field
	*   @param  : List<Apttus_Approval__Approval_Request__c> Map<ID,Apttus_Approval__Approval_Request__c>
	*/
	public static void CopieApprovalStatus(List<Apttus_Approval__Approval_Request__c> appRequests, map<Id,Apttus_Approval__Approval_Request__c> MapOld){
		list<Apttus_Approval__Approval_Request__c> ApprovalToUpdate = new list<Apttus_Approval__Approval_Request__c>();
		set<Id> opportunityIds = new set<Id>();
		String ApprovalStatus;
		for(Apttus_Approval__Approval_Request__c app : appRequests){
			if( (app.Apttus_Approval__Approval_Status__c == 'Approved' || app.Apttus_Approval__Approval_Status__c =='Cancelled' || app.Apttus_Approval__Approval_Status__c =='Rejected')  &&
	  app.Apttus_Approval__Approval_Status__c != MapOld.get(app.id).Apttus_Approval__Approval_Status__c && app.Apttus_Approval__Assigned_To_Name__c == null){
	ApprovalStatus=app.Apttus_Approval__Approval_Status__c;
	if(app.Apttus_Approval__Related_Opportunity__c != null)
		opportunityIds.add(app.Apttus_Approval__Related_Opportunity__c);
	  }
		}
		if(!opportunityIds.isEmpty()){
			for(Apttus_Approval__Approval_Request__c App : [select Id,Tech_Approval_Date__c,Tech_Status__c from Apttus_Approval__Approval_Request__c where Apttus_Approval__Related_Opportunity__c IN: OpportunityIds ]){
	App.Tech_Approval_Date__c = datetime.now();
	App.Tech_Status__c = ApprovalStatus;
	ApprovalToUpdate.add(App);
			}
		}
		Try{
			if(!ApprovalToUpdate.isEmpty())
	Database.update(ApprovalToUpdate,False);
		}catch(Exception e){
			system.debug('###Exception from NF_TL_UpdateRequestRCode : '+e.getMessage() );
		}
	}

	Public Static Void UpdateValidatorStatus(List<Apttus_Approval__Approval_Request__c> appRequests)
	{
		set<Id> ParentReqIds = new set<Id>();
		if(!GlobalConstants.UPDATE_VALIDATOR_REQUEST_STATUS){

			for(Apttus_Approval__Approval_Request__c app : appRequests){
	if(app.NF_Assignee_Type__c == 'Validator')
		ParentReqIds.add(app.Apttus_Approval__ParentRequestId__c);
	system.debug('ParentReqIds : ' + ParentReqIds);
			}
			if(!ParentReqIds.isEmpty()){
	for(Apttus_Approval__Approval_Request__c App_req : [select Id, Validator_Status__c,Validator_Request_Status__c from Apttus_Approval__Approval_Request__c where Apttus_Approval__ParentRequestId__c IN: ParentReqIds and NF_Assignee_Type__c = 'Validator']){
		Total_Count = total_count + 1;
		IF(App_req.Validator_Status__c != null)
			count = count + 1;
		system.debug('Count : ' + count);
		system.debug('Total_Count : ' + total_count);
	}
	for(Apttus_Approval__Approval_Request__c App : [select Id, Validator_Status__c,Validator_Request_Status__c  from Apttus_Approval__Approval_Request__c where Id IN: ParentReqIds]){
		if(count == total_count && total_count != null)
		{
			App.Validator_Request_Status__c = true;
			parentReqUpdate.add(App);
		}
		else if(count != total_count && App.Validator_Request_Status__c == true && total_count != null)
		{
			App.Validator_Request_Status__c = false;
			parentReqUpdate.add(App);
		}
	}
			}
			Try{
	if(!parentReqUpdate.isEmpty()){
		Database.update(parentReqUpdate,False);
	}
	GlobalConstants.UPDATE_VALIDATOR_REQUEST_STATUS=true;
			}catch(Exception e){
	system.debug('###Exception from NF_TL_UpdateRequestRCode : '+e.getMessage() );
			}
		}
	}

	 /**
	*   @desc   : Method used to Update the non NSA users to NSA Backup user
	*   @param  : List<Apttus_Approval__Approval_Request__c>
	*/
	public static void updateAssignee_NSA(List<Apttus_Approval__Approval_Request__c> appRequests)
	{
		try{
			String Cust_compliance;
			for(Apttus_Approval__Approval_Request__c request : appRequests)
			{
	if(request.Apttus_Approval__Related_Opportunity__c != null)
		Cust_compliance = Request.Oppty_Cust_compliance__c;
	System.debug('Oppty_Cust_compliance__c---->'+Request.Oppty_Cust_compliance__c);
			}

			If(Cust_compliance<>NUll && Cust_compliance == 'US_Govern' )
			{
	if(backup_Admin.isEmpty())
		backup_Admin = [ Select Id from User where Name =: Label.NF_NSA_BAckupAdmin ];

	for(Apttus_Approval__Approval_Request__c request : appRequests)
	{
		if(request.Approver_User__c != null &&!request.Asigneed_User_NSA_Check__c && !backup_Admin.isEmpty() )
		{
			request.Apttus_Approval__Assigned_To_Id__c = backup_Admin[0].id;
			request.Apttus_Approval__Assigned_To_Name__c = Label.NF_NSA_BAckupAdmin;
			request.OwnerId = backup_Admin[0].id;

		}
	}
			}
		}
		catch(Exception Exp)
		{
			System.debug('updateAssignee_NSA Method Exception #####'+Exp.getMessage());
		}
	}

	/*****************************
	*Method Name: updateValidatorAndStakeholderStatus
	*Description: this method work for update the validators status to "Cancelled" after approver rejected.
	*Support Ticket:11885
	*Parameters: Approval Request List
	*******************************/
	public static void updateValidatorAndStakeholderStatus(List<Apttus_Approval__Approval_Request__c> appRequests, map<Id,Apttus_Approval__Approval_Request__c> MapOld){
		try{
			Set<Id> approverReqOpptyIds = new Set<Id>();
			Set<Id> appReqToCancelIds = new Set<Id>();

			for(Apttus_Approval__Approval_Request__c app : appRequests){
	if(app.NF_Assignee_Type__c == 'Approver'&& app.Apttus_Approval__Approval_Status__c == GlobalConstants.REJECTED && MapOld.get(app.id).Apttus_Approval__Approval_Status__c != GlobalConstants.REJECTED){
		approverReqOpptyIds.add(app.Apttus_Approval__Object_Id__c);
	}
			}
			if(!approverReqOpptyIds.isEmpty()){

	List<Apttus_Approval__Approval_Request__c> appRequestsList = [SELECT Id,Apttus_Approval__Object_Id__c, NF_Assignee_Type__c, Apttus_Approval__Approval_Status__c FROM Apttus_Approval__Approval_Request__c WHERE Apttus_Approval__Object_Id__c in :approverReqOpptyIds and (NF_Assignee_Type__c = 'Validator' OR NF_Assignee_Type__c ='Stakeholder for Information')];
	system.debug('appRequestsList>>>>>>'+appRequestsList.size()+appRequestsList);

	for(Apttus_Approval__Approval_Request__c currentAppRequests:appRequestsList){
		//currentAppRequests.Apttus_Approval__Notify_Only__c = false;
		appReqToCancelIds.add(currentAppRequests.Id);
	}

	if(appRequestsList.size()>0){
		//update appRequestsList;
		updateAppReqStatusCancelled(appReqToCancelIds);
	}
			}
		}
		catch(Exception ex){
			System.debug('updateValidatorAndStakeholderStatus Method Exception #####'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.NF_TL_UPDATE_REQUESTRCODE, 'updateValidatorAndStakeholderStatus');
		}
	}


	@future(callout=true)
	public static void updateAppReqStatusCancelled(Set<Id> appReqIds){
		List<Apttus_Approval__Approval_Request__c> appRequestsList = new List<Apttus_Approval__Approval_Request__c>();
		for(Id arId : appReqIds){
			appRequestsList.add(new Apttus_Approval__Approval_Request__c(Id=arId, Apttus_Approval__Approval_Status__c = GlobalConstants.CANCEL, Apttus_Approval__Notify_Only__c = true));
		}
		update appRequestsList;
	}

	/*****************************
	*Method Name: updateDateApporovedFieldOnValidator
	*Description: this method work for update the validators's DateApproved to null after submit for approval. And change it to Approval time after approved
	*Support Ticket:12596
	*Parameters: Approval Request List
	*******************************/
		// Update DateApproved Field to Null when approval request is not valiated by validators
	public static void updateDateApporovedFieldOnValidator(List<Apttus_Approval__Approval_Request__c> appRequests){
		for(Apttus_Approval__Approval_Request__c apr:appRequests){
			System.debug('====>Status:'+apr.Apttus_Approval__Approval_Status__c+' Assignee:'+apr.NF_Assignee_Type__c +' Validator Status:'+ apr.Validator_Status__c +' Tech Status:'+apr.Tech_Status__c==null);
			if('Notified'.equalsignorecase(apr.Apttus_Approval__Approval_Status__c) && 'Validator'.equalsignorecase(apr.NF_Assignee_Type__c) && apr.Validator_Status__c==null && apr.Tech_Status__c==null){
	apr.Apttus_Approval__DateApproved__c = null;
			}
			if('Notified'.equalsignorecase(apr.Apttus_Approval__Approval_Status__c) && 'Validator'.equalsignorecase(apr.NF_Assignee_Type__c) &&  'Approved'.equalsignorecase(apr.Tech_Status__c)){
	apr.Apttus_Approval__DateApproved__c = Datetime.now();
			}
		}
	}

}