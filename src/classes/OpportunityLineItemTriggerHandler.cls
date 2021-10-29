/**
 * Created by Satya Mohanty on 3/22/2019.
 * Refactored by Nikolay Kolev on 3/25/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class OpportunityLineItemTriggerHandler implements ITriggerHandler {
    private final String CLOSED_WON = 'Closed Won';
    private final String CLOSED_LOST = 'Closed Lost';
    private final String CLOSED_CANCELLED = 'Closed Cancelled';
    private final String BOOKED = 'Booked';
    private final String APO= 'APO';
    private final String FORECAST = 'Forecast';
    private final String SYSTEM_ERROR_OCCURRED = 'A system error has occurred, the salesforce developers have been notified.';
    @TestVisible private final static String OPPORTUNITY_LINE_ITEM = 'OpportunityLineItem';

    public void BeforeInsert(List<sObject> opportunityLineItems) {
        system.debug('START OF BEFORE INSERT OLI');
        // Cast the sObject into OpportunityLineItems.
        List<OpportunityLineItem> lineItems = (List<OpportunityLineItem>) opportunityLineItems;

        // Defined outside of the try so they can be used in the catch block.
        Set<Id> productLineCrossRefIds = new Set<Id>();
        Set<Id> productIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> productLineIds = new Set<Id>();
        try {
            for (OpportunityLineItem lineItem : lineItems) {
                // Lookup to Product Line Cross Ref object.
                productLineCrossRefIds.add(lineItem.M_PM_Product__c);
                productIds.add(lineItem.Product2Id);
                opportunityIds.add(lineItem.OpportunityId);
                // Lookup to Product Line object.
                productLineIds.add(lineItem.M_PM_Product_Line__c);
            }
            productLineCrossRefIds.remove(null);
            productIds.remove(null);
            opportunityIds.remove(null);
            productLineIds.remove(null);

            // Pull associated opportunities.
            Map<Id, Opportunity> opportunities = OpportunityLineItemTriggerHelper.getOpportunities(opportunityIds);

            Map<Id, Id> opportunityToFleetAssetDetail = new Map<Id, Id>();
            Set<Id> platformIds = new Set<Id>();
            Map<Id, Id> fleetAssetDetailIdToPlatform = new Map<Id, Id>();
            Set<String> userNames = new Set<String>();
            for (Opportunity opportunity : opportunities.values()) {
                userNames.add(opportunity.Tech_Sales1__c);

                opportunityToFleetAssetDetail.put(opportunity.Id, opportunity.Aircraft_Ref__c);
                if (opportunity.Aircraft_Ref__r != null && opportunity.Aircraft_Ref__r.Platform_Name__c != null) {
                    platformIds.add(opportunity.Aircraft_Ref__r.Platform_Name__c);
                    fleetAssetDetailIdToPlatform.put(
                            opportunity.Aircraft_Ref__c,
                            opportunity.Aircraft_Ref__r.Platform_Name__c
                    );
                }
            }
            Map<Id, Product_Line__c > productLineRecordsMap = OpportunityLineItemTriggerHelper.getProductLines(
                    productLineCrossRefIds,
                    productLineIds
            );
            userNames.remove(null);
            platformIds.remove(null);

            Map<String, Id> productLineCrossRefNameToProductLineCrossRef = new Map<String, Id>();
            Map<Id, Product_Line_Cross_Ref__c> productLineCrossReferences = new Map<Id, Product_Line_Cross_Ref__c>();
            // Holds the product line tech sale mapped to a key of the product line name, sbu and cbt values.
            Map<Integer, Product_Line_Tech_Sales__c> productLineTechSales = new Map<Integer, Product_Line_Tech_Sales__c>();
            for (Product_Line__c productLine : productLineRecordsMap.values()) {
                for (Product_Line_Tech_Sales__c productLineTechSale : productLine.Product_Line_Tech_Sales__r) {
                    if (String.isNotBlank(productLine.Name) || String.isNotBlank(productLineTechSale.SBU__c) ||
                        String.isNotBlank(productLineTechSale.Region__c) || String.isNotBlank(productLineTechSale.Country__c)
                    ) {
                        productLineTechSales.put(
                                new TechSalesHashBuilder()
                                        .setName(productLine.Name)
                                        .setSbu(productLineTechSale.SBU__c)
                                        .setRegion(productLineTechSale.Region__c)
                                        .setCountry(productLineTechSale.Country__c)
                                        .getHash(TechSalesHashBuilder.Criteria.ALL),
                                productLineTechSale
                        );
                    }
                }
                for (Product_Line_Cross_Ref__c productLineCrossRef : productLine.Product_Line_Cross_Ref__r) {
                    productLineCrossRefNameToProductLineCrossRef.put(productLineCrossRef.Name, productLineCrossRef.Id);
                    productLineCrossReferences.put(productLineCrossRef.Id, productLineCrossRef);
                }
            }

            // Offering mapper or also known as offering platform
            Map<Id, List<OFFERING_MAPPER__c>> rmuValueToOfferingMappers =
                    OpportunityLineItemTriggerHelper.getRmuValueToOfferingMappers(platformIds);

            Map<Id, Id> productRmuIdToRmuValueId = OpportunityLineItemTriggerHelper.getProductRmuIdToRmuValueId(productIds);

            for (OpportunityLineItem lineItem : lineItems) {
                try {
                    System.debug('OpportunityLineItemTriggerHelper.isUserAnAdmin()==='+OpportunityLineItemTriggerHelper.isUserAnAdmin());
                    // Set the forecast factor ai index.
                    if (opportunities.get(lineItem.OpportunityId).StageName == CLOSED_WON) {
                        lineItem.Forecast_Factor_AI__c = 100;
                    } else if (opportunities.get(lineItem.OpportunityId).StageName == CLOSED_LOST ||
                            opportunities.get(lineItem.OpportunityId).StageName == CLOSED_CANCELLED) {
                        lineItem.Forecast_Factor_AI__c = 0;
                    }
                    //if (!OpportunityLineItemTriggerHelper.isUserAnAdmin()) {
                    if (!OpportunityLineItemTriggerHelper.is_D_S_API_User()) {
                                         
                        lineItem.Type__c = FORECAST;
                    }
                    // Set the probability.
                    if (lineItem.Type__c == BOOKED) {
                        lineItem.Probability__c = 100;
                    } else {
                        lineItem.Probability__c = opportunities.get(lineItem.OpportunityId).Combined_Probability__c;
                    }

                    lineItem.RMU__c = productRmuIdToRmuValueId.get(lineItem.Product2Id);

                    Id fleetAssetDetailId = opportunityToFleetAssetDetail.get(lineItem.OpportunityId);
                    // A line item can exist without having an Offer(Rmu_Value__c).
                    if (rmuValueToOfferingMappers.get(lineItem.RMU__c) != null) {
                        // Verify if there's a platform associated with the fleet asset detail id.
                        if (fleetAssetDetailIdToPlatform.get(fleetAssetDetailId) != null) {
                            // Pull all offering mappers related to that rmu value object.
                            for (OFFERING_MAPPER__c offRec : rmuValueToOfferingMappers.get(lineItem.RMU__c)) {
                                if (offRec.Aircraft_Platform__c == fleetAssetDetailIdToPlatform.get(fleetAssetDetailId)) {
                                    lineItem.RMU_Platform__c = offRec.Id;
                                    break;
                                }
                            }
                        }
                    }

                    // Set the Product Line lookup based on the Product Line Cross Reference.
                    if (lineItem.M_PM_Product__c != null) {
                        lineItem.M_PM_Product_Line__c = productLineCrossReferences.get(lineItem.M_PM_Product__c).Product_Line__c;
                    } else if (lineItem.M_PM_Product__c == null && lineItem.M_PM_Product_Line__c != null) {
                        Product_Line__c productLine = productLineRecordsMap.get(lineItem.M_PM_Product_Line__c);
                        // TODO: This is broken as it's trying to pull out of a product line cross ref map but provides a
                        // product line name. Not modifying this for now as that's not part of the current requirements.
                        lineItem.M_PM_Product__c = productLineCrossRefNameToProductLineCrossRef.get(productLine.Name);
                    }
                    /**
                     * Sets the tech sales.
                     */
                    TechSalesSettable techSalesSetter = TechSalesSetterBuilderFactory.getTechSalesSetter(
                            opportunities.get(lineItem.OpportunityId),
                            lineItem,
                            productLineTechSales,
                            OpportunityLineItemTriggerHelper.getUserMap(userNames)
                    );
                    techSalesSetter.setTechSales();
                // If anything fails for a particular line item then pass that line item's name to the error log for
                // debugging.
                } catch (Exception ex) {
                    // Have to invoke those methods because of a known bug in APEX.
                    String additionalDescription = ex.getMessage() + '\n' + ex.getStackTraceString() + '\n' +
                            '\n' + 'Opportunity Id is ' + lineItem.OpportunityId + '\n';
                    throw new OpportunityLineItemTriggerHandlerException(additionalDescription, ex);
                }
            }
        } catch (Exception ex) {
            handleException(ex,opportunityIds,productLineCrossRefIds,productIds,productLineIds);

            throw new OpportunityLineItemTriggerHandlerException(SYSTEM_ERROR_OCCURRED);
        }
        system.debug('END OF BEFORE INSERT OLI');
    }

    public void BeforeUpdate(Map<Id, SObject> newOpportunityLineItems, Map<Id, SObject> oldOpportunityLineItems) {
        system.debug('START OF BEFORE UPDATE OLI');
        Map<Id, OpportunityLineItem> newItems = (Map<Id, OpportunityLineItem>) newOpportunityLineItems;
        Map<Id, OpportunityLineItem> oldItems = (Map<Id, OpportunityLineItem>) oldOpportunityLineItems;

        // Defined outside of the try so they can be used in the catch block.
        Set<Id> productLineCrossRefIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> productLineIds = new Set<Id>();
        // This set will remain empty for the catch block. Trying to avoid method overloading to simplify the trigger.
        Set<Id> productIds = new Set<Id>();
        try {
            for (OpportunityLineItem lineItem : newItems.values()) {
                /**
                 * If the OLI was/is Booked/APO and the user is not an admin then return an error.
                 */
                if (
                        (newItems.get(lineItem.Id).Type__c == 'Booked' ||
                                oldItems.get(lineItem.Id).Type__c == 'Booked' ||
                                newItems.get(lineItem.Id).Type__c == 'APO' ||
                                oldItems.get(lineItem.Id).Type__c == 'APO') &&
                                !OpportunityLineItemTriggerHelper.isUserAnAdmin()
                ) {
                    lineItem.addError('Opportunity Product can be changed only by an admin.');
                }
                opportunityIds.add(lineItem.OpportunityId);
                // Lookup to Product Line object.
                productLineIds.add(lineItem.M_PM_Product_Line__c);
                // Lookup to Product Line Cross Ref object only if the lookup was changed on the OLI.
                productLineCrossRefIds.add(lineItem.M_PM_Product__c);
            }
            opportunityIds.remove(null);
            productLineIds.remove(null);
            productLineCrossRefIds.remove(null);

            Map<Id, Opportunity> opportunities = OpportunityLineItemTriggerHelper.getOpportunities(opportunityIds);
            Set<String> userNames = new Set<String>();
            Map<String, Id> userNameMap = new Map<String, Id>();
            for (Opportunity opportunity : opportunities.values()) {
                userNames.add(opportunity.Tech_Sales1__c);                
            }
            userNames.remove(null);
            
            if (userNames.size() > 0) {
                List<user> urs = [SELECT Id, Name FROM User WHERE Name IN :userNames AND IsPortalEnabled = FALSE AND IsActive =TRUE];
                for (User user : urs){
                    userNameMap.put(user.Name, user.Id);
                }
            }
            
            Map<Id, Product_Line__c > productLineRecordsMap = OpportunityLineItemTriggerHelper.getProductLines(
                    productLineCrossRefIds,
                    productLineIds
            );

            Map<String, Id> productLineCrossRefNameToProductLineCrossRef = new Map<String, Id>();
            Map<Id, Product_Line_Cross_Ref__c> productLineCrossReferences = new Map<Id, Product_Line_Cross_Ref__c>();
            // Holds the product line tech sale mapped to a key of the product line name, sbu and cbt values.
            Map<Integer, Product_Line_Tech_Sales__c> productLineTechSales = new Map<Integer, Product_Line_Tech_Sales__c>();
            for (Product_Line__c productLine : productLineRecordsMap.values()) {
                for (Product_Line_Tech_Sales__c productLineTechSale : productLine.Product_Line_Tech_Sales__r) {
                    if (String.isNotBlank(productLine.Name) || String.isNotBlank(productLineTechSale.SBU__c) ||
                            String.isNotBlank(productLineTechSale.Region__c) || String.isNotBlank(productLineTechSale.Country__c)
                        ) {
                        productLineTechSales.put(
                                new TechSalesHashBuilder()
                                        .setName(productLine.Name)
                                        .setSbu(productLineTechSale.SBU__c)
                                        .setRegion(productLineTechSale.Region__c)
                                        .setCountry(productLineTechSale.Country__c)
                                        .getHash(TechSalesHashBuilder.Criteria.ALL),
                                productLineTechSale
                        );
                    }
                }
                for (Product_Line_Cross_Ref__c productLineCrossRef : productLine.Product_Line_Cross_Ref__r) {
                    productLineCrossRefNameToProductLineCrossRef.put(productLineCrossRef.Name, productLineCrossRef.Id);
                    productLineCrossReferences.put(productLineCrossRef.Id, productLineCrossRef);
                }
            }

            /**
             * Pulls the schedules for the OLIs.
             */
            Map<Id, List<OpportunityLineItemSchedule>> lineItemsSchedules = new Map<Id, List<OpportunityLineItemSchedule>>();
            for (OpportunityLineItemSchedule schedule : [
                    SELECT
                            Id,
                            ScheduleDate,
                            OpportunityLineItemId
                    FROM OpportunityLineItemSchedule
                    WHERE OpportunityLineItemId IN:newItems.keySet()
                    ORDER BY ScheduleDate
            ]
            ) {
                List<OpportunityLineItemSchedule> schedules = new List<OpportunityLineItemSchedule>();
                if (lineItemsSchedules.containsKey(schedule.OpportunityLineItemId)) {
                    schedules.addAll(lineItemsSchedules.get(schedule.OpportunityLineItemId));
                }
                schedules.add(schedule);
                // OLI Id to List of OpportunityLineItemSchedule
                lineItemsSchedules.put(schedule.OpportunityLineItemId, schedules);
            }
            for (OpportunityLineItem lineItem : newItems.values()) {
                try {
                    // Set the forecast factor ai index.
                    if (opportunities.get(lineItem.OpportunityId).StageName == CLOSED_WON) {
                        lineItem.Forecast_Factor_AI__c = 100;
                    }
                    if (opportunities.get(lineItem.OpportunityId).StageName == CLOSED_LOST ||
                            opportunities.get(lineItem.OpportunityId).StageName == CLOSED_CANCELLED) {
                        lineItem.Forecast_Factor_AI__c = 0;
                    }
                     if (lineItem.Type__c == 'Booked') {
                     lineItem.Probability__c = 100;
                     }
                  /*  if (lineItem.Type__c != 'Booked') {
                        lineItem.Probability__c = opportunities.get(lineItem.OpportunityId).Combined_Probability__c;
                    } else {
                        lineItem.Probability__c = 100;
                    }*/
                    //Get the old version of the record
                    OpportunityLineItem oldLineItem = oldItems.get(lineItem.Id);

                    // Set the Product Line lookup based on the Product Line Cross Reference.
                    if ((lineItem.M_PM_Product__c != null &&
                        (oldLineItem.M_PM_Product__c != lineItem.M_PM_Product__c) ||
                            lineItem.M_PM_Product_Line__c == null) &&
                            productLineCrossReferences.get(lineItem.M_PM_Product__c) != null
                    ) {
                        lineItem.M_PM_Product_Line__c = productLineCrossReferences.get(lineItem.M_PM_Product__c).Product_Line__c;
                    } else if (lineItem.M_PM_Product__c == null && lineItem.M_PM_Product_Line__c != null) {
                        Product_Line__c productLine = productLineRecordsMap.get(lineItem.M_PM_Product_Line__c);
                        // TODO: This is broken as it's trying to pull out of a product line cross ref map but provides a
                        // product line name. Not modifying this for now as that's not part of the current requirements.
                        lineItem.M_PM_Product__c = productLineCrossRefNameToProductLineCrossRef.get(productLine.Name);
                    }

                    /**
                     * Sets the tech sales.
                     */
                    TechSalesSettable techSalesSetter = TechSalesSetterBuilderFactory.getTechSalesSetter(
                            opportunities.get(lineItem.OpportunityId),
                            lineItem,
                            productLineTechSales,
                            userNameMap
                    );
                    techSalesSetter.setTechSales();

                    // Holds the soonest start date for the OLI.
                    Date scheduleStartDate;
                    // Holds the furthest end date for the OLI.
                    Date scheduleEndDate;
                    if (lineItemsSchedules.containsKey(lineItem.Id)) {
                        // Iterating over a list of OpportunityLineItemSchedule.
                        for (OpportunityLineItemSchedule schedule : lineItemsSchedules.get(lineItem.Id)) {
                            // Sets OLI Id to the soonest in the future schedule start date.
                            if (scheduleStartDate == null || scheduleStartDate > schedule.ScheduleDate) {
                                scheduleStartDate = schedule.ScheduleDate;
                            }
                            // Sets OLI Id to the furthest in the future schedule end date.
                            if (scheduleEndDate == null || scheduleEndDate < schedule.ScheduleDate) {
                                scheduleEndDate = schedule.ScheduleDate;
                            }
                        }
                        if ((lineItem.Revenue_Start_Date__c != oldItems.get(lineItem.Id).Revenue_Start_Date__c &&
                                oldItems.get(lineItem.Id).Revenue_Start_Date__c != null && scheduleStartDate != lineItem.Revenue_Start_Date__c) ||
                                (lineItem.Revenue_End_Date__c != oldItems.get(lineItem.Id).Revenue_End_Date__c &&
                                        oldItems.get(lineItem.Id).Revenue_End_Date__c != null && scheduleEndDate != lineItem.Revenue_End_Date__c)
                                ) {
                            lineItem.addError('Please edit Revenue Schedule to change Revenue Start or End date.');
                        }
                        List<OpportunityLineItemSchedule> schedules = lineItemsSchedules.get(lineItem.Id);

                        Integer diff = schedules.size() > 1 ?
                                (schedules[0].ScheduleDate).daysBetween(schedules[1].ScheduleDate) :
                                0;
                        if (diff <= 1) {
                            lineItem.Schedule_Type__c = 'Daily';
                        } else if (diff > 1 && diff <= 7) {
                            lineItem.Schedule_Type__c = 'Weekly';
                        } else if (diff > 7 && diff <= 31) {
                            lineItem.Schedule_Type__c = 'Monthly';
                        } else if (diff > 31 && diff <= 92) {
                            lineItem.Schedule_Type__c = 'Quarterly';
                        } else if (diff > 92) {
                            lineItem.Schedule_Type__c = 'Yearly';
                        }

                        Integer daysBetweenInt = 0;
                        if (oldItems.get(lineItem.Id).ServiceDate != null && lineItem.ServiceDate != null) {
                            daysBetweenInt = oldItems.get(lineItem.Id).ServiceDate.daysBetween(lineItem.ServiceDate);
                        }
                        if (schedules.size() > 0 && schedules[0].ScheduleDate != null) {
                            lineItem.Revenue_Start_Date__c = schedules[0].ScheduleDate + daysBetweenInt;
                        }
                        if (schedules.size() >= 1 && schedules[schedules.size() - 1].ScheduleDate != null) {
                            lineItem.Revenue_End_Date__c = schedules[schedules.size() - 1].ScheduleDate + daysBetweenInt;
                        }
                        //Commented and Modified for SR# INC000005780915 - End
                        lineItem.Terms_in_Months__c = scheduleStartDate.monthsBetween(scheduleEndDate);
                    } else {
                        lineItem.Schedule_Type__c = '';
                        lineItem.Revenue_Start_Date__c = null;
                        lineItem.Revenue_End_Date__c = null;
                        lineItem.Terms_in_Months__c = null;
                    }
                // If anything fails for a particular line item then pass that line item's Id to the error log for
                // debugging.
                } catch (Exception ex) {
                    String additionalDescription = ex.getMessage() + '\n' + ex.getStackTraceString() + '\n' +
                            '\n' + 'Line Item Id is ' + lineItem.Id + '\n';
                    throw new OpportunityLineItemTriggerHandlerException(additionalDescription, ex);
                }
            }
        } catch (Exception ex) {
            handleException(ex,opportunityIds,productLineCrossRefIds,productIds,productLineIds);

            throw new OpportunityLineItemTriggerHandlerException(SYSTEM_ERROR_OCCURRED);
        }
        system.debug('END OF BEFORE UPDATE OLI');
    }

    public void BeforeDelete(Map<Id, SObject> oldItems) {
        system.debug('START OF BEFORE DELETE OLI');
        try {
            Map<Id, OpportunityLineItem> oldMap = (Map<Id, OpportunityLineItem>) oldItems;

            //Send an error if a non-admin tries to delete a Booked or APO Opportunity Product
            for (OpportunityLineItem opportunityMapLoop: oldMap.values()) {
                if (opportunityMapLoop.Type__c == 'Booked' || opportunityMapLoop.Type__c == 'APO') {
                    if (!OpportunityLineItemTriggerHelper.isUserAnAdmin()) {
                        opportunityMapLoop.addError('Opportunity Product can be deleted only by an admin.');
                    }
                }
            }
        } catch (Exception ex) {
            handleException(ex);

            throw new OpportunityLineItemTriggerHandlerException(SYSTEM_ERROR_OCCURRED);
        }
        system.debug('END OF BEFORE DELETE OLI');
    }

    public void AfterInsert(Map<Id, SObject> newItems) {}

    public void AfterUpdate(Map<Id, SObject> newOpportunityLineItems, Map<Id, SObject> oldOpportunityLineItems) {
        system.debug('START OF AFTER UPDATE OLI');
        Map<Id, OpportunityLineItem> newItems = (Map<Id, OpportunityLineItem>) newOpportunityLineItems;
        Map<Id, OpportunityLineItem> oldItems = (Map<Id, OpportunityLineItem>) oldOpportunityLineItems;

        Map<Id, Integer> daysDifferenceMap = new Map<Id, Integer>();

        Integer daysBetweenInt = 0;
        try {
            for (OpportunityLineItem lineItem : newItems.values()) {
                try {
                    if (
                            lineItem.ServiceDate != oldItems.get(lineItem.Id).ServiceDate &&
                                    lineItem.ServiceDate != null
                            ) {
                        daysBetweenInt = oldItems.get(lineItem.Id).ServiceDate.daysBetween(lineItem.ServiceDate);
                        daysDifferenceMap.put(lineItem.Id, daysBetweenInt);
                    }
                } catch (Exception ex) {
                    String additionalDescription = ex.getMessage() + '\n' + ex.getStackTraceString() + '\n' +
                                    '\n' + 'Line Item Id is ' + lineItem.Id + '\n';
                    throw new OpportunityLineItemTriggerHandlerException(additionalDescription, ex);
                }
            }
            //If the Opportunity product service date gets pushed out, push out each Opp Schedule Line Item the same number of days
            if (daysDifferenceMap.size() > 0) {
                List<OpportunityLineItemSchedule> oppLineItemSchList=new List<OpportunityLineItemSchedule>();
                // TODO: Why is it querying for 100.
                for (OpportunityLineItemSchedule oppLineItemSchedule : [
                                                                            SELECT
                                                                                    Id,
                                                                                    Quantity,
                                                                                    ScheduleDate,
                                                                                    Type,
                                                                                    OpportunityLineItemId
                                                                            FROM OpportunityLineItemSchedule
                                                                            WHERE OpportunityLineItemId IN :daysDifferenceMap.keySet()
                                                                            LIMIT 100
                ]) {
                    try {
                        OpportunityLineItemSchedule oppLineUpdateList = new OpportunityLineItemSchedule(Id = oppLineItemSchedule.Id);
                        if (oppLineItemSchedule.ScheduleDate != null) {
                            oppLineUpdateList.ScheduleDate = oppLineItemSchedule.ScheduleDate +
                                    daysDifferenceMap.get(oppLineItemSchedule.OpportunityLineItemId);
                            oppLineItemSchList.add(oppLineUpdateList);
                        }
                    } catch (Exception ex) {
                        String additionalDescription = ex.getMessage() + '\n' + ex.getStackTraceString() + '\n' +
                                '\n' + 'OpportunityLineItemSchedule is ' + oppLineItemSchedule.Id + '\n' +
                                '\n' + 'Line Item Id is ' + oppLineItemSchedule.OpportunityLineItemId + '\n';
                        throw new OpportunityLineItemTriggerHandlerException(additionalDescription, ex);
                    }
                }
                update oppLineItemSchList;
            }
        } catch (Exception ex) {
            handleException(ex);

            throw new OpportunityLineItemTriggerHandlerException(SYSTEM_ERROR_OCCURRED);
        }
        system.debug('END OF AFTER UPDATE OLI');
    }

    public void AfterDelete(Map<Id, SObject> oldItems) {}

    public void AfterUndelete(Map<Id, SObject> oldItems) {}
    @TestVisible
    private static void handleException(
            Exception ex,
            Set<Id> opportunityIds,
            Set<Id> productLineCrossRefIds,
            Set<Id> productIds,
            Set<Id> productLineIds
    ) {
        // Store any useful information that will allow for the replication of this bug.
        String customDescription = 'List of Parent Opportunity Id(s): \n';
        for (Id oppId: opportunityIds) {
            customDescription += oppId + '\n';
        }
        customDescription += 'List of Product Line Cross Reference Id(s): \n';
        for (Id crossRefId: productLineCrossRefIds) {
            customDescription += crossRefId + '\n';
        }
        customDescription += 'List of Product2 Id(s): \n';
        for (Id prodId: productIds) {
            customDescription += prodId + '\n';
        }
        customDescription += 'List of Product Line Id(s): \n';
        for (Id prodLineId: productLineIds) {
            customDescription += prodLineId + '\n';
        }
        new ErrorLogBuilder(ErrorLogBuilder.CRM_SALES)
                .setDescription(customDescription)
                .setObjectInfo(OPPORTUNITY_LINE_ITEM)
                .setException(ex)
                .generate();
    }
    @TestVisible
    private static void handleException(Exception ex) {
        new ErrorLogBuilder(ErrorLogBuilder.CRM_SALES)
                .setObjectInfo(OPPORTUNITY_LINE_ITEM)
                .setException(ex)
                .generate();
    }
    public class OpportunityLineItemTriggerHandlerException extends Exception {}
}