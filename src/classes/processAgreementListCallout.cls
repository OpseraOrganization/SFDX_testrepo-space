global class processAgreementListCallout implements Schedulable  
{
/*
    BM 10-02-2012: This Scheduled class runs for every 15 minutes and call the GetAgreementURL class to get the
    signed URL for agreements submitted
*/
   global void execute(SchedulableContext sc){  
        GetAgreementURL.calloutSigningURL();
    }
}