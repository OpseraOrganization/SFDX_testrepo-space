public class APIGEE_TestDataUtility {
    
    public static Account createAccount(){
        Account testAccount = New Account();
        testAccount.Name = 'Test Account';
        return testAccount;
    }
    
    public static Apttus_Proposal__Proposal__c createProposal(){
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.Apttus_Proposal__Proposal_Name__c = 'Test Proposal';
        proposal.RecordTypeId =  Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
        return proposal;
    }
    
    public static Apttus_Proposal__Proposal_Line_Item__c createProposalLineItem(Id proposalId){
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c();
        proposalLineItem.Apttus_Proposal__Proposal__c = proposalId;
        proposalLineItem.Apttus_Proposal__Description__c = 'To be Processed';
        proposalLineItem.Apttus_QPConfig__ExtendedDescription__c = 'Processed';
        return proposalLineItem;
    }
    
    public static Apttus_QPConfig__ProposalTaxBreakup__c createProposalTaxBreakup(Id proposalLineItemId){
        Apttus_QPConfig__ProposalTaxBreakup__c proposalTaxBreakup = new Apttus_QPConfig__ProposalTaxBreakup__c();
        proposalTaxBreakup.Apttus_QPConfig__LineItemId__c = proposalLineItemId;
        proposalTaxBreakup.Apttus_QPConfig__Sequence__c = 1;
        proposalTaxBreakup.Apttus_QPConfig__TaxAmount__c = 100;
        return proposalTaxBreakup;
    }
    
    public static Apttus_Billing__Invoice__c createInvoice(){
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c();
        invoice.Apttus_Billing__Type__c = 'Standard';
        invoice.Apttus_Billing__DeliveryStatus__c = 'Pending';
        invoice.APTS_Invoice_Description__c = 'Test Description';
        return invoice;
    }
    public static Apttus_Billing__InvoiceLineItem__c createInvoiceLineItem(Id invoiceId){
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c();
        invoiceLineItem.Apttus_Billing__InvoiceId__c = invoiceId;
        
        return invoiceLineItem;
    }
    
    public static Apttus_Billing__InvoiceLineItemTaxBreakup__c createInvoiceTaxBreakup(Id invoiceLineItemId){
        Apttus_Billing__InvoiceLineItemTaxBreakup__c invoiceTaxBreakup = new Apttus_Billing__InvoiceLineItemTaxBreakup__c();
        invoiceTaxBreakup.Apttus_Billing__InvoiceLineItemId__c = invoiceLineItemId;
        invoiceTaxBreakup.Apttus_Billing__Sequence__c = 1;
        invoiceTaxBreakup.Apttus_Billing__TaxAmount__c = 1;
        invoiceTaxBreakup.Apttus_Billing__TaxRate__c = 4;
        return invoiceTaxBreakup;
    }
    
    public static Apttus_Billing__CreditMemo__c createCreditMemo(Id accId){
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c();
        creditMemo.Apttus_Billing__BillToAccountId__c=accId;
        creditMemo.Apttus_Billing__CreditAmount__c=5000;
        creditMemo.APTS_Integration_Status__c='Completed';
        creditMemo.APTS_CMR_Number__c='1234';
        creditMemo.APTS_CMR_Status__c='Sucess';
        creditMemo.APTS_Billing_Document_Number__c='123456';
        creditMemo.Apttus_Billing__TotalTaxAmount__c=40000;
        creditMemo.APTS_Integration_Result__c   ='qwertyuiop';
        creditMemo.Apttus_Billing__CreditAmount__c= 123345677;     
        creditMemo.Apttus_Billing__TotalCreditAmount__c=12345678;
        creditMemo.Apttus_Billing__Status__c='Draft';
        creditMemo.Apttus_Billing__PaymentStatus__c  ='Uncredited';
        return creditMemo;
    }
    
    public static Apttus_Billing__CreditMemoLineItem__c createCreditMemoLineItem(Id creditMemoId){
        Apttus_Billing__CreditMemoLineItem__c creditMemoLineItem = new Apttus_Billing__CreditMemoLineItem__c();
        creditMemoLineItem.Apttus_Billing__CreditMemoId__c = creditMemoId;
        creditMemoLineItem.Apttus_Billing__Amount__c = 100;
        creditMemoLineItem.Apttus_Billing__TaxAmount__c = 100;
        creditMemoLineItem.Apttus_Billing__TaxAmount__c = 10;
        return creditMemoLineItem;
    }
    
    public static Apttus_Billing__CreditMemoLineItemTaxBreakup__c createCreditMemoTaxBreakup(Id creditMemoLineItemId){
        Apttus_Billing__CreditMemoLineItemTaxBreakup__c creditMemoTaxBreakup = new Apttus_Billing__CreditMemoLineItemTaxBreakup__c();
        creditMemoTaxBreakup.Apttus_Billing__CreditMemoLineItemId__c = creditMemoLineItemId;
        creditMemoTaxBreakup.Apttus_Billing__Sequence__c = 1;
        creditMemoTaxBreakup.Apttus_Billing__TaxAmount__c = 100;
        creditMemoTaxBreakup.Apttus_Billing__TaxRate__c = 10;
        return creditMemoTaxBreakup;
    }
    
    public Static Product2 createProduct(){
        Product2 product = new Product2();
        product.Name = 'Test Product';
        product.ProductCode = 'TestProductCode';
        return product;
    }
    
    public static Attachment createAttachment(Id parentId){
        Attachment attach = new Attachment();
        attach.Body = Blob.valueOf('Test');
        attach.ParentId = parentId;
        attach.Name = 'Test Attachment';
        return attach;
    }
    
    public static APTS_PDF_Attachment_Status__c createAttachmentIntStatus(Id attachmentId){
        APTS_PDF_Attachment_Status__c attachmentStatus = new APTS_PDF_Attachment_Status__c();
        attachmentStatus.APTS_Attachment_Id__c = attachmentId;
        return attachmentStatus;
    }
    
    public static APTS_MuleSoft_PL_Mapping__c createPlMapping(){
        APTS_MuleSoft_PL_Mapping__c plMapping = new APTS_MuleSoft_PL_Mapping__c();
        plMapping.CurrencyIsoCode = 'USD';
        plMapping.Name = 'Test Pl Mapping';
        return plMapping;
    }
    
    public static APTS_Middleware_Account_Mapping__c createAccountMapping(Id accId){
        APTS_Middleware_Account_Mapping__c accountMapping = new APTS_Middleware_Account_Mapping__c();
        accountMapping.CurrencyIsoCode = 'USD';
        accountMapping.Account__c = accId;
        accountMapping.Source__c='JIRA';
        accountMapping.Integration_Code__c = 'TESTCODE';
        accountMapping.Middleware__c = 'MuleSoft';
        return accountMapping;
    }
    
    public static APTSJIRA_Integration__c createjiraIntegration(){
        APTSJIRA_Integration__c jiraIntegration = new APTSJIRA_Integration__c();
        jiraIntegration.Name = 'Test integration';
        jiraIntegration.Product_Code_DEV__c = 'Test PDevCode';
        jiraIntegration.Product_Code_SUP__c = 'Test PSupCode';
        jiraIntegration.Product_Code_SUPFREE__c = 'Test PSupFreeCode';
        return jiraIntegration;
    }
}