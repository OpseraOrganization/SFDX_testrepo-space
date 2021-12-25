/**
 * @description	   : 
 * @author			: Lovek Panchal
 * @group			 : 
 * @last modified on  : 06-08-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date		 Author			   Modification
 * 1.0   06-08-2021   Lovel Panchal   Initial Version
**/
@isTest
public class NokiaCPQ_SitePhaseController_Test {
	@testSetup static void methodName() {
		// Create a test account
		List<Account> accounts=new List<Account>();
			Account testAcct = TestDataFactory.createAccount(1)[0];
			testAcct.AccountNumber='3011546567';
			testAcct.Acc_No__c = '3011546567';
			testAcct.CountryCode__c='IN';
			testAcct.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			accounts.add(testAcct);
		insert accounts;   
		// Creates first opportunity
		List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities.get(0).Lead_BG__c = 'MN';
		opportunities.get(0).RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		insert opportunities.get(0);
		List<product2> lstProduct = TestDataSetup.createCPQTestproduct(1);
		insert lstProduct;
		Apttus_Config2__PriceList__c objPriceList = TestDataSetup.createpriceListSO();
		insert objPriceList;
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = objPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = lstProduct[0].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		insert pLI1;
		Apttus_Proposal__Proposal__c objProposal = TestDataSetup.creatProposal(opportunities[0], testAcct, objPriceList);
		insert objProposal;
		Apttus_Config2__ProductConfiguration__c objProductConfiguration = TestDataSetup.creatProductConfiguration(testAcct, objPriceList, objProposal);
		insert objProductConfiguration;
		//List<Apttus_Config2__LineItem__c> objLineItem = TestDataSetup.creatConfigLineItem(testAcct, objProductConfiguration, objPriceList, lstProduct[0], 1);
		list<Apttus_Config2__LineItem__c> objLineItem = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=objProductConfiguration.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = objPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = lstProduct[0].Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = testAcct.Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem2;
		objLineItem.add(LineItem1);
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=objProductConfiguration.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = objPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = lstProduct[0].Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = testAcct.Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem2;
		objLineItem.add(LineItem2);
		insert objLineItem;
		NokiaCPQ_Phase__c objPhase = new NokiaCPQ_Phase__c();
		objPhase.Name = 'TestPhase';
		objPhase.Opportunity__c = opportunities[0].Id;
		Insert objPhase;
		NokiaCPQ_Site__c objSite = new NokiaCPQ_Site__c();
		objSite.Name = 'TestSite';
		objSite.Opportunity__c = opportunities[0].Id;
		Insert objSite;
		CPQ_Site_Phase_and_Quantity__c objSitePhase = new CPQ_Site_Phase_and_Quantity__c();
		objSitePhase.Name = 'TestSitPhase';
		objSitePhase.NCPQ_Phase__c = objPhase.Id;
		objSitePhase.NCPQ_Site__c =  objSite.Id;  
		objSitePhase.NCPQ_Quantity__c = 1;
		objSitePhase.Line_Item__c = objLineItem[0].Id;
		//objSitePhase.NCPQ_SiteUsesPhases__c = True ;
		insert objSitePhase;
	}
	static testMethod void getLineItemsTest() {
		Apttus_Config2__ProductConfiguration__c objProductConfiguration =[SELECT id,Apttus_Config2__AccountId__c FROM Apttus_Config2__ProductConfiguration__c LIMIT 1];
		NokiaCPQ_SitePhaseController.getLineItems(objProductConfiguration.Id);
		NokiaCPQ_SitePhaseController.getLineItems(objProductConfiguration.Apttus_Config2__AccountId__c);
	}
	
