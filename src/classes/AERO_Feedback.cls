@RestResource(urlMapping = '/feedback/*')
global with sharing class AERO_Feedback {
    
    @HTTPPost
    global static void doPost(){
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        string requestURI = req.requestURI;
        String body=req.requestbody.toString();
        String header = JSON.serialize(req.headers);
        inputWrapper jsonBody; 
        //Result response = new Result();        
        inputWrapper reqInput = (inputWrapper) JSON.deserialize(body, inputWrapper.class);
        AERO_Result result = createFeedback(reqInput);
        
        if(json.serialize(result) != '[]'){
            res.responseBody = Blob.valueOf(json.serialize(result));
        }
        
        
    }
    
    public static AERO_Result createFeedback(inputWrapper feedBackDetails){
        AERO_Result result = new AERO_Result();
        Id rtId = Schema.SObjectType.feedback__c.getRecordTypeInfosByName().get('Article Feedback').getRecordTypeId();   
        feedback__c feedBackRecord = new feedback__c();
        if(String.isNotBlank(feedBackDetails.email)){
            list<Contact> con = [select id from Contact where Primary_Email_Address__c = :feedBackDetails.email];
            if(con.size()<1){
                result.handleError(404, 'No user found for given email address', 'Please provide valid email address');
                return result;
            }else if(con.size()>0){
                feedBackRecord.Contact__c = con[0].id;
            }
        }else if(String.isBlank(feedBackDetails.email)){
            result.handleError(400, 'Email address not provided', 'Please provide email address');
            return result;
        }
        if(String.isNotBlank(feedBackDetails.articleNumber)){
            list<Knowledge__Kav> articleName = [select title,id from Knowledge__Kav where articleNumber = :feedBackDetails.articleNumber limit 1];
            if(articleName.size()>0){
                feedBackRecord.Article_Name__c = articleName[0].Title;
                feedBackRecord.Article_Id__c = articleName[0].id;
            }else if(articleName.size()<1){
                result.handleError(400, 'No record found for given article number', 'Please provide valid article number');
                return result;
            }
            
        }else{
            result.handleError(400, 'Article number not provided', 'Please provide article number');
            return result;
        }
        feedBackRecord.RecordTypeId = rtId;
        //feedBackDetails.articleId;
        //feedBackRecord.Article_Name__c = feedBackDetails.articleName;
        //feedBackRecord.Article_Type__c = feedBackDetails.articleType;
        feedBackRecord.Was_Article_Helpful__c = feedBackDetails.wasTheArticleHelpful;
        feedBackRecord.Customer_Feedback__c = feedBackDetails.comment;
        insert feedBackRecord;
        system.debug('feedBackRecord***' +feedBackRecord);
        result.resourceId = feedBackRecord.id;
        result.Status = 'Feedback successfully created';
        
        
        /*}*/
        return result; 
    }
    
    public class inputWrapper{
        public String email{get;set;}
        public String articleNumber{get;set;}
        //public String articleName{get;set;}
        //public String articleType{get;set;}
        public String comment{get;set;}
        public String wasTheArticleHelpful{get;set;}
    }
}