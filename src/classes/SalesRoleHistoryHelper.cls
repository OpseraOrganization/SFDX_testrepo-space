/******************************************************************************************************
Name : SalesRoleHistoryHelper
Created Date: 18 JUNE 2018
Created by: Accenture
Description : To create Sales Role Audit record on Sales Role History insertion	
*********************************************************************************************************/
public without sharing class SalesRoleHistoryHelper {
	/********************
*Method Name: createSalesAuditRecord
*Parameter: salesRoleHistoryList
*Description: For creating Sales Role Audit record'
*******************/
	public static void createSalesAuditRecord(List<Sales_Role_History__c> salesRoleHistoryList){
		
		List <Sales_Role_Audit__c> salesAuditListInsertion = new List <Sales_Role_Audit__c>();
		List <Sales_Role_Audit__c> salesAuditListDeletion = new List <Sales_Role_Audit__c>();
		
		System.debug('salesRoleHistoryList : '+salesRoleHistoryList);
		set<Id> salesRoleIds = new set<Id>();
		map<Id,Sales_role__c> mapOfSalesRole = new map<Id,Sales_role__c>();
		Map<Id,User> userIdToNewusername = new Map<Id,User>();
		Map<Id,User> userIdToOldusername = new Map<Id,User>();
		Set<Id> useridOld = new Set<Id>();
		Set<Id> useridNew = new Set<Id>();	  
		for(Sales_Role_History__c saleshistory :salesRoleHistoryList){
			salesRoleIds.add(saleshistory.Sales_Role__c);
			useridOld.add(saleshistory.Old_User__c);
			useridNew.add(saleshistory.New_User__c);
		}
		
		for(User u: [SELECT CreatedDate,FirstName,LastName,Nokia_ID__c FROM User where (Id In :useridNew or Id In :useridOld) LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
			if(useridOld.contains(u.id))
				userIdToOldusername.put(u.id,u);
			if(useridNew.contains(u.id))
				userIdToNewusername.put(u.id,u);
		}
		system.debug('userIdToOldusername>>>'+userIdToOldusername);
		system.debug('userIdToNewusername>>>'+userIdToNewusername);
		for(Sales_Role__c c:[SELECT Id,Process_SRT_Audit__c FROM Sales_Role__c where id In :salesRoleIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			mapOfSalesRole.put(c.id, c);
		}
		
		
		for(Sales_Role_History__c saleshistory :salesRoleHistoryList)
		{
			Sales_Role_Audit__c salesRoleAudit = new Sales_Role_Audit__c();
			salesRoleAudit.Hierarchy_Id__c = saleshistory.Hierarchy_ID__c; 
			salesRoleAudit.Role_Name__c = saleshistory.New_Role_Name__c;		 
			salesRoleAudit.Organisation__c = saleshistory.Organisation__c;
			salesRoleAudit.Role_Code__c = saleshistory.Role_Code__c;
			
			
			if(!userIdToNewusername.isEmpty())
			{
				//DateTime s =userIdToNewusername.get(saleshistory.New_User__c).CreatedDate;
				//date myDate = date.newinstance(s.year(), s.month(), s.day());
				salesRoleAudit.Role_Start_Date__c= userIdToNewusername.get(saleshistory.New_User__c).CreatedDate;	
				salesRoleAudit.Role_Owner_ID__c = userIdToNewusername.get(saleshistory.New_User__c).Nokia_ID__c;
			}
			salesRoleAudit.BG__c=saleshistory.BG_Attribute__c;			
			Sales_Role_Audit__c salesRoleAudit1 = new Sales_Role_Audit__c();			
			salesRoleAudit1.Role_Name__c = saleshistory.New_Role_Name__c; 
			if(!userIdToOldusername.isEmpty())
			{
				//DateTime s =userIdToNewusername.get(saleshistory.Old_User__c).CreatedDate;
				//date myDate = date.newinstance(s.year(), s.month(), s.day());
				salesRoleAudit1.Role_Start_Date__c=userIdToOldusername.get(saleshistory.Old_User__c).CreatedDate;
				salesRoleAudit1.Role_Owner_ID__c = userIdToOldusername.get(saleshistory.Old_User__c).Nokia_ID__c;
			}
			//salesRoleAudit1.Role_End_Date__c=31/12/9999;
			salesRoleAudit1.Organisation__c = saleshistory.Organisation__c;
			salesRoleAudit1.Role_Code__c = saleshistory.Role_Code__c;
			salesRoleAudit1.BG__c=saleshistory.BG_Attribute__c;
			salesRoleAudit1.Hierarchy_Id__c = saleshistory.Hierarchy_ID__c;
			
			if(saleshistory.Operation_Type__c == GlobalConstants.CREATED && saleshistory.New_User__c != null && mapOfSalesRole.get(saleshistory.Sales_Role__c).Process_SRT_Audit__c==true) 
			{
				salesRoleAudit.Operation_Type__c = GlobalConstants.INSERT_VALUE;
				salesRoleAudit.User__c = saleshistory.New_User__c;
				salesAuditListInsertion.add(salesRoleAudit);
			}
			
			if((saleshistory.Operation_Type__c == GlobalConstants.DELETED || saleshistory.Operation_Type__c == GlobalConstants.MODIFIED) && saleshistory.Old_User__c != null && mapOfSalesRole.get(saleshistory.Sales_Role__c).Process_SRT_Audit__c==true && saleshistory.Role_Code__c!=GlobalConstants.NSNGCOCT)
			{
				salesRoleAudit1.Operation_Type__c = GlobalConstants.DELETE_VALUE;
				salesRoleAudit1.User__c = saleshistory.Old_User__c;
				salesAuditListDeletion.add(salesRoleAudit1);
			}
			if((saleshistory.Operation_Type__c == GlobalConstants.MODIFIED) && saleshistory.New_User__c != null && mapOfSalesRole.get(saleshistory.Sales_Role__c).Process_SRT_Audit__c==true && saleshistory.Role_Code__c!=GlobalConstants.NSNGCOCT) 
			{
				salesRoleAudit.Operation_Type__c = GlobalConstants.INSERT_VALUE;
				salesRoleAudit.User__c = saleshistory.New_User__c;
				salesAuditListInsertion.add(salesRoleAudit);
			}
			
			if((saleshistory.Operation_Type__c == GlobalConstants.MODIFIED) && saleshistory.New_User__c != null && mapOfSalesRole.get(saleshistory.Sales_Role__c).Process_SRT_Audit__c==true && saleshistory.Role_Code__c==GlobalConstants.NSNGCOCT) 
			{
				salesRoleAudit.Operation_Type__c = GlobalConstants.UPDATE_VALUE;
				salesRoleAudit.User__c = saleshistory.New_User__c;
				salesAuditListInsertion.add(salesRoleAudit);
			}
			
		}
		System.debug('DML : '+Database.insert(salesAuditListDeletion, false)); 
		System.debug('DML : '+Database.insert(salesAuditListInsertion, false)); 
	}
}