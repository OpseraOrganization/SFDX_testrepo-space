public without sharing class CLM_OpportunityTriggerHelper {
	/**
* @description: Method to create Agreement from Opportunity  
*@Author	   Rajeev Ketha <rajeev.ketha.ext@nokia.com>
* @Group		CLM Services - E2ECLM- 
* @return: void
*/ 
	public static void createContract(Map<ID, Opportunity> optyOldMap, Map<Id, Opportunity> opptyNewMap){
		try{
			Map<ID, Opportunity> optyMap = new Map<ID, Opportunity>();
			Opportunity oldOpty = new Opportunity();
			for(Opportunity opty:opptyNewMap.values()){
				oldOpty = optyOldMap.get(opty.Id);
				if(CLM_GlobalConstants.optyRecordTypeNames.contains(Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).getDescribe().getRecordTypeInfosById().get(opty.RecordTypeId).getName())
				   && (FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_AM_Permission) || 
					   FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_CM_Permission) || Test.isRunningTest())
				   && (oldOpty.StageName != opty.StageName) && opty.StageName == 'Create Offer (Bid)'){
					   optyMap.put(opty.Id,opty); 
				   }
			}
			Map<string,OpportunityTeamMember> optyTeamMap = checkOptyhasLeagalMember(optyMap);
			
			List<CLM_OpportunityFieldsToCopy__c> cloneFieldDetails = CLM_OpportunityFieldsToCopy__c.getall().values();
			Map<string,string> csfieldMap = new Map<string,string>();
			for(CLM_OpportunityFieldsToCopy__c field:cloneFieldDetails){
				csfieldMap.put(field.OpportunityFieldAPI__c ,field.AgreementFieldAPI__c);
			}
			List<Apttus__APTS_Agreement__c> agrmntRecdLst = new List<Apttus__APTS_Agreement__c>();
			
			sObject optySObj = Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).newSObject();
			sObject sObj = Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).newSObject();
			for(Opportunity opty:optyMap.values()){
				optySObj = opty;
				sObj = Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).newSObject() ;
				sObj.put('CLM_Manual_or_Automatic__c', 'Automatic') ;   
				sObj.put('Apttus__Requestor__c', opty.OwnerId) ; 
				sObj.put('RecordTypeId', Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosByDeveloperName().get('ContractRequest').getRecordTypeId());
				for(string s:csfieldMap.Keyset()){
					sObj.put(csfieldMap.get(s), optySObj.get(s)) ;   
					if((optyTeamMap.keySet()).contains(opty.Id)){
						sObj.put('Apttus__Status__c', 'Submitted Request') ;   
						sObj.put('Apttus__Status_Category__c', 'Request') ;
						sObj.put('OwnerId', (optyTeamMap.get(opty.Id)).UserId) ;
					}
				}
				if(CLM_GlobalConstants.optyIndirectRecordtypeName == (Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).getDescribe().getRecordTypeInfosById().get(opty.RecordTypeId).getName())){
					sObj.put('End_Customer__c', opty.End_Customer_LE__c) ; 
				}
				if(CLM_GlobalConstants.optyDirectRecordTypeName == (Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).getDescribe().getRecordTypeInfosById().get(opty.RecordTypeId).getName())){
					sObj.put('End_Customer__c', opty.Legal_Entity__c) ; 
				}
				agrmntRecdLst.add((Apttus__APTS_Agreement__c)sObj);
			}
			if(!agrmntRecdLst.isEmpty()){
				
				List<Apttus__APTS_Agreement__c> createdAgrmnts = new List<Apttus__APTS_Agreement__c>();
				Map<string,Apttus__APTS_Agreement__c> agrmntIdMap = new Map<string,Apttus__APTS_Agreement__c>();
				List<opportunity> failedOptyRecds = new List<opportunity>();
				set<string> userIds = new set<string>(); 
				Database.SaveResult[] srList = Database.insert(agrmntRecdLst, false);
				for(Integer i=0; i<srList.size(); i++){
					
					if (srList[i].isSuccess()) {
						createdAgrmnts.add(agrmntRecdLst[i]);
						 
					}else {
						for(Database.Error err : srList[i].getErrors()) {
							failedOptyRecds.add(optyMap.get(agrmntRecdLst[i].Apttus__Related_Opportunity__c));
							userIds.add(optyMap.get(agrmntRecdLst[i].Apttus__Related_Opportunity__c).OwnerId);
							System.debug('The following error has occurred.');					
							System.debug(err.getStatusCode() + ': ' + err.getMessage());
						}
					}
				}
				Map<Id,user> userMap = getUserDetails(userIds);
				if(!failedOptyRecds.isEmpty()){
					sendEmailToAM(failedOptyRecds,userMap);
				}
				
				if(!createdAgrmnts.isEmpty()){
					for(Apttus__APTS_Agreement__c agrmnt:createdAgrmnts){
						if(agrmnt.Apttus__Status__c == 'Submitted Request'){
							agrmntIdMap.put(agrmnt.Id,agrmnt);
						}
					}
					if(!agrmntIdMap.isEmpty()){
						List<CLM_Agreement_Team__c> agrmntTeam = new List<CLM_Agreement_Team__c>();
						CLM_Agreement_Team__c team = new CLM_Agreement_Team__c();
						CLM_Agreement_Team__c teamAM = new CLM_Agreement_Team__c();
						for(string s:agrmntIdMap.keySet()){
							team = new CLM_Agreement_Team__c();
							team.CLM_Team_Member_Role__c = CLM_GlobalConstants.CMRole;
							team.CLM_Agreement__c = s;
							team.CLM_Team_Member__c = (agrmntIdMap.get(s)).OwnerId;
							team.CLM_Agreement_Access__c = CLM_GlobalConstants.Access_ReadWrite;
							
							teamAM = new CLM_Agreement_Team__c();
							teamAM.CLM_Team_Member_Role__c = CLM_GlobalConstants.AMRole;
							teamAM.CLM_Agreement__c = s;
							teamAM.CLM_Team_Member__c = optyMap.get((agrmntIdMap.get(s)).Apttus__Related_Opportunity__c).OwnerId;
							teamAM.CLM_Agreement_Access__c = CLM_GlobalConstants.Access_Read;
							agrmntTeam.add(teamAM);
							agrmntTeam.add(team);
						}
						if(!agrmntTeam.isEmpty()){
							insert agrmntTeam;
						}
					}
				}
				
			}
		}catch(Exception e){
			system.debug('>>>>>>73==='+e.getLineNumber()+''+e.getMessage());
		}
	}
	
	public static Map<string,OpportunityTeamMember> checkOptyhasLeagalMember( Map<ID, Opportunity> optyMap){
		List<OpportunityTeamMember> optyTeamMemLst = [SELECT Id,TeamMemberRole,OpportunityAccessLevel,UserId,OpportunityId
													  FROM OpportunityTeamMember
													  WHERE OpportunityId IN:optyMap.KeySet() AND TeamMemberRole=:CLM_GlobalConstants.CMRole];
		Map<string,OpportunityTeamMember> optyTeamMap = new Map<string,OpportunityTeamMember>();
		for(OpportunityTeamMember optyMem:optyTeamMemLst){
			optyTeamMap.put(optyMem.OpportunityId,optyMem);
		}
		return optyTeamMap;
	}  
	
	public static  Map<Id,user> getUserDetails(set<string> userIds){
		return new Map<Id,User>([SELECT Name,Email from User Where Id IN:userIds]);
	}
	
	public static void sendEmailToAM(List<opportunity> failedOptyRecds,Map<Id,user> userMap){
		List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		for(opportunity opty:failedOptyRecds){
			mail = new Messaging.SingleEmailMessage();
			mail.toAddresses = new List<string>{userMap.containsKey((opty.OwnerId)) ? userMap.get(opty.OwnerId).Email : ''};
			mail.setSaveAsActivity(false); 
			mail.subject = CLM_GlobalConstants.subjectforContractfailed + opty.Name;
			mail.htmlbody = 'Dear '+ userMap.get(opty.OwnerId).Name +','
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine  
				+'The contract request creation has failed for the opportunity ' +opty.Name+ ' Try creating the request manually. If you are still unable to create, contact the CLM Administrator.'+
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine 
				+'Click '+ '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opty.Id+'">Here</a> to go the opportunity.'
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine
				+'Thanks, '+CLM_GlobalConstants.NextLine;
			
			mailList.add(mail);
		}
		try{
			Messaging.sendEmail( mailList);
		}
		Catch(System.Exception e)
		{
			system.debug('>>>>>>73==='+e.getLineNumber()+''+e.getMessage()); 
		}
	}
}