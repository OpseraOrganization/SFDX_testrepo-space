/*************************************************************************************************
		* Class Name : CAPS_GetUsersInGroupREST
		* Created Date: 15 April 2019
		* Created By : TCS
		* Description: Return Group Members in a specified Groups.
		* Last Modified by: 
		* Last Modified Date: 
		* Description : 
	*************************************************************************************************/
	@RestResource(urlMapping='/GetUsersFromGroup/*')
	global with sharing class CAPS_GetUsersInGroupREST {
		/*********************************************************
			* Class Name: ResponseWrapper
			* Created Date: 15 April 2019
			* Created By : TCS
			* Description: This is inner class of CAPS_GetUsersInGroupREST to send response to CAPS
			* Last Modified by: 
			* Last Modified Date: 
			* Description : 
		*********************************************************/
		global class ResponseWrapper{
			global String sfUserId{get;set;}
			global String nokiaEmployeeId{get;set;}
			global String profileName{get;set;}
			global ResponseWrapper(String sfUserId, String nokiaEmployeeId, String profileName){
				this.sfUserId = sfUserId;
				this.nokiaEmployeeId = nokiaEmployeeId;
				this.profileName = profileName;
			}
		}
		// https://test.salesforce.com/services/apexrest/GetUsersFromGroup?sfGroupId=00G3C000001WesJ
		//GET Call with neccessary authentication with mentioned enpoint
		/*****************************************************
			* Method Name : usersIntheGroup
			* Created Date: 15 April 2019
			* Created By : TCS
			* Descsription: This is a REST GET Service to get Group Members in a Group.
			* Parameter: GroupId
			* Return: JSON Response to CAPS - Group Members along with their userid, nokkiaemployeeid,  profilename
			* Last Modified by: 
			* Last Modified Date: 
			* Description: 
			*******************************************/
		@HttpGet
		global static void usersIntheGroup() {
			RestResponse res = RestContext.response;
			CAPS_SecurityGroupsRESTUtil.StatusDetails errormsg;
			String interfaceLogName = 'CAPS-GETCALL-API-GetUsersFromGroup-Class-CAPS_GetUsersInGroupREST';
			RestRequest req = RestContext.request;
			String inputGroupId = '';
			try{
				List<ResponseWrapper> responseWrapList = new List<ResponseWrapper>();
				inputGroupId = req.params.get('sfGroupId');
				Set<Id> userIdSet = new Set<Id>();
				Set<Id> nonCHProfileUserId = new Set<Id>();
				Map<Id,User> usermap = new Map<Id,User>();
				Map<String,String> assigneVsProfileNameMap = new Map<String,String>();
				Map<Id,Profile> profileMap = new Map<Id,Profile>();
				Map<Id,String> ProfiletoProfileMap=new Map<Id,String>();
				profileMap = CAPS_SecurityGroupsRESTUtil.profileNames();
				ProfiletoProfileMap= CAPS_SecurityGroupsRESTUtil.profileCAPSName();// US-27475
				System.debug('ProfiletoProfileMap****'+ProfiletoProfileMap);
				if(!String.isBlank(inputGroupId))
				{
					List<Group> isGrpPresent = new List<Group>([SELECT Id 
															FROM Group 
															WHERE Id =: inputGroupId 
															LIMIT 1]);
					if(!isGrpPresent.isEmpty()){
						//if(!userIdSet.isEmpty())
					   // {
							for(User usr: [SELECT Id, Nokia_ID__c, Profile.Name,ProfileId, Email FROM User 
										   WHERE Id IN (SELECT UserOrGroupId FROM GroupMember WHERE GroupId =:isGrpPresent)
											LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
							{
								if(!profileMap.containskey(usr.ProfileId)|| !ProfiletoProfileMap.containskey(usr.ProfileId)){
									nonCHProfileUserId.add(usr.Id);
								}
								usermap.put(usr.Id,usr); 
							}
													  
							assigneVsProfileNameMap = CAPS_SecurityGroupsRESTUtil.permissionSetProfileMap(nonCHProfileUserId);
													   
						if(usermap.size()>0){
							System.debug('usermap***'+usermap.size());
							for(User usr : usermap.values())
							{
								if(profileMap.containskey(usr.ProfileId) || assigneVsProfileNameMap.containskey(usr.Id)||ProfiletoProfileMap.containskey(usr.ProfileId)){
																	
									if(profileMap.containskey(usr.ProfileId)){//when CH Profile
										responseWrapList.add(new ResponseWrapper(usr.Id, usr.Nokia_ID__c, usr.Profile.Name)); 
									}else if(ProfiletoProfileMap.containskey(usr.ProfileId)){//US-27475
										responseWrapList.add(new ResponseWrapper(usr.Id, usr.Nokia_ID__c, ProfiletoProfileMap.get(usr.ProfileId))); 
									}else{//when non ch profile but has permissionset listed in metadata
										responseWrapList.add(new ResponseWrapper(usr.Id, usr.Nokia_ID__c, assigneVsProfileNameMap.get(usr.Id))); 
									}
								}else{//non ch profile no permi from metadata
									responseWrapList.add(new ResponseWrapper(usr.Id, usr.Nokia_ID__c, usr.Profile.Name));
								}
							}
						}						  
							System.debug('responseWrapList1*****'+responseWrapList.size());
					   //}
					}else{
						res.statusCode = 400;
						CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails('Bad Request','Either group id is invalid or Group is not present in Salesforce');
						res.responseBody = Blob.valueOf(JSON.serialize(msg));
						CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI+'/'+inputGroupId);
						return;
					}
				}else
				{
					res.statusCode = 400;
					CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails('Bad Request','Group Id is missing in the Request Parameter.');
					res.responseBody = Blob.valueOf(JSON.serialize(msg));
					CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI+'/'+inputGroupId);
					return;
				}
				if(!responseWrapList.isEmpty())
				{
					res.statusCode = 200;
					res.responseBody = Blob.valueOf(JSON.serialize(responseWrapList));
					CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Success', interfaceLogName, 'Request URI: '+req.requestURI+'/'+inputGroupId);
				}
				if(responseWrapList.isEmpty())
				{
					res.statusCode = 200;
					CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'No Member in this Group.');
					res.responseBody = Blob.valueOf(JSON.serialize(msg));
					CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Success', interfaceLogName, 'Request URI: '+req.requestURI+'/'+inputGroupId);
					return;
				}
				
			}catch(Exception exp){CAPS_SecurityGroupsRESTUtil.excptionHandle(exp, res, errormsg);
				CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI+'/'+inputGroupId);
			}
		}
	}