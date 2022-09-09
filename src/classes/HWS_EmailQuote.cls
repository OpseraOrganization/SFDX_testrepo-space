/****************************************************************
* Class Name : HWS_EmailQuote 
* Created Date: 19-11-2021
* Created By: TCS
* Description : This Class Contains Common logic for sending to VF pages  HWS_EmailQuote and HWS_PreviewPdf
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date
Pavan Chereddy  HWSDDP-140		  09/12/2021

******************************************************************/

Public Without sharing class HWS_EmailQuote {  
	Public Static HWS_Service_Quote__c[] serviceQuoteLst  { get; set; }
	Public Static HWS_Service_Quote__c serviceQuote  { get; set; }
	Public Static HWS_Service_Quote__c serviceQuoteLineItem  { get; set; }
	Public Static List<HWS_ServiceFee_Discount__c> lstDiscount  { get; set; }
	Public Static string getRecordTypeName {get; set;}
	Public Static DateTime getQuoteExpirationDate {get; set;}
	Public Static DateTime getQuoteSentDate {get; set;}
	Public Static String isValidUser { get; set; }
		
	Public HWS_EmailQuote(ApexPages.StandardController caseController) {
		serviceQuote = (HWS_Service_Quote__c) caseController.getRecord();
		serviceQuoteLineItem=[Select Id,HWS_CDB_ContractLineItemID__c,RecordTypeId,HWS_CaresAgreementUniqueId__c,HWS_Quote_Total__c,HWS_Quote_Expiration_Days__c,
								HWS_Support_Ticket__r.Account.Name,HWS_Support_Ticket__r.Contact.Name,HWS_Support_Ticket__r.Contact.Phone,
							  (Select Id,HWS_Order_Number__c,HWS_Description__c,HWS_Exclusion_Category__c,HWS_Unit_List_Price__c,HWS_Quantity__c,HWS_Gross_Price__c,HWS_Discount__c,HWS_Unit_Net_Price__c  
																																	 from   Quote_Line_Item__r Where HWS_Fee_Inclusion__c=True) from HWS_Service_Quote__c  where Id =:serviceQuote.Id];
		List<HWS_Service_Quote__c> lstQuote = [SELECT id,HWS_CDB_ContractLineItemID__c,RecordTypeId,HWS_CaresAgreementUniqueId__c,HWS_Quote_Expiration_Days__c,HWS_Quote_Total__c,Ownerid from HWS_Service_Quote__c WHERE Id=: serviceQuote.Id LIMIT 1];
		if(lstQuote.size()> 0 && !string.ISBLANK(lstQuote[0].HWS_CDB_ContractLineItemID__c)){
	getRecordTypeName = Schema.SObjectType.HWS_Service_Quote__c.getRecordTypeInfosById().get(lstQuote[0].RecordTypeId).getDeveloperName();
			 lstDiscount=HWS_EmailQuote.getServiceFeeDiscountDetails(lstQuote[0].RecordTypeId,lstQuote[0].HWS_CDB_ContractLineItemID__c,lstQuote[0].HWS_CaresAgreementUniqueId__c);
		}
		if(lstQuote.size()> 0){ 
			DateTime getCurrentDateTime = DateTime.now();
			Integer getEligibleDays = (lstQuote[0].HWS_Quote_Expiration_Days__c!= null) ? Integer.valueof(lstQuote[0].HWS_Quote_Expiration_Days__c) : 0;
			getQuoteExpirationDate = getCurrentDateTime.addDays(getEligibleDays);
			getQuoteSentDate=DateTime.now();
			Boolean isPreviewPdf=HWS_EmailQuote.userAccessCheck(lstQuote[0].Id);
			if(!isPreviewPdf){ isValidUser='You are not authorized to view the page';}
		}
		
	}
	
	
	/*******************************************************
	* Method Name : emailQuote 
	* Description : This Method will check the validations and trigger the email for the RMA Contact, Customer Contact 1 and Customer Contact 2 
	*********************************************************/ 
	@AuraEnabled
	Public Static string emailQuote(Id recrdId , Boolean isFromUI) {
		Map<Id,String> contactMapString =new Map<Id,String>();
		List<HWS_Service_Quote__c> serviceQuoteLst;
		List<Id> conList =new List<Id>();	   
	   Set<String> activeContactEmails =new Set<String>();
		String errorMessage ;
		List<string> lstInActiveContacts =new List<string>();
		String attachmentName;
		List<CH_EmailAlert__c> emailAlertList = new List<CH_EmailAlert__c>();
		List<Attachment> lstAttachment=new List<Attachment>();
		String getEmailTemp;
		String nokiaEmail;
		//***********Validations for Email Quote
		serviceQuoteLst=[Select Id,Name,HWS_Quotation_Contact_Email__c,HWS_RMA_Number__c,HWS_Response_Resolution__c,HWS_AttachmentName__c,HWS_AttachmentId__c,
						 HWS_Quote_Sent_Date__c,HWS_Quote_Expiration_Date__c,HWS_Quote_Status__c,HWS_Customer_Accepted_Rejected_Date__c,HWS_Reason_for_Rejection__c,
						 HWS_Disposition_Instructions__c,HWS_Is_Quote_Expired__c,HWS_Suspension__c,
						 HWS_Quote_Expiration_Days__c,HWS_Support_Ticket__r.Contact.Id,HWS_Customer_ContactId_1__c,HWS_Customer_ContactId2__c,HWS_Nokia_Email__c,
						 OwnerId,RecordTypeId,HWS_CDB_ContractLineItemID__c,HWS_CaresAgreementUniqueId__c,HWS_Quote_Status_Reason__c from HWS_Service_Quote__c where Id =:recrdId];  
		string recordTypeName = Schema.SObjectType.HWS_Service_Quote__c.getRecordTypeInfosById().get(serviceQuoteLst[0].RecordTypeId).getDeveloperName();
		//Check if logged in user is owner or not
		if(serviceQuoteLst.size()> 0 && serviceQuoteLst[0].OwnerId != null && serviceQuoteLst[0].Ownerid != userinfo.getUserId() && isFromUI){
			errorMessage='You are not the Authorized Owner To Perform Action';
		}
		//If loggedin user is the owner checking email quote validations
		else{  
			for(HWS_Service_Quote__c serQuote:serviceQuoteLst){
				if(serQuote.HWS_Support_Ticket__r.Contact.Id !=null){
					contactMapString.put(serQuote.HWS_Support_Ticket__r.Contact.Id,'RMA Contact'); 
					conList.add(serQuote.HWS_Support_Ticket__r.Contact.Id);
				}
				if(serQuote.HWS_Customer_ContactId_1__c !=null){
					contactMapString.put(serQuote.HWS_Customer_ContactId_1__c,'Customer Contact 1');
					conList.add(serQuote.HWS_Customer_ContactId_1__c);
				}
				if(serQuote.HWS_Customer_ContactId2__c !=null){
					contactMapString.put(serQuote.HWS_Customer_ContactId2__c,'Customer Contact 2');
					conList.add(serQuote.HWS_Customer_ContactId2__c);
				}
				if(serQuote.HWS_Nokia_Email__c !=null){
					nokiaEmail=serQuote.HWS_Nokia_Email__c;
				}
				
			}
			if(conList.size()>0 && !conList.isEmpty())  {
				for(User userlist:[SELECT id,Contact.Id,contact.Email,isActive,isPortalEnabled FROM User where Contact.Id IN : conList and isPortalEnabled = True]){
					if(userlist.isActive == false){
						lstInActiveContacts.add(contactMapString.get(userlist.contact.Id)); 
					}
					else{
						activeContactEmails.add(userlist.contact.Email);
					}
					
				}   
			} 
			//If RMA Contact or Customer Contact 1 is InActive will send error message 
			if(lstInActiveContacts.size()>0 && !lstInActiveContacts.isEmpty()){
				String userInact=lstInActiveContacts.toString().replace('(', '').replace(')', '');
				errorMessage = 'Email Sent Successfully except for Inactive Contacts :'+'\n'+ userInact +'\n';  
				
			}
			//Check if all the contacts are inactive contacts
			if(conList.size()>0&& !conList.isEmpty()&& lstInActiveContacts.size()>0 && !lstInActiveContacts.isEmpty()&& conList.size()==lstInActiveContacts.size()){
				errorMessage = 'Email Cannot be sent as all are Inactive Contacts';  
			}
			if(!serviceQuoteLst.ISEMPTY() && !activeContactEmails.ISEMPTY()){
				// Add Parent Id to the parameters for standardcontroller
				PageReference pdfPage = Page.HWS_EmailQuote;
				pdfPage.getParameters().put('Id',serviceQuoteLst[0].Id);
				Blob pdfBlob;
	if(Test.isRunningTest()) { pdfBlob = blob.valueOf('Unit.Test'); } 
				else{ pdfBlob = pdfPage.getContent(); }
				String base64Pdf = EncodingUtil.base64Encode(pdfBlob);
				// Insert the  attachment 
				Attachment attachRec= new Attachment();
				attachRec.ParentId = recrdId;
				if(recordTypeName == 'HWS_Damaged_Part_Quote'){attachmentName = 'Nokia Return Exclusions Service Quote_'+serviceQuoteLst[0].Name+' Nokia Reference Number_'+serviceQuoteLst[0].HWS_RMA_Number__c+'_'+System.Now(); }
				else if(recordTypeName == 'HWS_UnReturned_Part_Quote'){ 
					attachmentName = 'Nokia Non-Returned Parts Service Quote_'+serviceQuoteLst[0].Name+' Nokia Reference Number_'+serviceQuoteLst[0].HWS_RMA_Number__c+'_'+System.Now(); 
					
				}
				attachRec.Name =attachmentName;
				attachRec.Body = pdfBlob;
				attachRec.contentType = 'application/pdf';
				lstAttachment.add(attachRec);
				insert lstAttachment;
				if(lstAttachment.size()>0){
					try{ Database.insert(lstAttachment,false);   } 
					catch(Exception e){ 
		  ErrorLog__c errlog = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString(),'','INSERT-OTHERS','HWS_EmailQuote',lstAttachment[0].Id);
					  errlog.Application__c = 'Case Handling - HWS';
					  DML_SObject.doInsert(errlog,true); //insert in without sharing
		}
				}
				serviceQuoteLst[0].HWS_AttachmentId__c=lstAttachment[0].Id;
				serviceQuoteLst[0].HWS_AttachmentName__c=attachmentName;
				DateTime getCurrentDateTime = DateTime.Now();
				Integer getEligibleDays = (serviceQuoteLst[0].HWS_Quote_Expiration_Days__c!= null) ? Integer.valueof(serviceQuoteLst[0].HWS_Quote_Expiration_Days__c) : 0;
				DateTime calculateExpirationDate = getCurrentDateTime.addDays(getEligibleDays);
				serviceQuoteLst[0].HWS_Quote_Sent_Date__c=DateTime.now();
				serviceQuoteLst[0].HWS_Quote_Expiration_Date__c=calculateExpirationDate;
				serviceQuoteLst[0].HWS_Quote_Status__c='Pending Customer Review';
				serviceQuoteLst[0].HWS_Customer_Accepted_Rejected_Date__c=null;
				serviceQuoteLst[0].HWS_Reason_for_Rejection__c='';
				serviceQuoteLst[0].HWS_Disposition_Instructions__c='';
				serviceQuoteLst[0].HWS_Quote_Status_Reason__c='';
				serviceQuoteLst[0].HWS_Is_Quote_Expired__c=false;
				serviceQuoteLst[0].HWS_Suspension__c=Null;
				serviceQuoteLst[0].HWS_SetStatusTime__c=Null;
				try{ Database.update(serviceQuoteLst,false);  } 
				catch(Exception e){ 
	 ErrorLog__c errlog = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString(),'','UPDATE-OTHERS','HWS_EmailQuote',serviceQuoteLst[0].Id);
				 errlog.Application__c = 'Case Handling - HWS';
				 DML_SObject.doInsert(errlog,true); //insert in without sharing
	}
			}
			List<HWS_ServiceFee_Discount__c> getDiscount=HWS_EmailQuote.getServiceFeeDiscountDetails(serviceQuoteLst[0].RecordTypeId,serviceQuoteLst[0].HWS_CDB_ContractLineItemID__c,serviceQuoteLst[0].HWS_CaresAgreementUniqueId__c);
			if(getDiscount !=null && !getDiscount.isEmpty()){
				getEmailTemp=getDiscount[0].HWS_Email_Template__c;
			}		   
			If(activeContactEmails != null && !activeContactEmails.isEmpty()){
				if(!String.isBlank(nokiaEmail)){activeContactEmails.add(nokiaEmail);}
				for(String email : activeContactEmails){
					CH_EmailAlert__c emailAlert = new CH_EmailAlert__c();
					emailAlert.CH_BindEmail1__c=email;
					emailAlert.CH_Bind1__c = serviceQuoteLst[0].Id;//Quote Id
					emailAlert.CH_Bind2__c= serviceQuoteLst[0].HWS_RMA_Number__c;//rma Number
					emailalert.CH_Bind18__c=getEmailTemp;//Long Text Area Field
					if(recordTypeName == 'HWS_Damaged_Part_Quote'){ emailalert.CH_EmailAlertName__c = 'HWSQuoteCustomerEmailDamagedParts';}
					else if(recordTypeName == 'HWS_UnReturned_Part_Quote'){ emailalert.CH_EmailAlertName__c = 'HWSQuoteCustomerEmailUnreturnedParts';}
					emailAlertList.add(emailalert);
					
				}
			}   
			If(emailAlertList.size()>0){
				List<ErrorLog__c> errorLogList = new List<ErrorLog__c>();
				Database.SaveResult[] saveResults = Database.insert(emailAlertList, false);
				for(Integer index = 0, size = saveResults.size(); index < size; index++){
					if(!saveResults[index].isSuccess()){
						for(Database.Error err: saveResults.get(index).getErrors()){
							Id recId = (String.isNotBlank(emailAlertList[index].id))?emailAlertList[index].id:null;
							ErrorLog__c errlog = CH_ErrorLogUtils.createErrorLog(err.getMessage(),'','INSERT-OTHERS','HWS_EmailQuote',recId);
							errlog.Application__c = 'Case Handling - HWS';
							errorLogList.add(errlog);
						}
					}
				}
				if(errorLogList.size()>0){ DML_SObject.doInsert(errorLogList,true);  }
			}
		}
		return errorMessage;
	}
	
	/*******************************************************
	* Method Name : emailQuoteforFlowStatus 
	* Description : This Method will check the validations and trigger the email for the RMA Contact, Customer Contact 1 and Customer Contact 2 
	*********************************************************/ 
	 @future(callout=true) // HWSDDP-80
	Public Static void emailQuoteforFlowStatus(list<id> quoteIds) {	   
		HWS_EmailQuote.emailQuote(quoteIds[0],false);	   
	}
	
	/*******************************************************
	* Method Name : emailQuoteforStatus 
	* Description : This Method will check the validations and trigger the email for the RMA Contact, Customer Contact 1 and Customer Contact 2 
	*********************************************************/ 
	@InvocableMethod // HWSDDP-80
	Public Static void emailQuoteforStatus(list<id> quoteIds) {
		HWS_EmailQuote.emailQuoteforFlowStatus(quoteIds);
		
	}
	
	 /*******************************************************
	* Method Name : getServiceFeeDiscountDetails 
	* Description : returns List of Service Fee Discount records
	*********************************************************/ 
	Public Static List<HWS_ServiceFee_Discount__c> getServiceFeeDiscountDetails(Id recordTypeId,String cdbContractLineItemID,String caresAgreementUniqueId){
		List<HWS_ServiceFee_Discount__c> getDiscountLst=new List<HWS_ServiceFee_Discount__c>();
		string recordTypeName = Schema.SObjectType.HWS_Service_Quote__c.getRecordTypeInfosById().get(recordTypeId).getName();
		recordTypeName = recordTypeName.replaceAll('Quote', '');
		string lstDiscout  ='SELECT Id,HWS_Scope_of_work_Damaged_Parts_id__c,HWS_Scope_of_work_Unreturned_Parts_id__c,HWS_Email_Template__c FROM HWS_ServiceFee_Discount__c WHERE HWS_LineItemDiscountUniqueId__c = "' +cdbContractLineItemID+'" ';
		lstDiscout=lstDiscout+' AND HWS_Status__c= \'Active\'  AND HWS_SupportedQuoteTypes__c INCLUDES  (\'' + recordTypeName + '\')  LIMIT 1 ';
		getDiscountLst=DML_SObject.doQuery(lstDiscout,true); // query in without sharing mode;
		if(getDiscountLst.size()==0){
			string sQuery ='SELECT Id,HWS_Scope_of_work_Damaged_Parts_id__c,HWS_Scope_of_work_Unreturned_Parts_id__c,HWS_Email_Template__c  FROM HWS_ServiceFee_Discount__c WHERE HWS_CaresAgreementUniqueId__c= "' +caresAgreementUniqueId+'" ';
			sQuery=sQuery+' AND HWS_Status__c= \'Active\'  AND HWS_SupportedQuoteTypes__c INCLUDES  (\'' + recordTypeName + '\')  LIMIT 1 ';
			getDiscountLst =DML_SObject.doQuery(sQuery,true); // query in without sharing mode;
		}
		return getDiscountLst;
	}
	
	/*******************************************************
	* Method Name : userAccessCheck 
	* Description : Check the logged in User has access to Preview PDF on the Service Quote
	*********************************************************/
	Public Static boolean userAccessCheck(Id getRecordId){
		boolean flag=false;
		Id userId = Userinfo.getUserId();
		if(getRecordId!=null){
			UserRecordAccess[] getRecordAccess=[SELECT RecordId, MaxAccessLevel, HasAllAccess, HasDeleteAccess, HasEditAccess, HasReadAccess, HasTransferAccess FROM UserRecordAccess where UserId =:userId and RecordId =:getRecordId];
			if(getRecordAccess.size()>0){
				if(getRecordAccess[0].HasReadAccess==true){
					flag=true;
				}
			}
		}
		return flag;
	}
	
}