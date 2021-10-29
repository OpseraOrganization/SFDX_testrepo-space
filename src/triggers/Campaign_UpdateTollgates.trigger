/** * File Name: UpdateTollgates
* Description: Trigger is to update the Is_Campaign_Completed__c field in Campaign Tollgate. This is used for internal purpose. Email for tollgate due sould not be send for cancelled and completed campaigns. To achieve this is time based workflow , we are updating this field in toll gate record.
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Campaign_UpdateTollgates on Campaign (after insert,after update) {

//Declaring variables
List<Campaign> c = Trigger.new;
List<ID> cidlist = new List<ID>();
List<Campaign_Gate__c> tollgates = new List<Campaign_Gate__c>();

//Adding the required campaign ids to a list
for (integer i=0;i<c.size();i++ )
{
 if(Trigger.Isupdate)
 {
  if ((c[i].Status=='Cancel'|| c[i].Status=='Completed') && (TRigger.old[i].status !='Cancel' ||Trigger.old[i].status !='Completed')&& (c[i].RecordTypeID != label.Id_of_BGA_record_type_of_Campaign))
    {
        cidlist.add(c[i].id);
    }
 } 
 if(Trigger.Isinsert)
 {
  if ((c[i].Status=='Cancel'|| c[i].Status=='Completed')&& (c[i].RecordTypeID != label.Id_of_BGA_record_type_of_Campaign))
    {
        cidlist.add(c[i].id);
    }
 }   
}
//Querying the tollgates 
if(cidlist.size()>0)
{
tollgates  = [select id,Is_Campaign_Completed__c from Campaign_Gate__c where campaign__c in :cidlist];
 for(integer i=0;i<tollgates.size();i++)
 {
 //Updating the field
 tollgates[i].Is_Campaign_Completed__c = true;
 }
}
if(tollgates.size()>0)
{
try
{
update tollgates;
}
catch(Exception e)
{
System.debug('Exception......'+e);
}
}

// Insert Campaign team after successfull insert or update of campaign 
        Map<id,Campaign> mapCampFinal = new Map<id,Campaign>([select  Account_Name__r.ownerid,Ownerid,Owner.Functional_Role__c,id,Name,CampaignPrimarySBU__c,CampaignPrimaryCBTTier2__c,CBT_Team__c,Primary_Sales_Channel__c,SC1__c,SC2__c from Campaign where id in: Trigger.new]);        
        list<Campaign_Team__c> CampaignTeamList =  new list<Campaign_Team__c>();      
        for(Campaign Camp: Trigger.new)
        {    
              if(Trigger.isUpdate && Trigger.oldMap.get(Camp.id).ownerid == Camp.ownerid){
                  continue;
              }
                  Campaign_Team__c CampInsert = new Campaign_Team__c();
                 if(Camp.CampaignPrimarySBU__c == 'ATR'||Camp.CampaignPrimarySBU__c == 'BGA'||Camp.CampaignPrimarySBU__c == 'D&S' ){
                    System.debug('Functional Role : ' +Camp.owner.Functional_Role__c);         
                    CampInsert.Team_Role__c= mapCampFinal.get(camp.id).owner.Functional_Role__c;
                    CampInsert.Campaign__c= Camp.Id;
                    System.debug('Owner ID : ' +Camp.ownerid);
                    CampInsert.Team_User__c = mapCampFinal.get(Camp.id).Account_Name__r.ownerid;  
                    CampInsert = new Campaign_Team__c(); 
                   }
                {    
                CampInsert.Campaign__c=Camp.Id;
                CampInsert.Team_User__c =Camp.ownerid;
                CampaignTeamList.add(CampInsert );
                }            
       }   
       insert CampaignTeamList;
}