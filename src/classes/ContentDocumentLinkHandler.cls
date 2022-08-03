/****
 * @description: File uploaded on Account/ Opportunity/ Offer using lightning component of sCRM. File share Logic change: Collect L7 Territory Users +Collect Opp. & Offer team users Share file with first 100 users
 *
 * =============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
 * 1.0	 Accenture	   20/1/2017 Sprint 4 Doc Stretegy & LoA requirements.
 * ============================================================================ 
 */
 
public without sharing class ContentDocumentLinkHandler
{
	public static Boolean isOwnerChanged = false;
	public static Boolean isConfidentialRecCreated = false;
	/**********************************************************************************************************************
	* author: Accenture
	* Date: June-2017
	* Param: None
	* Return: void
	* Description: ContentDocumentLink Trigger beforeInsert method
	**********************************************************************************************************************/
	public static void beforeInsert(List<ContentDocumentLink> contentDoclist)
	{
		try{	
			if(!isConfidentialRecCreated && ![SELECT IsPortalEnabled FROM User where Id =: UserInfo.getUserId() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())].IsPortalEnabled)
			{
				if(ContentDocumentLinkHelper.validateUpload(contentDoclist))
				{
					ContentDocumentLinkHelper.createConfidentialFiles(contentDoclist);
					ContentDocumentLinkHelper.shareWithAllUsers(contentDoclist);
					ContentDocumentLinkHelper.restrictNSASharing(contentDoclist);
				}
			}
			else
			{
				
			}
		}catch(System.Exception e){
			ExceptionHandler.addException(e,GlobalConstants.ContentDocumentLinkHandler,GlobalConstants.BEFORE_INSERT);
		}
	}
	
	/**********************************************************************************************************************
	* author: Accenture
	* Date: June-2017
	* Param: None
	* Return: void
	* Description: ContentDocumentLink Trigger AfterInsert method
	**********************************************************************************************************************/
	public static void afterInsert(List<ContentDocumentLink> contentDoclist)
	{
		
		//#Req: 2281  
		//Req#4710 - Updates in Sales Process based on new DocStrategy ReDesign
		//Req#4704 - Impact on PreSales based on new DocStrategy ReDesign
		//Req#4705 - PTA Signed automatically ticked
		ContentDocumentLinkHelper.determineObjectType(contentDoclist);
		System.debug('isOwnerChanged : '+isOwnerChanged);
		if(!isOwnerChanged)
		{
			isOwnerChanged = true;
			set<Id> docIds = new set<Id>();
			for(ContentDocumentLink link : contentDoclist)
			{
				docIds.add(link.ContentDocumentId);
			}
			System.debug('ownerChange docIds : '+docIds);
			if(docIds.size() > 0)
			{
				ContentDocumentLinkHelper.confidentialFileOwnerSet(docIds);
			}
		}			   
	}
	
	/**********************************************************************************************************************
	* author: Accenture
	* Date: June-2019
	* Param: List
	* Return: void
	* Description: ContentDocumentLink Trigger AfterInsert method
	**********************************************************************************************************************/
	 public static void CQ_afterInsert(List<ContentDocumentLink> contentDoclist)
	 {
		 CQ_ContentDocumentLinkHelper.Sharecqfileto_CqReport(contentDoclist);
	 }
	 
	  /**********************************************************************************************************************
	* author: Accenture
	* Date: June-2019
	* Param: List
	* Return: void
	* Description: ContentDocumentLink Trigger BeforeInsert method
	**********************************************************************************************************************/
	 public static void CQ_beforeInsert(List<ContentDocumentLink> contentDoclist)
	 {
		 if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Integration_API_Only_Profile)){
		 CQ_ContentDocumentLinkHelper.throwerroronCQ_FileUpload(contentDoclist); 
		 }	
	 }
 }