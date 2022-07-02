/*
Class Name: CAPS_UploadAttachMockHttpResponse
Date: 10-July-2018
Description: Mock response for CAPS Upload Attachment
*/
@isTest
global class CAPS_UploadAttachMockHttpResponse implements HttpCalloutMock {
	/*
	fake response
	*/
	global HTTPResponse respond(HTTPRequest req) {
		//System.assertEquals('POST', req.getMethod());
		if(req.getEndpoint().startsWith('https://capsv.nokia.com')){
		String jsonResponse = '{"id":"df330b2ea42b4e55b61f2647eb710f89","scrambled":false,"owner":"app_salesforce","owner_name":" ",'+
						'"owner_email":"ignore@nokia.com","app":"Salesforce","classification":{"id":14,"name":"Non-Sensitive Data"},'+
						'"classifications":[{"id":14,"name":"Non-Sensitive Data"}],"nctclassification":null,'+
						'"customer":{"id":31502,"id_cdb":"76521","name":"Verizon Wireless, US","country_code":"US"},'+
						'"product":{"id":5442,"id_cdb":"133-047489_00","id_caps_identifier":"lte-and-flexi-zone-sw",'+
						'"name":"Flexi Multiradio BTS LTE"},"productversion":null,"ticket":null,"description":"test",'+
						'"purpose":"test","files":[{"id":387522,"name":"test.txt","size":17064741,"type":"original",'+
						'"status":"deleted","s3keyname":"df330b2ea42b4e55b61f2647eb710f89/test.txt","processing_time":null,'+
						'"s3_time":null,"dpc_id":null,"virus_scan_status":1},{"id":387532,"name":"test.txt.encrypted.zip",'+
						'"size":3472,"type":"encrypted","status":"ready","s3keyname":"df330b2ea42b4e55b61f2647eb710f89/test.txt.encrypted.zip",'+
						'"processing_time":70,"s3_time":35,"dpc_id":null,"virus_scan_status":1}],"creation_time":"2018-07-27T05:40:38.190747-05:00",'+
						'"deletion_time":null,"retention_days":null,"status":null,'+
						'"encryption_key":"e8cf1660669b123f4351fd85196889de","evaporate":{"bucket":"capsvtest1",'+
						'"max_concurrent_parts":2,"sign_params":{"user":"testtttt","expiration":1532757105,"permission":"RW",'+
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
		else if(req.getEndpoint().startsWith('https://s3.capsv.nokia.com') && req.getEndpoint().endsWith('?uploads')){
			String xmlResponse = '<?xml version="1.0" encoding="UTF-8"?><InitiateMultipartUploadResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Bucket>capsvtest1</Bucket><Key>cf7cf5c045724b7981a234fb3117f877/test.txt</Key><UploadId>2~ijxcVVOnMUT7dCtnf6WEvREyldaGng-</UploadId></InitiateMultipartUploadResult>';
			// Create a fake response
			HttpResponse res = new HttpResponse();
			//res.setHeader('Content-Type', 'application/json');
			res.setBody(xmlResponse);
			return res;
		}
		else if(req.getEndpoint().startsWith('https://s3.capsv.nokia.com') && req.getMethod() == 'PUT'){
			HttpResponse res = new HttpResponse();
			res.setHeader('ETag', 'af104deed82e317da9658c76f2b00e3d');
			res.setBody('');
			res.setStatusCode(200);
			return res;
		}
		else if(req.getEndpoint().startsWith('https://s3.capsv.nokia.com') && req.getMethod() == 'POST'){
			String xmlResponse = '<?xml version="1.0" encoding="UTF-8"?><CompleteMultipartUploadResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Location>capsvtest1.ch-dc-s3-gsn-33.eecloud.nsn-net.net</Location><Bucket>capsvtest1</Bucket><Key>cf7cf5c045724b7981a234fb3117f877/test.txt</Key><ETag>af104deed82e317da9658c76f2b00e3d-1</ETag></CompleteMultipartUploadResult>';
			HttpResponse res = new HttpResponse();
			//res.setHeader('ETag', 'af104deed82e317da9658c76f2b00e3d');
			res.setBody(xmlResponse);
			res.setStatusCode(200);
			return res;
		}
		else{
			return null;
		}
	}
}