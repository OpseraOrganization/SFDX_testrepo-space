/**
 * @description	   : This is to execute any long running script for one time
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 03-16-2022
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log
 * Ver   Date		 Author			   Modification
 * 1.0   06-24-2021   Yashdeep Prajapati   Initial Version
 **/

public without sharing class NokiaCPQ_DataUpdate implements Database.Batchable<SObject>, Database.Stateful {
private String updateType;
public Set<string> recordsProcessed = new Set<string>();
public NokiaCPQ_DataUpdate(String updateType) {
	this.updateType = updateType;

}

private Database.QueryLocator getSobjectList(){
	System.debug('updateType-->' + updateType);
	String queryString;
	if(updateType == 'Apttus_Config2__LineItem__c') {
		queryString = 'SELECT Id,Apttus_Config2__ProductId__r.ProductCode, Portfolio_from_Quote_Line_Item__c,CPQ_ProductPortfolio__c,CPQ_MaintenancePortfolio__c,Is_Contract_Pricing_2__c,NokiaCPQ_Price_List_Type__c,Apttus_Config2__ChargeType__c,Apttus_Config2__BasePrice__c,Apttus_Config2__ListPrice__c,CPQ_ApplicableDiscount__c FROM Apttus_Config2__LineItem__c where  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c = \'Indirect CPQ\' AND (CPQ_ApplicableDiscount__c  = \'\' or CPQ_ApplicableDiscount__c  = null)';

	}  if(updateType == 'Apttus_Proposal__Proposal_Line_Item__c') {
		queryString = 'SELECT Id, Product_Portfolio__c,CPQ_MaintenancePortfolio__c,CPQ_ProductPortfolio__c,Apttus_Proposal__Proposal__r.NokiaCPQ_Portfolio__c FROM Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__r.Quote_Type__c = \'Indirect CPQ\' and (CPQ_ProductPortfolio__c = null OR CPQ_MaintenancePortfolio__c = null) and Apttus_Proposal__Proposal__r.NokiaCPQ_Portfolio__c != \'Fixed Networks\'';
	} if(updateType == 'Apttus_Proposal__Proposal__c') {
		String likeText1 = '%\\_;';
		String likeText2 = '%;';
		queryString = 'SELECT Id,NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Approval_Stage__c, NokiaCPQ_Needs_Reprice__c,NokiaCPQ_Portfolio__c,CPQ_SubPortfolio__c,NokiaCPQPricing_Cluster__c,CPQ_PortfolioClusterSF1__c, CPQ_PortfolioClusterSF2__c, CPQ_PortfolioClusterSF3__c, CPQ_PortfolioClusterSF4__c,(select Id,Apttus_QPConfig__Proposald__c,CPQ_PortfolioClusterSF1__c, CPQ_PortfolioClusterSF2__c, CPQ_PortfolioClusterSF3__c, CPQ_PortfolioClusterSF4__c from Apttus_QPConfig__Configurations__r)  from Apttus_Proposal__Proposal__c WHERE Quote_Type__c = \'Indirect CPQ\' and (CPQ_PortfolioClusterSF1__c = null OR CPQ_PortfolioClusterSF1__c = \'Not Applicable\' OR CPQ_PortfolioClusterSF1__c like :likeText1 OR CPQ_PortfolioClusterSF2__c like :likeText1 OR (NOT CPQ_PortfolioClusterSF1__c LIKE :likeText2))';
	}
	if (updateType == 'Attachment') {
		Set<String> attachToDeletelst = new Set<String> { '%PPA%','Maintenance Catalogue_%','Product Catalogue_%'};
		queryString = 'select Id,name,parentId,Parent.Name from Attachment where parent.type = \'Accreditation__c\' AND name LIKE:attachToDeletelst';

	}
	System.debug('queryString->'+queryString);

	return Database.getQueryLocator(queryString);
}

public Database.QueryLocator start(Database.BatchableContext BC)
{
	return getSobjectList();
}

public void execute(Database.BatchableContext BC, List<sObject> scope)	   {

	if(updateType == 'Apttus_Config2__LineItem__c') {
		List<Apttus_Config2__LineItem__c> updateLineItem = new List<Apttus_Config2__LineItem__c>();
		for(Apttus_Config2__LineItem__c lineItem: ((List<Apttus_Config2__LineItem__c>)scope)) {
			Apttus_Config2__LineItem__c newLineItem = new Apttus_Config2__LineItem__c();
			newLineItem.Id = lineItem.Id;
			//newLineItem.CPQ_ProductPortfolio__c = lineItem.Portfolio_from_Quote_Line_Item__c;
			//newLineItem.CPQ_MaintenancePortfolio__c = lineItem.Portfolio_from_Quote_Line_Item__c;
			if(!lineItem.Is_Contract_Pricing_2__c && String.isNotBlank(lineItem.CPQ_ProductPortfolio__c) && lineItem.CPQ_ProductPortfolio__c != 'FastMile' && lineItem.CPQ_ProductPortfolio__c != 'Nokia WIFI' && lineItem.Apttus_Config2__ChargeType__c != 'Maintenance Under Warranty' && lineItem.Apttus_Config2__ChargeType__c != 'Maintenance Beyond Warranty' && lineItem.Apttus_Config2__BasePrice__c > 0 && lineItem.Apttus_Config2__ListPrice__c > 0) {
	newLineItem.CPQ_ApplicableDiscount__c = 'DODDPD';
			}else{
	newLineItem.CPQ_ApplicableDiscount__c = '';
			}
			updateLineItem.add(newLineItem);
			//recordsProcessed.add(lineItem.Id);
		}

		UPDATESOBJ(updateLineItem,recordsProcessed);
	} if(updateType == 'Apttus_Proposal__Proposal_Line_Item__c') {
		List<Apttus_Proposal__Proposal_Line_Item__c> updateProposalLineItem = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		for(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem: ((List<Apttus_Proposal__Proposal_Line_Item__c>)scope)) {
			Apttus_Proposal__Proposal_Line_Item__c newPli = new Apttus_Proposal__Proposal_Line_Item__c();
			newPli.Id = proposalLineItem.Id;
			newPli.CPQ_ProductPortfolio__c = proposalLineItem.Apttus_Proposal__Proposal__r.NokiaCPQ_Portfolio__c;
			newPli.CPQ_MaintenancePortfolio__c = proposalLineItem.Apttus_Proposal__Proposal__r.NokiaCPQ_Portfolio__c;
			updateProposalLineItem.add(newPli);
			//recordsProcessed.add(proposalLineItem.Id);
		}

		//UPDATE updateProposalLineItem;
		UPDATESOBJ(updateProposalLineItem,recordsProcessed);
	}  if(updateType == 'Apttus_Proposal__Proposal__c') {
		set<string> fnPortfolios = new set<string> {'Fixed Access - POL','Fixed Access - FBA','FastMile'};
		List<Apttus_Proposal__Proposal__c> updateProposal = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus_Config2__ProductConfiguration__c> pcList = new List<Apttus_Config2__ProductConfiguration__c>();
		for(Apttus_Proposal__Proposal__c proposal: ((List<Apttus_Proposal__Proposal__c>)scope)) {


			if(proposal.NokiaCPQ_Needs_Reprice__c != TRUE && fnPortfolios.contains(proposal.NokiaCPQ_Portfolio__c)) {
	Apttus_Proposal__Proposal__c newProposal = new Apttus_Proposal__Proposal__c();
	newProposal.Id = proposal.Id;
	if(new List<string> {Nokia_CPQ_Constants.QUOTEAPPROVED,Nokia_CPQ_Constants.QUOTEEXPIRED,Nokia_CPQ_Constants.ACCEPTED_STRING, Nokia_CPQ_Constants.Closed_Not_Won}.indexOf(proposal.Apttus_Proposal__Approval_Stage__c) < 0) {
		newProposal.NokiaCPQ_Needs_Reprice__c = TRUE;
		recordsProcessed.add(proposal.NokiaCPQ_Proposal_Id__c);
	}
	updateProposal.add(newProposal);
			}
			else{
	updateProposal.add(proposal);

			}
			if(!proposal.Apttus_QPConfig__Configurations__r.isEmpty()) {
	pcList.addAll(proposal.Apttus_QPConfig__Configurations__r);
			}
		}
		//update cluster regardless of portfolio
		ProposalTriggerHelper.populateSearchClusterFields(updateProposal);

		system.debug('afterpopulateSearchClusterFields>>'+updateProposal);
		Nokia_CPQ_Constants.BYPASS_PROPOSAL_TRIGGER = true;
		//UPDATE updateProposal;
		UPDATESOBJ(updateProposal,recordsProcessed);
		system.debug('recordsProcessed>>'+recordsProcessed);
		if(!pcList.isEmpty()) {
			ProductConfigTriggerHelper.updateClusterSearchFieldsFromQuote(pcList);
		}
		Nokia_CPQ_Constants.BYPASS_PRODCONFIG_TRIGGER = true;
		//UPDATE pcList;
		UPDATESOBJ(pcList,recordsProcessed);
	}
	if(updateType == 'Attachment') {
		Set<Id> accIds = new Set<Id>();
		List<Attachment> attachToDeletelst = new List<Attachment>();
		for(Attachment att: ((List<Attachment>)scope)) {
			attachToDeletelst.add(att);
			accIds.add(att.ParentId);
		}
		DELETE attachToDeletelst;
		for (Accreditation__c acr : [SELECT ID, Partner__r.Name,Partner__r.AccountNumber FROM Accreditation__c WHERE ID IN :accIds]) {
			recordsProcessed.add(acr.Partner__r.AccountNumber + '~~' + acr.Partner__r.Name);
		}
	}
}

public void finish(Database.BatchableContext bc){
	AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bc.getJobId()];
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	String[] toAddresses = new String[] {'siva.kumar@standav.com','yashdeep.p@standav.com'};
	mail.setToAddresses(toAddresses);
	mail.setSubject('Data update completed for ' + updateType);
	mail.setPlainTextBody('Total Item Processed: ' + job.JobItemsProcessed +   'with '+ job.NumberOfErrors + ' failures.' + ' records: ' + (recordsProcessed.isEmpty() ? '' : string.join(new List<string> (recordsProcessed),';')));
	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}

public void UPDATESOBJ(List<sObject> recordsToUpdate,Set<string> recordsProcessed){
	if(!recordsToUpdate.isEmpty()) {
		Database.SaveResult[] updateResults = Database.update(recordsToUpdate, false);

		Integer i=0;
		for (Database.SaveResult sr : updateResults) {
			if (!sr.isSuccess()) {
	for(Database.Error err : sr.getErrors()) {
		System.debug(recordsToUpdate.get(i).Id + ': ' + err.getMessage());
		recordsProcessed.add(recordsToUpdate.get(i).Id + ' ERROR: ' + err.getMessage());
	}
			}
			i++;
		}
	}

}
}