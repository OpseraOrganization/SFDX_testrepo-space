/*
 * Should update tail count on account group members, whenever tail count changes on account itselft
 */
trigger APTS_TailCountUpdate on Account (after insert, after update, after delete) {
    Map<ID, Decimal> tailCounts = new Map<ID, Decimal>();
    if (Trigger.isUpdate || Trigger.isInsert) {
         for (Account account : Trigger.new) {
             if (Trigger.isInsert || 
                 Trigger.oldMap.get(account.id).APTS_Aviaso_Net_Fleet_Count__c != account.APTS_Aviaso_Net_Fleet_Count__c) {
                 tailCounts.put(account.id, account.APTS_Aviaso_Net_Fleet_Count__c);
             }
    	 }
    } else {
         tailCounts.put(null, 0);
    }
    
    if (!tailCounts.isEmpty()) {
        List<APTS_Account_Group_Member__c> accountMembers = 
            [Select Id, APTS_Account_Net_Tail_Count__c, APTS_Account__c From APTS_Account_Group_Member__c
             Where APTS_Account__c in :tailCounts.keySet()];
        if (accountMembers != null && !accountMembers.isEmpty()) {
            for (APTS_Account_Group_Member__c accountMember : accountMembers) {
                accountMember.APTS_Account_Net_Tail_Count__c = tailCounts.get(accountMember.APTS_Account__c);  
            }
            update accountMembers;
        }
	}
}