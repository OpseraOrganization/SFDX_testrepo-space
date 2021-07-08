/**
 * Name       :    GDMFSL_ContractLineItemProcessor
 * Purpose    :    Processor Logic for ContractLine Item object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2020-Oct-12    Created
 **/
public without sharing class GDMFSL_ContractLineItemProcessor {

    public static Map<Id, Map<Id, List<ContractLineItem>>> getRecords(Set<Id> serviceContractIds, Set<Id> assetIds) {

        System.debug('Inside GDMFSL_ContractLineItemProcessor');

        Map<Id, Map<Id, List<ContractLineItem>>> scAssetRelatedCLI = new Map<Id, Map<Id, List<ContractLineItem>>>();

        for (ContractLineItem contractLineItem : [
                SELECT
                        StartDate,
                        EndDate,
                        Id,
                        AssetId,
                        ServiceContractId,
                        GDMFSL_Warranty_Services__c,
                        GDMFSL_Parts_Replacement_Managment__c,
                        GDMFS_PO_Number_Reactive_Coverage__c,
                        GDMFSL_Reactive_Work_Not_Chargeable__c,
                        GDMFSL_Office_Hr_Reactive_Response__c,
                        GDMFSL_After_Hr_Reactive_Response__c,
                        GDMFSL_X24hr_Reactive_Response__c,
                        GDMFSL_HolidayNoReactiveCoverage__c,
                        GDMFSL_24HrCoverage_BusinessDays__c,
                        GDMFSL_Maintenance_Hours__c, (
                        SELECT Id,GDMFSL_Priority__c,GDMFSL_Resolution_Time__c,
                                GDMFSL_Response_Time__c,GDMFSL_Arrival_Time__c,
                                GDMFSL_Associated_Contract__c,GDMFSL_Contract_Line_Item__c
                        FROM SLAs__r
                )
                FROM ContractLineItem
                WHERE
                ServiceContractId IN :serviceContractIds AND
                AssetId IN :assetIds
        ]) {

            if (!scAssetRelatedCLI.containsKey(contractLineItem.ServiceContractId)) {
                scAssetRelatedCLI.put(contractLineItem.ServiceContractId, new Map<Id, List<ContractLineItem>>());
            }

            if (!scAssetRelatedCLI.get(contractLineItem.ServiceContractId).containsKey(contractLineItem.AssetId)) {
                scAssetRelatedCLI.get(contractLineItem.ServiceContractId).put(contractLineItem.AssetId, new List<ContractLineItem>());
            }

            scAssetRelatedCLI.get(contractLineItem.ServiceContractId).get(contractLineItem.AssetId).add(contractLineItem);
        }

        System.debug('Exit GDMFSL_ContractLineItemProcessor return value count : ' + scAssetRelatedCLI.size());
        return scAssetRelatedCLI;
    }

    public static void updateCLIfromSC(Map<Id, ServiceContract> serviceContractMap) {

        if (serviceContractMap != null && !serviceContractMap.isEmpty()) {
            List<ContractLineItem> clisToUpdate = new List<ContractLineItem>();

            for (ContractLineItem cli : [
                    SELECT
                            StartDate,
                            EndDate,
                            Id,
                            ServiceContractId
                    FROM ContractLineItem
                    WHERE
                            ServiceContractId IN :serviceContractMap.keySet()
            ]) {
                if (cli.StartDate <= serviceContractMap.get(cli.ServiceContractId).EndDate) {
                    cli.EndDate = serviceContractMap.get(cli.ServiceContractId).EndDate;
                    clisToUpdate.add(cli);
                }
            }

            if (!clisToUpdate.isEmpty()) {
                GDMFSL_CommonUtilities.updateRecords(clisToUpdate);
            }
        }
    }

}