/** * File Name: DSPCManualSharing
* Description Trigger to provide edit access to the Partner Account to which this portal User is Associated 
* Copyright : NTT DATA Copyright (c) 2014
* * @author : Praveen Sampath
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */ 
trigger DSPCManualSharing on User (After Insert, After Update)
{
    set<id>contactid= new set<id>();
    map<id,id> contactmap= new map<id,id>();
    list<AccountShare> accshare= new list<AccountShare>();
    list<contact> contactlist= new list<contact>();
    UserTriggerHelperClass helper=new UserTriggerHelperClass();
    for(user u:trigger.new)
    {
        if(u.IsActive==true && u.ContactId!=null)
        {
            contactid.add(u.ContactId);
            contactmap.put(u.ContactId, u.id);
        }
    }
    if(contactid.size()>0)
    {
        contactlist=[select id, accountid, Account.IsPartner,Account.DSPC_Account__c from contact where id IN:contactid and Account.DSPC_Account__c=true];
    }
    for(Contact c:contactlist)
    {
        if(contactmap.get(c.Id)!=null)
        {
            AccountShare share = new AccountShare();
            share.AccountId=c.AccountId;
            share.AccountAccessLevel='Edit';
            share.ContactAccessLevel='Read';
            share.OpportunityAccessLevel='Read';
            share.CaseAccessLevel='Read';
            share.UserOrGroupId=contactmap.get(c.Id);
            accshare.add(share);
        }
    }
    if(accshare.size()>0)
        insert  accshare;
    
    if(Trigger.isUpdate){
        //Salesforce Portal User update:
        set<id>userContactId= new set<id>();
        for(user userRec:trigger.new) {           
            if((Trigger.newmap.get(userRec.id).IsActive == false)  &&  (Trigger.oldmap.get(userRec.id).ProfileId == label.Custom_Customer_Portal)){
                 userContactId.add(userRec.contactid);
            }
        }
        if(System.isFuture() == false && system.isBatch()==false){
        UserTriggerHelperClass.AfterUpsert(userContactId); 
        }
    }
}