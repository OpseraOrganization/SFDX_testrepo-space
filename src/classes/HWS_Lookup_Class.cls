public without sharing class HWS_Lookup_Class {
	@AuraEnabled
	public static List<String> getPickListValues(String obj, String str) {
		String[] options = new String[]{}; 
			Schema.DescribeFieldResult picklistvalues = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(str).getDescribe();
		options.add(HWS_Constants.None);
		for(PicklistEntry ent:picklistvalues.getpicklistvalues())
		{
			options.add(ent.getLabel());
		}
		
		return options;
	}
	//Ship to party Billing Country and State fields logic
	@AuraEnabled(cacheable=true) 
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName,String countryName) {		
		return HWS_Utilty.getDependentMap(objDetail, contrfieldApiName,depfieldApiName,countryName);	
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
				if(workingList == null) {
					workingList = new List<untitleSObject>();
				}
				workingList.add(workObj);
			}
		}
		return workingList;
	}
	@AuraEnabled
	public static List<untitleSObject> findContactListFromConsole(String searchKey, String objectName, String returnValue) {
		List<list<SObject>> workingSearchList = new List<List<SObject>>();
		List<untitleSObject> workingList= new List<untitleSObject>();
		
		String searchQuery = 'FIND \'' + String.escapeSingleQuotes(searchKey) + '*\'  IN ALL FIELDS RETURNING '+ objectName+' (Id, '+returnValue+', Email, AccName__c) LIMIT 50';  
		
		workingSearchList = search.query(searchQuery);		
		for(List<SObject> sObj: workingSearchList)  {
			for (SObject so : sObj) {
				untitleSObject workObj = new untitleSObject();
				workObj.currentworkingTitleId = (Id)so.get('Id');
				workObj.currentworkingTitleName = (String)so.get(returnValue) + '   ' + (String)so.get('Email') + '   ' + (String)so.get('AccName__c');
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
	public static List<untitleSObject> searchShiptoParty(String searchKey, String objectName, String returnValue, String parentAccountValue, String addrType, List<Asset> selectedAsset, List<Account> legalAccRec, String triggeredFrom, String lineItemCountry,Boolean isEnglish, String CountryName){
		String erp ;
		//Start - NOKIASC-36274:Ship to party selection for Combined Ordering
		Boolean hWSCombinedOrdering= selectedAsset[0].HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c;
		if(hWSCombinedOrdering){
			erp = 'Both';
		}
		else{
			erp = selectedAsset[0].HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c;		
			if(erp !=null && erp !='' && erp != 'P20'){
				erp = 'eSpares';
			} 
		}
		//End - NOKIASC-36274:Ship to party selection for Combined Ordering
		String legalAccId =legalAccRec[0].Id; 
		
		
		Id logisticEntityExisting = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id wareHouseAccId = ID.valueof(Label.Account_ID_of_Global_Warehouse_Addresses);
		string searchQuery='';
		list<SObject> workingSearchList = new List<SObject>();
		List<untitleSObject> workingList= new List<untitleSObject>();
		// Commented below code for resolving the PMD error
		// string searchQuery = 'SELECT Id,Name from Account where RecordTypeId =: LogisticEntity AND ParentId =\''+parentAccountValue[0].id+'\' AND (BillingCountry like \'%'+searchKey+'%\'  OR BillingCity like \'%'+searchKey+'%\' OR BillingPostalCode like \'%'+searchKey+'%\' OR BillingStreet like \'%'+searchKey+'%\' OR BillingState like \'%'+searchKey+'%\') limit 50';
		//if(addrType == 'shipToParty'){//ADDED FOR 1358 TO DIFFERENTIATE BETWEEN STP AND WAREHOUSE ADDRS
		//searchQuery = 'SELECT Id,Region__c,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,BillingState,BillingCountry,BillingPostalCode from Account where ParentId =: legalAccId AND RecordTypeId =: logisticEntityExisting AND AccountSource =: erp AND (BillingCountry like \'%'+searchKey+'%\'  OR BillingCity like \'%'+searchKey+'%\' OR BillingPostalCode like \'%'+searchKey+'%\' OR BillingStreet like \'%'+searchKey+'%\' OR BillingState like \'%'+searchKey+'%\')';
		//}else if(addrType == 'wareHouseAddress'){
		//searchQuery = 'SELECT Id,Region__c,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,BillingState,BillingCountry,BillingPostalCode from Account where ParentId =: wareHouseAccId AND RecordTypeId =: logisticEntityExisting AND (BillingCountry like \'%'+searchKey+'%\'  OR BillingCity like \'%'+searchKey+'%\' OR BillingPostalCode like \'%'+searchKey+'%\' OR BillingStreet like \'%'+searchKey+'%\' OR BillingState like \'%'+searchKey+'%\')';
		//}//ADDED FOR 1358 TO DIFFERENTIATE BETWEEN STP AND WAREHOUSE ADDRS	
		//Other Lang changes
		//NOKIASC-35960
		
		
		if(addrType == 'shipToParty')
		{//ADDED FOR 1358 TO DIFFERENTIATE BETWEEN STP AND WAREHOUSE ADDRS
			//NOKIASC-35951:Add Local address field
			if(isEnglish) {
				searchQuery = 'SELECT Id,Region__c,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,BillingState,BillingCountry,BillingStreet, BillingPostalCode,HWS_AddressLineLocal1__c,HWS_AddressLineLocal2__c, HWS_AddressLineLocal3__c,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,ShippingStreet,Legal_Name_Ext__c from Account where ParentId =: legalAccId AND RecordTypeId =: logisticEntityExisting AND AccountSource = :erp ';
				searchQuery = searchQuery+'AND (BillingCountry like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR Name like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR BillingCity like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR BillingPostalCode like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR BillingStreet like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR BillingState like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' )';	
			} else {
				searchQuery = 'SELECT Id,Region__c,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,ShippingStreet, HWS_AddressLineLocal1__c,HWS_AddressLineLocal2__c,BillingCity,BillingCountry, BillingPostalCode,BillingState, BillingStreet, HWS_AddressLineLocal3__c,Legal_Name_Ext__c from Account where ParentId =: legalAccId AND RecordTypeId =: logisticEntityExisting AND AccountSource = :erp ';
				searchQuery = searchQuery+'AND (ShippingCountry like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR Name like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR ShippingCity like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR ShippingPostalCode like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR ShippingStreet like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR Legal_Name_Ext__c like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR ShippingState like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' )';   
			}
		}
		else if(addrType == 'wareHouseAddress')
		{
			if (isEnglish) {
		searchQuery = 'SELECT Id,Region__c,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,Hws_Address_Line_3__c,BillingCity,BillingState,BillingCountry,BillingPostalCode,BillingStreet,HWS_AddressLineLocal1__c,HWS_AddressLineLocal2__c, HWS_AddressLineLocal3__c,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,ShippingStreet,Legal_Name_Ext__c from Account where ParentId =: wareHouseAccId AND RecordTypeId =: logisticEntityExisting '; 
				searchQuery = searchQuery+'AND (BillingCountry like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR Name like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR BillingCity like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR BillingPostalCode like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR BillingStreet like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR BillingState like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' )';	
			} else {
	 	searchQuery = 'SELECT Id,Region__c,Name,Hws_Address_Line_1__c,BillingCity,BillingCountry, BillingPostalCode,BillingState, BillingStreet, Hws_Address_Line_2__c,Hws_Address_Line_3__c,HWS_AddressLineLocal1__c,HWS_AddressLineLocal2__c, HWS_AddressLineLocal3__c,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,ShippingStreet,Legal_Name_Ext__c from Account where ParentId =: wareHouseAccId AND RecordTypeId =: logisticEntityExisting '; 
				searchQuery = searchQuery+'AND (ShippingCountry like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR Name like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR ShippingCity like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR ShippingPostalCode like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR ShippingStreet like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' ';
				searchQuery = searchQuery +'OR ShippingState like \'%' + String.escapeSingleQuotes(searchKey.trim()) + '%\' )';	
			}	
		} 
		
		//Adding ContractLineItem's Country condition to get Shiptoparty Address (Logistic Account)--> NOKIASC-25672 nad NOKIASC-27280 (portal)
		if(triggeredFrom == 'console' || triggeredFrom == 'portal'){
			if (String.isNotBlank(CountryName)) {	
			searchQuery = searchQuery + ' AND BillingCountry =:CountryName';	
			}else{
			searchQuery = searchQuery + ' AND BillingCountry =:lineItemCountry';
			}
		}
		searchQuery = searchQuery + ' limit 5000';		
		workingSearchList = database.query(searchQuery);		
		//  for(list<SObject> sObj: workingSearchList)  {
		for (SObject so : workingSearchList) {
			untitleSObject workObj = new untitleSObject();
			workObj.currentworkingTitleId = (Id)so.get('Id');
			workObj.currentworkingTitleName = (String)so.get(returnValue);
			
			// if(isEnglish) {
			/*workObj.addressLine1 = (String)so.get('BillingCity');
system.debug('workObj.addressLine1=='+workObj.addressLine1);
workObj.addressLine2 = (String)so.get('BillingState');
workObj.addressLine3 = (String)so.get('BillingStreet') + ' ' + (String)so.get('BillingPostalCode');
workObj.localShiptoPartyName = (String)so.get('Legal_Name_Ext__c');*/
			// } 
			/*   else {
workObj.addressLine1 = (String)so.get('ShippingCity');
workObj.addressLine2 = (String)so.get('ShippingState');
workObj.addressLine3 = (String)so.get('ShippingStreet') + ' ' + (String)so.get('ShippingPostalCode');  
} 
*/
			workObj.addressLine1 = (String)so.get('Hws_Address_Line_1__c');
			workObj.addressLine2 = (String)so.get('Hws_Address_Line_2__c');
			workObj.addressLine3 = (String)so.get('Hws_Address_Line_3__c');
			workObj.addressLineLocal1 = (String)so.get('HWS_AddressLineLocal1__c');
			workObj.addressLineLocal2 = (String)so.get('HWS_AddressLineLocal2__c');
			workObj.addressLineLocal3 = (String)so.get('HWS_AddressLineLocal3__c');
			workObj.localShiptoPartyName = (String)so.get('Legal_Name_Ext__c');
			
			workObj.cityStateCountry = (String)so.get('BillingCity');
			workObj.shipToPartyAccount = so; 
			if((String)so.get('BillingState')!=null){
				workObj.cityStateCountry =workObj.cityStateCountry +','+(String)so.get('BillingState');
			}
			if((String)so.get('BillingCountry')!=null){
				workObj.cityStateCountry = workObj.cityStateCountry +','+(String)so.get('BillingCountry');
			}
			if((String)so.get('BillingPostalCode')!=null){
				workObj.cityStateCountry = workObj.cityStateCountry +','+(String)so.get('BillingPostalCode');
			}
			workObj.country = (String)so.get('BillingCountry');
			//Shipping Address
			 workObj.shippingcityStateCountry = (String)so.get('ShippingCity');
			if((String)so.get('ShippingState')!=null){
				workObj.shippingcityStateCountry =workObj.shippingcityStateCountry +','+(String)so.get('ShippingState');
			}
			if((String)so.get('ShippingCountry')!=null){
				workObj.shippingcityStateCountry = workObj.shippingcityStateCountry +','+(String)so.get('ShippingCountry');
			}
			if((String)so.get('ShippingPostalCode')!=null){
				workObj.shippingcityStateCountry = workObj.shippingcityStateCountry +','+(String)so.get('ShippingPostalCode');
			}
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
		@AuraEnabled
		public sObject shipToPartyAccount{get; set;}
		
		//NOKIASC-35951:Display ad hoc address and translated address on the case creation screen
		@AuraEnabled
		public String addressLineLocal1{get; set;}
		@AuraEnabled
		public String addressLineLocal2{get; set;}
		@AuraEnabled
		public String addressLineLocal3{get; set;}
		@AuraEnabled
		public String shippingcityStateCountry{get; set;}
		@AuraEnabled
		public String localShiptoPartyName{get; set;}
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
	public static untitleSObject updatetoParentCase(list<Account> selectedAccRec, Account accountRecord,List<Asset> selectedAsset, 
			String translationRequiredTo, String addline1,String addline2, String addline3,String accName) 
	{
		//Start - NOKIASC-36275:New ship to party creation for Combined Ordering
		Boolean hWSCombinedOrdering= selectedAsset[0].HWS_ContractLineItem__r.ServiceContract.HWS_Combined_Ordering__c;
		if(hWSCombinedOrdering){
			accountRecord.AccountSource ='Both';
		}
		else{
			accountRecord.AccountSource = selectedAsset[0].HWS_ContractLineItem__r.ServiceContract.CH_ERPSystem__c;
			if(accountRecord.AccountSource != 'P20'){
				accountRecord.AccountSource = 'eSpares'; 
			}	
		}
		//End - NOKIASC-36275:New ship to party creation for Combined Ordering			   
		ISO_Country_Codes__c codes = getTranslateRequiredValue(accountRecord.BillingCountry);											
		
		if(selectedAccRec != null){
			accountRecord.ParentId = selectedAccRec[0].id;
		}   
		Map<String, String> escapeCharMap = new Map<String, String>{
			' ' => '%20', 
				'#' => '%23', 
				';' => '%3B',
				'&' => '%26',
				',' => '%2C',
				'\'' => '%27',
				'`' => '%60',
				'\\' => '%5C',
				'/' => '%2F'
				};		
		//NOKIASC-37944  Added null value check | Start 
		String sBillingState = accountRecord.BillingState;
		if(String.isNotBlank(sBillingState) && (sBillingState.toLowercase() == '--none--' || sBillingState.contains('---'))) {
			accountRecord.BillingState = null;
		}
		//NOKIASC-37944  Added null value check | End
		if (String.isNotBlank(translationRequiredTo)) {
			String langCodLocal = codes.Language_Code__c != null ?  codes.Language_Code__c : 'en'; 
			//assuming addresss format - LegalName+'='+addline1+'='+addline2+'='+addline3+'='+street+'='+city;
			String addLineConcat = accountRecord.Name+'%3D'+addline1+'%3D'+addline2+'%3D'+addline3+'%3D'+accountRecord.BillingStreet+'%3D'+accountRecord.BillingCity;
			for(String chr : escapeCharMap.keySet()){
				if(addLineConcat.contains(chr)){
					addLineConcat = addLineConcat.replace(chr,escapeCharMap.get(chr));
				}
			}
			//When user input is Latin/English --> translate to local language
			if (translationRequiredTo == 'Local' && codes.Translation_Required__c) { 
				String localTranslation = HWS_GetMapLocation.getTranslatedAddress(new List<String> {addLineConcat},'en', langCodLocal);
				List<String> localTranslationLst = localTranslation.split('=');
				// added if-else for NOKIASC-38962
				if(localTranslationLst.size() == 6){
					accountRecord.HWS_AddressLineLocal1__c = localTranslationLst[1];
					accountRecord.HWS_AddressLineLocal2__c = localTranslationLst[2];
					accountRecord.HWS_AddressLineLocal3__c = localTranslationLst[3];
		accountRecord.Hws_Address_Line_1__c = addline1;
		accountRecord.Hws_Address_Line_2__c = addline2;
		accountRecord.Hws_Address_Line_3__c = addline3;
					accountRecord.ShippingStreet = localTranslationLst[4];
					accountRecord.ShippingCity = localTranslationLst[5];
					accountRecord.Legal_Name_Ext__c = localTranslationLst[0];
		accountRecord.ShippingState = accountRecord.BillingState;
					accountRecord.ShippingCountry = accountRecord.BillingCountry;
					accountRecord.ShippingPostalCode= accountRecord.BillingPostalCode;
				}
				else{
					throw new AuraHandledException(System.Label.HWS_GoogleTranslate_Failure_Msg);
				}
			} else if (translationRequiredTo == 'Latin' && codes.Translation_Required__c )  {
				//When user input is Local language --> translate to english language
				accountRecord.ShippingStreet = accountRecord.BillingStreet;
				accountRecord.ShippingCity = accountRecord.BillingCity;
				String englishTranslation = HWS_GetMapLocation.getTranslatedAddress(new List<String> {addLineConcat}, langCodLocal, 'en');
				List<String> englishTranslationLst = englishTranslation.split('=');	
				// added if-else for NOKIASC-38962
				if(englishTranslationLst.size() == 6){
					accountRecord.Hws_Address_Line_1__c = englishTranslationLst[1];
					accountRecord.Hws_Address_Line_2__c = englishTranslationLst[2];
					accountRecord.Hws_Address_Line_3__c = englishTranslationLst[3];
		accountRecord.HWS_AddressLineLocal1__c = addline1;
		accountRecord.HWS_AddressLineLocal2__c = addline2;
		accountRecord.HWS_AddressLineLocal3__c = addline3;
					accountRecord.BillingStreet = englishTranslationLst[4];
					accountRecord.BillingCity = englishTranslationLst[5];
					accountRecord.Legal_Name_Ext__c = accName; 
					accountRecord.Name = englishTranslationLst[0]; 
		accountRecord.ShippingState = accountRecord.BillingState;
					accountRecord.ShippingCountry = accountRecord.BillingCountry;
					accountRecord.ShippingPostalCode= accountRecord.BillingPostalCode;
				}
				else{
					throw new AuraHandledException(System.Label.HWS_GoogleTranslate_Failure_Msg);
				}
			} 
			else if(!codes.Translation_Required__c){
	//When toggle button is hidden and translation not required
				accountRecord.Hws_Address_Line_1__c = addline1;
				accountRecord.Hws_Address_Line_2__c = addline2;
				accountRecord.Hws_Address_Line_3__c = addline3;
			}
		} else {
			if(accountRecord.BillingCountry == HWS_Constants.None){
				accountRecord.BillingCountry = Null;
			}
			if(accountRecord.BillingState == HWS_Constants.None){
				accountRecord.BillingState = Null;
			}	
		}							
		
		accountRecord.Logistic_Account_Type__c = 'Ship-To';
		accountRecord.HWS_Address_Status__c ='Temporary Address';
		untitleSObject untitleProjec = new untitleSObject();
		Id logisticAccountExisting = HWS_Utilty.getRecordTypeByName('ACCOUNT',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		accountRecord.RecordTypeId = logisticAccountExisting;
		Database.SaveResult[] results1 = Database.insert(new SObject[] {accountRecord});
		Account accRec = [select Id,Region__c,Name,Hws_Address_Line_1__c,Hws_Address_Line_2__c,
						  Hws_Address_Line_3__c,BillingCity,BillingState,BillingCountry,BillingPostalCode,ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,HWS_AddressLineLocal1__c,HWS_AddressLineLocal2__c,HWS_AddressLineLocal3__c,Legal_Name_Ext__c
						  FROM Account where id =: accountRecord.Id];
		untitleProjec.currentworkingTitleId = accountRecord.Id;
		untitleProjec.currentworkingTitleName = accRec.Name; 
		untitleProjec.shipToPartyAccount = accRec;
		return untitleProjec;
	}
	/****************************************
* Name : getTranslateRequiredValue
* Description : return Language translate value 
* Parameters: countryname
* Returns : ISO_Country_Codes__c
* written on 19/05/2021
* By TCS
* NOKIASC-35956:Add Toggle button with a specific name for Ad hoc ship to address creation
*****************************************/
	@AuraEnabled(cacheable=true) 
	public static ISO_Country_Codes__c getTranslateRequiredValue(string countryname){		
		return  [SELECT id,Name,Country_Name__c,Market__c,Language_Code__c, Translation_Required__c
				 FROM ISO_Country_Codes__c WHERE Country_Name__c =:countryname LIMIT 1];		
	}
	/****************************************
* Name : getTranslateRequiredValue
* Description : return whether portal user or console user 
* Parameters: none
* Returns : boolean
* written on 27/05/2021
* By TCS
* NOKIASC-35958:Ad hoc address input in local characters+ toggle for latin characters input
*****************************************/
	@AuraEnabled(cacheable=true)
	public static boolean isPortalUser(){
		boolean isValidPortalUser = HWS_WarrantyQuotation_Controller.isPortalUser();		
		return isValidPortalUser;
	}
	// NOKIASC-35962 | Start
	@AuraEnabled
	public static void updateAccountValues(account obAccount){
		try {
			update obAccount;
		   // return [SELECT id, Hws_Address_Line_1__c, Hws_Address_Line_2__c, Hws_Address_Line_3__c, HWS_AddressLineLocal1__c, HWS_AddressLineLocal2__c, HWS_AddressLineLocal3__c FROM ACCOUNT WHERE ID=:sAccountId LIMIT 1];
		} catch(DMLException ex){
			throw new AuraHandledException(ex.getDmlMessage(0));
		}
		catch(Exception ex){
			throw new AuraHandledException(ex.getMessage());
		} //added for NOKIASC-38962
	}
	// NOKIASC-35962 | End
	@AuraEnabled	
	public static List<String> getCountryList(String retroAccountId) {	
		String shipCountry = [Select HWS_ShipToCountry__c FROM HWS_RetrofitAccount__c WHERE Id =:retroAccountId].HWS_ShipToCountry__c;	
		Set<String> picklistValues = new Set<String>( shipCountry.split(';') );	
		List<String> shipCountries = new List<String>();	
		for (String country : picklistValues) {	
		shipCountries.add(country);	
		}	
		return shipCountries;	
	}	
	@auraEnabled	
	public static list<Account> getAccounts(string accountId) {	
		Set<id> acc = new set<id>();	
		acc.add(accountId);	
		List<Account> lAccounts = HWS_Utilty.getAccounts(acc);	
		return lAccounts;	
	}
}