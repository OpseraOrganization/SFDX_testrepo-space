trigger HWTrng_Federation_ID on User (before insert,before update) {
/* commenting trigger code for coverage
List <User>userlst = Trigger.new;
for(integer i=0;i<userlst.size();i++)
{
if(Trigger.Isinsert)
{
if(Trigger.new[i].PROFILEID != label.Custom_Customer_Portal){
System.debug('&&&&&&&&contactid'+Trigger.new[i].contactid);

if(Trigger.new[i].contactid != Null &&Trigger.new[i].Federation_Formula__c == Null)
{
Trigger.new[i].addError('Please enter Honeywell Id in Contact Record');
}

if(Trigger.new[i].contactid != Null && Trigger.new[i].FederationIdentifier==Null)
{

System.debug('&&&&&&&&Federation_Formula__c'+Trigger.new[i].Federation_Formula__c);
Trigger.new[i].FederationIdentifier = Trigger.new[i].Federation_Formula__c;
}
}
}


if(Trigger.Isupdate)
{
if(Trigger.new[i].contactid != Null &&Trigger.new[i].Federation_Formula__c == Null)
{
Trigger.new[i].addError('Please enter Honeywell Id in Contact Record');
}

if(Trigger.new[i].contactid != Null && (Trigger.new[i].FederationIdentifier==Null || Trigger.old[i].Federation_Formula__c != Trigger.new[i].Federation_Formula__c))
{
System.debug('&&&&&&&&updateloop Federation_Formula__c'+Trigger.new[i].Federation_Formula__c);
Trigger.new[i].FederationIdentifier = Trigger.new[i].Federation_Formula__c;
}
}*/


/*
if(Trigger.new[i].contactid != Null &&Trigger.new[i].Federation_Formula__c == Null)
{
Trigger.new[i].addError('Please enter Honeywell Id in Contact Record');
}
*/
//}
}