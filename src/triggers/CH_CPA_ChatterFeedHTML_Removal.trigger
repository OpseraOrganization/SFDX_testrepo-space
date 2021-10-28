trigger CH_CPA_ChatterFeedHTML_Removal on CH_Corrective_Preventive_Action__c (before insert, before update) {
	
   

	for(CH_Corrective_Preventive_Action__c H : Trigger.New){
		if(H.CH_Cause_Analysis__c != null)
		H.CH_Cause_Analysis__c = H.CH_Cause_Analysis__c.replaceAll('\\<.*?\\>', '');
		//H.CH_Cause_Analysis__c = H.CH_Cause_Analysis__c.unescapeHtml4();
		if(H.CH_Description__c != null)
		H.CH_Description__c = H.CH_Description__c.replaceAll('\\<.*?\\>', '');
		//H.CH_Description__c = H.CH_Description__c.unescapeHtml4();
		if(H.CH_Recommendation__c != null)
		H.CH_Recommendation__c = H.CH_Recommendation__c.replaceAll('\\<.*?\\>', '');
		//H.CH_Recommendation__c = H.CH_Recommendation__c.unescapeHtml4();
		if(H.CH_Follow_up__c != null)
		H.CH_Follow_up__c = H.CH_Follow_up__c.replaceAll('\\<.*?\\>', '');
		//H.CH_Follow_up__c = H.CH_Follow_up__c.unescapeHtml4();
		if(H.CH_Result__c != null)
		H.CH_Result__c = H.CH_Result__c.replaceAll('\\<.*?\\>', '');
		//H.CH_Result__c = H.CH_Result__c.unescapeHtml4();
	}


}