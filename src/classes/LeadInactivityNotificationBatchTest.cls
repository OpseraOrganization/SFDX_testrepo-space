@isTest
public class LeadInactivityNotificationBatchTest {
    
    @isTest
    public static void testLeadBatchMethod(){

        Lead l=new Lead();
        l.status='Inquiry';
        l.lead_owner_change__c='TRUE';
        l.lastName='Test';
        l.Company='Test Company';
        l.ATR_Product_Information__c='MSP';
        l.ownerId=label.aero_default_user_id;
        insert l;
        Test.startTest();
        LeadInactivityNotificationBatch batch=new LeadInactivityNotificationBatch();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Lead Notification', sch, batch); 
        database.executeBatch(new LeadInactivityNotificationBatch(),1);
        Test.stopTest();
        system.assertEquals(1, limits.getEmailInvocations());
    }
}