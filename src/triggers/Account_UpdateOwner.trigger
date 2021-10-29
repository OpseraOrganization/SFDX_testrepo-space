/** * File Name: Account_UpdateOwner
* Description :Trigger to update owner
* Copyright : Wipro Technologies Limited Copyright (c) 2001 *
 * @author : Wipro
 * Modification Log =============================================================== Ver Date Author Modification --- ---- ------ -------------* */ 
 /*Modified on 10/29/2013 for SR#425182*/
trigger Account_UpdateOwner on Account (before insert,before update) 
{
    String profid=(UserInfo.getProfileId().substring(0,15));
    List<Account_Address__c> accaddress=new List<Account_Address__c>();
    if(profid!=label.DeniedpartyAPIuserprofile)
    {
        for(Account accounts:Trigger.new){
            accounts.Account_Owner__C=accounts.OwnerId;
        }  
    }
    //SR#425182 starts here
    if(trigger.isupdate)
    {
        Set<id> acccid = New set<Id>();
        for(Account acc:Trigger.new){
            if(Trigger.newMap.get(acc.id).Customer_Status__c == 'Inactive'&& Trigger.newMap.get(acc.id).Customer_Status__c != Trigger.oldMap.get(acc.id).Customer_Status__c)
            {
                acccid.add(acc.id);
            }           
        }
        if(acccid.size()>0)
        {
        List<Account_Address__c> accadd=[select id,name,Mobile_App_Visibility__c from Account_Address__c where Account_Name__c=:acccid and Mobile_App_Visibility__c=true];
        if(accadd.size()>0)
        {
            for(Account_Address__c accadd1:accadd)
            {
                accadd1.Mobile_App_Visibility__c=false;
                accadd1.Mobile_App_Visibility_Uncheck__c=true;
                accadd1.Mobile_App_Visibility_Check__c=true;
                accaddress.add(accadd1);
            }
            update accaddress;          
        }       
        
        }       
    }
}