/**********************************************************************************************************************
 * author: Piyush
 * Date: Mar-2018
 * Param: NA
 * Return: NA
 * Description: Apex class for updating dependent picklist value .
 * High Level Process : changes the value of maintenance type picklist based on portfolio and maintenance pricing level
 * Modifications : ITCCPQ-2556 (Christie JJ) 1/17/2022
 ********************************************************************************************************************* */
public without sharing class Quote_Maintenance_Picklist_handler {

/**
 * The method updates the maintenance picklist values
 * @param recordIDvar record id
 * @return list of default values
 */
@AuraEnabled
public static List<String> updateMaintenanceTypeValue(String recordIDvar){

	//List<String> splittedstrngList = new List<String>();
	//String portfoliomdt = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
	//Boolean leoQuote = false;		 //Added by Heema for LEO check
	//List<String> pricingLevelList = new List<String>();
	List<String> dep_ple_List = new List<String>();

	try{

		String maintVal = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		//String portfolioVal = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		//String stringtoSplit = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;


		Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
		quoteObj = [Select Id, Name, NokiaCPQ_Portfolio__c, NokiaCPQ_Prior_Leo_Value__c,/*NokiaCPQ_Maintenance_Accreditation__c,
			  NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c,*/ NokiaCPQ_Maintenance_Type__c,
			  NokiaCPQ_Maintenance_Level__c,NokiaCPQ_LEO_Discount__c,Apttus_Proposal__Account__c,CPQ_SubPortfolio__c from Apttus_Proposal__Proposal__c
			  where Id =:recordIDvar limit 1];

		//Added by Heema for LEO Check
		if(quoteObj.NokiaCPQ_LEO_Discount__c!=quoteObj.NokiaCPQ_Prior_Leo_Value__c) {
			maintVal= Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		}

		else{
			maintVal = quoteObj.NokiaCPQ_Maintenance_Type__c;
		}
		//Commented out for ITCCPQ-2556 by Christie JJ
		//portfolioVal = quoteObj.NokiaCPQ_Portfolio__c;
		List<String> subPortfolios = Nokia_CPQ_Utility.getPortfolio(quoteObj);
		system.debug('[+] subPortfolios = '+subPortfolios);
		// List<Accreditation__c> accreditations = [SELECT Id,Pricing_Accreditation__c,Portfolio__c,Accreditation_Type__c FROM Accreditation__c WHERE Accreditation_Type__c=:Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE AND Partner__c =:quoteObj.Apttus_Proposal__Account__c AND Portfolio__c IN :subPortfolios];
		Map<String,String> portfolioPricingLevelMap = new Map<String,String>();
		Map<String,String> portfolioMaintenanceTypeMap = new Map<String,String>();
		//Added for ITCCPQ-2556 by Christie JJ
		//Start
		// for(String subPortfolio : subPortfolios) {
		for(Accreditation__c accreditation : [SELECT Id,Pricing_Accreditation__c,Portfolio__c,Accreditation_Type__c FROM Accreditation__c WHERE Accreditation_Type__c=:Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE AND Partner__c =:quoteObj.Apttus_Proposal__Account__c AND Portfolio__c IN :subPortfolios]) {
			string maintPricinglevel = accreditation.Pricing_Accreditation__c;
			//if maintenance Pricing level does not contains brand or AED then set it as BRAND
			if(!String.isBlank(maintPricinglevel) && !maintPricinglevel.contains(Nokia_CPQ_Constants.BRAND_STRING) && !maintPricinglevel.contains(Nokia_CPQ_Constants.AED_STRING)) {
	maintPricinglevel = Nokia_CPQ_Constants.Nokia_Brand;
			}
			portfolioPricingLevelMap.put(accreditation.Portfolio__c,maintPricinglevel);
		}
		// }
		system.debug('[+] portfolioPricingLevelMap = ' + portfolioPricingLevelMap);
		//End

		//Commented out for ITCCPQ-2556 by Christie JJ
		/*
	 if(quoteObj.NokiaCPQ_Maintenance_Level__c !='Yes')
	  maintPricinglevel = quoteObj.NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c;
	 else
	  maintPricinglevel = 'Nokia Brand of Service';
	 //if maintenance Pricing level does not contains brand or AED then set it as All Others
	 if(!String.isBlank(maintPricinglevel) && !maintPricinglevel.contains(Nokia_CPQ_Constants.BRAND_STRING) && !maintPricinglevel.contains(Nokia_CPQ_Constants.AED_STRING)){
	  maintPricinglevel = Nokia_CPQ_Constants.PRICING_LEVEL_ALL_OTHERS;
	 }

	 else if(String.isBlank(maintPricinglevel)){
	  stringtoSplit = Nokia_CPQ_Constants.Maintenance_Type_List_Values;
	 }*/

		//Added for ITCCPQ-2556 by Christie JJ
		Set<String> maintenanceTypes = new Set<String>();
		Set<String> commonTypes = new Set<String>();
		for(Nokia_CPQ_Maintenance_type__mdt metadataRec : [SELECT NokiaCPQ_Portfolio__c, NokiaCPQ_Maintenance_Pricing_Levels__c,
													 Is_LEO_Quote__c,Maintenance_Type__c
													 FROM Nokia_CPQ_Maintenance_type__mdt
													 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {

			String portfoliomdt = metadataRec.NokiaCPQ_Portfolio__c;
			if(!subPortfolios.contains(portfoliomdt)) {
	continue;
			}
			List<String> pricingLevelList = metadataRec.NokiaCPQ_Maintenance_Pricing_Levels__c.split(Nokia_CPQ_Constants.SEMICOLON_STRING);
			Boolean leoQuote = metadataRec.Is_LEO_Quote__c;
			string maintPricinglevel = portfolioPricingLevelMap.get(portfoliomdt);

			//if(!String.isBlank(maintPricinglevel) && portfoliomdt.equals(portfolioVal) && pricingLevelList.contains(maintPricinglevel) && quoteObj.NokiaCPQ_LEO_Discount__c==leoQuote)
			if(String.isNotBlank(maintPricinglevel) && pricingLevelList.contains(maintPricinglevel) && quoteObj.NokiaCPQ_LEO_Discount__c == leoQuote)
			{
	//Added by Heema for LEO check quoteObj.NokiaCPQ_LEO_Discount__c==leoQuote
	portfolioMaintenanceTypeMap.put(portfoliomdt,metadataRec.Maintenance_Type__c);
			}

			/*else{
	portfolioMaintenanceTypeMap.put(portfoliomdt,Nokia_CPQ_Constants.Maintenance_Type_List_Values);
			}*/
		}
		system.debug('[+] portfolioMaintenanceTypeMap = ' + portfolioMaintenanceTypeMap);
		List<string> commonMaintTypes = new List<string>();
		if(!portfolioMaintenanceTypeMap.isEmpty()) {
			for (string maintType : portfolioMaintenanceTypeMap.values()) {
	List<string> types = maintType.split(Nokia_CPQ_Constants.SEMICOLON_STRING);
	if(commonMaintTypes.isEmpty()) {
		commonMaintTypes.addAll(types);
	}else{
		commonMaintTypes = Nokia_CPQ_Utility.getDuplicatesFrom2Lists(types, commonMaintTypes);
	}
			}
		}else{
			commonMaintTypes = Nokia_CPQ_Constants.Maintenance_Type_List_Values.split(Nokia_CPQ_Constants.SEMICOLON_STRING);
		}

		system.debug('[+] maintVal = ' + maintVal);
		system.debug('[+] commonMaintTypes = ' + commonMaintTypes);
		if(String.isNotBlank(maintVal)) {
			dep_ple_List.add(maintVal);
		}
		else{
			dep_ple_List.add(defaultValueReturn(recordIDvar));
		}
		system.debug('[+] dep_ple_List inital = ' + dep_ple_List);

		//Add metadata picklist options to the list.
		for(String strval : commonMaintTypes) {
			if(!strval.equals(maintVal) && !dep_ple_List.contains(strval)) {
	dep_ple_List.add(strval);
			}
		}
		system.debug('[+] dep_ple_List final = ' + dep_ple_List);
	}
	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}
	return dep_ple_List;
}

/**
 * The method updates the Existing Maintenance Contract picklist values
 * @param recordIDvar record id
 * @param fieldapiname API name of field
 * @return list of default values
 */
@AuraEnabled
public Static List<String> updateExistingMaintContract(String recordIDvar,String fieldapiname){

	Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	String exstMaintVal = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
	String extMaintcntVal = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
	List<String> exstMaintList = new List<String>();
	List<String> finalList = new List<String>();


	try{

		Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
		Schema.SObjectType pType = objGlobalMap.get(Nokia_CPQ_Constants.PROPOSAL_OBJECT);
		Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();

		List<Schema.PicklistEntry> dep_ple = objFieldMap.get(fieldapiname).getDescribe().getPicklistValues();

		for(Schema.PicklistEntry strvar : dep_ple) {

			exstMaintList.add(strvar.getvalue());
		}

		quoteObj = [Select Id, Name, NokiaCPQ_Portfolio__c, NokiaCPQ_SSP_Level__c, NokiaCPQ_SRS_Level__c,NokiaCPQ_No_of_Years__c, NokiaCPQ_Existing_IONMaint_Contract__c, /*NokiaCPQ_Maintenance_Accreditation__c,NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c,*/ NokiaCPQ_Maintenance_Type__c,NokiaCPQ_Maintenance_Level__c,NokiaCPQ_LEO_Discount__c from Apttus_Proposal__Proposal__c where Id =:recordIDvar limit 1];

		if(fieldapiname.equals(Nokia_CPQ_Constants.STRING_EXISTING_MAINT_CNT)) {

			exstMaintVal = quoteObj.NokiaCPQ_Existing_IONMaint_Contract__c;
			finalList.add(exstMaintVal);
			for(String strvar : exstMaintList) {

	if(!strvar.equals(exstMaintVal)) {
		finalList.add(strvar);
	}
			}
		}

		//Commented out for ITCCPQ-2556, by Christie JJ
		/*else if(fieldapiname == 'NokiaCPQ_Maintenance_Level__c'){
	  finalList.clear();
	  //ADDED BY RG:19th Nov 2019 Start

	  //updated for REQ#7143 - for MPW portfolio
	  if(quoteObj.NokiaCPQ_LEO_Discount__c == true && !quoteObj.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION)){
		  exstMaintVal = 'No';
		  finalList.add(exstMaintVal);
		  return finalList;
	  }

	  //ADDED BY RG:19th Nov 2019 End
	  if(quoteObj.NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c != 'Nokia Brand of Service')
	  {
		  exstMaintVal = quoteObj.NokiaCPQ_Maintenance_Level__c;
	  }
	  else{
		  exstMaintVal = 'Yes';
	  }
	  finalList.add(exstMaintVal);
	  System.debug('One Final List'+finalList );
	  //finalList.add(exstMaintVal);
	  System.debug('Two Final List'+finalList );
	  system.debug('exstMaintVal'+exstMaintVal);
	  for(String strvar : exstMaintList){


		  if(!strvar.equals(exstMaintVal)){

			  finalList.add(strvar);
		  }
	  }
	  system.debug('finalListfinalList'+finalList);
	  return finalList;
	 }*/


		else if(fieldapiname.equals(Nokia_CPQ_Constants.STRING_SSP_API_NAME)) {

			exstMaintVal = quoteObj.NokiaCPQ_SSP_Level__c;
			if(exstMaintVal==null && quoteObj.NokiaCPQ_Portfolio__c.equals(Nokia_CPQ_Constants.IP_ROUTING_STRING)) {
	exstMaintVal = Nokia_CPQ_Constants.SSP_DEFAULT_VALUE;
			}
		}

		else if(fieldapiname.equals(Nokia_CPQ_Constants.STRING_SRS_API_NAME)) {

			exstMaintVal = quoteObj.NokiaCPQ_SRS_Level__c;
			if(exstMaintVal==null && quoteObj.NokiaCPQ_Portfolio__c.equals(Nokia_CPQ_Constants.IP_ROUTING_STRING)) {
	exstMaintVal = Nokia_CPQ_Constants.SRS_DEFAULT_VALUE;
			}
		}


		else if(fieldapiname.equals(Nokia_CPQ_Constants.STRING_NO_OF_YEARS)) {

			exstMaintVal = quoteObj.NokiaCPQ_No_of_Years__c;
			extMaintcntVal = quoteObj.NokiaCPQ_Existing_IONMaint_Contract__c;
			String portfolio_Value = quoteObj.NokiaCPQ_Portfolio__c;
			//Boolean maint_only = quoteObj.NokiaCPQ_Is_Maintenance_Quote__c;
			List<String> numYearsList = new List<String>();

			if(portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_IP_ROUTING)
	  || portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_NUAGE)
	  || portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.OPTICS)
	  || portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL)
	  || portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA)
	  || portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.Nokia_FASTMILE)
	  
	  //Added condition for Fixed Networks Indirect Quote for ITCCPQ-2556
	  || portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_INDIRECT_FN)

	  || portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_MODULAR_PRIVATE_WIRELESS_SOLUTION)
	  || portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_MICROWAVE)) {

	numYearsList.add(Nokia_CPQ_Constants.ONE_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.TWO_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.THREE_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.FOUR_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.FIVE_YEAR_STRING);
			}
			else if(portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING)) {
	numYearsList.add(Nokia_CPQ_Constants.ONE_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.THREE_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.FIVE_YEAR_STRING);
			}

			//Added MPW portfolio for REQ#7143
			else if(portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION) ) {
	system.debug('Enter in MPW');
	numYearsList.add(Nokia_CPQ_Constants.THREE_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.FOUR_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.FIVE_YEAR_STRING);
			}

			else{
	numYearsList.add(Nokia_CPQ_Constants.ONE_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.TWO_YEAR_STRING);
	numYearsList.add(Nokia_CPQ_Constants.THREE_YEAR_STRING);
			}


			system.debug('finalListfinalList'+finalList);
			if((extMaintcntVal.equals(Nokia_CPQ_Constants.YES_STRING) ) || (extMaintcntVal.equals(Nokia_CPQ_Constants.NO_STRING)) ) {

	finalList.add(exstMaintVal);
	for(String strvar : numYearsList) {
		if(!strvar.equals(exstMaintVal)) {
			finalList.add(strvar);
		}
	}

			}

			else{
	if(!portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING) && !portfolio_Value.equalsIgnoreCase(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION)) {		 //Added by RG for Req:6379, Added by Monika - MPW portfolio for REQ#7143
		finalList.add(Nokia_CPQ_Constants.ONE_YEAR_STRING);
	}
	else{		 //Added by RG for Req:6379 Start

		finalList.add(exstMaintVal);
		for(String strvar : numYearsList) {
			if(!strvar.equals(exstMaintVal)) {
				finalList.add(strvar);
			}
		}
	}		 //Added by RG for Req:6379 End
			}


		}

		if(!fieldapiname.equals(Nokia_CPQ_Constants.STRING_NO_OF_YEARS) && !fieldapiname.equals(Nokia_CPQ_Constants.STRING_EXISTING_MAINT_CNT)) {

			if(exstMaintVal==null) {
	exstMaintVal = Nokia_CPQ_Constants.NONE_STRING;
			}

			finalList.add(exstMaintVal);
			for(String strvar : exstMaintList) {

	if(!strvar.equals(exstMaintVal)) {
		finalList.add(strvar);
	}
			}
		}
	}
	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}
	return finalList;
}

