/** * File Name: Opp_phases_ActualExpectedDates
* Description Trigger is for Opportunity gate to ensure that Expected Date and Actual Date of a Phase is greater than the previous Phase
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Opp_phases_ActualExpectedDates on Opportunity_Gate__c (before update) {

//Declaring variables
List<Opportunity_Gate__c> OppGate=Trigger.new;
List<Id> OppGateIds=new List<Id>();
List<Opportunity_Gate__c> phases =new List<Opportunity_Gate__c>();
Map<Id,Date> actualdates=new Map<Id,Date>();
Map<Id,Date> expecteddates=new Map<Id,Date>();
Map<String,Date> actualDateNew=new Map<String,Date>();
Map<String,Date> expectedDateNew=new Map<String,Date>();
Map<String,Decimal> actualSerialNew=new Map<String,Decimal>();
List<Opportunity_Gate__c> errorlist1 = new List<Opportunity_Gate__c>();
List<Opportunity_Gate__c> errorlist2 = new List<Opportunity_Gate__c>();
for (Integer i=0;i<OppGate.size();i++)
{
    if (Trigger.old[i].Actual_Date__c !=Trigger.new[i].Actual_Date__c || Trigger.old[i].Completion_Date__c!=Trigger.new[i].Completion_Date__c)
    {
       
        OppGateIds.add(OppGate[i].Opportunity__c);
         expectedDateNew.put(OppGate[i].Opportunity__c,OppGate[i].Completion_Date__c);
         actualSerialNew.put(OppGate[i].Opportunity__c,OppGate[i].serial_no__c);
         if(Trigger.new[i].Actual_Date__c != null){
        actualDateNew.put(OppGate[i].Opportunity__c,OppGate[i].Actual_Date__c);
             }
    }
}

if(OppGateIds.size()>0)
{

for ( Opportunity_Gate__c existingPhase:[Select id,Name,Actual_Date__c, Completion_Date__c,serial_no__c ,Opportunity__c from Opportunity_Gate__c where Opportunity__c IN: OppGateIds and Actual_date__c!=null order by Opportunity__c , serial_no__c ]) 
{
       
  if (actualSerialNew.get(existingPhase.Opportunity__c)>existingPhase.serial_no__c)
  {
  //Condition check if the actual date is lesser than the actual date of the previous phase
  if (actualDateNew.get(existingPhase.Opportunity__c)<existingPhase.Actual_Date__c )
  {
     errorlist1.add(existingPhase);
  }
  //Condition check if the expected date is lesser than the expected date of the previous phase
  if (expectedDateNew.get(existingPhase.Opportunity__c)<existingPhase.completion_Date__c )
  {
  errorlist2.add(existingPhase);
  }
  }
}

//Adding error message to the page 
for(integer i=0;i<Trigger.new.size();i++)
{
  for(integer j=0;j<errorlist1.size();j++)
  {
   if(Trigger.new[i].Opportunity__c == errorlist1[j].Opportunity__c)
  Trigger.new[i].AddError('Actual Date cannot be lesser than the Actual Dates of previous tollgates');
  }
  for(integer j=0;j<errorlist2.size();j++)
  {
  if(Trigger.new[i].Opportunity__c == errorlist2[j].Opportunity__c)
  Trigger.new[i].AddError('Expected Date cannot be lesser than the Expected Dates of previous tollgates');
  }
}
}
}