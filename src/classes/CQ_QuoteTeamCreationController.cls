/********************************
Class Name: CQ_QuoteTeamCreationController
Created by: Accenture
Created Date: 28 May 2019
Last modified by: Accenture
Last modified date:  
Description: CQ Quote Team creation Controller
*******************************/
public class CQ_QuoteTeamCreationController {
	
	/*******************************
Method Name: saveQuoteTeam
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static void saveQuoteTeam(string userList, string quoteId){
		try{
			List<quoteTeamWrapper> wrapperList = (List<quoteTeamWrapper>) JSON.deserialize(userList, List<quoteTeamWrapper>.class);
			//System.debug('UserList::> '+wrapperList);
			List<CQ_Quote_Team__c> newUserList = new List<CQ_Quote_Team__c>();
			
			for(quoteTeamWrapper obj : wrapperList ){
				if(obj.Quoteteam.Id <> NULL)
				{
					CQ_Quote_Team__c qt = new CQ_Quote_Team__c();
					qt.CQ_Quote_Team_Member__c = obj.Quoteteam.Id;
					qt.CQ_CQ_Name__c = quoteId;
					newUserList.add(qt);
				}
			}
			//System.debug('newUserList::> '+newUserList);
			List<Database.SaveResult> savedResults = Database.insert(newUserList, false);
			for(Database.SaveResult sr : savedResults){
				if (!sr.isSuccess()) {
					for(Database.Error err: sr.getErrors()) {
						String msg = err.getMessage();
						System.debug('Error while inserting quote team::> '+msg);
					}
				}
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_CLONEQUOTETEAM);
		}
	}
	/*******************************
Method Name: quoteTeamWrapper
Description:  
Parameters:
*******************************/
	public class quoteTeamWrapper{
		@AuraEnabled public User Quoteteam {get;set;}
		@AuraEnabled public String usersearch {get;set;}
	}
}