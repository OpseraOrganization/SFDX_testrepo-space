public class REG_PortalUser_Wrapper {
    Public String accountId{get;set;}
    Public Boolean isHolding ;
    Public String contactId{get;set;}
    Public String accountName{get;set;}
    Public String firstName{get;set;}
    Public String lastName{get;set;}
    Public String addressLine1{get;set;}
    Public String addressLine2{get;set;}
    Public String addressLine3{get;set;}
    Public String addressType{get;set;}
    Public String city{get;set;}
    Public String country{get;set;}
    Public String countryCode{get;set;}
    Public Boolean isPrimary{get;set;}
    Public String postalCode{get;set;}
    Public String stateCode{get;set;}
    Public String emailId{get;set;}
    Public String companyName{get;set;}
    Public String tempEmailId{get;set;}
    Public String tempCompanyName{get;set;}
    Public String function{get;set;}
    Public String jobTitle{get;set;}
    Public String orgLevel{get;set;}
    Public String phone{get;set;}
    Public String phoneExt{get;set;}
    Public String mobile{get;set;}
    Public Boolean deactivationStatus;
    Public Boolean deletedStatus;
    Public Boolean deniedPartyStatus;
    Public Boolean emailChangeStatus;
    Public Boolean isNewUser;
    Public Boolean isBendixKingUser;
    Public Boolean isInternalUser ;
    //public list<REG_PortalHoneywellId_Wrapper> portId{get;set;}
    //public list<REG_Contact_Address_API_Wrapper> address{get;set;}
    //public String domain{get;set;}
    Public String honeywellID = '';
    Public Boolean isSuperUser;
    Public Boolean isClaimsAdmin;
    Public Boolean isContractsAdmin ;
    Public Boolean isDynamicCatalogAdmin ;
    Public Boolean isTechPubsAdmin ;
    public Boolean isRevalidationRequired;
    public string status;
    public string aircraftAccess;
    public boolean hasAccessToAssignedAircrafts;
    public boolean hasAccessToAllAircrafts;
    public boolean hasRestriction;
    
    Public REG_PortalUser_Wrapper(List<Account_Email_Domains__c> internalUser){
        if(!internalUser.isEmpty()){
            this.isInternalUser = internalUser[0].Internal_Email_Domain__c;
        }else{
            this.isInternalUser = false;
        }
        this.isNewUser = true;
        system.debug('inside REG_PortalUser_Wrapper1 ');
    }
    Public REG_PortalUser_Wrapper(contact Contacts, List<Portal_Honeywell_ID__c> porHon, List<Contact_Address__c> conAdd, List<Account_Address__c> accAdd,string domain, Boolean isRequired,List<Account_Email_Domains__c> internalUser){

        this.accountId = Contacts.AccountId;
        this.isHolding = (Contacts.AccountId !=Null && Contacts.Account.ATR_Portal_Access_Template__c == system.label.REG_IS_HOLDING_ACCOUNTID)? true : false;
        this.accountName = Contacts.Account_Name__c;
        this.contactId = Contacts.Id;
        this.firstName = Contacts.FirstName;
        this.lastName = Contacts.LastName;
        this.emailId = Contacts.Primary_Email_Address__c;
        //this.domain = (emailId != null)?emailId.substring(emailId.lastIndexOf('@') +1): null;
        this.companyName = Contacts.Portal_Company_Name__c;
        this.tempEmailId = Contacts.Portal_Temp_Primary_Email__c;
        this.tempCompanyName = Contacts.Temp_Portal_Company_Name__c;
        this.function = Contacts.Contact_Function__c;
        this.jobTitle = Contacts.Job_Title__c;
        this.orgLevel = Contacts.Organizational_Level__c;
        this.phone = convertPhoneNumbersToDisplayFormat(Contacts.Phone_1__c);
        this.phoneExt = Contacts.Phone_1_Ext__c;
        this.mobile = convertPhoneNumbersToDisplayFormat(Contacts.MobilePhone); 
        this.isSuperUser = Contacts.Is_Portal_Super_User__c;
        this.honeywellID = null;
        if(!conAdd.isEmpty()){
            this.addressLine1 = conAdd[0].Reporting_Street_Address_Line_1__c;
            this.addressLine2 = conAdd[0].Reporting_Street_Address_Line_2__c;
            this.addressLine3 = conAdd[0].Reporting_Street_Address_Line_3__c;
            this.addressType = conAdd[0].Address_Type__c;
            this.city = conAdd[0].Reporting_City_Name__c;
            this.country = conAdd[0].Reporting_Country_Name__c;
            this.countryCode = conAdd[0].Report_Country_Codes__c;
            this.isPrimary = conAdd[0].Is_Primary_Address__c;
            this.postalCode = conAdd[0].Reporting_Address_Postal_Code__c;
            this.stateCode = conAdd[0].Reporting_Address_State_Code__c;
        }
        if(!porHon.isEmpty()){
            this.deactivationStatus = (porHon[0].portal_Status__c !=Null && porHon[0].portal_Status__c == 'INACTIVE')?true: false;   
            this.deletedStatus = (porHon[0].portal_Status__c !=Null && porHon[0].portal_Status__c == 'DELETED')?true: false;
            this.emailChangeStatus = (Contacts.Portal_Temp_Primary_Email__c != Null || porHon[0].Delete_Contact_ID__c != null)?true : False;
            this.isNewUser = porHon[0].Delete_Contact_ID__c !=null ? True: False;
            this.isClaimsAdmin = porHon[0].Claims_Admin__c;
            this.isContractsAdmin = porHon[0].contracts_admin__c;
            this.isDynamicCatalogAdmin = porHon[0].Dynamic_Catalog_Admin__c;
            this.isTechPubsAdmin = porHon[0].Tech_Pubs_Admin__c;
            this.isRevalidationRequired = isRequired;
            
        }
        if(!accAdd.isEmpty()){
            if(accAdd[0].Account_Name__r.License_Valid_Date__c != null && accAdd[0].Account_Name__r.License_Valid_Date__c>= system.Today()){
                this.deniedPartyStatus = false;
            }else{
                this.deniedPartyStatus = (accAdd[0].Denied_Party_Status__c != null && accAdd[0].Denied_Party_Status__c.toUpperCase() == 'BLOCKED');
            }
        }
        else{
            this.deniedPartyStatus = false;
        }
        this.isBendixKingUser = (domain.toLowerCase() == 'bendixking.com' || Contacts.Account_Name__c == 'BENDIX KING UNIDENTIFIED PORTAL USERS')?true: false;
        if(!internalUser.isEmpty()){
            this.isInternalUser = (Contacts.Contact_Is_Employee__c == true || internalUser[0].Internal_Email_Domain__c == true)?true : false;
        }else{
            this.isInternalUser = (Contacts.Contact_Is_Employee__c == true )?true : false;
        }
    } 
    
   /*** Public REG_PortalUser_Wrapper(contact Contact, string superUserAccId, string Company){
         this.firstName = Contact.firstname;
         this.lastName = Contact.lastname;
         this.honeywellId = Contact.Honeywell_ID__c;
         this.emailId= Contact.Primary_Email_Address__c;
         this.accountName = Contact.Account_Name__c;
         if(Contact.Is_Portal_Super_User__c != null){
             isSuperUser = Contact.Is_Portal_Super_User__c;
         }
         for(portal_honeywell_id__c por: Contact.portal_honeywell_id__r){
             if(por.Name == Contact.Honeywell_ID__c){
                 this.status = !string.isBlank(por.portal_status__c )?por.portal_status__c:'Active';
             }
         }    
         
         if(contact.Account_name__c == superUserAccId){
              if(!string.isBlank(Contact.access__c)){
                  aircraftAccess  =   Contact.access__c;
              }else
              if(company == system.label.REG_user_manage_godirect_view){
                  aircraftAccess  =   system.label.REG_full_access;
              }else{
                  aircraftAccess  =   system.label.REG_assign_access;
              }
              
              if(company == system.label.REG_user_manage_godirect_view && Contact.All_Aircrafts__c == false && Contact.Assigned_Aircrafts__c== false){
                  hasAccessToAllAircrafts = true;
              }else{
                  hasAccessToAllAircrafts = Contact.All_Aircrafts__c;
              }
              
              if(Contact.Assigned_Aircrafts__c != null){
                  hasAccessToAssignedAircrafts = contact.Assigned_Aircrafts__c;
              }
              if(Contact.Has_Restriction__c != null){
                  hasRestriction = Contact.Has_Restriction__c;
              }
         }
         
     } 
     ***/
     
    Public REG_PortalUser_Wrapper(Portal_Honeywell_ID__c phi, string superUserAccId, string Company){
         this.firstName = phi.contact__r.firstname;
         this.lastName = phi.contact__r.lastname;
         this.honeywellId = phi.name;
         this.emailId= phi.contact__r.Primary_Email_Address__c;
         this.accountName = phi.contact__r.Account_Name__c;
         if(phi.contact__r.Is_Portal_Super_User__c != null){
             isSuperUser = phi.contact__r.Is_Portal_Super_User__c;
         }
        //if (!string.isBlank(phi.portal_status__c))
        //this.status = phi.portal_status__c;
        this.status = String.isNotBlank(phi.portal_status__c)?phi.portal_status__c:'Active'; 

         

         if(phi.contact__r.Account_name__c == superUserAccId){
              if(!string.isBlank(phi.contact__r.access__c)){
                  aircraftAccess  =   phi.contact__r.access__c;
              }else
              if(company == system.label.REG_user_manage_godirect_view){
                  aircraftAccess  =   system.label.REG_full_access;
              }else{
                  aircraftAccess  =   system.label.REG_assign_access;
              }
              
              if(company == system.label.REG_user_manage_godirect_view && phi.contact__r.All_Aircrafts__c == false && phi.contact__r.Assigned_Aircrafts__c== false){
                  hasAccessToAllAircrafts = true;
              }else{
                  hasAccessToAllAircrafts = phi.contact__r.All_Aircrafts__c;
              }
              
              if(Contact.Assigned_Aircrafts__c != null){
                  hasAccessToAssignedAircrafts = phi.contact__r.Assigned_Aircrafts__c;
              }
              if(Contact.Has_Restriction__c != null){
                  hasRestriction = phi.contact__r.Has_Restriction__c;
              }
         }
         
     } 
     
     
    public static String convertPhoneNumbersToDisplayFormat(String input){
        if(input!=null&& !String.isBlank(input)){ 
             if(input.contains('(') && input.contains('+1') && input.contains('-') && input.contains(' ') && input.contains(')')){
                input=input.remove('+1'); input=input.remove('('); input=input.remove('-'); input=input.remove(')');input=input.remove(' ');
                input='+1 '+input;
            }         
        }   
        return input;
        
    }      
}