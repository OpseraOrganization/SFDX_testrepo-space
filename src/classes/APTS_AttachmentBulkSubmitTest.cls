@isTest
public class APTS_AttachmentBulkSubmitTest {
  @isTest
    public static void testSelect() {
        List <APTS_PDF_Attachment_Status__c> invoiceList = new List<APTS_PDF_Attachment_Status__c>();

        APTS_PDF_Attachment_Status__c invoice = new APTS_PDF_Attachment_Status__c(
          APTS_Status__c = 'Error'
        );
        invoiceList.add(invoice);
        insert invoiceList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invoiceList);
        sc.setSelected(invoiceList);
        
        APTS_AttachmentBulkSubmit  controller = new APTS_AttachmentBulkSubmit (sc);
        
        System.assertEquals(controller.getCandidateInvoiceSize()>0, true);
    }
    
    @isTest
    public static void testSubmit() {
        List <APTS_PDF_Attachment_Status__c> invoiceList = new List<APTS_PDF_Attachment_Status__c>();

        APTS_PDF_Attachment_Status__c invoice = new APTS_PDF_Attachment_Status__c(
          APTS_Status__c = 'Error'
        );
        invoiceList.add(invoice);
        insert invoiceList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invoiceList);
        sc.setSelected(invoiceList);
     
        APTS_AttachmentBulkSubmit controller = new APTS_AttachmentBulkSubmit (sc);
        
        
        PageReference pageRef = Page.APTS_InvoiceBulkSubmit;
        pageRef.getParameters().put('retURL', 'test');
      Test.setCurrentPage(pageRef);
        
        controller.submitInvoices();
        
    }
    
    @isTest
    public static void testMeesageSelected() {
        List <APTS_PDF_Attachment_Status__c> invoiceList = new List<APTS_PDF_Attachment_Status__c>();

        APTS_PDF_Attachment_Status__c invoice = new APTS_PDF_Attachment_Status__c(
          APTS_Status__c = 'Error'
        );
        invoiceList.add(invoice);
        insert invoiceList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invoiceList);
        sc.setSelected(invoiceList);
     
        APTS_AttachmentBulkSubmit controller = new APTS_AttachmentBulkSubmit(sc);
        
        PageReference pageRef = Page.APTS_AtachmentBulkSubmit;
        pageRef.getParameters().put('retURL', 'test');
        Test.setCurrentPage(pageRef);
        
        controller.selectedInvoices();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
    boolean check = false;
    for(Apexpages.Message msg : pageMessages){
        if (msg.getDetail().contains('Only Attachments(s) with a Status of Error can be Resubmitted!')) check = true;
    }
        System.assertEquals(check, true);
    }
    
    
    @isTest
    public static void testMeesageNotSelected() {
        List <APTS_PDF_Attachment_Status__c> invoiceList = new List<APTS_PDF_Attachment_Status__c>();

        APTS_PDF_Attachment_Status__c invoice = new APTS_PDF_Attachment_Status__c(
          APTS_Status__c = 'Error'
        );
        invoiceList.add(invoice);
        insert invoiceList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(invoiceList);
     
        APTS_AttachmentBulkSubmit controller = new APTS_AttachmentBulkSubmit(sc);
        
        PageReference pageRef = Page.APTS_AtachmentBulkSubmit;
        pageRef.getParameters().put('retURL', 'test');
      Test.setCurrentPage(pageRef);
        
        controller.selectedInvoices();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
    boolean check = false;
    for(Apexpages.Message msg : pageMessages){
        if (msg.getDetail().contains('Please select attachments first.')) check = true;
    }
        System.assertEquals(check, true);
    }
}