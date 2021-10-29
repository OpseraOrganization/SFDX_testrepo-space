@isTest
public class APTS_InvoiceBulkCancelTest {
	@isTest
    public static void testSelect() {
        List <Apttus_Billing__Invoice__c> invoiceList = new List<Apttus_Billing__Invoice__c>();

        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        invoiceList.add(invoice);
        insert invoiceList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invoiceList);
        sc.setSelected(invoiceList);
        
        APTS_InvoiceBulkCancel controller = new APTS_InvoiceBulkCancel(sc);
        
        System.assertEquals(controller.getCandidateInvoiceSize()>0, true);
    }
    
    @isTest
    public static void testCancel() {
        List <Apttus_Billing__Invoice__c> invoiceList = new List<Apttus_Billing__Invoice__c>();

        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        invoiceList.add(invoice);
        insert invoiceList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invoiceList);
        sc.setSelected(invoiceList);
     
        APTS_InvoiceBulkCancel controller = new APTS_InvoiceBulkCancel(sc);
        
        
        PageReference pageRef = Page.APTS_InvoiceBulkCancel;
        pageRef.getParameters().put('retURL', 'test');
  		Test.setCurrentPage(pageRef);
        
        controller.cancelInvoices();
        invoice = [Select Id, Name, Apttus_Billing__Status__c From Apttus_Billing__Invoice__c Where Id = :invoice.id];
        System.assertEquals(invoice.Apttus_Billing__Status__c=='Cancelled', true);
    }
    
    @isTest
    public static void testMeesageSelected() {
        List <Apttus_Billing__Invoice__c> invoiceList = new List<Apttus_Billing__Invoice__c>();

        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        invoiceList.add(invoice);
        insert invoiceList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invoiceList);
        sc.setSelected(invoiceList);
     
        APTS_InvoiceBulkCancel controller = new APTS_InvoiceBulkCancel(sc);
        
        PageReference pageRef = Page.APTS_InvoiceBulkCancel;
        pageRef.getParameters().put('retURL', 'test');
  		Test.setCurrentPage(pageRef);
        
        controller.selectedInvoices();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
		boolean check = false;
		for(Apexpages.Message msg : pageMessages){
    		if (msg.getDetail().contains('Only Invoice(s) with a Status of Draft can be Cancelled!')) check = true;
		}
        System.assertEquals(check, true);
    }
    
    
    @isTest
    public static void testMeesageNotSelected() {
        List <Apttus_Billing__Invoice__c> invoiceList = new List<Apttus_Billing__Invoice__c>();

        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
        	Apttus_Billing__Status__c = 'Draft'
        );
        invoiceList.add(invoice);
        insert invoiceList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invoiceList);
     
        APTS_InvoiceBulkCancel controller = new APTS_InvoiceBulkCancel(sc);
        
        PageReference pageRef = Page.APTS_InvoiceBulkCancel;
        pageRef.getParameters().put('retURL', 'test');
  		Test.setCurrentPage(pageRef);
        
        controller.selectedInvoices();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
		boolean check = false;
		for(Apexpages.Message msg : pageMessages){
    		if (msg.getDetail().contains('Please select invoices first.')) check = true;
		}
        System.assertEquals(check, true);
    }
}