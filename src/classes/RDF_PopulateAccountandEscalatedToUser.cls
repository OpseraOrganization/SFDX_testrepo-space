/*********************************************
    Class Name       : RDF_PopulateAccountandEscalatedToUser
    Test Class       : RDF_EscalatedToInsert_Test
    Created On       : 27th July 2018
    Project          : RDF - One - Off Discount process
    Created By       : Suryanarayana Tvvsn
    Purpose          : This class is used to update the External Community User into Escalated To User field based on Escalted to Contact and to populate the Account name based on opportunity.
*********************************************/


public class RDF_PopulateAccountandEscalatedToUser{

   public static void populateAcctandEscalatedToUsr(List<Case> newCase){
        
        List<case> case2Update = new List<case>();
        Set<Id> ids = new Set<Id> ();
        Set<Id> oppids = new Set<Id> ();
        set<Id> caseid = new set<Id>();
        Map<Id, Id> mapContactToUser = new Map<Id, Id>();
        for(Case c: newCase){
           ids.add(c.VN_Name__c);
           oppids.add(c.Opportunity__c);
        }
        
        system.debug('::::::Contact ids:::'+ids);
        //List<User> usrlst = [select id,ContactId,Profile.name from user where ContactId IN: ids AND Profile.name = 'One off Community Profile'];
        
        List<User> usrlst = [select id,ContactId,Profile.name from user where ContactId IN: ids AND Profile.name =: system.label.RDF_OneOffCommunityProfileName];
        Map<id,opportunity> OppMap = new  Map<id,opportunity>([select id,name,Accountid from opportunity where id IN: oppids]);
        
        for(User u : usrlst){
            mapContactToUser.put(u.ContactId, u.Id);
        }
        
        system.debug('::::mapContactToUser:::::'+mapContactToUser);
        for(Case eachCase : newCase){
            
            if(eachCase.Opportunity__c != null && OppMap.containsKey(eachCase.Opportunity__c)){
                eachCase.Accountid = OppMap.get(eachCase.Opportunity__c).Accountid;
                system.debug('::::OppMap.get(eachCase.Opportunity__c).Accountid:::::'+OppMap.get(eachCase.Opportunity__c).Accountid);
            }
            system.debug('::::eachCase.Accountid:::::'+eachCase.Accountid);
            
            if(eachCase.VN_Name__c != null && mapContactToUser.containsKey(eachCase.VN_Name__c)){
                eachCase.User_VN_Name__c = mapContactToUser.get(eachCase.VN_Name__c);
                //eachCase.Subject ='updated via trigger';
            }
            system.debug('::::eachCase.User_VN_Name__c:::::'+mapContactToUser.get(eachCase.VN_Name__c));
            
        }
     }
}