/****************************************
* Name : Batch_EDPSuppliersToAccount
* Author : Raj Dubey
* Description : This class is for loading data from Suppliers to Account 
* ReqNo : 
****************************************/
global class Batch_EDPSuppliersToAccount implements Database.Batchable<sObject>,Database.Stateful,Schedulable 
{
	
	public string source_type = 'Supplier_Staging__c';
	private static boolean debug = false;
	Id vendorRecordTypeId =
		Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
		.get('Vendor').getRecordTypeId();
	Id legalEntityRecordTypeId =
		Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
		.get('Legal_Entity').getRecordTypeId();
	
/****************************************
* Name : execute
* Description : executes the batch class using schedulable instance
* Parameters: SchedulableContext
*****************************************/
	global void execute(SchedulableContext SC)	  
	{
		Batch_EDPSuppliersToAccount  batch= new Batch_EDPSuppliersToAccount();
		Database.executebatch(batch,100);
		
	} 
	
  /****************************************
* Name : start
* Description : Retrieves the data from Supplier staging object
* Parameters: Database.BatchableContext
* Returns : Database.QueryLocator
*****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		
		String s_query = 'SELECT Id, Supplier_ID__c, Company_Name__c, Current_Supplier_Role__c, URL__c,'+
			'Street_Name__c, City__c, Name_Of_Street_District__c, ZIP_Code__c, Country__c,'+
			'Active_Status__c, Internal_Company__c, Company_Lifecycle_Status__c,'+
			'EDP_LastModifiedDate__c, EDP_ActiveStatus__c, Is_Processed__c FROM Supplier_Staging__c WHERE Is_Processed__c = FALSE' ;
		System.debug('SOQL '+s_query);		
		return database.getQueryLocator(s_query); 
	}
	
	/****************************************
* Name : execute
* Description : Retrieves the data from Supplier staging object
* Parameters: Database.BatchableContext, List of Suppliers
* Returns : 
*****************************************/ 
	global void execute(Database.BatchableContext BC, List<Supplier_Staging__c> suppliers)	{	 
		
		
	
		List<Account> parentAccountsUpsert = new List<Account>();
		Map<String, Account> childAccountsUpsertMap = new  Map<String, Account>();
		List<Account> childAccountsUpsert = new List <Account>();
		List<interface_log__c> ilogs = new List<interface_log__c>();
		List<String> successSuppIds = new List<String>();
		Map<String,String> successNewSuppParentIdMap = new  Map<String,String>();
		Map<String,String> successSuppChildIdMap = new Map<String,String>();
		List<Supplier_Staging__c> updateProcessedToTrue = new List<Supplier_Staging__c>();
		
		for (Supplier_Staging__c supp: suppliers){
			
			Account accParentReference = new Account(External_Id__c=('T1_'+supp.supplier_id__c));
			Account accParent = new Account(External_Id__c='T1_'+supp.supplier_id__c,
					Name = supp.Company_Name__c,
					AccountNumber = 'v'+supp.Supplier_ID__c,
					BusinessPartnerRole__c = 'Vendor',
					Type = 'Vendor',
					BillingCity = supp.City__c,
					BillingCountryCode  = supp.Country__c,
					State__c = supp.Name_Of_Street_District__c,					
					BillingStreet = supp.Street_Name__c,
					BillingPostalCode = supp.ZIP_Code__c,			
					Country__c = supp.Country__c,
					RecordTypeId = vendorRecordTypeId,
					Website = supp.URL__c,
					CountryCode__c = supp.Country__c,
					Acc_No__c = 'v'+supp.Supplier_ID__c
					
			 );
			
			Account accChild = new Account(
	Parent=accParentReference,
	AccountNumber = supp.Supplier_ID__c,
	External_Id__c = 'T2_'+supp.Supplier_ID__c,
	ALCR_Record_Type__c = 'Vendor',
	Type = 'Vendor',
	NCP_P20_ID__c = supp.Supplier_ID__c+'_vendor',
	RecordTypeId = legalEntityRecordTypeId,
	BillingCity = supp.City__c,	
	BillingCountryCode  = supp.Country__c,	
	State__c = supp.Name_Of_Street_District__c,	 
	BillingStreet = supp.Street_Name__c,
	BillingPostalCode = supp.ZIP_Code__c,			 
	Country__c = supp.Country__c,
	CountryCode__c = supp.Country__c,
	Website = supp.URL__c,
	AccountLifecycleStatus__c = supp.Company_Lifecycle_Status__c,
	Name = supp.Company_Name__c		 
			);
			
			parentAccountsUpsert.add(accParent);
			childAccountsUpsertMap.put(supp.Supplier_ID__c, accChild);
			
			
		}
		
			
		// Upsert the Tier 1 accounts.  
		 
		List<Database.UpsertResult> tier1Upsert = Database.upsert(parentAccountsUpsert,  Account.External_Id__c, false);
	
		for(Integer index = 0, size = tier1Upsert.size(); index < size; index++) 
		{
			String operationType = (tier1Upsert[index].isCreated() ? 'Insert' : 'Update');
			if(tier1Upsert[index].isSuccess()) 
			{				
	successSuppIds.add(parentAccountsUpsert[index].External_Id__c.replaceAll('T1_', ''));
	if(tier1Upsert[index].isCreated()){
	successNewSuppParentIdMap.put(parentAccountsUpsert[index].External_Id__c.replaceAll('T1_', ''), tier1Upsert[index].getId());
	}
		Interface_log__c ilog = createSuccessLog(parentAccountsUpsert[index],operationType, 'Parent Account');
	if(ilog != null)
		ilogs.add(ilog);
			}
			
			else {
	
	Interface_log__c ilog = createErrorLog(tier1Upsert[index].getErrors(),parentAccountsUpsert[index],operationType, 'Parent Account');
	if(ilog != null)
		ilogs.add(ilog);
			}
			
		}
		
System.debug('successSuppIds' +successSuppIds);
		
		for(String sIds : successSuppIds){
			
			childAccountsUpsert.add(childAccountsUpsertMap.get(sIds));
		}
		
		// Upsert the Tier 2 accounts. 
		List<Database.UpsertResult> tier2Upsert = Database.upsert(childAccountsUpsert,   Account.External_Id__c, false);
		
		for(Integer index = 0, size = tier2Upsert.size(); index < size; index++) 
		{
			String operationType = (tier2Upsert[index].isCreated() ? 'Insert' : 'Update');
			if(tier1Upsert[index].isSuccess()) 
			{		
	
	//update processed flag for all staging items if Account is proccessed		 
	Supplier_Staging__c stagingItem = new Supplier_Staging__c();
	stagingItem.put('Is_Processed__c',true);
	stagingItem.put('Supplier_ID__c',childAccountsUpsert[index].External_Id__c.replaceAll('T2_', ''));
	if(tier2Upsert[index].isCreated()){
	successSuppChildIdMap.put(childAccountsUpsert[index].External_Id__c.replaceAll('T2_', ''), tier2Upsert[index].getId());
	}
		updateProcessedToTrue.add(stagingItem);
	Interface_log__c ilog = createSuccessLog(childAccountsUpsert[index],operationType, 'Child Account');
	if(ilog != null)
		ilogs.add(ilog);
			}
			
			else {
	System.debug('ErrorsInside: '+tier2Upsert[index].getErrors());
	Interface_log__c ilog = createErrorLog(tier2Upsert[index].getErrors(), childAccountsUpsert[index], operationType, 'Child Account');
	if(ilog != null)
		ilogs.add(ilog);
			}
			
		}
		
		List<Account> newParentAccToBeDeleted = new List<Account>();  // if child record failed to create for Successful parent account 
		for(String sIds : successNewSuppParentIdMap.keyset()){
			if(successSuppChildIdMap.get(sIds) == null){
	Account acc = new Account();
	acc.id = successNewSuppParentIdMap.get(sIds);
	newParentAccToBeDeleted.add(acc);
			}
			childAccountsUpsert.add(childAccountsUpsertMap.get(sIds));
		}
		
	
		
		
		Database.insert(ilogs,false);
		Database.upsert(updateProcessedToTrue, Supplier_Staging__c.Supplier_ID__c);
		Database.delete(newParentAccToBeDeleted, false);
		
		
		
	}
	
	
	
	
	/****************************************
* Name : createErrorLog
* Description : creates an error log for errors occurred during Acocunt load
* Parameters: Database.Error[], Account record, Operation type
* Returns : Interfacelog
***************************************/
	public Interface_log__c createErrorLog(Database.Error[] errors, Account acc, String operationType, String ParentOrChild)
	{
		Interface_log__c ilog = new Interface_log__c();
		for (Database.Error err : errors)
		{
		ilog.comment__c ='Failure: Supplier Id '+acc.External_Id__c+'Fields: '+err.getFields()+' Message: '+err.getMessage()+
	' Status Code: '+err.getStatusCode();
		}
		ilog.comment__c += errors;
		ilog.Interface_Type__c = 'EDP Suppliers to Account';
		ilog.Message_Type__c = 'Inbound';
		ilog.Operation_Type__c = operationType;
		ilog.Interface_Request_Sent__c = 'Account Name: '+acc.Name+' Supplier ID: '+acc.External_Id__c + ' Record Type: '+acc.RecordTypeId +' Account Number: '+acc.AccountNumber;
		 
		ilog.Status__c = 'Failure';
		ilog.Name = ParentOrChild +operationType+'Failed with '+acc.External_Id__c;
		return ilog;
	}
	
	/****************************************
* Name : createSuccessLog
* Description : creates an success log for errors occurred during Account load
* Parameters: Account record, Operation type
* Returns : Interfacelog
****************************************/ 
	public Interface_log__c createSuccessLog(Account acc, String operationType, String ParentOrChild)
	{
		Interface_log__c ilog = new Interface_log__c();
		ilog.comment__c = 'Success';
		ilog.Interface_Type__c = 'EDP Suppliers to Account';
		ilog.Message_Type__c = 'Inbound';
		ilog.Operation_Type__c = operationType;
		ilog.Interface_Request_Sent__c = 'Account Name: '+acc.Name+' Supplier ID: '+acc.External_Id__c + 'Record Type: '+acc.RecordTypeId +'Account Number: '+acc.AccountNumber;
				
		ilog.Status__c = 'Success';
		ilog.Name = ParentOrChild +operationType+'success with '+acc.External_Id__c;

		
		return ilog;
	}
	
	global void finish(Database.BatchableContext BC)
	{
		
	}
}