trigger deleteContactRelatedDetails on Portal_Honeywell_ID__c (after update){
list<portal_Honeywell_ID__c> PortalHonids = trigger.new;
if(PortalHonids.get(0).Delete_Hon_Id__c==true){
System.debug('PortalHonids.get(0).Delete_Contact_ID__c========== '+PortalHonids.get(0).Delete_Contact_ID__c);
List<contact_aircraft__c> delItemsFrmContAircraft = [select id from contact_aircraft__c where  crm_contact_id__c = :PortalHonids.get(0).Delete_Contact_ID__c];

if(delItemsFrmContAircraft != null)
{
    delete delItemsFrmContAircraft;
}

List<SAP_Contact_Sold_To__c> delItemsFrmSAPContSoldTo = [select id,contact__c from SAP_Contact_Sold_To__c where  contact__c = :PortalHonids.get(0).Delete_Contact_ID__c];

if(delItemsFrmSAPContSoldTo != null)
{
delete delItemsFrmSAPContSoldTo;
}

List<Account_Contact__c> delItemsFrmAcctCont = [select id,contact__c from Account_Contact__c where  contact__c = :PortalHonids.get(0).Delete_Contact_ID__c];

if(delItemsFrmAcctCont != null)
{
delete delItemsFrmAcctCont;
}

//List<Contact_Tool_Access__c> delItemsFrmContToolAccess = [select id,crm_contact_id__c from Contact_Tool_Access__c where  crm_contact_id__c = :PortalHonids.get(0).Delete_Contact_ID__c];

//if(delItemsFrmContToolAccess != null)
//{
//delete delItemsFrmContToolAccess;
//}

List<Portal_Tools_master__c> toolId = [select id, name from Portal_Tools_Master__c where name = 'Order Status'];  
List<Contact_Tool_Access__c> updateStatusInContToolAccess = [select id,crm_contact_id__c,Portal_Tool_Master__c,Request_Status__c from Contact_Tool_Access__c where  crm_contact_id__c = :PortalHonids.get(0).Delete_Contact_ID__c];
if(updateStatusInContToolAccess !=null && updateStatusInContToolAccess.size()>0)
{
    for(integer i=0; i< updateStatusInContToolAccess.size(); i++)
    {
        //Order Status
        //if(updateStatusInContToolAccess.get(i).Portal_Tool_Master__c == 'a0GQ0000002n2NW')
        if(toolId!=null && toolId.size()>0){
            if(updateStatusInContToolAccess.get(i).Portal_Tool_Master__c == toolId.get(0).id)
            {
                updateStatusInContToolAccess.get(i).Request_Status__c = 'Denied';
            }
        }
                
    }
    update updateStatusInContToolAccess;

}
List<Contact> fieldsToWipedatainCont = [select id,Citizenship_Country__c,Contact_Birth_Country__c,Permanent_USA_Resident__c,Is_US_Citizen__c,Permanent_Resident_Expiration_Date__c,Is_Portal_Super_User__c,Export_Control_Approved__c from Contact where  id = :PortalHonids.get(0).Delete_Contact_ID__c];
System.debug('fields ========== '+fieldsToWipedatainCont);
if(fieldsToWipedatainCont != null && fieldsToWipedatainCont.size()>0)
{
fieldsToWipedatainCont.get(0).Citizenship_Country__c = '';
fieldsToWipedatainCont.get(0).Contact_Birth_Country__c = '';
fieldsToWipedatainCont.get(0).Permanent_USA_Resident__c = false;
fieldsToWipedatainCont.get(0).Is_US_Citizen__c = false;
fieldsToWipedatainCont.get(0).Permanent_Resident_Expiration_Date__c = null;
fieldsToWipedatainCont.get(0).Is_Portal_Super_User__c = false;
fieldsToWipedatainCont.get(0).Export_Control_Approved__c = false;

update fieldsToWipedatainCont;
}

List<portal_Honeywell_ID__c> wipePortalHonIdfields = [select id,Delete_Hon_Id__c,Delete_Contact_ID__c from portal_Honeywell_ID__c where  Delete_Contact_ID__c = :PortalHonids.get(0).Delete_Contact_ID__c];
System.debug('Poratal honeywell id fields ========== '+wipePortalHonIdfields);
if(wipePortalHonIdfields!= null && wipePortalHonIdfields.size()>0)
{
wipePortalHonIdfields.get(0).Delete_Hon_Id__c = false;
//wipePortalHonIdfields.get(0).Delete_Contact_ID__c = null;

update wipePortalHonIdfields;
}
}

}