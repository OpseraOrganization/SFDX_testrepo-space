@isTest
public class APTS_ConfigCreatedTest {
    @isTest
    public static void testInsert() {
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        insert proposal;
        
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(
            Apttus_Config2__ContractNumbers__c = '0',
            Apttus_Config2__BusinessObjectRefId__c = proposal.id
        );
        insert config;
        
        config = [Select Id, Apttus_Config2__ContractNumbers__c From Apttus_Config2__ProductConfiguration__c Where Id = :config.id];
        
        System.assertEquals('0', config.Apttus_Config2__ContractNumbers__c);
        
    }
    
    
    @isTest
    public static void testContractNumbers() {
        
        Account account = TestDataFactory.createAccount();
        account.APTS_Contract_Numbers__c = '15';
        update account;

        Id recordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Fuel Efficiency Proposal').getRecordTypeId();
        
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Account__c = account.id,
            RecordtypeId = recordTypeId
        );
        insert proposal;

        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(
            Apttus_Config2__BusinessObjectRefId__c = proposal.id
        );
        insert config;
        
        config = [Select Id, Apttus_Config2__ContractNumbers__c From Apttus_Config2__ProductConfiguration__c Where Id = :config.id];
        
        //System.assertEquals('15', config.Apttus_Config2__ContractNumbers__c);
        
    }
}