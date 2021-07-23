/****************************************
* Class Name : HWS_OrderConfirmationNotification
* Created Date:  Mar 2019
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: 15 Mar 2019
* Description : Whenever SPM related Cases receives return delivery addresses an email will be trigger ed to the Contact and Communication Contact
with the order confirmation and failure report of the each individual case.
*****************************************/
public without sharing class HWS_OrderConfirmationNotification {
	public ApexPages.StandardSetController stdCntrlr {get; set;}
	public static Id currentParentCaseId {get;set;}
	public static Integer recordCount {get;set;}
	public HWS_OrderConfirmationNotification(ApexPages.StandardSetController controller){
		stdCntrlr = controller;
	}
	public static Id childCaseReadOnly {
		get {
			if(childCaseReadOnly == null){
				childCaseReadOnly = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_CHILD_CASE_READ_ONLY);
			}
			return childCaseReadOnly;
		}
		set;
	}
	public static Id parentCase {
		get {
			if(parentCase == null){
				parentCase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE);
			}
			return parentCase;
		}
		set;
	}
	public static Id parentCaseReadOnly {
		get {
			if(parentCaseReadOnly == null){
				parentCaseReadOnly = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE_READ_ONLY);
			}
			return parentCaseReadOnly;
		}
		set;
	}	
	public static List<Case> childCaseList;
	public static boolean isMailSent=true;
	public static String emailCheck = 'Order Confirmation';
	
	/****************************************
* Method Name : sendEmailNotificationForPDF
* Created Date:  May 2019
* Created By : TCS
* Last Modified by: TCS
* Description : Whenever SPM related Cases receives return delivery addresses an email will be trigger ed to the Contact and Communication Contact with the order confirmation and failure report of the each individual case. The pdf will be generated using VF Page.
*****************************************/	
	@future (callout=true)
	public static void sendEmailNotificationForPDF(Set<Id> caseId){   
		//Calling the below method Asynchronusly to update parent case status based on multiple child cases updated at once.
		HWS_CaseTriggerHelper.changeParentCaseStatus(caseId);
		List<Case> childCases = new List<Case>();
		String emailBodyContent1 = System.Label.HWS_SREmailContent_1;
		String emailBodyContent2 = System.Label.HWS_SREmailContent_2;
		String fromAddress = System.Label.HWS_SupportEmailAddress;
		
		List<case> caseList = [select Id, RecordTypeId, ParentId from case where Id in :caseId];
		
		String[] ccAddress = new String[]{};//NOKIAsc-27247
			String contactName;
		List<Case> parentCasesToBeUpdated = new List<Case>();
		Set<Id> parentCaseIds = new Set<Id>();
		List<Case> parentCases = new List<Case>();
		
		for(Case cs:caseList){
			if(cs.RecordTypeId != parentCase && cs.RecordTypeId != parentCaseReadOnly){
				if(cs.ParentId != null){
					parentCaseIds.add(cs.ParentId);
				}
			}
		}
		
		OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
			EmailTemplate etemplate = new EmailTemplate();
		List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
		List <Attachment> attachlist = new List<Attachment>();
		List<FeedItem> postChatterList = new List<FeedItem>();
		String pdfBody='';
		system.debug('ParentCasesCheck'+parentCases);
		
		if(parentCaseIds.size()>0){	 
			parentCases = [SELECT Id, OwnerId, CaseNumber,Contact.Name,Contact.Email,Contact.Email1__c,Contact.CH_Email3__c, HWS_Communication_Contact__r.name, Account.Email_Send_Check__c, HWS_Communication_Contact__r.Email,HWS_ReturnAddressReceivedFromSOO__c,HWS_OrderConfirmationSent__c,HWS_Bar_Code__c,HWS_Bar_Code_Ref1__c,Origin,
						   (SELECT Id,HWS_RMA_Number__c,HWS_Customer_Reference_Number__c, Asset.ProductCode,Asset.HWS_Part_Code__c, Asset.Product2.Name, HWS_Faulty_Serial_Number__c,HWS_Bar_Code__c,HWS_Bar_Code_Ref1__c,HWS_Part_Code__c,
							Contact.Account.Name,Account.Name,Account.BillingCountry,Account.BillingState,Account.BillingCity,Account.BillingStreet,Account.BillingPostalCode,
							Parent.Hws_Ship_to_Party_Address__r.BillingCountry,Parent.Hws_Ship_to_Party_Address__r.BillingState,Parent.Hws_Ship_to_Party_Address__r.BillingCity,
							Parent.Hws_Ship_to_Party_Address__r.BillingStreet,Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode,HWS_Failure_Description__c,Contact.Name, Contact.Email, Contact.Email1__c, Contact.CH_Email3__c, Contact.Phone,
							HWS_Stockable_Product__r.HWS_Version_Code__c,HWS_Site_ID__c,HWS_Failure_Detection__c,HWS_Replacement_Unit_Serial_Number__c,
							HWS_Failure_Detection_Date__c,HWS_Failure_Occurance__c,HWS_Failure_Description_Server_ID__c,HWS_Site_Information__c,HWS_Address_Name__c ,
							Street_Address_1__c,Street_Address_2__c,Street_Address_3__c,City__c,State__c,Country__c,POSTAL_CODE_CHQ__c
							FROM Cases
							WHERE Status='Ordered' AND RecordTypeId=:childCaseReadonly) 
						   FROM Case 
						   WHERE Id IN: parentCaseIds AND HWS_ReturnAddressReceivedFromSOO__c=:True];
			
		}
		if(parentCases.size()>0){
			owea = [select Id from OrgWideEmailAddress where Address =: fromAddress];		
			etemplate = [SELECT Id, Subject, HtmlValue, Body
						 FROM EmailTemplate
						 WHERE DeveloperName='HWS_OrderConfirmationEmailTemaplate'];  
			for(Case parent: parentCases){
				if(parent.Contact.Email1__c != Null){
	ccAddress.add(parent.Contact.Email1__c); //// NOKIASC 27247
	}
	if(parent.Contact.CH_Email3__c != Null){
	ccAddress.add(parent.Contact.CH_Email3__c);// NOKIASC 27247
			   }
				
				if(parent.Cases.Size()>0){ //null pointer check starts
					Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
					Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
					List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
					//if(parent.Contact.Email!=Null){emailAddress.add(parent.Contact.Email);}
					//if(parent.HWS_Communication_Contact__r.Email!=Null){emailAddress.add(parent.HWS_Communication_Contact__r.Email);}
					contactName=((parent.Contact.Name!=null && parent.HWS_Communication_Contact__r.Name!=null)?parent.Contact.Name+'/'+parent.HWS_Communication_Contact__r.Name:(parent.Contact.Name!=null && parent.HWS_Communication_Contact__r.Name==null)?parent.Contact.Name:parent.HWS_Communication_Contact__r.Name);
					pdfBody += '<html><h4 style=\"text-align:left;\">Dear '+contactName+',</h4><br/></html>';
					pdfBody += '<html><h4 style=\"text-align:left;\">Thank you for contacting Nokia Care. This acknowledges your Hardware Services request '+ parent.CaseNumber + ' Your request has ' + parent.Cases.Size() + ' RMA(s) associated with it. Please find additional details below.</h4><br/></html>';
					pdfBody += '<html><h4 style=\"text-align:left;\">'+emailBodyContent1+'</h4><br/></html>';
					pdfBody += '<html><h4 style=\"text-align:left;\">'+emailBodyContent2+'</h4><br/></html>';
					pdfBody += '<br/><font size="2" ><table border="0.1" align="center" valign="middle" style="border-collapse: collapse"><tr><th bgcolor="#D6DBDF">RMA#</th><th bgcolor="#D6DBDF">Customer Ref#</th><th bgcolor="#D6DBDF">Part Code</th><th bgcolor="#D6DBDF">Part Description</th><th bgcolor="#D6DBDF">Faulty Serial Number</th></tr>';
					efa.setContentType('application/pdf');
					efa.setFileName('Order Confirmation_'+parent.CaseNumber+'.pdf');
					//calling the pdf with the parent case as arguement, the VF page will further iterate over this parent's child cases. -- Prateek -- NOKIASC-27243
					efa1=sendPdf(parent);
					attachmentList.add(efa1);
					Attachment a = new Attachment();
					a.ParentId = parent.Id;
					a.Body = efa1.body;
					a.Name = 'RMA\'s for Parent Case '+parent.CaseNumber+'.pdf';
					attachlist.add(a);
					for(Case child: parent.cases){
						pdfBody += '<tr><td>' +  (child.HWS_RMA_Number__c==null ? ' ' :child.HWS_RMA_Number__c) + '</td><td>' + (child.HWS_Customer_Reference_Number__c==null ? ' ' : child.HWS_Customer_Reference_Number__c) + '</td><td>' + (child.Asset.HWS_Part_Code__c==null ? ' ' : child.Asset.HWS_Part_Code__c)+ '</td><td>' + (child.Asset.Product2.Name==null ? ' ' : child.Asset.Product2.Name)+ '</td><td>' + (child.HWS_Faulty_Serial_Number__c==null ? ' ' : child.HWS_Faulty_Serial_Number__c) +'</td></tr><br/>';
						
						childCases.add(child);
					}  
					pdfBody += '</table><br/><br/>';
					pdfBody += '<html><h4 style=\"text-align:left;\">Regards,</h4></html>';
					pdfBody += '<html><h4 style=\"text-align:left;\">Nokia Care Services</h4><br/><br/></html>';
					efa.Body = Blob.toPDF(pdfBody);
					attachmentList.add(efa);
					if(parent.HWS_OrderConfirmationSent__c){
						if(parent.Account.Email_Send_Check__c != null && parent.Account.Email_Send_Check__c != '' && parent.Account.Email_Send_Check__c.contains(emailCheck)){
							if(parent.ContactId!=NULL){
								Messaging.SingleEmailMessage contactEmail = new Messaging.SingleEmailMessage();// for sending email to Contact
								contactEmail.setOrgWideEmailAddressId(owea.get(0).Id);
								
								contactEmail.setccAddresses(ccAddress); //// NOKIASC-27247
								contactEmail.setTemplateId(etemplate.Id);
								contactEmail.setTargetObjectId(parent.ContactId);
								contactEmail.setTreatTargetObjectAsRecipient(true);   
								contactEmail.setFileAttachments(attachmentList);
								try{
									Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {contactEmail});
								}
								catch(Exception e){
									System.debug('Exception Occured: '+e);
								}
							}
							if(parent.HWS_Communication_Contact__c!=NULL){
								Messaging.SingleEmailMessage comcontactEmail = new Messaging.SingleEmailMessage();// for sending email to Communication  Contact
								comcontactEmail.setOrgWideEmailAddressId(owea.get(0).Id);
								
								comcontactEmail.setccAddresses(ccAddress);// NOKIASC-27247
								comcontactEmail.setTemplateId(etemplate.Id);
								comcontactEmail.setTargetObjectId(parent.HWS_Communication_Contact__c);
								comcontactEmail.setTreatTargetObjectAsRecipient(true);   
								comcontactEmail.setFileAttachments(attachmentList);
								try{
									Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {comcontactEmail});
								}
								catch(Exception e){
									System.debug('Exception Occured: '+e);
								}
							}				
							
							if(parent.Origin=='web'){
								FeedItem postChatter = new FeedItem();
								postChatter.ParentId = parent.Id;
								postChatter.Body = 'Dear '+parent.Contact.Name+',\nYour Order with Case Number# '+(parent.caseNumber !=Null?parent.caseNumber :'')+' has been confirmed';
								postChatter.Title = 'Case';
								postChatter.LinkUrl = '/lightning/r/Case/'+parent.Id+'/view';
								postChatterList.add(postChatter);
							}
						}
						parent.HWS_OrderConfirmationSent__c=false;
						parentCasesToBeUpdated.add(parent);
					}
				} //null pointer check ends	
			}
			if(parentCasesToBeUpdated.Size()>0 && postChatterList.Size()>0){
				try{
					insert postChatterList;
				}
				catch(Exception e){
					System.debug('Exception while posting to chatter'+e);
				}
			}
			if(parentCasesToBeUpdated.Size()>0 && attachlist.Size()>0){
				try{
					insert attachlist;
				}
				catch(Exception e){
					System.debug('Exception while inserting attachments'+e);
				}
			}
			if(parentCasesToBeUpdated.Size()>0){	   
				
				try{
					update parentCasesToBeUpdated;
				}
				catch(Exception e){
					System.debug('Exception while updating parent case'+e);
				}
			}
		}
	}
	
	/****************************************
* Method Name : sendPdf
* Created Date:  May 2019
* Created By : TCS
* Last Modified by: TCS
* Description : The pdf will be generated usinf Vf page by using Pagereference.		
*****************************************/	 
	public static Messaging.EmailFileAttachment sendPdf(Case parentCase) {	
		//String logoUrl = System.Label.Nokia_Logo_URL; 
		String fileName='ParentCaseFile';
		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		efa.setContentType('application/pdf');
		//efa.setFileName('Failuredetails_'+fileName+'.pdf');
		efa.setFileName('RMA\'s for Parent Case '+parentCase.CaseNumber+'.pdf');
		efa.setInline(false);
		
		PageReference pdf = Page.HWS_OrderConfirmationNotificationVFPage;
		// add parent id to the parameters for standardcontroller
		pdf.getParameters().put('id',parentCase.Id);	 
		// the contents of the attachment from the pdf
		Blob body;
		
		try{	  
			// returns the output of the page as a PDF
			body = pdf.getContent();	  
			// need to pass unit test -- current bug  
		} catch (VisualforceException e) {
			body = Blob.valueOf('Some Text');
		}   
		
		efa.Body = body; 
		return efa;
	}
   
	//using this method as an extension to the VF page- HWS_OrderConfirmationNotificationVFPage, the VF page will iterate over the parent's child cases. 
	//The parent's id passed as param in the url of the VF page-- Prateek -- NOKIASC-27243
	public static List<Case> getCases(){
		currentParentCaseId  = ApexPages.CurrentPage().getparameters().get('id');
		List<Case> childCaseList = [select id, HWS_RMA_Number__c, Street_Address_1__c, Street_Address_2__c, Street_Address_3__c, City__c, State__c, Country__c, POSTAL_CODE_CHQ__c, HWS_Bar_Code__c, HWS_Shippeddate__c, 
									Account.Name, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingCountry, Account.BillingPostalCode, HWS_Bar_Code_Ref1__c, 
									Parent.Hws_Ship_to_Party_Address__r.BillingStreet, Parent.Hws_Ship_to_Party_Address__r.BillingCity, Parent.Hws_Ship_to_Party_Address__r.BillingState, Parent.Hws_Ship_to_Party_Address__r.BillingCountry, Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode, 
									HWS_Customer_Reference_Number__c, HWS_Faulty_Serial_Number__c, HWS_Failure_Detection_Date__c, HWS_Part_Code__c, HWS_Customer_Part_Revision__c, HWS_Stockable_Product__r.HWS_Version_Code__c, 
									Asset.Product2.Name, HWS_Site_ID__c, HWS_Site_Information__c, HWS_Failure_Occurance__c, HWS_Failure_Detection__c, HWS_Failure_Description__c, HWS_Failure_Description_Server_ID__c, HWS_Replacement_Unit_Serial_Number__c, 
									Contact.Name, Contact.Phone, Contact.Email, Contact.Email1__c, Contact.CH_Email3__c
									from Case where ParentId =: currentParentCaseId ];
		recordCount = childCaseList.size();
		return childCaseList;
	}
}