/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 10-18-2021
 * @last modified by  : Yashdeep Prajapati
 **/
//Bibhu:Created Controller for Common Reprice button

public with sharing class QuoteRepriceController
{
public Apttus_Proposal__Proposal__c quoteObj {get; set;}

public QuoteRepriceController(ApexPages.StandardController stdController)
{
	this.quoteObj = (Apttus_Proposal__Proposal__c)stdController.getRecord();

}
public pagereference QuoteReprice()
{
	
	quoteObj  = [Select Id,Is_Classic_Pricing__c,Is_Turbo_Pricing__c,Turbo_Pricing_Enable__c,Quote_Type__c,NokiaCPQ_Portfolio__c,CPQ_SubPortfolio__c,
					Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where Id=:quoteObj.Id];
	
   
	Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing  utilCls = new Nokia_CPQ_Utility.Nokia_CPQ_UtilityNoSharing();
	Boolean hasQuoteAccredSolns  = utilCls.checkQuoteAccredSoln(quoteObj);
	
	if(hasQuoteAccredSolns){
		update quoteObj;
	}
	
	PageReference QuoteRedirect;

	/*  if(quoteObj.Is_Classic_Pricing__c ==true)
	   {
	   QuoteRedirect = new pagereference('/apex/Reprice_Quote');
	   QuoteRedirect.getParameters().put('quoteId',quoteObj.Id);
	   QuoteRedirect.setRedirect(true);
	   //return QuoteRedirect ;
	   }
	   else if(quoteObj.Is_Turbo_Pricing__c ==true)
	   {
	   QuoteRedirect = new pagereference('/apex/Reprice_Quote_TP');
	   QuoteRedirect.getParameters().put('quoteId',quoteObj.Id);
	   QuoteRedirect.setRedirect(true);
	   //return QuoteRedirect ;
	   }  */
	if(quoteObj.Is_Turbo_Pricing__c ==true || quoteObj.Quote_Type__c == 'Direct CPQ') {
		QuoteRedirect = new pagereference('/apex/Reprice_Quote_TP');
		QuoteRedirect.getParameters().put('quoteId',quoteObj.Id);
		QuoteRedirect.setRedirect(true);
	}
	else {
		QuoteRedirect = new pagereference('/apex/Reprice_Quote');
		QuoteRedirect.getParameters().put('quoteId',quoteObj.Id);
		QuoteRedirect.setRedirect(true);
	}

	return QuoteRedirect;
	//}
}



}