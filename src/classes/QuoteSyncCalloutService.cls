/****************************************
* Class Name : QuoteSyncCalloutService 
* Created By : Accenture
* Description : This class is used for sending data to EAI via callout
**********************/

public class QuoteSyncCalloutService  {
	
	@future(callout=true)
  Public static void SyncQuotetoEAI( Set<ID>QuoteIds,Map<Id, string> Old_Approvalstagemap,Map<Id, string> Old_QuoteNamemap,Map<Id, boolean> Old_CqActivemap,Id iLogId,string Operationtype,Boolean ISbatch)
	   { 
		  Datapreparation( QuoteIds,Old_Approvalstagemap,Old_QuoteNamemap, Old_CqActivemap,iLogId, Operationtype, ISbatch);
	   }
	
	/*****************************
*Method Name: execute
*Description: execute method of the queueable class
*Parameters:  newQuoteMap, OldQuoteMap, Ilog id and operation type
*******************/
   
	Public static boolean Datapreparation( Set<ID>QuoteIds,Map<Id, string> Old_Approvalstagemap,Map<Id, string> Old_QuoteNamemap,Map<Id, boolean> Old_CqActivemap,Id iLogId,string Operationtype,Boolean ISbatch)
	{
		Boolean issuccess=false;
		Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap_v1=new Map<Id, Apttus_Proposal__Proposal__c>();
		try{
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
																									  CQ_Lead__r.LastName,CQ_Due_Date__c
																									  from Apttus_Proposal__Proposal__c Where Id IN:QuoteIds])
			{
				if(Finalquote.Apttus_Proposal__Approval_Stage__c.equalsignorecase('Draft'))Finalquote.Apttus_Proposal__Approval_Stage__c = 'CQ Created';
				if(Finalquote.Apttus_Proposal__Approval_Stage__c.equalsignorecase('Approved'))Finalquote.Apttus_Proposal__Approval_Stage__c = 'CQ Priced'; 
				if(Finalquote.Apttus_Proposal__Approval_Stage__c.equalsignorecase('Accepted'))Finalquote.Apttus_Proposal__Approval_Stage__c = 'Submitted to Customer'; 
				if(Finalquote.Apttus_Proposal__Approval_Stage__c.equalsignorecase('Closed (Won)'))Finalquote.Apttus_Proposal__Approval_Stage__c = 'Won CQ'; 
				if(Finalquote.Apttus_Proposal__Approval_Stage__c.equalsignorecase('Closed (Not Won)'))Finalquote.Apttus_Proposal__Approval_Stage__c = 'Cancelled / Lost'; 
				if(Operationtype.endsWithIgnoreCase(Globalconstants.UPDATE_VALUE)&&Old_Approvalstagemap.containskey(Finalquote.Id))
				{
					if(Old_Approvalstagemap.get(Finalquote.Id).equalsignorecase('Draft'))Old_Approvalstagemap.put(Finalquote.Id,'CQ Created') ;
					if(Old_Approvalstagemap.get(Finalquote.Id).equalsignorecase('Approved'))Old_Approvalstagemap.put(Finalquote.Id,'CQ Priced') ; 
					if(Old_Approvalstagemap.get(Finalquote.Id).equalsignorecase('Accepted'))Old_Approvalstagemap.put(Finalquote.Id,'Submitted to Customer'); 
					if(Old_Approvalstagemap.get(Finalquote.Id).equalsignorecase('Closed (Won)'))Old_Approvalstagemap.put(Finalquote.Id,'Won CQ') ; 
					if(Old_Approvalstagemap.get(Finalquote.Id).equalsignorecase('Closed (Not Won)'))Old_Approvalstagemap.put(Finalquote.Id,'Cancelled / Lost'); 
				}
				
				newQuoteMap_v1.put(Finalquote.id,Finalquote);
			}
				 map<string,Decimal> QUotecurvalMap=CurrencyConversion(newQuoteMap_v1);
			system.debug('QUotecurvalMap-->'+QUotecurvalMap.size());
			if(!newQuoteMap_v1.isEmpty())
				issuccess=fireSync_Operation(QUotecurvalMap,newQuoteMap_v1,Old_Approvalstagemap,Old_QuoteNamemap,Old_CqActivemap,iLogId,Operationtype,ISbatch);
		}
		catch(Exception ex) {
			system.debug('Exception-->'+Ex.getMessage());
		}
		return issuccess;
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

	   for(Apttus_Proposal__Proposal__c Quote : newQuoteMap.values())
	  {
		  if(Quote_NFCmap.containskey(Quote.Id))
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
Name : fireSync_Operation
Created Date:  21 April 2019
Created by: Accenture
Description : This method will send message to EAI
*********************************************************************************************************/
	Public static boolean fireSync_Operation(map<string,Decimal> QUotecurvalMap,Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap,Map<Id, string> Old_Approvalstagemap,Map<Id, string> Old_QuoteNamemap,Map<Id, boolean> Old_CqActivemap,Id iLogId,string Operationtype,Boolean ISbatch){
		
		Boolean Issuccess=false;
		List<SFDCOfferSyncWebService.OfferEntity> quoteEntityList = new List<SFDCOfferSyncWebService.OfferEntity>();
		
		for(Apttus_Proposal__Proposal__c quote : newQuoteMap.values()){
			SFDCOfferSyncWebService.OfferEntity quoteEntity = new SFDCOfferSyncWebService.OfferEntity();
			
			quoteEntity.isCQ = 'true';
			quoteEntity.accountRefNum = quote.Apttus_Proposal__Account__r.AccountNumber;
			quoteEntity.opportunityRefNum = quote.NokiaCPQ_Opportunity_Number__c;
			quoteEntity.sfdcModifiedDate = String.valueOfGmt(quote.LastModifiedDate);
			quoteEntity.eQuote = quote.CQ_eQuote__c ? 'true' : 'false';
			quoteEntity.opportunityId = quote.Apttus_Proposal__Opportunity__c;
			quoteEntity.opportunityName =quote.Apttus_Proposal__Opportunity__r.Name;
			quoteEntity.quoteAccountSoldTo = quote.Apttus_Proposal__Account__r.QTC_Sold_To__c;
			quoteEntity.quoteCurrencyIsoCode = quote.CurrencyIsoCode;
			quoteEntity.quoteCustomerOrganizationSegment = quote.Apttus_Proposal__Account__c;
			quoteEntity.quoteCustomerOrganizationSegmentName =quote.Apttus_Proposal__Account__r.Name;
			quoteEntity.quoteCustomerProjectCode = quote.CQ_Customer_Project_Code__c;
			quoteEntity.quoteCustomerProjectSiteCity = quote.CQ_Customer_Project_Site_City__c;
			quoteEntity.quoteCustomerProjectSiteStateProvince = quote.CQ_Customer_Project_Site_State__c;
			//1quoteEntity.quoteCustomerRequestNumber = quote.Customer_Request_Number__c;
			quoteEntity.quoteDescription = quote.Apttus_Proposal__Description__c;
			quoteEntity.quoteDestinationCountry =quote.Apttus_Proposal__Account__r.CountryCode__c;
			//quoteEntity.quoteDocumentURLList = quoteURL;
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
			//quoteEntity.quoteProductList = quoteProduct;
		   quoteEntity.quoteRequestorEmail = quote.NokiaCPQ_End_Customer__r.AccountNumber;
		   quoteEntity.quoteRequestorUPI = quote.CQ_Lead__r.Nokia_ID__c;
			quoteEntity.quoteSalesLead =  quote.CQ_Sales_Lead__r.Name;
			quoteEntity.quoteSalesLeadUPI = quote.CQ_Sales_Lead__r.Nokia_ID__c;
			quoteEntity.quoteStatus = quote.Apttus_Proposal__Approval_Stage__c;
			quoteEntity.quoteSubmittedtoCustomerDate = String.valueOfGmt(quote.CQ_Submitted_to_Customer_Date__c);
			quoteEntity.quoteValue = quote.CQ_Value__c == null ? '0' : String.valueOf(quote.CQ_Value__c);
			quoteEntity.quoteValueConvertedtoEuro = quote.CQ_Value__c == null ? '0' :String.valueOf(QUotecurvalMap.containskey(quote.Id+Globalconstants.EUR)?QUotecurvalMap.get(quote.Id+Globalconstants.EUR): 0);
			quoteEntity.quoteValueConvertedtoUSD = quote.CQ_Value__c == null ? '0' :String.valueOf(QUotecurvalMap.containskey(quote.Id+Globalconstants.USD)?QUotecurvalMap.get(quote.Id+Globalconstants.USD):0);
			quoteEntity.newOfferStatus = quote.CQ_Active__c ? 'Active' : 'Inactive';
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
					if(!ISbatch)logHandledSuccessAndExceptions( newquotemap.values(), iLogId, operationType, String.valueOf(request),string.valueOf(response));
				}
				//'An unexpected exception occurred:' + 'EAI Returned Response.ReturnCode = -1'
				else if(response==null || (response!=null && response.returnCode == '-1'&&!ISbatch))
					handleUnExepectedException('An unexpected exception occurred:' + 'EAI Returned Response.ReturnCode = -1', newquotemap.values(), Old_Approvalstagemap,Old_QuoteNamemap,Old_CqActivemap, iLogId, operationType, String.valueOf(request),string.valueOf(response));	
			}
			catch(System.CalloutException calloutEx){				
				//an unhandled exception thrown means, we need to log all records in the batch as errors.
				if(!ISbatch) handleUnExepectedException(calloutEx.getMessage(), newquotemap.values(), Old_Approvalstagemap,Old_QuoteNamemap,Old_CqActivemap, iLogId, operationType, String.valueOf(request),string.valueOf(response));
			} 
			catch(Exception ex) {
				//an unhandled exception thrown means, we need to log all records in the batch as errors.
				if(!ISbatch) handleUnExepectedException(ex.getMessage(), newquotemap.values(), Old_Approvalstagemap,Old_QuoteNamemap,Old_CqActivemap, iLogId, operationType, String.valueOf(request),string.valueOf(response));								
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
	private static void logHandledSuccessAndExceptions( List<Apttus_Proposal__Proposal__c> quoteList, Id iLogId, String operationType, String interfaceRequest,string Response) {
		
		//Integer checkedErrorCount ;//= checkedExceptionRecords.size();
		// Integer totalProcessCount = quoteList.size();
		// Integer totalSuccessCount = totalProcessCount - checkedErrorCount;
		
		//Create the Interface log record
		Interface_Log__c iLog = new Interface_Log__c(Id=iLogId, Interface_Type__c=GlobalConstants.INTERFACE_LOG_QUOTE_INTERFACE_TYPE, 
													 Message_Type__c=Globalconstants.OUTBOUND,												 
													 Operation_type__c = operationType);
		// iLog.Number_of_Records_Errored__c = checkedErrorCount;
		// iLog.Number_of_Records_Success__c = totalSuccessCount;
		iLog.Number_of_Record_Processed__c = quoteList.size();
		iLog.Interface_Request_Sent__c = interfaceRequest != null && interfaceRequest.length() > 32768 ? interfaceRequest.subString(0, 32768) : interfaceRequest;
		iLog.Comment__c= Response;
		//verify what would be the status of the log record.
		//if(totalSuccessCount == totalProcessCount) 
		iLog.Status__c =Globalconstants.SUCCESS; // TODO magic constants
		// else if(checkedErrorCount == totalProcessCount) 
		//	iLog.Status__c = INTERFACE_LOG_FAILURE_STATUS; // TODO magic constants
		//else
		//   iLog.Status__c = INTERFACE_LOG_PARTIAL_STATUS;// TODO Add picklist value and in constants.
		
		//update the log record										
		Database.update(iLog);
		
		//Debug to perform test scenarios. To be removed.
		
		
	}
	/******************************************************************************************************
Name : handleUnExepectedException
Created Date:  21 April 2019
Created by: Accenture
Description : This method will handle unexpected exceptions
*********************************************************************************************************/
	private static void handleUnExepectedException(string Exception_Msg,  List<Apttus_Proposal__Proposal__c> quoteList,map<id,string> Old_Approvalstagemap,map<id,string> Old_Namemap,map<id,boolean> Old_CqActivemap, Id iLogId, String operationType, String interfaceRequest,String response) {	  
		
		//create the interface log as error, with failed error race conditions and all request as unexpected errors.		
		Interface_Log__c iLog = new Interface_Log__c(Id=iLogId,Interface_Type__c=GlobalConstants.INTERFACE_LOG_QUOTE_INTERFACE_TYPE, 
													 Message_Type__c=Globalconstants.OUTBOUND,
													 Number_of_Record_Processed__c=quoteList.size(),
													 Operation_type__c = operationType,
													 status__c= Globalconstants.FAILURE,
													 Number_of_Records_Success__c = 0,
													 Number_of_Records_Errored__c= quoteList.size(),
													 Interface_Request_Sent__c = interfaceRequest != null && interfaceRequest.length() > 32768 ? interfaceRequest.subString(0, 32768) : interfaceRequest,
															Comment__c= 'Exception message:'+'\n'+Exception_Msg+'\n\n'+'Response:'+'\n'+Response);
		
		Database.update(iLog);
	 //   CreateErrorlogCustomsetting(iLogId);
		//iterate and setup detail error logs
		List<Interface_Record_Detail_Log__c> allDetailErrorList = new List<Interface_Record_Detail_Log__c>(); 
		for(Apttus_Proposal__Proposal__c quote: quoteList) {
			Interface_Record_Detail_Log__c  detailLog = createInterfaceDetailLogRecord(quote, operationType.equals(Globalconstants.UPDATE_VALUE) ?Old_Approvalstagemap.get(quote.Id):null,operationType.equals(Globalconstants.UPDATE_VALUE) ?Old_Namemap.get(quote.Id):null, operationType.equals(Globalconstants.UPDATE_VALUE) ?Old_CqActivemap.get(quote.Id):null,Exception_Msg, GlobalConstants.INTERFACE_DETAILLOG_SYNC_ERROR, operationType,iLogId);			  
			allDetailErrorList.add(detailLog);
		}
		
		Database.insert(allDetailErrorList);
	}   
	
	/******************************************************************************************************
Name : createInterfaceDetailLogRecord
Created Date:  21 April 2019
Created by: Accenture
Description : This method will create failed interface record detail log for failed records
*********************************************************************************************************/
	private static  Interface_Record_Detail_Log__c createInterfaceDetailLogRecord(Apttus_Proposal__Proposal__c quoteRecord,  string oldQuoteapprovalstage,string oldQuoteName,Boolean OldCqActive, String errorMessage, String statusAndAction, String operationType,Id iLogId) {
		Interface_Record_Detail_Log__c recordLogDetail = new Interface_Record_Detail_Log__c();
		
		recordLogDetail.name = quoteRecord.id;
		recordLogDetail.New_Value__c = 'Id='+quoteRecord.Id+';Status='+quoteRecord.Apttus_Proposal__Approval_Stage__c+';LastModDate='+quoteRecord.LastModifiedDate+';CQNumber='+quoteRecord.NokiaCPQ_Proposal_Id__c+';Name='+quoteRecord.Apttus_Proposal__Proposal_Name__c;
		if(operationType.equals(Globalconstants.UPDATE_VALUE)){
			String activeValue = OldCqActive== true ? 'Active' : 'Inactive';
			recordLogDetail.Old_Value__c = 'Status='+oldQuoteapprovalstage+';Active='+activeValue+';Name='+oldQuoteName;
		}
		errorMessage = errorMessage.length() > 255 ? errorMessage.substring(0,255) : errorMessage;
		recordLogDetail.Error_Message__c=errorMessage;
		recordLogDetail.Status_and_Action__c=statusAndAction;
		recordLogDetail.Object_Name__c= GlobalConstants.QUOTE_PROPOSAL_OBJECT;
		recordLogDetail.Interface_Log__c= iLogId;
		return recordLogDetail;
	}
	private static  void CreateErrorlogCustomsetting(Id iLogId) {
		CQ_Sync_Quote_EAI__c CQEAI=new CQ_Sync_Quote_EAI__c();
		//CQEAI.Is_Interfacelog__c=true;
		CQEAI.Name=iLogId;
		Database.insert(CQEAI);
	}
	
	
	
}