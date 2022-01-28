/*******************************
Class Name: CCRE_ContentDocumentLinkTriggerHandler
Created by: Accenture
Created Date: 24th Nov 2017
Last modified by: Accenture
Description: This class will handle the logic implemented on CCRE_ContentDocumentLinkTrigger
*******************************/
public with sharing class CCRE_ContentDocumentLinkTriggerHandler{
	
 /*****************************
 *Method Name:afterInsert
 *Description: 
 *Parameters:
 *Test coverage from: 
 *******************************/
	public static void afterInsert(List<ContentDocumentLink> contentDoclist){
		try{
		List<ContentDocumentLink> DocLinkToShare = new List<ContentDocumentLink>();
		List<ContentDocumentLink> DocLinkToRestrictUpload = new List<ContentDocumentLink>();
		for(ContentDocumentLink cdl : contentDoclist){
			   if((cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_DP))||(cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_Quotes))||(cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.supportingMaterialObj))||(cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.accObj))){
						
						DocLinkToShare.add(cdl);
				}
		 }
		 if(!DocLinkToShare.isEmpty()){
			 CCRE_ContentDocumentLinkTriggerHelper.shareDocument(DocLinkToShare); 
		 }
	 
		for(ContentDocumentLink cdl : contentDoclist){
			   if((cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_DP))||(cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(CSWXGlobalConstant.OBJECT_Quotes))){
							
					DocLinkToRestrictUpload.add(cdl);
				}
		 }
		 
		  if(!DocLinkToRestrictUpload.isEmpty()){
			 CCRE_ContentDocumentLinkTriggerHelper.restrictUpload(DocLinkToRestrictUpload); 
		 }
		
	}
		catch(System.Exception e){
		   // ExceptionHandler.addException(e,CSWXGlobalConstant.CCRE_ContentDocumentLinkTriggerHandler,GlobalConstants.AFTER_INSERT);
   }
  }

}