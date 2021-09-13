Public Class CCREProposalHelper implements Queueable {
	List<Id> oppid = new List<Id>();
	public void execute(QueueableContext context) {
		Boolean result = false;
		Boolean result_2 = false;
			 
		try
			{
			if(!oppId.isEmpty()){
				result = byPassG5Gate(oppId);
				if(result)
				{
					result_2= byPassG5_2Gate(oppId);
				}
				if(result_2)
				{
					byPassG6(oppId);
				}
			   }
			   }
			  catch(Exception ex){
					   ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREProposalHelper,CSWXGlobalConstant.CCREexecute );
					   
				   }	  

			  }
		public CCREProposalHelper(List<Id > oppId) {
			this.Oppid = oppid;
		}
		public static boolean byPassG5Gate(List<Id> oppId) {
 

		List<Order_Intake_Forecast__c> oifLines = new List<Order_Intake_Forecast__c>();
		List<Opportunity> OpptyUpdate= new List<Opportunity>();
		system.debug('In G5');

		try{	
			for(Order_Intake_Forecast__c oif : [SELECT Id,Forecast_Category__c FROM Order_Intake_Forecast__c WHERE Opportunity__c in: oppid and allocation__c<>true])
			{
				oif.Forecast_Category__c = CSWXGlobalConstant.SECURE;
				oifLines.add(oif); 
			} 
			if(!oifLines.isEmpty())
			{
			   // Database.update(oifLines,false); // HCL : Commented for SF : 510636 
			} 
			for(Opportunity opp : [select id,RecordTypeId,Apttus_Approval__Approval_Status__c,ApprovalStatusTechField__c,G2_Approval_Date__c,
							 StageName,Phase_Status__c,OIF_Amount_EUR__c,Sales_Outcome_Reason__c,Third_Reason__c ,Second_Reason__c ,DS_Reasons_Populated__c ,G5_Contract_Approval_Date__c,Probability,SWx_Upsell_Proposal__c from Opportunity where id=:oppId])
			{
				if(opp.SWx_Upsell_Proposal__c <> null){
				opp.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
				opp.ApprovalStatusTechField__c = CSWXGlobalConstant.G4_APPROVAL_TECH;
				opp.StageName = CSWXGlobalConstant.WIN_THE_CASE_NEGOTIATE ;
				opp.Phase_Status__c = CSWXGlobalConstant.PENDING_WIN_LOSS_DECLARATION  ;
				opp.G5_Contract_Approval_Date__c = System.now();
				if(opp.OIF_Amount_EUR__c>CSWXGlobalConstant.threshold){
				opp.Sales_Outcome_Reason__c= CSWXGlobalConstant.Sales_Outcome_Reason;
				opp.Second_Reason__c = CSWXGlobalConstant.Second_Reason;
				opp.Third_Reason__c  = CSWXGlobalConstant.Third_Reason;
				opp.DS_Reasons_Populated__c = true;
				}
				else
				{
				opp.DS_Reasons_Populated__c = false;
				}
				OpptyUpdate.add(opp);
							   }
			}
			system.debug('OpptyUpdate>>>!'+OpptyUpdate);
			if(OpptyUpdate.size()>0)
			{   
				database.update(OpptyUpdate,false); 
			} 
			CCREProposalHelper.updateOpportunityApprovalHistory(oppId,CSWXGlobalConstant.G5_2_APPROVAL_BYPASS ); 
 
		}
		
		catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREProposalHelper,CSWXGlobalConstant.byPassG5Gate );	  
		}
		return true;	
	  
 }

	public static boolean byPassG5_2Gate(List<Id> oppId) {
 

		List<Order_Intake_Forecast__c> oifLines = new List<Order_Intake_Forecast__c>();
		List<Opportunity> OpptyUpdate= new List<Opportunity>();
		system.debug('In G5.2');

		try{	
			for(Opportunity opp : [select id,Apttus_Approval__Approval_Status__c,ApprovalStatusTechField__c,G2_Approval_Date__c,
							 StageName,Phase_Status__c,G5_Contract_Approval_Date__c,G5_Approval_Date__c,SWx_Upsell_Proposal__c from Opportunity where id=:oppId])
			{
				if(opp.SWx_Upsell_Proposal__c <> null){
				opp.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
				opp.ApprovalStatusTechField__c = CSWXGlobalConstant.G5_APPROVAL_TECH;
				opp.StageName = CSWXGlobalConstant.HANDOVER_OPPTY  ;
				opp.Phase_Status__c = CSWXGlobalConstant.PTA_HANDOVER ;
				opp.G5_Approval_Date__c = System.now();
				opp.Sales_Outcome__c=CSWXGlobalConstant.WON;
				}
				OpptyUpdate.add(opp);
			}
			if(OpptyUpdate.size()>0)
				database.update(OpptyUpdate,false);   

			CCREProposalHelper.updateOpportunityApprovalHistory(oppId,CSWXGlobalConstant.G5_WIN_PHASE ); //G5 Contract Approvals (Bypass)
		}  
		   
		catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREProposalHelper,CSWXGlobalConstant.byPassG5_2Gate );
			   
		}
		return true;
	  
 }  
	public static void byPassG6(List<Id> oppId) {
		List<Opportunity> OpptyUpdate= new List<Opportunity>();
		system.debug('In G5.2');

		try{	
			for(Opportunity opp : [select id,Apttus_Approval__Approval_Status__c,ApprovalStatusTechField__c,G2_Approval_Date__c,
							 StageName,Phase_Status__c,Lead_BG__c,G5_Contract_Approval_Date__c,G5_Approval_Date__c,SWx_Upsell_Proposal__c from Opportunity where id=:oppId])
			{
				if(opp.SWx_Upsell_Proposal__c <> null && opp.Lead_BG__c == CSWXGlobalConstant.MN ){
				opp.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
				opp.ApprovalStatusTechField__c = CSWXGlobalConstant.G6_APPROVAL_TECH;
				opp.StageName = CSWXGlobalConstant.EXECUTE_STAGE  ;
				opp.Phase_Status__c = CSWXGlobalConstant.EXECUTE_PHASE ;
				opp.G6_Approval_Date__c = System.now();
				opp.Sales_Outcome__c=CSWXGlobalConstant.WON;
				}
				OpptyUpdate.add(opp);

			}
			if(OpptyUpdate.size()>0)
				database.update(OpptyUpdate,false);  
			
			CCREProposalHelper.updateOpportunityApprovalHistory(Oppid, CSWXGlobalConstant.G6_BYPASS);		   
		}  
			
		catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREProposalHelper,CSWXGlobalConstant.byPassG6 );
			   
		}
		
	  
 }  


   public static void updateOpportunityApprovalHistory(List<Id> oppId,  String gateName) {
	   List<Apttus_Approval__ApprovalProcessInstance__c> approvalInstanceList = new List<Apttus_Approval__ApprovalProcessInstance__c>();
	   Apttus_Approval__ApprovalProcessInstance__c approvalInstance;
	   List<Apttus_Approval__Approval_Request__c> requestList = new List<Apttus_Approval__Approval_Request__c>();
	   List<Apttus_Approval__Approval_Request_History__c> approvalDataHistory=new List<Apttus_Approval__Approval_Request_History__c>(); 
	   Map<Id,Apttus_Approval__ApprovalProcessInstance__c > appInstanceOptty = new Map<Id, Apttus_Approval__ApprovalProcessInstance__c>();
	   Apttus_Approval__Approval_Request_History__c approvalhistory;
	  try{
		List<Apttus_Approval__Approval_Process__c> aprovalprocessid = [Select id,Apttus_Approval__Process_Name__c,Apttus_Approval__Object_Type__c from Apttus_Approval__Approval_Process__c  where Apttus_Approval__Process_Name__c like: gateName LIMIT 1];
		//create approval process instance object for present gate
		for(Id opptyid : oppId)
		{
		  approvalInstance = new Apttus_Approval__ApprovalProcessInstance__c();
		  approvalInstance.Apttus_Approval__BusinessObjectId__c= opptyid;
		  approvalInstance.Apttus_Approval__BusinessObjectType__c =  aprovalprocessid[0].Apttus_Approval__Object_Type__c;
		  approvalInstance.Apttus_Approval__ApprovalProcessId__c =  aprovalprocessid[0].id;
		  approvalInstance.Apttus_Approval__Status__c = CSWXGlobalConstant.Approval_stage_approved;
		  approvalInstance.Name = gateName;
		  approvalInstanceList.add(approvalInstance);
		}
		if(!approvalInstanceList.isEmpty())
		{
			Database.insert(approvalInstanceList);
		}
	
		for(Apttus_Approval__ApprovalProcessInstance__c appprocessInstance : [SELECT id,Apttus_Approval__BusinessObjectId__c,Name from Apttus_Approval__ApprovalProcessInstance__c where Apttus_Approval__BusinessObjectId__c in : oppId and Apttus_Approval__ApprovalProcessId__c =: aprovalprocessid[0].id and name like: gateName ])
		{
			appInstanceOptty.put(appprocessInstance.Apttus_Approval__BusinessObjectId__c, appprocessInstance);
		}
				
		
		
		for(Apttus_Approval__Approval_Request__c approvalRequest : [SELECT id,Name,Apttus_Approval__StepNameLink__c,Apttus_Approval__Step_Name__c,
															   Apttus_Approval__Request_Comments__c,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Related_Opportunity__c,
															   Apttus_Approval__ProcessInstanceId__c,Apttus_Approval__StepSequenceString__c,
															   NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__Active__c,Apttus_Approval__Object_Id__c,Apttus_Approval__Object_Type__c,
															   Apttus_Approval__StepLabel__c,Apttus_Approval__RequestType__c,Apttus_Approval__Notify_Only__c,Apttus_Approval__Initial_Submitter__c,Apttus_Approval__Assigned_To_Name__c,Apttus_Approval__Date__c, Opportunity_Name__c
															   FROM Apttus_Approval__Approval_Request__c where Apttus_Approval__Related_Opportunity__c in:oppId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
			approvalHistory = new Apttus_Approval__Approval_Request_History__c();													 
			//create approval history records
			approvalHistory.Apttus_Approval__Related_Opportunity__c = approvalRequest.Apttus_Approval__Related_Opportunity__c;
			approvalHistory.Apttus_Approval__Step_Name__c = approvalRequest.Apttus_Approval__Step_Name__c;
			approvalHistory.Apttus_Approval__Assigned_To_Type__c = approvalRequest.Apttus_Approval__Assigned_To_Type__c;
			approvalHistory.Apttus_Approval__Active__c = approvalRequest.Apttus_Approval__Active__c;
			approvalHistory.Apttus_Approval__Object_Id__c = approvalRequest.Apttus_Approval__Object_Id__c;
			approvalHistory.Apttus_Approval__Object_Type__c = approvalRequest.Apttus_Approval__Object_Type__c;
			approvalHistory.Apttus_Approval__RequestType__c = approvalRequest.Apttus_Approval__RequestType__c;
			approvalHistory.Apttus_Approval__StepLabel__c = approvalRequest.Apttus_Approval__StepLabel__c;
			approvalHistory.Apttus_Approval__Notify_Only__c = True;
			approvalHistory.Apttus_Approval__Initial_Submitter__c = approvalRequest.Apttus_Approval__Initial_Submitter__c;
			approvalHistory.Apttus_Approval__ProcessInstanceId__c = approvalRequest.Apttus_Approval__ProcessInstanceId__c; 
			approvalHistory.Apttus_Approval__Date__c = System.now();
			approvalHistory.NF_Assignee_Type__c = approvalRequest.NF_Assignee_Type__c;
			approvalHistory.Apttus_Approval__Assigned_To_Name__c = approvalRequest.Apttus_Approval__Assigned_To_Name__c;
			approvalHistory.Apttus_Approval__Approver_Comments__c = CSWXGlobalConstant.APPROVER_COMMENTS+ System.now();
			approvalHistory.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Notified;
			approvalHistory.Apttus_Approval__Object_Name__c = approvalRequest.Opportunity_Name__c;
			approvalHistory.Apttus_Approval__Send_Email__c = false;
			approvalHistory.Apttus_Approval__DateApproved__c = System.now();
		//  approvalHistory.Apttus_Approval__Auto_Complete__c = true;
			approvalDataHistory.add(approvalHistory);
			//update approval request record
			if(gateName.equalsignorecase(CSWXGlobalConstant.G5_2_APPROVAL_BYPASS ) )
			{
				approvalRequest.Apttus_Approval__Step_Name__c = CSWXGlobalConstant.G5_Contract_Bypass;
				approvalRequest.Apttus_Approval__StepLabel__c = CSWXGlobalConstant.G5_Contract_Bypass;
				approvalRequest.Apttus_Approval__ProcessInstanceId__c = appInstanceOptty.get(approvalHistory.Apttus_Approval__Related_Opportunity__c).Id;
				approvalRequest.Apttus_Approval__Approver_Comments__c =  CSWXGlobalConstant.APPROVER_COMMENTS+ System.now();
				approvalRequest.Apttus_Approval__DateApproved__c =  System.now();
			}
			else if(gateName.equalsignorecase(CSWXGlobalConstant.G5_WIN_PHASE ) )
			{
				approvalRequest.Apttus_Approval__Step_Name__c = CSWXGlobalConstant.Win_Declaration;
				approvalRequest.Apttus_Approval__StepLabel__c = CSWXGlobalConstant.Win_Declaration;
				approvalRequest.Apttus_Approval__ProcessInstanceId__c = appInstanceOptty.get(approvalHistory.Apttus_Approval__Related_Opportunity__c).Id;
				approvalRequest.Apttus_Approval__Approver_Comments__c =  CSWXGlobalConstant.APPROVER_COMMENTS+ System.now();
				approvalRequest.Apttus_Approval__DateApproved__c =  System.now();
			}
			else if(gateName.equalsignorecase(CSWXGlobalConstant.G6_BYPASS ))
			{
				approvalRequest.Apttus_Approval__Step_Name__c = CSWXGlobalConstant.Gate_6_Bypass;
				approvalRequest.Apttus_Approval__StepLabel__c = CSWXGlobalConstant.Gate_6_Bypass;
				approvalRequest.Apttus_Approval__ProcessInstanceId__c = appInstanceOptty.get(approvalHistory.Apttus_Approval__Related_Opportunity__c).Id;
				approvalRequest.Apttus_Approval__Approver_Comments__c =  CSWXGlobalConstant.APPROVER_COMMENTS+ System.now();
				approvalRequest.Apttus_Approval__DateApproved__c =  System.now();
			}
			requestList.add(approvalRequest);
			}
		if(! approvalDataHistory.isEmpty()){
		   Database.SaveResult[] lsr = Database.insert(approvalDataHistory);   
		}   
		if(! requestList.isEmpty()){
		   Database.SaveResult[] lsr = Database.update(requestList,false);   
		}   
		
				
																   

	  }
	  catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREProposalHelper,CSWXGlobalConstant.updateApprovalHistory);
			   
		   }
	  
	   
   } 
 
}