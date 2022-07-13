/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Attachment Object Utility Class.
 * @TestClass		 : CH_AttachmentUtils_Test.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created : 2021 06 09 – tiago.almeida@nokia.com
 * ----- 
**/
public class CH_AttachmentUtils {
	private static final string NOKIA_ADMINISTRATOR = 'Nokia Admin Profile';
	private static final string SYSTEM_ADMINISTRATOR = 'System Administrator';

	public static List<CH_Attachment__c> getRelated(Id caseId) {
		List<CH_Attachment__c> result = new List<CH_Attachment__c>();
		//
		List<Case> oCaseList = DML_SObject.doQuery('SELECT Id, RecordType.DeveloperName FROM Case WHERE Id = "' + caseId + '" LIMIT 1', true);
		Case oCase = !oCaseList.isEmpty() ? oCaseList.get(0) : null;
		//
		if(caseId !=null){
			String sQuery = 'SELECT Id, Name, RecordType.Name, AttachmentID__c, CH_Classification__c, CH_Description__c, CH_Puropse__c, CH_Service_Class__c, '
			+ 'CH_Size__c, CH_Status__c, Case__c, Customer_Visible__c, File_Name__c, Sensitive_Data__c, Uploaded__c, CH_Actual_Delete_Date__c, '
			+ 'CH_Case_Number_for_CAPS__c, CH_Expected_Delete_Date__c, CH_FileType__c, CH_MarkForDelete__c, CH_NoSuchFileinCAPS__c, CH_Uploaded__c, '
			+ 'CH_Portal_or_Email_to_Case__c, CH_Migrated_Attachment__c, CH_LogCollectionRequestID__c, CH_LogType__c, CH_NetworkElementAsset__c, '
			+ 'CH_LogAnalysisURL__c, CH_RequestDate__c, CH_RequestStatus__c, CH_LogCategory__c, CH_AutoLogCollection__c, RecordType.DeveloperName, '
			+ 'CH_ProblemVisible__c FROM CH_Attachment__c WHERE ';
			if (oCase.RecordType.DeveloperName.equals('CH_Problem')) {
	Set<String> linkedCasesIds = new Map<String,SObject>(DML_SObject.doQuery('SELECT Id, CH_Problem__c FROM Case WHERE CH_Problem__c = "' + caseId + '"', true)).keySet();
	if(!linkedCasesIds.isEmpty()) {
		sQuery += '(Case__c = "' + caseId + '" OR (Case__c IN ' + DML_SObject.setToString(linkedCasesIds) + ' AND CH_ProblemVisible__c = true)) AND ';
	}
	else { sQuery += 'Case__c = "' + caseId + '" AND '; }
			}
			else { sQuery += 'Case__c = "' + caseId + '" AND '; }
			if (Site.getSiteId() != null) {
	sQuery += 'Customer_Visible__c = true AND CH_FileType__c != "Scrambled" AND ';
	sQuery += '((CH_Status__c NOT IN ("On Hold", "Failed") AND CH_Portal_or_Email_to_Case__c = "Salesforce") OR CH_Portal_or_Email_to_Case__c != "Salesforce") ';
			} else {
	sQuery += '((CH_Status__c NOT IN ("On Hold", "Failed") AND CH_Portal_or_Email_to_Case__c = "Portal") OR CH_Portal_or_Email_to_Case__c != "Portal") ';
			}
			sQuery += 'ORDER BY CH_Uploaded__c DESC';
			result = DML_SObject.doQuery(sQuery, true);
		}
		return result;
	}

