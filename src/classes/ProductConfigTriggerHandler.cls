/*************************************************************
   @Name: ProductConfigTriggerHandler
   @Author: Accenture
   @Description: This class contains Logic for Product Configuration Triggers
 ******************************************************************/
public with sharing class ProductConfigTriggerHandler {
/************************
   @MethodName: afterUpdate
 *************************/
	public static void afterUpdate(List<Apttus_Config2__ProductConfiguration__c> newConfigList, List<Apttus_Config2__ProductConfiguration__c> oldConfigList){
	try{
		Set<String> associatedQuoteSet = new Set<String>();
		Set<Id> configIdSet = new Set<Id>();
		Integer i=0;
		List<Apttus_Proposal__Proposal__c> quotesToBeUpdatedList = new List<Apttus_Proposal__Proposal__c>();
		//system.debug('new config**' + newConfigList[i].Apttus_Config2__BusinessObjectType__c + oldConfigList[i].Apttus_Config2__Status__c + newConfigList[i].Apttus_Config2__Status__c);
		for(i=0; i< newConfigList.size(); i++) {
			if(newConfigList[i].Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) && newConfigList[i].Apttus_Config2__BusinessObjectType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PROPOSAL) && (newConfigList[i].Apttus_Config2__Status__c.equalsIgnoreCase(Nokia_CPQ_Constants.Saved) || newConfigList[i].Apttus_Config2__Status__c.equalsIgnoreCase(Nokia_CPQ_Constants.ApprovalRequired) || newConfigList[i].Apttus_Config2__Status__c.equalsIgnoreCase(Nokia_CPQ_Constants.PendingApproval))) {
	associatedQuoteSet.add(newConfigList[i].Apttus_QPConfig__Proposald__c);
			}
			if(newConfigList[i].NokiaCPQ_Quote_Opportunity_Changed__c && newConfigList[i].Quote_Type__c.contains('CPQ'))
			{
	configIdSet.add(newConfigList[i].Id);
			}
		}

		if(!associatedQuoteSet.isEmpty()) {
			for(Apttus_Proposal__Proposal__c quote : [Select id, Quote_Status__c from Apttus_Proposal__Proposal__c where Id IN:associatedQuoteSet]) {
	//system.debug('quote.Quote_Status__c** '+quote.Quote_Status__c+'cloned???'+quote.isClone());
	if(String.isNotBlank(quote.Quote_Status__c) && quote.Quote_Status__c.equalsIgnoreCase(Nokia_CPQ_Constants.Configure)) {
		quote.Quote_Status__c = Nokia_CPQ_Constants.NokiaCPQ_PRICE;
		quotesToBeUpdatedList.add(quote);
	}
			}
			if(!quotesToBeUpdatedList.isEmpty()) {
	Database.update(quotesToBeUpdatedList,false);
			}
		}
		if(!configIdSet.isEmpty())
		{
			ProductConfigTriggerHelper.clearSiteOnConfiguration(configIdSet);
		}
		//ADDED BY RG FOR GPP PRICING TOOL LOGIC

		if((checkRecursive.runOnce() && newConfigList[0].XAE_Flag__c != null) || test.isRunningTest()) {
			ProductConfigTriggerHelper.gPPPricingToolLogic(newConfigList);
			//   ProductConfigTriggerHelper.gPPPricingToolConstRule(newConfigList[0].id);
		}
	}

	Catch(Exception e){
		ExceptionHandler.addException(e,ProductConfigTriggerHandler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	}
	}
/************************************
 * Method :  afterUpdate_QTC
 * Paramater: newList,oldList
 * Comments: Used to Update Approval status of Quote to Draft after Cart is Approved
 * Created By: UKS 09-09-2019
 * ************************************/
public static void afterUpdate_QTC(List<Apttus_Config2__ProductConfiguration__c> newConfigList, List<Apttus_Config2__ProductConfiguration__c> oldConfigList){
	List<Apttus_Proposal__Proposal__c> quotesUpdateList = new List<Apttus_Proposal__Proposal__c>();
	Set<String> QuoteIdSet = new Set<String>();
	try{System.debug('Inside afterUpdate_QTC>>>>>>>>>>>>>>>>');
	 for(Apttus_Config2__ProductConfiguration__c config : newConfigList) {
	  if(config.Quote_Type__c=='Direct CPQ'&&config.NokiaCPQ_Portfolio_From_Quote__c=='QTC'&&config.Apttus_CQApprov__Approval_Status__c=='Approved')
	QuoteIdSet.add(config.Apttus_QPConfig__Proposald__c);
	 }
	 if(!QuoteIdSet.isEmpty())
	  for(Apttus_Proposal__Proposal__c quote : [Select id, Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where Id IN:QuoteIdSet]) {
	quote.Apttus_Proposal__Approval_Stage__c='Draft';
	quotesUpdateList.add(quote);
	  }
	 if(!quotesUpdateList.IsEmpty())
	  Database.update(quotesUpdateList, false); }
	catch(Exception ex) {
		System.debug('afterUpdate_QTC Exception::> '+ex.getCause()+ex.getMessage());
	}
}

/************************************
 * Method :  BeforeInsert
 * Paramater: List<Apttus_Config2__ProductConfiguration__c>
 * Comments: Used for before creation of Product Configuration
 * Created By: Piyush Tawari 26-09-2019
 * Nokia CPQ REQ:6624
 * ************************************/
