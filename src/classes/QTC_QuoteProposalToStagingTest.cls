/*******************************
Class Name:QTC_QuoteProposalToStagingTest
Created by: Accenture
Created Date: 6 December 2019
Last modified by: Accenture
Description: Test class for QTC_QuoteProposalToStaging
*******************************/
@istest
public class QTC_QuoteProposalToStagingTest 
{
	@isTest
	public static void RunTest()
	{
		Test.startTest();
		Set<Id> QuoteproposalId = new Set<Id>();
		Map<String, String> taskValuesMap = new Map<String, String>();
		QTC_QuoteProposalToStaging qtPrplStgng = new QTC_QuoteProposalToStaging(QuoteproposalId, taskValuesMap);
		
		String sourceObject = 'Apttus_Proposal__Proposal_Line_Item__c';
		String fieldName = 'Apttus_QPConfig__LineType__c';
		Schema.SObjectType sourceObjectType = Schema.getGlobalDescribe().get(sourceObject);
		Sobject genericObject = sourceObjectType.newSObject();
		
		String value = '';
		qtPrplStgng.checkForValidCondition(fieldName, value, genericObject);
		
		DataBase.executeBatch(qtPrplStgng);
		
		List<sObject> proposalLineItemList = new List<sObject>();
		proposalLineItemList.add(genericObject);
		qtPrplStgng.LoadQuoteData(proposalLineItemList);
		
		String xmlbody = '<?xml version="1.0" encoding="utf-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:mat="http://soap.sforce.com/schemas/class/NCP_InterfaceLogFromIpaaS_WS">';
		xmlbody += '<soapenv:Body><mat:CreateInterfaceLogFromIpaaS>';
		xmlbody += '<mat:jobId>7077c00001hZVxKAAW</mat:jobId>';
		xmlbody += '</mat:CreateInterfaceLogFromIpaaS>';
		xmlbody += '</soapenv:Body></soapenv:Envelope>';
		
		//Create Quote staging Record:
		List<Quote_Staging__c> quote_staging_Rec = new List<Quote_Staging__c>();		
		Quote_Staging__c qtstg = new Quote_Staging__c();
		qtstg.Request_Data__c = xmlbody;
		qtstg.QTEID__c ='1912345';
		qtstg.Quote_Number__c = '19.US.876785 Q 1';
		qtstg.PARTNRID__c = '1234567';
		quote_staging_Rec.add(qtstg);	   
		Database.INSERT(quote_staging_Rec);
		
		Quote_Staging__c quote_staging = quote_staging_Rec[0];
		String quoteNumber = '1234';
		Apttus_Proposal__Proposal_Line_Item__c lineItem = new Apttus_Proposal__Proposal_Line_Item__c();
		//qtPrplStgng.createLineItemStaging(quote_staging, quoteNumber, lineItem);
		
		sObject proposal_lineitem = genericObject;
		String field = fieldName;
		qtPrplStgng.addParentLineNumber(proposal_lineitem, field, quoteNumber);
		
		Decimal val1 = 12;
		Decimal val2 = 2;
		String operation = '';
		qtPrplStgng.mapCurrencyParameter(val1, val2, operation);
		
		Decimal currencyValue = 0.0;
		qtPrplStgng.getTotalOptionQuantity(proposal_lineitem, quoteNumber, currencyValue);
		
		Map<ID, Apttus_Proposal__Proposal__c> proposal_Map = new Map<ID, Apttus_Proposal__Proposal__c>();
		String QTE_BODY = '';
		qtPrplStgng.mapQuoteParameter(proposal_lineitem, quote_staging, proposal_Map, quoteNumber, QTE_BODY);
		
		qtPrplStgng.mapChildNodesWithParent(xmlbody);
		
		Dom.Document docNode = qtPrplStgng.getDomDocument(quote_staging_Rec[0]);
		Dom.XmlNode rootElement = docNode.getRootElement();
		String xmlField1 = '';
		qtPrplStgng.getChildXmlNode(rootElement, xmlField1);
		
		String field1 = '';
		sObject childObj;
		qtPrplStgng.getDataFromParent(field1, childObj);		
	   
		DateTime dateValue = DateTime.now();
		String targetField = '';
		String currencyStringValue = '';
		Decimal quantity = 1;
		QTC_QuoteProposalToStaging.createDateXMLStructure(rootElement, dateValue, targetField);
		qtPrplStgng.createCurrencyXMLStructure(rootElement, currencyStringValue, currencyValue, proposal_lineitem, targetField);
		qtPrplStgng.createRoundingAdjustmentStructure(rootElement, currencyValue, quantity, proposal_lineitem, targetField);
		qtPrplStgng.createQuantityXMLStructure(rootElement, currencyStringValue, currencyValue, proposal_lineitem, targetField);
		qtPrplStgng.deleteStaging(proposal_Map);
		Test.stopTest();
	}
	
