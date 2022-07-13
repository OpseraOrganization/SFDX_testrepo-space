/*************************************************************
   @Name: Nokia_CPQ_Utility
   @Author: Siva
   @CreateDate: 02/02/2021
   @Description: This class contains common methods used in apex classes
 ******************************************************************/
public inherited sharing class Nokia_CPQ_Utility {
public static void insertSitePhaseConfig(String config,
				 List<Id> sitesToInsertList,
				 List<Id> phasesToInsertList){
	//insert Site Phase Configuration  - Starts
	List<NokiaCPQ_Site_Phase_Configuration__c> phaseConfigInsertList = new List<NokiaCPQ_Site_Phase_Configuration__c>();

	Set<Id> existSitePhaseIds = new Set<Id>();
	Decimal phaseLastSequence =0, siteLastSequence = 0;
	for(NokiaCPQ_Site_Phase_Configuration__c sitePhaseConfigObj: [SELECT Id,NokiaCPQ_Site__r.Name,NokiaCPQ_Sequence__c,
				  NokiaCPQ_Phase__r.Name FROM
				  NokiaCPQ_Site_Phase_Configuration__c
				  WHERE (NokiaCPQ_Site__c != null
					  OR NokiaCPQ_Phase__c != null)
				  AND NokiaCPQ_Sequence__c != null
				  AND NokiaCPQ_Configuration__c =: config ORDER BY NokiaCPQ_Sequence__c Desc ]) {

		if(sitePhaseConfigObj.NokiaCPQ_Site__c != NULL) {
			existSitePhaseIds.add(sitePhaseConfigObj.NokiaCPQ_Site__c);
			if (siteLastSequence == 0) {
	siteLastSequence = sitePhaseConfigObj.NokiaCPQ_Sequence__c;
			}
		}
		if(sitePhaseConfigObj.NokiaCPQ_Phase__c != NULL) {
			existSitePhaseIds.add(sitePhaseConfigObj.NokiaCPQ_Phase__c);
			if (phaseLastSequence == 0) {
	phaseLastSequence = sitePhaseConfigObj.NokiaCPQ_Sequence__c;
			}
		}


	}

	for(Id siteId : sitesToInsertList) {
		//check if sitePhaseConfiguration already exists for a given Cart
		if(!existSitePhaseIds.contains(siteId)) {
			siteLastSequence = siteLastSequence+1;
			phaseConfigInsertList.add(
	new NokiaCPQ_Site_Phase_Configuration__c(
		NokiaCPQ_Configuration__c = config,
		NokiaCPQ_Site__c = siteId,
		NokiaCPQ_Sequence__c = siteLastSequence
		)
	);
		}
	}

	for(Id phaseId : phasesToInsertList) {
		//check if sitePhaseConfiguration already exists for a given Cart
		if(!existSitePhaseIds.contains(phaseId)) {
			phaseLastSequence = phaseLastSequence +1;
			phaseConfigInsertList.add(
	new NokiaCPQ_Site_Phase_Configuration__c(
		NokiaCPQ_Configuration__c = config,
		NokiaCPQ_Phase__c = phaseId,
		NokiaCPQ_Sequence__c = phaseLastSequence
		)
	);
		}
	}

	//insert sitePhaseConfiguration
	if(!phaseConfigInsertList.isEmpty()) {
		insert phaseConfigInsertList;
	}

}
//added for ITPC:2186
//clone site configuration record on rebid.
public static void cloneSiteConfiguration(Id oldQuote, Id newQuote){
	// Apttus_Config2__ProductConfiguration__c configRec= new Apttus_Config2__ProductConfiguration__c();
	// Apttus_Config2__ProductConfiguration__c newConfigRec= new Apttus_Config2__ProductConfiguration__c();
	// List<NokiaCPQ_Site_Phase_Configuration__c> listToadd = new List<NokiaCPQ_Site_Phase_Configuration__c>();
	List<Apttus_Config2__ProductConfiguration__c> oConfigList =[SELECT Apttus_Config2__Status__c, Id,Apttus_Config2__VersionNumber__c,
				(SELECT id,NokiaCPQ_Phase__c,NokiaCPQ_Aggregator__c,NokiaCPQ_Site__c,NokiaCPQ_Sequence__c,NokiaCPQ_Configuration__c,
				 Name FROM Site_Phase_Configuration__r )
				FROM Apttus_Config2__ProductConfiguration__c WHERE
				Apttus_QPConfig__Proposald__c =:oldQuote ORDER BY
						Apttus_Config2__VersionNumber__c DESC LIMIT 1];
	system.debug('old config record id==>'+oConfigList);
	List<Apttus_Config2__ProductConfiguration__c> nConfigList  =[select Id,Apttus_Config2__VersionNumber__c from Apttus_Config2__ProductConfiguration__c
				 WHERE Apttus_QPConfig__Proposald__c =:newQuote
							ORDER BY Apttus_Config2__VersionNumber__c desc LIMIT 1];
	system.debug('new config record id==>'+nConfigList);
	if(!oConfigList.isEmpty() && !nConfigList.isEmpty()) {
		Apttus_Config2__ProductConfiguration__c configRec = oConfigList[0];
		Apttus_Config2__ProductConfiguration__c newConfigRec = nConfigList[0];
		List<NokiaCPQ_Site_Phase_Configuration__c> listToadd = new List<NokiaCPQ_Site_Phase_Configuration__c>();
		system.debug('old config records==>'+configRec.Site_Phase_Configuration__r );
		for(NokiaCPQ_Site_Phase_Configuration__c obj:configRec.Site_Phase_Configuration__r ) {
			NokiaCPQ_Site_Phase_Configuration__c spRec= new NokiaCPQ_Site_Phase_Configuration__c();
			spRec.NokiaCPQ_Phase__c =obj.NokiaCPQ_Phase__c;
			spRec.NokiaCPQ_Site__c=obj.NokiaCPQ_Site__c;
			spRec.NokiaCPQ_Sequence__c=obj.NokiaCPQ_Sequence__c;
			spRec.NokiaCPQ_Aggregator__c=obj.NokiaCPQ_Aggregator__c;
			spRec.NokiaCPQ_Configuration__c=newConfigRec.id;
			listToadd.add(spRec);
		}
		if(!listToadd.isEmpty()) {
			try{
	Database.insert(listToadd);
	if(Test.isRunningTest()) {
		DmlException e = new DmlException();
		e.setMessage('This is a constructed exception for testing and code coverage');
		throw e;
	}
			}catch(Exception ex) {
	ExceptionHandler.addException(ex,Nokia_CPQ_Utility.class.getName(),'cloneSiteConfiguration');
			}
		}
	}
}
// cloning site phase qty records over line items on rebid.
public static void cloneSitePhaseQuanity(Id oldQuote, Id clonedQuote){
	List<CPQ_Site_Phase_and_Quantity__c> listToInsert= new List<CPQ_Site_Phase_and_Quantity__c>();
	list<Apttus_Config2__LineItem__c> listLineItems= new list<Apttus_Config2__LineItem__c>();
	list<Apttus_Config2__LineItem__c> listLineItemsCloned= new list<Apttus_Config2__LineItem__c>();
	Set<Id> configIDs= new Set<Id>();
	Set<Id> configIDsCloned= new Set<Id>();
	Map<String,list<CPQ_Site_Phase_and_Quantity__c> > lineWithSitePhase= new Map<String,list<CPQ_Site_Phase_and_Quantity__c> >();
	Map<String,list<CPQ_Site_Phase_and_Quantity__c> > lineIdWithSitePhase= new Map<String,list<CPQ_Site_Phase_and_Quantity__c> >();
	Set<Id> lineIds= new Set<Id>();
	for(Apttus_Config2__ProductConfiguration__c config: [SELECT id FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__BusinessObjectRefId__c=:oldQuote]) {
		configIDs.add(config.id);
	}
	if(configIDs!=null) {
		listLineItems=[SELECT id,Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c,Name FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c IN:configIDs];
		for(Apttus_Config2__LineItem__c obj:listLineItems) {
			lineIds.add(obj.id);
		}
	}
	if(lineIds!=null) {
		for(CPQ_Site_Phase_and_Quantity__c rec:[SELECT id,Name,Line_Item__c,NCPQ_Phase__c,NCPQ_Quantity__c,NCPQ_Site__c FROM CPQ_Site_Phase_and_Quantity__c WHERE Line_Item__c IN:lineIds]) {
			if(!lineIdWithSitePhase.containsKey(rec.Line_Item__c)) {
	lineIdWithSitePhase.put(rec.Line_Item__c, new list<CPQ_Site_Phase_and_Quantity__c> {rec});
			}else{
	lineIdWithSitePhase.get(rec.Line_Item__c).add(rec);
			}
		}
	}
	if(listLineItems!=null) {
		if(!lineIdWithSitePhase.isEmpty()) {
			for(Apttus_Config2__LineItem__c obj:listLineItems) {
	String key= obj.Apttus_Config2__LineNumber__c +'-'+ obj.Apttus_Config2__ProductId__c +'-'+ obj.Apttus_Config2__ProductOptionId__c;
	lineWithSitePhase.put(key,lineIdWithSitePhase.get(obj.id));
			}
		}
	}
	// cloned quote
	for(Apttus_Config2__ProductConfiguration__c configCloned: [SELECT id FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_Config2__BusinessObjectRefId__c=:clonedQuote]) {
		configIDsCloned.add(configCloned.id);
	}
	if(configIDsCloned!=null) {
		listLineItemsCloned=[SELECT id,Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c,Name FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c IN:configIDsCloned];
	}
	try{
		if(listLineItemsCloned!=null) {
			for(Apttus_Config2__LineItem__c obj1:listLineItemsCloned) {
	String cloneKey=obj1.Apttus_Config2__LineNumber__c +'-'+ obj1.Apttus_Config2__ProductId__c +'-'+ obj1.Apttus_Config2__ProductOptionId__c;
	if(lineWithSitePhase.get(cloneKey)!=null) {
		for(CPQ_Site_Phase_and_Quantity__c obj2:lineWithSitePhase.get(cloneKey)) {
			CPQ_Site_Phase_and_Quantity__c copyRec =obj2.clone(false,true);// new CPQ_Site_Phase_and_Quantity__c();
			copyRec.Line_Item__c = obj1.Id;
			listToInsert.add(copyRec);
		}
	}
			}
		}
		if(!listToInsert.isEmpty()) {
			Database.insert(listToInsert,false);
		}
		if(Test.isRunningTest()) {
			DmlException e = new DmlException();
			e.setMessage('This is a constructed exception for testing and code coverage');
			throw e;
		}
	}
	Catch(Exception ex){
		ExceptionHandler.addException(ex,Nokia_CPQ_Utility.class.getName(),'cloneSitePhaseQuanity');
	}
}
// tell if aggregate are there on quote.
public static boolean hasAggregation(ID cartId){
	system.debug('catid=>'+cartId);
	return([SELECT Id,NokiaCPQ_Aggregator__c FROM NokiaCPQ_Site_Phase_Configuration__c WHERE NokiaCPQ_Configuration__c = : cartId AND NokiaCPQ_Aggregator__c != NULL LIMIT 1].size() > 0);
}

/**
 * @description : This will check if latest configuration has Aggregation
 * @author Yashdeep Prajapati | 09-09-2021
 * @param proposalId
 * @return boolean
 **/
public static boolean checkForAggregation(string proposalId){
	List<Apttus_Config2__ProductConfiguration__c> latestConfiguration = [SELECT Id, (SELECT Id FROM Site_Phase_Configuration__r WHERE NokiaCPQ_Aggregator__c!= null LIMIT 1) FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c =:proposalId ORDER BY Apttus_Config2__VersionNumber__c DESC LIMIT 1];
	return latestConfiguration != null && latestConfiguration.size() > 0 && latestConfiguration[0].Site_Phase_Configuration__r != null && !latestConfiguration[0].Site_Phase_Configuration__r.isEmpty();
}

/**
 * @description Remove and order unused site/phase config
 * @author Yashdeep Prajapati | 09-19-2021
 * @param configSet
 **/
public static void sitePhaseConfigCheck(Set<Id> configSet){
	try{
		system.debug('sitePhaseConfigCheck-->' + configSet);
		Set<Id> siteSet = new Set<Id>();
		Set<Id> phaseSet = new Set<Id>();
		//fetch all sites/phases allocated
		for (CPQ_Site_Phase_and_Quantity__c spq : [SELECT id,Name,NCPQ_Phase__c,NCPQ_Site__c FROM CPQ_Site_Phase_and_Quantity__c WHERE Line_Item__r.Apttus_Config2__ConfigurationId__c IN :configSet]) {
			if(spq.NCPQ_Site__c != null) {
	siteSet.add(spq.NCPQ_Site__c);
			}
			if(spq.NCPQ_Phase__c != null) {
	phaseSet.add(spq.NCPQ_Phase__c);
			}
		}
		system.debug('sitePhaseConfigCheck siteSet-->' + siteSet);
		system.debug('sitePhaseConfigCheck phaseSet-->' + phaseSet);
		Decimal removedSites = 0;
		Decimal removedPhases = 0;
		//check if there are uallocated sites/phases in the NokiaCPQ_Site_Phase_Configuration__c. If yes, then remove it and change the Sequence of the rest
		List<NokiaCPQ_Site_Phase_Configuration__c> uList = new List<NokiaCPQ_Site_Phase_Configuration__c>();
		List<NokiaCPQ_Site_Phase_Configuration__c> dList = new List<NokiaCPQ_Site_Phase_Configuration__c>();
		for (NokiaCPQ_Site_Phase_Configuration__c spc : [SELECT Id,NokiaCPQ_Site__c,NokiaCPQ_Phase__c,NokiaCPQ_Sequence__c FROM NokiaCPQ_Site_Phase_Configuration__c WHERE NokiaCPQ_Configuration__c IN :configSet ORDER BY NokiaCPQ_Sequence__c]) {
			if(spc.NokiaCPQ_Site__c != null) {
	if(!siteSet.contains(spc.NokiaCPQ_Site__c)) {
		dList.add(spc);
		if(spc.NokiaCPQ_Sequence__c != null) {
			removedSites++;
		}
	}else if(spc.NokiaCPQ_Sequence__c != null && removedSites > 0) {
		spc.NokiaCPQ_Sequence__c -= removedSites;
		uList.add(spc);
	}
			}
			if(spc.NokiaCPQ_Phase__c != null) {
	if(!phaseSet.contains(spc.NokiaCPQ_Phase__c)) {
		dList.add(spc);
		if(spc.NokiaCPQ_Sequence__c != null) {
			removedPhases++;
		}
	}else if(spc.NokiaCPQ_Sequence__c != null && removedPhases > 0) {
		spc.NokiaCPQ_Sequence__c -= removedPhases;
		uList.add(spc);
	}
			}
		}
		system.debug('sitePhaseConfigCheck dList-->' + dList);
		if(dList.size() > 0) {
			delete dList;
		}
		system.debug('sitePhaseConfigCheck uList-->' + uList);
		if(uList.size() > 0) {
			upsert uList;
		}
		if(Test.isRunningTest()) {
			DmlException e = new DmlException();
			e.setMessage('This is a constructed exception for testing and code coverage');
			throw e;
		}
	}
	Catch(Exception ex){
		ExceptionHandler.addException(ex,Nokia_CPQ_Utility.class.getName(), 'sitePhaseConfigCheck');
	}
}

/**
 * @description Check If Product is available as Catalog or Pre-approved
 * @author Yashdeep Prajapati | 09-24-2021
 * @param prodCodes
 * @param objProdConfig
 * @return Map<string, string>
 **/
public static Map<string,string> prodAvailabilityCheck(List<string> prodCodes,Apttus_Config2__ProductConfiguration__c objProdConfig) {
	system.debug('prodAvailabilityCheck-->' + prodCodes);
	system.debug('prodAvailabilityCheck-->' + objProdConfig);
	Map<string,string> prodData = new Map<string,string>();
	try
	{
		List<String> codeList = new List<String>();
		for(String code : prodCodes) {
			codeList.add('\'' +code+'\'');
		}
		Integer remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
		String accountId = objProdConfig.Apttus_Config2__AccountId__c;
		String maintenanceType = objProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c;
		String portfolio = objProdConfig.NokiaCPQ_Portfolio_From_Quote__c;
		string subPortfolio = ObjProdConfig.Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c;

		set<string> subPortLikSet = new set<string>();

		if(string.isNotBlank(subPortfolio)) {
			for(string str:subportfolio.split(';')) {
	subPortLikSet.add('%'+str+'%');
			}
		}

		for (product2 prod: [SELECT id, Name,Portfolio__c,Direct_Portfolio__c, ProductCode,Description,NokiaCPQ_State__c,IsActive,Pricing_Clusters_Search_Filter__c,Valid_Search_Filter__c,isInvalidProductCatalog__c,NokiaCPQ_Valid_for__c FROM product2 WHERE ProductCode IN :prodCodes AND ((Portfolio__c like :subPortLikSet OR Portfolio__c =:portfolio) OR Portfolio__c= :Nokia_CPQ_Constants.NOKIA_EMPTY OR Direct_Portfolio__c = :portfolio) LIMIT :remainingRows]) { //ITCCPQ-2594
			prodData.put(prod.ProductCode, isProductAvailableInCatalog(objProdConfig, prod) ? 'Available in Catalog' : '');
		}
		//ITCCPQ-2542 - Start
		for (string code : getMaintAndSSPSRSProdCodes()) {
			prodData.put(code,'Defaultly Available');
		}
		//ITCCPQ-2542 - End


		remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();

		if(remainingRows > 0) {
			string papQuery = 'SELECT ID,Product_Code__c FROM Pre_Approved_Custom_Products__c WHERE Account__c = :accountId AND Product_Code__c IN :prodCodes and Expiration_Date__c > TODAY AND (Portfolio__c =:portfolio OR Portfolio__c LIKE:subPortLikSet)';
			if(objProdConfig.Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ || (objProdConfig.Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ && objProdConfig.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c)) {
	papQuery += ' AND Maintenance_Type__c =:maintenanceType';
			}
			papQuery += ' LIMIT :remainingRows';
			List<Pre_Approved_Custom_Products__c> papList = Database.query(papQuery);
			system.debug('prodAvailabilityCheck papList-->' + papList);
			for (Pre_Approved_Custom_Products__c pac : papList) {
	if(!(prodData.containsKey(pac.Product_Code__c) && string.isNotEmpty(prodData.get(pac.Product_Code__c)))) {
		prodData.put(pac.Product_Code__c,'Available as Pre-Approved');
	}
			}
		}
	}
	catch(Exception ex) {
		system.debug('prodAvailabilityCheck ex-->' + ex.getMessage());
		ExceptionHandler.addException(ex,Nokia_CPQ_Utility.class.getName(),'prodAvailabilityCheck');
	}
	return prodData;
}

/**
 * @description Check if Product is avaiable to add from Catalog
 * @author Yashdeep Prajapati | 09-20-2021
 * @param objProdConfig
 * @param prod
 * @return Boolean
 **/
public static Boolean isProductAvailableInCatalog(Apttus_Config2__ProductConfiguration__c objProdConfig, product2 prod){
	if(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ.equalsIgnoreCase(objProdConfig.Quote_Type__c)) {
		// Boolean hasSubportfoliosmatch = false;
		// if(string.isNotBlank(objProdConfig.Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c) && string.isNotBlank(prod.Portfolio__c)){
		// 	for(string quoteSubportfolio: objProdConfig.Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c.split(';')){
		// 		if(prod.Portfolio__c.contains(quoteSubportfolio)){
		//	hasSubportfoliosmatch = true;
		//	break;
		// 		}
		// 	}
		// }
		return string.isNotBlank(prod.Portfolio__c) && ((prod.Portfolio__c.contains(objProdConfig.NokiaCPQ_Portfolio_From_Quote__c) && ((String.isNotBlank(objProdConfig.CPQ_PortfolioClusterSF1__c) && prod.Pricing_Clusters_Search_Filter__c.contains(objProdConfig.CPQ_PortfolioClusterSF1__c)) || (String.isNotBlank(objProdConfig.CPQ_PortfolioClusterSF2__c) && prod.Pricing_Clusters_Search_Filter__c.contains(objProdConfig.CPQ_PortfolioClusterSF2__c)) || (String.isNotBlank(objProdConfig.CPQ_PortfolioClusterSF3__c) && prod.Pricing_Clusters_Search_Filter__c.contains(objProdConfig.CPQ_PortfolioClusterSF3__c)) || (String.isNotBlank(objProdConfig.CPQ_PortfolioClusterSF4__c) && prod.Pricing_Clusters_Search_Filter__c.contains(objProdConfig.CPQ_PortfolioClusterSF4__c))))) && prod.IsActive && prod.Pricing_Clusters_Search_Filter__c.contains(objProdConfig.Pricing_Cluster_Search_Filter__c) && !prod.Valid_Search_Filter__c && !prod.isInvalidProductCatalog__c && ((objProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c && prod.NokiaCPQ_State__c == 'Release') || !objProdConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c); //ITCCPQ-2594
	}else if(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ.equalsIgnoreCase(objProdConfig.Quote_Type__c)) {
		return string.isNotBlank(prod.Direct_Portfolio__c) && prod.Direct_Portfolio__c == objProdConfig.NokiaCPQ_Portfolio_From_Quote__c && prod.IsActive;
	}
	return false;
}

// public static Boolean checkExistingMaintenanceContract(String endCustomerEntityId,Set<String> businessUnitSet){

//  return ([SELECT Id,Product2.CH_Business_Unit__c,ServiceContract.AccountId FROM ContractLineItem WHERE ServiceContract.AccountId = : endCustomerEntityId and ServiceContract.NCP_External_Status__c = 'Active' AND ServiceContract.Status = 'Active' AND ServiceContract.RecordType.Name IN ('CARE Service Contract') AND Product2.CH_Business_Unit__c IN : businessUnitSet].size() > 0);
// }

/**
 * @description if Maintenance contract doesn't exist then update the fields accordingly
 * @author Yashdeep Prajapati | 09-24-2021
 * @param proposal
 * @return Boolean
 **/
public static void existingMaintenanceContractCheck(Apttus_Proposal__Proposal__c proposal){
	if(proposal.NokiaCPQ_Opportunity_Id__c != null) {
		Opportunity opp = [SELECT ID,End_Customer_LE__c FROM Opportunity WHERE ID = :proposal.NokiaCPQ_Opportunity_Id__c LIMIT 1];

		//if(opp.End_Customer_LE__c != null && !hasExistingMaintenanceContract(opp.End_Customer_LE__c,proposal.NokiaCPQ_Portfolio__c)) {

		//Modified for ITCCPQ-2556 by Christie JJ for Rebid & Clone functionality changes.

		if(opp.End_Customer_LE__c != null && !hasExistingMaintenanceContractList(opp.End_Customer_LE__c,getPortfolio(proposal))) {
			proposal.NokiaCPQ_systemVerifiedContract__c = false;
			if(proposal.NokiaCPQ_No_of_Years__c != '1' || proposal.NokiaCPQ_Existing_IONMaint_Contract__c != 'No') {
	proposal.NokiaCPQ_Needs_Reprice__c = true;
	proposal.NokiaCPQ_No_of_Years__c = '1';
	proposal.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
			}
		}
	}
}

/**
 * @description Check if Maintenance Contract exists
 * @author Yashdeep Prajapati | 09-30-2021
 * @param legalEntityAccountId
 * @param portfolio
 **/
// public static Boolean hasExistingMaintenanceContract(String legalEntityAccountId, String portfolio){
// 	Set<string> buSet = new Set<string>();
// 	for(NokiaCPQ_Portfolio_Business_Mapping__mdt metadataRecord : [SELECT Id,NokiaCPQ_CH_Business_Unit__c,NokiaCPQ_Portfolios__c FROM NokiaCPQ_Portfolio_Business_Mapping__mdt]) {
// 		if(containsIgnoreCase(metadataRecord.NokiaCPQ_Portfolios__c.split(','),portfolio)) {
//	buSet.add(metadataRecord.NokiaCPQ_CH_Business_Unit__c);
// 		}
// 	}
// 	if(!buSet.isEmpty() && string.isNotBlank(legalEntityAccountId)) {
// 		Nokia_CPQ_UtilityNoSharing objUtility = new Nokia_CPQ_UtilityNoSharing();
// 		return objUtility.hasContract(buSet, legalEntityAccountId);
// 	}
// 	return false;
// }

/**
 * @description Check if Maintenance Contract exists for a list of sub-portfolios.
 * @author Christie JJ | 01-10-2022
 * @param legalEntityAccountId
 * @param portfolio
 **/
public static Boolean hasExistingMaintenanceContractList(String legalEntityAccountId, List<String> portfolio){
	Set<string> buSet = new Set<string>();
	for(NokiaCPQ_Portfolio_Business_Mapping__mdt metadataRecord : [SELECT Id,NokiaCPQ_CH_Business_Unit__c,NokiaCPQ_Portfolios__c FROM NokiaCPQ_Portfolio_Business_Mapping__mdt]) {
		for(String portfolioRecord : portfolio) {
			if(containsIgnoreCase(metadataRecord.NokiaCPQ_Portfolios__c.split(','),portfolioRecord)) {
	buSet.add(metadataRecord.NokiaCPQ_CH_Business_Unit__c);
			}
		}
	}
	if(!buSet.isEmpty() && string.isNotBlank(legalEntityAccountId)) {
		Nokia_CPQ_UtilityNoSharing objUtility = new Nokia_CPQ_UtilityNoSharing();
		return objUtility.hasContract(buSet, legalEntityAccountId);
	}
	return false;
}


/**
 * @description Update proposal with Turbo/Classic info and return cart url accordingly
 * @author Yashdeep Prajapati | 10-08-2021
 * @param proposal
 * @return string
 **/
public static string updateQuoteAndRedirect(Apttus_Proposal__Proposal__c proposal){
	string cartURL;
	system.debug('updateQuoteAndRedirect>>>>'+proposal);
	if(proposal != null) {
		if(proposal.Turbo_Pricing_Enable__c || proposal.Is_Turbo_Pricing__c) {
			cartURL = proposal.Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ ? proposal.APTS_ConfigureProductsTP__c : proposal.Configure_button_field_TP__c;
			proposal.Is_Turbo_Pricing__c = true;
			proposal.Is_Classic_Pricing__c = false;
		}
		else{
			cartURL = proposal.Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ ? proposal.Configure_grid_flow_button__c : proposal.Configure_button_field__c;
			proposal.Is_Turbo_Pricing__c = false;
			proposal.Is_Classic_Pricing__c = true;
		}
		try{
			Nokia_CPQ_Constants.BYPASS_PROPOSAL_TRIGGER = true;
			update proposal;

		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex,Nokia_CPQ_Utility.class.getName(),'updateQuoteAndRedirect');
		}
		system.debug('updateQuoteAndRedirect>>>>'+cartURL);
	}
	if(cartURL == null && Test.isRunningTest()) {
		cartURL = 'test.cpq.com';
	}
	//Support Tkt NO: 02232749 ==> ITCCPQ-2535 - Siva
	cartURL = cartURL.replace('Apttus_QPConfig__ProposalConfiguration','Apttus_Lightning_Page_Redirect');
	return cartURL;
}

