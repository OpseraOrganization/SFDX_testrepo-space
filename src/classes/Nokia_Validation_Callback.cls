/************************************************************************************************************
* Apex Class Name   : Nokia_Validation_Callback.cls
* Version   : 1.0
* Created Date  : 28 Aug 2017
* Function  : validation call back on Cart
* Modification Log  :
* Developer   Date	Description
* -----------------------------------------------------------------------------------------------------------
* Rupesh Sharma  08/28/2017 validation call back on Cart
*
************************************************************************************************************/
global with sharing class Nokia_Validation_Callback implements Apttus_Config2.CustomClass.IValidationCallback2 {
public Id ConfigId=null;
Id Recordtype=null;
public Id proposalId;
private Apttus_Config2__ProductConfiguration__c configSO;


private Apttus_Config2__ProductConfiguration__c prdConfig;
@TestVisible private String pageAction;	//Changes made as part of REQ-1105,528-Site Phase Product Quantity in Cart
List<Apttus_Config2__LineItem__c> Lineitemlist1 = new List<Apttus_Config2__LineItem__c> ();	//Changes made as part of REQ-1105,528-Site Phase Product Quantity in Cart
/* Method Name   : validateCart
 * Developer   : Rupesh Sharma
 * Description   : validation messages on cart */
global Apttus_Config2.CustomClass.ValidationResult validateCart(Apttus_Config2.ProductConfiguration cart) {
  Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true);
  Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
  Apttus_Config2__ProductConfiguration__c Prodid = new Apttus_Config2__ProductConfiguration__c();
  List<CPQ_Site_Phase_and_Quantity__c> sitePhaseQuantities = new List<CPQ_Site_Phase_and_Quantity__c> (); //Changes made as part of REQ-1105,528-Site Phase Product Quantity in Cart
  Boolean hasAggregation = false;
  try{

	ConfigId = cart.getConfigSO().Id;

	configSO = cart.getConfigSO();
	Decimal cqQuoteTotal = 0;
	Boolean isDiscountEligibleLineItemExist = false;
	Boolean isDiscountsNotApplied = false;
	List<CPQ_QuoteContractualDiscount__c> contractualDiscounts;
	//Surround CQ Req: May Release - modified - added CPQ_isCQ__c field
	Prodid=[select id,Quote_Type__c,NokiaCPQ_Portfolio_From_Quote__c,CPQ_IsNCQ__c,CPQ_IsCQ__c,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where id=:ConfigId];//modified by jithin - isNCQ - added CPQ_IsNCQ__c
	if(Prodid.Apttus_QPConfig__Proposald__c != null) {
	  quote =  [Select id,NokiaCPQ_Environment_Access_Type__c,Quote_Type__c,NokiaCPQ_LEO_Discount__c,NokiaCPQ_Is_Maintenance_Quote__c,NokiaCPQ_Portfolio__c,CPQ_Contractual_Condition_Updated__c,CPQ_Contractual_Discounts_Updated__c from Apttus_Proposal__Proposal__c where id = :Prodid.Apttus_QPConfig__Proposald__c];
	  //get the count of discounts under CQ quote
	  contractualDiscounts = QTC_DataExtract.getQuoteContractualDiscounts(quote.Id);
	}
	//Surround CQ Req: May Release - start
	Boolean isCQFlow = false;
	if(Prodid.CPQ_IsCQ__c) {
	  isCQFlow = true;
	}
	Map<String, String> mapValues = Apttus_Config2.RuntimeContext.getParameters();
	//Changes made as part of REQ-1105,528-Site Phase Product Quantity in Cart
	if (!Test.isRunningTest()) {
	  pageAction = mapValues != null && mapValues.size() > 0 && mapValues.containsKey('pageAction') ? mapValues.get('pageAction') : '';
	}
	else{
	  pageAction = 'Finalize';
	}
	//Surround CQ Req: May Release - end

	//Surround CQ Req: May Release - modified - added CPQ_isCQ__c condition
	if((!String.isblank(Prodid.Quote_Type__c) && Prodid.Quote_Type__c.contains('CPQ')) || Prodid.CPQ_IsNCQ__c  || isCQFlow) {//modified by jithin - isNCQ - added isNCQ condition
	  //Surround CQ Req: May Release - modified - added fields
	  //Changes made as part of REQ-1105,528-Site Phase Product Quantity in Cart start
	  List<string> selectFields = new List<string> {'id','Apttus_Config2__PrimaryLineNumber__c','CPQ_State__c','CPQ_SSF_Billing_Rule_ID__c','CPQ_Contracted_Price__c','CPQ_SSF_Permission__c','Apttus_Config2__AddedBy__c','CPQ_SSF_Term__c','Apttus_Config2__SellingTerm__c','Apttus_Config2__LineType__c','CPQ_Rollup_Group_Num__c','Apttus_Config2__NetPrice__c','CPQ_Product_Description__c','CPQ_Rollup_Group_Parent__c','CPQ_Contractual_Discounts_Applied__c','CPQ_Secondary_Category__c','CPQ_Price_Class__c','CPQ_Uploaded_via_SSF__c','CPQ_SSF_Quantity__c','Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c','Apttus_Config2__ProductId__r.IsActive','Apttus_Config2__ProductId__r.name','Apttus_Config2__ProductId__r.ProductCode','Apttus_Config2__ProductId__r.Portfolio__c','Apttus_Config2__ProductId__r.Direct_Portfolio__c','Apttus_Config2__ProductId__r.CPQ_ICD_Code__c','Apttus_Config2__ProductId__r.CPQ_Secondary_Category__c','Apttus_Config2__OptionId__r.name','Apttus_Config2__OptionId__r.IsActive','Apttus_Config2__ProductId__c','Apttus_Config2__OptionId__c','Apttus_Config2__BasePriceOverride__c','NokiaCPQ_Rationale_Of_Adjustment__c','Apttus_Config2__AdjustmentAmount__c','NokiaCPQ_Configuration_Type__c','NokiaCPQ_Spare__c','Item_Type__c','NokiaCPQ_Light_Color__c','NokiaCPQ_Is_CAT_Configured__c','CPQ_Market_Model__c','CPQ_Group_Quantity__c','Apttus_Config2__ExtendedQuantity__c','Apttus_Config2__Quantity__c','Apttus_Config2__ClassificationId__c','Apttus_Config2__ClassificationHierarchy__c','Source__c','NokiaCPQ_Part_Number__c','Apttus_Config2__LineNumber__c','Apttus_Config2__CopySourceNumber__c','Invalid_Maintenance_type__c','Apttus_Config2__ProductId__r.isInvalidProductCatalog__c'};
	  String soqlQuery = 'SELECT ' + String.join(selectFields, ',') + ' FROM  Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c =:ConfigId';
	  if (new List<string> { 'Direct CPQ', 'Indirect CPQ' }.IndexOf(Prodid.Quote_Type__c) >= 0 && pageAction.equalsIgnoreCase('Finalize')) {
		sitePhaseQuantities = [SELECT NCPQ_Quantity__c, Line_Item__c, Line_Item__r.Apttus_Config2__Quantity__c, NCPQ_Site__c, NCPQ_Site__r.Name, NCPQ_Phase__c, NCPQ_Phase__r.Name, Id FROM CPQ_Site_Phase_and_Quantity__c WHERE Line_Item__r.Apttus_Config2__ConfigurationId__c =: ConfigId ORDER BY NCPQ_Phase__c NULLS LAST LIMIT 1];
		if (sitePhaseQuantities != null && sitePhaseQuantities.size() > 0) {
		  hasAggregation = Nokia_CPQ_Utility.hasAggregation(ConfigId);
		  soqlQuery = 'SELECT ' + String.join(selectFields, ',') + ',(SELECT NCPQ_Quantity__c,Line_Item__c,Line_Item__r.Apttus_Config2__Quantity__c,NCPQ_Site__c,NCPQ_Site__r.Name,NCPQ_Phase__c,NCPQ_Phase__r.Name,Id FROM Site_Phase_and_Quantity__r ORDER BY NCPQ_Site__r.Name,NCPQ_Phase__r.Name) FROM  Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c =:ConfigId';
		}
	  }
	  Lineitemlist1 = Database.query(soqlQuery);
	  //Surround CQ Req: May Release - modified - added fields CPQ_Contractual_Discounts_Updated__c,CPQ_Contractual_Discounts_Updated__c

	  set<Id> Pricelistid= new set<Id>();
	  Map<ID,Boolean> ProductMap= new Map<ID,Boolean>();
	  Boolean isOnlyMaintenance=true;
	  String zeroQuantProd = '';
	  // added by Nandeesh for Jarvis Upload
	  //   If(Lineitemlist1.size() > 0 && Prodid.Quote_Type__c == 'Direct CPQ' && Prodid.NokiaCPQ_Portfolio_From_Quote__c == 'IP Routing'){
	  //  for(Apttus_Config2__LineItem__c litem : Lineitemlist1){
	  //	if(litem.Source__c == 'JARVIS' && litem.Apttus_Config2__CopySourceNumber__c== 0 && litem.Apttus_Config2__Quantity__c==1){
	  //	System.debug('ValidationCB---'+litem.NokiaCPQ_Part_Number__c+'---'+zeroQuantProd);
	  //	  zeroQuantProd += '('+'['+litem.Apttus_Config2__LineNumber__c+']-'+litem.NokiaCPQ_Part_Number__c +')' + ',';
	  //	}
	  //  }
	  //   }
	  //   System.debug('zeroQuantProd--'+ zeroQuantProd);
	  //   if(!String.isBlank(zeroQuantProd) ){
	  //  result.Messages.add(new ApexPages.Message(ApexPages.Severity.WARNING,'Some products had a quantity of 0 in the JARVIS file that have been defaulted to 1. Please change the quantity if needed for the following products: '+ zeroQuantProd.removeEnd(',')));
	  //  result.isSuccess = true;
	  //   }

	  If(Lineitemlist1.size() > 0)
	  {
		//Surround CQ Req: May Release - store parent details for rollup groups in CQ quotes - start
		Map<Decimal, Decimal> grpParentMap = new Map<Decimal, Decimal> ();
		if (isCQFlow) {
		  for (Apttus_Config2__LineItem__c lin: Lineitemlist1) {
			if (lin.CPQ_Rollup_Group_Num__c != null) {
			  Decimal count = grpParentMap.containskey(lin.CPQ_Rollup_Group_Num__c) ? grpParentMap.get(lin.CPQ_Rollup_Group_Num__c) : 0;
			  if (lin.CPQ_Rollup_Group_Parent__c) {
				grpParentMap.put(lin.CPQ_Rollup_Group_Num__c, count + 1);
			  } else {
				grpParentMap.put(lin.CPQ_Rollup_Group_Num__c, count);
			  }
			}
		  }
		}
		//Surround CQ Req: May Release - store parent details for rollup groups in CQ quotes - end

		for(Apttus_Config2__LineItem__c lin:Lineitemlist1) {
		  if(lin.Source__c == 'JARVIS' && lin.Apttus_Config2__CopySourceNumber__c== 0 && lin.Apttus_Config2__Quantity__c==1) {
			System.debug('ValidationCB---'+lin.NokiaCPQ_Part_Number__c+'---'+zeroQuantProd);
			zeroQuantProd += '('+'['+lin.Apttus_Config2__LineNumber__c+']-'+lin.NokiaCPQ_Part_Number__c +')' + ',';
		  }
		  //Surround CQ Req: May Release - start
		  if (isCQFlow) {//hbrid quote changes

			//check for applicable product states
			if(!isEligibleState(lin)) {
			  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'The product \'' + lin.Apttus_Config2__ProductId__r.name + '\' with state ' + lin.CPQ_State__c+ ' can not be added to the cart.'));
			  result.isSuccess = false;
			}

			//Term and quantity can not be changed for SSF uploaded line items
			if (lin.CPQ_Uploaded_via_SSF__c) {
			  if(lin.CPQ_SSF_Quantity__c != lin.Apttus_Config2__Quantity__c) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'The quantity for the product \'' + lin.Apttus_Config2__ProductId__r.name + '\' can not be changed from original quantity of : ' + lin.CPQ_SSF_Quantity__c));
				result.isSuccess = false;
			  }
			  if (lin.CPQ_SSF_Term__c != lin.Apttus_Config2__SellingTerm__c) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'The selling term for the product \'' + lin.Apttus_Config2__ProductId__r.name + '\' can not be changed from original term of : ' + lin.CPQ_SSF_Term__c));
				result.isSuccess = false;
			  }
			}
			//Proposed price is required for SSF Billing line items & User added Incentive line items for standalone line items
			if(!lin.CPQ_Uploaded_via_SSF__c && isStandloneLineItem(lin) && (isSSFBillingLineItem(lin) || (isIncentiveLineItem(lin) && lin.Apttus_Config2__AddedBy__c != null && lin.Apttus_Config2__AddedBy__c.equalsIgnoreCase('User')))) {
			  if (lin.Apttus_Config2__BasePriceOverride__c == null) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Proposed price is required for the product # ' +lin.Apttus_Config2__PrimaryLineNumber__c+ ': ' + lin.Apttus_Config2__ProductId__r.name ));
				result.isSuccess = false;
			  }
			}
			//Proposed price is not allowed for Bundles & Options and System added incentive line items && ssf uploaded line.
			if(!isStandloneLineItem(lin) || lin.CPQ_Uploaded_via_SSF__c || (isIncentiveLineItem(lin) && lin.Apttus_Config2__AddedBy__c != null && lin.Apttus_Config2__AddedBy__c.equalsIgnoreCase('System'))) {
			  if (lin.Apttus_Config2__BasePriceOverride__c != null) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Proposed price is not allowed for the product # ' +lin.Apttus_Config2__PrimaryLineNumber__c+ ': ' + lin.Apttus_Config2__ProductId__r.name ));
				result.isSuccess = false;
			  }
			}
			//Term and SSF Billing rule is required for SSF Billing standlone line items if SSF Permission is ‘M’.
			if(!lin.CPQ_Uploaded_via_SSF__c && isStandloneLineItem(lin) && isSSFBillingLineItem(lin) && lin.CPQ_SSF_Permission__c != null && lin.CPQ_SSF_Permission__c.equalsIgnoreCase('M')) {
			  if(lin.Apttus_Config2__SellingTerm__c == null || lin.CPQ_SSF_Billing_Rule_ID__c == null) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Term and Billing rule is required for the product # ' +lin.Apttus_Config2__PrimaryLineNumber__c+ ': ' + lin.Apttus_Config2__ProductId__r.name ));
				result.isSuccess = false;
			  }
			}
			//SSF Billing rule is allowed only for SSF Billing && SSF uploaded standlone lineitems//changed
			if(!(isStandloneLineItem(lin) && (isSSFBillingLineItem(lin) || lin.CPQ_Uploaded_via_SSF__c))) {
			  if(lin.CPQ_SSF_Billing_Rule_ID__c != null) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Billing rule is not allowed for the product: ' + lin.Apttus_Config2__ProductId__r.name ));
				result.isSuccess = false;
			  }
			}

			//product description is allowed only for service standlone line items
			if(!((isStandloneLineItem(lin) && isServiceLineItem(lin)) || lin.CPQ_Uploaded_via_SSF__c)) {
			  if(String.isNotBlank(lin.CPQ_Product_Description__c)) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Product description not allowed for the product: ' + lin.Apttus_Config2__ProductId__r.name ));
				result.isSuccess = false;
			  }
			}
			//validation to check group parents are populated
			if (!lin.Apttus_Config2__LineType__c.equalsIgnoreCase('Option') && (lin.Apttus_Config2__ProductId__r.CPQ_Secondary_Category__c != 'Incentive') && lin.Apttus_Config2__LineType__c.equalsIgnoreCase('Product/Service') && String.isNotBlank(lin.Item_Type__c) && lin.Item_Type__c.equalsIgnoreCase('Service')) {
			  if (grpParentMap.containsKey(lin.CPQ_Rollup_Group_Num__c) && grpParentMap.get(lin.CPQ_Rollup_Group_Num__c) != 1) {
				result.isSuccess = false;
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Group Parent is mandatory for every unique value of roll up group: product code: ' + lin.Apttus_Config2__ProductId__r.name + ' </br>Info: A group can have only one parent.'));
			  }
			}

			//Net price of individual line items can not be less than 0 except incentive line items, ssf uploaded line items - todo
			if(!(isIncentiveLineItem(lin) || lin.CPQ_Uploaded_via_SSF__c)) {
			  if (lin.Apttus_Config2__BasePriceOverride__c != null && lin.Apttus_Config2__BasePriceOverride__c < 0) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Net price can not be less than zero for the product: ' + lin.Apttus_Config2__ProductId__r.name));
				result.isSuccess = false;
			  }
			}

			//check for discounts eleigible line items for quote level discount change validation
			if (isDiscountsEligibleLineItem(lin) && quote.CPQ_Contractual_Discounts_Updated__c) {
			  isDiscountEligibleLineItemExist = true;
			}
			//check for lines discounts not applied
			if(contractualDiscounts != null && !contractualDiscounts.isEmpty() && isDiscountsEligibleLineItem(lin) && !lin.CPQ_Contractual_Discounts_Applied__c) {
			  isDiscountsNotApplied = true;
			}

			//store line item price to calculate total
			cqQuoteTotal = cqQuoteTotal + lin.Apttus_Config2__NetPrice__c;
		  }
		  //Surround CQ Req: May Release - end
		  //7253 added by srisailam 04/03/2021
		  if(quote.NokiaCPQ_Is_Maintenance_Quote__c
			 && lin.NokiaCPQ_Spare__c && quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ)) {
			result.isSuccess = false;
			result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Spares cannot be selected for the Maintenance only quote'));
		  }
		  if(!String.isBlank(Prodid.NokiaCPQ_Portfolio_From_Quote__c) && !Prodid.NokiaCPQ_Portfolio_From_Quote__c.equalsignorecase('QTC'))//modified by jithin - isNCQ - added null check
		  {

			if (lin.Apttus_Config2__LineType__c== 'Product/Service')
			{

			  if(lin.Apttus_Config2__ProductId__r.ProductCode!='MT001' &&
				 lin.Apttus_Config2__ProductId__r.ProductCode!='MT002'
				 && lin.Apttus_Config2__ProductId__r.ProductCode!='SSP002' && lin.Apttus_Config2__ProductId__r.ProductCode!='SRS')
			  {
				isOnlyMaintenance=false;
			  }
			  else if(lin.Apttus_Config2__AdjustmentAmount__c != null)
			  {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,Nokia_CPQ_Constants.NoAdjustment_MAINT));
				result.isSuccess = false;
			  }

			  if (lin.Apttus_Config2__ProductId__r.IsActive == false ) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'The Quote cannot be validated as it contains products that are no longer available for purchase. Please remove the following items:' + lin.Apttus_Config2__ProductId__r.name));
				result.isSuccess = false;
			  }

			}
			if (!Prodid.NokiaCPQ_Portfolio_From_Quote__c.equalsignorecase(Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO) && lin.NokiaCPQ_Spare__c==True && ((Nokia_CPQ_Constants.lin_Apttus_QPConfig.equals(lin.Apttus_Config2__LineType__c) && Nokia_CPQ_Constants.BUNDLE.equals(lin.NokiaCPQ_Configuration_Type__c)) ||
																																					  Nokia_CPQ_Constants.NOKIA_OPTION.equals(lin.Apttus_Config2__LineType__c) || !Nokia_CPQ_Constants.HARDWARE_STRING.equals(lin.Item_Type__c))) {
			  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.RestrictSpare));
			  result.isSuccess = false;
			}
			else if(lin.Apttus_Config2__LineType__c == 'Option') {
			  if (lin.Apttus_Config2__OptionId__r.IsActive == false ) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'The Quote cannot be validated as it contains products that are no longer available for purchase. Please remove the following items:' + lin.Apttus_Config2__OptionId__r.name ));
				result.isSuccess = false;
			  }
			}
			system.debug('quote.NokiaCPQ_Portfolio__c'+quote.NokiaCPQ_Portfolio__c);
			system.debug('lin.Apttus_Config2__ProductId__r.Portfolio__c'+lin.Apttus_Config2__ProductId__r.Portfolio__c);
			if((!String.isEmpty(lin.Apttus_Config2__ProductId__r.Portfolio__c ) && !String.isBlank(lin.Apttus_Config2__ProductId__r.Portfolio__c) && !lin.Apttus_Config2__ProductId__r.Portfolio__c.equalsignorecase(quote.NokiaCPQ_Portfolio__c)) && quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ)) { //ITCCPQ-2594


			   result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'The Quote cannot be finalized as it contains products that do not belong to the portfolio you selected on the quote. Please remove the following items:' +lin.Apttus_Config2__ProductId__r.name  ));
			   result.isSuccess = false;


			}
			//Heema enterprise FN functionality
			else if(quote.NokiaCPQ_Portfolio__c.equalsignorecase(Nokia_CPQ_Constants.NOKIA_FN) && (!String.isEmpty(lin.Apttus_Config2__ProductId__r.Direct_Portfolio__c ) && !String.isBlank(lin.Apttus_Config2__ProductId__r.Direct_Portfolio__c) && (!quote.NokiaCPQ_Portfolio__c.equalsignorecase(lin.Apttus_Config2__ProductId__r.Direct_Portfolio__c)))) {

			  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'The Quote cannot be finalized as it contains products that do not belong to the portfolio you selected on the quote. Please remove the following items:' +lin.Apttus_Config2__ProductId__r.name  ));
			  result.isSuccess = false;

			}
		  }

		  //Monika: Req:7278 - Throwing the error message when Spare field is checked for MPW Portfolio  :9/4/2020
		  if(lin.NokiaCPQ_Spare__c == True && quote.NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION) {
			result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,Nokia_CPQ_Constants.MPW_SPARE_VALIDATION_ERROR_MSG));
			result.isSuccess = false;
		  }
		  //end

		  //Microwave CAT Requirement
		  if(quote.NokiaCPQ_Portfolio__c==Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO && !lin.NokiaCPQ_Is_CAT_Configured__c && lin.NokiaCPQ_Configuration_Type__c.equals(Nokia_CPQ_Constants.BUNDLE)) {
			result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,Nokia_CPQ_Constants.CATERROR));
			result.isSuccess = false;
		  }

		  //Spare Validation for Microwave
		  if(quote.NokiaCPQ_Portfolio__c==Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO)
		  {
			if((lin.NokiaCPQ_Spare__c == False && lin.Apttus_Config2__ClassificationHierarchy__c==system.label.Microwave_Spares_Catalog && !lin.NokiaCPQ_Is_CAT_Configured__c && lin.NokiaCPQ_Configuration_Type__c != Nokia_CPQ_Constants.BUNDLE) ||
			   (lin.NokiaCPQ_Spare__c == true && (lin.Apttus_Config2__ClassificationHierarchy__c !=system.label.Microwave_Spares_Catalog || lin.NokiaCPQ_Is_CAT_Configured__c || lin.NokiaCPQ_Configuration_Type__c.equals(Nokia_CPQ_Constants.BUNDLE ))))
			{
			  result.Messages.add(new ApexPages.Message(ApexPages.Severity.Warning,Nokia_CPQ_Constants.SPARE_VALIDATION_WARNING_MSG));
			  result.isSuccess = false;
			}
		  }
		  //End of Validation
		  //added by jithin - isNCQ - validation to check manual change of quantities to be multiples of group quantities - start
		  if(Prodid.CPQ_IsNCQ__c || isCQFlow) {
			if(lin.CPQ_Market_Model__c<>NULL) {
			  Integer groupQuantity = Integer.valueOf((lin.CPQ_Group_Quantity__c == null || lin.CPQ_Group_Quantity__c == 0) ? 1 : lin.CPQ_Group_Quantity__c);
			  Integer lineQuantity = Integer.valueOf(lin.Apttus_Config2__Quantity__c);
			  System.debug('groupQuantity::> '+groupQuantity +' '+ '>lineQuantity::> '+lineQuantity);
			  if(Math.mod(lineQuantity, groupQuantity)<>0) {
				result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'Item ' +lin.Apttus_Config2__ProductId__r.name +' is part of a Flexible Group. The quantity you entered is invalid. The quantity entered must be a multiple of the Flexible Group Quantity : ' + groupQuantity ));
				result.isSuccess = false;
			  }
			}
		  }
		  //added by jithin - isNCQ - validation to check manual change of quantities to be multiples of group quantities - end
		}
		if(!String.isBlank(zeroQuantProd) ) {
		  result.Messages.add(new ApexPages.Message(ApexPages.Severity.WARNING,'Some products had a quantity of 0 in the JARVIS file that have been defaulted to 1. Please change the quantity if needed for the following products: '+ zeroQuantProd.removeEnd(',')));
		  result.isSuccess = true;
		}

		//Surround CQ Req: May Release
		//hybrid quote changes
		if (isCQFlow) {
		  //Quote total can not be less than zero
		  if(cqQuoteTotal < 0) {
			result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cart total can not be less than zero, please adjust your discounts.'));
			result.isSuccess = false;
		  }
		  //Reapply discounts if Quote level discounts are added/modified.
		  if(isDiscountEligibleLineItemExist) {
			result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Discounts have been changed under quote header. Please re-apply discounts.'));
			result.isSuccess = false;
		  }

		  //Apply discounts for those line discounts not applied
		  if(isDiscountsNotApplied) {
			result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, 'Discounts not applied for some line items.'));
			result.isSuccess = false;
		  }
		}
		//Surround CQ Req: May Release - validate cart total price - end
		//Heema :Req 6383
		if(isOnlyMaintenance==true && quote.NokiaCPQ_Is_Maintenance_Quote__c==false && !quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase('QTC')) {
		  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR,'You must select at least one catalog or custom product in the cart before you can finalize.'));
		  result.isSuccess = false;
		}
	  }


	  //}
	  /* Requirement   : Req:6001
	   * Developer   : Piyush Tawari
	   * Description   : warning messages on cart for product
		 1.if adjustment given but rationale not provided*/
	  if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) && !quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase('QTC') ) {
		system.debug('In directquote code');
		list<string> lstProdCode = new list<string> ();
		if(Lineitemlist1.size() > 0) {
		  for(Apttus_Config2__LineItem__c lin:Lineitemlist1) {
			//srisailam 484
			if (lin.Invalid_Maintenance_type__c == true && pageAction == 'Finalize') {
			  lstProdCode.add(lin.Apttus_Config2__ProductId__r.ProductCode);
			}
			/* Requirement   : Req:6671,6670,6500
			 * Developer   : Piyush Tawari, Kamlesh Jandu
			 * Description   : Error message on cart if Guidance is RED */
			String DealGuidancePortfolios = System.label.Deal_Guidance_Applicable_Portfolios;
			if(DealGuidancePortfolios.contains(quote.NokiaCPQ_Portfolio__c)) {
			  Boolean isPricingManager = FeatureManagement.checkPermission(Nokia_CPQ_Constants.PRICING_MANAGER);
			  //system.debug(isPricingManager );
			  Boolean isSalesUser = FeatureManagement.checkPermission(Nokia_CPQ_Constants.CPQ_SALES_USER);
			  if(PageAction == 'Finalize') {
				if(isSalesUser && !isPricingManager &&
				   !Nokia_CPQ_Constants.BUNDLE.equals(lin.NokiaCPQ_Configuration_Type__c) &&
				   lin.NokiaCPQ_Light_Color__c == Nokia_CPQ_Constants.RED ) {
				  result.isSuccess = false;
				  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, System.label.Deal_Guidance_Error));
				  return result;

				}
			  }
			}
		  }
		}
		if (lstProdCode.size() > 0 && !lstProdCode.isEmpty()) {
		  result.isSuccess = false;
		  result.Messages.add(new ApexPages.Message(ApexPages.Severity.WARNING, ' The Products ' + String.join(lstProdCode, ',') + ' cannot be supported by the maintenance type selected. Please use a supported maintenance option.'));
		  return result;
		}

	  }
	}

	/* Requirement   : Req:itccpq-461
	 * Developer   : Ameena
	 * Description   : Warning message on cart if Quote is maintenance quote */
	//validation
	/*if(quote.NokiaCPQ_Is_Maintenance_Quote__c && Prodid.Quote_Type__c!=null && Prodid.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ)){
	   result.Messages.add(new ApexPages.Message(ApexPages.Severity.WARNING, 'For Maintenance Only Quotes all product prices are displayed as 0.00'));
	   result.isSuccess = true;
	   return result;
	   }*/
  }

  catch(exception ex) {
	System.debug('EXception --- ' +ex);
  }

  result.isSuccess = true;

  if(!String.isblank(Prodid.Quote_Type__c) && Prodid.Quote_Type__c.contains('CPQ') && !Prodid.NokiaCPQ_Portfolio_From_Quote__c.equalsignorecase('QTC')) {
	prdConfig =  cart.getConfigSO();
	if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ)) {

	  List<Apttus_Config2__SummaryGroup__c> summaryLines = [Select Id,Name,Apttus_Config2__ExtendedPrice__c,NokiaCPQ_Net_Price__c,Apttus_Config2__Description__c,Apttus_Config2__AdjustmentAmount__c from Apttus_Config2__SummaryGroup__c Where Apttus_Config2__ConfigurationId__c = :prdConfig.Id];

	  if(Nokia_CPQ_Constants.NOKIA_PROPOSAL.equalsIgnoreCase(prdConfig.Apttus_Config2__BusinessObjectType__c)) {

		if(!isChargeTypeMaintenance(summaryLines)) {

		  result.isSuccess = false;
		  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, Nokia_CPQ_Constants.NOKIA_CHARGE_TYPE_ERROR_MSG));

		  return result;
		}

		if(isCADCorrect(summaryLines)) {

		  result.isSuccess = false;
		  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, Nokia_CPQ_Constants.NOKIA_CAD_ERROR_MSG));

		  return result;
		}
		if(quote.NokiaCPQ_LEO_Discount__c== true && isValidLEOAmount(summaryLines)) {
		  system.debug('i am LEO');
		  result.isSuccess = false;
		  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, Nokia_CPQ_Constants.NOKIA_LEO_WARNING_MSG));
		  system.debug('result'+result);
		  return result;
		}
	  }
	}
	else if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ))
	{
	  List<Apttus_Config2__SummaryGroup__c> summaryList = [Select Id,Name,NokiaCPQ_Net_Price__c,Apttus_Config2__Description__c,Apttus_Config2__ExtendedPrice__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__AdjustmentType__c from Apttus_Config2__SummaryGroup__c Where Apttus_Config2__ConfigurationId__c = :prdConfig.Id];
	  //Enterprise Hypercare - Sept 2020
	  System.debug('SummaryList:'+summaryList);
	  for(Apttus_Config2__SummaryGroup__c summaryLine : summaryList)
	  {
		System.debug('summaryLine:'+summaryLine);
		if(summaryLine.Name == Nokia_CPQ_Constants.SUBTOTAL_ONE_TIME && summaryLine.Apttus_Config2__AdjustmentAmount__c != null && (Double.valueOf(summaryLine.Apttus_Config2__AdjustmentAmount__c) < 0.00 || (summaryLine.Apttus_Config2__AdjustmentType__c == Nokia_CPQ_Constants.DISCOUNT_PERCENT && Double.valueOf(summaryLine.Apttus_Config2__AdjustmentAmount__c) >= 100.00)))
		{
		  result.isSuccess = false;
		  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, Nokia_CPQ_Constants.NOKIA_LSD_ERROR_MSG));

		  return result;
		}
	  }
	}

  }
  /* Requirement   : Req:6337
   * Developer   : Priyanka Agrawal
   * Description   : warning messages on cart for NP
	 1.if NP not equal to CNP - Reserves*/
  if(!String.isblank(Prodid.Quote_Type__c) && Prodid.Quote_Type__c.contains('CPQ') && !Prodid.NokiaCPQ_Portfolio_From_Quote__c.equalsignorecase('QTC')) {
	if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ) && quote.NokiaCPQ_Portfolio__c != 'QTC' ) {
	  List<CPQ_Advance_Pricing__mdt> tempData = new List<CPQ_Advance_Pricing__mdt>();
	  tempData = [Select MasterLabel,Action_Name__c from CPQ_Advance_Pricing__mdt where MasterLabel = :quote.NokiaCPQ_Portfolio__c];
	  if(!tempData.isEmpty()) {
		List<Apttus_Config2__SummaryGroup__c> summaryLines = [Select Id,Nokia_CPQ_Reserves__c,NokiaCPQ_Extended_CNP_2__c,NokiaCPQ_Extended_NP__c from Apttus_Config2__SummaryGroup__c Where Name = 'Total (One Time)' AND Apttus_Config2__ConfigurationId__c = :ConfigId LIMIT 1];

		if(PageAction == tempData[0].Action_Name__c) {
		  Decimal differnceCNP = (summaryLines[0].NokiaCPQ_Extended_CNP_2__c - (summaryLines[0].Nokia_CPQ_Reserves__c*summaryLines[0].NokiaCPQ_Extended_CNP_2__c)/100).setScale(2, RoundingMode.HALF_UP);
		  system.debug('differnceCNP---in loop'+differnceCNP + ' NP**' + summaryLines[0].NokiaCPQ_Extended_NP__c);
		  if(differnceCNP != summaryLines[0].NokiaCPQ_Extended_NP__c ) {
			system.debug('PageAction'+PageAction);
			result.isSuccess = false;
			result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, Nokia_CPQ_Constants.AdvacncePricing_error));

			return result;
		  }
		}
	  }
	}
  }

  //Changes made as part of REQ-1105,528-Site Phase Product Quantity in Cart start
  if (!String.isblank(Prodid.Quote_Type__c) && new List<string> { 'Direct CPQ', 'Indirect CPQ' }.IndexOf(Prodid.Quote_Type__c) >= 0 && sitePhaseQuantities != null && sitePhaseQuantities.size() > 0) {
	Boolean quoteUsesPhases = sitePhaseQuantities[0].NCPQ_Phase__c != null;
	if (Lineitemlist1 != null && Lineitemlist1.size() > 0) {
	  for (Apttus_Config2__LineItem__c line: Lineitemlist1) {
		if (line.Apttus_Config2__LineType__c != Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES || Nokia_CPQ_Utility.getMaintAndSSPSRSProdCodes().indexOf(line.Apttus_Config2__ProductId__r.ProductCode) >= 0 || line.Apttus_Config2__ProductId__r.isInvalidProductCatalog__c) {
		  continue;
		}
		Integer lineQuantity = line.Apttus_Config2__Quantity__c.intValue();
		Integer totalAllocatedQuantity = 0;
		if (line.Site_Phase_and_Quantity__r != null && line.Site_Phase_and_Quantity__r.size() > 0) {
		  for (CPQ_Site_Phase_and_Quantity__c sitePhase: line.Site_Phase_and_Quantity__r) {

			//Added condition for Aggregation (ITCCPQ-1125(2190)) by Christie

			if (sitePhase.NCPQ_Quantity__c == null || sitePhase.NCPQ_Quantity__c < 0 || sitePhase.NCPQ_Quantity__c > 99999999) {
			  result.isSuccess = false;
			  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, hasAggregation ? Nokia_CPQ_Constants.SITEPHASEAGGREGATION_MESSAGE : Nokia_CPQ_Constants.SITEPHASE_MESSAGE));
			  return result;
			}

			if (quoteUsesPhases && sitePhase.NCPQ_Phase__c == null && sitePhase.NCPQ_Quantity__c.intValue() != 0) {
			  result.isSuccess = false;
			  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, hasAggregation ? Nokia_CPQ_Constants.SITEPHASEAGGREGATION_MESSAGE : Nokia_CPQ_Constants.SITEPHASE_MESSAGE));
			  return result;
			}
			totalAllocatedQuantity += sitePhase.NCPQ_Quantity__c.intValue();
		  }
		  if (totalAllocatedQuantity != lineQuantity) {
			result.isSuccess = false;
			result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, hasAggregation ? Nokia_CPQ_Constants.SITEPHASEAGGREGATION_MESSAGE : Nokia_CPQ_Constants.SITEPHASE_MESSAGE));
			return result;
		  }
		} else {
		  result.isSuccess = false;
		  result.Messages.add(new ApexPages.Message(ApexPages.Severity.ERROR, hasAggregation ? Nokia_CPQ_Constants.SITEPHASEAGGREGATION_MESSAGE : Nokia_CPQ_Constants.SITEPHASE_MESSAGE));
		  return result;
		}
	  }
	}
  }
  //Changes made as part of REQ-1105,528-Site Phase Product Quantity in Cart finish

  return result;
}

