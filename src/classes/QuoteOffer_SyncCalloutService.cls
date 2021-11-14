/****************************************
* Class Name : QuoteOffer_SyncCalloutService 
* Created By : Accenture
* Description : This class is used for sending data to EAI via callout
**********************/

public class QuoteOffer_SyncCalloutService  {
	
	
	/*****************************
*Method Name: execute
*Description: execute method of the queueable class
*Parameters:  newQuoteMap, OldQuoteMap, Ilog id and operation type
*******************/
	@future(callout=true)
	Public static void SyncQuotetoEAI( Set<ID>QuoteIds,Map<Id, string> Old_Approvalstagemap,Map<Id, string> Old_QuoteNamemap,Map<Id, boolean> Old_CqActivemap,Id iLogId,string Operationtype,Boolean IsOffer)
	{
		Boolean issuccess=false;
		Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap_v1=new Map<Id, Apttus_Proposal__Proposal__c>();
		Map<string, string> Picklistmapping=new Map<string, string>();
		
		for(CQ_Sync_Quote_EAI__c Sync_EAI:CQ_Sync_Quote_EAI__c.getall().values())
			if(Sync_EAI.Is_CQpicklist__c)Picklistmapping.Put(Sync_EAI.Name,Sync_EAI.Message__c);
		
		for(Apttus_Proposal__Proposal__c Finalquote : [select Id,Apttus_Proposal__Account__c,CreatedDate,NokiaCPQ_Opportunity_Number__c,
													   Apttus_Proposal__Opportunity__r.Name,Apttus_Proposal__Opportunity__r.LOA_Level__c,Apttus_Proposal__Opportunity__r.StageName,
													   Apttus_Proposal__Opportunity__r.Phase_status__c,LastModifiedDate,CQ_eQuote__c,Apttus_Proposal__Opportunity__c,CurrencyIsoCode,
													   CQ_Customer_Project_Code__c,CQ_Customer_Project_Site_City__c,NokiaCPQ_OpportunityLeadBG__c,
													   CQ_Lead__c,CQ_Master_Quote__c,CQ_Master_Quote_Quantity__c,Apttus_Proposal__Proposal_Name__c,
													   CQ_Notes__c,NokiaCPQ_Proposal_Id__c,CQ_Sales_Lead__c,Apttus_Proposal__Approval_Stage__c,
													   CQ_Submitted_to_Customer_Date__c,CQ_Value__c,CQ_Active__c,CQ_eQuote_Status__c,NokiaCPQ_End_Customer__c,
													   createdbyId,CQ_Customer_Project_Site_State__c,Apttus_Proposal__Description__c,Apttus_Proposal__Account__r.AccountNumber,Apttus_Proposal__Account__r.Name,Apttus_Proposal__Account__r.CountryCode__c,
													   Apttus_Proposal__Account__r.QTC_Sold_To__c,CQ_Lead__r.Email,CQ_Lead__r.Nokia_ID__c,  CQ_Sales_Lead__r.Name,
													   CQ_Sales_Lead__r.Nokia_ID__c,NokiaCPQ_End_Customer__r.MU_GCBT_Name__c,createdby.Name,CQ_Lead__r.FirstName,
													   CQ_Lead__r.LastName,CQ_Due_Date__c,CQ_Customer_Request_Number__c,Account_Legal_Entity__c ,Account_Legal_Entity__r.Qtc_sold_to__c
													   from Apttus_Proposal__Proposal__c Where Id IN:QuoteIds])
		{
			if(Operationtype.endsWithIgnoreCase(Globalconstants.UPDATE_VALUE) && Finalquote.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(Globalconstants.CQ_STATUS_APPROVED) && (Old_Approvalstagemap.get(Finalquote.Id).equalsIgnoreCase(Globalconstants.CQ_STATUS_ACCEPTED) || Old_Approvalstagemap.get(Finalquote.Id).equalsIgnoreCase(Globalconstants.Approvalstage_won)) && Finalquote.CQ_eQuote_Status__c<> NULL && Finalquote.CQ_eQuote_Status__c.equalsIgnoreCase(Globalconstants.SUCCESS))
				Finalquote.Apttus_Proposal__Approval_Stage__c = Globalconstants.ACTIVE_STATUS;
			else if(Operationtype.endsWithIgnoreCase(Globalconstants.UPDATE_VALUE) && Finalquote.CQ_eQuote__c && Finalquote.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(Globalconstants.CQ_STATUS_APPROVED) && Finalquote.CQ_eQuote_Status__c <> NULL && Finalquote.CQ_eQuote_Status__c.equalsIgnoreCase(Globalconstants.EQUOTE_STATUS_FAILURE))
				Finalquote.Apttus_Proposal__Approval_Stage__c = 'Submitted to Customer';
			else if(Picklistmapping.containskey(Finalquote.Apttus_Proposal__Approval_Stage__c))
				Finalquote.Apttus_Proposal__Approval_Stage__c=Picklistmapping.get(Finalquote.Apttus_Proposal__Approval_Stage__c);
			
			if(Picklistmapping.containskey(Finalquote.Apttus_Proposal__Opportunity__r.StageName))
				Finalquote.Apttus_Proposal__Opportunity__r.StageName=Picklistmapping.get(Finalquote.Apttus_Proposal__Opportunity__r.StageName);
			if(Picklistmapping.containskey(Finalquote.Apttus_Proposal__Opportunity__r.Phase_status__c))
				Finalquote.Apttus_Proposal__Opportunity__r.Phase_status__c=Picklistmapping.get(Finalquote.Apttus_Proposal__Opportunity__r.Phase_status__c);
			
			if(Operationtype.endsWithIgnoreCase(Globalconstants.UPDATE_VALUE)&&Old_Approvalstagemap.containskey(Finalquote.Id))
				if(Picklistmapping.containskey(Old_Approvalstagemap.get(Finalquote.Id)))
				Old_Approvalstagemap.put(Finalquote.Id,Picklistmapping.get(Old_Approvalstagemap.get(Finalquote.Id)));
			
			newQuoteMap_v1.put(Finalquote.id,Finalquote);
		}
		map<string,Decimal> QUotecurvalMap=CurrencyConversion(newQuoteMap_v1);
		map<Id,Offer__c> Offermap=new map<Id,Offer__c>();
		
		system.debug('QUotecurvalMap-->'+QUotecurvalMap.size());
		if(!newQuoteMap_v1.isEmpty())
			issuccess=fireSync_Operation(Offermap,QUotecurvalMap,newQuoteMap_v1,Old_Approvalstagemap,Old_QuoteNamemap,Old_CqActivemap,iLogId,Operationtype,IsOffer);
		
		// return issuccess;
	}
	/******************************************************************************************************
Name : CurrencyConversion
Created Date:  21 April 2019
Created by: Accenture
Description : This method will help to convert the currency
*********************************************************************************************************/
	public static map<string,Decimal> CurrencyConversion(Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap){
		Date maxdate = system.today();
		Date mindate = system.today();
		Set<String> currencySet = new set<String>{GlobalConstants.USD,GlobalConstants.EUR};
			map<id,string> Quote_NFCmap = new map<id,string>();
		map<string,decimal> CUR_DERmap = new map<string,decimal>();
		map<string,Decimal> QUotecurvalMap=new map<string,Decimal>();
		
		for(Apttus_Proposal__Proposal__c Quote : newQuoteMap.values()){
			if(Quote.currencyisocode <> null){
				currencySet.add(Quote.currencyisocode);
				if(Quote.Createddate.date() > maxdate )maxdate = Quote.Createddate.date();
				if(Quote.Createddate.date()< mindate)mindate = Quote.Createddate.date();
			}
		}
		
		List<Nokia_Financial_Calendar__c> nokiafin_cal = new  List<Nokia_Financial_Calendar__c>([select id, End_Date__c,Start_Date__c,name from Nokia_Financial_Calendar__c
																								 where Start_Date__c <= :maxdate and End_Date__c >= :mindate]);
		
		for(Apttus_Proposal__Proposal__c Quote : newQuoteMap.values())
			for(Nokia_Financial_Calendar__c NFC : nokiafin_cal)
			if(Quote.Createddate.date() > NFC.Start_Date__c && Quote.Createddate.date() < NFC.End_Date__c)
			Quote_NFCmap.put(Quote.id,NFC.id);
		
		for( Dated_exchange_rates__c DatedExRate : [select id, exchange_rate__c, currencyisocode,DER_Period__c from Dated_exchange_rates__c
													where DER_Period__c in :Quote_NFCmap.values() and currencyisocode IN :currencySet ])
			CUR_DERmap.put(DatedExRate.DER_Period__c + DatedExRate.currencyisocode, DatedExRate.exchange_rate__c);   
		
		system.debug('Quote_NFCmap-->'+Quote_NFCmap.size());
		system.debug('CUR_DERmap-->'+CUR_DERmap.size());
		System.debug('Quote_NFCmap::> '+Quote_NFCmap);
		System.debug('CUR_DERmap::> '+CUR_DERmap);
		for(Apttus_Proposal__Proposal__c Quote : newQuoteMap.values())
		{
			if(Quote_NFCmap.containskey(Quote.Id) && Quote.CQ_Value__c <> NULL)
			{
				String Per_CUR = Quote_NFCmap.get(Quote.id) + Quote.CurrencyIsoCode;
				string per_USD= Quote_NFCmap.get(Quote.id) + GlobalConstants.USD;
				if(CUR_DERmap.containskey(Per_CUR)&&CUR_DERmap.containskey(per_USD))
				{
					QUotecurvalMap.put(Quote.id+Globalconstants.EUR,Quote.CurrencyIsoCode<>Globalconstants.EUR?(Quote.CQ_Value__c / CUR_DERmap.get(Per_CUR)).setscale(2):Quote.CQ_Value__c);
					QUotecurvalMap.put(Quote.id+Globalconstants.USD,Quote.CurrencyIsoCode<>Globalconstants.USD?((Quote.CQ_Value__c / CUR_DERmap.get(Per_CUR))* CUR_DERmap.get(per_USD)).setscale(2):Quote.CQ_Value__c);
				}
			}
		}
		
		return QUotecurvalMap;
	}
	/******************************************************************************************************
Name : SyncOffertoEAI
Created Date:  21 April 2019
Created by: Accenture
Description : This method will send message to EAI
*********************************************************************************************************/
	@future(callout=true)
	Public static void SyncOffertoEAI( Set<ID>OfferIds,Map<Id, string> Old_OfferStausmap,Map<Id, string> Old_OfferNamemap,Id iLogId,string Operationtype,Boolean Isoffer)
	{
		Boolean issuccess=false;
		map<string,Decimal> QUotecurvalMap=new map<string,Decimal>();
		Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap=new Map<Id, Apttus_Proposal__Proposal__c>();
		Map<Id, boolean> Old_CqActivemap=new Map<Id, boolean>();
		Map<string, string> Picklistmapping=new Map<string, string>();
		Map<Id, Offer__c> newofferMap = new Map<Id, Offer__c>();
		
		for(CQ_Sync_Quote_EAI__c Sync_EAI:CQ_Sync_Quote_EAI__c.getall().values())
			if(Sync_EAI.Is_CQpicklist__c)Picklistmapping.Put(Sync_EAI.Name,Sync_EAI.Message__c);
		
		for(Offer__c FinalOffer :[Select Id,Opportunity__r.Account.AccountNumber,ActiveOffer__c,Name,Offer_Number__c,Opportunity__r.Opportunity_ID__c,LastModifiedDate,Customer_Offer_Due_Date__c,
								  Opportunity__r.Account.MU_GCBT_Name__c,Opportunity__r.Account.QTC_Sold_To__c,Opportunity__r.Legal_Entity__r.QTC_Sold_To__c,Opportunity__r.Legal_Entity__c,CreatedBy.Name,LoA_Approval_Level__c,Opportunity__r.StageName,
								  Opportunity__r.Phase_Status__c from Offer__C where Id IN:OfferIds ])
		{
			if(Picklistmapping.containskey(FinalOffer.Opportunity__r.StageName))
				FinalOffer.Opportunity__r.StageName=Picklistmapping.get(FinalOffer.Opportunity__r.StageName);
			if(Picklistmapping.containskey(FinalOffer.Opportunity__r.Phase_status__c))
				FinalOffer.Opportunity__r.Phase_status__c=Picklistmapping.get(FinalOffer.Opportunity__r.Phase_status__c);
			
			newofferMap.put(FinalOffer.Id,FinalOffer);   
		}
		
		if(!newofferMap.isEmpty())
			issuccess=fireSync_Operation(newofferMap,QUotecurvalMap,newQuoteMap,Old_OfferStausmap,Old_OfferNamemap,Old_CqActivemap,iLogId,Operationtype,Isoffer);
	} 
	/******************************************************************************************************
Name : fireSync_Operation
Created Date:  21 April 2019
Created by: Accenture
Description : This method will send message to EAI
*********************************************************************************************************/
	Public static boolean fireSync_Operation(Map<Id,Offer__c> newofferMap,map<string,Decimal> QUotecurvalMap,Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap,Map<Id, string> Old_Approvalstagemap,Map<Id, string> Old_QuoteNamemap,Map<Id, boolean> Old_CqActivemap,Id iLogId,string Operationtype,Boolean ISOffer){
		
		
		Boolean Issuccess=false;
		List<SFDCOfferSyncWebService.OfferEntity> quoteEntityList = new List<SFDCOfferSyncWebService.OfferEntity>();
		if(!ISOffer){
			for(Apttus_Proposal__Proposal__c quote : newQuoteMap.values()){
				SFDCOfferSyncWebService.OfferEntity quoteEntity = new SFDCOfferSyncWebService.OfferEntity();
				quoteEntity.isCQ = 'true';
				quoteEntity.accountRefNum = quote.Apttus_Proposal__Account__r.AccountNumber;
				quoteEntity.opportunityRefNum = quote.NokiaCPQ_Opportunity_Number__c;
				quoteEntity.sfdcModifiedDate = String.valueOfGmt(quote.LastModifiedDate);
				quoteEntity.eQuote = quote.CQ_eQuote__c ? 'true' : 'false';
				quoteEntity.opportunityId = quote.Apttus_Proposal__Opportunity__c;
				quoteEntity.opportunityName =quote.Apttus_Proposal__Opportunity__r.Name;
				quoteEntity.quoteAccountSoldTo = quote.Account_Legal_Entity__r.Qtc_sold_to__c;
				quoteEntity.quoteCurrencyIsoCode = quote.CurrencyIsoCode;
				quoteEntity.quoteCustomerOrganizationSegment = quote.Apttus_Proposal__Account__c;
				quoteEntity.quoteCustomerOrganizationSegmentName =quote.Apttus_Proposal__Account__r.Name;
				quoteEntity.quoteCustomerProjectCode = quote.CQ_Customer_Project_Code__c;
				quoteEntity.quoteCustomerProjectSiteCity = quote.CQ_Customer_Project_Site_City__c;
				quoteEntity.quoteCustomerProjectSiteStateProvince = quote.CQ_Customer_Project_Site_State__c;
				quoteEntity.quoteCustomerRequestNumber = quote.CQ_Customer_Request_Number__c;
				quoteEntity.quoteDescription = quote.Apttus_Proposal__Description__c;
				quoteEntity.quoteDestinationCountry =quote.Apttus_Proposal__Account__r.CountryCode__c;
				quoteEntity.quoteDueDate = String.valueOfGmt(quote.CQ_Due_Date__c);
				quoteEntity.quoteId = quote.Id;
				quoteEntity.quoteLanguage = 'English';
				quoteEntity.quoteLeadBL = quote.NokiaCPQ_OpportunityLeadBG__c;
				quoteEntity.quoteLeadEmail =quote.CQ_Lead__r.Email;
				quoteEntity.quoteLeadUPI = quote.CQ_Lead__r.Nokia_ID__c;
				quoteEntity.quoteMasterQuote = quote.CQ_Master_Quote__c ? 'true' : 'false';
				quoteEntity.quoteMasterQuoteQuantity = String.valueOf(quote.CQ_Master_Quote_Quantity__c);
				quoteEntity.newQuoteName = quote.Apttus_Proposal__Proposal_Name__c;
				quoteEntity.quoteNotes = quote.CQ_Notes__c;
				quoteEntity.quoteNumber = quote.NokiaCPQ_Proposal_Id__c;
				quoteEntity.quoteRequestorEmail = quote.CQ_Lead__r.Email;
				quoteEntity.quoteRequestorUPI = quote.CQ_Lead__r.Nokia_ID__c;
				quoteEntity.quoteSalesLead =  quote.CQ_Sales_Lead__r.Name;
				quoteEntity.quoteSalesLeadUPI = quote.CQ_Sales_Lead__r.Nokia_ID__c;
				quoteEntity.quoteStatus = quote.Apttus_Proposal__Approval_Stage__c;
				quoteEntity.quoteSubmittedtoCustomerDate = String.valueOfGmt(quote.CQ_Submitted_to_Customer_Date__c);
				quoteEntity.quoteValue = quote.CQ_Value__c == null ? '0' : String.valueOf(quote.CQ_Value__c);
				quoteEntity.quoteValueConvertedtoEuro = quote.CQ_Value__c == null ? '0' :String.valueOf(QUotecurvalMap.containskey(quote.Id+Globalconstants.EUR)?QUotecurvalMap.get(quote.Id+Globalconstants.EUR): 0);
				quoteEntity.quoteValueConvertedtoUSD = quote.CQ_Value__c == null ? '0' :String.valueOf(QUotecurvalMap.containskey(quote.Id+Globalconstants.USD)?QUotecurvalMap.get(quote.Id+Globalconstants.USD):0);
				quoteEntity.newOfferStatus = quote.CQ_Active__c ? 'Active' : 'Inactive';
				if(quote.CQ_eQuote_Status__c<> NULL && quote.CQ_eQuote_Status__c.equalsIgnoreCase(Globalconstants.EQUOTE_STATUS_FAILURE))
					quoteEntity.eQuoteStatus = 'Failed';
				else
				quoteEntity.eQuoteStatus=quote.CQ_eQuote_Status__c;
				quoteEntity.customerL6Name=quote.NokiaCPQ_End_Customer__r.MU_GCBT_Name__c;
				quoteEntity.offerClassification=quote.Apttus_Proposal__Opportunity__r.LOA_Level__c;
				quoteEntity.opportunityPhase=quote.Apttus_Proposal__Opportunity__r.StageName;
				quoteEntity.sCRMCreatorName= quote.createdby.Name;
				quoteEntity.phaseStatus=quote.Apttus_Proposal__Opportunity__r.Phase_Status__c;
				quoteEntity.quoteLead = quote.CQ_Lead__r.FirstName+' '+quote.CQ_Lead__r.LastName;
				quoteEntity.quoteRequestorName = quote.CQ_Lead__r.FirstName+' '+quote.CQ_Lead__r.LastName; 
				
				if(operationType.equals(Globalconstants.UPDATE_VALUE)){
					quoteEntity.oldOfferStatus = Old_Approvalstagemap.get(quote.Id);
					quoteEntity.oldQuoteName = Old_QuoteNamemap.get(quote.Id);
				}
				
				quoteEntityList.add(quoteEntity);
			}
		}
		if(ISOffer){
			for(Offer__c Offer : newofferMap.values()){
				SFDCOfferSyncWebService.OfferEntity requestEntity = new SFDCOfferSyncWebService.OfferEntity();
				requestEntity.accountRefNum = Offer.Opportunity__r.Account.AccountNumber;
				requestEntity.newOfferStatus =Offer.ActiveOffer__c? 'Active':'InActive';
				requestEntity.newOfferName = Offer.Name;
				requestEntity.offerRefNum = Offer.Offer_Number__c;
				requestEntity.opportunityRefNum = Offer.Opportunity__r.Opportunity_ID__c;
				requestEntity.isCQ = 'false';
				requestEntity.sfdcModifiedDate = String.valueOfGmt(Offer.LastModifiedDate);
				requestEntity.customerOfferDueDate = String.valueOfGmt(Offer.Customer_Offer_Due_Date__c);
				requestEntity.customerL6Name =Offer.Opportunity__r.Account.MU_GCBT_Name__c;
				requestEntity.offerClassification =Offer.LoA_Approval_Level__c;
				requestEntity.opportunityPhase = Offer.Opportunity__r.StageName;
				requestEntity.sCRMCreatorName = Offer.CreatedBy.Name;
				requestEntity.phaseStatus = Offer.Opportunity__r.Phase_Status__c;
				requestEntity.quoteAccountSoldTo = Offer.Opportunity__r.Legal_Entity__r.QTC_Sold_To__c;
				if(Operationtype.equals(Globalconstants.UPDATE_VALUE)) {
					requestEntity.oldOfferStatus = Old_Approvalstagemap.get(Offer.Id);
					requestEntity.oldOfferName = Old_QuoteNamemap.get(Offer.Id);
				}
				quoteEntityList.add(requestEntity);
				
			}
		}
		if(!quoteEntityList.isEmpty()){
			
			SFDCOfferSyncWebService.EAISoapOfferSyncImpl webServiceInstance = new SFDCOfferSyncWebService.EAISoapOfferSyncImpl();
			SFDCOfferSyncWebService.OfferSyncRequest request = new SFDCOfferSyncWebService.OfferSyncRequest();
			SFDCOfferSyncWebService.SOAPResponse response;
			
			try{
				
				request.offerList = quoteEntityList;
				request.operationType = operationType;
				webServiceInstance.clientCertName_x= system.label.CQ_EAICertificateName;
				webServiceInstance.timeout_x = 120000;
				System.Debug('%%Request Sent To EAI%%'+request);
				response = webServiceInstance.syncSFDCOffers(request);
				System.Debug('%%Response received from EAI%%'+response);
				if( (response!=null && response.returnCode == '0')){
					Issuccess=true;
					logHandledSuccessAndExceptions( newofferMap.values(),newquotemap.values(), iLogId, operationType, String.valueOf(request),string.valueOf(response),isOffer);
					
				}
				//'An unexpected exception occurred:' + 'EAI Returned Response.ReturnCode = -1'
				else if(response==null || (response!=null && response.returnCode == '-1'))
					handleUnExepectedException('An unexpected exception occurred:' + 'EAI Returned Response.ReturnCode = -1',newofferMap.values(), newquotemap.values(), Old_Approvalstagemap,Old_QuoteNamemap,Old_CqActivemap, iLogId, operationType, String.valueOf(request),string.valueOf(response),IsOffer);	
			}
			catch(System.CalloutException calloutEx){  
				system.debug('CalloutException-->'+calloutEx.getMessage());
				//an unhandled exception thrown means, we need to log all records in the batch as errors.
				handleUnExepectedException(calloutEx.getMessage(),newofferMap.values(), newquotemap.values(), Old_Approvalstagemap,Old_QuoteNamemap,Old_CqActivemap, iLogId, operationType, String.valueOf(request),string.valueOf(response),IsOffer);
			} 
			catch(Exception ex) {
				system.debug('Exception-->'+ex.getMessage());
				//an unhandled exception thrown means, we need to log all records in the batch as errors.
				handleUnExepectedException(ex.getMessage(),newofferMap.values(), newquotemap.values(), Old_Approvalstagemap,Old_QuoteNamemap,Old_CqActivemap, iLogId, operationType, String.valueOf(request),string.valueOf(response),IsOffer);								
			}	 
		}
		return Issuccess;  
	}
	