/**
 * The Method saves the selected maintenance value on quote record.
 * @param recordIDvar record id
 * @param different field values to be saved
 * @return success/failure
 */
//Modified by Christie JJ for ITCCPQ-2556
@AuraEnabled
//public Static String saveRecord(String recordIDvar, String maintstring, String existcontract, String numyears, String planLevel, String releaseLevel,String strMaintLvl){
public Static String saveRecord(String recordIDvar, String maintstring, String existcontract, String numyears, String planLevel, String releaseLevel){

	String successmsg = Nokia_CPQ_Constants.FAIL_STRING;
	//addedby surinder
	//String repriceNeedeMessage;
	//system.debug('successmsg1 ---->'+successmsg);

	try{
		Apttus_Proposal__Proposal__c quoteInstance = new Apttus_Proposal__Proposal__c();
		quoteInstance = [Select Id, Name, NokiaCPQ_Portfolio__c,CPQ_SubPortfolio__c, NokiaCPQ_SRS_Level__c,NokiaCPQ_Prior_Leo_Value__c, NokiaCPQ_No_of_Years__c, NokiaCPQ_SSP_Level__c, NokiaCPQ_Existing_IONMaint_Contract__c, /*NokiaCPQ_Maintenance_Accreditation__c,NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c,*/ NokiaCPQ_Maintenance_Type__c,/*NokiaCPQ_Maintenance_Level__c,*/NokiaCPQ_LEO_Discount__c,NokiaCPQ_Needs_Reprice__c from Apttus_Proposal__Proposal__c where Id =:recordIDvar limit 1];

		if(String.isBlank(maintstring)) {
			maintstring=quoteInstance.NokiaCPQ_Maintenance_Type__c;

			if(String.isBlank(maintstring) || (quoteInstance.NokiaCPQ_LEO_Discount__c!=quoteInstance.NokiaCPQ_Prior_Leo_Value__c)) {
	String maintTypeString = defaultValueReturn(recordIDvar);
	//system.debug('maintTypeString--->'+maintTypeString);
	maintstring = maintTypeString;
			}

		}

		if(String.isBlank(existcontract)) {
			existcontract=quoteInstance.NokiaCPQ_Existing_IONMaint_Contract__c;
			//system.debug('existcontract--->'+quoteInstance.NokiaCPQ_Existing_IONMaint_Contract__c);
		}
		//added for 4362 enhancement
		else if(!String.isBlank(existcontract)) {
			if(!existcontract.equalsIgnoreCase(quoteInstance.NokiaCPQ_Existing_IONMaint_Contract__c)) {
	if(existcontract.equalsIgnoreCase(Nokia_CPQ_Constants.NO_STRING)&& !quoteInstance.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION)) {		 // Added "MPW portfolio" by Monika for REQ#7143
		//numyears = Nokia_CPQ_Constants.ONE_YEAR_STRING;
	}
	else if(existcontract.equalsIgnoreCase(Nokia_CPQ_Constants.YES_STRING)|| quoteInstance.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION)) {		 // Added "MPW portfolio" by Monika for REQ#7143
		numyears = Nokia_CPQ_Constants.THREE_YEAR_STRING;
	}
			}
		}

		//Start: Changes related to req 4805
		if(String.isBlank(planLevel)) {
			planLevel=quoteInstance.NokiaCPQ_SSP_Level__c;
			if(String.isBlank(planLevel)) {
	planLevel = sspsrsValueReturn(Nokia_CPQ_Utility.getPortfolio(quoteInstance), Nokia_CPQ_Constants.NOKIA_SSP);
			}

		}

		else if(!String.isBlank(planLevel)) {
			if(planLevel.equalsIgnoreCase(Nokia_CPQ_Constants.NONE_STRING)) {
	planLevel=null;
			}
		}

		if(String.isBlank(releaseLevel)) {
			releaseLevel=quoteInstance.NokiaCPQ_SRS_Level__c;
			if(String.isBlank(releaseLevel)) {
	releaseLevel = sspsrsValueReturn(Nokia_CPQ_Utility.getPortfolio(quoteInstance), Nokia_CPQ_Constants.NOKIA_SRS);
			}

		}

		else if(!String.isBlank(releaseLevel)) {
			if(releaseLevel.equalsIgnoreCase(Nokia_CPQ_Constants.NONE_STRING)) {
	releaseLevel=null;
			}
		}
		//End: Changes related to req 4805
		if(String.isBlank(numyears)) {
			if(/*existcontract.equalsIgnoreCase(Nokia_CPQ_Constants.NO_STRING) && !quoteInstance.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING) && */ quoteInstance.NokiaCPQ_Portfolio__c!=null && !quoteInstance.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION)) {		 //added by RG for Defect  // Added "MPW portfolio" by Monika for REQ#7143
	numyears = quoteInstance.NokiaCPQ_No_of_Years__c;

			}
			else{
	// Added the below if conidtion for "MPW portfolio" by Monika for REQ#7143
	if(quoteInstance.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION) && quoteInstance.NokiaCPQ_No_of_Years__c.equalsIgnoreCase(Nokia_CPQ_Constants.ONE_YEAR_STRING) ) {
		numyears = Nokia_CPQ_Constants.THREE_YEAR_STRING;
	}
	else {
		numyears=quoteInstance.NokiaCPQ_No_of_Years__c;
	}
	if(String.isBlank(numyears)) {
		numyears = Nokia_CPQ_Constants.THREE_YEAR_STRING;
	}

			}

		}
		//Commented out for ITCCPQ-2556 by Christie JJ
		/*if(! String.isBlank(strMaintLvl)){

	  quoteInstance.NokiaCPQ_Maintenance_Level__c=strMaintLvl;
	 }*/
		//system.debug('monika before if-->'+quoteInstance.NokiaCPQ_Maintenance_Level__c+'..'+strMaintLvl);
		/*if(quoteInstance.NokiaCPQ_LEO_Discount__c == true && !quoteInstance.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION)){
	 //system.debug('monika after if-->'+quoteInstance.NokiaCPQ_Maintenance_Level__c+'..'+strMaintLvl);
	  quoteInstance.NokiaCPQ_Maintenance_Level__c = 'No';
	 }*/
		system.debug('old MaintType--->'+quoteInstance.NokiaCPQ_Maintenance_Type__c+' New =>'+ maintstring);

		quoteInstance.NokiaCPQ_Maintenance_Type__c = maintstring;
		quoteInstance.NokiaCPQ_Existing_IONMaint_Contract__c = existcontract;
		quoteInstance.NokiaCPQ_SSP_Level__c = planLevel;
		quoteInstance.NokiaCPQ_SRS_Level__c = releaseLevel;
		quoteInstance.NokiaCPQ_No_of_Years__c = numyears;

		upsert quoteInstance;

		successmsg = Nokia_CPQ_Constants.SUCCESS_STRING;

	}

	catch(Exception e) {
		successmsg = Nokia_CPQ_Constants.FAIL_STRING+e.getMessage();

	}

	return successmsg;

}

