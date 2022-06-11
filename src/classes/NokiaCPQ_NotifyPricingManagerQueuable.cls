/**************************************************************
 *@Description: This class used by PriceListTrigger. 
 **To notifty all price managers via email when a Price List's Send Email is updated from XAE.
 *@param: Set<Id> - price List Ids
 *@History Log:
--------------------------------------------------------------------------------------------------   
	Author					Date			  Description
---------------------------------------------------------------------------------------------
   Siva Kumar			   Feb-05-2021		 Req No: 6699
March-03-2021 Req: ITCCPQ-811
*****************************************************************/
public class NokiaCPQ_NotifyPricingManagerQueuable implements Queueable {
	
	private set<id> priceIdsSet;
	
	public NokiaCPQ_NotifyPricingManagerQueuable(set<id> priceIdsSet){ 
		this.priceIdsSet = priceIdsSet;
	}
	
	public void execute(System.QueueableContext qc) {
		if(priceIdsSet != null){ 
			map<id,List<OppWrapper>> teamMemeberMap = new map<id,List<OppWrapper>>();
			list<string> oppStages = System.Label.OppStageForPriceListUpdation.split(',');
			string priceListname;
			//query Opportunity Team Members for given Price Lists
			for(opportunityTeamMember team : [SELECT Id,OpportunityId,Opportunity.Name,opportunity.Contract_Price_List__r.Name,UserId from opportunityTeamMember where 
											  Opportunity.Contract_Price_List__r.PriceList_Type__c =: Nokia_CPQ_Constants.PARTNER_PRICELISTTYPE
											  AND Opportunity.stagename IN: oppStages											
											  AND TeamMemberRole =: Nokia_CPQ_Constants.PRICING_MANAGER_ROLE AND User.isActive = TRUE 
											  AND Opportunity.Contract_Price_List__c IN: priceIdsSet]){
			//ITCCPQ-811_START
			/***assumption is one Price List can be udpated from XAE at a time***/
			priceListname = string.valueof(team.opportunity.Contract_Price_List__r.Name);
			//ITCCPQ-811_END
												  
												  OppWrapper oppWrap = new OppWrapper();
												  oppWrap.Id = team.OpportunityId;
												  oppWrap.Name = team.Opportunity.Name;
												  
												  //map of user to list of opportunities he's associated with
												  if(!teamMemeberMap.containsKey(team.UserId))
													  teamMemeberMap.put(team.UserId,new List<OppWrapper>{oppWrap});
												   else
													  teamMemeberMap.get(team.UserId).add(oppWrap);
												  
											  }  
			
			//get HTML body to be sent 
			if(teamMemeberMap != null && !teamMemeberMap.isEmpty()){
				   
				   map<id,String> emailmap = new map<id,String>();
				   
				   for(Id usrId : teamMemeberMap.keyset()){
					   String bodyStr;
					   
					   bodyStr = 'Project pricelist '+priceListname+' has been updated to the opportunity below...<br/><br/> Opportunity Details: <br/>';
					   bodyStr += '<table border="1"><tr><th>Opportunity Name</th></tr>';
					   for(OppWrapper opWrap : teamMemeberMap.get(usrId)){
						   bodyStr += '<tr><td>  <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opWrap.id+'">'+opWrap.Name+'</a> </td></tr>';
					   }
					   bodyStr += '</table>';
					   if(!string.isBlank(bodyStr))
						   emailmap.put(usrId,bodyStr);
				   }

				   if(emailmap != null && !emailmap.isEmpty()){ 
					   List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
					   for(Id usrId : emailmap.keyset()){
						   Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
						   message.setSubject('Project Price List has been updated');
						   message.toAddresses = new String[] { usrId };
						   message.htmlbody = emailmap.get(usrId);
						   messages.add(message);
					   } 

					   if(messages != null && !messages.isEmpty())
						   Messaging.sendEmail(messages);
				   }
			   }
		}
	}
	
	
	public class OppWrapper{
		public id Id;
		public String Name;
	}
}