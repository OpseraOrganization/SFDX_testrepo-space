/****************************************
 * Class Name : FeedItemTriggerHelper
 * Created Date: 7 FEB 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Handle the sequence of the FeedItemTriggerHandler
 * Test Class: 
 *****************************************/
public class FeedItemTriggerHelper{
	
	/*********************************
	* author: Accenture
	* Date: 7 FEB 2017
	* Param: List<FeedItem> feedItemTriggerList
	* Return: None
	* Description: check file uploaded by Chatter post or not, If not allow chatter post. If attachment there, through error message.
	* High Level Process :	 
	**********************************/
	public static void checkFIleUploadedViaChatterPost(List<FeedItem> feedItemTriggerList){
		System.debug('feedItemTriggerList : '+feedItemTriggerList);			
		Set<String> allowedProfileSet = new Set<String>();
		Try{
			String loggedInUserProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1][0].Name;
			String allowedProfileStr = File_Sharing_Custom_Setting__c.getValues(GlobalConstants.ALLOWED_PROFILES_FOR_CHATTER_FILES).Value__c;
			if(!String.IsBlank(allowedProfileStr)){
				for(String profileName: allowedProfileStr.split(GlobalConstants.COMMA)){
					allowedProfileSet.add(profileName.trim());
				}
			}
			system.debug('allowedProfileSet>>>'+allowedProfileSet);
			for(FeedItem feedItemRec : feedItemTriggerList){
				if(!allowedProfileSet.IsEmpty() && !allowedProfileSet.contains(loggedInUserProfile) && UserInfo.getUiTheme() == GlobalConstants.USER_UI_THEME_MOBILE && (feedItemRec.type.EqualsIgnoreCase(GlobalConstants.CHATTER_CONTENT_POST_TYPE) || feedItemRec.body.Contains(File_Sharing_Custom_Setting__c.getValues(GlobalConstants.CHATTER_FILE_INLINE_BODY_CUST_SETTING).Value__c))){
					//system.debug('inside If>>>loggedInUserProfile>>>'+ loggedInUserProfile);
					feedItemRec.addError(File_Sharing_Custom_Setting__c.getValues(GlobalConstants.CHATTER_FILE_UPLOAD_ERROR_MESSAGE_CUST_SETTING).Value__c);
				}
				else if(allowedProfileSet.IsEmpty() && UserInfo.getUiTheme() == GlobalConstants.USER_UI_THEME_MOBILE && (feedItemRec.type.EqualsIgnoreCase(GlobalConstants.CHATTER_CONTENT_POST_TYPE) || feedItemRec.body.Contains(File_Sharing_Custom_Setting__c.getValues(GlobalConstants.CHATTER_FILE_INLINE_BODY_CUST_SETTING).Value__c))){
					//system.debug('inside Else If>>>loggedInUserProfile>>>'+ loggedInUserProfile);
					feedItemRec.addError(File_Sharing_Custom_Setting__c.getValues(GlobalConstants.CHATTER_FILE_UPLOAD_ERROR_MESSAGE_CUST_SETTING).Value__c);
				}
			}
		}
		 catch(Exception ex) {
			ExceptionHandler.addException(ex, FeedItemTriggerHelper.class.getName(), GlobalConstants.METHOD_CHECK_FILE_UPLODED_VIA_CHATTER_POST);
		}
	}
	
	 
		
}