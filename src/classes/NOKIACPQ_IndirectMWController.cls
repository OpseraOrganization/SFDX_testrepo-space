public  with Sharing class NOKIACPQ_IndirectMWController {	

	public Id quoteId {get;set;}
	public String QuoteApprovalDetails = '';
	public NOKIACPQ_IndirectMWController(){
  }

	
	public String getQuoteAppvlDtls(){
	Apttus_Proposal__Proposal__c QuoteProposal = [Select id,Apttus_Proposal__Approval_Stage__c,NokiaCPQ_Portfolio__c,Apttus_Proposal__Opportunity__c,Apttus_Proposal__Opportunity__r.StageName,Apttus_Proposal__Opportunity__r.LOA_Level__c,Apttus_Proposal__Opportunity__r.Authorized_for_Pricing_manager__c,
					Apttus_Proposal__Opportunity__r.No_Loa__c,Apttus_Proposal__Opportunity__r.Pre_approved_Price_List_for_AM__c,NokiaCPQ_Total_Quote_Discount__c,SRS__c,SSP__c,Maintenance_Y2__c,Maintenance_Y1__c
						from Apttus_Proposal__Proposal__c where id =:quoteId and NokiaCPQ_Portfolio__c = :Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO];
	
	If(QuoteProposal != null)
	{
		List<Apttus_Proposal__Proposal_Line_Item__c > Lineitemlist= [Select id,is_Custom_Product__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =:quoteId and is_Custom_Product__c = true limit 1];  

		if(quoteProposal.Apttus_Proposal__Opportunity__r.StageName == GlobalConstants.WIN_THE_CASE_NEGOTIATE && QuoteProposal.Apttus_Proposal__Approval_Stage__c == Nokia_CPQ_Constants.ApprovalRequired && QuoteProposal.Apttus_Proposal__Opportunity__r.Pre_approved_Price_List_for_AM__c == 0 && QuoteProposal.Apttus_Proposal__Opportunity__r.Authorized_for_Pricing_manager__c == 0)			
		{
		 QuoteApprovalDetails = 'This Quote/Proposal requires G4 Approval. Please set the Opportunity Sales Phase back to Create Offer (Bid), create a new Offer and re-validate the Quote.'; // Label Changed - SF Ticket 00956787
		}
		else if(quoteProposal.Apttus_Proposal__Opportunity__r.StageName == GlobalConstants.CREATE_OFFER && (QuoteProposal.Apttus_Proposal__Approval_Stage__c == Nokia_CPQ_Constants.ApprovalRequired  || QuoteProposal.Apttus_Proposal__Approval_Stage__c ==  GlobalConstants.REVIEW) && QuoteProposal.Apttus_Proposal__Opportunity__r.LOA_Level__c != GlobalConstants.LOA_BYPASS_LEVEL  && 
	QuoteProposal.Apttus_Proposal__Opportunity__r.No_Loa__c != true && QuoteProposal.Apttus_Proposal__Opportunity__r.Pre_approved_Price_List_for_AM__c == 0 && QuoteProposal.Apttus_Proposal__Opportunity__r.Authorized_for_Pricing_manager__c == 0)
	  
		 {
		 QuoteApprovalDetails = 'This Quote/Proposal requires G4 Approval. Please validate the Quote, send the quote data to NPT, contact the Pricing Manager to process the data in NPT Cloud and in the Win the Deal tool, and submit the opportunity for G4 approval to complete the quote approval.'; // Label Changed - SF Ticket 00956787 
		 }
	}
	  system.debug('QuoteApprovalDetails '+QuoteApprovalDetails );
	 return QuoteApprovalDetails;
}
}