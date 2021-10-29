@isTest
public class APTS_CreditMemoApprove_Test {
    
    @isTest
    public static void testApprove()
    {
        List <Apttus_Billing__CreditMemo__c> creditMemoList = new List<Apttus_Billing__CreditMemo__c>();
        
        
        Account account = new Account();
        account.Apttus_Config2__DefaultCreditMemoTemplate__c='FE Credit Memo 4000 (EUR)';
        account.name = 'test';
        insert account;
        //
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        creditMemo.Apttus_Billing__Status__c= 'Draft';
        creditMemo.APTS_Integration_Method__c = 'Simulate Order';
        creditMemo.APTS_Integration_Requested__c = Datetime.now();
        creditMemo.Apttus_Billing__PaymentStatus__c='';
        creditMemoList.add(creditMemo);
        
        insert creditMemoList;
        
        creditMemo.APTS_Integration_Status__c = 'Requested'; 
        creditMemo.Apttus_Billing__Status__c= 'Draft';                              
        update creditMemo;
        
        creditMemo.APTS_Integration_Status__c = 'Completed'; 
        creditMemo.Apttus_Billing__Status__c='Approved';
                               
        update creditMemo;
    }
      @isTest
    public static void testApprove1()
    {
        List <Apttus_Billing__CreditMemo__c> creditMemoList = new List<Apttus_Billing__CreditMemo__c>();
        
        
        Account account = new Account();
        account.Apttus_Config2__DefaultCreditMemoTemplate__c='FE Credit Memo 4000 (EUR)';
        account.name = 'test';
        insert account;
        //
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        creditMemo.Apttus_Billing__CreditAmount__c = 10.0;
        creditMemo.Apttus_Billing__BillToAccountId__c = account.Id;
        creditMemo.Apttus_Billing__Status__c= 'Draft';
        creditMemo.APTS_Integration_Method__c = 'Simulate Order';
        creditMemo.APTS_Integration_Requested__c = Datetime.now();
        creditMemo.Apttus_Billing__PaymentStatus__c='';
        creditMemoList.add(creditMemo);
        
        insert creditMemoList;
        
        creditMemo.APTS_Integration_Status__c = 'Requested'; 
                                      
        update creditMemo;
        
        creditMemo.APTS_Integration_Status__c = 'Completed'; 
        creditMemo.Apttus_Billing__Status__c= 'Draft';
                               
        update creditMemo;
    }
  
    }