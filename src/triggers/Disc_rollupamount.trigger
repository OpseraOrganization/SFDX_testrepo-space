/** * File Name: AccountAddress_PrimaryAddress* 
Description  Trigger to update Allocated amount and Spend amount fields on Discretionary 100k budget.Allocated Amount will be sum total of Requested amount of all discretionary requests.Spend amount will be the sum total of all spend amount of all requests
Copyright : Wipro Technologies Limited Copyright (c) 2010* 
* @author : Wipro* 
Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* 
*/ 


trigger Disc_rollupamount on Discretionary__c(after insert,after update,after delete) {

//Declaring variables
List<Discretionary__c> discrlst =new List<Discretionary__c>();
if(Trigger.isdelete)
discrlst= Trigger.old;
else
discrlst= Trigger.new;
List<Campaign_Disc_Budget__c> budgetlst =new List<Campaign_Disc_Budget__c>();
List<Campaign_Disc_Budget__c> updatelist =new List<Campaign_Disc_Budget__c>();
List<ID> budgetids = new List<ID>();
List<Discretionary__c> alldiscrlst = new List<Discretionary__c>();
Decimal reqamt,spendamt;


for(integer i=0;i<discrlst.size();i++)
{
if(discrlst[i].Discretionary_100k_Budget__c!= null)
{
budgetids.add(discrlst[i].Discretionary_100k_Budget__c);
}
if(Trigger.IsUpdate)
{
if(discrlst[i].Discretionary_100k_Budget__c!= Trigger.old[i].Discretionary_100k_Budget__c && Trigger.old[i].Discretionary_100k_Budget__c!=null )
{

budgetids.add(Trigger.old[i].Discretionary_100k_Budget__c);
}
}
}

//Querying all discretionary requests related to the budget
if(budgetids.size()>0)
{
budgetlst = [select id,Allocated_Amount__c,Spend_Amount__c from Campaign_Disc_Budget__c where id in :budgetids];
alldiscrlst = [select id,Total_Request_Amount_rollup__c,Total_Spent_Amount__c,Discretionary_100k_Budget__c from Discretionary__c where Discretionary_100k_Budget__c in :budgetids];
}
for(integer i=0;i<budgetlst.size();i++)
{
 reqamt=0;
 spendamt=0;
 for(integer j=0;j<alldiscrlst.size();j++)
  {
  if(budgetlst[i].Id ==alldiscrlst[j].Discretionary_100k_Budget__c)
  { 
  reqamt=reqamt+alldiscrlst[j].Total_Request_Amount_rollup__c;
  spendamt=spendamt+alldiscrlst[j].Total_Spent_Amount__c;
  }
  }
  budgetlst[i].Allocated_Amount__c=reqamt;
  budgetlst[i].Spend_Amount__c=spendamt;
  updatelist.add(budgetlst[i]);
}
//updating fields
if(updatelist.size()>0)
{
try
{
update updatelist;
}
catch(Exception e)
{
System.debug('Exception in updation'+e);
}
}
}