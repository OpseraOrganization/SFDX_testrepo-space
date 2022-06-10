/****************************************
* Name : HWS_DispayCCM
* Author : TCS
* @description : This class is for display service contract owners
* Userstories: NOKIASC-31238/31239
* Test Class : HWS_DisplayCCM_Test
****************************************/

 

public with sharing class HWS_DispayCCM {
	
	/****************************************
	* Name : getUserInfo
	* @description : To fetch Service Contract owner List
	* @param: Case Id
	* @return : List of Service Contract owner List
	* written on 26th September 2020
	* By Sai Lakshman Kanukollu
	*****************************************/
	
	@auraEnabled
	public static List<user> getUserInfo(Id caseId){
		Set<Id> ownerIds = new Set<Id>();
		Set<Id> DataLoaderUserIds = new Set<Id>();
		
		List<User> DataLoaderUsersList = [SELECT Id FROM User WHERE Profile.Name = 'Data Loader Profile'];
		for(User user: DataLoaderUsersList){
			DataLoaderUserIds.add(user.Id);
		}
		
		List<user> ownerList = new List<user>();
		Case cse = [SELECT Id, AccountId FROM Case WHERE Id=: caseId ];
		if(cse != null){
			//adding WITH SECURITY_ENFORCED for PMD error- Validate CRUD permission before SOQL/DML operation- NOKIASC-32425
			List<ServiceContract> serCntract = [SELECT Id, OwnerId FROM ServiceContract WHERE AccountId =:cse.AccountId AND OwnerId!=:Label.CH_IPaas_User_Id AND (Status='Active' OR EndDate=LAST_N_Months:6) AND RecordType.DeveloperName =:'CH_ServiceContract' AND OwnerId NOT IN:DataLoaderUserIds];
			for(ServiceContract serRec: serCntract){
				ownerIds.add(serRec.OwnerId);
			}
		}
	   
		if(ownerIds.size()>0){
			//adding WITH SECURITY_ENFORCED for PMD error -Validate CRUD permission before SOQL/DML operation- NOKIASC-32425
			 ownerList = [SELECT Id,FirstName,LastName,Email,MobilePhone,Phone FROM User WHERE Id=:ownerIds];
			return ownerList;
		}
	  
		return ownerList;
	}
}