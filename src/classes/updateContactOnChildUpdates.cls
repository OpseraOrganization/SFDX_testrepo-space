public with sharing class updateContactOnChildUpdates{
    
    public static Boolean isRecursive = False;
    public Map<Id, Integer> contactUAASize {get;set;}
    
    public static void updateContactOnUAACreation(List<User_Aircraft_Association__c> uaaIDs) {
        Set<Id> conIdSet= new Set<Id>();
        List<Contact> conListToUpdate = new List<Contact>();
        For(User_Aircraft_Association__c  uaa : uaaIDs){
            conIdSet.add(uaa.User__c);
        }
        if(!conIdSet.isEmpty()){
        
      Map<Id,Contact> conMap =new Map<Id,Contact>([SELECT id,Access__c,Assigned_Aircrafts__c,All_Aircrafts__c, (SELECT Id from User_Aircraft_Associations__r LIMIT 1)FROM Contact WHERE Id IN : conIdSet LIMIT 1000]);
        For(User_Aircraft_Association__c  uaa : uaaIDs){
            if(conMap.get(uaa.User__c).Access__c =='No Access'){
              uaa.addError('For No Access type of Contact, UAA records cannot be created!');
            }
        }
          
           for(Contact con : conMap.values()){
             
              
              if(con.User_Aircraft_Associations__r.size()==1 && conIdSet.contains(con.Id))
              {
                 con.Assigned_Aircrafts__c= true; 
                 con.All_Aircrafts__c =false;
                 conListToUpdate.add(con);
              }
           }
           
           if(!conListToUpdate.isEmpty()){
              try{
                 update conListToUpdate;
              }catch(DmlException de ){
                 System.debug(de.getMessage());
              }
           }
        }
    }
   public static void updateContactOnUAADeletion(List<User_Aircraft_Association__c> uaaIDs){
        Set<Id> contactIdSet  = new Set<id>();
    List<Contact> conListToUpdate = new List<Contact>();
    for(User_Aircraft_Association__c uaa : uaaIDs)
    {
        contactIdSet.add(uaa.User__c);
    }       
    List<Contact> conList =new List<Contact>([SELECT id,Access__c,All_Aircrafts__c,Assigned_Aircrafts__c,
                (SELECT Id from User_Aircraft_Associations__r)FROM Contact WHERE Id IN : contactIdSet  LIMIT 50000]);
        
        for(Contact con : conList)
        {
            if(con.User_Aircraft_Associations__r.size()==0)
            {
                if(con.Access__c != 'No Access')
                {
                    con.All_Aircrafts__c=true; 
                 }
                else
                {
                    con.All_Aircrafts__c=false; 
                    con.Assigned_Aircrafts__c=false;                  
                }
                
                conListToUpdate.add(con);             
            }
        }
    try{
        update conListToUpdate;
    }catch(DmlException de ){
    }
        
        
}   
   public static void updateContactOnRSPCreation(List<Restricted_Service_Program__c > rspIDs)
   {
       Set<Id> conIdSet= new Set<Id>();
       List<Contact> conListToUpdate = new List<Contact>();
       For(Restricted_Service_Program__c rsp : rspIDs){
            
              conIdSet.add(rsp.User__c);
            
       }
       
       if(!conIdSet.isEmpty()){
         Map<Id,Contact> conMap =new Map<Id,Contact>([SELECT id,Access__c,Assigned_Aircrafts__c,All_Aircrafts__c,Has_Restriction__c,(SELECT Id from Restricted_Service_Programs__r LIMIT 1)FROM Contact WHERE Id IN : conIdSet LIMIT 1000]);
        For(Restricted_Service_Program__c   rsp: rspIDs){
            if(conMap.get(rsp.User__c).Access__c =='No Access'){
              rsp.addError('For No Access type of Contact, UAA records cannot be created!');
            }
        }
          
           for(Contact con : conMap.values()){
             
              
              if(con.Restricted_Service_Programs__r.size()==1 && conIdSet.contains(con.Id))
              {
                 con.Has_Restriction__c= true; 
                 
                 conListToUpdate.add(con);
              }
           }
           
           if(!conListToUpdate.isEmpty()){
              try{
                 update conListToUpdate;
              }catch(DmlException de ){
                 System.debug(de.getMessage());
              }
           }
        }
    }
   public static void updateContactOnRSPDeletion(List<Restricted_Service_Program__c > rspIDs)
   {
   Set<Id> contactIdSet  = new Set<id>();
 List<Contact> conListToUpdate = new List<Contact>();
            For(Restricted_Service_Program__c rsp:rspIDs)
            {
                contactIdSet.add(rsp.User__c);
            }
            
  List<Contact> conList=[SELECT id,Access__c,Has_Restriction__c,All_Aircrafts__c,Assigned_Aircrafts__c,(SELECT Id from Restricted_Service_Programs__r) FROM Contact WHERE Id IN : contactIdSet  LIMIT 50000];
               for(Contact con : conList )
               {
                   if(con.Restricted_Service_Programs__r.size() == 0)
                    {
                     if(con.Access__c == 'Read Only' || con.Access__c =='Full Access' || con.Access__c ==NULL)
                     {
                        con.Has_Restriction__c=false;
                     }
                            
                            else
                            {
                            con.Has_Restriction__c=true;
                            }      
                   }
               }
               try{
                  update conList;
               }catch(DmlException de ){
                   System.debug(de.getMessage());
               }
            }
//validation to stop the user when he adds duplicate service program in restricted service program tab.
        public static void restrictDuplicateRSP(List<Restricted_Service_Program__c > rspIDs)
        {
        Set<Id> contactIdSet  = new Set<id>();
        Map<Id,Set<Id>> mapUserMSP = new Map<id,Set<Id>>();
        For(Restricted_Service_Program__c rsp:rspIDs)
                    {
                        contactIdSet.add(rsp.User__c);
                    }
        
        List<Restricted_Service_Program__c> rspList=[SELECT Id,User__c,Master_Service_Program_Name__c from Restricted_Service_Program__c
        WHERE User__c IN : contactIdSet  LIMIT 50000];
        
        for(Restricted_Service_Program__c rs: rspList)
        {
            Set<Id> mspIdSet = new Set<Id>();
        if(mapUserMSP.containsKey(rs.User__c))
        {
            mspIdSet = mapUserMSP.get(rs.User__c);
        }
            mspIdSet.add(rs.Master_Service_Program_Name__c);
            mapUserMSP.put(rs.User__c,mspIdSet);
        }
        For(Restricted_Service_Program__c rsp:rspIDs)
                    {
                        if(mapUserMSP.containsKey(rsp.User__c))
        {
        
            if(mapUserMSP.get(rsp.User__c).contains
        
        (rsp.Master_Service_Program_Name__c))
        {
        rsp.addError('You Cannot Create the Duplicate Restricted Service Program');
        }
        }
                    }
        }
        
   //validation to stop the user when he adds duplicate service program in User aircraft association tab.     
  public static void restrictDuplicateUAA(List<User_Aircraft_Association__c > uaaIDs)
                {
        Set<Id> contactIdSet  = new Set<id>();
        Map<Id,Set<Id>> mapUserMSP = new Map<id,Set<Id>>();
        For(User_Aircraft_Association__c uaa:uaaIDs)
                    {
                        contactIdSet.add(uaa.User__c);
                    }
        
        List<User_Aircraft_Association__c> uaaList=[SELECT Id, User__c,Fleet_Asset_Aircraft_Name__c from User_Aircraft_Association__c 
        WHERE User__c IN : contactIdSet  LIMIT 50000];
        
        for(User_Aircraft_Association__c ua: uaaList)
        {
            Set<Id> mspIdSet = new Set<Id>();
        if(mapUserMSP.containsKey(ua.User__c))
        {
            mspIdSet = mapUserMSP.get(ua.User__c);
        }
            mspIdSet.add(ua.Fleet_Asset_Aircraft_Name__c);
            mapUserMSP.put(ua.User__c,mspIdSet);
        }
        For(User_Aircraft_Association__c uaa:uaaIDs)
                    {
                        if(mapUserMSP.containsKey(uaa.User__c))
        {
        
            if(mapUserMSP.get(uaa.User__c).contains
        
        (uaa.Fleet_Asset_Aircraft_Name__c))
        {
        uaa.addError('You Cannot Create the Duplicate User Associated Aircraft');
        }
        }
             } 
        }
        }