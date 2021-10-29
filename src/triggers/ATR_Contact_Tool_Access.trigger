trigger ATR_Contact_Tool_Access on Contact_Tool_Access__c (after update) {
    set<id> lstnew= NEW set<id>();
   
    set<id> listcontact= new set<id>();
    set<String> listPortalid= new set<String>();   
     //Boolean bolChangesPresent = false;
    for(Contact_Tool_Access__c con :Trigger.new)
    {
        system.debug('line 6');
        if(con.Portal_Tool_Master__c==label.Technical_Publications && (con.Request_Status__c=='Approved' || con.Request_Status__c=='Denied')){
            system.debug('line 8');
            lstnew.add(con.id);
            listcontact.add(con.CRM_Contact_ID__c);    
            listPortalId.add(con.Portal_Honeywell_id__c);    
            system.debug('size'+lstnew.size());
           // bolChangesPresent =true;
        }
     }
     Map<id,case> cslist = new Map<id,case>();
     Map<id,String> mapCase=new Map<id,String>();
     if(null!=listcontact && listcontact.size()>0) 
     {
         cslist = new Map<id,case>([select status,AccountId,casenumber,contactid,type,contact.name,tool_name__C,Honeywell_ID__c, Classification__c from case 
                 where  Type ='WEB Portal Registration'and Tool_name__c=:label.ATR_RMU_TOOL_Name and Status='Open' and contactid in :listcontact and Honeywell_ID__c in :listPortalId]);
    
         for(Case cs:cslist.values())
         {
             for(Contact_Tool_Access__c con :Trigger.new)
             {
                 if(cs.Contactid==con.CRM_Contact_ID__c && cs.Honeywell_id__c ==con.Portal_Honeywell_id__c)
                     cs.status=con.request_status__c;
                     mapCase.put(cs.id,con.request_status__c);
                 
             }
         }
         if(null!=mapCase && mapCase.size()>0)
         {
             UpdateContactToolAccessATRRMUTool.updateCase(mapCase);
         } 
     }
     
}