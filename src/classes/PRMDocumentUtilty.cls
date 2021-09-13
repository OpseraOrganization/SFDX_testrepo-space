/**
* @description: Trigger helper to perform Validation and functions before and after Lead conversion
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0				   26/12/2016   Sprint 4 PRM
* ============================================================================ 
*/
public with sharing class PRMDocumentUtilty {
/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: lead leadInstance
* Return: None
* Description: Insert ContentDocumentLink records
* High Level Process : 
**********************************************************************************************************************/
	public static void shareFileOnLeadConvert(lead leadInstance){
		List<ContentDocumentLink> listToInsert = new List<ContentDocumentLink>();  
		list<ContentDocumentLink> contentDocumentList = new list<ContentDocumentLink>();
		try
		{
			system.debug('IN PRM Doc Utility>>');
			contentDocumentList = [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType,Visibility FROM ContentDocumentLink WHERE LinkedEntityId =: leadInstance.Id];
			if(!contentDocumentList.IsEmpty()){
				for(ContentDocumentLink contentDocLink : contentDocumentList){
					ContentDocumentLink contentDocumentLink = getNewContentDocumentLink();
					contentDocumentLink.LinkedEntityId = leadInstance.convertedOpportunityId;
					contentDocumentLink.ContentDocumentId = contentDocLink.contentDocumentId;
					contentDocumentLink.Visibility = PRMGlobalConstants.ALL_USERS;
					contentDocumentLink.ShareType = PRMGlobalConstants.FILE_SHARE_TYPE_V;
					listToInsert.add(contentDocumentLink);
				}
			}
			System.debug('listToInsert PRM : '+listToInsert);
			if(!listToInsert.isEmpty())
			{
				Database.SaveResult[] savedResults = Database.insert(listToInsert, false);
				Boolean someFailure = false;
				for (Database.SaveResult sr : savedResults) 
				{
					if (!sr.isSuccess())
					{
						someFailure = true;
						for(Database.Error err : sr.getErrors()) 
						{
							System.debug('The following error has occurred : ');					
							System.debug(err.getStatusCode() + ' : ' + err.getMessage());
							System.debug('ContentDocumentLink fields that affected this error : ' + err.getFields());
						}
					}				   
				}
				if(!someFailure)
				{
					System.debug('All ContentDocumentLink records inserted successfully PRM'); 
				}
			}
			else
			{
				System.debug('<< No ContentDocumentLink records to insert >>');
			}
		}catch(Exception ex) {
			String Error = PRMGlobalConstants.GENERIC_EXCEPTION;
			System.debug(Error+' --> '+ex.getLineNumber()+'::'+ex.getCause());
			System.debug(ex.getMessage());
			System.debug(ex.getCause());
		}
	}
	public static void restrictFileUpload(List<ContentDocumentLink> contentDocLinkList){
		Map<id,List<ContentDocumentLink>> mapLeadContentDoclink = new Map<id,List<ContentDocumentLink>> ();
		Map<id,List<ContentDocumentLink>> mapOpptyContentDoclink = new Map<id,List<ContentDocumentLink>> ();
		set<id> leadId = new set<id>();
		set<id> opptyId = new set<id>();
		List<Lead> restrictedLead = new List<Lead> ();
		List<Opportunity> restrictedOppty = new List<Opportunity> ();
		
		for(ContentDocumentLink contentDocLink :contentDocLinkList){
			List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
			if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_LEAD ){
				
				if(mapLeadContentDoclink.containskey(contentDoclink.LinkedEntityId)){
					cdlList = mapLeadContentDoclink.get(contentDoclink.LinkedEntityId);
				}
				cdlList.add(contentDocLink);
				mapLeadContentDoclink.put(contentDoclink.LinkedEntityId,cdlList);
				leadId.add(contentDoclink.LinkedEntityId);
				break;
			
			
			}else if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_OPPORTUNITY  ){
				If(mapOpptyContentDoclink.containskey(contentDoclink.LinkedEntityId)){
					cdlList = mapLeadContentDoclink.get(contentDoclink.LinkedEntityId);
				}
				system.debug('contentDocLink>>>' +contentDocLink);
				if(contentDocLink == null){
					system.debug('contentDocLink >>>> is null');
				}
				cdlList.add(contentDocLink);
				system.debug('contentDocLink>>>' +contentDocLink);
				mapOpptyContentDoclink.put(contentDoclink.LinkedEntityId,cdlList);
				opptyId.add(contentDoclink.LinkedEntityId);
				break;
			}
			
		}
		if(!leadId.IsEmpty()){
			list<Lead> leadList = [SELECT Id,Status FROM Lead WHERE Id IN : leadId];
			for(lead ld : leadList){
				if(ld.Status == 'Approved'){
					restrictedLead.add(ld);
				}
			}
		}
		if(!opptyId.IsEmpty()){
			list<Opportunity> oppList = [SELECT Id,RecordType.Name FROM Opportunity WHERE Id IN : opptyId];
			for(Opportunity opp : oppList ){
				if(opp.RecordType.Name == 'Read Only Direct' || opp.RecordType.Name == 'Read Only Indirect' ){
					restrictedOppty.add(opp);
				}
			}
		}
		for(lead leadinstance : restrictedLead ){
			for(ContentDocumentLink conDocInstance : mapLeadContentDoclink.get(leadinstance.Id) ){
				conDocInstance.LinkedEntityId.addError('You Cannot Upload file after your Lead is approved');
			}
		}
		for(Opportunity opptyInstance : restrictedOppty ){
			for(ContentDocumentLink conDocInstance : mapOpptyContentDoclink.get(opptyInstance.Id) ){
				conDocInstance.LinkedEntityId.addError('You Cannot Upload file after your Opportunity is Closed');
			}
			
		}	   
		
		/*
		
		if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_LEAD ){
			list<Lead> leadList = [SELECT Id,Status FROM Lead WHERE Id =: contentDoclink.LinkedEntityId];
		
			if(leadList[0].Status == 'Approved'){
				contentDoclink.LinkedEntityId.addError('You Cannot Upload file after your Lead is approved');
			}
		}else if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_OPPORTUNITY  ){
			
			list<Opportunity> oppList = [SELECT Id,RecordType.Name FROM Opportunity WHERE Id =: contentDoclink.LinkedEntityId];
			if(oppList[0].RecordType.Name == 'Read Only Direct' || oppList[0].RecordType.Name == 'Read Only Indirect' ){
				contentDoclink.LinkedEntityId.addError('You Cannot Upload file after your Opportunity is Closed');
			}
			
		} */
		
	}
	public static ContentDocumentLink getNewContentDocumentLink()
	{
		return new ContentDocumentLink();
	}
	public static void restrictFileDelete(List<ContentDocumentLink> contentDocLinkList){
		Map<id,List<ContentDocumentLink>> mapLeadContentDoclink = new Map<id,List<ContentDocumentLink>> ();
		Map<id,List<ContentDocumentLink>> mapOpptyContentDoclink = new Map<id,List<ContentDocumentLink>> ();
		set<id> leadId = new set<id>();
		set<id> opptyId = new set<id>();
		List<Lead> restrictedLead = new List<Lead> ();
		List<Opportunity> restrictedOppty = new List<Opportunity> ();
		
		for(ContentDocumentLink contentDocLink :contentDocLinkList){
			List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
			if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_LEAD ){
				
				if(mapLeadContentDoclink.containskey(contentDoclink.LinkedEntityId)){
					cdlList = mapLeadContentDoclink.get(contentDoclink.LinkedEntityId);
				}
				cdlList.add(contentDocLink);
				mapLeadContentDoclink.put(contentDoclink.LinkedEntityId,cdlList);
				leadId.add(contentDoclink.LinkedEntityId);
				
				
			}else if(SchemaGlobalDescribe.findObjectNameFromRecordIdPrefix(contentDoclink.LinkedEntityId) == PRMGlobalConstants.OBJECT_OPPORTUNITY ){
				If(mapOpptyContentDoclink.containskey(contentDoclink.LinkedEntityId)){
					cdlList = mapLeadContentDoclink.get(contentDoclink.LinkedEntityId);
				}
				cdlList.add(contentDocLink);
				mapOpptyContentDoclink.put(contentDoclink.LinkedEntityId,cdlList);
				opptyId.add(contentDoclink.LinkedEntityId);
			}
			
		}
		if(!leadId.IsEmpty()){
			list<Lead> leadList = [SELECT Id,Status FROM Lead WHERE Id IN : leadId];
			for(lead ld : leadList){
				if(ld.Status == 'Approved'){
					restrictedLead.add(ld);
				}
			}
		}
		if(!opptyId.IsEmpty()){
			list<Opportunity> oppList = [SELECT Id,RecordType.Name FROM Opportunity WHERE Id IN : opptyId];
			for(Opportunity opp : oppList ){
				if(opp.RecordType.Name == 'Read Only Direct' || opp.RecordType.Name == 'Read Only Indirect' ){
					restrictedOppty.add(opp);
				}
			}
		}
		for(lead leadinstance : restrictedLead ){
			for(ContentDocumentLink conDocInstance : mapLeadContentDoclink.get(leadinstance.Id) ){
				conDocInstance.LinkedEntityId.addError('You Cannot Delete a file after your Lead is approved');
			}
		}
		for(Opportunity opptyInstance : restrictedOppty ){
			for(ContentDocumentLink conDocInstance : mapOpptyContentDoclink.get(opptyInstance.Id) ){
				conDocInstance.LinkedEntityId.addError('You Cannot Delete a file after your Opportunity is Closed');
			}
			
		}	
	}
	
}