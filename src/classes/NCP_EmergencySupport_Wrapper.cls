/**
About
-----
Description: This wrapper class is used to represent Emergency support object in support contact in the community.

Created for: Nokia Customer Portal
Created date: 23 28 2018

Update History
--------------
Created date: 23 28 2018 – aboukrim@salesforce.com

--------------
**/

public with sharing class NCP_EmergencySupport_Wrapper {

	@auraEnabled
	public String value{ get; set; }

	@auraEnabled
	public String label{ get; set; }

	@auraEnabled
	public String contact_Label{ get; set; }

	@auraEnabled
	public String contact_email_telephone{ get; set; }

}