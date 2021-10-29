@isTest
public class OrdersListPageController_test
{
    static testMethod void OrdersListPageController_test()
    {
        Account a = new Account(
                Name = 'testacc',
                Customer_Status__c = 'ACTIVE'
            );
        insert a;
        
        Contact c = new Contact(
                AccountId = a.Id,
                LastName = 'testCon',
                contact_status__c = 'ACTIVE',
                Contact_Is_Employee__c = false   
            );
        insert c;
        
        portal_honeywell_id__c ph = new portal_honeywell_id__c(
                contact__c = c.Id,
                user_type__c = 'NONCSR',
                primary_honeywell_id__c = true,
                Name = 'testId'
            );
        insert ph;
        
        contact_tool_access__c cta = new contact_tool_access__c(
                Name = 'Order Status',
                crm_contact_id__c = c.Id,
                request_status__c = 'Approved',
                Portal_Honeywell_ID__c = '12548'
            );
        insert cta;
        
        account_contact__c ac = new account_contact__c(
                contact__c = c.Id,
                account_name__c = a.Id
            );
        insert ac;
        
        account_cross_ref__c acr = new account_cross_ref__c(
                account_name__c = a.Id,
                XREF_Type__c = 'SAP_SOLD_TO',
                external_account_id__c = '01-02-01-02',
                Site_Code__c = '12546'
            );
        insert acr;
        
        OrdersListPageController.testClassBool = true;
        OrdersListPageController.SendRequest('testId', 'Open');
        OrdersListPageController controller = new OrdersListPageController();
        //controller.sendRequest1();
        OrdersListPageController.testClassBool = false;
        OrdersListPageController.SendRequest('testId', 'Shipped');
        
        OrdersListPageController.orderclass2 oc = new OrdersListPageController.orderclass2();
        oc.orderNO = '12425';
        oc.orderDATE = '12/12/2017';
        oc.plant = '1332';
        oc.estShipDATE = '01/01/2018';
        
    }
}