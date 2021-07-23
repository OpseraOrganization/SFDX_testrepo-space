/**
* @name	NF_FacilitatorNotificationCtrl_CloneTest
* @author
* @since   July 08, 2017
* @desc	Class used to to cover the code for NF_FacilitatorNotificationCtrl_Clone 
* @history
*/

@isTest
private class NF_FacilitatorNotificationCtrl_CloneTest{
    private static User testUser = NF_TestDataFactory.createAdminUser('System Administrator');
    private static User dataloaderUser = NF_TestDataFactory.createAdminUser('Data Loader Profile');
    private static Id upsellDealId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
    private static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
    
    private static Opportunity currentOpportunity;
    private static Account currentAccount;
    
    private static String stageName;
    private static String phaseStatus;
    private static String l4;
    private static String l5;
    private static String l7;
    private static String bg;
    private static String bu;
    private static Boolean noG4PlannedDate = false;
    private static String teamMemberRole;
    private static Boolean withOIF;
    private static String roleCode;
    private static Double totalValue = 1000.0;
    
    public static void setup(){
        
        //insert account
        currentAccount = NF_TestDataFactory.createAccount('132456783');
        currentAccount.L7Name__c = l7;
        currentAccount.L5Name__c = l5;
        currentAccount.L4Name__c = l4;
        insert currentAccount;
        //insert opp
        currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, stageName, phaseStatus, Date.today().addDays(10), 100);
        currentOpportunity.Business_Type__c=GlobalConstants.STANDARDOPPORTUNITY;
        currentOpportunity.Contract_Signing_Entity__c='fALU';
        currentOpportunity.Lead_BG__c = bg;
        currentOpportunity.Lead_BU__c = bu;
        currentOpportunity.Unweighted_Amount_EUR__c = totalValue;
        currentOpportunity.Type_of_Request__c = GlobalConstants.TYPE_REQUEST_RFP_RFI;
        currentOpportunity.Expected_LoA_Approval_Level__c = 'E';
        if(noG4PlannedDate) currentOpportunity.G4_Planned_Date__c = null;
        insert currentOpportunity;
        
    }
    
    public static void addTeamMember(){
        List<OpportunityTeamMember> opptyTeamMembers = TestDataFactory.optyTeamMemberCreation(1, testUser, currentOpportunity);
        opptyTeamMembers[0].TeamMemberRole = teamMemberRole;
        insert opptyTeamMembers;
    }
    
    public static void addOIF(){
        Product2 prod = TestDataFactory.productCreation(1)[0];
        prod.Business_Group__c='FN';
        prod.Family= 'FNCABLE';
        database.insert(prod);
        Nokia_Financial_Calendar__c nokiaFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
        database.insert(nokiaFinCal);
        nokiaFinCal.Start_Date__c=system.today()+1;
        nokiaFinCal.End_Date__c = system.today()+2;
        database.update(nokiaFinCal);
        List<Order_Intake_Forecast__c> oif1=new List<Order_Intake_Forecast__c>();
        oif1=TestDataFactory.orderIntakeCreation(1,currentOpportunity,prod,nokiaFinCal);
        insert oif1;
    }
    
    public static void addSalesRole(){
        User delegate1User = NF_TestDataFactory.createAdminUser('System Administrator');
        insert delegate1User;
        String orgLevel = l7 != null ? l7 : l5;
        Sales_Role__c currentSalesOrg = NF_TestDataFactory.createSalesRole(dataloaderUser, roleCode, orgLevel, '5 - G3 Facilitator');
        insert currentSalesOrg;
        Apttus_Approval__Backup_Approver__c backupApprover =new Apttus_Approval__Backup_Approver__c (
            Apttus_Approval__Backup_User__c= null,
            Apttus_Approval__Cancellation_Date__c= null,
            Apttus_Approval__Comment__c= null,
            Apttus_Approval__Current_User__c= dataloaderUser.Id,
            Apttus_Approval__DelegateUserIds__c= delegate1User.Id,
            Apttus_Approval__Effective_Date__c= null,
            Apttus_Approval__Expiration_Date__c= null,
            Apttus_Approval__InEffect__c= true,
            Apttus_Approval__IsActive__c= true,
            Apttus_Approval__IsDelegate__c= true,
            Apttus_Approval__SuppressDelegateNotification__c= false,
            Apttus_Approval__Transfer_in_flight__c= true,
            Delegate_Approver1__c= delegate1User.Id
        );
        insert backupApprover;
    }
    
    @isTest
    public static void testFacilitatorNotif_UpsellOpptyWithTeam(){
        insert testUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'GS';
        teamMemberRole = CSWXGlobalConstant.AM;
        system.runAs(testUser){
            setup();
            addTeamMember();			
            Test.startTest();
            
            SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,currentAccount)[0];
            upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
            upsellProposal_SWX.Analytics_Source__c='CXM';
            upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
            upsellProposal_SWX.P20_Id__c=215616;
            upsellProposal_SWX.CurrencyIsoCode='EUR';
            upsellProposal_SWX.Unweighted_Value__c=429052;
            upsellProposal_SWX.Account_ID__c=currentAccount.Id;
            upsellProposal_SWX.Sold_To_Party__c = currentAccount.Id;
            upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
            insert upsellProposal_SWX;
            
            currentOpportunity.SWx_Upsell_Proposal__c = upsellProposal_SWX.Id;
            update currentOpportunity;
            
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.init();
            currentOpportunity = facilitatorNotCtrl.currentOpp;
            facilitatorNotCtrl.ConfirmG3Facilitator();
            currentOpportunity = facilitatorNotCtrl.currentOpp;
            Test.stopTest();
            System.assert(facilitatorNotCtrl.FacilitatorName != null);
            System.assert(currentOpportunity.NF_Facilitator_Notified__c);
        }
        
    }
    
    @isTest
    public static void testFacilitatorNotif_UpsellOpptyWithoutTeam(){
        insert testUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'GS';
        system.runAs(testUser){			
            setup();
            
            Test.startTest();
            
            SWx_Upsell_Proposal__c upsellProposal_SWX=TestDataFactory.upsellList(1,currentAccount)[0];
            upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
            upsellProposal_SWX.Analytics_Source__c='CXM';
            upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
            upsellProposal_SWX.P20_Id__c=215616;
            upsellProposal_SWX.CurrencyIsoCode='EUR';
            upsellProposal_SWX.Unweighted_Value__c=429052;
            upsellProposal_SWX.Account_ID__c=currentAccount.Id;
            upsellProposal_SWX.Sold_To_Party__c = currentAccount.Id;
            upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
            insert upsellProposal_SWX;
            
            currentOpportunity.SWx_Upsell_Proposal__c = upsellProposal_SWX.Id;
            update currentOpportunity;
            
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.init();
            Test.stopTest();
            System.assert(facilitatorNotCtrl.FacilitatorName == null);
        }
        
    }
    
    @isTest
    public static void testFacilitatorNotif_IdentifyOppty(){
        insert testUser;
        stageName = 'Identify Opportunity';
        phaseStatus = 'Planned';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'GS';
        system.runAs(testUser){
            setup();
            Test.startTest();
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.showMandatoryInfo = false;
            facilitatorNotCtrl.init();
            Test.stopTest();
            System.assert(ApexPages.getMessages()[0].getDetail().contains( String.format(Label.NF_OnlyFacilitatorCanBeNotified,new String[] {GlobalConstants.DEVELOP_OPPORTUNITY})));
        }
        
    }
    
    @isTest
    public static void testFacilitatorNotif_G3Bypass(){
        insert testUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'GS';
        system.runAs(testUser){
            
            setup();
            Test.startTest();
            
            Offer__c currentOffer = TestDataFactory.OfferCreation(1,currentOpportunity)[0];
            currentOffer.ActiveOffer__c = true;
            currentOffer.No_Support_Offer_Condition__c = GlobalConstants.PICKLIST_VALUE_YES;
            insert currentOffer;
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.showMandatoryInfo = false;
            facilitatorNotCtrl.init();
            Test.stopTest();
            System.assert(ApexPages.getMessages()[0].getDetail().contains(GlobalConstants.G3_FACILITATOR_BYPASS));
        }
    }
    
    @isTest
    public static void testFacilitatorNotif_G4PlannedDate(){
        insert testUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'GS';
        noG4PlannedDate = true;
        system.runAs(testUser){
            setup();
            addOIF();
            Test.startTest();
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.showMandatoryInfo = false;
            facilitatorNotCtrl.init();
            currentOpportunity = facilitatorNotCtrl.currentOpp;
            Test.stopTest();
            List<ApexPages.Message> messages = ApexPages.getMessages();
            System.assert(messages[0].getDetail().contains(Label.NF_G4_PlannedDate_Error));
        }
        
    }
    
    @isTest
    public static void testFacilitatorNotif_WithoutOIF(){
        insert testUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'GS';
        system.runAs(testUser){
            
            setup();
            Test.startTest();
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.showMandatoryInfo = false;
            facilitatorNotCtrl.init();
            Test.stopTest();
            System.assert(ApexPages.getMessages()[0].getDetail().contains(GlobalConstants.MANDATORY_OIF_FOR_APPROVAL));
        }
        
    }
    
    @isTest
    public static void testFacilitatorNotif_AlreadyNotified(){
        insert testUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'GS';
        system.runAs(testUser){
            
            setup();
            addOIF();
            Test.startTest();
            currentOpportunity.NF_Facilitator_Notified__c = true;            
            update currentOpportunity;
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.showMandatoryInfo = false;
            facilitatorNotCtrl.init();
            Test.stopTest();
            System.assert(ApexPages.getMessages()[0].getDetail().contains(Label.NF_Facilitator_already_notified));
        }
        
    }
    
    @isTest
    public static void testFacilitatorNotif_MarketLATQueue(){		
        insert testUser;
        
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Latin America';
        l5 = 'LAT GCBT CARSO';
        bg = 'ION';
        bu = 'ION IPR';
        roleCode = 'NSND_OQM';
        
        system.runAs(testUser){
            
            setup();
            addOIF();
            
            Test.startTest();
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.showMandatoryInfo = false;
            facilitatorNotCtrl.init();
            Test.stopTest();
            System.assert(ApexPages.getMessages()[0].getDetail().contains(GlobalConstants.G3_FACILITATOR_FOUND));
            System.assert(facilitatorNotCtrl.facilitatorQueue != null);
        }
        
    }
    
    @isTest
    public static void testFacilitatorNotif_MarketEuropeMandatoryFields(){		
        insert testUser;
        insert dataloaderUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'FN';
        roleCode = 'NSND_OQM';
        system.runAs(dataloaderUser){
            setup();
            addOIF();
            Test.startTest();
            addSalesRole();
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.init();
            facilitatorNotCtrl.saveAndReturn();   
            facilitatorNotCtrl.init();
            facilitatorNotCtrl.proceed();
            facilitatorNotCtrl.currentOpp.Probability = 50;
            facilitatorNotCtrl.proceed();
            Test.stopTest();
            List<ApexPages.Message> messages = ApexPages.getMessages();
            System.assert(messages[0].getDetail().contains(GlobalConstants.G3_FACILITATOR_INFO_MSG));
            System.assert(facilitatorNotCtrl.FacilitatorName != null);
        }	
    }
    
    @isTest
    public static void testFacilitatorNotif_MarketEurope(){		
        insert testUser;
        insert dataloaderUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'Market Europe';
        l5 = 'EUR GCBT Vodafone';
        bg = 'FN';
        roleCode = 'NSND_OQM';
        system.runAs(dataloaderUser){
            setup();
            addOIF();
            Test.startTest();
            addSalesRole();
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.showMandatoryInfo = false;
            facilitatorNotCtrl.init();
            currentOpportunity = facilitatorNotCtrl.currentOpp;
            facilitatorNotCtrl.ConfirmG3Facilitator();
            Test.stopTest();
            List<ApexPages.Message> messages = ApexPages.getMessages();
            Integer msgSize = messages.size();
            System.assert(messages[0].getDetail().contains(GlobalConstants.G3_FACILITATOR_FOUND));
            System.assert(facilitatorNotCtrl.FacilitatorName != null);
        }	
    }
    
    
    @isTest
    public static void testFacilitatorNotif_MarketNAM1(){		
        insert testUser;
        stageName = 'Develop Opportunity';
        phaseStatus = 'Opportunity in Progress';
        l4 = 'NE Americas';
        l5 = 'NE AME NAM';
        bg = 'NSW';
        system.runAs(testUser){
            
            
            setup();
            addOIF();
            Test.startTest();
            ApexPages.currentPage().getParameters().put('oppId', currentOpportunity.Id);
            NF_FacilitatorNotificationCtrl_Clone facilitatorNotCtrl = new NF_FacilitatorNotificationCtrl_Clone();
            facilitatorNotCtrl.showMandatoryInfo = false;
            facilitatorNotCtrl.init();
            currentOpportunity = facilitatorNotCtrl.currentOpp;
            facilitatorNotCtrl.ConfirmG3Facilitator();
            Test.stopTest();
            List<ApexPages.Message> messages = ApexPages.getMessages();
            Integer msgSize = messages.size();
            System.assert(messages[0].getDetail().contains(GlobalConstants.G3_FACILITATOR_FOUND));
            System.assert(currentOpportunity.NF_Facilitator_Notified__c);
        }
        
    }

}