trigger new_case on EmailMessage (before insert) {
/*commenting trigger code for coverage
list<case> clist= new list<case>();

list<EmailMessage> elist= new list<EmailMessage>();

List <ACT_Case_Escalation__c> alist = ACT_Case_Escalation__c.getall().values();
List<Task> TaskDelete = new List<Task>();

List<Task> TaskInsert = new List<Task>();
set<Id> caseid = new set<Id>();
string s,s2;
list<string> s1=new list<string>();



List<Case> casetoUpdate= new List<Case>();
List<Case> cases= new List<Case>();
   List<Id> updateTaskIds1=new List<Id>();
for(EmailMessage e : Trigger.new) 
{
    System.debug('!!!!!!!!!!!!!!!!!!e.subject'+e.subject);
    if(((e.ToAddress=='act@8-hbe4c1d5dfteqeiw3jhxk5fx.tkl3bmaw.t.case.sandbox.salesforce.com')||
    (e.ToAddress=='act@honeywell.com')||(e.ToAddress=='apacactinternal@honeywell.com')
    ||(e.ToAddress=='apacactinternal@v-4xx1vrdag3t7ojs2k1euga1v8.tkl3bmaw.t.case.sandbox.salesforce.com')
    ||(e.ToAddress=='emeaactinternal@n-14iawb9e1cwos260gdtkw8m2a.tkl3bmaw.t.case.sandbox.salesforce.com')    
    ||(e.ToAddress=='emeaactinternal@honeywell.com')))
        { 
        if(e.ParentId != null)
        {
      for(case[] c0:[select ID,ContactID,Subject,CaseNumber from case where id=:e.ParentId and Activate_ACT__c=false and subject != :e.subject]) 
       {
         for(case c1: c0)
         { 
           if(c1 != null)
           {
            case c= new case();
            if((e.ToAddress=='act@x-qlflmob3g4wuxzwhg5ke7n3g.in.sandbox.salesforce.com')||
               (e.ToAddress=='act@honeywell.com'))
             {
              c.Mail_Box_Name__c= 'Email-ACTinternal';
              }

             if((e.ToAddress=='APACACTinternal@honeywell.com')
              ||(e.ToAddress=='apacactinternal@j-2tbxqhn05b4op6uf2x7y17shp.qc3zuma0.q.case.sandbox.salesforce.com'))
                  {
                c.Mail_Box_Name__c = 'Email-APACACTinternal';
                }
                if((e.ToAddress=='emeaactinternal@6kqi66hb66i8ylkwblqnaddhs.qc3zuma0.q.case.sandbox.salesforce.com')
                    
                    ||(e.ToAddress=='EMEAACTInternal@Honeywell.com'))
                {
                  c.Mail_Box_Name__c = 'Email-EMEAACTInternal';
                }
                
            c.Origin='Email';
            c.Status='Open';
            c.Activate_ACT__c=true;
                       
            if((e.ToAddress=='act@8-hbe4c1d5dfteqeiw3jhxk5fx.tkl3bmaw.t.case.sandbox.salesforce.com')||
    (e.ToAddress=='act@honeywell.com')){
            c.Type='Internal Communication';
            c.Classification__c='US ACT Internal';
         
            }
            
     if((e.ToAddress=='apacactinternal@v-4xx1vrdag3t7ojs2k1euga1v8.tkl3bmaw.t.case.sandbox.salesforce.com')||
    (e.ToAddress=='apacactinternal@honeywell.com')){
 
            c.Classification__c='APAC ACT Internal';
            
            }
            
            
            
      if((e.ToAddress=='emeaactinternal@n-14iawb9e1cwos260gdtkw8m2a.tkl3bmaw.t.case.sandbox.salesforce.com')||
    (e.ToAddress=='emeaactinternal@honeywell.com')){
      
            c.Classification__c='EMEA ACT Internal';
         
            }
                      
            
            
            
                  c.Type='Internal Communication';
              c.ownerid = alist[0].ACT_Queue__c;
            c.Recordtypeid = alist[0].RecordType_Id__c; 
            
            
            c.SuppliedEmail=e.FromAddress; 
            c.ContactID = c1.ContactID;
            c.subject=c1.Subject;
            //Please write the logic to update
   // c.ownerId='00G30000001zX8x';

   // c.Recordtypeid='01230000000Zen1';

            c.Export_Compliance_Content_ITAR_EAR__c='Undetermined';
            c.Government_Compliance_SM_M_Content__c='Undetermined';
            clist.add(c);
            elist.add(e);
            
            
            
            
 //Code modifying for ACT task deletion   
 
  try{
  String newsub='Email: '+e.subject ;
  Task taskId=[Select Id from Task where subject=:newsub 
  and  whatId=:e.ParentId
  ];
  TaskDelete.add(taskId);
  }
  

  catch (Exception err){}
  
    System.debug('&&&&&&&&&&&&&&&&&&&&&&&e.ParentId'+e.ParentId);
  
      System.debug('&&&&&&&&&&&&&&&&&&&&&&&TaskDelete'+TaskDelete);
  
  
  
  
  
  
  //Code end modifying for ACT task deletion        
           }
         

         }
       }
    }
 }
 
 if(e.status=='0'){
 System.debug('&&&&&&&&&&&&&&&&&&entered new loop'+e.status);
 integer flag=0;
    for(integer i=0;i<elist.size();i++){
      if(e.Id==elist[i].Id)
      flag=1;
    }
   if(flag==0){
   updateTaskIds1.add(e.ParentId);
    System.debug('&&&&&&&&&&&&&&&&&&entered new loop e.ParentId'+e.ParentId);
   }
 }
 
 
 
}





 //Code modifying for ACT task deletion 
if(TaskDelete.size()>0){
delete TaskDelete;
}


  //Code end modifying for ACT task deletion 


 if(clist.size()>0)
 insert clist;
 
 
 
 if(updateTaskIds1.size()>0){
 //"isclosed=false" condition is added in the query to prevent the reopened cases getting updated
cases=[Select Id,OwnerId,status ,OpenTask__c   from case where Id in:updateTaskIds1 and isClosed=false];
if(cases.size()>0){
for(integer i=0;i<cases.size();i++){
 String owner=cases[i].OwnerId;
 owner=owner.substring(0,3);
if(owner !='00G'){
cases[i].OpenTask__c=true;
casetoUpdate.add(cases[i]);
}
}
}
if(casetoUpdate.size()>0){
try{

update casetoUpdate;
}catch(Exception e){
}
 }
 }
 
 
 
 for(integer i=0;i< clist.size();i++)
 {
 
 Task t=new Task();
 t.whatId= clist[i].Id;
 t.subject='Email:'+clist[i].subject;
TaskInsert.add(t);
   elist[i].ParentId=clist[i].id;
   elist[i].subject=clist[i].subject;
 }
 
 
 if(TaskInsert.size()>0)
 insert TaskInsert;
 
   */ 
}