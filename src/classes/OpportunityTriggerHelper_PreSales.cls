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
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.PRESALESRISKOPPORTUNITY_READONLY).getRecordTypeId();
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.PRESALESRISKOPPORTUNITY).getRecordTypeId();

	public static Set<Opportunity> Opprec ;
	public static Set<String> Oppcurrency ;
	public static Map<String, Decimal> datedrate ;
	/***************************
	* Requirement Details:  Pre-Sales:Sprint 6: Req#2316 + Req#5539
	*Method Name: CovertionUpdatePreSales
	*Description: Updating Total Cost and Sales Value To EUR
	*Parameters: Opportunity opptyList1
	***********************/
	public static void convertionUpdatePreSales(List<Opportunity>opptyList, Map<Id,Opportunity>optyOldMap){
		System.debug('in convertionUpdatePreSales');
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = false;
		try{
			List<Opportunity> updatedOpportunityList = new List<Opportunity>();
			Opprec = new Set<Opportunity>();
			Oppcurrency = new Set<String>();
			datedrate = new Map<String, Decimal>();
			Date todayDate = Date.Today();
			//GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true; // to stop recursion of trigger
			for (Opportunity newrec: opptyList) {
	Oppcurrency.add(newrec.CurrencyIsoCode);
			}
			System.debug('in convertionUpdatePreSales>>'+Oppcurrency);

			/* for (Opportunity opportunity: opptyList){
			if(optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_AA__c != opportunity.PSR_Cost_Business_Group_AA__c ||
			optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_FN__c != opportunity.PSR_Cost_Business_Group_FN__c ||
			optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_GS__c != opportunity.PSR_Cost_Business_Group_GS__c ||
			optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_MN__c != opportunity.PSR_Cost_Business_Group_MN__c ||
			optyOldMap.get(opportunity.Id).PSR_Cost_Business_Unit_ION_Optics__c!= opportunity.PSR_Cost_Business_Unit_ION_Optics__c ||
			optyOldMap.get(opportunity.Id).PSR_Cost_Business_Unit_ION_IPR__c!= opportunity.PSR_Cost_Business_Unit_ION_IPR__c||
			optyOldMap.get(opportunity.Id).PSR_Cost_BU_NE_DAaaS__c!= opportunity.PSR_Cost_BU_NE_DAaaS__c ||
			optyOldMap.get(opportunity.Id).PSR_Cost_BU_NE_EOP__c != opportunity.PSR_Cost_BU_NE_EOP__c ||
			optyOldMap.get(opportunity.Id).PSR_Cost_BU_NE_IoT__c != opportunity.PSR_Cost_BU_NE_IoT__c ){
			updatedOpportunityList.add(opportunity);
			}
			}
			*/
			System.debug('in convertionUpdatePreSales>>updatedOpportunityList'+updatedOpportunityList);

			if(!opptyList.isEmpty()){
	for (Dated_Exchange_Rates__c ratecollect:  [select Id, CurrencyIsoCode, Exchange_Rate__c, Start_Date__c
						from Dated_Exchange_Rates__c where CurrencyIsoCode =: Oppcurrency
						Order By Start_Date__c ASC LIMIT: Limits.getLimitQueryRows()]){
				datedrate.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
						}

	for(Opportunity opportunity: opptyList){
		Decimal sumOfCostBUIONs =  (returnValueOfField( opportunity.PSR_Cost_Business_Unit_ION_Optics__c) +
			returnValueOfField (opportunity.PSR_Cost_Business_Unit_ION_IPR__c) +
			returnValueOfField (opportunity.PSR_Cost_BU_ION_IPR_DNI__c) +
			returnValueOfField (opportunity.PSR_Cost_BU_ION_IPR_MPC__c) +
			returnValueOfField (opportunity.PSR_Cost_BU_ION_IPR_Nuage__c) +
			returnValueOfField (opportunity.PSR_Cost_BU_ION_IPR_Services__c) +
			returnValueOfField (opportunity.PSR_Cost_BU_ION_Optics_Services__c));

		Decimal sumOfCostBUs = 0;
		sumOfCostBUs = returnValueOfField( opportunity.PSR_Cost_Business_Group_AA__c) +
			returnValueOfField( opportunity.PSR_Cost_Business_Group_FN__c) +
			returnValueOfField( opportunity.PSR_Cost_Business_Group_GS__c)  +
			returnValueOfField( opportunity.PSR_Cost_Business_Group_MN__c)  +
			sumOfCostBUIONs  +
			returnValueOfField( opportunity.PSR_Cost_BU_NE_IoT__c) +
			returnValueOfField( opportunity.PSR_Cost_BU_NE_EOP__c) +
			returnValueOfField( opportunity.PSR_Cost_BU_NE_DAaaS__c);

		System.debug('sumOfCostBUIONs>>'+sumOfCostBUIONs+'>>>'+sumOfCostBUs);

		if(opportunity.CurrencyIsoCode<>GlobalConstants.EUR){
		opportunity.PSR_Total_Cost_in_Euro__c =(sumOfCostBUs/ datedrate.get(opportunity.CurrencyIsoCode));
		System.debug('The DateRate >>>>>>>>>>'+ datedrate.get('INR'));
			opportunity.PSR_Total_Sales_Value_in_Euro__c = (opportunity.PSR_Total_Sales_Value_in_Local_Currency__c/ datedrate.get(opportunity.CurrencyIsoCode)).setscale(2);
			system.debug('daterec.PSR_Reference_Opportunity__r.CurrencyIsoCode****>>>>'+opportunity.PSR_Reference_Opportunity__r.CurrencyIsoCode);
		}else {
			opportunity.PSR_Total_Cost_in_Euro__c =  sumOfCostBUs;
			opportunity.PSR_Total_Sales_Value_in_Euro__c = opportunity.PSR_Total_Sales_Value_in_Local_Currency__c;
		}


		system.debug('opportunity.PSR_Total_Cost_in_Euro__c****>>>>'+opportunity.PSR_Total_Cost_in_Euro__c);
		system.debug('opportunity.PSR_Total_Sales_Value_in_Euro__c****>>>>'+opportunity.PSR_Total_Sales_Value_in_Euro__c);
	}			 }
		}catch(Exception ex){
			System.debug('eXECPTION>>>>'+ ex);
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.CONVERTIONUPDATEPRESALES);
		}
	}

	public static Decimal returnValueOfField(Decimal fieldValue){
		Return fieldValue == Null ? 0 : fieldValue;
	}

	/*****************************
	*Requirement Details:  Pre-Sales:Sprint 6: Req#2171
	*Method Name: updaterecordTypeWhenPreSaleTypeIsOtherThanRSRO
	*Description: This method will update recordtype according to Pre_Sales_Opportunity_Type__c to PreSales Risk Opp Edit Record Type when an Oppty is cloned as well
	*Parameters: Opportunity List, Opportunity Map
	*Test coverage from: OpportunityTriggerHelperTest
	**********************************/
	public static void updaterecordTypeWhenPreSaleTypeIsOtherThanRSRO(List<Opportunity>opportunityList, Map<Id, Opportunity>optyOldMap) {
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
		} Catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.UPDATERECORDTYPEWHENPRESALETYPEISOTHERTHANRSRO);
		}
	}

	public static Set<Id> parentOpprecIdsSet ;
	public static Map<Id,Opportunity> opportunityIdAndOpportunityMap;
		/***************************
	* Requirement Details:  Pre-Sales:Sprint 6: Req#2316
	*Method Name: populateParentCurrencyOnPreSales
	*Description: Fetching parent opportunities currency
	*Parameters: Opportunity opptyList1
	***********************/
	public static void populateParentCurrencyOnPreSales(List<Opportunity>opptyList , Map<Id, Opportunity>optyOldMap){
		try{
			parentOpprecIdsSet = new Set<Id>();
			opportunityIdAndOpportunityMap = new Map<Id,Opportunity>();
			//GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true;
			//get Parent Opportunity Id Set
			for (Opportunity newrec: opptyList) {
	parentOpprecIdsSet.add(newrec.PSR_Reference_Opportunity__c);
	System.debug('The PSR_reference_Opportunity>>>>>>>'+ newrec.PSR_Reference_Opportunity__r.name);
			}
			system.debug('In populateParentCurrencyOnPreSales Method >>>> parentOpprecIdsSet>>>'+parentOpprecIdsSet);
			//query on opportunity where Ids in parentoptyIdSet and create a Map of parentOptyId and opty
			for(Opportunity opportunity : [ select Id,currencyISOCode,PSR_Reference_Opportunity__c,AccountId
			 from Opportunity
			 where Id in: parentOpprecIdsSet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]
	  ){
	   opportunityIdAndOpportunityMap.put(opportunity.Id,opportunity);
	  }
			system.debug('In populateParentCurrencyOnPreSales Method >>>> opportunityIdAndOpportunityMap>>>'+opportunityIdAndOpportunityMap.size());

			for (Opportunity opportunity: opptyList){

	if(opportunityIdAndOpportunityMap.containsKey(opportunity.PSR_Reference_Opportunity__c)){
		opportunity.currencyISOCode = opportunityIdAndOpportunityMap.get(opportunity.PSR_Reference_Opportunity__c).currencyISOCode;
		system.debug('In populateParentCurrencyOnPreSales Method >>>> opportunityIdAndOpportunityMap>>> in if'+opportunityIdAndOpportunityMap.get(opportunity.PSR_Reference_Opportunity__c).AccountId);
	}

			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.POPULATEPARENTCURRENCYONPRESALES);

		}
	}

	/***************************
	* Requirement Details:  Pre-Sales:Sprint 6: Req#2316
	*Method Name: CovertionUpdatePreSales
	*Description: Sales Phase set to Preparation on creation of PSRO
	*Parameters: Opportunity opptyList1
	***********************/
	public static void populateParentAccountOnPreSalesAndSetDefaultStage(List<Opportunity>opptyList , Map<Id, Opportunity>optyOldMap){
		try{
			parentOpprecIdsSet = new Set<Id>();
			opportunityIdAndOpportunityMap = new Map<Id,Opportunity>();
			//GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true;
			//get Parent Opportunity Id Set
			for (Opportunity newrec: opptyList) {
	parentOpprecIdsSet.add(newrec.PSR_Reference_Opportunity__c);
			}
			system.debug('In populateParentCurrencyOnPreSales Method >>>> parentOpprecIdsSet>>>'+parentOpprecIdsSet);
			//query on opportunity where Ids in parentoptyIdSet and create a Map of parentOptyId and opty
			for(Opportunity opportunity : [ select Id,currencyISOCode,PSR_Reference_Opportunity__c,AccountId
			 from Opportunity
			 where Id in: parentOpprecIdsSet  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ]){
			  opportunityIdAndOpportunityMap.put(opportunity.Id,opportunity );
			 }
			system.debug('In populateParentCurrencyOnPreSales Method >>>> opportunityIdAndOpportunityMap>>>'+opportunityIdAndOpportunityMap.size());

			for (Opportunity opportunity: opptyList){

	if(opportunityIdAndOpportunityMap.containsKey(opportunity.PSR_Reference_Opportunity__c)){
		//opportunity.AccountId = opportunityIdAndOpportunityMap.get(opportunity.PSR_Reference_Opportunity__c).AccountId;
		if(optyOldMap.isEmpty()){
			opportunity.StageName = GlobalConstants.PREPARATION;
		}
		system.debug('In populateParentCurrencyOnPreSales Method >>>> opportunityIdAndOpportunityMap>>> in if'+opportunity.AccountId);
	}

			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.populateParentAccountOnPreSalesAndSetDefaultStage );

		}
	}

	public static List<Opportunity> updateNokiaPeriodOfOpportunityList;
	public static Map<Id,Date> opportunityIdAndCloseDateMap ;
	public static Map<Id,String> opportunityIdAndNokiaPeriod ;
	public static Map<Id, Nokia_Financial_Calendar__c> IdAndNokiaFinancialCalenderMap ;

	/***************
	*Requirement Details:  Pre-Sales:Sprint 6: Req#2337
	*Method Name: getNokiaPeriodName
	*Description: Fetching of the nokia Period from the Nokia_Financial_Calendar__c object
	*Parameters: Opportunity opptyList, Map optyOldMap, Nokia_Financial_Calendar__c nokiaList
	**************/
	public static void getNokiaPeriodName(List<Opportunity> opptyList, Map<Id, Opportunity> opportunityOldMap){
		updateNokiaPeriodOfOpportunityList = new List<Opportunity>();
		opportunityIdAndCloseDateMap = new Map<Id,Date>();
		opportunityIdAndNokiaPeriod = new Map<Id,String>();

		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true; // to stop recursion of trigger
		try{
			system.debug('opptyList>>>>'+opptyList);

			for(Opportunity opty: opptyList){
	opportunityIdAndCloseDateMap.put(opty.Id, opty.CloseDate);
			}
			system.debug('opportunityIdAndCloseDateMap>>>>'+opportunityIdAndCloseDateMap);
			if(!opportunityIdAndCloseDateMap.isEmpty()){
	IdAndNokiaFinancialCalenderMap = new Map<Id, Nokia_Financial_Calendar__c>([SELECT Name,Start_Date__c,End_Date__c  From Nokia_Financial_Calendar__c
						 Where Start_Date__c <=: opportunityIdAndCloseDateMap.values() and
						 End_Date__c >=: opportunityIdAndCloseDateMap.values() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
			}

			for(Id opportunityId : opportunityIdAndCloseDateMap.keySet() ){
	system.debug('opportunityId >>>>'+opportunityId );

	for(Id nokiaFinalcialCalendarId : IdAndNokiaFinancialCalenderMap.keySet()){
		system.debug('nokiaFinalcialCalendarId >>>>'+nokiaFinalcialCalendarId );
		system.debug('opportunityIdAndCloseDateMap.get(opportunityId)>>>>'+opportunityIdAndCloseDateMap.get(opportunityId));
		system.debug('IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).Start_Date__c >>>>'+IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).Start_Date__c);
		system.debug('IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).End_Date__c>>>>'+IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).End_Date__c);
		if(opportunityIdAndCloseDateMap.get(opportunityId) >= IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).Start_Date__c &&
		opportunityIdAndCloseDateMap.get(opportunityId) <= IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).End_Date__c){
		 opportunityIdAndNokiaPeriod.put(opportunityId,IdAndNokiaFinancialCalenderMap.get(nokiaFinalcialCalendarId).Name);
		}
	}
			}
			system.debug('opportunityIdAndNokiaPeriod>>>>'+opportunityIdAndNokiaPeriod);
			for(Opportunity opp : [select Id,PSR_Nokia_Period__c,RecordTypeId from Opportunity where Id in: opportunityIdAndNokiaPeriod.keySet()  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){

	system.debug('In populateParentCurrencyOnPreSales Method >>>> opportunityIdAndOpportunityMap>>> in if');
	if(opportunityIdAndNokiaPeriod.containsKey(opp.Id)){
		opp.PSR_Nokia_Period__c= opportunityIdAndNokiaPeriod.get(opp.Id);
		updateNokiaPeriodOfOpportunityList.add(opp);
	}

			}
			system.debug('updateNokiaPeriodOfOpportunityList>>>>'+updateNokiaPeriodOfOpportunityList);
			if(!updateNokiaPeriodOfOpportunityList.isEmpty()){
	Database.SaveResult[] savedResults = Database.update(updateNokiaPeriodOfOpportunityList, false);
	Boolean someFailure = false;
	// add exception into exception if there is any in database.saveresult.
	ExceptionHandler.generateExceptionRecordFromSaveResult(savedResults, GlobalConstants.GETNOKIAPERIODNAME, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES);
	system.debug('opportunityIdAndNokiaPeriod>>>>'+updateNokiaPeriodOfOpportunityList);
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.GETNOKIAPERIODNAME );
		}
	}


	public static Map<Id, List<Id>> parentoptyToChildrenopty ;
	public static Map<Id, String> parentOptyAndparentOpptyNumber ;
	public static Map<Id, String> chieldOptyAndLast3Number ;
	public static Map<Id, String> parentOptyAndLast3Number ;
	public static List<Opportunity> opportunityToUpdate ;
	public static List<Id> listChieldOpptyIds ;
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
	*Parameters: List<Opportunity> opptyList
	**************/
	public static void populatePreSalesOpportunityNumber(List<Opportunity> opptyList){
		parentoptyToChildrenopty = new Map<Id, List<Id>>();
		parentOptyAndparentOpptyNumber = new Map<Id, String>();
		chieldOptyAndLast3Number = new Map<Id, String>();
		parentOptyAndLast3Number = new Map<Id, String>();
		List<Opportunity> opportunityToUpdate = new List<Opportunity>();
		system.debug('In populatePreSalesOpportunityNumber>>>>>>>>>>>>>>>>>');
		String optyNumberFormatAsPerRecordType;
		try{
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true; // to stop recursive trigger executionof opty
			for(Opportunity opty:[select Id,name,PSR_Reference_Opportunity__c,Opportunity_ID__c,RecordType.Developername, PSR_Pre_Sales_Risk_Opportunity_Type__c
		  from opportunity where Id IN: opptyList LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){

			  if(parentoptyToChildrenopty.containskey(opty.PSR_Reference_Opportunity__c)){
			listChieldOpptyIds = new List<Id>();
			listChieldOpptyIds = parentoptyToChildrenopty.get(opty.PSR_Reference_Opportunity__c);
			listChieldOpptyIds.add(opty.Id);
			parentoptyToChildrenopty.put(opty.PSR_Reference_Opportunity__c, listChieldOpptyIds);
			system.debug('In if populatePreSalesOpportunityNumber>>>>>>>>>>>>>>>>>listChieldOpptyIds >>'+listChieldOpptyIds );
			  }
			  else{
			listChieldOpptyIds = new List<Id>();
			listChieldOpptyIds.add(opty.Id);
			parentoptyToChildrenopty.put(opty.PSR_Reference_Opportunity__c, listChieldOpptyIds);
			system.debug('In else populatePreSalesOpportunityNumber>>>>>>>>>>>>>>>>>listChieldOpptyIds >>'+listChieldOpptyIds );
			  }
		  }
			system.debug('In populatePreSalesOpportunityNumber>>>>>>>>>>>>>>>>>parentoptyToChildrenopty>>'+parentoptyToChildrenopty);
			String last3Digit = Globalconstants.ONE;
			if(!parentoptyToChildrenopty.isEmpty()){
	for (Opportunity parentOpp : [SELECT Id, Opportunity_Id__c FROM Opportunity WHERE Id IN : parentoptyToChildrenopty.keySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()] ){
		system.debug('In populatePreSalesOpportunityNumber>>>>>>>>>>>>>>>>>parentOpp.Opportunity_Id__c>>'+parentOpp.Opportunity_Id__c);
		parentOptyAndparentOpptyNumber.put(parentOpp.Id, parentOpp.Opportunity_Id__c);
	}
	integer skip1 = 1;
	system.debug('In populatePreSalesOpportunityNumber>>>>>>>>>>>>>>>>>parentOptyAndparentOpptyNumber>>'+parentOptyAndparentOpptyNumber);
	if(parentOptyAndparentOpptyNumber !=NULL){
		List<Opportunity> childoptys = [Select Id, Opportunity_ID__c,
				PSR_Reference_Opportunity__c,createdDate from Opportunity
				Where PSR_Reference_Opportunity__c =: parentOptyAndparentOpptyNumber.keySet() Order By createdDate DESC LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows() ALL ROWS];
		if(childoptys.size() == 1){
			last3Digit = GlobalConstants.ZERO;
			chieldOptyAndLast3Number.put(childoptys[0].Id, last3Digit);
			parentOptyAndLast3Number.put(childoptys[0].PSR_Reference_Opportunity__c,last3Digit);
		}
		else{
			for(Opportunity chieldOppty: childoptys )
			{
				system.debug('chieldOppty.Id >>'+chieldOppty.Id);
				if(!chieldOptyAndLast3Number.containsKey(chieldOppty.Id) && skip1 != 1){

		if(String.isBlank(chieldOppty.Opportunity_ID__c)){
			last3Digit = GlobalConstants.ZERO;
			chieldOptyAndLast3Number.put(chieldOppty.Id, last3Digit);
		}else{
			system.debug('In populatePreSalesOpportunityNumber>>>>>>>>>>>>>>>>> chieldOppty.Opportunity_ID__c'+chieldOppty.Opportunity_ID__c);
			String preOptyNumber = String.valueOf(chieldOppty.Opportunity_ID__c);
			system.debug('In populatePreSalesOpportunityNumber>>>>>>>>>>>>>>>>> preOptyNumber '+preOptyNumber );
			last3Digit = preOptyNumber.right(3);
			chieldOptyAndLast3Number.put(chieldOppty.Id, last3Digit );
		}
		system.debug('in for>>>'+chieldOptyAndLast3Number);
		system.debug('in for>>> chieldOppty.PSR_Reference_Opportunity__c'+chieldOppty.PSR_Reference_Opportunity__c);
		system.debug('in for>>> chieldOppty.last3Digit'+last3Digit);
		parentOptyAndLast3Number.put(chieldOppty.PSR_Reference_Opportunity__c,last3Digit);
		break;
				}
				skip1 ++;
			}
		}

	}

	for ( Opportunity opp : [select Id,name,PSR_Reference_Opportunity__c,Opportunity_ID__c,RecordType.Developername, PSR_Pre_Sales_Risk_Opportunity_Type__c
				 from opportunity where Id IN: opptyList LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()] ){
			system.debug('parentOptyAndparentOpptyNumber.containsKey(opp.PSR_Reference_Opportunity__c)'+parentOptyAndparentOpptyNumber.containsKey(opp.PSR_Reference_Opportunity__c));
			system.debug('parentOptyAndLast3Number.containsKey(opp.PSR_Reference_Opportunity__c)'+parentOptyAndLast3Number.containsKey(opp.PSR_Reference_Opportunity__c));
			system.debug('opp.PSR_Reference_Opportunity__c>>>'+opp.PSR_Reference_Opportunity__c);

			if(parentOptyAndparentOpptyNumber.containsKey(opp.PSR_Reference_Opportunity__c) && parentOptyAndLast3Number.containsKey(opp.PSR_Reference_Opportunity__c)){
			 if(opp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.TRIAL)){
				 optyNumberFormatAsPerRecordType = globalConstants.TRIALTYPE;
			 }else if(opp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.DEMO)){
				 optyNumberFormatAsPerRecordType = globalConstants.DEMOTYPE;
			 }else if(opp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.FOC)){
				 optyNumberFormatAsPerRecordType = globalConstants.FOCTYPE;
			 }else if(opp.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.RISK_ORDER)){
				 optyNumberFormatAsPerRecordType = globalConstants.RISKORDERTYPE;
			 }
			 system.debug('parentOptyAndLast3Number.get(opp.PSR_Reference_Opportunity__c)>>>'+parentOptyAndLast3Number.get(opp.PSR_Reference_Opportunity__c));
			 system.debug('opp.PSR_Pre_Sales_Risk_Opportunity_Type__c>>>>>>>>' + opp.PSR_Pre_Sales_Risk_Opportunity_Type__c);
			 Integer lastThreeDigits = Integer.ValueOf(parentOptyAndLast3Number.get(opp.PSR_Reference_Opportunity__c))+1;
			 system.debug('lastThreeDigits >>>'+lastThreeDigits  );
			 String lastThreeDigitsStr = String.valueOf(lastThreeDigits);
			 if(lastThreeDigitsStr.length() == 1){
				 lastThreeDigitsStr = globalConstants.APPEND_DOUBLEZERO + lastThreeDigitsStr;
			 }else if(lastThreeDigitsStr.length() == 2){
				 lastThreeDigitsStr = globalConstants.APPEND_SINGLEZERO+ lastThreeDigitsStr;
			 }
			 system.debug('lastThreeDigitsStr >>>'+lastThreeDigitsStr );
			 opp.Opportunity_ID__c = parentOptyAndparentOpptyNumber.get(opp.PSR_Reference_Opportunity__c)+GlobalConstants.DOT+optyNumberFormatAsPerRecordType+GlobalConstants.DOT+ lastThreeDigitsStr ;
			 // opp.Opportunity_ID__c  = parentOptyAndparentOpptyNumber.get(opp.PSR_Reference_Opportunity__c)+GlobalConstants.DOT+optyNumberFormatAsPerRecordType+GlobalConstants.DOT+ lastThreeDigitsStr ;
			 System.debug('the Opportunity Number >>>>>>>' + opp.Opportunity_ID__c);
			 opportunityToUpdate.add(opp);
			}
				 }

	if(!opportunityToUpdate.isEmpty()){
		Database.SaveResult[] savedResults = Database.update(opportunityToUpdate, false);
		Boolean someFailure = false;
		// add exception into exception if there is any in database.saveresult.
		ExceptionHandler.generateExceptionRecordFromSaveResult(savedResults, GlobalConstants.METHOD_POPULATEPRESALESOPPTYNUMBER, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES);
	}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.METHOD_POPULATEPRESALESOPPTYNUMBER );
		}
	}

	public static Map<Id, Set<Id>>mapOppIdRelatedUsers ;
	public static Map<Id, Opportunity>mapOptyIdAndOTMs ;
	public static ConnectApi.FeedItemInput feedItemInput ;
	public static ConnectApi.MessageBodyInput messageBodyInput ;
	public static ConnectApi.TextSegmentInput textSegmentInput ;
	public static ConnectApi.MentionSegmentInput mentionSegmentInput ;
	public static list<Id> lstIds ;
	/***************
*Requirement Details:  Pre-Sales:Sprint 7: Req#2503
*Method Name: NotifyOpportunityTeamMembers
*Description: When Opportunity is submitted for approval,rejected,approved then notify OTMs via chatter feed
*Parameters: List<Opportunity> opptyList
**************/
	/* public static void notifyOpportunityTeamMembers(List<Opportunity>opportunitiesList, Map<Id, Opportunity> opportunitiesoldMap) {

mapOppIdRelatedUsers = new Map<Id, Set<Id>>();
mapOptyIdAndOTMs = new Map<Id, Opportunity>();
system.debug('NotifyOpportunityTeamMembers>>>>>>>>>>>>>>>'+opportunitiesList);
try{
GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true; // to stop recursion
for(Opportunity opportunity : opportunitiesList){
if(opportunity.stagename != opportunitiesoldMap.get(opportunity.Id).stagename &&( opportunity.stagename == GlobalConstants.IN_EXECUTION
|| opportunity.stagename == GlobalConstants.SUBMITTED_FOR_APPROVAL)){


mapOptyIdAndOTMs.put(opportunity.Id, opportunity);
}
}
//system.assert(false, mapOptyIdAndOTMs);
system.debug('mapOptyIdAndOTMs>>>'+mapOptyIdAndOTMs);
if(!mapOptyIdAndOTMs.isEmpty()){

// fill the mapOppIdRelatedUsers Map by opportunity Owners
for (Opportunity opp: opportunitiesList) {
if (!mapOppIdRelatedUsers.containsKey(opp.Id)) {
mapOppIdRelatedUsers.put(opp.Id, new Set<Id>());
}
mapOppIdRelatedUsers.get(opp.Id).add(opp.OwnerId);
}

// fill the Map by opportunity team members
for (OpportunityTeamMember opportunityTeamMember: [SELECT UserId, OpportunityId
FROM OpportunityTeamMember
WHERE OpportunityId IN: mapOptyIdAndOTMs.keySet()
LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]) {

if (!mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId)) {
mapOppIdRelatedUsers.put(opportunityTeamMember.OpportunityId, new Set<Id>());
}
mapOppIdRelatedUsers.get(opportunityTeamMember.OpportunityId).add(opportunityTeamMember.UserId);
}
system.debug('mapOppIdRelatedUsers>>>'+mapOppIdRelatedUsers);
for (Id oppId: mapOptyIdAndOTMs.keySet()) {
if (mapOppIdRelatedUsers.get(OppId) != null) {
integer iNumber = 24 ;
integer NumberOfPost = (integer)((decimal) mapOppIdRelatedUsers.get(OppId).size() / iNumber).round(System.RoundingMode.UP);
integer StartLoop = 0;
system.debug('NumberOfPost >>>'+ NumberOfPost );
// for (integer i = 0; i<NumberOfPost; i++)
{
feedItemInput = new ConnectApi.FeedItemInput();
messageBodyInput = new ConnectApi.MessageBodyInput();
textSegmentInput = new ConnectApi.TextSegmentInput();
messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
lstIds = new list<Id>(mapOppIdRelatedUsers.get(oppId));

for (integer j = StartLoop; j<StartLoop + iNumber; j++) {
if (lstIds.size()>j) {
mentionSegmentInput = new ConnectApi.MentionSegmentInput();
mentionSegmentInput.Id = lstIds[j];
messageBodyInput.messageSegments.add(mentionSegmentInput);
}
}
StartLoop += iNumber;
if ((mapOptyIdAndOTMs.get(oppId).stagename).Contains(GlobalConstants.SUBMITTED_FOR_APPROVAL)) {
textSegmentInput.text = GlobalConstants.APPROVAL_STATEMENT + GlobalConstants.DOUBLE_STARTQUOTE + mapOptyIdAndOTMs.get(oppId).StageName + GlobalConstants.DOUBLE_ENDQUOTE;
}
if ((mapOptyIdAndOTMs.get(oppId).Apttus_Approval__Approval_Status__c).Contains(GlobalConstants.APPROVED)) {
textSegmentInput.text = Label.NF_Opportunity_Approved + GlobalConstants.DOUBLE_STARTQUOTE + mapOptyIdAndOTMs.get(oppId).StageName + GlobalConstants.DOUBLE_ENDQUOTE;
}
if ((mapOptyIdAndOTMs.get(oppId).Apttus_Approval__Approval_Status__c).Contains(GlobalConstants.REJECTED)) {
textSegmentInput.text = Label.NF_Opportunity_Rejected + GlobalConstants.DOUBLE_STARTQUOTE + mapOptyIdAndOTMs.get(oppId).StageName + GlobalConstants.DOUBLE_ENDQUOTE;
}

system.debug('textSegmentInput>>>'+textSegmentInput);

messageBodyInput.messageSegments.add(textSegmentInput);

feedItemInput.body = messageBodyInput;
system.debug(' feedItemInput.body>>>'+ feedItemInput.body);
feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
system.debug(' feedItemInput.feedElementType>>>'+feedItemInput.feedElementType);
feedItemInput.subjectId = oppId;
system.debug('feedItemInput.feedElementType'+feedItemInput.feedElementType);
system.debug('feedItemInput>>>'+feedItemInput);
if (!test.isRunningTest()) {}
ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

}
}

}
}
}catch(Exception ex){
ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.NOTIFYOPPORTUNITYTEAMMEMBERS );
}
}
*/
	public static List<Opportunity> preSalesOptyList  = new List<Opportunity> ();
	/*Helper method to get optylist based on presales recordtype*/
	public static List<Opportunity> getIsApplicableForPreSalesList(List<Opportunity> opptyList){


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
		system.debug('preSalesOptyList>>Helper'+preSalesOptyList);
		return preSalesOptyList;
	}

	public static Map<Id, Opportunity> preSalesOptyOldMap  = new Map<Id, Opportunity>() ;
	/*Helper method to get optylist based on presales recordtype*/
	public static Map<Id,Opportunity> getIsApplicableForPreSalesMap(List<Opportunity> preSalesOptyList ,Map<Id,Opportunity> optyOldMap){

		try{
			for(Opportunity opty : preSalesOptyList){
	preSalesOptyOldMap.put(opty.Id, optyOldMap.get(opty.Id));
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.GETISAPPLICABLEFORPRESALESMap );
		}
		return preSalesOptyOldMap;
	}

	public static List<Opportunity> preSalesOptyListReadOnly  = new List<Opportunity> ();
	/*Helper method to get optylist based on presales recordtype*/
	public static List<Opportunity> getIsApplicableForPreSalesListWithReadOnly(List<Opportunity> opptyList){

		system.debug('helper opptyList'+ opptyList);

		try{
			for(Opportunity opty : opptyList){
	system.debug('helper opptyList RecordTypeId '+ opty.RecordTypeId +'..'+PSR_ReadOnlyRecordTypeID);
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


	public static Set<Opportunity> preSalesOpty ;
	public static List<Opportunity> psrOpportunities ;
	/***************
*Requirement Details:  Pre-Sales:Sprint 8: Req#2760
*Method Name: populateParentCurrency
*Description: When a parent Opportunity's Currency is changed, all the pre sales child records' currency should be changed
*Parameters: List<Opportunity> opptyList, Map<Id, Opportunity> opportunityOldMap
**************/
	public static void populateParentCurrency(List<Opportunity>opptyList, Map<Id, Opportunity> opportunityOldMap){
		try{
			opportunityIdAndOpportunityMap = new Map<Id, Opportunity>();
			preSalesOpty = new Set<Opportunity>();
			psrOpportunities = new List<Opportunity>();

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
		Boolean someFailure = false;
		// add exception into exception if there is any in database.saveresult.
		ExceptionHandler.generateExceptionRecordFromSaveResult(savedResults, GlobalConstants.METHOD_POPULATECURRENCY, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES);
	}
			}

		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex,GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.METHOD_POPULATECURRENCY );
		}
	}

	public static Map<Id, Id> mapOptyIdAndAccountId ;
	public static Map<Id, String> optyIdAndAccountName ;
	public static ConnectApi.TextSegmentInput textSegmentInput1 ;
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
		//end modified for Ticket 00012822
		//mapOppIdRelatedUsers = new Map<Id, Set<Id>>();
		MapOptyIdAndOTMs = new Map<Id, Opportunity>();
		//mapOptyIdAndAccountId = new Map<Id, Id>();
		//optyIdAndAccountName = new Map<Id, String>();
		//Set<Id> emptySet = new Set<Id>();

		try{
			//GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true; // to stop recursion
			for(Opportunity opportunity : opportunitiesList){
	//modified for Ticket 00012822 : PSRO cancellation notif email fired when Account LE updated in "Reference Sales Opportunity"
	//if(opportunity.stagename == GlobalConstants.COMPLETED_OPPTY || opportunity.stagename == GlobalConstants.CANCEL){
	if(((String.isEmpty(mapIdOldOpp.get(opportunity.Id).stagename) && String.isNotEmpty(mapIdNewOpp.get(opportunity.Id).stagename))
		|| (String.isNotEmpty(mapIdOldOpp.get(opportunity.Id).stagename) && String.isNotEmpty(mapIdNewOpp.get(opportunity.Id).stagename)
			&& mapIdOldOpp.get(opportunity.Id).stagename != mapIdNewOpp.get(opportunity.Id).stagename))
	   && (opportunity.stagename == GlobalConstants.COMPLETED_OPPTY || opportunity.stagename == GlobalConstants.CANCEL)){
		mapOptyIdAndOTMs.put(opportunity.Id, opportunity);
		//mapOptyIdAndAccountId.put(opportunity.Id, opportunity.AccountId);
	   }
	//end modified for Ticket 00012822
			}
			if(MapOptyIdAndOTMs.size() > 0)
	notifyWhenPresalesOpptyClosed(MapOptyIdAndOTMs.keySet());
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
		mapOppIdRelatedUsers = new Map<Id, Set<Id>>();
		MapOptyIdAndOTMs = new Map<Id, Opportunity>();
		//mapOptyIdAndAccountId = new Map<Id, Id>();
		//optyIdAndAccountName = new Map<Id, String>();
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment1;
		ConnectApi.MarkupEndSegmentInput markupEndSegment1;
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment2;
		ConnectApi.MarkupEndSegmentInput markupEndSegment2;
		Set<Id> emptySet = new Set<Id>();

		try{
			//system.debug('mapOptyIdAndOTMs>>>'+mapOptyIdAndOTMs);
			if(opptyIdSet.size() > 0){
	MapOptyIdAndOTMs = new Map<Id,Opportunity>([select Id,OwnerId,Name,Account_Name__c,
						PSR_Pre_Sales_Risk_Opportunity_Type__c,
						StageName,Opportunity_Id__c,PSR_Lead_Business_Group__c
						from Opportunity
						where id in: opptyIdSet
						LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
	system.debug('mapOptyIdAndOTMs>>>'+mapOptyIdAndOTMs);
	// fill the mapOppIdRelatedUsers Map by opportunity Owners
	for (Opportunity opp: MapOptyIdAndOTMs.values()) {
		if (!mapOppIdRelatedUsers.containsKey(opp.Id)) {
			emptySet = new set<Id>();
			mapOppIdRelatedUsers.put(opp.Id, emptySet);
		}
		mapOppIdRelatedUsers.get(opp.Id).add(opp.OwnerId);
	}
	// fill the Map by opportunity team members
	for (OpportunityTeamMember opportunityTeamMember: [SELECT UserId, OpportunityId
				   FROM OpportunityTeamMember
				   WHERE OpportunityId IN: mapOptyIdAndOTMs.keySet()
				   LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
					if (!mapOppIdRelatedUsers.containsKey(opportunityTeamMember.OpportunityId)) {
					 emptySet = new set<Id>();
					 mapOppIdRelatedUsers.put(opportunityTeamMember.OpportunityId, emptySet);
					}
					mapOppIdRelatedUsers.get(opportunityTeamMember.OpportunityId).add(opportunityTeamMember.UserId);
				   }

	// fill the Map by approvers /stackeholders /valIdators
	//Apttus_Approval__Approval_Status__c
	for(Apttus_Approval__Approval_Request__c reqInfo:[SELECT Id,Apttus_Approval__Step_Name__c, Apttus_Approval__Backup_From_User__c,
				  Apttus_Approval__Assigned_To_Id__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
				  FROM Apttus_Approval__Approval_Request__c
				  WHERE Apttus_Approval__Object_Id__c IN: mapOptyIdAndOTMs.keySet() AND Apttus_Approval__Assigned_To_Id__c<>NULL
				 ]){ if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
					 emptySet = new Set<id>();
					 mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c,emptySet);
				 }
					mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Assigned_To_Id__c);
					if (ReqInfo.Apttus_Approval__DelegateApproverIds__c != GlobalConstants.SALES_EMPTY) {
						String[] delegateApproverIds = ReqInfo.Apttus_Approval__DelegateApproverIds__c.split(GlobalConstants.COMMA);
						for (string delegateapproverId: delegateApproverIds) {
							if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
					emptySet = new Set<id>();
					mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, emptySet);
							}mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(delegateapproverId);
						}
					}
					if (ReqInfo.Apttus_Approval__Backup_From_User__c != GlobalConstants.SALES_EMPTY) {
						if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
							emptySet = new Set<Id>();
							mapOppIdRelatedUsers.put(ReqInfo.Apttus_Approval__Object_Id__c, emptySet);
						}mapOppIdRelatedUsers.get(ReqInfo.Apttus_Approval__Object_Id__c).add(ReqInfo.Apttus_Approval__Backup_From_User__c);
					}
				   }
	system.debug('mapOppIdRelatedUsers>>>'+mapOppIdRelatedUsers);
	for (Id oppId: mapOptyIdAndOTMs.keySet()) {
		if (mapOppIdRelatedUsers.get(OppId) != null) {
			integer iNumber = 24 ;
			integer numberOfPost = (integer)((decimal) mapOppIdRelatedUsers.get(OppId).size() / iNumber).round(System.RoundingMode.UP);
			integer startLoop = 0;
			system.debug('NumberOfPost when closed >>>'+NumberOfPost );
			//  for (integer i = 0; i<NumberOfPost; i++)
			{
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

				if(mapOptyIdAndOTMs.get(oppId).PSR_Lead_Business_Group__c != Null){
		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = mapOptyIdAndOTMs.get(oppId).PSR_Lead_Business_Group__c;
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
				if (!test.isRunningTest()) {}
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
*Method Name: convertVRPSR_validationRule
*Description: This method will Prevent manually editing the Opportunity Currency for all preSales opptys
*Parameters: Opportunity List, Opportunity Map
*Test coverage from: OpportunityTriggerHelperPreSalesTest
*******************************/
	public static void convertVRPSR_validationRule(List<Opportunity>opportunityList, Map<Id, Opportunity>opportunityOldMap)
	{
		Set<Opportunity>Opprec = new Set<Opportunity>();
		try
		{
			Map<Id, Opportunity> newOpptyMap = new Map<Id, Opportunity>();
			for(Opportunity oppty : opportunityList)
			{
	newOpptyMap.put(oppty.Id, oppty);
			}

			for (Opportunity newrec: [select CurrencyIsoCode,PSR_Reference_Opportunity__r.CurrencyIsoCode
			  from Opportunity where Id in: opportunityList LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
	System.debug('Child old CurrencyIsoCode >>>'+opportunityOldMap.get(newrec.Id).CurrencyIsoCode+' child new CurrencyIsoCode : '+newOpptyMap.get(newrec.Id).CurrencyIsoCode);
	System.debug('Child CurrencyIsoCode >>>'+newrec.CurrencyIsoCode+' parent CurrencyIsoCode : '+newrec.PSR_Reference_Opportunity__r.CurrencyIsoCode);

	if(newOpptyMap.get(newrec.Id).CurrencyIsoCode <> opportunityOldMap.get(newrec.Id).CurrencyIsoCode && newOpptyMap.get(newrec.Id).CurrencyIsoCode <> newrec.PSR_Reference_Opportunity__r.CurrencyIsoCode)
	{
		newOpptyMap.get(newrec.Id).addError(GlobalConstants.YOU_CANNOT_CHANGE_PRE_SALES_OPPORTUNITIES_CURRENCY);
	}
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.METHOD_CONVERTVRVALIDATION );
		}
	}

	/***************
*Requirement Details:  Pre-Sales:Sprint 9: Req#2359
*Method Name: populateParentAccount
*Description: When a parent Opportunity's Account Name is changed, all the pre sales child records' Account Name should be changed
*Parameters: List<Opportunity> opptyList, Map<Id, Opportunity> opportunityOldMap
**************/
	/*public static void populateParentAccount(List<Opportunity>opptyList, Map<Id,Opportunity> opportunityOldMap){

List<Opportunity> psrOpportunities = new List<Opportunity>();


try{
//get all parent opportunity Ids, for which account is modified
for (Opportunity newrec: opptyList) {
if(newrec.AccountId != opportunityOldMap.get(newrec.Id).AccountId){
opportunityIdAndOpportunityMap.put(newrec.Id, newrec);
}
}

if(!opportunityIdAndOpportunityMap.isEmpty()){
psrOpportunities = [ select Id, PSR_Reference_Opportunity__r.AccountId, PSR_Reference_Opportunity__c from Opportunity
where PSR_Reference_Opportunity__c in: opportunityIdAndOpportunityMap.keySet()
and stagename =: GlobalConstants.PREPARATION LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];

//get all the child presales opportunities and in preparation stage of the parent
for(Opportunity psrOppty : psrOpportunities){
if(opportunityIdAndOpportunityMap.containsKey(psrOppty.PSR_Reference_Opportunity__c)){
psrOppty.AccountId = opportunityIdAndOpportunityMap.get(psrOppty.PSR_Reference_Opportunity__c).AccountId;
}
}


if(!psrOpportunities.isEmpty()){
Database.SaveResult[] savedResults = Database.update(psrOpportunities, false);
Boolean someFailure = false;
// add exception into exception if there is any in database.saveresult.
ExceptionHandler.generateExceptionRecordFromSaveResult(savedResults, GlobalConstants.METHOD_POPULATEACCOUNT, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES);
}
}

}catch(Exception ex) {
ExceptionHandler.addException(ex,GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES , GlobalConstants.METHOD_POPULATEACCOUNT );
}
}*/
	public static boolean salesValuesChanged(Opportunity opp, Map<Id,Opportunity> optyOldMap)
	{
		if(opp.PSR_Sales_Value_Business_Group_AA__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_Business_Group_AA__c
			|| opp.PSR_Sales_Value_Business_Group_FN__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_Business_Group_FN__c
			|| opp.PSR_Sales_Value_Business_Group_GS__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_Business_Group_GS__c
			|| opp.PSR_Sales_Value_Business_Group_MN__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_Business_Group_MN__c
			|| opp.PSR_Sales_Value_Business_Unit_ION_Optics__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_Business_Unit_ION_Optics__c
			|| opp.PSR_Sales_Value_Business_Unit_ION_IPR__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_Business_Unit_ION_IPR__c
			|| opp.PSR_Sales_Value_BU_ION_IPR_DNI__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_BU_ION_IPR_DNI__c
			|| opp.PSR_Sales_Value_BU_ION_IPR_MPC__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_BU_ION_IPR_MPC__c
			|| opp.PSR_Sales_Value_BU_ION_IPR_Nuage__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_BU_ION_IPR_Nuage__c
			|| opp.PSR_Sales_Value_BU_ION_IPR_Services__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_BU_ION_IPR_Services__c
			|| opp.PSR_Sales_Value_BU_ION_Optics_Services__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_BU_ION_Optics_Services__c
			|| opp.PSR_Sales_Value_BU_NE_DAaaS__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_BU_NE_DAaaS__c
			|| opp.PSR_Sales_Value_BU_NE_EOP__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_BU_NE_EOP__c
			|| opp.PSR_Sales_Value_BU_NE_IoT__c  <> optyOldMap.get(opp.Id).PSR_Sales_Value_BU_NE_IoT__c )
			return true;
		else
			return false;
	}

	public static boolean costsValuesChanged(Opportunity opp, Map<Id,Opportunity> optyOldMap)
	{
		if(opp.PSR_Cost_BU_ION_IPR_DNI__c  <> optyOldMap.get(opp.Id).PSR_Cost_BU_ION_IPR_DNI__c
			|| opp.PSR_Cost_BU_ION_IPR_MPC__c  <> optyOldMap.get(opp.Id).PSR_Cost_BU_ION_IPR_MPC__c
			|| opp.PSR_Cost_BU_ION_IPR_Nuage__c  <> optyOldMap.get(opp.Id).PSR_Cost_BU_ION_IPR_Nuage__c
			|| opp.PSR_Cost_BU_ION_IPR_Services__c  <> optyOldMap.get(opp.Id).PSR_Cost_BU_ION_IPR_Services__c
			|| opp.PSR_Cost_BU_ION_Optics_Services__c  <> optyOldMap.get(opp.Id).PSR_Cost_BU_ION_Optics_Services__c
			|| opp.PSR_Cost_BU_NE_DAaaS__c  <> optyOldMap.get(opp.Id).PSR_Cost_BU_NE_DAaaS__c
			|| opp.PSR_Cost_BU_NE_EOP__c  <> optyOldMap.get(opp.Id).PSR_Cost_BU_NE_EOP__c
			|| opp.PSR_Cost_BU_NE_IoT__c  <> optyOldMap.get(opp.Id).PSR_Cost_BU_NE_IoT__c
			|| opp.PSR_Cost_Business_Group_AA__c  <> optyOldMap.get(opp.Id).PSR_Cost_Business_Group_AA__c
			|| opp.PSR_Cost_Business_Group_FN__c  <> optyOldMap.get(opp.Id).PSR_Cost_Business_Group_FN__c
			|| opp.PSR_Cost_Business_Group_GS__c  <> optyOldMap.get(opp.Id).PSR_Cost_Business_Group_GS__c
			|| opp.PSR_Cost_Business_Group_MN__c  <> optyOldMap.get(opp.Id).PSR_Cost_Business_Group_MN__c
			|| opp.PSR_Cost_Business_Unit_ION_IPR__c  <> optyOldMap.get(opp.Id).PSR_Cost_Business_Unit_ION_IPR__c
			|| opp.PSR_Cost_Business_Unit_ION_Optics__c  <> optyOldMap.get(opp.Id).PSR_Cost_Business_Unit_ION_Optics__c
			|| opp.PSR_Cost_Business_Unit_ION_Video__c  <> optyOldMap.get(opp.Id).PSR_Cost_Business_Unit_ION_Video__c)
			return true;
		else
			return false;
	}
	/***************
*Requirement Details:  Pre-Sales:Sprint 10: Req#3097  + presales - Jan 18 Release :  5541 and 5647
*Method Name: costCalculationWhenEstimatedCostChecked
*Description: When The Estimated Cost is Checked, Automatically Cost values are updated.
*Parameters: List<Opportunity> opptyList, Map<Id, Opportunity> opportunityOldMap
**************/
	public static void costCalculationWhenEstimatedCostChecked(List<Opportunity>opptyList, Map<Id,Opportunity> optyOldMap){
		System.debug('in costCalculationWhenEstimatedCostChecked');
		try{
			for (Opportunity opp: opptyList)
			{
	boolean salesChanged = salesValuesChanged(opp,optyOldMap);
	boolean costsChanged = costsValuesChanged(opp,optyOldMap);
	if(!salesChanged && !costsChanged && opp.PSR_Automatically_Calc_Estimated_Cost__c == optyOldMap.get(opp.Id).PSR_Automatically_Calc_Estimated_Cost__c)
		continue;
	if(costsChanged && opp.PSR_Automatically_Calc_Estimated_Cost__c == true)
		opp.addError(GlobalConstants.ERROR_MESSAGE_COSTS_CANT_CHANGE_MANUALLY);
	if((salesChanged || costsChanged || opp.PSR_Automatically_Calc_Estimated_Cost__c  <> optyOldMap.get(opp.Id).PSR_Automatically_Calc_Estimated_Cost__c)
		&& !opp.Stagename.equals(GlobalConstants.PREPARATION))
		opp.addError(GlobalConstants.ERROR_MESSAGE_SALES_COSTS_LOCK_AFTER_PREPARATION);
	if(opp.Stagename.equals(GlobalConstants.PREPARATION) && opp.PSR_Automatically_Calc_Estimated_Cost__c == true)
	{
	 // Commented by HCL on 10th Feb, 2020 against SF ticket 00067724
		/*if(opp.PSR_Sales_Value_Business_Group_AA__c <> null){
			opp.PSR_Cost_Business_Group_AA__c = (opp.PSR_Sales_Value_Business_Group_AA__c* Integer.valueOf(System.Label.PSR_Sales_Value_AA_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_Business_Group_FN__c <> null){
			opp.PSR_Cost_Business_Group_FN__c = (opp.PSR_Sales_Value_Business_Group_FN__c* Integer.valueOf(System.Label.PSR_Sales_Value_FN_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_Business_Group_GS__c <> null){
			opp.PSR_Cost_Business_Group_GS__c = (opp.PSR_Sales_Value_Business_Group_GS__c* Integer.valueOf(System.Label.PSR_Sales_Value_GS_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_Business_Group_MN__c <> null){
			opp.PSR_Cost_Business_Group_MN__c = (opp.PSR_Sales_Value_Business_Group_MN__c* Integer.valueOf(System.Label.PSR_Sales_Value_MN_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_Business_Unit_ION_Optics__c <> null){
			opp.PSR_Cost_Business_Unit_ION_Optics__c = (opp.PSR_Sales_Value_Business_Unit_ION_Optics__c* Integer.valueOf(System.Label.PSR_Sales_Value_ION_Optics_Percentage))/100 ;
		}

		if(opp.PSR_Sales_Value_Business_Unit_ION_IPR__c <> null){
			opp.PSR_Cost_Business_Unit_ION_IPR__c = (opp.PSR_Sales_Value_Business_Unit_ION_IPR__c* Integer.valueOf(System.Label.PSR_Sales_Value_ION_IPR_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_BU_ION_IPR_DNI__c <> null){
			opp.PSR_Cost_BU_ION_IPR_DNI__c = (opp.PSR_Sales_Value_BU_ION_IPR_DNI__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_IPR_DNI_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_BU_ION_IPR_MPC__c <> null){
			opp.PSR_Cost_BU_ION_IPR_MPC__c = (opp.PSR_Sales_Value_BU_ION_IPR_MPC__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_IPR_MPC_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_BU_ION_IPR_Nuage__c <> null){
			opp.PSR_Cost_BU_ION_IPR_Nuage__c = (opp.PSR_Sales_Value_BU_ION_IPR_Nuage__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_IPR_Nuage_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_BU_ION_IPR_Services__c <> null){
			opp.PSR_Cost_BU_ION_IPR_Services__c = (opp.PSR_Sales_Value_BU_ION_IPR_Services__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_IPR_Services_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_BU_ION_Optics_Services__c <> null){
			opp.PSR_Cost_BU_ION_Optics_Services__c = (opp.PSR_Sales_Value_BU_ION_Optics_Services__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_Optics_Services_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_BU_NE_EOP__c <> null){
			opp.PSR_Cost_BU_NE_EOP__c = (opp.PSR_Sales_Value_BU_NE_EOP__c* Integer.valueOf(System.Label.PSR_Sales_Value_NE_EOP_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_BU_NE_DAaaS__c <> null){
			opp.PSR_Cost_BU_NE_DAaaS__c = (opp.PSR_Sales_Value_BU_NE_DAaaS__c* Integer.valueOf(System.Label.PSR_Sales_Value_NE_DAaaS_Percentage))/100 ;
		}
		if(opp.PSR_Sales_Value_BU_NE_IoT__c <> null){
			opp.PSR_Cost_BU_NE_IoT__c = (opp.PSR_Sales_Value_BU_NE_IoT__c* Integer.valueOf(System.Label.PSR_Sales_Value_NE_IoT_Percentage))/100 ;
		}
		*/
		// Added by HCL on 10th Feb, 2020 against SF ticket 00067724
		if(opp.PSR_Sales_Value_Business_Group_AA__c <> null){
			opp.PSR_Cost_Business_Group_AA__c = (opp.PSR_Sales_Value_Business_Group_AA__c* Integer.valueOf(System.Label.PSR_Sales_Value_AA_Percentage))/100 ;
		}
		else opp.PSR_Cost_Business_Group_AA__c =null;

		if(opp.PSR_Sales_Value_Business_Group_FN__c <> null){
			opp.PSR_Cost_Business_Group_FN__c = (opp.PSR_Sales_Value_Business_Group_FN__c* Integer.valueOf(System.Label.PSR_Sales_Value_FN_Percentage))/100 ;
		}
		else opp.PSR_Cost_Business_Group_FN__c =null;

		if(opp.PSR_Sales_Value_Business_Group_GS__c <> null){
			opp.PSR_Cost_Business_Group_GS__c = (opp.PSR_Sales_Value_Business_Group_GS__c* Integer.valueOf(System.Label.PSR_Sales_Value_GS_Percentage))/100 ;
		}
		else opp.PSR_Cost_Business_Group_GS__c =null;

		if(opp.PSR_Sales_Value_Business_Group_MN__c <> null){
			opp.PSR_Cost_Business_Group_MN__c = (opp.PSR_Sales_Value_Business_Group_MN__c* Integer.valueOf(System.Label.PSR_Sales_Value_MN_Percentage))/100 ;
		}
		else opp.PSR_Cost_Business_Group_MN__c =null;

		if(opp.PSR_Sales_Value_Business_Unit_ION_Optics__c <> null){
			opp.PSR_Cost_Business_Unit_ION_Optics__c = (opp.PSR_Sales_Value_Business_Unit_ION_Optics__c* Integer.valueOf(System.Label.PSR_Sales_Value_ION_Optics_Percentage))/100 ;
		}
		else opp.PSR_Cost_Business_Unit_ION_Optics__c =null;

		/*if(opp.PSR_Sales_Value_Business_Unit_ION_VIdeo__c <> null){
opp.PSR_Cost_Business_Unit_ION_VIdeo__c = (opp.PSR_Sales_Value_Business_Unit_ION_VIdeo__c* Integer.valueOf(System.Label.PSR_Sales_Value_ION_VIdeo_Percentage))/100 ;
}*/
		if(opp.PSR_Sales_Value_Business_Unit_ION_IPR__c <> null){
			opp.PSR_Cost_Business_Unit_ION_IPR__c = (opp.PSR_Sales_Value_Business_Unit_ION_IPR__c* Integer.valueOf(System.Label.PSR_Sales_Value_ION_IPR_Percentage))/100 ;
		}
		else opp.PSR_Cost_Business_Unit_ION_IPR__c =null;

		if(opp.PSR_Sales_Value_BU_ION_IPR_DNI__c <> null){
			opp.PSR_Cost_BU_ION_IPR_DNI__c = (opp.PSR_Sales_Value_BU_ION_IPR_DNI__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_IPR_DNI_Percentage))/100 ;
		}
		else opp.PSR_Cost_BU_ION_IPR_DNI__c =null;

		if(opp.PSR_Sales_Value_BU_ION_IPR_MPC__c <> null){
			opp.PSR_Cost_BU_ION_IPR_MPC__c = (opp.PSR_Sales_Value_BU_ION_IPR_MPC__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_IPR_MPC_Percentage))/100 ;
		}
		else opp.PSR_Cost_BU_ION_IPR_MPC__c =null;

		if(opp.PSR_Sales_Value_BU_ION_IPR_Nuage__c <> null){
			opp.PSR_Cost_BU_ION_IPR_Nuage__c = (opp.PSR_Sales_Value_BU_ION_IPR_Nuage__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_IPR_Nuage_Percentage))/100 ;
		}
		else opp.PSR_Cost_BU_ION_IPR_Nuage__c =null;

		if(opp.PSR_Sales_Value_BU_ION_IPR_Services__c <> null){
			opp.PSR_Cost_BU_ION_IPR_Services__c = (opp.PSR_Sales_Value_BU_ION_IPR_Services__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_IPR_Services_Percentage))/100 ;
		}
		else opp.PSR_Cost_BU_ION_IPR_Services__c =null;

		if(opp.PSR_Sales_Value_BU_ION_Optics_Services__c <> null){
			opp.PSR_Cost_BU_ION_Optics_Services__c = (opp.PSR_Sales_Value_BU_ION_Optics_Services__c* Integer.valueOf(System.Label.PSR_Sales_Value_BU_ION_Optics_Services_Percentage))/100 ;
		}
		else opp.PSR_Cost_BU_ION_Optics_Services__c =null;

		if(opp.PSR_Sales_Value_BU_NE_EOP__c <> null){
			opp.PSR_Cost_BU_NE_EOP__c = (opp.PSR_Sales_Value_BU_NE_EOP__c* Integer.valueOf(System.Label.PSR_Sales_Value_NE_EOP_Percentage))/100 ;
		}
		else opp.PSR_Cost_BU_NE_EOP__c =null;

		if(opp.PSR_Sales_Value_BU_NE_DAaaS__c <> null){
			opp.PSR_Cost_BU_NE_DAaaS__c = (opp.PSR_Sales_Value_BU_NE_DAaaS__c* Integer.valueOf(System.Label.PSR_Sales_Value_NE_DAaaS_Percentage))/100 ;
		}
		else opp.PSR_Cost_BU_NE_DAaaS__c =null;

		if(opp.PSR_Sales_Value_BU_NE_IoT__c <> null){
			opp.PSR_Cost_BU_NE_IoT__c = (opp.PSR_Sales_Value_BU_NE_IoT__c* Integer.valueOf(System.Label.PSR_Sales_Value_NE_IoT_Percentage))/100 ;
		}
		else opp.PSR_Cost_BU_NE_IoT__c =null;
	}
			}
		}catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.COSTCALCULATIONWHENESTIMATEDCOSTCHECKED);
		}
	}
	/***************
	Requirement Details:  Pre-Sales:Sprint 12: Req#3457, Sprint -19 : Req#5561
	*Method Name: psrGateClassificationAllocation
	*Description: All Oppty's Gate field updated as per the custom Setting.
	*Parameters: List<Opportunity> opptyList, Map<Id,Opportunity> optyOldMap
	**************/
	public static void psrGateClassificationAllocation(List<Opportunity>opptyList, Map<Id,Opportunity> optyOldMap) {

		Map<Id, Opportunity> preSalesOptyMapForLoAlevel = new Map<Id, Opportunity>();
		Map <Id, Opportunity> salesOptyWithApprovalDateMap = new Map <Id, Opportunity>();
		try{
			List<PSRO_Market_Threshold__c> ThresholdList = [Select Id, Market__c, Threshold_Value__c, current_value__c, Business_Group__c
				from PSRO_Market_Threshold__c];
			List<Map_Enterprise_MUs_and_Market__c> mapL5_L4 = Map_Enterprise_MUs_and_Market__c.getAll().values();
			List<PSRO_Market_Threshold__c>  UpdateList = new List<PSRO_Market_Threshold__c> ();
			List<PSRO_Market_Threshold__c>  sendmail_List = new List<PSRO_Market_Threshold__c> ();
			Oppcurrency = new Set<String>();
			datedrate = new Map<String, Decimal>();
			Boolean exceed;
			Date todayDate = Date.Today();
			String buValue;
			for (Opportunity newrec: opptyList)
			{
	Oppcurrency.add(newrec.CurrencyIsoCode);
			}
			if(!opptyList.isEmpty())
			{ 
	for (Dated_Exchange_Rates__c ratecollect:  [select Id, CurrencyIsoCode, Exchange_Rate__c, Start_Date__c
						from Dated_Exchange_Rates__c where CurrencyIsoCode =: Oppcurrency
						AND Start_Date__c<=: todayDate
						Order By Start_Date__c ASC LIMIT: Limits.getLimitQueryRows()])
	{
		datedrate.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
	}
			}
			
			for(Opportunity opportunity : opptyList)
			{
	// Added by HCL on 02March 2020 against SF ticket 00067724
	// Description: We have moved the PSR_Lead_Business_Group__c from Formula type to Text field in Trigger. SF Ticket - 00067724.
	decimal ionVal=0;
	if(opportunity.PSR_Cost_BU_ION_IPR_DNI__c!=null) ionVal+=opportunity.PSR_Cost_BU_ION_IPR_DNI__c;
	if(opportunity.PSR_Cost_BU_ION_IPR_MPC__c!=null) ionVal+=opportunity.PSR_Cost_BU_ION_IPR_MPC__c;
	if(opportunity.PSR_Cost_BU_ION_IPR_Nuage__c!=null) ionVal+=opportunity.PSR_Cost_BU_ION_IPR_Nuage__c;
	if(opportunity.PSR_Cost_Business_Unit_ION_IPR__c!=null) ionVal+=opportunity.PSR_Cost_Business_Unit_ION_IPR__c;
	if(opportunity.PSR_Cost_BU_ION_IPR_Services__c!=null) ionVal+=opportunity.PSR_Cost_BU_ION_IPR_Services__c;
	if(opportunity.PSR_Cost_Business_Unit_ION_Optics__c!=null) ionVal+=opportunity.PSR_Cost_Business_Unit_ION_Optics__c;
	if(opportunity.PSR_Cost_BU_ION_Optics_Services__c!=null) ionVal+=opportunity.PSR_Cost_BU_ION_Optics_Services__c;

	decimal nenVal=0;
				decimal[] nenCostBU = new List<Decimal>();
				if(opportunity.PSR_Cost_BU_NE_IoT__c!=null){
					nenVal+=opportunity.PSR_Cost_BU_NE_IoT__c;
					nenCostBU.add(opportunity.PSR_Cost_BU_NE_IoT__c);
				}
				if(opportunity.PSR_Cost_BU_NE_DAaaS__c!=null){
					nenVal+=opportunity.PSR_Cost_BU_NE_DAaaS__c;
					nenCostBU.add(opportunity.PSR_Cost_BU_NE_DAaaS__c);
				}
				if(opportunity.PSR_Cost_BU_NE_EOP__c!=null){
					nenVal+=opportunity.PSR_Cost_BU_NE_EOP__c;
					nenCostBU.add(opportunity.PSR_Cost_BU_NE_EOP__c);
				} 

	Decimal[] psrCostBG = new List<Decimal>();
	psrCostBG.add(opportunity.PSR_Cost_Business_Group_AA__c);
	psrCostBG.add(opportunity.PSR_Cost_Business_Group_FN__c);
	psrCostBG.add(opportunity.PSR_Cost_Business_Group_GS__c);
	//psrCostBG.add(opportunity.PSR_Cost_Business_Group_ION__c);
	psrCostBG.add(ionVal); // replacing 'PSR_Cost_Business_Group_ION__c' field with summarized value of dependent fields
	psrCostBG.add(opportunity.PSR_Cost_Business_Group_MN__c);
	//psrCostBG.add(opportunity.PSR_Cost_BG_NEN__c);
	psrCostBG.add(nenVal); // replacing 'PSR_Cost_BG_NEN__c' field with summarized value of dependent fields
	psrCostBG.sort();

	system.debug('psrCostBG: '+psrCostBG);	
	Integer arraySize = psrCostBG.size();

	if(opportunity.PSR_Cost_Business_Group_AA__c == psrCostBG[arraySize-1]){
		opportunity.PSR_Lead_Business_Group__c = GlobalConstants.Lead_BG_NSW;
	} else if(opportunity.PSR_Cost_Business_Group_FN__c == psrCostBG[arraySize-1]){
		opportunity.PSR_Lead_Business_Group__c = GlobalConstants.LEAD_BG_FN;
	} else if(opportunity.PSR_Cost_Business_Group_GS__c == psrCostBG[arraySize-1]){
		opportunity.PSR_Lead_Business_Group__c = GlobalConstants.LEAD_BG_GS;
	} else if(ionVal == psrCostBG[arraySize-1] && ionVal != 0){
		opportunity.PSR_Lead_Business_Group__c = GlobalConstants.LEAD_BG_ION;
	} else if(opportunity.PSR_Cost_Business_Group_MN__c == psrCostBG[arraySize-1]){
		opportunity.PSR_Lead_Business_Group__c = GlobalConstants.LEAD_BG_MN;
	} else if(nenVal > 0){
		opportunity.PSR_Lead_Business_Group__c = GlobalConstants.LEAD_BG_NEN;
					//get BU
					nenCostBU.sort();
					Integer nenArraySize = nenCostBU.size();
					if(opportunity.PSR_Cost_BU_NE_IoT__c == nenCostBU[nenArraySize-1]){
						buValue = GlobalConstants.NEIOT;
					} else if(opportunity.PSR_Cost_BU_NE_DAaaS__c == nenCostBU[nenArraySize-1]){
						buValue = GlobalConstants.NEDAAAS;
					} else if(opportunity.PSR_Cost_BU_NE_EOP__c == nenCostBU[nenArraySize-1]){
						buValue = GlobalConstants.NEEOP;
					}
	}
	//End

	/*if( opportunity.PSR_Cost_Business_Group_FN__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_FN__c ||
		opportunity.PSR_Cost_Business_Group_GS__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_GS__c ||
		opportunity.PSR_Cost_Business_Group_ION__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_ION__c ||
		opportunity.PSR_Cost_Business_Group_MN__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_MN__c ||
		opportunity.PSR_Cost_BG_NEN__c != optyOldMap.get(opportunity.Id).PSR_Cost_BG_NEN__c ||
		opportunity.PSR_Cost_Business_Group_AA__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_AA__c)
	*/
	// Additional changes done by HCL on 09-03-2020 to fix LoA Level Pre-Sales blank issue
	
	if( opportunity.PSR_Cost_Business_Group_FN__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_FN__c ||
		opportunity.PSR_Cost_Business_Group_GS__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_GS__c ||
		//opportunity.PSR_Cost_Business_Group_ION__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_ION__c ||
		(opportunity.PSR_Cost_BU_ION_IPR_DNI__c != optyOldMap.get(opportunity.Id).PSR_Cost_BU_ION_IPR_DNI__c ||
		opportunity.PSR_Cost_BU_ION_IPR_MPC__c != optyOldMap.get(opportunity.Id).PSR_Cost_BU_ION_IPR_MPC__c ||
		opportunity.PSR_Cost_BU_ION_IPR_Nuage__c != optyOldMap.get(opportunity.Id).PSR_Cost_BU_ION_IPR_Nuage__c ||
		opportunity.PSR_Cost_Business_Unit_ION_IPR__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Unit_ION_IPR__c ||
		opportunity.PSR_Cost_BU_ION_IPR_Services__c != optyOldMap.get(opportunity.Id).PSR_Cost_BU_ION_IPR_Services__c ||
		opportunity.PSR_Cost_Business_Unit_ION_Optics__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Unit_ION_Optics__c ||
		opportunity.PSR_Cost_BU_ION_Optics_Services__c != optyOldMap.get(opportunity.Id).PSR_Cost_BU_ION_Optics_Services__c 
		) ||
		opportunity.PSR_Cost_Business_Group_MN__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_MN__c ||
		//opportunity.PSR_Cost_BG_NEN__c != optyOldMap.get(opportunity.Id).PSR_Cost_BG_NEN__c ||
		(opportunity.PSR_Cost_BU_NE_IoT__c != optyOldMap.get(opportunity.Id).PSR_Cost_BU_NE_IoT__c ||
		 opportunity.PSR_Cost_BU_NE_DAaaS__c != optyOldMap.get(opportunity.Id).PSR_Cost_BU_NE_DAaaS__c ||
		 opportunity.PSR_Cost_BU_NE_EOP__c != optyOldMap.get(opportunity.Id).PSR_Cost_BU_NE_EOP__c 
		) ||
		opportunity.PSR_Cost_Business_Group_AA__c != optyOldMap.get(opportunity.Id).PSR_Cost_Business_Group_AA__c)
	{
		string orgL4 = opportunity.org_l4__c;
		if(opportunity.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.RISK_ORDER))
		{
			if(opportunity.Org_L3__c == globalConstants.Nokia_Enterprise)
			{
				for(Map_Enterprise_MUs_and_Market__c mapobj : mapL5_L4)
				{
		if(mapobj.Enterprise_MU__c == opportunity.org_l5__c)
		{ orgl4 = mapobj.Market__c; }
				}
			}
			for(PSRO_Market_Threshold__c BGVal : ThresholdList)
			{
				Decimal BG_cost = 0;
				Decimal current_value = 0;
				if(BGVal.Market__c == orgL4)
				{
		Boolean checkVal = PSRO_Calculate_BG_Cost.returnexceed(Opportunity,datedrate,BGVal);
			if(checkVal == true)
				exceed = true;
				}
			}
		}
		system.debug('Exceed?'+Exceed);
		if(exceed == true && opportunity.recordTypeId == PSR_EditRecordTypeID)
		{
			opportunity.PSR_LoA_Level__c = GlobalConstants.LOA_Level; //A
			opportunity.PSR_GateClass__c = GlobalConstants.Gate_R4;
		}
		else if(opportunity.recordTypeId == PSR_EditRecordTypeID)
		{ 
						preSalesOptyMapForLoAlevel.put(opportunity.PSR_Reference_Opportunity__c,opportunity); 
					}
	}
			}
			
			if(!preSalesOptyMapForLoAlevel.isEmpty()){
	system.debug('In LoA level Check');
	salesOptyWithApprovalDateMap = new Map <Id, Opportunity>([select id, G4_Approval_Date__c from Opportunity where id in : preSalesOptyMapForLoAlevel.keySet()]);
	if(!salesOptyWithApprovalDateMap.isEmpty()){
		for(Opportunity opportunity : preSalesOptyMapForLoAlevel.Values()){
			if(salesOptyWithApprovalDateMap.containsKey(opportunity.PSR_Reference_Opportunity__c) &&
		 		opportunity.PSR_Pre_Sales_Risk_Opportunity_Type__c.equalsIgnoreCase(GlobalConstants.RISK_ORDER) &&
			salesOptyWithApprovalDateMap.get(opportunity.PSR_Reference_Opportunity__c).G4_Approval_Date__c == null){
				opportunity.PSR_LoA_Level__c = GlobalConstants.LOA_Level; //A
				opportunity.PSR_GateClass__c = GlobalConstants.Gate_R4;
			}
			else
			{
				System.debug('Existing Logic for LoA level');
				List<PSR_Gate_Classification_Logic__c> objList;
				objList = PSR_Gate_Classification_Logic__c.getall().values();
				objList.sort(); 
				for(integer i = 0; i< objList.size(); i++){
								if(objList[i].BU_Value__c == null){
									if(opportunity.PSR_Pre_Sales_Risk_Opportunity_Type__c == objList[i].Opportunity_Type__c && 
										opportunity.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c == objList[i].Opportunity_Sub_Type__c &&
											opportunity.PSR_Lead_Business_Group__c == objList[i].BG_Value__c &&
												buValue != GlobalConstants.NEEOP &&
												   ((opportunity.PSR_Total_Cost_In_Euro__c >= objList[i].Min_Value__c && 
														 opportunity.PSR_Total_Cost_In_Euro__c <= objList[i].Max_Value__c)  || 
															(opportunity.PSR_Total_Cost_In_Euro__c >= objList[i].Max_Value__c && objList[i].Min_Value__c == null))){
										opportunity.PSR_GateClass__c = objList[i].Gate_Classification__c;
										opportunity.PSR_LoA_Level__c = objList[i].LOA_Level__c;
									}
								} else {
									//NEN specification
									if(opportunity.PSR_Pre_Sales_Risk_Opportunity_Type__c == objList[i].Opportunity_Type__c && 
										  	opportunity.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c == objList[i].Opportunity_Sub_Type__c &&
			opportunity.PSR_Lead_Business_Group__c == objList[i].BG_Value__c && 
												buValue.contains(objList[i].BU_Value__c) && 
													((opportunity.PSR_Total_Cost_In_Euro__c >= objList[i].Min_Value__c && 
														  	opportunity.PSR_Total_Cost_In_Euro__c <= objList[i].Max_Value__c)  || 
														 		(opportunity.PSR_Total_Cost_In_Euro__c >= objList[i].Max_Value__c && 
																 	objList[i].Min_Value__c == null))){
										opportunity.PSR_GateClass__c = objList[i].Gate_Classification__c;
										opportunity.PSR_LoA_Level__c = objList[i].LOA_Level__c;
			}
		}
							}
			}
		}
	}
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.UPDATEPROBABILTYOFPSROPTYSBEFOREINSERT);
		}

	}

	/***************
Requirement Details:  Pre-Sales:Sprint 12: Req#3457, Sprint -19 : Req#5561 + COE F2033
Method Name: psroUpdateThreshold
Description: Update current value in Threshold object.
Parameters: List<Opportunity> opptyList, Map<Id,Opportunity> optyOldMap
**************/
	public static void psroUpdateThreshold(List<Opportunity>opptyList, Map<Id,Opportunity> optyOldMap)
	{
		Set<Id> Opptyset = new set<id>();
		Map<Id, PSRO_Market_Threshold__c> Update_current_Value = new Map<Id, PSRO_Market_Threshold__c>();
		List<PSRO_Market_Threshold__c> sendmail_List = new List<PSRO_Market_Threshold__c>();

		try
		{

			Oppcurrency = new Set<String>();
			set<String> Marketset = new set<String>();
			set<String> MUset = new set<String>();
			Map<string, Decimal> cost_L4_BG = new Map<String, Decimal>();
			List<Map_Enterprise_MUs_and_Market__c> mapL5_L4 = Map_Enterprise_MUs_and_Market__c.getAll().values();
			datedrate = new Map<String, Decimal>();
			Date todayDate = Date.Today();
			for (Opportunity newrec: opptyList)
			{

	for(Map_Enterprise_MUs_and_Market__c mapobj : mapL5_L4)
	{
		IF(newrec.Org_L3__c == GlobalConstants.Nokia_Enterprise && mapobj.Enterprise_MU__c == newrec.org_l5__c)
		{
			Marketset.add(mapobj.Market__c);
			MUset.add(mapobj.Enterprise_MU__c);
		}
		else if(mapobj.Market__c == newrec.org_l4__c)
		{
			Marketset.add(mapobj.Market__c);
			MUset.add(mapobj.Enterprise_MU__c);
		}
	}

	if(newrec.stagename == GlobalConstants.IN_EXECUTION || optyOldMap.get(newrec.id).stagename == GlobalConstants.IN_EXECUTION)
		Opptyset.add(newrec.id);
			}

			for(Map_Enterprise_MUs_and_Market__c mapobj : mapL5_L4)
			{
	if(Marketset.contains(mapobj.Market__c)){
		MUset.add(mapobj.Enterprise_MU__c);
	}
			}

			System.debug('Oppset:'+opptyset+'Org_L4__c:'+MArketSet);
			If(!opptyset.isEmpty())
			{
	List<Opportunity> AllOpptyList = [SELECT id, PSR_Cost_Business_Group_FN__c, PSR_Cost_Business_Group_GS__c, PSR_Cost_Business_Group_ION__c, PSR_Cost_Business_Group_MN__c, PSR_Cost_BG_NEN__c, PSR_Cost_Business_Group_AA__c,
			  Org_L3__c,Org_L4__c,Org_L5__c,CurrencyIsoCode FROM Opportunity where (recordTypeId = :PSR_EditRecordTypeID OR recordTypeId = :PSR_ReadOnlyRecordTypeID) AND PSR_Pre_Sales_Risk_Opportunity_Type__c = 'Risk Order' AND (org_l4__c in :MarketSet OR org_l5__c in :MUset) AND (stagename = 'In Execution' OR ID in :opptyset)];

	List<PSRO_Market_Threshold__c> ThresholdList = [Select Id, Market__c, Threshold_Value__c,value_exceeded__c, current_value__c, Business_Group__c
				from PSRO_Market_Threshold__c where Market__c in :MarketSet];
	for (Opportunity newrec: AllopptyList)
	{
		Oppcurrency.add(newrec.CurrencyIsoCode);
	}
	if(!AllopptyList.isEmpty())
	{
		for (Dated_Exchange_Rates__c ratecollect:  [select Id, CurrencyIsoCode, Exchange_Rate__c, Start_Date__c
				from Dated_Exchange_Rates__c where CurrencyIsoCode =: Oppcurrency
				AND Start_Date__c<=: todayDate
				Order By Start_Date__c ASC LIMIT: Limits.getLimitQueryRows()])
		{
			datedrate.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
		}
	}

	for(Opportunity opportunity : AllopptyList)
	{
		String Stage ='';
		If(optyoldmap.containskey(opportunity.Id))
		{
			stage = optyOldMap.get(opportunity.Id).stagename;
		}
		System.debug('Stage_Oppty:'+stage);
		if(stage != 'In Execution')
		{
			string orgL4 = opportunity.org_l4__c;
			If(opportunity.Org_L3__c == GlobalConstants.Nokia_Enterprise)
			{
				for(Map_Enterprise_MUs_and_Market__c mapobj : mapL5_L4)
				{
		If(mapobj.Enterprise_MU__c == opportunity.org_l5__c)
		{ orgl4 = mapobj.Market__c; }
				}
			}
			system.debug('Opportunity:'+opportunity);

			for(PSRO_Market_Threshold__c BGVal : ThresholdList)
			{
				Decimal BG_cost = 0;
				If(BGVal.Market__c == orgL4)
				{
		If(BGVal.Business_Group__c ==  GlobalConstants.Lead_BG_NSW && opportunity.PSR_Cost_Business_Group_AA__c != null)
		{
			BG_cost = (returnValueOfField(opportunity.PSR_Cost_Business_Group_AA__c)).divide(datedrate.get(opportunity.CurrencyIsoCode),2,System.RoundingMode.HALF_UP);
			if(cost_L4_BG.containsKey(orgL4+BGVal.Business_Group__c))
			{
				BG_cost = cost_L4_BG.get(orgL4+BGVal.Business_Group__c) + BG_cost;
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			else
			{
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			BGVal.current_value__c = BG_cost;
			update_current_value.put(BGVal.Id,BGVal);
		}
		If(BGVal.Business_Group__c ==  GlobalConstants.Lead_BG_FN && opportunity.PSR_Cost_Business_Group_FN__c != null)
		{
			BG_cost = (returnValueOfField(opportunity.PSR_Cost_Business_Group_FN__c)).divide(datedrate.get(opportunity.CurrencyIsoCode),2,System.RoundingMode.HALF_UP);
			if(cost_L4_BG.containsKey(orgL4+BGVal.Business_Group__c))
			{
				BG_cost = cost_L4_BG.get(orgL4+BGVal.Business_Group__c) + BG_cost;
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			else
			{
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			BGVal.current_value__c = BG_cost;
			update_current_value.put(BGVal.Id,BGVal);
		}
		If(BGVal.Business_Group__c ==  GlobalConstants.Lead_BG_ION && opportunity.PSR_Cost_Business_Group_ION__c != null)
		{
			BG_cost = (returnValueOfField(opportunity.PSR_Cost_Business_Group_ION__c)).divide(datedrate.get(opportunity.CurrencyIsoCode),2,System.RoundingMode.HALF_UP);
			if(cost_L4_BG.containsKey(orgL4+BGVal.Business_Group__c))
			{
				BG_cost = cost_L4_BG.get(orgL4+BGVal.Business_Group__c) + BG_cost;
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			else
			{
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			BGVal.current_value__c = BG_cost;
			update_current_value.put(BGVal.Id,BGVal);
		}

		If(BGVal.Business_Group__c ==  GlobalConstants.Lead_BG_MN && opportunity.PSR_Cost_Business_Group_MN__c != null)
		{
			BG_cost = (returnValueOfField(opportunity.PSR_Cost_Business_Group_MN__c)).divide(datedrate.get(opportunity.CurrencyIsoCode),2,System.RoundingMode.HALF_UP);
			if(cost_L4_BG.containsKey(orgL4+BGVal.Business_Group__c))
			{
				BG_cost = cost_L4_BG.get(orgL4+BGVal.Business_Group__c) + BG_cost;
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			else
			{
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
				update_current_value.put(BGVal.Id,BGVal);
			}
			BGVal.current_value__c = BG_cost;
			update_current_value.put(BGVal.Id,BGVal);
		}
		If(BGVal.Business_Group__c ==  GlobalConstants.Lead_BG_GS && opportunity.PSR_Cost_Business_Group_GS__c != null)
		{
			BG_cost = (returnValueOfField(opportunity.PSR_Cost_Business_Group_GS__c)).divide(datedrate.get(opportunity.CurrencyIsoCode),2,System.RoundingMode.HALF_UP);
			if(cost_L4_BG.containsKey(orgL4+BGVal.Business_Group__c))
			{
				BG_cost = cost_L4_BG.get(orgL4+BGVal.Business_Group__c) + BG_cost;
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			else
			{
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			BGVal.current_value__c = BG_cost;
			update_current_value.put(BGVal.Id,BGVal);
		}
		If(BGVal.Business_Group__c ==  GlobalConstants.Lead_BG_NEN && opportunity.PSR_Cost_BG_NEN__c != null)
		{
			BG_cost = (returnValueOfField(opportunity.PSR_Cost_BG_NEN__c)).divide(datedrate.get(opportunity.CurrencyIsoCode),2,System.RoundingMode.HALF_UP);
			if(cost_L4_BG.containsKey(orgL4+BGVal.Business_Group__c))
			{
				BG_cost = cost_L4_BG.get(orgL4+BGVal.Business_Group__c) + BG_cost;
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			else
			{
				cost_L4_BG.put(orgL4+BGVal.Business_Group__c,BG_cost);
			}
			BGVal.current_value__c = BG_cost;
			update_current_value.put(BGVal.Id,BGVal);
		}

				}
			}
		}
	}
	List<PSRO_Market_Threshold__c> calcurrentvalue = [Select Id, Market__c, Threshold_Value__c, current_value__c,value_exceeded__c, Business_Group__c
				  from PSRO_Market_Threshold__c where Market__c in :Marketset];
	List<PSRO_Market_Threshold__c> UpdateTHList = new List<PSRO_Market_Threshold__c>();
	system.debug('Current Value Update:'+update_current_value);
	if(!update_current_value.isEmpty())
	{
		for(PSRO_Market_Threshold__c clearval: calcurrentvalue)
		{

			If(update_current_value.containskey(clearval.Id))
			{
				PSRO_Market_Threshold__c updateval = update_current_value.get(clearval.Id);
				system.debug('Update Value:'+update_current_value.get(clearval.Id));

				IF(updateval.current_value__c > updateval.Threshold_Value__c && updateval.value_exceeded__c == false)
				{
		sendmail_list.add(updateval);
		updateval.value_exceeded__c = true;
				}
				else if(updateval.current_value__c < updateval.Threshold_Value__c && updateval.value_exceeded__c == true)
				{
		updateval.value_exceeded__c = false;
				}
				UpdateTHList.add(updateval);
			}
			else
			{
				clearval.Current_value__c = 0;
				clearval.value_exceeded__c = false;
				UpdateTHList.add(clearval);
			}
		}
		database.update(UpdateTHList);
	}
	else
	{
		for(PSRO_Market_Threshold__c clearval: calcurrentvalue)
		{
			clearval.current_value__c = 0;
			clearval.value_exceeded__c = false;
			UpdateTHList.add(clearval);
		}
		database.update(updatethlist);
	}
	if(!sendmail_list.isEmpty())
	{
		// PSRO_Calculate_BG_Cost triggermail = new PSRO_Calculate_BG_Cost();
		PSRO_Calculate_BG_Cost.psroThresholdMail(sendmail_List);
	}
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.UpdateValueinThresholdObject);
		}
	}
	/***************
*Requirement Details:  Pre-Sales:Sprint 8: Req#2503
*Method Name: NotifyOpportunityTeamMembers
*Description: When Opportunity is submitted for approval,rejected,approved then notify OTMs via chatter feed
*Parameters: List<Opportunity> opptyList
**************/
	public static void notifyOTMsAndApprovalContributorsWhenReset(List<Opportunity>opportunitiesList, Map<Id, Opportunity>optyOldMap){

		mapOppIdRelatedUsers = new Map<Id, Set<Id>>();
		mapOptyIdAndOTMs = new Map<Id, Opportunity>();
		mapOptyIdAndAccountId = new Map<Id, Id>();
		optyIdAndAccountName = new Map<Id, String>();

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
	for (OpportunityTeamMember opportunityTeamMember: [SELECT UserId, OpportunityId
				   FROM OpportunityTeamMember
				   WHERE OpportunityId IN: mapOptyIdAndOTMs.keySet()
				   LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]) {
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
	{ if (!mapOppIdRelatedUsers.containsKey(ReqInfo.Apttus_Approval__Object_Id__c )) {
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
			integer NumberOfPost = (integer)((decimal) mapOppIdRelatedUsers.get(OppId).size() / iNumber).round(System.RoundingMode.UP);
			integer StartLoop = 0;
			system.debug('NumberOfPost >>>'+NumberOfPost );
			//for (integer i = 0; i<NumberOfPost; i++)
			{
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
				if (!test.isRunningTest()) {}
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
*Method Name: updateProbabiltyOfPSROptysBeforeInsert
*Description: Custom code to populate Parent Oppty Probability to new PSR oppty
*Requirement: PreSales : 5072
*Parameters: optyList
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public static void updateProbabiltyOfPSROptysBeforeInsertFeature(List<Opportunity>optyList) {

		Map<Id, Opportunity> preSalesOptyMapForProbabilty = new Map<Id, Opportunity>();
		Map <Id, Opportunity> salesOptyWithProbabilityMap = new Map <Id, Opportunity>();
		try{
			for(Opportunity opportunity : optyList){
	if(opportunity.recordTypeId == PSR_EditRecordTypeID ){
		preSalesOptyMapForProbabilty.put(opportunity.PSR_Reference_Opportunity__c,opportunity);
	}
			}

			if(!preSalesOptyMapForProbabilty.isEmpty()){
	salesOptyWithProbabilityMap = new Map <Id, Opportunity>
		([select id, Probability from Opportunity where id in : preSalesOptyMapForProbabilty.keySet()]);
	if(!salesOptyWithProbabilityMap.isEmpty()){
		for(Opportunity opty : preSalesOptyMapForProbabilty.Values())		{
			if(salesOptyWithProbabilityMap.containsKey(opty.PSR_Reference_Opportunity__c)){
				opty.Probability = salesOptyWithProbabilityMap.get(opty.PSR_Reference_Opportunity__c).Probability;
			}
		}
	}
			}

		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.UPDATEPROBABILTYOFPSROPTYSBEFOREINSERT);
		}

	}

	/*****************************
*Method Name: updateProbabiltyOfPSROptysBeforeUpdate
*Description:  Custom code to retain PSR Oppty Probability if PSR oppty sales stage get changes
*Requirement: PreSales : 5072
*Parameters: optyList , opportunityOldMap
*Test coverage from: OpportunityTriggerHelperTest
*******************************/
	public static void updateProbabiltyOfPSROptysBeforeUpdateFeature(List<Opportunity>optyList , Map<Id, Opportunity> optyOldMap) {
		system.debug('updateProbabiltyOfPSROptysBeforeUpdateFeature>>');
		Map<Id, Opportunity> preSalesOptyMapForProbabilty = new Map<Id, Opportunity>();
		Map <Id, Opportunity> salesOptyWithProbabilityMap = new Map <Id, Opportunity>();
		try{
			for(Opportunity opportunity : optyList){
	if(optyOldMap.get(opportunity.Id).stagename != opportunity.stagename){
		preSalesOptyMapForProbabilty.put(opportunity.PSR_Reference_Opportunity__c,opportunity);
		system.debug('updateProbabiltyOfPSROptysBeforeUpdateFeature>>preSalesOptyMapForProbabilty>>'+preSalesOptyMapForProbabilty);
	}
			}

			if(!preSalesOptyMapForProbabilty.isEmpty()){
	salesOptyWithProbabilityMap = new Map <Id, Opportunity>
		([select id, Probability from Opportunity where id in : preSalesOptyMapForProbabilty.keySet()]);
	system.debug('salesOptyWithProbabilityMap>>>'+salesOptyWithProbabilityMap);
	if(!salesOptyWithProbabilityMap.isEmpty()){
		for(Opportunity opty : preSalesOptyMapForProbabilty.Values())		{
			system.debug('opty>>>'+opty);
			if(salesOptyWithProbabilityMap.containsKey(opty.PSR_Reference_Opportunity__c)){
				system.debug('salesOptyWithProbabilityMap>>'+salesOptyWithProbabilityMap);
				opty.Probability = salesOptyWithProbabilityMap.get(opty.PSR_Reference_Opportunity__c).Probability;
				system.debug('updateProbabiltyOfPSROptysBeforeUpdateFeature>>opty.Probability>>'+opty.Probability);
			}
		}
	}

			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.OPPORTUNITYTRIGGERHELPER_PRESALES, GlobalConstants.UPDATEPROBABILTYOFPSROPTYSBEFOREUPDATE);
		}
	}
}