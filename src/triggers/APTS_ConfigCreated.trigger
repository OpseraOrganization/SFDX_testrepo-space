/*
 * Sets contract pricing for fuel efficency proposals 
 */
trigger APTS_ConfigCreated on Apttus_Config2__ProductConfiguration__c (before insert) {
	for (Apttus_Config2__ProductConfiguration__c config : Trigger.new) {
        /*
         * no need to bulkify we always be created as single object
         */ 
        List<Apttus_Proposal__Proposal__c> proposals = [Select Id, APTS_Account_Contract_Numbers__c, RecordType.Name From Apttus_Proposal__Proposal__c 
                                                            	Where Id = :config.Apttus_Config2__BusinessObjectRefId__c And
                                                                      RecordType.Name = 'Fuel Efficiency Proposal'];
        if (proposals !=  null && !proposals.isEmpty()) {
            config.Apttus_Config2__ContractNumbers__c =  proposals[0].APTS_Account_Contract_Numbers__c;
        }
    }
}