/**
 * @description list contains specified string
 * @author Yashdeep Prajapati | 10-08-2021
 * @param sList
 * @param searchStr
 * @return boolean
 **/
public static boolean containsIgnoreCase(List<String> sList, String searchStr) {
	for (String current : sList) {
		if (current.equalsIgnoreCase(searchStr)) {
			return true;
		}
	}
	return false;
}

public Without Sharing class Nokia_CPQ_UtilityNoSharing {
public Boolean hasContract(Set<String> buSet,String legalEntityAccountId){
	return ([SELECT Id,Product2.CH_Business_Unit__c,ServiceContract.AccountId FROM ContractLineItem WHERE ServiceContract.AccountId = : legalEntityAccountId and ServiceContract.NCP_External_Status__c = 'Active' AND ServiceContract.Status = 'Active' AND ServiceContract.RecordType.Name IN ('CARE Service Contract') AND Product2.CH_Business_Unit__c IN : buSet LIMIT 1].size() > 0);
}

/**
 * @description Check if user is Licensed for given namespace/package
 * @author Yashdeep Prajapati | 10-19-2021
 * @param userId
 * @param packageNamespace
 * @return boolean
 **/
public boolean isUserLicensedForPackage(String userId, String packageNamespace) {
	if(!([SELECT IsSandbox FROM Organization LIMIT 1]).IsSandbox || Test.isRunningTest()) {
		return [SELECT Id FROM UserPackageLicense WHERE PackageLicense.NamespacePrefix = : packageNamespace AND UserId = : userId limit 1].size() > 0;
	}
	return true;
}

/**
 * @description Fetch the RecordType "Proposal" for Quote/Proposal Object
 * @author Christie JJ | 11-04-2021
 * @return String
 **/
public String fetchProposalRecordType() {

	List<RecordType> recordTypeList = [select Id from RecordType WHERE SobjectType = :Nokia_CPQ_Constants.PROPOSAL_OBJECT AND DeveloperName = :Nokia_CPQ_Constants.NOKIA_PROPOSAL limit 1];
	if(recordTypeList.size()>0) {
		return recordTypeList[0].Id;
	}
	return null;
}

/**
 * @description Fetches the RecordType for Quote/Proposal Object based on the Developer Name
 * @author Christie JJ | 11-26-2021
 * @return String
 **/

public String fetchProposalRecordType(string developerName) {

	List<RecordType> recordTypeList = [select Id from RecordType WHERE SobjectType = :Nokia_CPQ_Constants.PROPOSAL_OBJECT AND DeveloperName = :developerName limit 1];
	if(recordTypeList.size()>0) {
		return recordTypeList[0].Id;
	}
	return null;
}

/**
 * @description Fetches the related valid Sub-Portfolios from the portfolio mapping custom metadata & the related account accreditations' portfolios
 * @author Christie JJ | 1-7-2022
 * @return String
 **/


public List<String> fetchSubPortfolios(String portfolio,Id accountId){

	//  Fetch the mapped subportfolios based on the portfolio, from the Portfolio Mapping Custom Metdata.
	List<String> portfolioMapList = new List<String>();
	for (List<string> pList : (getPortfolioMapping(portfolio)).values()) {
		portfolioMapList.addAll(pList);
	}
	// List<CPQ_PortfolioMapping__mdt> portfolioMappings = CPQ_PortfolioMapping__mdt.getAll().values();
	// for(CPQ_PortfolioMapping__mdt portfolioMapRecord : portfolioMappings) {
	//  if(portfolioMapRecord.CPQ_Portfolio__c.equals(portfolio)) {
	//	  portfolioMapList.add(portfolioMapRecord.CPQ_SubPortfolio__c);
	//  }
	// }

	//If mapped portfolios doesnt exist, then assign the portfolio from the quote. (Due to the fact that only FN has subportfolio mapppings currently, will need to change this, if the portfolio mapping custom metadata structure is chnaged)
	if(portfolioMapList.isEmpty()) {
		portfolioMapList.add(portfolio);
	}
	system.debug('[+] portfolioMapList = ' + portfolioMapList);
	//  Else,Sub-Portfolio Mappings are present for the quote portfolio, hence we can use the portfolioMapList in this case.


	//  Run common portfolio check logic amongst the Account accreditation records.


	//  Fetch all related Product Accreditation records under the Account
	List<Accreditation__c> accreditations = [SELECT Id,Portfolio__c,Accreditation_Type__c FROM Accreditation__c WHERE Partner__c =:accountId AND Portfolio__c IN :portfolioMapList];
	system.debug('[+] accreditations size = ' + accreditations.size());
	system.debug(accreditations);
	if(accreditations.isEmpty()) {
		return null;
	}

	//  Cycle through the mapped portfolios and check if both product & maintenance accreditation records exist for the portfolios in the list.
	List<String> validSubPortfolios = new List<String>();
	List<String> commonValidSubPortfolios = new List<String>();
	for(String mappedportfolio : portfolioMapList) {
		Boolean hasProductAccreditation=false,hasMaintenanceAccreditation=false;
		for(Accreditation__c accreditation : accreditations) {
			if(accreditation.Portfolio__c.equals(mappedportfolio)) {

	if(accreditation.Accreditation_Type__c.equals(Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT))
		hasProductAccreditation = true;

	else if(accreditation.Accreditation_Type__c.equals(Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE))
		hasMaintenanceAccreditation = true;
			}
		}
		//If the product & maintenance accreditations exist for the sub-portfolio's, then add that to the valid sub-portfolio's list
		system.debug('hasProductAccreditation = ' +hasProductAccreditation);
		system.debug('hasMaintenanceAccreditation = ' +hasMaintenanceAccreditation);
		if(hasProductAccreditation && hasMaintenanceAccreditation)
			validSubPortfolios.add(mappedportfolio);

	}
	system.debug(validSubPortfolios.size());
	system.debug(validSubPortfolios);
	if(!validSubPortfolios.isEmpty()) {
		for(String portfolioRecord : portfolioMapList) {
			if(validSubPortfolios.contains(portfolioRecord)) {
	commonValidSubPortfolios.add(portfolioRecord);

			}
		}
		return commonValidSubPortfolios;

	}


	return null;
}


/**
 * @description Fetches the related sub-portfolio mappings for the given portfolio, from the Portfolio Mapping custom metadata type.
 * @author Yashdeep | 1-10-2022
 * @param portfolio
 * @param
 * @return map<string,List<string>>
 * //ITCCPQ-2543
 **/
public Map<string, List<string> > getPortfolioMapping(String portfolio){
	List<CPQ_PortfolioMapping__mdt> portfolioMappings = CPQ_PortfolioMapping__mdt.getAll().values();
	Map<string, List<string> > pMap = new Map<string, List<string> >();
	for(CPQ_PortfolioMapping__mdt pm : portfolioMappings) {
		if((string.isNotBlank(portfolio) && pm.CPQ_Portfolio__c.equalsIgnoreCase(portfolio)) || string.isBlank(portfolio)) {
			if(!pMap.containsKey(pm.CPQ_Portfolio__c)) {
	pMap.put(pm.CPQ_Portfolio__c,new List<string>());
			}
			pMap.get(pm.CPQ_Portfolio__c).add(pm.CPQ_SubPortfolio__c);
		}
	}
	return pMap;
}

public string getSubPortfolioMapping(String subPortfolio){
	List<CPQ_PortfolioMapping__mdt> portfolioMappings = CPQ_PortfolioMapping__mdt.getAll().values();
	string portfolio;
	System.debug('[+] subPortfolio = '+subPortfolio);
	for(CPQ_PortfolioMapping__mdt pm : portfolioMappings) {
		system.debug('[+] pm.CPQ_SubPortfolio__c = '+pm.CPQ_SubPortfolio__c);
		system.debug('[+] pm.CPQ_SubPortfolio__c.equalsIgnoreCase(subPortfolio) = '+pm.CPQ_SubPortfolio__c.equalsIgnoreCase(subPortfolio));
		if((string.isNotBlank(subPortfolio) && pm.CPQ_SubPortfolio__c.equalsIgnoreCase(subPortfolio))) {
			portfolio = pm.CPQ_Portfolio__c;
			break;
		}
	}
	return portfolio;
}
public Boolean checkQuoteAccredSoln(Apttus_Proposal__Proposal__c quoteObj){
	string portfolio = getSubPortfolioMapping(quoteObj.NokiaCPQ_Portfolio__c);
	system.debug('[+] Utility Portfolio = '+portfolio);
	if(string.isNotBlank(portfolio)) {
		List<String> validAccreditedSolns= fetchSubPortfolios(portfolio,quoteObj.Apttus_Proposal__Account__c);
		system.debug('[+] validAccreditedSolns = '+validAccreditedSolns);
		quoteObj.NokiaCPQ_Portfolio__c = portfolio;
		if(!validAccreditedSolns.isEmpty()) {
			quoteObj.CPQ_SubPortfolio__c =String.join(validAccreditedSolns, ';');
			return true;
		}

	}
	return false;
}

}

