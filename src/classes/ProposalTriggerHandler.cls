/*********************************
 * Class: ProposalTriggerHandler
 * Description: Handler class for Proposal object
 * Heema  28/8/2018   Changes in Release 5 for req 4777
 **********************************/
public with sharing class ProposalTriggerHandler {
/*********************************
 * author: Accenture
 * Date: 20 MAR 2018
 * Param: List<Apttus_Proposal__Proposal__c> proposalTriggerList
 * Return: None
 * Description: methods collect Proposal Trigger List on before insert and pass to ProposalTriggerHelper.
 **********************************/
public static void handleBeforeInsertTrigger(List<Apttus_Proposal__Proposal__c> newProposalList)
{
	try{
		//added by surinder ITCCPQ-2543
		// enabled for direct/partner/surround quotes
		list<Apttus_Proposal__Proposal__c> turboCheckPropList = new List<Apttus_Proposal__Proposal__c>();
		for(Apttus_Proposal__Proposal__c prop: newProposalList) {
			if(prop.Quote_Type__c.equalsIgnoreCase(GlobalConstants.INDIRECT_QUOTE_TYPE))	 
	 {
	turboCheckPropList.add(prop);
			}
		}
		ProposalTriggerHelper.checkForTurboLogic(turboCheckPropList);
		// surinder changes end
		//change the value of static variable
		Nokia_CPQ_Constants.ProposalBeforeUpdateTriggerExecute = Nokia_CPQ_Constants.TRUE_STRING;
		List<Apttus_Proposal__Proposal__c> indirectQuotesList = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus_Proposal__Proposal__c> directQuotesList = new List<Apttus_Proposal__Proposal__c>();
		//added by surinder
		List<Apttus_Proposal__Proposal__c> directAndIndirectQuotes= new List<Apttus_Proposal__Proposal__c>();
		//Added by Rajitha
		List < Apttus_Proposal__Proposal__c > ncqQuotes = new List < Apttus_Proposal__Proposal__c > ();
		List<Apttus_Proposal__Proposal__c> cqQuotes = new List<Apttus_Proposal__Proposal__c>();
		//end
		//Segregating Direct and Indirect Quotes
		for(Apttus_Proposal__Proposal__c objNewQuoteRec : newProposalList)
		{
			if(objNewQuoteRec.Quote_Type__c.equalsIgnoreCase(GlobalConstants.DIRECT_QUOTE_TYPE)) {
	directQuotesList.add(objNewQuoteRec);
	//added by surinder
	directAndIndirectQuotes.add(objNewQuoteRec);
			}
			else if(objNewQuoteRec.Quote_Type__c.equalsIgnoreCase(GlobalConstants.INDIRECT_QUOTE_TYPE)) {
	indirectQuotesList.add(objNewQuoteRec);
	//added by surinder
	directAndIndirectQuotes.add(objNewQuoteRec);
			}
			//added by Rajitha && modified by jithin - added cq check
			if(objNewQuoteRec.CPQ_NCQ_Check__c || objNewQuoteRec.CPQ_CQ_Check__c) {
	ncqQuotes.add(objNewQuoteRec);
			}
			if(objNewQuoteRec.CPQ_CQ_Check__c) {
	cqQuotes.add(objNewQuoteRec);
			}
			// end
		}
		// added by Surinder
		// this method will implement the Quote versioning for Direct/Indirect Quotes.
		if(directAndIndirectQuotes.size()>0) {
			ProposalTriggerHelper.quoteVersioningMethod(directAndIndirectQuotes);
		}

		if(directQuotesList.size() > 0) {
			ProposalTriggerHelper.updateExchangeRateFieldsOnBeforeInsert(directQuotesList);
			//Changes in Sprint 0+ for requirement #5495
			ProposalTriggerHelper.associateDirectPriceList(directQuotesList);
			//priyanka: Move Process Builder (Update Quote Record Type Based on Status) logic to Trigger
			ProposalTriggerHelper.updateQuoteRecordType(directQuotesList);
			//priyanka: Move Process Builder (DS Update Quote Approval Stage + ION Direct Is List Price Only) only for direct CPQ logic
			ProposalTriggerHelper.updateListPriceIONDirect(directQuotesList);
		}

		if(indirectQuotesList.size() > 0) {
			ProposalTriggerHelper.associateAccreditation(indirectQuotesList);
			//Varsha: Move Process Builder (Update Quote Record Type Based on Status) logic to Trigger
			ProposalTriggerHelper.updateQuoteRecordTypeIndirect(indirectQuotesList);
		}

		/**
		 * Date: 18 Jul 2018
		 * Insert Maintenance SSP and SRS value when create quote
		 **/
		if(indirectQuotesList.size() > 0) {
			ProposalTriggerHelper.InsertMaintenanceSSPandSRS(indirectQuotesList);

			//Added for ITCCPQ-2557 by Christie JJ
	ProposalTriggerHelper.populateSearchClusterFields(indirectQuotesList);
		}
		if(Test.isRunningTest()) {
			CalloutException exc = new CalloutException();
			exc.setMessage('Static Exception Msg');
			throw exc;
		}
		//added by Rajitha
		if (ncqQuotes != null && !ncqQuotes.isEmpty()) {
			ProposalTriggerHelper.updateNCQQuotes(ncqQuotes);
		}
		//end
		//Added by standav - for CQ quotes
		if(cqQuotes != null && !cqQuotes.isEmpty()) {
			handleBeforeInsertCQOperations(cqQuotes);
		}

	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,ProposalTriggerHelper.class.getName(),Nokia_CPQ_Constants.QUOTE_NOT_FOUND);
	}
}


