/****************************************
* Class Name : AccreditationHelper
* Created Date: June 2018
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Accreditation Helper

* Test Class: 
*****************************************/
public without sharing class AccreditationHelper {
	
	/********************
*Method Name: UpdatedAccountfforACcreditation level update
*Parameter: 
*Description: this method will update Evalustion flag to true when Acrreditation meet Lab feild is updated
*******************/
	public static void updateAccreditation(list<Accreditation__c> newAccreditationList){
		try{			
			list<Accreditation__c> accredToUpdate = new list<Accreditation__c>();							
			for(Accreditation__c Accred : [select id, name, Evaluated_Accreditation__c from Accreditation__c 
										   where id in: newAccreditationList 
										   Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){			 
				Accred.Evaluated_Accreditation__c = true;
				accredToUpdate.add(Accred);
			}
			Database.update(accredToUpdate);		
		}catch(Exception e){ExceptionHandler.addException(e, PRMGlobalConstants.AccreditationHelper , PRMGlobalConstants.updateAccreditation);}
	}
}