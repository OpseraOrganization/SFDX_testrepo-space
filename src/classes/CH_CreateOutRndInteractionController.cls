public with sharing class CH_CreateOutRndInteractionController {
	@AuraEnabled
	public static RndInteraction loadInboundRndInteraction(Id inboundRndInteractionId) {
		RndInteraction result = new RndInteraction();
		List<CH_Problem_RnD_Reference__c> rndInteractions = [SELECT Id, CH_RnD_Reference__c, CH_Related_Record__c, CH_Related_Record__r.CaseNumber FROM CH_Problem_RnD_Reference__c WHERE Id =: inboundRndInteractionId];
		if (!rndInteractions.isEmpty()) {
			CH_Problem_RnD_Reference__c rndInteraction = rndInteractions[0];
			result.rndReference = rndInteraction.CH_RnD_Reference__c;
			if (rndInteraction.CH_Related_Record__r != NULL) {
	result.relatedRecordId = rndInteraction.CH_Related_Record__c;
	result.relatedRecordNumber = rndInteraction.CH_Related_Record__r.CaseNumber;
			}
		}
		return result;
	}

	@AuraEnabled
	public static Problem loadProblem(Id problemId) {
		Problem result = new Problem();
		Case problem = [SELECT Id, CH_CustomerDescription__c, CH_RDInterface__c FROM Case WHERE Id =: problemId];
		if (!String.isEmpty(problem.CH_CustomerDescription__c)) {
			result.description = problem.CH_CustomerDescription__c.stripHtmlTags();
		}
		result.interfaceName = problem.CH_RDInterface__c;
		return result;
	}

	@AuraEnabled
	public static Id createRndInteraction(String rndInteractionJson) {
		RndInteraction outboundRndInteraction = (RndInteraction) JSON.deserialize(rndInteractionJson, RndInteraction.class);
		CH_Problem_RnD_Reference__c outboundSfRndInteraction = outboundRndInteraction.initializeSfRndInteraction();
		insert outboundSfRndInteraction;

		return outboundSfRndInteraction.Id;
	}

	@AuraEnabled
	public static void deleteRndInteraction(Id outboundRndInteractionId) {
		CH_Problem_RnD_Reference__c outboundRndInteraction = [SELECT Id FROM CH_Problem_RnD_Reference__c WHERE Id =: outboundRndInteractionId];
		delete outboundRndInteraction;
	}

	@AuraEnabled
	public static Id sendRndInteraction(Id outboundRndInteractionId) {
		CH_Problem_RnD_Reference__c outboundRndInteraction = [SELECT Id, CH_Related_RnD_Interaction__c, CH_Related_RnD_Interaction__r.CH_RnD_Description__c, CH_Request__c, CH_RnD_Status__c, CH_RnD_Type__c, CH_Related_Record__c, CH_Related_Record__r.CaseNumber, CH_Related_Record__r.Severity__c,  CH_Related_Record__r.Priority, CH_Related_Record__r.CH_ReportedDate__c, CH_Related_Record__r.CH_PausedSinceDate__c, CH_Related_Record__r.CH_SolutionTargetDate__c, CH_RnD_Interface__c, CH_RnD_Reference__c, CH_RnD_Subject__c, CH_RnD_Description__c, CreatedDate, CH_Related_Record__r.CH_Originating_Incident_Number__c,  CH_Related_Record__r.CH_Originating_Incident_Number__r.CaseNumber FROM CH_Problem_RnD_Reference__c WHERE Id =: outboundRndInteractionId];
		if (outboundRndInteraction.CH_RnD_Status__c == 'Failed') {
			CH_ExternalInterfaceUTIL.resendOutboundRndInteraction(outboundRndInteraction);
		} else {
			CH_ExternalInterfaceUTIL.sendProntoOutboundRndInteraction(outboundRndInteraction);
		}
		return outboundRndInteractionId;
	}

	@AuraEnabled
	public static Id sendCreateAnalysisRndInteraction(Id outboundRndInteractionId) {
		CH_ExternalInterfaceUTIL.sendOutboundCreateAnalysisRndInteraction(outboundRndInteractionId);

		return outboundRndInteractionId;
	}
   
	public class RndInteraction {
		@AuraEnabled public String direction {get; set;}
		@AuraEnabled public String interactionType {get; set;}
		@AuraEnabled public String interfaceName {get; set;}
		@AuraEnabled public String rndReference {get; set;}
		@AuraEnabled public String transactionStatus {get; set;}
		@AuraEnabled public String relatedRecordNumber {get; set;}
		@AuraEnabled public Id relatedRecordId {get; set;}
		@AuraEnabled public String subject {get; set;}
		@AuraEnabled public String comment {get; set;}
		@AuraEnabled public String description {get; set;}
		@AuraEnabled public Id relatedRndInteractionId {get; set;}

		public CH_Problem_RnD_Reference__c initializeSfRndInteraction() {
			CH_Problem_RnD_Reference__c rndInteraction = new CH_Problem_RnD_Reference__c(CH_RnD_Direction__c = direction,
		CH_RnD_Type__c = interactionType,
		CH_RnD_Interface__c = interfaceName,
		CH_RnD_Reference__c = rndReference,
		CH_RnD_Status__c = transactionStatus,
		CH_Related_Record__c = relatedRecordId,
		CH_RnD_Comment__c = comment,
		CH_RnD_Description__c = description,
		CH_Related_RnD_Interaction__c = relatedRndInteractionId);
			switch on interactionType {
	when 'Workaround Accepted' {
		rndInteraction.CH_RnD_Subject__c = String.format('Problem {0}: Workaround Acceptance to {1}', new List<Object>{relatedRecordNumber, interfaceName});
	}	
	when 'Workaround Rejected' {
		rndInteraction.CH_RnD_Subject__c = String.format('Problem {0}: Workaround Rejection to {1}', new List<Object>{relatedRecordNumber, interfaceName});
	}
	when 'Correction Rejected' {
		rndInteraction.CH_RnD_Subject__c = String.format('Problem {0}: Correction Rejection to {1}', new List<Object>{relatedRecordNumber, interfaceName});
	}
	when 'Information Response' {
		rndInteraction.CH_RnD_Subject__c = String.format('Problem {0}: Information Response to {1}', new List<Object>{relatedRecordNumber, interfaceName});
	}
	when 'Information Update' {
		rndInteraction.CH_RnD_Subject__c = String.format('Problem {0}: Information Update to {1}', new List<Object>{relatedRecordNumber, interfaceName});
	}
	when else {
		rndInteraction.CH_RnD_Subject__c = subject;
	}
			}
			
			return rndInteraction;
		}
	}

	public class Problem {
		@AuraEnabled public String description {get; set;}
		@AuraEnabled public String interfaceName {get; set;}
	}
}