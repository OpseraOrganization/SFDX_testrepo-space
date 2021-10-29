/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_EmailAttachmentCopy
* Description           : Test Class to test the functionality of the class EmailAttachmentCopy.
* 
* Modification History  :
* Date              Version No.     Modified by Brief Description of Modification
* 21-May-2013       0.01            NTTData     Initial Version
* 24-Nov-2014       0.02            NTTDATA     Included test data for INC000007037567
* 23-07-2019        0.03            NTTDATA     Increased code coverage
***********************************************************************************************************/
@isTest
Public class TestClass_EmailAttachmentCopy{
    
   public static testmethod void attachmenttest()
    {
        
    Case cse = new Case();
        cse.Origin = 'XML Order';
        cse.Status = 'Open';
        cse.RecordTypeId = Label.XML_Orders_RecordType_Id;
        cse.Classification__c = 'Customer Master Team / eBusiness';
        //cse.ContactId = lstContacts[i].Id;
        cse.Type_of_Change__c = 'New Account';
        cse.Type = 'Other';
        cse.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse.Government_Compliance_SM_M_Content__c = 'NO';
        cse.Ownerid = Label.aero_default_user_id;
        cse.CreatedByID = label.aero_default_user_id;
        cse.SuppliedEmail = 'XMLtest@test.com';
        insert cse;
        Emailmessage e1 = new Emailmessage(parentid=cse.id);
        e1.ToAddress=label.Conexiom_RO_Email_Address;
        e1.Incoming=False;
        e1.ParentID = cse.ID;
        e1.subject = 'test subject';
        insert e1;
       /* Emailmessage e2 = new Emailmessage(parentid=cse.id);
        e2.ToAddress='test@test.com';
        e2.Incoming=False;
        insert e2; */
        
        Attachment a1 = new Attachment(name='sample',body=blob.valueof('samplebody'),parentid=e1.id, ContentType='text/xml');
        insert a1;
        
      EmailMessage e=   [select ID,ParentID,Status,MessageDate,subject,HasAttachment,Parent.createdDate from EmailMessage where Id=: e1.id];
        system.debug('email===' +e);
        //Time csTime = e1.Parent.createdDate.Time();
        //Time eTime = e1.MessageDate.Time();
       // decimal diffTime = ((e1.MessageDate.getTime())/1000/60)- ((e1.Parent.createdDate.getTime())/1000/60);
        List<attachment> caseatt = new List<attachment>();
        Attachment aobj = new Attachment();
            aobj.name=a1.name;
            aobj.body=a1.body;
            aobj.ContentType = a1.ContentType;
            aobj.parentid = cse.id;
            caseatt.add(aobj);
            
            if(caseatt.size()>0){
                insert caseatt;
            }
        
        
        Set<ID> temp = new Set<ID>();
        temp.add(e1.id);
        test.startTest();
       // UpdateCountOpenActivities.flag = false;
        EmailAttachmentCopy ea =new EmailAttachmentCopy();
        try{
          EmailAttachmentCopy.attachcase(temp);
        }
        catch(Exception e4)
        {
        system.debug('error in test' + e4.getMessage());
        }
        test.stopTest();
    }
    
    
    
    public static testmethod void attachmenttest1()
    {
        Case cse = new Case();
        cse.Origin = 'XML Order';
        cse.Status = 'Open';
        cse.RecordTypeId = Label.XML_Orders_RecordType_Id;
        cse.Classification__c = 'Customer Master Team / eBusiness';
        //cse.ContactId = lstContacts[i].Id;
        cse.Type_of_Change__c = 'New Account';
        cse.Type = 'Other';
        cse.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse.Government_Compliance_SM_M_Content__c = 'NO';
        cse.Ownerid = Label.aero_default_user_id;
        cse.CreatedByID = label.aero_default_user_id;
        cse.SuppliedEmail = 'XMLtest@test.com';
        insert cse;
        Emailmessage e1 = new Emailmessage(parentid=cse.id);
        e1.ToAddress=label.Conexiom_RO_Email_Address;
        e1.Incoming=False;
        e1.ParentID = cse.ID;
        e1.subject = 'test subject';
        //e1.HasAttachment = false;
        insert e1;
       /* Emailmessage e2 = new Emailmessage(parentid=cse.id);
        e2.ToAddress='test@test.com';
        e2.Incoming=False;
        insert e2; */
        
        
        
        Set<ID> temp = new Set<ID>();
        temp.add(e1.id);
        test.startTest();
       // UpdateCountOpenActivities.flag = false;
        EmailAttachmentCopy ea =new EmailAttachmentCopy();
        try{
          EmailAttachmentCopy.attachcase(temp);
        }
        catch(Exception e4)
        {
        system.debug('error in test' + e4.getMessage());
        }
        test.stopTest();
    }
     
}