	static testMethod void saveTest(){
		List<CPQ_Site_Phase_and_Quantity__c> lstSitePhase = [Select Name,NCPQ_Phase__c,NCPQ_Phase__r.Name,NCPQ_Site__c,NCPQ_Site__r.Name,NCPQ_Quantity__c,Line_Item__c from CPQ_Site_Phase_and_Quantity__c ORDER BY NCPQ_Phase__c NULLS LAST];
		List<Map<string,object>> mapResponse = new List<Map<String,Object>>();
		//Negative Quantity
		Map<String,object> mObject = new Map<String,Object>();
		mObject.put('quantity',-10);
		mObject.put('siteId',lstSitePhase[0].NCPQ_Site__c);
		mObject.put('phaseId',lstSitePhase[0].NCPQ_Phase__c);
		mObject.put('siteName',lstSitePhase[0].NCPQ_Site__r.Name);
		mObject.put('phaseName',lstSitePhase[0].NCPQ_Phase__r.Name);
		mObject.put('lineItemId',lstSitePhase[0].Line_Item__c);
		mObject.put('prodName','Test3');
		mObject.put('recordId',lstSitePhase[0].Id);
		List<Id> lstDelete = new List<Id>{lstSitePhase[0].Id};
		mapResponse.add(mObject);
		NokiaCPQ_SitePhaseController.saveSitePhaseQuantityLineItem(mapResponse,lstDelete,true,true); 
		//Positive Quantity
		mapResponse = new List<Map<String,Object>>();
		//Negative Quantity
		mObject = new Map<String,Object>();
		mObject.put('quantity',0);
		mObject.put('siteId',lstSitePhase[0].NCPQ_Site__c);
		mObject.put('phaseId',lstSitePhase[0].NCPQ_Phase__c);
		mObject.put('siteName',lstSitePhase[0].NCPQ_Site__r.Name);
		mObject.put('phaseName',lstSitePhase[0].NCPQ_Phase__r.Name);
		mObject.put('lineItemId',lstSitePhase[0].Line_Item__c);
		mObject.put('prodName','Test3');
		mObject.put('recordId',lstSitePhase[0].Id);
		mapResponse.add(mObject);
		system.debug('mapResponse->' + mapResponse);
		NokiaCPQ_SitePhaseController.saveSitePhaseQuantityLineItem(mapResponse,null,true,true); 

		mapResponse = new List<Map<String,Object>>();
		//Negative Quantity
		mObject = new Map<String,Object>();
		mObject.put('quantity',10);
		mObject.put('siteId',lstSitePhase[0].NCPQ_Site__c);
		mObject.put('phaseId',lstSitePhase[0].NCPQ_Phase__c);
		mObject.put('siteName',lstSitePhase[0].NCPQ_Site__r.Name);
		mObject.put('phaseName',lstSitePhase[0].NCPQ_Phase__r.Name);
		mObject.put('lineItemId',lstSitePhase[0].Line_Item__c);
		mObject.put('prodName','Test3');
		mObject.put('recordId',lstSitePhase[0].Id);
		mapResponse.add(mObject);
		system.debug('mapResponse->' + mapResponse);
		NokiaCPQ_SitePhaseController.saveSitePhaseQuantityLineItem(mapResponse,null,true,true); 
		//Negative Delta
		// mObject = new Map<String,Object>();
		// mObject.put('quantity',-10);
		// mObject.put('siteId',lstSitePhase[0].NCPQ_Site__c);
		// mObject.put('phaseId',lstSitePhase[0].NCPQ_Phase__c);
		// mObject.put('siteName',lstSitePhase[0].NCPQ_Site__r.Name);
		// mObject.put('phaseName','Δ');
		// mObject.put('lineItemId',lstSitePhase[0].Line_Item__c);
		// mObject.put('prodName','Test1');
		// mapResponse.add(mObject);
		// //Positive Delta
		// mObject = new Map<String,Object>();
		// mObject.put('quantity',10);
		// mObject.put('siteId',lstSitePhase[0].NCPQ_Site__c);
		// mObject.put('phaseId',lstSitePhase[0].NCPQ_Phase__c);
		// mObject.put('siteName',lstSitePhase[0].NCPQ_Site__r.Name);
		// mObject.put('phaseName','Δ');
		// mObject.put('lineItemId',lstSitePhase[0].Line_Item__c);
		// mObject.put('prodName','Test1');
		// mapResponse.add(mObject);
		// // 0 Quantity
		// mObject = new Map<String,Object>();
		// mObject.put('quantity',0);
		// mObject.put('siteId',lstSitePhase[0].NCPQ_Site__c);
		// mObject.put('phaseId',lstSitePhase[0].NCPQ_Phase__c);
		// mObject.put('siteName',lstSitePhase[0].NCPQ_Site__r.Name);
		// mObject.put('phaseName',lstSitePhase[0].NCPQ_Phase__r.Name);
		// mObject.put('lineItemId',lstSitePhase[0].Line_Item__c);
		// mObject.put('prodName','Test');
		// mapResponse.add(mObject);
		// // 0 Quantity Delta
		// mObject = new Map<String,Object>();
		// mObject.put('quantity',0);
		// mObject.put('siteId',lstSitePhase[0].NCPQ_Site__c);
		// mObject.put('phaseId',lstSitePhase[0].NCPQ_Phase__c);
		// mObject.put('siteName',lstSitePhase[0].NCPQ_Site__r.Name);
		// mObject.put('phaseName','Δ');
		// mObject.put('lineItemId',lstSitePhase[0].Line_Item__c);
		// mObject.put('prodName','Test');
		// mapResponse.add(mObject);
		
		//NokiaCPQ_SitePhaseController.saveSitePhaseQuantityLineItem(mapResponse,lstDelete,true,true); 
		//NokiaCPQ_SitePhaseController.saveSitePhaseQuantity((Map<String,String>)mObject);
	}
	 /*static testMethod void saveSitePhaseTest(){
		 Apttus_Proposal__Proposal__c> Apttus_Proposal__Proposal__c = [Select Id,NokiaCPQ_Orignal_Quote_Id__c  from Apttus_Proposal__Proposal__c limit 1];
		 Map<Id,Apttus_Proposal__Proposal__c> mProposal = new Map<Id,Apttus_Proposal__Proposal__c>();  
		 mProposal.put(updateQte.Id,updateQte);
		 ProposalTriggerHelper.cloneQuote(mProposal);  
		 system.debug('proposalList-'+proposalList); 
	 }*/
}