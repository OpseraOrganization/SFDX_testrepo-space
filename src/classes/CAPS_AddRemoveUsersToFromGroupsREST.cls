/*************************************************************************************************
		* Class Name : CAPS_AddRemoveUsersToFromGroupsREST
		* Created Date: 25 April 2019
		* Created By : TCS
		* Description: CAPS sends request to Add/Remove users from Security Groups. CAPS sends nokia employee id, Group Id 
			and "add" or "remove" string.
			This API consume and process the request. This can process more than 1 add/removal request in same call
			In response, SF sends success/fail OR partial success/fail message.
		* Last Modified by: 
		* Last Modified Date: 
		* Description : 
	*************************************************************************************************/
	@RestResource(urlMapping='/AddRemoveGroupmembership/*')
	global with sharing class CAPS_AddRemoveUsersToFromGroupsREST {
		/*********************************************************
			* Class Name: ResponseWrapper
			* Created Date: 15 April 2019
			* Created By : TCS
			* Description: This is inner class of CAPS_AddRemoveUsersToFromGroupsREST to send response to CAPS
			* Last Modified by: 
			* Last Modified Date: 
			* Description : 
		*********************************************************/
		global class ResponseWrapper{
			global Integer srNo{get;set;}
			global String nokiaEmployeeId{get;set;}
			global String sfUserId{get;set;}
			global String sfGroupId{get;set;}
			global String operation{get;set;}
			global String result{get;set;}
			global String message{get;set;}
			global ResponseWrapper(Integer srNo, String nokiaEmployeeId, String sfUserId, String sfGroupId, String operation, String result, String message){
	this.srNo = srNo;
	this.nokiaEmployeeId = nokiaEmployeeId;
	this.sfUserId = sfUserId;
	this.sfGroupId = sfGroupId;
	this.operation = operation;
	this.result = result;
	this.message = message;
			}
		}
		//https://test.salesforce.com/services/apexrest/AddRemoveGroupmembership - POST
		@HttpPost
		global static void addOrRemoveGroupMemberPOST() {
			CAPS_SecurityGroupsRESTUtil.StatusDetails errormsg;
			RestRequest req = RestContext.request;//get the request
			RestResponse res = RestContext.response;
			String interfaceLogName = 'CAPS-POSTCall-AddRemoveGroupmembership-ClsCAPS_AddRemoveUsersToFromGroupsREST';//name interface log record
			List<ResponseWrapper> responseWrapList = new List<ResponseWrapper>();
			System.Savepoint sp = Database.setSavepoint();
			try{
	Set<String> employeeIDSet = new Set<String>();
	Set<String> employeeIDDeleteSet = new Set<String>();
	Set<String> incomingGrpIdSet = new Set<String>();
	Set<String> grpId4RemovalSet = new Set<String>();
	Set<String> wrongGroupIdSet = new Set<String>();
	Set<String> concatenatedRequestSet = new Set<String>();
	Set<String> operationNameSet = new Set<String>{'add','remove'};
	Set<String> publicgroupIdSet = new Set<String>();
	Map<String,String> nokiaIdVsUserIdMap = new Map<String,String>();
	Map<String,String> userIdVsNokiaIdMap = new Map<String,String>();
	Set<String> deleteUserIdSet = new Set<String>();
	Map<String,String> concatStringVsResultSucessMap = new Map<String,String>();
	Map<String,String> concatStringVsResultFailMap = new Map<String,String>();
	Set<String> sfUserIdDeleteSet = new Set<String>();
	
	String jsonStr = RestContext.request.requestBody.toString();// get request body in JSON string format
	List<Map<String, String>> requestBodyList = new List<Map<String, String>>();
	if(String.isBlank(jsonStr)){//if no body in the request
		res.statusCode = 400;
		CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(CAPS_ConstantHandler.BAD_REQUEST,'Could not find a body in the request.');
		res.responseBody = Blob.valueOf(JSON.serialize(msg));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Failure', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
		return;
	}else{//deserialize the JSON request to process
		requestBodyList = (List<Map<String, String>>)JSON.deserialize(jsonStr, List<Map<String, String>>.class);
	}
	/*1. Get Security Groups(actually they are public groups in Salesforce) configured in Salesforce.
	  2. Mainly security groups are Starts with "SEC, but not make that constraint 
			for this implementation this has been configured in custom settings
	  3. Whenever new security group is created custom settings also needs to be updated.
	  4. Group Ids should be same once evenrything is refreshed from Production.*/
	Map<Id,String> groupIdVsNameMap = new Map<Id,String>();
	groupIdVsNameMap = CAPS_SecurityGroupsRESTUtil.securityGroups();
	if(groupIdVsNameMap.isEmpty())
	{//if there is no group is set up in custom settings
		res.statusCode = 500;
		CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'Group Setup is not correct in Salesforce Custom Settings');
		res.responseBody = Blob.valueOf(JSON.serialize(msg));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Failure', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
		return;
	}
	Integer lsitSize = requestBodyList.size();
	for(integer i=0; i< lsitSize; i++)
	{//iterate over request body list taht is parsed
		String grpId = (String)requestBodyList.get(i).get('sfGroupId');// Public Group Id
		String nokiaEmployeeId = (String)requestBodyList.get(i).get('nokiaEmployeeId');// Nokia Employee Id
		String operationToBePerformed = (String)requestBodyList.get(i).get('operation');//What operation to be done insert("add") or delete("remove")
		String sfUserId = (String)requestBodyList.get(i).get('sfUserId');
		if(!String.isBlank(nokiaEmployeeId) &&  !String.isBlank(sfUserId)){
			res.statusCode = 400;
			CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(CAPS_ConstantHandler.BAD_REQUEST,'Invalid Request. Both nokiaEmployeeId and sfUserId can not be populated in the request.');
			res.responseBody = Blob.valueOf(JSON.serialize(msg));
			CAPS_SecurityGroupsRESTUtil.createInterfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Failure', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
			return;
		}else if((String.isBlank(nokiaEmployeeId) &&  String.isBlank(sfUserId))  || String.isBlank(grpId) || String.isBlank(operationToBePerformed)){// if all 3 values are empty in the request
			res.statusCode = 400;
			CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(CAPS_ConstantHandler.BAD_REQUEST,'Invalid Request. nokiaEmployeeId OR sfUserId, sfGroupId and operation can not be blank.');
			res.responseBody = Blob.valueOf(JSON.serialize(msg));
			CAPS_SecurityGroupsRESTUtil.createInterfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Failure', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
			return;
		}else if(!operationNameSet.contains(operationToBePerformed)){//in "operation" string is other than "add" or "remove"
			res.statusCode = 400;
			CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(CAPS_ConstantHandler.BAD_REQUEST,'Invalid "operation" '+operationToBePerformed+' in request.');
			res.responseBody = Blob.valueOf(JSON.serialize(msg));
			CAPS_SecurityGroupsRESTUtil.createInterfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Failure', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
			return;
		}
		else{//if all looks good enter here
			string concatenatedRequestString = grpId+'|'+nokiaEmployeeId+'|'+operationToBePerformed+'|'+sfUserId;
			if(concatenatedRequestSet.contains(concatenatedRequestString)){// check if duplicate JSON in the request body
				res.statusCode = 400;
				String duplicateRqst = '{"nokiaEmployeeId" : "' +nokiaEmployeeId+'", '+' "sfGroupId" : "'+grpId+'", '+'"operation" : "'+operationToBePerformed+'"}';
				CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(CAPS_ConstantHandler.BAD_REQUEST,'Invalid Request. Duplicates in Request Body.\n'+duplicateRqst);
				res.responseBody = Blob.valueOf(JSON.serialize(msg));
				CAPS_SecurityGroupsRESTUtil.createInterfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Failure', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
				return;
			}else{//seems all good finally here
				concatenatedRequestSet.add(concatenatedRequestString);// this is used to check no duplicate
				if(!String.isBlank(nokiaEmployeeId)){
		employeeIDSet.add(nokiaEmployeeId);//all nokia ids in entire request
				}
				incomingGrpIdSet.add(grpId);//all group ids in entire request
				//if group id in the request is not present in the custom settings, SF does not have groupid or custom setting is not up to dated
				if(!groupIdVsNameMap.containsKey(grpId)){
		wrongGroupIdSet.add(grpId);
				}
				//get removal list
				if(operationToBePerformed == 'remove'){//if to delete groupmember
		if(!String.isBlank(sfUserId) && String.isBlank(nokiaEmployeeId)){
			sfUserIdDeleteSet.add(sfUserId);
		}else{
			employeeIDDeleteSet.add(nokiaEmployeeId);
		}
		grpId4RemovalSet.add(grpId);
				}
			}
		}
	}
	for(Group grp: [SELECT Id 
		FROM Group 
		WHERE Id IN : incomingGrpIdSet 
		LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		publicgroupIdSet.add(grp.Id);
	}//just to check if Group Id is in SF or not
	if(!publicgroupIdSet.isEmpty()){
		for(String grp : incomingGrpIdSet){
			if(!publicgroupIdSet.contains(grp)){
				wrongGroupIdSet.add(grp);
			}
		}
	}else{
		res.statusCode = 500;
		CAPS_SecurityGroupsRESTUtil.StatusDetails msg = new CAPS_SecurityGroupsRESTUtil.StatusDetails(null,'None of the Gourp(s) present in Salesforce.');
		res.responseBody = Blob.valueOf(JSON.serialize(msg));
		CAPS_SecurityGroupsRESTUtil.createInterfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Failure', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
		return;
	}
	for(User usr : [SELECT Id, Nokia_ID__c
		FROM User 
		WHERE Nokia_ID__c IN : employeeIDSet 
		LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
	{//Get all user based nokia id to get SF user id
		if(!nokiaIdVsUserIdMap.containsKey(usr.Nokia_ID__c)){//assumption is taken there will not be more than one user for a nokia id in Salesforce.
			nokiaIdVsUserIdMap.put(usr.Nokia_ID__c, usr.Id);
			userIdVsNokiaIdMap.put(usr.Id, usr.Nokia_ID__c);
			if(employeeIDDeleteSet.contains(usr.Nokia_ID__c)){
				deleteUserIdSet.add(usr.Id);//SF User Ids for GroupMember to delete
			}
		}
	}
	if(!sfUserIdDeleteSet.isEmpty()){
		deleteUserIdSet.addAll(sfUserIdDeleteSet);
	}
	//Again needs to iterate on requestlist to filter actual Group record to be deleted - 8/24/2019
	Set<String> concatUsrIdGrpIdDelSet = new Set<String>();
	for(integer i=0; i< lsitSize; i++){
		String grpId = (String)requestBodyList.get(i).get('sfGroupId');// Public Group Id
		String nokiaEmployeeId = (String)requestBodyList.get(i).get('nokiaEmployeeId');// Nokia Employee Id
		String operationToBePerformed = (String)requestBodyList.get(i).get('operation');//What operation to be done insert("add") or delete("remove")
		String sfUserId = (String)requestBodyList.get(i).get('sfUserId');
		if(operationToBePerformed == 'remove'){
			if(!String.isBlank(nokiaEmployeeId)){
				String temp = nokiaIdVsUserIdMap.get(nokiaEmployeeId)+'|'+grpId;
				concatUsrIdGrpIdDelSet.add(temp);
			}else{
				String temp = sfUserId+'|'+grpId;
				concatUsrIdGrpIdDelSet.add(temp);
			}
		}
	}
	
	//Get GroupMembers to delete
	List<GroupMember> grpMemberList = new List<GroupMember>();
	for(GroupMember gm : [SELECT Id, UserOrGroupId, GroupId 
				FROM GroupMember
				WHERE GroupId IN : grpId4RemovalSet
				AND UserOrGroupId IN : deleteUserIdSet 
				LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
	{
		if(concatUsrIdGrpIdDelSet.contains(gm.UserOrGroupId+'|'+gm.GroupId))
		{//filter correct GroupMember to delete
			grpMemberList.add(gm);
		}
	}
	List<GroupMember> grpMemberToInsert = new List<GroupMember>();
	List<GroupMember> grpMemberToDelete = new List<GroupMember>();
	Set<String> concatDelgroupMemberSet = new Set<String>();
	for(integer i=0; i< lsitSize; i++)
	{//iterate on request json list to generate insert list and delete list groupmembers
		String nokiaEmployeeId = (String)requestBodyList.get(i).get('nokiaEmployeeId');
		String operationToBePerformed = (String)requestBodyList.get(i).get('operation');
		String groupIdInRequest = (String)requestBodyList.get(i).get('sfGroupId');
		String sfUserId = (String)requestBodyList.get(i).get('sfUserId');
		if(operationToBePerformed == 'add'){
			if(!String.isBlank(nokiaEmployeeId)){
				grpMemberToInsert.add(new GroupMember(GroupId = groupIdInRequest, 
						UserOrGroupId = nokiaIdVsUserIdMap.get(nokiaEmployeeId)));
			}else{
				grpMemberToInsert.add(new GroupMember(GroupId = groupIdInRequest, 
						UserOrGroupId = sfUserId));
			}
		}
		//get removal list
		if(operationToBePerformed == 'remove'){
			for(GroupMember grpmbr : grpMemberList){
				if(!String.isBlank(nokiaEmployeeId)){
		if(grpmbr.UserOrGroupId == nokiaIdVsUserIdMap.get(nokiaEmployeeId) && grpmbr.GroupId == groupIdInRequest){
			grpMemberToDelete.add(grpmbr);
			concatDelgroupMemberSet.add(grpmbr.GroupId+'|'+grpmbr.UserOrGroupId+'|'+'remove');//this will be used later in case groupmember to be deleted is not available
		}
				}else{
		if(grpmbr.UserOrGroupId == sfUserId && grpmbr.GroupId == groupIdInRequest){
			grpMemberToDelete.add(grpmbr);
			concatDelgroupMemberSet.add(grpmbr.GroupId+'|'+grpmbr.UserOrGroupId+'|'+'remove');//this will be used later in case groupmember to be deleted is not available
		}
				}
			}
		}
	}
	Database.SaveResult[] srList = Database.insert(grpMemberToInsert,false);//get saveesult details and send in response.
	Integer insertListSize = srList.size();
	for (Integer i=0;i<insertListSize; i++){//Database.SaveResult sr : srList) {
		if (srList[i].isSuccess()) {
			// Operation was successful, so get the ID of the record that was processed
			concatStringVsResultSucessMap.put(grpMemberToInsert[i].GroupId+'|'+grpMemberToInsert[i].UserOrGroupId+'|'+'add', 'Successfully Added'+'|'+ 'GroupMembership Record Id is: '+srList[i].getId());
		}
		else {
			// Operation failed, so get all errors  
			String printMsg;
			for(Database.Error err : srList[i].getErrors()) {
				printMsg = printMsg +'Error StatusCode: '+err.getStatusCode() +' Error message: '+err.getMessage()+' Affected Fields: '+err.getFields()+'\n';
			}
			concatStringVsResultFailMap.put(grpMemberToInsert[i].GroupId+'|'+grpMemberToInsert[i].UserOrGroupId+ '|'+'add', 'Failed to Add'+'|'+ ' Errors: '+printMsg);
		}
	}
	Database.DeleteResult[] drList = Database.delete(grpMemberToDelete,false);//get deleteresult details and send in response.
	Integer deleteListSize = drList.size();
				Set<Id> oUserIdSet = new Set<Id>();//NOKIASC-31964
				Set<Id> oGroupIdSet = new Set<Id>();//NOKIASC-31964
	for(Integer i=0;i<deleteListSize; i++) { 
		if (drList[i].isSuccess()) {
			// Operation was successful, so get the ID of the record that was processed
			concatStringVsResultSucessMap.put(grpMemberToDelete[i].GroupId+'|'+grpMemberToDelete[i].UserOrGroupId+ '|'+'remove', 'Successfully Removed'+'|'+ 'Deleted GroupMembership Record Id is: '+drList[i].getId());
			oUserIdSet.add(grpMemberToDelete[i].UserOrGroupId);//NOKIASC-31964
			oGroupIdSet.add(grpMemberToDelete[i].GroupId);//NOKIASC-31964
					}
		else {
			// Operation failed, so get all errors	 
			String printMsg = '';
			for(Database.Error err : drList[i].getErrors()) {printMsg = printMsg +'Error StatusCode: '+err.getStatusCode() +' Error message: '+err.getMessage()+' Affected Fields: '+err.getFields()+'\n';}
			concatStringVsResultFailMap.put(grpMemberToDelete[i].GroupId+'|'+grpMemberToDelete[i].UserOrGroupId+ '|'+'remove', 'Failed to Remove'+'|'+ ' Errors: '+printMsg);
		}
	}
				//NOKIASC-31964
				if(!oUserIdSet.isEmpty() && !oGroupIdSet.isEmpty()) {
					CH_ClearGroupUserCases.execute(oUserIdSet, oGroupIdSet);
				}
				//
	for(integer i=0; i< lsitSize; i++)
	{//build response message
		String nokiaEmployeeId = (String)requestBodyList.get(i).get('nokiaEmployeeId');
		String operationToBePerformed = (String)requestBodyList.get(i).get('operation');
		String groupIdInRequest = (String)requestBodyList.get(i).get('sfGroupId');
		String sfUserId = (String)requestBodyList.get(i).get('sfUserId');
		String concatValue = groupIdInRequest+'|'+(!String.isBlank(nokiaEmployeeId) ? nokiaIdVsUserIdMap.get(nokiaEmployeeId) : sfUserId) +'|'+operationToBePerformed;
		
		
		if(wrongGroupIdSet.contains(groupIdInRequest) && !String.isBlank(nokiaEmployeeId) && !nokiaIdVsUserIdMap.containsKey(nokiaEmployeeId)){//If group id and nokia both are not present
			responseWrapList.add(new ResponseWrapper(i+1, nokiaEmployeeId, sfUserId, groupIdInRequest, operationToBePerformed, CAPS_ConstantHandler.NO_ACTION_TAKEN,'nokiaEmployeeId and sfGroupId are not available.'));
		}else if(wrongGroupIdSet.contains(groupIdInRequest)){//Group Id is not in SF. If None of the Group is a entire request is not present in SF then code execution does come till this point, before error is returned
			responseWrapList.add(new ResponseWrapper(i+1, nokiaEmployeeId, sfUserId, groupIdInRequest, operationToBePerformed, CAPS_ConstantHandler.NO_ACTION_TAKEN,'sfGroupId is not available.'));
		}
		else if(!String.isBlank(nokiaEmployeeId) && !nokiaIdVsUserIdMap.containsKey(nokiaEmployeeId)){//No user in SF for the Nokia Employee Id in request
			responseWrapList.add(new ResponseWrapper(i+1, nokiaEmployeeId, sfUserId, groupIdInRequest, operationToBePerformed, CAPS_ConstantHandler.NO_ACTION_TAKEN,'nokiaEmployeeId is not available.'));
		}else if(concatStringVsResultSucessMap.containsKey(concatValue)){//insert or delete was successful
			responseWrapList.add(new ResponseWrapper(i+1, nokiaEmployeeId, sfUserId, groupIdInRequest, operationToBePerformed, 'Success', concatStringVsResultSucessMap.get(concatValue)));
		}else if(concatStringVsResultFailMap.containsKey(concatValue)){// Insert or Delete failed
			responseWrapList.add(new ResponseWrapper(i+1, nokiaEmployeeId, sfUserId, groupIdInRequest, operationToBePerformed, 'Fail', concatStringVsResultFailMap.get(concatValue)));
		}else if (operationToBePerformed == 'remove' && !concatDelgroupMemberSet.contains(concatValue)){//GroupMember to be deleted is not present
			responseWrapList.add(new ResponseWrapper(i+1, nokiaEmployeeId, sfUserId, groupIdInRequest, operationToBePerformed, 'Unable to Process', 'User not in the Group.'));
		}
		else{responseWrapList.add(new ResponseWrapper(i+1, nokiaEmployeeId, sfUserId, groupIdInRequest, operationToBePerformed, 'Unknown', 'Unknown'));}
	}
	if(!responseWrapList.isEmpty()){
		res.statusCode = 200;
		res.responseBody = Blob.valueOf(JSON.serialize(responseWrapList));
		interfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Success', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
	}
			}catch(Exception exp){
	Database.rollback(sp);CAPS_SecurityGroupsRESTUtil.excptionHandle(exp, res, errormsg);
	interfaceLog(CAPS_ConstantHandler.REQUEST_BODY+req.requestBody.toString(), CAPS_ConstantHandler.RESPONSE_BODY+res.responseBody.toString(), 'Failure', interfaceLogName, CAPS_ConstantHandler.REQUEST_URI+req.requestURI);
			}
		}
		@future
		global static void interfaceLog(String interfaceRequest, String responseMsg, String status, String name, String rqstURI){
			CAPS_SecurityGroupsRESTUtil.createInterfaceLog(interfaceRequest, responseMsg, status, name, rqstURI);
		}
	}