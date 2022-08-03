public class SRTAuditProcess {
	
   /* public static void updateStatus(){
		
		List<String> statusList=CMDPack4Callout.customCallout();   
		system.debug('@@@@' +statusList);	
		//Map<String,list<Sales_Role_Audit__c>> map1=CMDPack4Callout.dataManipulation();
		//List<Sales_Role_Audit__c> auditList =map1.values();
		List<Sales_Role_Audit__c> auditList;
		auditList = [SELECT BG__c,Hierarchy_Id__c,Id,Is_Processed__c,Operation_Type__c,OwnerId,Role_Code__c,Role_End_Date__c,Role_Owner_ID__c,Role_Start_Date__c,User__c 
							FROM Sales_Role_Audit__c 
							WHERE Is_Processed__c = false 
							and Hierarchy_Id__c = 'OTH NC ENDCU INDIA'
							order by createddate
							limit 2];
		List<Sales_Role_Audit__c> auditListToUpdate = new List<Sales_Role_Audit__c> ();	
		for(Integer i=0; i<auditList.size(); i++){
			if(statusList[i] == 'OK'){
				auditList[i].Is_Processed__c = true;
				auditListToUpdate.add(auditList[i]);
			}
		}
		
	}
	public static List<String> parseXML(DOM.XMLNode node, List<String> statusList) {
				   
			if(string.ValueOf(node.getName()) == 'roleOwnerDetailsResponse'){
				statusList.add(node.getChildElements()[0].getText());
			}
			for (Dom.XMLNode child: node.getChildElements()) {
				parseXML(child , statusList);
			}
			return statusList;
			
		
	} */
	public static void updateRepsonse(Map<String,List<Sales_Role_Audit__c>>  unprocessedRecords,nsnComCmdService.response res){
		Integer outerCounter = 0;
		Integer innerCounter = 0;
		List<Sales_Role_Audit__c> updateAuditList = new List<Sales_Role_Audit__c>();
		for(String salesHierarchyID : unprocessedRecords.keySet()){
			innerCounter = 0;
			for(Sales_Role_Audit__c SRTAudit: unprocessedRecords.get(salesHierarchyID)){
				if(res.salesHierarhyResponse[outerCounter].executionStatus == 'OK'){
					string roleAuditStatus = res.salesHierarhyResponse[outerCounter].roleOwnerDetailsResponse[innerCounter].executionStatus;
					if(roleAuditStatus == 'OK'){
						SRTAudit.Is_Processed__c = true;
					}
					SRTAudit.Comments__c = roleAuditStatus;
				}else{
					 SRTAudit.Comments__c = res.salesHierarhyResponse[outerCounter].executionStatus;
				}
				updateAuditList.add(SRTAudit);
				innerCounter++;
			}
			outerCounter++;	
		  }
		 update updateAuditList; 
	}
	
	 /********************
	*Method Name: insertInterfaceLog
	*Parameter: AccountId 
	*Description: Used to create a log to track the response
	*******************/
	public static void insertInterfaceLog(nsnComCmdService.response res,Map<String,List<Sales_Role_Audit__c>> processedRecords,string status){
		
		Interface_Log__c interfaceLog = New Interface_Log__c();
		interfaceLog.Name = 'CMDpack4';
		/***************************************************************/
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;
		interfaceLog.Status__c = status;
		interfaceLog.Comment__c = res + GlobalConstants.BLANK_VALUE;
		interfaceLog.Operation_type__c = GlobalConstants.INSERT_VALUE; 
		interfaceLog.Interface_Request_Sent__c = processedRecords+'';
		interfaceLog.Interface_Type__c = 'CMD Pack4 Sales Role Sync';
		interfaceLog.Message_Type__c = GlobalConstants.OUTBOUND;  
		insert interfaceLog;
	}
}