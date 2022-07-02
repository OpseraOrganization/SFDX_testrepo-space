/*********************************************************************
* Class Name : QTO_CustomerDocumentMaturityLevel
* Test Class : QTO_CustomerDocumentMaturityLevelTest
* Created Date: 16 Feb 2022
* Created By : Shaik Johny Basha
* Description : DSI-2413 to adopt the Maturity level changes
*******************************************************************/
public with sharing class QTO_CustomerDocumentMaturityLevel {
	private static final String MATURITY_LEVEL = 'Maturity Level';
	
	
	/**
	* @description: Process Maturity Level based on the CPO field mapping
	* @param customerDoc: Customer Document.
	* @param currentCDStatus:  current Customer Document Status .
	* @return 
	**/  
	public static Customer_Document__c processMaturityLevel(Customer_Document__c customerDoc, String currentCDStatus) {
		System.debug('QTO_CustomerDocumentMaturityLevel : processMaturityLevel : cDoc : ' + customerDoc);
		System.debug('QTO_CustomerDocumentMaturityLevel : processMaturityLevel : currentCDStatus : ' + currentCDStatus);
		
		Map<String, QTO_CPO_Field_Mapping__c> fieldMapping =  findMaturityConfiguration();
		Map<String, QTO_CDMaturityMetadata__mdt> maturityMetadata = getCustomerDocumentMetadata();
		
		
		//Check Meturity level in CPO Field
		if(fieldMapping.containsKey(customerDoc.QTO_Customer_Name__c) && maturityMetadata.containsKey(currentCDStatus)) {
			QTO_CPO_Field_Mapping__c fieldMap= fieldMapping.get(customerDoc.QTO_Customer_Name__c);
			QTO_CDMaturityMetadata__mdt metadata = maturityMetadata.get(currentCDStatus);
			System.debug('QTO_CustomerDocumentMaturityLevel : ' + Integer.valueOf(metadata.Maturity_Value__c));
			System.debug('QTO_CustomerDocumentMaturityLevel Field Mapping: ' + Integer.valueOf(fieldMap.Mapping__c));
			if(Integer.valueOf(fieldMap.Mapping__c)  <= Integer.valueOf(metadata.Maturity_Value__c)) { 
			//if(Integer.valueOf(metadata.Maturity_Value__c)  <= Integer.valueOf(fieldMap.Mapping__c)) {
				customerDoc.Status__c = QTO_Constants.CD_STATUS_CPO_CREATION;
				customerDoc.QTO_Line_Iteam_Association_Comment__c =  metadata.QTO_Line_Item_Association_Comment__c;
				customerDoc.QTO_Line_Item_Matching_Comment__c =  metadata.QTO_Line_Item_Matching_Comment__c;
			}
			else {
				if(currentCDStatus == QTO_Constants.STATUS_ENRICHMENT_FAILED) {
					customerDoc.QTO_Line_Iteam_Association_Comment__c =  'Failed';
					customerDoc.QTO_Line_Item_Matching_Comment__c =  'Failed';
					customerDoc.Status__c = currentCDStatus; 
				}
				else if(currentCDStatus == QTO_Constants.STATUS_ASSOCIATION_FAILED) {
					customerDoc.QTO_Line_Iteam_Association_Comment__c =  'Failed';
					customerDoc.QTO_Line_Item_Matching_Comment__c =  'Failed';
					customerDoc.Status__c = currentCDStatus; 
				}
				else if(currentCDStatus == QTO_Constants.STATUS_MATCHING_FAILED) {
					customerDoc.QTO_Line_Iteam_Association_Comment__c =  'Successful';
					customerDoc.QTO_Line_Item_Matching_Comment__c =  'Failed';
					customerDoc.Status__c = currentCDStatus; 
				}
				else {
					customerDoc.QTO_Line_Iteam_Association_Comment__c =  'Not Attempted';
					customerDoc.QTO_Line_Item_Matching_Comment__c =  'Not Attempted';
				}
				
			}
		}
		else {
			System.debug('CD Processing : No Maturity value in CPO Field Mapping');
			if(currentCDStatus == QTO_Constants.STATUS_ENRICHMENT_FAILED) {
				customerDoc.QTO_Line_Iteam_Association_Comment__c =  'Failed';
				customerDoc.QTO_Line_Item_Matching_Comment__c =  'Failed';
				customerDoc.Status__c = currentCDStatus; 
			}
			else if(currentCDStatus == QTO_Constants.STATUS_ASSOCIATION_FAILED) {
				customerDoc.QTO_Line_Iteam_Association_Comment__c =  'Failed';
				customerDoc.QTO_Line_Item_Matching_Comment__c =  'Failed';
				customerDoc.Status__c = currentCDStatus; 
			}
			else if(currentCDStatus == QTO_Constants.STATUS_MATCHING_FAILED) {
				customerDoc.QTO_Line_Iteam_Association_Comment__c =  'Successful';
				customerDoc.QTO_Line_Item_Matching_Comment__c =  'Failed';
				customerDoc.Status__c = currentCDStatus; 
			}
			else {
				customerDoc.QTO_Line_Iteam_Association_Comment__c =  'Not Attempted';
				customerDoc.QTO_Line_Item_Matching_Comment__c =  'Not Attempted';
			}
			
		}
		return customerDoc;
	}
	
	/**
	* @description: find the maturity configuration from CPO Field Mapping
	* @return Map<String, QTO_CPO_Field_Mapping__c>
	**/
	public static Map<String, QTO_CPO_Field_Mapping__c> findMaturityConfiguration() {
		Map<String, QTO_CPO_Field_Mapping__c> fieldMapping = new Map<String, QTO_CPO_Field_Mapping__c>();
		List<QTO_CPO_Field_Mapping__c> mappingList = 
			[
				SELECT Name, Customer_Name__c, Mapping__c,PDF_Value__c, Type__c FROM QTO_CPO_Field_Mapping__c
				WHERE Type__c =: MATURITY_LEVEL							  
			];
		
		for (QTO_CPO_Field_Mapping__c mapping :mappingList) {
			fieldMapping.put(mapping.Customer_Name__c, mapping);
		}
		return fieldMapping;
	}
	
	/**
	* @description: Get meta data from QTO_CDMaturityMetadata__mdt
	* @return Map<String, QTO_CDMaturityMetadata__mdt>
	**/
	private static Map<String, QTO_CDMaturityMetadata__mdt> getCustomerDocumentMetadata() {
		Map<String, QTO_CDMaturityMetadata__mdt> maturityMetadata = new Map<String, QTO_CDMaturityMetadata__mdt>();
		for (QTO_CDMaturityMetadata__mdt metadata :[
			SELECT id, Customer_Document_Status__c, Maturity_Value__c, QTO_Line_Item_Association_Comment__c, 
			QTO_Line_Item_Matching_Comment__c FROM QTO_CDMaturityMetadata__mdt
		]) {
			maturityMetadata.put(metadata.Customer_Document_Status__c, metadata);
		}
		return maturityMetadata;
	}
}