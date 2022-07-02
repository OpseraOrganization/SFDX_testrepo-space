public with sharing class EM_User {


	/*
	* @description : Method to get the current User
	* @return : List<User>
	*/
	public static User getCurrentUser(Id userId) {
		return DM_User.getInstance().getCurrentUser(userId);
	}
	
	/**
	* @description Method to get all users
	* @param : List<Id>
	* @return : List<User>
	*/
	public static Set<User> getAllUsers(Set<Id> listUserId) {
		return DM_User.getInstance().getAllUsers(listUserId);
	}


	/*
	* @description : Method to get the current User Account
	* @return : List<Account>
	*/
	public static Account getCurrentUserAccount(Id accountId) {
		return DM_User.getInstance().getCurrentUserAccount(accountId);
	}


	/*
	* @description : Method to get the current User Owner
	* @return : User
	*/
	public static User getCurrentUserOwner(Id userId) {
		return DM_User.getInstance().getCurrentUserOwner(userId);
	}


	/*
	* @description : Method to get the Map of User Owners
	* @return : Map<Id, User>
	*/
	public static Map<Id, User> getUserOwnerMap(Set<Id> userIds) {
		return DM_User.getInstance().getUserOwnerMap(userIds);
	}



}