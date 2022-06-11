/***********************************
* Name : UserStory
* Author : Bidhu
*************************************/

trigger UserStory on User_Story__c (after insert, after Update, after delete) {

	if(Trigger.isAfter){
		if(Trigger.isInsert){
			UpdateUserStoryCountOnFeature.userStoryCountAfterInsert(trigger.New);
		}

		if(Trigger.isUpdate){
			UpdateUserStoryCountOnFeature.userStoryCountAfterUpdate(trigger.oldMap, trigger.newMap);
		}
		
		if(Trigger.isDelete){
			UpdateUserStoryCountOnFeature.userStoryCountAfterDelete(trigger.oldMap);
		}

	}
	
}