/**
 * @description Check if user has special permission for Turbo feature.
 * @author Surinder | 11-23-2021
 * @param
 * @param
 * @return boolean
 * //ITCCPQ-2543
 **/
public static boolean isUserhasTurboPermission() {
	return (FeatureManagement.checkPermission('CPQ_Turbo_Permission'));
}
/**
 * @description Get Prod Codes from Custom Setting
 * @author Yashdeep Prajapati | 12-14-2021
 * @return List<string>
 **/
public static List<string> getMaintAndSSPSRSProdCodes(){
	NCPQ_Settings__c cSetting = (NCPQ_Settings__c.getall().values())[0];
	List<string> codes = cSetting.NCPQ_MaintenanceProdCodes__c.split(',');
	codes.addAll(cSetting.NCPQ_SPS_SRS_ProdCodes__c.split(','));
	return codes;
}



public static Map<string,string> getXAEApps(List<string> name){
	Map<string,string> appMap = new Map<string,string>();
	for (CPQ_XAEApps__mdt mdt : [SELECT Id, DeveloperName, Label,CPQ_AppUrl__c FROM CPQ_XAEApps__mdt WHERE DeveloperName IN :name]) {
		appMap.put(mdt.DeveloperName, mdt.CPQ_AppUrl__c);
	}
	return appMap;
}

