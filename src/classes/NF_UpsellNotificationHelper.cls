/*******************************
Class Name: NF_UpsellNotificationHelper
Created By: Accenture 20-Sep 2018
Last Modified By: 
Last Modified Date:  
Description: Helper Class for Opportunity Trigger to notify Upsell Approvers when delta is updated
*******************************/
public class NF_UpsellNotificationHelper {
	
	/*****************************
*Method Name: notifyUpsellApprovers
*Description: This method is used to fetch Approvers when delta is changed
*Parameters: Opportunity List, Opportunity Map
*Created By: Accenture 20-Sep 2018
*Last Modified By: 
*Last Modified Date:  
*******************************/
	public static void notifyUpsellApprovers(Map<Id, Opportunity> oppNewMap, Map<Id, Opportunity> oppOldMap){
		
		List<Committed_Upsell_Configuration__mdt> mdList = new List<Committed_Upsell_Configuration__mdt>();
		Map<String, List<Committed_Upsell_Configuration__mdt>> metaDataMap = new Map<String, List<Committed_Upsell_Configuration__mdt>>();
		set<String> roleCodeSet = new set<String>();
		set<String> orgL2 = new set<String>();
		set<String> orgL3 = new set<String>();
		set<String> orgL4 = new set<String>();
		set<String> orgL5 = new set<String>();
		set<String> orgL6 = new set<String>();
		set<String> orgL7 = new set<String>();
		set<String> bgSet = new set<String>();
		List<Sales_Role__c> srList = new List<Sales_Role__c>();
		Map<Id, Id> userOppMap = new Map<Id,Id>();
		set<String> userOppset = new set<String>();
		set<Id> oppIdSet = new set<Id>();
		string empty = '';
		String bgValue = null;
		List<String> bgValue_List = new List<String>();
		List<Opportunity> opptyList = new List<opportunity>();
		Map<Id, Decimal> oppValueMap = new Map<Id,Decimal>();
		
	   if(GlobalConstants.NOTIFY_UPSELL_APPROVER == FALSE) 
	   {
		   if(!test.isRunningTest())
			GlobalConstants.NOTIFY_UPSELL_APPROVER = TRUE;
		try
		{
			//System.debug('inside notifyUpsellApprovers-UK');
			for(Committed_Upsell_Configuration__mdt metaData : [Select Lead_BG__c, Sales_Role__c, Sales_Role_Code__c, Upsell_Delta_Lower_Limit__c, Upsell_Delta_Upper_Limit__c
																FROM Committed_Upsell_Configuration__mdt])
			{
				//System.debug('Inside metadata UK');
				if(metaDataMap.containsKey(metaData.Lead_BG__c)){
					List<Committed_Upsell_Configuration__mdt> metaList = metaDataMap.get(metaData.Lead_BG__c);
					metaList.add(metaData);
					metaDataMap.put(metaData.Lead_BG__c, metaList);
				}
				else{
					metaDataMap.put(metaData.Lead_BG__c, new List<Committed_Upsell_Configuration__mdt>{metaData});
				}
			}
			//System.debug('MetadataMap::> '+metaDataMap);
			bgValue = System.Label.NF_Upsell_BG;
			bgValue_List.addAll(bgValue.split(GlobalConstants.COMMA));
			//System.debug('bgValue_List::> '+bgValue_List);
			
			for(Opportunity opp : oppNewMap.values()){
				system.debug('###Unweighted_Amount_EUR__c-->'+opp.Unweighted_Amount_EUR__c);
				system.debug('###delta-->'+opp.Upsell_Delta__c);
				 system.debug('###deltaold-->'+oppOldMap.get(opp.Id).Upsell_Delta__c);
				if(opp.Upsell_Delta__c <> NULL && (oppOldMap.get(opp.Id).Upsell_Delta__c <> opp.Upsell_Delta__c) && (oppOldMap.get(opp.Id).Upsell_Delta__c > opp.Upsell_Delta__c))
				{
					mdList = metaDataMap.get(opp.Lead_BG__c);
					Decimal comValue = 0;				
					comValue = (-(integer.valueOf(System.Label.NF_Upsell_Percent)*(opp.Committed_Unweighted_Value_in_EUR__c))/GlobalConstants.NF_DIVIDE);
					oppValueMap.put(opp.Id,comValue);
					//System.debug('oppValueMap::> '+oppValueMap);
					if((bgValue_List.contains(opp.Lead_BG__c) && opp.Upsell_Delta__c < oppValueMap.get(opp.Id)) || !(bgValue_List.contains(opp.Lead_BG__c)))
					{
						for(Committed_Upsell_Configuration__mdt mdata : mdList){
							if((opp.Upsell_Delta__c <= mdata.Upsell_Delta_Lower_Limit__c && opp.Upsell_Delta__c >= mdata.Upsell_Delta_Upper_Limit__c)
							   &&!(oppOldMap.get(opp.Id).Upsell_Delta__c <= mdata.Upsell_Delta_Lower_Limit__c && oppOldMap.get(opp.Id).Upsell_Delta__c >= mdata.Upsell_Delta_Upper_Limit__c))
							{
								//System.debug('inside sets -UK');
								roleCodeSet.add(mdata.Sales_Role_Code__c);
								bgSet.add(mdata.Lead_BG__c);
								oppIdSet.add(opp.Id);
								orgL2.add(opp.Org_L2__c);
								orgL3.add(opp.Org_L3__c);
								orgL4.add(opp.Org_L4__c);
								orgL5.add(opp.Org_L5__c);
								orgL6.add(opp.Org_L7__c);
								orgL7.add(opp.Org_L7__c);
							}
						} 
					}
				}
			}
			
			//System.debug('sets::> '+roleCodeSet+'oppId::> '+oppIdSet+'bgSet::> '+bgSet);
			//System.debug('orgL2::> '+orgL2+'orgL3::> '+orgL3+'orgL4::> '+orgL4);
			if(!roleCodeSet.isEmpty() && !oppIdSet.isEmpty())
			{
				//System.debug('Inside SR query::> ');
				srList = [SELECT Id,User__c,Organisation__c FROM Sales_Role__c WHERE Role_Code__c IN:roleCodeSet AND
						  BG__c IN: bgSet AND
						  (Organisation__c IN: orgL2 OR
						   Organisation__c IN: orgL3 OR
						   Organisation__c IN: orgL4 OR 
						   Organisation__c IN: orgL5 OR 
						   Organisation__c IN: orgL6 OR 
						   Organisation__c IN: orgL7)];
			}
			//System.debug('SRLISt::> '+srList);
			if(!srList.isEmpty())
			{
				for(Id oppId : oppIdSet){
					for(Sales_Role__c sr : srList){
						//System.debug('inside map -UK');
						userOppMap.put(sr.User__c,oppId);
						userOppSet.add(sr.User__c + GlobalConstants.COMMA + oppId);
					}
				}
			}
			
			for (Apttus_Approval__Backup_Approver__c delegateInfo:[select id,Apttus_Approval__Current_User__c,Delegate_Approver1__c,Delegate_Approver2__c,Delegate_Approver3__c,Apttus_Approval__Backup_User__c from Apttus_Approval__Backup_Approver__c where Apttus_Approval__IsActive__c=true and Apttus_Approval__InEffect__c=true and  Apttus_Approval__Current_User__c=:userOppMap.Keyset() LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
			{
				//System.debug('inside delegates -UK');
				if(userOppMap.containsKey(DelegateInfo.Apttus_Approval__Current_User__c)){
					
					if(DelegateInfo.Delegate_Approver1__c<>NUll){
						userOppMap.put(DelegateInfo.Delegate_Approver1__c,userOppMap.get(DelegateInfo.Apttus_Approval__Current_User__c));
						userOppSet.add(DelegateInfo.Delegate_Approver1__c+ GlobalConstants.COMMA +userOppMap.get(DelegateInfo.Apttus_Approval__Current_User__c));
					}
					if(DelegateInfo.Delegate_Approver2__c<>NUll){
						userOppMap.put(DelegateInfo.Delegate_Approver2__c,userOppMap.get(DelegateInfo.Apttus_Approval__Current_User__c));
						userOppSet.add(DelegateInfo.Delegate_Approver2__c+ GlobalConstants.COMMA +userOppMap.get(DelegateInfo.Apttus_Approval__Current_User__c));
					}
					if(DelegateInfo.Delegate_Approver3__c<>NUll){
						userOppMap.put(DelegateInfo.Delegate_Approver3__c,userOppMap.get(DelegateInfo.Apttus_Approval__Current_User__c));
						userOppSet.add(DelegateInfo.Delegate_Approver3__c+ GlobalConstants.COMMA +userOppMap.get(DelegateInfo.Apttus_Approval__Current_User__c));
					}
					if(DelegateInfo.Apttus_Approval__Backup_User__c<>NUll){					
						userOppMap.put(DelegateInfo.Apttus_Approval__Backup_User__c,userOppMap.get(DelegateInfo.Apttus_Approval__Current_User__c));
						userOppSet.add(DelegateInfo.Apttus_Approval__Backup_User__c+ GlobalConstants.COMMA +userOppMap.get(DelegateInfo.Apttus_Approval__Current_User__c));
					}
				}   
			}  
			
			if(!userOppset.isEmpty() )
				{	 
					set<String> MasteroppApproverset = new set<String>();
					MasteroppApproverset=FindMasterOppApprovers(oppIdSet);
					  //userOppset.addAll(MasteroppApproverset);
					//System.debug('Calling mail method::> '+userOppset);
					sendEmailtoUpsellApprovers(userOppset , MasteroppApproverset);
				}
			
			If(!oppIdSet.isEmpty())
			{
				for(Opportunity opty : [Select Id, Upsell_Change_Accepted__c,Upsell_Change_Approved_by__c, Name FROM Opportunity
										Where Id IN:oppIdSet])
				{
					//System.debug('Inside Upsell Clear::> ');
					opty.Upsell_Change_Accepted__c=False;
					opty.Upsell_Change_Approved_by__c=empty;
					opptyList.add(opty);
				}
			}
			//System.debug('opptyList::> '+opptyList);
			if(!opptyList.isEmpty())
				Database.update(opptyList);
			
		}
		catch(exception ex)
		{
			//System.debug('Upsell Exception::> '+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.NF_UPSELLNOTIFICATIONHELPER, GlobalConstants.METHOD_NOTIFY_UPSELL_APPROVERS);
		}
	}
	}
	
	/*****************************
*Method Name: 
*Description: This method is sent email to the Approvers for change in Upsell delta
*Parameters: Opportunity List, Opportunity Map
*Created By: Accenture 20-Sep 2018
*Last Modified By: 
*Last Modified Date:
*******************************/
	public static void sendEmailtoUpsellApprovers(Set<String> emailset , Set<String> MasterOpp_Approverset){
		
		Map<Id,Id> emailMap = new Map<Id,Id>();
		List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
		Map<Id,Id> ApproverMap = new Map<Id,Id>();
		Map<Id,List<String>> MasterMap = new Map<Id,List<String>>();
		
		try
		{
			EmailTemplate et=[SELECT Id FROM EmailTemplate WHERE developerName =:Label.NF_UpsellApproverNotification LIMIT 1];
			
			for(String mapValue : emailset){
				emailMap.put(mapValue.substringBefore(GlobalConstants.COMMA).Trim(),mapValue.substringAfter(GlobalConstants.COMMA).Trim());
			}
			// System.debug('emailMap::> '+emailMap);
			
			for(String appset : MasterOpp_Approverset)
			{
	ApproverMap.put(appset.substringBefore(GlobalConstants.COMMA).Trim(),appset.substringAfter(GlobalConstants.COMMA).Trim());
			}
			
			for(User userdata : [Select Id, Email from User where Id IN:ApproverMap.keyset()])
			{
	if(MasterMap.containsKey(ApproverMap.get(userdata.Id)))
	{
		List<String> emailList = MasterMap.get(ApproverMap.get(userdata.Id));
		emailList.add(userdata.email);
		MasterMap.put(ApproverMap.get(userdata.Id),emailList);
	}
	else 
	{
		MasterMap.put(ApproverMap.get(userdata.Id), new List<String>{userdata.email});
	}
			}
			for(id email :emailMap.Keyset())
			{
				//System.debug('inside email -UK');
				Messaging.SingleEmailMessage GateparticipentsEmail = new Messaging.SingleEmailMessage();
				
				GateparticipentsEmail.setWhatId(emailMap.get(email));
				//System.debug('whatID::> '+emailMap.get(email));
				GateparticipentsEmail.setTargetObjectId(email);
				//System.debug('Target::> '+email);
				GateparticipentsEmail.setCcAddresses(MasterMap.get(emailMap.get(email)));
				System.debug('setCcAddresses::> '+MasterMap.get(emailMap.get(email)));
				GateparticipentsEmail.setTemplateId(et.id);
				GateparticipentsEmail.setSaveAsActivity(false);
				mailList.add(GateparticipentsEmail);
				
			}
			// System.debug('mailList::> '+mailList);
			if(!mailList.isEmpty()){
				System.debug('inside final -UK');
				//GlobalConstants.NOTIFY_UPSELL_APPROVER = TRUE;
				Messaging.SendEmailResult[] results=Messaging.sendEmail(mailList);   
				//System.debug('Email Result--->'+results);
			}
		}
		catch(exception ex)
		{
			//System.debug('exception-UK::> '+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.NF_UPSELLNOTIFICATIONHELPER, GlobalConstants.METHOD_SENDEMAIL_TO_UPSELL_APPROVERS);
		}
		
	}
	
	
	 /*****************************
*Method Name: FindMasterOppApprovers
*Description: This method is used to fetch master opportunity Approvers when delta is changed
*Parameters: Opportunity List, Opportunity Map
*Created By: Accenture 09-nov 2018
*Last Modified By: 
*Last Modified Date:  
*******************************/
	public static Set<String>  FindMasterOppApprovers(Set<Id> OppIDSET){
		 
		set<String> MasterOpp_Approverset = new set<String>();
		set<Opportunity> MAsterOppset = new set<Opportunity>();
		map<string,string> DealOpp_MAp=new map<string,string>(); 
		map<string,string> masterOpp_submap=new map<string,string>();
		 map<Id,Opportunity> masterOppval=new map<Id,Opportunity>();
		  
	   try
		{ 
		for(Opportunity_Group__c oppgrpRec : [Select id, Opportunity__c,Deal__c,Deal__r.RecordType.Name from Opportunity_Group__c 
														where Opportunity__c IN:OppIDSET
														and Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL
												 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				DealOpp_MAp.put(oppgrpRec.Deal__c,oppgrpRec.Opportunity__c);
			}
		
		 for(Opportunity_Group__c oppgrp_Rec : [Select id, Opportunity__c,Opportunity_Relation__c,Deal__c,Deal__r.RecordType.Name from Opportunity_Group__c 
														where Deal__c IN:DealOpp_MAp.keyset()
														and Deal__r.RecordType.Name =: GlobalConstants.UPSELL_DEAL and Opportunity_Relation__c =: Globalconstants.MASTER
												 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				if(DealOpp_MAp.containskey(oppgrp_Rec.Deal__c))
				masterOpp_submap.put(oppgrp_Rec.Opportunity__c,DealOpp_MAp.get(oppgrp_Rec.Deal__c));
			}
		
		   for(Opportunity Opp:[Select id ,Business_Type__c,StageName,Phase_Status__c from Opportunity where (StageName!=:GlobalConstants.IDENTIFY_OPPORTUNITY AND StageName!=:GlobalConstants.DEVELOP_OPPORTUNITY AND StageName!=:GlobalConstants.CREATE_OFFER) AND id IN:masterOpp_submap.keyset()
												 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])  
		   {
			   MAsterOppset.add(Opp);
		   }
		//system.debug('MAsterOppset++>'+MAsterOppset);
		
		Apttus_Approval__Approval_Request__c[] approvalRequestListval = [SELECT ID,Apttus_Approval__Date__c ,Apttus_Approval__ProcessInstanceId__r.Apttus_Approval__Status__c,Apttus_Approval__Assigned_To_Type__c,Apttus_Approval__Backup_From_User__c,Apttus_Approval__ProcessInstanceId__r.Name,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__Step_Name__c,NF_Assignee_Type__c,Apttus_Approval__Approval_Status__c, Apttus_Approval__Object_Id__c, Apttus_Approval__DelegateApproverIds__c
															   FROM Apttus_Approval__Approval_Request__c
															   WHERE  (Apttus_Approval__ProcessInstanceId__r.Name=:Globalconstants.G4_APPROVALS OR Apttus_Approval__ProcessInstanceId__r.Name=:Globalconstants.G5_CONTRACT_APPROVALS) AND (Apttus_Approval__Object_Id__c IN:masterOpp_submap.keyset() AND Apttus_Approval__Assigned_To_Id__c<>Null AND NF_Assignee_Type__c<>Null AND NF_Assignee_Type__c=:GlobalConstants.APPROVER) LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
		 
		

	system.debug('approvalRequestListval++>'+approvalRequestListval);		
	   for(Opportunity Masteropp:MAsterOppset)
		  {   set<String> Approver_set = new set<String>();
			  integer countApprover=0;
			  integer countApproved=0;
		   if((!Masteropp.StageName.equalsignorecase(Globalconstants.WIN_THE_CASE_NEGOTIATE))||approvalRequestListval.isempty() ) 
				   countApprover=countApprover+1;
					
			  for(Apttus_Approval__Approval_Request__c ApprovalReqval: approvalRequestListval)
			{  
				if(Masteropp.id==ApprovalReqval.Apttus_Approval__Object_Id__c&&Masteropp.StageName.equalsignorecase(Globalconstants.WIN_THE_CASE_NEGOTIATE))
				{	
					Approver_set.add(ApprovalReqval.Apttus_Approval__Assigned_To_Id__c+GlobalConstants.COMMA + masterOpp_submap.get(Masteropp.id));
					
					if (ApprovalReqval.Apttus_Approval__DelegateApproverIds__c != null) {
				String[] delegateApproverIds = ApprovalReqval.Apttus_Approval__DelegateApproverIds__c.split(GlobalConstants.COMMA);
				for (string delegateapproverId: delegateApproverIds) {
				 Approver_set.add(delegateapproverId+GlobalConstants.COMMA + masterOpp_submap.get(Masteropp.id));
					   }
					}
					  countApprover=countApprover+1;
					 if (ApprovalReqval.Apttus_Approval__Approval_Status__c.equalsignorecase(GlobalConstants.APPROVED) )
					 countApproved=countApproved+1;
				}
			}
			  if(countApprover==countApproved)
				  MasterOpp_Approverset.addAll(Approver_set);
		   
		   if(countApprover!=countApproved)
				 masterOppval.put(Masteropp.id,Masteropp);
		   
			  
		  }
		
	 //  system.debug('masterOppval++>'+masterOppval);
	   Apttus_Approval__Approval_Request_History__c[] ApprovalReqhistory = [  SELECT id,createddate ,Apttus_Approval__DelegateApproverIds__c,Apttus_Approval__Active__c,Apttus_Approval__Approval_Process__c, Apttus_Approval__ProcessInstanceId__r.Apttus_Approval__Status__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__Date__c ,Apttus_Approval__Object_Id__c,Apttus_Approval__ProcessInstanceId__r.Name,NF_Assignee_Type__c,Apttus_Approval__Assigned_To_Id__c FROM Apttus_Approval__Approval_Request_History__c
																			 where ((Apttus_Approval__ProcessInstanceId__r.Name=:Globalconstants.G4_APPROVALS OR Apttus_Approval__ProcessInstanceId__r.Name=:Globalconstants.G5_CONTRACT_APPROVALS) AND (Apttus_Approval__Object_Id__c  IN:masterOppval.keyset() AND Apttus_Approval__Assigned_To_Id__c<>Null AND NF_Assignee_Type__c<>Null AND NF_Assignee_Type__c=:GlobalConstants.APPROVER AND Apttus_Approval__Approval_Status__c=:GlobalConstants.APPROVED AND Apttus_Approval__Active__c=true))
												 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		   
  
			
			  for(Apttus_Approval__Approval_Request_History__c ApprovalReq_History: ApprovalReqhistory)
			{   
				if(ApprovalReq_History.Apttus_Approval__ProcessInstanceId__r.Apttus_Approval__Status__c.equalsignorecase(GlobalConstants.APPROVED))
				{
					
				 if(((masterOppval.get(ApprovalReq_History.Apttus_Approval__Object_Id__c).Phase_Status__c.equalsignorecase(Globalconstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL)||
					  (masterOppval.get(ApprovalReq_History.Apttus_Approval__Object_Id__c).Phase_Status__c.equalsignorecase(Globalconstants.SUBMITTED_FOR_G5_APPROVAL)))&&(masterOppval.get(ApprovalReq_History.Apttus_Approval__Object_Id__c).StageName.equalsignorecase(Globalconstants.WIN_THE_CASE_NEGOTIATE))&&ApprovalReq_History.Apttus_Approval__ProcessInstanceId__r.Name.equalsignorecase(Globalconstants.G4_APPROVALS)) ||((((masterOppval.get(ApprovalReq_History.Apttus_Approval__Object_Id__c).Phase_Status__c.equalsignorecase(Globalconstants.PENDING_WIN_LOSS_DECLARATION))&&(masterOppval.get(ApprovalReq_History.Apttus_Approval__Object_Id__c).StageName.equalsignorecase(Globalconstants.WIN_THE_CASE_NEGOTIATE))) ||(!masterOppval.get(ApprovalReq_History.Apttus_Approval__Object_Id__c).StageName.equalsignorecase(Globalconstants.WIN_THE_CASE_NEGOTIATE)))&&ApprovalReq_History.Apttus_Approval__ProcessInstanceId__r.Name.equalsignorecase(Globalconstants.G5_CONTRACT_APPROVALS)))
					  {  
						  MasterOpp_Approverset.add(ApprovalReq_History.Apttus_Approval__Assigned_To_Id__c+GlobalConstants.COMMA + masterOpp_submap.get(ApprovalReq_History.Apttus_Approval__Object_Id__c));
						  if (ApprovalReq_History.Apttus_Approval__DelegateApproverIds__c != null) {
					  String[] delegateApproverIds = ApprovalReq_History.Apttus_Approval__DelegateApproverIds__c.split(GlobalConstants.COMMA);
					  for (string delegateapproverId: delegateApproverIds) {
					  MasterOpp_Approverset.add(delegateapproverId+GlobalConstants.COMMA + masterOpp_submap.get(ApprovalReq_History.Apttus_Approval__Object_Id__c));
							 }
							}
					  }
				}
			}
			return MasterOpp_Approverset;
		}
	
  catch(exception ex)
		{
			System.debug('exception::> '+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.NF_UPSELLNOTIFICATIONHELPER, GlobalConstants.METHOD_SENDEMAIL_TO_UPSELL_APPROVERS);
				   return MasterOpp_Approverset;
		}
	}
}