global class APTS_ProcessFailedAttachmentsSchedule Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        database.executebatch(new APTS_SendFailedAttachmentstoSAP());
    }

    
}