public with sharing class GDMFSL_SMSMessageRecipient {
    public GDMFSL_SMSMessageRecipient() {}

    @AuraEnabled @InvocableVariable(required=true)
    public String contextRecordId;

    @AuraEnabled @InvocableVariable(required=true)
    public Id userId;

    @AuraEnabled @InvocableVariable(required=true)
    public String phone;    
    
    @AuraEnabled @InvocableVariable(required=true)
    public String messagingTempateName;
}