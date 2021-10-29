/** * File Name: Approver_Owner
* Description : To populate the approver as owner
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Approver_Owner on Approver__c (before insert) 
{
List<Id> usr= new List<Id>();
List<user> usrList= new List<user>();
 for(Approver__c app : trigger.new )
  {
   if(app.Approver_Name__c!= null)
    {    
    usr.add(app.Approver_Name__c);
     app.ownerid = app.Approver_Name__c;
    }
  }
  //To copy the name field
  usrList=[Select Id,Name from user where id in:usr];
   for(Approver__c app1 : trigger.new )
  {
   for(integer i=0;i<usrList.size();i++){
     if(app1.Approver_Name__c==usrList[i].Id){
     app1.name=usrList[i].Name;

     }
        }
  }
   
}