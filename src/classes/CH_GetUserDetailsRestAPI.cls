/****************************************
* Class Name : CH_GetUserDetailsRestAPI 
* Created Date: 5 August 2020
* Created By : TCS
* Description : To make custom rest API call to get user details
************/
@RestResource(urlMapping='/api/UserDetails/*')
global with sharing class CH_GetUserDetailsRestAPI {
	@HttpGet
	global static List<User> doGet() {
		RestRequest request = RestContext.request;
		String fedId = request.params.get('FederationId');
		String lastModDate = request.params.get('LastModifiedDate'); 
		Datetime lastModifiedDate;		
		List<String> permissionSetList = new List<String>{'CH_3rdParty','CH_CaseHandler','CH_BasicCaseHandling','CH_FunctionalAccount'};
		List<String> chProfileList = new List<String>{'CH_Case Handler','CH_Basic Case Handling'};
		List<String> profileList = new List<String>{'CH_Agent','CH_Case Handler','CH_Basic Case Handling','Customers','Customers Login'}; 
		System.debug('lastModifiedDate'+lastModDate);
		List<User> userList = new List<User>();
		String userQuery;
		if(lastModDate != null){
			if(lastModDate == 'Today')
				lastModifiedDate = Date.today();
			else 
				lastModifiedDate = Datetime.valueOf(lastModDate.replace('T',' '));
		}
		List<PermissionSetAssignment> permSetList = [SELECT AssigneeId FROM PermissionSetAssignment WHERE Assignee.Profile.Name NOT IN :chProfileList AND PermissionSet.Name IN :permissionSetList];
		Set<Id> userIds = new Set<Id>();
		for(PermissionSetAssignment ps : permSetList){
			userIds.add(ps.AssigneeId);
		}
		userQuery = 'Select Id,UserName,Profile.Name,FederationIdentifier,isActive from User';
		userQuery = userQuery+' WHERE ((Id IN :userIds) OR (Profile.Name IN :profileList))';		
		if(lastModifiedDate != null){
			userQuery = userQuery + ' AND LastModifiedDate >= :lastModifiedDate';
		}
		if(fedId != null){
			userQuery = userQuery + ' AND FederationIdentifier = :fedId';			
		}
		System.debug('QUERY:'+userQuery);		
		userList = Database.query(userQuery);
		return userList;
	}
}