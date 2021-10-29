/** * File Name: CampaignPhase_UpdatePhase
* Description: Trigger to update the Campaign Next Phase and Next Phase Date when Actual Date for the Phase record is entered
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger CampaignPhase_UpdatePhase on Campaign_Gate__c (after update) {

//Variable Declaration
List<ID> oid = new List<ID>();
List<ID> did = new List<ID>();
List<Campaign_Gate__c> ogid = new List<Campaign_Gate__c>();
Map<id,Campaign_Gate__c> mdate = new Map<id,Campaign_Gate__c>();
Map<id,Campaign_Gate__c> m = new Map<id,Campaign_Gate__c>();
List<Campaign> dp = new List<Campaign>();
List<Campaign_Gate__c>  r = new List<Campaign_Gate__c>();
List<Campaign> op = new List<Campaign>();

for(Campaign_Gate__c og: Trigger.new)
{
//To update the Next Phase Date in Campaign when the Expected Date is entered for the first phase record
if(og.serial_no__c == 1 && og.Expected_Date__c != Trigger.oldMap.get(og.Id).Expected_Date__c )
{
did.add(og.Campaign__c);
mdate.put(og.Campaign__c,og);
}
//Considering only those Campaigns in which Actual Date is entered
if(og.Actual_Date__c != null && Trigger.oldMap.get(og.Id).Actual_Date__c == null)
{
oid.add(og.Campaign__c);
ogid.add(og);
m.put(og.Campaign__c,og);
}
}


//Querying the related Campaigns 
if(oid.size()>0)
{
 op= [select id,Next_Phase__c,Roll_up__c from Campaign where id in : oid];
 r=[select id,Phase__c,Expected_Date__c,Campaign__c,Serial_No__c from Campaign_Gate__c where  Campaign__c in :oid ];

}

//Code to check that the user enters the Actaul Date only in order.Rollup field in campaign gives the number of phase records having actual date
for(Campaign_Gate__c og: ogid)
{
for(integer i=0;i<op.size();i++)
{
Decimal k =op[i].roll_up__C;
if(og.Campaign__c == op[i].ID)
{
if(og.serial_no__c != k+1)
{
og.Actual_Date__c.addError('Please enter the Actual Date for the  previous tollgates');
}
}
}
}

//Code to get the Campaign record to update Next Phase Date when the Expected Date is changed for the first phase record
if(did.size()>0)
{
dp= [select id,Next_Phase__c from Campaign where id in : did];
}

List<Campaign> opty =new List<Campaign> ();
List<Campaign> opty1 =new List<Campaign> ();

//Code to update the Next Phase and Next Phase Date when the Actual Date is entered for the  Phase record
for(Campaign o: op)
{
if(o.Next_Phase__c == 'closed')
{
o.Next_Phase__c = '';
o.Next_Phase_Date__c =null ;
}
decimal i = m.get(o.id).serial_no__c + 1;
for(Campaign_Gate__c oo : r)
{
if(oo.Campaign__c == o.id && oo.serial_no__c == i)
{
if(o.Next_Phase__c != 'closed')
{
o.Next_Phase__c = oo.Phase__c;
o.Next_Phase_Date__c = oo.Expected_Date__c;
}
}
}
opty.add(o);
}

//Code to update the Next Phase DAte when the Expected Date is entered for the first Phase record
for(Campaign o1: dp)
{
o1.Next_Phase_Date__c = mdate.get(o1.id).Expected_Date__c;
opty1.add(o1);
}

try{
if(opty1.size()>0)
update opty1;
}
catch(Exception e)
{
System.debug('Exception for opty1............'+e);
}

try{
if(opty.size()>0)
update opty;
}
catch(Exception e)
{
System.debug('Exception for opty............'+e);
}


}