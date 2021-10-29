/** * File Name: OpportunityPhase_UpdatePhase
* Description Trigger to update next phase
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger OpportunityPhase_UpdatePhase on Opportunity_Gate__c (after update) {
List<ID> oid = new List<ID>();
List<ID> ogid = new List<ID>();
integer slno =0;
Map<id,Opportunity_Gate__c> m = new Map<id,Opportunity_Gate__c>();
List<Opportunity> dp= new List<Opportunity> ();
List<Opportunity_Gate__c> opg = new List<Opportunity_Gate__c> ();
List<Opportunity_Gate__c>  r= new List<Opportunity_Gate__c>();
List<Opportunity> op= new List<Opportunity> ();
 triggerinactive.TestOppRequiredFields=false;//Inactivate OpportunityRequiredFieldsTrigger Certido Ticket # 347890
for(Opportunity_Gate__c og: Trigger.new)
{
if(og.Actual_Date__c != null && Trigger.oldMap.get(og.Id).Actual_Date__c == null)
{
oid.add(og.Opportunity__c);
ogid.add(og.id);
m.put(og.Opportunity__c,og);
}
}
if(oid.size()>0)
{
 op= [select id,Next_Phase__c,Roll_up__c,StageName,IsClosed from Opportunity where id in : oid];
}
for(Opportunity_Gate__c og: Trigger.new)
{
for(integer i=0;i<op.size();i++)
{
DEcimal k =op[i].roll_up__C;
if(og.Opportunity__c == op[i].ID && og.Flag__c == False)

{
if(og.serial_no__c != k+1)
{
slno = 1;
og.Actual_Date__c.addError('Please enter the Actual Date for the  previous tollgates');
}
}
}
}
 if(ogid.size()>0)
opg = [select id,Opportunity__r.Next_Phase__c,Name from Opportunity_Gate__c where id in : ogid];
List<Opportunity> opty =new List<Opportunity> ();
if(oid.size()>0)
 r=[select id,Name,Completion_Date__c,Opportunity__c,Serial_No__c,Stage__c from Opportunity_Gate__c where  opportunity__c in :oid ];

for(Opportunity o: op)
{
decimal i = m.get(o.id).serial_no__c + 1;
for(Opportunity_Gate__c oo : r)
{
if(oo.Opportunity__c == o.id && oo.serial_no__c == i)
{
o.Next_Phase__c = oo.Name;
o.Next_Phase_Date__c = oo.Completion_Date__c;
if( o.IsClosed!=true)// added for SR# 385376
  o.StageName = oo.Stage__c;
opty.add(o); 
}

}
}


if(slno !=1)
{
if(opty.size()>0)
{
try
{

update opty;
}
catch(Exception e)
{
System.debug('Exception............'+e);
}
}
}
}