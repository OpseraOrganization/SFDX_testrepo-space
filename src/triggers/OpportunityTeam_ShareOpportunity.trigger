/** * File Name: OpportunityTeam_ShareOpportunity
* Description Trigger to provide edit access to the Opportunity when the user is added to the Opportunity Team 
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
13/10/2010 - Modified code to handle updatation of opportunity team record scenario as well
27/03/2013 - Modified update logic to map Opportunity id and user id correctly

Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger OpportunityTeam_ShareOpportunity on Opportunity_Sales_Team__c (before delete, before insert,before update) {

//Variable declaration
List<Id> objId = new List<Id>();
List<Id> objuserId = new List<Id>();
List<Opportunity_Sales_Team__c> opplst = Trigger.New;
List<OpportunityShare> lsshare = new List<OpportunityShare>();
List<List<ID>> lstOppshare = new List<List<ID>>();
List<ID> lstOppUserIds = new List<ID>();

if(Trigger.Isinsert || TRigger.ISupdate)
{
//Creating list of Opportunity Share record for the User added in the Opportunity Team
for(integer i=0;i<opplst.size();i++)
{
if(Trigger.Isinsert)
{
if(opplst[i].User__c !=null && opplst[i].User__c != Userinfo.getuserid() && opplst[i].User__c!=opplst[i].Opportunity_Owner_Id__c)
{
OpportunityShare s = new OpportunityShare();
s.UserOrGroupId = opplst[i].User__c;
s.OpportunityAccessLevel = 'Edit' ;
s.OpportunityId =opplst[i].opportunity__c;
lsshare.add(s);
}
}
if(Trigger.IsUpdate)
{
//Condition check for update trigger if the user is updated
if(opplst[i].User__c != Trigger.old[i].User__c && opplst[i].User__c !=null && opplst[i].User__c != Userinfo.getuserid() && opplst[i].User__c!=opplst[i].Opportunity_Owner_Id__c)
{
OpportunityShare s = new OpportunityShare();
s.UserOrGroupId = opplst[i].User__c;
s.OpportunityAccessLevel = 'Edit' ;
s.OpportunityId =opplst[i].opportunity__c;
lsshare.add(s);
}
}
}
//Inserting Opportunity Share record
if(lsshare.size()>0) 
{
    try
    {
    insert lsshare;
    }
    catch(Exception e)
    {
    system.debug('Exception e'+e);
    }
}
}

if(Trigger.Isdelete || TRigger.isupdate)
{
List <Opportunity_Sales_Team__c> opp = Trigger.old;
List<OpportunityShare> os = new List<OpportunityShare> ();
Map<string, OpportunityShare> osmap = new Map<string, OpportunityShare>();
List<OpportunityShare> lstOppShareToDel = new List<OpportunityShare> ();
if(opp.size()>0)
{
if(Trigger.ISdelete)
{
lstOppshare = new List<List<ID>>();
for(integer i=0;i<opp.size();i++)
{
if(opp[i].User__c != null )
{
objId.add(opp[i].opportunity__c);
lstOppUserIds = new List<ID>();
objuserId.add(opp[i].User__c);
lstOppUserIds.add(opp[i].opportunity__c);
lstOppUserIds.add(opp[i].User__c);
lstOppshare.add(lstOppUserIds);
}
}
}
if(Trigger.ISupdate)
{
lstOppshare = new List<List<ID>>();
for(integer i=0;i<opp.size();i++)
{
//Condition check for update trigger if the user is updated
if(Trigger.new[i].User__c != Trigger.old[i].User__c && opp[i].User__c != null)
{
objId.add(opp[i].opportunity__c);
lstOppUserIds = new List<ID>();
objuserId.add(opp[i].User__c);
lstOppUserIds.add(opp[i].opportunity__c);
lstOppUserIds.add(opp[i].User__c);
lstOppshare.add(lstOppUserIds);
}
}
}
}
//Querying the OpportuntiyShare object for removing the access to the Opportunity
if(objuserId.size()>0)
{
 os = [Select id,OPPORTUNITYID,UserOrGroupId from OpportunityShare where OPPORTUNITYID in :objId and (USERORGROUPID in : objuserid) ];
}
for(integer i=0; i<os.size(); i++)
{
string s1 = os[i].OPPORTUNITYID;
string s2 = os[i].UserOrGroupId;
osmap.put(s1+s2,os[i]);
}
    
    for(integer j=0; j<lstOppshare.size(); j++)
    {
    List<ID> lstIds = lstOppshare[j];
    string s3 = lstIds[0];
    string s4 = lstIds[1];
        if(osmap.containsKey(s3+s4))
        {
            lstOppShareToDel.add(osmap.get(s3+s4));
        }
    }
try
{
    system.debug('lstOppShareToDel'+lstOppShareToDel.size());
    if(lstOppShareToDel.size()>0)
    {  
        delete lstOppShareToDel;
    }
}
catch(Exception e)
{
    system.debug('Exception e'+e);
}
}

}