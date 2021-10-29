@IsTest
public class APTS_resricttoDeleteApprovedAttTest {
    
    public static testMethod void ValidateInvoiceCMR() {
     
       Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(Apttus_Billing__Status__c ='Approved');
        insert invoice;
       
        Account account = new Account();
        account.Apttus_Config2__DefaultCreditMemoTemplate__c='FE Credit Memo 4000 (EUR)';
        account.name = 'test';
        insert account;
                       
       Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        creditMemo.Apttus_Billing__InvoiceId__c = Invoice.Id;
        creditMemo.Apttus_Billing__Status__c='Approved'; 
        Insert creditMemo;
        
             
       APTS_PDF_Attachment_Status__c PDFAtt1 = New APTS_PDF_Attachment_Status__c();
        PDFAtt1.APTS_Invoice__c = invoice.id;
        PDFAtt1.APTS_Delete_Draft_Attachments__c = False;
        Insert PDFAtt1;
        
       APTS_PDF_Attachment_Status__c PDFAtt2 = New APTS_PDF_Attachment_Status__c();
        PDFAtt2.APTS_Credit_Memo__c = creditMemo.id;
        PDFAtt2.APTS_Delete_Draft_Attachments__c = False;
        Insert PDFAtt2; 
        
        Try{
          Delete PDFAtt2;
        }
        catch(Exception E)
        {
        
        }
         Try{
          Delete PDFAtt1;
        }
        catch(Exception E)
        {
        
        }
        
   }
   public static testMethod void ValidateInvoiceCMR1() {
     
       Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(Apttus_Billing__Status__c ='Draft');
        insert invoice;
       
        Account account = new Account();
        account.Apttus_Config2__DefaultCreditMemoTemplate__c='FE Credit Memo 4000 (EUR)';
        account.name = 'test';
        insert account;
                       
       Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        creditMemo.Apttus_Billing__InvoiceId__c = Invoice.Id;
        creditMemo.APTS_CMR_Number__c = '4567839';
        creditMemo.Apttus_Billing__Status__c='Draft'; 
        Insert creditMemo;
        
             
       APTS_PDF_Attachment_Status__c PDFAtt1 = New APTS_PDF_Attachment_Status__c();
        PDFAtt1.APTS_Invoice__c = invoice.id;
        PDFAtt1.APTS_Delete_Draft_Attachments__c = false;
        Insert PDFAtt1;
        
       APTS_PDF_Attachment_Status__c PDFAtt2 = New APTS_PDF_Attachment_Status__c();
        PDFAtt2.APTS_Credit_Memo__c = creditMemo.id;
        PDFAtt2.APTS_Delete_Draft_Attachments__c = false;
        Insert PDFAtt2; 
       PDFAtt2.APTS_Delete_Draft_Attachments__c = true;
       Update PDFAtt2;
       
       Delete PDFAtt1;
       Delete PDFAtt2;
          }
}