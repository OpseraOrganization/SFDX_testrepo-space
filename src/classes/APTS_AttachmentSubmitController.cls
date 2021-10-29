public class APTS_AttachmentSubmitController {
   private final APTS_PDF_Attachment_Status__c attachment;
   APTS_PDF_Attachment_Status__c attachmentObj;
   public APTS_AttachmentSubmitController(ApexPages.StandardController stdController) {
        this.attachment = (APTS_PDF_Attachment_Status__c)stdController.getRecord();
        //id recordid=this.attachment.get('id');
        attachmentObj=[select id,APTS_Invoice__c,APTS_Credit_Memo__c,APTS_Integration_Requested__c from APTS_PDF_Attachment_Status__c where id=:attachment.id];
        
   }
    
   public PageReference doSubmitAttcahment() {
       this.attachment.APTS_Status__c= 'To be Processed';
       this.attachment.APTS_Integration_Result__c = '';
       this.attachment.APTS_Integration_Requested__c=system.now();
       update this.attachment;
       if(attachmentObj.APTS_Invoice__c!=null)
           return new PageReference('/' + attachmentObj.APTS_Invoice__c);
       else if (attachmentObj.APTS_Credit_Memo__c!=null)
           return new PageReference('/' + attachmentObj.APTS_Credit_Memo__c);
       return null;
   }
}