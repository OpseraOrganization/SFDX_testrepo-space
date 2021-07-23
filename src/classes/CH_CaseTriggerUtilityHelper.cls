/****************************************
* Class Name : CH_CaseTriggerUtilityHelper
* Created Date: 2 July 2019
* Created By : Rajeshwari - Nokia 
* Last Modified by: Rajeshwari - Nokia 
* Last Modified Date: 2 July 2019
* Description : Handle the sequence of the CaseTriggerHelper
* Test Class: CH_CaseTriggerUtilityHelperTest
*****************************************/
public class CH_CaseTriggerUtilityHelper { 
	public static map<String,USer> ouserMap = new map<string,USer>();
	public static map<String,String> oldOwnerCase = new map<string,String>();
	public static map<string, CAseTeamMember> caseDetail = new map<string,CAseTeamMember>();
	public static map<string, CH_CaseTeamHistory__c> existCaseTeamHistoryMap = new map<string, CH_CaseTeamHistory__c> ();
	/***************************************************************
*Method Name: getOwnerBasedCase
*Parameter: newCaseList, oldCaseMap
*Description: Method to create create CH_CAseTeamHistory on change of cAse owner
This method is to get all owner ID of each case whenevr CAse owner is changed from Queue to user/User to User
*******************************************************************/
	public static void getOwnerBasedCase(List<Case> newCaseList , map<id, case> oldCaseMap){
		system.debug('createCaseTeamHistory  Method starts here ');
		List<case> ownerNewCaseList = new List<case>();
		List<case> ownerOldCaseList = new List<case>();
		set<String> oldCaseId = new set<String>();
		set<String> caseId = new set<String>();
		set<String> caseOwnerID = new set<String>();
		set<String> caseOldOwnerID = new set<String>();	
		//Added the newCaseOwnerId inorder to get the new case owner Id
		set<String> newCaseOwnerId = new set<String>();	
		set<string> chRecordType = new set<string>(); 
		Map<String, Schema.RecordTypeInfo> caseRecordTypes = Schema.SObjectType.Case.getRecordTypeInfosByName();
		chRecordType.add(caseRecordTypes.get('Nokia Incident with Restoration').getRecordTypeId());
		chRecordType.add(caseRecordTypes.get('Nokia Information Request').getRecordTypeId());
		chRecordType.add(caseRecordTypes.get('Nokia Standard Case').getRecordTypeId());
		chRecordType.add(caseRecordTypes.get('Problem').getRecordTypeId());
		for(case newCase : newCaseList){
			if(newCase.ownerId!=null && newCase.ownerId!=oldCaseMap.get(newCase.Id).ownerId && chRecordType.contains(newCase.RecordTypeId)){
				caseOwnerID.add(newCase.ownerId);
				caseId.add(newCase.Id);
				newCaseOwnerId.add(newCase.ownerId);
				if(string.valueOf(newCase.OwnerId).startsWith('005')){
					ownerNewCaseList.add(newCase);
				}
				if(string.valueOf(oldCaseMap.get(newCase.Id).OwnerId).startsWith('005')){
					caseOwnerID.add(oldCaseMap.get(newCase.Id).ownerId);
					oldOwnerCase.put(newCase.Id, oldCaseMap.get(newCase.Id).ownerId);
					ownerOldCaseList.add(newCase);
					oldCaseId.add(newCase.Id);
					caseOldOwnerID.add(oldCaseMap.get(newCase.Id).ownerId);
				}
			}
			
		}
		if(ownerOldCaseList!=null || !ownerNewCaseList.isempty()){
			getCaseOwnerDetails(caseOwnerID,  caseID);   
			
			if(!ownerNewCaseList.isempty()){
				createCaseTeamHistory(ownerNewCaseList, false, oldCaseMap, caseId,newCaseOwnerId);
			}
			
		}
		system.debug('createCaseTeamHistory  Method starts here ');
	}
	/***************************************************************
*Method Name: getOwnerBasedCase
*Parameter: newCaseList, oldCaseMap
*Description: Method to create create CH_CAseTeamHistory on change of cAse owner
******************************************************************/
	public static void createCaseTeamHistory(List<case> ownerCaseList , Boolean modify, map<id, case> oldCaseMap, set<String> caseIdSet ,set<string> newCaseOwnerId ){
		system.debug('createCaseTeamHistory  Method starts here '+modify);
		List<CH_CaseTeamHistory__c	> caseHistoryUpsertList = new List<CH_CaseTeamHistory__c>();
		map<string,case> caseForWorkGroup = new map<string,case> ( [select id , CH_Workgroup__c, CH_Workgroup__r.Name from case where id = :caseIdSet]);
		set<String>ochMap = new set <string> ();
		for (CH_CaseTeamHistory__c ctHistory :[select id, name, Support_Ticket__c,  CH_CaseTeamExit__c from CH_CaseTeamHistory__c
											   where Support_Ticket__c in :caseIdSet and CH_CaseTeamExit__c = null and OwnerId in :newCaseOwnerId
											   and CH_CaseTeamRole__c = 'Case Owner']){
												   ochMap.add(ctHistory.Support_Ticket__c);
											   }
		for(case objCase : ownerCaseList){
			string caseId = string.Valueof(objCase.Id);
			string strCaseNOwner = string.Valueof(objCase.OwnerID) + caseId;
			user oUser = ouserMap.get(objCase.OwnerID);
			
			Datetime cDT = System.now();
			
			if(!modify){
				if(ochMap==null || (ochMap!=null && !ochMap.contains(objCase.id))){
					CH_CaseTeamHistory__c caseHistoryObj = new CH_CaseTeamHistory__c();
					caseHistoryObj.CH_CaseTeamEntry__c = cDT;
					caseHistoryObj.CH_CaseTeamNokiaID__c =oUser.Nokia_ID__c;
					caseHistoryObj.CH_CaseTeamOwner__c =oUser.Name;
					caseHistoryObj.CH_CaseTeamRole__c = 'Case Owner';
					if(caseForWorkGroup.get(objCase.id).CH_Workgroup__c !=null){
						caseHistoryObj.CH_CaseTeamWorkgroup__c =caseForWorkGroup.get(objCase.id).CH_Workgroup__r.Name;
					}
					caseHistoryObj.OwnerId =oUser.ID;
					caseHistoryObj.Support_Ticket__c =objCase.Id;
					caseHistoryUpsertList.add(caseHistoryObj);
				}
			}
			if(oldOwnerCase !=null && oldOwnerCase.get(objCase.Id) !=null){
				CH_CaseTeamHistory__c caseHistoryObjUpdate = new CH_CaseTeamHistory__c();
				strCaseNOwner = string.Valueof(oldCaseMap.get(objCase.Id).OwnerID) + caseId;
				oUser = ouserMap.get(oldCaseMap.get(objCase.Id).OwnerID);
				caseHistoryObjUpdate.CH_CaseTeamNokiaID__c =oUser.Nokia_ID__c;
				caseHistoryObjUpdate.CH_CaseTeamRole__c ='Case Owner';
				caseHistoryObjUpdate.CH_CaseTeamExit__c = cDT;
				caseHistoryObjUpdate.OwnerId =oUser.ID;
				caseHistoryObjUpdate.CH_CaseTeamOwner__c =oUser.Name;
				caseHistoryObjUpdate.Support_Ticket__c =objCase.Id;
				if(caseForWorkGroup.get(objCase.id).CH_Workgroup__c !=null){
					caseHistoryObjUpdate.CH_CaseTeamWorkgroup__c =caseForWorkGroup.get(objCase.id).CH_Workgroup__r.Name;
				}
				if(!existCaseTeamHistoryMap.isEmpty()){
					CH_CaseTeamHistory__c objcaseHist = existCaseTeamHistoryMap.get(oldCaseMap.get(objCase.Id).OwnerID + 'Case Owner'+caseId);
					if(objcaseHist !=null && objcaseHist.Id!=null){
						caseHistoryObjUpdate.id = objcaseHist.Id;
					}else{
						caseHistoryObjUpdate.CH_CaseTeamEntry__c =cDT;
					}
				}else{
					caseHistoryObjUpdate.CH_CaseTeamEntry__c =cDT;
				}
				caseHistoryUpsertList.add(caseHistoryObjUpdate);
			}
		}
		if(!caseHistoryUpsertList.isempty()){
			upsert caseHistoryUpsertList;
		}
		system.debug('createCaseTeamHistory  Method ends here '+caseHistoryUpsertList);
	}
	/***************************************************************
*Method Name: getOwnerBasedCase
*Parameter: newCaseList, oldCaseMap
*Description: Method to get Owner Details wrt Case Team Member /USer to get Nokia Id, role etc..
*************************************************************************************************/
	public static void getCaseOwnerDetails(set<String> caseOwnerID, set<String> caseID){
		system.debug('getCaseOwnerDetails  Method ends here '+caseOwnerID);
		map<id, user> caseOwnerDetailMap = new map<id,user>();
		caseDetail = new map<string,CAseTeamMember>();
		if(caseOwnerID !=null && !caseOwnerID.isempty()){
			getCaseTeamHistoryDetails(caseId, caseOwnerID);
			//Using Global/Common query as part of Code Optimization -- 27619 --> By Satya Pagadala
			ouserMap = CH_Utils.getUserMap(caseOwnerID);
		}		
		system.debug('getCaseOwnerDetails  Method ends here ');
	}
	/***************************************************************
*Method Name: getCaseTeamHistoryDetails
*Parameter: oldCaseID, caseOldOwnerID
*Description: Method to get Existing CH_CaseTeamHistory__c wrt Case Owner ID and case ID.
******************************************************************/
	public static map<string, CH_CaseTeamHistory__c> getCaseTeamHistoryDetails(set<String> oldCaseID,  set<String> caseOldOwnerID){
		system.debug('getCaseTeamHistoryDetails  Method starts here '+oldCaseID+caseOldOwnerID);
		existCaseTeamHistoryMap = new map<string, CH_CaseTeamHistory__c> ();
		List<CH_CaseTeamHistory__c> objCAseTeamHistory = [select id, ownerID, Support_Ticket__c, CH_CaseTeamExit__c ,CH_CaseTeamEntry__c,CH_CaseTeamRole__c 
														  from CH_CaseTeamHistory__c
														  where ownerID in : caseOldOwnerID 
														  and Support_Ticket__c in :oldCaseID
														  and CH_CaseTeamExit__c =null ];
		for(CH_CaseTeamHistory__c cHist : objCAseTeamHistory){
			string histKey = cHist.ownerID + cHist.CH_CaseTeamRole__c + cHist.Support_Ticket__c;
			existCaseTeamHistoryMap.put(histKey, cHist);
		}
		system.debug('getCaseTeamHistoryDetails  Method ends here ');
		return existCaseTeamHistoryMap;
	}
	/***************************************************************
*Method Name: updateCaseHistory
*Parameter: newCaseList, oldCaseMap
*Description: Update  CH_CaseTeamHistory__c CH_CaseTeamExit__c Field for closed Case.
******************************************************************/
	public static void updateCaseHistory(List<Case> newCaseList , map<id, case> oldCaseMap){
		set<String> caseID = new set<String>();
		for(case newCase : newCaseList){
			if(newCase.Status =='Closed' && newCase.Status!=oldCaseMap.get(newCase.Id).Status){
				caseID.add(newCase.Id);
			}
		}
		if(!caseID.isempty()){
			List<CH_CaseTeamHistory__c> objCAseTeamHistory = new List<CH_CaseTeamHistory__c>();
			for(CH_CaseTeamHistory__c cHist :  [select id, ownerID, Support_Ticket__c, CH_CaseTeamExit__c ,CH_CaseTeamEntry__c
												from CH_CaseTeamHistory__c
												where 
												Support_Ticket__c in :caseID
												and CH_CaseTeamExit__c =null ]){
													cHist.CH_CaseTeamExit__c = System.now();
													objCAseTeamHistory.add(cHist);
												}
			if(!objCAseTeamHistory.isempty()){
				update objCAseTeamHistory;
			}
		}
		
	}
	/***************************************************************
*Method Name: createCaseTeamHistoryOnAddingTeam
*Parameter: userId, caseId, selectedRole
*Description: create  CH_CaseTeamHistory__c record whenever new member is added to the case.
This Functionality is triggerd from UI
******************************************************************/
	public static void createCaseTeamHistoryOnAddingTeam(Id userId, Id caseId, String selectedRole){
		system.debug('createCaseTeamHistoryOnAddingTeam Method starts here '+userId+caseId+selectedRole);
		Case objCase = [select id, CH_Workgroup__c, CH_Workgroup__r.Name from case where id = : caseId];
		user oUSer = [select id, name , Nokia_ID__c from user where id =:userId];
		CH_CaseTeamHistory__c caseHistoryObj = new CH_CaseTeamHistory__c();
		caseHistoryObj.CH_CaseTeamEntry__c = System.now();
		caseHistoryObj.CH_CaseTeamNokiaID__c =oUser.Nokia_ID__c;
		caseHistoryObj.CH_CaseTeamOwner__c =oUser.Name;
		caseHistoryObj.CH_CaseTeamRole__c = selectedRole; 
		if(objCase.CH_Workgroup__c !=null){
			caseHistoryObj.CH_CaseTeamWorkgroup__c =objCase.CH_Workgroup__r.Name;
		}
		caseHistoryObj.OwnerId =oUser.ID;
		caseHistoryObj.Support_Ticket__c =objCase.Id;
		insert caseHistoryObj;
		system.debug('createCaseTeamHistoryOnAddingTeam Method ends here '+caseHistoryObj);
	}
	/***************************************************************
*Method Name: createCaseTeamHistoryOnCaseCreation
*Parameter: membersForCaseTeam
*Description: create  CH_CaseTeamHistory__c record during case creation, If any case team member is added from Account
******************************************************************/
	public static void createCaseTeamHistoryOnCaseCreation(List<CaseTeamMember> membersForCaseTeam){
		system.debug('createCaseTeamHistoryOnAddingTeam Method starts here '+membersForCaseTeam);
		List<CH_CaseTeamHistory__c> caseTeamHistoryUpsert = new List<CH_CaseTeamHistory__c>();
		if(membersForCaseTeam !=null && !membersForCaseTeam.isempty()){
			set<string> caseId = new set<string>();
			set<string> userId = new set<string>();
			set<string> caseRoleId = new set<string>();
			set<string> casetmID = new set<string>();
			map<string,string> caseOwnerMap = new map<string, string>();
			for(CaseTeamMember ocst : membersForCaseTeam){
				system.debug('CaseTeamMember ocst'+ocst);
				casetmID.add(ocst.Id);
			}
			List<CaseTeamMember> membersForCaseTeamQuery =[select id,parentID,parent.CH_Workgroup__r.Name, 
														   parent.CH_Workgroup__c , memberID ,parent.OwnerID, 
														   TeamRoleId,TeamRole.Name, member.Name from CaseTeamMember where id in :casetmID];
			for(CaseTeamMember ocst : membersForCaseTeamQuery){
				system.debug('CaseTeamMember ocst membersForCaseTeamQuery'+ocst);
				caseId.add(ocst.parentID);
				userId.add(ocst.memberID);
				caseRoleId.add(ocst.TeamRoleId);
				if(string.valueOf(ocst.parent.OwnerID).startsWith('005')){
					caseOwnerMap.put(ocst.parentID, ocst.parent.OwnerID);
					userId.add(ocst.parent.OwnerID);
				}
				
			}
			map<string,Case >objCase = new map<string,Case >([select id, CH_Workgroup__c, CH_Workgroup__r.Name, ownerID
															  from case where id = : caseId]);
			map<string,user > oUSer = new map<string,USer >( [select id, name , Nokia_ID__c from user where id =:userId]);
			map<string,CaseTeamRole > oCaseTeamRole = new map<string,CaseTeamRole >( [select id, name  from CaseTeamRole where id =:caseRoleId]);
			set<string > caseTeamHistoryId = new  set<string >();
			for(CH_CaseTeamHistory__c och : [select id, name, Support_Ticket__c,  CH_CaseTeamExit__c from CH_CaseTeamHistory__c
											 where Support_Ticket__c =:caseId and CH_CaseTeamExit__c = null
											 and CH_CaseTeamRole__c = 'Case Owner']){
												 caseTeamHistoryId.add(och.Support_Ticket__c);
											 }
			for(CaseTeamMember ocst : membersForCaseTeamQuery){
				CH_CaseTeamHistory__c caseHistoryObj = new CH_CaseTeamHistory__c();
				caseHistoryObj.CH_CaseTeamEntry__c = System.now();
				caseHistoryObj.CH_CaseTeamNokiaID__c =oUser.get(ocst.memberId).Nokia_ID__c;
				caseHistoryObj.CH_CaseTeamOwner__c =oUser.get(ocst.memberId).Name;
				caseHistoryObj.CH_CaseTeamRole__c = ocst.TeamRole.Name;
				if(ocst.TeamRole !=null){
					caseHistoryObj.CH_CaseTeamRole__c = ocst.TeamRole.Name;
				}
				
				if(objCase.get(ocst.parentId).CH_Workgroup__c !=null){
					caseHistoryObj.CH_CaseTeamWorkgroup__c =objCase.get(ocst.parentId).CH_Workgroup__r.Name;
				}
				caseHistoryObj.OwnerId =ocst.memberID;
				caseHistoryObj.Support_Ticket__c =ocst.parentId;
				caseTeamHistoryUpsert.add(caseHistoryObj);
				/*
if( (userId !=null && userId.contains(ocst.parent.OwnerID)) && (caseTeamHistoryId == null || (caseTeamHistoryId !=null && !caseTeamHistoryId.contains(ocst.parentId)))){
CH_CaseTeamHistory__c caseHistoryObjOwner = new CH_CaseTeamHistory__c();
caseHistoryObjOwner.CH_CaseTeamEntry__c = System.now();
caseHistoryObjOwner.CH_CaseTeamNokiaID__c =oUser.get(ocst.parent.OwnerID).Nokia_ID__c;
caseHistoryObjOwner.CH_CaseTeamOwner__c =oUser.get(ocst.parent.OwnerID).Name;
caseHistoryObjOwner.CH_CaseTeamRole__c = 'Case Owner';
if(objCase.get(ocst.parentId).CH_Workgroup__c !=null){
caseHistoryObjOwner.CH_CaseTeamWorkgroup__c =objCase.get(ocst.parentId).CH_Workgroup__r.Name;
}
caseHistoryObjOwner.OwnerId =ocst.parent.OwnerID;
caseHistoryObjOwner.Support_Ticket__c =ocst.parentId;
caseTeamHistoryUpsert.add(caseHistoryObjOwner);
}
*/
			}
			for(String csteamCaseId : caseOwnerMap.Keyset() ){
				if (userId !=null && userId.contains(caseOwnerMap.get(csteamCaseId)) && (caseTeamHistoryId == null || (caseTeamHistoryId !=null && !caseTeamHistoryId.contains(csteamCaseId)))){
					CH_CaseTeamHistory__c caseHistoryObjOwner = new CH_CaseTeamHistory__c();
					caseHistoryObjOwner.CH_CaseTeamEntry__c = System.now();
					caseHistoryObjOwner.CH_CaseTeamNokiaID__c =oUser.get(caseOwnerMap.get(csteamCaseId)).Nokia_ID__c;
					caseHistoryObjOwner.CH_CaseTeamOwner__c =oUser.get(caseOwnerMap.get(csteamCaseId)).Name;
					caseHistoryObjOwner.CH_CaseTeamRole__c = 'Case Owner';
					if(objCase.get(csteamCaseId).CH_Workgroup__c !=null){
						caseHistoryObjOwner.CH_CaseTeamWorkgroup__c =objCase.get(csteamCaseId).CH_Workgroup__r.Name;
					}
					caseHistoryObjOwner.OwnerId =caseOwnerMap.get(csteamCaseId);
					caseHistoryObjOwner.Support_Ticket__c =csteamCaseId;
					caseTeamHistoryUpsert.add(caseHistoryObjOwner);
				}
			}
			system.debug('createCaseTeamHistoryOnAddingTeam Method ends here '+caseTeamHistoryUpsert);
			if(!caseTeamHistoryUpsert.isempty()){
				upsert caseTeamHistoryUpsert;
			}
		}
	}
	
