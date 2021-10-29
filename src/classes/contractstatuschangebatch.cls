global class contractstatuschangebatch implements Database.batchable<sObject>, Schedulable{
    global string query;
  
  global contractstatuschangebatch(){
     query = 'SELECT EndDate,Id,Name,Status,StartDate FROM Contract WHERE EndDate < today AND Status=\'Active\'';
  }
    
  global Database.QueryLocator start(Database.BatchableContext BC){
     
      return Database.getQueryLocator(query);
  }
    
  global void execute(Database.BatchableContext BC, List<Contract> scope){
     List<Contract> lstcont = new List<Contract>();
     
      for(Contract con:scope){
            con.Status = 'Inactive';
            lstcont.add(con);  
      }
        
      if(lstcont.size()>0){
            try{
            
                update lstcont;
               }
            catch(Exception ex){}
      }
    }
    
    global void finish(Database.BatchableContext BC){        
    
    } 
    
    global void execute(SchedulableContext sc){
        contractstatuschangebatch ContractBatch = new contractstatuschangebatch();
        database.executeBatch(ContractBatch,200);
    }
    
}