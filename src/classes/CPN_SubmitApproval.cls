/*****************************************************************
Name            :   CPN_SubmitApproval
Company Name    :   NTTData
Created Date    :   27-Mar-2021
Usages          :   Submits the record for approval process from Lightning component
Test Class		:	ChannelPartnerNominationTest
******************************************************************/
public class CPN_SubmitApproval {
	@AuraEnabled
    public static void submitforApproval(Id recordId){
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(recordId);
        try{
            Approval.ProcessResult result = Approval.process(app);
        }
        catch(Exception ex){
            throw new AuraHandledException('Something went wrong: '
            + ex.getMessage());  
        }
    }
}