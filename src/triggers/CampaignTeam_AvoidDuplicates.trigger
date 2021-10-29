/** * File Name: CampaignTeam_AvoidDuplicates
* Description Trigger to avoid duplicates for the Campaign Team Members 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
* 19/8/2010 - Modified query to limit the number of rows fetched so that list will have to hold only 1000 rows at a time
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger CampaignTeam_AvoidDuplicates on Campaign_Team__c (before insert,before update)
{
//Variable Declaration
Map<String, Campaign_Team__c> campMap = new Map<String,Campaign_Team__c>(); 
Map<String, id> campMap1 = new Map<String,id>(); 

for (Campaign_Team__c ct : System.Trigger.New) {

//Checking for User duplicate in the list of users to be loaded
if ((ct.Team_User__c !=null) && (System.Trigger.isInsert || (ct.Team_User__c != System.Trigger.oldMap.get(ct.Id).Team_User__c))) 
{
if(ct.campaign__c == campMap1.get(ct.Team_User__c)){
ct.Team_User__c.addError('This User is already a Campaign Team Member');
} else {
campMap.put(ct.Team_User__c, ct);
campMap1.put(ct.Team_User__c, ct.campaign__c);
}
}

//Checking for Contact duplicate in the list of Contacts to be loaded
if ((ct.Contact__c !=null) && (System.Trigger.isInsert || (ct.Contact__c != System.Trigger.oldMap.get(ct.Id).Contact__c))) 
{
if(ct.campaign__c == campMap1.get(ct.contact__c)){
ct.Contact__c.addError('This Contact is already a Campaign Team Member');
} else {
campMap.put(ct.Contact__c, ct);
campMap1.put(ct.Contact__c, ct.campaign__c);
}
}
}


//Checking for User duplicate from the database
for (Campaign_Team__c ct : [SELECT Team_User__c,Campaign__c FROM Campaign_Team__c WHERE Team_User__c IN :campMap.KeySet() limit 1000]) 
{
if(ct.campaign__c == campmap1.get(ct.Team_User__c))
{
Campaign_Team__c newct=campMap.get(ct.Team_User__c);
newct.Team_User__c.addError('This User is already a Campaign Team Member');
}
}

//Checking for Contact duplicate from the database
for (Campaign_Team__c ct : [SELECT Contact__c,Campaign__c FROM Campaign_Team__c WHERE Contact__c IN :campMap.KeySet() limit 1000]) 
{
if(ct.campaign__c == campmap1.get(ct.Contact__c))
{
Campaign_Team__c newct=campMap.get(ct.Contact__c);
newct.Contact__c.addError('This Contact is already a Campaign Team Member');
}
}
}