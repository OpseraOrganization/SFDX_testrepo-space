/*
 *  @author Showket Bhat
 *  Revision History:24 Augest 2017
 */   
/****************************************
 * Class Name : ReusableCustomLookUpController
 * Created Date: 24 Augest 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : Account Lookup for Indirect Opportunity
 * Test Class: reusableCustomLookUpController_Test
 *****************************************/
public class ReusableCustomLookUpController {
	
	  /********************
	*Method Name: fetchLookUpValues
	*Parameter: searchKeyWord , ObjectName
	*Description:After discussion, removing its generic nature.. this will be spacific to Account Lookup for Indirect Opportunity (28-Aug-2017)
	*******************/
	@AuraEnabled
	public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
		
		List < sObject > returnList = new List < sObject > ();
		
		try{
			//String searchKey = GlobalConstants.WILDCARD_SEARCH + searchKeyWord + GlobalConstants.WILDCARD_SEARCH;
			String searchKey = searchKeyWord + GlobalConstants.WILDCARD_SEARCH; //SF Ticket#- 01987084/01936003	
			
			// Dynamic SOQL Query For Fetch Record List with LIMIT 5   
			String sQuery =  GlobalConstants.SELECT_ID_NAME_ACCNO + ObjectName + GlobalConstants.CUSTOM_LOOKUP_QUERY;		   
			
			List < sObject > lstOfRecords = Database.query(sQuery);
			
			for (sObject obj: lstOfRecords) {
	returnList.add(obj);
			}
		 
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex, ReusableCustomLookUpController.class.getName(), GlobalConstants.METHOD_UPDATEOFFERSSOONUNDELETE);
		}
		
		return returnList;
	}
}