/*************************************************************************************************
 * Class Name : CH_lookUpController
 * Created Date: 24 April 2019
 * Created By : TCS
 * Descsription: Server Side Controller for SelectLookup for WorkGroup 
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
*************************************************************************************************/
public class CH_lookUpController {
	
	 /*****************************************************
	* Method Name : fetchWorkGroup
	* Created Date: 24 April 2019
	* Created By : Ganga Prasuna
	* Description:  Getting the selected records from the WorkGroup object
	* Parameter: NA
	* Return: selected records
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/  
	@AuraEnabled
	public static List < CH_Workgroup__c > fetchWorkGroup(String searchKeyWord, String productId) {
		String searchKey = '%' + searchKeyWord + '%';
		System.debug('***********searchkey: ' + searchKey);
		String caseProductId = productId;
		System.debug('***********productId: ' + productId);
		List < CH_Workgroup__c > returnList = new List < CH_Workgroup__c > ();
		String currentUserId = Userinfo.getUserId();
		List <User> testUsers = [Select id from User Where id =: currentUserId ];
		System.debug('***********testUsers' + testUsers);
		List <CH_Workgroup_Member__c> testMembers = [Select CH_Name__c,CH_UserId__c,CH_User__c FROM CH_Workgroup_Member__c where CH_User__c In: testUsers];
		System.debug('***********testMembers' + testMembers);
		List < CH_Workgroup__c > testLstOfWorkgroup = [select id,Name,(Select CH_Name__c,CH_UserId__c,CH_User__c FROM CH_Workgroup_Members__r where CH_UserId__c =: currentUserId) from CH_Workgroup__c ];
		System.debug('***********testLstOfWorkgroups' + testLstOfWorkgroup);
		List <CH_Workgroup_Rule__c> testLstofProductRelatedWorkgroups = [select CH_Workgroup__c from CH_Workgroup_Rule__c  where CH_Product__c =: productId];
		System.debug('***********testLstofProductRelatedWorkgroups' + testLstofProductRelatedWorkgroups);
		//List < CH_Workgroup__c > lstOfWorkgroup = [select id,Name,(Select CH_Name__c,CH_UserId__c,CH_User__c FROM CH_Workgroup_Members__r where CH_User__c In (Select id from User Where id =: currentUserId)) from CH_Workgroup__c where Name like: searchKey AND RecordType.DeveloperName='CH_KB_Workgroup ' limit 5];
		//List < CH_Workgroup__c > lstOfWorkgroup = [select id, name from CH_Workgroup__c where id In (select CH_Workgroup__c FROM CH_Workgroup_Member__c where CH_User__c =:currentUserId) AND Name like: searchkey AND RecordType.DeveloperName='CH_KB_Workgroup' limit 5];
		List < CH_Workgroup__c > lstOfWorkgroup = [select id, name from CH_Workgroup__c where id In (select CH_Workgroup__c FROM CH_Workgroup_Member__c where CH_User__c =:currentUserId) AND id In (select CH_Workgroup__c from CH_Workgroup_Rule__c  where CH_Product__c =: productId) AND Name like: searchkey AND RecordType.DeveloperName='CH_KB_Workgroup' AND CH_Status__c = 'Active' limit 5];
		//List < CH_Workgroup__c > lstOfWorkgroup = [select id, name, (select Workgroup__c from CH_Workgroup_Rule__c  where CH_Product__c =: productId) from CH_Workgroup__c where id in (select Workgroup__c FROM CH_Workgroup_Member__r where CH_User__c =:currentUserId) AND Name like: searchkey AND RecordType.DeveloperName='CH_KB_Workgroup' limit 5];

		system.debug('lstOfWorkgroup' +lstOfWorkgroup); 
		//for(CH_Workgroup__c  wc : lstOfWorkgroup ) {  
			
		//	for(CH_Workgroup_Member__c wm: wc.CH_Workgroup_Members__r ){
		//		if(UserInfo.getUserId() == wm.CH_User__c){
		//			returnList.add(wc);
		//	  }
				
		//	}
			
		//	system.debug('returnList' +returnList);
		//}
	   //return returnList;
	   return lstOfWorkgroup;
	}
   
	
}