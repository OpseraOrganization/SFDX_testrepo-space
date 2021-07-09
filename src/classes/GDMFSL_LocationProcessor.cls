/*******************************************************************************************
Name       :    GDMFSL_LocationProcessor
Purpose    :    Processor Logic for Location object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-07    Created
**********************************************************************************************/

public without sharing class GDMFSL_LocationProcessor {

    private static Map<Id, Schema.Location> retVals = new Map<Id, Schema.Location>();

    public static Map<Id, Schema.Location> getRecords(Set<Id> recIds) {

        System.debug('Inside GDMFSL_LocationProcessor.getRecords');

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (retVals.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!retVals.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, Schema.Location> theRecs = new Map<Id, Schema.Location>([
                        SELECT Id,
                                GDMFSL_Service_Territory__c,
                                GDMFSL_Working_Hours__c,
                                GDMFSL_Address__c,
                                GDMFSL_Vertical__c,
                                GDMFSL_Address__r.Street,
                                GDMFSL_Address__r.City,
                                GDMFSL_Address__r.State,
                                GDMFSL_Address__r.PostalCode,
                                GDMFSL_Address__r.Country,
                                GDMFSL_Site_License__c,
                                Location,
                                GDMFSL_Ship_To_Account__c,
                                GDMFSL_Ship_To_Account__r.Name,
                                GDMFSL_Ship_To_Account__r.Region__c,
                                GDMFSL_Service_Territory__r.GDMFSL_Price_Book__c,
                                GDMFSL_Service_Territory__r.GDMFSL_Price_Book__r.Name,
                                GDMFSL_Is_Classified__c,
                                GDMFSL_Extra_Travel_Time__c,
                                GDMFSL_SAP_Customer_Number__c,
                                GDMFSL_Region__c,
                                GDMFSL_Working_Hours__r.TimeZone, (
                                SELECT Id,
                                        GDMFSL_Preference_Type__c,
                                        GDMFSL_Service_Resource__c
                                FROM Location_Resource_Preferences__r
                                WHERE GDMFSL_Service_Resource__r.IsActive = TRUE
                                AND GDMFSL_Service_Resource__r.ResourceType != 'D'
                        )
                        FROM Location
                        WHERE
                                Id IN :newRecIds

                ]);

                retVals.putAll(theRecs);
                System.debug('Retrieved Locations: ' + retVals);
            }
        }

        return retVals;
    }

}