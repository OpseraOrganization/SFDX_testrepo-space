/** * File Name: Campaign_FetchAccountData
* Description: Trigger is to update the SBU field and CBT field in Campaign from Account
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Campaign_FetchAccountData on Campaign(before insert,before update)
{
List<Campaign> c = Trigger.new;
//SBUFormulae__c,CBTTier2Formulae__c are formula fields which holds the SBU, CBT values form the Account
for (integer i=0;i<c.size();i++ )
{
    if (c[i].CampaignPrimarySBU__c==null && c[i].Account_Name__c!=null && c[i].RecordTypeId != label.Id_of_BGA_record_type_of_Campaign)
    {
        c[i].CampaignPrimarySBU__c =c[i].SBUFormulae__c;
        c[i].CampaignPrimaryCBTTier2__c=c[i].CBTTier2Formulae__c;
    }
}
}