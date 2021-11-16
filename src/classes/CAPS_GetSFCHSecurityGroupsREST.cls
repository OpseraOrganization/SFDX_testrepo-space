/*************************************************************************************************
	* Class Name : CAPS_GetSFCHSecurityGroupsREST
	* Created Date: 15 April 2019
	* Created By : TCS
	* Description: Return details of CH Security Groups.
		Security Groups are mainly Public Groups.
		Group Id and API Name should be configured in the custom settings.
	* Last Modified by: 
	* Last Modified Date: 
	* Description : 
*************************************************************************************************/
@RestResource(urlMapping='/GetSFCHSecurityGroups/*')
global with sharing class CAPS_GetSFCHSecurityGroupsREST {
	/*********************************************************
		* Class Name: ResponseWrapper
		* Created Date: 15 April 2019
		* Created By : TCS
		* Description: This is inner class of CAPS_GetSFCHSecurityGroupsREST to send response to CAPS
		* Last Modified by: 
		* Last Modified Date: 
		* Description : 
	*********************************************************/
	global class ResponseWrapper{
		global String sfGroupId{get;set;}
		global String groupSFName{get;set;}
		global ResponseWrapper(String sfGroupId, String groupSFName){
			this.sfGroupId = sfGroupId;
			this.groupSFName = groupSFName;
		}
	}
	// https://test.salesforce.com/services/apexrest/GetSFCHSecurityGroups
	//GET Call with neccessary authentication with mentioned enpoint
	/*****************************************************
		* Method Name : chSecurityGroups
		* Created Date: 15 April 2019
		* Created By : TCS
		* Descsription: This is a REST GET Service to get all CH Security Groups
		* Parameter: NA
		* Return: JSON Response to CAPS - Security Groups
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
	@HttpGet
	global static void chSecurityGroups() {
		RestResponse res = RestContext.response;
		CAPS_SecurityGroupsRESTUtil.StatusDetails errormsg;
		String interfaceLogName = 'CAPS-GETCALL-API-GetSFCHSecurityGroups-Class-CAPS_GetSFCHSecurityGroupsREST';
		RestRequest req = RestContext.request;
		try{
			List<ResponseWrapper> responseWrapList = new List<ResponseWrapper>();
			/*1. Get Security Groups(actually they are public groups in Salesforce) configured in Salesforce.
	 2. Mainly security groups are Starts with "SEC, but not make that constraint 
		for this implementation this has been configured in custom settings
	 3. Whenever new security group is created custom settings also needs to be updated.
	 4. Group Ids should be same once evenrything is refreshed from Production.*/
			Map<Id,String> groupIdVsNameMap = new Map<Id,String>();
			groupIdVsNameMap = CAPS_SecurityGroupsRESTUtil.securityGroups();
			if(groupIdVsNameMap.isEmpty()){
	res.statusCode = 500;
	CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'Group Setup is not correct in Salesforce Custom Settings');
	res.responseBody = Blob.valueOf(JSON.serialize(msg));
	CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI);
	return;
			}else{
	for(Group grp: [SELECT Id, DeveloperName 
		FROM Group 
		WHERE ID IN: groupIdVsNameMap.keySet() 
		LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
	{
		responseWrapList.add(new ResponseWrapper(grp.Id, grp.DeveloperName));
	}
	if(!responseWrapList.isEmpty()){
		res.statusCode = 200;
		res.responseBody = Blob.valueOf(JSON.serialize(responseWrapList));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Success', interfaceLogName, 'Request URI: '+req.requestURI);
	}else{
		res.statusCode = 200;
		CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'No Group Found.');
		res.responseBody = Blob.valueOf(JSON.serialize(msg));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Success', interfaceLogName, 'Request URI: '+req.requestURI);
		return;
	}
			}
		}catch(Exception exp){CAPS_SecurityGroupsRESTUtil.excptionHandle(exp, res, errormsg);
			CAPS_SecurityGroupsRESTUtil.createInterfaceLog('Request Body: '+req.requestBody.toString(), 'Response Body: '+res.responseBody.toString(), 'Failure', interfaceLogName, 'Request URI: '+req.requestURI);
		}
	}
}