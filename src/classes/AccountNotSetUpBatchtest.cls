@isTest/*(seeAllData = true)*/
public class AccountNotSetUpBatchtest{
public static list<Portal_User_Registration__c > lp=new list<Portal_User_Registration__c >();
 public static testmethod void testmethod1()
 {      
     Portal_User_Registration__c obj=new Portal_User_Registration__c();
     obj.Honeywell_ID__c='test1234';
     obj.EmailAddress__c='manish.das@honeywell.com';
     
     
    // obj.CurrencyIsoCode='EUR-Euro';
insert obj;
 obj.Created_Date__c=System.now()-30.5;
 obj.Initial_Reg__c = 'Y';
 obj.Create_HoneywellId__c ='N';
 
 update obj;
 
Test.startTest();
AccountNotSetUpBatch obj1=new AccountNotSetUpBatch();
Id batchjobid=Database.executeBatch(obj1);
Test.stopTest();

}


}