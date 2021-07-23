@isTest
public class DS_MatchCD2QuoteTest {
	private static final String PRODUCT_2 = 'Ext-P1234';
	private static final String PRODUCT_1 = 'Ext-P1233';
	private static final String NOKIA_LEGAL_ENTITY = 'Nokia-Hungary';
	private static final String DEFAULT_PO_NUMBER = '55555555';
	private static final Date DEFAULT_PO_DATE = Date.newInstance(2020, 01, 01);
	private static final String DEFAULT_INCOTERMS = 'DDP (Delivered Duty Paid)';
	private static final String DEFAULT_CURRENCY = 'EUR';
	private static final String DEFAULT_SOLD_TO_PARTY = '100006843';

  private static final String SITECODE_1 = '950130';
	private static final String SITECODE_2 = '1234567890';
  private static final String SITE_1 = SITECODE_1 + ' MONTIGNY LES CORMEILLES 2';
	private static final String SITE_2 = SITECODE_2 + ' another sitename';

  @testSetup static void createCDWithQuotes() {
	Apttus_Config2__PaymentTerm__c p60 = new Apttus_Config2__PaymentTerm__c(Name='P60', Apttus_Config2__Sequence__c=1);
	Apttus_Config2__PaymentTerm__c p30 = new Apttus_Config2__PaymentTerm__c(Name='P30', Apttus_Config2__Sequence__c=2);
	Database.insert(new List<Apttus_Config2__PaymentTerm__c>{p60, p30});

	Customer_Document__c cd = new Customer_Document__c(Total_Value__c = 4000.00, Customer_Document_Date__c=DEFAULT_PO_DATE,
	Customer_Document_ID__c=DEFAULT_PO_NUMBER, INCO_Terms__c=DEFAULT_INCOTERMS, Payment_terms__c = p60.Id, CurrencyIsoCode=DEFAULT_CURRENCY, Nokia_Legal_entity__c=NOKIA_LEGAL_ENTITY);
	insert cd;

	List<Customer_Document_Line_Items__c> cdlis = new List<Customer_Document_Line_Items__c>();
	for(String site:new List<String> {SITE_1, SITE_2}) {
	  for(String p:new List<String> {'P1233', 'P1234'}) {
		Customer_Document_Line_Items__c cdli = new Customer_Document_Line_Items__c(
		  CurrencyIsoCode = DEFAULT_CURRENCY,
		  Customer_Document__c=cd.id,
		  Quantity__c = '10',
		  High_level_Product_Description__c='Description of ' + p,
		  High_level_Product__c =	'Ext-' + p,
		  Net_Value__c=100,
		  Site__c=site,
		  Total_Value__c=1000
		  );
		cdlis.add(cdli);
	  }
	}
	insert cdlis;
	Test.startTest();
	setupQuotesTo(cd,p60);
	Test.stopTest();
	System.debug('--->setup cd.id: ' + cd.Id);
  }

