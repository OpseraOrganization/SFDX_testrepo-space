public with sharing class VOC_ExportToExcel_controller{
    public List<Voice_of_Customer__c> voc{get; set;}
    list<Voice_of_Customer__c> voclist;
    public VOC_ExportToExcel_controller() {
        id pgid = ApexPages.currentPage().getParameters().get('id');
        voc = new List<Voice_of_Customer__c>();
        voclist = [select Id,(select id,Company_Name__c,Customer_s_Title_Role__c,Primary_Customer_s_Email__c,Contact__c,VOC_Record__c, Customer_name__c from VOC_Customer_Names__r), VOC__c,CreatedDate,Name,Company_Name__c,Customer_Participant_Name__c,Customer_s_Email__c,Customer_s_Title_Role__c,Purpose_of_this_VOC__c,Security_Group__c,VOC_Collection__c,VOC_Date__c,VOC_Title__c,Honeywell__c,Honeywell__r.Name,VOC_Hypothesis__c,Key_Takeaways1__c,Product_Name__c,Platform__c,Platform__r.Name,Product_Family__c,Sensitive__c,Is_Sensitive__c,Account__c,Enddate__c,Startdate__c,Financial_Implications__c,Honeywell_Lead__c,status__c from Voice_of_Customer__c where id =:pgid];
        for (Voice_of_Customer__c vc : voclist) {       
            voc.add(vc);
        }
    }
    
  /*  public PageReference sendPdf() {
    id pgid = ApexPages.currentPage().getParameters().get('id');
    PageReference pdf = Page.VOC_Email_to_pdf;
    // add parent id to the parameters for standardcontroller
    pdf.getParameters().put('id',pgid);

    // the contents of the attachment from the pdf
    Blob body;
    // returns the output of the page as a PDF
      body = pdf.getContent();

    // need to pass unit test -- current bug  
     // body = Blob.valueOf('Some Text');


    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    attach.setContentType('application/pdf');
    attach.setFileName('testPdf.pdf');
    attach.setInline(false);
    attach.Body = body;

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    mail.setToAddresses(new String[] {'debajyoti.chatterjee@nttdata.com'});
    mail.setSubject('PDF Email Demo');
    mail.setHtmlBody('Here is the email you requested.');
    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 

    // Send the email
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with PDF sent to '));

    return null;

  }
  */
}