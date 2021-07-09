/**
 * Created by uzaroo on 1/13/21.
 */

public without sharing class GDMFSL_WorkPlanTemplateProcessor {

    private static Map<Id, WorkPlanTemplate> retVals = new Map<Id, WorkPlanTemplate>();

    public static Map<Id, WorkPlanTemplate> getRecords(Set<Id> recIds) {

        System.debug('GDMFSL_WorkPlanTemplateProcessor.getRecords()');

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

                Map<Id, WorkPlanTemplate> theRecs = new Map<Id, WorkPlanTemplate>([
                        SELECT Id,
                                Name,
                                IsActive,
                                Description,
                                RelativeExecutionOrder, (
                                SELECT Id,
                                        ExecutionOrder,
                                        WorkPlanTemplateEntryNumber,
                                        WorkStepTemplateId
                                FROM
                                        WorkStepTemplates
                        )
                        FROM WorkPlanTemplate
                        WHERE Id IN :newRecIds

                ]);

                retVals.putAll(theRecs);
                System.debug('Retrieved WorkPlanTemplate: ' + retVals);
            }
        }

        return retVals;
    }

    public static WorkPlan createWOWorkPlanFromWorkPlanTemplate(WorkPlanTemplate wpt, Id woId, Id woliId) {

        WorkPlan wp;

        if (wpt != null) {
            wp = new WorkPlan();
            wp.Name = wpt.Name;
            wp.Description = wpt.Description;
            wp.WorkOrderId = woId;
            wp.ExecutionOrder = wpt.RelativeExecutionOrder;
            wp.WorkOrderLineItemId = woliId;
        }

        System.debug('Returning WorkPlanTemplate: ' + wp);

        return wp;
    }

}