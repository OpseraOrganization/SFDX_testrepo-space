/**
 * Created by satya mohanty on 3/22/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class OpportunityTriggerHelper {
    public static final OppType__c restrictedTypeList = OppType__c.getAll().values().size() > 0 ?
            OppType__c.getAll().values().get(0):
            null;
    private static User user;
    private static List<Opportunity> childOpportunities;
    private static Decimal childOpportunitiesWinLossAmount;
    private static Decimal childOpportunitiesWinLossProposalAmount;
    private static Decimal childOpportunitiesTotalWinLossAmount;
    private static Decimal childOpportunitiesTotalWinProposalAmount;
    @TestVisible private static final String RESTRICTED = 'Restricted';
    @TestVisible private static final String ATR = 'ATR';
    private static final String BGA = 'BGA';
    private static final String D_N_S = 'D&S';

    public static List<Opportunity> getChildOpportunities(Set<Id> opportunityIds) {
            childOpportunities = [
                    SELECT
                            Id,
                            IsWon,
                            StageName,
                            Win_Loss_Proposal_Amount__c,
                            Win_Loss_Amount__c,
                            Parent_Opportunity__c,
                            Total_Win_Loss_Proposal_Amount__c,
                            Total_Win_Loss_Amount__c
                    FROM Opportunity
                    WHERE Parent_Opportunity__c IN :opportunityIds
            ];
        return childOpportunities;
    }
    public static User getUser(Id userId) {
        if (user == null) {
            user = [
                    SELECT
                            Id,
                            Name,
                            ContactId,
                            Contact.AccountId,
                            Contact.Account.Name
                    FROM User
                    WHERE Id = :userId
                    AND ContactId != NULL
                    LIMIT 1
            ];
        }
        return user;
    }
    public static Date getEndQuarterDate() {
        return [
                SELECT
                        EndDate
                FROM Period
                WHERE Type = 'Quarter'
                AND StartDate = THIS_FISCAL_QUARTER
        ].EndDate;
    }
    /**
     * @description Verifies if the user that triggered the process has a "spiral" profile or not.
     * @return Boolean based on if the user has the "profile" profile.
     */
    public static Boolean isSpiralUser() {
        Boolean blnDSprofilechk = false;
        System.debug(UserInfo.getProfileId()+'Spirl User Out==='+Label.D_S_Sales_Spiral_API_User_Label);
        System.debug(UserInfo.getProfileId()+'Spirl User Out==='+Label.D_S_Sales_API_User_Profile);
        System.debug(UserInfo.getProfileId()+'Spirl User Out==='+Label.D_S_Sales_API_Discretionary_User_Profile);
        if(UserInfo.getProfileId() == Label.D_S_Sales_Spiral_API_User_Label || UserInfo.getProfileId() == Label.D_S_Sales_API_User_Profile || UserInfo.getProfileId() == Label.D_S_Sales_API_Discretionary_User_Profile){         
            blnDSprofilechk = true;
        }
        return blnDSprofilechk;
    }
    public static void handleMpmLicensing(Opportunity opportunity, Opportunity oldOpportunity) {
        if (opportunity.HIPI_CONTRACT_NUMBER__c != null) {
            opportunity.Request_Contract_Number__c = false;
        }
        if (opportunity.Record_Data_Owner__c == null) {
            opportunity.Appendix_Review_Engineer_Name__c = '';
        }
        if (opportunity.LicenseDraft__c == false) {
            opportunity.License_Draft__c = null;
        }
        if (opportunity.Final_Review__c == false) {
            opportunity.License_Review__c = null;
        }
        if (opportunity.Engineer_Manager_Review__c == false) {
            opportunity.Engineer_Manager_Review_Date__c = null;
        }
        if (opportunity.WorkbookComplete__c == false) {
            opportunity.Workbook_Complete__c = null;
        }
        if (opportunity.Account_manager_review__c == false) {
            opportunity.Account_manager_review_Date__c = null;
        }
        if (opportunity.Revenue_Recognized__c == false) {
            opportunity.Revenue_Recognized_Date__c = null;
        }
        if (opportunity.InvoiceRequested__c == false) {
            opportunity.Invoice_Requested_date__c = null;
        }
        if (opportunity.CUSTOMER_LICENSE_NEED_DATE__c != null) {
            opportunity.Customer_Last_Modified_Date__c = opportunity.LastModifiedDate;

            opportunity.Current_end_of_fiscal_quarter_date1__c = getEndQuarterDate();

            Date customerLicenseNeedDate = opportunity.CUSTOMER_LICENSE_NEED_DATE__c;

            Integer differenceBetweenEndDates;
            if (opportunity.CUSTOMER_LICENSE_NEED_DATE__c != oldOpportunity.CUSTOMER_LICENSE_NEED_DATE__c ||
                    opportunity.LastModifiedDate != oldOpportunity.Customer_Last_Modified_Date__c
                    ) {
                // TODO: What if the customerLicenseNeedDate == endOfQuarterDate?
                if (customerLicenseNeedDate < getEndQuarterDate()) {
                    differenceBetweenEndDates = customerLicenseNeedDate.daysBetween(getEndQuarterDate());
                } else if (customerLicenseNeedDate > getEndQuarterDate()) {
                    differenceBetweenEndDates = getEndQuarterDate().daysBetween(customerLicenseNeedDate);
                }
            }
            Decimal draft;
        Decimal draft1;
        // TODO: Verify with Tony how this works or what it's supposed to do.
        if (differenceBetweenEndDates != null) {
            draft = ((90 - (differenceBetweenEndDates)) / 30);
            draft1 = (draft + 3).setScale(2);
        }
        if (String.valueOf(draft1) != null) {
            opportunity.Draft_Priority_Flag__c = String.valueOf(draft1);
        } else {
            opportunity.Draft_Priority_Flag__c = '';
        }
    }
    }
    public static OppType__c getRestrictedType() {
        return restrictedTypeList;
    }
    public static void setRestrictedFields(Opportunity opportunity) {
        opportunity.Restricted_Opportunity_Name__c = opportunity.Name;
        opportunity.Restricted_Customer_Name__c = opportunity.Account_Name_formula__c;
        opportunity.Restricted_Program_Name__c = opportunity.Program__c;
        opportunity.Restricted_End_User__c = opportunity.End_User_Formula__c;
        if (opportunity.Description != null && opportunity.Description.length() > 175) {
            opportunity.Restricted_Comments_Description__c = opportunity.Description.substring(0, 175);
        } else {
            opportunity.Restricted_Comments_Description__c = opportunity.Description;
        }
    }
    public static void hideBaseFields(Opportunity opportunity) {
        opportunity.Name = RESTRICTED;
        opportunity.AccountId = getRestrictedType().RestrictedAccount__c;
        opportunity.Program__c = RESTRICTED;
        opportunity.Description = RESTRICTED;
        opportunity.End_User__c = getRestrictedType().RestrictedAccount__c;
    }
    @TestVisible
    private static List<String> getRestrictedAccountNames(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
        List<String> restrictedAccountNames = new List<String>();
        for (Opportunity opportunity: newMap.values()) {
            Opportunity oldOpportunity = oldMap.get(opportunity.Id);
            if (((opportunity.Is_Restricted_Opportunity__c == false &&
                    opportunity.Is_Follow_On_Opportunity__c == true) &&
                    (oldOpportunity.Is_Restricted_Opportunity__c == true ||
                            oldOpportunity.Is_Follow_On_Opportunity__c == false)) ||
                    ((opportunity.Is_Restricted_Opportunity__c == false &&
                            opportunity.Is_Follow_On_Opportunity__c == false) &&
                            (oldOpportunity.Is_Restricted_Opportunity__c == true ||
                                    oldOpportunity.Is_Follow_On_Opportunity__c == true))
                    ) {
                restrictedAccountNames.add(opportunity.Restricted_Customer_Name__c);
                restrictedAccountNames.add(opportunity.Restricted_End_User__c);
            }
        }
        return restrictedAccountNames;
    }
    public static List<Account> getRestrictedAccounts(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap) {
        List<Account> restrictedAccountList;
        List<String> restrictedAccountNames = OpportunityTriggerHelper.getRestrictedAccountNames(oldMap, newMap);
        if (restrictedAccountNames.size() > 0) {
            restrictedAccountList = [
                    SELECT
                            Name,
                            Id
                    FROM Account
                    WHERE Name
                    IN :restrictedAccountNames
            ];
        }
        return restrictedAccountList;
    }
    // TODO: Commenting the lines below as it was requested we take out this logic. However we are leaving them here in case
    // TODO: it is requested to bring them back once we go to PROD.
