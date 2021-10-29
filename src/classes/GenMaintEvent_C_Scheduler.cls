global class GenMaintEvent_C_Scheduler implements Schedulable{
      
    global void execute(SchedulableContext sc){ 
            
        GenerateMaintEvent_Platform_C  a = new GenerateMaintEvent_Platform_C();
        
        a.query = 'SELECT Id From Platform__c Where (CCHK_NUM__c > 0 OR C_Event_Duration__c > 0) AND Avg_Flying_Hors_Per_Year__c > 0 ';    
        System.debug('PLATFORMMMMMMM'+a.query);
        if(a.query!=null){
        System.debug(a.query);
        Id BatchProcessId=Database.ExecuteBatch(a,1);
        }
        
    }
}