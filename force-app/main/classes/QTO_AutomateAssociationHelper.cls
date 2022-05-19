/**
* @Name: QTO_AutomateAssociationHelper
* @Author: Raj Kamdar
* @CreateDate: 11/04/2020
* @Description: Helper for automatic association methods. 
* @CalledFrom : QTO_AutomaticAssociationController
* @LastModifiedBy: Raj Kamdar
* @LastModifiedDate: 12/10/2020
* @ChangeDescription: Removed unused methods.
**/

public without sharing class  QTO_AutomateAssociationHelper {
	
	public Static Map<Id,QTO_Customer_Document_Agreement__c> finalListAgrAssociatedToCD = new Map<Id,QTO_Customer_Document_Agreement__c>();
	public Static Map<Id,List<Apttus_Proposal__Proposal_Line_Item__c>> finalQLIForAssociationCDLIMap = new Map<Id,List<Apttus_Proposal__Proposal_Line_Item__c>>();
	public Static Set<String> setApprovalStages = new Set<String>{'Rejected','Withdrawn','Draft'};
	public Static Id cdAccountId;
	
	
	/**
	* @description 
	* @author Raj Kamdar | 12-10-2020 
	* @param List of customer documents. 
	* @return QTO_AssociationDMLWrapper 
	**/
	public static QTO_AssociationDMLWrapper autoAssociateCustomerDocuments(List<Customer_Document__c> customerDocList){
		 System.debug('Batch Method Started: '+customerDocList);
		Map<Id,QTO_AssociationDMLWrapper> mapOutputWrapper = new Map<Id,QTO_AssociationDMLWrapper>();
		 Set<Id> setCustomerDocumentIds = new Set<Id>();
		 QTO_AssociationDMLWrapper outputWrapper = new QTO_AssociationDMLWrapper();		
		 QTO_AssociationOutputWrapper inputWrapper = new QTO_AssociationOutputWrapper();
		 Id customerDocumentId =customerDocList[0].id;
		 cdAccountId = customerDocList[0].Customer__c;
		 
	  //  Parse Data
		for(Customer_Document__c custDoc : customerDocList){
			setCustomerDocumentIds.add(custDoc.id);
		}
		Map<Id,QTO_CDParsingWrapper> CDOMap = QTO_CDParser.parseAllAssociationData(setCustomerDocumentIds);
	System.debug('Parsed Map: '+CDOMap); 
	System.debug('Parsed MapcustomerDocumentId: '+customerDocumentId); 
		 //  Call Flow
	inputWrapper = processAssociationFlow(CDOMap).get(customerDocumentId);
	system.debug('inputWrapper.mapAgreementsFetchedFromQuotes---->'+inputWrapper.mapAgreementsFetchedFromQuotes); 
		 // Create CD and Quote association list
	outputWrapper.listQuoteJunction = QTO_QuoteLineItemAssociationController.associateQuoteWithCD(customerDocumentId,inputWrapper.setFinalQuotes,inputWrapper.mapMatchedQuoteReferences);
	system.debug('quoteJnList == '+ outputWrapper.listQuoteJunction);
	 
		 // Create CD and Agrrement association list
		 if(!inputWrapper.isManual){
			outputWrapper.listAgreementJunction = QTO_QuoteLineItemAssociationController.associateAgreementWithCD(customerDocumentId,inputWrapper.setFinalAgreements,inputWrapper.mapAgreementsFetchedFromQuotes);
		 }
		 system.debug('Agreement Junctions FINAL == '+ outputWrapper.listAgreementJunction);
	system.debug('finalSetOfAgr == '+ inputWrapper.setFinalAgreements);
	
		 // Create CDLI to QLI list
	outputWrapper.listQLIJunction =QTO_QuoteLineItemAssociationController.getCustDocLineItemQuoteLine(finalQLIForAssociationCDLIMap);
	system.debug('cdLIToQLIJnList == '+ outputWrapper.listQLIJunction);
	
	Set<Id> setAssociatedCDLIs = new Set<Id>();
	Map<Id,Customer_Document_Line_Items__c> mapAssociatedCDLIs = new Map<Id,Customer_Document_Line_Items__c>();
	mapAssociatedCDLIs = updateAssociatedCDLIs(outputWrapper.listQLIJunction);
	System.debug('Associated CDLIs: '+mapAssociatedCDLIs);
	System.debug('Set Associated CDLIs: '+setAssociatedCDLIs);
	outputWrapper.listCDLIs.addAll(mapAssociatedCDLIs.values());
	outputWrapper.listCDLIs.addAll(removeAssociatedCDLIs(inputWrapper.listCDLIs,mapAssociatedCDLIs.keySet()));
		 
		 // Fetch existing data
		 outputWrapper.listExistingQuoteJunction = fetchExistingQuoteAssociations(customerDocumentId);
		 outputWrapper.listExistingAgreementJunction = fetchExistingAgreementAssociations(customerDocumentId);
		 outputWrapper.listExistingQLIJunction = fetchExistingQLIAssociations(customerDocumentId);
			
		 // Update CD Status
		 outputWrapper.customerDocument = fetchCustomerDocument(customerDocumentId);
		 outputWrapper.customerDocument = updateCustomerDocumentStatus(outputWrapper.customerDocument,inputWrapper.status);
		 outputWrapper.listQuotesToUpdate = updateQuoteDetails(inputWrapper.setFinalQuotes,outputWrapper.customerDocument); 
		 
		 // Delete existing logs
		 outputWrapper.listExistingLogs = fetchExistingLogs(customerDocumentId); 

		 outputWrapper.listTasks = QTO_Utility.fetchTasks(customerDocumentId);
		 outputWrapper.listExistingTasks = fetchExistingTasks(customerDocumentId);
		 
		 // Log creation 
	outputWrapper.listLogs =QTO_Utility.getLogs(customerDocList);
		outputWrapper.customerDocument = updateCustomerDocumentError(outputWrapper.customerDocument,outputWrapper.listLogs);
	system.debug('logList == '+ outputWrapper.listLogs);
		 mapOutputWrapper.put(customerDocumentId,outputWrapper);
		 
		 return outputWrapper;
	 }

	/**
	* @description: Processes the whole automatic association flow.
	* @author Raj Kamdar | 12-10-2020 
	* @param Map of customer document ids and parsed wrapper. 
	* @return Map<Id, QTO_AssociationOutputWrapper> 
	**/
	@testVisible
	private static Map<Id,QTO_AssociationOutputWrapper> processAssociationFlow(Map<Id,QTO_CDParsingWrapper> mapWrapper){
		System.debug('Process Flow Started '+mapWrapper);
		
		Map<Id,QTO_AssociationOutputWrapper> mapOutputWrapper = new Map<Id,QTO_AssociationOutputWrapper>();
		QTO_AssociationOutputWrapper outputWrapper = new QTO_AssociationOutputWrapper();
		
		Set<Id> setCustomerDocumentIds = mapWrapper.keySet();
		Id customerDocumentId=new List<Id>(setCustomerDocumentIds)[0];
		
		Id accountId = fetchAccountFromCustomerDocument(customerDocumentId);
		System.debug('CDLIs: '+mapWrapper.get(customerDocumentId).setCDOLineItems);
		outputWrapper.listCDLIs = updateUnassociatedCDLIs(mapWrapper.get(customerDocumentId).setCDOLineItems);
		mapOutputWrapper.put(customerDocumentId,outputWrapper);
		if(!doAgreementsExistInAccount(accountId)){ // find agreements with in effect or in application status category under the customer of this customer document
			System.debug('Agreement Doesnt Exist for the customer to be associated');
			//Change CD status to Not Associated
			outputWrapper.status=QTO_Constants.EXCEPTION_ASSOCIATION; // no agreements found with the status, hence no association
			QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
			logMetadata = QTO_Utility.fetchLogMetadata(401);
			QTO_Utility.createLogs(logMetadata.QTO_Return_Description__c,customerDocumentId,null,String.valueOf(logMetadata.QTO_Return_Code__c),logMetadata.QTO_Return_Type__c);
			QTO_Utility.createTask(customerDocumentId,logMetadata.QTO_Return_Description__c,logMetadata.QTO_Return_Code__c,logMetadata.QTO_Task_Subject__c,logMetadata.QTO_Tasks_Priority__c,logMetadata.QTO_Tasks_Due_Date__c,logMetadata.QTO_Tasks_Status__c,logMetadata.QTO_Investigating_Group__c);
			return mapOutputWrapper;
		}
		System.debug('customerDocumentId'+customerDocumentId);
		System.debug('customerDocumentId'+mapWrapper);
		Boolean foundByDSI2322 = false;
		if(!doReferencesExistOnCD(mapWrapper,customerDocumentId)){ // find if agreement references are found in the cfas of cd or the cd lines
			outputWrapper = fetchManualCDAs(outputWrapper,customerDocumentId); // find if already any agreement association found for the cd (manual association)
			System.debug('No references exist');
			// DSI-2322 if after all process, no agreement association is found
			System.debug('DSI-2322 - outputwrapper - agreements::' + outputWrapper.setMatchedAgreementIds);
			if(outputWrapper.setMatchedAgreementIds.isEmpty()) {
	System.debug('DSI-2322 - No Agreements found for association. Initiate finding other possible agreements to associate');
	// find agreements from pdf site code, pdf opty ref and sold to party
	outputWrapper.setMatchedAgreementIds.addAll(getPossibleAssociationOfAgreements(mapWrapper.get(customerDocumentId),accountId,customerDocumentId));
	if (!outputWrapper.setMatchedAgreementIds.isEmpty()) {foundByDSI2322=true;}
			}
			//Change CD status to Not Associated
			if(!doReferencesExistInSystem(outputWrapper.setMatchedAgreementIds)){ // if no agreements found for cd
	outputWrapper.status=QTO_Constants.EXCEPTION_ASSOCIATION;
	QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
	logMetadata = QTO_Utility.fetchLogMetadata(402);
	QTO_Utility.createLogs(logMetadata.QTO_Return_Description__c,customerDocumentId,null,String.valueOf(logMetadata.QTO_Return_Code__c),logMetadata.QTO_Return_Type__c);
	QTO_Utility.createTask(customerDocumentId,logMetadata.QTO_Return_Description__c,logMetadata.QTO_Return_Code__c,logMetadata.QTO_Task_Subject__c,logMetadata.QTO_Tasks_Priority__c,logMetadata.QTO_Tasks_Due_Date__c,logMetadata.QTO_Tasks_Status__c,logMetadata.QTO_Investigating_Group__c);
	return mapOutputWrapper;
			} else if(!foundByDSI2322) { // DSI-2322, manual flag was preventing junction record creation
	outputWrapper.isManual =True;
			}
		}
		System.debug('@@outputWrapper'+outputWrapper);
		System.debug('@@mapWrapper'+mapWrapper);
		System.debug('@@Matched Agreements: '+outputWrapper.listMatchedAgreements);
		System.debug('@@Matched Agreement Set: '+outputWrapper.setMatchedAgreementIds);
		if(!outputWrapper.isManual){
			outputWrapper = fetchAgreementsFromCRM(mapWrapper,outputWrapper);
		}
		
		System.debug('Fetched Agreement References: '+outputWrapper.listMatchedAgreements); 
		
		outputWrapper = fetchQuotesFromCRM(mapWrapper,outputWrapper);
		
		System.debug('Initial Set Matched Agreements: '+outputWrapper.setMatchedAgreementIds);
		System.debug('Initial Set Matched Quotes: '+outputWrapper.setMatchedQuoteIds);
		
		//outputWrapper = processUnmatchedQuoteReferences(outputWrapper,customerDocumentId);
		system.debug('Unmatched references---->'+outputWrapper.listUnmatchedQuoteReferences);
		boolean doQuoteReferencesExistInCRM = doReferencesExistInSystem(outputWrapper.setMatchedQuoteIds);
		boolean doAgreementReferencesExistInCRM = doReferencesExistInSystem(outputWrapper.setMatchedAgreementIds);
		
		System.debug('Do agreement references exist'+doAgreementReferencesExistInCRM);
		System.debug('Do quote references exist'+doQuoteReferencesExistInCRM);  
		
		if(doQuoteReferencesExistInCRM){
			boolean isRiskOrder = checkRiskOrder(outputWrapper.listMatchedQuotes);
			if(isRiskOrder){
	QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
	logMetadata = QTO_Utility.fetchLogMetadata(401);
	QTO_Utility.createLogs(logMetadata.QTO_Return_Description__c,customerDocumentId,null,String.valueOf(logMetadata.QTO_Return_Code__c),logMetadata.QTO_Return_Type__c);
	//outputWrapper.listTasks.add(QTO_Utility.createTask(Label.QTO_Risk_Order_Exception,logMetadata.QTO_Return_Code__c,logMetadata.QTO_Task_Subject__c,logMetadata.QTO_Tasks_Priority__c,logMetadata.QTO_Tasks_Due_Date__c,logMetadata.QTO_Tasks_Status__c));
	outputWrapper.status=QTO_Constants.EXCEPTION_ASSOCIATION;
	return mapOutputWrapper;
			}
			flowIfQuoteReferencesExistInCRM(outputWrapper,customerDocumentId);
		}
		
		if(doAgreementReferencesExistInCRM && !doQuoteReferencesExistInCRM){
			flowIfAgreementReferencesExistInCRM(outputWrapper,customerDocumentId);
		}
		else if(!doAgreementReferencesExistInCRM && !doQuoteReferencesExistInCRM){
			flowIfNoReferencesExistInCRM(outputWrapper,customerDocumentId);
		}
		outputWrapper.setFinalAgreements.addAll(outputWrapper.setMatchedAgreementIds);
		return mapOutputWrapper;
	}   


	  /**
	  * @description: Fetches manual Customer Document Associations
	  * @author Raj Kamdar | 12-10-2020 
	  * @param outputWrapper 
	  * @param customerDocumentId 
	  * @return QTO_AssociationOutputWrapper 
	  **/
	  @testVisible
	  private static QTO_AssociationOutputWrapper fetchManualCDAs(QTO_AssociationOutputWrapper outputWrapper, Id customerDocumentId){
		List<QTO_Customer_Document_Agreement__c> listExistingAgreementAssociations = new List<QTO_Customer_Document_Agreement__c>();
		if(customerDocumentId!=null){
			listExistingAgreementAssociations = [select id,QTO_Agreement__c from QTO_Customer_Document_Agreement__c where QTO_Customer_Document__c= :customerDocumentId and QTO_Source__c= :QTO_Constants.MANUAL];
			System.debug('Existing CDAs: '+listExistingAgreementAssociations);
			for(QTO_Customer_Document_Agreement__c currentCDA: listExistingAgreementAssociations){
	if(currentCDA.QTO_Agreement__c!=null){
		System.debug('Agreement is not null in existing CDA.');
		outputWrapper.setMatchedAgreementIds.add(currentCDA.QTO_Agreement__c);
	}
			}
			List<Apttus__APTS_Agreement__c> listAgreements = new List<Apttus__APTS_Agreement__c>();
			if(outputWrapper.setMatchedAgreementIds.size()>0){
	System.debug('Manual Agreement Association Found.');
	listAgreements = [select id,Name,Agreement_External_Contract_Number__c from Apttus__APTS_Agreement__c where id in :outputWrapper.setMatchedAgreementIds];
	outputWrapper.listManualAgreements = listAgreements;
			}
		}
		
		return outputWrapper;
	  }

	/**
	* @description: Processes the flow if quote references exist in the system.
	* @author Raj Kamdar | 12-10-2020 
	* @param outputWrapper 
	* @param customerDocumentId 
	* @return QTO_AssociationOutputWrapper 
	**/
	@testVisible
	private static QTO_AssociationOutputWrapper  flowIfQuoteReferencesExistInCRM(QTO_AssociationOutputWrapper outputWrapper, Id customerDocumentId){
		System.debug('Quote References Exist');
		Set<Id> setAdditionalQuoteIds = new Set<Id>();
		Set<Id> setAgreementIdsFromQuote = new Set<Id>();
	 
		setAdditionalQuoteIds = QTO_QuoteLineItemAssociationController.callAssociationCDToQuotes(customerDocumentId,outputWrapper.setMatchedQuoteIds);
		outputWrapper.setFinalQuotes.addAll(outputWrapper.setMatchedQuoteIds);
		outputWrapper.setFinalQuotes.addAll(setAdditionalQuoteIds);
			
		outputWrapper = fetchAgreementsFromQuotes(outputWrapper);
		system.debug('outputWrapper--->'+outputWrapper);
		if(outputWrapper.status!=QTO_Constants.EXCEPTION_ASSOCIATION){
			outputWrapper.status=QTO_Constants.ASSOCIATED;
		}   
		System.debug('Quote References Set Matched Agreements: '+outputWrapper.setMatchedAgreementIds);
		System.debug('Quote References Set Matched Quotes: '+outputWrapper.setMatchedQuoteIds);
		
		return outputWrapper;
	}

	/**
	* @description: Processes the flow if agreement references exist in the system.
	* @author Raj Kamdar
	* @param outputWrapper 
	* @param customerDocumentId 
	* @return QTO_AssociationOutputWrapper 
	**/
	@testVisible
	private static QTO_AssociationOutputWrapper flowIfAgreementReferencesExistInCRM(QTO_AssociationOutputWrapper outputWrapper, Id customerDocumentId){
		Set<Id> setQuoteIdsFromAgreement = new Set<Id>();
		Set<Id> setAdditionalQuoteIds = new Set<Id>();
		System.debug('Agreement References Exist, Quote References dont exist');
		if(outputWrapper.status!=QTO_Constants.EXCEPTION_ASSOCIATION){	
			outputWrapper.status=QTO_Constants.ASSOCIATED;
		} 
		setQuoteIdsFromAgreement = fetchQuotesFromAgreements(outputWrapper.setMatchedAgreementIds);
		System.debug('QUOTES FETCHED FROM AGREEMENTS: '+setQuoteIdsFromAgreement);
		
		outputWrapper.setMatchedQuoteIds.addAll(setQuoteIdsFromAgreement);
		outputWrapper.setFinalQuotes.addAll(setQuoteIdsFromAgreement);
		System.debug('Added all mathed quote ids');
		if(setQuoteIdsFromAgreement.size()>0){
			setAdditionalQuoteIds = QTO_QuoteLineItemAssociationController.callAssociationCDToQuotes(customerDocumentId,outputWrapper.setMatchedQuoteIds);
			outputWrapper.setFinalQuotes.addAll(setAdditionalQuoteIds);
		}
		
			
		System.debug('Agmnt Set Matched Agreements: '+outputWrapper.setMatchedAgreementIds);
		System.debug('Agmnt Set Matched Quotes: '+outputWrapper.setMatchedQuoteIds);
		
		return outputWrapper;
	}

	/**
	* @description: Processes the flow if no references exist in the system. 
	* @author Raj Kamdar
	* @param outputWrapper 
	* @param customerDocumentId 
	* @return QTO_AssociationOutputWrapper 
	**/
	@testVisible
	private static QTO_AssociationOutputWrapper flowIfNoReferencesExistInCRM(QTO_AssociationOutputWrapper outputWrapper, Id customerDocumentId){
		System.debug('Quote and agreement references dont Exist');
		List<Apttus__APTS_Agreement__c> listMatchedAgreements = new List<Apttus__APTS_Agreement__c>();
		Set<Id> setMatchedQuoteIds = new Set<Id>();
		Set<Id> setFinalQuotes = new Set<Id>();
		Set<Id> setQuoteIdsFromAgreement = new Set<Id>();
		Id accountId;
			
		accountId = fetchAccountFromCustomerDocument(customerDocumentId);
		listMatchedAgreements = fetchAgreementsFromAccount(accountId);
		outputWrapper.listMatchedAgreements.addAll(listMatchedAgreements);
		outputWrapper.setMatchedAgreementIds = convertListToSet(outputWrapper.listMatchedAgreements);  
		setQuoteIdsFromAgreement = fetchQuotesFromAgreements(outputWrapper.setMatchedAgreementIds);
		outputWrapper.setMatchedQuoteIds.addAll(setQuoteIdsFromAgreement);
		outputWrapper.setFinalQuotes.addAll(setQuoteIdsFromAgreement);
		System.debug('Intermediate final quotes: '+outputWrapper.setFinalQuotes);
			
		if(outputWrapper.setMatchedQuoteIds.size()>0){
			setFinalQuotes = QTO_QuoteLineItemAssociationController.callAssociationCDToQuotes(customerDocumentId,outputWrapper.setMatchedQuoteIds);
			System.debug('Before IF');
			if(setFinalQuotes!=null && setFinalQuotes.size()>0){
	System.debug('After IF');
	outputWrapper.setFinalQuotes.addAll(setFinalQuotes);
			}
	
			System.debug('Last Set Matched Agreements: '+outputWrapper.setMatchedAgreementIds);
			System.debug('Last Set Matched Quotes: '+outputWrapper.setMatchedQuoteIds);
			System.debug('Last Set Final Quotes: '+outputWrapper.setFinalQuotes);
			if(outputWrapper.status!=QTO_Constants.EXCEPTION_ASSOCIATION){
	outputWrapper.status=QTO_Constants.ASSOCIATED;
			}
		}
		else{
			QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
			logMetadata = QTO_Utility.fetchLogMetadata(403);
	  QTO_Utility.createLogs(logMetadata.QTO_Return_Description__c,customerDocumentId,null,String.valueOf(logMetadata.QTO_Return_Code__c),logMetadata.QTO_Return_Type__c);
	  QTO_Utility.createTask(customerDocumentId,logMetadata.QTO_Return_Description__c,logMetadata.QTO_Return_Code__c,logMetadata.QTO_Task_Subject__c,logMetadata.QTO_Tasks_Priority__c,logMetadata.QTO_Tasks_Due_Date__c,logMetadata.QTO_Tasks_Status__c,logMetadata.QTO_Investigating_Group__c);
			outputWrapper.status=QTO_Constants.EXCEPTION_ASSOCIATION;
		}
		return outputWrapper;
	}
	
	/**
	* @description: Checks size of the set provided.
	* @author Raj Kamdar
	* @param setMatchedIds 
	* @return boolean 
	**/
	@testVisible
	private static boolean doReferencesExistInSystem(Set<Id> setMatchedIds){
		system.debug('setMatchedIds'+setMatchedIds);
		if(setMatchedIds.size()>0){
			return True;
		}
		return False;
	}

	/**
	* @description: Processes the quote references which are not found in the system.
	* @author Raj Kamdar
	* @param outputWrapper 
	* @param customerDocumentId 
	* @return QTO_AssociationOutputWrapper 
	**/
	/*@testVisible
	private static QTO_AssociationOutputWrapper processUnmatchedQuoteReferences(QTO_AssociationOutputWrapper outputWrapper,
					Id customerDocumentId){
		if(outputWrapper.listUnmatchedQuoteReferences.size()>0){
			QTO_Exception_Configuration__mdt logMetadata = new QTO_Exception_Configuration__mdt();
			logMetadata = QTO_Utility.fetchLogMetadata(421);
			QTO_Utility.createLogs(logMetadata.QTO_Return_Description__c,customerDocumentId,null,String.valueOf(logMetadata.QTO_Return_Code__c),logMetadata.QTO_Return_Type__c);
			QTO_Utility.createTask(customerDocumentId,logMetadata.QTO_Return_Description__c,logMetadata.QTO_Return_Code__c,logMetadata.QTO_Task_Subject__c,logMetadata.QTO_Tasks_Priority__c,logMetadata.QTO_Tasks_Due_Date__c,logMetadata.QTO_Tasks_Status__c,logMetadata.QTO_Investigating_Group__c);
	 // change status to Exception
	 outputWrapper.status=QTO_Constants.ASSOCIATED;
	}
		return outputWrapper;
	}*/

	/**
	* @description: Fetches existing quote associations for a given Customer Document. 
	* @author Raj Kamdar
	* @param customerDocumentId 
	* @return List<Customer_Document_Junction__c> 
	**/
	public static List<Customer_Document_Junction__c> fetchExistingQuoteAssociations(Id customerDocumentId){
		List<Customer_Document_Junction__c> listExistingQuoteAssociations = new List<Customer_Document_Junction__c>();
		if(customerDocumentId!=null){
			listExistingQuoteAssociations = [select id from Customer_Document_Junction__c where Customer_Document__c= :customerDocumentId];
		}
		return listExistingQuoteAssociations;
	}
	
	/**
	* @description: Fetches existing agreement associations for a given Customer Document.
	* @author Raj Kamdar
	* @param customerDocumentId 
	* @return List<QTO_Customer_Document_Agreement__c> 
	**/
	@testVisible
	private static List<QTO_Customer_Document_Agreement__c> fetchExistingAgreementAssociations(Id customerDocumentId){
		List<QTO_Customer_Document_Agreement__c> listExistingAgreementAssociations = new List<QTO_Customer_Document_Agreement__c>();
		if(customerDocumentId!=null){
			listExistingAgreementAssociations = [select id from QTO_Customer_Document_Agreement__c where QTO_Customer_Document__c= :customerDocumentId and QTO_Source__c!='Manual'];
		}
		return listExistingAgreementAssociations;
	}

	/**
	* @description: Fetches existing QLI associations for a given Customer Document.
	* @author Raj Kamdar
	* @param customerDocumentId 
	* @return List<QTO_Customer_Document_Quote_Line__c> 
	**/
	public static List<QTO_Customer_Document_Quote_Line__c> fetchExistingQLIAssociations(Id customerDocumentId){
		List<QTO_Customer_Document_Quote_Line__c> listExistingQLIAssociations = new List<QTO_Customer_Document_Quote_Line__c>();
		if(customerDocumentId!=null){
			listExistingQLIAssociations = [select id from QTO_Customer_Document_Quote_Line__c where QTO_Customer_Document_Line_Items__r.Customer_Document__c= :customerDocumentId];
		}
		return listExistingQLIAssociations;
	}

	/**
	* @description: Checks whether agreements exist for a given account.
	* @author Raj Kamdar
	* @param accountId 
	* @return boolean 
	**/
	@testVisible
	private static boolean doAgreementsExistInAccount(Id accountId){
		System.debug('Account ID: '+accountId);
		List<AggregateResult> listCount = new List<AggregateResult>();
		Integer agreementCount = 0;
		if(accountId!=null){
			listCount = [select count(id) total from Apttus__APTS_Agreement__c where Apttus__Account__c = :accountId and (Apttus__Status_Category__c=:QTO_Constants.IN_APPLICATION or Apttus__Status_Category__c=:QTO_Constants.IN_EFFECT)];
			agreementCount = (Integer) listCount[0].get('total');
		}
		if(agreementCount>0){
			return True;
		}
		return False;
	}

	/**
	* @description: Fetches agreements from CRM based upon the references provided.
	* @author Raj Kamdar
	* @param mapWrapper 
	* @param outputWrapper 
	* @return QTO_AssociationOutputWrapper 
	**/
	@testVisible
	private static QTO_AssociationOutputWrapper fetchAgreementsFromCRM(Map<Id,QTO_CDParsingWrapper> mapWrapper, QTO_AssociationOutputWrapper outputWrapper){
		Set<String> setReferences = new set<String>();
		List<Apttus__APTS_Agreement__c> listAgreements = new List<Apttus__APTS_Agreement__c>();
		Map<Id,Apttus__APTS_Agreement__c> mapAgreements = new Map<Id,Apttus__APTS_Agreement__c>();
		QTO_AssociationOutputWrapper.AgreementAssociationWrapper agreementWrapper = new QTO_AssociationOutputWrapper.AgreementAssociationWrapper();
		Map<String,Id> mapFoundReferences = new Map<String,Id>();
		Id customerDocumentId =  new List<Id>(mapWrapper.keySet())[0];
		QTO_CDParsingWrapper currentWrapper = mapWrapper.get(customerDocumentId);
		
		setReferences.addAll(currentWrapper.setHeaderAgreements);
		setReferences.addAll(currentWrapper.setLineItemAgreements);
		 System.debug('@@setReferences'+setReferences);
		 if(setReferences.size()>0){
			mapAgreements = new Map<Id,Apttus__APTS_Agreement__c> ([select id,Name,Agreement_External_Contract_Number__c from Apttus__APTS_Agreement__c where (Agreement_External_Contract_Number__c in :setReferences or Name in :setReferences) and Apttus__Account__c =: cdAccountId and (Apttus__Status_Category__c=:QTO_Constants.IN_APPLICATION or Apttus__Status_Category__c=:QTO_Constants.IN_EFFECT)]);
		 }
		for(Apttus__APTS_Agreement__c currentAgreement: mapAgreements.values()){
			mapFoundReferences.put(currentAgreement.Name,currentAgreement.Id);
			mapFoundReferences.put(currentAgreement.Agreement_External_Contract_Number__c,currentAgreement.Id);
		}

		System.debug('listAgreements'+mapAgreements.values());
		//if(listAgreements.size()<setReferences.size()){	
			for(String currentReference:setReferences){
	if(!mapFoundReferences.containsKey(currentReference)){
		system.debug('If -- '+currentReference);
		outputWrapper.listUnmatchedAgreementReferences.add(currentReference);
	}
	else{
		system.debug('else -- '+currentReference);
		agreementWrapper.source = QTO_Constants.PO_PDF;
		agreementWrapper.reference = currentReference;
		outputWrapper.mapAgreementsFetchedFromQuotes.put(mapFoundReferences.get(currentReference),agreementWrapper);
	}
			}
		//}
		outputWrapper.setMatchedAgreementIds.addAll(mapAgreements.keySet());
		outputWrapper.listMatchedAgreements.addAll(mapAgreements.values());
		system.debug('fetchAgreementsFromCRM - outputWrapper - - '+outputWrapper);   
		return outputWrapper;
	}

	/**
	* @description: Checks if customer document classification is Risk Order. 
	* @author Raj Kamdar
	* @param listQuotes 
	* @return boolean 
	**/
	@testVisible
	private static boolean checkRiskOrder(List<Apttus_Proposal__Proposal__c> listQuotes){
		for(Apttus_Proposal__Proposal__c currentQuote:listQuotes){
			if(currentQuote.Nokia_Customer_Document_ID__c!=null){
	if(currentQuote.Nokia_Customer_Document_ID__r.Classification__c==QTO_Constants.RISK_ORDER){
		return True;
	}
			}
		}
		return False;
	}

	/**
	* @description: Fetches quotes from CRM based upon the references provided.
	* @author Raj Kamdar
	* @param mapWrapper 
	* @param outputWrapper 
	* @return QTO_AssociationOutputWrapper 
	**/
	@testVisible
	private static QTO_AssociationOutputWrapper fetchQuotesFromCRM(Map<Id,QTO_CDParsingWrapper> mapWrapper, QTO_AssociationOutputWrapper outputWrapper){
		Set<String> setReferences = new set<String>();
		List<Apttus_Proposal__Proposal__c> listQuotes = new List<Apttus_Proposal__Proposal__c>();
		Map<Id,Apttus_Proposal__Proposal__c> mapQuotes = new Map<Id,Apttus_Proposal__Proposal__c>();
		Map<String,Id> mapFoundReferences = new Map<String,Id>();
		Id customerDocumentId =  new List<Id>(mapWrapper.keySet())[0];
		Id accountId = fetchAccountFromCustomerDocument(customerDocumentId);
		system.debug('customerDocumentId'+customerDocumentId);
		QTO_CDParsingWrapper currentWrapper = mapWrapper.get(customerDocumentId);
		system.debug('currentWrapper'+currentWrapper);
		setReferences.addAll(currentWrapper.setHeaderQuotes);
		setReferences.addAll(currentWrapper.setLineItemQuotes);
		system.debug('accountId'+accountId);
		system.debug('setApprovalStages'+setApprovalStages);
		system.debug('setReferences'+setReferences);
		// Quote Number on proposal stores the format of the quote name, which matches the attribute value format
		// of a customer facing atrribute with PDF QUOTE REF as the label
		if(setReferences.size()>0) {
			
			Set<Id> parentIds = new Set<Id>();
			for(Account Acco: [SELECT Id,name,Parentid, AccountNumber, Parent.Id, Parent.OwnerId, Parent.AccountNumber FROM Account WHERE Id=: accountId]) {
				parentIds.add(Acco.parentId);
			}  
			mapQuotes = new Map<Id,Apttus_Proposal__Proposal__c>(
	[
		select Id,Agreement_Lookup__c, Name, Account_Legal_Entity__c, Apttus_Proposal__Proposal_Name__c,Nokia_Customer_Document_ID__c, Nokia_Customer_Document_ID__r.Classification__c 
		FROM Apttus_Proposal__Proposal__c 
		WHERE (NokiaCPQ_Proposal_Id__c IN :setReferences OR Name in :setReferences OR Apttus_Proposal__Proposal_Name__c in :setReferences) // removed as part of DSI-2330
		AND (Sold_To_Party__c =: accountId OR Account_Legal_Entity__c IN : parentIds OR Apttus_Proposal__Account__c IN : parentIds)
		AND Apttus_Proposal__Approval_Stage__c = 'Approved'  // not in:setApprovalStages // removed as part of DSI-2330
		//and QTO_Association_Status__c=:QTO_Constants.NOT_ASSOCIATED // REMOVED AS PART OF DSI-2335
	]
			);
		}
		
		system.debug('listQuotes : '+mapQuotes.values().size());
		
		for(Apttus_Proposal__Proposal__c currentQuote: mapQuotes.values()){
			mapFoundReferences.put(currentQuote.Name,currentQuote.Id);
			mapFoundReferences.put(currentQuote.Apttus_Proposal__Proposal_Name__c,currentQuote.Id);
			mapFoundReferences.put(currentQuote.Nokia_Customer_Document_ID__c,currentQuote.Id);
		}
		
		
		//if(listQuotes.size()<setReferences.size()){
			for(String currentReference:setReferences){
	if(!mapFoundReferences.containsKey(currentReference)){
		outputWrapper.listUnmatchedQuoteReferences.add(currentReference);
	}
	else{
		outputWrapper.mapMatchedQuoteReferences.put(mapFoundReferences.get(currentReference),currentReference);
	}
			}
		//}
		outputWrapper.setMatchedQuoteIds.addAll(mapQuotes.keySet());
		outputWrapper.listMatchedQuotes = mapQuotes.values();
		return outputWrapper;
	}

	/**
	* @description: Fetches agreements from the quote references found.
	* @author Raj Kamdar
	* @param outputWrapper 
	* @return QTO_AssociationOutputWrapper 
	**/
	@testVisible
	private static QTO_AssociationOutputWrapper fetchAgreementsFromQuotes(QTO_AssociationOutputWrapper outputWrapper){
		Set<Id> setAgreements = new Set<Id>();
		Set<Id> quoteIds = new Set<Id>();
		Integer countMasterQuotes = 0;
		String masterQuoteName;
		Id accountId;
		QTO_AssociationOutputWrapper.AgreementAssociationWrapper agreementWrapper = new QTO_AssociationOutputWrapper.AgreementAssociationWrapper();
		system.debug('outputWrapper.listMatchedQuotes--'+outputWrapper.listMatchedQuotes);
		system.debug('Inside fetchAgreementsFromQuotes');
		
		for(Apttus_Proposal__Proposal__c quote :outputWrapper.listMatchedQuotes) {
			quoteIds.add(quote.Id);
		} 
		
		System.debug('QUOTES IDS......' + quoteIds);
		
		List<Apttus_Proposal__Proposal__c> quotes = 
			[
				select Id, Name, Account_Legal_Entity__c, Agreement_Lookup__c, Sold_To_Party__c, Apttus_Proposal__Account__c, Apttus_Proposal__Proposal_Name__c,
				Nokia_Customer_Document_ID__c,Nokia_Customer_Document_ID__r.Classification__c 
				FROM Apttus_Proposal__Proposal__c WHERE
				Id IN :quoteIds 
			];
		
		//outputWrapper.listMatchedQuotes = quotes; 
		System.debug('quotes....'+quotes);
		
		for(Apttus_Proposal__Proposal__c quote : quotes) {
		  	System.debug('quote.Agreement_Lookup__c ....' + quote.Agreement_Lookup__c);
			if(quote.Agreement_Lookup__c != null) {
	setAgreements.add(quote.Agreement_Lookup__c);
	agreementWrapper.source = quote.Name;
	if(!outputWrapper.mapAgreementsFetchedFromQuotes.containsKey(quote.Agreement_Lookup__c)){
		outputWrapper.mapAgreementsFetchedFromQuotes.put(quote.Agreement_Lookup__c,agreementWrapper);
	}
			}
			if(quote.Agreement_Lookup__c == null && (quote.Apttus_Proposal__Account__c != null ||  quote.Account_Legal_Entity__c != null)) {
				countMasterQuotes = countMasterQuotes + 1;
				accountId = quote.Apttus_Proposal__Account__c != NULL ? quote.Apttus_Proposal__Account__c : quote.Account_Legal_Entity__c;
			}
		}
	   
		System.debug('countMasterQuotes : '+countMasterQuotes);
		if(countMasterQuotes > 0) {
			for(Apttus_Proposal__Proposal__c quote :
	[
					select id,Agreement_Lookup__c,Name,Apttus_Proposal__Proposal_Name__c,Nokia_Customer_Document_ID__c, Nokia_Customer_Document_ID__r.Classification__c 
		FROM Apttus_Proposal__Proposal__c 
		WHERE (Sold_To_Party__c =: accountId OR Account_Legal_Entity__c =: accountId OR Apttus_Proposal__Account__c =: accountId)
		AND Apttus_Proposal__Approval_Stage__c = 'Approved' 
				]) {
	if(quote.Agreement_Lookup__c != null) {
		setAgreements.add(quote.Agreement_Lookup__c);
		agreementWrapper.source = masterQuoteName;
		if(!outputWrapper.mapAgreementsFetchedFromQuotes.containsKey(quote.Agreement_Lookup__c)){
			outputWrapper.mapAgreementsFetchedFromQuotes.put(quote.Agreement_Lookup__c,agreementWrapper);
		}
	}
			}
		}
		outputWrapper.setMatchedAgreementIds.addAll(setAgreements);
		system.debug('fetchAgreementsFromQuotes - outputWrapper--'+outputWrapper);
		return outputWrapper;  
	 } 

	 /**
	 * @description: Fetches Existing Tasks for a Customer Document.
	 * @author Raj Kamdar
	 * @param customerDocumentId 
	 * @return List<Task> 
	 **/
	 @testVisible
	 private static List<Task> fetchExistingTasks(Id customerDocumentId){
		List<Task> listTasks = new List<Task>();
		if(customerDocumentId!=null && Limits.getLimitQueries() > Limits.getQueries()){
			listTasks = [select id,Status from Task where WhatId = :customerDocumentId];
		}
		for(Task currentTask:listTasks){
			currentTask.Status = QTO_Constants.COMPLETED;
		}
		return listTasks;
	 }

	/**
	* @description: Converts list of sObject to Set of Ids. 
	* @author Raj Kamdar 
	* @param listToBeConverted 
	* @return Set<Id> 
	**/
	@testVisible
	private static Set<Id> convertListToSet(List<sObject> listToBeConverted){
		Set<Id> setConverted = new Set<Id>();
		for(sObject s:listTobeConverted){
			setConverted.add(s.Id);
		}
		return setConverted;
	}

	/**
	* @description: Fetches quotes from the agreement references found.
	* @author Raj Kamdar
	* @param setAgreementIds 
	* @return Set<Id> 
	**/
	@testVisible
	private static Set<Id> fetchQuotesFromAgreements(Set<Id> setAgreementIds){
		Map<Id,Apttus_Proposal__Proposal__c> mapProposals = new Map<Id,Apttus_Proposal__Proposal__c>();
		
		if(setAgreementIds.size()>0){
			mapProposals =new Map<Id,Apttus_Proposal__Proposal__c>([select id,name,Agreement_Lookup__c from Apttus_Proposal__Proposal__c where Agreement_Lookup__c in :setAgreementIds and QTO_Association_Status__c=:QTO_Constants.NOT_ASSOCIATED and  Apttus_Proposal__Approval_Stage__c not in:setApprovalStages]);
		}
		return mapProposals.keySet();
	}

	/**
	* @description: Fetches active agreements for an account.
	* @author Raj Kamdar
	* @param accountId 
	* @return List<Apttus__APTS_Agreement__c> 
	**/
	@testVisible
	private static List<Apttus__APTS_Agreement__c> fetchAgreementsFromAccount(Id accountId){
		List<Apttus__APTS_Agreement__c> listAgreements = new List<Apttus__APTS_Agreement__c>();
		if(accountId!=null){
			listAgreements = [select id,name from Apttus__APTS_Agreement__c where Apttus__Account__c = :accountId and (Apttus__Status_Category__c=:QTO_Constants.IN_APPLICATION or Apttus__Status_Category__c=:QTO_Constants.IN_EFFECT)];
		}
		return listAgreements;
	}

	/**
	* @description: Checks if references exist in Customer Document.
	* @author Raj Kamdar
	* @param mapWrapper 
	* @param customerDocumentId 
	* @return boolean 
	**/
	@testVisible
	private static boolean doReferencesExistOnCD(Map<Id,QTO_CDParsingWrapper> mapWrapper, Id customerDocumentId){
		if((mapWrapper.get(customerDocumentId).setHeaderAgreements.size()==0 && mapWrapper.get(customerDocumentId).setLineItemAgreements.size()==0)&&(mapWrapper.get(customerDocumentId).setHeaderQuotes.size()==0 && mapWrapper.get(customerDocumentId).setLineItemQuotes.size()==0)){
			return False;
		}
		return True;
	}

	/**
	* @description: Fetches existing logs for a given Customer Document.
	* @author Raj Kamdar
	* @param customerDocumentId 
	* @return List<QTO_Customer_Document_Issue_Log__c> 
	**/
	public static List<QTO_Customer_Document_Issue_Log__c> fetchExistingLogs(Id customerDocumentId){
		List<QTO_Customer_Document_Issue_Log__c> listDeletion = new List<QTO_Customer_Document_Issue_Log__c>();
		if(customerDocumentId!=null && Limits.getLimitQueries() > Limits.getQueries()){
			listDeletion = [select id from QTO_Customer_Document_Issue_Log__c where QTO_CustomerDocumentId__c = :customerDocumentId];
		}
		return listDeletion;
	}

	/**
	* @description: Fetches customer document details.
	* @author Raj Kamdar
	* @param customerDocumentId 
	* @return Customer_Document__c 
	**/
	@testVisible
	private static Customer_Document__c fetchCustomerDocument(Id customerDocumentId){
		Customer_Document__c currentCustomerDocument = new Customer_Document__c();
		if(customerDocumentId!=null){
			currentCustomerDocument = [select id,Status__c,Customer_Document_Date__c,QTO_Customer_Account_Number__c from Customer_Document__c where Id = :customerDocumentId];
		}
		return currentCustomerDocument;
	}

	/**
	* @description: Updates customer document status.
	* @author Raj Kamdar
	* @param customerDocument 
	* @param status 
	* @return Customer_Document__c 
	**/
	@testVisible
	private static Customer_Document__c updateCustomerDocumentStatus(Customer_Document__c customerDocument, String status){
		customerDocument.Status__c = status;
		return customerDocument;
	}
	
	/**
	* @description: Updates customer document error.
	* @author Raj Kamdar
	* @param customerDocument 
	* @param status 
	* @return Customer_Document__c 
	**/
	@testVisible
	private static Customer_Document__c updateCustomerDocumentError(Customer_Document__c customerDocument, List<QTO_Customer_Document_Issue_Log__c> listLogs){
		Boolean errorFound = False;
		for(QTO_Customer_Document_Issue_Log__c currentLog:listLogs){
			if(currentLog.QTO_CustomerDocumentId__c!=null && currentLog.QTO_CustomerDocumentId__c==customerDocument.Id && currentLog.QTO_ErrorType__c==QTO_Constants.ERROR){
	customerDocument.QTO_Error_Message__c = currentLog.QTO_IssueDetails__c;
	errorFound=True;
	break;
			}
		}
		if(!errorFound){
			customerDocument.QTO_Error_Message__c = '';	
		}
		return customerDocument;
	}

	/**
	* @description: Fetches legal entity for a given customer document.
	* @author Raj Kamdar 
	* @param customerDocumentId 
	* @return Id 
	**/
	@testVisible
	private static Id fetchAccountFromCustomerDocument(Id customerDocumentId){
		Customer_Document__c customerDocument = new Customer_Document__c();
		if(customerDocumentId!=null){
			customerDocument = [select Customer__c from Customer_Document__c where Id = :customerDocumentId];
		}
		return customerDocument.Customer__c;
	}

	/**
	* @description: Fetches all associated CDLIs from list of junction. 
	* @author Raj Kamdar
	* @param listJunction 
	* @return Set<Id> 
	**/
	@testVisible
	private static Set<Id> fetchAssociatedCDLIs(List<QTO_Customer_Document_Quote_Line__c> listJunction){
		Set<Id> setCDLIs = new Set<Id>();
		for(QTO_Customer_Document_Quote_Line__c currentJunction:listJunction){
			setCDLIs.add(currentJunction.QTO_Customer_Document_Line_Items__c);
		}
		return setCDLIs;
	}
	
	/**
	* @description: UUpdates all associated CDLIs from list of junction.
	* @author Raj Kamdar
	* @param listJunction 
	* @return List<Customer_Document_Line_Items__c> 
	**/
	@testVisible
	private static Map<Id,Customer_Document_Line_Items__c> updateAssociatedCDLIs(List<QTO_Customer_Document_Quote_Line__c> listJunction){
		Set<Id> setCDLIs = new Set<Id>();
		setCDLIs = fetchAssociatedCDLIs(listJunction);
		Map<Id,Customer_Document_Line_Items__c> mapCDLIs = new Map<Id,Customer_Document_Line_Items__c>();
		if(setCDLIs.size()>0){

			for(Id currentId:setCDLIs){
	Customer_Document_Line_Items__c currentCDLI = new Customer_Document_Line_Items__c(Id=currentId);
	currentCDLI.QTO_Association__c = QTO_Constants.CD_STATUS_SUCESSFUL;
	mapCDLIs.put(currentId,currentCDLI);
			}
		}
		return mapCDLIs;
	}

	/**
	* @description: Removes Associated CDLIs
	* @author Raj Kamdar 
	* @param listAllCDLIs 
	* @param setAssociatedCDLIs 
	* @return List<Customer_Document_Line_Items__c> 
	**/
	
	@testVisible
	private static List<Customer_Document_Line_Items__c> removeAssociatedCDLIs(List<Customer_Document_Line_Items__c> listAllCDLIs, Set<Id> setAssociatedCDLIs){
		List<Customer_Document_Line_Items__c> listUnassociatedCDLIs = new List<Customer_Document_Line_Items__c>();
		for(Customer_Document_Line_Items__c currentCDLI:listAllCDLIs){
			System.debug(currentCDLI.Id);
			if(!setAssociatedCDLIs.contains(currentCDLI.Id)){
	System.debug('FOUND UNMATCHED CDLI');
	listUnassociatedCDLIs.add(currentCDLI);
			}
		}
		return listUnassociatedCDLIs;
	}


	/**
	* @description: Updates unassociated CDLIs.
	* @author Raj Kamdar | 12-02-2020 
	* @param setCDLIs 
	* @return List<Customer_Document_Line_Items__c> 
	**/
	@testVisible
	private static List<Customer_Document_Line_Items__c> updateUnassociatedCDLIs(Set<Id> setCDLIs){
		List<Customer_Document_Line_Items__c> listCDLIs = new List<Customer_Document_Line_Items__c>();
		if(setCDLIs.size()>0){
			for(Id currentId:setCDLIs){
	Customer_Document_Line_Items__c currentCDLI = new Customer_Document_Line_Items__c(Id=currentId);
	currentCDLI.QTO_Association__c = QTO_Constants.CD_STATUS_FAILED;
	listCDLIs.add(currentCDLI);
			}
		}
		return listCDLIs;
	}
	
	/**
	* @description: Updates details for a given quote. 
	* @author Raj Kamdar
	* @param setQuoteIds 
	* @param customerDocument 
	* @return List<Apttus_Proposal__Proposal__c> 
	**/
	@testVisible
	private static List<Apttus_Proposal__Proposal__c> updateQuoteDetails(Set<Id> setQuoteIds,Customer_Document__c customerDocument){
		List<Apttus_Proposal__Proposal__c> listQuotes = new List<Apttus_Proposal__Proposal__c>();
		System.debug('RECEIVED SET ID QUOTE TO UPDATE: '+setQuoteIds.size());
		if(setQuoteIds.size()>0){
			for(Id currentId:setQuoteIds){
	Apttus_Proposal__Proposal__c currentQuote = new Apttus_Proposal__Proposal__c(Id=currentId);
	currentQuote.Apttus_QPConfig__PODate__c = customerDocument.Customer_Document_Date__c;
	currentQuote.Apttus_QPConfig__PONumber__c = customerDocument.QTO_Customer_Account_Number__c;
	currentQuote.Nokia_Customer_Document_ID__c = customerDocument.Id;
	currentQuote.QTO_Association_Status__c = QTO_Constants.ASSOCIATED;
	listQuotes.add(currentQuote);
			}
		}
		
		return listQuotes;
	}
	// DSI-2322
	@testVisible
	private static List<Id> getPossibleAssociationOfAgreements(QTO_CDParsingWrapper parsingWrapper, Id accountId,Id customerDocumentId) {
		List<Id> possibleAgreementIdsToAssociate = new List<Id>();
		// question: how to know from an agreement, whether it has already been associated ?
		// find quote lines under associated quotes and agreement status active and in effect
		// find cfas for site code under those quote line
		for (Customer_facing_Attribute__c cfa : [
			SELECT Id, Attribute_Label__c, Attribute_Value__c, Quote_Line_Item__r.Apttus_Proposal__Proposal__r.Agreement_Lookup__c
			FROM Customer_facing_Attribute__c
			WHERE (Attribute_Label__c = 'Site Code' OR Attribute_Name__c ='Site Code')
			AND  Attribute_Value__c IN :parsingWrapper.pdfSiteCodeRefs
			AND Quote_Line_Item__r.Apttus_Proposal__Proposal__r.Sold_To_Party__c=:accountId
			AND Quote_Line_Item__r.Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
			AND Quote_Line_Item__r.Apttus_Proposal__Proposal__r.Agreement_Lookup__r.Apttus__Status_Category__c = :QTO_Constants.IN_EFFECT
		]) {
			possibleAgreementIdsToAssociate.add(cfa.Quote_Line_Item__r.Apttus_Proposal__Proposal__r.Agreement_Lookup__c);
		}
		if (possibleAgreementIdsToAssociate.isEmpty()) {
			System.debug(LoggingLevel.INFO, 'DSI-2322 - No Agreements found for association from Site Code. Initiate finding other possible agreements to associate');
			// need to update error on cd as "No CFE type "PDF CONTRACT REF" has been provided"
			QTO_Utility.createLogs('No CFE type "PDF CONTRACT REF" has been provided',customerDocumentId,null,'','Warning');
		}
		// find agreements under same customer having opportunity in the pdf opty ref
		for (Apttus__APTS_Agreement__c agreement : [
			SELECT Id, Name, Apttus__Related_Opportunity__r.Name, Apttus__Related_Opportunity__r.Opportunity_ID__c FROM Apttus__APTS_Agreement__c WHERE Apttus__Account__c = :accountId
			AND (Apttus__Related_Opportunity__r.Opportunity_ID__c IN :parsingWrapper.pdfOpportunityRefs OR Apttus__Related_Opportunity__r.Name IN :parsingWrapper.pdfOpportunityRefs)
			AND Apttus__Status_Category__c = :QTO_Constants.IN_EFFECT ORDER BY CreatedDate DESC LIMIT 1]) {
			possibleAgreementIdsToAssociate.add(agreement.Id);
		}
		if (possibleAgreementIdsToAssociate.isEmpty()) {
			System.debug(LoggingLevel.INFO, 'DSI-2322 - No Agreements found for association from Opportunity. Initiate finding other possible agreements to associate');
		}
		// if still no agreement found for association, find agreement under sold to party
		// assuming the sold to party is same as the customer, need to confirm
		if (possibleAgreementIdsToAssociate.isEmpty()) {
			for (Apttus__APTS_Agreement__c agreement : [SELECT Id, Name FROM Apttus__APTS_Agreement__c WHERE Apttus__Account__c = :accountId ORDER BY CreatedDate DESC LIMIT 1]) {
	possibleAgreementIdsToAssociate.add(agreement.Id);
			}
		}
		if (possibleAgreementIdsToAssociate.isEmpty()) {
			System.debug(LoggingLevel.INFO, 'DSI-2322 - No Agreements found for association from ' + accountId);
		}
		
		System.debug('possibleAgreementIdsToAssociate	: '+possibleAgreementIdsToAssociate);
		
		return possibleAgreementIdsToAssociate;
	}
}