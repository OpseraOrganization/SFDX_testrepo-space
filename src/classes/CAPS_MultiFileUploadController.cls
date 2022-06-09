/*************************************************************************************************
	 * Class Name : CAPS_MultiFileUploadController
	 * Created Date: 18 July 2018
	 * Created By : TCS
	 * Description: Upload attachment server side controller
	 * Last Modified by: 
	 * Last Modified Date: 
	 * Description : 
	*************************************************************************************************/
	Public without sharing class CAPS_MultiFileUploadController {
		public static List < String > allOpts1 = new List < String > ();
		public final static string BASE_URL = CAPS_ConstantHandler.BASE_URL;
		public static string signer;
		public static string user;
		public static string expiration;
		public static string permission;
		public static string signtoken;
		public static string bucket;
		public static string s3keyname;
		public static string acl;
		public static string aws_url;
		public static string aws_key;
		public static string s3_region;
		public static string aws_signature_version;
		public static string attachmentId;
		public static string eTAG;
		public static string fileId;
		public static string fileNameInUTF8;
		public static boolean scrambled;

		/*****************************************************
		* Method Name : isCommunity
		* Created Date: 27 June 2018
		* Created By : Jeroen de Vries
		* Descsription: Check if the component is running in SF or in the community
		* Parameter: NA
		* Return: True if running in the communit. False running in SF
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/	
		@AuraEnabled
		public static boolean isCommunity(){
			Id siteId = Site.getSiteId(); 
			if (siteId != null) {
	return true;
			}
			return false;
		}
		
		//Get all the workgroup members 
		@AuraEnabled
		public static boolean getCaseTeamMembers(String caseId){
			String userId = UserInfo.getUserId();
			Profile p = [Select Name from Profile where Id =: UserInfo.getProfileid()];
			String pprofileName = p.name;
			List<CaseTeamMember> oCaseTeamMembers = [SELECT Id, Member.Name, Member.Id, TeamRole.Name, CreatedDate FROM CaseTeamMember WHERE ParentId =: caseId];
			List<CaseTeamMember> currentUserInCaseTeamMember = new List<CaseTeamMember>();
			Id siteId = Site.getSiteId();
			
			if(pprofileName == 'CH_Agent'){
	return true;
			}			
			if(!oCaseTeamMembers.isEmpty()){
	for(CaseTeamMember oCaseTeamMember : oCaseTeamMembers){
		if(oCaseTeamMember.Member.Id == userId){
			currentUserInCaseTeamMember.add(oCaseTeamMember);
		}
	}
			} else if(siteId != null){
	return true;
			}
			if(!currentUserInCaseTeamMember.isEmpty() && siteId != null){
	return true;
			} else if(!currentUserInCaseTeamMember.isEmpty() && siteId == null){
	return true;
			} else if(currentUserInCaseTeamMember.isEmpty() && siteId != null){
	return true;
			} else {
	List<Case> oCaseOwner = [SELECT Id, OwnerId FROM Case WHERE Id =: caseId AND OwnerId =: userId];
	if(!oCaseOwner.isEmpty() && siteId != null){
		return true;	 
	} else if (!oCaseOwner.isEmpty() && siteId == null){
		return true;
	} else if (oCaseOwner.isEmpty() && siteId != null){
		return true;
	} else { 
		return false;
	}
			}
		}
		
		/******************************************
		* Method Name : getselectOptions
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: Get picklist values
		* Parameter: sObject,string
		* Return: List < String >
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/ 
		@AuraEnabled
		public static List < String > getselectOptions(sObject objObject, string fld) {
			List <String> allOpts = new list <String>();
			// Get the object type of the SObject.
			Schema.sObjectType objType = objObject.getSObjectType();
			// Describe the SObject using its object type.
			Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
			// Get a map of fields for the SObject
			map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
			// Get the list of picklist values for this field.
			list<Schema.PicklistEntry> values =
	fieldMap.get(fld).getDescribe().getPickListValues();
			// Add these values to the selectoption list.
			for (Schema.PicklistEntry a: values) {
	allOpts.add(a.getValue());
			}
			allOpts1 = allOpts; 
			return allOpts;
		}
		/******************************************
		* Method Name : cAPSVclassification
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: get nct classification id
		* Parameter: string
		* Return: string
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/ 
		public static string cAPSVclassification(string classification){
			String nctclassificationId = null;
			if(!String.isBlank(classification)){
	if(CAPS_ConstantHandler.ENDUSER_DATA.equalsIgnoreCase(classification)){//End USER Sensitive Info
		nctclassificationId = CAPS_ConstantHandler.ENDUSER_DATA_ID; 
	}else if(CAPS_ConstantHandler.OTHERSENSITIVE_DATA.equalsIgnoreCase(classification)){//Other Sensitive Info
		nctclassificationId = CAPS_ConstantHandler.OTHERSENSITIVE_DATA_ID; 
	}else if(CAPS_ConstantHandler.OTHER_DATA.equalsIgnoreCase(classification)){//Non Sensitive Info.
		nctclassificationId = CAPS_ConstantHandler.OTHER_DATA_ID; 
	}
			}
			return nctclassificationId;
		}
		/******************************************
		* Method Name : initiateUpload
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: 1. create json for attachment creation. 2. Get signature for CAPS.
		* Parameter: ID,Boolean,String,String,String,Decimal
		* Return: CAPS_MultiFileUploadWrapper
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		@AuraEnabled
		public static CAPS_MultiFileUploadWrapper initiateUpload
			(Id caseRecordId, 
			Boolean customervisible, 
			String fileName,
			String description, 
			String classifications, 
			Decimal fileSize
			) 
		{	
			Set<String> caseStatusSet = new Set<String>{'Completed','Closed','Cancelled'};
			Map<String,String> CAPSPriorityMap = new Map<String,String>();//Added for NOKIASC-31214
			String Priority; //Added for NOKIASC-31214
			CAPS_MultiFileUploadWrapper wrap;
			JSONGenerator gen;
			String jsonString;
			String nowFormatted;
			if(caseRecordId != null && !String.isBlank(fileName) && !String.isBlank(description) && fileSize != null){
	wrap = new CAPS_MultiFileUploadWrapper();
	//Added Severity__c and CH_Outage__c in the query for NOKIASC-31214
	List<Case> caseList = [SELECT Id, CaseNumber, Product.ProductCode, Status, Severity__c,CH_Outage__c,CH_SecurityGroup__c, 
	CH_Product_Release__r.CH_NSNLegacyCode__c, CH_LawfullIntercept_CALEA__c,Entitlement.ServiceContract.CH_CDB_CustomerId__c, 
	Account.AccountNumber 
	FROM Case 
	WHERE Id =: caseRecordId
	LIMIT 1];
	wrap.caseHasBeenClosed = '';
	if(caseStatusSet.contains(caseList[0].Status)){
	  wrap.caseHasBeenClosed = 'This Case has been '+caseList[0].Status +'. So, File cannot be uploaded.';
		return wrap;
	}
	CAPSPriorityMap = getAttachmentPriority();//Added for NOKIASC-31214		   
	String priorityString = (caseList[0].Severity__c+caseList[0].CH_Outage__c+caseList[0].Status).toLowerCase();//Added for NOKIASC-31214
	Priority = (!CAPSPriorityMap.isEmpty() && CAPSPriorityMap.containsKey(priorityString))?CAPSPriorityMap.get(priorityString):System.Label.CAPS_Default_Priority;//Added for NOKIASC-31214
	Boolean caleaFlag = caseList[0].CH_LawfullIntercept_CALEA__c;// Eashwar 36529
	gen = JSON.createGenerator(true);
	gen.writeStartObject();
	gen.writeFieldName(CAPS_ConstantHandler.CUSTOMER);
	gen.writeStartObject();
	if(caseList[0].Entitlement != null && caseList[0].Entitlement.ServiceContract != null && caseList[0].Entitlement.ServiceContract.CH_CDB_CustomerId__c != null){
		gen.writeStringField(CAPS_ConstantHandler.ID_CDB, caseList[0].Entitlement.ServiceContract.CH_CDB_CustomerId__c);
	}else if(caseList[0].Account != null && caseList[0].Account.AccountNumber != null){
		gen.writeStringField(CAPS_ConstantHandler.ID_CDB, caseList[0].Account.AccountNumber);
	}
	gen.writeEndObject();
	gen.writeFieldName(CAPS_ConstantHandler.FILES);
	gen.writeStartArray();
	gen.writeStartObject();
	gen.writeStringField(CAPS_ConstantHandler.NAMES,fileName);
	gen.writeNumberField(CAPS_ConstantHandler.SIZESTRING, filesize);
	gen.writeEndObject();
	gen.writeEndArray();
	if(caseList[0].Product !=null && caseList[0].Product.ProductCode != null){
		gen.writeFieldName(CAPS_ConstantHandler.PRODUCT);
		gen.writeStartObject();
			gen.writeStringField(CAPS_ConstantHandler.ID_CDB, caseList[0].Product.ProductCode);
		gen.writeEndObject();
	}
	if(Label.ExecuteProductionVersion == CAPS_ConstantHandler.YESSTRING && caseList[0].CH_Product_Release__c != null && caseList[0].CH_Product_Release__r.CH_NSNLegacyCode__c != null){
			gen.writeFieldName(CAPS_ConstantHandler.PRODUCTVERSION);
			gen.writeStartObject();
			gen.writeStringField(CAPS_ConstantHandler.ID_CDB, caseList[0].CH_Product_Release__r.CH_NSNLegacyCode__c); 
			gen.writeEndObject();
		}
	if(!String.isBlank(classifications)){
		gen.writeStringField(CAPS_ConstantHandler.NCTCLASSIFICATION,cAPSVclassification(classifications));
	}	
	gen.writeStringField(CAPS_ConstantHandler.SERVICECLASS,CAPS_ConstantHandler.CARE_SREVICECLASS); 
	gen.writeStringField(CAPS_ConstantHandler.APP_STR,CAPS_ConstantHandler.SFSERVICECLOUD); 
	gen.writeStringField(CAPS_ConstantHandler.PURPOSE,CAPS_ConstantHandler.CASE_HANDLING);
	gen.writeStringField(CAPS_ConstantHandler.DESCRIPTIONJSON,description);
	if(Label.CAPS_AppName != null){
		gen.writeFieldName(CAPS_ConstantHandler.TICKET);
		gen.writeStartObject();
		gen.writeStringField(CAPS_ConstantHandler.APP_NAME, Label.CAPS_AppName);
		gen.writeStringField(CAPS_ConstantHandler.TICKET_ID, caseList[0].CaseNumber);
		gen.writeEndObject();
	}
	if(caseList[0].CH_SecurityGroup__c != null){
		gen.writeStringField(CAPS_ConstantHandler.SF_SECURITY_GROUPS, caseList[0].CH_SecurityGroup__c);
	}
	gen.writeStringField(CAPS_ConstantHandler.SF_CASE_STATUS, CAPS_ConstantHandler.OPEN_STATUS);

	gen.writeBooleanField(CAPS_ConstantHandler.CUSTOMERVISIBLEJSON, customervisible);
	gen.writeStringField(CAPS_ConstantHandler.PRIORITY, Priority);  //Added for NOKIASC-31214 
	gen.writeBooleanField(CAPS_ConstantHandler.LAWFULINTERCEPT_CALEA, caleaFlag); 
	gen.writeEndObject();
	jsonString = gen.getAsString();
	wrap.jsonString = jsonString;
	DateTime now = DateTime.now();
	nowFormatted = now.formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
	wrap.signature = calculateSignature(CAPS_ConstantHandler.SYSTEM_URL1,CAPS_ConstantHandler.POST_METHOD,CAPS_ConstantHandler.CAPS_ENDUSER,nowFormatted);
	wrap.nowFormatted = nowFormatted;
	String signatureKey = DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
	wrap.signatureKey = signatureKey;
	wrap.baseURL = CAPS_ConstantHandler.BASE_URL;
	wrap.logApiURL = CAPS_ConstantHandler.SYSTEM_URL1;
	wrap.s3SignApiURL = CAPS_ConstantHandler.S3_SIGNURL;
	wrap.s3SignApiV4URL = CH_Settings__c.getValues('CAPSVS3SignAPIV4Url') != null ? CH_Settings__c.getValues('CAPSVS3SignAPIV4Url').SettingValue__c :'';
			}
			return wrap;
		}
		/******************************************
		* Method Name : parseAttachmentResponse
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: 1. parse json and send to lightning. 2. Get signature for S3 sign.
		* Parameter: String
		* Return: CAPS_MultiFileUploadWrapper
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		@AuraEnabled
		public static CAPS_MultiFileUploadWrapper parseAttachmentResponse(string parseResponse){
			CAPS_MultiFileUploadWrapper wrapperObj = new CAPS_MultiFileUploadWrapper();
			JSONParser parser = JSON.createParser(parseResponse);
			while (parser.nextToken() != null) {
	string key = parser.getCurrentName();
	if(key == CAPS_ConstantHandler.KEY_ID && attachmentId == null){

			parser.nextToken();
			attachmentId = parser.getText();
			wrapperObj.attachmentId = attachmentId;
	}
	key = parser.getCurrentName();
	if(key == CAPS_ConstantHandler.S3KEYNAME){
		s3keyname = parser.getText();
		wrapperObj.s3keyname = s3keyname;		 
	}
	if(key == CAPS_ConstantHandler.KEY_ID){
		fileid = parser.getText();
		wrapperObj.fileid = fileid;
	}
	if(key == CAPS_ConstantHandler.SIGNER){
		signer = parser.getText();
		wrapperObj.signer = signer;	 
	}
	if(key == CAPS_ConstantHandler.KEY_USER){
		user = parser.getText();
		wrapperObj.user = user;	 
	}
	if(key == CAPS_ConstantHandler.SIGN_TOKEN){
		signtoken = parser.getText();
		wrapperObj.signtoken = signtoken;	
	}
	if(key == CAPS_ConstantHandler.EXPIRATION){
		expiration = parser.getText(); 
		wrapperObj.expiration = expiration;	 
	}
	if(key == CAPS_ConstantHandler.PERMISSION){
		permission = parser.getText();
		wrapperObj.permission = permission;	 
	}
	if(key == CAPS_ConstantHandler.ACL){
		acl = parser.getText();  
		wrapperObj.acl = acl;
	}
	if(key == CAPS_ConstantHandler.AWS_URL){
		aws_url = parser.getText();  
		wrapperObj.aws_url = aws_url;
	}
	if(key == CAPS_ConstantHandler.BUCKET){
		bucket = parser.getText(); 
		wrapperObj.bucket = bucket;	 
	}
	if(key == CAPS_ConstantHandler.AWS_KEY){
		aws_key = parser.getText();
		wrapperObj.aws_key = aws_key;	
	}
	if(key == 's3_region'){
		s3_region = parser.getText();
		wrapperObj.s3_region = s3_region;  
	}
	if(key == 'aws_signature_version'){
		aws_signature_version = parser.getText();
		wrapperObj.aws_signature_version = aws_signature_version;  
	}
			}
			DateTime now = DateTime.now();
			string nowFormatted = now.formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
			wrapperObj.signature1stS3Sign = calculateSignature(CAPS_ConstantHandler.S3_SIGNURL,CAPS_ConstantHandler.GET_METHOD,CAPS_ConstantHandler.CAPS_ENDUSER,nowFormatted);
			wrapperObj.amzdate = nowFormatted; 
			return wrapperObj;
		}
		/******************************************
		* Method Name : signURLForS3
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: Build Sign to S3
		* Parameter: string
		* Return: string
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public static string signURLForS3(string urlToSign){
			string s3Token;
			string url = CAPS_ConstantHandler.S3_SIGNURL;
			string tosignUTF8 = EncodingUtil.urlEncode(urlToSign, CAPS_ConstantHandler.UTF8FORMAT);
			string signerUTF8 = EncodingUtil.urlEncode(signer, CAPS_ConstantHandler.UTF8FORMAT);
			string userUTF8 = EncodingUtil.urlEncode(user, CAPS_ConstantHandler.UTF8FORMAT);
			string expirationUTF8 = EncodingUtil.urlEncode(expiration, CAPS_ConstantHandler.UTF8FORMAT);
			string permissionUTF8 = EncodingUtil.urlEncode(permission, CAPS_ConstantHandler.UTF8FORMAT);
			string signtokenUTF8 = EncodingUtil.urlEncode(signtoken, CAPS_ConstantHandler.UTF8FORMAT);
			url = url + CAPS_ConstantHandler.TOSIGN + tosignUTF8 + CAPS_ConstantHandler.SIGNERURL + signerUTF8 + CAPS_ConstantHandler.USER_URL + userUTF8 + 
	CAPS_ConstantHandler.AMPERSANDEXPIRATION + expirationUTF8 + CAPS_ConstantHandler.PERMISSIONURL + permissionUTF8 + CAPS_ConstantHandler.SIGNTOKENURL + signtokenUTF8;
			HttpRequest req = new HttpRequest();
			req.setMethod(CAPS_ConstantHandler.GET_METHOD);
			req.setEndpoint(BASE_URL + url);
			Http http = new Http();
			HTTPResponse res = http.send(req);
			if(res != null && res.getStatusCode() == 200){
	s3Token = res.getBody();
	return s3Token;
			}else{return null;}
		}
		/******************************************
		* Method Name : uploadComplete
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: 1. Complete upload in S3. 2. Change status in CAPS. 3. Create attachment recordin SAlesforce.
		* Parameter: String,String,String,String,Integer,String,String,String,String
		* Return: NA
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		@AuraEnabled
		public static string uploadComplete
			( 
			String partVsetagjson, 
			string s3uploadid, 
			string wrapperFromJs, 
			string fileName, 
			Decimal fileSize, 
			string caseRecordId, 
			Boolean customervisible, 
			string description, 
			string classfication,
			string s3KeyNameInUTF8,
			Boolean isFromEmail
			)
		{
			//comment 15209
			/*Set<String> originSystemSet = new Set<String>{'tcom-dtag','orange-irma','vodafone','Schweizer-Armee','megafon','telefonica','pnms'};
			Boolean sendToNAIPOrNot = false;
			String sendAttachmentToNAIP = CH_Settings__c.getValues('SendAttachmentToNAIP') != null ? CH_Settings__c.getValues('SendAttachmentToNAIP').SettingValue__c :'';
			if('Yes'.equalsIgnoreCase(sendAttachmentToNAIP)){
	sendToNAIPOrNot = true;
			}*/
			//comment 15209 
			string statuscheck = null;
			fileNameInUTF8 = s3KeyNameInUTF8;	  
			JSONParser parser = JSON.createParser(partVsetagjson);
			Map<String,String> partNumberVsETagMap = new Map<String,String>();
			while (parser.nextToken() != null) {
	string part;
	string etag;
	if(parser.getCurrentToken() == JSONToken.START_ARRAY ){
		while(parser.nextToken() != JSONToken.END_ARRAY){
			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == CAPS_ConstantHandler.PARTNUMBER_P_INSMALL)){
	parser.nextToken();
	part = parser.getText();
	parser.nextToken();
	if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == CAPS_ConstantHandler.ETAGVARIABLE)){
		parser.nextToken();
		etag = parser.getText();
		partNumberVsETagMap.put(part,etag);
	}
			}
		}
	}
			}
			gerDeserializedValue(wrapperFromJs);
			completeFile(s3uploadid,partNumberVsETagMap);
			String jsonString  = getJsonToChangeStatus(fileid, fileSize, fileName);
			HTTPResponse lastresponse=  callAPI(CAPS_ConstantHandler.SYSTEM_URL + attachmentid,CAPS_ConstantHandler.PUT_METHOD,jsonString, CAPS_ConstantHandler.CAPS_ENDUSER);
			if(lastresponse != null && lastresponse.getStatusCode() == 200){
	Map<String, Object> objMapApiResponse = (Map<String, Object>)JSON.deserializeUntyped(lastresponse.getBody());
	scrambled = (Boolean)objMapApiResponse.get('scrambled');
	List<CH_Attachment__c> listattach =new List<CH_Attachment__c>();
	CH_Attachment__c chAttachmentRecord = new CH_Attachment__c();
	chAttachmentRecord = getCHattachmentdata(caseRecordId,customervisible,fileName,description,fileSize,classfication,attachmentId,false,isFromEmail);
	listattach.add(chAttachmentRecord);
	if(scrambled)
	{
		chAttachmentRecord = new CH_Attachment__c();
		chAttachmentRecord = getCHattachmentdata(caseRecordId,customervisible,fileName,description,fileSize,classfication,attachmentId,true,isFromEmail);
		listattach.add(chAttachmentRecord);
	}
	Database.insert(listattach,true);//set it true for error handling
	//comment 15209
	/*if(!isFromEmail && !isCommunity() && sendToNAIPOrNot && customervisible)
	{
		List<Case> csList = new List<Case>([SELECT Id, CaseNumber, Origin, CH_CaseOriginSystem__c, Reference_Number__c
			FROM Case 
			WHERE Id =: caseRecordId 
			LIMIT 1]);
		if((!csList.isEmpty() && !String.isBlank(csList[0].Origin) && csList[0].Origin =='S2S' && 
	!String.isBlank(csList[0].CH_CaseOriginSystem__c)) && 
	((csList[0].CH_CaseOriginSystem__c == 'tmobile-tim' && fileSize <= 5120000) 
	|| originSystemSet.contains(csList[0].CH_CaseOriginSystem__c )))
		{
			CAP_SendCAPSAttachmentToNAIP.sendAttachmentId(csList[0],fileName,attachmentId,description,fileSize);
		}
	}*/
	//comment 15209
	return statuscheck= 'success';
			}
			else{return statuscheck;}
		}
		/******************************************
		* Method Name : getJsonToChangeStatus
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: Create json to change status to ready
		* Parameter: String,Integer,String
		* Return: String
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public static String getJsonToChangeStatus(String fileid, Decimal fileSize, String fileName){
			String jsonString;
			JSONGenerator gen;
			gen = JSON.createGenerator(true);
			gen.writeStartObject();
			gen.writeFieldName(CAPS_ConstantHandler.FILES);
			gen.writeStartArray();
			gen.writeStartObject();
			gen.writeStringField(CAPS_ConstantHandler.KEY_ID,fileid);
			gen.writeStringField(CAPS_ConstantHandler.STATUS, CAPS_ConstantHandler.READY);
			gen.writeStringField(CAPS_ConstantHandler.NAMES, fileName);
			gen.writeNumberField(CAPS_ConstantHandler.SIZESTRING, fileSize);
			gen.writeEndObject();
			gen.writeEndArray(); 
			gen.writeEndObject();
			jsonString = gen.getAsString();
			return jsonString;
		}
		/******************************************
		* Method Name : gerDeserializedValue
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: 1. create json for attachment creation. 2. Get signature for CAPS.
		* Parameter: String
		* Return: NA
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public static void gerDeserializedValue(String wrapperFromJs){
			CAPS_MultiFileUploadWrapper wrapperDeserialized = (CAPS_MultiFileUploadWrapper)JSON.deserialize(wrapperFromJs, CAPS_MultiFileUploadWrapper.class);
			attachmentId = wrapperDeserialized.attachmentId;
			s3keyname = wrapperDeserialized.s3keyname;
			fileid = wrapperDeserialized.fileid;
			signer = wrapperDeserialized.signer;
			user = wrapperDeserialized.user;
			signtoken = wrapperDeserialized.signtoken;
			expiration = wrapperDeserialized.expiration;
			permission = wrapperDeserialized.permission;
			acl = wrapperDeserialized.acl;
			aws_url = wrapperDeserialized.aws_url;
			bucket = wrapperDeserialized.bucket;
			aws_key = wrapperDeserialized.aws_key;
			s3_region = wrapperDeserialized.s3_region;
			aws_signature_version = wrapperDeserialized.aws_signature_version;
		}
		/******************************************
		* Method Name : completeFile
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: POST Call to S3 to complete file in S3
		* Parameter: string,Map<string,string>
		* Return: NA
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public static string completeFile(string s3uploadid,Map<string,string> partNumberVsETagMap){
			string s3v4SignAPIUrl = CH_Settings__c.getValues('CAPSVS3SignAPIV4Url') != null ? CH_Settings__c.getValues('CAPSVS3SignAPIV4Url').SettingValue__c :'';
			string statuscheck = null;
			string responseXML;
			DateTime now = DateTime.now();
			string nowFormatted = now.formatGMT(CAPS_ConstantHandler.DATE_FORMAT);

			//Create xml to update CAPS with complete status
			DOM.Document doc = new DOM.Document();
			dom.XmlNode completeMultipartUpload = doc.createRootElement(CAPS_ConstantHandler.COMPLETEDMULTIPARTUPLOAD, null, null);
			
			for(String itr: partNumberVsETagMap.keySet()){//check if sorting required if partnumber is not coming sequentially 1,2,3,4....
	dom.XmlNode part= completeMultipartUpload.addChildElement(CAPS_ConstantHandler.PART_STR, null, null);
	part.addChildElement(CAPS_ConstantHandler.PARTNUMBER, null, null).addTextNode(string.valueOf(itr));
	part.addChildElement(CAPS_ConstantHandler.ETAG, null, null).addTextNode(partNumberVsETagMap.get(itr));
			}
			string xmlstring = doc.toXmlString();
			string authHead5;
			string payload_hash;
			string dateTimeStamp;
			if(aws_signature_version == '2'){
	string urlToSign = 'POST\n\napplication/xml; charset=UTF-8\n\n'+'x-amz-date:'+nowFormatted+CAPS_ConstantHandler.NEW_LINE+CAPS_ConstantHandler.FRONT_SLASH+bucket+CAPS_ConstantHandler.FRONT_SLASH+fileNameInUTF8+ CAPS_ConstantHandler.UPLOADID +s3uploadid;
	string s3Token = signURLForS3(urlToSign);
	authHead5 = 'AWS '+aws_key+':'+s3Token;
			}else if(aws_signature_version == '4'){
	string algorithm = 'AWS4-HMAC-SHA256';
	string region = s3_region;
	string service = 's3';
	string dateStamp = now.formatGMT('yyyyMMdd');
	string timeStamp = now.formatGMT('HHmmss');
	dateTimeStamp = dateStamp+'T'+timeStamp+'Z';
	string credential_scope = datestamp + '/' + region + '/' + service + '/' + 'aws4_request';
	string method2 = 'POST';
	string s3keyname4 = fileNameInUTF8;
	string canonical_uri = '/'+aws_url.split('/')[3]+'/'+aws_url.split('/')[4]+'/'+bucket+'/'+s3keyname4;
	string canonical_part = 'uploadId='+s3uploadid;
	
	string host = aws_url.split('/')[2];
	string canonical_headers = 'host:' + host + '\n' + 'x-amz-date:' + dateTimeStamp;
	string sign_headers = 'content-type;host;x-amz-date';
	payload_hash = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(xmlstring)));
	string canonical_request = method2 + '\n' + canonical_uri + '\n' + canonical_part + '\n'+'content-type:application/xml; charset=UTF-8'+'\n' + canonical_headers + '\n' + '\n' + sign_headers + '\n' + payload_hash;
	string to_sign = algorithm + '\n' +  dateTimeStamp + '\n' +  credential_scope + '\n' +  EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(canonical_request)));//hashlib.sha256(canonical_request.encode('utf-8')).hexdigest()
	string url = s3v4SignAPIUrl+'?to_sign='+encode(to_sign)+'&datetime='+encode(dateTimeStamp)+'&canonical_request='+encode(canonical_request)+'&signer='+encode(signer)+'&user='+encode(user)+'&expiration='+encode(expiration)+'&permission='+encode(permission)+'&signtoken='+ encode(signtoken);
	HttpRequest req1 = new HttpRequest();
	req1.setMethod('GET');
	req1.setEndpoint(url);
	Http http = new Http();
	HTTPResponse res1 = http.send(req1);
	string s3Token;
	if(res1 != null && res1.getStatusCode() == 200){
		s3Token = res1.getBody();
	}
	authHead5 = 'AWS4-HMAC-SHA256 '+'Credential='+aws_key+'/'+credential_scope+', SignedHeaders='+sign_headers+', Signature='+s3Token;
			}

			HttpRequest req = new HttpRequest();
			req.setMethod(CAPS_ConstantHandler.POST_METHOD);
			if(aws_signature_version == '2'){
	req.setHeader(CAPS_ConstantHandler.X_AMZ_DATE, nowFormatted);
	
			}else if(aws_signature_version == '4'){
	req.setHeader('x-amz-content-sha256', payload_hash);
	req.setHeader('x-amz-date', dateTimeStamp);
			}
			req.setHeader(CAPS_ConstantHandler.CONTENT_TYPE, CAPS_ConstantHandler.APPLICATIONXMLCHARUTF);
			req.setHeader(CAPS_ConstantHandler.AUTHORIZATION_STR, authHead5);
			
			req.setBody(xmlstring);
			req.setEndpoint(aws_url +CAPS_ConstantHandler.FRONT_SLASH+bucket+CAPS_ConstantHandler.FRONT_SLASH+fileNameInUTF8 + CAPS_ConstantHandler.UPLOADID + s3uploadid);
			Http http = new Http();
			HTTPResponse res = http.send(req);
			if(res != null && res.getStatusCode() == 200){
	responseXML = res.getBody();
	return responseXML;
			}else{return statuscheck;}
		}
		static string encode(string tring){
			string data = string.isBlank(tring) ? '' : EncodingUtil.urlEncode(tring, 'UTF-8');
			return data.replaceAll('%7E','~');
		}
		/******************************************
		* Method Name : callAPI
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: 1. create json for attachment creation. 2. Get signature for CAPS.
		* Parameter: String,String,String,String
		* Return: HTTPResponse
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public static HTTPResponse callAPI(string url, string method, string jsonString, string userEmail){
			string signatureKeyId = DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
	
			DateTime now = DateTime.now();
			string nowFormatted = now.formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
			final string signature = calculateSignature(url, method, userEmail, nowFormatted);
			HttpRequest req = new HttpRequest();
			req.setMethod(method);
			req.setTimeout(120000);//Added to fix 35877
			req.setEndpoint(BASE_URL + url);
			req.setHeader(CAPS_ConstantHandler.CONTENT_TYPE, CAPS_ConstantHandler.APPLICATION_JSON);
			req.setHeader(CAPS_ConstantHandler.X_AMZ_DATE, nowFormatted);
			req.setHeader(CAPS_ConstantHandler.X_END_USER, userEmail);
			req.setHeader(CAPS_ConstantHandler.AUTHORIZATION_STR, CAPS_ConstantHandler.SIGNATURE_KEYID1 +signatureKeyId+CAPS_ConstantHandler.SIGNATURE_KEYID3 
		+ 'algorithm="hmac-sha256", ' 
		+ CAPS_ConstantHandler.OTHER_HEADER_VALUE
		+ CAPS_ConstantHandler.SIGNATURE_STR + signature + CAPS_ConstantHandler.DOUBLE_QUOTE);
			req.setBody(jsonString);
			Http http = new Http();
			HTTPResponse res = http.send(req);
			return res;
		}
		/******************************************
		* Method Name : calculateSignature
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: Calculate Signature
		* Parameter: String,String,String,String
		* Return: String
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public static String calculateSignature(string url, string method, string userEmail, string nowFormatted){
			
			final string secret = DecodeEncodeUtility.decodeValues(CH_Settings__c.getValues(CAPS_ConstantHandler.CAPS_SECRET).SettingValue__c);
			Blob secretBlob = Blob.valueOf(secret);
			string reqpath = CAPS_ConstantHandler.REQUEST_TARGET + method.toLowerCase() + ' ' + url;
			string thisdate = CAPS_ConstantHandler.X_AMZ_DATE_SIGN + nowFormatted;
			string capsenduser = CAPS_ConstantHandler.X_END_USER_SIGN + userEmail;
			string signstring = reqpath + CAPS_ConstantHandler.NEW_LINE + thisdate + CAPS_ConstantHandler.NEW_LINE + capsenduser;
			Blob signstringBlob = Blob.valueOf(signstring);
			Blob signatureBlob = Crypto.generateMac(CAPS_ConstantHandler.HMACSHA256, signstringBlob, secretBlob);
			String signature = EncodingUtil.base64Encode(signatureBlob);
			return signature;
		}
		/******************************************
		* Method Name : getCHattachmentdata
		* Created Date: 12-Sep-2018
		* Created By : TCS
		* Descsription: Create Ch_Attachment records in Salesforce
		* Parameter: ID,Boolean,String,String,Decimal,String,String,Boolean
		* Return: CH_Attachment__c
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/
		public static CH_Attachment__c getCHattachmentdata
			(Id caseRecordId, 
			Boolean customervisible, 
			String fileName,
			String description,
			Decimal fileSize,
			String classification,
			String attachmentId,
			Boolean isScrambled,
			Boolean isFromEmail)
		{
			CH_Attachment__c chattch = new CH_Attachment__c();
			chattch.Name = fileName;
			chattch.CH_Size__c = fileSize;
			chattch.CH_Description__c = description;
			chattch.CH_Puropse__c = CAPS_ConstantHandler.CASE_HANDLING;
			chattch.CH_Service_Class__c = CAPS_ConstantHandler.CARE_SREVICECLASS;
			chattch.CH_Classification__c = classification;
			chattch.Case__c = caseRecordId;
			chattch.CH_Status__c = CAPS_ConstantHandler.UPLOADING;
			chattch.AttachmentID__c = attachmentId;
			chattch.Customer_Visible__c = customervisible;
			chattch.CH_Uploaded__c = system.now();
			if(isCommunity()){
	chattch.CH_Portal_or_Email_to_Case__c = CAPS_ConstantHandler.PORTAl;
			}else{
	if(isFromEmail){
		chattch.CH_Portal_or_Email_to_Case__c = 'Email';
	}else{
		chattch.CH_Portal_or_Email_to_Case__c = CAPS_ConstantHandler.SALESFORCE;
	}
			}	
			if(!isScrambled){
	chattch.File_Name__c = fileName + CAPS_ConstantHandler.ENCRYPTEDDOTZIP;
	chattch.CH_FileType__c = CAPS_ConstantHandler.ENCRYPTED;
			}
			if(isScrambled){
	/*Adding scrambled attachment*/ 
	chattch.File_Name__c = fileName +CAPS_ConstantHandler.SCRAMBLEDDOTZIP;
	chattch.CH_FileType__c = CAPS_ConstantHandler.SCRAMBLED; 
			}
			return chattch;
		}
		/*****************************************************
		* Method Name : getCaseInfo
		* Created Date: 01 April 2019
		* Created By : TCS
		* Descsription: Get case info in DoInit
		* Parameter: Case Id
		* Return: Case
		* Last Modified by: 
		* Last Modified Date: 
		* Description: 
		*******************************************/	
		@AuraEnabled
		public static Case getCaseInfo(Id caseId){
			Case csObj = null;
			if(caseId != null){
	csObj = [SELECT Id, Status, Origin, CH_CaseOriginSystem__c 
		FROM Case 
		WHERE Id = : caseId 
		LIMIT 1]; 
			}
			return csObj;
		}
		/*********************************************************************
	*Description: to get the priority from the custom metadata.
	*US: NOKIASC-31214
	*Author:  TCS
	*Date:	15 Sep 2020
	*Method Name: getAttachmentPriority
	*Parameter: 
	*Return: Map<String,String>
	*********************************************************************/
	public static Map<String,String> getAttachmentPriority(){
		Map<String,String> attachmentPriorityMap = new Map<String,String>();
		for(CH_CAPSPriority__mdt Priority: [SELECT CH_Status__c,CH_Severity__c,CH_Priority__c,CH_Otage__c FROM CH_CAPSPriority__mdt]){
			String priorityString = (Priority.CH_Severity__c+Priority.CH_Otage__c+Priority.CH_Status__c).toLowerCase();//concatenating Severity, Outage and Status to form unique key
			attachmentPriorityMap.put(priorityString,Priority.CH_Priority__c);
		}
		return attachmentPriorityMap;
	}
	}