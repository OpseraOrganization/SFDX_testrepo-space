/***********************************
Class Name: OptyProgramFlagJunctionTriggerHelper
Author: Accenture
Reason: Sales Process : This is to lock relatedList of opportunity.
Created Date: Feb / 2017 
******************************************/
public with sharing class OptyProgramFlagJunctionTriggerHelper{
	
	 /***********************
	* Method Name: retrictOptyProgramFlagJunction
	* Description: Sales Process : lock relatedList of opportunity before update when opty stage = Identify Opportunity/Win the Case/Create Offer/ Develop Opportunity and Sales_Outcome = Cancelled by Customer/Lost to Competitor/Withdrawn by Nokia/Obsolete		 
	* Parameters: List of OptyProgramFlagJunction__c
	************************/ 
	public static void retrictOptyProgramFlagJunction(List<OptyProgramFlagJunction__c> opfjList){ 
		try{
			Map<ID,ID> opfjIDOppIDMap = new Map<ID,ID>();
			
			for(OptyProgramFlagJunction__c opfj : opfjList){
	if(opfj.Opportunity__c != null){
		opfjIDOppIDMap .put(opfj.Id,opfj.Opportunity__c);
	}  
			}
			if(opfjIDOppIDMap .size() > 0){
	Map<ID,Opportunity> oppMap = new Map<ID,Opportunity>([Select id, StageName, Phase_Status__c,Sales_Outcome__c from Opportunity where Id IN: opfjIDOppIDMap.Values()]);
	for(OptyProgramFlagJunction__c opfj : opfjList){
		if(opfj.Opportunity__c != null){
			Opportunity opp = oppMap.get(opfjIDOppIDMap.get(opfj.id));
			//Adding logic as per D-1687: opportunity will be locked based on Phase Status
			//if(opp.StageName != null && opp.Sales_Outcome__c != null){
	//if((opp.StageName == 'Identify Opportunity' || opp.StageName == 'Win the Case' || opp.StageName == 'Create Offer' || opp.StageName == 'Develop Opportunity') && (opp.Sales_Outcome__c == 'Cancelled by Customer' || opp.Sales_Outcome__c == 'Lost to Competitor' || opp.Sales_Outcome__c == 'Withdrawn by Nokia' || opp.Sales_Outcome__c == 'Obsolete')){
	if(opp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.PHASE_STATUS_CLOSED) || opp.Phase_Status__c.equalsIgnoreCase(GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON)){
		opfj.addError(System.Label.Program_Flag_Error_Message);	
	}
			//}
		}
	}
			}
			
			
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.OPTYPROGRAMFLAGJUNCTIONTRIGGERHELPER ,GlobalConstants.RETRICTOPTYPROGRAMFLAGJUNCTION);
		}
	}

	//Sales Process: Requirement 1454
	/***********************
	* Method Name: copyOpptyProgramFlagToOif
	* Description: Sales Process : This method will update OIF's Program Flag with Opportunity Related Program Flag 
	* Parameters: List of OptyProgramFlagJunction__c
	************************/ 
	public static void copyOpptyProgramFlagToOif(List<OptyProgramFlagJunction__c> opfjList, boolean isInsert){
		Set<ID> OpportunityIdSet = new Set<ID>();
		List<Order_Intake_Forecast__c> oifList = new List<Order_Intake_Forecast__c>();
		Map<Id, List<ID>> opptyToProgFlagMap = new Map<Id, List<ID>>();
		Map<Id, List<ID>> opptyToOifMap = new Map<Id, List<ID>>();
		List<OIFProgramFlagJunction__c> finalOIFProgramFlagJunctionRecList = new List<OIFProgramFlagJunction__c>();
		List<ID> pfIds = new List<ID>();
		List<ID> oifIds = new List<ID>();
		//Getting Opportunity Related to Program Flags 
		try{
			if(!opfjList.IsEmpty()){
	for(OptyProgramFlagJunction__c programFlag : opfjList){
	system.debug('Adam_Test======='+opfjList);
	system.debug('opfjList>>'+opfjList.size());
		if(programFlag.Program_Flag__c != NULL){
			OpportunityIdSet.add(programFlag.Opportunity__c);
			if(opptyToProgFlagMap.containskey(programFlag.Opportunity__c)){
	//List<ID> pfIds = new List<ID>();
	pfIds = opptyToProgFlagMap.get(programFlag.Opportunity__c);
	pfIds.add(programFlag.Program_Flag__c);
	//relationship between Opportunity and PF
	opptyToProgFlagMap.put(programFlag.Opportunity__c, pfIds);
			}
			else{
	pfIds = new List<ID>();
	pfIds.add(programFlag.Program_Flag__c);
	//relationship between Opportunity and PF
	opptyToProgFlagMap.put(programFlag.Opportunity__c, pfIds);
			}
		}
	}
			}

			if(isInsert){
			//Getting Opportunity's related OIF
			System.debug('opptyToOifMap>>');
	
	  //SF 00211091 - removed 'And Allocation__c != True' from below SOQL
	  //oifList = [SELECT Id, Opportunity__c FROM Order_Intake_Forecast__c WHERE Opportunity__c IN : OpportunityIdSet And Allocation__c != True LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	  oifList = [SELECT Id, Opportunity__c FROM Order_Intake_Forecast__c WHERE Opportunity__c IN : OpportunityIdSet LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	
	if(oifList != NULL){
		for(Order_Intake_Forecast__c oifObj : oifList){
			if(opptyToOifMap.containskey(oifObj.Opportunity__c)){
	oifIds = opptyToOifMap.get(oifObj.Opportunity__c);
	oifIds.add(oifObj.Id);
	opptyToOifMap.put(oifObj.Opportunity__c, oifIds);
			}
			else{
	oifIds = new List<ID>();
	oifIds.add(oifObj.Id);
	opptyToOifMap.put(oifObj.Opportunity__c, oifIds);
			}
	System.debug('opptyToOifMap>>'+opptyToOifMap.size());
		}
	}

	// generate OIFProgramFlagJunction__c records. 
	for(Id opptyId : opptyToProgFlagMap.keySet()){
		for(Id pfId : opptyToProgFlagMap.get(opptyId)){
			if(opptyToOifMap.get(opptyId) != NULL ){
	for(Id oifId : opptyToOifMap.get(opptyId)){
		if(pfId != null && oifId != null){
		OIFProgramFlagJunction__c objOIFProgramFlagJunction = new OIFProgramFlagJunction__c();
		String SoifId = String.valueOf(oifId);
		SoifId = SoifId.substring(0,SoifId.length()-3); 
		objOIFProgramFlagJunction.Order_Intake_Forecast__c = SoifId;
		
		String SpfId = String.valueOf(pfId);
		SpfId = SpfId.substring(0,SpfId.length()-3);	
		objOIFProgramFlagJunction.Program_Flag_Data__c=SpfId;
		system.debug('Zeen Liu Create'+objOIFProgramFlagJunction.Order_Intake_Forecast__c+'++++'+objOIFProgramFlagJunction.Program_Flag_Data__c);
		finalOIFProgramFlagJunctionRecList.add(objOIFProgramFlagJunction);
		}
	}  
			}
		}
	}
	System.debug('finalOIFProgramFlagJunctionRecList>>'+ finalOIFProgramFlagJunctionRecList.size());
	if (finalOIFProgramFlagJunctionRecList.size()>0) {
		database.insert(finalOIFProgramFlagJunctionRecList);
	}
			}else{
	Set<Id> forDeletionPfId = new Set<Id>();
	for(OptyProgramFlagJunction__c forProgFlagDeletion : opfjList){
		if(forProgFlagDeletion.Program_Flag__c != null){
			forDeletionPfId.add(forProgFlagDeletion.Program_Flag__c);
		}
	}
	if (OpportunityIdSet != null){
		//Adam Update
		List<String> list_OpID  = new List<String>();
		for (Id opid: OpportunityIdSet) {
			String onerun = String.valueOf(opid);
			onerun = onerun.substring(0,onerun.length()-3);
			System.debug('onerun===' +onerun);
			list_OpID.add(onerun);
		}
		finalOIFProgramFlagJunctionRecList = [SELECT id, Program_Flag_Data__c,OIF_Oppt_ID__c FROM OIFProgramFlagJunction__c WHERE Program_Flag_Data__c IN: forDeletionPfId AND OIF_Oppt_ID__c IN: list_OpID LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
		if (finalOIFProgramFlagJunctionRecList.size()>0) {
System.debug('finalOIFProgramFlagJunctionRecList===' + finalOIFProgramFlagJunctionRecList);
			database.delete(finalOIFProgramFlagJunctionRecList);
		}
	}
			}  
		}

	catch(Exception ex){
		ExceptionHandler.addException(ex,GlobalConstants.OPTYPROGRAMFLAGJUNCTIONTRIGGERHELPER ,GlobalConstants.OPTY_TO_OIF_PROGRAM_FLAG);
	}
	}
}