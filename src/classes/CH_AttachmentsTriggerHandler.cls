/****************************************
* Class Name : CH_AttachmentsTriggerHandler
* Created Date : 08-Aug-2018
* Author : TCS  
* Description : Calling CAPS API
* Last Modified Date : 18-Sep-2020
* Last Modified by : Chiraag Jain
*****************************************/
public without sharing class CH_AttachmentsTriggerHandler {
	/********************
	* Method Name : updateAttchmentinCAPS
	* Created Date : 08-Aug-2018
	* Author : TCS
	* Parameter : New CH_Attachment List, Old CH_Attachment Map
	* Description : Calling CAPS API
	* Return : None
	* Last Modified by :
	* Last Modified Date : 
	* Last Modified : 
	*********************/  
	public static void updateAttchmentinCAPS(List<CH_Attachment__C> chAttachmentList,Map<Id, CH_Attachment__C> chAttachmentOldMap){
		try{  
			Map<String,Map<String,String>> attachIdVsMapOfUpdateFieldsMap = new Map<String,Map<String,String>>();
			Integer combinedListSize = 0;
			Integer calloutLimit = CAPS_ConstantHandler.CALLOUTLIMITCHATTACHMENTTRIGGER;
			Set<String> attachmentIdSet= new Set<String>();
			Map<String,String> cAPSVParamVsValuesMap;
			Map<String,Boolean> attahmentIdVsToBeDeletedMap = new Map<String,Boolean>();
			Map<String,String> attachmentidvsdate =new Map<String,String>();
			for(CH_Attachment__C chattachObj : chAttachmentList){
	if(!String.isBlank(chattachObj.AttachmentID__c) && !attachmentIdSet.contains(chattachObj.AttachmentID__c)){
		cAPSVParamVsValuesMap = new Map<String,String>();
	
		if(!String.isBlank(chattachObj.CH_Description__c) && 
		(chattachObj.CH_Description__c  != chAttachmentOldMap.get(chattachObj.Id).CH_Description__c))
		{
			attachmentIdSet.add(chattachObj.AttachmentID__c);
			cAPSVParamVsValuesMap.put(CAPS_ConstantHandler.DESCRIPTION, chattachObj.CH_Description__c);
		}
	
		if(!cAPSVParamVsValuesMap.isEmpty()){
			attachIdVsMapOfUpdateFieldsMap.put(chattachObj.AttachmentID__c, cAPSVParamVsValuesMap);
			combinedListSize++;
		}
	}
	//call out will be happening inside for loop as CAPS system is seeking attachment id as end point and in signature. 
	//Check if CAPS can handle bulk update from API in single transaction, 
	//else to avoid exception of 100 limit in http call out, add one counter below and take max 99 in below two sets.
	// As per confirmation, need to call out inside loop i.e. invoke API for each attachment.
	if(combinedListSize > calloutLimit){// break from loop if list has more than call out limit in single transaction
			break;
	}
			} 
			if(!attachIdVsMapOfUpdateFieldsMap.isEmpty()){
	CAPS_Attachment_Delete.updateAllFieldsforTrigger(JSON.serialize(attahmentIdVsToBeDeletedMap),JSON.serialize(attachIdVsMapOfUpdateFieldsMap),JSON.serialize(attachmentidvsdate)); 
			}
		}  
		catch(Exception ex){ExceptionHandler.addException(ex,CAPS_ConstantHandler.cHAttachmentsTriggerHandler,CAPS_ConstantHandler.updateAttchmentinCAPS);}
	}
	
	/********************
	* Method Name : sendAttachmentIdForReadyStatus
	* Created Date : 26-Aug-2019
	* Author : Raj Dubey
	* Parameter : New CH_Attachment List, Old CH_Attachment Map
	* Description : Callout to NAIP for sending attahcment Id for Attachment with ready status
	* Return : None
	*********************/  
	public static void sendAttachmentIdForReadyStatus(List<CH_Attachment__C> chAttachmentList,Map<Id, CH_Attachment__C> chAttachmentOldMap) {
		Boolean sendToNAIPOrNot = false;
		String sendAttachmentToNAIP = CH_Settings__c.getValues('SendAttachmentToNAIP') != null ? CH_Settings__c.getValues('SendAttachmentToNAIP').SettingValue__c :'';
		if('Yes'.equalsIgnoreCase(sendAttachmentToNAIP)){
			sendToNAIPOrNot = true;
		}
	  
		for (CH_Attachment__C att : [SELECT Id, File_Name__c, CH_Description__c, AttachmentID__c,Customer_Visible__c,CH_Status__c, CH_Size__c, CH_FileType__c, Case__r.Origin, Case__r.CH_CaseOriginSystem__c, Case__r.CaseNumber, Case__r.Reference_Number__c FROM CH_Attachment__C WHERE Id IN :chAttachmentOldMap.keySet() AND CH_Portal_or_Email_to_Case__c = 'Salesforce']) {	
			if (att.CH_Status__c == 'Ready' && att.Customer_Visible__c && sendToNAIPOrNot && chAttachmentOldMap.get(att.Id).get('CH_Status__c') != att.CH_Status__c && att.Case__r.Origin == 'S2S' && (att.Case__r.CH_CaseOriginSystem__c == 'tmobile-tim' && att.CH_Size__c <= 5120000 || att.Case__r.CH_CaseOriginSystem__c != 'tmobile-tim')) {	
				CH_ExternalInterfaceUTIL.sendAttachmentId (att.Case__c, att.Case__r.CaseNumber, att.Case__r.CH_CaseOriginSystem__c, att.Case__r.Reference_Number__c, att.File_Name__c, att.AttachmentID__c, att.CH_Description__c, att.CH_Size__c, att.CH_FileType__c);
			}
		}
	 
	}
	public static void addAttachmentComment(List<CH_Attachment__c> oAttachmentList){
		List<CaseComment> oCaseCommentList = new List<CaseComment>();
		for(CH_Attachment__c oAttachment : oAttachmentList){
			
			if(oAttachment.Customer_Visible__c)  //DEM0050458: For customer hidden attachments comments should not be public
			{
	oCaseCommentList.add(new CaseComment(ParentId = oAttachment.Case__c, CommentBody='CAPS '+oAttachment.Name+': '+oAttachment.CH_Description__c, IsPublished=true));
			}
			else{
	oCaseCommentList.add(new CaseComment(ParentId = oAttachment.Case__c, CommentBody='CAPS '+oAttachment.Name+': '+oAttachment.CH_Description__c, IsPublished=false));

			}
		}
		if(!oCaseCommentList.isEmpty()){
			insert oCaseCommentList;
		}
	}
}