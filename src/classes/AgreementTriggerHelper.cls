/**
 * About
 * -----
 * @Description : This helper is written for the Trigger of Apttus Agreement Object
 * @TestClass : DS_ProposalControllerTest.
 * @Project : Digital Sales, QTO, CLM
 * @Modification Log :
 *  Created  : - Accenture
 *  Modified : 2020.11.17 - gyorgyi.kovacs@nokia.com
 * -----
**/
public without sharing class AgreementTriggerHelper {

	private static integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
	private static List<String> categories = new List<String> {'HW', 'SW', 'Services'};

	/**
	* @description: This method is used to validate if all the mandatory fields on agreement are filled or not
	* @param: List of current record Ids of Apttus Agreement
	*/
	public static void checkMandatoryFields(List<Apttus__APTS_Agreement__c> newAgreements) {
		try {
			//get the mandatordy fields by ERP types
			Map<String,String> mandatoryFieldsERPMap = getMandatoryFields();
			if (!newAgreements.isEmpty()) {
	//Below for loop iterate through the Agreement records and checks for the empty values for the Required fields.
	for (Apttus__APTS_Agreement__c a : newAgreements) {
		if (!String.isEmpty(a.ERP__c)) {
			List<String> mandatoryFields = mandatoryFieldsERPMap.get(a.ERP__c).split(CSWXGlobalConstant.comma);
			List<String> missingFieldsLabels = new List<String>();
			for (String field : mandatoryFields) {
	System.debug('field >>>>' + field);
	String fieldLabel = Schema.getGlobalDescribe().get(CSWXGlobalConstant.OBJECT_Agreement).getDescribe().fields.getMap().get(field).getDescribe().getLabel();
	if (a.get(field) == null || a.get(field) == false) {
		missingFieldsLabels.add(fieldLabel);
	}
			}
			System.debug('missingFieldsLabels >>>>' + JSON.serialize(missingFieldsLabels));
			if (missingFieldsLabels.size() > 0) {
	a.addError(CSWXGlobalConstant.mandatoryFieldsAgreementErrorMsg + String.join(missingFieldsLabels, ', '));
			}
		}
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, CSWXGlobalConstant.AgreementTriggerHelper, CSWXGlobalConstant.checkMandatoryFields);
		}
	}

	/**
	* @description: Method to get Agreement fields
	* @return: Map<String, String> ERP, Comma separated list of mandatory fields
	*/
	public static Map<String,String> getMandatoryFields() {
		try {
			Map<String,String> mandatoryFieldsERPMap = new Map<String,String>();
			for (DS_Agreement_Validation__c av : [SELECT Name, ERP__c, Agreement_MandatoryFields__c, Agreement_MandatoryFields2__c, Agreement_MandatoryFields3__c
	FROM DS_Agreement_Validation__c
	WHERE Name != null LIMIT :limitRows] ) {
	String mandatoryFields = CSWXGlobalConstant.EMPTY_STRING;
	if (av.Agreement_MandatoryFields3__c != null) {
		mandatoryFields =  av.Agreement_MandatoryFields__c + CSWXGlobalConstant.comma + av.Agreement_MandatoryFields2__c + CSWXGlobalConstant.comma + av.Agreement_MandatoryFields3__c;
	} else {
		mandatoryFields =  av.Agreement_MandatoryFields__c + CSWXGlobalConstant.comma + av.Agreement_MandatoryFields2__c;
	}
	mandatoryFieldsERPMap.put(av.ERP__c, mandatoryFields);
			}
			system.debug('mandatoryFieldsERPMap>>>>>>>>>' + mandatoryFieldsERPMap);
			return mandatoryFieldsERPMap;
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, CSWXGlobalConstant.AgreementTriggerHelper, CSWXGlobalConstant.getAgreementFields);
		}
		return null;
	}

	/**
	* @description: Method to copy values to Agreement fields from related Opportunity and Opportunity Team Members upon Apttus Agreement creation
	* @param: List<Apttus__APTS_Agreement__c> List of newly created Apttus Agreement records
	*/
	public static void populateFieldsForNewAgreement(List<Apttus__APTS_Agreement__c> agreements) { /* DSI-1857 */
		//initial check on parameters
		if (agreements == null || agreements.isEmpty()) {
			IllegalArgumentException e = new IllegalArgumentException();
			e.setMessage('Illegal argument!');
			throw e;
		}

		// Newly created Agreement case, all Opportunities fetched to opportunities map
		Set<Id> oppSet = new Set<Id>();
			for (Apttus__APTS_Agreement__c a : agreements) {
	oppSet.add(a.Apttus__Related_Opportunity__c);
			}

		Map<Id, Opportunity> opportunities = new Map<Id, Opportunity>();
		try {
			for (Opportunity o : [SELECT Id, RecordType.Name, Description, Lead_BG__c, Amount, Account_Role__c, End_Customer__c, Indirect_Reseller_Account__c,End_Customer_LE__c,Legal_Entity__c,
	(SELECT UserId, TeamMemberRole FROM OpportunityTeamMembers)
	FROM Opportunity
	WHERE Id = :oppSet
	WITH SECURITY_ENFORCED
	LIMIT :limitRows]) {
	opportunities.put(o.Id, o);
			}

			for (Apttus__APTS_Agreement__c agreement : agreements) {
	copyOpportunityFieldsToAgreement(agreement, opportunities.get(agreement.Apttus__Related_Opportunity__c));
	copyOTMFieldsToAgreement(agreement, opportunities.get(agreement.Apttus__Related_Opportunity__c).OpportunityTeamMembers);
			}
		} catch (Exception e) {
			ExceptionHandler.addException(e, CSWXGlobalConstant.AgreementTriggerHelper, 'populateFieldsForNewAgreement');
		}
	}

	/**
	* @description: Method to create Agreement Invoicing Milestone records for the newly created agreements
	* @param: List<Apttus__APTS_Agreement__c> list of newly created Apttus Agreement records
	*/
	public static void createMilestones(List<Apttus__APTS_Agreement__c> agreements) { /* DSI-1857 */
		//initial check on parameters
		if (agreements == null || agreements.isEmpty()) {
			IllegalArgumentException e = new IllegalArgumentException();
			e.setMessage('Illegal argument!');
			throw e;
		}

		List<CLM_Agreement_Invoicing_Milestone__c> aims = new List<CLM_Agreement_Invoicing_Milestone__c>();
		for (Apttus__APTS_Agreement__c a : agreements) {
			for (String category : categories) {
	CLM_Agreement_Invoicing_Milestone__c aim = new CLM_Agreement_Invoicing_Milestone__c();
	aim.Agreement__c = a.Id;
	aim.Category__c = category;
	aims.add(aim);
			}
		}

		if (CLM_Agreement_Invoicing_Milestone__c.sObjectType.getDescribe().isCreateable()) {
			insert aims;
		}
	}

	/**
	* @description: Method to copy values to Agreement fields from related Opportunity
	* @param: Apttus__APTS_Agreement__c newly created Apttus Agreement record
	* @param: Opportunity related Opportunity record
	*/
	private static void copyOpportunityFieldsToAgreement(Apttus__APTS_Agreement__c a, Opportunity o) { /* DSI-1857 */
		// for new Agreements all the necessary fields are copied without checking
		string recordTypeName = Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosById().get(a.RecordTypeId).getName();
		List<string> eligibleRT = CLM_GlobalConstants.agreementRecordTypeNames;
		a.Lead_BG__c = o.Lead_BG__c;
		a.Apttus__Description__c = o.Description;
		a.Apttus__Total_Contract_Value__c = o.Amount;

		a.Apttus_CMConfig__ShipToAccountId__c = a.Apttus__Account__c;
		a.Apttus_CMConfig__BillToAccountId__c = a.Apttus__Account__c;
		a.Payer__c = a.Apttus__Account__c;
		// in case of Indirect Opportunity
		if (o.RecordType.Name == CSWXGlobalConstant.indirectOppty) {
			a.Account_Role__c = o.Account_Role__c;
			a.End_Customer__c = eligibleRT.contains(recordTypeName) ? o.End_Customer_LE__c : o.End_Customer__c;
			a.Indirect_Reseller_Account__c = o.Indirect_Reseller_Account__c;
		} else if(o.RecordType.Name == CSWXGlobalConstant.directOppty){
			a.End_Customer__c = eligibleRT.contains(recordTypeName) ? o.Legal_Entity__c : a.Apttus__Account__c;
		}else{
		   a.End_Customer__c = a.Apttus__Account__c; 
		}
	}

	/**
	* @description: Method to copy values to Agreement fields from related Opportunity Team Members
	* @param: Apttus__APTS_Agreement__c newly created Apttus Agreement record
	* @param: List<OpportunityTeamMember> related Opportunity Team Member records
	*/
	private static void copyOTMFieldsToAgreement(Apttus__APTS_Agreement__c a, List<OpportunityTeamMember> otms) { /* DSI-1857 */
		// AM, CCM, PCM and CDM filled
		OTMFound otmFound = new OTMFound();
		for (OpportunityTeamMember otm : otms) {
			switch on otm.TeamMemberRole {
	when 'Account Manager (TRICORN Sales Case Owner (SCO))' {
		// first Account Manager TRICORN is used
		if (!otmFound.isAMTricornFound) {
			a.Account_Manager__c = otm.UserId;
			otmFound.isAMTricornFound = true;
		}
	}
	when 'Account Manager' {
		// first Account Manager is used as long as no AM Tricorn is found (yet)
		if (!otmFound.isAMTricornFound && !otmFound.isAMFound) {
			a.Account_Manager__c = otm.UserId;
			otmFound.isAMFound = true;
		}
	}
	when 'Commercial Contract Manager and Legal' {
		// first Commercial Contract Manager is used
		if (!otmFound.isCCMFound) {
			a.Commercial_Contract_Manager__c = otm.UserId;
			otmFound.isCCMFound = true;
		}
	}
	when 'Project Contract Manager' {
		// first Project Contract Manager is used
		if (!otmFound.isPCMFound) {
			a.Project_Contract_Manager__c = otm.UserId;
			otmFound.isPCMFound = true;
		}
	}
	when 'One Customer Delivery Manager' {
		// first Customer Delivery Manager is used
		if (!otmFound.isCDMFound) {
			a.Customer_Delivery_Manager__c = otm.UserId;
			otmFound.isCDMFound = true;
		}
	}
			}
		}
	}

	/**
	* @description: Method to update Agreement fields upon Opportunity change if not changed manually before
	* @param: Map<Id, Opportunity> Map of old Opportunity records
	* @param: Map<Id, Opportunity> Map of current Opportunity records
	*/
	public static void updateAgreementFieldsOnOpportunityChange(Map<Id, Opportunity> oldOpps, Map<Id, Opportunity> newOpps) { /* DSI-1857 */
		// initial check on parameters
		if (newOpps == null || newOpps.isEmpty() || oldOpps == null || oldOpps.isEmpty()) {
			IllegalArgumentException e = new IllegalArgumentException();
			e.setMessage('Illegal argument!');
			throw e;
		}

		//copying logic shall start only if there is at least one record where any of the needed fields are changed.
		List<Id> oppIdList = new List<Id>();
		for (Id key : oldOpps.keySet()) {
			if (oldOpps.get(key).Description != newOpps.get(key).Description || oldOpps.get(key).Amount != newOpps.get(key).Amount) {
	oppIdList.add(key);
			}
		}

		if (!oppIdList.isEmpty()) {
			try {
	// all the related Agreements fetched to agreements
	List<Apttus__APTS_Agreement__c> agreements = [SELECT Apttus__Related_Opportunity__c, Apttus__Description__c, Apttus__Total_Contract_Value__c
		FROM Apttus__APTS_Agreement__c
		WHERE Apttus__Related_Opportunity__c = : oppIdList
		WITH SECURITY_ENFORCED
		LIMIT :limitRows];

	if (!agreements.isEmpty()) {

		for (Apttus__APTS_Agreement__c a : agreements) {
			if (newOpps.containsKey(a.Apttus__Related_Opportunity__c)) {
	Opportunity newOpty = newOpps.get(a.Apttus__Related_Opportunity__c);
	Opportunity oldOpty = oldOpps.get(a.Apttus__Related_Opportunity__c);

	// old values are compared and changed only when Agreement value was not changed manually before
	if (oldOpty.Description == a.Apttus__Description__c) {
		a.Apttus__Description__c = newOpty.Description;
	}
	if (oldOpty.Amount == a.Apttus__Total_Contract_Value__c) {
		a.Apttus__Total_Contract_Value__c = newOpty.Amount;
	}
			}
		}
		if (Schema.sObjectType.Apttus__APTS_Agreement__c.fields.Apttus__Description__c.isUpdateable() && Schema.sObjectType.Apttus__APTS_Agreement__c.fields.Apttus__Total_Contract_Value__c.isUpdateable()) {
			update agreements;
		}
	} else {
		System.debug('No Agreement records found!');
	}
			} catch (Exception e) {
	ExceptionHandler.addException(e, CSWXGlobalConstant.AgreementTriggerHelper, 'updateAgreementFieldsOnOpportunityChange');
			}
		} else {
			System.debug('No Agreement related change found in received Opportunities');
		}
	}

	/* Auxiliary class to store flags for already found records */
	private class OTMFound { /* DSI-1857 */
		public Boolean isAMFound;
		public Boolean isAMTricornFound;
		public Boolean isCCMFound;
		public Boolean isPCMFound;
		public Boolean isCDMFound;

		public OTMFound() {
			isAMFound = false;
			isAMTricornFound = false;
			isCCMFound = false;
			isPCMFound = false;
			isCDMFound = false;
		}

	}

	
}