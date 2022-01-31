public with sharing class DM_User extends DM_SObject{

	private static DM_User classInstance;

	static {
		classInstance = new DM_User();
	}

	private DM_User() {}

	/**
	* @description Method provides an instance of the object.
	* @return DM_User Instance of the object.
	*/
	public static DM_User getInstance() {
		return classInstance;
	}

	/**
	* @description Method to get the current user
	* @param : Id
	* @return : List<User>
	*/
	public User getCurrentUser(Id userId) {
		return [
				SELECT
					Id,
					Name,
					Email,
					ContactId,
					SmallPhotoUrl,
					AccountId
				FROM
					User
				WHERE
					Id=:userId
		];
	}
	
	/**
	* @description Method to get all users
	* @param : List<Id>
	* @return : List<User>
	*/
	public Set<User> getAllUsers(Set<Id> listUserId) {
		Set<User> result = new Set<User>();
		result.addAll([
				SELECT
					Id,
					Name,
					Email,
					ContactId,
					SmallPhotoUrl,
					GLT_Assistant__c,
					isActive,
					AccountId
				FROM
					User
				WHERE
					Id=:listUserId
		]);
		return result;
	}

	/**
	* @description method to get the current User Account
	* @param : Id
	* @return: List<Account>
	*/
	public Account getCurrentUserAccount(Id accountId) {
		return [
				SELECT
					Id,
					OwnerId
				FROM
					Account
				WHERE
					Id=:accountId
		];
	}

	/**
	 * @description method to get the current User Owner
	 * @param Id
	 * @return List<User>
	 */
	public User getCurrentUserOwner(Id accountId) {
		return [
				SELECT
					Id,
					Name,
					FirstName,
					LastName,
					SmallPhotoUrl,
					MediumPhotoUrl,
					ContactId,
					Phone,
		GLT_Assistant__r.Email,
					GLT_Assistant__c,
					Email
				FROM
					User
				WHERE
					Id=:accountId
		];

	}

	/**
	 * @description method to get the current User Owner
	 * @param Id
	 * @return List<User>
	 */
	public Map<Id, User> getUserOwnerMap(Set<Id> userIds) {
		return new Map<Id, User>([
				SELECT
					Id,
					Name,
					FirstName,
					LastName,
					SmallPhotoUrl,
					MediumPhotoUrl,
					ContactId,
					Phone,
		GLT_Assistant__r.Email,
					GLT_Assistant__c,
					Email
				FROM
					User
				WHERE
					Id IN :userIds
		]);

	}
}