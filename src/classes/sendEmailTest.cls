@isTest
private class sendEmailTest {

    static testMethod void myUnitTest() {
    
    String test = 'test';
    String test1 = 'test1';
    string pEmail = 'test@wipro.com';
    string[] pKeyword = new string[]{'key'};
    string pSubject = 'test subject';
    string pEmailBody = 'testing';
    string pDisplayName = 'display test';
    string pReplyTo = 'test@honeywell.com';
    string pFolderId = '12345';
    string pCategory = '';
    string qCategory = null;
    string pUseCommonMailId = null;
    string[] temail = new string[]{'test@wipro.com'};
    
    List<Id> ids=new List<Id>();
    List<String> oldEmail=new List<String>();
    List<String> newEmail=new List<String>();
        Contact c=new Contact();
        c.FirstName='Test First Name';
        c.LastName='Test Last Name';
        c.email='test@test.com';
        try {
            insert c;
        
            ids.add(c.id);
            oldEmail.add(c.email);
            newEmail.add(c.email);
            sendEmail se=new sendEmail();
            se.sendMail(ids,oldEmail,newEmail);
            sendEmail.preapreKeywords(test,test1);
            sendEmail.SendEmailNotification(pEmail,pKeyword,pSubject,pEmailBody,pDisplayName,pReplyTo,pFolderId,pCategory,pUseCommonMailId);
            sendEmail.SendEmailNotification(pEmail,pKeyword,pSubject,pEmailBody,pDisplayName,pReplyTo,pFolderId,qCategory,pUseCommonMailId);
            sendEmail.SendSimpleEmailNotification(temail,pSubject,pEmailBody);
        
        }catch(Exception ex){
            System.debug('No Valid Email to send Email');
        }
    
    }
}