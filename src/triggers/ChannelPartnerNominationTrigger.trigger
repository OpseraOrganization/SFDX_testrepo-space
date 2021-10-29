/*****************************************************************
Name            :   ChannelPartnerNomination
Company Name    :   NTTData
Created Date    :   27-Mar-2021
Usages          :   Checks if the Submitted record has a file by checking the Content Document URL
Test Class		:	ChannelPartnerNominationTest
******************************************************************/
trigger ChannelPartnerNominationTrigger on Channel_Partner_Nomination__c (before update) {
    //loops through each Channel partner nomination and checks if the status is changed to pending
    //and content document url is not blank
    for(Channel_Partner_Nomination__c CPN:trigger.new){
        if(trigger.oldmap.get(CPN.Id).approval_status__c != CPN.approval_status__C && CPN.approval_status__C=='pending' && string.isblank(CPN.Content_document_url__c)){
            CPN.addError(label.CPN_no_file_submit);
        }
        /*else if(CPN.approval_status__C=='pending' && string.isblank(CPN.Content_document_url__c)){
            CPN.addError(label.CPN_File_Error_Msg);
        }*/
        //CPN_send_email_w_attachment.sendEmail((trigger.newmap).keyset());
    }
}