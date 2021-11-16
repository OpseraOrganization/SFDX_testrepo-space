/*
Class Name: CAPS_DownloadMockHttpResponseS3Fail
Date: 24-October-2019
Description: Mock response for CAPS Download
*/
@isTest
global class CAPS_DownloadMockHttpResponseS3Fail implements HttpCalloutMock {
	/*
	fake response
	*/
	global HTTPResponse respond(HTTPRequest req) {
		//System.assertEquals('POST', req.getMethod())
		if(req.getEndpoint().startsWith('https://capsv.nokia.com/93f6cc8e/api/s3sign')){
			String jsonResponse = '{"error":{"url":"/xe4dd3ac/Privacy_Restricted_Data_Rules.pdf","code":400,"message":"'+
			'This is error from CAPSV,This is error from CAPSV,This is error from CAPSV,This is error from CAPSV,This is error from CAPSV,This is error from CAPSV,This is error from CAPSV"}}';
			// Create a fake response
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody(jsonResponse);
			res.setStatusCode(400);
			return res;
		}else{
			String jsonResponse = '{"id":"df330b2ea42b4e55b61f2647eb710f89","owner":"app_salesforce","owner_name":" ",'+
							'"owner_email":"ignore@nokia.com","app":"Salesforce","classification":{"id":14,"name":"Non-Sensitive Data"},'+
							'"classifications":[{"id":14,"name":"Non-Sensitive Data"}],"nctclassification":null,'+
							'"customer":{"id":31502,"id_cdb":"76521","name":"Verizon Wireless, US","country_code":"US"},'+
							'"product":{"id":5442,"id_cdb":"133-047489_00","id_caps_identifier":"lte-and-flexi-zone-sw",'+
							'"name":"Flexi Multiradio BTS LTE"},"productversion":null,"ticket":null,"description":"test",'+
							'"purpose":"test","files":[{"id":387522,"name":"16MBTET1.txt","size":17064741,"type":"original",'+
							'"status":"deleted","s3keyname":"df330b2ea42b4e55b61f2647eb710f89/16MBTET1.txt","processing_time":null,'+
							'"s3_time":null,"dpc_id":null,"virus_scan_status":1},{"id":387532,"name":"16MBTET1.txt.encrypted.zip",'+
							'"size":3472,"type":"encrypted","status":"ready","s3keyname":"df330b2ea42b4e55b61f2647eb710f89/16MBTET1.txt.encrypted.zip",'+
							'"processing_time":70,"s3_time":35,"dpc_id":null,"virus_scan_status":1}],"creation_time":"2018-07-27T05:40:38.190747-05:00",'+
							'"deletion_time":null,"retention_days":null,"status":null,'+
							'"encryption_key":"e8cf1660669b123f4351fd85196889de","evaporate":{"bucket":"capsvtest1",'+
							'"max_concurrent_parts":2,"sign_params":{"user":"testtttt","expiration":1532757105,"permission":"R",'+
							'"signer":"bdc7f90cef7345c984f9e34d25e0c192","signtoken":"63823fceca9aeed2-842e632dcc8ae6348177520d00057bd975e949cccd4791fde62e28b494a5e386"},'+
							'"aws_signature_version":"2","s3_region":"us-east-1",'+
							'"aws_url":"https://s3.capsv.nokia.com/a848be61/us2","part_size":33554432,"acl":"private",'+
							'"aws_key":"RZZVJKQRQUBLHMVWYTJ_","signer_url":"https://capsv.nokia.com/93f6cc8e/api/s3sign"},'+
							'"download_url":"https://capsv.nokia.com/93f6cc8e/downloadattachment?id=df330b2ea42b4e55b61f2647eb710f89",'+
							'"download_url_external":"https://capsv.nokia.com/93f6cc8e/external/downloadattachment?id=df330b2ea42b4e55b61f2647eb710f89",'+
							'"skip_scrambling":false,"service_class":"CARE","nct_lawful_intercept":null,"nct_case_status":null,"customer_visible":true,'+
							'"retentiondaysleft":"N/A","capsrt_issue":77041}';
			// Create a fake response
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody(jsonResponse);
			
			res.setStatusCode(200);
			return res;
		}
	}
}