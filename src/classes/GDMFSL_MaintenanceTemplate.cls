/**
 * Name       :    GDMFSL_MaintenanceTemplate
 * Purpose    :    Wrapper class to encapsulate Maintenance Template data
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * JMay                  2020-Sep-23    Created
 **/
public without sharing class GDMFSL_MaintenanceTemplate {

    public Id theProductId;
    public Id theWorkTypeId;
    public Decimal durationInMinutes;
    public Decimal frequency;
    public String frequencyType;
    public String recurrenceType;
    public String rRuleTemplate;
    public Id recordId;
    public Decimal sortOrder;
    public string name;

    public GDMFSL_MaintenanceTemplate() {
    }

    public static Map<Id, List<GDMFSL_MaintenanceTemplate>> getMaintenanceTemplateForProducts(Set<Id> prodIds) {

        Map<Id, List<GDMFSL_MaintenanceTemplate>> retList = new Map<Id, List<GDMFSL_MaintenanceTemplate>>();

        if (prodIds != null && !prodIds.isEmpty()) {
            for (GDMFSL_Maintenance_Template__c r : [
                    SELECT GDMFSL_Duration_minutes__c,
                            GDMFSL_Frequency_Every_N__c,
                            GDMFSL_Frequency_Type__c,
                            GDMFSL_Product__c,
                            GDMFSL_Recurrence_Type__c,
                            GDMFSL_RRULE_Template__c,
                            GDMFSL_Work_Type__c,
                            GDMFSL_Sort_Order__c,
                            Id,
                            Name,
                            OwnerId
                    FROM GDMFSL_Maintenance_Template__c
                    WHERE GDMFSL_Product__c IN :prodIds
            ]) {

                    if (!retList.containsKey(r.GDMFSL_Product__c)){
                        retList.put(r.GDMFSL_Product__c, new List<GDMFSL_MaintenanceTemplate>());
                    }
                    GDMFSL_MaintenanceTemplate mtForObj = mapsObjectToMaintTemplate(r);
                    if(mtForObj != null){
                        retList.get(r.GDMFSL_Product__c).add(mtForObj);
                }
            }
        }

        return retList;
    }

    @TestVisible
    private static GDMFSL_MaintenanceTemplate mapsObjectToMaintTemplate(GDMFSL_Maintenance_Template__c theSource) {
        if(theSource == null){
            return null;
        } else {
            GDMFSL_MaintenanceTemplate theResult = new GDMFSL_MaintenanceTemplate();
            theResult.recordId = theSource.Id;
            theResult.theProductId = theSource.GDMFSL_Product__c;
            theResult.theWorkTypeId = theSource.GDMFSL_Work_Type__c;
            theResult.durationInMinutes = theSource.GDMFSL_Duration_minutes__c;
            theResult.frequency = theSource.GDMFSL_Frequency_Every_N__c;
            theResult.frequencyType = theSource.GDMFSL_Frequency_Type__c;
            theResult.recurrenceType = theSource.GDMFSL_Recurrence_Type__c;
            theResult.rRuleTemplate = theSource.GDMFSL_RRULE_Template__c;
            theResult.sortOrder=theSource.GDMFSL_Sort_Order__c;
            theResult.name=theSource.Name;

            return theResult;
        }
    }
}