trigger NCP_ExistingContactTrigger on NCP_ExistingContact__e (after insert) {


	List<string> emailList = new List<String>();
	for (Case singleCase : [
			SELECT Id,SuppliedEmail
			FROM Case
			WHERE recordType.Name = 'SF Support' AND Status = 'New'
	]) {
		emailList.add(singleCase.SuppliedEmail);
	}


	List<Case> caseList = new List<Case>();
	for (NCP_ExistingContact__e existingContactEvent : Trigger.New) {

		if(!emailList.contains(existingContactEvent.Lead_Email__c)){
			Case newCase = new Case();


			newCase.SuppliedName = existingContactEvent.Full_Name__c;
			Id recordTypeID = null;
			if (existingContactEvent.Record_Type_ID__c != null) {
				recordTypeID = Id.valueOf(existingContactEvent.Record_Type_ID__c);
			}
			newCase.RecordTypeId =  recordTypeID;
			newCase.Issue_Reported_By__c = existingContactEvent.Reported_User_ID__c ;
			newCase.subject = Label.NCP_DuplicateMailCaseSubject;
			newCase.type = 'sCRM Problem';
			newCase.Category__c = 'Mass Update Request';
			newCase.description = 'Request to Convert Lead ' + existingContactEvent.Lead_ID__c + ' Email: ' + existingContactEvent.Lead_Email__c + ' to a Salesforce Contact record';
			newCase.Priority = 'Critical';
			newCase.Justification_for_Critical_Priority__c = Label.NCP_DuplicateMailCaseJustification;
			newCase.Estimated_Prod_Resolution_Date__c = system.today() + 1;
			newCase.SuppliedEmail = existingContactEvent.Lead_Email__c;
			newCase.Origin = 'Web';
			newCase.Oppty_Offer_Account_ref_Number_s__c = existingContactEvent.Account_Details__c;

			caseList.add(newCase);
		}

	}
	if(caseList.size()>0){
		insert caseList;
	}


}