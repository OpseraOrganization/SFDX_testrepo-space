//Type:  Apex Controller
//Name - CH_AddMemberInTeam
//Description - This class is used to add member in case team
//Date: 12-09-2018
 
public with sharing class CH_AddMemberInTeam  
{
	// ******* Refactored *******  
  
	// Get all the workgroup members for the current workgroup 
	@AuraEnabled  
	public static CH_CaseAssignment getWorkgroupMembers(String caseId){
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		return helper.GetActiveWorkgroupMembersNoRota(caseId);
	}	
	
	// Search for workgroup members based on the search criteria entered.
	// All valid members of all found workgroups are displayed. 
	@AuraEnabled   
	public static CH_CaseAssignment searchWorkgroupMembers(String caseId, String contract, String severity, String region, String country, 
														   List<String> levelOfSupport, String customer, String customerGroup, 
														   String product, String productGroup, String outage, Boolean rota) {
																								   
		CH_CaseAssignment caseAssignmentDetails = new CH_CaseAssignment(); 
		caseAssignmentDetails.contract = contract;
		caseAssignmentDetails.severity = severity;
		caseAssignmentDetails.region = region;
		caseAssignmentDetails.country = country;
		caseAssignmentDetails.levelOfSupport = (levelOfSupport == null ? new List<string>() : levelOfSupport);
		caseAssignmentDetails.customerId = String.isBlank(Customer) ? null : Customer;
		caseAssignmentDetails.GetCustomerGroupsForCustomer();
		caseAssignmentDetails.customerGroupId = String.isBlank(CustomerGroup) ? null : CustomerGroup;
		caseAssignmentDetails.productId = String.isBlank(Product) ? null : Product;
		caseAssignmentDetails.GetProductGroupsForProduct();
		caseAssignmentDetails.productGroupId = String.isBlank(ProductGroup) ? null : ProductGroup;												 
		caseAssignmentDetails.outage = outage;
		caseAssignmentDetails.isAvailableAccordingToRota = rota;
		
		// TODO Refactor as this queury is also in DisplayWG Helper
		Case supportCase = [SELECT Id, CreatedDate, CH_SystemRestoredTargetDate__c, CH_Initial_Assignment__c,
							RecordTypeId, Status, Severity__c, Account.Region__c, Account.Country__c, CH_Reassignment__c,
							AccountId, ProductId, CH_Outage__c, NCP_Service_Contract__r.Name, BusinessHoursId, CH_SystemRestored__c 
							FROM Case 
							WHERE Id =:caseId];													   
															   
		caseAssignmentDetails.supportCase = supportCase;
															   
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();													   
		caseAssignmentDetails = helper.GetWorkgroupMembersAllMatchingRules(caseAssignmentDetails);													   
															   
		return caseAssignmentDetails;
	}	
	
	// Add a new member to the case team
	// UserId = id of the user to add
	// CaseId = Id of the case where the user is added to the case team
	// memberSelectedRole = role that the user will get in the case team
	@AuraEnabled	
	public static void InsertMember(Id UserId, Id caseId, String memberSelectedRole){
		
		// Get the Id of the selected role
		// **** TODO Refactor. The list in the UI is hardcoded and needs to be made dynamic and then the Id is 
		// already known. Error if the role is not setup.		
		CaseTeamRole caseTeamRole = [SELECT Id FROM CaseTeamRole WHERE Name = :memberSelectedRole LIMIT 1];
		CaseTeamMember newCaseTeamMember = new CaseTeamMember();
		newCaseTeamMember.ParentId = caseId;
		newCaseTeamMember.MemberId = UserId;
		newCaseTeamMember.TeamRoleId = caseTeamRole.Id;
		insert newCaseTeamMember;
		
		// Create a task for the new teammember
		Task memeberTask = new Task();
		if(memberSelectedRole == 'Incident Engineer'){
			memeberTask.WhatId = caseId;
			memeberTask.OwnerId = UserId;
			memeberTask.Subject = 'Troubleshoot';
			memeberTask.Status = 'Open';
			memeberTask.Priority = 'Normal';
			insert memeberTask;
		}
		if(memberSelectedRole == 'Incident Expert'){
			memeberTask.WhatId = caseId;
			memeberTask.OwnerId = UserId;
			memeberTask.Subject = 'Assistance';
			memeberTask.Status = 'Open';
			memeberTask.Priority = 'Normal';
			insert memeberTask;
		}
		if(memberSelectedRole == 'Incident Support'){
			memeberTask.WhatId = caseId;
			memeberTask.OwnerId = UserId;
			memeberTask.Subject = 'Collaboration';
			memeberTask.Status = 'Open';
			memeberTask.Priority = 'Normal';
			insert memeberTask;
		}
	}
	
	
	// ******* Refactored *******

	
	//Description - This method is used for holding values of dependent picklist.
	@AuraEnabled 
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) 
	{
		String controllingField = contrfieldApiName.toLowerCase();
		String dependentField = depfieldApiName.toLowerCase();
		Map<String,List<String>> objResults = new Map<String,List<String>>();
		Schema.sObjectType objType = objDetail.getSObjectType();
		if (objType==null){
			return objResults;
		}
		Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
		
		if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
			return objResults;	 
		}
		Schema.SObjectField theField = objFieldMap.get(dependentField);
		Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
		
		List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
		List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
		List<String> controllingValues = new List<String>();
		
		for (Schema.PicklistEntry ple : contrEntries) {
			String label = ple.getLabel();
			objResults.put(label, new List<String>());
			controllingValues.add(label);
		}
		for (PicklistEntryWrapper plew : depEntries) {
			String label = plew.label;
			String validForBits = base64ToBits(plew.validFor);
			for (Integer i = 0; i < validForBits.length(); i++) {
				String bit = validForBits.mid(i, 1);
				if (bit == '1') {
					objResults.get(controllingValues.get(i)).add(label);
				}
			}
		}
		return objResults;
	}
	
	//Description - This method is internal method of getDependentMap.
	public static String base64ToBits(String validFor) 
	{
		if (String.isEmpty(validFor)) return '';
		
		String validForBits = '';
		
		for (Integer i = 0; i < validFor.length(); i++) {
			String thisChar = validFor.mid(i, 1);
			Integer val = base64Chars.indexOf(thisChar);
			String bits = decimalToBinary(val).leftPad(6, '0');
			validForBits += bits;
		}
		return validForBits;
	}

	//Description - This method is internal method of base64ToBits.
	public static String decimalToBinary(Integer val) 
	{
		String bits = '';
		while (val > 0) {
			Integer remainder = Math.mod(val, 2);
			val = Integer.valueOf(Math.floor(val / 2));
			bits = String.valueOf(remainder) + bits;
		}
		return bits;
	}	
	private static final String base64Chars = '' +
		'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
		'abcdefghijklmnopqrstuvwxyz' +
		'0123456789+/';

	//Description - This method is used for wrapping picklist values.
	private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) 
	{
		return (List<PicklistEntryWrapper>)
			JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
	}
	
	public class PicklistEntryWrapper
	{
		public String active {get;set;}
		public String defaultValue {get;set;}
		public String label {get;set;}
		public String value {get;set;}
		public String validFor {get;set;}
		public PicklistEntryWrapper(){			
		}
	}
}