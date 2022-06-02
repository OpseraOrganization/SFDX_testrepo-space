/**
*   This class is used as a helper to Update ApprovalRequest History 
*   "Role NAme", "Organization" and "AssigneeType" from the Rule Assignee Table
*/
public with sharing class NF_TL_UpdateHistoryRequestRCode {
	@TestVisible  public static Map<String,String> mapRoleCodeHierCode = new Map<String,String>{'2' => 'NSNA', '3' => 'NSNB', '4' => 'NSNC', '5' => 'NSND', '6' => 'NSNE', '7' => 'NSNG'} ;
	/**
	*   @desc   : Method used to update approvalRuleHistory Fields based on the appropriate AssigneeRule Table
	*   @param  : List<Apttus_Approval__Approval_Request_History__c>
	*/
	public static void updateHistoryRequestRcodeM(List<Apttus_Approval__Approval_Request_History__c> historyRequests){
		set<String> assignedUsers = new set<String>();
		set<String> arulesSet = new set<String>();
		Map<String,Apttus_Approval__Approval_Request_History__c> appRequestHSubStepMap = new Map<String,Apttus_Approval__Approval_Request_History__c>();
		Set<Id> opportunityIds = new Set<Id>();
		List<Apttus_Approval__Approval_Request_History__c> appReqHistoryUpdate = new List<Apttus_Approval__Approval_Request_History__c>();
		//Fetch  assignedTo Users + ApprovalRuleAssignees Name
		for(Apttus_Approval__Approval_Request_History__c request : historyRequests){
			arulesSet.add(request.Apttus_Approval__SubstepName__c);
			appRequestHSubStepMap.put(request.Apttus_Approval__SubstepName__c, request);
			assignedUsers.add(request.Apttus_Approval__Assigned_To_Id__c);
			opportunityIds.add(request.Apttus_Approval__Related_Opportunity__c);
			System.debug('-->User'+assignedUsers+arulesSet);
		}
		
		Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([Select Id,  Lead_BG__c, Lead_BU__c, OwnerID, Org_L2__c, Org_L3__c, Org_L4__c, Org_L5__c, Org_L6__c, Org_L7__c from Opportunity where Id in :opportunityIds]);
		
		System.debug('historyRequests-->'+historyRequests);

		set<String> orgsSet = new set<String>();
		set<String> codesSet = new set<String>();
		set<String> bgSet = new set<String>();
		Map<String, Set<String>> arAssigneeToOrgndCodeMap = new Map<String, Set<String>>();
		Map<String, String> arAssigneeToType = new Map<String, String>();

		//Loop Through assignees and construct : Org, roles, Map for each assigneeName relatedOrg+Code
		for(Apttus_Approval__ApprovalRuleAssignee__c arAssignee :[SELECT Id,Apttus_Approval__AssigneeValue__c,Apttus_Approval__AssigneeDescription__c,Name  FROM Apttus_Approval__ApprovalRuleAssignee__c 
																  WHERE Name in :arulesSet ]){
			
			String code='';			
			List<String> codList = new List<String>();
			List<String> org_codList = new List<String>();
			List<String> bg_List = new List<String>();
			
			String bg_Val = '';
			String bu_Val = '';
			System.debug('Asignee Rule ID --->'+arAssignee.Id);
			
			//Map for unique AssigneeNAme to Description which can be : Approver, Validator, Stackholder to be used for ValidatorComments.
			if(!arAssigneeToType.containsKey(arAssignee.Name) && String.isNotBlank(arAssignee.Apttus_Approval__AssigneeDescription__c))
				arAssigneeToType.put(arAssignee.Name, arAssignee.Apttus_Approval__AssigneeDescription__c.subString(arAssignee.Apttus_Approval__AssigneeDescription__c.lastIndexOf(',')+1, arAssignee.Apttus_Approval__AssigneeDescription__c.length()));				   
			
			
			//Check wether the Record has a valid value in  the field assigneeValue, if yes then split.
			if(arAssignee.Apttus_Approval__AssigneeValue__c != null && arAssignee.Apttus_Approval__AssigneeValue__c.contains('AND'))
			{
				codList = arAssignee.Apttus_Approval__AssigneeValue__c.split('AND');
				org_codList = codList[1].split('OR');
				if(codlist.size()== 4 && codList[3].contains('OR')) 
					bg_List = codList[3].split('OR');	   
			}
			system.debug('org_codList:'+org_codList);
			system.debug('codList:'+codList);
			//Get the Organization Level from SalesRole, then get the value from the opportunity by Dynamic Apex.  
			Apttus_Approval__Approval_Request_History__c request = appRequestHSubStepMap.containsKey(arAssignee.Name) ? appRequestHSubStepMap.get(arAssignee.Name) : null;
			
			if(request != null && request.Apttus_Approval__Related_Opportunity__c != null && !codList.isEmpty())
			{
				code = codList[0].subString(codList[0].lastIndexOf('%')+2, codList[0].length()-2).remove(' '); 
				Opportunity opptyAR = opportunityMap.get(request.Apttus_Approval__Related_Opportunity__c);
				if(!bg_List.isEmpty())
				{  
					bg_Val = opptyAR.Lead_BG__c;
					bgSet.add(bg_Val);
					if(opptyAR.Lead_BU__c != null)
					{
						bu_Val = opptyAR.Lead_BU__c;
						bgSet.add(bu_Val);
					}
				}
				else if(codList.size() == 4)
				{
					bg_Val = codList[3].subString(codList[3].lastIndexOf('=')+2,codList[3].IndexOf(')')-1);
					bgSet.add(bg_Val);
				}
				
				//Map for Unique Assignee name to (Code + BG) and (Code + BU)
				if(!arAssigneeToOrgndCodeMap.containsKey(arAssignee.Name) && String.isNotBlank(code) ){
					arAssigneeToOrgndCodeMap.put(arAssignee.Name,new Set<String>{(code+bg_Val).touppercase(),(code+bu_Val).touppercase()});
				}
				
				if(!org_codList.isEmpty())
				{	
					for(String orgCode : org_codList)
					{
						String org1 = orgCode.subString(orgCode.lastIndexOf(':')+1, orgCode.lastIndexOf('\'')).remove(' ');
						System.debug(opptyAR.get(org1));
						orgsSet.add(String.valueOf(opptyAR.get(org1)));
						String roleCodeLevel = orgCode.subString(orgCode.lastIndexOf('L')+1, orgCode.lastIndexOf('_')-1).remove(' ');	
						if(mapRoleCodeHierCode.containsKey(roleCodeLevel))
							codesSet.add(mapRoleCodeHierCode.get(roleCodeLevel)+code);
					} 
				} 
			}				   
		}
		system.debug('code:'+codesSet);
		system.debug('OrsSet:'+orgsSet);
		system.debug('bgSet:'+bgSet);
		Map<String, Sales_Role__c> rolendOrgToSalesRoleMap = new Map<String, Sales_Role__c>();
		for(Sales_Role__c sRole :[SELECT Id, User__c, BG__c, Role_Name__c, Organisation__c, Role_Code__c FROM Sales_Role__c WHERE (BG__c = :bgSet or BG__c = '') AND Role_Code__c in :codesSet AND Organisation__c in :orgsSet ]){
			//Map for unique Code+Organization to the relevant record sRole.
			string Role = sRole.Role_Code__c;
			String Role_Map_Key ='';
			IF(sRole.BG__c!=null)
			Role_Map_Key = Role.subString(Role.lastIndexOf('_'))+sRole.BG__c;
			else
			Role_Map_Key = Role.subString(Role.lastIndexOf('_'));		   
			if(!rolendOrgToSalesRoleMap.containsKey(Role_Map_Key.touppercase())){
				rolendOrgToSalesRoleMap.put(Role_Map_Key.touppercase(), sRole);
				system.debug('sRole:'+sRole);
			}
		}
		//Loop throught historyRequest list and update the relevant data.
		Savepoint sp = null;
		for(Apttus_Approval__Approval_Request_History__c request : historyRequests){
			Apttus_Approval__Approval_Request_History__c requestUpdate = new Apttus_Approval__Approval_Request_History__c();
			requestUpdate.Id = request.Id;
			Set<String> roleBGVal = new Set<String>();
			if(arAssigneeToOrgndCodeMap.get(request.Apttus_Approval__SubstepName__c) != null )
				roleBGVal = arAssigneeToOrgndCodeMap.get(request.Apttus_Approval__SubstepName__c);
			
			for(String option : roleBGVal){
				if(rolendOrgToSalesroleMap.containsKey(option)){
					Sales_role__c srole = rolendOrgToSalesroleMap.get(option);
					if(srole != null){
						requestUpdate.NF_Organization_Level__c = srole.Organisation__c;
						requestUpdate.NF_role_Code__c = srole.role_Code__c;
						requestUpdate.NF_role_Name__c = srole.role_Name__c;  
						if(sRole.BG__c<>NUll)  
							requestUpdate.BG_Attribute__c=sRole.BG__c;
						system.debug('sroleCode: '+ srole.role_Code__c);
					}
					break;
				}
			}

			if(arAssigneeToType.get(request.Apttus_Approval__SubstepName__c) != null){
				requestUpdate.NF_Assignee_Type__c = arAssigneeToType.get(request.Apttus_Approval__SubstepName__c);
			}
			appReqHistoryUpdate.add(requestUpdate);
		}
		try{
			sp = Database.setSavepoint();
			Database.update(appReqHistoryUpdate,false);
		}catch(DmlException e){
			if (sp != null) Database.rollback(sp);
			system.debug('###Exception from NF_TL_UpdateHistoryRequestRCode : '+e.getMessage() + 'Stack Trace : '+e.getStackTraceString());
			throw e;
		}
		
	}
}