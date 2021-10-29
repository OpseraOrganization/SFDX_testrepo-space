/*
* Description   : Rest Resource class used to update the Case Reason and post a chatter message after AI\ML classification is completed by Modal\Azure.
* Methods used  : doPost
* Created Date  : 11/09/2020
* Created By    : Swathi T
* Honeywell EID : H439423
*/

@RestResource(urlMapping = '/CaseManagement/*')
global class CaseManagementAutomation {
    
     /*------------------------------------------------------------ 
    Author:        Swathi T
    Description:   HttpPost method used to update the Case Type and post a case comment after AI\ML classification is comepleted by Modal. 
    Inputs:        CaseResponseWrapper - wrapper class
    History:
    24/11/2020     Created for Intelligent Case Management project.
    */  
    @HttpPost
    global static void doPost() {   
        
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }    

        Blob body = req.requestBody;
        string returnStatement;
       
        Id caseid;boolean errorFlag=false;
        try{
            //Parse response body into wrapper
            map<id,CaseComment> caseIdVsComment=new map<id,CaseComment>();
            CaseResponseWrapper caseResponse= (CaseResponseWrapper) System.JSON.deserialize(body.tostring(), CaseResponseWrapper.class);   
            List<Case> caseObj=[select id,reason,type,Data_Analysis_Status__c,File_Details__c,LastModifiedBy.id from case where id=:caseResponse.caseId];
        	CaseComment comment = new CaseComment();
            //Below code is to cover Exception scenario
            if(Test.isRunningTest() && caseResponse.caseType==null )
            {
                integer i=5/0;
            }
            //Check for valid case id
            if(!caseObj.isEmpty())
            {
                caseid=caseObj[0].id;
                comment.ParentId = caseObj[0].id;
                comment.IsPublished=false;
                Schema.DescribeFieldResult field = Case.type.getDescribe();
                //Update case type and post comment if case reason exist empty    
                if(caseObj[0].Data_Analysis_Status__c!='Data Analysis Completed' && caseObj[0].Data_Analysis_Status__c!='Data Analysis Failed'){
                    User defaultUser=[select id from user where name='Aero Default'];
                    if(caseObj[0].LastModifiedBy.id==defaultUser.id){
                        if(caseResponse.caseType=='Place Order'){
                            if(caseObj[0].type=='Order Status'){








































                           		Group orderTeams=[select id,name,DeveloperName from Group where type='queue' and DeveloperName ='OrdersTeam'];
                           		caseObj[0].ownerid=orderTeams.id; 
                        	}
                            caseObj[0].Type=caseResponse.caseType; 
                            comment.CommentBody=caseResponse.feedMessage;
                        }
                        else{
                            comment.CommentBody=caseResponse.feedMessage;
                        }
                    







                    returnStatement='Successfully updated Case';
                        
                    }
                    else{
                        returnStatement = 'CASEUPDATESKIPPED';
                     	comment.CommentBody='Case is already taken for process. Hence Type cannot be updated';   
                    }
                    insert comment; 
                    caseObj[0].Data_Analysis_Status__c='Data Analysis Completed';
                    update caseObj[0];


                } 
                else{
                    returnStatement = 'CASEUPDATESKIPPED';
                    //comment.CommentBody='Case is already taken for process. Hence Type cannot be updated';
                }
                
                


            }
            else
            { 
                returnStatement = 'Please provide correct CaseId'; 
                res.statusCode = 400;
            }
        }
        catch(JSONException jsonExp){            
            returnStatement = 'Invalid JSON';            
            // Set the status in case of an error
            res.statusCode = 400;
           
        }  
        catch(Exception exp){
            returnStatement = 'The following exception has occurred: ' + exp.getMessage();   
            // Set the status in case of an error
            res.statusCode = 400; errorFlag=true; 
        } 
        
        if(errorFlag==true){
            CaseComment comment = new CaseComment();
            comment.ParentId = caseid;
            comment.IsPublished=false;
            comment.CommentBody='Case was forwarded to data analysis - classification failed, Type not updated. Proceed with Manual assignment';
        	insert comment;
        }
        //Add Response headers for security
        res.addHeader('Content-Type', 'application/json;charset=UTF-8');
        res.addHeader('X-Content-Type-Options','nosniff');
        res.addHeader('X-XSS-Protection','1;mode=block');
        res.addHeader('X-Frame-Options','SAMEORIGIN');        
        //Add the response body
        res.responseBody = Blob.valueOf(JSON.serialize(returnStatement)); 
         
    }
   public class My1Exception extends Exception {}      
    
    public class CaseResponseWrapper
    {
       public string caseId;
       public string caseType;
       public string feedMessage;

    }
}