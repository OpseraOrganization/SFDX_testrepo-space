/*******************************************************************************************************************
* Apex Class Name: CH_NotificationSubsciptionWrapper
* This Class will recieve the Custom notification id,receipentids,Targetid,title and body for sending email and Push Notifications
* This wrapperclass will use for creating Json request
* Developed By : TCS
* Developer Name: Akhil Ramisetty
* Test Class Name: CH_CustomNotificationSubscription_Test
* Last Modified (By&On):  Akhil Ramisetty on 07.08.2020
*******************************************************************************************************************/

public class CH_NotificationSubsciptionWrapper {
		Public string customNotifTypeId;
		Public String title;
		Public String body;
		Public String targetId;
		Public Set<String> recipientIds;
		
		public CH_NotificationSubsciptionWrapper(String customNotifId, String Title, String Body, String TargerID, Set<String> recipientIds){
			this.customNotifTypeId = customNotifId;
			this.title = Title;
			this.body = Body;
			this.targetId = TargerID;
			this.recipientIds = recipientIds;
		}
	
	public class jsonRequest{
		public List<CH_NotificationSubsciptionWrapper> inputs;
	}
}