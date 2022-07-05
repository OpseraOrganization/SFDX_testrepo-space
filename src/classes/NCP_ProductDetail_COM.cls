/**
About
-----
Description: Controller for the product detail component

Created for: Nokia Customer Portal
Created date: 12 18 2017

Details / Methods
-----------------
getRecord - Used to get the product details
getProductAccess - Used to get product access for the connected user

Update History
--------------
Created: 12 18 2017 – AES

Issues / TODOs
--------------
**/
public without sharing class NCP_ProductDetail_COM {
	
	private static final String NCP_chACCESS_TYPE = NCP_Constants.NCP_chACCESS_TYPE;
	private static final String NCP_chhwsACCESS_TYPE = NCP_Constants.NCP_chhwsACCESS_TYPE;
	public static final User connectedUser =  [Select Id,contactId from user where id =: UserInfo.getUserId()];
	
	@AuraEnabled
	public static Object getRecord(Id prId) {
		List<Object> productList = [Select Name,Apttus_Config2__IconId__c,NokiaCPQ_Category__c,NCP_Marketing_Text__c,NCP_Nokia_Product_Id__c,NCP_ALTERNATE_CODE2__c,NCP_NOKIA_EXT_PRODUCT_CODE__c,NCP_Origin__c from Product2 where id = :prId];
		return productList[0];
	}
	
	@AuraEnabled
	public static List<Object> getRecordandCommunityURL(Id prId) { 
		List<Object> productList = [Select Name,Apttus_Config2__IconId__c,NokiaCPQ_Category__c,NCP_Marketing_Text__c,NCP_Nokia_Product_Id__c,NCP_ALTERNATE_CODE2__c,NCP_NOKIA_EXT_PRODUCT_CODE__c,NCP_Origin__c from Product2 where id = :prId];
		return new List<Object> {productList[0],NCP_Utils.communitySetting().Community_URL_Name__c};
			}
	
	/*
* @description   Entitlement V2 : get List of Entitlement product for the connected user
* @param		 userId: the connected user
* @param		 objectId: the object that needs access, it can be product or service
* @return	list of access type
*/
	@AuraEnabled
	public static List<NCP_ProductAccess_Wrapper> getProductAccess2(Id prId) {
		
		Set<String> accessList = new Set<String>();
		Set<Id> prIdSet = new Set<Id>();
		prIdSet.add(prId);
		if (NCP_Utils.isInternalUser()) {
			accessList = NCP_InternalEntitlements.searchInternalEntitlements();
		} else {
			Set<String> CDBaccess = NCP_Entitlements.SearchEntitlementsCDB(prIdSet, null).get(prId);
			Set<String> CARESaccess = NCP_Entitlements.SearchEntitlementsCares(prIdSet, null).get(prId);
			
			if (CDBaccess != null) accessList = CDBaccess;
			if (CARESaccess != null) accessList.addAll(CARESaccess);
			List<List<EntitlementContact>> entitledCntCHList = new List<List<EntitlementContact>>();
			Boolean isSWSCaseLinkEnabled = NCP_CaseCreationOnSP.isSWSEntitledOnProduct(prId);
			entitledCntCHList = NCP_CaseCreationOnSP.checkforCHTileDisplay(connectedUser);
			if(isSWSCaseLinkEnabled){
	accessList.add(NCP_chACCESS_TYPE);
			} 
			
			if(entitledCntCHList[1].size()>0){
	accessList.add(NCP_chhwsACCESS_TYPE);
			}
			
			
			System.debug('### AES getProductAccess2 cdb  ' + CDBaccess);
			System.debug('### AES getProductAccess2 cares  ' + CARESaccess);
			
		}
		
		Set<String> productAccess = new Set<String>();
		for (NCP_Product_Content__c prSr : [Select Id,NCP_Service__c from NCP_Product_Content__c where NCP_Product__c = :prId]) {
			//Marks 'NCT' Service type as 'Help Desk' - Shrish
			//Start
			if(prSr.NCP_Service__c == NCP_Constants.PRODUCT_CONTENT_NCT) {
	productAccess.add(NCP_Constants.PRODUCT_ACCESS_MDT_HELP_DESK);
			}
			else if(prSr.NCP_Service__c == 'Discovery Center (Skylab)') {
	productAccess.add('Discovery Center');
			}
			else {
	productAccess.add(prSr.NCP_Service__c);
			}
			//End
		}
		Set<String> caseHandlingLst = new Set<String>{NCP_chACCESS_TYPE,NCP_chhwsACCESS_TYPE,NCP_Constants.MANAGE_SUPPORT};
			productAccess.addAll(caseHandlingLst);
		System.debug('### AES productAccess ' + productAccess);
		System.debug('### AES accessList ' + accessList);
		
		List<NCP_Product_Access_Type__mdt> productAccessList = [
			SELECT Id,DeveloperName,MasterLabel,NCP_Link__c,NCP_QA_Link__c,NCP_Order__c,NCP_Standard_Service_URL__c,NCP_Origin__c,NCP_Type__c,NCP_docType__c,NCP_Always_Unlocked__c,NCP_Title__c
			FROM NCP_Product_Access_Type__mdt
			WHERE NCP_Type__c IN:productAccess
			ORDER BY NCP_Order__c ASC
		];
		
		if (NCP_Utils.isSandbox()) {
			for (NCP_Product_Access_Type__mdt pa : productAccessList) {
	pa.NCP_Link__c = pa.NCP_QA_Link__c;
			}
		}
		List<String> horizontalUserServices = new List<String>();
		for(NCP_Service_Tile__mdt serviceTile : [SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Horizontal_User__c, NCP_Title__c, NCP_Description__c,
		NCP_Entitlement_Access_Type__c, NCP_URL__c, NCP_QA_URL__c, NCP_Image_Name__c, NCP_Image_URL__c, NCP_Priority__c
	 FROM NCP_Service_Tile__mdt
	 WHERE NCP_Horizontal_User__c = TRUE]){
			horizontalUserServices.add(serviceTile.NCP_Entitlement_Access_Type__c);
		}
		Boolean horizontalUserFlag = [SELECT NCP_IsHorizontal__c FROM User WHERE Id = :UserInfo.getUserId()].NCP_IsHorizontal__c;
		System.debug('### AES productAccessList ' + productAccessList);
		Map<String, List<NCP_AccessType_Wrapper>> mapProductAccess = new Map<String, List<NCP_AccessType_Wrapper>>();
		System.debug('### AES accessList final is' +accessList);
		for (NCP_Product_Access_Type__mdt ar : productAccessList) {
			if (String.isNotBlank(ar.NCP_Title__c)) {
	Boolean hasAccess = false;
	if(!(horizontalUserFlag && horizontalUserServices.contains(ar.NCP_Type__c))){
		if ((accessList != null && accessList.contains(ar.NCP_Type__c))
			|| ar.NCP_Always_Unlocked__c == true) {
	hasAccess = true;
			}
		else if (accessList != null && (accessList.contains(NCP_chACCESS_TYPE) || accessList.contains(NCP_chhwsACCESS_TYPE)) && ar.DeveloperName == NCP_Constants.MANAGESUPPORTTICKETS_LINK_QUALIFIEDAPINAME){
			hasAccess = true;
		}
	}
	NCP_AccessType_Wrapper accessType = new NCP_AccessType_Wrapper(hasAccess, ar);
	
	if (!mapProductAccess.containsKey(ar.MasterLabel)) {
		mapProductAccess.put(ar.MasterLabel, new List<NCP_AccessType_Wrapper>());
	}
	mapProductAccess.get(ar.MasterLabel).add(accessType);
			}
		}
		
		List<NCP_ProductAccess_Wrapper> prAccessWrappList = new List<NCP_ProductAccess_Wrapper>();
		for (String label : mapProductAccess.keySet()) {
			NCP_ProductAccess_Wrapper wrapp = new NCP_ProductAccess_Wrapper(label, mapProductAccess.get(label));
			prAccessWrappList.add(wrapp);
		}
		
		System.debug('### AES accessList ' + accessList);
		System.debug('### AES prAccessWrappList ' + prAccessWrappList);
		return prAccessWrappList;
	}
	
	/*
* @description   Check the product status to enable add/remove favourite functionality
* @param		 Id: the product id
* @return	Map detailing entitled product and favourite status
*/
	@AuraEnabled
	public static Map<String, Boolean> checkProductStatus(Id prId) {
		Map<String, Boolean> productStatus = new Map<String, Boolean>();
		// Test first to see if it is an entitled product
		Boolean isEntitledProduct = false;
		// If the user is internal then all products are entitled
		NCP_ListViewPagedResult_Wrapper entitledProducts = new NCP_ListViewPagedResult_Wrapper();
		if (NCP_Utils.isInternalUser()) {
			isEntitledProduct = true;
		} else {
			entitledProducts = NCP_Entitlements.searchMyEntitledProducts(1000, 1);
			for (Integer i = 0; i < entitledProducts.products.size(); i++) {
	NCP_MyEntitledProducts_Wrapper aProduct = entitledProducts.products[i];
	if (aProduct.product.Id == prId) {
		isEntitledProduct = true;
		break;
	}
			}
		}
		// need to test entitledProducts.products (List) for the presence of the product in question
		// If it is then test to see if it is on the users favourite list
		Boolean isFavourite = true;
		List<NCP_Favorite_Product__c> favourites = [SELECT NCP_Product_Id__r.Name from NCP_Favorite_Product__c WHERE NCP_User__c = :UserInfo.getUserId() AND NCP_Product_Id__c = :prId and NCP_Removed_Record__c != True];
		if (favourites.isEmpty()) {
			isFavourite = false;
		}
		productStatus.put('entitledProduct', isEntitledProduct);
		productStatus.put('favourite', isFavourite);
		return productStatus;
	}
	
	@AuraEnabled
	public static void changeProductStatus(String Id, Boolean isFavourite) {
		// piggy-backing on the NCP_ListView_COM method
		// should probably be moved to utils
		NCP_ListView_COM.saveFavoriteProducts(Id, isFavourite);
	}
}