/***********************************************************************************************
Name:                   OpportunityTriggerHandler
Author:                 Satya Mohanty
Created Date:           1/8/2019
Use Case:               This class holds all trigger code for the Opportunity object.
                        It is fired by the trigger OpportunityMainTrigger
                        OWNED BY THE CRM SALES TEAM.
************************************************************************************************/
public class OpportunityTriggerHandler implements ITriggerHandler{
    private final String ACS_LABS = 'ACS Labs';
    private final String BENDIXKING = 'BendixKing';
    private final String PRODUCT_TESTING = 'Product Testing';
    private final String PROSPECTING = 'Prospecting';
    private final String OPPORTUNITY = 'Opportunity';
    private final String D_N_S = 'D&S';
    private final String M_PM_SIM_LICENSING = 'M&PM SIM Licensing';
    private final String ATR = 'ATR';
    private final String contactId = Label.UFR_Cont_Id;
    @TestVisible private final static String OPPORTUNITY = 'Opportunity';
    @TestVisible private static final String ENTER_A_VALUE = 'Please enter a value in this field.';
    private static Integer counta = 0;
    public void BeforeInsert(List<Opportunity> newOpportunities){
        try {
            System.debug('INTO BEFORE INSERT');
            /***
            * When a D&S user marks their new Opp as "Restricted", this process will remove the Opp Name, Accounts,
            * Program Name and description, overwrite them with the word "Restricted", then populate the values
            * into a secure section
            */
            Set<Id> parentOpps = new Set<Id>();
            for (Opportunity opp : newOpportunities) {
                parentOpps.add(opp.Parent_Opportunity__c);
            }
            Map<Id, Opportunity> parentOpportunities = new Map<Id, Opportunity> ([
                    SELECT
                            SBU__c,
                            Sales_Channel__c
                    FROM Opportunity
                    WHERE Id IN :parentOpps]);
            for (Opportunity opp : newOpportunities) {
                try {
                    if (opp.Parent_Opportunity__c != null) {
                        opp.Parent_Opportunity_SBU__c = parentOpportunities.get(opp.Parent_Opportunity__c).SBU__c;
                        opp.Parent_Opportunity_Sales_Channel__c = parentOpportunities.get(opp.Parent_Opportunity__c).Sales_Channel__c;
                    }
                    if (opp.Is_Restricted_Opportunity__c == true) {
                        OpportunityTriggerHelper.setRestrictedFields(opp);
                        OpportunityTriggerHelper.hideBaseFields(opp);
                    }

                    //If a new Aero Opp is created or cloned, make sure the first stage is Prospecting
                    if (opp.Opportunity_Type__c != BENDIXKING &&
                            opp.Opportunity_Type__c != ACS_LABS &&
                            opp.Opportunity_Type__c != M_PM_SIM_LICENSING &&
                            opp.Opportunity_Type__c != PRODUCT_TESTING) {
                        opp.StageName = PROSPECTING;

                    }
                    System.debug('record type ' + opp.Opportunity_Type__c );
                    //Tact Ai
                    if(!String.isBlank(opp.Next_Step__c))
                    {
                        if(opp.Next_Step_Date__c == null)
                        {
                            opp.Next_Step_Date__c = System.today();
                        }
                    }
                    if(!String.isBlank(opp.Log_Virtual_Meeting__c))
                    {
                        if(opp.Log_Virtual_Meeting_Date__c == null)
                        {
                            opp.Log_Virtual_Meeting_Date__c = System.today();
                        }
                    }
                    if(!String.isBlank(opp.Log_F2F_Meeting__c))
                    {
                        if(opp.Log_F2F_Meeting_Date__c == null)
                        {
                            opp.Log_F2F_Meeting_Date__c = System.today();
                        }
                    }
                    //Tact Ai end
                } catch (Exception ex) {
                    // Have to invoke those methods because of a known bug in APEX.
                    String additionalDescription = ex.getMessage() + '\n' + ex.getStackTraceString() + '\n' +
                            '\n' + 'Opportunity Name is ' + opp.Name + '\n';
                    throw new OpportunityTriggerHandlerException(additionalDescription, ex);
                }
            }
        } catch(Exception ex) {
            handleException(ex, newOpportunities);
        }
    }
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        System.debug('INTO BEFORE UPDATE');
        Map<Id, Opportunity> newMap = (Map<Id, Opportunity>) newItems;
        Map<Id, Opportunity> oldMap = (Map<Id, Opportunity>) oldItems;
        try {
            User user;
            if (UserInfo.getProfileId().substring(0,15) == Label.D_S_Partner_ProfileId) {
                user = OpportunityTriggerHelper.getUser(UserInfo.getUserId());
            }

            OppClassForPublicMethods objtemp = new OppClassForPublicMethods();
            objtemp.OppProvideAccessMethod(newMap.values(), oldMap);

            Set<Id> revenueDateOpportunities = new Set<Id>();
            for (Opportunity opportunity : newMap.values()) {
                System.debug('opportunity.Revenue_End_Date__c ' + opportunity.Revenue_End_Date__c);
                System.debug('opportunity.Revenue_Start_Date__c ' + opportunity.Revenue_Start_Date__c);
                System.debug('opportunity.SBU__c ' + opportunity.SBU__c);
                if (opportunity.Revenue_End_Date__c != null && opportunity.Revenue_Start_Date__c != null &&
                        opportunity.SBU__c != D_N_S) {
                    revenueDateOpportunities.add(opportunity.Id);
                }
                //Change Next_Step_Date__c to current date if it is null
                if(!String.isBlank(opportunity.Next_Step__c))
                {
                    if(opportunity.Next_Step_Date__c == null)
                    {
                        opportunity.Next_Step_Date__c = System.today();
                    }
                }
                //Change Log_Virtual_Meeting_Date__c to current date if it is null
                if(!String.isBlank(opportunity.Log_Virtual_Meeting__c))
                {
                    if(opportunity.Log_Virtual_Meeting_Date__c == null)
                    {
                        opportunity.Log_Virtual_Meeting_Date__c = System.today();
                    }
                }
                //Change Log_F2F_Meeting_Date__c to current date if it is null
                if(!String.isBlank(opportunity.Log_F2F_Meeting__c))
                {
                    if(opportunity.Log_F2F_Meeting_Date__c == null)
                    {
                        opportunity.Log_F2F_Meeting_Date__c = System.today();
                    }
                }
            }
            System.debug('revenueDateOpportunities are ' +revenueDateOpportunities);

            Map<Id, Date> schEndDateMap = new Map<Id, Date>();
            Map<Id, OpportunityLineItem> longSchDurationMap = new Map<Id, OpportunityLineItem>();
            Map<Id, Date> schStartDateMap = new Map<Id, Date>();
            if (revenueDateOpportunities.size() > 0) {
                List<OpportunityLineItem> lineItems = [
                        SELECT
                                Id,
                                Revenue_Start_Date__c,
                                Schedule_Type__c,
                                Terms_in_Months__c,
                                Revenue_End_Date__c,
                                OpportunityId
                        FROM OpportunityLineItem
                        WHERE OpportunityId IN:revenueDateOpportunities
                        ORDER BY Terms_in_Months__c DESC
                        LIMIT 50000
                ];
                if (lineItems.size() > 0) {
                    for (OpportunityLineItem lineItem : lineItems) {
                        if ((!(longSchDurationMap.containsKey(lineItem.OpportunityId)) && lineItem.Terms_in_Months__c != null)) {
                            longSchDurationMap.put(lineItem.OpportunityId, lineItem);
                            schStartDateMap.put(lineItem.OpportunityId, lineItem.Revenue_Start_Date__c);
                            schEndDateMap.put(lineItem.OpportunityId, lineItem.Revenue_End_Date__c);
                        } else if (lineItem.Terms_in_Months__c != null &&
                                longSchDurationMap.get(lineItem.OpportunityId).Terms_in_Months__c < lineItem.Terms_in_Months__c) {
                            longSchDurationMap.put(lineItem.OpportunityId, lineItem);
                            schStartDateMap.put(lineItem.OpportunityId, lineItem.Revenue_Start_Date__c);
                            schEndDateMap.put(lineItem.OpportunityId, lineItem.Revenue_End_Date__c);
                        }
                    }
                }
            }

            for (Opportunity opportunity : newMap.values()) {
                try {
                    opportunity.Owner_ID__c = opportunity.OwnerId;
                    // Sales Survey start
                    // Opportunity close stage is only allowed after sending a survey or reason for not sending survey is selected
                    if (newMap.size()== 1){ //Check if more than one record is being processed. Updates using data loader are allowed.
                        for (Opportunity opp : newMap.values()) {

                            if(oldMap.get(opp.Id).StageName != 'Closed Won' && oldMap.get(opp.Id).StageName != 'Closed Lost' &&
                                    oldMap.get(opp.Id).StageName != 'Closed Cancelled' &&
                                    oldMap.get(opp.Id).StageName != 'Won' && oldMap.get(opp.Id).StageName != 'Lost' && (opp.Qualified_Sales_Survey__c)
                                    && (opp.StageName == 'Won' || opp.StageName == 'Lost'
                                    || opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Cancelled')
                                    && opp.Sales_Survey_Sent__c == false && (opp.Reason_For_Not_Sending_Survey_Picklist__c == ''
                                    || opp.Reason_For_Not_Sending_Survey_Picklist__c == null))
                            {
                                opp.AutopopOff__c = true; //Enable Sales Survey popup
                                opp.StageName = oldMap.get(opp.Id).StageName; // Revrting to old  stage. Do not allow opportunity to close

                            }
                        }
                    }
                    // Sales Survey end

                    System.debug('#1 opportunity.RecordTypeId is ' + opportunity.RecordTypeId);
                    Opportunity oldOpportunity = oldMap.get(opportunity.Id);
                    /**
                 * If a non-spiral user updates a D&S Complex or Standard record, check certain proposal requirement
                 * fields for completion.
                 */
                    if (!OpportunityTriggerHelper.isSpiralUser() && UserInfo.getProfileId().substring(0,15) == Label.D_S_Partner_ProfileId) {
                        //Prevent partners from changing the Account or SBU on an opportunity
                        if (opportunity.AccountId != null && user != null & user.ContactId != null &&
                                user.Contact != null && user.Contact.Account != null &&
                                opportunity.AccountId != user.Contact.AccountId) {
                            opportunity.AccountId.addError('You cannot choose an Account other than' + user.Contact.Account.Name);
                        }
                        if (opportunity.SBU__c != D_N_S) {
                            opportunity.SBU__c.addError('SBU needs to be D&S');
                        }
                    }

                    /**
                * For C&PS Opps with a populated License Need Date, calculate the number of days between the Close Date
                * and End of Quarter date. Use this number to perform a formula that generates a priority # on the Opp.
                * Example: Diff is 15 days, priority would be 6
                */
                    if (opportunity.Record_Type_Name__c == M_PM_SIM_LICENSING) {
                        OpportunityTriggerHelper.handleMpmLicensing(opportunity, oldOpportunity);
                    } else if (opportunity.Record_Type_Name__c == 'D&S Standard' || opportunity.Record_Type_Name__c == 'D&S Complex') {
                        if (!OpportunityTriggerHelper.isSpiralUser()) {
                            //If a non-spiral user updates a D&S Complex or Standard record, check certain proposal requirement fields for completion
                            if (opportunity.StageName != 'Prospecting' && opportunity.StageName != 'Cultivate'
                                    && opportunity.StageName != 'Closed Cancelled') {
                                if (opportunity.RFP_Expected_Date__c == null) {
                                    opportunity.RFP_Expected_Date__c.addError(ENTER_A_VALUE);
                                }
                                if (opportunity.Proposal_Complexity_Description__c == null && opportunity.Proposal_Complexity__c != null) {
                                    opportunity.Proposal_Complexity_Description__c.addError(ENTER_A_VALUE);
                                }
                                if (opportunity.Certification_Requirements__c == null) {
                                    opportunity.Certification_Requirements__c.addError(ENTER_A_VALUE);
                                }
                            }
                        }
                    }

                    // Deactivate all closed cancelled opportunities so Spiral can ignore them.
                    if (opportunity.StageName == 'Closed Cancelled') {
                        opportunity.Active__c = false;
                    }
                    if (opportunity.Win_Only_Opportunity__c == True &&
                            (opportunity.StageName == 'Closed Won' ||
                                    opportunity.StageName == 'Closed Lost')) {
                        opportunity.Active__c = false;
                    }
                    if (opportunity.Record_Type_Name__c != oldOpportunity.Record_Type_Name__c) {
                        opportunity.Opportunity_Type__c = opportunity.Record_Type_Name__c;
                    }

                    // TODO: Don't delete this for now(05/22/19). Leaving this code as it's not 100% certain if we are not
                    // TODO: going to have to bring it back soon. - Nikolay Kolev
//                    opportunity.Total_Win_Loss_Amount__c = OpportunityTriggerHelper.getChildWinLoss(newMap.keySet());
//                    opportunity.Total_Win_Loss_Proposal_Amount__c = OpportunityTriggerHelper.getChildWinLossProposal(newMap.keySet());
//                    if (opportunity.StageName != 'Closed Lost'
//                            && opportunity.StageName != 'Closed Cancelled'
//                            && opportunity.StageName != 'Closed Channel Partner') {
//                        if (opportunity.Win_Loss_Amount__c != null) {
//                            opportunity.Total_Win_Loss_Amount__c = opportunity.Total_Win_Loss_Amount__c == null ?
//                                    opportunity.Win_Loss_Amount__c :
//                                    opportunity.Total_Win_Loss_Amount__c + opportunity.Win_Loss_Amount__c;
//                        }
//                        if (opportunity.Win_Loss_Proposal_Amount__c != null) {
//                            opportunity.Total_Win_Loss_Proposal_Amount__c = opportunity.Total_Win_Loss_Proposal_Amount__c == null?
//                                    opportunity.Win_Loss_Proposal_Amount__c :
//                                    opportunity.Total_Win_Loss_Proposal_Amount__c + opportunity.Win_Loss_Proposal_Amount__c;
//                        }
//                    }
                    System.debug('opportunity.Total_Win_Loss_Proposal_Amount__c is ' + opportunity.Total_Win_Loss_Proposal_Amount__c);
//                    opportunity.Total_Win_Amount__c = OpportunityTriggerHelper.getChildTotalWinLoss(newMap.keySet());
//                    opportunity.Total_Win_Proposal_Amount__c = OpportunityTriggerHelper.getChildTotalWinLossProposal(newMap.keySet());
//                    if (opportunity.IsWon == true) {
//                        if (opportunity.Win_Loss_Amount__c != null) {
//                            opportunity.Total_Win_Amount__c = opportunity.Total_Win_Amount__c == null ?
//                                    opportunity.Win_Loss_Amount__c :
//                                    opportunity.Total_Win_Amount__c + opportunity.Win_Loss_Amount__c;
//                        }
//                        if (opportunity.Win_Loss_Proposal_Amount__c != null) {
//                            opportunity.Total_Win_Proposal_Amount__c = opportunity.Total_Win_Proposal_Amount__c == null ?
//                                    opportunity.Win_Loss_Proposal_Amount__c :
//                                    opportunity.Total_Win_Proposal_Amount__c + opportunity.Win_Loss_Proposal_Amount__c;
//                        }
//                    }

                    if ((opportunity.Is_Restricted_Opportunity__c == true &&
                            opportunity.Is_Follow_On_Opportunity__c == true) &&
                            (oldOpportunity.Is_Restricted_Opportunity__c == false ||
                                    oldOpportunity.Is_Follow_On_Opportunity__c == false)) {
                        if (opportunity.Restricted_Opportunity_Name__c == null) {
                            OpportunityTriggerHelper.setRestrictedFields(opportunity);
                        }
                        OpportunityTriggerHelper.hideBaseFields(opportunity);
                        if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Catalog__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Catalog__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Catalog_FollowOn__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.D_S_Catalog_Restricted_FollowOn__c;
                        } else if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Complex__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Complex__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Competitive_FollowOn__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.D_S_Competitive_Restricted_FollowOn__c;
                        } else if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Standard__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Standard__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Non_Competitive_FollowOn__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.D_S_Non_Competitive_Restricted_FollowOn__c;
                        }
                    } else if ((opportunity.Is_Restricted_Opportunity__c == true &&
                            opportunity.Is_Follow_On_Opportunity__c == false) &&
                            (oldOpportunity.Is_Restricted_Opportunity__c == false ||
                                    oldOpportunity.Is_Follow_On_Opportunity__c == true)) {
                        if (opportunity.Restricted_Opportunity_Name__c == null) {
                            OpportunityTriggerHelper.setRestrictedFields(opportunity);
                        }
                        OpportunityTriggerHelper.hideBaseFields(opportunity);
                        if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Catalog__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Catalog_Restricted_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Catalog_FollowOn__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.Restricted_Catalog__c;
                        } else if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Complex__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Competitive_Restricted_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Competitive_FollowOn__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.Restricted_Complex__c;
                        } else if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Standard__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Non_Competitive_Restricted_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Non_Competitive_FollowOn__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.Restricted_Standard__c;
                        }
                    } else if ((opportunity.Is_Restricted_Opportunity__c == false &&
                            opportunity.Is_Follow_On_Opportunity__c == true) &&
                            (oldOpportunity.Is_Restricted_Opportunity__c == true ||
                                    oldOpportunity.Is_Follow_On_Opportunity__c == false)) {
                        OpportunityTriggerHelper.setFromRestrictedAccounts(oldMap, newMap, opportunity);

                        if (opportunity.Restricted_Opportunity_Name__c != null) {
                            opportunity.Name = opportunity.Restricted_Opportunity_Name__c;
                            opportunity.AccountId = opportunity.Account_Id__c;
                            opportunity.Program__c = opportunity.Restricted_Program_Name__c;
                            opportunity.Description = opportunity.Restricted_Comments_Description__c;
                            opportunity.End_User__c = opportunity.End_User_Id__c;
                            opportunity.Restricted_Opportunity_Name__c = '';
                            opportunity.Restricted_Customer_Name__c = '';
                            opportunity.Restricted_Program_Name__c = '';
                            opportunity.Restricted_Comments_Description__c = '';
                            opportunity.Restricted_End_User__c = '';
                        }
                        if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Catalog__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Catalog_Restricted_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Catalog__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.D_S_Catalog_FollowOn__c;
                        } else if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Complex__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Competitive_Restricted_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Complex__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.D_S_Competitive_FollowOn__c;
                        } else if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Standard__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Non_Competitive_Restricted_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Standard__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.D_S_Non_Competitive_FollowOn__c;
                        }
                    } else if (((opportunity.Is_Restricted_Opportunity__c == false) &&
                            (opportunity.Is_Follow_On_Opportunity__c == false)) &&
                            ((oldOpportunity.Is_Restricted_Opportunity__c == true) ||
                                    (oldOpportunity.Is_Follow_On_Opportunity__c == true))) {
                        OpportunityTriggerHelper.setFromRestrictedAccounts(oldMap, newMap, opportunity);
                        if (opportunity.Restricted_Opportunity_Name__c != null) {
                            opportunity.Name = opportunity.Restricted_Opportunity_Name__c;
                            opportunity.AccountId = opportunity.Account_Id__c;
                            opportunity.Program__c = opportunity.Restricted_Program_Name__c;
                            opportunity.Description = opportunity.Restricted_Comments_Description__c;
                            opportunity.End_User__c = opportunity.End_User_Id__c;
                            opportunity.Restricted_Opportunity_Name__c = '';
                            opportunity.Restricted_Customer_Name__c = '';
                            opportunity.Restricted_Program_Name__c = '';
                            opportunity.Restricted_Comments_Description__c = '';
                            opportunity.Restricted_End_User__c = '';
                        }
                        if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Catalog_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Catalog_Restricted_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Catalog__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.Catalog__c;
                        } else if (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Competitive_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Competitive_Restricted_FollowOn__c ||
                                opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Complex__c)
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.Complex__c ;
                        } else if ((opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Non_Competitive_FollowOn__c) ||
                                (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.D_S_Non_Competitive_Restricted_FollowOn__c) ||
                                (opportunity.RecordTypeId == OpportunityTriggerHelper.restrictedTypeList.Restricted_Standard__c))
                        {
                            opportunity.RecordTypeId = OpportunityTriggerHelper.restrictedTypeList.Standard__c;
                        }
                    }


                    if (revenueDateOpportunities.size() > 0) {
                        List<OpportunityLineItem> lineItems = [
                                SELECT
                                        Id,
                                        Revenue_Start_Date__c,
                                        Schedule_Type__c,
                                        Terms_in_Months__c,
                                        Revenue_End_Date__c,
                                        OpportunityId
                                FROM OpportunityLineItem
                                WHERE OpportunityId IN:revenueDateOpportunities
                                ORDER BY Terms_in_Months__c DESC
                                LIMIT 50000
                        ];
                        if (lineItems.size() > 0) {
                            if (schStartDateMap.get(opportunity.Id) != null && schEndDateMap.get(opportunity.Id) != null) {
                                Integer yearDifference = 0;
                                if (longSchDurationMap.get(opportunity.Id) != null &&
                                        longSchDurationMap.get(opportunity.Id).Schedule_Type__c != 'Yearly') {
                                    Integer daysDifference = 0;
                                    daysDifference = schStartDateMap.get(opportunity.Id).daysBetween(schEndDateMap.get(opportunity.Id));
                                    Decimal t = daysDifference / 365.0;
                                    Double d = t.setScale(0, System.RoundingMode.CEILING);
                                    yearDifference = d.intValue();
                                } else if (longSchDurationMap.get(opportunity.Id) != null &&
                                        longSchDurationMap.get(opportunity.Id).Schedule_Type__c == 'Yearly') {
                                    yearDifference = schEndDateMap.get(opportunity.Id).year() - schStartDateMap.get(opportunity.Id).year();
                                }

                                if (opportunity.Program_Terms__c != String.valueOf(yearDifference) &&
                                        opportunity.Program_Terms__c == oldMap.get(opportunity.Id).Program_Terms__c && yearDifference != 0) {
                                    opportunity.Program_Terms__c = String.valueOf(yearDifference);
                                } else if (yearDifference == 0) {
                                    opportunity.Program_Terms__c = '1';
                                } else if (opportunity.Program_Terms__c != String.valueOf(yearDifference) &&
                                        opportunity.Program_Terms__c != oldMap.get(opportunity.Id).Program_Terms__c &&
                                        oldMap.get(opportunity.Id).Program_Terms__c != null) {
                                    opportunity.addError('You can not change Program Term. Program Term will be auto populated based on Revenue Schedule.');
                                }
                            }

                            /*  if (opportunity.StageName == 'Closed Lost'
                                      || opportunity.StageName == 'Closed Cancelled'
                                      || opportunity.StageName == 'Closed Channel Partner') {
                                  opportunity.Pgo__c= '0';
                                  opportunity.PWin__c ='0';
                              } else if (opportunity.StageName == 'Closed Won') {
                                  opportunity.Pgo__c = '1';
                                  opportunity.PWin__c = '1';
                              }
                              System.debug(opportunity.Pgo__c+'===pgo==='+opportunity.PWin__c); */
                        }
                    }
                    if (opportunity.StageName == 'Closed Lost'
                            || opportunity.StageName == 'Closed Cancelled'
                            || opportunity.StageName == 'Closed Channel Partner') {
                        opportunity.Pgo__c= '0';
                        opportunity.PWin__c ='0';
                    } else if (opportunity.StageName == 'Closed Won') {
                        opportunity.Pgo__c = '1';
                        opportunity.PWin__c = '1';
                    }

                    // Start - Logic added related to Parent Opportunity
                    Map<String,id> recordTypeMap = new Map<String,id>();
                    Set<Id> AMSet = new Set<Id>();
                    for(RecordType rec:[select id,name from RecordType where name in ('AM Complex','AM Catalog','AM Standard','AM FollowOn')]){
                        recordTypeMap.put(rec.name,rec.id);
                        if(rec.name.equalsIgnoreCase('AM Complex') ||
                                rec.name.equalsIgnoreCase('AM Catalog')||
                                rec.name.equalsIgnoreCase('AM Standard')){
                            AMSet.add(rec.id);
                        }
                    }
                    Map<id,String> oldRecordTypes = new Map<id,String>();

                    for(OpportunityFieldHistory hist :[select id,Field,OldValue,NewValue,OpportunityId from OpportunityFieldHistory where OpportunityId in :newMap.keySet() and Field='Opportunity_Type__c' order by CreatedDate desc]) {
                        if(oldRecordTypes.get(hist.OpportunityId) == null){
                            oldRecordTypes.put(hist.OpportunityId,(String)hist.NewValue);
                        }
                    }
                    for (Opportunity opp : newMap.values()) {
                        if(opp.Parent_Opportunity__c != null && opp.Is_Follow_On_Opportunity__c && opp.Win_Only_Opportunity__c && AMSet.contains(opp.RecordTypeId)){
                            opp.RecordTypeId = recordTypeMap.get('AM FollowOn');
                        }
                        if(recordTypeMap.get('AM FollowOn') == opp.RecordTypeId && opp.Parent_Opportunity__c == null && !opp.Is_Follow_On_Opportunity__c && !opp.Win_Only_Opportunity__c){
                            if(oldRecordTypes.get(opp.id) != null && recordTypeMap.get(oldRecordTypes.get(opp.id)) != null){
                                opp.RecordTypeId = recordTypeMap.get(oldRecordTypes.get(opp.id));
                            }
                        }
                    }
                    // End - Logic added related to Parent Opportunity

                    System.debug(opportunity.Pgo__c+'===pgo==='+opportunity.PWin__c);
                } catch (Exception ex) {
                    // Have to invoke those methods because of a known bug in APEX.
                    String additionalDescription = ex.getMessage() + '\n' + ex.getStackTraceString() + '\n' +
                            '\n' + 'Opportunity Id is ' + opportunity.Id + '\n';
                    throw new OpportunityTriggerHandlerException(additionalDescription, ex);
                }
            }
        } catch(Exception ex) {
            handleException(ex, newMap.values());
        }
    }

    public void BeforeDelete(Map<Id, SObject> oldItems) {}

    public void AfterInsert(Map<Id, SObject> newItems) {
        System.debug('INTO AFTER INSERT');

        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();

        Map<Id, Opportunity> newMap = (Map<Id, Opportunity>) newItems;
        try {
            Set<Id> accountIds = new Set<Id>();
            Set<Id> userIds = new Set<Id>();

            for (Opportunity opp : newMap.values()) {
                accountIds.add(opp.AccountId);
                userIds.add(opp.OwnerId);
            }
            List<Account> accounts = new List<Account>();
            accounts = [
                    SELECT
                            Id,
                            Account_Owner__c,
                            Account_Owner__r.Functional_Role__c,
                            Account_Owner__r.IsActive
                    FROM Account
                    WHERE Id IN:accountIds
            ];

            Map<Id, User> usersForSalesTeam = new Map<Id,User> ([
                    SELECT
                            IsActive
                    FROM User
                    WHERE Id IN :userIds
            ]);

            List<Opportunity_Sales_Team__c> oppSalesTeamList = new List<Opportunity_Sales_Team__c>();
            for (Opportunity opp : newMap.values()) {
                Opportunity_Sales_Team__c salesTeamToInsert = new Opportunity_Sales_Team__c();
                for (Account account : accounts) {
                    if (account.Id == opp.AccountId) {
                        if (opp.SBU__c == ATR) {
                            salesTeamToInsert.Opportunity_Team_Role__c = account.Account_Owner__r.Functional_Role__c;
                            salesTeamToInsert.Opportunity__c = opp.Id;
                            salesTeamToInsert.User__c = account.Account_Owner__c;
                            if (account.Account_Owner__r.IsActive) {
                                oppSalesTeamList.add(salesTeamToInsert);
                            }
                        }
                    }
                }
                salesTeamToInsert = new Opportunity_Sales_Team__c();
                salesTeamToInsert.Opportunity__c = opp.Id;
                salesTeamToInsert.User__c = opp.OwnerId;
                if (usersForSalesTeam.get(opp.OwnerId).IsActive) {
                    oppSalesTeamList.add(salesTeamToInsert);
                }
            }
            //Add new Task (Customer Status or Next Step) when Customer Status / Next Step is changed
            for (Opportunity opp : newMap.values()) {
                if(!String.isBlank(opp.Status__c))
                {
                    Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Status').getRecordTypeId();

                    Task newCustomerStatusTask = new Task(
                            RecordTypeId = recTypeId,
                            Subject = 'Customer Status',
                            WhatId = opp.Id,
                            //This is the default..
                            OwnerId = UserInfo.getUserId(),
                            Status = 'Completed',
                            Type = 'Call',
                            Description = opp.Status__c,
                            ActivityDate = System.today(),
                            Activity_Date__c = System.today(),
                            CreatedDate = System.now());

                    insert newCustomerStatusTask;
                }

                if(!String.isBlank(opp.Next_Step__c))
                {
                    Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

                    Task newNextStepTask = new Task(
                            RecordTypeId = recTypeId,
                            Subject = 'Next Step',
                            WhatId = opp.Id,
                            //This is the default..
                            OwnerId = UserInfo.getUserId(),
                            Status = 'Completed',
                            Type = 'Call',
                            Description = opp.Next_Step__c,
                            ActivityDate = opp.Next_Step_Date__c,
                            Activity_Date__c = opp.Next_Step_Date__c,
                            CreatedDate = System.now()
                    );

                    insert newNextStepTask;
                }

                if(!String.isBlank(opp.Log_Virtual_Meeting__c))
                {
                    Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log Virtual Meeting').getRecordTypeId();

                    Task newLogVirtualMeetingTask = new Task(
                            RecordTypeId = recTypeId,
                            Subject = 'Log Virtual Meeting',
                            WhatId = opp.Id,
                            //This is the default..
                            OwnerId = UserInfo.getUserId(),
                            Status = 'Completed',
                            Type = 'Call',
                            Description = opp.Log_Virtual_Meeting__c,
                            ActivityDate = opp.Log_Virtual_Meeting_Date__c,
                            Activity_Date__c = opp.Log_Virtual_Meeting_Date__c,
                            CreatedDate = System.now()
                    );

                    insert newLogVirtualMeetingTask;
                }
                if(!String.isBlank(opp.Log_F2F_Meeting__c))
                {
                    Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log F2F Meeting').getRecordTypeId();

                    Task newLogF2FMeetingTask = new Task(
                            RecordTypeId = recTypeId,
                            Subject = 'Log F2F Meeting',
                            WhatId = opp.Id,
                            //This is the default..
                            OwnerId = UserInfo.getUserId(),
                            Status = 'Completed',
                            Type = 'Call',
                            Description = opp.Log_F2F_Meeting__c,
                            ActivityDate = opp.Log_F2F_Meeting_Date__c,
                            Activity_Date__c = opp.Log_F2F_Meeting_Date__c,
                            CreatedDate = System.now()
                    );

                    insert newLogF2FMeetingTask;
                }
            }
            //Add new task end
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
            List<Messaging.SingleEmailMessage> bulkEmails1 = new List<Messaging.SingleEmailMessage>();
            Map<Id, Opportunity> fullOpportunityMap = OpportunityTriggerHelper.getOpportunities(newMap.keySet());
            for (Opportunity opp2 : newMap.values()) {
                Opportunity fullOpp = fullOpportunityMap.get(opp2.Id);
                if ((fullOpp.License_Draft__c != null
                        && fullOpp.License_Draft__c == Date.today())
                        && (fullOpp.Record_Type_Name__c == M_PM_SIM_LICENSING)) {
                    if (fullOpp.Record_Data_Owner__c != null) {
                        msg.setTargetObjectId(fullOpp.Record_Data_Owner__c);
                        msg.setTemplateId(Label.Sim_License_Appendix_Eng);
                        msg.setWhatId(fullOpp.Id);
                        msg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{msg});
                    } else if (fullOpp.BusinessContact__c != null) {
                        if (!System.Test.isRunningTest()) {
                            msg.setTargetObjectId(contactId);
                        } else {
                            msg.setTargetObjectId(fullOpp.BusinessContact__r.ContactId);
                        }
                        msg.setSaveAsActivity(false);
                        msg.setTemplateId(Label.Sim_License_Acct_Mng);
                        msg.setWhatId(fullOpp.Id);
                        msg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                        msgList.add(msg);
                        String[] toAddresses = new String[]{
                                fullOpp.BusinessContact__r.Email
                        };
                        Savepoint sp = Database.setSavepoint();
                        if (msg.getTemplateId() != null) {
                            Messaging.sendEmail(msgList);
                        }
                        Database.rollback(sp);
                        if (msgList.size() > 0) {
                            for (Messaging.SingleEmailMessage email : msgList) {
                                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                                emailToSend.setToAddresses(toAddresses);
                                emailToSend.setPlainTextBody(email.getPlainTextBody());
                                emailToSend.setHtmlBody(email.getHtmlBody());
                                emailToSend.setSubject(email.getSubject());
                                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                                if (emailToSend.getHtmlBody() != null) {
                                    bulkEmails1.add(emailToSend);
                                }
                            }
                        }
                    }
                }
            }
            if (bulkEmails1.size() > 0) {
                Messaging.sendEmail(bulkEmails1);
            }
            Messaging.reserveSingleEmailCapacity(Trigger.size);
//            Messaging.sendEmail(bulkEmails);

            OppClassForPublicMethods objtemp = new OppClassForPublicMethods();
            List<Opportunity_Sales_Team__c> tempOpprofileList = objtemp.Opportunity_insert_opportunityteam(newMap.values(), null);
            System.debug('tempOpprofileList is ' + tempOpprofileList);
            for (Opportunity_Sales_Team__c oteam: tempOpprofileList) {
                System.debug('oteam is ' + oteam);
            }

            if (null != tempOpprofileList && tempOpprofileList.size() > 0) {
                oppSalesTeamList.addAll(tempOpprofileList);
            }
            if (oppSalesTeamList.size() > 0) {
                System.debug('oppSalesTeamList is ' + oppSalesTeamList);
                insert oppSalesTeamList;
            }

            // Added to fix the linking opportunity and lead record.

            //Added code for leadupadate
            if(newMap.values().size()==1){
                Opportunity opp = newMap.values().get(0);
                if(opp.Lead_ID__c != null){
                    Lead leadRec = [SELECT Id,
                            Opportunity_Name__c,
                            Event__c
                    FROM Lead
                    WHERE Id=:opp.Lead_ID__c];
                    leadRec.Opportunity_Name__c = opp.Id;
                    //leadRec.Opportunity_Search_Confirmation__c = false;
                    update leadRec;

                    //Insert record in Event_and_Opportunity__c
                    if(leadRec.Event__c != null)
                    {
                        System.debug('leadRec.Event__c');
                        List<Event_and_Opportunity__c> eopp_query = [SELECT Event__c,Opportunity__c FROM Event_and_Opportunity__c WHERE Event__c=:leadRec.Event__c AND Opportunity__c=:opp.Id];

                        if(eopp_query.size() == 0)
                        {
                            Event_and_Opportunity__c eopp = new Event_and_Opportunity__c();
                            eopp.Opportunity__c = opp.Id;
                            eopp.Event__c = leadRec.Event__c;
                            insert eopp;
                            System.debug('Inserted new record in Event_and_Opportunity__c:');
                        }
                    }

                }
            }
        } catch(Exception ex) {
            System.debug('exception is ' + ex.getMessage());
            System.debug('exception stack trace is ' + ex.getStackTraceString());
            handleException(ex, newMap.values());
        }
    }
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems){
        System.debug('IN AFTER UPDATE');

        Map<Id, Opportunity> newMap = (Map<Id, Opportunity>) newItems;
        Map<Id, Opportunity> oldMap = (Map<Id, Opportunity>) oldItems;
        List<SObject> objectsToDelete = new List<SObject>();
        List<SObject> objectsToInsert = new List<SObject>();
        List<SObject> objectsToUpdate = new List<SObject>();

        List<AccountTeamMember> list_accteam = new List<AccountTeamMember >();
        List<String> list_prdName = new List<String>();
        List<String> list_prodName = new List<String>();
        List<PO_tracker_Case_Creation_Products__c>polist= new List<PO_tracker_Case_Creation_Products__c>();
        Set<Id> set_opp = new Set<Id>();
        Map<Id,Id> map_accid = new Map<Id,Id>();
        Map<Id,Opportunity> map_acc = new Map<Id,Opportunity>();
        Map<Id,Id> map_accteam = new Map<Id,Id>();
        Map<Id,List<Product2>> map_opportunityProductlist = new Map<Id,List<Product2>>();
        Map<String,String> map_prodOpp = new Map<String,String>();

        Boolean bool_trans = true;
        Boolean bool = false;

        try {
            Id recordtypeId = Label.RMU_EIS_Record_type;
            List<OpportunityLineItem> lineItems = OpportunityTriggerHelper.getLineItems(newMap.keySet());

            Map<Id, Opportunity> opportunities = OpportunityTriggerHelper.getOpportunities(newMap.keySet());
            System.debug('opportunities are ' + opportunities);

            User opportunityOwner;
            if (Trigger.new.size() == 1) {
                for (Id oppId : newMap.keySet()) {
                    opportunityOwner = OpportunityTriggerHelper.getOpportunityOwner(newMap.get(oppId).OwnerId);
                }
            }
            User opportunityOldOwner;
            if (Trigger.new.size() == 1) {
                for (Id oppId : oldMap.keySet()) {
                    opportunityOldOwner = OpportunityTriggerHelper.getOpportunityOwner(oldMap.get(oppId).OwnerId);
                }
            }
            if (!StopRecursivecall.hasUpdate_OnBehalfendUserStatus() || Test.isRunningTest() ) {
                StopRecursivecall.setUpdate_OnBehalfendUserStatus();
                for (OpportunityLineItem lineItem : lineItems) {
                    Opportunity newOpp = newMap.get(lineItem.OpportunityId);
                    Opportunity oldOpp = oldMap.get(lineItem.OpportunityId);
                    if (newMap.get(lineItem.OpportunityId).Pgo__c != null && newMap.get(lineItem.OpportunityId).PWin__c != null) {
                        lineItem.Probability__c = (Decimal.valueOf(newMap.get(lineItem.OpportunityId).Pgo__c) *
                                Decimal.valueOf(newMap.get(lineItem.OpportunityId).PWin__c)) * 100;
                    }
                    if (newMap.get(lineItem.OpportunityId).StageName == 'Closed Cancelled') {
                        lineItem.Active__c = false;
                    }

                    if (Trigger.new.size() == 1 && newOpp.CloseDate != oldOpp.CloseDate && newOpp.Push_Product_Date__c) {
                        if (lineItem.ServiceDate != null && lineItem.Type__c == 'Forecast') {
                            lineItem.ServiceDate = lineItem.ServiceDate + oldOpp.CloseDate.daysBetween(newOpp.CloseDate);
                        }
                    }
                }
                if (lineItems.size() > 0) {
                    objectsToUpdate.addAll(lineItems);
                }
            }

            List<Opportunity_Sales_Team__c> salesTeams = new List<Opportunity_Sales_Team__c>();
            Set<Id> mpmLicensingOpportunities = new Set<Id>();
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
            List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
            for (Opportunity opp : newMap.values()) {
                if ((opp.OwnerId != null && opp.OwnerId != oldMap.get(opp.Id).OwnerId) ||
                        (opp.SBU__c != null && opp.SBU__c != oldMap.get(opp.Id).SBU__c) ||
                        (opp.Name != null && opp.Name != oldMap.get(opp.Id).Name) ||
                        (opp.CBT_Tier_2__c != null && opp.CBT_Tier_2__c != oldMap.get(opp.Id).CBT_Tier_2__c) ||
                        (opp.Record_Type_Name__c != null && opp.Record_Type_Name__c != oldMap.get(opp.Id).Record_Type_Name__c) ||
                        (opp.AccountId != null && opp.AccountId != oldMap.get(opp.Id).AccountId) ||
                        (opp.Region__c != null && opp.Region__c != oldMap.get(opp.Id).Region__c)) {
                    objectsToUpdate.addAll(
                            OpportunityTriggerHelper.setWorkflowDetails(
                                    newMap,
                                    oldMap,
                                    opp,
                                    opportunities.get(opp.Id).Workflow_details__r)
                    );
                }
                if (oldMap.get(opp.Id).dealer_account__c != opp.dealer_account__c
                        || oldMap.get(opp.Id).OwnerId != opp.OwnerId) {
                    for (Case theCase : opportunities.get(opp.Id).Cases__r) {
                        if (oldMap.get(opp.Id).dealer_account__c != opp.dealer_account__c) {
                            theCase.BGA_Dealer_Name__c = opportunities.get(opp.Id).dealer_account__r.Name;
                        }
                        if (oldMap.get(opp.Id).OwnerId != opp.OwnerId) {
                            theCase.Opportunity_Owner__c = opportunities.get(opp.Id).OwnerId;
                        }
                        objectsToUpdate.add(theCase);
                    }
                }
                if (((opp.StageName != oldMap.get(opp.Id).StageName) ||
                        (opp.Deal_Status__c != oldMap.get(opp.Id).Deal_Status__c) ||
                        (opp.CloseDate != oldMap.get(opp.Id).CloseDate) ||
                        (opp.Total_Value_of_Agmt_K_Text__c != oldMap.get(opp.Id).Total_Value_of_Agmt_K_Text__c) ||
                        (opp.Contract_Term_In_Years__c != oldMap.get(opp.Id).Contract_Term_In_Years__c) ||
                        (opp.Value_in_Q1_K_Text__c != oldMap.get(opp.Id).Value_in_Q1_K_Text__c) ||
                        (opp.Value_in_Q2_K_Text__c != oldMap.get(opp.Id).Value_in_Q2_K_Text__c) ||
                        (opp.Value_in_Q3_K_Text__c != oldMap.get(opp.Id).Value_in_Q3_K_Text__c) ||
                        (opp.Value_in_Q4_K_Text__c != oldMap.get(opp.Id).Value_in_Q4_K_Text__c) ||
                        (opp.Year_2__c != oldMap.get(opp.Id).Year_2__c) ||
                        (opp.Year_3__c != oldMap.get(opp.Id).Year_3__c) ||
                        (opp.Year_4__c != oldMap.get(opp.Id).Year_4__c) ||
                        (opp.Year_5__c != oldMap.get(opp.Id).Year_5__c) ||
                        (opp.HIPI_Accounts__c != oldMap.get(opp.Id).HIPI_Accounts__c) ||
                        (opp.BusinessContact__c != oldMap.get(opp.Id).BusinessContact__c) ||
                        (opp.Value_in_Current_Year_Jan_Dec_K__c != oldMap.get(opp.Id).Value_in_Current_Year_Jan_Dec_K__c)) &&
                        (opp.Record_Type_Name__c == M_PM_SIM_LICENSING) &&
                        (opp.Corp_HIPI_Opportunity_Number__c != null)) {
                    mpmLicensingOpportunities.add(opp.Id);
                }
                if ((opp.Submit_to_Licensing__c != oldMap.get(opp.Id).Submit_to_Licensing__c)
                        && (opp.Record_Type_Name__c == M_PM_SIM_LICENSING)
                        && (opp.Corp_HIPI_Opportunity_Number__c == null)) {
                    mpmLicensingOpportunities.add(opp.Id);
                }
                if (AvoidRecursion.isFirstRun() || Test.isRunningTest()) {
                    System.debug('opp.License_Draft__c is ' + opp.License_Draft__c);
                    System.debug('oldMap.get(opp.Id).License_Draft__c is ' + oldMap.get(opp.Id).License_Draft__c);
                    System.debug('opp.Record_Type_Name__c is ' + opp.Record_Type_Name__c);
                    if (((opp.License_Draft__c != null && opp.License_Draft__c == Date.today())
                            && (opp.License_Draft__c != oldMap.get(opp.Id).License_Draft__c)
                            && (opp.Record_Type_Name__c == M_PM_SIM_LICENSING))) {
                        if (opp.Record_Data_Owner__c != null) {
                            msg.setTargetObjectId(opp.Record_Data_Owner__c);
                            msg.setTemplateId(Label.Sim_License_Appendix_Eng);
                            msg.setWhatId(opp.Id);
                            msg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
                                    msg
                            });
                        }else if (opp.BusinessContact__c != null && (opp.Engineer_Manager_Review__c == false)) {
                            if (!System.Test.isRunningTest()) {
                                msg.setTargetObjectId(contactId);
                            } else {
                                msg.setTargetObjectId(opportunities.get(opp.Id).BusinessContact__r.ContactId);
                            }
                            msg.setSaveAsActivity(false);
                            msg.setTemplateId(Label.Sim_License_Acct_Mng);
                            msg.setWhatId(opp.Id);
                            msg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                            msgList.add(msg);

                            String[] toAddresses = new String[]{
                                    opportunities.get(opp.Id).BusinessContact__r.Email
                            };
                            Savepoint sp = Database.setSavepoint();
                            if (msg.getTemplateId() != null) {
                                Messaging.sendEmail(msgList);
                            }
                            Database.rollback(sp);
                            if (msgList.size() > 0) {
                                for (Messaging.SingleEmailMessage email : msgList) {
                                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                                    emailToSend.setToAddresses(toAddresses);
                                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                                    emailToSend.setHtmlBody(email.getHtmlBody());
                                    emailToSend.setSubject(email.getSubject());
                                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                                    if (emailToSend.getHtmlBody() != null) {
                                        bulkEmails.add(emailToSend);
                                    }

                                }
                            }
                        }
                    }
                    if (((opp.Engineer_Manager_Review_Date__c != null) &&
                            (opp.Engineer_Manager_Review_Date__c != oldMap.get(opp.Id).Engineer_Manager_Review_Date__c) &&
                            (opp.Record_Type_Name__c == M_PM_SIM_LICENSING))) {
                        if (opp.BusinessContact__c != null) {
                            System.debug('opp.BusinessContact__c  is ' + opp.BusinessContact__c );
                            if (!System.Test.isRunningTest()) {
                                msg.setTargetObjectId(contactId);
                            } else {
                                msg.setTargetObjectId(opportunities.get(opp.Id).BusinessContact__r.ContactId);
                            }
                            msg.setSaveAsActivity(false);
                            msg.setTemplateId(Label.Sim_License_Acct_Mng);
                            msg.setWhatId(opp.Id);
                            msg.setOrgWideEmailAddressId(Label.AeroNo_Reply_email_ID);
                            msgList.add(msg);
                            System.debug('msgList is ' + msgList);
                            String[] toAddresses = new String[]{
                                    opportunities.get(opp.Id).BusinessContact__r.Email
                            };
                            Savepoint sp = Database.setSavepoint();
                            if (msg.getTemplateId() != null) {
                                Messaging.sendEmail(msgList);
                            }
                            Database.rollback(sp);
                            if (msgList.size() > 0) {
                                for (Messaging.SingleEmailMessage email : msgList) {
                                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                                    emailToSend.setToAddresses(toAddresses);
                                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                                    emailToSend.setHtmlBody(email.getHtmlBody());
                                    emailToSend.setSubject(email.getSubject());
                                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                                    if (emailToSend.getHtmlBody() != null) {
                                        bulkEmails.add(emailToSend);
                                    }
                                }
                            }
                        }
                    }
                    if (bulkEmails.size() > 0) {
                        System.debug('Email Final Entry*****' + bulkEmails.size());
                        Messaging.sendEmail(bulkEmails);
                    }
                    if (mpmLicensingOpportunities.size() > 0) {
                        // TODO: Needs to be moved into an ETL process or at least move to a scheduled batch job
                        CallServicetoCreateClass1.classService(mpmLicensingOpportunities);
                    }
                }
                /**
             * This logic should only run if the opportunity is being edited through the Salesforce UI, not in bulk.
             * There's different process that will handle the sharing for opportunities that get updated in bulk.
             * Ask Satya Mohanty for details.
             */
                if (Trigger.new.size() == 1) {
                    /**
             * Handle the opportunity team logic.
             * This cannot be moved to the helper method because of the addError() lack of support outside of the trigger
             * during unit test code.
             */
                    // TODO: The opportunity team trigger will try to update the opportunity and create a loop. See if you can fix this logic somehow.
                    if (opp.OwnerId != oldMap.get(opp.Id).OwnerId) {
                        Boolean teamMemberExists = false;
                        for (Opportunity_Sales_Team__c salesTeam : opportunities.get(opp.Id).Opportunity_Sales_Teams__r) {
                            OpportunityShare opportunityShare = new OpportunityShare();
                            if (salesTeam.User__c != null) {
                                opportunityShare.UserOrGroupId = salesTeam.User__c;
                            }
                            opportunityShare.OpportunityAccessLevel = 'Edit';
                            opportunityShare.OpportunityId = salesTeam.Opportunity__c;
                            if (salesTeam.User__r.IsPortalEnabled == true) {
                                opp.addError('Found Portal User in Opportunity team. Please remove ' + salesTeam.User__r.Name + ' from Opportunity Team.');
                            } else if (salesTeam.Is_User_Active__c == 'True'
                                    && salesTeam.User__c != salesTeam.Opportunity_Owner_Id__c) {
                                objectsToInsert.add(opportunityShare);
                            }
                            if (salesTeam.Opportunity__c == opp.Id && salesTeam.User__c == opp.OwnerId) {
                                teamMemberExists = true;
                            }
                        }
                        if (teamMemberExists == false) {
                            Opportunity_Sales_Team__c teamMember = new Opportunity_Sales_Team__c();
                            teamMember.Opportunity__c = opp.Id;
                            teamMember.User__c = opp.OwnerId;
                            salesTeams.add(teamMember);
                        }

                    }
                    if ((
                            (opp.Is_Restricted_Opportunity__c == true &&
                                    opp.Is_Follow_On_Opportunity__c == true) &&
                                    (oldMap.get(opp.Id).Is_Restricted_Opportunity__c == false || oldMap.get(opp.Id).Is_Follow_On_Opportunity__c == false))
                            ||
                            ((opp.Is_Restricted_Opportunity__c == true && opp.Is_Follow_On_Opportunity__c == false) &&
                                    (oldMap.get(opp.Id).Is_Restricted_Opportunity__c == false ||
                                            oldMap.get(opp.Id).Is_Follow_On_Opportunity__c == true))
                            ) {
                        objectsToDelete.addAll(opportunities.get(opp.Id).Shares);
                    }

                    //Adding new logic for opportunity owner get notification whenever owner field is modified
                    system.debug('checking opportunity owner change email');

                    Id profileId = UserInfo.getProfileId();
                    String profileName =[SELECT Id, Name FROM Profile WHERE Id=:profileId].Name;

                    if (!OpportunityTriggerHelper.isSpiralUser() &&
                            UserInfo.getName() != opportunityOldOwner.Name &&
                            opportunityOldOwner != opportunityOwner  &&
                            (profileName != 'System Administrator' && profileName != 'Sales Admin')) {
                        //if(opportunityOldOwner != opportunityOwner){
                        if (counta ==0 && opp.Opportunity_Type__c != BENDIXKING &&
                                opp.Opportunity_Type__c != ACS_LABS &&
                                opp.Opportunity_Type__c != M_PM_SIM_LICENSING) {
                            counta = 1;
                            String serverUrl = Url.getSalesforceBaseUrl().toExternalForm() + '/';
                            String htmlHeader = '<html><head>' +
                                    '<style>.tableborder{   border-bottom:3px solid #e39321;}.fontlabel{ ' +
                                    'font-family:Arial, Helvetica, sans-serif; color:#333; font-size:100%;}</style>' +
                                    '</head><body class=fontlabel>';
                            String htmlFooter = '</body></html>';

                            String htmlBdy = 'Dear Opportunity Owner: '+ opportunityOldOwner.Name +',<br><br><br> For your information, ' +
                                    'changes have been made to an Opportunity you own, ' +
                                    '</a><br><br> </n></n>Please review the Opportunity History on the Opportunity : <a href='
                                    + serverUrl + opp.Id + '>' + opp.Name + '</a><br><br> </n></n>Opportunity' +
                                    ' has been reassigned to '+ opportunityOwner.Name;


                            List<String> emailList = new List<String>();
                            if (opportunityOldOwner != null && String.isNotBlank(opportunityOldOwner.Email)) {
                                emailList.add(opportunityOldOwner.Email);

                            }
                            System.debug('email ids are===='+emailList);

                            htmlBdy = htmlBdy + '</a><br><br> </n></n>Contact the last modified by if you' +
                                    ' have any questions or concerns. <br><br><br></n></n>Thank you.';
                            if (emailList != null && emailList.size() > 0) {
                                sendEmail.SendSimpleEmailNotification(emailList,
                                        'Opportunity updated: ' + opp.Name,
                                        htmlHeader + htmlBdy + htmlFooter);

                            }
                            // }
                            //}
                        }
                    }
                    //end
                    OppClassForPublicMethods objtemp = new OppClassForPublicMethods();
                    objectsToInsert.addAll(objtemp.Opportunity_insert_opportunityteam(newMap.values(), oldMap));

                    if (salesTeams.size() > 0) {
                        objectsToInsert.addAll(salesTeams);
                    }
                    if (oldMap.get(opp.Id).StageName != newMap.get(opp.Id).StageName && opp.StageName == 'Closed Won') {
                        set_opp.add(opp.Id);
                        map_acc.put(opp.Id, opp);
                        map_accid.put(opp.AccountId, opp.Id);
                        bool = true;
                    }
                }
            }
            // EmailAlertOnOpportunityUpdates //
            if (Trigger.new.size() == 1) {
                //query all related opp product
                if (bool == true && bool_trans == true) {
                    List<OpportunityLineItem> list_oppprd = [
                            SELECT
                                    Id,
                                    OpportunityId,
                                    PricebookEntry.Product2Id,
                                    PricebookEntry.Product2.Name
                            FROM OpportunityLineItem
                            WHERE OpportunityId
                                    IN:set_opp
                    ];
                    for (OpportunityLineItem p : list_oppprd) {
                        list_prdName.add(p.PricebookEntry.Product2.Name);
                        map_prodOpp.put(p.PricebookEntry.Product2.Name, p.OpportunityId);
                    }
                    //refined product list present in custom setting responible for case creation
                    polist = [
                            SELECT
                                    Name,
                                    Product_Name_del__c
                            FROM PO_tracker_Case_Creation_Products__c
                            WHERE Product_Name_del__c
                                    IN:list_prdName
                    ];
                    for (PO_tracker_Case_Creation_Products__c p : polist) {
                        list_prodName.add(p.Product_Name_del__c);
                    }
                    //query all the product record based on refined list
                    List<Product2> list_product = [
                            SELECT
                                    Id,
                                    Name
                            FROM Product2
                            WHERE Name
                                    IN:list_prodName
                    ];
                    for (Product2 p : list_product) {
                        List<Product2> list_temp = new List<Product2>();
                        if (map_opportunityProductlist.containsKey(map_prodOpp.get(p.Name))) {
                            map_opportunityProductlist.get(map_prodOpp.get(p.Name)).add(p);
                        } else {
                            list_temp.add(p);
                            map_opportunityProductlist.put(map_prodOpp.get(p.Name), list_temp);

                        }
                    }
                    list_accteam = [
                            SELECT
                                    Id,
                                    AccountId,
                                    UserId
                            FROM AccountTeamMember
                            WHERE AccountId
                                    IN:map_accid.keySet()
                            AND TeamMemberRole = 'Customer Service Manager'
                    ];
                    for (AccountTeamMember acc : list_accteam) {
                        if (map_accid.containsKey(acc.AccountId)) {
                            map_accteam.put(map_accid.get(acc.AccountId), acc.UserId);
                        }
                    }
                    if (AvoidRecursion.isFirstRun() || Test.isRunningTest()) {
                        // TODO: Another iteration
                        for (Opportunity op : newMap.values()) {
                            System.debug('>>>>>0' + map_opportunityProductlist.get(op.Id));
                            if (map_opportunityProductlist.get(op.Id) != null &&
                                    oldMap.get(op.Id).StageName != newMap.get(op.Id).StageName &&
                                    op.StageName == 'Closed Won') {
                                for (Product2 p : map_opportunityProductlist.get(op.Id)) {
                                    Case theCase = new Case();
                                    theCase.RecordTypeId = recordtypeId;
                                    theCase.AccountId = map_acc.get(op.Id).AccountId;
                                    theCase.Aircraft_Name__c = map_acc.get(op.Id).Aircraft_Ref__c;
                                    theCase.Opportunity__c = op.Id;
                                    theCase.Product__c = p.Id;
                                    theCase.Status = 'Done';
                                    theCase.Subject = p.Name + ' - ' + map_acc.get(op.Id).Model__c + ' - ' + map_acc.get(op.Id).Serial_Number__c;
                                    theCase.Make__c = map_acc.get(op.Id).Make__c;
                                    theCase.Model__c = map_acc.get(op.Id).Model__c;
                                    theCase.Serial_Number__c = map_acc.get(op.Id).Serial_Number__c;

                                    if (map_accteam.containsKey(op.Id)) {
                                        theCase.OwnerId = map_accteam.get(op.Id);
                                    } else {
                                        theCase.OwnerId = Label.Steve_Ferensak_User_Id;
                                    }
                                    theCase.BGA_Dealer_Name__c = map_acc.get(op.Id).dealer_account__r.Name;
                                    objectsToInsert.add(theCase);
                                    bool_trans = false;
                                }
                            }
                        }
                    }
                }
            }
            /**
        * Create new Task whenever Customer Status or Next Step is changed

        */
            if (Trigger.new.size() == 1) {
                for (Opportunity opp : newMap.values()) {
                    //Customer Status

                    if(opp.Status__c != null && opp.Status__c != '' && oldMap.get(opp.Id).Status__c != opp.Status__c)
                    {
                        System.debug('inside customer status:' + opp.Id);

                        //check if source is Tact.AI
                        Task[] tactAICustomerStatus = [SELECT WhatId, Description, Subject FROM Task
                        WHERE WhatId =: opp.Id ORDER BY CreatedDate DESC LIMIT 1];

                        System.debug('tactAICustomerStatus' + tactAICustomerStatus);

                        if(tactAICustomerStatus.size() > 0
                                && opp.Status__c == tactAICustomerStatus[0].Description
                                && tactAICustomerStatus[0].Subject != 'Customer Status'
                                && tactAICustomerStatus[0].Subject != 'Next Step'
                                && tactAICustomerStatus[0].Subject != 'Log Virtual Meeting'
                                && tactAICustomerStatus[0].Subject != 'Log F2F Meeting')
                        {
                            //It is Tact.AI request and just do nothing

                        }
                        else
                        {
                            Task[] customerStatus = [SELECT WhatId, Description FROM Task
                            WHERE WhatId =: opp.Id AND Subject = 'Customer Status' ORDER BY CreatedDate DESC LIMIT 1];

                            System.debug('customerStatus:' + customerStatus);

                            if(customerStatus.size() == 0 || (customerStatus.size() > 0 && customerStatus[0].Description != opp.Status__c))
                            {
                                Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Status').getRecordTypeId();

                                Task newCustomerStatusTask = new Task(
                                        RecordTypeId = recTypeId,
                                        Subject = 'Customer Status',
                                        WhatId = opp.Id,
                                        //This is the default..
                                        OwnerId = UserInfo.getUserId(),
                                        Status = 'Completed',
                                        Type = 'Call',
                                        Description = opp.Status__c,
                                        ActivityDate = System.today(),
                                        Activity_Date__c = System.today(),
                                        CreatedDate = System.now());

                                insert newCustomerStatusTask;
                            }

                            System.debug('opp:' + opp.Status__c);
                        }
                    }

                    //Next Step
                    if(opp.Next_Step__c != null && opp.Next_Step__c != '' && opp.Next_Step_Date__c != null
                            && (oldMap.get(opp.Id).Next_Step__c != opp.Next_Step__c || oldMap.get(opp.Id).Next_Step_Date__c != opp.Next_Step_Date__c))
                    {
                        System.debug('inside next step');

                        //check if source is Tact.AI
                        Task[] tactAINextStep = [SELECT WhatId, Description, Subject, ActivityDate FROM Task WHERE WhatId =: opp.Id ORDER BY CreatedDate DESC LIMIT 1];
                        System.debug(tactAINextStep.size()+opp.Next_Step__c+opp.Next_Step_Date__c+'Tact code AI '+tactAINextStep);

                        if(tactAINextStep.size() > 0
                                && opp.Next_Step__c == tactAINextStep[0].Description
                                && opp.Next_Step_Date__c == tactAINextStep[0].ActivityDate
                                && tactAINextStep[0].Subject != 'Customer Status'
                                && !(tactAINextStep[0].Subject.contains('Next Step'))
                                && tactAINextStep[0].Subject != 'Log Virtual Meeting'
                                && tactAINextStep[0].Subject != 'Log F2F Meeting')
                        {
                            //It is Tact.AI request and just do nothing
                        }
                        else
                        {
                            Task[] nextStep = [SELECT Id, WhatId, Description, ActivityDate, CreatedDate FROM Task WHERE WhatId =: opp.Id AND RecordType.Name = 'Next Step' ORDER BY CreatedDate DESC LIMIT 1];

                            System.debug(nextStep.size()+'Tact code update'+nextStep);
                            Id newTaskId;
                            
                            if(nextStep.size() == 0 || (nextStep.size()> 0 && (nextStep[0].Description != opp.Next_Step__c || nextStep[0].ActivityDate != opp.Next_Step_Date__c))){
                                Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Next Step').getRecordTypeId();

                                Task newNextStepTask = new Task(
                                        RecordTypeId = recTypeId,
                                        Subject = 'Next Step',
                                        WhatId = opp.Id,
                                        //This is the default..
                                        OwnerId = UserInfo.getUserId(),
                                        Status = 'In Progress',
                                        Type = 'Call',
                                        Description = opp.Next_Step__c,
                                        ActivityDate = opp.Next_Step_Date__c,
                                        Activity_Date__c = opp.Next_Step_Date__c,
                                        CreatedDate = System.now()
                                );

                                System.debug('before:' + newNextStepTask);

                                insert newNextStepTask;
                                newTaskId = newNextStepTask.Id;
                                System.debug(newTaskId+'after:' + newNextStepTask);
                            }

                            if(nextStep.size() > 0 && newTaskId == NULL){
                                newTaskId = nextStep[0].Id;
                            }

                            if(nextStep.size() > 0){
                                Task[] nextStepAll = [SELECT Id, WhatId, Description, ActivityDate, CreatedDate FROM Task WHERE WhatId =: opp.Id AND RecordType.Name = 'Next Step' AND Id !=: newTaskId AND Status != 'Completed'];
                                System.debug(nextStepAll.size()+'Records Need to update'+nextStepAll);

                                if(nextStepAll.size() > 0 && newTaskId != NULL){
                                    List<task> tl = new List<task>();
                                    Task oldNextStepTask;
                                    for(task tk:nextStepAll){
                                        oldNextStepTask = new Task();
                                        if(oldNextStepTask.Status != 'Completed'){
                                            oldNextStepTask.Id = tk.Id;
                                            oldNextStepTask.Status = 'Completed';
                                            tl.add(oldNextStepTask);
                                        }
                                    }
                                    System.debug('tsk list is==='+tl);
                                    if(tl.size()>0){
                                        update tl;
                                    }
                                }
                            }
                        }
                    }

                    //Log Virtual Meeting
                    if(opp.Log_Virtual_Meeting__c != null && opp.Log_Virtual_Meeting__c != '' && opp.Log_Virtual_Meeting_Date__c != null
                            && (oldMap.get(opp.Id).Log_Virtual_Meeting__c != opp.Log_Virtual_Meeting__c || oldMap.get(opp.Id).Log_Virtual_Meeting_Date__c != opp.Log_Virtual_Meeting_Date__c))
                    {
                        System.debug('inside log virtual meeting');

                        //check if source is Tact.AI
                        Task[] tactAILogVirtualMeeting = [SELECT WhatId, Description, Subject, ActivityDate,Activity_Date__c FROM Task
                        WHERE WhatId =: opp.Id ORDER BY CreatedDate DESC LIMIT 1];

                        if(tactAILogVirtualMeeting.size() > 0
                                && opp.Log_Virtual_Meeting__c == tactAILogVirtualMeeting[0].Description
                                && opp.Log_Virtual_Meeting_Date__c == tactAILogVirtualMeeting[0].Activity_Date__c
                                && tactAILogVirtualMeeting[0].Subject != 'Customer Status'
                                && tactAILogVirtualMeeting[0].Subject != 'Next Step'
                                && tactAILogVirtualMeeting[0].Subject != 'Log Virtual Meeting'
                                && tactAILogVirtualMeeting[0].Subject != 'Log F2F Meeting')
                        {
                            //It is Tact.AI request and just do nothing
                        }
                        else
                        {
                            Task[] logVirtualMeeting = [SELECT WhatId, Description, ActivityDate,Activity_Date__c, CreatedDate FROM Task
                            WHERE WhatId =: opp.Id AND Subject = 'Log Virtual Meeting'
                            ORDER BY CreatedDate DESC LIMIT 1];

                            if(logVirtualMeeting.size() == 0 || ( logVirtualMeeting.size()> 0 && (logVirtualMeeting[0].Description != opp.Log_Virtual_Meeting__c || logVirtualMeeting[0].Activity_Date__c != opp.Log_Virtual_Meeting_Date__c)))
                            {
                                Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log Virtual Meeting').getRecordTypeId();

                                Task newLogVirtualMeetingTask = new Task(
                                        RecordTypeId = recTypeId,
                                        Subject = 'Log Virtual Meeting',
                                        WhatId = opp.Id,
                                        //This is the default..
                                        OwnerId = UserInfo.getUserId(),
                                        Status = 'Completed',
                                        Type = 'Call',
                                        Description = opp.Log_Virtual_Meeting__c,
                                        ActivityDate = opp.Log_Virtual_Meeting_Date__c,
                                        Activity_Date__c = opp.Log_Virtual_Meeting_Date__c,
                                        CreatedDate = System.now()
                                );

                                System.debug('before:' + newLogVirtualMeetingTask);

                                insert newLogVirtualMeetingTask;

                                System.debug('after:' + newLogVirtualMeetingTask);
                            }
                        }
                    }

                    //Log F2F Meeting
                    if(opp.Log_F2F_Meeting__c != null && opp.Log_F2F_Meeting__c != '' && opp.Log_F2F_Meeting_Date__c != null
                            && (oldMap.get(opp.Id).Log_F2F_Meeting__c != opp.Log_F2F_Meeting__c || oldMap.get(opp.Id).Log_F2F_Meeting_Date__c != opp.Log_F2F_Meeting_Date__c))
                    {
                        System.debug('inside log f2f meeting');


                        //check if source is Tact.AI
                        Task[] tactAILogF2FMeeting = [SELECT WhatId, Description, Subject, ActivityDate,Activity_Date__c FROM Task
                        WHERE WhatId =: opp.Id ORDER BY CreatedDate DESC LIMIT 1];

                        if(tactAILogF2FMeeting.size() > 0
                                && opp.Log_F2F_Meeting__c == tactAILogF2FMeeting[0].Description
                                && opp.Log_F2F_Meeting_Date__c == tactAILogF2FMeeting[0].Activity_Date__c
                                && tactAILogF2FMeeting[0].Subject != 'Customer Status'
                                && tactAILogF2FMeeting[0].Subject != 'Next Step'
                                && tactAILogF2FMeeting[0].Subject != 'Log Virtual Meeting'
                                && tactAILogF2FMeeting[0].Subject != 'Log F2F Meeting')
                        {
                            //It is Tact.AI request and just do nothing
                        }
                        else
                        {
                            Task[] logF2FMeeting = [SELECT WhatId, Description, ActivityDate,Activity_Date__c, CreatedDate FROM Task
                            WHERE WhatId =: opp.Id AND Subject = 'Log F2F Meeting'
                            ORDER BY CreatedDate DESC LIMIT 1];

                            if(logF2FMeeting.size() == 0 || ( logF2FMeeting.size()> 0 && (logF2FMeeting[0].Description != opp.Log_F2F_Meeting__c || logF2FMeeting[0].Activity_Date__c != opp.Log_F2F_Meeting_Date__c)))
                            {
                                Id recTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Log F2F Meeting').getRecordTypeId();

                                Task newLogF2FMeetingTask = new Task(
                                        RecordTypeId = recTypeId,
                                        Subject = 'Log F2F Meeting',
                                        WhatId = opp.Id,
                                        //This is the default..
                                        OwnerId = UserInfo.getUserId(),
                                        Status = 'Completed',
                                        Type = 'Call',
                                        Description = opp.Log_F2F_Meeting__c,
                                        ActivityDate = opp.Log_F2F_Meeting_Date__c,
                                        Activity_Date__c = opp.Log_F2F_Meeting_Date__c,
                                        CreatedDate = System.now()
                                );

                                System.debug('before:' + newLogF2FMeetingTask);

                                insert newLogF2FMeetingTask;

                                System.debug('after:' + newLogF2FMeetingTask);
                            }
                        }
                    }
                }
            }
            /**
         * Perform any DML statements in bulk at the end of the trigger.
         */


            if (objectsToDelete.size() > 0) {
                delete objectsToDelete;
            }
            if (objectsToInsert.size() > 0) {
                insert objectsToInsert;
            }
            if (objectsToUpdate.size() > 0) {
                System.debug('final update the line item ----'+objectsToUpdate.size());
                update objectsToUpdate;
            }
        } catch(Exception ex) {
            handleException(ex, newMap.values());
        }
    }
    public void AfterDelete(Map<Id, SObject> oldItems) {}

    public void AfterUndelete(Map<Id, SObject> oldItems) {}

    @TestVisible
    private static void handleException(Exception ex, List<Opportunity> opps) {
        for (Opportunity opp: opps) {
            opp.addError(ex.getMessage());
            break;
        }
        publishEvent(ex);
    }
    @TestVisible
    private static void publishEvent(Exception ex) {
        Error_Log__c errLog = new ErrorLogBuilder(ErrorLogBuilder.CRM_SALES)
                .setDescription('User who triggered the exception is: ' + UserInfo.getUserName() + ' \n' +
                        'User Id is : ' + UserInfo.getUserId())
                .setObjectInfo(OPPORTUNITY)
                .setException(ex)
                .build();

        Log_Error_Event__e errLogEvent = new Log_Error_Event__e();
        errLogEvent.Team_Name__c = ErrorLogBuilder.CRM_SALES;
        errLogEvent.Object__c = OPPORTUNITY;
        errLogEvent.Description__c = errLog.Description__c;

        EventBus.publish(errLogEvent);
    }
    public class OpportunityTriggerHandlerException extends Exception {}
}