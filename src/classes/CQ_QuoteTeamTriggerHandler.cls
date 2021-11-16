/*Description: Handler Class for CQ_QuoteTeamTrigger for Contracted Quote Record Type
*******************************/
public class CQ_QuoteTeamTriggerHandler {
	/*****************************
/*Method Name: AfterInsert
*Description: This method is used to send email for quote team members
*Parameters:  Quote Team List
*Created By: Accenture - May 2019
*Last Modified By: Accenture
*Last Modified Date: 15-05-2019
*******************************/   
	public static void AfterInsert(List<CQ_Quote_Team__c> newQuoteTeam_list){
		
		CQ_QuoteTeamTriggerHelper.QuoteTeamMemberAssigned(newQuoteTeam_list);
	}
	  

}