/**
 * This method is used to pass Boolean value based portfolio picklist value to SSP field in Lightning component.
 * @param recordIDvar record id
 * @return Portfolio value
 */
@AuraEnabled
public Static Boolean getportfolioSSP(String recordIDvar){
	Boolean disableVal = true;
	String portfolioVal = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;

	try{

		Apttus_Proposal__Proposal__c quoteInstance = new Apttus_Proposal__Proposal__c();

		//Modified for ITCCPQ-2557 by Christie JJ
		//quoteInstance = [Select Id, Name, NokiaCPQ_Portfolio__c, NokiaCPQ_Maintenance_Accreditation__c,NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c, NokiaCPQ_Maintenance_Type__c from Apttus_Proposal__Proposal__c where Id =:recordIDvar limit 1];
	 quoteInstance = [Select Id, Name, NokiaCPQ_Portfolio__c, CPQ_SubPortfolio__c,/*NokiaCPQ_Maintenance_Accreditation__c,NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c,*/ NokiaCPQ_Maintenance_Type__c from Apttus_Proposal__Proposal__c where Id =:recordIDvar limit 1];

		//system.debug('quoteInstanceSSP-->'+quoteInstance);
		//portfolioVal = quoteInstance.NokiaCPQ_Portfolio__c;

		//Nokia_CPQ_SSP_SRS_Default_Values__mdt metadataRec = [SELECT Portfolio__c, SSP_Visible__c FROM Nokia_CPQ_SSP_SRS_Default_Values__mdt where Portfolio__c =: portfolioVal limit 1];
		List<Nokia_CPQ_SSP_SRS_Default_Values__mdt> metadataRec = [SELECT Portfolio__c, SSP_Visible__c FROM Nokia_CPQ_SSP_SRS_Default_Values__mdt where Portfolio__c IN: Nokia_CPQ_Utility.getPortfolio(quoteInstance) limit 1];
		if(metadataRec.size()>0){
		if(metadataRec[0].SSP_Visible__c) {
			disableVal = false;
		}}

	}
	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}

	return disableVal;
}

