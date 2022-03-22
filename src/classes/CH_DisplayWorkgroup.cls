public without sharing class CH_DisplayWorkgroup
{
 // Get all the workgroup members 
	@AuraEnabled  
	public static CH_CaseAssignment getWorkgroupMembers(String caseId){
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		return helper.GetWorkgroupMembers(caseId);
	}	
	
	//Description - This method is used to update case owner 
	@AuraEnabled
	public static void updateSupportTicketOwner(String caseId, String memId){			
		try{
			Id queueId; 
			Case caseObj = new Case();
			caseObj = [SELECT Status FROM Case where Id =:caseId LIMIT 1];
			
			// Get the new member
			CH_Workgroup_Member__c newAssignedMember = [SELECT Id, CH_Role__c, CH_User__r.Id, CH_Queue__c, CH_Workgroup__c   
														FROM CH_Workgroup_Member__c 
														WHERE Id = :memId LIMIT 1];
			
			// If the new member is a user
			if (newAssignedMember.CH_User__r.Id != null){
				User userobj =[SELECT CH_LastCaseAssigned__c From User where Id = :newAssignedMember.CH_User__r.Id Limit 1];		
				userobj.CH_LastCaseAssigned__c = system.now();
				update userobj;
				
				caseObj.OwnerId = userobj.id;
				if(caseObj.status == 'Draft'|| caseObj.status == 'Created'){
					caseObj.status = 'Assigned';
				}
			}
			// If the new member is a queue
			else if (newAssignedMember.CH_Queue__c != null){
				Group grpObj = [select id from group where type='Queue' and name = :newAssignedMember.CH_Queue__c Limit 1];
				queueId = grpObj.Id;
				if(grpObj != null){
					caseObj.OwnerId = queueId;
				}
				if(caseObj.status == 'Draft'){
					caseObj.status = 'Created';
				}				 
			}
			caseObj.CH_Workgroup__c = newAssignedMember.CH_Workgroup__c;
			// Hide the assignment window
			caseObj.CH_Initial_Assignment__c = false; 
			caseObj.CH_Reassignment__c = false; 
			update caseObj;
			
			
			// If a queue assigned
			if (newAssignedMember.CH_Queue__c != null){
				// Send out notifications to queue members
				CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
				helper.notifyQueueMembers(queueId, caseId);
			}
			
		}
		catch (Exception e){
			System.debug('Error occured in User record update in Displayworkgroup class updateSupportTicketOwner.'+e + 'Line Number--'+e.getLineNumber());
			throw e;
		}
	}
		
	//Description - to close assignment component
	@AuraEnabled
	public static void closeCompMethod(string caseId){
		case caseObj = new case(); 
		caseObj = [select CH_Reassignment__c, CH_Initial_Assignment__c from case where Id=:caseId Limit 1];
		if(caseObj!=NULL){
			caseObj.CH_Initial_Assignment__c = false; 
			caseObj.CH_Reassignment__c = false;
			update caseObj;
		}
	}
}