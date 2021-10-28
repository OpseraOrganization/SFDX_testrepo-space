/******************************************************************************************************
Name : SalesRoleHelper
Created Date: 7 JULY 2018
Created by: Accenture
Description : To create Sales Role History record on Sales Role insertion
*********************************************************************************************************/
public class SalesRoleHelper {
	/********************
*Method Name: createSalesHistoryRecord
*Parameter: salesRoleNewList
*Description: For creating Sales Role History record'
*******************/

	public static void createSalesHisoryRecord(List<Sales_Role__c> salesRoleNewList){
		try{
			List <Sales_Role_History__c> salesRoleHistoryInsertion = new List <Sales_Role_History__c>();
			// List <Sales_Role_History__c> salesRoleHistoryListDeletion = new List <Sales_Role_History__c>();
			Set<String> hierarchyLabel = new Set<String>();
			Map<String,String> hierarchyLabelToHierarchyId = new Map<String,String>();
			Map<Id,User> userIdToNewusername = new Map<Id,User>();
			Set<Id> useridNew = new Set<Id>();

			for(Sales_Role__c saleshistory :salesRoleNewList){
	hierarchyLabel.add(saleshistory.Organisation__c);
	useridNew.add(saleshistory.User__c);
			}

			system.debug('hierarchyLabel>>'+hierarchyLabel);

			for(Territory2 territoryVar : [select Id,Name,Hierarchy_Level__c,Hierarchy_ID__c from Territory2 where Name In: hierarchyLabel
			 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	hierarchyLabelToHierarchyId.put(territoryVar.Name,territoryVar.Hierarchy_ID__c);

			}

			system.debug('hierarchyLabelToHierarchyId >>'+hierarchyLabelToHierarchyId);

			for(User u: [SELECT CreatedDate,FirstName,LastName,Nokia_ID__c FROM User where Id In :useridNew] ){
	userIdToNewusername.put(u.id,u);
			}

			for(Sales_Role__c saleshistory :salesRoleNewList)
			{
	Sales_Role_History__c salesRoleHistory = new Sales_Role_History__c();
	salesRoleHistory.Approval_Type__c = saleshistory.Approval_Type__c;
	salesRoleHistory.BG_Attribute__c = saleshistory.BG__c;
	salesRoleHistory.Comments__c = saleshistory.Business_Comments__c;
	salesRoleHistory.email__c = saleshistory.User_Email__c;
	salesRoleHistory.External_ID__c = saleshistory.External_ID__c;
	salesRoleHistory.New_User__c	 = saleshistory.User__c;
	salesRoleHistory.Organisation__c	 = saleshistory.Organisation__c;
	salesRoleHistory.Role_Code__c	= saleshistory.Role_Code__c;
	salesRoleHistory.New_Role_Name__c	= saleshistory.Role_Name__c;
	salesRoleHistory.Sales_Role__c   = saleshistory.Id;
	salesRoleHistory.Operation_Type__c   = 'Created';
	salesRoleHistory.Hierarchy_Id__c	 = hierarchyLabelToHierarchyId.get(saleshistory.Organisation__c);


	salesRoleHistoryInsertion.add(salesRoleHistory);
			}

			System.debug('salesAuditList : '+salesRoleHistoryInsertion);
			System.debug('DML : '+Database.insert(salesRoleHistoryInsertion, false));
			// System.debug('DML : '+Database.insert(salesAuditListDeletion, false));
			//System.debug('SalesAudit queue joob id : '+System.enqueueJob(new SalesAudit()));
		}catch(Exception ex) {
	ExceptionHandler.addException(ex, SalesRoleHelper.class.getName(), 'createSalesHisoryRecord');
			}
	}



	public static void modifySalesHisoryRecord(List<Sales_Role__c> salesRoleNewList,Map<Id,Sales_Role__c> salesRoleOldMap){
		try{
			List<Sales_Role__c> validChangeList = new list<Sales_Role__c>();
			for(Sales_Role__c sr : salesRoleNewList){

	system.debug('New sr.Process_SRT_Audit__c.......'+sr.Process_SRT_Audit__c);
	system.debug('old sr.Process_SRT_Audit__c.......'+salesRoleOldMap.get(sr.Id).Process_SRT_Audit__c);
	system.debug('New sr.user__c .......'+sr.user__c );
	system.debug('old sr.user__c .......'+salesRoleOldMap.get(sr.Id).user__c);

	if(sr.Process_SRT_Audit__c == true && salesRoleOldMap.get(sr.Id).Process_SRT_Audit__c == false){
		 if( sr.user__c != salesRoleOldMap.get(sr.Id).user__c){
			if(sr.user__c != null)
				validChangeList.add(sr);
		 }
	}else if(sr.Process_SRT_Audit__c == true && salesRoleOldMap.get(sr.Id).Process_SRT_Audit__c == true){
		if( sr.user__c != salesRoleOldMap.get(sr.Id).user__c){
			if(sr.user__c != null)
				validChangeList.add(sr);
		 }
	}
			}
			List <Sales_Role_History__c> salesRoleHistoryInsertion = new List <Sales_Role_History__c>();
			// List <Sales_Role_History__c> salesRoleHistoryListDeletion = new List <Sales_Role_History__c>();
			Set<String> hierarchyLabel = new Set<String>();
			Map<String,String> hierarchyLabelToHierarchyId = new Map<String,String>();

			Map<Id,Boolean> mapOfIdToProcessSRTAuditNew = new Map<Id,Boolean>();
			Map<Id,Boolean> mapOfIdToProcessSRTAuditOld = new Map<Id,Boolean>();

			Set<Id> userId = new Set<Id>();
			for(Sales_Role__c saleshistory :validChangeList){
	hierarchyLabel.add(saleshistory.Organisation__c);
	mapOfIdToProcessSRTAuditNew.put(saleshistory.Id,saleshistory.Process_SRT_Audit__c);

			}

			Map<String,Sales_Role__c> autoNumberToUserId = new Map<String,Sales_Role__c>();

			for(Sales_Role__c saleshistory :salesRoleOldMap.values()){
	autoNumberToUserId.put(saleshistory.Name,saleshistory);
	userId.add(saleshistory.User__c);
			}

			system.debug('hierarchyLabel>>'+hierarchyLabel);

			for(Territory2 territoryVar : [select Id,Name,Hierarchy_Level__c,Hierarchy_ID__c from Territory2 where Name In: hierarchyLabel
			 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	hierarchyLabelToHierarchyId.put(territoryVar.Name,territoryVar.Hierarchy_ID__c);

			}

			system.debug('hierarchyLabelToHierarchyId >>'+hierarchyLabelToHierarchyId);


			for(Sales_Role__c saleshistory :validChangeList)
			{
	Sales_Role_History__c salesRoleHistory = new Sales_Role_History__c();
	salesRoleHistory.Approval_Type__c = saleshistory.Approval_Type__c;
	salesRoleHistory.BG_Attribute__c = saleshistory.BG__c;
	salesRoleHistory.Comments__c = saleshistory.Business_Comments__c;
	salesRoleHistory.email__c = saleshistory.User_Email__c;
	salesRoleHistory.External_ID__c = saleshistory.External_ID__c;
	salesRoleHistory.New_User__c	 = saleshistory.User__c;
	salesRoleHistory.Organisation__c	 = saleshistory.Organisation__c;
	salesRoleHistory.Role_Code__c	= saleshistory.Role_Code__c;
	salesRoleHistory.New_Role_Name__c	= saleshistory.Role_Name__c;
	salesRoleHistory.Sales_Role__c   = saleshistory.Id;
	salesRoleHistory.Hierarchy_Id__c	 = hierarchyLabelToHierarchyId.get(saleshistory.Organisation__c);
	salesRoleHistory.Operation_Type__c   = 'Modified';
	salesRoleHistory.Old_User__c=autoNumberToUserId.get(saleshistory.Name).User__c;

	salesRoleHistoryInsertion.add(salesRoleHistory);
			}

			System.debug('salesAuditList : '+salesRoleHistoryInsertion);

			if(!salesRoleHistoryInsertion.isEmpty()){
	System.debug('DML : '+Database.insert(salesRoleHistoryInsertion, false));
			}

			// System.debug('DML : '+Database.insert(salesAuditListDeletion, false));
			//System.debug('SalesAudit queue joob id : '+System.enqueueJob(new SalesAudit()));
		}catch(Exception ex) {
	ExceptionHandler.addException(ex, SalesRoleHelper.class.getName(), 'modifySalesHisoryRecord');
			}
	}

	public static void deleteSalesHisoryRecord(List<Sales_Role__c> salesRoleOldList){
		try{
			List <Sales_Role_History__c> salesRoleHistoryInsertion = new List <Sales_Role_History__c>();
			// List <Sales_Role_History__c> salesRoleHistoryListDeletion = new List <Sales_Role_History__c>();
			Set<String> hierarchyLabel = new Set<String>();
			Map<String,String> hierarchyLabelToHierarchyId = new Map<String,String>();
			//Map<String,String> hierarchyLabelToHierarchyId = new Map<String,String>();
			Set<Id> userId = new Set<Id>();
			string valid_DeleteRole=Label.NF_Salesrole_Delete_Validation;
			string[] valid_DeleteRoles=valid_DeleteRole.split(';');

			for(Sales_Role__c saleshistory :salesRoleOldList){
	hierarchyLabel.add(saleshistory.Organisation__c);

			}

			system.debug('hierarchyLabel>>'+hierarchyLabel);

			for(Territory2 territoryVar : [select Id,Name,Hierarchy_Level__c,Hierarchy_ID__c from Territory2 where Name In: hierarchyLabel
			 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	hierarchyLabelToHierarchyId.put(territoryVar.Name,territoryVar.Hierarchy_ID__c);

			}

			system.debug('hierarchyLabelToHierarchyId >>'+hierarchyLabelToHierarchyId);


			for(Sales_Role__c saleshistory :salesRoleOldList)
			{
	if(!valid_DeleteRoles.contains(saleshistory.Role_Code__c))
	{
	Sales_Role_History__c salesRoleHistory  = new Sales_Role_History__c();
	salesRoleHistory.Approval_Type__c	= saleshistory.Approval_Type__c;
	salesRoleHistory.BG_Attribute__c		= saleshistory.BG__c;
	salesRoleHistory.Comments__c			= saleshistory.Business_Comments__c;
	salesRoleHistory.email__c	  = saleshistory.User_Email__c;
	salesRoleHistory.External_ID__c		 = saleshistory.External_ID__c;
	salesRoleHistory.Organisation__c		= saleshistory.Organisation__c;
	salesRoleHistory.Role_Code__c	 = saleshistory.Role_Code__c;
	salesRoleHistory.New_Role_Name__c	= saleshistory.Role_Name__c;
	salesRoleHistory.Sales_Role__c	= saleshistory.Id;
	salesRoleHistory.Hierarchy_Id__c		= hierarchyLabelToHierarchyId.get(saleshistory.Organisation__c);
	salesRoleHistory.Operation_Type__c	  = 'Deleted';
	salesRoleHistory.Old_User__c			= saleshistory.User__c;

	salesRoleHistoryInsertion.add(salesRoleHistory);
		  }
	else
	{
		saleshistory.addError('Deletion of CO CT Head role is not possible');
	}
			}

			System.debug('salesAuditList : '+salesRoleHistoryInsertion);
			System.debug('DML : '+Database.insert(salesRoleHistoryInsertion, false));
			// System.debug('DML : '+Database.insert(salesAuditListDeletion, false));
			//System.debug('SalesAudit queue joob id : '+System.enqueueJob(new SalesAudit()));
		}catch(Exception ex) {
	ExceptionHandler.addException(ex, SalesRoleHelper.class.getName(), 'deleteSalesHisoryRecord');
			}
	}
}