/**
 * This method is used to pass Boolean value based portfolio picklist value to SRS field in Lightning component.
 * @param recordIDvar record id
 * @return Portfolio value
 */
@AuraEnabled
public Static Boolean getportfolioSRS(String recordIDvar){
	Boolean disableVal = true;
	String portfolioVal = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;

	try{

		Apttus_Proposal__Proposal__c quoteInstance = new Apttus_Proposal__Proposal__c();

		//Modified for ITCCPQ-2557 by Christie JJ
		
		//quoteInstance = [Select Id, Name, NokiaCPQ_Portfolio__c, NokiaCPQ_Maintenance_Accreditation__c,NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c, NokiaCPQ_Maintenance_Type__c from Apttus_Proposal__Proposal__c where Id =:recordIDvar limit 1];
		//system.debug('quoteInstanceSRS-->'+quoteInstance);

		quoteInstance = [Select Id, Name, NokiaCPQ_Portfolio__c,CPQ_SubPortfolio__c from Apttus_Proposal__Proposal__c where Id =:recordIDvar limit 1];

		//portfolioVal = quoteInstance.NokiaCPQ_Portfolio__c;

		//Nokia_CPQ_SSP_SRS_Default_Values__mdt metadataRec = [SELECT Portfolio__c, SRS_Visible__c FROM Nokia_CPQ_SSP_SRS_Default_Values__mdt where Portfolio__c =: portfolioVal limit 1];
		List<Nokia_CPQ_SSP_SRS_Default_Values__mdt> metadataRec = [SELECT Portfolio__c, SRS_Visible__c FROM Nokia_CPQ_SSP_SRS_Default_Values__mdt where Portfolio__c IN: Nokia_CPQ_Utility.getPortfolio(quoteInstance) limit 1];
		if(metadataRec.size()>0){
		if(metadataRec[0].SRS_Visible__c) {
			disableVal = false;
		}}

	}
	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}

	return disableVal;
}