	public static void updateExitTimeCaseHistory(CaseTeamMember caseMember){
		system.debug(' updateExitTimeCaseHistory Method Starts here -->');
		try{
			List<CH_CaseTeamHistory__c> objCaseTeamHistory = [select id, ownerID, Support_Ticket__c, CH_CaseTeamExit__c ,CH_CaseTeamEntry__c
															  from CH_CaseTeamHistory__c
															  where 
															  ownerID = :caseMember.MemberId and 
															  Support_Ticket__c = :caseMember.ParentId
															  and CH_CaseTeamExit__c =null and CH_CaseTeamRole__c = :caseMember.TeamRole.Name];
			if(objCaseTeamHistory!=null && !objCaseTeamHistory.isempty()){
				objCAseTeamHistory[0].CH_CaseTeamExit__c = System.now();  
				update objCAseTeamHistory[0];
			}
		}
		catch(Exception ex){
			system.debug(' updateExitTimeCaseHistory Exception -->'+ex);
		}
		system.debug(' updateExitTimeCaseHistory Method ends here -->');
	}
	
	/*public static void createProductChatterGroupOnUpdate(List<Case> newCaseList, map<id, case> oldCaseMap){
system.debug('createProductChatterGroupOnUpdate Method starts here -->'+newCaseList);
set<string> buUnitStr = new set<string>();
Boolean isOutageChanged = false;
Boolean isSeverityChanged = false;
for(Case objCase : newCaseList){
if(objCase.CH_BusinessUnit__c !=null && ((objCase.Severity__c =='Critical' && oldCaseMap.get(objCase.Id).Severity__c !='Critical')
||( (objCase.CH_Outage__c =='Yes' && oldCaseMap.get(objCase.Id).CH_Outage__c !='Yes') ||
(objCase.CH_ServiceType__c =='Customer Support' &&  oldCaseMap.get(objCase.Id).CH_ServiceType__c =='Customer Support')
)
) ){
buUnitStr.add(objCase.CH_BusinessUnit__c); 
if(objCase.Severity__c =='Critical' && oldCaseMap.get(objCase.Id).Severity__c !='Critical'){
isSeverityChanged = true;
}
if( (objCase.CH_Outage__c =='Yes' && oldCaseMap.get(objCase.Id).CH_Outage__c !='Yes') ||
(objCase.CH_ServiceType__c =='Customer Support' &&  oldCaseMap.get(objCase.Id).CH_ServiceType__c !='Customer Support')
){
isOutageChanged = true;		 
} 

}
}
postMessageInChatterGroup(newCaseList, buUnitStr, isSeverityChanged, isOutageChanged);
system.debug('createProductChatterGroupOnUpdate Method ends here -->'+newCaseList);
}*/
	
