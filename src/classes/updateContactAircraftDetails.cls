/**** class invokes from updateAircraftDetails Trigger ***/
public class updateContactAircraftDetails
{    
    //method  to perform operations while changing aircraft related checkboxes in contact detail page 
    public void updateAircraftDetails(List<Contact> lstCon,Map<id,Contact> mapCon)
    {
        //set to store contact Ids
        Set<Id> setContactId = new Set<Id>(); 
        
        //store User aircraft association related data
        List<User_Aircraft_Association__c> lstUAA =new List<User_Aircraft_Association__c>();
        List<User_Aircraft_Association__c> lstUAAToDelete = new List<User_Aircraft_Association__c>();
        Map<Id,List<User_Aircraft_Association__c>> mapUAA = new Map<Id,List<User_Aircraft_Association__c>>();
        
        //store Restricted Service Program related data
        List<Restricted_Service_Program__c> lstRSP =new List<Restricted_Service_Program__c>();
        List<Restricted_Service_Program__c> lstRSPToDelete = new List<Restricted_Service_Program__c>();
        Map<Id,List<Restricted_Service_Program__c>> mapRSP = new Map<Id,List<Restricted_Service_Program__c>>();
        
        //add value to set from Trigger.new
        for(Contact c: lstCon)
        {
            setContactId.add(c.Id);
        }
        
        //fetch UAA and RSP for newly updating contacts
        lstUAA = [Select id,User__c from User_Aircraft_Association__c where  User__c IN: setContactId];
        lstRSP = [Select id, User__c from Restricted_Service_Program__c where User__c IN: setContactId];
        
        for(User_Aircraft_Association__c uaa: lstUAA)
        {
            List<User_Aircraft_Association__c> lstUAAPerContact =new List<User_Aircraft_Association__c>();
            if(mapUAA.containsKey(uaa.User__c))
            {
                lstUAAPerContact = mapUAA.get(uaa.User__c);
            }
            lstUAAPerContact.add(uaa);
            mapUAA.put(uaa.User__c,lstUAAPerContact);
        }
        for(Restricted_Service_Program__c rsp: lstRSP)
        {
            List<Restricted_Service_Program__c> lstRSPPerContact =new List<Restricted_Service_Program__c>();
            if(mapRSP.containsKey(rsp.User__c))
            {
                lstRSPPerContact = mapRSP.get(rsp.User__c);
            }
            lstRSPPerContact.add(rsp);
            mapRSP.put(rsp.User__c,lstRSPPerContact);
        }
        for(Contact c: lstCon)
        {        
            if(c.Access__c !='No Access') 
            {   
                if((c.Assigned_Aircrafts__c != mapCon.get(c.Id).Assigned_Aircrafts__c) && c.Assigned_Aircrafts__c)
                {
                    if(!mapUAA.containsKey(c.Id))
                    {
                        c.addError('There are no User Aircraft Association records available for this Contact. Please verify.');    
                    }
                    else
                    {
                        c.All_Aircrafts__c = false;
                    }                 
                }
                else if(((c.Assigned_Aircrafts__c != mapCon.get(c.Id).Assigned_Aircrafts__c) && !c.Assigned_Aircrafts__c) || ((c.All_Aircrafts__c != mapCon.get(c.Id).All_Aircrafts__c) && c.All_Aircrafts__c))
                {   
                    if(mapUAA.containsKey(c.Id))
                    {
                        lstUAAToDelete.addAll(mapUAA.get(c.Id));
                    }
                    if(!c.Assigned_Aircrafts__c)
                        c.All_Aircrafts__c = true; 
                    if(c.All_Aircrafts__c)
                        c.Assigned_Aircrafts__c = false;
                    
                }
                if((c.Has_Restriction__c!= mapCon.get(c.Id).Has_Restriction__c) && c.Has_Restriction__c)
                {
                    if(!mapRSP.containsKey(c.Id))
                    {
                        c.addError('There are no Restricted Service Program records available for this Contact. Please verify.');    
                    }
                }
                else if((c.Has_Restriction__c!= mapCon.get(c.Id).Has_Restriction__c) && !c.Has_Restriction__c)
                {
                    if(mapRSP.containsKey(c.Id))
                    {
                        lstRSPToDelete.addAll(mapRSP.get(c.Id));
                    }
                }
            }
            else
            {
                if((c.All_Aircrafts__c!= mapCon.get(c.Id).All_Aircrafts__c) && c.All_Aircrafts__c)
                {
                    c.addError('You donot have access to check All Aircrafts');    
                }
                else if((c.Assigned_Aircrafts__c!= mapCon.get(c.Id).Assigned_Aircrafts__c) && c.Assigned_Aircrafts__c)
                {
                    c.addError('You donot have access to check Assigned Aircrafts');    
                }
                else if((c.Has_Restriction__c!= mapCon.get(c.Id).Has_Restriction__c) && c.Has_Restriction__c)
                {
                    c.addError('You donot have access to check Has Restriction');    
                }
                else
                {
                    c.Assigned_Aircrafts__c = false;
                    c.All_Aircrafts__c = false;
                    c.Has_Restriction__c = false;
                    if(mapRSP.containsKey(c.Id))
                    {
                        lstRSPToDelete.addAll(mapRSP.get(c.Id));
                    }
                    if(mapUAA.containsKey(c.Id))
                    {
                        lstUAAToDelete.addAll(mapUAA.get(c.Id));
                    }
                }
            }
        }
        try
        {
            if(!lstUAAToDelete.isEmpty())
                delete lstUAAToDelete;
            if(!lstRSPToDelete.isEmpty())
                delete lstRSPToDelete;
        }
        catch(Exception e)
        {
            System.debug(e);
        }
        
    }
}