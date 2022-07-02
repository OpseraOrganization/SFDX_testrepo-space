public with sharing class DS_MatchCD2Quote {

  public static final String MATCHING_RESPONSE_OK = 'OK';
  public static final String MATCHING_RESPONSE_OK_MATCHING = 'OK, Everything is matching.';
  public static final String MATCHING_RESPONSE_NO_SITE_AVAILABLE = 'There is no Site code at quote header.';
  public static final String MATCHING_RESPONSE_NO_QUOTE = 'No associated quote. Please associate relevant quotes asap.';
  public static final String MATCHING_RESPONSE_ERROR_CHECK_DETAILS = 'Not OK, please check details.';

  public class NoSiteAtQuoteException extends Exception {
  public String quoteId;
  public String quoteName;

  public NoSiteAtQuoteException(String quoteId, String quoteName){
	  this.quoteId = quoteId;
	  this.quoteName = quoteName;
	}
  }

  @AuraEnabled
  public static String validate(Id cdId) {

	String result=MATCHING_RESPONSE_ERROR_CHECK_DETAILS;
	List<DS_MatchWarning> errorMsgs = new List<DS_MatchWarning>();

	Map<ID, Customer_Document__c> mcd = readCustomerDocument(cdId);
	Customer_Document__c cd=mcd.get(cdId);
	Map<ID, Apttus_Proposal__Proposal__c> quotes = readQuote(cdId);
	try {
	  if(!quotes.isEmpty()) {
		errorMsgs.addAll(compareHeaderFields(cd, quotes));
		errorMsgs.addAll(compareGrandTotal(cd, quotes));
		errorMsgs.addAll(compareLineItems(cd, groupQuoteLinesByProductAndSite(quotes)));
		errorMsgs.addAll(compareSumOfLineItemGrandTotals(cd));

		if(errorMsgs.isEmpty()) {
		  result=MATCHING_RESPONSE_OK;
		  errorMsgs.add(new DS_MatchWarning('','',MATCHING_RESPONSE_OK_MATCHING));
		}
	  } else {
		result = MATCHING_RESPONSE_NO_QUOTE;
		errorMsgs.add(new DS_MatchWarning(cd.id, cd.Name, result));
	  }
	} catch (NoSiteAtQuoteException e) {
	  result=MATCHING_RESPONSE_NO_SITE_AVAILABLE;
	  errorMsgs.add(new DS_MatchWarning(e.quoteId, e.quoteName, result));
	}
	errorMsgs.addAll(updateResult(cd, result));
	return System.JSON.serialize(errorMsgs);
  }

  private static List<DS_MatchWarning> updateResult(Customer_Document__c cd, String result) {
	List<DS_MatchWarning> errorMsgs = new List<DS_MatchWarning>();
	try {
	  cd.Matches_Quotes__c = result;
	  Database.upsert(cd);
	} catch (Exception e) {
	  errorMsgs.add(new DS_MatchWarning(cd.Id, cd.Name, 'Cannot execute upsert on Customer Document: ' + e.getMessage()));
	}
	return errorMsgs;
  }

  private static List<DS_MatchWarning> compareLineItems(Customer_Document__c cd, Map<String, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> siteProductQuoteItems) {
	List<DS_MatchWarning> errorMsgs = new List<DS_MatchWarning>();

	Map<String, Set<String>> cdProducts = new Map<String, Set<String>>();
	for (Customer_Document_Line_Items__c cdli : cd.Customer_Document_Line_Items__r) {
	  if(cdli.High_level_Product__c == null) {
		errorMsgs.add(new DS_MatchWarning(cdli.id,cdli.name, 'Product code is missing, please correct the line item in customer document'));
		continue;
	  }
	  if(cdli.Site__c == null) {
		errorMsgs.add(new DS_MatchWarning(cdli.id,cdli.name, 'Site code is missing, please correct the line item in customer document'));
		continue;
	  }
	  String productCode=cdli.High_level_Product__c;
	  String site=cdli.Site__c.substringBefore(' ');
	  registerProductForSite(cdProducts, site, productCode);

	  if (siteProductQuoteItems.containsKey(site)) {
		errorMsgs.addAll(compareLineItem(site, cdli, siteProductQuoteItems.get(site)));
	  } else {
		errorMsgs.add(new DS_MatchWarning(cdli.id, cdli.Name, 'Missing site code: ' + site + ' is not available in any associated quote: ' + siteProductQuoteItems.keySet()));
	  }
	}

	errorMsgs.addAll(checkMissingProductInCD(cdProducts, siteProductQuoteItems));
	return errorMsgs;
  }

	private static List<DS_MatchWarning> compareLineItem(String site, Customer_Document_Line_Items__c cdli, Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> productQuoteItems){
	List<DS_MatchWarning> errorMsgs = new List<DS_MatchWarning>();
	String productCode=cdli.High_level_Product__c;
	Set<String> quoteNames = new Set<String>();

	If(cdli.Net_Value__c * Decimal.valueOf(cdli.Quantity__c) != cdli.Total_Value__c) {
	  errorMsgs.add(new DS_MatchWarning(cdli.Id, cdli.Name, String.format('Inconsistency at line item: {0} @ {1}: Total Value ({2}) does not equal to net value ({3}) * quantity ({4}) in CD line item: {5}', new List<Object>{productCode, site, format(cdli.Total_Value__c), format(cdli.Net_Value__c), cdli.Quantity__c, cdli.Name})));
	}

	if (productQuoteItems.containsKey(productCode)) {
	  Decimal quantity = 0;
	  Decimal total = 0;
	  for (Apttus_Proposal__Proposal_Line_Item__c qli : productQuoteItems.get(productCode)) {
		quantity += qli.NokiaCPQ_Quantity__c;
		total += qli.Apttus_QPConfig__NetPrice__c;
		quoteNames.add(qli.Apttus_Proposal__Proposal__r.Name);
		if(qli.Apttus_QPConfig__NetUnitPrice__c != cdli.Net_Value__c) {
		  errorMsgs.add(new DS_MatchWarning(qli.Id, qli.Name, String.format('Net unit price of product code {0} ({1}) at site {2} does not equal to net value of quote: {3} CD line item: {4}', new List<Object>{productCode, format(cdli.Net_Value__c), site, format(qli.Apttus_QPConfig__NetUnitPrice__c), cdli.Name})));
		}
	  }
	  if(!String.valueOf(quantity).equals(cdli.Quantity__c)) {
		errorMsgs.add(new DS_MatchWarning(cdli.Id, cdli.Name, String.format('Quantity of product code {0} ({1}) at site {2} does not equal to sum of quantity of quotes: {3}, covered quotes: {4}', new List<Object>{productCode, cdli.Quantity__c, site, quantity, quoteNames})));
	  }
	  if(total!=cdli.Total_Value__c) {
		errorMsgs.add(new DS_MatchWarning(cdli.Id, cdli.Name, String.format('Total value of product code {0} ({1}) at site {2} does not equal to sum of total value of quotes: {3}, covered quotes: {4}', new List<Object>{ productCode, format(cdli.Total_Value__c), site, format(total), quoteNames})));
	  }
	} else {
	  errorMsgs.add(new DS_MatchWarning(cdli.Id, cdli.Name, String.format('Product code {0} is not available in any associated quote for site {1}: {2} are the products found in the quotes.', new List<Object>{productCode, site, productQuoteItems.keySet()})));
	}
	return errorMsgs;
  }

	private static void registerProductForSite(Map<String,Set<String>> cdProducts, String site, String productCode){
	if(!cdProducts.containsKey(site)) {
	  cdProducts.put(site,new Set<String>());
	}
	cdProducts.get(site).add(productCode);
  }

  private static List<DS_MatchWarning> checkMissingProductInCD(Map<String,Set<String>> cdProducts, Map<String,Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>> siteProductQuoteItems){
	List<DS_MatchWarning> errorMsgs = new List<DS_MatchWarning>();
	for(String site: cdProducts.keySet()) {
	  Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> quoteItems=siteProductQuoteItems.get(site);
	  if(quoteItems==null) {
		quoteItems=new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
	  }
	  if(cdProducts.get(site)== null || !cdProducts.get(site).containsAll(quoteItems.keySet())) {
		Set<String> missingProducts=quoteItems.keySet().clone();
		missingProducts.removeAll(cdProducts.get(site));
		errorMsgs.add(new DS_MatchWarning('', '', 'Missing product code ' + missingProducts + ' listed in quote but not available in customer document for site:' + site));
	  }
	}
	return errorMsgs;
	}

  private static Map<Id, String> readQuoteSites(Set<Id> quoteIdSet) {
	Map<Id, String> quoteSites = new Map<Id, String>();

	List<Customer_facing_Attribute__c> cfas = [SELECT Attribute_Value__c, Quote__c FROM Customer_facing_Attribute__c
	  WHERE Attribute_Label__c = 'G2R site' AND Attribute_indicator__c = :CSWXGlobalConstant.header_indicator AND Quote__c IN :quoteIdSet];
	for( Customer_facing_Attribute__c cfa: cfas) {
	  quoteSites.put(cfa.Quote__c, cfa.Attribute_Value__c);
	}
	return quoteSites;
  }

  private static Map<String, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> groupQuoteLinesByProductAndSite(Map<ID, Apttus_Proposal__Proposal__c> mquote) {
	Map<String, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> quoteItemsByProductPerSite = new Map<String, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>>();

	Map<Id, String> quoteSites=readQuoteSites(mquote.keySet());

	for (Apttus_Proposal__Proposal__c quote : mquote.values()) {
	  System.debug(quote);
	  String site = quoteSites.get(quote.Id);
	  if(site == null) {
		throw new NoSiteAtQuoteException(quote.Id, quote.Name);
	  }
	  for (Apttus_Proposal__Proposal_Line_Item__c qli : quote.Apttus_Proposal__R00N70000001yUfBEAU__r) {
		String productCode = qli.External_Reference__c;
		appendto(lookupLineItemsByProduct(site, quoteItemsByProductPerSite), productCode, qli);
	  }
	}
	return quoteItemsByProductPerSite;
  }

  private static Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>> lookupLineItemsByProduct(String site, Map<String, Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>> quoteItemsByProductPerSite) {
	Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>> quoteItemsByProduct = quoteItemsByProductPerSite.get(site);
	if(quoteItemsByProduct == null) {
	  quoteItemsByProductPerSite.put(site, new Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>>());
	  quoteItemsByProduct = quoteItemsByProductPerSite.get(site);
	}
	return quoteItemsByProduct;
  }

  private static void appendTo(Map<String, List<Apttus_Proposal__Proposal_Line_Item__c>> quoteItemsByProduct, String productCode, Apttus_Proposal__Proposal_Line_Item__c qli) {
	if(quoteItemsByProduct.get(productCode) == null) {
	  quoteItemsByProduct.put(productCode, new List<Apttus_Proposal__Proposal_Line_Item__c>());
	}
	quoteItemsByProduct.get(productCode).add(qli);
  }

  private static List<DS_MatchWarning> compareGrandTotal(Customer_Document__c cd, Map<Id, Apttus_Proposal__Proposal__c> mquote) {
	List<DS_MatchWarning> errorMsgs = new List<DS_MatchWarning>();

	Decimal totalInCd = cd.Total_Value__c;
	Decimal totalInQuote = 0;
	for (Apttus_Proposal__Proposal__c quote : mquote.values()) {
	  System.debug(quote);
	  totalInQuote += quote.Quote_Total__c;
	}
	if (totalInCd != totalInQuote) {
	  errorMsgs.add(new DS_MatchWarning( cd.Id, cd.Name, 'Grand Total value is different: customer document grand total=' + format(totalInCd) + ' quote grand total=' + format(totalInQuote)));
	}

	return errorMsgs;
  }

  private static List<DS_MatchWarning> compareSumOfLineItemGrandTotals(Customer_Document__c cd) {
	List<DS_MatchWarning> errorMsgs = new List<DS_MatchWarning>();

	Decimal totalInCd = cd.Total_Value__c;
	Decimal totalInLI = 0;
	for (Customer_Document_Line_Items__c cdli : cd.Customer_Document_Line_Items__r) {
	  System.debug(cdli);
	  totalInLI += cdli.Total_Value__c;
	}
	if (totalInCd != totalInLI) {
	  errorMsgs.add(new DS_MatchWarning(cd.Id, cd.Name, 'Sum of Total values (' + format(totalInLI) + ') in Customer Document line items does not equal to Total in Customer Document header (' + format(totalInCd) + ').'));
	}

	return errorMsgs;
  }

  private static List<DS_MatchWarning> compareHeaderFields(Customer_Document__c cd, Map<Id, Apttus_Proposal__Proposal__c> mquote) {
	List<DS_MatchWarning> errorMsgs = new List<DS_MatchWarning>();

	for (Apttus_Proposal__Proposal__c quote : mquote.values()) {
	  System.debug(quote);
	  if (cd.Customer__c != quote.Sold_To_Party__c) {
		errorMsgs.add(new DS_MatchWarning( quote.Id, quote.Name, 'Sold To Party is different: customer document customer account number=' + cd.Customer__r.AccountNumber + ' and quote Sold To Party account number=' + quote.Sold_To_Party__r.AccountNumber));
	  }
	  if (cd.CurrencyIsoCode != quote.CurrencyIsoCode) {
		errorMsgs.add(new DS_MatchWarning( quote.Id, quote.Name, 'Currency is different: customer document currency=' + cd.CurrencyIsoCode + ' and quote currency=' + quote.CurrencyIsoCode));
	  }
	  if (cd.INCO_Terms__c != quote.Incoterms__c) {
		errorMsgs.add(new DS_MatchWarning( quote.Id, quote.Name, 'Incoterms is different: customer document Incoterms=' + cd.INCO_Terms__c + ' and quote Incoterms=' + quote.Incoterms__c));
	  }
	  if (cd.Payment_terms__c != quote.Apttus_QPConfig__PaymentTermId__c) {
		errorMsgs.add(new DS_MatchWarning( quote.Id, quote.Name, 'Payment Term is different: customer document Payment Term=' + cd.Payment_terms__r.Name + ' and quote Payment Term=' + quote.Apttus_QPConfig__PaymentTermId__r.Name));
	  }
	  if (cd.Nokia_Legal_entity__c != quote.Agreement_Lookup__r.Nokia_Legal_Entity__c) {
		errorMsgs.add(new DS_MatchWarning( quote.Id, quote.Name, 'Nokia Legal Entity is different: customer document Nokia Legal Entity=' + cd.Nokia_Legal_entity__c + ' and quote Nokia Legal Entity=' + quote.Agreement_Lookup__r.Nokia_Legal_Entity__c));
	  }
	  if (cd.Customer_Document_ID__c != quote.Apttus_QPConfig__PONumber__c) {
		errorMsgs.add(new DS_MatchWarning( quote.Id, quote.Name, 'PO Number is different: customer document PO Number=' + cd.Customer_Document_ID__c + ' and quote PO Number=' + quote.Apttus_QPConfig__PONumber__c));
	  }
	  if (cd.Customer_Document_Date__c != quote.Apttus_QPConfig__PODate__c) {
		errorMsgs.add(new DS_MatchWarning( quote.Id, quote.Name, 'PO Date is different: customer document PO Date=' + dateFormat(cd.Customer_Document_Date__c) + ' and quote PO Date=' + dateFormat(quote.Apttus_QPConfig__PODate__c)));
	  }
	}
	return errorMsgs;
  }

  private static Map<ID, Customer_Document__c> readCustomerDocument(String cdId) {
	System.debug('cdId: ' + cdId);

	Map<ID, Customer_Document__c> mcd = new Map<ID, Customer_Document__c>([
				SELECT Customer_Document_Date__c, Customer_Document_ID__c, CurrencyIsoCode, Customer__c, Customer__r.AccountNumber, Id, INCO_Terms__c, Matches_Quotes__c, Name, Nokia_Legal_entity__c, Payment_terms__c, Payment_terms__r.Name, Total_Value__c,
				(SELECT High_level_Product__c, Id, Name, Net_Value__c, Quantity__c, Site__c, Total_Value__c FROM Customer_Document_Line_Items__r)
				FROM Customer_Document__c
				WHERE id = :cdId]);

	System.debug(mcd.keyset());
	System.debug(mcd);
	return mcd;
  }

  private static Map<ID, Apttus_Proposal__Proposal__c> readQuote(String cdId) {
	Map<ID, Apttus_Proposal__Proposal__c> mquote = new Map<ID, Apttus_Proposal__Proposal__c>([
	  SELECT Apttus_QPConfig__PODate__c, Apttus_QPConfig__PONumber__c, Agreement_Lookup__r.Nokia_Legal_Entity__c, Name, Apttus_QPConfig__PaymentTermId__c, Apttus_QPConfig__PaymentTermId__r.Name, CurrencyIsoCode, Id, Incoterms__c, Quote_Total__c, Sold_to_party_name__c, Sold_To_Party__c, Sold_To_Party__r.AccountNumber,
	  (SELECT Apttus_Proposal__Proposal__r.Name, Name, Apttus_QPConfig__NetPrice__c, Apttus_QPConfig__NetUnitPrice__c, NokiaCPQ_Quantity__c, External_Reference__c FROM Apttus_Proposal__R00N70000001yUfBEAU__r WHERE Apttus_QPConfig__LineType__c <> :CSWXGlobalConstant.Option )
	  FROM Apttus_Proposal__Proposal__c
	  WHERE id in (SELECT Quote_Proposal__c FROM Customer_Document_Junction__c WHERE Customer_Document__c = :cdId)]);

	System.debug(mquote.keyset());
	System.debug(mquote);
	return mquote;
  }

  private static String format(Decimal num) {
	if(num != null) {
	  List<String> args = new String[]{'0','number','###,###,##0.00'};
	  return String.format(num.format(), args);
	} else {
	  return null;
	}
  }

  private static String dateFormat(Date pdate) {
	return pdate!=null?pdate.format():null;
  }
}