/* Method Name   : validateCart
 * Developer   : Rupesh Sharma
 * Description   : This method returns true when the CAD is applied on any Sub Total Lines */
@TestVisible private Boolean isChargeTypeMaintenance(List<Apttus_Config2__SummaryGroup__c> summaryLines) {
  /*maintenance Fee Flag*/
  @TestVisible Boolean isMaintenanceFee = TRUE;

  for(Apttus_Config2__SummaryGroup__c osl:summaryLines)
  {
	if(osl.Apttus_Config2__Description__c!=null && osl.Apttus_Config2__AdjustmentAmount__c!=null&&!((osl.Apttus_Config2__Description__c.equalsIgnoreCase('Total (One Time) (One Time)')) || (osl.Apttus_Config2__Description__c.equalsIgnoreCase('Total (One Time)')))&&Double.valueOf(osl.Apttus_Config2__AdjustmentAmount__c)>0.00)
	{
	  isMaintenanceFee = FALSE;
	}
  }
  return isMaintenanceFee;
}



/* Method Name   : validateCart
 * Developer   : Rupesh Sharma
 * Description   : This method returns true when the CAD is applied wrong */
@TestVisible private Boolean isCADCorrect(List<Apttus_Config2__SummaryGroup__c> summaryLines) {
  /*CAD discount Flag*/
  @TestVisible Boolean isCADcorrect = FALSE;
  for(Apttus_Config2__SummaryGroup__c osl:summaryLines)
  {
	if(osl.Apttus_Config2__Description__c!=null && osl.Apttus_Config2__AdjustmentAmount__c!=null&&(osl.Apttus_Config2__Description__c.equalsIgnoreCase('Total (One Time) (One Time)')|| osl.Apttus_Config2__Description__c.equalsIgnoreCase('Total (One Time)'))&& osl.Apttus_Config2__AdjustmentAmount__c>osl.Apttus_Config2__ExtendedPrice__c)
	{
	  isCADcorrect = TRUE;
	}
  }
  return isCADcorrect;
}
/*Method name validate cart
 * developer : heema solanki
 * Description : this method will return true if quote amunt is less than 500 for LEO */
