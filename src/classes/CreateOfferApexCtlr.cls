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
			opp = [Select Id,Name,G4_Planned_Date__c,G3_Planned_Date__c,G5_Planned_Date__c,Account.Customer_Compliance__c, Expected_LoA_Approval_Level__c from Opportunity
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
		try{
			Database.SaveResult savedResults = Database.insert(offerRec, false);
			Boolean someFailure = false;
			if (!savedResults.isSuccess()) {
	someFailure = true;
	for (Database.Error err: savedResults.getErrors()) {
		offerId = err.getMessage();
		System.debug('Error occured : ' + err.getStatusCode() + ' : ' + err.getMessage());
		System.debug('Fields that affected this error : ' + err.getFields());
	}
			}
			if (!someFailure) {
	System.debug('Offer added successfully.');
	offerId = offerRec.id;
			} 
		}catch (Exception ex)
		{
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
		System.debug('Error occured : ' + err.getStatusCode() + ' : ' + err.getMessage());
		System.debug('Fields that affected this error : ' + err.getFields()); 
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
	/*Database.SaveResult[] savedResults = Database.insert(offerTeamList, true);

for(Integer i=0;i<savedResults.size();i++){
if(!savedResults[i].isSuccess()){//only look at failures, or NOT Successes
system.debug(savedResults[i]. getErrors());
system.debug(offerTeamList[i]);
msg += 'For User : '+wrapperFinalList[i].userName+' : '+savedResults[i]. getErrors();
}
}
throw new AuraHandledException(msg);
}*//*catch(DmlException e){
for (Integer i = 0; i < e.getNumDml(); i++) {
//Get Validation Rule & Trigger Error Messages
if(msg == '')
msg ='Row no : '+e.getDmlIndex(i)+ ' '+e.getLineNumber()+' '+e.getDmlFieldNames(0)+' '+e.getDmlFields(0)+' '+e.getDmlMessage(i) +  '\n' ;
else
msg = msg+'Row no : '+e.getDmlIndex(i)+ ' '+e.getDmlMessage(i) +  '\n' ;
}
//throw DML exception message
throw new AuraHandledException(msg);*/
	@AuraEnabled
	public static void saveOfferTeam(String wrapperList, Id newOfferId)
	{
		String msg = '';
		system.debug('wrapperList'+wrapperList);
		system.debug('newOfferId'+newOfferId);
		Type idArrType = Type.forName(GlobalConstants.LIST_WRAPPER);
		List<OfferTeamWrapper> wrapperFinalList = new List<OfferTeamWrapper>();		
		List <Offer_Team__c> offerTeamList ;
		Offer_Team__c offerTeamVar;
		try{
			wrapperFinalList = (List<OfferTeamWrapper>) JSON.deserialize(wrapperList, idArrType);
			system.debug('wrapperFinalList'+wrapperFinalList);
			if(wrapperFinalList != Null)
			{
	offerTeamList = new List<Offer_Team__c>();
	system.debug('In if statement');
	for(OfferTeamWrapper wrapperVar : wrapperFinalList)
	{
		if(wrapperVar.teamRole != Null || wrapperVar.teamRole != '')
		{
			system.debug('wrapperVar'+wrapperVar);
			offerTeamVar = new Offer_Team__c();
			offerTeamVar.Offer_Access__c = wrapperVar.offerAccess;
			offerTeamVar.Team_Member_Role__c = wrapperVar.teamRole;
			offerTeamVar.Name__c = wrapperVar.userId;
			offerTeamVar.Offer__c = newOfferId;
			offerTeamVar.Additional_Team_Role__c = wrapperVar.additionalTeamRole;
			offerTeamVar.BG__c = wrapperVar.leadBG; 
			system.debug('offerTeamVar'+offerTeamVar);
			offerTeamList.add(offerTeamVar);
		}
	}
	system.debug('offerTeamList'+offerTeamList);
	Database.SaveResult[] savedResults = Database.insert(offerTeamList, false);
	for(Database.SaveResult res : savedResults)
	{
		system.debug('res.getErrors()'+res.getErrors());
	}
	//system.debug('savedResults.getErrors()'+savedResults.getErrors());
	Boolean someFailure = false;
	for(Database.SaveResult result : savedResults){
		if (!result.isSuccess()) {
			someFailure = true;
			for (Database.Error err: result.getErrors()) {
				System.debug('Error occured : ' + err.getStatusCode() + ' : ' + err.getMessage());
				System.debug('Fields that affected this error : ' + err.getFields());
			}
		}
		if (!someFailure) {
			System.debug('New offer Team inserted successfully');
		} 
	}
			}			
		}catch (Exception ex)  {  ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.SAVEOFFERTEAM); }
	}
	
	
	/********************
*Method Name: getAllExpectedLoALevel
*Parameter: 
*Description:  Fetching all Expected Loa Level from picklist
*******************/
	@AuraEnabled
	public static Map<string,string> getAllExpectedLoALevel(){
		Map<string,string> expectedLoALevel= new  Map<string,string>();
		// Get the list of picklist values for this field.
		map<String, Schema.SObjectField> fieldMap = CreateOfferApexCtlr.getFieldMapOffer();
		system.debug('fieldMap'+fieldMap);
		try{
			list<Schema.PicklistEntry> values = fieldMap.get(GlobalConstants.Expected_LoA_Level).getDescribe().getPickListValues();
			system.debug('values'+values);
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry val : values)
			{ 
	if(val.isActive())
		expectedLoALevel.put(val.getLabel(), val.getValue()); 
			}
		}catch (Exception ex){ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.SAVEOFFERTEAM); }
		return expectedLoALevel;
	}
	
	/********************
*Method Name: getFieldMap
*Parameter: 
*Description:  common exection in fetching picklist values of offer
*******************/
	private static map<String, Schema.SObjectField> getFieldMapOffer(){
		// Get the object type of the SObject.
		Schema.sObjectType objType = Offer__c.getSObjectType(); 
		system.debug('objType'+objType);
		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); 
		system.debug('objDescribe'+objDescribe);
		// Get a map of fields for the SObject
		return objDescribe.fields.getMap(); 
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
		}catch (Exception ex){ ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR ,GlobalConstants.SAVEOFFERTEAM);	 }
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
		list<Schema.PicklistEntry> values = fieldMap.get(gLOBALcONSTANTS.TEAMMEMBERROLE).getDescribe().getPickListValues();
		try{
			
			system.debug('values'+values);
			// Add these values to the select option list.
			for (Schema.PicklistEntry val : values)
			{ 
	teamMemberRole.put(val.getValue(), val.getLabel()); 
			}
			oppTeam = [Select Id,UserId,User.Name,User.NSA_Compliant__c,
		TeamMemberRole,Additional_Team_Role__c, OpportunityAccessLevel,
		opportunity.OwnerId, opportunity.Owner.NSA_Compliant__c, opportunity.Owner.Name
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
		wrapper.nsaCompliant = opp.User.NSA_Compliant__c ;
		wrapper.userName = opp.User.Name;
		wrapper.oppOwnerId = opp.opportunity.OwnerId;
		wrapper.oppOwnerNSA = opp.opportunity.Owner.NSA_Compliant__c;
		wrapper.oppOwnerName = opp.opportunity.Owner.Name;
		wrapperList.add(wrapper);
	}
	wrapperList = manageBidManager(wrapperList, teamMemberRole);
			}
		}catch(Exception ex) { ExceptionHandler.addException(ex,GlobalConstants.CREATEOFFERAEXCTLR,GlobalConstants.GETOPPTYTEAM);		}
		System.debug(wrapperList);
		return wrapperList;
	}
	
	private static List<OfferTeamWrapper> manageBidManager(List<OfferTeamWrapper> offerTeamMembersList, Map<string,string> teamMemberRole)
	{
		Boolean hasPrimaryBM = false; //Bid manager has alternative role
		Boolean hasAlternateBM = false; //Bid manager has alternative role
		OfferTeamWrapper offerMemberWithAlt = new OfferTeamWrapper();
		
		for (OfferTeamWrapper offTeamMember : offerTeamMembersList)
		{
			if(offTeamMember != null && offTeamMember.teamRoleLabel != null && offTeamMember.teamRoleLabel.equals(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE))//Check if we already have a Bid Manager assigned
			{ 
	hasPrimaryBM = true;
	break;
			}
			else if( offTeamMember != null && offTeamMember.additionalTeamRole != null && offTeamMember.additionalTeamRole.contains(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE) && !hasAlternateBM)//Check if we already have a Bid Manager assigned
			{
	hasAlternateBM = true;
	offerMemberWithAlt = offTeamMember;
			}
		}
		
		//Assign new BM if needed 
		if (!hasPrimaryBM)//Need to create new offer team member
		{
			OfferTeamWrapper wrapper = new OfferTeamWrapper();
			wrapper.teamRole = GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE;
			if(teamMemberRole.containsKey(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE))
	wrapper.teamRoleLabel = teamMemberRole.get(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE);
			
			wrapper.offerAccess = GlobalConstants.READ_EDIT_ACCESS;
			if( hasAlternateBM)//Elect team member that is "Bid Manager" as an alternate role as "the Bid Manager"
			{
	wrapper.userId = offerMemberWithAlt.UserId;
	wrapper.nsaCompliant = offerMemberWithAlt.additionalTeamRole.contains(GlobalConstants.BID_MANAGER_OFFER_TEAM_ROLE);//offerMemberWithAlt.nsaCompliant;
	wrapper.userName = offerMemberWithAlt.additionalTeamRole;//offerMemberWithAlt.userName;
			}
			else//elect opportunity owner has the Bid Manager in team offer
			{
	wrapper.userId = offerTeamMembersList[0].oppOwnerId;
	wrapper.nsaCompliant = offerTeamMembersList[0].oppOwnerNSA;
	wrapper.userName = offerTeamMembersList[0].oppOwnerName;
			}
			offerTeamMembersList.add(wrapper);
		}
		return offerTeamMembersList;
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
		//User userVar;
		String searchKey = GlobalConstants.WILDCARD_SEARCH + keyWord + GlobalConstants.WILDCARD_SEARCH;
		try{
			userList = [Select Id,Name,NSA_Compliant__c from User where Name like: searchKey and IsActive =: true LIMIT :GlobalConstants.QUERRY_LIMIT_MAX_USER_PER_OFFER];
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
	public static List<OfferTeamWrapper> offerTeamPrMValidation ( String offTeamList, Id opptyId)
	{
		system.debug('offTeamList'+offTeamList);
		set<String> orgLevel = new set<String>();
		Map<String,String> sRmap = new Map<String, String>();
		Type idArrType = Type.forName(GlobalConstants.LIST_WRAPPER);
		List<OfferTeamWrapper> wrapperFinalList = new List<OfferTeamWrapper>();	  
		List<OfferTeamWrapper> pricingManagerList = new List<OfferTeamWrapper>();
		try
		{ 
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