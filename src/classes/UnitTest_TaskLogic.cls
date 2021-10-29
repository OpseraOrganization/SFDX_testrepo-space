@isTest
public class UnitTest_TaskLogic{
    testMethod static void testTaskCreation(){
       Account acct = new Account(Name='Test',Strategic_Business_Unit__c='BGA');
        insert acct;
      Platform__c pla =new Platform__c();
      pla.OEM_warranty_period__c ='12';
             insert pla;
       Fleet_Asset_Detail__c faa = new Fleet_Asset_Detail__c();
      
       faa.Aircraft_Delivery_Date__c = Date.today();
       faa.Platform_Name__c = pla.id;
       faa.Account__c = acct.id;
       faa.Inside_Sales__c=UserInfo.getUserId();
       faa.Aircraft_Delivery_Date__c = Date.today().addMonths(-12);
       
       insert faa;
       
        Fleet_Asset_Detail__c faa1 = new Fleet_Asset_Detail__c();
      
       faa1.Aircraft_Delivery_Date__c = Date.today();
       faa1.Platform_Name__c = pla.id;
       faa1.Account__c = acct.id;
       faa1.Inside_Sales__c=UserInfo.getUserId();
       faa1.Aircraft_Delivery_Date__c = Date.today().addMonths(-12);
       
       insert faa1;
        
      contract newcontract1 = new contract(accountid=acct.id,startdate=date.valueOf('2017-02-22'),status='Draft',Aircraft__c=faa.id,EndDate=system.today(),Type__c='APM',Site_Name__c='SAP_CNT');       
        insert newcontract1; 
        contract newcontract2 = new contract(accountid=acct.id,startdate=date.valueOf('2017-02-22'),status='Draft',Aircraft__c=faa.id,EndDate=system.today(),Type__c='HAPP-MPP',Site_Name__c='SAP_CNT');       
        insert newcontract2;  
       TaskLogicScheduler p = new TaskLogicScheduler(); //Schedule apex class name
       String sch = '0 0 * * * ?'; //schedule interval time
       system.schedule('One Time Pro', sch, p); //system method to schedule apex class*/
    }
}