@TestVisible private Boolean isValidLEOAmount(List<Apttus_Config2__SummaryGroup__c> summaryLines) {
  /*valid LEO amount check*/
  @TestVisible Boolean isValidLEOAmount = FALSE;
  for(Apttus_Config2__SummaryGroup__c osl:summaryLines)
  {
	if(osl.Apttus_Config2__Description__c!=null && (osl.Apttus_Config2__Description__c.equalsIgnoreCase('Total (One Time) (One Time)') || osl.Apttus_Config2__Description__c.equalsIgnoreCase('Total (One Time)')) && osl.NokiaCPQ_Net_Price__c < 500)
	{
	  isValidLEOAmount = TRUE;
	}
  }

  return isValidLEOAmount;
}

/* Method Name   : validateCart
 * Developer   : Apttus
 * Description   : OOTB */
global Apttus_Config2.CustomClass.ValidationResult validateRampLineItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2.LineItem> rampLineItems) {
  Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true);
  return result;
}

/* Method Name   : validateCart
 * Developer   : Apttus
 * Description   : OOTB */
global Apttus_Config2.CustomClass.ValidationResult validateAssetItems(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2__TempRenew__c> assetItems) {

  Apttus_Config2.CustomClass.ValidationResult result= new Apttus_Config2.CustomClass.ValidationResult(true);
  return result;
}

