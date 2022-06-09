public class NokiaCPQ_inQuteApprvlTempltController {	

	public Id quoteId {get;set;}
	public Apttus_CQApprov.CartApprovalEmailController stdCntrlr {get; set;}
	public String QuoteApprovalDetails = '';
	
	public NokiaCPQ_inQuteApprvlTempltController(Apttus_CQApprov.CartApprovalEmailController controller){
	 stdCntrlr = controller;
	}
	
	public String getQuoteAppvlDtls(){
		Id proposalid;
		if(!Test.isRunningTest()){
	proposalid = [select id,Apttus_QPApprov__ProposalId__c from Apttus_Approval__Approval_Request__c where id=:quoteId].Apttus_QPApprov__ProposalId__c;
		}else{
	proposalid = [select id,Apttus_QPApprov__ProposalId__c from Apttus_Approval__Approval_Request__c].Apttus_QPApprov__ProposalId__c;
		}
		Apttus_Proposal__Proposal__c QuoteProposal = [Select id,NokiaCPQ_Net_Amount_Quote__c,CurrencyIsoCode,Maintenance_Y1__c,Maintenance_Y2__c,SRS__c,SSP__c,NokiaCPQ_CAD__c,NokiaCPQ_LEO_Discount__c,NokiaCPQ_has_Partner_Certified__c,is_LEO_Criteria_Match__c from Apttus_Proposal__Proposal__c where id =:proposalid];
		
		if(QuoteProposal.NokiaCPQ_LEO_Discount__c == true && QuoteProposal.NokiaCPQ_has_Partner_Certified__c == true){
			QuoteApprovalDetails +='This is a Lab Equipment Quote with value '+QuoteProposal.CurrencyIsoCode+ ' '+QuoteProposal.NokiaCPQ_Net_Amount_Quote__c+ '\n';
		}
		
		if(QuoteProposal.NokiaCPQ_CAD__c > 0){
			QuoteApprovalDetails +='Quote requires a CAD approval with a value '+QuoteProposal.CurrencyIsoCode+ ' '+QuoteProposal.NokiaCPQ_CAD__c+'\n';
		}
		
		if(QuoteProposal.Maintenance_Y1__c > 0 || QuoteProposal.Maintenance_Y2__c > 0 || QuoteProposal.SRS__c > 0 || QuoteProposal.SSP__c > 0){
		
	QuoteApprovalDetails += 'Following values are overridden in the quote : \n';
	
			if(QuoteProposal.Maintenance_Y1__c > 0){
	QuoteApprovalDetails += 'Maintenance Year1 \n';
			}
	
			if(QuoteProposal.Maintenance_Y2__c > 0){
	QuoteApprovalDetails +='Maintenance Year2+ \n';
			}
	
			if(QuoteProposal.SRS__c > 0){
	QuoteApprovalDetails +='SRS \n';
			}
	
			if(QuoteProposal.SSP__c > 0){
	QuoteApprovalDetails +='SSP \n';
			}
		}
	
		
		List<Apttus_Config2__LineItem__c> lineItem;
		/*lineItem = [Select id,is_Custom_Product__c,is_Custom_Product__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Maintenance_Y1__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Maintenance_Y2__c, 
		Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.SRS__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.SSP__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_CAD__c, 
		Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_has_Partner_Certified__c, 
		Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.is_LEO_Criteria_Match__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =:proposalid]; */
		
		lineItem = [Select id,is_Custom_Product__c,Custom_Product_Name__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =:proposalid and Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c =:GlobalConstants.FINALIZED and is_Custom_Product__c = true];
		
		if(lineItem.size() > 0){
			QuoteApprovalDetails +='This a custom product approval \n';
		}
		
		for(Apttus_Config2__LineItem__c items: lineItem){

			if(items.is_Custom_Product__c == true && items.Custom_Product_Name__c != ''){
	 QuoteApprovalDetails += items.Custom_Product_Name__c+'\n';
			}
		
		} 
		QuoteApprovalDetails = QuoteApprovalDetails.removeEnd('\n');
		//System.debug('QuoteApprovalDetails-->'+QuoteApprovalDetails);
		return QuoteApprovalDetails;

	}

}