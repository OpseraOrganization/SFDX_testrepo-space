@isTest
public class DRNewCreationPageControllerTest {
    public testMethod static void dotest()
    {
        Account acct = new Account();
        acct.name ='Test';
        insert acct;
        
        Opportunity opp = new Opportunity();
        opp.RecordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('D&S Complex').getRecordTypeId();
        opp.Name ='test opp';
        opp.AccountId =acct.id;
        opp.StageName ='Prospecting';
        opp.CloseDate =System.today().addDays(1);
        insert opp;
        
        Apexpages.currentPage().getParameters().put('OppId',opp.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(new Discretionary__c());
        DRNewCreationPageController newCon = new DRNewCreationPageController(controller);
        newCon.DRReq.Estimated_Completion_Date__c =System.today().addDays(5);
        newCon.DRReq.GBE__c = 'Engines';
        newCon.Save();
        newCon.cancel();
    }
}