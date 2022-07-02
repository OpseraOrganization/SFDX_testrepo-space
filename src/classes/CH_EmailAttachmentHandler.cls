/****************************************
* Class Name : CH_EmailAttachmentHandler
* Created Date: 18 Sept 2018
* Created By : Marwan Boutaleb (mboutaleb@salesforce.com)
* Last Modified by: Marwan Boutaleb (mboutaleb@salesforce.com)
* Last Modified Date: 23 Oct2018
* Description : Upload attachment to CAPS
* The aim of the following code is to store the emails attachments received as case replies into CAPS system.
* All the rest calls in this class are an exact replication of the mecanism of saving an attachement in CAPS: 
* present at the level of the lightning component CAPS_UploadMultipleAttachment
* This class reformulates the XMLHttpRequest callh_s present at the level of the helper of the same component into Apex rest calls.
*	  
* This method fires a Queueable call for each non inline binary/text attachment received with email: this is due to the re-use of the method CAPS_MultiFileUploadController.uploadComplete that makes a callout and a DML operation
* Adding an additional DML and a Callout in the same transaction will result in the famous exception: 'You have uncommitted work pending. Please commit or rollback before calling out'
* The limit is 50 Queueable call per transaction = Max of 50 attachements in the email
* Test Class: CH_EmailAttachmentHandler_Test
*****************************************/