	public static Map<String, Object> getUserActionsAuthorization(Id caseId, Boolean forUpload) {
		Map<String, Object> result = new Map<String, Object>();
		List<Case> oCaseList = DML_SObject.doQuery('SELECT Id, CH_SuspectedDataBreach__c, CH_RDInterface__c, Status, Origin, CH_CaseOriginSystem__c, RecordType.DeveloperName, CH_Problem__c FROM Case WHERE Id = "' + caseId + '" LIMIT 1', true);
		Case oCase = !oCaseList.isEmpty() ? oCaseList.get(0) : null;
		Id userId = UserInfo.getUserId();
		Boolean isOwnerOrTeamMember = CH_CaseUtils.isOwnerOrTeamMember(caseId, userId);
		Boolean isCHAgent = CH_SecurityUtils.checkUserPermissions(UserInfo.getUserId(), new List<String>{'CH_Agent'}, new List<String>(), false);
		Boolean isProblem = oCase.RecordType.DeveloperName.equals('CH_Problem');
		Boolean isRestoration = oCase.RecordType.DeveloperName.equals('CH_NokiaIncidentWithRestoration'); 
		Boolean isStandard = oCase.RecordType.DeveloperName.equals('CH_NokiaStandardCase');		
		//Link Permission
		result.put('link', Site.getSiteId() == null && isOwnerOrTeamMember && !isProblem && ( isRestoration || isStandard));
		result.put('unlink', Site.getSiteId() == null && isOwnerOrTeamMember && (isProblem || isRestoration || isStandard));	 
		//Upload Permission
		if(forUpload != null) {
			Boolean validCaseStatus = (new List<String>{'Closed', 'Completed', 'Cancelled'}).indexOf(oCase.Status) == -1;
			if(Site.getSiteId() == null) {
	result.put('upload', validCaseStatus && (isOwnerOrTeamMember || isCHAgent));
	result.put('sizeWarning', false);
			}
			else {
	result.put('upload', validCaseStatus);
	result.put('sizeWarning', oCase.Origin == 'S2S' && oCase.CH_CaseOriginSystem__c == 'tmobile-tim');
			}
			return result;
		}
		//Download Permission
		result.put('download', !CH_SecurityUtils.checkUserPermissions(
			userId, new List<String>{'CH_Agent'}, new List<String>{}, false
		));
		//Delete Permission
		Boolean dataBreach = oCase != null && oCase.CH_SuspectedDataBreach__c;
		if(Site.getSiteId() == null) {
			result.put('delete', !dataBreach && isOwnerOrTeamMember);
		}
		else result.put('delete', !dataBreach);
		//Share Permission
	 List<CH_Problem_RnD_Reference__c> oRnDReferences = DML_SObject.doQuery('SELECT Id FROM CH_Problem_RnD_Reference__c WHERE CH_Related_Record__c = "' + caseId + '" LIMIT 1', true);
		Boolean isRDInterface = oCase.CH_RDInterface__c != null && (oCase.CH_RDInterface__c.equals('JIRA') || oCase.CH_RDInterface__c.equals('PRONTO'));
		result.put('share', Site.getSiteId() == null && isProblem && isRDInterface && !oRnDReferences.isEmpty());
		//URLs
		result.put('capsInstance', CH_Settings__c.getValues('CAPSInstance') != null ? CH_Settings__c.getValues('CAPSInstance').SettingValue__c :'');
		result.put('baseUrl', CH_Settings__c.getValues('BaseUrl') != null ? CH_Settings__c.getValues('BaseUrl').SettingValue__c :'');
		result.put('rndInterface', oCase.CH_RDInterface__c);
		return result;
	}
	
	public static List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> download(List<CH_Attachment__c> oAttachmentList) {
		List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper> downloadWarp = new List<CAPS_Attachments_Download.CAPS_DownloadResponseWrapper>() ;
		if(oAttachmentList != null && !oAttachmentList.isEmpty()){
			Map<String,List<String>> attachmentIdToFileListMap = new Map<String,List<String>>();
			List<String> attachmentIds = new List<String>();
			for(CH_Attachment__c oAttachment : oAttachmentList) {
	if(!String.isBlank(oAttachment.Id) && !String.isBlank(oAttachment.AttachmentID__c) && !String.isBlank(oAttachment.File_Name__c)) {
		List<String> fileNameList = attachmentIdToFileListMap.containsKey(oAttachment.AttachmentID__c) ? attachmentIdToFileListMap.get(oAttachment.AttachmentID__c) : new List<String>();
		fileNameList.add(oAttachment.File_Name__c);
		attachmentIdToFileListMap.put(oAttachment.AttachmentID__c, fileNameList);
		attachmentIds.add(oAttachment.Id);
	}
			}
			if(!attachmentIdToFileListMap.isEmpty()){
	downloadWarp  = new CAPS_Attachments_Download().getAttachment(attachmentIds, attachmentIdToFileListMap);
			}
		}
		return downloadWarp;
	}
	