/**
 * method to return the default value from custom metadata
 * @param recordIDvar record id
 * @return default value
 */
//  Modified by ITCCPQ-2556, by Christie JJ
@AuraEnabled
public static String defaultValueReturn(String recordIDvar){

	String defaultValue = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;

	//Added for ITCCPQ-2556
	//Start
	Map<String,String> portfolioPricingLevelMap = new Map<String,String>();
	//End

	try{

		Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
		quoteObj = [Select Id, Name, NokiaCPQ_Portfolio__c,NokiaCPQ_LEO_Discount__c, /*NokiaCPQ_Maintenance_Accreditation__c,NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c,*/ NokiaCPQ_Maintenance_Type__c,Apttus_Proposal__Account__c,CPQ_SubPortfolio__c from Apttus_Proposal__Proposal__c where Id =:recordIDvar limit 1];

		String accountId = quoteObj.Apttus_Proposal__Account__c;

		//Added for ITCCPQ-2556
		//Start
		List<String> subPortfolios = Nokia_CPQ_Utility.getPortfolio(quoteObj);

		for(Accreditation__c accreditation : [SELECT Id,Pricing_Accreditation__c,Portfolio__c,Accreditation_Type__c FROM Accreditation__c WHERE Accreditation_Type__c=:Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE AND Partner__c =:accountId AND Portfolio__c IN :subPortfolios]) {
			string maintPricinglevel = accreditation.Pricing_Accreditation__c;
			//if maintenance Pricing level does not contains brand or AED then set it as BRAND
			if(!String.isBlank(maintPricinglevel) && !maintPricinglevel.contains(Nokia_CPQ_Constants.BRAND_STRING) && !maintPricinglevel.equalsIgnoreCase(Nokia_CPQ_Constants.AED_STRING)) {
	maintPricinglevel = Nokia_CPQ_Constants.Nokia_Brand;
			}
			portfolioPricingLevelMap.put(accreditation.Portfolio__c,maintPricinglevel);
		}

		for(Nokia_CPQ_Maintenance_type__mdt metadataRec : [SELECT NokiaCPQ_Portfolio__c, NokiaCPQ_Maintenance_Pricing_Levels__c, Default_Value__c, Maintenance_Type__c,Is_LEO_Quote__c FROM Nokia_CPQ_Maintenance_type__mdt Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
			if(!subPortfolios.contains(metadataRec.NokiaCPQ_Portfolio__c)) {
	continue;
			}
			List<String> pricingLevelList = metadataRec.NokiaCPQ_Maintenance_Pricing_Levels__c.split(Nokia_CPQ_Constants.SEMICOLON_STRING);
			system.debug('pricingLevelList-->'+pricingLevelList);
			string maintPricinglevel = portfolioPricingLevelMap.get(metadataRec.NokiaCPQ_Portfolio__c);
			if(String.isNotBlank(maintPricinglevel) && pricingLevelList.contains(maintPricinglevel) && metadataRec.Is_LEO_Quote__c==quoteObj.NokiaCPQ_LEO_Discount__c) {
	defaultValue = metadataRec.Default_Value__c;
	break;
			}
		}
	}
	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}
	return defaultValue;

}

