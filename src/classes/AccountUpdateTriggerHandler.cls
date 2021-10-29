public with sharing class AccountUpdateTriggerHandler {  

   /************************************************************************************************************************
   * Purpose: Populate Customer & Business focal escalation field values in AccFocal Object, precedeSoldToValues with Zero, Declare AccountFocaldefault value
   *************************************************************************************************************************/
    public static void beforeActions(List<Account_Focal__c> accFocList){
        //Start: Customer and Business focal and escalation values : In AccFocal Object
        Set<Id> ContactIdSet = new Set<Id>();
        Map<Id,Id> EscalationManagerMap = new Map<Id,Id>();
        for (Account_Focal__c  eachAcccFocal: accFocList)
        {         
            if(eachAcccFocal.Customer_Support_Focal__c != null){
                ContactIdSet.add(eachAcccFocal.Customer_Support_Focal__c);
            }
            if(eachAcccFocal.BusinessFocal__c != null){
                ContactIdSet.add(eachAcccFocal.BusinessFocal__c);
            }  
        }
        for(Contact con : [SELECT Id, Name,Employee_Manager_Name__c FROM Contact WHERE Id IN : ContactIdSet])
        {
            if(con.Employee_Manager_Name__c != null){
                EscalationManagerMap.put(con.Id,con.Employee_Manager_Name__c);
            }    
        } 
        for(Account_Focal__c  eachAcccFocal: accFocList)
        {         
            if(EscalationManagerMap.containsKey(eachAcccFocal.Customer_Support_Focal__c)){
                eachAcccFocal.Customer_Support_Escalation__c = EscalationManagerMap.get(eachAcccFocal.Customer_Support_Focal__c);
            }
            if(EscalationManagerMap.containsKey(eachAcccFocal.BusinessFocal__c)){
                eachAcccFocal.Business_Escalation__c = EscalationManagerMap.get(eachAcccFocal.BusinessFocal__c);
            }
            //Start: precedeSoldToValues 
            if(eachAcccFocal.Sold_To__c  != NULL && eachAcccFocal.Sold_To__c.length() < 10 )
            {
                Integer i = eachAcccFocal.Sold_To__c.length();
                i = 10 - i;
                String temp ='';
                for (Integer j = 0; j < i; j++ )
                {
                    temp += '0';
                }
                eachAcccFocal.Sold_To__c = temp+eachAcccFocal.Sold_To__c;
                system.debug('##Temp'+temp);
            }
            //End: precedeSoldToValues 
            
            //Start: Declare AccountFocaldefault section
            if(!bundle_checkRecursive.isStopRecursion)
            {
                  eachAcccFocal.Default__c = true;
            }
           //End: Declare AccountFocaldefault section
        }
        //End: Customer and Business focal and escalation values : In AccFocal Object
    }
   /************************************************************************************************************************
   * Purpose: Enable only one AccountFocaldefault record per Account
   *************************************************************************************************************************/
    public static void makeAccountFocaldefault(List<Account_Focal__c> afList){        
        Set<Id> AccountFocalId = new Set<Id>();
        List<Id> AccountIds = new List<Id>();
        for(Account_Focal__c afocal : afList)
        {           
            AccountFocalId.add(afocal.id);
            AccountIds.add(afocal.Account__c);
        }       
        List<Account_Focal__c> acctFocalList = new List<Account_Focal__c>();
        for(Account_Focal__c  acc : [SELECT id,default__c,Sold_To__c FROM Account_Focal__c WHERE Account__c In :AccountIds AND ID NOT IN:AccountFocalId AND Default__c =true ])
        {
            Account_Focal__c AFLog = acc;
            AFLog.Default__c = false;
            acctFocalList.add(acc);
        }           
        bundle_checkRecursive.isStopRecursion =true;
        update acctFocalList;   
        bundle_checkRecursive.isStopRecursion =false;
    }
   /************************************************************************************************************************
   * Purpose: Populate Focal & Escalation field values in Account Object
   *************************************************************************************************************************/
    public static void AccountEscalation(List<Account_Focal__c> aFocalList){
        List<Id> AccountFocalIdSet = new List<Id>();
        for(Account_Focal__c afc : aFocalList){
            AccountFocalIdSet.add(afc.Account__c);
        }       
        Map<id,Account> afAccMap = new Map<id, Account>([select id,name,
                                                         (SELECT Id,Name,Account__c,Account__r.id,
                                                          Customer_Support_Focal__c,Account__r.Customer_Support_Focal__c,
                                                          BusinessFocal__c,Account__r.Business_Focal__c ,
                                                          Customer_Support_Escalation__c,Account__r.Customer_Support_Escalation__c,
                                                          Business_Escalation__c,Account__r.Business_Escalation__c,
                                                          Default__c FROM Account_Focals_del__r),
                                                         Customer_Support_Focal__c ,Business_Focal__c,
                                                         Customer_Support_Escalation__c, Business_Escalation__c 
                                                         FROM Account where id IN: AccountFocalIdSet]);
        Account UpdateAccount = new Account();                                  
        for(Account_Focal__c afc : aFocalList){
            system.debug('afc.Customer_Support_Focal__c'+afc.Customer_Support_Focal__c);
            system.debug('afc.Default__c'+afc.Default__c);
            UpdateAccount = afAccMap.get(afc.Account__c);
            if((afc.Customer_Support_Focal__c != null) && (afc.Default__c == true))
            {
                system.debug('inside customer'+afc.Customer_Support_Focal__c);
                if(afAccMap.containsKey(afc.Account__c))
                {                   
                    UpdateAccount.Customer_Support_Focal__c = afc.Customer_Support_Focal__c;
                    UpdateAccount.Customer_Support_Escalation__c = afc.Customer_Support_Escalation__c;
                } 
            }
            if((afc.BusinessFocal__c != null) && (afc.Default__c == true)){
                if(afAccMap.containsKey(afc.Account__c))
                {
                    UpdateAccount.Business_Focal__c = afc.BusinessFocal__c;
                    UpdateAccount.Business_Escalation__c = afc.Business_Escalation__c;
                } 
            }
           update afAccMap.values();
        }
        update UpdateAccount;
    }
   /************************************************************************************************************************
   * Purpose:  AddAccountTeamMember in Account Object without duplicates when default is true
   *************************************************************************************************************************/
    public static void AddAccountTeamMember(List<Account_Focal__c> aFocList){
        Account_Focal__c  singleaccfocal1 = new Account_Focal__c();
        Map<String,AccountTeamMember> RoleMap = new Map<String,AccountTeamMember>();
        List<AccountTeamMember> accteamList = new List<AccountTeamMember>();
        List<AccountTeamMember> oldAccteamList = new List<AccountTeamMember>();
        Set<Id> acctIdSet = new Set<Id>();
        for(Account_Focal__c singleaccfocal : aFocList){
            acctIdSet.add(singleaccfocal.Account__c);
        }
        
        for(AccountTeamMember atm : [SELECT AccountId, UserId, TeamMemberRole FROM AccountTeamMember Where AccountId =: acctIdSet ]) {
            if(atm.TeamMemberRole == 'Customer Support Manager (CSM)'){                   
                RoleMap.put(atm.TeamMemberRole,atm);
            }
            if(atm.TeamMemberRole == 'Customer Service Project Manager (CSPM)'){                   
                RoleMap.put(atm.TeamMemberRole,atm);
            }
            if(atm.TeamMemberRole == 'Customer Business Manager (CBM)'){                   
                RoleMap.put(atm.TeamMemberRole,atm);
            }
            if(atm.TeamMemberRole == 'Area Sales Manager (ASM)'){                   
                RoleMap.put(atm.TeamMemberRole,atm);
            }
        }
        System.debug('@@@RoleMap'+RoleMap);
        for(Account_Focal__c singleaccfocal : aFocList){
            
            if(singleaccfocal.Customer_Support_Manager_CSM__c != NULL)
            {
                AccountTeamMember aT = new AccountTeamMember();
                if(RoleMap.get('Customer Support Manager (CSM)') !=null)
                {
                    oldAccteamList.add(RoleMap.get('Customer Support Manager (CSM)'));                       
                }                    
                aT.UserId = singleaccfocal.Customer_Support_Manager_CSM__c ;
                aT.AccountId = singleaccfocal.Account__c;
                aT.TeamMemberRole = 'Customer Support Manager (CSM)';                    
                accteamList.add(aT); 
            }
            if(singleaccfocal.Customer_Support_Project_Manager_CSPM__c != NULL)
            {
                AccountTeamMember aT = new AccountTeamMember();
                if(RoleMap.get('Customer Service Project Manager (CSPM)') !=null)
                {
                    oldAccteamList.add(RoleMap.get('Customer Service Project Manager (CSPM)'));                       
                }                    
                aT.UserId = singleaccfocal.Customer_Support_Project_Manager_CSPM__c;
                aT.AccountId = singleaccfocal.Account__c;
                aT.TeamMemberRole = 'Customer Service Project Manager (CSPM)';                    
                accteamList.add(aT); 
            }
            
            if(singleaccfocal.Customer_Business_Manager_CBM__c != NULL)
            {
                AccountTeamMember aT = new AccountTeamMember();
                if(RoleMap.get('Customer Business Manager (CBM)') !=null) {
                    oldAccteamList.add(RoleMap.get('Customer Business Manager (CBM)'));                    
                }                
                aT.UserId = singleaccfocal.Customer_Business_Manager_CBM__c;
                aT.AccountId = singleaccfocal.Account__c;
                aT.TeamMemberRole = 'Customer Business Manager (CBM)';                
                accteamList.add(aT); 
            }
            if(singleaccfocal.Area_Sales_Manager_ASM__c != NULL)
            {
                AccountTeamMember aT = new AccountTeamMember();
                if(RoleMap.get('Area Sales Manager (ASM)') !=null) {
                    oldAccteamList.add(RoleMap.get('Area Sales Manager (ASM)'));                       
                }                    
                aT.UserId = singleaccfocal.Area_Sales_Manager_ASM__c;
                aT.AccountId = singleaccfocal.Account__c;
                aT.TeamMemberRole = 'Area Sales Manager (ASM)';                  
                accteamList.add(aT); 
            }                
        }
        delete oldAccteamList;
        insert accteamList;
    }
}