	public static Boolean updateVisibility(List<CH_Attachment__c> oAttachmentList, String visibilityType, Boolean visibilityValue) {
		if(oAttachmentList != null && !oAttachmentList.isEmpty() && visibilityType != null && visibilityValue != null) {
			for(CH_Attachment__c oAttachment : oAttachmentList) {
	if(visibilityType.equals('Customer')) {
		oAttachment.Customer_Visible__c = visibilityValue;
		
	}
	else if(visibilityType.equals('Problem')) {
		oAttachment.CH_ProblemVisible__c = visibilityValue;
	}
			}
			DML_SObject.doUpdate(oAttachmentList, true);
			return true;
		}
		return false;
	}
	
	public static void markForDelete(Id caseId, List<CH_Attachment__c> oAttachmentList) {
		List<Case> oCaseList = DML_SObject.doQuery('SELECT Id, CH_SuspectedDataBreach__c FROM Case WHERE Id = "' + caseId + '" LIMIT 1', true);
		if(!oCaseList.isEmpty() && !oCaseList[0].CH_SuspectedDataBreach__c && oAttachmentList != null && !oAttachmentList.isEmpty()) {
			Set<String> attachmentIds = new Set<String>();
			for(CH_Attachment__c oAttachment : oAttachmentList) {
	if(!String.isBlank(oAttachment.Id) && !String.isBlank(oAttachment.AttachmentID__c)) {
		attachmentIds.add(oAttachment.AttachmentID__c);
	}
			}
			if(!attachmentIds.isEmpty() && !Test.isRunningTest()) {
	CAPS_Attachment_Delete.updateRetentionDaysforLightning(attachmentIds, true); //update retention days to minimum
			}
		}
	}
	
	public static String shareWithRND(Id caseid, String interfaceName, String subject, String combinedDescription, String comments, List<CH_Attachment__c> oAttachmentList) {
		Case oCase = (Case) DML_SObject.doQuery(
			'SELECT Id, Priority, CH_ReportedDate__c, CH_PausedSinceDate__c, CH_SolutionTargetDate__c, Severity__c, CH_SuspectedDataBreach__c, CaseNumber, CH_CRNumber__c, CH_Originating_Incident_Number__c, CH_Originating_Incident_Number__r.CaseNumber ' +
			'FROM Case WHERE Id = "' + caseId + '" LIMIT 1'
		, true).get(0); //Added PausedSinceDate & SolutionTargetDate For NOKIASC-39679
		CH_Problem_RnD_Reference__c oProblemRnDReference = CH_ExternalInterfaceUTIL.sendCaseAttachments(
			new CH_Problem_RnD_Reference__c(
	CH_RnD_Subject__c = subject,
	CH_RnD_Description__c = combinedDescription,
	CH_RnD_Comment__c = comments,
	CH_RnD_Interface__c = interfaceName,
	CH_Related_Record__c = caseid,
	CH_RnD_Reference__c = oCase.CH_CRNumber__c,
	CH_RnD_Direction__c = 'outbound',
	CH_RnD_Type__c = 'Update to R&D'
			),
			oCase, new Map<Id, CH_Attachment__c>(oAttachmentList).keySet()
		);
		return oProblemRnDReference.Id;
	}
	