	@testSetup static void setup() 
   {	
		//Create quote parameter entries
		List<Quote_Parameter__c> quoteParameterList = new List<Quote_Parameter__c>();
		Quote_Parameter__c param1 = new Quote_Parameter__c();
		param1.Target_Field__c = GlobalConstants.Add_QuoteAddMessage;
		param1.Target_Object__c = '';
		param1.Source_Field__c = '';
		param1.Source_Object__c = '';
		param1.Parameter_Value1__c = '';
		param1.Parameter_Value2__c ='';
		param1.Parameter_Type__c = GlobalConstants.Interface_String;
		param1.Active__c = true;
		quoteParameterList.add(param1);
		
		Quote_Parameter__c param2 = new Quote_Parameter__c();
		param2.Target_Field__c = 'BASE__c';
		param2.Target_Object__c = 'Quote_Staging__c';
		param2.Source_Field__c = 'NokiaCPQ_ExtendedPrice_CNP__c,Apttus_QPConfig__Quantity2__c';
		param2.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param2.Parameter_Value1__c = 'OPERATION';
		param2.Parameter_Value2__c ='DIVIDE';
		param2.Parameter_Type__c = 'Mapping Rule';
		param2.Active__c = true;
		quoteParameterList.add(param2);
		
		Quote_Parameter__c param3 = new Quote_Parameter__c();
		param3.Target_Field__c = 'DOCUMENTID__c';
		param3.Target_Object__c = 'Quote_Staging__c';
		param3.Source_Field__c = 'NokiaCPQ_Proposal_Id__c';
		param3.Source_Object__c = 'Apttus_Proposal__Proposal__c';
		param3.Parameter_Type__c = 'Mapping Rule';
		param3.Active__c = true;
		quoteParameterList.add(param3);
		
		Quote_Parameter__c param4 = new Quote_Parameter__c();
		param4.Target_Field__c = 'WarrantyContractNumber__c';
		param4.Target_Object__c = 'Quote_Staging__c';
		param4.Parameter_Value1__c = 'ALU12MSTANDARD';
		param4.Source_Object__c = 'Apttus_Proposal__Proposal__c';
		param4.Parameter_Type__c = 'Direct Value';
		param4.Active__c = true;
		quoteParameterList.add(param4);
		
		Quote_Parameter__c param5 = new Quote_Parameter__c();
		param5.Target_Field__c = 'UOM__c';
		param5.Target_Object__c = 'Quote_Staging__c';
		param5.Source_Field__c = 'Apttus_QPConfig__Uom__c';
		param5.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param5.Parameter_Type__c = 'Mapping Value';
		param2.Parameter_Value1__c = 'Each';
		param2.Parameter_Value2__c ='EA';
		param5.Active__c = true;
		quoteParameterList.add(param5);
		
		Quote_Parameter__c param6 = new Quote_Parameter__c();
		param6.Target_Field__c = '';
		param6.Target_Object__c = 'Quote_Staging__c';
		param6.Source_Field__c = 'Arcadia_Product_Code__c,Product_Code__c,Proposal__c,Quantity__c,Parent_Line_Item__r.Apttus_Config2__LineNumber__c,Proposal__r.NokiaCPQ_Portfolio__c,CurrencyISOCode,Proposal__r.NokiaCPQ_Proposal_Id__c';
		param6.Source_Object__c = 'Quote_Delivery_Sales_Item__c';
		param6.Parameter_Type__c = 'Query Fields';
		param6.Active__c = true;
		quoteParameterList.add(param6);
		
		Quote_Parameter__c param7 = new Quote_Parameter__c();
		param7.Target_Field__c = 'RoundingAdjustment__c';
		param7.Target_Object__c = 'Quote_Staging__c';
		param7.Source_Field__c = 'Quantity__c';
		param7.Source_Object__c = 'Quote_Delivery_Sales_Item__c';
		param7.Parameter_Type__c = 'Mapping Rule';
		param7.Active__c = true;
		quoteParameterList.add(param7);
		
		Quote_Parameter__c param8 = new Quote_Parameter__c();
		param8.Target_Field__c = 'Bundle';
		param8.Target_Object__c = 'Quote_Staging__c';
		param8.Source_Field__c = 'NokiaCPQ_Configuration_Type__c';
		param8.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param8.Parameter_Type__c = 'Exclude';
		/*   param8.Parameter_Value1__c='Proposal__r.NokiaCPQ_Portfolio__c';
		param8.Parameter_Value2__c='IP ROUTING'; */
		param8.Active__c = true;
		quoteParameterList.add(param8);
		
		Quote_Parameter__c param9 = new Quote_Parameter__c();
		param9.Target_Field__c = 'QTEID__c';
		param9.Target_Object__c = 'Quote_Staging__c';
		param9.Source_Field__c = 'Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c';
		param9.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param9.Parameter_Type__c = 'Mapping Rule';
		param9.Active__c = true;
		quoteParameterList.add(param9);
		
		Quote_Parameter__c param10 = new Quote_Parameter__c();
		param10.Target_Field__c = 'ITEMTYPE__c';
		param10.Target_Object__c = 'Quote_Staging__c';
		param10.Source_Field__c = 'NokiaCPQ_Item_Type__c';
		param10.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param10.Parameter_Type__c = 'Mapping Rule';
		param10.Active__c = true;
		quoteParameterList.add(param10);
		
		Quote_Parameter__c param11 = new Quote_Parameter__c();
		param11.Target_Field__c = 'BASE__c';
		param11.Target_Object__c = 'Quote_Staging__c';
		param11.Source_Field__c = 'NokiaCPQ_ExtendedPrice_CNP__c,Apttus_QPConfig__Quantity2__c';
		param11.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param11.Parameter_Type__c = 'Mapping Rule';
		param11.Parameter_Value1__c='OPERATION';
		param11.Parameter_Value2__c= 'DIVIDE'; 
		param11.Active__c = true;
		quoteParameterList.add(param11);
		
		Quote_Parameter__c param12 = new Quote_Parameter__c();
		param12.Target_Field__c = ' Year 1 Maintenance,SSP,Maintenance for Y2 and Beyond';
		param12.Target_Object__c = 'Quote_Staging__c';
		param12.Source_Field__c = 'Apttus_QPConfig__ChargeType__c';
		param12.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param12.Parameter_Type__c = 'Exclude';
		param12.Active__c = true;
		quoteParameterList.add(param12);
		
		Quote_Parameter__c param13 = new Quote_Parameter__c();
		param13.Target_Field__c = '0.0';
		param13.Target_Object__c = 'Quote_Staging__c';
		param13.Source_Field__c = 'NokiaCPQ_Unitary_IRP__c';
		param13.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param13.Parameter_Type__c = 'Exclude';
		param13.Parameter_Value1__c='Apttus_Proposal__Proposal__r.NokiaCPQ_Portfolio__c';
		param13.Parameter_Value2__c='IP ROUTING'; 
		param13.Active__c = true;
		quoteParameterList.add(param13);
		
		Quote_Parameter__c param14 = new Quote_Parameter__c();
		param14.Target_Field__c = 'EXPIRATION__c';
		param14.Target_Object__c = 'Quote_Staging__c';
		param14.Source_Field__c = 'Apttus_Proposal__Proposal_Expiration_Date__c';
		param14.Source_Object__c = 'Apttus_Proposal__Proposal__c';
		param14.Parameter_Type__c = 'Mapping Rule';
		param14.Active__c = true;
		quoteParameterList.add(param14);
		
		
		Quote_Parameter__c param15 = new Quote_Parameter__c();
		param15.Target_Field__c = '';
		param15.Target_Object__c = 'Quote_Staging__c';
		param15.Source_Field__c = 'Apttus_Proposal__Product__c,Apttus_QPConfig__OptionId__c,Apttus_QPConfig__OptionId__r.Productcode,Apttus_Proposal__Product__r.ProductCode,Flexible_group_code__c,Apttus_QPConfig__Uom__c,CurrencyISOCode,NokiaCPQ_Item_Type__c';
		param15.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param15.Parameter_Type__c = 'Query Fields';
		param15.Active__c = true;
		quoteParameterList.add(param15); 
		
		Quote_Parameter__c param16 = new Quote_Parameter__c();
		param16.Target_Field__c = 'Quote_Number__c';
		param16.Target_Object__c = 'Quote_Staging__c';
		param16.Source_Field__c = 'Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c';
		param16.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param16.Parameter_Type__c = 'Mapping Rule';
		param16.Active__c = true;
		quoteParameterList.add(param16);
		
		
		Quote_Parameter__c param17 = new Quote_Parameter__c();
		param17.Target_Field__c = 'EXTENDED__c';
		param17.Target_Object__c = 'Quote_Staging__c';
		param17.Source_Field__c = 'NokiaCPQ_ExtendedPrice_CNP__c';
		param17.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param17.Parameter_Type__c = 'Mapping Rule';
		param17.Active__c = true;
		quoteParameterList.add(param17);
		
		Quote_Parameter__c param18 = new Quote_Parameter__c();
		param18.Target_Field__c = 'QUANTITY__c';
		param18.Target_Object__c = 'Quote_Staging__c';
		param18.Source_Field__c = 'Apttus_QPConfig__Quantity2__c';
		param18.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param18.Parameter_Type__c = 'Mapping Rule';
		param18.Active__c = true;
		quoteParameterList.add(param18);
		
		Quote_Parameter__c param19 = new Quote_Parameter__c();
		param19.Target_Field__c = 'BASE__c';
		param19.Target_Object__c = 'Quote_Staging__c';
		param19.Source_Field__c = 'NokiaCPQ_ExtendedPrice_CNP__c,Apttus_QPConfig__Quantity2__c';
		param19.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param19.Parameter_Type__c = 'Mapping Rule';
		param19.Parameter_Value1__c='OPERATION';
		param19.Parameter_Value2__c= 'MULTIPLY'; 
		param19.Active__c = true;
		quoteParameterList.add(param19);
		
		Quote_Parameter__c param20 = new Quote_Parameter__c();
		param20.Target_Field__c = 'DOCUMENTID__c';
		param20.Target_Object__c = 'Quote_Staging__c';
		param20.Source_Field__c = 'DOCUMENTID__c';
		param20.Source_Object__c = '';
		param20.Parameter_Type__c = 'Remove Character';
		param20.Parameter_Value1__c='//s+';
		param20.Active__c = true;
		quoteParameterList.add(param20);
		
		Quote_Parameter__c param21 = new Quote_Parameter__c();
		param21.Target_Field__c = 'DOCUMENTID__c';
		param21.Target_Object__c = 'Quote_Staging__c';
		param21.Source_Field__c = 'DOCUMENTID__c';
		param21.Source_Object__c = '';
		param21.Parameter_Type__c = 'Remove Character';
		param21.Parameter_Value1__c='.';
		param21.Active__c = true;
		quoteParameterList.add(param21);
		
		Maintenance_SSP_Product__c msp = new Maintenance_SSP_Product__c();
		msp.NokiaCPQ_Product_Type__c = 'SSP';
		msp.NokiaCPQ_Portfolio__c = 'IP ROUTING';
		msp.Product_Code__c = '3HE11428AA';
		msp.NokiaCPQ_Description__c = 'Annual Software Release Subscription';
		msp.NokiaCPQ_7705_SSP_Applicable__c = 'NAM';
		INSERT msp;
		
		Quote_Parameter__c param24 = new Quote_Parameter__c();
		param24.Target_Field__c = 'DOCUMENTID__c';
		param24.Target_Object__c = 'Quote_Staging__c';
		param24.Source_Field__c = 'Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c';
		param24.Source_Object__c = 'Apttus_Proposal__Proposal_Line_Item__c';
		param24.Parameter_Type__c = 'Mapping Rule';
		param24.Active__c = true;
		quoteParameterList.add(param24);
		
		Database.INSERT(quoteParameterList);
	}
	
	
	/***************************
	* Description : The method returns Collaboration URL.
	* Parameter passed : recordIdVar
	* return : String 
	***************************/
	Static testmethod void configureCollaboration_testMethod()
	{
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='301030872';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		INSERT accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		
		//create opportunity	
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'Alliance Partner';
		INSERT opportunities;  
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		INSERT accreditations;
		
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].Quote_Status__c='Order';
		INSERT proposals;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		prodConfigs[0].Apttus_Config2__Status__c = 'Finalized';
		INSERT prodConfigs;
		  test.startTest();
		//create a quote Line Item
		List<Apttus_Proposal__Proposal_Line_Item__c > proposalsLineItem1 = NOKIA_CPQ_TestDataFactory.createProposalLineItem(3);
		proposalsLineItem1[0].Apttus_Proposal__Proposal__c = proposals[0].id;
		proposalsLineItem1[0].Apttus_QPConfig__LineType__c = 'Option';
		proposalsLineItem1[0].NokiaCPQ_ExtendedPrice_CNP__c = 1234.50;
		proposalsLineItem1[0].Apttus_QPConfig__Quantity2__c = 1;
		System.debug('1st QLI'+proposalsLineItem1[0].Apttus_Proposal__Proposal__c);
		
