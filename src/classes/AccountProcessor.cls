public class AccountProcessor {
       
    public static void countContacts(Set<id> accountIds){    
   
        //List<Contacts> contactList = [Select id,Name from Contacts Where Accountid IN :accountIds];
        List<Account> accountList = [Select id ,Name ,Number_of_Contacts__c ,Text_Field__c,AccountNumber,(Select id from Contacts) from Account Where id IN :accountIds];
        for (Account updAccount : accountList ){
            
            List<Contact> conlt = updAccount.Contacts;
            updAccount.Number_of_Contacts__c = conlt.Size();
            updAccount.Text_Field__c = updAccount.AccountNumber ;
            
        }
        if(!accountList.isEmpty())
        system.debug('Print Account List'+accountList);    
        update accountList ;
        
    
    
    }


}