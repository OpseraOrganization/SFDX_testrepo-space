global without sharing class GDMFSL_ServiceAppointmentGenerator implements Database.Batchable<SObject>, Schedulable {

    public static final Decimal DEFAULTMAXSERVICEAPPTDURATIONHRS = 7.5;

    public String str_SOQL;
    public List<Id> woIdsToTestWith;
    public Integer jobBatchSize = 100;

    public Integer startTimeLookBackMinutes = 240;

    public Datetime startingDateTime;
    public Datetime endingDateTime;

    global GDMFSL_ServiceAppointmentGenerator() {

        woIdsToTestWith = new List<Id>();

        str_SOQL = 'SELECT Id, StartDate, EndDate, Duration ';
        str_SOQL += ' , ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c, ServiceTerritory.GDMFSL_Discarded_SA_Duration_Min__c  ';
        str_SOQL += ' FROM WorkOrder WHERE (Status = \'New\' OR Status = \'Scheduled\') ';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {

        if (woIdsToTestWith.isEmpty()) {
            str_SOQL += ' AND GDMFSL_Created_by_WO_Merge_Process__c = TRUE ' ;
        } else {
            str_SOQL += ' AND Id IN :woIdsToTestWith ';
        }

        if (startingDateTime != null && endingDateTime != null) {

            System.debug('Adding query filter for WO Creation date range');

            str_SOQL += ' AND CreatedDate > :startingDateTime AND CreatedDate < :endingDateTime ';

        } else if (startTimeLookBackMinutes > 0) {

            System.debug('Adding query filter for WO Creation range of previous minutes: ' + startTimeLookBackMinutes);

            startingDateTime = Datetime.now().addMinutes((-1 * startTimeLookBackMinutes));
            str_SOQL += ' AND CreatedDate > :startingDateTime ';
        }

        str_SOQL += ' ORDER BY ServiceTerritoryId ';

        System.debug('ServiceAppt Generator query: ' + str_SOQL);

        return Database.getQueryLocator(str_SOQL);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {

        generateSAs((List<WorkOrder>) scope);
    }


    global void finish(Database.BatchableContext param1) {

    }

    global void execute(SchedulableContext ctx) {

        GDMFSL_ServiceAppointmentGenerator theJob = new GDMFSL_ServiceAppointmentGenerator();

        for (WorkOrder theWO : [
                SELECT Id
                FROM WorkOrder
                WHERE (GDMFSL_Created_by_WO_Merge_Process__c = TRUE 
                       OR MaintenancePlan.GDMFSL_Multi_day_Asset_Maintenance__c = TRUE 
                       OR MaintenancePlan.GDMFSL_Requires_Assistant__c = TRUE)
                AND ServiceAppointmentCount = 0
        ]) {

            theJob.woIdsToTestWith.add(theWO.Id);
        }

        if (!theJob.woIdsToTestWith.isEmpty()) {
            theJob.startTimeLookBackMinutes = 0;
            Database.executeBatch(theJob, jobBatchSize);
        }
    }


    private void generateSAs(List<WorkOrder> theWOs) {

        List<ServiceAppointment> saSToCreate = new List<ServiceAppointment>();

        Map<Id, Decimal> woIDToTotalDuration = new Map<Id, Decimal>();

        for (AggregateResult thisRes :[SELECT WorkOrderId woID, SUM(GDMFSL_Total_Duration__c) totDuration
                                        FROM WorkOrderLineItem
                                        WHERE WorkOrderId IN :theWOs
                                        GROUP BY WorkOrderId]){


            System.debug('WorkOrder ID: ' + thisRes.get('woID'));
            System.debug('Tot Duration: ' + thisRes.get('totDuration'));

            woIDToTotalDuration.put((Id) thisRes.get('woID'), (Decimal) thisRes.get('totDuration'));
        }

        for (WorkOrder thisWO : theWOs) {

            System.debug('Working on WO: ' + thisWO.Id);
            System.debug('ServTerr Max Duration Hrs: ' + thisWO.ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c);
            System.debug('ServTerr Discard Duration Mins: ' + thisWO.ServiceTerritory.GDMFSL_Discarded_SA_Duration_Min__c);
            System.debug('WO Duration: ' + thisWO.Duration);

            if (thisWO.ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c == null) {
                System.debug('ServTerritory.Maximum_SA_Duration_Hrs is null, defaulting to ' + (DEFAULTMAXSERVICEAPPTDURATIONHRS * 60));
            }

            if (woIDToTotalDuration.containsKey(thisWO.Id)) {

                System.debug('Has WOLIs');

                Decimal remainingDuration = woIDToTotalDuration.get(thisWO.Id);

                System.debug('Total WOLI Duration: ' + remainingDuration);

                Decimal discardMins = thisWO.ServiceTerritory.GDMFSL_Discarded_SA_Duration_Min__c != null ? thisWO.ServiceTerritory.GDMFSL_Discarded_SA_Duration_Min__c : 0;
                Decimal maxSADurationMins = thisWO.ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c != null ? thisWO.ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c * 60 : (DEFAULTMAXSERVICEAPPTDURATIONHRS * 60);

                if (maxSADurationMins <= discardMins) {
                    System.debug('ServiceTerritory Max SA Duration is not properly set -> it is lower or equal to Discard Mins');

                } else {

                    Boolean firstRound = true;
                    while (firstRound || remainingDuration > discardMins) {

                        firstRound = false;
                        ServiceAppointment thisSA = new ServiceAppointment();
                        thisSA.ParentRecordId = thisWO.Id;
                        thisSA.EarliestStartTime = thisWO.StartDate;

                        thisSA.DurationType = 'Minutes';
                        if (remainingDuration <= maxSADurationMins) {
                            System.debug('Creating an SA with the remaining Duration: ' + remainingDuration);
                            thisSA.Duration = remainingDuration;
                            remainingDuration = 0;
                        } else {
                            System.debug('Creating an SA with the max Duration');
                            thisSA.Duration = maxSADurationMins;
                            remainingDuration -= maxSADurationMins;
                        }

                        saSToCreate.add(thisSA);
                    }
                }
            }  else {
                System.debug('No WOLIs, no SAs needed');
            }
        }


        System.debug('Have this many SAs to create: ' + saSToCreate.size());
        if (!saSToCreate.isEmpty()) {
            GDMFSL_CommonUtilities.insertRecords(saSToCreate, false);
        }
    }

}