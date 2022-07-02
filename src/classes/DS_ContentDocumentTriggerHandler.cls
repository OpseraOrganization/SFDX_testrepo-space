/*******************************
Class Name: DS_ContentDocumentTriggerHandler
Created by: Accenture
Created Date: 24th Nov 2017
Last modified by: Accenture
Description: This class will handle the logic implemented on CCRE_ContentDocumentLinkTrigger
*******************************/
public with sharing class DS_ContentDocumentTriggerHandler{
 /*****************************
 *Method Name:beforeDelete
 *Description: used to call helper method to restrict deletion of file on Before Delete
 *Parameters:contentDoclist
 *Test coverage from: 
 *******************************/
	  public static void beforeDelete(List<ContentDocument> contentDoclist){
		DS_ContentDocumentTriggerHelper.restrictDelete(contentDoclist); 
	}

 }