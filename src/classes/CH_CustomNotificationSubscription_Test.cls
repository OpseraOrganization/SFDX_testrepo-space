/*******************************************************************************************************************
* Test Class Name: CH_CustomNotificationSubscription_Test
* This test Class covers the code coverage for CH_NotificationSubsciptionWrapper and CH_CustomNotificationSubscription
* Developed By : TCS
* Developer Name: Akhil Ramisetty
* Last Modified (By&On):  Akhil Ramisetty on 17.08.2020
*******************************************************************************************************************/
@istest
public class CH_CustomNotificationSubscription_Test {
	Static testmethod void CH_NotificationSubsciptionWrapper(){
	  	Set<String> recipientIds;
		test.StartTest();
		CH_NotificationSubsciptionWrapper wrapper = new CH_NotificationSubsciptionWrapper(Label.CH_CustomNotificationID, 'title',  'body','targetId',recipientIds);
		test.StopTest();
	}
	
	static testmethod void sendCustomNotification(){
		String body;		
		test.StartTest();
		CH_CustomNotificationSubscription.sendCustomNotification('body');
		test.StopTest();
		
	}
	
	static testmethod void sendCustomNotification1(){
		String body='"inputs":[{"title":"New Major Case with Outage","targetId":"50054000007DeqdAAC","recipientIds":["0052M000008cGrBQAU","0052M000009CjuvQAC"]}]';   
		test.StartTest();		
		Test.setMock(HttpCalloutMock.class, new CH_CustomNotificationSubscription_Test.MockHttpCAPSresponse());
		CH_CustomNotificationSubscription.sendCustomNotification('body');
		test.StopTest();
	}
	
	public class MockHttpCAPSresponse implements HttpCalloutMock{
	public HTTPResponse respond(HTTPRequest req){
	  HttpResponse res = new HttpResponse();
	  res.setHeader('Content-Type', 'application/json');
	  res.setBody('{"example":"test"}');
	  res.setStatusCode(200);
	  return res;
	}
  }
}