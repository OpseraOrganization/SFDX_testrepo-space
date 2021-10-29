@isTest
public class UnitTest_TaskForFailureToTransferCase{
    testMethod static void testTaskForFailureToTransferCase(){
      
       Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();
       system.debug('RecordTypeIdCase value:'+RecordTypeIdCase);
       Account acct = new Account(Name='Test',Customer_Status__c='Active',REPORT_ACCOUNT_NAME__c='Testing');
       acct.Strategic_Business_Unit__c='BGA';
       
        insert acct;
        
        Contact cont=new Contact(firstname='Test',LastName='Contact Inactive',AccountId=acct.Id,Phone_3__c='9986502456',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E534543',Employee_Contact_Role__c='Administrator',ownerid = UserInfo.getUserId() );
        insert cont;
        
       Test.startTest();
      acct = [select id,Strategic_Business_Unit__c from Account where id=:acct.id];
      Case caseRec = new Case();
      caseRec.createdDate = System.today();
      caseRec.Status ='Done';
      caseRec.Sub_Status__c ='Failure To Transfer';
      caseRec.RecordTypeId = RecordTypeIdCase;
      caseRec.AccountId = acct.id;
      caseRec.ClosedDate = datetime.now();
      caseRec.contactId = cont.id;
      insert caseRec;
      caseRec = [select status,sub_status__c,closedDate,RecordType.Name from Case where id=:caseRec.id];
      system.debug('Case rec values:'+caseRec);
      Account acctTemp = [select id,Customer_Status__c,REPORT_ACCOUNT_NAME__c,Strategic_Business_Unit__c from Account where id=:acct.id];
      system.debug('Account record details:'+acctTemp);
       Case recr = [select AccountId from Case];
       recr.AccountId = acct.id;
       update recr;
       recr = [select AccountId from Case];
       system.debug('recr Value:'+recr.AccountId);
       TaskForFailureToTransferCaseScheduler p = new TaskForFailureToTransferCaseScheduler(); //Schedule apex class name
       String sch = '0 0 * * * ?'; //schedule interval time
       system.schedule('One Time Pro', sch, p); //system method to schedule apex class*/
       
        
       TaskForFailureToTransferCase tf = new TaskForFailureToTransferCase();
       database.executebatch(tf,200);
       Test.stopTest();
    }
}