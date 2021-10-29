public class ContractExtension_InitialLoad implements Queueable  {
    
    public static void execute(QueueableContext a)
    {
       
        for (List<Contract> cons: [SELECT id,Name,IsSubmitForApproval__c From Contract Where 
                                   RecordTypeId ='01230000000azJc' 
                                   AND IsSubmitForApproval__c=false limit 1000]) 
        {
            for(Contract c : cons) {
                c.IsSubmitForApproval__c =true;
            }
            Database.update(cons);
        }
        List<Contract> conList =[SELECT id,Name,IsSubmitForApproval__c From Contract Where 
                                   RecordTypeId ='01230000000azJc' 
                                   AND IsSubmitForApproval__c=false limit 1000];
        if(!conList.isEmpty())
        {
        if(!test.IsrunningTest()){
            System.enqueueJob(new ContractExtension_InitialLoad());
            }
        }
    }
}