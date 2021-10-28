/*******************************
Class Name: CQ_QuoteTeamTriggerHelper
Created By: Accenture - May 2019
Last Modified By: Accenture
Last Modified Date: 15-05-2019
Description: Helper Class for CQ_QuoteTeamTriggerHelper for Contracted Quote Record Type
*******************************/
public class CQ_QuoteTeamTriggerHelper {
	
	/*Method Name: QuoteTeamMemberAssigned
*Description: This method is used to fetch the quote team members for the newly created QuoteTeam and send email to them.
*Parameters:  Quote Team List
*Created By: Accenture - May 2019
*Last Modified By: Accenture
*Last Modified Date: 15-05-2019
*******************************/	
	public static void QuoteTeamMemberAssigned(list<CQ_Quote_Team__c> QuoteTeam_list){
		map<id,list<string>> Team_map = new map<id,list<string>>();
		Map<Id,Set<Id>> QTeam_Idlist=new Map<Id,Set<Id>>();
		integer limitRows = Limits.getLimitQueryRows()- Limits.getQueryRows();
		Messaging.SingleEmailMessage[] Email_List= new Messaging.SingleEmailMessage[] {};
			try{
				if(!GlobalConstants.CQ_SEND_EMAIL_TO_QUOTETEAM){
					for(CQ_Quote_Team__c CQ_team:QuoteTeam_list){
						if(!QTeam_Idlist.containskey(CQ_team.CQ_CQ_Name__c))
							QTeam_Idlist.put(CQ_team.CQ_CQ_Name__c,new Set<Id>{CQ_team.CQ_Quote_Team_Member__c});
						else
							QTeam_Idlist.get(CQ_team.CQ_CQ_Name__c).add(CQ_team.CQ_Quote_Team_Member__c);					
					}
					
					system.debug('Team_map'+QTeam_Idlist);
					system.debug('Teamsize'+QTeam_Idlist.size());
					List<EmailTemplate> template_list=[Select Id from EmailTemplate Where DeveloperName=:Label.CQ_QuoteTeamMemberAssignment_EmailTemplate LIMIT:limitRows];
					String template_id=template_list[0].Id;
					if(!QTeam_Idlist.isEmpty()){
						for(Id q_Teamid:QTeam_Idlist.keyset()){  
							system.debug('q_Teamid'+q_Teamid);
							map<string,string> output = EmailNotifications.ExtractHTMLbody(template_id,q_Teamid);
							system.debug('template_id-->'+template_id);
							Messaging.SingleEmailMessage[] Email= EmailNotifications.sendmailwithtrgtobj(output.get(GlobalConstants.body),output.get(GlobalConstants.subject),QTeam_Idlist.get(q_Teamid)); 
							//Messaging.SingleEmailMessage Email= EmailNotifications.sendmail(output.get(GlobalConstants.body),output.get(GlobalConstants.subject),Team_map.get(q_Teamid)); 
							Email_List.addall(Email);
						}
						GlobalConstants.CQ_SEND_EMAIL_TO_QUOTETEAM=True;
					}
					system.debug('Email_List'+Email_List);
					if(!Email_List.isEmpty())
						Messaging.sendEmail(Email_List,false);
				}
			}catch(Exception ex){
				ExceptionHandler.addException(ex,GlobalConstants.CQ_QuoteTeamTriggerHelper,GlobalConstants.QuoteTeamMemberAssigned);
			}
	}
}