public class SearchProductWrapper {


	@AuraEnabled
	public String  strProductCode { get; set;}
	
	@AuraEnabled
	public String strProductName { get; set; }
	
	@AuraEnabled
	public Integer iLineNumber { get; set; }	
	
	@AuraEnabled
	public Integer iItemSequence { get; set; }
	
	@AuraEnabled
	public Integer iPrimaryLineNumber { get; set; }
	
	@AuraEnabled
	public string strPricingAccred  { get; set; }
	
	@AuraEnabled
	public decimal strAccredDiscount  { get; set; }
	
	@AuraEnabled
	public decimal dSRSPercentage  { get; set; }
	
	@AuraEnabled
	public string strGlobalPriceListID  { get; set; }
	
	@AuraEnabled
	public string strGlobalPriceListItemID  { get; set; }
	
	 @AuraEnabled
	public ID strProductID  { get; set; }
	
	 @AuraEnabled
	public String strPortfolio { get; set; }
	
	 @AuraEnabled
	public decimal iIncotermPercentage { get; set; }
	
	@AuraEnabled
	public String strPdc { get; set; }
	
	
	@AuraEnabled
	public String str1Year { get; set; }
	
	@AuraEnabled
	public Boolean isLEO { get; set; }
 

}