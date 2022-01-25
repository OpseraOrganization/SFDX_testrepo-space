/*******************************
Class Name: EmailAlertQueueable
Created by: HCL
Created Date: 7th Jan 2021
Description: This class will send email alerts to the Quote team members
*******************************/
public class EmailAlertQueueable implements Queueable{
	List<Sales_Order_reporting__c> salesorderlist = new List<Sales_Order_reporting__c>();
	
	public EmailAlertQueueable(List<Sales_Order_reporting__c> salesorderRecords){
		salesorderlist = salesorderRecords;
	}
	
	public void execute(QueueableContext context) {
		set<id> cqid = new set<id>();
		List<Messaging.SingleEmailMessage> email_list = new List<Messaging.SingleEmailMessage>() ;
		List<String> QT_emailList = new List<String>();
		set<string> QTemailset = new set<string>();
		set<Id> QTuserset = new set<Id>();
		system.debug('Queries used enterning email alert: '+ limits.getQueries());
		map<id,set<Id>> CQteam_map = new map<id,set<Id>>();
		EmailTemplate[] Templatelist = [SELECT DeveloperName,Id,Foldername FROM EmailTemplate WHERE DeveloperName = :GlobalConstants.Email_temp_SO_Created ];
		Id Templateid = Templatelist[0].id;
		for(Sales_Order_reporting__c so_cq : salesorderlist){
			
			if(so_cq.Contracted_Quote__c <> null){
				cqid.add(so_cq.Contracted_Quote__c);
			}
		}
		system.debug('Queries used after so_cq: '+ limits.getQueries());
		System.debug('CQid:'+cqid);
		if(cqid.size() > 0){
			for(Apttus_Proposal__Proposal__c quoteteam : [select id,(select id,CQ_Quote_Team_Member__c, member_email__C from Quote_Team__r) from Apttus_Proposal__Proposal__c where id in :cqid]){
				
				system.debug('Queries used : '+ limits.getQueries());
				system.debug('quoteteam' + quoteteam);
				
				
				for(CQ_Quote_Team__c QT : quoteteam.Quote_Team__r){
					QTemailset.add(QT.member_email__C );
					QTuserset.add(QT.CQ_Quote_Team_Member__c);
				}
				QT_emailList.addall(QTemailset);
				CQteam_map.put(quoteteam.id, QTuserset);
			}
			system.debug('Queries used after quoteteam: '+ limits.getQueries());
			system.debug('CQteam_map:'+ CQteam_map);
			for(Sales_Order_reporting__c so : salesorderlist){
				
				
				if(CQteam_map.get(so.Contracted_Quote__c) <> null){
					system.debug('so.id'+so.id);
					system.debug('Queries used before extract html : '+ limits.getQueries());
					map<string,string> output = EmailNotifications.ExtractHTMLbody(Templateid,so.id);
					system.debug('Queries used before sendmail : '+ limits.getQueries());
					// Messaging.SingleEmailMessage email_rec = EmailNotifications.sendmail(output.get(Globalconstants.body),output.get(Globalconstants.subject),CQteam_map.get(so.Contracted_Quote__c));
					Messaging.SingleEmailMessage[] email_rec = EmailNotifications.sendmailwithtrgtobj(output.get(Globalconstants.body),output.get(Globalconstants.subject),CQteam_map.get(so.Contracted_Quote__c));
					email_list.addall(email_rec);
				}
				system.debug('Queries used in email for loop : '+ limits.getQueries());
			}
			system.debug('Queries used after email triggering : '+ limits.getQueries());
			If(!email_list.IsEmpty()){
				Messaging.sendEmail(email_list);
			}
		}	 
	}
}