trigger User_NonAdminProfiles_EditFields on User (before update) {
    List<User> users = Trigger.new;
    String prof = Userinfo.getProfileId();
    String profname = [Select name from Profile where Id=:prof].name;
    profname = profname.tolowercase();

    if((profname == 'sales admin')||(profname == 'sales analyst')||(profname == 'sales developer'))
    {
        for(Integer i=0;i<users.size();i++){         
                if(Trigger.old[i].EmployeeNumber != Trigger.new[i].EmployeeNumber 
                    || Trigger.old[i].email != Trigger.new[i].email
                    || Trigger.old[i].CommunityNickname != Trigger.new[i].CommunityNickname 
                    ||Trigger.old[i].IsActive != Trigger.new[i].IsActive 
                    || Trigger.old[i].UserPermissionsOfflineUser != Trigger.new[i].UserPermissionsOfflineUser
                    || Trigger.old[i].Citizenship_Cntry__c != Trigger.new[i].Citizenship_Cntry__c
                    || Trigger.old[i].Citizenship_Status_Descr__c != Trigger.new[i].Citizenship_Status_Descr__c
                    || Trigger.old[i].US_Permanent_Resident__c != Trigger.new[i].US_Permanent_Resident__c
                    || Trigger.old[i].US_Permanent_Resident_Card_Expiry__c != Trigger.new[i].US_Permanent_Resident_Card_Expiry__c
                    || Trigger.old[i].UserRole != Trigger.new[i].UserRole 
                    || Trigger.old[i].Profile != Trigger.new[i].Profile)     
                    
                {
                    Trigger.new[i].addError('You are not authorized to change this information');
                }
            }
    }
    else
    {
    // excluding incontact support user profile as per SCTASK3040456
        if(!(profname.contains('peoplesoft')) && !(profname.contains('admin')) && !(profname.contains('sales admin')) && !(profname.contains('incontact support user'))){
            for(Integer i=0;i<users.size();i++){
                if(
                    (Trigger.old[i].FirstName != Trigger.new[i].FirstName) ||
                    (Trigger.old[i].CurrentStatus != Trigger.new[i].CurrentStatus) || 
                    (Trigger.old[i].AboutMe != Trigger.new[i].AboutMe) ||
                    (Trigger.old[i].Street != Trigger.new[i].Street) ||
                    (Trigger.old[i].City != Trigger.new[i].City) ||       
                    (Trigger.old[i].State != Trigger.new[i].State) ||
                    (Trigger.old[i].PostalCode != Trigger.new[i].PostalCode) ||     
                    (Trigger.old[i].Country != Trigger.new[i].Country) ||            
                    (Trigger.old[i].Fax != Trigger.new[i].Fax) ||
                    (Trigger.old[i].Title != Trigger.new[i].Title) ||
                    (Trigger.old[i].LocaleSidKey != Trigger.new[i].LocaleSidKey) ||
                    (Trigger.old[i].LanguageLocaleKey != Trigger.new[i].LanguageLocaleKey)||                        
                    (Trigger.old[i].TimeZoneSidKey != Trigger.new[i].TimeZoneSidKey) || 
                    (Trigger.old[i].MobilePhone != Trigger.new[i].MobilePhone) || 
                    (Trigger.old[i].Phone != Trigger.new[i].Phone) || 
                    (Trigger.old[i].Signature1__c != Trigger.new[i].Signature1__c) ||
                    //Code Added  for SR # 393953 starts
                    (Trigger.old[i].Tier_1_Teams__c != Trigger.new[i].Tier_1_Teams__c) ||
                    (Trigger.old[i].Tier_2_Teams__c != Trigger.new[i].Tier_2_Teams__c) ||
                    (Trigger.old[i].Tier_3_Teams__c != Trigger.new[i].Tier_3_Teams__c) ||
                    (Trigger.old[i].Tier_4_Teams__c != Trigger.new[i].Tier_4_Teams__c) ||
                    (Trigger.old[i].Tier_5_Teams__c != Trigger.new[i].Tier_5_Teams__c) ||
                    //Code Added  for SR # 393953 ends
                    (Trigger.old[i].KCS_level__c != Trigger.new[i].KCS_level__c) ||
                    (Trigger.old[i].KCS_Coach__c != Trigger.new[i].KCS_Coach__c) ||
                    (Trigger.old[i].Support_Level__c != Trigger.new[i].Support_Level__c) ||                                        
                    (Trigger.old[i].Primary_Manager_Name__c != Trigger.new[i].Primary_Manager_Name__c) ||
                    (Trigger.old[i].Managers_Name__c != Trigger.new[i].Managers_Name__c) ||                    
                    (Trigger.old[i] == Trigger.new[i])
                )
                    System.Debug('Editable fields');
                else
                    Trigger.new[i].addError('You are not authorized to update any information except First Name, Address, Title, Language, Time zone, Signature, Work and Mobile phone numbers');
            }
        }
    }
}