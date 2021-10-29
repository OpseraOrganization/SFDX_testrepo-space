@isTest(seeAlldata=true)
public class IsAttachmentTestClass {
    static testMethod void TestIsAttachment()    
    {    
        Contact con = new Contact();
        con.LastName = 'Testcon';
        con.FirstName = 'test';
        con.AccountId = '0013000000bFxtr';
        con.Primary_Email_Address__c = 'test.test1@nttdata.com';
        con.Email='test.test1@nttdata.com';
        insert con;
        
		Service_Request__c sr=new Service_Request__c();
        sr.Subject__c='test';
        sr.Priority__c='Routine';
        sr.Status__c='Open';       
        sr.Contact_Name__c = con.id;
        insert sr;
        
        Attachment att=new Attachment();
        att.Name='testAtt';
        att.ParentId=sr.Id;
        att.body = Blob.valueOf('test data');
        att.Description='TestAttachment';
        insert att;
        delete att;  
    }
}