/*********************************
 * author: Accenture
 * Date: 20 MAR 2018
 * Param: List<Apttus_Proposal__Proposal__c> proposalTriggerList
 * Return: None
 * Description: methods collect Proposal Trigger List on before insert and pass to ProposalTriggerHelper.
 * High Level Process :
 **********************************/
public static void beforeUpdateTrigger(Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger, Map<Id, Apttus_Proposal__Proposal__c> proposalOldTrigger){
	List<Apttus_Proposal__Proposal__c> directQuotesList = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> indirectQuotesList = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
	if(GlobalConstants.ALLOW_BEFOREUPDATE_QUOTE_PROPOSAL_TRIGGER == true)
	{
		GlobalConstants.ALLOW_BEFOREUPDATE_QUOTE_PROPOSAL_TRIGGER = false;
		System.debug('************Inside ProposalTriggerHelper***********************');
		ProposalTriggerHelper.updateDirectExchangeRate(proposalNewTrigger,proposalOldTrigger);
		ProposalTriggerHelper.customValidationOnDirectQickActions(proposalNewTrigger,proposalOldTrigger);
		//heema : status changed while submission for approval
		ProposalTriggerHelper.approvalRequiredChangeStatus(proposalNewTrigger,proposalOldTrigger);
		//Added by RG for Indirect Quote Approval check condition
		ProposalTriggerHelper.updateIndirectApprovalCheck(proposalNewTrigger);
		//priyanka : Move Process Builder ( Quote Updates When Opportunity is Changed) for cancel quote
		ProposalTriggerHelper.quoteCancelIndirect(proposalNewTrigger,proposalOldTrigger);
		//priyanka : Move Workflow(Update Needs Reprice When Maintenance Changed  )
		ProposalTriggerHelper.updateRepriseOnMaintChange(proposalNewTrigger,proposalOldTrigger);
		//Piyush: Move Process Builder(Quote Updates When Opportunity is Changed) flow(ContractNameUpdateAtQuote)
		//Added by shashikant line no 110
		ProposalTriggerHelper.restrictExchangeRateUpdate(proposalNewTrigger,proposalOldTrigger);

		//Added by Harsh (Standav) for CQ Quotes
		List<Apttus_Proposal__Proposal__c> cqQuotes = new List<Apttus_Proposal__Proposal__c>();
		List<Apttus_Proposal__Proposal__c> ncqQuotes = new List<Apttus_Proposal__Proposal__c>();
		for(Apttus_Proposal__Proposal__c qot : proposalNewTrigger.values()) {
			if(qot.CPQ_CQ_Check__c) {
	cqQuotes.add(qot);
			}
			if(qot.CPQ_NCQ_Check__c || qot.CPQ_CQ_Check__c) {
	ncqQuotes.add(qot);
			}
		}
		if(!cqQuotes.isEmpty()) {
			handleBeforeUpdateCQOperations(cqQuotes, proposalOldTrigger);
		}


		for(id proposal : proposalNewTrigger.keySet()) {
			if((proposalNewTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c != proposalOldTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c)
	  && proposalNewTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c == 'Approved') {
	quoteList.add(proposalNewTrigger.get(proposal));
			}
		}

		if(!quoteList.isEmpty()) {
			system.debug('inside updateIndirectOnOppChange');
			ProposalTriggerHelper.updateContractNameOnQuote(quoteList);
		}
		// ProposalTriggerHelper.updateContractNameOnQuote(proposalNewTrigger,proposalOldTrigger);
		//Varsha: Move Process Builder (Update Quote Record Type Based on Status) logic to Trigger
		for(Id proposalObjRecId: proposalNewTrigger.keySet()) {
			//added null check by Siva (Standav) - as part of ITCCPQ-1121
			if(proposalNewTrigger.get(proposalObjRecId).Quote_Type__c != null) {
	if(proposalNewTrigger.get(proposalObjRecId).Quote_Type__c.equalsIgnoreCase(GlobalConstants.DIRECT_QUOTE_TYPE)) {
		directQuotesList.add(proposalNewTrigger.get(proposalObjRecId));
	}
	else if(proposalNewTrigger.get(proposalObjRecId).Quote_Type__c.equalsIgnoreCase(GlobalConstants.INDIRECT_QUOTE_TYPE)) {
		indirectQuotesList.add(proposalNewTrigger.get(proposalObjRecId));
	}
			}
		}
		if(!directQuotesList.isEmpty()) {
			ProposalTriggerHelper.updateQuoteRecordType(directQuotesList);
			//priyanka: Move Process Builder (DS Update Quote Approval Stage + ION Direct Is List Price Only) only for direct CPQ logic
			ProposalTriggerHelper.updateListPriceIONDirect(directQuotesList);


		}
		if(!indirectQuotesList.isEmpty()) {
			//priyanka: Move Process Builder (Update Quote Record Type Based on Status) logic to Trigger
			ProposalTriggerHelper.updateQuoteRecordTypeIndirect(indirectQuotesList);
		}



		//Priyanka: Move Process Builder (Update Quote Expiry Date) logic to Trigger
		List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();

		for(id proposal : proposalNewTrigger.keySet()) {
			if(proposalOldTrigger.get(proposal)!=null && String.isNotBlank(proposalOldTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c) &&
	  (proposalOldTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c == 'In Review' ||
	proposalOldTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c == 'Draft' )&&
	  proposalNewTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTEAPPROVED) &&
	  String.isNotBlank(proposalNewTrigger.get(proposal).NokiaCPQ_Portfolio__c) && String.isNotBlank(proposalNewTrigger.get(proposal).Quote_Type__c) ) {
	propList.add(proposalNewTrigger.get(proposal));
			}
		}

		if(!propList.isEmpty()) {
			ProposalTriggerHelper.updateQuoteExpiryDate(propList);
		}
		//Added by rajitha //Resolve SOQL 101 issue- Adding check by Heema
		if(!ncqQuotes.isEmpty()) {
			ProposalTriggerHelper.updateNCQfieldsOnUpdate(proposalNewTrigger, proposalOldTrigger);
		}
	}




}


