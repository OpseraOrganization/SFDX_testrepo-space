/*--- Trigger to insert Campaign Phases when a Campaign is inserted.This trigger will update the "Next Phase " field of the Campaign record also ---*/
/** * File Name: Campaign_InsertCampaignGates
* Description: Trigger to insert Campaign Phases when a Campaign is inserted.This trigger will update the "Next Phase " field of the Campaign record also
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger Campaign_InsertCampaignGates on Campaign (after insert) {
List<Campaign> lidcomplex = new List<Campaign>();
List<Campaign> lidfocus = new List<Campaign>();
List<Campaign> lidkey = new List<Campaign>();
List<Campaign_Gate__c> og = new List<Campaign_Gate__c>();
List<Campaign> clist = new List<Campaign>();
List<ID> cIds = new List<ID>();
Campaign_Gate__c optyg =null;
for(Campaign o :Trigger.new)
{
if(o.RecordTypeId != label.Id_of_BGA_record_type_of_Campaign){
cIds.add(o.Id);
}
}
List <Campaign> cList1= new List <Campaign>();
cList1 = [select id,Type,next_phase__c from Campaign where id in : cIds];

for(integer i=0;i<cList1.size();i++)
{
if(cList1[i].Type == 'Competitive')
{
lidcomplex.add(cList1[i]);
}
if(cList1[i].Type == 'Focus')
{
lidfocus.add(cList1[i]);
}
if(cList1[i].Type == 'Key')
{
lidkey.add(cList1[i]);
}
}

//Fetching Campaign Phase  records from the Phase/Matrix Object for Campaign Type "Focus" and updating the "Next Phase" field in Campaign
if(lidfocus.size()>0)
{

List<Matrix__c> mfocus = [select Phase__C,serial_no__c,stage__C,Campaign_Type__c from Matrix__c where Campaign_Type__c = 'Focus' order by serial_no__c];
if(mfocus.size()>0)
{
for(Campaign opp :  lidfocus)
{
opp.next_phase__c = mfocus[0].Phase__C ;
for(integer i=0;i<mfocus.size();i++)
{
optyg = new Campaign_Gate__c();
optyg.Campaign__c = opp.id;
optyg.name =mfocus[i].Phase__C;
optyg.phase__c =mfocus[i].Phase__C;
optyg.serial_no__c =mfocus[i].serial_no__c;
optyg.Campaign_Type__c =mfocus[i].Campaign_Type__C;
og.add(optyg);
}
clist.add(opp);
}
}
}
//Fetching Campaign Phase  records from the Phase/Matrix Object for Campaign Type "Key" and updating the "Next Phase" field in Campaign
if(lidkey.size()>0)
{
List<Matrix__c> mkey = [select Phase__C,serial_no__c,stage__C,Campaign_Type__C from Matrix__c where Campaign_Type__c = 'Key' order by serial_no__c];
if(mkey.size()>0)
{
for(Campaign opp :  lidkey)
{
opp.next_phase__c = mkey[0].Phase__C ;
for(integer i=0;i<mkey.size();i++)
{
optyg = new Campaign_Gate__c();
optyg.Campaign__c = opp.id;
optyg.name =mkey[i].Phase__C;
optyg.phase__c =mkey[i].Phase__C;
optyg.Campaign_Type__c =mkey[i].Campaign_Type__C;
optyg.serial_no__c =mkey[i].serial_no__c;
og.add(optyg);
}
clist.add(opp);
}
}
}
//Fetching Campaign Phase  records from the Phase/Matrix Object for Campaign Type "Competitive" and updating the "Next Phase" field in Campaign
if(lidcomplex.size()>0)
{
List<Matrix__c> mcomplex = [select Phase__C,serial_no__c,stage__C,Campaign_Type__C from Matrix__c where Campaign_Type__c = 'Competitive' order by serial_no__c];
if(mcomplex.size()>0)
{
for(Campaign opp :  lidcomplex)
{
opp.next_phase__c = mcomplex[0].Phase__C ;
for(integer i=0;i<mcomplex.size();i++)
{
optyg = new Campaign_Gate__c();
optyg.Campaign__c = opp.id;
optyg.name =mcomplex[i].Phase__C;
optyg.phase__c =mcomplex[i].Phase__C;
optyg.serial_no__c =mcomplex[i].serial_no__c;
optyg.Campaign_Type__c =mcomplex[i].Campaign_Type__C;
og.add(optyg);
}
clist.add(opp);
}
}
}
//Inserting Campaign Phase records
try{
if(og.size()>0)
{
insert og;
}
}
catch(Exception e)
{
System.debug('Exception for og.....'+e);
}
//Updating campaign records
try
{
if(clist.size()>0)
{
update clist;
}
}
catch(Exception e)
{
System.debug('Exception for clist.....'+e);
}
}