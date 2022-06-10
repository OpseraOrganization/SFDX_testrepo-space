global without sharing class Pack4_CSP_Batch implements Database.Batchable<sObject>, Database.Stateful {
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
		String query = Label.Pack4_CSP_Scope;
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext bc, List<Sales_Role_Audit__c> records){
		if(!records.isEmpty()){			
			Set<String> userSalesRoleHierarchyIds = new Set<String>();
			List<Territory2> territory2List = new List<Territory2>();
			List<Pack4_CSP__c> pack4cspToInsert = new List<Pack4_CSP__c>();
			Boolean hierarchy, parentHierarchy;
			
			for(Sales_Role_Audit__c sra : records){			
				userSalesRoleHierarchyIds.add(sra.Hierarchy_Id__c);
			}
			if(!userSalesRoleHierarchyIds.isEmpty()){
				territory2List = [SELECT Id, Hierarchy_ID__c, Description, Name, Hierarchy_Level__c, LastModifiedDate, ParentTerritory2Id, ParentTerritory2.Hierarchy_ID__c, ParentTerritory2.Description, ParentTerritory2.Name, ParentTerritory2.Hierarchy_Level__c, ParentTerritory2.LastModifiedDate FROM Territory2 WHERE Hierarchy_ID__c IN : userSalesRoleHierarchyIds];
				if(!territory2List.isEmpty()){
					for(Sales_Role_Audit__c sra : records){
						for(Territory2 t2 : territory2List){
							if(t2.Hierarchy_ID__c == sra.Hierarchy_Id__c){
								Pack4_CSP__c pack4CSPObj = new Pack4_CSP__c();
								
								pack4CSPObj.Sales_Role_Audit__c = sra.Id;
								pack4CSPObj.Sales_Role_Audit_Id__c = sra.Id;
								pack4CSPObj.Sales_Role_Audit_Active__c = sra.Active__c;
								pack4CSPObj.User__c = sra.User__c;
								
								pack4CSPObj.Territory_Hierarchy_Id__c = t2.Hierarchy_ID__c;
								pack4CSPObj.Territory_Description__c = t2.Description;
								pack4CSPObj.Territory_Name__c = t2.Name;
								
								hierarchy = t2.Hierarchy_Level__c.contains('L');	 
								if(hierarchy){
									pack4CSPObj.Hierarchy_Level__c = t2.Hierarchy_Level__c.replaceAll('L', '');
								} else {
									pack4CSPObj.Hierarchy_Level__c = t2.Hierarchy_Level__c;
								}
								
								pack4CSPObj.LastModifiedDate__c = t2.LastModifiedDate;
								
								pack4CSPObj.Parent_Territory_Hierarchy_Id__c = t2.ParentTerritory2.Hierarchy_ID__c;
								pack4CSPObj.Parent_Territory_Description__c = t2.ParentTerritory2.Description;
								pack4CSPObj.Parent_Territory_Name__c = t2.ParentTerritory2.Name;
								
								parentHierarchy = t2.ParentTerritory2.Hierarchy_Level__c.contains('L');	 
								if(parentHierarchy){
									pack4CSPObj.Parent_Hierarchy_Level__c = t2.ParentTerritory2.Hierarchy_Level__c.replaceAll('L', '');
								} else {
									pack4CSPObj.Parent_Hierarchy_Level__c = t2.ParentTerritory2.Hierarchy_Level__c;
								}

								pack4CSPObj.Parent_LastModifiedDate__c = t2.ParentTerritory2.LastModifiedDate;
								
								pack4cspToInsert.add(pack4CSPObj);
							}
						}		
					}
				}
				if(!pack4cspToInsert.isEmpty()){
					Database.upsert(pack4cspToInsert, Pack4_CSP__c.Sales_Role_Audit_Id__c, false);
				}
			}
		}
	}	
	
	global void finish(Database.BatchableContext bc){
		
	}
}