/**
 * Created by Satya Mohanty on 5/2/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class OpportunityTriggerHelper_Test {
    private static Set<Id> opportunityIds = new Set<Id>();
    private final static String BENDIXKING = 'BendixKing';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private static final String D_N_S = 'D&S';
    private static List<String> restrictedAccountNames;
    private static User userOne;
    private static User userTwo;
    private static Product2 productOne;
    private static Product2 productTwo;
    private static Account account;
    private static Opportunity opportunity;
    private static Opportunity parentOpportunity;
    private static Opportunity_Sales_Team__c opportunityTeam;
    private static Contact contact;

    static void init() {
        account = new TestAccountBuilder()
                .addField( 'Report_Country_Name__c', AMERICA )
                .addField( 'Region_Name__c', AMERICAS )
                .generate();
        OppType__c oppType = new OppType__c( RestrictedAccount__c = account.Id, Name = 'Test' );
        insert oppType;
        parentOpportunity = new TestOpportunityBuilder().generate();
        opportunity = new TestOpportunityBuilder( 'testOpportunity', BENDIXKING )
                .addField( 'AccountId', account.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Closed Won' )
                .build();
        // opportunityTeam = new TestOpportunityTeamBuilder().generate();
        contact = new TestContactBuilder().generate();

        userOne = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();
        userTwo = new TestUserBuilder().setFirstName( 'Jane' ).setLastName( 'Doe' ).generate();
        productOne = new TestProductBuilder( 'My Product One' )
                .generate();
        productTwo = new TestProductBuilder( 'My Product Two' )
                .generate();
    }
    @IsTest
    static void getChildOpportunitiesTest() {
        init();

        System.Test.startTest();
        opportunity.Parent_Opportunity__c = parentOpportunity.Id;
        insert opportunity;

        List<Opportunity> opportunities = OpportunityTriggerHelper.getChildOpportunities( new Set<Id>{
                parentOpportunity.Id
        } );
        System.Test.stopTest();

        System.assertEquals( 1, opportunities.size() );
        System.assertEquals( opportunity.Id, opportunities.get( 0 ).Id );
    }

    @IsTest
    static void getUserTest() {

        UserRole userRole = [SELECT Id FROM UserRole WHERE PortalType = 'CustomerPortal' LIMIT 1];

        User adminUser = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .addField('userRoleId', UserInfo.getUserRoleId())
                .addField('profileId', UserInfo.getProfileId())
                .generate();

        Contact cont;
        System.runAs(adminUser) {
            Account acct = new TestAccountBuilder()
                    .addField( 'Report_Country_Name__c', AMERICA )
                    .addField( 'Region_Name__c', AMERICAS )
                    .generate();

            cont = new TestContactBuilder()
                    .addField('accountId', acct.Id)
                    .generate();
        }

        User testUser;
        System.runAs(adminUser) {
            testUser = new TestUserBuilder()
                    .addField('ContactId', cont.Id)
                    .addField('ProfileId', [
                            SELECT Id
                            FROM Profile
                            WHERE Name = 'Customer Self Service Community Profile'
                    ].Id
                    )
                    .generate();
        }

        System.Test.startTest();
        User returnedUser = OpportunityTriggerHelper.getUser(testUser.Id);
        System.Test.stopTest();

        System.assertEquals(testUser.Id, returnedUser.Id);
    }
    @IsTest
    static void hideBaseFieldsTest() {
        init();

        System.Test.startTest();
        Opportunity dummyOpportunity = new TestOpportunityBuilder()
                .addField( 'Name', 'Test' )
                .addField( 'AccountId', account.Id )
                .addField( 'Program__c', 'Test program' )
                .addField( 'Description', 'test' )
                .addField( 'End_User__c', account.Id )
                .build();
        OpportunityTriggerHelper.hideBaseFields( dummyOpportunity );
        System.Test.stopTest();

        System.assertEquals( OpportunityTriggerHelper.RESTRICTED, dummyOpportunity.Name );
        System.assertEquals( account.Id, dummyOpportunity.AccountId );
        System.assertEquals( OpportunityTriggerHelper.RESTRICTED, dummyOpportunity.Program__c );
        System.assertEquals( OpportunityTriggerHelper.RESTRICTED, dummyOpportunity.Description );
        System.assertEquals( account.Id, dummyOpportunity.End_User__c );
    }
    @IsTest
    static void setRestrictedFieldsSmallDescriptionTest() {
        init();

        System.Test.startTest();
        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.Description = 'testDescription';

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Program__c,
                        End_User_Formula__c,
                        Description
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );
        System.Test.stopTest();

        System.assertEquals( 'testOpportunity', insertedOpportunity.Restricted_Opportunity_Name__c );
        System.assertEquals( 'Testaccount', insertedOpportunity.Restricted_Customer_Name__c );
        System.assertEquals( OpportunityTriggerHelper.RESTRICTED, insertedOpportunity.Restricted_Program_Name__c );
        System.assertEquals( 'Testaccount', insertedOpportunity.Restricted_End_User__c );
        System.assertEquals( 'testDescription', insertedOpportunity.Description );
    }
    @IsTest
    static void setRestrictedFieldsLargeDescriptionTest() {
        init();

        String testDescription = 'LoremipsumdolorsitametconsecteturadipiscingelitNamfermentumetlacusat fringilla. ' +
                'Curabitur sed laoreet magna. Quisque iaculis tincidunt justo, eget porttitor libero pretium nec. ' +
                'Vestibulum ante ipsum primis';

        opportunity.Description = testDescription;

        System.Test.startTest();

        OpportunityTriggerHelper.setRestrictedFields( opportunity );
        System.Test.stopTest();

        System.assertEquals( testDescription.substring( 0, 175 ), opportunity.Restricted_Comments_Description__c );

    }
    @IsTest
    static void getRestrictedAccountNamesTest() {
        init();

        System.Test.startTest();
        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.Description = 'testDescription';
        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.Is_Follow_On_Opportunity__c = true;

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField( 'Is_Restricted_Opportunity__c', true )
                .addField( 'Is_Follow_On_Opportunity__c', false )
                .generate();
        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };
        List<String> restrictedAccountNames = OpportunityTriggerHelper.getRestrictedAccountNames(oldMap ,newMap);
        System.Test.stopTest();

        System.assertEquals( 2,restrictedAccountNames.size());
        System.assertEquals( 'Testaccount', restrictedAccountNames.get(0) );
        System.assertEquals( 'Testaccount', restrictedAccountNames.get(1) );
    }
    @IsTest
    static void getRestrictedAccountNamesIsRestrictedIsFollowUpTest() {
        init();

        System.Test.startTest();
        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.Description = 'testDescription';
        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.Is_Follow_On_Opportunity__c = false;

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField( 'Is_Restricted_Opportunity__c', true )
                .addField( 'Is_Follow_On_Opportunity__c', true )
                .generate();
        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };
        List<String> restrictedAccountNames = OpportunityTriggerHelper.getRestrictedAccountNames(oldMap ,newMap);
        System.Test.stopTest();

        System.assertEquals( 2,restrictedAccountNames.size());
        System.assertEquals( 'Testaccount', restrictedAccountNames.get(0) );
        System.assertEquals( 'Testaccount', restrictedAccountNames.get(1) );
    }
    @IsTest
    static void getOpportunitiesTest() {
        init();

        System.Test.startTest();

        opportunity.Corp_HIPI_Opportunity_Number__c = 'Test Number';
        opportunity.OwnerId = userOne.Id;
        opportunity.RFP_Receipt_Date__c = Date.today();
        opportunity.RFP_Expected_Date__c = Date.today();
        opportunity.CBT_Tier_2__c = 'DAA';
        opportunity.AccountId = account.Id;
        opportunity.SBU__c = 'BGA';
        opportunity.License_Draft__c = Date.today().addDays( 5 );
        opportunity.WorkbookComplete__c = true;

        insert opportunity;

        Opportunity_Sales_Team__c opptyTeam = new TestOpportunityTeamBuilder()
                .addField( 'Opportunity__c', opportunity.Id )
                .setUserId( userTwo.Id )
                .generate();

        Case newCase = new TestCaseBuilder()
                .addField( 'BGA_Dealer_Name__c', 'Honeywell' )
                .addField( 'Opportunity_Owner__c', userOne.Id )
                .addField( 'Opportunity__c', opportunity.Id )
                .generate();

        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField( 'Wokflow_Name__c', 'Test egreensheet' )
                .addField( 'Opportunity_Name__c', 'testOpportunity' )
                .addField( 'Opportunity_Description__c', opportunity.Id )
                .addField( 'Opportunity_Number__c', '1234' )
                .generate();
        Map<Id, Opportunity> returnedOpportunities = OpportunityTriggerHelper.getOpportunities( new Set<Id>{
                opportunity.Id
        } );
        System.Test.stopTest();

        System.assertEquals( 1, returnedOpportunities.size() );
        System.assertEquals( true, returnedOpportunities.containsKey( opportunity.Id ) );
        System.assertEquals( opportunity.Id, returnedOpportunities.get( opportunity.Id ).Id );
        System.assertEquals( 'BGA', returnedOpportunities.get( opportunity.Id ).SBU__c );

        System.assertEquals( 2, returnedOpportunities.get( opportunity.Id ).Opportunity_Sales_Teams__r.size() );
        Set<Id> userIds = new Set<Id>{
                returnedOpportunities.get( opportunity.Id ).Opportunity_Sales_Teams__r.get( 0 ).User__c,
                returnedOpportunities.get( opportunity.Id ).Opportunity_Sales_Teams__r.get( 1 ).User__c
        };
        System.assertEquals( opptyTeam.Opportunity__c, returnedOpportunities.get( opportunity.Id ).Opportunity_Sales_Teams__r.get( 0 ).Opportunity__c );
        System.assertEquals( true, userIds.contains( opptyTeam.User__c ) );
        System.assertEquals( true, userIds.contains( opportunity.OwnerId ) );
        //System.assertEquals(userTwo.Id, opptyTeam.User__c);

        System.assertEquals( newCase.BGA_Dealer_Name__c, returnedOpportunities.get( opportunity.Id ).Cases__r.get( 0 ).BGA_Dealer_Name__c );
        System.assertEquals( newCase.Opportunity_Owner__c, returnedOpportunities.get( opportunity.Id ).Cases__r.get( 0 ).Opportunity_Owner__c );

        System.assertEquals( eGreensheet.Wokflow_Name__c, returnedOpportunities.get( opportunity.Id ).Workflow_details__r.get( 0 ).Wokflow_Name__c );
        System.assertEquals( eGreensheet.Opportunity_Name__c, returnedOpportunities.get( opportunity.Id ).Workflow_details__r.get( 0 ).Opportunity_Name__c );
        System.assertEquals( eGreensheet.Opportunity_Description__c, returnedOpportunities.get( opportunity.Id ).Workflow_details__r.get( 0 ).Opportunity_Description__c );
        System.assertEquals( true, returnedOpportunities.get( opportunity.Id ).Workflow_details__r.get( 0 ).Opportunity_Number__c != null );

    }
    @IsTest
    static void getLineItemsTest() {
        init();

        System.Test.startTest();
        insert opportunity;

        OpportunityLineItem lineItem;

        Pricebook2 pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );
        Database.insert( standardPricebookEntry );
        PricebookEntry pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook( pbook.Id )
                .setProduct( product.Id )
                .generate();

        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )
                .setUnitPrice( 100 )
                .setQuantity( 10 )
                .setPricebookEntryId( pbookEntry.Id )
                .setType( 'Forecast' )
                .setOpportunityId( opportunity.Id )
                .generate();

        List<OpportunityLineItem> lineItems = OpportunityTriggerHelper.getLineItems( new Set<Id>{
                opportunity.Id
        } );
        System.Test.stopTest();

        System.assertEquals( 1, lineItems.size() );
        System.assertEquals( 'Forecast', lineItems.get( 0 ).Type__c );
        System.assertEquals( lineItem.Id, lineItems.get( 0 ).Id );
    }
    @IsTest
    static void handleMpmLicensingTestLicenseNeedDateTest() {
        init();

        System.Test.startTest();
        opportunity.HIPI_CONTRACT_NUMBER__c = '123';
        opportunity.Record_Data_Owner__c = null;
        opportunity.LicenseDraft__c = false;
        opportunity.Final_Review__c = false;
        opportunity.Engineer_Manager_Review__c = false;
        opportunity.WorkbookComplete__c = false;
        opportunity.Account_manager_review__c = false;
        opportunity.Revenue_Recognized__c = false;
        opportunity.InvoiceRequested__c = false;
        opportunity.CUSTOMER_LICENSE_NEED_DATE__c = Date.today().addDays(150);
        insert opportunity;

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField( 'Request_Contract_Number__c', true )
                .addField( 'Appendix_Review_Engineer_Name__c', 'testName' )
                .addField( 'License_Draft__c', Date.today() )
                .addField( 'License_Review__c', Date.today() )
                .addField( 'CUSTOMER_LICENSE_NEED_DATE__c', Date.today().addDays(150) )
                .addField( 'Customer_Last_Modified_Date__c', Datetime.newInstance( 2018, 7, 11, 10, 43, 1 ) )
                .build();
        OpportunityTriggerHelper.handleMpmLicensing(opportunity ,oldOpportunity);
        System.Test.stopTest();

        System.assertEquals( false, opportunity.Request_Contract_Number__c );
        System.assertEquals( '', opportunity.Appendix_Review_Engineer_Name__c );
        System.assertEquals( null, opportunity.License_Draft__c );
        System.assertEquals( null, opportunity.License_Review__c );
        System.assertEquals( null, opportunity.Engineer_Manager_Review_Date__c );
        System.assertEquals( null, opportunity.Workbook_Complete__c );
        System.assertEquals( null, opportunity.Account_manager_review_Date__c );
        System.assertEquals( null, opportunity.Revenue_Recognized_Date__c );
        System.assertEquals( null, opportunity.Invoice_Requested_date__c );
        System.assertEquals( opportunity.LastModifiedDate, opportunity.Customer_Last_Modified_Date__c );
        System.assertEquals( OpportunityTriggerHelper.getEndQuarterDate(), opportunity.Current_end_of_fiscal_quarter_date1__c);
    }
    @IsTest
    static void handleMpmLicensingTestLastModifiedDateTest() {
        init();

        System.Test.startTest();
        opportunity.HIPI_CONTRACT_NUMBER__c = '123';
        opportunity.Record_Data_Owner__c = null;
        opportunity.LicenseDraft__c = false;
        opportunity.Final_Review__c = false;
        opportunity.Engineer_Manager_Review__c = false;
        opportunity.WorkbookComplete__c = false;
        opportunity.Account_manager_review__c = false;
        opportunity.Revenue_Recognized__c = false;
        opportunity.InvoiceRequested__c = false;
        opportunity.CUSTOMER_LICENSE_NEED_DATE__c = Date.today().addDays(-1);
        insert opportunity;

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField( 'Request_Contract_Number__c', true )
                .addField( 'Appendix_Review_Engineer_Name__c', 'testName' )
                .addField( 'License_Draft__c', Date.today() )
                .addField( 'License_Review__c', Date.today() )
                .addField( 'CUSTOMER_LICENSE_NEED_DATE__c', Date.today().addDays(-2) )
                .addField( 'Customer_Last_Modified_Date__c', Datetime.newInstance( 2018, 7, 11, 10, 43, 1 ) )
                .build();
        OpportunityTriggerHelper.handleMpmLicensing(opportunity ,oldOpportunity);
        System.Test.stopTest();

        System.assertEquals( false, opportunity.Request_Contract_Number__c );
        System.assertEquals( '', opportunity.Appendix_Review_Engineer_Name__c );
        System.assertEquals( null, opportunity.License_Draft__c );
        System.assertEquals( null, opportunity.License_Review__c );
        System.assertEquals( null, opportunity.Engineer_Manager_Review_Date__c );
        System.assertEquals( null, opportunity.Workbook_Complete__c );
        System.assertEquals( null, opportunity.Account_manager_review_Date__c );
        System.assertEquals( null, opportunity.Revenue_Recognized_Date__c );
        System.assertEquals( null, opportunity.Invoice_Requested_date__c );
        System.assertEquals( false, opportunity.Request_Contract_Number__c );
        System.assertEquals( false, opportunity.Request_Contract_Number__c );
        System.assertEquals( false, opportunity.Request_Contract_Number__c );
        System.assertEquals( opportunity.LastModifiedDate, opportunity.Customer_Last_Modified_Date__c );
        System.assertEquals( OpportunityTriggerHelper.getEndQuarterDate(), opportunity.Current_end_of_fiscal_quarter_date1__c);
    }
    @IsTest
    static void getEndQuarterDateTest() {
        init();
        System.Test.startTest();
        Date myEndQuarter = [
                SELECT
                        EndDate
                FROM Period
                WHERE Type = 'Quarter'
                AND StartDate = THIS_FISCAL_QUARTER
        ].EndDate;

        Date endQuarterDate = OpportunityTriggerHelper.getEndQuarterDate();
        System.Test.stopTest();

        System.assertEquals(myEndQuarter , endQuarterDate);
    }
    @IsTest
    static void getRestrictedAccountsTest() {
        init();

        System.Test.startTest();
        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.Description = 'testDescription';
        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.Is_Follow_On_Opportunity__c = true;

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField( 'Is_Restricted_Opportunity__c', true )
                .addField( 'Is_Follow_On_Opportunity__c', false )
                .generate();
        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };
        List<Account> restrictedAccounts = OpportunityTriggerHelper.getRestrictedAccounts(oldMap ,newMap);
        System.Test.stopTest();

        System.assertEquals(1,restrictedAccounts.size());
        System.assertEquals(account.Id, restrictedAccounts.get(0).Id);
    }
    @IsTest
    static void setFromRestrictedAccountsTest() {
        init();

        System.Test.startTest();
        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.Description = 'testDescription';
        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.Is_Follow_On_Opportunity__c = true;

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField( 'Is_Restricted_Opportunity__c', true )
                .addField( 'Is_Follow_On_Opportunity__c', false )
                .generate();
        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };
        OpportunityTriggerHelper.setFromRestrictedAccounts(
                oldMap,
                newMap,
                insertedOpportunity
        );
        System.Test.stopTest();

        System.assertEquals(account.Id, insertedOpportunity.Account_Id__c);
        System.assertEquals(account.Id, insertedOpportunity.End_User_Id__c);
    }
    @IsTest
    static void setWorkflowDetailsCbtAirlinesTest() {
        init();

        System.Test.startTest();
        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.Description = 'testDescription';
        opportunity.Is_Restricted_Opportunity__c = false;
        opportunity.Is_Follow_On_Opportunity__c = true;
        opportunity.Name = 'new opportunity';
        opportunity.SBU__c = 'ATR';
        opportunity.CBT_Tier_2__c ='Airlines';
        opportunity.OwnerId = userOne.Id;

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description,
                        Ownerfullname__c,
                        SBU__c,
                        CBT_Tier_2__c,
                        RecordTypeId,
                        AccountId,
                        Region__c,
                        OwnerId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField( 'Is_Restricted_Opportunity__c', true )
                .addField( 'Is_Follow_On_Opportunity__c', false )
                .addField( 'OwnerId', userTwo.Id )
                .addField('Name', 'old opportunity')
                .addField('SBU__c', 'BGA')
                .addField('CBT_Tier_2__c','Airbus')
                .generate();
        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };

        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField('Opportunity_Lead_Owner__c', 'Test Owner')
                .addField('Opportunity_Name__c', 'testOpportunity')
                .generate();

        List<Workflow_details__c> eGreensheets = OpportunityTriggerHelper.setWorkflowDetails(
                newMap,
                oldMap,
                insertedOpportunity,
                new List<Workflow_details__c> {eGreensheet}
        );
        System.Test.stopTest();
        System.assertEquals(1, eGreensheets.size());
        System.assertEquals(insertedOpportunity.Ownerfullname__c, eGreensheets.get(0).Opportunity_Lead_Owner__c);
        System.assertEquals(insertedOpportunity.Name, eGreensheets.get(0).Opportunity_Name__c);
        System.assertEquals(true, eGreensheets.get(0).ATR__c);
        System.assertEquals(false, eGreensheets.get(0).BG_A__c);
        System.assertEquals(false, eGreensheets.get(0).Defence_Space__c);
        System.assertEquals(true, eGreensheets.get(0).Airlines__c);
        System.assertEquals(false, eGreensheets.get(0).Airbus__c);
        System.assertEquals(false, eGreensheets.get(0).RACC__c);
        System.assertEquals(false, eGreensheets.get(0).Boeing__c);
        System.assertEquals(false, eGreensheets.get(0).HTSI__c);
    }
    @IsTest
    static void setWorkflowDetailsCbtAirbusTest() {
        init();

        System.Test.startTest();
        account.Report_Country_Name__c = 'Poland';
        account.Region_Name__c = 'Europe/MiddleEast/Africa/India';
        update account;

        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.SBU__c = 'BGA';
        opportunity.OwnerId = userOne.Id;
        opportunity.CBT_Tier_2__c ='Airbus';

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description,
                        Ownerfullname__c,
                        SBU__c,
                        CBT_Tier_2__c,
                        RecordTypeId,
                        AccountId,
                        Region__c,
                        OwnerId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField('CBT_Tier_2__c','Boeing ATR')
                .addField('SBU__c', 'D_N_S')
                .generate();
        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };
        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField('Opportunity_Lead_Owner__c', 'Test Owner')
                .addField('Opportunity_Name__c', 'testOpportunity')
                .generate();

        List<Workflow_details__c> eGreensheets = OpportunityTriggerHelper.setWorkflowDetails(
                newMap,
                oldMap,
                insertedOpportunity,
                new List<Workflow_details__c> {eGreensheet}
        );
        System.Test.stopTest();
        System.assertEquals(1, eGreensheets.size());
        System.assertEquals(false, eGreensheets.get(0).Airlines__c);
        System.assertEquals(true, eGreensheets.get(0).Airbus__c);
        System.assertEquals(false, eGreensheets.get(0).RACC__c);
        System.assertEquals(false, eGreensheets.get(0).Boeing__c);
        System.assertEquals(false, eGreensheets.get(0).HTSI__c);
        System.assertEquals(false, eGreensheets.get(0).ATR__c);
        System.assertEquals(true, eGreensheets.get(0).BG_A__c);
        System.assertEquals(false, eGreensheets.get(0).Defence_Space__c);
        System.assertEquals(false, eGreensheets.get(0).Americas__c);
        System.assertEquals(false, eGreensheets.get(0).APAC__c);
        System.assertEquals(true, eGreensheets.get(0).EMEAI__c);
        System.assertEquals(false, eGreensheets.get(0).Global__c);
    }
    @IsTest
    static void setWorkflowDetailsCbtBoeingTest() {
        init();

        System.Test.startTest();
        account.Report_Country_Name__c = 'Poland';
        account.Region_Name__c = 'Europe/MiddleEast/Africa/India';
        update account;

        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.SBU__c = 'BGA';
        opportunity.OwnerId = userOne.Id;
        opportunity.CBT_Tier_2__c ='Boeing ATR';

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description,
                        Ownerfullname__c,
                        SBU__c,
                        CBT_Tier_2__c,
                        RecordTypeId,
                        AccountId,
                        Region__c,
                        OwnerId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField('CBT_Tier_2__c','Airbus')
                .addField('SBU__c', 'D_N_S')
                .generate();
        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };
        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField('Opportunity_Lead_Owner__c', 'Test Owner')
                .addField('Opportunity_Name__c', 'testOpportunity')
                .generate();

        List<Workflow_details__c> eGreensheets = OpportunityTriggerHelper.setWorkflowDetails(
                newMap,
                oldMap,
                insertedOpportunity,
                new List<Workflow_details__c> {eGreensheet}
        );
        System.Test.stopTest();
        System.assertEquals(1, eGreensheets.size());
        System.assertEquals(false, eGreensheets.get(0).Airlines__c);
        System.assertEquals(false, eGreensheets.get(0).Airbus__c);
        System.assertEquals(false, eGreensheets.get(0).RACC__c);
        System.assertEquals(true, eGreensheets.get(0).Boeing__c);
        System.assertEquals(false, eGreensheets.get(0).HTSI__c);
        System.assertEquals(false, eGreensheets.get(0).ATR__c);
        System.assertEquals(true, eGreensheets.get(0).BG_A__c);
        System.assertEquals(false, eGreensheets.get(0).Defence_Space__c);
        System.assertEquals(false, eGreensheets.get(0).Americas__c);
        System.assertEquals(false, eGreensheets.get(0).APAC__c);
        System.assertEquals(true, eGreensheets.get(0).EMEAI__c);
        System.assertEquals(false, eGreensheets.get(0).Global__c);
    }
    @IsTest
    static void setWorkflowDetailsCbtHtsiTest() {
        init();

        System.Test.startTest();
        account.Report_Country_Name__c = 'Poland';
        account.Region_Name__c = 'Unassigned';
        update account;

        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.SBU__c = 'BGA';
        opportunity.OwnerId = userOne.Id;
        opportunity.CBT_Tier_2__c ='HTSI';

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description,
                        Ownerfullname__c,
                        SBU__c,
                        CBT_Tier_2__c,
                        RecordTypeId,
                        AccountId,
                        Region__c,
                        OwnerId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField('CBT_Tier_2__c','Airbus')
                .addField('SBU__c', 'D_N_S')
                .generate();
        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };
        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField('Opportunity_Lead_Owner__c', 'Test Owner')
                .addField('Opportunity_Name__c', 'testOpportunity')
                .generate();

        List<Workflow_details__c> eGreensheets = OpportunityTriggerHelper.setWorkflowDetails(
                newMap,
                oldMap,
                insertedOpportunity,
                new List<Workflow_details__c> {eGreensheet}
        );
        System.Test.stopTest();
        System.assertEquals(1, eGreensheets.size());
        System.assertEquals(false, eGreensheets.get(0).Airlines__c);
        System.assertEquals(false, eGreensheets.get(0).Airbus__c);
        System.assertEquals(false, eGreensheets.get(0).RACC__c);
        System.assertEquals(false, eGreensheets.get(0).Boeing__c);
        System.assertEquals(true, eGreensheets.get(0).HTSI__c);
        System.assertEquals(false, eGreensheets.get(0).ATR__c);
        System.assertEquals(true, eGreensheets.get(0).BG_A__c);
        System.assertEquals(false, eGreensheets.get(0).Defence_Space__c);
        System.assertEquals(false, eGreensheets.get(0).Americas__c);
        System.assertEquals(false, eGreensheets.get(0).APAC__c);
        System.assertEquals(false, eGreensheets.get(0).EMEAI__c);
        System.assertEquals(true, eGreensheets.get(0).Global__c);
    }
    @IsTest
    static void setWorkflowDetailsRecordTypeBendixTest() {
        init();

        System.Test.startTest();
        DR_Approvers_List__c approversList = new DR_Approvers_List__c();
        approversList.SBU__c = 'D&S';
        approversList.CBT__c = 'DBL';
        approversList.Proposal_Manager__c = userOne.Id;
        approversList.Sales_Operations_Analyst__c = userTwo.Id;
        approversList.Finance__c = userTwo.Id;
        approversList.PMOS_Leader__c = contact.Id;
        approversList.ISC__c = contact.Id;
        approversList.C_PS__c = contact.Id;
        approversList.Engineering__c = contact.Id;
        approversList.M_PM__c = contact.Id;
        approversList.Contracts__c = contact.Id;
        approversList.Pricing__c = userOne.Id;
        approversList.Growth_Leader__c = userOne.Id;
        insert approversList;

        account.Report_Country_Name__c = 'India';
        account.Region_Name__c = 'Asia/Pacific Rim';
        account.Account_Owner__c = userOne.Id;
        update account;

        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.SBU__c = D_N_S;
        opportunity.CBT_Tier_2__c = 'DBL';
        opportunity.CBT_Team_Tier_3__c = 'VLAM';
        opportunity.AccountId = account.Id;
        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description,
                        Ownerfullname__c,
                        SBU__c,
                        CBT_Tier_2__c,
                        RecordTypeId,
                        AccountId,
                        Region__c,
                        OwnerId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField('End_User__c', account.Id)
                .addField('CBT_Tier_2__c','HTSI')
                .addField('SBU__c','BGA')
                .generate();

        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };

        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField('Opportunity_Lead_Owner__c', 'Test Owner')
                .addField('Opportunity_Name__c', 'testOpportunity')
                .generate();

        List<Workflow_details__c> eGreensheets = OpportunityTriggerHelper.setWorkflowDetails(
                newMap,
                oldMap,
                insertedOpportunity,
                new List<Workflow_details__c> {eGreensheet}
        );
        System.Test.stopTest();
        RecordType recordType = [
                SELECT
                        Id,
                        Name
                FROM RecordType
                WHERE SobjectType = 'Opportunity'
                AND DeveloperName = :BENDIXKING
                LIMIT 1
        ];
        System.assertEquals(1, eGreensheets.size());
        System.assertEquals(recordType.Id, insertedOpportunity.RecordTypeId);
        System.assertEquals(false, eGreensheets.get(0).AM__c);
        System.assertEquals(false, eGreensheets.get(0).OE__c);
        System.assertEquals(false, eGreensheets.get(0).Airlines__c);
        System.assertEquals(false, eGreensheets.get(0).Airbus__c);
        System.assertEquals(false, eGreensheets.get(0).RACC__c);
        System.assertEquals(false, eGreensheets.get(0).Boeing__c);
        System.assertEquals(false, eGreensheets.get(0).HTSI__c);
        System.assertEquals(false, eGreensheets.get(0).Americas__c);
        System.assertEquals(true, eGreensheets.get(0).APAC__c);
        System.assertEquals(false, eGreensheets.get(0).EMEAI__c);
        System.assertEquals(false, eGreensheets.get(0).Global__c);
        System.assertEquals(false, eGreensheets.get(0).ATR__c);
        System.assertEquals(false, eGreensheets.get(0).BG_A__c);
        System.assertEquals(true, eGreensheets.get(0).Defence_Space__c);
    }
    @IsTest
    static void setWorkflowDetailsRecordTypeAmCatalogTest() {
        init();

        System.Test.startTest();
        RecordType recordType = [
                SELECT
                        Id,
                        Name
                FROM RecordType
                WHERE SobjectType = 'Opportunity'
                AND DeveloperName = 'AM_Catalog'
                LIMIT 1
        ];

        DR_Approvers_List__c approversList = new DR_Approvers_List__c();
        approversList.SBU__c = 'D&S';
        approversList.CBT__c = 'DBL';
        approversList.Proposal_Manager__c = userOne.Id;
        approversList.Sales_Operations_Analyst__c = userTwo.Id;
        approversList.Finance__c = userTwo.Id;
        approversList.PMOS_Leader__c = contact.Id;
        approversList.ISC__c = contact.Id;
        approversList.C_PS__c = contact.Id;
        approversList.Engineering__c = contact.Id;
        approversList.M_PM__c = contact.Id;
        approversList.Contracts__c = contact.Id;
        approversList.Pricing__c = userOne.Id;
        approversList.Growth_Leader__c = userOne.Id;
        insert approversList;

        account.Report_Country_Name__c = 'India';
        account.Region_Name__c = 'Asia/Pacific Rim';
        account.Account_Owner__c = userOne.Id;
        update account;

        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.SBU__c = D_N_S;
        opportunity.CBT_Tier_2__c = 'DBL';
        opportunity.CBT_Team_Tier_3__c = 'VLAM';
        opportunity.AccountId = account.Id;
        opportunity.RecordTypeId = recordType.Id;
        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description,
                        Ownerfullname__c,
                        SBU__c,
                        CBT_Tier_2__c,
                        RecordTypeId,
                        AccountId,
                        Region__c,
                        OwnerId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField('End_User__c', account.Id)
                .addField('CBT_Tier_2__c','HTSI')
                .addField('SBU__c','BGA')
                .generate();

        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };

        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField('Opportunity_Lead_Owner__c', 'Test Owner')
                .addField('Opportunity_Name__c', 'testOpportunity')
                .generate();

        List<Workflow_details__c> eGreensheets = OpportunityTriggerHelper.setWorkflowDetails(
                newMap,
                oldMap,
                insertedOpportunity,
                new List<Workflow_details__c> {eGreensheet}
        );
        System.Test.stopTest();

        System.assertEquals(1, eGreensheets.size());
        System.assertEquals(true, eGreensheets.get(0).AM__c);
        System.assertEquals(false, eGreensheets.get(0).OE__c);
        System.assertEquals(false, eGreensheets.get(0).Airlines__c);
        System.assertEquals(false, eGreensheets.get(0).Airbus__c);
        System.assertEquals(false, eGreensheets.get(0).RACC__c);
        System.assertEquals(false, eGreensheets.get(0).Boeing__c);
        System.assertEquals(false, eGreensheets.get(0).HTSI__c);
        System.assertEquals(false, eGreensheets.get(0).Americas__c);
        System.assertEquals(true, eGreensheets.get(0).APAC__c);
        System.assertEquals(false, eGreensheets.get(0).EMEAI__c);
        System.assertEquals(false, eGreensheets.get(0).Global__c);
        System.assertEquals(false, eGreensheets.get(0).ATR__c);
        System.assertEquals(false, eGreensheets.get(0).BG_A__c);
        System.assertEquals(true, eGreensheets.get(0).Defence_Space__c);
    }
    @IsTest
    static void setWorkflowDetailsRecordTypeOeComplexTest() {
        init();

        System.Test.startTest();
        RecordType recordType = [
                SELECT
                        Id,
                        Name
                FROM RecordType
                WHERE SobjectType = 'Opportunity'
                AND DeveloperName = 'OE_Complex'
                LIMIT 1
        ];

        DR_Approvers_List__c approversList = new DR_Approvers_List__c();
        approversList.SBU__c = 'D&S';
        approversList.CBT__c = 'DBL';
        approversList.Proposal_Manager__c = userOne.Id;
        approversList.Sales_Operations_Analyst__c = userTwo.Id;
        approversList.Finance__c = userTwo.Id;
        approversList.PMOS_Leader__c = contact.Id;
        approversList.ISC__c = contact.Id;
        approversList.C_PS__c = contact.Id;
        approversList.Engineering__c = contact.Id;
        approversList.M_PM__c = contact.Id;
        approversList.Contracts__c = contact.Id;
        approversList.Pricing__c = userOne.Id;
        approversList.Growth_Leader__c = userOne.Id;
        insert approversList;

        account.Report_Country_Name__c = 'India';
        account.Region_Name__c = 'Asia/Pacific Rim';
        account.Account_Owner__c = userOne.Id;
        update account;

        opportunity.Program__c = OpportunityTriggerHelper.RESTRICTED;
        opportunity.End_User__c = account.Id;
        opportunity.SBU__c = D_N_S;
        opportunity.CBT_Tier_2__c = 'DBL';
        opportunity.CBT_Team_Tier_3__c = 'VLAM';
        opportunity.AccountId = account.Id;
        opportunity.RecordTypeId = recordType.Id;
        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description,
                        Ownerfullname__c,
                        SBU__c,
                        CBT_Tier_2__c,
                        RecordTypeId,
                        AccountId,
                        Region__c,
                        OwnerId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField('End_User__c', account.Id)
                .addField('CBT_Tier_2__c','HTSI')
                .addField('SBU__c','BGA')
                .generate();

        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };

        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField('Opportunity_Lead_Owner__c', 'Test Owner')
                .addField('Opportunity_Name__c', 'testOpportunity')
                .generate();

        List<Workflow_details__c> eGreensheets = OpportunityTriggerHelper.setWorkflowDetails(
                newMap,
                oldMap,
                insertedOpportunity,
                new List<Workflow_details__c> {eGreensheet}
        );
        System.Test.stopTest();

        System.assertEquals(1, eGreensheets.size());
        System.assertEquals(false, eGreensheets.get(0).AM__c);
        System.assertEquals(true, eGreensheets.get(0).OE__c);
    }
    @IsTest
    static void setWorkflowDetailsAccountTest() {
        init();

        System.Test.startTest();
        opportunity.CBT_Tier_2__c = 'Components Business';
        opportunity.AccountId = account.Id;

        insert opportunity;

        Opportunity insertedOpportunity = [
                SELECT
                        Name,
                        Account_Name_formula__c,
                        Is_Restricted_Opportunity__c,
                        Is_Follow_On_Opportunity__c,
                        Program__c,
                        End_User_Formula__c,
                        Description,
                        Ownerfullname__c,
                        SBU__c,
                        CBT_Tier_2__c,
                        RecordTypeId,
                        AccountId,
                        Region__c,
                        OwnerId
                FROM Opportunity
                WHERE Id = :opportunity.Id
        ];
        OpportunityTriggerHelper.setRestrictedFields( insertedOpportunity );

        Opportunity oldOpportunity = new TestOpportunityBuilder()
                .addField('CBT_Tier_2__c','Boeing ATR')
                .generate();

        oldOpportunity.Id = opportunity.Id;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
                oldOpportunity.Id => oldOpportunity
        };
        Map<Id, Opportunity> newMap = new Map<Id, Opportunity>{
                opportunity.Id => insertedOpportunity
        };

        Workflow_details__c eGreensheet = new TestEgreensheetBuilder()
                .addField('Customer_Name__c', account.Id)
                .generate();

        List<Workflow_details__c> eGreensheets = OpportunityTriggerHelper.setWorkflowDetails(
                newMap,
                oldMap,
                insertedOpportunity,
                new List<Workflow_details__c> {eGreensheet}
        );
        System.Test.stopTest();
        RecordType recordType = [
                SELECT
                        Id,
                        Name
                FROM RecordType
                WHERE SobjectType = 'Opportunity'
                AND DeveloperName = :BENDIXKING
                LIMIT 1
        ];
        System.assertEquals(1, eGreensheets.size());
        System.assertEquals(recordType.Id, insertedOpportunity.RecordTypeId);
        System.assertEquals(false, eGreensheets.get(0).AM__c);
        System.assertEquals(false, eGreensheets.get(0).OE__c);
        System.assertEquals(false, eGreensheets.get(0).Airlines__c);
        System.assertEquals(false, eGreensheets.get(0).Airbus__c);
        System.assertEquals(true, eGreensheets.get(0).RACC__c);
        System.assertEquals(false, eGreensheets.get(0).Boeing__c);
        System.assertEquals(false, eGreensheets.get(0).HTSI__c);
    }
    
}