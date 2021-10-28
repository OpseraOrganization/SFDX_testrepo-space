/**
About
-----
Description: This Class is used as Controller for Lightning Component accountManagement.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
public without sharing class NIA_AccountManagementController
{
	/**
	*   @desc : Get CurrentManagerContacts
	*   @param : Return User Record
	*/
	@AuraEnabled(cacheable=true)
	public static user getcurrentuserContactcard()
	{
		User Currentuserowner;
		Account CurrentuserAccount;

		try
		{
			Id userId =UserInfo.getUserId();

			User Currentuser = EM_User.getCurrentUser(userId);

			if(Currentuser != NULL && Currentuser.AccountId != NULL)
			{
				CurrentuserAccount = EM_User.getCurrentUserAccount(CurrentUser.AccountId);
			}

			if(CurrentuserAccount != NULL && CurrentuserAccount.ownerid != NULL)
			{
				Currentuserowner = EM_User.getCurrentUserOwner(userId);
			}

		}catch(Exception ex)
		{
			System.assert(NULL != ex.getStackTraceString());
		}
		return Currentuserowner;
	}
}