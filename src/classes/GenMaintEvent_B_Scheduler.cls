global class GenMaintEvent_B_Scheduler implements Schedulable{
      
    global void execute(SchedulableContext sc){ 
            
        GenerateMaintEvent_Platform_B  a = new GenerateMaintEvent_Platform_B();
        
        a.query = 'SELECT Id From Platform__c Where (BCHK_NUM__c > 0 OR B_Event_Duration__c > 0) AND Avg_Flying_Hors_Per_Year__c > 0';    
        
        if(a.query!=null){
        System.debug(a.query);
        Id BatchProcessId=Database.ExecuteBatch(a,1);
        }
        
    }
}