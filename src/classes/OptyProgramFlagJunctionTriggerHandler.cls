/***********************************
Class Name: OptyProgramFlagJunctionTriggerHandler
Author: Accenture
Reason: Sales Process : This is to lock relatedList of opportunity, this is handler class called from trigger.
Created Date: Feb / 2017 
******************************************/
public with sharing class  OptyProgramFlagJunctionTriggerHandler {
	
	
	/***********************
	* Method Name: beforeInsertOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of OptyProgramFlagJunction__c
	************************/		
	public static void beforeInsertOperation(List<OptyProgramFlagJunction__c> opfjList){
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		system.debug('*******************'+Profiles_Able_To_Modify_Program_Flags__c.getInstance(profileName));
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Profiles_Able_To_Modify_Program_Flags__c.getInstance(profileName) == null){ 
			OptyProgramFlagJunctionTriggerHelper.retrictOptyProgramFlagJunction(opfjList);
		}
		//Zeen Add
		Set<Id> opporIDs = new Set<ID>();
		for(OptyProgramFlagJunction__c opfj: opfjList){
			if(opfj.Opportunity__c != null){
				opporIDs.add(opfj.Opportunity__c);
			}
		}
	   map<id,set<id>> existoppoid2pfid = new Map<id,set<id>>();
	   set<id> pfids = new Set<id>();
	   List<OptyProgramFlagJunction__c> existopfj = [select id,CurrencyIsoCode,Program_Flag__c,Opportunity__c,opportunity__r.CurrencyIsoCode from OptyProgramFlagJunction__c where Opportunity__c in:opporIDs ];
	   
		for(OptyProgramFlagJunction__c opfj:existopfj){
		   if(existoppoid2pfid.containsKey(opfj.Opportunity__c)){
			  pfids = existoppoid2pfid.get(opfj.Opportunity__c);
			  pfids.add(opfj.Program_Flag__c);
			  existoppoid2pfid.put(opfj.Opportunity__c,pfids);
		   }else{
			  pfids = new Set<id>();
			  pfids.add(opfj.Program_Flag__c);
			  existoppoid2pfid.put(opfj.Opportunity__c,pfids);
		   } 
	   } 
		for(OptyProgramFlagJunction__c opfj :opfjList){
			
			if(opfj.Opportunity__c != null){ 
				opfj.CurrencyIsoCode = System.label.EUR; 
			}
			if(existoppoid2pfid.containsKey(opfj.Opportunity__c)){
				if(existoppoid2pfid.get(opfj.Opportunity__c).contains(opfj.Program_Flag__c)){
					
					opfj.addError('You can not assign repeat Program Flag!');
				}
			} 
		}
		/*if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			//Sales Process, Requirement 1454
			OptyProgramFlagJunctionTriggerHelper.copyOpptyProgramFlagToOif(opfjList);
			system.debug('copyOpptyProgramFlagToOif Before Insert');
		}*/
				 
	}

	/***********************
	* Method Name: beforeInsertOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of OptyProgramFlagJunction__c
	************************/		
	public static void afterInsertOperation(List<OptyProgramFlagJunction__c> opfjList){
		//if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			//Sales Process, Requirement 1454
			system.debug('copyOpptyProgramFlagToOif After Insert');
			OptyProgramFlagJunctionTriggerHelper.copyOpptyProgramFlagToOif(opfjList, true);
			
		//}
	}
	
	/***********************
	* Method Name: beforeUpdateOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of OptyProgramFlagJunction__c
	************************/		
	public static void beforeUpdateOperation(List<OptyProgramFlagJunction__c> opfjList){ 
		 String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		system.debug('*******************'+Profiles_Able_To_Modify_Program_Flags__c.getInstance(profileName));
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Profiles_Able_To_Modify_Program_Flags__c.getInstance(profileName) == null){
			OptyProgramFlagJunctionTriggerHelper.retrictOptyProgramFlagJunction(opfjList);
		}
	}
	
	public static void afterUpdateOperation(Map<ID,OptyProgramFlagJunction__c> newopfjList,Map<ID,OptyProgramFlagJunction__c> oldopfjList){
		system.debug('Begin Update');
		List<OptyProgramFlagJunction__c> finalOIFProgramFlagJunctionRecListtoDelete = new List<OptyProgramFlagJunction__c>();
		List<OptyProgramFlagJunction__c> finalOIFProgramFlagJunctionRecListtoCreate = new List<OptyProgramFlagJunction__c>();
		OptyProgramFlagJunction__c opfj = new OptyProgramFlagJunction__c();
		for(ID i : newopfjList.keySet()){
					opfj = newopfjList.get(i);
					if(opfj.Program_Flag__c == Null){
						system.debug(oldopfjList.get(opfj.Id));
						finalOIFProgramFlagJunctionRecListtoDelete.add(oldopfjList.get(opfj.Id));
					}else{
						 system.debug(oldopfjList.get(opfj.Id));
						finalOIFProgramFlagJunctionRecListtoDelete.add(oldopfjList.get(opfj.Id));
						 system.debug(newopfjList.get(opfj.Id));
						finalOIFProgramFlagJunctionRecListtoCreate.add(newopfjList.get(opfj.Id));
					}
		}
	   
		OptyProgramFlagJunctionTriggerHelper.copyOpptyProgramFlagToOif(finalOIFProgramFlagJunctionRecListtoDelete, false);
		OptyProgramFlagJunctionTriggerHelper.copyOpptyProgramFlagToOif(finalOIFProgramFlagJunctionRecListtoCreate, true);
	}
	
	
	/***********************
	* Method Name: beforeDeleteOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of OptyProgramFlagJunction__c
	************************/		
	public static void beforeDeleteOperation(List<OptyProgramFlagJunction__c> opfjList){ 
		String profileName = [Select Id,Name from Profile where Id =: userinfo.getProfileId()].Name;
		system.debug('ProfileName'+profileName);
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Profiles_Able_To_Modify_Program_Flags__c.getInstance(profileName) == null){ 
			OptyProgramFlagJunctionTriggerHelper.retrictOptyProgramFlagJunction(opfjList);
		}
		//if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			//Sales Process, Requirement 1454
			system.debug('copyOpptyProgramFlagToOif before Delete');
			OptyProgramFlagJunctionTriggerHelper.copyOpptyProgramFlagToOif(opfjList, false);
			
		//}
		
	}

	/***********************
	* Method Name: afterDeleteOperation
	* Description: Sales Process : lock relatedList of opportunity before update
	* Parameters: List of OptyProgramFlagJunction__c
	************************/		
	/*public static void afterDeleteOperation(List<OptyProgramFlagJunction__c> opfjList){
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			//Sales Process, Requirement 1454
			system.debug('copyOpptyProgramFlagToOif before Delete');
			OptyProgramFlagJunctionTriggerHelper.copyOpptyProgramFlagToOif(opfjList);
			
		}
	} */
}