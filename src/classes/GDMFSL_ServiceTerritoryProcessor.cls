/**
 * Name       :    GDMFSL_ServiceTerritoryProcessor
 * Purpose    :    Business Logic for Service Territory object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Bryant Daniels        2020-Dec-30      Created
 **/
public without sharing class GDMFSL_ServiceTerritoryProcessor {

    public static String PRIMARYTERRITORYTYPEVALUE = 'P';

    private static Map<Id, ServiceTerritory> retVals = new Map<Id, ServiceTerritory>();

    public static Map<Id, ServiceTerritory> getRecords(Set<Id> serviceTerritoryIds) {

        if (serviceTerritoryIds != null && !serviceTerritoryIds.isEmpty()) {

            Set<Id> newServiceTerritoryIds = new Set<Id>();

            if (retVals.isEmpty()) {
                System.debug('List is empty adding all Service Territories');
                newServiceTerritoryIds.addAll(serviceTerritoryIds);
            } else {
                for (Id serviceTerritoryId : serviceTerritoryIds) {
                    if (!retVals.containsKey(serviceTerritoryId)) {
                        newServiceTerritoryIds.add(serviceTerritoryId);
                    }
                    System.debug('Retrieved New Service Territories List : ' + newServiceTerritoryIds);
                }
            }

            if (!newServiceTerritoryIds.isEmpty()) {
                Map<Id, ServiceTerritory> newServiceTerritoryMap = new Map<Id, ServiceTerritory>([
                        SELECT Id,
                                IsActive,
                                OperatingHoursId,
                                OperatingHours.TimeZone
                        FROM ServiceTerritory
                        WHERE Id IN :newServiceTerritoryIds
                ]);

                retVals.putAll(newServiceTerritoryMap);
                System.debug('Retrieved ServiceTerritories : ' + retVals);
            }

        }

        System.debug('Exit GDMFSL_ServiceTerritoryProcessor:getRecords');
        return retVals;
    }


    public static Map<Id, List<ServiceTerritoryMember>> getSTMs(Set<ServiceResource> servResources, Boolean onlyPrimary){

        Map<Id, List<ServiceTerritoryMember>> servResIdToSTMs = new Map<Id, List<ServiceTerritoryMember>>();

        String stmQuery = getSTMQueryString();
        stmQuery += ' WHERE ServiceResourceId IN :servResources ';

        if (onlyPrimary){
            stmQuery += ' AND TerritoryType = \'' + PRIMARYTERRITORYTYPEVALUE + '\'';
        }

        stmQuery += ' ORDER BY EffectiveStartDate ASC ';

        System.debug('STM query to run: ' + stmQuery);

        for (ServiceTerritoryMember thisSTM : Database.query(stmQuery)){

            System.debug('Found STM Id ' + thisSTM.Id + ' for ServiceRes: ' + thisSTM.ServiceResourceId);

            if (!servResIdToSTMs.containsKey(thisSTM.ServiceResourceId)){
                servResIdToSTMs.put(thisSTM.ServiceResourceId, new List<ServiceTerritoryMember>());
            }

            servResIdToSTMs.get(thisSTM.ServiceResourceId).add(thisSTM);
        }

        return servResIdToSTMs;
    }

    public static Map<Id, List<ServiceTerritoryMember>> getSTMs(Set<Id> servTerrIds, Boolean onlyPrimary){

        Map<Id, List<ServiceTerritoryMember>> servResIdToSTMs = new Map<Id, List<ServiceTerritoryMember>>();

        String stmQuery = getSTMQueryString();
        stmQuery += ' WHERE ServiceTerritoryId IN :servTerrIds ';

        if (onlyPrimary){
            stmQuery += ' AND TerritoryType = \'' + PRIMARYTERRITORYTYPEVALUE + '\'';
        }

        System.debug('STM query to run: ' + stmQuery);

        for (ServiceTerritoryMember thisSTM : Database.query(stmQuery)){

            System.debug('Found STM Id ' + thisSTM.Id + ' for ServiceTerr: ' + thisSTM.ServiceTerritoryId);

            if (!servResIdToSTMs.containsKey(thisSTM.ServiceTerritoryId)){
                servResIdToSTMs.put(thisSTM.ServiceTerritoryId, new List<ServiceTerritoryMember>());
            }

            servResIdToSTMs.get(thisSTM.ServiceTerritoryId).add(thisSTM);
        }

        return servResIdToSTMs;
    }

    @TestVisible
    private static String getSTMQueryString(){

        String stmQuery = 'SELECT Id,  EffectiveEndDate, EffectiveStartDate, OperatingHoursId, ServiceResourceId, TerritoryType ';
        stmQuery += ' , City, Country, CountryCode, PostalCode, State, StateCode, Street ';
        stmQuery += ' , GDMFSL_30_Minutes_Break__c,GDMFSL_45_Minutes_Break__c,GDMFSL_60_Minutes_Break__c, ServiceTerritoryId, ServiceTerritory.OperatingHoursId ';
        stmQuery += ' FROM ServiceTerritoryMember ';

        return stmQuery;
    }

    public static Map<Id, List<Date>> getOpHoursHolidayDates(Set<Id> opHoursIds){

        Map<Id, List<Date>> opHrIdToHolidayDates = new Map<Id, List<Date>>();

        if (opHoursIds != null && !opHoursIds.isEmpty()){

            for (OperatingHoursHoliday thisHolOpHours : [SELECT Id, OperatingHoursId, DateAndTime
                                                        FROM OperatingHoursHoliday
                                                        WHERE OperatingHoursId IN :opHoursIds]){

                if(!opHrIdToHolidayDates.containsKey(thisHolOpHours.OperatingHoursId)){
                    opHrIdToHolidayDates.put(thisHolOpHours.OperatingHoursId, new List<Date>());
                }

                System.debug('Op Hrs Holiday DateaAndTime: ' + thisHolOpHours.DateAndTime);
                List<String> fullDateAndTime = thisHolOpHours.DateAndTime.split(' ');
                opHrIdToHolidayDates.get(thisHolOpHours.OperatingHoursId).add(Date.parse(fullDateAndTime[0]));
            }

            for (Id thisOpHrsId : opHrIdToHolidayDates.keySet()){
                opHrIdToHolidayDates.get(thisOpHrsId).sort();
            }
        }

        return opHrIdToHolidayDates;

    }

    public static List<OperatingHours> getOperatingHours(Set<Id> opHoursIds){

        List<OperatingHours> retVal = new List<OperatingHours>();

        if (opHoursIds != null && !opHoursIds.isEmpty()){

            retVal = new List<OperatingHours>([SELECT Id, TimeZone, GDMFSL_Holiday_Operating_Hours__c
                                                FROM OperatingHours
                                                WHERE Id IN :opHoursIds
                                                OR GDMFSL_Holiday_Operating_Hours__c = TRUE]);
        }

        return retVal;
    }

    public static void updateRelatedServResources(List<ServiceTerritory> newRecs, Map<Id, ServiceTerritory> oldMap){

        if (newRecs != null && oldMap != null){
            setHolidayProcessingDates(newRecs, oldMap);
        }
    }

    @TestVisible
    private static void setHolidayProcessingDates(List<ServiceTerritory> newRecs, Map<Id, ServiceTerritory> oldMap) {

        if (newRecs != null && oldMap != null) {

            Set<Id> servTerrIdsForProcessing = new Set<Id>();

            System.debug('Checking ServTerr for holiday processing dates');

            for (ServiceTerritory thisST : newRecs){

                if (thisST.GDMFSL_Holiday_Processing_Range_Start__c != null
                        && thisST.GDMFSL_Holiday_Processing_Range_End__c != null
                        && (thisST.GDMFSL_Holiday_Processing_Range_Start__c != oldMap.get(thisST.Id).GDMFSL_Holiday_Processing_Range_Start__c
                        || thisST.GDMFSL_Holiday_Processing_Range_End__c != oldMap.get(thisST.Id).GDMFSL_Holiday_Processing_Range_End__c)) {

                    System.debug('ServTerritory needs holiday processing: ' + thisST.Id);
                    servTerrIdsForProcessing.add(thisST.Id);
                }
            }

            System.debug('Have this many ServTerr for holiday processing: ' + servTerrIdsForProcessing.size());

            if (!servTerrIdsForProcessing.isEmpty()){

                Map<Id, List<ServiceTerritoryMember>> servTerrIDToSTMs = getSTMs(servTerrIdsForProcessing, true);

                System.debug('Found STMs for this many ServTerr: ' + servTerrIDToSTMs.size());

                Set<ServiceResource> servResToUpdate = new Set<ServiceResource>();

                for (ServiceTerritory thisST : newRecs){

                    if (servTerrIDToSTMs.containsKey(thisST.Id)){
                        System.debug('Processing STM for Serv Terr: ' + thisST.Id);

                        for (ServiceTerritoryMember thisSTM : servTerrIDToSTMs.get(thisST.Id)){
                            servResToUpdate.add(new ServiceResource(Id = thisSTM.ServiceResourceId,
                                    GDMFSL_Holiday_Processing_Range_Start__c = thisST.GDMFSL_Holiday_Processing_Range_Start__c,
                                    GDMFSL_Holiday_Processing_Range_End__c = thisST.GDMFSL_Holiday_Processing_Range_End__c));
                        }
                    }
                }

                System.debug('Have this many ServRes to update for holiday processing: ' + servResToUpdate.size());

                if(!servResToUpdate.isEmpty()){
                    List<ServiceResource> sResList = new List<ServiceResource>();
                    sResList.addAll(servResToUpdate);
                    GDMFSL_CommonUtilities.updateRecords(sResList);
                }
            }

        }
    }
}