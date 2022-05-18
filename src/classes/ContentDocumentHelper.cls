/**
* @description: HND_ContentDocumentHelper apex class. This use to extend the delete file functionality of lightning component.
*	class includes function to delete the appropriate record from Document__c object when an excisting file is deleted from file object.
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR	DATE		DETAIL			FEATURES/CSR/TTP
* 1.0	  12/09/2016   Sprint 3 Doc Stretegy & LoA requirements.
* ============================================================================ 
*/
public without sharing class ContentDocumentHelper
{
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: ContentVersion list
* Return: void
* Description://Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
//Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
//Req#4705 - PTA Signed automatically ticked
This method checks SObject type and Document type and calls related method for flag unchecking. 
* High Level Process : 
**********************************************************************************************************************/
	public static void determineObjectTypeForDelete(Map<Id,ContentDocument> contentDocOldMap)
	{
		try
		{		
			if(!contentDocOldMap.isEmpty())
			{
	String sObjectType ;
	Set<Id> contentDocIds = contentDocOldMap.keySet();
	Set<Id> offerIds = new Set<Id>();
	Set<Id> opptyIds = new Set<Id>();  
	Set<Id> salesOpptyIds = new Set<Id>();
	Set<Id> presalesOpptyIds = new Set<Id>();
	Set<String> documentTypesSSO = new Set<String>();
	Set<String> documentTypesPTA= new Set<String>();
	Set<String> documentTypesBOM = new Set<String>();		
	Map<Id,String> contentDocIdDocTypeMap = new map<Id,String>(); 
	String SSODoc ;
	String PTADoc ;
	String BOMBOQDoc ;
	
	for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c 
				from Document_Types__mdt
				where DeveloperName =: Globalconstants.SSO_Document_Types OR
				DeveloperName =: Globalconstants.PTA_Documents OR
				DeveloperName =: Globalconstants.BoMBoQ_Document 
				LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		if(docTypes.DeveloperName == Globalconstants.SSO_Document_Types)
		{
			SSODoc = docTypes.Document_Type__c;
		}
		if(docTypes.DeveloperName == Globalconstants.PTA_Documents)
		{
			PTADoc = docTypes.Document_Type__c;
		}
		if(docTypes.DeveloperName == Globalconstants.BoMBoQ_Document)
		{
			BOMBOQDoc = docTypes.Document_Type__c;
		}
	}
	
	if(String.isNotBlank(SSODoc)){
		for(String docType : SSODoc.split(GlobalConstants.COMMA))
		{
			documentTypesSSO.add(docType.trim());
		}
	}
	if(String.isNotBlank(BOMBOQDoc)){
		for(String docType : BOMBOQDoc.split(GlobalConstants.COMMA))
		{
			documentTypesBOM.add(docType.trim());
		}
	}
	if(String.isNotBlank(PTADoc)){
		for(String docType : PTADoc.split(GlobalConstants.COMMA))
		{
			documentTypesPTA.add(docType.trim());
		}
	}
	
	for(ContentVersion conVersion : [select Document_Type_POC__c,ContentDocumentId,IsLatest 
			 from ContentVersion 
			 where (ContentDocumentId in: contentDocIds
					and IsLatest = True) ALL ROWS ])
	{
		contentDocIdDocTypeMap.put(conVersion.ContentDocumentId,conVersion.Document_Type_POC__c);
	}
	
	for(ContentDocumentLink link : [Select ContentDocumentId,LinkedEntityId from ContentDocumentLink 
			where (ContentDocumentId in : contentDocIds) ALL ROWS ])
	{
		sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getName();
		if(sObjectType == GlobalConstants.OBJECT_OFFER && 
		documentTypesSSO.contains(contentDocIdDocTypeMap.get(link.ContentDocumentId)))
		{
			offerIds.add(link.LinkedEntityId);
		}
		else if(sObjectType == GlobalConstants.OBJECT_OPPORTUNITY && 
				(documentTypesBOM.contains(contentDocIdDocTypeMap.get(link.ContentDocumentId)) 
		|| documentTypesPTA.contains(contentDocIdDocTypeMap.get(link.ContentDocumentId))))
		{
			opptyIds.add(link.LinkedEntityId);
		}
	}
	
	if(!opptyIds.isEmpty()){
		for(Opportunity opptyRec : [select Id, RecordType.Name from Opportunity 
			where id in : opptyIds  
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			if(opptyRec.RecordType.Name == GlobalConstants.DIRECT_OPPTY  ||
		 opptyRec.RecordType.Name == GlobalConstants.INDIRECT_OPPTY )
			{
				salesOpptyIds.add(opptyRec.Id);
			}
			else if(opptyRec.RecordType.Name == GlobalConstants.PRESALESRISKOPPORTUNITY )
			{
				presalesOpptyIds.add(opptyRec.Id);
			}
		}
	}
	if(offerIds.size() > 0){
		checkUncheckOfferSSOFlagOnDelete(offerIds);
	} 
	if(salesOpptyIds.size() > 0){
		checkUncheckOpportunityPTAFLagOnDelete(salesOpptyIds);
	} 
	if(presalesOpptyIds.size() > 0){
		checkUncheckOpportunityBOMFlagOnDelete(presalesOpptyIds);
	} 
			}
			else
			{
	system.debug('contentDocOldMap is empty');
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.determineObjectTypeForDelete);
		}
	} 
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: ContentVersion list
* Return: void
* Description://Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
//Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
//Req#4705 - PTA Signed automatically ticked
This method checks SObject type and Document type and calls related method for flag checking. 
* High Level Process : 
**********************************************************************************************************************/
	public static void determineObjectTypeForUndelete(Map<Id,ContentDocument> contentDocNewMap)
	{
		try
		{		
			if(!contentDocNewMap.isEmpty())
			{
	String sObjectType ;
	Set<Id> contentDocIds = contentDocNewMap.keySet();
	Set<Id> offerIds = new Set<Id>();
	Set<Id> opptyIds = new Set<Id>();  
	Set<Id> salesOpptyIds = new Set<Id>();
	Set<Id> presalesOpptyIds = new Set<Id>();	
	Set<String> documentTypesSSO = new Set<String>();
	Set<String> documentTypesPTA= new Set<String>();
	Set<String> documentTypesBOM = new Set<String>();		
	Map<Id,String> contentDocIdDocTypeMap = new map<Id,String>();
	Map<Id,Id> contentDocIdToOfferIdMap = new Map<Id,Id>();
	Map<Id,Id> OfferIdToContentDocId = new Map<Id,Id>();
	Map<Id,Id> contentDocIdToOpptyIdMap = new Map<Id,Id>();
	Map<Id,Id> contentDocIdToSalesOpptyIdMap = new Map<Id,Id>();
	Map<Id,Id> contentDocIdToPresalesOpptyIdMap = new Map<Id,Id>();
	String SSODoc ;
	String PTADoc ;
	String BOMBOQDoc ;
	
	for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c 
				from Document_Types__mdt
				where DeveloperName =: Globalconstants.SSO_Document_Types OR
				DeveloperName =: Globalconstants.PTA_Documents OR
				DeveloperName =: Globalconstants.BoMBoQ_Document 
				LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		if(docTypes.DeveloperName == Globalconstants.SSO_Document_Types)
		{
			SSODoc = docTypes.Document_Type__c;
		}
		if(docTypes.DeveloperName == Globalconstants.PTA_Documents)
		{
			PTADoc = docTypes.Document_Type__c;
		}
		if(docTypes.DeveloperName == Globalconstants.BoMBoQ_Document)
		{
			BOMBOQDoc = docTypes.Document_Type__c;
		}
	}
	
	if(String.isNotBlank(SSODoc)){
		for(String docType : SSODoc.split(GlobalConstants.COMMA))
		{
			documentTypesSSO.add(docType.trim());
		}
	}
	if(String.isNotBlank(BOMBOQDoc)){
		for(String docType : BOMBOQDoc.split(GlobalConstants.COMMA))
		{
			documentTypesBOM.add(docType.trim());
		}
	}
	if(String.isNotBlank(PTADoc)){
		for(String docType : PTADoc.split(GlobalConstants.COMMA))
		{
			documentTypesPTA.add(docType.trim());
		}
	}
	
	for(ContentVersion conVersion : [select Document_Type_POC__c,ContentDocumentId,IsLatest 
			 from ContentVersion 
			 where ContentDocumentId in: contentDocIds
			 and IsLatest = True
			 ORDER BY VersionNumber desc 
			 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		contentDocIdDocTypeMap.put(conVersion.ContentDocumentId,conVersion.Document_Type_POC__c);
	}
	
	for(ContentDocumentLink link : [Select ContentDocumentId,LinkedEntityId from ContentDocumentLink 
			where ContentDocumentId in : contentDocIds LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getName();
		if(sObjectType == GlobalConstants.OBJECT_OFFER  )
		{
			OfferIdToContentDocId.put(link.LinkedEntityId,link.ContentDocumentId);
		}
		if(sObjectType == GlobalConstants.OBJECT_OFFER && 
		documentTypesSSO.contains(contentDocIdDocTypeMap.get(link.ContentDocumentId)) )
		{
			contentDocIdToOfferIdMap.put(link.ContentDocumentId,link.LinkedEntityId);
		}
		else if(sObjectType == GlobalConstants.OBJECT_OPPORTUNITY && 
				(documentTypesBOM.contains(contentDocIdDocTypeMap.get(link.ContentDocumentId)) 
		|| documentTypesPTA.contains(contentDocIdDocTypeMap.get(link.ContentDocumentId))))
		{
			contentDocIdToOpptyIdMap.put(link.LinkedEntityId,link.ContentDocumentId);
		}
	}
	
	if(!OfferIdToContentDocId.isEmpty())
	{
		for(Offer__c offr : [Select Id,ActiveOffer__c,Opportunity__r.Phase_Status__c 
				 from Offer__c 
				 where id in : OfferIdToContentDocId.keySet() and 
				 ActiveOffer__c = True and 
				 Opportunity__r.Phase_Status__c =: GlobalConstants.PENDING_WIN_LOSS_DECLARATION
				 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			system.debug('undelete not possible');
			if(contentDocNewMap.containsKey(OfferIdToContentDocId.get(offr.Id))){
				contentDocNewMap.get(OfferIdToContentDocId.get(offr.Id)).addError(System.Label.Restrict_Offer_Doc_Undelete);
				contentDocIdToOfferIdMap.remove(OfferIdToContentDocId.get(offr.Id));
			}
		}
	}
	
	if(!contentDocIdToOpptyIdMap.isEmpty()){
		for(Opportunity opptyRec : [select Id, RecordType.Name from Opportunity 
			where id in : contentDocIdToOpptyIdMap.keySet()  
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			if(opptyRec.RecordType.Name == GlobalConstants.DIRECT_OPPTY  ||
		 opptyRec.RecordType.Name == GlobalConstants.INDIRECT_OPPTY )
			{
				contentDocIdToSalesOpptyIdMap.put(contentDocIdToOpptyIdMap.get(opptyRec.Id),opptyRec.Id);
			}
			else if(opptyRec.RecordType.Name == GlobalConstants.PRESALESRISKOPPORTUNITY )
			{
				contentDocIdToPresalesOpptyIdMap.put(contentDocIdToOpptyIdMap.get(opptyRec.Id),opptyRec.Id);
			}
		}
	}
	if(!contentDocIdToOfferIdMap.isEmpty()){
		checkUncheckOfferSSOFlagOnUndelete(contentDocIdToOfferIdMap);
	} 
	if(!contentDocIdToSalesOpptyIdMap.isEmpty()){
		checkUncheckOpportunityPTAFlagOnUndelete(contentDocIdToSalesOpptyIdMap);
	} 
	if(!contentDocIdToPresalesOpptyIdMap.isEmpty()){
		checkUncheckOpportunityBOMFlagOnUndelete(contentDocIdToPresalesOpptyIdMap);
	} 
			}
			else
			{
	system.debug('contentDocNewMap is empty');
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.determineObjectTypeForUndelete);
		}
	} 
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: contentDocumentOldMap
* Return: void
* Description: Updates Opportunity fields when Excel-AddIn updates Offer fields
//Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
Unchecking SSO flag when SSO Document is deleted on Offer.
* High Level Process : 
**********************************************************************************************************************/
	public static void checkUncheckOfferSSOFlagOnDelete(Set<Id> offerIdSet)
	{
		try
		{		
			String documentTypesSSO = Null ;			
			for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c 
			from Document_Types__mdt
			where DeveloperName =: Globalconstants.SSO_Document_Types
			and Object__c =: GlobalConstants.OBJECT_OFFER
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
	if(docTypes.DeveloperName == Globalconstants.SSO_Document_Types)
	{
		documentTypesSSO = docTypes.Document_Type__c;
	}
			}	
			
			if(String.isNotBlank(documentTypesSSO))
			{
	Offer__c offr = Null;
	String sObjectType = Null;
	Set<String> documentTypes = new Set<String>();
	Set<Id> contentDocIdSet = Null;
	Map<Id,Set<Id>> offerIdtoContentDocIdMap = new Map<Id,Set<Id>>();
	Map<Id,Id> contentDocIdToOfferIdMap = new map<Id,Id>();	
	List<Offer__c> offersToUpdate = new List<Offer__c>(); 
	Map<Id,Offer__c> offerMap = Null;
	Double totalNetSalesValue = Double.valueOf(System.Label.Total_Net_Sales_Value_EUR_Threshold);
	
	for(String docType : documentTypesSSO.split(GlobalConstants.COMMA))
	{
		documentTypes.add(docType.trim());
	}
	
	if(offerIdSet.size()>0)
	{	
		for(ContentDocumentLink link : [Select ContentDocumentId,LinkedEntityId 
				from ContentDocumentLink 
				where LinkedEntityId in : offerIdSet 
				LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			contentDocIdToOfferIdMap.put(link.ContentDocumentId, link.LinkedEntityId);
		}
		if(!contentDocIdToOfferIdMap.isEmpty()){
			for(ContentVersion conVersion : [select Document_Type_POC__c,ContentDocumentId,IsLatest 
					 from ContentVersion 
					 where ContentDocumentId in: contentDocIdToOfferIdMap.keySet() 
					 and Document_Type_POC__c in : documentTypes and IsLatest = True
					 ORDER BY VersionNumber desc 
					 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
				if(offerIdtoContentDocIdMap.containsKey(contentDocIdToOfferIdMap.get(conVersion.ContentDocumentId))) {
		contentDocIdSet = new Set<Id>();
		contentDocIdSet = offerIdtoContentDocIdMap.get(contentDocIdToOfferIdMap.get(conVersion.ContentDocumentId));
		contentDocIdSet.add(conVersion.ContentDocumentId);
		offerIdtoContentDocIdMap.put(contentDocIdToOfferIdMap.get(conVersion.ContentDocumentId), contentDocIdSet);
				} else{
		contentDocIdSet = new Set<Id>();
		contentDocIdSet.add(conVersion.ContentDocumentId);
		offerIdtoContentDocIdMap.put(contentDocIdToOfferIdMap.get(conVersion.ContentDocumentId), contentDocIdSet);
				} 
			}
		}
		
		offerMap = new Map<Id,Offer__c>([select Id,Opportunity__r.Unweighted_Amount_EUR__c 
					 from Offer__c
					 where id in: offerIdSet
					 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
		
		if(offerIdtoContentDocIdMap.isEmpty() )
		{			
			for(Id offerObjId : offerIdSet)
			{
				offr = new Offer__c(Id = offerObjId);
				if(offerMap.get(offerObjId).Opportunity__r.Unweighted_Amount_EUR__c >= totalNetSalesValue)
				{
		offr.Solution_Sign_Off_New__c = GlobalConstants.Required;
		offr.SSO_Exception_Reason__c = GlobalConstants.BLANK_VALUE ;
				}else{
		offr.Solution_Sign_Off_New__c = GlobalConstants.Not_Required;
		offr.SSO_Exception_Reason__c = GlobalConstants.ExceptionReasonDefaultValue;
				}
				offersToUpdate.add(offr);
			}
		}else {
			for(Id offerObjId : offerIdSet)
			{
				if((offerIdtoContentDocIdMap.containsKey(offerObjId) && 
		offerIdtoContentDocIdMap.get(offerObjId).size() == 0) ||
		  !offerIdtoContentDocIdMap.containsKey(offerObjId))
				{
		offr = new Offer__c(Id = offerObjId);
		if(offerMap.get(offerObjId).Opportunity__r.Unweighted_Amount_EUR__c >= totalNetSalesValue)
		{
			offr.Solution_Sign_Off_New__c = GlobalConstants.Required;
			offr.SSO_Exception_Reason__c = GlobalConstants.BLANK_VALUE ;
		}else{
			offr.Solution_Sign_Off_New__c = GlobalConstants.Not_Required;
			offr.SSO_Exception_Reason__c = GlobalConstants.ExceptionReasonDefaultValue;
		}
		offersToUpdate.add(offr);
				}
			}
		}			
	if(!offersToUpdate.isEmpty() && offersToUpdate.size()>0)
	{
		ID jobID = System.enqueueJob(new UpdateSObjectFlags(offersToUpdate));  
	}
	else
	{
		system.debug(GlobalConstants.NOTHINGTOUPDATEONDELETE);
	}
			}
		}
		else{
			system.debug(Globalconstants.SSO_DocumentType);
		}
	}
	catch(Exception ex)
	{
		ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.checkUncheckOfferSSOFlagOnDelete);
	}
}

/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: None
* Return: void
* Description: Updates Opportunity fields when Excel-AddIn updates Offer fields
//Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
checking SSO flag when SSO Document is Undeleted on Offer.
* High Level Process : 
**********************************************************************************************************************/
public static void checkUncheckOfferSSOFlagOnUndelete(Map<Id, Id> contentDocIdToOfferIdMap)
{
	try
	{	  
		String documentTypesSSO = Null;	
		for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c 
					from Document_Types__mdt
					where DeveloperName =: Globalconstants.SSO_Document_Types
					and Object__c =: GlobalConstants.OBJECT_OFFER
					LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			if(docTypes.DeveloperName == Globalconstants.SSO_Document_Types)
			{
	documentTypesSSO = docTypes.Document_Type__c;
			}
		}
		if(String.isNotBlank(documentTypesSSO))
		{
			Offer__c offr = Null;
			Set<String> documentTypes = new Set<String>();
			Set<Id> contentDocIdSet = new Set<Id>();	
			List<Offer__c> offersToUpdate = new List<Offer__c>();		
			
			for(String docType : documentTypesSSO.split(GlobalConstants.COMMA))
			{
	documentTypes.add(docType.trim());
			}
			
			if(!contentDocIdToOfferIdMap.isEmpty())
			{
	for(ContentVersion conVersion : [select Document_Type_POC__c,ContentDocumentId ,IsLatest
			 from ContentVersion 
			 where ContentDocumentId in: contentDocIdToOfferIdMap.keySet() 
			 and Document_Type_POC__c in: documentTypes and IsLatest = True
			 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		contentDocIdSet.add(conVersion.ContentDocumentId);
	}
	
	if(!contentDocIdSet.isEmpty())
	{
		for(Id contentDocId : contentDocIdSet)
		{
			if(!String.isBlank(contentDocIdToOfferIdMap.get(contentDocId)))
			{
				offr = new Offer__c(Id = contentDocIdToOfferIdMap.get(contentDocId));
				offr.Solution_Sign_Off_New__c = GlobalConstants.Required_Attached ;
				offr.SSO_Exception_Reason__c = GlobalConstants.BLANK_VALUE ;
				offersToUpdate.add(offr);
			}
		}
	}
	if(!offersToUpdate.isEmpty() && offersToUpdate.size()>0)
	{
		ID jobID = System.enqueueJob(new UpdateSObjectFlags(offersToUpdate));  
	}
	else
	{
		system.debug(GlobalConstants.NOTHINGTOUPDATEONUNDELETE);
	}
			}
		}
		else{
			system.debug(Globalconstants.SSO_DocumentType);
		}
	}
	catch(Exception ex)
	{
		ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.checkUncheckOfferSSOFlagOnUndelete);
	}
}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: contentDocumentOldMap
* Return: void
* Description: Updates Opportunity fields when Excel-AddIn updates Offer fields
Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
Unchecking BOM/BOQ flag when BOM Document is deleted on Opportunity.
* High Level Process : 
**********************************************************************************************************************/
	public static void  checkUncheckOpportunityBOMFlagOnDelete(Set<Id> presalesOpptyIdSet)
	{
		try
		{		
			String documentTypesBOMBOQ ;	
			for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c 
			from Document_Types__mdt
			where DeveloperName =: Globalconstants.BoMBoQ_Document
			and Object__c =: GlobalConstants.OBJECT_OPPORTUNITY
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
	if(docTypes.DeveloperName == Globalconstants.BoMBoQ_Document)
	{
		documentTypesBOMBOQ = docTypes.Document_Type__c;
	}
			}			
			if( String.isNotBlank(documentTypesBOMBOQ))
			{
	Opportunity oppty ;
	Set<String> documentTypes = new Set<String>();
	Set<Id> contentDocIdSet ;
	Map<Id,Set<Id>> opptyIdtoContentDocIdMap = new Map<Id,Set<Id>>();
	Map<Id,Id> contentDocIdToOpptyIdMap = new map<Id,Id>();	
	List<Opportunity> opptyToUpdate = new List<Opportunity>();		  
	
	for(String docType : documentTypesBOMBOQ.split(GlobalConstants.COMMA))
	{
		documentTypes.add(docType.trim());
	}
	
	for(ContentDocumentLink link : [Select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId in : presalesOpptyIdSet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		contentDocIdToOpptyIdMap.put(link.ContentDocumentId, link.LinkedEntityId);
	}
	
	if(!contentDocIdToOpptyIdMap.isEmpty())
	{
		for(ContentVersion conVersion : [select Document_Type_POC__c,ContentDocumentId,IsLatest 
				 from ContentVersion 
				 where ContentDocumentId in: contentDocIdToOpptyIdMap.keySet() 
				 and Document_Type_POC__c in : documentTypes and IsLatest = True
				 ORDER BY VersionNumber desc 
				 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			if(opptyIdtoContentDocIdMap.containsKey(contentDocIdToOpptyIdMap.get(conVersion.ContentDocumentId))) 
			{
				contentDocIdSet = new Set<Id>();
				contentDocIdSet = opptyIdtoContentDocIdMap.get(contentDocIdToOpptyIdMap.get(conVersion.ContentDocumentId));
				contentDocIdSet.add(conVersion.ContentDocumentId);
				opptyIdtoContentDocIdMap.put(contentDocIdToOpptyIdMap.get(conVersion.ContentDocumentId), contentDocIdSet);
			} else{
				contentDocIdSet = new Set<Id>();
				contentDocIdSet.add(conVersion.ContentDocumentId);
				opptyIdtoContentDocIdMap.put(contentDocIdToOpptyIdMap.get(conVersion.ContentDocumentId), contentDocIdSet);
			} 
		}
	}
	
	if(opptyIdtoContentDocIdMap.isEmpty() )
	{
		for(Id opptyObjId : presalesOpptyIdSet)
		{
			oppty = new Opportunity(Id = opptyObjId);
			oppty.PSR_is_BOM_BOQ_document_attached__c = false;
			opptyToUpdate.add(oppty);
		}
	}else {
		for(Id opptyObjId : presalesOpptyIdSet)
		{
			if((opptyIdtoContentDocIdMap.containsKey(opptyObjId) && 
				opptyIdtoContentDocIdMap.get(opptyObjId).size() == 0) ||
		 !opptyIdtoContentDocIdMap.containsKey(opptyObjId))
			{
				oppty = new Opportunity(Id = opptyObjId);
				oppty.PSR_is_BOM_BOQ_document_attached__c = false;
				opptyToUpdate.add(oppty);
			}
		}			
	}
	
	if(!opptyToUpdate.isEmpty() && opptyToUpdate.size()>0)
	{
		ID jobID = System.enqueueJob(new UpdateSObjectFlags(opptyToUpdate));  
	}
	else
	{
		system.debug(GlobalConstants.NOTHINGTOUPDATEONDELETE);
	}
	
			}
			else{
	system.debug(Globalconstants.BoMBoQDocument);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.updateOpportunityBOMOnDelete);
		}
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: None
* Return: void
* Description: Updates Opportunity fields when Excel-AddIn updates Offer fields
Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
checking BOM/BOQ flag when BOM Document is Undeleted on Opportunity.
* High Level Process : 
**********************************************************************************************************************/
	public static void  checkUncheckOpportunityBOMFlagOnUndelete(Map<Id, Id> contentDocIdToPresalesOpptyIdMap)
	{
		try
		{	 
			String documentTypesBOMBOQ ;	
			for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c 
			from Document_Types__mdt
			where DeveloperName =: Globalconstants.BoMBoQ_Document
			and Object__c =: GlobalConstants.OBJECT_OPPORTUNITY
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
	if(docTypes.DeveloperName == Globalconstants.BoMBoQ_Document)
	{
		documentTypesBOMBOQ = docTypes.Document_Type__c;
	}
			}
			if(String.isNotBlank(documentTypesBOMBOQ))
			{
	Opportunity oppty ;
	Set<String> documentTypes = new Set<String>();
	Set<Id> contentDocIdSet = new Set<Id>();	  
	List<Opportunity> opptyToUpdate = new List<Opportunity>();		
	
	for(String docType : documentTypesBOMBOQ.split(GlobalConstants.COMMA))
	{
		documentTypes.add(docType.trim());
	}
	
	if(!contentDocIdToPresalesOpptyIdMap.isEmpty())
	{
		for(ContentVersion conVersion : [select Document_Type_POC__c,ContentDocumentId from ContentVersion 
				 where ContentDocumentId in: contentDocIdToPresalesOpptyIdMap.keySet() and
				 Document_Type_POC__c in: documentTypes and IsLatest = True
				 ORDER BY VersionNumber desc 
				 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			contentDocIdSet.add(conVersion.ContentDocumentId);
		}		
		if(!contentDocIdSet.isEmpty())
		{
			for(Id contentDocId : contentDocIdSet)
			{
				system.debug('');
				if(!String.isBlank(contentDocIdToPresalesOpptyIdMap.get(contentDocId)))
				{
		oppty = new Opportunity(Id = contentDocIdToPresalesOpptyIdMap.get(contentDocId));
		oppty.PSR_is_BOM_BOQ_document_attached__c = True;
		opptyToUpdate.add(oppty);
				}
			}
		}
		if(!opptyToUpdate.isEmpty() && opptyToUpdate.size()>0)
		{
			ID jobID = System.enqueueJob(new UpdateSObjectFlags(opptyToUpdate));  
		}
		else
		{
			system.debug(GlobalConstants.NOTHINGTOUPDATEONUNDELETE);
		}
	}
	
			}
			else{
	system.debug(Globalconstants.BoMBoQDocument);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.updateOpportunityBOMOnUndelete);
		}
	}
	
	
	
	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: contentDocumentOldMap
* Return: void
* Description: Updates Opportunity fields when Excel-AddIn updates Offer fields
//Req#4705 - PTA Signed automatically ticked
Unchecking PTA flag when PTA Document is deleted on Opportunity.
* High Level Process : 
**********************************************************************************************************************/
	public static void checkUncheckOpportunityPTAFLagOnDelete(Set<Id> salesOpptyIdSet)
	{
		try
		{	 
			String documentTypesPTA ;
			
			for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c 
			from Document_Types__mdt
			where DeveloperName =: Globalconstants.PTA_Documents
			and Object__c =: GlobalConstants.OBJECT_OPPORTUNITY
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
	if(docTypes.DeveloperName == Globalconstants.PTA_Documents)
	{
		documentTypesPTA = docTypes.Document_Type__c;
	}
			}
			if( String.isNotBlank(documentTypesPTA))
			{
	Opportunity oppty ;
	String sObjectType ;
	Set<String> documentTypes = new Set<String>();
	Set<Id> contentDocIdSet ;
	Map<Id,Set<Id>> opptyIdtoContentDocIdMap = new Map<Id,Set<Id>>();
	Map<Id,Id> contentDocIdToOpptyIdMap = new map<Id,Id>();	
	List<Opportunity> opptyToUpdate = new List<Opportunity>();		  
	
	for(String docType : documentTypesPTA.split(GlobalConstants.COMMA))
	{
		documentTypes.add(docType.trim());
	}
	
	for(ContentDocumentLink link : [Select ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId in : salesOpptyIdSet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		contentDocIdToOpptyIdMap.put(link.ContentDocumentId, link.LinkedEntityId);
	}
	
	if(!contentDocIdToOpptyIdMap.isEmpty())
	{
		for(ContentVersion conVersion : [select Document_Type_POC__c,ContentDocumentId,IsLatest 
				 from ContentVersion 
				 where ContentDocumentId in: contentDocIdToOpptyIdMap.keySet() 
				 and Document_Type_POC__c in : documentTypes and IsLatest = True
				 ORDER BY VersionNumber desc 
				 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			if(opptyIdtoContentDocIdMap.containsKey(contentDocIdToOpptyIdMap.get(conVersion.ContentDocumentId))) 
			{
				contentDocIdSet = new Set<Id>();
				contentDocIdSet = opptyIdtoContentDocIdMap.get(contentDocIdToOpptyIdMap.get(conVersion.ContentDocumentId));
				contentDocIdSet.add(conVersion.ContentDocumentId);
				opptyIdtoContentDocIdMap.put(contentDocIdToOpptyIdMap.get(conVersion.ContentDocumentId), contentDocIdSet);
			} else{
				contentDocIdSet = new Set<Id>();
				contentDocIdSet.add(conVersion.ContentDocumentId);
				opptyIdtoContentDocIdMap.put(contentDocIdToOpptyIdMap.get(conVersion.ContentDocumentId), contentDocIdSet);
			} 
		}
	}	
	if(opptyIdtoContentDocIdMap.isEmpty() )
	{
		for(Id opptyObjId : salesOpptyIdSet)
		{
			oppty = new Opportunity(Id = opptyObjId);
			oppty.PTA_Signed__c = false;
			opptyToUpdate.add(oppty);
		}
	}else {
		for(Id opptyObjId : salesOpptyIdSet)
		{
			if((opptyIdtoContentDocIdMap.containsKey(opptyObjId) && 
				opptyIdtoContentDocIdMap.get(opptyObjId).size() == 0) ||
		 !opptyIdtoContentDocIdMap.containsKey(opptyObjId))
			{
				oppty = new Opportunity(Id = opptyObjId);
				oppty.PTA_Signed__c = false;
				opptyToUpdate.add(oppty);
			}
		}			
	}
	if(!opptyToUpdate.isEmpty() && opptyToUpdate.size()>0)
	{
		ID jobID = System.enqueueJob(new UpdateSObjectFlags(opptyToUpdate));  
	}
	else
	{
		system.debug(GlobalConstants.NOTHINGTOUPDATEONDELETE);
	}
	
			}
			else{
	system.debug(Globalconstants.PTADocument);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.updateOpportunityBOMOnDelete);
		}
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: None
* Return: void
* Description: Updates Opportunity fields when Excel-AddIn updates Offer fields
//Req#4705 - PTA Signed automatically ticked
checking PTA flag when PTA Document is Undeleted on Opportunity.
* High Level Process : 
**********************************************************************************************************************/
	public static void checkUncheckOpportunityPTAFlagOnUndelete(Map<Id, Id> contentDocIdTosalesOpptyIdMap)
	{
		try
		{	  
			String documentTypesPTA ;
			
			for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c 
			from Document_Types__mdt
			where DeveloperName =: Globalconstants.PTA_Documents
			and Object__c =: GlobalConstants.OBJECT_OPPORTUNITY
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
	if(docTypes.DeveloperName == Globalconstants.PTA_Documents)
	{
		documentTypesPTA = docTypes.Document_Type__c;
	}
			}
			if(String.isNotBlank(documentTypesPTA))
			{
	Opportunity oppty ;
	Set<String> documentTypes = new Set<String>();
	Set<Id> contentDocIdSet = new Set<Id>();	  
	List<Opportunity> opptyToUpdate = new List<Opportunity>();		
	
	for(String docType : documentTypesPTA.split(GlobalConstants.COMMA))
	{
		documentTypes.add(docType.trim());
	}
	
	if(!contentDocIdTosalesOpptyIdMap.isEmpty())
	{
		for(ContentVersion conVersion : [select Document_Type_POC__c,ContentDocumentId from ContentVersion 
				 where ContentDocumentId in: contentDocIdTosalesOpptyIdMap.keySet() and
				 Document_Type_POC__c in: documentTypes and IsLatest = True
				 ORDER BY VersionNumber desc 
				 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
		{
			contentDocIdSet.add(conVersion.ContentDocumentId);
		}		
		if(!contentDocIdSet.isEmpty())
		{
			for(Id contentDocId : contentDocIdSet)
			{
				if(!String.isBlank(contentDocIdTosalesOpptyIdMap.get(contentDocId)))
				{
		oppty = new Opportunity(Id = contentDocIdTosalesOpptyIdMap.get(contentDocId));
		oppty.PTA_Signed__c = True;
		opptyToUpdate.add(oppty);
				}
			}
		}
		if(!opptyToUpdate.isEmpty() && opptyToUpdate.size()>0)
		{
			ID jobID = System.enqueueJob(new UpdateSObjectFlags(opptyToUpdate));  
		}
		else{   
			system.debug(GlobalConstants.NOTHINGTOUPDATEONUNDELETE);
		}
	}
	
			}
			else{
	system.debug(Globalconstants.PTADocument);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.updateOpportunityPTAOnUndelete);
		}
	}	
	
	/**********************************************************************************************************************
* author: Accenture
* Date: July-2018
* Param: None
* Return: void
* Description: 
//Req#4858-Block file Deletion of SSO / PTA if Opportunity is pending for Approval
**********************************************************************************************************************/
	public static void blockFileDeletionOppty(Map<Id, ContentDocument> contentDocMap)
	{	
		try{
			Set<Id> docId = new Set<Id>();
			Set<Id> opptyIdForQuery = new Set<Id>();
			Set<Id> opptyId = new Set<Id>();
			
			Map<ID, ID> docToOppty = new Map<ID, ID>();
			Map<ID, ID> docToOffer = new Map<ID, ID>();
			Map<ID, ID> offerToOppty = new Map<ID, ID>();
			
			
			for(ContentVersion version : [SELECT ContentDocumentId,Document_Type_POC__c,Id FROM ContentVersion WHERE ContentDocumentId In: contentDocMap.KeySet() AND (Document_Type_POC__c =: GlobalConstants.Offer_Strategy_Sign_Off  OR Document_Type_POC__c =: GlobalConstants.Project_Transfer_Agreement OR  Document_Type_POC__c =: GlobalConstants.Pre_Sales_Risk_Doc_Type)])
			{
	docId.add(version.ContentDocumentId);
			}
			system.debug('docId>>>>>>>'+docId);
			if(!docId.isEmpty()){
	for(ContentDocumentLink link : [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType FROM ContentDocumentLink WHERE ContentDocumentId In: docId ])
	{
		String sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();  
		if(sObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OPPORTUNITY))
		{
			docToOppty.put(link.ContentDocumentId, link.LinkedEntityId);
			opptyIdForQuery.add(link.LinkedEntityId);
		}
		else if(sObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OFFER_1))
		{
			docToOffer.put(link.ContentDocumentId, link.LinkedEntityId);
		}
	}
			}
			for(Offer__C offerInstance : [SELECT Id, Opportunity__c FROM Offer__c WHERE Id IN: docToOffer.values()]){
	opptyIdForQuery.add(offerInstance.Opportunity__c);
	offerToOppty.put(offerInstance.Id, offerInstance.Opportunity__c);
			}
			
			if(!opptyIdForQuery.isEmpty()){
	for(Opportunity oppty : [SELECT Phase_Status__c, Id FROM Opportunity WHERE Id IN: opptyIdForQuery AND (Phase_Status__c =: GlobalConstants.SUBMITTED_FOR_G2_APPROVAL  OR Phase_Status__c =: GlobalConstants.SUBMITTED_FOR_G3_APPROVAL  OR Phase_Status__c =: GlobalConstants.SUBMITTED_FOR_G4_APPROVAL  OR Phase_Status__c =: GlobalConstants.SUBMITTED_FOR_G5_Contract_APPROVAL  OR StageName =: GlobalConstants.SUBMITTED_FOR_APPROVAL)])
	{
		opptyId.add(oppty.Id);
	}
			}
			
			for(ContentDocument doc : contentDocMap.Values())
			{
	if(opptyId.contains(docToOppty.get(doc.Id))){
		doc.addError(GlobalConstants.ERROR_MESSAGE_FOR_INPROGRESS_OPPTY_FILE_DELETE_RESTRICTION );
	}else if(opptyId.contains(offerToOppty.get(docToOffer.get(doc.Id)))){
		doc.addError(GlobalConstants.ERROR_MESSAGE_FOR_INPROGRESS_OPPTY_FILE_DELETE_RESTRICTION );
	}
			}
			
			
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.blockFileDeletionOppty);
		}
	}   
	/**********************************************************************************************************************
* author: Accenture
* Date: July-2018
* Param: None
* Return: void
* Description: 
**********************************************************************************************************************/
	public static void deleteFile(Map<Id, ContentDocument> contentDocOldMap)
	{  
		try{
			if(!contentDocOldMap.isEmpty())
			{
	List<Confidential_File__c> confidentialFileList = new List<Confidential_File__c>();
	List<File_Report__c> fileRecordList = new List<File_Report__c>();
	confidentialFileList = [SELECT ContentDocumentId__c,Id,Name FROM Confidential_File__c WHERE ContentDocumentId__c In: contentDocOldMap.KeySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	fileRecordList = [SELECT Id FROM File_Report__c WHERE ContentDocumentId__c In: contentDocOldMap.KeySet() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	database.delete(confidentialFileList);
	database.delete(fileRecordList);
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.deleteFile);
		}   
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: July-2018
* Param: None
* Return: void
* Description: 
**********************************************************************************************************************/
	public static void unDeleteFile(Map<Id, ContentDocument> contentDocNewMap)
	{  
		try{
			if(!contentDocNewMap.isEmpty())
			{
	List<Confidential_File__c> confidentialFileList = new List<Confidential_File__c>();
	List<File_Report__c> fileRecordList = new List<File_Report__c>();
	confidentialFileList = [SELECT Account_LookUp__c,Account__c,ContentDocumentId__c,Content_Version_Name__c,CreatedById,CreatedDate,CurrencyIsoCode,Description__c,Document_Type__c,File_Link__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,Offer__c,Opportunity__c,SystemModstamp FROM Confidential_File__c WHERE ContentDocumentId__c In: contentDocNewMap.KeySet() AND IsDeleted=true ALL ROWS ];
	fileRecordList = [SELECT Associated_Object__c,ContentDocumentId__c,Document_Type__c,File_Name__c,Id,IsDeleted,Name,Parent_Account__c,Related_Offer__c,Related_Opportunity__c,Restriction_Level__c FROM File_Report__c WHERE ContentDocumentId__c In: contentDocNewMap.KeySet() ALL ROWS];
	database.undelete(confidentialFileList); 
	database.undelete(fileRecordList);
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.deleteFile);
		}   
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: July-2018
* Param: None
* Return: void
* Description: 
//Req#8357-Block file Deletion of All files on Offer if Opportunity is in pending for Approval
**********************************************************************************************************************/
	public static void blockFileDeletionOnOffer(Map<Id, ContentDocument> contentDocMap)
	{	
		Set<Id> conDocIdSet = new Set<Id>();
		Map<ID, ID> offerToContDoc = new Map<ID, ID>();
		try{			
			if(!contentDocMap.isEmpty())
	conDocIdSet= contentDocMap.keySet();
			if(conDocIdSet.size() > 0){
	for(ContentDocumentLink link : [SELECT ContentDocumentId,Id,LinkedEntityId 
			FROM ContentDocumentLink 
			WHERE ContentDocumentId In: conDocIdSet
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		String sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();  
		if(sObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OFFER_1))
		{
			offerToContDoc.put(link.LinkedEntityId,link.ContentDocumentId);
		}
	}
			}
			if(!offerToContDoc.isEmpty())
			{
	for(Offer__C offerInstance : [SELECT Id, Opportunity__c,Opportunity__r.Phase_Status__c 
			 FROM Offer__c 
			 WHERE Id IN: offerToContDoc.KeySet() and 
			 Opportunity__r.Phase_Status__c =: GlobalConstants.PENDING_WIN_LOSS_DECLARATION
			 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
	{
		if(contentDocMap.containsKey(offerToContDoc.get(offerInstance.Id)))
			contentDocMap.get(offerToContDoc.get(offerInstance.Id)).addError(System.label.Restrict_Offer_Doc_Deletion);
	}
			}		
			
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOCUMENT_POC_HELPER, GlobalConstants.blockFileDeletionOnOffer);
		}
	}   
}