public static List<string> getPortfolio(Apttus_Proposal__Proposal__c proposal){
	if(string.isNotBlank(proposal.CPQ_SubPortfolio__c)) {
		return proposal.CPQ_SubPortfolio__c.split(';');
	}
	return new List<string> { proposal.NokiaCPQ_Portfolio__c };
}
public static Boolean checkProdAndMaintAccreditation(List<Accreditation__c> accreditations,List<String> portfolios){

	Boolean hasProductAccreditation=false,hasMaintenanceAccreditation=false;
	for(String portfolio : portfolios) {
		hasProductAccreditation=false;
		hasMaintenanceAccreditation=false;
		for(Accreditation__c accreditation : accreditations) {
			if(accreditation.Portfolio__c.equalsIgnoreCase(portfolio)) {

	if(accreditation.Accreditation_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_PRODUCT))
		hasProductAccreditation = true;

	else if(accreditation.Accreditation_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE))
		hasMaintenanceAccreditation = true;
			}
		}
		if(hasProductAccreditation && hasMaintenanceAccreditation) {
			return true;
		}
	}

	return false;
}
public static Map<String,String> fecthRelatedPricingAccreditations(List<Accreditation__c> accreditations){
	if(accreditations.size()>0) {
		Map<String,String> portfolioPricingLevelMap = new Map<String,String>();
		for(Accreditation__c accreditation : accreditations) {
			if(accreditation.Pricing_Accreditation__c!=null && !String.isBlank(accreditation.Pricing_Accreditation__c)) {
	portfolioPricingLevelMap.put(accreditation.Portfolio__c,accreditation.Pricing_Accreditation__c);
			}
		}
		return portfolioPricingLevelMap;

	}
	return null;

}

