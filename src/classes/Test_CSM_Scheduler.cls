@isTest
public class Test_CSM_Scheduler
  {
  public static testmethod void test_CSMSchedular()
      
   {
   Case c=new Case();
   RecordType c1 = [select id , name from RecordType where name='CSM Toolbox'];
                c.RecordTypeId=c1.Id;
                c.Origin='Email';
                c.Status='Open';
                c.Type='AOG';
                insert c;
                
           // List<Case> clist=new List<Case> (select Id, Status, CSM__c, CreatedDate from Case where Status != \'Closed\' and Type=\'AOG\' and Case_Record_Type__c=\'CSM Toolbox\' and CreatedDate < today);
            //    clist.CSM_Email_Status__c='Inqueue';
              //  try
               // {
             //   update c;
            //    }
                CSMJobScheduler cj = new CSMJobScheduler();
                Test.startTest();
            DateTime tstDateTime = System.now();
             CSM_Scheduler CSMSchedule = new CSM_Scheduler();
            String Shdlr=' 0 00 10 * * ?';  
            System.schedule('Test CSMSchedule  Scheduling',Shdlr,CSMSchedule);
     //   CSM_EmailStatusFieldUpdate job = new CSM_EmailStatusFieldUpdate();
     //  job.query = 'Select Id,CSM_Email_Status__c From case where Case_Record_Type__c=\'CSM Toolbox\' Limit 1';
     //  Database.executeBatch(job, 1);
        Test.stoptest(); 
        }
        }