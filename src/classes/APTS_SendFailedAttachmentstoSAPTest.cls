@isTest
public class APTS_SendFailedAttachmentstoSAPTest {
    
    public static testMethod void SendFailedAttachmentstoSAP() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
          Apttus_Billing__Status__c = 'Draft');
        insert invoice;
        
        List<APTS_PDF_Attachment_Status__c> LstPDF = New List<APTS_PDF_Attachment_Status__c >();
        APTS_PDF_Attachment_Status__c PDF1 = New APTS_PDF_Attachment_Status__c();
        PDF1.APTS_Integration_Requested__c = system.now();
        PDF1.APTS_Integration_Result__c = 'test123'; 
        PDF1.APTS_Status__c = 'Error';  
        LstPDF.Add(PDF1);
        APTS_PDF_Attachment_Status__c PDF2 = New APTS_PDF_Attachment_Status__c();
        PDF1.APTS_Integration_Requested__c = system.now();
        PDF1.APTS_Integration_Result__c = 'test123'; 
        PDF1.APTS_Status__c = 'Error';  
        LstPDF.Add(PDF2);
        APTS_PDF_Attachment_Status__c PDF3 = New APTS_PDF_Attachment_Status__c();
        PDF1.APTS_Integration_Requested__c =system.now();
        PDF1.APTS_Integration_Result__c = 'test123'; 
        PDF1.APTS_Status__c = 'Error';  
        LstPDF.Add(PDF3);
        APTS_PDF_Attachment_Status__c PDF4 = New APTS_PDF_Attachment_Status__c();
        PDF1.APTS_Integration_Requested__c = system.now();
        PDF1.APTS_Integration_Result__c = 'test123'; 
        PDF1.APTS_Status__c = 'Error';  
        LstPDF.Add(PDF4);
        
        Insert LstPDF;
        
       
        Test.startTest();
        ID BatchProcessdId = Database.executeBatch(new APTS_SendFailedAttachmentstoSAP());
        Test.stopTest();
    }
}