@isTest
private class PrimaryPart_FieldEventsTest{
static testMethod void myUnitTest(){
        date testdate = System.today();
        Product2 prod=new Product2();
        prod.name='Test Product';
        prod.description='Test Product Description';
        insert prod;
        
        Account acc= new Account(name='Test Account');
        insert acc;

        Contact cont=new Contact(
            Firstname='Test',
            LastName='Contact Inactive',
            AccountId=acc.Id,
            Phone_3__c='9986502456',
            Contact_Is_Employee__c=true,
            Contact_Status__c='Active',
            Employee_Number__c='E734143',
            Employee_Contact_Role__c='Administrator'
        );
        insert cont;
         
        Field_Event__c fe = new Field_Event__c();
        fe.Report_Type__c = 'APU';
        fe.Report_Date__c = testdate;
        fe.Event_Date__c = System.now(); //Date time
        fe.Product_Type__c = 'Bendix-King';
        fe.Catalog_Product_Group__c = 'Displays(BK)';
        fe.Supported_Product__c = 'Displays';
        fe.Product_Model__c = '131-9A';
        fe.Engine_APU_Reported_S_N__c = '12345';
        fe.Aircraft_Type__c = [SELECT Id FROM Platform__c where Active__c = true limit 1].Id;
        fe.Operational_Symptom__c = 'A/C Delivery';
        fe.Effect_on_Operation__c = 'Air Turnback';
        fe.IFSD_ETOPS__c = 'YES';
        fe.Shutdown_Details__c = 'Ground';
        fe.Engine_Removal__c = 'YES';
        fe.Contact__c = cont.id;
        
        insert fe;
        
        Parts__c part1=new Parts__c();
        part1.Component_Installed_Part_Number__c='12345';
        part1.Component_Installed_Serial_Number__c='98765';
        part1.Component_Reason_for_Removal__c='Test Part reason for removal';
        part1.Component_Removed_Cycles__c=10;
        part1.Component_Removed_Hrs__c=9;
        part1.Component_Removed_Serial_Number__c='98765';
        part1.Product_Name__c=prod.id;
        part1.Primary_Part__c=true;
        part1.Field_Event__c=fe.id;
        insert part1;
        
        part1.Primary_Part__c=false;
        update part1;
        
        part1.Primary_Part__c=true;
        update part1;
        
        delete part1;
        
    }
}