/**
 * method to return the value of Approval stage as well as reprice in progress checkbox
 * @param recordIDvar record id
 * @return boolean
 */
@AuraEnabled
public static Boolean approvalStageValueReturn(String recordIDvar){

	Boolean repricecheck = false;
	Boolean returnval = false;
	String stageValue = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;

	try{

		Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
		quoteObj = [Select Id, Name, Apttus_Proposal__Approval_Stage__c, Reprice_In_Progress__c, NokiaCPQ_Portfolio__c, /*NokiaCPQ_Maintenance_Accreditation__c,NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c,*/ NokiaCPQ_Maintenance_Type__c from Apttus_Proposal__Proposal__c where Id =:recordIDvar limit 1];
		stageValue = quoteObj.Apttus_Proposal__Approval_Stage__c;
		repricecheck = quoteObj.Reprice_In_Progress__c;

		if(stageValue.equalsIgnoreCase(Nokia_CPQ_Constants.IN_REVIEW_STRING) || stageValue.equalsIgnoreCase(Nokia_CPQ_Constants.APPROVED_STRING) || stageValue.equalsIgnoreCase(Nokia_CPQ_Constants.EXPIRED_STRING) || stageValue.equalsIgnoreCase(Nokia_CPQ_Constants.CLOSED_NOT_WON_STRING) || stageValue.equalsIgnoreCase(Nokia_CPQ_Constants.ACCEPTED_STRING) || repricecheck) {
			returnval = true;
		}


	}
	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}

	return returnval;
}

