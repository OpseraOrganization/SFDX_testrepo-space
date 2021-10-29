@isTest
public class emailAttachmentReassignerTest {
        static testmethod void attachmentTester() {
            Attachment a = new Attachment();
            a.name = 'test attachment';
            a.body = blob.valueof('attachment body');
            a.parentid = [select id from EmailMessage limit 1].id;
            
            insert a;   
            
            delete a;
        }   
    }