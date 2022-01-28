/*************************************************************************************************
 * Class Name : CAPS_UploadAttachmentRESTHelper
 * Created Date: 18 July 2018
 * Created By : TCS
 * Description: Upload attachment rest api call outs
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
*************************************************************************************************/
public class CAPS_UploadAttachmentRESTHelper {
	
	final public string BASE_URL = CAPS_ConstantHandler.BASE_URL;
	public string signer;
	public string user;
	public string expiration;
	public string permission;
	public string signtoken;
	public string tosign;
	public string bucket;
	public string s3keyname;
	public string acl;
	public string aws_url;
	public string aws_key;
	public string attachmentId;
	public string eTAG;
	public string fileId;
	public map<string,string> partNumVsEtagMap;
	public string partNumberString;
	public string upload_id;
	CAPS_UploadResponseWrapper wrapperObj;
	/*****************************************************
	* Method Name : upload
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Perform all call outs
	* Parameter: 
	* Return: CAPS_UploadResponseWrapper
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public CAPS_UploadResponseWrapper upload(Id caseRecordId, Boolean customervisible, blob jsonst, string Name, string contentType,String classifications,String description,String filename,
												Decimal filesize, Double partNumber, Boolean isLastChunk, CAPS_UploadResponseWrapper wrapperFromJs){
		wrapperObj = new CAPS_UploadResponseWrapper();
		partNumberString = String.ValueOf(Integer.ValueOf(Double.ValueOf(partNumber)));
		JSONGenerator gen;
		String jsonString;
		string ticketId = caseRecordId;
		if(partNumberString == '1'){
			List<Case> caseList = [SELECT Id, CaseNumber, Product.ProductCode, Status, CH_SecurityGroup__c, CH_Product_Release__r.CH_NSNLegacyCode__c, 
															Entitlement.ServiceContract.CH_CDB_CustomerId__c, Account.AccountNumber 
									FROM Case 
									WHERE Id =: caseRecordId 
									LIMIT 1];
			//CH_ProductRelease__c.CH_NSN_Legacy__c instead of CH_ProductRelease__c.Name once we have the field in sandbox
			string classifications1=classifications;
			//string customerIdCdb = caseList[0].Entitlement.ServiceContract.CH_CDB_CustomerId__c;// add null check for customer and product
			//string description1 =Description;
			string filename1=filename;
			gen = JSON.createGenerator(true);
			gen.writeStartObject();
			gen.writeFieldName('customer');
			gen.writeStartObject();
			if(caseList[0].Entitlement != null && caseList[0].Entitlement.ServiceContract != null && caseList[0].Entitlement.ServiceContract.CH_CDB_CustomerId__c != null){
				gen.writeStringField('id_cdb', caseList[0].Entitlement.ServiceContract.CH_CDB_CustomerId__c); //'76521'//customerIdCdb
			}else if(caseList[0].Account != null && caseList[0].Account.AccountNumber != null){
				gen.writeStringField('id_cdb', caseList[0].Account.AccountNumber);
			}
			gen.writeEndObject();
			gen.writeFieldName('files');
			gen.writeStartArray();
			gen.writeStartObject();
			gen.writeStringField('name',filename);
			gen.writeNumberField('size', filesize);
			gen.writeEndObject();
			gen.writeEndArray();
			if(caseList[0].Product !=null && caseList[0].Product.ProductCode != null){
				gen.writeFieldName('product');
				gen.writeStartObject();
					gen.writeStringField('id_cdb', caseList[0].Product.ProductCode); //'133-047489_00' //'833-022515_00'
				
				gen.writeEndObject();
			}
			if(Label.ExecuteProductionVersion == 'Yes'){
				if(caseList[0].CH_Product_Release__c != null && caseList[0].CH_Product_Release__r.CH_NSNLegacyCode__c != null){
					gen.writeFieldName('productversion');
					gen.writeStartObject();
					gen.writeStringField('id_cdb', caseList[0].CH_Product_Release__r.CH_NSNLegacyCode__c);		  //'833-022516_00'//if null do not create 
					gen.writeEndObject();
				}
			}
		  /*  gen.writeFieldName('classification');
			gen.writeStartObject();
			gen.writeStringField('id', classifications1); 
			gen.writeEndObject();*/
		   gen.writeStringField('nctclassification',classifications);			
		   gen.writeStringField('service_class','CARE'); 
		   gen.writeStringField('app','SF Service Cloud'); 
		   gen.writeStringField('purpose','Case Handling');
		   gen.writeStringField('description',description); 
		   gen.writeFieldName('ticket'); //not able to send 
		   gen.writeStartObject();
		   gen.writeStringField('app_name', Label.CAPS_AppName);
		   gen.writeStringField('ticket_id', caseList[0].CaseNumber);
		   gen.writeEndObject();
		   if(caseList[0].CH_SecurityGroup__c != null){
			gen.writeStringField('SFsecuritygroup', caseList[0].CH_SecurityGroup__c);//'test'// if null do not create 
		   }
		   gen.writeStringField('sf_case_status', 'Open');
		   /*if(caseList[0].Account != null && caseList[0].Account.AccountNumber != null){
				gen.writeStringField('customer_reference_id', caseList[0].Account.AccountNumber);
		   }*/
		   gen.writeBooleanField('customer_visible', customervisible);
		   gen.writeEndObject();
		   jsonString = gen.getAsString();
		   String response = callAPI(CAPS_ConstantHandler.SYSTEM_URL1,CAPS_ConstantHandler.POST_METHOD,jsonString,CAPS_ConstantHandler.CAPS_ENDUSER);
			parseAttachmentResponse(response);
			upload_id= getUploadIDForFile();
			wrapperObj.uploadId = upload_id;
		}
		if(partNumberString != '1'){
			readWrapperValue(wrapperFromJs);
		}
		uploadFile(upload_id, jsonst);
		partNumVsEtagMap = new Map<string,string>();
		if(partNumberString != '1'){
			partNumVsEtagMap = wrapperFromJs.partNumVsEtagMap;
		}
		partNumVsEtagMap.put(partNumberString,eTAG);
		wrapperObj.partNumVsEtagMap = partNumVsEtagMap;
		//Mark upload as complete
		
		//Mark file as ready
		if(isLastChunk){
			completeFile(upload_id);
			gen = JSON.createGenerator(true);
			gen.writeStartObject();
			gen.writeFieldName('files');
			gen.writeStartArray();
			gen.writeStartObject();
			gen.writeStringField('id',fileid);
			gen.writeStringField('status', 'ready');
			gen.writeStringField('name', filename);
			gen.writeNumberField('size', filesize);
			gen.writeEndObject();
			gen.writeEndArray(); 
			gen.writeEndObject();
			jsonString = gen.getAsString();
			String lastresponse=  callAPI(CAPS_ConstantHandler.SYSTEM_URL + attachmentid,CAPS_ConstantHandler.PUT_METHOD,jsonString, CAPS_ConstantHandler.CAPS_ENDUSER);
		}
		return wrapperObj;
	}
	/*****************************************************
	* Method Name : completeFile
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Complete file in S3
	* Parameter: string
	* Return: None
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public void completeFile(string uploadID){
		DateTime now = DateTime.now();
		string nowFormatted = now.formatGMT('EEE, d MMM YYYY HH:mm:ss z');
		string filenameUTF8 = EncodingUtil.urlEncode(s3keyname, 'UTF-8');
		string urlToSign = 'POST\n\napplication/xml; charset=UTF-8\n\n'+'x-amz-date:'+nowFormatted+'\n'+'/'+bucket+'/'+filenameUTF8+'?uploadId='+uploadID;
		string s3Token = signURLForS3(urlToSign);
		string s3auth = aws_key+':'+s3Token;
		//Create xml to update CAPS with complete status
		DOM.Document doc = new DOM.Document();
		dom.XmlNode completeMultipartUpload = doc.createRootElement('CompleteMultipartUpload', null, null);
		integer numberOfParts = partNumVsEtagMap.size();
		for(String itr: partNumVsEtagMap.keySet()){//check if sorting required if partnumber is not coming sequentially 1,2,3,4....
			dom.XmlNode part= completeMultipartUpload.addChildElement('Part', null, null);
			part.addChildElement('PartNumber', null, null).addTextNode(itr);
			part.addChildElement('ETag', null, null).addTextNode(partNumVsEtagMap.get(itr));
		}
		string xmlstring = doc.toXmlString();								
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setHeader('Authorization', 'AWS '+s3auth);
		req.setHeader('x-amz-date', nowFormatted);
		req.setHeader('Content-Type', 'application/xml; charset=UTF-8');
		req.setBody(xmlstring);
		
		req.setEndpoint(aws_url +'/'+bucket+'/'+filenameUTF8+'?uploadId='+uploadID);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		string responseXML = res.getBody();
	}
	/*****************************************************
	* Method Name : uploadFile
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Upload file in chunks
	* Parameter: String, Blob
	* Return: List String
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public String uploadFile(string uploadID, blob data){
		DateTime now = DateTime.now();
		string nowFormatted = now.formatGMT('EEE, d MMM YYYY HH:mm:ss z');
		string filenameUTF8 = EncodingUtil.urlEncode(s3keyname, 'UTF-8');
		string urlToSign = 'PUT\n\n\n\n'+'x-amz-date:'+nowFormatted+'\n'+'/'+bucket+'/'+filenameUTF8+'?partNumber='+partNumberString+'&uploadId='+uploadID;
		string s3Token = signURLForS3(urlToSign);
		string s3auth = aws_key+':'+s3Token;
		HttpRequest req = new HttpRequest();
		req.setMethod('PUT');
		req.setHeader('Authorization', 'AWS '+s3auth);
		req.setHeader('x-amz-date', nowFormatted);
		req.setHeader('Content-Length', String.valueOf(data.size()));	   
	   // req.setBody(EncodingUtil.base64Encode(data));
		req.setBodyAsBlob(data);
		req.setEndpoint(aws_url +'/'+bucket+'/'+filenameUTF8+'?partNumber='+partNumberString+'&uploadId='+uploadID);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		string responseXML = res.getBody();
		eTAG = res.getHeader('ETag');
		return uploadID;
	}
	/*****************************************************
	* Method Name : getUploadIDForFile
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Get uplaod Id 
	* Parameter: 
	* Return: String
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public String getUploadIDForFile(){
		DateTime now = DateTime.now();
		string nowFormatted = now.formatGMT('EEE, d MMM YYYY HH:mm:ss z');
		//amzdate = strftime("%a, %d %b %Y %H:%M:%S GMT", gmtime())
		string filenameUTF8 = EncodingUtil.urlEncode(s3keyname, 'UTF-8');
		string urlToSign = 'POST\n\n\n\n'+'x-amz-acl:'+acl+'\n'+'x-amz-date:'+nowFormatted+'\n'+'/'+bucket+'/'+filenameUTF8+'?uploads';
		string s3Token = signURLForS3(urlToSign);
		string s3auth = aws_key+':'+s3Token;
		HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setHeader('Authorization', 'AWS '+s3auth);
		req.setHeader('x-amz-acl', acl);
		req.setHeader('x-amz-date', nowFormatted);
		req.setEndpoint(aws_url +'/'+bucket+'/'+filenameUTF8+'?uploads');
		Http http = new Http();
		HTTPResponse res = http.send(req);
		string responseXML = res.getBody();
		Dom.Document doc = new Dom.Document();
		doc.load(responseXML);
		Dom.XMLNode root = doc.getRootElement();
		String uploadID= root.getChildElement('UploadId', 'http://s3.amazonaws.com/doc/2006-03-01/').getText();
		return uploadID;
	}
	
	/*public String CreateS3Token(){
		//Get S3 token
		string url = '/93f6cc8e/api/s3sign';
		string expiration2 = String.valueOf(Math.round((Datetime.now().getTime() / 1000) + 60)); 
		string attachmentIDUTF8 = EncodingUtil.urlEncode(s3keyname.split('/')[0], 'UTF-8');
		string filenameUTF8 = EncodingUtil.urlEncode(s3keyname.split('/')[1], 'UTF-8');
		string urlToSign = 'GET\n\n\n'+expiration2+'\n'+'/' + bucket + '/'+ attachmentIDUTF8 + '/' + filenameUTF8;
		string s3Token = SignURLForS3(urlToSign);
		string awsurl = aws_url +'/'+ bucket +'/'+ attachmentIDUTF8 +'/'+ filenameUTF8 + '?AWSAccessKeyId=' + aws_key + '&Expires=' + expiration2 + '&Signature='+s3Token ;
		return awsurl;
	}*/
	/*****************************************************
	* Method Name : signURLForS3
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Get picklist values
	* Parameter: string
	* Return: string
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public string signURLForS3(string urlToSign){
		string url = CAPS_ConstantHandler.S3_SIGNURL;//'/93f6cc8e/api/s3sign';
		string tosignUTF8 = EncodingUtil.urlEncode(urlToSign, 'UTF-8');
		string signerUTF8 = EncodingUtil.urlEncode(signer, 'UTF-8');
		string userUTF8 = EncodingUtil.urlEncode(user, 'UTF-8');
		string expirationUTF8 = EncodingUtil.urlEncode(expiration, 'UTF-8');
		string permissionUTF8 = EncodingUtil.urlEncode(permission, 'UTF-8');
		string signtokenUTF8 = EncodingUtil.urlEncode(signtoken, 'UTF-8');
		url = url + '?to_sign=' + tosignUTF8 + '&signer=' + signerUTF8 + '&user=' + userUTF8 + '&expiration=' + expirationUTF8 + '&permission=' + permissionUTF8 + '&signtoken=' + signtokenUTF8;
		HttpRequest req = new HttpRequest();
		req.setMethod('GET');
		req.setEndpoint(BASE_URL + url);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		string s3Token = res.getBody();
		return s3Token;
	}
	/*****************************************************
	* Method Name : parseAttachmentResponse
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Parse first response
	* Parameter: string
	* Return: None
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public void parseAttachmentResponse(string response){
		JSONParser parser = JSON.createParser(response);
		while (parser.nextToken() != null) {
			string key = parser.getCurrentName();
			if(key == 'id'){
				if (attachmentId == null){
					parser.nextToken();
					attachmentId = parser.getText();
					wrapperObj.attachmentId = attachmentId;
				}
			}
			key = parser.getCurrentName();
			if(key == 's3keyname'){
	s3keyname = parser.getText();
	wrapperObj.s3keyname = s3keyname;						   
			}
			if(key == 'id'){
	fileid = parser.getText();
	wrapperObj.fileid = fileid;
			}
			if(key == 'signer'){
				signer = parser.getText();
				wrapperObj.signer = signer;				 
			}
			if(key == 'user'){
				user = parser.getText();
				wrapperObj.user = user;				 
			}
			if(key == 'signtoken'){
				signtoken = parser.getText();
				wrapperObj.signtoken = signtoken;				   
			}
			if(key == 'expiration'){
				expiration = parser.getText(); 
				wrapperObj.expiration = expiration;				 
			}
			if(key == 'permission'){
				permission = parser.getText();
				wrapperObj.permission = permission;				 
			}
			if(key == 'acl'){
				acl = parser.getText();  
				wrapperObj.acl = acl;
			}
			if(key == 'aws_url'){
				aws_url = parser.getText();  
				wrapperObj.aws_url = aws_url;
			}
			if(key == 'bucket'){
				bucket = parser.getText(); 
				wrapperObj.bucket = bucket;				 
			}
			if(key == 'aws_key'){
				aws_key = parser.getText();
				wrapperObj.aws_key = aws_key;				   
			}
		}
	}
	/*****************************************************
	* Method Name : readWrapperValue
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Read Wrapper values
	* Parameter: CAPS_UploadResponseWrapper
	* Return: None
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public void readWrapperValue(CAPS_UploadResponseWrapper wrapperFromJs){
		wrapperObj.attachmentId = attachmentId = wrapperFromJs.attachmentId;
		wrapperObj.s3keyname = s3keyname = wrapperFromJs.s3keyname;
		wrapperObj.fileid = fileid = wrapperFromJs.fileid;
		wrapperObj.signer = signer = wrapperFromJs.signer;
		wrapperObj.user = user = wrapperFromJs.user;
		wrapperObj.signtoken = signtoken = wrapperFromJs.signtoken;
		wrapperObj.expiration = expiration = wrapperFromJs.expiration;
		wrapperObj.permission = permission = wrapperFromJs.permission;
		wrapperObj.acl = acl = wrapperFromJs.acl;
		wrapperObj.aws_url = aws_url = wrapperFromJs.aws_url;
		wrapperObj.bucket = bucket = wrapperFromJs.bucket;
		wrapperObj.aws_key = aws_key = wrapperFromJs.aws_key;
		wrapperObj.uploadId = upload_id = wrapperFromJs.uploadId;
	}
	/*****************************************************
	* Method Name : callAPI
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Call to CAPS
	* Parameter: string,string,string,string
	* Return: string
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public string callAPI(string url, string method, string jsonString, string userEmail){
		string signatureKeyId = DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
		boolean patch = false;		
		DateTime now = DateTime.now();
		string nowFormatted = now.formatGMT('EEE, d MMM YYYY HH:mm:ss z');
		final string signature = calculateSignature(url, method, userEmail, nowFormatted);
		HttpRequest req = new HttpRequest();
		req.setMethod(method);
		req.setEndpoint(BASE_URL + url);
		req.setHeader('Content-Type', 'application/json');
		req.setHeader('x-amz-date', nowFormatted);
		req.setHeader('X-End-User', userEmail);
		req.setHeader('Authorization', 'Signature keyId="' +signatureKeyId+'",' 
										+ 'algorithm="hmac-sha256", ' 
										+ 'headers="(request-target) x-amz-date x-end-user",'
										+ 'signature= "' + signature + '"');
		if (method == 'PUT' || method =='POST'){
			req.setBody(jsonString);
		}
		Http http = new Http();
		HTTPResponse res = http.send(req);
		return res.getBody();
	}
	/*****************************************************
	* Method Name : calculateSignature
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: get signature
	* Parameter: string, string, string, string
	* Return: String
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/ 
	public String calculateSignature(string url, string method, string userEmail, string nowFormatted){
		
		final string secret = DecodeEncodeUtility.decodeValues(CH_Settings__c.getValues('CAPSSecret').SettingValue__c);
		Blob secretBlob = Blob.valueOf(secret);
		string reqpath = '(request-target): ' + method.toLowerCase() + ' ' + url;
		string thisdate = 'x-amz-date: ' + nowFormatted;
		string capsenduser = 'x-end-user: ' + userEmail;
		string signstring = reqpath + '\n' + thisdate + '\n' + capsenduser;
		Blob signstringBlob = Blob.valueOf(signstring);
		Blob signatureBlob = Crypto.generateMac('HmacSHA256', signstringBlob, secretBlob);
		String signature = EncodingUtil.base64Encode(signatureBlob);
		return signature;
	}
}