public without sharing class CH_CA_Notifications {
	private static List<FeedItem> oFeedItemList = new List<FeedItem>();
	private static List<CH_EmailAlert__c> oEmailAlertList = new List<CH_EmailAlert__c>();
	
	// Create a chatter post for a workgroup
	public void createNotificationViaChatter(Case supportCase, CH_Workgroup_Member__c newAssignedUser){
		if (!String.isBlank(newAssignedUser.CH_Workgroup__c)){
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
			oFeedItemList.add(new FeedItem(
				ParentId = newAssignedUser.CH_Workgroup__c,
				Body = body
			));
		}
		else System.debug('CH_CA: CH_Workgroup__c is blank. No Chatter post.');
	}
	
	// Send an email for case assignment
	public void createNotificationViaEmail(Case supportCase, CH_Workgroup_Member__c newAssignedUser){
		if (!String.isBlank(newAssignedUser.CH_Queue_Email__c)) {
			oEmailAlertList.add(new CH_EmailAlert__c(
				CH_EmailAlertName__c = 'Workgroup Queue Email Alert',
				CH_Bind1__c = supportCase.CaseNumber,
				CH_Bind2__c = newAssignedUser.Name,
				CH_Bind3__c = supportCase.CH_Stage__c,
				CH_Bind4__c = string.valueOfGmt(supportCase.CH_ReportedDate__c),
				CH_Bind5__c = supportCase.CH_ServiceType__c,
				CH_Bind6__c = supportCase.Type,
				CH_Bind7__c = supportCase.Severity__c,
				CH_Bind8__c = supportCase.CH_Product_Name__c,
				CH_Bind9__c = supportCase.CH_ExternalBridge__c == null ? '' : supportCase.CH_ExternalBridge__c,
				CH_Bind10__c = supportCase.Account.Name + ' ' + (supportCase.Account.Region__c == null ? '' : supportCase.Account.Region__c),
				CH_Bind11__c = supportCase.Country__c == null ? '' : supportCase.Country__c,
				CH_Bind12__c = newAssignedUser.CH_Workgroup__r.Name,
				CH_Bind13__c = 'Case Assigned to ' + newAssignedUser.Name + ' for ' + supportCase.Account.Name + ', ' + supportCase.CH_Product_Name__c,
				CH_Bind14__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + supportCase.id,
				CH_Bind15__c = newAssignedUser.CH_Queue_Email__c
			));
		}
		else System.debug('CH_CA: Email is blank. No Email Send.'); 
	}
	
	public void send(Boolean sendFeedItem, Boolean sendEmailAlert) {
		if(sendFeedItem) { Database.insert(oFeedItemList, false); }
		if(sendEmailAlert) { Database.insert(oEmailAlertList, false); }
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