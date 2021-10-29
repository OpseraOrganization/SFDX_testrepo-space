/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_AddOppPdt
* Description           : Test Class to test the functionality of the trigger AddOpportunityProduct.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 06-Sep-2012      0.01           NTTData               Initial Version
***********************************************************************************************************/
@isTest
private class TestClass_AddOpportunityProduct_ATR
{

    private static RMU_VALUE__c rmuValueOne;
    private static Product2 productOne;
    private static Platform__c platformOne;
    private static Platform__c platformTwo;
    private static Product_Line_Cross_Ref__c productLineCrossRef;
    private static Opportunity opportunity;
    private static Pricebook2 pbook;
    private static PricebookEntry pbookEntry;
    private static User techSalesManager;
    private static Fleet_Asset_Detail__c fleetAssetDetail;
    private static Product_Line__c productLine;
    private static User u;
    private final static String BENDIXKING = 'BendixKing';
    private final static String BK_FLIGHT_CONTROLS = 'BK-Flight Controls';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private final static String NULL_POINTER_EXCEPTION = 'Attempt to de-reference a null object';
    
    static void init() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);
        System.runAs(u) {
            Account acct = new TestAccountBuilder()
                    .addField('Report_Country_Name__c', AMERICA)
                    .addField('Region_Name__c', AMERICAS)
                    .generate();
    
            opportunity = new TestOpportunityBuilder('Test', BENDIXKING)
                    .addField('AccountId', acct.Id)
                    .addField('SBU__c', 'BGA')
                    .addField('StageName', 'Closed Won')
                    .generate();
    
            Contact contact = new TestContactBuilder().addField('AccountId', acct.Id).generate();
    
            productOne = new TestProductBuilder('My Product One')
                    .generate();
    
            rmuValueOne = new TestRmuValueBuilder().generate();
    
            platformOne = new TestPlatformBuilder()
                    .setName('TestPlatformOne')
                    .setModel('36-16A')
                    .setMake('Various OEMS')
                    .setSAPExternalSystem(true)
                    .addField('Active__c', true)
                    .generate();
    
            platformTwo = new TestPlatformBuilder()
                    .setName('TestPlatformTwo')
                    .setModel('36-16A')
                    .setMake('Various OEMS')
                    .setSAPExternalSystem(true)
                    .addField('Active__c', true)
                    .generate();
    
            fleetAssetDetail = new TestFleetAssetDetailBuilder()
                    .setPlatform(platformOne.Id)
                    .generate();
    
            Platform_cross_ref__c platformCrossRef = new Platform_cross_ref__c();
            platformCrossRef.External_System_Name__c = 'FleetAnalyzer';
            platformCrossRef.Platform_Parent__c = platformOne.Id;
            insert platformCrossRef;
    
            Platform_cross_ref__c platformCrossRefTwo = new Platform_cross_ref__c();
            platformCrossRefTwo.External_System_Name__c = 'FleetAnalyzer';
            platformCrossRefTwo.Platform_Parent__c = platformTwo.Id;
            insert platformCrossRefTwo;
            productLine = new TestProductTypeBuilder()
            .addField('Name','TestName')
            .generate();
            pbook = new TestPricebookBuilder()
                    .generate();
            Pricebook2 pbook2 = new TestPricebookBuilder()
                    .generate();
            Product2 product = new TestProductBuilder()
                    .addField('CanUseRevenueSchedule', true)
                    .addField('Name','test opp')
                    .addField('Product_Line__c',productLine.id)
                    .generate();
            PricebookEntry standardPricebookEntry= new PriceBookEntry(
                    Pricebook2Id = System.Test.getStandardPricebookId(),
                    Product2Id = product.Id,
                    UnitPrice = 50
            );
            Database.insert(standardPricebookEntry);
            pbookEntry = new TestPricebookEntryBuilder()
                    .setPricebook(pbook.Id)
                    .setProduct(product.Id)
                    .generate();
            pbookEntry = new TestPricebookEntryBuilder()
                    .setPricebook(pbook2.Id)
                    .setProduct(product.Id)
                    .generate();
            
            productLineCrossRef = new TestProductLineCrossRefBuilder('TestName')
                    .setProductType(productLine.Id)
                    .setProductLeader(contact.Id)
                    .generate();
            techSalesManager = new TestUserBuilder().generate();
            System.Test.startTest();
            System.debug('M_PM_Product__c value @@@:'+productLineCrossRef.id);
            OpportunityLineItem lineItem = new TestOpportunityLineItemBuilder()
                .setOpportunityId(opportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .addField('Type__c', 'Booked')
                .addField('M_PM_Product__c',productLineCrossRef.id)
                .generate();
            
        }
    }
    
    static testMethod void Test_AddOppPdtMthd(){  
        init();

        PageReference pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        AddOpportunityProduct_ATR oppPdt2 = new AddOpportunityProduct_ATR(sc);
        oppPdt2.searchString='test opp';        
        oppPdt2.Editpage();
        //oppPdt.save();
        oppPdt2.updateAvailableList();
        oppPdt2.matchProduct();
        oppPdt2.onSave();
        oppPdt2.onSave1();
        oppPdt2.OnCancel();
        oppPdt2.changePricebook();
         
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        PageReference pageRef3 = Page.AddProduct_BGA;
        pageRef3.getParameters().put('id', String.valueOf(opportunity.Id)); 
        Test.setCurrentPage(pageRef3);
        AddProduct_BGA oppPdt3 = new AddProduct_BGA(sc);    
        oppPdt2.Editpage();
        //oppPdt.save();
        oppPdt2.updateAvailableList();
        oppPdt2.matchProduct();
        oppPdt2.onSave();
        oppPdt2.onSave1();
        oppPdt2.OnCancel();
        oppPdt2.changePricebook();
        sc = new ApexPages.StandardController(opportunity);
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        AddProduct_BGA oppPd3 = new AddProduct_BGA(sc);
        oppPd3.Editpage();
        
        oppPd3.updateAvailableList();
        oppPd3.matchProduct();
         System.Test.stopTest();
        oppPd3.onSave();
        oppPdt3.Editpage();
        oppPdt3.onSave1();
        oppPd3.onCancel();
        oppPd3.changePricebook();
       
        PageReference pageRef1 = Page.AddOpportunityProduct_ATR;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('Id', String.valueOf(opportunity.Id));
        ApexPages.StandardController sc1 = new ApexPages.StandardController(opportunity);
        AddOpportunityProduct_ATR aopatr = new AddOpportunityProduct_ATR(sc1);
        
    }
    
    static testMethod void Test_AddOppPdtMthd2(){  
        init();
        OpportunityLineItem oli = [select id,PricebookEntryId from OpportunityLineItem ];
        System.runAs(u) {
                //delete oli;
                }
        
        PageReference pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        AddOpportunityProduct_ATR oppPdt2 = new AddOpportunityProduct_ATR(sc);
        oppPdt2.searchString='test opp';        
        oppPdt2.Editpage();
        //oppPdt.save();
        oppPdt2.updateAvailableList();
        oppPdt2.matchProduct();
        oppPdt2.olItem.pricebookentryid = null;
        oppPdt2.onSave();
        oppPdt2.onSave1();
        oppPdt2.OnCancel();
        oppPdt2.changePricebook();
         
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        PageReference pageRef3 = Page.AddProduct_BGA;
        pageRef3.getParameters().put('id', String.valueOf(opportunity.Id)); 
        Test.setCurrentPage(pageRef3);
        AddProduct_BGA oppPdt3 = new AddProduct_BGA(sc);   
        oppPdt3.searchString='test opp'; 
        oppPdt2.Editpage();
        //oppPdt.save();
        oppPdt2.updateAvailableList();
        oppPdt2.matchProduct();
        oppPdt2.onSave();
        oppPdt2.onSave1();
        oppPdt2.OnCancel();
        oppPdt2.changePricebook();
        sc = new ApexPages.StandardController(opportunity);
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        AddProduct_BGA oppPd3 = new AddProduct_BGA(sc);
        oppPd3.searchString='test opp';
        oppPd3.Editpage();
        
        oppPd3.updateAvailableList();
        oppPd3.matchProduct();
        oppPd3.olItem.pricebookentryid = null;
         System.Test.stopTest();
        oppPd3.onSave();
        oppPdt3.Editpage();
        oppPdt3.matchProduct();
        oppPdt3.olItem.pricebookentryid = null;
        oppPdt3.onSave1();
        oppPd3.onCancel();
        oppPd3.changePricebook();
        
        PageReference pageRef1 = Page.AddOpportunityProduct_ATR;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('Id', String.valueOf(opportunity.Id));
        ApexPages.StandardController sc1 = new ApexPages.StandardController(opportunity);
        //AddOpportunityProduct_ATR aopatr = new AddOpportunityProduct_ATR(sc1);
        
    }
    
    static testMethod void Test_AddOppPdtMthd3(){  
        init();
        OpportunityLineItem oli = [select id,PricebookEntryId from OpportunityLineItem ];
        Platform_cross_ref__c pcr = [select id from Platform_cross_ref__c limit 1];
        System.runAs(u) {
                oli.M_PM_Product__c = productLineCrossRef.id;
                update oli;
                productLine.name = 'TT Test';
                update productLine;
                }
                
        
        PageReference pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        AddOpportunityProduct_ATR oppPdt2 = new AddOpportunityProduct_ATR(sc);
        oppPdt2.searchString='test opp';        
        oppPdt2.Editpage();
        //oppPdt.save();
        oppPdt2.updateAvailableList();
        oppPdt2.matchProduct();
        oppPdt2.olItem.pricebookentryid = null;
        oppPdt2.onSave();
        oppPdt2.onSave1();
        oppPdt2.OnCancel();
        oppPdt2.changePricebook();
        oppPdt2.toUnselect='test';
        oppPdt2.Total = 10.8;
         
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        PageReference pageRef3 = Page.AddProduct_BGA;
        pageRef3.getParameters().put('id', String.valueOf(opportunity.Id)); 
        Test.setCurrentPage(pageRef3);
        AddProduct_BGA oppPdt3 = new AddProduct_BGA(sc);  
        oppPdt3.searchString='test opp';  
        oppPdt2.Editpage();
        //oppPdt.save();
        oppPdt2.updateAvailableList();
        oppPdt2.matchProduct();
        oppPdt2.onSave();
        oppPdt2.onSave1();
        oppPdt2.OnCancel();
        oppPdt2.changePricebook();
        sc = new ApexPages.StandardController(opportunity);
        pageRef2 = Page.AddOpportunityProduct_ATR;
        pageRef2.getParameters().put('id', String.valueOf(opportunity.Id)); 
        AddProduct_BGA oppPd3 = new AddProduct_BGA(sc);
        oppPd3.searchString='test opp';
        oppPd3.Editpage();
        
        oppPd3.updateAvailableList();
         System.Test.stopTest();
        oppPd3.matchProduct();
        //oppPd3.olItem.pricebookentryid = null;
        oppPd3.olItem.M_PM_Product__c = null;
        oppPd3.onSave();
        oppPdt3.Editpage();
        //oppPdt3.olItem.pricebookentryid = null;
        oppPdt3.matchProduct();
        oppPdt3.olItem.M_PM_Product__c = null;
        //oppPdt3.olItem.M_PM_Product__c = productLineCrossRef.id;
        oppPdt3.onSave1();
        
        oppPd3.onCancel();
        oppPd3.changePricebook();
        PageReference pageRef1 = Page.AddOpportunityProduct_ATR;
        Test.setCurrentPage(pageRef1);
        pageRef1.getParameters().put('Id', String.valueOf(opportunity.Id));
        ApexPages.StandardController sc1 = new ApexPages.StandardController(opportunity);
        //AddOpportunityProduct_ATR aopatr = new AddOpportunityProduct_ATR(sc1);
        
    }
    
  }