/**
 * @name	NF_ApprovalEmailCheck 
 * @author   
 * @since   July 08, 2017
 * @desc	This class helps to check the who is the  approval emails and as per that records will approve
 * @history 
 */

global class NF_ApprovalEmailCheck implements Messaging.InboundEmailHandler {

   global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
	Messaging.InboundEnvelope envelope) {
	String emaildata;
	Map<ID,ID> Currentuser =new Map<ID,ID>();
	Map<ID,ID> ApproverUser =new Map<ID,ID>();
	List<ID> Compareinfo = new List<ID>();
	
	String replypath=email.fromAddress;
	String ApprovalStatus;
	
	for(user userinfo:[select id from user where email=:replypath ])
	Currentuser.put(userinfo.id,userinfo.id);
	
	  String emailBody = email.plainTextBody.replaceAll( '\\s+', '').split('ApprovalRequestID:')[1];
	  System.debug('Loop EMail Data==='+emailBody );
	   String emailid=emailBody.substring(0,18).replaceAll( '\\s+', '');
	   
	   System.debug('Loop Rec ID---'+emailid);
	
	
	Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
	 
	
	  //String emailid=email.subject.replaceAll( '\\s+', '').replaceAll('-SubmityourDecision','').replaceAll('Approved','').replaceAll('Rejected','');

	System.debug('Loop EMail Info'+emailid);
	Id opptyId;
	for(Apttus_Approval__Approval_Request__c ApprovalData:[select id,Delegate_Approvers__c,Apttus_Approval__Related_Opportunity__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__DelegateApproverIds__c,Apttus_Approval__Assigned_To_Id__c,NF_Assignee_Type__c from Apttus_Approval__Approval_Request__c where NF_Assignee_Type__c='Approver'AND (id=:emailid)])
	{
	  ApproverUser.put(ApprovalData.Apttus_Approval__Assigned_To_Id__c,ApprovalData.Apttus_Approval__Assigned_To_Id__c);
	  opptyId = ApprovalData.Apttus_Approval__Related_Opportunity__c;
	  if(ApprovalData.Apttus_Approval__DelegateApproverIds__c!=null){
		String[] delegateApproverIds = ApprovalData.Apttus_Approval__DelegateApproverIds__c.split(',');
		for (string delegateapproverId: delegateApproverIds) {
		  ApproverUser.put(delegateapproverId,delegateapproverId);
		}

	}
  
 
  
  System.debug('Loop Approval Loop Rec'+ApprovalData);
  
 }
 
 System.debug('Loop Approver Info'+ApproverUser);
  System.debug('Loop user Info'+Currentuser);
 
 
 for(ID Usercheck:ApproverUser.values())
 {
   if(Usercheck.equals(Currentuser.get(Usercheck)))
   Compareinfo.add(Usercheck);
 
 }
 
 if(Compareinfo.size()>0 ){
  try{
	SavePoint sp  = Database.setSavepoint();
	system.debug('Get into Apttus Package');
	Apttus_Approval.ApprovalEmailHandler obj =new Apttus_Approval.ApprovalEmailHandler();
	obj.handleInboundEmail(email,envelope);
	System.debug('Loop Result'+result.message);
	System.debug('Loop ==='+result);

	Opportunity opp = [Select Name, Opportunity_ID__c, Phase_Status__c, Apttus_Approval__Approval_Status__c FROM Opportunity Where Id =: opptyId][0];
	List<Apttus_Approval__Approval_Request__c> approvalList = [select id,Delegate_Approvers__c,Apttus_Approval__Related_Opportunity__c,Apttus_Approval__Approval_Status__c,Apttus_Approval__DelegateApproverIds__c,Apttus_Approval__Assigned_To_Id__c,NF_Assignee_Type__c from Apttus_Approval__Approval_Request__c where NF_Assignee_Type__c='Approver'AND Apttus_Approval__Related_Opportunity__c =: opptyId];
	Boolean isFinalApproval = false;
	Integer appCount = 0;
	system.debug(approvalList.size());
	if(approvalList.size() > 1){
	  for(Apttus_Approval__Approval_Request__c approvalRequest : approvalList){
		if(approvalRequest.Apttus_Approval__Approval_Status__c == 'Approved'){
		   appCount = appCount+1;
		}
	  }
		if(approvalList.size()==appCount){
		  isFinalApproval = true;
		}
	}
	if(approvalList.size() == 1){
	  isFinalApproval = true;
	}
	system.debug(opp.Apttus_Approval__Approval_Status__c + '@@@@' + isFinalApproval);
	if(opp.Apttus_Approval__Approval_Status__c == 'Pending Approval' && isFinalApproval){
	  Database.rollback(sp);
	  Exception__c excLog = new Exception__c(
			Class__c = 'NF_ApprovalEmailCheck',
			Message__c = 'Email approval failed for Opportunity: ' + opp.Opportunity_ID__c,
			Method__c = 'handleInboundEmail'
			);
	  database.insert(excLog);
	  //result.message = 'Your email approval faield - Opportunity Name: ' + opp.Name + ', Opportunity Id: ' + opptyId + ', please try to approve in the Approval Center and contact SDC-Salesforce-Support <sdc-salesforce-support@groups.nokia.com> if you have any queries.';
	  String[] ccAddress = new String[]{'00541000002b4MH'};
	  String[] toAddress = Currentuser.values();
	  string textMessgae;
	  textMessgae = 'Your email approval could not processed for: Opportunity Name: ' + opp.Name + ', Opportunity Number: ' + opp.Opportunity_ID__c + '\n';
	  textMessgae = textMessgae + '\nPlease approve from within sCRM on the opportunity Approval Center: ' + Label.rebateFormURL + opp.Id + '\n';
	  textMessgae = textMessgae + '\nPlease submit a SF Support Ticket if you continue to have issues.'; 
	  Messaging.SingleEmailMessage singleMessage = new Messaging.SingleEmailMessage();
	  singleMessage.setToAddresses(toAddress);
	  singleMessage.setCcAddresses(ccAddress);
	  singleMessage.setPlainTextBody(textMessgae);
	  singleMessage.setSubject('NOTICE: Email approval submission error');
	  singleMessage.setSenderDisplayName('noreply@salesforce.com');
	  Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {singleMessage};
	  Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
	}
  }catch(Exception ex){
	result.message = ex.getMessage();
	System.debug('Loop Result'+result.message);
  }

 return result;

 }
 
 else if(Compareinfo.size()<=0)
 result.message='You are not authorized to perform any Approval action';
 
	 
	return result ;
   
	
	}
  
  
}