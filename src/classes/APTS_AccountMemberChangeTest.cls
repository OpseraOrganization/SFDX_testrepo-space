@isTest
public class APTS_AccountMemberChangeTest {
	@isTest
    public static void testInsert() {
		APTS_Account_Group_Member__c accountGroupMember = TestDataFactory.createAccountGroupMember();
        accountGroupMember = [Select Id, APTS_Account_Net_Tail_Count__c From APTS_Account_Group_Member__c Where APTS_Account_Group_Member__c.APTS_Account__c = :accountGroupMember.APTS_Account__c];
        System.assertEquals(accountGroupMember.APTS_Account_Net_Tail_Count__c, 0);
    }
    
    @isTest
    public static void testUpdate() {
		APTS_Account_Group_Member__c accountGroupMember = TestDataFactory.createAccountGroupMember();
        
        Account account = TestDataFactory.createAccount();
        account.APTS_Aviaso_Minimum_Fleet_Count__c = 5;
        account.APTS_Aviaso_Delta_Fleet_Count__c = 7;
		update account;
        
        accountGroupMember.APTS_Account__c = account.id;
        update accountGroupMember;
        
        accountGroupMember = [Select Id, APTS_Account_Net_Tail_Count__c From APTS_Account_Group_Member__c Where APTS_Account_Group_Member__c.APTS_Account__c = :accountGroupMember.APTS_Account__c];
        System.assertEquals(7, accountGroupMember.APTS_Account_Net_Tail_Count__c);
    } 
}