@isTest
public class test_CSMCaseCreation
  {
  public static testmethod void test_csmfeedback()
      {
    
      TriggerInactive.testTrigger = false;
       Account acc = new Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',CBT__c = 'HTSI');
       insert acc;
       Feedback__c f1=new Feedback__c();
       RecordType r1 = [select id , name from RecordType where name='NPS'];
       f1.RecordTypeId=r1.Id;
       f1.NPS_Classification__c='Passive';
       f1.Account__c= acc.Id;
       insert f1;
       f1.NPS_Classification__c='Detractor';
       update f1;
   Contact con=new Contact(FirstName='CSM',LastName='testcontact', AccountId=acc.Id, SBU_Contact__c='ALT',Primary_Email_Address__c='abc@xxx.com',Phone_3__c='12345');   
   insert con; 
   
   Test.startTest();
   {
   
   Case c=new Case();
   RecordType c1 = [select id , name from RecordType where name='CSM Toolbox'];
                c.RecordTypeId=c1.Id;
                c.Origin='Email';
                c.Status='Open';
                c.Description='test case';
                c.type='Net Promoter Score';
                c.ContactId=con.Id;
                insert c;
                
                Task t=new Task();
                t.Priority='Normal';
                t.Status='Not Started';
                t.Subject='test task';
                t.whatid=c.Id;
                insert t;
                c.Status='Closed';
                try
                {
                update c;
                }
                catch(System.DMLException e){//System.assert(e.getMessage().contains(
                //'This case cannot be closed because it has open activities.'),
                //  e.getMessage());
      }
                }
                Test.stopTest();
      }
  }