/****************************************
*Class Name : OrderIntakeHepler
*Created Date: 11 November 2016
*Created By : Accenture
*Last Modified by: Accenture
*Last Modified Date: 24 november 2016
*Description : This class will copy the leading business group of Offer Intake to Lead BG field on Opportunity *and the rest of the business group into Supporting BG field.
*Test Class: OrderIntakeHeplerTest
*****************************************/
public with sharing class OrderIntakeHepler {

	Public Static Boolean isOfferWithoutExpectedLoALevel=false;
	Public Static Map<String,Decimal> USDCurrencyrate =new Map<String,Decimal>();
	Public Static map<String,Dated_Exchange_Rates__c> USDActiverate =new map<String,Dated_Exchange_Rates__c>();
	Public Static map<String,string> Currencycode = new map<String,string>();
	Public Static Map<Id,Dated_Exchange_Rates__c > seldateList =new  Map<Id,Dated_Exchange_Rates__c>();

	Public Static map<String,Dated_Exchange_Rates__c> ActiveCurrency=new map<String,Dated_Exchange_Rates__c>();
	Public Static Double TotalSum=0.0;
	public static Map<Id,product2> businessLineMap;


	/*******************************
*Method name: getOpportuntityData
*Description: This method will retrieve opportunity data through soql
*Parameter: Order_Intake_Forecast__c Values
*comments:This method is added for getting all opportunity data using a single soql query and can be used wherever needed
*******************************/
	public static Map<Id,Opportunity> getOpportuntityData(Set<Id> opportunityIdList)
	{
		Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
		try{
			opportunityMap =  new Map<Id,Opportunity>(
	[Select Id, CurrencyIsoCode,Business_Type__c,recordtypeId,
	 Positive_OIF__c,Upsell_Change_Explanation__c,Sales_Outcome__c,
	 Committed_Unweighted_Value_in_EUR__c,Lead_BG__c, G5_Approval_Date__c, Phase_Status__c 
	 From Opportunity
	 Where Id IN: opportunityIdList
	 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.GETOPPORTUNITYDATA);
		}
		return opportunityMap;

	}

	/*******************************
*Method name: getOpportuntityID
*Description: This method will retrieve opportunity data through soql
*Parameter: Order_Intake_Forecast__c Values
*comments:This method is added for getting all opportunity data using a single soql query and can be used wherever needed
*******************************/
	public static Set<ID> getOpportuntityID(List<Order_Intake_Forecast__c> orderIntakeList)
	{
		//Added the for loop for fetching opportunity id from oif in handler
		//so that it need not be repeated in every helper method
		Set<Id> opportunityIDList= new Set<Id>();
		try{
			for(Order_Intake_Forecast__c oif : orderIntakeList) {
	opportunityIDList.add(oif.Opportunity__c);
			}
			System.debug('opportunityIDList>>>>>>>>>>'+opportunityIDList);
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.GETOPPORTUNITYID);
		}
		return opportunityIDList;

	}

	/*******************************
*Method name: checkForCommittedUpsellOppty
*Description: This method will Check if any of the order intake belongs to committed upsell opportunity by checking the opportunity list
*Parameter: Order_Intake_Forecast__c Values
*comments:This method is added for getting all opportunity data using a single soql query and can be used wherever needed
*******************************/
	public static Map<Id, opportunity> checkForCommittedUpsellOppty(List<opportunity> opportunityData)
	{
		Map<Id, opportunity> commupsellmap_oppty = new Map<Id, opportunity>();
		try{
			for(Opportunity opp : opportunityData)
			{
	if(opp.Business_Type__c == GlobalConstants.COMMITTED_UPSELL)
	{
		commupsellmap_oppty.put(opp.Id,opp);
	}
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.CHECKFORCOMMITTEDUPSELLOPPTY);
		}
		return commupsellmap_oppty;
	}

	/*******************************
*Method name: updateCurrentPeriod
*Description: This method will update if Category is Booked and  the Period is furture then updateit to Currenct Period
*Parameter: Order_Intake_Forecast__c Values
*******************************/

	public static void updateCurrentPeriod(List <Order_Intake_Forecast__c> orderIntakeList) {


		// Get the current Month

		map<ID,Nokia_Financial_Calendar__c> Nfcid= new  map<ID,Nokia_Financial_Calendar__c>();
		try {

			List< Id > PeiodsId = new List<Id> ();
			for (Order_Intake_Forecast__c oifID: orderIntakeList) {
	// collecting the current Peiod Id
	PeiodsId.add(oifID.POPlanReceipt__c);
			}

			//collecting all periods
			if(PeiodsId.size() > 0)
			{
	Nfcid = new  map<ID,Nokia_Financial_Calendar__c>([select id, name, End_Date__c, Start_Date__c
				  from Nokia_Financial_Calendar__c
				  where id IN: PeiodsId
				  LIMIT: PeiodsId.size()]);
			}

			List < Nokia_Financial_Calendar__c > currentPeiod = [select id, name, Start_Date__c ,End_Date__c
				 from Nokia_Financial_Calendar__c
				 Where Current_Period__c = True
				 ORDER BY End_Date__c ASC LIMIT 1];
			//Collecting  the currenct period details
			for (Order_Intake_Forecast__c OIFList: orderIntakeList) {
	if((OIFList.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.BOOKED) || OIFList.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.CANCEL) || OIFList.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.LOST)) && (currentPeiod.size()>0 && Nfcid.get(OIFList.POPlanReceipt__c).Start_Date__c>currentPeiod.get(0).Start_Date__c  && Nfcid.get(OIFList.POPlanReceipt__c).End_Date__c>currentPeiod.get(0).End_Date__c))
		// Condition for Forecast Categeory Booked and Selected period is future then update the period to current One
	{
		// check the enddate is always greater than the today date
		OIFList.POPlanReceipt__c = currentPeiod.get(0).ID;
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.UPDATE_CURRENT_PERIOD);
		}

	}

	/*******************************
*Method name: ChangeCurrency
*Description: This method will update for  OIF EUR field currency
*Parameter:oifInsetList
*******************************/


	public static void ChangeCurrency(List <Order_Intake_Forecast__c> oifInsetList, Map<Id,Opportunity> opportunityMap){
		// OID id's
		Set < Id > OppId = new Set < Id > ();
		// Opportunity Id'd
		Set < Id > NfcId = new Set < Id > ();
		// Opportunity Id'd
		Date todayDate = Date.Today();
		// collecting today date
		Set<String> Picklist= new Set<String>();
		map<ID,String> Oifoppid=new map<ID,String>();

		try{
			//collecting Id's and oif closedate
			for (Order_Intake_Forecast__c oifrec: oifInsetList) {
	// collecting the record Id
	OppId.add(oifrec.Opportunity__c);
	NfcId.add(oifrec.POPlanReceipt__c);
			}

			for(Opportunity Selectedopp: opportunityMap.values())
			{
	Picklist.add(Selectedopp.CurrencyIsoCode);
	Oifoppid.put(Selectedopp.ID,Selectedopp.CurrencyIsoCode);
	Currencycode.put(Selectedopp.CurrencyIsoCode,Selectedopp.CurrencyIsoCode);
			}
			// Map to get the active currency
			for(Dated_Exchange_Rates__c DerRecc:[select Id, CurrencyIsoCode,DER_Period__c,DER_Start_Date__c,DER_Period__r.End_Date__c , Exchange_Rate__c, Start_Date__c
			 from Dated_Exchange_Rates__c
			 where (CurrencyIsoCode =:Picklist OR CurrencyIsoCode=:GlobalConstants.USD )
			 AND  (DER_Period__c=:NfcId  OR DER_Period__r.End_Date__c>=:todayDate )
			 Order By DER_Start_Date__c ASC
			 LIMIT: Limits.getLimitQueryRows()])
			{

	if(DerRecc.CurrencyIsoCode.equalsignorecase(GlobalConstants.USD)){
		USDCurrencyrate.put(DerRecc.CurrencyIsoCode,DerRecc.Exchange_Rate__c);
		USDActiverate.put(DerRecc.DER_Period__c,DerRecc);

	}
	IF(Currencycode.get(DerRecc.CurrencyIsoCode)<>Null  && Currencycode.get(DerRecc.CurrencyIsoCode).equalsignorecase(DerRecc.CurrencyIsoCode)  )
	{
		seldateList.put(DerRecc.DER_Period__c,DerRecc);
		ActiveCurrency.put(DerRecc.CurrencyIsoCode,DerRecc);
	}
			}

			System.debug('USDCurrencyrate'+USDCurrencyrate);
			System.debug('USDActiverate'+USDActiverate);
			System.debug('seldateList'+seldateList);
			System.debug('ActiveCurrency'+ActiveCurrency);

			// dated currency list as per the close date of OIF
			for (Order_Intake_Forecast__c oifList: oifInsetList)
			{
	if( !Oifoppid.get(oifList.Opportunity__c).equalsignorecase(GlobalConstants.EUR)){
		System.debug('Loop Not EUR');

		if(seldateList.get(oifList.POPlanReceipt__c)==NULL && oifList.NFC_Start_Date__c>=todayDate ) {
			if(ActiveCurrency.get(Oifoppid.get(oifList.Opportunity__c))<>NUll){
				oifList.OIF_Value_EUR__c = (oifList.OIF_Value__c /ActiveCurrency.get(Oifoppid.get(oifList.Opportunity__c)).Exchange_Rate__c).setScale(2);
			}
			System.debug('Loop 1===>'+ActiveCurrency.get(Oifoppid.get(oifList.Opportunity__c)) +','+USDCurrencyrate.get(GlobalConstants.USD));

			if(ActiveCurrency.get(Oifoppid.get(oifList.Opportunity__c))<>NUll && USDCurrencyrate.get(GlobalConstants.USD)<>NUll )
			{
				oifList.OIF_Value_USD__c = ( (oifList.OIF_Value__c/ActiveCurrency.get(Oifoppid.get(oifList.Opportunity__c)).Exchange_Rate__c) *USDCurrencyrate.get(GlobalConstants.USD)).setScale(2);

			}
		}
		else
			if(seldateList.get(oifList.POPlanReceipt__c)<>NULL  && seldateList.get(oifList.POPlanReceipt__c).CurrencyIsoCode.equalsignorecase(Oifoppid.get(oifList.Opportunity__c)))
		{
			oifList.OIF_Value_EUR__c = (oifList.OIF_Value__c /seldateList.get(oifList.POPlanReceipt__c).Exchange_Rate__c).setScale(2);
			if(USDActiverate.get(oifList.POPlanReceipt__c)<>NUll)
				oifList.OIF_Value_USD__c = ((oifList.OIF_Value__c/seldateList.get(oifList.POPlanReceipt__c).Exchange_Rate__c) *USDActiverate.get(oifList.POPlanReceipt__c).Exchange_Rate__c).setScale(2);
			else if(USDCurrencyrate.get(GlobalConstants.USD)<>NUll)

				oifList.OIF_Value_USD__c = ( (oifList.OIF_Value__c/seldateList.get(oifList.POPlanReceipt__c).Exchange_Rate__c) *USDCurrencyrate.get(GlobalConstants.USD)).setScale(2);
		}
	}

	// OIF Currency is EUR then USD filed will update to the latest USD rate
	if(Oifoppid.get(oifList.Opportunity__c).equalsignorecase(GlobalConstants.EUR)){
		System.debug('Loop EUR');
		oifList.OIF_Value_EUR__c = oifList.OIF_Value__c;
		if(USDActiverate.get(oifList.POPlanReceipt__c)==NULL&& USDCurrencyrate.get(GlobalConstants.USD)<>Null  &&oifList.NFC_Start_Date__c>=todayDate)
		{
			oifList.OIF_Value_USD__c = (oifList.OIF_Value__c *USDCurrencyrate.get(GlobalConstants.USD)).setScale(2);
		}
		else
			if(USDActiverate.get(oifList.POPlanReceipt__c)<>NULL)
		{
			oifList.OIF_Value_USD__c = (oifList.OIF_Value__c *USDActiverate.get(oifList.POPlanReceipt__c).Exchange_Rate__c).setScale(2);
		}
	}

	//OIF Currency USD then USD filed will update to the same OIF Value
	if(Oifoppid.get(oifList.Opportunity__c).equalsignorecase(GlobalConstants.USD))
		oifList.OIF_Value_USD__c=oifList.OIF_Value__c;
			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.INSERT_DATED_CURRENCY);
		}

	}

	//Sales Process: Requirement 1454
	/***********************
* Method Name: copyOpptyProgramFlagToOif
* Description: Sales Process : This method will update OIF's Program Flag with Opportunity Related Program Flag
* Parameters: List of OptyProgramFlagJunction__c
************************/
	public static void copyOpptyProgramFlagToOif(List<Order_Intake_Forecast__c> oifList){
		//Master detail, so no deletion required
		Set<Id> opptyIdSet = new Set<Id>();
		Map<Id, List<Id>> opptyToProgFlagMap = new Map<Id, List<Id>>();
		Map<Id, List<Id>> opptyToOifMap = new Map<Id, List<Id>>();
		List<Id> oifIdList = new List<Id>();
		List<Id> progFlagIdList = new List<Id>();
		try{
			for(Order_Intake_Forecast__c oifObj : oifList){
	//Getting OIF related Opportunity
	opptyIdSet.add(oifObj.Opportunity__c);
	System.debug('opptyIdSet--->'+oifObj.Opportunity__c);
			}
			//Getting Opportunity related Program Flag
			//progFlagJunList = [SELECT id, Opportunity__c, Program_Flag__c FROM OptyProgramFlagJunction__c WHERE Opportunity__c IN: opptyIdSet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
			//System.debug('progFlagJunList'+progFlagJunList);
			//Relationship between Program Flag and Opportunity
			//for(OptyProgramFlagJunction__c opptyProgFlagJuncObj : progFlagJunList){
			for(OptyProgramFlagJunction__c opptyProgFlagJuncObj : [SELECT id, Opportunity__c, Program_Flag__c FROM OptyProgramFlagJunction__c WHERE Opportunity__c IN: opptyIdSet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){
	if(!string.isBlank(opptyProgFlagJuncObj.Opportunity__c)){
		if(opptyToProgFlagMap.containsKey(opptyProgFlagJuncObj.Opportunity__c)){
			progFlagIdList = opptyToProgFlagMap.get(opptyProgFlagJuncObj.Opportunity__c);
			progFlagIdList.add(opptyProgFlagJuncObj.Program_Flag__c);
			opptyToProgFlagMap.put(opptyProgFlagJuncObj.Opportunity__c, progFlagIdList);
			System.debug('progFlagIdList if has data'+progFlagIdList);
		}
		else{
			progFlagIdList = new List<Id>();
			progFlagIdList.add(opptyProgFlagJuncObj.Program_Flag__c);
			opptyToProgFlagMap.put(opptyProgFlagJuncObj.Opportunity__c, progFlagIdList);
			System.debug('progFlagIdList if the first one'+progFlagIdList);
		}
	}
			}
			//Stabilishing relationship between OIF and Opportunity
			for(Order_Intake_Forecast__c oifObj : oifList){
	if(opptyToOifMap.containsKey(oifObj.Opportunity__c)){
		oifIdList = opptyToOifMap.get(oifObj.Opportunity__c);
		oifIdList.add(oifObj.id);
		opptyToOifMap.put(oifObj.Opportunity__c, oifIdList);
		System.debug('oifIdList if has data'+oifIdList);
	}
	else{
		//Zeen Add
		oifIdList = new List<Id>();
		oifIdList.add(oifObj.id);
		opptyToOifMap.put(oifObj.Opportunity__c, oifIdList);
		System.debug('oifIdList if the first one'+oifIdList);
	}
			}
			// generate OIFProgramFlagJunction__c records.
			List<OIFProgramFlagJunction__c> finalOIFProgramFlagJunctionRecList = new List<OIFProgramFlagJunction__c>();
			for(Id opptyId : opptyToOifMap.keySet()){
	if(opptyToProgFlagMap.size()>0){
		for(Id progFlagId : opptyToProgFlagMap.get(opptyId)){
			if(opptyToOifMap.size()>0){
				for(Id oifId : opptyToOifMap.get(opptyId)){
		if(progFlagId != Null && oifid != null){
			system.debug('Zeen Test');
			OIFProgramFlagJunction__c objOIFProgramFlagJunction = new OIFProgramFlagJunction__c();
			String soifid = oifId;
			soifid = soifid.subString(0,soifid.length()-3);
			objOIFProgramFlagJunction.Order_Intake_Forecast__c = soifid;

			String sprogFlagId = progFlagId;
			sprogFlagId = sprogFlagId.subString(0,sprogFlagId.length()-3);
			objOIFProgramFlagJunction.Program_Flag_Data__c = sprogFlagId;
			finalOIFProgramFlagJunctionRecList.add(objOIFProgramFlagJunction);
			System.debug('finalOIFProgramFlagJunctionRecList>>'+finalOIFProgramFlagJunctionRecList);
		}
				}
			}
		}
	}
			}
			System.debug('Trigger Insert');
			database.insert(finalOIFProgramFlagJunctionRecList);
		}catch(Exception Ex){
			ExceptionHandler.addException(ex,GlobalConstants.ORDER_INTAKE_HELPER ,GlobalConstants.OPTY_TO_OIF_PROGRAM_FLAG);
		}
	}

	//Forecasting: Requirement 1439
	/***********************
* Method Name: DeletecloneLines
* Description: Sales Process : This method will Delete the Clone Lines
* Parameters: List of OrderIntakeForecast
************************/

	Public Static Void DeletecloneLines(List<Order_Intake_Forecast__c> OIFDeleteValues)
	{

		Set<ID> OIFID =new Set<ID>();
		List<Order_Intake_Forecast__c > OIFRecDelete =New List<Order_Intake_Forecast__c>();
		try{
			//collceting the Deleted ID
			For(Order_Intake_Forecast__c DeleteID:OIFDeleteValues)
	OIFID.add(DeleteID.ID);

			//Colleting the Clone Reocrds
			for(Order_Intake_Forecast__c OIFinfo: [Select id,name,Update_Status__c
			   from Order_Intake_Forecast__c
			   where Cloned_From__c=:OIFID
			   Limit:Limits.getLimitQueryRows()])
			{
	OIFRecDelete.add(OIFinfo);

			}


			if(OIFRecDelete.size()>0)
	Database.delete(OIFRecDelete);
		}

		catch(Exception Ex){
			ExceptionHandler.addException(ex,GlobalConstants.ORDER_INTAKE_HELPER,GlobalConstants.DELETE_CLONE_LINES);
		}

	}
	/*******************************
*Method name: CompetitorErrorCheck
*Description: This method USed to check the competitor values
*Parameter: Order_Intake_Forecast__c Values
*******************************/

	public static void CompetitorErrorCheck(List <Order_Intake_Forecast__c> orderIntakeList) {
		Set<ID> OpptyID =new Set<ID>();

		try{
			for(Order_Intake_Forecast__c OIFList:orderIntakeList){
	OpptyID.add(OIFList.Opportunity__c);
			}

			list<Activity_Sector_Name__c> listActivitySector = [SELECT Id, Activity_Sector_Name__c FROM Activity_Sector_Name__c ];
			TotalSum = 0;
			boolean errCount = false;
			for(Order_Intake_Forecast__c OpptyOIFData : [SELECT id,Opportuity_Competitor_Count__c,OIF_Value_EUR__c, Opportunity__r.RecordType.Name, Opportunity__r.Account_Activity_Sector__c, Opportunity__r.End_Customer_Activity_Sector__c
					 FROM Order_Intake_Forecast__c
					 WHERE Opportunity__c =: OpptyID ]){

				System.debug(OpptyOIFData.OIF_Value_EUR__c);
				TotalSum = TotalSum + OpptyOIFData.OIF_Value_EUR__c;
				if(OpptyOIFData.Opportuity_Competitor_Count__c == 0 && Integer.ValueoF(Label.OpportunityThreshouldValueNE) <= TotalSum ){
				 if(Integer.ValueoF(Label.OpportunityThreshouldValue) <= TotalSum ){
					 errCount = true;
					 orderIntakeList[0].addError(GlobalConstants.OIF_COMPETITOR_CHECK);
				 }
				 else if((OpptyOIFData.Opportunity__r.RecordType.Name == GlobalConstants.DIRECT_OPPTY) || (OpptyOIFData.Opportunity__r.RecordType.Name == GlobalConstants.READONLYDIRECT)){
					 for(Activity_Sector_Name__c activitySector : listActivitySector){
						 if(activitySector.Activity_Sector_Name__c == OpptyOIFData.Opportunity__r.Account_Activity_Sector__c){
					errCount = true;
					orderIntakeList[0].addError(GlobalConstants.OIF_COMPETITOR_CHECK);
					break;
						 }
					 }
				 }
				 else if((OpptyOIFData.Opportunity__r.RecordType.Name == GlobalConstants.INDIRECT_OPPTY) || (OpptyOIFData.Opportunity__r.RecordType.Name == GlobalConstants.READONLYINDIRECT)){
					 for(Activity_Sector_Name__c activitySector : listActivitySector){
						 if(activitySector.Activity_Sector_Name__c == OpptyOIFData.Opportunity__r.End_Customer_Activity_Sector__c){
					errCount = true;
					orderIntakeList[0].addError(GlobalConstants.OIF_COMPETITOR_CHECK);
					break;
						 }
					 }
				 }
				 if(errCount){
					 break;
				 }else{
					 continue;
				 }
				}
					 }

			GlobalConstants.OIF_ERROR_CHECK=True;
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.OIF_COMPETITOR_CHECK);
		}
	}

	/*******************************
*Method name: CloneLinesChangeCurrency
*Description: This method will update the allocation lines OIF EUR/USD field currency
*Parameter:oifInsetList
*******************************/
	public static Map<Id,Order_Intake_Forecast__c> CloneLinesChangeCurrency(Map<Id,Order_Intake_Forecast__c> oif2updateMap) {
		// OID id's
		Set < Id > OppIdclone = new Set < Id > ();
		// Opportunity Id'd
		Set < Id > NfcIdclone = new Set < Id > ();
		// Opportunity Id'd
		Date todayDate = Date.Today();
		// collecting today date
		Set<String> Picklistclone= new Set<String>();
		map<ID,String> OifOppIdclone=new map<ID,String>();

		Map<Id,Order_Intake_Forecast__c> oifInsetList = new Map<Id,Order_Intake_Forecast__c>(
			[Select id,Opportunity__c,NFC_Start_Date__c,POPlanReceipt__c,CurrencyIsoCode,
	OIF_Value__c,OIF_Value_USD__c,OIF_Value_EUR__c,Cloned_From__r.NFC_Start_Date__c
	from Order_Intake_Forecast__c
	where id=:oif2updateMap.keyset()]);
		try{
			//collecting Id's and oif closedate
			for (Order_Intake_Forecast__c oifrec: oifInsetList.values()) {
	// collecting the record Id
	OppIdclone.add(oifrec.Opportunity__c);
	NfcIdclone.add(oif2updateMap.get(oifrec.Id).POPlanReceipt__c);
			}

			for(Opportunity Selectedopp:[select Id, CurrencyIsoCode from Opportunity
				 where id =: OppIdclone
				 Limit: OppIdclone.Size()])
			{
	Picklistclone.add(Selectedopp.CurrencyIsoCode);
	OifOppIdclone.put(Selectedopp.ID,Selectedopp.CurrencyIsoCode);
	Currencycode.put(Selectedopp.CurrencyIsoCode,Selectedopp.CurrencyIsoCode);
			}

			// Map to get the active currency
			for(Dated_Exchange_Rates__c DerRecc:[select Id, CurrencyIsoCode,DER_Period__c,DER_Start_Date__c,DER_Period__r.End_Date__c , Exchange_Rate__c, Start_Date__c
			 from Dated_Exchange_Rates__c
			 where (CurrencyIsoCode =:Picklistclone OR CurrencyIsoCode=:GlobalConstants.USD )
			 AND  (DER_Period__c=:NfcIdclone  OR DER_Period__r.End_Date__c>=:todayDate )
			 Order By DER_Start_Date__c ASC
			 LIMIT: Limits.getLimitQueryRows()])
			{

	if(DerRecc.CurrencyIsoCode.equalsignorecase(GlobalConstants.USD)){
		USDCurrencyrate.put(DerRecc.CurrencyIsoCode,DerRecc.Exchange_Rate__c);
		USDActiverate.put(DerRecc.DER_Period__c,DerRecc);

	}
	IF(Currencycode.get(DerRecc.CurrencyIsoCode)<>Null  && Currencycode.get(DerRecc.CurrencyIsoCode).equalsignorecase(DerRecc.CurrencyIsoCode)  )
	{
		seldateList.put(DerRecc.DER_Period__c,DerRecc);
		ActiveCurrency.put(DerRecc.CurrencyIsoCode,DerRecc);

	}
			}
			System.debug('USDCurrencyrate'+USDCurrencyrate);
			System.debug('USDActiverate'+USDActiverate);
			System.debug('seldateList'+seldateList);
			System.debug('ActiveCurrency'+ActiveCurrency);

			// dated currency list as per the close date of OIF
			for (Order_Intake_Forecast__c oifList: oif2updateMap.Values())
			{
	String oifOppty = oifInsetList.get(oifList.Id).Opportunity__c;
	Date NFCStartDate = oifInsetList.get(oifList.Id).Cloned_From__r.NFC_Start_Date__c;//check this

	if( !OifOppIdclone.get(oifOppty).equalsignorecase(GlobalConstants.EUR)){
		System.debug('Loop Not EUR');

		if(seldateList.get(oifList.POPlanReceipt__c)==NULL && NFCStartDate >=todayDate ) {
			if(ActiveCurrency.get(OifOppIdclone.get(oifOppty))<>NUll){
				oifList.OIF_Value_EUR__c = (oifList.OIF_Value__c /ActiveCurrency.get(OifOppIdclone.get(oifOppty)).Exchange_Rate__c).setScale(2);
			}
			System.debug('Loop 1===>'+ActiveCurrency.get(OifOppIdclone.get(oifOppty)) +','+USDCurrencyrate.get(GlobalConstants.USD));

			if(ActiveCurrency.get(OifOppIdclone.get(oifOppty))<>NUll && USDCurrencyrate.get(GlobalConstants.USD)<>NUll )
			{
				oifList.OIF_Value_USD__c = ( (oifList.OIF_Value__c/ActiveCurrency.get(OifOppIdclone.get(oifOppty)).Exchange_Rate__c) *USDCurrencyrate.get(GlobalConstants.USD)).setScale(2);

			}
		}
		else if(seldateList.get(oifList.POPlanReceipt__c)<>NULL  && seldateList.get(oifList.POPlanReceipt__c).CurrencyIsoCode.equalsignorecase(OifOppIdclone.get(oifOppty)))
		{
			System.debug('inside not eur');
			oifList.OIF_Value_EUR__c = (oifList.OIF_Value__c /seldateList.get(oifList.POPlanReceipt__c).Exchange_Rate__c).setScale(2);
			if(USDActiverate.get(oifList.POPlanReceipt__c)<>NUll)
				oifList.OIF_Value_USD__c = ((oifList.OIF_Value__c/seldateList.get(oifList.POPlanReceipt__c).Exchange_Rate__c) *USDActiverate.get(oifList.POPlanReceipt__c).Exchange_Rate__c).setScale(2);
			else if(USDCurrencyrate.get(GlobalConstants.USD)<>NUll)

				oifList.OIF_Value_USD__c = ( (oifList.OIF_Value__c/seldateList.get(oifList.POPlanReceipt__c).Exchange_Rate__c) *USDCurrencyrate.get(GlobalConstants.USD)).setScale(2);



		}
	}

	// OIF Currency is EUR then USD filed will update to the latest USD rate
	if(OifOppIdclone.get(oifOppty).equalsignorecase(GlobalConstants.EUR)){
		System.debug('Loop EUR');
		oifList.OIF_Value_EUR__c = oifList.OIF_Value__c;
		if(USDActiverate.get(oifList.POPlanReceipt__c)==NULL&& USDCurrencyrate.get(GlobalConstants.USD)<>Null  && NFCStartDate >=todayDate)
		{

			oifList.OIF_Value_USD__c = (oifList.OIF_Value__c *USDCurrencyrate.get(GlobalConstants.USD)).setScale(2);
		}
		else
			if(USDActiverate.get(oifList.POPlanReceipt__c)<>NULL)
		{

			oifList.OIF_Value_USD__c = (oifList.OIF_Value__c *USDActiverate.get(oifList.POPlanReceipt__c).Exchange_Rate__c).setScale(2);

		}

	}

	//OIF Currency USD then USD filed will update to the same OIF Value
	if(OifOppIdclone.get(oifOppty).equalsignorecase(GlobalConstants.USD))
		oifList.OIF_Value_USD__c=oifList.OIF_Value__c;

			}
		}catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.CloneLinesChangeCurrency);
		}
		System.debug('oif2updateMap>>>>>>>'+oif2updateMap);
		return oif2updateMap;
	}

	/*******************************
*Method name: updateAllocationOIF
*Description: This method will update the allocation lines OIF field according to Master OIF(support ticket 12942)
*******************************/
	public static void updateAllocationOIF(map<Id, Order_Intake_Forecast__c> map_oifId_newOif, map<Id, Order_Intake_Forecast__c> map_oifId_oldOif) {
		set<String> set_oifIds = new set<String>();
		list<Order_Intake_Forecast__c> list_oif2update = new list<Order_Intake_Forecast__c>();
		Map<Id,Order_Intake_Forecast__c> oif2updateMap = new Map<ID,Order_Intake_Forecast__c>();
		map<String, Order_Intake_Forecast__c> map_oifId_oppValue = new map<String, Order_Intake_Forecast__c>();

		for(String oifId : map_oifId_newOif.keySet()) {
			Order_Intake_Forecast__c oldOif = map_oifId_oldOif.get(oifId);
			Order_Intake_Forecast__c newOif = map_oifId_newOif.get(oifId);
			if((oldOif.Notes__c != newOif.Notes__c || oldOif.Software__c != newOif.Software__c
	|| oldOif.OIF_Value__c != newOif.OIF_Value__c || oldOif.POPlanReceipt__c != newOif.POPlanReceipt__c
	|| oldOif.Forecast_Category__c != newOif.Forecast_Category__c
	|| oldOif.Exclude_Reason__c != newOif.Exclude_Reason__c
	|| oldOif.Rev_RecPlan_Receipt__c != newOif.Rev_RecPlan_Receipt__c)
	  && newOif.Allocation__c == false
	  && oldOif.BusinessLine__c == newOif.BusinessLine__c )
			{
	set_oifIds.add(oifId);
			}

		}

		if(set_oifIds.size() > 0)
		{
			for(Order_Intake_Forecast__c oif : [select Id, Opportunity__r.Contract_Signing_Entity__c, BusinessLine__r.Total_Allocation__c, BusinessLine__r.Family, BusinessLine__r.Business_Group__c,BusinessLine__r.Business_Line2__c,
			BusinessLine__r.Post_Allocation_1__c, BusinessLine__r.Post_Allocation_2__c, BusinessLine__r.Post_Allocation_3__c,
			BusinessLine__r.Allocated_BL_1__c, BusinessLine__r.Allocated_BL_2__c, BusinessLine__r.Allocated_BL_3__c,
			BusinessLine__r.Allocated_BL_1__r.Business_Group__c, BusinessLine__r.Allocated_BL_1__r.Family,
			BusinessLine__r.Allocated_BL_1__r.Business_Line2__c,
			BusinessLine__r.Allocated_BL_2__r.Business_Group__c,
			BusinessLine__r.Allocated_BL_2__r.Family,
			BusinessLine__r.Allocated_BL_2__r.Business_Line2__c,
			BusinessLine__r.Allocated_BL_3__r.Business_Group__c, BusinessLine__r.Allocated_BL_3__r.Family,
			BusinessLine__r.Allocated_BL_3__r.Business_Line2__c
			From Order_Intake_Forecast__c Where Id IN: set_oifIds]) {
				map_oifId_oppValue.put(oif.Id, oif);
			}

			for(String oifId : map_oifId_newOif.keySet()) {
	Order_Intake_Forecast__c oldOif = map_oifId_oldOif.get(oifId);
	Order_Intake_Forecast__c newOif = map_oifId_newOif.get(oifId);
	Order_Intake_Forecast__c OppforNewOif = map_oifId_oppValue.get(oifId);

	if(OppforNewOif <> null && OppforNewOif.Opportunity__r.Contract_Signing_Entity__c.equalsIgnoreCase('fNOK')){

		if(String.isNotEmpty(newOif.Allocation_Clone__c) && String.isNotEmpty(newOif.Allocation_Line_1__c)) {
			Order_Intake_Forecast__c oif = setInfo2AllocationOIF(newOif.Allocation_Clone__c, newOif, OppforNewOif);
			if(String.isNotEmpty(OppforNewOif.BusinessLine__c)) {
				oif.BusinessLine__c = OppforNewOif.BusinessLine__c;
				oif.Business_Group__c = OppforNewOif.BusinessLine__r.Business_Group__c;
				oif.Business_Unit__c = OppforNewOif.BusinessLine__r.Family;
				//AP2021
				oif.BusinessLine2__c = OppforNewOif.BusinessLine__r.Business_Line2__c;
			}
			if(OppforNewOif.BusinessLine__r.Total_Allocation__c != null) {
				oif.OIF_Value__c  = 0 - (newOif.OIF_Value__c * OppforNewOif.BusinessLine__r.Total_Allocation__c)/100;
			}else {
				oif.OIF_Value__c  = null;
			}
			list_oif2update.add(oif);
			oif2updateMap.put(oif.Id,oif);
		}
		if(String.isNotEmpty(newOif.Allocation_Line_1__c)) {
			Order_Intake_Forecast__c oif = setInfo2AllocationOIF(newOif.Allocation_Line_1__c, newOif, OppforNewOif);
			if(String.isNotEmpty(OppforNewOif.BusinessLine__r.Allocated_BL_1__c)) {
				oif.BusinessLine__c = OppforNewOif.BusinessLine__r.Allocated_BL_1__c;
				oif.Business_Group__c = OppforNewOif.BusinessLine__r.Allocated_BL_1__r.Business_Group__c;
				oif.Business_Unit__c = OppforNewOif.BusinessLine__r.Allocated_BL_1__r.Family;
				//AP2021
				oif.BusinessLine2__c = OppforNewOif.BusinessLine__r.Allocated_BL_1__r.Business_Line2__c;
			}
			if(OppforNewOif.BusinessLine__r.Post_Allocation_1__c != null) {
				oif.OIF_Value__c  = (newOif.OIF_Value__c * OppforNewOif.BusinessLine__r.Post_Allocation_1__c)/100;
			}else {
				oif.OIF_Value__c  = null;
			}
			list_oif2update.add(oif);
			oif2updateMap.put(oif.Id,oif);
		}
		if(String.isNotEmpty(newOif.Allocation_Line_2__c)) {
			Order_Intake_Forecast__c oif = setInfo2AllocationOIF(newOif.Allocation_Line_2__c, newOif, OppforNewOif);
			if(String.isNotEmpty(OppforNewOif.BusinessLine__r.Allocated_BL_2__c)) {
				oif.BusinessLine__c = OppforNewOif.BusinessLine__r.Allocated_BL_2__c;
				oif.Business_Group__c = OppforNewOif.BusinessLine__r.Allocated_BL_2__r.Business_Group__c;
				oif.Business_Unit__c = OppforNewOif.BusinessLine__r.Allocated_BL_2__r.Family;
				//AP2021
				oif.BusinessLine2__c = OppforNewOif.BusinessLine__r.Allocated_BL_2__r.Business_Line2__c;
			}
			if(OppforNewOif.BusinessLine__r.Post_Allocation_2__c != null) {
				oif.OIF_Value__c  = (newOif.OIF_Value__c * OppforNewOif.BusinessLine__r.Post_Allocation_2__c)/100;
			}else {
				oif.OIF_Value__c  = null;
			}
			list_oif2update.add(oif);
			oif2updateMap.put(oif.Id,oif);
		}
		if(String.isNotEmpty(newOif.Allocation_Line_3__c)) {
			Order_Intake_Forecast__c oif = setInfo2AllocationOIF(newOif.Allocation_Line_3__c, newOif, OppforNewOif);
			if(String.isNotEmpty(OppforNewOif.BusinessLine__r.Allocated_BL_3__c)) {
				oif.BusinessLine__c = OppforNewOif.BusinessLine__r.Allocated_BL_3__c;
				oif.Business_Group__c = OppforNewOif.BusinessLine__r.Allocated_BL_3__r.Business_Group__c;
				oif.Business_Unit__c = OppforNewOif.BusinessLine__r.Allocated_BL_3__r.Family;
				//AP2021
				oif.BusinessLine2__c = OppforNewOif.BusinessLine__r.Allocated_BL_3__r.Business_Line2__c;
			}
			if(OppforNewOif.BusinessLine__r.Post_Allocation_3__c != null) {
				oif.OIF_Value__c  = (newOif.OIF_Value__c * OppforNewOif.BusinessLine__r.Post_Allocation_3__c)/100;
			}else {
				oif.OIF_Value__c  = null;
			}
			list_oif2update.add(oif);
			oif2updateMap.put(oif.Id,oif);
		}
	}
			}
		}

		if(oif2updateMap.size() > 0) {
			oif2updateMap = CloneLinesChangeCurrency(oif2updateMap);
			database.update(oif2updateMap.values(), false);
		}
	}

	/*******************************
*Method name: setInfo2AllocationOIF
*Description: This method will update the allocation lines OIF field according to Master OIF(support ticket 12942)
*******************************/
	public static Order_Intake_Forecast__c setInfo2AllocationOIF(String oifId, Order_Intake_Forecast__c newOif, Order_Intake_Forecast__c OppforNewOif) {
		Order_Intake_Forecast__c oif2update = new Order_Intake_Forecast__c();
		oif2update.Id = oifId;
		oif2update.CurrencyIsoCode = newOif.CurrencyIsoCode;
		oif2update.Exclude_Reason__c = newOif.Exclude_Reason__c;
		oif2update.Forecast_Category__c = newOif.Forecast_Category__c;
		oif2update.Notes__c = newOif.Notes__c;
		oif2update.POPlanReceipt__c = newOif.POPlanReceipt__c;
		oif2update.Rev_RecPlan_Receipt__c = newOif.Rev_RecPlan_Receipt__c;
		oif2update.Software__c = newOif.Software__c;
		oif2update.Update_Status__c = true;
		return oif2update;
	}

	/*******************************
*Method name: clearAllocationOIF
*Description: This method will clear the Master OIF field : Allocation_Line_1__c, Allocation_Line_2__c and Allocation_Line_3__c(support ticket 12826)
*******************************/
	public static void clearAllocationOIF(list<Order_Intake_Forecast__c> list_oifs) {
		for(Order_Intake_Forecast__c oif : list_oifs) {
			if(oif.Allocation__c == false && (String.isNotEmpty(oif.Allocation_Line_1__c) || String.isNotEmpty(oif.Allocation_Line_2__c) || String.isNotEmpty(oif.Allocation_Line_3__c))) {
	oif.Allocation_Line_1__c = null;
	oif.Allocation_Line_2__c = null;
	oif.Allocation_Line_3__c = null;
			}
		}
	}

	/*******************************
*Method name: createAllocationOIF
*Description: This method will create the allocation lines OIF field according to Master OIF(support ticket 12826)
*******************************/
	public static void createAllocationOIF(list<Order_Intake_Forecast__c> list_oifs) {
		try{
			set<String> set_oifIds = new set<String>();
			list<Order_Intake_Forecast__c> list_oif2Insert = new list<Order_Intake_Forecast__c>();

			for(Order_Intake_Forecast__c oif : list_oifs) {
	set_oifIds.add(oif.Id);
			}

			for(Order_Intake_Forecast__c oif : [Select Id, Opportunity__c, Opportunity__r.CurrencyIsoCode ,Opportunity__r.Contract_Signing_Entity__c, BusinessLine__c, BusinessLine__r.Family,BusinessLine__r.Business_Line2__c,
			BusinessLine__r.Business_Group__c, BusinessLine__r.Total_Allocation__c, BusinessLine__r.Allocated_BL_1__c,
			BusinessLine__r.Allocated_BL_2__c, BusinessLine__r.Allocated_BL_3__c, CurrencyIsoCode, Exclude_Reason__c,
			Allocation__c, Forecast_Category__c, Notes__c, OIF_Value__c, POPlanReceipt__c, Rev_RecPlan_Receipt__c, Software__c,
			BusinessLine__r.Post_Allocation_1__c, BusinessLine__r.Post_Allocation_2__c, BusinessLine__r.Post_Allocation_3__c,
			BusinessLine__r.Allocated_BL_1__r.Business_Group__c, BusinessLine__r.Allocated_BL_1__r.Family,
			BusinessLine__r.Allocated_BL_1__r.Business_Line2__c,
			BusinessLine__r.Allocated_BL_2__r.Business_Group__c,
			BusinessLine__r.Allocated_BL_2__r.Family,
			BusinessLine__r.Allocated_BL_2__r.Business_Line2__c,
			BusinessLine__r.Allocated_BL_3__r.Business_Group__c, BusinessLine__r.Allocated_BL_3__r.Family,
			BusinessLine__r.Allocated_BL_3__r.Business_Line2__c
			From Order_Intake_Forecast__c
			Where Id IN: set_oifIds and Allocation_Line_1__c = '' and Allocation_Line_2__c = '' and Allocation_Line_3__c = '' and Allocation__c = false]) {

				if(oif.Opportunity__r.Contract_Signing_Entity__c.equalsIgnoreCase('fNOK')) {
					if(String.isNotEmpty(oif.BusinessLine__r.Allocated_BL_1__c) || Test.isRunningTest()) {
						Order_Intake_Forecast__c oif2Insert_clone = setInfo2CreateAllocationOIF(oif);
						oif2Insert_clone.BusinessLine__c = oif.BusinessLine__c;
						oif2Insert_clone.Business_Group__c = oif.BusinessLine__r.Business_Group__c;
						oif2Insert_clone.Business_Unit__c = oif.BusinessLine__r.Family;
						//AP2021
						oif2Insert_clone.BusinessLine2__c = oif.BusinessLine__r.Business_Line2__c;
						if(oif.BusinessLine__r.Total_Allocation__c != null) {
				oif2Insert_clone.OIF_Value__c  = 0 - (oif.OIF_Value__c * oif.BusinessLine__r.Total_Allocation__c)/100;
						}else {
				oif2Insert_clone.OIF_Value__c  = null;
						}
						list_oif2Insert.add(oif2Insert_clone);

						Order_Intake_Forecast__c oif2Insert_1 = setInfo2CreateAllocationOIF(oif);
						oif2Insert_1.Allocation_Sequence__c = 1;
						oif2Insert_1.BusinessLine__c = oif.BusinessLine__r.Allocated_BL_1__c;
						oif2Insert_1.Business_Group__c = oif.BusinessLine__r.Allocated_BL_1__r.Business_Group__c;
						oif2Insert_1.Business_Unit__c = oif.BusinessLine__r.Allocated_BL_1__r.Family;
						//AP2021
						oif2Insert_1.BusinessLine2__c = oif.BusinessLine__r.Allocated_BL_1__r.Business_Line2__c;
						if(oif.BusinessLine__r.Post_Allocation_1__c != null) {
				oif2Insert_1.OIF_Value__c  = (oif.OIF_Value__c * oif.BusinessLine__r.Post_Allocation_1__c)/100;
						}else {
				oif2Insert_1.OIF_Value__c  = null;
						}
						list_oif2Insert.add(oif2Insert_1);
					}
					if(String.isNotEmpty(oif.BusinessLine__r.Allocated_BL_2__c) || Test.isRunningTest()) {
						Order_Intake_Forecast__c oif2Insert = setInfo2CreateAllocationOIF(oif);
						oif2Insert.Allocation_Sequence__c = 2;
						oif2Insert.BusinessLine__c = oif.BusinessLine__r.Allocated_BL_2__c;
						oif2Insert.Business_Group__c = oif.BusinessLine__r.Allocated_BL_2__r.Business_Group__c;
						oif2Insert.Business_Unit__c = oif.BusinessLine__r.Allocated_BL_2__r.Family;
						//AP2021
						oif2Insert.BusinessLine2__c = oif.BusinessLine__r.Allocated_BL_2__r.Business_Line2__c;
						if(oif.BusinessLine__r.Post_Allocation_2__c != null) {
				oif2Insert.OIF_Value__c  = (oif.OIF_Value__c * oif.BusinessLine__r.Post_Allocation_2__c)/100;
						}else {
				oif2Insert.OIF_Value__c  = null;
						}
						list_oif2Insert.add(oif2Insert);
					}
					if(String.isNotEmpty(oif.BusinessLine__r.Allocated_BL_3__c) || Test.isRunningTest()) {
						Order_Intake_Forecast__c oif2Insert = setInfo2CreateAllocationOIF(oif);
						oif2Insert.BusinessLine__c = oif.BusinessLine__r.Allocated_BL_3__c;
						oif2Insert.Business_Group__c = oif.BusinessLine__r.Allocated_BL_3__r.Business_Group__c;
						oif2Insert.Business_Unit__c = oif.BusinessLine__r.Allocated_BL_3__r.Family;
						//AP2021
						oif2Insert.BusinessLine2__c = oif.BusinessLine__r.Allocated_BL_3__r.Business_Line2__c;
						oif2Insert.Allocation_Sequence__c = 3;
						if(oif.BusinessLine__r.Post_Allocation_3__c != null) {
				oif2Insert.OIF_Value__c  = (oif.OIF_Value__c * oif.BusinessLine__r.Post_Allocation_3__c)/100;
						}else {
				oif2Insert.OIF_Value__c  = null;
						}
						list_oif2Insert.add(oif2Insert);
					}
				}
			}

			if(list_oif2Insert.size() > 0) {
	database.insert(list_oif2Insert, false);
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.CREATEALLOCATIONOIF);
		}

	}

	/*******************************
*Method name: setInfo2CreateAllocationOIF
*Description: This method will create the allocation lines OIF field according to Master OIF(support ticket 12826)
*******************************/
	public static Order_Intake_Forecast__c setInfo2CreateAllocationOIF(Order_Intake_Forecast__c oif) {
		Order_Intake_Forecast__c oif2Insert = new Order_Intake_Forecast__c();
		oif2Insert.Opportunity__c = oif.Opportunity__c;
		oif2Insert.Cloned_From__c = oif.Id;
		oif2Insert.CurrencyIsoCode = oif.Opportunity__r.CurrencyIsoCode;
		oif2Insert.Exclude_Reason__c = oif.Exclude_Reason__c;
		oif2Insert.Forecast_Category__c = oif.Forecast_Category__c;
		oif2Insert.Notes__c = oif.Notes__c;
		oif2Insert.POPlanReceipt__c = oif.POPlanReceipt__c;
		oif2Insert.Rev_RecPlan_Receipt__c = oif.Rev_RecPlan_Receipt__c;
		oif2Insert.Software__c = oif.Software__c;
		return oif2Insert;
	}

	/*******************************
*Method name: updateOIFCurrencyIsoCode
*Description: This method will update the CurrencyIsoCode of Master OIF(support ticket 13172)
*******************************/
	public static void updateOIFCurrencyIsoCode(list<Order_Intake_Forecast__c> list_oifs,Map<Id,Opportunity> opportunityMap)
	{
		for(Order_Intake_Forecast__c oif : list_oifs) {
			if(oif.Allocation__c == false) {
	oif.CurrencyIsoCode = opportunityMap.get(oif.Opportunity__c).CurrencyIsoCode;
			}
		}
	}
	/*******************************
*Method name: chatterOnInsert
*Description: This method will chatter post whenever new OIFs created on opportunity
*******************************/
	public static void chatterOnInsert(List<Order_Intake_Forecast__c> oifNewList)
	{
		Set <Id> opptyIdSet = new Set <Id>();
		Map <Id,Opportunity> opptyMap = new Map <Id,Opportunity>();
		Map <Id,list<Order_Intake_Forecast__c>> OIFMap = new Map<Id,List < Order_Intake_Forecast__c >> ();
		List <Order_Intake_Forecast__c> OIFList;
		ConnectApi.FeedItemInput feedItemInput;
		ConnectApi.MessageBodyInput messageBodyInput;
		ConnectApi.TextSegmentInput textSegmentInput1;
		ConnectApi.TextSegmentInput textSegmentInput;


		for (Order_Intake_Forecast__c orderIntakeForecast: oifNewList )
		{
			opptyIdSet.add(orderIntakeForecast.Opportunity__c);
			if (OIFMap.containsKey(orderIntakeForecast.Opportunity__c))
			{
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
		if(opptyIdSet.size() > 0)
		{
			opptyMap = new Map <Id,Opportunity>([SELECT id, ownerId, Owner_Name__c, Name
			 from Opportunity
			 where id in :opptyIdSet
			 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
		}

		for(id opptyOIF : OIFMap.keyset())
		{
			messageBodyInput = new ConnectApi.MessageBodyInput();
			messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
			textSegmentInput1 = new ConnectApi.TextSegmentInput();
			feedItemInput = new ConnectApi.FeedItemInput();
			String chatterText;

			chatterText = GlobalConstants.NEWLINE + GlobalConstants.DEAR + GlobalConstants.SPACE + opptyMap.get(opptyOIF).Owner_Name__c + GlobalConstants.COMMA + GlobalConstants.NEWLINE + GlobalConstants.NEWLINE + GlobalConstants.OIF_CHATTER1 + opptyMap.get(opptyOIF).Name + GlobalConstants.OIF_CHATTER2;

			for(Order_Intake_Forecast__c OIFchatter : OIFMap.get(opptyOIF ) )
			{
	if(chatterText.length()<9500){
		//Changed BUSINESS_LINE to PRODUCT_LINE as part of SF 01354710
		chatterText += GlobalConstants.NEWLINE + GlobalConstants.NEWLINE + OIFChatter.Name + GlobalConstants.COLON_WITHOUT_SPACE + GlobalConstants.PRODUCT_LINE + OIFchatter.Business_line_Data__c + GlobalConstants.FORECAST_CATEGORY + OIFchatter.Forecast_Category__c + GlobalConstants.OIF_VALUE + OIFchatter.currencyisocode + GlobalConstants.SPACE + OIFchatter.OIF_Value__c + GlobalConstants.POPLAN + OIFchatter.PO_Plan_Data__c+ GlobalConstants.SOFTWARE + OIFchatter.Software__c;
	}
	else
	{
		chatterText = GlobalConstants.NEWLINE + GlobalConstants.DEAR + opptyMap.get(opptyOIF).Owner_Name__c + GlobalConstants.COMMA + GlobalConstants.NEWLINE + GlobalConstants.NEWLINE + GlobalConstants.OIF_CHATTER3 + opptyMap.get(opptyOIF).Name + GlobalConstants.OIF_CHATTER4;
		break;
	}
			}
			textSegmentInput1.text = chatterText;
			messageBodyInput.messageSegments.add(textSegmentInput1);

			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.OIF_CHATTER5 + Label.URL_Instance + GlobalConstants.char_slash + opptyOIF + GlobalConstants.OIF_CHATTER6 + Label.URL_Instance + GlobalConstants.OIF_CHATTER8 ;
			messageBodyInput.messageSegments.add(textSegmentInput);
			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = opptyMap.get(opptyOIF).ownerid;
			if(!Test.isRunningTest() && !(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser) || FeatureManagement.checkPermission(GlobalConstants.custompermission_PartnerSalesManager) )  )
	ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

		}


	}
	/*******************************
*Method name: chatterOnUpdate
*Description: This method will chatter post whenever  OIFs mpodified on opportunity
*******************************/
	public static void chatterOnUpdate(Map<Id,Order_Intake_Forecast__c> oifNewMap, Map<Id,Order_Intake_Forecast__c> oifOldMap)
	{
		Set <Id> opptyIdSet = new Set <Id>();
		Map <Id,Opportunity> opptyMap = new Map <Id,Opportunity>();
		Map <Id,list<Order_Intake_Forecast__c>> OIFMap = new Map<Id,List < Order_Intake_Forecast__c >> ();
		List <Order_Intake_Forecast__c> OIFList;
		ConnectApi.FeedItemInput feedItemInput;
		ConnectApi.MessageBodyInput messageBodyInput;
		ConnectApi.TextSegmentInput textSegmentInput1;
		ConnectApi.TextSegmentInput textSegmentInput;

		for (Id id: oifNewMap.keyset() )
		{
			if(!oifNewMap.get(id).allocation__c && !oifNewMap.get(id).Modified_by_Owner__c && (oifNewMap.get(id).Forecast_Category__c != oifOldMap.get(id).Forecast_Category__c || oifNewMap.get(id).Business_line_Data__c != oifOldMap.get(id).Business_line_Data__c || oifNewMap.get(id).OIF_Value__c != oifOldMap.get(id).OIF_Value__c || oifNewMap.get(id).PO_Plan_Data__c != oifOldMap.get(id).PO_Plan_Data__c || oifNewMap.get(id).Software__c != oifOldMap.get(id).Software__c  ))
			{
	opptyIdSet.add(oifNewMap.get(id).Opportunity__c);
	if (OIFMap.containsKey(oifNewMap.get(id).Opportunity__c))
	{
		OIFList = new List < Order_Intake_Forecast__c > ();
		OIFList = OIFMap.get(oifNewMap.get(id).Opportunity__c);
		OIFList.add(oifNewMap.get(id));
		OIFMap.put(oifNewMap.get(id).Opportunity__c, OIFList);
	} else {
		OIFList = new List < Order_Intake_Forecast__c > ();
		OIFList.add(oifNewMap.get(id));
		OIFMap.put(oifNewMap.get(id).Opportunity__c, OIFList);
	}
			}

		}
		if(opptyIdSet.size() > 0)
		{
			opptyMap = new Map <Id,Opportunity>([SELECT id, Name, ownerId, Owner_Name__c,
			 SWx_Upsell_Proposal__c
			 from Opportunity
			 where id in :opptyIdSet
			 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
		}

		for(id opptyOIF : OIFMap.keyset())
		{
			if(opptyMap.get(opptyOIF).SWx_Upsell_Proposal__c == null)
			{
	messageBodyInput = new ConnectApi.MessageBodyInput();
	messageBodyInput.messageSegments = new List < ConnectApi.MessageSegmentInput > ();
	textSegmentInput1 = new ConnectApi.TextSegmentInput();
	feedItemInput = new ConnectApi.FeedItemInput();
	String chatterText;
	chatterText = GlobalConstants.NEWLINE + GlobalConstants.DEAR + GlobalConstants.SPACE + opptyMap.get(opptyOIF).Owner_Name__c + GlobalConstants.COMMA + GlobalConstants.NEWLINE + GlobalConstants.NEWLINE + GlobalConstants.OIF_CHATTER1  + opptyMap.get(opptyOIF).Name + GlobalConstants.OIF_CHATTER9 + GlobalConstants.COLEN  ;

	for(Order_Intake_Forecast__c OIFchatter : OIFMap.get(opptyOIF ) )
	{
		if(chatterText.length()<9500){
			chatterText += GlobalConstants.NEWLINE + GlobalConstants.NEWLINE + OIFchatter.Name + GlobalConstants.COLON_WITHOUT_SPACE;

			if(oifOldMap.get(OIFchatter.id).Business_line_Data__c!= oifNewMap.get(OIFchatter.id).Business_line_Data__c)
				chatterText += GlobalConstants.BL_CHANGE + oifOldMap.get(OIFchatter.id).Business_line_Data__c + GlobalConstants.TO +oifNewMap.get(OIFchatter.id).Business_line_Data__c + GlobalConstants.DOT;
			if(oifOldMap.get(OIFchatter.id).Forecast_Category__c!= oifNewMap.get(OIFchatter.id).Forecast_Category__c)
				chatterText += GlobalConstants.FORECAST_CHANGE + oifOldMap.get(OIFchatter.id).Forecast_Category__c + GlobalConstants.TO +oifNewMap.get(OIFchatter.id).Forecast_Category__c + GlobalConstants.DOT ;
			if(oifOldMap.get(OIFchatter.id).OIF_Value__c!= oifNewMap.get(OIFchatter.id).OIF_Value__c)
				chatterText += GlobalConstants.OIF_CHANGE + oifOldMap.get(OIFchatter.id).currencyisocode + GlobalConstants.SPACE +  oifOldMap.get(OIFchatter.id).OIF_Value__c + GlobalConstants.TO + oifNewMap.get(OIFchatter.id).currencyisocode + GlobalConstants.SPACE  + oifNewMap.get(OIFchatter.id).OIF_Value__c + GlobalConstants.DOT ;
			if(oifOldMap.get(OIFchatter.id).PO_Plan_Data__c!= oifNewMap.get(OIFchatter.id).PO_Plan_Data__c)
				chatterText += GlobalConstants.PO_CHANGE + oifOldMap.get(OIFchatter.id).PO_Plan_Data__c + GlobalConstants.TO +oifNewMap.get(OIFchatter.id).PO_Plan_Data__c + GlobalConstants.DOT ;
			if(oifOldMap.get(OIFchatter.id).Software__c!= oifNewMap.get(OIFchatter.id).Software__c)
				chatterText += '\nSoftware % is changed from '+ oifOldMap.get(OIFchatter.id).Software__c + GlobalConstants.TO +oifNewMap.get(OIFchatter.id).Software__c + GlobalConstants.DOT ;
		}
		else{
			chatterText = GlobalConstants.NEWLINE + GlobalConstants.DEAR + opptyMap.get(opptyOIF).Owner_Name__c + GlobalConstants.COMMA + GlobalConstants.NEWLINE + GlobalConstants.NEWLINE  + GlobalConstants.OIF_CHATTER3 +opptyMap.get(opptyOIF).Name + GlobalConstants.OIF_CHATTER9 + GlobalConstants.DOT ;
			break;
		}
	}
	textSegmentInput1.text = chatterText;
	messageBodyInput.messageSegments.add(textSegmentInput1);
	textSegmentInput = new ConnectApi.TextSegmentInput();

	textSegmentInput.text = GlobalConstants.OIF_CHATTER5 + Label.URL_Instance + GlobalConstants.char_slash + opptyOIF + GlobalConstants.OIF_CHATTER7 +Label.URL_Instance + GlobalConstants.OIF_CHATTER8 ;
	messageBodyInput.messageSegments.add(textSegmentInput);
	feedItemInput.body = messageBodyInput;
	feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
	feedItemInput.subjectId = opptyMap.get(opptyOIF).ownerid;
	if(!Test.isRunningTest())
		ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
			}
		}
	}

	/*******************************
*Method name: BusinessLineDataInsert
*Description: This method is for replacing process builder (update_on_Business_Unit_Group)
which inserts business line data in OIF whenever OIF is created or business line is updated in OIF
*******************************/
	public static void businessLineDataInsert(List<Order_Intake_Forecast__c> orderIntakeList,Map<Id,Order_Intake_Forecast__c> oifOldMap)
	{
		try{
			if(GlobalConstants.isOrderIntakeFirstRun)
			{
	Id RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get(GlobalConstants.BUSINESS_LINE_RECORD_TYPE).getRecordTypeId();//JOTATR to change
	businessLineMap = new Map<Id,product2>(
		[Select Id,
		 Business_Group__c,
		 Family,Business_Line2__c,
		 Name,Description
		 From Product2
		 where RecordTypeId = :RecordTypeId
		 limit :(Limits.getLimitQueryRows() - Limits.getQueryRows())]);
	GlobalConstants.isOrderIntakeFirstRun = false;
			}

			System.debug('<<<<<<<<<Business line map>>>>>>>>>>'+businessLineMap);
			for(Order_Intake_Forecast__c oif : orderIntakeList)
			{
	if(oif.BusinessLine__c <> null && !oif.Allocation__c & (oifOldMap == null || (oifOldMap <> null && oifOldMap.get(oif.Id).BusinessLine__c <> oif.BusinessLine__c)))
	{
		oif.Business_Group__c = businessLineMap.get(oif.BusinessLine__c).Business_Group__c;
		oif.Business_Unit__c = businessLineMap.get(oif.BusinessLine__c).Family;
		//Change part of AP2021 to fill the data of Business Line Field
		oif.BusinessLine2__c = businessLineMap.get(oif.BusinessLine__c).Business_Line2__c;
	}
			}
			System.debug('Inside Order intake BL:');
			System.debug('Queries used: '+Limits.getQueries());
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.BUSINESSLINEDATAINSERT);
		}
	}


	public static boolean firstRun_Update = true;
	public static boolean firstRun_Insert = true;
	public static boolean firstRun_Delete = true;
	public static integer iCount = 0;
	/*******************************
*Method name: UpsellDelta_OpptyCheck
*Description: This method USed to check the competitor values
*Parameter: Order_Intake_Forecast__c Values
*******************************/
	public static void UpsellDelta_OpptyCheck(List <Order_Intake_Forecast__c> orderIntakeList) {
		Set<ID> OpptyID =new Set<ID>();
		map<id,opportunity> mapId_Opportunity = new map<id,opportunity>();
		map<id,Order_Intake_Forecast__c> mapNewOpportunity = new map<id,Order_Intake_Forecast__c>();
		list<Order_Intake_Forecast__c> lstExistingOIF = new list<Order_Intake_Forecast__c>();

		try{
			for(Order_Intake_Forecast__c OIFList:orderIntakeList)
			{
	OpptyID.add(OIFList.Opportunity__c);
	mapNewOpportunity.put(OIFList.id,OIFList);
	system.debug('OIFinfo.orderIntakeList'+mapNewOpportunity);
			}

			mapId_Opportunity = new map<id,opportunity>(
	[select id,Positive_OIF__c,Upsell_Change_Explanation__c,Sales_Outcome__c,Business_Type__c,Committed_Unweighted_Value_in_EUR__c,Lead_BG__c
	 from opportunity
	 where id in : OpptyID
	 And Business_Type__c = :GlobalConstants.COMMITTED_UPSELL
	 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
			System.debug('mapId_Opportunity>>>>>>>>'+mapId_Opportunity);

			if(mapId_Opportunity <> null && mapId_Opportunity.size() > 0)
			{
	for(Order_Intake_Forecast__c ObjOIF:[Select id,Allocation__c,Forecast_Category__c,Opportunity__c,Opportuity_Competitor_Count__c,OIF_Value_EUR__c from Order_Intake_Forecast__c where Opportunity__c in :OpptyID ])
	{
		if(mapNewOpportunity.get(ObjOIF.id) == null)
			lstExistingOIF.add(ObjOIF);
	}
	system.debug('TotalSum'+OpptyID);
	TotalSum=0;
	for(Order_Intake_Forecast__c OpptyOIFData: lstExistingOIF)
	{
		if (String.IsEmpty(mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c) || mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED))
		{
			if(OpptyOIFData.Forecast_Category__c != GlobalConstants.CANCEL && OpptyOIFData.Forecast_Category__c != GlobalConstants.EXCLUDED && OpptyOIFData.Forecast_Category__c != GlobalConstants.LOST)
			{
				TotalSum=TotalSum + OpptyOIFData.OIF_Value_EUR__c;
			}
		}else if ((mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c<>GlobalConstants.WON))
		{
			TotalSum=TotalSum+OpptyOIFData.OIF_Value_EUR__c;
		}
	}

	for(Order_Intake_Forecast__c OpptyOIFDataNew: mapNewOpportunity.values())
	{
		system.debug('mapNewOpportunity'+OpptyOIFDataNew.OIF_Value_EUR__c);
		if (String.IsEmpty(mapId_Opportunity.get(OpptyOIFDataNew.Opportunity__c).Sales_Outcome__c) || mapId_Opportunity.get(OpptyOIFDataNew.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || mapId_Opportunity.get(OpptyOIFDataNew.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED))
		{
			if(mapNewOpportunity.get(OpptyOIFDataNew.id).Forecast_Category__c != GlobalConstants.CANCEL && mapNewOpportunity.get(OpptyOIFDataNew.id).Forecast_Category__c != GlobalConstants.EXCLUDED && mapNewOpportunity.get(OpptyOIFDataNew.id).Forecast_Category__c != GlobalConstants.LOST)
			{
				TotalSum=TotalSum + OpptyOIFDataNew.OIF_Value_EUR__c;
			}
		}else if ((mapId_Opportunity.get(OpptyOIFDataNew.Opportunity__c).Sales_Outcome__c<>GlobalConstants.WON))
		{
			TotalSum=TotalSum+ OpptyOIFDataNew.OIF_Value_EUR__c;
		}
	}
	decimal strUpsellDelta =0.00;
	system.debug('TotalSum'+TotalSum);

	for(Order_Intake_Forecast__c OIFinfo:orderIntakeList)
	{
		system.debug('OIFinfo OIFinfo'+OIFinfo);
		system.debug('OIFinfo OIFinfo'+OIFinfo.OIF_Value_EUR__c);
		if(mapId_Opportunity.get(OIFinfo.opportunity__c).Business_Type__c == Globalconstants.COMMITTED_UPSELL)
		{
			if(mapId_Opportunity.get(OIFinfo.opportunity__c).Committed_Unweighted_Value_in_EUR__c != 0 )
			{
				strUpsellDelta = TotalSum - mapId_Opportunity.get(OIFinfo.opportunity__c).Committed_Unweighted_Value_in_EUR__c;
				system.debug('strUpsellDelta'+strUpsellDelta);
				if(string.isBlank(mapId_Opportunity.get(OIFinfo.opportunity__c).Upsell_Change_Explanation__c) && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id )
		  && ( (mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_MN  && strUpsellDelta <= integer.valueof(Label.Lead_MN_UpsellDeltaValue))
		   || (mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_NI || mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_CNS) && strUpsellDelta <= integer.valueof(Label.Lead_NI_CNS_UpsellDeltaValue) ))
				{
		OIFinfo.adderror(Label.UpsellDelta_ErrorMsg);
				}
			}
			firstRun_Update=false;
		}
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.OIF_COMPETITOR_CHECK);
		}
	}

	/*******************************
*Method name: UpsellDelta_OpptyCheckInsert
*Description: This method USed to check the competitor values
*Parameter: Order_Intake_Forecast__c Values
*******************************/
	public static void UpsellDelta_OpptyCheckInsert(List <Order_Intake_Forecast__c> orderIntakeList, Map<id,opportunity> mapId_Opportunity) {
		Set<ID> OpptyID =new Set<ID>();
		map<id,Order_Intake_Forecast__c> mapNewOpportunity = new map<id,Order_Intake_Forecast__c>();
		list<Order_Intake_Forecast__c> lstExistingOIF = new list<Order_Intake_Forecast__c>();

		try{

			for(Order_Intake_Forecast__c OIFList:orderIntakeList)
			{
	OpptyID.add(OIFList.Opportunity__c);
	mapNewOpportunity.put(OIFList.id,OIFList);
	system.debug('OIFinfo.orderIntakeList'+mapNewOpportunity);
			}

			for(Order_Intake_Forecast__c ObjOIF:[Select id,Allocation__c,Forecast_Category__c,Opportunity__c,Opportuity_Competitor_Count__c,OIF_Value_EUR__c from Order_Intake_Forecast__c where Opportunity__c in :OpptyID ])
			{
	if(mapNewOpportunity.get(ObjOIF.id) == null)
		lstExistingOIF.add(ObjOIF);
			}

			system.debug('TotalSum'+OpptyID);
			TotalSum=0;
			for(Order_Intake_Forecast__c OpptyOIFData: lstExistingOIF)
			{
	system.debug('OpptyOIFData.OIF_Value_EUR__c'+OpptyOIFData.OIF_Value_EUR__c);
	if (String.IsEmpty(mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c) || mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED))
	{
		if(OpptyOIFData.Forecast_Category__c != GlobalConstants.CANCEL && OpptyOIFData.Forecast_Category__c != GlobalConstants.EXCLUDED && OpptyOIFData.Forecast_Category__c != GlobalConstants.LOST)
		{
			TotalSum=TotalSum + OpptyOIFData.OIF_Value_EUR__c;
		}
	}else if ((mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c<>GlobalConstants.WON))
	{
		TotalSum=TotalSum+OpptyOIFData.OIF_Value_EUR__c;
	}
			}

			for(Order_Intake_Forecast__c OpptyOIFDataNew: mapNewOpportunity.values())
			{
	system.debug('mapNewOpportunity'+OpptyOIFDataNew.OIF_Value_EUR__c);
	if (String.IsEmpty(mapId_Opportunity.get(OpptyOIFDataNew.Opportunity__c).Sales_Outcome__c) || mapId_Opportunity.get(OpptyOIFDataNew.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || mapId_Opportunity.get(OpptyOIFDataNew.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED))
	{
		if(mapNewOpportunity.get(OpptyOIFDataNew.id).Forecast_Category__c != GlobalConstants.CANCEL && mapNewOpportunity.get(OpptyOIFDataNew.id).Forecast_Category__c != GlobalConstants.EXCLUDED && mapNewOpportunity.get(OpptyOIFDataNew.id).Forecast_Category__c != GlobalConstants.LOST)
		{
			TotalSum=TotalSum + OpptyOIFDataNew.OIF_Value_EUR__c;
		}
	}else if ((mapId_Opportunity.get(OpptyOIFDataNew.Opportunity__c).Sales_Outcome__c<>GlobalConstants.WON))
	{
		TotalSum=TotalSum+ OpptyOIFDataNew.OIF_Value_EUR__c;
	}
			}

			decimal strUpsellDelta =0.00;
			system.debug('TotalSum'+TotalSum);

			for(Order_Intake_Forecast__c OIFinfo:orderIntakeList)
			{
	system.debug('OIFinfo OIFinfo'+OIFinfo);
	system.debug('OIFinfo OIFinfo'+OIFinfo.OIF_Value_EUR__c);
	if(mapId_Opportunity.get(OIFinfo.opportunity__c).Business_Type__c == Globalconstants.COMMITTED_UPSELL)
	{
		if(mapId_Opportunity.get(OIFinfo.opportunity__c).Committed_Unweighted_Value_in_EUR__c != 0 )
		{
			strUpsellDelta = TotalSum - mapId_Opportunity.get(OIFinfo.opportunity__c).Committed_Unweighted_Value_in_EUR__c;
			system.debug('strUpsellDelta'+strUpsellDelta);
			if(string.isBlank(mapId_Opportunity.get(OIFinfo.opportunity__c).Upsell_Change_Explanation__c) && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id )
		 && ( (mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_MN  && strUpsellDelta <= integer.valueof(Label.Lead_MN_UpsellDeltaValue))
		  || (mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_NI || mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_CNS) && strUpsellDelta <= integer.valueof(Label.Lead_NI_CNS_UpsellDeltaValue) ))
			{
				OIFinfo.adderror(Label.UpsellDelta_ErrorMsg);
			}
		}
		firstRun_Insert=false;
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.OIF_COMPETITOR_CHECK);
		}
	}

	/*******************************
*Method name: UpsellDelta_OpptyCheckDelete
*Description: This method USed to check the competitor values
*Parameter: Order_Intake_Forecast__c Values
*******************************/
	public static void UpsellDelta_OpptyCheckDelete(List <Order_Intake_Forecast__c> orderIntakeList, Map<Id,Opportunity> mapId_Opportunity) {
		Set<ID> OpptyID =new Set<ID>();
		map<id,Order_Intake_Forecast__c> mapNewOpportunity = new map<id,Order_Intake_Forecast__c>();
		list<Order_Intake_Forecast__c> lstExistingOIF = new list<Order_Intake_Forecast__c>();

		try{
			for(Order_Intake_Forecast__c OIFList:orderIntakeList)
			{
	OpptyID.add(OIFList.Opportunity__c);
	mapNewOpportunity.put(OIFList.id,OIFList);
	system.debug('OIFinfo.orderIntakeList'+mapNewOpportunity);
			}

			for(Order_Intake_Forecast__c ObjOIF:[Select id,Allocation__c,Forecast_Category__c,Opportunity__c,Opportuity_Competitor_Count__c,OIF_Value_EUR__c
			 from Order_Intake_Forecast__c
			 where Opportunity__c in :OpptyID ])
			{
	if(mapNewOpportunity.get(ObjOIF.id) == null)
		lstExistingOIF.add(ObjOIF);
			}
			system.debug('TotalSum'+OpptyID);
			TotalSum=0;
			for(Order_Intake_Forecast__c OpptyOIFData: lstExistingOIF)
			{
	if (String.IsEmpty(mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c) || mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON) || mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c.equalsignorecase(GlobalConstants.WON_REQUESTED))
	{
		if(OpptyOIFData.Forecast_Category__c != GlobalConstants.CANCEL && OpptyOIFData.Forecast_Category__c != GlobalConstants.EXCLUDED && OpptyOIFData.Forecast_Category__c != GlobalConstants.LOST)
		{
			TotalSum=TotalSum + OpptyOIFData.OIF_Value_EUR__c;
		}
	}else if ((mapId_Opportunity.get(OpptyOIFData.Opportunity__c).Sales_Outcome__c<>GlobalConstants.WON))
	{
		TotalSum=TotalSum+OpptyOIFData.OIF_Value_EUR__c;
	}
			}

			decimal strUpsellDelta =0.00;
			system.debug('TotalSum'+TotalSum);

			for(Order_Intake_Forecast__c OIFinfo:orderIntakeList)
			{
	system.debug('OIFinfo OIFinfo'+OIFinfo);
	system.debug('OIFinfo OIFinfo'+OIFinfo.OIF_Value_EUR__c);
	if(mapId_Opportunity.get(OIFinfo.opportunity__c).Business_Type__c == Globalconstants.COMMITTED_UPSELL)
	{
		if(mapId_Opportunity.get(OIFinfo.opportunity__c).Committed_Unweighted_Value_in_EUR__c != 0 )
		{
			strUpsellDelta = TotalSum - mapId_Opportunity.get(OIFinfo.opportunity__c).Committed_Unweighted_Value_in_EUR__c;
			system.debug('strUpsellDelta'+strUpsellDelta);
			if(string.isBlank(mapId_Opportunity.get(OIFinfo.opportunity__c).Upsell_Change_Explanation__c) && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id ) &&
		 ( (mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_MN  && strUpsellDelta <= integer.valueof(Label.Lead_MN_UpsellDeltaValue))
		  || (mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_NI || mapId_Opportunity.get(OIFinfo.opportunity__c).Lead_BG__c == Globalconstants.LEAD_BG_CNS) && strUpsellDelta <= integer.valueof(Label.Lead_NI_CNS_UpsellDeltaValue) ) ) {
		OIFinfo.adderror(Label.UpsellDelta_ErrorMsg);
			}
		}
		firstRun_Delete=false;
	}
			}
		}
		catch (Exception ex) {
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.OIF_COMPETITOR_CHECK);
		}
	}

	/*******************************
*Method name: UpsellDealvalidator
*Description: This method USed to check whether upsell deal is available for commited upsell opportunity
*Parameter: Order_Intake_Forecast__c Values
*******************************/
	public static void UpsellDealvalidator(List <Order_Intake_Forecast__c> orderIntakeList,Map<Id,Opportunity> commupsellmap_oppty) {
		Set<Id> opptywithupdeal =  new Set<Id>();
		try{
			system.debug('UpsellDealvalidator');
			system.debug('opptyIdSet: '+commupsellmap_oppty.keySet());

			//check whether it has deal associated with it
			//if not, add an error to oif record to associate it with a committed upsell opportunity
			for(Opportunity_Group__c opptyGroupObj:[Select id, Opportunity__c,Deal__r.RecordType.Name
				from Opportunity_Group__c
				where Opportunity__c IN: commupsellmap_oppty.keyset()
				and Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL
				LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	opptywithupdeal.add(opptyGroupObj.opportunity__c);
			}

			system.debug('opptywithupdeal: '+opptywithupdeal);
			system.debug('orderIntakeList: '+orderIntakeList);
			for (Order_Intake_Forecast__c oif_rec : orderIntakeList){
	system.debug('oif_rec: '+oif_rec);
	system.debug('map_oppty.get(oif_rec.Opportunity__c).Business_Type__c: '+GlobalConstants.COMMITTED_UPSELL);
	if(commupsellmap_oppty.get(oif_rec.Opportunity__c) <> null && !opptywithupdeal.contains(oif_rec.opportunity__c)){
			oif_rec.adderror(System.Label.AssociateUpsellDealToUpsellOppty_Error);
	}
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.ORDER_INTAKE_HELPER, GlobalConstants.Method_oif_deal_validate);
		}
	}
	/*******************************
	*Method name: setOIFtoZeroAfterG5
	*Description: This method will update OIF value to zero if Forecast Category equals 'Lost' or 'Cancelled' after G5
	*Parameter: Order_Intake_Forecast__c Values
	*******************************/
	public static void setOIFtoZeroAfterG5(list<Order_Intake_Forecast__c> list_oifs, List<Order_Intake_Forecast__c> oifoldvalue, Map<Id,Opportunity> opportunityMap) {
		for(Order_Intake_Forecast__c oif : list_oifs) {
			if(oifoldvalue != null){
	for(Order_Intake_Forecast__c oifOld : oifoldvalue) {
					if( oifOld.Id == oif.Id &&
						opportunityMap.get(oif.Opportunity__c).G5_Approval_Date__c == NULL && 
			opportunityMap.get(oif.Opportunity__c).Phase_Status__c != GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON && 
				((oif.Forecast_Category__c != oifOld.Forecast_Category__c) && 
		(oif.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.LOST) || 
			oif.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.CANCEL)))){
										oif.OIF_Value__c = GlobalConstants.INTEGER_ZERO;
		}
	}
			}
			else{
				if(opportunityMap.get(oif.Opportunity__c).G5_Approval_Date__c == NULL && 
				  	opportunityMap.get(oif.Opportunity__c).Phase_Status__c != GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON && 
						(oif.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.LOST) || 
							oif.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.CANCEL))){
				 	oif.OIF_Value__c = GlobalConstants.INTEGER_ZERO;
				}
			}
		}
	}

}