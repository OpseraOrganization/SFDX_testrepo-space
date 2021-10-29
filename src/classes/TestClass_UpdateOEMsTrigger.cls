@isTest
private class TestClass_UpdateOEMsTrigger
{
    static testmethod void  TestClass_UpdateOEMsTrigger()
    {
        Account acc = New Account(
            Name= 'sbuaccount'
                  );
        insert acc;
        
        Contact cont=new Contact(
            firstname='Test',
            LastName='Contactfor upd',
            AccountId=acc.Id,
            Phone_3__c='9986502495',
            Contact_Is_Employee__c=true,
            Contact_Status__c='Active' ,
            Employee_Number__c='E157567',
            Employee_Contact_Role__c='Administrator'
        );
        insert cont;
        
        Service_Request__c serreq = new Service_Request__c(
            Subject__c='test ser',
            SR_Type__c='Field Event',
            Priority__c='AOG',
            status__c='Open',
            Problem_Description_new__c='hgcdatrd',
            Deliverable__c='htfrd',
            Risk_Assessment__c='Red',
            Contact_Name__c=cont.id,
            Customer_Reason_Change__c='Original',
            Atr__c='Value',
            Attribute_Details__c='Allocation Priority',
            Complexity_Level__c='1-Part Price/Availability'
            );
        insert serreq;
        
                
        //test.starttest();

        Key_Affected_OEMs_Operators__c KAOO = new Key_Affected_OEMs_Operators__c(
            Service_Request__c = serreq.id,
            Account_Name__c = acc.id,
        OEM_Operator__c = 'OEM'
        );
        insert KAOO;  
        update serreq;
      //  test.stoptest();     
    }
}