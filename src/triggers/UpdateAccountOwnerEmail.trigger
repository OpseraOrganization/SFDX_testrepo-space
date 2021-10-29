/* Trigger to autopopulate accountowner in accountaddress object and 
   compare the ownerIds of account anf Account Address */
trigger UpdateAccountOwnerEmail on Account_Address__c (before insert, before update) 
{
    Set<ID> setConIds = new Set<ID>();
    for(Account_Address__c  obj : trigger.new)
       {
        if(obj.Account_Name__c != null)
        setConIds.add(obj.Account_Name__c);
       }
    
    MAP<ID , Account> mapCon = new MAP<ID , Account>([Select Id,OwnerId, Owner.Email from Account where id in: setConIds]);
    for(Account_Address__c obj : trigger.new)
    {
        if(obj.Account_Name__c != null && null!=mapCon.get(obj.Account_Name__c)){            
            if(null!=mapCon.get(obj.Account_Name__c).ownerid){
                obj.AccountOwner_Email__c = mapCon.get(obj.Account_Name__c).Owner.Email; //Assing AccountOwnerEmail to AccountAddressOwnerEmailFeild                           
            }    
        }                       
    }
   /* Rep Locator Project - To map Reports fields data to BGA Mob fields when Sync field is enabled */ 
    for(Account_Address__c  eachAccAdd : trigger.new)
    {
    //condition for new record insert
     if( (trigger.isinsert && eachAccAdd.Sync_from_account_address__c == TRUE) 
      
      //condition for sync check box changes 
      || (trigger.isupdate && Trigger.oldMap.get(eachAccAdd.id).Sync_from_account_address__c != Trigger.newMap.get(eachAccAdd.id).Sync_from_account_address__c
       && eachAccAdd.Sync_from_account_address__c == TRUE) 
       
       //condition for address field changes
      ||(trigger.isupdate && eachAccAdd.Sync_from_account_address__c == TRUE && 
      ( Trigger.oldMap.get(eachAccAdd.id).Report_Address_Line_1__c != Trigger.newMap.get(eachAccAdd.id).Report_Address_Line_1__c 
      || Trigger.oldMap.get(eachAccAdd.id).Report_Address_Line_2__c != Trigger.newMap.get(eachAccAdd.id).Report_Address_Line_2__c  
      || Trigger.oldMap.get(eachAccAdd.id).Report_Address_Line_3__c != Trigger.newMap.get(eachAccAdd.id).Report_Address_Line_3__c 
      || Trigger.oldMap.get(eachAccAdd.id).Report_City_Name__c != Trigger.newMap.get(eachAccAdd.id).Report_City_Name__c 
      || Trigger.oldMap.get(eachAccAdd.id).Report_State_Name__c != Trigger.newMap.get(eachAccAdd.id).Report_State_Name__c 
      || Trigger.oldMap.get(eachAccAdd.id).Report_Postal_Code__c != Trigger.newMap.get(eachAccAdd.id).Report_Postal_Code__c 
      || Trigger.oldMap.get(eachAccAdd.id).Report_Country_Name__c != Trigger.newMap.get(eachAccAdd.id).Report_Country_Name__c)))
      {
      // if(mapCon.containsKey(eachAccAdd.Account_Name__c))
         eachAccAdd.BGAMob_Address_1__c = eachAccAdd.Report_Address_Line_1__c;
         eachAccAdd.BGAMob_Address_2__c = eachAccAdd.Report_Address_Line_2__c;
         eachAccAdd.BGAMob_Address_3__c = eachAccAdd.Report_Address_Line_3__c;
         eachAccAdd.BGAMob_City_Name__c = eachAccAdd.Report_City_Name__c;
         eachAccAdd.BGAMob_State_Province__c = eachAccAdd.Report_State_Code__c;
         eachAccAdd.BGAMob_Postal_Code__c = eachAccAdd.Report_Postal_Code__c;
         eachAccAdd.BGAMob_Country_Nm__c = eachAccAdd.Report_Country_Name__c;
        
      }
    }
    
}