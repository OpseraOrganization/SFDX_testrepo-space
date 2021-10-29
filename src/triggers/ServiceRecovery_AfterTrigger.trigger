/** * File Name: ServiceRecovery_AfterTrigger
* Description :To send mail to Account Team members
* when any of Service Recovery Report created or updated
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger   ServiceRecovery_AfterTrigger on Service_Recovery_Report__c (after insert,after update) {
Account accounts;
integer flag=0;
String userName;
List<Account> accountInsert=new List<Account>();
List<Account> accountUpdate=new List<Account>();
List<Id> accountInsertId=new List<Id>();
List<Id> accountUpdateId=new List<Id>();
userName=Userinfo.getUserName();
 if(userName!='SFDC Admin'){    

// getting the related data
 for(Service_Recovery_Report__c servReport: Trigger.New){ 

     if(Trigger.IsInsert){
        if(servReport.Account_Name__c !=null)
        accountInsertId.add(servReport.Account_Name__c);
     }
     if(Trigger.isUpdate && (System.Trigger.OldMap.get(servReport.Id).Status__C != System.Trigger.NewMap.get(servReport.Id).Status__C)){
            if(servReport.Account_Name__c !=null)
            accountUpdateId.add(servReport.Account_Name__c);
     }
 }//end of for  
//getting SR insert account data
  if(accountInsertId.size()>0){
   accountInsert=[Select Id, SendMailTeamUpdate__c,SendMailTeam__C,SRR_Name__c,SRR_Link__C
   from Account where id in:accountInsertId];
   }
 //getting SR upadate account data
  if(accountUpdateId.size()>0){
   accountUpdate=[Select Id, SendMailTeamUpdate__c,SendMailTeam__C,SRR_Name__c,SRR_Link__C
   from Account where id in:accountUpdateId];
   }

// getting the related data
 for(Service_Recovery_Report__c servReports: Trigger.New){ 
  //for SRR insert
     if(Trigger.IsInsert){
        if(servReports.Account_Name__c !=null){
          for(integer i=0;i<accountInsert.size();i++){
            if(servReports.Account_Name__c ==accountInsert[i].Id){
                    accountInsert[i].SRR_Name__c=servReports.name;
                    accountInsert[i].SRR_Link__C=servReports.Id;
                    accountInsert[i].SendMailTeam__C=true;
            }
          }
        }  
     }
     //for SRR update
     if(Trigger.isUpdate && (System.Trigger.OldMap.get(servReports.Id).Status__C != System.Trigger.NewMap.get(servReports.Id).Status__C)){
       if(servReports.Account_Name__c !=null){
          for(integer i=0;i<accountUpdate.size();i++){
            if(servReports.Account_Name__c ==accountUpdate[i].Id){
                    accountUpdate[i].SRR_Name__c=servReports.name;
                    accountUpdate[i].SRR_Link__C=servReports.Id;
                    accountUpdate[i].SendMailTeamUpdate__c=true;
            }
          }
        }  
     }
 }//end of for  
// for SRR insert mail trigger
if(accountInsert.size()>0)
update accountInsert;
// for SRR update mail trigger
if(accountUpdate.size()>0)
update accountUpdate;

}//end of if   
}// end of trigger