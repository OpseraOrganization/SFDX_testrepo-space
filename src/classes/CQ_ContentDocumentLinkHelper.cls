public without sharing class CQ_ContentDocumentLinkHelper {
	
	
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
			List<ContentDocumentLink> QuotecontentDOcumentset_Insert = new List<ContentDocumentLink>();
			List<ContentDocumentLink> CQAdmin_insert = new List<ContentDocumentLink>();
			map<String,string> QuoteReporting_map=new map<String,string>();
			map<Id,Id> Quote_File_map=new map<Id,Id>();
			map<Id,Id> Account_File_map=new map<Id,Id>();
			id cqadmingroup;
			
			list<collaborationgroup> CQadminlist = [select id from collaborationgroup where name = :GlobalConstants.CQ_Business_Admin_group];
			
			if(CQadminlist.size() > 0){ 
	cqadmingroup = CQadminlist[0].id;
			}
			for(ContentDocumentLink c_dlink :contentDocLinkList){
	
	system.debug('sName-->'+c_dlink.LinkedEntityId.getSObjectType().getDescribe().getName());
	if(c_dlink.LinkedEntityId.getSObjectType().getDescribe().getName()==GlobalConstants.QuoteProposal_API_Name){
		entityID.add(c_dlink.LinkedEntityId);
		Quote_File_map.put(c_dlink.LinkedEntityId, c_dlink.ContentDocumentId);
		QuotecontentDOcumentset.add(c_dlink);
		
	}		 
			}
			
			system.debug('QuotecontentDOcumentset--->'+QuotecontentDOcumentset);
			
			for(Apttus_Proposal__Proposal__c Quote:[select id,NokiaCPQ_Proposal_Id__c,RecordTypeId,RecordType.Name,Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c 
	where id IN:entityID and ((RecordType.DeveloperName = :GlobalConstants.QuoteProposal_RecordType_1) or (RecordType.DeveloperName = :GlobalConstants.QuoteProposal_RecordType_2) or (RecordType.DeveloperName = :GlobalConstants.CQ_New_RecordType_Edit) or (RecordType.DeveloperName = :GlobalConstants.CQ_New_RecordType_Read))])
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
			//if((!QuotecontentDOcumentset.isempty()) && (!QuoteReporting_map.isempty()))
			//System.debug('QuotecontentDOcumentset-->'+QuotecontentDOcumentset);
			//System.debug('Quote_map-->'+QuoteReporting_map);
			
			
			
		}catch(Exception ex){
			System.debug('Exception1-->'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CQ_ContentDocumentLinkHelper, GlobalConstants.Sharecqfileto_CqReport);
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
			ExceptionHandler.addException(ex, GlobalConstants.CQ_ContentDocumentLinkHelper, GlobalConstants.UpdateDocumentType_ContentVersion);
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
	system.debug('quoteReporting_ID'+quoteReporting_ID);
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
			ExceptionHandler.addException(ex, GlobalConstants.CQ_ContentDocumentLinkHelper, GlobalConstants.File_Share_From_CqToReport);
			
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
}