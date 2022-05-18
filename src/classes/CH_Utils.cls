/****************************************
	* Class Name : CH_Utils
	* Created Date: 24 Mar 2020
	* Created By : TCS
	* Description : This class is to have all global queries executed from CH_CaseTriggerHandler class
	* Test Class: CH_UtilsTest
	*****************************************/
public without sharing class CH_Utils {
	public static Set<Id> globalAccountIdSet;	
	public static Set<Id> globalContactIdSet;
	public static Set<Id> globalEntitltmentIdSet;
	public static Set<Id> globalProductIdSet;
	public static Set<Id> globalAssetIdSet;
	public static Set<String> globalUserIdSet;
	public static Boolean doQueryAgain = false;
	public static Map<Id, Account> accountMap {
		get {
			if(accountMap == null || (accountMap != null && doQueryAgain)){
	//This query is useful when where clause is based on AccountIds from Case only
	accountMap = new Map<Id, Account>([SELECT Id, Name, CountryCode__c, AccountNumber, Customer_Compliance__c FROM Account WHERE Id IN :globalAccountIdSet]);	
			}
			doQueryAgain = false;
			return accountMap;
		}set;
	}
	public static Map<Id, Contact> contactMap {
		get {
			if(contactMap == null || (contactMap != null && doQueryAgain)){
	//This query is useful when where clause is based on ContactIds from Case only
	contactMap = new Map<Id, Contact>([SELECT Id, CH_ContactType__c, Email, Email1__c, CH_Email3__c FROM Contact WHERE Id IN :globalContactIdSet]);	
			}
			doQueryAgain = false;
			return contactMap;
		}set;
	}
	public static Map<Id, Entitlement> entitlementMap {
		get {
			if(entitlementMap == null || (entitlementMap != null && doQueryAgain)){
	//This query is useful when where clause is based on Entitlement from Case only
	entitlementMap = new Map<Id, Entitlement>([SELECT Id, AssetId, ContractLineItem.ServiceContractId, ServiceContractId, ContractLineItem.CH_BusinessHour__c FROM Entitlement WHERE Id IN :globalEntitltmentIdSet]);	
			}
			doQueryAgain = false;
			return entitlementMap;
		}set;
	}
	public static Map<Id, Product2> productMap {
		get {
			if(productMap == null|| (productMap != null && doQueryAgain)){
	//This query is useful when where clause is based on ProductIds from Case only
	productMap = new Map<Id, Product2>([SELECT Id, ProductCode, NCP_Nokia_Product_Id__c FROM Product2 WHERE Id IN :globalProductIdSet]);	
			}
			doQueryAgain = false;
			return productMap;
		}set;
	}
	public static Map<Id, Asset> assetMap {
		get {
			if(assetMap == null || (assetMap != null && doQueryAgain)){
	//This query is useful when where clause is based on AssetIds from Case only
	assetMap = new Map<Id, Asset>([SELECT Id, Product2Id , CH_ProductRelease__c, CH_ProductVariant__c, CH_Solution__c, CH_CountryISOName__c FROM Asset WHERE Id IN :globalAssetIdSet]);	
			}
			doQueryAgain = false;
			return assetMap;
		}set;
	}
	public static Map<String, User> userMap {
		get {
			if(userMap == null || (userMap != null && doQueryAgain)){
	//This query is useful when where clause is based on User(Owner) Id from Case only
	userMap = new Map<String, User>([SELECT Id, Name, UserRoleId, UserRole.Name, Nokia_ID__c, CH_LastCaseAssigned__c, CH_LastEngagement__c,User_Cost_Center__c FROM User WHERE Id IN :globalUserIdSet]);	
			}
			doQueryAgain = false;
			return userMap;
		}set;
	}
	/********************
	*Method Name: getAccountMap
	*Parameter: Set of Account Ids 
	*Last updated by: TCS (24th Mar 2020)
	*Description: This is to return Account Map from global query. So that we can use one query.   
	*******************/
	public static Map<Id, Account> getAccountMap(Set<Id> accountIdSet) {
		if(globalAccountIdSet != null){
			for(Id objId: accountIdSet){
	if(!globalAccountIdSet.contains(objId)){
		doQueryAgain = true;
		globalAccountIdSet.add(objId);
	}
			}
		}
		else{
			globalAccountIdSet = accountIdSet;
		}
		return accountMap;
	}
	/********************
	*Method Name: getContactMap
	*Parameter: Set of Contact Ids 
	*Last updated by: TCS (24th Mar 2020)
	*Description: This is to return Contact Map from global query. So that we can use one query.   
	*******************/
	public static Map<Id, Contact> getContactMap(Set<Id> contactIdSet) {
		if(globalContactIdSet != null){
			for(Id objId: contactIdSet){
	if(!globalContactIdSet.contains(objId)){
		doQueryAgain = true;
		globalContactIdSet.add(objId);
	}
			}			
		}
		else{
			globalContactIdSet = contactIdSet;
		}	
		return contactMap;
	}
	/********************
	*Method Name: getEntitlementMap
	*Parameter: Set of Entitlement Ids 
	*Last updated by: TCS (24th Mar 2020)
	*Description: This is to return Entitlement Map from global query. So that we can use one query.   
	*******************/
	public static Map<Id, Entitlement> getEntitlementMap(Set<Id> entitltmentIdSet) {
		if(globalEntitltmentIdSet != null){
			for(Id objId: entitltmentIdSet){
	if(!globalEntitltmentIdSet.contains(objId)){
		doQueryAgain = true;
		globalEntitltmentIdSet.add(objId);
	}
			}			
		}
		else{
			globalEntitltmentIdSet = entitltmentIdSet;
		}	 
		return entitlementMap;
	}
	/********************
	*Method Name: getProductMap
	*Parameter: Set of Product Ids 
	*Last updated by: TCS (24th Mar 2020)
	*Description: This is to return Product Map from global query. So that we can use one query.   
	*******************/
	public static Map<Id, Product2> getProductMap(Set<Id> productIdSet) {
		if(globalProductIdSet != null){
			for(Id objId: productIdSet){
	if(!globalProductIdSet.contains(objId)){
		doQueryAgain = true;
		globalProductIdSet.add(objId);
	}
			}
		}
		else{
			globalProductIdSet = productIdSet;
		}
		return productMap;
	}
	/********************
	*Method Name: getAssetMap
	*Parameter: Set of Asset Ids 
	*Last updated by: TCS (24th Mar 2020)
	*Description: This is to return Asset Map from global query. So that we can use one query.   
	*******************/
	public static Map<Id, Asset> getAssetMap(Set<Id> assetIdSet) {
		if(globalAssetIdSet != null){
			for(Id objId: assetIdSet){
	if(!globalAssetIdSet.contains(objId)){
		doQueryAgain = true;
		globalAssetIdSet.add(objId);
	}
			}
		}
		else{
			globalAssetIdSet = assetIdSet;
		}
		return assetMap;
	}
	/********************
	*Method Name: getUserMap
	*Parameter: Set of User Ids 
	*Last updated by: TCS (24th Mar 2020)
	*Description: This is to return User Map from global query. So that we can use one query.   
	*******************/
	public static Map<String, User> getUserMap(Set<String> userIdSet) {
		if(globalUserIdSet != null){
			for(Id objId: userIdSet){
	if(!globalUserIdSet.contains(objId)){
		doQueryAgain = true;
		globalUserIdSet.add(objId);
	}
			}
		}
		else{
			globalUserIdSet = userIdSet;
		}
		return userMap;
	}
	/********************
	*Method Name: accessCheck
	*Parameter: Set of User Ids 
	*Last updated by: TCS (20th Oct 2020)
	*Description: This is used to check access for logged in User .
	**********************/
	public static boolean accessCheck(Id caseId, Boolean isCreateArticle){
		boolean flag=false;
		boolean createarticleflag =false;
		String caseTeamMemberId;
		Case fetchCase=[SELECT Id, OwnerId, Status
			FROM Case
			WHERE Id=:caseId];
		List<CaseTeamMember> caseTeamMemberList =[SELECT MemberId ,TeamRoleId ,ParentId 
	 FROM CaseTeamMember 
	 WHERE ParentId=:caseId 
	 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
		Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		Integer runTeamCnt = [SELECT count() FROM PermissionSetAssignment Where AssigneeId =:userinfo.getUserId() AND PermissionSet.Name=:SWS_Constants.CHRUNTEAM];
		if(fetchCase!=NULL){
			for(caseTeamMember member : caseTeamMemberList){
				if(member.MemberId == UserInfo.getUserId()){
					flag=true;
				}
			}
			if((fetchCase.Status=='Assigned'|| fetchCase.Status=='Created') &&  isCreateArticle)
			{
	createarticleflag = false;
			}
			if(fetchCase.OwnerId == UserInfo.getUserId()){
	flag=true;
			}
			if(profileName == 'CH_Agent' || profileName == 'System Administrator'){
	flag=true;
			}
			if(runTeamCnt !=0){
				flag=true;
			}
		}
		else{
			flag=false;
		}
		return flag;
	}
	
}