  @IsTest
  static void testCDMatchesQuoteGrandTotalValueMatched(){
	//given
	Customer_Document__c cd = readCD();

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_OK, readCD().Matches_Quotes__c, response);
	System.assert(response.contains(DS_MatchCD2Quote.MATCHING_RESPONSE_OK_MATCHING), response);
  }

  @IsTest
  static void testCDMatchesQuoteGrandTotalValueDifferent(){
	//given
	Customer_Document__c cd = readCD();
	cd.Total_Value__c = 4100;
	update cd;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c);
	System.assert(response.contains('Grand Total value is different: customer document grand total=4,100 quote grand total=4,000'), response);
  }

  @IsTest
  static void testMissingProductFromQuote(){
	//given
	Customer_Document__c cd = readCD();
	for(Customer_Document_Line_Items__c li : cd.Customer_Document_Line_Items__r) {
	  li.High_level_Product__c = 'one-product';
	}
	update cd.Customer_Document_Line_Items__r;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Product code one-product is not available in any associated quote for site 950130: {Ext-P1233, Ext-P1234} are the products found in the quotes.'), response);
  }

  @IsTest
  static void testMissingProductFromCD(){
	//given
	Customer_Document__c cd = readCD();
	List<Customer_Document_Line_Items__c> cdlis = new List<Customer_Document_Line_Items__c>();
	for(Customer_Document_Line_Items__c li : cd.Customer_Document_Line_Items__r) {
	  if(li.High_level_Product__c.equals(PRODUCT_1) && li.Site__c.equals(SITE_2)) {
		cdlis.add(li);
	  }
	}
	delete cdlis;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(!response.contains('Missing product code {Ext-P1233} listed in quote but not available in customer document for site:' + SITECODE_1), response);
	System.assert(response.contains('Missing product code {Ext-P1233} listed in quote but not available in customer document for site:' + SITECODE_2), response);
  }

  @IsTest
  static void testDifferentQuantities(){
	//given
	String q1 = '123456789';
	String q2 = '987654321';
	Customer_Document__c cd = readCD();
	for(Customer_Document_Line_Items__c li : cd.Customer_Document_Line_Items__r) {
	  li.Quantity__c=li.Site__c.equals(SITE_2)?q2:q1;
	}
	update cd.Customer_Document_Line_Items__r;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains(String.format('Quantity of product code Ext-P1233 ({0}) at site {1} does not equal to sum of quantity of quotes: 10', new List<Object>{q1, SITECODE_1})), response);
	System.assert(response.contains(String.format('Quantity of product code Ext-P1234 ({0}) at site {1} does not equal to sum of quantity of quotes: 10', new List<Object>{q2, SITECODE_2})), response);
  }

  @IsTest
  static void testDifferentNetValue(){
	//given
	Decimal p1 = 123.4;
	Decimal p2 = 321.5;
	Customer_Document__c cd = readCD();
	for(Customer_Document_Line_Items__c li : cd.Customer_Document_Line_Items__r) {
	  if(li.Site__c.equals(SITE_2)) {
		li.Net_Value__c=li.High_level_Product__c.equals(PRODUCT_2)?p2:p1;
	  }
	}
	update cd.Customer_Document_Line_Items__r;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains(String.format('Net unit price of product code Ext-P1233 ({0}) at site {1} does not equal to net value of quote: 100', new List<Object>{p1,SITECODE_2})), response);
	System.assert(response.contains(String.format('Net unit price of product code Ext-P1234 ({0}) at site {1} does not equal to net value of quote: 100', new List<Object>{p2,SITECODE_2})), response);
  }

  @IsTest
  static void testDifferentTotalValue(){
	//given
	Decimal p1 = 123.4;
	Decimal p2 = 321.5;
	Customer_Document__c cd = readCD();
	for(Customer_Document_Line_Items__c li : cd.Customer_Document_Line_Items__r) {
	  if(li.Site__c.equals(SITE_2)) {
		li.Total_Value__c=li.High_level_Product__c.equals('Ext-P1234')?(p2*10):(p1*10);
	  }
	}
	update cd.Customer_Document_Line_Items__r;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains(String.format('Total value of product code Ext-P1233 (1,234) at site {0} does not equal to sum of total value of quotes: 1,000', new List<Object>{SITECODE_2})), response);
	System.assert(response.contains(String.format('Total value of product code Ext-P1234 (3,215) at site {0} does not equal to sum of total value of quotes: 1,000', new List<Object>{SITECODE_2})), response);
  }

  @IsTest
  static void testTotalValueNotEqualsToNetValueMultipliedByQuantity(){
	//given
	Customer_Document__c cd = readCD();
	for(Customer_Document_Line_Items__c li : cd.Customer_Document_Line_Items__r) {
	  if(li.Site__c.equals(SITE_2) && li.High_level_Product__c.equals('Ext-P1234')) {
		li.Total_Value__c=-1;
	  }
	}
	update cd.Customer_Document_Line_Items__r;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Inconsistency at line item: Ext-P1234 @ ' + SITECODE_2 + ': Total Value (-1) does not equal to net value (100) * quantity (10) in CD line item:'), response);
  }

  @IsTest
  static void testSoldToPartyDifferent(){
	//given
	String soldToParty = '100009999';
	Customer_Document__c cd = readCD();
	cd.Customer__c = createLegalEntity(soldToParty).Id;
	update cd;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Sold To Party is different: customer document customer account number=' + soldToParty + ' and quote Sold To Party account number=' + DEFAULT_SOLD_TO_PARTY), response);

  }

  @IsTest
  static void testCurrencyDifferent(){
	//given
	Customer_Document__c cd = readCD();
	cd.CurrencyIsoCode = 'USD';
	update cd;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Currency is different: customer document currency=USD and quote currency=EUR'), response);
  }

  @IsTest
  static void testIncoTermsDifferent(){
	//given
	Customer_Document__c cd = readCD();
	cd.INCO_Terms__c = 'FOB (Free on Board)';
	update cd;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Incoterms is different: customer document Incoterms=FOB (Free on Board) and quote Incoterms=DDP (Delivered Duty Paid)'), response);
  }

  @IsTest
  static void testPaymentTermDifferent(){
	//given
	Customer_Document__c cd = readCD();
	cd.Payment_terms__c = [SELECT Id FROM Apttus_Config2__PaymentTerm__c WHERE Name = 'P30' Limit 1].get(0).Id;
	update cd;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Payment Term is different: customer document Payment Term=P30 and quote Payment Term=P60'), response);
  }

  @IsTest
  static void testNoAssociatedQuote(){
	//given
	Customer_Document__c cd = readCD();
	delete [SELECT id FROM Customer_Document_Junction__c];

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_NO_QUOTE, readCD().Matches_Quotes__c, response);
	System.assert(response.contains(DS_MatchCD2Quote.MATCHING_RESPONSE_NO_QUOTE), response);
  }

  @IsTest
  static void testSumOfItemLevelTotalNotEqualToHeaderLevelTotalInCustomerDocument(){
	//given
	Customer_Document__c cd = readCD();
	List<Customer_Document_Line_Items__c> cdlis = [SELECT CurrencyIsoCode, Customer_Document__c, Quantity__c, High_level_Product__c, Net_Value__c,
	Site__c, Total_Value__c FROM Customer_Document_Line_Items__c WHERE High_level_Product__c = 'Ext-P1233'];
	for(Customer_Document_Line_Items__c cdli : cdlis) {
	  // duplicate Ext-P1233 product line items
	  cdli.id=null;
	}
	insert cdlis;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Sum of Total values (6,000) in Customer Document line items does not equal to Total in Customer Document header (4,000).'), response);
  }

  // no site at quote
  @IsTest
  static void testErrorWhenNoSiteInfoAtQuote(){
	//given
	Customer_Document__c cd = readCD();
	delete [SELECT id FROM Customer_facing_Attribute__c];

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assert(readCD().Matches_Quotes__c.contains(DS_MatchCD2Quote.MATCHING_RESPONSE_NO_SITE_AVAILABLE), readCD().Matches_Quotes__c + ' response: ' + response);
	System.assert(response.contains(DS_MatchCD2Quote.MATCHING_RESPONSE_NO_SITE_AVAILABLE), response);
  }

  @IsTest
  static void testNokiaLegalEntityDifferent(){
	//given
	String anotherEntity = 'Another Nokia Legal Entity';
	Customer_Document__c cd = readCD();
	cd.Nokia_Legal_entity__c = anotherEntity;
	update cd;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Nokia Legal Entity is different: customer document Nokia Legal Entity=' + anotherEntity + ' and quote Nokia Legal Entity=' + NOKIA_LEGAL_ENTITY), response);
  }

  @IsTest
  static void testPONumberDifferent(){
	//given
	String anotherPONumber = '44444444';
	Customer_Document__c cd = readCD();
	cd.Customer_Document_ID__c = anotherPONumber;
	update cd;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('PO Number is different: customer document PO Number=' + anotherPONumber + ' and quote PO Number=' + DEFAULT_PO_NUMBER), response);
  }

  @IsTest
  static void testPODateDifferent(){
	//given
	Date anotherPODate =  date.newInstance(2020, 05, 01);
	Customer_Document__c cd = readCD();
	cd.Customer_Document_Date__c = anotherPODate;
	update cd;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('PO Date is different: customer document PO Date=' + anotherPODate.format() + ' and quote PO Date=' + DEFAULT_PO_DATE.format()), response);
  }

  @IsTest
  static void testMissingSiteCodeFromCD(){
	//given
	Customer_Document__c cd = readCD();
	for(Customer_Document_Line_Items__c li : cd.Customer_Document_Line_Items__r) {
	  if(li.High_level_Product__c.equals(PRODUCT_1) && li.Site__c.equals(SITE_2)) {
		li.Site__c=null;
	  }
	}
	update cd.Customer_Document_Line_Items__r;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Site code is missing, please correct the line item in customer document'), response);
  }


  @IsTest
  static void testMissingProductCodeFromCD(){
	//given
	Customer_Document__c cd = readCD();
	for(Customer_Document_Line_Items__c li : cd.Customer_Document_Line_Items__r) {
	  if(li.High_level_Product__c.equals(PRODUCT_1) && li.Site__c.equals(SITE_2)) {
		li.High_level_Product__c=null;
	  }
	}
	update cd.Customer_Document_Line_Items__r;

	//when
	Test.startTest();
	String response = DS_MatchCD2Quote.validate(cd.Id);
	Test.stopTest();

	//then
	System.assertEquals(DS_MatchCD2Quote.MATCHING_RESPONSE_ERROR_CHECK_DETAILS, readCD().Matches_Quotes__c, response);
	System.assert(response.contains('Product code is missing, please correct the line item in customer document'), response);

  }

  private static Customer_Document__c readCD() {
	List<Customer_Document__c> mcd = new List<Customer_Document__c>([
	  SELECT Classification__c, Comment__c, CreatedById, CreatedDate, CurrencyIsoCode, Customer_Contact_commercial__c, Customer_Contact_delivery__c, Customer_Document_Date__c, Customer_Document_ID__c, Customer_Invoicing_Address__c, Customer__c, Id, INCO_Terms__c, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Matches_Quotes__c, Name, Nokia_Document_Receipt_Date__c, Nokia_Legal_entity__c, OwnerId, Payment_terms__c, RecordTypeId, Requested_Delivery_Date__c, Status__c, Sub_Classification__c, SystemModstamp, Total_Value__c,
	  (SELECT CreatedById, CreatedDate, CurrencyIsoCode, Customer_Document__c, Detailed_Product_Description__c, Detailed_Product__c, High_level_Product_Description__c, High_level_Product__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, Matches_Quote__c, Missing_Fields__c, Name, Net_Value__c, Place_of_Delivery__c, Quantity__c, Site__c, SystemModstamp, Total_Value__c FROM Customer_Document_Line_Items__r)
	  FROM Customer_Document__c]);
	  System.debug('--->mcd: ' + mcd);
	  return mcd.get(0);
  }

  private static Account createLegalEntity(String accountNumber) {
	Account legalEntity = TestDataFactory.createAccount(1)[0];
	legalEntity.AccountNumber = accountNumber;
	legalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	Database.insert(legalEntity);
	return legalEntity;
  }

  private static Product2 createProduct(String productCode) {
	Product2 product = new Product2(
	  Name = productCode + 'Test1',
	  ProductCode = productCode,
	  Business_Group__c = 'NSW',
	  CurrencyIsoCode = 'EUR',
	  IsActive = true
	);
	return product;
  }

  private static Opportunity createOpportunity(Account account) {
	Opportunity opportunity = TestDataFactory.OpportunityCreation(1, account)[0];
	opportunity.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
	opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
	opportunity.Lead_BG__c = 'MN';
	opportunity.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;

	Database.insert(opportunity);
	return opportunity;
  }

  private static Apttus_Proposal__Proposal__c createQuote(Apttus__APTS_Agreement__c agreement, Opportunity oppty, Account legalEntity, Account account, Apttus_Config2__PaymentTerm__c paymentTerm) {
	Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
	quoteProposal.Apttus_Proposal__Opportunity__c = oppty.id;
	quoteProposal.Contract_Type_Name__c = 'Project';
	quoteProposal.Sold_To_Party__c = legalEntity.id;
	quoteProposal.Apttus_Proposal__Account__c = account.Id;
	quoteProposal.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	quoteProposal.Apttus_Proposal__Approval_Stage__c = 'Approved';
	quoteProposal.LOA_Status__c = 'Approved';
	quoteProposal.Apttus_QPConfig__PaymentTermId__c = paymentTerm.Id;
	quoteProposal.CurrencyIsoCode = DEFAULT_CURRENCY;
	quoteProposal.Agreement_Lookup__c = agreement.Id;
	quoteProposal.Apttus_QPConfig__PONumber__c = DEFAULT_PO_NUMBER;
	quoteProposal.Apttus_QPConfig__PODate__c = DEFAULT_PO_DATE;

	return quoteProposal;
  }

  private static List<Customer_facing_Attribute__c> createSiteCFAs(Apttus_Proposal__Proposal__c quoteProposal, String siteCode) {
	List<Customer_facing_Attribute__c> cfas = new List<Customer_facing_Attribute__c>();
	cfas.add(new Customer_facing_Attribute__c(Attribute_Name__c = 'Site code',  Attribute_Label__c = 'G2R site', Attribute_Value__c = siteCode,
	Attribute_indicator__c = CSWXGlobalConstant.header_indicator, Quote__c = quoteProposal.ID, Account__c = quoteProposal.Apttus_Proposal__Account__c));
	cfas.add(new Customer_facing_Attribute__c(Attribute_Name__c = 'Dummy Attribute',  Attribute_Label__c = 'Dummy Attribute', Attribute_Value__c = 'Dummy Value',
	Attribute_indicator__c = CSWXGlobalConstant.header_indicator, Quote__c = quoteProposal.ID, Account__c = quoteProposal.Apttus_Proposal__Account__c));
	return cfas;
  }

  private static Apttus_Config2__ProductConfiguration__c createCart(Account account, Apttus_Config2__PriceList__c priceList, Apttus_Proposal__Proposal__c quote) {
	Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c(
	  Name = 'APTTUS Test Config',
	  Apttus_Config2__AccountId__c = account.Id,
	  Apttus_Config2__PriceListId__c = priceList.Id,
	  Apttus_QPConfig__Proposald__c = quote.Id,
	  Apttus_Config2__Status__c = 'New',
	  Apttus_Config2__VersionNumber__c = 1,
	  Apttus_Config2__EffectivePriceListId__c = priceList.Id,
	  Apttus_Config2__BusinessObjectId__c = String.valueOf(quote.Id),
	  Apttus_Config2__BusinessObjectType__c = 'Proposal');
	return cart;
  }

  private static Apttus_Config2__PriceList__c createPriceList() {
	Apttus_Config2__PriceList__c priceList = TestdataFactory.priceList(1)[0];
	Database.insert(priceList);
	return priceList;
  }

  private static Apttus_Config2__PriceListItem__c createPriceListItem(Apttus_Config2__PriceList__c priceList, Product2 product, Decimal price) {
	Apttus_Config2__PriceListItem__c priceListItem = TestdataFactory.createPriceListItem(1, priceList)[0];
	priceListItem.Apttus_Config2__ProductId__c = product.id;
	priceListItem.Apttus_Config2__ListPrice__c = price;
	priceListItem.Apttus_Config2__ContractItemNumber__c = 'Ext-' + product.ProductCode;

	return priceListItem;
  }

  private static void putProductsIntoCart(Apttus_Config2__ProductConfiguration__c cart, Map<Product2, Apttus_Config2__PriceListItem__c> productsPrices) {
	Apttus_CPQApi.CPQ.AddMultiProductRequestDO standAloneProDs = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	standAloneProDs.cartID = cart.Id;

	List<String> customFields = new List<String> { CSWXGlobalConstant.priceListItem, 'Apttus_Config2__LineNumber__c'};
	List<String> customFieldsStandalone = new List<String> {CSWXGlobalConstant.priceListItem, CSWXGlobalConstant.quantityField, 'Apttus_Config2__LineNumber__c'};

	standAloneProDs.SelectedProducts = new List<Apttus_CPQApi.CPQ.SelectedProductDO>();

	for(Product2 p : productsPrices.keySet()) {
	  Apttus_CPQApi.CPQ.SelectedProductDO standaloneProduct  = new Apttus_CPQApi.CPQ.SelectedProductDO();
	  Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
	  customData.Apttus_Config2__PriceListItemId__c = productsPrices.get(p).Id;
	  customData.Apttus_Config2__LineNumber__c = 1;
	  customData.Apttus_Config2__Quantity__c =10;
	  standaloneProduct.CustomData = customData;
	  standaloneProduct.ProductId = p.Id;
	  standaloneProduct.CustomFields = customFieldsStandalone;
	  standAloneProDs.SelectedProducts.add(standaloneProduct);
	}
	Apttus_CPQApi.CPQWebService.addMultiProducts(StandAloneProDs);
  }

  private static void updatePrices(Apttus_Config2__ProductConfiguration__c cart){
	boolean  isPricePending = false;
	do {
	  Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
	  objUpdatePriceRequestDO.CartId = cart.Id;
	  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	  isPricePending = result.IsPricePending;
	} while(isPricePending);
  }

  private static void finalizeCart(Apttus_Config2__ProductConfiguration__c cart) {
	updatePrices(cart);

	Apttus_CpqApi.CPQ.FinalizeCartRequestDO cartFinalRequest = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
	cartFinalRequest.CartId = cart.Id;
	Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(cartFinalRequest);
	System.debug('Cart finalization result: ' + response);
  }

  private static Customer_Document_Junction__c assign(Apttus_Proposal__Proposal__c quote, Customer_Document__c cd) {
	Customer_Document_Junction__c cdQuoteJunction = new Customer_Document_Junction__c();
	cdQuoteJunction.Customer_Document__c = cd.Id;
	cdQuoteJunction.Quote_Proposal__c = quote.id;
	return cdQuoteJunction;
  }

	private static void setupQuotesTo(Customer_Document__c cd, Apttus_Config2__PaymentTerm__c paymentTerm){
	Apttus_Config2__PriceList__c priceList = createPriceList();

	List<Account> accounts = TestDataFactory.createAccount(2);
	Account account = accounts[0];
	Account legalEntity = accounts[1];
	legalEntity.AccountNumber = DEFAULT_SOLD_TO_PARTY;
	legalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	Database.insert(accounts);

	cd.Customer__c = legalEntity.id;
	update cd;

	Apttus__APTS_Agreement__c agreement=createAgreement(account, priceList);

	Map<Product2, Apttus_Config2__PriceListItem__c> productsPrices = setupProductsAndPrices(priceList);

	Opportunity opportunity = createOpportunity(account);
	Apttus_Proposal__Proposal__c quote = createQuote(agreement, opportunity, legalEntity, account, paymentTerm);
	Apttus_Proposal__Proposal__c quote2 = createQuote(agreement, opportunity, legalEntity, account, paymentTerm);
	insert new List<Apttus_Proposal__Proposal__c> {quote, quote2};

	List<Customer_facing_Attribute__c> cfas = new List<Customer_facing_Attribute__c>();
	cfas.addAll(createSiteCFAs(quote, SITECODE_1));
	cfas.addAll(createSiteCFAs(quote2, SITECODE_2));
	insert cfas;

	Apttus_Config2__ProductConfiguration__c cart = createCart(account, priceList, quote);
	Apttus_Config2__ProductConfiguration__c cart2 = createCart(account, priceList, quote2);
	insert new List<Apttus_Config2__ProductConfiguration__c> {cart, cart2};

	putProductsIntoCart(cart, productsPrices);
	finalizeCart(cart);
	putProductsIntoCart(cart2, productsPrices);
	finalizeCart(cart2);

	Database.insert(new List<Customer_Document_Junction__c> {assign(quote, cd), assign(quote2, cd)});
  }

  private static Apttus__APTS_Agreement__c createAgreement(Account account, Apttus_Config2__PriceList__c priceList) {
	Apttus__APTS_Agreement__c agreement= new Apttus__APTS_Agreement__c();
	agreement.Apttus__Agreement_Number__c='00000033';
	agreement.Name= 'Test Agreement';
	agreement.Apttus__Account__c = account.id;
	agreement.CurrencyIsoCode = 'EUR';
	agreement.Delivery_System__c = 'Scratch Order via P20';
	agreement.ERP__c = 'P20';
	agreement.Sales_Mode__c = 'Corporate Sales Mode';
	agreement.Confidence_Level__c = 'Low Level';
	agreement.Apttus__Contract_Start_Date__c=System.today();
	agreement.Apttus__Contract_End_Date__c=System.today()+30;
	agreement.Apttus_CMConfig__PriceListId__c = priceList.id;
	agreement.Inco_Term_Description__c = DEFAULT_INCOTERMS;
	agreement.Nokia_Legal_Entity__c = NOKIA_LEGAL_ENTITY;
	Database.insert(agreement);
	return agreement;
  }

  private static Map<Product2, Apttus_Config2__PriceListItem__c> setupProductsAndPrices(Apttus_Config2__PriceList__c priceList) {
	Product2 product = createProduct('P1233');
	Product2 product2 = createProduct('P1234');
	List<Product2> products = new List<Product2> {product, product2};
	Database.insert(products);

	List<Apttus_Config2__PriceListItem__c> prices = new List<Apttus_Config2__PriceListItem__c> {createPriceListItem(priceList, product, 100), createPriceListItem(priceList, product2, 100)};
	Database.insert(prices);

	return new Map<Product2, Apttus_Config2__PriceListItem__c>{
	  products.get(0) => prices.get(0),
	  products.get(1) => prices.get(1)
	};
  }

}