/*******************************************************************************************************************
* Apex Class Name: CH_CustomNotificationSubscription
* This Class will recieve the json request as a String for Push Notifications
* This class will use for sending Push Notifications
* Developed By : TCS
* Developer Name: Akhil Ramisetty
* Test Class Name: CH_CustomNotificationSubscription_Test
* Last Modified (By&On):  Akhil Ramisetty on 07.08.2020
*******************************************************************************************************************/

public class CH_CustomNotificationSubscription {
	
	public static void sendCustomNotification(String Body){
		List<ErrorLog__c> errorLogList = new List<ErrorLog__c>();
		ErrorLog__c errorLog = new ErrorLog__c();
		String response;
		String endPoint = URL.getSalesforceBaseUrl().toExternalForm() + Label.CH_CN_PushNotificationEndpointURL;
		HttpRequest notificationRequest = new HttpRequest();
		notificationRequest.setEndpoint(endPoint);
		notificationRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		notificationRequest.setHeader('Content-Type', 'application/json');
		notificationRequest.setBody(Body);
		system.debug(' body'+Body);
		notificationRequest.setMethod('POST');
		try{
			Http newHttp = new Http();
			HttpResponse notificationResponse  = newHttp.send(notificationRequest);
			System.debug('getStatusCode'+notificationResponse.getStatusCode());
			System.debug('getStatus	 '+notificationResponse.getStatus());
			if(notificationResponse.getStatusCode()==200){
				response =  notificationResponse.getBody();
				System.debug('Notification sent'+response);
			}else{ 
				errorLog = CH_ErrorLogUtils.createErrorLog(notificationResponse.getStatus()+'  '+notificationResponse.getBody(),'CH_CustomNotificationSubscription-sendCustomNotification','NOTIFICATION-API','Custom Notification',null);
				errorLogList.add(errorLog);
				System.debug('error in getting response');
			}
		}catch(Exception Ex){
			errorLog = CH_ErrorLogUtils.createErrorLog(Ex.getStackTraceString(),'CH_CustomNotificationSubscription-sendCustomNotification','NOTIFICATION-API','Custom Notification',null);
			errorLogList.add(errorLog);
			System.debug('callout Exception '+Ex.getMessage());
		}
		if(errorLogList.Size()>0) { 
			CH_ErrorLogUtils.insertErrorLog(errorLogList);
		}
		
	}
}