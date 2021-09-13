@isTest
public class DealProductHelperTest{
   static testMethod void DealProductTestMethod(){
	   Test.startTest(); 
	   List<Lead> ld1 = new List<Lead>();
	   ld1 = TestDataFactory.createLead(1);
	   ld1[0].Country = 'India';
	   insert ld1;
	   List<DealProduct__c> productlist = new List<DealProduct__c>();
	   DealProduct__c dd = new DealProduct__c();
	   dd.Deal__c =  ld1[0].id;
	   dd.Value__c = 800;
	   productlist.add(dd);
	   DealProduct__c dd1 = new DealProduct__c();
	   dd1.Deal__c =  ld1[0].id;
	   dd1.Value__c = 100;
	   productlist.add(dd1);
	   insert productlist;
	   Delete productlist;
	   Test.stopTest();	 
   }
}