//prod code


trigger updateTeamMember on Account (before insert,before update,after update) {
if(Label.StopUpdateTeamMamber == 'Active'){
    String profid=(UserInfo.getProfileId().substring(0,15));
    if(profid!=label.DeniedpartyAPIuserprofile){
        List<Id> accountId = new List<Id> ();
        List<AccountTeamMember> act= new List<AccountTeamMember>();
        
        if(Trigger.isBefore){
            // map<ID,Account> oldmap = new map<ID,Account> ();
            for(Account accnts : Trigger.New){
              accountId.add(accnts.Id); 
            }
            System.debug('&&&&&&&&accountId'+accountId.size());
            try{
                act=[Select Id,accountId,userId from AccountTeamMember where TeamMemberRole='Contract Manager' and 
                Accountid in :accountId];
                for(Account accnts : Trigger.New){
                   for(integer i=0;i<act.size();i++){
                    if(accnts.Id==act[i].AccountId) {
                    accnts.contract_manager__C=act[i].userId;
                    }
                    
                   }
                }
            }
            catch(Exception e){}
        
        
 //Code Changes for SR#428485 - Concierge Checkbox needs to be read only except for the Customer Master Data team or Admins
    String Userid = UserInfo.getUserId().substring(0,15);
    String prof = Userinfo.getProfileId();
    String profname = [Select name from Profile where Id=:prof].name;
    profname = profname.tolowercase();
    Map<id,User> mapGpmr = new Map<id,User>([Select Id from User where Id in (Select UserOrGroupId From GroupMember where GroupId = :Label.Customer_Master_Data_Team)]);
            System.debug('System admin:'+profname);
    if(!mapGpmr.containsKey(Userid) && profname != 'system administrator' && profname != 'honeywell system administrator' && profName != 'honeywell system administrator (non us)'){
        for(Account acc :Trigger.New)
        {
            if((Trigger.isInsert  && acc.Concierge__c == true ) || (Trigger.isUpdate && Trigger.OldMap.get(acc.Id).Concierge__c != acc.Concierge__c)){
                acc.addError('To change a Concierge please contact the Customer Master Data Team or Admins');
            }
        }
    }
  //Code changes for SR#428485 Ends    
  }
 } 
    // Code changes for INC0000882132
    
    Set<Id> accCusIds = new Set<Id>();
    Set<Id> accBusIds = new Set<Id>();
    Set<Id> accArSalIds = new Set<Id>();
    Set<Id> accCusEscIds = new Set<Id>();
    Set<Id> accBusEscIds = new Set<Id>();
    Set<Id> conIdsCus = new Set<Id>();
    Set<Id> conIdsBus = new Set<Id>();
    Set<Id> conIdsCusEsc = new Set<Id>();
    Set<Id> conIdsBusEsc = new Set<Id>();
    set<id> userIdareasls = new set<id>();
    Set<Id> accdelCusIds = new Set<Id>();
    Set<Id> accdelBusIds = new Set<Id>();
    Set<Id> accdelArSalIds = new Set<Id>();
    Set<Id> accdelCusEscIds = new Set<Id>();
    Set<Id> accdelBusEscIds = new Set<Id>();
    // Acc Ids
   if(Trigger.isUpdate && Trigger.isAfter)
    for(Account acInt: Trigger.New)
    {
        //accIds.add(acInt.Id);
        if(acInt.Customer_Support_Focal__c!= null){
        conIdsCus.add(acInt.Customer_Support_Focal__c);
        accCusIds.add(acInt.Id);
        }
        else if(acInt.Customer_Support_Focal__c == null){
        //condelIdsCus.add(acInt.Customer_Support_Focal__c);
        accdelCusIds.add(acInt.Id);
        }
        if(acInt.Business_Focal__c!= null){
        conIdsBus.add(acInt.Business_Focal__c);
        accBusIds.add(acInt.Id);
        }
        else if(acInt.Business_Focal__c == null){
        //conIdsBus.add(acInt.Business_Focal__c);
        accdelBusIds.add(acInt.Id);
        }
        if(acInt.Area_Sales_Mgr__c!= null){
        userIdareasls.add(acInt.Area_Sales_Mgr__c);
        accArSalIds.add(acInt.Id);
        }
        else if(acInt.Area_Sales_Mgr__c == null){
        //userIdareasls.add(acInt.Area_Sales_Mgr__c);
        accdelArSalIds.add(acInt.Id);
        }
        if(acInt.Customer_Support_Escalation__c!= null){
        conIdsCusEsc.add(acInt.Customer_Support_Escalation__c);
        accCusEscIds.add(acInt.Id);
        }
        else if(acInt.Customer_Support_Escalation__c == null){
        //userIdareasls.add(acInt.Customer_Support_Escalation__c);
        accdelCusEscIds.add(acInt.Id);
        }
        if(acInt.Business_Escalation__c!= null){
        conIdsBusEsc.add(acInt.Business_Escalation__c);
        accBusEscIds.add(acInt.Id);
        }
        else if(acInt.Business_Escalation__c == null){
        //conIdsBusEsc.add(acInt.Business_Escalation__c);
        accdelBusEscIds.add(acInt.Id);
        }
        
    }
    // Account Team Map
    List<AccountTeamMember> oldList = new List<AccountTeamMember>();
    List<AccountTeamMember> olddelList = new List<AccountTeamMember>();
    Map<String, List<AccountTeamMember>> accTeamMapCus = new Map<String, List<AccountTeamMember>>();
    Map<String, AccountTeamMember> accTeamMapBus = new Map<String, AccountTeamMember>();
    Map<String, AccountTeamMember> accTeamMapSalesMng = new Map<String, AccountTeamMember>();
    Map<String, AccountTeamMember> accTeamMapCusEsc = new Map<String, AccountTeamMember>();
    Map<String, AccountTeamMember> accTeamMapBusEsc = new Map<String, AccountTeamMember>();
    Map<String, List<AccountTeamMember>> accTeamDelMapCus= new Map<String, List<AccountTeamMember>>();
    Map<String, AccountTeamMember> accTeamDelMapBus = new Map<String, AccountTeamMember>();
    Map<String, AccountTeamMember> accTeamDelMapSalesMng = new Map<String, AccountTeamMember>();
    Map<String, AccountTeamMember> accTeamDelMapCusEsc = new Map<String, AccountTeamMember>();
    Map<String, AccountTeamMember> accTeamDelMapBusEsc = new Map<String, AccountTeamMember>();
    
    if(accCusIds.size()>0){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where ((TeamMemberRole ='Customer Support Manager (CSM)') OR (TeamMemberRole ='Customer Support Program Manager (CSPM)') OR (TeamMemberRole ='Customer Support Focal (CSM/CSPM)')) AND Accountid in :accCusIds])
    {
       // if(act.TeamMemberRole == 'Customer Service Manager')
      //  {
            if(accTeamMapCus.containskey(act.accountId)){
             oldList = accTeamMapCus.get(act.accountId);
             oldList.add(act);
             accTeamMapCus.put(act.accountId,oldList);
            }else{
               List<AccountTeamMember> newList = new List<AccountTeamMember>();
               newList.add(act);
               accTeamMapCus.put(act.accountId,newList);
            }
       // }
    }
    }
     //system.debug('@@ accTeamMapCus is '+accTeamMapCus);
    
    if((accBusIds.size()>0) || (accArSalIds.size()>0) || (accCusEscIds.size()>0) || (accBusEscIds.size()>0)){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where (TeamMemberRole ='Customer Business Manager (CBM)' AND Accountid in :accBusIds) OR (TeamMemberRole = 'Area Sales Manager (ASM)' AND Accountid in :accArSalIds) OR (TeamMemberRole = 'Customer Support Escalation' AND Accountid in :accCusEscIds) OR (TeamMemberRole ='Customer Business Director' AND Accountid in :accBusEscIds)])
    {  
       
        if(act.TeamMemberRole == 'Customer Business Manager (CBM)')
        {
            accTeamMapBus.put(act.accountId, act);
            
        }
        if(act.TeamMemberRole == 'Area Sales Manager (ASM)')
        {
            accTeamMapSalesMng.put(act.accountId, act);
        }
        if(act.TeamMemberRole == 'Customer Support Escalation')
        {
            accTeamMapCusEsc.put(act.accountId, act);
        }
        if(act.TeamMemberRole == 'Customer Business Director')
        {
            accTeamMapBusEsc.put(act.accountId, act);
            
        }
    }
    } 
    
  /*  if(accArSalIds.size()>0){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where TeamMemberRole = 'Area Sales Manager (ASM)' AND Accountid in :accArSalIds])
    {    
       // if(act.TeamMemberRole == 'Area Sales Manager (ASM)')
       // {
            accTeamMapSalesMng.put(act.accountId, act);
       // }
    }    
    }
    
     if(accCusEscIds.size()>0){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where TeamMemberRole = 'Customer Support Escalation' AND Accountid in :accCusEscIds])
    {    
       // if(act.TeamMemberRole == 'Customer Support Escalation')
       // {
            accTeamMapCusEsc.put(act.accountId, act);
       // }
    }    
    }
    
   
    
    if(accBusEscIds.size()>0){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where TeamMemberRole ='Customer Business Director' AND Accountid in :accBusEscIds])
    {  
       
       // if(act.TeamMemberRole == 'Customer Business Director (CBD) ')
       // {
            accTeamMapBusEsc.put(act.accountId, act);
            
       // }
    }
    }  */
    
  
    
    
 /*  if(accdelCusIds.size()>0){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where TeamMemberRole ='Customer Support Manager (CSM)'AND Accountid in :accdelCusIds])
    {
       // if(act.TeamMemberRole == 'Customer Service Manager')
      //  {
            accTeamDelMapCus.put(act.accountId, act);
       // }
    }
    }
    if(accdelBusIds.size()>0){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where TeamMemberRole ='Customer Business Manager (CBM)' AND Accountid in :accdelBusIds])
    {  
       
       // if(act.TeamMemberRole == 'Customer Business Manager (CBM)')
       // {
            accTeamDelMapBus.put(act.accountId, act);
            
       // }
    }
    } 
    if(accdelArSalIds.size()>0){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where TeamMemberRole = 'Area Sales Manager (ASM)' AND Accountid in :accdelArSalIds])
    {    
       // if(act.TeamMemberRole == 'Area Sales Manager (ASM)')
       // {
            accTeamDelMapSalesMng.put(act.accountId, act);
       // }
    }    
    }  */ 
    
   if((accdelBusIds.size()>0) || (accdelArSalIds.size()>0) || (accdelCusEscIds.size()>0) || (accdelBusEscIds.size()>0)){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where (TeamMemberRole = 'Customer Support Escalation' AND Accountid in :accdelCusEscIds) OR (TeamMemberRole ='Customer Business Director' AND Accountid in :accdelBusEscIds) OR (TeamMemberRole ='Customer Business Manager (CBM)' AND Accountid in :accdelBusIds) OR (TeamMemberRole = 'Area Sales Manager (ASM)' AND Accountid in :accdelArSalIds)])
    {    
        if(act.TeamMemberRole == 'Customer Support Escalation')
        {
            accTeamdelMapCusEsc.put(act.accountId, act);
        }
        if(act.TeamMemberRole == 'Customer Business Director')
        {
            accTeamDelMapBusEsc.put(act.accountId, act);
            
        }
       /*  if(act.TeamMemberRole == 'Customer Support Manager (CSM)')
        {
            accTeamDelMapCus.put(act.accountId, act);
        } */
        if(act.TeamMemberRole == 'Customer Business Manager (CBM)')
        {
            accTeamDelMapBus.put(act.accountId, act);
            
        }
        if(act.TeamMemberRole == 'Area Sales Manager (ASM)')
        {
            accTeamDelMapSalesMng.put(act.accountId, act);
        }
    }    
    }
    
    if(accdelCusIds.size()>0){
      for(AccountTeamMember act:[Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where (((TeamMemberRole ='Customer Support Manager (CSM)') OR (TeamMemberRole ='Customer Support Program Manager (CSPM)') OR (TeamMemberRole ='Customer Support Focal (CSM/CSPM)')) AND Accountid in :accdelCusIds)]){
          if(accTeamDelMapCus.containskey(act.accountId)){
               olddelList = accTeamDelMapCus.get(act.accountId);
               olddelList.add(act);
               accTeamDelMapCus.put(act.accountId,olddelList);
          }else{
            List<AccountTeamMember> newdelList = new List<AccountTeamMember>();
            newdelList.add(act);
            accTeamDelMapCus.put(act.accountId,newdelList);
          }
         
         
      
      }
    
    }
    
  /*  if(accdelBusEscIds.size()>0){
    for(AccountTeamMember act: [Select Id, accountId, userId, TeamMemberRole from AccountTeamMember where TeamMemberRole ='Customer Business Director' AND Accountid in :accdelBusEscIds])
    {  
       
       // if(act.TeamMemberRole == 'Customer Business Director (CBD)')
       // {
            accTeamDelMapBusEsc.put(act.accountId, act);
            
       // }
    }
    } */
        
    
    // Contact Map
    Map<String, Contact> conMapCus = new Map<String, Contact>();
    Map<String, Contact> conMapBus = new Map<String, Contact>();
    Map<String, user> userMapAreaSls = new Map<String, user>();
    Map<String, Contact> conMapCusEsc = new Map<String, Contact>();
    Map<String, Contact> conMapBusEsc = new Map<String, Contact>();
    Set<String> conNames = new Set<String>();
     if(conIdsCus.size()>0 && conIdsCus!=null){
       for(Contact co: [Select Id, email,Name, AccountId from Contact where Id IN :conIdsCus])
        {
          conMapCus.put(co.Id, co);
          if(String.isNotBlank(co.email)){
           conNames.add(co.email);
          }
        }
      }
     if(conIdsBus.size()>0 && conIdsBus!=null){
       for(Contact co: [Select Id,email, Name, AccountId from Contact where Id IN :conIdsBus])
        {
        conMapBus.put(co.Id, co);
         if(String.isNotBlank(co.email)){
          conNames.add(co.email);
         }
        }
      }
     if(userIdareasls.size()>0 && userIdareasls!=null){   
       for(User u: [Select Id,email,Name from user where id in :userIdareasls]){
        userMapAreaSls.put(u.id,u);
        if(String.isNotBlank(u.email)){
        conNames.add(u.email);
        }
       }
     }
    if(conIdsCusEsc.size()>0 && conIdsCusEsc!=null){
       for(Contact co: [Select Id, email,Name, AccountId from Contact where Id IN :conIdsCusEsc])
        {
          conMapCusEsc.put(co.Id, co);
          if(String.isNotBlank(co.email)){
           conNames.add(co.email);
          }
        }
      }
      if(conIdsBusEsc.size()>0 && conIdsBusEsc!=null){
       for(Contact co: [Select Id,email, Name, AccountId from Contact where Id IN :conIdsBusEsc])
        {
        conMapBusEsc.put(co.Id, co);
         if(String.isNotBlank(co.email)){
          conNames.add(co.email);
         }
        }
      } 
     
    // User Map
    Map<String, Id> usrMap = new Map<String, Id>();
    //for(User ur: [Select Id,Name from user where Name IN :conNames AND ])
    if(conNames.size()>0){
    for(User ur: [Select Id,Name,IsActive,email from user where email IN :conNames AND ProfileId IN (SELECT Id FROM Profile where UserLicenseId = '100300000001VfdAAE') AND IsActive = true])
    {
        usrMap.put(ur.email, ur.Id);
    }
    }
    System.debug('<<conMapCus>>'+conMapCus+'<<conMapBus>>'+conMapBus);
    System.debug('<<conNames>>'+conNames+'<<usrMap>>'+usrMap);
    // Functionality
    List<AccountTeamMember> newmembers= new List<AccountTeamMember>(); 
   
    for(Account acc: Trigger.New)
    {
       if(acc.Customer_Support_Focal__c != null){
        if(Trigger.oldMap != null){
         if(Trigger.oldMap.containskey(acc.id)){
       
        if(Trigger.oldMap.get(acc.id).Customer_Support_Focal__c != acc.Customer_Support_Focal__c )
         {
            AccountTeamMember TeammemberadCus = new AccountTeamMember();
            if(accTeamMapCus.containsKey(acc.Id))
            {
                delete accTeamMapCus.get(acc.Id);
            }
            system.debug('<<acc.Customer_Support_Focal__c>>'+acc.Customer_Support_Focal__c+'<<conMapCus.containsKey(acc.Customer_Support_Focal__c)>>'+conMapCus.containsKey(acc.Customer_Support_Focal__c));
            if(conMapCus.containsKey(acc.Customer_Support_Focal__c))
            {   
                system.debug('<<>>'+conMapCus.get(acc.Customer_Support_Focal__c)+'<<usrMap.get(conMapCus.get(acc.Customer_Support_Focal__c).Name)>>'+usrMap.containsKey(conMapCus.get(acc.Customer_Support_Focal__c).Name));
                if(usrMap.containsKey(conMapCus.get(acc.Customer_Support_Focal__c).email))
                {
                    system.debug('<<usrMap.get(conMapCus.get(acc.Customer_Support_Focal__c).Name) Inside 123>>'+usrMap.get(conMapCus.get(acc.Customer_Support_Focal__c).Name));
                    TeammemberadCus.UserId = usrMap.get(conMapCus.get(acc.Customer_Support_Focal__c).email);
                    TeammemberadCus.TeamMemberRole = 'Customer Support Focal (CSM/CSPM)';
                    TeammemberadCus.AccountId = acc.id;
                    newmembers.add(TeammemberadCus);
                }
                else
                {
                    acc.Customer_Support_Focal__c.adderror('This contact has no associated user');
                }
            }
          }
         }
        }
        
      }
      else if(acc.Customer_Support_Focal__c == null){
      
      //system.debug('customer support old'+Trigger.oldMap.get(acc.id).Customer_Support_Focal__c);
      //system.debug('customer support new'+acc.Customer_Support_Focal__c);
     if(Trigger.oldMap != null){
      if(Trigger.oldMap.containskey(acc.id)){
       if(Trigger.oldMap.get(acc.id).Customer_Support_Focal__c != null ){
          if(Trigger.oldMap.get(acc.id).Customer_Support_Focal__c != acc.Customer_Support_Focal__c){
            system.debug('entered if I');
            
            
               if(accTeamDelMapCus.containsKey(Trigger.oldMap.get(acc.id).ID))
               {
                system.debug('entered if II');
                delete accTeamDelMapCus.get(Trigger.oldMap.get(acc.id).ID);
               }
          
          }
         }
       }
      }
     }
      
     if(acc.Business_Focal__c != null){ 
       if(Trigger.oldMap != null){
        if(Trigger.oldMap.containskey(acc.id)){
        
        if(Trigger.oldMap.get(acc.id).Business_Focal__c != acc.Business_Focal__c)
        {
            AccountTeamMember TeammemberadBus = new AccountTeamMember();
            if(accTeamMapBus.containsKey(acc.Id))
            {
                delete accTeamMapBus.get(acc.Id);
            }
            system.debug('<<acc.Business_Focal__c>>'+acc.Business_Focal__c+'<<conMapBus.containsKey(acc.Business_Focal__c)>>'+conMapBus.containsKey(acc.Business_Focal__c));
            if(conMapBus.containsKey(acc.Business_Focal__c))
            {   
                system.debug('<<>>'+conMapBus.get(acc.Business_Focal__c)+'<<usrMap.containsKey(conMapBus.get(acc.Business_Focal__c).Name)>>'+usrMap.containsKey(conMapBus.get(acc.Business_Focal__c).Name));
                if(usrMap.containsKey(conMapBus.get(acc.Business_Focal__c).email))
                {
                    system.debug('<< usrMap.get(conMapBus.get(acc.Business_Focal__c).Name) Inside 123>>'+usrMap.get(conMapBus.get(acc.Business_Focal__c).Name));
                    TeammemberadBus.UserId = usrMap.get(conMapBus.get(acc.Business_Focal__c).email);
                    TeammemberadBus.TeamMemberRole = 'Customer Business Manager (CBM)';
                    TeammemberadBus.AccountId = acc.id;
                    newmembers.add(TeammemberadBus);
                }              
                else
                {
                    acc.Business_Focal__c.adderror('This contact has no associated user');
                }
            }
           }
          }  
        }
       }
       
       else if(acc.Business_Focal__c == null){
      
      //system.debug('customer support old'+Trigger.oldMap.get(acc.id).Customer_Support_Focal__c);
      //system.debug('customer support new'+acc.Customer_Support_Focal__c);
      
       if(Trigger.oldMap != null){
        if(Trigger.oldMap.containskey(acc.id)){
        if(Trigger.oldMap.get(acc.id).Business_Focal__c != null ){
          if(Trigger.oldMap.get(acc.id).Business_Focal__c != acc.Business_Focal__c){
            system.debug('entered if I');
            
            
               if(accTeamDelMapBus.containsKey(Trigger.oldMap.get(acc.id).ID))
               {
                system.debug('entered if II');
                delete accTeamDelMapBus.get(Trigger.oldMap.get(acc.id).ID);
               }
          
          }
         } 
        }
       }
      }
     
       
       if(acc.Area_Sales_Mgr__c != null){
        if(Trigger.oldMap != null){
         if(Trigger.oldMap.containskey(acc.id)){ 
        
        if(Trigger.oldMap.get(acc.id).Area_Sales_Mgr__c != acc.Area_Sales_Mgr__c)
        {
            AccountTeamMember TeammemberadBus = new AccountTeamMember();
            if(accTeamMapSalesMng.containsKey(acc.Id))
            {
                delete accTeamMapSalesMng.get(acc.Id);
            }
            if(userMapAreaSls.containsKey(acc.Area_Sales_Mgr__c))
            {   
               // system.debug('<<>>'+conMapBus.get(acc.Business_Focal__c)+'<<usrMap.containsKey(conMapBus.get(acc.Business_Focal__c).Name)>>'+usrMap.containsKey(conMapBus.get(acc.Business_Focal__c).Name));
                if(usrMap.containsKey(userMapAreaSls.get(acc.Area_Sales_Mgr__c).email))
                {
                    //system.debug('<< usrMap.get(conMapBus.get(acc.Business_Focal__c).Name) Inside 123>>'+usrMap.get(conMapBus.get(acc.Business_Focal__c).Name));
                    TeammemberadBus.UserId = usrMap.get(userMapAreaSls.get(acc.Area_Sales_Mgr__c).email);
                    TeammemberadBus.TeamMemberRole = 'Area Sales Manager (ASM)';
                    TeammemberadBus.AccountId = acc.id;
                    newmembers.add(TeammemberadBus);
                }              
                else
                {
                    acc.adderror('There is no user');
                }
            }
           }
          } 
        }
       }
        else if(acc.Area_Sales_Mgr__c == null){
      
      //system.debug('customer support old'+Trigger.oldMap.get(acc.id).Customer_Support_Focal__c);
      //system.debug('customer support new'+acc.Customer_Support_Focal__c);
        if(Trigger.oldMap != null){
          if(Trigger.oldMap.containskey(acc.id)){
           if(Trigger.oldMap.get(acc.id).Area_Sales_Mgr__c != null){
          if(Trigger.oldMap.get(acc.id).Area_Sales_Mgr__c != acc.Area_Sales_Mgr__c){
            system.debug('entered if I');
            
            
               if(accTeamDelMapSalesMng.containsKey(Trigger.oldMap.get(acc.id).ID))
               {
                system.debug('entered if II');
                delete accTeamDelMapSalesMng.get(Trigger.oldMap.get(acc.id).ID);
               }
          
          }
         }
      
       }
      } 
        
   }
   
   if(acc.Customer_Support_Escalation__c != null){
      if(Trigger.oldMap != null){
       if(Trigger.oldMap.containskey(acc.id)){
       
        if(Trigger.oldMap.get(acc.id).Customer_Support_Escalation__c != acc.Customer_Support_Escalation__c )
         {
            AccountTeamMember TeammemberadCusESC = new AccountTeamMember();
            if(accTeamMapCusEsc.containsKey(acc.Id))
            {
                delete accTeamMapCusEsc.get(acc.Id);
            }
            system.debug('<<Customer_Support_Escalation__c>>'+acc.Customer_Support_Escalation__c+'<<conMapCusEsc.containsKey(acc.Customer_Support_Escalation__c)>>'+conMapCusEsc.containsKey(acc.Customer_Support_Escalation__c));
            if(conMapCusEsc.containsKey(acc.Customer_Support_Escalation__c))
            {   
                system.debug('<<>>'+conMapCusEsc.get(acc.Customer_Support_Escalation__c)+'<<usrMap.get(conMapCusEsc.get(acc.Customer_Support_Escalation__c).Name)>>'+usrMap.containsKey(conMapCusEsc.get(acc.Customer_Support_Escalation__c).Name));
                if(usrMap.containsKey(conMapCusEsc.get(acc.Customer_Support_Escalation__c).email))
                {
                    system.debug('<<usrMap.get(conMapCusEsc.get(acc.Customer_Support_Escalation__c).Name) Inside 123>>'+usrMap.get(conMapCusEsc.get(acc.Customer_Support_Escalation__c).Name));
                    TeammemberadCusESC.UserId = usrMap.get(conMapCusEsc.get(acc.Customer_Support_Escalation__c).email);
                    TeammemberadCusESC.TeamMemberRole = 'Customer Support Escalation';
                    TeammemberadCusESC.AccountId = acc.id;
                    newmembers.add(TeammemberadCusESC);
                }
                else
                {
                    acc.Customer_Support_Escalation__c.adderror('This contact has no associated user');
                }
            }
        }
       }
       }
        
      }
      else if(acc.Customer_Support_Escalation__c == null){
      
      //system.debug('customer support old'+Trigger.oldMap.get(acc.id).Customer_Support_Escalation__c);
      //system.debug('customer support new'+acc.Customer_Support_Escalation__c);
     if(Trigger.oldMap != null){
      if(Trigger.oldMap.containskey(acc.id)){
       if(Trigger.oldMap.get(acc.id).Customer_Support_Escalation__c != null ){
          if(Trigger.oldMap.get(acc.id).Customer_Support_Escalation__c != acc.Customer_Support_Escalation__c ){
            system.debug('entered if I');
            
            
               if(accTeamDelMapCusEsc.containsKey(Trigger.oldMap.get(acc.id).ID))
               {
                system.debug('entered if II');
                delete accTeamDelMapCusEsc.get(Trigger.oldMap.get(acc.id).ID);
               }
          
          }
         }
       }
      }
     } 
   
   if(acc.Business_Escalation__c!= null){
     if(Trigger.oldMap != null){
      if(Trigger.oldMap.containskey(acc.id)){ 
        
        if(Trigger.oldMap.get(acc.id).Business_Escalation__c != acc.Business_Escalation__c)
        {
            AccountTeamMember TeammemberadBusEsc = new AccountTeamMember();
            if(accTeamMapBusEsc.containsKey(acc.Id))
            {
                delete accTeamMapBusEsc.get(acc.Id);
            }
            system.debug('<<acc.Business_Escalation__c>>'+acc.Business_Escalation__c+'<<conMapBusEsc.containsKey(acc.Business_Escalation__c)>>'+conMapBusEsc.containsKey(acc.Business_Escalation__c));
            if(conMapBusEsc.containsKey(acc.Business_Escalation__c))
            {   
                system.debug('<<>>'+conMapBusEsc.get(acc.Business_Escalation__c)+'<<usrMap.containsKey(conMapBusEsc.get(acc.Business_Escalation__c).Name)>>'+usrMap.containsKey(conMapBusEsc.get(acc.Business_Escalation__c).Name));
                if(usrMap.containsKey(conMapBusEsc.get(acc.Business_Escalation__c).email))
                {
                    system.debug('<< usrMap.get(conMapBusEsc.get(acc.Business_Escalation__c).Name) Inside 123>>'+usrMap.get(conMapBusEsc.get(acc.Business_Escalation__c).Name));
                    TeammemberadBusEsc.UserId = usrMap.get(conMapBusEsc.get(acc.Business_Escalation__c).email);
                    TeammemberadBusEsc.TeamMemberRole = 'Customer Business Director';
                    TeammemberadBusEsc.AccountId = acc.id;
                    newmembers.add(TeammemberadBusEsc);
                }              
                else
                {
                    acc.Business_Escalation__c.adderror('This contact has no associated user');
                }
            }
        }
        }
        }
       }
       
       else if(acc.Business_Escalation__c == null){
      
      //system.debug('customer support old'+Trigger.oldMap.get(acc.id).Business_Escalation__c);
      //system.debug('customer support new'+acc.Business_Escalation__c);
      
       if(Trigger.oldMap != null){
        if(Trigger.oldMap.containskey(acc.id)){
        if(Trigger.oldMap.get(acc.id).Business_Escalation__c != null ){
          if(Trigger.oldMap.get(acc.id).Business_Escalation__c != acc.Business_Escalation__c){
            system.debug('entered if I');
            
            
               if(accTeamDelMapBusEsc.containsKey(Trigger.oldMap.get(acc.id).ID))
               {
                system.debug('entered if II');
                delete accTeamDelMapBusEsc.get(Trigger.oldMap.get(acc.id).ID);
               }
          
          }
         } 
        }
       }
      } 
 }  
    if(!newmembers.isEmpty())
      insert newmembers;
     
}
}