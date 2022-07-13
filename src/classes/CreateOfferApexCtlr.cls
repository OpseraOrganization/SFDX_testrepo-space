/****************************************
* Class Name : CreateOfferApexCtlr
* Created Date: 27.9.2018
* Created By : Accenture
* Last Modified by: Accenture
* Description :
* Test Class: CreateOfferApexCtlr
*****************************************/
public without sharing class CreateOfferApexCtlr {
	/********************
*Method Name: getOppty
*Parameter:
*Description:  Fetching all Opportunity Name,Id
*******************/
	@AuraEnabled
	public static Opportunity getOppty(String opptyId)
	{
		Opportunity opp;
		try{
			opp = [Select Id,Name,G4_Planned_Date__c,G3_Planned_Date__c,G5_Planned_Date__c,Account.Customer_Compliance__c, Gate_3_Bypass_no_offer_support__c, Business_Type__c from Opportunity
	   where id=: opptyId limit 1];
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.GETOPPTY);
		}
		return opp;
	}

	/********************
*Method Name: getAllLeadBG
*Parameter:
*Description:  Fetching all Lead BG of OfferTeam
*******************/
	@AuraEnabled
	public static Map<string,string> getAllLeadBGOfOfferTeam(){
		Map<string,string> leadBGMap = new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOfferApexCtlr.getFieldMapOfferTeam();
		system.debug('fieldMap'+fieldMap);
		list<Schema.PicklistEntry> values = fieldMap.get('BG__c').getDescribe().getPickListValues();
		system.debug('values'+values);
		// Add these values to the selectoption list.
		for (Schema.PicklistEntry val : values)
		{
			leadBGMap.put(val.getLabel(), val.getValue());
		}
		return leadBGMap;
	}
	/********************
*Method Name: saveOffer
*Parameter:
*Description:  Save Offer Record
*******************/
	@AuraEnabled
	public static String saveOffer(Offer__c offerRec)
	{
		String offerId ;
		/** SF Ticket#: 01825599 code block starts**/
		String duplicateOffer ;
		Offer__c offerReceived = offerRec;
		List<String> offerNumber = new List<String>();
		List<Offer__c> existingOffer = new List<Offer__c>();

		existingOffer = [SELECT Id, Name, Offer_Number__c FROM Offer__c WHERE Opportunity__c =: offerRec.Opportunity__c];
		System.Debug('existingOffer>>> '+existingOffer);

		if(existingOffer.size() >0){
			for(Offer__c offr : existingOffer){
	offerNumber.add(offr.Offer_Number__c);
			}
		}

		List<Offer__c> newOfferList = new List<Offer__c>();

		newOfferList = [SELECT Id, Name, Offer_Number__c FROM Offer__c WHERE Offer_Number__c IN: offerNumber];

		Map<String ,Offer__c> mapOfferNumber = new Map<String,Offer__c>();
		if(newOfferList.size()>0){
			for(Offer__c off: newOfferList){
	mapOfferNumber.put(off.Offer_Number__c ,off);
			}
		}

		if(existingOffer.size() >0){
			for(Offer__c offr : existingOffer){
	if(mapOfferNumber.containsKey(offr.Offer_Number__c)){
		duplicateOffer = 'Offer Number already Exists';
	}
			}
		}
		try{
			Database.SaveResult savedResults = Database.insert(offerRec, false);

			/** SF Ticket#: 01825599 code block ends**/
			Boolean someFailure = false;
			if (!savedResults.isSuccess()) {
	someFailure = true;
	for (Database.Error err: savedResults.getErrors()) {
		offerId = err.getMessage();
		System.debug(GlobalConstants.ERROR_OCCURED + err.getStatusCode() + ' : ' + err.getMessage());
		System.debug(GlobalConstants.FIELDS_AFFECTED_BY_ERROR + err.getFields());
	}
			}
			if (!someFailure) {
	System.debug('Offer added successfully.');
	offerId = offerRec.id;
			}
		}catch (Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR,GlobalConstants.SAVEOFFER );
		}
		return offerId;
	}

	/********************
*Method Name: saveOppty
*Parameter:
*Description:  Save Opportunity Record
*******************/
	@AuraEnabled
	public static string saveOppty(Opportunity opptyRec)
	{
		String opptyId ;
		try{
			Database.SaveResult updateResult = Database.update(opptyRec, false);
			Boolean someFailure = false;
			if (!updateResult.isSuccess()){
	someFailure = true;
	for (Database.Error err : updateResult.getErrors()){
		opptyId = err.getMessage();
		System.debug(GlobalConstants.ERROR_OCCURED + err.getStatusCode() + ' : ' + err.getMessage());
		System.debug(GlobalConstants.FIELDS_AFFECTED_BY_ERROR + err.getFields());
	}
			}
			if (!someFailure) {
	System.debug('Oppty updated successfully.');
	opptyId = 'Success';
			}

		}catch (Exception ex){ ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR,GlobalConstants.SAVEOFFER );  }
		return opptyId;
	}


	/********************
*Method Name: saveOfferTeam
*Parameter:
*Description:  Save Offer Team Record
*******************/
	@AuraEnabled
	public static void saveOfferTeam(String wrapperList, Id newOfferId)
	{
		system.debug('wrapperList'+wrapperList);
		system.debug('newOfferId>>>'+newOfferId);
		Type idArrType = Type.forName(GlobalConstants.LIST_WRAPPER);
		List<OfferTeamWrapper> wrapperFinalList = new List<OfferTeamWrapper>();
		List <Offer_Team__c> offerTeamList ;
		Offer_Team__c offerTeamVar;

		Set<Id> offTeamSetId = new  Set<Id>();
		try{
			wrapperFinalList = (List<OfferTeamWrapper>) JSON.deserialize(wrapperList, idArrType);
			for(OfferTeamWrapper wrapperVar : wrapperFinalList){
	if( (wrapperVar.offerTeamId != '' && wrapperVar.offerTeamId != null) ){
		offTeamSetId.add(wrapperVar.offerTeamId);
	}
			}
			Map<Id,Offer_Team__c> offerTeamMap = new Map<Id,Offer_Team__c>([Select Id, Team_Member_Role__c, Name__r.Name,
							Offer_Access__c, Additional_Team_Role__c, BG__c,
							Name__c, Name__r.IsActive,name__r.NSA_Compliant__c
							from Offer_Team__c where id IN :offTeamSetId]);
			if(wrapperFinalList != Null){
	offerTeamList = new List<Offer_Team__c>();
	for(OfferTeamWrapper wrapperVar : wrapperFinalList){
		if((wrapperVar.teamRole != Null || wrapperVar.teamRole != '') && (wrapperVar.offerTeamId == '' || wrapperVar.offerTeamId == null)){
			system.debug('wrapperVar.offerTeamId ' + wrapperVar.offerTeamId);
			system.debug('wrapperVar'+wrapperVar);
			offerTeamVar = new Offer_Team__c();
			offerTeamVar.Offer_Access__c = wrapperVar.offerAccess;
			offerTeamVar.Team_Member_Role__c = wrapperVar.teamRole;
			offerTeamVar.Name__c = wrapperVar.userId;
			offerTeamVar.Offer__c = newOfferId;
			offerTeamVar.Additional_Team_Role__c = wrapperVar.additionalTeamRole;
			offerTeamVar.BG__c = wrapperVar.leadBG;
			offerTeamList.add(offerTeamVar);
		}else{
			Offer_Team__c offerTeamQuerry = offerTeamMap.get(wrapperVar.offerTeamId);
			offerTeamQuerry.Offer_Access__c = wrapperVar.offerAccess;
			offerTeamQuerry.Team_Member_Role__c = wrapperVar.teamRole;
			offerTeamQuerry.Name__c = wrapperVar.userId;
			offerTeamQuerry.Additional_Team_Role__c = wrapperVar.additionalTeamRole;
			offerTeamQuerry.BG__c = wrapperVar.leadBG;
			offerTeamList.add(offerTeamQuerry);
		}
	}
	system.debug('offerTeamList'+offerTeamList);
	Schema.SobjectField ftoken = Schema.getGlobalDescribe().get('Offer_Team__c').getDescribe().fields.getMap().get('Id');
	Database.UpsertResult[] upsertResults = Database.upsert(offerTeamList,ftoken, false);
	for(Database.UpsertResult res : upsertResults)
	{
		system.debug('res.getErrors()'+res.getErrors());
	}
	Boolean someFailure = false;
	for(Database.UpsertResult result : upsertResults){
		if (!result.isSuccess()) {
			someFailure = true;
			for (Database.Error err: result.getErrors()) {
				System.debug(GlobalConstants.ERROR_OCCURED + err.getStatusCode() + ' : ' + err.getMessage());
				System.debug(GlobalConstants.FIELDS_AFFECTED_BY_ERROR + err.getFields());
			}
		}
		if (!someFailure) {
			System.debug('New offer Team inserted/updated successfully');
		}
	}
			}
		}catch (Exception ex)  {  ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.SAVEOFFERTEAM); }
	}

	/********************
*Method Name: getAllTeamMemberRole
*Parameter:
*Description:  Fetching all Team Role from picklist
*******************/
	@AuraEnabled
	public static Map<string,string> getAllTeamMemberRole(){
		Map<string,string> teamMemberRole= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOfferApexCtlr.getFieldMapOfferTeam();
		system.debug('fieldMap'+fieldMap);
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.TeamMember).getDescribe().getPickListValues();
			system.debug('values'+values);
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry val : values)
			{
	if(val.isActive())
		teamMemberRole.put(val.getLabel(), val.getValue());
			}
		}catch (Exception ex){ ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.SAVEOFFERTEAM);   }
		return teamMemberRole;
	}

	/********************
*Method Name: getAllTeamMemberRoleMap
*Parameter:
*Description:  Fetching all Team Role from picklist
*******************/
	@AuraEnabled
	public static Map<string,string> getAllTeamMemberRoleMap(){
		Map<string,string> teamMemberRole= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOfferApexCtlr.getFieldMapOfferTeam();
		system.debug('fieldMap'+fieldMap);
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.TeamMember).getDescribe().getPickListValues();
			system.debug('values'+values);
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry val : values)
			{
	if(val.isActive())
		teamMemberRole.put(val.getValue(), val.getLabel());
			}
		}catch (Exception ex) {   ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.SAVEOFFERTEAM);   }
		return teamMemberRole;
	}

	/********************
*Method Name: getAllAdditionalTeamMemberRole
*Parameter:
*Description:  Fetching all Additional Team Role from picklist
*******************/
	@AuraEnabled
	public static Map<string,string> getAllAdditionalTeamMemberRole(){
		Map<string,string> additionalTeamMemberRole= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOfferApexCtlr.getFieldMapOfferTeam();
		system.debug('fieldMap'+fieldMap);
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.AdditionalTeamMember).getDescribe().getPickListValues();
			system.debug('values'+values);
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry val : values)
			{
	if(val.isActive())
		additionalTeamMemberRole.put(val.getLabel(), val.getValue());
			}
		}catch (Exception ex) { ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.SAVEOFFERTEAM);   }
		return additionalTeamMemberRole;
	}

	/********************
*Method Name: getAllAccessLevel
*Parameter:
*Description:  Fetching all Access level from picklist
*******************/
	@AuraEnabled
	public static Map<string,string> getAllAccessLevel(){
		Map<string,string> accessLevel = new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOfferApexCtlr.getFieldMapOfferTeam();
		system.debug('fieldMap'+fieldMap);
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.Access_Level).getDescribe().getPickListValues();
			system.debug('values'+values);
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry val : values)
			{
	if(val.isActive())
		accessLevel.put(val.getLabel(), val.getValue());
			}
		}catch (Exception ex){ ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.SAVEOFFERTEAM);  }
		return accessLevel;
	}

	/********************
*Method Name: getFieldMap
*Parameter:
*Description:  common exection in fetching picklist values of Offer Team
*******************/
	private static map<String, Schema.SObjectField> getFieldMapOfferTeam(){
		// Get the object type of the SObject.
		Schema.sObjectType objType = Offer_Team__c.getSObjectType();
		system.debug('objType'+objType);
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		system.debug('objDescribe'+objDescribe);
		// Get a map of fields for the SObject
		return objDescribe.fields.getMap();
	}

	/********************
*Method Name: fetOpptyTeam
*Parameter:
*Description:  Fetching all Team Members of Opportunity
*******************/
	@AuraEnabled
	public static List<OfferTeamWrapper> getOpptyTeam(String opptyId)
	{
		List<OpportunityTeamMember> oppTeam;
		List<OfferTeamWrapper> wrapperList = new List<OfferTeamWrapper>();
		OfferTeamWrapper wrapper;
		// Get the object type of the SObject.
		Schema.sObjectType objType = OpportunityTeamMember.getSObjectType();
		system.debug('objType'+objType);
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		Map<string,string> teamMemberRole= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		system.debug('fieldMap'+fieldMap);
		list<Schema.PicklistEntry> values = fieldMap.get(GLobalConstants.TEAMMEMBERROLE).getDescribe().getPickListValues();
		try{

			system.debug('values'+values);
			// Add these values to the select option list.
			for (Schema.PicklistEntry val : values)
			{
	teamMemberRole.put(val.getValue(), val.getLabel());
			}
			oppTeam = [Select Id,UserId,User.IsActive,User.Name,User.NSA_Compliant__c,
		TeamMemberRole,Additional_Team_Role__c, OpportunityAccessLevel,
		opportunity.OwnerId, opportunity.Owner.IsActive, opportunity.Owner.NSA_Compliant__c, opportunity.Owner.Name
		from OpportunityTeamMember
		where OpportunityId=: opptyId
		LIMIT :Limits.getLimitQueryRows() - Limits.getQueryRows()];
			system.debug('oppTeam'+oppTeam);
			if(oppTeam != Null)
			{
	for(OpportunityTeamMember opp : oppTeam)
	{
		wrapper = new OfferTeamWrapper();
		wrapper.teamRole = opp.TeamMemberRole;
		if(teamMemberRole.containsKey(opp.TeamMemberRole))
			wrapper.teamRoleLabel = teamMemberRole.get(opp.TeamMemberRole);
		else
			wrapper.teamRoleLabel = opp.TeamMemberRole;
		if(opp.OpportunityAccessLevel == GlobalConstants.ALL_ACCESS_OFFER || opp.OpportunityAccessLevel == GlobalConstants.EDIT_ACCESS )
			wrapper.offerAccess = GlobalConstants.READ_EDIT_ACCESS;
		else
			wrapper.offerAccess = GlobalConstants.READ_ONLY_ACCESS;
		wrapper.additionalTeamRole = opp.Additional_Team_Role__c;
		wrapper.userId = opp.UserId;
		wrapper.isActiveUser = opp.User.IsActive;
		wrapper.nsaCompliant = opp.User.NSA_Compliant__c ;
		wrapper.userName = opp.User.Name;
		wrapper.oppOwnerActive = opp.opportunity.Owner.IsActive;
		wrapper.oppOwnerId = opp.opportunity.OwnerId;
		wrapper.oppOwnerNSA = opp.opportunity.Owner.NSA_Compliant__c;
		wrapper.oppOwnerName = opp.opportunity.Owner.Name;
		wrapper.isKeyRole = false;
		wrapperList.add(wrapper);
	}
	wrapperList = manageKeyRoles(wrapperList, teamMemberRole);
			}
		}catch(Exception ex) { ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR,GlobalConstants.GETOPPTYTEAM);   }
		System.debug(wrapperList);
		return wrapperList;
	}

	private static List<OfferTeamWrapper> manageKeyRoles(List<OfferTeamWrapper> offerTeamMembersList, Map<string,string> teamMemberRole)
	{
		//Get key roles
		String keyRoles = Label.Offer_Team_Key_Roles;
		List<String> keyRolesList = keyRoles.split(';');
		Set<String> existingPrimKeyRoles = new Set<String>();
		Map<String, OfferTeamWrapper> existingAltKeyRolesMap = new Map<String, OfferTeamWrapper>();
		for (String keyRole : keyRolesList)
		{
			Boolean hasAlternateKeyRole = false;
			for (OfferTeamWrapper offTeamMember : offerTeamMembersList)
			{
	//Check for Existing Key Roles in offer team added from opp team
	if(offTeamMember != null && offTeamMember.teamRoleLabel != null && offTeamMember.teamRoleLabel.equals(keyRole))//Check if we already have a Bid Manager assigned
	{
		existingPrimKeyRoles.add(keyRole);
		if(hasAlternateKeyRole)
		{
			existingAltKeyRolesMap.remove(keyRole);//Remove from the list because we don't need to create this member from alternate role member
		}
		break;
	}
	else if( offTeamMember != null && offTeamMember.additionalTeamRole != null && offTeamMember.additionalTeamRole.contains(keyRole) && !hasAlternateKeyRole)//Check if we already have a Bid Manager assigned
	{
		hasAlternateKeyRole = true;
		existingAltKeyRolesMap.put(keyRole,offTeamMember);
	}
			}
		}

		//Assign new Offer team Members if needed (Key Roles)
		List<OfferTeamWrapper> missingOfferKeyRoles = new List<OfferTeamWrapper>();
		for (String keyRole : keyRolesList)
		{
			if (!existingPrimKeyRoles.contains(keyRole) )//Does not exists in opp team has primary role so we need to create new offer team member (not copied from opp team)
			{
	OfferTeamWrapper wrapper = new OfferTeamWrapper();
	wrapper.teamRole = keyRole;
	if(teamMemberRole != null && teamMemberRole.containsKey(keyRole))
	{
		wrapper.teamRoleLabel = teamMemberRole.get(keyRole);
	}
	else
	{
		wrapper.teamRoleLabel = keyRole;
	}
	wrapper.offerAccess = GlobalConstants.READ_EDIT_ACCESS;
	if( existingAltKeyRolesMap.containsKey(keyRole) )//Elect offer team member that is  as an alternate role as "the Bid Manager"
	{
		OfferTeamWrapper offerMemberWithAlt = existingAltKeyRolesMap.get(keyRole);
		wrapper.userId = offerMemberWithAlt.UserId;
		wrapper.isActiveUser = offerMemberWithAlt.isActiveUser;
		wrapper.nsaCompliant = offerMemberWithAlt.additionalTeamRole.contains(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE);
		wrapper.userName = offerMemberWithAlt.additionalTeamRole;
	}
	else
	{
		if(keyRole.equals(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE) && offerTeamMembersList.size() > 0)////elect opportunity owner has the Bid Manager in team offer
		{
			wrapper.userId = offerTeamMembersList[0].oppOwnerId;
			wrapper.isActiveUser = offerTeamMembersList[0].oppOwnerActive;
			wrapper.nsaCompliant = offerTeamMembersList[0].oppOwnerNSA;
			wrapper.userName = offerTeamMembersList[0].oppOwnerName;
		}
		else
		{
			wrapper.userId = '';
			wrapper.isActiveUser = true;//Avoids showing message on front-end "User is inactive"
			wrapper.nsaCompliant = false;
			wrapper.userName = '';
		}
	}
	if(wrapper.userId == null || wrapper.userId.equals(''))
	{
		wrapper.isKeyRole = true;//Allow that offer is created without a user assigned by removing the lines from the list before save.

	}
	else
	{
		wrapper.isKeyRole = false;
	}
	wrapper.offerAccess = GlobalConstants.READ_EDIT_ACCESS;
	if( existingAltKeyRolesMap.containsKey(keyRole) )//Elect offer team member that is  as an alternate role as "the Bid Manager"
	{
		OfferTeamWrapper offerMemberWithAlt = existingAltKeyRolesMap.get(keyRole);
		wrapper.userId = offerMemberWithAlt.UserId;
		wrapper.isActiveUser = offerMemberWithAlt.isActiveUser;
		wrapper.nsaCompliant = offerMemberWithAlt.additionalTeamRole.contains(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE);
		wrapper.userName = offerMemberWithAlt.additionalTeamRole;
	}
	else
	{
		if(keyRole.equals(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE) && offerTeamMembersList.size() > 0)////elect opportunity owner has the Bid Manager in team offer
		{
			wrapper.userId = offerTeamMembersList[0].oppOwnerId;
			wrapper.isActiveUser = offerTeamMembersList[0].oppOwnerActive;
			wrapper.nsaCompliant = offerTeamMembersList[0].oppOwnerNSA;
			wrapper.userName = offerTeamMembersList[0].oppOwnerName;
		}
		else
		{
			wrapper.userId = '';
			wrapper.isActiveUser = true;//Avoids showing message on front-end "User is inactive"
			wrapper.nsaCompliant = false;
			wrapper.userName = '';
		}
	}
	if(wrapper.userId == null || wrapper.userId.equals(''))
	{
		wrapper.isKeyRole = true;//Allow that offer is created without a user assigned by removing the lines from the list before save.

	}
	else
	{
		wrapper.isKeyRole = false;
	}
	System.debug(wrapper);
	missingOfferKeyRoles.add(wrapper);
			}
		}
		missingOfferKeyRoles.addAll(offerTeamMembersList); //Make sure missing key roles appear at the top
		return missingOfferKeyRoles;//Not realy only missig key roles, but all roles
	}
	/********************
*Method Name: getOfferTeam
*Parameter:
*Description:  Get all Team Members of Offer Team
*******************/
	@AuraEnabled
	public static List<OfferTeamWrapper> getOfferTeam(String offerId){
		List<Offer_Team__c> offerTeamList = new List<Offer_Team__c>();
		List<OfferTeamWrapper> wrapperList = new List<OfferTeamWrapper>();

		try{

			offerTeamList = [Select Id, Team_Member_Role__c, Name__r.Name,
		Offer_Access__c, Additional_Team_Role__c, BG__c,
		Name__c, Name__r.IsActive,name__r.NSA_Compliant__c
		from Offer_Team__c where offer__c =: offerId
		LIMIT :Limits.getLimitQueryRows() - Limits.getQueryRows()];
			system.debug('offerTeamList'+offerTeamList);
			if(offerTeamList != Null)
			{
	for(Offer_Team__c offerTeam : offerTeamList)
	{
		OfferTeamWrapper wrapper = new OfferTeamWrapper();
		wrapper.teamRole = offerTeam.Team_Member_Role__c;
		wrapper.teamRoleLabel = offerTeam.Team_Member_Role__c;
		wrapper.offerTeamId = offerTeam.id;
		wrapper.offerAccess = offerTeam.Offer_Access__c;
		wrapper.additionalTeamRole = offerTeam.Additional_Team_Role__c;
		wrapper.userId = offerTeam.Name__c;
		wrapper.isActiveUser = offerTeam.Name__r.IsActive;
		wrapper.nsaCompliant = offerTeam.Name__r.NSA_Compliant__c ;
		wrapper.userName = offerTeam.Name__r.Name;
		wrapper.leadBG = offerTeam.BG__c;
		wrapper.isKeyRole = false;
		wrapperList.add(wrapper);
	}
	wrapperList = manageKeyRoles(wrapperList, null);
			}
		}catch(Exception ex) { ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR,GlobalConstants.GETOFFERTEAM);   }
		System.debug(wrapperList);
		return wrapperList;
	}

	/********************
*Method Name: deleteRowFromList
*Parameter:
*Description:  Delete Offer Team Record given the ID
*******************/
	@AuraEnabled
	public static void deleteRowFromList(String offerTeamId){
		Offer_Team__c doomedOfferTeam = [SELECT Id, Name
				 FROM Offer_Team__c
				 WHERE id =: offerTeamId];
		try {
			delete doomedOfferTeam;
		} catch (DmlException e) {
			// Process exception here
		}

	}

	/********************
*Method Name: getAllUserList
*Parameter:
*Description:  Fetching all User
*******************/
	@AuraEnabled
	public static List<User> getAllUserList(String keyWord)
	{
		List<User> userList;
		Set<String> crmProfiles = new Set<String>();
		String searchKey = GlobalConstants.WILDCARD_SEARCH + keyWord + GlobalConstants.WILDCARD_SEARCH;
		try{
			for(CRM_Profiles__mdt crmProfileObj: [Select Label from CRM_Profiles__mdt]){
	crmProfiles.add(crmProfileObj.Label);
			}
			userList = [Select Id,IsActive,Name,NSA_Compliant__c from User
			where Name like: searchKey and Profile.Name IN: crmProfiles and
			IsActive =: true LIMIT :GlobalConstants.QUERRY_LIMIT_MAX_USER_PER_OFFER];
			system.debug('userList'+userList);
		}catch(Exception ex){ ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR,GlobalConstants.GETALLUSERLIST); }
		return userList;
	}

	/********************
*Method Name: getUser
*Parameter:
*Description:  Fetching selected User
*******************/
	@AuraEnabled
	public static User getUser(String userId)
	{
		User userList;
		try{
			userList = [Select Id,Name,NSA_Compliant__c from User where Id=: userId LIMIT 1];
			system.debug('userList'+userList);
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.GETUSER );
		}
		return userList;
	}


	/**********************************************************************************************************************
* author: Accenture
* Date: Feb-2019
* Param: String offTeamList, Id opptyId
* Return: List<OfferTeamWrapper>
* Description: Pricing Manager Validation in Offer Team
* High Level Process :
**********************************************************************************************************************/
	@AuraEnabled
	public static List<OfferTeamWrapper> offerTeamPrMValidation ( String offTeamList, Id opptyId, id recordId)
	{
		system.debug('offTeamList'+offTeamList);
		set<String> orgLevel = new set<String>();
		Map<String,String> sRmap = new Map<String, String>();
		Type idArrType = Type.forName(GlobalConstants.LIST_WRAPPER);
		List<OfferTeamWrapper> wrapperFinalList = new List<OfferTeamWrapper>();
		List<OfferTeamWrapper> pricingManagerList = new List<OfferTeamWrapper>();
		try
		{
			if(opptyId == null && recordId != null){
	Offer__c off = [Select id, Opportunity__r.id FROM Offer__c WHERE Id =: recordId];
	opptyId = off.Opportunity__r.id;
			}
			wrapperFinalList = (List<OfferTeamWrapper>) JSON.deserialize(offTeamList, idArrType);
			system.debug('wrapperFinalList'+wrapperFinalList);
			Opportunity opp = [SELECT Org_L2__c,Org_L3__c,Org_L4__c,Org_L5__c,Org_L6__c,Org_L7__c
		  FROM Opportunity
		  WHERE Id =: opptyId AND SWx_Upsell_Proposal__c = null
		  limit 1];
			{
	orgLevel.add(opp.Org_L2__c);
	orgLevel.add(opp.Org_L3__c);
	orgLevel.add(opp.Org_L4__c);
	orgLevel.add(opp.Org_L5__c);
	orgLevel.add(opp.Org_L7__c);
	orgLevel.add(opp.Org_L7__c);
			}
			if(orgLevel.size() > 0){
	for(Sales_Role__c sR : [SELECT User__c,Organisation__c FROM Sales_Role__c WHERE Role_Code__c LIKE :System.Label.NF_PrM_Role AND
				Organisation__c IN: orgLevel LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		sRmap.put(sR.User__c, sR.Organisation__c);
	}
			}

			for(OfferTeamWrapper wrapper : wrapperFinalList )
			{
	System.debug('wrapper::> '+wrapper);
	if((!sRmap.isEmpty() && !sRmap.containsKey(wrapper.userId) )|| sRmap.isEmpty())
	{
		pricingManagerList.add(wrapper);
	}
			}
			system.debug('pricingManagerList'+pricingManagerList);
		}
		Catch (Exception ex){ ExceptionHandler.addException(ex, GlobalConstants.OFFER_TEAM_HELPER_CLASS, GlobalConstants.OFFERTEAMPRMVALIDATION); }
		return pricingManagerList;
	}
}