		proposalsLineItem1[1].Apttus_Proposal__Proposal__c = proposals[0].id;
		proposalsLineItem1[1].Apttus_QPConfig__LineType__c = 'Option';
		proposalsLineItem1[1].Item_Type_From_CAT__c = 'Offer';
		proposalsLineItem1[1].Sequence_Site_Id__c= '';
		proposalsLineItem1[1].NokiaCPQ_ExtendedPrice_CNP__c = 220.0;
		proposalsLineItem1[1].Apttus_QPConfig__Quantity2__c = 2;
		System.debug('2nd QLI'+proposalsLineItem1[1].Apttus_Proposal__Proposal__c);
		
		proposalsLineItem1[2].Apttus_Proposal__Proposal__c = proposals[0].id;
		proposalsLineItem1[2].Apttus_QPConfig__LineType__c = 'Product/Service';
		proposalsLineItem1[2].Item_Type_From_CAT__c = 'Offer';
		proposalsLineItem1[2].Sequence_Site_Id__c= '';
		proposalsLineItem1[2].NokiaCPQ_ExtendedPrice_CNP__c = 100;
		proposalsLineItem1[2].Apttus_QPConfig__Quantity2__c = 3;
		INSERT proposalsLineItem1;

		//CREATE PRODUCT
		Product2 prod = new Product2();
		prod.Name = 'Test product 1';
		prod.NokiaCPQ_Item_Type__c = 'SERVICE';
		prod.ProductCode = 'TEST00123';
		INSERT prod;
		
