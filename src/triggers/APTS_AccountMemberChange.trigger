/*
 * copies tail count form account on change
 */
trigger APTS_AccountMemberChange on APTS_Account_Group_Member__c (before insert, before update) {
	for (APTS_Account_Group_Member__c accountMember : Trigger.new) {
        /*
         * no need to bulkify will be updated manually only
         */
        List<Account> accounts = [Select APTS_Aviaso_Net_Fleet_Count__c From Account
                       Where Id = :accountMember.APTS_Account__c];
        if (accounts != null && !accounts.isEmpty()) {
            accountMember.APTS_Account_Net_Tail_Count__c = accounts.get(0).APTS_Aviaso_Net_Fleet_Count__c;
        } 
        if (accounts == null || accounts.isEmpty() || accountMember.APTS_Account__c == null) {
            accountMember.APTS_Account_Net_Tail_Count__c = 0;
        }
    }
}