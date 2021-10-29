@isTest
public class AERO_Feedback_Test {

    static testMethod void testFeedBack(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        test.startTest();
        request.requestURI = '/feedback/';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        AERO_Feedback.inputWrapper jsonObj = new AERO_Feedback.inputWrapper();
        jsonObj.email ='Nisha.gupta2@honeywell.com';
        Contact con = new Contact(LastName = 'Test',Primary_Email_Address__c = 'Nisha.gupta2@honeywell.com', AccountId= '0013000000eciic' );
        insert con;
        knowledge__kav newArticle = new knowledge__kav(Title='test',summary='xyz',urlname='xyz',validationStatus = 'WIP',currencyISOCode = 'USD',Question_Problem__c='test Question',Answer_Solution__c='test answer',Technical_review_needed__c='No');
        insert newArticle;
        knowledge__kav newArticle1 = [select id,articleNumber from knowledge__kav where id = :newArticle.id limit 1];
        jsonObj.articleNumber = newArticle1.articleNumber;
        jsonObj.comment ='Test Comment';
        jsonObj.wasTheArticleHelpful ='Yes';  
        request.requestBody = blob.valueOf(JSON.serialize(jsonObj));  
        AERO_Feedback.doPost();
        test.stopTest();
        
    }
    
    static testMethod void testFeedBack1(){
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        test.startTest();
        request.requestURI = '/feedback/';  //Request URL
        request.httpMethod = 'POST';//HTTP Request Type
        
        AERO_Feedback.inputWrapper jsonObj = new AERO_Feedback.inputWrapper();
        jsonObj.email ='';
        jsonObj.articleNumber ='00085522';
        //jsonObj.articleName ='Test Article';
        //jsonObj.articleType ='Test Type';
        jsonObj.comment ='Test Comment';
        jsonObj.wasTheArticleHelpful ='Yes';
        request.requestBody = blob.valueOf(JSON.serialize(jsonObj));
        AERO_Feedback.doPost();
        test.stopTest();
        
    }
}