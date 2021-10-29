@isTest
private class Test_UpdateGoDirectViewForMgtCmpny
{
    private static testMethod void testUpdateGoDirectView() 
    {
       Management_Sold_To__c  mst = new Management_Sold_To__c(Name='10991',Sold_To_Nos__c ='10991');
       insert mst;
       Account acc = new Account();
       acc.Name= 'Test Account';
       acc.Customer_Status__c= 'Active';
       insert acc;
       Account_Cross_Ref__c acr = new Account_Cross_Ref__c();
       acr.XREF_Type__c = 'SAP_SOLD_TO';
       acr.External_Account_ID__c = '10991';
       //acr.account_status__c  = 'Active';
       acr.Site_Code__c = 'test';
       acr.Account_Name__c  = acc.Id;
       insert acr;       
       UpdateGoDirectViewForMgtCmpnyController.getRecord();
    }
}