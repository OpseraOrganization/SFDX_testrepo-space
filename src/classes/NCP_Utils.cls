/**
About
-----
Description: Class for reused methods

Created for: Nokia Customer Portal
Created date: 02 01 2017

Details / Methods
-----------------


Update History
--------------
Updated: 02 01 2018 – dominic.butler@salesforce.com, added isUserAuthenticated method.
Updated: 02 08 2018 – dominic.butler@salesforce.com, added getUserDetails method.
Updated: 04 09 2018 - AES added searchRecords function

Issues / TODOs
--------------
**/

public without sharing class NCP_Utils {

  public static NCP_CustomerCommunitySetting__c communitySetting(){
	return  NCP_CustomerCommunitySetting__c.getValues('Default');
  }
  
  public static Boolean isUserAuthenticated() {
	String sessionId = System.UserInfo.getSessionId();
	Boolean isAuth = false;
	if (String.isBlank(sessionId)) {
	  isAuth = false;
	} else {
	  isAuth = true;
	}
	return isAuth;
  }

  public static String getUserDetails() {
	Map<String, String> userDetails = new Map<String, String>();
	String userId = System.UserInfo.getUserId();
	String firstName = System.UserInfo.getFirstName();
	String lastName = System.UserInfo.getLastName();
	User u = [Select u.SmallPhotoUrl, u.FullPhotoUrl From User u where u.id = :userId];
	userDetails.put('id', userId);
	userDetails.put('firstName', firstName);
	userDetails.put('lastName', lastName);
	userDetails.put('smallPhotoUrl', u.SmallPhotoUrl);
	userDetails.put('fullPhotoUrl', u.FullPhotoUrl);
	String response = JSON.serialize(userDetails);
	return response;
  }

  /*
  * @description   generic method to search for objects
  * @param	 searchKeyWord: the string searched
  * @param	 objectName: the name of the object
  * @return	list of sobject
  */
  public static List <sObject> searchRecords(String searchKeyWord, String objectName) {
	String searchKey = '%' + searchKeyWord + '%';
	List <sObject> returnList = new List <sObject>();
	// Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5
	String sQuery = 'select Id, Name from ' + ObjectName + ' where Name LIKE: searchKey AND NCP_CAREACTIVATE__c != null AND (NokiaCPQ_State__c != \'Obsolete\' AND NokiaCPQ_State__c !=\'Rejected\') AND (PMD_Product_Item_Type__c = \'Design item\' OR PMD_Product_Item_Type__c = \'Service Design Item\' OR PMD_Product_Item_Type__c = \'Complementary Item\' OR PMD_Product_Item_Type__c = \'Solution\' OR PMD_Product_Item_Type__c = \'NSN Solution\' OR PMD_Product_Item_Type__c = \'NSN Service Design Item\') ORDER BY NAME ASC limit 50';
	List <sObject> lstOfRecords = Database.query(sQuery);
	for (sObject obj : lstOfRecords) {
	  returnList.add(obj);
	}
	return returnList;
  }
  /*
  * @description   generic method to select pall service products
  * @return	list of sobject
  */
  public static List<sObject> selectProducts() {
	String baseQuery = 'Select Id,Name FROM Product2 where NCP_CAREACTIVATE__c != null AND (PMD_Product_Item_Type__c = \'Design item\' OR PMD_Product_Item_Type__c = \'Service Design Item\' OR PMD_Product_Item_Type__c = \'Complementary Item\' OR PMD_Product_Item_Type__c = \'Solution\' OR PMD_Product_Item_Type__c = \'NSN Solution\' OR PMD_Product_Item_Type__c = \'NSN Service Design Item\') AND (NokiaCPQ_State__c != \'Obsolete\' AND NokiaCPQ_State__c !=\'Rejected\') ORDER BY NAME ASC limit 10000';
	List<sObject> productList = Database.query(baseQuery);
	return productList;
  }

  /**
   *
   *
   * @param sobjectType
   * @param developerName
   *
   * @return get record type Id by sObjectType and record type Developer name
   */
  public static ID retRecordTypeID(String sobjectType, String developerName) {

	return
	[
		SELECT Id
		FROM RecordType
		WHERE DeveloperName = :developerName
		AND SobjectType = :sobjectType
	].Id;
  }

  /*x3
  * @description   check if the org isSandbox
  * @return	boolean
  */
  public Static Boolean isSandbox() {

	Organization org = [select Id, isSandbox from Organization limit 1][0];

	// Check to make sure we have a result
	if (org != null) {
	  return org.isSandbox;
	} else {
	  return true;
	}
  }

  public static User getConnectedUser() {
	return [
		SELECT Id, AccountId, ContactId
		FROM User
		WHERE Id = :UserInfo.getUserId()
		LIMIT 1
	];
  }

  /*
  * @description   email validation
  * @return	boolean
  */
  public static Boolean checkEmail(String semail) {
	String InputString = semail;
	String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
	Pattern MyPattern = Pattern.compile(emailRegex);

	// Then instantiate a new Matcher object "MyMatcher"
	Matcher MyMatcher = MyPattern.matcher(InputString);

	if (!MyMatcher.matches()) {
	  return FALSE;
	} else {
	  return TRUE;
	}
  } //end email check

  /*
  * @description   check if the connected user is internal employee
  * @return	boolean
  */
  public static Boolean isInternalUser() {
	User connectedUser = [Select contact.AccountId,NCP_Is_Internal__c,contact.Id from user where id = :UserInfo.getUserId()];
	if (connectedUser.NCP_Is_Internal__c == true) {
	  return true;
	} else {
	  return false;
	}
  }

  public static void sendEmail(Map<Id, List<String>> emails, String templateName) {
	EmailTemplate et = [Select id from EmailTemplate where DeveloperName = :templateName limit 1];
	List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>() ;
	Id contactId = [Select contact.AccountId,Name from user where id = :UserInfo.getUserId()].contactId;
	System.debug('### AES contactId ' + contactId);
	if (String.isNotBlank(contactId)) {
	  for (Id cId : emails.keyset()) {
		List<String> addresses = new List<String>();
		for (string e : emails.get(cId)) {
		  System.debug('### AES check email ' + NCP_Utils.checkEmail(e));
		  if (NCP_Utils.checkEmail(e)) {
			addresses.add(e);
		  }
		}
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(addresses);
		mail.setWhatId(cId);
		mail.setTargetObjectId(contactId);
		mail.setSenderDisplayName('System Admin');
		mail.setTreatTargetObjectAsRecipient(false);
		mail.setTemplateId(et.id);
		messages.add(mail);
	  }
	  Messaging.SendEmail(messages);
	  System.debug('### AES send email');
	} else {
	  // for internal users if you specify a TargetObjectId, Apex’s Messaging classes require you to specify a WhatID that refers to a Contact, not a User.
	  // Pick a dummy Contact
	 // Contact c = [select id, Email from Contact where email <> null limit 1];
	  String contactEmail = System.Label.NCP_Contact_mail ;
	  System.debug('contactEmail:'+ contactEmail);
	  Contact c = [select id, Email from Contact where email =: contactEmail limit 1];
	  System.debug('contact Record:'+ c);
	  List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
	  System.debug('### AES emails ' + emails);
	  for (Id cId : emails.keyset()) {
		List<String> addresses = new List<String>();
		for (string e : emails.get(cId)) {
		  System.debug('### AES check email ' + NCP_Utils.checkEmail(e));
		  if (NCP_Utils.checkEmail(e)) {
			addresses.add(e);
		  }
		}
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setTemplateId(et.id);
		mail.setToAddresses(addresses);
		mail.setTargetObjectId(c.id);
		mail.setSenderDisplayName('System Admin');
		mail.setTreatTargetObjectAsRecipient(false);
		mail.setWhatId(cId);
		messages.add(mail);
	  }
	  // Send the emails in a transaction, then roll it back
	  Savepoint sp = Database.setSavepoint();
	  Messaging.sendEmail(messages);
	  Database.rollback(sp);
	  // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
	  // contents to a new SingleEmailMessage. Then send those new messages.
	  for (Messaging.SingleEmailMessage email : messages) {
		Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
		emailToSend.setToAddresses(email.getToAddresses());
		emailToSend.setPlainTextBody(email.getPlainTextBody());
		emailToSend.setHTMLBody(email.getHTMLBody());
		emailToSend.setSubject(email.getSubject());
		lstMsgsToSend.add(emailToSend);
	  }
	  Messaging.sendEmail(lstMsgsToSend);
	  System.debug('### AES send email');
	}
  }

  /*
  * @description   collect all the licensed profiles
  * @return	List<string>
  */
  public static List<string> getAllLicensedProfiles() {
	List<string> allLicensedProfiles = new List<string>();
	allLicensedProfiles.add(NCP_Constants.PROFILE_LOGIN_CUSTOMERS);
	allLicensedProfiles.add(NCP_Constants.PROFILE_LOGIN_CUSTOMER_COMMUNITY_PLUS);
	allLicensedProfiles.add(NCP_Constants.PROFILE_CUSTOMER_COMMUNITY_PLUS);
	allLicensedProfiles.add(NCP_Constants.PROFILE_CUSTOMERS);
	return allLicensedProfiles;
  }

  /*
  * @description   Cache all the licensed profiles
  * @return	List<string>
  */
  public static final List<string> ALL_LICENSED_PROFILES = getAllLicensedProfiles();


  /*
  * @description   Test if the user has a community license
  * @return	Boolean
  */
  public static Boolean hasCommunityLicense() {
	Boolean hasLicensedProfile = false;
	Profile userProfileName = [select Name from Profile where id = :UserInfo.getProfileId()];
	if (NCP_Utils.ALL_LICENSED_PROFILES.contains(userProfileName.Name)) {
	  hasLicensedProfile = true;
	}
	return hasLicensedProfile;
  }

  /*
  * @description   Cache all the licensed profiles
  * @return	Boolean
  */
  public static Boolean hasEntitlementRelationship() {
	Boolean hasRelationship = false;
	if (hasCommunityLicense()) {
	  // if the user has a community license need to test if they have an entitlement relationship
	  String userId = System.UserInfo.getUserId();
	  User userInfo = [select id, contactId from User where id = :userId];
	  id userContactId = userInfo.contactId;

	  // select AccountId, ContactId, NCP_Entitlement_Relationship__c from AccountContactRelation where ContactId = '003q000000n1zEGAAY'
	  AccountContactRelation[] acr = [select AccountId from AccountContactRelation where ContactId = :userContactId and NCP_Entitlement_Relationship__c = true];
	  if (acr.size() > 0) {
		hasRelationship = true;
	  }
	} else {
	  // if the user does not have a community license (ie., they are an internal user)
	  // assume that they have a relationship
	  hasRelationship = true;
	}
	return hasRelationship;
  }

  public static Id getObjectRecordTypeId(String objectName, String recordtypeDevName) {

	// break the describe methods apart at each step
	Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
	Schema.DescribeSobjectResult objTypeDesc = objType.getDescribe();
	Map<String, Schema.RecordTypeInfo> recTypeMap = objTypeDesc.getRecordTypeInfosByDeveloperName();
	Schema.RecordTypeInfo rtByName = recTypeMap.get(recordtypeDevName);
	return rtByName.getRecordTypeId();
  }

  public static String getUsername(String emailAddress) {

	String UNIQUE_USERNAME = 'singlecrm.';
	List<String> emailParams = emailAddress.split('@');

	String userName = emailParams[0] + '@' + UNIQUE_USERNAME + emailParams[1];

	if (isSandbox()) {
	  NCP_CustomerCommunitySetting__c setting = NCP_CustomerCommunitySetting__c.getValues('Default');
	  userName += setting.SandboxNameForUserName__c;
	}

	return userName;
  }
}