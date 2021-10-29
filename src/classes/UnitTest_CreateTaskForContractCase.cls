@isTest
public class UnitTest_CreateTaskForContractCase{
    testMethod static void testCreateTaskForContractCase(){
      
       Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();
       system.debug('RecordTypeIdCase value:'+RecordTypeIdCase);
       Account acct = new Account(Name='Test',Customer_Status__c='Active',REPORT_ACCOUNT_NAME__c='Testing');
       acct.Strategic_Business_Unit__c='BGA';
       
        insert acct;
       Test.startTest();
      acct = [select id,Strategic_Business_Unit__c from Account where id=:acct.id];
      Case caseRec = new Case();
      caseRec.createdDate = System.today();
      caseRec.Status ='On Hold';
      caseRec.Sub_Status__c ='Reinstatement Opp';
      caseRec.RecordTypeId = RecordTypeIdCase;
      caseRec.AccountId = acct.id;
      caseRec.ClosedDate = System.now().dateGMT();
      insert caseRec;
      
      Account acctTemp = [select id,Customer_Status__c,REPORT_ACCOUNT_NAME__c,Strategic_Business_Unit__c from Account where id=:acct.id];
      system.debug('Account record details:'+acctTemp);
       Case recr = [select AccountId from Case];
       recr.AccountId = acct.id;
       update recr;
       recr = [select AccountId from Case];
       system.debug('recr Value:'+recr.AccountId);
       CreateTaskForContractCaseScheduler p = new CreateTaskForContractCaseScheduler(); //Schedule apex class name
       String sch = '0 0 * * * ?'; //schedule interval time
       system.schedule('One Time Pro', sch, p); //system method to schedule apex class*/
       
        
       CreateTaskForContractCase ct = new CreateTaskForContractCase();
       database.executebatch(ct,200);
       Test.stopTest();
    }
}