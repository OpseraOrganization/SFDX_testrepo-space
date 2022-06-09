public without sharing class CH_CaseField_ProblemController {
	
	// The use of withour sharing is that Problem creation can result in updating the related incident
	// The user performing this action does not always have an edit access on the incident
	
	@AuraEnabled
	public static boolean accessCheck(Id caseId){
		boolean flag=false;
		String caseTeamMemberId;
		Case fetchCase=[SELECT Id, OwnerId
						FROM Case
						WHERE Id=:caseId];
		List<CaseTeamMember> caseTeamMemberList =[SELECT MemberId ,TeamRoleId ,ParentId 
												  FROM CaseTeamMember 
												  WHERE ParentId=:caseId 
												  LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
		Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		if(fetchCase!=NULL){
			for(caseTeamMember member : caseTeamMemberList){
				if(member.MemberId == UserInfo.getUserId()){
					flag=true;
				}
			}
			if(fetchCase.OwnerId == UserInfo.getUserId()){
				flag=true;
			}
			if(profileName == 'CH_Agent' || profileName == 'System Administrator'){
				flag=true;
			}
		}
		else{
			flag=false;
		}
		
		return flag;
	}
	
	@AuraEnabled
	public static Case getCaseDetails(Id caseId) { 
		try{
			list<Case> cases = new list<Case>([SELECT CH_Problem__c, CH_Problem__r.Subject FROM Case WHERE Id = :caseId]);
			return cases.isEmpty() ? null : cases[0];
		}catch(Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}	
	}
	
	@AuraEnabled
	public static void disassociateNewProblem(Id caseId){
		try{
			update new Case(Id = caseId, CH_Problem__c = null, ParentId = null);	
		}catch(Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}
	
	@AuraEnabled
	public static void newPostToProblem(Id caseId){
		try{
			
			list<Case> incidents = new list<Case>([SELECT CaseNumber, CH_Problem__c, CH_Problem__r.OwnerId FROM Case WHERE Id = :caseId]);
			if(!incidents.isEmpty() && incidents[0].CH_Problem__c != null){
				if(((string)incidents[0].CH_Problem__r.OwnerId).startsWith('00G'))
				throw new NokiaException('You cannot create a chatter post because the problem is currently owned by a Queue');
				FeedItem post = new FeedItem(   Type = 'LinkPost', 
												LinkUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + incidents[0].Id,
												ParentId = incidents[0].CH_Problem__r.OwnerId,
												Body = 'More information has been added to a related incident' );
				//insert post;
				
				ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
				ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
				ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
				ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
				messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
				mentionSegmentInput.id = incidents[0].CH_Problem__r.OwnerId;
				messageBodyInput.messageSegments.add(mentionSegmentInput);
				textSegmentInput.text = '\n More information has been added to the incident: ' + incidents[0].CaseNumber;
				messageBodyInput.messageSegments.add(textSegmentInput);
				feedItemInput.body = messageBodyInput;
				feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
				feedItemInput.subjectId = incidents[0].CH_Problem__c;
				ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput); 
				system.debug('###feedElement:' + feedElement);
				
				
			}
			
			
			
				
		}catch(Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
	}
	
	
	@AuraEnabled
	public static Case createNewProblem(Case problemRecord, string incidentId){
		
		try{
			
			system.debug(Logginglevel.ERROR,'###CH_CaseField_ProblemController:createNewProblem:incidentId:' + incidentId);
			system.debug(Logginglevel.ERROR,'###CH_CaseField_ProblemController:createNewProblem:problemRecord:' + problemRecord);
			if(problemRecord != null && incidentId != null){
				// Get problem case record type
				list<RecordType> problemRecType = new list<RecordType>([SELECT Id FROM RecordType WHERE sObjectType = 'Case' and DeveloperName = 'CH_Problem' limit 1]);
				system.debug(Logginglevel.ERROR,'###CH_CaseField_ProblemController:createNewProblem:problemRecType:Size:' + problemRecType.size());
				if(!problemRecType.isEmpty()){
					// Assign Problem record type
					problemRecord.recordTypeId = problemRecType[0].Id;
					// Copy fields from Incident to Problem
					Case incident = [SELECT AccountId, AssetId, CH_Outage__c, Country__c, entitlementId, priority, severity__c, CreatedDate FROM Case WHERE Id = :incidentId];
					problemRecord.AccountId = incident.AccountId;
					//problemRecord.AssetId = incident.AssetId; NOKIASC-13850
					problemRecord.CH_Outage__c = incident.CH_Outage__c;
					problemRecord.Country__c = incident.Country__c;
					//problemRecord.entitlementId = incident.entitlementId;
					problemRecord.priority = incident.priority;
					problemRecord.severity__c = incident.severity__c;
					problemRecord.CH_ServiceType__c = 'Internal Support';
					problemRecord.CH_Originating_Incident_Number__c = incidentId;
					problemRecord.CH_ReportedDate__c = incident.CreatedDate;
					insert problemRecord;
					system.debug(Logginglevel.ERROR,'###CH_CaseField_ProblemController:createNewProblem:problemRecord:' + problemRecord);	
					// Update related incident
					Case incidentToUpdate = new Case(Id = incidentId, 
													parentId = problemRecord.Id, 
													CH_Problem__c = problemRecord.Id, 
													CH_ProblemCreationReason__c = problemRecord.CH_ProblemCreationReason__c);
					update incidentToUpdate;
					system.debug(Logginglevel.ERROR,'###CH_CaseField_ProblemController:createNewProblem:incidentToUpdate:' + incidentToUpdate);
					
					// Assign Problem to Queue 
					CH_DisplayWorkgroupHelper.assignProblemToQueue(new List<Id>{problemRecord.Id});
	
				}
			}
			return problemRecord;
				
		}catch(Exception e){
			system.debug(Logginglevel.ERROR, '###Exception:' + e.getStackTraceString() + ':' + e.getLineNumber() + ':' + e.getCause() + ':' + e.getTypeName());
			// e.setMessage('Something went wrong: ');
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		// AuraHandledException e = new AuraHandledException('Something Went Wrong');
	   // e.setMessage('Something Went Wrong');
		//system.debug(e);
	   // throw e;
		}
		
	}
	
	public class NokiaException extends Exception {}

}