/**
 * method to return the value of Approval stage as well as reprice in progress checkbox
 * @param recordIDvar record id
 * @return boolean
 */
@AuraEnabled
public static String sspsrsValueReturn(List<String> portfolios, String field){

	String defaultValue = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
	map<String,Nokia_CPQ_SSP_SRS_Default_Values__mdt> newMapSRS_SSP = new map<String,Nokia_CPQ_SSP_SRS_Default_Values__mdt>();

	try{

		
		for(Nokia_CPQ_SSP_SRS_Default_Values__mdt sspSrsMetadata :[SELECT Portfolio__c,SSP_Visible__c,SRS_Visible__c, SSP_Default_Value__c, SRS_Default_Value__c FROM Nokia_CPQ_SSP_SRS_Default_Values__mdt where Portfolio__c IN: portfolios limit 4]) {
			newMapSRS_SSP.put(sspSrsMetadata.Portfolio__c, sspSrsMetadata);
		}
		for(String portfolio : portfolios) {
			if(newMapSRS_SSP != null && newMapSRS_SSP.get(portfolio) != null) {
	Nokia_CPQ_SSP_SRS_Default_Values__mdt metadataRec = newMapSRS_SSP.get(portfolio);
			
		if(field.equals(Nokia_CPQ_Constants.NOKIA_SSP)) {
			if(metadataRec.SSP_Visible__c) {
	defaultValue = metadataRec.SSP_Default_Value__c;
			}
			else{
	defaultValue= null;
			}
		}
		else{
			if(metadataRec.SRS_Visible__c) {
	defaultValue = metadataRec.SRS_Default_Value__c;
			}
			else{
	defaultValue= null;
			}
		}
	
		if(defaultValue!=null)
		break;
}}

	}

	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}

	return defaultValue;
}

