/******************************************************************************************************
Name : custom_LookUpController
Created Date: 7 JULY 2018
Created by: Accenture
Description : To get records from user object and  NF_RoleCode__c custom setting   
*********************************************************************************************************/
public class custom_LookUpController {
   
	/***************************************************************
*Method Name: fetchLookUpValues
*Parameter: ObjectName
*Description: to get records from NF_RoleCode__c custom setting
****************************************************************/
	@AuraEnabled
	public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName,string selectedTerritory,string fetchASCheck,boolean Adduser) {
		//system.debug('searchKeyWord++>'+searchKeyWord);
		String searchKey = '%' +searchKeyWord+ '%';
		Map<string,string> orgHierarchylevelMap = new Map<string,string>();
		Set<sobject> myset = new Set<sobject>();
		List<NF_RoleCode__c> listofroleCodes= new List<NF_RoleCode__c>(); 
		
		for(Territory2 territoryRecord : [Select Id,Name,Hierarchy_ID__c,Hierarchy_Level__c  from Territory2 Where Name =: selectedTerritory])
		{
			orgHierarchylevelMap.put(territoryRecord.Name,territoryRecord.Hierarchy_Level__c);  
		}
		string Hierarclevel=orgHierarchylevelMap.get(selectedTerritory);
		
		
				String sQuery =  'select id, Name,Role_name__c,BG_Attribute__c ,Hierarchy_Level__c ,A_S__c from  NF_RoleCode__c where Role_name__c LIKE: searchKey ';
		 if(fetchASCheck==GlobalConstants.IWA_Check)
		 {
			sQuery +=' AND A_S__c=true  ';
		 }
		if(fetchASCheck==GlobalConstants.Non_IWA_Check) 
		{
			sQuery +=' AND A_S__c=false  ';
		}

		 if(Adduser==true)
		 {
			 sQuery +=' AND Hierarchy_Level__c=:Hierarclevel  '; 
		 }
		
		 sQuery +=' order by createdDate DESC  '; 
		
		listofroleCodes = Database.query(sQuery);
	   
		return listofroleCodes;
	}
	
	/********************************************************
*Method Name: fetchUserValues
*Parameter: ObjectName
*Description: to get records from User Object
*********************************************************/
	@AuraEnabled
	public static List < sObject > fetchUserValues(String searchKeyWord, String ObjectName,string Org_NSA) {
		String searchKey = '%' +searchKeyWord + '%';
		List < sObject > returnList = new List < sObject > ();
		boolean NSAvalue=true;
		string As_val=null;
		List<String> Pack4ProfilesCS = new List<String>();
		for(Pack4_User_Profiles__c p4Profiles : Pack4_User_Profiles__c.getall().values()){
		 
			Pack4ProfilesCS.add(p4Profiles.name);
		  
		}
		String sQuery =  'select id,Name,IsActive,Nokia_ID__c,Email,NSA_Compliant__c ,Profile.Name,FirstName,LastName from ' +ObjectName + ' where  (Name LIKE: searchKey OR LastName LIKE: searchKey OR FirstName LIKE: searchKey) AND Profile.Name IN:Pack4ProfilesCS';
		//sQuery +=' AND Nokia_ID__c !=As_val ';
		system.debug('@@'+sQuery);
		if(Org_NSA.contains('NSA'))
			sQuery +=' AND NSA_Compliant__c =:NSAvalue order by createdDate DESC limit 10 ';
		else
			sQuery +=' order by createdDate DESC limit 10 ';
	   
		
		List < sObject > lstOfRecords = Database.query(sQuery);
		system.debug('@@@'+sQuery);
		for (sObject obj: lstOfRecords) {
			returnList.add(obj);
		}system.debug('@@@'+sQuery);
		return returnList;
	}
}