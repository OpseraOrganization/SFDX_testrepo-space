/*********************************************************************
 * Class Name : CAPS_UploadResponseWrapper
 * Created Date: 03 August 2018
 * Created By : TCS
 * Description: Wrap initial response
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
**********************************************************************/
public class CAPS_UploadResponseWrapper{
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
	@AuraEnabled public  String uploadId{get;set;}
	@AuraEnabled public  Map<String, String> partNumVsEtagMap{get;set;}
}