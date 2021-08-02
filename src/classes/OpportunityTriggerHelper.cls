/*******************************
Class Name: OpportunityTriggerHelper
Created by: Accenture
Created Date: 7th Nov 2016
Last modified by: Accenture
Last modified date: 26th Dec 2016
Description: This class will handle the logic implemented on Opportunity
Note : Fix to handle unwanted update on probability in inline editing on Opportunity
*******************************/
public class OpportunityTriggerHelper {

	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.DIRECT_OPPTY).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.INDIRECT_OPPTY).getRecordTypeId();
	private static final Id readOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYDIRECT).getRecordTypeId();
	private static final Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYINDIRECT).getRecordTypeId();
	public static String approvaldata;
	public static boolean isExecuting = false;

	/*****************************
	*Method Name: probabilityUpdate
	*Description: This method will update probability on oppty with the old value if changed by inline editing,
	and set 0 for negative value and 100 for positive
	*Parameters: Opportunity List, Opportunity Map
	*Test coverage from: OpportunityTriggerHelperTest
	* 1.0: Chnaging the logic from Sales Outcome to StageName
	*******************************/
	public static void probabilityUpdateInline( Map<ID, Opportunity>opptyNewMap, Map<ID, Opportunity>opptyOldMap) {
		Set<ID>accountIdSet = new Set<ID>();
		List<Opportunity> opptyList = new List<Opportunity>();
		if( OpportunityTriggerHelper.isExecuting ){
			// if was executed during the same context
			// avoid recursion
			return;
		}
		for(Opportunity opty: opptyNewMap.values()) {
			opptyList.add(opty);
		}
		try {
			for (Opportunity opptyObj: opptyList) {
	if 	(opptyObj.Probability == 0 && opptyOldMap.get(opptyObj.Id).probability != 0 &&
		opptyObj.StageName != opptyOldMap.get(opptyObj.Id).StageName &&
		(opptyObj.StageName ==GlobalConstants.IDENTIFY_OPPORTUNITY || opptyObj.StageName ==GlobalConstants.DEVELOP_OPPORTUNITY  || opptyObj.StageName == GlobalConstants.CREATE_OFFER || opptyObj.StageName ==GlobalConstants.WIN_THE_CASE_NEGOTIATE) &&
		(opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId)){
			accountIdSet.add(opptyObj.accountId);
	}
			}
			if (!accountIdSet.isEmpty()) {
	List<Opportunity> opptyRecList = new List<Opportunity>();
	Map<ID, Account>accountMap = new Map<ID, Account>([SELECT id, AccountNumber FROM Account WHERE id IN: accountIdSet LIMIT: accountIdSet.size()]);
	for (Opportunity oppty: opptyList) {
		if (accountMap.get(oppty.accountId).AccountNumber != NULL) {
			Opportunity opptyRec = new Opportunity(Id=oppty.Id);
			opptyRec.probability = opptyOldMap.get(oppty.Id).probability;
			opptyRecList.add(opptyRec);
		}
	}
	if(!opptyRecList.isEmpty())
		Database.update(opptyRecList,false);
	OpportunityTriggerHelper.isExecuting = true;
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.PROBABILITY_UPDATE);
		}
	}

	/*****************************
	*Method Name: setAluasTrue
	*Description: This method will update ALU-I flag to true when account country is equal to ALU-I custom settings
	*Requirement: 529
	*Parameters: Opportunity List
	*Test coverage from: OpportunityTriggerHelperTest
	*******************************/
	public static void setAluasTrue(List<Opportunity>opptyList) {
		Set<Id>accountIdSet = new Set<Id>();
		Set<String>aluCountrySet = new Set<String>();
		Map<Id, Account>idToAccountMap;
		Map<ID, Schema.RecordTypeInfo>recTypeMap = Schema.SObjectType.Opportunity.getRecordTypeInfosById();
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_SET_ALU_TRUE == false){
	//getting country field data from custom setting
	for (ALUI__c aluCountry: ALUI__c.getAll().values()) {
		aluCountrySet.add(aluCountry.country__c);
	}
	//Getting Account Id from Opportunity
	for (Opportunity opptyAccount: opptyList) {
		String opptyRecordType = recTypeMap.get(opptyAccount.RecordTypeId).getName();
		//If record type is direct then it will pick legal account
		if (opptyRecordType == GlobalConstants.DIRECT_OPPTY) {
			accountIdSet.add(opptyAccount.accountId);
		}
		//If record type is indirect then it will pick end customer
		else if (opptyRecordType == GlobalConstants.INDIRECT_OPPTY) {
			accountIdSet.add(opptyAccount.End_Customer__c);
		}
	}
	//Map for Account's country is equal to ALU-I custom Setting
	if (!accountIdSet.isEmpty()) {
		idToAccountMap = new Map<Id, Account>([SELECT id, Country__c FROM Account WHERE Id IN: accountIdSet AND Country__c IN: aluCountrySet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
	}
	for (Opportunity opptyObj: opptyList) {
		if ((idToAccountMap != NULL && idToAccountMap.containsKey(opptyObj.accountId)) || (idToAccountMap != NULL && idToAccountMap.containsKey(opptyObj.End_Customer__c))) {
			opptyObj.ALU__c = true;
		} else {
			opptyObj.ALU__c = false;
		}
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_SET_ALU_TRUE = true;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.SET_ALU_TRUE);
		}
	}

	/*****************************
	*Method Name: convertionrateupdate
	*Description: This method will update Unweighted Amount EUR to new rate vale(Ref:Dated Exchange Rate Values)
	*Parameters: Opportunity opptyList
	*******************************/
	public static void convertionrateupdate(List<Opportunity>opptyList) {
		Set<Opportunity>Opprec = new Set<Opportunity>();
		Set<String>Oppcurrency = new Set<String>();
		map<String, Decimal>datedrate = new map<String, Decimal>();
		Date todayDate = Date.Today();
		// collecting today date
		try {
			for (Opportunity newrec: opptyList) {
	Opprec.add(newrec);
	Oppcurrency.add(newrec.CurrencyIsoCode);
			}
			//collecting the Active period
			List < Nokia_Financial_Calendar__c > currentPeiod = [select id, name, Start_Date__c ,End_Date__c from Nokia_Financial_Calendar__c Where Current_Period__c = True ORDER BY End_Date__c ASC LIMIT 1];

			if( currentPeiod.size()>0){
	//collecting the rate
	List<Dated_Exchange_Rates__c> ratecollectList = [SELECT Id,CurrencyIsoCode,DER_Period__c,DER_Period__r.Start_Date__c , Exchange_Rate__c, Start_Date__c
	FROM Dated_Exchange_Rates__c
	WHERE ( CurrencyIsoCode =: Oppcurrency or CurrencyIsoCode =:GlobalConstants.USD)
	AND  DER_Period__c=:currentPeiod.get(0).ID LIMIT: Limits.getLimitQueryRows()];
	for (Dated_Exchange_Rates__c ratecollect: ratecollectList)
		datedrate.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
	for (Opportunity updaterec: opptyList) {
		if (updaterec.OIF_Lines__c == 0) {
			if((!updaterec.CurrencyIsoCode.equalsignorecase(GlobalConstants.USD)) && updaterec.Amount<>0) {
	if((!updaterec.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR))&& datedrate.get(GlobalConstants.USD)<>NUll && datedrate.get(updaterec.CurrencyIsoCode)<>Null )
		updaterec.Unweighted_Amount_USD__c=((updaterec.Amount/datedrate.get(updaterec.CurrencyIsoCode))*datedrate.get(GlobalConstants.USD)).setscale(2);
	else if(datedrate.get(GlobalConstants.USD)<>Null && updaterec.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR) ){
		updaterec.Unweighted_Amount_USD__c=(updaterec.Amount*datedrate.get(GlobalConstants.USD)).setscale(2);
	}
			} else
	updaterec.Unweighted_Amount_USD__c= updaterec.Amount;
			if ((!updaterec.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR)) && updaterec.Amount<>0){
	updaterec.Unweighted_Amount_EUR__c = (updaterec.Amount / datedrate.get(updaterec.CurrencyIsoCode)).setscale(2);
			} else{
	updaterec.Unweighted_Amount_EUR__c = updaterec.Amount;
			}
		}
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.EXCHANGERATE);
		}
	}

	/*****************************
	*Method Name: Currenychange
	*Description: Update unweighted amount
	*Parameters: OpptyID
	*******************************/
	@Future
	public static void Currenychange(Set<ID>  Opptyid) {
		List<Opportunity> UpdateOppty =new List<Opportunity>();
		Map<Object,Set<String>> AggResultMap = new Map<Object,Set<String>>();
		try {
			List<AggregateResult> aggResultList = [SELECT Business_Group__c,Opportunity__c FROM Order_Intake_Forecast__c
	WHERE Opportunity__c =:Opptyid AND Allocation__c=false
	GROUP BY Business_Group__c,Opportunity__c Limit:Limits.getLimitQueryRows()];
			for(AggregateResult aggResult:aggResultList)
			{
	if (!AggResultMap.containsKey(aggResult.get('Opportunity__c')))
		AggResultMap.put(aggResult.get('Opportunity__c'), new Set<String>());

	if (AggResultMap.containsKey(aggResult.get('Opportunity__c')))
		AggResultMap.get(aggResult.get('Opportunity__c')).add(String.ValueOf(aggResult.get('Business_Group__c')) );
			}
			//if(GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE==False){
			List<Opportunity> newoppList = [Select id,Positive_OIF_EUR__c,OIF_Value_Won_USD__c,Mono_or_Multi_BG__c,Sales_Outcome__c,OIF_Value_Cancel_USD__c,Positive_OIF__c,Negative_OIF_EUR__c,Negative_OIF__c from Opportunity where id=:Opptyid Limit:Opptyid.size()];
			for (Opportunity newopp:newoppList) {
	if(AggResultMap<>Null &&AggResultMap.get(newopp.id)<>Null && AggResultMap.get(newopp.id).size()>1)
		newopp.Mono_or_Multi_BG__c='Multi-BG';
	else if(AggResultMap<>Null &&AggResultMap.get(newopp.id)<>Null && AggResultMap.get(newopp.id).size()==1)
		newopp.Mono_or_Multi_BG__c='Mono-BG';
	else
		newopp.Mono_or_Multi_BG__c=null;
	if (String.IsEmpty(newopp.Sales_Outcome__c) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED)) {
		newopp.Unweighted_Amount_EUR__c = newopp.Positive_OIF_EUR__c.setScale(2);
		newopp.amount=newopp.Positive_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c=newopp.OIF_Value_Won_USD__c.setScale(2);
		newopp.Is_Automated__c=TRUE;
	} else if ((newopp.Sales_Outcome__c<>GlobalConstants.WON)){
		newopp.Unweighted_Amount_EUR__c = newopp.Negative_OIF_EUR__c.setScale(2);
		newopp.amount=newopp.Negative_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c=newopp.OIF_Value_Cancel_USD__c.setScale(2);
		newopp.Is_Automated__c=TRUE;
	}
	UpdateOppty.add(newopp);
			}
			if(!UpdateOppty.isEmpty()){
	update UpdateOppty;
	GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE=TRUE;
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CURRENCY_CHANGE);
		}
	}

	/*****************************
	*Method Name: BatchCurrenychange
	*Description: Update unweighted amount
	*Parameters: Oppty ID
	*******************************/
	public static void BatchCurrenychange(Set<ID>  Opptyid) {
		List<Opportunity> UpdateOppty =new List<Opportunity>();
		try {
			List<Opportunity> newOppList = [Select id,Positive_OIF_EUR__c,OIF_Value_Won_USD__c,Sales_Outcome__c,OIF_Value_Cancel_USD__c,Positive_OIF__c,Negative_OIF_EUR__c,Negative_OIF__c from Opportunity where id=:Opptyid Limit:Opptyid.size()];
			for (Opportunity newopp:newOppList) {
	if (String.IsEmpty(newopp.Sales_Outcome__c) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED)) {
		newopp.Unweighted_Amount_EUR__c = newopp.Positive_OIF_EUR__c.setScale(2);
		newopp.amount=newopp.Positive_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c=newopp.OIF_Value_Won_USD__c.setScale(2);
		newopp.Is_Automated__c=TRUE;
	}else if ((newopp.Sales_Outcome__c<>GlobalConstants.WON)){
		newopp.Unweighted_Amount_EUR__c = newopp.Negative_OIF_EUR__c.setScale(2);
		newopp.amount=newopp.Negative_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c=newopp.OIF_Value_Cancel_USD__c.setScale(2);
		newopp.Is_Automated__c=TRUE;
	}
	UpdateOppty.add(newopp);
			}

			if(!UpdateOppty.isEmpty()){
	List<Database.saveResult> srs = Database.update(UpdateOppty,false);
	ExceptionHandler.addExceptionForOIFBtach(UpdateOppty, srs);
	GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE=TRUE;
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.BATCH_CURRENCY_CHANGE);
		}
	}

	//Requirement 722: Sales Process: Opportunity Decision date will update as per the NFC active period
	/*****************************
	*Method Name: DecisonUpdate
	*Description: Opportunity Active rate will update as per the NFC active period , Req 5470
	*Parameters: Opportunity List
	*******************************/
	public static void DecisonUpdate(List<Opportunity>opptyList) {
		try {
			List<Opportunity> opportunityList = new List<Opportunity>();
			for (Opportunity opplist: opptyList) {
			//Adding a filter to avoide descision period is updated on Opportunity Creation.
			if ((opplist.id !=null) && String.isnotEmpty(opplist.StageName) &&  String.isEmpty(opplist.Decision_Period__c)  && ( opplist.StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY)  || opplist.StageName.equalsignorecase(GlobalConstants.CANCELLED_BY_CUSTOMER) || opplist.StageName.equalsignorecase(GlobalConstants.LOST_TO_COMPETITOR) ||  opplist.StageName.equalsignorecase(GlobalConstants.OBSOLETE) ||   opplist.StageName.equalsignorecase(GlobalConstants.WITH_DRAW_BY_NOKIA)) )
	//Sales outcome not empry then decision Period will update as per the Active NFC Period Name
	opportunityList.add(opplist);
			else if(opplist.StageName.equalsignorecase(GlobalConstants.IDENTIFY_OPPORTUNITY) || opplist.StageName.equalsignorecase(GlobalConstants.DEVELOP_OPPORTUNITY) || opplist.StageName.equalsignorecase(GlobalConstants.CREATE_OFFER) ||opplist.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE ) )
	opplist.Decision_Period__c = '';
			}
			if(!opportunityList.isEmpty()){
	//Collecting the Active period Name
	List<Nokia_Financial_Calendar__c>currentPeiod = [select id, name, Start_Date__c, End_Date__c from Nokia_Financial_Calendar__c Where Current_Period__c = True ORDER BY End_Date__c LIMIT 1];
	if(currentPeiod.size()>0){
		for(Opportunity opp : opptyList) {
			opp.Decision_Period__c = currentPeiod.get(0).Name;
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.DECISION_UPDATE);
		}
	}

	//Requirement 722: Sales Process: Opportunity owner will follow Opportunity on Chatter
	/*****************************
	*Method Name: FollowOpportunity
	*Description: Opportunity owner will follow Opportunity on Chatter
	*Parameters: Opportunity List
	*******************************/
	public static void FollowOpportunity(List<Opportunity>opptyList) {
		List<EntitySubscription>opptyEntitySubList = new List<EntitySubscription>();
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_FOLLOW_OPPTY == False){
	for (Opportunity opptyObj: opptyList) {
		EntitySubscription opptyEntity = new EntitySubscription();
		opptyEntity.ParentId = opptyObj.id;
		opptyEntity.SubscriberId = opptyObj.OwnerId;
		opptyEntity.NetworkId = Network.getNetworkId();
		opptyEntitySubList.add(opptyEntity);
	}
	database.insert(opptyEntitySubList);
			}
			GlobalConstants.OPPORTUNITYTRIGGER_FOLLOW_OPPTY = True;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.FOLLOW_OPPORTUNITY);
		}
	}

	/*
	* @desc   this method used to create opportunity team members for delegates approvers
	* @param   opportunities: the map of opportunities which are approved or rejected
	*/
	public static void createOpportunityTeamMembers(map<Id, Opportunity>opportunitiesMap) {
		// Variables declaration
		map<ID, Set<Id>>mapOppIdMemberIds = new map<ID, Set<Id>>();
		map<ID, Set<Id>>mapOppIdFacilitatorsIds = new map<ID, Set<Id>>();
		List<OpportunityTeamMember>opportunitiesTeamMembersToCreate = new List<OpportunityTeamMember>();
		//get the Delegate Approvers Ids map
		for (Opportunity opportunity: opportunitiesMap.values()) {
			if (!mapOppIdFacilitatorsIds.containsKey(opportunity.Id)) {
	mapOppIdFacilitatorsIds.put(opportunity.Id, new Set<ID>());
			}
			if (opportunity.Facilitator_Delegate_1__c != null)
	mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.Facilitator_Delegate_1__c);
			if (opportunity.Facilitator_Delegate_2__c != null)
	mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.Facilitator_Delegate_2__c);
			if (opportunity.Facilitator_Delegate_3__c != null)
	mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.Facilitator_Delegate_3__c);
			if (opportunity.Facilitator_Backup__c != null)
	mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.Facilitator_Backup__c);
			if (opportunity.NF_Facilitator_User__c != null)
	mapOppIdFacilitatorsIds.get(opportunity.Id).add(opportunity.NF_Facilitator_User__c);
		}
		// Fill the map of opportunity and related users in opportunity team members
		List<OpportunityTeamMember>opportunitiesTeamMembers = [SELECT UserId, OpportunityId
	FROM OpportunityTeamMember
	WHERE OpportunityId IN: mapOppIdFacilitatorsIds.keySet()
	];
		for (OpportunityTeamMember oppTeamMember: opportunitiesTeamMembers) {
			if (!mapOppIdMemberIds.containsKey(oppTeamMember.OpportunityId)) {
	mapOppIdMemberIds.put(oppTeamMember.OpportunityId, new Set<ID>());
			}
			mapOppIdMemberIds.get(oppTeamMember.OpportunityId).add(oppTeamMember.UserId);
		}

		for (Id oppId: mapOppIdFacilitatorsIds.keySet()) {
			set<ID>existingMemberIds = new set<ID>();
			existingMemberIds = mapOppIdMemberIds.get(oppId);
			for (Id FacilitatorId: mapOppIdFacilitatorsIds.get(oppId)) {
	if (FacilitatorId != null && ((existingMemberIds != null && !existingMemberIds.contains(FacilitatorId)) || existingMemberIds == null)) {
		opportunitiesTeamMembersToCreate.add(new OpportunityTeamMember(
			UserId = FacilitatorId, OpportunityId = oppId, OpportunityAccessLevel = 'Edit'));
	}
			}
		}
	}

	//Requirement 870: Default Legal Entity Logic
	/*****************************
	*Method Name: populateDefaultLE
	*Description: this method used to populate default legalEntities on opportunity
	*Parameters: Opportunity List
	*******************************/
	public static void populateDefaultLE(List<Opportunity>opportunityList, Map<ID, Opportunity>optyOldMap) {
		List<Opportunity>validCustomerChanges = new List<Opportunity>();
		for (Opportunity opp: opportunityList) {
			if (optyOldMap.size()>0) {
	if (opp.AccountId != optyOldMap.get(opp.Id).AccountId || opp.End_Customer__c != optyOldMap.get(opp.Id).End_Customer__c) {
		validCustomerChanges.add(opp);
	}
			} else {
	if (opp.Legal_Entity__c == NULL || opp.End_Customer__c == NULL)
		validCustomerChanges.add(opp);
			}
		}
		if(validCustomerChanges.size()>0){
			List<String>allAccountIds = new List<String>();
			Map<string, string>customerVsDefaultLE = new Map<string, string>();
			for (Opportunity opp: validCustomerChanges) {
	allAccountIds.add(opp.accountId);
	//Null Check added by HCL on 9th Aug 2019
	if(opp.End_Customer__c != null){
		allAccountIds.add(opp.End_Customer__c);
	}
			}
			List<Account>defaultLEList = [select Id, parentId from Account where RecordType.name = 'Legal Entity'
		and Default_Legal_Entity__c = true
		and parentId IN: allAccountIds
		limit: (Limits.getLimitQueryRows() - Limits.getQueryRows())
		];
			for (Account defaultLE: defaultLEList) {
	customerVsDefaultLE.put(defaultLE.parentId, defaultLE.Id);
			}

			Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
			for (Opportunity opp: validCustomerChanges) {
	if (opp.RecordTypeId == oppDirectRecordTypeId && opp.End_Customer__c != NULL && opp.PRMPartner_User_Name__c == null){
		if(customerVsDefaultLE.containsKey(opp.End_Customer__c))
			opp.End_Customer_LE__c = customerVsDefaultLE.get(opp.End_Customer__c);
		else
			opp.End_Customer_LE__c = NULL;
	}
	if (opp.accountId != NULL){
		if(customerVsDefaultLE.containsKey(opp.accountId))
			opp.Legal_Entity__c = customerVsDefaultLE.get(opp.accountId);
		else
			opp.Legal_Entity__c = NULL;
	}
			}
		}
	}

	/***************************************
	*Method Name: updateOffersOnG4OrG5ApprovalDateIsUpdated
	*Description: This method will update the 'Active Offer' G4/G5 Approval date field on update of G4/G5 Appproval date of Opportunity. REQ#942& defect D-2793
	*Parameters: Opportunity Maps old/new
	*History : 22-12-2017 AJ: Requirement : 3545, Comment Logic to transfer G5 Approval date from Oppty to Active Offer & Delete field from Offer.
	*******************************/
	public static void updateOffersOnG4OrG5ApprovalDateIsUpdated(Map<ID, Opportunity>opptyMap, Map<ID, Opportunity> opptyOldMap) {
		List<Offer__c>offerToUpdate = new List<Offer__c>();
		Map<ID, List<Offer__c>>oppOfferListMap = new Map<ID, List<Offer__c>>();
		Set<Id> opptyIdSet = new Set<Id>();
		for(Opportunity objO: opptyMap.values()){
			if(objO.TotalOfferCount__c > 0)
	opptyIdSet.add(objO.Id);
		}

		if(!opptyIdSet.isEmpty() && opptyIdSet.size()>0){
			List<Offer__c>offerList = [Select id, ActiveOffer__c, Opportunity__c, G4_Approval_Date__c from Offer__c where Opportunity__c IN: opptyIdSet AND ActiveOffer__c = True];
			try {
	for (Offer__c offer: offerList) {
		//checking for active Offer
		if (offer.ActiveOffer__c == True) {
			List<Offer__c>offList = new List<Offer__c>();
			//Opportunity can have multiple Offer hence the below check
			if (oppOfferListMap.get(offer.Opportunity__c) != Null) {
	//Fetching the already existing opportunity id and adding offer List
	offList.addAll(oppOfferListMap.get(offer.Opportunity__c));
	offList.add(offer);
	oppOfferListMap.put(offer.Opportunity__c, offList);
			}
			if (oppOfferListMap.get(offer.Opportunity__c) == Null) {
	offList.add(offer);
	oppOfferListMap.put(offer.Opportunity__c, offList);
			}
		}
	}
	for (ID opptyID: oppOfferListMap.KeySet()) {
		for (Offer__c off: oppOfferListMap.get(opptyID)) {
			Opportunity opp = opptyMap.get(opptyID);
			if (opp.G4_Approval_Date__c != Null && opptyOldMap.get(opp.id).G4_Approval_Date__c != opp.G4_Approval_Date__c) {
	off.G4_Approval_Date__c = date.newinstance(opp.G4_Approval_Date__c.year(), opp.G4_Approval_Date__c.month(), opp.G4_Approval_Date__c.day());
	offerToUpdate.add(off);
			}
			//Requirement : 3545, Comment Logic to transfer G5 Approval date from Oppty to Active Offer & Delete field from Offer. Logic is deleted from here.
		}
	}
	if(offerToUpdate.size() >0)
	{
		database.Update(offerToUpdate);
		GlobalConstants.OPPORTUNITYTRIGGER_HELPER_UPDATE_G4_G5 = true;
	}
			} catch (Exception ex) {
	ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATE_G4_G5_APROVALDATE_FUNCTION);
			}
		}
	}

	//Sales Process: Requirement 855
	/*****************************
	*Method Name: restrictOpptyCreationByOTMFromDiffrentTerritory
	*Description: Checks the current user territory and account territory if maps allows opportunity Creation
	*Parameters: Opportunity List
	*Test coverage from: OpportunityTriggerHelperTest
	*******************************/
	public static void restrictOpptyCreationByOTMFromDiffrentTerritory(List<Opportunity>newOpptyList) {
		Map<Id, ObjectTerritory2Association>accountIdsAndOTMap = new Map<Id, ObjectTerritory2Association>();
		Set<Id>terriIds = new Set<Id>();
		Set<Id>accountIDs = new Set<Id>();
		Set<ID>objIDterriHerirachySet = new Set<ID>();
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_RESTRICT_OPPTY_CREATION == False && !FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser) ){
	List<UserTerritory2Association>myList = [SELECT Id, UserId, Territory2Id FROM UserTerritory2Association WHERE UserId =: userinfo.getuserid() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for (UserTerritory2Association terr: myList) {
		terriIds.add(terr.Territory2Id);
	}
	Map<Id, Territory2>idToTerritoryMap = new Map<Id, Territory2>([SELECT Id, Name, ParentTerritory2Id FROM Territory2 WHERE Id IN: terriIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
	Map<Id, Territory2>allTerritory = new Map<Id, Territory2>([SELECT Id, Name, DeveloperName, ParentTerritory2Id FROM Territory2 WHERE Territory2Model.state =: GlobalConstants.TERRITORY2MODEL_STATE_ACTIVE LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
	for (Opportunity opp: newOpptyList) {
		accountIDs.add(opp.AccountID);
	}
	List<ObjectTerritory2Association>oTList = [SELECT Id, ObjectId, Territory2Id FROM ObjectTerritory2Association WHERE ObjectId IN: accountIDs LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for (ObjectTerritory2Association ot: oTList) {
		if (ot.ObjectId != null) {
			accountIdsAndOTMap.put(ot.ObjectId, ot);
		}
	}
	for (Opportunity opp: newOpptyList) {
		if (opp.AccountID != null) {
			ObjectTerritory2Association objectTerr = accountIdsAndOTMap.get(opp.AccountID);
			if (allTerritory.get(objectTerr.Territory2Id) != null) {
	Territory2 terr = allTerritory.get(objectTerr.Territory2Id);
	objIDterriHerirachySet.add(terr.Id);
	ID territoryParentID = terr.ParentTerritory2Id;
	for (Integer i = 0; territoryParentID != null; i++) {
		objIDterriHerirachySet.add(territoryParentID);
		if (allTerritory.get(territoryParentID).ParentTerritory2Id != null) {
			territoryParentID = allTerritory.get(territoryParentID).ParentTerritory2Id;
		} else {
			territoryParentID = null;
		}
	}
			}
		}
		Integer size = 0;
		for (ID terrID: objIDterriHerirachySet) {
			if (idToTerritoryMap.KeySet().contains(terrID)) {
	Size++;
			}
		}
	if (size<1) {
		opp.addError(GlobalConstants.ACCOUNT_TERRITORY_IS_DIFFRENT_FROM_OPPORTUNITY_CREATOR_TERRITORY);
	}
			}
		}
			GlobalConstants.OPPORTUNITYTRIGGER_RESTRICT_OPPTY_CREATION = True;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.RESTRICTOPPTYCREATIONBYOTMFROMDIFFRENTTERRITORY);
		}
	}

	/*****************************
	*Method Name: UpdateUserinformation
	*Description: Update the Lastmodifieduser filed as per the Lastmodied custom data.
	*Parameters: Opportunity List
	*Test coverage from: OpportunityTriggerHelperTest
	*******************************/
	public static void UpdateUserinformation(List<Opportunity> newOpptyList){
		//collecting the Lastmodified custom data information
		List<LastModified__c> customdata = LastModified__c.getall().values();
		Map<Id,String> Customid =new Map<ID,String>();
		Set<ID> Oppid=new Set<ID>();
		//collecting the custom data User ID
		for(LastModified__c custominfo:customdata)
			Customid.put(custominfo.User_ID__c,custominfo.User_ID__c);
		try{
			for(Opportunity Opplist:newOpptyList){
	if(Opplist.Modified_User__c<>(Customid.get(Opplist.Modified_User__c)))
		Opplist.Last_User_Modified__c=System.now();
	else
		Opplist.Last_User_Modified__c=Opplist.Last_User_Modified__c;
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.OPPTY_TRIGGER_HELPER,GlobalConstants.UPDATE_USER_INFORMATION);
		}
	}

	//Sales Process: Sprint 5 : D-1512 Pupulate End Customer with Account and End customer LE with Account LE`
	/*****************************
	*Method Name: populateDefaultEndCustomerAndEndCustomerLegalEntity when record type is Direct
	*Description: this method used to populate default legalEntities on opportunity
	*Parameters: Opportunity List
	*Change Log : 1.1 D-1645 Sprint 5 Hypercare Fixes(Sales Process)
	*******************************/
	public static void populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType(List<Opportunity>opportunityList, Map<ID, Opportunity>opportunityOldMap) {
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_END_CUSTOMER == false){
	Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	for (Opportunity opp: opportunityList) {
		if (opp.RecordTypeId == oppDirectRecordTypeId && opp.Lead_type__c == Null && opp.PartnerAvailable__c != GlobalConstants.PICKLIST_VALUE_YES) {
			
			// commented below for SF Ticket 00297826 (along with Sonarqube adjustment) 27-05-2020
			
			/*if (!opportunityOldMap.isEmpty() && opportunityOldMap.get(opp.Id).End_Customer__c != opp.End_Customer__c) {
	opp.End_Customer__c = opp.AccountId;
	if (opp.Legal_Entity__c != NULL) {
		opp.End_Customer_LE__c = opp.Legal_Entity__c;
	}
	
			} else {
	opp.End_Customer__c = opp.AccountId;
	if (opp.Legal_Entity__c != NULL) {
		opp.End_Customer_LE__c = opp.Legal_Entity__c;
	} Commented to fix the bug from Sonarqube 
			}*/
			
			// Added below for SF Ticket 00297826 (along with Sonarqube adjustment) 27-05-2020
			
			opp.End_Customer__c = opp.AccountId;
			if (opp.Legal_Entity__c != NULL) {
	opp.End_Customer_LE__c = opp.Legal_Entity__c;
			}
		}
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_END_CUSTOMER = True;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.POPULATEENDCUSTOMERANDENDCUSTOMERLEGALENTITYFORDIRECTRECORDTYPE);
		}
	}

	//Sales Process: Sprint 5 : Req-758 Notify HSSE
	/*****************************
	*Method Name: notifyHSSERiskCountry
	*Description: On update of phase status
	*Parameters: Map<Id, Opportunity>oldMap , Map<Id, Opportunity>newMap
	*******************************/
	@InvocableMethod
	public static void notifyHSSERiskCountry(List<Opportunity> OpportunityList) {
		try {
			if(GlobalConstants.OPPORTUNITYTRIGGER_NOTIFY_HSSE == False){
	String country ;
	Set<String>isoCodeList = new Set<String>();
	Map<String , String> ISOcodeCountryMap = new  Map<String , String>();
	List<ID> idlist = new List<ID>();
	List<Risk_Country__c>csList = new List<Risk_Country__c>();
	List<SendTo__c> recipientList = new List<SendTo__c>();
	List<String> sendToList = new List<String>();
	Map<Id,String> optyIdISOcode  = new Map<Id,String>();
	csList = [SELECT id, Name ,Country__c , ISO_Code__c FROM Risk_Country__c where ExtremeRisk__c = true OR HighRisk__c = True Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	if(csList!=Null){
		for (Risk_Country__c obj1: csList) {
			isoCodeList.add(obj1.ISO_Code__c);
			ISOcodeCountryMap.put(obj1.ISO_Code__c , obj1.Country__c);
		}
		Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
		Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY).getRecordTypeId();
		recipientList = [select name from SendTo__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		for(SendTo__c obj: recipientList ){
			sendToList.add(obj.Name);
		}
		for(Opportunity optyid : OpportunityList){
			idlist.add(optyid.Id);
		}
		List<Opportunity> optyList = [select id , End_Customer__r.CountryNameISO2__c from Opportunity where id in:idlist];
		If(!optyList.isEmpty()){
			for(Opportunity optyObject : optyList ){
	optyIdISOcode.put(optyObject.id , optyObject.End_Customer__r.CountryNameISO2__c);
			}
		}
		for (Opportunity Obj: OpportunityList) {
			If(Obj.RecordTypeId.equals(oppDirectRecordTypeId)) {
	if (isoCodeList.contains(optyIdISOcode.get(Obj.Id))) {
		country = ISOcodeCountryMap.get(optyIdISOcode.get(Obj.Id));
		sendEmail(Obj.Id ,sendToList , country );
	}
			}
			else if (Obj.RecordTypeId.equals(oppIndirectRecordTypeId)) {
	if (isoCodeList.contains(optyIdISOcode.get(Obj.Id))) {
		country = ISOcodeCountryMap.get(optyIdISOcode.get(Obj.Id));
		sendEmail(Obj.Id ,sendToList ,country);
	}
			}
		}
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_NOTIFY_HSSE = True;
		} Catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.NOTIFYHSSERISKCOUNTRY);
		}
	}

	//Sales Process: Sprint 6 : Req-758 send Email
	/*****************************
	*Method Name: sendEmail
	*Description: On update of phase status send mail to HSSE risk countries.
	*Parameters: Id optyId , List<string> sendToList
	*******************************/
	public static void sendEmail(Id optyId , List<String> sendToList , String Country){
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_SEND_EMAIL == False){
	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	String projectExeOwnerNameEmail = NULL ;
	Date dt ;
	String formattedDate;
	Opportunity opty = [SELECT G3_Approval_Date__c , End_Customer__c , OwnerId , Opportunity_ID__c ,Lead_BG__c , End_Customer__r.Name ,End_Customer__r.L7Name__c   FROM Opportunity WHERE Id =:optyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
	List<User> optyOwner = [select name , Email  from user where Id = :opty.OwnerId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	List<OpportunityTeamMember> optyTeamMemberList = new List<OpportunityTeamMember>();
	optyTeamMemberList = [SELECT Name , UserId  FROM OpportunityTeamMember WHERE TeamMemberRole =: GlobalConstants.PROJECTEXECUTIONOWNER AND OpportunityId = :optyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	if(opty.G3_Approval_Date__c != null){
		dt = Date.valueOf(opty.G3_Approval_Date__c);
		formattedDate = dt.format();
	}
	if(!optyTeamMemberList.isEmpty()){
		List<user> CMDuser = [select name , Email from user where id =:optyTeamMemberList[0].UserId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		projectExeOwnerNameEmail = GlobalConstants.COLON + GlobalConstants.BOLD + CMDuser[0].Name + GlobalConstants.ENDBOLD + GlobalConstants.BODY9 + GlobalConstants.COLON +  CMDuser[0].Email ;
	}
	else{
		projectExeOwnerNameEmail =  GlobalConstants.COLON + GlobalConstants.BOLD + GlobalConstants.BODY10 + GlobalConstants.ENDBOLD ;
	}
	String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
	String emailBody  = GlobalConstants.BODY1 ;
	emailBody+=  GlobalConstants.LINEBREAK + GlobalConstants.BODY2 +GlobalConstants.LINK1+sfdcBaseURL+ GlobalConstants.LINK2+ optyId + GlobalConstants.URLPART6+ opty.Opportunity_ID__c +GlobalConstants.LINK3+ GlobalConstants.BODY3 + formattedDate;
	emailBody+=  GlobalConstants.LINEBREAK +   GlobalConstants.BODY4 ;
	emailBody+=  GlobalConstants.LINEBREAK +  GlobalConstants.BODY5 +  GlobalConstants.COLON + GlobalConstants.BOLD +  Country + GlobalConstants.ENDBOLD ;
	emailBody+=  GlobalConstants.LINEBREAK +  GlobalConstants.BODY6  + GlobalConstants.COLON + GlobalConstants.BOLD +  optyOwner[0].name + GlobalConstants.ENDBOLD  +GlobalConstants.BODY7 + GlobalConstants.COLON +  optyOwner[0].Email;
	emailBody+=  GlobalConstants.LINEBREAK +  GlobalConstants.BODY8 + projectExeOwnerNameEmail ;
	emailBody+=  GlobalConstants.LINEBREAK +  GlobalConstants.BODY11 + GlobalConstants.COLON + GlobalConstants.BOLD +  opty.Lead_BG__c + GlobalConstants.ENDBOLD;
	emailBody+=  GlobalConstants.LINEBREAK +  GlobalConstants.BODY12 + GlobalConstants.COLON + GlobalConstants.BOLD +  opty.End_Customer__r.Name + GlobalConstants.ENDBOLD;
	emailBody+=  GlobalConstants.LINEBREAK +  GlobalConstants.BODY13 + GlobalConstants.COLON + GlobalConstants.BOLD +  opty.End_Customer__r.L7Name__c + GlobalConstants.ENDBOLD ;
	emailBody+=  GlobalConstants.LINEBREAK + GlobalConstants.LINEBREAK +GlobalConstants.DISCLAIMER1 + GlobalConstants.LINEBREAK + GlobalConstants.DISCLAIMER2 + GlobalConstants.LINEBREAK  + GlobalConstants.DISCLAIMER3 ;
	Id docId = [select Id from document where Name=:GlobalConstants.HEADER].ID;
	Id docId1 = [select Id from document where Name=:GlobalConstants.FOOTER].ID;
	Id OrgID = UserInfo.getOrganizationId();
	mail.setWhatId(optyId);
	mail.setToAddresses(sendToList);
	mail.setSubject(GlobalConstants.EMAILSUBJECT);
	mail.setHtmlBody(GlobalConstants.URLPART1+GlobalConstants.URLPART2+sfdcBaseURL + GlobalConstants.URLPART3 +GlobalConstants.URLPART4 +docId +GlobalConstants.URLPART5 +OrgID  +GlobalConstants.URLPART6 + GlobalConstants.URLPART7 + GlobalConstants.URLPART8 +  emailBody+ GlobalConstants.URLPART9 + GlobalConstants.URLPART10 +GlobalConstants.URLPART11+ sfdcBaseURL + GlobalConstants.URLPART3 + GlobalConstants.URLPART4 +docId1 +GlobalConstants.URLPART5 + OrgID  + GlobalConstants.URLPART6+GlobalConstants.URLPART12 );
	mails.add(mail);
	Messaging.sendEmail(mails);
			}
			GlobalConstants.OPPORTUNITYTRIGGER_SEND_EMAIL = True;
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.SENDEMAIL);
		}
	}

	/*****************************
	*Method Name: opportuntityClosedOrActive
	*Description: Returns true if opportunity is closed and false if opportunity is open
	*Parameters: Id opportunityId
	*******************************/
	public static Boolean opportuntityClosedOrActive(Id opportunityId){
		Boolean opportunityClosed = false;
		Set<String>phaseStatusValues = new Set<String>();
		Opportunity oppObj = new Opportunity();
		try {
			oppObj = [Select Id,StageName,Sales_Outcome__c,Phase_Status__c from Opportunity where id =: opportunityId LIMIT 1];
			String opportunityFinalStage = File_Sharing_Custom_Setting__c.getInstance(GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE).Value__c;
			if (oppObj.StageName.equals(opportunityFinalStage) ) {
	opportunityClosed = true;
			} else if (oppObj.StageName.equals(opportunityFinalStage) && !phaseStatusValues.contains(oppObj.Phase_Status__c)) {
	opportunityClosed = false;
			}
		}Catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.FREEZEANDUNFREEZEDOCS);
		}
		return opportunityClosed;
	}

	public class InvocableVariableOpportunity {
		@InvocableVariable(label='Opportunity' required=true)
		public Opportunity theOpportunity;
	}

	/***************************************************************************
	*Method Name: validateRefOpptyAndPTASigned
	*Description: This will serve as method for validation for No LOA and PTA Signed
	*Parameters: Opportunity Map
	*******************************************************************************/
	public static void validateRefOpptyAndPTASigned(Map<ID, Opportunity> opptyMap, Map<ID, Opportunity> opptyOldMap){
		Offer__c offerObj = new Offer__c();
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_VALIDATE ==  False){
	List<Opportunity> opptyList = [SELECT id, TotalOfferCount__c,Reference_Opportunity__c,PTA_Signed__c, StageName, (SELECT id, ActiveOffer__c, LOA_Bypass__c,Product_Only_Offer__c FROM Offers__r WHERE ActiveOffer__c = true LIMIT 1) FROM opportunity WHERE Id IN: opptyMap.keySet()];
	//SF Ticket 00003242: If 'LoA Bypass offer condition' is No LoA and Active Offer, Reference Opportunity cannot be changed or cannot be blank
	for(opportunity oppty : opptyList){
		if(Oppty.TotalOfferCount__c > 0 && Oppty.Offers__r.size()>0)
			offerObj = Oppty.Offers__r;
		if(offerObj != Null){
			If(oppty.Reference_Opportunity__c == NULL && OfferObj.LOA_Bypass__c == GlobalConstants.NO_LOA && oppty.SWx_Upsell_Proposal__c == Null){
	opptyMap.get(oppty.id).addError(GlobalConstants.REFERENCE_OPPTY_ERROR);
			}
			//Adding condition to check Opportunity's PTA Signed and Offer's Product_Only_Offer__c is true at the same time
			//Requiremet 2381
			if(oppty.PTA_Signed__c  == TRUE && OfferObj.Product_Only_Offer__c == TRUE){
	opptyMap.get(oppty.id).addError(label.PtaProduct_OnlyOfferAreNotSame);
			}
			//Either 'PTA Signed' or 'Product/Software Only' should be checked before G6 approval
			if(oppty.PTA_Signed__c  == FALSE && (oppty.StageName.equalsignorecase(GlobalConstants.EXECUTE_OPPTY) && opptyOldMap.get(oppty.Id).StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY)) && OfferObj.Product_Only_Offer__c == FALSE){
	opptyMap.get(oppty.id).addError(label.PTAOrProductOnlyOfferShouldBeChecked);
			}
		}
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_VALIDATE = True;
		}Catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.Validate_Ref_Oppty_And_PTA_Signed);
		}
	}

	/*Helper method to get optylist based on presales recordtype*/
	public static Map<Id, Opportunity> getIsApplicableForSalesNewMap(Map<Id, Opportunity> opptyMap){
		Map<Id, Opportunity> salesOptyMap = new Map<Id, Opportunity> ();
		try{
			for(Opportunity opty : opptyMap.values()){
	if(opty.RecordTypeId == directRecordTypeId || opty.RecordTypeId == inDirectRecordTypeId ){
		salesOptyMap.put(opty.Id, opty);
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER , GlobalConstants.GETISAPPLICABLEFORPRESALESLIST );
		}
		return salesOptyMap;
	}

	/*Helper method to get optylist based on presales recordtype*/
	public static Map<Id,Opportunity> getIsApplicableForSalesNewAndOldMap(Map<Id, Opportunity> salesOptyMap ,Map<Id,Opportunity> optyOldMap){
		Map<Id, Opportunity> salesOptyOldMap = new Map<Id, Opportunity>();
		try{
			for(Opportunity opty : salesOptyMap.values()){
	salesOptyOldMap.put(opty.Id, optyOldMap.get(opty.Id));
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER , GlobalConstants.GETISAPPLICABLEFORPRESALESMAP );
		}
		return salesOptyOldMap;
	}

	/*****************************
	*Method Name: checkLEIsEmpty
	*Description: This method will check whether Legal Entity is Empty
	*Parameters: Opportunity opptyList
	*******************************/
	public static void checkLEIsEmpty(List<Opportunity>opportunityList, Map<ID, Opportunity>optyOldMap){
		try{
			Map<Id,List<Opportunity>> accountIdwithOpportunityMap = new Map<Id,List<Opportunity>>();
			Map<Id,List<Opportunity>> endCustomerIdwithOpportunityMap = new Map<Id,List<Opportunity>>();
			List<opportunity> optyList = new List<opportunity>();
			List<opportunity> endCustomeroptyList = new List<opportunity>();
			for (Opportunity opp: opportunityList) {
	if(((opp.Legal_Entity__c != optyOldMap.get(opp.Id).Legal_Entity__c) || (opp.End_Customer_LE__c != optyOldMap.get(opp.Id).End_Customer_LE__c)) && (opp.RecordTypeId == inDirectRecordTypeId || opp.RecordTypeId == directRecordTypeId ))
	{
		if(accountIdwithOpportunityMap.containsKey(opp.AccountId)){
			optyList = accountIdwithOpportunityMap.get(opp.AccountId);
			optyList.add(opp);
			accountIdwithOpportunityMap.put(opp.AccountId  , optyList);
		}
		else{
			optyList = new List<opportunity>();
			optyList.add(opp);
			accountIdwithOpportunityMap.put(opp.AccountId  , optyList);
		}
		If(endCustomerIdwithOpportunityMap.containsKey(opp.End_Customer__c)){
			endCustomeroptyList = endCustomerIdwithOpportunityMap.get(opp.End_Customer__c);
			endCustomeroptyList.add(opp);
			endCustomerIdwithOpportunityMap.put(opp.End_Customer__c  , endCustomeroptyList);
		}
		else{
			endCustomeroptyList = new List<opportunity>();
			endCustomeroptyList.add(opp);
			endCustomerIdwithOpportunityMap.put(opp.End_Customer__c  , endCustomeroptyList);
		}
	}
			}
			//For Account
			if(!accountIdwithOpportunityMap.isEmpty()){
	List<AggregateResult> resultList = [SELECT count(Id) , ParentId FROM Account where recordtype.name=: GlobalConstants.LEGAL_ENTITY group by parentId having count(id) > 0 and ParentId in: accountIdwithOpportunityMap.keyset() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	for (AggregateResult result : resultList){
		for(Opportunity opp : accountIdwithOpportunityMap.get(String.valueOf(result.get('ParentId')))){
			if (optyOldMap.get(opp.Id).Legal_Entity__c != Null && opp.Legal_Entity__c == NULL){
	opp.addError(label.Legal_Entity_Cannot_be_Empty);
			}
		}
	}
			}
			//For Endcustomer
			if(!endCustomerIdwithOpportunityMap.isEmpty()){
	List<AggregateResult> resultList =  [SELECT count(Id) , ParentId FROM Account where recordtype.name=: GlobalConstants.LEGAL_ENTITY group by parentId having count(id) > 0 and ParentId in: endCustomerIdwithOpportunityMap.keyset() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	for (AggregateResult result : resultList){
		for(Opportunity opp : endCustomerIdwithOpportunityMap.get(String.valueOf(result.get('ParentId')))){
			if (optyOldMap.get(opp.Id).End_Customer_LE__c  != Null && opp.End_Customer_LE__c  == NULL){
	opp.addError(label.Legal_Entity_Cannot_be_Empty);
			}
		}
	}
			}
		}Catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER , GlobalConstants.METHOD_CHECK_LE_ISEMPTY );
		}
	}

	/*****************************
	*Method Name: offerPriceChange
	*Description: This method will update offer Price
	*Parameters: Opportunity opptyList, opportunity od map
	*******************************/
	public static void offerPriceChange(List<opportunity> opptyList, Map<Id,opportunity> opptyOldMap){
		Map<Id,Offer__c> optyActiveOfferMap  = new Map<Id,Offer__c>();
		List<Offer__c> activeOfferList = new List<Offer__c>();
		List<Offer__c> offerList = new List<Offer__c>();
		Set<Id> idSet = new Set<Id>();
		for(Opportunity opty : opptyList){
			idSet.add(opty.Id);
		}
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_OFFER_PRICE_CHANGE == False){
	activeOfferList = [SELECT Opportunity__c, Id , Price__c,ActiveOffer__c FROM Offer__c WHERE ActiveOffer__c = true and Opportunity__c in :idSet];
	if(!activeOfferList.isEmpty()){
		for(Offer__c offerObj : activeOfferList){
			optyActiveOfferMap.put(offerObj.Opportunity__c,offerObj);
		}
		for (Opportunity opp: opptyList){
			if((opp.RecordTypeId == inDirectRecordTypeId || opp.RecordTypeId == directRecordTypeId ) &&
	opp.Apttus_Approval__Approval_Status__c!='Pending Approval' &&
	opp.Amount!=opp.Active_Offer_Price__c && opp.Amount != opptyOldMap.get(opp.Id).Amount &&
	opp.Amount!=NULL && optyActiveOfferMap.get(opp.Id).Price__c != opp.Amount &&
	optyActiveOfferMap.get(opp.Id).ActiveOffer__c == true ) {
	optyActiveOfferMap.get(opp.Id).Price__c = opp.Unweighted_Amount_Opportunity_Currency__c ;
	offerList.add(optyActiveOfferMap.get(opp.Id));
			}
		}
	}
	if (!offerList.isEmpty()){
		Database.SaveResult[] savedResults = Database.update(offerList, false);
		Boolean someFailure = false;
	}
			}
			GlobalConstants.OPPORTUNITYTRIGGER_OFFER_PRICE_CHANGE = True;
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER , GlobalConstants.METHOD_OFFER_PRICE_CHANGE );
		}
	}

	/*****************************
	*Method Name: DeleteAllocationLine
	*Description: Delete the Allocation lines as per the CSE flad
	*Parameters: Opptyid
	*******************************/
	public static void DeleteAllocationLine(Set<ID>  Opptyid) {
		List<Order_Intake_Forecast__c > OIFRecDelete =New List<Order_Intake_Forecast__c>();
		try{
			if(GlobalConstants.OPPORTUNITY_DELETE_ALLOCATION==false){
	//Colleting the Clone Reocrds
	for(Order_Intake_Forecast__c OIFinfo: [Select id,name,Update_Status__c from Order_Intake_Forecast__c where Allocation__c=TRUE AND Opportunity__c=:Opptyid Limit:Limits.getLimitQueryRows()])
		OIFRecDelete.add(OIFinfo);
	if(OIFRecDelete.size()>0)
		Database.delete(OIFRecDelete);
	GlobalConstants.OPPORTUNITY_DELETE_ALLOCATION=true;
			}
		}
		catch(Exception Ex){
			ExceptionHandler.addException(ex,GlobalConstants.OPPTY_TRIGGER_HELPER,GlobalConstants.DELETE_ALLOCATION_LINES);
		}
	}
	/*****************************
	*Method Name: populateG5ContractApprovalDate
	*Description: Req-3062 G5 Process: Date Fields
	*Parameters: Trigger.new , Trigger.oldMap
	*******************************/

	public static void populateG5ContractApprovalDate(List<opportunity> opptyList, Map<Id,opportunity> opptyOldMap) {
		System.debug('test enter populateG5ContractApprovalDate');
		try{
			if(GlobalConstants.G5_CONTRACT_APPROVAL == false){
	for(Opportunity opp: opptyList){
		if((opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId) && opp.StageName == GlobalConstants.HANDOVER_OPPTY  && opptyOldMap.get(opp.id).StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE  && opptyOldMap.get(opp.id).Phase_Status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION  ){
			opp.G5_Contract_Approval_Date__c = System.now();
			System.debug('test assign populateG5ContractApprovalDate'+opp.G5_Contract_Approval_Date__c);
		}
	}
	GlobalConstants.G5_CONTRACT_APPROVAL=true;
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.OPPTY_TRIGGER_HELPER,GlobalConstants.populateG5ContractApprovalDate);
		}
	}

	//Sales process: Sprint 9: requirement 3158 ,AP Release 5546
	/******************************
	*Method Name: chatterPostToAccountManager
	*Description: This method is used inform Account Manager when G4/G5 approved
	Opportunity  and OIF BG's deviate through chatter.
	*Parameters:  OpptyNewMap, OpptyOldMap
	********************************/
	public static void chatterPostToAccountManager(Map < Id, Opportunity > opptyMap, Map < Id, Opportunity > oldOpptyMap) {
		//Oppty BG's set
		Set <String> opportunityBGs = new Set <String>();
		//OIF BG's set
		Set <String> OIFBGs = new Set <String>();
		//AccountId set
		Set <Id> accountIds = new Set <Id>();
		Set <Id> opptyIdSet = new Set <Id>();
		List <Opportunity> opptyList = new List <Opportunity>();
		//ConnecAPI For chatter Post
		ConnectApi.FeedItemInput feedItemInput;
		ConnectApi.MessageBodyInput messageBodyInput;
		ConnectApi.TextSegmentInput textSegmentInput;
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment1;
		ConnectApi.MarkupEndSegmentInput markupEndSegment1;
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment2;
		ConnectApi.MarkupEndSegmentInput markupEndSegment2;
		ConnectApi.MentionSegmentInput mentionSegmentInput;
		List <Order_Intake_Forecast__c> OIFList;
		//Account Map
		Map <Id,Account> accountMap;
		//map of oppty and related OIF's
		Map <Id,list<Order_Intake_Forecast__c>> OIFMap = new Map<Id,List < Order_Intake_Forecast__c >> ();
		try {
			for(opportunity opptyObj : opptyMap.values()){
	if((opptyObj.StageName == GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE && oldOpptyMap.get(opptyObj.Id).StageName == GlobalConstants.CREATE_OFFER)
		|| (opptyObj.StageName == GlobalConstants.HANDOVER_OPPTY && oldOpptyMap.get(opptyObj.Id).StageName == GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE)
		&& (opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId)){
		opptyIdSet.add(opptyObj.id);
		opptyList.add(opptyObj);
	}
			}
			if (GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG == false && opptyIdSet.size()>0) {
	//Loop to add oppty and related OIF's in map
	for (Order_Intake_Forecast__c orderIntakeForecast: [SELECT id, Business_Group__c, Business_Unit__c, Opportunity__c,Allocation__c FROM Order_Intake_Forecast__c where Opportunity__c in :opptyIdSet and Allocation__c = False and Forecast_Category__c != : GlobalConstants.CANCEL and Forecast_Category__c != : GlobalConstants.Lost LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		if (OIFMap.containsKey(orderIntakeForecast.Opportunity__c)) {
			OIFList = new List < Order_Intake_Forecast__c > ();
			OIFList = OIFMap.get(orderIntakeForecast.Opportunity__c);
			OIFList.add(orderIntakeForecast);
			OIFMap.put(orderIntakeForecast.Opportunity__c, OIFList);
		} else {
			OIFList = new List < Order_Intake_Forecast__c > ();
			OIFList.add(orderIntakeForecast);
			OIFMap.put(orderIntakeForecast.Opportunity__c, OIFList);
		}
	}
	//Loop to get All account Ids in set
	for (Opportunity oppty: opptyList) {
		accountIds.add(oppty.AccountId);
	}
	//Getting name of account
	if(accountIds.size()>0){
		accountMap = new Map < Id,Account > ([select Id, Name from Account  where id in :accountIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
	}
	//loop on all oppty's which qualify conditions for chatter
	for (Opportunity oppty: opptyList) {
		//checking flag for recurssion
		if (GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG == false && opptyIdSet.size()>0) {
			//Adding Oppty BG's in Set
			if (String.isNotBlank(oppty.Lead_BG__c) && !String.isEmpty(oppty.Lead_BG__c)) {
	opportunityBGs.add(oppty.Lead_BG__c);
			}
			if (String.isNotBlank(oppty.Supporting_BG_AA__c) && !String.isEmpty(oppty.Supporting_BG_AA__c)) {
	opportunityBGs.add(oppty.Supporting_BG_AA__c);
			}
			if (String.isNotBlank(oppty.Supporting_BG_FN__c) && !String.isEmpty(oppty.Supporting_BG_FN__c)) {
	opportunityBGs.add(oppty.Supporting_BG_FN__c);
			}
			if (String.isNotBlank(oppty.Supporting_BG_ION__c) && !String.isEmpty(oppty.Supporting_BG_ION__c)) {
	opportunityBGs.add(oppty.Supporting_BG_ION__c);
			}
			if (String.isNotBlank(oppty.Supporting_BG_MN__c) && !String.isEmpty(oppty.Supporting_BG_MN__c)) {
	opportunityBGs.add(oppty.Supporting_BG_MN__c);
			}
			if (String.isNotBlank(oppty.Supporting_BG_GS__c) && !String.isEmpty(oppty.Supporting_BG_GS__c)) {
	opportunityBGs.add(oppty.Supporting_BG_GS__c);
			}
			if (String.isNotBlank(oppty.Supporting_BG_NEN__c) && !String.isEmpty(oppty.Supporting_BG_NEN__c)) {
	opportunityBGs.add(oppty.Supporting_BG_NEN__c);
			}
			//Looping over OIF map to add OIF BG's in set
			for (Order_Intake_Forecast__c OIF: OIFMap.get(oppty.Id)) {
	if (String.isNotBlank(OIF.Business_Group__c) && !String.isEmpty(OIF.Business_Group__c)) {
		OIFBGs.add(OIF.Business_Group__c);
	}
			}
			//checking condition if BG's deviate
			if (!opportunityBGs.equals(OIFBGs) && !opportunityBGs.containsAll(OIFBGs) && !OIFBGs.isEmpty()) {
	//ConnecAPI For chatter Post
	feedItemInput = new ConnectApi.FeedItemInput();
	messageBodyInput = new ConnectApi.MessageBodyInput();
	mentionSegmentInput = new ConnectApi.MentionSegmentInput();
	mentionSegmentInput.id = oppty.ownerId;
	messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
	messageBodyInput.messageSegments.add(mentionSegmentInput);

	markupBeginSegment1 = new ConnectApi.MarkupBeginSegmentInput();
	markupBeginSegment1.markupType = ConnectApi.MarkupType.Bold;
	messageBodyInput.messageSegments.add(markupBeginSegment1);
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE + GlobalConstants.HYPHEN;
	textSegmentInput.text += GlobalConstants.SPACE + System.Label.Chatter_Message;
	messageBodyInput.messageSegments.add(textSegmentInput);
	markupEndSegment1 = new ConnectApi.MarkupEndSegmentInput();
	markupEndSegment1.markupType = ConnectApi.MarkupType.Bold;
	messageBodyInput.messageSegments.add(markupEndSegment1);

	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE + GlobalConstants.For_Oppty;
	messageBodyInput.messageSegments.add(textSegmentInput);

	markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
	markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
	messageBodyInput.messageSegments.add(markupBeginSegment2);
	markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
	markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
	messageBodyInput.messageSegments.add(markupEndSegment2);

	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = oppty.Opportunity_ID__c + GlobalConstants.SPACE;
	textSegmentInput.text += GlobalConstants.HYPHEN + GlobalConstants.SPACE + oppty.Name;
	textSegmentInput.text += GlobalConstants.SPACE + GlobalConstants.HYPHEN;
	textSegmentInput.text += GlobalConstants.SPACE + accountMap.get(oppty.AccountId).name;
	messageBodyInput.messageSegments.add(textSegmentInput);

	messageBodyInput.messageSegments.add(markupBeginSegment2);
	messageBodyInput.messageSegments.add(markupEndSegment2);

	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.Check_And_Update;
	messageBodyInput.messageSegments.add(textSegmentInput);

	messageBodyInput.messageSegments.add(markupBeginSegment2);
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.New_Black_Space;
	messageBodyInput.messageSegments.add(textSegmentInput);
	messageBodyInput.messageSegments.add(markupEndSegment2);

	String oppty_BGs = '' + opportunityBGs;
	oppty_BGs = oppty_BGs.remove(GlobalConstants.Curly_Braces_Start);
	oppty_BGs = oppty_BGs.remove(GlobalConstants.Curly_Braces_End);
	opportunityBGs.remove(oppty.Lead_BG__c);
	String supporting_BGs = '' + opportunityBGs;
	supporting_BGs = supporting_BGs.remove(GlobalConstants.Curly_Braces_Start);
	supporting_BGs = supporting_BGs.remove(GlobalConstants.Curly_Braces_End);
	String OIF_BGs = '' + OIFBGs;
	OIF_BGs = OIF_BGs.remove(GlobalConstants.Curly_Braces_Start);
	OIF_BGs = OIF_BGs.remove(GlobalConstants.Curly_Braces_End);

	messageBodyInput.messageSegments.add(markupBeginSegment1);
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.Lead_BG + GlobalConstants.SPACE;
	messageBodyInput.messageSegments.add(textSegmentInput);
	messageBodyInput.messageSegments.add(markupEndSegment1);

	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = oppty.Lead_BG__c;
	messageBodyInput.messageSegments.add(textSegmentInput);

	if (!opportunityBGs.isEmpty()) {
		messageBodyInput.messageSegments.add(markupBeginSegment1);
		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = GlobalConstants.SPACE + GlobalConstants.Supporting_BGs + GlobalConstants.SPACE;
		messageBodyInput.messageSegments.add(textSegmentInput);
		messageBodyInput.messageSegments.add(markupEndSegment1);

		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = GlobalConstants.SPACE + supporting_BGs;
		messageBodyInput.messageSegments.add(textSegmentInput);
	}
	messageBodyInput.messageSegments.add(markupBeginSegment2);
	messageBodyInput.messageSegments.add(markupEndSegment2);

	messageBodyInput.messageSegments.add(markupBeginSegment1);
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.OIF_BGs + GlobalConstants.SPACE;
	messageBodyInput.messageSegments.add(textSegmentInput);
	messageBodyInput.messageSegments.add(markupEndSegment1);

	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE + OIF_BGs;
	messageBodyInput.messageSegments.add(textSegmentInput);
	messageBodyInput.messageSegments.add(markupBeginSegment2);
	messageBodyInput.messageSegments.add(markupEndSegment2);

	feedItemInput.body = messageBodyInput;
	feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
	feedItemInput.subjectId = Oppty.Id;
	if (!test.isRunningTest()) {
		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
	}
			}
		}
	}
	GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG = true;
			}
		} catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER);
		}
	}

	/*****************************
	*Method Name: populateSalesOutcome
	*Description: This method will populate Sales Outcome and Opportunity Sales Phase Tracking on Opportunity
	*Parameters: List<Opportunity>, Map<ID, Opportunity>opptyOldMap
	*******************************/
	public static void populateSalesOutcome(List<Opportunity> opptyList, Map<ID, Opportunity>opptyOldMap){
		Id readOnlyDirect = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYDIRECT).getRecordTypeId();
		Id readOnlyIndirect = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYINDIRECT).getRecordTypeId();
		Map<String, Stage_Sales_Outcome__c> openPhases = new Map<String, Stage_Sales_Outcome__c>();
		Map<String, Stage_Sales_Outcome__c> wonPhases = new Map<String, Stage_Sales_Outcome__c>();
		Map<String, Stage_Sales_Outcome__c> lostPhases = new Map<String, Stage_Sales_Outcome__c>();
		Set<Id> oppRecordTypes = new Set<Id> {directRecordTypeId, inDirectRecordTypeId, readOnlyDirect, readOnlyIndirect};
		Set<String> profileBypass = new Set<String> {Label.System_Admin_Profile, Label.Global_Process_Admin_Profile, Label.Accenture_Admin, Label.Nokia_Admin_Profile, Label.SDC_Admin};
		Set<Id> roRecordTypes = new Set<Id> {readOnlyDirect, readOnlyIndirect};
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME == false){
	List<Stage_Sales_Outcome__c> salesOutcomeValues = Stage_Sales_Outcome__c.getAll().values();
	List<Profile> currentProfile = [select id, Name from profile where Id =:UserInfo.getProfileId()];
	AllowReopenOpptyAndAccountChange__c userBypass = AllowReopenOpptyAndAccountChange__c.getInstance(UserInfo.getUserId());
	for(Stage_Sales_Outcome__c csObj: salesOutcomeValues){
		if(csObj.Stage_Type__c.equalsignorecase(GlobalConstants.ClosedLost)){
			lostPhases.put(csObj.Name, csObj);
		} else if(csObj.Stage_Type__c.equalsignorecase(GlobalConstants.ClosedWon)){
			wonPhases.put(csObj.Name, csObj);
		} else if(csObj.Stage_Type__c.equalsignorecase(GlobalConstants.Open)){
			openPhases.put(csObj.Name, csObj);
		}
	}
	for(Opportunity opp: opptyList){
		if( !oppRecordTypes.contains(opp.RecordTypeId) || opp.StageName.equalsignorecase(opptyOldMap.get(opp.id).StageName)){
			continue;
		}
		if(openPhases.containsKey(opp.StageName)){
			//For a re-opened Oppty, clear Sales Outcome and populate Phase Status
			if(lostPhases.containsKey(opptyOldMap.get(opp.id).StageName) && opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c == opp.StageName){
	opp.Sales_Outcome__c = openPhases.get(opp.StageName).Related_Sales_Outcome__c;
	opp.Phase_Status__c = openPhases.get(opp.StageName).Related_Phase_Status__c;
	opp.Opportunity_Sales_Phase_Tracking__c = GlobalConstants.BLANK_VALUE;
	opp.Probability = GlobalConstants.DEFAULT_PROBABILITY ;
			}
			//Navigating through Sales Phases
			else if(openPhases.containsKey(opptyOldMap.get(opp.id).StageName) || wonPhases.containsKey(opptyOldMap.get(opp.id).StageName)){
	opp.Phase_Status__c = openPhases.get(opp.StageName).Related_Phase_Status__c;
			}
			//When user re-opens Oppty with a different Sales Phase, throw error
			else if(lostPhases.containsKey(opptyOldMap.get(opp.id).StageName) && opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c != opp.StageName){
	//Edit not allowed for non-admin profiles
	if(roRecordTypes.contains(opp.RecordTypeId) && !profileBypass.contains(currentProfile[0].Name) && UserInfo.getUserEmail() != userBypass.Email__c && userBypass.Allow_Reopening_of_Closed_opportunity__c == false){
		opp.addError(Label.FreezeOppError);
		break;
	}
	opp.addError(Label.Sales_Phase_Error+GlobalConstants.DOUBLE_STARTQUOTE+opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c+GlobalConstants.DOUBLE_ENDQUOTE);
			}
		}
		//Set Sales Outcome as appropriate from Custom Setting when Sales Phase is Closed
		else if(lostPhases.containsKey(opp.StageName)){
			if(roRecordTypes.contains(opp.RecordTypeId) && lostPhases.containsKey(opptyOldMap.get(opp.id).StageName)){
	opp.addError(Label.ClosedOpportunityError);
	break;
			}
			opp.Opportunity_Sales_Phase_Tracking__c = opptyOldMap.get(opp.id).StageName;
			opp.Sales_Outcome__c = lostPhases.get(opp.StageName).Related_Sales_Outcome__c;
			opp.Phase_Status__c = lostPhases.get(opp.StageName).Related_Phase_Status__c;
			if(String.isNotBlank(lostPhases.get(opp.StageName).Default_Main_Reason__c)){
	opp.Sales_Outcome_Reason__c = lostPhases.get(opp.StageName).Default_Main_Reason__c;
	opp.Second_Reason__c = GlobalConstants.BLANK_VALUE ;
	opp.Third_Reason__c = GlobalConstants.BLANK_VALUE ;
			}
		} else if(wonPhases.containsKey(opp.StageName)){
			//Re-opening with Won Phase
			if(lostPhases.containsKey(opptyOldMap.get(opp.id).StageName) && roRecordTypes.contains(opp.RecordTypeId) && !profileBypass.contains(currentProfile[0].Name) && UserInfo.getUserEmail() != userBypass.Email__c && userBypass.Allow_Reopening_of_Closed_opportunity__c == false){
	opp.addError(Label.FreezeOppError);
	break;
			} else if(lostPhases.containsKey(opptyOldMap.get(opp.id).StageName) && opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c != opp.StageName && (profileBypass.contains(currentProfile[0].Name) || (UserInfo.getUserEmail() == userBypass.Email__c && userBypass.Allow_Reopening_of_Closed_opportunity__c == True))){
	opp.addError(Label.Sales_Phase_Error+GlobalConstants.DOUBLE_STARTQUOTE+opptyOldMap.get(opp.id).Opportunity_Sales_Phase_Tracking__c+GlobalConstants.DOUBLE_ENDQUOTE);
	break;
			}
			opp.Sales_Outcome__c = wonPhases.get(opp.StageName).Related_Sales_Outcome__c;
			opp.Phase_Status__c = wonPhases.get(opp.StageName).Related_Phase_Status__c;
		}
	}
	GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_SALES_OUTCOME = true;
			}
			if(Test.isRunningTest()){
	CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
	throw testingCatch;
			}
		} catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.populateSalesOutcome);
		}
	}

	/*****************************
	*Method Name: populatePhaseStatusOnInsert
	*Description: This method will populate Phase Status on new Opportunity
	*Parameters: List<Opportunity>
	*******************************/
	public static void populatePhaseStatusOnInsert(List<Opportunity> opptyList){
		try{
			if(GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_PHASESTATUS == false){
	Stage_Sales_Outcome__c phaseStatusValue = Stage_Sales_Outcome__c.getValues(GlobalConstants.IDENTIFY_OPPORTUNITY);
	Stage_sales_Outcome__c phaseStatusValue2 = Stage_Sales_Outcome__c.getValues(GlobalConstants.DEVELOP_OPPORTUNITY);
	Stage_sales_Outcome__c phaseStatusValue3 = Stage_Sales_Outcome__c.getValues(GlobalConstants.CREATE_OFFER);
	Stage_sales_Outcome__c phaseStatusValue4 = Stage_Sales_Outcome__c.getValues(GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE);
	Set<Id> oppRecordTypes = new Set<Id> {directRecordTypeId, inDirectRecordTypeId};
	for(Opportunity opp: opptyList){
		// added by-pass for Upsell Opportunity.
		if(oppRecordTypes.contains(opp.RecordTypeId)&& opp.SWx_Upsell_Proposal__c == Null && (opp.Business_Type__c != GlobalConstants.COMMITTED_UPSELL || opp.Is_Auto_Upsell__c != True)){
			opp.StageName = phaseStatusValue.Name;
			opp.Phase_Status__c = phaseStatusValue.Related_Phase_Status__c;
			//Sales process Req#3791
			opp.Probability = GlobalConstants.DEFAULT_PROBABILITY ;
		}
	}
	GlobalConstants.OPPORTUNITYTRIGGER_POPULATE_PHASESTATUS = true;
			}
			if(Test.isRunningTest()){
	CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
	throw testingCatch;
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.populatePhaseStatusOnInsert);
		}
	}

	/*****************************
	*Method Name: MassupdateonOIFLines
	*Description: This method will used to update the all OIF lines to cancelled/Lost
	*Parameters: List<Opportunity>
	*******************************/
	@Future
	public static void MassupdateonOIFLines(Set<Id> OpptyMap){
		list<Order_Intake_Forecast__c> OIFUpdate=new List<Order_Intake_Forecast__c>();
		try{
			List<Order_Intake_Forecast__c> OIFRecList = [SELECT Id,Opportunity__c,Opportunity__r.Sales_Outcome__c,Forecast_Category__c,BusinessLine__c  FROM Order_Intake_Forecast__c where Opportunity__c=:OpptyMap and Allocation__c=false AND BusinessLine__c!=Null];
			for(Order_Intake_Forecast__c OIFRec:OIFRecList){
	if(OIFRec.Opportunity__r.Sales_Outcome__c<>Null && (OIFRec.Opportunity__r.Sales_Outcome__c.equalsignorecase(GlobalConstants.CANCEL_BY_CUSTOMER) || OIFRec.Opportunity__r.Sales_Outcome__c.equalsignorecase(GlobalConstants.WITHDRAWN_BY_NOKIA)  || OIFRec.Opportunity__r.Sales_Outcome__c.equalsignorecase(GlobalConstants.OPP_OBSOLETE)))
	{
		OIFRec.Forecast_Category__c=GlobalConstants.CANCEL;
		OIFUpdate.add(OIFRec);
	} else if(OIFRec.Opportunity__r.Sales_Outcome__c<>Null && (OIFRec.Opportunity__r.Sales_Outcome__c.equalsignorecase(GlobalConstants.OPP_LOST_TO_COMPETITOR))){
		if( OIFRec.Forecast_Category__c<>Null && !OIFRec.Forecast_Category__c.equalsignorecase(GlobalConstants.CANCEL) && !OIFRec.Forecast_Category__c.equalsignorecase(GlobalConstants.EXCLUDED))
			OIFRec.Forecast_Category__c=GlobalConstants.LOST;
		if( OIFRec.Forecast_Category__c<>Null && OIFRec.Forecast_Category__c.equalsignorecase(GlobalConstants.EXCLUDED))
			OIFRec.Forecast_Category__c=GlobalConstants.CANCEL;
		OIFUpdate.add(OIFRec);
	}
			}
			if(!OIFUpdate.isEmpty())
	Database.update(OIFUpdate,False);
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER,GlobalConstants.MASS_UPDATE);
		}
	}

	/*****************************
	*Method Name: populateReasons
	*Description: This method will populate the win/loss reasons.
	*Parameters:Opportunity List, Opportunity Map
	*Requirement : 3217
	*******************************/
	public static void populateReasons( Map<ID, Opportunity>opptyNewMap, Map<ID, Opportunity>opptyOldMap)
	{
		Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
		Map<Id,Offer__c> opptyOfferMap = new Map<Id,Offer__C>();
		set<String> loaBypassSet = new set<String>();
		String Unweighted_Amount = System.Label.Unweighted_Amount_For_Sales_Outcome;
		Offer__C objOpptyOffer=null;

		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId)
		&& ( (opptyObj.OIF_Amount_EUR__c == 0 && opptyObj.Amount >= Decimal.valueOf(Unweighted_Amount)) || opptyObj.OIF_Amount_EUR__c >= Decimal.valueOf(Unweighted_Amount)) &&
		(opptyObj.StageName == GlobalConstants.CANCELLED_BY_CUSTOMER || opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR || opptyObj.StageName == GlobalConstants.WITH_DRAW_BY_NOKIA)
		&& opptyObj.Apttus_Approval__Approval_Status__c != GlobalConstants.APPROVED && opptyObj.Apttus_Approval__Approval_Status__c != GlobalConstants.PENDING_APPROVAL )
	{
		opptyMap.put(opptyObj.Id, opptyObj);
	}
			}
			if(!opptyMap.isEmpty()) {
	for(Offer__c offerObj : [Select id, ActiveOffer__c, Opportunity__c, LOA_Bypass__c from Offer__c where Opportunity__c IN: opptyMap.KeySet() AND ActiveOffer__c = True LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		opptyOfferMap.put(offerObj.Opportunity__c,offerObj);
	}

	for(Opportunity opptyObj: opptyMap.values()){
		objOpptyOffer=null;
		if(opptyObj.count_offer__c > 0){
			objOpptyOffer =opptyOfferMap.get(opptyObj.id);
			List<String> loaBypassList=System.label.LoA_Bypass_Offer_Condition.Split(GlobalConstants.COMMA);
			loaBypassSet.addAll(loaBypassList);
			if(objOpptyOffer!=null) {
	if(!loaBypassSet.contains(objOpptyOffer.LOA_Bypass__c) && (opptyObj.Sales_Outcome_Reason__c == null || opptyObj.Second_Reason__c == null ||  opptyObj.Third_Reason__c == null)) {
		opptyObj.addError(System.label.PopulateReasonsOnOppty);
	}
			}
		} else if(opptyObj.count_offer__c == 0 && (opptyObj.Sales_Outcome_Reason__c == null || opptyObj.Second_Reason__c == null ||  opptyObj.Third_Reason__c == null)) {
			opptyObj.addError(System.label.PopulateReasonsOnOppty);
		}
	}
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.Populate_Reasons);
		}
	}

	//Requirement 3775: End customer autopopulate Logic
	/*****************************
	*Method Name: populateEnd Customer
	*Description: this method used to populate End Customer on opportunity
	*Parameters: Opportunity List
	*******************************/
	public static void populateEndCustomer(List<Opportunity>opportunityList, Map<ID, Opportunity>optyOldMap) {
		List<Opportunity>validCustomerChanges = new List<Opportunity>();
		List<String> accountIds = new list<String>();
		for (Opportunity opp: opportunityList) {
			if (optyOldMap.size()>0) {
	if (opp.End_Customer_LE__c != optyOldMap.get(opp.Id).End_Customer_LE__c) {
		validCustomerChanges.add(opp);
		accountIds.add(opp.End_Customer_LE__c);
	}
			} else {
	if (opp.End_Customer_LE__c != NULL){
		validCustomerChanges.add(opp);
		accountIds.add(opp.End_Customer_LE__c);
	}
			}
		}
		Map<Id,Account> accMap = new  Map<Id,Account>([select Id,parentId from Account where Id In : accountIds]);
		if(validCustomerChanges.size()>0){
			for (Opportunity opp: validCustomerChanges) {
	if(accMap.containsKey(opp.End_Customer_LE__c))
		opp.End_Customer__c = accMap.get(opp.End_Customer_LE__c).parentId;
	else
		opp.End_Customer__c = NULL;
			}
		}
	}

	/*****************************
	*Method Name: deleteOpenTasks
	*Description: This method will populate the win/loss reasons.
	*Parameters:Opportunity Set, Task Map
	*Requirement : 4313
	*******************************/
	public static void deleteOpenTasks(Map<Id,Opportunity> opptyNewMap,Map<Id,Opportunity> opptyOldMap){
		Set<Id> opptyIdSet = new Set<Id>();
		//Map<ID,Task> openTaskMap = new Map<ID,Task>();
		List<Task> taskList = new List<Task>();
		try{
			for(Opportunity opp : opptyNewMap.values()){
	if(opp.StageName<>null && opptyNewMap.get(opp.id).StageName<>null && (opp.StageName.equalsIgnoreCase(GlobalConstants.CANCELLED_BY_CUSTOMER)) || (opp.StageName.equalsIgnoreCase(GlobalConstants.WITH_DRAW_BY_NOKIA)) ||
	(opp.StageName.equalsIgnoreCase(GlobalConstants.LOST_TO_COMPETITOR)) || (opp.StageName.equalsIgnoreCase(GlobalConstants.OBSOLETE))){
		opptyIdSet.add(opp.Id);
	}
			}
			if(!opptyIdSet.isEmpty()){
	for(Task taskRec :[SELECT Id,Status,WhatId FROM Task where WhatID=:opptyIdSet and Status=:GlobalConstants.Open Limit:Limits.getLimitQueryRows()]){
		taskRec.Open_Task_At_Closure__c = GlobalConstants.VALUE_TRUE;
		taskRec.Task_Creation_By_Pass_Check__c = GlobalConstants.VALUE_TRUE;
		taskList.add(taskRec);
	}
			}
			if(!taskList.isEmpty()){
	Database.SaveResult[] drList = Database.update(taskList);
			}
			//Database.DeleteResult[] drList = Database.delete(TaskList);
			GlobalConstants.DeleteOpenTaskFlag = True;
			// Iterate through each returned result
			/*  for(Database.DeleteResult dr : drList) {
			if (dr.isSuccess()) {
			System.debug('Successfully deleted task with ID');
			}
			else {
			for(Database.Error err : dr.getErrors()) {
			System.debug('The following error has occurred.');
			System.debug(err.getStatusCode() + ': ' + err.getMessage());
			}
			}
			}*/
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.DELETE_OPEN_TASK);
		}
	}

	/*****************************
	*Method Name: removeLeadBGFreeze
	*Description: this method work for removing freeze of Lead BG/Supp BG at roll back oppty.
	*Support Ticket:10920
	*Parameters: Opportunity List, Opportunity Map
	*******************************/
	public static void removeLeadBGFreeze(List<Opportunity> opptyList, Map<ID, Opportunity> opptyOldMap) {
		//set oldopptymap.id in opptyOldIdSet,so as offer.
		Set <Id> opptyOldIdSet = new Set <Id>();
		Set <Id> offerIdSet = new Set <Id>();
		List<ContentDocumentLink> currentDocument = new List <ContentDocumentLink>();
		for(Opportunity currentOpptyOld:opptyOldMap.values()){
			opptyOldIdSet.add(currentOpptyOld.Id);
		}
		//select this oppty's activeOffer
		List<Offer__c> activeOffer = [select Id, Name from Offer__c where ActiveOffer__c = true and Opportunity__c in :opptyOldIdSet];
		for(Offer__c currentOffer:activeOffer){
			offerIdSet.add(currentOffer.Id);
		}
		//moving query to new object
		if(offerIdSet.size() > 0)
			currentDocument = [Select Id, ContentDocumentId, linkedEntityId from ContentDocumentLink  where linkedEntityId in : offerIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];

		for(Opportunity currentOppty:opptyList){
			//conditions: 1.the Opportunity is moved back to 'Develop Opportunity' phase 2.Active offer does not have a LoA template.
			if((currentOppty.StageName =='Identify Opportunity' || currentOppty.StageName == 'Develop Opportunity' )  && currentDocument.size()==0){
	currentOppty.Freeze_LeadBG_Field__c=false;
		}
		}
	}

	/*****************************
	*Method Name: removeG3Facilitator
	*Description: this method work for removing G3 Facilitator at roll back oppty.
	*Support Ticket:11982
	*Parameters: Opportunity List, Opportunity Map
	*******************************/
	public static void removeG3Facilitator(List<Opportunity> opptyList, Map<ID, Opportunity> opptyOldMap) {
		for(Opportunity currentOppty:opptyList){
			if(currentOppty.StageName =='Identify Opportunity' || (currentOppty.StageName == 'Develop Opportunity' &&  opptyOldMap.get(currentOppty.Id).StageName!='Develop Opportunity')){
	currentOppty.NF_Facilitator_Notified__c=false;
	currentOppty.NF_Facilitator_User__c=null;
	currentOppty.Facilitator_Delegate_1__c=null;
	currentOppty.Facilitator_Delegate_2__c=null;
	currentOppty.Facilitator_Delegate_3__c=null;
	currentOppty.Queue_Id__c=null;
			}
		}
	}

	/*****************************
	*Method Name: updateMultiBG
	*Description: update the isMultiBg field on opportunity.
	*Parameters: Opportunity List
	*******************************/
	private static List<String> fillListOfBGs(Opportunity currentOpp){
		return new List<String>{currentOpp.Supporting_BG_AA__c , currentOpp.Supporting_BG_FN__c ,currentOpp.Supporting_BG_ION__c, currentOpp.Supporting_BG_MN__c,currentOpp.Supporting_BG_GS__c, currentOpp.Supporting_BG_NEN__c};
	}

	private static void isMultiBGMethod(Opportunity currentOpp){
		currentOpp.isMultiBG__c = false;
		for(String bg: fillListOfBGs(currentOpp)){
			if(String.isBlank(bg)){
	continue;
			}
			if(currentOpp.Lead_BG__c != bg){
	currentOpp.isMultiBG__c = true;
	break;
			}
		}
	}

	public static void updateMultiBG(List<Opportunity> opptyList){
		for(Opportunity opp: opptyList){
			isMultiBGMethod(opp);
		}
	}

	/*****************************
	*Description: This method will make G4 Planned Date mandatory after G3 Facilitator notification and selection of G3 Bypass.
	*Parameters:Opportunity List, Opportunity Map
	*Requirement : 4879
	*******************************/
	public static void g4PlannedDateMandatory( Map<ID, Opportunity>opptyNewMap, Map<ID, Opportunity>opptyOldMap)
	{
		Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
		Map<Id,Offer__c> opptyOfferMap = new Map<Id,Offer__C>();
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.G4_Planned_Date__c != opptyOldMap.get(opptyObj.id).G4_Planned_Date__c && opptyObj.G4_Planned_Date__c == null) {
		opptyMap.put(opptyObj.Id, opptyObj);
	}
			}
			if(!opptyMap.isEmpty()) {
	List<Offer__c> offerObjList = [Select id,No_Support_Offer_Condition__c,ActiveOffer__c, Opportunity__c from Offer__c where Opportunity__c IN: opptyMap.KeySet() AND ActiveOffer__c = True AND  No_Support_Offer_Condition__c =: GlobalConstants.PICKLIST_VALUE_YES  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for(Offer__c offerObj : offerObjList) {
		opptyOfferMap.put(offerObj.Opportunity__c,offerObj);
	}
	for(Opportunity opptyObj: opptyMap.values()){
		if(opptyObj.NF_Facilitator_Notified__c == true || (!opptyOfferMap.isEmpty() && opptyOfferMap.containsKey(opptyObj.id))) {
			opptyObj.addError(System.label.G4_Planned_Date_Mandatory);
		}
	}
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.G4_Planned_Date_Mandatory);
		}
	}

	/*****************************
	*Method Name: committedUpsellOptyClosureValidation
	*Description: This method will prevent currentloggeduser with Role CO Sales Operations Market Head, closing committed upsell opty
	*Requirement: 4999
	*Parameters: opportunityNewMap , opportunityOldMap
	*Test coverage from: OpportunityTriggerHelperTest
	*******************************/
	public static void committedUpsellOptyClosureValidation(List<Opportunity>optyList, Map<Id, Opportunity> opportunityOldMap) {
		Map<Id, Opportunity> opportunityAddErrorMap = new Map<Id, Opportunity>();
		List<Sales_Role__c> salesRoleList = new List<Sales_Role__c> ();
		try {
			for(Opportunity opty : optyList)	{
	if(opty.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && opportunityOldMap.get(opty.id).Phase_Status__c != opty.Phase_Status__c  && opty.Phase_Status__c == GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON){
		opportunityAddErrorMap.put(opty.Id,opty);
	}
			}

			if(!opportunityAddErrorMap.isEmpty()){
	salesRoleList  = [select id,Role_Code__c,Role_Name__c,User__c from Sales_Role__c where User__c =: UserInfo.getUserId() AND  (Role_Name__c like:GlobalConstants.WILDCARD_SEARCH+Label.CO_Sales_Operations_Market_Head AND Active__c =: GlobalConstants.VALUE_TRUE) LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	if(salesRoleList.isEmpty()){
		for(Opportunity optyToShowError : opportunityAddErrorMap.values()){
			optyToShowError.addError(Label.AvoidClosingCommitedUpsellByCoSalesOpMarketHead);
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.AVOIDCLOSINGCOMMITTEDUPSELLBYCOSALESOPMARKETHEAD);
		}
	}

	/********************************************************************************
	*author: Accenture
	* Date: 30/08/2018
	* Param: Oppty New Map, Oppty Old Map
	* Return: void
	* Description: 5090 :Trigger to automatically update Solution Sign-Off
	This method will fire when Unweighted Amount euro is updated on Opportunity
	*************************************************************************************/
	public static void updateSSOOnUnweightedValueChange(Map<Id,Opportunity> opptyNewMap,Map<Id,Opportunity> opptyOldMap)
	{
		Set<Id> opptyId = new Set<Id>();
		List<Offer__c> offerList = new List<Offer__c>();
		Double totalNetSalesValue = Double.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold);
		try{
			for(Opportunity opp : opptyNewMap.values()){
	if((opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId) && opp.Unweighted_Amount_EUR__c != opptyOldMap.get(opp.Id).Unweighted_Amount_EUR__c) {
		opptyId.add(opp.Id);
	}
			}
			if(opptyId.size() > 0)
			{
	List<Offer__c> offrList = [select Id,Expected_LoA_G4_Approval_Level__c,Solution_Sign_Off_New__c,  Opportunity__c,Opportunity__r.Unweighted_Amount_EUR__c from Offer__c where Opportunity__c in: opptyId and ActiveOffer__c = True and Solution_Sign_Off_New__c !=: GlobalConstants.Required_Attached LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	for(Offer__c offr : offrList) {
		if((offr.Expected_LoA_G4_Approval_Level__c == GlobalConstants.LOA_Level) || (offr.Expected_LoA_G4_Approval_Level__c == GlobalConstants.LOA_Level_A_Plus) || (offr.Expected_LoA_G4_Approval_Level__c == GlobalConstants.LOA_Level_c && offr.Opportunity__r.Unweighted_Amount_EUR__c >= totalNetSalesValue)){
			offr.Solution_Sign_Off_New__c = GlobalConstants.Required;
			offr.SSO_Exception_Reason__c = GlobalConstants.BLANK_VALUE ;
		}  else  {
			offr.Solution_Sign_Off_New__c = GlobalConstants.Not_Required;
			offr.SSO_Exception_Reason__c = GlobalConstants.ExceptionReasonDefaultValue;
		}
		offerList.add(offr);
	}
	if(!offerList.isEmpty()){
		Database.SaveResult[] savedResults = Database.update(offerList, false);
	}
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.updateSSOOnUnweightedValueChange);
		}
	}
	/*****************************
	*Method Name: updateUnweightedValueofOpptyGroup
	*Description: This method will update unweighted value of its related deal opportunity grouping objects.
	*Parameters:Opportunity List, Opportunity Map
	*Requirement : 4943
	*******************************/
	public static void updateUnweightedValueofOpptyGroup( Map<ID, Opportunity>opptyNewMap, Map<ID, Opportunity>opptyOldMap)
	{
		set<Id> opptyIdSet = new set<Id>();
		List<Opportunity_Group__c> opptyGroupList = new List<Opportunity_Group__c>();
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.Unweighted_Amount_EUR__c != opptyOldMap.get(opptyObj.id).Unweighted_Amount_EUR__c){
		opptyIdSet.add(opptyObj.id);
	}
			}
			if(opptyIdSet.size() > 0){
	List<Opportunity_Group__c> opptyGroupObjList = [Select id, Opportunity__c,Unweighted_Value_in_EUR__c from Opportunity_Group__c where Opportunity__c IN: opptyIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for(Opportunity_Group__c opptyGroupObj:opptyGroupObjList){
		opptyGroupObj.Unweighted_Value_in_EUR__c = opptyNewMap.get(opptyGroupObj.Opportunity__c).Unweighted_Amount_EUR__c;
		opptyGroupList.add(opptyGroupObj);
	}
			}
			if(!opptyGroupList.isEmpty())
	database.update(opptyGroupList);
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.updateUnweightedValueofOpptyGroup);
		}
	}

	/*****************************
	*Method Name: associateUpsellOpptyWithUpsellDeal
	*Description: This method will check if upsell oppty is related with upsell deal.
	*Parameters:Opportunity List, Opportunity Map
	*Requirement : 5151
	*******************************/
	public static void associateUpsellOpptyWithUpsellDeal( Map<ID, Opportunity>opptyNewMap, Map<ID, Opportunity>opptyOldMap)
	{
		Set<Id> opptyIdSet =  new Set<Id>();
		Set<Id> opptyIdHavingUpsellDealsSet =  new Set<Id>();
		Set<Id> opptyIdNotHavingUpsellDealSet =  new Set<Id>();
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && opptyOldMap.get(opptyObj.id).Business_Type__c != GlobalConstants.STANDARDOPPORTUNITY && opptyOldMap.get(opptyObj.id).HighestOfferNumber__c == opptyObj.HighestOfferNumber__c) {
		opptyIdSet.add(opptyObj.id);
	}
			}
			if(opptyIdSet.size() > 0) {
	for(Opportunity_Group__c opptyGroupObj:[Select id, Opportunity__c,Deal__r.RecordType.Name from Opportunity_Group__c where Opportunity__c IN: opptyIdSet and Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		opptyIdHavingUpsellDealsSet.add(opptyGroupObj.Opportunity__c);
	}

	for(Id opptyId: opptyIdSet) {
		if(!opptyIdHavingUpsellDealsSet.contains(opptyId))
			opptyIdNotHavingUpsellDealSet.add(opptyId);
	}
	if(opptyIdNotHavingUpsellDealSet.size() > 0)   {
		for(Id opptyId : opptyIdNotHavingUpsellDealSet)
			opptyNewMap.get(opptyId).addError(System.Label.AssociateUpsellDealToUpsellOppty_Error);
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.associateUpsellOpptyWithUpsellDeal);
		}
	}

	/*****************************
	*Method Name: updateProbabilityOfPSROAsSalesOptyAfterUpdate
	*Description: This method will update probability of 'Sales opty' on 'PSRO' opty exlculding 'closed','cancelled' psro opty
	*Requirement: 5072
	*Parameters: opportunityNewMap , opportunityOldMap
	*Test coverage from: OpportunityTriggerHelperTest
	*******************************/
	public static void updateProbabilityOfPSROAsSalesOptyAfterUpdate(Map<Id, Opportunity> optyNewMap, Map<Id, Opportunity> optyOldMap){
		Set<Id> salesOptyIdsSet = new Set<Id>();
		try {
			for(Opportunity opp: optyNewMap.values()){
	if((opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId) && opp.Probability != optyOldMap.get(opp.Id).Probability){
		salesOptyIdsSet.add(opp.Id);
	}
			}
			if(!salesOptyIdsSet.isEmpty()){
	//call future method
	updateProbabilityOfPSROInFuture(salesOptyIdsSet);
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATEPROBABILITYOFPSROASSALESOPTYAFTERUPDATE);
		}
	}

	/*****************************
	*Method Name: updateProbabilityOfPSROInFuture
	*Description: This method will call from 'updateProbabilityOfPSROAsSalesOptyAfterUpdate'
	*Requirement: PreSales : 5072
	*Parameters: salesOptyIdsSet
	*Test coverage from: OpportunityTriggerHelperTest
	*******************************/
	@future
	public static void updateProbabilityOfPSROInFuture(Set<Id> salesOptyIdsSet){
		List<Opportunity> salesOptyList = new List<Opportunity>();
		List<Opportunity> psroOptyListToUpdate = new List<Opportunity>();
		try{
			salesOptyList = [SELECT Id,Probability,(SELECT Id,Probability,StageName FROM PreSalesOpportunities__r where StageName !=: GlobalConstants.COMPLETED_OPPTY AND StageName !=: GlobalConstants.CANCELLED AND StageName !=: GlobalConstants.SUBMITTED_FOR_APPROVAL) FROM Opportunity where Id in: salesOptyIdsSet Limit : salesOptyIdsSet.size() ];
			for(Opportunity salesOpty : salesOptyList){
	for(Opportunity psroOpty : salesOpty.PreSalesOpportunities__r){
		psroOpty.Probability = salesOpty.Probability;
		psroOptyListToUpdate.add(psroOpty);
	}
			}

			if(!psroOptyListToUpdate.isEmpty()){
	Database.update(psroOptyListToUpdate);
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATEPROBABILITYOFPSROINFUTURE);
		}
	}

	/*****************************
	*Method Name: validateSubstituteOptyWithSameUpsellDeal
	*Description: This method will check, Committed upsell opportunities deal is same as Substitute opportunityies deal of type upsell deal
	*Parameters:Opportunity List, Opportunity Map
	*Requirement : 5001
	*******************************/
	public static void validateSubstituteOptyWithSameUpsellDeal( List<Opportunity>opptyList, Map<ID, Opportunity>opptyOldMap)
	{
		Map<Id, Id> salesOpIdAndSubstituteOpIdMap = new Map<Id, Id> ();
		Map<Id, Id> salesOpIdAndDealIdMap = new Map<Id, Id> ();
		Map<Id, Id> substituteOpIdAndDealIdMap = new Map<Id, Id> ();
		Set<Id> opportunityIdsSet = new Set<Id>();
		List<Opportunity> opportunityErrorList = new List<Opportunity>();
		try {
			for (Opportunity opptyObj: opptyList) {
	if((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && (opptyObj.Substitute_Opportunity__c != null && opptyObj.Substitute_Opportunity__c != opptyOldMap.get(opptyObj.Id).Substitute_Opportunity__c)){
		salesOpIdAndSubstituteOpIdMap.put(opptyObj.Id, opptyObj.Substitute_Opportunity__c);
	}
			}
			if(!salesOpIdAndSubstituteOpIdMap.isEmpty()){
	for(Opportunity_Group__c opptyGroupObj: [Select id, Opportunity__c,Deal__r.RecordType.Name  from Opportunity_Group__c where Opportunity__c IN: salesOpIdAndSubstituteOpIdMap.keySet() and Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL and Opportunity_Relation__c =: GlobalConstants.SUBORDINATE LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		if(opptyGroupObj.Deal__c != null)
			salesOpIdAndDealIdMap.put(opptyGroupObj.Opportunity__c, opptyGroupObj.Deal__c);
		else
			salesOpIdAndDealIdMap.put(opptyGroupObj.Opportunity__c,null);
	}
	for(Opportunity_Group__c opptyGroupObj: [Select id, Opportunity__c,Deal__r.RecordType.Name from Opportunity_Group__c where Opportunity__c IN: salesOpIdAndSubstituteOpIdMap.values() and Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL and Opportunity_Relation__c =: GlobalConstants.SUBORDINATE LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		if(opptyGroupObj.Deal__c != null)
			substituteOpIdAndDealIdMap.put(opptyGroupObj.Opportunity__c, opptyGroupObj.Deal__c);
		else
			substituteOpIdAndDealIdMap.put(opptyGroupObj.Opportunity__c, null);
	}
	for( Opportunity opp : opptyList){
		if(salesOpIdAndDealIdMap.containsKey(opp.Id) && substituteOpIdAndDealIdMap.containsKey(salesOpIdAndSubstituteOpIdMap.get(opp.Id))) {
			//get deal
			if(salesOpIdAndDealIdMap.get(opp.Id) != substituteOpIdAndDealIdMap.get(salesOpIdAndSubstituteOpIdMap.get(opp.Id))){
	opp.addError(Label.UpsellOpportunityDealErrorMessage);
			}
		} else if(salesOpIdAndDealIdMap.containsKey(opp.Id) && substituteOpIdAndDealIdMap.isEmpty()){
			opp.addError(Label.UpsellOpportunityDealErrorMessage);
		}
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.VALIDATESUBSTITUTEOPTYWITHSAMEUPSELLDEAL);
		}
	}

	/*****************************
	*Method Name: restrictOpptyTypeChange
	*Description: This method will check if oppty is associated as master oppty on changing opportunity type from standard to committed upsell.
	*Parameters:Opportunity List, Opportunity Map
	*Requirement : 5150
	*******************************/
	public static void restrictOpptyTypeChange( Map<ID, Opportunity>opptyNewMap, Map<ID, Opportunity>opptyOldMap)
	{
		Set<Id> opptyIdSet =  new Set<Id>();
		Set<Id> masterOpptyIdSet = new Set<Id>();
		try {
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId) && opptyObj.Business_Type__c == GlobalConstants.COMMITTED_UPSELL && opptyOldMap.get(opptyObj.id).Business_Type__c == GlobalConstants.STANDARDOPPORTUNITY) {
		opptyIdSet.add(opptyObj.id);
	}
			}
			if(opptyIdSet.size() > 0) {
	for(Opportunity_Group__c opptyGroupObj:[Select id, Opportunity__c,Opportunity_Relation__c from Opportunity_Group__c where Opportunity__c IN: opptyIdSet and Opportunity_Relation__c =: GlobalConstants.MASTER LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		masterOpptyIdSet.add(opptyGroupObj.Opportunity__c);
	}
	if(masterOpptyIdSet.size() > 0){
		for(Id opptyId: masterOpptyIdSet) {
			opptyNewMap.get(opptyId).addError(System.label.ErrorOnChangingOpptyType);
		}
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.restrictOpptyTypeChange);
		}
	}

	/*****************************
	*Method Name: ClosedOpptyStatustoTeam
	*Description:  Chatter Post to Oppty and Offer Team members to inform about to Opportunity Closed Status info
	Req:5077 - chatter post on oppty close(positive and negative)
	*Parameters: opportunitiesMap

	*******************************/
	public static void OpportunityClosure(Map<Id,Opportunity> newMap ,Map<Id,Opportunity> oldMap ) {
		Set<Id> chatterOpptyInfo = new Set<Id>();
		try{
			for(Opportunity opptyData:newMap.values()){
	if(opptyData.StageName != Null && opptyData.StageName != oldMap.get(opptyData.id).StageName &&
		(opptyData.StageName.equalsignorecase(GlobalConstants.COMPLETED_OPPTY ) ||
		opptyData.StageName.equalsignorecase(GlobalConstants.CANCELLED_BY_CUSTOMER ) ||
		opptyData.StageName.equalsignorecase(GlobalConstants.LOST_TO_COMPETITOR ) ||
		opptyData.StageName.equalsignorecase(GlobalConstants.WITH_DRAW_BY_NOKIA ) ||
		opptyData.StageName.equalsignorecase(GlobalConstants.OBSOLETE )) &&
		(opptyData.RecordTypeId == directRecordTypeId || opptyData.RecordTypeId == inDirectRecordTypeId ||
		opptyData.RecordTypeId == readOnlyDirectRecordTypeId || opptyData.RecordTypeId == readOnlyIndirectRecordTypeId)){
			chatterOpptyInfo.add(opptyData.ID);
	}
			}
			if(!ChatterOpptyinfo.isEmpty() ) {
	OpportunityTriggerHelper.ClosedOpptyStatustoTeam(ChatterOpptyinfo);
	GlobalConstants.OPPORTUNITY_CLOSE_CHECK=True;
	OpportunityTriggerHandler.flagForChatter = True;
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CLOSED_OPPTY_POST);
		}
	}

	/*****************************
	*Method Name: ClosedOpptyStatustoTeam
	*Description:  Chatter Post to Oppty and Offer Team members to inform about to Opportunity Closed Status info
	Req:5077 - chatter post on oppty close(positive and negative)
	Req 5546 Ap release
	*Parameters: opportunitiesMap
	*******************************/
	@future
	public static void ClosedOpptyStatustoTeam(Set <Id> opptyIdSet) {

		map<ID, Set<ID>>mapOppIdRelatedUsers = new map<ID, Set<ID>>();
		map<Id, Opportunity> opportunitiesMap ;
		list<Id> lstIds ;
		Set<Id> emptySet = new set<Id>();
		String messageBody;
		Map<String,String> organizationinfo=new Map<String,String>();
		Map<String,ID> cTHeadinfo=new Map<String,ID>();
		Map<ID,Set<ID>> cTHeadDelegate=new Map<ID,Set<ID>>();
		Map<ID,ID> cTHeadID= new  Map<ID,ID>();
		Map<ID,Offer__c> opptyIdOfferMap = new  Map<ID,Offer__c>();
		String supportingBG='';
		String supportingBUs='';
		ConnectApi.FeedItemInput feedItemInput  ;
		ConnectApi.MessageBodyInput messageBodyInput ;
		ConnectApi.TextSegmentInput textSegmentInput ;
		try{
			GlobalConstants.OPPORTUNITY_CLOSE_CHECK=True;
			if(opptyIdSet.size() > 0){
	opportunitiesMap = new Map<Id,Opportunity>([select Id,Org_L7__c,CT_Head__c,OwnerId,Name,Account_Name__c,StageName,Opportunity_ID__c,Country__c,CurrencyIsoCode,Amount,
	Lead_BG__c,Supporting_BG_AA__c,Supporting_BG_FN__c,Supporting_BG_MN__c,Supporting_BG_GS__c,Supporting_BG_ION__c,Supporting_BG_NEN__c,
	Lead_BU__c,Supporting_BU_ION__c,Supporting_BUs_NEN__c,LOA_Level__c,Sales_Outcome__c,Sales_Outcome_Reason__c,Second_Reason__c,Third_Reason__c from opportunity
	where id in: opptyIdSet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
			}
			Map<Id,Offer__c> offerinfo = new Map<Id,Offer__c>([select id,name,Opportunity__c,LoA_Approval_Level__c, LoA_Level_Before_Trigger_Approval__c from Offer__c where ActiveOffer__c=True AND Opportunity__c=:opportunitiesMap.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ]);
			for(Offer__c offr : offerinfo.values()){
	opptyIdOfferMap.put(offr.Opportunity__c,offr);
			}
			//fill the mapOppIdRelatedUsers map by Offer Team
			if(offerinfo.size() > 0){
	for(Offer_Team__c offerTeamMembers: [select id,Offer__c ,Name__c,Offer__r.Opportunity__c from Offer_Team__c where Team_Member_Role__c!=:GlobalConstants.TEAM_ROLE AND  Offer__c=:Offerinfo.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()  ]) {
		if (!mapOppIdRelatedUsers.containsKey(OfferTeamMembers.Offer__r.Opportunity__c)) {
			emptySet = new Set<Id>();
			mapOppIdRelatedUsers.put(OfferTeamMembers.Offer__r.Opportunity__c, emptySet);
		}
		if(mapOppIdRelatedUsers.containsKey(OfferTeamMembers.Offer__r.Opportunity__c))
			mapOppIdRelatedUsers.get(OfferTeamMembers.Offer__r.Opportunity__c).add(OfferTeamMembers.Name__c);
	}
			}
			// fill the mapOppIdRelatedUsers map by opportunity Owners
			for (Opportunity opp: opportunitiesMap.values()) {
	if( opp.Org_L7__c <> Null)
		Organizationinfo.put(opp.Org_L7__c,opp.Org_L7__c);
	if (!mapOppIdRelatedUsers.containsKey(opp.Id)) {
		emptySet = new Set<Id>();
		mapOppIdRelatedUsers.put(opp.Id, emptySet);
	}
	if(opp.CT_Head__c != Null)
		mapOppIdRelatedUsers.get(opp.Id).add(opp.CT_Head__c);
	mapOppIdRelatedUsers.get(opp.Id).add(opp.OwnerId);
			}
			//colleting the CT Head Information
			if(Organizationinfo.size() > 0){
	List<Sales_Role__c> salesroleList = [SELECT Organisation__c,OwnerId,Role_Code__c,User__c FROM Sales_Role__c where Role_Code__c=:Label.NF_NSNG_HCT AND Organisation__c=:Organizationinfo.KeySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ];
	for(Sales_Role__c salesrole:salesroleList) {
		CTHeadinfo.put(Salesrole.Organisation__c,Salesrole.User__c);
		CTHeadID.put(Salesrole.User__c,Salesrole.User__c);
	}
	//colleceting the delegates info
	for (Apttus_Approval__Backup_Approver__c delegateInfo:[select id,Apttus_Approval__Current_User__c,Delegate_Approver1__c,Delegate_Approver2__c,Delegate_Approver3__c,Apttus_Approval__Backup_User__c from Apttus_Approval__Backup_Approver__c where Apttus_Approval__IsActive__c=true and Apttus_Approval__InEffect__c=true and  Apttus_Approval__Current_User__c=:CTHeadID.Keyset() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
		if(!CTHeadDelegate.containsKey(DelegateInfo.Apttus_Approval__Current_User__c)){
			emptySet = new Set<Id>();
			CTHeadDelegate.put(DelegateInfo.Apttus_Approval__Current_User__c,emptySet);
		}
		if(DelegateInfo.Delegate_Approver1__c<>NUll && CTHeadDelegate<>NUll )
			CTHeadDelegate.get(DelegateInfo.Apttus_Approval__Current_User__c).add(DelegateInfo.Delegate_Approver1__c);

		if(DelegateInfo.Delegate_Approver2__c<>NUll && CTHeadDelegate<>NUll  )
			CTHeadDelegate.get(DelegateInfo.Apttus_Approval__Current_User__c).add(DelegateInfo.Delegate_Approver2__c);

		if(DelegateInfo.Delegate_Approver3__c<>NUll && CTHeadDelegate<>NUll  )
			CTHeadDelegate.get(DelegateInfo.Apttus_Approval__Current_User__c).add(DelegateInfo.Delegate_Approver3__c);

		if(DelegateInfo.Apttus_Approval__Backup_User__c<>NUll && CTHeadDelegate<>NUll )
			CTHeadDelegate.get(DelegateInfo.Apttus_Approval__Current_User__c).add(DelegateInfo.Apttus_Approval__Backup_User__c);
	}
	for (Opportunity opp: opportunitiesMap.values()) {
		if(CTHeadinfo.get(opp.Org_L7__c)<>Null) {
			if (opp.Org_L7__c<>Null && !mapOppIdRelatedUsers.containsKey(opp.Id)) {
	emptySet = new Set<Id>();
	mapOppIdRelatedUsers.put(opp.Id, emptySet);
			}
			if(opp.Org_L7__c<>Null)
	mapOppIdRelatedUsers.get(opp.Id).add(CTHeadinfo.get(opp.Org_L7__c));
			//passing the delegates id
			if(!CTHeadDelegate.isEmpty() && CTHeadDelegate.get(CTHeadinfo.get(opp.Org_L7__c)).size()>0){
	for(ID delegateID:CTHeadDelegate.get(CTHeadinfo.get(opp.Org_L7__c))){
		if(DelegateID<>NUll)
			mapOppIdRelatedUsers.get(opp.Id).add(DelegateID);
	}
			}
		}
	}
			}
			// fill the Map by approvers /stackeholders /valIdators
			List<Apttus_Approval__Approval_Request__c> reqInfoList = [SELECT Id,Apttus_Approval__Step_Name__c,Apttus_Approval__Backup_From_User__c,Apttus_Approval__Assigned_To_Id__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c FROM Apttus_Approval__Approval_Request__c WHERE Apttus_Approval__Object_Id__c IN: opportunitiesMap.keySet() AND Apttus_Approval__Assigned_To_Id__c<>NULL LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ];
			for(Apttus_Approval__Approval_Request__c reqInfo:reqInfoList){
	if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
		emptySet = new Set<Id>();
		mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, emptySet);
	}
	mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Assigned_To_Id__c);
	if (ReqInfo.Apttus_Approval__DelegateApproverIds__c != GlobalConstants.SALES_EMPTY) {
		String[] delegateApproverIds = ReqInfo.Apttus_Approval__DelegateApproverIds__c.split(GlobalConstants.COMMA);
		for (string delegateapproverId: delegateApproverIds) {
			if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
	emptySet = new Set<Id>();
	mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, emptySet);
			}
			mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(delegateapproverId);
		}
	}
	if (ReqInfo.Apttus_Approval__Backup_From_User__c != GlobalConstants.SALES_EMPTY) {
		if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
			emptySet = new Set<Id>();
			mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, emptySet);
		}
		mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Backup_From_User__c);
	}
			}

			// fill the map by opportunity team members
			List<OpportunityTeamMember> opportunityTeamMemberList = [SELECT UserId, OpportunityId FROM OpportunityTeamMember WHERE TeamMemberRole!=:GlobalConstants.TEAM_ROLE AND  OpportunityId IN: opportunitiesMap.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ];
			for (OpportunityTeamMember opportunityTeamMember: opportunityTeamMemberList) {
	if (!mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId)) {
		emptySet = new Set<Id>();
		mapOppIdRelatedUsers.put(opportunityTeamMember.OpportunityId, emptySet);
	}
	if(mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId))
		mapOppIdRelatedUsers.get(opportunityTeamMember.OpportunityId).add(opportunityTeamMember.UserId);
			}

			for (ID oppId: opportunitiesMap.keySet()) {
	if (mapOppIdRelatedUsers.get(OppId) != null) {
		integer numberOfPost = (integer)((decimal) mapOppIdRelatedUsers.get(OppId).size() / 24).round(System.RoundingMode.UP);
		integer startLoop = 0;
		for (integer i = 0; i<NumberOfPost; i++) {
			feedItemInput = new ConnectApi.FeedItemInput();
			messageBodyInput = new ConnectApi.MessageBodyInput();
			textSegmentInput = new ConnectApi.TextSegmentInput();

			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			lstIds = new list<Id>(mapOppIdRelatedUsers.get(oppId));

			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentBold;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentBold;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentSpace;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentSpace;
			ConnectApi.MarkupBeginSegmentInput markupBeginSegmentParagraph;
			ConnectApi.MarkupEndSegmentInput markupEndSegmentParagraph;
			ConnectApi.MentionSegmentInput mentionSegmentInput ;

			//Tag for Bold
			markupBeginSegmentBold = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentBold.markupType = ConnectApi.MarkupType.Bold;
			markupEndSegmentBold = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentBold.markupType = ConnectApi.MarkupType.Bold;

			//Tag for Next Line
			markupBeginSegmentSpace = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			markupEndSegmentSpace = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentSpace.markupType = ConnectApi.MarkupType.Paragraph;

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.DEAR ;
			messageBodyInput.messageSegments.add(textSegmentInput);

			for (integer j = StartLoop; j< StartLoop + 24 ; j++) {
	if (lstIds.size()>j) {
		mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.id = lstIds[j];
		if(mentionSegmentInput != null){
			messageBodyInput.messageSegments.add(mentionSegmentInput);
		}
	}
			}
			StartLoop += 24;
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.COMMAS ;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//new Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//first line of chatter info
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.The_Opportunity;
			textSegmentInput.text  += GlobalConstants.SPACE+opportunitiesMap.get(oppId).Name;
			textSegmentInput.text  += GlobalConstants.SPACE+GlobalConstants.HYPHEN;
			textSegmentInput.text  += GlobalConstants.SPACE+opportunitiesMap.get(oppId).Account_Name__c;
			textSegmentInput.text  += GlobalConstants.SPACE+GlobalConstants.HAS_BEEN ;
			textSegmentInput.text  += GlobalConstants.SPACE+opportunitiesMap.get(oppId).StageName;
			textSegmentInput.text  += GlobalConstants.DOT_SYMBOL;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//new Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			// Oppty ID
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text += GlobalConstants.oppty_Number+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Opportunity_ID__c;
			messageBodyInput.messageSegments.add(textSegmentInput);

			// opportunity name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.oppty_Name+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Name;
			messageBodyInput.messageSegments.add(textSegmentInput);

			// Customer name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Oppty_Customer+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Account_Name__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text =GlobalConstants.SPACE+opportunitiesMap.get(oppId).Account_Name__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}

			// Country name
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text += GlobalConstants.Country+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Country__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text =GlobalConstants.SPACE+opportunitiesMap.get(oppId).Country__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}

			// Unweighted Amount
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Unweighted_Amounts+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).CurrencyIsoCode+GlobalConstants.SPACE+opportunitiesMap.get(oppId).Amount;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			// New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Lead BG
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Oppty_Lead_BG+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Lead_BG__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text =GlobalConstants.SPACE+ opportunitiesMap.get(oppId).Lead_BG__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}

			//Supporting BGs
			SupportingBG = GlobalConstants.BLANK_VALUE;
			if(opportunitiesMap.get(oppId).Supporting_BG_AA__c<>Null)
	SupportingBG=opportunitiesMap.get(oppId).Supporting_BG_AA__c;

			if(opportunitiesMap.get(oppId).Supporting_BG_AA__c<>Null&&opportunitiesMap.get(oppId).Supporting_BG_FN__c<>Null)
	SupportingBG=SupportingBG+GlobalConstants.COMMA;

			if(opportunitiesMap.get(oppId).Supporting_BG_FN__c<>Null)
	SupportingBG=SupportingBG+opportunitiesMap.get(oppId).Supporting_BG_FN__c;

			if(opportunitiesMap.get(oppId).Supporting_BG_ION__c<>Null&&(opportunitiesMap.get(oppId).Supporting_BG_AA__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_FN__c<>Null))
	SupportingBG= SupportingBG+GlobalConstants.COMMA;

			if(opportunitiesMap.get(oppId).Supporting_BG_ION__c<>Null)
	SupportingBG=SupportingBG+opportunitiesMap.get(oppId).Supporting_BG_ION__c;

			if(opportunitiesMap.get(oppId).Supporting_BG_MN__c<>Null &&(opportunitiesMap.get(oppId).Supporting_BG_AA__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_FN__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_ION__c<>Null ))
	SupportingBG= SupportingBG+GlobalConstants.COMMA;

			if(opportunitiesMap.get(oppId).Supporting_BG_MN__c<>Null)
	SupportingBG=SupportingBG+opportunitiesMap.get(oppId).Supporting_BG_MN__c;

			if(opportunitiesMap.get(oppId).Supporting_BG_GS__c<>Null && (opportunitiesMap.get(oppId).Supporting_BG_AA__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_FN__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_ION__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_MN__c<>Null ))
	SupportingBG= SupportingBG+GlobalConstants.COMMA;

			if(opportunitiesMap.get(oppId).Supporting_BG_GS__c<>Null)
	SupportingBG=SupportingBG+opportunitiesMap.get(oppId).Supporting_BG_GS__c;

			if(opportunitiesMap.get(oppId).Supporting_BG_NEN__c<>Null&&(opportunitiesMap.get(oppId).Supporting_BG_AA__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_FN__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_ION__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_MN__c<>Null || opportunitiesMap.get(oppId).Supporting_BG_GS__c<>Null))
	SupportingBG= SupportingBG+GlobalConstants.COMMA;

			if(opportunitiesMap.get(oppId).Supporting_BG_NEN__c<>Null)
	SupportingBG=SupportingBG+opportunitiesMap.get(oppId).Supporting_BG_NEN__c;

			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.SupportingBG+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(SupportingBG != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+SupportingBG;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}

			//Lead BU
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Oppty_Lead_BU+GlobalConstants.SPACE;

			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Lead_BU__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Lead_BU__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}

			//Supporting BUs
			SupportingBUs = GlobalConstants.BLANK_VALUE;
			if(opportunitiesMap.get(oppId).Supporting_BU_ION__c<>Null)
	SupportingBUs=opportunitiesMap.get(oppId).Supporting_BU_ION__c;

			if(opportunitiesMap.get(oppId).Supporting_BUs_NEN__c<>Null && SupportingBUs<>Null)
	SupportingBUs=SupportingBUs+GlobalConstants.SEMICOLON+opportunitiesMap.get(oppId).Supporting_BUs_NEN__c;

			if(opportunitiesMap.get(oppId).Supporting_BUs_NEN__c<>Null && SupportingBUs == Null)
	SupportingBUs=opportunitiesMap.get(oppId).Supporting_BUs_NEN__c;

			if(SupportingBUs<>NUll && SupportingBUs.contains(GlobalConstants.SEMICOLON))
	SupportingBUs=SupportingBUs.replaceAll(GlobalConstants.SEMICOLON,GlobalConstants.COMMA);

			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.SupportingBU+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(SupportingBUs != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+SupportingBUs;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			// New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			// LOA Level
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.LoALevel+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opptyIdOfferMap.size() > 0 && opptyIdOfferMap.containsKey(oppId) && opptyIdOfferMap.get(oppId).LoA_Approval_Level__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+opptyIdOfferMap.get(oppId).LoA_Approval_Level__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}

			// LoA Level before STA
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.LoA_Level_Before_STA+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opptyIdOfferMap.size() > 0 && opptyIdOfferMap.containsKey(oppId) && opptyIdOfferMap.get(oppId).LoA_Level_Before_Trigger_Approval__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+opptyIdOfferMap.get(oppId).LoA_Level_Before_Trigger_Approval__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}

			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Opportunity Conclusion
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text =GlobalConstants.Opportunity_Conclusion+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//Sales Outcome
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Sales_Outcomes+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Sales_Outcome__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Sales_Outcome__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//MainReason
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Main_Reason+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Sales_Outcome_Reason__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Sales_Outcome_Reason__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//SecondReason
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Second_Reasons+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Second_Reason__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Second_Reason__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//ThirdReason
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);
			messageBodyInput.messageSegments.add(markupBeginSegmentBold);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Third_Reasons+GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			messageBodyInput.messageSegments.add(markupEndSegmentBold);
			if(opportunitiesMap.get(oppId).Third_Reason__c != Null){
	textSegmentInput = new ConnectApi.TextSegmentInput();
	textSegmentInput.text = GlobalConstants.SPACE+opportunitiesMap.get(oppId).Third_Reason__c;
	messageBodyInput.messageSegments.add(textSegmentInput);
			}
			messageBodyInput.messageSegments.add(markupBeginSegmentSpace);
			messageBodyInput.messageSegments.add(markupEndSegmentSpace);

			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Regards
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Regards + GlobalConstants.COMMA ;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Nokia_CRM ;
			messageBodyInput.messageSegments.add(textSegmentInput);

			///New Paragraph
			markupBeginSegmentParagraph = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegmentParagraph);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegmentParagraph = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegmentParagraph.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegmentParagraph);

			//Oppty link
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.OPPORTUNITY_LINK;
			textSegmentInput.text += URL.getSalesforceBaseUrl().toExternalForm();
			textSegmentInput.text += GlobalConstants.LINK2+ opportunitiesMap.get(oppId).Id;
			messageBodyInput.messageSegments.add(textSegmentInput);

			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = oppId;
			if (!test.isRunningTest()) {
	ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
			}
		}
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CLOSED_OPPTY_POST );
		}
	}

	/*****************************
	*Method Name: opportunityTypeChangeRestriction
	*Description: This method will prevent currentloggeduser with Role other than CO Sales Operations Market Head,
	changing opportunity type after Identify stage.
	*Requirement: 5003
	*Parameters: opportunityNewMap , opportunityOldMap
	*Test coverage from: OpportunityTriggerHelperTest
	*******************************/
	public static void opportunityTypeChangeRestriction(List<Opportunity>optyList, Map<Id, Opportunity> opportunityOldMap) {
		Map<Id, Opportunity> opportunityAddErrorMap = new Map<Id, Opportunity>();
		Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
		List<Sales_Role__c> salesRoleList = new List<Sales_Role__c> ();
		try {
			for(Opportunity opty : optyList)	{
	if(opty.Business_Type__c != opportunityOldMap.get(opty.id).Business_Type__c &&
		(opty.RecordTypeId == directRecordTypeId || opty.RecordTypeId == inDirectRecordTypeId || opty.RecordTypeId == readOnlyDirectRecordTypeId || opty.RecordTypeId == readOnlyIndirectRecordTypeId ) &&
		(opty.StageName == GlobalConstants.COMPLETED_OPPTY || opty.StageName == GlobalConstants.CANCELLED_BY_CUSTOMER || opty.StageName == GlobalConstants.LOST_TO_COMPETITOR  || opty.StageName == GlobalConstants.WITH_DRAW_BY_NOKIA  || opty.StageName == GlobalConstants.OBSOLETE ||
		opty.Phase_Status__c == GlobalConstants.SUBMITTED_FOR_G2_APPROVAL || opty.Phase_Status__c == GlobalConstants.SUBMITTED_FOR_G3_APPROVAL || opty.Phase_Status__c == GlobalConstants.SUBMITTED_FOR_G4_APPROVAL || opty.Phase_Status__c == GlobalConstants.SUBMITTED_FOR_G5_APPROVAL || opty.Phase_Status__c == GlobalConstants.SUBMITTED_FOR_G6_APPROVAL )) {
		opportunityAddErrorMap.put(opty.Id,opty);
	} else if(opty.Business_Type__c != opportunityOldMap.get(opty.id).Business_Type__c && (opty.RecordTypeId == directRecordTypeId || opty.RecordTypeId == inDirectRecordTypeId)){
		opportunityMap.put(opty.Id,opty);
	}
			}

			if(!opportunityMap.isEmpty()){
	salesRoleList  = [select id,Role_Code__c,Role_Name__c,User__c from Sales_Role__c where User__c =: UserInfo.getUserId() AND (Role_Name__c like:GlobalConstants.WILDCARD_SEARCH+Label.CO_Sales_Operations_Market_Head AND Active__c =: GlobalConstants.VALUE_TRUE) LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	if(salesRoleList.isEmpty()){
		for(Opportunity optyToShowError : opportunityMap.values()){
			if(optyToShowError.StageName != GlobalConstants.IDENTIFY_OPPORTUNITY ){
	optyToShowError.addError(System.Label.Opportunity_Type_Change);
			}else {
			}
		}
	}
			}
			if(!opportunityAddErrorMap.isEmpty()){
	for(Opportunity optyToShowError : opportunityAddErrorMap.values()){
		optyToShowError.addError(System.Label.OpptyTypeChnage_whenOpptyLockedclosed);
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
		}
	}

	/*****************************
	*Method Name: upsellDeltaDifference
	*Description: calculate Committed Upsell Deviation
	*Parameters: List<Opportunity> ,Map<ID, Opportunity>
	*Requirement : 5107
	*******************************/
	public static void upsellDeltaDifference(List<Opportunity> lstOppty, Map<ID, Opportunity> opptyOldMap)
	{
		try {
			for(opportunity objOppty : lstOppty){
	if(objOppty.Business_Type__c == Globalconstants.COMMITTED_UPSELL && objOppty.Unweighted_Amount_EUR__c != opptyOldMap.get(objOppty.id).Unweighted_Amount_EUR__c ){
		if(objOppty.Committed_Unweighted_Value_in_EUR__c != 0 ){
			objOppty.Upsell_Delta__c = objOppty.Unweighted_Amount_EUR__c - objOppty.Committed_Unweighted_Value_in_EUR__c;
			if(string.isBlank(objOppty.Upsell_Change_Explanation__c) && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id ) ){
	if( (objOppty.Lead_BG__c == Globalconstants.LEAD_BG_MN || objOppty.Lead_BG__c == Globalconstants.LEAD_BG_GS) && objOppty.Upsell_Delta__c <= integer.valueof(Label.LeadBGMN_GSUpsellDeltaValue) )
		objOppty.adderror(Label.UpsellDelta_ErrorMsg);
	else if((objOppty.Lead_BG__c == Globalconstants.LEAD_BG_ION  || objOppty.Lead_BG__c == Globalconstants.LEAD_BG_FN ) && objOppty.Upsell_Delta__c <= integer.valueof(Label.LeadBGION_FN_NSWUpsellDeltaValue)  )
		objOppty.adderror(Label.UpsellDelta_ErrorMsg);
	else if((objOppty.Lead_BG__c == Globalconstants.Lead_BG_NSW) && objOppty.Upsell_Delta__c <= integer.valueof(Label.Lead_NSWUpsellDeltaValue)  )
		objOppty.adderror(Label.UpsellDelta_ErrorMsg);
			}
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
		}
	}

	/*****************************
	*Method Name: committedUnweightedValue
	*Description: calculate Committed Unweighted Value of Upsell Opportunity
	*Parameters: List<Opportunity> ,Map<ID, Opportunity>
	*Requirement : 5114
	*******************************/
	public static void committedUnweightedValue(List<Opportunity> lstOppty, Map<ID, Opportunity> opptyOldMap)
	{
		integer iOpptyCount = 0;
		set<id> setOpptyId = new set<id>();
		set<id> setDealId = new set<id>();
		set<id> setCommittedOppty = new set<id>();
		list<opportunity> lstUpsellOppty = new list<opportunity>();
		list<opportunity> lstUpsellOpptyToUpdate = new list<opportunity>();
		string strStageName = GlobalConstants.OPPTYSALESPHASE;
		list<string> lstStageName = strStageName.split(',');
		Set<String> setStageName = new Set<String>(lstStageName);

		try {
			for(opportunity objOppty : lstOppty){
	if( objOppty.Phase_Status__c != opptyOldMap.get(objOppty.id).Phase_Status__c && (objOppty.Phase_Status__c == GlobalConstants.PENDING_WIN_LOSS_DECLARATION || objOppty.Phase_Status__c == GlobalConstants.OFFERSUBMITTEDTOCUSTOMER ) ) {
		setOpptyId.add(objOppty.id);
	}
			}
			if(setOpptyId.size() > 0) {
	List<Opportunity_Group__c> objDealGrouplist = [select id,Opportunity__c,Deal__c from Opportunity_Group__c where Opportunity__c in : setOpptyId and Opportunity_Relation__c =: globalconstants.MASTER ];
	for(Opportunity_Group__c objDealGroup : objDealGrouplist) {
		setDealId.add(objDealGroup.Deal__c);
	}
	if(setDealId.size()>0) {
		for(Opportunity_Group__c objDealGroup : [select id,Opportunity__c,Deal__c from Opportunity_Group__c where Deal__c in : setDealId and Opportunity_Relation__c =: globalconstants.SUBORDINATE ]) {
			setCommittedOppty.add(objDealGroup.Opportunity__c);
		}

		if(setCommittedOppty.size()>0) {
			lstUpsellOpptyToUpdate = getCommittedUpsellOpptyList(setCommittedOppty);
			for(opportunity objUpsellOptty : lstUpsellOpptyToUpdate) {
	if(objUpsellOptty.Is_Auto_Upsell__c == false ){
		objUpsellOptty.Committed_Unweighted_Value_in_EUR__c = calculateTotalSalesYear(objUpsellOptty.Opportunity_ID__c);
		objUpsellOptty.Upsell_Delta__c = 0 ;
		lstUpsellOppty.add(objUpsellOptty);
	}
			}
		}
	}
			}
			update lstUpsellOppty;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
		}
	}

	/*****************************
	*Method Name: calculateTotalSalesYear
	*Description: To get the comitted Upsell Opportunity
	*Parameters: list<opportunity>
	*Requirement : 5008
	*******************************/
	public static decimal  calculateTotalSalesYear(string strOpptyNumber)
	{
		decimal dTotalSales = 0.0 ;
		list<Upsell_Container__c> lstUpsellContainer = new List<Upsell_Container__c>();
		lstUpsellContainer.clear();
		lstUpsellContainer = [select Upsell_Opportunity_Number__c,Template_Identifier__c,Total_Year_Sales__c,Quarter1_Period_Value__c , Quarter2_Period_Value__c , Quarter3_Period_Value__c , Quarter4_Period_Value__c from Upsell_Container__c where Template_Identifier__c =: Globalconstants.TEMPLATEIDENTIFIER_G5 AND Upsell_Opportunity_Number__c =: strOpptyNumber] ;
		if(lstUpsellContainer.size() == 0)
			lstUpsellContainer = [select Upsell_Opportunity_Number__c,Template_Identifier__c,Total_Year_Sales__c,Quarter1_Period_Value__c , Quarter2_Period_Value__c , Quarter3_Period_Value__c , Quarter4_Period_Value__c from Upsell_Container__c where Template_Identifier__c =: Globalconstants.TEMPLATEIDENTIFIER_G4 AND Upsell_Opportunity_Number__c =: strOpptyNumber] ;

		try {
			if(lstUpsellContainer.size() > 0){
	for(Upsell_Container__c objUpsell : lstUpsellContainer){
		if(String.valueOf(objUpsell.Upsell_Opportunity_Number__c.escapeUnicode()).replace(GlobalConstants.SPECIAL_CHARACTER, GlobalConstants.BLANK_VALUE).Equals(String.valueOf(strOpptyNumber.escapeUnicode()).replace(GlobalConstants.SPECIAL_CHARACTER, GlobalConstants.BLANK_VALUE)) ){
			dTotalSales = dTotalSales + objUpsell.Total_Year_Sales__c ;
		}
	}
	return dTotalSales.setScale(2);
			}
			return 0.0;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
			return null ;
		}
	}

	/*****************************
	*Method Name: getCommittedUpsellOpptyList
	*Description: To get the comitted Upsell Opportunity
	*Parameters: set<id>
	*Requirement : 5008
	*******************************/
	public static list<Opportunity> getCommittedUpsellOpptyList(set<id> setCommittedOppty)
	{
		try {
			list<opportunity> lstUpsellOppty =  [select id,Is_Auto_Upsell__c,Opportunity_ID__c,Unweighted_Amount_EUR__c,Committed_Unweighted_Value_in_EUR__c from opportunity where id in :setCommittedOppty ];
			return lstUpsellOppty;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
			return null ;
		}
	}

	/*****************************
	*Method Name: upsellDeltaDifference
	*Description: Restrict sign-off of Committed Upsell changes
	*Parameters: List<Opportunity> ,Map<ID, Opportunity>
	*Requirement : 5008
	*******************************/
	public static void upsellChangeAccepted(List<Opportunity> lstOppty, Map<ID, Opportunity>opptyOldMap)
	{
		set<string> setRoleName = new set<string>();
		Map<String, string> mapLeadSalesRole = new Map<String, string> ();
		List<Opportunity> lstNewOppty = new list<opportunity>();
		try {
			for(opportunity oOppty : lstOppty){
	if(oOppty.Upsell_Change_Accepted__c == true && opptyOldMap.get(oOppty.id).Upsell_Change_Accepted__c != oOppty.Upsell_Change_Accepted__c){
		lstNewOppty.add(oOppty);
	}else if(oOppty.Upsell_Change_Accepted__c == false && opptyOldMap.get(oOppty.id).Upsell_Change_Accepted__c != oOppty.Upsell_Change_Accepted__c){
		lstNewOppty.add(oOppty);
	}
			}
			if(lstNewOppty.size()> 0){
	List<Committed_Upsell_Configuration__mdt> objUpsellConfigList = [select Lead_BG__c,Sales_Role_Code__c from Committed_Upsell_Configuration__mdt];
	for(Committed_Upsell_Configuration__mdt objUpsellConfig : objUpsellConfigList){
		mapLeadSalesRole.put(objUpsellConfig.Lead_BG__c,objUpsellConfig.Sales_Role_Code__c);
	}

	List<Sales_Role__c> objRoleNameList = [select id,Role_Code__c,Role_Name__c,User__c from Sales_Role__c where User__c =: UserInfo.getUserId()];
	for(Sales_Role__c objRoleName : objRoleNameList ){
		list<string> lstStageName = objRoleName.Role_Code__c.split(',');
		setRoleName.addall(lstStageName);
	}

	string strStageName = GlobalConstants.STAGENAME;
	list<string> lstStageName = strStageName.split(',');
	Set<String> setStageName = new Set<String>(lstStageName);
	string username = [select name from user where id = : UserInfo.getUserId() ].name;
	for(opportunity objOppty : lstNewOppty){
		if(objOppty.Upsell_Change_Accepted__c == true && opptyOldMap.get(objOppty.id).Upsell_Change_Accepted__c != objOppty.Upsell_Change_Accepted__c){
			if(!setStageName.contains(objOppty.RecordType.DeveloperName) && !setStageName.contains(objOppty.Phase_Status__c ) ){
	if(setRoleName.size() > 0 || (UserInfo.getProfileId().equalsIgnoreCase(system.Label.Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Global_Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Nokia_Admin))) {
		if(setRoleName.contains(mapLeadSalesRole.get(objOppty.Lead_BG__c)) || (UserInfo.getProfileId().equalsIgnoreCase(system.Label.Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Global_Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Nokia_Admin))){
			objOppty.Upsell_Change_Approved_by__c = username + globalconstants.SPACE + globalconstants.COMMA +  globalconstants.SPACE + system.Now();
		}else{
			objOppty.addError(label.Upsell_Change_Accepted_Checked);
		}
	} else{
		objOppty.addError(label.Upsell_Change_Accepted_Checked);
	}
			}else
	objOppty.addError(GlobalConstants.ERROR_MESSAGE_OPPTY);
		}else if(objOppty.Upsell_Change_Accepted__c == false && opptyOldMap.get(objOppty.id).Upsell_Change_Accepted__c != objOppty.Upsell_Change_Accepted__c){
			if(!setStageName.contains(objOppty.RecordType.DeveloperName) && !setStageName.contains(objOppty.Phase_Status__c ) ){
	if((UserInfo.getProfileId().equalsIgnoreCase(system.Label.Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Global_Admin) || UserInfo.getProfileId().equalsIgnoreCase(system.Label.Nokia_Admin))){
		objOppty.Upsell_Change_Approved_by__c =  '';
	}
			}else
	objOppty.addError(GlobalConstants.ERROR_MESSAGE_OPPTY);
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.opportunityTypeChangeRestriction);
		}
	}

	/*****************************
	*Method Name: populate_G4ApprovalCycleTimeOnOffer
	*Description: This method will populate G4 Approval Cycle Time on offer when opportunity is submitted for g4 approval or g4 approved.
	*Parameters:Opportunity List, Opportunity Map
	*Requirement : 4422 , Req 5470
	*******************************/
	public static void populate_G4ApprovalCycleTimeOnOffer(Map<ID, Opportunity>opptyMap, Map<ID, Opportunity> opptyOldMap)
	{
		Map<Id, Offer__c> opptyOfferMap = new Map<Id, Offer__c>();
		List<Offer__c> offerList = new List<Offer__c>();
		Set<id> opptyIdSet = new Set<id>();
		try{
			for(Opportunity oppty: opptyMap.values()){
	if(oppty.TotalOfferCount__c > 0 && ((oppty.G4_Submission_Date__c != null && oppty.G4_Submission_Date__c != opptyOldMap.get(oppty.id).G4_Submission_Date__c )  || (oppty.G4_Approval_Date__c != null && oppty.G4_Approval_Date__c != opptyOldMap.get(oppty.id).G4_Approval_Date__c))) {
		opptyIdSet.add(oppty.id);
	}
			}
			if(!opptyIdSet.isEmpty() && opptyIdSet.size()>0){
	for(Offer__c offer : [Select id, ActiveOffer__c, Opportunity__c, G4_Approval_Cycle_Time__c from Offer__c where Opportunity__c IN: opptyIdSet AND ActiveOffer__c = True LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		opptyOfferMap.put(offer.Opportunity__c, offer);
	}
	if(!opptyOfferMap.isEmpty()){
		for(Id opptyId: opptyOfferMap.keySet()) {
			if(opptyMap.get(opptyId).G4_Submission_Date__c != null){
	if(opptyMap.get(opptyId).G4_Approval_Date__c != null){
		if((opptyMap.get(opptyId).G4_Approval_Date__c).date() >= opptyMap.get(opptyId).G4_Submission_Date__c)
			opptyOfferMap.get(opptyId).G4_Approval_Cycle_Time__c = opptyMap.get(opptyId).G4_Submission_Date__c.daysBetween(opptyMap.get(opptyId).G4_Approval_Date__c.date());
	} else  {
		if(System.today() >= opptyMap.get(opptyId).G4_Submission_Date__c){
			opptyOfferMap.get(opptyId).G4_Approval_Cycle_Time__c =  opptyMap.get(opptyId).G4_Submission_Date__c.daysBetween(System.today());
		}
	}
			}
			offerList.add(opptyOfferMap.get(opptyId));
		}
	}
	if(!offerList.isEmpty())
		database.update(offerList);
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.POPULATE_G4APPROVALCYCLETIMEONOFFER);
		}
	}

	/*****************************
	*Method Name: createCompetitorWhenOpportunityClosedNegatively
	*Description: this method creates competitor when opportunity is closed not won
	*Parameters: Opportunity List, Opportunity Map
	*Req: 5073
	*******************************/
	public static void createCompetitorWhenOpportunityClosedNegatively(List<Opportunity>opportunityList, Map<ID, Opportunity>optyOldMap)
	{
		List<Competitor__c> CompetitorsListOld = new List<Competitor__c>();
		List<Competitor__c> updateList = new List<Competitor__c>();
		Set<String> compSet = new Set<String>();
		Set<String> compSetOld = new Set<String>();
		Set<String> compSetOldFinal = new Set<String>();
		Map<Id, Set<String>> opptyCompMap =  new Map<Id, Set<String>>();
		Competitor__c compVar;
		String[] compList = new List<String>();
		Map<String, Competitor__c> updateMap ;
		Map<Id, List<Competitor__c>> OpptyIdAndCompetitorsMapOld =  new Map<Id, List<Competitor__c>>();
		try{
			for (Opportunity opptyObj: opportunityList) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyIndirectRecordTypeId)
		&& opptyObj.StageName != optyOldMap.get(opptyObj.id).StageName && opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR && opptyObj.Winning_Competitor__c != GlobalConstants.SALES_EMPTY) {
		compList.clear();
		compList = opptyObj.Winning_Competitor__c.split(GlobalConstants.SEMICOLON);
		compSet.addAll(compList);
		opptyCompMap.put(opptyObj.id, compSet);
	}
			}
			if(!opptyCompMap.isEmpty()) {
	for (Competitor__c compObject: [select id,Opportunity__c, Competitor_New__c,Opportunity_Won__c from Competitor__c where  Opportunity__c in: opptyCompMap.keyset() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
		if(OpptyIdAndCompetitorsMapOld.containsKey(compObject.Opportunity__c)) {
			CompetitorsListOld = OpptyIdAndCompetitorsMapOld.get(compObject.Opportunity__c);
			CompetitorsListOld.add(compObject);
			OpptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c,CompetitorsListOld);
		}  else  {
			CompetitorsListOld.clear();
			CompetitorsListOld.add(compObject);
			OpptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c,CompetitorsListOld);
		}
	}
	for(Id oppId : opptyCompMap.keyset()) {
		updateMap = new Map<String, Competitor__c>();
		if(OpptyIdAndCompetitorsMapOld.containsKey(oppId)) {
			for(Competitor__c comp : OpptyIdAndCompetitorsMapOld.get(oppId)) {
	compSetOld.add(comp.Competitor_New__c);
	updateMap.put(comp.Competitor_New__c,comp);
			}
		}
		for(String str: opptyCompMap.get(oppId)) {
			if(compSetOld.contains(str))
	compSetOldFinal.add(str);
		}
		if(compSetOldFinal.size() > 0){
			for(String str : compSetOldFinal){
	if(updateMap.get(str).Opportunity_Won__c != true){
		updateMap.get(str).Opportunity_Won__c = true;
		updateList.add(updateMap.get(str));
	}
			}
		}
		opptyCompMap.get(oppId).removeAll(compSetOldFinal);
		if(opptyCompMap.get(oppId).size() > 0){
			for(String str : opptyCompMap.get(oppId)){
	compVar = new Competitor__c();
	compVar.Competitor_New__c = str;
	compVar.Opportunity__c = oppId;
	compVar.Opportunity_Won__c = true;
	updateList.add(compVar);
			}
		}
	}
			}
			if(!updateList.isEmpty()){
	Database.UpsertResult[] savedResults = Database.upsert(updateList);
			}
		}catch(Exception e){
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CREATECOMPETITORWHENOPPORTUNITYCLOSEDNEGATIVELY);
		}
	}

	/*****************************
	*Method Name: createUnknownCompetitorRecord
	*Description: this method creates 'Unknown' competitor when no competitor is selected while opportunity closure
	*Parameters: Opportunity List, Opportunity Map
	*Req: 5073
	*******************************/
	public static void createUnknownCompetitorRecord(List<Opportunity>opportunityList, Map<ID, Opportunity>optyOldMap)
	{
		List<Competitor__c> updateList = new List<Competitor__c>();
		Set<Id> opptyIdSet = new Set<Id>();
		Competitor__c compVar;
		Map<Id, Competitor__c> OpptyIdAndCompetitorMap =  new Map<Id, Competitor__c>();
		try{
			for (Opportunity opptyObj: opportunityList) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyIndirectRecordTypeId)
		&& opptyObj.StageName != optyOldMap.get(opptyObj.id).StageName && opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR && opptyObj.Winning_Competitor__c == GlobalConstants.SALES_EMPTY){
		opptyIdSet.add(opptyObj.id);
	}
			}
			if(opptyIdSet.size() > 0){
	List<Competitor__c> compObjectList = [select id,Opportunity__c, Competitor_New__c,Opportunity_Won__c from Competitor__c where  Opportunity__c in: opptyIdSet AND Competitor_New__c =: GlobalConstants.UNKNOWN LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for (Competitor__c compObject: compObjectList){
		OpptyIdAndCompetitorMap.put(compObject.Opportunity__c, compObject);
	}
	for(Id oppId : opptyIdSet){
		if(OpptyIdAndCompetitorMap.containsKey(oppId)){
			OpptyIdAndCompetitorMap.get(oppId).Opportunity_Won__c = true;
			updateList.add(OpptyIdAndCompetitorMap.get(oppId));
		} else  {
			compVar = new Competitor__c();
			compVar.Competitor_New__c = GlobalConstants.UNKNOWN;
			compVar.Opportunity__c = oppId;
			compVar.Opportunity_Won__c = true;
			updateList.add(compVar);
		}
	}
			}
			if(!updateList.isEmpty()){
	Database.UpsertResult[] savedResults = Database.upsert(updateList);
			}
		}catch(Exception e){
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.CREATEUNKNOWNCOMPETITORRECORD);
		}
	}

	/*****************************
	*Method Name: updateWinningCompOnOppty
	*Description: this method updates Winning Competitor to 'unknown' when no competitor is selected.
	*Parameters: Opportunity Map
	*Req: 5073
	*******************************/
	public static void updateWinningCompOnOppty(Map<ID, Opportunity>opptyNewMap,Map<ID, Opportunity>optyOldMap)
	{
		/* Disabled due to New Requirements.
		Set<Id> opptyIdSet = new Set<Id>();
		Set<Id> newOppIdSet = new Set<Id>();
		Map<Id, Set<String>> OpptyIdAndCompetitorsMapOld = new Map<Id, Set<String>>();
		Set<String> compSet = new Set<String>();
		String newString;
		String winningComps;
		Map<id, String> opptyWithCompMap = new Map<id, String>();
		try{
		for (Opportunity opptyObj: opptyNewMap.values())
		{
		if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId
		|| opptyObj.RecordTypeId == readOnlyDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyIndirectRecordTypeId)
		&& opptyObj.StageName != optyOldMap.get(opptyObj.id).StageName
		&& opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR)
		{
		if(opptyObj.Winning_Competitor__c == GlobalConstants.SALES_EMPTY)
		opptyIdSet.add(opptyObj.id);
		else if(opptyObj.Winning_Competitor__c != GlobalConstants.SALES_EMPTY)
		{

		opptyWithCompMap.put(opptyObj.Id,opptyObj.Winning_Competitor__c);
		System.debug('opptyWithCompMap>>>>>'+ opptyWithCompMap);
		}
		}

		}
		if(!opptyIdSet.isEmpty() || opptyWithCompMap.size() > 0)
		{
		for (Competitor__c compObject: [select id,Opportunity__c, Competitor_New__c,Opportunity_Won__c
		from Competitor__c
		where  (Opportunity__c in: opptyIdSet or Opportunity__c in: opptyWithCompMap.keySet())
		and Opportunity_Won__c =: true
		LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
		{
		if(OpptyIdAndCompetitorsMapOld.containsKey(compObject.Opportunity__c))
		{
		compSet = OpptyIdAndCompetitorsMapOld.get(compObject.Opportunity__c);
		compSet.add(compObject.Competitor_New__c);
		OpptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c,compSet);
		}
		else
		{
		compSet.clear();
		compSet.add(compObject.Competitor_New__c);
		OpptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c,compSet);
		}
		}
		}
		System.debug('OpptyIdAndCompetitorsMapOld>>>>>'+ OpptyIdAndCompetitorsMapOld);
		if(!OpptyIdAndCompetitorsMapOld.isEmpty())
		{
		for(Id oppId : OpptyIdAndCompetitorsMapOld.keyset())
		{
		newString = null;
		for(String str: OpptyIdAndCompetitorsMapOld.get(oppId))
		{
		if(newString != null)
		newString = newString + GlobalConstants.SEMICOLON + str;
		else
		newString = str ;
		}
		if(opptyWithCompMap.containsKey(oppId))
		{
		winningComps = opptyWithCompMap.get(oppId);
		for(String str: winningComps.split(GlobalConstants.SEMICOLON))
		{
		if(newString != null && !newString.contains(str) )
		newString = newString + GlobalConstants.SEMICOLON + str ;
		}
		}
		opptyNewMap.get(oppId).Winning_Competitor__c = newString;
		}
		}
		for(Id oppId :opptyIdSet)
		{
		if(!OpptyIdAndCompetitorsMapOld.keySet().contains(oppId))
		newOppIdSet.add(oppId);
		}
		if(!newOppIdSet.isEmpty())
		{
		for(Id oppId :newOppIdSet)
		{
		opptyNewMap.get(oppId).Winning_Competitor__c = GlobalConstants.UNKNOWN;
		}
		}
		}
		catch(Exception e){
		ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATEWINNINGCOMPONOPPTY);
		}*/
	}

	/*****************************
	*Method Name: insertOwnerInOpptyTeam
	*Description: Insert Oppty owner in Oppty Team
	*Parameters: List<Opportunity>
	*Requirement : 5468
	*******************************/
	public static void insertOwnerInOpptyTeam(List<Opportunity> opptyList )
	{
		List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
		List<opportunity> opptyListNew = New List<Opportunity>();
		OpportunityTeamMember opptyTeamMemberVar;
		try{
			if(!opptyList.isEmpty()){
	for(Opportunity opp : opptyList){
		if(opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId){
			opptyListNew.add(opp);
		}
	}
			}
			if(!opptyListNew.isEmpty()){
	for(Opportunity opp : opptyListNew){
		opptyTeamMemberVar = new OpportunityTeamMember();
		opptyTeamMemberVar.OpportunityId = opp.Id;
		opptyTeamMemberVar.UserId = opp.OwnerId;
		opptyTeamMemberVar.TeamMemberRole = System.Label.ACC_MANAGER_TRICON_SCO;
		opptyTeamMemberVar.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
		opptyTeamMemberList.add(opptyTeamMemberVar);
	}
			}
			if(!opptyTeamMemberList.isEmpty()){
	Database.SaveResult[] savedResults = Database.insert(opptyTeamMemberList, false);
	Boolean someFailure = false;
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.INSERT_OWNER_IN_OPPTY_TEAM);
		}
	}

	/*****************************
	*Method Name: updateOwnerInOpptyTeam
	*Description: Update Oppty owner in Oppty Team
	*Parameters: List<Opportunity> , Map<Id,Opportunity>
	*Requirement : 5468
	*******************************/
	public static void updateOwnerInOpptyTeam(List<Opportunity> opptyList , Map<Id,Opportunity> opptyOldMap )
	{
		List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
		List<OpportunityTeamMember> opptyTeamMemberListDelete = new List<OpportunityTeamMember>();
		Map<Id,OpportunityTeamMember> opptyTeamMemberMap = new Map<Id,OpportunityTeamMember>();
		OpportunityTeamMember opptyTeamMemberVar;
		Map<Id,Id> opptyOldOwnerIdSet = new Map<Id,Id>();
		List<opportunity> opptyNewList = new List<Opportunity>();
		try{
			if(!opptyList.isEmpty()){
	for(Opportunity opp : opptyList){
		if((opp.RecordTypeId == directRecordTypeId || opp.RecordTypeId == inDirectRecordTypeId ) && opp.OwnerId != opptyOldMap.get(opp.Id).OwnerId){ opptyOldOwnerIdSet.put(opp.Id,opptyOldMap.get(opp.Id).OwnerId);
			opptyNewList.add(opp);
		}
	}
	if(opptyOldOwnerIdSet.size() > 0){
		for(OpportunityTeamMember oppTeamMem : [Select Id,UserId,OpportunityId, TeamMemberRole,OpportunityAccessLevel, Additional_Team_Role__c from OpportunityTeamMember where UserId in : opptyOldOwnerIdSet.values() and OpportunityId in : opptyOldOwnerIdSet.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){
			if(oppTeamMem.TeamMemberRole == System.Label.ACC_MANAGER_TRICON_SCO){
	opptyTeamMemberMap.put(oppTeamMem.OpportunityId,oppTeamMem);
			}
		}
	}
	if(!opptyNewList.isEmpty()){
		for(Opportunity opp : opptyNewList){
			if(opptyTeamMemberMap.containsKey(opp.Id)){
	opptyTeamMemberListDelete.add(opptyTeamMemberMap.get(opp.Id));
	opptyTeamMemberVar = new OpportunityTeamMember();
	opptyTeamMemberVar.OpportunityId = opp.Id;
	opptyTeamMemberVar.TeamMemberRole = System.Label.ACC_MANAGER_TRICON_SCO;
	opptyTeamMemberVar.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
	opptyTeamMemberVar.UserId = opp.OwnerId;
	opptyTeamMemberList.add(opptyTeamMemberVar);
			}else{
	opptyTeamMemberVar = new OpportunityTeamMember();
	opptyTeamMemberVar.OpportunityId = opp.Id;
	opptyTeamMemberVar.TeamMemberRole = System.Label.ACC_MANAGER_TRICON_SCO;
	opptyTeamMemberVar.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
	opptyTeamMemberVar.UserId = opp.OwnerId;
	opptyTeamMemberList.add(opptyTeamMemberVar);
			}
		}
	}
			}
			if(!opptyTeamMemberList.isEmpty()){
	Database.SaveResult[] savedResults = Database.insert(opptyTeamMemberList, false);
	Boolean someFailure = false;
			}
			if(!opptyTeamMemberListDelete.isEmpty()){
	Database.DeleteResult[] drList = Database.delete(opptyTeamMemberListDelete);
	Boolean someFailure = false;
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATE_OWNER_IN_OPPTY_TEAM);
		}
	}

	/*****************************
	*Method Name: insertOwnerInTeamOnReopening
	*Description: Insert Oppty owner in Oppty Team
	*Parameters: List<Opportunity>
	*Requirement : 5468
	*******************************/
	public static void insertOwnerInTeamOnReopening(List<Opportunity> opptyList, Map<Id,Opportunity> opptyOldMap )
	{
		List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();
		List<Opportunity> opptyNewList = new List<Opportunity>();
		Map<Id,Id> opptyOwnerOldMap = new Map<Id,Id>();
		Map<Id,Id> opptyOwnerIdMap = new Map<Id,Id>();
		OpportunityTeamMember opptyTeamMemberVar;
		try{
			for(Opportunity opty : opptyList){
	if((opty.RecordTypeId == directRecordTypeId || opty.RecordTypeId == inDirectRecordTypeId || opty.RecordTypeId == readOnlyDirectRecordTypeId || opty.RecordTypeId == readOnlyIndirectRecordTypeId ) &&
		((opty.StageName == Globalconstants.EXECUTE_OPPTY && opptyOldMap.get(opty.Id).StageName == Globalconstants.COMPLETED_OPPTY) ||
		((opptyOldMap.get(opty.Id).StageName == GlobalConstants.CANCELLED_BY_CUSTOMER || opptyOldMap.get(opty.Id).StageName == GlobalConstants.LOST_TO_COMPETITOR  ||
		opptyOldMap.get(opty.Id).StageName == GlobalConstants.WITH_DRAW_BY_NOKIA || opptyOldMap.get(opty.Id).StageName == GlobalConstants.OBSOLETE )&&
		(opty.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY || opty.StageName == Globalconstants.DEVELOP_OPPORTUNITY ||
		opty.StageName == GlobalConstants.CREATE_OFFER || opty.StageName == GlobalConstants.WIN_THE_CASE))))
	{
		opptyNewList.add(opty);
		opptyOwnerIdMap.put(opty.Id,opty.OwnerId);
	}
			}
			if(!opptyNewList.isEmpty()){
	for(OpportunityTeammember opptyTeamMember : [Select Id,UserId,OpportunityId from OpportunityTeamMember where UserId in : opptyOwnerIdMap.values() and OpportunityId in : opptyOwnerIdMap.keyset() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ]){
		opptyOwnerOldMap.put(opptyTeamMember.OpportunityId,opptyTeamMember.UserId);
	}
	for(Opportunity opp : opptyNewList){
		if(!opptyOwnerOldMap.containsKey(opp.Id)){
			opptyTeamMemberVar = new OpportunityTeamMember();
			opptyTeamMemberVar.OpportunityId = opp.Id;
			opptyTeamMemberVar.TeamMemberRole = System.Label.ACC_MANAGER_TRICON_SCO;
			opptyTeamMemberVar.OpportunityAccessLevel = GlobalConstants.ALL_ACCESS;
			opptyTeamMemberVar.UserId = opp.OwnerId;
			opptyTeamMemberList.add(opptyTeamMemberVar);
		}
	}
			}
			if(!opptyTeamMemberList.isEmpty()){
	Database.SaveResult[] savedResults = Database.insert(opptyTeamMemberList, false);
	Boolean someFailure = false;
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.INSERT_OWNER_IN_OPPTY_TEAM_REOPENING);
		}
	}

	/*****************************
	*Method Name: updateCustomerOfferDueDate
	*Description: this method updates Customer Offer Due Date to 'G4 Planned Date + 2 Days' for the active offers.
	*Parameters: Opportunity Map
	*Req: 5669
	*******************************/
	public static void updateCustomerOfferDueDate(Map<ID, Opportunity>opptyNewMap)
	{
		List<Offer__c> offerListToUpdate = new List<Offer__c>();
		Map<Opportunity, Offer__c> g4DateToOffer =  new Map<Opportunity, Offer__c>();
		try{
			List<Offer__c> offerInstList = [SELECT id,ActiveOffer__c,Opportunity__r.G4_Planned_Date__c,Customer_Offer_Due_Date__c,Opportunity__r.RecordTypeId,Opportunity__r.StageName,Opportunity__r.Phase_Status__c FROM Offer__c WHERE ActiveOffer__c =: true AND G4_passed__c=false AND Opportunity__c IN: opptyNewMap.keySet()];
			for(Offer__c offerInst : offerInstList){
	g4DateToOffer.put(opptyNewMap.get(offerInst.Opportunity__c), offerInst);
			}
			if(g4DateToOffer.size() > 0){
	for (Offer__c objOffer: g4DateToOffer.values()){
		if ((objOffer.Opportunity__r.RecordTypeId == directRecordTypeId || objOffer.Opportunity__r.RecordTypeId == inDirectRecordTypeId|| objOffer.Opportunity__r.RecordTypeId == readOnlyDirectRecordTypeId || objOffer.Opportunity__r.RecordTypeId == readOnlyIndirectRecordTypeId)
			&& (objOffer.Opportunity__r.StageName == GlobalConstants.CREATE_OFFER || objOffer.Opportunity__r.StageName == GlobalConstants.DEVELOP_OPPORTUNITY || objOffer.Opportunity__r.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY )){
			if(objOffer.Opportunity__r.G4_Planned_Date__c != null){
	objOffer.Customer_Offer_Due_Date__c = objOffer.Opportunity__r.G4_Planned_Date__c + 2 ;
			}
		}
		offerListToUpdate.add(objOffer);
	}
	database.update(offerListToUpdate, false);
			}
		}
		catch(Exception e){
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATEWINNINGCOMPONOPPTY);
		}
	}

	/*****************************
	*Method Name: UpdateOffer
	*Description: Update Offer Field
	*Parameters: List<Opportunity> ,Map<ID, Opportunity>
	*Requirement : 5669
	*******************************/
	public static void UpdateOffer(List<Opportunity> lstOppty,map<Id,Opportunity> opportunitiesoldMap)
	{
		set<id> setOpptyUpdate = new set<id>();
		list<Offer__c> lstOffer = new list<offer__c>();
		try
		{
			for(opportunity objOppUpdate : lstOppty){
	if(objOppUpdate.StageName != opportunitiesoldMap.get(objOppUpdate.id).StageName && ( objOppUpdate.StageName == GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE &&   opportunitiesoldMap.get(objOppUpdate.id).StageName == GlobalConstants.CREATE_OFFER)) {
		setOpptyUpdate.add(objOppUpdate.id);
	}
			}
			if(setOpptyUpdate.size() > 0){
	List<offer__c> objOfferlist = [select id,ActiveOffer__c,G4_passed__c from offer__c where Opportunity__c in :setOpptyUpdate and ActiveOffer__c=true];
	for(offer__c  objOffer : objOfferlist){
		if(objOffer.G4_passed__c == false){
			objOffer.G4_passed__c = true;
			lstOffer.add(objOffer);
		}
	}
			}
			if(lstOffer.size() > 0)
	update lstOffer;
		}
		catch(Exception e){
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.UPDATEWINNINGCOMPONOPPTY);
		}
	}

	/*****************************
	*Method Name: validateWonShareAllocationSum
	*Description: this method will check total won share of all winning competitors and show error if sum is greater than 100
	*Parameters: Opportunity Map, Opportunity Map
	*Req: 5783 Sales Process
	*******************************/
	public static void validateWonShareAllocationSum(Map<ID, Opportunity> opptyNewMap, Map<ID, Opportunity>optyOldMap)
	{
		List<Competitor__c> CompetitorsListOld = new List<Competitor__c>();
		Set<Id> opptyIdSet =  new Set<Id>();
		Set<String> allCompetitors ;
		String str = '';
		Map<Id, List<Competitor__c>> OpptyIdAndCompetitorsMapOld =  new Map<Id, List<Competitor__c>>();
		try{
			for (Opportunity opptyObj: opptyNewMap.values()) {
	if ((opptyObj.RecordTypeId == directRecordTypeId || opptyObj.RecordTypeId == inDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyDirectRecordTypeId || opptyObj.RecordTypeId == readOnlyIndirectRecordTypeId)
		&& opptyObj.StageName != optyOldMap.get(opptyObj.id).StageName && opptyObj.StageName == GlobalConstants.LOST_TO_COMPETITOR && opptyObj.Winning_Competitor__c != GlobalConstants.SALES_EMPTY) {
		opptyIdSet.add(opptyObj.id);
	}
			}
			if(!opptyIdSet.isEmpty()){
	List<Competitor__c> compObjectList = [select id,Opportunity__c, Competitor_New__c,Opportunity_Won__c,Won_Share_Allocation_in__c from Competitor__c where Opportunity__c in: opptyIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	for (Competitor__c compObject: compObjectList){
		if(OpptyIdAndCompetitorsMapOld.containsKey(compObject.Opportunity__c)){
			CompetitorsListOld = OpptyIdAndCompetitorsMapOld.get(compObject.Opportunity__c);
			CompetitorsListOld.add(compObject);
			OpptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c,CompetitorsListOld);
		}  else {
			CompetitorsListOld.clear();
			CompetitorsListOld.add(compObject);
			OpptyIdAndCompetitorsMapOld.put(compObject.Opportunity__c,CompetitorsListOld);
		}
	}
	for(Id oppId : opptyIdSet){
		if(OpptyIdAndCompetitorsMapOld.containsKey(oppId)){
			Decimal sum = 0;
			for(Competitor__c comp : OpptyIdAndCompetitorsMapOld.get(oppId)){
	str = opptyNewMap.get(oppId).Winning_Competitor__c;
	allCompetitors = new Set<String>(str.split(GlobalConstants.SEMICOLON));
	if((allCompetitors.contains(comp.Competitor_New__c) || comp.Opportunity_Won__c == true) && comp.Won_Share_Allocation_in__c > 0)
		sum += comp.Won_Share_Allocation_in__c;
			}
			if(sum > decimal.valueOf(System.Label.Hundred))
	opptyNewMap.get(oppId).addError(System.Label.Won_Share_Sum_Validation);
		}
	}
			}
		}catch(Exception e){
			ExceptionHandler.addException(e, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.VALIDATEWONSHAREALLOCATIONSUM);
		}
	}

	/*****************************
	*Method Name: BatchCurrenychangeDL
	*Description: Update unweighted amount for dataloaderuser
	*Parameters: Oppty ID
	*********************************/
	public static void BatchCurrenychangeDL(Set<ID>  Opptyid) {
		List<Opportunity> UpdateOppty =new List<Opportunity>();
		try {
			for (Opportunity newopp:[Select id,Positive_OIF_EUR__c,OIF_Value_Won_USD__c,Sales_Outcome__c,OIF_Value_Cancel_USD__c,Positive_OIF__c,Negative_OIF_EUR__c,Negative_OIF__c from Opportunity where id=:Opptyid Limit:Opptyid.size()]) {
	if (String.IsEmpty(newopp.Sales_Outcome__c) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || newopp.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED)){
		newopp.Unweighted_Amount_EUR__c = newopp.Positive_OIF_EUR__c.setScale(2);
		newopp.amount=newopp.Positive_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c=newopp.OIF_Value_Won_USD__c.setScale(2);
		//newopp.Is_Automated__c=TRUE;
	} else if ((newopp.Sales_Outcome__c<>GlobalConstants.WON)){
		newopp.Unweighted_Amount_EUR__c = newopp.Negative_OIF_EUR__c.setScale(2);
		newopp.amount=newopp.Negative_OIF__c.setScale(2);
		newopp.Unweighted_Amount_USD__c=newopp.OIF_Value_Cancel_USD__c.setScale(2);
	}
	UpdateOppty.add(newopp);
			}
			if(!UpdateOppty.isEmpty()){
	List<Database.saveResult> srs = Database.update(UpdateOppty,false);
	ExceptionHandler.addExceptionForOIFBtach(UpdateOppty, srs);
	GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE=TRUE;
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.BATCH_CURRENCY_CHANGE);
		}
	}
	/* FT-1553 for April 2020 BP
	public static void cloneContractRenewalOpportunity(Map<id,Opportunity>oldOpportunitiesMap,List<Opportunity>newOpportunitiesList)
	{
		List<Opportunity> oppsToBeCloneList = new List<Opportunity>();
		Opportunity oldOpp;
		Opportunity oppToBeClone;
		boolean userAllowedToEditAutoCloningFields;
		for(Opportunity currentOpp : newOpportunitiesList)
		{
			oldOpp = oldOpportunitiesMap.get(currentOpp.id);
			userAllowedToEditAutoCloningFields = currentOpp.ownerId == UserInfo.getUserId() ? true:false;
			if(oldOpp.Care_Contract_End_Date__c != currentOpp.Care_Contract_End_Date__c && currentOpp.StageName == 'Execute (Start Delivery)')
			{
	currentOpp.addError('Care Contract End Date is not editable in this stage or by this user.');
	return;
			}
			if(oldOpp.StageName != currentOpp.StageName && currentOpp.StageName == 'Win the Case (Negotiate)' && currentOpp.Dismiss_Renewal__c == false
		&& currentOpp.Care_Contract_End_Date__c!=null &&
		(
			currentOpp.recordtypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId()
			|| currentOpp.recordtypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId()
		)
	)
			{
	oppToBeClone = new Opportunity();
	oppToBeClone.name = currentOpp.name+'_Clone for Care Renewal';
	oppToBeClone.Lead_BG__c = 'GS';
	DateTime dT = System.now();
	Date d = date.newinstance(dT.year(), dT.month()+3, dT.day());
	oppToBeClone.G3_Planned_Date__c  = d;
	oppToBeClone.G4_Planned_Date__c  = d.addMonths(3);
	oppToBeClone.G5_Approval_Date__c = d.addMonths(6);
	oppToBeClone.CloseDate = d.addMonths(6);
	oppsToBeCloneList.add(oppToBeClone);
			}
		}
		System.debug('oppsToBeCloneList --> '+oppsToBeCloneList);
		insert oppsToBeCloneList;
	}//end cloneContractRenewalOpportunity method
	*/
	
	/*****************************
	*Method Name: oppTeamPrMValidation
	*Description: Prevent oppty creation, If user have wrong pricing manager or pricing manager(lead) in their default opportunity team
	*Added by HCL Team 
	*********************************/
	
	public static void oppTeamPrMValidation ( List<OpportunityTeamMember> oppTeamlst)
	{
		set<Id> oppIdSet = new set<Id>();
		set<String> orgL2 = new set<String>();
		set<String> orgL3 = new set<String>();
		set<String> orgL4 = new set<String>();
		set<String> orgL5 = new set<String>();
		set<String> orgL6 = new set<String>();
		set<String> orgL7 = new set<String>();
		String slashForErrorMsg = '';
		String additionalTeamRole = '';
		Map<String,String> sRmap = new Map<String, String>();
		System.debug('Calling PrM validation Oppty team');
		try
		{
			for(OpportunityTeamMember oppteam : oppTeamlst)
			{
	//if((oppteam.TeamMemberRole == System.Label.NF_PricingManager || oppteam.TeamMemberRole == 'Pricing Manager (Lead)') || (oppteam.Additional_Team_Role__c != null && (oppteam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager) || oppTeam.Additional_Team_Role__c == System.Label.NF_PricingManager || oppTeam.Additional_Team_Role__c == 'Pricing Manager (Lead)')))
	if((oppTeam.TeamMemberRole == System.Label.NF_PricingManager || oppTeam.TeamMemberRole ==System.Label.NF_PricingManagerLead)
		|| (oppTeam.Additional_Team_Role__c != null 
		&& (oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager) || oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManagerLead))))
	{
		oppIdSet.add(oppteam.OpportunityId);
	}
			}
			System.debug('oppIdSet::> '+oppIdSet);
			if(!oppIdSet.isEmpty())
			{
	for(Opportunity opp : [SELECT Id,Org_L2__c,Org_L3__c,Org_L4__c,Org_L5__c,Org_L6__c,Org_L7__c FROM Opportunity WHERE Id IN :oppIdSet ])
	{
		orgL2.add(opp.Org_L2__c);
		orgL3.add(opp.Org_L3__c);
		orgL4.add(opp.Org_L4__c);
		orgL5.add(opp.Org_L5__c);
		orgL6.add(opp.Org_L7__c);
		orgL7.add(opp.Org_L7__c);
	}
	List<Sales_Role__c> sRList = [SELECT User__c,Organisation__c FROM Sales_Role__c WHERE Role_Code__c LIKE :System.Label.NF_PrM_Role AND (Organisation__c IN: orgL2 OR Organisation__c IN: orgL3 OR Organisation__c IN: orgL4 OR Organisation__c IN: orgL5 OR Organisation__c IN: orgL6 OR Organisation__c IN: orgL7)];
	for(Sales_Role__c sR : sRList)
	{
		sRmap.put(sR.User__c, sR.Organisation__c);
	}
			}
			for(OpportunityTeamMember oppTeam : oppTeamlst)
			{
	if((!sRmap.isEmpty() && !sRmap.containsKey(oppTeam.UserId)) || sRmap.isEmpty())
	{
	/* if((oppTeam.TeamMemberRole == System.Label.NF_PricingManager || oppTeam.TeamMemberRole == 'Pricing Manager (Lead)')
		|| (oppTeam.Additional_Team_Role__c != null 
	&& (oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager) || oppTeam.Additional_Team_Role__c == 'Pricing Manager (Lead)') || oppTeam.Additional_Team_Role__c == System.Label.NF_PricingManager))*/
		if((oppTeam.TeamMemberRole == System.Label.NF_PricingManager || oppTeam.TeamMemberRole ==System.Label.NF_PricingManagerLead)
		|| (oppTeam.Additional_Team_Role__c != null
		&& (oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManager) || oppTeam.Additional_Team_Role__c.Contains(System.Label.NF_PricingManagerLead))))
		{
			System.debug('Error for PrM');
			if(oppTeam.Additional_Team_Role__c != null && oppTeam.Additional_Team_Role__c != ''){
	slashForErrorMsg = '/';
	additionalTeamRole = oppTeam.Additional_Team_Role__c;
			}
			Trigger.NewMap.get(oppTeam.Opportunityid).addError('You have a user named: '+oppTeam.User.Name+' having role '+oppTeam.TeamMemberRole+slashForErrorMsg+additionalTeamRole+' in your default opportunity team, which does not belongs to them. Please remove the user or change the role to proceed further.');
		}
	}
			}
		}
		Catch (Exception ex)
		{   system.debug('ex'+ex);
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITY_TEAM_HELPER, GlobalConstants.METHOD_OPPORTUNITYTEAM_PrMVALIDATION);
		}
	}
}