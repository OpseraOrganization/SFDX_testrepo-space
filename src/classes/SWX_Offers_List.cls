/****************************************
 * Class Name : SWX_Offers_List
 * Created Date: 18 Nov 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Controller Class for SWX_Offers_List.cmp
 *****************************************/
	public with sharing class SWX_Offers_List{
	Static List<Apttus_Config2__ClassificationHierarchy__c> categoryHierarcyList = new List<Apttus_Config2__ClassificationHierarchy__c>();

/******************************
	*Method Name: getCurrentUserData
	*Description: This Method will get the required data for the logged in user
	********************************/
	@AuraEnabled
	public static User getCurrentUserData()
	{   
		try{
			
			return [SELECT Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		 }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_PortalDashboard, CSWXGlobalConstant.getCurrentUserData);
			return NULL;  
		 }
	}
	


	/*****************************
 *Method Name : getProposal
 *Description: This method will return Query Data   
 *Parameters: String sortField, boolean isAsc,String level1,String level2, String level3, String level5, String level6
 *Test coverage from: 
 *******************************/ 
	 @AuraEnabled
	public static List<Apttus_Proposal__Proposal__c> getProposalOnLoad()
	{
	  
	  String AnalyticsSource_CXM = CSWXGlobalConstant.AnalyticsSource;
	  String accountID = getCurrentUserData().accountId;
	  System.debug('accountID--->'+accountID);  
	  Set<String> Approval_Stage= new Set<String>();
	   Approval_stage.add( CSWXGlobalConstant.Approval_stage_accepted); 
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_withdrawn);
	  //Approval_stage.add( CSWXGlobalConstant.Approval_stage_published);
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_approved);
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_rejected);
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_publishedReady);
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_publishedInProgress);
	   
	  String Revision = CSWXGlobalConstant.revision_status;

		
	 //Analytics_Source__c = :AnalyticsSource_CXM AND removed from below query DSI-1252
	   //String sSoql = 'SELECT Id,RecordType.Name,Proposal_Recommendation_Type__c, Creation_Date__c ,NAME,Apttus_Proposal__Opportunity__r.Name,Apttus_Proposal__Approval_Stage__c,Quote_Stage__c,Apttus_Proposal__Valid_Until_Date__c,Apttus_Proposal__Proposal_Name__c From Apttus_Proposal__Proposal__c where (Analytics_Source__c = :AnalyticsSource_CXM AND (Apttus_Proposal__Approval_Stage__c =:Approval_Stage  OR  Quote_Stage__c=:Revision)AND Apttus_Proposal__Account__c =:accountID)  order by Name asc  ' ;
	  String sSoql = 'SELECT Id,RecordType.Name,Proposal_Recommendation_Type__c, Creation_Date__c ,NAME,Apttus_Proposal__Opportunity__r.Name,Apttus_Proposal__Approval_Stage__c,Quote_Stage__c,Apttus_Proposal__Valid_Until_Date__c,Apttus_Proposal__Proposal_Name__c From Apttus_Proposal__Proposal__c where (Analytics_Source__c = :AnalyticsSource_CXM AND (Apttus_Proposal__Approval_Stage__c =:Approval_Stage  OR  Quote_Stage__c=:Revision))  order by Name asc  ' ;
	 
	  integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	  sSoql += ' LIMIT :limitRows ';
	  
	  System.debug('sSoql --->'+sSoql);
		
	  list <Apttus_Proposal__Proposal__c> lstResult;
	  try {
		 lstResult = Database.query(sSoql); 
		 List < Apttus_Proposal__Proposal__c > DetailRecord = new List < Apttus_Proposal__Proposal__c > ();
 
		 for (Apttus_Proposal__Proposal__c c: lstResult) {
			DetailRecord.add(c);
		  }
		 return DetailRecord;
	  }
		catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.SWX_Offers_List,CSWXGlobalConstant.getProposalMethod);
		 return null;
	  }		
	}
	
 /*****************************
 *Method Name : getProposal
 *Description: This method will return Query Data   
 *Parameters: String sortField, boolean isAsc,String level1,String level2, String level3, String level5, String level6
 *Test coverage from: 
 *******************************/ 
	 @AuraEnabled
	public static List<String> getQuoteStages()
	{
	 try {
		  String QuoteStages = System.label.QuoteStages;
		  List<String> lstQuoteStages = QuoteStages.split(GlobalConstants.SEMICOLON);
		  return lstQuoteStages; 
	  }
		catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.SWX_Offers_List,CSWXGlobalConstant.getQuoteStages);
		 return null;
	  }  
	}