	/******************************************************************************************************
Name : logHandledSuccessAndExceptions
Created Date:  21 April 2019
Created by: Accenture
Description : This method will handle successand exceptions
*********************************************************************************************************/
	private static void logHandledSuccessAndExceptions( List<Offer__C> offerList,List<Apttus_Proposal__Proposal__c> quoteList, Id iLogId, String operationType, String interfaceRequest,string Response,boolean IsOffer) {
		
		//Create the Interface log record
		Interface_Log__c iLog = new Interface_Log__c(Id=iLogId, Interface_Type__c=Isoffer?GlobalConstants.INTERFACE_LOG_OFFER_INTERFACE_TYPE:GlobalConstants.INTERFACE_LOG_QUOTE_INTERFACE_TYPE, 
													 Message_Type__c=Globalconstants.OUTBOUND,												 
													 Operation_type__c = operationType);
		
		iLog.Number_of_Record_Processed__c = quoteList.size();
		iLog.Interface_Request_Sent__c = interfaceRequest != null && interfaceRequest.length() > 32768 ? interfaceRequest.subString(0, 32768) : interfaceRequest;
		iLog.Comment__c= Response;
		iLog.Status__c =Globalconstants.SUCCESS;			 
		Database.update(iLog);
	}
	/******************************************************************************************************
Name : handleUnExepectedException
Created Date:  21 April 2019
Created by: Accenture
Description : This method will handle unexpected exceptions
*********************************************************************************************************/
	private static void handleUnExepectedException(string Exception_Msg, List<Offer__C> offerList,  List<Apttus_Proposal__Proposal__c> quoteList,map<id,string> Old_Approvalstagemap,map<id,string> Old_Namemap,map<id,boolean> Old_CqActivemap, Id iLogId, String operationType, String interfaceRequest,String response,Boolean IsOffer) {	  
		
		//create the interface log as error, with failed error race conditions and all request as unexpected errors.		
		Interface_Log__c iLog = new Interface_Log__c(Id=iLogId,Interface_Type__c=Isoffer?GlobalConstants.INTERFACE_LOG_OFFER_INTERFACE_TYPE:GlobalConstants.INTERFACE_LOG_QUOTE_INTERFACE_TYPE, 
													 Message_Type__c=Globalconstants.OUTBOUND,
													 Number_of_Record_Processed__c=Isoffer?offerList.size():quoteList.size(),
													 Operation_type__c = operationType,
													 status__c= Globalconstants.FAILURE,
													 Number_of_Records_Success__c =0,
													 Number_of_Records_Errored__c=Isoffer?offerList.size():quoteList.size(),
													 Interface_Request_Sent__c = interfaceRequest != null && interfaceRequest.length() > 32768 ? interfaceRequest.subString(0, 32768) : interfaceRequest,
													 Comment__c= 'Exception message:'+'\n'+Exception_Msg+'\n\n'+'Response:'+'\n'+Response);
		
		system.debug('system.debug(iLog);-->'+iLog);
		Database.update(iLog);
		system.debug('system.debug(iLog);-->'+iLog);
		try{
			List<Interface_Record_Detail_Log__c> allDetailErrorList = new List<Interface_Record_Detail_Log__c>(); 
			for(Apttus_Proposal__Proposal__c quote: quoteList) {
				Interface_Record_Detail_Log__c  detailLog = createInterfaceDetailLogRecord(Null,quote, operationType.equals(Globalconstants.UPDATE_VALUE) ?Old_Approvalstagemap.get(quote.Id):null,operationType.equals(Globalconstants.UPDATE_VALUE) ?Old_Namemap.get(quote.Id):null, operationType.equals(Globalconstants.UPDATE_VALUE) ?Old_CqActivemap.get(quote.Id):null,Exception_Msg, GlobalConstants.INTERFACE_DETAILLOG_SYNC_ERROR, operationType,iLogId,IsOffer);			  
				allDetailErrorList.add(detailLog);
			}
			for(Offer__C Offer: offerList) {
				Interface_Record_Detail_Log__c  detailLog = createInterfaceDetailLogRecord(Offer,Null, operationType.equals(Globalconstants.UPDATE_VALUE) ?Old_Approvalstagemap.get(Offer.Id):null,operationType.equals(Globalconstants.UPDATE_VALUE) ?Old_Namemap.get(Offer.Id):null, Null,Exception_Msg, GlobalConstants.INTERFACE_DETAILLOG_SYNC_ERROR, operationType,iLogId,IsOffer);			  
				allDetailErrorList.add(detailLog);
			}
			
			if(!allDetailErrorList.isEmpty())Database.insert(allDetailErrorList,false);
		}
		catch(Exception Ex){
			system.debug('exceptio-->'+ex.getMessage());
		}
	}   
	
