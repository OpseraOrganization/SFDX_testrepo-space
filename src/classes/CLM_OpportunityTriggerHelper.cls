/**
* @description: Method to create Agreement from Opportunity  
*@Author	   Rajeev Ketha <rajeev.ketha.ext@nokia.com>
* @Group		CLM Services - E2ECLM- 
* @return: void
*/ 
public without sharing class CLM_OpportunityTriggerHelper {
	
	public static void createContract(Map<ID, Opportunity> optyOldMap, Map<Id, Opportunity> opptyNewMap){
		try{
			Map<ID, Opportunity> optyMap = new Map<ID, Opportunity>();
			Map<ID, Opportunity> cmCheckOptyMap = new Map<ID, Opportunity>();
			Map<string,OpportunityTeamMember> optyTeamMap = new Map<string,OpportunityTeamMember>();
			Opportunity oldOpty = new Opportunity();
			List<Opportunity> emailToOwnerOpty = new List<Opportunity>();
			Set<string> accountIDSet = new Set<string>();
			Set<string> queueNames = new Set<string>();
			Map<string,CLM_CBT_CT_Code_Mapping__c> cbtCtCodMap = new Map<string,CLM_CBT_CT_Code_Mapping__c>();
			Map<Id,Account> accDetailsMap = new Map<Id,Account>();
			Map<string,string> accCBTMap = new Map<string,string>();
			Map<string,string> accCBTCodeLabelMap = new Map<string,string>();
			Map<string,Group> grpMap = new Map<string,Group>();
			
			List<CLM_CBT_CT_Code_Mapping__c> cbtCtCodLst = new List<CLM_CBT_CT_Code_Mapping__c>();
			CLM_CBT_CT_Code_Mapping__c codeRecCheck = new CLM_CBT_CT_Code_Mapping__c();
			for(Opportunity opty:opptyNewMap.values()){
				oldOpty = optyOldMap.get(opty.Id);
				if(CLM_GlobalConstants.optyRecordTypeNames.contains(Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).getDescribe().getRecordTypeInfosById().get(opty.RecordTypeId).getName())
				   && (((FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_AM_Permission) || 
						 FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_CM_Permission)))|| Test.isRunningTest()) 
				   && opty.StageName == 'Create Offer (Bid)' && oldOpty.StageName == 'Develop Opportunity'
				   && !opty.Gate_3_Bypass_no_offer_support__c && string.isNotBlank(opty.CLM_Contract_Request_Type__c)
				   && opty.CLM_Contract_Request_Type__c != 'None'
				  ){
					  cmCheckOptyMap.put(opty.Id,opty); 
					  if(string.isNotBlank(opty.AccountId)){
						  accountIDSet.add(opty.AccountId); 
					  }
				  }
			}
			if(cmCheckOptyMap.size()>0){
				optyTeamMap = checkOptyhasLeagalMember(cmCheckOptyMap);
			}
			if(accountIDSet.size()>0){
				accDetailsMap = new Map<Id,Account>([SELECT Id,CBT_CT_Code__c 
													 FROM Account 
													 WHERE Id IN:accountIDSet 
													 AND CBT_CT_Code__c != null]);
				
				String objectName = 'Account';
				String fieldName ='CBT_CT_Code__c';
				
				Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
				Schema.DescribeSObjectResult r = s.getDescribe() ;
				Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
				Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
				List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
				for( Schema.PicklistEntry pickListVal : ple){
					accCBTCodeLabelMap.put(string.valueOf(pickListVal.getValue()),string.valueOf(pickListVal.getLabel()));
				} 
				
				for(Account acc:accDetailsMap.values()){
					if(string.isNotBlank(acc.CBT_CT_Code__c)){
						accCBTMap.put(acc.Id,accCBTCodeLabelMap.get(acc.CBT_CT_Code__c));
					}
				}
				
				
				cbtCtCodLst = [SELECT ID,CLM_L_C_User__c,CLM_L_C_Queue__c,CLM_CBT_CT_Code__c 
							   FROM CLM_CBT_CT_Code_Mapping__c 
							   Where CLM_CBT_CT_Code__c	!= null 
							   AND CLM_CBT_CT_Code__c IN:accCBTMap.values()];
				for(CLM_CBT_CT_Code_Mapping__c codeRec:cbtCtCodLst){
					if(string.isNotBlank(codeRec.CLM_L_C_Queue__c)){
						queueNames.add(codeRec.CLM_L_C_Queue__c);
					}
					cbtCtCodMap.put(codeRec.CLM_CBT_CT_Code__c,codeRec);
				}
				
				List<Group> grpLst = [select id,Name, DeveloperName 
									  FROM Group 
									  WHERE DeveloperName IN:queueNames];
				
				for(Group rec:grpLst){
					grpMap.put(rec.DeveloperName,rec);
				}
				
			}
			
			for(Opportunity opty:opptyNewMap.values()){ 
				oldOpty = optyOldMap.get(opty.Id);
				if(CLM_GlobalConstants.optyRecordTypeNames.contains(Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).getDescribe().getRecordTypeInfosById().get(opty.RecordTypeId).getName())
				   && (((FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_AM_Permission) || 
						 FeatureManagement.checkPermission(CLM_GlobalConstants.CLM_CM_Permission)))|| Test.isRunningTest()) 
				   && opty.StageName == 'Create Offer (Bid)' && oldOpty.StageName == 'Develop Opportunity'
				   && !opty.Gate_3_Bypass_no_offer_support__c && string.isNotBlank(opty.CLM_Contract_Request_Type__c) 
				   && opty.CLM_Contract_Request_Type__c != 'None' 
				  ){
					  optyMap.put(opty.Id,opty);   
				  }
				
			}
			
			if(optyMap.size()>0){
				
				List<CLM_OpportunityFieldsToCopy__c> cloneFieldDetails = CLM_OpportunityFieldsToCopy__c.getall().values();
				Map<string,string> csfieldMap = new Map<string,string>();
				Map<ID,Opportunity> oppDetailMapp = new Map<ID,Opportunity>();
				for(CLM_OpportunityFieldsToCopy__c field:cloneFieldDetails){
					csfieldMap.put(field.OpportunityFieldAPI__c ,field.AgreementFieldAPI__c);
				}
				List<Apttus__APTS_Agreement__c> agrmntRecdLst = new List<Apttus__APTS_Agreement__c>();
				sObject optySObj = Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).newSObject();
				sObject sObj = Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).newSObject();
				for(Opportunity opty:optyMap.values()){
					if((optyTeamMap.containsKey(opty.Id) 
						|| (accCBTMap.containsKey(opty.AccountId) 
							&& (cbtCtCodMap.containsKey(accCBTMap.get(opty.AccountId))))) 
					   && (opty.CLM_Contract_Request_Type__c == 'New Contract' || (opty.CLM_Contract_Request_Type__c == 'Renewal of a Contract' || opty.CLM_Contract_Request_Type__c == 'Changes to a Contract') && string.isNotBlank(opty.CLM_Existing_Contract_Reference__c ))){
						   optySObj = opty;
						   sObj = Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).newSObject() ;
						   for(string s:csfieldMap.Keyset()){
							   sObj.put(csfieldMap.get(s), optySObj.get(s)) ;   
						   }
						   if(!Test.isRunningTest()){
							   sObj.put('CreatedById', opty.OwnerId) ;
						   }
						   sObj.put('CLM_Manual_or_Automatic__c', 'Automatic') ;   
						   sObj.put('Apttus__Requestor__c', opty.OwnerId) ; 
						   sObj.put('CLM_Contract_Category__c', 'Transactional (SSA, Care, etc.)') ; 
						   sObj.put('RecordTypeId', Schema.getGlobalDescribe().get(CLM_GlobalConstants.agrmntAPIName).getDescribe().getRecordTypeInfosByDeveloperName().get('ContractRequest').getRecordTypeId());
						   sObj.put('Apttus__Status__c', 'Submitted Request') ;  
						   sObj.put('Apttus__Request_Date__c',system.today()) ; 
						   sObj.put('Apttus__Status_Category__c', 'Request') ;
						   sObj.put('CLM_Contract_Request_Type__c', opty.CLM_Contract_Request_Type__c) ;
						   
						   if(optyTeamMap.containsKey(opty.Id)){
							   sObj.put('OwnerId',(optyTeamMap.get(opty.Id)).UserId) ;
						   }else{
							   codeRecCheck = cbtCtCodMap.get(accCBTMap.get(opty.AccountId));
							   sObj.put('OwnerId',string.isNotBlank(codeRecCheck.CLM_L_C_Queue__c) ? grpMap.get(codeRecCheck.CLM_L_C_Queue__c).Id : codeRecCheck.CLM_L_C_User__c);
						   }
						   if(CLM_GlobalConstants.optyIndirectRecordtypeName == (Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).getDescribe().getRecordTypeInfosById().get(opty.RecordTypeId).getName())){
							   sObj.put('End_Customer__c', opty.End_Customer_LE__c) ; 
						   }
						   if(CLM_GlobalConstants.optyDirectRecordTypeName == (Schema.getGlobalDescribe().get(CLM_GlobalConstants.optyAPIName).getDescribe().getRecordTypeInfosById().get(opty.RecordTypeId).getName())){
							   sObj.put('End_Customer__c', opty.Legal_Entity__c) ; 
						   }
						   agrmntRecdLst.add((Apttus__APTS_Agreement__c)sObj);
					   }else{
						   emailToOwnerOpty.add(opty);
					   }
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
								system.debug('>>>>>>72==='+err.getStatusCode()+''+err.getMessage());
								failedOptyRecds.add(optyMap.get(agrmntRecdLst[i].Apttus__Related_Opportunity__c));
								userIds.add(optyMap.get(agrmntRecdLst[i].Apttus__Related_Opportunity__c).OwnerId);
								
							}
						}
					}
					Map<Id,user> userMap = CLM_AgrmntCustomActionsCtrl.getUserDetails(userIds);
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
								if(String.ValueOf((Id.ValueOf(agrmntIdMap.get(s).OwnerId)).getsobjectType()) != CLM_GlobalConstants.groupAPIName){
									team = new CLM_Agreement_Team__c();
									team.CLM_Team_Member_Role__c = CLM_GlobalConstants.CMRole;
									team.CLM_Agreement__c = s;
									team.CLM_Team_Member__c = agrmntIdMap.get(s).OwnerId;
									team.CLM_Agreement_Access__c = CLM_GlobalConstants.Access_ReadWrite;
									agrmntTeam.add(team);
								}
								
								teamAM = new CLM_Agreement_Team__c();
								teamAM.CLM_Team_Member_Role__c = CLM_GlobalConstants.AMRole;
								teamAM.CLM_Agreement__c = s;
								teamAM.CLM_Team_Member__c =  optyMap.get((agrmntIdMap.get(s)).Apttus__Related_Opportunity__c).OwnerId;
								teamAM.CLM_Agreement_Access__c = CLM_GlobalConstants.Access_Read;
								agrmntTeam.add(teamAM);
								
							}
							if(!agrmntTeam.isEmpty()){
								insert agrmntTeam;
							}
						}
					}
					
				}
				
				if(emailToOwnerOpty.size()>0){
					Set<string> optyOwnerIds = new Set<string>();
					for(Opportunity opty:emailToOwnerOpty){
						optyOwnerIds.add(opty.OwnerId);
					}
					Map<Id,user> ownerUsersMap = CLM_AgrmntCustomActionsCtrl.getUserDetails(optyOwnerIds);
					sendEmailToOptyOwner(emailToOwnerOpty,ownerUsersMap);
				}
			}
			
			
		}catch(Exception e){
			system.debug('>>>>>>73==='+e.getLineNumber()+''+e.getMessage());
		}
	}
	
	public static Map<string,OpportunityTeamMember> checkOptyhasLeagalMember( Map<ID, Opportunity> optyMap){
		List<OpportunityTeamMember> optyTeamMemLst = [SELECT Id,TeamMemberRole,OpportunityId,OpportunityAccessLevel,UserId
													  FROM OpportunityTeamMember
													  WHERE OpportunityId IN:optyMap.KeySet() AND TeamMemberRole=:CLM_GlobalConstants.CMRole];
		Map<string,OpportunityTeamMember> optyTeamMap = new Map<string,OpportunityTeamMember>();
		for(OpportunityTeamMember optyMem:optyTeamMemLst){
			optyTeamMap.put(optyMem.OpportunityId,optyMem);
		}
		return optyTeamMap;
	}  
	
	public static void sendEmailToAM(List<opportunity> failedOptyRecds,Map<Id,user> userMap){
		List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		OrgWideEmailAddress orgWideEmailAddress = [SELECT Id,Address FROM OrgWideEmailAddress where Address = 'clm.services@nokia.com' Limit 1];
		for(opportunity opty:failedOptyRecds){
			mail = new Messaging.SingleEmailMessage();
			mail.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
			mail.toAddresses = new List<string>{userMap.containsKey((opty.OwnerId)) ? userMap.get(opty.OwnerId).Email : ''};
				mail.setSaveAsActivity(false); 
			mail.subject = CLM_GlobalConstants.subjectforContractfailed +'-'+ opty.Name;
			mail.htmlbody = 'Dear '+ userMap.get(opty.OwnerId).Name +','
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine  
				+'The contract request creation has failed for the opportunity ' +opty.Name+ ' Try creating the request manually. If you are still unable to create, contact the CLM Administrator.'+
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine 
				+'Click '+ '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opty.Id+'">here</a> to go the opportunity.'
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine
				+'Thanks, '+CLM_GlobalConstants.NextLine;
			
			mailList.add(mail);
		}
		try{
			Messaging.sendEmail( mailList);
		}
		Catch(System.Exception e)
		{
			system.debug('>>>>>>200==='+e.getLineNumber()+''+e.getMessage()); 
		}
	}
	
	public static void sendEmailToOptyOwner(List<opportunity> failedOptyRecds,Map<Id,user> userMap){
		OrgWideEmailAddress orgWideEmailAddress = [SELECT Id,Address FROM OrgWideEmailAddress where Address = 'clm.services@nokia.com' Limit 1];
		List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		for(opportunity opty:failedOptyRecds){
			mail = new Messaging.SingleEmailMessage();
			mail.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
			mail.toAddresses = new List<string>{userMap.containsKey((opty.OwnerId)) ? userMap.get(opty.OwnerId).Email : ''};
				mail.setSaveAsActivity(false); 
			mail.subject = CLM_GlobalConstants.subjectforContractfailed +'-'+ opty.Name;
			mail.HtmlBody =  'Hello '+ userMap.get(opty.OwnerId).Name +','
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine  
				+'  Contract Request for the following opportunity is not created as one or more of the following reasons '
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine
				+' 1. Opportunity Team does not have Commercial Contract Manager '+
				+CLM_GlobalConstants.NextLine 
				+' 2. If Contract Request Type = Renewal of a contract or Changes to a contract, you need to '+
				+CLM_GlobalConstants.NextLine 
				+'provide a value to Existing Contract Reference '+
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine
				+'You will have to create the contract request now manually after populating the above information.'+
				+CLM_GlobalConstants.NextLine 
				+'   Click <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opty.Id+'">here</a> to go the opportunity.'+
				+CLM_GlobalConstants.NextLine
				+'If you further face issues, please contact the <a href="mailto:'+orgWideEmailAddress.Address+'">CLM Services</a>  '
				+CLM_GlobalConstants.NextLine +CLM_GlobalConstants.NextLine
				+'Thanks, '+CLM_GlobalConstants.NextLine;
			
			mailList.add(mail);
		}
		try{
			Messaging.sendEmail( mailList);
		}
		Catch(System.Exception e)
		{
			system.debug('>>>>>>241==='+e.getLineNumber()+''+e.getMessage()); 
		}
	}  
	
	
}