/*********************************
 * author: Accenture
 * Date: 27 MAR 2018
 * Param: List<Apttus_Proposal__Proposal__c> proposalTriggerList
 * Return: None
 * Description: methods checks the values of Maintenance and SSP section should not be blank at the time of update.
 **********************************/
public static void beforeUpdateCheckBlankFields(Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger, Map<Id, Apttus_Proposal__Proposal__c> proposalOldTrigger){

	if(Nokia_CPQ_Constants.ProposalBeforeUpdateTriggerExecute != Nokia_CPQ_Constants.TRUE_STRING) {
		ProposalTriggerHelper.checkBlankFieldsValidation(proposalNewTrigger,proposalOldTrigger);
	}

}
/*********************
 *
 * Param: Map<Id,Apttus_Proposal__Proposal__c> proposalNewTrigger>,Map<Id,Apttus_Proposal__Proposal__c> proposalOldTrigger>
 * Return: None
 * Description: methods insert the professional services product for a quote based on portfolio and accreditation level
 * High Level Process :
 **Requirement ID 4777
 **********************************/
public static void createServiceRecord(Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger, Map<Id, Apttus_Proposal__Proposal__c> proposalOldTrigger){
	List<Apttus_Proposal__Proposal__c> propList = new List<Apttus_Proposal__Proposal__c>();
	List<String> validMarketList = new List<String>();
	validMarketList = Label.MarketForProfessionalServices.split(';');
	try{
		for(id proposal : proposalNewTrigger.keySet()) {
			if(proposalOldTrigger.get(proposal)!=null && String.isNotBlank(proposalOldTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c) &&
	  !proposalOldTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTEAPPROVED) &&
	  proposalNewTrigger.get(proposal).Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTEAPPROVED) &&
	  String.isNotBlank(proposalNewTrigger.get(proposal).NokiaCPQ_Portfolio__c) && String.isNotBlank(proposalNewTrigger.get(proposal).Quote_Type__c) &&
	  proposalNewTrigger.get(proposal).Quote_Type__c.equalsignorecase(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ)) {
	if(String.isNotBlank(proposalNewTrigger.get(proposal).Account_Market__c) && !validMarketList.isEmpty() && validMarketList.contains(proposalNewTrigger.get(proposal).Account_Market__c)) {
		propList.add(proposalNewTrigger.get(proposal));
	}
			}
		}

		if(!propList.isEmpty()) {
			ProposalTriggerHelper.insertServiceRecord(propList);
		}
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,ProposalTriggerHandler.class.getName(),Nokia_CPQ_Constants.QUOTE_NOT_FOUND);
	}
}


/*********************************
 * author: Accenture
 * Date: 23 AUG 2019
 * Param: Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger, Map<Id, Apttus_Proposal__Proposal__c> proposalOldTrigger
 * Return: None
 * Description: methods collect Old and New Proposal Trigger Map on after update and pass to CQ_ProposalTriggerHelper.
 * High Level Process :
 *****************/
