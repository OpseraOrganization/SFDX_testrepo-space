/** * File Name: Contact_UpdateOwner
* Description :Trigger to update owner
* Copyright : NTT DATA Copyright (c) 2001 *
* @author : NTT DATA
* Modification Log =============================================================== 
   Modify on 12/16/2013 for SR#439707
   Modify on 9/4/2014 for marketo sync contact validation rule INC000006099517
   Modify on 5/5/2015 for Contact Owner Update on Inactive Status
**/
trigger Contact_UpdateOwner on Contact(before update) 
{        
       
    Map<id,contact> contactsMap=new Map<id,contact>();    
    contactsMap=new Map<ID,Contact>([select id,(SELECT Id, Name FROM Portal_Honeywell_ID__r ),
        owner.Isactive from Contact where id in:Trigger.new]);
    
    String username = UserInfo.getUserName();
    for(Contact ct : Trigger.new)
    {
        //SR#439707 changes - Start
        if(!contactsMap.get(ct.id).owner.isactive)
        {
            ct.ownerid = label.API_User_SFDC_Cust_Master1;    
        }
        //SR#439707 changes - End
        
        /* Start - Commenting the code based on the ticket #INC000011601590
        //////////////Start: Added for Marketo Sync # INC000006099517//////////// 
        if(username == 'marketoapiuser@honeywell.com' && 
            (ct.Contact_Is_Employee__c == true || contactsMap.get(ct.id).Portal_Honeywell_ID__r.size()>0 ))
        {
            ct.addError('Marketo is not allowed to update email address for a Portal Contact.');
        }
        //////////////End: Added for Marketo Sync # INC000006099517/////////////  
        */ //End - Commenting the code based on the ticket #INC000011601590
        
        // Code starts for INC000008600452
        if(null!=ct.Contact_Status__c && trigger.oldMap.get(ct.id).Contact_Status__c!=trigger.newMap.get(ct.id).Contact_Status__c && ct.Contact_Status__c=='Inactive'){
            ct.OwnerId = Label.Inactive_Record_Owner_Id;
        }
        // Code End for INC000008600452     
    }       
}