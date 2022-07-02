/*************************************************************
@Name: NokiaCPQ_Reprice_Quote_controller
@Author: Accenture
@Description: This class contains logic for quote reprice

******************************************************************/

public without sharing class NokiaCPQ_Reprice_Quote_controller{
	public static String toastMessage;
	public static List<Apttus_Proposal__Proposal__c> validQuoteList = new List<Apttus_Proposal__Proposal__c>();
	
	//constructor defined
	public NokiaCPQ_Reprice_Quote_controller(){
		toastMessage = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;	  
	}
	
	//The method contains the logic to start the reprice batch 
	@AuraEnabled
	public static String submitForReprice(String recordIdVar){
		String quoteStages = Label.Skip_Reprice_Stages;
		Integer maxCount = 10;
		List<String> quoteStageList = new List<String>();
		
		try{
			if(String.isNotBlank(quoteStages)){
				quoteStageList.addAll(quoteStages.split(Nokia_CPQ_Constants.SEMICOLON_STRING));
			}
			if(String.isNotBlank(recordIdVar)){
				validQuoteList = [Select Id From Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c =:recordIdVar AND NokiaCPQ_Needs_Reprice__c = true AND Reprice_In_Progress__c = false AND Quote_Type__c =: Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ  AND Apttus_Proposal__Approval_Stage__c NOT IN: quoteStageList LIMIT 1];
				system.debug('validQuoteList--->'+validQuoteList);
			}
		   
			if(validQuoteList.isEmpty()){	
				toastMessage = Nokia_CPQ_Constants.REPRICENOTREQ;
			}
			else{
				if(String.isNotBlank(Label.DecreaseRepriceLoad)){
					maxCount= Integer.valueOf(Label.DecreaseRepriceLoad);
				}
				if([SELECT count() FROM AsyncApexJob WHERE JobType =: Nokia_CPQ_Constants.BATCHAPEX_STRING AND (Status =: Nokia_CPQ_Constants.PROCCESSING_STRING OR Status =: Nokia_CPQ_Constants.PREPARING_STRING OR Status =: Nokia_CPQ_Constants.HOLDING_STRING OR Status =: Nokia_CPQ_Constants.QUEUED_STRING)] < maxCount){ 
					Id batchId = Database.executeBatch(new RepriceAllQuotesBatch(recordIdVar),50);
					toastMessage = Nokia_CPQ_Constants.REPRICEBATCHSUBMITTED;
				}
				else{
					toastMessage = Nokia_CPQ_Constants.REPRICEBATCHOVERLOAD;
				}
			}
		}
		
		catch(Exception e){
			 ExceptionHandler.addException(e,NokiaCPQ_Reprice_Quote_controller.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			
		}
		
		system.debug('toastMessage--->'+toastMessage);
		return toastMessage;   
	}  
}