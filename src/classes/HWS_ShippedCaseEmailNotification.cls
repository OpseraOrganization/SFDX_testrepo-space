/****************************************
* Class Name : HWS_ShippedCaseEmailNotification
* Created Date:  Apr 2019
* Created By : TCS
* Last Modified by: TCS
* Last Modified Date: Apr 2019
* Description : Whenever SPM related Cases receives status as 'Shipped' then an email will be triggered to the Contact and Communication Contact with the Shiped confirmation
* This class will calling from HWS_CasetriggerHandler after update event
* HWST-1376
*****************************************/ 
public without sharing class HWS_ShippedCaseEmailNotification {
	/*public static Id spsCaseRecordType {
		get {
			if(spsCaseRecordType == null){
				spsCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES);
			}
			return spsCaseRecordType;
		}
		set;
	}
	public static Id spsReadOnlyCaseRecordType {
		get {
			if(spsReadOnlyCaseRecordType == null){
				spsReadOnlyCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_SPS_PART_SALES_READ_ONLY);
			}
			return spsReadOnlyCaseRecordType;
		}
		set;
	}
	public static String emailCheck = 'Shipment confirmation';*/
	
	/*********
	*Method Name: sendEmailNotification
	*Parameter: Old Case Map and New Case List
	*Description: Used to handle after update operation to send Email Notification for Shipped Case
	**********/
	//@InvocableMethod(label='Update Parent Case to Shipped' description='send mail when child cases are shipped or partially shipped')
   /* public static void sendEmailNotification(Map <Id, Case> oldCaseMap, List <Case> newCaseList){		
		String fromAddress = System.Label.HWS_SupportEmailAddress;
		OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
		Case objOldCase;
		Set<Id> caseIdSet = new Set<Id>();
		Set<Id> caseSpsIdSet = new Set<Id>();
		for(Case c :newCaseList){			
			objOldCase = (Case) oldCaseMap.get(c.Id);					 
			if(c.Status == 'Shipped' && objOldCase.Status != 'Shipped'){
				caseIdSet.add(c.Id);
			}
			else{
				if(c.Status == 'Partially Shipped' && (c.RecordTypeId == spsCaseRecordType || c.RecordTypeId == spsReadOnlyCaseRecordType)){
					caseSpsIdSet.add(c.Id);
				}
			
			}
		}
		if(caseIdSet.size()>0){
			owea = [select Id from OrgWideEmailAddress where Address =: fromAddress];	   
			
			List<Case> caseList = [Select Id,OwnerId,HWS_RecordTypeCheck__c,HWS_SPS_Order_No__c,Account.Email_Send_Check__c, RecordtypeId, ContactId, Status, ParentId, HWS_AWBNumber__c, HWS_RMA_Number__c, HWS_Customer_Reference_Number__c, HWS_ServiceType__c, CaseNumber, Parent.CaseNumber, HWS_Courier_URL_Link__c, HWS_EstimatedTimeOfDelivery__c, Parent.HWS_Shipment_Recipient_Name__c, Parent.Hws_Ship_to_Party_Address__c, HWS_Faulty_Serial_Number__c, HWS_Replacement_Unit_Serial_Number__c, HWS_Shippeddate__c, Asset.ProductCode,Asset.HWS_Part_Code__c,Asset.Product2.Name, Parent.HWS_Communication_Contact__r.Email, Parent.HWS_Communication_Contact__r.Name, Parent.HWS_ShipmentRecipientEmailId__c, Contact.Email, Parent.Hws_Ship_to_Party_Address__r.BillingStreet, Parent.Hws_Ship_to_Party_Address__r.BillingCity, Parent.Hws_Ship_to_Party_Address__r.BillingState, Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode, Parent.Hws_Ship_to_Party_Address__r.BillingCountry, Contact.Name, Origin from case where Status='Shipped' and id in :caseIdSet and HWS_RecordTypeCheck__c = true];
						
			String body = '';			
			String shipmenttoAddress = '';
			List<FeedItem> postChatterLst = new List<FeedItem>();
			for(Case c: caseList){
				objOldCase = (Case) oldCaseMap.get(c.Id);
				if(c.Account.Email_Send_Check__c != null && c.Account.Email_Send_Check__c != '' && (c.Account.Email_Send_Check__c.contains(emailCheck))){
					if(c.Status == 'Shipped' && objOldCase.Status != 'Shipped'){
						if(c.Parent.Hws_Ship_to_Party_Address__c !=null){
							shipmenttoAddress = (c.Parent.Hws_Ship_to_Party_Address__r.BillingStreet!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingStreet+',<br/>':'')+''+(c.Parent.Hws_Ship_to_Party_Address__r.BillingCity!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingCity+',<br/>':'')+''+(c.Parent.Hws_Ship_to_Party_Address__r.BillingState!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingState+',<br/>':'')+''+(c.Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode+',<br/>':'')+''+(c.Parent.Hws_Ship_to_Party_Address__r.BillingCountry!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingCountry:'');
						}
					
						String[] emailAddress = new String[]{};
						emailAddress.add(c.Contact.Email);
						if(c.Parent.HWS_ShipmentRecipientEmailId__c != null && c.Parent.HWS_ShipmentRecipientEmailId__c != ''){
							emailAddress.add(c.Parent.HWS_ShipmentRecipientEmailId__c);						
						}
						if(c.Parent.HWS_Communication_Contact__r.Email != null && c.Parent.HWS_Communication_Contact__r.Email != ''){
							emailAddress.add(c.Parent.HWS_Communication_Contact__r.Email);					   
						}
						Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();// for sending email
						// use the html body to set the content of the body
						email.setSubject('Your Order with AWB Number# '+(c.HWS_AWBNumber__c !=Null?c.HWS_AWBNumber__c :'')+' has been shipped');
					   
						String setHtmlBodyStr = '';						
						setHtmlBodyStr= 'Dear '+c.Contact.Name+(c.Parent.HWS_Communication_Contact__r.Name !=Null?+'/'+c.Parent.HWS_Communication_Contact__r.Name :'')+',<br/><br/>Your '+(c.HWS_ServiceType__c !=Null?c.HWS_ServiceType__c :'')+' Hardware Services Order for Case Number <b>'+c.CaseNumber+'</b> has shipped.<br/>The associated tracking number is <b>'+(c.HWS_AWBNumber__c !=Null?c.HWS_AWBNumber__c :'')+'</b>. Please see additional details below.<br/><br/>';
						
						if(c.RecordTypeId != spsCaseRecordType && c.RecordTypeId != spsReadOnlyCaseRecordType){
							setHtmlBodyStr= setHtmlBodyStr+'<b>RMA#: </b>'+(c.HWS_RMA_Number__c !=Null?c.HWS_RMA_Number__c :'')+'<br/>';
						}
						if(c.RecordTypeId == spsCaseRecordType || c.RecordTypeId == spsReadOnlyCaseRecordType){
							setHtmlBodyStr= setHtmlBodyStr+'<b>SPS Order#: </b>'+(c.HWS_SPS_Order_No__c!=Null? c.HWS_SPS_Order_No__c :'')+'<br/>';
						}
						
						setHtmlBodyStr= setHtmlBodyStr+'<b>Customer Ref#: </b>'+(c.HWS_Customer_Reference_Number__c !=Null?c.HWS_Customer_Reference_Number__c :'')+'<br/><b>Part Code: </b>'+(c.Asset.HWS_Part_Code__c!=Null?c.Asset.HWS_Part_Code__c:'')+'<br/><b>Description: </b>'+(c.Asset.Product2.Name !=Null?c.Asset.Product2.Name :'')+'<br/>';
						if(c.RecordTypeId != spsCaseRecordType && c.RecordTypeId != spsReadOnlyCaseRecordType){
							setHtmlBodyStr= setHtmlBodyStr+'<b>Serial Number: </b>'+(c.HWS_Replacement_Unit_Serial_Number__c !=Null?c.HWS_Replacement_Unit_Serial_Number__c :'')+'<br/>';
						}
						String shippedDate = '';
							if(c.HWS_Shippeddate__c != null){
								//shippedDate = c.HWS_Shippeddate__c.month()+'-'+c.HWS_Shippeddate__c.day()+'-'+c.HWS_Shippeddate__c.year()+' '+c.HWS_Shippeddate__c.Hour()+':'+C.HWS_Shippeddate__c.minute()+':'+C.HWS_Shippeddate__c.Second();
								shippedDate = c.HWS_Shippeddate__c.format('MM-dd-yyyy\' \'HH:mm:ss');
								system.debug('HWS_Shippeddate__c'+shippedDate);
							}
						setHtmlBodyStr= setHtmlBodyStr+'<b>Actual Shipped Date: </b>'+shippedDate+'<br/><br/>Your Order will be delivered to:<br/>'+(c.Parent.HWS_Shipment_Recipient_Name__c !=Null?c.Parent.HWS_Shipment_Recipient_Name__c+'<br/>' :'')+shipmenttoAddress+'<br/><br/>This email is not an RMA form and must not be used to ship your material(s) for return.<br/><br/>Regards,<br/>Nokia Care Services';
						email.setHtmlBody(setHtmlBodyStr);
						
						email.setToAddresses(emailAddress);
						email.setOrgWideEmailAddressId(owea.get(0).Id);
						email.setTargetObjectId(c.ContactId);
						email.setTreatTargetObjectAsRecipient(false);					
						Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
						if(c.Origin=='web'){
							FeedItem postChatter = new FeedItem();
							postChatter.ParentId = c.OwnerId;
							postChatter.Body = 'Dear '+c.Contact.Name+',\nYour Order with AWB Number# '+(c.HWS_AWBNumber__c !=Null?c.HWS_AWBNumber__c :'')+' has been shipped';
							postChatter.Title = 'Case';
							postChatter.LinkUrl = '/lightning/r/Case/'+c.Id+'/view';
							postChatterLst.add(postChatter);
						}
						
					}
				}
			}
			if(postChatterLst.size()>0){
				try{
					insert postChatterLst;
				}
				catch(Exception e){
					system.debug('Chatter exception......'+e);
				}
			}
		}*/
		
		/* Start Changes for User Story 3212 */
	   /*  if(caseSpsIdSet.size()>0){
			owea = [select Id from OrgWideEmailAddress where Address =: fromAddress];								  
			List<Case> caseList = [Select Id,Account.Email_Send_Check__c, RecordtypeId, ContactId, Status, ParentId, HWS_AWBNumber__c, HWS_RMA_Number__c, HWS_Customer_Reference_Number__c, HWS_ServiceType__c, CaseNumber, Parent.CaseNumber, HWS_Courier_URL_Link__c, HWS_EstimatedTimeOfDelivery__c, Parent.HWS_Shipment_Recipient_Name__c, Parent.Hws_Ship_to_Party_Address__c, HWS_Faulty_Serial_Number__c, HWS_Replacement_Unit_Serial_Number__c, HWS_Shippeddate__c, Asset.ProductCode,Asset.HWS_Part_Code__c, Asset.Product2.Name, Parent.HWS_Communication_Contact__r.Email, Parent.HWS_Communication_Contact__r.Name, Parent.HWS_ShipmentRecipientEmailId__c, Contact.Email, Parent.Hws_Ship_to_Party_Address__r.BillingStreet, Parent.Hws_Ship_to_Party_Address__r.BillingCity, Parent.Hws_Ship_to_Party_Address__r.BillingState, Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode, Parent.Hws_Ship_to_Party_Address__r.BillingCountry, Contact.Name,HWS_SPS_Order_No__c, Parent.HWS_Customer_PO__c, HWS_Part_Code__c, HWS_Quantity__c, HWS_Sellable_Product__c, HWS_ShippedQuantity__c ,HWS_LSP_Courier_Name__c from case where Status='Partially Shipped' and id in :caseSpsIdSet and (RecordtypeId = :spsCaseRecordType  OR RecordtypeId = :spsReadOnlyCaseRecordType )] ;
			System.debug('We are have just entered the loop  '+caseList);
			String body = '';			
			String shipmenttoAddress = '';   
			String setHtmlBody = '';	
			Integer shippedCountValue;
			if(caseList.size()>0){
				//List<Messaging.SingleEmailMessage> mailList =  new List<Messaging.SingleEmailMessage>();
				
				for(Case c: caseList){
					objOldCase = (Case) oldCaseMap.get(c.Id);
					//shippedCountValue=Integer.valueOf(c.HWS_ShippedQuantity__c)+Integer.valueOf(objOldCase.HWS_ShippedQuantity__c);
					//system.debug('Old Value :'+Integer.valueOf(objOldCase.HWS_ShippedQuantity__c));
					//system.debug('New Value :'+Integer.valueOf(c.HWS_ShippedQuantity__c));
					// system.debug('Total Value :'+shippedCountValue);
					//if(objOldCase.HWS_ShippedQuantity__c != c.HWS_ShippedQuantity__c){}
					if(c.Account.Email_Send_Check__c != null && c.Account.Email_Send_Check__c != '' && (c.Account.Email_Send_Check__c.contains(emailCheck))){
						if(c.Status == 'Partially Shipped'  && objOldCase.HWS_AWBNumber__c!= c.HWS_AWBNumber__c && c.RecordTypeId == spsReadOnlyCaseRecordType){
							if(c.Parent.Hws_Ship_to_Party_Address__c !=null){
								shipmenttoAddress = (c.Parent.Hws_Ship_to_Party_Address__r.BillingStreet!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingStreet+',<br/>':'')+''
									+(c.Parent.Hws_Ship_to_Party_Address__r.BillingCity!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingCity+',<br/>':'')
									+''+(c.Parent.Hws_Ship_to_Party_Address__r.BillingState!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingState+',<br/>':'')+''+
									(c.Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingPostalCode+',<br/>':'')+''+
									(c.Parent.Hws_Ship_to_Party_Address__r.BillingCountry!=Null?c.Parent.Hws_Ship_to_Party_Address__r.BillingCountry:'');
							}			  
							
							String[] emailAddress = new String[]{};
								emailAddress.add(c.Contact.Email);
							
							//if(c.Parent.HWS_ShipmentRecipientEmailId__c != null && c.Parent.HWS_ShipmentRecipientEmailId__c != ''){
							//  emailAddress.add(c.Parent.HWS_ShipmentRecipientEmailId__c);						
							//}
							
							if(c.Parent.HWS_Communication_Contact__r.Email != null && c.Parent.HWS_Communication_Contact__r.Email != ''){
								emailAddress.add(c.Parent.HWS_Communication_Contact__r.Email);					   
							}
							Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();// for sending email
							// use the html body to set the content of the body
						   // email.setSubject('Your Order with AWB Number# '+(c.HWS_AWBNumber__c !=Null?c.HWS_AWBNumber__c :'')+' has been partially shipped');
							email.setSubject('Your order '+(c.CaseNumber!=Null? c.CaseNumber :'')+' is partially shipped, Tracking Id '+(c.HWS_AWBNumber__c !=Null?c.HWS_AWBNumber__c :''));
							String shippedDate = '';
							if(c.HWS_Shippeddate__c != null){
								shippedDate = c.HWS_Shippeddate__c.month()+'/'+c.HWS_Shippeddate__c.day()+'/'+c.HWS_Shippeddate__c.year()+c.HWS_Shippeddate__c.Hour()+C.HWS_Shippeddate__c.minute()+C.HWS_Shippeddate__c.Second();
								system.debug('HWS_Shippeddate__c'+shippedDate);
							}
							
							setHtmlBody='Dear '+c.Contact.Name+(c.Parent.HWS_Communication_Contact__r.Name !=Null?+'/'+c.Parent.HWS_Communication_Contact__r.Name :'');
							setHtmlBody=setHtmlBody+',<br/><br/>Your Spare Parts Order has been shipped.<br/>Shipping carrier: '+(c.HWS_LSP_Courier_Name__c!=Null?c.HWS_LSP_Courier_Name__c:'')+'<br/>The associated tracking number is <b>'+(c.HWS_AWBNumber__c !=Null?c.HWS_AWBNumber__c :'');
							setHtmlBody=setHtmlBody+'</b>. Please see additional details below.<br/><br/>Your Order will be delivered to: <br/>';
							setHtmlBody=setHtmlBody+(c.Parent.HWS_Shipment_Recipient_Name__c !=Null?c.Parent.HWS_Shipment_Recipient_Name__c+'<br/>' :'')+shipmenttoAddress;
							setHtmlBody=setHtmlBody+'<br/><br/><b>Estimated Time of Delivery: </b>'+(c.HWS_EstimatedTimeOfDelivery__c !=Null? c.HWS_EstimatedTimeOfDelivery__c.format() : '')+'<br/>';
							setHtmlBody=setHtmlBody+'<b>Spare Parts Order Number(s): </b>'+(c.HWS_SPS_Order_No__c!=Null? c.HWS_SPS_Order_No__c :'')+'<br/><b>Customer Purchase Order Number: </b>'+(c.Parent.HWS_Customer_PO__c !=Null?c.Parent.HWS_Customer_PO__c :'');
							// setHtmlBody=setHtmlBody+'<br/><b>Part:</b>'+c.HWS_Part_Code__c+'<br/><b>Part Description:</b>'+c.HWS_Sellable_Product__c;
							setHtmlBody=setHtmlBody+'<br/><b>Part Code: </b>'+(c.HWS_Part_Code__c!=Null?c.HWS_Part_Code__c :'')+'<br/><b>Part Description: </b>'+(c.Asset.Product2.Name !=Null?c.Asset.Product2.Name :''); 
							// setHtmlBody=setHtmlBody+'<br/><b>Alternate Code:</b>'+c.HWS_Part_Code__c+'<br/><b>Ordered Quantity:</b>'+c.HWS_Quantity__c;
							setHtmlBody=setHtmlBody+'<br/><b>Alternate Code: </b>'+'<br/><b>Ordered Quantity: </b>'+(c.HWS_Quantity__c !=Null? c.HWS_Quantity__c :null);
							setHtmlBody=setHtmlBody+'<br/><b>Shipped Quantity: </b>'+(c.HWS_ShippedQuantity__c !=Null?c.HWS_ShippedQuantity__c:null)+'<br/><b>Actual Shipped Date: </b>'+(c.HWS_Shippeddate__c !=null? c.HWS_Shippeddate__c.format() : '');
							setHtmlBody=setHtmlBody+'<br/><br/>Regards,<br/>Nokia Care Services';
							email.setHtmlBody(setHtmlBody);				  
							//email.setHtmlBody('Dear '+c.Contact.Name+(c.Parent.HWS_Communication_Contact__r.Name !=Null?+'/'+c.Parent.HWS_Communication_Contact__r.Name :'')+',<br/><br/>Your Your Spare Parts Order has been shipped.<br/>The associated tracking number is <b>'+(c.HWS_AWBNumber__c !=Null?c.HWS_AWBNumber__c :'')+'</b>. Please see additional details below.<br/><br/>Your Order will be delivered to:<br/>'+(c.Parent.HWS_Shipment_Recipient_Name__c !=Null?c.Parent.HWS_Shipment_Recipient_Name__c :'')+shipmenttoAddress+'<br/><br/>Regards,<br/>Nokia Care Services');				  
							system.debug('Loop Entered and the email address values are '+emailAddress);
							email.setToAddresses(emailAddress);
							email.setOrgWideEmailAddressId(owea.get(0).Id);
							email.setTargetObjectId(c.ContactId);
							email.setTreatTargetObjectAsRecipient(false);   
							//mailList.add(email);
							Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
						}
					}
				}
				//system.debug('Values =='+email);
				//Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mailList});
				//Messaging.sendEmail( mailList );

			}
		}*/
		/* End Changes for User Story 3212 */
	//}
}