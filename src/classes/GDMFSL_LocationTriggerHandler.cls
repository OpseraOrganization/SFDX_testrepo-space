/*******************************************************************************************
Name       :    GDMFSL_LocationTriggerHandler 
Purpose    :    Processor Logic for Location object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Varun               2021-Feb-05       Created
**********************************************************************************************/


public without sharing class GDMFSL_LocationTriggerHandler {

    public static final String COMMUNPROFILENAME = label.GDMFSLCOMMUNPROFILENAME;


    public static void handleOperations(TriggerOperation operation, List<Schema.Location> newRecs, Map<Id, Schema.Location> oldRecsMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()){
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when AFTER_INSERT, AFTER_UPDATE {
                doAfterWork(operation, newRecs, oldRecsMap);
            }
        }
    }


    public static void doAfterWork(TriggerOperation triggerOp, List<Schema.Location> newRecs, Map<Id, Schema.Location> oldMap){
        shareLocationRecords(triggerOp, newRecs, oldMap);
    }


    public static void shareLocationRecords(TriggerOperation triggerOp, List<Schema.Location> newLocationLst, Map<Id, Schema.Location> oldLocationMap) {

        if (triggerOp == TriggerOperation.AFTER_INSERT || triggerOp == TriggerOperation.AFTER_UPDATE) {

            Set<Id> accIds = new Set<Id>();
            Set<Id> locIds = new Set<Id>();

            for (Schema.Location locObj : newLocationLst) {

                locIds.add(locObj.Id);

                if (locObj.GDMFSL_Ship_To_Account__c != null) {
                    accIds.add(locObj.GDMFSL_Ship_To_Account__c);
                }

                if (oldLocationMap != null
                        && oldLocationMap.containsKey(locObj.Id)
                        && oldLocationMap.get(locObj.Id).GDMFSL_Ship_To_Account__c != null) {

                    accIds.add(oldLocationMap.get(locObj.Id).GDMFSL_Ship_To_Account__c);
                }
            }

            System.debug('See if there are any Community Users for any of the Accounts');

            Map<Id, List<Id>> accIdUserIdListMap = new Map<Id, List<Id>>();

            Set<Id> allUserIdsForLocShares = new Set<Id>();

            for (User thisUser : [SELECT Id, Contact.AccountId FROM User WHERE Profile.Name = :COMMUNPROFILENAME AND IsActive = TRUE AND Contact.AccountId IN :accIds]) {

                allUserIdsForLocShares.add(thisUser.Id);

                if (!accIdUserIdListMap.containsKey(thisUser.Contact.AccountId)) {
                    System.debug('Adding AccountID to the Map because we have a Community User: ' + thisUser.Contact.AccountId);
                    accIdUserIdListMap.put(thisUser.Contact.AccountId, new List<Id>());
                }

                System.debug('Adding Community User Id ' + thisUser.Id + ' to the Map for Account ' + thisUser.Contact.AccountId);
                accIdUserIdListMap.get(thisUser.Contact.AccountId).add(thisUser.Id);
            }

            Map<String, List<LocationShare>> locIdUsrLstMap = new Map<String, List<LocationShare>>();

            for (LocationShare locShr : [
                    SELECT Id, ParentId, UserOrGroupId, RowCause
                    FROM LocationShare
                    WHERE ParentId IN :locIds AND UserOrGroupId IN :allUserIdsForLocShares
            ]) {

                if (!locIdUsrLstMap.containsKey(locShr.ParentId + '::' + locShr.UserOrGroupId)) {
                    locIdUsrLstMap.put(locShr.ParentId + '::' + locShr.UserOrGroupId, new List<LocationShare>());
                }

                locIdUsrLstMap.get(locShr.ParentId + '::' + locShr.UserOrGroupId).add(locShr);
            }

            List<LocationShare> sharesToCreate = new List<LocationShare>();
            List<LocationShare> locShareDeleteLst = new List<LocationShare>();

            System.debug('Ready to adjust Location Sharing records');

            for (Schema.Location thisLocation : newLocationLst) {

                if (thisLocation.GDMFSL_Ship_To_Account__c != null
                        && accIdUserIdListMap.containsKey(thisLocation.GDMFSL_Ship_To_Account__c)) {

                    for (Id thisUserId : accIdUserIdListMap.get(thisLocation.GDMFSL_Ship_To_Account__c)) {
                        sharesToCreate.add(new LocationShare(
                                AccessLevel = 'Read',
                                ParentId = thisLocation.Id,
                                UserOrGroupId = thisUserId));
                    }
                }

                if ( triggerOp == TriggerOperation.AFTER_UPDATE
                        && oldLocationMap.containsKey(thisLocation.Id)
                        && oldLocationMap.get(thisLocation.Id).GDMFSL_Ship_To_Account__c != null
                        && thisLocation.GDMFSL_Ship_To_Account__c != oldLocationMap.get(thisLocation.Id).GDMFSL_Ship_To_Account__c
                        && accIdUserIdListMap.containsKey(oldLocationMap.get(thisLocation.Id).GDMFSL_Ship_To_Account__c)) {

                    for (Id thisUserId : accIdUserIdListMap.get(oldLocationMap.get(thisLocation.Id).GDMFSL_Ship_To_Account__c)) {
                        if (locIdUsrLstMap.containsKey(thisLocation.Id + '::' + thisUserId)) {
                            locShareDeleteLst.addAll(locIdUsrLstMap.get(thisLocation.Id + '::' + thisUserId));
                        }
                    }
                }
            }

            if (!sharesToCreate.isEmpty()) {
                GDMFSL_CommonUtilities.insertRecords(sharesToCreate);
            }

            if (!locShareDeleteLst.isEmpty()) {
                GDMFSL_CommonUtilities.deleteRecords(locShareDeleteLst);
            }
        }
    }
}