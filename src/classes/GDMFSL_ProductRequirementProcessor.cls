public without sharing class GDMFSL_ProductRequirementProcessor {

    private static Map<Id, ProductRequired> prodPrefsById = new Map<Id, ProductRequired>();
    private static Map<Id, List<ProductRequired>> mapParentRecIdToProdReqs = new Map<Id, List<ProductRequired>>();

    public static Map<Id, ProductRequired> getRecords(Set<Id> recIds) {

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (prodPrefsById.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!prodPrefsById.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, ProductRequired> theRecs = new Map<Id, ProductRequired>([
                        SELECT
                                Id,
                                ParentRecordId,
                                Product2Id,
                                QuantityRequired,
                                QuantityUnitOfMeasure
                        FROM ProductRequired
                        WHERE Id IN :newRecIds

                ]);

                prodPrefsById.putAll(theRecs);
                System.debug('Prod Reqs: ' + prodPrefsById);
            }
        }

        return prodPrefsById;
    }


    public static Map<Id, List<ProductRequired>> getRecordsForParentId(Set<Id> parentRecIds) {


        if (parentRecIds != null && !parentRecIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (mapParentRecIdToProdReqs.isEmpty()) {
                newRecIds.addAll(parentRecIds);
            } else {
                for (Id thisRecId : parentRecIds) {
                    if (!mapParentRecIdToProdReqs.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                for (ProductRequired r : [
                        SELECT
                                Id,
                                ParentRecordId,
                                Product2Id,
                                QuantityRequired,
                                QuantityUnitOfMeasure
                        FROM ProductRequired
                        WHERE ParentRecordId IN :newRecIds
                ]) {

                    if (!mapParentRecIdToProdReqs.containsKey(r.ParentRecordId)) {
                        mapParentRecIdToProdReqs.put(r.ParentRecordId, new List<ProductRequired>());
                    }

                    mapParentRecIdToProdReqs.get(r.ParentRecordId).add(r);
                }
            }
        }

        return mapParentRecIdToProdReqs;
    }
}