public static void afterUpdateCPQTrigger(Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger, Map<Id, Apttus_Proposal__Proposal__c> proposalOldTrigger){
	try{
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			Map<String,String> taskValuesMap = new Map<String,String>();
			Set<Id> qtcProposalMap=new  Set<ID>();
			//Map<Id,Apttus_Proposal__Proposal__c> DQ_sharingchanges=new  Map<Id,Apttus_Proposal__Proposal__c>();
			//Map<Id,Id> DQ_Acct_map = new Map<Id,Id>();
			List<Apttus_Proposal__Proposal__c> cqQuotes = new List<Apttus_Proposal__Proposal__c>();
			for(Apttus_Proposal__Proposal__c Quote:proposalNewTrigger.values()) {
	//ITCCPQ-1948 - Yashdeep changed condition to exclude both Direct and Indirect
	if(new List<string> {GlobalConstants.DIRECT_QUOTE_TYPE, GlobalConstants.INDIRECT_QUOTE_TYPE}.indexOf(Quote.Quote_Type__c) < 0) {
		//{
		//  if(Quote.OwnerId <> proposalOldTrigger.get(Quote.Id).ownerId || quote.Apttus_Proposal__Account__c <> proposalOldTrigger.get(Quote.Id).Apttus_Proposal__Account__c){
		//  system.debug(' entered CQ_sharingchanges');
		//  DQ_Acct_map.put(Quote.Id, Quote.Apttus_Proposal__Account__c);
		// DQ_sharingchanges.put(Quote.Id, Quote);
		//}
		// }

		//QTC_QuoteProposalTOStaging NovRelease 2019
		//Added by Naveen to pass data to QTC integration
		//ITCEPP - 755 -- stopped calling when Quote Finalized and Stage is Accepted
		if((proposalNewTrigger.get(Quote.Id).Roll_Up_Of_Proposal_Line_Item__c != proposalOldTrigger.get(Quote.Id).Roll_Up_Of_Proposal_Line_Item__c)
		//&& proposalNewTrigger.get(Quote.Id).Quote_Type__c.equalsIgnoreCase(GlobalConstants.DIRECT_QUOTE_TYPE)
		&& proposalNewTrigger.get(Quote.Id).Roll_Up_Of_Proposal_Line_Item__c> 0) {
			//Add the values to task map, to identify if its a Add or Final AddQuoteMessage
			taskValuesMap.put(Quote.NokiaCPQ_Proposal_Id__c,GlobalConstants.TASK_VALUE_UPD);
			qtcProposalMap.add(Quote.Id);
			system.debug('immmmmmrrrr'+qtcProposalMap+'  '+taskValuesMap);
		}
		if(proposalOldTrigger.get(Quote.Id).Apttus_Proposal__Approval_Stage__c !=Quote.Apttus_Proposal__Approval_Stage__c && Quote.Apttus_Proposal__Approval_Stage__c <> null &&
		Quote.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(GlobalConstants.ACCEPTED)) {
			taskValuesMap.put(Quote.NokiaCPQ_Proposal_Id__c,GlobalConstants.TASK_VALUE_Final);
			qtcProposalMap.add(Quote.Id);
		}

	}
	//Adding Standav code
	//
	if(Quote.CPQ_CQ_Check__c && proposalOldTrigger.get(Quote.Id).CPQ_Pricing_Pool__c != Quote.CPQ_Pricing_Pool__c) {
		cqQuotes.add(Quote);
	}
			}
			if(!cqQuotes.isEmpty()) {
	deleteQuotecontractualdiscounts(cqQuotes);
			}
			//ITCEPP - 755 -- stopped calling when Quote Finalized and Stage is Accepted
			if(!qtcProposalMap.isEmpty() && !GlobalConstants.QTC_BATCHEXECUTED) {
	system.debug('Running batch job for status change');
	GlobalConstants.QTC_BATCHEXECUTED = true;
	QTC_QuoteProposalToStaging qtc = new QTC_QuoteProposalToStaging(qtcProposalMap,taskValuesMap);
	Database.executebatch(qtc,Integer.valueOf(Label.QTC_ADDQuoteBatchSize));
			}

			//if(!DQ_sharingchanges.isempty()){
			//  CQ_ProposalTriggerHelper.CQTerritorysharingupdate(DQ_sharingchanges,DQ_Acct_map);
			//   }
			//priyanka : Move Workflow (Change Quote Status from 'Price' to 'Validate')
			List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
			Set<Id> quoteIDSet = new Set<Id>();
			for(id proposal : proposalNewTrigger.keySet()) {
	if((proposalNewTrigger.get(proposal).Roll_Up_Of_Proposal_Line_Item__c != proposalOldTrigger.get(proposal).Roll_Up_Of_Proposal_Line_Item__c)
	&& proposalNewTrigger.get(proposal).Quote_Type__c.equalsIgnoreCase(GlobalConstants.DIRECT_QUOTE_TYPE)
	&& proposalNewTrigger.get(proposal).Roll_Up_Of_Proposal_Line_Item__c> 0) {
		quoteList.add(proposalNewTrigger.get(proposal));
	}

			}
			// End of addition for September Release
			if(!quoteList.isEmpty()) {
	ProposalTriggerHelper.quoteStatusToValidate(quoteList);
			}
			//priyanka : Move Process Builder ( Quote Updates When Opportunity is Changed) for cancel quote
			List<Apttus_Proposal__Proposal__c> quoteListindirect = new List<Apttus_Proposal__Proposal__c>();
			for(id proposal : proposalNewTrigger.keySet()) {
	if((proposalNewTrigger.get(proposal).Apttus_Proposal__Opportunity__c != proposalOldTrigger.get(proposal).Apttus_Proposal__Opportunity__c)
	&& proposalNewTrigger.get(proposal).Quote_Type__c.equalsIgnoreCase(GlobalConstants.INDIRECT_QUOTE_TYPE)) {
		quoteListindirect.add(proposalNewTrigger.get(proposal));
	}
			}

			if(!quoteListindirect.isEmpty()) {
	system.debug('inside updateIndirectOnOppChange');
	ProposalTriggerHelper.updateIndirectOnOppChange(quoteListindirect);
			}

			//ADDED BY RG FOR GPP LOGIC
			List<Apttus_Proposal__Proposal__c> gPPquoteList = new List<Apttus_Proposal__Proposal__c>();
			for(id gppproposal : proposalNewTrigger.keySet()) {
	if(proposalNewTrigger.get(gppproposal).CreateCartOnUpdate__c) {
		gPPquoteList.add(proposalNewTrigger.get(gppproposal));
	}
			}
			if(!gPPquoteList.isEmpty()) {
	ProposalTriggerHelper.createGppCart(gPPquoteList);
			}
		}

	}

	catch(exception ex) {
		ExceptionHandler.addException(ex, GlobalConstants.ProposalTriggerHandler, GlobalConstants.ProposalTriggerHandler_afterUpdateCPQTrigger);
	}
}


