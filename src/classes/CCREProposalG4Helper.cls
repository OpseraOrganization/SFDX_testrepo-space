/*******************************
	Created by: Accenture
	Last modified by: Accenture
	Description: This helper class runs logics written on Proposal Trigger
	*******************************/
Public without sharing Class CCREProposalG4Helper implements Queueable {
	List<Id> oppid = new List<Id>();
	Map<Id,Apttus_Proposal__Proposal__c > quoteMap;
	
	/*******************************
	Created by: Accenture
	Last modified by: Accenture
	Description: Method for created the Queueable Context
	*******************************/
	public void execute(QueueableContext context) {
			
		try
			{
			   if(!oppId.isEmpty()){
				 CCREProposalG4Helper.byPassG4(oppId);
			   }
							 
			   }
			  catch(Exception ex){
					  ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREProposalHelper,CSWXGlobalConstant.CCREexecute );  
				   }	  

			  }
	
 /*******************************
	Created by: Accenture
	Last modified by: Accenture
	Description: Constructor for this class
	*******************************/   
		public CCREProposalG4Helper(List<Id > oppId  ) {
			this.Oppid = oppid;
			   }
	
	/*******************************
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is run to bypass G4 logic
	*******************************/
	public static void byPassG4(List<Id> oppId ) {
 
	List<Opportunity> OpptyUpdate= new List<Opportunity>();
		try{   
		system.debug('beforeUpdateinG4Bypassbeforequery'+Limits.getQueries()); 
			for(Opportunity opp : [select id,SWx_Upsell_Proposal__c ,Apttus_Approval__Approval_Status__c,ApprovalStatusTechField__c,G2_Approval_Date__c,
							 StageName,Phase_Status__c,G4_Approval_Date__c from Opportunity where id=:oppId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows()) ])
			{
				if(opp.SWx_Upsell_Proposal__c <> null){
				opp.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
				opp.ApprovalStatusTechField__c = CSWXGlobalConstant.G4_APPROVAL_TECH;
				opp.StageName = CSWXGlobalConstant.WIN_THE_CASE_NEGOTIATE   ;
				opp.Phase_Status__c = CSWXGlobalConstant.OFFER_SUBMITTED;
				opp.G4_Approval_Date__c = System.now();
				}
				
				OpptyUpdate.add(opp);					   
			}
			system.debug('beforeUpdateinG4Bypass');
			if(OpptyUpdate.size()>0){
			system.debug('beforeUpdateinG4Bypass'+Limits.getQueries());
			   database.update(OpptyUpdate,false);
			   system.debug('afterUpdate'+Limits.getQueries());	}
			   system.debug('beforeapprovalHistory'+Limits.getQueries());
			updateOpportunityApprovalHistory( oppId,CSWXGlobalConstant.G4_BYPASS);
			system.debug('afterapprovalHistory'+Limits.getQueries());	   
		}  
		   
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREPROPOSALG4HELPER, CSWXGlobalConstant.byPassG4 );
			   
		}  
		 

 }   
	/*******************************
	Created by: Accenture
	Last modified by: Accenture
	Description: This method is run to update Approval History
	*******************************/
	public static void updateOpportunityApprovalHistory(List<Id> oppId,  String gateName) {
	   List<Apttus_Approval__ApprovalProcessInstance__c> approvalInstanceList = new List<Apttus_Approval__ApprovalProcessInstance__c>();
	   Apttus_Approval__ApprovalProcessInstance__c approvalInstanceG4;
	   Apttus_Approval__ApprovalProcessInstance__c approvalInstanceG3;
	   List<Apttus_Approval__Approval_Request__c> requestList = new List<Apttus_Approval__Approval_Request__c>();
	   List<Apttus_Approval__Approval_Request_History__c> approvalDataHistory=new List<Apttus_Approval__Approval_Request_History__c>(); 
	   Map<Id,Apttus_Approval__ApprovalProcessInstance__c > appInstanceOpttyG3 = new Map<Id, Apttus_Approval__ApprovalProcessInstance__c>();
	   Map<Id,Apttus_Approval__ApprovalProcessInstance__c > appInstanceOpttyG4 = new Map<Id, Apttus_Approval__ApprovalProcessInstance__c>();
	   Apttus_Approval__Approval_Request_History__c approvalhistory;
	   Map<String,Apttus_Approval__Approval_Process__c> appProcessMap = new Map<String,Apttus_Approval__Approval_Process__c>();
	  try{
		for(Apttus_Approval__Approval_Process__c appProcess : [Select Apttus_Approval__Process_Name__c,id,Apttus_Approval__Object_Type__c from Apttus_Approval__Approval_Process__c  where Apttus_Approval__Process_Name__c like: gateName OR Apttus_Approval__Process_Name__c like: CSWXGlobalConstant.G3_BYPASS LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
		{
			appProcessMap.put(appProcess.Apttus_Approval__Process_Name__c,appProcess);
		}
		system.debug('appProcessMap>>'+appProcessMap);
		//create approval process instance object for present gate
		for(Id opptyid : oppId)
		{
		  approvalInstanceG4 = new Apttus_Approval__ApprovalProcessInstance__c();
		  approvalInstanceG4.Apttus_Approval__BusinessObjectId__c= opptyid;
		  approvalInstanceG4.Apttus_Approval__BusinessObjectType__c = appProcessMap.get(gateName).Apttus_Approval__Object_Type__c;
		  approvalInstanceG4.Apttus_Approval__ApprovalProcessId__c =  appProcessMap.get(gateName).id;
		  approvalInstanceG4.Apttus_Approval__Status__c = CSWXGlobalConstant.Approval_stage_approved;
		  approvalInstanceG4.Name = gateName;
		  approvalInstanceList.add(approvalInstanceG4);
		  
		  approvalInstanceG3 = new Apttus_Approval__ApprovalProcessInstance__c();
		  approvalInstanceG3.Apttus_Approval__BusinessObjectId__c= opptyid;
		  approvalInstanceG3.Apttus_Approval__BusinessObjectType__c =  appProcessMap.get(CSWXGlobalConstant.G3_BYPASS).Apttus_Approval__Object_Type__c;
		  approvalInstanceG3.Apttus_Approval__ApprovalProcessId__c =  appProcessMap.get(CSWXGlobalConstant.G3_BYPASS).id;
		  approvalInstanceG3.Apttus_Approval__Status__c = CSWXGlobalConstant.Approval_stage_approved;
		  approvalInstanceG3.Name = CSWXGlobalConstant.G3_BYPASS;
		  approvalInstanceList.add(approvalInstanceG3);
		}
		system.debug('approvalInstanceList>>'+approvalInstanceList);
		if(!approvalInstanceList.isEmpty())
		{
			Database.insert(approvalInstanceList);
		}
	
		for(Apttus_Approval__ApprovalProcessInstance__c appprocessInstance : [SELECT id,Apttus_Approval__BusinessObjectId__c,Name from Apttus_Approval__ApprovalProcessInstance__c where Apttus_Approval__BusinessObjectId__c in : oppId and (name like: gateName or name like: CSWXGlobalConstant.G3_BYPASS ) LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
		{
			if(appprocessInstance.Name.equalsIgnoreCase(CSWXGlobalConstant.G3_BYPASS))
				appInstanceOpttyG3.put(appprocessInstance.Apttus_Approval__BusinessObjectId__c, appprocessInstance);
			else {
				if(appprocessInstance.Name.equalsIgnoreCase(gateName))
				appInstanceOpttyG4.put(appprocessInstance.Apttus_Approval__BusinessObjectId__c, appprocessInstance);
			}
		}
		system.debug('appInstanceOpttyG4>>'+appInstanceOpttyG4);	   
		
		
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
			approvalHistory.Apttus_Approval__ProcessInstanceId__c = appInstanceOpttyG3.get(approvalHistory.Apttus_Approval__Related_Opportunity__c).Id;
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
			if(gateName.equalsignorecase(CSWXGlobalConstant.G4_APPROVAL_BYPASS ) )
			{
				approvalRequest.Apttus_Approval__Step_Name__c = CSWXGlobalConstant.G4_BYPASS_PROCESS;
				approvalRequest.Apttus_Approval__StepLabel__c = CSWXGlobalConstant.G4_BYPASS_PROCESS;
				approvalRequest.Apttus_Approval__ProcessInstanceId__c = appInstanceOpttyG4.get(approvalHistory.Apttus_Approval__Related_Opportunity__c).Id;
				approvalRequest.Apttus_Approval__Approver_Comments__c =  CSWXGlobalConstant.APPROVER_COMMENTS+ System.now();
				approvalRequest.Apttus_Approval__DateApproved__c =  System.now();
				approvalRequest.Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Notified ;
			}
		   
			requestList.add(approvalRequest);
			}
			system.debug('approvalDataHistory>>'+approvalDataHistory);
			system.debug('requestList>>'+requestList);
		if(! approvalDataHistory.isEmpty()){
			
		   Database.SaveResult[] lsr = Database.insert(approvalDataHistory);   
		}   
		if(! requestList.isEmpty()){
		   Database.SaveResult[] lsr = Database.update(requestList,false);   
		}   
		
				
																   

	  }
	  catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.CCREPROPOSALG4HELPER,CSWXGlobalConstant.UPDATE_HISTORY);
			   
		   }
	  
	   
   }  
 
}