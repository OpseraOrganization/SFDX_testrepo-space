@isTest
public class APTS_TailCountUpdateTest {
    
    @isTest
    public static void testInsert() {
		APTS_Account_Group_Member__c accountGroupMember = TestDataFactory.createAccountGroupMember();
        accountGroupMember = [Select Id, APTS_Account_Net_Tail_Count__c From APTS_Account_Group_Member__c Where APTS_Account_Group_Member__c.APTS_Account__c = :accountGroupMember.APTS_Account__c];
        System.assertEquals(accountGroupMember.APTS_Account_Net_Tail_Count__c, 0);
    }  
    
    @isTest
    public static void testUpdate() {
		APTS_Account_Group_Member__c accountGroupMember = TestDataFactory.createAccountGroupMember();
        Account account = [Select Id, Name From Account Where Id = :accountGroupMember.APTS_Account__c];
        account.APTS_Aviaso_Minimum_Fleet_Count__c = 5;
        account.APTS_Aviaso_Delta_Fleet_Count__c = 7;
		update account;
        accountGroupMember = [Select Id, APTS_Account_Net_Tail_Count__c From APTS_Account_Group_Member__c Where APTS_Account_Group_Member__c.APTS_Account__c = :accountGroupMember.APTS_Account__c];
        System.assertEquals(7, accountGroupMember.APTS_Account_Net_Tail_Count__c);
    }
    
    @isTest
    public static void testUpdate2() {
		APTS_Account_Group_Member__c accountGroupMember = TestDataFactory.createAccountGroupMember();
        Account account = [Select Id, Name From Account Where Id = :accountGroupMember.APTS_Account__c];
        account.APTS_Aviaso_Minimum_Fleet_Count__c = 9;
        account.APTS_Aviaso_Delta_Fleet_Count__c = 7;
		update account;
        accountGroupMember = [Select Id, APTS_Account_Net_Tail_Count__c From APTS_Account_Group_Member__c Where APTS_Account_Group_Member__c.APTS_Account__c = :accountGroupMember.APTS_Account__c];
        System.assertEquals(9, accountGroupMember.APTS_Account_Net_Tail_Count__c);
    }
    
    @isTest
    public static void testDelete() {
		APTS_Account_Group_Member__c accountGroupMember = TestDataFactory.createAccountGroupMember();
        Account account = [Select Id, Name From Account Where Id = :accountGroupMember.APTS_Account__c];
        account.APTS_Aviaso_Delta_Fleet_Count__c = 7;
		update account;
        accountGroupMember = [Select Id, APTS_Account_Net_Tail_Count__c From APTS_Account_Group_Member__c Where APTS_Account_Group_Member__c.APTS_Account__c = :accountGroupMember.APTS_Account__c];
        System.assertEquals(7, accountGroupMember.APTS_Account_Net_Tail_Count__c);
        delete account;
        accountGroupMember = [Select Id, APTS_Account_Net_Tail_Count__c From APTS_Account_Group_Member__c Where APTS_Account_Group_Member__c.Id = :accountGroupMember.Id];
        System.assertEquals(0, accountGroupMember.APTS_Account_Net_Tail_Count__c);
    }
    
}