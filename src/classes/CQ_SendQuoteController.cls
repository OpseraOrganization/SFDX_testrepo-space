/******************************************************************************************************
Name : CQ_SendQuoteController
Created Date: 21 April 2019
Created by: Accenture
Description : Controller for The CQ_SendQuote Lightning Component to Send email to the customer
*********************************************************************************************************/
public without sharing class CQ_SendQuoteController {
	Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	public static Id primarycontact ;
	/******************************************************************************************************
Name : QuoteRelatedDetails
Created Date: 21 April 2019
Created by: Accenture
Description : method for The CQ_SendQuote Lightning Component to return the related details for the Quote
*********************************************************************************************************/
	@AuraEnabled 
	public static  SendquotesWrap QuoteRelatedDetails(Id currentRecordId,String Objecttype)
	{	 
		string Errormessage='The Contracted Quote can only be sent when';
		string CURRENT_USER=userinfo.getName();
		integer Countmsg=0;
		SendquotesWrap SendQuoteNew=new SendquotesWrap();
		List<Contactteamwrap> Contactteamwraplist=new List<Contactteamwrap>();
		List<string> Filenames=new List<string>();
		list<Emailtemplate> E_templates=new list<Emailtemplate>();
		List<Id> ContentDocId_list=new List<Id>();
		List<Id> CV_Quote_doc = new List<Id>();
		map<Id,ContentVersion> CV_map = new map<Id,ContentVersion>();
		map<String,Surround_document_links__c> SDL_map = new map<String,Surround_document_links__c>();
		Boolean PricingfileError = true;
		
		
		Apttus_Proposal__Proposal__c Current_Quote = [SELECT Id,Name,Apttus_Proposal__Proposal_Expiration_Date__c,NokiaCPQ_Proposal_Id__c,CQ_Value__c,Apttus_Proposal__Approval_Stage__c,Account_Legal_Entity__c ,Account_Legal_Entity__r.Qtc_sold_to__c,NokiaCPQ_Opportunity_Id__c,Apttus_Proposal__Proposal_Name__c,
				  CQ_Sender__c,CQ_Customer_Email_Sent__c,CQ_Submitted_to_Customer_Date__c,CQ_eQuote_Status__c,CQ_Documents_Attached__c,CQ_eQuote__c,Surround_Priced_Account__c
				  FROM Apttus_Proposal__Proposal__c WHERE Id =: currentRecordId Limit : limitRows];
		
		Integer primarycontactcount=[select Count() from CQ_Customer_Contact__c where CQ_CQ_Name__c =:currentRecordId AND CQ_Is_Primary__c=true];
		
		for(Surround_document_links__c Sur_Dlink:[select Name,FIle_Path__c,CQ_ID__c ,Title__c,OwnerId,File_Name__c,CQ_Name__r.CQ_eQuote__c,ContentDocumentId__c from Surround_document_links__c where CQ_Name__c=:currentRecordId AND IS_latest__c=true and Title__c != :GlobalConstants.CQ_Services_price Limit : limitRows ])
		{
			
			system.debug('Sur_Dlink-->'+Sur_Dlink);
			if(Sur_Dlink.CQ_Name__r.CQ_eQuote__c){
	if(Sur_Dlink.Title__c == GlobalConstants.VzWSpecial_price){
		 if(!Filenames.contains(Sur_Dlink.File_Name__c))Filenames.add(Sur_Dlink.File_Name__c);
		SDL_map.put(Sur_Dlink.File_Name__c,Sur_Dlink);
	}
			}
			else{
			if(!Filenames.contains(Sur_Dlink.File_Name__c))Filenames.add(Sur_Dlink.File_Name__c);
	SDL_map.put(Sur_Dlink.File_Name__c,Sur_Dlink);
			}
			if(Sur_Dlink.CQ_Name__r.CQ_eQuote__c){
	if(Sur_Dlink.Title__c == GlobalConstants.VzWSpecial_price && Sur_Dlink.ContentDocumentId__c <> null){PricingfileError = false;}
			}else{
	if(Current_Quote.Surround_Priced_Account__c <> null && Sur_Dlink.ContentDocumentId__c <> null){PricingfileError = false;}
			}
			//if(!Filenames.contains(Sur_Dlink.Name.Substringbeforelast('.')))Filenames.add(Sur_Dlink.Name.Substringbeforelast('.'));
		
		}
		
	 
		for(ContentDocumentLink Content_Doclink:[Select Id,LinkedEntityId,ContentDocumentId from ContentDocumentLink 
				 WHERE LinkedEntityId =: currentRecordId  Limit : limitRows ])
		{
			ContentDocId_list.add(Content_Doclink.ContentDocumentId);
		}
		if(ContentDocId_list.size() > 0){
		for(ContentVersion CV : [SELECT ContentDocumentId,Document_Type_POC__c,FileExtension,FileType,IsLatest,VersionNumber FROM ContentVersion where IsLatest = true and ContentDocumentId in :ContentDocId_list Limit : limitRows]){
			CV_map.put(CV.ContentDocumentId,CV);
			if(CV.Document_Type_POC__c == 'Quote Document'){CV_Quote_doc.add(CV.ContentDocumentId);}
		}
		}
		If(Current_Quote.Apttus_Proposal__Approval_Stage__c<>null&&!Current_Quote.Apttus_Proposal__Approval_Stage__c.equalsignorecase(GlobalConstants.APPROVED) ){Errormessage +=' Approval Stage is Approved,';Countmsg=Countmsg+1;}
		If(Current_Quote.CQ_Value__c < 0 ||Current_Quote.CQ_Value__c==null){Errormessage +=' CQ Value is filled,';Countmsg=Countmsg+1;}
		If(primarycontactcount==0 ){Errormessage +=' Customer Contact is available,';Countmsg=Countmsg+1;}
		//If((Filenames.size()==0 ||!Current_Quote.CQ_Documents_Attached__c)&&Current_Quote.Account_Legal_Entity__r.Qtc_sold_to__c<>null&&Current_Quote.Account_Legal_Entity__r.Qtc_sold_to__c.equalsignorecase(system.Label.VzW_Number) ){Errormessage +=' Pricing File is attached to the Quote,';Countmsg=Countmsg+1;}
		If((PricingfileError || !Current_Quote.CQ_Documents_Attached__c) && Current_Quote.CQ_eQuote__c){Errormessage +=' Pricing File is attached to the Quote,';Countmsg=Countmsg+1;}
		If(!Current_Quote.CQ_eQuote__c && Current_Quote.Surround_Priced_Account__c <> null) 
		{
			if(SDL_map.isempty()){
	if(CV_Quote_doc.size() == 0) {Errormessage +=' Pricing File is attached to the Quote,';Countmsg=Countmsg+1;}
			}else{
	if(PricingfileError) {Errormessage +=' Pricing File is attached to the Quote,';Countmsg=Countmsg+1;}
			}
		}
		If(Current_Quote.Apttus_Proposal__Proposal_Expiration_Date__c==null ||(Current_Quote.Apttus_Proposal__Proposal_Expiration_Date__c<>null&&Current_Quote.Apttus_Proposal__Proposal_Expiration_Date__c<system.today())){Errormessage +=' Quote Expiration Date has not passed,';Countmsg=Countmsg+1;}
		if(Countmsg==0&&Current_Quote.Account_Legal_Entity__r.Qtc_sold_to__c<>null&&Current_Quote.Account_Legal_Entity__r.Qtc_sold_to__c.equalsignorecase(system.Label.VzW_Number)&&(Current_Quote.CQ_eQuote_Status__c<>null&&(Current_Quote.CQ_eQuote_Status__c.equalsignorecase(GlobalConstants.RETURN_SUCCESS) || Current_Quote.CQ_eQuote_Status__c.equalsignorecase(Globalconstants.EQUOTE_STATUS_INPROGRESS) )))
		{Errormessage ='The Contracted Quote cannot be sent when eQuote Message is Successful or In process';Countmsg=Countmsg+1;}
		system.debug('Errormessage: '+Errormessage);
		if(Countmsg==0)
		{
			string pri_ContactNames='';
			for(CQ_Quote_Team__c Quoteteam:[Select Id,CQ_CQ_Name__c,CQ_Role__c,CQ_Quote_Team_Member__c,CQ_Quote_Team_Member__r.Email,CQ_Quote_Team_Member__r.NAme from CQ_Quote_Team__c
					WHERE CQ_CQ_Name__c =: currentRecordId Limit : limitRows])
			{
	Contactteamwrap Contactteamnew=new Contactteamwrap(); 
	Contactteamnew.isselected=false;
	Contactteamnew.Quoteteam=Quoteteam;
	Contactteamwraplist.add(Contactteamnew);
			}
			
			for(CQ_Customer_Contact__c Customercontact:[Select Id,CQ_Account__c,CQ_Contact__c,CQ_Contact__r.Name,CQ_Contact__r.Email,CQ_CQ_Name__c,CQ_Is_Primary__c,CQ_Quote_Name__c from CQ_Customer_Contact__c
					WHERE CQ_CQ_Name__c =: currentRecordId Limit : limitRows])
			{
	Contactteamwrap Contactteamnew=new Contactteamwrap(); 
	Contactteamnew.isselected=CustomerContact.CQ_Is_Primary__c? true:false;
	primarycontact = CustomerContact.CQ_Is_Primary__c? CustomerContact.CQ_Contact__c:null;
	Contactteamnew.CustomerContact=CustomerContact;
	if(CustomerContact.CQ_Is_Primary__c)pri_ContactNames=pri_ContactNames+CustomerContact.CQ_Contact__r.Name+',';
	Contactteamwraplist.add(Contactteamnew);
			}
			
			
			for(ContentDocumentLink Content_Doclink:[Select Id,LinkedEntityId,ContentDocumentId,ContentDocument.Id ,ContentDocument.Title,ContentDocument.filetype,ContentDocument.Description from ContentDocumentLink 
				 WHERE LinkedEntityId =: currentRecordId  Limit : limitRows ])
			{
	Contactteamwrap Contactteamnew=new Contactteamwrap();
	String name_concat = Content_Doclink.ContentDocument.Title;//+'.'+Content_Doclink.ContentDocument.filetype;
	system.debug('Content_Doclink.ContentDocument.Title: '+Content_Doclink.ContentDocument.Title);
	system.debug('Filenames: '+ Filenames);
	system.debug('name_concat: '+name_concat);
	if(Filenames.contains(name_concat)){
		system.debug('check if');
		if(SDL_map.get(name_concat).Title__c == GlobalConstants.VzWSpecial_price){
			Contactteamnew.isselected=Filenames.contains(name_concat)?true:false;
			Contactteamnew.disabled=Filenames.contains(name_concat)?true:false;
		}else {
			Contactteamnew.isselected=false;
			Contactteamnew.disabled=false;
		}
		Contactteamnew.ContDoc_link=Content_Doclink;
		Contactteamnew.docType=SDL_map.get(name_concat).Title__c;
		Contactteamwraplist.add(Contactteamnew);
	} else if(CV_map.get(Content_Doclink.ContentDocumentId).Document_Type_POC__c == 'Quote Document'){
			//Content_Doclink.ContentDocument.Description='Quote Document';
			Contactteamnew.isselected=false;
			Contactteamnew.disabled=false;
			Contactteamnew.ContDoc_link=Content_Doclink;
			//Contactteamnew.docType=CV_map.get(Content_Doclink.ContentDocumentId).Document_Type_POC__c;
			Contactteamwraplist.add(Contactteamnew);
	}
			}
			list<string> E_TempNames=new list<string>();
			for(CQ_Email_Templates__c Etemp:CQ_Email_Templates__c.getall().values())
	E_TempNames.add(Etemp.Name);
			
			for(Emailtemplate E_template:[select id,Name,HTMLValue  from Emailtemplate WHERE developerName IN: E_TempNames Limit : limitRows ])
			{ 
	if(E_template.HTMLValue<>null){
		E_template.HTMLValue= E_template.HTMLValue.replace('PRIMARY_CUS_CONTACT',pri_ContactNames.removeEnd(',')).replace('QUOTE_NAME',Current_Quote.Apttus_Proposal__Proposal_Name__c).replace('QUOTE_NUMBER',Current_Quote.NokiaCPQ_Proposal_Id__c).replace('SENDER_NAME',CURRENT_USER);
		E_templates.add(E_template);
	}
	
			}
			
		}
		
		SendQuoteNew.CurrentQuote=Current_Quote;
		SendQuoteNew.Contactteamwraplist=Contactteamwraplist;
		SendQuoteNew.Emailtemplates=E_templates;
		SendQuoteNew.Errormessage=(Countmsg>0 )? Errormessage.removeEnd(','):null;
		
		return SendQuoteNew;
	}
	
	/******************************************************************************************************
Name : SendquotesWrap
Created Date: 21 April 2019
Created by: Accenture
Description : wrapperclass for The CQ_SendQuote Lightning Component to return the related details for the Quote
*********************************************************************************************************/
	public without sharing  class SendquotesWrap {
		@AuraEnabled public Apttus_Proposal__Proposal__c CurrentQuote {get;set;}
		@AuraEnabled public List<Contactteamwrap> Contactteamwraplist {get;set;}
		@AuraEnabled public List<EmailTemplate> Emailtemplates {get;set;}
		@AuraEnabled public String Errormessage {get;set;}
	}
	
	
	/******************************************************************************************************
Name : Contactteamwrap
Created Date: 21 April 2019
Created by: Accenture
Description : wrapperclass for The CQ_SendQuote Lightning Component to return the related details for the Quote
*********************************************************************************************************/
	public without sharing  class Contactteamwrap {
		@AuraEnabled public Boolean isselected {get;set;}
		@AuraEnabled public Boolean disabled {get;set;}
		@AuraEnabled public CQ_Customer_Contact__c CustomerContact {get;set;}  
		@AuraEnabled public CQ_Quote_Team__c Quoteteam {get;set;}  
		@AuraEnabled public ContentDocumentLink ContDoc_link {get;set;}  
		@AuraEnabled public String docType {get;set;}
	}
	
	
	/******************************************************************************************************
Name : sendQuoteEmail
Created Date: 21 April 2019
Created by: Accenture
Description : method for The CQ_SendQuote Lightning Component to send the related details for the Quote
*********************************************************************************************************/
	@AuraEnabled
	public static string sendQuoteEmail(list<string> toAddresses,list<string> CCAddresses,string mailbody,string subject,List<Id> DocumentIds,Apttus_Proposal__Proposal__c Quote,list<CQ_Customer_Contact__c> Customercontacts,list<string> QuoteteamEmails) 
	{
		string Exceptionval;
		String Toaddress='';
		boolean isvzw=false;
		string style='<style>p{margin-top:0px; margin-bottom:0px;}</style>';
		mailbody=style+ mailbody;
		list<string> ToAddresslist=new list<string>();	   
		
		for(string Toaddresss:toAddresses){
			if(!Toaddress.contains(Toaddresss))
	Toaddress=Toaddress+','+Toaddresss;
			if(!ToAddresslist.contains(Toaddresss))
	ToAddresslist.add(Toaddresss);
		}
		
		if(Quote.Account_Legal_Entity__r.Qtc_sold_to__c<>null&&Quote.Account_Legal_Entity__r.Qtc_sold_to__c.equalsignorecase(system.Label.VzW_Number))isvzw=true;
		list<string> DocNames=new list<string>();
		List<ContentDocumentLink> QuotecontentDOcumentset_Insert = new List<ContentDocumentLink>();
		List<Messaging.EmailFileAttachment> FileAttachments= new List<Messaging.EmailFileAttachment>{};
			Messaging.SendEmailResult[] EmailResult;
		database.saveresult S_Result;
		Id PrimarycontactId = [select CQ_Contact__c from CQ_Customer_Contact__c WHERE CQ_CQ_Name__c =: Quote.Id Limit 1].Id;
		try{
			for (ContentVersion Cversion: [SELECT Id, Title, FileType,FileExtension, VersionData, isLatest, ContentDocumentId FROM ContentVersion
			  WHERE isLatest = true AND ContentDocumentId IN :DocumentIds Limit : limitRows]) 
	{
		Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
		attachment.setBody(Cversion.VersionData);
		String ext='.'+Cversion.FileExtension;
		if(Cversion.Title.endsWithIgnoreCase(ext))   
		{attachment.setFileName(Cversion.Title);}
		else
		{ attachment.setFileName(Cversion.Title+ext);}
		
		FileAttachments.add(attachment);
		DocNames.add(Cversion.Title);
	}
			if(!isvzw)
			{
	
	system.debug('primarycontact: '+primarycontact);
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	mail.setToAddresses(ToAddresslist);
	if(subject!=null)mail.setSubject(subject);
	mail.setHtmlBody(mailbody);
	//mail.setTargetObjectId(userinfo.getUserId());
	mail.setSenderDisplayName(Userinfo.getName());
	if(!FileAttachments.isempty())mail.setFileAttachments(FileAttachments);
	EmailResult = Messaging.sendEmail(new Messaging.Email[] {mail},false);
			}
			else if(isvzw)
			{
	Sendequotetoservice(subject,mailbody,Customercontacts,QuoteteamEmails,DocNames, quote,USerInfo.getUserEmail());
			}
			
			if((!isvzw&&!EmailResult.isempty()&&EmailResult.get(0).isSuccess()) || isvzw ){
	EmailMessage NewE_Msg=CreateEmailMessage(mailbody,subject,Toaddress,Quote,isVzw);
	S_Result=database.insert(NewE_Msg,false);
	
	if(S_Result<>null&&S_Result.isSuccess()){
		if(S_Result.isSuccess()){
			EmailMessageRelation EMRel=new EmailMessageRelation();
			EMRel.EmailMessageId=S_Result.getId();
			EMRel.RelationId=USerinfo.getUserId();
			EMRel.RelationType=Globalconstants.FROMADDRESS;
			Database.saveresult S_res=Database.insert(EMRel,false);
			if(!S_res.isSuccess())Exceptionval=S_res.getErrors()[0].getMessage();
		}
		if( !isvzw&&string.isEmpty(Exceptionval)){
			quote.CQ_Sender__c=Userinfo.getUserId();
			quote.Apttus_Proposal__Approval_Stage__c=Globalconstants.ACCEPTED;
			quote.CQ_Customer_Email_Sent__c=true;
			quote.CQ_Submitted_to_Customer_Date__c=system.today();
		}
		if(isvzw&&string.isEmpty(Exceptionval)){
			quote.CQ_eQuote_Status__c=GlobalConstants.IN_PROGRESS;
			quote.CQ_Sender__c=Userinfo.getUserId();
		}
		database.saveresult Sresult=database.update(quote,false);
		if(!Sresult.isSuccess())Exceptionval=Sresult.getErrors()[0].getMessage();
	}
	if(!S_Result.isSuccess())Exceptionval=S_Result.getErrors()[0].getMessage();
			}
			if(!isvzw&&!EmailResult.get(0).isSuccess()&&string.isEmpty(Exceptionval))Exceptionval=EmailResult.get(0).getErrors()[0].getMessage();
			
			if(S_Result<>null&&S_Result.isSuccess()&&string.isEmpty(Exceptionval))
			{
	for(Id DocId:DocumentIds){
		ContentDocumentLink Cont_DocLink=new ContentDocumentLink();
		Cont_DocLink.LinkedEntityId=S_Result.getId();
		Cont_DocLink.ShareType=GlobalConstants.FILE_SHARE_TYPE_V;
		Cont_DocLink.ContentDocumentId=DocId;	 
		Cont_DocLink.Visibility=GlobalConstants.ALL_USERS;	
		QuotecontentDOcumentset_Insert.add(Cont_DocLink) ;
	}
			}
			
			system.debug('####Exceptionval-->'+Exceptionval);
			if(!QuotecontentDOcumentset_Insert.isEmpty())database.insert(QuotecontentDOcumentset_Insert,false);
			if(string.isEmpty(Exceptionval))Exceptionval=GlobalConstants.RETURN_SUCCESS;
			return Exceptionval.replaceAll('&quot;', '');
		}
		catch (Exception ex) {
			system.debug('Exception message-->'+ex.getMessage());
			Exceptionval=ex.getMessage();
			return Exceptionval.replaceAll('&quot;', '');
		}
	}
	
	
	/******************************************************************************************************
Name : sendQuoteEmail
Created Date: 21 April 2019
Created by: Accenture
Description : method for Emailmessage field mapping
*********************************************************************************************************/
	public static Emailmessage CreateEmailMessage(string mailbody,string subject,string Toaddress,Apttus_Proposal__Proposal__c Quote,Boolean isVZw )
	{
		EmailMessage NewE_Msg=new EmailMessage();
		NewE_Msg.RelatedToId=Quote.Id;
		NewE_Msg.FromAddress=USerInfo.getUserEmail();
		NewE_Msg.FromName=USerInfo.getName();
		NewE_Msg.MessageDate=system.now();
		NewE_Msg.Subject=subject;
		NewE_Msg.HtmlBody=mailbody;
		NewE_Msg.ToAddress=Toaddress; 
		NewE_Msg.IsExternallyVisible=false;
		NewE_Msg.Status= '3';
		NewE_Msg.IsTracked=false;
		
		return NewE_Msg; 
	}
	
	
	/******************************************************************************************************
Name : Sendequotetoservice
Created by: Accenture
Description : method for sending Process Quote sync message to EAI
*********************************************************************************************************/
	public static String Sendequotetoservice(String subject,string mailbody,list<CQ_Customer_Contact__c> Customercontact,List<String> quoteTeamEmailList,List<string> documentNames,Apttus_Proposal__Proposal__c quoteRecord,String userEmail)
	{
		
		List<SFDCEAISendQuoteEmailRequest.customerContactData> custContList = new List<SFDCEAISendQuoteEmailRequest.customerContactData>();
		List<SFDCEAISendQuoteEmailRequest.pdfLinksdata> pdfLinksList = new List<SFDCEAISendQuoteEmailRequest.pdfLinksdata>();
		SFDCEAISendQuoteEmailRequest.customerContactList custContData = new SFDCEAISendQuoteEmailRequest.customerContactList();
		SFDCEAISendQuoteEmailRequest.pdfLinksList pdfLinks = new SFDCEAISendQuoteEmailRequest.pdfLinksList();
		SFDCEAISendQuoteEmailRequest.processQuoteRequestClass processQuote = new SFDCEAISendQuoteEmailRequest.processQuoteRequestClass();
		SFDCEAISendQuoteEmailWebService.processQuoteBinding_soaphttps_ClusterMED_DMZ_PROD webserviceInstance = new SFDCEAISendQuoteEmailWebService.processQuoteBinding_soaphttps_ClusterMED_DMZ_PROD();
		SFDCEAISendQuoteEmailResponse.processQuoteResponseClass response = new SFDCEAISendQuoteEmailResponse.processQuoteResponseClass();
		Integer statusCode;
		String statusMessage = '';
		GlobalConstants.IS_PROCESS_QUOTE_SYNC = True;
		
		Set<Id> custContactId = new Set<Id>();
		
		for(CQ_Customer_Contact__c cc : customerContact){
			
			SFDCEAISendQuoteEmailRequest.customerContactData ccData = new SFDCEAISendQuoteEmailRequest.customerContactData();
			ccData.customerContactEmail = cc.CQ_Contact__r.Email;
			ccData.customerContactName = cc.CQ_Contact__r.Name;
			ccData.isPrimary = cc.CQ_Is_Primary__c;
			custContList.add(ccData);
			custContactId.add(cc.Id);
		}
		
		
		for(Surround_document_links__c sdoc:[select File_Name__c,FIle_Path__c,CQ_ID__c  ,Title__c,OwnerId 
			from Surround_document_links__c 
			where CQ_Name__c=:quoteRecord.Id and File_Name__c = :documentNames and Is_Latest__c = true
			Limit : limitRows])
		{
			SFDCEAISendQuoteEmailRequest.pdfLinksdata pdfData = new SFDCEAISendQuoteEmailRequest.pdfLinksdata();
			pdfData.pdfFileLink = sdoc.FIle_Path__c;
			pdfData.pdfFileName = sdoc.Title__c;
			pdfData.isSurroundDocument = true;
			pdfLinksList.add(pdfData);  
		}
		
		
		pdfLinks.pdfLink = pdfLinksList;
		custContData.customerContact = custContList;
		processQuote.customerContacts = custContData;
		processQuote.aluContactEmail = quoteTeamEmailList;
		processQuote.CQNumber = quoteRecord.NokiaCPQ_Proposal_Id__c;
		mailBody = '<![CDATA['+mailBody+']]>';
		system.debug('##mailBody'+mailBody);
		processQuote.EmailBody = mailBody;
		processQuote.EmailSubject = subject;
		processQuote.isEQuote = quoteRecord.CQ_eQuote__c;
		processQuote.mailFrom = userEmail;
		processQuote.pdfLinks = pdfLinks;
		
		webserviceInstance.clientCertName_x = system.label.CQ_EAICertificateName;
		webserviceInstance.timeout_x = 120000;
		
		String interfaceReqSent = String.valueOf(processQuote);
		
		try{
			
			System.Debug('##SEND EMAIL REQUEST##'+processQuote);
			response = webserviceInstance.processQuote(processQuote);
			System.Debug('##SEND EMAIL RESPONSE##'+response);
			
			if(response <> null && response.status == 0)
			{
	statusMessage = 'Status: '+response.status+'\n Message: '+response.STATUS_MESSAGE;
	Interface_Log__c iLog = new Interface_Log__c(Interface_Type__c=GlobalConstants.CQ_PROCESS_QUOTE, //create interface type
				Message_Type__c= GlobalConstants.OUTBOUND,
				Number_of_Record_Processed__c=1,
				status__c= GlobalConstants.EQUOTE_STATUS_SUCCESS,
				Number_of_Records_Success__c = 1,
				Number_of_Records_Errored__c= 0,
				Operation_Type__c = GlobalConstants.UPDATE_VALUE,
				Name='Process Quote Message Success for '+quoteRecord.NokiaCPQ_Proposal_Id__c,
				Interface_Request_Sent__c = interfaceReqSent.length() > 32768 ? interfaceReqSent.subString(0, 32768) : interfaceReqSent,
				Comment__c= statusMessage.length() > 32768 ? statusMessage.subString(0, 32768) : statusMessage);
	
	Database.insert(iLog,false);
			}
			else if(response==null || (response!=null && response.STATUS <> 0))
			{
	statusMessage = response == null ? 'Failed without Response' : response.STATUS_MESSAGE;
	if(response <> null) statusCode = response.STATUS;
	//handleExceptionLogs(statusMessage,quoteRecord,statusCode,custContactId,quoteTeamEmailList,interfaceReqSent);
	handleExceptionLogs(statusMessage,quoteRecord,custContactId,quoteTeamEmailList,interfaceReqSent);
	return null;
			}
		}catch(Exception ex){
			//handleExceptionLogs(ex.getMessage(),quoteRecord,statusCode,custContactId,quoteTeamEmailList,interfaceReqSent);
			handleExceptionLogs(ex.getMessage(),quoteRecord,custContactId,quoteTeamEmailList,interfaceReqSent);
			return null;
		}
		return 'success';
		
	}
	
	
	//private static void handleExceptionLogs(String message,Apttus_Proposal__Proposal__c quoteRecord,Integer StatusCode,Set<Id> CustomercontactIds,List<String> quoteTeamEmailList,String interfaceReqSent)
	private static void handleExceptionLogs(String message,Apttus_Proposal__Proposal__c quoteRecord,Set<Id> CustomercontactIds,List<String> quoteTeamEmailList,String interfaceReqSent)
	{
		try{
			Interface_Log__c iLog = new Interface_Log__c(Interface_Type__c=GlobalConstants.CQ_PROCESS_QUOTE, //create interface type
					 Message_Type__c=GlobalConstants.OUTBOUND,
					 Number_of_Record_Processed__c=1,
					 status__c=GlobalConstants.FAILURE,
					 Number_of_Records_Success__c = 0,
					 Number_of_Records_Errored__c= 1,
					 Name='Process Quote Message Failed for '+quoteRecord.NokiaCPQ_Proposal_Id__c,
					 Operation_type__c = Globalconstants.UPDATE_VALUE,
					 Interface_Request_Sent__c = interfaceReqSent.length() > 32768 ? interfaceReqSent.subString(0, 32768) : interfaceReqSent,
					 Comment__c= message);
			
			Database.SaveResult result = Database.insert(iLog,false);
			if(result.isSuccess()){
	createInterfaceDetailLogRecord(quoteRecord,message,iLog.Id,CustomercontactIds,quoteTeamEmailList);
			}
			
		}Catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_SENDQUOTECONTROLLER,GlobalConstants.HANDLE_EXCEPTIONLOGS);
		}
		
	}
	
	/******************************************************************************************************
Name : createInterfaceDetailLogRecord
Created Date:  21 April 2019
Created by: Accenture
Description : This method will create failed interface record detail log for failed records
*********************************************************************************************************/
	private static VOID createInterfaceDetailLogRecord(Apttus_Proposal__Proposal__c quoteRecord, String errorMessage, 
				Id iLogId,Set<Id> CustomercontactIds,List<String> quoteTeamEmailList) 
	{
		try{
			Interface_Record_Detail_Log__c recordLogDetail = new Interface_Record_Detail_Log__c();
			recordLogDetail.name = quoteRecord.id;
			recordLogDetail.Old_Value__c = 'Id='+quoteRecord.Id+';CQ Number='+quoteRecord.NokiaCPQ_Proposal_Id__c+';Equote= '+quoteRecord.CQ_eQuote__c+';Name='+quoteRecord.Apttus_Proposal__Proposal_Name__c;
			recordLogDetail.New_Value__c = 'CustomerContact='+CustomercontactIds+',QuoteTeamEmail='+quoteTeamEmailList;
			errorMessage = errorMessage.length() > 255 ? errorMessage.substring(0,255) : errorMessage;
			recordLogDetail.Error_Message__c=errorMessage;
			recordLogDetail.Status_and_Action__c= GlobalConstants.PROCESS_QUOTE_SYNC_ERROR;
			recordLogDetail.Object_Name__c= GlobalConstants.QUOTE_PROPOSAL_OBJECT;
			recordLogDetail.Interface_Log__c= iLogId;
			Database.insert(recordLogDetail,false);
		}catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_SENDQUOTECONTROLLER,GlobalConstants.CQ_CREATEINTERFACEDETAILLOGRECORD);
		}
		
	}
	
	/*****************************
*Method Name: sendQuoteByMail
*Description: This method sends email once response is received via update quote status
*Parameters:  Quote/Proposal List
**********************/   
	public static void sendQuoteByMail(Map<Id, Apttus_Proposal__Proposal__c> eQuoteMap)
	{
		List<EmailMessage> emailMessageList = new List<EmailMessage>();
		List<Messaging.EmailFileAttachment> FileAttachments= new List<Messaging.EmailFileAttachment>{};
			Map<Id,List<Messaging.EmailFileAttachment>> quoteFileAttachments = new Map<Id,List<Messaging.EmailFileAttachment>>();
		Map<Id,EmailMessage> emailMsgQuoteMap = new Map<Id,EmailMessage>();
		Messaging.SingleEmailMessage[] emailList = new Messaging.SingleEmailMessage[]{};
			Map<Id,Id> quoteDocMap = new Map<Id,Id>();
		Set<Id> msgIds = new Set<Id>();
		Messaging.SendEmailResult[] EmailResult;
		try{
			for(EmailMessage emsg : [select Id,ContentDocumentIds,
			 RelatedToId,FromAddress,FromName,CcAddress,MessageDate,Subject,
			 HtmlBody,ToAddress,IsExternallyVisible,Status
			 from EmailMessage 
			 where RelatedToId in :eQuoteMap.keySet()
			 order by CreatedDate desc
			 Limit :limitRows])
			{
	if(!quoteDocMap.values().contains(emsg.RelatedToId))
	{
		System.debug('emsg>>>>>>>>>>>>>>>>'+emsg.ContentDocumentIds);
		emailMsgQuoteMap.put(emsg.RelatedToId,emsg);
		msgIds.add(emsg.Id);
		//Get the document id from email message which has attachement linked to it
		for(Id contDocId : emsg.ContentDocumentIds)
			quoteDocMap.put(contDocId,emsg.RelatedToId);
	}
			}
			
			for (ContentVersion Cversion: [SELECT Id, Title, FileType,FileExtension, VersionData, isLatest, ContentDocumentId 
			 FROM ContentVersion
			 WHERE isLatest = true 
			 AND ContentDocumentId IN :quoteDocMap.keySet() 
			 Limit : limitRows
			]) 
			{
	Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
	attachment.setBody(Cversion.VersionData);
	
	String ext='.'+Cversion.FileExtension;
		if(Cversion.Title.endsWithIgnoreCase(ext))   
		{attachment.setFileName(Cversion.Title);}
	else{
		attachment.setFileName(Cversion.Title+ext);}
	FileAttachments.add(attachment);
	if(quoteFileAttachments.containsKey(quoteDocMap.get(Cversion.ContentDocumentId)))
		quoteFileAttachments.get(quoteDocMap.get(Cversion.ContentDocumentId)).add(attachment);
	else
		quoteFileAttachments.put(quoteDocMap.get(Cversion.ContentDocumentId),new List<Messaging.EmailFileAttachment>{attachment});
			}
			for(Apttus_Proposal__Proposal__c eQuote : eQuoteMap.values())
			{
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	EmailMessage emailMsg = emailMsgQuoteMap.get(eQuote.Id);
	mail.setSaveAsActivity(false);
	mail.setToAddresses((emailMsg.ToAddress).split(';'));
	//mail.setCcAddresses((emailMsgRel.EmailMessage.CcAddress).split(';'));
	if(emailMsg.Subject!=null)
		mail.setSubject(emailMsg.Subject);
	mail.setBccSender(false);
	mail.setHtmlBody(emailMsg.HtmlBody);
	mail.senderDisplayName = emailMsg.FromName;
	mail.setTargetObjectId(userinfo.getUserId());
	mail.setTreatTargetObjectAsRecipient(false);
	if(!FileAttachments.isempty())
		mail.setFileAttachments(quoteFileAttachments.get(eQuote.Id));
	System.debug('mailmailmail'+mail);
	emailList.add(mail);
	
	//After email is sent, update the stage and other fields in quote
	eQuote.Apttus_Proposal__Approval_Stage__c= GlobalConstants.CQ_STATUS_ACCEPTED;
	eQuote.CQ_Customer_Email_Sent__c=true;
	eQuote.CQ_Submitted_to_Customer_Date__c=system.today();
	
	
			}
			EmailResult = Messaging.sendEmail(emailList,false);
			system.debug('EmailResult+++++'+EmailResult);
			for(integer index = 0; index< EmailResult.size(); index++){
	if(EmailResult[index].getErrors() <> null){
		for(Messaging.SendEmailError error : EmailResult[index].getErrors()){
						ContractedQuoteTriggerHandler contQtTrigHandler = new ContractedQuoteTriggerHandler();
			contQtTrigHandler.createErrorInterfaceLogs(GlobalConStants.UPDATESTATUS_INTERFACETYPE,GlobalConstants.SEND_EMAIL_FALURE_STRING,
					  emailList[index].subject,error.getMessage());
		}
	}
			}
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_SENDQUOTECONTROLLER, GlobalConstants.CQ_SEND_QUOTE_BY_MAIL);
		}
	}
	
	
	
}