	public static Map<String, String> initiateUpload(Id caseId, Map<String, Object> file) {
		List<Case> oCaseList = DML_SObject.doQuery(
			'SELECT Id, CaseNumber, Product.ProductCode, Status, Severity__c, CH_Outage__c, ' + 
			'CH_SecurityGroup__c,CH_LawfullIntercept_CALEA__c, CH_Product_Release__r.CH_NSNLegacyCode__c, Account.AccountNumber, ' +
			'Entitlement.ServiceContract.CH_CDB_CustomerId__c FROM Case WHERE Id = "' + caseId + '" LIMIT 1'
		, true);
		Map<String, String> result = new Map<String, String>();
		String fileName = file.containsKey('Filename') ? (String) file.get('Filename') : '';
		Decimal fileSize = file.containsKey('Size') ? (Decimal) file.get('Size') : 0;
		if(!oCaseList.isEmpty() && String.isNotBlank(fileName) && fileSize  != null && fileSize > 0) {
			Case oCase = oCaseList.get(0);
			if(!(new Set<String>{'Completed','Closed','Cancelled'}).contains(oCase.Status)) {
	result.put('caseHasBeenClosed', '');
	Map<String,String> CAPSPriorityMap = getAttachmentPriority();
	//NOKIASC-31214
	String oCasePriority = (oCase.Severity__c+oCase.CH_Outage__c+oCase.Status).toLowerCase();
	String priority = (!CAPSPriorityMap.isEmpty() && CAPSPriorityMap.containsKey(oCasePriority))?CAPSPriorityMap.get(oCasePriority):System.Label.CAPS_Default_Priority;
	Boolean caleaFlag = oCase.CH_LawfullIntercept_CALEA__c;// Eashwar 36529
	//
	JSONGenerator gen = JSON.createGenerator(true);
	gen.writeStartObject();
	gen.writeFieldName(CAPS_ConstantHandler.CUSTOMER);
	gen.writeStartObject();
	if(oCase.Entitlement != null && oCase.Entitlement.ServiceContract != null && oCase.Entitlement.ServiceContract.CH_CDB_CustomerId__c != null){
		gen.writeStringField(CAPS_ConstantHandler.ID_CDB, oCase.Entitlement.ServiceContract.CH_CDB_CustomerId__c);
	}else if(oCase.Account != null && oCase.Account.AccountNumber != null){
		gen.writeStringField(CAPS_ConstantHandler.ID_CDB, oCase.Account.AccountNumber);
	}
	gen.writeEndObject();
	gen.writeFieldName(CAPS_ConstantHandler.FILES);
	gen.writeStartArray();
	gen.writeStartObject();
	gen.writeStringField(CAPS_ConstantHandler.NAMES,fileName);
	gen.writeNumberField(CAPS_ConstantHandler.SIZESTRING, fileSize);
	gen.writeEndObject();
	gen.writeEndArray();
	if(oCase.Product !=null && oCase.Product.ProductCode != null){
		gen.writeFieldName(CAPS_ConstantHandler.PRODUCT);
		gen.writeStartObject();
		gen.writeStringField(CAPS_ConstantHandler.ID_CDB, oCase.Product.ProductCode);
		gen.writeEndObject();
	}
	if(Label.ExecuteProductionVersion == CAPS_ConstantHandler.YESSTRING && oCase.CH_Product_Release__c != null && oCase.CH_Product_Release__r.CH_NSNLegacyCode__c != null){
		gen.writeFieldName(CAPS_ConstantHandler.PRODUCTVERSION);
		gen.writeStartObject();
		gen.writeStringField(CAPS_ConstantHandler.ID_CDB, oCase.CH_Product_Release__r.CH_NSNLegacyCode__c); 
		gen.writeEndObject();
	}
	String classification = file.containsKey('Classification') ? (String) file.get('Classification') : '';
	if(String.isNotBlank(classification)){
		if(CAPS_ConstantHandler.ENDUSER_DATA.equalsIgnoreCase(classification)){//End USER Sensitive Info
			gen.writeStringField(CAPS_ConstantHandler.NCTCLASSIFICATION,CAPS_ConstantHandler.ENDUSER_DATA_ID); 
		}else if(CAPS_ConstantHandler.OTHERSENSITIVE_DATA.equalsIgnoreCase(classification)){//Other Sensitive Info
			gen.writeStringField(CAPS_ConstantHandler.NCTCLASSIFICATION,CAPS_ConstantHandler.OTHERSENSITIVE_DATA_ID); 
		}else if(CAPS_ConstantHandler.OTHER_DATA.equalsIgnoreCase(classification)){//Non Sensitive Info.
			gen.writeStringField(CAPS_ConstantHandler.NCTCLASSIFICATION,CAPS_ConstantHandler.OTHER_DATA_ID); 
		}
	}   
	gen.writeStringField(CAPS_ConstantHandler.SERVICECLASS,CAPS_ConstantHandler.CARE_SREVICECLASS); 
	gen.writeStringField(CAPS_ConstantHandler.APP_STR,CAPS_ConstantHandler.SFSERVICECLOUD); 
	gen.writeStringField(CAPS_ConstantHandler.PURPOSE,CAPS_ConstantHandler.CASE_HANDLING);
	gen.writeStringField(CAPS_ConstantHandler.DESCRIPTIONJSON, file.containsKey('Description') ? (String) file.get('Description') : '');
	if(Label.CAPS_AppName != null){
		gen.writeFieldName(CAPS_ConstantHandler.TICKET);
		gen.writeStartObject();
		gen.writeStringField(CAPS_ConstantHandler.APP_NAME, Label.CAPS_AppName);
		gen.writeStringField(CAPS_ConstantHandler.TICKET_ID, oCase.CaseNumber);
		gen.writeEndObject();
	}
	if(oCase.CH_SecurityGroup__c != null){
		gen.writeStringField(CAPS_ConstantHandler.SF_SECURITY_GROUPS, oCase.CH_SecurityGroup__c);
	}
	gen.writeStringField(CAPS_ConstantHandler.SF_CASE_STATUS, CAPS_ConstantHandler.OPEN_STATUS);
	gen.writeBooleanField(CAPS_ConstantHandler.CUSTOMERVISIBLEJSON, file.containsKey('CustomerVisible') ? (Boolean) file.get('CustomerVisible') : true);
	gen.writeStringField(CAPS_ConstantHandler.PRIORITY, Priority);  //Added for NOKIASC-31214   
	gen.writeBooleanField(CAPS_ConstantHandler.LAWFULINTERCEPT_CALEA, caleaFlag);//Added for NOKIASC-36529
	gen.writeEndObject();
	//
	result.put('jsonString', gen.getAsString());
	String nowFormatted = DateTime.now().formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
	result.put('signature', calculateSignature(CAPS_ConstantHandler.SYSTEM_URL1,CAPS_ConstantHandler.POST_METHOD,CAPS_ConstantHandler.CAPS_ENDUSER,nowFormatted));
	result.put('nowFormatted', nowFormatted);
	result.put('signatureKey', DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2));
	result.put('baseURL', CAPS_ConstantHandler.BASE_URL);
	result.put('logApiURL', CAPS_ConstantHandler.SYSTEM_URL1);
	result.put('s3SignApiURL', CAPS_ConstantHandler.S3_SIGNURL);
	result.put('s3SignApiV4URL', CH_Settings__c.getValues('CAPSVS3SignAPIV4Url') != null ? CH_Settings__c.getValues('CAPSVS3SignAPIV4Url').SettingValue__c :'');
			}
			else result.put('caseHasBeenClosed', 'This Case has been '+ oCase.Status +'. So, File cannot be uploaded.');
		}
		System.debug('caps attachment result'+result);
		return result;
	}
	
	public static Map<String, String> parseResponse(String response) {
		Map<String, String> result = new Map<String, String>();
		JSONParser parser = JSON.createParser(response);
		while(parser.nextToken() != null) {
			String key = parser.getCurrentName();
			if(!result.containsKey('attachmentId') && key == CAPS_ConstantHandler.KEY_ID) {
	parser.nextToken();
	result.put('attachmentId', parser.getText());
	key = parser.getCurrentName();
			}
			//
			if(key == CAPS_ConstantHandler.S3KEYNAME) { result.put('s3keyname', parser.getText()); }
			else if(key == CAPS_ConstantHandler.KEY_ID) { result.put('fileid', parser.getText()); }
			else if(key == CAPS_ConstantHandler.SIGNER) { result.put('signer', parser.getText()); }
			else if(key == CAPS_ConstantHandler.KEY_USER) { result.put('user', parser.getText()); }
			else if(key == CAPS_ConstantHandler.SIGN_TOKEN) { result.put('signtoken', parser.getText()); }
			else if(key == CAPS_ConstantHandler.EXPIRATION) { result.put('expiration', parser.getText()); }
			else if(key == CAPS_ConstantHandler.PERMISSION) { result.put('permission', parser.getText()); }
			else if(key == CAPS_ConstantHandler.ACL) { result.put('acl', parser.getText()); }
			else if(key == CAPS_ConstantHandler.AWS_URL) { result.put('aws_url', parser.getText()); }
			else if(key == CAPS_ConstantHandler.BUCKET) { result.put('bucket', parser.getText()); }
			else if(key == CAPS_ConstantHandler.AWS_KEY) { result.put('aws_key', parser.getText()); }
			else if(key == 's3_region'){  result.put('s3_region', parser.getText()); }
			else if(key == 'aws_signature_version'){  result.put('aws_signature_version', parser.getText()); }
		}
		String nowFormatted = DateTime.now().formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
		result.put('amzdate', nowFormatted);
		result.put('signature1stS3Sign', calculateSignature(CAPS_ConstantHandler.S3_SIGNURL,CAPS_ConstantHandler.GET_METHOD,CAPS_ConstantHandler.CAPS_ENDUSER,nowFormatted));
		return result;
	}
	
	public static String completeUpload(Id caseId, Map<String, Object> file, Map<String, String> initialMap, Map<String, String> partToETagMap, String uploadId, String s3KeyNameInUTF8, Boolean isFromEmail) {
		String result;
		String attachmentId = initialMap.get('attachmentId');
		completeFile(partToETagMap, initialMap, uploadId, s3KeyNameInUTF8);
		HTTPResponse oHTTPResponse = callAPI(
			CAPS_ConstantHandler.SYSTEM_URL + attachmentId,
			CAPS_ConstantHandler.PUT_METHOD,
			getJsonToChangeStatus(initialMap.get('fileid'), file.containsKey('Size') ? (Decimal) file.get('Size') : 0, file.containsKey('Filename') ? (String) file.get('Filename') : ''),
			CAPS_ConstantHandler.CAPS_ENDUSER
		);
		if(oHTTPResponse != null && oHTTPResponse.getStatusCode() == 200){
			Map<String, Object> oMapApiResponse = (Map<String, Object>) JSON.deserializeUntyped(oHTTPResponse.getBody());
			List<CH_Attachment__c> oAttachmentList = new List<CH_Attachment__c>();
			oAttachmentList.add(createAttachment(caseId, file, attachmentId, false, isFromEmail));
			if((Boolean) oMapApiResponse.get('scrambled')) {
	oAttachmentList.add(createAttachment(caseId, file, attachmentId, true, isFromEmail));
			}
			Database.insert(oAttachmentList,true);
			result = 'success';
		}
		return result;
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
		req.setEndpoint(CAPS_ConstantHandler.BASE_URL + url);
		req.setHeader(CAPS_ConstantHandler.CONTENT_TYPE, CAPS_ConstantHandler.APPLICATION_JSON);
		req.setHeader(CAPS_ConstantHandler.X_AMZ_DATE, nowFormatted);
		req.setHeader(CAPS_ConstantHandler.X_END_USER, userEmail);
		req.setHeader(CAPS_ConstantHandler.AUTHORIZATION_STR, CAPS_ConstantHandler.SIGNATURE_KEYID1 +signatureKeyId+CAPS_ConstantHandler.SIGNATURE_KEYID3 
	+ 'algorithm="hmac-sha256", ' 
	+ CAPS_ConstantHandler.OTHER_HEADER_VALUE
	+ CAPS_ConstantHandler.SIGNATURE_STR + signature + CAPS_ConstantHandler.DOUBLE_QUOTE);
		req.setBody(jsonString);
		return new Http().send(req);
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
	public static String completeFile(Map<String, String> partToETagMap, Map<String, String> initialMap, String uploadId, String fileNameInUTF8) {
		string s3v4SignAPIUrl = CH_Settings__c.getValues('CAPSVS3SignAPIV4Url') != null ? CH_Settings__c.getValues('CAPSVS3SignAPIV4Url').SettingValue__c :'';
		DateTime now = DateTime.now();
		//Create xml to update CAPS with complete status
		DOM.Document doc = new DOM.Document();
		dom.XmlNode completeMultipartUpload = doc.createRootElement(CAPS_ConstantHandler.COMPLETEDMULTIPARTUPLOAD, null, null);
		for(String itr: partToETagMap.keySet()){//check if sorting required if partnumber is not coming sequentially 1,2,3,4....
			dom.XmlNode part = completeMultipartUpload.addChildElement(CAPS_ConstantHandler.PART_STR, null, null);
			part.addChildElement(CAPS_ConstantHandler.PARTNUMBER, null, null).addTextNode(string.valueOf(itr));
			part.addChildElement(CAPS_ConstantHandler.ETAG, null, null).addTextNode(partToETagMap.get(itr));
		}
		String xmlstring = doc.toXmlString();
		//
		HttpRequest request = new HttpRequest();
		request.setMethod(CAPS_ConstantHandler.POST_METHOD);
		String signVersion = initialMap.get('aws_signature_version');
		String bucket = initialMap.get('bucket');
		String authHead5;
		if(signVersion == '2') {
			String formattedDate = now.formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
			String urlToSign = 'POST\n\napplication/xml; charset=UTF-8\n\n'+'x-amz-date:' + formattedDate + CAPS_ConstantHandler.NEW_LINE + CAPS_ConstantHandler.FRONT_SLASH + bucket +
		CAPS_ConstantHandler.FRONT_SLASH + fileNameInUTF8 + CAPS_ConstantHandler.UPLOADID + uploadId;
			authHead5 = 'AWS ' + initialMap.get('aws_key') + ':' + signURLForS3(initialMap, urlToSign);
			request.setHeader(CAPS_ConstantHandler.X_AMZ_DATE, formattedDate);
		}
		else if(signVersion == '4') {
			String dateTimeStamp = now.formatGMT('yyyyMMdd')+'T'+now.formatGMT('HHmmss')+'Z';
			String payloadHash = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(xmlstring)));
			String signHeaders = 'content-type;host;x-amz-date';
			String credentialScope = now.formatGMT('yyyyMMdd') + '/' + initialMap.get('s3_region') + '/s3/aws4_request';
			String[] awsUrl = initialMap.get('aws_url').split('/');
			string canonicalRequest = 'POST' + '\n' + '/' + awsUrl[3] + '/' + awsUrl[4] + '/' + bucket + '/' + fileNameInUTF8 + '\n' +
		'uploadId=' + uploadId + '\n' + 'content-type:application/xml; charset=UTF-8'+'\n' + 'host:' +awsUrl[2] +
		'\n' + 'x-amz-date:' + dateTimeStamp + '\n' + '\n' + signHeaders + '\n' + payloadHash;
			//
			HttpRequest tokenRequest = new HttpRequest();
			tokenRequest.setMethod('GET');
			tokenRequest.setEndpoint(
	s3v4SignAPIUrl + '?to_sign=' + encode('AWS4-HMAC-SHA256' + '\n' +  dateTimeStamp + '\n' +  credentialScope + '\n' +  EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(canonicalRequest)))) + 
	'&datetime=' + encode(dateTimeStamp) + '&canonical_request=' + encode(canonicalRequest) + '&signer=' + encode(initialMap.get('signer')) + '&user=' + encode(initialMap.get('user')) +
	'&expiration=' + encode(initialMap.get('expiration')) + '&permission=' + encode(initialMap.get('permission')) + '&signtoken='+ encode(initialMap.get('signtoken'))
			);
			HTTPResponse tokenResponse = new Http().send(tokenRequest);
			authHead5 = 'AWS4-HMAC-SHA256 ' + 'Credential=' + initialMap.get('aws_key') + '/' + credentialScope +
			', SignedHeaders=' + signHeaders + ', Signature=' + ((tokenResponse != null && tokenResponse.getStatusCode() == 200) ? tokenResponse.getBody() : null);
			request.setHeader('x-amz-content-sha256', payloadHash);
			request.setHeader('x-amz-date', dateTimeStamp);
		}
		request.setHeader(CAPS_ConstantHandler.CONTENT_TYPE, CAPS_ConstantHandler.APPLICATIONXMLCHARUTF);
		request.setHeader(CAPS_ConstantHandler.AUTHORIZATION_STR, authHead5);
		request.setBody(xmlstring);
		request.setEndpoint(initialMap.get('aws_url') + CAPS_ConstantHandler.FRONT_SLASH + bucket + CAPS_ConstantHandler.FRONT_SLASH + fileNameInUTF8 + CAPS_ConstantHandler.UPLOADID + uploadId);
		HTTPResponse response = new Http().send(request);
		return (response != null && response.getStatusCode() == 200) ? response.getBody() : null;
	}
	
	//Private
	
	private static Map<String,String> getAttachmentPriority(){
		Map<String,String> attachmentPriorityMap = new Map<String,String>();
		Map<String,CH_CAPSPriority__mdt> capsPrority = CH_CAPSPriority__mdt.getall();
		if(!capsPrority.isEmpty()) { 
			for(CH_CAPSPriority__mdt Priority: capsPrority.values()) {
	String priorityString = (Priority.CH_Severity__c+Priority.CH_Otage__c+Priority.CH_Status__c).toLowerCase();//concatenating Severity, Outage and Status to form unique key
	attachmentPriorityMap.put(priorityString,Priority.CH_Priority__c);
			}
		}
		return attachmentPriorityMap;
	}
	
	@testVisible
	private static CH_Attachment__c createAttachment(Id caseId, Map<String, Object> file, String attachmentId, Boolean isScrambled, Boolean isFromEmail) {
		CH_Attachment__c oAttachment = new CH_Attachment__c();
		oAttachment.Case__c = caseId;
		oAttachment.Name = file.containsKey('Filename') ? (String) file.get('Filename') : '';
		oAttachment.CH_Size__c = file.containsKey('Size') ? (Decimal) file.get('Size') : 0;
		oAttachment.CH_Description__c = file.containsKey('Description') ? (String) file.get('Description') : '';
		oAttachment.CH_Classification__c = file.containsKey('Classification') ? (String) file.get('Classification') : '';
		oAttachment.Customer_Visible__c = file.containsKey('CustomerVisible') ? (Boolean) file.get('CustomerVisible') : true;
		oAttachment.CH_ProblemVisible__c = file.containsKey('ProblemVisible') ? (Boolean) file.get('ProblemVisible') : false;
		//
		oAttachment.CH_Puropse__c = CAPS_ConstantHandler.CASE_HANDLING;
		oAttachment.CH_Service_Class__c = CAPS_ConstantHandler.CARE_SREVICECLASS;
		oAttachment.CH_Status__c = CAPS_ConstantHandler.UPLOADING;
		oAttachment.AttachmentID__c = attachmentId;
		oAttachment.CH_Uploaded__c = system.now();
		if(Site.getSiteId() == null) { oAttachment.CH_Portal_or_Email_to_Case__c = (isFromEmail ? 'Email' : CAPS_ConstantHandler.SALESFORCE); }
		else { oAttachment.CH_Portal_or_Email_to_Case__c = CAPS_ConstantHandler.PORTAl; }
		if(isScrambled){
			oAttachment.File_Name__c = oAttachment.Name + CAPS_ConstantHandler.SCRAMBLEDDOTZIP;
			oAttachment.CH_FileType__c = CAPS_ConstantHandler.SCRAMBLED; 
		}
		else {
			oAttachment.File_Name__c = oAttachment.Name + CAPS_ConstantHandler.ENCRYPTEDDOTZIP;
			oAttachment.CH_FileType__c = CAPS_ConstantHandler.ENCRYPTED;
		}
		return oAttachment;
	}
	
	private static String calculateSignature(string url, string method, string userEmail, string nowFormatted){
		final string secret = DecodeEncodeUtility.decodeValues(CH_Settings__c.getValues(CAPS_ConstantHandler.CAPS_SECRET).SettingValue__c);
		String sign = CAPS_ConstantHandler.REQUEST_TARGET + method.toLowerCase() + ' ' + url + CAPS_ConstantHandler.NEW_LINE +
	CAPS_ConstantHandler.X_AMZ_DATE_SIGN + nowFormatted + CAPS_ConstantHandler.NEW_LINE +
	CAPS_ConstantHandler.X_END_USER_SIGN + userEmail;
		return EncodingUtil.base64Encode(Crypto.generateMac(CAPS_ConstantHandler.HMACSHA256, Blob.valueOf(sign), Blob.valueOf(secret)));
	}

	@testVisible
	private static String signURLForS3(Map<String, String> initialMap, String urlToSign){
		HttpRequest request = new HttpRequest();
		request.setMethod(CAPS_ConstantHandler.GET_METHOD);
		request.setEndpoint(
			CAPS_ConstantHandler.BASE_URL + CAPS_ConstantHandler.S3_SIGNURL + CAPS_ConstantHandler.TOSIGN +
			EncodingUtil.urlEncode(urlToSign, CAPS_ConstantHandler.UTF8FORMAT) + CAPS_ConstantHandler.SIGNERURL +
			EncodingUtil.urlEncode(initialMap.get('signer'), CAPS_ConstantHandler.UTF8FORMAT) + CAPS_ConstantHandler.USER_URL +
			EncodingUtil.urlEncode(initialMap.get('user'), CAPS_ConstantHandler.UTF8FORMAT) + CAPS_ConstantHandler.AMPERSANDEXPIRATION +
			EncodingUtil.urlEncode(initialMap.get('expiration'), CAPS_ConstantHandler.UTF8FORMAT) + CAPS_ConstantHandler.PERMISSIONURL +
			EncodingUtil.urlEncode(initialMap.get('permission'), CAPS_ConstantHandler.UTF8FORMAT) + CAPS_ConstantHandler.SIGNTOKENURL +
			EncodingUtil.urlEncode(initialMap.get('signtoken'), CAPS_ConstantHandler.UTF8FORMAT)
		);
		HTTPResponse response = new Http().send(request);
		return (response != null && response.getStatusCode() == 200) ? response.getBody() : null;
	}
	
	@testVisible
	private static String getJsonToChangeStatus(String fileid, Decimal fileSize, String fileName){
		JSONGenerator gen = JSON.createGenerator(true);
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
		return gen.getAsString();
	}
	
	@testVisible
	private static String encode(String data) {
		return (string.isBlank(data) ? '' : EncodingUtil.urlEncode(data, 'UTF-8')).replaceAll('%7E','~');
	}
}