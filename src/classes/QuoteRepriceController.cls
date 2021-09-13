//Bibhu:Created Controller for Common Reprice button

public with sharing class QuoteRepriceController 
{
	public Apttus_Proposal__Proposal__c quoteObj {get;set;}
	   
	public QuoteRepriceController(ApexPages.StandardController stdController)
	{
		this.quoteObj = (Apttus_Proposal__Proposal__c)stdController.getRecord();
	}
	public pagereference QuoteReprice()
	{
	   quoteObj  = [Select Id,Is_Classic_Pricing__c,Is_Turbo_Pricing__c from Apttus_Proposal__Proposal__c where Id=:quoteObj.Id];
	   PageReference QuoteRedirect;
	   if(quoteObj.Is_Classic_Pricing__c ==true)
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
	   }
	  return QuoteRedirect;
	//}
	}

}