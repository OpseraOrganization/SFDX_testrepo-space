/**
 * Created by uzaroo on 1/13/21.
 */

public without sharing class GDMFSL_WorkStepTemplateProcessor {

    //Mapping of Fields from a  WorkStep object==>WorkStepTemplate
    @TestVisible
    private static final Map<String, String> STEPTEMPLATETOWORKSTEP = new Map<String, String>{
            'ActionDefinition'=>'ActionDefinition',
            'GDMFSL_AI__c'=>'GDMFSL_AI__c',
            'GDMFSL_AI_Factor__c'=>'GDMFSL_AI_Factor__c',
            'GDMFSL_Analytics_Impact__c'=>'GDMFSL_Analytics_Impact__c',
            'GDMFSL_AO__c'=>'GDMFSL_AO__c',
            'GDMFSL_AO_Factor__c'=>'GDMFSL_AO_Factor__c',
            'GDMFSL_Connected_Analytics_Task_Category__c'=>'GDMFSL_Connected_Analytics_Task_Category__c',
            'Description'=>'Description',
            'GDMFSL_DI__c'=>'GDMFSL_DI__c',
            'GDMFSL_DI_Factor__c'=>'GDMFSL_DI_Factor__c',
            'GDMFSL_DO__c'=>'GDMFSL_DO__c',
            'GDMFSL_DO_Factor__c'=>'GDMFSL_DO_Factor__c',
            'GDMFSL_Duration_in_Minutes__c'=>'GDMFSL_Duration_in_Minutes__c',
            'GDMFSL_Dynamic_Maint_Analysed_Points__c'=>'Dynamic_Maintenance_Analysed_Points__c',
            'GDMFSL_Is_Reading__c'=>'GDMFSL_Is_Reading__c',
            'Name'=>'Name',
            'GDMFSL_Reading_UOM__c'=>'GDMFSL_Reading_UOM__c',
            'GDMFSL_Relative_Sort_Order__c'=>'GDMFSL_Relative_Sort_Order__c',
            'GDMFSL_SFG_Criticality__c'=>'GDMFSL_SFG_Criticality__c',
            'GDMFSL_SW__c'=>'GDMFSL_SW__c',
            'GDMFSL_Task_Type__c'=>'GDMFSL_Task_Type__c',
            'GDMFSL_Total_HW__c'=>'GDMFSL_Total_HW__c',
            'GDMFSL_Total_Points__c'=>'GDMFSL_Total_Points__c',
            'GDMFSL_Total_Time_Min_Cal_Points_x_Freq__c'=>'Total_Time_in_Min_Cal_from_Points_x_Freq__c',
            'GDMFSL_Total_Time_in_Minutes__c'=>'GDMFSL_Total_Time_in_Minutes__c',
            'GDMFSL_Total_Time_Per_Year_in_Hours__c'=>'GDMFSL_Total_Time_Per_Year_in_Hours__c',
            'GDMFSL_Total_Time_Per_Year_in_Minute__c'=>'GDMFSL_Total_Time_Per_Year_in_Minute__c',
            'GDMFSL_Total_Time_Analytics_Per_Year_Hr__c'=>'Total_Time_with_Analytics_Per_Yr_in_Hour__c',
            'GDMFSL_Traditional_Service_Freq_Per_Year__c'=>'GDMFSL_Traditional_Service_Freq_Per_Year__c',
            'GDMFSL_Virtual_Point_Factor__c'=>'GDMFSL_Virtual_Point_Factor__c'
    };

    private static Map<Id, WorkStepTemplate> retVals = new Map<Id, WorkStepTemplate>();

    public static Map<Id, WorkStepTemplate> getRecords(Set<Id> recIds) {

        System.debug('GDMFSL_WorkStepTemplateProcessor.getRecords()');

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

                Map<Id, WorkStepTemplate> theRecs = new Map<Id, WorkStepTemplate>([
                        SELECT  ActionDefinition,
                                IsActive,
                                GDMFSL_AI__c,
                                GDMFSL_AI_Factor__c,
                                GDMFSL_Analytics_Impact__c,
                                GDMFSL_AO__c,
                                GDMFSL_AO_Factor__c,
                                GDMFSL_Connected_Analytics_Task_Category__c,
                                Description,
                                GDMFSL_DI__c,
                                GDMFSL_DI_Factor__c,
                                GDMFSL_DO__c,
                                GDMFSL_DO_Factor__c,
                                GDMFSL_Duration_in_Minutes__c,
                                Dynamic_Maintenance_Analysed_Points__c,
                                GDMFSL_External_ID__c,
                                GDMFSL_Is_Reading__c,
                                Name,
                                GDMFSL_Reading_UOM__c,
                                GDMFSL_Relative_Sort_Order__c,
                                GDMFSL_SFG_Criticality__c,
                                GDMFSL_SW__c,
                                GDMFSL_Task_Type__c,
                                GDMFSL_Total_HW__c,
                                GDMFSL_Total_Points__c,
                                Total_Time_in_Min_Cal_from_Points_x_Freq__c,
                                GDMFSL_Total_Time_in_Minutes__c,
                                GDMFSL_Total_Time_Per_Year_in_Hours__c,
                                GDMFSL_Total_Time_Per_Year_in_Minute__c,
                                Total_Time_with_Analytics_Per_Yr_in_Hour__c,
                                GDMFSL_Traditional_Service_Freq_Per_Year__c,
                                GDMFSL_Virtual_Point_Factor__c
                        FROM WorkStepTemplate
                        WHERE Id IN :newRecIds

                ]);

                retVals.putAll(theRecs);
                System.debug('Retrieved WorkStep templates: ' + retVals);
            }
        }

        return retVals;
    }

    public static WorkStep createWorkStepFromWorkStepTemplate(WorkStepTemplate wst, Id workorderId, Id workPlanId, Integer executionOrder, Id woliId)
    {
        WorkStep ws;

        if (wst != null) {
            ws = new WorkStep();

            for (String wstFieldName : STEPTEMPLATETOWORKSTEP.keySet()) {
                System.debug('WorkStep Field : Value ' + wstFieldName + ' : ' + wst.get(STEPTEMPLATETOWORKSTEP.get(wstFieldName)));
                ws.put(wstFieldName, wst.get(STEPTEMPLATETOWORKSTEP.get(wstFieldName)));
            }

           //ws.WorkOrderId = workorderId;
            ws.WorkPlanId = workPlanId;
         //  ws.WorkOrderLineItemId = woliId;
            ws.ExecutionOrder = executionOrder != null ? executionOrder : 0;
        }

        System.debug('Returning WorkStep: ' + ws);
        return ws;
    }
}