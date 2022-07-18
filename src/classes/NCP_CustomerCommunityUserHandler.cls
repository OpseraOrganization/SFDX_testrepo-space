global without sharing class NCP_CustomerCommunityUserHandler implements Auth.SamlJitHandler {
	private class JitException extends Exception {
	}
	static Boolean userReactivationUpdateFlag = false;
	static final String NOT_AVAILABLE = 'Not Available';
	static Boolean hasACRChanged = true;
	static Boolean newACRCreationRequiredFlag = false;
	static Boolean oldACRDeletionRequiredFlag = false;
	static Id customerUserId;
	static Map<Id, AccountContactRelation> acrMap = new Map<Id, AccountContactRelation>();
	static Set<Id> incomingAccountIds = new Set<Id>();
	static Id accountIdToBeDeleted;
	static Contact existingContactRecord;
	
	@testVisible
	global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
		String emailAdd, uName1, userRelationship = '';
		User u = new User();
		String trainingOnly;
		
		//Check for Embargo Countries - start
		checkForEmbargoCountries(attributes);
		//Check for Embargo Countries - stop
		
		if (attributes.containsKey('Relationship')) {
			userRelationship = (attributes.get('Relationship')).trim();
		} 
		if (attributes.containsKey('emailID')) {
			emailAdd = (attributes.get('emailID')).trim();
		}
		if (attributes.containsKey('Username')) {
			uName1 = (attributes.get('Username')).trim();
		}
		
		List<User> user = [SELECT Id, Username, contactId, isActive, 
						   Profile.Name,ManagerId, NCP_Is_Internal__c, Street, City,State, postalCode, 
						   CountryCode, FederationIdentifier, Email FROM User WHERE Email =: emailAdd and Username =: uName1 limit 1];
		if(user.size()>0)
		{
			Contact con = [select ID,Email FROM Contact WHERE Id =: user[0].contactID];
			if(userRelationship == 'Internal'){
				u = user[0];
				u.Alias = attributes.containsKey('nsnDomainId') ? attributes.get('nsnDomainId') : u.LastName.left(4) + '1';
				update u;
			}
			if((con.ID != NULL && con.Email == user[0].Email) || userRelationship=='Internal'){
				u = user[0];
				String decodedAssertion = EncodingUtil.base64Decode(assertion).toString();
				u.isActive = true;
				handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, decodedAssertion);
			}
		}else{  
			if (attributes.containsKey('TrainingOnlyUser'))
				trainingOnly = (attributes.get('TrainingOnlyUser'));
		}
		
		if(trainingOnly == 'true'){
			Try{
				update u;
			}
			Catch(Exception e){
				String errMsg = Label.NCP_TrainingOnlyUser_Error_Message;
				throwJitException(Label.NCP_TrainingOnlyUser_Link + errMsg, 'emailID', attributes);		
			}
		}else{
			u = new User(); 
			String decodedAssertion = EncodingUtil.base64Decode(assertion).toString();	
			handleJit(true, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, decodedAssertion);	
		}
		
		return u;
	}
	
	global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,String federationIdentifier, Map<String, String> attributes, String assertion) {
		//Check for Embargo Countries - start
		checkForEmbargoCountries(attributes);
		//Check for Embargo Countries - stop
		
		List<User> users = [SELECT Id, contactId, isActive, Profile.Name,ManagerId, NCP_Is_Internal__c, Street, City, NokiaUID__c, Nokia_ID__c, NCP_SSOPID__c, NCP_IsHorizontal__c, NCP_Horizontal_Company_Name__c, State, PostalCode, CountryCode, FederationIdentifier, Email, UserName, LastName FROM User WHERE Id = :userId];
		String decodedAssertion = EncodingUtil.base64Decode(assertion).toString();
		if (users.isEmpty()) {
			return;
		}
		
		User u = users[0];
		if(attributes.containsKey('Relationship') && attributes.get('Relationship') == 'Internal'){
			u.Alias = attributes.containsKey('nsnDomainId') ? attributes.get('nsnDomainId') : u.LastName.left(4) + '1';
			update u;
		}
		if(!u.isActive && String.isNotBlank(u.ContactId)){
			userReactivationUpdateFlag = true;
			customerUserId = u.Id;
			u.isActive = true;
			//Fetch the ALCR Ids from the attributes
			String primaryAccountFlag = 'true';
			if (attributes.containsKey('nsnPrimaryAccountFlag')) {
				primaryAccountFlag = attributes.get('nsnPrimaryAccountFlag');
			}
			List<String> incomingAccountIdList = handleAccount(false, u, attributes, decodedAssertion, primaryAccountFlag, federationIdentifier);
			for(String incomingAccountId : incomingAccountIdList){
				incomingAccountIds.add(Id.valueOf(incomingAccountId));
			}
			//Fetch the Existing ACRs
			List<AccountContactRelation> existingACRs = new List<AccountContactRelation>();
			
			for(AccountContactRelation acr : [SELECT Id, ContactId, AccountId, NCP_Entitlement_Relationship__c, Account.ParentId, IsDirect
											  FROM AccountContactRelation
											  WHERE contactId = :u.ContactId AND 
											  NCP_Entitlement_Relationship__c = true]){
												  existingACRs.add(acr);
												  acrMap.put(acr.Id, acr);
											  }
			if(!(incomingAccountIdList?.isEmpty())){
				Integer incomingALCRIdsCount = incomingAccountIdList.size();
				Integer existingACRsCount = existingACRs.size();
				if(incomingALCRIdsCount == existingACRsCount &&
				   (
					   (incomingALCRIdsCount == 1 && incomingAccountIdList[0] == existingACRs[0].AccountId) ||
					   (
						   incomingALCRIdsCount == 2 && (
							   (incomingAccountIdList[0] == existingACRs[0].AccountId && incomingAccountIdList[1] == existingACRs[1].AccountId) ||
							   (incomingAccountIdList[0] == existingACRs[1].AccountId && incomingAccountIdList[1] == existingACRs[0].AccountId)
						   )
					   )
				   )
				  ){
					  hasACRChanged = false;
				  }
				else if((incomingALCRIdsCount == 1 && existingACRsCount == 2)){//delete ACR scenario
					if(incomingAccountIdList[0] != existingACRs[0].AccountId){
						accountIdToBeDeleted = existingACRs[0].AccountId;
					}
					else{
						accountIdToBeDeleted = existingACRs[1].AccountId;
					}
					oldACRDeletionRequiredFlag = true;
				}
				else if(incomingALCRIdsCount == existingACRsCount && incomingALCRIdsCount == 1 && incomingAccountIdList[0] != existingACRs[0].AccountId){//1 ACR updated scenario
					accountIdToBeDeleted = existingACRs[0].AccountId;
					oldACRDeletionRequiredFlag = true;
					newACRCreationRequiredFlag = true;
				}
			}
		}
		handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, decodedAssertion);
	}
	
	private void handleUser(Boolean create, User u, String contactId, Map<String, String> attributes,String federationIdentifier, Boolean isStandard, String PrimaryAccount, String assertion) {
		String profileNameCustomer = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_User_Profile__c;
		String profileNameCustomerLogin = NCP_CustomerCommunitySetting__c.getValues('Default').NCP_Customer_Login_Profile__c;
		String emailAddress;
		
		if (create) {
			
			Profile pCustomer;
			try {
				pCustomer = [SELECT Id FROM Profile WHERE name = :profileNameCustomer];
			} catch (Exception e) {throwJitException('Data Mismatch found while processing the request as System is unable to identify the Profile. ', 'emailID', attributes);
								  }
			u.ProfileId = pCustomer.Id;
			
			if (attributes.containsKey('emailID')) {
				emailAddress = attributes.get('emailID');
				String userName = NCP_Utils.getUsername(emailAddress);
				u.Email = emailAddress;
				if (PrimaryAccount == 'true') {
					u.Username = userName;
					u.NCP_CDB_Contact_ID__c = emailAddress;
				} else if (PrimaryAccount == 'false') {
					u.Username = userName + '.' + federationIdentifier;
				}
			}  
		}  
		
		if (attributes.containsKey('FederationIdentifier')) {
			u.FederationIdentifier = attributes.get('FederationIdentifier');
		} else {
			u.FederationIdentifier = federationIdentifier;
		}
		
		u.Nokia_ID__c = u.FederationIdentifier;
		
		if (PrimaryAccount == 'true' && attributes.containsKey('emailID')) {	
			u.NCP_CDB_Contact_ID__c = attributes.get('emailID');
		}
		
		if (attributes.containsKey('PersonalID')) {
			u.NokiaUID__c = attributes.get('PersonalID');
		}
		if (attributes.containsKey('Lname')) {
			u.LastName = attributes.get('Lname');
		}
		if (attributes.containsKey('Fname')) {
			u.FirstName = attributes.get('Fname');
		}
		if (attributes.containsKey('MobilePhone')) {
			u.MobilePhone = attributes.get('MobilePhone');
		}
		if (create && !String.isBlank(contactId)) {
			u.ContactId = contactId;
		}
		if (attributes.containsKey('Relationship')) {
			u.NCP_Relationship__c = attributes.get('Relationship');
		}
		if (attributes.containsKey('Phone')) {
			u.Phone = attributes.get('Phone');
		}
		if (attributes.containsKey('SSOPID')) {
			u.NCP_SSOPID__c = attributes.get('SSOPID');
		}
		if(attributes.containsKey('uid')){
			u.Nam_UID__c = attributes.get('uid');
		}   
		if (attributes.containsKey('Street')) {
			u.Street = attributes.get('Street');
		}
		if (attributes.containsKey('City')) {
			u.City = attributes.get('City');
		}
		if (attributes.containsKey('State')) {
			u.State = attributes.get('State');
			if (u.State == NOT_AVAILABLE){
				u.State = '';
			}
		}
		if (attributes.containsKey('PostalCode')) {
			u.PostalCode = attributes.get('PostalCode');
		}
		if (attributes.containsKey('CountryCode')) {
			u.CountryCode = attributes.get('CountryCode');
		}
		if (attributes.containsKey('ApprovalStatus')) {
			u.NCP_Approval_Status__c = attributes.get('ApprovalStatus');
		}
		if (attributes.containsKey('NSNID') && PrimaryAccount == 'true') {
			u.NCP_NSN_ID__c = attributes.get('NSNID');
		}
		if (attributes.containsKey('HorizontalFlag')) {
			u.NCP_IsHorizontal__c = attributes.get('HorizontalFlag') == '1';
		}
		if (attributes.containsKey('HorizontalCustomerName')) {
			u.NCP_Horizontal_Company_Name__c = attributes.get('HorizontalCustomerName');
		}
		u.UserPermissionsSFContentUser = u.NCP_Relationship__c == 'Partner';
		
		// Added for Timezone attribute
		if (attributes.containsKey('nokiaTimeZone')) {
			
			String CSTimezoneValue;
			For(NCP_Timezone_Mapping__c namTZ: NCP_Timezone_Mapping__c.getAll().Values()){
				if(namTZ.NAM_Timezone__c == attributes.get('nokiaTimeZone'))
					CSTimezoneValue = namTZ.SF_TimeZone__c;
			}
			if(CSTimezoneValue != NULL){
				u.TimeZoneSidKey =  CSTimezoneValue; 
			}else{
				u.TimeZoneSidKey = 'GMT';
			}
		}  
		
		if (create) {
			u.Alias = u.LastName.left(4) + '1';
			u.LanguageLocaleKey = 'en_US';
			u.EmailEncodingKey = 'UTF-8';
			u.LocaleSidKey = 'en_GB';
		}
		
		if (!create) {
			if (Schema.sObjectType.Contact.isUpdateable()) {
				try {
					if (attributes.containsKey('FederationIdentifier')) {
						u.FederationIdentifier = attributes.get('FederationIdentifier');
					}
					update u;
					
					if(userReactivationUpdateFlag){
						if(!hasACRChanged){
							AccountContactRelationTriggerHelper.dmlObjectShare(incomingAccountIds, u.Id, contactId, true, false, false, NULL, NULL);
						}
						else{
							Id incomingAccountId;
							for(Id incomingAccId : incomingAccountIds){
								incomingAccountId = incomingAccId;
							}
							Id parentAccountIdForContact = existingContactRecord != NULL ? existingContactRecord.AccountId : NULL;
							if(newACRCreationRequiredFlag){
								AccountContactRelationTriggerHelper.dmlObjectShare(new Set<Id>{incomingAccountId}, customerUserId, contactId, !hasACRChanged, true, true, accountIdToBeDeleted, parentAccountIdForContact);
							}
							else{
								AccountContactRelationTriggerHelper.dmlObjectShare(new Set<Id>{incomingAccountId}, customerUserId, contactId, !hasACRChanged, false, true, accountIdToBeDeleted, parentAccountIdForContact);
							}   
						}
					}
				} catch (Exception e) {throwJitException('Data Mismatch found while processing the request. ' + ' ' + Label.NCP_SSO_UserUpdate1 + ' Email=' + u.Email + ',Username=' + u.Username + ',NokiaUID__c=' + u.NokiaUID__c + ',FederationIdentifier=' + u.FederationIdentifier + ',Nokia_ID__c=' + u.Nokia_ID__c + ',NCP_SSOPID__c=' + u.NCP_SSOPID__c + ',u.NCP_IsHorizontal__c=' + u.NCP_IsHorizontal__c + ',NCP_Horizontal_Company_Name__c=' + u.NCP_Horizontal_Company_Name__c + ', e=' + e, 'emailID', attributes);
									  }
			}
		}
		else {
			if (Schema.sObjectType.Contact.isCreateable()) {
				try {
					insert u;
				} catch (Exception e) {
					if (e.getMessage().contains('LICENSE_LIMIT_EXCEEDED')) {
						Profile pCustomerLogin;
						try {pCustomerLogin = [SELECT Id FROM Profile WHERE name = :profileNameCustomerLogin];
							} catch (Exception e1){throwJitException('Unable to process the request due to limited access being approved on the Profile. ', 'emailID', attributes);
												  }
						u.ProfileId = pCustomerLogin.Id;
						try {insert u;
							} catch (Exception e2) {throwJitException('Data Mismatch found while processing the User’s request. ' + ' User can not be created! Email=' + u.Email + ',Username=' + u.Username + ',NokiaUID__c=' + u.NokiaUID__c + ',FederationIdentifier=' + u.FederationIdentifier + ',Nokia_ID__c=' + u.Nokia_ID__c + ',NCP_SSOPID__c=' + u.NCP_SSOPID__c + ',u.NCP_IsHorizontal__c=' + u.NCP_IsHorizontal__c + ',NCP_Horizontal_Company_Name__c=' + u.NCP_Horizontal_Company_Name__c + ', e=' + e2, 'emailID', attributes);
												   }
					} else {
						String errMsg = ' User can not be created! Email=' + u.Email + ',Username=' + u.Username + ',NokiaUID__c='
							+ u.NokiaUID__c + ',FederationIdentifier=' + u.FederationIdentifier + ',Nokia_ID__c=' + u.Nokia_ID__c
							+ ',NCP_SSOPID__c=' + u.NCP_SSOPID__c + ',u.NCP_IsHorizontal__c=' + u.NCP_IsHorizontal__c
							+ ',NCP_Horizontal_Company_Name__c=' + u.NCP_Horizontal_Company_Name__c + ', e=' + e;
						throwJitException('Data Mismatch found while processing the User’s request. ' + errMsg, 'emailID', attributes);
					}
				}
			}
		}
	}
	
	private void handleInternalUser(Boolean create, User u, Map<String, String> attributes, String federationIdentifier, Boolean isStandard, String PrimaryAccount) {
		String jiveProfile = System.Label.NCPjiveProfileName ;
		String profileNameInternalUser = NCP_CustomerCommunitySetting__c.getValues('Default').Internal_User_Profile__c;
		String thresholdLicense=NCP_CustomerCommunitySetting__c.getValues('Default').License_Threshold_Limit__c;
		String warningThreshold=NCP_CustomerCommunitySetting__c.getValues('Default').Warning_System_Threshold__c;
		List<User> SpInternalUserList=new List<User>();
		SpInternalUserList=[select Id FROM User WHERE Profile.Name=:profileNameInternalUser and isActive=true];
		List<Profile> profiles = [SELECT Id FROM Profile WHERE name = :profileNameInternalUser];
		String licensingGroupName=NCP_CustomerCommunitySetting__c.getValues('Default').License_Management_Group__c; 
		List<CollaborationGroup> licensingGroup =[select Id FROM CollaborationGroup WHERE Name=:licensingGroupName Limit 1];
		//Only while updating an inactive user or during creation of new user the below block will be executed

		if ((!create&&!u.isActive)||create){
			
			if (u.Profile.Name == jiveProfile) {  
				
				u.isActive = TRUE ;
				u.ProfileId = profiles[0].Id;
				update  u;
				
				List<PermissionSetAssignment> psa = [SELECT Id, PermissionSetId, PermissionSet.Name,  
													 AssigneeId, Assignee.Name FROM PermissionSetAssignment 
													 WHERE AssigneeId =: u.Id AND PermissionSet.IsOwnedByProfile = false];
				
				delete psa;
				
				return;
			}	 
			//If an inactive user does not belongs to below profile throw the error message
			if(!create&&u.Profile.Name !=profileNameInternalUser){throwJitException('Error:  Your Salesforce account is currently deactivated and not eligible for auto-activation for Support portal access. Please contact IT Service Desk for assistance', 'emailID', attributes);
																 }
			
			//if there is no user exists under this profile
			if(profiles.isEmpty()){return;
								  }
			Integer availableLicenseCount=Integer.ValueOf(thresholdLicense)- SpInternalUserList.Size();
			//if InternalUser count is greater or equal to threshold throw error message while creation or activation
			if(SpInternalUserList.Size()>=Integer.ValueOf(thresholdLicense)){throwJitException('Error:  License Threshold has been exceeded.  Please open an IT ticket', 'emailID', attributes);
																			}
			else if(SpInternalUserList.Size()<Integer.ValueOf(thresholdLicense)&& SpInternalUserList.Size()+1>=Integer.ValueOf(warningThreshold)){postLicenseConsumptionMessageInChatter(availableLicenseCount-1,licensingGroup[0].Id);
																																				 }
		}  
		if(!create)
		{
			if ( u.Profile.Name != profileNameInternalUser && u.isActive) { 
				
				if (u.NCP_Is_Internal__c != True) {
					u.NCP_Is_Internal__c = True;
					update  u;
				}
				//return;
			}
			if (u.Profile.Name == jiveProfile) {  
				
				u.ProfileId = profiles[0].Id;
				update  u;
				
				List<PermissionSetAssignment> psa = [SELECT Id, PermissionSetId, PermissionSet.Name,  
													 AssigneeId, Assignee.Name FROM PermissionSetAssignment 
													 WHERE AssigneeId =: u.Id AND PermissionSet.IsOwnedByProfile = false];
				
				delete psa;
				
				// return;
				if(!u.isActive) u.isActive=true;
			}  
			
			
		}	
		
		
		if (create) {
			if (profiles.isEmpty()) { return;
									}
			
			u.ProfileId = profiles[0].Id;
			if (attributes.containsKey('FederationIdentifier')) {u.FederationIdentifier = attributes.get('FederationIdentifier');
																} else {
																	u.FederationIdentifier = federationIdentifier;
																}
			u.Nokia_ID__c = u.FederationIdentifier;
			u.NCP_Is_Internal__c = True;
		}
		
		if (attributes.containsKey('emailID')) {
			String emailAddress = attributes.get('emailID');
			String userName = NCP_Utils.getUsername(emailAddress);
			if (create) {
				U.Email = emailAddress;
			}   
			if (PrimaryAccount == 'true') {
				if (create) {
					u.Username = userName;
				}
				u.NCP_CDB_Contact_ID__c = emailAddress;
			} else if (PrimaryAccount == 'false') {
				if (create) {
					u.Username = userName + '.' + federationIdentifier;
				} 
				
				//u.NCP_CDB_Contact_ID__c = emailAddress + '.' + federationIdentifier;
			}
		}
		
		if (attributes.containsKey('PersonalID')) {
			u.NokiaUID__c = attributes.get('PersonalID');
		}
		if(create){
			if (attributes.containsKey('Lname')) {
				u.LastName = attributes.get('Lname');
			}
			if (attributes.containsKey('Fname')) {
				u.FirstName = attributes.get('Fname');
			}
			if (attributes.containsKey('MobilePhone')) {
				u.MobilePhone = attributes.get('MobilePhone');
			}
			if (attributes.containsKey('Phone')) {
				u.Phone = attributes.get('Phone');
			}
			if (attributes.containsKey('Street')) {
				u.Street = attributes.get('Street');
			}
			if (attributes.containsKey('City')) {
				u.City = attributes.get('City');
			}
			if (attributes.containsKey('State')) {
				u.State = attributes.get('State');
				if (u.State == NOT_AVAILABLE){
					u.State = '';
				}
			}
			if (attributes.containsKey('PostalCode')) {
				u.PostalCode = attributes.get('PostalCode');
			}
			if (attributes.containsKey('CountryCode')) {
				u.CountryCode = attributes.get('CountryCode');
				try{
					u.Market__c = ISO_Country_Codes__c.getvalues(u.CountryCode).Market__c;
					u.Country__c = ISO_Country_Codes__c.getvalues(u.CountryCode).Country_Name__c; 
				}catch(Exception e){
					throwJitException('Data Mismatch found while processing the request as System is unable to identify the Country Code. ', 'emailID', attributes);
				}   
			}
			// Added for Timezone attribute	 
			if (attributes.containsKey('nokiaTimeZone')) {
				String CSTimezoneValue;
				
				For(NCP_Timezone_Mapping__c namTZ: NCP_Timezone_Mapping__c.getAll().Values()){
					if(namTZ.NAM_Timezone__c == attributes.get('nokiaTimeZone'))
						CSTimezoneValue = namTZ.SF_TimeZone__c;
				}
				//  string CSTimezoneValue = NCP_Timezone_Mapping__c.getvalues(attributes.get('nokiaTimeZone')).SF_Timezone__c;
				if(CSTimezoneValue != NULL){
					u.TimeZoneSidKey =  CSTimezoneValue; 
				}else{
					u.TimeZoneSidKey = 'GMT';
				}
			}
			//u.Alias = u.LastName.left(4) + '1';
			u.Alias = attributes.containsKey('nsnDomainId') ? attributes.get('nsnDomainId') : u.LastName.left(4) + '1';
			//  u.TimeZoneSidKey = 'Europe/Amsterdam';
			u.LanguageLocaleKey = 'en_US';
			u.EmailEncodingKey = 'UTF-8';
			u.LocaleSidKey = 'en_GB';
		}   
		
		if (attributes.containsKey('Relationship')) {
			u.NCP_Relationship__c = attributes.get('Relationship');
		}
		
		u.Nokia_ID__c = u.FederationIdentifier;
		u.NCP_Is_Internal__c = true;
		
		
		if (attributes.containsKey('SSOPID')) {
			u.NCP_SSOPID__c = attributes.get('SSOPID');
		}
		if(attributes.containsKey('uid')){u.Nam_UID__c = attributes.get('uid');
										 }
		
		if (attributes.containsKey('ApprovalStatus')) {
			u.NCP_Approval_Status__c = attributes.get('ApprovalStatus');
		}
		if (attributes.containsKey('NSNID') && PrimaryAccount == 'true') {
			u.NCP_NSN_ID__c = attributes.get('NSNID');
		}
		//u.CompanyName = 'Nokia';
		
		if(!create)
		{
			if ( u.Profile.Name != profileNameInternalUser && u.isActive) { 
				if (u.NCP_Is_Internal__c != True) {
					u.NCP_Is_Internal__c = True;
					
				}
				update  u;
				return;
			}
			if(!u.isActive) u.isActive=true;
		}
		if (!create) {
			if (Schema.sObjectType.Contact.isUpdateable()) {
				update u;
			}
		} else {
			if (Schema.sObjectType.Contact.isCreateable()) {
				insert u;
			}
		}
	}
	
	private void handleJit(Boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,String federationIdentifier, Map<String, String> attributes, String assertion) {
		User user = u;
		Boolean c = create;
		String contactId = '';
		Account acct;
		String parentAccountId;
		String relationship = attributes.get('Relationship');
		//throwJitException('Temp Error - ' + relationship, 'emailID', attributes);
		if (relationship == '' || relationship == null) {
			throwJitException('Relationship not identified! Relationship=' + relationship, 'emailID', attributes);
		}
		String PrimaryAccount = 'true';
		if (attributes.containsKey('nsnPrimaryAccountFlag')) {
			PrimaryAccount = attributes.get('nsnPrimaryAccountFlag');
		}
		
		if (relationship == 'Customer' || relationship == 'Supplier' || relationship == 'Sub Contractor' || relationship == 'Guest') {
			List<String> accountIds = new List<String>();
			if(incomingAccountIds.size() > 0){
				List<Id> accIdList = new List<Id>();
				accIdList.addAll(incomingAccountIds);
				accountIds = accIdList;
			}
			else{
				accountIds = handleAccount(c, user, attributes, assertion, PrimaryAccount, federationIdentifier);
			}
			List<Account> accounts;
			accounts = [SELECT Id, ParentId FROM Account WHERE Id IN :accountIds];
			if(accounts?.size() == 2){
				if(accounts[0].ParentId != accounts[1].ParentId){throwJitException('Unable to process the request due to an incorrect mapping received for the User and Customer association. ', 'acr1', attributes);
																}
			}
			
			if(!(accounts?.isEmpty())){	 
				acct = accounts[0];
				parentAccountId = acct.parentId;
			}
			else{
				throwJitException('The association for the User and the Organization record does not match. ', 'acr1', attributes);
			}
			contactId = handleContact(c, accountIds, parentAccountId, user, attributes, PrimaryAccount, federationIdentifier, assertion);
			if(String.isNotBlank(contactId)){
				handleUser(create, u, contactId, attributes, federationIdentifier, false, PrimaryAccount, assertion);
			}   
		}
		else if (relationship == 'Internal') {
			handleInternalUser(create, u, attributes, federationIdentifier, false, PrimaryAccount);
		}
		else if (relationship == 'Partner') {
			//just login. No JIT at all
			if (create) {
				throwJitException('You are trying to connect to Nokia Customer Portal. To get access to relevant access resources, please connect via the www.partners.nokia.com/s/. ', 'emailID', attributes);
			}
		}
		else {
			throwJitException('Relationship value not correct! Relationship=' + relationship, 'emailID', attributes);
		}
	}
	/**************************************************************************************************
	*Method Name:   handleContact
	*Parameter:  Boolean create - create or update User account
	List<String> accountIds - the account Ids received from ALCR ids present in the Attributes
	String parentAccountId - Parent Account Id of the account present in the ALCR ids present in the Attributes
	User u - User record
	Map<String, String> attributes - this contains the attributes list
	String PrimaryAccount - Comes as true if Primary Account flag comes as true in the attributes from NAM
	String federationIdentifier - federation key to identify the User
	String assertion - the default SAML assertion, base-64 encoded.
	*Return:		List<String>
	*Date	Modified By	 Demand   Remarks
	12/02/2021   Soham   DEM0051264  Updated the method to get 2 ALCR attributes as part of DEM0051264 - Multiple ACR
	**************************************************************************************************/
	private String handleContact(Boolean create, List<String> alcrIds, String parentAccountId, User u, Map<String, String> attributes, String PrimaryAccount, String federationIdentifier, String assertion) {
		String p20Id;
		String alcrId;
		String AccountDetails;
		List<Contact> contacts;
		String secondaryFirstName = '';
		String secondaryLastName = '';
		String secondaryPrefix = 'DUP';
		String email = '';
		String userApprovalStatus = '';
		String userRelationship = '';
		Boolean createSSOAccountChangeCase = false;
		Boolean existSSOAccountChangeCase = false;
		Boolean existSSOAccountChangeCaseApproved = false;
		Contact c;
		
		Account independentContractorAccount = fetchIDCAccountDetails();
		
		if(attributes.containsKey('Fname')) {
			secondaryFirstName = (attributes.get('Fname')).trim();
		}
		if(attributes.containsKey('Lname')) {
			secondaryLastName = (attributes.get('Lname')).trim();
		}
		if(attributes.containsKey('P20')) {
			p20Id = attributes.get('P20');
		}
		if(attributes.containsKey(System.Label.NCPAlcrId)) {
			alcrId = attributes.get(System.Label.NCPAlcrId);
		} 
		if(attributes.containsKey('ApprovalStatus')) {
			userApprovalStatus = attributes.get('ApprovalStatus');
		} 
		if(attributes.containsKey('emailID')) {
			email = attributes.get('emailID');
			if(PrimaryAccount == 'false') {
				email = (secondaryFirstName + secondaryLastName + '@' + federationIdentifier + '.com').trim();
			}
			contacts = [SELECT Id, lastName, firstName, Email, AccountId,Owner.Name,OwnerId, createdDate, MKT_IsConvertedForSupportProcess__c, MKT_AttributionCampaign__c, Marketing_Campaign__c FROM Contact WHERE Id = :u.ContactId OR email = :email LIMIT 1];
		}
		else {
			contacts = [SELECT Id, lastName, firstName, Email, AccountId, Owner.Name, OwnerId, createdDate, MKT_IsConvertedForSupportProcess__c, MKT_AttributionCampaign__c, Marketing_Campaign__c FROM Contact WHERE Id = :u.ContactId LIMIT 1];
		}
		
		if(contacts.isEmpty()) {
			
			Integer maxSize = 80;
			String fullName = secondaryFirstName + ' ' + secondaryLastName;
			
			if(fullName.length() > maxSize) {
				fullName = fullName.substring(0, maxSize);
			} 
			
			AccountDetails = 'Contact will be assigned to the parent Account of Legal Entity with numbers: P20 Id: '+p20Id+', ALCRID: '+alcrId;
			Boolean isDuplicateEmail = createCaseForDuplicateLeadContact(email,fullName, AccountDetails, independentContractorAccount, alcrIds, attributes);
			if(isDuplicateEmail) {
				throwJitException('Data Mismatch found while processing the request due to an issue in the email address. ', 'emailID', attributes);
			}else{
				c = new Contact();
				c.MKT_IsConvertedForSupportProcess__c = true;
			}
		} else {
			c = contacts[0];
			if(!c.MKT_IsConvertedForSupportProcess__c){
				c.MKT_IsConvertedForSupportProcess__c = true;
			}
		}
		
		if(create) {
			if(attributes.containsKey('emailID')) {
				if(PrimaryAccount == 'true') {
					c.email = attributes.get('emailID');
				} else if(PrimaryAccount == 'false') {
					c.email = (secondaryFirstName + secondaryLastName + '@' + federationIdentifier + '.com').trim();
				}
			}
		}
		
		if(attributes.containsKey('Fname')) {
			if(PrimaryAccount == 'false'){
				c.FirstName = secondaryPrefix + attributes.get('Fname');
			}else{
				c.FirstName = attributes.get('Fname'); 
			}  
		}
		if(attributes.containsKey('Lname')) {
			if(PrimaryAccount == 'false'){
				c.LastName = secondaryPrefix + attributes.get('Lname');
			}else{
				c.LastName = attributes.get('Lname'); 
			}
		}
		
		if(attributes.containsKey('ApprovalStatus')) {
			userApprovalStatus = attributes.get('ApprovalStatus');
		}
		
		if(attributes.containsKey('MobilePhone')) {
			c.MobilePhone = attributes.get('MobilePhone');
		}
		if(attributes.containsKey('Street')) {
			c.MailingStreet = attributes.get('Street');
		}
		if(attributes.containsKey('City')) {
			c.MailingCity = attributes.get('City');
		} 
		if(attributes.containsKey('State')) {
			c.MailingState = attributes.get('State');
			if(c.MailingState == NOT_AVAILABLE){
				c.MailingState = '';
			}
		}
		if(attributes.containsKey('PostalCode')) {
			c.MailingPostalCode = attributes.get('PostalCode');
		}
		if(attributes.containsKey('CountryCode')) {
			c.MailingCountryCode = attributes.get('CountryCode');
			try {
				c.Market__c = ISO_Country_Codes__c.getvalues(c.mailingCountryCode).Market__c;
			}
			catch(Exception e){
				throwJitException('Data Mismatch found while processing the request as System is unable to identify the Country Code. ', 'CountryCode', attributes);
			} 
		}
		if(attributes.containsKey('Phone')) {
			c.Phone = attributes.get('Phone');
		}
		if(attributes.containsKey('SSOPID')) {
			c.NCP_External_Contact_Id__c = attributes.get('SSOPID');
		} 
		
		if(attributes.containsKey('Relationship')) {
			userRelationship = attributes.get('Relationship');
		}
		if(PrimaryAccount == 'false'){
			c.CH_ContactType__c = 'Secondary Account';
			c.NCP_Secondary_Account__c = true; 
			c.Sync_To_Marketo__c = false;
		}
		else if(userRelationship == 'Supplier'){
			c.CH_ContactType__c = 'Supplier';
		} else if(userRelationship == 'Customer'){
			c.CH_ContactType__c = 'Customer';
		}
		
		if(contacts.isEmpty()) {//Contact not present
			if(!(alcrIds?.isEmpty()) && String.isNotBlank(parentAccountId)) {
				c.AccountId = parentAccountId;
			}
			if(Schema.sObjectType.Contact.isCreateable()) {
				try {
					insert c;
				} catch (Exception e) {throwJitException('Error encountered while processing your data on Nokia Support Portal. ', 'emailID', attributes);
									  }
			}
			
			//create Account Contact Relationship record for legal entity
			if(!(alcrIds?.isEmpty())){
				List<AccountContactRelation> acrs = new List<AccountContactRelation>();
				for(String accountIdStr : alcrIds){
					AccountContactRelation acr = new AccountContactRelation();
					acr.AccountId = accountIdStr;
					acr.ContactId = c.Id;
					acr.NCP_Entitlement_Relationship__c = true;
					acrs.add(acr);
				}
				insert acrs;
				//gAccountId = alcrIds[0];
			}
		}
		else {//Contact present
			if(hasACRChanged){
				try{
					List<AccountContactRelation> existingACRs = [SELECT Id, ContactId, AccountId, NCP_Entitlement_Relationship__c, Account.ParentId
																 FROM AccountContactRelation
																 WHERE contactId = :c.Id AND 
																 NCP_Entitlement_Relationship__c = true AND
																 isActive = true];
					Boolean recurssionUpdateCheck = false;
					
					//Check if both ALCRs are populated in the Attributes?
					if(!(alcrIds?.isEmpty())){
						switch on alcrIds.size(){
							when 1{//1 ALCR has been populated
								if(!(existingACRs?.isEmpty())){
									switch on existingACRs.size(){
										when 1{//1 ACR exists - 1 ALCR incoming
											if(alcrIds[0] != existingACRs[0].AccountId){//Check if ALCR does not have the same LE already present in the ACR?
												if(existingACRs[0].Account.ParentId == parentAccountId){//Check if Parent Id of existing ACR (Contact's Parent Id) and incoming ALCR are same?
													dmlOnACR(parentAccountId, alcrIds[0], c, existingACRs, true, attributes);//Deactivate the existing ACR(s). Create new ACR
												}
												else{
													parentAccountChange(parentAccountId, alcrIds[0], c,  attributes, existingACRs);
												}
											}
										}
										when 2{//2 ACRs exist - 1 ALCR incoming
											//Has 1 ACR been removed or both the ACRs are replaced by a single ALCR?
											if(alcrIds[0] == existingACRs[0].AccountId){//1st ACR is a match with ALCR
												dmlOnACR(parentAccountId, alcrIds[0], c, new List<AccountContactRelation>{existingACRs[1]}, false, attributes);//remove the 2nd ACR
											}
											else if(alcrIds[0] == existingACRs[1].AccountId){//2nd ACR is a match with ALCR
												dmlOnACR(parentAccountId, alcrIds[0], c, new List<AccountContactRelation>{existingACRs[0]}, false, attributes);//remove the 1st ACR
											}
											else{//Both the ACRs have been replaced by a single ALCR
												if(existingACRs[0].Account.ParentId == parentAccountId && existingACRs[1].Account.ParentId == parentAccountId){//Check if Parent Id of existing ACR (Contact's Parent Id) and incoming ALCR are same?
													dmlOnACR(parentAccountId, alcrIds[0], c, existingACRs, true, attributes);//Deactivate the existing ACR(s). Create new ACR
												}
												else{
													parentAccountChange(parentAccountId, alcrIds[0], c,  attributes, existingACRs);
												}
											}
										}
									}
								}
								else{
									if(c.AccountId != parentAccountId){
										parentAccountChange(parentAccountId, alcrIds[0], c,  attributes, existingACRs);
									}
									else{
										dmlOnACR(parentAccountId, alcrIds[0], c, null, true, attributes);
									}
								}
							}
							when 2{//2 ALCRs have been populated
								if(!(existingACRs?.isEmpty())){
									switch on existingACRs.size(){
										when 1{//1 ACR exists
											//Create new ACR for the LE not present in the ACR in Salesforce
											if(alcrIds[0] == existingACRs[0].AccountId){
												dmlOnACR(parentAccountId, alcrIds[1], c, null, true, attributes);//Create new ACR for the LE not present in Salesforce
											}
											else if(alcrIds[1] == existingACRs[0].AccountId){
												dmlOnACR(parentAccountId, alcrIds[0], c, null, true, attributes);//Create new ACR for the LE not present in Salesforce
											}
										}
										when 2{//2 ACRs exist
											if(!((alcrIds[0] == existingACRs[0].AccountId && alcrIds[1] == existingACRs[1].AccountId) || (alcrIds[0] == existingACRs[1].AccountId && alcrIds[1] == existingACRs[0].AccountId))){
												if(alcrIds[0] == existingACRs[0].AccountId){
													dmlOnACR(parentAccountId, alcrIds[1], c, new List<AccountContactRelation>{existingACRs[1]}, true, attributes);//remove the 2nd ACR, create the new one
												}
												else if(alcrIds[1] == existingACRs[0].AccountId){//1st ACR is a match with either ALCR	  
													dmlOnACR(parentAccountId, alcrIds[0], c, new List<AccountContactRelation>{existingACRs[1]}, true, attributes);//remove the 2nd ACR, create the new one
												}
												else if(alcrIds[0] == existingACRs[1].AccountId){
													dmlOnACR(parentAccountId, alcrIds[1], c, new List<AccountContactRelation>{existingACRs[0]}, true, attributes);//remove the 1st ACR, create the new one
												}
												else if(alcrIds[1] == existingACRs[1].AccountId){//2nd ACR is a match with either ALCR
													dmlOnACR(parentAccountId, alcrIds[0], c, new List<AccountContactRelation>{existingACRs[0]}, true, attributes);//remove the 1st ACR, create the new one
												}
											}
										}
									}
								}
							}
						}
					}
				}catch (Exception e) {
					if(e.getMessage().contains('There is an active Open S/w or H/w Case existing against the Orgranization. Requested update cannot be executed.')){
						throwJitException('There is an active Open S/w or H/w Case existing against the Orgranization. Requested update cannot be executed.', 'emailID', attributes);   
					}
					else{
						throwJitException('Unable to process to request. There has been an issue in the incoming request related to your mapping with Customer Association.', 'emailID', attributes);
					}
					
				}
				if(Schema.sObjectType.Contact.isUpdateable()) {
					try {
						//update c;
						if(!userReactivationUpdateFlag){
							if(c.AccountId != parentAccountId){
								c.AccountId = parentAccountId;
							}
							ID jobID = System.enqueueJob(new NCP_CustCommContactCreationQueueable(c));
						}
					} catch (Exception e) {throwJitException('Error encountered while updating your data on Nokia Support Portal. ', 'emailID', attributes);
										  }
				}
			}   
		}
		return c.Id;
	}
	/**************************************************************************************************
	*Method Name:   handleAccount
	*Parameter:  Boolean create - create or update User account
	User u - User record
	Map<String, String> attributes - this contains the attributes list
	String assertion - the default SAML assertion, base-64 encoded.
	String PrimaryAccount - Comes as true if Primary Account flag comes as true in the attributes from NAM
	String federationIdentifier - federation key to identify the User
	*Return:		List<String>
	*Date	Modified By	 Demand   Remarks
	12/02/2021   Soham   DEM0051264  Updated the method to get 2 ALCR attributes as part of DEM0051264 - Multiple ACR
	**************************************************************************************************/
	private List<String> handleAccount(Boolean create, User u, Map<String, String> attributes, String assertion, String PrimaryAccount, String federationIdentifier) {
		List<String> accountIds = new List<String>();
		/* String parentAccountId = ''; */
		String accountName = '';
		String accountNumber = '';
		String userApprovalStatus = '';
		String p20Id = '';
		List<String> alcrs = new List<String>();
		
		if (attributes.containsKey('ApprovalStatus')) {
			userApprovalStatus = attributes.get('ApprovalStatus');
		}
		if (attributes.containsKey('CustomerName')) {
			accountName = attributes.get('CustomerName');
		}
		if (attributes.containsKey('P20')) {
			p20Id = attributes.get('P20');
		}
		if(attributes.containsKey(System.Label.NCPAlcrId)) {//ALCR
			alcrs.add(attributes.get(System.Label.NCPAlcrId));
		}
		if(attributes.containsKey(System.Label.NCPSecAlcrId)) {//nokiaSecAlcrId
			alcrs.add(attributes.get(System.Label.NCPSecAlcrId));
		}
		//check if Contact record exists 
		String email;
		List<Contact> contacts; 
		String secondaryFirstName = '';
		String secondaryLastName = ''; 
		if (attributes.containsKey('Fname')) {
			secondaryFirstName = attributes.get('Fname');
		}
		if (attributes.containsKey('Lname')) {
			secondaryLastName = attributes.get('Lname');
		}  
		if (attributes.containsKey('emailID')) {
			email = attributes.get('emailID');
			if (PrimaryAccount == 'false') {
				email = secondaryFirstName + secondaryLastName + '@' + federationIdentifier + '.com';
			}
			contacts = [SELECT Id, lastName, firstName, Email, AccountId FROM Contact WHERE Id = :u.ContactId OR email = :email LIMIT 1];
		} else {
			contacts = [SELECT Id, lastName, firstName, Email, AccountId FROM Contact WHERE Id = :u.ContactId LIMIT 1];
		}
		List<Account> acctList;
		String errMsg = '';
		if (!(alcrs?.isEmpty())) {
			acctList = [SELECT Id, ParentId FROM Account WHERE AccountNumber IN :alcrs];
		}
		else if(String.isNotBlank(p20Id)) {
			try {
				acctList = [SELECT Id, parentId FROM Account WHERE NCP_P20_ID__c = :p20Id LIMIT 1];
			} catch (Exception e) {
				if(contacts.isEmpty()){throwJitException('Unable to process to request. No Customer data has been found. ', 'emailID', attributes);
									  }
			}
		}
		
		if(acctList?.size() > 0){
			for(Account accRecord: acctList){
				accountIds.add(accRecord.Id);
			} 
		}
		return accountIds;
	}
	
	public Boolean createCaseForDuplicateLeadContact(String email,String fullName, String accountDetails, Account independentContractorAccount, List<String> accountIds, Map<String, String> attributes){
		Boolean leadEmailExists = false;
		List<Lead> leadsList = [SELECT Id, email,FirstName,LastName, status, recordType.name FROM lead WHERE email = :email AND RecordType.name IN ('Direct Sales', 'TXLE Lead') AND status != 'Closed - Converted (Qualified)'];
		if (leadsList.size()>0) {
			String leadEmail = leadsList[0].Email;
			//Check if the ALCR belongs to the Independent Contractor Account
			//if(independentContractorAccount?.Id == accountIds[0] || independentContractorAccount?.Id == accountIds[1]){
			if(accountIds?.size() > 0 && independentContractorAccount != NULL && independentContractorAccount.Id != NULL && accountIds.contains(independentContractorAccount.Id)){
				throwJitException('As per the System records, you are being granted Guest access. Currently, System is unable to process your request due to Internal Processing. If you are looking to access training portal, please click here  https://nokialearn.csod.com/client/nokialearn/default.aspx.', 'emailID', attributes);
			}
			else{
				//Add check if Case does not exist
				if (!isCaseExists(leadEmail)) {
					Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SF_Support').getRecordTypeId();
					callExistingContactPlatformEvent(leadsList[0],String.valueOf(recTypeId),fullName,accountDetails);
				}
				leadEmailExists = true;
			}
		}
		return leadEmailExists;
	}
	@testVisible
	private Boolean isCaseExists(String leadEmail){
		
		Boolean caseExists = false;
		List<Case> caseList = [SELECT Id FROM Case WHERE RecordType.Name ='SF Support' AND Status='New' AND SuppliedEmail =:leadEmail];
		
		if(caseList.size()>0){
			caseExists = true;
		}
		return caseExists;
	}
	
	//DEM0051264 - Multiple ACR
	private Account fetchIDCAccountDetails(){
		String accountName = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_Account__c;
		String accountNumber = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_Account_Number__c; 
		
		Account independentContractorAccount = null;
		
		try {
			//get accountId and parentAccountId
			independentContractorAccount = [SELECT Id, ParentId, AccountNumber FROM Account WHERE AccountNumber = :accountNumber AND Name = :accountName LIMIT 1];
		} catch (Exception e) {
		}   
		
		
		return independentContractorAccount;
	}
	
	/**************************************************************************************************
	*Method Name:   throwJitException
	*Parameter:  String errorMessage - Text for the JIT exception
	String parameterStr - Parameter to spotlight
	Map<String, String> attributes - this contains the attributes list
	*Return:		nothing
	*Date	Modified By	Demand   Remarks
	2/26/2021	 Karan DEM0051264 Common method created to throw an exception for JIT Handler
	**************************************************************************************************/
	public void throwJitException(String errorMessage, String parameterStr, Map<String, String> attributes){
		throw new JitException(getErrorMessage(errorMessage, attributes, attributes.get(parameterStr)));
	}
	
	/**************************************************************************************************
	*Method Name:   getErrorMessage
	*Parameter:  String errorMessage - Text for the JIT exception
	String userName -	Parameter to spotlight
	Map<String, String> attributes - this contains the attributes list  
	*Return:		nothing
	*Date	Modified By	Demand   Remarks
	2/26/2021	 Karan DEM0051264 Common method created to throw an exception for JIT Handler
	**************************************************************************************************/  
	private String getErrorMessage(String errorMessage, Map<String, String> attributes, String userName) {
		
		Map<String, Object> err = new Map<String, Object>{
			'UserName' => userName,
				'Attributes' => attributes,
				'ErrorMessage' => errorMessage
				};
					return JSON.serialize(err);
	}
	
	/**************************************************************************************************
	*Method Name:   parentAccountChange
	*Parameter:  String incomingParentAccountId - Parent 301 account on the ALCR
	String alcrId -   alcrId recieved in the NAM request
	Contact contactRecord   - Contact associated with ALCR 
	List<Case> cases - Check if there are existing Cases for “NCP SSO Account Change” for the 
	Contact and new Parent Account from ALCR? Status = New/Rejected/Closed/Approved
	Map<String, String> attributes - this contains the attributes list  
	List<AccountContactRelation> - existing acr on the account  
	*Return:		nothing
	*Date	Modified By	Demand   Remarks
	2/26/2021	 Soham DEM0051264 If case present and in approved status call create/update contact. 
	If case not presend check marketing/salesopportunity/software case 
	**************************************************************************************************/  
	public void parentAccountChange(String incomingParentAccountId, String alcrId, Contact contactRecord, Map<String, String> attributes, List<AccountContactRelation> acrs){
		String existingParentAccountId;
		List<String> accountIds = new List<String>();
		Boolean approvedCaseFlag = false;
		Boolean newClosedRejectedCaseFlag = false;
		if(acrs.size() > 0){
			for(AccountContactRelation acr : acrs){
				existingParentAccountId = acr.Account.ParentId;
				accountIds.add(acr.AccountId);
			}
		}
		else{
			existingParentAccountId = contactRecord.AccountId;
		}
		
		if(marketingEventExists(existingParentAccountId, contactRecord) || salesOpportunityExists(existingParentAccountId, contactRecord)){
			List<Case> caseList = [SELECT Id, Status FROM Case WHERE recordtype.name = 'NCP SSO Account Change' AND contactId = :contactrecord.Id AND accountID = :existingParentAccountId AND Status IN ('Approved', 'New', 'Closed', 'Rejected') ORDER BY CreatedDate DESC];
			if(caseList?.size() > 0){
				for(Case caseRecord : caseList){
					if(caseRecord.Status == 'Approved'){
						approvedCaseFlag = true;			
						break;
					}
					else if(caseRecord.Status == 'New'){
						break;
					}
					else if(caseRecord.Status == 'Closed' || caseRecord.Status == 'Rejected'){
						newClosedRejectedCaseFlag = true;	 
						break;
					}
				}
			}
			else{
				newClosedRejectedCaseFlag = true;
			}
			if(approvedCaseFlag){
				dmlOnACR(incomingParentAccountId, alcrId, contactRecord, acrs,true, attributes);
			}
			if(newClosedRejectedCaseFlag){
				createCase(contactRecord,attributes, false);
			}
		}
		else{
			dmlOnACR(incomingParentAccountId, alcrId, contactRecord, acrs,true, attributes);
		}
	}
	
	
	/**************************************************************************************************
	*Method Name:   dmlOnACR
	*Parameter:  String incomingParentAccountId - Parent 301 account on the ALCR
	String alcrId -   alcrId recieved in the NAM request
	Contact contactRecord   - Contact associated with ALCR 
	List<AccountContactRelation> acrs - Check if there are existing Cases for “NCP SSO Account Change” for the 
	Boolean insertRequired  
	*Return:		nothing
	*Date	Modified By	Demand   Remarks
	3/4/2021	Karan   DEM0051264 Create new ACR for the LE not present in the ACR in Salesforce 
	**************************************************************************************************/  
	private void dmlOnACR(String incomingParentAccountId, String alcrId, Contact contactrecord, List<AccountContactRelation> existingACRs, Boolean insertRequired, Map<String, String> attributes){
		Boolean dmlOnContactACRAllowed = true;
		Boolean existingACRDeleteFlag = false;
		Boolean createCaseFlag = false;
		Set<Id> acrIds = new Set<Id>();
		if(existingACRs?.size() > 0){
			List<String> accountIds = new List<String>();
			String existingParentAccountId;
			for(AccountContactRelation acr : existingACRs){
				acrIds.add(acr.Id);
				accountIds.add(acr.AccountId);
				existingParentAccountId = acr.Account.ParentId;
			}
			if(swhwCaseExists(contactRecord.Id, accountIds)){
				List<Case> caseList = [SELECT Id, Status FROM Case WHERE recordtype.name = 'NCP SSO Account Change' AND contactId = :contactrecord.Id AND accountID = :existingParentAccountId AND Status IN ('Approved', 'New', 'Closed', 'Rejected') ORDER BY CreatedDate DESC];
				if(caseList?.size() > 0){
					for(Case caseRecord : caseList){
						if(caseRecord.Status == 'Approved'){
							existingACRDeleteFlag = true;
							break;
						}
						else if(caseRecord.Status == 'New'){
							dmlOnContactACRAllowed = false;
							break;
						}
						else if(caseRecord.Status == 'Closed' || caseRecord.Status == 'Rejected'){
							dmlOnContactACRAllowed = false;
							createCaseFlag = true;
							break;
						}
					}
				}
				else{
					dmlOnContactACRAllowed = false;
					createCaseFlag = true;	  
				}
			}
			else{   
				existingACRDeleteFlag = true;
			}
			if(createCaseFlag){
				if(existingParentAccountId == incomingParentAccountId){
					createCase(contactRecord,attributes, true);
				}
				else{
					createCase(contactRecord,attributes, false);
				}
			}
		}
		if(dmlOnContactACRAllowed){
			if(contactRecord.AccountId != incomingParentAccountId){
				contactRecord.AccountId = incomingParentAccountId;
				if(userReactivationUpdateFlag){
					existingContactRecord = contactRecord;
				}
				else{
					update contactRecord;
				}
			}
			
			if(insertRequired && !userReactivationUpdateFlag){
				AccountContactRelation newACR = new AccountContactRelation();
				newACR.AccountId = alcrId;
				newACR.ContactId = contactRecord.Id;
				newACR.NCP_Entitlement_Relationship__c = true;
				insert newACR;
			}
		}
		if(existingACRDeleteFlag && !(userReactivationUpdateFlag && hasACRChanged)){
			delete existingACRs;
		}
	}
	
	/**************************************************************************************************
	*Method Name:   marketingEventExists
	*Parameter:  String parentAccountId - Parent 301 account on the ALCR	 
	*Return:		Boolean
	*Date	Modified By	Demand   Remarks
	3/4/2021	Karan   DEM0051264 On ParentAccountChange when we have no case associated with the account. We checking marketing data.
	**************************************************************************************************/  
	private Boolean marketingEventExists(String parentAccountId, Contact contactRecord){
		//List<Event__c> events = [SELECT Id, Account__c, Event_Type__c FROM Event__c WHERE (Event_Type__c = 'ERM - Executive Review Meeting' OR Event_level__c = 'ERM') AND Account__c =: parentAccountId AND Event_phase__c !='Closed'];
		List<CampaignMember> campaignMemberList = [SELECT Id FROM CampaignMember WHERE ContactId =: contactRecord.Id];
		//if(String.isNotBlank(contactRecord.MKT_AttributionCampaign__c) || String.isNotBlank(contactRecord.Marketing_Campaign__c) || events?.size() > 0 || campaignMemberList?.size() > 0){
		if(String.isNotBlank(contactRecord.MKT_AttributionCampaign__c) || String.isNotBlank(contactRecord.Marketing_Campaign__c) || campaignMemberList?.size() > 0){
			return true;
		}
		return false;
	}
	/**************************************************************************************************
	*Method Name:   salesOpportunityExists
	*Parameter:  String parentAccountId - Parent 301 account on the ALCR	 
	*Return:		Boolean
	*Date	Modified By	Demand   Remarks
	3/4/2021	Karan   DEM0051264 On ParentAccountChange when we have no case associated with the account. We checking opportunity data.
	**************************************************************************************************/ 
	private Boolean salesOpportunityExists(String parentAccountId, Contact contactRecord){
		List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
		/*opportunities = [SELECT Id, AccountId FROM Opportunity WHERE StageName NOT IN ('Completed', 'Closed - Cancelled by Customer', 'Closed - Withdrawn by Nokia', 'Closed - Lost to Competitor', 'Closed - Obsolete', 'Cancelled', 'Closed') AND AccountId =:parentAccountId];*/
		ocrList = [SELECT Id FROM OpportunityContactRole WHERE Opportunity.AccountId = :parentAccountId AND ContactId = :contactRecord.Id AND Opportunity.StageName NOT IN ('Completed', 'Closed - Cancelled by Customer', 'Closed - Withdrawn by Nokia', 'Closed - Lost to Competitor', 'Closed - Obsolete', 'Cancelled', 'Closed')];
		return ocrList.size() > 0 ? true : false;
	}
	/**************************************************************************************************
	*Method Name:   swhwCaseExists
	*Parameter:  String parentAccountId - Parent 301 account on the ALCR	 
	*Return:		Boolean
	*Date	Modified By	Demand   Remarks
	3/4/2021	Karan   DEM0051264 On ParentAccountChange when we have no case associated with the account. We checking Software or Hardware case exist.
	**************************************************************************************************/ 
	private Boolean swhwCaseExists(String contactIdStr, List<String> accountIdList){
		List<Case> cases = new List<Case>();
		List<String> endStatusList = Label.NCP_Case_End_Status.split(',');
		cases = [SELECT Id, CH_RecordTypeDevName__c, HWS_RecordTypeCheck__c, ContactId, AccountId
				 FROM CASE
				 WHERE (CH_RecordTypeCheck__c = true OR HWS_RecordTypeCheck__c = true) AND 
				 ContactId = :contactIdStr AND AccountId IN :accountIdList AND
				 Status NOT IN :endStatusList];
		return cases.size() > 0 ? true : false;
	}
	@testVisible
	private void callExistingContactPlatformEvent(Lead singleLead,String recordTypeId,String fullName,String accountDetails){
		List<NCP_ExistingContact__e> existingContactEvent = new List<NCP_ExistingContact__e>();
		existingContactEvent.add(new NCP_ExistingContact__e(
			Lead_ID__c = singleLead.Id,
			Reported_User_ID__c = UserInfo.getUserId(),
			Lead_Email__c = singleLead.Email,
			Record_Type_ID__c = recordTypeId,
			Full_Name__c = fullName,
			Account_Details__c = accountDetails));
		List<Database.SaveResult> results = EventBus.publish(existingContactEvent);
	}
	
	@testVisible
	private void createCase(Contact con,Map<String, String> attributes, Boolean swhwCaseExistsFlag){
		
		String p20Id;
		String alcrId;
		
		String ssoPortalSupportEmail = Label.NCP_PortalSupport_email;
		List<User> portalSupportUser = [select Id, Email FROM User WHERE Email =: ssoPortalSupportEmail LIMIT 1];
		
		if (attributes.containsKey('P20')) {
			p20Id = attributes.get('P20');
		}
		if(attributes.containsKey(System.Label.NCPAlcrId)) {
			alcrId = attributes.get(System.Label.NCPAlcrId);
		}
		
		Case newCase = new Case();
		Id caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('NCP_SSO_Account_Change').getRecordTypeId();
		newCase.RecordTypeId =  caseRecTypeId;
		newCase.contactid = con.Id;
		if(!portalSupportUser.isEmpty()){
			newCase.OwnerId = portalSupportUser[0].Id;
		}   
		newCase.accountId = con.accountId;
		newCase.subject = 'Contact '+con.email +  + ' - ' + Label.NCP_SSO_Acc_Case_Subject;
		newCase.description = 'Contact '+con.email + Label.NCP_SSO_Acc_Case_Description + ' NAM P20ID= ('+p20Id+'). NAM ALCRID= ('+alcrId+').';
		newCase.description += swhwCaseExistsFlag ? ' There are existing Hardware or Software Cases opened against the User. Please escalate the issue to CAPM for the closure of the Cases.': '';
		newCase.Priority = 'Critical';
		newCase.Origin = 'Web';
		
		Database.DMLOptions dmo = new Database.DMLOptions();
		dmo.assignmentRuleHeader.useDefaultRule= true;
		dmo.EmailHeader.triggerAutoResponseEmail = true;
		dmo.EmailHeader.triggerUserEmail = true;
		dmo.EmailHeader.triggerOtherEmail = true;
		//dmo.assignmentRuleHeader.assignmentRuleId= '01Q41000000fp0CEAQ';
		newCase.setOptions(dmo);
		insert newCase;
	}
	@testVisible
	private void postLicenseConsumptionMessageInChatter(integer availableLicense,Id chattergroupId){
		if(chattergroupId!=null){
			
			FeedItem feed = new FeedItem();
			feed.ParentId = chattergroupId;
			feed.Body ='Hi Members! ,Only '+availableLicense+' Reserved SP Licenses Are Remaining To Activate User';
			
			try{
				insert feed;
			}
			catch(Exception e){}
		}
	}

	@testVisible
	private void checkForEmbargoCountries(Map<String, String> attributes){
		if(String.isNotBlank(Label.NCP_EmbargoCountries) && attributes.containsKey('CountryCode') && 
		Label.NCP_EmbargoCountries.containsIgnoreCase(attributes.get('CountryCode')) && String.isNotBlank(Label.NCP_RelationshipTypeBannedForEmbargoCountries) &&
		attributes.containsKey('Relationship') && Label.NCP_RelationshipTypeBannedForEmbargoCountries.containsIgnoreCase(attributes.get('Relationship'))){
			throwJitException('Error: Your Support Portal account has been restricted. Please contact Nokia Contact Person for further assistance.', 'CountryCode', attributes);
		}
	}
}