/**
 * method to return the value of portfolio for a quote
 * @param recordIDvar record id
 * @return boolean
 */
@AuraEnabled
public static String portfolioValueReturn(String recordIdVar){

	String PortfolioVal = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
	try{
		Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
		quoteObj = [Select Id, Name, NokiaCPQ_Portfolio__c from Apttus_Proposal__Proposal__c where id=:recordIdVar Limit 1];
		PortfolioVal = quoteObj.NokiaCPQ_Portfolio__c;
	}
	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}

	return PortfolioVal;

}

/* Commented out for FN restructuring changes by Christie JJ
@AuraEnabled
public static String MaintenanceLevelValueReturn(ID recordIdVar,string strTypeValue){



	try{
		Apttus_Proposal__Proposal__c quoteval = new Apttus_Proposal__Proposal__c();
		quoteval = [Select Id, Name, NokiaCPQ_Maintenance_Level__c from Apttus_Proposal__Proposal__c where id=:recordIdVar Limit 1];

		if(quoteval.NokiaCPQ_Maintenance_Level__c != strTypeValue)
			quoteval.NokiaCPQ_Maintenance_Level__c = strTypeValue;


		update quoteval;
		return 'working';
	}

	catch(Exception e) {

		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		return e.getMessage();
	}
}*/
@AuraEnabled
public static String accreditationValueReturn(String recordIdVar){

	String accreditationValue = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
	try{
		
		//Modified for ITCCPQ-2556 by Christie JJ
		//Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
		//quoteObj = [Select Id, Name, NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c from Apttus_Proposal__Proposal__c where id=:recordIdVar Limit 1];
		//accreditationValue = quoteObj.NokiaCPQ_Maintenance_Accreditation__r.Pricing_Accreditation__c;
		Apttus_Proposal__Proposal__c quoteObj = [Select Id, Name,Apttus_Proposal__Account__c,NokiaCPQ_Portfolio__c,CPQ_SubPortfolio__c from Apttus_Proposal__Proposal__c where id=:recordIdVar Limit 1];
		if(quoteObj!=null){
		
		List<Accreditation__c> accreditationsList = [SELECT Id,Pricing_Accreditation__c,Portfolio__c,Accreditation_Type__c,Partner__c FROM Accreditation__c 
		WHERE Accreditation_Type__c=:Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE AND Partner__c = :quoteObj.Apttus_Proposal__Account__c 
		AND Portfolio__c IN :Nokia_CPQ_Utility.getPortfolio(quoteObj)];

		if(accreditationsList.size()>0){
			accreditationValue = accreditationsList[0].Pricing_Accreditation__c;
		}
	}
	return accreditationValue;
}
	catch(Exception e) {
		ExceptionHandler.addException(e,quote_Maintenance_Picklist_handler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);

	}

	return accreditationValue;

}


/**
	* Added by Kishor
	* Date : 26-10-2021
	* method to return the map to initialize the Maintenance Type picklist LWC
	* @param recordId record id
	* @param fieldapinames list of field API names 
	* @return map<String, Object>
	*/
	@AuraEnabled
	public Static map<String, Object> initializeMaintenancePicklists(String recordId, list<String> fieldapinames){
		map<String, Object> fieldVsValue = new map<String, Object>();
		
		//Approval Stage method
		Boolean approvalStageVal = approvalStageValueReturn(recordId);
		fieldVsValue.put('approvalStageValueReturn', approvalStageVal);

		//SSP Portfolios
		Boolean sspPortfolioVal = getportfolioSSP(recordId);
		fieldVsValue.put('getportfolioSSP', sspPortfolioVal);

		//SRS Portfolio
		Boolean srsPortfolioVal = getportfolioSRS(recordId);
		fieldVsValue.put('getportfolioSRS', srsPortfolioVal);

		//Maintenance Type Value
		list<String> dep_ple_List = updateMaintenanceTypeValue(recordId);
		fieldVsValue.put('updateMaintenanceTypeValue', dep_ple_List);

		//Accredition method
		string accrediation = accreditationValueReturn(recordId);
		fieldVsValue.put('accreditationValueReturn', accrediation);

		//Portfolio method
		string portfolio = portfolioValueReturn(recordId);
		fieldVsValue.put('portfolioValueReturn', portfolio);

		//Update Existing Maintenance Contracts
		if(fieldapinames.size() > 0){
			for(string field : fieldapinames){
	list<String> returnVal = updateExistingMaintContract(recordId, field.trim());
	
	fieldVsValue.put(field, returnVal);
			}
		}
		return fieldVsValue;
	}


}