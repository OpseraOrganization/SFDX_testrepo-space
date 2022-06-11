/****************************************
* Name : UpdateRequirementCountOnUserStory
* Author : Bidhu
* Description : Class to calculate total number of User stories related to a Feature.
*****************************************/

public class UpdateRequirementCountOnUserStory{
	
	//============//
	//Method Name :requirementCountAfterInsert
	//Description: to calculate requirement count after a new requirement is created.
	//==============//
	public static void requirementCountAfterInsert(List<Request__c> newReqList){
	
		Map<Id, Integer> userStoryAndRequirementMap = new Map<Id, Integer>();
		List<User_Story__c> updateUSList = new List<User_Story__c>(); 
		Integer count;
		
		for(Request__c requirement : newReqList){
			if(requirement.User_Story__c != null){
				if(userStoryAndRequirementMap.containsKey(requirement.User_Story__c)){
					count = userStoryAndRequirementMap.get(requirement.User_Story__c);
					userStoryAndRequirementMap.put(requirement.User_Story__c, count + 1);
				} else {
					userStoryAndRequirementMap.put(requirement.User_Story__c, 1);
				}
			}
		}
		

		for(User_Story__c userStoryObj : [Select Id, Total_Requirements__c from User_Story__c where Id IN : userStoryAndRequirementMap.keyset()]){
			if(userStoryObj.Total_Requirements__c == null){
				userStoryObj.Total_Requirements__c = 0;
			} 
			userStoryObj.Total_Requirements__c = userStoryObj.Total_Requirements__c + userStoryAndRequirementMap.get(userStoryObj.Id);
			updateUSList.add(userStoryObj);
		}
		
		if(!updateUSList.isEmpty()){
			try{
				update updateUSList;
			} catch (Exception ex){
				system.debug('error'+ ex);
			}
		}
		
	}
	
	//============//
	//Method Name : userStoryCountAfterUpdate
	//Description: to calculate requirement count after a requirement is updated to User Story.
	//==============//
	public static void requirementCountAfterUpdate(Map<Id, Request__c> oldMap, Map<Id, Request__c> newMap){

		List<User_Story__c> newUSList = new List<User_Story__c>(); 
		List<User_Story__c> oldUsList = new List<User_Story__c>();
		Set<Id> newUSIdset = new Set<Id>(); 
		Set<Id> oldUSIdset = new Set<Id>();		 
		Map<Id,Integer>countMap = new Map<Id,Integer>();
		Integer count;
		
		for(Request__c requirement : oldMap.values()){
			if(requirement.User_Story__c != null){
				oldUSIdset.add(requirement.User_Story__c);
				if(countMap.containsKey(requirement.User_Story__c)){
					count = countMap.get(requirement.User_Story__c);
					countMap.put(requirement.User_Story__c, count + 1);
				} else {
					countMap.put(requirement.User_Story__c, 1);
				}
			}
		}
		system.debug('oldUSAndReqMap'+countMap);
		for(Request__c requirement: newMap.values()){
			if(requirement.User_Story__c != null){
				newUSIdset.add(requirement.User_Story__c);
				if(countMap.containsKey(requirement.User_Story__c)){
					count = countMap.get(requirement.User_Story__c);
					countMap.put(requirement.User_Story__c, count + 1);
				} else {
					countMap.put(requirement.User_Story__c, 1);
				}
			}
		}
		system.debug('newUSAndreqMap'+countMap);
		for(User_Story__c userStoryObj :  [Select Id, Total_Requirements__c from User_Story__c where Id IN : newUSIdset]){
			if(userStoryObj.Total_Requirements__c == null){
				userStoryObj.Total_Requirements__c = 0;
			}
			if(countMap.get(userStoryObj.Id) != null){
				userStoryObj.Total_Requirements__c = userStoryObj.Total_Requirements__c + countMap.get(userStoryObj.Id);
			}
			newUSList.add(userStoryObj);
		}
		system.debug('newUSList'+newUSList);
		for(User_Story__c userStoryObj :  [Select Id, Total_Requirements__c from User_Story__c where Id IN : oldUSIdset]){
			if(userStoryObj.Total_Requirements__c == null){
				userStoryObj.Total_Requirements__c = 0;
			}
			if(countMap.get(userStoryObj.Id) != null){
				userStoryObj.Total_Requirements__c = userStoryObj.Total_Requirements__c - countMap.get(userStoryObj.Id);
			}
			oldUsList.add(userStoryObj);
		}
		system.debug('oldUsList'+oldUsList);
		
		if(!newUSList.isEmpty()){		
			try{
				update newUSList;
			} catch (Exception ex){
				system.debug('error'+ ex);
			}
		}
		
		
		if(!oldUsList.isEmpty()){		
			try{
				update oldUsList;
			} catch (Exception ex){
				system.debug('error'+ ex);
			}
		}
	}
	
	
	//============//
	//Method Name : requirementCountAfterDelete
	//Description: to calculate requirement count after a requirement is deleted.
	//==============//
	public static void requirementCountAfterDelete(Map<Id,Request__c> oldMap){
	
		Set<Id> userStoryIdsSet = new Set<Id>();
		Map<Id,Integer> countMap = new Map<Id,Integer>();
		Integer count;
		List<User_Story__c> updateUSList = new List<User_Story__c>(); 
		
		for(Request__c requirement : oldMap.values()){
			if(requirement.User_Story__c != null){
				userStoryIdsSet.add(requirement.User_Story__c);
				
				if(countMap.containsKey(requirement.User_Story__c)){
					count = countMap.get(requirement.User_Story__c);
					countMap.put(requirement.User_Story__c, count+1);
				} else {
					countMap.put(requirement.User_Story__c, 1);
				} 
			}
		}

		if(!userStoryIdsSet.isEmpty()){
			for(User_Story__c userStoryObj : [Select Id, Total_Requirements__c from User_Story__c where Id IN : userStoryIdsSet]){
				if(userStoryObj.Total_Requirements__c != null){
					userStoryObj.Total_Requirements__c = userStoryObj.Total_Requirements__c - countMap.get(userStoryObj.Id);
					updateUSList.add(userStoryObj);
				}
			}
			
			if(!updateUSList.isEmpty()){
				try{
					update updateUSList;
				} catch (Exception ex){
					system.debug('error'+ ex);
				}
			}
		}
	}

}