global without sharing class CH_EmailAttachmentHandler implements Messaging.InboundEmailHandler {
	
	@TestVisible Id caseId {get; set;} 
	string emailType = 'Update'; 
	string feedbody = 'An attachment from email reply was not stored in CAPS because its size is over 11MB ';
	string NotifBody = 'Sorry your attachment(s) was rejected because the limit size of 11MB has been exceeded ';
	@TestVisible Integer fileMaxSizeBytes = Integer.valueOf(Label.CH_EmailAttachmentSize);
	
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope){
		Set<String> caseStatusSet = new Set<String>{'Completed','Closed','Cancelled'};
		Set<String> recordtypeSet = new Set<String>(Label.CH_Case_RecordTypes.replaceAll('\\s','').split(','));
		Boolean isClosedOrCancelled = false;
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult(); 
		string headervalues;
		Boolean isBlankval = false;
		Boolean toaddressmatch=false;
		Boolean fromaddressmatch=false;
		Boolean stopmailsend=false;
		string[] toaddresssvalue=email.toAddresses;
		string fromaddressvalue=email.fromAddress;
		String checkaddress=system.label.CH_FromAddressForGWCMail;
		String bypassEmail=system.label.CH_BypassEmailAddresses;
		Boolean isEmailTruncated=false;
		Integer inboundEmailContentLimit=Integer.valueOf(system.label.CH_EmailContentLimit);
		Boolean isEmailtoCaseOwner=false;//Changes added for NOKIASC-36144
		
		if (fromaddressvalue==checkaddress){ fromaddressmatch=true; }
		if (toaddresssvalue.contains(checkaddress)){ toaddressmatch=true; }
		if (fromaddressmatch==true && toaddressmatch==true) { stopmailsend=true; }
		if (fromaddressvalue.contains(bypassEmail)){ stopmailsend=true;   }
		try{
			if(!string.isBlank(email.subject)){
				// Get the email reference present at the level of the email subject
				string threadId = email.subject.substringBetween('ref:',':ref');
				if(!string.isBlank(threadId)){
					// Identify the related case, based on the previousely retrieved reference, from the email message records
					threadId = '%' + threadId + '%';
					// Changes added for US-31935
					Map<Id,EmailMessage> getMapEmailMessage=new  Map<Id,EmailMessage>([SELECT ParentId,Parent.Id,Parent.CaseNumber,Parent.Status,Parent.Contact.Email,Parent.CH_RecordTypeCheck__c,MessageDate, Parent.CH_Workgroup__r.CH_AutomaticQualificationTimer__c, Parent.BusinessHours.Name,Parent.BusinessHours.Id, Parent.CH_PlannedAutomaticQualificationDateTime__c,subject,Parent.RecordType.DeveloperName,FromAddress,
																					   Parent.CreatedBy.IsPortalEnabled,Parent.CreatedBy.Email,Parent.Contact.Name,
																					   Parent.Subject,Parent.Owner.IsActive,Parent.Owner.Email   
																					   FROM EmailMessage WHERE ParentId!=null AND 
																					   Parent.RecordType.DeveloperName IN : recordtypeSet 
																					   AND Subject like :threadId]);
					List<EmailMessage> getEmailMesage=new List<EmailMessage>();
					if(getMapEmailMessage.size()>0){	
						List<EmailMessage> lstEmailMessages = getMapEmailMessage.values();
						for(EmailMessage emailMsgs:lstEmailMessages){
							string compareVal='';
							string subject = email.subject.substringBetween('ref:',':ref');
							compareVal=emailMsgs.subject.substringBetween('ref:',':ref');
							if(subject.equals(compareVal)){
								caseId = emailMsgs.ParentId;
								getEmailMesage.add(emailMsgs);
							}
						}
					}
					if(caseId != null){
						if((!getEmailMesage.isEmpty() && caseStatusSet.contains(getEmailMesage[0].Parent.Status)) && (email.textAttachments != null || email.binaryAttachments != null)){
							isEmailtoCaseOwner=True;
							isClosedOrCancelled = true;
							CH_EmailAttachmentHelper.sendEmailNotification(email.fromAddress, 
																		   'Undeliverable: [ ref:' + threadId + ':ref ]', 
																		   System.Label.CH_SenderDisplayName,
																		   'Dear Sender,'+'\n\nAn attachment from email reply was not processed as Support Case '+getEmailMesage[0].Parent.CaseNumber+ ' has been '+getEmailMesage[0].Parent.Status+'.'+'\n\nRegards,\n\nNokia Support',  
																		   email.messageId,'');
						}
						string fileNamesOver3mb = '';
						list<FeedItem> feedItems = new list<FeedItem>();
						// Check if text attachment need to be uploaded to CAPS
						if(email.textAttachments != null)
							for(Messaging.InboundEmail.TextAttachment att : email.textAttachments){
								if(att.body.length() <= fileMaxSizeBytes){
									if(att.body != null){
										CH_EmailAttachmentHelper help = new CH_EmailAttachmentHelper(caseId, email.Subject, att);
										if(!isClosedOrCancelled){
											System.enqueueJob(help);
										}   
									} 
								}
								else{
									feedItems.add(new FeedItem(ParentId = caseId, Body = feedbody + '(' + att.fileName + ')', Type = 'TextPost'));
									fileNamesOver3mb += string.isBlank(fileNamesOver3mb) ? att.fileName : ', ' + att.fileName;
								}
							} 
						map<string, Attachment> contentIdAttachment = new map<string, Attachment>();
						// Save email inline content as Salesforce attachments and replace the header attachment id with the attachment url in the email html body
						// And send non inline attachment to CAPS 
						if(email.binaryAttachments != null){
							for(Messaging.InboundEmail.BinaryAttachment att : email.binaryAttachments){
								CH_EmailAttachmentHelper.AttachmentHeader attHeader = CH_EmailAttachmentHelper.getAttHeader(att.headers);
								if(attHeader.contentDisposition == 'inline'){
									contentIdAttachment.put(attHeader.attachementId, new Attachment(parentId = caseId, Body = att.body, ContentType = attHeader.contentType, Name = att.fileName, Description = 'Inline attachment from email reply'));
								}
								else{
									if(att.body.size() <= fileMaxSizeBytes){
										CH_EmailAttachmentHelper help = new CH_EmailAttachmentHelper(caseId, email.Subject, att);
										if(!isClosedOrCancelled){
											System.enqueueJob(help);
										}	
									}
									else{
										feedItems.add(new FeedItem(ParentId = caseId, Body = feedbody + '(' + att.fileName + ')', Type = 'TextPost'));
										fileNamesOver3mb += string.isBlank(fileNamesOver3mb) ? att.fileName : ', ' + att.fileName;
									}
								}
							} 
							if(!feedItems.isEmpty() && !isClosedOrCancelled) insert feedItems;
							if(!contentIdAttachment.isEmpty()) insert contentIdAttachment.values();
						} 
						
						// Attach the new email reply to the case
						string toAddresses = '';
						if(email.toAddresses != null && !email.toAddresses.isEmpty())
							for(string toAdd : email.toAddresses) toAddresses += toAdd + ', ';
						toAddresses = toAddresses.substringBeforeLast(', ');
						
						if(!String.isEmpty(getEmailMesage[0].Parent.contact.Email)){
							toAddresses = toAddresses + ', ' + getEmailMesage[0].Parent.contact.Email;
						}
						
						if(email.fromAddress != null){
							toAddresses = toAddresses + ', ' + email.fromAddress;
						}
						
						string ccAddresses = '';
						if(email.ccAddresses != null && !email.ccAddresses.isEmpty())
							for(string toAdd : email.ccAddresses) ccAddresses += toAdd + ', ';
						ccAddresses = ccAddresses.substringBeforeLast(', ');
						
						String htBody;
						String plainBody;
						
						if(email.htmlbody != null){
							if(email.htmlbody.length()>inboundEmailContentLimit){
								htBody = email.htmlbody.substring(0,inboundEmailContentLimit)+'<br><br><B>131k size limit reached. Email history truncated. Please refer to the emails already received to read the complete history.</B>';	
								isEmailTruncated=True;
							}
							else {
								htBody= email.htmlbody;
							}
						}
						
						if(email.plainTextBody != null){
							if(email.plainTextBody.length()>inboundEmailContentLimit){
								plainBody = email.plainTextBody.length()>inboundEmailContentLimit?email.plainTextBody.substring(0,inboundEmailContentLimit)+'\n 131k size limit reached. Email history truncated. Please refer to the emails already received to read the complete history.':
								email.plainTextBody +'\n 131k size limit reached. Email history truncated. Please refer to the emails already received to read the complete history.';  
								isEmailTruncated=True;
							}
							else {
								plainBody=email.plainTextBody;
							}
						}
						
						if(!string.isBlank(htBody) && contentIdAttachment != null)
							for(string attId : contentIdAttachment.KeySet())
							htBody = htBody.replace('cid:' + attId, '/servlet/servlet.FileDownload?file=' + contentIdAttachment.get(attId).Id);
						
						EmailMessage newEmail = new EmailMessage(ParentId = caseId, 
																 Subject = email.subject, 
																 FromAddress = email.FromAddress, 
																 FromName = email.FromName, 
																 TextBody = plainBody,
																 HtmlBody = htBody, 
																 //toAddress = (string.isEmpty(getEmailMesage[0].Parent.contact.Email) ? toAddresses : getEmailMesage[0].Parent.contact.Email), 
																 toAddress = toAddresses,
																 ccAddress = ccAddresses,
																 CH_Email_Type__c = emailType);

						insert newEmail;
						
						if(!string.isBlank(fileNamesOver3mb) && !isClosedOrCancelled){
							isEmailtoCaseOwner=True;
							CH_EmailAttachmentHelper.sendEmailNotification(email.fromAddress, 
																		   'Undeliverable: [ ref:' + threadId + ':ref ]', 
																		   System.Label.CH_SenderDisplayName, 
																		   System.Label.CH_AttachmentSizeRejectionBody + '\n\n File Name: ' + fileNamesOver3mb ,  
																		   email.messageId,'');
						}
						if(isEmailTruncated){
							isEmailtoCaseOwner=True;
							CH_EmailAttachmentHelper.sendEmailNotification(email.fromAddress,getEmailMesage[0].Parent.CaseNumber, '', 'Send Truncated Email' , email.subject,'');
						}	
						//Changes added for NOKIASC-36144
						if(!isEmailtoCaseOwner && getEmailMesage[0].Parent.Owner.IsActive ){  
							CH_EmailAttachmentHelper.sendEmailNotification(getEmailMesage[0].Parent.Owner.Email,getEmailMesage[0].Parent.Contact.Name,getEmailMesage[0].Parent.CaseNumber,'Case Owner Notification for PortalCases',getEmailMesage[0].Parent.Subject,newEmail.Id);  
						}
						//Changes added for NOKIASC-36588
						String domainName;
						if(!String.isEmpty(fromaddressvalue)){
							domainName = fromaddressvalue.substring(fromaddressvalue.indexOf('@')+1);
						}
						String getNokiaDomains = System.Label.CH_NokiaDomain;
						Set<String> setNokiaDomains = new Set<String>();
						if(getNokiaDomains!= null){  for(String getSetValue : getNokiaDomains.split(',')) { setNokiaDomains.add(getSetValue);  } }
						if(!isEmailtoCaseOwner && getEmailMesage[0].Parent.Status == 'Pending Customer' && getEmailMesage[0].Parent.CH_PlannedAutomaticQualificationDateTime__c == null && !setNokiaDomains.isEmpty() && !setNokiaDomains.contains(domainName)){  
							Integer getWorkgroupTimer; if(getEmailMesage[0].Parent.CH_Workgroup__r.CH_AutomaticQualificationTimer__c != null){getWorkgroupTimer =  Integer.valueof(getEmailMesage[0].Parent.CH_Workgroup__r.CH_AutomaticQualificationTimer__c);}
							CH_EmailAttachmentHelper.calculateAutomaticPlanned(getEmailMesage[0].Parent.Id,getWorkgroupTimer);  
						}
					} 
				}
			}
			for (Messaging.InboundEmail.Header header : email.headers) {
				headervalues=header.value;
				break;
			}
			if(String.isBlank(headervalues)){
				isBlankval = true;
			}	 
			
			// Notify sender when no case is retreived
			if(caseId == null && isBlankval==false && stopmailsend==false) 
				CH_EmailAttachmentHelper.sendEmailNotification(email.fromAddress, 
															   'Nokia Support - Unable to Process Email', 
															   System.Label.CH_SenderDisplayName, 
															   System.Label.CH_NoThreadIdentified,  
															   null,''); 
			result.success = true;
		}
		catch (Exception e) {
			result.success = false;
			result.message = 'An error has occurred: '+ e.getMessage();
		} 
		return result;
	}
}