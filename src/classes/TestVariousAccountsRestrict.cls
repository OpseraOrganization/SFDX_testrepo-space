@isTest
private class TestVariousAccountsRestrict{
static testMethod void VariousAccountsRestrictTst(){
  Account ac=new Account();
  ac.name='Vars account test';
  insert ac;
  
  Task t1=new Task();
  t1.Priority='Not Started';
  t1.whatId=ac.Id;
  insert t1;
  
  Event e=new Event();
  e.subject='Call';
  e.whatId=ac.Id;
  e.DurationInMinutes=30;
  e.ActivityDateTime=Date.today();
  insert e;
}
}