@istest 
public class DSPC_Acclist_controller_Test {
    static testMethod void myUnitTest() {
        Account ac = new Account();
        ac.Name = 'Test Account';
        ac.Customer_Status__c = 'Active';
        ac.Region_Name__c = 'Americas';
        ac.Sub_Region_Name__c = 'United States';
        ac.Service_Level__c = 'Standard';
        ac.Strategic_Business_Unit__c = 'D&S';
        ac.CBT__c = 'DSPC';
        ac.CBT_Team__c = 'Orion';
        ac.Market_Name__c = 'Space';
        ac.Type = 'OEM';
        ac.REPORT_ACCOUNT_NAME__c = 'Test Account';
        insert ac;
        PageReference pageRef = Page.DSPC_Account_List;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',ac.id);
        DSPC_Acclist_controller Cntlr = new DSPC_Acclist_controller();
        Cntlr.New_form();
        Cntlr.AccountRequestStatus();
    }

}