/**
About
-----
Description: This Class provides the api for the custom profile menu.

Created for: Nokia Customer Portal
Created date: 02 07 2018

Update History
--------------
Created: 02 07 2018 – dominic.butler@salesforce.com
Modified: 24 08 2018 - added in methods from NCP_ProfileMenu_COM to harmonise the two classes
Modified: 05 10 2018 - switched to single XHR request, added test for entitlement relationship, moved functions to NCP_Utils
Modified: 02 01 2019 - added in method to allow dynamic configuration of Manage Subscription URL
Modified: 31 01 2019 - introduced test to ensure that the user is authenticated before showing menu

--------------
**/

public with sharing class NCP_CustomProfileMenu_COM {

	@AuraEnabled
	public static String fetchURL() {
		String ntwrkId = Network.getNetworkId();
		ConnectApi.Community comm = ConnectApi.Communities.getCommunity(ntwrkId);
		String currentUrl = comm.siteUrl;
		return (currentUrl);
	}

	@AuraEnabled
	public static Map<string, object> getAllProfileDetails() {
		Map<string, object> allDetails = new Map<string, object>();

		allDetails.put('isSandbox', NCP_Utils.isSandbox());
		allDetails.put('isInternalUser', NCP_Utils.isInternalUser());
		allDetails.put('isAuthorisedEmployee', isAuthorisedEmployee());
		allDetails.put('isAuth', NCP_Utils.isUserAuthenticated());
		allDetails.put('orgUrl', getOrgUrl());
		allDetails.put('manageSubscriptionURLs', getManageSubscriptionURLs());
		allDetails.put('hasEntitlementRelationship', NCP_Utils.hasEntitlementRelationship());
		return allDetails;
	}

	public static Boolean isAuthorisedEmployee() {
		Profile p = [select Id,name from Profile where Id = :UserInfo.getProfileId() limit 1];

		NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
		List<String> enabledProfiles = setting.NCP_AdminProfiles__c != null ? setting.NCP_AdminProfiles__c.split(',') : new List<String>();

		if (enabledProfiles.contains(p.name)) {
			return true;
		} else {

			List<PermissionSetAssignment> psAssignments = [SELECT Id,PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()];
			List<String> enabledPermissions = setting.NCP_AdminPermissionSets__c != null ? setting.NCP_AdminPermissionSets__c.split(',') : new List<String>();
			for (PermissionSetAssignment ps : psAssignments) {
	if (enabledPermissions.contains(ps.PermissionSet.Name)) {
		return true;
	}
			}
		}

		return false;
	}

	@AuraEnabled
	public static Boolean useTestFunction() {
		return NCP_Utils.hasEntitlementRelationship();
	}

	public static String getOrgUrl() {
		String protocolAndHost = '';
		String uid = UserInfo.getUserId();
		String sid = UserInfo.getSessionId();
		String oid = UserInfo.getOrganizationId();
		String base = Url.getSalesforceBaseUrl().toExternalForm();

		//use getSalesforceBaseUrl within batches and schedules (not Visualforce), and fix inconsistent protocol
		if (sid == null) {
			return base.replaceFirst('http:', 'https:');
		}

		//within test context use url class, else derive from identity response
		PageReference api = new PageReference('/id/' + oid + '/' + uid + '?access_token=' + sid);
		String content = Test.isRunningTest() ? '{"urls":{"profile":"' + base + '"}}' : api.getContent().toString();
		Url profile = new Url(content.substringBetween('"profile":"', '"'));
		protocolAndHost = profile.getProtocol() + '://' + profile.getHost();
		return protocolAndHost;
	}

	public static Map<string, object> getManageSubscriptionURLs() {
		Map<string, object> subscriptionURL = new Map<string, object>();
		List<NCP_Manage_Subscriptions_URL__mdt> candidateURL = new List<NCP_Manage_Subscriptions_URL__mdt>();

		for (NCP_Manage_Subscriptions_URL__mdt targetURL : [Select Active_URL__c, Target_URL__c from NCP_Manage_Subscriptions_URL__mdt where Active_URL__c = true]) {
			// only add one item
			if (candidateURL.size() < 1) {
	candidateURL.add(targetURL);
	subscriptionURL.put('ambiguousURLs', false);
	subscriptionURL.put('errorMsg', '');
			} else {
	subscriptionURL.put('ambiguousURLs', true);
	subscriptionURL.put('errorMsg', 'Only one URL can be active in NCP_Manage_Subscriptions_URL__mdt custom metadata');
			}
		}
		if (candidateURL.size() > 0) {
			subscriptionURL.put('candidateURL', candidateURL.get(0));
		} else {
			String errorMessage = 'No active URL in NCP_Manage_Subscriptions_URL__mdt custom metadata';
			AuraHandledException err = new AuraHandledException(errorMessage);
			throw err;
		}

		return subscriptionURL;
	}

	@AuraEnabled
	public static Boolean isAuthenticated() {
		return NCP_Utils.isUserAuthenticated();
	}

	// Get community url name (Customers/Support or something else
	@AuraEnabled
	public static String getCommunityURL() {
		return NCP_Utils.communitySetting().Community_URL_Name__c;
	}

	// Get community Login url
	@AuraEnabled
	public static String getLoginRedirectURL() {
		return NCP_Utils.communitySetting().Login_Redirect_URL__c;
	}

	// This method is no longer in use
	@AuraEnabled
	public static String getUserDetails() {
		return NCP_Utils.getUserDetails();
	}
	
	//This will return true if the User is a Guest user. Otherwise, it will return false.
	@AuraEnabled
	public static Boolean checkForGuestUser() {
		return System.UserInfo.getUserType() == 'Guest' ? true : false;
	}
	
	//This will return true if the User is a Competitor.
	@AuraEnabled
	public static Boolean checkCompetitorUser() {
		User userRecord = [SELECT NCP_IsHorizontal__c FROM User WHERE Id = :UserInfo.getUserId()];
		return userRecord != NULL ? userRecord.NCP_IsHorizontal__c : false;
	}
}