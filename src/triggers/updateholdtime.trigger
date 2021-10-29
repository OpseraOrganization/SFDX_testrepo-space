trigger updateholdtime on Technical_Issue_Case_Extensions__c (before update) {
List<Technical_Issue_Case_Extensions__c> tcaslist= new List<Technical_Issue_Case_Extensions__c>();  
List<Technical_Issue_Case_Extensions__c> updatelist= new List<Technical_Issue_Case_Extensions__c>(); 
for (Technical_Issue_Case_Extensions__c tcasx :trigger.new)
{
 system.debug('inside for');
//if((tcasx.Customer_Feedback_Hold_Start_time__c!= null && (trigger.isupdate && tcasx.Customer_Feedback_Hold_Start_time__c!=trigger.oldmap.get(tcasx.id).Customer_Feedback_Hold_Start_time__c))||(tcasx.EPS_Engineering_Hold_Start_Time__c!= null && (trigger.isupdate && tcasx.EPS_Engineering_Hold_Start_Time__c!=trigger.oldmap.get(tcasx.id).EPS_Engineering_Hold_Start_Time__c))|| (tcasx.Honeywell_Internal_Hold_Start_time__c!= null && (trigger.isupdate && tcasx.Honeywell_Internal_Hold_Start_time__c!=trigger.oldmap.get(tcasx.id).Honeywell_Internal_Hold_Start_time__c)))
if((System.Trigger.NewMap.get(tcasx.Id).Customer_Feedback_Hold_Start_time__c!=System.Trigger.OldMap.get(tcasx.Id).Customer_Feedback_Hold_Start_time__c && System.Trigger.OldMap.get(tcasx.Id).Customer_Feedback_Hold_Start_time__c != null) || (System.Trigger.NewMap.get(tcasx.Id).EPS_Start_Hold_Time__c!=System.Trigger.OldMap.get(tcasx.Id).EPS_Start_Hold_Time__c&& System.Trigger.OldMap.get(tcasx.Id).EPS_Start_Hold_Time__c!= null) || (System.Trigger.NewMap.get(tcasx.Id).Engineering_Start_Hold_Time__c!=System.Trigger.OldMap.get(tcasx.Id).Engineering_Start_Hold_Time__c&& System.Trigger.OldMap.get(tcasx.Id).Engineering_Start_Hold_Time__c!= null) || (System.Trigger.NewMap.get(tcasx.Id).Honeywell_Internal_Hold_Start_time__c!=System.Trigger.OldMap.get(tcasx.Id).Honeywell_Internal_Hold_Start_time__c&& System.Trigger.OldMap.get(tcasx.Id).Honeywell_Internal_Hold_Start_time__c!= null))
{
tcaslist.add(tcasx);
system.debug('tcaslist Listtt'+tcaslist);
}
}
for (Technical_Issue_Case_Extensions__c casx :tcaslist)
{
system.debug('line 15 Tech Issue Extension');
//if(casx.Customer_Feedback_Hold_Start_time__c!= null && (trigger.isupdate && casx.Customer_Feedback_Hold_Start_time__c!=trigger.oldmap.get(casx.id).Customer_Feedback_Hold_Start_time__c))
if(System.Trigger.NewMap.get(casx.Id).Customer_Feedback_Hold_Start_time__c!=System.Trigger.OldMap.get(casx.Id).Customer_Feedback_Hold_Start_time__c)
{
//casx.Past_Customer_Feedback_in_Hours__c= (Decimal.valueof(System.Trigger.OldMap.get(casx.Id).Customer_Feedback_Hold_End_time__c.getTime() - System.Trigger.OldMap.get(casx.Id).Customer_Feedback_Hold_Start_time__c.getTime())/3600000) + casx.Past_Customer_Feedback_in_Hours__c ;
casx.Past_Customer_Feedback_in_Hours__c= System.Trigger.OldMap.get(casx.Id).Waiting_for_Customer_Feedback_in_Hours__c;
casx.Customer_Feedback_Hold_End_time__c=null;
}
//Code Added for SR INC000009852330 Starts
if(System.Trigger.NewMap.get(casx.Id).EPS_Start_Hold_Time__c!=System.Trigger.OldMap.get(casx.Id).EPS_Start_Hold_Time__c && System.Trigger.OldMap.get(casx.Id).EPS_End_Hold_Time__c != null)
{
//casx.Past_EPS_Engineering_in_Hours__c= (Decimal.valueof(System.Trigger.OldMap.get(casx.Id).EPS_Engineering_Hold_End_time__c.getTime() - System.Trigger.OldMap.get(casx.Id).EPS_Engineering_Hold_Start_Time__c.getTime())/3600000) + casx.Past_EPS_Engineering_in_Hours__c;
casx.Past_EPS_Engineering_in_Hours__c= System.Trigger.OldMap.get(casx.Id).Waiting_for_EPS_Engineering_in_Hours__c;
casx.EPS_End_Hold_Time__c=null;
}
if(System.Trigger.NewMap.get(casx.Id).Engineering_Start_Hold_Time__c!=System.Trigger.OldMap.get(casx.Id).Engineering_Start_Hold_Time__c && System.Trigger.OldMap.get(casx.Id).Engineering_End_Hold_Time__c != null)
{
//casx.Past_EPS_Engineering_in_Hours__c= (Decimal.valueof(System.Trigger.OldMap.get(casx.Id).EPS_Engineering_Hold_End_time__c.getTime() - System.Trigger.OldMap.get(casx.Id).EPS_Engineering_Hold_Start_Time__c.getTime())/3600000) + casx.Past_EPS_Engineering_in_Hours__c;
casx.Past_Engineering_in_Hours__c= System.Trigger.OldMap.get(casx.Id).Waiting_for_Engineering_in_Hours__c;
casx.Engineering_End_Hold_Time__c=null;
}
//Code Added for SR INC000009852330 Ends
if(System.Trigger.NewMap.get(casx.Id).Honeywell_Internal_Hold_Start_time__c!=System.Trigger.OldMap.get(casx.Id).Honeywell_Internal_Hold_Start_time__c && System.Trigger.OldMap.get(casx.Id).Honeywell_Internal_Hold_End_time__c != null) 
{
//casx.Past_Honeywell_Internal_in_Hours__c= (Decimal.valueof(System.Trigger.OldMap.get(casx.Id).Honeywell_Internal_Hold_End_time__c.getTime() - System.Trigger.OldMap.get(casx.Id).Honeywell_Internal_Hold_Start_time__c.getTime())/3600000) + casx.Past_Honeywell_Internal_in_Hours__c;
casx.Past_Honeywell_Internal_in_Hours__c= System.Trigger.OldMap.get(casx.Id).Honeywell_Internal_in_Hours__c;
casx.Honeywell_Internal_Hold_End_time__c=null;
}
updatelist.add(casx);
system.debug('Line 20 updatelist'+updatelist);
}
}