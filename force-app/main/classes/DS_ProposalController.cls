/**
 * About
 * -----
 * @Description	  : This class contains all the needed functions to handle Commercial Proposals (Quotes) List View
 * @TestClass		: DS_ProposalControllerTest.
 * @Project		  : Digital Sales QtOv.
 * @Modification Log :
 *  Created  : 2019 10 30 – gyorgyi.kovacs@nokia.com
 *  Modified : 2020 04 22 - gyorgyi.kovacs@nokia.com
 * -----
**/
public with sharing class DS_ProposalController {

	/**
	* @description : This function retrieves all the Commercial Proposals (Quotes) available for the logged in User
	* @return	  : List<DS_ProposalWrapper> List of DS_ProposalWrapper structure containing all the necessary data to be displayed in the Component
	*/
	@AuraEnabled (cacheable=true)
	public static List<DS_ProposalWrapper> getCommercialProposalList() {
		Boolean isCustomerPortalUser = DS_ProposalUtil.getCurrentUser().Profile.Name.equals(GlobalConstants.PROFILE_DS_SALES_CUST);
		List<DS_ProposalWrapper> proposalWrapperList = new List<DS_ProposalWrapper>();

		//every accessible Quotes and Customer Facing Attributes are displayed to logged in user (Project Mode, Direct DS Quote/Indirect DS Quote)
		for (Apttus_Proposal__Proposal__c p : [SELECT Id, Name, NokiaCPQ_Proposal_Id__c, CreatedDate, Creation_Date__c, Quote_Stage__c, Apttus_Proposal__Approval_Stage__c, SWx_Upsell_Proposal__r.Technology__c, SWx_Upsell_Proposal__r.Use_Case__c, Quote_Total__c, CurrencyIsoCode, Apttus_QPConfig__PONumber__c, Apttus_QPConfig__PODate__c, Apttus_Proposal__Proposal_Name__c, Agreement_Lookup__r.Name, Apttus_Proposal__Account__r.Id, Apttus_Proposal__Account__r.Name, UserRecordAccess.HasReadAccess,
			  (SELECT Attribute_Label__c, Attribute_Value__c
			  FROM DS_Customer_facing_Attributes__r
			  WHERE Attribute_Visibility__c = 'Yes' AND Attribute_Label__c != null
			  ORDER BY Attribute_Label__c ASC)
			  FROM Apttus_Proposal__Proposal__c
			  WHERE (Apttus_Proposal__Approval_Stage__c = :DS_ProposalUtil.loadApprovalStages() OR Quote_Stage__c = :CSWXGlobalConstant.revision_status) AND Quote_Type__c = :DS_ProposalUtil.DSQuoteTypes AND Contract_Type_Name__c = :CSWXGlobalConstant.ContractTypeNameProject
			  ORDER BY Name DESC
			  LIMIT :DS_ProposalUtil.limitRows]) {
			proposalWrapperList.add(readProposal(p, isCustomerPortalUser));
		}
		return proposalWrapperList;
	}

	/**
	* @description : This function processes the Quote/Proposal record
	* @param	   : Apttus_Proposal__Proposal__c p Quote/Proposal record
	* @param	   : Boolean isCustomerPortalUser flag for Customer Portal Users
	* @return	  : DS_ProposalWrapper processed ProposalWrapper
	*/
	private static DS_ProposalWrapper readProposal(Apttus_Proposal__Proposal__c p, Boolean isCustomerPortalUser) {
		DS_ProposalWrapper proposalWrap = new DS_ProposalWrapper();
		//Fill the basic parameters
		proposalWrap.id = p.Id;
		proposalWrap.qLink = Site.getSiteId() != null || isCustomerPortalUser ? Label.DS_PortalTheme + 'proposal/' + p.Id : '/' + p.Id;

		// Quote Stage is used in Community, Approval Stage + Revision is used in Standard page (Internal View)
		proposalWrap.quoteStage = Site.getSiteId() != null || isCustomerPortalUser ? p.Quote_Stage__c : p.Quote_Stage__c.equals(CSWXGlobalConstant.revision_status) ? p.Quote_Stage__c : p.Apttus_Proposal__Approval_Stage__c;
		proposalWrap.proposalName = p.Apttus_Proposal__Proposal_Name__c;
		proposalWrap.aId = p.Apttus_Proposal__Account__r.Id;
		proposalWrap.aLink = '/' + p.Apttus_Proposal__Account__r.Id;
		proposalWrap.accountName = p.Apttus_Proposal__Account__r.Name;
		proposalWrap.name = p.Name;
		proposalWrap.quoteNumber = p.NokiaCPQ_Proposal_Id__c;	// Quote Number
		proposalWrap.creationDate = (p.Creation_Date__c == null ? p.CreatedDate.date() : p.Creation_Date__c);
		proposalWrap.isDisabled = (p.Quote_Stage__c.equals(CSWXGlobalConstant.revision_status) ? true : false); //clickable on list view
		proposalWrap.grandTotal = p.Quote_Total__c;
		proposalWrap.currencyIsoCode = p.CurrencyIsoCode;
		proposalWrap.PONumber = p.Apttus_QPConfig__PONumber__c;
		proposalWrap.PODate = p.Apttus_QPConfig__PODate__c;
		proposalWrap.agreementName = p.Agreement_Lookup__r.Name;
		proposalWrap.technology = p.SWx_Upsell_Proposal__r.Technology__c;
		proposalWrap.useCase = p.SWx_Upsell_Proposal__r.Use_Case__c;
		proposalWrap.extraInfo = '';
		proposalWrap.truncExtraInfo = '';

		//Processing Customer Facing Attribues
		Map<String,Set<String>> attributes = readAttributes(p.DS_Customer_facing_Attributes__r);
		for (String k : attributes.keySet()) {
			proposalWrap.extraInfo += k + ': ' + String.join(new List<String>(attributes.get(k)), ',') + '\r\n';
		}
		//truncate the first row of Attributes
		proposalWrap.truncExtraInfo = proposalWrap.extraInfo.substringBefore('\r\n');
		if (attributes.keySet().size() > 1) {
			proposalWrap.truncExtraInfo += ' ...';
		}
		proposalWrap.extraInfoText = proposalWrap.truncExtraInfo;
		proposalWrap.displayExtraInfo = attributes.keySet().size() > 1 ? 'slds-show' : 'slds-hide';
		proposalWrap.extraInfoButton = 'utility:add';

		//checkboxes
		proposalWrap.selectIcon = null;
		proposalWrap.selected = false;
		proposalWrap.selectTitle = 'Add to selection';
		return proposalWrap;
	}

	/**
	* @description : This function processes all the Attributes available for the Quote and put them in a map
	* @param	   : List<Customer_facing_Attribute__c> pAttrList List of Customer Facing Attributes
	* @return	  : Map<String,Set<String>> map of attribute label and set of values
	*/
	private static Map<String,Set<String>> readAttributes(List<Customer_facing_Attribute__c> pAttrList) {
		//Fill the Extra Information list with Customer Facing Attributes
		//e.g: Attribute name: Attribute value1, Attribute value2
		Map<String,Set<String>> attributes = new Map<String,Set<String>>();
		if (!pAttrList.isEmpty()) {
			for (Integer i=0; i<pAttrList.size(); i++) {
	if (!attributes.containsKey(pAttrList[i].Attribute_Label__c)) {
		attributes.put(pAttrList[i].Attribute_Label__c, new Set<String>());
	}
	attributes.get(pAttrList[i].Attribute_Label__c).add(pAttrList[i].Attribute_Value__c);
			}
		}
		return attributes;
	}

	/**
	* @description : This function retrieves all the Attributes available for the Quotes received in parameter
	* @param	   : String quoteIdStr Comma separated list of Quote Ids in a String
	* @return	  : List<DS_ListWrapper> List of Attributes as label-value pairs containing all the Attributes of the given Quotes
	*/
	@AuraEnabled
	public static List<DS_ListWrapper> getAvailableAttributeLabelsForQuotes(String quoteIdsStr) {
		AggregateResult[] groupedResults = [SELECT Attribute_Label__c
	FROM Customer_facing_Attribute__c
	WHERE Quote__c = :quoteIdsStr.split(',') AND Attribute_Label__c != null AND Attribute_Visibility__c = 'Yes'
	GROUP BY Attribute_Label__c
	LIMIT :DS_ProposalUtil.limitRows];
		List<DS_ListWrapper> attributeList = new List<DS_ListWrapper>();
		for (AggregateResult ar : groupedResults) {
			String label = ar.get('Attribute_Label__c').toString();
			attributeList.add(new DS_ListWrapper(label, label));
		}
		return attributeList;
	}

	/**
	* @description : This function retrieves all the Quote Line Items of the Quotes received in parameter
	* @param	   : String quoteIdStr Comma separated list of Quote Ids in a String
	* @param	   : addOptions A flag if Options are also included in the list or not
	* @return List<DS_LineItemWrapper> List of Quote Line Items of the given Quotes
	*/
	@AuraEnabled
	public static List<DS_LineItemWrapper> getQuoteLineItemList(String quoteIdsStr, Boolean addOptions) {
		String optionFilterStr = addOptions == true ? '' : CSWXGlobalConstant.Option;
		List<DS_LineItemWrapper> liList = new List<DS_LineItemWrapper>();
		Map<Id, Apttus_Proposal__Proposal__c> headerAttributesByQuote = new Map<Id, Apttus_Proposal__Proposal__c>(
			[SELECT Id, (SELECT Attribute_Label__c, Attribute_Value__c
			 FROM DS_Customer_facing_Attributes__r
			 WHERE Attribute_Visibility__c = 'Yes' AND Attribute_Label__c != null AND Attribute_Indicator__c = :CSWXGlobalConstant.header_indicator)
	FROM Apttus_Proposal__Proposal__c
	WHERE Id = :quoteIdsStr.split(',')
	LIMIT :DS_ProposalUtil.limitRows]
		);
		List<Apttus_Proposal__Proposal_Line_Item__c> pliList = [SELECT
					Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c, Apttus_Proposal__Proposal__r.Quote_Stage__c, Apttus_Proposal__Proposal__r.Apttus_QPConfig__PONumber__c, Apttus_Proposal__Proposal__r.Apttus_QPConfig__PODate__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode,
					Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__r.Name, Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__r.AccountNumber,
					Apttus_Proposal__Proposal__r.Sold_To_Party__r.Name, Apttus_Proposal__Proposal__r.Sold_To_Party__r.AccountNumber,
					Name, Product_Code__c, NokiaCPQ_Product_Name__c, External_Reference__c, External_Description__c, Apttus_QPConfig__Quantity2__c, Apttus_QPConfig__NetPrice__c, Apttus_QPConfig__LineType__c, NokiaCPQ_Configuration_Type__c, DS_Grouping_Name__c,
					(SELECT Attribute_Label__c, Attribute_Value__c FROM DS_customer_facing_Attributes__r WHERE Attribute_Label__c != null AND Attribute_Visibility__c = 'Yes')
				FROM Apttus_Proposal__Proposal_Line_Item__c
				WHERE Apttus_Proposal__Proposal__c = :quoteIdsStr.split(',') AND Apttus_QPConfig__LineType__c != :optionFilterStr
				ORDER BY Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__r.Name ASC, Apttus_Proposal__Proposal__r.Name ASC, Name ASC
				LIMIT :DS_ProposalUtil.limitRows];
		for (Apttus_Proposal__Proposal_Line_Item__c pli : pliList) {
			DS_LineItemWrapper li	= new DS_LineItemWrapper();
			li.quoteId	= pli.Apttus_Proposal__Proposal__r.Name;
			li.quoteNumber			= pli.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c;
			li.quoteLineItemId		= pli.Name;
			//li.product = String.isBlank(pli.External_Reference__c) ? pli.Product_Code__c : pli.External_Reference__c;
			li.quantity	= pli.Apttus_QPConfig__Quantity2__c;
			li.lineType	= pli.Apttus_QPConfig__LineType__c;
			li.configType			= pli.NokiaCPQ_Configuration_Type__c;
			li.accountName			= pli.Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__r.Name;
			li.accountNumber		= pli.Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__r.AccountNumber;
			li.soldToPartyName		= pli.Apttus_Proposal__Proposal__r.Sold_To_Party__r.Name;
			li.soldToPartyNumber	= pli.Apttus_Proposal__Proposal__r.Sold_To_Party__r.AccountNumber;
			li.stage	= (pli.Apttus_Proposal__Proposal__r.Quote_Stage__c == CSWXGlobalConstant.revision_status ? CSWXGlobalConstant.revision_status : pli.Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c);
			li.PONumber	= pli.Apttus_Proposal__Proposal__r.Apttus_QPConfig__PONumber__c;
			li.PODate	= pli.Apttus_Proposal__Proposal__r.Apttus_QPConfig__PODate__c;
			li.customerGroupingName	= pli.DS_Grouping_Name__c;
			li.productCode			= pli.Product_Code__c;
			li.productDescription	= pli.NokiaCPQ_Product_Name__c;
			li.externalReference	= pli.External_Reference__c;
			li.externalDescription	= pli.External_Description__c;
			li.netPrice	= (pli.Apttus_QPConfig__LineType__c == CSWXGlobalConstant.Option ? 0 : pli.Apttus_QPConfig__NetPrice__c);
			li.currencyIsoCode		= pli.Apttus_Proposal__Proposal__r.CurrencyIsoCode;

			li.itemAttributes = new List<DS_ListWrapper>();
			for(Customer_facing_Attribute__c cfa : pli.DS_Customer_facing_Attributes__r) {
	li.itemAttributes.add(new DS_ListWrapper(cfa.Attribute_Label__c, cfa.Attribute_Value__c));
			}
			for(Customer_facing_Attribute__c headerAttr: headerAttributesByQuote.get(pli.Apttus_Proposal__Proposal__c).DS_Customer_facing_Attributes__r) {
	li.itemAttributes.add(new DS_ListWrapper(headerAttr.Attribute_Label__c, headerAttr.Attribute_Value__c));
			}
			liList.add(li);
		}
		return liList;
	}

	/**
	* @description : This function retrieves all the Stages a Quote can have
	* @return	  : List<DS_ListWrapper> List of Stages as label-value pairs
	*/
	@AuraEnabled
	public static List<DS_ListWrapper> getQuoteStages() {
		List<DS_ListWrapper> stageList = new List<DS_ListWrapper>();
		/*Published;Published - In Progress;Published - Ready;Accepted;Rejected;Withdrawn;Revision*/
		String quoteStages = System.label.QuoteStages;
		List<String> tempStages = new List<String>();
		if (Site.getSiteId() != null) {
			// Quote Stages are used on Customer Portal (Community)
			tempStages = quoteStages.split(GlobalConstants.SEMICOLON);
		} else {
			// Approval Stages + Revision are used on Standard page (Internal View)
			tempStages.addAll(DS_ProposalUtil.loadApprovalStages());
			tempStages.add(CSWXGlobalConstant.revision_status);
		}
		stageList.add(new DS_ListWrapper(CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.All));
		for (Integer i = 0; i < tempStages.size(); i++) {
			stageList.add(new DS_ListWrapper(tempStages[i], tempStages[i]));
		}
		System.debug('getQuoteStages ->' + stageList);
		return stageList;
	}

	/**
	* @description : This function retrieves all the valid Stages a Quote can be modified among
	* @return	  : List<DS_ListWrapper> List of Stages as label-value pairs
	*/
	@AuraEnabled
	public static List<String> getValidQuoteStages() {
		//intermediate stage change only available among valid Quote stages
		List<String> validStageList = new List<String>{
			CSWXGlobalConstant.Approval_stage_approved,
			CSWXGlobalConstant.Approval_stage_publishedInProgress,
			CSWXGlobalConstant.Approval_stage_publishedReady,
			CSWXGlobalConstant.Approval_stage_callofReady
		};
		return validStageList;
	}

	/**
	* @description : This function generates a map between Sold-to Parties and related Quote/Proposal records
	* @param	   : List<Apttus_Proposal__Proposal__c> pProposals, List of Quote/Proposal records
	* @return	  : Map<String,List<Apttus_Proposal__Proposal__c>> mapSTPL, Map of Sold-To Party IDs and related Quote/Proposal records
	*/
	private static Map<String,List<Apttus_Proposal__Proposal__c>> generateMapSoldToProposals(List<Apttus_Proposal__Proposal__c> pProposals) {
		Map<String,List<Apttus_Proposal__Proposal__c>> mapSTPL = new Map<String,List<Apttus_Proposal__Proposal__c>>();
		for (Integer i=0; i < pProposals.size(); i++) {
			// Task shall be created only for Project Mode Quotes
			if (pProposals[i].Contract_Type_Name__c == CSWXGlobalConstant.ContractTypeNameProject) {
	if (!mapSTPL.containsKey(pProposals[i].Sold_To_Party__c)) {
		mapSTPL.put(pProposals[i].Sold_To_Party__c, new List<Apttus_Proposal__Proposal__c>());
	}
	mapSTPL.get(pProposals[i].Sold_To_Party__c).add(pProposals[i]);
			}
		}
		return mapSTPL;
	}

	/**
	* @description : This function generates a map between Sold-to Parties and related Queue IDs
	* @param	   : Set<String> legalEntities, set of Sold-to Parties (Legal Entities)
	* @return	  : Map<String,String> mapSoldToLogisticsQueue, Map of Sold-To Party IDs and related Queue IDs
	*/
	private static Map<String,String> generateMapSoldToLogisticsQueue(Set<String> legalEntities) {
		//List is retrieved from Custom Settings DS LE Logistics Queue Map
		List<DS_LE_Logistics_Queue_Map__c> soldToLogisticsQueueList = [SELECT Legal_Entity_ID__c, Queue_ID__c FROM DS_LE_Logistics_Queue_Map__c WHERE Legal_Entity_ID__c IN :legalEntities];
		Map<String,String> mapSoldToLogisticsQueue = new Map<String,String>();
		for (Integer i=0; i<soldToLogisticsQueueList.size(); i++) {
			if (!mapSoldToLogisticsQueue.containsKey(soldToLogisticsQueueList[i].Legal_Entity_ID__c)) {
	mapSoldToLogisticsQueue.put(soldToLogisticsQueueList[i].Legal_Entity_ID__c, soldToLogisticsQueueList[i].Queue_ID__c);
			}
		}
		return mapSoldToLogisticsQueue;
	}

	/**
	* @description : This function creates a Task record for Call-off Ready Quote/Proposals
	* @param	   : Map<String,List<Apttus_Proposal__Proposal__c>> mapSoldToProposalList, map of Sold-to Parties (Legal Entities) and Quote/Proposals
	* @param	   : Map<String,String> mapSoldToLogisticsQueue, Map of Sold-To Party IDs and related Queue IDs
	*/
	private static void createTaskForCallOffReadyProposals(Map<String,List<Apttus_Proposal__Proposal__c>> mapSoldToProposalList, Map<String,String> mapSoldToLogisticsQueue) {
		if (mapSoldToLogisticsQueue != null && !mapSoldToLogisticsQueue.isEmpty()) {
			//A separate 'Delivery Call-off' Task shall be created for every Legal Entity (Sold To Party)
			for (String legalEntityId : mapSoldToLogisticsQueue.keySet()) {
	String description = System.Label.DS_deliveryCallOffTaskBody;
	for (Integer i = 0; i < mapSoldToProposalList.get(legalEntityId).size(); i++) {
		description += '\n' + mapSoldToProposalList.get(legalEntityId)[i].Name;
	}
	Task task = new Task(
		Subject = System.Label.DS_deliveryCallOffTaskSubject + ' ' + mapSoldToProposalList.get(legalEntityId)[0].Sold_To_Party_Name__c, // Subject
		OwnerId = mapSoldToLogisticsQueue.get(legalEntityId), // Logistics Queue Id
		WhatId = legalEntityId, // Legal Entity (Sold To Party) Id
		Description = description, // Text and Proposal List
		RecordTypeId = System.Label.DS_TaskRecordTypeId,
		Status = 'Open'
	);
	Database.insert(task);
			}
		} else {
			System.debug('updateIntermediateStageForQuotes -> No Logistics Queue found.');
		}
	}

	/**
	* @description : This function updates the Approval Stage for all the given Quotes. The new and the prior value of Approval Stage
	* of a certain Quote must be either 'Approved', 'Published - In Progress', 'Published - Ready' or 'Call-off Ready' otherwise no update is done.
	* @param	   : String quoteIdsStr, Comma separated string of Quote/Proposal record IDs
	* @param	   : String approvalStage, The new Approval Stage of the Quote/Proposals
	* @return	  : Integer, The number of records successfully updated
	*/
	@AuraEnabled
	public static Integer updateIntermediateStageForQuotes(String quoteIdsStr, String approvalStage) {
		List<String> validStageList = getValidQuoteStages();

		List<Apttus_Proposal__Proposal__c> proposalList = [SELECT Id, Name, Apttus_Proposal__Approval_Stage__c, Sold_To_Party__c, Sold_To_Party_Name__c, Contract_Type_Name__c
		FROM Apttus_Proposal__Proposal__c
		WHERE Id = :quoteIdsStr.split(',') AND Apttus_Proposal__Approval_Stage__c IN :validStageList
		LIMIT :DS_ProposalUtil.limitRows];

		String errorMsg = '';
		try {
			if (proposalList.size() == 0) {
	AuraHandledException e = new AuraHandledException('Invalid Quote Stage.');
	e.setMessage('Invalid Quote Stage.');
	throw e;
			}

			// update the stage of the selected Quote/Proposals
			for (Integer i=0; i < proposalList.size(); i++) {
	proposalList[i].Apttus_Proposal__Approval_Stage__c = approvalStage;
	//In order to avoid duplication of Task by Process Builder firing
	if (approvalStage == CSWXGlobalConstant.Approval_stage_callofReady) {
		proposalList[i].Changed_Approval_Stage__c = true;
	}
			}
			Database.update(proposalList);

			//Handling Call-off Ready Quotes
			if (approvalStage == CSWXGlobalConstant.Approval_stage_callofReady) {
	Map<String,List<Apttus_Proposal__Proposal__c>> mapSoldToProposalList = generateMapSoldToProposals(proposalList);
	Map<String,String> mapSoldToLogisticsQueue = generateMapSoldToLogisticsQueue(mapSoldToProposalList.keyset());
	createTaskForCallOffReadyProposals(mapSoldToProposalList, mapSoldToLogisticsQueue);
	// revert the changed approval stage
	for (Integer i=0; i < proposalList.size(); i++) {
		proposalList[i].Changed_Approval_Stage__c = false;
	}
	Database.update(proposalList);
			}
			return proposalList.size();
		} catch (DMLException e) {
			for (Integer i = 0; i < e.getNumDml(); i++) {
	//Get Validation Rule & Trigger Error Messages
	errorMsg =+ e.getDmlMessage(i) + '\n' ;
			}
			//throw DML exception message
			throw new AuraHandledException(errorMsg);
		} catch (Exception e) {
			System.debug('updateIntermediateStageForQuotes exception = ' + e.getMessage());
			throw new AuraHandledException(e.getMessage());
		}
	}
}