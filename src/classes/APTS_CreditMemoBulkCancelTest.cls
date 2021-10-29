@isTest
public class APTS_CreditMemoBulkCancelTest {
  @isTest
    public static void testSelect() {
        List <Apttus_Billing__CreditMemo__c> creditMemoList = new List<Apttus_Billing__CreditMemo__c>();
        
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        Account account = new Account();
        account.name = 'test';
        insert account;
        //
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        creditMemo.Apttus_Billing__Status__c='Draft';
        //
        creditMemoList.add(creditMemo);
        insert creditMemoList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(creditMemoList);
        sc.setSelected(creditMemoList);
        
        APTS_CreditMemoBulkCancel controller = new APTS_CreditMemoBulkCancel(sc);
        
        System.assertEquals(controller.getCandidateCreditMemoSize()>0, true);
    }
    
    @isTest
    public static void testCancel() {
        List <Apttus_Billing__CreditMemo__c> creditMemoList = new List<Apttus_Billing__CreditMemo__c>();
        
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        Account account = new Account();
        account.name = 'test';
        insert account;
        //
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        creditMemo.Apttus_Billing__Status__c='Draft';
        //
        creditMemoList.add(creditMemo);
        insert creditMemoList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(creditMemoList);
        sc.setSelected(creditMemoList);
     
        APTS_CreditMemoBulkCancel controller = new APTS_CreditMemoBulkCancel(sc);
        
        
        PageReference pageRef = Page.APTS_CreditMemoBulkCancel;
        pageRef.getParameters().put('retURL', 'test');
        Test.setCurrentPage(pageRef);
        
        controller.cancelCreditMemo();
        creditMemo = [Select Id, Name, Apttus_Billing__Status__c From Apttus_Billing__CreditMemo__c Where Id = :creditMemo.id];
        System.assertEquals(creditMemo.Apttus_Billing__Status__c=='Cancelled', true);
    }
    
    @isTest
    public static void testMeesageSelected() {
        List <Apttus_Billing__CreditMemo__c> creditMemoList = new List<Apttus_Billing__CreditMemo__c>();
        
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        Account account = new Account();
        account.name = 'test';
        insert account;
        //
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        creditMemo.Apttus_Billing__Status__c='Draft';
        //
        creditMemoList.add(creditMemo);
        insert creditMemoList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(creditMemoList);
        sc.setSelected(creditMemoList);
     
        APTS_CreditMemoBulkCancel controller = new APTS_CreditMemoBulkCancel(sc);
        
        PageReference pageRef = Page.APTS_CreditMemoBulkCancel;
        pageRef.getParameters().put('retURL', 'test');
        Test.setCurrentPage(pageRef);
        
        controller.selectedCreditMemos();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        boolean check = false;
        for(Apexpages.Message msg : pageMessages){
            if (msg.getDetail().contains('Only CreditMemo(s) with a Status of Draft can be Cancelled!')) check = true;
        }
            System.assertEquals(check, true);
        }
    
    
    @isTest
    public static void testMeesageNotSelected() {
        List <Apttus_Billing__CreditMemo__c> creditMemoList = new List<Apttus_Billing__CreditMemo__c>();
        
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        Account account = new Account();
        account.name = 'test';
        insert account;
        //
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        creditMemo.Apttus_Billing__Status__c='Draft';
        //
        creditMemoList.add(creditMemo);
        insert creditMemoList;

        ApexPages.StandardSetController sc = new ApexPages.StandardSetController(creditMemoList);
     
        APTS_CreditMemoBulkCancel controller = new APTS_CreditMemoBulkCancel(sc);
        
        PageReference pageRef = Page.APTS_CreditMemoBulkCancel;
        pageRef.getParameters().put('retURL', 'test');
        Test.setCurrentPage(pageRef);
        
        controller.selectedCreditMemos();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        boolean check = false;
        for(Apexpages.Message msg : pageMessages){
            if (msg.getDetail().contains('Please select at least one credit memo to continue...')) check = true;
        }
            System.assertEquals(check, true);
        }
}