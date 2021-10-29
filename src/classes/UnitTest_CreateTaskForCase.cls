@isTest
public class UnitTest_CreateTaskForCase{
    testMethod static void testCreateTaskForCase(){
      
       Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
       system.debug('RecordTypeIdCase value:'+RecordTypeIdCase);
       Account acct = new Account(Name='Test',Customer_Status__c='Active',REPORT_ACCOUNT_NAME__c='Testing');
       acct.Strategic_Business_Unit__c='BGA';
       
        insert acct;
      Platform__c pla =new Platform__c();
        insert pla;
       Fleet_Asset_Detail__c faa = new Fleet_Asset_Detail__c();
      
       faa.Aircraft_Delivery_Date__c = Date.today();
       faa.Platform_Name__c = pla.id;
       faa.Account__c = acct.id;
       faa.Inside_Sales__c=UserInfo.getUserId();
       faa.Aircraft_Delivery_Date__c = Date.today().addMonths(-22);
       
       insert faa;
       
       Fleet_Asset_Detail__c faa1 = new Fleet_Asset_Detail__c();
      
       faa1.Aircraft_Delivery_Date__c = Date.today();
       faa1.Platform_Name__c = pla.id;
       faa1.Account__c = acct.id;
       faa1.Inside_Sales__c=UserInfo.getUserId();
       faa1.Aircraft_Delivery_Date__c = Date.today().addMonths(-22);
       faa1.Tail_Number__c = '1234';
       faa1.Serial_Number__c = '1234'; 
       insert faa1;
      Contract contractRec = new Contract();
      contractRec.AccountId = acct.id;
      insert contractRec;
       Test.startTest();
      acct = [select id,Strategic_Business_Unit__c from Account where id=:acct.id];
      Case caseRec = new Case();
      caseRec.createdDate = System.today().addMonths(-2);
      caseRec.Status ='Closed';
      caseRec.Sales_Order_Number__c ='123';
      //caseRec.Serv_Contract__c = contractRec.id;
      caseRec.Aircraft_Tail_Number__c = '1234';
      caseRec.Aircraft_Serial_Number__c ='1234';
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
       CreateTaskForCaseScheduler p = new CreateTaskForCaseScheduler(); //Schedule apex class name
       String sch = '0 0 * * * ?'; //schedule interval time
       system.schedule('One Time Pro', sch, p); //system method to schedule apex class*/
       
        
       CreateTaskForCase ct = new CreateTaskForCase();
       database.executebatch(ct,200);
       Test.stopTest();
    }
}