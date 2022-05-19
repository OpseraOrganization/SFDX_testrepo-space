/**
About
-----
Description: This Class provides the api for the favourites page.

Created for: Nokia Customer Portal
Created date: 21 02 2018

Update History
--------------
Created: 21 02 2018 – dominic.butler@salesforce.com

--------------
**/

public with sharing class NCP_Favourites_COM {
	
	@AuraEnabled
	public static Boolean isAuthenticated() {
		return NCP_Utils.isUserAuthenticated();
	}
	
	/*
	* @description   gets all entitlements to avoid soql queries
	* @return		wrapper list for service contract and it's related products and services
	*/
	@AuraEnabled
	public static List<NCP_MyEntitlements_Wrapper> checkForEntitlements(){
		return NCP_MyEntitlements_COM.getAllMyEntitlements();
	}
	/*
	* @description   checks for en
	* @return		wrapper list for service contract and it's related products and services
	*/
	@AuraEnabled
	public static Boolean checkForEntitledProducts() {
		Decimal pageSize = 6;
		Decimal pageNumber = 1;
		Boolean hasEntitledProducts = false;
		NCP_ListViewPagedResult_Wrapper result =  new NCP_ListViewPagedResult_Wrapper();
		if (NCP_Utils.isInternalUser()) {
			result = NCP_Entitlements.searchAllServiceProducts(pageSize, pageNumber);
		} else {
			result = NCP_Entitlements.searchMyEntitledProducts(pageSize, pageNumber);
		}
		if (!result.products.isEmpty()) {
			hasEntitledProducts = true;
		}
		return hasEntitledProducts;
	}
	/*
	* @description   gets all the support links from custom metadata
	* @return		map providing support links and open tickets list view reference
	*/
	@AuraEnabled
	public static Map<string, object> getLinks() {
		Boolean isCHAuthorised = false;
		String casesViewId;
		Map<string, object> linksObject = new Map<string, object>();
		List<NCP_Support_Link__mdt> supportLinks = new List<NCP_Support_Link__mdt>();
		String userId = System.UserInfo.getUserId();
		User userInfo = [select id, contactId, CountryCode from User where id = :userId];
		
		id userContactId = userInfo.contactId;
		// do the user id test here - check to see if it is in the list of approved users
		EntitlementContact[] entContacts = [select EntitlementId, Id from EntitlementContact where ContactId=:userContactId];
		if (entContacts.size() > 0) {
			isCHAuthorised = true;
			//Changes made on default list view NOKIASC-37030
			ListView[] casesListViews = [select Id from ListView where SobjectType = 'Case' and DeveloperName = 'CH_Portal_My_cases' ];
			// there should only be one of these
			casesViewId = casesListViews[0].Id;
			linksObject.put('viewId', casesViewId);
		}	
		
		if (isCHAuthorised) {
			// get all the active links
			for (NCP_Support_Link__mdt supportLink : [SELECT NCP_Image_Name__c, NCP_Support_type__c, NCP_CH_authorised_contact_only__c, NCP_URL__c, NCP_Title__c, NCP_Tier__c, NCP_Show_for_Embargo_Countries__c
													  FROM NCP_Support_Link__mdt WHERE NCP_Active__c = TRUE]) {
				Boolean addSupportLink = true;
				if((String.isNotBlank(Label.NCP_EmbargoCountriesForSupportLinks) && String.isNotBlank(userInfo.CountryCode) && (Label.NCP_EmbargoCountriesForSupportLinks.containsIgnoreCase(userInfo.CountryCode))) && 
				   !supportLink.NCP_Show_for_Embargo_Countries__c){
					addSupportLink = false;
				}
				if(addSupportLink){
					supportLinks.add(supportLink);
				}	
			}
		} else {
			// get only the links that are active and that are not CHAuthorised only
			for (NCP_Support_Link__mdt supportLink : [Select NCP_Image_Name__c, NCP_Support_type__c, NCP_CH_authorised_contact_only__c, NCP_URL__c, NCP_Title__c, NCP_Tier__c from NCP_Support_Link__mdt WHERE NCP_Active__c = TRUE AND NCP_CH_authorised_contact_only__c = FALSE]) {
	supportLinks.add(supportLink);
			}
		}
		
		linksObject.put('links', supportLinks);
		linksObject.put('categories', getCategories());
		return linksObject;
	}
	
	public static Map<string, object> getCategories() {
		Map<string, object> categoryObject = new Map<string, object>();
		Schema.DescribeFieldResult fieldResult = NCP_Support_Link__mdt.NCP_Support_type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		
		for( Schema.PicklistEntry f : ple) {
			Map<string, object> category = new Map<string, object>();
			category.put('value', f.getValue());
			category.put('label', f.getLabel());
			categoryObject.put(f.getValue(), category);
		}
		return categoryObject;
	}
}