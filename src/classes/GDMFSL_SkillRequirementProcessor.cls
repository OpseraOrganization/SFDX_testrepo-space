public without sharing class GDMFSL_SkillRequirementProcessor {

    private static Map<Id, SkillRequirement> resPrefsById = new Map<Id, SkillRequirement>();
    private static Map<Id, List<SkillRequirement>> mapParentRecIdToSkillReqs = new Map<Id, List<SkillRequirement>>();

    public static Map<Id, SkillRequirement> getRecords(Set<Id> recIds) {

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (resPrefsById.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!resPrefsById.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, SkillRequirement> theRecs = new Map<Id, SkillRequirement>([
                        SELECT
                                Id,
                                RelatedRecordId,
                                SkillId,
                                SkillLevel
                        FROM SkillRequirement
                        WHERE Id IN :newRecIds

                ]);

                resPrefsById.putAll(theRecs);
                System.debug('Skill Reqs: ' + resPrefsById);
            }
        }

        return resPrefsById;
    }


    public static Map<Id, List<SkillRequirement>> getRecordsForParentId(Set<Id> parentRecIds) {


        if (parentRecIds != null && !parentRecIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (mapParentRecIdToSkillReqs.isEmpty()) {
                newRecIds.addAll(parentRecIds);
            } else {
                for (Id thisRecId : parentRecIds) {
                    if (!mapParentRecIdToSkillReqs.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                // NOTE: this SOQL has to remain in SkillId order so that WorkOrderMerge can properly bucket all WOs using the same sequence of Skills
                for (SkillRequirement sr : [
                        SELECT
                                Id,
                                RelatedRecordId,
                                SkillId,
                                SkillLevel
                        FROM SkillRequirement
                        WHERE RelatedRecordId IN :newRecIds
                        ORDER BY SkillId ASC
                ]) {

                    if (!mapParentRecIdToSkillReqs.containsKey(sr.RelatedRecordId)) {
                        mapParentRecIdToSkillReqs.put(sr.RelatedRecordId, new List<SkillRequirement>());
                    }

                    mapParentRecIdToSkillReqs.get(sr.RelatedRecordId).add(sr);
                }
            }
        }

        return mapParentRecIdToSkillReqs;
    }


    public static Map<Id, Map<Id, Decimal>> getParentRecordIdSkillLevels(Map<Id, List<SkillRequirement>> pareRecIDToSkillReqs) {

        Map<Id, Map<Id, Decimal>> retval = new Map<Id, Map<Id, Decimal>>();

        if (pareRecIDToSkillReqs != null && !pareRecIDToSkillReqs.isEmpty()) {

            for (Id theParRecId : pareRecIDToSkillReqs.keySet()) {

                System.debug('Finding Skill Levels for Parent Rec ID: ' + theParRecId);

                retval.put(theParRecId, new Map<Id, Decimal>());

                for (SkillRequirement skillReq : pareRecIDToSkillReqs.get(theParRecId)) {

                    System.debug('Adding Skill Id: ' + skillReq.SkillId);
                    System.debug('and Level: ' + skillReq.SkillLevel);
                    retval.get(theParRecId).put(skillReq.SkillId, skillReq.SkillLevel);
                }
            }
        }

        return retval;
    }




}