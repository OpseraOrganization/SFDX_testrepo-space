/******************************************************************************************************
Name : CustomerDocumentTriggerHelperTest
Created Date: 7 July 2019
Created by: Accenture
Modified by: Györgyi Kovács, Nokia
Description : This class is test class for CustomerDocumentTrigger
*********************************************************************************************************/
@isTest
public class CustomerDocumentTriggerHelperTest {
	
	
	public static final String STATUS_CLOSED_REJECTED = 'Closed-rejected';
	public static final String CLASSIFICATION_STANDARD_PO = 'Purchase Order';
	public static final String SUBCLASSIFICATION_QUOTE_BASED = 'Standard';
	
	/***********************************************
Name : testCustomerDocumentStatus
Descritpion: This method is used fortesting mandatory fields on customer document as OM(CSM,CSC) based on Status from Custom Setting
Parameter :
*************************************************/
	static testmethod void testCustomerDocumentStatus() {
		//User
		User sysAdmin = TestDataFactory.userCreation(1,'System Administrator')[0];
		Database.insert(sysAdmin);
		
		//Permission Set
		PermissionSet permission = [SELECT Name, Id, Description, Type
									FROM PermissionSet
									WHERE name = 'DS_CSC'];
		Database.insert(new PermissionSetAssignment(AssigneeId = sysAdmin.Id, PermissionSetId = permission.Id));
		
		System.RunAs(sysAdmin){
			Test.startTest();
			Account account = TestDataFactory.createAccount(1)[0];
			Database.insert(account);
			
			//Mandatory Fields
			List<Mandatory_fields_for_Customer_Document__c> mandatoryFieldsList = new List<Mandatory_fields_for_Customer_Document__c>();
			Mandatory_fields_for_Customer_Document__c mandatoryField1 = new Mandatory_fields_for_Customer_Document__c(
				Name = 'ClosedConsumed_Mandatory_Fields_Umbr',
				Object__c = 'Customer_Document__c',
				Sub_Classification__c = 'Umbrella (Offer Based)',
				Status__c = 'Closed-consumed',
				Classification__c = CLASSIFICATION_STANDARD_PO,
				Mandatory_Fields__c = 'Classification__c,Sub_Classification__c,Customer__c,Nokia_Legal_entity__c,Customer_Document_ID__c,Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,Total_Value__c'
			);
			mandatoryFieldsList.add(mandatoryField1);
			
			Mandatory_fields_for_Customer_Document__c mandatoryField2 = new Mandatory_fields_for_Customer_Document__c(
				Name = 'ClosedRejected_Mandatory_Fields_Quote',
				Object__c = 'Customer_Document__c',
				Sub_Classification__c = SUBCLASSIFICATION_QUOTE_BASED,
				Classification__c = CLASSIFICATION_STANDARD_PO,
				Status__c = STATUS_CLOSED_REJECTED,
				Mandatory_Fields__c = 'Classification__c,Sub_Classification__c,Customer__c,Nokia_Legal_entity__c,Customer_Document_ID__c,Customer_Document_Date__c,Nokia_Document_Receipt_Date__c,Total_Value__c,INCO_Terms__c,Payment_terms__c'
			);
			mandatoryFieldsList.add(mandatoryField2);
			
			Mandatory_fields_for_Customer_Document__c mandatoryField3 = new Mandatory_fields_for_Customer_Document__c(
				Name = 'Draft_Mandatory_Fields',
				Object__c = 'Customer_Document__c',
				Status__c = 'Draft',
				Mandatory_Fields__c = 'Customer__c,Customer_Document_ID__c'
			);
			mandatoryFieldsList.add(mandatoryField3);
			
			Mandatory_fields_for_Customer_Document__c mandatoryField4 = new Mandatory_fields_for_Customer_Document__c(
				Name = 'ClosedRejected__Fields_LI_Quote',
				Object__c = 'Customer_Document_Line_Items__c',
				Status__c = STATUS_CLOSED_REJECTED,
				Mandatory_Fields__c = 'Quantity__c,Net_Value__c,Total_Value__c',
				Classification__c = CLASSIFICATION_STANDARD_PO,
				Sub_Classification__c = SUBCLASSIFICATION_QUOTE_BASED
			);
			mandatoryFieldsList.add(mandatoryField4);
			Database.insert(mandatoryFieldsList, false);
			
			String message;
			Customer_Document__c cd = new Customer_Document__c(
				Customer__c = account.Id,
				Status__c = 'Draft',
				Customer_Document_ID__c = '124356',
				Classification__c = CLASSIFICATION_STANDARD_PO,
				Sub_Classification__c = SUBCLASSIFICATION_QUOTE_BASED
				
			);
			try {
				Database.insert(cd);
			} catch (Exception ex) {
				message = ex.getMessage();
			}
			//	System.assert(message != null);
			
			
			//Database.insert(cd);
			
			//Customer Document Line Item
			Customer_Document_Line_Items__c cdli = new Customer_Document_Line_Items__c(
				Quantity__c = '1',
				Net_Value__c = 35,
				Total_Value__c = 50,
				Customer_Document__c = cd.Id
			);
			Database.insert(cdli);
			
			cd.Status__c = STATUS_CLOSED_REJECTED;
			cd.Classification__c = CLASSIFICATION_STANDARD_PO;
			cd.Sub_Classification__c = SUBCLASSIFICATION_QUOTE_BASED;
			try {
				Database.update(cd);
			} catch (Exception ex) {
				message = ex.getMessage();
			}
			//		System.assert(message != null);
			
			//CustomerDocumentTriggerHandler.checkValidationOnUpdate(null, null);
			Account soldtopartyAcc = TestDataFactory.createAccount(1)[0];
			//Database.insert(soldtopartyAcc);
			
			//Opportunity
			Opportunity oppty = TestDataFactory.OpportunityCreation(1, soldtopartyAcc)[0];
			oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
			oppty.Lead_BG__c = 'MN';
			oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			//Database.insert(oppty);
			
			//Quote/Proposal
			Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal.Apttus_Proposal__Opportunity__c = oppty.Id;
			quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
			quoteProposal.Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			quoteProposal.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
			quoteProposal.Prices_Aligned__c = true;
			quoteProposal.Apttus_Proposal__Account__c = soldtopartyAcc.Id;
			quoteProposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
			quoteProposal.LOA_Status__c = 'Approved';
			//Database.insert(quoteProposal);
			
			//Customer Document Association
			Customer_Document_Junction__c cdj = new Customer_Document_Junction__c(
				Customer_Document__c = cd.Id,
				Quote_Proposal__c = quoteProposal.Id
			);
			//Database.insert(cdj);
			checkRecursive.run = true;
			
			if (cdj.Id <> null) {
				Database.DeleteResult dr = Database.delete(cdj);
				System.assert(true, dr.isSuccess());
			}
			List<Customer_Document__c> cdl = new List<Customer_Document__c>();
			cdl.add(cd);
			Set<Id> ids = new Set<Id>();
			ids.add(cd.Id);
			CustomerDocumentTriggerHelper.checkValidation(cdl, ids);
			CustomerDocumentTriggerHandler.checkValidationOnUpdate(cdl, null);
			
			Test.stopTest();
		}
	}
}