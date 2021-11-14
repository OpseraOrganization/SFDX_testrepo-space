/***********************************
Class Name: QuestionnaireTriggerHelper
Author: Accenture
Reason: Sales Process : This is to lock relatedList of opportunity.
Created Date: Feb / 2017 
******************************************/
public with sharing class QuestionnaireTriggerHelper{
	
	/***********************
	* Method Name: retrictQuestionnaire
	* Description: Sales Process : lock relatedList of opportunity before update when opty stage = Identify Opportunity/Win the Case/Create Offer/ Develop Opportunity and Sales_Outcome = Cancelled by Customer/Lost to Competitor/Withdrawn by Nokia/Obsolete						   
	* Parameters: List of OptyProgramFlagJunction__c
	************************/ 
	public static void retrictQuestionnaire(List<Questionnaire__c> QuesList){ 
		try{
			Map<ID,ID> QuesIDOppIDMap = new Map<ID,ID>();
			
			for(Questionnaire__c Ques : QuesList){
				if(Ques.Opportunity__c != null){
					QuesIDOppIDMap .put(Ques.Id,Ques.Opportunity__c);
				}  
			}
			if(QuesIDOppIDMap .size() > 0){
				Map<ID,Opportunity> oppMap = new Map<ID,Opportunity>([Select id, StageName, Phase_Status__c,Sales_Outcome__c from Opportunity where Id IN: QuesIDOppIDMap.Values()   Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]);
				for(Questionnaire__c Ques : QuesList){
					if(Ques.Opportunity__c != null){
						Opportunity opp = oppMap.get(QuesIDOppIDMap .get(Ques.id));
						//Adding logic as per D-1687
						//if(opp.StageName != null && opp.Sales_Outcome__c != null){
							//if((opp.StageName == 'Identify Opportunity' || opp.StageName == 'Win the Case' || opp.StageName == 'Create Offer' || opp.StageName == 'Develop Opportunity') && (opp.Sales_Outcome__c == 'Cancelled by Customer' || opp.Sales_Outcome__c == 'Lost to Competitor' || opp.Sales_Outcome__c == 'Withdrawn by Nokia' || opp.Sales_Outcome__c == 'Obsolete')){
							if(opp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.PHASE_STATUS_CLOSED) || opp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON)){
								Ques.addError(System.Label.Questionnaire_Error_Message);
							
							}
						//}
					}
				}
			}
			
			
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.QUESTIONNAIRETRIGGERHELPER,GlobalConstants.RETRICTQUESTIONNAIRE);
		}
	}
}