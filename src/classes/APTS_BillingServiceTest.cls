@isTest
public class APTS_BillingServiceTest {
	@isTest
    public static void testApproveInvoice() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        List<Id> invoiceIds = new List<Id>();
        invoiceIds.add(invoice.id);
        APTS_InvoiceActionResult result = APTS_BillingService.approveInvoice(invoiceIds);
        System.assert(result.isSuccess());
        
        invoice = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__Invoice__c Where Id = :invoice.id];
        System.assertEquals('Approved',invoice.Apttus_Billing__Status__c);
    }
    
    @isTest
    public static void testCancelInvoice() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        List<Id> invoiceIds = new List<Id>();
        invoiceIds.add(invoice.id);
        APTS_InvoiceActionResult result = APTS_BillingService.cancelInvoice(invoiceIds);
        System.assert(result.isSuccess());
        
        invoice = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__Invoice__c Where Id = :invoice.id];
        System.assertEquals('Cancelled', invoice.Apttus_Billing__Status__c);
    }
    
    @isTest
    public static void testDeleteInvoice() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        List<Id> invoiceIds = new List<Id>();
        invoiceIds.add(invoice.id);
        delete invoice;
        APTS_InvoiceActionResult result = APTS_BillingService.approveInvoice(invoiceIds);
        System.assert(!result.isSuccess());
        System.assertEquals('Invoice not found', result.getMessage());
    }

    
    @isTest
    public static void testInvoiceEmptyIdList() {
        APTS_InvoiceActionResult result = APTS_BillingService.cancelInvoice(null);
        System.assert(!result.isSuccess());
        
        List<Id> invoiceIds = new List<Id>();
        result = APTS_BillingService.cancelInvoice(invoiceIds);
        System.assert(!result.isSuccess());
    }
    
    
    @isTest
    public static void testApproveInvoiceLineItem() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        List<Id> invoiceIds = new List<Id>();
        invoiceIds.add(invoice.id);
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
        	Apttus_Billing__InvoiceId__c = invoice.id
        );
        insert invoiceLineItem;
        
        APTS_InvoiceActionResult result = APTS_BillingService.approveInvoice(invoiceIds);
        System.assert(result.isSuccess());
        
        invoiceLineItem = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__InvoiceLineItem__c Where Id = :invoiceLineItem.id];
		System.assertEquals('Approved', invoiceLineItem.Apttus_Billing__Status__c);
    }
    
    @isTest
    public static void testCancelleInvoiceLineItem() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        List<Id> invoiceIds = new List<Id>();
        invoiceIds.add(invoice.id);
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
        	Apttus_Billing__InvoiceId__c = invoice.id
        );
        insert invoiceLineItem;
        
        APTS_InvoiceActionResult result = APTS_BillingService.cancelInvoice(invoiceIds);
        System.assertEquals(result.isSuccess(), true);
        
        invoiceLineItem = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__InvoiceLineItem__c Where Id = :invoiceLineItem.id];
		System.assertEquals('Cancelled', invoiceLineItem.Apttus_Billing__Status__c);
    }
    
    
    @isTest
    public static void testApproveInvoiceBillingSchedule() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        List<Id> invoiceIds = new List<Id>();
        invoiceIds.add(invoice.id);
        
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        insert billingSchedule;
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
        	Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        insert invoiceLineItem;
        
        APTS_InvoiceActionResult result = APTS_BillingService.approveInvoice(invoiceIds);
        System.assertEquals(result.isSuccess(), true);
        
        billingSchedule = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__BillingSchedule__c Where Id = :billingSchedule.id];

        System.assertEquals(billingSchedule.Apttus_Billing__Status__c=='Invoiced', true);
    }
    
    @isTest
    public static void testCancelleInvoiceBillingSchedule() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        List<Id> invoiceIds = new List<Id>();
        invoiceIds.add(invoice.id);
        
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        insert billingSchedule;
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
        	Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        insert invoiceLineItem;
        
        APTS_InvoiceActionResult result = APTS_BillingService.cancelInvoice(invoiceIds);
        System.assertEquals(result.isSuccess(), true);
        
        billingSchedule = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__BillingSchedule__c Where Id = :billingSchedule.id];
        
        System.assertEquals(billingSchedule.Apttus_Billing__Status__c=='Pending Billing', true);
    }
    
    //----
    @isTest
    public static void testApproveCreditMemo() {
        Apttus_Billing__CreditMemo__c creditMemo = TestDataFactory.createCreditMemo();
        List<Id> creditMemoIds = new List<Id>();
        creditMemoIds.add(creditMemo.id);
        APTS_CreditMemoActionResult result = APTS_BillingService.approveCreditMemo(creditMemoIds);
        System.assertEquals(result.isSuccess(), true);
        
        creditMemo = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__CreditMemo__c Where Id = :creditMemo.id];
        System.assertEquals(creditMemo.Apttus_Billing__Status__c=='Approved', true);
    }
    
    @isTest
    public static void testCancelCreditMemo() {
        Apttus_Billing__CreditMemo__c creditMemo = TestDataFactory.createCreditMemo();
        List<Id> creditMemoIds = new List<Id>();
        creditMemoIds.add(creditMemo.id);
        APTS_CreditMemoActionResult result = APTS_BillingService.cancelCreditMemo(creditMemoIds);
        System.assertEquals(result.isSuccess(), true);
        
        creditMemo = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__CreditMemo__c Where Id = :creditMemo.id];
        System.assertEquals(creditMemo.Apttus_Billing__Status__c=='Cancelled', true);
    }
    
    @isTest
    public static void testDeleteCreditMemo() {
        Apttus_Billing__CreditMemo__c creditMemo = TestDataFactory.createCreditMemo();
        List<Id> creditMemoIds = new List<Id>();
        creditMemoIds.add(creditMemo.id);
        delete creditMemo;
        APTS_CreditMemoActionResult result = APTS_BillingService.approveCreditMemo(creditMemoIds);
        System.assert(!result.isSuccess());
        System.assertEquals('CreditMemo not found', result.getMessage());
    }

    
    @isTest
    public static void testCreditMemoEmptyIdList() {
        APTS_CreditMemoActionResult result = APTS_BillingService.cancelCreditMemo(null);
        System.assertEquals(result.isSuccess(), false);
        
        List<Id> creditMemoIds = new List<Id>();
        result = APTS_BillingService.cancelCreditMemo(creditMemoIds);
        System.assertEquals(result.isSuccess(), false);
    }
    
    
    @isTest
    public static void testApproveCreditMemoLineItem() {
        Apttus_Billing__CreditMemo__c creditMemo = TestDataFactory.createCreditMemo();
        List<Id> creditMemoIds = new List<Id>();
        creditMemoIds.add(creditMemo.id);
        
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = new Apttus_Billing__CreditMemoLineItem__c(
        	Apttus_Billing__CreditMemoId__c = creditMemo.id
        );
        insert creditMemoLineItem;
        
        APTS_CreditMemoActionResult result = APTS_BillingService.approveCreditMemo(creditMemoIds);
        System.assertEquals(result.isSuccess(), true);
        
        creditMemoLineItem = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__CreditMemoLineItem__c Where Id = :creditMemoLineItem.id];
		System.assertEquals(creditMemoLineItem.Apttus_Billing__Status__c=='Approved', true);
    }
    
    @isTest
    public static void testCancelleCreditMemoLineItem() {
        Apttus_Billing__CreditMemo__c creditMemo = TestDataFactory.createCreditMemo();
        List<Id> creditMemoIds = new List<Id>();
        creditMemoIds.add(creditMemo.id);
        
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = new Apttus_Billing__CreditMemoLineItem__c(
        	Apttus_Billing__CreditMemoId__c = creditMemo.id
        );
        insert creditMemoLineItem;
        
        APTS_CreditMemoActionResult result = APTS_BillingService.cancelCreditMemo(creditMemoIds);
        System.assertEquals(result.isSuccess(), true);
        
        creditMemoLineItem = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__CreditMemoLineItem__c Where Id = :creditMemoLineItem.id];
		System.assertEquals(creditMemoLineItem.Apttus_Billing__Status__c=='Cancelled', true);
    }
    
    
    @isTest
    public static void testApproveCreditMemoBillingSchedule() {
        Apttus_Billing__CreditMemo__c creditMemo = TestDataFactory.createCreditMemo();
        List<Id> creditMemoIds = new List<Id>();
        creditMemoIds.add(creditMemo.id);
        
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        insert billingSchedule;
        
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = new Apttus_Billing__CreditMemoLineItem__c(
        	Apttus_Billing__CreditMemoId__c = creditMemo.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        insert creditMemoLineItem;
        
        APTS_CreditMemoActionResult result = APTS_BillingService.approveCreditMemo(creditMemoIds);
        System.assertEquals(result.isSuccess(), true);
        
        billingSchedule = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__BillingSchedule__c Where Id = :billingSchedule.id];

        System.assertEquals(billingSchedule.Apttus_Billing__Status__c=='CreditMemod', true);
    }
    
    @isTest
    public static void testCancelleCreditMemoBillingSchedule() {
        Apttus_Billing__CreditMemo__c creditMemo = TestDataFactory.createCreditMemo();
        List<Id> creditMemoIds = new List<Id>();
        creditMemoIds.add(creditMemo.id);
        
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        insert billingSchedule;
        
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = new Apttus_Billing__CreditMemoLineItem__c(
        	Apttus_Billing__CreditMemoId__c = creditMemo.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        insert creditMemoLineItem;
        
        APTS_CreditMemoActionResult result = APTS_BillingService.cancelCreditMemo(creditMemoIds);
        System.assertEquals(result.isSuccess(), true);
        
        billingSchedule = [Select Id, Apttus_Billing__Status__c From Apttus_Billing__BillingSchedule__c Where Id = :billingSchedule.id];
        
        System.assertEquals(billingSchedule.Apttus_Billing__Status__c=='Pending Billing', true);
    }
}