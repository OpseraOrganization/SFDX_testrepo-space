@isTest
Private class SendNotificationTest
{
	@testSetup
	private static void setup()
	{
		CustomNotificationType notifType = new CustomNotificationType();
		notifType.DeveloperName = 'User_Notifications';
		notifType.Mobile = true;
		notifType.Desktop = true;
	}
	
	private static testMethod void generateNotification()
	{
		CustomNotificationType notifType = [SELECT Id FROM CustomNotificationType WHERE DeveloperName = 'User_Notifications' LIMIT 1];
		if(notifType != null)
			SendNotification.send(notifType.Id, 'test', UserInfo.getUserId());
		else
			SendNotification.send(null, 'test', UserInfo.getUserId());
	 }
}