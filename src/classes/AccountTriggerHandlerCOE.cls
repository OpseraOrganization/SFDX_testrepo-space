/****************************************
 * Class Name : AccountTriggerHandler
 * Created Date: 27 December 2016
 * Created By : Nokia
 * Last Modified by: Nokia
 * Last Modified Date: 13 feb 2021
 * Description : Handle the sequence of the AccountTrigger
 * Test Class: 
 *****************************************/
public with sharing class AccountTriggerHandlerCOE{	
	 public static void beforeUpdateOperation(List<Account> accountList){
		 AccountTriggerHelperCOE.ValidatePricelist(accountList);
	 }
}