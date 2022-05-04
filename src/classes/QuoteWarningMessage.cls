/**
 * @description	   :
 * @author			: Yashdeep Prajapati
 * @group			 :
 * @last modified on  : 02-02-2022
 * @last modified by  : Yashdeep Prajapati
 **/
public with sharing class QuoteWarningMessage {
//This class will handle the logic for warning message on Quote/Proposal Object

/******************************
 * Method Name: getquoteId
 * Description: Test Method will get Quote/Proposal id for displaying the error message
 * Parameters: Id recordId
 ********************************/

//public String needPricingMessage{get;set;}
public static string INDIRECT_CPQ = Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ;
@AuraEnabled public String ToastMessage {get; set;}
@AuraEnabled public String Message {get; set;}
@AuraEnabled
public static QuoteWarningMessage callInit(Id recordId){
	String quoteWarningMsg = GlobalConstants.BLANK_VALUE;
	Datetime dateTimeNow = System.now();
	Long timeNow = dateTimeNow.getTime();
	Long timeCreated;
	Long timeDifference;
	QuoteWarningMessage obj = new QuoteWarningMessage();
	Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c();
	try{
		String objectName = recordId.getSObjectType().getDescribe().getName();
		if(objectName.equalsIgnoreCase('Apttus_Proposal__Proposal__c')) {
			quote = [SELECT id,Quote_Type__c, NokiaCPQ_Needs_Reprice__c,Apttus_Proposal__Approval_Stage__c,CreatedDate FROM Apttus_Proposal__Proposal__c where Id=:recordId LIMIT 1];
			if(quote!=null)
			{
	if(quote.Quote_Type__c == INDIRECT_CPQ) {
		timeCreated = quote.CreatedDate.getTime();
		timeDifference = timeNow - timeCreated;
		if(quote.Apttus_Proposal__Approval_Stage__c =='Draft' && timeDifference <=60000)
		{
			obj.ToastMessage = system.label.NOKIA_CPQ_QuoteWarning;
		}
		else
		{
			obj.ToastMessage = GlobalConstants.BLANK_VALUE;
		}
	}
	//added by Surinder-JIRA ITPC:1884
	//alert users to reprice cart if Neep Reprice flag is set true

	set<string> invalidStages = new set<string> {Nokia_CPQ_Constants.QUOTEAPPROVED,Nokia_CPQ_Constants.ACCEPTED_STRING,Nokia_CPQ_Constants.EXPIRED_STRING,
										  Nokia_CPQ_Constants.Closed_Not_Won};


	// if (quote.Apttus_Proposal__Approval_Stage__c == 'In Review' && quote.Quote_Type__c == INDIRECT_CPQ ){
	//	 obj.Message= System.Label.InReview_Reprice_Message;//message to be added
	// }
	if(quote.NokiaCPQ_Needs_Reprice__c && ((quote.Quote_Type__c == INDIRECT_CPQ && !invalidStages.contains(quote.Apttus_Proposal__Approval_Stage__c )) || quote.Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ)) {

		obj.Message= (quote.Apttus_Proposal__Approval_Stage__c == 'In Review' && quote.Quote_Type__c == INDIRECT_CPQ ) ? System.Label.InReview_Reprice_Message : System.Label.repriceNeedCustomMessage;
	}

			}
		}

		return obj;
	}
	catch(Exception e)
	{
		ExceptionHandler.addException(e,QuoteWarningMessage.class.getName(),'callInit');
		System.debug('Exception found'+e);
		return obj;
	}
}
}