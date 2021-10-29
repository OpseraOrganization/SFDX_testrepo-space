/** * File Name: DSPCManualSharingForCampaign
* Description Read acces to campaign To which the user belongs as Team Member.
* Copyright :NTT DATA Copyright (c) 2010
* * @author : Praveen Sampath
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
trigger DSPCManualSharingForCampaign on Campaign_Team__c (after insert, after update) 
{
   list<campaignshare>updatelist= new list<campaignshare>();
   set<id> campaignIds = new set<id>();
   for(Campaign_Team__c ct: trigger.new)
   {
    campaignIds.add(ct.campaign__c);
   }
   map<id,Campaign> campaignMap = new map<id,campaign>([select id,owner.id from campaign where id in :campaignIds]);
   for(Campaign_Team__c ct: trigger.new)
   {
      if(ct.Team_User__c!=null && (trigger.isInsert ||(trigger.isupdate && ct.Team_User__c!=trigger.oldmap.get(ct.id).Team_User__c)))
      {
        if(ct.Team_User__c != campaignMap.get(ct.campaign__c).Owner.id){
            campaignshare cs= new campaignshare();
            cs.CampaignAccessLevel='Edit';
            cs.UserOrGroupId=ct.Team_User__c;
            cs.CampaignId=ct.Campaign__c;
            updatelist.add(cs);
        }
      }
   }
   insert updatelist;
}