/*****************************
 *Method Name : getQuoteLevel3
 *Description: This method will return PickList Values of Level3
 *Parameters: 
 *Test coverage from: 
 *******************************/ 
	 @AuraEnabled
	public static List<String> getQuoteLevel3()
	{
	  try {
			  String QuoteLevel3 = System.label.QuoteLevel3;
			  List<String> lstQuoteLevel3 = QuoteLevel3.split(GlobalConstants.SEMICOLON);
			  return lstQuoteLevel3; 
	   }
		catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.SWX_Offers_List,CSWXGlobalConstant.getQuoteLevel3);
			 return null;
	  }  
	}	
 /*****************************
 *Method Name : getProposal
 *Description: This method will return Query Data   
 *Parameters: String sortField, boolean isAsc,String level1,String level2, String level3, String level5, String level6
 *Test coverage from: 
 *******************************/ 
	 @AuraEnabled
	public static List<Apttus_Proposal__Proposal__c> getProposal(String sortField, boolean isAsc,String level1,String level2, String level3, String level5, String level6)
	{
	  System.debug('sortField>>>>'+sortField);
	  System.debug('level1>>>>'+level1);
	  System.debug('level2>>>>'+level2);
	  System.debug('level3>>>>'+level3);
	  System.debug('level5>>>>'+level5);
	  System.debug('level6>>>>'+level6);			
		
		
	  if(level1 == CSWXGlobalConstant.All)
		   level1=GlobalConstants.WILDCARD_SEARCH;
		 // level1='%';
		 
	  if(level2 == CSWXGlobalConstant.All)
		  level2=GlobalConstants.WILDCARD_SEARCH;
		 // level2='%'; 
	   //String[] level3List = level3.split(';');
	   String[] level3List = level3.split(GlobalConstants.SEMICOLON);
		
	  //String catString = '% | '+level1+' | '+level2;
	  String catString = GlobalConstants.WILDCARD_SEARCH+' | '+level1+' | '+level2;
	  
	  Set<Id> configIdSet = new Set<Id>();
	  Set<Id> quoteSet = new Set<Id>();
	  
	  for(Apttus_Config2__LineItem__c lineItemObj:[Select Id, Apttus_Config2__ConfigurationId__c from 
												   Apttus_Config2__LineItem__c where 
												   Apttus_Config2__ClassificationHierarchy__c like :catString Limit : limits.getLimitQueryRows()]){
		configIdSet.add(lineItemObj.Apttus_Config2__ConfigurationId__c);
	  }
	  
	  String status_Finalized = CSWXGlobalConstant.statusFinalized;
	  for(Apttus_Config2__ProductConfiguration__c prdconfigObj:[Select Id,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c
															 where id in :configIdSet and Apttus_Config2__Status__c = :status_Finalized Limit : limits.getLimitQueryRows()]){
		quoteSet.add(prdconfigObj.Apttus_QPConfig__Proposald__c);
	  }
	 
	  String AnalyticsSource_CXM = CSWXGlobalConstant.AnalyticsSource;
	  Set<String> Approval_Stage= new Set<String>();
	  String accountID = getCurrentUserData().accountId;
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_accepted); 
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_withdrawn);
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_approved);
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_rejected);
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_publishedReady);
	  Approval_stage.add( CSWXGlobalConstant.Approval_stage_publishedInProgress);
	  String Revision = CSWXGlobalConstant.revision_status;
		
	  //String sSoql = 'SELECT Id,RecordType.Name,Proposal_Recommendation_Type__c, Creation_Date__c ,NAME,Apttus_Proposal__Opportunity__r.Name,Apttus_Proposal__Approval_Stage__c,Quote_Stage__c,Apttus_Proposal__Valid_Until_Date__c,Apttus_Proposal__Proposal_Name__c From Apttus_Proposal__Proposal__c where (Analytics_Source__c = :AnalyticsSource_CXM AND (Apttus_Proposal__Approval_Stage__c =:Approval_Stage OR  Quote_Stage__c=:Revision)AND Apttus_Proposal__Account__c =:accountID)';
	  String sSoql = 'SELECT Id,RecordType.Name,Proposal_Recommendation_Type__c, Creation_Date__c ,NAME,Apttus_Proposal__Opportunity__r.Name,Apttus_Proposal__Approval_Stage__c,Quote_Stage__c,Apttus_Proposal__Valid_Until_Date__c,Apttus_Proposal__Proposal_Name__c From Apttus_Proposal__Proposal__c where (Analytics_Source__c = :AnalyticsSource_CXM AND (Apttus_Proposal__Approval_Stage__c =:Approval_Stage OR  Quote_Stage__c=:Revision))';
	  
	  if(level1!=GlobalConstants.WILDCARD_SEARCH || level2!=GlobalConstants.WILDCARD_SEARCH){
		  sSoql += ' and id in :quoteSet  ';
	  }
	  
		// assigning status based on filter applied 
	  if(level6!=CSWXGlobalConstant.All){
				if(level6.equals(CSWXGlobalConstant.Approval_stage_published) ){
									String Approved =CSWXGlobalConstant.Approval_stage_approved ;
									sSoql += ' and Apttus_Proposal__Approval_Stage__c =: Approved ';
								   }else{
									   if(level6==CSWXGlobalConstant.revision_status){
										   String Revision_status= CSWXGlobalConstant.revision_status;
										   sSoql += ' and Quote_Stage__c =: Revision_status ';	
									   }else{
										   sSoql += ' and Apttus_Proposal__Approval_Stage__c = :level6 ';
									   }
								   }
	  } 
	   
	  integer allFlag=0;
	  for(integer i=0;i<level3List.size();i++){
			if(level3List.get(i)==CSWXGlobalConstant.All){
				allFlag=1;
			}
	   }
	   if(allFlag==0)
		   sSoql += ' and Level_3__c in :level3List  ';
		
		if(String.isNotBlank(level5)){
			Date level5Date=Date.valueOf(level5);
			sSoql += ' and Creation_Date__c >= :level5Date ';
	   }
		
	  if (String.isNotBlank(sortField)) {
		 sSoql += ' order by ' + sortField;
		 if (isAsc) {
			sSoql += ' asc';
		 } else {
			sSoql += ' desc';
		 }
	  }
		
	  integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	  sSoql += ' LIMIT :limitRows ';
		
	  list <Apttus_Proposal__Proposal__c> lstResult;
	  try {
		 system.debug('sSoql>>>>'+sSoql);
		 lstResult = Database.query(sSoql); 
		 List < Apttus_Proposal__Proposal__c > DetailRecord = new List < Apttus_Proposal__Proposal__c > ();
 
		 for (Apttus_Proposal__Proposal__c c: lstResult) {
			DetailRecord.add(c);
		  }
		  system.debug('DetailRecord>>>>'+DetailRecord);
		 return DetailRecord;
	  }catch (Exception ex) {
		 ExceptionHandler.addException(ex,CSWXGlobalConstant.SWX_Offers_List,CSWXGlobalConstant.getProposalMethod);
		 return null;
	  }		
	}

  /*****************************
 *Method Name : getDocumentId
 *Description: This method will return document Id   
 *Parameters: QuoteId, Title
 *Test coverage from: 
 *******************************/
	@AuraEnabled
	public static Id getDocumentId(ID QuoteID,String Title)
	{
		try {
			//List<ContentDocumentLink> cdl = [select ContentDocumentId from ContentDocumentLink where LinkedEntityId =:QuoteID];
			Set<id> contentid = new Set<id>();
			for(ContentDocumentLink cdl1 :[select ContentDocumentId from ContentDocumentLink where LinkedEntityId =:QuoteID Limit : limits.getLimitQueryRows()]){
				contentid.add(cdl1.ContentDocumentId);
			}
			ContentVersion cv  = [SELECT ContentDocumentId,Title FROM ContentVersion where title =:Title and ContentDocumentId IN:contentid Limit : limits.getLimitQueryRows()];
			return cv.ContentDocumentId;
		}
		catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.SWX_Offers_List,CSWXGlobalConstant.getDocumentIdMethod);
		   return null;
		}
		  
	}
	/*****************************
 *Method Name : getCategoryHierarcyDetails
 *Description:	
 *Parameters: QuoteId, Title
 *Test coverage from: 
 *******************************/
	@AuraEnabled
	public static List<Apttus_Config2__ClassificationHierarchy__c> getCategoryHierarcyDetails(){
		List<Apttus_Config2__ClassificationHierarchy__c> categoryList = new List<Apttus_Config2__ClassificationHierarchy__c>();
	
		try {
		categoryList = [SELECT id, 
										Name FROM Apttus_Config2__ClassificationHierarchy__c
										WHERE Name = :CSWXGlobalConstant.ProductCatalogue Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
		categoryHierarcyList = [SELECT id, 
									   Name,
									   Apttus_Config2__Level__c, 
									   Apttus_Config2__AncestorId__c, 
									   Apttus_Config2__PrimordialId__c,
									   Apttus_Config2__HierarchyId__c
									   FROM Apttus_Config2__ClassificationHierarchy__c
									   WHERE Apttus_Config2__PrimordialId__c IN: categoryList  
									   AND Apttus_Config2__Level__c = 1
									   AND Apttus_Config2__AncestorId__c IN: categoryList Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
									   
			return categoryHierarcyList;
			 }
		catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.SWX_Offers_List,CSWXGlobalConstant.getCategoryHierarcyDetails);
		 return null;
	  }  
		
									   
	}
	/*****************************
 *Method Name : getCategoryDataForSecondLevel
 *Description:	
 *Parameters: 
 *Test coverage from: 
 *******************************/
	@AuraEnabled
	public static List<Apttus_Config2__ClassificationHierarchy__c> getCategoryDataForSecondLevel(){
		List<Apttus_Config2__ClassificationHierarchy__c> categoryList = new List<Apttus_Config2__ClassificationHierarchy__c>();
		List<Apttus_Config2__ClassificationHierarchy__c> categoryHierarcyListLevel2 = new List<Apttus_Config2__ClassificationHierarchy__c>();
		try {

		categoryList = [SELECT id, 
										Name FROM Apttus_Config2__ClassificationHierarchy__c
										WHERE Name = :CSWXGlobalConstant.ProductCatalogue Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
		
		categoryHierarcyListLevel2 = [SELECT id, 
									   Name,
									   Apttus_Config2__Level__c, 
									   Apttus_Config2__AncestorId__c, 
									   Apttus_Config2__PrimordialId__c,
									   Apttus_Config2__HierarchyId__c
									   FROM Apttus_Config2__ClassificationHierarchy__c
									   WHERE Apttus_Config2__PrimordialId__c IN: categoryList  
									   AND Apttus_Config2__Level__c = 2
									   AND Apttus_Config2__AncestorId__c IN: categoryHierarcyList Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
									   
			return categoryHierarcyListLevel2;
			   }
		catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.SWX_Offers_List,CSWXGlobalConstant.getCategoryHierarcyDetails);
		 return null;
	  }  
	}

}