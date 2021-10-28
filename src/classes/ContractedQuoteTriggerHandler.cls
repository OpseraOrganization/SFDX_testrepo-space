/****************************************
* Trigger Name : ContractedQuoteTriggerHandler
* Created Date: 24 April 2019
* Created By : Accenture
* Modified Date: 09 Feb 2021
* Modified By : HCL Technologies
* Description : This trigger copies quote records updates from EAI and load it in to Contracted_Quote__c staging object
*********************/
public with sharing class ContractedQuoteTriggerHandler
{
	private String UPDATESTATUS_INTERFACETYPE = 'CQ UpdateQuote/Status';
	private String UPDATEPRICING_INTERFACETYPE = 'CQ UpdateQuote/Pricing';
	Public integer limitRows = Limits.getLimitQueryRows()- Limits.getQueryRows();
	List<Interface_log__c> ilogsList = new List<Interface_log__c>();
	
	/*****************************
	*Method Name: checkSurroundCQ
	*Description: This method is used to check whether it the quotes existing in CQ or not
	*Parameters:  Quote/Proposal List
	**********************/
	public void CheckSurroundCQ(List<Contracted_Quote__c> cqList, Map<Id, Contracted_Quote__c> cqOldMap)
	{
		Map<String, Apttus_Proposal__Proposal__c> quoteMap = new Map<String, Apttus_Proposal__Proposal__c>();
		Set<String> setQuoteNumber = new Set<String>();
		Set<String> Sdlfalsequoteset=new Set<String>();
		Set<String> surrDocQuotes = new Set<String>();
		Map<String, String> oppNumbers = new Map<String, String>();
		List<Apttus_Proposal__Proposal__c> cqUpdateStatusList = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus_Proposal__Proposal__c> cqUpdatePricingList = new List<Apttus_Proposal__Proposal__c>();
		List<Contracted_Quote__c> cqinsertList = new List<Contracted_Quote__c>();
		List<Surround_Document_Links__c> surrDocLinks = new List<Surround_Document_Links__c>();
		try
		{
			for(Contracted_Quote__c cq : cqList)
			{
				setQuoteNumber.add(cq.CQ_Number__c);
				String oppNo = cq.CQ_Number__c;
				oppNo = oppNo.substring(0, oppNo.lastIndexOf('.')).replace('.', '');
				oppNumbers.put(cq.CQ_Number__c, oppNo);
			}

			/*List<Apttus_Proposal__Proposal__c> lstApttus = [SELECT Id, 
															NokiaCPQ_Proposal_Id__c,
															eQuote_Error__c, 
															Apttus_Proposal__Approval_Stage__c, 
															CQ_Submitted_to_Customer_Date__c, 
															CQ_eQuote_Status__c, CQ_eQuote__c
															FROM Apttus_Proposal__Proposal__c
						WHERE NokiaCPQ_Proposal_Id__c IN :setQuoteNumber];
			System.debug('Apttus List: ' + lstApttus);*/													
			
			for(Apttus_Proposal__Proposal__c scq : [SELECT Id, 
													NokiaCPQ_Proposal_Id__c,
													eQuote_Error__c, 
													Apttus_Proposal__Approval_Stage__c, 
													CQ_Submitted_to_Customer_Date__c, 
													CQ_eQuote_Status__c, CQ_eQuote__c
													FROM Apttus_Proposal__Proposal__c
													WHERE NokiaCPQ_Proposal_Id__c IN :setQuoteNumber])
			{
				//System.debug('Quote Number: ' + scq.NokiaCPQ_Proposal_Id__c);
				quoteMap.put(scq.NokiaCPQ_Proposal_Id__c, scq);
			}
			for(Contracted_Quote__c quote : cqList)
			{
				//system.debug('quoteMap' + quoteMap.keySet());
				//system.debug('quote' + quote.CQ_Number__c);
				if(quoteMap.containsKey(quote.CQ_Number__c))
				{
					if(quote.eQuote_Error__c <> null && quote.eQuote_Error__c <> 'null' && !String.isBlank(quote.eQuote_Error__c))
					{
						if(cqOldMap == null || (cqOldMap <> null && quoteMap.get(quote.CQ_Number__c).eQuote_Error__c <> quote.eQuote_Error__c)){
							GlobalConstants.IS_CQUPDATESTATUSMSG = true;
							Apttus_Proposal__Proposal__c cqupdatestatus = updateQuoteStatus(quote, quoteMap);
							cqUpdateStatusList.add(cqupdatestatus); 
						}
					}
					if(quote.Surround_QTC_Code__c <> null && quote.Surround_QTC_Code__c <> 'null' && !String.isBlank(quote.Surround_QTC_Code__c))
					{
						  if(quoteMap.get(quote.CQ_Number__c).CQ_eQuote__c <> true || !(quoteMap.get(quote.CQ_Number__c).CQ_eQuote__c == true &&
								(quoteMap.get(quote.CQ_Number__c).CQ_eQuote_Status__c != null &&
							   quoteMap.get(quote.CQ_Number__c).CQ_eQuote_Status__c.equalsIgnoreCase(GlobalConstants.EQUOTE_STATUS_INPROGRESS))))
						  {
							  GlobalConstants.IS_CQUPDATEPRICINGMSG = true;
								   Apttus_Proposal__Proposal__c cqupdatepricing = updateQuotePricing(quote, quoteMap);
								cqUpdatePricingList.add(cqupdatepricing);
								sdlfalsequoteset.add(cqupdatepricing.Id);
						  }
					}				   
				}			   
			}
			for(Surround_Document_Links__c sdocLink : [SELECT Id, Is_Latest__c 
													   FROM Surround_Document_Links__c
													   WHERE(CQ_Name__c in :sdlfalsequoteset)
													   AND Is_Latest__c = true])
			{
				sdocLink.Is_Latest__c = false;
				surrDocLinks.add(sdocLink);
			}

			if(!cqUpdateStatusList.isEmpty())
				updateQuoteinQP(cqUpdateStatusList, UPDATESTATUS_INTERFACETYPE);
			if(!cqUpdatePricingList.isEmpty())
			{
				updateQuoteinQP(cqUpdatePricingList, UPDATEPRICING_INTERFACETYPE);
			}

			 if(!surrDocLinks.isEmpty()){
				Database.update(surrDocLinks, false);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_CONTRACTED_QUOTE_TRIGGER_HANDLER, GlobalConstants.CQ_CHECKSURROUNDCQ);
		}
	}
	
	/*****************************
	*Method Name: updateQuote
	*Description: This method checks whether it is update quote status or update quote pricing
	*Parameters:  Quote/Proposal List
	**********************/ 
	public Apttus_Proposal__Proposal__c UpdateQuoteStatus(Contracted_Quote__c cq, Map<String, Apttus_Proposal__Proposal__c> quoteMap)
	{
		Apttus_Proposal__Proposal__c CQquote = new Apttus_Proposal__Proposal__c();
		try
		{
			CQquote.Id = quoteMap.get(cq.CQ_Number__c).Id;
			CQquote.eQuote_Error__c = cq.eQuote_Error__c;
			CQquote.NokiaCPQ_Proposal_Id__c = cq.CQ_Number__c;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_CONTRACTED_QUOTE_TRIGGER_HANDLER, GlobalConstants.CQ_UPDATE_QUOTE_STATUS);
		}
		return CQquote;
	}
	
	/*****************************
	*Method Name: updateQuote
	*Description: This method checks whether it is update quote status or update quote pricing
	*Parameters:  Quote/Proposal List
	**********************/ 
	public void UpdateQuoteinQP(List<Apttus_Proposal__Proposal__c> cqList, String messageType)
	{
		String ilogName = '';
		String interfaceReqSent = '';
		String comment = '';
		List<Interface_log__c> ilogsList = new List<Interface_log__c>();
		
		try
		{
			if(!cqList.isEmpty())
			{
				List<Database.SaveResult> cqResults = Database.update(cqList, false);
				for(Integer index=0, size = cqList.size(); index < size; index++ )
				{
					if(messageType.equals(UPDATESTATUS_INTERFACETYPE)){
						ilogName = 'CQ update status success for ' + cqList[index].NokiaCPQ_Proposal_Id__c;
						interfaceReqSent = ' Quote Id: ' + cqList[index].Id + ' eQuote error :' + cqList[index].eQuote_Error__c;
					}
					else{
						ilogName = 'CQ update pricing success for ' + cqList[index].NokiaCPQ_Proposal_Id__c;
						interfaceReqSent = ' Quote Id: ' + cqList[index].Id + '\nCQ value :' + cqList[index].CQ_Value__c +
							'\nReady for Submission: ' + cqList[index].CQ_Ready_for_Submission__c + '\nInitial Pricing Date: ' + cqList[index].CQ_Initial_Pricing_Date__c
							+ '\nExpiration Date: ' + cqList[index].Apttus_Proposal__Proposal_Expiration_Date__c +
							'\nCurrency Code: ' + cqList[index].CurrencyIsoCode;
					}
					if(cqResults[index].isSuccess()){
						ilogsList.add(createSuccessInterfaceLogs(messageType, ilogName, interfaceReqSent));
					}
					else{
						for (Database.Error err : cqResults[index].getErrors()){
							comment = ' Fields: ' + err.getFields() + ' Message: ' + err.getMessage() +
											'Status Code: ' + err.getStatusCode();
						}
						ilogsList.add(createErrorInterfaceLogs(messageType, ilogName, interfaceReqSent, comment));
					}
				}
				Database.insert(ilogsList, false);
			}
			//Send email logic to be added
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_CONTRACTED_QUOTE_TRIGGER_HANDLER, GlobalConstants.CQ_UPDATEQUOTEINQP);
		}
	}
	
	/*****************************
	*Method Name: updateQuoteProposal
	*Description: This method updates record in quote/proposal based on data from EAI
	*Parameters:  Quote/Proposal List
	**********************/
	@testVisible
	private Apttus_Proposal__Proposal__c UpdateQuotePricing(Contracted_Quote__c cq, Map<String, Apttus_Proposal__Proposal__c> quoteMap)
	{
		Apttus_Proposal__Proposal__c CQquote = new Apttus_Proposal__Proposal__c();	  
		try
		{
			CQquote.Id = quoteMap.get(cq.CQ_Number__c).Id;
			CQquote.CQ_Value__c = cq.CQ_Value__c;
			CQquote.CurrencyIsoCode = cq.CurrencyIsoCode;
			CQquote.CQ_Initial_Pricing_Date__c = cq.Initial_Pricing_Date__c;
			CQquote.CQ_Ready_for_Submission__c = cq.Ready_for_Submission__c;
			CQquote.NokiaCPQ_Proposal_Id__c = cq.CQ_Number__c;
			CQquote.Apttus_Proposal__Proposal_Expiration_Date__c = cq.Expiration_Date__c;
			//CQquote.CQ_Master_Quote__c = cq.Surround_Master_Quote__c;
			CQquote.CQ_Surround_Master_Quote__c = cq.Surround_Master_Quote__c;
			CQquote.Surround_QTC_Code__c = cq.Surround_QTC_Code__c; 
			if(quoteMap.get(cq.CQ_Number__c).Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(GlobalConstants.CQ_STATUS_DRAFT))
				CQquote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.CQ_STATUS_APPROVED;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_CONTRACTED_QUOTE_TRIGGER_HANDLER, GlobalConstants.CQ_UPDATE_QUOTE_PRICING);
		}
		return CQquote;
	}   // QuoteMapping() method ends here
	
	/*****************************
	*Method Name: createInterfaceLogs
	*Description: This method creates record in interface logs for all the error record updates from EAI
	*Parameters:  Quote/Proposal List
	**********************/ 
	public Interface_log__c CreateErrorInterfaceLogs(String interfaceType, String logName, String interfaceReqSent, String comment)
	{
		Interface_log__c ilog_callout = new Interface_log__c();
		try
		{
			ilog_callout.Interface_Type__c = interfaceType ;
			ilog_callout.Message_Type__c = GlobalConstants.INBOUND;
			ilog_callout.Operation_Type__c = GlobalConstants.UPDATE_VALUE;
			ilog_callout.Interface_Request_Sent__c = interfaceReqSent;
			ilog_callout.Status__c = GlobalConstants.FAILURE;
			ilog_callout.Name = logName;   
			ilog_callout.comment__c = comment;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_CONTRACTED_QUOTE_TRIGGER_HANDLER, GlobalConstants.CQ_CREATERRORINTERFACELOGS);
		}
		return ilog_callout;
	}
	
	/*****************************
	*Method Name: createSuccessInterfaceLogs
	*Description: This method creates record in interface logs for all the success record updates from EAI
	*Parameters:  Quote/Proposal List
	**********************/ 
	public Interface_log__c CreateSuccessInterfaceLogs(String interfaceType, String logName, String interfaceReqSent)
	{
		Interface_log__c ilog_callout = new Interface_log__c();
		try
		{
			ilog_callout.Interface_Type__c = interfaceType ;
			ilog_callout.Message_Type__c = GlobalConstants.INBOUND;
			ilog_callout.Operation_Type__c = GlobalConstants.UPDATE_VALUE;
			ilog_callout.Interface_Request_Sent__c = interfaceReqSent;
			ilog_callout.Status__c = GlobalConstants.SUCCESS;
			ilog_callout.Name = logName;   
			ilog_callout.comment__c = GlobalConstants.SUCCESS;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_CONTRACTED_QUOTE_TRIGGER_HANDLER, GlobalConstants.CQ_CREATESUCCESSINTERFACELOGS);
		}
		return ilog_callout;
	}   
}