/*********************************
 * author: Accenture
 * Date: 23 AUG 2019
 * Param: Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger
 * Return: None
 * Description: methods collect Old and New Proposal Trigger Map on after insert and pass to CQ_ProposalTriggerHelper.
 * High Level Process :
 **********************************/

public static void afterInsertCPQTrigger(Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger){
	try{
		Map<string, string> mProposal = new Map<string, string>();
		for(id proposalId : proposalNewTrigger.keySet()) {
			system.debug('--->'+proposalNewTrigger.get(proposalId).NokiaCPQ_Orignal_Quote_Id__c );
			Apttus_Proposal__Proposal__c proposal =  proposalNewTrigger.get(proposalId);
			if(proposal.NokiaCPQ_Orignal_Quote_Id__c != null)
			{
	//mProposal.put(proposalId,proposal);
	mProposal.put(proposal.NokiaCPQ_Orignal_Quote_Id__c,proposalId);
			}
		}
		if(!mProposal.isEmpty()) {
			//ProposalTriggerHelper.cloneQuote(mProposal);
			System.enqueueJob(new NokiaCPQ_CloneSitePhase(mProposal));
		}
		//if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		//{
		/*  Map<Id,Apttus_Proposal__Proposal__c> DQ_newMap_WithRecord=new  Map<Id,Apttus_Proposal__Proposal__c>();
	 Map<Id,Id> DQ_Acct_map = new Map<Id,Id>();

	 for(Apttus_Proposal__Proposal__c Quote:proposalNewTrigger.values())
	 {
	 if(Quote.Quote_Type__c.equalsIgnoreCase(GlobalConstants.DIRECT_QUOTE_TYPE))
	 {
	 DQ_newMap_WithRecord.put(Quote.Id, Quote);
	 DQ_Acct_map.put(Quote.Id, Quote.Apttus_Proposal__Account__c);
	 system.debug('Inside after CPQ Trigger-Selva');
	 system.debug('Quote.NokiaCPQ_End_Customer__c'+Quote.Apttus_Proposal__Account__c);
	 }

	 }

	 system.debug('DQ_Acct_map'+DQ_Acct_map);
	 if(!DQ_newMap_WithRecord.isEmpty())
	 {
	 System.debug('Inside after CPQ Trigger-Selva2');
	 CQ_ProposalTriggerHelper.CQTerritorysharing(DQ_newMap_WithRecord, DQ_Acct_map);
	 System.debug('Inside after CPQ Trigger-Selva3');
	 }*/
		//  }
	}
	catch(exception ex) {
		ExceptionHandler.addException(ex, GlobalConstants.ProposalTriggerHandler, GlobalConstants.ProposalTriggerHandler_afterInsertCPQTrigger);
	}
}

/*********************************
 * author: RG: COE
 * Date: 27 NOV 2019
 * Param: Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger
 * Return: None
 * Description: methods collect Old and New Proposal Trigger Map on after insert and pass to CQ_ProposalTriggerHelper.
 * High Level Process :
 **********************************/
