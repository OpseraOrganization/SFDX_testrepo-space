/****************************************
* Class Name : CH_CN_SubscriptionsController
* User Story :NOKIASC-28839
* Created Date: 25 June 2020
* Created By : TCS
* Last Modified by: 
* Last Modified Date:
* Description : Controller for Notification Subscription functionality
* Test Class: CH_CN_SubscriptionsController_Test
*****************************************/
public without sharing class CH_CN_SubscriptionsController{
	//This method is used to get recordtype DeveloperName against object and recordtypeId
	//User Story :NOKIASC-28839
	@AuraEnabled
	public static String getRecordTypeName(String recordTypeId, string objectName){
		String recordTypeName = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosById().get(recordTypeId).getDeveloperName();
		return recordTypeName;
	}
	//This method is used to get default recordtype DeveloperName against object
	//User Story :NOKIASC-28839
	@AuraEnabled
	public static String getDefaultRecordTypeName(string objectName){
		String recordTypeName = '';
		Schema.DescribeSObjectResult recordType = CH_NotificationSubscription__c.SObjectType.getDescribe();
		List<Schema.RecordTypeInfo> recordtypeList = recordType.getRecordTypeInfos();
		for (Schema.RecordTypeInfo rtInfo : recordtypeList) {
			if (rtInfo.isDefaultRecordTypeMapping()) {
	recordTypeName = rtInfo.getDeveloperName();
	break;
			}
		}		
		return recordTypeName;
	}
	/****************************************
* Name : getCustomSettingsForNotificationPerUser
* Description : this method is is used to check how many Notification Subscriptions allowed per user
* written on 6th Aug 2020
* By Afif Reja
* NOKIASC-29178
*****************************************/	
	@AuraEnabled
	public static  String getCustomSettingsForNotificationPerUser(){
		String isLimitExceeded =null;
		Id loginUserId =Userinfo.getUserId();		 
		CH_CNNotificationLimits__c notificationPerUser = CH_CNNotificationLimits__c.getValues('Subscription Limit');
		//Check login user's total number of subscriptions
		Integer notificationPerUserCount= [SELECT count()
			 from CH_NotificationSubscription__c 
			 WHERE  OwnerId= : loginUserID];
		if(notificationPerUserCount>=Integer.valueOf(notificationPerUser.CH_NotificationLimitValue__c)) {			
			isLimitExceeded ='You have reached maximum limit of '+ notificationPerUser.CH_NotificationLimitValue__c +' subscriptions, please review and delete existing subscription to create a new one.';			
		}
		return isLimitExceeded;
	}
	
	
	/****************************************
* Name : getCustomSettingsForNotification
* Description : this method is is used to get all the custom setting related to Notification Subscriptions
* written on 6th Aug 2020
* By Afif Reja
* NOKIASC-29178
*****************************************/	
	@AuraEnabled
	public static  Map<String, CH_CNNotificationLimits__c> getCustomSettingsForNotification(){		
		Map<String, CH_CNNotificationLimits__c> listNotificationLimits = CH_CNNotificationLimits__c.getAll();
		return listNotificationLimits;
	}	
	/****************************************
* Name : saveNotificationSubscription
* Description : This method is used to save and update notification subscription data
* By Afif Reja
* User story : NOKIASC-29490,NOKIASC-28994,NOKIASC-29005
*****************************************/ 
	@AuraEnabled	
	public static string saveNotificationSubscription(String strNotificationSubscription,String strNotificationId,String strdeleteNotificationSubscriptionDetails,   String strNotificationSubscriptionDetails,String strNotificationSubscriptionChild){
		String errorMsg='';		
		String selectedWorkgroups='',selectedCountries='',selectedLegalEntities='',selectedProducts='';
		
		Savepoint sp = Database.setSavepoint();
		try{	
			
			//deserialize Notification Subscription json string to object
			CH_NotificationSubscription__c upsertNotificationSubscription = (CH_NotificationSubscription__c)JSON.deserialize(strNotificationSubscription, CH_NotificationSubscription__c.Class);			
			//deserialize Notification Subscription Child json string to object to store in parent object
			List<CH_NotificationSubscriptionDetail__c> notificationSubscriptionChild = (List<CH_NotificationSubscriptionDetail__c>) JSON.deserialize(strNotificationSubscriptionChild, List<CH_NotificationSubscriptionDetail__c>.class);			
			
			//Initialize child data to store in parent			
			for(CH_NotificationSubscriptionDetail__c details : notificationSubscriptionChild){
	switch on details.CH_AttributeType__c {
		when 'Workgroup' {
			selectedWorkgroups += details.CH_AttributeRecordID__c +',';
		}
		when 'Country' {
			selectedCountries += details.CH_AttributeRecordID__c +',';
		}
		when 'Legal Entity Account','Parent Account' {
			selectedLegalEntities += details.CH_AttributeRecordID__c +',';
		}
		when 'Product' {
			SelectedProducts += details.CH_AttributeRecordID__c +',';   
		}
		when else{ //Do Nothing
			}		
	}
			}
			//Insert /Update Notification Subscription Master object
			upsertNotificationSubscription.CH_SelectedWorkgroups__c=selectedWorkgroups.removeEnd(',');
			upsertNotificationSubscription.CH_SelectedCountries__c=selectedCountries.removeEnd(',');
			upsertNotificationSubscription.CH_SelectedLegalEntities__c=selectedLegalEntities.removeEnd(',');
			upsertNotificationSubscription.CH_SelectedProducts__c=SelectedProducts.removeEnd(',');			
			upsert upsertNotificationSubscription;  
			
			if(String.isBlank(strNotificationId)){
	//assign notification subscriprtion id after insert records 
	strNotificationId=upsertNotificationSubscription.Id;
			}
			else{
	//Delete existing records from Notification Subscription details object
	List<CH_NotificationSubscriptionDetail__c> deleteNotificationSubscription = (List<CH_NotificationSubscriptionDetail__c>) JSON.deserialize(strdeleteNotificationSubscriptionDetails, List<CH_NotificationSubscriptionDetail__c>.class);	
	if(deleteNotificationSubscription.size()>0){
		delete deleteNotificationSubscription;  
	}
			}
			
			//deserialize Notification Subscription details json string to object
			List<CH_NotificationSubscriptionDetail__c> notificationSubscriptionDetails = (List<CH_NotificationSubscriptionDetail__c>) JSON.deserialize(strNotificationSubscriptionDetails, List<CH_NotificationSubscriptionDetail__c>.class);
			
			// insert Notification Subscription details object 
			if(notificationSubscriptionDetails.size()>0){
	List<CH_NotificationSubscriptionDetail__c> insertNotificationSubscriptionDetails =new List<CH_NotificationSubscriptionDetail__c>();
	for(CH_NotificationSubscriptionDetail__c details : notificationSubscriptionDetails){
		CH_NotificationSubscriptionDetail__c detail = new CH_NotificationSubscriptionDetail__c();
		detail=details;
		detail.CH_AttributeRecordID__c=details.CH_AttributeType__c=='Default'?strNotificationId:details.CH_AttributeRecordID__c;
		detail.CH_NotificationSubscription__c=strNotificationId;
		insertNotificationSubscriptionDetails.add(detail);	
	}
	insert insertNotificationSubscriptionDetails;
			}
			return strNotificationId;
		}
		catch(DmlException e){ 
			//Rollback to savepoint incase of exception
			Database.rollback(sp);
			for (Integer i = 0; i < e.getNumDml(); i++) {	
	errorMsg =+ e.getDmlMessage(i) +  '\n' ;
			}			
			throw new AuraHandledException(errorMsg);
		}
		catch(Exception e){
			//Rollback to savepoint incase of exception
			Database.rollback(sp);
			throw new AuraHandledException(e.getMessage());
		}
	}
	
	/****************************************
* Name : getNotificationSubscriptionData
* Description : get Notification Subscription Records against Id
* By Afif Reja
* User story : NOKIASC-29490
*****************************************/ 
	//
	@AuraEnabled
	public static List<CH_NotificationSubscription__c> getNotificationSubscriptionData(String notificationSubscriptionId){
		return [ SELECT id,Name , CH_BusinessGroup__c, CH_BusinessUnit__c, CH_Country__c, CH_DomainType__c, 
	CH_EventType__c, CH_NotificationMode__c,CH_Product__c, CH_Region__c, CH_Workgroup__c ,CH_LegalEntityAccount__c,CH_ParentAccount__c 
	from CH_NotificationSubscription__c 
	WHERE Id=:notificationSubscriptionId LIMIT 1 ];
	}
	/****************************************
* Name : getNotificationSubscriptionDetails
* Description : get Notification Subscription Details against Notification Id
* By Afif Reja
* User story : NOKIASC-29490
*****************************************/ 
	@AuraEnabled
	public static List<CH_NotificationSubscriptionDetail__c > getNotificationSubscriptionDetails(String notificationSubscriptionId){
		return [ select Id ,CH_NotificationSubscription__c,CH_AttributeCode__c, CH_AttributeName__c, CH_AttributeType__c,CH_AttributeRecordID__c 
	from CH_NotificationSubscriptionDetail__c 
	WHERE CH_NotificationSubscription__c=:notificationSubscriptionId ];
	}
	/****************************************
* Name : getBusinessGroupsandUnits
* Description : returns Map with Business Group and Business Units from Product2 aggreagate results
* Parameters: 
* Returns : Map of Map
* written on 26th Jun 2020
* By Satya Pagadala
* NOKIASC-28972, 25919
*****************************************/
	@auraEnabled
	public static Map<String, List<String>> getBusinessGroupsandUnits(){
		Map<String, List<String>> bgbuMap = new Map<String, List<String>>();	   
		List<AggregateResult> bgbuAgrLst = [select CH_Business_Group__c,CH_Business_Unit__c from Product2 where CH_Valid__c = true and CH_Business_Group__c !=null and CH_Business_Unit__c !=null group by CH_Business_Group__c, CH_Business_Unit__c];
		if(bgbuAgrLst.size()>0){
			for(AggregateResult prd:bgbuAgrLst){
	String bg = String.valueOf(prd.get('CH_Business_Group__c'));
	String bu = String.valueOf(prd.get('CH_Business_Unit__c'));
	if(bu != null && bu !=''){
		if(bgbuMap.containskey(bg)){
			bgbuMap.get(bg).add(bu);
		}
		else{
			bgbuMap.put(bg, new List<String>{bu});
		}
	}
			}
		}		
		
		return bgbuMap;
	}
	
	/****************************************
* Name : getProducts
* Description : returns Product2 records
* Parameters: List of Business Groups, List of Business Units, all BGs selected or not, all BUs selected or not, search string, all Products selected or not, Product Id List
* Returns : Product Records
* written on 26th Jun 2020
* By Satya Pagadala
* NOKIASC-28972
*****************************************/
	@auraEnabled
	public static List<Product2> getProducts(List<String> selectedBGLst, List<String> selectedBULst, Boolean selectedAllBG, Boolean selectedAllBU, String searchKey, Boolean selectedAllProds, List<Id> prodIdsLst,Integer ProductSearchLimit){
		
		//get 'Sales Product' Recordtype Id
		Id salesPrdRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();		
		//set values for PMD_Portfolio_Classification__c
		Set<String> pmdPortfolioClassificationSet = CH_ProductUtils.PRODUCT_NOT_PORTFOLIO_CLASS;
		//set values for PMD_Additional_Classification__c
		Set<String> pmdAdditionalClassificationSet = CH_ProductUtils.PRODUCT_NOT_ADDITIONAL_CLASS;
		//set values for NokiaCPQ_State__c
		Set<String> nokiaCPQStateSet = CH_ProductUtils.PRODUCT_NOT_NOKIACPQ_STATE; //new Set<String>{'Obsolete','Rejected'};		
		//construct Product Query with default filters
		String prodQuery = 'select Id, Name, ProductCode, CH_Business_Group__c, CH_Business_Unit__c, PMD_Portfolio_Classification__c from Product2 Where  CH_Valid__c = true ';
		//Check size of prodIdsLst --> if true, it means it is for Update mode else create mode
		if(prodIdsLst.size()>0){
			prodQuery = prodQuery +' AND Id IN :prodIdsLst';
		}else{
			//part of soql optimizations
			prodQuery = prodQuery+' AND IsActive = true AND PMD_Portfolio_Classification__c NOT IN :pmdPortfolioClassificationSet AND PMD_Additional_Classification__c NOT IN :pmdAdditionalClassificationSet AND NokiaCPQ_State__c NOT IN :nokiaCPQStateSet ';			
			//if(!selectedAllBG && selectedBGLst.size()>0){
			if(selectedBGLst.size()>0){
	prodQuery = prodQuery+' AND CH_Business_Group__c IN :selectedBGLst';	
			}
			//if(!selectedAllBU && selectedBULst.size()>0){
			if(selectedBULst.size()>0){
	prodQuery = prodQuery+' AND CH_Business_Unit__c IN :selectedBULst';	
			}
			if(!selectedAllProds && searchKey !=null){
	searchKey = '%'+searchKey+'%';
	prodQuery = prodQuery+' AND Name LIKE :searchKey';	
			}
		}
		ProductSearchLimit++;
		prodQuery = prodQuery+'  order by Name asc LIMIT :ProductSearchLimit ';
		List<Product2> prdLst = database.query(prodQuery);
		
		return prdLst;
	}
	
	/****************************************
* Name : getRegions
* Description : Fetch Regions from ISO Country Code custom settings
* Parameters: 
* Returns : List
* written on 26th Jun 2020
* By Gopi Krishna
* NOKIASC-28840
* Modified By Eashwar regions to get from Workgroup Rule object dependant map as part of NOKIASC-37902 on 27th Aug 2021
*****************************************/ 
	@AuraEnabled
	public static List<String> getRegion(){
		Map<String, List<String>> regionCountryMap  = CH_CA_TestWorkgroupRules_Controller.getDependentMap(new CH_Workgroup_Rule__c(), 'CH_Region1__c', 'CH_Country1__c');
		List<String> regionsList = new List<String>(regionCountryMap.keySet());
		return regionsList;
	}
	
	/****************************************
* Name : getCountries
* Description : return Country records based on Region
* Parameters: 
* Returns : Map of Map
* written on 26th Jun 2020
* By Gopi Krishna
* NOKIASC-28840
*Modified NOKIASC-37902 updated ISO Countrycodes with Workgroup rule picklist values
*****************************************/
	@AuraEnabled
	public static List<regionCountryWrapper> getcountries(list<string> regions,string searchCountry){

				List<regionCountryWrapper> rcm=new List<regionCountryWrapper>();
		Map<String, List<String>> regionCountryMap  = CH_CA_TestWorkgroupRules_Controller.getDependentMap(new CH_Workgroup_Rule__c(), 'CH_Region1__c', 'CH_Country1__c');
		List<String> regionsList = new List<String>(regionCountryMap.keySet());
	  	List<String> countryList=new List<String>();
		Map<String,String> lsMap=new Map<String,String>();
		if(regions[0]=='All')
		{
			regions=regionsList;
		}
		for(ISO_Country_Codes__c cc:[select id,Name,Country_Name__c,Market__c from ISO_Country_Codes__c])
		{
			lsMap.put(cc.Country_Name__c,cc.Name);
		}
		String countryCode;
		 if(searchCountry!=null)
	   {
		 for(String mk:regions)   
		//for(String mk:regionsList)
		{
		   for(String ct: regionCountryMap.get(mk))
		   {
			   if(ct.containsIgnoreCase(searchCountry))
			   {
				   countryCode=lsMap.get(ct);
				   regionCountryWrapper rc=new regionCountryWrapper(ct,countryCode,mk);
				   rcm.add(rc);
			   }
		   }
		}
	   }
		else if(searchCountry==null)
		{
			for(String mk:regions)
			//for(String mk:regionsList)
			{
				for(String ct: regionCountryMap.get(mk))
				{
					 countryCode=lsMap.get(ct);
				   regionCountryWrapper rc=new regionCountryWrapper(ct,countryCode,mk);
				   rcm.add(rc);
				}
			}   
		}
		return rcm;
	}
	
	   @AuraEnabled
	public static List<String> getRegionFromWKRule(){
		
		Map<String, List<String>> regionCountryMap  = CH_CA_TestWorkgroupRules_Controller.getDependentMap(new CH_Workgroup_Rule__c(), 'CH_Region1__c', 'CH_Country1__c');
		List<String> regionsList = new List<String>(regionCountryMap.keySet());
		Integer rc=regionsList.indexOf('NNO Others');// Removing as this is extra value
		regionsList.remove(rc);
		return regionsList;
	  
	}
	
	   @AuraEnabled
	public static Map<String,regionCountryWrapper> getcountriesFromWGRule(){
		List<regionCountryWrapper> rcm=new List<regionCountryWrapper>();
		Map<String, List<String>> regionCountryMap  = CH_CA_TestWorkgroupRules_Controller.getDependentMap(new CH_Workgroup_Rule__c(), 'CH_Region1__c', 'CH_Country1__c');
		List<String> regionsList = new List<String>(regionCountryMap.keySet());
		Integer rct=regionsList.indexOf('NNO Others');// Removing as this is extra value
		regionsList.remove(rct);
	  	List<String> countryList=new List<String>();
		Map<String,String> lsMap=new Map<String,String>();
		Map<String,regionCountryWrapper> lsMap2=new Map<String,regionCountryWrapper>();
		for(ISO_Country_Codes__c cc:[select id,Name,Country_Name__c,Market__c from ISO_Country_Codes__c])
		{
			lsMap.put(cc.Country_Name__c,cc.Name);
		}
		String countryCode;
	  
	 
		   // for(String mk:regions)
			for(String mk:regionsList)
			{
				for(String ct: regionCountryMap.get(mk))
				{
					 countryCode=lsMap.get(ct);
				   regionCountryWrapper rc=new regionCountryWrapper(ct,countryCode,mk);
				   lsMap2.put(ct,rc);
				}
			}   
		
		return lsMap2;
	   
	}
	
  
	/****************************************
* Name : getAccounts
* Description : return All Account records
* Parameters: 
* Returns : List
* written on 17th July 2020
* By Afif Reja
* NOKIASC-28841,NOKIASC-28994
*****************************************/
	@AuraEnabled
	public static List<Account> getAccounts(String searchString,String accountTypeValue,Integer legalEntitySearchLimit){
		string searchStringValue = '%'+searchString+'%';
		List<Account> accountList= [SELECT id,AccountNumber,RecordType.name,Name,Active__c FROM Account WHERE RecordType.name = :accountTypeValue AND Active__c = true AND 
			(name LIKE: searchStringValue OR AccountNumber LIKE :searchStringValue)  ORDER BY Name LIMIT :legalEntitySearchLimit+1 ]; 

		return accountList;	
	}
	
	/****************************************
* Name : getWorkgroups
* Description : return workgroups
* Parameters: 
* Returns : List
* written on 26th Jun 2020
* By Debanjan Ray
* NOKIASC-28983
*****************************************/
	@AuraEnabled
	public static List<CH_Workgroup__c> getWorkgroups(string searchWorkgroup){
		string wgNameSearch = '%'+searchWorkgroup+'%';
		List<CH_Workgroup__c> wgList= [select Name,CH_Type__c,CH_Level_Of_Support__c from CH_Workgroup__c where RecordType.DeveloperName = 'CH_CA_Workgroup' and (Name like: wgNameSearch) ORDER BY Name]; 
		return wgList;	
	} 
	/****************************************
* Name : setCountries
* Description : return Subscription Detail List
* Parameters: Notification Id
* Returns : List
* written on 14th July 2020
* By Gopi Krishna
* NOKIASC-28995
*****************************************/
	@AuraEnabled
	public static List<regionCountryWrapper> setCountriesList(list<String> countriesID){
		
		List<regionCountryWrapper> rcm=new List<regionCountryWrapper>();
		Map<String, List<String>> regionCountryMap  = CH_CA_TestWorkgroupRules_Controller.getDependentMap(new CH_Workgroup_Rule__c(), 'CH_Region1__c', 'CH_Country1__c');
		List<String> regionsList = new List<String>(regionCountryMap.keySet());
	  	List<String> countryList=new List<String>();
		Map<String,String> lsMap=new Map<String,String>();
		for(ISO_Country_Codes__c cc:[select id,Name,Country_Name__c,Market__c from ISO_Country_Codes__c])
		{
			lsMap.put(cc.Country_Name__c,cc.Name);
		}
		String countryCode;
		String searchCountry;
		for(String mk:regionsList)
		{
		   for(String ct: regionCountryMap.get(mk))
		   {
			   if(countriesID.contains(lsMap.get(ct)))
			   {
				   countryCode=lsMap.get(ct);
				   regionCountryWrapper rc=new regionCountryWrapper(ct,countryCode,mk);
				   rcm.add(rc);
			   }
		   }
		}
		return rcm;
	}
	
	/****************************************
*  Name : setWorkgroupList
* Description : return workgroups
* Parameters: 
* Returns : List
* written on 26th Jun 2020
* By Debanjan Ray
* NOKIASC-28983
*****************************************/
	@AuraEnabled
	public static list<CH_Workgroup__c> setWorkgroupList(list<Id> workgroupID){
		
		list<CH_Workgroup__c> workgroupList = new list<CH_Workgroup__c>();
		
		string wgQuery = 'select Name,CH_Type__c,CH_Level_Of_Support__c from CH_Workgroup__c where Id IN :workgroupID';
		
		workgroupList = database.query(wgQuery);
		
		
		return workgroupList;	
	}
	
		/****************************************
*  Name : regionCountryWrapper
* Description : return Country,Market,ISOCode 
* Parameters: 
* Returns : List
* written on 27th Aug 2021
* By Eashwar Alluri
* NOKIASC-37902
*****************************************/
	public class regionCountryWrapper{
	   @AuraEnabled public String Country_Name_c;
	   @AuraEnabled public String Id;
	   @AuraEnabled public String Name; 
	   @AuraEnabled public String Market_c;
		regionCountryWrapper(String country,String isoCode,String region)
		{
			this.Country_Name_c=country;
			this.Id=isoCode;
			this.Name=isoCode;
			this.Market_c= region;
		}
		
	}
}