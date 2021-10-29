/*------------------------------------------------------------ 
Author:        Swathi T 
Company:       NTT DATA
Description:   This is a test class for CaseManagementAutomation      
History 
24/11/2020      Created for Intelligent Case Management project. 
*/
@isTest
public class CaseManagementAutomationTest {
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the success functionality of updating case through rest resource
    History:	
    24/11/2020     Created for Intelligent Case Management project.
    */  
 	@isTest
    public static void caseManagementAutomationSuccess(){
       //Create test case
	   User defaultUser=[select id from user where name='Aero Default'];
       System.runAs(defaultUser) {
       Case failureCaseobj= new Case(origin='Email',type='Order Status',File_Details__c='Aero Mailbox : xlsx : 16988 ;');
       insert failureCaseobj;
       CaseComment commentCase = new CaseComment(ParentId = failureCaseobj.id,CommentBody= 'Case forwarded to Data Analysis',IsPublished=false);
       insert commentCase;
       Test.startTest();
       //Test callout to hit rest resource CaseManagement 
       RestRequest failureReq = new RestRequest(); 
       RestResponse failureRes = new RestResponse();             
       failureReq.requestURI = '/services/apexrest/CaseManagement/';
       failureReq.httpMethod = 'POST';
       failureReq.requestBody=Blob.valueOf('{"caseId":"'+failureCaseobj.id+'","caseType":"Place Order","feedMessage":"Classified-casereason"}');
       RestContext.request = failureReq;
       RestContext.response= failureRes;
       CaseManagementAutomation.doPost();
       //Verify if the Response

       System.assert(failureRes.responseBody.toString()=='\"Successfully updated Case\"','File details update on Case is failed');
       
       Test.stopTest();}
    }
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the Failure functionality of updating case through rest resource
    History:	
    24/11/2020     Created for Intelligent Case Management project.
    */ 
    @isTest
    public static void caseManagementAutomationFailure(){
       Test.startTest();
       //Test callout to hit rest resource CaseManagement 
       RestRequest errorReq = new RestRequest(); 
       RestResponse errorRes = new RestResponse();             
       errorReq.requestURI = '/services/apexrest/CaseManagement/';
       errorReq.httpMethod = 'POST';
       errorReq.requestBody=Blob.valueOf('{"caseId":"XXX","caseType":"Place Order","feedMessage":"Classified-casereason"}'); 
       RestContext.request = errorReq;
       RestContext.response= errorRes;
       CaseManagementAutomation.doPost();
       //Verify if the Response
       System.assert(errorRes.responseBody.toString()=='\"Please provide correct CaseId\"','File details update on Case is failed');
       Test.stopTest();
       
    }
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the Error functionality of updating case through rest resource
    History:	
    24/11/2020     Created for Intelligent Case Management project.
    */ 
    @isTest
    public static void caseManagementAutomationError(){
       //Create test case
       Case errorCaseobj= new Case(origin='Email');
       insert errorCaseobj; 
       CaseComment commentCase = new CaseComment(ParentId = errorCaseobj.id,CommentBody= 'Case forwarded to Data Analysis',IsPublished=false);
       insert commentCase; 
       Test.startTest();
       //Test callout to hit rest resource CaseManagement 
       RestRequest errorReq = new RestRequest(); 
       RestResponse errorRes = new RestResponse();             
       errorReq.requestURI = '/services/apexrest/CaseManagement/';
       errorReq.httpMethod = 'POST';
       errorReq.requestBody=Blob.valueOf('{"caseId":"'+errorCaseobj.id+'""caseType1":"Place Order1","feedMessage":"Classified-casereason"}'); 
       RestContext.request = errorReq;
       RestContext.response= errorRes;
       CaseManagementAutomation.doPost();
       //Verify if the Response
       System.assert(errorRes.responseBody.toString()=='\"Invalid JSON\"','File details update on Case is failed');







       Test.stopTest();
    }
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the case with original type through rest resource
    History:	
    24/11/2020     Created for Intelligent Case Management project.
    */ 
    @isTest
    public static void caseManagementAutomationWithtype(){
       //Create test case
       User defaultUser=[select id from user where name='Aero Default'];
       System.runAs(defaultUser) {
       Case successCaseobj= new Case(origin='Email');
       insert successcaseobj;
       CaseComment commentCase = new CaseComment(ParentId = successCaseobj.id,CommentBody= 'Case forwarded to Data Analysis',IsPublished=false);
       insert commentCase; 
       Test.startTest();
       //Test callout to hit rest resource CaseManagement 
       RestRequest successReq = new RestRequest(); 
       RestResponse successRes = new RestResponse();             
       successReq.requestURI = '/services/apexrest/CaseManagement/';
       successReq.httpMethod = 'POST';
       successReq.requestBody=Blob.valueOf('{"caseId":"'+successCaseobj.id+'","caseType":"","feedMessage":"Classified-casereason"}'); 
       RestContext.request = successReq;
       RestContext.response= successRes;
       CaseManagementAutomation.doPost();
       //Verify if the Response
       System.assert(successRes.responseBody.toString()=='\"Successfully updated Case\"','File details update on Case is failed');
       Test.stopTest();
       }
    }
     /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the Duplicate functionality of updating case through rest resource
    History:	
    24/11/2020     Created for Intelligent Case Management project.
    */ 
    @isTest
    public static void caseManagementAutomationDuplicate(){
       //Create test case
       Case successCaseobj= new Case(origin='Email',Data_Analysis_Status__c='Data Analysis Completed');
       insert successcaseobj;
       CaseComment commentCase = new CaseComment(ParentId = successCaseobj.id,CommentBody= 'Case forwarded to Data Analysis',IsPublished=false);
       insert commentCase; 
       Test.startTest();
       //Test callout to hit rest resource CaseManagement 
       RestRequest successReq = new RestRequest(); 
       RestResponse successRes = new RestResponse();             
       successReq.requestURI = '/services/apexrest/CaseManagement/';
       successReq.httpMethod = 'POST';
       successReq.requestBody=Blob.valueOf('{"caseId":"'+successCaseobj.id+'","caseType":"","feedMessage":"Classified-casereason"}'); 
       RestContext.request = successReq;
       RestContext.response= successRes;
       CaseManagementAutomation.doPost();
       //Verify if the Response
       System.assert(successRes.responseBody.toString()!='\"Successfully updated Case\"','File details update on Case is failed');
       Test.stopTest();
    }
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the Exception functionality of updating case through rest resource
    History:	
    24/11/2020     Created for Intelligent Case Management project.
    */  
 	@isTest
    public static void caseManagementAutomationException(){
       //Create test case

       Case failureCaseobj= new Case(origin='Email',type='Place Order');
       insert failureCaseobj;
       CaseComment commentCase = new CaseComment(ParentId = failureCaseobj.id,CommentBody= 'Case forwarded to Data Analysis',IsPublished=false);
       insert commentCase;
       Test.startTest();
       //Test callout to hit rest resource CaseManagement 
       RestRequest failureReq = new RestRequest(); 
       RestResponse failureRes = new RestResponse();             
       failureReq.requestURI = '/services/apexrest/CaseManagement/';
       failureReq.httpMethod = 'POST';
       failureReq.requestBody=Blob.valueOf('{"caseId":"'+failureCaseobj.id+'","feedMessage":"Classified-casereason"}');
       RestContext.request = failureReq;
       RestContext.response= failureRes;
       try{CaseManagementAutomation.doPost();}
       catch(exception e){}
       Test.stopTest();
    }





























































































    
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the functionality of updating case without attachment through rest resource
    History:	
    24/11/2020     Created for Intelligent Case Management project.
    */  
 	@isTest
    public static void caseManagementAutomationNotDefaultUser(){
       //Create test case
	  
       Case failureCaseobj= new Case(origin='Email',type='Order Status',File_Details__c='NONE');
       insert failureCaseobj;
       CaseComment commentCase = new CaseComment(ParentId = failureCaseobj.id,CommentBody= 'Case forwarded to Data Analysis',IsPublished=false);
       insert commentCase;
       Test.startTest();
       //Test callout to hit rest resource CaseManagement 
       RestRequest failureReq = new RestRequest(); 
       RestResponse failureRes = new RestResponse();             
       failureReq.requestURI = '/services/apexrest/CaseManagement/';
       failureReq.httpMethod = 'POST';
       failureReq.requestBody=Blob.valueOf('{"caseId":"'+failureCaseobj.id+'","caseType":"Place Order","feedMessage":"Classified-casereason"}');
       RestContext.request = failureReq;
       RestContext.response= failureRes;
       CaseManagementAutomation.doPost();
       //Verify if the Response
       System.assert(failureRes.responseBody.toString()!='\"Successfully updated Case\"','File details update on Case is failed');
       Test.stopTest();
    }
}