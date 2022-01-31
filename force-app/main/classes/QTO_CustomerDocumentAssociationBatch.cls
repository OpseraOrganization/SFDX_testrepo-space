/**
* @Name: QTO_CustomerDocumentAssociationBatch
* @Author: Akanksha Trivedi
* @CreateDate: 10/29/2020
* @Description: This Batch Job would process Customer Document records which are Registered status. 
* @CalledFrom : QTO_AutomaticAssociationScheduler
* @LastModifiedBy: Raj Kamadar
* @LastModifiedDate: 08/12/2020
* @ChangeDescription: Updated the Batch class with DML Statments
**/
global with sharing class QTO_CustomerDocumentAssociationBatch implements Database.Batchable<sObject> {
	String query;
	
	public static final String REGISTERED = 'Registered';
	
	Set<String> docIDs;
	
	// Constructor
	public QTO_CustomerDocumentAssociationBatch(Set<String> docIDSet){
		docIDs = new Set<String>();		
		docIDs = docIDSet;
	}
	public QTO_CustomerDocumentAssociationBatch(){
	docIDs = new Set<String>();
	}
	
   /**
	* @description : Fetch Customer Document based on either Salesforce Record-ID (Re-Take Mechanism) or Status
	* @author Raj Kamdar | 11-25-2020 
	* @param Batch Contrext
	* @return List<Customer_Document__c> 
	**/
	
	global Database.QueryLocator start(Database.BatchableContext bc){
		system.debug('In Start');  
		if(!docIDs.isEmpty()){
			query = 'SELECT id,Customer__c from Customer_Document__c WHERE Id in :docIDs' ;
		}else{
			query = 'SELECT id,Customer__c from Customer_Document__c WHERE Status__c  = \''+REGISTERED+'\'' ;
		}		
		return Database.getQueryLocator(query);
	}
	
	/**
	* @description : Process Customer-Document.
	* @author Raj Kamdar | 11-25-2020 
	* @param Batch Context.
	* @return void
	**/
	
	global void execute(Database.BatchableContext bc, List<Customer_Document__c> customerDocList){
		QTO_AssociationDMLWrapper insertionWrapper = new QTO_AssociationDMLWrapper();
		insertionWrapper = QTO_AutomateAssociationController.autoAssociateCustomerDocuments(customerDocList);
		
		try{
			deleteData(insertionWrapper);
			insertData(insertionWrapper);
			updateData(insertionWrapper);
		}
		catch(QTO_CustomException e){
			throw new QTO_CustomException('Error occurred while inserting association data. \nDetails: '+e.getMessage());
		}
		
		
	}
	
   /**
	* @description : Finish Method of Batch
	* @author Raj Kamdar | 11-25-2020 
	* @param Batch Context.
	* @return void
	**/
	
	global void finish(Database.BatchableContext bc){
		system.debug('In Finish method');
	}	

	/**
	* @description : Perform Delete DML statements. 
	* @author Raj Kamdar 
	* @param insertionWrapper 
	**/
	private void deleteData(QTO_AssociationDMLWrapper insertionWrapper){
		if(insertionWrapper.listExistingQuoteJunction.size()>0){
			delete insertionWrapper.listExistingQuoteJunction;
		}
		if(insertionWrapper.listExistingAgreementJunction.size()>0){
			delete insertionWrapper.listExistingAgreementJunction;
		}
		if(insertionWrapper.listExistingQLIJunction.size()>0){
			delete insertionWrapper.listExistingQLIJunction;
		}
		if(insertionWrapper.listExistingLogs.size()>0){
			delete insertionWrapper.listExistingLogs;
		}
	}

	/**
	* @description : Perform Insert DML statements. 
	* @author Raj Kamdar 
	* @param insertionWrapper 
	**/
	private void insertData(QTO_AssociationDMLWrapper insertionWrapper){
		if(insertionWrapper.listQuoteJunction.size()>0){
			insert insertionWrapper.listQuoteJunction;
		}
		system.debug('insertionWrapper.listAgreementJunction--->'+insertionWrapper.listAgreementJunction);
		if(insertionWrapper.listAgreementJunction.size()>0){
			insert insertionWrapper.listAgreementJunction;
		}
		if(insertionWrapper.listQLIJunction.size()>0){
			insert insertionWrapper.listQLIJunction;
		}
		if(insertionWrapper.listLogs.size()>0){
			insert insertionWrapper.listLogs;
		}
		if(insertionWrapper.listTasks.size()>0){
			insert insertionWrapper.listTasks;
		}
	}

	/**
	* @description : Perform Update DML statements.
	* @author Raj Kamdar 
	* @param insertionWrapper 
	**/
	private void updateData(QTO_AssociationDMLWrapper insertionWrapper){
		if(insertionWrapper.listQuotesToUpdate.size()>0){
			update insertionWrapper.listQuotesToUpdate;
		}
		if(insertionWrapper.customerDocument!=null){
			update insertionWrapper.customerDocument;
		}
		if(insertionWrapper.listCDLIs.size()>0){
			update insertionWrapper.listCDLIs;
		}
		if(insertionWrapper.listExistingTasks.size()>0){
			update insertionWrapper.listExistingTasks;
		}
	}
}