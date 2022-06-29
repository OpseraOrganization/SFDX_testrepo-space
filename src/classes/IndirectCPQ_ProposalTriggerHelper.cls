/******************************************************************************************************
Name : IndirectCPQ_ProposalTriggerHelper
Created by: Accenture
Description : Helper class for Indirect CPQ to handle quote process.		
*********************************************************************************************************/
public without sharing class IndirectCPQ_ProposalTriggerHelper { 
/******************************
*Method Name: updateStatusonLI
*Description: This Method is used to update Pricing Status On Config LI once Prices are overridden at Quote Level.
 ********************************/
	public static void updateStatusonLI(Map<Id , Boolean> quoteIDSet){
		try{
			Set<Id>productConfigIDSet = new Set<Id>();
			List <Apttus_Config2__LineItem__c> configLIList = new List<Apttus_Config2__LineItem__c>();
	 for(Apttus_Config2__ProductConfiguration__c config : [Select ID,Name from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c IN : quoteIDSet.keySet() and Apttus_Config2__Status__c = : Nokia_CPQ_Constants.Saved ]){
	   productConfigIDSet.add(config.Id);
	 }
		
	 for(Apttus_Config2__LineItem__c configLI : [Select ID, Name,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c, Apttus_Config2__ChargeType__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c IN : productConfigIDSet]){
	if(quoteIDSet.get(configLI.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c) || configLI.Apttus_Config2__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD)){
	configLI.Apttus_Config2__PricingStatus__c = Nokia_CPQ_Constants.PENDING_STRING;
	configLIList.add(configLI);
			}
		}
		database.update(configLIList); 
	}
		Catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_ProposalTriggerHelper.class.getName(), Nokia_CPQ_Constants.ERROR_MSD);
		}
		
	}


	/*********************************	
	* Author : Christie JJ	
	* Param: Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap, Map<Id, Apttus_Proposal__Proposal__c> proposalOldTriggerMap	
	* Return: None  	
	* This method is written in order to Accept the Partner Quotes, when their SAP Document Number gets populated from Workato.	
	**********************************/	
	public static void checkSAPNumberIsPopulated(List<Apttus_Proposal__Proposal__c> updatedQuoteList, Map<Id, Apttus_Proposal__Proposal__c> proposalOldTriggerMap){	
		List<Apttus_Proposal__Proposal__c> proposalsMatching = new List<Apttus_Proposal__Proposal__c>();	
		Map<Id, Apttus_Proposal__Proposal__c> proposalNewTriggerMap = new Map<Id, Apttus_Proposal__Proposal__c>(updatedQuoteList);	
			
		for(Id quoteRecord : proposalNewTriggerMap.keyset()){	
  	
	if(proposalNewTriggerMap.get(quoteRecord).Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ && 	
	proposalNewTriggerMap.get(quoteRecord).NokiaCPQ_SAP_Document_Number__c!=null && 	
	proposalNewTriggerMap.get(quoteRecord).NokiaCPQ_SAP_Document_Number__c!=proposalOldTriggerMap.get(quoteRecord).NokiaCPQ_SAP_Document_Number__c){	
  	
			proposalsMatching.add(proposalNewTriggerMap.get(quoteRecord));	
	}	
		}	
  	
		if(proposalsMatching.size()>0){	
	for(Apttus_Proposal__Proposal__c proposalRecord : proposalsMatching){	
			system.debug('[+] Before Accept');	
			system.debug('[+] approval stage = '+proposalRecord.Apttus_Proposal__Approval_Stage__c);	
			Boolean isSuccess = Apttus_QPConfig.QPConfigWebService.acceptQuote(proposalRecord.Id);	
			system.debug('[+] After Accept');	
			system.debug('[+] approval stage = '+proposalRecord.Apttus_Proposal__Approval_Stage__c);	
  	
  	
	}	
		}	
	  }

}