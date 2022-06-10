/*******************************
	Class name :DS_UserTrigger_Helper	 
	Created by: Accenture
	Description: This helper class contains the logic for sharing the community user with AM
	Team: Digital Sales 
	*******************************/
public without sharing class DS_UserTrigger_Helper {
	
	/*******************************
	Method name :shareCustomerUserWithAM	 
	Created by: Accenture
	Description: This method shares the customer user with AM
	Team: Digital Sales
	*******************************/
	 @future 
	 public static void shareCustomerUserWithAM(Set<Id> userKeySet) {
		try{
		
		//List<User> userList = [select Id,Contact.Account.OwnerId, Contact.Account.DMP_Account__c from User where Id IN : userKeySet  and IsPortalEnabled = true and Contact.Account.DMP_Account__c= true];
		List<UserShare> objUserShareList = new List<UserShare>();
		UserShare objUserShare;
		Map<String,DS_User_Profile_config_for_User_Sharing__c>alldata= DS_User_Profile_config_for_User_Sharing__c.getAll();
		Set<String> profileName = new Set<String>();
		for(DS_User_Profile_config_for_User_Sharing__c objVal : alldata.values()) {
			profileName.add(objVal.Name);
		}
		if(!profileName.isEmpty()) {
			for(User objUser : [select Id,Contact.Account.OwnerId, Contact.Account.DMP_Account__c from User where Id IN : userKeySet  and IsPortalEnabled = true and Contact.Account.DMP_Account__c= true and Profile.Name IN :profileName  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
				if(objUser.Contact.Account.OwnerId != null) {
					if(objUser.Contact.Account.DMP_Account__c == true ) {
						objUserShare = new UserShare();
						objUserShare.UserId = objUser.Contact.Account.OwnerId;
						objUserShare.UserOrGroupId = objUser.Id;
						objUserShare.UserAccessLevel ='Read';
						objUserShareList.add(objUserShare);
					}
				}
				
			}
			
			if(!objUserShareList.isEmpty()) {
				insert objUserShareList;
			}
		}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, 'shareCustomerUserWithAM' , 'DS_UserTrigger_Helper' );
		}
	} 

	/*******************************
	Method name :shareCustomerUserWithPublicGroup	 
	Created by: Accenture
	Description: This method shares the customer user with Public Group and Assigning DS Specific Permission set on After creation
	Team: Digital Sales
	*******************************/
	 @future 
	 public static void shareCustomerUserWithPublicGroup(Set<Id> userKeySet) {
		try {
			
			//List<User> userList = [select Id,Contact.Account.OwnerId, Contact.Account.DMP_Account__c from User where Id IN : userKeySet  and IsPortalEnabled = true and Contact.Account.DMP_Account__c= true];
			
			GroupMember gm;
			Group g=[select Id from Group Where DeveloperName=: Label.DS_Portal_User_Customer_Group_Name  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			Map<String,DS_User_Profile_config_for_User_Sharing__c>alldata= DS_User_Profile_config_for_User_Sharing__c.getAll();
			Set<String> profileName = new Set<String>();
			for(DS_User_Profile_config_for_User_Sharing__c objVal : alldata.values()) {
				profileName.add(objVal.Name);
			}
			if(!profileName.isEmpty()) {
				
				List<GroupMember> listGroupMember = new List<GroupMember>();
				Set<String> userProfileNameSet= new Set<String>();
				for (User user : [select Id,Profile.Name,Contact.Account.OwnerId, Contact.Account.DMP_Account__c from User where Id IN : userKeySet  and IsPortalEnabled = true and Contact.Account.DMP_Account__c= true and Profile.Name IN: profileName  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				  gm = new GroupMember(); 
				  gm.GroupId=g.id;
				  gm.UserOrGroupId = user.id;
				  userProfileNameSet.add(user.Profile.Name);
				  listGroupMember.add(gm);   
				}

				if(!listGroupMember.isEmpty()) {
					insert listGroupMember;
				}
				List<DS_Customer_Permission_Set__c> lstCustomerPs = [Select Name from DS_Customer_Permission_Set__c where ProfileName__c IN :userProfileNameSet];
				
				if(!lstCustomerPs.isEmpty()) {
					Set<String> psSet = new Set<String>();
					for(DS_Customer_Permission_Set__c obj : lstCustomerPs) {
						psSet.add(obj.Name);
					}
					List<PermissionSet> lstPermissionSet = [SELECT Id, Name, Label FROM PermissionSet  where NAme IN :psSet  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				
					Set<Id> PermissionSetAssignmentIdSet = new Set<Id>();
					if(!lstPermissionSet.isEmpty()) {
					for(PermissionSetAssignment  objPSAssignment :   [SELECT Id, PermissionSetId, AssigneeId, SystemModstamp FROM PermissionSetAssignment where PermissionSetId IN :psSet and AssigneeId IN:userKeySet  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
						  PermissionSetAssignmentIdSet.add(objPSAssignment.AssigneeId);
					}
				  
					List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
					PermissionSetAssignment obj;
					for(User objUser : [Select Id,Profile.Name from User where ID IN:userKeySet and IsPortalEnabled = true and Contact.Account.DMP_Account__c= true and Profile.Name IN :profileName]) {

						if(!PermissionSetAssignmentIdSet.contains(objUser.Id)  ) {
							for( PermissionSet objPS :lstPermissionSet ) {
								obj = new PermissionSetAssignment();
								obj.PermissionSetId = objPS.Id;
								obj.AssigneeId = objUser.Id;
								permissionSetList.add(obj);
							}
						}
					}
					
					if(!permissionSetList.isEmpty()) {
						insert permissionSetList;
					}
				}
					
				}
			}

		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex,'shareCustomerUserWithPublicGroup' , 'DS_UserTrigger_Helper' ); 
		}
	 }
	
	/*******************************
	Method name :shareDSQuoteWithNewlyCreatedCustomer	 
	Created by: Accenture
	Description: This method shares the customer user with DS specific Quotes with associated accounts.
	Team: Digital Sales
	*******************************/	
	
	@future 
	public static void shareDSQuoteWithNewlyCreatedCustomer(Set<Id> userKeySet) {
	  try {   
			Set<String> accountIdSet = new Set<String>();//This set is used for stores all the Account Id associted with portal user.
			Map<String,String> userContactAccountMap = new Map<String,String>();
			Map<String,List<Apttus_Proposal__Proposal__c>> accountProposalMap = new Map<String,List<Apttus_Proposal__Proposal__c>>();
			List<String>  userIdList = new List<String>();
			String userFilterString = 'Select Id,contact.AccountId from User where Id IN : userKeySet '+Label.DS_User_Filter_for_Quote_Share_With_Community_user;
			
			for( User objUser : Database.Query(userFilterString)) {
				
				if(objUser.contact != null && objUser.contact.AccountId != null) {
					
					accountIdSet.add(objUser.contact.AccountId);
					userContactAccountMap.put(objUser.Id,objUser.contact.AccountId);
					
				}
			}
			
			//below code groups all the Quote/Proposal associated with the Account.
			List<Apttus_Proposal__Proposal__c> propList;
			Set<Id> propIdSet = new Set<Id>();
			String QueryString = 'Select Id,Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Account__c IN :accountIdSet '+ Label.DS_Quote_Filter_for_Quote_Share_With_Community_user;
			List<Apttus_Proposal__Proposal__c> proposalList = Database.Query(QueryString);
			
			for(Apttus_Proposal__Proposal__c objProp :proposalList) {
				 propList = new List<Apttus_Proposal__Proposal__c>();
				 propIdSet.add(objProp.Id);
				 if(!accountProposalMap.containsKey(objProp.Apttus_Proposal__Account__c)) {
					
					propList.add(objProp);
					 
				 }
				 else {
					 propList = accountProposalMap.get(objProp.Apttus_Proposal__Account__c);
					 propList.add(objProp);
				 }
				 accountProposalMap.put(objProp.Apttus_Proposal__Account__c,propList);
			}
			
			
			
			//Below code contains the logic for sharing the quote share.
			List<Apttus_Proposal__Proposal__Share> propShareList = new List<Apttus_Proposal__Proposal__Share >();
			if(!userContactAccountMap.isEmpty()) {
				for(String key : userContactAccountMap.keySet()) {
					if(accountProposalMap.containsKey(userContactAccountMap.get(key))) {
						for(Apttus_Proposal__Proposal__c objProp : accountProposalMap.get(userContactAccountMap.get(key))) {
							
								Apttus_Proposal__Proposal__Share objPropShare = new Apttus_Proposal__Proposal__Share();
								objPropShare.ParentId = objProp.Id;
								objPropShare.UserOrGroupId = key;
								objPropShare.AccessLevel = 'Edit';
								propShareList.add(objPropShare);
							
						}
					}
				}
			}
			
			if(!propShareList.isEmpty()) {
				 insert propShareList;
			}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex,'shareDSQuoteWithNewlyCreatedCustomer' , 'DS_UserTrigger_Helper' ); 
		}
		
		
		
	}
	 
	
}