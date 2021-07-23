public without sharing class HWS_Lookup_Class {
	@AuraEnabled
	public static List<String> getPickListValues(String obj, String str) {
		String[] options = new String[]{}; 
			Schema.DescribeFieldResult picklistvalues = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(str).getDescribe();
		options.add('--None--');
		for(PicklistEntry ent:picklistvalues.getpicklistvalues())
		{
			options.add(ent.getLabel());
		}
		
		return options;
	}
	//Ship to party Billing Country and State fields logic
	@AuraEnabled 
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
		Map<String, List<String>> objResults = HWS_Utilty.getDependentMap(objDetail, contrfieldApiName,depfieldApiName);
		return objResults;
	}
	@auraEnabled
	public static Account getDefaultvalues(string accountId)
	{   
		Account accs= [SELECT Id,Name FROM Account where Id = :accountId];
		return accs;
	}
	@AuraEnabled
	public static List<untitleSObject> findContactList(String searchKey, String objectName, String returnValue) {
		List<list<SObject>> workingSearchList = new List<List<SObject>>();
		List<untitleSObject> workingList= new List<untitleSObject>();
		String searchQuery = 'FIND \'' + String.escapeSingleQuotes(searchKey) + '*\'  IN ALL FIELDS RETURNING '+ objectName+' (Id,'+returnValue+') LIMIT 50';  
		//String searchQuery = 'FIND {' + String.escapeSingleQuotes(searchKey) + '*}  IN ALL FIELDS RETURNING '+ objectName+' (Id,'+returnValue+') LIMIT 50';  
		//FIND {test*}  IN ALL FIELDS RETURNING Contact (Id,Name) LIMIT 50
		workingSearchList = search.query(searchQuery);		
		for(List<SObject> sObj: workingSearchList)  {
			for (SObject so : sObj) {
				untitleSObject workObj = new untitleSObject();
				workObj.currentworkingTitleId = (Id)so.get('Id');
				workObj.currentworkingTitleName = (String)so.get(returnValue);
				//workObj.currentworkingTitleName = (String)so.get('Name');
				if(workingList == null) {
					workingList = new List<untitleSObject>();
				}
				workingList.add(workObj);
			}
		}
		return workingList;
	}
	//To be able to search Ship to party Address fields 
	//25672 pasing two more params "triggeredFrom" & "lineItemCountry" to get Shiptoparty Address (Logistic Account) based on those filters--> NOKIASC-25672
	@AuraEnabled
	public static List<untitleSObject> searchShiptoParty(String searchKey, String objectName, String returnValue, String parentAccountValue, String addrType, List<Asset> selectedAsset, List<Account> legalAccRec, String triggeredFrom, String lineItemCountry){
		String erp = selectedAsset[0].HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c;		
		if(erp !=null && erp !='' && erp != 'P20'){
			erp = 'eSpares';
		}
		String legalAccId =legalAccRec[0].Id; 
		Id legalEntity = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Legal_Entity);
		//Id LogisticEntity = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT);
		Id logisticEntityExisting = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id wareHouseAccId = ID.valueof(Label.Account_ID_of_Global_Warehouse_Addresses);
		string searchQuery='';
		list<SObject> workingSearchList = new List<SObject>();
		List<untitleSObject> workingList= new List<untitleSObject>();
		// string searchQuery = 'SELECT Id,Name from Account where RecordTypeId =: LogisticEntity AND ParentId =\''+parentAccountValue[0].id+'\' AND (BillingCountry like \'%'+searchKey+'%\'  OR BillingCity like \'%'+searchKey+'%\' OR BillingPostalCode like \'%'+searchKey+'%\' OR BillingStreet like \'%'+searchKey+'%\' OR BillingState like \'%'+searchKey+'%\') limit 50';
		if(addrType == 'shipToParty'){//ADDED FOR 1358 TO DIFFERENTIATE BETWEEN STP AND WAREHOUSE ADDRS
			searchQuery = 'SELECT Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,BillingState,BillingCountry,BillingPostalCode from Account where ParentId =: legalAccId AND RecordTypeId =: logisticEntityExisting AND AccountSource =: erp AND (BillingCountry like \'%'+searchKey+'%\'  OR BillingCity like \'%'+searchKey+'%\' OR BillingPostalCode like \'%'+searchKey+'%\' OR BillingStreet like \'%'+searchKey+'%\' OR BillingState like \'%'+searchKey+'%\')';
		}else if(addrType == 'wareHouseAddress'){
			searchQuery = 'SELECT Id,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,BillingState,BillingCountry,BillingPostalCode from Account where ParentId =: wareHouseAccId AND RecordTypeId =: logisticEntityExisting AND (BillingCountry like \'%'+searchKey+'%\'  OR BillingCity like \'%'+searchKey+'%\' OR BillingPostalCode like \'%'+searchKey+'%\' OR BillingStreet like \'%'+searchKey+'%\' OR BillingState like \'%'+searchKey+'%\')';
		}//ADDED FOR 1358 TO DIFFERENTIATE BETWEEN STP AND WAREHOUSE ADDRS		
	   
		//Adding ContractLineItem's Country condition to get Shiptoparty Address (Logistic Account)--> NOKIASC-25672 nad NOKIASC-27280 (portal)
		if(triggeredFrom == 'console' || triggeredFrom == 'portal'){
			searchQuery = searchQuery + ' AND BillingCountry =:lineItemCountry';
		}
		searchQuery = searchQuery + ' limit 5000';		
		workingSearchList = database.query(searchQuery);		
		//  for(list<SObject> sObj: workingSearchList)  {
		for (SObject so : workingSearchList) {
			untitleSObject workObj = new untitleSObject();
			workObj.currentworkingTitleId = (Id)so.get('Id');
			workObj.currentworkingTitleName = (String)so.get(returnValue);
			workObj.addressLine1 = (String)so.get('Hws_Address_Line_1__c');
			workObj.addressLine2 = (String)so.get('Hws_Address_Line_2__c');
			workObj.addressLine3 = (String)so.get('Hws_Address_Line_3__c');
			workObj.cityStateCountry = (String)so.get('BillingCity');
			if((String)so.get('BillingState')!=null){
				workObj.cityStateCountry =workObj.cityStateCountry +','+(String)so.get('BillingState');
			}
			if((String)so.get('BillingCountry')!=null){
				workObj.cityStateCountry = workObj.cityStateCountry +','+(String)so.get('BillingCountry');
			}
			if((String)so.get('BillingPostalCode')!=null){
				workObj.cityStateCountry = workObj.cityStateCountry +','+(String)so.get('BillingPostalCode');
			}
			//workObj.currentworkingTitleName = (String)so.get('Name');
			workObj.country = (String)so.get('BillingCountry');
			if(workingList == null) {
				workingList = new List<untitleSObject>();
			}
			workingList.add(workObj);
		}		
		return workingList;
	}
	
	public class untitleSObject {
		@AuraEnabled
		public String currentworkingTitleId {get; set;}
		@AuraEnabled
		public String currentworkingTitleName {get; set;}
		@AuraEnabled
		public String currentworkingName {get; set;}
		@AuraEnabled
		public String addressLine1{get; set;}
		@AuraEnabled
		public String addressLine2{get; set;}
		@AuraEnabled
		public String addressLine3{get; set;}
		@AuraEnabled
		public String cityStateCountry{get; set;}
		@AuraEnabled
		public String country{get; set;}
	}
	@AuraEnabled
	public static untitleSObject createContact(Id accountRecId, Contact contactRecord) {
		untitleSObject untitleProjec = new untitleSObject();
		contactRecord.AccountId = accountRecId;
		//starts - 3843
		Nokia_Employee_Email_Domains__c nokEmpEmlDom = [select id, Nokia_Valid_Domain__c from Nokia_Employee_Email_Domains__c];
		if(nokEmpEmlDom.Nokia_Valid_Domain__c != null){
			List<String> emalDomList = new List<String>();
			if(nokEmpEmlDom.Nokia_Valid_Domain__c.contains(',')){
				emalDomList = nokEmpEmlDom.Nokia_Valid_Domain__c.split(',');
			}
			String emailDomain;
			if(contactRecord.Email.contains('@')){
				emailDomain = contactRecord.Email.split('@').get(1);
			}
			Boolean isNokiaEmp = false;
			if(emalDomList.size()>0){
				for(String s:emalDomList){				
					if(s.contains('@')){
						if(s=='@'+emailDomain){
							isNokiaEmp = true;
						}
					}
					else {
						if(s==emailDomain){
							isNokiaEmp = true;					
						}
					}
				}
			}
			if(isNokiaEmp){
				contactRecord.CH_ContactType__c = 'Nokia Employee';
			}
			else{
				contactRecord.CH_ContactType__c = 'Customer';
			}
		}
		//ends - 3843
		Database.SaveResult[] results1 = Database.insert(new SObject[] {contactRecord});
		Contact contactRec = [select Id,Name from Contact where id =: contactRecord.Id];
		untitleProjec.currentworkingTitleId = contactRecord.Id;
		untitleProjec.currentworkingTitleName = contactRec.Name;
		return untitleProjec;
	}
	
	//to update the Account Ship to party delivery address  
	@AuraEnabled
	public static untitleSObject updatetoParentCase(list<Account> selectedAccRec, Account accountRecord, List<Asset> selectedAsset) {
		accountRecord.name = accountRecord.Name;		
		accountRecord.AccountSource = selectedAsset[0].HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c;
		if(accountRecord.AccountSource != 'P20'){
			accountRecord.AccountSource = 'eSpares'; 
		}		
		if(selectedAccRec != null){
			accountRecord.ParentId = selectedAccRec[0].id;
		}
		if(accountRecord.BillingCountry == '--None--'){
			accountRecord.BillingCountry = Null;
		}
		if(accountRecord.BillingState == '--None--'){
			accountRecord.BillingState = Null;
		}
		accountRecord.Logistic_Account_Type__c = 'Ship-To';
		accountRecord.HWS_Address_Status__c ='Temporary Address';
		//accountRecord.P20_Logistic_ID__c ='a1432'; // added by ajesh
		untitleSObject untitleProjec = new untitleSObject();
		// Id logisticAccount = HWS_Utilty.getRecordTypeByName('ACCOUNT',HWS_Constants.LOGISTIC_ACCOUNT);
		Id logisticAccountExisting = HWS_Utilty.getRecordTypeByName('ACCOUNT',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		
		accountRecord.RecordTypeId = logisticAccountExisting;
		Database.SaveResult[] results1 = Database.insert(new SObject[] {accountRecord});
		Account accRec = [select Id,Name from Account where id =: accountRecord.Id];
		untitleProjec.currentworkingTitleId = accountRecord.Id;
		untitleProjec.currentworkingTitleName = accRec.Name; 
		return untitleProjec;
	}
}