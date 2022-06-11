/*******************************
	Class Name: CSWX_OpportunityTriggerHelper
	Created by: Accenture
	Created Date: 26 Apr 2018
	Last modified by: Accenture
	Last modified date: 26 Apr 2018
	Description: This class will handle the logic implemented to create Quote/Proposal
	*******************************/
public without sharing class CSWX_OpportunityTriggerHelper implements Queueable {
  
   private Set<Id> accId = new Set<Id>();
   private Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
   
   /******************************
	*Method Name: execute
	*Description: This method is used to create Quote/Proposal when Upsell Stage changes to convert
	*Parameters:  UpsellProposal List
	********************************/
   public void execute(QueueableContext context) {
	   
	   System.debug('inside quote creation');
		
		 List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
			try{ 
				
			   Map<Id,Account> accIdWithPriceList = new Map<Id,Account>([Select Id,name,(SELECT Id,CurrencyIsoCode,Apttus_Config2__AccountId__c,Type__c,PriceList_Type__c FROM Apttus_Config2__PriceLists__r) from account where Id in:accId LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]);			
			   List<Apttus_Config2__PriceList__c> currentPriceList;
			   Apttus_Proposal__Proposal__c proposalObj;
				
			   
			   for(SWx_Upsell_Proposal__c upsellProposalObj : [SELECT Id,Account_ID__c,CurrencyIsoCode,Analytics_File_Refer_ID__c,Proposal_Recommendation_Type__c,Creation_Date__c,Collection_Period_End_Date__c,Collection_Period_Start_Date__c,Analytics_Source__c, Sold_To_Party__c FROM SWx_Upsell_Proposal__c WHERE ID IN :upsellProposalToOppty.keySet() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				   
				   
				   System.debug('dplist-->'+upsellProposalObj);
						   
							proposalObj = new Apttus_Proposal__Proposal__c();
						   Opportunity opptyObj = upsellProposalToOppty.get(upsellProposalObj.Id);
						   System.debug('opptyObj-->'+opptyObj);
						   if(opptyObj!=NULL){
							   proposalObj.Apttus_Proposal__Opportunity__c = opptyObj.Id;
							   proposalObj.Apttus_Proposal__Proposal_Name__c = opptyObj.Name;
						   }
						   
						   proposalObj.Apttus_Proposal__Account__c = upsellProposalObj.Account_ID__c;
						   proposalObj.Analytics_File_Refer_ID__c = upsellProposalObj.Analytics_File_Refer_ID__c;
						   proposalObj.Apttus_Proposal__Approval_Stage__c = CSWXGlobalConstant.draft;
						   proposalObj.Proposal_Recommendation_Type__c = upsellProposalObj.Proposal_Recommendation_Type__c;
						   proposalObj.Creation_Date__c = upsellProposalObj.Creation_Date__c;
						   proposalObj.Collection_Period_Start_Date__c = upsellProposalObj.Collection_Period_Start_Date__c;  
						   proposalObj.Collection_Period_End_Date__c = upsellProposalObj.Collection_Period_End_Date__c;
						   proposalObj.Analytics_Source__c= upsellProposalObj.Analytics_Source__c;
						   proposalObj.SWx_Upsell_Proposal__c = upsellProposalObj.Id;
						   System.debug('upsellProposalObj.Account_ID__c --->'+upsellProposalObj.Account_ID__c);
						  
						  
						   proposalObj.Apttus_Proposal__Valid_Until_Date__c = System.today().AddDays(28);
						  // proposalObj.CurrencyIsoCode = upsellProposalObj.CurrencyIsoCode;
						   proposalObj.Sold_TO_Party__c = upsellProposalObj.Sold_To_Party__c;
						   
						   
							Id RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId();
							if(RecordTypeId !=null){   
									  proposalObj.RecordTypeId= RecordTypeId;
							  
							  }
				   
	 
							Boolean doesNotMatchType = false;  
							if(accIdWithPriceList.containsKey(upsellProposalObj.Account_ID__c)){
								currentPriceList = accIdWithPriceList.get(upsellProposalObj.Account_ID__c).Apttus_Config2__PriceLists__r;
								if(!currentPriceList.isEmpty()){
									for(Apttus_Config2__PriceList__c plobj : currentPriceList){
								   /**  DSI-1252,Sprint 21 - Removed the analytic resource  dependency **/
										if(plobj.PriceList_Type__c.equalsIgnoreCase(CSWXGlobalConstant.DSPriceListType)){
										
											proposalObj.Apttus_QPConfig__PriceListId__c = plobj.Id;
											proposalObj.CurrencyIsoCode = plobj.CurrencyIsoCode;
											break;
										}
										
									}
								   
								}
								else{
									 doesNotMatchType = true;
									}
							}
						 
						  // **  Comented in Sprint 21, DSI-1252 , Logic to assign default price list
						 /*   if(!accIdWithPriceList.containsKey(upsellProposalObj.Account_ID__c) || doesNotMatchType == true){
								if(upsellProposalObj.Analytics_Source__c.equals(CSWXGlobalConstant.AnalyticsSource)){
									proposalObj.Apttus_QPConfig__PriceListId__c = System.Label.CXM_PriceList;
								}
								else{ 
								   if(upsellProposalObj.Analytics_Source__c.equals(CSWXGlobalConstant.AnalyticsSource_CCRE)){
											proposalObj.Apttus_QPConfig__PriceListId__c =System.Label.CCRE_PriceList;
								   }		
								}
							}*/
				 System.debug('proposalList--->'+proposalList);  
	 
			   proposalList.add(proposalObj);
			  
			   }
			  
			   insert proposalList;
			  
		 }catch(Exception ex){
			   ExceptionHandler.addException(ex, CSWXGlobalConstant.CSWX_OpportunityTriggerHelper, CSWXGlobalConstant.CREATEPROPOSAL);
	   }	   
	}
 
 

 /******************************
	*Method Name: CSWX_OpportunityTriggerHelper Constructor
	*Description: This used to initalize value of upsellProposalToOpptyMap and accSet
	*Parameters:  Map<Id,Opportunity> upsellProposalToOpptyMap,Set<Id> accSet
	********************************/	
	 public CSWX_OpportunityTriggerHelper (Map<Id,Opportunity> upsellProposalToOpptyMap,Set<Id> accSet) {
		this.accId = accSet;
		this.upsellProposalToOppty = upsellProposalToOpptyMap;
	   }
	}