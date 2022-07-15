/********************************************************************************
* Name : HWS_GetMapLocation_Test
* Author : deeksha.1.gupta@nokia.com
* Description : Test class for class HWS_GetMapLocation
********************************************************************************/
@isTest
public class HWS_GetMapLocation_Test {
	public static testmethod void testGetTranslatedAddress(){
		List<String> inputAddress = new list<String>{'1+Wangjing+E+Rd+中国北京市朝阳区望京街道望京东路1号+邮政编码:+100017'};
		String srcLangCode = 'zh';
		String tarLangCode = 'en';
		Test.setMock(HttpCalloutMock.class, new RestMock());
		Test.startTest();
		String translatesAddress = HWS_GetMapLocation.getTranslatedAddress(inputAddress,srcLangCode,tarLangCode);
		Test.stopTest();
		System.assertEquals(translatesAddress, '1 Wangjing E Rd No. 1, Wangjing East Road, Wangjing Street, Chaoyang District, Beijing, China Postal Code: 100017');
	}
	//mock class for callout
	private class RestMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			String mockJson = '{ "data": { "translations": [ { "translatedText": "1 Wangjing E Rd No. 1, Wangjing East Road, Wangjing Street, Chaoyang District, Beijing, China Postal Code: 100017" } ] } }';
			HTTPResponse res = new HTTPResponse();
			res.setHeader('Content-Type', 'text/json');
			res.setBody(mockJson);
			res.setStatusCode(200);
			return res;
		}
	}
}