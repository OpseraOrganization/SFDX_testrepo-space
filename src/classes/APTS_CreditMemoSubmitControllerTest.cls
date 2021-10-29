@isTest
public class APTS_CreditMemoSubmitControllerTest {
    
    public static testMethod void testSubmitMemo() {
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        Account account = new Account();
        account.name = 'test';
        insert account;
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        insert creditMemo;
        
        Id creditMemoId = (Id)creditMemo.get('id');
        PageReference pageRef = new PageReference('/' + creditMemoId);
        Test.setCurrentPage(pageRef);
      
        ApexPages.StandardController standardController  = new ApexPages.StandardController(creditMemo);
            // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', creditMemoId);
        APTS_CreditMemoSubmitController controller = new APTS_CreditMemoSubmitController(standardController); 
        String nextPage = controller.doSubmitMemo().getUrl();

        // Verify that the success page displays
        System.assertEquals('/' + creditMemo.get('id'), nextPage);
        Apttus_Billing__CreditMemo__c[] creditMemos = [select id, Apttus_Billing__Status__c,  APTS_Integration_Method__c,
                                                              APTS_Integration_Result__c, APTS_Integration_Status__c
                                                       from Apttus_Billing__CreditMemo__c where id = :creditMemoId];
        System.debug(creditMemos[0]);
        System.assertEquals('Submitted', creditMemos[0].Apttus_Billing__Status__c);
        System.assertEquals('Credit Memo Request', creditMemos[0].APTS_Integration_Method__c);
        System.assertEquals(null, creditMemos[0].APTS_Integration_Result__c);
        //System.assertEquals(null, creditMemos[0].APTS_Integration_Status__c);
    }
}