/*------------------------------------------------------------ 
Author:        Swathi T 
Company:       NTT DATA
Description:   This is a test class for CaseManagementBatch & ScheduledCaseUpdate
History 
24/11/2020      Created for Intelligent Case Management project. 
*/
@istest
public class CaseManagementBatchTest {
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to create test data. 
    History:
    24/11/2020     Created for Intelligent Case Management project.
    */ 
    @testsetup
    public static void prepareCaseTestData(){
       //Create Case
       RecordType  objcustomerSuppoert = [SELECT Id FROM RecordType WHERE DeveloperName = 'Orders' AND SobjectType = 'Case'].get(0);
       Case caseobj= new Case(Origin='Email',Data_Analysis_Status__c='Data Analysis In-Progress',RecordTypeId = objcustomerSuppoert.Id);
       insert caseobj;
       Datetime minBack15 = Datetime.now().addMinutes(-15);
       Test.setCreatedDate(caseobj.Id, minBack15); 
    }
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the functionality of Failure management in batch class
    History:
    24/11/2020     Created for Intelligent Case Management project.
    */ 
    @istest
    public static void caseManagementFailureTest(){
       Test.startTest();
       Job_Status__c jobStatus = new Job_Status__c();
       jobStatus.Name = 'CaseManagementBatch';
       jobStatus.LastSuccessTime__c=Datetime.now().addMinutes(-20);
       insert jobStatus;
       CaseManagementBatch batchInstance = new CaseManagementBatch();
	   database.executeBatch(batchInstance, 100);
       List<Case> cases = [Select Id,Type,Data_Analysis_Status__c from Case];
       Test.stopTest();
       CaseComment caseComment = [select id,IsPublished,ParentId,CommentBody  from CaseComment where parentId =:cases[0].id];
       System.assert(string.valueof(caseComment.CommentBody).contains('Case was forwarded to data analysis - classification failed, Type not updated'),'File details update on Case is failed');
    }
    /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the schedule functionality
    History:
    24/11/2020     Created for Intelligent Case Management project.
    */ 
    @istest
    public static void scheduledCaseUpdateTest(){
       Test.startTest();
       CaseManagementBatchScheduler scheduleInstance = new CaseManagementBatchScheduler(); 
       System.schedule('Scheduled Job 10', '0 0 * * * ?', scheduleInstance);
       Test.stopTest();
    }

}