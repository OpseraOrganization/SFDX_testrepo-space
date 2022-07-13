/****************************************
 * Class Name : NokiaCPQ_Validate_Quote_Ctrlr
 * Created Date: 8 December 2017
 * Created By : Accenture
 * Description : Approval Process for direct and Indirect Quotes
 * Test Class:
 *****************************************/
public without sharing class NokiaCPQ_Validate_Quote_Ctrlr {

	public String currentquoteId {get; set;}
	public String currentOpportunityId  {get; set;}
	public Boolean validationException {get; set;}
	public Opportunity opportunity;
	public Boolean isCancelButtonRequired {get; set;}
	public boolean isHavingError {get; set;}
	public Apttus_Proposal__Proposal__c quote;
	public Boolean loaBypass {get; set;}
	public Boolean isBatchRunning {get; set;}
	public Boolean isBatchComplete {get; set;}
	public Boolean canProceed = false;
	public Boolean quoteApproved {get; set;}
	public String currentUserId;
	public String apexMethod;
	public String apexClass;
	public List<Apttus_Config2__ProductConfiguration__c> productConfigs;
	public Apttus_Config2__ProductConfiguration__c productConfig;
	public List<Apttus_Proposal__Proposal_Line_Item__c > Lineitemlist1;
	public Apttus_Config2__SummaryGroup__c summaryGroupRec;
	public Id ConfigId=null;
	Apttus_Config2.ProductConfiguration cart;
	public Integer flag;
	public List<string> invalidMaintTypeProdCodes = new List<string>();
	public Map<String,Decimal> marketAndDiscountMap = new  Map<String,Decimal>();
	//5261 chnages
	public ID finalizedProductConfigID = null;
	public boolean isCustomFlag = false;
	
	//For Direct
	public Boolean isContractedCLP = true;
	public Boolean manualDiscountGiven = false;
	public string trafficLight = '';
	List<Direct_Portfolio_General_Setting__mdt> generalSetting = new List<Direct_Portfolio_General_Setting__mdt>();
	public Double totalCNPinEURO= 0.0;
	
	public List<Offer__c> offerList = new List<Offer__c>();
	
	//Imran ITCEPP-748
	List<String>portfolioList = System.label.Direct_Portfolio.Split(',');
	set<String> portfolioSet = new set<String>();
	
	// Christie ITCCPQ-1043
	//List<Pre_Approved_Custom_Products__c> preApprovedProductsList = new List<Pre_Approved_Custom_Products__c>();
	List<String> preAppProductsList = new List<String>();
	List<Apttus_Config2__LineItem__c> lineItemRecords = new List<Apttus_Config2__LineItem__c>();
	Set<Id> preApprovedIds = new Set<Id>();
	//Boolean flagPreApproved = false;
	
	//ITCCPQ-1956 - Yashdeep
	public Boolean needsReprice {get; set;}
	Set<string> prodInvalidCodes = new Set<string>();
	Set<string> pliInvalidCodes = new Set<string>();
	public Set<Id> lineItemIds = new Set<Id>();
	//Constructor Class
	public NokiaCPQ_Validate_Quote_Ctrlr(){
		try{
			currentquoteId = ApexPages.currentPage().getParameters().get(GlobalConstants.QUOTEID);
			system.debug('Inside'+ currentquoteId);
			quote = [Select id,Apttus_Proposal__Opportunity__r.OwnerId,Apttus_Proposal__Opportunity__r.Account.OwnerId,Maintenance_Y1__c,Maintenance_Y2__c,SSP__c,SRS__c,NokiaCPQ_Environment_Access_Type__c,Apttus_Proposal__Approval_Stage__c,NokiaCPQ_Capture_Cancel_Recall_Action__c, NokiaCPQ_Pre_Approved_Discount_Range__c,Exchange_Rate__c, NokiaCPQ_Needs_Reprice__c,NokiaCPQ_Total_Quote_Discount__c, NokiaCPQ_Approval_Required_Flag__c,Nokia_CPQ_SW_IRP_Discount__c,Nokia_CPQ_SEET_Margin__c,NokiaCPQ_Net_Amount_Quote__c,CurrencyIsoCode,
		 NokiaCPQ_Total_CNP__c, Quote_Type__c,Apttus_Proposal__Account__r.L4Name__c,NokiaCPQ_Portfolio__c,Is_List_Price_Only__c,Offer__c,Apttus_Proposal__Opportunity__c, is_CustomProductQuote__c,NokiaCPQ_LEO_Discount__c,is_LEO_Criteria_Match__c,NokiaCPQ_CAD__c,NokiaCPQ_has_Partner_Certified__c,Indirect_Approval_Required__c,Project_Price_List_Number__c,CPQ_SubPortfolio__c from Apttus_Proposal__Proposal__c
		 where id = :currentquoteId limit 1];
	
	
			currentOpportunityId = quote.Apttus_Proposal__Opportunity__c;
	
			opportunity = [Select id,StageName,Phase_Status__c,Authorized_for_Pricing_manager__c, Pre_approved_Price_List_for_AM__c,No_Loa__c,LOA_Level__c,count_offer__c,Blanket_Approval_Condition__c,Org_L4__c,NF_LoA_Bypass__c,Contract_Price_List__c,Contract_Price_List__r.PriceList_Type__c,Contract_Price_List__r.Project_Price_List_Number__c from Opportunity where id = :currentOpportunityId limit 1];
	
	
			quote.NokiaCPQ_Capture_Cancel_Recall_Action__c = GlobalConstants.NOTHING;
	
			productConfigs = [Select id,Apttus_Config2__Status__c,Apttus_Config2__AccountId__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c,NokiaCPQ_Portfolio_From_Quote__c from Apttus_Config2__ProductConfiguration__c
		 where Apttus_QPConfig__Proposald__c = :currentquoteId and Apttus_Config2__BusinessObjectType__c =: Nokia_CPQ_Constants.NOKIA_PROPOSAL
								Order by CreatedDate DESC];
	
			if(!productConfigs.isEmpty()) {
	productConfig = productConfigs.get(0);
	system.debug('Status:'+ productConfig.Apttus_Config2__Status__c );
	if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) &&
	   (quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_IP_ROUTING) || quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_FN)))
	// if(portfolioSet.contains(quote.NokiaCPQ_Portfolio__c))
	{
		//September Enterprise Release
		summaryGroupRec = [SELECT NokiaCPQ_Guidance_Traffic_Light__c, Id from Apttus_Config2__SummaryGroup__c
			WHERE Apttus_Config2__ConfigurationId__c = :productConfig.Id and Name = :Nokia_CPQ_Constants.SUBTOTAL_ONE_TIME Limit 1];
	
		if(summaryGroupRec != null)
		{
			trafficLight = summaryGroupRec.NokiaCPQ_Guidance_Traffic_Light__c;
		}
	}
	// End of addition
			}
	
			//Retrieving meta data
			for(Account_L4_percentage__mdt objMetaData : [SELECT Account_L4__c,Percent_margin__c from Account_L4_percentage__mdt]) {
	marketAndDiscountMap.put(objMetaData.Account_L4__c,objMetaData.Percent_margin__c);
			}
	
			Lineitemlist1= [Select id,Apttus_QPConfig__DerivedFromId__c,Product_Code__c,Apttus_QPConfig__PriceListItemId__c,Apttus_QPConfig__PriceListItemId__r.Apttus_Config2__ExpirationDate__c,Apttus_QPConfig__PriceListItemId__r.Apttus_Config2__Active__c,LastModifiedDate,Is_Dummy_Bundle__c,NokiaCPQ_Static_Bundle_Option__c, NokiaCPQ_IsOptions__c, Apttus_QPConfig__ListPrice__c,Apttus_Proposal__Product__r.Last_Modified_Version__c, Apttus_QPConfig__LineType__c,Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c,Apttus_Proposal__Product__r.IsActive, NokiaCPQ_Product_Name__c, Apttus_QPConfig__OptionId__r.name, Apttus_QPConfig__OptionId__r.IsActive,Apttus_Proposal__Product__c, Apttus_QPConfig__OptionId__c, Apttus_QPConfig__Guidance__c,NokiaCPQ_Is_CLP__c, Apttus_QPConfig__NetAdjustmentPercent__c, is_Custom_Product__c,Apttus_QPConfig__ChargeType__c,NokiaCPQ_Light_Color__c,Invalid_Maintenance_type__c,Apttus_Proposal__Product__r.ProductCode,Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__c,Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.name,Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Product_Code__c,Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Expiration_Date__c,Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c,Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Maintenance_Type__c,Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Portfolio__c,Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Account__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =:currentquoteId];
			system.debug('[+] Lineitemlist1.size()'+Lineitemlist1.size());
			system.debug(Lineitemlist1);
			for(Apttus_Proposal__Proposal_Line_Item__c lin : Lineitemlist1) {
	//ITCCPQ-1956
	system.debug('IsActive>>>>>' + lin.Apttus_Proposal__Product__r.IsActive + lin.Product_Code__c);
	if(new List<string> {GlobalConstants.INDIRECT_QUOTE_TYPE,GlobalConstants.DIRECT_QUOTE_TYPE}.indexOf(quote.Quote_Type__c) >= 0 && (!lin.Apttus_Proposal__Product__r.IsActive || (lin.Apttus_QPConfig__OptionId__c != null && !lin.Apttus_QPConfig__OptionId__r.IsActive))) {
		prodInvalidCodes.add(lin.Product_Code__c);
	}
	system.debug('[+]' +lin.Apttus_QPConfig__PriceListItemId__c);
	if(lin.Apttus_QPConfig__PriceListItemId__c == null || (lin.Apttus_QPConfig__PriceListItemId__r.Apttus_Config2__ExpirationDate__c  != null && lin.Apttus_QPConfig__PriceListItemId__r.Apttus_Config2__ExpirationDate__c  <= System.now().date()) || lin.Apttus_QPConfig__PriceListItemId__r.Apttus_Config2__Active__c == false) {
		pliInvalidCodes.add(lin.Product_Code__c);
		lineItemIds.add(lin.Apttus_QPConfig__DerivedFromId__c);
	}
	if(quote.Quote_Type__c.equalsIgnoreCase(GlobalConstants.INDIRECT_QUOTE_TYPE )) {
		//srisailam: as a part of defect 1915
		if(lin.Invalid_Maintenance_type__c && (((lin.NokiaCPQ_IsOptions__c == 'standalone' || lin.NokiaCPQ_IsOptions__c == 'option' ) && lin.NokiaCPQ_Static_Bundle_Option__c == false ) || (lin.NokiaCPQ_IsOptions__c == 'Bundle' && lin.Apttus_QPConfig__ListPrice__c > 0))) {
			invalidMaintTypeProdCodes.add(lin.Apttus_Proposal__Product__r.ProductCode);
		}
		// if(lin.Apttus_Proposal__Product__r.IsActive == false  ) {
		//  flag = 1;
		//  break;
		// }
		if (lin.Apttus_Proposal__Product__r.Last_Modified_Version__c > lin.LastModifiedDate) {
			flag = 2;
			break;
		}
		//ITCCPQ-1864 - Yashdeep added Preapproved check
		if(lin.is_Custom_Product__c && lin.Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__c == null) {
			isCustomFlag = true;
		}
	
	}
	else{
		if(String.isNotBlank(lin.Apttus_QPConfig__ChargeType__c) && lin.Apttus_QPConfig__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD_PRICE) && lin.Apttus_QPConfig__LineType__c != Nokia_CPQ_Constants.lin_Apttus_QPConfig && lin.NokiaCPQ_Is_CLP__c == false && !Nokia_CPQ_Constants.NOKIA_YES.equalsIgnoreCase(lin.Is_Dummy_Bundle__c)) {
	
			isContractedCLP = false;
		}
		if(lin.Apttus_QPConfig__NetAdjustmentPercent__c != 0 && lin.Apttus_QPConfig__NetAdjustmentPercent__c != null) {
			manualDiscountGiven = true;
		}
		/*if(lin.is_Custom_Product__c){
			isCustomFlag = true;
		}  */
	}
	//1975- added by Yashdeep
	if(lin.Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__c != null && (lin.Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Expiration_Date__c <= System.now().date() || lin.Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Account__c != productConfig.Apttus_Config2__AccountId__c || lin.Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Maintenance_Type__c != productConfig.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c || !Nokia_CPQ_Utility.getPortfolio(quote).contains(lin.Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Portfolio__c)))
	{
		preAppProductsList.add('[' + lin.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c + ']-' + lin.Apttus_QPConfig__DerivedFromId__r.Pre_Approved_Custom_Product__r.Product_Code__c);
	}
			}
			system.debug('isContractedCLP**' + isContractedCLP + '**manualDiscountGiven*'+ manualDiscountGiven);
	
			if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ)) {
	generalSetting = [Select Id, Approval_Based_On_Traffic_Lights__c From Direct_Portfolio_General_Setting__mdt where Portfolio__c =: quote.NokiaCPQ_Portfolio__c LIMIT 1];
			}
			if(!productConfigs.isEmpty()) {
	productConfig = productConfigs.get(0);
	system.debug('Status:'+ productConfig.Apttus_Config2__Status__c );
			}
	
			//Imran ITCEPP-748
			portfolioSet.addAll(portfolioList);
	
		}catch(Exception e) {
			System.debug('Error::'+e.getMessage());
			ExceptionHandler.addException(e,NokiaCPQ_Validate_Quote_Ctrlr.class.getName(),GlobalConstants.ERRORVK);
		}
	}
	
	//PageReference
	
	public PageReference init() {
		system.debug('Inside Init');
		isCancelButtonRequired=true;
		isHavingError=false;
		isBatchComplete = false;
	
		PageReference approvalsPage = null;
		Boolean noFinalizedCart = false;
		List<string> contractNumbers = quote.Project_Price_List_Number__c != null ? quote.Project_Price_List_Number__c.split(',') : null;
		list<Apttus_Config2__PriceList__c> priceList = new list<Apttus_Config2__PriceList__c>();
		if(contractNumbers != null) {
			priceList = [select Project_Price_List_Number__c
			 From Apttus_Config2__PriceList__c
			 where Project_Price_List_Number__c in :contractNumbers
			 AND PriceList_Type__c != 'Indirect Market'];
		}
	
		try{
			if(quote.NokiaCPQ_Needs_Reprice__c == true)
			{
	system.debug('debug2 Checking');
	validationException =True;
	isBatchRunning = false;
	isBatchComplete = true;
	noFinalizedCart = true;
	
	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORMS));
	
			}
	
			else if(productConfig != null)
			{
	
	if(productConfig.Apttus_Config2__Status__c != GlobalConstants.FINALIZED)
	{
		validationException =True;
		isBatchRunning = false;
		isBatchComplete = true;
		loaBypass = false;
		noFinalizedCart = true;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORHP));
	}
			}
	
			// noFinalizedCart = false;
			system.debug('>>>>'+noFinalizedCart);
			if(!noFinalizedCart)
			{
	
	if(quote.Quote_Type__c.equalsIgnoreCase(GlobalConstants.INDIRECT_QUOTE_TYPE )) {
	
		System.debug('Inside Indirect QuoteType>>>>');
		System.debug('StageNameK' +opportunity.StageName);
		System.debug('Phase_Status__cK' +opportunity.Phase_Status__c);
		system.debug('[+] oppty ID = '+opportunity.Id);
		system.debug('[+] oppty LOA_Level__c = '+opportunity.LOA_Level__c);
		system.debug('[+] oppty Authorized_for_Pricing_manager__c = '+opportunity.Authorized_for_Pricing_manager__c);
		system.debug('[+] oppty No_Loa__c = '+opportunity.No_Loa__c);
		if(opportunity.StageName.startsWith(GlobalConstants.WINCASE)  && opportunity.Phase_Status__c.startsWith(GlobalConstants.PENDINGWIN)  || (opportunity.StageName.equalsIgnoreCase(GlobalConstants.HANDOVER_OPPTY) || opportunity.StageName.equalsIgnoreCase(GlobalConstants.EXECUTE_OPPTY)))
		{
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			loaBypass = false;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORJB));
			}
			else
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORRS));
			}
		}
	
	
	
		//Added by RG for Quote Approval Start
	
		else if(quote.NokiaCPQ_LEO_Discount__c == true && quote.NokiaCPQ_has_Partner_Certified__c == false) {
	
			system.debug('Leo Quote Partner Checking');
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
	
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPC));
		}
	
	
		//Added by RG for Quote Approval End
	
		// else if(Lineitemlist1.size() > 0 && flag == 1)
		// {
	
		//  for(Apttus_Proposal__Proposal_Line_Item__c lin:Lineitemlist1) {
	
		//	  if (lin.Apttus_QPConfig__LineType__c == Nokia_CPQ_Constants.lin_Apttus_QPConfig)
		//	  {
	
		//  if (lin.Apttus_Proposal__Product__r.IsActive == false ) {
		//	  validationException = True;
		//	  isBatchRunning = false;
		//	  isBatchComplete = true;
	
		//	  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORABD));
	
		//  }
		//	  }else if(lin.Apttus_QPConfig__LineType__c== Nokia_CPQ_Constants.lin_Apttus_QPConfig_if_else) {
	
		//  if (lin.Apttus_QPConfig__OptionId__r.IsActive == false ) {
		//	  validationException = True;
		//	  isBatchRunning = false;
		//	  isBatchComplete = true;
		//	  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORABD));
	
		//  }
		//	  }
		//  }
		// }
		else if(!prodInvalidCodes.isEmpty()) {
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORABD + string.join((Iterable<String>)prodInvalidCodes,',')));
		}
		else if(Lineitemlist1.size() > 0 && flag == 2 )
		{
	
			system.debug('debug1 Checking');
	
			for(Apttus_Proposal__Proposal_Line_Item__c lin:Lineitemlist1)
			{
				if(lin.Apttus_Proposal__Product__r.Last_Modified_Version__c > lin.LastModifiedDate)
				{
		validationException = True;
		isBatchRunning = false;
		isBatchComplete = true;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORBM));
				}
			}
		}
	
		//srisailam: as a part of defect 1915
		//system.debug('canProceed = '+canProceed);
		else if(invalidMaintTypeProdCodes != null && invalidMaintTypeProdCodes.size() > 0 && !canProceed) {
	
			system.debug('invalidMaintTypeProdCodes invalid = '+invalidMaintTypeProdCodes);
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.WARNING, ' The Product(s) ' + String.join(invalidMaintTypeProdCodes, ',') + ' cannot be supported by the maintenance type selected. Please use a supported maintenance option. Do you still want to Proceed ? '));
			isHavingError=true;
			canProceed=true;
		}
	
		//Reqt-itccpq-1078
	
		else if(opportunity.Contract_Price_List__c ==null && quote.Project_Price_List_Number__c!= null && productConfig.Apttus_Config2__Status__c == GlobalConstants.FINALIZED && contractNumbers != null && priceList.size() > 0)
		{
	
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			noFinalizedCart = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The price list on this quote is different from the price list on the opportunity. Please create a new quote (clone this quote) as this quote is no longer valid.'));
		}
		else if( opportunity.Contract_Price_List__c !=null && quote.Project_Price_List_Number__c!= null && productConfig.Apttus_Config2__Status__c == GlobalConstants.FINALIZED && !quote.Project_Price_List_Number__c.contains(opportunity.Contract_Price_List__r.Project_Price_List_Number__c))
		{
	
			system.debug('opportunity.Contract_Price_List__c is not null');
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			noFinalizedCart = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The price list on this quote is different from the price list on the opportunity. Please create a new quote (clone this quote) as this quote is no longer valid.'));
	
		}
		//ITCCPQ-1956
		else if(!pliInvalidCodes.isEmpty()) {
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			noFinalizedCart = true;
			loaBypass = false;
			quote.NokiaCPQ_Needs_Reprice__c = true;
			Nokia_CPQ_Constants.BYPASS_PROPOSAL_TRIGGER = true;
			update quote;
			needsReprice = true;
			string prodCodes = '';
			if(pliInvalidCodes.size() > 5) {
				Integer i = 5;
				for (string code : pliInvalidCodes) {
		prodCodes += code + ',';
		i--;
		if(i == 0) {
			prodCodes = prodCodes.substringBeforeLast(',');
			break;
		}
				}
			}else{
				prodCodes = string.join((Iterable<String>)pliInvalidCodes,',');
			}
			String errMsgformated = String.format(Nokia_CPQ_Constants.PSP_ERROR_MESSAGE, new List<String> {string.valueof(pliInvalidCodes.size()),prodCodes});
	
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errMsgformated));
		}
		// Added by Christie JJ for ITCCPQ-1043 to validate Pre-Approved Custom Products
		//Start
		//1975-changed condition by Yashdeep
	
		else if (preAppProductsList != null && preAppProductsList.size() > 0) {
			system.debug('[+] Inside PreApproved');
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			noFinalizedCart = true;
			loaBypass = false;
			String formattedString=String.format(Nokia_CPQ_Constants.VALIDATE_PREAPPROVED, new List<string> { string.join(preAppProductsList,',') });
	
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,formattedString));
		}
		//End
	
		else if((opportunity.StageName == GlobalConstants.CREATE_OFFER|| opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE ) && (opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) && opportunity.Authorized_for_Pricing_manager__c == 0
				&& opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == false)
		{
	
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			loaBypass = false;
			if(quote.NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL && opportunity.StageName == GlobalConstants.CREATE_OFFER && (quote.NokiaCPQ_Total_Quote_Discount__c > 0 || (quote.Maintenance_Y1__c>0 || quote.Maintenance_Y2__c>0 || quote.SSP__c>0 || quote.SRS__c>0) || isCustomFlag))
			{
				quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
				update quote;
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				if(profileName.contains(Nokia_CPQ_Constants.profilename_contains))
				{
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORBL));
				}
				else
				{
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.INFOPSMNPT));
				}
			}
			else if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORSS));
			}
			else
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORJA));
			}
		}
	
	
		else if(quote.NokiaCPQ_Net_Amount_Quote__c == 0)
		{
			system.debug('debug4 Checking');
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORJR));
	
		}
	
		else if(opportunity.StageName != GlobalConstants.CREATE_OFFER && opportunity.StageName != GlobalConstants.WIN_THE_CASE_NEGOTIATE )
		{
			system.debug('debug5 Checking');
	
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORDW));
	
		}
	
		else if(opportunity.Phase_Status__c == GlobalConstants.SUBMITTED_FOR_G4_APPROVAL)
	
		{
			system.debug('debug6 Checking');
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORKW));
	
		}
	
		else if(opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && (opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL)  && opportunity.Authorized_for_Pricing_manager__c == 0
				&& opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == true && quote.NokiaCPQ_Total_Quote_Discount__c == 0 && !isCustomFlag && (quote.Maintenance_Y1__c == null && quote.Maintenance_Y2__c == null && quote.SSP__c == null && quote.SRS__c == null && quote.NokiaCPQ_LEO_Discount__c == false))
	
		{
			system.debug('debug7 Checking');
			if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser) &&
		 quote.Apttus_Proposal__Opportunity__r.OwnerId != quote.Apttus_Proposal__Opportunity__r.Account.OwnerId) {
				System.debug('Inside Optyowner sharing');
				System.debug('Oppty  owner'+quote.Apttus_Proposal__Opportunity__r.OwnerId);
				System.debug('Account owner'+quote.Apttus_Proposal__Opportunity__r.Account.OwnerId);
				IndirectCPQ_UserSharing.optyOwnertoPartnerSharing(quote.Apttus_Proposal__Opportunity__r.OwnerId);
	
			}
			quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.APPROVED;
			update quote;
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_ApprovedQuote));
	
		}
		// Start of addition for Microwave Nov 2020
		else if(quote.NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO && (opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE || opportunity.StageName == GlobalConstants.CREATE_OFFER) && (opportunity.Authorized_for_Pricing_manager__c > 0 || opportunity.Pre_approved_Price_List_for_AM__c > 0))
		{
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			if(profileName.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORSS));
			}
			else
			{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.INFOPSMNA));
			}
		}
		else if(quote.NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO && (opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE || opportunity.StageName == GlobalConstants.CREATE_OFFER) && opportunity.LOA_Level__c != null && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL && opportunity.No_Loa__c == true)
		{
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			if(profileName.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORSS));
			}
			else
			{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORJA));
			}
		}
		//End of addition for Microwave Nov 2020
		else if(opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && (opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) && opportunity.Authorized_for_Pricing_manager__c == 0
				&& opportunity.Pre_approved_Price_List_for_AM__c > 0 && opportunity.No_Loa__c == false && quote.NokiaCPQ_Pre_Approved_Discount_Range__c == true && !isCustomFlag && (quote.Maintenance_Y1__c == null && quote.Maintenance_Y2__c == null && quote.SSP__c == null && quote.SRS__c == null && quote.NokiaCPQ_LEO_Discount__c == false))
	
		{
			system.debug('debug8 Checking');
			if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser) &&
		 quote.Apttus_Proposal__Opportunity__r.OwnerId != quote.Apttus_Proposal__Opportunity__r.Account.OwnerId) {
				System.debug('Inside Optyowner sharing');
				System.debug('Oppty  owner'+quote.Apttus_Proposal__Opportunity__r.OwnerId);
				System.debug('Account owner'+quote.Apttus_Proposal__Opportunity__r.Account.OwnerId);
				IndirectCPQ_UserSharing.optyOwnertoPartnerSharing(quote.Apttus_Proposal__Opportunity__r.OwnerId);
	
			}
	
			quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.APPROVED;
			update quote;
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_ApprovedQuote));
	
		}
	
	
	
		else if((opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE || opportunity.StageName == GlobalConstants.CREATE_OFFER) && (opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) && opportunity.Authorized_for_Pricing_manager__c == 0
				&& opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == true && (quote.NokiaCPQ_Total_Quote_Discount__c > 0 || (quote.Maintenance_Y1__c>0 || quote.Maintenance_Y2__c>0 || quote.SSP__c>0 || quote.SRS__c>0) || isCustomFlag || quote.NokiaCPQ_LEO_Discount__c))
	
		{
			//RG: 13-08-2019 Added as a part of Req# 6430 Start
			quote.Indirect_Approval_Required__c = true;
			update quote;
			System.debug('quote.NokiaCPQ_LEO_Discount__c-->'+quote.NokiaCPQ_LEO_Discount__c);
			String getuserProfileId = userinfo.getProfileId();
			Profile Getprofile = [Select name from Profile where id = :getuserProfileId];
			String partnerProfile = Getprofile.Name;
	
			if(quote.NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO)
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				if(partnerProfile.contains(Nokia_CPQ_Constants.profilename_contains))
				{
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORSS));
				}
				else
				{
		if(opportunity.StageName == GlobalConstants.CREATE_OFFER)
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORJA));
		}
		else if(opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE)
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCG));
		}
				}
			}
	
	
			//added MPW Portfolio check to display error REQ: 7135
			else if(quote.NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION && partnerProfile.contains(Nokia_CPQ_Constants.profilename_contains) && opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE )
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCG));
			}
			else
			{
				if((quote.Maintenance_Y1__c>0 || quote.Maintenance_Y2__c>0 || quote.SSP__c>0 || quote.SRS__c>0) && isCustomFlag && quote.NokiaCPQ_LEO_Discount__c && quote.NokiaCPQ_Total_Quote_Discount__c > 0) {
		String userProfileId = userinfo.getProfileId();
		Profile profile = [Select name from Profile where id = :userProfileId];
		String profileName = profile.Name;
		if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
		{
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORAll));
		}
		else{
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMAll));
		}
				}
	
				else if(quote.Maintenance_Y1__c>0 || quote.Maintenance_Y2__c>0 || quote.SSP__c>0 || quote.SRS__c>0)  {
	
		if(quote.NokiaCPQ_LEO_Discount__c) {
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORMPO));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORLP));
			}else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMMPO));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMLP));
			}
		}
		else if(isCustomFlag==true) {
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORMPO));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCP));
			}
			else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMMPO));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMCP));
			}
		}
		else if(quote.NokiaCPQ_Total_Quote_Discount__c > 0) {
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORMPO));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCAD));
			}
			else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMMPO));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMCAD));
			}
		}
		else{
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORMPO));
			}
			else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMMPO));
			}
		}
				}
				else if(isCustomFlag==true) {
		if(quote.NokiaCPQ_LEO_Discount__c) {
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCP));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORLP));
			}
			else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMCP));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMLP));
			}
		}
		else if(quote.NokiaCPQ_Total_Quote_Discount__c > 0) {
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCP));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCAD));
			}
			else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMCP));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMCAD));
			}
		}
		else{
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCP));
			}
			else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMCP));
			}
		}
				}
				else if(quote.NokiaCPQ_LEO_Discount__c == true) {
	
		if(quote.NokiaCPQ_Total_Quote_Discount__c > 0) {
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORLP));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCAD));
			}
			else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMLP));
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMCAD));
			}
		}
		else{
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORLP));
			}
			else{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMLP));
			}
		}
				}
				else if(quote.NokiaCPQ_Total_Quote_Discount__c > 0) {
		String userProfileId = userinfo.getProfileId();
		Profile profile = [Select name from Profile where id = :userProfileId];
		String profileName = profile.Name;
		if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
		{
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCAD));
		}
		else{
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORPSMCAD));
		}
				}
				//RG: 13-08-2019 Added as a part of Req# 6430 End
	
				else{
		String userProfileId = userinfo.getProfileId();
		Profile profile = [Select name from Profile where id = :userProfileId];
		String profileName = profile.Name;
		loaBypass = false;
		System.debug('Inside Optyowner sharing');
		if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
		{
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORSS));
		}
		else
		{
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORJA));
		}
				}
			}
		}
	
	
		else if((opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE || opportunity.StageName == GlobalConstants.CREATE_OFFER) && (opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL ) && opportunity.Authorized_for_Pricing_manager__c == 0
				&& opportunity.Pre_approved_Price_List_for_AM__c > 0 && opportunity.No_Loa__c == false && quote.NokiaCPQ_Pre_Approved_Discount_Range__c == false)
	
		{
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			loaBypass = false;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORSS));
			}
			else
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORJA));
	
			}
		}
		else if(opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && ((opportunity.LOA_Level__c != null && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL) || opportunity.Authorized_for_Pricing_manager__c > 0)
				&& opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == false)
		{
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
	
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
			{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORSS));
			}
			else
			{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORCG));
			}
		}
		else if(opportunity.StageName == GlobalConstants.CREATE_OFFER && (opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) && opportunity.Authorized_for_Pricing_manager__c == 0
				&& opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == true && quote.NokiaCPQ_Total_Quote_Discount__c == 0)
		{
	
			if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser) &&
		 quote.Apttus_Proposal__Opportunity__r.OwnerId != quote.Apttus_Proposal__Opportunity__r.Account.OwnerId) {
				System.debug('Inside Optyowner sharing');
				System.debug('Oppty  owner'+quote.Apttus_Proposal__Opportunity__r.OwnerId);
				System.debug('Account owner'+quote.Apttus_Proposal__Opportunity__r.Account.OwnerId);
				IndirectCPQ_UserSharing.optyOwnertoPartnerSharing(quote.Apttus_Proposal__Opportunity__r.OwnerId);
	
			}
			quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
			quote.NokiaCPQ_Approval_Required_Flag__c = true;
			update quote;
			system.debug('Inside Create Akrati-->');
			validationException = true;
			loaBypass = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_ApprovedQuote));
			if(!Test.isRunningTest()) {
				submitforApproval(currentOpportunityId);
			}
			isBatchRunning = true;
			isBatchComplete = false;
		}
		else if(opportunity.StageName == GlobalConstants.CREATE_OFFER && (opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) && opportunity.Authorized_for_Pricing_manager__c == 0 && opportunity.Pre_approved_Price_List_for_AM__c > 0 && opportunity.No_Loa__c == false && quote.NokiaCPQ_Pre_Approved_Discount_Range__c == true )
		{
	
			System.debug('Insidde Indirectcondition>>>>>>>');
			if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser) && quote.Apttus_Proposal__Opportunity__r.OwnerId != quote.Apttus_Proposal__Opportunity__r.Account.OwnerId) {
				System.debug('Inside Optyowner sharing');
				System.debug('Oppty  owner'+quote.Apttus_Proposal__Opportunity__r.OwnerId);
				System.debug('Account owner'+quote.Apttus_Proposal__Opportunity__r.Account.OwnerId);
				IndirectCPQ_UserSharing.optyOwnertoPartnerSharing(quote.Apttus_Proposal__Opportunity__r.OwnerId);
	
			}
			quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
			quote.NokiaCPQ_Approval_Required_Flag__c = true;
			update quote;
			validationException = true;
			loaBypass = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_ApprovedQuote));
			if(!Test.isRunningTest())
				submitforApproval(currentOpportunityId);
			isBatchRunning = true;
			isBatchComplete = false;
		}
		else if(opportunity.StageName == GlobalConstants.CREATE_OFFER && ((opportunity.LOA_Level__c != null && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL ) || opportunity.Authorized_for_Pricing_manager__c > 0)
				&& opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == false /* && (quote.Maintenance_Y1__c>0 || quote.Maintenance_Y2__c>0 || quote.SSP__c>0 || quote.SRS__c>0) */)
		{
	
			System.debug('Insidde Indirectcondition22222>>>>>>>');
			String userProfileId = userinfo.getProfileId();
			Profile profile = [Select name from Profile where id = :userProfileId];
			String profileName = profile.Name;
			loaBypass = false;
			//Added by RG for Approval check starts
			if(quote.NokiaCPQ_Total_Quote_Discount__c > 0 || (quote.Maintenance_Y1__c>0 || quote.Maintenance_Y2__c>0 || quote.SSP__c>0 || quote.SRS__c>0) || isCustomFlag || quote.NokiaCPQ_LEO_Discount__c) {
				quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
				update quote;
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				if(quote.NokiaCPQ_Portfolio__c ==   Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO)
				{
		if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORBL));
		}
		else
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.INFOPSMNPT));
	
		}
				}
				else
				{
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERROROCA));
				}
			}
			//Added by RG for Approval check End
			else{ //added else check by RG
				if(profilename.contains(Nokia_CPQ_Constants.profilename_contains))
				{
		if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser) &&
		   quote.Apttus_Proposal__Opportunity__r.OwnerId != quote.Apttus_Proposal__Opportunity__r.Account.OwnerId) {
			System.debug('Inside Optyowner sharing');
			System.debug('Oppty  owner'+quote.Apttus_Proposal__Opportunity__r.OwnerId);
			System.debug('Account owner'+quote.Apttus_Proposal__Opportunity__r.Account.OwnerId);
			IndirectCPQ_UserSharing.optyOwnertoPartnerSharing(quote.Apttus_Proposal__Opportunity__r.OwnerId);
	
		}
		quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
		update quote;
		validationException = True;
		isBatchRunning = false;
		isBatchComplete = true;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORBL));
				}
				else
				{
		if(FeatureManagement.checkPermission(GlobalConstants.CustomPermission_CPQPartnerUser) &&
		   quote.Apttus_Proposal__Opportunity__r.OwnerId != quote.Apttus_Proposal__Opportunity__r.Account.OwnerId) {
			System.debug('Inside Optyowner sharing');
			System.debug('Oppty  owner'+quote.Apttus_Proposal__Opportunity__r.OwnerId);
			System.debug('Account owner'+quote.Apttus_Proposal__Opportunity__r.Account.OwnerId);
			IndirectCPQ_UserSharing.optyOwnertoPartnerSharing(quote.Apttus_Proposal__Opportunity__r.OwnerId);
	
		}
		quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
		update quote;
		validationException = True;
		isBatchRunning = false;
		isBatchComplete = true;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORKS));
				}
			}
		}
	
	}
	// Req 4183 Starts:Approval Process for Direct Quotes
	
	else
	{
	
		System.debug('Direct Quote starts here>>');
	
		//Changes in Sprint 0+ for requirement #5505
		//Condition 1: Quote needs reprice
		if(quote.NokiaCPQ_Needs_Reprice__c == true) {
			system.debug('Quote needs reprice>>');
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ERRORMS));
		}
		else if(!prodInvalidCodes.isEmpty()) {
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,GlobalConstants.ERRORABD + string.join((Iterable<String>)prodInvalidCodes,',')));
		}
		//ITCCPQ-1956
		else if(!pliInvalidCodes.isEmpty() && quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ)) {
	
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			noFinalizedCart = true;
			loaBypass = false;
			quote.NokiaCPQ_Needs_Reprice__c = true;
			Nokia_CPQ_Constants.BYPASS_PROPOSAL_TRIGGER = true;
			update quote;
			needsReprice = true;
			string prodCodes = '';
			if(pliInvalidCodes.size() > 5) {
				Integer i = 5;
				for (string code : pliInvalidCodes) {
		prodCodes += code + ',';
		i--;
		if(i == 0) {
			prodCodes = prodCodes.substringBeforeLast(',');
			break;
		}
				}
			}else{
				prodCodes = string.join((Iterable<String>)pliInvalidCodes,',');
			}
			String errMsgformated = String.format(Nokia_CPQ_Constants.PSP_ERROR_MESSAGE, new List<String> {string.valueof(pliInvalidCodes.size()),prodCodes});
	
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errMsgformated));
		} // Condition 2: Opportunity stage shoud be Create Offer/Win the Case Negotiate
		else if(opportunity.StageName != GlobalConstants.CREATE_OFFER && opportunity.StageName != GlobalConstants.WIN_THE_CASE_NEGOTIATE) {
			system.debug('Oppty stage=Create off/win the case negative'+opportunity.StageName);
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ERRORBS));
		} //Condition 3: Invalid Offer Condition
		else if(((opportunity.StageName == GlobalConstants.CREATE_OFFER || opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE) && opportunity.LOA_Level__c == null && opportunity.Authorized_for_Pricing_manager__c == 0 && opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == false)) {
			system.debug('Invalid offer condition');
			loaBypass = false;
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ERRORWA));
		} //Condition 4: Quote should be finalized
		//If 100% DISCOUNT GIVEN , CNP CAN BE ZERO(Req 6000)
		else if(quote.NokiaCPQ_Total_CNP__c == 0 && Lineitemlist1.size() == 0) {
			system.debug('100% Discount give>>');
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ERRORJR));
	
		} //Condition 5: Opportunity should not already be in approval
		else if(opportunity.Phase_Status__c == GlobalConstants.SUBMITTED_FOR_G4_APPROVAL && quote.NokiaCPQ_Portfolio__c <> 'QTC') {
	
			system.debug('debug6 Checking');
			validationException =True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ERRORKW));
		} //Condition 6: Quote cannot be validated when Oppty is already G4 approved
		else if(opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && (opportunity.Authorized_for_Pricing_manager__c > 0 || opportunity.Pre_approved_Price_List_for_AM__c > 0 || opportunity.No_Loa__c == true || (opportunity.LOA_Level__c != null && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL)) && quote.NokiaCPQ_Portfolio__c <> 'QTC') {
			System.debug('Quote cannot be validated when oppty is already G4');
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,GlobalConstants.ERRORCG));
		} //Condition 7: For all remaining cases, Move quote to In-Review
		else if(opportunity.StageName == GlobalConstants.CREATE_OFFER && (opportunity.Authorized_for_Pricing_manager__c > 0 || opportunity.Pre_approved_Price_List_for_AM__c > 0 || opportunity.No_Loa__c == true || (opportunity.LOA_Level__c != null && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL )) && quote.NokiaCPQ_Portfolio__c <> 'QTC') {
			system.debug('For all remaining quotes');
			if(String.isNotBlank(currentOpportunityId)) {
				offerList = [Select Id,ActiveOffer__c, Name,Opportunity__c from Offer__c where ActiveOffer__c=true and Opportunity__c =:currentOpportunityId limit 1];
			}
			system.debug('generalSetting'+generalSetting+generalSetting[0].Approval_Based_On_Traffic_Lights__c+quote.Is_List_Price_Only__c);
			if(!generalSetting.isempty() && generalSetting[0].Approval_Based_On_Traffic_Lights__c == false && quote.Is_List_Price_Only__c) {
				System.debug('ION Direct List Price Only quote>>');
				quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.APPROVED;
				if(!offerList.isEmpty()) {
		quote.Offer__c= offerList[0].Id;
				}
				quote.Quote_Status__c = 'Submit';
				update quote;
	
	
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				loaBypass = false;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_ApprovedQuote));
			}
			else{
				//Converting currency into Euro by dividing it with Exchange rate
				if(quote.CurrencyIsoCode != 'EUR') {
		if(quote.Exchange_Rate__c != 0) {
			totalCNPinEURO = (quote.NokiaCPQ_Total_CNP__c/quote.Exchange_Rate__c).setScale(2, RoundingMode.HALF_UP);
		}
				}
				else{
		totalCNPinEURO = quote.NokiaCPQ_Total_CNP__c;
				}
				//Enterprise Release
				// Below Condition modified by Nandeesh as part of fixing approvals issue
				if(opportunity.NF_LoA_Bypass__c > 0 &&
		  (opportunity.Pre_approved_Price_List_for_AM__c > 0 || opportunity.No_Loa__c == true || opportunity.Authorized_for_Pricing_manager__c > 0))
				{
		//if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ)  && (quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_IP_ROUTING) || quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_FN))&& trafficLight == Nokia_CPQ_Constants.RED)
		if(portfolioSet.contains(quote.NokiaCPQ_Portfolio__c) && trafficLight == Nokia_CPQ_Constants.RED)
		{
			if(quote.Apttus_Proposal__Approval_Stage__c == Nokia_CPQ_Constants.ApprovalRequired)
			{
				quote.NokiaCPQ_Approval_Required_Flag__c = true;
				quote.Apttus_QPApprov__Approval_Status__c = GlobalConstants.STATUS_NOT_SUBMITTED;
	
				if(!offerList.isEmpty()) {
					quote.Offer__c = offerList[0].Id;
				}
				update quote;
	
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.ERRORIPRL));
			}
			else
			{
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.ERRORSTAGE));
	
			}
		}
				}
				system.debug('traffic light:'+trafficLight);
				// LOA Bypass: No Loa OR Preapproved for Account Manager
				if((opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) && opportunity.Authorized_for_Pricing_manager__c == 0 && ((opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == true) || (opportunity.Pre_approved_Price_List_for_AM__c > 0 && opportunity.No_Loa__c == false))) {
	
	
		// Quote set to In-Review + Auto Approval
		if(opportunity.No_Loa__c == true) {
			//if(((quote.NokiaCPQ_Portfolio__c != Nokia_CPQ_Constants.NOKIA_IP_ROUTING) && manualDiscountGiven == false && isContractedCLP == true && totalCNPinEURO < 5000000.00) ||
			//   (quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) && (quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_IP_ROUTING) || quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_FN))&& trafficLight == Nokia_CPQ_Constants.GREEN))
			if(((!portfolioSet.contains(quote.NokiaCPQ_Portfolio__c)) && manualDiscountGiven == false && isContractedCLP == true && totalCNPinEURO < 5000000.00) ||
			(portfolioSet.contains(quote.NokiaCPQ_Portfolio__c) && trafficLight == Nokia_CPQ_Constants.GREEN))
			{
	
				quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
				quote.NokiaCPQ_Approval_Required_Flag__c = true;
	
				if(!offerList.isEmpty()) {
					quote.Offer__c = offerList[0].Id;
				}
				update quote;
	
				system.debug('Inside LOA Bypass: No Loa OR Preapproved for Account Manager');
	
				validationException = true;
				loaBypass = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_ApprovedQuote));
	
				// Below condition Modified by Nandeesh as part of fixing optty stage value
				system.debug('ApprovalProcess--'+ opportunity.Blanket_Approval_Condition__c+'stage--'+opportunity.StageName+'Phase--'+opportunity.Phase_Status__c+'orgL4--'+opportunity.Org_L4__c+'App. level--'+opportunity.LOA_Level__c+'G4/G5 bypas--'+opportunity.NF_LoA_Bypass__c);
				Opportunity opp = [Select id,Blanket_Approval_Condition__c,StageName,Phase_Status__c,Org_L4__c,LOA_Level__c,NF_LoA_Bypass__c from Opportunity where id  =:currentOpportunityId limit 1];
				system.debug('ApprovalProcess--'+ opp);
				if(!Test.isRunningTest() && opp.StageName != GlobalConstants.WIN_THE_CASE_NEGOTIATE) {
					submitforApproval(currentOpportunityId);
					isBatchRunning = true;
					isBatchComplete = false;
				}
				else{
					system.debug('ApprovalProcess--else-');
					isBatchRunning = true;
					isBatchComplete = false;
				}
	
			}
			else if(trafficLight == null || trafficLight == '') {
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				loaBypass = false;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Nokia_CPQ_Constants.ErrorNoLOA));
			}
		}
		else if(opportunity.Pre_approved_Price_List_for_AM__c > 0) {
			//if((manualDiscountGiven == false && isContractedCLP == true && totalCNPinEURO < 5000000 && quote.NokiaCPQ_Portfolio__c != Nokia_CPQ_Constants.NOKIA_IP_ROUTING) ||
			//  (quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) &&  trafficLight == Nokia_CPQ_Constants.GREEN))
			if((manualDiscountGiven == false && isContractedCLP == true && totalCNPinEURO < 5000000 && !portfolioSet.contains(quote.NokiaCPQ_Portfolio__c)) ||
			(portfolioSet.contains(quote.NokiaCPQ_Portfolio__c) &&  trafficLight == Nokia_CPQ_Constants.GREEN))
			{
				quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
				quote.NokiaCPQ_Approval_Required_Flag__c = true;
	
				if(!offerList.isEmpty()) {
					quote.Offer__c = offerList[0].Id;
				}
				update quote;
	
				system.debug('Inside LOA Bypass: No Loa OR Preapproved for Account Manager');
	
				validationException = true;
				loaBypass = true;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_ApprovedQuote));
	
				// Below condition Modified by Nandeesh as part of fixing optty stage value
				system.debug('ApprovalProcess--'+ opportunity.Blanket_Approval_Condition__c+'stage--'+opportunity.StageName+'Phase--'+opportunity.Phase_Status__c+'orgL4--'+opportunity.Org_L4__c+'App. level--'+opportunity.LOA_Level__c+'G4/G5 bypas--'+opportunity.NF_LoA_Bypass__c);
				Opportunity oppt = [Select id,Blanket_Approval_Condition__c,StageName,Phase_Status__c,Org_L4__c,LOA_Level__c,NF_LoA_Bypass__c from Opportunity where id  =:currentOpportunityId limit 1];
				system.debug('ApprovalProcess--'+ oppt);
				if(!Test.isRunningTest() && oppt.StageName != GlobalConstants.WIN_THE_CASE_NEGOTIATE) {
					submitforApproval(currentOpportunityId);
					isBatchRunning = true;
					isBatchComplete = false;
				}
				else{
					system.debug('ApprovalProcess--else-');
					isBatchRunning = true;
					isBatchComplete = false;
				}
			}
			else if(trafficLight == null || trafficLight == '') {
				validationException = True;
				isBatchRunning = false;
				isBatchComplete = true;
				loaBypass = false;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Nokia_CPQ_Constants.ErrorPreApproved));
			}
		}
				} // LOA Bypass: Authorized for Pricing Manager
				else if((opportunity.LOA_Level__c == null || opportunity.LOA_Level__c == GlobalConstants.LOA_BYPASS_LEVEL) && opportunity.Authorized_for_Pricing_manager__c > 0 && opportunity.Pre_approved_Price_List_for_AM__c == 0 && opportunity.No_Loa__c == false) {
	
		Boolean isRedColor=false;
		for(Apttus_Proposal__Proposal_Line_Item__c lin:Lineitemlist1) {
			if(lin.NokiaCPQ_Light_Color__c == Nokia_CPQ_Constants.RED) {
				isRedColor=true;
				break;
			}
		}
	
		//Quote set to In-Review, No Auto Approval
		//if((!isRedColor && totalCNPinEURO < 5000000 && (quote.NokiaCPQ_Portfolio__c != Nokia_CPQ_Constants.NOKIA_IP_ROUTING))
		//   || (quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) && trafficLight == Nokia_CPQ_Constants.GREEN)){
		if((!isRedColor && totalCNPinEURO < 5000000 && (!portfolioSet.contains(quote.NokiaCPQ_Portfolio__c)))
		   || (portfolioSet.contains(quote.NokiaCPQ_Portfolio__c) && trafficLight == Nokia_CPQ_Constants.GREEN)) {
			system.debug('Inside LOA Bypass: Authorized for Pricing Manager');
	
			quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
			if(!offerList.isEmpty()) {
				quote.Offer__c = offerList[0].Id;
			}
			update quote;
	
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_InReview_DirectQuote));
		}
		else if(trafficLight == null || trafficLight == '') {
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Nokia_CPQ_Constants.ErrorAuthorized));
		}
				} // No LOA Bypass
				//else if(opportunity.LOA_Level__c != null && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL && (quote.NokiaCPQ_Portfolio__c != Nokia_CPQ_Constants.NOKIA_IP_ROUTING
				// || (quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) && trafficLight == Nokia_CPQ_Constants.GREEN))){
				else if(opportunity.LOA_Level__c != null && opportunity.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL && (!portfolioSet.contains(quote.NokiaCPQ_Portfolio__c)
										 || (portfolioSet.contains(quote.NokiaCPQ_Portfolio__c) && trafficLight == Nokia_CPQ_Constants.GREEN))) {
		system.debug('Inside No LOA Bypass');
		// Quote set to In-Review, No Auto Approval
		quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.REVIEW;
		if(!offerList.isEmpty()) {
			quote.Offer__c = offerList[0].Id;
		}
		update quote;
	
		validationException = True;
		isBatchRunning = false;
		isBatchComplete = true;
		loaBypass = false;
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_InReview_DirectQuote));
				}
			}
		} //Condition 8: For all QTC cases, move to Approved
		else if((opportunity.StageName == GlobalConstants.CREATE_OFFER || opportunity.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE) && quote.NokiaCPQ_Portfolio__c == 'QTC' ) {
	
			System.debug('ION Direct List Price Only quote>>');
			quote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.APPROVED;
			quote.Quote_Status__c = 'Submit';
			update quote;
			validationException = True;
			isBatchRunning = false;
			isBatchComplete = true;
			loaBypass = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,System.Label.NokiaCPQ_ApprovedQuote));
		}
	}
			}
	
			return approvalsPage;
		}catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQ_Validate_Quote_Ctrlr.class.getName(),GlobalConstants.ERRORAG);
		}
		return approvalsPage;
	}
	
	// Req No. 4183 Ends
	
	
	//Status Class
	public void currentBatchStatus()
	{
		try{
			if(!loaBypass)
			{
	
	isBatchComplete = true;
	isBatchRunning = false;
	
			}
			else
			{
	isBatchComplete = true;
	isBatchRunning = false;
	quoteApproved = true;
	//Majid: D-14593 As future method to submit for Approval removed below does not require
	/*
	   currentUserId = UserInfo.getUserId();
	   apexMethod = GlobalConstants.APPROVE;
	   apexClass = System.Label.NOKIA_CPQ_Validate_Quote_Ctrlr;
	
	   List<AsyncApexJob> apexJobs = [Select Id,Status From AsyncApexJob Where ApexClassId = :apexClass AND JobType =: GlobalConstants.FUTURECASE AND MethodName = :apexMethod AND CreatedById = :currentUserId Order by CreatedDate DESC];
	   AsyncApexJob job = apexJobs.get(0);
	   if(job.Status == GlobalConstants.COMPLETED_OPPTY)
	   {
	   isBatchComplete = true;
	   isBatchRunning = false;
	   quoteApproved = true;
	   }
	   else
	   {
	   isBatchComplete = false;
	   isBatchRunning = true;
	   }
	 */
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQ_Validate_Quote_Ctrlr.class.getName(),GlobalConstants.ERRORMH);
		}
	}
	
	//PageReference if cancelled
	public PageReference cancel() {
		return new PageReference(Nokia_CPQ_Constants.SLASH+currentquoteId);
	}
	
	//Class for Approval
	public static void submitforApproval(String oppId) {
	
		Apttus_Approval.ApprovalsWebService.submitForApprovals(GlobalConstants.OBJECT_OPPORTUNITY,oppId);
	
	}
	
	public PageReference reprice() {
		list<Apttus_Config2__LineItem__c> lineItemList = new list<Apttus_Config2__LineItem__c>();
		for(Id lineItemId : lineItemIds) {
			Apttus_Config2__LineItem__c lineItemSO = new Apttus_Config2__LineItem__c();
			lineItemSO.Id = lineItemId;
			lineItemSO.Is_Contract_Pricing_2__c = false;
			lineItemList.add(lineItemSO);
		}
		update lineItemList;
		isBatchComplete = false;
		needsReprice = false;
		isBatchRunning = true;
		ApexPages.StandardController controller = new ApexPages.StandardController(quote);
		QuoteRepriceController qrcObj = new QuoteRepriceController(controller);
		return qrcObj.QuoteReprice();
	}
	
	
	}