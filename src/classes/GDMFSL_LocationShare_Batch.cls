/*******************************************************************************************
Name       :    GDMFSL_LocationShare_Batch 
Purpose    :    Batch class to share Location records with Contact added as a relationship to any Ship to Account
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Varun               2021-Feb-19      Created
**********************************************************************************************/

public without sharing class GDMFSL_LocationShare_Batch implements Database.Batchable<SObject>, Schedulable {

    public String queryString = 'SELECT AccountId, ContactId, Id, IsActive FROM AccountContactRelation where CreatedDate = TODAY';

    public Database.QueryLocator start(Database.BatchableContext context) {

        return Database.getQueryLocator(queryString);
    }

    public void execute(Database.BatchableContext context, List<AccountContactRelation> acrRecordsList) {

        Map<Id, List<Id>> accIdContactIdLst = new Map<Id, List<Id>>();

        for (AccountContactRelation acr : acrRecordsList) {

            if (!accIdContactIdLst.containsKey(acr.AccountId)) {
                accIdContactIdLst.put(acr.AccountId, new List<Id>());
            }

            accIdContactIdLst.get(acr.AccountId).add(acr.ContactId);
        }

        Map<Id, List<Schema.Location>> accIdLocListMap = new Map<Id, List<Schema.Location>>();

        for (Schema.Location loc : [SELECT Id, GDMFSL_Ship_To_Account__c FROM Location WHERE GDMFSL_Ship_To_Account__c IN :accIdContactIdLst.keySet()]) {

            if (!accIdLocListMap.containsKey(loc.GDMFSL_Ship_To_Account__c)) {
                accIdLocListMap.put(loc.GDMFSL_Ship_To_Account__c, new List<Schema.Location>());
            }

            accIdLocListMap.get(loc.GDMFSL_Ship_To_Account__c).add(loc);
        }

        if (!accIdLocListMap.isEmpty()) {

            Map<String, String> conIdUserIdMap = new Map<String, String>();

            for (User thisUser : [
                    SELECT Id, ContactId
                    FROM User
                    WHERE Profile.Name = :GDMFSL_LocationTriggerHandler.COMMUNPROFILENAME
                    AND IsActive = TRUE
                    AND Contact.AccountId IN :accIdContactIdLst.keySet()
            ]) {

                conIdUserIdMap.put(thisUser.ContactId, thisUser.Id);
            }

            List<LocationShare> sharesToCreate = new List<LocationShare>();

            for (String accId : accIdContactIdLst.keySet()) {

                if (accIdLocListMap.containsKey(accId)) {

                    for (Id thisContId : accIdContactIdLst.get(accId)) {

                        if (conIdUserIdMap.containsKey(thisContId)) {

                            for (Schema.Location loc : accIdLocListMap.get(accId)) {

                                sharesToCreate.add(new LocationShare(
                                        AccessLevel = 'Read',
                                        ParentId = loc.Id,
                                        UserOrGroupId = conIdUserIdMap.get(thisContId)));
                            }
                        }
                    }
                }
            }

            if (!sharesToCreate.isEmpty()) {
                GDMFSL_CommonUtilities.insertRecords(sharesToCreate);
            }
        }
    }

    public void execute(SchedulableContext SC) {
        Database.executeBatch(new GDMFSL_LocationShare_Batch());
    }


    public void finish(Database.BatchableContext context) {

    }
}