/*********helper mthods - start**********/
private Boolean isStandloneLineItem(Apttus_Config2__LineItem__c lineItem) {
  Boolean isStandloneLineItem = false;
  if(lineItem.Apttus_Config2__LineType__c.equalsIgnoreCase('Product/Service') && lineItem.Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c.equalsIgnoreCase('Standalone')) {
	isStandloneLineItem = true;
  }
  return isStandloneLineItem;
}
private Boolean isSSFBillingLineItem(Apttus_Config2__LineItem__c lineItem) {
  return lineItem.CPQ_SSF_Permission__c != null ? true : false;
}
private Boolean isIncentiveLineItem(Apttus_Config2__LineItem__c lineItem) {
  String secondaryCategory = lineItem.CPQ_Secondary_Category__c;
  if(String.isNotBlank(secondaryCategory) && secondaryCategory.equalsIgnoreCase('Incentive')) {
	return true;
  } else {
	return false;
  }
}
private Boolean isServiceLineItem(Apttus_Config2__LineItem__c lineItem) {
  String itemType = lineItem.Item_Type__c;
  if(String.isNotBlank(itemType) && itemType.equalsIgnoreCase('Service')) {
	return true;
  } else {
	return false;
  }
}

private Boolean isDiscountsEligibleLineItem(Apttus_Config2__LineItem__c lineItem) {
  Boolean isDiscountsEligibleLineItem  = false;
  if(isStandloneLineItem(lineItem) && lineItem.Apttus_Config2__BasePriceOverride__c == null && lineItem.CPQ_Contracted_Price__c != null) {
	isDiscountsEligibleLineItem = true;
  }
  return isDiscountsEligibleLineItem;
}

private Boolean isEligibleState(Apttus_Config2__LineItem__c lineItem) {
  Boolean isEligibleState  = false;
  Set<String> eligibleStates = new Set<String> {'Implement', 'Ramp Up', 'Release', 'Ramp Down'};
  if(String.isNotBlank(lineItem.CPQ_State__c) && eligibleStates.contains(lineItem.CPQ_State__c)) {
	isEligibleState = true;
  }
  return isEligibleState;
}
/*********helper mthods - end**********/
}