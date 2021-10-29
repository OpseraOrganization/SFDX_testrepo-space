@isTest(SeeAllData=false)
public class APTS_InvoiceApproveTest {
    @isTest
    public static void testApprove(){
        
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft',
            APTS_Integration_Status__c='Requested'
        );
        insert invoice;
        
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            APTS_External_Id__c = '123',
            APTS_External_Source__c = 'JIRA'
        );
        insert assetLineItem;
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
            Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__AssetLineItemId__c  = assetLineItem.id
        );
        insert invoiceLineItem;
        
        invoice.Apttus_Billing__Status__c = 'Approved';
        invoice.APTS_Integration_Status__c='Completed';
        update invoice;
        
        invoice = [select id, APTS_JIRA_Transaction_Date__c from Apttus_Billing__Invoice__c where Id = :invoice.id];
        
        System.assertEquals(invoice.APTS_JIRA_Transaction_Date__c==null, false);
    }
}