	public static map<string,string>  getChatterGroup(set<string> buUnitStr ){
		map<string,string> chatterGroupMap = new map<string,string> ();
		if(!buUnitStr.isempty()){
			List<CollaborationGroup> CollaborationGroupList = [select Id, Name, Description, InformationBody, 
															   InformationTitle from CollaborationGroup
															   where name in : buUnitStr ];
			system.debug(CollaborationGroupList.size()+' CollaborationGroupList --> '+CollaborationGroupList);
			if(!CollaborationGroupList.isempty()){
				for(CollaborationGroup cg : CollaborationGroupList ){
					chatterGroupMap.put(cg.Name, cg.id);
				} 
			}
			set<string> newBuList = new set<String>();
			for(string bu : buUnitStr){
				if(chatterGroupMap !=null && chatterGroupMap.containsKey(bu)){
				}else{
					newBuList.add(bu);
				}
			}
			system.debug('@@@ newBuList'+newBuList);
			if(!newBuList.isempty()){
				List<CollaborationGroup> newChatterGroup = new List<CollaborationGroup>();
				for(String newBu : newBuList){
					CollaborationGroup newGroup = new CollaborationGroup(Name=newBu, CollaborationType='Public');
					newChatterGroup.add(newGroup);
				}
				insert newChatterGroup;
				system.debug(' @@ newChatterGroup'+newChatterGroup);
				for(CollaborationGroup newCg : newChatterGroup){
					chatterGroupMap.put(newCg.Name,newCg.id);
				}
			}
		}
		return chatterGroupMap;
	}
	
