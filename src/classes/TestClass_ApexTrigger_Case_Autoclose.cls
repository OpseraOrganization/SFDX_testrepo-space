/** * File Name:  TestClass_ApexTrigger_Case_Autoclose 
* Description : Test Method for Case_Autoclose
* Trigger Tested: Case_Autoclose
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
@isTest
private class TestClass_ApexTrigger_Case_Autoclose {

    static testMethod void Case_AutocloseTest() {
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            Employee_Number__c = 'E147567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        
        test.starttest();
        Case cases = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email-GDC Accounts',
            //No_FCR_Reason__c = 'Not Trained',For Ticket INC000009687923
            Type = 'Order'
        );
        insert cases;
        test.stoptest();
    }
}