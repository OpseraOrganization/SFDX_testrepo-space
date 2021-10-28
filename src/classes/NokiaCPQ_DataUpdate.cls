/**
 * @description	   : This is to execute any long running script for one time
 * @author			: Yashdeep Prajapati
 * @group			 : 
 * @last modified on  : 06-30-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date		 Author			   Modification
 * 1.0   06-24-2021   Yashdeep Prajapati   Initial Version
**/

public without sharing class NokiaCPQ_DataUpdate implements Database.Batchable<SObject>{
	List<Apttus_Config2__PriceList__c> priceListUpdate = new List<Apttus_Config2__PriceList__c>();
	List<Opportunity> opportunityUpdate = new List<Opportunity>();

	public Database.QueryLocator start(Database.BatchableContext BC)
	{
		return database.getQueryLocator('SELECT Id,NokiaCPQ_Region__c,Account.GEOLevel1ID__c, Contract_Price_List__c,Contract_Price_List__r.CPQ_Region__c FROM Opportunity WHERE AccountId != NULL AND Account.GEOLevel1ID__c != NULL AND RecordType.DeveloperName IN (\'Indirect_Record_Type\',\'Indirect_Sales_Opportunity_For_Partner\') AND NokiaCPQ_Region__c = NULL AND Account.Active__c = true'); 
		
	}
	 
	public void execute(Database.BatchableContext BC, List<Opportunity> data)	{
		system.debug('data size-->' + (data != null ? data.size() : 0 ));
		if(data != null && data.size() > 0){
			for(Opportunity opp : data){
				opportunityUpdate.add(new Opportunity(Id = opp.Id, NokiaCPQ_Region__c = opp.Account.GEOLevel1ID__c));
				if(opp.Contract_Price_List__c != null && opp.Contract_Price_List__r.CPQ_Region__c == null){
					priceListUpdate.add(new Apttus_Config2__PriceList__c(Id = opp.Contract_Price_List__c, CPQ_Region__c = opp.Account.GEOLevel1ID__c));
				}
			}
			system.debug('ManageAdditionalUserProfile: opportunityUpdate size-->' + opportunityUpdate.size());
			if(opportunityUpdate.size() > 0){
				Nokia_CPQ_Constants.isCloneRun = true;
				GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
				Database.update(opportunityUpdate, false);
			}
			
			system.debug('ManageAdditionalUserProfile: priceListUpdate size-->' + priceListUpdate.size());
			if(priceListUpdate.size() > 0){
				Database.update(priceListUpdate, false);
			}
		}
	}
	
	public void finish(Database.BatchableContext BC)
	{
		
	}
}