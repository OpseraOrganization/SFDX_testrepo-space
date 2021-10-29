public with sharing class ContactToolAccessTriggerHelperClass {
     
    //After Delete
    @future
    public static void AfterDelete(set<Id> contactIdSet){
        Set<Id> contactIdUserDeactivateSet = new Set<Id>();
        system.debug('contactIdSet'+contactIdSet);
        List<contact> contacToolList1 = [select id,Name,(SELECT Id,Name,Portal_Honeywell_ID__c,Portal_Tool_Master__c,Portal_Tool_Master__r.Name,Request_Date__c,Request_Status__c,last_logged_in__c 
                                                         from Contact_Tool_Access__r where name IN('Honeywell Training','Technical Knowledge Center') ) from contact  
                                         where id IN :contactIdSet];
        
        for(Contact con : contacToolList1)
        {
            if(con.Contact_Tool_Access__r.isEmpty()){
                contactIdUserDeactivateSet.add(con.Id);
            }
        }
        
        List<User> userToDeactivate = [SELECT ID,IsActive, ContactId, Contact.Firstname, Contact.Lastname, ProfileId, Profile.Name FROM User WHERE ContactID IN :contactIdUserDeactivateSet];
        for(User user : userToDeactivate){
            user.isActive = false;
        }
        Update userToDeactivate;      
    }
    
    
    
    //After Update
    @future
    public static void AfterUpdate(set<Id> contactIdSet){
        Set<Id> contactIdUserDeactivateSet = new Set<Id>();
        system.debug('contactIdSet'+contactIdSet);
        List<contact> contacToolList1 = [select id,Name,(SELECT Id,Name,Portal_Honeywell_ID__c,Portal_Tool_Master__c,Portal_Tool_Master__r.Name,Request_Date__c,Request_Status__c,last_logged_in__c 
                                                         from Contact_Tool_Access__r where name IN('Honeywell Training','Technical Knowledge Center') and Request_Status__c!='Approved') from contact  
                                         where id IN :contactIdSet];
        
        system.debug('contacToolList1'+contacToolList1);
        for(Contact con : contacToolList1)
        {
           // if(!con.Contact_Tool_Access__r.isEmpty()){
                contactIdUserDeactivateSet.add(con.Id);
           // }
        }
        system.debug('contactIdUserDeactivateSet'+contactIdUserDeactivateSet);
        List<User> userToDeactivate = [SELECT ID,IsActive, ContactId, Contact.Firstname, Contact.Lastname, ProfileId, Profile.Name FROM User WHERE ContactID IN :contactIdUserDeactivateSet];
       system.debug('userToDeactivate'+userToDeactivate);
 for(User user : userToDeactivate){
            user.isActive = false;
        }
        Update userToDeactivate;      
    }
}