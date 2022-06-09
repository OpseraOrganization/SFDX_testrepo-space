/*******************************
Class Name: SurroundDocumentLinkHandler
Created By: Accenture -2 May 2019
Last Modified By: Accenture
Last Modified Date: 
Description: Handler Class for SurroundDocumentLink Trigger for Contracted Quote Record Type
*******************************/
public with sharing class SurroundDocumentLinkHandler {
	
	/*****************************
*Method Name: updateCQNameField
*Description: This method is used to update CQ Name and ID fields in surround document link object
*Parameters:  Quote/Proposal List
*Created By: Accenture - 2 May 2019
*Last Modified By: Accenture
*Last Modified Date: 09-04-2019
*******************************/
	public static void updateCQNameField(List<Surround_Document_Links__c> sdLinkList)
	{
		Set<String> quoteNumbers = new Set<String>();
		Map<String,Apttus_Proposal__Proposal__c> quoteMap = new Map<String,Apttus_Proposal__Proposal__c>();
		List<Apttus_Proposal__Proposal__c> quoteUpdateList = new List<Apttus_Proposal__Proposal__c>();
		List<Surround_Document_Links__c> surrDocLinks = new List<Surround_Document_Links__c>();
		try{
			for(Surround_Document_Links__c sdlink : sdLinkList){
				quoteNumbers.add(sdlink.CQ_ID__c);
			}
			
			for(Apttus_Proposal__Proposal__c quote : [Select CQ_Documents_Attached__c, NokiaCPQ_Proposal_Id__c ,CQ_eQuote_Status__c,Apttus_Proposal__Approval_Stage__c,CQ_Reporting_Link__c 
													  From Apttus_Proposal__Proposal__c
													  Where NokiaCPQ_Proposal_Id__c in :quoteNumbers
													 ])
			{
				if(quote.CQ_Documents_Attached__c <> null && quote.CQ_Documents_Attached__c <> false && !(quote.Apttus_Proposal__Approval_Stage__c==GlobalConstants.CQ_STATUS_APPROVED && quote.CQ_eQuote_Status__c==GlobalConstants.EQUOTE_STATUS_INPROGRESS)){
					quote.CQ_Documents_Attached__c = false;
					quoteUpdateList.add(quote);
				}   
				quoteMap.put(quote.NokiaCPQ_Proposal_Id__c,quote);
			}
			
			for(Surround_Document_Links__c sdlink : sdLinkList){
				//String QId=quoteMap.get(sdlink.CQ_ID__c).Id;
				//system.debug('qid'+QId);
				if(quoteMap.get(sdlink.CQ_ID__c) <> Null){
				if(quoteMap.get(sdlink.CQ_ID__c).Apttus_Proposal__Approval_Stage__c==GlobalConstants.CQ_STATUS_APPROVED && quoteMap.get(sdlink.CQ_ID__c).CQ_eQuote_Status__c==GlobalConstants.EQUOTE_STATUS_INPROGRESS )
				{
				   sdlink.addError(GlobalConstants.CQ_SDL_ERROR); 
				}
				else if(sdlink.CQ_ID__c <> null){
					sdlink.CQ_Name__c = quoteMap.get(sdlink.CQ_ID__c).Id;
					sdlink.Is_Latest__c = true;
					String path = sdlink.FIle_Path__c;
					if (path <> null){sdlink.File_Name__c = path.substringAfterLast('/');}
					sdlink.CQ_Reporting_Name__c=quoteMap.get(sdlink.CQ_ID__c).CQ_Reporting_Link__c;
				}
			  }
			  else
				  sdlink.addError(GlobalConstants.CQ_SDL_ERROR1);
			
			}
			
			
		  /*for(Surround_Document_Links__c sdocLink : [SELECT Id, Is_Latest__c 
													   FROM Surround_Document_Links__c
													   where (CQ_ID__c in :quoteNumbers or 
															  CQ_Name__c in :quoteMap.keyset())
													   AND Is_Latest__c = true])
			{
				sdocLink.Is_Latest__c = false;
				surrDocLinks.add(sdocLink);
			}*/
			if(!quoteUpdateList.isEmpty()){
				Database.update(quoteUpdateList,false);
			}
			/*if(!surrDocLinks.isEmpty()){
				Database.update(surrDocLinks,false);
			}*/
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_SURROUNDDOCUMENTLINKHANDLER, GlobalConstants.CQ_UPDATECQNAMEFIELD);
		}
		
	}
	
}