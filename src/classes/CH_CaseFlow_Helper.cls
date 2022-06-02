/****************************************
* Class Name : CH_CaseFlow_Helper
* Created Date: 8 May 2019
* Created By : Tiago Almeida (tiago.almeida@nokia.com)
* Last Modified by: Sónia Reis
* Last Modified Date: 10 October 2019
* Description : Controller Helper for all the Case Flows
* Test Class: 
*****************************************************/
public without sharing class CH_CaseFlow_Helper {
	public static final String LEGAL_ENTITY_REC_TYPE = 'Legal_Entity';
	
	public static List < Knowledge__kav > getArticles(){
		return [SELECT Id, ArticleNumber, UrlName, Title, LastModifiedDate, CH_KB_Products__c, Description__c, CH_PurposeRequired__c, CH_InformationForInternalAudiences__c, CH_QuestionOrProductDescription__c, CH_AnswerOrResolution__c, CH_ProblemDescriptionRequired__c
				FROM Knowledge__kav WHERE PublishStatus = 'Online' AND ValidationStatus = 'External Approved']; 
	}
	
	public static List < Account > getLegalEntities(String contactId, boolean swMaintenance){
		Set < Account > legalEntitySet = new Set < Account > ();
		if(String.isNotBlank(contactId)){
			// Get Account legal entity record type dev name
			Id legalEntRecTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get(LEGAL_ENTITY_REC_TYPE).getRecordTypeId();
			if(swMaintenance)
			for(EntitlementContact entCtt : [SELECT Entitlement.AccountId, Entitlement.Account.Name, Entitlement.Account.CH_CareContract__c, Entitlement.Account.OperationalCustomerName__c, Entitlement.Account.Acc_No__c, Entitlement.Account.AccountNumber, Entitlement.Account.CH_ParentAccountName__c , Entitlement.Account.CH_Account_Name_Alias__c
											 FROM EntitlementContact 
											 WHERE ContactId = :contactId 
											 AND Entitlement.ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true
											 AND Entitlement.ServiceContract.NCP_External_Status__c = 'Active'
											 AND Entitlement.Account.RecordTypeId = :legalEntRecTypeId
			AND Entitlement.Account.Type != 'Vendor']) {
												 if(entCtt.Entitlement != null && entCtt.Entitlement.Account != null) {
													legalEntitySet.add(entCtt.Entitlement.Account);													 
												 }
											 }	
			else
			// Get Legal entities based on EntitlementContact object
			for(EntitlementContact entCtt : [SELECT Entitlement.AccountId, Entitlement.Account.Name, Entitlement.Account.CH_CareContract__c, Entitlement.Account.OperationalCustomerName__c, Entitlement.Account.Acc_No__c, Entitlement.Account.AccountNumber, Entitlement.Account.CH_ParentAccountName__c , Entitlement.Account.CH_Account_Name_Alias__c
											 FROM EntitlementContact 
											 WHERE ContactId = :contactId 
											 AND Entitlement.ServiceContract.NCP_External_Status__c = 'Active'
											 AND Entitlement.Account.RecordTypeId = :legalEntRecTypeId
			AND Entitlement.Account.Type != 'Vendor']) {
												 if(entCtt.Entitlement != null && entCtt.Entitlement.Account != null) {
													legalEntitySet.add(entCtt.Entitlement.Account);													 
												 }
											 }
		}
		return new List < Account > (legalEntitySet);
	}
	  public static Id saveCase(String action, String oCase) {
		try {
			System.debug('### ' + oCase);
			List<Case> caseList = (List<Case>) JSON.deserialize(oCase, List<Case>.class);
			if(action.equals('insert')) insert caseList;
			else if(action.equals('upsert')) upsert caseList;
			else if(action.equals('update')) update caseList;
			return caseList[0].id;   
		} catch (Exception e) {
			system.debug('###Exception:' + e.getMessage());
			throw new AuraHandledException('Something went wrong! '+ e.getMessage());
		}
	}
	public static List < Asset > getAssets(String legalEntityId, String contactId, String serviceType, boolean swMaintenance) {
		Set < Asset > assetSet = new Set < Asset > ();		
		if(String.isNotBlank(contactId) && String.isNotBlank(legalEntityId)) {
			Set < Id > contractIds = new Set < Id > ();
			for(EntitlementContact entContactObj: [SELECT Entitlement.ServiceContractId FROM EntitlementContact WHERE ContactId = :contactId]) {
	contractIds.add(entContactObj.Entitlement.ServiceContractId);				
			}
			if(swMaintenance)
			for(ContractLineItem cliObj: [SELECT AssetId, Asset.Name, Asset.Product2Id, Asset.Product2.Name, Asset.Product2.Description, Asset.CH_Solution__c, Asset.CH_Solution__r.Name, Asset.CH_ProductVariant__c, Asset.CH_ProductVariant__r.Name, Asset.CH_ProductRelease__c, Asset.CH_ProductRelease__r.Name, Asset.CH_CountryISOName__c	
						 FROM ContractLineItem
						 WHERE ServiceContractId IN :contractIds
			 AND ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true
						 AND Asset.AccountId =:legalEntityId
						 AND NCP_External_Status__c = 'Active'
						 AND CH_ServiceType__c = :serviceType
						 ORDER BY Asset.Name]) {
							assetSet.add(cliObj.Asset);
						 }
			else
			for(ContractLineItem cliObj: [SELECT AssetId, Asset.Name, Asset.Product2Id, Asset.Product2.Name, Asset.Product2.Description, Asset.CH_Solution__c, Asset.CH_Solution__r.Name, Asset.CH_ProductVariant__c, Asset.CH_ProductVariant__r.Name, Asset.CH_ProductRelease__c, Asset.CH_ProductRelease__r.Name, Asset.CH_CountryISOName__c	
						 FROM ContractLineItem
						 WHERE ServiceContractId IN :contractIds
						 AND Asset.AccountId =:legalEntityId
						 AND NCP_External_Status__c = 'Active'
						 AND CH_ServiceType__c = :serviceType
						 ORDER BY Asset.Name]) {
							assetSet.add(cliObj.Asset);
						 }
		}
		return new List < Asset > (assetSet);
	}
	
	public static List < Entitlement > getEntitlements(String assetId, String contactId, String serviceType, boolean swMaintenance) {
		List < Entitlement > entitlementList = new List < Entitlement > ();
		if(String.isNotBlank(contactId) && String.isNotBlank(assetId)) {
			Set < Id > contractIds = new Set < Id > ();
			for(EntitlementContact entContactObj: [SELECT Entitlement.ServiceContractId FROM EntitlementContact WHERE ContactId = :contactId]) {
	contractIds.add(entContactObj.Entitlement.ServiceContractId);				
			}
			if(swMaintenance)
			entitlementList = [SELECT Id, Name, StartDate, EndDate, Status, Entitlement_Status__c, Type, 
				AccountId, Account.Name, AssetId, Asset.Name, 
				ServiceContractId, ServiceContract.Name, ServiceContract.CH_Project__c, ServiceContract.CH_EntitlementScript__c, ServiceContract.CH_CustomerContractNumber__c, 
				ContractLineItemId, ContractLineItem.CH_LineItemEntitlementScript__c, ContractLineItem.LineItemNumber, 
				ContractLineItem.CH_BusinessHour__c, ContractLineItem.CH_BusinessHour__r.Name 
							   FROM Entitlement
							   WHERE ServiceContractId IN :contractIds
							   AND ServiceContract.CH_PortalCaseCreationSWMaintenance__c = true
							   AND CH_RecordTypeCheck__c = true 
							   AND Status = 'Active'
							   AND ContractLineItem.CH_ServiceType__c = :serviceType
							   AND ContractLineItem.NCP_External_Status__c = 'Active'
							   AND Name != 'Authorized Contact'							   
							   AND AssetId =: assetId];	
			else
			entitlementList = [SELECT Id, Name, StartDate, EndDate, Status, Entitlement_Status__c, Type, 
				AccountId, Account.Name, AssetId, Asset.Name, 
				ServiceContractId, ServiceContract.Name, ServiceContract.CH_Project__c, ServiceContract.CH_EntitlementScript__c, ServiceContract.CH_CustomerContractNumber__c, 
				ContractLineItemId, ContractLineItem.CH_LineItemEntitlementScript__c, ContractLineItem.LineItemNumber, 
				ContractLineItem.CH_BusinessHour__c, ContractLineItem.CH_BusinessHour__r.Name, ServiceContract.CH_PortalCaseCreationSWMaintenance__c
							   FROM Entitlement
							   WHERE ServiceContractId IN :contractIds
							   AND CH_RecordTypeCheck__c = true 
							   AND Status = 'Active'
							   AND ContractLineItem.CH_ServiceType__c = :serviceType
							   AND ContractLineItem.NCP_External_Status__c = 'Active'
							   AND Name != 'Authorized Contact'							   
							   AND AssetId =: assetId];
		}
		return entitlementList;
	}
}