public static void beforeInsert(List<Apttus_Config2__ProductConfiguration__c> prodConfigList)
{
	try{
		ProductConfigTriggerHelper.updateFieldsOnProdConfig(prodConfigList);
		//Added for ITCCPQ-2557 by Christie JJ
		ProductConfigTriggerHelper.updateClusterSearchFieldsFromQuote(prodConfigList);
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,ProductConfigTriggerHandler.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	}
}
/************************************
 * Method :  afterUpdate
 * Paramater: List<Apttus_Config2__ProductConfiguration__c>
 * Comments: Used for creation of site phase Quanity, Site Phase Configuration records
 * Created By: Nandeesh
 * Modifed by: Siva -ITCCPQ-1963(2187)
 * ************************************/
public static void cloneChildItems(List<Apttus_Config2__ProductConfiguration__c> config){

	//insert Site Phase Quantity records
	List<CPQ_Site_Phase_and_Quantity__c> sitePhaseRecs = [Select id, name,Line_Item__c,NCPQ_Phase__c,NCPQ_Quantity__c,NCPQ_Site__c,Line_Item__r.Apttus_Config2__LineNumber__c,Line_Item__r.Apttus_Config2__ProductId__c,Line_Item__r.Apttus_Config2__ProductOptionId__c from CPQ_Site_Phase_and_Quantity__c where Line_Item__r.Apttus_Config2__ConfigurationId__c = :config[0].id];
	if(config[0].Apttus_Config2__AncestorId__c!= null && sitePhaseRecs.isEmpty()) {
		insertSitePhaseQuan(config[0].Apttus_Config2__AncestorId__c, config[0].Id);
	}

	//insert Site Phase Configuration records
	Integer existingSitPhaseConfigCount = [Select count() from NokiaCPQ_Site_Phase_Configuration__c where NokiaCPQ_Configuration__c =:config[0].Id];
	if(config[0].Apttus_Config2__AncestorId__c != null && existingSitPhaseConfigCount == 0) {
		insertSitePhaseConfig(config[0].Apttus_Config2__AncestorId__c, config[0].Id);
	}
}

public static void insertSitePhaseConfig(Id configId, Id newConfigId){

	List<NokiaCPQ_Site_Phase_Configuration__c> configList = new List<NokiaCPQ_Site_Phase_Configuration__c>();
	system.debug('configId>>'+configId);
	system.debug('newConfigId>>'+newConfigId);
	for(NokiaCPQ_Site_Phase_Configuration__c configRec : [SELECT Id, NokiaCPQ_Phase__c, NokiaCPQ_Sequence__c, NokiaCPQ_Site__c, NokiaCPQ_Aggregator__c
				FROM NokiaCPQ_Site_Phase_Configuration__c
				WHERE NokiaCPQ_Configuration__c =: configId]) {
		configList.add(new NokiaCPQ_Site_Phase_Configuration__c(
	 NokiaCPQ_Configuration__c = newConfigId,
	 NokiaCPQ_Phase__c = configRec.NokiaCPQ_Phase__c,
	 NokiaCPQ_Sequence__c = configRec.NokiaCPQ_Sequence__c,
	 NokiaCPQ_Site__c = configRec.NokiaCPQ_Site__c,
	 NokiaCPQ_Aggregator__c = configRec.NokiaCPQ_Aggregator__c
	 )
	 );
	}
	if(!configList.isEmpty()) {
		Database.insert(configList,false);
	}
}

public static void insertSitePhaseQuan(Id ancestorConfigId, Id newConfigId){

	List<CPQ_Site_Phase_and_Quantity__c> insertsitephrecs= new List<CPQ_Site_Phase_and_Quantity__c>();
	Map<String,List<CPQ_Site_Phase_and_Quantity__c> > maplivaluesandsitephs = new Map<String,List<CPQ_Site_Phase_and_Quantity__c> >();
	List<CPQ_Site_Phase_and_Quantity__c> sitePhaseRec = [Select id, name,Line_Item__c,NCPQ_Phase__c,NCPQ_Quantity__c,NCPQ_Site__c,Line_Item__r.Apttus_Config2__LineNumber__c,Line_Item__r.Apttus_Config2__ProductId__c,Line_Item__r.Apttus_Config2__ProductOptionId__c from CPQ_Site_Phase_and_Quantity__c where Line_Item__r.Apttus_Config2__ConfigurationId__c =:ancestorConfigId];

	for(CPQ_Site_Phase_and_Quantity__c sitephs: sitePhaseRec) {
		String livalue=sitephs.Line_Item__r.Apttus_Config2__LineNumber__c +'-'+ sitephs.Line_Item__r.Apttus_Config2__ProductId__c +'-'+ sitephs.Line_Item__r.Apttus_Config2__ProductOptionId__c;

		if(!maplivaluesandsitephs.containsKey(livalue)) {
			maplivaluesandsitephs.put(livalue,new List<CPQ_Site_Phase_and_Quantity__c> {sitephs});
		}
		else{
			maplivaluesandsitephs.get(livalue).add(sitephs);
		}
	}
	System.debug('-----mapvalues--'+ maplivaluesandsitephs);

	List<Apttus_Config2__LineItem__c> newlis = [select id,name,Apttus_Config2__LineNumber__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductOptionId__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c= :newConfigId];
	//	 if(sitePhaseRec1.isEmpty()){
	for(Apttus_Config2__LineItem__c li:newlis) {
		String livalue=li.Apttus_Config2__LineNumber__c +'-'+ li.Apttus_Config2__ProductId__c +'-'+ li.Apttus_Config2__ProductOptionId__c;
		if(maplivaluesandsitephs.get(livalue) !=null) {
			for(CPQ_Site_Phase_and_Quantity__c recs: maplivaluesandsitephs.get(livalue)) {
	CPQ_Site_Phase_and_Quantity__c clonerecs = recs.clone(false,true);
	clonerecs.Line_Item__c= li.id;
	insertsitephrecs.add(clonerecs);

			}
		}
	}
	if(insertsitephrecs.size() >0) {
		Database.insert(insertsitephrecs,false);
	}

}
}