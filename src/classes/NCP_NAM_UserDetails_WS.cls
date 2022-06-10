/**
 * Created by bkandov on 22/05/2018.
 */

global with sharing class NCP_NAM_UserDetails_WS {

	static final String NOT_AVAILABLE = 'Not Available';

	global class NCP_NAM_UserDetails {

		webservice String Username { get; set; }
		webservice String FederationIdentifier { get; set; }
		webservice String requestId { get; set; }
		webservice Boolean IsActive { get; set; }
		webservice String NokiaID { get; set; }
		webservice String Email { get; set; }
		webservice String MobilePhone { get; set; }
		webservice String LastName { get; set; }
		webservice String FirstName { get; set; }
		webservice String NCPRelationship { get; set; }
		webservice String NCPHRID { get; set; }
		webservice String Phone { get; set; }
		webservice String NCPSSOPID { get; set; }
		webservice String Country { get; set; }
		webservice String NCPApprovalStatus { get; set; }
		webservice String NCPNSNID { get; set; }
		webservice Boolean NCPIsHorizontal { get; set; }
		webservice String Street { get; set; }
		webservice String City { get; set; }
		webservice String State { get; set; }
		webservice String PostalCode { get; set; }
		webservice String NCPHorizontalCompanyName { get; set; }
		webservice NCP_NAM_ContactDetails UserContact { get; set; }


		public NCP_NAM_UserDetails() {
			this.UserContact = new NCP_NAM_ContactDetails();
		}

		public void updateUserDetails() {

			try {

	if (String.isBlank(this.FederationIdentifier)) {
		CalloutException e = new CalloutException();
		e.setMessage('FederationIdentifier is missing');
		throw e;
	}

	System.debug('FederationIdentifier >> ' + this.FederationIdentifier);

	List<User> users = [
			SELECT Id,ContactId,FederationIdentifier
			FROM User
			WHERE FederationIdentifier = :this.FederationIdentifier
			LIMIT 1
	];

	if (users.size() == 0) {
		CalloutException e = new CalloutException();
		e.setMessage('User not exists');
		throw e;
	}

	User user = users[0];

//	if (String.isNotBlank(this.Username)) {
//		user.Username = this.Username;
//	}

	if (String.isNotBlank(this.FederationIdentifier)) {
		user.FederationIdentifier = this.FederationIdentifier;
	}

	if (this.IsActive != null) {
		user.IsActive = this.IsActive;
	}
	if (this.IsActive == false) {
		user.IsActive = false;
	}

	if (this.NokiaID != null) {
		user.NokiaUID__c = this.NokiaID;
	}
	if (this.Email != null) {
		user.Email = this.Email;
		user.Username = NCP_Utils.getUsername(this.Email);
	}
	if (this.MobilePhone != null) {
		user.MobilePhone = this.MobilePhone;
	}
	if (this.LastName != null) {
		user.LastName = this.LastName;
	}
	if (this.FirstName != null) {
		user.FirstName = this.FirstName;
	}
	if (this.NCPRelationship != null) {
		user.NCP_Relationship__c = this.NCPRelationship;
	}
	if (this.NCPHRID != null) {
		user.NCP_HR_ID__c = this.NCPHRID;
	}
	if (this.Phone != null) {
		user.Phone = this.Phone;
	}
	if (this.NCPSSOPID != null) {
		user.NCP_SSOPID__c = this.NCPSSOPID;
	}
	if (this.City != null) {
		user.City = this.City ;
	}
	if (this.Street != null) {
		user.Street = this.Street;
	}
	if (this.Country != null) {
		user.CountryCode = this.Country;
	}
	if (this.PostalCode != null) {
		user.PostalCode = this.PostalCode;
	}
	if (this.State != null) {
		if (this.State == NOT_AVAILABLE){
			user.State = '';
		}else {
			user.State = this.State;
		}
	}
	if (this.NCPApprovalStatus != null) {
		user.NCP_Approval_Status__c = this.NCPApprovalStatus;
	}
	if (this.NCPNSNID != null) {
		user.NCP_NSN_ID__c = this.NCPNSNID;
	}
	if (this.NCPHorizontalCompanyName != null) {
		user.NCP_Horizontal_Company_Name__c = this.NCPHorizontalCompanyName;
	}
	if (this.NCPIsHorizontal != null) {
		user.NCP_IsHorizontal__c = this.NCPIsHorizontal;
	}


	update user;

	if (UserContact != null && String.isBlank(user.ContactId) == false) {
		UserContact.updateContactDetails(user.ContactId);
	}

			} catch (Exception ex) {
	throw ex;
			}
		}
	}
	
	
	global class NCP_NAM_ContactDetails {

		webservice String FirstName { get; set; }
		webservice String LastName { get; set; }
		webservice String Email { get; set; }
		webservice String EmailChangeSource { get; set; }
		webservice String MobilePhone { get; set; }
		webservice String City { get; set; }
		webservice String Street { get; set; }
		webservice String State { get; set; }
		webservice String Country { get; set; }
		webservice String PostalCode { get; set; }
		webservice String Phone { get; set; }

		public void updateContactDetails(String contactId) {

			try {

	//Contact contact = new Contact(Id = contactId, CH_ContactType__c = 'Customer');
	Contact contact = new Contact(Id = contactId);
	if (this.FirstName != null) {
		contact.FirstName = this.FirstName;
	}
	if (this.LastName != null) {
		contact.LastName = this.LastName;
	}
	if (this.Email != null) {
		contact.Email = this.Email;
	}
	if (this.EmailChangeSource != null) {
		contact.Email_Change_Source__c = this.EmailChangeSource;
	}
	if (this.MobilePhone != null) {
		contact.MobilePhone = this.MobilePhone;
	}
	if (this.State != null) {
		if (this.State == NOT_AVAILABLE){
			contact.MailingState = '';
		}else {
			contact.MailingState = this.State;
		}
	}
	if (this.City != null) {
		contact.MailingCity = this.City;
	}
	if (this.Street != null) {
		contact.MailingStreet = this.Street;
	}
	if (this.Country != null) {
		contact.MailingCountryCode = this.Country;
		contact.Market__c = ISO_Country_Codes__c.getvalues(contact.mailingCountryCode).Market__c;
	}
	if (this.PostalCode != null) {
		contact.MailingPostalCode = this.PostalCode;
	}
	if (this.Phone != null) {
		contact.Phone = this.Phone;
	}

	update contact;

			} catch (Exception ex) {
	System.debug('NCP_NAM_UserDetailsService :: updateUserDetails >> ' + ex.getMessage());
	throw ex;
			}
		}

	}

	global class ResponseParams {
		webservice Integer Status { get; set; }
		webservice String Message { get; set; }
		webService String requestId { get; set; }

		global ResponseParams(Integer Status, String Message, String requestId) {
			this.Status = Status;
			this.Message = Message;
			this.requestId = requestId;
		}
	}

	/**
	 * Update ONE User and Contact Details
	 *
	 * @param userDetails - data that will update Salesforce User and Related Contact
	 *
	 * @return
	 */
	webservice static ResponseParams updateUserDetails(NCP_NAM_UserDetails userDetails) {

		try {

			userDetails.updateUserDetails();
			NCP_InterfaceLog.insertInterfaceLog('NAM User Details', 'Inbound', 'Update', 'NAM Integration', 'Success', 'User updated successfully', '' + userDetails);
			// update contact
		} catch (Exception ex) {
			NCP_InterfaceLog.insertInterfaceLog('NAM User Details', 'Inbound', 'Update', 'NAM Integration', 'Failure', ex.getMessage(), '' + userDetails);
			System.debug('NCP_NAM_UserDetailsService :: updateUserDetails >> ' + ex.getMessage());
			return new ResponseParams(400, 'An error occurred while updating user: ' + ex.getMessage(), userDetails.requestId);
		}

		return new ResponseParams(201, 'User updated successfully', userDetails.requestId);
	}

	/**
	 * Update List of Users and Contacts Details
	 *
	 * @param usersDetails - data that will update Salesforce Users and Related Contacts
	 *
	 * @return
	 */
//	webservice static ResponseParams updateUsersDetails(List<NCP_NAM_UserDetails> usersDetails) {
//
//		List<String> errors = new List<String>();
//
//		for (NCP_NAM_UserDetails userDetails : usersDetails) {
//
//			try {
//	userDetails.updateUserDetails();
//
//			} catch (Exception ex) {
//	System.debug('NCP_NAM_UserDetailsService :: updateUsersDetails >> ' + ex.getMessage());
//	errors.add('An error occurred while updating User: ' + userDetails.FirstName + ' ' + userDetails.LastName + ' :: ' + ex.getMessage());
//			}
//		}
//
//		if (errors.size() > 0) {
//			return new ResponseParams(400, String.join(errors, ' , '));
//		}
//
//		return new ResponseParams(201, 'Users updated successfully');
//	}

}