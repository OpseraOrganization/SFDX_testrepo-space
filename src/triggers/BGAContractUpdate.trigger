trigger BGAContractUpdate on Fleet_Asset_Aggregate__c (after insert,after update) {
    List<Account> acclist = new List<Account>();
    map<id,List<string>> plname = new map<id,list<string>>();
    List<Fleet_Asset_Aggregate__c > faa= new List<Fleet_Asset_Aggregate__c >();
    Account[] acclist1 = new Account[]{};
    set<id> accid = new set<id>();
    for(Fleet_Asset_Aggregate__c fl:trigger.new){
        accid.add(fl.Account_Name__c);
    }
    if(accid.size()>0){
        acclist = [SELECT id, name, BGA_Contract__c from Account where id IN:accid];
    }
    if(accid.size()>0){
        faa= [SELECT id,Platform_Name__r.Name,BGA_Contract__c,Account_Name__c from Fleet_Asset_Aggregate__c where BGA_Contract__c = true and Account_Name__c IN:accid];
    }
    if(faa.size()>0)
    {
        for(Fleet_Asset_Aggregate__c fl:faa)
        {
            list<string> temp=new list<string>();
            if(plname.containsKey(fl.Account_Name__c))
            temp=(plname.get(fl.Account_Name__c));
            temp.add(fl.Platform_Name__r.Name);
            plname.put(fl.Account_Name__c,temp);
        }
    }
    if(acclist.size()>0){
        for(Account acc:acclist){
            acc.BGA_Contract__c='';
            if(plname.containsKey(acc.id)){
                acc.BGA_Contract__c+= plname.get(acc.id);
                String test = acc.BGA_Contract__c;
                string test2 = test.substring(1,test.length()-1);
                acc.BGA_Contract__c = test2;
            }
            acclist1.add(acc);      
        }
    }
    if(acclist1.size()>0)
        update acclist1;
}