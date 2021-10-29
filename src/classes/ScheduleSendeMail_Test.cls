@isTest
 Public class ScheduleSendeMail_Test
 
 {
 static testMethod void  testmethod_one()
   {
      Test.startTest();
      ScheduleSendeMailToADVNCustomersBatch obj= new ScheduleSendeMailToADVNCustomersBatch();
       String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, obj);
      Test.stopTest();
      
   }
   
   }