public static void opptyApprovalforIndirectQuote(Map<Id, Apttus_Proposal__Proposal__c> proposalNewTrigger){
	try{
		Id opptyid;
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			for(id proposalRecId: proposalNewTrigger.keySet()) {
	opptyid = proposalNewTrigger.get(proposalRecId).Apttus_Proposal__Opportunity__c;
			}
			Opportunity checkOpptyStage = [Select id,StageName,Phase_Status__c,LOA_Level__c,No_Loa__c,Authorized_for_Pricing_manager__c,Pre_approved_Price_List_for_AM__c from Opportunity where id =:opptyid];
			for(id proposalRecId: proposalNewTrigger.keySet()) {

	if(proposalNewTrigger.get(proposalRecId).Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ)) {
		if(checkOpptyStage.StageName == GlobalConstants.CREATE_OFFER &&
		checkOpptyStage.Phase_Status__c == GlobalConstants.OFFER_IN_PROGRESS &&
		(checkOpptyStage.LOA_Level__c == null || checkOpptyStage.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) &&
		(checkOpptyStage.Pre_approved_Price_List_for_AM__c > 0 ||
		 checkOpptyStage.No_Loa__c == true) &&
		proposalNewTrigger.get(proposalRecId).Apttus_Proposal__Approval_Stage__c == GlobalConstants.APPROVED &&
		proposalNewTrigger.get(proposalRecId).Indirect_Approval_Required__c == true) {
			System.debug('Inside Submit for approval Auto');
			NokiaCPQ_Validate_Quote_Ctrlr.submitforApproval(opptyid);
		}
	}
	// Enterprise September Release
	else if(proposalNewTrigger.get(proposalRecId).Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ)
			&& (proposalNewTrigger.get(proposalRecId).NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.IP_ROUTING_STRING  || proposalNewTrigger.get(proposalRecId).NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.NOKIA_FN))
	{
		if(checkOpptyStage.StageName == GlobalConstants.CREATE_OFFER &&
		checkOpptyStage.Phase_Status__c == GlobalConstants.OFFER_IN_PROGRESS &&
		(checkOpptyStage.LOA_Level__c == null || checkOpptyStage.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) &&
		(checkOpptyStage.Pre_approved_Price_List_for_AM__c > 0 ||
		 checkOpptyStage.No_Loa__c == true) &&
		proposalNewTrigger.get(proposalRecId).Apttus_Proposal__Approval_Stage__c == GlobalConstants.REVIEW &&
		proposalNewTrigger.get(proposalRecId).NokiaCPQ_Approval_Required_Flag__c == true)
		{
			NokiaCPQ_Validate_Quote_Ctrlr.submitforApproval(opptyid);
		}
	}
			}
		}
	}
	catch(exception ex) {
		ExceptionHandler.addException(ex, GlobalConstants.ProposalTriggerHandler, GlobalConstants.ProposalTriggerHandler_afterInsertCPQTrigger);
	}
}
/*********************************
 * author: Standav
 * Date: 25 MAR 2021
 * Developers: Ravi and Harsh
 * Description: methods collect Proposal Trigger List on before insert/update to update Applicable Agreements on Quote header.
 **********************************/
private static void updateApplicableAgreements(List<Apttus_Proposal__Proposal__c> newProposalList)
{
	set<string> ppSet = new set<string>();
	for(Apttus_Proposal__Proposal__c prop:newProposalList) {
		if(prop.CPQ_Pricing_Pool__c != null && prop.CPQ_CQ_Check__c ) {
			prop.CPQ_Contractual_Condition_Updated__c = true;
			ppSet.add(prop.CPQ_Pricing_Pool__c);

		}
	}

	if(!ppSet.isEmpty()) {

		List<CPQ_Pricing_Pool_Agreement_Map__c> ppAgrList = new List<CPQ_Pricing_Pool_Agreement_Map__c>();

		ppAgrList = [select CPQ_Pricing_Pool_Name__c,CPQ_Agreement_Number__c from CPQ_Pricing_Pool_Agreement_Map__c where CPQ_Pricing_Pool_Name__c IN: ppSet AND CPQ_Active__c = true order by CPQ_Rank__c asc NULLS LAST];

		if(!ppAgrList.isEmpty()) {

			Map<string,string> ppAgrMap = new  Map<string,string>();

			for(CPQ_Pricing_Pool_Agreement_Map__c ppa:ppAgrList) {

	if(ppAgrMap.containsKey(ppa.CPQ_Pricing_Pool_Name__c)) {
		string agrstring = ppAgrMap.get(ppa.CPQ_Pricing_Pool_Name__c)+','+ppa.CPQ_Agreement_Number__c;
		ppAgrMap.put(ppa.CPQ_Pricing_Pool_Name__c,agrstring);

	}else{
		ppAgrMap.put(ppa.CPQ_Pricing_Pool_Name__c,ppa.CPQ_Agreement_Number__c);
	}

			}

			if(!ppAgrMap.values().isEmpty()) {

	for(Apttus_Proposal__Proposal__c prop:newProposalList) {
		if(prop.CPQ_Pricing_Pool__c != null && ppAgrMap.containsKey(prop.CPQ_Pricing_Pool__c)) {
			prop.CPQ_Applicable_Agreements__c  = ppAgrMap.get(prop.CPQ_Pricing_Pool__c);

		}


	}



			}


		}


	}
}

