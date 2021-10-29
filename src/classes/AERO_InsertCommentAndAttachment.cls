@RestResource(urlMapping='/caseCommentAndAttachment/*')
global with sharing class AERO_InsertCommentAndAttachment {
    
    @httpPost
    global static void doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String header = JSON.serialize(req.headers);
        //String fileExtension = req.headers.get('fileExtension');
        //String title = req.headers.get('title');
        String contactId = req.headers.get('contactId');
        //String commentBody = req.headers.get('commentBody');
        String body = req.requestBody.toString();
        //system.debug('body***'+body);
        JSON2Apex  reqWrap = (JSON2Apex) System.JSON.deserialize(body, JSON2Apex.class);
        AERO_Result result = insertCommentAndAttachment(reqWrap,contactId);
        system.debug('reqWrap***' +reqWrap.files);
        //res.statusCode = result.statusCode;
        if(json.serialize(result) != '[]'){  
            res.responseBody = Blob.valueOf(json.serialize(result));
        }
        //res.responseBody = blob.valueOf('{"id":"'+cv.Id+'"}');  
        
    }  
    
    public static AERO_Result insertCommentAndAttachment(JSON2Apex inputs,String conId){
        
        //system.debug('inputs***'+inputs);
        AERO_Result result = new AERO_Result();
        list<contentVersion> cvList = new list<contentVersion>();
        if(String.isBlank(inputs.commentBody)){
            result.handleError(400,'No comment found','Comment is mandatory');
            return result;
        }
        if(String.isBlank(conId)){
            result.handleError(400,'Contact Id not provided','Please Provide contact Id');
            return result;
        }
        if(conId.length()<15){
            result.handleError(404,'ContactId length is inappropriate','Contact Id length should be either 15 or 18 digit');
            return result;
        }
        String ConIdFromHeader = conId.substring(0,15);
        //List<requestWrapper> wrapperDeserialized = (List<requestWrapper>) JSON.deserializeStrict(inputs,list<requestWrapper>.class);
        if(String.isNotBlank(inputs.caseNumber)){
            system.debug('inside if 1');
            list<case> cs = [select caseNumber,contactId,recordType.name,Origin,ownerId,OwnerName__c,Portal_request_type__c,Order_Type__c from case where caseNumber = :inputs.caseNumber limit 1];
            /*if(cs.size()<1){
result.handleError(404,'Invalid Case number','Please provide valid case number');
return result;
}*/
            if(cs.size()>0 && String.isNotBlank(cs[0].recordType.name)){
                list<AERO_PortalRequestType__mdt> portalreqList = [SELECT Lead_Days__c,Label from AERO_PortalRequestType__mdt where Label =:cs[0].recordType.name];
                if(portalreqList.size()<1){
                    result.handleError(404,'Case record Type is different','Case comment and Attachments cannot be uploaded');
                    return result;
                }
            }
            if(cs.size()<1){
                result.handleError(404, 'Invalid case number', 'Please provide valid case number');
                return result;
            }else if(cs.size()>0 && String.isNotBlank(conId)){
                String csConId = cs[0].contactId;  // To convert and compare the contactId with header param
                String conIdOnCase = '';
                if(String.isNotBlank(csConId)){
                    conIdOnCase = csConId.substring(0, 15);
                }
                if(conIdOnCase != ConIdFromHeader){
                    result.handleError(404,'ContactId is not same','Case details cannot be updated');
                    return result;
                }
                if(inputs.files != null && inputs.files.size()>0){
                    for(RequestWrapper attachment : inputs.files){
                        contentVersion cv = new contentVersion();
                        cv.PathOnClient = attachment.title+'.'+attachment.fileExtension;
                        cv.Title = attachment.title+'.'+attachment.fileExtension;
                        cv.VersionData = EncodingUtil.base64Decode(attachment.versionData);
                        cv.ContentLocation = 'S';
                        cvList.add(cv);
                        //system.debug('PathOnClient***' +PathOnClient);
                        //system.debug('pathOnClient***' +cv.PathOnClient);
                    }
                    insert cvList;
                    list<ContentDocumentLink> conDocLinkList = new list<ContentDocumentLink>();
                    list<contentVersion> contentDocs = [select ContentDocumentId from ContentVersion where id in:cvList];
                    for(contentVersion cv1 :contentDocs){
                        //create ContentDocumentLink  record  
                        ContentDocumentLink conDocLink = New ContentDocumentLink();
                        conDocLink.LinkedEntityId = cs[0].id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                        conDocLink.ContentDocumentId = cv1.ContentDocumentId;  //ContentDocumentId Id from ContentVersion
                        conDocLink.shareType = 'I';
                        conDocLink.Visibility = 'AllUsers';
                        conDocLinkList.add(conDocLink);
                    }
                    insert conDocLinkList;
                }
                if(String.isNotBlank(inputs.commentBody)){
                    caseComment cc = new caseComment();
                    cc.ParentId = cs[0].id;
                    cc.CommentBody = inputs.commentBody;
                    cc.isPublished = True;
                    insert cc;
                }
            }
            String ownerId = '';
            /*if(cs[0].recordType.name == 'Repair & Overhaul' && cs[0].Origin == 'SAP Interface'){
                ownerId = [select Id from Group where Type = 'Queue' AND DeveloperNAME = 'CSOROTeam'].id;
                cs[0].OwnerId = ownerId;
            }*/
            
            if((cs[0].recordType.name != null &&(cs[0].recordType.name == 'Repair & Overhaul' || cs[0].recordType.name == 'Orders'))&& cs[0].OwnerName__c == 'Aero Default'){
                ownerId = [select Id from Group where Type = 'Queue' AND DeveloperNAME = 'CSOROTeam'].id;
                cs[0].OwnerId = ownerId;
            }


            
            /*if(String.isNotBlank(ownerId)){
                cs[0].status = 'Open-Comment-Attachment';
                cs[0].sub_status__c = '';
                cs[0].OwnerId = ownerId; 
                update cs;
            }else{
                cs[0].status = 'Open-Comment-Attachment';
                cs[0].sub_status__c = '';
                update cs;
            }*/
            cs[0].status = 'Open-Comment-Attachment';
            cs[0].sub_status__c = '';
            update cs;
        }else{
            result.handleError(400, 'No case number found', 'Please provide case number');
            return result;
        }
        
        result.Status = 'Files/CaseComment successfully created';
        return result; 
        //result.resourceId = cvList[0].id;
        
    }
    
    public class JSON2Apex {
        public List<RequestWrapper> files;
        Public String commentBody;
        Public String caseNumber;
    }
    
    public class RequestWrapper{
        public String fileExtension{get;set;}
        public String title{get;set;}
        public String versionData{get;set;}
    }
    
}