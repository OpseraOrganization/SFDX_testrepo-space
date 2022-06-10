/****************************************
* Class Name : CH_CreateCaseController
* Created Date: 19 Feb 2019
* Created By : Mahati Krishna (mahatikrishna.chitta@tcs.com)
* Last Modified by: Suman Samaddar
* Last Modified Date: 21-Aug-2020
* Description : Case creation button action and visibility 
* Test Class: CH_CreateCaseControllerTest
*****************************************/
public with sharing class CH_CreateCaseController {
	/********************
	* Method Name: checkCreateCaseButtonVisibility
	* Parameter: Id contactId
	* Description: Used to Checks object level access of case and contact status 'Active' for button visibility
	* Reference: NOKIASC-15495
	*******************/
	@AuraEnabled
	public static String checkCreateCaseButtonVisibility(Id contactId) {
		// Check Object access method have been referred from CH_CaseFlow_Controller as per NOKIASC-31960
		String message = CH_CaseFlow_Controller.checkObjectAccess('Case', new String[] {'Create'});
		// Return blank if message is null as well
		if(String.isBlank(message)) {
			message = '';
		}
		return message;
	}
	
	/********************
	* Method Name: checkBulkUploadPermission
	* Parameter: 
	* Description: Check if user has bulk upload permission from console
	* Reference: NOKIASC-37118:Check if user has bulk upload permission
	*******************/
	@AuraEnabled
	public static Boolean checkBulkUploadPermission( ) {
		return FeatureManagement.checkPermission('HWS_Enable_Bulk_Case_Creation');
	}
	/********************
	* Method Name: redirectToCreateCaseFlow
	* Parameter: Id contactId
	* Description: Used to Checks condition for case creation
	* Reference: NOKIASC-15083
	*******************/
	@AuraEnabled
	public static String redirectToCreateCaseFlow(Id contactId, String serviceType ) {
		String message = '';
		Contact contactObj = [SELECT Id, Contact_Status__c, MobilePhone,CH_Legal_Entity_Name__c, Phone, Email FROM Contact WHERE Id=: contactId];
		
		//NOKIASC-37154
		List<PermissionSetAssignment> retrofitCoordinatorEmails = [SELECT Assignee.Email FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'HWS_RetrofitCoordinator' LIMIT 1];
		if(retrofitCoordinatorEmails.size() > 0 && retrofitCoordinatorEmails.get(0).Assignee.Email != contactObj.Email){		 
			message = 'You are not authorized to create a case for another Contact.  Please select your own Contact record to begin case creation';
			return message;  
		}
		//NOKIASC-37154
		
		if(contactObj != null) {
			if ((contactObj.MobilePhone != null || contactObj.Phone != null) && contactObj.CH_Legal_Entity_Name__c != null && contactObj.Contact_Status__c == 'Active') {
	message = redirectBasedOnServiceType(serviceType, contactId) ;
			} else {
				// Check Object access method have been referred from CH_CaseFlow_Controller as per NOKIASC-31960
	String ObjectAccess = CH_CaseFlow_Controller.checkObjectAccess('Contact', new String[] {'Edit'});
	String RecordAccess = checkRecordLevelAccess(contactId);
	
	Map < String, String > fieldLevelAccessMap =  checkFieldAccess('Contact', new Map < String, String > {'Contact_Status__c' => 'Edit' ,'CH_Legal_Entity_Name__c' => 'Edit', 'MobilePhone' => 'Edit', 'Phone' => 'Edit' });	 
	
	if (contactObj.Contact_Status__c != 'Active') {
		if(String.isBlank(ObjectAccess) && String.isBlank(fieldLevelAccessMap.get('Contact_Status__c')) && String.isBlank(RecordAccess)) {
			message = System.label.CH_NewCaseButton_ContactNotActive +'\n'; 
		} else {
			message = 'Kindly Contact system administrator to ' + System.label.CH_NewCaseButton_ContactNotActive +'\n';
		}	 
	}
	// If legal entity is blank through a message
	if (contactObj.CH_Legal_Entity_Name__c == null) {	
		if(String.isBlank(ObjectAccess) && String.isBlank(fieldLevelAccessMap.get('CH_Legal_Entity_Name__c')) && String.isBlank(RecordAccess)) {
			message += System.label.CH_NewCaseButton_LegalEntityMissing +'\n'; 
		} else {
			message += 'Kindly Contact system administrator to ' + System.label.CH_NewCaseButton_LegalEntityMissing +'\n';
		}
	}
	// If mobile or phone is blank through a message
	if (contactObj.MobilePhone == null && contactObj.Phone == null) {
		if(String.isBlank(ObjectAccess) && String.isBlank(fieldLevelAccessMap.get('MobilePhone')) && String.isBlank(fieldLevelAccessMap.get('Phone')) && String.isBlank(RecordAccess)) {
			message += System.label.CH_NewCaseButton_Missingphone;
		} else {
			if (String.isBlank(message)) {
				message = 'contactDetails';
			} else {
				message += '';
			}			
		}
	}
			} 
		} else{
			message = 'This message does not make sense. No Contact Record found'; 
		}
		return message;
	}
	/********************
	* Method Name: checkFieldAccess
	* Parameter: String sObjectName, Map < String, String > fieldMap
	* Description: Used to check access of fields with provided access level
	* Reference: NOKIASC-15495/15083
	*******************/
	public static Map < String, String > checkFieldAccess(String sObjectName, Map < String, String > fieldMap) {
		Map < String, String > fieldAccessmap = new Map < String, String > ();
		SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
		Map < String, Schema.SObjectField > schemaFieldMap = sObjectType.getDescribe().fields.getMap();
		for (String fieldApiName : fieldMap.keySet()) {
			if(schemaFieldMap.get(fieldApiName) != null) {
	if(fieldMap.get(fieldApiName) == 'Read' && !schemaFieldMap.get(fieldApiName).getDescribe().isAccessible()) {
		
		 fieldAccessmap.put(fieldApiName, 'No Read Access for field');
	} else if(fieldMap.get(fieldApiName) == 'Edit' && !schemaFieldMap.get(fieldApiName).getDescribe().isUpdateable()) {
		
		fieldAccessmap.put(fieldApiName, 'No Edit Access for field');
	} else {
		
		fieldAccessmap.put(fieldApiName, '');
	}
			}	
		}	  
		return fieldAccessmap;
	}

	
	/********************
	* Method Name: getPickListValuesBasedOnContactType
	* Parameter: string ObjectName, string fieldName
	* Description: Used to get the picklist values based on input paramters
	* Reference: NOKIASC-15458
	*******************/
	@AuraEnabled
	public static List < String > getPickListValuesBasedOnContactType(Id contactId) {   
		Set < String > picklistValues = new Set < String > ();
		if(String.isNotBlank(contactId)) {
			Contact contactObj = [SELECT Id, Contact_Status__c, CH_ContactType__c FROM Contact WHERE Id=: contactId];
		
			if(contactObj.CH_ContactType__c != 'None') {
	String contactType = contactObj.CH_ContactType__c;
	picklistValues = getCustomSettingData(contactType);
			}
		}
		return (new List < String > (picklistValues));
	}
	
	/********************
	* Method Name: getCustomSettingData
	* Parameter: string ContactType
	* Description: Used to get custom data values
	* Reference: NOKIASC-15458
	*******************/	
	public static Set < String > getCustomSettingData(String ContactType) { 
		Set < String > picklistValues = new Set < String > ();
		if(String.isNotEmpty(ContactType)) {			
			for(CH_ServiceTypeData__c ServiceTypeData : [SELECT CH_ServiceType__c FROM CH_ServiceTypeData__c WHERE CH_ContactType__c = :ContactType]) {
	picklistValues.add(ServiceTypeData.CH_ServiceType__c);
			}
		}
		return picklistValues;		
	}
	
	public static final String LEGAL_ENTITY_REC_TYPE = 'Legal_Entity';
	
	/********************
	* Method Name: updateContactDetails
	* Parameter: Integer mobile, Integer phone, string contactId
	* Description: Used to send email for updating contact details
	* Reference: NOKIASC- 16337,29418
	*******************/ 
	@AuraEnabled
	public static String updateContactDetails(String mobile, String phone, Id contactId){   
		String message = '';
		if ( mobile != null || phone != null ) {
			if ( contactId != null ) {
	
	Contact contactObj = [SELECT Id,Name, AccountId, Account.Name, Account.Country__c FROM Contact WHERE Id =: contactId];  
	  
	
					
				 
				//**NEW CODE BLOCK as per : NOKIASC-29418**//
				string  toAdd= System.label.CH_ContactMissingEmail;
				CH_EmailAlert__c createEmail=new CH_EmailAlert__c();
				createEmail.CH_Bind1__c=contactObj.Name;
				createEmail.CH_Bind2__c=contactObj.Account.Name;
				createEmail.CH_Bind15__c=toAdd;
			   
				createEmail.CH_EmailAlertName__c='Update contact details Alert';
				createEmail.CH_Bind3__c=contactObj.Account.Country__c;
				createEmail.CH_Bind4__c=string.valueof(mobile);
				createEmail.CH_Bind5__c=string.valueof(phone);
				createEmail.CH_Bind14__c=URL.getSalesforceBaseUrl().toExternalForm() + '/' + contactObj.id ;
				createEmail.CH_Bind6__c='Update contact details';
				insert createEmail;	
					
	message = 'sendMail';
			}else{
	message = 'Invalid Contact Id';
			}   
			
		} else {
			message = 'Invalid Phone/Mobile No';
		}		
		return message;
	}
	
	/********************
	* Method Name: redirectBasedOnServiceType
	* Parameter: String serviceType, Id contactId
	* Description: Used to separate the case creation based on service type
	* Reference: NOKIASC-16406
	*******************/ 
	
	public static String redirectBasedOnServiceType(String serviceType, Id contactId){ 
		
		String message = '';
		if (contactId != null){
			Contact contactObj = [SELECT CH_ContactType__c FROM Contact WHERE Id =: contactId];
			if (serviceType != null && contactObj != null ) {
	if ( serviceType == 'Customer Support' || serviceType == 'Internal Support' ) {
		
		message = '';
		return message;
	// HWS - Start	
	// Modified as partof HWS HWST-3196 & 3198 user stories Sprint 1917	
	} else if ( serviceType == 'Hardware Services') {	
		message = '';	
	// HWS - End
	} else {
		message = 'Case cannot be created for this service type';
	}
			} else{
	message = 'Not valid service type';
			} 
		}		
		return message;
	}
	
	/********************
	* Method Name: checkRecordLevelAccess
	* Parameter: Id objectID
	* Description: TO check the record level access
	* Reference: NOKIASC-16337
	*******************/ 
	
	public static String checkRecordLevelAccess(Id objectID){ 
		String message = '';
		if (objectID != null){
		UserRecordAccess recordAccess =  [SELECT RecordId  ,HasEditAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId() AND RecordId =: objectID Limit 1];
			if(recordAccess != null && recordAccess.HasEditAccess){
	  message = ''; 
			} else {
	message = 'Does not have edit access over record for this user';
			}	 
		}  
		return message;
	}	
}