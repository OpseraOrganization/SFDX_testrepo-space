@isTest
public class CountNumberOfOpenActivitiesTest 
{
    static testMethod void testMethod1() 
    {
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        try{
          insert acc;
        }Catch(Exception ex){}

        Contact con = new Contact();
        con.FirstName = 'KapilM';
        con.LastName = 'Singh';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'kapil.nowhere@gmail.com';
        con.Email='kapil.nowhere@gmail.com';
        try {
         insert con;
        }Catch(Exception ex){}
        List<Case> lstCase = new List<Case>();
        //for(Integer i=0 ;i <200;i++)
        //{
            Case cs = new Case();
            cs.RecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('OEM/Spares').getRecordTypeId();
            cs.Origin = 'Phone';
            cs.Status = 'Open';
            if(con.Id != NULL || con.Id != ''){
            cs.ContactId = con.Id;
            }else {
            cs.ContactId = [Select Id from Contact Limit 1].Id;
            }
           cs.Classification__c = 'GTO Field Service';
           cs.HON_Commit_Date__c = System.now() + 1;
           cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
           cs.Government_Compliance_SM_M_Content__c = 'NO';
           lstCase.add(cs);
        //}
        
        insert lstCase;
        
        Test.startTest();

            CountNumberOfOpenActivities obj = new CountNumberOfOpenActivities();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}