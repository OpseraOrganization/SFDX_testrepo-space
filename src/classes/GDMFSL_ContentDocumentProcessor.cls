/**
 * Name       :    GDMFSL_ContentDocumentProcessor
 * Purpose    :    Business Logic for Content Document object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2021-Mar-11    Created
 **/

public without sharing class GDMFSL_ContentDocumentProcessor {


    public static Map<Id, List<ContentDocumentLink>> retVals = new Map<Id, List<ContentDocumentLink>>();

    public static Map<Id, List<ContentDocumentLink>> getCaseRelatedFileRecords(Set<Id> recIds) {
        System.debug('Inside getCaseRelatedFileRecords.getCaseRelatedFileRecords');

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
                Map<Id, ContentDocumentLink> theRecs = new Map<Id, ContentDocumentLink>([
                        SELECT ContentDocumentId,
                                LinkedEntityId
                        FROM ContentDocumentLink
                        WHERE LinkedEntityId IN (SELECT Id FROM Case WHERE Id IN :newRecIds)
                ]);
                if (!theRecs.isEmpty()) {
                    for (ContentDocumentLink cdl : theRecs.values()) {
                        if (!retVals.containsKey(cdl.LinkedEntityId)) {
                            retVals.put(cdl.LinkedEntityId, new List<ContentDocumentLink>());
                        }
                        retVals.get(cdl.LinkedEntityId).add(cdl);
                    }
                }
                System.debug('Return Values Count from Content Document Link : ' + retVals.size());
            }
        }
        return retVals;
    }

    public static void connectContentDocumentToAsset(List<ContentDocument> newRecs) {
        if (newRecs != null && !newRecs.isEmpty()) {

            Map<Id, Id> contentDocumentIdToLinkedEntityIdMap = new Map<Id, Id>();
            Map<Id, Id> woliIdToAssetIdMap = new Map<Id, Id>();
            Set<Id> contentDocIds = new Set<Id>();
            System.debug('Get all the WOLIs for the ContentDocuments that were passed in');

            for (ContentDocument cd : newRecs) {
                contentDocIds.add(cd.Id);
            }
            for (ContentDocumentLink cdl : [
                    SELECT Id, LinkedEntityId, ContentDocumentId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId != NULL
                    AND ContentDocumentId IN :contentDocIds
            ]) {

                if (cdl.LinkedEntityId.getSobjectType() == WorkOrderLineItem.getSObjectType()) {
                    contentDocumentIdToLinkedEntityIdMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
                }
            }

            System.debug('For every WOLI, find the related Asset');
            for (WorkOrderLineItem woli : GDMFSL_WorkOrderLIProcessor.getRecords(contentDocumentIdToLinkedEntityIdMap.values()).values()) {
                if(woli.AssetId!=null) {
                    woliIdToAssetIdMap.put(woli.Id, woli.AssetId);
                }
            }

            System.debug('Create a new ContentDocumentLink between the Asset and the existing ContentDocument');
            List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();

            for (ContentDocument cd2 : newRecs) {

                if (contentDocumentIdToLinkedEntityIdMap.containsKey(cd2.Id)
                        && woliIdToAssetIdMap.containsKey(contentDocumentIdToLinkedEntityIdMap.get(cd2.Id))) {

                    cdlList.add(new ContentDocumentLink(
                            ContentDocumentId = cd2.Id,
                            LinkedEntityId = woliIdToAssetIdMap.get(contentDocumentIdToLinkedEntityIdMap.get(cd2.Id))
                    ));
                }
            }

            System.debug('Insert this many ContentDocumentLink records: ' + cdlList.size());

            if (cdlList.size() > 0) {
                GDMFSL_CommonUtilities.insertRecords(cdlList, false);
            }
        }
    }
}