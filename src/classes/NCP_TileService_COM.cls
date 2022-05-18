/**
About
-----
Description: This Class is used to represent Tiles object in community Service Page.

Created for: Nokia Customer Portal
Created date: 12 28 2017

Update History
--------------
Created: 12 18 2017 – aboukrim@salesforce.com
Updated: 02 01 2018 – dominic.butler@salesforce.com, added isAuthenticated method.
Updated: 05 11 2018 – dominic.butler@salesforce.com, refactor and simplify.

--------------
**/

public with sharing class NCP_TileService_COM {
	
	private static final String access_Type_Partner_Portal = NCP_Constants.PARTNER_PORTAL_ACCESS_TYPE;
	private static final String user_NCP_Relation_Partner = NCP_Constants.USER_NCP_RELATIONS_PARTNER;
	private static final String access_Type_Supplier_Portal = NCP_Constants.SUPPLIER_PORTAL_ACCESS_TYPE;
	private static final String user_NCP_Relation_Supplier = NCP_Constants.USER_NCP_RELATIONS_SUPPLIER;
	private static final String NCP_chACCESS_TYPE = NCP_Constants.NCP_chACCESS_TYPE;
	private static final String NCP_chhwsACCESS_TYPE = NCP_Constants.NCP_chhwsACCESS_TYPE;
	public static Final User userRecord =  [Select Id,contactId, NCP_IsHorizontal__c, NCP_Relationship__c, CountryCode from user where id =: UserInfo.getUserId()];
	
	@AuraEnabled
	public static List<NCP_TileService_Wrapper> getTiles() {		
		Set<String> accessList;
		if (NCP_Utils.isInternalUser()) {
			accessList = NCP_InternalEntitlements.searchInternalEntitlements();
		} else {
			accessList = NCP_Entitlements.searchSelectedServices();
			Set<String> OtherServices = NCP_Entitlements.SearchEntitlementsOtherServices(null).get(null);
			if (OtherServices != null) accessList.addAll(OtherServices);
			List<List<EntitlementContact>> entitledCntCHList = new List<List<EntitlementContact>>();
			entitledCntCHList = NCP_CaseCreationOnSP.checkforCHTileDisplay(userRecord);
			if(entitledCntCHList[0].size()>0){
				accessList.add(NCP_chACCESS_TYPE);
			}
			if(entitledCntCHList[1].size()>0){
				accessList.add(NCP_chhwsACCESS_TYPE);
			}
		}
		
		List<NCP_TileService_Wrapper> tiles = new List<NCP_TileService_Wrapper>();
		//User userRecord = [Select NCP_IsHorizontal__c,NCP_Relationship__c from user where id = :UserInfo.getUserId()];
		
		for (NCP_Service_Tile__mdt tile : [
			SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Horizontal_User__c, NCP_Title__c, NCP_Description__c,
				NCP_Entitlement_Access_Type__c, NCP_URL__c, NCP_QA_URL__c, NCP_Image_Name__c, NCP_Image_URL__c, NCP_Priority__c, 
				NCP_Show_for_Embargo_Countries__c
			FROM NCP_Service_Tile__mdt
		]) {
			if (!isAuthenticated()) {
				// Unauthenticated - just return the public ones
				if (tile.NCP_Public_Access__c) {
					tiles.add(getTileInstance(tile));
				}
			}
			// return all the ones the user is entitled to, plus the public ones - For Partner
			// return all the ones the user is entitled to, plus the public ones - For Supplier
			else if (
				!(tile.NCP_Horizontal_User__c && userRecord.NCP_IsHorizontal__c) && 
	(String.isBlank(userRecord.CountryCode) || (String.isNotBlank(Label.NCP_EmbargoCountriesForTiles) && (String.isNotBlank(userRecord.CountryCode)) && (
					((Label.NCP_EmbargoCountriesForTiles.containsIgnoreCase(userRecord.CountryCode)) && tile.NCP_Show_for_Embargo_Countries__c
					) || !(Label.NCP_EmbargoCountriesForTiles.containsIgnoreCase(userRecord.CountryCode))
				))) && 
	(
					tile.NCP_Default_Access__c  ||
					accessList.contains(tile.NCP_Entitlement_Access_Type__c) ||
					(tile.NCP_Entitlement_Access_Type__c == access_Type_Partner_Portal && userRecord.NCP_Relationship__c == user_NCP_Relation_Partner) ||
					(tile.NCP_Entitlement_Access_Type__c == access_Type_Supplier_Portal && userRecord.NCP_Relationship__c == user_NCP_Relation_Supplier) ||
					tile.NCP_Public_Access__c
	)
			) {
				tiles.add(getTileInstance(tile));
			}
		}
		//Logic to show 'Manage support tickets' tile - the tile appears if either Software support or Hardware support tile is visible
		Set<String> entlmntSet = new Set<String>();
		for(NCP_TileService_Wrapper tsw : tiles){
			entlmntSet.add(tsw.entitlementAccessType);
		}
		if(entlmntSet.contains(NCP_chACCESS_TYPE) || entlmntSet.contains(NCP_chhwsACCESS_TYPE)){
			tiles.add(getTileInstance(NCP_Service_Tile__mdt.getInstance('Manage_Support_Tickets')));
		}
		return tiles;
	}
	
	// this is no longer required, just leaving it in for now
	// should use global value provider in the client instead
	@AuraEnabled
	public static Boolean isAuthenticated() {
		return NCP_Utils.isUserAuthenticated();
	}
	
	private static NCP_TileService_Wrapper getTileInstance(NCP_Service_Tile__mdt tile) {
		
		NCP_TileService_Wrapper tileService = new NCP_TileService_Wrapper();
		tileService.title = tile.NCP_Title__c;
		tileService.description = tile.NCP_Description__c;
		tileService.url = NCP_Utils.isSandbox() ? tile.NCP_QA_URL__c : tile.NCP_URL__c;
		tileService.entitlementAccessType = tile.NCP_Entitlement_Access_Type__c;
		tileService.iconName = tile.NCP_Image_Name__c;
		tileService.imageUrl = tile.NCP_Image_URL__c;
		tileService.priority = tile.NCP_Priority__c;
		tileService.isPublic = tile.NCP_Public_Access__c;
		
		return tileService;
	}
	
	@auraEnabled
	public static String getResourceURL(String resourceName)
	{
		system.debug('resource name####'+resourceName);
		//Fetching the resource
		List<StaticResource> resourceList = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :resourceName];
		
		//Checking if the result is returned or not
		if(resourceList.size() == 1)
		{
			//Getting namespace
			String namespace = resourceList[0].NamespacePrefix;
			//Resource URL
			return '/resource/' + resourceList[0].SystemModStamp.getTime() + '/' + (namespace != null && namespace != '' ? namespace + '__' : '') + resourceName; 
		}
		else return '';
	}
}