@isTest
public class CoOpInvoiceManagerCtlrTest {
	
	private static User testUser = NF_TestDataFactory.createAdminUser(GlobalConstants.DATA_LOADER_PROFILE);
	
	@testSetup 
	static void datasetup() 
	{
		List<Account> partner = createPartnerAccount(1, GlobalConstants.Distributor);
		insert partner;
		
		Fund__c fund = new Fund__c(Name = 'Test Fund', Partner_Name__c = partner[0].id);
		insert fund;
		
		Co_Op_Activity__c activity = new Co_Op_Activity__c(Partner_Account__c = partner[0].id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund.id, Activity_Status__c = 'New' , Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
		insert activity;
		
		List<Claim__c> claimList = createCoOpClaim(1, partner[0].id, fund.id, activity.Id);
		insert claimList;
	
		List<Co_Op_Invoice__c> invList = createCoOpInvoice(1, claimList[0].Id, activity.Id);
		insert invList;
		
		List<Co_Op_Invoice_Line_Item__c> liList = createCoOpLineItem(2, invList[0].Id);
		insert liList;
		
	}
	
	static testmethod void getInvoicesTest()
	{
		List<Claim__c> claimList = [Select Id From Claim__c Limit 1];
		
		setTestUser();
		system.runAs(testUser)
		{
			Test.startTest();
			CoOpInvoiceManagerCtlr.WrapperFull resp = CoOpInvoiceManagerCtlr.getClaimInvoices(claimList[0].Id);
			System.assertEquals(1, resp.invoiceWrapperList.size(), 'Records retrieved');
			Test.stopTest();
		}
	}
	
	static testmethod void deleteInvoicesTest()
	{
		List<Claim__c> claimList = [Select Id From Claim__c Limit 1];
		List<Co_Op_Invoice__c> invList = [Select Id From Co_Op_Invoice__c WHERE Claim__c = :claimList[0].Id Limit 1];
		List<Co_Op_Invoice_Line_Item__c> liList = [Select Id From Co_Op_Invoice_Line_Item__c WHERE Co_Op_Invoice__c = :invList[0].Id];
		
		List<Id> invIdList = new List<Id>();
		List<Id> liIdList = new List<Id>();
		liIdList.add(liList[0].Id);
		
		setTestUser();
		system.runAs(testUser)
		{
			Test.startTest();
			CoOpInvoiceManagerCtlr.WrapperFull resp1 = CoOpInvoiceManagerCtlr.deleteRecordsApex(invIdList, liIdList, claimList[0].Id);
			List<Co_Op_Invoice_Line_Item__c> liListAfter = [Select Id From Co_Op_Invoice_Line_Item__c WHERE Id = :liList[0].Id];
			//Check if liListAfter is empty
			System.assertEquals(0, liListAfter.size(), 'Invoice line item was deleted');
			
			invIdList.add(invList[0].Id);
			CoOpInvoiceManagerCtlr.WrapperFull resp2 = CoOpInvoiceManagerCtlr.deleteRecordsApex(invIdList, liIdList, claimList[0].Id);
			List<Co_Op_Invoice__c> invListAfter = [Select Id From Co_Op_Invoice__c WHERE Id = :invList[0].Id];
			//check if invListAfter is empty
			System.assertEquals(0, invListAfter.size(), 'Invoice was deleted');
			Test.stopTest();
		}
	}
	
	static testmethod void createInvoiceTest()
	{
		/*
		List<Co_Op_Activity__c> activityList = [SELECT Partner_Account__c, Fund_Id__c, Id FROM Co_Op_Activity__c LIMIT 1];
		List<Claim__c> claimList = createCoOpClaim(1, activityList[0].Partner_Account__c, activityList[0].Fund_Id__c, activityList[0].Id);
		insert claimList;
		*/
		List<Claim__c> claimList = [SELECT Id FROM Claim__c LIMIT 1];
		
		setTestUser();
		system.runAs(testUser)
		{
			Test.startTest();
			List<Co_Op_Invoice__c> invListbefore = [Select Id From Co_Op_Invoice__c WHERE Claim__c = :claimList[0].Id];
			CoOpInvoiceManagerCtlr.WrapperFull resp = CoOpInvoiceManagerCtlr.createClaimInvoice(claimList[0].Id);
			List<Co_Op_Invoice__c> invListAfter = [Select Id From Co_Op_Invoice__c WHERE Claim__c = :claimList[0].Id];
			//Check if invListAfter as one record
			System.assertEquals(invListbefore.size() + 1, invListAfter.size(), 'Invoice was created');
			Test.stopTest();
		}
	}
	
	static testmethod void updateInvoicesTest()
	{
		List<Claim__c> claimList = [Select Id From Claim__c Limit 1];
		List<Co_Op_Invoice__c> invList = [Select Id From Co_Op_Invoice__c WHERE Claim__c = :claimList[0].Id Limit 1];
		List<Co_Op_Invoice_Line_Item__c> liList = [Select Id From Co_Op_Invoice_Line_Item__c WHERE Co_Op_Invoice__c = :invList[0].Id];
		
		List<CoOpInvoiceManagerCtlr.WrapperInvoice> wrapperList = new List<CoOpInvoiceManagerCtlr.WrapperInvoice>();
		CoOpInvoiceManagerCtlr.WrapperInvoice invWrap1 = new CoOpInvoiceManagerCtlr.WrapperInvoice();
		invWrap1.description = 'Inv1';
		invWrap1.invoiceNumber = 'Inv13214342';
		invWrap1.invoiceAmount = 10000;
	 invWrap1.vendorName = 'vendor';
		invWrap1.Id = invList[0].Id; 
		
		List<CoOpInvoiceManagerCtlr.WrapperInvoiceLI> liWrapList = new List<CoOpInvoiceManagerCtlr.WrapperInvoiceLI>();
		CoOpInvoiceManagerCtlr.WrapperInvoiceLI liWrap1 = new CoOpInvoiceManagerCtlr.WrapperInvoiceLI();
		liWrap1.description = 'New line item to create';
		liWrap1.amount = 100;
		liWrap1.invoiceId = invList[0].Id;
		liWrapList.add(liWrap1);
		
		CoOpInvoiceManagerCtlr.WrapperInvoiceLI liWrap2 = new CoOpInvoiceManagerCtlr.WrapperInvoiceLI();
		liWrap2.description = 'Existing line item to update';
		liWrap2.amount = 100;
		liWrap2.invoiceId = invList[0].Id;
		liWrap2.Id = liList[0].Id;
		liWrapList.add(liWrap2);
		
		invWrap1.invoiceLIWrapperList = liWrapList;
		wrapperList.add(invWrap1);
		
		setTestUser();
		system.runAs(testUser)
		{
			Test.startTest();
			CoOpInvoiceManagerCtlr.WrapperFull resp = CoOpInvoiceManagerCtlr.updateClaimInvoices(wrapperList, claimList[0].Id);
			List<Co_Op_Invoice_Line_Item__c> liListAfter = [Select Id From Co_Op_Invoice_Line_Item__c WHERE Co_Op_Invoice__c = :invList[0].Id];
			//Check if liListAfter has one more record than liList
			System.assertEquals(liList.size() + 1, liListAfter.size(), 'Invoice was updated and a new line item was created');
			Test.stopTest();
		}
	}
	
	public static void setTestUser()
	{
		insert testUser;
		List<PermissionSet> pmsList = [SELECT Id FROM PermissionSet WHERE Name = :GlobalConstants.COOP_GLOBAL_ADMIN_PERMISSION_SET];
		PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = pmsList[0].Id, AssigneeId = testUser.Id);
		insert psa;
	}
	
