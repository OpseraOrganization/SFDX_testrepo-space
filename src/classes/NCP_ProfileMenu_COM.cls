/**
About
-----
Description: This Class provides the api for the custom profile menu.

Created for: Nokia Customer Portal
Created date: 21 02 2018

Update History
--------------
Created: 21 02 2018 – dominic.butler@salesforce.com
Modified: 22 08 2018 – dominic.butler@salesforce.com - add isInternalUser method
Modified: 23 08 2018 – dominic.butler@salesforce.com - add getOrgUrl method
Modified: 24 08 2018 - Should be deleted (use NCP_CustomProfileMenu_COM instead)

--------------
**/

public with sharing class NCP_ProfileMenu_COM {

	@AuraEnabled
	public static Boolean isInSandbox() {
		return NCP_Utils.isSandbox();
	}

	@AuraEnabled
	public static Boolean isInternalUser() {
		return NCP_Utils.isInternalUser();
	}

	@AuraEnabled
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
}