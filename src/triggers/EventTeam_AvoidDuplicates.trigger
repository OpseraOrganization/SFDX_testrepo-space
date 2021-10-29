/** * File Name: EventTeam_AvoidDuplicates
* Description Trigger to avoid duplicates for the Event Team Members
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
* 19/8/2010 - Modified query to limit the number of rows fetched so that list will have to hold only 1000 rows at a time
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger EventTeam_AvoidDuplicates on Event_Team__c (before insert,before update)
{
//Variable Declaration
Map<String, Event_Team__c> campMap = new Map<String,Event_Team__c>(); 
Map<String, id> campMap1 = new Map<String,id>(); 

for (Event_Team__c ct : System.Trigger.New) {
//Checking for User duplicate in the list of users to be loaded
if ((ct.User__c !=null) && (System.Trigger.isInsert || (ct.User__c != System.Trigger.oldMap.get(ct.Id).User__c))) 
{
if(ct.Event__c == campMap1.get(ct.User__c))
{
ct.User__c.addError('This User is already an Event Team Member');
} 
else 
{
campMap.put(ct.User__c, ct);
campMap1.put(ct.User__c, ct.Event__c);
}
}
//Checking for Contact duplicate in the list of Contacts to be loaded
if ((ct.Contact__c !=null) && (System.Trigger.isInsert || (ct.Contact__c != System.Trigger.oldMap.get(ct.Id).Contact__c))) 
{
if(ct.Event__c == campMap1.get(ct.contact__c))
{
ct.Contact__c.addError('This Contact is already an Event Team Member');
} 
else
{
campMap.put(ct.Contact__c, ct);
campMap1.put(ct.Contact__c, ct.Event__c);
}
}
}

//Checking for User duplicate from the database
for (Event_Team__c ct : [SELECT User__c,Event__c FROM Event_Team__c WHERE User__c IN :campMap.KeySet() limit 1000])
{
if(ct.Event__c == campmap1.get(ct.User__c))
{
Event_Team__c newct=campMap.get(ct.User__c);
newct.User__c.addError('This User is already an Event Team Member');
}
}

//Checking for Contact duplicate from the database
for (Event_Team__c ct : [SELECT Contact__c,Event__c FROM Event_Team__c WHERE Contact__c IN :campMap.KeySet() limit 1000])
{
if(ct.Event__c == campmap1.get(ct.Contact__c))
{
Event_Team__c newct=campMap.get(ct.Contact__c);
newct.Contact__c.addError('This Contact is already an Event Team Member');
}
}
}