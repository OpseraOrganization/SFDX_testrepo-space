@isTest
public class TestDataFactory {
    
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
    
    public static Account createAccount(){
        Account account = new Account(
            Name = 'Test Account'+TestDataFactory.generateRandomString(3),
            Industry = 'Accounting',
            BillingCity = 'Test City',
            BillingCountry = 'US',
            BillingState = 'CA',
            BillingStreet = 'Test Street',
            BillingPostalCode = '80220'
        );
        insert account;
        return account;
    }
    
    public static APTS_Account_Group__c createAccountGroup(){
        APTS_Account_Group__c accountGroup = new APTS_Account_Group__c(
            Name = 'Test Account Group'+TestDataFactory.generateRandomString(3)
        );
        insert accountGroup;
        return accountGroup;
    }
    
    public static Product2 createProduct(){
        Product2 product = new Product2(
            Name = 'Test Product'+TestDataFactory.generateRandomString(3)
        );
        insert product;
        return product;
    }
    
    public static Product2 createProductWithISVTrue(){
        Product2 product = new Product2(
            Name = 'Test Product'+TestDataFactory.generateRandomString(3),
            APTS_ISV_Impact__c = true
        );
        insert product;
        return product;
    }
    
    public static Pricebook2 createPriceBook () {
        Pricebook2 testPB = new Pricebook2(Name='Standard Price Book', isActive=true);
        insert testPB;
        return testPB;
    }
    
    public static Opportunity createOpportunity(){
        Account account = TestDataFactory.createAccount();
        Pricebook2 testPB = TestDataFactory.createPriceBook();
        Opportunity opportunity = new Opportunity(
            Name='Test Opportunity',
            Account = account,
            AccountId=account.Id,
            StageName='Order Complete',
            PriceBook2 = testPB,
            CloseDate = System.today()
        );
        insert opportunity;
        return opportunity;
    }
    
    public static Apttus_Proposal__Proposal__c createProposal(){
        Opportunity opportunity = TestDataFactory.createOpportunity();
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Opportunity__c=opportunity.id
        );
        insert proposal;
        return proposal;
    }
    
    public static Apttus_Config2__ProductConfiguration__c createConfiguration() {
        Apttus_Proposal__Proposal__c proposal = testDataFactory.createProposal();
        Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c (
            Apttus_QPConfig__Proposald__c = proposal.id,
            Apttus_Config2__BusinessObjectType__c = 'Test',
            Name = 'Test Cart'
        );
        insert cart;
        return cart;
    }
    
    public static Apttus_Config2__LineItem__c createConfigLineItem() {
        Product2 product = TestDataFactory.createProduct();
        Apttus_Config2__ProductConfiguration__c configuration = TestDataFactory.createConfiguration();
        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
            CurrencyIsoCode = 'USD',
            Apttus_Config2__ProductId__c = product.id,
            Apttus_Config2__ConfigurationId__c = configuration.id,
            Apttus_Config2__Description__c = 'TEST Line Item'+TestDataFactory.generateRandomString(3),
            Apttus_Config2__NetPrice__c = 100,
            Apttus_Config2__BasePrice__c = 200,
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert lineItem;
        return lineItem;
    }
    
    public static Apttus_Config2__LineItem__c createConfigLineItemWithISVTrue() {
        Product2 product = TestDataFactory.createProductWithISVTrue();
        Apttus_Config2__ProductConfiguration__c configuration = TestDataFactory.createConfiguration();
        Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
            CurrencyIsoCode = 'USD',
            Apttus_Config2__ProductId__c = product.id,
            Apttus_Config2__ConfigurationId__c = configuration.id,
            Apttus_Config2__Description__c = 'TEST Line Item'+TestDataFactory.generateRandomString(3),
            Apttus_Config2__NetPrice__c = 100,
            Apttus_Config2__BasePrice__c = 200,
            Apttus_Config2__ItemSequence__c = 1,
            Apttus_Config2__LineNumber__c = 1
        );
        insert lineItem;
        return lineItem;
    }
    
    
    
    public static APTS_Account_Group_Member__c createAccountGroupMember(){
        Account account = TestDataFactory.createAccount();
        APTS_Account_Group__c accountGroup = TestDataFactory.createAccountGroup();
        APTS_Account_Group_Member__c accountGroupMember = new APTS_Account_Group_Member__c(
            APTS_Account_Group__c = accountGroup.id,
            APTS_Account__c = account.id
        );
        insert accountGroupMember;
        return accountGroupMember;
    }
    
    public static Apttus_Billing__CreditMemo__c createCreditMemo(){
        Account account = TestDataFactory.createAccount();
        Apttus_Billing__CreditMemo__c creditMemo = new Apttus_Billing__CreditMemo__c(
            Apttus_Billing__Status__c = 'Draft',
            Apttus_Billing__BillToAccountId__c = account.Id,
            Apttus_Billing__CreditAmount__c = 2.5
        );
        insert creditMemo;
        return creditMemo;
    }
    //RAPD-7779 
    public static Channel_Partner_Nomination__c CreateCPN(ID AccId){
        string GlobalChannelCommittee = '';
        string EnginesABM = '';
        Schema.DescribeFieldResult fieldResult = Channel_Partner_Nomination__c.Global_Channel_Committee__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            GlobalChannelCommittee = pickListVal.getvalue();
            break;
        }
        
        fieldResult = Channel_Partner_Nomination__c.Engines_Aftermarket_Business_Manager__c.getDescribe();
        
        ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            EnginesABM = pickListVal.getvalue();
            break;
        }
        Channel_Partner_Nomination__c CPN = new Channel_Partner_Nomination__c(
            Account__c=AccId,
            Type_of_Agreement__c = 'Authorized Direct Reseller (ADR)',
            Global_Channel_Committee__c = GlobalChannelCommittee,
            Engines_Aftermarket_Business_Manager__c = EnginesABM
        );
        insert CPN;
        return CPN;
        //Global_Channel_Committee_look_up__c = userinfo.getUserId(),
    }
    public static ContentVersion CreateContentVersion(Id ContDocId){
        Blob fileContent=Blob.valueOf('Test File Content');
        ContentVersion CV = new ContentVersion();
        CV.title = 'TestTitle';
        if(ContDocId!=null){
            CV.contentDocumentId = ContDocId;
        }
        CV.VersionData =fileContent;
        CV.PathOnClient = 'test';
        insert CV;
        return CV;
    }
    public static ContentDocumentLink CreateContentDocumentLink(ID objId,Id ContentDocId){
        ContentDocumentLink contentdoclink=new ContentDocumentLink();
        contentdoclink.LinkedEntityId=objId;  
        contentdoclink.ContentDocumentId=ContentDocId;
        insert contentdoclink;  
        return contentdoclink;
    }
    //RAPD-7779
}