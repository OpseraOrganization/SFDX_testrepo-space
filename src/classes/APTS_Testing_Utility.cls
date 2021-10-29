@isTest ( seealldata = false )
public with sharing class APTS_Testing_Utility
{
    

    //  public methods listed in alphabetical order
    public static Account instantiateAccount ()
    {
        //  variables declared in alphabetical order
        Account account = new Account
        (   //  fields set in alphabetical order
            BillingCity            = 'Boulder'
        ,   BillingCountry         = 'United States'
        ,   BillingPostalCode      = '80302'
        ,   BillingState           = 'Texas'
        ,   BillingStreet          = '1600 Canyon Blvd'
        ,   Name                   = 'Test Account'
        ,Phone = '21212121'

        );

        return account;

    }   //  instantiateAccount ()

    public static Opportunity instantiateOpportunity
    ( Id accountId )
    {
        //  variables declared in alphabetical order
        Opportunity opportunity = new Opportunity
        (   //  fields set in alphabetical order
            AccountId      = accountId
        ,   Amount         = 1500.75
        ,   CloseDate      = Date.today ().addDays (45)
        ,   Description    = 'This is only a test.'
        ,   Name           = 'Test Opportunity'
        ,   StageName      = '4 - Selected'

        );

        return opportunity;

    }   //  instantiateOpportunity ()

    public static Apttus_Config2__PriceList__c instantiatePriceList ()
    {
        //  variables declared in alphabetical order
        Apttus_Config2__PriceList__c pricelist = new Apttus_Config2__PriceList__c
        (   //  fields set in alphabetical order
            Name = 'Test Price List USD'

        );

        return pricelist;

    }   //  instantiatePriceList ()

    public static Apttus_Proposal__Proposal__c instantiateProposal
    ( Id accountId
    , Id pricelistId
    )
    {
        //  variables declared in alphabetical order
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c
        (   //  fields set in alphabetical order
            Apttus_QPConfig__PriceListId__c       = pricelistId
        ,   Apttus_Proposal__Account__c           = accountId
        ,   Apttus_Proposal__ExpectedStartDate__c = Date.today ().addDays (20)
        ,   Apttus_Proposal__Proposal_Name__c     = 'Test Proposal'
        

        );

        return proposal;

    }   //  instantiateProposal ()
    public static Product2 createProduct(String PRoductName, String pcode, String pfamily, String sConfigType, Boolean bHasAttributes, Boolean bHasOptions, String CallbackApply) {
        Product2 productSO = new Product2();
        productSO.Name = ProductName;
        productSO.Family = pfamily;
        productSO.ProductCode = pcode;
        productSO.IsActive = true;
        productSO.Apttus_Config2__ConfigurationType__c = sConfigType;
        productSO.Apttus_Config2__HasAttributes__c = bHasAttributes;
        productSO.Apttus_Config2__HasOptions__c = bHasOptions;
        ProductSO.APTS_CallbackApply__c = CallbackApply;
        return productSO;
    }
    
    public static Apttus_Config2__PriceListItem__c createPriceListItem(Id PriceListId, Id ProductId, String sChargeType, String sPriceType, String sPriceMethod, Decimal dListPrice, String sFrequency, String sPriceUOM, String sBillingFreq, String sBillingRule, String sProvisioningType) {

        Apttus_Config2__PriceListItem__c priceListItem = new Apttus_Config2__PriceListItem__c();
        priceListItem.Apttus_Config2__PriceListId__c = PriceListId;     
        priceListItem.Apttus_Config2__ProductId__c = ProductId;
        priceListItem.Apttus_Config2__ChargeType__c = sChargeType;
        priceListItem.Apttus_Config2__PriceType__c = sPriceType;
        priceListItem.Apttus_Config2__PriceMethod__c = sPriceMethod;
        priceListItem.Apttus_Config2__ListPrice__c = dListPrice;
        priceListItem.Apttus_Config2__EffectiveDate__c = Date.today().addDays(-100);
        priceListItem.Apttus_Config2__ExpirationDate__c = Date.today().addDays(365);
        priceListItem.Apttus_Config2__Frequency__c = sFrequency;
        priceListItem.Apttus_Config2__PriceUom__c = sPriceUOM;
        priceListItem.Apttus_Config2__Active__c = true;
        priceListItem.Apttus_Config2__BillingFrequency__c = sBillingFreq;
        priceListItem.Apttus_Config2__BillingRule__c = sBillingRule;
        return priceListItem;
    }

     public static Apttus_Config2__ProductConfiguration__c createTestProductConfig(Apttus_Proposal__Proposal__c proposal, Account acc,Apttus_Config2__PriceList__c price) {
        
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c();
        config.Name = 'Product Config - 1 posting';
        config.Apttus_Config2__VersionNumber__c = 1;
        config.Apttus_Config2__SummaryGroupType__c = 'Category';
        config.Apttus_Config2__Status__c = 'New';
        config.Apttus_QPConfig__Proposald__c = proposal.Id;
        config.Apttus_Config2__BusinessObjectId__c = string.valueof(proposal.Id);
        config.Apttus_Config2__BusinessObjectType__c = 'Proposal';
        config.Apttus_Config2__AccountId__c = acc.id;
        config.Apttus_Config2__EffectivePriceListId__c = price.Id;
        config.Apttus_Config2__PriceListId__c = price.id;
        config.Apttus_Config2__ExpectedStartDate__c = (System.now()).date();
        config.Apttus_Config2__ExpectedEndDate__c = (System.now()).date().addDays(30);
        config.Apttus_Config2__IsTransient__c = true;
        return config;
    }
    public static Apttus_Config2__LineItem__c createLineItem(Apttus_Config2__ProductConfiguration__c ProdConfig, Id PriceListItemId, Id LocationId, Id ProductId, Id OptionId, Id AssetLineItemId, Decimal dPrimaryLineNo, Decimal dLineNumber, Decimal dItemSequence, String sLineType, Id BillPreferenceId, String sBillFrequency, String sBillingRule, String sPriceType, String sPriceMethod, String sPriceUOM, Decimal dBasePrice){

        Apttus_Config2__LineItem__c oLineItem = new Apttus_Config2__LineItem__c();
        oLineItem.Apttus_Config2__ConfigurationId__c = ProdConfig.Id;
        oLineItem.Apttus_Config2__BillToAccountId__c = ProdConfig.Apttus_Config2__BillToAccountId__c;
        oLineItem.Apttus_Config2__ShipToAccountId__c = ProdConfig.Apttus_Config2__ShipToAccountId__c;
        oLineItem.Apttus_Config2__PriceListId__c = ProdConfig.Apttus_Config2__PriceListId__c;
        oLineItem.Apttus_Config2__PriceListItemId__c = PriceListItemId;
        oLineItem.Apttus_Config2__LocationId__c = LocationId;
        oLineItem.Apttus_Config2__ProductId__c = ProductId;
        oLineItem.Apttus_Config2__OptionId__c = OptionId;
        oLineItem.Apttus_Config2__AssetLineItemId__c = AssetLineItemId;
        oLineItem.Apttus_Config2__PrimaryLineNumber__c = dPrimaryLineNo;
        oLineItem.Apttus_Config2__LineNumber__c = dLineNumber;
        oLineItem.Apttus_Config2__ItemSequence__c = dItemSequence;
        oLineItem.Apttus_Config2__LineType__c = sLineType;
        oLineItem.Apttus_Config2__StartDate__c = ProdConfig.Apttus_Config2__ExpectedStartDate__c;
        oLineItem.Apttus_Config2__EndDate__c = ProdConfig.Apttus_Config2__ExpectedEndDate__c;
        oLineItem.Apttus_Config2__BillingPreferenceId__c = BillPreferenceId;
        oLineItem.Apttus_Config2__BillingFrequency__c = sBillFrequency;
        oLineItem.Apttus_Config2__BillingRule__c = sBillingRule;
        oLineItem.Apttus_Config2__PriceType__c = sPriceType;
        oLineItem.Apttus_Config2__PriceMethod__c = sPriceMethod;
        oLineItem.Apttus_Config2__PriceUom__c = sPriceUOM;
        oLineItem.Apttus_Config2__BasePrice__c = dBasePrice;
        oLineItem.Apttus_Config2__NetPrice__c = dBasePrice;
        oLineItem.Apttus_Config2__SellingTerm__c = 1;
        return oLineItem;
    }
    
}