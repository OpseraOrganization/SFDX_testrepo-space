global class CH_EmailPublisherHandler implements QuickAction.QuickActionDefaultsHandler {
	
	global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) {
		QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = null;
	
		for (Integer j = 0; j < defaults.size(); j++) {
			if (defaults.get(j) instanceof QuickAction.SendEmailQuickActionDefaults && defaults.get(j).getActionType().equals('SendEmail') && defaults.get(j).getTargetSObject().getSObjectType() == EmailMessage.sObjectType && (defaults.get(j).getActionName().equals('Case.CH_Email_Communication') || defaults.get(j).getActionName().equals('Case.CH_Email_Communication_IR') || defaults.get(j).getActionName().equals('Case.CH_Email_Communication_NS') || defaults.get(j).getActionName().equals('Case.CH_ProblemEmailAction'))){
				   sendEmailDefaults = (QuickAction.SendEmailQuickActionDefaults)defaults.get(j);
				   break;
			}
		}
		
		system.debug('###sendEmailDefaults:' + sendEmailDefaults);
		
		if (sendEmailDefaults != null) {
			Case c = [SELECT Contact.Email FROM Case WHERE Id =: sendEmailDefaults.getContextId() AND CH_RecordTypeCheck__c = true];
			EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject();	
			emailMessage.ToAddress = c.Contact.Email;
		}
	}
}