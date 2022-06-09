/*****
* @description: File uploaded on Account/ Opportunity/ Offer using lightning component of sCRM. File share Logic change: Collect L7 Territory Users +Collect Opp. & Offer team users Share file with first 100 users
*
* ============================================================================
* History:
* -------
*
* VERSION AUTHOR  DATE	DETAIL	  FEATURES/CSR/TTP
* 1.0   Accenture  20/1/2017 Sprint 4 Doc Stretegy & LoA requirements.
*	HCL Technologies 20/1/2021	Commenting unused variables
* ============================================================================

*/
public without sharing class ContentDocumentLinkHelper
{
	public class CustomException extends Exception {
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Check if Uploaing file is valid or not
**********************************************************************************************************************/
	public static Boolean validateUpload(List<ContentDocumentLink> contentDocLinkList)
	{
		Boolean isValid = true;
		try{

			Set<Id> offers = new Set<Id>();
			Set<Id> opptys = new Set<Id>();
			Set<Id> NADocs = new Set<Id>();
			Set<Id> closedOffers = new Set<Id>();
			Set<Id> closedOpptys = new Set<Id>();
			//Set<Id> contentDocumentIds = new Set<Id>(); //Commenting Unused variables
			Set<String> requiredObjects = new Set<String>();
			Map<Id, Id> contDocIdLinkIdMap = new Map<Id, Id>();
			Map<Id, String> contDocSelectedObjectMap = new Map<Id, String>();
			List<ContentDocumentLink> requiredContDocLink = new List<ContentDocumentLink>();

			for(String theObject : System.Label.Objects_For_Next_Screen_File.split(GlobalConstants.COMMAS  ))
			{
				requiredObjects.add(theObject.trim());
			}

			for(ContentDocumentLink link : contentDocLinkList)
			{
				if(link.ShareType != GlobalConstants.FILE_SHARE_TYPE_I)
				{
					Id contDocId = link.ContentDocumentId;
					String ObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getName();

					requiredContDocLink.add(link);
					contDocIdLinkIdMap.put(link.ContentDocumentId, link.LinkedEntityId);
					system.debug('ObjectType>>>>>>>>>>'+ObjectType);
					if(ObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OFFER))
					{
						offers.add(link.LinkedEntityId);
					}
					else if(ObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OPPORTUNITY))
					{
						opptys.add(link.LinkedEntityId);
					}
				}
			}
			if(!contDocIdLinkIdMap.isEmpty()){
				for(ContentVersion version : [SELECT ContentDocumentId, Document_Type_POC__c, RecordTypeId, RecordType.Name FROM ContentVersion WHERE IsDeleted = False
											  and IsLatest = True and ContentDocumentId In: contDocIdLinkIdMap.keySet()])
				{
					String objName;
					String recordTypeName = version.RecordType.Name;

					if(version.Document_Type_POC__c != null && version.Document_Type_POC__c.equalsIgnoreCase(GlobalConstants.NA))
					{
						NADocs.add(version.ContentDocumentId);
					}

					if(recordTypeName != null)
					{
						if(recordTypeName.containsIgnoreCase(GlobalConstants.OTHER_OBJECT))
						{
							objName = GlobalConstants.OTHER_OBJECT;
						}
						else if(recordTypeName.containsIgnoreCase(GlobalConstants.OBJECT_ACCOUNT))
						{
							objName = GlobalConstants.OBJECT_ACCOUNT;
						}
						else if(recordTypeName.containsIgnoreCase(GlobalConstants.OBJECT_OPPORTUNITY))
						{
							objName = GlobalConstants.OBJECT_OPPORTUNITY;
						}
						else if(recordTypeName.containsIgnoreCase(GlobalConstants.OBJECT_OFFER_1))
						{
							objName = GlobalConstants.OBJECT_OFFER;
						}
						contDocSelectedObjectMap.put(version.ContentDocumentId, objName);
					}
					else
					{
					}
				}
			}


			if(!opptys.isEmpty())
			{
				closedOpptys.addAll(new Map<Id, Opportunity>([SELECT Id FROM Opportunity WHERE (RecordTypeId =: System.Label.Read_Only_Direct_Opportunity_Record_Type OR RecordTypeId =: System.Label.Read_Only_InDirect_Opportunity_Record_Type) AND (Id IN: opptys)]).keySet());
			}

			if(!offers.isEmpty())
			{
				closedOffers.addAll(new Map<Id, Offer__c>([SELECT Id, Opportunity__c From Offer__c WHERE (Opportunity__r.RecordTypeId =: System.Label.Read_Only_Direct_Opportunity_Record_Type OR Opportunity__r.RecordTypeId =: System.Label.Read_Only_InDirect_Opportunity_Record_Type) AND Id IN: offers]).keySet());
			}

			for(ContentDocumentLink link : requiredContDocLink)
			{
				Id contDocId = link.ContentDocumentId;
				String actualsObjectType = contDocIdLinkIdMap.get(contDocId).getSObjectType().getDescribe().getName();

				if(contDocSelectedObjectMap.containsKey(contDocId))
				{
					String selectedsObjectType = contDocSelectedObjectMap.get(contDocId);
					//Commenting Unused Variable
					//String selected_Object_Offer = GlobalConstants.OBJECT_OFFER;
					system.debug('selectedsObjectType>>>>>>>>>>>'+selectedsObjectType);
					system.debug('actualsObjectType>>>>>>>>>>>'+actualsObjectType);
					if(requiredObjects.contains(selectedsObjectType) && NADocs.contains(link.ContentDocumentId))
					{
						isValid = false;
						link.addError(GlobalConstants.DOCUMENTTYPE_NULL_CHECK);
					}
					else if(!actualsObjectType.equalsIgnoreCase(selectedsObjectType) &&
							(actualsObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_ACCOUNT) || actualsObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OPPORTUNITY) || actualsObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OFFER)))
					{
						isValid = false;
						link.addError(GlobalConstants.SORRY_U_CNT_UPLOAD +actualsObjectType.remove(GlobalConstants.UNDERSCORE_C)+ GlobalConstants.SELECT_CORRECT_RECORD_TYPE + actualsObjectType.remove(GlobalConstants.UNDERSCORE_C)+ GlobalConstants.PLEASE_SELECT_CORRECT_REC_TYPE);
					}else if((selectedsObjectType != GlobalConstants.OTHER_OBJECT && actualsObjectType != GlobalConstants.USER) &&
							 !(actualsObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_ACCOUNT) || actualsObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OPPORTUNITY) || actualsObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OFFER)))
					{
						isValid = false;
						link.addError(GlobalConstants.HEY_UR_ON +actualsObjectType.remove(GlobalConstants.UNDERSCORE_C)+ GlobalConstants.PLEASE_SELECT_UNRESTRICTED_FILE_FOR_OTHER);
					}
					else if(actualsObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OPPORTUNITY) && closedOpptys.contains(contDocIdLinkIdMap.get(contDocId)))
					{
						isValid = false;
						link.addError(GlobalConstants.CLOSE_OPPTY_FILE_UPLOAD_ERROR);
					}
					else if(actualsObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OFFER) && closedOffers.contains(contDocIdLinkIdMap.get(contDocId)))
					{
						isValid = false;
						link.addError(GlobalConstants.CLOSE_OPPTY_FILE_UPLOAD_ERROR);
					}
				}
				else
				{
				}
			}


		} catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.validateUpload);
		}
		return isValid;

	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Create create confidential File records
