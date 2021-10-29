/*****************************************************************
Name            :   CPNFromAccountAddress
Created By      :   Shanthi
Company Name    :   NTTData
Created Date    :   01-JAN-2020
******************************************************************/
trigger CPNFromAccountAddress on Channel_Partner_Nomination__c (before insert,before Update) {
   if(trigger.isBefore && trigger.isInsert){
    CPNFromAccountAddress.getDistributorLineItems(trigger.new);
    CPNFromAccountAddress.getAttachments(trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate){
    CPNFromAccountAddress.getDistributorLineItems(trigger.new);
     if(trigger.isExecuting){
              system.debug('Is Executable'+trigger.isExecuting);
    CPNFromAccountAddress.legalApproverField(trigger.new);
    }
    CPNFromAccountAddress.getAttachments(trigger.new);
    }
}