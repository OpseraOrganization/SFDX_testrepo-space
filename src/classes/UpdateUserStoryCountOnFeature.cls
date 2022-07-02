/****************************************
* Name : UpdateUserStoryCountOnFeature
* Author : Bidhu
* Description : Class to calculate total number of User stories related to a Feature.
*****************************************/

public class UpdateUserStoryCountOnFeature{
	
	//============//
	//Method Name :userStoryCountAfterInsert
	//Description: to calculate user story count after a new user story is created.
	//==============//
	public static void userStoryCountAfterInsert(List<User_Story__c> newUSList){
	
		List<Capability__c> updateFeatureList = new List<Capability__c>();			  
		Map<Id, Integer> featureAndUserStoryMap = new Map<Id, Integer>();
		Integer count;
		
		for(User_Story__c userStory : newUSList){
			if(userStory.Capability__c != null){
				if(featureAndUserStoryMap.containsKey(userStory.Capability__c)){
					count = featureAndUserStoryMap.get(userStory.Capability__c);
					featureAndUserStoryMap.put(userStory.Capability__c, count + 1);
				} else {
					featureAndUserStoryMap.put(userStory.Capability__c, 1);
				}
			}
		}
		
		for(Capability__c featureObj : [Select Id,Total_User_Stories__c from Capability__c where Id IN : featureAndUserStoryMap.keyset()]){
			if(featureObj.Total_User_Stories__c == null){
				featureObj.Total_User_Stories__c = 0;
			} 
			featureObj.Total_User_Stories__c = featureObj.Total_User_Stories__c + featureAndUserStoryMap.get(featureObj.Id);
			updateFeatureList.add(featureObj);
		}
		
		if(!updateFeatureList.isEmpty()){
			try{
				update updateFeatureList;
			} catch (Exception ex){
				system.debug('error'+ ex);
			}
		}
		
	}
	
	
	//============//
	//Method Name : userStoryCountAfterUpdate
	//Description: to calculate User story count after a user story is updated to new feature.
	//==============//
	public static void userStoryCountAfterUpdate(Map<Id, User_Story__c> oldMap, Map<Id, User_Story__c> newMap){
	  
		//Map<Id, Integer> oldFeatureAndUserStoryMap = new Map<Id, Integer>();
		//Map<Id, Integer> newFeatureAndUserStoryMap = new Map<Id, Integer>();
		Set<Id> newFeatureIdset = new Set<Id>();
		Set<Id> oldFeatureIdset = new Set<Id>();
		Map<Id, Integer> countMap = new Map<Id, Integer>();
		List<Capability__c> newReqList = new List<Capability__c>(); 
		List<Capability__c> oldReqList = new List<Capability__c>(); 
		//Integer oldCount;
		//Integer newCount;
		Integer count;
		
		for(User_Story__c userStory : oldMap.values()){
			if(userStory.Capability__c != null){
				oldFeatureIdset.add(userStory.Capability__c);
				if(countMap.containsKey(userStory.Capability__c)){
					count = countMap.get(userStory.Capability__c);
					countMap.put(userStory.Capability__c, count + 1);
				} else {
					countMap.put(userStory.Capability__c, 1);
				}
			}
		}
		
		for(User_Story__c userStory : newMap.values()){
			if(userStory.Capability__c != null){
				newFeatureIdset.add(userStory.Capability__c);
				if(countMap.containsKey(userStory.Capability__c)){
					count = countMap.get(userStory.Capability__c);
					countMap.put(userStory.Capability__c, count + 1);
				} else {
					countMap.put(userStory.Capability__c, 1);
				}
			}
		}
		
		for(Capability__c feature : [Select Id, Total_User_Stories__c from Capability__c where Id IN : newFeatureIdset]){
			if(feature.Total_User_Stories__c == null){
				feature.Total_User_Stories__c = 0;
			}
			feature.Total_User_Stories__c = feature.Total_User_Stories__c + countMap.get(feature.Id);
			newReqList.add(feature);
		}
		
		for(Capability__c feature : [Select Id, Total_User_Stories__c from Capability__c where Id IN : oldFeatureIdset]){
			if(feature.Total_User_Stories__c == null){
				feature.Total_User_Stories__c = 0;
			}
			feature.Total_User_Stories__c = feature.Total_User_Stories__c - countMap.get(feature.Id);
			oldReqList.add(feature);
		}
		
		if(!newReqList.isEmpty()){		
			try{
				update newReqList;
			} catch (Exception ex){
				system.debug('error'+ ex);
			}
		}
		
		
		if(!oldReqList.isEmpty()){		
			try{
				update oldReqList;
			} catch (Exception ex){
				system.debug('error'+ ex);
			}
		}
	}
	
	
	//============//
	//Method Name : userStoryCountAfterDelete
	//Description: to calculate User story count after a user story is deleted.
	//==============//
	public static void userStoryCountAfterDelete(Map<Id,User_Story__c> oldMap){
	
		List<Capability__c> updateFeatureList = new List<Capability__c>(); 
		Set<Id> featureIdsSet = new Set<Id>();
		Map<Id,Integer> countMap = new Map<Id,Integer>();
		Integer count;
		
		for(User_Story__c userStory : oldMap.values()){
			if(userStory.Capability__c != null){
				featureIdsSet.add(userStory.Capability__c);
				
				if(countMap.containsKey(userStory.Capability__c)){
					count = countMap.get(userStory.Capability__c);
					countMap.put(userStory.Capability__c, count+1);
				} else {
					countMap.put(userStory.Capability__c, 1);
				} 
			}
		}
		
		if(!featureIdsSet.isEmpty()){
			for(Capability__c featureObj : [Select Id,Total_User_Stories__c from Capability__c where Id IN : featureIdsSet]){
				featureObj.Total_User_Stories__c = featureObj.Total_User_Stories__c - countMap.get(featureObj.Id);
				updateFeatureList.add(featureObj);
			}
		}
			

		if(!updateFeatureList.isEmpty()){
			try{
				update updateFeatureList;
			} catch (Exception ex){
				system.debug('error'+ ex);
			}
		}
	}
}