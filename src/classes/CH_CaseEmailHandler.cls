public class CH_CaseEmailHandler {
  
  /****************
   * Method Name: notifyAdditionalContacts
   * Parameter: caseList
   * Last updated by: nikhil.m@nokia.com, tiago.almeida@nokia.com
   * Description:
   * User Story: NOKIASC-15674
  ****************/
  public static void notifyAdditionalContacts(List <Case> caseList){
	List<EmailTemplate> oEmailTemplateList = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'DMK_CH_CaseCreatedOutboundAll'];
	
	// Modified for NOKIASC-29359, to get proper ORG ID by TCS
	List<OrgWideEmailAddress> oOrgWideEmailAddressList = [SELECT Id,Address FROM OrgWideEmailAddress WHERE Address like 'support.services%'];
	Id UATOrgid,PRODOrgid;
	String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
	// End for NOKIASC-29359
	
	if(oEmailTemplateList.isEmpty()) {
	  throw new CustomException('Email template "DMK_CH_CaseCreatedOutboundAll" not found!');	  
	}
	if(oOrgWideEmailAddressList.isEmpty()) {
	  throw new CustomException('Org Wide Email "support.services@nokia.com" not found!');
	}
	// NOKIASC-29359 Added the code to add proper OrgID based on sandbox or Prod organization by TCS
	else{
		for(OrgWideEmailAddress oOrgAddr:oOrgWideEmailAddressList){
			if(baseURL.contains('nokia.my.salesforce.com') && oOrgAddr.Address == 'support.services@nokia.com'){
				PRODOrgid = oOrgAddr.id;
			}else{
				UATOrgid = oOrgAddr.id;
			}
		}
	}
	// End for NOKIASC-29359
	Set<Id> idCaseSet = new Set<Id>();
	Set<Id> idContactSet = new Set<Id>();
	for(Case oCase : caseList){
	  idCaseSet.add(oCase.id);
	  idContactSet.add(oCase.contactId);
	}
	//Using Global/Common query as part of Code Optimization - NOKIASC-27617 by Satya Pagadala
	Map<Id, Contact> oContactMap = CH_Utils.getContactMap(idContactSet);
	List<Messaging.SingleEmailMessage> oMessageList = new List<Messaging.SingleEmailMessage>();
	for(Case oCase : caseList) {
	  Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
	  if(oCase.contactId !=null) {
		
		//Modified the logic to add proper OrgID based on sandbox or Prod organization by TCS
		if(baseURL.contains('nokia.my.salesforce.com') && PRODOrgid!=null){
			message.setOrgWideEmailAddressId(PRODOrgid);
		}else if(UATOrgid!=null){
			message.setOrgWideEmailAddressId(UATOrgid);
		}
		// End for NOKIASC-29359 message.setOrgWideEmailAddressId(oOrgWideEmailAddressList.get(0).Id);
		Contact oContact = oContactMap.get(oCase.contactId);
		if(oContact.Email != null) {
		  message.setToAddresses(new String[]{oContact.Email});
		}
		List<String> ccAddresses = new List<String>();
		if(oCase.CH_AdditionalContacts__c != null){
		  if(oCase.CH_AdditionalContacts__c.contains(';')) {
			ccAddresses.addAll(oCase.CH_AdditionalContacts__c.split(';'));
		  }
		  else {
			ccAddresses.add(oCase.CH_AdditionalContacts__c);
		  }
		}
		if(oContact.Email1__c != null) {
		  ccAddresses.add(oContact.Email1__c);
		}
		if(oContact.CH_Email3__c != null) {
		  ccAddresses.add(oContact.CH_Email3__c);
		}
		if(!ccAddresses.isEmpty()) {
		  message.setccAddresses(ccAddresses);
		}
		message.setTemplateId(oEmailTemplateList.get(0).Id);
		message.setTargetObjectId(oCase.ContactId);
		message.setWhatId(oCase.id);
		oMessageList.add(message);
	  }
	}
	if(!oMessageList.isEmpty()){
	  try {
		Messaging.SendEmailResult[] results = Messaging.sendEmail(oMessageList, false);
	  }
	  catch(exception e) {
		System.debug(e.getMessage());
	  }
	}
  }
}