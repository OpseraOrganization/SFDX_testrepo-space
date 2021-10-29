// This test class is written for the incident - INC000009657671
@isTest()
Private Class TestClass_CaseOnHoldLogController{
static testMethod void TestClass_CaseOnHoldLogController(){

Test.StartTest();
Account acc=new Account(name='test account');
insert acc;

Contact con = new Contact();
con.LastName = 'Testcon';
con.FirstName = 'Test';
con.AccountId = acc.Id;
con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
con.Email='nandini.nanjappan@nttdata.com';
con.Employee_Number__c = 'E000002'; 
insert con;
        
Case cs = new Case();
cs.Origin = 'Email';
cs.Status = 'On Hold';
cs.Sub_Status__c = 'Contract Hold'; 
cs.VN_Name__c = con.Id;
cs.Reason_for_hold__c = 'Amended PO - Part Confirmation';        
cs.ContactId = con.Id;
cs.RecordtypeId = label.Repair_Overhaul_RT_ID;
cs.Classification__c = 'CSO Spares';
cs.Type = 'Place Order';
cs.HON_Commit_Date__c = system.today();
cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
cs.Government_Compliance_SM_M_Content__c = 'No';
cs.Primary_Email__c = 'nandini.nanjappan@nttdata.com';
cs.SuppliedEmail = 'nandini.nanjappan@nttdata.com'; 
insert cs;

Case_On_Hold_Log__c COH = new Case_On_Hold_Log__c();
COH.Sub_Status_hidden__c = 'Contract Hold';
COH.In_Progress_Status__c = 'In Progress - Contract Admin';
COH.Functional_Team_Completion_Date__c = null;
COH.Case_Number__c = cs.Id;
insert COH;

ApexPages.StandardController cont = new ApexPages.StandardController(coh);
System.currentPagereference().getParameters().put('id',coh.id);
CaseOnHoldLogController aler = new CaseOnHoldLogController(cont);
aler.dis();
Test.StopTest();

}
}