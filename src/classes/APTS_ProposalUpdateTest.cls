@isTest
public class APTS_ProposalUpdateTest {
    public static testMethod void testUpdate() {
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        priceList.CurrencyIsoCode = 'EUR';
        insert priceList;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        insert proposal;
        proposal.Apttus_QPConfig__PriceListId__c = priceList.Id;
        update proposal;
        
        Apttus_Proposal__Proposal__c[] proposals = [Select Id, APTS_Price_List_Currecy__c, CurrencyIsoCode From Apttus_Proposal__Proposal__c Where Id = :proposal.Id];
        
        System.assertEquals('EUR', proposals[0].APTS_Price_List_Currecy__c);
        System.assertEquals(proposals[0].APTS_Price_List_Currecy__c, proposals[0].CurrencyIsoCode);
    }
    
    public static testMethod void testProposalPaymentTerm() {
        
        Apttus_Config2__PaymentTerm__c paymentTerm = new Apttus_Config2__PaymentTerm__c(
            Apttus_Config2__Sequence__c = 1
        );
        insert paymentTerm;
        
        Apttus_Proposal__Proposal__c proposal = TestDataFactory.createProposal();
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_Proposal__Proposal__c = proposal.id
        );
        insert proposalLineItem;
        
        proposal.Apttus_Proposal__Approval_Stage__c = 'Accepted';
        proposal.APTS_SimulateOrderStatus__c = 'Completed';
        proposal.Apttus_QPConfig__PaymentTermId__c = paymentTerm.id;
        update proposal;
        
        proposalLineItem = [select Id, Apttus_QPConfig__PaymentTermId__c from Apttus_Proposal__Proposal_Line_Item__c where Id =:proposalLineItem.id];
        System.assertEquals(paymentTerm.id, proposalLineItem.Apttus_QPConfig__PaymentTermId__c);
    }
    
    
    public static testMethod void testAccountPaymentTerm() {
        
        Apttus_Config2__PaymentTerm__c paymentTerm = new Apttus_Config2__PaymentTerm__c(
            Apttus_Config2__Sequence__c = 1
        );
        insert paymentTerm;
        
        Apttus_Proposal__Proposal__c proposal = TestDataFactory.createProposal();
        
        Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_Proposal__Proposal__c = proposal.id
        );
        insert proposalLineItem;
        
        Account account = TestDataFactory.createAccount();
        account.Apttus_Config2__PaymentTermId__c = paymentTerm.id;
        update account;
        
        
        proposal.Apttus_Proposal__Account__c = account.id;
        proposal.Apttus_QPConfig__PaymentTermId__c = null;
        update proposal;
        
             
        proposal.Apttus_Proposal__Approval_Stage__c = 'Accepted';
        proposal.APTS_SimulateOrderStatus__c = 'Completed';
        update proposal;
        
                 
        proposalLineItem = [select Id, Apttus_QPConfig__PaymentTermId__c from Apttus_Proposal__Proposal_Line_Item__c where Id =:proposalLineItem.id];
        System.assertEquals(paymentTerm.id, proposalLineItem.Apttus_QPConfig__PaymentTermId__c);
    }
    public static testMethod void Populatepredefinefields() {
         Apttus_Config2__PaymentTerm__c paymentTerm = new Apttus_Config2__PaymentTerm__c(
            Apttus_Config2__Sequence__c = 1
        );
        insert paymentTerm;
        Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
        priceList.CurrencyIsoCode = 'EUR';
        insert priceList;
        Apttus_Config2__BillingPreference__c Billingpreference = New Apttus_Config2__BillingPreference__c();
        Billingpreference.Name ='TestBillingpreference';
        Insert Billingpreference;
        
        Account account = TestDataFactory.createAccount();
        account.Apttus_Config2__PaymentTermId__c = paymentTerm.id;
        account.APTS_Price_List__c = priceList.id;
        account.Apttus_Config2__BillingPreferenceId__c = Billingpreference.id;
        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        proposal.Apttus_Proposal__Account__c = account.id;
        insert proposal;
        
        
        proposal.Apttus_QPConfig__PriceListId__c =account.APTS_Price_List__c;
        proposal.Apttus_QPConfig__PaymentTermId__c =account.Apttus_Config2__PaymentTermId__c;
        proposal.Apttus_QPConfig__BillingPreferenceId__c =account.Apttus_Config2__BillingPreferenceId__c;
        update proposal;

    }    
       
}