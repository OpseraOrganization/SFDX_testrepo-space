/******************************
Class Name: OpportunityTriggerHandler
Created By: Accenture
Improvement Date: 10 Jan 2021
Improved By: HCL Technologies
Description: Handler Class for Opportunity Trigger
Change log : 1.0
1.1 Introduced SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES to stop recusion of opportinity trigger on insert/update of preSales opty
1.1 D-1645 Sprint 5 Hypercare Fixes(Sales Process)
******************************/
public inherited sharing class OpportunityTriggerHandler
{
	public static Map<Id, Opportunity> preSaleOptyOldMap = new Map<Id, Opportunity>();
	public static List<Opportunity> preSaleOptyList =  new List<Opportunity>();
	public static List<Opportunity> preSalesOptyFilter = new List<Opportunity>();
	public static List<Opportunity> preSaleOptyListWithReadOnly  = new List<Opportunity>();
	public static Map<Id, Opportunity> saleOptyMap = new Map<Id, Opportunity>();
	public static boolean batchFlag = true;
	private static boolean flag = true;
	private static boolean oppflag = true;
	private static boolean opptyFlag = true;
	private static boolean chatterNotified = false;
	public static boolean flagForCompetitor = false;
	public static boolean flagForComp = false;
	public static boolean flagForChatter = false;
	public static boolean flagUpsellChange = true;
	public static boolean flagCommittedVal = true;
	public static boolean flagUpsellDeltaDiff = true;
	public static boolean flagForOwnerInsert = false;
	public static boolean flagForOwnerUpdate = false;
	public static boolean flagUpdateOffer = true;
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PSR_RECORD_TYPE).getRecordTypeId();
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	private static final Id readOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_INDIRECT_RECORD_TYPE).getRecordTypeId();

	private OpportunityTriggerHelper OpptTrigHelper;
	public OpportunityTriggerHandler()
	{
		OpptTrigHelper = new OpportunityTriggerHelper();
	}

	/*****************************
*Method Name: beforeUpdate
*Description: This is handler method for before update on opportunity
*Parameters: Opportunity List, Opportunity Map
*******************************/
	public void beforeUpdate(List<Opportunity> optyList, Map<ID, Opportunity> optyOldMap, Map<Id, Opportunity> opptyNewMap)
	{
		List<Opportunity> decisionlist=new List<Opportunity>();
		Map<Id, Opportunity> refOppties = new Map<Id, Opportunity>();

		// PSRO Logic
		// ignore trigger execution for Data Loader profile users
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && !GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES ){
			//check the oppty list for PSROs
			List<Opportunity> psros = OpportunityTriggerHelper_PreSales.getPSROList(optyList); //All PSROs record types
			preSaleOptyList = OpportunityTriggerHelper_PreSales.getIsApplicableForPreSalesList(optyList); //PSRO with Edit Record Type
			if(!psros.isEmpty()){ //--- methods to be calculated to all record type of PSRO
	refOppties = OpportunityTriggerHelper_PreSales.getReferenceOpptyFromPSRO(psros); //fetch at beginning the reference oppties if necessary for other methods
	OpportunityTriggerHelper_PreSales.updateProbability(psros, optyOldMap, refOppties); // PreSales Req:5072
	OpportunityTriggerHelper_PreSales.costCalculationWhenEstimatedCostChecked(psros, optyOldMap);//PreSales Req: 3097
	OpportunityTriggerHelper_PreSales.psroUpdateThreshold(psros, optyOldMap); //PreSales Sprint 26
	OpportunityTriggerHelper_PreSales.checkCurrency(psros, optyOldMap, refOppties); //PreSales:Sprint 8
			}
			if(!preSaleOptyList.isEmpty()){ //--- methods to be calculated to only Edit Record Type
	OpportunityTriggerHelper_PreSales.getNokiaPeriodName(preSaleOptyList, optyOldMap, opptyNewMap); //PreSales
	OpportunityTriggerHelper_PreSales.convertionTotalCostsPreSales(preSaleOptyList, optyOldMap); //PreSales
	OpportunityTriggerHelper_PreSales.psrApprovalLevel(preSaleOptyList, optyOldMap, refOppties); //PreSales Sprint 12
			}
		}
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) &&  ITA_IFM_PAD.canRun('NF_ApprovalRequestTrigger') ){

			if(!optyList.isEmpty()&& !CSWXGlobalConstant.oifCheckStatus){
	CSWXGlobalConstant.oifCheckStatus = true;
			}
			//D-1645 Sprint 5 Hypercare Fixes(Sales Process)
			OpptTrigHelper.populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType(optyList, optyOldMap);
			Map<Id,Account> accountsInfo = OpptTrigHelper.getAccountsInfo(optyList, optyOldMap);
			if(!GlobalConstants.isSearchAndAddEndCustomer){
	OpptTrigHelper.populateDefaultLE(optyList, optyOldMap, accountsInfo);
	OpptTrigHelper.populateEndCustomer(optyList, optyOldMap, accountsInfo);
			}
			OpptTrigHelper.checkLEIsEmpty(optyList, optyOldMap,accountsInfo);
			OpptTrigHelper.checkEnterpriseOpportunity(optyOldMap, optyList);
			OpptTrigHelper.UpdateUserinformation(optyList);
			//Support Ticket:11982
			OpptTrigHelper.removeG3Facilitator(optyList, optyOldMap);
			//Sales Process: Requirement 3062
			//Requirement 953
			List<Opportunity> updateAmount =new List<Opportunity>();
			Map<Id,Opportunity> updateOIFLines = new Map<Id,Opportunity>();
			for(Opportunity oppty :optyList)
			{
	if(oppty.OIF_Lines__c <= 0 && oppty.Amount<>0 && oppty.Amount<>Null )
		updateAmount.add(oppty);
	if(oppty.OIF_Lines__c<>0 && oppty.Amount<>0 && oppty.Amount<>Null && oppty.CurrencyIsoCode<>optyOldMap.get(oppty.id).CurrencyIsoCode)
		updateOIFLines.put(oppty.Id, oppty);
			}
			if(updateAmount.size()>0)
			{
	OpptTrigHelper.convertionrateupdate(updateAmount);
			}
			if(updateOIFLines.size()>0){
	List<Order_Intake_Forecast__c> oifList = [select id, CurrencyIsoCode, OIF_Value_EUR__c, Opportunity__c, OIF_Value__c, POPlanReceipt__c from Order_Intake_Forecast__c where Opportunity__c in :updateOIFLines.keySet()];
	OrderIntakeHepler.ChangeCurrency(oifList, updateOIFLines);
			}
		}

		//Sales Process: New Sales Path
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			//Req 5783
			if(opptyFlag)
			{
	OpptTrigHelper.validateWonShareAllocationSum(new map<Id, Opportunity>(optyList), optyOldMap);
	opptyFlag = false;
			}
			//Requirement 5151
			if(flag)
			{
	OpptTrigHelper.associateUpsellOpptyWithUpsellDeal(new map<Id, Opportunity>(optyList), optyOldMap);
	flag = false;
			}
			/*
			//Req  5073 Sales Process
			if(oppflag)
			{
	OpptTrigHelper.updateWinningCompOnOppty(new map<Id, Opportunity>(optyList), optyOldMap);
	oppflag = false;
			}*/
			//Req 5150
			//OpptTrigHelper.restrictOpptyTypeChange(new map<Id, Opportunity>(optyList), optyOldMap);
			//
			OpptTrigHelper.populateSalesOutcome(optyList, optyOldMap);
			// Requirement 3217
			OpptTrigHelper.populateReasons(new map<Id, Opportunity>(optyList), optyOldMap);
			//Release8:Req#4999
			OpptTrigHelper.committedUpsellOptyClosureValidation(optyList, optyOldMap);
			//Req 4879
			OpptTrigHelper.g4PlannedDateMandatory(new map<Id, Opportunity>(optyList), optyOldMap);
			//Req 4879
			OpptTrigHelper.resetG3BypassFlag(new map<Id,Opportunity>(optyList),optyOldMap);
			OpptTrigHelper.rollBackFieldsApprovers(new map<Id, Opportunity>(optyList), optyOldMap);
			//Sales process R-8 req#5003
			OpptTrigHelper.opportunityTypeChangeRestriction(optyList, optyOldMap);
			//G2 not 100% bypass
			OpptTrigHelper.updateMultiBG(optyList);
			//ft-128 - Set Account Role
			OpptTrigHelper.setAccRole(optyList, optyOldMap);
			//ft-299
			OpptTrigHelper.updateG2BypassFlag(optyList, optyOldMap);
			//Populate Phase Status Comment
			OpptTrigHelper.validatePhaseStatusComment(optyList);
			OpptTrigHelper.validateAccountChange(optyList, optyOldMap);
			//Sales Process: 2381
			//ft-75: check if user can edit the pre oppty
			//OpptTrigHelper.checkPreOppEditAccess(optyList);

			//Sales Process: 2381
			//OpptTrigHelper.opptyPtaSignedOfferProductOnlyNotSame(new Map<Id, Opportunity>());
			// checking the old and new sales outcome values
			system.debug('OpptyList100'+optyList);
			for(Opportunity Oppupdate:optyList)
			{
	system.debug('inloop');
	system.debug('current value------>>>>'+Oppupdate.StageName);
	system.debug('oldMap value------>>>>'+optyOldMap.get(Oppupdate.ID).StageName);
	if((!Oppupdate.StageName.equalsignorecase(optyOldMap.get(Oppupdate.ID).StageName) && !Oppupdate.StageName.equalsignorecase(GlobalConstants.IN_EXECUTION) && !Oppupdate.StageName.equalsignorecase(GlobalConstants.COMPLETED_OPPTY) )){
		system.debug('Inif');
		decisionlist.add(Oppupdate);
	}
			}

			//calll the decision period update methods

			if(decisionlist.size()>0){
	system.debug('Decisionlist'+decisionlist);
	OpptTrigHelper.DecisonUpdate(decisionlist);
			}

			OpptTrigHelper.validateSubstituteOptyWithSameUpsellDeal(optyList, optyOldMap);

			if(flagUpsellChange)
			{
	OpptTrigHelper.upsellChangeAccepted(optyList, optyOldMap);
	flagUpsellChange = false;
			}

			if(flagCommittedVal)
			{
	OpptTrigHelper.committedUnweightedValue(optyList, optyOldMap);
	flagUpsellChange = false;
			}

			if(flagUpsellDeltaDiff)
			{
	OpptTrigHelper.upsellDeltaDifference(optyList, optyOldMap);
	flagUpsellChange = false;
			}

			//if(flagUpdateOffer)
			{
	OpptTrigHelper.UpdateOffer(optyList, optyOldMap);
	flagUpdateOffer = false;
			}
		}
		ITA_IFM_PAD.deactivateTrigger('NF_ApprovalRequestTrigger');

	}

	/*****************************
*Method Name: beforeInsert
*Description: This is handler method for before insert on opportunity
*Parameters: Opportunity List
*******************************/
	public void beforeInsert(List<Opportunity> optyList, Map<Id, Opportunity> opportunityNewMap)
	{
		OpptTrigHelper.validateOpportunityType(optyList);
		// ignore trigger execution for Data Loader profile users
		Id profileId=userinfo.getProfileId();
		List<Opportunity> currencyList =new List<Opportunity>();
		flag = false;
		String profileName=[Select Id, Name from Profile where Id=:profileId LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()].Name;
		ProfileNames__c pN = ProfileNames__c.getInstance(profileName);
		if(pN == Null){
			OpptTrigHelper.restrictOpptyCreationByOTMFromDiffrentTerritory(optyList);
		}
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES == false){
			OpportunityTriggerHelper_PreSales.updateRecordTypeWhenPreSaleTypeIsOtherThanRSRO(optyList);  // Pre-Sales:Sprint 6: Req#2171
			preSaleOptyList = OpportunityTriggerHelper_PreSales.getIsApplicableForPreSalesList(optyList);
			if(!preSaleOptyList.isEmpty()){
	//fetch at beginning the reference oppties if necessary for other methods
	Map<Id, Opportunity> refOppties = OpportunityTriggerHelper_PreSales.getReferenceOpptyFromPSRO(preSaleOptyList);
	OpportunityTriggerHelper_PreSales.populatePreSalesOpportunityNumber(preSaleOptyList, refOppties);
	OpportunityTriggerHelper_PreSales.setInitialSalesPhase(preSaleOptyList, refOppties); //PreSales:Sprint 6 and 7
	OpportunityTriggerHelper_PreSales.updateProbability(preSaleOptyList, null, refOppties); //Release 8 :Sales Process : req :5072
	OpportunityTriggerHelper_PreSales.populateParentCurrencyOnPreSales(preSaleOptyList, refOppties);
	OpportunityTriggerHelper_PreSales.convertionTotalCostsPreSales(preSaleOptyList, null);
	OpportunityTriggerHelper_PreSales.getNokiaPeriodName(preSaleOptyList, null, opportunityNewMap);
			}
			OpptTrigHelper.DecisonUpdate(optyList);
			if(!GlobalConstants.isSearchAndAddEndCustomer){
	Map<Id,Account> accountsInfo = OpptTrigHelper.getAccountsInfo(optyList, new map<Id, Opportunity>());
	OpptTrigHelper.populateDefaultLE(optyList, new map<Id, Opportunity>(), accountsInfo);
	OpptTrigHelper.populateEndCustomer(optyList, new map<Id, Opportunity>(), accountsInfo);
			}
			OpptTrigHelper.checkEnterpriseOpportunity(new Map<Id, Opportunity>() , optyList);
			OpptTrigHelper.UpdateUserinformation(optyList);

			for(Opportunity Opptylist:optyList)
			{
	if(Opptylist.OIF_Lines__c <= 0 && Opptylist.Amount<>0 && Opptylist.Amount<>Null )
		currencyList.add(Opptylist);
			}
			if(currencyList.size()>0)
	OpptTrigHelper.convertionrateupdate(currencyList);


		}
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			OpptTrigHelper.populatePhaseStatusOnInsert(optyList);
			//G2 not 100% bypass
			OpptTrigHelper.updateMultiBG(optyList);
			//ft-299
			OpptTrigHelper.setG2BypassFlag(optyList);
		}
		//Set Account Role
		OpptTrigHelper.setAccRole(optyList, null);
		//No need to by pass for dataLoader
		//Digital Sales: 166
		//CSWX_OpportunityTriggerHelper.assigningG3Approver(optyList);
	}

	/*****************************
*Method Name: afterInsert
*Description: This is handler method for after insert on opportunity
*Parameters: Opportunity List
*******************************/
	public void afterInsert(List<Opportunity> optyList)
	{
		// ignore trigger execution for Data Loader profile users
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES == false) { // to stop recursive trigger executionof opty
			OpptTrigHelper.FollowOpportunity(optyList);
			//Requirement 953
			if(!CSWXGlobalConstant.oifCheckStatus){
	CSWXGlobalConstant.oifCheckStatus = true;
			}
		}
		//Map<Id, Opportunity> opptymap = new Map<Id, Opportunity>();

		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			//Sales process Req:5468
			if(!flagForOwnerInsert)
			{
	OpptTrigHelper.insertOwnerInOpptyTeam(optyList);
	flagForOwnerInsert = true;
			}
			/*
for(Opportunity opptycheck:optyList){
opptymap.put(opptycheck.id, opptycheck);
}*/

			//ft-286
			OpptTrigHelper.createNokiaCompetitorRecord(optyList, null);

		}

		//   SF:0069801 > Prevent Oppty creation if user have wrong pricing manager and pricing manager lead in their default oppty team.
		//   Added by HCL Team

		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && optyList.size() >0){

			List<OpportunityTeamMember> oppTeamlst = new List<OpportunityTeamMember>();
			oppTeamlst= [Select id, OpportunityId, user.name, UserId, TeamMemberRole, Additional_Team_Role__c from OpportunityTeamMember where OpportunityId in:optyList];
			if(oppTeamlst.size()>0) OpptTrigHelper.oppTeamPrMValidation(oppTeamlst);

		}

	}

	/*
* @desc	This is handler method for after update on opportunity
* @param   opportunitiesNewMap: the map of opportunities which are approved or rejected
* @param   opportunitiesoldMap: the map of opportunities which are approved or rejected
*/
	/*****************************
*Method Name: afterUpdate
*Description: This is handler method for after Update on opportunity
*Parameters: map<Id, Opportunity> opportunitiesNewMap, map<Id, Opportunity> opportunitiesoldMap
*******************************/
	public void afterUpdate(map<Id, Opportunity> opportunitiesNewMap, map<Id, Opportunity> opportunitiesoldMap)
	{
		Map<Id, Opportunity> oldMap=new  Map<Id, Opportunity>();
		Map<Id, Opportunity> newMap=new  Map<Id, Opportunity>();
		Map<ID, Opportunity> taskOfferInfo=new Map<ID, Opportunity>();
		List<opportunity> lstoldOpp= new List<opportunity>();
		Map<Id, Opportunity> recallOpptyinfo= new Map<Id, Opportunity>();
		Set<id> opptyid = new Set<id>();
		Set<id> opptyallocationid = new Set<id>();
		Map<Id, Opportunity> stakeholderInfo= new Map<Id, Opportunity>();
		Map<ID, Opportunity> windeclarationInfo =new Map<ID, Opportunity>();
		oldMap=opportunitiesoldMap;
		newMap=opportunitiesNewMap;

		//FT-1553: for April 2020 BP
		//OpptTrigHelper.cloneContractRenewalOpportunity(opportunitiesoldMap, opportunitiesNewMap.values());

		If(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			//Req 5073
			if(flagForCompetitor == false){
	OpptTrigHelper.createCompetitorWhenOpportunityClosedNegatively(opportunitiesNewMap.values(), opportunitiesoldMap);
	flagForCompetitor = true;
			}
			//Req 5073 sales Process
			if(flagForComp == false){
	OpptTrigHelper.createUnknownCompetitorRecord(opportunitiesNewMap.values(), opportunitiesoldMap);
	flagForComp = true;
			}
			//Sales Process Req:5468
			if(!flagForOwnerUpdate)
			{
	OpptTrigHelper.updateOwnerInOpptyTeam(opportunitiesNewMap.values(), opportunitiesoldMap);
	OpptTrigHelper.insertOwnerInTeamOnReopening(opportunitiesNewMap.values(), opportunitiesoldMap);
	flagForOwnerUpdate = true;
			}
			if(GlobalConstants.DeleteOpenTaskFlag!=True){

	OpptTrigHelper.deleteOpenTasks(opportunitiesNewMap, opportunitiesoldMap);
			}
			// Req 4943
			OpptTrigHelper.updateUnweightedValueofOpptyGroup(opportunitiesNewMap, opportunitiesoldMap);
			OpptTrigHelper.updateProbabilityOfPSROAsSalesOptyAfterUpdate(opportunitiesNewMap, opportunitiesoldMap); //Sales Process : October Release : Req:5072
			//Req 4422
			OpptTrigHelper.populate_G4ApprovalCycleTimeOnOffer(opportunitiesNewMap, opportunitiesoldMap);
			OpptTrigHelper.checkG2G6Approval(opportunitiesNewMap, opportunitiesoldMap);
			//ft-286
			OpptTrigHelper.createNokiaCompetitorRecord(opportunitiesNewMap.values(), opportunitiesoldMap);
		}
		lstoldOpp= opportunitiesoldMap.values();
		System.debug('Helpr after update' +GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES );

		//modified for Ticket 00012822 : PSRO cancellation notif email fired when Account LE updated in "Reference Sales Opportunity"
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && (GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  == false || GlobalConstants.notifyByChatter == false))
		{
			preSaleOptyListWithReadOnly = OpportunityTriggerHelper_PreSales.getIsApplicableForPreSalesListWithReadOnly(opportunitiesNewMap.values());
			if(!preSaleOptyListWithReadOnly.isEmpty()){
	//modified for Ticket 00012822 : PSRO cancellation notif email fired when Account LE updated in "Reference Sales Opportunity"
	if((GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  == false || GlobalConstants.notifyByChatter == false) && !chatterNotified) {
		OpportunityTriggerHelper_PreSales.notifyOTMsAndApprovalContributorsWhenClosed(preSaleOptyListWithReadOnly, opportunitiesoldMap, opportunitiesNewMap);
		GlobalConstants.notifyByChatter = true;
		chatterNotified = true;
	}
	if(GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  == false) {
		OpportunityTriggerHelper_PreSales.notifyOTMsAndApprovalContributorsWhenReset(preSaleOptyListWithReadOnly, opportunitiesoldMap); // preSales > Sprint 10> Req: 3110
	}
			}
		}
		//This Method will execute only foe dataload profile
		If(UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			OpptTrigHelper.probabilityUpdateInline(opportunitiesNewMap, opportunitiesoldMap);
		}

		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)  &&  !Test.isRunningTest() ){

			for (Opportunity newopportunity:newMap.values()){
	if (newopportunity.Apttus_Approval__Approval_Status__c != null && newopportunity.Phase_Status__c != null &&
		newopportunity.Phase_Status__c != oldMap.get(newopportunity.Id).Phase_Status__c && newopportunity.Apttus_Approval__Approval_Status__c != oldMap.get(newopportunity.Id).Apttus_Approval__Approval_Status__c &&
		newopportunity.Apttus_Approval__Approval_Status__c.contains(GlobalConstants.APPROVED) && oldMap.get(newopportunity.Id).StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE) &&
		newopportunity.StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY)   ){
			windeclarationInfo.put(newopportunity.Id, newopportunity);
		}
			}
			if(!windeclarationInfo.isEmpty())
	NF_OpportunityTriggerHelper.WindeclarationNotification(windeclarationInfo);

		}

		// ignore trigger execution for Data Loader profile users....
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)  && ITA_IFM_PAD.canRun('afterUpdateOPP') && !Test.isRunningTest() )
		{
			Set<ID> opportunitiesMap = new Set<ID>();

			//Update the Probability
			OpptTrigHelper.probabilityUpdateInline(opportunitiesNewMap, opportunitiesoldMap);

			for (Opportunity newopportunity:newMap.values()){

	Id prsoReadRecordTypeId=System.Label.PRSO_Read_RecordTypeId;
	Id prsoRecordTypeId=System.Label.PRSO_RecordTypeId;

	if(( oldMap.get(newopportunity.id).RecordTypeId == prsoReadRecordTypeId || oldMap.get(newopportunity.id).RecordTypeId == prsoRecordTypeId ||
		(oldMap.get(newopportunity.ID).Phase_Status__c<>NUll && !oldMap.get(newopportunity.ID).Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION)
		 && !oldMap.get(newopportunity.ID).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G3_APPROVAL) && !oldMap.get(newopportunity.ID).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G4_APPROVAL) && !oldMap.get(newopportunity.ID).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G5_APPROVAL)  && !oldMap.get(newopportunity.ID).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G6_APPROVAL) ) )
	   && newopportunity.Apttus_Approval__Approval_Status__c != null && newopportunity.Apttus_Approval__Approval_Status__c!=oldMap.get(newopportunity.id).Apttus_Approval__Approval_Status__c &&
	   (newopportunity.Apttus_Approval__Approval_Status__c.contains(GlobalConstants.APPROVED) || newopportunity.Apttus_Approval__Approval_Status__c.contains(GlobalConstants.REJECTED) ) && GlobalConstants.OPPORTUNITY_APPROVAL==false){
		opportunitiesMap.add(newopportunity.Id);
	   }
			}
			if(opportunitiesMap.size()>0 && (!System.isBatch() && !System.isFuture()))
	NF_OpportunityTriggerHelper.NotifyOpportunityRelatedUsers(opportunitiesMap);

			//Forecasting Requirement
			for (Opportunity newopportunity:newMap.values())
			{
	String oldAccNbr = oldMap.get(newopportunity.Id).Account_Information__c.split(';')[0];
	String newAccNbr = newopportunity.Account_Information__c.split(';')[0];

	//Checking if Account__c was changed to another
	if(newopportunity.AccountId != oldMap.get(newopportunity.Id).AccountId)
	{
		//Checking if new account is not listed to bypass allocation creation
		if(CRM_Account_to_Bypass_Allocation__c.getValues(newAccNbr) == null && CRM_Account_to_Bypass_Allocation__c.getValues(oldAccNbr) != null
		&& GlobalConstants.FNOK.equalsignorecase(newopportunity.Contract_Signing_Entity__c))
		{
			System.debug('add allocation to create for ' + newopportunity.id);
			opptyallocationid.add(newopportunity.Id);
		}
		//Checking if old account was not listed to bypass allocation creation
		if(CRM_Account_to_Bypass_Allocation__c.getValues(oldAccNbr) == null && CRM_Account_to_Bypass_Allocation__c.getValues(newAccNbr) != null
		&& GlobalConstants.FNOK.equalsignorecase(oldMap.get(newopportunity.Id).Contract_Signing_Entity__c))//Checking if old account was not listed to bypass allocation creation
		{
			System.debug('add allocation to delete from ' + oldMap.get(newopportunity.Id).Id);
			opptyid.add(newopportunity.Id);
		}
	}
	else
	{
		//Checking if Contract_Signing_Entity__c was changed to FALU (delete allocation)
		if(newopportunity.Contract_Signing_Entity__c!=null && !newopportunity.Contract_Signing_Entity__c.equalsignorecase(oldMap.get(newopportunity.Id).Contract_Signing_Entity__c) && newopportunity.Contract_Signing_Entity__c.equalsignorecase(GlobalConstants.FALU))
		{
			opptyid.add(newopportunity.id);
		}//Checking if Contract_Signing_Entity__c was changed to FNOK (create allocation)
		if(newopportunity.Contract_Signing_Entity__c!=null && !newopportunity.Contract_Signing_Entity__c.equalsignorecase(oldMap.get(newopportunity.Id).Contract_Signing_Entity__c) && newopportunity.Contract_Signing_Entity__c.equalsignorecase(GlobalConstants.FNOK)
		&& CRM_Account_to_Bypass_Allocation__c.getValues(newAccNbr) == null)
		{
			opptyallocationid.add(newopportunity.id);
		}
	}
			}

			//Allocation line deletion
			if(!opptyid.isEmpty())
			{
	OpptTrigHelper.DeleteAllocationLine(opptyid);
			}
			//auto creation of Allocation Lines
			if(!opptyallocationid.isEmpty())
			{
	OrderIntakeAllocationCreation.OIFAlloctionCreate(opptyallocationid);
			}
			ITA_IFM_PAD.deactivateTrigger('afterUpdateOPP');
		}
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) &&!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id) && GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  == false)
		{
			String opportunityFinalStage = System.Label.Opportunity_SalesPhase_FinalStage;
			map<Id, Opportunity> filteredOpportunitiesNewMap = new map<Id, Opportunity>();
			map<Id, Opportunity> filteredOpportunitiesoldMap = new map<Id, Opportunity>();
			//map<Id, String> opptyIdToOfferLOAMap = new map<Id, String>();
			//List<Offer__c> offerList = new  List<Offer__c>();
			Set<Id> parentOppIdSet = new Set<Id>();
			//offerList  = [SELECT ActiveOffer__c, Id, LoA_Approval_Level__c, Opportunity__c FROM Offer__c WHERE ActiveOffer__c =: TRUE AND Opportunity__c IN: opportunitiesNewMap.keySet()];
			/*
			for(Offer__c offerInst : offerList){
	opptyIdToOfferLOAMap.put(offerInst.Opportunity__c, offerInst.LoA_Approval_Level__c);
			}*/
			for(Opportunity oppRec : opportunitiesNewMap.values())
			{
	if(oppRec.Phase_Status__c!=null && oppRec.StageName != null){
		if(!(oppRec.Phase_Status__c.equals(opportunitiesoldMap.get(oppRec.Id).Phase_Status__c)) || (oppRec.StageName.equals(opportunityFinalStage) && !oppRec.StageName.equals(opportunitiesoldMap.get(oppRec.Id).StageName)))
		{
			filteredOpportunitiesNewMap.put(oppRec.id, opportunitiesNewMap.get(oppRec.Id));
			filteredOpportunitiesoldMap.put(oppRec.id, opportunitiesoldMap.get(oppRec.Id));
		}

		if(oppRec.LOA_Level__c != 'E' && oppRec.Phase_Status__c.equals('Pending Win/Loss Declaration') && oppRec.StageName.equals('Win the Case (Negotiate)') && !oppRec.Phase_Status__c.equals(opportunitiesoldMap.get(oppRec.Id).Phase_Status__c)){
			parentOppIdSet.add(oppRec.Id);
		}
	}
			}

			if(!parentOppIdSet.isEmpty() && UpsellOpportunityUtility.firstRun)
			{
	UpsellOpportunityUtility.toCreateUpsellOpportunity(parentOppIdSet);
	UpsellOpportunityUtility.firstRun = false;
			}
		}
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  == false)
		{
			if(!GlobalConstants.OPPORTUNITYTRIGGER_HELPER_UPDATE_G4_G5){
	OpportunityTriggerHelper.updateOffersOnG4ApprovalDateIsUpdated(opportunitiesNewMap, opportunitiesOldMap);
			}

			saleOptyMap = OpptTrigHelper.getIsApplicableForSalesNewMap(opportunitiesNewMap);

			if(!saleOptyMap.isEmpty()){
	//system.debug('in if loop>>>>');
		//		OpptTrigHelper.validateRefOpptyAndPTASigned(saleOptyMap, opportunitiesoldMap); //sales process
	OpportunityTriggerHelper_preSales.populateParentCurrency(saleOptyMap.values(), opportunitiesoldMap);
			}

			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
	OpptTrigHelper.chatterPostToAccountManager(opportunitiesNewMap, opportunitiesoldMap);
			}
			OpptTrigHelper.offerPriceChange(opportunitiesNewMap.values(), opportunitiesoldMap);

			for(Opportunity opty : opportunitiesNewMap.values()){
	preSalesOptyFilter.add(opty);
			}

			//Requirement #2558: Sales Process: Bypass only for data loader profile
			if(batchFlag == true){
	batchFlag = false;
			}

			// Opportunity Close Notification
			// Sales process Req-5077
			if(!GlobalConstants.OPPORTUNITY_CLOSE_CHECK && !flagForChatter) {
	OpptTrigHelper.OpportunityClosure(opportunitiesNewMap, opportunitiesoldMap);
			}

			// Opportunity Recall Notification
			for(Opportunity Opptydata:newMap.values())
			{

	if(Opptydata.RecordTypeId!=PSR_EditRecordTypeID&&Opptydata.RecordTypeId!=PSR_ReadOnlyRecordTypeID && Opptydata.Apttus_Approval__Approval_Status__c<>Null && oldMap.get(Opptydata.id).Apttus_Approval__Approval_Status__c<>Null && Opptydata.Apttus_Approval__Approval_Status__c<>oldMap.get(Opptydata.id).Apttus_Approval__Approval_Status__c && Opptydata.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.CANCEL)
	   && !GlobalConstants.SUBMITTED_FOR_G3_APPROVAL.equalsIgnoreCase(oldMap.get(Opptydata.id).Phase_Status__c) && !GlobalConstants.SUBMITTED_FOR_G4_APPROVAL.equalsIgnoreCase(oldMap.get(Opptydata.id).Phase_Status__c) && !GlobalConstants.SUBMITTED_FOR_G5_APPROVAL.equalsIgnoreCase(oldMap.get(Opptydata.id).Phase_Status__c) && !GlobalConstants.SUBMITTED_FOR_G6_APPROVAL.equalsIgnoreCase(oldMap.get(Opptydata.id).Phase_Status__c) )
		recallOpptyinfo.put(Opptydata.ID, oldMap.get(Opptydata.ID));

	If(Opptydata.Apttus_Approval__Approval_Status__c<>Null && oldMap.get(Opptydata.id).Apttus_Approval__Approval_Status__c<>Null && Opptydata.Apttus_Approval__Approval_Status__c<>oldMap.get(Opptydata.id).Apttus_Approval__Approval_Status__c && Opptydata.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.PENDING_APPROVAL) && Opptydata.StageName<>Null && Opptydata.Phase_Status__c<>NUll
	   && !GlobalConstants.PENDING_WIN_LOSS_DECLARATION.equalsIgnoreCase(oldMap.get(Opptydata.id).Phase_Status__c) && !GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL.equalsIgnoreCase(oldMap.get(Opptydata.id).Phase_Status__c) && !GlobalConstants.SUBMITTED_FOR_G3_APPROVAL.equalsIgnoreCase(Opptydata.Phase_Status__c) && !GlobalConstants.SUBMITTED_FOR_G4_APPROVAL.equalsIgnoreCase(Opptydata.Phase_Status__c) && !GlobalConstants.SUBMITTED_FOR_G5_APPROVAL.equalsIgnoreCase(Opptydata.Phase_Status__c) && !GlobalConstants.SUBMITTED_FOR_G6_APPROVAL.equalsIgnoreCase(Opptydata.Phase_Status__c) )
		stakeholderInfo.put(Opptydata.ID, Opptydata);

	IF( Opptydata.Apttus_Approval__Approval_Status__c<>Null && oldMap.get(Opptydata.id).Apttus_Approval__Approval_Status__c<>Null && Opptydata.Apttus_Approval__Approval_Status__c<>oldMap.get(Opptydata.id).Apttus_Approval__Approval_Status__c
	   && Opptydata.Apttus_Approval__Approval_Status__c.contains(GlobalConstants.APPROVED) && Opptydata.StageName<>Null && Opptydata.Phase_Status__c<>Null &&  (Opptydata.Phase_Status__c.equalsignorecase(GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL)
													&& Opptydata.StageName.equalsignorecase(GlobalConstants.WIN_THE_CASE_NEGOTIATE)) )
		taskOfferInfo.put(Opptydata.ID, Opptydata);
			}

			if(!recallOpptyinfo.isEmpty() && !GlobalConstants.OPPORTUNITY_RECALL_CHECK)
	NF_OpportunityTriggerHelper.RecallNotification(recallOpptyinfo);
			IF(!stakeholderInfo.isEmpty() && !GlobalConstants.OPPORTUNITY_CHATTER_CHECK)
	NF_OpportunityTriggerHelper.ChatterPostToStakeHolders(stakeholderInfo, false);

			If(!taskOfferInfo.isEmpty())
	NF_OpportunityTriggerHelper.CloseTheG4SubmissionTask(taskOfferInfo);

			Set<ID> opptyMap =new Set<ID>();
			//Massupdate on OIF lines
			for(Opportunity Opptydata:newMap.values())
			{
	if(!system.isfuture() && Opptydata.Sales_Outcome__c<>NUll && (!Opptydata.Sales_Outcome__c.equalsignorecase('') &&!Opptydata.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) && !Opptydata.Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED)))
		opptyMap.add(Opptydata.ID);
			}

			IF(!opptyMap.isEmpty() && !System.isFuture() && !System.isBatch())
	OpportunityTriggerHelper.MassupdateonOIFLines(opptyMap);
		}

		map<Id, Opportunity> maptoUpdate = new map<Id, Opportunity>();
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			//common method for NF_opportunitytriggerhelper
			NF_OpportunityTriggerHelper.Common_method_calls(newMap, oldMap);
			//IWA_Req.5005_Upsell_Approver_Notification
			NF_UpsellNotificationHelper.notifyUpsellApprovers(opportunitiesNewMap, opportunitiesOldMap);

			for(Opportunity OpptyCheck:newMap.values()){
	if(OpptyCheck.G4_Planned_Date__c != opportunitiesOldMap.get(OpptyCheck.id).G4_Planned_Date__c){

		maptoUpdate.put(OpptyCheck.id, OpptyCheck);

	}
			}
			if(maptoUpdate.size() > 0){
	OpptTrigHelper.updateCustomerOfferDueDate(opportunitiesNewMap);
			}
			// SF:0069801 > Prevent to add wrong PRM/ PRM lead OTM on opportunity whenever owner gets changed
			Set<Id> ownerChangedOppties = new Set<Id>();
			for(Opportunity oppty : opportunitiesNewMap.values()){
	if(oppty.OwnerId != opportunitiesOldMap.get(oppty.Id).ownerid){
		ownerChangedOppties.add(oppty.Id);
	}
			}
			if(ownerChangedOppties.size()>0){
	List<OpportunityTeamMember> oppTeamlst = [Select id, OpportunityId, user.name, UserId, TeamMemberRole, Additional_Team_Role__c from OpportunityTeamMember Where OpportunityId IN :ownerChangedOppties];
	OpptTrigHelper.oppTeamPrMValidation(oppTeamlst);
			}
		}


		//DSI-1857: CLM R0 #1 - update fields of corresponding Agreement records after Oppty update
		AgreementTriggerHelper.updateAgreementFieldsOnOpportunityChange(opportunitiesOldMap, opportunitiesNewMap);
	}

	/*****************************
*Method Name: afterDelete
*Description: This is handler method for after Delete on opportunity
*Parameters: map<Id, Opportunity> opportunitiesNewMap
*******************************/
	public void afterDelete(Map<Id, Opportunity> opptyoldMap){
		//Requirement 953
		//IWA Test Class are failing so adding this condition
		/*		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)&&!test.isrunningtest())
OpptTrigHelper.compareUnweightedValueOnDeal(opptyoldMap, NUll, true); //SalesProcess : Sprint 8 : Req#3303*/
	}

	@InvocableMethod(label = 'changeFlagOpptyTeamUpdate')
	public static void changeFlagOpptyTeamUpdate (){
		flagForOwnerUpdate = false;
	}
}