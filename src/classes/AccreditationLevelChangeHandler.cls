/****************************************
* Class Name : AccreditationHandler
* Created Date: 1 Sep 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Handle the sequence of the Accreditation Trigger
* Test Class: 
*****************************************/
public without sharing class AccreditationLevelChangeHandler {
	/********************
*Method Name: afterUpdateOperation
*Parameter: newContractList, Old Accreditation Map
*Description: Used to handle after Update activities
*******************/
	public static void afterUpdateOperation(List<Accreditation_Level_Rule__c> newAccreditationList, Map<ID, Accreditation_Level_Rule__c> accreditationOldMap) {					   
		list<Accreditation_Level_Rule__c> updatedAccreditation = new list<Accreditation_Level_Rule__c>();			
		try{
			for(Accreditation_Level_Rule__c newAccreditation : newAccreditationList){
				if(newAccreditation.Accreditation_Level__c != accreditationOldMap.get(newAccreditation.id).Accreditation_Level__c){
					updatedAccreditation.add(newAccreditation);
				}				   
			}			   
			if(updatedAccreditation.size() > 0){
				AccreditationLevelChange.setAccrdRuleLevelRank(updatedAccreditation);
			}	
			
			System.debug(':::::afterUpdateOperation.new::::::: ');
			//AccreditationLevelChange.setAccrdRuleLevelRank(newAccreditationList);
		}
		catch(System.Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.AccreditationHandler , PRMGlobalConstants.afterUpdateOperation );}
	}  
	/********************
*Method Name: afterUpdateOperation
*Parameter: newContractList, Old Accreditation Map
*Description: Used to handle after Update activities
*******************/
	public static void afterInsertOperation(List<Accreditation_Level_Rule__c> newAccreditationList) {					   
		try{
				AccreditationLevelChange.setAccrdRuleLevelRank(newAccreditationList);
			  
		}
		catch(System.Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.AccreditationHandler , PRMGlobalConstants.afterUpdateOperation );}
	}	  

}