//    public static Decimal getChildWinLoss(Set<Id> opportunityIds){
//        if (childOpportunitiesWinLossAmount == null) {
//            populateChildOpportunitiesValues(opportunityIds);
//        }
//        return childOpportunitiesWinLossAmount;
//    }
//    public static Decimal getChildWinLossProposal(Set<Id> opportunityIds){
//        if (childOpportunitiesWinLossProposalAmount == null) {
//            populateChildOpportunitiesValues(opportunityIds);
//        }
//        return childOpportunitiesWinLossProposalAmount;
//    }
//    public static Decimal getChildTotalWinLoss(Set<Id> opportunityIds){
//        if (childOpportunitiesTotalWinLossAmount == null) {
//            populateChildOpportunitiesValues(opportunityIds);
//        }
//        return childOpportunitiesTotalWinLossAmount;
//    }
//    public static Decimal getChildTotalWinLossProposal(Set<Id> opportunityIds){
//        if (childOpportunitiesTotalWinProposalAmount == null) {
//            populateChildOpportunitiesValues(opportunityIds);
//        }
//        return childOpportunitiesTotalWinProposalAmount;
//    }
//    private static void populateChildOpportunitiesValues(Set<Id> opportunityIds) {
//        if (getChildOpportunities(opportunityIds).size() > 0) {
//            for (Opportunity childOpportunity : getChildOpportunities(opportunityIds)) {
//                if (childOpportunity.StageName != 'Closed Lost' &&
//                        childOpportunity.StageName != 'Closed Cancelled' &&
//                        childOpportunity.StageName != 'Closed Channel Partner') {
//                    if (childOpportunity.Win_Loss_Amount__c != null) {
//                        childOpportunitiesWinLossAmount += childOpportunity.Win_Loss_Amount__c;
//                    }
//                    if (childOpportunity.Win_Loss_Proposal_Amount__c != null) {
//                        childOpportunitiesWinLossProposalAmount += childOpportunity.Win_Loss_Proposal_Amount__c;
//                    }
//                }
//                if (childOpportunity.IsWon == true) {
//                    if (childOpportunity.Win_Loss_Amount__c != null) {
//                        childOpportunitiesTotalWinLossAmount += childOpportunity.Win_Loss_Amount__c;
//                    }
//                    if (childOpportunity.Win_Loss_Proposal_Amount__c != null) {
//                        childOpportunitiesTotalWinProposalAmount += childOpportunity.Win_Loss_Proposal_Amount__c;
//                    }
//                }
//            }
//        }
//    }
    public static void setFromRestrictedAccounts(Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap, Opportunity opportunity) {
        for (Account restrictedAccount: getRestrictedAccounts(oldMap, newMap)) {
            if (restrictedAccount.Name == opportunity.Restricted_Customer_Name__c) {
                opportunity.Account_Id__c = restrictedAccount.Id;
            }
            if (restrictedAccount.Name == opportunity.Restricted_End_User__c) {
                opportunity.End_User_Id__c = restrictedAccount.Id;
            }
        }
    }
    public static Map<Id, Opportunity> getOpportunities(Set<Id> opportunityIds) {
            return new Map<Id, Opportunity> (
                    (List<Opportunity>)[
                            SELECT
                                    Id,
                                    Corp_HIPI_Opportunity_Number__c,
                                    OwnerId,
                                    Owner.Name,
                                    Owner.Email,
                                    Account.OwnerId,
                                    Account.Owner.Functional_Role__c,
                                    Account.CBT__c,
                                    Account.CBT_Team__c,
                                    Account.CBT_Directorate__c,
                                    Account.Sales_Channel__c,
                                    Account.SC1__c,
                                    Account.SC2__c,
                                    HIPI_Accounts__c,
                                    AccountId,
                                    dealer_account__r.Name,
                                    RFP_Receipt_Date__c,
                                    RFP_Expected_Date__c,
                                    Next_Phase__c,
                                    Name,
                                    CBT_Tier_2__c,
                                    Ownerfullname__c,
                                    Region__c,
                                    RecordTypeId,
                                    Opportunity_Owner_formula__c,
                                    SBU__c,
                                    Appendix_Review_Engineer__r.Email,
                                    Account.Owner.Email,
                                    License_Draft__c,
                                    Record_Type_Name__c,
                                    License_Review__c,
                                    Workbook_Complete__c,
                                    WorkbookComplete__c,
                                    Engineer_Manager_Review__c,
                                    Engineer_Manager_Review_Date__c,
                                    Account_manager_review_Date__c,
                                    Account_Contact_Name__c,
                                    Account_Contact_Name__r.Primary_Email_Address__c,
                                    Record_Data_Owner__c,
                                    Record_Data_Owner__r.Primary_Email_Address__c,
                                    BusinessContact__c,
                                    BusinessContact__r.Email,
                                    BusinessContact__r.ContactId,
                                    StageName,
                            (
                                    SELECT
                                            Id,
                                            Opportunity__c,
                                            User__c,
                                            User__r.Email,
                                            User__r.IsPortalEnabled,
                                            User__r.Name,
                                            Is_User_Active__c,
                                            Opportunity_Owner_Id__c
                                    FROM Opportunity_Sales_Teams__r
                                    // TODO: This is likely redundant as this query is already an inner query inside the Opportunity object.
                                    WHERE Opportunity__c IN :opportunityIds
                            ),
                            (
                                    SELECT
                                            Id,
                                            BGA_Dealer_Name__c,
                                            Opportunity_Owner__c
                                    FROM Cases__r
                                    WHERE Opportunity__c IN:opportunityIds
                            ),
                            (
                                    SELECT
                                            Id,
                                            Wokflow_Name__c,
                                            Opportunity_Name__c,
                                            Opportunity_Number__c,
                                            Opportunity_Description__c
                                    FROM Workflow_details__r
                            ),
                                    Request_Contract_Number__c,
                                    HIPI_CONTRACT_NUMBER__c
                            FROM Opportunity
                            WHERE Id IN:opportunityIds
                    ]);
    }
    public static List<OpportunityLineItem> getLineItems(Set<Id> opportunityIds) {
            return [
                    SELECT
                            Id,
                            OpportunityId,
                            Probability__c,
                            ServiceDate,
                            Type__c,
                            Blanket_Forecast__c,
                            Revenue_Start_Date__c
                    FROM OpportunityLineItem
                    WHERE OpportunityId IN :opportunityIds
                    AND Type__c = 'Forecast'
            ];
    }
    public static List<Workflow_details__c> setWorkflowDetails(
            Map<Id, Opportunity> newOpportunities,
            Map<Id, Opportunity> oldMap,
            Opportunity opp,
            List<Workflow_details__c> workflowDetails
    ) {
        List<Workflow_details__c> workflowDetailsToUpdate = new List<Workflow_details__c>();
        for(Workflow_details__c workflowDetail: workflowDetails)
        {
            system.debug('LOG 2');
            if (newOpportunities.get(opp.Id).OwnerId!=null
                    && newOpportunities.get(opp.Id).OwnerId!=oldMap.get(opp.Id).OwnerId) {
                system.debug('LOG 3');
                workflowDetail.Opportunity_Lead_Owner__c=newOpportunities.get(opp.Id).Ownerfullname__c;
                system.debug('workflowDetail.Opportunity_Lead_Owner__c is ' + workflowDetail.Opportunity_Lead_Owner__c);
            }
            if (newOpportunities.get(opp.Id).Name!=null
                    && newOpportunities.get(opp.Id).Name!=oldMap.get(opp.Id).Name) {
                workflowDetail.Opportunity_Name__c=newOpportunities.get(opp.Id).Name;
            }
            if (newOpportunities.get(opp.Id).SBU__c!=null
                    && newOpportunities.get(opp.Id).SBU__c!=oldMap.get(opp.Id).SBU__c
                    && newOpportunities.get(opp.Id).SBU__c==ATR) {
                workflowDetail.ATR__c=true;
                workflowDetail.BG_A__c=false;
                workflowDetail.Defence_Space__c=false;
            }
            else if(newOpportunities.get(opp.Id).SBU__c!=null&&
                    newOpportunities.get(opp.Id).SBU__c!=oldMap.get(opp.Id).SBU__c &&
                    newOpportunities.get(opp.Id).SBU__c== BGA) {
                workflowDetail.ATR__c=false;
                workflowDetail.BG_A__c=true;
                workflowDetail.Defence_Space__c=false;
            }
            else if(newOpportunities.get(opp.Id).SBU__c!=null&&
                    newOpportunities.get(opp.Id).SBU__c!=oldMap.get(opp.Id).SBU__c &&
                    newOpportunities.get(opp.Id).SBU__c== D_N_S ) {
                workflowDetail.ATR__c=false;
                workflowDetail.BG_A__c=false;
                workflowDetail.Defence_Space__c=true;
            }
            else {
                workflowDetail.ATR__c=false;
                workflowDetail.BG_A__c=false;
                workflowDetail.Defence_Space__c=false;
            }
            if((newOpportunities.get(opp.Id).CBT_Tier_2__c!=null&&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c!=oldMap.get(opp.Id).CBT_Tier_2__c &&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c=='Airlines')) {
                workflowDetail.Airlines__c=true;
                workflowDetail.Airbus__c=false;
                workflowDetail.RACC__c=false;
                workflowDetail.Boeing__c=false;
                workflowDetail.HTSI__c=false;
            }
            else if((newOpportunities.get(opp.Id).CBT_Tier_2__c!=null&&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c!=oldMap.get(opp.Id).CBT_Tier_2__c &&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c=='Airbus')) {
                workflowDetail.Airlines__c=false;
                workflowDetail.Airbus__c=true;
                workflowDetail.RACC__c=false;
                workflowDetail.Boeing__c=false;
                workflowDetail.HTSI__c=false;
            }
            else if((newOpportunities.get(opp.Id).CBT_Tier_2__c!=null &&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c!=oldMap.get(opp.Id).CBT_Tier_2__c &&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c=='Boeing ATR')) {
                workflowDetail.Airlines__c=false;
                workflowDetail.Airbus__c=false;
                workflowDetail.RACC__c=false;
                workflowDetail.Boeing__c=true;
                workflowDetail.HTSI__c=false;
            }
            else if((newOpportunities.get(opp.Id).CBT_Tier_2__c!=null&&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c!=oldMap.get(opp.Id).CBT_Tier_2__c &&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c=='Components Business')) {
                workflowDetail.Airlines__c=false;
                workflowDetail.Airbus__c=false;
                workflowDetail.RACC__c=true;
                workflowDetail.Boeing__c=false;
                workflowDetail.HTSI__c=false;
            }
            else if((newOpportunities.get(opp.Id).CBT_Tier_2__c!=null&&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c!=oldMap.get(opp.Id).CBT_Tier_2__c &&
                    newOpportunities.get(opp.Id).CBT_Tier_2__c=='HTSI')) {
                workflowDetail.Airlines__c=false;
                workflowDetail.Airbus__c=false;
                workflowDetail.RACC__c=false;
                workflowDetail.Boeing__c=false;
                workflowDetail.HTSI__c=true;
            }
            else {
                workflowDetail.Airlines__c=false;
                workflowDetail.Airbus__c=false;
                workflowDetail.RACC__c=false;
                workflowDetail.Boeing__c=false;
                workflowDetail.HTSI__c=false;
            }
            if(newOpportunities.get(opp.Id).RecordTypeId!=null&&
                    newOpportunities.get(opp.Id).RecordTypeId!=oldMap.get(opp.Id).RecordTypeId &&
                    (newOpportunities.get(opp.Id).RecordTypeId==Label.AM_Catalog
                            || newOpportunities.get(opp.Id).RecordTypeId==Label.AM_Complex
                            || newOpportunities.get(opp.Id).RecordTypeId==Label.AM_Standard)) {
                workflowDetail.AM__c=true;
                workflowDetail.OE__c=false;
            }
            else if(newOpportunities.get(opp.Id).RecordTypeId!=null&&
                    newOpportunities.get(opp.Id).RecordTypeId!=oldMap.get(opp.Id).RecordTypeId &&
                    (newOpportunities.get(opp.Id).RecordTypeId==Label.OE_Complex
                            || newOpportunities.get(opp.Id).RecordTypeId==Label.OE_Standard)) {
                workflowDetail.AM__c=false;
                workflowDetail.OE__c=true;
            }
            else {
                workflowDetail.AM__c=false;
                workflowDetail.OE__c=false;
            }
            if(newOpportunities.get(opp.Id).AccountId!=null&&
                    newOpportunities.get(opp.Id).AccountId!=oldMap.get(opp.Id).AccountId) {
                workflowDetail.Customer_Name__c=newOpportunities.get(opp.Id).AccountId;
            }
            if((newOpportunities.get(opp.Id).Region__c!=null&&
                    newOpportunities.get(opp.Id).Region__c!=oldMap.get(opp.Id).Region__c &&
                    newOpportunities.get(opp.Id).Region__c=='Americas')) {
                workflowDetail.Americas__c=true;
                workflowDetail.APAC__c=false;
                workflowDetail.EMEAI__c=false;
                workflowDetail.Global__c=false;
            }
            else if((newOpportunities.get(opp.Id).Region__c!=null&&
                    newOpportunities.get(opp.Id).Region__c!=oldMap.get(opp.Id).Region__c &&
                    newOpportunities.get(opp.Id).Region__c=='Asia/Pacific Rim')) {
                workflowDetail.Americas__c=false;
                workflowDetail.APAC__c=true;
                workflowDetail.EMEAI__c=false;
                workflowDetail.Global__c=false;
            }
            else if((newOpportunities.get(opp.Id).Region__c!=null&&
                    newOpportunities.get(opp.Id).Region__c!=oldMap.get(opp.Id).Region__c &&
                    newOpportunities.get(opp.Id).Region__c=='Europe/MiddleEast/Africa/India')) {
                workflowDetail.Americas__c=false;
                workflowDetail.APAC__c=false;
                workflowDetail.EMEAI__c=true;
                workflowDetail.Global__c=false;
            }
            else {
                workflowDetail.Americas__c=false;
                workflowDetail.APAC__c=false;
                workflowDetail.EMEAI__c=false;
                workflowDetail.Global__c=true;
            }
            workflowDetailsToUpdate.add(workflowDetail);
        }
        return workflowDetailsToUpdate;
    }
    public static User getOpportunityOwner(Id ownerId) {
           return [
                    SELECT
                            Email,
                            Name
                    FROM User
                    WHERE Id  = :ownerId
                    LIMIT 1
                ];
    }
    
    public static void updateSalesSurveyQualified(List<Opportunity> opporutnites){
        List<Opportunity> qualifiedOpp = new List<Opportunity>();
        Set<Id> endUserAccounts = new Set<Id>();
        Map<id,String> recordTypeMap = new Map<id,String>();
        for(RecordType recordTypeRec:[select id,name from RecordType where name in ('BGA Operator','D&S Standard','D&S Standard FollowOn','AM Standard','AM Complex')]){
            recordTypeMap.put(recordTypeRec.id,recordTypeRec.name);
        }
        
        for(Opportunity oppRec:opporutnites){
            // Do this entire process only if "Sales Survey Qualified" is currently false.
            if(!oppRec.Sales_Survey_Qualified__c){
                qualifiedOpp.add(oppRec);
                endUserAccounts.add(oppRec.End_User__c);
                endUserAccounts.add(oppRec.AccountId);
            }
        }
        Map<Id,Account> endUserAccountMap = new Map<Id,Account>([select id,Country_Region__c,
                        ATR_Channel_Partner__c,BGA_Account__c,D_S_Channel_Partner__c from Account where id in:endUserAccounts]);
        for(Opportunity opp:opporutnites){
            if(!opp.Sales_Survey_Qualified__c){
                opp.Sales_Survey_Qualified__c = false;
                // ATR Case:
                if(opp.SBU__c == 'ATR' && !opp.Is_HAT__c && 
                    (opp.StageName =='Prospecting' || opp.StageName =='Cultivate' || opp.StageName =='Launch' || opp.StageName =='Propose' || opp.StageName =='Offer/Negotiate/Close')
                    && (recordTypeMap.get(opp.RecordTypeId)=='AM Standard' || recordTypeMap.get(opp.RecordTypeId)=='AM Complex')
                    && !endUserAccountMap.get(opp.AccountId).ATR_Channel_Partner__c
                    && !endUserAccountMap.get(opp.AccountId).BGA_Account__c
                    && !endUserAccountMap.get(opp.AccountId).D_S_Channel_Partner__c){
                    // Case 1:
                    if(opp.Pipeline_Amount__c >=1000000 && 
                        endUserAccountMap.get(opp.End_User__c).Country_Region__c == 'Americas'){
                        opp.Sales_Survey_Qualified__c = true;
                    }
                    // Case 2:
                    if(opp.Pipeline_Amount__c >=500000 && 
                        (endUserAccountMap.get(opp.End_User__c).Country_Region__c == 'Asia/Pacific Rim'
                        || endUserAccountMap.get(opp.End_User__c).Country_Region__c == 'Europe/MiddleEast/Africa/India')
                        ){
                        opp.Sales_Survey_Qualified__c = true;
                    }
                }
                
                // BGA Case:
                if(opp.SBU__c == 'BGA' && !opp.Is_HAT__c && opp.Sales_Type__c !='Completion'
                    && (opp.StageName =='Prospecting' || opp.StageName =='Cultivate' || opp.StageName =='Launch' || opp.StageName =='Propose' || opp.StageName =='Offer/Negotiate/Close')
                    && recordTypeMap.get(opp.RecordTypeId)=='BGA Operator'
                    && !endUserAccountMap.get(opp.AccountId).ATR_Channel_Partner__c
                    && !endUserAccountMap.get(opp.AccountId).BGA_Account__c
                    && !endUserAccountMap.get(opp.AccountId).D_S_Channel_Partner__c){
                    // Case 3:
                    if(opp.Pipeline_Amount__c >=40000 && 
                        (endUserAccountMap.get(opp.End_User__c).Country_Region__c == 'Americas'
                        || endUserAccountMap.get(opp.End_User__c).Country_Region__c == 'Asia/Pacific Rim'
                        || endUserAccountMap.get(opp.End_User__c).Country_Region__c == 'Europe/MiddleEast/Africa/India')
                        ){
                        opp.Sales_Survey_Qualified__c = true;
                    }
                }
                
                // D&S Case:
                if(opp.SBU__c == 'D&S' && !opp.Is_HAT__c 
                    && (opp.StageName =='Prospecting' || opp.StageName =='Cultivate' || opp.StageName =='Launch' || opp.StageName =='Propose' || opp.StageName =='Offer/Negotiate/Close')
                    && (recordTypeMap.get(opp.RecordTypeId)=='D&S Standard'
                        || recordTypeMap.get(opp.RecordTypeId)=='D&S Standard FollowOn')
                    && !endUserAccountMap.get(opp.AccountId).ATR_Channel_Partner__c
                    && !endUserAccountMap.get(opp.AccountId).BGA_Account__c
                    && !endUserAccountMap.get(opp.AccountId).D_S_Channel_Partner__c){
                    // Case 4:
                    if(opp.Pipeline_Amount__c >=100000 && 
                        (endUserAccountMap.get(opp.End_User__c).Country_Region__c == 'Asia/Pacific Rim'
                        || endUserAccountMap.get(opp.End_User__c).Country_Region__c == 'Europe/MiddleEast/Africa/India')
                        ){
                        opp.Sales_Survey_Qualified__c = true;
                    }
                }
            }
        }
    }

    
}