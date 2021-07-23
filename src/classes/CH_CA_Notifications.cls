public without sharing class CH_CA_Notifications {
	// Create a chatter post for a workgroup
	public void NotifyViaChatter(Case supportCase, CH_Workgroup_Member__c newAssignedUser){
		if (String.isBlank(newAssignedUser.CH_Workgroup__c)){
			System.debug('CH_CA: CH_Workgroup__c is blank. No Chatter post.');
			return;
		}		

		System.debug('CH_CA: Chatter post to: ' + newAssignedUser.CH_Workgroup__c + '. By user: ' + newAssignedUser);
		
		// Create the chatter post for case assignment
		String body = 'The Case ' + supportCase.CaseNumber + ' has been assigned to ' + newAssignedUser.Name + ' #WorkgroupCase \n\n';
		body += 'Case Details:\n';
		body += 'Reported to Nokia	 : ' + string.valueOfGmt(supportCase.CH_ReportedDate__c) + '\n';
		body += 'Service Type	: ' + supportCase.CH_ServiceType__c + '\n';
		body += 'Case Type	: ' + supportCase.Type + '\n';
		body += 'Severity	 : ' + supportCase.Severity__c + '\n';
		body += 'Product	  : ' + supportCase.CH_Product_Name__c + '\n';
		body += 'External Bridge Number: ' + (supportCase.CH_ExternalBridge__c == null ? '' : supportCase.CH_ExternalBridge__c) + '\n';
		body += 'Customer	 : ' + supportCase.Account.Name + '\n';
		body += 'Country	  : ' + supportCase.Country__c + '\n';
		
		// Create the chatter post
		FeedItem post = new FeedItem();
		post.ParentId = newAssignedUser.CH_Workgroup__c;
		post.Body = body;
		insert post;


		System.debug('CH_CA: Posted to Chatter for workgroup ' + newAssignedUser.CH_Workgroup__c);		
	}
	
	// Send an email for case assignment
	public void NotifyViaEmail(Case supportCase, CH_Workgroup_Member__c newAssignedUser){
		string email = newAssignedUser.CH_Queue_Email__c;
		
		if (String.isBlank(email)){
			System.debug('CH_CA: Email is blank. No Email Send.'); 
			return;
		}
		//Changes added for 29521
		String getEmailAddress = System.Label.CH_NoReplyEmailAddress;
		//Get the Ordwide Email address
		OrgWideEmailAddress[] orgEmail = new OrgWideEmailAddress[]{};
		orgEmail = [select Id from OrgWideEmailAddress where Address =: getEmailAddress LIMIT 1];
		String subject = 'Case Assigned to ' + newAssignedUser.Name + ' for ' + 
			supportCase.Account.Name + ', ' + supportCase.CH_Product_Name__c;

		String body = 'Dear User,<br><br><br>';
		body += 'The Case ' + supportCase.CaseNumber + ' has been assigned to ' + 
			newAssignedUser.Name + '.<br><br>';
		body += 'The Case is within the ' + supportCase.CH_Stage__c + ' process stage.<br><br>';
		body += '<b>Case Details:</b><br>';
		body += 'Reported to Nokia	 : ' + string.valueOfGmt(supportCase.CH_ReportedDate__c) + '<br>';
		body += 'Service Type	: ' + supportCase.CH_ServiceType__c + '<br>';
		body += 'Case Type	: ' + supportCase.Type + '<br>';
		body += 'Severity	 : ' + supportCase.Severity__c + '<br>';
		body += 'Product	  : ' + supportCase.CH_Product_Name__c + '<br>';
		body += 'External Bridge Number: ' + (supportCase.CH_ExternalBridge__c == null ? '' : supportCase.CH_ExternalBridge__c) + '<br>';
		body += 'Customer	 : ' + supportCase.Account.Name + ' ' + (supportCase.Account.Region__c == null ? '' : supportCase.Account.Region__c) + '<br>';
		body += 'Country	  : ' + (supportCase.Country__c == null ? '' : supportCase.Country__c) + '<br>';
		body += 'Current Workgroup	 : ' + newAssignedUser.CH_Workgroup__r.Name + '<br>';
		body += 'View this <a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + supportCase.id + '">Case</a><br><br>';
		body += 'Regards,<br>';
		body += 'Nokia Support Services.';

		List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
		// Create the email
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<String> sendTo = new List<string>();
		sendTo.add(email);
		//mail.setSenderDisplayName('Nokia Support'); 
		If(orgEmail.get(0).Id!=null){
		mail.setOrgWideEmailAddressId(orgEmail.get(0).Id); 
		}
		mail.setReplyTo('no-reply@nokia.com');
		mail.setToAddresses(new String[] {email});
		mail.setBccSender(false);
		mail.setSubject(subject);
		mail.setHtmlBody(body);
		mail.setTreatTargetObjectAsRecipient(false);
		emailList.add(mail);
		// Send the email
		Messaging.sendEmail(emailList);		

		System.debug('CH_CA: Email send to ' + email);
	}
	
	//Post to chatter
	public static void postToChatter(Map<Id, String> chatterMap){
		List<FeedItem> postsToInsert = new List<FeedItem>();
		for(Id parentId : chatterMap.keySet()){
			// Create the chatter post
			FeedItem post = new FeedItem();
			post.ParentId = parentId;
			post.Body = chatterMap.get(parentId);
			postsToInsert.add(post);
		}
		insert postsToInsert;
	}
}