/**
* @description: This class will create content version records for Account/Contact/Opportunity when file is uploaded to converstingt lead
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0	 Accenture	   02/8/2018 Sprint 7									 Doc Stretegy redesign feature.
* ============================================================================ 
*/
public without sharing class LeadConevrtDocHandler{
	public static boolean isLeadConversion = false;
	 /**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: This method will allow lead conversion whenn file is uploaded on lead
* High Level Process : PRM deal reg conersion possible when file uploaded
**********************************************************************************************************************/	
	public static void allowConvert(List<ContentDocumentLink> contentDocLinkList){
		Boolean someFailure = false;
		try{
			if(LeadConevrtDocHandler.isLeadConversion)
			return;
			LeadConevrtDocHandler.isLeadConversion = true;
			System.debug('Inside Allow Convert......');
			Set<String> requiredObjects = new Set<String>();
			List<String> documentIdList = new List<String>();
			Set<String> allVisibilityDocumentSet = new Set<string>();
			
			for(ContentDocumentLink link : contentDocLinkList){
				System.debug('Inside Allow Convert contentDocLink......'+link);
				System.debug('Inside Allow Convert contentDocLink share type......'+link.ShareType);
				System.debug('Inside Allow Convert contentDocLink share type......'+link.Visibility);
				Id contDocId = link.ContentDocumentId;
				documentIdList.add(link.ContentDocumentId);
				if(link.Visibility==GlobalConstants.ALL_USERS)
					allVisibilityDocumentSet.add(link.ContentDocumentId);
			}
			Id accountRecordType = Schema.SObjectType.ContentVersion.getRecordTypeInfosByName().get(GlobalConstants.UnrestrictedFileToAccount).getRecordTypeId();
			Id opportunityRecordType = Schema.SObjectType.ContentVersion.getRecordTypeInfosByName().get(GlobalConstants.UnrestrictedFileToOpportunity).getRecordTypeId();
			List<ContentVersion> updateVersionList = new List<ContentVersion>();
			
			Set<Id> contentDocIDset = new set<Id>();
			system.debug('SOQL Limit......'+limits.getQueries());
			List<ContentVersion> vesionList = [select Id,Title,PathOnClient,VersionData,IsMajorVersion,origin,contentdocumentId from ContentVersion where contentDocumentId in: documentIdList];
			for(ContentVersion conversion : vesionList){	
				if(!contentDocIDset.contains(conversion.contentdocumentId)){
					ContentVersion accContentVersion = new ContentVersion();
					accContentVersion.Title = conversion.Title; 
					accContentVersion.PathOnClient = conversion.PathOnClient; 
					accContentVersion.VersionData = conversion.VersionData ; 
					accContentVersion.IsMajorVersion = conversion.IsMajorVersion ;
					accContentVersion.origin = conversion.origin; 
					accContentVersion.recordtypeId = opportunityRecordType;
					if(allVisibilityDocumentSet.contains(conversion.contentdocumentId)){
						accContentVersion.Share_with_External_Users__c = true;
					}
					updateVersionList.add(accContentVersion);
					
					ContentVersion oppContentVersion = new ContentVersion();
					oppContentVersion.Title = conversion.Title; 
					oppContentVersion.PathOnClient = conversion.PathOnClient; 
					oppContentVersion.VersionData = conversion.VersionData ; 
					oppContentVersion.IsMajorVersion = conversion.IsMajorVersion ;
					oppContentVersion.origin = conversion.origin; 
					oppContentVersion.recordtypeId = accountRecordType;
					if(allVisibilityDocumentSet.contains(conversion.contentdocumentId)){
						oppContentVersion.Share_with_External_Users__c = true;
					}
					updateVersionList.add(oppContentVersion);
				}
			}
			System.debug('updateVersionList>>>>>>>>>>>>>>>>'+updateVersionList);
			Database.SaveResult[] savedResults = Database.insert(updateVersionList, false);
			for (Database.SaveResult sr : savedResults)
			{
				if (!sr.isSuccess())
				{
					someFailure = true;
					for(Database.Error err : sr.getErrors())
					{
						System.debug('err......'+err);
					}
				}
			}			
			
			Map<String,List<contentVersion>> contentVersionVsObject = new Map<String,List<contentVersion>>();
			for(contentversion conVers : [SELECT Id, ContentDocumentId,recordtypeId FROM ContentVersion where ID IN: updateVersionList]){
				System.debug('recordtypeId......'+conVers.recordtypeId);
				if(conVers.recordtypeId == accountRecordType){
					if(!contentVersionVsObject.containsKey(GlobalConstants.OBJECT_ACCOUNT)){
						contentVersionVsObject.put(GlobalConstants.OBJECT_ACCOUNT,new list<contentVersion>{conVers});
					}else{
						contentVersionVsObject.get(GlobalConstants.OBJECT_ACCOUNT).add(conVers);
					}
				}else if(conVers.recordtypeId == opportunityRecordType){
					if(!contentVersionVsObject.containsKey(GlobalConstants.OBJECT_OPPORTUNITY)){
						contentVersionVsObject.put(GlobalConstants.OBJECT_OPPORTUNITY,new list<contentVersion>{conVers});
					}else{
						contentVersionVsObject.get(GlobalConstants.OBJECT_OPPORTUNITY).add(conVers);
					}
				}
			} 
			
			for(String theObject : System.Label.Objects_For_Next_Screen_File.split(GlobalConstants.COMMAS  )){
				requiredObjects.add(theObject.trim());
			}
			
			List<ContentDocumentLink> newLinkList = new List<ContentDocumentLink>();
			List<Id> oldLinkIdList = new List<Id>();
			Integer AccCounter = GlobalConstants.INTEGER_ZERO;
			Integer oppCounter = GlobalConstants.INTEGER_ZERO; 
			for(ContentDocumentLink link : contentDocLinkList){
				String ObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getName();
				
				system.debug('ObjectType>>>>>>>>>>'+ObjectType);
				if(ObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_ACCOUNT)){
					System.debug('contentVersionVsObject.get(Account).ContentDocumentId......'+contentVersionVsObject.get(GlobalConstants.OBJECT_ACCOUNT).get(AccCounter).ContentDocumentId);
					ContentDocumentLink cl = new ContentDocumentLink();
					cl.ContentDocumentId = contentVersionVsObject.get(GlobalConstants.OBJECT_ACCOUNT).get(AccCounter).ContentDocumentId ;
					cl.linkedEntityId = link.linkedEntityId;
					cl.sharetype = GlobalConstants.FILE_SHARE_TYPE_V;
					newLinkList.add(cl);
					oldLinkIdList.add(link.Id);
					AccCounter++;
				}
				else if(ObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OPPORTUNITY)){
					System.debug('contentVersionVsObject.get(Opportunity).ContentDocumentId......'+contentVersionVsObject.get(GlobalConstants.OBJECT_OPPORTUNITY).get(oppCounter).ContentDocumentId);
					//link.ContentDocumentId = contentVersionVsObject.get(GlobalConstants.OBJECT_OPPORTUNITY).ContentDocumentId ;
					ContentDocumentLink cl = new ContentDocumentLink();
					cl.ContentDocumentId = contentVersionVsObject.get(GlobalConstants.OBJECT_OPPORTUNITY).get(oppCounter).ContentDocumentId ;
					cl.linkedEntityId = link.linkedEntityId;
					cl.sharetype = GlobalConstants.FILE_SHARE_TYPE_V;
					newLinkList.add(cl);
					oldLinkIdList.add(link.Id);
					oppCounter++;
				}else{}
			}
			if(newLinkList.size()> GlobalConstants.INTEGER_ZERO){
				database.insert(newLinkList) ;
			}
			if(oldLinkIdList.size()> GlobalConstants.INTEGER_ZERO){
				LeadConevrtDocHandler.deleteOldLink(oldLinkIdList);
			}
			ContentDocumentLinkHelper.createFileRecord(newLinkList);
		}catch(Exception ex)
		{ExceptionHandler.addException(ex, GlobalConstants.LeadConevrtDocHandler, GlobalConstants.allowConvert);}
			   
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: This method will check if lead is converted to opportunity
* High Level Process : PRM deal reg conersion possible when file uploaded
**********************************************************************************************************************/ 
	public static boolean detectLeadConvert(List<ContentDocumentLink> contentDocLinkList){
		if(LeadConevrtDocHandler.isLeadConversion)
		return true;
	
		System.debug('Inside detectLeadConvert......');
		Set<String> requiredObjects = new Set<String>();
		
		List<ContentDocumentLink> validContentDocLink = new List<ContentDocumentLink>();
		for(String theObject : System.Label.Objects_For_Next_Screen_File.split(GlobalConstants.COMMAS  )){
			requiredObjects.add(theObject.trim());
		}
		if(Math.mod(contentDocLinkList.size(),GlobalConstants.INTEGER_THREE)== GlobalConstants.INTEGER_ZERO){
		   for(ContentDocumentLink link : contentDocLinkList){
			   String ObjectType = link.LinkedEntityId.getSObjectType().getDescribe().getName();
			   System.debug('The object type......'+ObjectType);
			   if(ObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_ACCOUNT)){
				   validContentDocLink.add(link);
			   }else if(ObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_OPPORTUNITY)){
				   validContentDocLink.add(link);
			   }else if(ObjectType.equalsIgnoreCase(GlobalConstants.OBJECT_CONTACT)){
				   validContentDocLink.add(link);	
			   }
		   }
			if(Math.Mod(validContentDocLink.size(),GlobalConstants.INTEGER_THREE)== GlobalConstants.INTEGER_ZERO){
			  return true;
			}else
			   return false;
		}else{
			return false;
		}   
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: June 2018
* Description: This method will delete duplicate contentversion record
* High Level Process : PRM deal reg conersion possible when file uploaded
**********************************************************************************************************************/ 
	//@future
	public static void deleteOldLink(List<Id> contentDocLinkIdList){
		try{
			List<ContentDocumentLink> toBeDeletList = [select Id,contentDocumentId from contentDocumentLink where Id in : contentDocLinkIdList];
			
		   if(toBeDeletList.size()>0){
				delete toBeDeletList;
			}		   
			
		} catch(Exception ex)
		{ExceptionHandler.addException(ex, GlobalConstants.LeadConevrtDocHandler, GlobalConstants.deleteOldLink);}
		
	}
}