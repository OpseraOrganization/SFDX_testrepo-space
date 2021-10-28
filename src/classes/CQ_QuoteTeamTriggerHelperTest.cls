@isTest
public class CQ_QuoteTeamTriggerHelperTest {
	@isTest
	public static void CreateQuoteTeam(){
		
		list<CQ_Quote_Team__c> Quote_teamlist = new list<CQ_Quote_Team__c>();
		
		Id UserId=userinfo.getUserId();
		String UserEmail=[Select Id,Name,Email from User where Id=:UserId].Email;
		system.debug('UserEmail'+UserEmail);
		
		CQ_Quote_Team__c qteam = new CQ_Quote_Team__c();
		qteam.CQ_Quote_Team_Member__c=UserId;
		Quote_teamlist.add(qteam);
		
		database.insert(Quote_teamlist);
	 
		test.startTest();		
		CQ_QuoteTeamTriggerHelper.QuoteTeamMemberAssigned(Quote_teamlist);
		test.stopTest();
		
		
	}   
}