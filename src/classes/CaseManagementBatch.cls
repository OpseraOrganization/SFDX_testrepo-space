/*
* Description : When an email to case is created in the system, the case is being forwarded to Modal for AI\ML Classification.
*               This batch is used to handle the failure scenarios when Modal is unable to send the Case Classification Details(Case Type update details).
* Created Date :11/09/2020
* Created By : Swathi T
* Honeywell EID : H439423
*/
public class CaseManagementBatch  implements Database.Batchable<sObject>, Database.Stateful{

    public Datetime lastSuccesstime;
    public Datetime minBack10;
    public Job_Status__c jobStatus= Job_Status__c.getInstance('CaseManagementBatch');
    
    /*
    * Description : Start method to prepare the query for getting the list of Cases for which AI\ML Classification is failed.
    */
    public Database.QueryLocator start(Database.BatchableContext BC){
       String query;
       //Check if the current apex batch is already processing     
       //Query the Apex Batch Class
       ApexClass objApexClass = [SELECT Id FROM ApexClass WHERE Name = 'CaseManagementBatch'];
       List<AsyncApexJob> caseManagementAsyncJob  = [SELECT Id, Status,ApexClassID FROM AsyncApexJob WHERE ApexClassID =: objApexClass.Id and Status = 'Processing'];
       //Check if there is any existing CaseManagementBatch job in progress.
       if(caseManagementAsyncJob.isEmpty()){
       //Update lastSuccesstime from custom setting jobstatus
       if(jobStatus != null){
           lastSuccesstime=jobStatus.LastSuccessTime__c;
       }      
       Datetime minBack20;
       //Store the value of the current time minus 10 mins.
       minBack10= Datetime.now().addMinutes(-10);
       
       //Generate custom setting record in case of first schedule
       if(lastSuccesstime==null){
           jobStatus = new Job_Status__c();
           jobStatus.Name = 'CaseManagementBatch';
           insert jobStatus;
           //Query record created within 20 to 10 mins prior and still in progress
           minBack20= Datetime.now().addMinutes(-20);
           query='select id,Type,createddate,Data_Analysis_Status__c from case where CreatedDate >='+minBack20.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')+'AND CreatedDate <='+minBack10.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')+' AND Data_Analysis_Status__c = \'Data Analysis In-Progress\'';}
       else{
           //Query record created within last sucessfull batch time to 10 mins prior and still in progress
           minBack20= lastSuccesstime;
           query='select id,Type,Data_Analysis_Status__c from case where CreatedDate >='+minBack20.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')+'AND CreatedDate <='+minBack10.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')+' AND Data_Analysis_Status__c = \'Data Analysis In-Progress\'';
       		}
       }
        else{
           //Since there is an existing CaseManagementBatch in progres create a dummy query which will not pick up any record to avoid parallel execution of CaseManagementBatch
           DateTime currentTime = System.now();
           query='select id,reason,Data_Analysis_Status__c from case where Id = null and Data_Analysis_Status__c !=null and CreatedDate >: currentTime  limit 1';
       }
       return Database.getQueryLocator(query);
    }
    
    
    /*
    * Description : Execute method will create Chatter messages on the the list of Cases for which AI\ML Classification is failed.
    */
    public void execute(Database.BatchableContext BC, List<case> scope){
    
       List<CaseComment> commentList = new List<CaseComment>();
       
        for(case caseObj :scope){
            CaseComment comment=new CaseComment();
        	comment.ParentId = caseObj.id;
            comment.IsPublished=false;
            if(caseObj.Data_Analysis_Status__c=='Data Analysis In-Progress')
            {
                //Post feed on respective case
                comment.CommentBody='Case was forwarded to data analysis - classification failed, Type not updated';
            	commentList.add(comment);
                caseObj.Data_Analysis_Status__c='Data Analysis Failed';
            }
        }
        insert commentList;update scope;
    }
    
    /*
    * Description : Finish method will update the Job status custom setting record with the last succesfull execution time of the batch
    */
    public void finish(Database.BatchableContext BC){
        AsyncApexJob asyncJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email, ExtendedStatus from AsyncApexJob where Id = :BC.getJobId()];   
        //Update lastSuccesstime on custom setting once batch completed successfuly
        if(asyncJob.Status == 'Completed' && asyncJob.NumberOfErrors == 0 && minBack10 != null) {
            jobStatus.LastSuccessTime__c=minBack10;
            update jobStatus;
        }
    }

}