	/******************************************************************************************************
Name : createInterfaceDetailLogRecord
Created Date:  21 April 2019
Created by: Accenture
Description : This method will create failed interface record detail log for failed records
*********************************************************************************************************/
	private static  Interface_Record_Detail_Log__c createInterfaceDetailLogRecord(Offer__C Offer,Apttus_Proposal__Proposal__c quoteRecord,  string oldQuoteapprovalstage,string oldQuoteName,Boolean OldCqActive, String errorMessage, String statusAndAction, String operationType,Id iLogId,Boolean ISoffer) {
		Interface_Record_Detail_Log__c recordLogDetail = new Interface_Record_Detail_Log__c();
		
		recordLogDetail.name = ISoffer?Offer.Id:quoteRecord.id;
		If(IsOffer){
			String activeValue = Offer.ActiveOffer__c?'Active':'InActive';
			recordLogDetail.New_Value__c = 'accRefNum =' +Offer.Opportunity__r.Account.AccountNumber + ';' 
				+ 'newOfferStatus ='  +activeValue + ';'
				+ 'offerName =' +Offer.Name + ';'
				+ 'offerRefNum ='+ Offer.Offer_Number__c + ';'
				+ 'opportunityRefNum =' +Offer.Opportunity__r.Opportunity_ID__c + ';'
				+ 'sfdcModifiedDate =' + String.valueOfGmt(Offer.LastModifiedDate) + ';'
				+ 'customerOfferDueDate =' +String.valueOfGmt(Offer.Customer_Offer_Due_Date__c) +';'
				+ 'customerL6Name =' +Offer.Opportunity__r.Account.MU_GCBT_Name__c +';'
				+ 'offerClassification =' +Offer.LoA_Approval_Level__c +';'
				+ 'opportunityPhase =' +Offer.Opportunity__r.StageName+';'
				+ 'sCRMCreatorName =' +Offer.CreatedBy.Name +';'
				+ 'phaseStatus =' +Offer.Opportunity__r.Phase_Status__c+';'
				+ 'quoteAccountSoldTo =' +Offer.Opportunity__r.Legal_Entity__r.QTC_Sold_To__c+';';   
			if(operationType.equals(Globalconstants.UPDATE_VALUE))
				recordLogDetail.Old_Value__c = 'Status='+oldQuoteapprovalstage+';Name='+oldQuoteName;
			
		}
		if(!IsOffer)
			recordLogDetail.New_Value__c ='Id='+quoteRecord.Id+';Status='+quoteRecord.Apttus_Proposal__Approval_Stage__c+';LastModDate='+quoteRecord.LastModifiedDate+';CQNumber='+quoteRecord.NokiaCPQ_Proposal_Id__c+';Name='+quoteRecord.Apttus_Proposal__Proposal_Name__c;
		if(operationType.equals(Globalconstants.UPDATE_VALUE)&&!IsOffer){
			String activeValue = OldCqActive== true ? 'Active' : 'Inactive';
			recordLogDetail.Old_Value__c = 'Status='+oldQuoteapprovalstage+';Active='+activeValue+';Name='+oldQuoteName;
		}
		errorMessage = errorMessage.length() > 255 ? errorMessage.substring(0,255) : errorMessage;
		recordLogDetail.Error_Message__c=errorMessage;
		recordLogDetail.Status_and_Action__c=statusAndAction;
		recordLogDetail.Object_Name__c= IsOffer?GlobalConstants.OFFER_OBJ:GlobalConstants.QUOTE_PROPOSAL_OBJECT;
		recordLogDetail.Interface_Log__c= iLogId;
		return recordLogDetail;
	}
	
	
}