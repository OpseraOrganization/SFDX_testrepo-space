public class DS_Oppty_Main_Reasons {

	@AuraEnabled  
	public static Integer checkOpttyStageParams(Id recordId)
	{		
		Integer flag = 0;
		List<Opportunity> Oppty = new List<Opportunity>();
		Oppty = [Select Id, StageName, Phase_Status__c,Lead_BG__c,DS_Reasons_Populated__c,OIF_Amount_EUR__c, SWx_Upsell_Proposal__c from Opportunity WHERE id =: recordId LIMIT 1];
		for(Opportunity opp: Oppty){
			if(opp.SWx_Upsell_Proposal__c!= null && opp.DS_Reasons_Populated__c ==true && opp.OIF_Amount_EUR__c > CSWXGlobalConstant.threshold  &&((opp.StageName == CSWXGlobalConstant.EXECUTE_STAGE && opp.Phase_Status__c == CSWXGlobalConstant.EXECUTE_PHASE && opp.Lead_BG__c == CSWXGlobalConstant.MN )||(opp.StageName == CSWXGlobalConstant.CLOSED_STAGE && opp.Phase_Status__c == CSWXGlobalConstant.CLOSED_PHASE) || (opp.StageName == CSWXGlobalConstant.HANDOVER_OPPTY && opp.Phase_Status__c == CSWXGlobalConstant.PTA_HANDOVER))){
				flag = 1;
			}
		}
		return flag;   
	}  
}