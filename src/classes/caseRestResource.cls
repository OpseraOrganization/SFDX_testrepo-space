/*********************************************************************************************************************************************
Name            : caseRestResource class
Created BY      : Karnatakam Ganguraju
Project         : Honeywell - NGBSS
Created Date    : 2nd December 2019
Modified Date   : 21th Jan 2020
Modified By     : Karnatakam Ganguraju
Class           : caseRestResource 
Test Class      : caseRestResourceTest
Description     : caseRestResource class used for creating a case from backend
***********************************************************************************************************************************************/
@RestResource(urlMapping='/ngbss/api/v1/case/*')
global with sharing class caseRestResource {
    @HttpPost
    //global static Map<String,String> doPostcase() {
        global static void doPostcase() {
        Map<String,String> response = new Map<String,String>();
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        try{
            String caseJSON = RestContext.request.requestbody.toString();
            System.debug('caseJSON'+caseJSON);
            Casefields CF = (Casefields)(JSON.deserialize(caseJSON,Casefields.class));
            Case C = New Case();
            IF(CF.origin != Null && CF.origin != ''){
                C.Origin = CF.origin;
            }
            else
                throw new MyException('Origin is mandatory in request body');
            IF(CF.status != Null && CF.status != ''){
                C.Status= CF.status;
            }
            else
                throw new MyException('Status is mandatory in request body');
            //C.RecordTypeId= CF.recordTypeId;
            IF(CF.type != Null && CF.type != ''){
                C.Type= CF.type;
            }
            else
                throw new MyException('Type is mandatory in request body');
            IF(CF.recordTypeId != Null && CF.recordTypeId != ''){
                C.RecordTypeId= CF.recordTypeId;
            }
            else
                throw new MyException('recordTypeId is mandatory in request body');
            //C.RecordTypeId= CF.recordTypeId;
          /*  IF(CF.ownerId != Null && CF.ownerId != ''){
                C.OwnerId= CF.ownerId;
            }
            else
                throw new MyException('ownerId is mandatory in request body'); */
            //C.OwnerId = CF.ownerId;
            IF(CF.priority != Null){
                C.Priority = CF.priority;
            }
            IF(CF.subject != Null){
                C.Subject = CF.subject;
            }
            IF(CF.description != Null){
                C.Description = CF.description;
            }
            IF(CF.requestorEmail != Null){
                C.Requestor_Email__c = CF.requestorEmail;
            }
            IF(CF.subClass != Null){
                C.Sub_Class__c = CF.subClass;
            }
            IF(CF.accountServicesEmail != Null){
                C.AccountServicesEmail__c = CF.accountServicesEmail;
            }
            IF(CF.subStatus != Null){
                C.Sub_Status__c = CF.subStatus;
            }
            IF(CF.honeywellId != Null){
                C.Honeywell_ID__c = CF.honeywellId;
                contact con = [Select id,accountid,Honeywell_ID__c,Honeywell_Contact__c from contact Where Honeywell_ID__c =: CF.honeywellId];
                If(con.accountId != Null)
                {
                c.accountid = con.accountId; 
                }
                If(con.id != Null)
                {
                c.contactId = con.id; 
                }
            }
            Insert c;
            System.debug(c);
            Case C1 = [Select id,CaseNumber from Case where id =:C.id limit 1];
            System.debug(C1);
            list<attachment> attachmentToInsert = new list<attachment>();
            If(CF.attachments != Null)
            {
            for (Attachmentlst att :CF.attachments) {
                attachmentToInsert.add(
                    new Attachment(parentId = C1.Id, 
                                   name = att.name, 
                                   contentType = att.contentType, 
                                   body = EncodingUtil.base64Decode(att.body)));
            }
            If(attachmentToInsert.Size()>0)
            {
            insert attachmentToInsert;
            }
            }
            System.debug('caseId'+ C1.id);
            System.debug('caseNumber'+ c1.CaseNumber);
            response.Put('caseId',C1.id);
            response.Put('caseNumber',c1.CaseNumber);
            
            res.responseBody = Blob.valueOf(json.serialize(response));
            res.statusCode = 200;
        }
        Catch(Exception e){
            system.debug('catch error messages'+e );
            system.debug('error is at '+e.getLineNumber());
            MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
            res.responseBody = Blob.valueOf(json.serialize(error));
            res.statusCode = 400; 
            //response.Put('BAD_REQUEST',e.getMessage());
            //response.Put('statusCode','400');
            //return response;
        }  
        //return response;
    }
    global class Casefields{
        public String origin;
        public String status;
        public String recordTypeId;
        public String type;
        public String ownerId;
        public String priority;
        public String subject;
        public String description;
        public String requestorEmail;
        public String accountServicesEmail;
        public String subClass;
        public String subStatus;
        public String honeywellId;
        Public List<Attachmentlst> Attachments{Get;Set;}
    }   
    
    global class Attachmentlst {
        Public String body;
        Public String contentType;
        Public String name;
    } 
    global class MyExc { 
        public string errorCode;
        public string message;
        MyExc(string errorCode, string message){
            this.errorCode = errorCode;
            this.message = message;
        }
    }
    public class MyException extends Exception {
    }
}