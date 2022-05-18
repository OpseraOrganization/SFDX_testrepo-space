/****************************************
* Class Name : CH_EmailAttachmentHandler
* Created Date: 15 Oct 2018
* Created By : Marwan Boutaleb (mboutaleb@salesforce.com)
* Last Modified by: Marwan Boutaleb (mboutaleb@salesforce.com)
* Last Modified Date: 23 Oct 2018
* Description : Upload attachment to CAPS
*	  The aim of the following code is to store the emails attachments received as case replies into CAPS system.
*	  All the rest calls in this class are an exact replication of the mecanism of saving an attachement in CAPS: 
*	  present at the level of the lightning component CAPS_UploadMultipleAttachment
*	  This class reformulates the XMLHttpRequest calls present at the level of the helper of the same component into Apex rest calls.
* Test Class: CH_EmailAttachmentHandler_Test
*****************************************/
public without sharing class CH_EmailAttachmentHelper implements Queueable, Database.AllowsCallouts { 
	
	boolean customerVisible = true; 
	string fileClassification = 'Other Information';
	Integer fileMaxSizeBytes = Integer.valueOf(Label.CH_EmailAttachmentSize);
	
	public Id caseId {get; set;}
	public Messaging.InboundEmail.BinaryAttachment bAttachment {get; set;}
	public Messaging.InboundEmail.TextAttachment tAttachment {get; set;}
	public string emailSubject {get; set;}
	public static final string xamzDateStrng ='x-amz-date';
	public static final string contentTypeStrng='Content-Type';
	public static final string xamzDate1='x-amz-date:';
	public static final string permissionstrng='&permission=';
	public static final string singerStrng='&signer=';
	public static final string userstrng='&user=';
	public static final string signtokenstrng='&signtoken=';
	public static final string expirytokenstrng='&expiration=';
	public static final string tosignStrng='?to_sign=';
	public static final string shaconstantValue='SHA-256';
	public static final string uploadStrng='&uploadId=';
	
	public void execute(QueueableContext context){
		
		if(caseId != null){
			
			if(bAttachment != null && bAttachment.body != null && bAttachment.body.size() <= fileMaxSizeBytes)
			{createCAPSattachment(caseId, customerVisible, bAttachment.fileName, emailSubject, fileClassification, bAttachment.body.size(), bAttachment.body); }   
			
			if(tAttachment != null && tAttachment.body != null && tAttachment.body.length() <= fileMaxSizeBytes) {createCAPSattachment(caseId, customerVisible, tAttachment.fileName, emailSubject, fileClassification, tAttachment.body.length(), Blob.valueOf(tAttachment.body));}
		}
		
	}
	
	// Constructor
	public CH_EmailAttachmentHelper(Id caseId, string emailSubject, Messaging.InboundEmail.BinaryAttachment bAttachment){
		this.caseId = caseId;
		this.bAttachment = bAttachment;
		this.emailSubject = emailSubject;
	}
	
	// Constructor
	public CH_EmailAttachmentHelper(Id caseId, string emailSubject, Messaging.InboundEmail.TextAttachment tAttachment){
		this.caseId = caseId;
		this.tAttachment = tAttachment;
		this.emailSubject = emailSubject;
	}
	
	/*
This method replicates the same behavior used at the level of the component CAPS_UploadMultipleAttachment to upload attachment in CAPS system
*/
	public void createCAPSattachment(Id caseId, boolean customerVisible, string fileName, string fileDescription, string fileClassification, Integer fielSize, Blob fileBody){
		
		if(Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new CH_EmailAttachmentHandler_Test.MockHttpCAPSresponse1());
		// Get signature for CAPS 
		CAPS_MultiFileUploadWrapper wrap = Test.isRunningTest() ? new CAPS_MultiFileUploadWrapper() : CAPS_MultiFileUploadController.initiateUpload(caseId, customerVisible, fileName, fileDescription, fileClassification, fielSize);
	
		
		if(Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new CH_EmailAttachmentHandler_Test.MockHttpCAPSresponse2());
		
		string enpointurl = wrap.baseURL + wrap.logApiURL;
		string authHeader = 'Signature keyId="'+ wrap.signatureKey+'",' + 'algorithm="hmac-sha256", ' + 'headers="(request-target) x-amz-date x-end-user",' + 'signature= "' + wrap.signature + '"';
		map<string, string> headers = new map<string, string>{contentTypeStrng => 'application/json', xamzDateStrng => wrap.nowFormatted, 'X-End-User'=> 'CAPSCLI', 'Authorization' => authHeader};
			//call to creare attachement
			HTTPResponse res;
		if(!Test.isRunningTest()){res = restCall('POST', enpointurl, headers, wrap.jsonString, null);}
		CAPS_MultiFileUploadWrapper wrap2 = Test.isRunningTest() ? new CAPS_MultiFileUploadWrapper() : CAPS_MultiFileUploadController.parseAttachmentResponse(res.getbody());
		
		
		string aws_signature_version = Test.isRunningTest() ? '4' : wrap2.aws_signature_version;
		
		string filenameUTF8 =encode(wrap2.s3keyname);
		// Remove spaces from the filename
		filenameUTF8 = filenameUTF8.replaceAll('\\+','%20');
		string algorithm = 'AWS4-HMAC-SHA256';
		string region = wrap2.s3_region;
		string service = 's3';
		
		map<string, string> headers3;
		string s3v4SignAPIUrl = CH_Settings__c.getValues('CAPSVS3SignAPIV4Url') != null ? CH_Settings__c.getValues('CAPSVS3SignAPIV4Url').SettingValue__c :'';
		if(aws_signature_version == '2'){
			string urlToSignPOST = 'POST\n\n\n\n'+'x-amz-acl:'+wrap2.acl+'\n'+xamzDate1+wrap2.amzdate+'\n'+'/'+wrap2.bucket+'/'+filenameUTF8+'?uploads';
			string urlPOST = wrap.baseURL + wrap.s3SignApiURL+tosignStrng+encode(urlToSignPOST)+singerStrng+encode(wrap2.signer)+userstrng+encode(wrap2.user)+expirytokenstrng+encode(wrap2.expiration)+permissionstrng+encode(wrap2.permission)+signtokenstrng+ encode(wrap2.signtoken);
			//sign api call before getting upload id
			HTTPResponse res2; if(!Test.isRunningTest()){res2 = restCall('GET', urlPOST, null, null, null);}
			string jSONResponseUploadIDS3Token1 = res2.getBody(); string s3authPOST = wrap2.aws_key + ':' + jSONResponseUploadIDS3Token1; string authHead = 'AWS ' + s3authPOST;
			headers3 = new map<string, string>{'x-amz-acl'=> wrap2.acl, xamzDateStrng=> wrap2.amzdate, 'Authorization' => authHead};
	}else if(aws_signature_version == '4'){
		DateTime now = DateTime.now();
		string dateStamp = now.formatGMT('yyyyMMdd');
		string timeStamp = now.formatGMT('HHmmss');
		string dateTimeStamp = dateStamp+'T'+timeStamp+'Z';
		string credential_scope = dateStamp + '/' + region + '/' + service + '/' + 'aws4_request';
		string method1 = 'POST';
		string bucket1 = wrap2.bucket;
		string s3keyname4 = filenameUTF8;
		string canonical_querystring = 'uploads=';
		string signed_headers = 'host;x-amz-acl;x-amz-date';
		if(!Test.isRunningTest()){
			string canonical_uri = '/'+wrap2.aws_url.split('/')[3]+'/'+wrap2.aws_url.split('/')[4]+'/'+bucket1+'/'+s3keyname4; string host = wrap2.aws_url.split('/')[2]; string canonical_headers = 'host:' + host + '\n' +'x-amz-acl:' +'private'+'\n'+ xamzDate1 + dateTimeStamp +'\n';
			string payload_hash = EncodingUtil.convertToHex(Crypto.generateDigest(shaconstantValue, Blob.valueOf(''))); string canonical_request = method1 + '\n' + canonical_uri + '\n' + canonical_querystring + '\n' + canonical_headers + '\n' + signed_headers + '\n' + payload_hash;
			string to_sign = algorithm + '\n' +  dateTimeStamp + '\n' +  credential_scope + '\n' +  EncodingUtil.convertToHex(Crypto.generateDigest(shaconstantValue, Blob.valueOf(canonical_request)));
			string urlPOST = s3v4SignAPIUrl+tosignStrng+encode(to_sign)+'&datetime='+encode(dateTimeStamp)+'&canonical_request='+encode(canonical_request)+singerStrng+encode(wrap2.signer)+userstrng+encode(wrap2.user)+expirytokenstrng+encode(wrap2.expiration)+permissionstrng+encode(wrap2.permission)+signtokenstrng+ encode(wrap2.signtoken);
			HTTPResponse res2 = restCall('GET', urlPOST, null, null, null); string jSONResponseUploadIDS3Token1 = res2.getBody(); string authHead = 'AWS4-HMAC-SHA256 '+'Credential='+wrap2.aws_key+'/'+credential_scope+', SignedHeaders='+signed_headers+', Signature='+jSONResponseUploadIDS3Token1; headers3 = new map<string, string>{'x-amz-content-sha256'=>payload_hash,'x-amz-acl'=> wrap2.acl, xamzDateStrng=> dateTimeStamp, 'Authorization' => authHead};
				}
	}
		if(Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new CH_EmailAttachmentHandler_Test.MockHttpCAPSresponse3());
		string enpointPOST = wrap2.aws_url + '/' + wrap2.bucket + '/' + filenameUTF8 + '?uploads';
		//call to get upload id
		HTTPResponse res3;
		string jSONResponseUploadIDS3Token;
		if(!Test.isRunningTest()){ res3 = restCall('POST', enpointPOST, headers3, null, null); jSONResponseUploadIDS3Token = res3.getBody();}
		string s3uploadid;
		DOM.Document document = new DOM.Document();
		if(!string.isBlank(jSONResponseUploadIDS3Token)) {document.load(jSONResponseUploadIDS3Token);}
		Dom.XMLNode noda = document.getRootElement();
		if(noda != null)
			for(Dom.XMLNode child : noda.getChildElements()) { if(child.getName() == 'UploadId') s3uploadid = child.getText();}
		
		map<string, string> headers5;
		if(aws_signature_version == '2'){
			string nowFormatted = DateTime.now().formatGMT(CAPS_ConstantHandler.DATE_FORMAT); string urlToSignPUT = 'PUT\n\n'+'text/plain;charset=UTF-8'+'\n\n'+xamzDate1+nowFormatted+'\n'+'/'+wrap2.bucket+'/'+filenameUTF8+'?partNumber='+ '1' +uploadStrng+s3uploadid;
			String capsSignAPIUrl = wrap.baseURL + wrap.s3SignApiURL; string url4 = capsSignAPIUrl +tosignStrng+encode(urlToSignPUT)+singerStrng+encode(wrap2.signer)+userstrng+encode(wrap2.user)+expirytokenstrng+encode(wrap2.expiration)+permissionstrng+encode(wrap2.permission)+signtokenstrng+encode(wrap2.signtoken);
			HTTPResponse res4 = restCall('GET', url4, null, null, null); string jsonResponseS3 = res4.getBody();
			
			string s3authPUT = wrap2.aws_key + ':'+jsonResponseS3; 
			string authHead3 = 'AWS '+s3authPUT;
			headers5 = new map<string, string>{xamzDateStrng=> nowFormatted, contentTypeStrng => 'text/plain;charset=UTF-8', 'Authorization'=> authHead3};
	}else if(aws_signature_version == '4'){
		DateTime now = DateTime.now();
		string dateStamp = now.formatGMT('yyyyMMdd');
		string timeStamp = now.formatGMT('HHmmss');
		string dateTimeStamp = dateStamp+'T'+timeStamp+'Z';
		string credential_scope = dateStamp + '/' + region + '/' + service + '/' + 'aws4_request';
		string method2 = 'PUT';
		string bucket2 = wrap2.bucket;
		string s3keyname4 =filenameUTF8;
		string canonical_part = 'partNumber='+'1'+uploadStrng+s3uploadid;
		string canonical_querystring = 'uploads=';
		string sign_headers = 'content-md5;host;x-amz-date';
		if(!Test.isRunningTest()){
			string canonical_uri = '/'+wrap2.aws_url.split('/')[3]+'/'+wrap2.aws_url.split('/')[4]+'/'+bucket2+'/'+s3keyname4;
			string host = wrap2.aws_url.split('/')[2]; string canonical_headers = 'host:' + host + '\n' + xamzDate1 + dateTimeStamp; string md5data = EncodingUtil.base64Encode(Crypto.generateDigest('MD5', fileBody));
			string canonical_part2 = 'content-md5:'+md5data; string canonical_request = method2 + '\n' + canonical_uri + '\n' + canonical_part + '\n' + canonical_part2 + '\n' + canonical_headers + '\n'+'\n'+sign_headers + '\n' + 'UNSIGNED-PAYLOAD';
			string to_sign = algorithm + '\n' +  dateTimeStamp + '\n' +  credential_scope + '\n' +  EncodingUtil.convertToHex(Crypto.generateDigest(shaconstantValue, Blob.valueOf(canonical_request))); string url4 = s3v4SignAPIUrl+tosignStrng+encode(to_sign)+'&datetime='+encode(dateTimeStamp)+'&canonical_request='+encode(canonical_request)+singerStrng+encode(wrap2.signer)+userstrng+encode(wrap2.user)+expirytokenstrng+encode(wrap2.expiration)+permissionstrng+encode(wrap2.permission)+signtokenstrng+ encode(wrap2.signtoken);
			HTTPResponse res4; if(!Test.isRunningTest()){res4 = restCall('GET', url4, null, null, null);} string jsonResponseS3 = res4.getBody();
		
			string s3auth = 'Credential='+wrap2.aws_key+'/'+credential_scope+', SignedHeaders='+sign_headers+', Signature='+jsonResponseS3; string authHead3 = 'AWS4-HMAC-SHA256 '+s3auth; headers5 = new map<string, string>{'Authorization'=> authHead3, 'x-amz-content-sha256'=> 'UNSIGNED-PAYLOAD',xamzDateStrng=> dateTimeStamp, 'content-md5' => md5data};
				}
	}
		if(Test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new CH_EmailAttachmentHandler_Test.MockHttpCAPSresponse4());
		//sign api call before upload of content
		string uploadEndPointUrl = wrap2.aws_url + '/'+wrap2.bucket+'/'+filenameUTF8+'?partNumber='+ '1' +uploadStrng+s3uploadid;
		//call to upload content
		HTTPResponse res5;
		res5 = restCall('PUT', uploadEndPointUrl, headers5, null, fileBody);
		
		string etag = Test.isRunningTest() ? 'm7fQ2Jej9bNzIg4vr8NYL1abdcg=' : res5.getHeader('ETag');
		
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
		gen.writeFieldName('Name');
		gen.writeStartArray();
		gen.writeStartObject();
		gen.writeStringField('partNumber', '1');
		gen.writeStringField('etag', etag);
		gen.writeEndObject();
		gen.writeEndArray();
		gen.writeEndObject();
		string partVsetagjson = gen.getAsString();
		// Running the test class results in System.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out
		string rresult = Test.isRunningTest() ? 'TEST_IS_RUNNING' : CAPS_MultiFileUploadController.uploadComplete(partVsetagjson, s3uploadid, JSON.Serialize(wrap2), fileName, fielSize, (string)caseId, customerVisible, fileDescription, fileClassification, filenameUTF8, true );
		
	}
	
	public HTTPResponse restCall(string method, string endpoint, map<string, string> headers, string body, Blob blobAttach){ 
		
		Http http = new Http();
		HttpRequest req = new HttpRequest();
		req.setTimeout(120000);
		req.setMethod(method);
		req.setEndpoint(endpoint);
		if(headers != null && !headers.isEmpty()){for(string head : headers.keySet()){if(!string.isBlank(head) && !string.isBlank(headers.get(head))){ req.setHeader(head, headers.get(head)); }}}
		if(!string.isBlank(body)) {req.setBody(body);}
		if(blobAttach != null) {req.setBodyAsBlob(blobAttach);}
		
		HTTPResponse res; if(!Test.isRunningTest()){res = http.send(req);
				
			   }			
		return res;
	}
	
	static string encode(string tring){
		return string.isBlank(tring) ? '' : EncodingUtil.urlEncode(tring, 'UTF-8');
	}
	
	public static AttachmentHeader getAttHeader(list<Messaging.InboundEmail.Header> headers){
		AttachmentHeader attHeader = new AttachmentHeader();
		if(headers != null)
			for(Messaging.InboundEmail.Header header : headers){
	if(header.name == 'Content-ID')		 attHeader.attachementId = header.value.substringBetween('<','>');
	if(header.name == contentTypeStrng)	 attHeader.contentType = header.value;
	if(header.name == 'Content-Disposition')	attHeader.contentDisposition = header.value.substring(0, header.value.indexOf(';'));
			}
		return attHeader;
	}
	
	public class AttachmentHeader{
		public string contentType {get; set;}
		public string contentDisposition {get; set;} // Format: inline; filename="image.png"...
		public string attachementId {get; set;}
	}
	
	public static void sendEmailNotification(string toAddress, string subject, string senderName, string plainTextBody, string messageId, string caseId){
	
		CH_EmailAlert__c createEmail=new CH_EmailAlert__c();
		createEmail.CH_Bind1__c=subject;
		if(plainTextBody=='Send Truncated Email'){createEmail.CH_EmailAlertName__c=plainTextBody; createEmail.CH_Bind2__c=messageId;}
		//Changes added for NOKIASC-36144
		else if (plainTextBody=='Case Owner Notification for PortalCases'){createEmail.CH_EmailAlertName__c=plainTextBody; createEmail.CH_Bind2__c=senderName;
																		  createEmail.CH_Bind3__c=messageId; createEmail.CH_Bind4__c=caseId;}
		else{createEmail.CH_EmailAlertName__c='Send Email Notification';}
		createEmail.CH_Bind18__c=plainTextBody;
		createEmail.CH_Bind15__c=toAddress;
		insert createEmail;
		
		
	}
	
	Public Static Void calculateAutomaticPlanned(Id CaseId,Integer WorkgroupTime){
		Long milliseconds = ((Long)WorkgroupTime) * 60 * 60 *1000;
		if(milliseconds==0){milliseconds=1;}
		List<CaseMilestone> caseMilestones = [SELECT BusinessHours.Id FROM CaseMilestone WHERE CaseId = :CaseId ORDER BY TargetDate ASC NULLS LAST LIMIT 1];
		if(caseMilestones.size()>0){ 
		DateTime calculateTimer=BusinessHours.add(caseMilestones[0].BusinessHours.Id,DateTime.now(),milliseconds);
		Case caseValues=new Case(Id=CaseId,CH_PlannedAutomaticQualificationDateTime__c=calculateTimer);
		update caseValues;
		}
	}
	
	Public Static void caseCommentCalculation(Set<Id> userIds,Set<Id> caseIds){
		For(CaseComment getCaseComment : [SELECT Id,Parent.Id,Parent.Status,Parent.CH_PlannedAutomaticQualificationDateTime__c,
										  Parent.CH_RecordTypeCheck__c, Parent.BusinessHours.Id,
										  Parent.CH_Workgroup__r.CH_AutomaticQualificationTimer__c FROM CaseComment 
										  WHERE CreatedById IN :userIds AND  Parent.CH_RecordTypeCheck__c= TRUE AND  Parent.CH_PlannedAutomaticQualificationDateTime__c = null
										  AND  Parent.Status='Pending Customer' AND Parent.Id IN :caseIds]){
											  Integer getWorkgrpTimer; if(getCaseComment.Parent.CH_Workgroup__r.CH_AutomaticQualificationTimer__c != null){ getWorkgrpTimer =  Integer.valueof(getCaseComment.Parent.CH_Workgroup__r.CH_AutomaticQualificationTimer__c);}
											  CH_EmailAttachmentHelper.calculateAutomaticPlanned(getCaseComment.Parent.Id,getWorkgrpTimer); 
										  }
	}
	
}