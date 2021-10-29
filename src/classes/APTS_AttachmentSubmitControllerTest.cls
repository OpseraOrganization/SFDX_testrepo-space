@isTest
public class APTS_AttachmentSubmitControllerTest {
    
    public static testMethod void testSubmitMemo() {
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        Account account = new Account();
        account.name = 'test';
        insert account;
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        insert creditMemo;
        
        APTS_PDF_Attachment_Status__c objats= new APTS_PDF_Attachment_Status__c();
        objats.APTS_Credit_Memo__c=creditMemo.id;
        objats.APTS_Status__c='To be Processed';
        insert objats;
        
        Id creditMemoId = (Id)objats.get('id');
        PageReference pageRef = new PageReference('/' + objats);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objats);
            // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', creditMemoId);
        APTS_AttachmentSubmitController  controller = new APTS_AttachmentSubmitController(standardController); 
        String nextPage = controller.doSubmitAttcahment().getUrl();        
    }
    
    public static testMethod void testSubmitMemo1() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c();
        insert invoice;
        APTS_PDF_Attachment_Status__c objats= new APTS_PDF_Attachment_Status__c();
        objats.APTS_Invoice__c=invoice.id;
        objats.APTS_Status__c='To be Processed';
        insert objats;
        Id invoiceId = (Id)objats.get('id');
        PageReference pageRef = new PageReference('/' + invoiceId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(objats);
            // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', invoiceId);
        APTS_AttachmentSubmitController controller = new APTS_AttachmentSubmitController(standardController); 
        String nextPage = controller.doSubmitAttcahment().getUrl();        
    }
}