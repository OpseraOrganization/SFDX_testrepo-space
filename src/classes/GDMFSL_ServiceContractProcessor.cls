/*******************************************************************************************
Name       :    GDMFSL_ServiceContractProcessor
Purpose    :    Processor Logic for Service Contract object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-28    Created
**********************************************************************************************/

public without sharing class GDMFSL_ServiceContractProcessor {

    // ALE => SC
    private static final Map<String, String> ALEFIELDSMAPTOSC = new Map<String, String>{

            'GDMFSL_24hr_Reactive_Coverage__c' => 'GDMFSL_X24hr_Reactive_Response__c',
            'GDMFSL_After_Hr_Reactive_Coverage__c' => 'GDMFSL_After_Hr_Reactive_Response__c',
            'GDMFSL_Connected_Digital_Services__c' => 'GDMFSL_Connected_Digital_Services__c',
            'GDMFSL_SLA_Guarantee_Financial_Penalty__c' => 'GDMFSL_SLA_Guarantee_w_Financial_Penalty__c',
            'GDMFSL_Office_Hr_Reactive_Coverage__c' => 'GDMFSL_Office_Hr_Reactive_Response__c',
            'GDMFSL_Parts_Replacement_Management__c' => 'GDMFSL_Parts_Replacement_Management__c',
            'GDMFSL_PO_Number_Reactive_Coverage__c' => 'GDMFS_PO_Number_Reactive_Coverage__c',
            'GDMFSL_Preventative_Maintenance__c' => 'GDMFSL_Preventative_Maintenance__c',
            'GDMFSL_Reactive_Work_Chargeable__c' => 'GDMFSL_Reactive_Work_Chargeable__c',
            'GDMFSL_Reactive_Work_Not_Chargeable__c' => 'GDMFSL_Reactive_Work_Not_Chargeable__c',
            'GDMFSL_Site_Resident_Labour_Present__c' => 'GDMFSL_Site_Resident_Labour_Present__c',
            'GDMFSL_Software_Assurance__c' => 'GDMFSL_Software_Assurance__c',
            'GDMFSL_Tech_Phone_Support__c' => 'GDMFSL_Tech_Phone_Support__c',
            'GDMFSL_Third_Party_Support__c' => 'GDMFSL_Third_Party_Support__c',
            'GDMFSL_Warranty_Services__c' => 'GDMFSL_Warranty_Services__c',
            'GDMFSL_DigitalServices_OTS__c' => 'GDMFSL_DigitalServices_OTS__c',
            'GDMFSL_DigitalServices_CS__c' => 'GDMFSL_DigitalServices_CS__c',
            'GDMFSL_RemoteSupport_SH__c' => 'GDMFSL_RemoteSupport_SH__c',
            'GDMFSL_RemoteSupport_AM__c' => 'GDMFSL_RemoteSupport_AM__c',
            'GDMFSL_RemoteSupport_BO__c' => 'GDMFSL_RemoteSupport_BO__c',
            'GDMFSL_ReactiveWork_Chargeable_L__c' => 'GDMFSL_ReactiveWork_Chargeable_L__c',
            'GDMFSL_RemoteReactiveWork_Chargeable_L__c' => 'GDMFSL_RemoteReactiveWork_Chargeable_L__c',
            'GDMFSL_RemoteReactiveWork_NotChargeable__c' => 'GDMFSL_RemoteReactiveWork_NotChargeable__c',
            'GDMFSL_HolidayNoReactiveCoverage__c' => 'GDMFSL_HolidayNoReactiveCoverage__c',
            'GDMFSL_24HrCoverage_BusinessDays__c' => 'GDMFSL_24HrCoverage_BusinessDays__c',
            'GDMFSL_PartsStockManagement__c' => 'GDMFSL_PartsStockManagement__c',
            'GDMFSL_PartsReplacementManagement_L__c' => 'GDMFSL_PartsReplacementManagement_L__c'
    };

    private static Map<Id, ServiceContract> retVals = new Map<Id, ServiceContract>();

    public static Map<Id, ServiceContract> getRecords(Set<Id> recIds) {

        System.debug('GDMFSL_ServiceContractProcessor.getRecords');

        Set<Id> newRecIds = new Set<Id>();

        if (recIds != null && !recIds.isEmpty()) {

            System.debug('Adding in specified recordIDs');

            if (retVals.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!retVals.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }
        }

        if (!newRecIds.isEmpty()) {

            for (ServiceContract thisSC : [
                    SELECT Id,
                            AccountId,
                            GDMFSL_Bill_to_Account__c,
                            GDMFSL_ATS_BreakFix_Hours__c,
                            GDMFSL_ATS_PM_Hours__c,
                            GDMFSL_Contract_Type__c,
                            GDMFSL_Actual_Time_Consumed_BF_Hours__c,
                            GDMFSL_Actual_Time_Consumed_PM_Hours__c,
                            GDMFSL_Site_Resident_Labour_Present__c,
                            GDMFSL_Warranty_Services__c,
                            GDMFSL_Parts_Replacement_Management__c,
                            GDMFS_PO_Number_Reactive_Coverage__c,
                            GDMFSL_Reactive_Work_Not_Chargeable__c,
                            GDMFSL_Office_Hr_Reactive_Response__c,
                            GDMFSL_After_Hr_Reactive_Response__c,
                            GDMFSL_Profit_Center__c,
                            GDMFSL_Travel_Time_Chargeable__c,
                            GDMFSL_Bill_To_Account_Number__c,
                            GDMFSL_Sold_To_Account_Number__c,
                            GDMFSL_Bill_To_Source_System__c,
                            GDMFSL_Sold_To_Source_System__c,
                            GDMFSL_Sales_Office__c,
                            GDMFSL_Sales_Organization__c,
                            GDMFSL_Distribution_Channel__c,
                            GDMFSL_Profit_Center__r.GDMFSL_Sales_Organization__c,
                			Name

                    FROM ServiceContract
                    WHERE Id IN :newRecIds

            ]){
                retVals.put(thisSC.Id, thisSC);
            }
        }
        return retVals;
    }

    public static void setInitialFields(List<ServiceContract> theSCs) {

        if (theSCs != null && !theSCs.isEmpty()) {
            List<Pricebook2> pbs = new List<Pricebook2>([
                    SELECT Id
                    FROM Pricebook2
                    WHERE IsActive = TRUE
                    AND GDMFSL_Default_Service_Offerings__c = TRUE
                    LIMIT 1
            ]);

            Id theDefServOffPBId = pbs.isEmpty() ? null : pbs[0].Id;

            System.debug('Found Default Service Offering PBook: ' + theDefServOffPBId);

            if (theDefServOffPBId != null) {

                for (ServiceContract sc : theSCs) {
                    sc.Pricebook2Id = theDefServOffPBId;
                }
            }
        }
    }

    public static void updateRelatedObjects(Map<Id, ServiceContract> oldServiceContractMap, Map<Id, ServiceContract> newServiceContractMap) {

        Map<Id, ServiceContract> contractsCancelled = new Map<Id, ServiceContract>();
        Map<Id, ServiceContract> contractsForMP_CLIUpdateMap = new Map<Id, ServiceContract>();
        Set<Id> servContractIdsBlocked = new Set<Id>();

        for (ServiceContract sc : newServiceContractMap.values()) {
            System.debug('Checking Service Contract: ' + sc.Id);

            if (oldServiceContractMap.containsKey(sc.Id) && sc.GDMFSL_Cancelled__c != oldServiceContractMap.get(sc.Id).GDMFSL_Cancelled__c
                    && sc.GDMFSL_Cancelled__c == true) {
                System.debug('Cancelled Flag got updated to true');
                contractsCancelled.put(sc.Id, sc);

            }

            if (oldServiceContractMap.containsKey(sc.Id) && sc.EndDate != null && sc.EndDate != oldServiceContractMap.get(sc.Id).EndDate) {
                System.debug('EndDate Updated');
                contractsForMP_CLIUpdateMap.put(sc.Id, sc);
            }

            if (sc.GDMFSL_SC_Block__c && !oldServiceContractMap.get(sc.Id).GDMFSL_SC_Block__c) {
                System.debug('Became blocked');
                servContractIdsBlocked.add(sc.Id);
            }
        }


        if (!servContractIdsBlocked.isEmpty()) {
            GDMFSL_ServiceAppointmentProcessor.unscheduleServContractSAs(servContractIdsBlocked);
        }

        if (!contractsCancelled.isEmpty()) {
            GDMFSL_WorkOrderProcessor.cancelNonCaseRelatedWOs(contractsCancelled);
            GDMFSL_CaseProcessor.cancelContractRelatedCases(contractsCancelled.keySet());
        }

        if (!contractsForMP_CLIUpdateMap.isEmpty()) {
            GDMFSL_MaintenancePlanProcessor.updateMaintenancePlanfromSC(contractsForMP_CLIUpdateMap);
            GDMFSL_ContractLineItemProcessor.updateCLIfromSC(contractsForMP_CLIUpdateMap);
        }

    }

    public static void updateALEFieldsOnSC(List<ServiceContract> serviceContracts) {
        updateALEFieldsOnSC(serviceContracts, null);
    }

    public static void updateALEFieldsOnSC(List<ServiceContract> serviceContracts, Map<Id, ServiceContract> oldServiceContractMap) {
        Set<Id> agreementLevelIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        List<ServiceContract> tobeUpdatedSCs = new List<ServiceContract>();
        Map<Id, GDMFSL_Agreement_Level__c> agreementLevelMap = new Map<Id, GDMFSL_Agreement_Level__c>();

        System.debug('Inside UpdateALEFieldsOnSC');
        for (ServiceContract sc : serviceContracts) {
            if (oldServiceContractMap == null) {

                if (sc.GDMFSL_Agreement_Level__c != null) {
                    tobeUpdatedSCs.add(sc);
                }

            } else {
                if (sc.GDMFSL_Agreement_Level__c != null && sc.GDMFSL_Agreement_Level__c != oldServiceContractMap.get(sc.Id).GDMFSL_Agreement_Level__c) {
                    System.debug('Agreement Level updated on the Service Contract');
                    tobeUpdatedSCs.add(sc);
                }
            }
            if (sc.AccountId != null) {
                accountIds.add(sc.AccountId);
            }
            Map<Id, Account> accountMap = GDMFSL_AccountProcessor.getRecords(accountIds);
            if (sc.AccountId != null && accountMap.containsKey(sc.AccountId)) {
                sc.GDMFSL_Region__c = accountMap.get(sc.AccountId).Region__c;
                tobeUpdatedSCs.add(sc);
            }
        }

        for (ServiceContract sc : tobeUpdatedSCs) {
            agreementLevelIds.add(sc.GDMFSL_Agreement_Level__c);
        }
        if (!agreementLevelIds.isEmpty()) {
            agreementLevelMap = GDMFSL_AgreementLevelProcessor.getRecords(agreementLevelIds);
        }

        if (!agreementLevelMap.isEmpty()) {
            for (ServiceContract sc : tobeUpdatedSCs) {
                if (agreementLevelMap.containsKey(sc.GDMFSL_Agreement_Level__c)) {
                    for (String scFieldName : ALEFIELDSMAPTOSC.keySet()) {
                        System.debug('Set Service Contract Field Value :' + ALEFIELDSMAPTOSC.get(scFieldName) + '  : ' + agreementLevelMap.get(sc.GDMFSL_Agreement_Level__c).get(scFieldName));
                        sc.put(ALEFIELDSMAPTOSC.get(scFieldName), agreementLevelMap.get(sc.GDMFSL_Agreement_Level__c).get(scFieldName));
                    }
                }
            }
        }
    }

    public static Map<Id, List<GDMFSL_Service_Contract_Resource_Pref__c>> getServContractResourcePrefRecords(Set<Id> serviceContractIds) {
        System.debug('getServContractResourcePrefRecords()');

        Map<Id, List<GDMFSL_Service_Contract_Resource_Pref__c>> retMap = new Map<Id, List<GDMFSL_Service_Contract_Resource_Pref__c>>();

        if (serviceContractIds != null && !serviceContractIds.isEmpty()) {

            for (GDMFSL_Service_Contract_Resource_Pref__c r : [
                    SELECT Id, GDMFSL_Preference_Type__c, GDMFSL_Service_Resource__c,
                            GDMFSL_Associated_Contract__r.Service_Contract__c
                    FROM GDMFSL_Service_Contract_Resource_Pref__c
                    WHERE GDMFSL_Service_Resource__r.IsActive = TRUE
                    AND GDMFSL_Service_Resource__r.ResourceType != 'D'
                    AND GDMFSL_Associated_Contract__r.Service_Contract__c IN :serviceContractIds
            ]) {

                if (!retMap.containsKey(r.GDMFSL_Associated_Contract__r.Service_Contract__c)) {
                    retMap.put(r.GDMFSL_Associated_Contract__r.Service_Contract__c, new List<GDMFSL_Service_Contract_Resource_Pref__c>());
                }
                retMap.get(r.GDMFSL_Associated_Contract__r.Service_Contract__c).add(r);
            }
        }

        return retMap;
    }

    public static void setATSHours(List<WorkOrder> lstWorkOrder) {

        Map<Id, List<WorkOrder>> scIdToWOs = new Map<Id, List<WorkOrder>>();

        for (WorkOrder wo : [
                SELECT Id, Work_Type_Category__c, ServiceContractId,
                        GDMFSL_Total_OT_Travel_in_minutes__c,
                        GDMFSL_Total_PT_Travel_in_minutes__c,
                        GDMFSL_Total_Regular_Travel_in_minutes__c,
                        GDMFSL_Total_OT_Labor_in_minutes__c,
                        GDMFSL_Total_PT_Labor_in_minutes__c,
                        GDMFSL_Total_Regular_Labor_in_minutes__c,
                        GDMFSL_Travel_Time_Chargeable__c,
                        ServiceContract.GDMFSL_ATS_BreakFix_Hours__c,
                        ServiceContract.GDMFSL_ATS_PM_Hours__c,
                        ServiceContract.GDMFSL_Travel_Time_Chargeable__c

                FROM WorkOrder
                WHERE Id IN :lstWorkOrder
                AND ServiceContractId != NULL
        ]) {

            if (!scIdToWOs.containsKey(wo.ServiceContractId)) {
                scIdToWOs.put(wo.ServiceContractId, new List<WorkOrder>());
            }

            scIdToWOs.get(wo.ServiceContractId).add(wo);
        }

        if (!scIdToWOs.isEmpty()) {

            List<ServiceContract> scToUpdate = new List<ServiceContract>();

            for (ServiceContract sc : getRecords(scIdToWOs.keySet()).values()) {

                Boolean needsUpdate = false;

                for (WorkOrder wo : scIdToWOs.get(sc.Id)) {

                    Decimal totalLaborHours = 0;
                    totalLaborHours = (wo.GDMFSL_Total_OT_Labor_in_minutes__c  != null ? wo.GDMFSL_Total_OT_Labor_in_minutes__c : 0)
                            + (wo.GDMFSL_Total_PT_Labor_in_minutes__c  != null ? wo.GDMFSL_Total_PT_Labor_in_minutes__c : 0)
                            + (wo.GDMFSL_Total_Regular_Labor_in_minutes__c != null ? wo.GDMFSL_Total_Regular_Labor_in_minutes__c : 0);
                    Decimal totalTravelHours = 0;

                    System.debug('Travel Chargeable: ' + wo.ServiceContract.GDMFSL_Travel_Time_Chargeable__c);
                    if (wo.ServiceContract.GDMFSL_Travel_Time_Chargeable__c) {
                        totalTravelHours = (wo.GDMFSL_Total_OT_Travel_in_minutes__c != null ? wo.GDMFSL_Total_OT_Travel_in_minutes__c : 0)
                                + (wo.GDMFSL_Total_PT_Travel_in_minutes__c != null ? wo.GDMFSL_Total_PT_Travel_in_minutes__c : 0)
                                + (wo.GDMFSL_Total_Regular_Travel_in_minutes__c != null ? wo.GDMFSL_Total_Regular_Travel_in_minutes__c : 0);
                                
                    }


                    Decimal totalHours = (totalTravelHours / 60) + (totalLaborHours / 60);
                    System.debug('Total ATS Hours consumed on Work Order: '+ totalHours);
      

                    switch on wo.Work_Type_Category__c {

                        when 'PM' {
                            System.debug('Deducting PM ATS Hours');
                            if(sc.GDMFSL_Actual_Time_Consumed_PM_Hours__c != null){
                                sc.GDMFSL_Actual_Time_Consumed_PM_Hours__c +=  totalHours;
                            }
                            else{
                                sc.GDMFSL_Actual_Time_Consumed_PM_Hours__c = totalHours;  
                            }
                            needsUpdate = true;
                           
                        }

                        when 'BF' {
                            System.debug('Deducting BF ATS Hours');
                            if(sc.GDMFSL_Actual_Time_Consumed_BF_Hours__c != null){
                                sc.GDMFSL_Actual_Time_Consumed_BF_Hours__c +=  totalHours;
                            }
                            else{
                                sc.GDMFSL_Actual_Time_Consumed_BF_Hours__c =  totalHours;
                            }
                            needsUpdate = true;
                        }
                    }
                }

                if (needsUpdate) {
                    scToUpdate.add(sc);
                }
            }

            System.debug('Total SCs being updated  ' + scToUpdate.size());

            if (scToUpdate.size() > 0) {
                GDMFSL_CommonUtilities.updateRecords(scToUpdate);
            }
        }
    }


}