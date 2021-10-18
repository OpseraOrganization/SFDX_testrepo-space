/*******************************
 Class name :DS_AccountTriggerHelper	 
 Created by: Accenture
 Description: This helper is written for the Trigger on Account object
 Team: Digital Sales
*******************************/
public without sharing class DS_AccountTriggerHelper {
 /******************************************************************************************************
Name : assignTerritory
Description : This method is used to assign territories for Logistic accounts..
Parameter : List of Account records
*********************************************************************************************************/  
	public static void assignTerritory(List<Account> accList) {
		
		try{
			// This map will store legal entity account as key and its associated logistic accounts as values  
			Map<Id, Set<Id>> legalTOLogisticMap = new Map<Id,Set<Id>>();
			Set<Id> logisticAccountIDSet = new Set<Id>();
			
			for(Account acc : accList){
			
				logisticAccountIDSet.clear();
				logisticAccountIDSet.add(acc.Id);					//Set of logistic accounts associated with one legal entity account
		   
			if(!legalTOLogisticMap.containsKey(acc.ParentId)){
				legalTOLogisticMap.put(acc.ParentId, logisticAccountIDSet);
			}else{
				legalTOLogisticMap.get(acc.ParentId).add(acc.Id);
			}
		  }
	  
		
		//This Map will Store territory assigned to one legal entity account
		Map<Id, Id> legalAccountIDToTerritoryIDMap = new Map<Id, Id>();
		for(ObjectTerritory2Association objRec : [Select Id, AssociationCause, ObjectId , SobjectType , Territory2Id from ObjectTerritory2Association where ObjectId IN : legalTOLogisticMap.Keyset() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		 legalAccountIDToTerritoryIDMap.put(objRec.ObjectId, objRec.Territory2Id);
		}  
		
		//Code for assignment of legal entity account's territory to Logistic account Territory
		List<ObjectTerritory2Association> logisticAccterritoryList = new List<ObjectTerritory2Association>();
		for(ID parentID :legalAccountIDToTerritoryIDMap.keySet() ){
		   for(Id logisticAccId : legalTOLogisticMap.get(parentID)){
				ObjectTerritory2Association logisticAccterritory = new ObjectTerritory2Association();
				logisticAccterritory.ObjectId= logisticAccId;
				logisticAccterritory.Territory2Id = legalAccountIDToTerritoryIDMap.get(parentID);
				logisticAccterritory.AssociationCause=CSWXGlobalConstant.Territory2Manual;
				logisticAccterritoryList.add(logisticAccterritory);
			   }
		 } 
			database.insert(logisticAccterritoryList);
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_AccountTriggerHelperClass, CSWXGlobalConstant.assignTerritorymethod);}
	
	}
	
	 /******************************************************************************************************
	Name : AssignTheCommunityUserWithAccountOwner
	Description : This method will contains logic for sharing  the Customer community user with Account Owner.
	Parameter : List of Account records
	*********************************************************************************************************/  
	
	public static void AssignTheCommunityUserWithAccountOwner(List<Account> accList) {
		
	try {
			//Creating the Map to group all customer user with Account Owner. 
			Map<String,DS_User_Profile_config_for_User_Sharing__c>alldata= DS_User_Profile_config_for_User_Sharing__c.getAll();
			Set<String> profileName = new Set<String>();
			for(DS_User_Profile_config_for_User_Sharing__c objVal : alldata.values()) {
				profileName.add(objVal.Name);
			}
			if(!profileName.isEmpty())  {
				
				Set<Id> accountIdSet = new Set<Id>();
				Set<Id> accountOwnerIdSet = new Set<Id>();
				Map<Id,Id> accountAndAccountOwnerMap = new Map<Id,Id>();
				for(Account obj : accList) {
					accountIdSet.add(obj.Id);
					accountAndAccountOwnerMap.put(obj.Id,obj.OwnerId);
					accountOwnerIdSet.add(obj.OwnerId);
				}
				
			   system.debug('accountIdSet>>>>'+accountIdSet);
				system.debug('profileName>>>>'+profileName);
			   
				//List all the users Associated with contacts.
				List<User> lstUser = [SELECT Id, Username,Profile.Name, LastName, Name, ContactId,Contact.AccountId,Contact.Account.OwnerId FROM User where Contact.AccountId IN : accountIdSet and  isActive = true and Profile.Name IN :profileName];
			   System.debug('lstUser>>>>>>>>>>'+lstUser);
				
				set<Id> userIdSet = new Set<Id>();
				for(User objUser : lstUser) {
					userIdSet.add(objUser.Id);
				}
			
				Map<String,UserShare> userShareMap = new Map<String,UserShare>();
				
				List<UserShare> lstUserShare = [SELECT Id, UserId, UserOrGroupId, UserAccessLevel, RowCause, IsActive FROM UserShare where UserId IN:accountOwnerIdSet and UserOrGroupId IN:userIdSet];
			   
				
				for(UserShare objShare : lstUserShare) {
					String Key = String.valueOf(objShare.UserId) + '-' + String.valueOf(objShare.UserOrGroupId);
					if(!userShareMap.containsKey(Key)) {
						userShareMap.put(Key,objShare);
					}
				}
				System.debug('*****userShareMap*********'+userShareMap.keySet());
				Map<Id,List<User>> AccountUserListMap = new Map<Id,List<User>>();
				for(User objUser : lstUser) {
					if(objUser.Contact.Account.OwnerId != null) {
						
						if(!AccountUserListMap.containsKey(objUser.Contact.AccountId)) {
							List<User> userList = new List<User>();
							userList.add(objUser);
							AccountUserListMap.put(objUser.Contact.AccountId,userList);
						}
						else {
							List<User> userList = AccountUserListMap.get(objUser.Contact.AccountId);
							userList.add(objUser);
							AccountUserListMap.put(objUser.Contact.AccountId,userList);
						}
					}
				}
			
				//Iterate over through the Map and creates the user sharing. 
				List<UserShare> lstUserShareAccountOwner = new List<UserShare>();
				
				for(String key : AccountUserListMap.keySet()){
					
					List<User> lstUserFromMap = AccountUserListMap.get(key);
					for(user objUser : lstUserFromMap) {
						String keyString = String.valueOf(objUser.Contact.Account.OwnerId )+'-'+String.valueOf(objUser.Id);
						System.debug('********keyString*************'+keyString);
						if(!userShareMap.containsKey(keyString)) {
							UserShare objShare =  new UserShare();
							objShare.UserId = objUser.Contact.Account.OwnerId;
							objShare.UserOrGroupId = objUser.Id;
							objShare.UserAccessLevel ='Read';
							lstUserShareAccountOwner.add(objShare);
						}
					}
				}
				
				//If there is record exist to share then it will be shared. 
				if(!lstUserShareAccountOwner.isEmpty()) {
					
					insert lstUserShareAccountOwner;
					
				}
			
				AddDMPUserToPublicGroup(userIdSet);
			}
		}
		Catch(Exception ex) {
			ExceptionHandler.addException(ex,'DS_AccountTriggerHelper' ,'');
		}
	}
	
	 /******************************************************************************************************
	Name : AddDMPUserToPublicGroup
	Description : This method is used to assign DMp user to Public group.
	Parameter : List of DMP User Id.
	*********************************************************************************************************/  
	
	@Future 
	public static void AddDMPUserToPublicGroup(Set<ID> userIdSet) {
		
		Map<String,DS_User_Profile_config_for_User_Sharing__c>alldata= DS_User_Profile_config_for_User_Sharing__c.getAll();
		Set<String> profileName = new Set<String>();
		for(DS_User_Profile_config_for_User_Sharing__c objVal : alldata.values()) {
			profileName.add(objVal.Name);
		}
		
		if(!profileName.isEmpty())  {
			Map<Id,GroupMember> userGroupMap = new Map<Id,GroupMember>();
			for(GroupMember objGroupMember : [SELECT Id, GroupId, UserOrGroupId FROM GroupMember where UserOrGroupId IN:userIdSet]) {
				userGroupMap.put(objGroupMember.UserOrGroupId, objGroupMember);
			}
			
			
		   
		   List<GroupMember>lstGroupMember = new List<GroupMember>();
			Group g=[select Id from Group Where DeveloperName='Customer_Portal_users_group'];
			
			for(User objUser : [SELECT Id,Profile.Name, Username, LastName, Name, ContactId,Contact.AccountId,Contact.Account.OwnerId FROM User where ID IN : userIdSet and isActive = true and Profile.Name IN :profileName]){
				if(!userGroupMap.containsKey(objUser.Id)) {
					GroupMember objMember = new GroupMember();
					objMember.UserOrGroupId = objUser.Id;
					objMember.GroupId = g.Id; 
					lstGroupMember.add(objMember);
				}
			}
					
					//Inserts the Record to Group
			if(!lstGroupMember.isEmpty()) {
				
				insert lstGroupMember;
			}
		}
		
	}
}