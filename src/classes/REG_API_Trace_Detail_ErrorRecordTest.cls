@isTest 
public class REG_API_Trace_Detail_ErrorRecordTest 
{
    static testMethod void testMethod1() 
    {
        REG_API_Trace_Detail__c acc = new REG_API_Trace_Detail__c();
        acc.API_Name__c ='Name1';
        acc.Type__c ='Error';
        acc.CreatedDate = system.today()-15;
        insert acc;
         
        //Test.setCreatedDate(acc.Id, Date.today().addDays(-15));
        System.assertEquals(Date.today().addDays(-15), acc.CreatedDate);
        
        Test.startTest();
        REG_API_Trace_Detail_ErrorRecordBatch obj = new REG_API_Trace_Detail_ErrorRecordBatch();
        obj.execute(null, new list<sObject>{acc});   
        database.executeBatch(obj);
        Test.stopTest();
        
    }
}