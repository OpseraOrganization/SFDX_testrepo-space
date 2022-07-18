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
	 public static void beforeUpdateOperation(List<Account> accountList,Map<ID, Account> accOldMap,boolean updateAcStatus){   
	   List<Account> AcList = new List<Account>();		 
	   if(updateAcStatus==true){	  
		 for(Account acc:accountList){
			 if(acc.NokiaCPQ_Applicable_Price_Lists__c!=null && accOldMap.get(acc.Id).NokiaCPQ_Applicable_Price_Lists__c != acc.NokiaCPQ_Applicable_Price_Lists__c){				
				  AcList.add(acc);				
				 }
			 }
			 if(!AcList.isEmpty()){
			 AccountTriggerHelperCOE.ValidatePricelist(AcList);
			 }
		 }
		 else{
		  AccountTriggerHelperCOE.ValidatePricelist(accountList);
		 }
	 }
}