/*********************************************************************
* Class Name : QTO_CustomerDocument_Helper
* Test Class : QTO_CustomerDocumentTriggerTest
* Created Date: 14 Dec 2020
* Created By : Bogdan Botcharov, Nokia
* Description : This class is for validation agreement association
* Modified By : Neeharika Upadrasta, Nokia
* Description : DSI-2096 to change status to Ready for legacy
*******************************************************************/
public without sharing class QTO_CustomerDocument_Helper {
	
	public static Boolean isFirstTime = true;
	public static Boolean isFirstTimeForUpdate = true;
	final static String RECORDTYPE_LEGAL_ENTITY = 'Legal Entity';
	final static String WAIT_FOR_APPROVAL = 'Wait for approval';
	static Map<String,List<QTO_CPO_Field_Mapping__c>> cpoFieldMapping = new Map<String,List<QTO_CPO_Field_Mapping__c>>();
	static Map<String, Customer_Document__c> taskAndIssueLogMap = new Map<String, Customer_Document__c>();
	static Map<String,String> mapCSCustomer = new Map<String,String>();
	static Map<String,Account> mapCustomerAccount = new Map<String,Account>();
	static Map<String,Account> mapLegalEntity = new Map<String,Account>();
	static Map<String,Id> mapContacts = new Map<String,Id>();
	static Map<String,QTO_Exception_Configuration__mdt> exceptionConfigMetaData = new Map<String,QTO_Exception_Configuration__mdt>();
	static Map<String,Id> mapPaymentTermInfos = new Map<String,Id>();
	
	//Class variables
	public static Id qtoRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('QTO').getRecordTypeId();
	
	/**
	* @description: Pull the Basic MetaData
	* @return 
	**/ 
	private static void extractBasicMetaData()  {
		populateCustomSettings();
		getMapPaymentTerms();
		fetchExceptionConfigMetaData();
	}
	
	/**
	* @description: Transcode Customer Document fileds from PDF Fields
	* @param cDocList: List of cistomer documents
	* @param currentCDStatus:  current Customer Document Status .
	* @return 
	**/  
	public static void updateCustomerDocument(List<Customer_Document__c> cDocList) {
		extractBasicMetaData();
		
		List<Customer_Document__c> updatedCdocs = new List<Customer_Document__c>(); 
		Map<Id,Customer_Document__c> cdMap = new Map<Id,Customer_Document__c>(); 
		List<Id> cdocIds = new List<Id>();  
		Set<String> customerNames = new Set<String>(mapCSCustomer.values());
		
		for(Customer_Document__c cDoc : cDocList) {
			cdocIds.add(cDoc.Id);
			cdMap.put(cDoc.Id, cDoc);
			if(cDoc.QTO_PDF_Customer_Name__c!=null) {
				customerNames.add(cDoc.QTO_PDF_Customer_Name__c);
			}
			if(cDoc.Customer__c != null) {
				customerNames.add(cDoc.Customer__c);
			}
		}
		
		//Customer Document List
		List<Customer_Document__c> customerDocumentList = findAllByCustomerDocumentId(cdocIds);
		
		if(!customerDocumentList.isEmpty()) {
			
			for(Customer_Document__c customerDoc : customerDocumentList) {
				//Get Account Map
				mapCustomerAccount = getAccountByNameAndAddress(customerDoc);  
				System.debug('CD HELPER : CustomerAccount>>>>>>: '+mapCustomerAccount);
				
				//Get Contact Reference Map
				mapContacts = getContactReferenceMap(customerDoc);
				System.debug('CD HELPER : ContactRefs >>>>>>>>>: '+mapContacts);
				
				//Update Customer Document
				transcodeOCRFieldsIntoCDFields(customerDoc);
				
				mapLegalEntity = getNokiaLegalEntity(customerDoc);
				System.debug('CD HELPER : LegalEntity>>>>>>>>>>: '+mapLegalEntity);
				
				//Validation rules on Classification and Sub-Classification 
				System.debug('Validation rules');
				boolean hasException = customerDocumentValidityRules(customerDoc);
				
				if(hasException) {
					if(customerDoc.Classification__c == QTO_Constants.PURCHASEORDER && customerDoc.Sub_Classification__c == QTO_Constants.CONTRACT){
						customerDoc.Status__c = 'Ready for Contract treatment'; 
					}
					else {
						customerDoc.Status__c = QTO_Constants.STATUS_DRAFT_WITH_EXCEPTIONS; 
					}	
				} else {
					if(customerDoc.Comment__c=='PURCHASE ORDER LEGACY')
						customerDoc.Status__c = 'Closed-Legacy';
					else
						customerDoc.Status__c = QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS; 
				}
				
				//Duplicate Check
				poDeDuplicationCheck(customerDoc);
				System.debug('After cusDocDuplicateCheckRules >>>>>'); 
				
				
				updatedCdocs.add(customerDoc);
				
				System.debug('taskAndIssueLogMap >>>>>'+taskAndIssueLogMap.size()); 
				
				if(!taskAndIssueLogMap.isEmpty() && taskAndIssueLogMap.size()>0) {
					createTaskAndIssueLog(taskAndIssueLogMap);
				}
			}
		}
		try {
			update updatedCdocs;
		} catch (Exception e){
			System.debug('*****Error while updating Customer Document : '+e.getMessage());
		}
	}
	
	
   /**
	* @description: Transcode Customer Document fileds from PDF Fields
	* @param cDocList: List of cistomer documents
	* @param currentCDStatus:  current Customer Document Status .
	* @return 
	**/
	private static void transcodeOCRFieldsIntoCDFields(Customer_Document__c cdSO) {
		Boolean hasException = false;
		cdSO.QTO_Error_Message__c = '';
		
		//Default to System Date
		cdSO.Nokia_Document_Receipt_Date__c = Date.today();
		System.debug('CD HELPER : CASE STATUS >>'+ cdSo.Case__r.CH_Status__c);
		
		if((String.isBlank(cdSo.Case__c) && (cdSo.Comment__c=='PURCHASE ORDER B2B' || cdSo.Comment__c=='PURCHASE ORDER LEGACY'|| cdSo.Comment__c=='RISK ORDER'))
		   || (!String.isBlank(cdSo.Case__r.CH_Status__c) 
			   && cdSo.Case__r.CH_Status__c != 'Manual')) {
			   
				   try {
					   cdSO.CurrencyIsoCode = cdSO.QTO_Currency__c;
					   if(String.isBlank(cdSO.Classification__c)) {
						   cdSO.Classification__c = !String.isBlank(cdSO.QTO_Classification__c) ? mapCPOFields(cdSO.QTO_Classification__c, 'Classification',null) : null;   
					   }
					   if(String.isBlank(cdSO.Sub_Classification__c)) {
						   cdSO.Sub_Classification__c =  !String.isBlank(cdSO.QTO_Sub_Classification__c)  ? mapCPOFields(cdSO.QTO_Sub_Classification__c, 'Sub-Classification',null) : null; 
					   }
					   if(String.isBlank(cdSO.QTO_Nature__c)) {
						   cdSO.QTO_Nature__c =  !String.isBlank(cdSO.QTO_PDF_Nature__c) ? mapCPOFields(cdSO.QTO_PDF_Nature__c, 'Nature',null) : null;
					   }
					   if(String.isBlank(cdSO.Customer__c)) {
						   cdSO.Customer__c = mapCustomerAccount.containsKey(cdSO.QTO_PDF_Customer_Name__c) ? mapCustomerAccount.get(cdSO.QTO_PDF_Customer_Name__c).Id : null;
					   }
				   } catch (Exception e){
					   cdSO.QTO_Error_Message__c += 'CD HELPER :  Error  populating CPO fields: '+e.getMessage();
					   hasException = true;
				   }
				   
				   String customerName = '';
				   System.debug('CD HELPER : mapCustomerAccount >>'+ mapCustomerAccount); 
				   //Payment Term Assignment
				   if(!mapCustomerAccount.isEmpty()){
					   customerName = cdSO.Customer__c != null ? mapCustomerAccount.get(cdSO.QTO_PDF_Customer_Name__c).Name : null;
				   }
				   if(!String.isBlank(customerName)) {	
					   try {
						   if(String.isBlank(cdSO.Payment_terms__c)) {
							   if(!String.isBlank(cdSO.QTO_Payment_Terms__c) && !String.isBlank(customerName)) {
								   cdSO.Payment_terms__c =  mapPaymentTermInfos.get(mapCPOFields(cdSO.QTO_Payment_Terms__c, 'Payment Terms',customerName));
							   }
						   }
						   
					   } catch (Exception e){
						   System.debug('CD HELPER : Error populating Payment_terms__c: : '+e.getMessage());
						   cdSO.QTO_Error_Message__c += 'Error populating Payment_terms__c: : '+e.getMessage();
						   hasException = true;
					   }
					   
					   //Inco Term Assignment
					   try {
						   if(String.isBlank(cdSO.Inco_Terms__c)) {
							   if(!String.isBlank(cdSO.QTO_INCO_Terms__c) && !String.isBlank(customerName)) {
								   cdSO.Inco_Terms__c = mapCPOFields(cdSO.QTO_Inco_Terms__c, 'Inco Terms',customerName);
							   }
						   }
					   } catch(Exception e){
						   System.debug('CD HELPER : Error populating Inco_Terms__c: : '+e.getMessage());
						   cdSO.QTO_Error_Message__c += 'Error populating Inco_Terms__c: : '+e.getMessage();
						   hasException = true;
					   }
					   System.debug('QTO : Nokia_Legal_Entity_Postal_Code__c >>> '+cdSO.Nokia_Legal_Entity_Postal_Code__c);
					   System.debug('QTO : QTO_Nokia_Legal_Entity_Postal_Code__c >>> '+cdSO.QTO_Nokia_Legal_Entity_Postal_Code__c);
					   
					   try {
						   if(String.isBlank(cdSO.Nokia_Legal_Entity_Postal_Code__c)) {
							   if(!String.isBlank(cdSO.QTO_Nokia_Legal_Entity_Postal_Code__c) && !String.isBlank(customerName)) {
								   String postalCode = mapCPOFields(cdSO.QTO_Nokia_Legal_Entity_Postal_Code__c, 'Legal Entity Postal Code', customerName);
								   System.debug('QTO : POSTAL CODE ' + postalCode);
								   if(String.isBlank(postalCode))
									   cdSO.Nokia_Legal_Entity_Postal_Code__c = cdSO.QTO_Nokia_Legal_Entity_Postal_Code__c;
								   else 
									   cdSO.Nokia_Legal_Entity_Postal_Code__c = postalCode;
							   }
						   }
					   } catch(Exception e){
						   System.debug('CD HELPER : Error populating Nokia_Legal_Entity_Postal_Code__c: : '+e.getMessage());
						   cdSO.QTO_Error_Message__c += 'Error populating Nokia_Legal_Entity_Postal_Code__c: : '+e.getMessage();
						   hasException = true;
					   }
				   }
				   
				   //Commercial Contact Lookup
				   try{
					   String commercialContactString = cdSO.QTO_Customer_Contact_Commercial__c;
					   if(commercialContactString != null){
						   List<String> commercialContactStringSplit = commercialContactString.split('/');
						   if(commercialContactStringSplit != null){
							   if(mapContacts.containsKey(commercialContactStringSplit[0])){
								   cdSO.Customer_Contact_commercial__c = mapContacts.get(commercialContactStringSplit[0]);
							   }
						   }
					   }
				   } catch (Exception e){
					   cdSO.QTO_Error_Message__c += 'Error populating Customer_Contact_commercial__c: : '+e.getMessage();
					   hasException = true;
				   }
				   
				   //Delivery Contact Lookup
				   try{
					   String deliveryContactString = cdSO.QTO_Customer_Contact_Delivery__c;
					   if(deliveryContactString != null){
						   List<String> deliveryContactStringSplit = deliveryContactString.split('/');
						   if(deliveryContactStringSplit != null){
							   if(mapContacts.containsKey(deliveryContactStringSplit[0])){
								   cdSO.Customer_Contact_delivery__c = mapContacts.get(deliveryContactStringSplit[0]);
							   }
						   }
					   }
				   } catch (Exception e){
					   cdSO.QTO_Error_Message__c += 'Error populating Customer_Contact_delivery__c: : '+e.getMessage();
					   hasException = true;
				   }
				   
				   //Customer Document Date Assignment
				   try{
					   System.debug('CD HELPER : DATES ');
					   cdSO.Requested_Delivery_Date__c = getDocumentDate(cdSO.QTO_PDF_Requested_Delivery_Date__c);
					   cdSO.Customer_Document_Date__c = getDocumentDate(cdSO.QTO_Customer_Document_Date__c);
					   if(cdSO.Customer_Document_Date__c == null) {
						   cdSO.QTO_Error_Message__c += 'Error populating Customer_Document_Date__c';
						   hasException = true; 
					   }
				   } catch (Exception e){
					   System.debug('CD HELPER : Error populating Customer_Document_Date__c: : '+e.getMessage());
					   cdSO.QTO_Error_Message__c += 'Error populating Customer_Document_Date__c: : '+e.getMessage();
					   hasException = true;
				   }
				   
				   
				   
				   /*  
					System.debug('CD HELPER : mapCustomerAccount >>'+ mapCustomerAccount); 
					//Payment Term Assignment   
					if(!mapCustomerAccount.isEmpty()){
					customerName = cdSO.Customer__c != null ? mapCustomerAccount.get(cdSO.QTO_PDF_Customer_Name__c).Name : null;
					}
					System.debug('CD HELPER : CUSTOMER NAME >>'+ customerName); 
					*/
				   
				   
				   //Total Value formatting
				   try{
					   if(cdSO.Total_Value__c == null) {
						   cdSO.Total_Value__c = Decimal.valueOf(formatCurrency(cdSO.QTO_PDF_Total_Value__c));
					   }
				   } catch (Exception e){
					   System.debug('CD HELPER : Error populating Total_Value__c: : '+e.getMessage());
					   cdSO.QTO_Error_Message__c += 'Error populating Total_Value__c: : '+e.getMessage();
					   hasException = true;
				   }
		}
		else {
			cdSO.Status__c = QTO_Constants.STATUS_DRAFT_WITH_EXCEPTIONS;
			cdSO.QTO_Error_Message__c += 'Case Status is Manual';
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//Handler Methods
	public static void afterUpdate(List<Customer_Document__c> listCustomerDocsSO) {
		Set<Id> closedCds = new Set<Id>();
		if(!listCustomerDocsSO.isEmpty() &&listCustomerDocsSO != null){
			for (Customer_Document__c cdSO : listCustomerDocsSO) {
				if (cdSO.Status__c == QTO_Constants.CLOSED_VALIDATED || cdSO.Status__c == QTO_Constants.CLOSED_CANCELLED
					|| cdSO.Status__c == QTO_Constants.CLOSED_CONSUMED || cdSO.Status__c == QTO_Constants.CLOSED_REJECTED) {
						closedCds.add(cdSO.Id);
					}
			}
		}
		
		if (!closedCds.isEmpty()) {
			updateOpenToClosed(closedCds);
		}
	}
	
	
	public static void beforeUpdate(List<Customer_Document__c> listCustomerDocsSO, Map<Id,Customer_Document__c> oldCustomerDocMap) {
		fetchExceptionConfigMetaData();
		Map<Id,Customer_Document__c> associatedCDs = new Map<Id,Customer_Document__c>();
		List<Customer_Document__c> registeredCDs = new List<Customer_Document__c>();
		
		for(Customer_Document__c cdSO : listCustomerDocsSO){
			
			if(cdSO.Status__c == QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS
			   && oldCustomerDocMap.get(cdSO.Id).Status__c != QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS || cdSO.Status__c == QTO_Constants.STATUS_DRAFT_WITH_EXCEPTIONS){
				   registeredCDs.add(cdSO);
			   }
			
			if(cdSO.Status__c == QTO_Constants.ASSOCIATED && oldCustomerDocMap.get(cdSO.Id).Status__c != QTO_Constants.ASSOCIATED){
				associatedCDs.put(cdSO.Id,cdSO);
			}
			
			if(cdSO.Modification_term__c != null 
			   && (cdSO.Modification_term__c == QTO_Constants.CHANGE_ALLOWED  
				   || cdSO.Modification_term__c == QTO_Constants.CHANGE_REFUSED 
				   || cdSO.Modification_term__c == QTO_Constants.CANCELLATION_ALLOWED 
				   || cdSO.Modification_term__c == QTO_Constants.CANCELLATION_REFUSED
				  )) {
					  cdSO.Status__c = QTO_Constants.MODIFICATION_TERM_DETERMINED; 
					  //623task
					  taskAndIssueLogMap.put('Registration 623',cdSO);
					  createTaskAndIssueLog(taskAndIssueLogMap);
				  }
		}
		
		System.debug('registeredCDs....'+registeredCDs.size());
		System.debug('associatedCDs....'+associatedCDs.size());
		
		//if(registeredCDs.size() > 0)
			//checkMandatoryFields(registeredCDs, QTO_Constants.CUSTOMER_DOCUMENT_REGISTRATION_STATUS);
		
		if(!associatedCDs.isEmpty()) //DSI-1944
			validateAssociations(associatedCDs);
	}
	
	
	public static Map<Id, List<QTO_Customer_Document_Agreement__c>> allCustomerAgreementsWithCds(Map<Id,Customer_Document__c> mapAssociatedCDs) {
		Map<Id, List<QTO_Customer_Document_Agreement__c>> mapAssociationsToCD = new Map<Id, List<QTO_Customer_Document_Agreement__c>>();
		for(QTO_Customer_Document_Agreement__c cdaSO : [
			SELECT Id, QTO_Agreement__c, QTO_Agreement_Ref_in_PDF__c, QTO_Agreement_Status__c,
			QTO_Customer_Document__c, QTO_Match__c, QTO_Source__c, QTO_Used__c, QTO_Agreement__r.Apttus__Status_Category__c,
			QTO_Agreement__r.Nokia_Legal_Entity_lookup__c, QTO_Agreement__r.Apttus_CMConfig__PaymentTermId__c, QTO_Agreement__r.CLM_Payment_Term__c,
			QTO_Agreement__r.Inco_Term_Description__c, QTO_Agreement__r.Place_or_delivery_shipment__c,	  
			QTO_Agreement__r.SW_business_type__c, QTO_Agreement__r.Other_business_type__c, QTO_Agreement__r.CurrencyIsoCode,
			QTO_Agreement__r.name, QTO_Agreement__r.Id
			FROM QTO_Customer_Document_Agreement__c
			WHERE QTO_Customer_Document__c IN: mapAssociatedCDs.keySet()
			AND QTO_Agreement__r.Apttus__Status_Category__c =: QTO_Constants.IN_EFFECT]) {
				
				if (!mapAssociationsToCD.containsKey(cdaSO.QTO_Customer_Document__c)) {
					mapAssociationsToCD.put(cdaSO.QTO_Customer_Document__c, new List<QTO_Customer_Document_Agreement__c>{cdaSO});
				} else {
					mapAssociationsToCD.get(cdaSO.QTO_Customer_Document__c).add(cdaSO);
				}
			}
		return mapAssociationsToCD;
	}
	
	public static Map<Id, List<Customer_Document_Junction__c>> allCustomerQuotesWithCds(Map<Id,Customer_Document__c> mapAssociatedCDs) {
		
		Map<Id, List<Customer_Document_Junction__c>> mapAssociationsToCD = new Map<Id, List<Customer_Document_Junction__c>>();
		
		for(Customer_Document_Junction__c cdaSO : 
			[ 
				SELECT Id, Customer_Document__c, Quote_Proposal__r.Id FROM Customer_Document_Junction__c
				WHERE Customer_Document__c IN: mapAssociatedCDs.keySet()
				AND Quote_Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
			]) {
				
				if (!mapAssociationsToCD.containsKey(cdaSO.Customer_Document__c)) {
					mapAssociationsToCD.put(cdaSO.Customer_Document__c, new List<Customer_Document_Junction__c>{cdaSO});
				} else {
					mapAssociationsToCD.get(cdaSO.Customer_Document__c).add(cdaSO);
				}
			}
		return mapAssociationsToCD;
	}
	
	private static List<Apttus__AgreementLineItem__c> checkAgreementHasLines(Set<Id> agreementIds) {
		List<Apttus__AgreementLineItem__c> allAgreementLines = 
			[
				Select Id,Apttus__AgreementId__c,Name,Apttus__Description__c,CLM_CFE_Reference__c, Apttus__ProductId__c,
				Apttus__ProductId__r.ProductCode, Product_Code__c, Apttus__AgreementId__r.Inco_Term_Description__c, 
				Apttus__AgreementId__r.Apttus_CMConfig__PaymentTermId__c,
				Apttus__AgreementId__r.CLM_Payment_Term__c
				From Apttus__AgreementLineItem__c
				where Apttus__AgreementId__c In: agreementIds 
				AND Apttus__AgreementId__r.Apttus__Status__c = 'Activated' 
				AND Apttus__AgreementId__r.Apttus__Status_Category__c ='In Effect' 
			];
		
		return allAgreementLines;
	} 
	
	
	private static Boolean checkQuoteHasLines(Set<String> soldToParties) {
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> soldToPartyLines = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>(
			[Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c,
			 Apttus_Proposal__Proposal__c,Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c,
			 Apttus_Proposal__Proposal__r.Id, Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c,
			 Apttus_Proposal__Product__r.ProductCode,External_Reference__c, Apttus_Proposal__Quantity__c,  Apttus_QPConfig__Quantity2__c 
			 from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__r.Sold_to_Party__c IN: soldToParties 
			 AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved']); 
		
		if(soldToPartyLines.size()>0)
			return true;
		
		return false;
	} 	
	
	private static Boolean checkAccountHasQuoteLines(Set<String> soldtoParty) {
		Set<Id> parentIds = new Set<Id>();
		for(Account Acco: 
			[
				SELECT Id,name,Parentid, AccountNumber, Parent.Id, Parent.OwnerId, Parent.AccountNumber FROM Account WHERE Id=: soldtoParty
			]) {
				parentIds.add(Acco.parentId);
			} 
		
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> accountQls = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>
			([
				Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c, Apttus_Proposal__Proposal__c,
				Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Proposal__r.Id,
				Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c, Apttus_Proposal__Product__r.ProductCode,
				External_Reference__c, Apttus_Proposal__Quantity__c, Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c,
				Apttus_QPConfig__Uom__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, QTO_QL_Available_Quantity__c  
				FROM Apttus_Proposal__Proposal_Line_Item__c 
				WHERE Apttus_Proposal__Proposal__r.Apttus_Proposal__Account__c IN : parentIds
				AND Apttus_Proposal__Proposal__r.Apttus_Proposal__Approval_Stage__c = 'Approved'
				AND Apttus_QPConfig__LineType__c = 'Product/Service'
				ORDER BY  Apttus_Proposal__Proposal__r.CreatedDate
			]); 
		
		if(accountQls.size()>0)
			return true;
		
		return false;
	} 	
	
	private static Boolean checkQLHasRiskorderQty(Set<String> soldToParties) {
		Map<Id,Apttus_Proposal__Proposal_Line_Item__c> riskOrderQLs = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>(
			[
				Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c,
				Apttus_Proposal__Proposal__c,Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c,
				Apttus_Proposal__Proposal__r.Id, Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c,
				Apttus_Proposal__Product__r.ProductCode,External_Reference__c, Apttus_Proposal__Quantity__c,  Apttus_QPConfig__Quantity2__c 
				from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__r.Sold_to_Party__c IN: soldToParties 
				AND QTO_QLI_Matched_Risk_Quantity__c >0
			]); 
		
		if(riskOrderQLs.size()>0)
			return true;
		
		return false;
	}
	
	
	
	
	
	public static String checkIsUsed(Customer_Document__c cdDoc, List<QTO_Customer_Document_Agreement__c> mapAssociationsToCD,
									 String errorMessage, List<QTO_Customer_Document_Agreement__c> agreementsToUpdate) 
	{
		if (mapAssociationsToCD.size() == 1) 
		{
			mapAssociationsToCD[0].QTO_Used__c = true;
			
			String matchResponse = isAgreementMatched(cdDoc, mapAssociationsToCD[0]);
			if (matchResponse == 'true') {
				cdDoc.QTO_T_C_Match__c = 'true';
				mapAssociationsToCD[0].QTO_Match__c = true;
			}
			agreementsToUpdate.add(mapAssociationsToCD[0]);
			return matchResponse != 'true' ? matchResponse : '';
		} 
		else if (mapAssociationsToCD.size() > 1) 
		{
			for (QTO_Customer_Document_Agreement__c cdaSO : mapAssociationsToCD) 
			{
				if (cdaSO.QTO_Used__c == true) {
					cdaSO.QTO_Match__c = true;
					mapAssociationsToCD.add(cdaSO);
					String matchResponse = isAgreementMatched(cdDoc, cdaSO);
					if (matchResponse == 'true') {
						cdDoc.QTO_T_C_Match__c = 'true';
						mapAssociationsToCD.add(mapAssociationsToCD[0]);
					} else {
						return matchResponse;
					}
					
					agreementsToUpdate.add(cdaSO);
				}
			}
		}
		return null;
	}
	
	public static String isAgreementMatched(Customer_Document__c cdRec, QTO_Customer_Document_Agreement__c cdaSO) {
		Boolean legalEntity = false;
		Boolean currencyIso = false;
		Boolean paymentTerms = false;
		Boolean incoterms = false;
		Boolean placeOfShipment = false;
		
		String errorMessage = '';
		
		if (cdRec.Nokia_Legal_Entity_Account__c == null || (cdRec.Nokia_Legal_Entity_Account__c == cdaSO.QTO_Agreement__r.Nokia_Legal_Entity_lookup__c)) {
			legalEntity = true;
		} else {
			if (String.isNotBlank(errorMessage)) {
				errorMessage += errorMessage + ', ' + QTO_Constants.ISSUE_NOKIA_LEGAL_ENTITY_ACCOUNT;
			} else {
				errorMessage = QTO_Constants.ISSUE_NOKIA_LEGAL_ENTITY_ACCOUNT;
			}
		}
		
		if (cdRec.CurrencyIsoCode == null || (cdRec.CurrencyIsoCode == cdaSO.QTO_Agreement__r.CurrencyIsoCode)) {
			currencyIso = true;
		} else {
			if (String.isNotBlank(errorMessage)) {
				errorMessage += errorMessage + ', ' + QTO_Constants.ISSUE_CURRENCY;
			} else {
				errorMessage = QTO_Constants.ISSUE_CURRENCY;
			}
		}
		
		//if (cdRec.Payment_terms__c == null || (cdRec.Payment_terms__c == cdaSO.QTO_Agreement__r.Apttus_CMConfig__PaymentTermId__c)) {
		//if (cdRec.Payment_terms__c == null || (cdRec.Payment_terms__c == cdaSO.QTO_Agreement__r.CLM_Payment_Term__c)) {
		//if (cdRec.Payment_terms__c == null || (cdRec.Payment_terms__c == mapPaymentTermInfos.get(cdaSO.QTO_Agreement__r.CLM_Payment_Term__c))) {
		//PROD HOT fix issue
		if (cdRec.Payment_terms__c == null || (cdaSO.QTO_Agreement__r.CLM_Payment_Term__c !=null && (cdRec.Payment_terms__c == mapPaymentTermInfos.get(cdaSO.QTO_Agreement__r.CLM_Payment_Term__c)))
			|| (cdRec.Payment_terms__c == cdaSO.QTO_Agreement__r.Apttus_CMConfig__PaymentTermId__c)) {
				paymentTerms = true;
			} else {
				if (String.isNotBlank(errorMessage)) {
					errorMessage += errorMessage + ', ' + QTO_Constants.ISSUE_PAYMENT_TERMS;
				} else {
					errorMessage = QTO_Constants.ISSUE_PAYMENT_TERMS;
				}
			}
		
		if (cdRec.INCO_Terms__c == null || (cdRec.INCO_Terms__c == cdaSO.QTO_Agreement__r.Inco_Term_Description__c)) {
			incoterms = true;
		} else {
			if (String.isNotBlank(errorMessage)) {
				errorMessage += errorMessage + ', ' + QTO_Constants.ISSUE_INCOTERM;
			} else {
				errorMessage = QTO_Constants.ISSUE_INCOTERM;
			}
		}
		
		if (cdRec.QTO_PDF_Place_of_Delivery_Shipment__c == null ||(cdRec.QTO_PDF_Place_of_Delivery_Shipment__c  == cdaSO.QTO_Agreement__r.Place_or_delivery_shipment__c)) {
			placeOfShipment = true;
		} else {
			if (String.isNotBlank(errorMessage)) {
				errorMessage += errorMessage + ', ' + QTO_Constants.ISSUE_PLACE_OF_DELIVERY;
			} else {
				errorMessage = QTO_Constants.ISSUE_PLACE_OF_DELIVERY;
			}
		}
		
		return String.isBlank(errorMessage) ? 'true' : errorMessage;
	}
	
	//Helper Methods
	//DSI-1944
	public static void validateAssociations(Map<Id,Customer_Document__c> mapAssociatedCDs) {
		getMapPaymentTerms();
		System.debug('Validate Associations : ' + mapAssociatedCDs);
		
		List<QTO_Customer_Document_Issue_Log__c> listIssueLogs = new List<QTO_Customer_Document_Issue_Log__c>();
		List<Task> taskRecords = new List<Task>();
		List<QTO_Customer_Document_Agreement__c> agreementsToUpdate = new List<QTO_Customer_Document_Agreement__c>();
		
		Map<Id, List<QTO_Customer_Document_Agreement__c>> associatedAgreementsToCD = allCustomerAgreementsWithCds(mapAssociatedCDs);
		
		Set<Id> agreementIds = new Set<Id>();
		List<Id> paymentTerms = new List<Id>();
		List<String> incoTerms = new List<String>();
		Set<String> soldToParties = new Set<String>();
		
		for (Customer_Document__c cdSO : mapAssociatedCDs.values()) {
			if (associatedAgreementsToCD.containsKey(cdSO.Id)) {
				Customer_Document__c cdRec = mapAssociatedCDs.get(cdSO.Id);
				for(QTO_Customer_Document_Agreement__c  agreement :  associatedAgreementsToCD.get(cdRec.Id)){
					agreementIds.add(agreement.QTO_Agreement__r.Id); 
					if(agreement.QTO_Agreement__r.CLM_Payment_Term__c == null){
						paymentTerms.add(agreement.QTO_Agreement__r.Apttus_CMConfig__PaymentTermId__c); 
					}
					else{
						paymentTerms.add(mapPaymentTermInfos.get(agreement.QTO_Agreement__r.CLM_Payment_Term__c));
					}
					System.debug('agreement.QTO_Agreement__r.CLM_Payment_Term__c.....' +agreement.QTO_Agreement__r.CLM_Payment_Term__c);
					incoTerms.add(agreement.QTO_Agreement__r.Inco_Term_Description__c);
				}
			}
			if (associatedAgreementsToCD.containsKey(cdSO.Id)) {
				Customer_Document__c cdRec = mapAssociatedCDs.get(cdSO.Id);
				soldToParties.add(cdSO.Customer__c);
			}
		}
		
		Boolean hasAgreementLines = false;
		Boolean hasSoldToPartyQuoteLines = false;
		Boolean hasAccountQuoteLines = false;
		Boolean hasRiskOrderQtyQLs = false;
		List<Apttus__AgreementLineItem__c> allAgreementLines = new List<Apttus__AgreementLineItem__c>();
		
		if(agreementIds.size() >0) {
			allAgreementLines = checkAgreementHasLines(agreementIds);
			if(allAgreementLines.size()>0) {
				hasAgreementLines =  true;
			}
		}
		
		if(soldToParties.size() >0){
			hasSoldToPartyQuoteLines = checkQuoteHasLines(soldToParties);
		}
		//DSI- (R22.1)
		hasAccountQuoteLines = checkAccountHasQuoteLines(soldToParties);
		//DSI-2399 (R22.1)
		hasRiskOrderQtyQLs = checkQLHasRiskorderQty(soldToParties);
		
		
		System.debug('associatedAgreementsToCD>>>> '+associatedAgreementsToCD.size()+'>>>agreementIds  :'+agreementIds +' , hasAgreementLines : '+hasAgreementLines);
		System.debug('soldToParties>>>> '+soldToParties.size()+'>>>soldToParties :'+soldToParties+' , hasQuoteLines : '+hasSoldToPartyQuoteLines);
		
		
		for (Customer_Document__c cdSO : mapAssociatedCDs.values()) {
			if (associatedAgreementsToCD.containsKey(cdSO.Id)) {
				String errorMessage = '';
				Customer_Document__c cdRec = mapAssociatedCDs.get(cdSO.Id);
				cdSO.QTO_T_C_Match__c = cdRec.QTO_T_C_Match__c;
				if(cdSO.Payment_terms__c ==null)
					cdSO.Payment_terms__c = paymentTerms[0];
				if(cdSO.INCO_Terms__c ==null)
					cdSO.INCO_Terms__c = incoTerms[0];
				
				String errorResponse = checkIsUsed(cdRec, associatedAgreementsToCD.get(cdSO.Id), errorMessage, agreementsToUpdate);
				
				if (String.isNotBlank(errorResponse)) {
					cdSO.Status__c = QTO_Constants.EXCEPTION_HEADER_MISMATCH;
					cdSO.QTO_Error_Message__c = errorResponse;
					QTO_Customer_Document_Issue_Log__c issue =createIssueLog(cdSO.Id, QTO_Constants.ERROR, QTO_Constants.ERROR_502,errorMessage);
					Task newTask = createTask(cdSO.Id, QTO_Constants.ERROR_502, QTO_Constants.OPEN,QTO_Constants.SUBJ_CD_MATCH, QTO_Constants.DESC_REGISTER,  QTO_Constants.ORDER_MANAGEMENT);
					taskRecords.add(newTask);
					listIssueLogs.add(issue);
				} 
				else {
				   // if(hasSoldToPartyQuoteLines || hasAgreementLines || hasAccountQuoteLines || hasRiskOrderQtyQLs) {
						cdSO.Status__c = QTO_Constants.CD_STATUS_LINES_HANDOFF;
				   // }
					//else {
						cdSO.Status__c = QTO_Constants.CD_STATUS_LINES_HANDOFF;
					//}
				}
			}
		}

		//Insert Task and CD Issue logs and update CD associations Used flag
		if(taskRecords.size() > 0)
			insert taskRecords;
		if(listIssueLogs.size() > 0)
			insert listIssueLogs;
		if (agreementsToUpdate.size() > 0) {
			update agreementsToUpdate;
		}
	}
	
	
	
	
	/**
	* @description: CPO Creation
	* @param newCds: Set of all new Customer Documents.
	* @param oldCds: Set of all new Customer Documents.
	* @return 
	**/ 
	
	public static void createCPO(Map<Id, Customer_Document__c> newCds, Map<Id, Customer_Document__c> oldCds) {
		/*
		List<Customer_Document__c> matchedStatusDocument = new List<Customer_Document__c>();
		for (Id cdId : newCds.keySet()) {
			System.debug('::::::::::Status::::::' + newCds.get(cdId).Status__c);
			System.debug('::::::::::Status::::::' + oldCds.get(cdId).Status__c);
			
			if ((oldCds.get(cdId).Status__c == 'Enriched(Lines)' || 
				 oldCds.get(cdId).Status__c == 'Exception-Matching(Lines)' || 
				 oldCds.get(cdId).Status__c == 'Manually-Enriched(Lines)'
				) 
				&& (newCds.get(cdId).Status__c == QTO_Constants.CD_STATUS_LEGACY)) {
					matchedStatusDocument.add(newCds.get(cdId));
				}
		}
		
QTO		if (!matchedStatusDocument.isEmpty()) {
			if (CPO_OrderEnrichmentHeaderCreation.isFirstTime) {
				CPO_OrderEnrichmentHeaderCreation.createEnrichment(matchedStatusDocument);
				CPO_OrderEnrichmentHeaderCreation.isFirstTime = false;
			}
		}
		*/
		
		List<Customer_Document__c> readforCPODocs = new List<Customer_Document__c>();
		for (Id cdId : newCds.keySet()) {
			System.debug('::::::::::NEW Status::::::' + newCds.get(cdId).Status__c);
			System.debug('::::::::::OLD Status::::::' + oldCds.get(cdId).Status__c);
			if(newCds.get(cdId).Status__c == QTO_Constants.CD_STATUS_CPO_CREATION) {
					readforCPODocs.add(newCds.get(cdId));
		   }
		}
		
		if (!readforCPODocs.isEmpty()) {
			if (CPO_OrderEnrichmentHeaderCreation.isFirstTime) {
				CPO_OrderEnrichmentHeaderCreation.createEnrichment(readforCPODocs);
				CPO_OrderEnrichmentHeaderCreation.isFirstTime = false;
			}
		}
	}
	
	/**
	* @description: Check Customer document header data mismatch
	* @param newCds: Set of all new Customer Documents.
	* @param oldCds: Set of all new Customer Documents.
	* @return 
	**/  
	public static void checkCustomerDocumentHeader(Map<Id, Customer_Document__c> newCds, Map<Id, Customer_Document__c> oldCds) {
		System.debug('CD PROCESSING : CD HELPER ...'+newCds.size());
		Set<Id> headerMisMatchCds = new Set<Id>();
		Set<Id> headerExcepCds = new Set<Id>();
		for (Id cdId : newCds.keySet()) {
			System.debug('CD PROCESSING : Customer Document Status....'+ newCds.get(cdId).Status__c);
			if(newCds.get(cdId).Status__c == QTO_Constants.EXCEPTION_ASSOCIATION) {
				headerExcepCds.add(newCds.get(cdId).Id);
			}
			if(newCds.get(cdId).Status__c == QTO_Constants.EXCEPTION_HEADER_MISMATCH) {
				headerMisMatchCds.add(newCds.get(cdId).Id);
			}
		}
		
		if(!headerExcepCds.isEmpty()){
			QTOCustomerDocumentUtil.updateCustomerDocumentStatus(headerExcepCds, 'HEADER');
		}
		else if(!headerMisMatchCds.isEmpty()){
			QTOCustomerDocumentUtil.updateCustomerDocumentStatus(headerMisMatchCds, 'HEADER');
		}
		else {
			//CD LINE ITEM PROCESS
			cdLineItemProcess(newCds, oldCds);
		}
	}
	
	
	/**
	* @description: Customer Line Item processing : Enrichment, Associaton, Matching Logic
	* @param newCds: Set of all new Customer Documents.
	* @param oldCds: Set of all new Customer Documents.
	* @return 
	**/	 
	public static void cdLineItemProcess(Map<Id, Customer_Document__c> newCds, Map<Id, Customer_Document__c> oldCds) {
		
		System.debug('callLineItemEnrichment...'+newCds.size());
		Set<Id> lineItemHandoffDocs = new Set<Id>();
		for (Id cdId : newCds.keySet()) {
			if(newCds.get(cdId).Status__c == QTO_Constants.CD_STATUS_LINES_HANDOFF) {
				lineItemHandoffDocs.add(newCds.get(cdId).Id);
			}
		}
		
		if(!lineItemHandoffDocs.isEmpty()) {
			List<Customer_Document__c> customerDocData = QTOCustomerDocumentUtil.findAllCdLinesByStatus(lineItemHandoffDocs, QTO_Constants.CD_STATUS_LINES_HANDOFF);
			System.debug('Customer document Id..'+customerDocData);
			
			if(customerDocData.size() >0 ) {
				List<Customer_Document_Line_Items__c> cdLines= new List<Customer_Document_Line_Items__c>();
				for(Customer_Document_Line_Items__c lineItem:  customerDocData[0].Customer_Document_Line_Items__r) {
					cdLines.add(lineItem);
				}
				
				if(cdLines.size()>0)  {
					
					if( customerDocData[0].Classification__c == QTO_Constants.PURCHASEORDER 
					   && customerDocData[0].Sub_Classification__c == QTO_Constants.BLANKET) {
						 //Process Blanket POS
						 QTO_ProcessBlanketPo.procesBlanketPO(lineItemHandoffDocs);
					   }
					else {
						//Process Standard POs
						QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(cdLines); 
					}
					QTOCustomerDocumentUtil.updateCustomerDocumentStatus(lineItemHandoffDocs, 'LINEITEM');
				}
			}
		}
		
		//Get Enriched(Lines) for Association
		List<Customer_Document_Line_Items__c> cdLines= new List<Customer_Document_Line_Items__c>();
		
		List<Customer_Document__c>  customerDocData = QTOCustomerDocumentUtil.findAllCdLinesByStatus(newCds.keySet(), QTO_Constants.STATUS_ENRICHED);
		if(!customerDocData.isEmpty()){
			for(Customer_Document_Line_Items__c lineItem:  customerDocData.get(0).Customer_Document_Line_Items__r) {
				cdLines.add(lineItem);
			}
			
			System.debug('Line Item Association has been Started...!' + cdLines.size());
			if(cdLines!=null && !cdLines.isEmpty()) {
				QTO_CdLineItemAssociationHelper.associateCdLineItems(cdLines);
				//QTO_CDLineItemMatchingHelper.updateCDocStatus(cdLines);
				QTOCustomerDocumentUtil.updateCustomerDocumentStatus(newCds.keySet(), 'LINEITEM');
				QTO_CDLineItemMatchingHelper.updateQuoteAndAgreementAcceptance(cdLines) ;
			}
		}
	}
		
			/*
			List<Customer_Document__c> customerDocData = QTOCustomerDocumentUtil.findAllCdLinesByStatus(customerDocIds, QTO_Constants.CD_STATUS_LINES_HANDOFF);
			if(customerDocData.size() >0 ) {
				
				List<Customer_Document_Line_Items__c> cdLines= new List<Customer_Document_Line_Items__c>();
				for(Customer_Document_Line_Items__c lineItem:  customerDocData[0].Customer_Document_Line_Items__r) {
					cdLines.add(lineItem);
				}
				
				if(cdLines.size()>0)  {
					QTO_CustomerDocumentLineItem_Helper.lineItemEnrichment(cdLines); 
				}
		   
			
			
				//Get Enriched(Lines)
				cdLines= new List<Customer_Document_Line_Items__c>();
				customerDocData = QTOCustomerDocumentUtil.findAllCdLinesByStatus(customerDocIds, QTO_Constants.STATUS_ENRICHED);
				if(!customerDocData.isEmpty()){
					for(Customer_Document_Line_Items__c lineItem:  customerDocData[0].Customer_Document_Line_Items__r) {
						cdLines.add(lineItem);
					}
				}
				
				System.debug('Line Item Association has been Started...!' + cdLines.size());
				if(cdLines!=null && !cdLines.isEmpty()) {
					QTO_CdLineItemAssociationHelper.associateCdLineItems(cdLines);
					QTO_CDLineItemMatchingHelper.updateCDocStatus(cdLines);
					QTO_CDLineItemMatchingHelper.updateQuoteAndAgreementAcceptance(cdLines) ;
				}
			}
	}
 */
	
	
	
	
	
	//To create Customer Document Issue log related to the Customer Document
	private static QTO_Customer_Document_Issue_Log__c createIssueLog(Id cdSOId, String errorType, String returnCode, String issueDetails){
		QTO_Customer_Document_Issue_Log__c issueLog = new QTO_Customer_Document_Issue_Log__c();
		issueLog.QTO_CustomerDocumentId__c = cdSOId;
		issueLog.QTO_ErrorType__c = errorType; //Warning-Error
		issueLog.QTO_Return_Code__c = returnCode; //101-121
		issueLog.QTO_IssueDetails__c = issueDetails;
		return issueLog;
	}
	
	//To create Task related to issue on Customer Document.
	public static Task createTask(Id cdSOId, String errorCode, String status, String subject, String description, String investingGroup) {
		Task newTask = new Task();
		newTask.WhatId = cdSOId;
		newTask.RecordTypeId = qtoRecordTypeId;
		newTask.QTO_Error_Code__c = errorCode;
		newTask.Status = status;
		newTask.Subject = subject;
		newTask.Description = description;
		newTask.Investigating_Groups__c = investingGroup;
		newTask.ActivityDate = Date.today();
		return newTask;
	}
	
	//DSI-2211
	public static void updateOpenToClosed(Set<Id> openCds) {
		List<Task> openTasks = [
			SELECT Status
			FROM Task
			WHERE WhatId =: openCds];
		for (Task openTask: openTasks) {
			openTask.Status = 'Completed';
		}
		
		update openTasks;
	}
	
	//DSI-1944 - If status changed to Registered, checks if all the mandatory fields have been filled in the CD
	public static void checkMandatoryFields(List<Customer_Document__c> registeredCDs, String cdStatus){
		
		List<String> mandatoryFields = new List<String>();
		
		for(Mandatory_fields_for_Customer_Document__c customSetting : 
			[
				SELECT Id, Mandatory_Fields__c FROM Mandatory_fields_for_Customer_Document__c
				WHERE Object__c =: registeredCDs[0].Id.getSObjectType().getDescribe().getName()
				AND Status__c =: cdStatus
				AND Classification__c =: QTO_Constants.CLASS_STANDARDPO
				AND Sub_Classification__c =: QTO_Constants.SUB_CLASS_LEGACY
			]){
				mandatoryFields.addall(customSetting.Mandatory_Fields__c.split(','));
			}
		
		if(mandatoryFields.size() > 0){
			for(Customer_Document__c cd : registeredCDs){
				for(String fieldAPI : mandatoryFields){
					if(cd.get(fieldAPI) == null){
						cd.addError('Mandatory field '+fieldAPI+' missing.');
					}
				}
			}
		}
	}
	
	
	/***************************************************************************************************************/
	//Refactor Code
	public static List<Customer_Document__c> findAllByCustomerDocumentId(List<Id> cdocIds) {
		
		List<Customer_Document__c> customerDocs = 
			[
				Select Id,Name, Case__c, Case__r.CH_Status__c, QTO_Classification__c,Classification__c, QTO_Sub_Classification__c, Sub_Classification__c,
				QTO_PDF_Nature__c,QTO_Nature__c, QTO_PDF_Customer_Name__c, QTO_Customer_Postal_Code__c,Customer__c,QTO_Customer_Document_Date__c,QTO_Payment_Terms__c,Payment_terms__c,
				QTO_Nokia_Legal_Entity_Account__c, Nokia_Legal_entity__c,Nokia_Legal_Entity_Account__c,Nokia_Legal_Entity_Postal_Code__c, QTO_Nokia_Legal_Entity_Postal_Code__c,
				QTO_Customer_Contact_Commercial__c,QTO_Customer_Contact_Delivery__c,QTO_Currency__c,QTO_PDF_Total_Value__c,Total_Value__c,Status__c,QTO_Error_Message__c,
				QTO_Inco_Terms__c,Inco_Terms__c,isDuplicate__c, Comment__c, QTO_Customer_Name__c, Customer_Document_ID__c,Requested_Delivery_Date__c,QTO_PDF_Requested_Delivery_Date__c,
				(
					Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
					QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
					QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,Net_Value__c,Quantity__c,Total_Value__c,
					QTO_PDF_Total_Value__c,QTO_Requested_Delivery_Date__c,QTO_PDF_Requested_Delivery_Date__c,
					Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c
					from Customer_Document_Line_Items__r
				)
				from Customer_Document__c where Id In:cdocIds
			];
		
		return customerDocs;
	}
	
	private static List<Account> findAllByAccountName(Set<String> customerNames) {
		
		List<Account> accList = 
			[
				SELECT Id, Name, RecordType.Name, BillingPostalCode, Active__c, ParentId, BillingCountryCode 
				FROM Account
				Where Name IN: customerNames
				AND RecordType.Name =: RECORDTYPE_LEGAL_ENTITY
				AND Active__c = true AND ParentId != null
			];
		return  accList;	
	}
	
	
	
	//Customer validation rules
	private static boolean customerDocumentValidityRules(Customer_Document__c cdSO) {
		
		boolean errorFound=false;
		String errorMsg = '\n';
		QTO_Exception_Configuration__mdt exceptionMetadata =null;
		////DSI-2018
		if(cdSO.Customer__c == null) {
			taskAndIssueLogMap.put('Registration 101 Cus Lookup',cdSO);
			exceptionMetadata = exceptionConfigMetaData.get('Registration 101 Cus Lookup');
			errorFound = true;
			errorMsg += exceptionMetadata.QTO_Log_Details__c + '\n';
		}
		//if(cdSO.Classification__c != QTO_Constants.PURCHASEORDER  && cdSO.Sub_Classification__c != QTO_Constants.STANDARD) {
		if(cdSO.QTO_Payment_Terms__c != null && cdSO.Payment_terms__c==null) {
			taskAndIssueLogMap.put('Registration 101 PayTerm',cdSO);
			errorFound = true;
			exceptionMetadata = exceptionConfigMetaData.get('Registration 101 PayTerm');
			errorMsg += exceptionMetadata.QTO_Log_Details__c +'\n';
		}

		if(cdSO.QTO_INCO_Terms__c !=null && cdSO.Inco_Terms__c == null) {
			taskAndIssueLogMap.put('Registration 101 Inco',cdSO);
			exceptionMetadata = exceptionConfigMetaData.get('Registration 101 Inco');
			errorFound = true;
		   errorMsg += exceptionMetadata.QTO_Log_Details__c +'\n';
		}

		
		//Legal entity missing in Customer Document
		if(cdSO.Nokia_Legal_Entity_Account__c == null) {
			taskAndIssueLogMap.put('Registration 101 Legal Entity', cdSO);
			errorFound = true;
			exceptionMetadata = exceptionConfigMetaData.get('Registration 101 Legal Entity');
			errorMsg += exceptionMetadata.QTO_Log_Details__c +'\n';
		}
		
		// DSI-2136: Point-1 - Classification missing in Customer Document
		if(cdSO.Classification__c == NULL || cdSO.Classification__c == '') {
			errorFound = true;
			taskAndIssueLogMap.put('Registration 102',cdSO);
			exceptionMetadata = exceptionConfigMetaData.get('Registration 102');
			errorMsg += exceptionMetadata.QTO_Log_Details__c +'\n';
		}
		
		//DSI-2136: Point-1 - Classification, Subclassification missing in Customer Document
		if((cdSO.Classification__c == NULL || cdSO.Classification__c == '') && (cdSO.Sub_Classification__c == NULL || cdSO.Sub_Classification__c == '')){
			errorFound = true;
			taskAndIssueLogMap.put('Registration 103',cdSO);
			exceptionMetadata = exceptionConfigMetaData.get('Registration 103');
			errorMsg += exceptionMetadata.QTO_Log_Details__c +'\n';
		}
		
		// DSI-2136 : Point-2 
		if(cdSO.Classification__c == QTO_Constants.PURCHASEORDER){
			if(cdSO.Sub_Classification__c == NULL || cdSO.Sub_Classification__c == '') {
				cdSO.Sub_Classification__c = QTO_Constants.STANDARD;
			}
			//if(cdSO.Sub_Classification__c == QTO_Constants.BLANKET || cdSO.Sub_Classification__c == QTO_Constants.CONTRACT) {
			if(cdSO.Sub_Classification__c == QTO_Constants.CONTRACT) {
				errorFound = true; //124 code - 3
				taskAndIssueLogMap.put('Registration 124',cdSO);
				exceptionMetadata = exceptionConfigMetaData.get('Registration 124');
				errorMsg += exceptionMetadata.QTO_Log_Details__c +'\n';
			}
		}
		
		// DSI-2136 : Point-3 
		if(cdSO.Classification__c == QTO_Constants.INHOUSEORDER) {
			if(cdSO.Sub_Classification__c == NULL || cdSO.Sub_Classification__c == ''){
				taskAndIssueLogMap.put('Registration 103',cdSO);	
				errorFound = true; // 103 Code - 2
				exceptionMetadata = exceptionConfigMetaData.get('Registration 103');
				errorMsg += exceptionMetadata.QTO_Log_Details__c +'\n';
			} 
			//if(cdSO.Sub_Classification__c == QTO_Constants.RISKORDER || cdSO.Sub_Classification__c == QTO_Constants.ENGINEERINGORDER) {
			if(cdSO.Sub_Classification__c == QTO_Constants.ENGINEERINGORDER) {
				taskAndIssueLogMap.put('Registration 124', cdSO);
				errorFound = true; //124 code - 3
				exceptionMetadata = exceptionConfigMetaData.get('Registration 124');
				errorMsg += exceptionMetadata.QTO_Log_Details__c +'\n';
			}
		}
		if(errorFound) {
			cdSO.QTO_Error_Message__c += errorMsg;
		}
		return errorFound;
	}
	
	
	//Duplicate check 
	private static void poDeDuplicationCheck(Customer_Document__c cdSO) {
		QTO_Exception_Configuration__mdt exceptionMetadata = null;
		try {
			List<Customer_Document__c> existingCDocList  = [Select Id, Name, Customer_Document_ID__c, Customer__c, Classification__c, Sub_Classification__c, Nokia_Legal_entity__c,
															Customer_Document_Date__c,QTO_Nature__c 
															FROM Customer_Document__c
															WHERE Customer_Document_ID__c =: cdSO.Customer_Document_ID__c ORDER BY Customer_Document_Date__c DESC];
			if(!existingCDocList.isEmpty() && existingCDocList.size()>1) {
				// DSI-2136 : Point-4 
				if(cdSO.Classification__c == QTO_Constants.PURCHASEORDER && (cdSO.Sub_Classification__c == QTO_Constants.STANDARD || cdSO.Sub_Classification__c == QTO_Constants.RISKORDER)) {
					boolean isDuplicate = checkDuplicateCD(cdSO);
					System.debug('isDuplicate >>>>>>>> :'+ isDuplicate);
					String nature = cdSO.QTO_Nature__c ;
					if(isDuplicate) {
						cdSO.Status__c = QTO_Constants.STATUS_DRAFT_WITH_EXCEPTIONS;
						cdSO.isDuplicate__c = true;
						if(nature == '' || nature == null) {
							exceptionMetadata = exceptionConfigMetaData.get('Registration 123');
							cdSO.QTO_Error_Message__c += exceptionMetadata.QTO_Log_Details__c; 
							taskAndIssueLogMap.put('Registration 123',cdSO);
						}
						if(nature == QTO_Constants.CREATE) {
							cdSO.QTO_Nature__c = QTO_Constants.CREATE;
							exceptionMetadata = exceptionConfigMetaData.get('Registration 121 Dup PO No');
							cdSO.QTO_Error_Message__c += exceptionMetadata.QTO_Log_Details__c;   
							taskAndIssueLogMap.put('Registration 121 Dup PO No',cdSO);
						}
						if(nature == QTO_Constants.COPY ) {
							exceptionMetadata = exceptionConfigMetaData.get('Registration 121 Dup PO');
							cdSO.QTO_Error_Message__c += exceptionMetadata.QTO_Log_Details__c;	
							taskAndIssueLogMap.put('Registration 121 Dup PO',cdSO);
							associateCdToCd(cdSO);
						}
						//DSI-2212
						if(nature ==QTO_Constants.CHANGE || nature ==QTO_Constants.CANCEL) {
							List<CD_Association_to_CD__c> associatedList =  associateCdToCd(cdSO);
							if(associatedList.size()>0) {
								System.debug('AggrementPOModificationTerm');
								//Create Task for MO  DSI-2175
								taskAndIssueLogMap.put('Registration 127', cdSO);
								cdSO.Status__c = WAIT_FOR_APPROVAL;
								//AggrementPOModificationTerm
								updateCDModificationTerm(cdSO, associatedList);
							}
						}
					}
				}
			} 
			else {
				if(cdSO.QTO_Nature__c == null || cdSO.QTO_Nature__c == '') {
					cdSO.QTO_Nature__c = QTO_Constants.CREATE;
				}
				if(cdSO.Classification__c == QTO_Constants.PURCHASEORDER && (cdSO.Sub_Classification__c == QTO_Constants.STANDARD || cdSO.Sub_Classification__c == QTO_Constants.RISKORDER) && cdSO.QTO_Nature__c == QTO_Constants.COPY) {
					exceptionMetadata = exceptionConfigMetaData.get('Registration 122');
					cdSO.QTO_Error_Message__c += exceptionMetadata.QTO_Log_Details__c;
					cdSO.Status__c = QTO_Constants.STATUS_DRAFT_WITH_EXCEPTIONS; 
					taskAndIssueLogMap.put('Registration 122',cdSO);
				}
				//DSI-2212 - Classification, sub-classification and nature Cancel and Change into account 
				if(cdSO.Classification__c == QTO_Constants.PURCHASEORDER && (cdSO.Sub_Classification__c == QTO_Constants.STANDARD || cdSO.Sub_Classification__c == QTO_Constants.RISKORDER)  && cdSO.QTO_Nature__c == QTO_Constants.CANCEL) {
					exceptionMetadata = exceptionConfigMetaData.get('Registration 126');
					cdSO.QTO_Error_Message__c += exceptionMetadata.QTO_Log_Details__c;
					cdSO.Status__c = QTO_Constants.STATUS_DRAFT_WITH_EXCEPTIONS; 
					taskAndIssueLogMap.put('Registration 126',cdSO);
				}
				//DSI-2212 - Classification, sub-classification and nature Cancel and Change into account 
				if(cdSO.Classification__c == QTO_Constants.PURCHASEORDER && (cdSO.Sub_Classification__c == QTO_Constants.STANDARD || cdSO.Sub_Classification__c == QTO_Constants.RISKORDER) && cdSO.QTO_Nature__c == QTO_Constants.CHANGE) {
					exceptionMetadata = exceptionConfigMetaData.get('Registration 125');
					cdSO.QTO_Error_Message__c += exceptionMetadata.QTO_Log_Details__c;
					cdSO.Status__c = QTO_Constants.STATUS_DRAFT_WITH_EXCEPTIONS; 
					taskAndIssueLogMap.put('Registration 125',cdSO);
				}
			}
		} catch (Exception e){
			System.debug('Error Dupliacte check >>>>>>>: '+e.getMessage());
			cdSO.Status__c = QTO_Constants.STATUS_DRAFT_WITH_EXCEPTIONS;
		}
	}
	
	
	//DSI-2175 // DSI-2176
	@TestVisible
	private static void updateCDModificationTerm(Customer_Document__c  cdSO, List<CD_Association_to_CD__c> associatedList) {
		System.debug('updateCDModificationTerm');
		List<Id> associatedCdIds = new List<Id>();
		Map<Id,QTO_Customer_Document_Agreement__c> agreementMap = new Map<Id,QTO_Customer_Document_Agreement__c>();		
		if(associatedList.size()>0) {
			for (CD_Association_to_CD__c associateCD: associatedList) {
				associatedCdIds.add(associateCD.QTO_Nokia_Customer_Document_ID__c);
			}
			if(associatedCdIds.size()>0) {
				for(QTO_Customer_Document_Agreement__c cdAggr : [Select Id, QTO_Agreement__c, QTO_Agreement_Ref_in_PDF__c,QTO_Agreement_Status__c, QTO_Customer_Document__c 
																 from QTO_Customer_Document_Agreement__c 
																 where QTO_Customer_Document__c In :associatedCdIds and QTO_Used__c=true ]) {		
																	 agreementMap.put(cdAggr.QTO_Agreement__c, cdAggr);	 
																 }
				for(Apttus__APTS_Agreement__c aggr : [Select Id,Purchase_Order_Modification_Term__c from Apttus__APTS_Agreement__c where Id In : agreementMap.keySet()]) {
					//POmodification term update
					String modification_term = aggr.Purchase_Order_Modification_Term__c;
					cdSO.Modification_term__c = aggr.Purchase_Order_Modification_Term__c;
					List<String> terms = modification_term.split(';');
					//DSI-2182 
					if(terms.isEmpty()){
						//129task
						taskAndIssueLogMap.put('Registration 129',cdSO);
					}
					else {
						if(terms.contains(QTO_Constants.CHANGE_CONTRACTUAL_ALLOWED) || terms.contains(QTO_Constants.CANCELLATION_CONTRACTUAL_ALLOWED)) {
							//128task
							cdSO.Status__c = QTO_Constants.MODIFICATION_TERM_SET; 
							taskAndIssueLogMap.put('Registration 128',cdSO);
						}
					}
				}	
			}
		}
	}
	
	//check Document Id Duplicate
	private static boolean checkDuplicateCD(Customer_Document__c inputCD) {
		System.debug('checkDuplicateCD......');  
		List<Customer_Document__c> existingCDocList  = [Select Id, Name, Customer_Document_ID__c, Customer__c, Classification__c, Sub_Classification__c, Nokia_Legal_entity__c,Customer_Document_Date__c FROM Customer_Document__c
														WHERE Customer_Document_ID__c =: inputCD.Customer_Document_ID__c 
														AND Nokia_Legal_entity__c =: inputCD.Nokia_Legal_entity__c 
														AND Classification__c=: inputCD.Classification__c 
														AND Sub_Classification__c =:inputCD.Sub_Classification__c 
														AND Customer__c =:inputCD.Customer__c
														ORDER BY Customer_Document_Date__c DESC];
		if(existingCDocList.size()>0) {
			return true;
		}
		return false;
	}
	
	
	//create Task and IssueLog
	private static void createTaskAndIssueLog(Map<String, Customer_Document__c> taskAndIssueLogMap) {
		List<Task> taskList = new List<Task>();
		List<QTO_Customer_Document_Issue_Log__c> issueLogList = new List<QTO_Customer_Document_Issue_Log__c>();
		boolean lookupErrorExists = false;
		Id cdId = null;
		for (String key: taskAndIssueLogMap.keyset()) {
			System.debug('TaskAndIssueLog Key>>>>>>>>>>>>>'+key);
			
			QTO_Exception_Configuration__mdt exceptionMetadata = null;
			QTO_Customer_Document_Issue_Log__c  issueLog=null;
			Task task  = null;
			Customer_Document__c cdSO = taskAndIssueLogMap.get(key); 
			cdId = cdSO.Id;
			System.debug('Customer Doc ID Key>>>>>>>>>>>>>'+cdId);
			switch on key {
				when 'Registration 101 PayTerm', 'Registration 101 Inco', 'Registration 101 Cus Lookup', 'Registration 101 Legal Entity' {
					exceptionMetadata = exceptionConfigMetaData.get(key);
					issueLog = createIssueLog(cdSO.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);
					lookupErrorExists = true;
				} when 'Registration 102', 'Registration 103',  'Registration 124','Registration 123','Registration 121 Dup PO No', 'Registration 121 Dup PO', 'Registration 122', 'Registration 126', 'Registration 125' {
					exceptionMetadata =  exceptionConfigMetaData.get(key);
					issueLog = createIssueLog(cdSO.Id, exceptionMetadata.QTO_Return_Type__c, String.valueOf(exceptionMetadata.QTO_Return_Code__c), exceptionMetadata.QTO_Log_Details__c);
					task = createTask(cdSO.Id, String.valueOf(exceptionMetadata.QTO_Return_Code__c) , exceptionMetadata.QTO_Tasks_Status__c, exceptionMetadata.QTO_Task_Subject__c, exceptionMetadata.QTO_Log_Details__c, exceptionMetadata.QTO_Investigating_Group__c);
				} when 'Registration 127', 'Registration 128' , 'Registration 129', 'Registration 623' {
					//DSI-2182
					exceptionMetadata = exceptionConfigMetaData.get(key);
					System.debug(exceptionMetadata);
					task = createTask(cdSO.Id, String.valueOf(exceptionMetadata.QTO_Return_Code__c) , exceptionMetadata.QTO_Tasks_Status__c, exceptionMetadata.QTO_Task_Subject__c, exceptionMetadata.QTO_Log_Details__c, exceptionMetadata.QTO_Investigating_Group__c);
				}
				when else {
					System.debug('default');
				}
			} 
			if(issueLog != null)
				issueLogList.add(issueLog);
			if(task != null)
				taskList.add(task);
			
		}
		try {
			if(lookupErrorExists==true) {
				QTO_Exception_Configuration__mdt exceptionMetadata = exceptionConfigMetaData.get('Registration 101 PayTerm');
				Task task = createTask(cdId, String.valueOf(exceptionMetadata.QTO_Return_Code__c) , exceptionMetadata.QTO_Tasks_Status__c, exceptionMetadata.QTO_Task_Subject__c, exceptionMetadata.QTO_Log_Details__c, exceptionMetadata.QTO_Investigating_Group__c);
				taskList.add(task);
			} 
			
			for (Task task: taskList) {
				System.debug('task>>>>>>'+task);
			}
			
			if(!issueLogList.isEmpty())
				insert issueLogList;
			if(!taskList.isEmpty())
				insert taskList;
		} catch(Exception e){
			System.debug('*****error inserting Tasks in: '+e);
		}
	}
	
	
	//fetch Exception Metadata
	private static void fetchExceptionConfigMetaData() {
		for(QTO_Exception_Configuration__mdt metadata :[select id, MasterLabel, QualifiedApiName,QTO_Return_Code__c,QTO_Return_Description__c,QTO_Return_Type__c,QTO_Task_Subject__c,QTO_Tasks_Due_Date__c,QTO_Tasks_Priority__c,QTO_Tasks_Status__c,QTO_Investigating_Group__c,QTO_Log_Details__c from QTO_Exception_Configuration__mdt]){
			exceptionConfigMetaData.put(metadata.MasterLabel, metadata);
		}
	}
	
	
	/****/
	public static Map<String,Id> getContactReferenceMap(Customer_Document__c cDoc) {
		Map<String,Id> mapContactFullNameToId = new Map<String,Id>();
		Set<String> firstNames = new Set<String>();
		Set<String> lastNames = new Set<String>();
		if(cDoc.QTO_Customer_Contact_Commercial__c != null) {
			String fullCommercialContactString = cDoc.QTO_Customer_Contact_Commercial__c;
			List<String> splitCommercialContactString = fullCommercialContactString.split('/');
			if(splitCommercialContactString.size()>0) {
				String commercialContactFullName = splitCommercialContactString[0];
				List<String> commercialContactNameSplit = commercialContactFullName.split(' ');
				firstNames.add(commercialContactNameSplit[0]);
				if(commercialContactNameSplit.size() > 1)
					lastNames.add(commercialContactNameSplit[1]);
			}
		}
		if(cDoc.QTO_Customer_Contact_Delivery__c != null) {
			String deliveryContactFullName = cDoc.QTO_Customer_Contact_Delivery__c;
			List<String> deliveryContactNameSplit = deliveryContactFullName.split(' ');
			firstNames.add(deliveryContactNameSplit[0]);
			if(deliveryContactNameSplit.size() > 1)
				lastNames.add(deliveryContactNameSplit[1]);
		}
		for(Contact contactSO : [SELECT Id, FirstName, LastName 
								 FROM Contact WHERE FirstName IN: firstNames AND LastName IN: lastNames]){
									 mapContactFullNameToId.put(contactSO.FirstName +' '+contactSO.LastName, contactSO.Id);
								 }
		return mapContactFullNameToId;
	}
	
	
	/** **/
	public static Map<String,Account> getAccountByNameAndAddress(Customer_Document__c cDoc) {
		
		Map<String, List<Account>> nameToAccsMap = new Map<String,List<Account>>();
		Map<String,Account> mapNameToAccountRecord = new Map<String,Account>();			
		Set<String> customerNames = new Set<String>(mapCSCustomer.values());
		List<Account> tempList = new List<Account>();
		
		customerNames.add(cDoc.QTO_PDF_Customer_Name__c);
		//Create a map of existing Accounts in SF  
		for(Account accSO : [SELECT Id, Name, RecordType.Name, BillingPostalCode, Active__c, ParentId, BillingCountryCode 
							 FROM Account Where Name IN: customerNames
							 AND RecordType.Name =: RECORDTYPE_LEGAL_ENTITY
							 AND Active__c = true AND ParentId != null]) {
			//for(Account accSO : accounts) {
			if(nameToAccsMap.containsKey(accSO.Name)) {
				tempList = nameToAccsMap.get(accSO.Name);
				tempList.add(accSO);
				nameToAccsMap.put(accSO.Name, tempList);
			}	
			else
				nameToAccsMap.put(accSO.Name, new List<Account>{accSO});
		}
		
		String accNameInDoc = cDoc.QTO_PDF_Customer_Name__c;
		String billingPostalCode = cDoc.QTO_Customer_Postal_Code__c;
		Boolean accountFound = false; 
		
		//If Name from Doc directly matches an Account
		if(String.isNotBlank(accNameInDoc) && nameToAccsMap.containsKey(accNameInDoc)) {	
			//If Postal Code was also provided in the Doc
			if(String.isNotBlank(billingPostalCode)) {		 
				for(Account accSO : nameToAccsMap.get(accNameInDoc)) {
					//And Name + Postal Code have an exact match with existing Account
					if(accSO.BillingPostalCode == billingPostalCode) {
						//Assign that Account record 
						mapNameToAccountRecord.put(accNameInDoc, accSO);
						accountFound = true;
					}		
				}
			}
			//If Postal Code was not provided but only one account exists with that name
			if(accountFound==false && String.isBlank(billingPostalCode) && nameToAccsMap.get(accNameInDoc).size() == 1) {   
				//Assign the single Account
				mapNameToAccountRecord.put(accNameInDoc, nameToAccsMap.get(accNameInDoc)[0]);
				accountFound = true;
			}
		}
		//If not, search in Mapping table for alternative name of that Account and verify if that matches an existing Account record
		if(accountFound==false && mapCSCustomer.containsKey(accNameInDoc) && nameToAccsMap.containsKey(mapCSCustomer.get(accNameInDoc))) {	
			//If Postal Code was also provided in the Doc
			if(String.isNotBlank(billingPostalCode)) {
				for(Account accSO : nameToAccsMap.get(mapCSCustomer.get(accNameInDoc))) {
					//And Name + Postal Code have an exact match with existing Account
					if(accSO.BillingPostalCode == billingPostalCode) {
						//Assign that Account record 
						mapNameToAccountRecord.put(accNameInDoc, accSO);
						accountFound=true;
					}
				}
			}
			//If Postal Code was not provided but only one account exists with that name
			if(accountFound==false && nameToAccsMap.get(mapCSCustomer.get(accNameInDoc)).size() == 1) {
				//Assign the single Account
				mapNameToAccountRecord.put(accNameInDoc, nameToAccsMap.get(mapCSCustomer.get(accNameInDoc))[0]);
			}
		}
		return mapNameToAccountRecord;
	}
	
	
	
	/** **/
	public static Map<String,Account> getNokiaLegalEntity(Customer_Document__c cusDoc) {
		final String TYPE_INTERNAL_CUSTOMER = 'Internal Customer';
		Map<String, List<Account>> nameToAccsMap = new Map<String,List<Account>>();
		List<Account> tempList = new List<Account>();
		Map<String,Account> mapNameToAccountRecord = new Map<String,Account>();
		Set<String> customerNames = new Set<String>(mapCSCustomer.values());
		Set<String> customerPostalCodes = new Set<String>();
		
		if(cusDoc.QTO_Nokia_Legal_Entity_Account__c != null) {
			mapNameToAccountRecord.put(cusDoc.QTO_Nokia_Legal_Entity_Account__c,null);
			customerNames.add('%'+cusDoc.QTO_Nokia_Legal_Entity_Account__c+'%');			
		}	 
		
		System.debug('customerNames >>>>> '+customerNames);
		
		//---Added newly to align with Customer field logic for DSI-2105, commented older logic
		//Create a map of existing Accounts in SF		
		for(Account accSO : [SELECT Id, Name, RecordType.Name, BillingPostalCode, Active__c, ALU_Unit_Code__c  
							 FROM Account Where Name LIKE: customerNames 
							 AND Type =: TYPE_INTERNAL_CUSTOMER
							 AND Active__c = true])
		{
			if(nameToAccsMap.containsKey(accSO.Name))
			{
				tempList = nameToAccsMap.get(accSO.Name);
				tempList.add(accSO);
				nameToAccsMap.put(accSO.Name, tempList);
			}	
			else
				nameToAccsMap.put(accSO.Name, new List<Account>{accSO});
		}
		
		String accNameInDoc = cusDoc.QTO_Nokia_Legal_Entity_Account__c; //Account Name provided in the document
		String pdfBillingPostalCode = cusDoc.QTO_Nokia_Legal_Entity_Postal_Code__c; //Postal code provided in the document
		String billingPostalCode = cusDoc.Nokia_Legal_Entity_Postal_Code__c; //Postal code provided in the document
		
		Boolean accountFound =false; //if the name matches an Account record in SF
		//If Name from Doc directly matches an Account
		if(String.isNotBlank(accNameInDoc) && nameToAccsMap.containsKey(accNameInDoc)) {   
			//If Postal Code was also provided in the Doc
			if(String.isNotBlank(billingPostalCode)) { 
				for(Account accSO : nameToAccsMap.get(accNameInDoc)) {
					//And Name + Postal Code have an exact match with existing Account
					if(accSO.BillingPostalCode == billingPostalCode) {
						//Assign that Account record
						mapNameToAccountRecord.put(accNameInDoc, accSO);
						accountFound = true;
					} 
				}
			}
			//If Postal Code was not provided but only one account exists with that name
			if(accountFound == false && String.isBlank(billingPostalCode) && nameToAccsMap.get(accNameInDoc).size() == 1) {
				//Assign the single Account
				mapNameToAccountRecord.put(accNameInDoc, nameToAccsMap.get(accNameInDoc)[0]);
				accountFound = true;
			}
		}
		  
		//If not, search in Mapping table for alternative name of that Account and verify if that matches an existing Account record
		if(accountFound==false && mapCSCustomer.containsKey(accNameInDoc) && nameToAccsMap.containsKey(mapCSCustomer.get(accNameInDoc))) {
			//If Postal Code was also provided in the Doc
			if(String.isNotBlank(billingPostalCode)) { 
				for(Account accSO : nameToAccsMap.get(mapCSCustomer.get(accNameInDoc))) {
					//And Name + Postal Code have an exact match with existing Account
					if(accSO.BillingPostalCode == billingPostalCode) {
						//Assign that Account record 
						mapNameToAccountRecord.put(accNameInDoc, accSO);
						accountFound = true;
					} 
				}
			}
			//If Postal Code was not provided but only one account exists with that name
			if(accountFound==false && nameToAccsMap.get(mapCSCustomer.get(accNameInDoc)).size() == 1) { 
				//Assign the single Account
				mapNameToAccountRecord.put(accNameInDoc, nameToAccsMap.get(mapCSCustomer.get(accNameInDoc))[0]);
			}
		}
		if(!mapNameToAccountRecord.isEmpty()) {
			if(String.isBlank(cusDoc.Nokia_Legal_Entity_Account__c)) {
				cusDoc.Nokia_Legal_Entity_Account__c = mapNameToAccountRecord.get(cusDoc.QTO_Nokia_Legal_Entity_Account__c) != null ? mapNameToAccountRecord.get(cusDoc.QTO_Nokia_Legal_Entity_Account__c).Id : null;
			}
			if(String.isBlank(cusDoc.Nokia_Legal_entity__c)) {
				cusDoc.Nokia_Legal_entity__c = mapNameToAccountRecord.get(cusDoc.QTO_Nokia_Legal_Entity_Account__c) != null ? mapNameToAccountRecord.get(cusDoc.QTO_Nokia_Legal_Entity_Account__c).ALU_Unit_Code__c : null;
			}
		}
		return mapNameToAccountRecord;
	}
	
	/** **/
	
	public static String mapCPOFields(String pdfValue,String fieldType,String customerName) {
		String cdRecordMapping ;   
		Boolean valueExists = false;
		Schema.DescribeFieldResult fieldResult  = null;
		if(customerName == null) {
			if(fieldType=='Classification') 
				fieldResult = Customer_Document__c.Classification__c.getDescribe();
			
			if(fieldType=='Sub-Classification') 
				fieldResult = Customer_Document__c.Sub_Classification__c.getDescribe();
			
			
			if(fieldType=='Nature') 
				fieldResult = Customer_Document__c.QTO_Nature__c.getDescribe();
			
			
			if(fieldType=='Legal Entity Postal Code') {
				valueExists = false;
			}
			else {
				List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
				for (Schema.PicklistEntry pickListVal : ple) {
					if (pickListVal.getLabel() == pdfValue) {
						valueExists = true;
						cdRecordMapping  = pdfValue;	  
					}
				} 
			}
			if (!valueExists) {
				if(cpoFieldMapping.containsKey(fieldType)) {
					List<QTO_CPO_Field_Mapping__c> ctoMaps = cpoFieldMapping.get(fieldType);
					for(QTO_CPO_Field_Mapping__c ctoMap : ctoMaps) {
						if(ctoMap.Type__c == fieldType && ctoMap.PDF_Value__c == pdfValue) {
							cdRecordMapping =  ctoMap.Mapping__c;
							valueExists = true;
							break;
						}
					}
				}
			}
		}
		
		if(cpoFieldMapping.containsKey(fieldType) && customerName != null) {
			System.debug('QTO :  ' + cpoFieldMapping.containsKey(fieldType));
			List<QTO_CPO_Field_Mapping__c> ctoMaps = cpoFieldMapping.get(fieldType);
			 System.debug('QTO :  ' + ctoMaps);
			for(QTO_CPO_Field_Mapping__c ctoMap : ctoMaps) {
				 System.debug('QTO :  ctoMap.Type__c == fieldType' + (ctoMap.Type__c == fieldType));
				 System.debug('QTO :  ctoMap.PDF_Value__c == pdfValue' + (ctoMap.PDF_Value__c == pdfValue));
				 System.debug('QTO :  ctoMap.Customer_Name__c == customerName' + (ctoMap.Customer_Name__c == customerName));
				if(ctoMap.Type__c == fieldType && ctoMap.PDF_Value__c == pdfValue && ctoMap.Customer_Name__c == customerName) {
					System.debug('QTO :  LEGAL ENTITY' + ctoMap.Mapping__c);
					cdRecordMapping =  ctoMap.Mapping__c;
					valueExists = true;
					break;
				}  
			}
		}
		//if (!valueExists)
		//return pdfValue;	  
		//else
		return cdRecordMapping;		
	}
	
	
	
	
	/** **/
	public static void populateCustomSettings() {		
		for(QTO_CPO_Field_Mapping__c mapping : [SELECT Name, Customer_Name__c, Mapping__c,PDF_Value__c, Type__c FROM QTO_CPO_Field_Mapping__c]) {		 
			
			if(mapping.Type__c == 'Customer Name'){
				mapCSCustomer.put(mapping.PDF_Value__c,mapping.Mapping__c);
			}
			
			if(cpoFieldMapping.containsKey(mapping.Type__c)) {
				List<QTO_CPO_Field_Mapping__c> ctoExistingList = cpoFieldMapping.get(mapping.Type__c);
				ctoExistingList.add(mapping);
				cpoFieldMapping.put(mapping.Type__c, ctoExistingList);
			} else {
				cpoFieldMapping.put(mapping.Type__c, new List<QTO_CPO_Field_Mapping__c> { mapping }); 
			}
		}  
		System.debug('cpoFieldMapping >>>> '+cpoFieldMapping);
		
	}
	/** **/	
	public static void getMapPaymentTerms() {		
		for(Apttus_Config2__PaymentTerm__c paymentTermSO : [SELECT Id, Name FROM Apttus_Config2__PaymentTerm__c]){
			mapPaymentTermInfos.put(paymentTermSO.Name,paymentTermSO.Id);			
		}
	}
	/** **/
	public static Date getDocumentDate(String dateString) {
		if(dateString != null){
			List<String> dates = new List<String>();
			if(dateString.contains('.'))
				dates = dateString.split('\\.');
			else if(dateString.contains('-'))
				dates = dateString.split('-');
			else if(dateString.contains('/'))
				dates = dateString.split('/');
			else if(dateString.contains(' '))
				dates = dateString.split(' ');
			
			List<String> finalDates = new List<String>();
			for(String s : dates){
				s = s.trim();
				finalDates.add(s);
			}
			system.debug(finalDates+' finalDates ');
			if(!finalDates.isEmpty()){
				if(finalDates[2].length() == 2)
					finalDates[2] = '20'+finalDates[2];
				
				if(finalDates.size() > 2){
					// added by HCL for SF 01797590		
					if(finalDates[1].isNumeric()){
						system.debug('is numeric');
						return Date.newInstance(Integer.valueOf(finalDates[2]), Integer.valueOf(finalDates[1]), Integer.valueOf(finalDates[0]));
						
					}else if (finalDates[1].isAlpha()){
						system.debug('is alpha');
						Integer month; 
						string mon = finalDates[1].toUppercase();
						switch on mon{
							when 'JAN', 'JANUARY' { month = 1;}
							when 'FEB' { month = 2;}
							when 'MAR' { month = 3;}
							when 'APR' { month = 4;}
							when 'MAY' { month = 5;}
							when 'JUN' { month = 6;}
							when 'JUL' { month = 7;}
							when 'AUG' { month = 8;}
							when 'SEP' { month = 9;}
							when 'OCT' { month = 10;}
							when 'NOV' { month = 11;}
							when 'DEC' { month = 12;}
							when else  { month = -1;}			
						} // switch end
						return Date.newInstance(Integer.valueOf(finalDates[2]), Integer.valueOf(month), Integer.valueOf(finalDates[0]));
						
					}else 
						return null;
					// end of : HCL for SF 01797590
				}else 
					return null;
			} else 
				return null;
		} else {
			return null;
		}
	}
	/** **/
	public static String formatCurrency(String totalAmount) {
		if(totalAmount != null){
			
			String totalAmountString = totalAmount;
			String precision = '00';
			if(totalAmountString.contains(' '))
				totalAmountString = totalAmountString.replaceAll(' ','');
			
			if(totalAmountString.contains('\\.') || totalAmountString.contains(',') || totalAmountString.contains('.')) {
				if(totalAmountString.contains('\\.')) {
					precision = totalAmountString.substring(totalAmountString.lastIndexOf('\\.')+1, totalAmountString.length());
				}
				if (totalAmountString.contains(',')) {
					precision = totalAmountString.substring(totalAmountString.lastIndexOf(',')+1, totalAmountString.length());
				}
				if (totalAmountString.contains('.')) {
					precision = totalAmountString.substring(totalAmountString.lastIndexOf('.')+1, totalAmountString.length()); 
				} 
				totalAmountString = totalAmountString.replaceAll('[^a-zA-Z0-9]','');
				totalAmountString = totalAmountString.substring(0,totalAmountString.length()- precision.length()) + '.' + totalAmountString.substring(totalAmountString.length()- precision.length(), totalAmountString.length());
			}
			return totalAmountString;
			
		} else {
			return String.valueOf('0.00');
		}
	}
	
	/** **/
	private static List<CD_Association_to_CD__c> associateCdToCd(Customer_Document__c cusDoc) {
		List<CD_Association_to_CD__c> customerAssociationList = new List<CD_Association_to_CD__c>();
		Map<Id,Customer_Document__c> cdsMap = new Map<Id,Customer_Document__c>();
		List<String> customerDocumentIdList = new List<String>();
		boolean isCustomerFound = false;
		boolean isNokiaLegalEntityFound = false;
		boolean isClassificationFound = false;
		boolean isSubClassificationFound = false;
		List<Id> customerDocumentIds = new List<Id>();
		List<Customer_Document__c> matchedList = new List<Customer_Document__c>();
		try {
			
			if(cusDoc.QTO_Nature__c == QTO_Constants.CANCEL){
				matchedList = [Select Id, Name, Customer_Document_ID__c, Customer__c, Classification__c, 
							   Sub_Classification__c, Nokia_Legal_entity__c,Customer_Document_Date__c,QTO_Nature__c 
							   FROM Customer_Document__c
							   WHERE Customer_Document_ID__c =: cusDoc.Customer_Document_ID__c
							   AND Classification__c =:  cusDoc.Classification__c 
							   AND Sub_Classification__c =:  cusDoc.Sub_Classification__c 
							   AND Nokia_Legal_entity__c =:  cusDoc.Nokia_Legal_entity__c 
							   AND Customer__c =:  cusDoc.Customer__c 
							   AND QTO_Nature__c !=:  cusDoc.QTO_Nature__c 
							   AND Name !=:  cusDoc.Name 
							   ORDER BY Customer_Document_Date__c DESC];
			}
			else {
				matchedList = [Select Id, Name, Customer_Document_ID__c, Customer__c, Classification__c, 
							   Sub_Classification__c, Nokia_Legal_entity__c,Customer_Document_Date__c,QTO_Nature__c 
							   FROM Customer_Document__c
							   WHERE Customer_Document_ID__c =: cusDoc.Customer_Document_ID__c
							   AND Classification__c =:  cusDoc.Classification__c 
							   AND Sub_Classification__c =:  cusDoc.Sub_Classification__c 
							   AND Nokia_Legal_entity__c =:  cusDoc.Nokia_Legal_entity__c 
							   AND Customer__c =:  cusDoc.Customer__c 
							   AND Name !=:  cusDoc.Name 
							   ORDER BY Customer_Document_Date__c DESC];
			}
			
			if(matchedList.size()>0) {
				for (Customer_Document__c matchedCD: matchedList) {
					CD_Association_to_CD__c cdAssociation = new CD_Association_to_CD__c();
					cdAssociation.QTO_Nokia_Customer_Document_ID__c = matchedCD.Id;
					cdAssociation.QTO_Customer_Document_Date__c = matchedCD.Customer_Document_Date__c;
					cdAssociation.QTO_Manual__c = false;
					cdAssociation.QTO_Nature__c =  matchedCD.QTO_Nature__c ;
					cdAssociation.Customer_Document__c = cusDoc.Id;
					customerAssociationList.add(cdAssociation);
				}
			}
			if(customerAssociationList.size()>0) {
				try {
					insert customerAssociationList;
				} catch (Exception e){
					System.debug('*****error inserting customerAssociationList: '+e.getMessage());
				}
			}
		} catch(Exception ex){
			System.debug('*****error : '+ex.getMessage());
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CustomerDocumentTriggerHelper ,CSWXGlobalConstant.CheckValidation);
		}
		return customerAssociationList;
	}
	//To create Customer Document Issue log related to the Customer Document
	public static QTO_Customer_Document_Issue_Log__c createIssueLog(Id cdId,  Id cdLineId, String errorType, String returnCode, String issueDetails){
		QTO_Customer_Document_Issue_Log__c issueLog = new QTO_Customer_Document_Issue_Log__c();
		issueLog.QTO_CustomerDocumentId__c = cdId;
		issueLog.QTO_CustomerDocumentItemId__c = cdLineId;
		issueLog.QTO_ErrorType__c = errorType; 
		issueLog.QTO_Return_Code__c = returnCode;
		issueLog.QTO_IssueDetails__c = issueDetails;
		return issueLog;
	}
}