/*******************************
Class Name: CQ_customLookUpController
Created by: Accenture
Created Date: 22 April 2019
Last modified by: Accenture
Last modified date:  
Description: Custom Lookup controller used in Lightning component
*******************************/
public class CQ_customLookUpController {
	@AuraEnabled
	public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, string AccId) {
		//system.debug('ObjectName-->' + ObjectName);
		List < sObject > returnList = new List < sObject > ();
		if(ObjectName=='Contact'){
			List<List<sobject>> sobjList = [FIND :searchKeyWord IN NAME Fields RETURNING Contact(Id, Name, Email WHERE AccountId =: AccId AND CH_ContactType__c = 'Customer' AND Contact_Status__c = 'Active') LIMIT 5];
			List<sObject> conList = sobjList[0];
			for (sObject obj: conList) {
	returnList.add(obj);
			}
		}
		else
		{
			String searchKey = '%'+ searchKeyWord + '%';
			//String profilename = '%Customer%';
			// Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
			String sQuery =  'select Id, Name, Email from ' +ObjectName + ' where Name LIKE: searchKey AND (IsActive=True AND Active_Nokia_Employee__c=True ) limit 5'; 		
			List < sObject > lstOfRecords = Database.query(sQuery);
	for (sObject obj: lstOfRecords) {
	returnList.add(obj);
			}
		}
		return returnList;
	}
}