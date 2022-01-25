/**
About
-----
Description: Controller for the product landing page component

Created for: Nokia Customer Portal
Created date: 12 18 2017

Update History
--------------
Created: 12 18 2017 – AES
Modified: 01 10 2019 – DOM single api introduced

Issues / TODOs
--------------
**/
public with sharing class NCP_ListView_COM {

	public static Map<String,id> mapListView = new Map<String,id>();
	public static ApexPages.StandardSetController AccSetController;
	public static String AccFilterId;

	/*
	* @description	  provide all list information inc current filter if applicable
	* @param			listName: the name of the chosen list view
	*/
	@AuraEnabled
	public static Map<string, object> getListViewInfo(String listName) {
		Map<string, object> listViewInfo = new Map<string, object>();
		listViewInfo.put('activeListView', getListViewFilter(listName));
		listViewInfo.put('allListViews', getListViews());
		return listViewInfo;
	}

	/*
	* @description	  instanciate the list view name
	* @param			listName: the name of the chosen list view
	*/
	@AuraEnabled
	public static String getListViewFilter(String listName){
		if(String.isBlank(listName)){
			if(NCP_Utils.isInternalUser()){
				if(NCP_Entitlements.getFavoriteProducts().size() != 0){
					listName = NCP_Constants.FAVORITE_PRODUCTS_LIST_VIEW;
				}else{
					listName = NCP_Constants.MY_ENTITLED_LIST_VIEW;
				}
			}else{
				if(NCP_Entitlements.getFavoriteProducts().size() != 0){
					listName = NCP_Constants.FAVORITE_PRODUCTS_LIST_VIEW;
				}else if(NCP_Entitlements.searchMyEntitledProduct().size() != 0){
					listName = NCP_Constants.MY_ENTITLED_LIST_VIEW;
				}else{
					listName = NCP_Constants.ALL_SERVICES_LIST_VIEW;
				}
			}
		}
		AccFilterId = listName;
		return AccFilterId;
	}

	/*
	* @description   gets the list views list from the standard controller
	* @return		list of the list view
	*/
	@AuraEnabled
	public static List<String> getListViews(){
		//system.debug('### AES getListViews');
		List<String> lst = new List<String>();
		if(NCP_Utils.isInternalUser()){
			lst.add(NCP_Constants.FAVORITE_PRODUCTS_LIST_VIEW);
			lst.add(NCP_Constants.MY_ENTITLED_LIST_VIEW);
		}else if(NCP_Utils.isUserAuthenticated()){
			lst.add(NCP_Constants.FAVORITE_PRODUCTS_LIST_VIEW);
			lst.add(NCP_Constants.MY_ENTITLED_LIST_VIEW);
			lst.add(NCP_Constants.ALL_SERVICES_LIST_VIEW);
		}else{
			lst = new List<String>();
		}
		return lst;
	}

	@AuraEnabled
	public static NCP_ListViewPagedResult_Wrapper getProductsListView(String listView,Decimal pageSize, Decimal pageNumber){

		NCP_ListViewPagedResult_Wrapper result =  new NCP_ListViewPagedResult_Wrapper();
		if(listView == NCP_Constants.FAVORITE_PRODUCTS_LIST_VIEW){
			result = NCP_Entitlements.getFavoriteProducts(pageSize,pageNumber);
		}else if(listView == NCP_Constants.MY_ENTITLED_LIST_VIEW){
			if(NCP_Utils.isInternalUser()){
				result = NCP_Entitlements.searchAllServiceProducts(pageSize,pageNumber);
			}else{
				result = NCP_Entitlements.searchMyEntitledProducts(pageSize,pageNumber);
			}
		}else{
			result = NCP_Entitlements.searchAllServiceProducts(pageSize,pageNumber);
		}
		return result;
	}
	/*
	* @description   generic method to search for objects
	* @param		 searchKeyWord: the string searched
	* @param		 objectName: the name of the object
	* @return		list of Object
	*/
	@AuraEnabled
	public static List <sObject> fetchLookUpValues(String searchKeyWord, String objectName) {
		return NCP_Utils.searchRecords(searchKeyWord,objectName);
	}

	/*
	* @description	  Add/Delete selected favorite products records
	* @param			Id: Id  of the product,  selected the value of checkbox
	* @author		   aboukrim@salesforce.com
	*/
	@AuraEnabled
	public static void  saveFavoriteProducts(String Id, Boolean selected) {

		//String contactId = [Select ContactId from User WHERE Id=:UserInfo.getUserId()].ContactId;
		List <NCP_Favorite_Product__c> favoriteProduct = [SELECT Id,NCP_Removed_Record__c from NCP_Favorite_Product__c  where NCP_Product_Id__c =: Id and NCP_User__c =: UserInfo.getUserId() limit 1];
		// delete a favorite product
		if (!selected && !favoriteProduct.isEmpty()){
			favoriteProduct[0].NCP_Removed_Record__c = True;
			update favoriteProduct;
		}
		// add a favorite product
		if (selected){
			if(favoriteProduct.isEmpty()){
				NCP_Favorite_Product__c newFavoriteProduct = new NCP_Favorite_Product__c();
				newFavoriteProduct.NCP_Product_Id__c = Id;
				newFavoriteProduct.NCP_Removed_Record__c = False;
				newFavoriteProduct.NCP_User__c = UserInfo.getUserId();
				insert newFavoriteProduct;
			}else{
				favoriteProduct[0].NCP_Removed_Record__c = false;
				update favoriteProduct;
			}
		}
	}

}