**********************************************************************************************************************/
	public static void createConfidentialFiles(List<ContentDocumentLink> contentDocLinkListNew)
	{
		try{
			Set<Id> offers = new Set<Id>();
			Set<Id> opptys = new Set<Id>();
			Set<Id> confidentialRecordIds = new Set<Id>();
			Map<Id, Id> contDocLinkMap = new Map<Id, Id>();
			Map<Id, String> contDocObjNameMap = new Map<Id, String>();
			Map<Id, ContentVersion> documentVersionMap = new Map<Id, ContentVersion>();

			for(ContentDocumentLink link : contentDocLinkListNew)
			{
				String sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();
				if(link.ShareType != GlobalConstants.FILE_SHARE_TYPE_I && (sObjectType == GlobalConstants.OBJECT_OFFER_1 || sObjectType == GlobalConstants.OBJECT_OPPORTUNITY || sObjectType == GlobalConstants.OBJECT_ACCOUNT))
				{
					contDocLinkMap.put(link.ContentDocumentId, link.LinkedEntityId);
					contDocObjNameMap.put(link.ContentDocumentId, sObjectType);
				}
			}

			for(String recortType : System.Label.Confidential_File_Record_Types.split(GlobalConstants.COMMAS  ))
			{
				confidentialRecordIds.add(Schema.SObjectType.ContentVersion.getRecordTypeInfosByDeveloperName().get(recortType.trim()).getRecordTypeId());
			}

			System.debug('ContentVersions : '+[SELECT Title, ContentDocumentId, Document_Type_POC__c, Description FROM ContentVersion WHERE
											   RecordTypeId In: confidentialRecordIds and ContentDocumentId In: contDocLinkMap.keySet()]);
			if(!contDocLinkMap.isEmpty())
			{
				for(ContentVersion version : [SELECT Title, ContentDocumentId, Document_Type_POC__c, Description FROM ContentVersion WHERE
											  RecordTypeId In: confidentialRecordIds and ContentDocumentId In: contDocLinkMap.keySet()])
				{
					String sObjectType = contDocObjNameMap.get(version.ContentDocumentId);
					if(sObjectType == GlobalConstants.OBJECT_OFFER_1)
					{
						offers.add(contDocLinkMap.get(version.ContentDocumentId));
					}
					else if(sObjectType == GlobalConstants.OBJECT_OPPORTUNITY)
					{
						opptys.add(contDocLinkMap.get(version.ContentDocumentId));
					}

					documentVersionMap.put(version.ContentDocumentId, version);
				}
				if(!documentVersionMap.isEmpty())
				{
					shareWithConfidential(contentDocLinkListNew, documentVersionMap, opptys, offers);

					//Restricting the sharing of confidential docs
					restrictFileSharing(documentVersionMap.keySet());
				}
				else
				{
				}
			}
			else
			{
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.createConfidentialFiles);
		}

	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Share file with "All User"
**********************************************************************************************************************/
	public static void shareWithAllUsers(List<ContentDocumentLink> contentDocLinkListNew)
	{
		try{
			Set<String> reqObjects = new Set<String>();
			Map<String,ContentDocumentLink> docIdvsLinkMap = new Map<String,ContentDocumentLink>();
			Map<String,ContentVersion> docIdvsVersionMap = new Map<String,ContentVersion>();

			for(String theObject : System.Label.Objects_For_All_User_File_Share.split(GlobalConstants.COMMAS  )){
				reqObjects.add(theObject.trim());
			}

			for(ContentDocumentLink link : contentDocLinkListNew){
				docIdvsLinkMap.put(link.ContentDocumentId,link);
			}
			for(ContentVersion version : [SELECT Title, ContentDocumentId, Document_Type_POC__c, Description,Share_with_External_Users__c FROM ContentVersion WHERE
										  ContentDocumentId In: docIdvsLinkMap.keySet()]){
											  docIdvsVersionMap.put(version.ContentDocumentId,version);
										  }
			for(ContentDocumentLink link : contentDocLinkListNew){
				String ObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getName();
				if(link.ShareType == GlobalConstants.FILE_SHARE_TYPE_V  && reqObjects.contains(ObjectType))
				{
					if(ObjectType == 'Account' || ObjectType == 'Opportunity'){
						if(docIdvsVersionMap.get(link.ContentDocumentId).Share_with_External_Users__c){
							link.Visibility = GlobalConstants.ALL_USERS;
						}
					}else{
						link.Visibility = GlobalConstants.ALL_USERS;
					}
				}
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.shareWithAllUsers);
		}

	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Future method for Restricting File Sharing
**********************************************************************************************************************/
	@future
	public static void restrictFileSharing(Set<Id> contDocIds)
	{
		try{
			List<ContentDocument> contDocList = new List<ContentDocument>();

			//Need to add additional bussiness logic for restricting only 3 objects file sharing, not all
			if(!contDocIds.isEmpty()){
				for(ContentDocument contDoc : [SELECT SharingOption FROM ContentDocument WHERE Id In: contDocIds])
				{
					if(contDoc.SharingOption != GlobalConstants.SHARING_OPTION_VALUE)
					{
						contDoc.SharingOption = GlobalConstants.SHARING_OPTION_VALUE;
						contDocList.add(contDoc);
					}
				}
			}


			Database.update(contDocList, false);
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.restrictFileSharing);
		}

	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Share Document with "Confidential File" record
**********************************************************************************************************************/
	public static void shareWithConfidential(List<ContentDocumentLink> contentDocLinkListNew, Map<Id, ContentVersion> contDocVersionMap, Set<Id> opptys, Set<Id> offers)
	{
		try{
			Map<Id, Id> offerAccMap = new Map<Id, Id>();
			Map<Id, Id> opptyAccMap = new Map<Id, Id>();
			Confidential_File__c confFile = null;
			Set<Id> contentDocumentIds = contDocVersionMap.keySet();
			List<Confidential_File__c> confFileToInsert = new List<Confidential_File__c>();

			// Retrieving master Accounts
			if(offers != null)
			{
				offerAccMap = getOfferMasterAccounts(offers);
			}
			if(opptys != null)
			{
				opptyAccMap = getOpptyMasterAccounts(opptys);
			}
			set<Id> docSet = new set<Id>();
			for(ContentDocumentLink link : contentDocLinkListNew)
			{
				if(link.ShareType != GlobalConstants.FILE_SHARE_TYPE_I && contentDocumentIds.contains(link.ContentDocumentId))
				{
					confFile = new Confidential_File__c();
					ContentVersion version = contDocVersionMap.get(link.ContentDocumentId);
					String sObjectName = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();

					if(sObjectName == GlobalConstants.OBJECT_OFFER_1)
					{
						confFile.Offer__c = link.LinkedEntityId;
						confFile.Account__c = offerAccMap.get(link.LinkedEntityId);
					}
					else if(sObjectName == GlobalConstants.OBJECT_OPPORTUNITY)
					{
						confFile.Opportunity__c = link.LinkedEntityId;
						confFile.Account__c = opptyAccMap.get(link.LinkedEntityId);
					}
					else if(sObjectName == GlobalConstants.OBJECT_ACCOUNT)
					{
						confFile.Account__c = link.LinkedEntityId;
						confFile.Account_LookUp__c = link.LinkedEntityId;
					}
					else
					{
						// not an expected sObject
						break;
					}
					docSet.add(link.ContentDocumentId);
					confFile.Description__c = version.Description;
					confFile.Content_Version_Name__c = version.Title;
					confFile.ContentDocumentId__c = link.ContentDocumentId;
					confFile.Document_Type__c = version.Document_Type_POC__c;
					confFileToInsert.add(confFile);
				}
			}

			confFileToInsert = insertSObjectList(confFileToInsert, GlobalConstants.Confidential_File);

			for(ContentDocumentLink link : contentDocLinkListNew)
			{
				if(link.ShareType != GlobalConstants.FILE_SHARE_TYPE_I && contentDocumentIds.contains(link.ContentDocumentId))
				{
					link.LinkedEntityId = confFileToInsert[0].Id;
				}
			}

			//Preventing recursive calls
			ContentDocumentLinkHandler.isConfidentialRecCreated = true;
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.shareWithConfidential);
		}

	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Get Master Account from Offer to populate in "Confidential File" record
**********************************************************************************************************************/
	public static Map<Id, Id> getOfferMasterAccounts(Set<Id> offerIds)
	{
		Map<Id, Id> offerAccMap = new Map<Id, Id>();
		try{
			for(Offer__C offr : [select Opportunity__r.AccountId, Opportunity__c  from Offer__c where Id In: offerIds])
			{
				offerAccMap.put(offr.Id, offr.Opportunity__r.AccountId);
			}

		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.getOfferMasterAccounts);
		}
		return offerAccMap;
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Get Master Account from Oppertunity to populate in "Confidential File" record
**********************************************************************************************************************/
	public static Map<Id, Id> getOpptyMasterAccounts(Set<Id> opptyIds)
	{
		Map<Id, Id> opptyAccMap = new Map<Id, Id>();
		try{
			for(Opportunity opp : [select AccountId from Opportunity where Id In: opptyIds])
			{
				opptyAccMap.put(opp.Id, opp.AccountId);
			}

		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.getOpptyMasterAccounts);
		}
		return opptyAccMap;
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Insert Method
**********************************************************************************************************************/
	public static List<sObject> insertSObjectList(List<sObject> listToInsert, String sObjectName)
	{
		Boolean someFailure = false;
		Database.SaveResult[] savedResults = Database.insert(listToInsert, false);
		try{
			for (Database.SaveResult sr : savedResults)
			{
				if (!sr.isSuccess())
				{
					someFailure = true;
					for(Database.Error err : sr.getErrors())
					{
					}
				}
			}
			if(!someFailure)
			{
				System.debug('All '+sObjectName+' records inserted successfully');
			}


		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.insertSObjectList);
		}
		return listToInsert;
	}


	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: ContentDocumentLink list
* Return: void
* Description:
Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
This method determined on which object Document is uploaded.
* High Level Process :
**********************************************************************************************************************/
	public static void determineObjectType(List<ContentDocumentLink> contentDoclist)
	{
		try
		{
			if(!contentDoclist.isEmpty())
			{
				String sObjectType ;
				Map<Id,Id> docIdToOfferIdMap = new Map<Id,Id>();
				Map<Id,Id> offerToSSODocIdMap = new Map<Id,Id>();
				//List<Offer__c> offerList ;  //Commenting Unused Variable
				Map<Id,ContentDocumentLink> salesOpportunityContentDocsLinkMap = new Map<Id,ContentDocumentLink>();
				List<ContentDocumentLink> presalesOpportunityContentDocsLinkList = new List<ContentDocumentLink>();
				Map<Id,ContentDocumentLink> OpptyIdToContentDocMap = new Map<Id,ContentDocumentLink>();
				Map<Id,Id> OpptyIdToContentDocIdMap = new Map<Id,Id>();
				Map<Id,ContentDocumentLink> offerIdToContentDocLink = new Map<Id,ContentDocumentLink>();

				for(ContentDocumentLink link : contentDoclist)
				{
					sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getName();
					system.debug('sObjectType'+sObjectType);
					if(sObjectType == GlobalConstants.OBJECT_OFFER )
					{
						offerIdToContentDocLink.put(link.LinkedEntityId,link);
						docIdToOfferIdMap.put(link.ContentDocumentId,link.LinkedEntityId);
					}
					else if(sObjectType == GlobalConstants.OBJECT_OPPORTUNITY )
					{
						OpptyIdToContentDocMap.put(link.LinkedEntityId,link);
					}
				}


				if(offerIdToContentDocLink.size() > 0)
				{

					if(docIdToOfferIdMap.size() > 0){
						for(ContentVersion version : [SELECT ContentDocumentId,Document_Type_POC__c,FileType,Id,RecordTypeId,VersionNumber
													  FROM ContentVersion WHERE ContentDocumentId IN: docIdToOfferIdMap.keySet() AND
													  Document_Type_POC__c =: GlobalConstants.SSOFlag]){

														  offerToSSODocIdMap.put(docIdToOfferIdMap.get(version.ContentDocumentId), version.ContentDocumentId);
													  }
					}


					for(Offer__c offr : [Select Id,Opportunity__r.Phase_Status__c,ActiveOffer__c
										 from Offer__c
										 where id in : offerIdToContentDocLink.keySet() and
										 ActiveOffer__c = True and
										 Opportunity__r.Phase_Status__c =: GlobalConstants.PENDING_WIN_LOSS_DECLARATION
										 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
					{
						if(offerToSSODocIdMap.containsKey(offr.Id)){
							offerIdToContentDocLink.get(offr.Id).addError(System.Label.Restrict_Offer_Doc_Upload);
							offerIdToContentDocLink.remove(offr.Id);
						}
					}
				}

				if(!OpptyIdToContentDocMap.isEmpty()){
					for(Opportunity opptyRec : [select Id, RecordType.Name from Opportunity
												where id in : OpptyIdToContentDocMap.keySet()
												LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
					{
						if(opptyRec.RecordType.Name == GlobalConstants.DIRECT_OPPTY  ||
						   opptyRec.RecordType.Name == GlobalConstants.INDIRECT_OPPTY )
						{
							OpptyIdToContentDocIdMap.put(opptyRec.Id,OpptyIdToContentDocMap.get(opptyRec.Id).ContentDocumentId);
							salesOpportunityContentDocsLinkMap.put(opptyRec.Id,OpptyIdToContentDocMap.get(opptyRec.Id));
						}
						else if(opptyRec.RecordType.Name == GlobalConstants.PRESALESRISKOPPORTUNITY )
						{
							presalesOpportunityContentDocsLinkList.add(OpptyIdToContentDocMap.get(opptyRec.Id));
						}
					}
				}

				/*if(!offerIdToContentDocLink.isEmpty()){
checkUncheckOfferSSOFlagOnInsert(offerIdToContentDocLink.values());
}*/
				if(!salesOpportunityContentDocsLinkMap.isEmpty()){
					checkUncheckOpportunityPTAFlagOnInsert(salesOpportunityContentDocsLinkMap,OpptyIdToContentDocIdMap);
				}
				if(!presalesOpportunityContentDocsLinkList.isEmpty()){
					checkUncheckOpportunityBOMFlagOnInsert(presalesOpportunityContentDocsLinkList);
				}
			}
			else
			{
				System.debug('Content doc link List Empty');
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.DETERMINE_SOBJECT_TYPE);
		}
	}

	/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: ContentDocumentLink list
* Return: void
* Description: Updates Opportunity fields when Excel-AddIn updates Offer fields
//Req#4710-Updates in Sales Process based on new DocStrategy ReDesign
checking SSO flag when SSO Document is uploaded on Offer.
* High Level Process :
**********************************************************************************************************************/
	/*public static void checkUncheckOfferSSOFlagOnInsert(List<ContentDocumentLink> contentDoclist)
{
try
{
String sSODocumentTypes = Null;

for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c
from Document_Types__mdt
where DeveloperName =: Globalconstants.SSO_Document_Types
and Object__c =: GlobalConstants.OBJECT_OFFER
LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
{
if(docTypes.DeveloperName == Globalconstants.SSO_Document_Types)
{
sSODocumentTypes = docTypes.Document_Type__c;
}
}

if(String.isNotBlank(sSODocumentTypes))
{
Offer__c offr = Null;
String sObjectType = Null;
Set<String> documentTypes = new Set<String>();
List<Offer__c> offersToUpdate = new List<Offer__c>();
Set<Id> contentDocIdOfOffer = new Set<Id>();
Set<Id> contDocIdSet = new Set<Id>();

if(String.isNotBlank(sSODocumentTypes)){
for(String docType : sSODocumentTypes.split(GlobalConstants.COMMA))
{
documentTypes.add(docType.trim());
}
}

for(ContentDocumentLink link : contentDoclist)
{
contentDocIdOfOffer.add(link.ContentDocumentId);
}

if(contentDocIdOfOffer.size() > 0){
for(ContentVersion version : [SELECT Document_Type_POC__c,
ContentDocumentId
FROM ContentVersion
WHERE ContentDocumentId In: contentDocIdOfOffer and
IsLatest = True and
Document_Type_POC__c in : documentTypes
ORDER BY VersionNumber desc
LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
{
if(!contDocIdSet.contains(version.ContentDocumentId))
{
contDocIdSet.add(version.ContentDocumentId);
}
}

for(ContentDocumentLink link : contentDoclist)
{
if(contDocIdSet.contains(link.ContentDocumentId))
{
offr = new Offer__c(Id = link.LinkedEntityId);
offr.Solution_Sign_Off_New__c = GlobalConstants.Required_Attached;
offersToUpdate.add(offr);
}
}
}


if(!offersToUpdate.isEmpty() && offersToUpdate.size()>0)
{
ID jobID = System.enqueueJob(new UpdateSObjectFlags(offersToUpdate));
system.debug('jobID'+jobID);
}
else
{
System.debug(GlobalConstants.NOTHINGTOUPDATEONINSERT);
}
}
else
{
System.debug(GlobalConstants.SSO_DocumentType);
}
}
catch(Exception ex)
{
ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.checkUncheckOfferSSOFlagOnInsert);
}
}*/

	/**********************************************************************************************************************
* author: Accenture
* Date: Sept -2017
* Param: ContentDocumentLink list
* Return: void
* Description: PreSales : Sprint 10 : Req:2766: update flag to true when BOM/BOQ doc is uploaded on presales opty
Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
checking BOM/BOQ flag when BOM Document is uploaded on presales Opportunity.
* High Level Process :
**********************************************************************************************************************/
	public static void checkUncheckOpportunityBOMFlagOnInsert(List<ContentDocumentLink> contentDoclist)
	{
		try
		{
			String boMBoQDocument ;

			for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c
												from Document_Types__mdt
												where DeveloperName =: Globalconstants.BoMBoQ_Document
												and Object__c =: GlobalConstants.OBJECT_OPPORTUNITY
												LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
				if(docTypes.DeveloperName == Globalconstants.BoMBoQ_Document)
				{
					boMBoQDocument = docTypes.Document_Type__c;
				}
			}

			if(String.isNotBlank(boMBoQDocument))
			{
				Opportunity oppty ;
				//String sObjectType ; //Commenting unused variable
				Set<String> documentTypes = new Set<String>();
				List<Opportunity> opptyToUpdate = new List<Opportunity>();
				Set<Id> contentDocIdOfOppty = new Set<Id>();
				Set<Id> contDocIdsSet = new Set<Id>();


				if(String.isNotBlank(boMBoQDocument)){
					for(String docType : boMBoQDocument.split(GlobalConstants.COMMA))
					{
						documentTypes.add(docType.trim());
					}
				}
				for(ContentDocumentLink link : contentDoclist)
				{
					contentDocIdOfOppty.add(link.ContentDocumentId);
				}

				if(contentDocIdOfOppty.size() > 0){
					for(ContentVersion version : [SELECT Document_Type_POC__c,
												  ContentDocumentId
												  FROM ContentVersion
												  WHERE ContentDocumentId In: contentDocIdOfOppty and
												  IsLatest = True and
												  Document_Type_POC__c in : documentTypes
												  ORDER BY VersionNumber desc
												  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
					{
						if( documentTypes.contains(version.Document_Type_POC__c))
						{
							contDocIdsSet.add(version.ContentDocumentId);
						}
					}

					for(ContentDocumentLink link : contentDoclist)
					{
						if(contDocIdsSet.contains(link.ContentDocumentId))
						{
							oppty = new Opportunity(Id = link.LinkedEntityId);
							oppty.PSR_is_BOM_BOQ_document_attached__c  = true;
							opptyToUpdate.add(oppty);
						}
					}
				}

				if(!opptyToUpdate.isEmpty() && opptyToUpdate.size()>0)
				{
					ID jobID = System.enqueueJob(new UpdateSObjectFlags(opptyToUpdate));
					system.debug('jobID'+jobID);
				}
				else
				{
					System.debug(GlobalConstants.NOTHINGTOUPDATEONINSERT);
				}
			}
			else
			{
				System.debug(GlobalConstants.BoMBoQDocument);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.checkUncheckOpportunityBOMFlagOnInsert);
		}
	}

	/**********************************************************************************************************************
* author: Accenture
* Date: Sept -2017
* Param: ContentDocumentLink list
* Return: void
* Description: Req#4705 - PTA Signed automatically ticked
checking PTA flag when PTA Document is uploaded on Opportunity.
* High Level Process :
**********************************************************************************************************************/
	public static void checkUncheckOpportunityPTAFlagOnInsert(Map<Id,ContentDocumentLink> contentDocMap,Map<Id,Id> opptyIdToContentDocId)
	{
		try
		{
			String pTADocument ;

			for(Document_Types__mdt docTypes : [select DeveloperName,Document_Type__c,Object__c
												from Document_Types__mdt
												where DeveloperName =: Globalconstants.PTA_Documents
												and Object__c =: GlobalConstants.OBJECT_OPPORTUNITY
												LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
				if(docTypes.DeveloperName == Globalconstants.PTA_Documents)
				{
					pTADocument = docTypes.Document_Type__c;
				}
			}


			if(String.isNotBlank(pTADocument))
			{
				Opportunity oppty ;
				//String sObjectType ; // Commenting unused variable
				Set<String> documentTypes = new Set<String>();
				List<Opportunity> opptyToUpdate = new List<Opportunity>();
				Set<Id> contentDocIdOfOppty = new Set<Id>();
				Set<Id> contDocIdsSet = new Set<Id>();

				if(String.isNotBlank(pTADocument)){
					for(String docType : pTADocument.split(GlobalConstants.COMMA))
					{
						documentTypes.add(docType.trim());
					}
				}

				for(ContentDocumentLink link : contentDocMap.values())
				{
					contentDocIdOfOppty.add(link.ContentDocumentId);
				}

				if(contentDocIdOfOppty.size() > 0){
					for(ContentVersion version : [SELECT Document_Type_POC__c,
												  ContentDocumentId
												  FROM ContentVersion
												  WHERE ContentDocumentId In: contentDocIdOfOppty and
												  IsLatest = True and
												  Document_Type_POC__c in : documentTypes
												  ORDER BY VersionNumber desc
												  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
					{
						if(documentTypes.contains(version.Document_Type_POC__c))
						{
							contDocIdsSet.add(version.ContentDocumentId);
						}
					}

					if(contentDocMap.size() > 0)
					{
						for(Opportunity opp : [Select Id,Gate_6_Bypass_No_Execute_needed__c from Opportunity
											   where (Gate_6_Bypass_No_Execute_needed__c = True and Id in: opptyIdToContentDocId.KeySet())])
						{
							if(contDocIdsSet.contains(opptyIdToContentDocId.get(opp.id)))
							{
								contentDocMap.get(opp.id).addError(System.Label.Restrict_Oppty_PTA_Doc_Upload);
								contentDocMap.remove(opp.id);
							}
						}
					}

					for(ContentDocumentLink link : contentDocMap.values())
					{
						if(contDocIdsSet.contains(link.ContentDocumentId))
						{
							oppty = new Opportunity(Id = link.LinkedEntityId);
							oppty.PTA_Signed__c = true;
							opptyToUpdate.add(oppty);
						}
					}
				}

				if(!opptyToUpdate.isEmpty() && opptyToUpdate.size()>0)
				{
					ID jobID = System.enqueueJob(new UpdateSObjectFlags(opptyToUpdate));
					system.debug('jobID'+jobID);
				}
				else
				{
					System.debug(GlobalConstants.NOTHINGTOUPDATEONINSERT);
				}
			}
			else
			{
				System.debug(GlobalConstants.PTADocument);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.checkUncheckOpportunityPTAFlagOnInsert);
		}
	}

	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Error when user tries to share NSa record file to Non NSA user
* High Level Process : Doc Strategy NSA Restrictions
**********************************************************************************************************************/
	public static void restrictNSASharing(List<ContentDocumentLink> contentDocLinkListNew)
	{
		try{
			Set<Id> offerIDs = new Set<Id>();
			Set<Id> accountIDs = new Set<Id>();
			Set<Id> opptyIDs = new Set<Id>();
			Set<Id> userIDs = new Set<Id>();
			Set<Id> cofidentialIds = new Set<Id>();
			Set<Id> accountSet = new Set<Id>();
			Set<Id> documentIDs = new Set<Id>();

			Map<Id, Id> contDocLinkMap = new Map<Id, Id>();
			Map<ID, ID> offerToOpptyMap = new Map<ID, ID>();
			Map<ID, ID> opptyToAccMap = new Map<ID, ID>();
			Map<ID, ID> confyToAccMap = new Map<ID, ID>();
			Map<ID, ID> userToDocMap = new Map<ID, ID>();
			Map<Id, String> contDocSelectedObjectMap = new Map<Id, String>();

			for(ContentDocumentLink link : contentDocLinkListNew)
			{
				String sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();
				if(sObjectType == GlobalConstants.USER)
				{
					userToDocMap.put(link.LinkedEntityId, link.ContentDocumentId);
				}
			}
			//Check if Sharing user is Not NSA
			if(!userToDocMap.isEmpty()){
				for(User userInstance : [SELECT Id,NSA_Compliant__c FROM User WHERE Id IN: userToDocMap.keySet() AND NSA_Compliant__c =: false]){
					userIDs.add(userInstance.Id);
					//add document Id to set
					if(userToDocMap.containsKey(userInstance.Id)){
						documentIDs.add(userToDocMap.get(userInstance.Id));
					}
				}
			}

			if(!documentIDs.isEmpty()){
				for(ContentDocumentLink link : [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType FROM ContentDocumentLink WHERE ContentDocumentId IN: documentIDs ] ){
					String sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();
					system.debug('link.ShareType>>>>>>>'+link.ShareType);
					if(link.ShareType != GlobalConstants.FILE_SHARE_TYPE_I && (sObjectType == GlobalConstants.OBJECT_OFFER_1 || sObjectType == GlobalConstants.OBJECT_OPPORTUNITY || sObjectType == GlobalConstants.OBJECT_ACCOUNT || sObjectType == GlobalConstants.Confidential_File1))
					{  system.debug('link.ShareType>>>>>>>'+link.ShareType);
					 //doc to entity map.....
					 contDocLinkMap.put(link.ContentDocumentId, link.LinkedEntityId);
					 contDocSelectedObjectMap.put(link.ContentDocumentId, sObjectType);
					}
					if(sObjectType == GlobalConstants.OBJECT_OFFER_1)
					{
						offerIDs.add(link.LinkedEntityId);
					}else if(sObjectType == GlobalConstants.OBJECT_OPPORTUNITY)
					{
						opptyIDs.add(link.LinkedEntityId);
					}else if(sObjectType == GlobalConstants.OBJECT_ACCOUNT)
					{
						accountIDs.add(link.LinkedEntityId);
					}else if(sObjectType == GlobalConstants.Confidential_File1){
						cofidentialIds.add(link.LinkedEntityId);
					}

				}

			}
			if(!offerIDs.isEmpty()){
				for(Offer__c offer: [SELECT Id, Opportunity__c, Customer_Account_Name__c FROM Offer__c WHERE Id IN: offerIDs]){
					opptyIDs.add(offer.Opportunity__c);
					offerToOpptyMap.put(offer.Id, offer.Opportunity__c );
				}

			}
			if(!opptyIDs.isEmpty()){
				for(Opportunity Oppoty : [SELECT Id, AccountId FROM Opportunity WHERE Id IN: opptyIDs]){
					accountIDs.add(Oppoty.AccountId);
					opptyToAccMap.put(Oppoty.Id, Oppoty.AccountId );
				}
			}

			if(!cofidentialIds.isEmpty()){
				for(Confidential_File__c confy : [SELECT Account__c, Id FROM Confidential_File__c WHERE Id IN: cofidentialIds]){
					accountIDs.add(confy.Account__c);
					confyToAccMap.put(confy.Id, confy.Account__c);
				}
			}

			if(!accountIDs.isEmpty()){
				for(Account acc : [SELECT Id, Customer_Compliance__c FROM Account WHERE Id IN: accountIDs AND Customer_Compliance__c =: GlobalConstants.US_Govern]){
					accountSet.add(acc.Id);
				}
			}


			for(ContentDocumentLink link : contentDocLinkListNew)
			{
				String actualObjectName = contDocSelectedObjectMap.get(link.ContentDocumentId) ;
				if(actualObjectName == GlobalConstants.OBJECT_OFFER_1)
				{
					if(userIDs.contains(link.LinkedEntityId) && accountSet.contains(opptyToAccMap.get(offerToOpptyMap.get(contDocLinkMap.get(link.ContentDocumentId)))) )
					{
						link.addError(GlobalConstants.RESTRICT_NSA_ERROR);
					}
				}
				else if(actualObjectName == GlobalConstants.OBJECT_OPPORTUNITY)
				{
					if(userIDs.contains(link.LinkedEntityId) && accountSet.contains(opptyToAccMap.get(contDocLinkMap.get(link.ContentDocumentId))))
					{
						link.addError(GlobalConstants.RESTRICT_NSA_ERROR );
					}

				}
				else if(actualObjectName == GlobalConstants.OBJECT_ACCOUNT)
				{
					if(userIDs.contains(link.LinkedEntityId) && accountSet.contains(contDocLinkMap.get(link.ContentDocumentId)))
					{
						link.addError(GlobalConstants.RESTRICT_NSA_ERROR);
					}
				}
				else if(actualObjectName == GlobalConstants.Confidential_File1)
				{
					System.debug(link.ShareType+' : '+link.LinkedEntityId+' : '+userIDs.contains(link.LinkedEntityId)+' : '+accountSet.contains(confyToAccMap.get(contDocLinkMap.get(link.ContentDocumentId))));
					if(userIDs.contains(link.LinkedEntityId) && accountSet.contains(confyToAccMap.get(contDocLinkMap.get(link.ContentDocumentId))))
					{
						link.addError(GlobalConstants.RESTRICT_NSA_ERROR);
					}
				}
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.restrictNSASharing);
		}
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Methode will pass all confidenatil file (contentDoc) list to Queueable apex
* High Level Process : Doc Strategy confidentail file owner change
**********************************************************************************************************************/
	public static void confidentialFileOwnerSet(set<Id> docIds)
	{
		try{
			Set<Id> confidentialRecordIds = new Set<Id>();
			List<ContentDocument> contentDocumentToUpdate = new List<ContentDocument>();

			Id globalFileOwner = [SELECT Id FROM User WHERE Name =: GlobalConstants.Global_File_Owner].Id;

			for(String recortType : System.Label.Confidential_File_Record_Types.split(GlobalConstants.COMMAS  ))
			{
				confidentialRecordIds.add(Schema.SObjectType.ContentVersion.getRecordTypeInfosByDeveloperName().get(recortType.trim()).getRecordTypeId());
			}
			if(!docIds.isEmpty()){
				for(ContentVersion version: [SELECT ContentDocumentId,Id,RecordTypeId FROM ContentVersion WHERE ContentDocumentId IN: docIds and  IsDeleted = False and IsLatest = True
											 AND RecordTypeId In: confidentialRecordIds])
				{
					contentDocumentToUpdate.add(new ContentDocument(Id = version.ContentDocumentId, OwnerId = globalFileOwner));
				}
			}


			if(!contentDocumentToUpdate.isEmpty())
			{
				ID jobID = System.enqueueJob(new ConfidentialFileOwnerChange(contentDocumentToUpdate));
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.confidentialFileOwnerSet);
		}

	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: Methode will pass all confidenatil file (contentDoc) list to Queueable apex
* High Level Process : Doc Strategy confidentail file owner change
**********************************************************************************************************************/
	public static void createFileRecord(List<ContentDocumentLink> contentDocLinkListNew)
	{
		try{
			Set<Id> offerIDs = new Set<Id>();
			Set<Id> opptyIDs = new Set<Id>();
			Set<Id> accountIDs = new Set<Id>();
			Set<Id> confedentialIds = new Set<Id>();
			Set<Id> contentDocIDs = new Set<Id>();
			Map<ID, ID> offerToOpptyMap = new Map<ID, ID>();
			Map<ID, ID> opptyToAccMap = new Map<ID, ID>();
			Map<ID, Confidential_File__c> confidentialMap = new Map<ID, Confidential_File__c>();
			Map<ID,ContentVersion> contentVersionMap= new Map<ID,ContentVersion>();

			File_Report__c fileRecord = new File_Report__c();
			List<File_Report__c> fileRecordList = new List<File_Report__c>();
			List<File_Report__c> fileRecordListToInsert = new List<File_Report__c>();
			for(ContentDocumentLink link : contentDocLinkListNew)
			{
				String sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();
				system.debug('sObjectType>>>'+link.LinkedEntityId.getSObjectType().getDescribe().getLabel());
				if(sObjectType == GlobalConstants.OBJECT_OFFER_1)
				{
					offerIDs.add(link.LinkedEntityId);
					contentDocIDs.add(link.ContentDocumentId);
				}else if(sObjectType == GlobalConstants.OBJECT_OPPORTUNITY)
				{
					opptyIDs.add(link.LinkedEntityId);
					contentDocIDs.add(link.ContentDocumentId);
				}else if(sObjectType == GlobalConstants.OBJECT_ACCOUNT)
				{
					accountIDs.add(link.LinkedEntityId);
					contentDocIDs.add(link.ContentDocumentId);
				}else if(sObjectType ==GlobalConstants.Confidential_File1){
					confedentialIds.add(link.LinkedEntityId);
					contentDocIDs.add(link.ContentDocumentId);
				}
			}
			if(!confedentialIds.isEmpty()){
				for(Confidential_File__c conf : [SELECT Id,Account__c,Account_LookUp__c,ContentDocumentId__c,Content_Version_Name__c,Document_Type__c,Offer__c,Opportunity__c FROM Confidential_File__c WHERE Id IN: confedentialIds]){
					if(conf.Offer__c != null){
						offerIDs.add(conf.Offer__c);
					}
					confidentialMap.put(conf.Id, conf);
				}
			}
			if(!offerIDs.isEmpty())
			{
				for(Offer__c offer: [SELECT Id, Opportunity__c, Customer_Account_Name__c FROM Offer__c WHERE Id IN: offerIDs ]){
					opptyIDs.add(offer.Opportunity__c);
					offerToOpptyMap.put(offer.Id, offer.Opportunity__c );
				}
			}
			if(!opptyIDs.isEmpty())
			{
				for(Opportunity Oppoty : [SELECT Id, AccountId FROM Opportunity WHERE Id IN: opptyIDs]){
					accountIDs.add(Oppoty.AccountId);
					opptyToAccMap.put(Oppoty.Id, Oppoty.AccountId );
				}
			}
			if(!contentDocIDs.isEmpty() )
			{
				system.debug('opptyToAccMap>>>'+contentDocIDs);
				for(ContentVersion ver: [SELECT ContentDocumentId,Document_Type_POC__c,FileType,Id,Title,RecordType.name,ContentSize,Description,VersionNumber,IsLatest,Owner.Name,Share_with_External_Users__c FROM ContentVersion WHERE IsLatest = True and ContentDocumentId In: contentDocIDs]){
					contentVersionMap.put(ver.ContentDocumentId,ver);
				}
			}

			for(Confidential_File__c conf : confidentialMap.Values()){
				//TO DO create file report record
				fileRecord = new File_Report__c();
				if(conf.opportunity__c!=Null && conf.Offer__c==Null){
					fileRecord.Associated_Object__c = GlobalConstants.OBJECT_OPPORTUNITY ;
					fileRecord.Related_Opportunity__c = conf.opportunity__c;
				}
				else if(conf.Offer__c!=Null){
					fileRecord.Associated_Object__c = GlobalConstants.OBJECT_OFFER_1;
					fileRecord.Related_Offer__c = conf.Offer__c;
					fileRecord.Related_Opportunity__c = offerToOpptyMap.get(conf.Offer__c);
				}
				fileRecord.Document_Type__c = conf.Document_Type__c;
				fileRecord.File_Name__c = contentVersionMap.get(conf.ContentDocumentId__c).Title;
				fileRecord.Report_type__c = contentVersionMap.get(conf.ContentDocumentId__c).RecordType.name;
				fileRecord.Restriction_Level__c = GlobalConstants.CONFIDENTIAL_VALUE;
				fileRecord.Parent_Account__c = conf.Account__c;
				fileRecord.ContentDocumentId__c = conf.ContentDocumentId__c;
				fileRecord.File_Size__c = contentVersionMap.get(conf.ContentDocumentId__c).ContentSize;
				fileRecord.File_Version__c = contentVersionMap.get(conf.ContentDocumentId__c).VersionNumber;
				fileRecord.Description__c = contentVersionMap.get(conf.ContentDocumentId__c).Description;
				fileRecord.File_Owner__c = GlobalConstants.Global_File_Owner;
				fileRecord.Share_with_External_Users__c = contentVersionMap.get(conf.ContentDocumentId__c).Share_with_External_Users__c;
				fileRecordList.add(fileRecord);
			}


			for(ContentDocumentLink link : contentDocLinkListNew)
			{
				fileRecord = new File_Report__c();
				String sObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();
				system.debug('sObjectType1>>>'+link.LinkedEntityId.getSObjectType().getDescribe().getLabel());
				fileRecord.Associated_Object__c = link.LinkedEntityId.getSObjectType().getDescribe().getLabel();
				fileRecord.Document_Type__c = contentVersionMap.get(link.ContentDocumentId).Document_Type_POC__c;
				fileRecord.File_Name__c = contentVersionMap.get(link.ContentDocumentId).Title;
				fileRecord.Report_type__c = contentVersionMap.get(link.ContentDocumentId).RecordType.name;
				fileRecord.File_Size__c = contentVersionMap.get(link.ContentDocumentId).ContentSize;
				fileRecord.File_Version__c = contentVersionMap.get(link.ContentDocumentId).VersionNumber;
				fileRecord.Description__c = contentVersionMap.get(link.ContentDocumentId).Description;
				fileRecord.File_Owner__c = contentVersionMap.get(link.ContentDocumentId).Owner.Name;
				fileRecord.Share_with_External_Users__c = contentVersionMap.get(link.ContentDocumentId).Share_with_External_Users__c;
				system.debug('Report_type__c>>>'+contentVersionMap.get(link.ContentDocumentId).RecordType.name);
				if(contentVersionMap.get(link.ContentDocumentId).RecordType.name == GlobalConstants.UnrestrictedFileToOffer ||  contentVersionMap.get(link.ContentDocumentId).RecordType.name ==GlobalConstants.UnrestrictedFileToAccount|| contentVersionMap.get(link.ContentDocumentId).RecordType.name == GlobalConstants.UnrestrictedFileToOpportunity)
				{
					fileRecord.Restriction_Level__c = GlobalConstants.UNRESTRICTED;
				}else if(contentVersionMap.get(link.ContentDocumentId).RecordType.name == GlobalConstants.UnrestrictedFileToOther){
					fileRecord.Restriction_Level__c = GlobalConstants.NA;
				}
				if(sObjectType == GlobalConstants.OBJECT_OFFER_1)
				{
					fileRecord.ContentDocumentId__c = link.ContentDocumentId;
					fileRecord.Related_Offer__c = link.LinkedEntityId;
					fileRecord.Related_Opportunity__c = offerToOpptyMap.get(link.LinkedEntityId);
					fileRecord.Parent_Account__c = opptyToAccMap.get(offerToOpptyMap.get(link.LinkedEntityId));
					fileRecordList.add(fileRecord);
				}else if(sObjectType == GlobalConstants.OBJECT_OPPORTUNITY) {
					fileRecord.ContentDocumentId__c = link.ContentDocumentId;
					system.debug('link.ContentDocumentId>>>'+link.ContentDocumentId);
					fileRecord.Related_Opportunity__c = link.LinkedEntityId;
					fileRecord.Parent_Account__c = opptyToAccMap.get(link.LinkedEntityId);
					fileRecordList.add(fileRecord);
				}else if(sObjectType == GlobalConstants.OBJECT_ACCOUNT){
					fileRecord.ContentDocumentId__c = link.ContentDocumentId;
					fileRecord.Parent_Account__c = link.LinkedEntityId;
					fileRecordList.add(fileRecord);
				}
				//fileRecordList.add(fileRecord);
			}
			for(File_Report__c fileReport : fileRecordList){
				system.debug('fileRecordListToInsert>>>'+fileRecord.Restriction_Level__c);
				if(fileRecord.Restriction_Level__c != GlobalConstants.NA){
					fileRecordListToInsert.add(fileReport);
				}
			}
			system.debug('fileRecordListToInsert>>>'+fileRecordListToInsert);
			if(!fileRecordList.isEmpty())
			{
				Database.insert(fileRecordListToInsert, false);
			}
			else
			{
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.createFileRecord);
		}

	}
	/*Method Name: Sharecqfileto_CqReport
*Description: This method is used to share files from Quote/Proposal to Cq_Reporting
*Parameters:  ContentDocumentLink List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static void Sharecqfileto_CqReport(List<ContentDocumentLink> contentDocLinkList){

		try{

			set<id> entityID = new set<id>();
			set<ContentDocumentLink> QuotecontentDOcumentset = new set<ContentDocumentLink>();
			//Commenting Unused Variable
			//List<ContentDocumentLink> QuotecontentDOcumentset_Insert = new List<ContentDocumentLink>();
			List<ContentDocumentLink> CQAdmin_insert = new List<ContentDocumentLink>();
			map<String,string> QuoteReporting_map=new map<String,string>();
			map<Id,Id> Quote_File_map=new map<Id,Id>();
			id cqadmingroup;

			list<collaborationgroup> CQadminlist = [select id from collaborationgroup where name = :GlobalConstants.CQ_Business_Admin_group];

			if(CQadminlist.size() > 0){
				cqadmingroup = CQadminlist[0].id;
			}

			for(ContentDocumentLink c_dlink :contentDocLinkList){
				system.debug('sName-->'+c_dlink.LinkedEntityId.getSObjectType().getDescribe().getName());
				if(c_dlink.LinkedEntityId.getSObjectType().getDescribe().getName()==GlobalConstants.QuoteProposal_API_Name){
					entityID.add(c_dlink.LinkedEntityId);
					QuotecontentDOcumentset.add(c_dlink);
					Quote_File_map.put(c_dlink.LinkedEntityId, c_dlink.ContentDocumentId);
				}
			}

			system.debug('QuotecontentDOcumentset--->'+QuotecontentDOcumentset);

			for(Apttus_Proposal__Proposal__c Quote:[select id,NokiaCPQ_Proposal_Id__c,RecordTypeId,RecordType.Name,Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c
													where id IN:entityID and ((RecordType.DeveloperName = :GlobalConstants.QuoteProposal_RecordType_1) or (RecordType.DeveloperName = :GlobalConstants.QuoteProposal_RecordType_2))])
			{
				QuoteReporting_map.put(Quote.ID,Quote.NokiaCPQ_Proposal_Id__c);
				if(Quote_File_map.get(Quote.id) <> null){
					//Account_File_map.put(Quote.Apttus_Proposal__Account__c,Quote_File_map.get(Quote.id));
					ContentDocumentLink cdlink_rec = new ContentDocumentLink();
					cdlink_rec.sharetype = GlobalConstants.sharetype_c;
					cdlink_rec.LinkedEntityId = cqadmingroup;
					cdlink_rec.ContentDocumentId = Quote_File_map.get(Quote.id);

					CQAdmin_insert.add(cdlink_rec);
				}

			}

			database.SaveResult[] linkinsert = database.insert(CQAdmin_insert, false);
			system.debug('linkinsert:' + linkinsert);
			//this method is to insert files to CQ_reporting from their corresponding Quote/Proposal Object
			FileShareFromCqToReport(QuotecontentDOcumentset,QuoteReporting_map);
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Integration_API_Only_Profile)){
				System.debug('QuotecontentDOcumentset-->'+QuotecontentDOcumentset);
				System.debug('Quote_map-->'+QuoteReporting_map);
				UpdateDocumentType_ContentVersion(QuotecontentDOcumentset,QuoteReporting_map);

			}

		}catch(Exception ex){
			System.debug('Exception1-->'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.Sharecqfileto_CqReport);
		}
	}

	/*Method Name: UpdateDocumentType_ContentVersion
*Description: This method is used to update Document Type field in ContentVersion Object
*Parameters:  ContentDocumentLink List
*Created By: Accenture - May 2019
*Last Modified By: Accenture
*Last Modified Date: 09-05-2019
*******************************/

	public static void UpdateDocumentType_ContentVersion(Set<ContentDocumentLink> contentDocIdSet, Map<String,string> Quote_map){

		System.debug('contentDocIdSet-->'+contentDocIdSet);
		System.debug('Quote_map-->'+Quote_map);

		List<ContentVersion> cvupdate=new List<ContentVersion>();
		set<Id> cDidSet=new Set<Id>();
		try{
			for(ContentDocumentLink CD:contentDocIdSet)
				if(Quote_map.containskey(CD.LinkedEntityId))
				cDidSet.add(CD.ContentDocumentid);

			for(ContentVersion cv:[Select Id,Document_Type_POC__c,ContentDocumentid From ContentVersion Where ContentDocumentid in :cDidSet]){
				System.debug('cv-->'+cv);
				cv.Document_Type_POC__c=GlobalConstants.Quote_Document;
				cv.sharingoption = GlobalConstants.shareoption_restricted;  //Restricts users from sharing file
				cvupdate.add(cv);
			}
			If(!cvupdate.isempty()){
				System.debug('cvupdate-->'+cvupdate);
				database.SaveResult[] Sr= database.update(cvupdate);
				System.debug('database.update(cvupdate)-->'+Sr);
			}
		}catch(Exception ex){
			System.debug('Exception-->'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.UpdateDocumentType_ContentVersion);
		}

	}

	/*Method Name: FileShareFromCqToReport
*Description: This method is used to share files from Quote/Proposal to Cq_Reporting
*Parameters:  ContentDocumentLink List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static void FileShareFromCqToReport(Set<ContentDocumentLink> Quote_content_Doc_set, Map<String,string> QuoteRep_map){
		try{
			system.debug('Q_set'+Quote_content_Doc_set);
			system.debug('Q_map'+QuoteRep_map);
			List<ContentDocumentLink> QuotecontentDOcument_Insert = new List<ContentDocumentLink>();
			for(Surround_CQ_Reporting__c Quotereport:[select id,CQ_Number__C from Surround_CQ_Reporting__c where CQ_Number__C IN : QuoteRep_map.values()])
				QuoteRep_map.put(Quotereport.CQ_Number__C,Quotereport.id);

			for(ContentDocumentLink cq_dlink :Quote_content_Doc_set){
				string  quoteNumber= QuoteRep_map.containskey(cq_dlink.LinkedEntityId)?  QuoteRep_map.get(cq_dlink.LinkedEntityId):null;
				string quoteReporting_ID= quoteNumber<>null&& QuoteRep_map.containskey(quoteNumber) ? QuoteRep_map.get(quoteNumber):null;
				if(quoteReporting_ID<>null)
				{
					ContentDocumentLink Cont_DocLink=new ContentDocumentLink();
					Cont_DocLink.LinkedEntityId=quoteReporting_ID;
					Cont_DocLink.ShareType=GlobalConstants.FILE_SHARE_TYPE_V;
					Cont_DocLink.ContentDocumentId=cq_dlink.ContentDocumentId;
					//Cont_DocLink.Visibility=c_dlink.Visibility;
					Cont_DocLink.Visibility=GlobalConstants.ALL_USERS;
					QuotecontentDOcument_Insert.add(Cont_DocLink) ;
				}
			}
			system.debug('li_se'+QuotecontentDOcument_Insert);

			If(!QuotecontentDOcument_Insert.isempty())
				database.insert(QuotecontentDOcument_Insert,false);
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CONTENT_DOC_LINK_HELPER, GlobalConstants.File_Share_From_CqToReport);

		}
	}

	/*Method Name: throwerroronCQ_FileUpload
*Description: This method is used to throw error on uploadin files Quote/Proposal Object manually
*Parameters:  ContentDocumentLink List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static void throwerroronCQ_FileUpload(List<ContentDocumentLink> contentDocLinkList){

		List<PermissionSetAssignment> pset=new List<PermissionSetAssignment>();
		Set<id> cdset=new Set<id>();
		Set<id> set_quoteid=new Set<id>();
		Set<id> set_entityid=new Set<id>();
		Map<Id,String> cvmap=new Map<Id,String>();
		system.debug('IN-->'+contentDocLinkList);
		for(ContentDocumentLink cd:contentDocLinkList)
		{

			cdset.add(cd.ContentDocumentId);
			if(cd.LinkedEntityId.getSObjectType().getDescribe().getName()==GlobalConstants.quoteProposal){
				set_quoteid.add(cd.LinkedEntityId);
			}
			system.debug('set_quoteid-->'+set_quoteid);
			system.debug('cd.LinkedEntityId-->'+cd.LinkedEntityId);

		}

		for(Apttus_Proposal__Proposal__c qt :[select id, isCQ__c from Apttus_Proposal__Proposal__c where isCQ__c= true AND id IN: set_quoteid] )
			set_entityid.add(qt.id);

		for(ContentVersion cv:[Select ContentDocumentId,Document_Type_POC__c,RecordType.Name from ContentVersion Where ContentDocumentId In :cdset])
		{
			cvmap.put(cv.ContentDocumentId,cv.Document_Type_POC__c+GlobalConstants.Comma+cv.RecordType.Name);
		}
		system.debug('cvmap'+cvmap);
		/* pset=[Select PermissionSetId from PermissionSetAssignment
where AssigneeId =:UserInfo.getUserId()
and PermissionSet.Name=:GlobalConstants.CQ_Business_admin];*/
		Boolean hasCustomPermission = FeatureManagement.checkPermission(GlobalConstants.CQ_Business_admin);
		system.debug(pset);

		if(hasCustomPermission){

			for(ContentDocumentLink cd:contentDocLinkList)
			{
				//if(cvmap.get(cd.ContentDocumentId)==GlobalConstants.NA)
				if(set_entityid.contains(cd.LinkedEntityId)){
					if(cvmap.get(cd.ContentDocumentId).substringBefore(GlobalConstants.Comma) == GlobalConstants.NA)
						cd.addError(GlobalConstants.SelectDocType);
					else if(cvmap.get(cd.ContentDocumentId).substringAfter(GlobalConstants.Comma) != GlobalConstants.UnrestrictedFileToOther)
						cd.addError(GlobalConstants.SelectRecType);
				}
			}
		}

	}

	public static void PS_ModifyFileShareTypeAndVisibility(List<ContentDocumentLink> newRecLst){
		Map<Id, Id> caseDocMap = new Map<Id, Id>();
		String contDocLnkCaseId;
		for(ContentDocumentLink contDocLnk : newRecLst){
			contDocLnkCaseId = '';
			if(contDocLnk.LinkedEntityId != NULL)
				contDocLnkCaseId = contDocLnk.LinkedEntityId;

			if(contDocLnkCaseId.startsWith('500'))
				caseDocMap.put(contDocLnk.ContentDocumentId, contDocLnkCaseId);
		}

		if(!caseDocMap.isEmpty()){
			Map<Id, Case> caseIdMap = new Map<Id, Case>([SELECT Id FROM Case WHERE RecordType.DeveloperName = 'PS_Partner_Support' AND Id IN: caseDocMap.values()]);
			if(caseIdMap != NULL && !caseIdMap.isEmpty()){

				for(ContentDocumentLink contDocLnk : newRecLst){
					if(caseIdMap.containsKey(contDocLnk.LinkedEntityId) && caseDocMap.keySet().contains(contDocLnk.ContentDocumentId) && caseDocMap.get(contDocLnk.ContentDocumentId) == contDocLnk.LinkedEntityId){
						contDocLnk.ShareType = 'I';
						if(UserInfo.getUserType() != 'PowerPartner'){
							contDocLnk.Visibility = 'AllUsers';
						}
					}
				}
			}
		}

	}


}