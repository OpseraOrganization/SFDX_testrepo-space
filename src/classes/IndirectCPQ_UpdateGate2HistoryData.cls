public class IndirectCPQ_UpdateGate2HistoryData implements Queueable {
private List<Opportunity> opptyList;
	
	public void execute(QueueableContext context) {
		 System.debug('opptyList----->'+opptyList);
	 
	   beforeUpdateG2DataFill(opptyList);
	   Set<Id> opptyId = new Set<Id>();   
	   opptyId.add(opptyList[0].Id);
	   updateG2approvalHistoryData(opptyId);
	  
		 System.debug('opptyListbEFORE----->'+opptyList);
		   if(!Test.isRunningTest()) {
				 System.enqueueJob(new IndirectCPQ_CreateOIFAndOffer(opptyList)); 
		   }
		 
		 
	}
	
	
	public IndirectCPQ_UpdateGate2HistoryData(List<Opportunity> tempOpptyList) {
		opptyList=tempOpptyList;
	   
	}
	
	   
/******************************
*Method Name: beforeUpdateG2DataFill
*Description: This method will work for G2 Approval History Data
*Parameters: List<Opportunity>
CreationDate: 25/05/2018
Developer:Digital Sales team
*******************************/
	public static void beforeUpdateG2DataFill(List<Opportunity> opptyList){
		
  try{
		List<Opportunity> opptyListToUpdate = new  List<Opportunity>();
		Set<Id> oppId=new Set<Id>();
		for(Opportunity op:opptyList){
			oppId.add(op.id);
		}
		for(Opportunity opp: opptyList){
			if(opp.stagename.equals(GlobalConstants.IDENTIFY_OPPORTUNITY)){
				
			
			//Apttus_Approval.ApprovalsWebService.previewApprovals(CSWXGlobalConstant.OPPORTUNITY,opp.id);
		opp.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
		opp.ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
		opp.Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
		opp.G2_Approval_Date__c = System.now();
		 opp.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		 opp.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		opptyListToUpdate.add(opp);
			}
	}
	update opptyListToUpdate;
	  System.debug('opptyListToUpdate----->'+opptyListToUpdate);
	}
		catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_UpdateGate2HistoryData.class.getName(), CSWXGlobalConstant.beforeUpdateG2DataFill);
		}
	}
	
 /******************************
*Method Name: updateG2approvalHistoryData
*Description: This method will work for G2 Approval History Data
*Parameters: List<Opportunity>
CreationDate: 02/08/2018 (August Release)
Developer:Digital Sales team
*******************************/

	public static void updateG2approvalHistoryData(Set<Id> oppRecordId){
		
  try{
		
		
		List<Opportunity> opptyList=[Select Id,Owner.Name,Account.OwnerID,Org_L7__c,SWx_Upsell_Proposal__c,stagename,Name from Opportunity where Id=:oppRecordId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
		System.debug('opptyList[0].Org_L7__c---->'+opptyList[0].Org_L7__c);
		List<Sales_Role__c> sales= [SELECT Organisation__c,OwnerId,Role_Code__c,User__c,User__r.Name FROM Sales_Role__c where Role_Code__c=:CSWXGlobalConstant.NSNG_COCT AND Organisation__c=:opptyList[0].Org_L7__c Limit 1];
			
		  System.debug('sales----->'+sales);
	  
			List<Apttus_Approval__Backup_Approver__c> app=new List<Apttus_Approval__Backup_Approver__c>();
			if(!sales.isEmpty()){
			app=[select id,Apttus_Approval__Current_User__c,Apttus_Approval__Current_User__r.Name,Delegate_Approver1__c,Delegate_Approver2__c,Delegate_Approver3__c,Apttus_Approval__Backup_User__c from Apttus_Approval__Backup_Approver__c where Apttus_Approval__IsActive__c=true and Apttus_Approval__InEffect__c=true and  Apttus_Approval__Current_User__c=:sales[0].User__c LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			}
			
			  System.debug('app@@@@@----->'+app);
			List<Opportunity> oppOwner=[Select Id,Owner.Name from Opportunity where Id=:opptyList LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			Map<Id,String> MapOfOwner=new Map<Id,String>();
			for(Opportunity op:oppOwner){
				MapOfOwner.put(op.Id,op.Owner.Name);
			}
			
			
			String idsOfApprover;
			String delegateName;
			if(!app.isEmpty()){
			for(Apttus_Approval__Backup_Approver__c backup:app){
				if(backup.Delegate_Approver1__c!=null){
					idsOfApprover=backup.Delegate_Approver1__c;
				}
				if(backup.Delegate_Approver2__c!=null){
					idsOfApprover=idsOfApprover+','+backup.Delegate_Approver2__c;
				}
				if(backup.Delegate_Approver3__c!=null){
					idsOfApprover=idsOfApprover+','+backup.Delegate_Approver3__c;
				}
				
			}
			}
			
			Apttus_Approval__ApprovalProcessInstance__c appInstance=[SELECT Id, Name, Apttus_Approval__ApprovalProcessId__c FROM Apttus_Approval__ApprovalProcessInstance__c where Name=:CSWXGlobalConstant.G2_Approvals_New Limit 1 ]; 
			List<Apttus_Approval__Approval_Request_History__c > insertAppReq=new List<Apttus_Approval__Approval_Request_History__c >();
			
			System.debug('opptyList----#####'+opptyList);
			for(Opportunity opp: opptyList){
			   
					
					for(Integer i=0;i<2;i++){
						Apttus_Approval__Approval_Request_History__c  req=new Apttus_Approval__Approval_Request_History__c ();
						req.Apttus_Approval__Step_Name__c=CSWXGlobalConstant.Gate_2;
						req.Apttus_Approval__Assigned_To_Type__c=GlobalConstants.USER;
					   // req.NF_Assignee_Type__c=CSWXGlobalConstant.StakeholderName;
						req.Apttus_Approval__Request_Comments__c=CSWXGlobalConstant.SalesPhaseIdentifyOpportunity;
						req.Apttus_Approval__Approval_Status__c=CSWXGlobalConstant.NotifiedName;
						req.Apttus_Approval__Active__c=true;
					  //  req.Apttus_Approval__Object_Id__c =opp.id;
					  //  req.Apttus_Approval__RequestType__c =CSWXGlobalConstant.StandardName;
						req.Apttus_Approval__Related_Opportunity__c =opp.id;		
						req.Apttus_Approval__Object_Type__c=CSWXGlobalConstant.OpportunityName;
						req.Apttus_Approval__Object_Name__c=Opp.Name;
						req.Apttus_Approval__Notify_Only__c =true;
					   // req.Apttus_Approval__Initial_Submitter__c=UserInfo.getUserId();
					   req.Apttus_Approval__Initial_Submitter__c=Opp.Account.OwnerID;
					   // if(idsOfApprover!=null){
					  //  req.Apttus_Approval__HasDelegateApprover__c=true;
					  //  }
						//else{
					   // req.Apttus_Approval__HasDelegateApprover__c=false;
					  //  }
						req.Apttus_Approval__Date__c=System.now();
						req.Apttus_Approval__DateAssigned__c=System.now();
						req.Apttus_Approval__DateApproved__c=System.now();
						//req.Apttus_Approval__DelegateApproverIds__c=idsOfApprover;
						req.Apttus_Approval__ProcessInstanceId__c=appInstance.id; 
						//AM
						if(i==0 && !sales.isEmpty()){
							
							req.Apttus_Approval__Assigned_To_Name__c=sales[0].User__r.Name;
							req.Apttus_Approval__Approver_Comments__c=CSWXGlobalConstant.Notified_System_Info_Notified_User+' '+sales[0].User__r.Name+' '+System.now();
							req.Apttus_Approval__StepLabel__c=CSWXGlobalConstant.Notify_CT_Head;
							
						}
						//Opp Owner
						if(i==1){
							req.Apttus_Approval__Assigned_To_Name__c=MapOfOwner.get(opp.Id);
							req.Apttus_Approval__Approver_Comments__c=CSWXGlobalConstant.Notified_System_Info_Notified_User+' '+MapOfOwner.get(opp.Id)+' '+System.now();
							req.Apttus_Approval__StepLabel__c=CSWXGlobalConstant.Gate_2_Byepass;
						}
						
						insertAppReq.add(req);
					}
				// opp.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
			   //  opp.ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
			   //  opp.Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
			   //  opp.G2_Approval_Date__c = System.now();
			   //  opp.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			   //  opp.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			   
		}
		
		if(!insertAppReq.isEmpty()){
			insert insertAppReq;
		}
		
	}
	catch(Exception ex){
			ExceptionHandler.addException(ex, IndirectCPQ_UpdateGate2HistoryData.class.getName(), CSWXGlobalConstant.updateG2approvalHistoryData);
		}
	} 
	
	

}