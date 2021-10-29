global class CSM_Scheduler implements Schedulable{
      
    global  void execute(SchedulableContext sc){ 
            
    //    CSM_EmailStatusFieldUpdate  a = new CSM_EmailStatusFieldUpdate();
    //    datetime test = system.now().addHours(-24);
        
     //   a.query = 'select Id, Status, CSM_Email_Status__c, CreatedDate from Case where Status != \'Closed\' and Type=\'AOG\' and Case_Record_Type__c=\'CSM Toolbox\' and CreatedDate < today ';
     //   System.debug(a.query);
     //   Id BatchProcessId=Database.ExecuteBatch(a);
     list<Case> caselist = new list<Case>();
     list<Case> newcaselist = new list<Case>();
     caselist = [select Id, Status, CSM_Email_Status__c, CreatedDate from Case where Status != 'Closed' and Type='AOG' and Case_Record_Type__c='CSM Toolbox' and CreatedDate < today];
     System.debug('debugggging...'+caselist.size());
     System.debug('debugggging...'+caselist);
     for(Case c: caselist){
         if(c.CSM_Email_Status__c != 'Inqueue')
        {
            c.CSM_Email_Status__c = 'Inqueue';
            newcaselist.add(c); 
         }   
        }
        if(newcaselist.size()>0)
    Update newcaselist;
   
    }
}