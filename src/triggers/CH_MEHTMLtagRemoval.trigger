trigger CH_MEHTMLtagRemoval on CH_Manage_Escalation__c (before insert,before update) {
	
	for(CH_Manage_Escalation__c meobject : Trigger.New)
	{
		if(meobject.CH_EscalationDescription__c != null)
		meobject.CH_EscalationDescription__c = meobject.CH_EscalationDescription__c.replaceAll('\\<.*?\\>', '');
	}

}