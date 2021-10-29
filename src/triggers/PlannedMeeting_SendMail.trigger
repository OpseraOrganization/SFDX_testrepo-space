/** * File Name: PlannedMeeting_SendMail
* Description Trigger to call the apex class to send email to the event coordinators when the status of the Planned Meeting is Approved
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger PlannedMeeting_SendMail on Planned_Meeting__c (after update) {

//variable declaration
List<Planned_Meeting__c> pmlst = Trigger.new;
List<Planned_Meeting__c> pmlist = new List<Planned_MEeting__c>();
List<id> eveidlst = new List<ID>();

for(integer i=0;i<pmlst.size();i++)
{
//Condition check that email should be send only when Planned Meeting status is Approved and Send Email Notification is true
if((Trigger.old[i].Meeting_Status__C != 'Approved' && pmlst[i].Meeting_Status__c == 'Approved' && pmlst[i].Event__c != null && pmlst[i].Send_Email_Notification__c == True) ||(pmlst[i].Send_Email_Notification__c == True && Trigger.old[i].Send_Email_Notification__c != true && pmlst[i].Meeting_Status__c == 'Approved' ) )
{
pmlist.add(pmlst[i]);
eveidlst.add(pmlst[i].Event__c);
}
}
//Calling the apex class to send email
PlannedMeeting_SendMassMails.sendemail(pmlist,eveidlst);
}