/** * File Name: PlannedMeetingAttendee_AvoidDuplicates
* Description Trigger to avoid duplicates for the Planned Meeting Attendees
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
* 19/8/2010 - Modified query to limit the number of rows fetched so that list will have to hold only 1000 rows at a time
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger PlannedMeetingAttendee_AvoidDuplicates on Planned_Meeting_Attendee__c (before insert,before update) {
Map<String, Planned_Meeting_Attendee__c> campMap = new Map<String,Planned_Meeting_Attendee__c>(); 
Map<String, Planned_Meeting_Attendee__c> campMap2 = new Map<String,Planned_Meeting_Attendee__c>(); 
Map<String, id> campMap1 = new Map<String,id>(); 
String s1;
String s2;

for (Planned_Meeting_Attendee__c ct : System.Trigger.New) {
//Checking for User duplicate in the list of users to be loaded
if ((ct.User__c !=null) && (System.Trigger.isInsert || (ct.User__c != System.Trigger.oldMap.get(ct.Id).User__c))) 
{
s1 = ct.User__c;
s2 =ct.Opportunity__c ;
if (campMap.containsKey(s1+s2)) {
ct.User__c.addError('This User is already a Planned Meeting Attendee');
} else {

campMap.put(s1+s2, ct);
campMap2.put(ct.User__c, ct);
campMap1.put(s1+s2, ct.Planned_Meeting__c);
}
}

//Checking for Contact duplicate in the list of Contacts to be loaded
if ((ct.Contact__c !=null) && (System.Trigger.isInsert || (ct.Contact__c != System.Trigger.oldMap.get(ct.Id).Contact__c))) 
{
s1 = ct.Contact__c;
s2 =ct.Opportunity__c ;
if (campMap.containsKey(s1+s2)) {
ct.Contact__c.addError('This Contact is already a Planned Meeting Attendee');
} else {
campMap.put(s1+s2, ct);
campMap2.put(ct.Contact__c, ct);
campMap1.put(s1+s2, ct.Planned_Meeting__c);
}
}
}


//Checking for User duplicate from the database
for (Planned_Meeting_Attendee__c ct : [SELECT User__c,Planned_Meeting__c,Opportunity__c FROM Planned_Meeting_Attendee__c WHERE User__c IN :campMap2.KeySet() limit 1000]) 
{
s1 = ct.User__c;
s2 =ct.Opportunity__c ;

//System.debug('campmap1.get(s1+s2).........'+campmap1.get(s1+s2));
if(ct.Planned_Meeting__c == campmap1.get(s1+s2) && campmap1.get(s1+s2)!=null)
{
Planned_Meeting_Attendee__c newct=campMap.get(s1+s2);
//System.debug('newct................'+newct);
if(newct.Flag__c!= true)
newct.User__c.addError('This User is already a Planned Meeting Attendee');
}
}

//Checking for Contact duplicate from the database
for (Planned_Meeting_Attendee__c ct : [SELECT Contact__c,Planned_Meeting__c,Opportunity__c FROM Planned_Meeting_Attendee__c WHERE Contact__c IN :campMap2.KeySet() limit 1000]) 
{
s1 = ct.Contact__c;
s2 =ct.Opportunity__c ;
if(ct.Planned_Meeting__c == campmap1.get(s1+s2) && campmap1.get(s1+s2)!=null)
{
Planned_Meeting_Attendee__c newct=campMap.get(s1+s2);
if(newct.Flag__c!= true)
newct.Contact__c.addError('This Contact is already a Planned Meeting Attendee');
}
}


}