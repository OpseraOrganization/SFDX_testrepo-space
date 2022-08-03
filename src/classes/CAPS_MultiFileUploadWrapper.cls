/****************************************************************
 * Class Name : CAPS_MultiFileUploadController
 * Created Date: 18 July 2018
 * Created By : TCS
 * Description: Wrapper class to send some value to lightning component and to get some value from lightning component
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
*****************************************************************/
public class CAPS_MultiFileUploadWrapper{
	@AuraEnabled public  String jsonString{get;set;}
	@AuraEnabled public  String signature{get;set;}
	@AuraEnabled public  String nowFormatted{get;set;}
	@AuraEnabled public  String signatureKey{get;set;}
	
	@AuraEnabled public  String attachmentId{get;set;}
	@AuraEnabled public  String s3keyname{get;set;}
	@AuraEnabled public  String fileid{get;set;}
	@AuraEnabled public  String signer{get;set;}
	@AuraEnabled public  String user{get;set;}
	@AuraEnabled public  String signtoken{get;set;}
	@AuraEnabled public  String expiration{get;set;}
	@AuraEnabled public  String permission{get;set;}
	@AuraEnabled public  String acl{get;set;}
	@AuraEnabled public  String aws_url{get;set;}
	@AuraEnabled public  String bucket{get;set;}
	@AuraEnabled public  String aws_key{get;set;}
	@AuraEnabled public  String baseURL{get;set;}
	@AuraEnabled public  String logApiURL{get;set;}
	@AuraEnabled public  String s3SignApiURL{get;set;}
	@AuraEnabled public  String s3_region{get;set;}
	@AuraEnabled public  String aws_signature_version{get;set;}
	@AuraEnabled public  String s3SignApiV4URL{get;set;}
	
	@AuraEnabled public  String signature1stS3Sign{get;set;}
	@AuraEnabled public  String amzdate{get;set;}
	
	@AuraEnabled public  String caseHasBeenClosed{get;set;}
}