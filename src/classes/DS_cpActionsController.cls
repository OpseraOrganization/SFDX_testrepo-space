public class DS_cpActionsController {

	@AuraEnabled
	public static Boolean hasUploadedDocument(Id recordId) {
		Set<Id> documentList = new Set<Id>();
		for (ContentDocumentLink documentLink : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId LIMIT :Limits.getLimitQueryRows()-Limits.getQueryRows()]) {
			documentList.add(documentLink.ContentDocumentId);
		}
		if (!documentList.isEmpty()) {
			Integer documentCount = [SELECT Count() FROM ContentVersion WHERE OwnerId = :UserInfo.getUserId() AND ContentDocumentId IN :documentList LIMIT :Limits.getLimitQueryRows()-Limits.getQueryRows()];
			return (documentCount > 0);
		}
		return false;
	}

	@AuraEnabled
	public static Apttus_Proposal__Proposal__c updateStage(Id recordId, String approvalStage, String rejectionReason) {
		Apttus_Proposal__Proposal__c proposal = [SELECT Id, Apttus_Proposal__Approval_Stage__c, Rejection_Reason__c FROM Apttus_Proposal__Proposal__c WHERE Id = :recordId LIMIT :Limits.getLimitQueryRows()-Limits.getQueryRows()];
		String msg = '';
		try {
			proposal.Apttus_Proposal__Approval_Stage__c = approvalStage;
			proposal.Rejection_Reason__c = rejectionReason;
			update proposal;
			return proposal;
		} catch (DMLException e) {
			for (Integer i = 0; i < e.getNumDml(); i++) {
				//Get Validation Rule & Trigger Error Messages
				msg =+ e.getDmlMessage(i) + '\n' ;
			}
			//throw DML exception message
			throw new AuraHandledException(msg);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static void updateIntermediateStage(Id recordId, String approvalStage) {
		String msg = '';
		try {
			List<Customer_facing_Attribute__c> attributes = [SELECT Id, Quote_Approval_Stage__c FROM Customer_facing_Attribute__c WHERE Quote__c = :recordId LIMIT 1];
			for (Customer_facing_Attribute__c a : attributes) {
				a.Quote_Approval_Stage__c = approvalStage;
			}
			update attributes;
		} catch (DMLException e) {
			for (Integer i = 0; i < e.getNumDml(); i++) {
				//Get Validation Rule & Trigger Error Messages
				msg =+ e.getDmlMessage(i) + '\n' ;
			}
			//throw DML exception message
			throw new AuraHandledException(msg);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled
	public static List<Customer_facing_Attribute__c> getExtraInformationForQuoteId(String recordId) {
		return [SELECT Id, Attribute_Label__c, Attribute_Value__c
				FROM Customer_facing_Attribute__c
				WHERE Quote__c = :recordId AND Attribute_Indicator__c = :CSWXGlobalConstant.header_indicator AND Attribute_Visibility__c = 'Yes' AND Attribute_Label__c != null
				ORDER BY Attribute_Label__c ASC];
	}

	@AuraEnabled
	public static Map<String,String> getHelpTextForQuote() {
		Map<String, String> helpTextMap = new Map<String, String>();
		helpTextMap.put('Apttus_Proposal__Proposal_Name__c', Apttus_Proposal__Proposal__c.Apttus_Proposal__Proposal_Name__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Sold_To_Party__r.Name', Apttus_Proposal__Proposal__c.Sold_To_Party__r.Name.getDescribe().getInlineHelpText());
		helpTextMap.put('Agreement_Lookup__r.Name', Apttus_Proposal__Proposal__c.SAgreement_Lookup__r.Name.getDescribe().getInlineHelpText());
		helpTextMap.put('Contract_Start_Date__c', Apttus_Proposal__Proposal__c.Contract_Start_Date__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Contract_End_Date__c', Apttus_Proposal__Proposal__c.Contract_End_Date__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Terms_Month__c', Apttus_Proposal__Proposal__c.Terms_Month__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Apttus_QPConfig__PONumber__c', Apttus_Proposal__Proposal__c.Apttus_QPConfig__PONumber__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Apttus_QPConfig__PODate__c', Apttus_Proposal__Proposal__c.Apttus_QPConfig__PODate__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Invoice_Frequency__c', Apttus_Proposal__Proposal__c.Invoice_Frequency__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Apttus_Proposal__Payment_Term__c', Apttus_Proposal__Proposal__c.Apttus_Proposal__Payment_Term__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Incoterms__c', Apttus_Proposal__Proposal__c.Incoterms__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Customer_Contact_Name_Commercial__c', Apttus_Proposal__Proposal__c.Customer_Contact_Name_Commercial__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Customer_Contact_Name_Delivery__c', Apttus_Proposal__Proposal__c.Customer_Contact_Name_Delivery__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Apttus_Proposal__Primary_Contact__c', Apttus_Proposal__Proposal__c.Apttus_Proposal__Primary_Contact__c.getDescribe().getInlineHelpText());
		helpTextMap.put('SWx_Upsell_Proposal__r.Technology__c', SWx_Upsell_Proposal__c.Technology__c.getDescribe().getInlineHelpText());
		helpTextMap.put('SWx_Upsell_Proposal__r.Use_Case__c', SWx_Upsell_Proposal__c.Use_Case__c.getDescribe().getInlineHelpText());
		helpTextMap.put('Rejection_Reason__c', Apttus_Proposal__Proposal__c.Rejection_Reason__c.getDescribe().getInlineHelpText());
		return helpTextMap;
	}

	@AuraEnabled
	public static Boolean isDSCustomerProfile() {
		return (1 == [SELECT COUNT()
					  FROM User
					  WHERE Id = :UserInfo.getUserId() AND Profile.Name = :GlobalConstants.PROFILE_DS_SALES_CUST]);
	}

}