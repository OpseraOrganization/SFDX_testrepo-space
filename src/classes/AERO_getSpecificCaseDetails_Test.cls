@isTest
public class AERO_getSpecificCaseDetails_Test {
    static testMethod void doGetCaseDetails(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('AOG').getRecordTypeId();
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id,recordTypeId = recId);
        insert cs;
        case cs1 = [select caseNumber from case where id= :cs.id limit 1];
        Id csId = cs.id;
        CaseComment   tComment = new CaseComment();
        tComment.ParentId = cs.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = True;
        
        INSERT tComment;
        
        request.requestURI = '/casenumber/'+cs1.caseNumber;  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.headers.put('contactId',+con.Id);
        test.startTest(); 
        AERO_GetSpecificCaseDetails.doGet();
        test.stopTest();
    }
    
    static testMethod void doGetCaseDetails1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse(); 
        RestContext.request = request;  
        RestContext.response= response;
        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        Contact con = new Contact(LastName='test',accountId = accId);
        insert con;
        Case cs = new Case();
        cs.Subject='test Subject';
        cs.Status='Open';
        cs.Sub_Status__c='AWB Sent';
        cs.Quantity_of_Claims__c=56;
        cs.Amount_of_Claim__c=55;
        cs.Resolution__c='test';
        cs.Fault_Messages__c='test';
        //cs.RecordTypeId = rT.Name;
        //cs.Aircraft_Name__c = aircraftType.Name;
        insert cs;
        List<Case> caselist = new List<case>();
        caselist.add(cs);
        CaseComment cc = new CaseComment();
        cc.CommentBody = 'test';
        cc.IsPublished=true;
        cc.ParentId=cs.Id;
        insert cc;
        
        //insert caselist;
        //contentDocumentLink cd = new contentDocumentLink();
        //cd.LinkedEntityId = cs.id;
        //insert cd;
        list<contentDocumentLink> docDetails = new list<contentDocumentLink>();
        docDetails = [select contentDocumentId,contentDocument.title,contentDocument.fileExtension from contentDocumentLink where linkedEntityId =:cs.Id and Visibility = 'AllUsers'];
        insert docDetails;
        String abc= JSON.serialize(docDetails);
        //  contentDocumentLink CdL = new contentDocumentLink(cD.Id,cD.Title,cD.FileExtension);
        // insert cDL;
        // contentDocument cD = new contentDocument();
        // cD.Title='test';
        // cD.FileExtension='txt';
        //insert cD;
        request.requestURI = '/casenumber/';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        AERO_GetSpecificCaseDetails.getCaseDetails('',con.Id,'date');
        AERO_GetSpecificCaseDetails.getCaseDetails(cs.CaseNumber,'1233455','date');
        test.startTest();
        AERO_GetSpecificCaseDetails.getCaseDetails(abc,'1233455','date');
        test.stopTest();
    }
    
    static testMethod void doGetCaseDetails2(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id);
        insert cs;
        case cs1 = [select caseNumber from case where id= :cs.id limit 1];
        Id csId = cs.id;
        CaseComment   tComment = new CaseComment();
        tComment.ParentId = cs.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = True;
        
        INSERT tComment;
        
        request.requestURI = '/casenumber/'+cs1.caseNumber;  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.headers.put('contactId',+con.Id);
        request.headers.put('restrictedDate','2021-54');
        test.startTest(); 
        AERO_GetSpecificCaseDetails.doGet();
        test.stopTest();
    }
    
    static testMethod void doGetCaseDetails3(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id);
        insert cs;
        case cs1 = [select caseNumber from case where id= :cs.id limit 1];
        Id csId = cs.id;
        CaseComment   tComment = new CaseComment();
        tComment.ParentId = cs.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = True;
        
        INSERT tComment;
        
        request.requestURI = '/casenumber/'+cs1.caseNumber;  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.headers.put('contactId',+con.Id);
        request.headers.put('restrictedDate','2021-12-31');
        test.startTest(); 
        AERO_GetSpecificCaseDetails.doGet();
        test.stopTest();
    }
    
    static testMethod void doGetCaseDetails4(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        account acc = new account(name = 'test account');
        insert acc;
        Id accId = [select id from account where name = 'test account' limit 1].id;
        contact con = new contact(lastName = 'Test contact',accountId = accId);
        insert con;
        Id recId = Schema.SObjectType.case.getRecordTypeInfosByName().get('General').getRecordTypeId();
        case cs = new case(status = 'New' , subject = 'Test',contactId = con.id,recordTypeId = recId);
        insert cs;
        case cs1 = [select caseNumber from case where id= :cs.id limit 1];
        Id csId = cs.id;
        CaseComment   tComment = new CaseComment();
        tComment.ParentId = cs.Id;
        tComment.CommentBody = 'Some Comment';
        tComment.IsPublished = True;
        
        INSERT tComment;
        
        request.requestURI = '/casenumber/'+cs1.caseNumber;  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        request.headers.put('contactId',+con.Id);
        test.startTest(); 
        AERO_GetSpecificCaseDetails.doGet();
        test.stopTest();
    }
}