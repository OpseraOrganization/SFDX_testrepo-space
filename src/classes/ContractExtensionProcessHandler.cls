public class ContractExtensionProcessHandler {

   /******** Contract Extension Process *****/
    public static void updateBusinessFocalEmail(Set<Id> acctidSet)
    {
        List<Account> listAcc = [Select id,Name ,Business_Focal__c,Business_Focal__r.Primary_Email_Address__c From Account Where Id In:acctidSet];
        Map<ID,Account> CEPacctIdMap = New Map<Id,Account>();
        //for(Account acct : [Select id,Name ,Business_Focal__c,Business_Focal__r.Primary_Email_Address__c From Account Where Id In:acctidSet])
        for(Account acct : listAcc)
        {
            CEPacctIdMap.put(acct.Id, acct);
        }
        List<Contract> contractList = new List<Contract>();
        List<Contract> listCont=[Select id,Business_Focal_Email__c,AccountId From Contract Where AccountId In : CEPacctIdMap.keySet() AND RecordType.Name='Contracts'];
        //for(Contract con :[Select id,Business_Focal_Email__c,AccountId From Contract Where AccountId In : CEPacctIdMap.keySet() AND RecordType.Name='Contracts'])
        for(Contract con :listCont)
        {
            con.Business_Focal_Email__c =CEPacctIdMap.get(con.AccountId).Business_Focal__r.Primary_Email_Address__c;
            contractList.add(con);   
        }
        if(!contractList.isEmpty())
        {
            update contractList;
        }
    }
    
    public static void updatemail(List<Contract> contractList,Set<ID> acctidSet)
    {
        
        Map<ID,String> CEPacctIdMap = New Map<Id,String>();
       
        Map<ID,Id> accountContactMap = new Map<ID,Id>();
        System.debug('@@@@con acctidSet'+acctidSet);
        System.debug('@@@@con contractList'+contractList);
        List<Account> listAcct=[Select id,Name ,Business_Focal__c,Business_Focal__r.Email,Type From Account Where Id In:acctidSet AND Business_Focal__c !=Null];
        //for(Account acct : [Select id,Name ,Business_Focal__c,Business_Focal__r.Email From Account Where Id In:acctidSet AND Business_Focal__c !=Null])
        for(Account acct : listAcct)
        {            
            accountContactMap.put(acct.Business_Focal__c,acct.Id);
           
        }
        List<Contact> listCont=[Select id,Name,Email,AccountId From Contact Where Id In:accountContactMap.keySet()];
        //for(Contact con : [Select id,Name,Email,AccountId From Contact Where Id In:accountContactMap.keySet() ])
        for(Contact con : listCont)
        {
            System.debug('@@@@Emnail'+con.Email);
            CEPacctIdMap.put(accountContactMap.get(con.Id), con.Email);
        }
        System.debug('@@@@CEPacctIdMap'+CEPacctIdMap);
        //   List<Contract> contractList = new List<Contract>();
        for(Contract con :contractList)
        {
            System.debug('@@@@con'+con.AccountId);
            con.Business_Focal_Email__c =CEPacctIdMap.get(con.AccountId);
                     
        }              
    }
    public static void updatGroupEmail(List<Contract> contractList,Map<Id,Contract> oldMap)
    {
      List<Contract> conList = new List<Contract>();
       Set<String> acctidSet = New Set<String>();
       Set<String> acctConSet= New Set<String>();
       for(Contract con : contractList)
       {
           if(oldMap.get(con.Id).IsContractExtProcessTriggered__c != con.IsContractExtProcessTriggered__c)
           {
               conList.add(con);
               acctidSet.add(con.AccountId);
           }
       }
        List<Account> listAcct=[Select id,Name ,Business_Focal__c,Business_Focal__r.Email,Type From Account Where Id In:acctidSet];
       
         for(Account acct : listAcct)
        {                     
            if((acct.type).contains('airline'))
            {
                acctConSet.add(acct.id);
            }
        }
        for(Contract con :contractList)
        {
            System.debug('@@@@con'+con.AccountId);         
            if(acctConSet.contains(con.AccountId))
            {
                con.ContExt_Group_Email__c ='CommercialCACOE@Honeywell.com';
            }
            else
            {
                 con.ContExt_Group_Email__c ='DefenseCACOE@Honeywell.com';
            }
            
            System.debug('@@@@con'+con);
        }  
    }
    
}