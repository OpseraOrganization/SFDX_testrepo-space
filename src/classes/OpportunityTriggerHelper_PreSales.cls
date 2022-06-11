/*******************************
Class Name: OpportunityTriggerHelper_PreSales
Created by: Accenture
Created Date: 05th June 2017
Last modified by: Accenture
Last modified date: 05th June 2017
Description: This class will handle the logic implemented on PreSales Opportunity
Note : Fix to handle unwanted update on probability in inline editing on Opportunity
*******************************/
public class OpportunityTriggerHelper_PreSales
{
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PSR_RECORD_TYPE).getRecordTypeId();
	private static Boolean thresholdsCalculated = false;

	/***************************
	* Requirement Details:  Pre-Sales:Sprint 6: Req#2316 + Req#5539
	*Method Name: convertionTotalCostsPreSales
	*Description: Updating Total Cost and Sales Value To EUR
	*Parameters: Opportunity opptyList1, Map<Id,Opportunity> psroOldMap
	***********************/
	public static void convertionTotalCostsPreSales(List<Opportunity> psroList, Map<Id,Opportunity> psroOldMap){
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false;
		try{
			Set<String> psroCurrencies = new Set<String>();
			Map<String,Decimal> datedRatesMap = new Map<String,Double>();
			Map<Id,Opportunity> utilOpptyMap = new Map<Id,Opportunity>();
			for (Opportunity psro : psroList) {
	psroCurrencies.add(psro.CurrencyIsoCode);
	utilOpptyMap.put(psro.Id,psro.clone(true,true,true,true));
			}

			for (Dated_Exchange_Rates__c ratecollect :  [Select Id, CurrencyIsoCode, Exchange_Rate__c, Start_Date__c  from Dated_Exchange_Rates__c where CurrencyIsoCode =: psroCurrencies
					 AND DER_Period__r.Current_Period__c = true LIMIT: Limits.getLimitQueryRows()]){
	datedRatesMap.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
			}
			//calling this function to recalculate the formulas on the PSRO , specially the Total Costs and Total Sales, so then automatically used in Total Euros fields
			//because the formulas are not yet updated on Before trigger
			Formula.recalculateFormulas(utilOpptyMap.values());
	 	for(Opportunity psro : psroList){
	Opportunity recalculatedOppty = utilOpptyMap.get(psro.Id);
	if(psro.CurrencyIsoCode != GlobalConstants.EUR && datedRatesMap.containsKey(psro.CurrencyIsoCode)){
		psro.PSR_Total_Cost_in_Euro__c = recalculatedOppty.PSR_Total_Cost_in_Local_Currency__c / datedRatesMap.get(psro.CurrencyIsoCode) ;
		psro.PSR_Total_Sales_Value_in_Euro__c = (recalculatedOppty.PSR_Total_Sales_Value_in_Local_Currency__c/datedRatesMap.get(psro.CurrencyIsoCode)).setscale(2);
	}else {
		psro.PSR_Total_Cost_in_Euro__c =  recalculatedOppty.PSR_Total_Cost_in_Local_Currency__c;
		psro.PSR_Total_Sales_Value_in_Euro__c = recalculatedOppty.PSR_Total_Sales_Value_in_Local_Currency__c;
	}
			}
		}catch(Exception ex){
			System.debug(GlobalConstants.ERROR_OCCURED + ex);
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , 'convertionTotalCostsPreSales');
		}
	}

	/*****************************
	*Requirement Details:  Pre-Sales:Sprint 6: Req#2171
	*Method Name: updaterecordTypeWhenPreSaleTypeIsOtherThanRSRO
	*Description: This method will set recordtype according to Pre_Sales_Opportunity_Type__c to PreSales Risk Opp Edit Record Type when an Oppty is cloned as well
	*Parameters: Opportunity List
	*Test coverage from: OpportunityTriggerHelperTest
	**********************************/
	public static void updaterecordTypeWhenPreSaleTypeIsOtherThanRSRO(List<Opportunity>opportunityList) {
		try {
			for (Opportunity opp: opportunityList) {
	if(opp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.TRIAL) ||
	   opp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.DEMO) ||
	   opp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.FOC) ||
	   opp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.RISK_ORDER)){
		opp.RecordTypeId = PSR_EditRecordTypeID;
		system.debug('opp.RecordTypeId>>>>>>>>>>>>>'+opp.RecordTypeId);
	   }
			}
		} catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.UPDATERECORDTYPEWHENPRESALETYPEISOTHERTHANRSRO);
		}
	}

	/***************************
	* Requirement Details:  Pre-Sales:Sprint 6: Req#2316
	*Method Name: populateParentCurrencyOnPreSales
	*Description: Fetching parent opportunities currency
	*Parameters: Opportunity opptyList1
	***********************/
	public static void populateParentCurrencyOnPreSales(List<Opportunity>opptyList , Map<Id,Opportunity> refOppties){
		try{
			for (Opportunity opportunity: opptyList){
	if(refOppties.containsKey(opportunity.PSR_Reference_Opportunity__c)){
		opportunity.currencyISOCode = refOppties.get(opportunity.PSR_Reference_Opportunity__c).currencyISOCode;
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.POPULATEPARENTCURRENCYONPRESALES);
		}
	}

	/***************************
	* Requirement Details:  Pre-Sales:Sprint 6: Req#2316
	*Method Name: setInitialSalesPhase
	*Description: Sales Phase set to Preparation on creation of PSRO
	*Parameters: opptyList, refOppties
	***********************/
	public static void setInitialSalesPhase(List<Opportunity>opptyList , Map<Id, Opportunity> refOppties){
		try{
			for (Opportunity opportunity: opptyList){
	if(refOppties.containsKey(opportunity.PSR_Reference_Opportunity__c)){
		opportunity.StageName = GlobalConstants.PREPARATION;
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , 'setInitialSalesPhase' );
		}
	}

	/***************
	*Requirement Details:  Pre-Sales:Sprint 6: Req#2337
	*Method Name: getNokiaPeriodName
	*Description: Fetching of the nokia Period from the Nokia_Financial_Calendar__c object
	*Parameters: Opportunity opptyList, Map optyOldMap, Nokia_Financial_Calendar__c nokiaList
	**************/
	public static void getNokiaPeriodName(List<Opportunity> opptyList, Map<Id, Opportunity> opportunityOldMap, Map<Id, Opportunity> opportunityNewMap){
		Map<Id,Date> opportunityIdAndCloseDateMap = new Map<Id,Date>();
		Map<Id, Nokia_Financial_Calendar__c> IdAndNokiaFinancialCalenderMap =  new Map<Id, Nokia_Financial_Calendar__c>();

		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true; // to stop recursion of trigger
		try{
			for(Opportunity opty: opptyList){
	if(opportunityOldMap == null || (opty.CloseDate != opportunityOldMap.get(opty.Id).CloseDate))
		opportunityIdAndCloseDateMap.put(opty.Id, opty.CloseDate);
			}
			system.debug('opportunityIdAndCloseDateMap>>>>'+opportunityIdAndCloseDateMap);
			if(!opportunityIdAndCloseDateMap.isEmpty()){
	IdAndNokiaFinancialCalenderMap = new Map<Id, Nokia_Financial_Calendar__c>([SELECT Name,Start_Date__c,End_Date__c  From Nokia_Financial_Calendar__c
						 Where Start_Date__c <=: opportunityIdAndCloseDateMap.values() and
						 End_Date__c >=: opportunityIdAndCloseDateMap.values() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
			}

			for(Opportunity oppty : opptyList){
	Id opportunityId = oppty.Id;
	if(opportunityIdAndCloseDateMap.containsKey(opportunityId) ){
		for(Id nokiaFinalcialCalendarId : IdAndNokiaFinancialCalenderMap.keySet()){
			if(oppty.CloseDate >= IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).Start_Date__c &&
		 oppty.CloseDate <= IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).End_Date__c){
		  oppty.PSR_Nokia_Period__c = IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).Name;
		 }
		}
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.GETNOKIAPERIODNAME );
		}
	}

	/***************
	*Requirement Details:  Pre-Sales:Sprint 7: Req#2248
	*Method Name: populatePreSalesOpportunityNumber
	*Description: Adjust the Pre-Sales Risk Opportunity Id format of each Pre-Sales Risk Opportunity:
	If Parent Opportunity is - 17.US.123456
	o   RO - 17.US.123456.R.001
	o   Trial - 17.US.123456.T.002
	o   Demo - 17.US.123456.D.003
	o   FoC - 17.US.123456.F.004
	o   RO - 17.US.123456.R.005
	*Parameters: List<Opportunity> psroList
	**************/
	public static void populatePreSalesOpportunityNumber(List<Opportunity> psroList, Map<Id,Opportunity> refOppties){
		Map<Id, List<Opportunity>> parentOpptyToPSROs = new Map<Id, List<Opportunity>>();

		try{
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true; // to stop recursive trigger executionof opty

			for(Opportunity psro : psroList){
	parentOpptyToPSROs.put(psro.PSR_Reference_Opportunity__c, new List<Opportunity>());
			}

			if(!parentOpptyToPSROs.isEmpty()){
	//get all childs from each Sales Parent Oppty
	List<Opportunity> childoptys = [SELECT Id, Opportunity_ID__c, PSR_Reference_Opportunity__c,createdDate FROM Opportunity
			WHERE PSR_Reference_Opportunity__c =: parentOpptyToPSROs.keySet() ORDER BY CreatedDate DESC LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ALL ROWS];

	//Map the childs per parent
	for(Opportunity child : childoptys){
		if(parentOpptyToPSROs.containsKey(child.PSR_Reference_Opportunity__c)){
			parentOpptyToPSROs.get(child.PSR_Reference_Opportunity__c).add(child);
		}
	}

	for(Opportunity psro : psroList){
		String typeCode = getPSROTypeCode(psro);
		if(typeCode == null)
			continue;
		String psroNumber = '';
		Opportunity refOppty = refOppties.get(psro.PSR_Reference_Opportunity__c);
		if(refOppty == null)
			continue;
		psroNumber += refOppty.Opportunity_ID__c + GlobalConstants.DOT + typeCode + GlobalConstants.DOT;
		Integer countId = 0;
		Integer newestChildNumber = 0;
		if(parentOpptyToPSROs.get(refOppty.Id).size() > 0){
			Opportunity newestChild = parentOpptyToPSROs.get(refOppty.Id)[0]; //this is the newest PSRO because used ORDER BY on query
			newestChildNumber = newestChild.Opportunity_ID__c.right(3) != null ? Integer.valueOf(newestChild.Opportunity_ID__c.right(3)) : 0;
			countId = newestChildNumber;
		}
		countId++;
		psroNumber += (String.valueOf(countId)).leftPad(3,GlobalConstants.ZERO);
		psro.Opportunity_ID__c = psroNumber;
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.METHOD_POPULATEPRESALESOPPTYNUMBER );
		}
	}

	/***************
	*Method Name: getPSROList
	*Description: Validate which opportunities are PSROs
	*Parameters: List<Opportunity> opptyList
	**************/
	public static List<Opportunity> getPSROList(List<Opportunity> opptyList){
		List<Opportunity> preSalesOptyList  = new List<Opportunity> ();
		try{
			for(Opportunity opty : opptyList){
	if(opty.RecordTypeId == PSR_EditRecordTypeID || opty.RecordTypeId == PSR_ReadOnlyRecordTypeID)
	{
		preSalesOptyList.add(opty);
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , 'getPSROList' );
		}
		return preSalesOptyList;
	}

	/***************
	*Method Name: getIsApplicableForPreSalesList
	*Description: Validate which opportunities are PSROs
	*Parameters: List<Opportunity> opptyList
	**************/
	public static List<Opportunity> getIsApplicableForPreSalesList(List<Opportunity> opptyList){
		List<Opportunity> preSalesOptyList  = new List<Opportunity> ();
		try{
			for(Opportunity opty : opptyList){
	if(opty.RecordTypeId == PSR_EditRecordTypeID )
	{
		preSalesOptyList.add(opty);
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.GETISAPPLICABLEFORPRESALESLIST );
		}
		system.debug('getIsApplicableForPreSalesList - '+preSalesOptyList);
		return preSalesOptyList;
	}

	/***************
	*Method Name: getIsApplicableForPreSalesListWithReadOnly
	*Description: Validate which opportunities are PSROs as read only record type
	*Parameters: List<Opportunity> opptyList
	**************/
	public static List<Opportunity> getIsApplicableForPreSalesListWithReadOnly(List<Opportunity> opptyList){
		List<Opportunity> preSalesOptyListReadOnly  = new List<Opportunity> ();
		try{
			for(Opportunity opty : opptyList){
	if(opty.RecordTypeId == PSR_ReadOnlyRecordTypeID )
	{
		preSalesOptyListReadOnly.add(opty);
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.GETISAPPLICABLEFORPRESALESLIST );
		}
		system.debug('helper preSalesOptyListReadOnly'+ opptyList);
		return preSalesOptyListReadOnly;
	}

	/***************
	*Requirement Details:  Pre-Sales:Sprint 8: Req#2760
	*Method Name: populateParentCurrency
	*Description: When a parent Opportunity's Currency is changed, all the pre sales child records' currency should be changed
	*Parameters: List<Opportunity> opptyList, Map<Id, Opportunity> opportunityOldMap
	**************/
	public static void populateParentCurrency(List<Opportunity>opptyList, Map<Id, Opportunity> opportunityOldMap){
		try{
			Map<Id, Opportunity> opportunityIdAndOpportunityMap = new Map<Id, Opportunity>();
			List<Opportunity> psrOpportunities = new List<Opportunity>();

			for (Opportunity newrec: opptyList) {
	if(newrec.currencyISOCode != opportunityOldMap.get(newrec.Id).currencyISOCode){
		System.debug('In populateParentCurrency');
		opportunityIdAndOpportunityMap.put(newrec.Id, newrec);
	}
			}
			if(!opportunityIdAndOpportunityMap.isEmpty()){
	for(Opportunity psrOppty : [select Id,currencyISOCode,PSR_Reference_Opportunity__c from Opportunity
					where PSR_Reference_Opportunity__c in: opportunityIdAndOpportunityMap.keySet() and stagename =: GlobalConstants.PREPARATION
					LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){
			if(opportunityIdAndOpportunityMap.containsKey(psrOppty.PSR_Reference_Opportunity__c)){
				System.debug('In populateParentCurrency for loop>>');
				psrOppty.currencyISOCode = opportunityIdAndOpportunityMap.get(psrOppty.PSR_Reference_Opportunity__c).currencyISOCode;
				psrOpportunities.add(psrOppty);
			}
					}
	if(!psrOpportunities.isEmpty()){
		Database.SaveResult[] savedResults = Database.update(psrOpportunities, false);
		// add exception into exception if there is any in database.saveresult.
		ExceptionHandler.generateExceptionRecordFromSaveResult(savedResults, GlobalConstants.METHOD_POPULATECURRENCY, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES);
	}
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex,GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.METHOD_POPULATECURRENCY );
		}
	}

	/***************
	*Requirement Details:  Pre-Sales:Sprint 8: Req#2503
	*Method Name: NotifyOpportunityTeamMembers
	*Description: When Opportunity is submitted for approval,rejected,approved then notify OTMs via chatter feed
	//modified for Ticket 00012822 : PSRO cancellation notif email fired when Account LE updated in "Reference Sales Opportunity"
	//Chatter Post to Oppty and Offer Team members to inform about to Opportunity Closed Status info
	Req:5077 - chatter post on oppty close(positive and negative)
	*Parameters: List<Opportunity> opptyList
	**************/
	public static void notifyOTMsAndApprovalContributorsWhenClosed(list<Opportunity>opportunitiesList, map<Id, Opportunity> mapIdOldOpp, map<Id, Opportunity> mapIdNewOpp) {
		Map<Id, Opportunity> mapOptyIdAndOTMs = new Map<Id, Opportunity>();
		try{
			for(Opportunity opportunity : opportunitiesList){
	//modified for Ticket 00012822 : PSRO cancellation notif email fired when Account LE updated in "Reference Sales Opportunity"
	if(((String.isEmpty(mapIdOldOpp.get(opportunity.Id).stagename) && String.isNotEmpty(mapIdNewOpp.get(opportunity.Id).stagename))
		|| (String.isNotEmpty(mapIdOldOpp.get(opportunity.Id).stagename) && String.isNotEmpty(mapIdNewOpp.get(opportunity.Id).stagename)
			&& mapIdOldOpp.get(opportunity.Id).stagename != mapIdNewOpp.get(opportunity.Id).stagename))
	   && (opportunity.stagename == GlobalConstants.COMPLETED_OPPTY || opportunity.stagename == GlobalConstants.CANCEL)){
		mapOptyIdAndOTMs.put(opportunity.Id, opportunity);
	   }
	//end modified for Ticket 00012822
			}
			if(mapOptyIdAndOTMs.size() > 0)
	notifyWhenPresalesOpptyClosed(mapOptyIdAndOTMs.keySet());
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.NOTIFYOPPORTUNITYTEAMMEMBERS );
		}
	}

	/***************
	*Requirement Details:  Pre-Sales:Sprint 8: Req#2503,R-8  Req:5077
	*Method Name: NotifyOpportunityTeamMembers
	*Description: When Opportunity is submitted for approval,rejected,approved then notify OTMs via chatter feed
	//modified for Ticket 00012822 : PSRO cancellation notif email fired when Account LE updated in "Reference Sales Opportunity"
	//Chatter Post to Oppty and Offer Team members to inform about to Opportunity Closed Status info
	Req:5077 - chatter post on oppty close(positive and negative)
	*Parameters: List<Opportunity> opptyList
	**************/
	@future
	public static void notifyWhenPresalesOpptyClosed(Set<Id> opptyIdSet) {
		//end modified for Ticket 00012822
		Map<Id, Set<Id>> mapOppIdRelatedUsers = new Map<Id, Set<Id>>();
		Map<Id, Opportunity> mapOptyIdAndOTMs = new Map<Id, Opportunity>();
		ConnectApi.TextSegmentInput textSegmentInput1;
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment1;
		ConnectApi.MarkupEndSegmentInput markupEndSegment1;
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment2;
		ConnectApi.MarkupEndSegmentInput markupEndSegment2;
		ConnectApi.FeedItemInput feedItemInput ;
		ConnectApi.MessageBodyInput messageBodyInput ;
		ConnectApi.TextSegmentInput textSegmentInput ;
		ConnectApi.MentionSegmentInput mentionSegmentInput ;
		List<Id> lstIds;

		try{
			if(opptyIdSet.size() > 0){
	mapOptyIdAndOTMs = new Map<Id,Opportunity>([select Id,OwnerId,Name,Account_Name__c,
						PSR_Pre_Sales_Risk_Opportunity_Type__c,
						StageName,Opportunity_Id__c,Lead_BG__c
						from Opportunity
						where id in: opptyIdSet
						LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
	system.debug('mapOptyIdAndOTMs>>>'+mapOptyIdAndOTMs);
	// fill the mapOppIdRelatedUsers Map by opportunity Owners
	for (Opportunity opp: MapOptyIdAndOTMs.values()) {
		if (!mapOppIdRelatedUsers.containsKey(opp.Id)) {
			mapOppIdRelatedUsers.put(opp.Id, new set<Id>());
		}
		mapOppIdRelatedUsers.get(opp.Id).add(opp.OwnerId);
	}
	// fill the Map by opportunity team members
	for (OpportunityTeamMember opportunityTeamMember: [SELECT UserId, OpportunityId FROM OpportunityTeamMember WHERE OpportunityId IN: mapOptyIdAndOTMs.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
		if (!mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId)) {
			mapOppIdRelatedUsers.put(opportunityTeamMember.OpportunityId, new set<Id>());
		}
		mapOppIdRelatedUsers.get(opportunityTeamMember.OpportunityId).add(opportunityTeamMember.UserId);
	}

	// fill the Map by approvers /stackeholders /valIdators
	//Apttus_Approval__Approval_Status__c
	for(Apttus_Approval__Approval_Request__c reqInfo:[SELECT Id,Apttus_Approval__Step_Name__c, Apttus_Approval__Backup_From_User__c,  Apttus_Approval__Assigned_To_Id__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
				  FROM Apttus_Approval__Approval_Request__c WHERE Apttus_Approval__Object_Id__c IN: mapOptyIdAndOTMs.keySet() AND Apttus_Approval__Assigned_To_Id__c<>NULL])
	{
		if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c ))
		{
			mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c,new Set<id>());
		}
		mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Assigned_To_Id__c);
		if (ReqInfo.Apttus_Approval__DelegateApproverIds__c != GlobalConstants.SALES_EMPTY) {
			String[] delegateApproverIds = ReqInfo.Apttus_Approval__DelegateApproverIds__c.split(GlobalConstants.COMMA);
			for (string delegateapproverId: delegateApproverIds) {
				if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
		mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, new Set<id>());
				}
				mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(delegateapproverId);
			}
		}
		if (ReqInfo.Apttus_Approval__Backup_From_User__c != GlobalConstants.SALES_EMPTY) {
			if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
				mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, new Set<Id>());
			}
			mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Backup_From_User__c);
		}
	}
	system.debug('mapOppIdRelatedUsers>>>'+mapOppIdRelatedUsers);
	for (Id oppId: mapOptyIdAndOTMs.keySet()) {
		if (mapOppIdRelatedUsers.get(OppId) != null) {
			integer iNumber = 24 ;
			integer startLoop = 0;
			feedItemInput = new ConnectApi.FeedItemInput();
			messageBodyInput = new ConnectApi.MessageBodyInput();
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput1 = new ConnectApi.TextSegmentInput();
			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			lstIds = new list<Id>(mapOppIdRelatedUsers.get(oppId));
			system.debug('lstIds>>>>>>'+lstIds);
			textSegmentInput1.text = GlobalConstants.DEAR ;
			messageBodyInput.messageSegments.add(textSegmentInput1);

			for (integer j = StartLoop; j<StartLoop + iNumber; j++) {
				if (lstIds.size()>j) {
		mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.Id = lstIds[j];
		if(mentionSegmentInput != null){
			messageBodyInput.messageSegments.add(mentionSegmentInput);
		}
				}
			}
			StartLoop += iNumber;
			textSegmentInput.text = GlobalConstants.COMMAS ;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//Paraghraph
			markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegment2);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegment2);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.THE_PRE_SALES_RISK_OPPORTUNITY  ;
			if ((mapOptyIdAndOTMs.get(oppId).stagename).Contains(GlobalConstants.COMPLETED_OPPTY)) {
				textSegmentInput.text += MapOptyIdAndOTMs.get(oppId).PSR_Pre_Sales_Risk_Opportunity_Type__c + GlobalConstants.GAP + MapOptyIdAndOTMs.get(oppId).Name + GlobalConstants.GAP + MapOptyIdAndOTMs.get(oppId).Account_Name__c + GlobalConstants.HAS_BEEN + mapOptyIdAndOTMs.get(oppId).StageName + GlobalConstants.DOT_SYMBOL;
			}
			if ((mapOptyIdAndOTMs.get(oppId).stagename).Contains(GlobalConstants.CANCEL)) {
				textSegmentInput.text += MapOptyIdAndOTMs.get(oppId).PSR_Pre_Sales_Risk_Opportunity_Type__c + GlobalConstants.GAP + MapOptyIdAndOTMs.get(oppId).Name + GlobalConstants.GAP + MapOptyIdAndOTMs.get(oppId).Account_Name__c  + GlobalConstants.HAS_BEEN + + mapOptyIdAndOTMs.get(oppId).StageName + GlobalConstants.DOT_SYMBOL;
			}
			messageBodyInput.messageSegments.add(textSegmentInput);

			//Paraghraph
			markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegment2);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegment2);

			//Oppty Number
			markupBeginSegment1 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment1.markupType = ConnectApi.MarkupType.Bold;
			messageBodyInput.messageSegments.add(markupBeginSegment1);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.oppty_Number + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegment1 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment1.markupType = ConnectApi.MarkupType.Bold;
			messageBodyInput.messageSegments.add(markupEndSegment1);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = mapOptyIdAndOTMs.get(oppId).Opportunity_Id__c;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//Paraghraph
			markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegment2);
			markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegment2);

			//Oppty Name
			markupBeginSegment1 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment1.markupType = ConnectApi.MarkupType.Bold;
			messageBodyInput.messageSegments.add(markupBeginSegment1);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.oppty_Name + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegment1 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment1.markupType = ConnectApi.MarkupType.Bold;
			messageBodyInput.messageSegments.add(markupEndSegment1);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = mapOptyIdAndOTMs.get(oppId).Name;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//Paraghraph
			markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegment2);
			markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegment2);

			//Customer
			markupBeginSegment1 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment1.markupType = ConnectApi.MarkupType.Bold;
			messageBodyInput.messageSegments.add(markupBeginSegment1);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text +=GlobalConstants.Oppty_Customer + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegment1 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment1.markupType = ConnectApi.MarkupType.Bold;
			messageBodyInput.messageSegments.add(markupEndSegment1);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = MapOptyIdAndOTMs.get(oppId).Account_Name__c ;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//Paraghraph
			markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegment2);
			markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegment2);

			//Lead BG
			markupBeginSegment1 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment1.markupType = ConnectApi.MarkupType.Bold;
			messageBodyInput.messageSegments.add(markupBeginSegment1);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Big_Dot+GlobalConstants.SPACE;
			textSegmentInput.text += GlobalConstants.Oppty_Lead_BG  + GlobalConstants.SPACE;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegment1 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment1.markupType = ConnectApi.MarkupType.Bold;
			messageBodyInput.messageSegments.add(markupEndSegment1);

			if(mapOptyIdAndOTMs.get(oppId).Lead_BG__c != Null){
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = mapOptyIdAndOTMs.get(oppId).Lead_BG__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
			}

			//Paraghraph
			markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegment2);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegment2);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Regards + GlobalConstants.COMMA ;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//Paraghraph
			markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegment2);
			markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegment2);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Nokia_CRM ;
			messageBodyInput.messageSegments.add(textSegmentInput);

			//Paraghraph
			markupBeginSegment2 = new ConnectApi.MarkupBeginSegmentInput();
			markupBeginSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupBeginSegment2);
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.NBSP;
			messageBodyInput.messageSegments.add(textSegmentInput);
			markupEndSegment2 = new ConnectApi.MarkupEndSegmentInput();
			markupEndSegment2.markupType = ConnectApi.MarkupType.Paragraph;
			messageBodyInput.messageSegments.add(markupEndSegment2);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.OPPORTUNITY_LINK;
			textSegmentInput.text += GlobalConstants.SPACE;
			textSegmentInput.text += URL.getSalesforceBaseUrl().toExternalForm();
			textSegmentInput.text += GlobalConstants.LINK2+ mapOptyIdAndOTMs.get(oppId).Id;
			messageBodyInput.messageSegments.add(textSegmentInput);

			feedItemInput.body = messageBodyInput;
			system.debug(' feedItemInput.body>>>'+ feedItemInput.body);
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			system.debug(' feedItemInput.feedElementType>>>'+feedItemInput.feedElementType);
			feedItemInput.subjectId = oppId;
			system.debug('feedItemInput.feedElementType'+feedItemInput.feedElementType);
			system.debug('feedItemInput>>>'+feedItemInput);
			if (!test.isRunningTest()) {
				ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
			}
		}
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.notifyWhenPresalesOpptyClosed );
		}
	}

	/*****************************
	*Requirement Details:  Pre-Sales:Sprint 12: Defect#5492
	*Method Name: checkCurrency
	*Description: This method will prevent manually editing the Opportunity Currency for all preSales opptys
	*Parameters: Opportunity List, Opportunity Map, Map ref opportunities
	*******************************/
	public static void checkCurrency(List<Opportunity>opportunityList, Map<Id, Opportunity>opportunityOldMap, Map<Id,Opportunity> refOppties)
	{
		try
		{
			for(Opportunity psro : opportunityList)
			{
	if(psro.CurrencyIsoCode != opportunityOldMap.get(psro.Id).CurrencyIsoCode && refOppties.containsKey(psro.PSR_Reference_Opportunity__c) &&
	   psro.CurrencyIsoCode != refOppties.get(psro.PSR_Reference_Opportunity__c).CurrencyIsoCode){
		psro.addError(GlobalConstants.YOU_CANNOT_CHANGE_PRE_SALES_OPPORTUNITIES_CURRENCY);
	   }
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , 'checkCurrency' );
		}
	}

	/***************
	*Requirement Details:  Pre-Sales:Sprint 10: Req#3097  + presales - Jan 18 Release :  5541 and 5647 ---- Changed on March 2021
	*Method Name: costCalculationWhenEstimatedCostChecked
	*Description: When The Estimated Cost is Checked, Automatically Cost values are updated.
	*Parameters: List<Opportunity> opptyList, Map<Id, Opportunity> opportunityOldMap
	**************/
	public static void costCalculationWhenEstimatedCostChecked(List<Opportunity> psroList, Map<Id,Opportunity> psroOldMap){
		try{
			for(Opportunity psro : psroList) {
	Opportunity oldPSRO = psroOldMap.get(psro.Id);
	Boolean salesValueChanged = salesValuesChanged(psro,oldPSRO);
	Boolean costValueChanged = costsValuesChanged(psro,oldPSRO);
	//If 'Automatically Calculate Estimated Cost' is true and any cost field changed - throw error
	if ( psro.StageName != GlobalConstants.PREPARATION && (salesValueChanged || costValueChanged || psro.PSR_Automatically_Calc_Estimated_Cost__c != oldPSRO.PSR_Automatically_Calc_Estimated_Cost__c )){
		psro.addError(GlobalConstants.ERROR_MESSAGE_SALES_COSTS_LOCK_AFTER_PREPARATION);
	} else if( psro.PSR_Automatically_Calc_Estimated_Cost__c && costValueChanged ){
		psro.addError(GlobalConstants.ERROR_MESSAGE_COSTS_CANT_CHANGE_MANUALLY);
	} else if ( psro.PSR_Automatically_Calc_Estimated_Cost__c && (salesValueChanged  || psro.PSR_Automatically_Calc_Estimated_Cost__c != oldPSRO.PSR_Automatically_Calc_Estimated_Cost__c)){
		if(psro.PSR_Sales_Value_BU_NI_FN__c != null)
			psro.PSR_Cost_BU_NI_FN__c = (psro.PSR_Sales_Value_BU_NI_FN__c*Integer.valueOf(System.Label.PSR_Sales_Value_BU_NI_FN_Percentage))/100 ;
		else
			psro.PSR_Cost_BU_NI_FN__c = null;
		if(psro.PSR_Sales_Value_BU_NI_IPRTG__c != null)
			psro.PSR_Cost_BU_NI_IPRTG__c = (psro.PSR_Sales_Value_BU_NI_IPRTG__c*Integer.valueOf(System.Label.PSR_Sales_Value_BU_NI_IPRTG_Percentage))/100 ;
		else
			psro.PSR_Cost_BU_NI_IPRTG__c = null;
		if(psro.PSR_Sales_Value_BU_NI_OPTICS__c != null)
			psro.PSR_Cost_BU_NI_OPTICS__c = (psro.PSR_Sales_Value_BU_NI_OPTICS__c*Integer.valueOf(System.Label.PSR_Sales_Value_BU_NI_OPTICS_Percentage))/100 ;
		else
			psro.PSR_Cost_BU_NI_OPTICS__c = null;
		if(psro.PSR_Sales_Value_BG_MN__c != null)
			psro.PSR_Cost_BG_MN__c = (psro.PSR_Sales_Value_BG_MN__c*Integer.valueOf(System.Label.PSR_Sales_Value_MN_Percentage))/100 ;
		else
			psro.PSR_Cost_BG_MN__c = null;
		if(psro.PSR_Sales_Value_BG_CNS__c != null)
			psro.PSR_Cost_BG_CNS__c = (psro.PSR_Sales_Value_BG_CNS__c*Integer.valueOf(System.Label.PSR_Sales_Value_CNS_Percentage))/100 ;
		else
			psro.PSR_Cost_BG_CNS__c = null;
	}
			}
		}catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.COSTCALCULATIONWHENESTIMATEDCOSTCHECKED);
		}
	}

	/***************
	Requirement Details:  Pre-Sales:Sprint 12: Req#3457, Sprint -19 : Req#5561
	*Method Name: psrApprovalLevel
	*Description: Validate if costs changed and if so recalculate the LoA Level
	*Parameters: List<Opportunity> psroList, Map<Id,Opportunity> optyOldMap
	**************/
	public static void psrApprovalLevel(List<Opportunity> psroList , Map<Id,Opportunity> psroOldMap, Map<Id,Opportunity> refOppties ) {
		try{
			List<Opportunity> psroUpdated = new List<Opportunity>();

			for (Opportunity psro: psroList)
			{
	if(costsValuesChanged(psro, psroOldMap.get(psro.Id))){
		psroUpdated.add(psro);
	}
			}

			if(psroUpdated.isEmpty()){
	return;
			}
			calculatePSROApprovalLevel(psroUpdated, null, refOppties);

		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, 'psrApprovalLevel');
		}
	}

	/***************
	Requirement Details:  Pre-Sales:Sprint 12: Req#3457, Sprint -19 : Req#5561 + COE F2033, Changed on March 2021 due to new structure on BGs/BUs
	Method Name: psroUpdateThreshold
	Description: Update current value in Threshold object.
	Parameters: List<Opportunity> opptyList, Map<Id,Opportunity> optyOldMap
	**************/
	public static void psroUpdateThreshold(List<Opportunity> opptyList, Map<Id,Opportunity> optyOldMap)
	{
		try
		{
			if(thresholdsCalculated)
	return;

			List<PSRO_Market_Threshold__c> thresholds = new List<PSRO_Market_Threshold__c>();
	 	List<Opportunity> psros = new List<Opportunity>();
			Set<Id> psrosExclude = new Set<ID>();
			Set<String> markets = new Set<String>();
			Set<Id> thresholdsExceeded = new Set<Id>();
			Map<String,String> mapMarketUnit_Market = new Map<String,String>();

			//get the matrix for the correspondent market for specific market units
			for(Map_Enterprise_MUs_and_Market__c mapping : Map_Enterprise_MUs_and_Market__c.getAll().values()){
	mapMarketUnit_Market.put(mapping.Enterprise_MU__c, mapping.Market__c);
	mapMarketUnit_Market.put(mapping.Market__c, mapping.Enterprise_MU__c);
			}

			for(Opportunity oppty : opptyList){
	Opportunity oldOppty = optyOldMap.get(oppty.Id);
	if( oppty.StageName != oldOppty.StageName &&  oppty.StageName == GlobalConstants.IN_EXECUTION ){
		psros.add(oppty);
		addMarkets(mapMarketUnit_Market, markets, oppty);
	} else if( oppty.StageName != oldOppty.StageName && oldOppty.StageName == GlobalConstants.IN_EXECUTION ){
		psrosExclude.add(oppty.Id);
		addMarkets(mapMarketUnit_Market, markets, oppty);
	}
			}

			if(psros.isEmpty() && psrosExclude.isEmpty()){
	return;
			}

			//fetches all the other PSROs in the same markets that are In Execution because it's necessary to recalculate all due to inconsistencies with dated rates whenever the thresholds are updated
			//It will not consider on the query the PSROs that triggered this method - those are considered above (and only the ones moving to In Execution, the other moving to Completed are not considered anymore in the thresholds)
			//the ones moving to In Execution are not yet with that sales phase on database
			psros.addAll([SELECT Id, PSR_Cost_BU_NI_FN__c , PSR_Cost_BU_NI_IPRTG__c , PSR_Cost_BU_NI_OPTICS__c , PSR_Cost_BG_MN__c , PSR_Cost_BG_CNS__c, PSR_Cost_BG_NI__c,
		   Org_L3__c,Org_L4__c,Org_L5__c,CurrencyIsoCode FROM Opportunity
		   WHERE (RecordTypeId = :PSR_EditRecordTypeID OR RecordTypeId = :PSR_ReadOnlyRecordTypeID) AND
		   PSR_Pre_Sales_Risk_Opportunity_Type__c = :GlobalConstants.RISK_ORDER AND (Org_L4__c IN :markets OR Org_L5__c IN :markets)  AND StageName = 'In Execution'
		   AND Id NOT IN : psrosExclude]);

			thresholds = calculatePSROMarketThresholds(psros, thresholdsExceeded);
			if(thresholds != null)
	Database.update(thresholds);
			if(!thresholdsExceeded.isEmpty()){
	sendPSROThresholdEmail(thresholdsExceeded);
			}
			thresholdsCalculated = true;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.UpdateValueinThresholdObject);
		}
	}

	/***************
	*Method Name: addMarkets
	*Description: util method to add markets to the search
	*Parameters: Map<String,String> mapMarketUnit_Market, Set<String> markets, Opportunity oppty
	**************/
	private static void addMarkets(Map<String,String> mapMarketUnit_Market, Set<String> markets, Opportunity oppty){
		if(mapMarketUnit_Market.containsKey(oppty.Org_L5__c)){
			markets.add(mapMarketUnit_Market.get(oppty.Org_L5__c));
		}
		if(mapMarketUnit_Market.containsKey(oppty.Org_L4__c)){
			markets.add(mapMarketUnit_Market.get(oppty.Org_L4__c));
		}
		markets.add(oppty.Org_L4__c);
	}

	/***************
	*Requirement Details:  Pre-Sales:Sprint 8: Req#2503
	*Method Name: NotifyOpportunityTeamMembers
	*Description: When Opportunity is submitted for approval,rejected,approved then notify OTMs via chatter feed
	*Parameters: List<Opportunity> opptyList
	**************/
	public static void notifyOTMsAndApprovalContributorsWhenReset(List<Opportunity>opportunitiesList, Map<Id, Opportunity>optyOldMap){

		Map<Id, Set<Id>> mapOppIdRelatedUsers = new Map<Id, Set<Id>>();
		Map<Id, Opportunity> mapOptyIdAndOTMs = new Map<Id, Opportunity>();
		Map<Id, Id> mapOptyIdAndAccountId = new Map<Id, Id>();
		Map<Id, String>optyIdAndAccountName = new Map<Id, String>();
		ConnectApi.TextSegmentInput textSegmentInput1;
		ConnectApi.FeedItemInput feedItemInput ;
		ConnectApi.MessageBodyInput messageBodyInput ;
		ConnectApi.TextSegmentInput textSegmentInput ;
		ConnectApi.MentionSegmentInput mentionSegmentInput ;
		List<Id> lstIds;

		try{
			for(Opportunity opportunity : opportunitiesList){
	if(opportunity.stagename.equalsIgnoreCase(GlobalConstants.IN_EXECUTION) && optyOldMap.get(opportunity.Id).PSR_Reset_PSRO__c != opportunity.PSR_Reset_PSRO__c){
		mapOptyIdAndOTMs.put(opportunity.Id, opportunity);
		mapOptyIdAndAccountId.put(opportunity.Id, opportunity.AccountId);
	}
			}
			system.debug('mapOptyIdAndOTMs>>>'+mapOptyIdAndOTMs);
			if(!mapOptyIdAndOTMs.isEmpty()){
	if(!mapOptyIdAndAccountId.isEmpty()){
		for(Opportunity op:  [select Id,Account.Name from Opportunity where Id in : mapOptyIdAndAccountId.keySet()]){
			optyIdAndAccountName.put(op.Id,op.Account.Name);
		}
	}

	// fill the mapOppIdRelatedUsers Map by opportunity Owners
	for (Opportunity opp: opportunitiesList) {
		if (!mapOppIdRelatedUsers.containsKey(opp.Id)) {
			mapOppIdRelatedUsers.put(opp.Id, new Set<Id>());
		}
		mapOppIdRelatedUsers.get(opp.Id).add(opp.OwnerId);
	}
	// fill the Map by opportunity team members
	for (OpportunityTeamMember opportunityTeamMember: [SELECT UserId, OpportunityId FROM OpportunityTeamMember WHERE OpportunityId IN: mapOptyIdAndOTMs.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
		if (!mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId)) {
			mapOppIdRelatedUsers.put(opportunityTeamMember.OpportunityId, new Set<Id>());
		}
		mapOppIdRelatedUsers.get(opportunityTeamMember.OpportunityId).add(opportunityTeamMember.UserId);
	}

	// fill the Map by approvers /stackeholders /valIdators
	//Apttus_Approval__Approval_Status__c
	for(Apttus_Approval__Approval_Request__c ReqInfo:[SELECT Id,Apttus_Approval__Step_Name__c, Apttus_Approval__Assigned_To_Id__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
				  FROM Apttus_Approval__Approval_Request__c
				  WHERE Apttus_Approval__Object_Id__c IN: mapOptyIdAndOTMs.keySet() AND Apttus_Approval__Assigned_To_Id__c<>NULL])
	{
		if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
			mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, new Set<Id>());
		}
		mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Assigned_To_Id__c);
		if (ReqInfo.Apttus_Approval__DelegateApproverIds__c != GlobalConstants.SALES_EMPTY) {
			String[] delegateApproverIds = ReqInfo.Apttus_Approval__DelegateApproverIds__c.split(GlobalConstants.COMMA);
			for (string delegateapproverId: delegateApproverIds) {
				if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
		mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, new Set<Id>());
				}
				mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(delegateapproverId);
			}
		}
	}
	system.debug('mapOppIdRelatedUsers>>>'+mapOppIdRelatedUsers);
	for (Id oppId: mapOptyIdAndOTMs.keySet()) {
		if (mapOppIdRelatedUsers.get(OppId) != null) {
			integer iNumber = 24 ;
			integer StartLoop = 0;
			feedItemInput = new ConnectApi.FeedItemInput();
			messageBodyInput = new ConnectApi.MessageBodyInput();
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput1 = new ConnectApi.TextSegmentInput();

			messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			lstIds = new list<Id>(mapOppIdRelatedUsers.get(oppId));
			system.debug('lstIds>>>>>>'+lstIds);
			textSegmentInput1.text = GlobalConstants.DEAR ;
			messageBodyInput.messageSegments.add(textSegmentInput1);

			for (integer j = StartLoop; j<StartLoop + iNumber; j++) {
				if (lstIds.size()>j) {
		mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		mentionSegmentInput.Id = lstIds[j];
		if(mentionSegmentInput != null){
			messageBodyInput.messageSegments.add(mentionSegmentInput);
		}
				}
			}
			StartLoop += iNumber;
			textSegmentInput.text = GlobalConstants.strSegInput ;
			textSegmentInput.text += GlobalConstants.THE_PRE_SALES_RISK_OPPORTUNITY  ;
			textSegmentInput.text += mapOptyIdAndOTMs.get(oppId).PSR_Pre_Sales_Risk_Opportunity_Type__c + GlobalConstants.GAP + mapOptyIdAndOTMs.get(oppId).Name + GlobalConstants.GAP + optyIdAndAccountName.get(oppId) ;
			textSegmentInput.text += GlobalConstants.HAS_BEEN_SET_TO_PREP_MSG;
			textSegmentInput.text += GlobalConstants.NEWLINE + GlobalConstants.OPPORTUNITY_LINK+ URL.getSalesforceBaseUrl().toExternalForm() + GlobalConstants.FORWARDSLASH + mapOptyIdAndOTMs.get(oppId).Id;
			textSegmentInput.text += GlobalConstants.KIND_REGARDS ;
			textSegmentInput.text += GlobalConstants.YOUR_SINGLECRM_SUPPORT_TEAM;

			messageBodyInput.messageSegments.add(textSegmentInput);

			feedItemInput.body = messageBodyInput;
			system.debug(' feedItemInput.body>>>'+ feedItemInput.body);
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			system.debug(' feedItemInput.feedElementType>>>'+feedItemInput.feedElementType);
			feedItemInput.subjectId = oppId;
			system.debug('feedItemInput.feedElementType'+feedItemInput.feedElementType);
			system.debug('feedItemInput>>>'+feedItemInput);
			if (!test.isRunningTest()) {
				ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
			}
		}
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.NOTIFYOPPORTUNITYTEAMMEMBERS );
		}
	}

	/*****************************
	*Method Name: updateProbability
	*Description: Custom code to populate Parent Oppty Probability to new PSR oppty or when the stage changes
	*Requirement: PreSales : 5072
	*Parameters: optyList, optyOldMap, refOppties
	*******************************/
	public static void updateProbability(List<Opportunity>optyList, Map<Id, Opportunity> optyOldMap, Map<Id,Opportunity> refOppties) {
		try{
			for(Opportunity psro : optyList){
	if( (optyOldMap == null || optyOldMap.get(psro.Id).stagename != psro.stagename )  &&  refOppties.containsKey(psro.PSR_Reference_Opportunity__c)){
		psro.Probability = refOppties.get(psro.PSR_Reference_Opportunity__c).Probability;
		system.debug('Update probability on '+psro.Id+ ' value '+psro.Probability);
	}
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, 'updateProbability');
		}
	}

	/*****************************
	*Method Name: sendPSROThresholdEmail
	*Description: send email to each "BG Finance Level A PSRO validator" for the threshold with value exceeded
	*Parameters: thresholdExceed
	*******************************/
	@future(callout=true)
	public static void sendPSROThresholdEmail(Set<Id> thresholdsIds)
	{
		try
		{
			List<PSRO_Market_Threshold__c> thresholdsExceeded = [SELECT Id, Business_Group__c, Business_Unit__c FROM PSRO_Market_Threshold__c WHERE ID IN : thresholdsIds];
			EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE developerName =:Label.NF_ThresholdExceededNotification LIMIT 1];
			List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
			Set<String> roleList = new Set<String>(Label.PSRO_Threshold_send_Mail.split(';'));
			List<Sales_Role__c> salesRoleList = [Select Id, BG__c, O__c, User__C from Sales_Role__c where Role_Code__c in :roleList];

			for(PSRO_Market_Threshold__c threshold : thresholdsExceeded)
			{
	for(Sales_Role__c salesRole : salesRoleList)
	{
		if(salesRole.BG__C == threshold.Business_Group__c || salesRole.BG__C == threshold.Business_Unit__c)
		{
			Messaging.SingleEmailMessage newEmail = new Messaging.SingleEmailMessage();
			newEmail.setWhatId(threshold.Id);
			newEmail.setTargetObjectId(salesRole.User__c);
			newEmail.setTemplateId(et.Id);
			newEmail.setSaveAsActivity(false);
			mailList.add(newEmail);
		}
	}
			}

			if(!mailList.isEmpty() && !Test.isRunningTest()){
	system.debug('Send mail:'+mailList);
	Messaging.sendEmail(mailList);
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.PSROThresholdMail, GlobalConstants.PSROThresholdMail);
		}
	}

	/*****************************
	*Method Name: getReferenceOpptyFromPSRO
	*Description: fetch the reference opportunities of PSRO to prevent multiple queries
	*Parameters: psroList
	*******************************/
	public static Map<Id,Opportunity> getReferenceOpptyFromPSRO(List<Opportunity> psroList) {
		Map<Id,Opportunity> refOppties = new Map<Id,Opportunity>();
		Set<Id> refOpptyIds = new Set<Id>();
		for(Opportunity psro : psroList) {
			if(psro.PSR_Reference_Opportunity__c != null)
	refOpptyIds.add(psro.PSR_Reference_Opportunity__c);
		}
		if(!refOpptyIds.isEmpty()){
			refOppties = new Map<Id,Opportunity>([SELECT Id,Opportunity_ID__c, Name, Probability, AccountId, CurrencyIsoCode, G4_Approval_Date__c FROM Opportunity WHERE Id IN : refOpptyIds]);
		}
		return refOppties;
	}

	/***************
	*Method Name: setLeadBG_BU
	*Description: Re-calculate the BG and BU according to the costs
	*Parameters: Opportunity psro
	**************/
	private static void setLeadBG_BU(Opportunity psro){
		Decimal totalCostNI = returnValueOfField(psro.PSR_Cost_BU_NI_FN__c) + returnValueOfField(psro.PSR_Cost_BU_NI_IPRTG__c) + returnValueOfField(psro.PSR_Cost_BU_NI_OPTICS__c);
		Map<String,Decimal> costValues = new Map<String,Decimal>{GlobalConstants.BG_CNS => psro.PSR_Cost_BG_CNS__c, GlobalConstants.LEAD_BG_MN => psro.PSR_Cost_BG_MN__c, GlobalConstants.BG_NI => totalCostNI};
		String leadBG = null;
		String leadBU = null;
		Decimal maxCost = 0.0;
		for(String bg : costValues.keySet()){
			if(costValues.get(bg) != null && costValues.get(bg) > maxCost){
	leadBG = bg;
	maxCost = costValues.get(bg);
			}
		}
		psro.Lead_BG__c = leadBG;
		if(leadBG == GlobalConstants.BG_NI){
			costValues = new Map<String,Decimal>{GlobalConstants.BU_NI_FN => psro.PSR_Cost_BU_NI_FN__c, GlobalConstants.BU_NI_IPRTG => psro.PSR_Cost_BU_NI_IPRTG__c, GlobalConstants.BU_NI_OPTICS => psro.PSR_Cost_BU_NI_OPTICS__c};
			maxCost = 0.0;
			for(String bu : costValues.keySet()){
	if(costValues.get(bu) != null && costValues.get(bu) > maxCost){
		leadBU = bu;
		maxCost = costValues.get(bu);
	}
			}
		}
		psro.Lead_BU__c = leadBU;
	}

	/***************
	*Method Name: calculatePSROApprovalLevel
	*Description: calculate the LoA Level Pre-Sales on PSRO - depending on where it's called could either bring map for Ref Oppties (from trigger) or it will do a query (other classes)
	*Parameters: List<Opportunity> psroList, Set<Id> refOpptiesIds, Map<Id,Opportunity> refOpptiesMap
	**************/
	public static void calculatePSROApprovalLevel(List<Opportunity> psros, Set<Id> refOpptiesIds, Map<Id,Opportunity> refOppties){
		Map<String,Decimal> datedRatesMap = new Map<String,Decimal>();
		Set<String> psroCurrencies = new Set<String>();
		Set<String> markets = new Set<String>();
		List<PSR_Gate_Classification_Logic__c> matrixPSROApprovalLevel = PSR_Gate_Classification_Logic__c.getall().values();
		Map<String,PSRO_Market_Threshold__c> thresholdsMap = new Map<String,PSRO_Market_Threshold__c>();
		Decimal datedRate = 1.0;
		Map<String,String> mapMarketUnit_Market = new Map<String,String>();

		//get the matrix for the correspondent market for specific market units
		for(Map_Enterprise_MUs_and_Market__c mapping : Map_Enterprise_MUs_and_Market__c.getAll().values()){
			mapMarketUnit_Market.put(mapping.Enterprise_MU__c, mapping.Market__c);
		}

		for(Opportunity psro : psros){
			psroCurrencies.add(psro.CurrencyIsoCode);
			markets.add(mapMarketUnit_Market.containsKey(psro.Org_L5__c) ? mapMarketUnit_Market.get(psro.Org_L5__c) : psro.Org_L4__c);
		}

		//on the thresholds to facilitate finding the right one on market and BG or BU it's used a map with key Market/BG or Market/BU if the threshold is either defined at BG level or BU level
		for(PSRO_Market_Threshold__c threshold : getPSROMarketThresholds(markets))
		{
			String key = threshold.Market__c+GlobalConstants.BackSlash+ (threshold.Business_Unit__c != null ? threshold.Business_Unit__c : threshold.Business_Group__c);
			thresholdsMap.put(key, threshold);
		}

		for (Dated_Exchange_Rates__c ratecollect: getDatedExchangeRates(psroCurrencies))
		{
			datedRatesMap.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
		}

		if(refOppties == null || refOppties.isEmpty()){
			refOppties = new Map<Id,Opportunity>([SELECT Id, G4_Approval_Date__c FROM Opportunity WHERE Id IN : refOpptiesIds]);
		}

		for(Opportunity psro : psros){
			setLeadBG_BU(psro);
			if(psro.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.RISK_ORDER)){
	datedRate = datedRatesMap.get(psro.CurrencyIsoCode);
	//if any threshold is exceeded with the costs of this PSRO, then it's set LoA = A
	//if reference oppty has not been through G4 , then it's set LoA = A
	String market = mapMarketUnit_Market.containsKey(psro.Org_L5__c) ? mapMarketUnit_Market.get(psro.Org_L5__c) : psro.Org_L4__c;
	if(addCostValueToThreshold(thresholdsMap, datedRate, psro, market) || (refOppties.containsKey(psro.PSR_Reference_Opportunity__c) && refOppties.get(psro.PSR_Reference_Opportunity__c).G4_Approval_Date__c == null)){
		psro.PSR_LoA_Level__c = GlobalConstants.LOA_Level;
		continue;
	}
			}
			//then it checks the matrix for PSRO Approval Level (for all PSRO types)
			for(PSR_Gate_Classification_Logic__c criteria : matrixPSROApprovalLevel){
	if(psro.PSR_Pre_Sales_Risk_Opportunity_Type__c == criteria.Opportunity_Type__c && psro.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c == criteria.Opportunity_Sub_Type__c &&
	   psro.Lead_BG__c == criteria.BG_Value__c &&
	   ( ( psro.PSR_Total_Cost_In_Euro__c >= criteria.Min_Value__c && psro.PSR_Total_Cost_In_Euro__c <= criteria.Max_Value__c ) ||
		( psro.PSR_Total_Cost_In_Euro__c >= criteria.Min_Value__c && criteria.Max_Value__c == null) ) )
	{
		psro.PSR_LoA_Level__c = criteria.LOA_Level__c;
	}
			}
		}
	}

	/*****************************
	*Method Name: calculatePSROMarketThresholds
	*Description:  Util method to calculate PSRO Market Threshold
	*Parameters: List<Opportunity> psros, Set<Id> thresholdsExceeded
	*******************************/
	private static List<PSRO_Market_Threshold__c> calculatePSROMarketThresholds(List<Opportunity> psros, Set<Id> thresholdsExceeded ){
		Set<String> psroCurrencies = new Set<String>();
		Map<String,PSRO_Market_Threshold__c> thresholdsMap = new Map<String,PSRO_Market_Threshold__c>();
		Map<String,Decimal> datedRatesMap = new Map<String,Decimal>();
		Map<String,String> mapMarketUnit_Market = new Map<String,String>();
		Set<String> markets = new Set<String>();

		try {
			//get the matrix for the correspondent market for specific market units
			for(Map_Enterprise_MUs_and_Market__c mapping : Map_Enterprise_MUs_and_Market__c.getAll().values()){
	mapMarketUnit_Market.put(mapping.Enterprise_MU__c, mapping.Market__c);
			}

			for(Opportunity psro : psros){
	psroCurrencies.add(psro.CurrencyIsoCode);
	markets.add(mapMarketUnit_Market.containsKey(psro.Org_L5__c) ? mapMarketUnit_Market.get(psro.Org_L5__c) : psro.Org_L4__c);
			}

			//on the thresholds to facilitate finding the right one on market and BG or BU it's used a map with key Market/BG or Market/BU if the threshold is either defined at BG level or BU level
			for(PSRO_Market_Threshold__c threshold : getPSROMarketThresholds(markets))
			{
	String key = threshold.Market__c+GlobalConstants.BackSlash+ (threshold.Business_Unit__c != null ? threshold.Business_Unit__c : threshold.Business_Group__c);
	threshold.Current_value__c = 0.0;
	thresholdsMap.put(key, threshold);
			}

			for (Dated_Exchange_Rates__c ratecollect : getDatedExchangeRates(psroCurrencies))
			{
	datedRatesMap.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
			}

			for(Opportunity psro : psros) {
	Decimal datedRate = datedRatesMap.get(psro.CurrencyIsoCode);
	if(datedRate == null) continue;
	String market = mapMarketUnit_Market.containsKey(psro.Org_L5__c) ? mapMarketUnit_Market.get(psro.Org_L5__c) : psro.Org_L4__c;
	addCostValueToThreshold(thresholdsMap, datedRate, psro, market);
			}

			checkThresholdValueExceeded(thresholdsMap, thresholdsExceeded);
			return thresholdsMap.values();

		} catch (Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, 'calculatePSROMarketThresholds');
			return null;
		}
	}

	/*****************************
	*Method Name: addCostValueToThreshold
	*Description:  Util method to add the cost value to current value on the respective Threshold record, and when used on calculating LoA on PSRO checks already if exceeded
	*Parameters: Map<String,Decimal> updatedTHValMap, Decimal datedRate, Opportunity psro
	*Return: False if no threshold will exceed, True if at least one will exceed
	*******************************/
	private static Boolean addCostValueToThreshold(Map<String,PSRO_Market_Threshold__c> updatedTHValMap, Decimal datedRate, Opportunity psro, String market){
		Boolean willExceed = false;
		Decimal costValue = 0.0;
		//starting with NI - FN
		String keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BU_NI_FN;
		if(psro.PSR_Cost_BU_NI_FN__c != null && updatedTHValMap.containsKey(keyFilter)){
			costValue = (returnValueOfField(psro.PSR_Cost_BU_NI_FN__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
			updatedTHValMap.get(keyFilter).Current_Value__c += costValue;
			willExceed = willThresholdValueExceed(updatedTHValMap.get(keyFilter),willExceed);
		}
		//checking NI - IPRTG
		keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BU_NI_IPRTG;
		if(psro.PSR_Cost_BU_NI_IPRTG__c != null && updatedTHValMap.containsKey(keyFilter)){
			costValue = (returnValueOfField(psro.PSR_Cost_BU_NI_IPRTG__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
			updatedTHValMap.get(keyFilter).Current_Value__c += costValue;
			willExceed = willThresholdValueExceed(updatedTHValMap.get(keyFilter),willExceed);
		}
		//checking NI - OPTICS
		keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BU_NI_OPTICS;
		if(psro.PSR_Cost_BU_NI_OPTICS__c != null && updatedTHValMap.containsKey(keyFilter)){
			costValue = (returnValueOfField(psro.PSR_Cost_BU_NI_OPTICS__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
			updatedTHValMap.get(keyFilter).Current_Value__c += costValue;
			willExceed = willThresholdValueExceed(updatedTHValMap.get(keyFilter),willExceed);
		}
		//checking NI (if active)
		keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BG_NI;
		if(psro.PSR_Cost_BG_NI__c != null && updatedTHValMap.containsKey(keyFilter)){
			//Cost NI is a formula, but if costs on BU level were changed , since this may be processed on before update the formulas are not yet updated
			Decimal costNI = returnValueOfField(psro.PSR_Cost_BU_NI_OPTICS__c) + returnValueOfField(psro.PSR_Cost_BU_NI_IPRTG__c) + returnValueOfField(psro.PSR_Cost_BU_NI_FN__c);
			costValue = costNI.divide(datedRate,2,System.RoundingMode.HALF_UP) ;
			updatedTHValMap.get(keyFilter).Current_Value__c += costValue;
			willExceed = willThresholdValueExceed(updatedTHValMap.get(keyFilter),willExceed);
		}
		//checking CNS
		keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BG_CNS;
		if(psro.PSR_Cost_BG_CNS__c != null && updatedTHValMap.containsKey(keyFilter)){
			costValue = (returnValueOfField(psro.PSR_Cost_BG_CNS__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
			updatedTHValMap.get(keyFilter).Current_Value__c += costValue;
			willExceed = willThresholdValueExceed(updatedTHValMap.get(keyFilter),willExceed);
		}
		//checking MN
		keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.LEAD_BG_MN;
		if(psro.PSR_Cost_BG_MN__c != null && updatedTHValMap.containsKey(keyFilter)){
			costValue = (returnValueOfField(psro.PSR_Cost_BG_MN__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
			updatedTHValMap.get(keyFilter).Current_Value__c += costValue;
			willExceed = willThresholdValueExceed(updatedTHValMap.get(keyFilter),willExceed);
		}
		return willExceed;
	}

	/*****************************
	*Method Name: willThresholdValueExceed
	*Description:  Util method to check if the threshold value will be exceeded for with a particular PSRO
	*Parameters: PSRO_Market_Threshold__c threshold, Boolean previousCheck
	*******************************/
	private static Boolean willThresholdValueExceed(PSRO_Market_Threshold__c threshold, Boolean previousCheck){
		return previousCheck || (threshold.Current_Value__c > threshold.Threshold_Value__c);
	}

	/*****************************
	*Method Name: checkThresholdValueExceeded
	*Description:  Util method to check if the threshold value is exceeded from the current value - only valid to check if should be sent an email
	*Parameters: Map<String,PSRO_Market_Threshold__c> thresholdsMap, Set<Id> thresholdsExceeded
	*******************************/
	private static void checkThresholdValueExceeded(Map<String,PSRO_Market_Threshold__c> thresholdsMap, Set<Id> thresholdsExceeded) {
		for(PSRO_Market_Threshold__c threshold : thresholdsMap.Values()){
			if(threshold.Current_value__c > threshold.Threshold_Value__c && !threshold.Value_exceeded__c) {
	threshold.Value_exceeded__c = true;
	thresholdsExceeded.add(threshold.Id);
			} else if (threshold.Current_value__c <= threshold.Threshold_Value__c && threshold.Value_exceeded__c) {
	threshold.Value_exceeded__c = false;
			}
		}
	}

	/***************
	*Method Name: getPSROTypeCode
	*Description: get the type code to add in opportunity number
	*Parameters: Opportunity psro
	**************/
	private static String getPSROTypeCode(Opportunity psro)
	{
		String typeCode = null;
		if(psro.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.TRIAL)){
			typeCode = GlobalConstants.TRIALTYPE;
		}else if(psro.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.DEMO)){
			typeCode = GlobalConstants.DEMOTYPE;
		}else if(psro.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.FOC)){
			typeCode = GlobalConstants.FOCTYPE;
		}else if(psro.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.RISK_ORDER)){
			typeCode = GlobalConstants.RISKORDERTYPE;
		}
		return typeCode;
	}

 	/***************
	*Method Name: salesValuesChanged
	*Description: Validate if any of the sales fields were modiefied
	*Parameters: Opportunity opp, Opportunity oldOppty
	**************/
	private static boolean salesValuesChanged(Opportunity opp, Opportunity oldOppty)
	{
		if(opp.PSR_Sales_Value_BU_NI_FN__c  <> oldOppty.PSR_Sales_Value_BU_NI_FN__c
	 || opp.PSR_Sales_Value_BU_NI_IPRTG__c  <> oldOppty.PSR_Sales_Value_BU_NI_IPRTG__c
	 || opp.PSR_Sales_Value_BU_NI_OPTICS__c  <> oldOppty.PSR_Sales_Value_BU_NI_OPTICS__c
	 || opp.PSR_Sales_Value_BG_MN__c  <> oldOppty.PSR_Sales_Value_BG_MN__c
	 || opp.PSR_Sales_Value_BG_CNS__c  <> oldOppty.PSR_Sales_Value_BG_CNS__c )
			return true;
		else
			return false;
	}

	/***************
	*Method Name: costsValuesChanged
	*Description: Validate if any of the cost fields were modiefied
	*Parameters: Opportunity opp, Opportunity oldOppty
	**************/
	private static boolean costsValuesChanged(Opportunity opp, Opportunity oldOppty )
	{
		if(opp.PSR_Cost_BU_NI_FN__c  <> oldOppty.PSR_Cost_BU_NI_FN__c
	 || opp.PSR_Cost_BU_NI_IPRTG__c  <> oldOppty.PSR_Cost_BU_NI_IPRTG__c
	 || opp.PSR_Cost_BU_NI_OPTICS__c  <> oldOppty.PSR_Cost_BU_NI_OPTICS__c
	 || opp.PSR_Cost_BG_MN__c  <> oldOppty.PSR_Cost_BG_MN__c
	 || opp.PSR_Cost_BG_CNS__c  <> oldOppty.PSR_Cost_BG_CNS__c)
			return true;
		else
			return false;
	}

	/***************
	Method Name: getPSROMarketThresholds
	Description: Util method to retrieve all PSRO Market Thresholds
	**************/
	public static List<PSRO_Market_Threshold__c> getPSROMarketThresholds(Set<String> markets){
		if(markets == null)
			return [Select Id, Market__c, Threshold_Value__c,Value_exceeded__c, Current_value__c, Business_Group__c, Business_Unit__c from PSRO_Market_Threshold__c where Active__c = true];
		return [Select Id, Market__c, Threshold_Value__c,Value_exceeded__c, Current_value__c, Business_Group__c, Business_Unit__c from PSRO_Market_Threshold__c where Active__c = true and Market__c In :markets];
	}

	/***************
	Method Name: getDatedExchangeRates
	Description: Util method to retrieve filtered exchange rates
	**************/
	public static List<Dated_Exchange_Rates__c> getDatedExchangeRates(Set<String> currencies){
		return [select Id, CurrencyIsoCode, Exchange_Rate__c, Start_Date__c from Dated_Exchange_Rates__c where CurrencyIsoCode IN : currencies AND DER_Period__r.Current_Period__c = true LIMIT: Limits.getLimitQueryRows()];
	}

	/***************
	Method Name: returnValueOfField
	Description: Util method to retrieve the value
	**************/
	public static Decimal returnValueOfField(Decimal fieldValue){
		Return fieldValue == null ? 0 : fieldValue;
	}
}