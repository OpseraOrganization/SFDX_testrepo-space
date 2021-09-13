global class NCP_CommunityUserHandler implements Auth.SamlJitHandler {
		
		private class JitException extends Exception{}
		
		private void handleUser(Boolean create, User u, String contactId, Map<String, String> attributes,
								String federationIdentifier, Boolean isStandard) {
									System.debug('create ' + create);
									System.debug('UserId ' + u.Id);
									System.debug('federationIdentifier ' + federationIdentifier);

			if(create && attributes.containsKey('User.Username')) {
				u.Username = attributes.get('User.Username');
			}
			if(create) {
				
				if(attributes.containsKey('FederationIdentifier')) {
					u.FederationIdentifier = attributes.get('FederationIdentifier');
				} else {
					u.FederationIdentifier = federationIdentifier;
				} 
				
				if(attributes.containsKey('User.Nokia_ID__c')) {
					u.Nokia_ID__c = attributes.get('User.Nokia_ID__c');
				}
				
				//u.Nokia_ID__c =  u.FederationIdentifier;			   
			}
			
				System.debug('User Profile from Custom Settings');
				String profileName = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_User_Profile__c;
				//String profileName = 'Customers Login';
				//String profileName = 'Partner Community User';
				System.debug('profileName ' + profileName);
				Profile p = [SELECT Id FROM Profile WHERE name = :profileName];
				u.ProfileId = p.Id;		   
			if(attributes.containsKey('User.Email')) {
				u.Email = attributes.get('User.Email');
			}
			if(attributes.containsKey('User.NokiaUID__c')) {
				u.NokiaUID__c = attributes.get('User.NokiaUID__c');
			}
			if(attributes.containsKey('User.LastName')) {
				u.LastName = attributes.get('User.LastName');
			}
			if(attributes.containsKey('User.FirstName')) {
			  u.FirstName = attributes.get('User.FirstName');
			}
			if (create && !String.isBlank(contactId) ) {
				u.ContactId = contactId;
			}  
			if(create) {
				u.Alias = u.LastName.left(4)+'1';
				u.TimeZoneSidKey = 'Europe/Amsterdam';
				u.LanguageLocaleKey = 'en_US';
				u.EmailEncodingKey = 'UTF-8';
				u.LocaleSidKey = 'en_GB';
			}
			System.debug('User.Username ' + u.Username);
			System.debug('User.FederationIdentifier ' + u.FederationIdentifier);
			System.debug('User.ProfileId ' + u.ProfileId);
			System.debug('User.Email ' + u.Email);
			System.debug('User.LastName ' + u.LastName);
			System.debug('User.FirstName ' + u.FirstName);
			System.debug('User.Nokia_ID__c ' + u.Nokia_ID__c);
			System.debug('User.ContactId ' + u.ContactId);
			
			if(!create){
				if(!Schema.sObjectType.Contact.isUpdateable()) {
					System.debug(LoggingLevel.Error, 'you don\'t have access to update User');
				} else {
					update(u);
				}
			}
			else{
				if(!Schema.sObjectType.Contact.isCreateable()) {
					System.debug(LoggingLevel.Error, 'you don\'t have access to create User');
				} else {
					insert(u);
				}				
			}
		}
		
		private void handlePartnerUser(Boolean create, User u, String contactId, Map<String, String> attributes,
								String federationIdentifier, Boolean isStandard) {
									System.debug('create ' + create);
									System.debug('UserId ' + u.Id);
									System.debug('federationIdentifier ' + federationIdentifier);

			
			
			if(create && attributes.containsKey('User.Username')) {
				u.Username = attributes.get('User.Username');
			}
			if(create) {
				
				if(attributes.containsKey('FederationIdentifier')) {
					u.FederationIdentifier = attributes.get('FederationIdentifier');
				} else {
					u.FederationIdentifier = federationIdentifier;
				} 
				
				if(attributes.containsKey('User.Nokia_ID__c')) {
					u.Nokia_ID__c = attributes.get('User.Nokia_ID__c');
				}
				
				//u.Nokia_ID__c =  u.FederationIdentifier;			   
			}
			
				System.debug('User Profile from Custom Settings');
				//String profileName = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_User_Profile__c;
				//String profileName = 'Customers Login';
				//String profileName = 'Partner Community User';
				String profileName = 'Customers - Dummy';
				
				System.debug('profileName ' + profileName);
				Profile p = [SELECT Id FROM Profile WHERE name = :profileName];
				u.ProfileId = p.Id;		   
			if(attributes.containsKey('User.Email')) {
				u.Email = attributes.get('User.Email');
			}
			if(attributes.containsKey('User.NokiaUID__c')) {
				u.NokiaUID__c = attributes.get('User.NokiaUID__c');
			}
			if(attributes.containsKey('User.LastName')) {
				u.LastName = attributes.get('User.LastName');
			}
			if(attributes.containsKey('User.FirstName')) {
			  u.FirstName = attributes.get('User.FirstName');
			}
			if (create && !String.isBlank(contactId) ) {
				u.ContactId = contactId;
			}  
			if(create) {
				u.Alias = u.LastName.left(4)+'1';
				u.TimeZoneSidKey = 'Europe/Amsterdam';
				u.LanguageLocaleKey = 'en_US';
				u.EmailEncodingKey = 'UTF-8';
				u.LocaleSidKey = 'en_GB';
			}
			System.debug('User.Username ' + u.Username);
			System.debug('User.FederationIdentifier ' + u.FederationIdentifier);
			System.debug('User.ProfileId ' + u.ProfileId);
			System.debug('User.Email ' + u.Email);
			System.debug('User.LastName ' + u.LastName);
			System.debug('User.FirstName ' + u.FirstName);
			System.debug('User.Nokia_ID__c ' + u.Nokia_ID__c);
			System.debug('User.ContactId ' + u.ContactId);
			
			if(!create){
				if(!Schema.sObjectType.Contact.isUpdateable()) {
					System.debug(LoggingLevel.Error, 'you don\'t have access to update User');
				} else {
					update(u);
				}
			}
			else{
				if(!Schema.sObjectType.Contact.isCreateable()) {
					System.debug(LoggingLevel.Error, 'you don\'t have access to create User');
				} else {
					insert(u);
				}				
			}
			List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
				PermissionSetAssignment psaPartner = new PermissionSetAssignment (PermissionSetId = '0PSq000000012S3GAI', AssigneeId = u.Id);
	permissionSetList.add(psaPartner);
	PermissionSetAssignment psaCustomer = new PermissionSetAssignment (PermissionSetId = '0PSq000000014dNGAQ', AssigneeId = u.Id);
	permissionSetList.add(psaCustomer);
	upsert permissionSetList;
			
		}
		
		private void handleJit(Boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
							   String federationIdentifier, Map<String, String> attributes, String assertion) {
		   String contactId = '';
		   if(communityId != null || portalId != null) {
			   
			   String accountId = handleAccount(create, u, attributes);
			   Account acct = [SELECT Id, parentId FROM Account WHERE id = :accountId];
			   String parentAccountId = acct.parentId;
			   contactId = handleContact(create, accountId, parentAccountId, u, attributes);
			   if ('Customer'=='Partner'){
					handlePArtnerUser(create, u, contactId, attributes, federationIdentifier, false);
			   }else{
					handleUser(create, u, contactId, attributes, federationIdentifier, false);
			   }
		   } else {
			   handleUser(create, u, contactId, attributes, federationIdentifier, true);
		   }
		}

		private String handleContact(Boolean create, String accountId, String parentAccountId, User u, Map<String, String> attributes){
			List<Contact> contacts;
			if(attributes.containsKey('Contact.Email')) {
				String email = attributes.get('Contact.Email');
				contacts = [SELECT Id, lastName, firstName, Email, AccountId FROM Contact WHERE id = :u.ContactId OR email = :email LIMIT 1];
			}
			else{
				contacts = [SELECT Id, lastName, firstName, Email, AccountId FROM Contact WHERE id = :u.ContactId LIMIT 1];
			}
			Contact c;
			if(contacts.isEmpty()) {  
				c = new Contact();
			}else{		   
				c = contacts[0];
			}
			
			if(contacts.isEmpty() && accountId != null && accountId != '' && parentAccountId != null && parentAccountId != '') {
				c.AccountId = parentAccountId;
			} 
			if(attributes.containsKey('Contact.FirstName')) {
				c.FirstName = attributes.get('Contact.FirstName');
			}else{
				c.FirstName = attributes.get('User.FirstName');
			} 
			if(attributes.containsKey('Contact.LastName')) {
				c.LastName = attributes.get('Contact.LastName');
			}else{
				c.LastName = attributes.get('User.LastName');
			} 
			if(attributes.containsKey('Contact.Email')) {
				c.email = attributes.get('Contact.Email');
			}   
			System.debug('create ' + create);
			System.debug('AccountId ' + accountId);
			System.debug('parentAccountId ' + parentAccountId);
			System.debug('Contact.AccountId ' + c.AccountId);
			System.debug('Contact.LastName ' + c.LastName);
			System.debug('Contact.FirstName ' + c.FirstName);
			System.debug('Contact.Email ' + c.email);
			if(contacts.isEmpty()) {
				if (!Schema.sObjectType.Contact.isCreateable()) {
					System.debug(LoggingLevel.Error, 'you don\'t have access to create Contact');
				} else {
					insert c;
					if (parentAccountId != null && parentAccountId != ''){
						AccountContactRelation acr = new AccountContactRelation();
						acr.AccountId = accountId;
						acr.ContactId = c.Id;
						acr.NCP_Entitlement_Relationship__c = True;
						insert acr;
						
					}
				}
			}else{
				if(!Schema.sObjectType.Contact.isUpdateable() ) {
					System.debug(LoggingLevel.Error, 'you don\'t have access to update Contact ');
				} else {
					update c;
				}
			}
			return c.id;
		}
		
		private String handleAccount(Boolean create, User u, Map<String, String> attributes){
			String accountId = '';
			String parentAccountId = '';
			String accountName ='';
			String accountNumber ='';
			if(attributes.containsKey('Account.Name')) {
				accountName = attributes.get('Account.Name');
			}else{
				System.debug('Account Name from Custom Settings');
				accountName = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_Account__c;
				System.debug('accountName ' + accountName);
			}	
			if(attributes.containsKey('Account.AccountNumber')) {
				accountNumber = attributes.get('Account.AccountNumber');
			}else{
				System.debug('Account Number from Custom Settings');
				accountNumber = NCP_CustomerCommunitySetting__c.getValues('Default').Customer_Account_Number__c;
				System.debug('accountNumber ' + accountNumber);
			}
			//if(create){
				Account acct = [SELECT Id, parentId FROM Account WHERE accountNumber=:accountNumber AND name = :accountName LIMIT 1];
				accountId = acct.Id;
				parentAccountId = acct.parentId;
			//}
			System.debug('create ' + create);
			System.debug('parentAccountId ' + parentAccountId);
			System.debug('accountId ' + accountId);
			System.debug('accountName ' + accountName);
			System.debug('accountNumber ' + accountNumber);   
			return accountId;
		}

		@testVisible
		global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
							   String federationIdentifier, Map<String, String> attributes, String assertion) {
		   System.debug('In createUser:'+attributes);
		   System.debug('samlSsoProviderId ' + samlSsoProviderId);
		   System.debug('communityId ' + communityId);
		   System.debug('portalId ' + portalId);
		   System.debug('federationIdentifier ' + federationIdentifier);
		   System.debug('assertion ' + assertion);
		   
		   User u = new User();
		   handleJit(true, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
		   return u;
		}
		
		global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
							   String federationIdentifier, Map<String, String> attributes, String assertion) {
		   System.debug('In UpdateUser: '+attributes);
		   System.debug('userId ' + userId);
		   System.debug('samlSsoProviderId ' + samlSsoProviderId);
		   System.debug('communityId ' + communityId);
		   System.debug('portalId ' + portalId);
		   System.debug('federationIdentifier ' + federationIdentifier);
		   System.debug('assertion ' + assertion);
		   User u1 = new User();
		   User u = [SELECT Id, contactId, isActive FROM User WHERE Id=:userId];
		   if (u.isActive){
			handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
		   }
		   else{
			handleJit(true, u1, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
		   }
	   }
	}