	public static List<Account> createPartnerAccount(integer nbrRec, String partnerRole)
	{	
		List<Account> partnerAccList = new List<Account>();
		for (integer i = 0; i < nbrRec; i++) 
		{
			Account accRec = new Account();
			accRec.BusinessPartnerRole__c = partnerRole;
			accRec.Partner_Program__c = 'GPP 3.0';
			accRec.Name = 'Test Account -' + i + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accRec.BillingStreet = '1660 International Dr';
			accRec.BillingCity = 'Lisboa';
			accRec.BillingPostalCode = '22102';
			accRec.BillingCountry = 'portugal';
			accRec.AccountStatusInCRMOM__c = 'Active';
			accRec.Industry='Enterprise';
			accRec.Market__c='Market Europe';
			accRec.Country__c='Portugal';
			accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(GlobalConstants.CUSTOMER).getRecordTypeId();
			partnerAccList.add(accRec);
		}
		return partnerAccList;
	}
	public static List<Claim__c> createCoOpClaim(integer nbrRec, Id partnerId, Id fundId, Id activityId)
	{	
		List<Claim__c> claimList = new List<Claim__c>();
		Claim__c claim = new Claim__c(Partner_Account__c = partnerId, Fund__c= fundId, Activity_Number__c = activityId, HFLOF_Amount__c = 10, Claim_Status__c = GlobalConstants.CLAIM_STATUS_CLAIMABLE, Claim_Amount_Passed_Audit__c = 100);
		claimList.add(claim);
		return claimList;   
	}
	public static List<Co_Op_Invoice__c> createCoOpInvoice(integer nbrRec, Id coopClaimId, Id activityId)
	{   
		List<Co_Op_Invoice__c> invoiceList = new  List<Co_Op_Invoice__c>();
		for(integer i = 0; i < nbrRec; i++)
		{ 
			Co_Op_Invoice__c invoice = new Co_Op_Invoice__c();
	invoice.Description__c = 'Invoice number ' + i;
	invoice.Invoice_Amount__c = 1000;
	invoice.Invoice_Number__c = 'INV019283366';
	invoice.Vendor_Name__c = 'vendor';
	invoice.Description__c = 'Invoice number ' + i;
	invoice.Claim__c = coopClaimId;
	invoice.Co_op_Activity__c = activityId;
			invoiceList.add(invoice);
		}
		return invoiceList;
	}
	public static List<Co_Op_Invoice_Line_Item__c> createCoOpLineItem(integer nbrRec, Id invoiceId)
	{   
		List<Co_Op_Invoice_Line_Item__c> lineItemList = new  List<Co_Op_Invoice_Line_Item__c>();
		for(integer i = 0; i < nbrRec; i++)
		{ 
			Co_Op_Invoice_Line_Item__c lineItem = new Co_Op_Invoice_Line_Item__c();
	lineItem.Description__c = 'Line Item number ' + i;
			lineItem.Co_op_Invoice__c = invoiceId;
			lineItem.Amount__c = 100;
			lineItemList.add(lineItem);
		}
		return lineItemList;
	}
}