/*************************************************************************************************
 * Class Name : CAPS_ConstantHandler
 * Created Date: 10 July 2018
 * Created By : TCS
 * Description: CAPS Integration related constant values
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
*************************************************************************************************/
public without sharing class CAPS_ConstantHandler{
	public static final string BASE_URL = CH_Settings__c.getValues('BaseUrl') != null ? CH_Settings__c.getValues('BaseUrl').SettingValue__c :'';
	public static final string CAPS_ENDUSER = CH_Settings__c.getValues('CAPSEndUserforPUT') != null ? CH_Settings__c.getValues('CAPSEndUserforPUT').SettingValue__c :'';
	public static final string DATE_FORMAT = 'EEE, d MMM yyyy HH:mm:ss z';
	public static final string PUT_METHOD = 'PUT';
	public static final string GET_METHOD = 'GET';
	public static final string POST_METHOD = 'POST';
	public static final string SYSTEM_URL = CH_Settings__c.getValues('StorageUrl') != null ? CH_Settings__c.getValues('StorageUrl').SettingValue__c :'';
	public static final string SYSTEM_URL1 = CH_Settings__c.getValues('StorageUrl1') != null ? CH_Settings__c.getValues('StorageUrl1').SettingValue__c :'';
	public static final string REQUEST_TARGET='(request-target): ';
	public static final string CONTENT_TYPE = 'Content-Type';
	public static final string APPLICATION_JSON = 'application/json';
	public static final string X_AMZ_DATE_SIGN = 'x-amz-date: ';
	public static final string X_AMZ_DATE = 'x-amz-date';
	public static final string X_END_USER_SIGN = 'x-end-user: ';
	public static final string X_END_USER = 'X-End-User';
	public static final string AUTHORIZATION_STR = 'Authorization';
	public static final string SIGNATURE_KEYID1 = 'Signature keyId="';
	public static final string SIGNATURE_KEYID2 = CH_Settings__c.getValues('CAPSSignatureKey') != null ? CH_Settings__c.getValues('CAPSSignatureKey').SettingValue__c :'';
	public static final string SIGNATURE_KEYID3 = '",';
	public static final string ALGORITHM_STR = 'algorithm="hmac-sha256",';
	public static final string OTHER_HEADER_VALUE = 'headers="(request-target) x-amz-date x-end-user",';
	public static final string SIGNATURE_STR = 'signature= "';
	public static final string EMPTY_WHITESPACE = ' ';
	public static final string DOUBLE_QUOTE = '"';
	public static final string RETENTION_DAYS = 'retention_days';
	public static final Integer RETENTION_DAYS_1 = Integer.valueOf(CH_Settings__c.getValues('RetentionDayForDelete') != null ? CH_Settings__c.getValues('RetentionDayForDelete').SettingValue__c :'0');
	public static final Integer RETENTION_DAYS_730 = Integer.valueOf(CH_Settings__c.getValues('RetentionDaysNonSensitive') != null ? CH_Settings__c.getValues('RetentionDaysNonSensitive').SettingValue__c :'0');
	public static final Integer REQUEST_STATUS_200 = 200;
	public static final string DELETED_STR = 'Deleted';
	public static final String CLOSED_STATUS = 'Closed';
	public static final String SENSITIVE_DATA = 'Sensitive Data';
	public static final String NONSENSITIVE_DATA = 'Non-Sensitive Data';
	public static final String ENDUSER_DATA = 'Service Provider End User Information';
	public static final String OTHERSENSITIVE_DATA = 'Other Sensitive Information';
	public static final String OTHER_DATA = 'Other Information';
	public static final Integer CALL_OUT_LIMIT= Integer.valueOf(CH_Settings__c.getValues('LimitOfListSize') != null ? CH_Settings__c.getValues('LimitOfListSize').SettingValue__c :'0');
	public static final Integer CALLOUTLIMITCHATTACHMENTTRIGGER = Integer.valueOf(CH_Settings__c.getValues('LimitFromCHAttachmentTrigger') != null ? CH_Settings__c.getValues('LimitFromCHAttachmentTrigger').SettingValue__c :'0');
	public static final String CANCELLED_STATUS = 'Cancelled';
	public static final String CAPS_SECRET = 'CAPSSecret';
	public static final String NEW_LINE = '\n';
	public static final String HMACSHA256 = 'HmacSHA256';
	public static final String USER_STR = '?user=';
	public static final String USER_URL = '&user=';
	public static final String PLUS_SYMBOL = '+';
	public static final String FRONT_SLASH = '/';
	public static final String PERCENT2F = '%2F';
	public static final String PERCENT2B = '%2B';
	public static final String AWSACCESSKEYID = '?AWSAccessKeyId=';
	public static final String EXPIRES_STR = '&Expires=';
	public static final String SIGNATURE_STRING = '&Signature=';
	public static final String FILE_ENCRYPTED = '.encrypted.zip';
	public static final String ENCRYPTION_KEY = 'encryption_key';
	public static final String EVAPORATE = 'evaporate';
	public static final String AWS_URL = 'aws_url';
	public static final String AWS_KEY = 'aws_key';
	public static final String SIGNER_URL = 'signer_url';
	public static final String BUCKET = 'bucket';
	public static final String SIGN_PARAMS = 'sign_params';
	public static final String EXPIRATION = 'expiration';
	public static final String PERMISSION = 'permission';
	public static final String SIGNER = 'signer';
	public static final String SIGN_TOKEN = 'signtoken';
	public static final String UTF8FORMAT = 'UTF-8';
	public static final String EXPIRATIONEQUAL = '?expiration=';
	public static final String PERMISSIONURL = '&permission=';
	public static final String SIGNERURL = '&signer=';
	public static final String SIGNTOKENURL = '&signtoken=';
	public static final String GETNEWLINES = 'GET\n\n\n';
	public static final String TO_SIGN = '&to_sign=';
	public static final string NOKIA_USERNAME = CH_Settings__c.getValues('NokiaUserName') != null ? CH_Settings__c.getValues('NokiaUserName').SettingValue__c :'';
	public static final string S3_SIGNURL = CH_Settings__c.getValues('S3SignUrl') != null ? CH_Settings__c.getValues('S3SignUrl').SettingValue__c :'';
	public static final string CLASSIFICATION = 'Classification';
	public static final string DESCRIPTION = 'Description';
	public static final string CUSTOMERVISIBLE = 'Customer Visible';
	public static final string ticketid='Ticket Id';
	public static final string PRODUCTID = 'Product Id';
	public static final string CDBCUSTOMERID = 'CDB CustomerId';
	public static final string REFERENTIALID = 'Referential Id';
	public static final string SECURITYGROUP = 'Security Group';
	public static final string PRODUCTVERSIONID = 'Product Version Id';
	public static final string PRODUCT = 'product';
	public static final string SF_SECURITY_GROUPS = 'SFsecuritygroup';
	public static final string ID_CDB = 'id_cdb';
	public static final string PRODUCTVERSION = 'productversion';
	public static final string CASESTATUS = 'Case Status';
	public static final String ENDUSER_DATA_ID = '1';
	public static final String OTHERSENSITIVE_DATA_ID = '3';
	public static final String OTHER_DATA_ID = '4';
	public static final String KEY_USER = 'user';
	public static final String S3KEYNAME = 's3keyname';
	public static final String KEY_ID = 'id';
	public static final String ACL = 'acl';
	public static final String CASE_HANDLING = 'Case Handling';
	public static final String CARE_SREVICECLASS = 'CARE';
	public static final String UPLOADING = 'Uploading';
	public static final String PORTAl = 'Portal';
	public static final String SALESFORCE = 'Salesforce';
	public static final String ENCRYPTEDDOTZIP = '.encrypted.zip';
	public static final String ENCRYPTED = 'Encrypted';
	public static final String SCRAMBLEDDOTZIP = '.scrambled.zip';
	public static final String SCRAMBLED = 'Scrambled';
	public static final String TOSIGN = '?to_sign=';
	public static final String AMPERSANDEXPIRATION = '&expiration=';
	public static final String CUSTOMER = 'customer';
	public static final String FILES = 'files';
	public static final String NAMES = 'name';
	public static final String SIZESTRING = 'size';
	public static final String YESSTRING = 'Yes';
	public static final String NCTCLASSIFICATION = 'nctclassification';
	public static final String SERVICECLASS = 'service_class';
	public static final String APP_STR = 'app';
	public static final String SFSERVICECLOUD = 'SF Service Cloud';
	public static final String PURPOSE = 'purpose';
	public static final String DESCRIPTIONJSON = 'description';
	public static final String TICKET = 'ticket';
	public static final String APP_NAME = 'app_name';
	public static final String TICKET_ID = 'ticket_id';
	public static final String SF_CASE_STATUS = 'sf_case_status';
	public static final String OPEN_STATUS = 'Open';
	public static final String CUSTOMERVISIBLEJSON = 'customer_visible';
	public static final String STATUS = 'status';
	public static final String READY = 'ready';
	public static final String READY_STATUS = 'Ready';
	public static final String UPLOADID = '?uploadId=';
	public static final String COMPLETEDMULTIPARTUPLOAD = 'CompleteMultipartUpload';
	public static final String PARTNUMBER = 'PartNumber';
	public static final String ETAG = 'ETag';
	public static final String APPLICATIONXMLCHARUTF = 'application/xml; charset=UTF-8';
	public static final String PART_STR = 'Part';
	public static final String AWS_STR = 'AWS ';
	public static final String PARTNUMBER_P_INSMALL = 'partNumber';
	public static final String ETAGVARIABLE = 'etag';
	public static final String PRIORITY = 'ticket.priority'; //Added as part of NOKIASC-21314
	public static final String LAWFULINTERCEPT_CALEA = 'nct_lawful_intercept'; //NOKIASC-36529
	
	public static string cAPSAttachmentDelete = 'CAPS_Attachment_Delete';
	public static string cHCAPSCaseTriggerHelper = 'CH_CAPSCaseTriggerHelper';
	public static string cHAttachmentsTriggerHandler = 'CH_AttachmentsTriggerHandler';
	public static string updateRetentionDaysforTrigger = 'updateRetentionDaysforTrigger';
	public static string updateAllFieldsforTrigger = 'updateAllFieldsforTrigger';
	public static string updateRetentionDaysforLightning = 'updateRetentionDaysforLightning';
	public static string updateAttchmentinCAPS = 'updateAttchmentinCAPS';
	public static string cAPSAttachmentDownload = 'CAPS_Attachments_Download';
	public static string getAttachment = 'getAttachment';
	
	
	public static string othersensitiveinformation='Other Sensitive Information';
	public static string ServiceProviderEndUserInformation ='Service Provider End User Information'; 
	public static string OtherInformation   ='Other Information';  
	
	public static final Integer SPECIFICTIMEFORONHOLD = Integer.valueOf(CH_Settings__c.getValues('SpecificTimeForOnhold') != Null ? CH_Settings__c.getValues('SpecificTimeForOnhold').SettingValue__c : '0');
	public static final String ONHOLD ='On Hold';
	public static final string DELETED_STATUS = 'deleted';
	public static final string ENCRYPTED_TYPE = 'encrypted';
	public static final string SCRAMBLED_TYPE = 'scrambled';
	public static final string FAILED_STATUS = 'failed';
	public static final string TYPE_STR = 'type';
	public static final Integer STATUS_UPDATEBATCH_FREQ = Integer.valueOf(CH_Settings__c.getValues('RunFreqInMinuteCAPSStatusUpdateBatch') != null ? CH_Settings__c.getValues('RunFreqInMinuteCAPSStatusUpdateBatch').SettingValue__c :'0');
	public static final string JOBNAME = 'Scheduler_CAPSStatusUpdateBatch ';
	public static final Integer EXPIRATION_ADD_60 = Integer.valueOf(CH_Settings__c.getValues('ExpirationTimeAdded') != null ? CH_Settings__c.getValues('ExpirationTimeAdded').SettingValue__c :'0');
	public static final string RETENTION_DAYS1_STR = CH_Settings__c.getValues('RetentionDayForDelete') != null ? CH_Settings__c.getValues('RetentionDayForDelete').SettingValue__c :'0';
	public static final string RETENTION_DAYS720_STR = CH_Settings__c.getValues('RetentionDaysNonSensitive') != null ? CH_Settings__c.getValues('RetentionDaysNonSensitive').SettingValue__c :'0';
	
	public static final Integer ATTACHMENT_NUMBER_DEL_MANUAL = Integer.valueOf(CH_Settings__c.getValues('AttachmentNumberinEachJobManualDelete') != null ? CH_Settings__c.getValues('AttachmentNumberinEachJobManualDelete').SettingValue__c :'0');
	public static final Integer ATTACHMENT_NUMBER_DEL_AUTO = Integer.valueOf(CH_Settings__c.getValues('AttachmentNumberinEachJobAutoDelete') != null ? CH_Settings__c.getValues('AttachmentNumberinEachJobAutoDelete').SettingValue__c :'0');
	public static final string YESVALUE = 'Yes';
	public static final string ENABLECHATTACHMENTTRIGGER = 'EnableCHAttachmentTrigger';
	public static final string EMPTYSTRING= ' ';

	//NOKIASC-33684
	public static final String BAD_REQUEST = 'Bad Request';
	public static final String REQUEST_BODY = 'Request Body: ';
	public static final String RESPONSE_BODY = 'Response Body: ';
	public static final String REQUEST_URI = 'Request URI: ';
	public static final String NO_ACTION_TAKEN = 'No Action Taken';
	
	public static final String ENDPOINT = ',\nendpoint = ';
	public static final String ERROR_MESSAGE = 'Error: message = ';
	public static final String AWS4_HMAC_SHA256 = 'AWS4-HMAC-SHA256';
}