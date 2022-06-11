/*************************************************************************************************
	 * Class Name : CAPS_Attachments_Download 
	 * Created Date: 27 June 2018
	 * Created By : TCS
	 * Descsription: Server Side Class for CAPS Attachment Download(Request and Response)
	 * Last Modified by: 
	 * Last Modified Date: 
	 * Description : CAPS_Attachments_Download
	*************************************************************************************************/
	public without sharing class CAPS_Attachments_Download {

		CAPS_DownloadResponseWrapper wrapperObj;
		public String decodedSignatureKey =  DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
		public String password = null;
		public String fileName = null;
		public String downLoadUrl = null;   
		private String aws_url = '',aws_key = '',bucket = '',signerurl = '',s3keyname = '',attachmentIDUTF8 = '',filenameUTF8 = '',expiration2 = '',completeFileName = '';
		List<CAPS_DownloadResponseWrapper> downloadWrapper = new List<CAPS_DownloadResponseWrapper>();
		public String S3ApiEndpoint = '';
		public string aws_signature_version = '';
		public string s3_region = '';
		public string s3resource = '';
		

	  /*****************************************************
		* Method Name : getAttachment
		* Created Date: 27 June 2018
		* Created By : TCS
		* Descsription: Fetching attachment from Caps System
		* Parameter: String, Map<String,List<String>>
		* Return: List<CAPS_DownloadResponseWrapper>
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/  
		public List<CAPS_DownloadResponseWrapper> getAttachment(List<String> attachmentIds, Map<String,List<String>> attachIdVsFileListMap){	 
			try{
	String baseUrl, storageUrl, suffixUrl, userName;
	String method = CAPS_ConstantHandler.GET_METHOD;
	String userEmail;
	if(CAPS_AttachmentController.isCommunity()){userName =  CAPS_ConstantHandler.NOKIA_USERNAME;
	}else{userName = [SELECT Alias FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].Alias;}
	baseUrl = CAPS_ConstantHandler.BASE_URL;
	storageUrl = CAPS_ConstantHandler.SYSTEM_URL;
	for(String attachId: attachIdVsFileListMap.keySet()){
		for(String fileNames: attachIdVsFileListMap.get(attachId)){
			wrapperObj = new CAPS_DownloadResponseWrapper();
			fileName = '';
			downLoadUrl = '';
			wrapperObj.fileName = fileNames;
			suffixUrl=storageUrl + attachId + CAPS_ConstantHandler.USER_STR + userName ;
			HTTPResponse resCAPSLogApi;
			resCAPSLogApi = callLogApi(baseUrl, suffixUrl, '');// call log api and get response//Raju.Upadhyayula.ext@nokia.com
			
			if(resCAPSLogApi.getStatusCode()==200){
				HTTPResponse resS3Api;
		 // HTTPResponse fileresponse;
				resS3Api=callS3Api(resCAPSLogApi, method, attachId, fileNames, userName); // call S3 and get response 
				if(resS3Api.getStatusCode()==200){// if success, get s3 token to build donwloadable url
		String s3Token=resS3Api.getBody();
		if(!String.isBlank(s3Token)){
			// replace / and +
			s3Token = s3Token.replace(CAPS_ConstantHandler.FRONT_SLASH, CAPS_ConstantHandler.PERCENT2F);
			s3Token = s3Token.replace(CAPS_ConstantHandler.PLUS_SYMBOL, CAPS_ConstantHandler.PERCENT2B);
			s3Token = s3Token.replaceAll('%7E','~');
		}
		//downloadable url
		if(aws_signature_version == '2'){
			String awsurl = aws_url + CAPS_ConstantHandler.FRONT_SLASH + bucket + CAPS_ConstantHandler.FRONT_SLASH + attachmentIDUTF8 + CAPS_ConstantHandler.FRONT_SLASH + 
			filenameUTF8 + CAPS_ConstantHandler.AWSACCESSKEYID + aws_key + CAPS_ConstantHandler.EXPIRES_STR + expiration2 + CAPS_ConstantHandler.SIGNATURE_STRING + s3Token;
			wrapperObj.downLoadUrl = awsurl;
		}
		else if(aws_signature_version == '4'){
			wrapperObj.downLoadUrl = aws_url+s3resource+s3Token;
		}
				}else{
		string endurl = S3ApiEndpoint;
		integer lenth = S3ApiEndpoint.length();
		if(lenth>150){
			endurl = '';
			for(String str: S3ApiEndpoint.split('&')){
				endurl = endurl + str +'&\n';
			}
		}
		if(resS3Api != null && resS3Api.getBody() != null && resS3Api.getBody() != ''){
			Map<String, Object> s3apiResponseMap = (Map<String, Object>)JSON.deserializeUntyped(resS3Api.getBody());
			Map<String, Object>  objMaps3Error =(Map<String, Object>)s3apiResponseMap.get('error');
			if(objMaps3Error != null){
				string errorMessage = (String)objMaps3Error.get('message');
				string errorUrl = (String)objMaps3Error.get('url');
				wrapperObj.capsError = CAPS_ConstantHandler.ERROR_MESSAGE+errorMessage+',\nurl = '+errorUrl+CAPS_ConstantHandler.ENDPOINT+endurl;
			}
		}else{
			wrapperObj.capsError = 'Error: Unknown error has occurred. '+',endpoint = '+endurl;
		}
				}
			}else if(resCAPSLogApi != null && resCAPSLogApi.getStatusCode()==502){
				wrapperObj.capsError = CAPS_ConstantHandler.ERROR_MESSAGE+resCAPSLogApi.getStatus()+'.'+CAPS_ConstantHandler.ENDPOINT+baseUrl+suffixUrl;
			}
			else{
				if(resCAPSLogApi != null && resCAPSLogApi.getBody() != null && resCAPSLogApi.getBody() != ''){
		Map<String, Object> apiResponseMap = (Map<String, Object>)JSON.deserializeUntyped(resCAPSLogApi.getBody());
		Map<String, Object>  objMapLogError =(Map<String, Object>)apiResponseMap.get('error');
		if(objMapLogError != null){
			string errorMessage = (String)objMapLogError.get('message');
			string errorUrl = (String)objMapLogError.get('url');
			wrapperObj.capsError = CAPS_ConstantHandler.ERROR_MESSAGE+errorMessage+',\nurl = '+errorUrl+CAPS_ConstantHandler.ENDPOINT+baseUrl+suffixUrl;
		}
				}else{
		wrapperObj.capsError = 'Error: Unknown error has occurred. '+',endpoint = '+baseUrl+suffixUrl;
				}
			}
		}
		downloadWrapper.add(wrapperObj);
	}
			}catch(Exception exp){ExceptionHandler.addException(exp, CAPS_ConstantHandler.cAPSAttachmentDownload, CAPS_ConstantHandler.getAttachment);
	downloadWrapper = new List<CAPS_DownloadResponseWrapper>();
	wrapperObj = new CAPS_DownloadResponseWrapper();
	wrapperObj.exceptionMessage = exp.getMessage() +  '\n'+ exp.getStackTraceString();
	downloadWrapper.add(wrapperObj);
	return downloadWrapper;
			}
	return downloadWrapper;
		}  
		/******************************************
		* Method Name : callLogApi
		* Created Date: 27 June 2018
		* Created By : TCS
		* Descsription: Fetching response from Caps System
		* Parameter: String, String, String
		* Return: HTTPResponse
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public HTTPResponse callLogApi(String baseUrl, String suffixUrl, String userEmail){
			CAPS_Attachment_Util objAtachmentUtil = new CAPS_Attachment_Util();			
			HttpRequest reqCAPSApi ;
			//call to get signature and log api call		
			reqCAPSApi = objAtachmentUtil.createRequest(baseURL, suffixUrl, CAPS_ConstantHandler.GET_METHOD, userEmail, decodedSignatureKey);	
			Http httpCAPSapi = new Http();
			HTTPResponse resCAPSApi = httpCAPSapi.send(reqCAPSApi);// send request log api 
			return resCAPSApi;
		}
		/******************************************
		* Method Name : callS3Api
		* Created Date: 27 June 2018
		* Created By : TCS
		* Descsription: Fetching response from S3
		* Parameter: HTTPResponse, String, String, String
		* Return: HTTPResponse
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public HTTPResponse callS3Api(HTTPResponse resCAPSApi, String method, String attachId, String fileNames, String userName){
			S3ApiEndpoint = '';
			completeFileName = fileNames;
			string s3KeyName4 = EncodingUtil.urlEncode(attachId, 'UTF-8')+'/'+EncodingUtil.urlEncode(fileNames, 'UTF-8');
			s3KeyName4 = s3KeyName4.replaceAll('\\+','%20');
			Map<String, Object> objMapApiResponse = (Map<String, Object>)JSON.deserializeUntyped(resCAPSApi.getBody());
			//Getting Encryption Key
			wrapperObj.password = (String)objMapApiResponse.get(CAPS_ConstantHandler.ENCRYPTION_KEY);
		
			/*Getting Evaporate values*/
			Map<String, Object>  objMapEvaporate=(Map<String, Object>)objMapApiResponse.get(CAPS_ConstantHandler.EVAPORATE);
			aws_url =(String)objMapEvaporate.get(CAPS_ConstantHandler.AWS_URL);
			aws_key=(String)objMapEvaporate.get(CAPS_ConstantHandler.AWS_KEY);
			//Getting Signer values
			signerurl=(String)objMapEvaporate.get(CAPS_ConstantHandler.SIGNER_URL);
			//Getting bucket value
			bucket=(String)objMapEvaporate.get(CAPS_ConstantHandler.BUCKET);
			/*sign Params Values*/
			Map<String,Object>  objMapSignParams=(Map<String, Object>)objMapEvaporate.get(CAPS_ConstantHandler.SIGN_PARAMS);
			Integer expyration=(Integer)objMapSignParams.get(CAPS_ConstantHandler.EXPIRATION);
			String permision=(String)objMapSignParams.get(CAPS_ConstantHandler.PERMISSION);
			String signr =(String)objMapSignParams.get(CAPS_ConstantHandler.SIGNER);
			String signTokn=(string)objMapSignParams.get(CAPS_ConstantHandler.SIGN_TOKEN);
			attachmentIDUTF8 = EncodingUtil.urlEncode(attachId, CAPS_ConstantHandler.UTF8FORMAT);
			filenameUTF8 = EncodingUtil.urlEncode(completeFileName, CAPS_ConstantHandler.UTF8FORMAT);// file name encoded required for S3
			filenameUTF8 = filenameUTF8.replaceAll('\\+','%20');
			String signuserFromGET=(string)objMapSignParams.get('user');
			aws_signature_version = (String)objMapEvaporate.get('aws_signature_version');
			s3_region = (String)objMapEvaporate.get('s3_region');
			if(aws_signature_version == '2'){
	String S3ApiUrlPart = signerurl + CAPS_ConstantHandler.EXPIRATIONEQUAL + expyration + CAPS_ConstantHandler.PERMISSIONURL + permision + CAPS_ConstantHandler.SIGNERURL + 
			signr + CAPS_ConstantHandler.SIGNTOKENURL + signTokn;//first part of the end point url
			
	String formattedDateString1 = Datetime.now().formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
	expiration2 = String.valueOf(Math.round((Datetime.now().getTime() / 1000) + CAPS_ConstantHandler.EXPIRATION_ADD_60)); 
	String  to_sign = CAPS_ConstantHandler.GETNEWLINES + expiration2+ CAPS_ConstantHandler.NEW_LINE + CAPS_ConstantHandler.FRONT_SLASH + bucket + 
			CAPS_ConstantHandler.FRONT_SLASH + attachmentIDUTF8 + CAPS_ConstantHandler.FRONT_SLASH + filenameUTF8;
	
	S3ApiEndpoint = S3ApiUrlPart + CAPS_ConstantHandler.TO_SIGN + EncodingUtil.urlEncode(to_sign, CAPS_ConstantHandler.UTF8FORMAT) + CAPS_ConstantHandler.USER_URL + userName;//'rajupadh';//end point to invoke S3
			}else if(aws_signature_version == '4'){
	string s3v4SignAPIUrl = CH_Settings__c.getValues('CAPSVS3SignAPIV4Url') != null ? CH_Settings__c.getValues('CAPSVS3SignAPIV4Url').SettingValue__c :'';
	DateTime now = DateTime.now();
	string dateStamp = now.formatGMT('yyyyMMdd');
	string timeStamp = now.formatGMT('HHmmss');
	string dateTimeStamp = dateStamp+'T'+timeStamp+'Z';
	string credential_scope = datestamp + '/' + s3_region + '/' + 's3' + '/' + 'aws4_request';
	string credential_scope2 = '/' + datestamp+ '/' + s3_region + '/' + 's3' + '/' + 'aws4_request';
	string credential_scope3 = '&X-Amz-Date='+dateTimeStamp+'&X-Amz-Expires=3600&X-Amz-SignedHeaders=host';
	string canonical_uri = '/'+bucket+'/'+attachId+'/'+filenameUTF8;
	string canonical_querystring = 'X-Amz-Algorithm='+CAPS_ConstantHandler.AWS4_HMAC_SHA256+'&X-Amz-Credential='+aws_key+credential_scope2+credential_scope3;
	string host = aws_url.split('/')[2];
	string canonical_headers = 'host:'+host+'\n'+'\n'+'host'+'\n'+ 'UNSIGNED-PAYLOAD';
	string canonical_request = 'GET' + '\n' + canonical_uri + '\n' + canonical_querystring + '\n' + canonical_headers;
	string canonical_request_urlencoded=EncodingUtil.urlEncode(canonical_request, 'UTF-8');
	string canonical_request_urlencoded1=canonical_request_urlencoded.replaceAll('%3A',':');
	string to_sign = CAPS_ConstantHandler.AWS4_HMAC_SHA256 + '\n' +  dateTimeStamp + '\n' +  credential_scope + '\n' +  EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(canonical_request_urlencoded)));
	string to_sign_url_encoded = EncodingUtil.urlEncode(to_sign, 'UTF-8');
	to_sign_url_encoded = to_sign_url_encoded.replaceAll('%26','&');
	to_sign_url_encoded = to_sign_url_encoded.replaceAll('%3D','=');
	string service='?canonical_request='+canonical_request_urlencoded1+'&datetime='+dateTimeStamp+'&expiration='+expyration+'&permission='+permision+'&signer='+signr+'&signtoken='+signTokn+'&to_sign='+to_sign_url_encoded+'&user='+signuserFromGET;
	string credential_scope2encode = EncodingUtil.urlEncode(credential_scope2, 'UTF-8');
	credential_scope2encode = credential_scope2encode.replaceAll('%2F','/');
	s3resource = '/'+bucket+'/'+s3KeyName4+'?X-Amz-Algorithm='+CAPS_ConstantHandler.AWS4_HMAC_SHA256+'&X-Amz-Credential='+aws_key+credential_scope2encode+'&X-Amz-Date='+dateTimeStamp+'&X-Amz-Expires=3600&X-Amz-SignedHeaders=host'+'&X-Amz-Signature=';
	S3ApiEndpoint = s3v4SignAPIUrl+service;
			}
			HttpRequest reqS3Api = new HttpRequest();
			reqS3Api.setMethod(method);//Get method 
			reqS3Api.setEndpoint(S3ApiEndpoint);//set S3 end point
			reqS3Api.setTimeout(120000);
			Http httpS3Api = new Http();
			HTTPResponse resS3Api = httpS3Api.send(reqS3Api);//send request to S3
			return resS3Api;
		}
		/******************************************
		* Class Name : CAPS_DownloadResponseWrapper
		* Created Date: 18 July 2018
		* Created By : TCS
		* Descsription: Wrapper class to send file information to lightning component
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public class CAPS_DownloadResponseWrapper{
			@AuraEnabled public  String password{get;set;}//password open file 
			@AuraEnabled public  String fileName{get;set;}
			@AuraEnabled public  String downLoadUrl{get;set;}//downloadable url
			@AuraEnabled public  String capsError{get;set;}
			@AuraEnabled public  String exceptionMessage{get;set;}
		}
	}