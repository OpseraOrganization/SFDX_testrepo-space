@isTest
public class caseRestResourceTest {

    Static void init(){
     Account Acc = New Account();
        acc.Name = 'Air indigo';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        Insert acc;
        
        contact c = New contact();
        C.firstname = 'Test';
        C.LastName = 'Contact';
        C.Primary_Email_Address__c = 'test@gmail.com'; 
        C.AccountId = acc.id;
        C.Honeywell_ID__c = 'H147664';
        insert C;
            
            Id  rtSoftware_Tools_SW_Tools = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Software Tools (SWT)').getRecordTypeId();
        Case ca = New Case();
        Ca.Subject = 'Test Case';
        Ca.RecordTypeId = rtSoftware_Tools_SW_Tools;
        ca.Origin = 'Web';
        ca.Status = 'Open';
        Ca.Type = 'SW Tools';
        Ca.Contactid = C.id;
        Ca.Classification__c = 'Misc';
        Ca.HON_Commit_Date__c = System.Now();
        Insert ca;
        
        attachment A = New attachment();
        A.ParentId = Ca.id;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        A.Body = bodyBlob;
        A.ContentType = 'text/plain';
        A.Name = 'hello.txt';
        Insert A;
    }
    @isTest
    static void doPostcasetest1(){
        Account Acc = New Account();
        acc.Name = 'Air indigo';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        Insert acc;
        
        contact c = New contact();
        C.firstname = 'Test';
        C.LastName = 'Contact';
        C.Primary_Email_Address__c = 'test@gmail.com'; 
        C.AccountId = acc.id;
        C.Honeywell_ID__c = 'H147664';
        insert C;
            
            Id  rtSoftware_Tools_SW_Tools = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Software Tools (SWT)').getRecordTypeId();
        Case ca = New Case();
        Ca.Subject = 'Test Case';
        Ca.RecordTypeId = rtSoftware_Tools_SW_Tools;
        ca.Origin = 'Web';
        ca.Status = 'Open';
        Ca.Type = 'SW Tools';
        Ca.Contactid = C.id;
        Ca.Classification__c = 'Misc';
        Ca.HON_Commit_Date__c = System.Now();
        Insert ca;
        
        attachment A = New attachment();
        A.ParentId = Ca.id;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        A.Body = bodyBlob;
        A.ContentType = 'text/plain';
        A.Name = 'hello.txt';
        Insert A;
        test.startTest();
       // case ce = [Select id,Subject,Status,Type,Contactid,Classification__c,HON_Commit_Date__c,(Select id,Parentid,ContentType,Name from Attachments) from case Where id =:Ca.Id];
        caseRestResource reqst= New caseRestResource();
        String json= JSON.serialize(ca);
        System.debug('json'+json);
        RestRequest request = new RestRequest();
        request.requestUri ='services/apexrest/ngbss/api/v1/case/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        caseRestResource.doPostcase();
        test.stoptest();
    }
    @isTest static void doPostcasetest2(){
         Init();
        test.startTest();
        
        String json=       '{'+    
    '"status": "Open",'+
    '"origin": "COREPT",'+
    '"type": "Content",'+
    '"recordTypeId": "0120U000000HMgp",'+
    '"ownerId": "0051B00000Co2Af",'+
    '"priority": "Normal",'+
    '"subject": "Test subject",'+
    '"description": "Test subject",'+
    '"requestorEmail": "test@gmail.com",'+ 
    '"accountServicesEmail": "test@gmail.com",'+
    '"subClass": "Test class",'+
    '"subStatus": "subStatus",'+
    '"honeywellId": "H147664",'+

    '"attachments": [{'+
        '"Body": "d29ybGQ=",'+
        '"ContentType": "text/plain",'+
        '"Name": "hello.txt"'+
    '}, {'+
        '"Body": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY3growIAAycBLhVrvukAAAAASUVORK5CYII=",'+
        '"ContentType": "image/png",'+
        '"Name": "picture.png"'+
    '}]'+
    '}';
    System.debug('json'+json);
        RestRequest request = new RestRequest();
        request.requestUri ='services/apexrest/ngbss/api/v1/case/';
        request.httpMethod = 'POST';
        //request.addParameter('action', 'reprice');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        caseRestResource.doPostcase();
        test.stoptest();
    }
    @isTest
    static void doPostcasetest3(){
        Init();
        test.startTest();
        
        String json=        '{'+
            '    "status": "Open",'+
            '    "origin": "COREPT",'+
            '    "type": "Case",'+
            '    "ownerId": "'+UserInfo.getUserId()+'",'+
            '    "priority": "Normal",'+
            '    "description": "test",'+
            '    "subject": "test2",'+
            '    "requestorEmail": "test.test@honeywell.com",'+
            '    "accountServicesEmail": "test.test@honeywell.com",'+
            '    "subClass": "",'+
            '    "subStatus": "Misc",'+
            '    "honeywellId": ""'+
            '}';
        RestRequest request = new RestRequest();
        request.requestUri ='services/apexrest/ngbss/api/v1/case/';
        request.httpMethod = 'POST';
        //request.addParameter('action', 'reprice');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        caseRestResource.doPostcase();
        test.stoptest();
    }
    
    @isTest
    static void doPostcasetest4(){
         Init();
        test.startTest();
        
        String json=        '{'+
            '    "origin": "COREPT",'+
            '    "recordTypeId": "0120U000000HMgp",'+
            '    "type": "Case",'+
            '    "ownerId": "'+UserInfo.getUserId()+'",'+
            '    "priority": "Normal",'+
            '    "description": "test",'+
            '    "subject": "test2",'+
            '    "requestorEmail": "test.test@honeywell.com",'+
            '    "accountServicesEmail": "test.test@honeywell.com",'+
            '    "subClass": "",'+
            '    "subStatus": "Misc",'+
            '    "honeywellId": ""'+
            '}';
        RestRequest request = new RestRequest();
        request.requestUri ='services/apexrest/ngbss/api/v1/case/';
        request.httpMethod = 'POST';
        //request.addParameter('action', 'reprice');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        caseRestResource.doPostcase();
        test.stoptest();
    }
    @isTest
    static void doPostcasetest5(){
         Init();
        test.startTest();
        
        String json=        '{'+
            '    "status": "Open",'+
            '    "recordTypeId": "0120U000000HMgp",'+
            '    "origin": "COREPT",'+
            '    "ownerId": "'+UserInfo.getUserId()+'",'+
            '    "priority": "Normal",'+
            '    "description": "test",'+
            '    "subject": "test2",'+
            '    "requestorEmail": "test.test@honeywell.com",'+
            '    "accountServicesEmail": "test.test@honeywell.com",'+
            '    "subClass": "",'+
            '    "subStatus": "Misc",'+
            '    "honeywellId": ""'+
            '}';
        RestRequest request = new RestRequest();
        request.requestUri ='services/apexrest/ngbss/api/v1/case/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        caseRestResource.doPostcase();
        test.stoptest();
    } 
}