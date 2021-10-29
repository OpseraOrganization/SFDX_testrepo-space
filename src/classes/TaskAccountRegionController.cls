public class TaskAccountRegionController {
public Task Task { get; private set; }
private final Account account;
    public TaskAccountRegionController(ApexPages.StandardController controller) {
    Id id = ApexPages.currentPage().getParameters().get('id');
      Task  task = (id == null) ? new task() : 
            [SELECT Whatid FROM task WHERE Id = :id];
            try {
         String par=task.Whatid;
                    if(par !=null)
                    par=par.substring(0,3);
                    if(par=='001')
                    account  = [select id,Region_Name__c from account where id =:task.whatid];        
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
           
        }
    }
     
    public Account getAccount() {
        return account;
    }
}