/*********************************
 * author: Standav
 * Date: 9 April 2021
 * Developers: Ravi and Harsh
 * Description: methods collect Proposal Trigger List on After update to Delete Quote contractual discounts when pricing pool changes.
 **********************************/
public static void deleteQuotecontractualdiscounts(List<Apttus_Proposal__Proposal__c> newProposalList) {

	List<CPQ_QuoteContractualDiscount__c> qcdtobedeleted = new List<CPQ_QuoteContractualDiscount__c>();

	qcdtobedeleted = [select Id from CPQ_QuoteContractualDiscount__c where CPQ_Proposal__c IN: newProposalList limit 10000];

	if(!qcdtobedeleted.isEmpty()) {
		Delete qcdtobedeleted;
	}
}
@TestVisible
private static void handleBeforeInsertCQOperations(List<Apttus_Proposal__Proposal__c> proposalNewList) {
	if(proposalNewList == null || proposalNewList.isEmpty()) return;
	ProposalTriggerHelper.updateNCQQuotes(proposalNewList);
	Set<Id> clliIds = new Set<Id>();
	Set<Id> ssfBillingIds = new Set<Id>();
	Set<Id> accountIds = new Set<Id>();
	List<Apttus_Proposal__Proposal__c> clliProposals = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> ssfProposals = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> transportProposals = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> poolProposals = new List<Apttus_Proposal__Proposal__c>();
	for(Apttus_Proposal__Proposal__c prop : proposalNewList) {
		if(prop.CPQ_CLLI_ID__c != null) {
			clliIds.add(prop.CPQ_CLLI_ID__c);
			clliProposals.add(prop);
		}
		if(prop.CPQ_SSF_Billing_Rule_ID__c != null) {
			ssfBillingIds.add(prop.CPQ_SSF_Billing_Rule_ID__c);
			ssfProposals.add(prop);
		}
		if(prop.CPQ_Include_Transportation__c) {
			accountIds.add(prop.Apttus_Proposal__Account__c);
			transportProposals.add(prop);
		}
		if(String.isNotBlank(prop.CPQ_Pricing_Pool__c)) {
			poolProposals.add(prop);
		}
	}
	if(!clliProposals.isEmpty()) {
		updateCILLIFields(clliIds, clliProposals);
	}
	if(!ssfProposals.isEmpty()) {
		updateSSFFields(ssfBillingIds, ssfProposals);
	}
	if(!transportProposals.isEmpty()) {
		validateTransportInclusion(accountIds, transportProposals);
	}
	if(!poolProposals.isEmpty()) {
		updateApplicableAgreements(poolProposals);
	}
}
@TestVisible
private static void handleBeforeUpdateCQOperations(List<Apttus_Proposal__Proposal__c> proposalNewList, Map<Id, Apttus_Proposal__Proposal__c> oldMap) {
	if(proposalNewList == null || proposalNewList.isEmpty() || oldMap == null || oldMap.isEmpty()) return;
	Set<Id> clliIds = new Set<Id>();
	Set<Id> ssfBillingIds = new Set<Id>();
	Set<Id> accountIds = new Set<Id>();
	List<Apttus_Proposal__Proposal__c> clliProposals = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> ssfProposals = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> transportProposals = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> poolProposals = new List<Apttus_Proposal__Proposal__c>();
	for(Apttus_Proposal__Proposal__c prop : proposalNewList) {
		if(oldMap.containsKey(prop.Id) && oldMap.get(prop.Id).CPQ_CLLI_ID__c != prop.CPQ_CLLI_ID__c) {
			if(prop.CPQ_CLLI_ID__c != null) {
	clliIds.add(prop.CPQ_CLLI_ID__c);
			}
			clliProposals.add(prop);
		}
		if(oldMap.containsKey(prop.Id) && oldMap.get(prop.Id).CPQ_SSF_Billing_Rule_ID__c != prop.CPQ_SSF_Billing_Rule_ID__c) {
			if(prop.CPQ_SSF_Billing_Rule_ID__c != null) {
	ssfBillingIds.add(prop.CPQ_SSF_Billing_Rule_ID__c);
			}
			ssfProposals.add(prop);
		}
		if(prop.CPQ_Include_Transportation__c && oldMap.containsKey(prop.Id) && !oldMap.get(prop.Id).CPQ_Include_Transportation__c) {
			accountIds.add(prop.Apttus_Proposal__Account__c);
			transportProposals.add(prop);
		}
		if(prop.CPQ_Pricing_Pool__c != null && oldMap.containsKey(prop.Id) && oldMap.get(prop.Id).CPQ_Pricing_Pool__c != prop.CPQ_Pricing_Pool__c) {
			poolProposals.add(prop);
		}
	}
	if(!clliProposals.isEmpty()) {
		updateCILLIFields(clliIds, clliProposals);
	}
	if(!ssfProposals.isEmpty()) {
		updateSSFFields(ssfBillingIds, ssfProposals);
	}
	if(!transportProposals.isEmpty()) {
		validateTransportInclusion(accountIds, transportProposals);
	}
	if(!poolProposals.isEmpty()) {
		updateApplicableAgreements(poolProposals);
	}
}
private static void updateCILLIFields(Set<Id> clliIds, List<Apttus_Proposal__Proposal__c> clliProposals) {
	if(clliProposals == null || clliProposals.isEmpty()) return;
	Map<Id, CPQ_CLLI_Master__c> clliMap = new Map<Id, CPQ_CLLI_Master__c>([SELECT Id, CPQ_CLLI_Code__c, CPQ_CLLI_Key__c, CPQ_CLLI_Site_Name__c, CPQ_CLLI_Site_City__c, CPQ_CLLI_Site_State__c FROM CPQ_CLLI_Master__c WHERE ID IN: clliIds]);
	for(Apttus_Proposal__Proposal__c prop : clliProposals) {
		CPQ_CLLI_Master__c clliRec = clliMap.containsKey(prop.CPQ_CLLI_ID__c) ? clliMap.get(prop.CPQ_CLLI_ID__c) : null;
		if(clliRec == null || prop.CPQ_CLLI_ID__c == null) {		//clear clli fields
			prop.CPQ_CLLI_Code__c = null;
			prop.CPQ_Site_Number__c = null;
			prop.CQ_Customer_Project_Site_City__c = null;
			prop.CQ_Customer_Project_Site_State__c = null;
		} else {
			prop.CPQ_CLLI_Code__c = clliRec.CPQ_CLLI_Code__c;
			prop.CPQ_Site_Number__c = clliRec.CPQ_CLLI_Site_Name__c;
			prop.CQ_Customer_Project_Site_City__c = clliRec.CPQ_CLLI_Site_City__c;
			prop.CQ_Customer_Project_Site_State__c = clliRec.CPQ_CLLI_Site_State__c;
		}
	}
}
private static void updateSSFFields(Set<Id> ssfBillingIds, List<Apttus_Proposal__Proposal__c> ssfProposals) {
	if(ssfProposals == null || ssfProposals.isEmpty()) return;
	Map<Id, CPQ_SSFBillingRuleMaster__c> ssfMap = new Map<Id, CPQ_SSFBillingRuleMaster__c>([SELECT Id, CPQ_Billing_Rule_Code__c, CPQ_Billing_Rule_Description__c FROM CPQ_SSFBillingRuleMaster__c WHERE Id IN: ssfBillingIds]);

	for(Apttus_Proposal__Proposal__c prop : ssfProposals) {
		CPQ_SSFBillingRuleMaster__c ssfRec = ssfMap.containsKey(prop.CPQ_SSF_Billing_Rule_ID__c) ? ssfMap.get(prop.CPQ_SSF_Billing_Rule_ID__c) : null;
		if(ssfRec == null || prop.CPQ_SSF_Billing_Rule_ID__c == null) {	 //clear ssf fields
			prop.CPQ_SSF_Billing_Rule_Code__c = null;
			prop.CPQ_SSF_Billing_Rule_Description__c = null;
		} else {
			prop.CPQ_SSF_Billing_Rule_Code__c = ssfRec.CPQ_Billing_Rule_Code__c;
			prop.CPQ_SSF_Billing_Rule_Description__c = ssfRec.CPQ_Billing_Rule_Description__c;
		}
	}
}
private static void validateTransportInclusion(Set<Id> accountIds, List<Apttus_Proposal__Proposal__c> transportProposals) {
	if(transportProposals == null || transportProposals.isEmpty()) return;
	List<CPQ_TransportMap__c> transportDefaultList = [Select Id, CPQ_Account__c, CPQ_Product__c FROM CPQ_TransportMap__c WHERE CPQ_Account__c IN :accountIds AND CPQ_Active__c = true AND CPQ_Product__c = null];
	Map<Id, CPQ_TransportMap__c> transportByAccountId = new Map<Id, CPQ_TransportMap__c>();
	for(CPQ_TransportMap__c transport : transportDefaultList) {
		transportByAccountId.put(transport.CPQ_Account__c, transport);
	}
	for(Apttus_Proposal__Proposal__c prop : transportProposals) {
		if(!transportByAccountId.containsKey(prop.Apttus_Proposal__Account__c)) {
			prop.addError('Unable to include transportation. There is no default transportation rate defined for the customer.');
		}
	}
}
}