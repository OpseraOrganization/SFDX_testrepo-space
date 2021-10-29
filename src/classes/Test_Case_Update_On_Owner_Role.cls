@isTest(SeeAllData=true)
public class Test_Case_Update_On_Owner_Role{
    public static Testmethod void Test_Case_Update_On_Owner_Role(){

        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id,
            Phone_3__c = '987654321',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Test',
            Employee_Number__c = 'H287751',
            Honeywell_ID__c = 'E12345',
            EMAIL = 'test@honeywell.com'
        );
        insert cont;
        
        RecordType c1 = [select id from recordtype where name='Repair & Overhaul' and sobjecttype='case' limit 1];
        test.starttest();
        Case cases = new Case(
            AccountId = acc.Id,
            recordtypeid = c1.id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Email',
            //No_FCR_Reason__c = 'Not Trained', For Ticket INC000009687923
            Type = 'Order'
        );
        insert cases;
        cases.ownerid = label.R_O_Toulouse_Order_Entry_Queue_ID;
        update cases;
        test.stoptest();
    }
}