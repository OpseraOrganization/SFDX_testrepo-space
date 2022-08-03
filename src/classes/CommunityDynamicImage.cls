/**
* Created By: Accenture IDC
* Created Date: 4/24/2017
**/
public without sharing class CommunityDynamicImage {
	@AuraEnabled
	/**
* Description : Method to return the Partner type of logged in user.
* @param NA 
* @return String
**/
	public static String getUserPartner(){
		String userType;
		try{
			Id currentuserId = UserInfo.getUserId();
			User currentuser = [select id,Contact.User_Partner_Type__c from user where id=:currentuserId limit 1];
			userType = currentuser.Contact.User_Partner_Type__c;
			if(Test.isRunningTest()){
				currentuser.Contact.User_Partner_Type__c = PRMGlobalConstants.Testtext;
			}
			
		}
		catch(Exception e){
			
			ExceptionHandler.addException(e,PRMGlobalConstants.CommunityDynamic_Controller ,PRMGlobalConstants.GET_UserPartner);
		}
		return userType;
	}
	@AuraEnabled
	/**
* Description : Method to return the list of User Partner type.
* @param NA 
* @return List
**/
	public static List<User_Partner_Type__c> getUserHeading(){
		List<User_Partner_Type__c> lstUser = new List<User_Partner_Type__c>();
		try{
			lstUser = User_Partner_Type__c.getAll().values();
		}
		catch(Exception e){
		  ExceptionHandler.addException(e,PRMGlobalConstants.CommunityDynamic_Controller ,PRMGlobalConstants.GET_UserHeading);  
		}
		return lstUser;
	}
}