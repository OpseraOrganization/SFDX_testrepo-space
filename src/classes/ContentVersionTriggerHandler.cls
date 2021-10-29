/*****************************************************************
Name            :   ContentVersionTriggerHandler
Company Name    :   NTTData
Created Date    :   27-Mar-2021
Usages          :   Used in ContentVersionTrigger.
					1. RAPD - 7779 - Checks if the channel partner nomination's approval status is pending/approved 
Test Class		:	ChannelPartnerNominationTest
******************************************************************/
public class ContentVersionTriggerHandler {
    //Checks if the status of the channel partner nomination is not pending before deleting.
    public static void checkifCPNispending(Map<Id,ContentVersion> triggerMap){
        //Stores Content Document Id and Content version Id
        map<id,id> contentDocVerMap = new map<id,id>();
        //Stores LinkedEntityId and Content document Id
        map<id,id> ContentDocEntity = new map<id,id>();
        //loops through each content version
        for(contentversion CV:triggerMap.values()){
            contentDocVerMap.put(CV.contentDocumentId,CV.Id);
        }
        //loops through each content document link
        for(ContentDocumentLink CDL:[Select LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId in: contentDocVerMap.keyset()]){
            if((CDL.LinkedEntityId).getSObjectType().getDescribe().getName() == 'channel_partner_nomination__c'){
                ContentDocEntity.put(CDL.LinkedEntityId,CDL.ContentDocumentId);
            }
        }
        for(channel_partner_nomination__c CPN:[Select id,Approval_status__c,Name from channel_partner_nomination__c where id in: ContentDocEntity.keyset()]){
            if(CPN.Approval_status__c == 'pending' || CPN.Approval_status__c == 'approved'){
                triggerMap.get(contentDocVerMap.get(ContentDocEntity.get(CPN.Id))).addError(label.CPN_File_Error_Msg + ' for the record ' + CPN.Name);
            }
        }
        
    }
}