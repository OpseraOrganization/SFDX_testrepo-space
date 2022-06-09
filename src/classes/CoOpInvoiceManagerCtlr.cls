public without sharing class CoOpInvoiceManagerCtlr
{
	@AuraEnabled
	public static WrapperFull getClaimInvoices(Id coopClaimId)
	{
		List<Co_Op_Invoice__c> coopInvoiceList = new List<Co_Op_Invoice__c>();
		List<WrapperInvoice> invoiceWrapperList = new List<WrapperInvoice>();
		WrapperFull toSend = new WrapperFull();
		if(coopClaimId != null)
		{
			try
			{
	coopInvoiceList = [SELECT Id, Invoice_Number__c, Description__c, Total_Amount__c, Claim__c, Co_Op_Activity__c, Invoice_Amount__c, Vendor_Name__c,
		   (SELECT Id, Name, Description__c, Amount__c, Co_op_Invoice__c FROM Co_Op_Invoice_Line_Items__r) 
		   FROM Co_Op_Invoice__c 
		   WHERE Claim__c = :coopClaimId
		   ORDER BY Name];
	System.debug(coopInvoiceList);
		
	invoiceWrapperList = popInvoiceWrapper(coopInvoiceList);
	toSend.invoiceWrapperList = invoiceWrapperList;
	toSend.writeAccess = checkForWriteAccess(coopClaimId);
	toSend.coopClaimId= coopClaimId;
	toSend.coopActivityId = getRelatedActivityId(coopClaimId);
	toSend.successMessage = GlobalConstants.SUCCESS_MESSAGE_GET;
			}
			catch(Exception e)
			{
	System.debug('Error: ' + e.getMessage());
	toSend.errorMessage = GlobalConstants.ERROR_MESSAGE_GET;
	return toSend;
			}
		}
		return toSend;
	}
	
	@AuraEnabled
	public static WrapperFull createClaimInvoice (Id coopClaimId)
	{
		WrapperInvoice newInvWrapper = new WrapperInvoice();
		WrapperFull toSend = new WrapperFull();
		toSend.invoiceWrapperList = new list<WrapperInvoice>();
		toSend.coopClaimId = coopClaimId;
		try
		{
			if(checkForWriteAccess(coopClaimId))
			{   
	Co_Op_Invoice__c newInvRec = new Co_Op_Invoice__c();
	newInvRec.claim__c = coopClaimId;
	newInvRec.Co_op_Activity__c = getRelatedActivityId(coopClaimId);
	newInvWrapper.Id = newInvRec.Id;
	insert newInvRec;
	newInvRec = [SELECT Id, Name, Description__c, Invoice_Number__c, Total_Amount__c, Vendor_Name__c FROM Co_Op_Invoice__c WHERE Id = :newInvRec.Id];
	WrapperInvoice invoiceWpr= new WrapperInvoice();
	newInvWrapper.Id = newInvRec.Id;
	newInvWrapper.invoiceNumber = newInvRec.Invoice_Number__c;
	newInvWrapper.vendorName = newInvRec.Vendor_Name__c;
	newInvWrapper.description = newInvRec.Description__c;
	newInvWrapper.selected = false;
	newInvWrapper.visible = true;
	toSend.invoiceWrapperList.add(newInvWrapper);
	toSend.successMessage = GlobalConstants.SUCCESS_MESSAGE_CREATE;
			}
		}
		catch(Exception e)
		{
			System.debug('Error: ' + e.getMessage());
			toSend.errorMessage = GlobalConstants.ERROR_MESSAGE_CREATE;
			return toSend;
		}
		return toSend;
	}
	
	@AuraEnabled
	public static WrapperFull updateClaimInvoices(List<WrapperInvoice> wrapperList, Id coopClaimId)
	{
		List<Co_Op_Invoice__c> invoice2update = new List<Co_Op_Invoice__c>();
		List<Co_Op_Invoice_Line_Item__c> invoiceLI2update = new List<Co_Op_Invoice_Line_Item__c>();
		List<Co_Op_Invoice_Line_Item__c> invoiceLI2create = new List<Co_Op_Invoice_Line_Item__c>();
		Map<Id, WrapperInvoice> invoiceOldMap = new Map<Id, WrapperInvoice>();
		Map<Id, WrapperInvoiceLI> invoiceLIOldMap = new Map<Id, WrapperInvoiceLI>();
		WrapperFull toSend = new WrapperFull();
		toSend.coopClaimId = coopClaimId;
		String msg = '';
		try
		{
			if(checkForWriteAccess(coopClaimId) && checkInvoiceNumber(coopClaimId, wrapperList))
			{
	for(WrapperInvoice invWrap : wrapperList)
	{
		invoiceOldMap.put(invWrap.Id, invWrap);
					if(invWrap != null && invWrap.invoiceLIWrapperList != null)
					{
						for(WrapperInvoiceLI invLIWrap : invWrap.invoiceLIWrapperList)
						{
							if(invLIWrap != null && invLIWrap.Id == null)//Need to create invoice line item
							{
								Co_Op_Invoice_Line_Item__c newLineItem = new Co_Op_Invoice_Line_Item__c();
								newLineItem.Amount__c = invLIWrap.amount;
								newLineItem.Description__c = invLIWrap.description;
								newLineItem.Co_op_Invoice__c = invWrap.Id;
								invoiceLI2create.add(newLineItem);
							}
							else//Need to update existing invoice line item
							{
								invoiceLIOldMap.put(invLIWrap.Id, invLIWrap);
							}  
			}		
					}	
	}
	invoice2update = [SELECT Id, Description__c, Invoice_Amount__c, Invoice_Number__c, Vendor_Name__c FROM Co_Op_Invoice__c WHERE Id in :invoiceOldMap.keySet()];
	invoiceLI2update = [SELECT Id, Description__c, Amount__c FROM Co_Op_Invoice_Line_Item__c WHERE Id in :invoiceLIOldMap.keySet()];
	for(Integer i = 0;i < invoice2update.size(); i++)
	{
		invoice2update[i].Description__c = invoiceOldMap.get(invoice2update[i].Id).description;
		invoice2update[i].Invoice_Amount__c = invoiceOldMap.get(invoice2update[i].Id).invoiceAmount;
		invoice2update[i].Invoice_Number__c = invoiceOldMap.get(invoice2update[i].Id).invoiceNumber;
		invoice2update[i].Vendor_Name__c = invoiceOldMap.get(invoice2update[i].Id).vendorName;
	}
	for(Integer i = 0;i < invoiceLI2update.size(); i++)
	{
		invoiceLI2update[i].Description__c = invoiceLIOldMap.get(invoiceLI2update[i].Id).description;
		invoiceLI2update[i].Amount__c = invoiceLIOldMap.get(invoiceLI2update[i].Id).amount;
	}
	invoiceLI2update.addAll(invoiceLI2create);
	update invoice2update;
	upsert invoiceLI2update;
	updateReimbursableAmount(coopClaimId);
		
	toSend.successMessage = GlobalConstants.SUCCESS_MESSAGE_UPDATE;
	WrapperFull wf = getClaimInvoices(coopClaimId);
	toSend.invoiceWrapperList = wf.invoiceWrapperList;
			}
			else
			{
	toSend.errorMessage = GlobalConstants.ERROR_MESSAGE_DUPLICATE;
			}
		}
		catch(System.DmlException e){
			for (Integer i = 0; i < e.getNumDml(); i++) {
				msg += e.getDmlMessage(i);
			}
			toSend.errorMessage = msg;
			return toSend;
		}
		catch(Exception e){
			System.debug('Error: ' + e.getMessage());
			toSend.errorMessage = GlobalConstants.ERROR_MESSAGE_UPDATE + ' - ' + e.getMessage();
			return toSend;
		}
		return toSend;
	}
	
	@AuraEnabled
	public static WrapperFull deleteRecordsApex (List<String> invoiceIdList, List<String> invoiceLIIdList, Id coopClaimId)
	{
		WrapperFull toSend = new WrapperFull();
		toSend.coopClaimId = coopClaimId;
		List<Co_Op_Invoice_Line_Item__c> invLI2del = new List<Co_Op_Invoice_Line_Item__c>();
		List<Co_Op_Invoice__c> inv2del = new List<Co_Op_Invoice__c>();
		try
		{
			if(checkForWriteAccess(coopClaimId))
			{  
	invLI2del = [SELECT Id FROM Co_Op_Invoice_Line_Item__c WHERE Id in :invoiceLIIdList ];
	inv2del =  [SELECT Id FROM Co_Op_Invoice__c WHERE Id in :invoiceIdList AND claim__c = :coopClaimId];
	delete inv2del;
	delete invLI2del;
	updateReimbursableAmount(coopClaimId);
	toSend.successMessage = GlobalConstants.SUCCESS_MESSAGE_DELETE;
			}		 
		}
		catch(Exception e){
			System.debug('Error: ' + e.getMessage());
			toSend.errorMessage = GlobalConstants.ERROR_MESSAGE_DELETE;
			return toSend;
		}
		return toSend;
	}
	
	/**AUX METHODS**/
	private static List<WrapperInvoice> popInvoiceWrapper(List<Co_Op_Invoice__c> invoiceList)
	{ 
		List<WrapperInvoice> invoiceWprList= new List<WrapperInvoice>();
		for(Co_Op_Invoice__c invoice : invoiceList)
		{
			WrapperInvoice invoiceWpr= new WrapperInvoice();
			invoiceWpr.Id = invoice.Id;
			invoiceWpr.invoiceNumber = invoice.Invoice_Number__c;
			invoiceWpr.totalAmount = invoice.Total_Amount__c;
			invoiceWpr.invoiceAmount = invoice.Invoice_Amount__c;
			invoiceWpr.vendorName = invoice.Vendor_Name__c;
			invoiceWpr.description = invoice.Description__c;
			invoiceWpr.invoiceLIWrapperList = popInvoiceLIWrapper(invoice.Co_Op_Invoice_Line_Items__r);
			invoiceWpr.selected = false;
			invoiceWpr.visible = true;
			invoiceWprList.add(invoiceWpr);
		}
		return invoiceWprList;
	}  

	private static List<WrapperInvoiceLI> popInvoiceLIWrapper(List<Co_Op_Invoice_Line_Item__c> lineItemList)
	{ 
		List<WrapperInvoiceLI> invoiceLIWprList = new List<WrapperInvoiceLI>();
		for(Co_Op_Invoice_Line_Item__c invoiceLI : lineItemList)
		{
			WrapperInvoiceLI invoiceLIWpr= new WrapperInvoiceLI();
			invoiceLIWpr.Id = invoiceLI.Id;
			invoiceLIWpr.invoiceId = invoiceLI.Co_op_Invoice__c;
			invoiceLIWpr.invoiceLINumber = invoiceLI.Name;
			invoiceLIWpr.description  = invoiceLI.Description__c;
			invoiceLIWpr.amount = invoiceLI.Amount__c;
			invoiceLIWpr.selected = false;
			invoiceLIWpr.visible = true;
			invoiceLIWprList.add(invoiceLIWpr);
		}
		return invoiceLIWprList;
	}
	
	//Only users having the mentioned permission set have write access to the class
	private static Boolean checkForWriteAccess(Id CoopClaimId)
	{
		Boolean writeAccess = false;		
		List<PermissionSetAssignment> pmsList = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name in (:GlobalConstants.COOP_GLOBAL_ADMIN_PERMISSION_SET, :GlobalConstants.COOP_PARTNER_ADMIN_PERMISSION_SET)];
		Claim__c claimRec = [SELECT Id, Claim_Status__c from Claim__c where Id = :CoopClaimId LIMIT 1];
		if( pmsList.size() > 0 && (claimRec.Claim_Status__c.equals(GlobalConstants.CLAIM_STATUS_CLAIMABLE) || claimRec.Claim_Status__c.equals(GlobalConstants.CLAIM_STATUS_INCOMPLETE)) ) 
		{
			writeAccess = true;
		}
		return writeAccess;
	}
	
	private static Boolean checkInvoiceNumber(Id coopClaimId, List<WrapperInvoice> wrapperList)
	{
		Boolean uniqueNumber = true;
		List<String> invoiceNumbers = new List<String>();
		for(WrapperInvoice invoiceWrp : wrapperList)
		{
			invoiceNumbers.add(invoiceWrp.invoiceNumber);
		}
		List<Co_Op_Invoice__c> invoiceList = [SELECT Id, Claim__r.Partner_Account__c FROM Co_Op_Invoice__c WHERE Claim__c != :coopClaimId AND Invoice_Number__c in :invoiceNumbers];
		Claim__c claim = [SELECT Id, Partner_Account__c from Claim__c Where Id = :coopClaimId LIMIT 1];
		for(Co_Op_Invoice__c invoiceToCheck : invoiceList)
		{
			if(invoiceToCheck.Claim__r != null && invoiceToCheck.Claim__r.Partner_Account__c == claim.Partner_Account__c)
			{
	uniqueNumber = false;
			}
		}
	return uniqueNumber;
	}

	private static Id getRelatedActivityId(Id coopClaimId)
	{
		Claim__c claim = [SELECT Activity_Number__c from Claim__c Where Id = :coopClaimId LIMIT 1];
		return claim.Activity_Number__c;
	}
   
	private static void updateReimbursableAmount(Id coopClaimId)
	{
	 	Claim__c claimRec = [SELECT Id, claim_total_reimbursable_amount__c, (Select Id, Total_Amount__c FROM Co_op_Invoices__r) FROM Claim__c WHERE Id = :coopClaimId];
		List<Co_Op_Invoice__c> invoiceList = claimRec.Co_op_Invoices__r;
		Decimal claimReimbursableAmount = 0;
		for(Co_Op_Invoice__c inv : invoiceList)
		{
			if(inv.Total_Amount__c != null)
			{
	claimReimbursableAmount += inv.Total_Amount__c;
			}
		}
		claimRec.claim_total_reimbursable_amount__c = claimReimbursableAmount;
		update claimRec;
	}
	
	/** WRAPPER CLASSES**/
	public class WrapperFull
	{ 
		@AuraEnabled
		public Id coopClaimId  {get;set;}
		@AuraEnabled
		public Id coopActivityId {get;set;}
		@AuraEnabled
		public Boolean writeAccess {get;set;}
		@AuraEnabled
		public String successMessage {get;set;}
		@AuraEnabled
		public String errorMessage {get;set;}
		@AuraEnabled
		public List<WrapperInvoice> invoiceWrapperList {get;set;}
	}
	
	public class WrapperInvoice
	{ 
		@AuraEnabled
		public Id Id {get;set;}
		@AuraEnabled
		public String invoiceNumber {get;set;} 
		@AuraEnabled
		public Decimal totalAmount {get;set;}
		@AuraEnabled
		public Decimal invoiceAmount {get;set;}
		@AuraEnabled
		public String vendorName {get;set;}
		@AuraEnabled
		public String description {get;set;}
		@AuraEnabled
		public List<WrapperInvoiceLI> invoiceLIWrapperList{get;set;}
		//Functional
		@AuraEnabled
		public Boolean selected {get;set;} 	
		@AuraEnabled
		public Boolean visible {get;set;} 		
	}
	
	public class WrapperInvoiceLI
	{ 
		@AuraEnabled
		public Id Id {get;set;}
		@AuraEnabled
		public Id invoiceId {get;set;}
		@AuraEnabled
		public String invoiceLINumber {get;set;} 
		@AuraEnabled
		public Decimal amount {get;set;} 
		@AuraEnabled
		public String description {get;set;} 
		//Functional
		@AuraEnabled
		public Boolean selected {get;set;} 
		@AuraEnabled
		public Boolean visible {get;set;}
	}
}