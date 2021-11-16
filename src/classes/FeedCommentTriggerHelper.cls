/****************************************
 * Class Name : FeedCommentTriggerHelper
 * Created Date: 7 FEB 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Handle the sequence of the FeedCommentTriggerHandler
 * Test Class: 
 *****************************************/
public class FeedCommentTriggerHelper{
	
	/*********************************
	* author: Accenture
	* Date: 7 FEB 2017
	* Param: List<FeedComment> feedCommentTriggerList
	* Return: None
	* Description: check file uploaded by Chatter Comment or not, If not, allow chatter post. If attachment there, through error message.
	* High Level Process :	 
	**********************************/
	public static void checkFIleUploadedViaChatterPost(List<FeedComment> feedCommentTriggerList){  
		Set<String> allowedProfileSet = new Set<String>();
		Try{
			system.debug('UserInfo.getUiTheme()>>>>>>>'+UserInfo.getUiTheme());
			String loggedInUserProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1][0].Name;
			String allowedProfileStr = File_Sharing_Custom_Setting__c.getValues(GlobalConstants.ALLOWED_PROFILES_FOR_CHATTER_FILES).Value__c;
			if(!String.IsBlank(allowedProfileStr)){
				for(String profileName: allowedProfileStr.split(GlobalConstants.COMMA)){
					allowedProfileSet.add(profileName.trim());
				}
			}			
			for(FeedComment feedCommentRec : feedCommentTriggerList){		   
				if(!allowedProfileSet.IsEmpty() && !allowedProfileSet.contains(loggedInUserProfile) && UserInfo.getUiTheme() == GlobalConstants.USER_UI_THEME_MOBILE && (feedCommentRec.CommentType.EqualsIgnoreCase(GlobalConstants.CHATTER_COMMENT_CONTENT_POST_TYPE) || feedCommentRec.CommentBody.Contains(File_Sharing_Custom_Setting__c.getValues(GlobalConstants.CHATTER_FILE_INLINE_BODY_CUST_SETTING).Value__c))){				  
					feedCommentRec.addError(File_Sharing_Custom_Setting__c.getValues(GlobalConstants.CHATTER_FILE_UPLOAD_ERROR_MESSAGE_CUST_SETTING).Value__c);
				}
				else if(allowedProfileSet.IsEmpty() && UserInfo.getUiTheme() == GlobalConstants.USER_UI_THEME_MOBILE && (feedCommentRec.CommentType.EqualsIgnoreCase(GlobalConstants.CHATTER_COMMENT_CONTENT_POST_TYPE) || feedCommentRec.CommentBody.Contains(File_Sharing_Custom_Setting__c.getValues(GlobalConstants.CHATTER_FILE_INLINE_BODY_CUST_SETTING).Value__c))){
					feedCommentRec.addError(File_Sharing_Custom_Setting__c.getValues(GlobalConstants.CHATTER_FILE_UPLOAD_ERROR_MESSAGE_CUST_SETTING).Value__c);
				}
						
			}										
		}Catch(Exception ex){
			ExceptionHandler.addException(ex, FeedCommentTriggerHelper.class.getName(), GlobalConstants.METHOD_CHECK_FILE_UPLODED_VIA_CHATTER_POST);
		}
													
	}
	
	 
}