trigger Account_Deniedpartyindicator on Account_Address__c (after update) {
set<Id> accid= New Set<Id>();
set<Id> accidnotdenied= New Set<Id>();
set<Id> havealert= New Set<Id>();
set<Id> bluealert= New Set<Id>();
set<Id> orangealert= New Set<Id>();
list<Account> updateremove= New List<Account>();
list<Account> updateacc= New List<Account>();
List<Account> acc =New list<Account>();
list<Contact> updatecon= New List<contact>();
list<Contact> removeconalert= New List<contact>();
List<Account_Address__C> accadd1 = new List<Account_Address__C>();
    for(Account_Address__c accadd:Trigger.new){
        if(Trigger.newMap.get(accadd.id).Denied_Party_Status__c!=Trigger.oldMap.get(accadd.id).Denied_Party_Status__c){
            if(accadd.Denied_Party_Status__c=='Blocked'){
                accid.add(accadd.Account_Name__c);
            }
            else if(accadd.Denied_Party_Status__c!='Blocked'){
                accidnotdenied.add(accadd.Account_Name__c);
            }
        }
    }
    if(accid.size()>0)
        acc=[select id,Denied_Party_Alert__c from Account where id in: accid];

    for(Account a:acc){
        a.Denied_Party_Alert__c='Potential Denied Party Match Red';
        updateacc.add(a);
    }
//Below logic is for remove the alert message if none of the Account Address is having Denied status
    if(accidnotdenied.size()>0)
        accadd1=[select id,Denied_Party_Status__c,Account_Name__c from Account_Address__c where Account_Name__c in: accidnotdenied order by Denied_Party_Status__c asc];
       
    for(Account_Address__c ac :accadd1){
        if(ac.Denied_Party_Status__c=='Blocked')
            havealert.add(ac.Account_Name__c);
        if(ac.Denied_Party_Status__c=='Pending Block'||ac.Denied_Party_Status__c=='Further Review Needed')
            bluealert.add(ac.Account_Name__c);
        if(ac.Denied_Party_Status__c=='Conditional Release')
            orangealert.add(ac.Account_Name__c);
    }
    for(id d :accidnotdenied){
        if(!(havealert.contains(d))){
            if(!(orangealert.contains(d)) ){
                if(!(bluealert.contains(d))){
                    Account removealert = new account(id=d);
                    removealert.Denied_Party_Alert__c='NA';
                    updateacc.add(removealert);
                }
                  else if((bluealert.contains(d))){
                Account bluecoloralert = new account(id=d);
                bluecoloralert.Denied_Party_Alert__c='Potential Denied Party Match Blue';
                updateacc.add(bluecoloralert);
               
                }
            }
           else if((orangealert.contains(d))){
                    Account orangecoloralert = new account(id=d);
                    orangecoloralert.Denied_Party_Alert__c='Potential Denied Party Match Orange';
                    updateacc.add(orangecoloralert);
            }
        }
    }
    try{
        if(updateacc.size()>0)
        update updateacc;
    }catch(Exception e){}
}