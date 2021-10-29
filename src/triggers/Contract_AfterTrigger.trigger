/** * File Name: Contract_AfterTrigger
* Description :To send mail to Account Team members when Contract going to expire
* */ 
trigger  Contract_AfterTrigger on Contract (after update) {
    Account accounts;
    integer flag=0;
    String userName;
    List<Contract> contlist = new List<Contract>();
    List<Account> accountUpdate90=new List<Account>();
    List<Account> accountUpdate180=new List<Account>();
    List<Id> accountUpdateId90=new List<Id>();
    List<Id> accountUpdateId180=new List<Id>();
    /*** Added for MSP Contract Renewal start *****/
    list<Attachment> lstatt = new list<Attachment>();
    List<Contract> conlist = new List<Contract>();
    List<Attachment> conAttach = new list<Attachment>();
    Map<Id,List<Attachment>> conAttachMap = new Map<Id,List<Attachment>>();
    List<Case> cas=new List<Case>();
    List<Case> caslist=new List<Case>();
    Map<Id,case> casMap = new Map<Id,case>();
    /*** Added for MSP Contract Renewal ends*****/       
    
    userName=Userinfo.getUserName();
    if(userName!='SFDC Admin'){    
        
        // getting the related data
        for(Contract contracts: Trigger.New){ 
            
            
            if(Trigger.isUpdate && (System.Trigger.OldMap.get(contracts.Id).Contract_3_months_Expiry__C != System.Trigger.NewMap.get(contracts.Id).Contract_3_months_Expiry__C  && contracts.Contract_3_months_Expiry__C==true  )){
                if(Contracts.AccountId !=null)
                    accountUpdateId90.add(contracts.AccountId);
            }
            
            if(Trigger.isUpdate && (System.Trigger.OldMap.get(contracts.Id).Contract_6_months_Expiry__C != System.Trigger.NewMap.get(contracts.Id).Contract_6_months_Expiry__C  && contracts.Contract_6_months_Expiry__C==true  )){
                if(Contracts.AccountId !=null)
                    accountUpdateId180.add(contracts.AccountId);
            }
        }//end of for  
        
        
        //getting SR insert account data
        if(accountUpdateId90.size()>0){
            accountUpdate90=[Select Id, Contract_3_months_Expiry__c,contract__C
                             from Account where id in:accountUpdateId90];   
            for(Contract contracts90: Trigger.New){ 
                if(Trigger.isUpdate && (System.Trigger.OldMap.get(contracts90.Id).Contract_3_months_Expiry__C != System.Trigger.NewMap.get(contracts90.Id).Contract_3_months_Expiry__C  && contracts90.Contract_3_months_Expiry__C==true  )){
                    for(integer i=0;i<accountUpdate90.size();i++){
                        if(contracts90.accountId==accountUpdate90[i].Id ){
                            accountUpdate90[i].Contract_3_months_Expiry__c=true;
                            accountUpdate90[i].contract__c=contracts90.Id;      
                        }
                    }
                }    
            }
        } 
        //getting SR upadate account data
        if(accountUpdateId180.size()>0){
            accountUpdate180=[Select Id, Contract_3_months_Expiry__c,contract__c
                              from Account where id in:accountUpdateId180];
            for(Contract contracts180: Trigger.New){ 
                if(Trigger.isUpdate && (System.Trigger.OldMap.get(contracts180.Id).Contract_6_months_Expiry__C != System.Trigger.NewMap.get(contracts180.Id).Contract_6_months_Expiry__C  && contracts180.Contract_6_months_Expiry__C==true  )){
                    for(integer i=0;i<accountUpdate180.size();i++){
                        if(contracts180.accountId==accountUpdate180[i].Id ){
                            accountUpdate180[i].Contract_6_months_Expiry__c=true;
                            accountUpdate180[i].contract__c=contracts180.Id;      
                        }
                    }
                    
                }
            }
        }
        
        
        // update accnts for 3 months expiry
        if(accountUpdate90.size()>0)
            update accountUpdate90;
        
        
        
        // update accnts for 6 months expiry
        if(accountUpdate180.size()>0)
            update accountUpdate180;
    }//end of if   
    
}// end of trigger