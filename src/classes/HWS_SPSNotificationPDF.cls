public without sharing class HWS_SPSNotificationPDF {
	
	private Final Static String EmailCheck = 'Order Confirmation';	
	public static Id spsReadOnlyCaseRecordType {
		get {
			if(spsReadOnlyCaseRecordType == null){
				spsReadOnlyCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES_READ_ONLY);
			}
			return spsReadOnlyCaseRecordType;
		}
		set;
	}   
	
	Public static void spsChildCasesPDF(List<Case> newCaseList,  Map<Id, Case> oldCaseMap){
		try{
			system.debug('spsChildCasesPDF'+newCaseList);
			set<Id> parentCaseIds = new set<Id>();
			List<String> emailTobeSent = new List<String>();
			String fromAddress = System.Label.HWS_SupportEmailAddress;
			List<String> ccAddress = new List<String>();//NOKIAsc-27247
			Boolean isMailSent=true;
			for(Case caseRec : newCaseList){
				//system.debug('--1--'+'--caseRec.RecordTypeId'+caseRec.RecordTypeId+'----'+oldCaseMap.Containskey(caseRec.Id)+'---2-'+oldCaseMap.get(caseRec.Id).Status+'-------'+caseRec.Status);
				if(caseRec.RecordTypeId == spsReadOnlyCaseRecordType ){
					// system.debug('--1--'+oldCaseMap.Containskey(caseRec.Id)+'---2-'+oldCaseMap.get(caseRec.Id).Status+'-------'+caseRec.Status);
					if(oldCaseMap.Containskey(caseRec.Id) && oldCaseMap.get(caseRec.Id).Status != caseRec.Status && caseRec.Status == 'Ordered'){
						parentCaseIds.add(caseRec.ParentId);
						system.debug('parentCaseIds'+parentCaseIds);
					}
				}
			} 
			OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
				List<Case> spsChildsList =[SELECT id ,status,CaseNumber,HWS_SPS_Order_No__c, ParentID,HWS_Customer_PO__c,HWS_Customer_Reference_Number__c,
										   Parent.CaseNumber,Parent.HWS_Customer_PO__c,Contact.name, ContactId, Contact.Email,Contact.Email1__c,Contact.CH_Email3__c ,Account.Email_Send_Check__c,
										   HWS_Sellable_Product__c,HWS_Sellable_Product__r.Name,Asset.ProductCode,Asset.HWS_Part_Code__c,Asset.product2.Name,
										   HWS_Quantity__c,HWS_Net_Quantity__c,Asset.HWS_Price__c,
										   Subject,Parent.HWS_Communication_Contact__r.name,Parent.HWS_Communication_Contact__r.Email FROM Case 
										   WHERE ParentId IN: parentCaseIds and Status='Ordered']; 
			
			system.debug('spsChildsList'+spsChildsList);
			// system.debug('I am here1'+spsChildsList[0].Account.Email_Send_Check__c);
			if(spsChildsList.size()>0){
				owea = [select Id from OrgWideEmailAddress where Address =: fromAddress];
				if(spsChildsList[0].Contact.Email != Null){
					emailTobeSent.add(spsChildsList[0].Contact.Email);
				}
				if(spsChildsList[0].Contact.Email1__c != Null){
					ccAddress.add(spsChildsList[0].Contact.Email1__c); // NOKIASC 27247
				}
				if(spsChildsList[0].Contact.CH_Email3__c != Null){
					ccAddress.add(spsChildsList[0].Contact.CH_Email3__c);// NOKIASC 27247
				}
				if(spsChildsList[0].Parent.HWS_Communication_Contact__r.Email!=Null){
					emailTobeSent.add(spsChildsList[0].Parent.HWS_Communication_Contact__r.Email);
				}
				system.debug('emailTobeSent'+emailTobeSent);
				if(spsChildsList[0].Account.Email_Send_Check__c != null && spsChildsList[0].Account.Email_Send_Check__c != ''&& spsChildsList[0].Account.Email_Send_Check__c.contains(EmailCheck)){	
					if(spsChildsList.size()>0){	
						List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
						
						Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
						attach.setContentType('application/pdf');
						attach.setFileName('SPS.pdf');
						
						String body = '';
						
						body = '<html><h4 style=\"text-align:left;\">Dear '+spsChildsList[0].Contact.Name+',</h4><br/></html>';
						body += '<html><h4 style=\"text-align:left;\">Thank you for contacting Nokia Care.This email acknowledges your Spare Part Sales Customer Purchase Order ' +(spsChildsList[0].Parent.HWS_Customer_PO__c==null ? ' ' : spsChildsList[0].Parent.HWS_Customer_PO__c) + ' provided by the customer. Please find additional details below. </h4><br/><br/></html>';
						
						body += '<html><h4 style=\"text-align:left;\">Child Case Details</h4></html>';
						body += '<br/><font size="2" ><table border="0.1" align="center" valign="middle" style="border-collapse: collapse"><tr><th bgcolor="#D6DBDF">Spare Parts Order Number(s)</th><th bgcolor="#D6DBDF">Customer Order# (PO #)</th><th bgcolor="#D6DBDF">Part</th><th bgcolor="#D6DBDF">Part Description</th><th bgcolor="#D6DBDF">Quantity</th><th bgcolor="#D6DBDF">Price (per item)</th><th bgcolor="#D6DBDF">Total</th></tr>';
						
						for(Case caserec:spsChildsList){
							
							body += '<tr><td>' +  (caserec.HWS_SPS_Order_No__c==null ? ' ' :caserec.HWS_SPS_Order_No__c) + '</td><td>' + (caserec.Parent.HWS_Customer_PO__c==null ? ' ' : caserec.Parent.HWS_Customer_PO__c) + '</td><td>' +  (caserec.Asset.HWS_Part_Code__c==null ? ' ' : caserec.Asset.HWS_Part_Code__c) + '</td><td>'+ (caserec.Asset.Product2.Name==null ? ' ' : caserec.Asset.Product2.Name ) + '</td><td>'+ (String.valueOf(caserec.HWS_Quantity__c)==null ? ' ' : string.valueOf(caserec.HWS_Quantity__c )) + '</td><td>'+ (caserec.Asset.HWS_Price__c == null ? '' : caserec.Asset.HWS_Price__c)  + '</td><td>'+ (caserec.HWS_Net_Quantity__c == null ? '' : caserec.HWS_Net_Quantity__c)  + '</td></tr><br/>';
						}
						body += '</table><br/><br/>';
						body += '<html><h4 style=\"text-align:left;\">Regards,</h4></html>';
						body += '<html><h4 style=\"text-align:left;\">Nokia Care Services</h4><br/><br/></html>';
						
						attach.Body = Blob.toPDF(body);
						EmailTemplate etemplate = [SELECT Id, Subject, HtmlValue, Body
												   FROM EmailTemplate
												   WHERE DeveloperName='HWS_SPS_Order_Notification_Email_Temaplate'];
						
						//  emailTobeSent= new String[]{'Govardhan.guduru.ext@nokia.com'};
						if(emailTobeSent.Size()>0 && isMailSent){
							Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();// for sending email
							email.setOrgWideEmailAddressId(owea.get(0).Id);
							email.setTemplateId(etemplate.Id);
							system.debug('emailTobeSent'+emailTobeSent);
							email.setToAddresses( emailTobeSent );
							email.setccAddresses(ccAddress); //// NOKIASC-27247
							email.setTargetObjectId(spsChildsList[0].ContactId);
							email.setTreatTargetObjectAsRecipient(false);   
							email.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
							Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
							isMailSent=false;
						}
					}
				}
			}
		}	
		catch(Exception ex){
			//System.debug(ex.getMessage());
			List<Interface_Log__c> ilogs = new List<Interface_Log__c>();
			Interface_Log__c ilogpr = new Interface_Log__c();
			ilogpr.Message_Type__c = 'Inbound';
			ilogpr.Status__c = 'Failure';
			ilogpr.Interface_Type__c = 'HWS SPS Notification Email failure';
			ilogpr.Name = 'Child Case PDF email generation failed : '+ ex.getMessage();
			ilogs.add(ilogpr);
			if(ilogs.size()>0){
				Database.SaveResult[] results = Database.insert(ilogs,false);
			}
		}
	}
}