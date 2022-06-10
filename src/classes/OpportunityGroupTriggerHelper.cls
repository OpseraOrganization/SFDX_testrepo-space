/*******************************
Class Name: OpportunityGroupTriggerHelper
Created by: Accenture
Last modified by: Accenture
Description: This class will handle the logic implemented on Deal-Opportunity Grouping
*******************************/
public class OpportunityGroupTriggerHelper 
{
	public static boolean firstRun = true;
	/*****************************
*Method Name: populateUnweightedValueofGroupingObject
*Description: This method will populate the Unweighted value of Deal-Opportunity Grouping object from unweighted value of its Master Opportunity.
*Parameters:Deal-Opportunity Grouping List
*Requirement : 4943
*******************************/
	public static void populateUnweightedValueofGroupingObject( List<Opportunity_Group__c> opptyGroupList)
	{
		Map<id, Opportunity> opptyMap = new Map<id, Opportunity>();
		try{
			set<ID> opptyIdSet = new set<ID>();
			for (Opportunity_Group__c opptyGroupObj: opptyGroupList) 
			{
	if(opptyGroupObj.Opportunity__c != null)
	{
		opptyIdSet.add(opptyGroupObj.Opportunity__c);
	}
			}
			if(opptyIdSet.size() > 0)
			{
	opptyMap = new Map<Id,Opportunity>([select id,Unweighted_Amount_EUR__c from Opportunity where id IN:opptyIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
			}
			for (Opportunity_Group__c opptyGroupObj: opptyGroupList) 
			{
	opptyGroupObj.Unweighted_Value_in_EUR__c  = opptyMap.get(opptyGroupObj.Opportunity__c).Unweighted_Amount_EUR__c;
			}
		}
		catch (Exception ex) 
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.populateUnweightedValueofGroupingObject);
		}
	}
	/*****************************
*Method Name: validateCorrectDealOpptyCombination
*Description: This method will check the deal combination associated with an opportunity.
*Parameters:Deal-Opportunity Grouping List
*Requirement : 4557
*******************************/
	 public static void validateCorrectDealOpptyCombination( List<Opportunity_Group__c> newOpptyGroupList)
	{
		try{
			Map<ID, List<Opportunity_Group__c>> opptyWithOpptyGroupMap = new Map<ID, List<Opportunity_Group__c>>();
			Map<ID, List<Opportunity_Group__c>> opptyWithOpptyGroupMapNew = new Map<ID, List<Opportunity_Group__c>>();
			Map<ID, List<Opportunity_Group__c>> opptyWithOpptyGroupMapOld = new Map<ID, List<Opportunity_Group__c>>();
			Map<ID, String> dealIdWithRecordTypeMap = new Map<ID, String>();
			set<ID> newDealIdsSet = new set<ID>();
			set<ID> newOppIdSet = new set<ID>();
			List<Opportunity_Group__c > opptyGroupList;
			List<Opportunity_Group__c > opptyGrpList = new List<Opportunity_Group__c >();
			List<Opportunity_Group__c > opptyGroupErrorList = new List<Opportunity_Group__c >();
			List<Opportunity_Group__c > opptyGrpListNew ;
			String oldDealType;
			String newDealType;
			String oldRelation;
			String newRelation;
			for (Opportunity_Group__c opptyGroupObj: newOpptyGroupList) 
			{
	newDealIdsSet.add(opptyGroupObj.Deal__c);	
			}
			for(Deal__c dealObj : [select id, RecordType.Name from Deal__c where id in :newDealIdsSet])
			{
	dealIdWithRecordTypeMap.put(dealObj.id, dealObj.RecordType.Name);
			}
			for (Opportunity_Group__c opptyGroupObj: newOpptyGroupList) 
			{
	if(dealIdWithRecordTypeMap.get(opptyGroupObj.Deal__c) != GlobalConstants.SIMPLE_DEAL)
	{
		if(opptyWithOpptyGroupMap.containsKey(opptyGroupObj.Opportunity__c))
		{
			opptyGroupList = opptyWithOpptyGroupMap.get(opptyGroupObj.Opportunity__c);
			opptyGroupList.add(opptyGroupObj);
			opptyWithOpptyGroupMap.put(opptyGroupObj.Opportunity__c,opptyGroupList );
		}
		else
		{
			opptyGroupList= new List<Opportunity_Group__c >();
			opptyGroupList.add(opptyGroupObj);
			opptyWithOpptyGroupMap.put(opptyGroupObj.Opportunity__c,opptyGroupList);
		}	
	}	  
			}
			for(Opportunity_Group__c opptyGroupObj: [Select Opportunity__c,deal__c,deal__r.recordtype.name,id,Opportunity_Relation__c 
				 from Opportunity_Group__c 
				 where Opportunity__c IN: opptyWithOpptyGroupMap.keySet() and
				 deal__r.recordtype.name !=: GlobalConstants.SIMPLE_DEAL
				 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	if(opptyWithOpptyGroupMapOld.containsKey(opptyGroupObj.Opportunity__c))
	{
		opptyGrpList = opptyWithOpptyGroupMapOld.get(opptyGroupObj.Opportunity__c);
		opptyGrpList.add(opptyGroupObj);
		opptyWithOpptyGroupMapOld.put(opptyGroupObj.Opportunity__c,opptyGrpList );
	}
	else
	{
		opptyGrpList.clear();
		opptyGrpList.add(opptyGroupObj);
		opptyWithOpptyGroupMapOld.put(opptyGroupObj.Opportunity__c,opptyGrpList);
	} 
	dealIdWithRecordTypeMap.put(opptyGroupObj.deal__c, opptyGroupObj.deal__r.recordtype.name);
			}
			
			for(Id opptyId : opptyWithOpptyGroupMap.keySet())
			{
	if(!opptyWithOpptyGroupMapOld.keySet().contains(opptyId))
		newOppIdSet.add(opptyId);
			}
			for(Id opptyId : opptyWithOpptyGroupMap.keySet())
			{
	if(opptyWithOpptyGroupMapOld.get(opptyId).size() > 1)
	{
		opptyGroupErrorList.addAll(opptyWithOpptyGroupMap.get(opptyId));
	}
	else if(opptyWithOpptyGroupMapOld.get(opptyId).size() == 1)
	{
		if(opptyWithOpptyGroupMap.get(opptyId).size() > 1)
		{
			opptyGroupErrorList.addAll(opptyWithOpptyGroupMap.get(opptyId));
			opptyGroupErrorList.remove(0);
		}
		else
		{
			opptyGrpListNew = new List<Opportunity_Group__c >();
			opptyGrpListNew.add(opptyWithOpptyGroupMap.get(opptyId)[0]);
			opptyWithOpptyGroupMapNew.put(opptyId,opptyGrpListNew);
		}  
	}
			}
			if(newOppIdSet.size() > 0)
			{
	for(Id opptyId:newOppIdSet)
	{
		if(opptyWithOpptyGroupMap.get(opptyId).size() > 2)
		{
			opptyGroupErrorList.addAll(opptyWithOpptyGroupMap.get(opptyId));
			opptyGroupErrorList.remove(0);
			opptyGroupErrorList.remove(1);
		}
		else
		{
			opptyGrpListNew = new List<Opportunity_Group__c >();
			opptyGrpListNew.add(opptyWithOpptyGroupMap.get(opptyId)[0]);
			opptyGrpListNew.add(opptyWithOpptyGroupMap.get(opptyId)[1]);
			opptyWithOpptyGroupMapNew.put(opptyId,opptyGrpListNew);
		}
	} 
			}
			for(Opportunity_Group__c opptyGroupObj: opptyGroupErrorList)
	opptyGroupObj.addError(System.label.InvalidDealCombinationError);
			if(opptyWithOpptyGroupMapNew.size() > 0)
			{
	for(id opptyId : opptyWithOpptyGroupMapNew.keySet())
	{
		if(opptyWithOpptyGroupMapNew.get(opptyId).size() == 1)
		{
			oldDealType = dealIdWithRecordTypeMap.get(opptyWithOpptyGroupMapOld.get(opptyId)[0].Deal__c);
			newDealType = dealIdWithRecordTypeMap.get(opptyWithOpptyGroupMapNew.get(opptyId)[0].Deal__c);
			oldRelation = opptyWithOpptyGroupMapOld.get(opptyId)[0].Opportunity_Relation__c;
			newRelation = opptyWithOpptyGroupMapNew.get(opptyId)[0].Opportunity_Relation__c;
		}
		else if(opptyWithOpptyGroupMapNew.get(opptyId).size() == 2)
		{
			oldDealType = dealIdWithRecordTypeMap.get(opptyWithOpptyGroupMapNew.get(opptyId)[0].Deal__c);
			newDealType = dealIdWithRecordTypeMap.get(opptyWithOpptyGroupMapNew.get(opptyId)[1].Deal__c);
			oldRelation = opptyWithOpptyGroupMapNew.get(opptyId)[0].Opportunity_Relation__c;
			newRelation = opptyWithOpptyGroupMapNew.get(opptyId)[1].Opportunity_Relation__c;
		}
		if((oldDealType.equalsignorecase(GlobalConstants.UPSELL_DEAL) && newDealType.equalsignorecase( GlobalConstants.UPSELL_DEAL)) 
		|| (oldDealType.equalsignorecase(GlobalConstants.FRAMED_DEAL) && newDealType.equalsignorecase( GlobalConstants.FRAMED_DEAL)))
			opptyWithOpptyGroupMapNew.get(opptyId)[opptyWithOpptyGroupMapNew.get(opptyId).size()-1].addError(System.label.InvalidDealCombinationError);
		/*else if(((newRelation.equalsignorecase(GlobalConstants.SUBORDINATE) && oldRelation.equalsignorecase(GlobalConstants.MASTER))
		|| (newRelation.equalsignorecase(GlobalConstants.MASTER) && oldRelation.equalsignorecase( GlobalConstants.SUBORDINATE))
		|| (newRelation.equalsignorecase(GlobalConstants.SUBORDINATE) && oldRelation.equalsignorecase(GlobalConstants.SUBORDINATE)))	
				&& ((oldDealType.equalsignorecase(GlobalConstants.UPSELL_DEAL) && newDealType.equalsignorecase(GlobalConstants.FRAMED_DEAL)) 
		|| (oldDealType.equalsignorecase(GlobalConstants.FRAMED_DEAL) && newDealType.equalsignorecase(GlobalConstants.UPSELL_DEAL))))
			opptyWithOpptyGroupMapNew.get(opptyId)[opptyWithOpptyGroupMapNew.get(opptyId).size()-1].addError(System.label.InvalidDealCombinationError_MasterOppty); */ 
	}
			}	  
		}
		catch (Exception ex) 
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.validateCorrectDealOpptyCombination);
		}
	}
	/*****************************
*Method Name: restrictOpptyAssociationWithSameDeal
*Description: This method will restrict insertion of duplicate Deal-Opportunity Grouping object records.
*Parameters:Deal-Opportunity Grouping List
*Requirement : 4557
*******************************/
	public static void restrictOpptyAssociationWithSameDeal( List<Opportunity_Group__c> newOpptyGroupList)
{
	Set<id> setopptyid = new Set<id>();
	Set<id> setdealid = new Set<id>();
	Set<String> setStringNew = new Set<String>();
	Set<String> setStringOld = new Set<String>();
	try
	{
		for (Opportunity_Group__c opptyGroupObj: newOpptyGroupList) 
		{
			setopptyid.add(opptyGroupObj.Opportunity__c);
			setdealid.add(opptyGroupObj.deal__c);
			if(setStringNew.contains(String.valueOf(opptyGroupObj.Opportunity__c) + String.valueOf(opptyGroupObj.deal__c)))
	opptyGroupObj.adderror(System.label.ExistingOpptyDealCombinationError);
			else
	setStringNew.add(String.valueOf(opptyGroupObj.Opportunity__c) + String.valueOf(opptyGroupObj.deal__c));
		}
		for(Opportunity_Group__c opptyGroupObj : [select Opportunity__c, deal__c 
			from Opportunity_Group__c 
			where Opportunity__c IN: setopptyid And deal__c in :  setdealid
			LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
		{
			setStringOld.add(String.valueOf(opptyGroupObj.Opportunity__c) + String.valueOf(opptyGroupObj.deal__c));
		}
		for (Opportunity_Group__c opptyGroupObj: newOpptyGroupList) 
		{
			if(setStringOld.contains(String.valueOf(opptyGroupObj.Opportunity__c) + String.valueOf(opptyGroupObj.deal__c)))
			{
	opptyGroupObj.adderror(System.label.ExistingOpptyDealCombinationError);
			}
		}
	}
	catch (Exception ex) 
	{
		ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.restrictOpptyAssociationWithSameDeal);
	}
}


	/*****************************
*Method Name: checkIfDealHasAlreadyMasterOppty
*Description: This method will check if the deal already has master opportunity associated.
*Parameters: Deal-Opportunity Grouping List
*Requirement : 4557
*******************************/
   public static void checkIfDealHasAlreadyMasterOppty( List<Opportunity_Group__c> newOpptyGroupList)
	{
		try{
			Map<ID, List<Opportunity_Group__c>> dealWithOpptyGroupMap = new Map<ID, List<Opportunity_Group__c>>();
			List<Opportunity_Group__c> opptyGroupList  = new List<Opportunity_Group__c>();
			Map<ID, String> dealIdWithRecordTypeMap = new Map<ID, String>();
			set<ID> newDealIdsSet = new set<ID>();
			set<ID> dealIdHavingMasterOpptySet;
			for (Opportunity_Group__c opptyGroupObj: newOpptyGroupList) 
			{
	newDealIdsSet.add(opptyGroupObj.Deal__c);  
			}
			for(Deal__c dealObj : [select id, RecordType.Name from Deal__c where id in :newDealIdsSet])
			{
	dealIdWithRecordTypeMap.put(dealObj.id, dealObj.RecordType.Name);
			}
			for (Opportunity_Group__c opptyGroupObj: newOpptyGroupList) 
			{
	if(opptyGroupObj.Opportunity_Relation__c.equalsignorecase(GlobalConstants.MASTER) &&
	dealIdWithRecordTypeMap.get(opptyGroupObj.Deal__c) != GlobalConstants.SIMPLE_DEAL)
	{
		if(dealWithOpptyGroupMap.containsKey(opptyGroupObj.Deal__c))
		{
			opptyGroupList = dealWithOpptyGroupMap.get(opptyGroupObj.Deal__c);
			opptyGroupList.add(opptyGroupObj);
			dealWithOpptyGroupMap.put(opptyGroupObj.Deal__c,opptyGroupList );
		}
		else
		{
			opptyGroupList.clear();
			opptyGroupList.add(opptyGroupObj);
			dealWithOpptyGroupMap.put(opptyGroupObj.Deal__c,opptyGroupList);
		}
	}   
			}
			if(dealWithOpptyGroupMap.keySet().size() > 0)
			{
	dealIdHavingMasterOpptySet = new set<ID>();
	for(id dealId : dealWithOpptyGroupMap.keySet())
	{
		if(dealWithOpptyGroupMap.get(dealId).size() >1)
			for(Integer i=1; i< dealWithOpptyGroupMap.get(dealId).size(); i++)
			dealWithOpptyGroupMap.get(dealId)[i].addError(System.label.MasterOpptyonDealError);
	}
	for(Opportunity_Group__c opptyGroupObj : [select Deal__c,deal__r.recordtype.name,Opportunity_Relation__c 
					from Opportunity_Group__c 
					where Deal__c IN: dealWithOpptyGroupMap.keySet() 
					and Opportunity_Relation__c =: GlobalConstants.MASTER 
					and deal__r.recordtype.name !=: GlobalConstants.SIMPLE_DEAL
					LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
	{
		dealIdHavingMasterOpptySet.add(opptyGroupObj.Deal__c);
	}
			}
			if(dealIdHavingMasterOpptySet.size() > 0)
			{
	for(id dealId : dealIdHavingMasterOpptySet)
	{
		dealWithOpptyGroupMap.get(dealId)[0].addError(System.label.MasterOpptyonDealError);
	}
			}	 
		}
		catch (Exception ex) 
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.checkIfDealHasAlreadyMasterOppty);
		}
	}
	/*****************************
*Method Name: checkIfDealHasMasterOpptyOnAssociationUpdate
*Description: This method will check if the deal already has master opportunity associated at the time of updating the association from subordinate to master.
*Parameters:Deal-Opportunity Grouping List, Deal-Opportunity Grouping List
*Requirement : 4557
*******************************/
	public static void checkIfDealHasMasterOpptyOnAssociationUpdate(Map<Id, Opportunity_Group__c> opptyGroupNewMap, Map<Id, Opportunity_Group__c> opptyGroupOldMap)
	{
		try{
			Map<Id,List<Opportunity_Group__c>> newDealIdWithOpptyGroupMap = new Map<Id,List<Opportunity_Group__c>>();
			List<Opportunity_Group__c>  opptyGroupList = new List<Opportunity_Group__c>();
			List<Opportunity_Group__c> opptyGroupErrorList= new List<Opportunity_Group__c>();
			Map<Id,Opportunity_Group__c> oldDealIdWithOpptyGroupMap;
			for (Opportunity_Group__c opptyGroupObj: opptyGroupNewMap.values()) 
			{
	if(opptyGroupObj.Opportunity_Relation__c.equalsignorecase(GlobalConstants.MASTER) && 
	opptyGroupOldMap.get(opptyGroupObj.id).Opportunity_Relation__c.equalsignorecase(GlobalConstants.SUBORDINATE)
	&&  opptyGroupObj.deal__r.recordtype.name != GlobalConstants.SIMPLE_DEAL)
	{
		if(newDealIdWithOpptyGroupMap.containsKey(opptyGroupObj.Deal__c))
		{
			opptyGroupList = newDealIdWithOpptyGroupMap.get(opptyGroupObj.Deal__c);
			opptyGroupList.add(opptyGroupObj);
			newDealIdWithOpptyGroupMap.put(opptyGroupObj.Deal__c,opptyGroupList );
		}
		else
		{
			opptyGroupList.clear();
			opptyGroupList.add(opptyGroupObj);
			newDealIdWithOpptyGroupMap.put(opptyGroupObj.Deal__c,opptyGroupList);
		}	
	}   
			}
			if(newDealIdWithOpptyGroupMap.Keyset().size() > 0)
			{
	 oldDealIdWithOpptyGroupMap = new Map<Id,Opportunity_Group__c>();
	for(Opportunity_Group__c opptyGroupObj : [select id,Opportunity__c,Deal__c,deal__r.recordtype.name,Opportunity_Relation__c 
				from Opportunity_Group__c 
				where Deal__c IN: newDealIdWithOpptyGroupMap.Keyset() 
				AND Opportunity_Relation__c =: GlobalConstants.MASTER AND
				deal__r.recordtype.name !=: GlobalConstants.SIMPLE_DEAL
				LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
	{
		oldDealIdWithOpptyGroupMap.put(opptyGroupObj.Deal__c,opptyGroupObj);
	}
			}
			for(id dealId :newDealIdWithOpptyGroupMap.Keyset())
			{
	opptyGroupErrorList.addAll(newDealIdWithOpptyGroupMap.get(dealId));
	if(oldDealIdWithOpptyGroupMap.size() <= 0)
		opptyGroupErrorList.remove(0);
			}  
			for(Opportunity_Group__c opptyGroupObj :opptyGroupErrorList)
	opptyGroupObj.addError(System.label.MasterOpptyonDealError);
		}
		catch (Exception ex) 
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.checkIfDealHasMasterOpptyOnAssociationUpdate);
		}
	}
	/*****************************
*Method Name: associationChangeFromMasterToSubordinate
*Description: This method will check the correct deal combination when the association is changed from master to subordinate.
*Parameters: Deal-Opportunity Grouping List, Deal-Opportunity Grouping List
*Requirement : 4557
******************************
	public static void associationChangeFromMasterToSubordinate(Map<Id, Opportunity_Group__c> opptyGroupNewMap, Map<Id, Opportunity_Group__c> opptyGroupOldMap)
	{
		try{
			Map<Id, List<Opportunity_Group__c>> opptyWithOpptyGroupMap = new Map<Id, List<Opportunity_Group__c>>();
			List<Opportunity_Group__c> opptyGroupList = new List<Opportunity_Group__c>();
			List<Opportunity_Group__c> opptyGroupErrorList= new List<Opportunity_Group__c>();
			Map<Id, Set<Id>> oldOpptyWithDealsMap;
			set<Id> oldDealIdSet;
			Map<Id, String> dealIdWithRecordTypeMap;
			String newDealType;
			String oldDealType;
			for (Opportunity_Group__c opptyGroupObj: opptyGroupNewMap.values()) 
			{
	if(opptyGroupObj.Opportunity_Relation__c.equalsignorecase(GlobalConstants.SUBORDINATE) && opptyGroupOldMap.get(opptyGroupObj.id).Opportunity_Relation__c.equalsignorecase(GlobalConstants.MASTER) )
	{
		if(opptyWithOpptyGroupMap.containsKey(opptyGroupObj.Opportunity__c))
		{
			opptyGroupList = opptyWithOpptyGroupMap.get(opptyGroupObj.Opportunity__c);
			opptyGroupList.add(opptyGroupObj);
			opptyWithOpptyGroupMap.put(opptyGroupObj.Opportunity__c,opptyGroupList );
		}
		else
		{
			opptyGroupList.clear();
			opptyGroupList.add(opptyGroupObj);
			opptyWithOpptyGroupMap.put(opptyGroupObj.Opportunity__c,opptyGroupList);
		}	
	}   
			}
			if(opptyWithOpptyGroupMap.keySet().size() > 0)
			{
	oldOpptyWithDealsMap =  new Map<Id, Set<Id>>();
	oldDealIdSet = new Set<Id>();
	dealIdWithRecordTypeMap = new Map<Id, String>();
	for(Opportunity_Group__c opptyGroupObj : [select id,Opportunity__c,Deal__c,deal__r.recordtype.name,Opportunity_Relation__c 
					from Opportunity_Group__c 
					where Opportunity__c IN: opptyWithOpptyGroupMap.keySet() AND 
					Opportunity_Relation__c =: GlobalConstants.MASTER AND
					deal__r.recordtype.name !=: GlobalConstants.SIMPLE_DEAL
					LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
	{
		if(oldOpptyWithDealsMap.containsKey(opptyGroupObj.Opportunity__c))
		{
			oldDealIdSet = oldOpptyWithDealsMap.get(opptyGroupObj.Opportunity__c);
			oldDealIdSet.add(opptyGroupObj.Deal__c);
			oldOpptyWithDealsMap.put(opptyGroupObj.Opportunity__c, oldDealIdSet);
		}
		else
		{
			oldDealIdSet.clear();
			oldDealIdSet.add(opptyGroupObj.Deal__c);
			oldOpptyWithDealsMap.put(opptyGroupObj.Opportunity__c, oldDealIdSet);
		}
		dealIdWithRecordTypeMap.put(opptyGroupObj.Deal__c, opptyGroupObj.deal__r.recordtype.name);
	}
			}
			for(id opptyId : oldOpptyWithDealsMap.keySet())
			{
	if(oldOpptyWithDealsMap.get(opptyId).size() == 2)
	{
		newDealType = dealIdWithRecordTypeMap.get(new List<Id> (oldOpptyWithDealsMap.get(opptyId)).get(0));
		oldDealType = dealIdWithRecordTypeMap.get(new List<Id> (oldOpptyWithDealsMap.get(opptyId)).get(1));
		if((newDealType.equalsignorecase(GlobalConstants.UPSELL_DEAL) && oldDealType.equalsignorecase (GlobalConstants.FRAMED_DEAL))
		|| (newDealType.equalsignorecase(GlobalConstants.FRAMED_DEAL) && oldDealType.equalsignorecase(GlobalConstants.UPSELL_DEAL)))
		{
		opptyGroupErrorList.addAll(opptyWithOpptyGroupMap.get(opptyId));
		}   
	}
			}
			for(Opportunity_Group__c opptyGroupObj :opptyGroupErrorList)
	opptyGroupObj.addError(System.label.InvalidDealCombinationError_MasterOppty);
		}
		catch (Exception ex) 
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.associationChangeFromMasterToSubordinate);
		}
	}
	/*****************************
*Method Name: beforeDeleteCheckOpptyRecordType
*Description: This method will check if the oppty is closed or not before deleting junction object record.
*Parameters: Deal-Opportunity Grouping List
*Requirement : 4943
*******************************/
   public static void beforeDeleteCheckOpptyRecordType(Map<ID, Opportunity_Group__c> opptyGroupOldMap)
	{
		Set<id> opptyGroupIdSet = new Set<id>();
		Set<id> opptyIdsSet = new Set<id>();
		Map<id,Opportunity> opptyMap = new Map<id,Opportunity>();
		try{
			for (Opportunity_Group__c opptyGroupObj: opptyGroupOldMap.Values()) 
			{
	opptyIdsSet.add(opptyGroupObj.Opportunity__c);	
			}
			for(Opportunity opptyObj : [select id, RecordType.Name, Phase_Status__c, StageName 
			from Opportunity where id in :opptyIdsSet
			LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	opptyMap.put(opptyObj.id, opptyObj);
			}
			for (Opportunity_Group__c opptyGroupObj: opptyGroupOldMap.Values()) 
			{
	if(//opptyMap.get(opptyGroupObj.Opportunity__c).RecordType.Name.equalsignorecase(GlobalConstants.READONLYDIRECT) ||
		//opptyMap.get(opptyGroupObj.Opportunity__c).RecordType.Name.equalsignorecase(GlobalConstants.READONLYINDIRECT) ||
		((opptyMap.get(opptyGroupObj.Opportunity__c).RecordType.Name.equalsignorecase(GlobalConstants.DIRECT_OPPTY) || 
		 opptyMap.get(opptyGroupObj.Opportunity__c).RecordType.Name.equalsignorecase(GlobalConstants.INDIRECT_OPPTY)) &&
		 ( 
		 
		 
		opptyMap.get(opptyGroupObj.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G2_APPROVAL)|| 
		 opptyMap.get(opptyGroupObj.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G3_APPROVAL)||
		 opptyMap.get(opptyGroupObj.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G4_APPROVAL)||
		 opptyMap.get(opptyGroupObj.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G5_APPROVAL)||
		 opptyMap.get(opptyGroupObj.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.SUBMITTED_FOR_G6_APPROVAL)||
		 opptyMap.get(opptyGroupObj.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.PENDING_WIN_LOSS_DECLARATION)
		 //opptyMap.get(opptyGroupObj.Opportunity__c).StageName.equalsignorecase(GlobalConstants.COMPLETED_OPPTY) ||
		 //opptyMap.get(opptyGroupObj.Opportunity__c).StageName.equalsignorecase(GlobalConstants.HANDOVER_OPPTY) ||
		 //opptyMap.get(opptyGroupObj.Opportunity__c).StageName.equalsignorecase(GlobalConstants.EXECUTE_OPPTY) || 
		 //opptyMap.get(opptyGroupObj.Opportunity__c).Phase_Status__c.equalsignorecase(GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON)
		 )))
	{
	   opptyGroupIdSet.add(opptyGroupObj.id);
	}   
			}
			for(Id opptyGrpId : opptyGroupIdSet)
	opptyGroupOldMap.get(opptyGrpId).addError(System.Label.ErrorOnDeletingDealOpptyGroupRecord);
		}   
		catch (Exception ex) 
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTY_TRIGGER_HELPER, GlobalConstants.beforeDeleteCheckOpptyRecordType);
		}
	}
}