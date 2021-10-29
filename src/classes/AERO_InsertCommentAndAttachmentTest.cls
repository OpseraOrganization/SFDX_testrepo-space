@isTest
public class AERO_InsertCommentAndAttachmentTest {
    static testMethod void testInsertCommentAndAttachment(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        
        request.requestURI = '/caseCommentAndAttachment/';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'Open',Subject = 'Test',contactId = con.Id,recordTypeId = recId);
        insert cs;
        case cs1 = [select caseNumber from case where id = :cs.id limit 1];
        CaseComment cc = new CaseComment();
        cc.ParentId = cs.Id;
        cc.CommentBody = 'This is a comment';
        cc.IsPublished = true;
        insert cc;
        request.headers.put('contactId',con.id);
        AERO_InsertCommentAndAttachment.JSON2Apex JSONBody = new AERO_InsertCommentAndAttachment.JSON2Apex();
        AERO_InsertCommentAndAttachment.RequestWrapper jsonObj = new AERO_InsertCommentAndAttachment.RequestWrapper();
        list<AERO_InsertCommentAndAttachment.RequestWrapper> wrapperList = new list<AERO_InsertCommentAndAttachment.RequestWrapper>();
        jsonObj.fileExtension='txt';
        jsonObj.title='test';
        jsonObj.versionData='VGhpcyBpcyBhIHRlc3QgZmlsZS4=';
        wrapperList.add(jsonObj);
        JSONBody.files = wrapperList;
        JSONBody.commentBody = 'This is the comment from header';
        JSONBody.caseNumber  = cs1.caseNumber;
        request.requestBody = blob.valueOf(JSON.serialize(JSONBody)); 
        test.startTest();
        AERO_InsertCommentAndAttachment.doPost();
        test.stopTest();
    }
    
    static testMethod void testInsertCommentAndAttachment1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/caseCommentAndAttachment/';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        AERO_InsertCommentAndAttachment.JSON2Apex JSONBody = new AERO_InsertCommentAndAttachment.JSON2Apex();
        AERO_InsertCommentAndAttachment.RequestWrapper jsonObj = new AERO_InsertCommentAndAttachment.RequestWrapper();
        list<AERO_InsertCommentAndAttachment.RequestWrapper> wrapperList = new list<AERO_InsertCommentAndAttachment.RequestWrapper>();
        jsonObj.fileExtension='txt';
        jsonObj.title='test';
        jsonObj.versionData='VGhpcyBpcyBhIHRlc3QgZmlsZS4=';
        wrapperList.add(jsonObj);
        JSONBody.files = wrapperList;
        request.requestBody = blob.valueOf(JSON.serialize(JSONBody)); 
        test.startTest();
        AERO_InsertCommentAndAttachment.doPost();
        test.stopTest();
    }
    
    static testMethod void testInsertCommentAndAttachment2(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/caseCommentAndAttachment/';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('General').getRecordTypeId();
        case cs = new case(status = 'Open',Subject = 'Test',contactId = con.Id,recordTypeId = recId);
        insert cs;
        case cs1 = [select caseNumber from case where id = :cs.id limit 1];
        CaseComment cc = new CaseComment();
        cc.ParentId = cs.Id;  
        cc.CommentBody = 'This is a comment';
        cc.IsPublished = true;
        insert cc;
        request.headers.put('contactId',con.id);
        AERO_InsertCommentAndAttachment.JSON2Apex JSONBody = new AERO_InsertCommentAndAttachment.JSON2Apex();
        AERO_InsertCommentAndAttachment.RequestWrapper jsonObj = new AERO_InsertCommentAndAttachment.RequestWrapper();
        list<AERO_InsertCommentAndAttachment.RequestWrapper> wrapperList = new list<AERO_InsertCommentAndAttachment.RequestWrapper>();
        jsonObj.fileExtension='txt';
        jsonObj.title='test';
        jsonObj.versionData='VGhpcyBpcyBhIHRlc3QgZmlsZS4=';
        wrapperList.add(jsonObj);
        JSONBody.files = wrapperList;
        JSONBody.commentBody = 'This is the comment from header';
        JSONBody.caseNumber  = cs1.caseNumber;
        request.requestBody = blob.valueOf(JSON.serialize(JSONBody)); 
        test.startTest();
        AERO_InsertCommentAndAttachment.doPost();
        test.stopTest();
    }
    
}