		//INSERT priceList
		Apttus_Config2__PriceList__c pricelist = new Apttus_Config2__PriceList__c();
		pricelist.Apttus_Config2__Active__c = true;
		pricelist.CurrencyIsoCode = 'USD';
		pricelist.Name = 'Test Price List USD';
		
		INSERT pricelist;
		
		//INSERT priceListItem
		
		Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
		pli.Apttus_Config2__PriceListId__c = pricelist.id;
		pli.Apttus_Config2__ChargeType__c = 'Standard Price';
		
		INSERT pli;
		
		// INSERT Configuration Line Items	  
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Custom_Product_Name__c='tereer',
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
			Apttus_Config2__PriceListItemId__c = pli.id,
			NokiaCPQ_Alias__c ='test',
			Apttus_Config2__ParentBundleNumber__c = null,
			Apttus_Config2__LineSequence__c =1,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__BasePrice__c=4427,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PriceIncludedInBundle__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			is_Custom_Product__c =true,
			Custom_Product_Code__c=Nokia_CPQ_Constants.MAINTY2CODE,
			Apttus_Config2__AddedBy__c = 'added by code',
			Apttus_Config2__NetPrice__c=120,
			NokiaCPQ_SSP_Rate__c=120
		);
		
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Custom_Product_Name__c='tereer',
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price',
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
			Apttus_Config2__PriceListItemId__c = pli.id,
			NokiaCPQ_Alias__c ='test',
			Apttus_Config2__ParentBundleNumber__c = 1,
			Apttus_Config2__LineSequence__c =1,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__BasePrice__c=4427,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PriceIncludedInBundle__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 2,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			is_Custom_Product__c =true,
			Custom_Product_Code__c=Nokia_CPQ_Constants.MAINTY2CODE,
			Apttus_Config2__AddedBy__c = 'added by code',
			Apttus_Config2__NetPrice__c=120,
			NokiaCPQ_SSP_Rate__c=120
		);
		
		//create proposal line items		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(5);
		proposalLineItemList[0].NokiaCPQ_Spare__c = false;
		proposalLineItemList[0].Apttus_Proposal__Product__c = prod.Id;
		// proposalLineItemList[0].Apttus_QPConfig__OptionId__c = pricelist.Id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c = proposals[0].Id;
		System.debug('On trying to INSERT ' +proposalLineItemList[0].Apttus_Proposal__Proposal__c);
		
		proposalLineItemList[0].Apttus_QPConfig__ParentBundleNumber__c = Null;
		proposalLineItemList[0].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[0].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[0].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[0].is_Custom_Product__c = false;
		proposalLineItemList[0].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[0].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[0].Apttus_QPConfig__PrimaryLineNumber__c = 1;
		proposalLineItemList[0].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[0].Apttus_QPConfig__ConfigurationId__c = LineItem1.id;
		proposalLineItemList[0].NokiaCPQ_ExtendedPrice_CNP__c = 10000.50;
		proposalLineItemList[0].Apttus_QPConfig__Quantity2__c = 1;
		proposalLineItemList[0].NokiaCPQ_Parent_Bundle_Name__c = 'False';
		
		
		proposalLineItemList[1].NokiaCPQ_Spare__c = false;
		proposalLineItemList[1].Apttus_Proposal__Product__c = prod.Id;
		// proposalLineItemList[1].Apttus_QPConfig__OptionId__c = pricelist.Id;
		proposalLineItemList[1].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[1].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[1].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[1].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[1].is_Custom_Product__c = false;
		proposalLineItemList[1].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[1].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[1].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[1].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[1].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[1].Apttus_QPConfig__ConfigurationId__c = LineItem1.id;
		proposalLineItemList[1].NokiaCPQ_ExtendedPrice_CNP__c = 7898.50;
		proposalLineItemList[1].Apttus_QPConfig__Quantity2__c = 2;
		proposalLineItemList[1].NokiaCPQ_Parent_Bundle_Name__c = 'False';
		
		proposalLineItemList[2].NokiaCPQ_Spare__c = false;
		proposalLineItemList[2].Apttus_Proposal__Product__c = prod.Id;
		// proposalLineItemList[2].Apttus_QPConfig__OptionId__c = pricelist.Id;
		proposalLineItemList[2].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[2].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[2].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[2].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[2].is_Custom_Product__c = false;
		proposalLineItemList[2].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[2].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[2].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[2].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[2].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[2].Apttus_QPConfig__ConfigurationId__c = LineItem1.id; 
		proposalLineItemList[2].NokiaCPQ_ExtendedPrice_CNP__c = 10000.50;
		proposalLineItemList[2].Apttus_QPConfig__Quantity2__c = 3;
		proposalLineItemList[2].NokiaCPQ_Parent_Bundle_Name__c = 'False';
		
		proposalLineItemList[3].NokiaCPQ_Spare__c = false;
		proposalLineItemList[3].Apttus_Proposal__Product__c = prod.Id;
		//proposalLineItemList[3].Apttus_QPConfig__OptionId__c = pricelist.Id;
		proposalLineItemList[3].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[3].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[3].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[3].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[3].is_Custom_Product__c = false;
		proposalLineItemList[3].Apttus_QPConfig__LineType__c = 'Option';
		proposalLineItemList[3].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[3].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[3].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[3].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[3].Apttus_QPConfig__ConfigurationId__c = LineItem2.id; 
		proposalLineItemList[3].NokiaCPQ_ExtendedPrice_CNP__c = 999.03;
		proposalLineItemList[3].Apttus_QPConfig__Quantity2__c = 3;
		proposalLineItemList[3].NokiaCPQ_Parent_Bundle_Name__c = 'False';
		
		proposalLineItemList[4].Apttus_Proposal__Proposal__c = proposals[0].Id;
		proposalLineItemList[4].Apttus_Proposal__Product__c = prod.Id;
		//proposalLineItemList[4].Apttus_QPConfig__OptionId__c = pricelist.Id;
		proposalLineItemList[4].Apttus_QPConfig__ParentBundleNumber__c = 1;
		proposalLineItemList[4].NokiaCPQ_Configuration_Type__c = 'Standalone';
		proposalLineItemList[4].Custom_Product_Code__c = 'AirScaleWiFi';
		proposalLineItemList[4].is_Custom_Product__c = false;
		proposalLineItemList[4].Apttus_QPConfig__LineType__c = 'Product Service';
		proposalLineItemList[4].Apttus_QPConfig__ChargeType__c = 'Standard price';
		proposalLineItemList[4].Apttus_QPConfig__LineNumber__c = 1;
		proposalLineItemList[4].Apttus_QPConfig__PrimaryLineNumber__c = 2;
		proposalLineItemList[4].Apttus_Proposal__Description__c = 'Installation Services';
		proposalLineItemList[4].CPQ_Market_Model__c = 'TestFlexiGroup.QTY(3)';
		proposalLineItemList[4].Flexible_group_code__c = 'Solution001';
		proposalLineItemList[4].Apttus_QPConfig__ConfigurationId__c = LineItem1.id; 
		proposalLineItemList[4].NokiaCPQ_ExtendedPrice_CNP__c = 11000.50;
		proposalLineItemList[4].Apttus_QPConfig__Quantity2__c = 4;
		proposalLineItemList[4].NokiaCPQ_Parent_Bundle_Name__c = 'False';
		INSERT proposalLineItemList;
		
		
		// INSERT Quote Delivery Sales Item 
		Quote_Delivery_Sales_Item__c listQDSIs=new Quote_Delivery_Sales_Item__c();
		listQDSIs.Arcadia_Product_Code__c= 'ARC00010AA';
		listQDSIs.Item_Type__c= 'Order';
		listQDSIs.Parent_Line_Item__c= LineItem1.Id;
		listQDSIs.PCI_Code__c= 'SPS-ALU-PR-SW-PCI';
		listQDSIs.Product_Code__c= '3HZ16085AAAA';
		listQDSIs.Quantity__c= 200;
		listQDSIs.Proposal__c=  proposals[0].id;
		listQDSIs.Sequence_Site_Id__c= 'SPS-ALU-PR-SW-PCI';
		listQDSIs.Alias_for_Exports__c= 'SPS-ALU-PR-SW-PCI';
		listQDSIs.CMN__c= 'SPS-ALU-PR-SW-PCI';	  
		INSERT listQDSIs;
		
		//Create Quote staging Record:
		List<Quote_Staging__c> quote_staging_Rec = new List<Quote_Staging__c>();
		
		Quote_Staging__c qtstg = new Quote_Staging__c();
		qtstg.Request_Data__c= 'abcdef123';
		qtstg.QTEID__c='1912345';
		qtstg.Quote_Number__c = '19.US.876785 Q 1';
		qtstg.PARTNRID__c = '1234567';
		quote_staging_Rec.add(qtstg);
		Database.INSERT(quote_staging_Rec);
		
		
		Set<Id> quoteIds = new Set<Id>();
		quoteIds.add('a3k56000000QecvAAC');
		
		Map<String,String> taskValuesMap = new Map<String,String>();   
		taskValuesMap.put('a3k56000000QecvAAC','UPD');
		
		
	  
		NokiaCPQquoteActionsController.sendAddQuoteMessageToEAI(proposals[0].id, '');
		Database.BatchableContext BC;
		QTC_QuoteProposalToStaging qtc = new QTC_QuoteProposalToStaging(quoteIds,taskValuesMap);
		qtc.execute(BC, proposalsLineItem1);
		qtc.checkForValidCondition('Request_Data__c', '123',null);
		qtc.checkForValidCondition(null, '123',null);
		qtc.checkForValidCondition(null,null,null);
		qtc.checkForValidCondition('Quote_Staging__r.Request_Data__c',null,null);
		test.stopTest();	 
	}
}