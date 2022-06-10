/****************************************
 * Class Name : AdditionalResourceHandler
 * Created Date: 13 December 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description :
 *****************************************/
public without sharing class AdditionalResourceHandler{
/*******************************
*Method name: updateAccount
*Description: This Method will update Account on Additional Resource
*Parameter: 
*******************************/ 
	public static void updateAccount(List<Additional_Resource_Request__c> addResList){
		
		AdditionalResourceHelper.additionalResourceAccount(addResList);
	}
}