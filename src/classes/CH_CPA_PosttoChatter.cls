global class  CH_CPA_PosttoChatter implements Messaging.InboundEmailHandler {
	
	@TestVisible Id CPAID1 {get; set;} 
	string emailType = 'Update'; 
	string feedbody = 'An attachment from email reply was not stored in CAPS because its size is over 11MB ';
	string NotifBody = 'Sorry your attachment(s) was rejected because the limit size of 11MB has been exceeded ';
	@TestVisible Integer fileMaxSizeBytes = Integer.valueOf(Label.CH_EmailAttachmentSize);//3000000;
	
	global  Messaging.InboundEmailResult handleInboundEmail( Messaging.inboundEmail email, Messaging.InboundEnvelope envelop){
		Messaging.InboundEmailResult result  =  new Messaging.InboundEmailResult();
		
		System.debug(email);
		
		//String  threadId;  
		String  accname  =  email.fromName;
		String  accdes  =  email.plainTextBody;
		String  accIndus  =  email.Subject;
		String trigrval;
		String communityId = null;
		/*Account ac  =  new  Account( Name  = accname,  description  =  accdes,  Industry =  accIndus);
insert ac;*/
		if(!string.isBlank(email.subject)){
			String resub=email.subject.substringBetween('ref:',':ref');
			if(!string.isBlank(resub)){
		resub=resub.trim();
			System.debug('id value with like is:'+resub);
		
		
		//threadId = '%' + resub + '%';
		
		List <CH_Corrective_Preventive_Action__c> aval=[select 	CH_CPA_Link__c,name,createddate,CH_Source__c,OwnerId,CH_CPA_Manager__c,CreatedById,CH_Description__c,CH_Classification__c ,CH_Priority__c,CH_Category__c,CH_Impacted_Business_Groups__c,CH_Domain__c,CH_Target_Date__c from CH_Corrective_Preventive_Action__c where id=:resub limit 1];
		String CPAID=resub;
		String cpaowner=aval[0].OwnerId;
		String cpamanger=aval[0].CH_CPA_Manager__c;
		String cpanumber=aval[0].name;
		Datetime createddate=aval[0].createddate;
		String source=aval[0].CH_Source__c;
		String id=aval[0].CreatedById;
		String description=aval[0].CH_Description__c;
		String Classification=aval[0].CH_Classification__c;
		String Priority=aval[0].CH_Priority__c;
		String Category=aval[0].CH_Category__c;
		String imbusigroups=aval[0].CH_Impacted_Business_Groups__c;
		String Domain=aval[0].CH_Domain__c;
		Datetime targetdate=aval[0].CH_Target_Date__c;
		//String link=LEFT($Api.Partner_Server_URL_300, FIND( '/services', $Api.Partner_Server_URL_300));
		String linkurlinitial= aval[0].CH_CPA_Link__c;
		String linkurlfinal=linkurlinitial +'lightning/r/CH_Corrective_Preventive_Action__c/'+resub+'/view';
		
		LIST <user> userval=[select name from user where id=:id limit 1];
		String usname=userval[0].name;	
		
		String postmessage='Dear User,A new email is arrived linked to the action '+cpanumber+'\n\nCPA Details: \nCreate Date: '+createddate+' (in User Timezone)\nSource: '+source+'\nCPA Creator: '+usname+'\nDescription: '+description+'\nClassification: '+Classification+'\nPriority: '+Priority+'\nCategory: '+Category+'\nImpacted Business Groups: '+imbusigroups+'\nDomain: '+Domain+'\nTarget Date: '+targetdate+' (in User Timezone)\n\nView this '+linkurlfinal;
		
		trigrval=postmessage;
		String targetUserOrGroupOrRecordId=cpaowner;
		//String targetUserOrGroupOrRecordId  = 'me';
		String codeSnippet = trigrval;
		ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
		input.subjectId = targetUserOrGroupOrRecordId;
		input.feedElementType = ConnectApi.FeedElementType.FeedItem;
		
		ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegment;
		ConnectApi.MarkupBeginSegmentInput markupBeginSegment;
		ConnectApi.MarkupEndSegmentInput markupEndSegment;
		
		messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		
		markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
		markupBeginSegment.markupType = ConnectApi.MarkupType.Code;
		messageInput.messageSegments.add(markupBeginSegment);
		
		textSegment = new ConnectApi.TextSegmentInput();
		textSegment.text = codeSnippet;
		messageInput.messageSegments.add(textSegment);
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
		markupEndSegment.markupType = ConnectApi.MarkupType.Code;
		messageInput.messageSegments.add(markupEndSegment);
		
		input.body = messageInput;
		
		if(!test.isRunningTest()){ConnectApi.ChatterFeeds.postFeedElement(communityId, input);}
		
		//////////////newly added////////
		String targetUserOrGroupOrRecordId1=cpamanger;
		
		String codeSnippet1 = trigrval;
		//ConnectApi.FeedItemInput input1 = new ConnectApi.FeedItemInput();
		input.subjectId = targetUserOrGroupOrRecordId1;
		input.feedElementType = ConnectApi.FeedElementType.FeedItem;
		
		//ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
		//ConnectApi.TextSegmentInput textSegment;
		//ConnectApi.MarkupBeginSegmentInput markupBeginSegment;
		//ConnectApi.MarkupEndSegmentInput markupEndSegment;
		
		messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		
		markupBeginSegment = new ConnectApi.MarkupBeginSegmentInput();
		markupBeginSegment.markupType = ConnectApi.MarkupType.Code;
		messageInput.messageSegments.add(markupBeginSegment);
		
		textSegment = new ConnectApi.TextSegmentInput();
		textSegment.text = codeSnippet1;
		messageInput.messageSegments.add(textSegment);
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
		markupEndSegment.markupType = ConnectApi.MarkupType.Code;
		messageInput.messageSegments.add(markupEndSegment);
		
		input.body = messageInput;
		
		if(!test.isRunningTest()){ConnectApi.ChatterFeeds.postFeedElement(communityId, input);}  
		}
		}
		Boolean isClosedOrCancelled = false;
		//Messaging.InboundEmailResult result = new Messaging.InboundEmailResult(); 
		
		try{
			system.debug('###handleInboundEmail:subject:' + email.subject); 
			if(!string.isBlank(email.subject)){
	
	// Get the email reference present at the level of the email subject
	string threadId = email.subject.substringBetween('ref:',':ref');
	system.debug('###handleInboundEmail:threadId:' + threadId);
	
	if(!string.isBlank(threadId)){
		
		// Identify the related case, based on the previously retrieved reference, from the email message records
		threadId = '%' + threadId + '%';
		System.debug('threadId:'+threadId);
		list<EmailMessage> emails = new list<EmailMessage>([SELECT RelatedToId FROM EmailMessage WHERE Subject like :threadId limit 1]); // use MessageDate to imporve the query?
		System.debug('emails:'+emails);
		if(!emails.isEmpty() ){if(emails[0].RelatedToId != null){CPAID1 = emails[0].RelatedToId;}}  
		//System.debug('parent id is'+emails[0].RelatedToId);
		
		if(CPAID1 != null){
			List<CH_Corrective_Preventive_Action__c> CPAList = new List<CH_Corrective_Preventive_Action__c>([SELECT Id
			 FROM CH_Corrective_Preventive_Action__c 
			 WHERE Id = :CPAID1 
			 LIMIT 1]);
			
			string fileNamesOver3mb = '';
			system.debug('###handleInboundEmail:CPAID1:' + CPAID1);
			list<FeedItem> feedItems = new list<FeedItem>();
			// Check if text attachment need to be uploaded to CAPS
			if(email.textAttachments != null)
	for(Messaging.InboundEmail.TextAttachment att : email.textAttachments){
		if(att.body.length() <= fileMaxSizeBytes){
			if(att.body != null && !Test.isRunningTest()){
	
	CH_EmailAttachmentHelper help = new CH_EmailAttachmentHelper(CPAID1, email.Subject, att);
	if(!isClosedOrCancelled){ ID jobId = System.enqueueJob(help);
		system.debug('###CH_EmailAttachmentHandler:JobId:' + jobId);
	}   
			} 
		}else{
			feedItems.add(new FeedItem(ParentId = CPAID1, Body = feedbody + '(' + att.fileName + ')', Type = 'TextPost'));
			fileNamesOver3mb += string.isBlank(fileNamesOver3mb) ? att.fileName : ', ' + att.fileName;
		}
		
	} 
			
			map<string, Attachment> contentIdAttachment = new map<string, Attachment>();
			// Save email inline content as Salesforce attachments and replace the header attachment id with the attachment url in the email html body
			// And send non inline attachment to CAPS 
			if(email.binaryAttachments != null){
	for(Messaging.InboundEmail.BinaryAttachment att : email.binaryAttachments){
		system.debug('#HEADERS:' + att.headers);
		CH_EmailAttachmentHelper.AttachmentHeader attHeader = CH_EmailAttachmentHelper.getAttHeader(att.headers);
		system.debug('#attHeader:' + attHeader);
		if(attHeader.contentDisposition == 'inline'){ contentIdAttachment.put(attHeader.attachementId, new Attachment(parentId = CPAID1, Body = att.body, ContentType = attHeader.contentType, Name = att.fileName, Description = 'Inline attachment from email reply'));
		}else{
			if(att.body.size() <= fileMaxSizeBytes){
	if(!Test.isRunningTest()){ CH_EmailAttachmentHelper help = new CH_EmailAttachmentHelper(CPAID1, email.Subject, att);
		if(!isClosedOrCancelled){ ID jobId = System.enqueueJob(help);
			system.debug('###CH_EmailAttachmentHandler:JobId:' + jobId); 
		}	
	}   
			}else{
	feedItems.add(new FeedItem(ParentId = CPAID1, Body = feedbody + '(' + att.fileName + ')', Type = 'TextPost'));
	fileNamesOver3mb += string.isBlank(fileNamesOver3mb) ? att.fileName : ', ' + att.fileName;
			}
			
		}
	} 
	
	system.debug('#feedItems:' + feedItems.size());
	if(!feedItems.isEmpty() && !isClosedOrCancelled) insert feedItems;
	
	system.debug('#contentIdAttachment:' + contentIdAttachment.size());
	system.debug('#contentIdAttachment:' + contentIdAttachment);
	if(!contentIdAttachment.isEmpty()) insert contentIdAttachment.values();
	
			} 
			
			// Attach the new email reply to the case
			string toAddresses = '';
			if(email.toAddresses != null && !email.toAddresses.isEmpty())
	for(string toAdd : email.toAddresses) toAddresses += toAdd + ', ';
			toAddresses = toAddresses.substringBeforeLast(', ');
			
			string htBody = email.htmlBody;
			if(!string.isBlank(htBody) && contentIdAttachment != null)
	for(string attId : contentIdAttachment.KeySet())
	htBody = htBody.replace('cid:' + attId, '/servlet/servlet.FileDownload?file=' + contentIdAttachment.get(attId).Id);
			
			EmailMessage newEmail = new EmailMessage(   RelatedToId = CPAID1, 
	 Subject = email.subject, 
	 FromAddress = email.FromAddress, 
	 FromName = email.FromName, 
	 TextBody = email.plainTextBody,
	 HtmlBody = htBody, 
	 toAddress ='',
	 CH_Email_Type__c = emailType,
				Status ='2');
			
			
			
			insert newEmail;
			
			system.debug('#fileNamesOver3mb:' + fileNamesOver3mb);
			if(!string.isBlank(fileNamesOver3mb) && !isClosedOrCancelled){ CH_EmailAttachmentHelper.sendEmailNotification(email.fromAddress, 'Undeliverable: [ ref:' + threadId + ':ref ]', System.Label.CH_SenderDisplayName, System.Label.CH_AttachmentSizeRejectionBody + '\n\n File Name: ' + fileNamesOver3mb ,  email.messageId, null);
			}	
		} 
	}
	else{ 
			CH_EmailAttachmentHelper.sendEmailNotification(email.fromAddress, 
	  'Nokia Support - Unable to Process Email', 
	  System.Label.CH_SenderDisplayName, 
	  'Dear Sender,'+'\n\nUnfortunately your email was not attached to a Corrective and Preventive Action. This means that your email will not be processed by one of our support agents. Please reply to an email that you received from Nokia, or contact the support team via email.'+'\n\nRegards,\n\nNokia Support',  
	  null, null);
			}
			}
	else{ 
			CH_EmailAttachmentHelper.sendEmailNotification(email.fromAddress, 
	  'Nokia Support - Unable to Process Email', 
	  System.Label.CH_SenderDisplayName, 
	  'Dear Sender,'+'\n\nUnfortunately your email was not attached to a Corrective and Preventive Action. This means that your email will not be processed by one of our support agents. Please reply to an email that you received from Nokia, or contact the support team via email.'+'\n\nRegards,\n\nNokia Support',  
	  null, null);
			}
			
			
			
			result.success = true;
			
		}catch (Exception e) { result.success = false; result.message = 'An error has occurred: '+ e.getMessage();
			system.debug('###Exception:Message>' + e.getMessage() + ':LineNumber>' + e.getLineNumber() + ':Cause>'+ e.getCause() + ':Type>'+ e.getTypeName() + ':Trace>'+ e.getStackTraceString());
		} 
		return result;
	}
}