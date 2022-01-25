/**
* Email services are automated processes that use Apex classes
* to process the contents, headers, and attachments of inbound
* email.
*/
global class NF_UpdateApproverStatus   implements Messaging.InboundEmailHandler {
	
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		String OpptyName;
		String OpptyInfo;
		String RequestID;
		String ApprovalCompletionDate;
		String emaildata;
		String ApprovalStatus;
		Map<ID,ID> ApproverUser =new Map<ID,ID>();
		Map<ID,ID> Currentuser =new Map<ID,ID>();
		Apttus_Approval__Approval_Request__c  Validatorinfo = new Apttus_Approval__Approval_Request__c();
		List<ID> Compareinfo = new List<ID>();
		// User Email address
		String replypath=email.fromAddress;
		Map<Id,String> UserTimeZone = new Map<Id,String>() ;
		String UserZone;
		// collecting the Current user ID
		for(user userinfo:[select id,TimeZoneSidKey  from user where email=:replypath ])
		{
			
			Currentuser.put(userinfo.id,userinfo.id);
			UserTimeZone.put(userinfo.ID,userinfo.TimeZoneSidKey);
		}
		
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		
		
		String emailsubject=email.subject;
		
		String Emailsubject1=email.subject.substring(0,9).replaceAll( '\\s+', '');
		
		String[] emailBody = email.plainTextBody.split('End of Comments',0);
		
		
		String emailid=emailsubject.replaceAll( '\\s+', '').replaceAll('-SubmityourDecision','').replaceAll('Approved','').replaceAll('Rejected','');
		
		System.debug('Loop--->'+emailid);
		
		emaildata=emailBody[0].replaceall('End of Comments','').replaceAll('Please do NOT edit the email subject.','').replaceAll('Please Enter the Comments Below','').replaceAll('Approver Comments:','').replaceAll('Rejection Comments:','');
		
		// Retriving the Data as per the ID
		for(Apttus_Approval__Approval_Request__c ApprovalData:[select id,Validation_Completion_Date__c,Apttus_Approval__Object_Name__c,Tech_Approval_Date__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__DelegateApproverIds__c,Apttus_Approval__Approver_Comments__c,Validator_Status__c from Apttus_Approval__Approval_Request__c where (id=:emailid) Limit 1 ])
		{
			
			if(ApprovalData.Validator_Status__c<>NUll)
				ApprovalStatus=ApprovalData.Validator_Status__c;
			ApproverUser.put(ApprovalData.Apttus_Approval__Assigned_To_Id__c,ApprovalData.Apttus_Approval__Assigned_To_Id__c);
			
			// collecting Delegates ID
			if(ApprovalData.Apttus_Approval__DelegateApproverIds__c!=null){
				String[] delegateApproverIds = ApprovalData.Apttus_Approval__DelegateApproverIds__c.split(',');
				for (string delegateapproverId: delegateApproverIds) {
					ApproverUser.put(delegateapproverId,delegateapproverId);
				}
			}
			
			if(Emailsubject1.contains('Approved')){
				ApprovalData.Validator_Status__c ='Validated';
				ApprovalData.Apttus_Approval__Approver_Comments__c=emaildata;
				
			}
			else if(Emailsubject1.contains('Rejected')) {
				ApprovalData.Validator_Status__c='Rejected';
				ApprovalData.Apttus_Approval__Approver_Comments__c=emaildata;
			}
			Validatorinfo=ApprovalData;
		}  
		
		
		//comaring the approver id and current user id
		for(ID Usercheck:ApproverUser.values())
		{
			if(Usercheck.equals(Currentuser.get(Usercheck))){
				
				Compareinfo.add(Usercheck);
				if(String.IsEmpty(ApprovalStatus)){  
					Validatorinfo.Apttus_Approval__Actual_Approver__c=Usercheck;
					Validatorinfo.Validation_Completion_Date__c=System.now();
				}
				
				if(UserTimeZone.get(Usercheck)<>NUll)
					UserZone=UserTimeZone.get(Usercheck);
			}
		}
		
		
		
		
		if(Compareinfo.size()>0 )
		{
			
			DateTime dT =Validatorinfo.Validation_Completion_Date__c;
			String Completiondate=dT.format('yyyy-MM-dd HH:mm:ss',UserZone);
			
			OpptyInfo= 'OpportunityName : '+Validatorinfo.Apttus_Approval__Object_Name__c+'\n'+'For more details, click the following link : '+Label.Email_URL+'/'+Validatorinfo.ID;
			
			
			try{
				if(String.IsEmpty(ApprovalStatus))
					update Validatorinfo;
				else  if(!String.IsEmpty(ApprovalStatus))
				{
					
					
					sendEmail(replypath,'Error : Validation Completion Error in '+Validatorinfo.Apttus_Approval__Object_Name__c,'Error : Validation Request Already Completed on '+ Completiondate+'\n'+OpptyInfo);
					
				}
				
			}
			catch(Exception e)
			{
				// parse the validation and send the correct error message to users
				if(e.getMessage().contains(','))
				{
					
					
					String[] ErrorMessageParse = e.getMessage().split(',');
					if(ErrorMessageParse[1].contains(':')){
						String ErrorMessage='Error :'+ErrorMessageParse[1].subString(0, ErrorMessageParse[1].lastIndexOf(':'));
						system.debug('--->'+ ErrorMessage);
						sendEmail(replypath,ErrorMessage+'in '+Validatorinfo.Apttus_Approval__Object_Name__c,ErrorMessage+'\n'+OpptyInfo);
						
						
					}else{
						
						
						String ErrorMessage='Error :'+ErrorMessageParse[1].subString(0, ErrorMessageParse[1].length()-4);
						System.debug('---'+ErrorMessage);
						sendEmail(replypath,ErrorMessage+'in '+Validatorinfo.Apttus_Approval__Object_Name__c,ErrorMessage+'\n'+OpptyInfo);
						
						
						
					}
				}
				else
					sendEmail(replypath,'Validation Completion Error in '+Validatorinfo.Apttus_Approval__Object_Name__c,e.getMessage()+'\n'+OpptyInfo);
				
				
				
			}
			
		}
		else if(Compareinfo.size()<=0){
			// Modified by Yang Quanyao For Support Ticket 00011976 on 2018 May 25
			if(String.isEmpty(Validatorinfo.Id)){
				sendEmail(replypath,email.subject + ' - not possible, new Gate was triggered for this opportunity','Was not possible to manage your validation request, new Gate was triggered for this opportunity.');
			}   
			else{
				OpptyInfo= 'OpportunityName : '+Validatorinfo.Apttus_Approval__Object_Name__c+'\n'+'For more details, click the following link : '+Label.Email_URL+'/'+Validatorinfo.ID;
			
				sendEmail(replypath,'Error : You are not authorized to perform any Validation action in '+Validatorinfo.Apttus_Approval__Object_Name__c,'Error : You are not authorized to perform any Validation action'+'\n'+OpptyInfo);
			}
		}
		return result;
		
	}
	
	public void sendEmail(String CurrentUseremail,String subLine,String bodyMsg)
	{
		try
		{
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {CurrentUseremail};
				mail.setToAddresses(toAddresses);
			mail.setSubject(subLine);
			mail.setplainTextBody(bodyMsg);
			// Send the email you have created.
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
		catch(Exception e){
			System.debug('NF_UpdateApproverStatus Email Exception $$$$'+e.getMessage());
			
		}
	}
}