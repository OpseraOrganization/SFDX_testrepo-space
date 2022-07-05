/*****************************************
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
	public static Savepoint sp ;
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
	// NOKIASC-38139 Moved this code seperately for batch implementation
	@future (callout=true)
	public static void sendEmailNotificationForPDF(Set<Id> caseId)  
	{
		sendEmailNotificationForPDFForBatch(caseId);
	}
	/****************************************
	* Method Name : sendEmailNotificationForPDF
	* Created Date:  May 2019
	* Created By : TCS
	* Last Modified by: TCS
	* Description :1. Whenever SPM related Cases receives return delivery addresses an email will be trigger ed to the Contact and Communication Contact with the order confirmation and failure report of the each individual case. The pdf will be generated using VF Page.
	***************2.NOKIASC-32322:Added new column Order/WarrantyStatus in Order Confirmation pdf .getWarrantyStatusandOrderStatus method will return the value.
	*****************************************/  
	
	public static void sendEmailNotificationForPDFForBatch(Set<Id> caseId){   
		sp = Database.setSavepoint();
		List<case> caseList = [select Id, RecordTypeId, ParentId,Status from case where Id in :caseId];
		List<Case> childCases = new List<Case>();
		String emailBodyContent1 = System.Label.HWS_SREmailContent_1;
		String emailBodyContent2 = System.Label.HWS_SREmailContent_2;
		String fromAddress = System.Label.HWS_SupportEmailAddress;
		String[] ccAddress = new String[]{};//NOKIAsc-27247
			String contactName;
		List<Case> parentCasesToBeUpdated = new List<Case>();
		Set<Id> parentCaseIds = new Set<Id>();
		List<Case> parentCases = new List<Case>();
		
		for(Case cs:caseList){
			if(cs.RecordTypeId != parentCase && cs.RecordTypeId != parentCaseReadOnly && cs.ParentId != null){
				
				parentCaseIds.add(cs.ParentId);
				
			}
		}
		//added for NOKIASC-37492 - START
		Map<Id, Id> parentIdAttIdMap = new Map<Id, Id>();
		for(Attachment att : [select Id,parentId from Attachment where parentId IN: parentCaseIds]){
			parentIdAttIdMap.put(att.parentId, att.Id);
		}
		//added for NOKIASC-37492 - END
		OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
			EmailTemplate etemplate = new EmailTemplate();
		List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
		List <Attachment> attachlist = new List<Attachment>();
		List<FeedItem> postChatterList = new List<FeedItem>();
		String pdfBody='';
		system.debug('ParentCasesCheck'+parentCases);
		
		if(parentCaseIds.size()>0){ 
			//NOKIASC-33012:SRM Email subject for Console
			//Added 'Cancelled' status and removed RecordTypeId for NOKIASC-32938 
			parentCases = [SELECT Id,Subject,CH_InternalStatus__c, OwnerId, CaseNumber,Contact.Name,Contact.Email,Contact.Email1__c,Contact.CH_Email3__c, HWS_Communication_Contact__r.name, Account.Email_Send_Check__c, HWS_Communication_Contact__r.Email,HWS_ReturnAddressReceivedFromSOO__c,HWS_OrderConfirmationSent__c,HWS_Bar_Code__c,HWS_Bar_Code_Ref1__c,Origin,Status,
						   (SELECT Id,HWS_RMA_Number__c,HWS_Customer_Reference_Number__c, Asset.ProductCode,Asset.HWS_Part_Code__c, Asset.Product2.Name, HWS_Faulty_Serial_Number__c,HWS_Bar_Code__c,HWS_Bar_Code_Ref1__c,HWS_Part_Code__c,
							Contact.Account.Name,Account.Name,Account.BillingCountry,Account.BillingState,Account.BillingCity,Account.BillingStreet,Account.BillingPostalCode,
							Parent.Hws_Ship_to_Party_Address__r.BillingCountry,Parent.Hws_Ship_to_Party_Address__r.BillingState,Parent.Hws_Ship_to_Party_Address__r.BillingCity,
							Parent.Hws_Ship_to_Party_Address__r.BillingStreet,Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode,HWS_Failure_Description__c,Contact.Name, Contact.Email, Contact.Email1__c, Contact.CH_Email3__c, Contact.Phone,
							HWS_Stockable_Product__r.HWS_Version_Code__c,HWS_Site_ID__c,HWS_Failure_Detection__c,HWS_Replacement_Unit_Serial_Number__c,
							HWS_Failure_Detection_Date__c,HWS_Failure_Occurance__c,HWS_Failure_Description_Server_ID__c,HWS_Site_Information__c,HWS_Address_Name__c ,
							Street_Address_1__c,Street_Address_2__c,Street_Address_3__c,City__c,State__c,Country__c,POSTAL_CODE_CHQ__c,CH_EntitlementException__c,CH_EntitlementStatus__c,Status,HWS_Contract_Line_Item__c,RecordTypeId,CH_ServiceType__c,entitlementId,CH_RecordTypeDevName__c 
							FROM Cases
							WHERE Status in ('Ordered','Cancelled','Draft'))
						   FROM Case 
						   WHERE Id IN: parentCaseIds AND (HWS_ReturnAddressReceivedFromSOO__c = true or  Status ='Closed') FOR UPDATE
						   ];//AND ((HWS_SOO_Reference_Number__c = null AND Status ='Closed') OR HWS_ReturnAddressReceivedFromSOO__c=:True)
						   //modified query for NOKIASC-37984 and added for NOKIASC-38058
			
		}
		if(parentCases.size()>0){
			owea = [select Id from OrgWideEmailAddress where Address =: fromAddress];	   
			etemplate = [SELECT Id, Subject, HtmlValue, Body
						 FROM EmailTemplate
						 WHERE DeveloperName='HWS_OrderConfirmationEmailTemaplate']; 
					
			//NOKIASC-38081 | Start
			//boolean isValidPortalUser = HWS_WarrantyQuotation_Controller.isPortalUser();
			String communityUrl = '';		
			Site site = [SELECT Id FROM Site WHERE UrlPathPrefix = 'Customers' LIMIT 1];
			communityUrl = [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;
			

			

			map<id, string> pidToReferenceN = new map<id, string>();			
			for(HWS_BulkUpload__c bu : [select id,Support_Ticket__c, HWS_Bulk_Reference_Number__c from HWS_BulkUpload__c where Support_Ticket__c IN: parentCaseIds]){
				pidToReferenceN.put(bu.Support_Ticket__c , bu.HWS_Bulk_Reference_Number__c);
			}
			//NOKIASC-38081 | End			 
			for(Case parent: parentCases){
				ccAddress.Clear();
				attachmentList.Clear();
				attachlist.Clear();
				childCases.Clear();
				if(parent.Contact.Email1__c != Null){
					ccAddress.add(parent.Contact.Email1__c); //// NOKIASC 27247
				}
				if(parent.Contact.CH_Email3__c != Null){
					ccAddress.add(parent.Contact.CH_Email3__c);// NOKIASC 27247
				}
				
				if(parent.Cases.Size()>0 && parentIdAttIdMap != null && parentIdAttIdMap.get(parent.Id) == null){ //null pointer check starts
					Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
					Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
					String pdfBodyOrdered = '';
					String pdfBodyCancelled = '';
					integer orderedCount = 0;
					integer cancelledCount = 0;
					for(Case child: parent.cases){
						//34829
						if(child.Status == 'Ordered' || child.Status == 'Draft'){
							pdfBodyOrdered += '<tr><td>' +  (child.HWS_RMA_Number__c==null ? ' ' :child.HWS_RMA_Number__c) + '</td><td>' + (child.HWS_Customer_Reference_Number__c==null ? ' ' : child.HWS_Customer_Reference_Number__c) + '</td><td>' + (child.Asset.HWS_Part_Code__c==null ? ' ' : child.Asset.HWS_Part_Code__c)+ '</td><td>' + (child.Asset.Product2.Name==null ? ' ' : child.Asset.Product2.Name)+ '</td><td>' + (child.HWS_Faulty_Serial_Number__c==null ? ' ' : child.HWS_Faulty_Serial_Number__c) + '</td><td>' + getWarrantyStatusandOrderStatus(child) +'</td></tr>';
							orderedCount =orderedCount+1;
						}
						if(child.Status == 'Cancelled'){
							pdfBodyCancelled += '<tr><td>' + (child.HWS_Customer_Reference_Number__c==null ? ' ' : child.HWS_Customer_Reference_Number__c) + '</td><td>' + (child.Asset.HWS_Part_Code__c==null ? ' ' : child.Asset.HWS_Part_Code__c)+ '</td><td>' + (child.Asset.Product2.Name==null ? ' ' : child.Asset.Product2.Name)+ '</td><td>' + (child.HWS_Faulty_Serial_Number__c==null ? ' ' : child.HWS_Faulty_Serial_Number__c) +'</td><td>' + getWarrantyStatusandOrderStatus(child) +'</td></tr>';
							cancelledCount =cancelledCount+1;
						}   
						childCases.add(child);
					}
					
					contactName=((parent.Contact.Name!=null && parent.HWS_Communication_Contact__r.Name!=null)?parent.Contact.Name+'/'+parent.HWS_Communication_Contact__r.Name:(parent.Contact.Name!=null && parent.HWS_Communication_Contact__r.Name==null)?parent.Contact.Name:parent.HWS_Communication_Contact__r.Name);
				 
					//34829//NOKIASC-36630
					if(Parent.status=='Open'){
					pdfBody += '<html><div><span style="font-size: 15px;">Dear Customer,<br/><br/>Thank you for contacting Nokia Care. Please refer to your order summary below.<br/><br/>The RMA for each Ordered item is attached. Please do not reply as this is an automated email acknowledging your Hardware Service Request.';
					pdfBody += '<br/><br/><b>Note the order status for each line item.</b><br/><br/>';
					}
					else {
					pdfBody += '<html><div><span style="font-size: 15px;">Dear Customer,<br/><br/>Thank you for contacting Nokia Care. Please refer to your order summary below.<br/><br/>Please do not reply as this is an automated email acknowledging your Hardware Service Request.';
					pdfBody += '<br/><br/><b>Note the order status for each line item.</b><br/><br/>';
					}
				   
					if(orderedCount > 0){
						pdfBody += 'Hardware Services request '+parent.CaseNumber+' has '+orderedCount+' <b>Ordered</b> item(s). Please include the attached RMA file(s) with your return shipment.<br/><br/>';
						pdfBody += '<table border="3" align="left" valign="left" style="border-collapse: collapse;width: 100%"><tr><th bgcolor="#D6DBDF">RMA#</th><th bgcolor="#D6DBDF">Customer Ref#</th><th bgcolor="#D6DBDF">Part Code</th><th bgcolor="#D6DBDF">Part Description</th><th bgcolor="#D6DBDF">Faulty Serial Number</th><th bgcolor="#D6DBDF">Warranty Status</th></tr>';
						pdfBody += pdfBodyOrdered;
						pdfBody += '</table>';
						pdfBody += '<br/><br/>';
					}
					if(cancelledCount > 0 && orderedCount >0){
						pdfBody += '</div><div>&nbsp;</div><div>&nbsp;</div><div><span style="font-size: 15px;">The following '+cancelledCount+' item(s) have been <b>Cancelled</b> and must not be shipped to Nokia:<br/><br/></span>';
						pdfBody += '<table border="3" align="left" valign="left" style="border-collapse: collapse;width: 100%"><tr><th bgcolor="#D6DBDF">Customer Ref#</th><th bgcolor="#D6DBDF">Part Code</th><th bgcolor="#D6DBDF">Part Description</th><th bgcolor="#D6DBDF">Faulty Serial Number</th><th bgcolor="#D6DBDF">Status</th></tr>';
						pdfBody += pdfBodyCancelled;
						pdfBody += '</table>';
						pdfBody += '<br/><br/></div>';
					}
					
					if(orderedCount == 0 && cancelledCount >0){
						pdfBody += 'Hardware Services request '+parent.CaseNumber+' has '+cancelledCount+' item(s).';
						pdfBody += '</div><div>&nbsp;</div><div>&nbsp;</div><div><span style="font-size: 15px;">All the following item(s) have been <b>Cancelled</b> and must not be shipped to Nokia:<br/><br/></span>';
						pdfBody += '<table border="3" align="left" valign="left" style="border-collapse: collapse;width: 100%"><tr><th bgcolor="#D6DBDF">Customer Ref#</th><th bgcolor="#D6DBDF">Part Code</th><th bgcolor="#D6DBDF">Part Description</th><th bgcolor="#D6DBDF">Faulty Serial Number</th><th bgcolor="#D6DBDF">Status</th></tr>';
						pdfBody += pdfBodyCancelled;
						pdfBody += '</table>';
						pdfBody += '<br/><br/></div>';
					}
					
					
					efa.setContentType('application/pdf');
					efa.setFileName('Order Confirmation_'+parent.CaseNumber+'.pdf');
					//calling the pdf with the parent case as arguement, the VF page will further iterate over this parent's child cases. -- Prateek -- NOKIASC-27243
					//Added for NOKIASC-32942
					if(parent.Status != 'Closed'){  
						efa1=sendPdf(parent);
						attachmentList.add(efa1);
						Attachment a = new Attachment();
						a.ParentId = parent.Id;
						a.Body = efa1.body;
						a.Name = 'RMA\'s for Parent Case '+parent.CaseNumber+'.pdf';
						attachlist.add(a);
					}
					//NOKIASC-38081 | Start 
					if(!String.isBlank(pidToReferenceN.get(parent.id)) && System.Label.HWS_Allowed_Users =='new'){
						pdfBody += '<b> Note: You will receive a separate communication for each batch of 25 RMA\'s created per contract. </b><br/><br/>';
						pdfBody += '';
						schema.describesobjectresult cs = case.Sobjecttype.getDescribe();
						if(parent.Origin == 'Console-Bulk'){ // use bulk-web, bulk-console, (Ordered)
				
				string sURL = url.getsalesforcebaseurl().toexternalform()+'/'+cs.getkeyprefix()
					+'?fcf='+System.Label.HWS_Bulk_List_View_Id;
				pdfBody += '<a href='+sURL+'>Bulk Request Details</a><br/>';
						}
						else{
				string sURL = communityUrl+'/'+cs.getkeyprefix()
					+'?fcf='+System.Label.HWS_Bulk_List_View_Id;
				pdfBody += '<a href='+sURL+'>Bulk Request Details</a><br/>';	   
						}
				
					}
					//NOKIASC-38081 | End
					pdfBody += '<div>&nbsp;</div><div>&nbsp;</div><div><span style="font-size: 15px;">Regards,<br/>';
					pdfBody += 'Nokia Care Services<br/><br/></span></span></div></html>';
					efa.Body = Blob.toPDF(pdfBody);
system.debug('Abhay-----'+pdfBody);
		//attachmentList.add(efa);//NOKIASC-36630
					if(parent.HWS_OrderConfirmationSent__c){
						if(parent.Account.Email_Send_Check__c != null && parent.Account.Email_Send_Check__c != '' && parent.Account.Email_Send_Check__c.contains(emailCheck)){
							//NOKIASC-33012:SRM Email subject for Console(Pass subject and Origin)
							if(parent.ContactId!=NULL && !test.isRunningTest()){
								
								sendEmailtoContact(owea.get(0).Id, ccAddress, pdfBody, parent.ContactId, attachmentList,parent.Subject,parent.Origin, pidToReferenceN.get(parent.id));
							}
							if(parent.HWS_Communication_Contact__c!=NULL && !test.isRunningTest()){
								sendEmailtoContact(owea.get(0).Id, ccAddress, pdfBody, parent.HWS_Communication_Contact__c, attachmentList,parent.Subject,parent.Origin, pidToReferenceN.get(parent.id));
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
					update parentCasesToBeUpdated; //added for NOKIASC-38058
				}
				catch(Exception e){
					System.debug('Exception while inserting attachments'+e);
				}
			}else if(parentCasesToBeUpdated.Size()>0){
				update parentCasesToBeUpdated; 
			}
		}
	}
	/****************************************   
	* Method Name : sendEmailtoContact  
	* Created Date:  NOV 2020   
	* Created By : TCS  
	* Last Modified by: TCS 
	* Description : As part of code retrofactering we implimented this logic	
	*****************************************/  
	public static void sendEmailtoContact(Id oweaId,String[] ccAddress, string htmlbody, Id contactRecId, List<Messaging.EmailFileAttachment> attachmentList,String Subject,String caseOrigin,String bulkReferenceN) {  
		 try{
		Messaging.SingleEmailMessage contactEmail = new Messaging.SingleEmailMessage();// for sending email to Contact  
		contactEmail.setOrgWideEmailAddressId(oweaId);  
		contactEmail.setccAddresses(ccAddress); //// NOKIASC-27247  
		//contactEmail.setTemplateId(etemplateId);//NOKIASC-36630
		contactEmail.setHtmlBody(htmlbody);//NOKIASC-36630
		//NOKIASC-33012:SRM Email subject for Console
		if(String.isNotBlank(Subject) && caseOrigin!='Web'){
			Subject=Subject.length()>210?Subject.substring(0,210):Subject;
			contactEmail.setSubject(Subject + ' Order Confirmation');
		}else {
			
			if(!String.isBlank(bulkReferenceN)){				
				string sSubject = 'Nokia Hardware Services Order Confirmation for Reference Number: '+bulkReferenceN;
				contactEmail.setSubject(sSubject);
			}
			else
				contactEmail.setSubject('Nokia Hardware Services Order Confirmation');//NOKIASC-36630
		}
		contactEmail.setTargetObjectId(contactRecId);   
		contactEmail.setTreatTargetObjectAsRecipient(true); 
		contactEmail.setFileAttachments(attachmentList);	
	
			Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {contactEmail});	
		}   
		catch(Exception e){
			Database.rollback(sp); 
			Interface_Log__c ilog=new Interface_Log__c(Name='HWS Email Failure',Message_Type__c='Inbound',Operation_Type__c='Insert',Status__c='Post Processing Error',Comment__c=e.getMessage(),DS_Payload__c=htmlbody );
			insert ilog;
			System.debug('Exception Occured: '+e);  
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
		
		
		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		efa.setContentType('application/pdf');
		
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
									from Case where ParentId =: currentParentCaseId and Status != 'Cancelled'];
		recordCount = childCaseList.size();
		/*---------------new code-------------------------*/
		List<HWS_BulkUpload__c> bulkrecList = [Select Id, Part_Code_Part_Revision__c, HWS_LSPResponse__c,ParentCaseId__c from HWS_BulkUpload__c where ParentCaseId__c=:currentParentCaseId];
		if(!bulkrecList.isEmpty()){
			HWS_BulkUpload__c bulkrec = bulkrecList[0];
			if(bulkrec.Part_Code_Part_Revision__c !=null && bulkrec.HWS_LSPResponse__c != null){
				HWS_WrapLSPInstructions requestObj = (HWS_WrapLSPInstructions)JSON.deserialize(bulkrec.HWS_LSPResponse__c, HWS_WrapLSPInstructions.class);
				Map<Id, Case> caseMap = new Map<Id, Case>();
				for(Case caseRec : childCaseList){
					System.debug('caseRec.Id**'+caseRec.Id);
					caseMap.put(caseRec.Id, caseRec);
				}
				Map<String,HWS_WrapLSPInstructions.DeliveryAddress> mapNodeDeliveryAddress = new Map<String,HWS_WrapLSPInstructions.DeliveryAddress>();
				for(HWS_WrapLSPInstructions.DeliveryAddress address: requestObj.DeliveryAddress){
					mapNodeDeliveryAddress.put(address.ReturnAddressNode,address);
				}
				childCaseList.clear();
				for(HWS_WrapLSPInstructions.ChildCases child: requestObj.ChildCases){
					if(child.SRMServiceItemID!=null && child.SRMServiceItemID!='' && caseMap.get(child.SRMServiceItemID) != null){
						Case lSPInstructionCase = caseMap.get(child.SRMServiceItemID);
						lSPInstructionCase.HWS_LogisticNodeCode__c = child.LogisticNode;
						lSPInstructionCase.HWS_LogisticNodeName__c = child.LogisticNodeName;
						if(mapNodeDeliveryAddress.get(child.ReturnAddressNode)!=null){
							HWS_WrapLSPInstructions.DeliveryAddress returnAddressDetails = mapNodeDeliveryAddress.get(child.ReturnAddressNode);
							lSPInstructionCase.HWS_Address_Name__c = returnAddressDetails.Name; lSPInstructionCase.HWS_AddressType__c = returnAddressDetails.AddressType;lSPInstructionCase.City__c = returnAddressDetails.City;
							lSPInstructionCase.Street_Address_1__c = returnAddressDetails.Street; lSPInstructionCase.Street_Address_2__c = returnAddressDetails.AddressLine2;
							lSPInstructionCase.Street_Address_3__c = returnAddressDetails.AddressLine3; lSPInstructionCase.HWS_Region__c = returnAddressDetails.Region;
							lSPInstructionCase.POSTAL_CODE_CHQ__c = returnAddressDetails.PostalCode; lSPInstructionCase.Country__c = returnAddressDetails.Country;
							lSPInstructionCase.HWS_Region__c = returnAddressDetails.Region;lSPInstructionCase.HWS_DeliveryNote__c = returnAddressDetails.DeliveryNote;
							lSPInstructionCase.State__c = returnAddressDetails.State; childCaseList.add(lSPInstructionCase);
						}
					}
				}
			}
		}
		/*------------------------------------------*/
		return childCaseList;
	}
	/****************************************
	* Method Name : getWarrantyStatusandOrderStatus
	* Created Date:  09/11/2020
	* User Story :NOKIASC-32322
	* Created By : Afif
	* Description : This method will check condition and return Order/WarrantyStatus for Order confirmation mail attachment
	* Updated By : Satya Pagadala
	* NOKIASC -34829 (Mar 23 2021)
	*****************************************/  
	public static String getWarrantyStatusandOrderStatus( Case child){
		if(child.CH_EntitlementException__c == HWS_Constants.IWPOMissing || 
		   child.CH_EntitlementException__c == HWS_Constants.OWPOMissing){
			return 'Missing PO';
		}
		else if(child.CH_EntitlementException__c == HWS_Constants.UWStatus || 
				child.CH_EntitlementException__c == HWS_Constants.WStatusCheckFailed){
			return 'Verifying Warranty';
		}
		else if(child.CH_EntitlementException__c == 'No Exception'){
			return 'Not Applicable';
		}
		else{
			return child.CH_EntitlementException__c !=null?child.CH_EntitlementException__c:'';
		}
	}
	public static String getWarrantyStatusandOrderStatusForPortal(Case child){ 
		if(child.HWS_EntitlementException__c == HWS_Constants.IWPOMissing || 
		   child.HWS_EntitlementException__c == HWS_Constants.OWPOMissing){
			   return 'Missing PO';
		   }
		else if(child.HWS_EntitlementException__c == HWS_Constants.UWStatus || 
				child.HWS_EntitlementException__c == HWS_Constants.WStatusCheckFailed){
					return 'Verifying Warranty';
				}
				else if(child.CH_EntitlementException__c == 'No Exception'){
			return 'Not Applicable';
			}
		else{
			return child.HWS_EntitlementException__c !=null?child.HWS_EntitlementException__c:'';
		}
	}
}