@isTest 
public class REG_API_Trace_Detail_TransRecordTest
{
   /*  @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecordsfortraceBatch();        
    }*/
    
    static testMethod void testMethod1() 
    {
        REG_API_Trace_Detail__c acc = new REG_API_Trace_Detail__c();
        acc.API_Name__c ='Name1';
        acc.Type__c ='Error';
        acc.CreatedDate = system.today()-90;
        insert acc;
        
        //Test.setCreatedDate(acc.Id, Date.today().addDays(-15));
        System.assertEquals(Date.today().addDays(-90),acc.CreatedDate);
        
        Test.startTest();
        REG_API_Trace_Detail_TransRecordBatch obj = new REG_API_Trace_Detail_TransRecordBatch();
        obj.execute(null, new list<sObject>{acc});   
        database.executeBatch(obj);
        Test.stopTest();
        
    }
}