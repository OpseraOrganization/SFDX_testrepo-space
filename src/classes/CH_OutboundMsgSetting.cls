public without sharing class CH_OutboundMsgSetting {
@AuraEnabled
	public static List<CH_OutboundMessageSettings__c> getOMSList() 
	{
		return [
	SELECT Name,CaseCreation__c,CaseFeedEmailCauseAnalysisReport__c,CaseFeedEmailCustomerInformationRequest__c,CaseFeedEmailInitialResponse__c,
				CaseFeedEmailRestoration__c,CaseFeedEmailServiceDisruptionReport__c,CaseFeedEmailSolution__c,CaseFeedEmailTemporary__c,
				CaseFeedEmailUpdate__c,CaseStageAssetRespond__c,CaseStageClose__c,CaseStageDiagnosisTechnicalAnalysis__c,CaseStageInvestigateRestore__c,
				CaseStageRegister__c,CaseStageResolve__c,CaseStageRoute__c
	FROM CH_OutboundMessageSettings__c ORDER BY Name ASC ];
	}
	@AuraEnabled
	public static void deleteOMS(String omName) 
	{
		delete [SELECT Name FROM CH_OutboundMessageSettings__c where Name =:omName ];
	}
	@AuraEnabled
	public static CH_OutboundMessageSettings__c getOMS(String omName) 
	{
		List<CH_OutboundMessageSettings__c>  omsRecords=[SELECT Name,CaseCreation__c,CaseFeedEmailCauseAnalysisReport__c,CaseFeedEmailCustomerInformationRequest__c,CaseFeedEmailInitialResponse__c,
				CaseFeedEmailRestoration__c,CaseFeedEmailServiceDisruptionReport__c,CaseFeedEmailSolution__c,CaseFeedEmailTemporary__c,
				CaseFeedEmailUpdate__c,CaseStageAssetRespond__c,CaseStageClose__c,CaseStageDiagnosisTechnicalAnalysis__c,CaseStageInvestigateRestore__c,
				CaseStageRegister__c,CaseStageResolve__c,CaseStageRoute__c
	FROM CH_OutboundMessageSettings__c where Name =:omName ];
		return omsRecords[0];
	}
	@AuraEnabled
	public static boolean isOMSPresent(String omName) 
	{ 
		List<CH_OutboundMessageSettings__c>  omsRecords=[SELECT Name,CaseCreation__c,CaseFeedEmailCauseAnalysisReport__c,CaseFeedEmailCustomerInformationRequest__c,CaseFeedEmailInitialResponse__c,
				CaseFeedEmailRestoration__c,CaseFeedEmailServiceDisruptionReport__c,CaseFeedEmailSolution__c,CaseFeedEmailTemporary__c,
				CaseFeedEmailUpdate__c,CaseStageAssetRespond__c,CaseStageClose__c,CaseStageDiagnosisTechnicalAnalysis__c,CaseStageInvestigateRestore__c,
				CaseStageRegister__c,CaseStageResolve__c,CaseStageRoute__c
	FROM CH_OutboundMessageSettings__c where Name =:omName];
		if(omsRecords.isEmpty())
		{
			return false;
		}
		else
		{
			return true;
		}
		
	}
	@AuraEnabled
	public static String upsertOutBoundRecord(CH_OutboundMessageSettings__c record) {
		try {
			Database.UpsertResult ur = Database.upsert(record);
			return ur.isSuccess() ? 'sucess' : ur.getErrors()[0].getMessage();
		} catch (DmlException e) {
			return e.getDmlMessage(0);
		}
	}
	@AuraEnabled
	public static String accessToOBM(String  userId) {	 
		List<Object> obs=[select Id from PermissionSetAssignment where Assignee.Id =:userId AND PermissionSet.Label in ('CH_S2S Key User')  limit 1];
		List<Object> obs2=[select Id, Name from User where Profile.Name IN ('System Administrator') AND Id =:userId];
		String flag;
		if(obs.size()>0)
		{
			flag='S2S';
		}
		else if(obs2.size()>0)
		{
			flag='SYSADMIN';
		}
		else
		{
			flag='false';
		}
		return flag;
	}
	@AuraEnabled
	public static String getReportLink() {
		
		return CH_InterfacingMapping__c.getValues('reportLink').ReportUrl__c;
	}
}