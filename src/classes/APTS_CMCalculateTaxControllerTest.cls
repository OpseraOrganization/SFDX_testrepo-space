@isTest
public class APTS_CMCalculateTaxControllerTest {
    
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
        APTS_CMCalculateTaxController controller = new APTS_CMCalculateTaxController(standardController); 
        String nextPage = controller.doCalculateTax().getUrl();        
    }
}