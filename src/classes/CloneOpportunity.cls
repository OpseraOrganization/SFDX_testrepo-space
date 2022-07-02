/*******************************
Class Name: CloneOpportunity
Created by: Accenture
Created Date: 20th June 2017
Last modified by: Accenture
Last modified date:
Description: Requirement 1507: Sales Process: Opportunity Cloning
*******************************/
public with sharing class CloneOpportunity   {
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	private static final Id directReadOnlyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectReadOnlyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_INDIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id preOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PREOPPTY_RECORD_TYPE).getRecordTypeId();//CO Dev Team - US 137 END
	
	@AuraEnabled
	/*******************************
Method Name: getCloneOpp
Description: Method invoked from lightning component
Parameters: Opportunity record id
*******************************/
	public static String getCloneOpp(String recordId) {
		return CloneOpportunity.cloneOpp(recordId, null);
	}
	
	/*******************************
Method Name: CloneOpp
Description: Requirement 1507: Sales Process: Opportunity Cloning
Parameters: Opportunity record id
renewalYears: if this parameter is not null, than the clone is a Care Renewal (ft-241). If not it is a regular clone.
*******************************/
	public static String cloneOpp(String recordId, Integer renewalYears) {
		system.debug('recordId>>>>>>>>> ' + recordId);
		// Initialize setup variables
		String returnMessage;
		Schema.DescribeSObjectResult sc = Opportunity.sObjectType.getDescribe();
		Boolean isCreateable = sc.isCreateable();
		opportunity opty = new Opportunity();
		system.debug('isCreateable' + isCreateable);
		Id profileId = UserInfo.getProfileId();
		Set<Id> profileIdSet = new Set<Id>();
		String objectName = GlobalConstants.OBJECT_OPPORTUNITY;
		String query = GlobalConstants.SELECT_QUERY;
		String sRecordType;
		Boolean isAutomaticRenewal = renewalYears == null ? false : true;
		Boolean someFailure = false;
		Boolean careRenewalfailure = false;
		Opportunity oppToRenewWithRelObj;
		
		try {
			if(recordId != null) {
	
	List<Id> profiles = System.Label.Clone_Restricted_Profiles.Split(GlobalConstants.COMMA);
	profileIdSet.addAll(profiles);
	
	if (isCreateable && (!profileIdSet.contains(profileId))) {
		
		opty = [select RecordTypeId, Business_Type__c from opportunity where id=:recordId Limit 1];
		if(opty.RecordTypeId.equals(directReadOnlyRecordTypeId) || opty.RecordTypeId.equals(inDirectReadOnlyRecordTypeId)){
			system.debug('You cannot clone the read only opportunity');
			returnMessage = system.label.ReadOnlyCloneDenied;
		} if(opty.Business_Type__c == GlobalConstants.FAST_TRACK_OPP_TYPE && !isAutomaticRenewal){
			returnMessage = 'Fast Track Opportunities cannot be cloned';
		} else {
			if(opty.RecordTypeId.equals(directRecordTypeId) ) {
				sRecordType = GlobalConstants.Direct;
			} else if(opty.RecordTypeId.equals(inDirectRecordTypeId)){
				sRecordType = GlobalConstants.Indirect;
			} else if((opty.RecordTypeId.equals(preOppRecordTypeId))){
				sRecordType = GlobalConstants.PREOPPORTUNITY;
			}
			
			query+=GlobalConstants.SPACE;
			List<String> fieldsAPI = new List<String>();
			for(cloneObject__c opptyField : [SELECT Field_API__c  FROM cloneObject__c
					 where Object__c =: GlobalConstants.OBJECT_OPPORTUNITY and Record_Type__c =: sRecordType LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				fieldsAPI.add(opptyField.Field_API__c);
			}
			
			query += String.join(fieldsAPI, ',');
			if(isAutomaticRenewal && !fieldsAPI.contains('Care_Contract_End_Date__c'))
			{
				query += ', Care_Contract_End_Date__c ';
			}
			query += GlobalConstants.SOQLFROM + objectName + GlobalConstants.SOQLWHERE + recordId + GlobalConstants.SOQLLIMIT;
			Opportunity opp = database.query(query);
			
			Opportunity newOpp = opp.clone(false, true, false, false);
			newOpp.Name = opp.Name + GlobalConstants.CLONEOPTYNAME;
			if(!opty.RecordTypeId.equals(preOppRecordTypeId)){
				newOpp.Amount = 0;
				newOpp.G3_Planned_Date__c = system.today();
				newOpp.G4_Planned_Date__c = system.today();
				newOpp.G5_Planned_Date__c = system.today();
				newOpp.G6_Planned_Date__c = system.today();
			} else {
				newOpp.StageName = GlobalConstants.BUSINESS_DEVELOPMENT;
			}
			
			//ft-241 - Automatic Renewal (not a regular clone)
			if(isAutomaticRenewal)
			{
				if(opp.Care_Contract_End_Date__c == null)
				{
		careRenewalfailure = true;
		returnMessage = 'Automatic Renewal was not possible because the original opportunity does not have a "Care Contract End Date".';
				}
				else
				{
		oppToRenewWithRelObj = fetchRelatedRecords(opp.Id, System.Label.CRM_OIF_Cat_To_Clone_Renew.split(';'), System.Label.CRM_Care_OIF_PL.split(';'));
		newOpp.Name = oppToRenewWithRelObj.Name + GlobalConstants.RENEWAL_OPP_SUFFIX;//Override cloned Name for Renewal Name
		newOpp.Care_Renewal__c = True;
		newOpp.Care_Contract_End_Date__c = setDateNoPast(oppToRenewWithRelObj.Care_Contract_End_Date__c.addYears(renewalYears));
		newOpp.G3_Planned_Date__c = setDateNoPast(oppToRenewWithRelObj.Care_Contract_End_Date__c.addDays(1).addMonths(-6));//First we add one day because the next contract starts one day after the previous ends.
		newOpp.G4_Planned_Date__c = setDateNoPast(oppToRenewWithRelObj.Care_Contract_End_Date__c.addDays(1).addMonths(-5));
		newOpp.G5_Planned_Date__c = setDateNoPast(oppToRenewWithRelObj.Care_Contract_End_Date__c.addDays(1).addDays(-30));
		newOpp.CloseDate = newOpp.G5_Planned_Date__c;
		newOpp.Reference_Care_Opportunity__c = oppToRenewWithRelObj.Id;//System.Label.Organization_URL + opp.Id;
		newOpp.CLM_Contract_Request_Type__c = GlobalConstants.RENEWAL_CONTRACT_TYPE;
		if(opty.Business_Type__c == GlobalConstants.FAST_TRACK_OPP_TYPE)
			newOpp.Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
		if(oppToRenewWithRelObj.R00N50000001Xl0FEAS.isEmpty())
		{
			newOpp.CLM_Existing_Contract_Reference__c = oppToRenewWithRelObj.CLM_Existing_Contract_Reference__c;
		}
		else
		{
			newOpp.CLM_Existing_Contract_Reference__c = oppToRenewWithRelObj.R00N50000001Xl0FEAS[0].Id;
			
		}
				}
			}
			Database.SaveResult savedResults;
			if (!careRenewalfailure)
			{
				savedResults = Database.insert(newOpp, false);
				if (!savedResults.isSuccess() )
				{
		someFailure = true;
		for (Database.Error err: savedResults.getErrors())
		{
			System.debug(GlobalConstants.ERROR_OCCURED + err.getStatusCode() + ' : ' + err.getMessage());
			System.debug(GlobalConstants.FIELDS_AFFECTED_BY_ERROR + err.getFields());
			returnMessage = err.getMessage();
		}
				}
			}
			else
			{
				someFailure = true;
			}
			
			
			if (!someFailure)
			{
				System.debug('newopp Opportunity inserted added successfully');
				returnMessage = newOpp.id;
				cloneOpportunityTeam(newOpp.id, recordId, sRecordType);
				if((opty.RecordTypeId.equals(preOppRecordTypeId)))
				{
		cloneProgramFlags(newOpp.id, recordId);
				}
				//ft-241 - Automatic Renewal (not a regular clone)
				if(isAutomaticRenewal)
				{
		cloneContacts(newOpp.Id, oppToRenewWithRelObj.OpportunityContactRoles);
		cloneCompetitors(newOpp.Id, oppToRenewWithRelObj.Competitors__r);
		cloneOIF(newOpp, oppToRenewWithRelObj, oppToRenewWithRelObj.Order_Intake_Forecast_del__r);
				}
			}
		}
	} else {
		returnMessage = system.label.AccessDenied;
	}
			}
			system.debug('returnMessage' + returnMessage);
			return returnMessage;
		} catch(DmlException ex) {
			system.debug('Print Exception' + ex);
			returnMessage = ex.getDmlMessage(0);
			ExceptionHandler.addException(ex, GlobalConstants.CLONE_OPPORTUNITY, GlobalConstants.GET_CLONE_OPPTY);
			return returnMessage;
		} catch (Exception e) {
			system.debug('Print Exception' + e);
			returnMessage = e.getMessage();
			ExceptionHandler.addException(e, GlobalConstants.CLONE_OPPORTUNITY, GlobalConstants.GET_CLONE_OPPTY);
			return returnMessage;
		}
	}
	/*******************************
Method Name: cloneOpportunityTeam
Description: Requirement 1507: Sales Process: Opportunity Cloning
Parameters: old Opportunity id , new Opportunity id
*******************************/
	public static void cloneOpportunityTeam(ID newOpptyId, string oldOpptyID, string sRecordType) {
		List < OpportunityTeamMember > opportunityTeamMemberList = new List < OpportunityTeamMember > ();
		List < OpportunityTeamMember > newOpportunityTeamMemberList = null;
		OpportunityTeamMember opportunityTeamMemberObj = new OpportunityTeamMember();
		Id currentUserId = UserInfo.getUserId() ;
		String accManager = System.Label.ACC_MANAGER_TRICON_SCO ;
		String solManager = GlobalConstants.SOLUTION_MANAGER;
		Set<String> additionalRole = new Set<String>();
		String roles;
		try {
			opportunityTeamMemberList = [SELECT UserId, User.IsActive, Additional_Team_Role__c, Name, OpportunityAccessLevel, OpportunityId, TeamMemberRole, Opportunity.OwnerId
				 FROM OpportunityTeamMember where OpportunityId = :oldOpptyID and TeamMemberRole != NULL and User.IsActive = True LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
			if (!opportunityTeamMemberList.isEmpty()) {
	system.debug('Inside if offerteamlist');
	newOpportunityTeamMemberList = new List < OpportunityTeamMember > ();
	for (OpportunityTeamMember obj: opportunityTeamMemberList) {
		if(currentUserId != obj.UserId){
			Boolean roleOfInterest = false;
			if(obj.TeamMemberRole != accManager && sRecordType != GlobalConstants.PREOPPORTUNITY){
				roleOfInterest = TRUE;
			}else if(sRecordType.equals(GlobalConstants.PREOPPORTUNITY) && obj.TeamMemberRole != solManager){
				roleOfInterest = TRUE;
			}
			if(roleOfInterest){
				opportunityTeamMemberObj = new OpportunityTeamMember();
				opportunityTeamMemberObj.Additional_Team_Role__c = obj.Additional_Team_Role__c;
				opportunityTeamMemberObj.UserId = obj.UserId;
				opportunityTeamMemberObj.OpportunityId = newOpptyId;
				opportunityTeamMemberObj.OpportunityAccessLevel = obj.OpportunityAccessLevel;
				opportunityTeamMemberObj.TeamMemberRole = obj.TeamMemberRole;
				newOpportunityTeamMemberList.add(opportunityTeamMemberObj);
			}
		} else if(currentUserId == obj.UserId && obj.Additional_Team_Role__c != Null){
			opportunityTeamMemberObj = new OpportunityTeamMember();
			roles = obj.Additional_Team_Role__c;
			String checkRole = accManager;
			if(sRecordType == GlobalConstants.PREOPPORTUNITY){
				checkRole = solManager;
			}
			if(roles.contains(checkRole)){
				additionalRole = new Set<String>(roles.split(';'));
				additionalRole.remove(checkRole);
				opportunityTeamMemberObj.Additional_Team_Role__c = String.join(new List<String>(additionalRole), GlobalConstants.SEMICOLON);
			}else
				opportunityTeamMemberObj.Additional_Team_Role__c = obj.Additional_Team_Role__c;
			opportunityTeamMemberObj.UserId = obj.UserId;
			opportunityTeamMemberObj.OpportunityId = newOpptyId;
			opportunityTeamMemberObj.TeamMemberRole = checkRole;
			opportunityTeamMemberObj.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
			newOpportunityTeamMemberList.add(opportunityTeamMemberObj);
		}
	}
	
	system.debug('Final newOpportunityTeamMemberList' + newOpportunityTeamMemberList);
	if (!newOpportunityTeamMemberList.isEmpty()) {
		Database.SaveResult[] savedResults = Database.insert(newOpportunityTeamMemberList, false);
		Boolean someFailure = false;
		for (Database.SaveResult sr: savedResults) {
			if (!sr.isSuccess()) {
				someFailure = true;
				for (Database.Error err: sr.getErrors()) {
		System.debug(GlobalConstants.ERROR_OCCURED + err.getStatusCode() + ' : ' + err.getMessage());
		System.debug(GlobalConstants.FIELDS_AFFECTED_BY_ERROR + err.getFields());
				}
			}
		}
		if (!someFailure) {
			System.debug('Opty Team added successfully');
		}
	}
	system.debug('OptyTeam Insert successful');
	createOfferTeam(newOpptyId, newOpportunityTeamMemberList);
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.CLONE_OPPORTUNITY, GlobalConstants.GET_CLONE_OPPTY);
		}
	}
	
	/*******************************
	Method Name: createOfferTeam
	Description: Aux method to create Offer Team when clonning an Opportunity
	Parameters: Id newOpptyId , List<OpportunityTeamMember> oppTeam
	*******************************/
	private static void createOfferTeam(Id newOpptyId, List<OpportunityTeamMember> oppTeam){
		List<Offer_Team__c> newOfferTeam = new List<Offer_Team__c>();
		Boolean hasBidRole = false;
		List<Opportunity> oppty = [Select Id,
	 (Select Id From Offers__r Where ActiveOffer__c = True)
	From Opportunity Where Id = :newOpptyId];
		
		Id offerId = oppty[0].Offers__r[0].Id;
		for(OpportunityTeamMember teamMember: oppTeam){
			if(!teamMember.TeamMemberRole.equals(GlobalConstants.ACCOUNT_MANAGER_TRICORN)){
	Offer_Team__c newOfferMember = new Offer_Team__c();
	newOfferMember.Offer__c = offerId;
	newOfferMember.Name__c = teamMember.UserId;
	newOfferMember.Team_Member_Role__c = teamMember.TeamMemberRole;
	newOfferMember.Additional_Team_Role__c = teamMember.Additional_Team_Role__c;
	if(teamMember.OpportunityAccessLevel == GlobalConstants.ALL_ACCESS_OFFER || teamMember.OpportunityAccessLevel == GlobalConstants.EDIT_ACCESS )
		newOfferMember.Offer_Access__c = GlobalConstants.READ_EDIT_ACCESS;
	
	else
		newOfferMember.Offer_Access__c = GlobalConstants.READ_ONLY_ACCESS;
	
	if(newOfferMember.Team_Member_Role__c.equals(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE))
		hasBidRole = true;
	
	newOfferTeam.add(newOfferMember);
			}
		}
		
		if(hasBidRole){
			Offer_Team__c oldBidManager = null;
			oldBidManager = [SELECT Id FROM Offer_Team__c WHERE Offer__c =: offerId AND Team_Member_Role__c =: GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE];
			DELETE oldBidManager;
		}
		
		Database.SaveResult[] srList = Database.insert(newOfferTeam, false);

		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
			if (sr.isSuccess()) {
	// Operation was successful, so get the ID of the record that was processed
	System.debug('Successfully inserted account. Account ID: ' + sr.getId());
			}
			else {
	// Operation failed, so get all errors	
	for(Database.Error err : sr.getErrors()) {
		System.debug('The following error has occurred.');		
		System.debug(err.getStatusCode() + ': ' + err.getMessage());
		System.debug('Account fields that affected this error: ' + err.getFields());
	}
			}
		}
	}
	/*******************************
Method Name: cloneProgramFlags
Description: Requirement 137: Cloning Pre-opportunities
Parameters: old Opportunity id , new Opportunity id
*******************************/
	public static void cloneProgramFlags(ID newOpptyId, string oldOpptyID) {
		List < Program_Flag__c > opportunityProgramFlagsList = new List < Program_Flag__c > ();
		List < Program_Flag__c > newProgramFlagsList = null;
		List < OptyProgramFlagJunction__c > opportunityProgramFlagsJuncList = new List < OptyProgramFlagJunction__c > ();
		List < OptyProgramFlagJunction__c > newProgramFlagsJuncList = null;
		OptyProgramFlagJunction__c opportunityProgramFlagJuncObj = new OptyProgramFlagJunction__c();
		Set<String> flagIds = new Set<String>();
		try {
			opportunityProgramFlagsJuncList = [SELECT Program_Flag__c, Name FROM OptyProgramFlagJunction__c where Opportunity__c = :oldOpptyID
			  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
			if (!opportunityProgramFlagsJuncList.isEmpty()) {
	for(OptyProgramFlagJunction__c objFlagJunc: opportunityProgramFlagsJuncList){
		flagIds.add(objFlagJunc.Program_Flag__c);
	}
	opportunityProgramFlagsList = [SELECT CurrencyIsoCode, Description__c, Flag_Category__c, Flag_End_Date__c, Name, Is_Flag_Active__c, OwnerId FROM Program_Flag__c where Id in :flagIds
			  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	
	system.debug('Inside if opportunityProgramFlagsList');
	newProgramFlagsList = new List < Program_Flag__c > ();
	
	for (Program_Flag__c obj: opportunityProgramFlagsList) {
		system.debug('obj' + obj);
		Program_Flag__c opportunityProgramFlagObj = obj.clone(false,false,false,false);
		newProgramFlagsList.add(opportunityProgramFlagObj);
	}
	
	system.debug('Final newProgramFlagsList' + newProgramFlagsList);
	if (!newProgramFlagsList.isEmpty()) {
		Database.SaveResult[] savedResults = Database.insert(newProgramFlagsList, false);
		Boolean someFailure = false;
		for (Database.SaveResult sr: savedResults) {
			if (!sr.isSuccess()) {
				someFailure = true;
				for (Database.Error err: sr.getErrors()) {
		System.debug(GlobalConstants.ERROR_OCCURED + err.getStatusCode() + ' : ' + err.getMessage());
		System.debug(GlobalConstants.FIELDS_AFFECTED_BY_ERROR + err.getFields());
				}
			}
		}
		if (!someFailure) {
			System.debug('Opty Flags added successfully');
		}
	}
	
	system.debug('Inside if opportunityProgramFlagJuncObj');
	newProgramFlagsJuncList = new List<OptyProgramFlagJunction__c>();
	
	for(Program_Flag__c objflag :newProgramFlagsList){
		opportunityProgramFlagJuncObj = new OptyProgramFlagJunction__c();
		opportunityProgramFlagJuncObj.Program_Flag__c = objflag.ID;
		opportunityProgramFlagJuncObj.Opportunity__c = newOpptyId;
		newProgramFlagsJuncList.add(opportunityProgramFlagJuncObj);
	}
	
	system.debug('Final newProgramFlagsJuncList' + newProgramFlagsJuncList);
	if (!newProgramFlagsJuncList.isEmpty()) {
		Database.SaveResult[] savedResults = Database.insert(newProgramFlagsJuncList, false);
		Boolean someFailure = false;
		for (Database.SaveResult sr: savedResults) {
			if (!sr.isSuccess()) {
				someFailure = true;
				for (Database.Error err: sr.getErrors()) {
		System.debug(GlobalConstants.ERROR_OCCURED + err.getStatusCode() + ' : ' + err.getMessage());
		System.debug(GlobalConstants.FIELDS_AFFECTED_BY_ERROR + err.getFields());
				}
			}
		}
		if (!someFailure) {
			System.debug('Opty Flags Junction added successfully');
		}
	}
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.CLONE_OPPORTUNITY, GlobalConstants.GET_CLONE_OPPTY);
		}
	}
	
	/*******************************
Method Name: cloneOIF
Description: ft-241: Automatic Care Renewal
Parameters: old Opportunity id , new Opportunity id
*******************************/
	private static void cloneOIF(Opportunity newOppty, Opportunity oldOppty, List<Order_Intake_Forecast__c> oldOpptyOIFs)
	{
		List<Order_Intake_Forecast__c> newOIFList = new List<Order_Intake_Forecast__c>();
		Date poAndRevDate = setDateNoPast(oldOppty.Care_Contract_End_Date__c.addDays(-30));
		Nokia_Financial_Calendar__c calRec = [SELECT id FROM Nokia_Financial_Calendar__c where Start_Date__c <= :poAndRevDate AND End_Date__c >= :poAndRevDate];
		for(Order_Intake_Forecast__c oldOIFLine :oldOpptyOIFs)
		{
			Order_Intake_Forecast__c newOIFLine = new Order_Intake_Forecast__c();
			newOIFLine.Opportunity__c = newOppty.Id;
			newOIFLine.BusinessLine__c = oldOIFLine.BusinessLine__c;
			newOIFLine.OIF_Value__c = oldOIFLine.OIF_Value__c;
			newOIFLine.Software__c = oldOIFLine.Software__c;
			newOIFLine.Notes__c = oldOIFLine.Notes__c;
			newOIFLine.Forecast_Category__c = 'Risk';
			newOIFLine.POPlanReceipt__c = calRec.Id;
			if(oldOIFLine.Rev_RecPlan_Receipt__c != null)
			{
	newOIFLine.Rev_RecPlan_Receipt__c = calRec.Id;
			}
			newOIFList.add(newOIFLine);
		}
		saveRecords(newOIFList, 'OIF Lines added successfully');
	}
	/*******************************
Method Name: cloneCompetitors
Description: ft-241: Automatic Care Renewal
Parameters: old Opportunity id , new Opportunity id
*******************************/
	private static void cloneCompetitors(Id renewalOpptyId, List<Competitor__c> originalOpptyCompetitors)
	{
		List<Competitor__c> renewalCompetitorList = new List<Competitor__c>();
		for(Competitor__c competitor : originalOpptyCompetitors)
		{
	   if(competitor.Competitor_New__c != 'Nokia'){
			Competitor__c clonedCompetitor = new Competitor__c();
			clonedCompetitor.Competitor_New__c = competitor.Competitor_New__c;
			clonedCompetitor.Comments__c = competitor.Comments__c;
			clonedCompetitor.Competitors_Price_Aggressiveness__c = competitor.Competitors_Price_Aggressiveness__c;
			clonedCompetitor.Won_Share_Allocation_in__c = competitor.Won_Share_Allocation_in__c;
			clonedCompetitor.Primary_Competitor__c = competitor.Primary_Competitor__c;
			clonedCompetitor.Opportunity__c = renewalOpptyId;
			renewalCompetitorList.add(clonedCompetitor);
			}
		}
		saveRecords(renewalCompetitorList, 'Competitors added successfully');
	}
	
	/*******************************
Method Name: cloneContacts
Description: ft-241: Automatic Care Renewal
Parameters: old Opportunity id , new Opportunity id
*******************************/
	private static void cloneContacts(Id newOpptyId, List<OpportunityContactRole> originalContactRoles)
	{
		List<OpportunityContactRole> newContactRoleList = new List<OpportunityContactRole>();
		for(OpportunityContactRole originalContactRole : originalContactRoles)
		{
			OpportunityContactRole clonedContactRole = new OpportunityContactRole();
			clonedContactRole.OpportunityId = newOpptyId;
			clonedContactRole.Role = originalContactRole.Role;
			clonedContactRole.IsPrimary = originalContactRole.IsPrimary;
			clonedContactRole.ContactId = originalContactRole.ContactId;
			newContactRoleList.add(clonedContactRole);
		}
		saveRecords(newContactRoleList, 'Contact Roles added successfully');
	}
	
	//Prevents Date to be set on Past
	private static Date setDateNoPast(Date dateVal)
	{
		Date finalDate;
		if(dateVal >= System.today())
		{
			finalDate = dateVal;
		}
		else
		{
			finalDate = System.today();
		}
		return finalDate;
	}
	
	private static void saveRecords(List<sObject> listToInsert, String debugMessage)
	{
		Database.SaveResult[] savedResults = Database.insert(listToInsert, false);
		Boolean someFailure = false;
		for (Database.SaveResult sr: savedResults) {
			if (!sr.isSuccess()) {
	someFailure = true;
	for (Database.Error err: sr.getErrors()) {
		System.debug(GlobalConstants.ERROR_OCCURED + err.getStatusCode() + ' : ' + err.getMessage());
		System.debug(GlobalConstants.FIELDS_AFFECTED_BY_ERROR + err.getFields());
	}
			}
		}
		if (!someFailure) {
			System.debug(debugMessage);
		}
	}
	
	private static Opportunity fetchRelatedRecords(Id  oppId, List<String> categFilterOIF, List<String> productFilterOIF)
	{
		Opportunity opty = [SELECT Id, Name, Care_Contract_End_Date__c, CLM_Existing_Contract_Reference__c,
				(SELECT OpportunityId, Role, IsPrimary, ContactId FROM OpportunityContactRoles),
				(SELECT Comments__c, Competitor_New__c, Competitors_Price_Aggressiveness__c, Won_Share_Allocation_in__c, Primary_Competitor__c FROM Competitors__r),
				(SELECT Id, Forecast_Category__c, BusinessLine__c, OIF_Value__c, Software__c, Notes__c, BusinessLine__r.ProductCode, Rev_RecPlan_Receipt__c FROM Order_Intake_Forecast_del__r WHERE BusinessLine__r.ProductCode IN :productFilterOIF AND Forecast_Category__c IN :categFilterOIF),
				(SELECT Id FROM R00N50000001Xl0FEAS)
				FROM Opportunity WHERE Id = :oppId AND Care_Renewal__c = TRUE];
		return opty;
	}
}