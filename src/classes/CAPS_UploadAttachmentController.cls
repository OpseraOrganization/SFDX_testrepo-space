/*************************************************************************************************
* Class Name : CAPS_UploadAttachmentController
* Created Date: 18 July 2018
* Created By : TCS
* Description: Upload attachment server side controller
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
Public class CAPS_UploadAttachmentController {
	public static List < String > allOpts1 = new List < String > ();

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
	
	/*****************************************************
	* Method Name : getselectOptions
	* Created Date: 27 June 2018
	* Created By : TCS
	* Descsription: Get picklist values
	* Parameter: sObject, string
	* Return: List < String >
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/  
	@AuraEnabled
	public static List < String > getselectOptions(sObject objObject, string fld) {
		List < String > allOpts = new list < String > ();
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
		allOpts.sort();
		allOpts1 = allOpts; 
		return allOpts;
	}
	/*****************************************************
* Method Name : saveChunk
* Created Date: 27 June 2018
* Created By : TCS
* Descsription: Perform Rest API callouts
* Parameter: 
* Return: CAPS_UploadResponseWrapper
* Last Modified by: 
* Last Modified Date: 
* Description: 
*******************************************/ 
	@AuraEnabled
	public static CAPS_UploadResponseWrapper saveChunk(Id caseRecordId, Boolean customervisible, String fileName, String base64Data, String contentType,
													   String fileId,String desfield,String classfield, Decimal fileSize, Double partNumber, Boolean isLastChunk, String wrapperFromJs) 
	{	
		CAPS_UploadResponseWrapper wrapperDeserialized = (CAPS_UploadResponseWrapper)JSON.deserialize(wrapperFromJs, CAPS_UploadResponseWrapper.class);
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
		Attachment oAttachment = new Attachment();
		oAttachment.Body = EncodingUtil.base64Decode(base64Data);
		oAttachment.Name = fileName;
		oAttachment.ContentType = contentType;
		String ServiceName;
		String classificationId;
		if(classfield == 'Service Provider End User Information'){
			classificationId ='1'; 
		}else if(classfield == 'Other Sensitive Information'){
			classificationId ='3'; 
		}else if(classfield == 'Other Information'){
			classificationId ='4'; 
		}
		CAPS_UploadResponseWrapper wrapper =  new CAPS_UploadResponseWrapper();
		CAPS_UploadAttachmentRESTHelper acc= new CAPS_UploadAttachmentRESTHelper();
		wrapper=acc.Upload(caseRecordId,customervisible,oAttachment.Body,oAttachment.Name,oAttachment.ContentType,classificationId,desfield,oAttachment.Name,filesize,partNumber, isLastChunk, wrapperDeserialized);
		if(isLastChunk){
			String attachvalue = wrapper.attachmentId;
			getCHattachmentdata(caseRecordId, customervisible, fileName, desfield,fileSize,classfield,attachvalue);
		}
		return wrapper;
	}
	/*****************************************************
* Method Name : getCHattachmentdata
* Created Date: 27 June 2018
* Created By : TCS
* Descsription: Create CH_Attachment__c records
* Parameter: 
* Return: None
* Last Modified by: 
* Last Modified Date: 
* Description: 
*******************************************/ 
	@AuraEnabled
	Public static void getCHattachmentdata(Id caseRecordId, Boolean customervisible, String fileName,String desfield,Decimal fileSize,String classfield,String attachvalue){
		List<CH_Attachment__c> listattach =new List<CH_Attachment__c>();
			CH_Attachment__c chattch = new CH_Attachment__c();
			chattch.Name = fileName;
			chattch.CH_Size__c = fileSize;
			chattch.CH_Description__c = desfield;
			chattch.CH_Puropse__c = 'Case Handling';
			chattch.CH_Service_Class__c = 'CARE';
			chattch.CH_Classification__c = classfield;
			chattch.Case__c = caseRecordId;
			chattch.CH_Status__c = 'Uploading';
			chattch.AttachmentID__c = attachvalue;
			chattch.Customer_Visible__c = customervisible;
			chattch.CH_Uploaded__c = system.now();
			chattch.CH_Portal_or_Email_to_Case__c ='Salesforce';
		if(classfield == CAPS_ConstantHandler.OtherInformation){
			chattch.File_Name__c = fileName +'.encrypted.zip';
			chattch.CH_FileType__c ='Encrypted';
			insert chattch;
		} else if(classfield ==CAPS_ConstantHandler.othersensitiveinformation || classfield ==CAPS_ConstantHandler.ServiceProviderEndUserInformation){
			/*Adding scrambled attachment*/ 
			chattch.File_Name__c = fileName +'.scrambled.zip';
			chattch.CH_FileType__c ='Scrambled'; 
			listattach.add(chattch); 
		   /*Adding Encrypted attachment*/ 
			CH_Attachment__c chattch1 = new CH_Attachment__c();
			chattch1.Name = fileName;
			chattch1.File_Name__c = fileName +'.txt.encrypted.zip';
			chattch1.CH_Size__c = fileSize;
			chattch1.CH_Description__c = desfield;
			chattch1.CH_Puropse__c = 'Case Handling';
			chattch1.CH_Service_Class__c = 'CARE';
			chattch1.CH_Classification__c = classfield;
			chattch1.Case__c = caseRecordId;
			chattch1.CH_Status__c = 'Uploading';
			chattch1.AttachmentID__c = attachvalue;
			chattch1.Customer_Visible__c = customervisible;
			chattch1.CH_Uploaded__c = system.now();
			chattch1.CH_FileType__c ='Encrypted'; 
			chattch1.CH_Portal_or_Email_to_Case__c ='Salesforce';
			listattach.add(chattch1); 
			insert listattach;
		}
		
	}
}