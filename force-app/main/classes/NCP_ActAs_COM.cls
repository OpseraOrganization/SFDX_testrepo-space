/**
 * Created by bkandov on 05/06/2018.
 * 
 * 
 * Update History   
 * --------------   

Updated date: 08 24 2018 – AHOYBYE, extended for use on user record
Updated date: 09 14 2018 - VTURAN, added emailAddress attribute if rcordId is User. Limit Network.Name to '%Customers%'

 */

public with sharing class NCP_ActAs_COM {

	private final sObject obj;
	public String MyAccountId { get; set; }
	public String CustomerAccountId { get; set; }
	public String setupId { get; set; }
	public String userId { get; set; }

	public String oid { get; set; }
	public String sunetworkid { get; set; }
	public String sunetworkuserid { get; set; }


	public NCP_ActAs_COM(ApexPages.StandardController stdController) {
		obj = (User) stdController.getRecord();
	}

	public PageReference redirectToIAM() {
		if (obj != null) {

			String psStartActAs = NCP_CustomerCommunitySetting__c.getValues('Default').Start_Act_As_Permission_Set__c;
			PermissionSetAssignment psaStartActAs;
			String psaName;
			try {
				System.debug('psStartActAs: ' + psStartActAs);
				System.debug('userInfo.getUserId(): ' + userInfo.getUserId());
				psaStartActAs = [SELECT PermissionSet.Name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :userInfo.getUserId() AND PermissionSet.Name = :psStartActAs];
				System.debug('psaName: ' + psaStartActAs.PermissionSet.Name);
				psaName = psaStartActAs.PermissionSet.Name;
			} catch (Exception e) {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have access rights to perform this action');
				ApexPages.addMessage(myMsg);

				return null;
			}

			//String url = setPortalSSOSessionTemp(obj.Id);
			String url = setPortalSSOSession(obj.Id);
			//String url = 'https://nokia--ccport.cs21.my.salesforce.com/servlet/servlet.su?oid=00Dq00000000wan&retURL=/005q0000004J8oEAAS&sunetworkid=0DB4100000003Dc&sunetworkuserid=005q0000004J8oEAAS';
			//String url = 'https://nokia--ccport.cs21.my.salesforce.com/servlet/servlet.su?oid=00Dq00000000wan&suorgadminid=00541000004oNT0&retURL=/00541000004oNT0?noredirect=1&isUserEntityOverride=1&targetURL=https://nokia--ccport.cs21.my.salesforce.com/servlet/networks/switch?networkId=0DB4100000003Dc';
			System.debug(UserInfo.getOrganizationId());
			//String url = 'https://nokia--ccport.cs21.my.salesforce.com/apex/NCP_Complete_ActAsUser?oid=00Dq0000000D7vjEAC&sunetworkid=0DB4100000003DcGAI&sunetworkuserid=' + obj.Id;
			System.debug('url= ' + url);
			PageReference pageRef = new PageReference(url);
			return pageRef;

		} else {
			return null;
		}
	}

	public PageReference redirectBackToSalesforce() {
		System.debug(' inside Redirect back to SF ');
		MyAccountId = ApexPages.currentPage().getParameters().get('MyAccountId');
		CustomerAccountId = ApexPages.currentPage().getParameters().get('CustomerAccountId');
		setupId = ApexPages.currentPage().getParameters().get('setupId');
		userId = ApexPages.currentPage().getParameters().get('userId');
		oid = ApexPages.currentPage().getParameters().get('oid');
		sunetworkid = ApexPages.currentPage().getParameters().get('sunetworkid');
		sunetworkuserid = ApexPages.currentPage().getParameters().get('sunetworkuserid');
		String sunetworkid_short = String.valueOf(sunetworkid).substring(0, 15);

		String profileCustomerLogin = NCP_CustomerCommunitySetting__c.getValues('Default').NCP_Customer_Login_Profile__c;
		String profileCustomer = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_User_Profile__c;
		String psActAsCustomer = NCP_CustomerCommunitySetting__c.getValues('Default').Act_As_Customer_Permission_Set__c;
		List<String> ACTASProfiles = System.Label.NCP_ACTASProfile.split(';');
		List<String> NCPRelationship = System.Label.NCP_Relationship.split(';');
		ACTASProfiles.add(profileCustomerLogin);
		ACTASProfiles.add(profileCustomer);
		system.debug('**1**'+ACTASProfiles);
		String url;
		Boolean basevalue = false;
		String baseURL = System.URL.getSalesforceBaseURL().toExternalForm();

		try {
			User usr = [SELECT profile.Name, id,NCP_Relationship__c, username FROM User WHERE id = :sunetworkuserid];
			PermissionSet ps = [select id, name from permissionSet where name = :psActAsCustomer];
			system.debug('**2**'+usr.profile.name);
			for(String str : ACTASProfiles){
				if(str == usr.profile.name){
					basevalue = true;
				}
			}
			system.debug('**3**'+basevalue);
			if (basevalue) {//Customer User
				//url = 'https://nokia--ccport.cs21.my.salesforce.com/servlet/servlet.su?oid=00Dq00000000wan&retURL=/005q0000004J8oEAAS&sunetworkid=0DB4100000003Dc&sunetworkuserid=005q0000004J8oEAAS';
				//url = 'https://nokia--ccport.cs21.my.salesforce.com/servlet/servlet.su?oid='+oid+'&retURL=/'+sunetworkuserid+'&sunetworkid='+sunetworkid+'&sunetworkuserid='+sunetworkuserid;
			   System.debug(' inside IF statement ');
			   url = baseURL + '/servlet/servlet.su?oid=' + oid + '&retURL=/' + sunetworkuserid + '&sunetworkid=' + sunetworkid + '&sunetworkuserid=' + sunetworkuserid;
			   system.debug('* Url / '+url);
				List<PermissionSetAssignment> psaList = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :ps.Id AND AssigneeId = :Userinfo.getUserId()];

				if (psaList.isEmpty()) {
				
					//assign permission set to be able to act as
					PermissionSetAssignment psa = new PermissionSetAssignment
							(PermissionSetId = ps.Id, AssigneeId = Userinfo.getUserId());
					insert psa;
				}
				NCP_ActAsHelper.assignLastActAsUser(usr);

			} else {
				
				system.debug('inside else ' );
				//url = 'https://nokia--ccport.cs21.my.salesforce.com/servlet/servlet.su?oid=00Dq00000000wan&suorgadminid=00541000004oNT0&retURL=/00541000004oNT0?noredirect=1&isUserEntityOverride=1&targetURL=https://nokia--ccport.cs21.my.salesforce.com/servlet/networks/switch?networkId=0DB4100000003Dc';
				//url = 'https://nokia--ccport.cs21.my.salesforce.com/servlet/servlet.su?oid='+oid+'&suorgadminid='+sunetworkuserid+'&retURL=/'+sunetworkuserid+'?noredirect=1&isUserEntityOverride=1&targetURL=https://nokia--ccport.cs21.my.salesforce.com/servlet/networks/switch?networkId='+sunetworkid_short;
				url = baseURL + '/servlet/servlet.su?oid=' + oid + '&suorgadminid=' + sunetworkuserid + '&retURL=/' + sunetworkuserid + '?noredirect=1&isUserEntityOverride=1&targetURL=' + baseURL + '/servlet/networks/switch?networkId=' + sunetworkid_short;
			}
			System.debug('url: ' + url);
			try {
				PageReference pageRef = new PageReference(url);
				return pageRef;
			} catch (Exception e) {
				system.debug('inside Catch ' );
				return null;
			} finally {
				System.debug('redirectBackToSalesforce - in finally');
				//removeUserPermission(Userinfo.getUserId(), ps.Id);
			}
		} catch (Exception e) {
			System.debug('!!! redirectBackToSalesforce In error !!!  ' + e.getMessage());
			return null;
		}
	}


	/**
	 * @param recordId
	 * @param NokiaSSOEndPointURL
	 * @param SSOTargetEndPointURL
	 *
	 * @return contactDetails - get contact details that need to send to SSO connection
	 */
	private static String getDetailsUrlParams(String recordId, String NokiaSSOEndPointURL, String SSOTargetEndPointURL) {

		String orgId = UserInfo.getOrganizationId().mid(0, 15);
		String accountId = '', userId = '', groupId = '', federationId = '', networkId = '', emailAddress = '';
		if (recordid.startsWith('003')) {  // initiated from a contact record - fetch associated user via contact record
			List<Contact> contacts = [SELECT AccountId,Email FROM Contact WHERE Id = :recordId LIMIT 1];
			if (contacts.size() > 0) {
				accountId = contacts[0].AccountId;
				emailAddress = contacts[0].Email;
				List<User> users = [
						SELECT Id,FederationIdentifier
						FROM User
						WHERE AccountId = :accountId AND ContactId = :recordId
						LIMIT 1
				];
				if (users.size() > 0) {
					userId = users[0].Id;
					//federationId = users[0].FederationIdentifier;
				}
			}
		} else if (recordid.startsWith('005')) { // initiated from a user record
			userId = recordId;
			emailAddress = [SELECT Email FROM User WHERE Id = :recordId LIMIT 1].email;
		}
		
		List<NetworkMember> networkMembers = [
			SELECT NetworkId
			FROM NetworkMember
			WHERE MemberId = :userId AND Network.Status = 'Live' AND (Network.Name like '%Customers%' OR Network.Name like '%Nokia Partner Portal%')
			LIMIT 1
		];		

		if (networkMembers.size() > 0) {
			networkId = networkMembers[0].NetworkId;
		}

		String contactDetailsParams = '?USER=' + EncodeParam(emailAddress);
		Map<String, String> targetDetails = new Map<String, String>();
		targetDetails.put('MyAccountId', orgId);
		targetDetails.put('CustomerAccountId', recordId);
		targetDetails.put('setupId', networkId);
		targetDetails.put('userId', userId);

		String targetParams = '&target=' + EncodeParam(SSOTargetEndPointURL);
		for (String key : targetDetails.keySet()) {
			targetParams += '?' + key + '=' + EncodeParam(targetDetails.get(key));
		}

		contactDetailsParams += targetParams;
		return contactDetailsParams;
	}

	/**
	 * returns nokia's
	 * @param url
	 *
	 * @return http response
	 */
	@AuraEnabled
	public static String setPortalSSOSession(String recordId) {

		NCP_CustomerCommunitySetting__c actAsUrls = NCP_CustomerCommunitySetting__c.getValues('Default');
		String NokiaSSOEndPointURL = actAsUrls.NokiaSSOEndPointURL__c ;
		String SSOTargetEndPointURL = actAsUrls.SSOTargetEndPointURL__c ;

		String contactDetailsUrlParams = getDetailsUrlParams(recordId, NokiaSSOEndPointURL, SSOTargetEndPointURL);
		String SSOUrl = NokiaSSOEndPointURL + contactDetailsUrlParams;
		system.debug(SSOUrl);
		return SSOUrl;
	}

	private static String EncodeParam(String value) {
		return EncodingUtil.urlEncode(value, 'UTF-8').replace('+', '%20');
	}

	@AuraEnabled
	public static String setPortalSSOSessionTemp(String recordId) {

		//NCP_CustomerCommunitySetting__c  actAsUrls = NCP_CustomerCommunitySetting__c.getValues('Default');
		//String NokiaSSOEndPointURL = actAsUrls.NokiaSSOEndPointURL__c ;
		//String SSOTargetEndPointURL = actAsUrls.SSOTargetEndPointURL__c ;

		//String contactDetailsUrlParams = getDetailsUrlParamsTemp(recordId,NokiaSSOEndPointURL,SSOTargetEndPointURL);
		//String SSOUrl = NokiaSSOEndPointURL + contactDetailsUrlParams;
		String SSOUrl = getDetailsUrlParamsTemp(recordId);
		system.debug(SSOUrl);
		return SSOUrl;
	}

	/**
 * @param recordId
 * @param NokiaSSOEndPointURL
 * @param SSOTargetEndPointURL
 *
 * @return contactDetails - get contact details that need to send to SSO connection
 */
	private static String getDetailsUrlParamsTemp(String recordId) {
		//?oid=1111&sunetworkid=2222&sunetworkuserid='+recordId
		String orgId = UserInfo.getOrganizationId().mid(0, 15);
		String accountId = '', userId = '', groupId = '', federationId = '', networkId = '', emailAddress = '';
		if (recordid.startsWith('003')) {  // initiated from a contact record - fetch associated user via contact record
			List<Contact> contacts = [SELECT AccountId,Email FROM Contact WHERE Id = :recordId LIMIT 1];
			if (contacts.size() > 0) {
				accountId = contacts[0].AccountId;
				emailAddress = contacts[0].Email;
				List<User> users = [
						SELECT Id,FederationIdentifier
						FROM User
						WHERE AccountId = :accountId AND ContactId = :recordId
						LIMIT 1
				];
				if (users.size() > 0) {
					userId = users[0].Id;
					//federationId = users[0].FederationIdentifier;
				}
			}
		} else if (recordid.startsWith('005')) { // initiated from a user record
			userId = recordId;
			emailAddress = [SELECT Email FROM User WHERE Id = :recordId LIMIT 1].email;
		}

		List<NetworkMember> networkMembers = [
			SELECT NetworkId
			FROM NetworkMember
			WHERE MemberId = :userId AND Network.Status = 'Live' AND (Network.Name like '%Customers%' OR Network.Name like '%Nokia Partner Portal%')
			LIMIT 1
		];

		if (networkMembers.size() > 0) {
			networkId = networkMembers[0].NetworkId;
		}
		String targetURL = 'https://nokia--ccport.cs21.my.salesforce.com/apex/NCP_Complete_ActAsUser';
		targetURL = targetURL + '?oid=' + orgId + '&sunetworkid=' + networkId + '&sunetworkuserid=' + userId;
		System.debug('targetURL= ' + targetURL);
		return targetURL;
		//String contactDetailsParams = '?USER=' + EncodeParam(emailAddress);
		//Map<String, String> targetDetails = new Map<String, String>();
		//targetDetails.put('MyAccountId', orgId);
		//targetDetails.put('CustomerAccountId', recordId);
		//targetDetails.put('setupId', networkId);
		//targetDetails.put('userId', userId);

		//String targetParams = '&target=' + EncodeParam(SSOTargetEndPointURL);
		//for (String key : targetDetails.keySet()) {
		//  targetParams += '?' + key + '=' + EncodeParam(targetDetails.get(key));
		//}

		//contactDetailsParams += targetParams;
		//return contactDetailsParams;
	}
	/*
	@future
	private static void removeUserPermission(String userId, String permId) {
		// Perform some operations
		List<PermissionSetAssignment> psaList = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :permId AND AssigneeId = :userId];
		if (!psaList.isEmpty()) {
			for (Integer i = 0; i < 10000; i++) {
			}
			delete psaList[0];
		}
	}

	*/
}