	public static void postMessageInChatterGroup(List<Case> newCaseList, set<string> buUnitStr, Boolean isSeverityChanged,Boolean isOutageChanged,String eventType){
		String className='CH_CaseTriggerUtilityHelper';
		String methodName='postMessageInChatterGroup';
		String methodRunType='QUEUEABLE';
		if(!buUnitStr.isempty()){
			map<string,string> chatterGroupMap = getChatterGroup( buUnitStr );
			List<FeedItem> oFeedItemList = new List<FeedItem>();
			for(case objCase : newCaseList){
				String bodySeverity = 'The Case '+objCase.CaseNumber+' for this product '+objCase.CH_Product_Name__c+'  has been  identified as Critical. #Critical \r\n';
				String bodyOutage = 'The Case '+objCase.CaseNumber+' for this product '+objCase.CH_Product_Name__c+'  has been marked as an Outage. #Outage \r\n';
				String body =  ' Case Details:  \r\n';
				body = body + ' Reported to Nokia: '+ objCase.CreatedDate +' (in User Timezone) \r\n';
				body = body + ' Service Type: '+ objCase.CH_ServiceType__c +' \r\n';
				body = body + ' Severity: '+ objCase.Severity__c +' \r\n';
				body = body + ' Outage: '+ objCase.CH_Outage__c +' \r\n';
				body = body + ' Customer: '+ objCase.CH_Account_Name__c +' \r\n';
				body = body + ' Product Business Unit: '+ objCase.CH_BusinessUnit__c +' \r\n';
				body = body + ' Product: '+ objCase.CH_Product_Name__c +' \r\n';
				body = body + ' External Bridge Number: '+ objCase.CH_ExternalBridge__c +' \r\n';
				body = body + ' Country: '+ objCase.Country__c +' \r\n';
				
				String bodyDetails = body.replace('null', '');
				
				if((objCase.CH_BusinessUnit__c !=null && objCase.Severity__c =='Critical') && isSeverityChanged){
					FeedItem oFeedItemSeverity = new FeedItem(Body=bodySeverity+bodyDetails, ParentId = chatterGroupMap.get(objCase.CH_BusinessUnit__c), Type='TextPost');
					oFeedItemList.add(oFeedItemSeverity);
				}
				if((objCase.CH_BusinessUnit__c !=null && objCase.CH_Outage__c =='Yes' && objCase.CH_ServiceType__c =='Customer Support')  && isOutageChanged){
					FeedItem oFeedItemOutage = new FeedItem(Body=bodyOutage +bodyDetails, ParentId = chatterGroupMap.get(objCase.CH_BusinessUnit__c), Type='TextPost');
					oFeedItemList.add(oFeedItemOutage);
				}
			}
			Database.SaveResult[] srList = Database.insert(oFeedItemList,false);
			for(Integer index = 0, size = srList.size(); index < size; index++){
				if(!srList[index].isSuccess()){
					List<CollaborationGroup> cgList = CH_ErrorLogUtils.getErrorLogChatterGroup();
					Id errorchatterGroupId;
					if(!cgList.isEmpty()){
						errorchatterGroupId = cgList[0].Id;
					}
					for(Database.Error err: srList.get(index).getErrors()){
						String chatterBody = CH_ErrorLogUtils.createChatterbody(className,methodName,err);
						String recId;
						if(oFeedItemList[index].id!=Null &&oFeedItemList[index].id!=''){
							recId =  oFeedItemList[index].id; 
						}else{
							recId = ''; 
						}
						ErrorLog__c newErrorLog = New ErrorLog__c();
						FeedItem newChatterPost = new FeedItem();
						newErrorLog = CH_ErrorLogUtils.createErrorLog(err.getMessage(),className,methodName, eventType,methodRunType,recId);
						newChatterPost = CH_ErrorLogUtils.postToErrorLogChatGroup(errorchatterGroupId,chatterBody);
						CH_CaseProcessQueueable.errorList.add(newErrorLog);
						CH_CaseProcessQueueable.chatterPostList.add(newChatterPost);
					}
				}
				
			}
		}
	}
	/*public static void createProductChatterGroup(List<Case> newCaseList){
system.debug('createProductChatterGroup Method starts here -->'+newCaseList);
set<string> buUnitStr = new set<string>();
Boolean isOutageChanged = false;
Boolean isSeverityChanged = false;
for(case objCase : newCaseList){
if(objCase.CH_BusinessUnit__c !=null && (objCase.Severity__c =='Critical' || (objCase.CH_Outage__c =='Yes' && objCase.CH_ServiceType__c =='Customer Support'))){
buUnitStr.add(objCase.CH_BusinessUnit__c);
if(objCase.Severity__c =='Critical'){
isSeverityChanged = true;
}
if(objCase.CH_Outage__c =='Yes' && objCase.CH_ServiceType__c =='Customer Support'){
isOutageChanged = true;
}
}
}
postMessageInChatterGroup(newCaseList, buUnitStr, isSeverityChanged, isOutageChanged);
system.debug('createProductChatterGroup Method ends here -->'+newCaseList);
}*/
	public static void createProductChatterGroup(List<Case> newCaseList, map<id, case> oldCaseMap,String eventType){
		system.debug('createProductChatterGroupOnUpdate Method starts here -->'+newCaseList);
		set<string> buUnitStr = new set<string>();
		Boolean isOutageChanged = false;
		Boolean isSeverityChanged = false;
		List<Case> caseList = new List<Case>();
		for(Case objCase : newCaseList){
			if(objCase.CH_BusinessUnit__c !=null && objCase.CH_ServiceType__c =='Customer Support' ){
				buUnitStr.add(objCase.CH_BusinessUnit__c); 
				if(objCase.Severity__c =='Critical' || 
				   (!oldCaseMap.isempty() && objCase.Severity__c =='Critical' && oldCaseMap.get(objCase.Id).Severity__c !='Critical')){
					   isSeverityChanged = true;
					   caseList.add(objCase);
				   }
				if(objCase.CH_Outage__c =='Yes' ||
				   (!oldCaseMap.isempty() && objCase.CH_Outage__c =='Yes' && oldCaseMap.get(objCase.Id).CH_Outage__c !='Yes')){
					   isOutageChanged = true;	
					   caseList.add(objCase);
				   }
				
			}
		}
		if(isOutageChanged || isSeverityChanged){
			postMessageInChatterGroup(caseList, buUnitStr, isSeverityChanged, isOutageChanged,eventType);
		}
		system.debug('createProductChatterGroupOnUpdate Method ends here -->'+newCaseList);
	}
	
	
}