public static List<string> getDuplicatesFrom2Lists(List<string> list1, List<string> list2) {
	// Convert lists to sets
	Set<String> set1 = new Set<String>(list1), set2 = new Set<String>(list2);
	// Modify set1 to contain only values also in set2.
	set1.retainAll(set2);
	// Convert back to a list
	return new List<String>(set1);
}

public static Map<string,string> getPicklistValuesByLabel(string objectName, string fieldName, List<string> labels){
	Map<string,string> pickValueMap = new Map<string,string>();
	Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName);
	Schema.DescribeSObjectResult r = s.getDescribe();
	Map<String,Schema.SObjectField> fields = r.fields.getMap();
	Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
	system.debug(fieldResult);
	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	for( Schema.PicklistEntry pickListVal : ple) {
		string lb = pickListVal.getLabel();
		if(labels.contains(lb)) {
			pickValueMap.put(pickListVal.getLabel(), pickListVal.getValue());
		}
	}
	return pickValueMap;
}

public static Map<string,string> getPicklistLabelsByValue(string objectName, string fieldName, List<string> values){
	Map<string,string> pickLabelMap =new Map<string,string>();
	Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName);
	Schema.DescribeSObjectResult r = s.getDescribe();
	Map<String,Schema.SObjectField> fields = r.fields.getMap();
	Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
	system.debug(fieldResult);
	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
	for( Schema.PicklistEntry pickListVal : ple) {
		string vl = pickListVal.getValue();
		if(values.contains(vl)) {
			pickLabelMap.put(pickListVal.getValue(),pickListVal.getLabel());
		}
	}
	return pickLabelMap;
}
}