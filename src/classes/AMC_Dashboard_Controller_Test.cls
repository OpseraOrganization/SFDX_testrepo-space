@isTest
public class AMC_Dashboard_Controller_Test{
    List<Service_Request__c> ser = new List<Service_Request__c>();
    static testMethod void myUnitTest() 
    {
        test.starttest();
        Account acc= new Account(name='Test Account');
        insert acc;
        Contact c=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Email='test123@honeywell.com',Phone_3__c='12345678890',
                              Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='E146953', Employee_Contact_Role__c='E&T');
        insert c;
        Service_Request__c sr = new Service_Request__c();
        sr.AMC_Item__c='test';
        //sr.HON_Commit_Date__c=system.TODAY();
        sr.Customer_Due_Date__c=system.TODAY();
        sr.Problem_Description__c='test';
        sr.Contact_Name__c=c.id;
        //sr.Status_for_Ext_Cust__c='test';
        //sr.Status_for_Ext_Cust_Comment__c='test';
        sr.Subject__c='test';
        sr.Customer_Update__c='test';
        insert sr;
        
        AMC_Dashboard_Controller amc= new AMC_Dashboard_Controller();
        amc.getColor() ;
        amc.getSerRequest();
        test.stoptest();
    }
}