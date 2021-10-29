/** * File Name: REG_PortalContact_Service

* Description  Get the status of tools for honeywell Id

* * @author : TCS 

Date 01/18/2019 

* */

public with sharing class REG_PortalContact_Service{
    
    /*To get contact details from honeywell id */
    public static REG_Result getContactforHid(string honId){
        REG_Result result = new REG_Result();
        if(string.isBlank(honId)){
            return null;
        }
        List<Portal_Honeywell_ID__c > contactPortalList1 = new List<Portal_Honeywell_ID__c >();
        contactPortalList1 = [SELECT Contact__c,Contact__r.AccountId, Contact_Status__c, Name,Portal_Status__c  FROM Portal_Honeywell_ID__c WHERE Name =: honId AND Portal_Status__c != 'InActive' AND Portal_Status__c != 'Deleted'];
        
        If(contactPortalList1.isEmpty() ){
            result.handleError(400, 'Bad Data', 'HID is either InActive or Deleted.'); 
        }
        
        else{
            result.Data = contactPortalList1;
        }
        return result;
    }   
    
    
    
    
    /*To get contact id from honeywell id */
    public static Id getContact(string honId){
        if(string.isBlank(honId)){
            return null;
        }
        List<Portal_Honeywell_ID__c > contactPortalList = new List<Portal_Honeywell_ID__c >();
        // List<Contact> contactList = new List<Contact>();
        contactPortalList = [SELECT Contact__c,Contact__r.AccountId  FROM Portal_Honeywell_ID__c WHERE Name =: honId AND Portal_Status__c != 'Inactive' AND Portal_Status__c != 'Deleted'];
        string contactId; 
        If(!contactPortalList.isEmpty() ){
            
            return contactPortalList[0].Contact__c ;
            
        }else{
            /*contactList = [SELECT Id,AccountId FROM Contact WHERE Honeywell_ID__c =: honId AND Contact_Status__c != 'InActive'];
if(contactList.size() > 0){
return contactList[0].Id;
}else{
return null;
} */    
            return null;
        }
        
    } //end of getContact method 
    
    /* Method to get Contact Details for given honeywell ID*/ 
    public static REG_Result getContactDetail(String h_Id){
        REG_Result result = new REG_Result();
        string contactID = '';
        if(string.isNotEmpty(h_Id)){
            try{
                contactID = getContact(h_Id);
                if(String.isNotEmpty(contactID)){
                    list<contact> contactList = [SELECT Honeywell_ID__c,Account.Name, Account.Id, contact_status__c, alternate_email_address__c, attention__c, birth_city__c, birthdate, citizenship_country__c, contact_birth_country__c, contact_function__c, fax, firstname, id, is_portal_super_user__c, is_us_citizen__c, job_title__c, lastname, market__c, middle_name__c, middle_name_not_available__c, mobilephone, name, permanent_resident_expiration_date__c, permanent_usa_resident__c, phone_1__c, phone_1_ext__c, primary_email_address__c, product_updates__c, Portal_Company_Name__c, salutation, suffix__c, organizational_level__c, account.ATR_Portal_Access_Template__c, Employee_Number__c,Account.Sbl_Account_Row_Id__c,
                                                 (SELECT Id,Name,Contact__c,Portal_Last_Accessed_Date__c,Portal_Status__c,Primary_Honeywell_ID__c,User_Type__c,Claims_Admin__c,contracts_admin__c,Dynamic_Catalog_Admin__c,Tech_Pubs_Admin__c from Portal_Honeywell_ID__r WHERE Name = :h_Id),
                                                 (SELECT Id,Address_Type__c,Report_Country_Codes__c,Reporting_Address_Postal_Code__c,Reporting_Address_State_Code__c,Reporting_City_Name__c,Reporting_Country_Name__c,Reporting_Street_Address_Line_1__c,Reporting_Street_Address_Line_2__c,Reporting_Street_Address_Line_3__c,Is_Primary_Address__c FROM Contact_Addresses__r WHERE Is_Primary_Address__c = true AND Address_Status__c = 'Active'),
                                                 (SELECT Id,Portal_Honeywell_ID__c,Portal_Tool_Master__c,Portal_Tool_Master__r.Name,Request_Date__c,Request_Status__c,last_logged_in__c from Contact_Tool_Access__r WHERE Portal_Honeywell_ID__c = :h_Id),
                                                 (SELECT Id,Name,Contact_Status__c,SAP_Account_Sold_To__c,SoldtoToolAccess__c from SAP_Contact_Sold_To__r),
                                                 (SELECT Id,Aircraft_Contract_Num__c,Aircraft_Engine_Serial__c,Aircraft_Make__c,Aircraft_Model__c,Aircraft_Serial_Number__c,Aircraft_Tail_Number__c,Name from Account_Aircraft__r),
                                                 (SELECT Id,Account_Name__c,Account_Name__r.Name from Account_Contacts1__r),
                                                 (SELECT Id,Aircraft_Make__c,Aircraft_Model__c,Fleet_Asset_Aircraft_Name__c,Name,Serial_Number__c,Tail_Number__c from User_Aircraft_Associations__r),
                                                 (SELECT Id,Master_Service_Program_Name__c,Name,Restricted_Service_Program_Name__c from Restricted_Service_Programs__r) FROM contact WHERE Contact_Status__c != 'InActive' and Id  = :contactID];
                    for(contact c:contactList){
                        if(String.isNotBlank(c.mobilephone)){
                            c.mobilephone= convertPhoneNumbersToDisplayFormat(c.mobilephone);
                        }
                        if(String.isNotBlank(c.phone_1__c)){
                            c.phone_1__c= convertPhoneNumbersToDisplayFormat(c.phone_1__c);
                        }
                        /* if(String.isNotBlank(c.phone_5__c)){
c.phone_5__c= convertPhoneNumbersToDisplayFormat(c.phone_5__c);
}*/
                    } 
                    
                    result.Data = contactList; 
                }else{
                    result.handleError(404,'Contact details not found for the given honeywell id','Please provide a valid honeywell id.');
                }
            }catch(exception e){
                result.handleException(500, e.getMessage(), e);
            }
        }
        return result;
        
    }//end of getContactDetail method
    
    /*Method to get Contact details by given Email ID*/
    public static REG_Result getContactByEmail(String email_ID){
        REG_Result result = new REG_Result();
        List<REG_Contact_Match_Wrapper> conMatchWrapList = new List<REG_Contact_Match_Wrapper>();
        list<account> accAddress = new list<account>();
        try{
            if(String.isNotBlank(email_ID)){
                List<contact> contactInfo = [select Honeywell_ID__c,portal_company_name__c,Contact_Is_Employee__c,Account.Name,Account.Id,Account.Sbl_Account_Row_Id__c,contact_status__c, alternate_email_address__c, attention__c, birth_city__c, birthdate, citizenship_country__c,contact_birth_country__c, contact_function__c, email, fax, firstname, id, is_portal_super_user__c, is_us_citizen__c, job_title__c, lastname, market__c, middle_name__c, middle_name_not_available__c, mobilephone, name, permanent_resident_expiration_date__c, permanent_usa_resident__c, phone_1__c, phone_1_ext__c, primary_email_address__c, product_updates__c, salutation, state_code__c, suffix__c, organizational_level__c, account.ATR_Portal_Access_Template__c,Employee_Number__c,
                                             (SELECT Id,Address_Type__c,Report_Country_Codes__c,Reporting_Address_Postal_Code__c,Reporting_Address_State_Code__c,Reporting_City_Name__c,Reporting_Country_Name__c,Reporting_Street_Address_Line_1__c,Reporting_Street_Address_Line_2__c,Reporting_Street_Address_Line_3__c,Is_Primary_Address__c FROM Contact_Addresses__r WHERE Is_Primary_Address__c = true AND Address_Status__c = 'Active') 
                                             from contact where Contact_Status__c != 'InActive' and account.Customer_Status__c = 'active' and email  = :email_ID];
               system.debug('contactInfo'+contactInfo);                   
                if(!contactInfo.IsEmpty()){
                    system.debug('contactInfo[0].Contact_Addresses__r.size()'+contactInfo[0].Contact_Addresses__r.size());
                    system.debug('contactInfo[0].Contact_Is_Employee__c'+contactInfo[0].Contact_Is_Employee__c);
                    if(contactInfo[0].Contact_Addresses__r.size()<1 && contactInfo[0].Contact_Is_Employee__c == true){
                        accAddress = [select (select Id,Address_Type__c,Report_Country_Codes__c,Report_Postal_Code__c,Report_State_Code__c,Report_City_Name__c,Report_Country_Name__c,Report_Address_Line_1__c,Report_Address_Line_2__c,Report_Address_Line_3__c,Is_Primary_Address__c from Account_Address__r where Is_Primary_Address__c = true AND Address_Status__c = 'Active') from account where Id = :contactInfo[0].Account.Id];
                        system.debug('accAddress ' +accAddress);
                        system.debug('contactInfo[0].Account.Id ' +contactInfo[0].Account.Id);
                    }
                    for(contact c:contactInfo){
                        if(String.isNotBlank(c.mobilephone)){
                            c.mobilephone= convertPhoneNumbersToDisplayFormat(c.mobilephone);
                        }
                        if(String.isNotBlank(c.phone_1__c)){
                            c.phone_1__c= convertPhoneNumbersToDisplayFormat(c.phone_1__c);
                        }
                        /* if(String.isNotBlank(c.phone_5__c)){
c.phone_5__c= convertPhoneNumbersToDisplayFormat(c.phone_5__c);
}*/                      
   if(contactInfo[0].Contact_Addresses__r.size()==1){
    REG_Contact_Match_Wrapper conMatchWrap = new REG_Contact_Match_Wrapper(c);  
    conMatchWrapList.add(conMatchWrap);
    
}else if(contactInfo[0].Contact_Addresses__r.size()<1 && contactInfo[0].Contact_Is_Employee__c == false){
    REG_Contact_Match_Wrapper conMatchWrap = new REG_Contact_Match_Wrapper(c);  
    conMatchWrapList.add(conMatchWrap);
    
}else if(contactInfo[0].Contact_Addresses__r.size()<1 && accAddress[0].Account_Address__r.size()>0 && contactInfo[0].Contact_Is_Employee__c == true){
    conMatchWrapList.add(new REG_Contact_Match_Wrapper(c,accAddress));
    
}else{
    result.handleError(422, 'Bad data', 'Contact/Account address not found');
    return result;
}
                    }                 
                    system.debug(logginglevel.info,'atr' +contactInfo[0].account.ATR_Portal_Access_Template__c);
                    //contactMatchWrapper conMatchWrap = new contactMatchWrapper(contactInfo[0].account.ATR_Portal_Access_Template__c, contactInfo);
                    result.Data = conMatchWrapList;
                }else{
                    result.handleError(404 ,'Contact details not found for the given email id','Please provide a valid email id.');
                }
                
            }else{
                result.handleError(400,'Please provide email id.','Param : email id is not provided.');
            }
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
            
        }
        return result; 
    }//end of getContactByEmail method
    
    /*Method to fetch all sold to by given Honeywell ID*/
    public static REG_Result getContactSoldTo(String hon_ID){
        REG_Result result = new REG_Result();
        String contact_ID = '';
        //String SAPAccountSoldTo = '';
        String emailDomain = '';
        boolean selected = false;
        contact_ID = REG_PortalContact_Service.getContact(hon_ID);
        system.debug('contact_ID***'+contact_ID);
        System.debug(LoggingLevel.Info, 'contact_ID***'+contact_ID);
        if(string.isBlank(contact_ID)){
            //throw new stringException('No contact found for given Honeywell Id');
            result.handleError(404, 'Contact details not found for the given honeywell id', 'Please provide a valid honeywell id.');
            return result;
        }
        list<Id> AccountID = new list<Id>();
        list<REG_AccountCrossRef_API_Wrapper> allSoldToWrapperList = new list<REG_AccountCrossRef_API_Wrapper>();
        list<String> soldToToolAccess = new list<String>();
        Map<string,List<string>> soldToToolConMap = new Map<string,List<string>>();
        try{
            if(String.isNotEmpty(contact_ID)){
                list<contact> contactInfo = [SELECT Primary_Email_Address__c,AccountId,
                                             (SELECT SAP_Account_Sold_To__c,SoldtoToolAccess__c from SAP_Contact_Sold_To__r) 
                                             from Contact WHERE Id = :contact_ID];
                System.debug(LoggingLevel.Info, 'contactinfo***'+contactInfo );                          
                if(!contactInfo.IsEmpty()){
                    AccountID.add(contactInfo[0].AccountId);
                    emailDomain = contactInfo[0].Primary_Email_Address__c;
                    String domain = emailDomain.substring(emailDomain.lastIndexOf('@') +1);
                    System.debug(LoggingLevel.Info, 'domain ***'+domain);  
                    list<String> soldToDoList = new list<String>();
                    String selectValue = 'N';
                    for (SAP_Contact_Sold_To__c soldToAccount: contactInfo[0].SAP_Contact_Sold_To__r){
                        soldToDoList.add(soldToAccount.SAP_Account_Sold_To__c);
                        if(soldToToolConMap.containsKey(soldToAccount.SAP_Account_Sold_To__c)){
                            List<string> soldToToolAccessLst = soldToToolConMap.get(soldToAccount.SAP_Account_Sold_To__c);
                            soldToToolAccessLst.add(soldToAccount.SoldtoToolAccess__c);
                            soldToToolConMap.put(soldToAccount.SAP_Account_Sold_To__c, soldToToolAccessLst );                        
                        }else{
                            soldToToolConMap.put(soldToAccount.SAP_Account_Sold_To__c,new List<string> { soldToAccount.SoldtoToolAccess__c });
                        }
                        // selectValue = 'Y';
                    }
                    system.debug('*****soldToDoList'+soldToDoList);
                    System.debug(LoggingLevel.Info, 'soldToDoList***'+soldToDoList);  
                    //System.debug(LoggingLevel.Info, 'soldToToolAcc1***'+soldToToolAcc1);
                    //to fetch account ID
                    list<account_cross_ref__c> crossRef = [select sbl_account_row_id__c, account_name__c, account_name__r.type, account_name__r.id,account_name__r.market_name__c,account_name__r.name, account_status__c, account_type__c, external_account_id__c, external_account_name__c, external_address_line_1__c, external_address_line_2__c, external_address_line_3__c, external_city_name__c,external_country_code__c, external_country_name__c, external_postal_code__c, external_state_code__c, id, name,xref_name__c, xref_type__c from account_cross_ref__c where (not external_account_name__c like '%do not use%') 
                                                           and (not external_account_name__c like '%reference account%') 
                                                           and (not external_account_name__c like '%various%') 
                                                           and (not account_name__r.name like '%various%') 
                                                           and (account_status__c = 'active') and external_account_id__c in :soldToDoList 
                                                           and account_name__r.name not in ('HONEYWELL UNIDENTIFIED PORTAL USERS','Bendix King UNIDENTIFIED PORTAL USERS','Honeywell Default Account','NO ACCOUNT FOUND','FSR TEMPORARY OPERATOR','Portal Missing Users (Do not use)') and xref_type__c='SAP_SOLD_TO'];
                    system.debug('*****crossRef '+crossRef );     
                    for(account_cross_ref__c accountCrossRef : crossRef){
                        AccountID.add(accountCrossRef.account_name__c);
                    }
                    
                    list<Account_Contact__c> accountContact = [SELECT Contact__r.accountid,Account_Name__c FROM Account_Contact__c WHERE Contact__c = :contact_ID];
                    system.debug('*****accountContact '+accountContact );
                    for(Account_Contact__c accountContactList : accountContact){
                        AccountID.add(accountContactList.Account_Name__c);
                    }
                    
                    list<Account> accountActiveDomainList = [SELECT Id FROM Account where Customer_Status__c = 'Active' and Id in (SELECT Account__c FROM Account_Email_Domains__c WHERE Account_Email_Domain__c = :domain)];
                    system.debug('*****accountActiveDomainList '+accountActiveDomainList );
                    for(Account acc : accountActiveDomainList){
                        AccountID.add(acc.Id);
                    }
                    system.debug('*****AccountID'+AccountID);
                    set<account_cross_ref__c> allSoldTo = new Set<account_cross_ref__c>([ select sbl_account_row_id__c, account_name__c, account_name__r.type, account_name__r.id,account_name__r.market_name__c,  account_name__r.name, account_status__c, account_type__c, external_account_id__c,external_account_name__c, external_address_line_1__c, external_address_line_2__c,external_address_line_3__c, external_city_name__c, external_country_code__c, external_country_name__c, external_postal_code__c, external_state_code__c, id, name, xref_name__c, xref_type__c from account_cross_ref__c where account_status__c='active' and (not external_account_name__c like '%do not use%') and (not external_account_name__c like '%reference account%')and (not external_account_name__c like '%various%') and (not account_name__r.name like '%various%') and (not external_account_id__c like '%-02')  and xref_type__c = 'SAP_SOLD_TO' and account_name__c in :AccountID]);
                    system.debug('*****allSoldTo '+allSoldTo );
                    System.debug(LoggingLevel.Info, 'allSoldTo ***'+allSoldTo );  
                    list<String> extAccId = new list<String>();
                    for(account_cross_ref__c accRef : allSoldTo){
                        extAccId.add(accRef.external_account_id__c);
                    }
                    System.debug(LoggingLevel.Info, 'extAccId ***'+extAccId);
                    list<SAP_Contact_Sold_To__c> soldToToolAcc = [select SoldtoToolAccess__c from SAP_Contact_Sold_To__c WHERE SAP_Account_Sold_To__c IN :extAccId];
                    System.debug(LoggingLevel.Info, 'soldToToolAcc ***'+soldToToolAcc);
                    for(SAP_Contact_Sold_To__c soldTo : soldToToolAcc){
                        soldToToolAccess.add(soldTo.SoldtoToolAccess__c);
                    }
                    
                    
                    if(!allSoldTo.IsEmpty()){
                        for(account_cross_ref__c accRef : allSoldTo){
                            system.debug('accRef.external_account_id__c' +accRef.external_account_id__c);
                            if(!soldToDoList.contains(accRef.external_account_id__c)){
                                
                                list<String> soldToolAcc = new list<String>();
                                allSoldToWrapperList.add(new REG_AccountCrossRef_API_Wrapper(accRef, contact_ID,selectValue='N',soldToolAcc ));
                                
                            }
                            else{
                                allSoldToWrapperList.add(new REG_AccountCrossRef_API_Wrapper(accRef, contact_ID,selectValue='Y',soldToToolConMap.get(accRef.external_account_id__c)));
                            }
                            
                            
                            //System.debug(LoggingLevel.Info, 'external_account_id__c***'+accRef.external_account_id__c);  
                            //  allSoldToWrapperList.add(new REG_AccountCrossRef_API_Wrapper(accRef, contact_ID,selectValue ));
                            //selected = true;
                        }
                        result.Data = allSoldToWrapperList;//allSoldTo;
                    }else{
                        //changed by saurabh for SCTASK3076927 to avoid getting error code 400 
                         result.Data = new list<REG_AccountCrossRef_API_Wrapper>();
                        //result.handleError(400, 'No Details found for given Honeywell ID..:'+hon_ID, 'Provide valid honeywell ID to fetch data');
                        //end of SCTASK3076927  
                    } 
                }
            }else{
                result.handleError(400,'No data found.','Provide contact ID do not contain specific data..!');
            }
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
        }
        return result;
    }//end of getContactSoldTo method
    
    //method for revalidate API
    
    public static REG_Result revalidate(String honId , String incCount){
        system.debug('incCount***' +incCount);
        REG_Result result = new REG_Result();
        list<Portal_Honeywell_ID__c> portHonId = new list<Portal_Honeywell_ID__c>();
        list<string> recordId = new list<string>();
        String portalStatus;
        Decimal emailCount;
        try{
            if(String.isNotBlank(honId)){
                /* String conId = REG_PortalContact_Service.getContact(honId);
system.Debug('conId**********' +conId);
if(conId == null){
result.handleError(404, 'No data found', 'No details found for given honeywell ID');
return result;
}
system.debug('honeywellId ' +honId);*/
                list<Portal_Honeywell_ID__c> portDetails = [SELECT Id,Name,Email_Sent_Counter__c,Portal_Status__c,contact__r.Contact_Status__C FROM Portal_Honeywell_ID__c where Name = :honId];
                //system.debug('Before update ' +portDetails[0].contact__r.Contact_Status__C);
                if(portDetails.isEmpty()){
                    result.handleError(400, 'No data found', 'No record found for HID: '+ honId  );
                    return result;
                }else if(portDetails[0].contact__r.Contact_Status__C == 'Inactive'){
                    result.handleError(400, 'Contact status is Inactive', 'Revalidation/IncrementCounter operation can not performed on Inactive contact status');
                    return result;
                }
                else{   
                    
                    portalStatus = portDetails[0].Portal_Status__c;
                    emailCount = portDetails[0].Email_Sent_Counter__c;
                    /* if(portalStatus == 'Active'){
result.handleError(400, 'User status is already Active', 'Revalidation/increment email counter is not required');
return result;
}  */                  
                    system.debug('portalStatus***' +portalStatus);
                    system.debug('incCount***' +incCount);
                    
                    if(incCount == 'y'){
                        if(portalStatus == 'InActive'){
                            for (Portal_Honeywell_ID__c portalHoneywellId1 : portDetails){
                                // portalHoneywellId1.Email_Sent_Counter__c = portalHoneywellId1.Email_Sent_Counter__c +1;
                                
                                portalHoneywellId1.Email_Sent_Counter__c = portalHoneywellId1.Email_Sent_Counter__c != null?portalHoneywellId1.Email_Sent_Counter__c +1:1;
                                
                                portHonId.add(portalHoneywellId1);
                                recordId.add(portalHoneywellId1.Id);
                            }
                            if(!portDetails.isEmpty()){
                                update portHonId;
                                system.debug('after update counter****' +portHonId);
                                result.resourceId = recordId[0];
                                result.status = 'successfully updated email sent counter for provided honeywell Id';
                                return result;
                            }
                        }else if(portalStatus == 'Active' || portalStatus == null ){
                            result.handleError(400, 'User status is already Active', 'It is not required to increment the email counter');
                            return result;
                            
                        }else if(portalStatus == 'Deleted'){
                            result.handleError(400, 'User status is Deleted', 'It is not required to the increment email counter');
                            return result;
                            
                        }
                    }
                }
                if(portalStatus == 'Deleted'){
                    result.handleError(400, 'User status is Deleted', 'Revalidation is not required');
                    return result;
                }
                if(emailCount == null || emailCount == 0){
                    result.handleError(400, 'Revalidation is not required', 'User is Active, No revalidation required!');
                    return result;
                }
                
                
                for (Portal_Honeywell_ID__c portalHoneywellId : portDetails){
                    portalHoneywellId.Revalidated_Date__c = system.today();
                    portalHoneywellId.Portal_Status__c = 'Active'; 
                    portalHoneywellId.Email_Sent_Counter__c = null;
                    portHonId.add(portalHoneywellId);
                    recordId.add(portalHoneywellId.Id);
                    
                }
                if(!portDetails.IsEmpty()){
                    update portHonId;
                    system.debug('after update ' +portHonId);
                    
                    result.resourceId = recordId[0];
                    result.status = 'successfully updated';
                }
                else{
                    result.handleError(404, 'No data found', 'No details found for given honeywell ID.');
                }
                
            }else{
                result.handleError(400, 'No honeywell ID found', 'Provide honeywell ID...!');
            }
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
        }
        return result;
    }//end of revalidate method
    
    
    /*To get the accountId from ContactId*/
    public static Id GetAccountId(string conId){
        List<Contact> accountId = new List<Contact>();
        if(conId != null && conId !=''){
            accountId = [SELECT AccountId FROM Contact WHERE Id =: conId   ];
        }
        if(accountId.size() > 0){
            return accountId[0].AccountId ;
        }else 
            return null;
    }
    
    //Get the list of tools active for particular contact
    public static List<Contact_Tool_Access__c > getContactTools(string conId, string honId){
        List<Contact_Tool_Access__c > conToolList = new List<Contact_Tool_Access__c>();
        if(conId != null && conId != '' && honId != null && honId != ''){
            conToolList = [SELECT Access_Granted_Date__c,CRM_Contact_ID__c,Id,Portal_Honeywell_ID__c,Portal_Tool_Master__c,
                           Request_Date__c,Request_Status__c,last_logged_in__c FROM Contact_Tool_Access__c 
                           WHERE CRM_Contact_ID__c =: conId AND Portal_Honeywell_ID__c =: honId];    
        }
        return conToolList;
    }
    public static REG_Result getToolStatus(string honId){
        
        object activeTools ;
        string conId = '';
        string accId = '';
        List<Portal_Tools_Master__c > PortalToolList = new List<Portal_Tools_Master__c>();
        List<Account_Tools__c> accountToolList = new List<Account_Tools__c>();
        List<Contact_Tool_Access__c > contToolList = new List<Contact_Tool_Access__c>();
        List<REG_ToolWrapper> finalValue = new List<REG_ToolWrapper>();
        Map<Id,Portal_Tools_Master__c > toolMasterMap = new Map<Id,Portal_Tools_Master__c >();
        Map<Id,Account_Tools__c> accountToolMap = new Map<Id,Account_Tools__c>();
        Map<Id,Portal_Tools_Master__c > accountContains = new Map<Id,Portal_Tools_Master__c >();
        Map<Id,Portal_Tools_Master__c > accountContainsN = new Map<Id,Portal_Tools_Master__c >();
        Map<Id,Portal_Tools_Master__c > conContainsN = new Map<Id,Portal_Tools_Master__c >();
        Map<Id,Contact_Tool_Access__c > conContains = new Map<Id,Contact_Tool_Access__c >();
        Map<Id,Contact_Tool_Access__c > conMap = new Map<Id,Contact_Tool_Access__c >();        
        REG_Result result = new REG_Result();
        try{
            
            /* To get active tools calling registration utility class*/
            
            activeTools = REG_RegistrationUtility.getAllActiveTools().Data;
            PortalToolList  = (List<Portal_Tools_Master__c >) activeTools;
            for(Portal_Tools_Master__c pTool:PortalToolList ){
                toolMasterMap.put(pTool.Id, pTool);
            }
            system.debug('****PortalToolList  ' +PortalToolList  );
            
            /*To get contact id from honeywell id calling registration utility class*/
            //try{
            conId = getContact(honId);
            if(conId == null || conId == ''){
                //throw new stringException('Contact Id not present for given Honeywell Id');
                result.handleError(404,'Contact Id not present for given Honeywell Id', 'Please provide valid honeywell Id');
                return result;
            }
            system.debug('****conId ' +conId );
            /* }catch(stringException e){
result.handleException(400, e.getMessage(), e);            
}catch(exception e){
result.handleException(500, e.getMessage(), e);             
}  */
            
            /*To get the accountId from ContactId*/   
            //try{
            accId = GetAccountId(conId);
            system.debug('****accId ' +accId );
            /*  }catch(System.StringException e){
result.StatusCode = 404;             
result.handleException(404,  'Requested Account Not Found', e); 

}catch(exception e){
result.handleException(500, e.getMessage(), e);             

}  
*/
            
            // try{
            /* to get the list of tools allowed in an account calling portal account class*/
            accountToolList = REG_PortalAccount_Service.GetAccTools(accId);
            system.debug('****accountToolList ' +accountToolList );
            
            //Get the list of tools active for particular contact calling portal contact class
            contToolList  = getContactTools(conId, honId);
            system.debug('****contToolList  ' +contToolList  );     
            
            //create map for account tools
            for(Account_Tools__c aTool: accountToolList ){
                accountToolMap.put(aTool.Portal_Tool_Master_Name__c , aTool);
            }
            //checking for allowed tools in account from master tools
            /* for(Portal_Tools_Master__c pM : PortalToolList){
if(accountToolMap.containsKey(pM.Id)){
accountContains.put(pM.Id,pM ); 
system.debug('***accountContains'+accountContains);
}else{
accountContainsN.put(pM.Id, pM);    
system.debug('***accountContainsN'+accountContainsN);
}
}*/
            system.debug('***accountContainsfinal'+accountContains);
            system.debug('***accountContainsNfinal'+accountContainsN); 
            
            //checking for status of contact tools for master tool list
            for(Contact_Tool_Access__c con: contToolList){
                conMap.put(con.Portal_Tool_Master__c, con);
                system.debug('***conMap'+conMap);
            }
            system.debug('***conMap'+conMap);
            
            for(Portal_Tools_Master__c pM : PortalToolList){
                if(conMap.containsKey(pM.Id)){
                    conContains.put(pM.Id,conMap.get(pM.Id) ); 
                    system.debug('***conContains'+conContains);
                }else{
                    conContainsN.put(pM.Id,pM ); 
                    system.debug('***conContainsN'+conContainsN);
                }
            } 
            
            for(Id pTool: conContainsN.keyset()){
                if(accountToolMap.containsKey(pTool)){
                    accountContains.put(pTool,toolMasterMap.get(pTool)); 
                    system.debug('***accountContains'+accountContains);
                }else{
                    accountContainsN.put(pTool,toolMasterMap.get(pTool));
                    system.debug('***accountContainsN'+accountContainsN);
                }
            }  
            
            /*for(Id pTool: accountContains.keyset()){
if(conMap.containsKey(pTool)){
conContains.put(pTool,conMap.get(pTool)); 
system.debug('***conContains'+conContains);
}else{
conContainsN.put(pTool,conMap.get(pTool));
system.debug('***conContainsN'+conContainsN);
}
}*/
            
            for(Portal_Tools_Master__c pmT: PortalToolList){
             /*   if((accountContainsN.containsKey(pmT.Id)) && (conContainsN.containsKey(pmT.Id))){
                    string status = 'Not Permitted';
                    REG_ToolWrapper toolWrap = new REG_ToolWrapper(status, conId, honId, null, null, null, pmT.Id,accountContainsN.get(pmT.Id).Tool_Authorization_Method__c
                                                                   ,accountContainsN.get(pmT.Id).Auto_approve__c,accountContainsN.get(pmT.Id).Tool_Image__c
                                                                   ,accountContainsN.get(pmT.Id).Lanch_URL__c, accountContainsN.get(pmT.Id).Name
                                                                   ,accountContainsN.get(pmT.Id).Tool_Sort_Order__c );
                    finalValue.add(toolWrap);
                }   */
                
                if((conContainsN.containsKey(pmT.Id)) && (accountContains.containsKey(pmT.Id))){
                    string status = 'Not Requested';
                    REG_ToolWrapper toolWrap = new REG_ToolWrapper(status, conId, honId, null, null, null, pmT.Id,accountContains.get(pmT.Id).Tool_Authorization_Method__c
                                                                   ,accountContains.get(pmT.Id).Auto_approve__c,accountContains.get(pmT.Id).Tool_Image__c
                                                                   ,accountContains.get(pmT.Id).Lanch_URL__c, accountContains.get(pmT.Id).Name
                                                                   , accountContains.get(pmT.Id).Tool_Sort_Order__c  );
                    finalValue.add(toolWrap);
                }  
                if(conContains.containsKey(pmT.Id)){
                    string status = conContains.get(pmT.Id).request_status__c;
                    REG_ToolWrapper toolWrap = new REG_ToolWrapper(status, conId, honId, conContains.get(pmT.Id).Access_Granted_Date__c
                                                                   , conContains.get(pmT.Id).last_logged_in__c,conContains.get(pmT.Id).Request_Date__c
                                                                   , pmT.Id,toolMasterMap.get(pmT.Id).Tool_Authorization_Method__c,toolMasterMap.get(pmT.Id).Auto_approve__c
                                                                   ,toolMasterMap.get(pmT.Id).Tool_Image__c,toolMasterMap.get(pmT.Id).Lanch_URL__c, toolMasterMap.get(pmT.Id).Name
                                                                   , toolMasterMap.get(pmT.Id).Tool_Sort_Order__c);
                    finalValue.add(toolWrap);
                }  
                
            } 
            result.data = finalValue;
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);             
            
        }  
        
        return result;            
    }    
    /* public static REG_Result getToolStatus(string honId){

object activeTools ;
string conId = '';
string accId = '';
List<Portal_Tools_Master__c > PortalToolList = new List<Portal_Tools_Master__c>();
List<Account_Tools__c> accountToolList = new List<Account_Tools__c>();
List<Contact_Tool_Access__c > contToolList = new List<Contact_Tool_Access__c>();
List<REG_ToolWrapper> finalValue = new List<REG_ToolWrapper>();
Map<Id,Account_Tools__c> accountToolMap = new Map<Id,Account_Tools__c>();
Map<Id,Portal_Tools_Master__c > accountContains = new Map<Id,Portal_Tools_Master__c >();
Map<Id,Portal_Tools_Master__c > accountContainsN = new Map<Id,Portal_Tools_Master__c >();
Map<Id,Contact_Tool_Access__c > conContainsN = new Map<Id,Contact_Tool_Access__c >();
Map<Id,Contact_Tool_Access__c > conContains = new Map<Id,Contact_Tool_Access__c >();
Map<Id,Contact_Tool_Access__c > conMap = new Map<Id,Contact_Tool_Access__c >();        
REG_Result result = new REG_Result();


// To get active tools calling registration utility class

activeTools = REG_RegistrationUtility.getAllActiveTools().Data;
PortalToolList  = (List<Portal_Tools_Master__c >) activeTools;
system.debug('****PortalToolList  ' +PortalToolList  );

//To get contact id from honeywell id calling registration utility class
try{
conId = getContact(honId);
if(conId == null || conId == ''){
//throw new stringException('Contact Id not present for given Honeywell Id');
result.handleError(404,'Contact Id not present for given Honeywell Id', 'Please provide valid honeywell Id');
}
system.debug('****conId ' +conId );
}catch(stringException e){
result.handleException(400, e.getMessage(), e);            
}catch(exception e){
result.handleException(500, e.getMessage(), e);             
}  

//To get the accountId from ContactId   
try{
accId = GetAccountId(conId);
system.debug('****accId ' +accId );
}catch(System.StringException e){
result.StatusCode = 404;             
result.handleException(404,  'Requested Account Not Found', e); 

}catch(exception e){
result.handleException(500, e.getMessage(), e);             

}  


try{
//to get the list of tools allowed in an account calling portal account class
accountToolList = REG_PortalAccount_Service.GetAccTools(accId);
system.debug('****accountToolList ' +accountToolList );

//Get the list of tools active for particular contact calling portal contact class
contToolList  = getContactTools(conId, honId);
system.debug('****contToolList  ' +contToolList  );     

//create map for account tools
for(Account_Tools__c aTool: accountToolList ){
accountToolMap.put(aTool.Portal_Tool_Master_Name__c , aTool);
}
//checking for allowed tools in account from master tools
for(Portal_Tools_Master__c pM : PortalToolList){
if(accountToolMap.containsKey(pM.Id)){
accountContains.put(pM.Id,pM ); 
system.debug('***accountContains'+accountContains);
}else{
accountContainsN.put(pM.Id, pM);    
system.debug('***accountContainsN'+accountContainsN);
}
}
system.debug('***accountContainsfinal'+accountContains);
system.debug('***accountContainsNfinal'+accountContainsN); 

//checking for status of contact tools from account tools list
for(Contact_Tool_Access__c con: contToolList){
conMap.put(con.Portal_Tool_Master__c, con);
system.debug('***conMap'+conMap);
}
system.debug('***conMap'+conMap);
for(Id pTool: accountContains.keyset()){
if(conMap.containsKey(pTool)){
conContains.put(pTool,conMap.get(pTool)); 
system.debug('***conContains'+conContains);
}else{
conContainsN.put(pTool,conMap.get(pTool));
system.debug('***conContainsN'+conContainsN);
}
}

for(Portal_Tools_Master__c pmT: PortalToolList){
if(accountContainsN.containsKey(pmT.Id)){
string status = 'Not Permitted';
REG_ToolWrapper toolWrap = new REG_ToolWrapper(status, conId, honId, null, null, null, pmT.Id,accountContainsN.get(pmT.Id).Tool_Authorization_Method__c
,accountContainsN.get(pmT.Id).Auto_approve__c,accountContainsN.get(pmT.Id).Tool_Image__c
,accountContainsN.get(pmT.Id).Lanch_URL__c, accountContainsN.get(pmT.Id).Name
,accountContainsN.get(pmT.Id).Tool_Sort_Order__c );
finalValue.add(toolWrap);
}   

if(conContainsN.containsKey(pmT.Id)){
string status = 'Not Requested';
REG_ToolWrapper toolWrap = new REG_ToolWrapper(status, conId, honId, null, null, null, pmT.Id,accountContains.get(pmT.Id).Tool_Authorization_Method__c
,accountContains.get(pmT.Id).Auto_approve__c,accountContains.get(pmT.Id).Tool_Image__c
,accountContains.get(pmT.Id).Lanch_URL__c, accountContains.get(pmT.Id).Name
, accountContains.get(pmT.Id).Tool_Sort_Order__c  );
finalValue.add(toolWrap);
}  
if(conContains.containsKey(pmT.Id)){
string status = conContains.get(pmT.Id).request_status__c;
REG_ToolWrapper toolWrap = new REG_ToolWrapper(status, conId, honId, conContains.get(pmT.Id).Access_Granted_Date__c
, conContains.get(pmT.Id).last_logged_in__c, conContains.get(pmT.Id).Request_Date__c
, pmT.Id,accountContains.get(pmT.Id).Tool_Authorization_Method__c,accountContains.get(pmT.Id).Auto_approve__c
,accountContains.get(pmT.Id).Tool_Image__c,accountContains.get(pmT.Id).Lanch_URL__c, accountContains.get(pmT.Id).Name
, accountContains.get(pmT.Id).Tool_Sort_Order__c);
finalValue.add(toolWrap);
}  

} 
result.data = finalValue;
}catch(exception e){
result.handleException(500, e.getMessage(), e);             

}  

return result;            
}
*/
    public static REG_Result getSpecificToolStatus(string honId, string toolId){
        
        object activeTools;
        string conId = '';
        string accId = '';
        string status = '';
        boolean accPresent = false;
        List<Portal_Tools_Master__c > PortalToolList = new List<Portal_Tools_Master__c>();
        List<Contact_Tool_Access__c > conToolList = new List<Contact_Tool_Access__c > ();
        List<Account_Tools__c> accountToolList = new List<Account_Tools__c>();
        Map<Id, Contact_Tool_Access__c > conToolMap = new Map<Id, Contact_Tool_Access__c >(); 
        Map<Id, Portal_Tools_Master__c > masterMap = new Map<Id, Portal_Tools_Master__c >(); 
        REG_Result result = new REG_Result(); 
        /*To get contact id from honeywell id calling registration utility class*/
        
        try{
            conId = getContact(honId);
            system.debug(logginglevel.info,'conId' +conId);
            if(conId == null || conId == ''){
                // result.data = 'No Contact found for given Honeywell Id';
                //return result;
                //throw new stringException('Contact Id not present for given Honeywell Id');
                result.handleError(404, 'Contact does not exist for the Honeywell id.', 'Contact does not exist for the Honeywell id.');
                return result;
            }
            system.debug('****conId ' +conId );
        }catch(stringException e){
            result.handleException(400, e.getMessage(), e);
            
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);             
            
        }  
        
        /*To get the accountId from ContactId*/   
        try{
            accId = GetAccountId(conId);
            system.debug('****accId ' +accId );
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);             
            
        }  
        
        system.debug('****toolId'+toolId);
        /* To get active tools calling registration utility class*/
        try{
            system.debug('inside try');
            activeTools = REG_RegistrationUtility.getAllActiveTools().Data;
            
            PortalToolList  = (List<Portal_Tools_Master__c >) activeTools;
            system.debug('***portalToolList'+portalToolList);
            for(Portal_Tools_Master__c ptM : PortalToolList){
                masterMap.put(ptM.Id, ptM);
            }
            //string chckToolId = masterMap.get(toolId).Id;
            system.debug('*****masterMap'+masterMap);
            //system.debug('*****masterMap'+masterMap.containsKey(toolId));
            if(!masterMap.containsKey(toolId)){
                system.debug('inside if');
                throw new stringException('Given Tool Id does not exist');
            }
            system.debug('****PortalToolList  ' +PortalToolList  );
            
            
            conToolList  = getContactTools(conId, honId);
            for(Contact_Tool_Access__c conT: conToolList){
                if(conT.Portal_Tool_Master__c == toolId){
                    conToolMap.put(conT.Portal_Tool_Master__c, cont); 
                    status = conT.Request_Status__c;
                    break;
                }
            }
            system.debug('conToolMap' +conToolMap);
            if(conToolMap.isEmpty()){
                system.debug('inside contool');
                accountToolList = REG_PortalAccount_Service.GetAccTools(accId);
                if(!accountToolList.isEmpty()){    
                    system.debug('accountToolList ' +accountToolList );
                    for(Account_Tools__c accTool: accountToolList){
                        string accToolId = accTool.Portal_Tool_Master_Name__c;
                        if(accToolId.contains(toolId)){
                            system.debug('inside if accounttool');
                            status = 'Not Requested'; 
                            accPresent = True;
                            break;   
                        }else{
                            system.debug('inside if accounttool4455');
                            
                            status = 'Not Permitted';
                        }
                    }
                } else{status = 'Not Permitted';}       
            }
            system.debug('status' +status);
            /*  if(!accPresent ){
status = 'Not Permitted';
}*/
            if(conToolMap.size() >= 1){
                REG_ToolWrapper toolWrap = new REG_ToolWrapper(status, conId, honId, conToolMap.get(toolId).Access_Granted_Date__c
                                                               , conToolMap.get(toolId).last_logged_in__c, conToolMap.get(toolId).Request_Date__c
                                                               , toolId,masterMap.get(toolId).Tool_Authorization_Method__c,masterMap.get(toolId).Auto_approve__c
                                                               ,masterMap.get(toolId).Tool_Image__c,masterMap.get(toolId).Lanch_URL__c, masterMap.get(toolId).Name
                                                               , masterMap.get(toolId).Tool_Sort_Order__c);
                result.Data = toolWrap;
                system.debug('****result.data' +result.data);
            }else{
                REG_ToolWrapper toolWrap = new REG_ToolWrapper(status, conId, honId, null
                                                               , null, null
                                                               , toolId,masterMap.get(toolId).Tool_Authorization_Method__c,masterMap.get(toolId).Auto_approve__c
                                                               ,masterMap.get(toolId).Tool_Image__c,masterMap.get(toolId).Lanch_URL__c, masterMap.get(toolId).Name
                                                               , masterMap.get(toolId).Tool_Sort_Order__c);
                result.Data = toolWrap;
                system.debug('****result.data' +result.data);
            }
        }catch(stringException e){        
            //result.handleException(400, 'Invalid Tool Id OR Tool is not active', e); 
            result.handleError(404 , 'Invalid Tool Id OR Tool is not active' , 'Please provide a valid tool Id.');
            
        }catch(exception e){
            result.handleException(500, e.getMessage(), e); 
            
        }
        return result;
    }
    
    
    /** 
getAccountMessage Method will get 'Account Specific Portal Sign in Message' for Primary Account
* */         
    public static REG_Result getAccountMessage(String honid,String emailId){
        REG_Result result = new REG_Result();
        String message = '';
        String accId = '';
        try{
            List<contact> conInfo;
            if(String.isNotBlank(honid)){
                REG_Result conId = REG_PortalContact_Service.getContactforHid(honid);
                if(conId.StatusCode==200){
                    List<Portal_Honeywell_ID__c> lstphi=(List<Portal_Honeywell_ID__c> ) conId.Data;
                    if(lstphi.size() >0 && lstphi[0].Contact_Status__c=='Inactive'){
                        result.handleError(400,'Bad Data','Contact Status is Inactive');
                        return result;}
                    
                    conInfo = [select Id, EMAIL, AccountID, FirstName, LastName, Primary_Email_Address__c
                               from contact where id = :lstphi[0].Contact__c];
                } else {
                    result.handleError(400, 'Bad Data', 'Provide valid Honeywell ID to fetch contact detail.');
                    return result;
                }
                
            } else{
                List<Portal_Honeywell_ID__c> conInfo1;
                conInfo1 = [SELECT Contact__c,Contact__r.AccountId, Contact_Status__c, Name,Portal_Status__c ,Contact__r.Primary_Email_Address__c,Primary_Honeywell_ID__c
                            FROM Portal_Honeywell_ID__c WHERE Contact__r.Primary_Email_Address__c= :emailId  and Primary_Honeywell_ID__c=true AND Portal_Status__c != 'InActive' AND Portal_Status__c != 'Deleted'];  
                if(conInfo1.IsEmpty()){
                    result.handleError(400, 'Bad Data', 'Provide valid email ID to fetch contact detail.');
                    return result;
                }
                else if (conInfo1[0].Contact_Status__c=='Inactive'){
                    result.handleError(400,'Bad Data','Contact Status is Inactive');
                    return result;}
                conInfo = [select Id, EMAIL, AccountID, FirstName, LastName, Primary_Email_Address__c
                           from contact where Primary_Email_Address__c = :emailId];
            }
            
            if(!conInfo.IsEmpty()){
                accId = conInfo[0].AccountID;
                System.debug(LoggingLevel.Info, 'accId ***'+accId);
                //fetching Account Messgae content
                account porMessage = [select id, PortalSignInMessage__c from account where id = :accId];
                System.debug(LoggingLevel.Info, 'porMessage ***'+porMessage);
                message = porMessage.PortalSignInMessage__c;
                
                REG_AccountMessage_Wrapper msgWrap = new REG_AccountMessage_Wrapper(accId,message);
                result.data =  msgWrap;
                
            }/*else{
result.handleError(404, 'No data found', 'No record found for given Input');
}*/
        }   
        catch(exception e){
            result.handleException(500, e.getMessage(), e);
        }
        return result;
    } //end of getAccountMessage Method //
    
    
    public static String convertPhoneNumbersToInputFormat(String input){
        if(!String.isBlank(input)){
            //system.debug(logginglevel.info,'****input' +input);
            //system.debug(logginglevel.info,'****input.length' +input.length());
            if(input.startsWith('+1') && input.length()==13){
                String str1=input.substring(3, 6);
                String str2=input.substring(6, 9);
                String str3=input.substring(9, 13);
                input='+1 '+'('+str1+') '+str2+'-'+str3;
                system.debug(logginglevel.info,'****input1' +input);
            }               
            
        }        
        return input;
    } 
    /** 
createContact MEthod will create/update contact and insert/update the related data
* */    
    public static REG_Result createContact(Object contactInfo){        
        REG_Result result = new REG_Result();
        Portal_Honeywell_ID__c portalHONrecordMul=new Portal_Honeywell_ID__c();
        List<Messaging.SingleEmailMessage> FinalMsgList = new List<Messaging.SingleEmailMessage>();
        Savepoint sp= Database.setSavepoint();
        
        try{
            //Parse from object to contact
            system.debug('***contactInfo123' +contactInfo);
            //system.debug('contactInfo.Honeywell_ID__c'+contactInfo.Honeywell_ID__c);
            Contact ct=(contact) contactInfo;
            system.debug('ct***'+ct);           
            
            //contact and portal honeywell id object update
            if(!string.isBlank(ct.Id)){
                
                //update:02-05-19
                //preparing email body 
                List<contact> con = [select Primary_Email_Address__c,Email,Honeywell_ID__c,Contact_Status__c,CreatedDate from contact where id =:ct.id];
                if(con.isEmpty()){
                    result.handleError(404,'No data found', 'No data found for given contact Id');
                    return result;                
                }else if(con[0].Contact_Status__c == 'Inactive'){
                    result.handleError(404, 'Bad data', 'Contact status is inactive');
                    return result;
                }                
                if(!string.isBlank(ct.Honeywell_ID__c) && (ct.Honeywell_ID__c != con[0].Honeywell_ID__c)){
                    contact conObjAdm = REG_RegistrationUtility.getAdmilemailData(ct.Id);
                    system.debug('conObjAdm***'+conObjAdm);
                    string ctexhid =ct.Honeywell_ID__c;
                    system.debug('conObjAdm.Contact_Tool_Access__r***'+conObjAdm.Contact_Tool_Access__r);
                    FinalMsgList  = REG_RegistrationUtility.getEmailMetaData(conObjAdm,conObjAdm.Contact_Tool_Access__r , 'Honeywell_ID_di_association',ctexhid);
                    system.debug('FinalMsgList***'+FinalMsgList);
                    
                }        
                ct.Primary_Email_Address__c = con[0].Primary_Email_Address__c;
                ct.Email = con[0].Email;
                
                //Added as a part of RAPD - 5719
                ct.Email_Opt_In__c = ct.Email_Opt_In__c;
                system.debug('con[0].CreatedDate==>'+con[0].CreatedDate);
                if(ct.Email_Opt_In__c == true){
                    ct.Email_Opt_In_Date__c = Date.valueof(con[0].CreatedDate.format('yyyy-MM-dd', UserInfo.getTimeZone().getID()));
                }else if(ct.Email_Opt_In__c == false){
                    ct.Email_Opt_In_Date__c = null;
                }
                
            }            
            //2.1 Check if the Contact is internal contact or not
            Boolean isInternal=false;
            if(!String.isBlank(ct.Email)){
                
                String domain=ct.Email.substring(ct.Email.indexOf('@') + 1);
                REG_Result domainResult= REG_RegistrationUtility.getdomainType(domain,'');
                system.debug(logginglevel.info,'domainResult*****' +domaInResult);
                system.debug(logginglevel.info,'Result*****' +Result);
                if(domainresult.StatusCode==200){
                    List<Account_Email_Domains__c> lstDomains=(List<Account_Email_Domains__c> ) domainResult.Data;
                    system.debug(logginglevel.info,'lstDomains*****' +lstDomains);
                    if(lstDomains.size() >0 && lstDomains[0].Internal_Email_Domain__c==true){
                        isInternal=true;
                    }
                    
                }
            }
            
                
                
           
            //0.1 If the AccountId is empty then make accountid as unidentified account by specifying the undefitied account id
            
            if(String.isBlank(ct.AccountId)){
                ct.AccountId=System.Label.REG_UnidentifiedAccountId;                
            }
            //0.2 Populate the data for contact 
            if(String.isNotBlank(ct.Phone_1__c)){
                ct.Phone_1__c=convertPhoneNumbersToInputFormat(ct.Phone_1__c);
            }
            if(String.isNotBlank(ct.mobilePhone)){
                ct.mobilePhone=convertPhoneNumbersToInputFormat( ct.mobilePhone);
            }
            if(String.isNotBlank(ct.Phone_5__c)){
                ct.Phone_5__c=convertPhoneNumbersToInputFormat(ct.Phone_5__c);
            }
            
            ct.Contact_Status__c='Active';
            ct.Contact_Is_Employee__c=isInternal;
            if(isInternal)   {
                ct.Employee_Number__c=ct.Honeywell_ID__c;
                ct.Employee_Contact_Role__c='Other';
                
            }
            ct.Middle_Name_not_Available__c=(String.isBlank(ct.Middle_Name__c))?true:false;
            ct.Product_Updates__c=false;
            
            
            //1. Check if the contact exists or not . If exists insert else update 
            //;getContact(ct.Honeywell_ID__c);
            String contactOperation=null;
            if(!String.isBlank(ct.id)){
                system.debug('update===>');
                contactOperation='Updated';                
            }else{
               //Added as a part of RAPD - 5719
                system.debug('con[0].CreatedDate==>'+Date.valueof(Datetime.now()));
                if(ct.Email_Opt_In__c == true){
                    ct.Email_Opt_In_Date__c = Date.valueof(Datetime.now().format('yyyy-MM-dd', UserInfo.getTimeZone().getID()));
                }
                contactOperation='Inserted';
            }
            try{
            UPSERT ct ID;
            }catch(DmlException e){
                    if (e.getMessage().contains('Employee_Number__c duplicates value')){
                       result.handleError(404, 'Bad data', 'Duplicate value found for employee number:'+ct.Employee_Number__c);
                    }else{
                        result.handleException(500, e.getMessage(), e);
                    }      }
            //UPSERT ct ID;
            
            //2.2 Create Related Account Contact Record
            if(!String.isBlank(ct.AccountId) && ( ct.AccountId!=System.Label.REG_UnidentifiedAccountId) && (  contactOperation=='Inserted') && isInternal==false){
                Account_Contact__c accountContact=new Account_Contact__c();
                AccountContact.Account_Name__c=Ct.AccountId;
                AccountContact.Contact__c=Ct.Id;
                INSERT accountContact;
            }
            
            
            if(!String.isBlank(ct.Id)){
                //3 Create related contact Address
                //3.1 Make contact Address as Inactive 
                List<contact_address__c> addressList=[Select contact__c, id, is_primary_address__c from contact_address__c where contact__c= :ct.ID and (address_status__c = 'active' or is_primary_address__c = true)];
                for(contact_address__c contactAddress: addressList){
                    contactAddress.is_primary_address__c=false;
                    contactAddress.address_status__c='Inactive';
                }       
                UPDATE addressList;
                //3.2 Create new contactAddress records
                Contact_Address__c newContactAddress=new Contact_Address__c();
                newContactAddress.contact__c=ct.Id ;
                newContactAddress.address_type__c='Office' ;
                newContactAddress.address_status__c='Active';
                newContactAddress.is_primary_address__c=true ;
                newContactAddress.reporting_street_address_line_1__c=ct.Address_Line_1__c;
                newContactAddress.reporting_street_address_line_2__c=ct.Address_Line_2__c;
                newContactAddress.reporting_street_address_line_3__c=ct.Address_Line_3__c;
                newContactAddress.reporting_city_name__c=ct.City_Name__c;
                newContactAddress.reporting_address_postal_code__c=ct.Postal_Code__c ;
                newContactAddress.reporting_country_name__c=ct.Country_Name__c ;
                newContactAddress.report_country_codes__c=ct.Country_code__c ;
                newContactAddress.reporting_address_state_code__c=ct.State_Code__c;
                
                INSERT newContactAddress;
                
                //4 Create Portal Honeywell id
                //4.1 getExistingHONIdsByContactId and make them inactive
                List<Portal_Honeywell_ID__c> portalHONrecords0=[Select Id,Name,Primary_Honeywell_ID__c from 
                                                                Portal_Honeywell_ID__c   where  Contact__c = :ct.id and Primary_Honeywell_ID__c = true];
                for(Portal_Honeywell_ID__c portalHONrecord:portalHONrecords0){
                    portalHONrecord.Primary_Honeywell_ID__c=false;
                }
                update portalHONrecords0;
                ///Query is pending for 4.2
                //4.2 Get the list of all Honeywell IDs as if contact id exists for some other honeywell id as delete contact id then it should be updated
                List<Portal_Honeywell_ID__c> portalHONrecords1=[SELECT Delete_Contact_ID__c,Id,Primary_Honeywell_ID__c FROM Portal_Honeywell_ID__c WHERE Delete_Contact_ID__c = :ct.Id AND Name = :ct.Honeywell_ID__c];
                for(Portal_Honeywell_ID__c portalHONrecord:portalHONrecords1){
                    portalHONrecord.Primary_Honeywell_ID__c=false;
                    portalHONrecord.delete_contact_id__c=null;
                }
                update portalHONrecords1;
                
                //4.3 "Check whether the hon id exists in portal_honeywell_id__c and If available, update portal_honeywell_id__c or create new record
                List<Portal_Honeywell_ID__c> portalHONrecords3=[SELECT Contact__c,Id,Name,Primary_Honeywell_ID__c,portal_status__c FROM Portal_Honeywell_ID__c WHERE Name = :ct.Honeywell_ID__c];
                system.debug(logginglevel.info,'portal honeywell record'+portalHONrecords3);
                
                /*
//if a contact is associated wiyh multiple honid's with different(like active, inactive, delete) or same status. choose the 
// record with priority given in following order: 1) active or null 2 inactive 3 delete 
if(portalHONrecords3.size() >1){
List<Portal_Honeywell_ID__c> portalHONrecordUpdate =new List<Portal_Honeywell_ID__c>();
Map<string,Portal_Honeywell_ID__c > portalHONrecordMulMap = new Map<string,Portal_Honeywell_ID__c >();

for(Portal_Honeywell_ID__c prtHon : portalHONrecords3){

if(string.isBlank(prtHon.portal_status__c)){
prtHon.portal_status__c = 'Active';
}
portalHONrecordMulMap.put(prtHon.portal_status__c ,prtHon);
}
system.debug(logginglevel.info,'portal honeywell record map'+portalHONrecordMulMap);
if(portalHONrecordMulMap.containsKey('Active')){
portalHONrecordMul = portalHONrecordMulMap.get('Active');
for(Portal_Honeywell_ID__c prtHon: portalHONrecords3){

if(prtHon.Id != portalHONrecordMul.Id && prtHon.portal_status__c != 'Deleted' && prtHon.portal_status__c != 'Inactive'){
prtHon.portal_status__c = 'Inactive'   ; 
portalHONrecordUpdate.add(prtHon);
}    
} 
update portalHONrecordUpdate;
}

else{
portalHONrecordMul =  portalHONrecords3[0];   
}

}else if(portalHONrecords3.size() == 1){
portalHONrecordMul =  portalHONrecords3[0]; 
}
*/
                
                Portal_Honeywell_ID__c portalHONrecord=new Portal_Honeywell_ID__c();
                if(portalHONrecords3.size()>0) {
                    if((!string.isBlank(portalHONrecords3[0].Contact__c)) && (portalHONrecords3[0].Contact__c != ct.id)){
                        contact conHonIdUpdate = new contact();
                        conHonIdUpdate.Id = portalHONrecords3[0].Contact__c;
                        conHonIdUpdate.honeywell_id__c = '';
                        update conHonIdUpdate ;
                    }
                    portalHONrecord=portalHONrecords3[0];
                    portalHONrecord.delete_contact_id__c=null;
                    portalHONrecord.Deleted_By__c =null;
                    portalHONrecord.delete_hon_id__c=false;
                    portalHONrecord.portal_last_updated_date__c=System.today();
                    portalHONrecord.Portal_Last_Accessed_Date__c=System.today();
                    system.debug(logginglevel.info,'portal honeywell record'+portalHONrecord);
                }
                else
                {
                    portalHONrecord.Portal_Created_Date__c = System.today();
                    portalHONrecord.Revalidated_Date__c = System.today(); 
                    portalHONrecord.Portal_Last_Accessed_Date__c=System.today();
                    
                }
                portalHONrecord.Contact__c=ct.Id;
                portalHONrecord.Name=ct.Honeywell_ID__c;
                if(!String.isBlank(ct.Email)) portalHonrecord.Email_Address__c=ct.Email;
                portalHonrecord.primary_honeywell_id__c=true;
                portalHONrecord.portal_status__c= 'Active';
                try{
                    UPSERT portalHonrecord ID;
                }
                catch(DmlException e){
                    if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                        result.handleException(400, e.getMessage(), e);
                    }else{
                        result.handleException(500, e.getMessage(), e);
                    }
                }
                //5 Call PUR  PUT API Method
                Object PURDetails;
                Portal_User_Registration__C pur=new Portal_User_Registration__C();
                pur.Honeywell_ID__c=ct.Honeywell_ID__c;
                pur.Contact_Creation_in_SFDC__c='Y';
                pur.Contact__c=ct.Id;
                if(!String.isBlank(ct.Email)) pur.EmailAddress__c=ct.Email;
                PURDetails=(Object) pur;
                REG_Result res=REG_PortalUserRegistration_Service.setPURDetails(PURDetails);
                if(res.StatusCode!=200) result=res;
                
                
                
                //Call create Tool API to given access to training tool
                //commenting as per discussion with Sumeet - 22/08/19
                /*List<toolsWrap> toolsList=new List<toolsWrap>();
REG_Result tempResult = REG_PortalToolAccess_Service.checkToolAccess(ct.Honeywell_ID__c, REG_Master_Tool_Name__c.getValues('REG Technical Knowledge Center').tool_id__c, null, null,null,null,null,null);  
if(tempResult.StatusCode!=200){result=tempResult;}
else{
System.debug(logginglevel.info,'tempResult'+tempResult);
//toolsList.add(new toolsWrap(tempResult.resourceId,tempResult.status));
toolsList.addAll(((REG_Resource)tempResult.resource).tools);

}*/
                
                //codeupdate:02-05-19
                if( (string.isNotBlank(ct.Id)) && (FinalMsgList.size() > 0)){
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(FinalMsgList);
                }
                
                result.status='success';
                result.isInternal=ct.Contact_Is_Employee__c;
                result.honId=ct.Honeywell_ID__c;
                result.contactId=ct.Id;
                //result.resource=new REG_Resource(ct,toolsList);
                
                //Below code is to send email when Account is Unidentified Account
                if(ct.AccountId==System.Label.REG_UnidentifiedAccountId && (!String.isBlank(Label.REG_UnidentifiedAccountMailRecipients)) ){
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();                    
                    message.toAddresses =Label.REG_UnidentifiedAccountMailRecipients.split(';');                    
                    message.setOrgWideEmailAddressId(Label.REG_UnidentifiedAccountFromAddress);
                    //changed for INC0003335856 by saurabh
                    message.subject = Label.REG_UnidentifiedAccountEmail_Subject;
                    //end
                    message.htmlbody= '<br/> Hi, <br/><br/> User with Honeywell ID :  '+ct.Honeywell_ID__c+'   has registered as a generic user in MyAerospace Portal.<br/><br/>  Please find the Company Name entered by the user : '+ct.Portal_Company_Name__c+' and link the SFDC Contact to the proper account. <br/><br/>Make sure to remove the HONEYWELL UNIDENTIFIED PORTAL USERS; account from the Contact Account Name and the Related Accounts list after the proper account has been assigned.<br/><br/>Regards,<br/>MyAerospace Admin.';                    
                    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};                        
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                }   
            }
            
        }catch(Exception e){
            Database.rollback(sp);
            result.handleException(500, e.getMessage(), e);
            //result.handleError(400, 'Honeywell Id cannot be duplicate', 'Honeywell should be unique');
            
        }
        
        return result;
    }
    //code to update specific tool for given honeywell id
    public static REG_Result updateSpecificTool(string toolId, string honId){
        List< Contact_Tool_Access__c> conToolList = new List< Contact_Tool_Access__c>();
        REG_Result result =new REG_Result();
        try{
            conToolList = [select Id, last_logged_in__c from Contact_Tool_Access__c where Portal_Tool_Master__c =: toolId and Portal_Honeywell_ID__c =: honId];
            system.debug('conToolList ' +conToolList );
            if(conToolList.size() >= 1){
                conToolList[0].last_logged_in__c = system.now();
                system.debug('conToolList[0].last_logged_in__c' +conToolList[0].last_logged_in__c);
                update conToolList[0];
                result.resourceId =conToolList[0].ID;
                result.status='success';            
            }else{
                result.handleError(404,'No data found', 'No data found for given honID/Tool Id');
                return result;
                //throw new stringException('No data found for given Tool Id');
            }
            
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);    
        }
        return result;
    }
    
    
    //code for create tool
    public static void createTool(string honId, List<string> toolId, string conId, Contact_Tool_Access__c contactToolAccess,Map<string,string> reqstatMap){
        REG_Result result =new REG_Result();
        //set<string> chckToolSet18 = new set<string>();
        //set<string> chckToolSet15 = new set<string>();
        system.debug('insert create tool-789');
        List< Contact_Tool_Access__c> conTList = new List< Contact_Tool_Access__c>();
        List<Contact_Tool_Access__c> conTListInsert = new List<Contact_Tool_Access__c>();
        List<Contact_Tool_Access__c> conTListUpdate = new List<Contact_Tool_Access__c>();
        Map<string,Contact_Tool_Access__c> conTMap = new Map<string,Contact_Tool_Access__c>();
        List<Portal_Tools_Master__c> masterList = new list<Portal_Tools_Master__c>();
        Map<string,Portal_Tools_Master__c > chckToolMap = new Map<string,Portal_Tools_Master__c>();
        try{
            
            masterList = [SELECT Tool_Description__c,Name,Id,OwnerId,Queue_Id__c FROM Portal_Tools_Master__c where Id in :toolId];
            /* if(masterList.isEmpty()){
throw new stringException('No data found for given Tool Id');
}*/
            system.debug('insert create tool-masterList'+masterList);
            for(Portal_Tools_Master__c  ptM: masterList){
                
                //string a = ptm.id;
                //string b = a.substring(0,15);
                chckToolMap.put(ptM.id,ptM); 
                // chckToolSet18.add(ptM.id); 
                //   chckToolSet15.add(b); 
                
            }
            
            system.debug('conId' +conId);
            //system.debug('contactToolAccess.Portal_Tool_Master__c' +contactToolAccess.Portal_Tool_Master__c);
            conTList = [select Id,name,CRM_Contact_ID__c ,Portal_Tool_Master__c , Request_Date__c,MCORE_Account_Type__c,Manager_Name__c,MCORE_Platform_of_most_interest1__c,MCORE_Platform_of_most_interest2__c,MCORE_Platform_of_most_interest3__c,MCORE_Purpose_of_MCORE_Access__c, Access_Granted_Date__c, Request_Status__c from Contact_Tool_Access__c where Portal_Tool_Master__c in :toolId and CRM_Contact_ID__c =: conId and Portal_Honeywell_ID__c=: honId]; 
            system.debug('conTList' +conTList);
            for(Contact_Tool_Access__c con: conTList){
                conTMap.put(con.Portal_Tool_Master__c , con);    
                system.debug('conTMap' +conTMap);
            }
            system.debug(logginglevel.info,'conTMap' +conTMap);
            for(string tool: toolId){
                system.debug(logginglevel.info,'toolId*****' +toolId);
                if(conTMap.containsKey(tool)){
                    system.debug('if-part');
                    //update portalhoneywellid, contactid, toolname
                    conTMap.get(tool).Name = chckToolMap.get(tool).Name;
                    conTMap.get(tool).Portal_Honeywell_ID__c = honId;
                    conTMap.get(tool).CRM_Contact_ID__c = conId;
                    conTMap.get(tool).Request_Date__c = system.Now();
                    conTMap.get(tool).Access_Granted_Date__c =  reqstatMap.get(tool) == 'Approved'?system.Now():null;
                    system.debug(logginglevel.info,'reqstatMap' +reqstatMap);
                    system.debug(logginglevel.info,'tool' +tool);
                    conTMap.get(tool).Request_Status__c = reqstatMap.get(tool);  
                    if(contactToolAccess!=null){
                        if(!string.isBlank(contactToolAccess.MCORE_Account_Type__c))
                            conTMap.get(tool).MCORE_Account_Type__c = contactToolAccess.MCORE_Account_Type__c;
                        if(!string.isBlank(contactToolAccess.Manager_Name__c))
                            conTMap.get(tool).Manager_Name__c= contactToolAccess.Manager_Name__c;
                        if(!string.isBlank(contactToolAccess.MCORE_Platform_of_most_interest1__c))
                            conTMap.get(tool).MCORE_Platform_of_most_interest1__c = contactToolAccess.MCORE_Platform_of_most_interest1__c;
                        if(!string.isBlank(contactToolAccess.MCORE_Platform_of_most_interest2__c))
                            conTMap.get(tool).MCORE_Platform_of_most_interest2__c= contactToolAccess.MCORE_Platform_of_most_interest2__c;
                        if(!string.isBlank(contactToolAccess.MCORE_Platform_of_most_interest3__c))
                            conTMap.get(tool).MCORE_Platform_of_most_interest3__c= contactToolAccess.MCORE_Platform_of_most_interest3__c;
                        if(!string.isBlank(contactToolAccess.MCORE_Purpose_of_MCORE_Access__c))
                            conTMap.get(tool).MCORE_Purpose_of_MCORE_Access__c= contactToolAccess.MCORE_Purpose_of_MCORE_Access__c;
                        //conTListMap.put('Update',conTList[0]);
                        system.debug('conTMap'+conTMap);
                    }
                }else{
                    system.debug('else-part****');
                    Contact_Tool_Access__c conTool = new Contact_Tool_Access__c();
                    conTool.Name = chckToolMap.get(tool).Name;
                    conTool.Portal_Tool_Master__c = tool;
                    conTool.Request_Date__c = system.Now();
                    conTool.Access_Granted_Date__c = reqstatMap.get(tool) == 'Approved'?system.Today():null;
                    conTool.Portal_Honeywell_ID__c = honId;
                    conTool.CRM_Contact_ID__c = conId;
                    conTool.Request_Status__c = reqstatMap.get(tool);
                    if(reqstatMap.get(tool) == 'Approved')
                        conTool.AutoApproveFlag__c = True;
                    if(contactToolAccess!=null){
                        if(!string.isBlank(contactToolAccess.MCORE_Account_Type__c))
                            conTool.MCORE_Account_Type__c = contactToolAccess.MCORE_Account_Type__c;
                        if(!string.isBlank(contactToolAccess.Manager_Name__c))
                            conTool.Manager_Name__c= contactToolAccess.Manager_Name__c;
                        if(!string.isBlank(contactToolAccess.MCORE_Platform_of_most_interest1__c))
                            conTool.MCORE_Platform_of_most_interest1__c = contactToolAccess.MCORE_Platform_of_most_interest1__c;
                        if(!string.isBlank(contactToolAccess.MCORE_Platform_of_most_interest2__c))
                            conTool.MCORE_Platform_of_most_interest2__c= contactToolAccess.MCORE_Platform_of_most_interest2__c;
                        if(!string.isBlank(contactToolAccess.MCORE_Platform_of_most_interest3__c))
                            conTool.MCORE_Platform_of_most_interest3__c= contactToolAccess.MCORE_Platform_of_most_interest3__c;
                        if(!string.isBlank(contactToolAccess.MCORE_Purpose_of_MCORE_Access__c))
                            conTool.MCORE_Purpose_of_MCORE_Access__c= contactToolAccess.MCORE_Purpose_of_MCORE_Access__c;
                        //conTListMap.put('Insert',conTool);
                    }
                    conTListInsert.add(conTool);
                }
            }
            if(conTMap.size() > 0){
                for(Contact_Tool_Access__c  con: conTMap.values()){
                    conTListUpdate.add(con);
                }
                system.debug(logginglevel.info,'conTListUpdate'+conTListUpdate);
                update conTListUpdate;
            }
            if(conTListInsert.size() > 0){
                
                insert conTListInsert;
            }        
        }catch(exception e){
            result.handleException(500, e.getMessage(), e); 
        }
        
        
        
    }
    
    
    /***
Returns the Active contact Address belonging to an input contact id
**/
    public static List<contact_address__c> getActiveContactAddreess(String contactId){
        return [Select contact__c, id, is_primary_address__c from contact_address__c where contact__c= :contactId and (address_status__c = 'active' or is_primary_address__c = true)];
        
    }
    /***
Returns the Account Address belonging to an input account & addrees name combination 
**/
    public static List<account_address__c> getAccountAddreessByAddressName(String accountAddressName,String accountId){
        return [SELECT Id,Address_Name__c,Account_Name__c,name,Report_Address_Line_1__c,Report_Address_Line_2__c,Report_Address_Line_3__c,Report_City_Name__c,Report_Country_Codes__c,Report_Country_Name__c,Report_Postal_Code__c,Report_State_Code__c,Report_State_Name__c From Account_Address__c where  Account_Name__c=:accountId and Address_Name__c=:accountAddressName  ];
        
    }
    /***
Maps the field of Contact Address with value present in Contact.
**/
    public static contact_address__c mapContactAddressWithContact(contact_address__c address,contact ct){
        
        address.reporting_street_address_line_1__c=ct.Address_Line_1__c;
        address.reporting_street_address_line_2__c=ct.Address_Line_2__c;
        address.reporting_street_address_line_3__c=ct.Address_Line_3__c;
        address.reporting_city_name__c=ct.City_Name__c;
        address.reporting_address_postal_code__c=ct.Postal_Code__c ;
        address.reporting_country_name__c=ct.Country_Name__c ;
        address.report_country_codes__c=ct.Country_code__c ;
        address.reporting_address_state_code__c=ct.State_Code__c;
        
        return address;
    }
    /***
Maps the field of Account Address with value present in Contact.
**/
    public static account_address__c mapAccoutAddressFieldsWithContact(account_address__c accountAddressRecord,contact contactRecord){
        
        accountAddressRecord.Address_Type__c='Contact';
        accountAddressRecord.Report_Address_Line_1__c=contactRecord.Address_Line_1__c;
        accountAddressRecord.Report_Address_Line_2__c=contactRecord.Address_Line_2__c; 
        accountAddressRecord.Report_Address_Line_3__c=contactRecord.Address_Line_3__c;
        accountAddressRecord.Report_City_Name__c=contactRecord.City_Name__c;
        accountAddressRecord.Report_Country_Codes__c=contactRecord.Country_Code__c;
        accountAddressRecord.Report_Country_Name__c=(contactRecord.Country_Code__c=='US'?'USA':contactRecord.Country_Name__c);
        accountAddressRecord.Report_Postal_Code__c=contactRecord.Postal_Code__c;
        if(contactRecord.Country_Code__c=='US')
            accountAddressRecord.Report_State_Code__c=contactRecord.State_Code__c;
        
        return accountAddressRecord;
    }
    public static Contact getUpdateRelatedFields(Contact input){
        Contact c=new contact();
        if(input.Id !=null){c.Id=input.Id;}
        if(String.isnotBlank(input.LastName)){c.LastName=input.LastName;}
        if(String.isnotBlank(input.FirstName)){c.FirstName=input.FirstName;}
        if(String.isnotBlank(input.MobilePhone)){c.MobilePhone=input.MobilePhone;}
        if(String.isnotBlank(input.Phone_1_Ext__c)){c.Phone_1_Ext__c=input.Phone_1_Ext__c;}
        if(String.isnotBlank(input.Phone_1__c)){c.Phone_1__c=input.Phone_1__c;}
        
        if(String.isnotBlank(input.Verbal_Security_Passphrase__c)){c.Verbal_Security_Passphrase__c=input.Verbal_Security_Passphrase__c;}
        if(String.isnotBlank(input.Portal_Company_Name__c)){c.Portal_Company_Name__c=input.Portal_Company_Name__c;}
        if(String.isnotBlank(input.Contact_Function__c)){c.Contact_Function__c=input.Contact_Function__c;}
        if(String.isnotBlank(input.Organizational_Level__c)){c.Organizational_Level__c=input.Organizational_Level__c;}
        if(String.isnotBlank(input.Phone_5__c)){c.Phone_5__c=input.Phone_5__c;}
        if(String.isnotBlank(input.Address_Line_1__c)){c.Address_Line_1__c=input.Address_Line_1__c;}
        if(String.isnotBlank(input.Address_Line_2__c)){c.Address_Line_2__c=input.Address_Line_2__c;}
        if(String.isnotBlank(input.Address_Line_3__c)){c.Address_Line_3__c=input.Address_Line_3__c;}
        if(String.isnotBlank(input.City_Name__c)){c.City_Name__c=input.City_Name__c;}
        if(String.isnotBlank(input.Postal_Code__c)){c.Postal_Code__c=input.Postal_Code__c;}
        if(String.isnotBlank(input.State_Code__c)){c.State_Code__c=input.State_Code__c;}
        if(String.isnotBlank(input.Country_Name__c)){c.Country_Name__c=input.Country_Name__c;}
        if(String.isnotBlank(input.Country_Code__c)){c.Country_Code__c=input.Country_Code__c;}
        
        return c;
        
    }
    
    /****
Update  Contact Method used for update Contact API
*******/
    public static REG_Result updateContact(Object contactInfo,String honId){
        System.debug('update contact020519');
        REG_Result result=new REG_Result();
        List<Messaging.SingleEmailMessage> FinalMsgList = new List<Messaging.SingleEmailMessage>();
        Savepoint sp=Database.setSavepoint();
        try{
            Id contactId=REG_PortalContact_Service.getContact(honId);
            if(contactId!=null){
                
                Contact contactRecord=getUpdateRelatedFields((Contact) contactInfo);
                
                //1.0 Populate the data for contact 
                contactRecord.id=contactId;
                if(String.isNotBlank(contactRecord.Phone_1__c))
                    contactRecord.Phone_1__c=REG_PortalContact_Service.convertPhoneNumbersToInputFormat(contactRecord.Phone_1__c);
                if(String.isNotBlank(contactRecord.mobilePhone))
                    contactRecord.mobilePhone=REG_PortalContact_Service.convertPhoneNumbersToInputFormat( contactRecord.mobilePhone);
                if(String.isNotBlank(contactRecord.Phone_5__c))
                    contactRecord.Phone_5__c=REG_PortalContact_Service.convertPhoneNumbersToInputFormat(contactRecord.Phone_5__c);
                System.debug(contactRecord);
                //1.1 Update Contact Record.
                UPDATE contactRecord;
                
                //1.2 Update Contact Address
                if(String.isNotBlank(contactRecord.Address_Line_1__c)){ 
                    List<Contact_Address__c> activeContactAddress=getActiveContactAddreess(contactRecord.id);
                    if(activeContactAddress.size()>0){
                        contact_address__c address= mapContactAddressWithContact(activeContactAddress[0],contactRecord);
                        update address;
                    }
                    
                    //Account Address check
                    //2.0 get Account Id to fetch the 
                    String accountId=REG_PortalContact_Service.GetAccountId(contactRecord.id);
                    if(accountId!=null){
                        
                        //2.1 Create Account Addresss name
                        //String accountAddressName=contactRecord.Address_Line_1__c+' '+contactRecord.City_Name__c+' '+(contactRecord.Country_Code__c=='US'?((String.isBlank(contactRecord.State_Code__c))?'USA':contactRecord.State_Code__c+' USA'):contactRecord.Country_Name__c);
                        String accountAddressName=contactRecord.Address_Line_1__c+' '+contactRecord.City_Name__c+' '+(contactRecord.Country_Code__c=='US'?contactRecord.State_Code__c:'')+' '+(contactRecord.Country_Code__c=='US'?'USA':contactRecord.Country_Name__c);
                        
                        System.debug(accountAddressName);
                        //2.2 Fetch Accpunt Address record
                        List<Account_Address__c> accoutAddressList =getAccountAddreessByAddressName(accountAddressName,accountId);
                        Account_Address__c accountAddressRecord =new Account_Address__c(Account_Name__c=accountId);
                        System.debug(accoutAddressList);
                        System.debug(accountAddressRecord);
                        if(accoutAddressList.size()>0){
                            accountAddressRecord=accoutAddressList[0];
                            System.debug(accountAddressRecord);
                        }
                        accountAddressRecord= mapAccoutAddressFieldsWithContact(accountAddressRecord,contactRecord);
                        
                        
                        upsert accountAddressRecord;
                        
                        
                        
                    }
                    
                }  
                
                result.status='Successfully Updated';
                result.resourceId=contactId;
                
                
            }
            else{
                result.handleError(404, 'Contact not found', 'Contact does not exists with input Honeywell Id');
            }
            
        }catch(Exception e){
            Database.rollback(sp);
            result.handleException(500,e.getMessage(),  e);
            
        }
        
        return result;
    }
    
    /***
* Method to convert the phone number from  (xxx) xxx-xxxx to +1 xxxxxxxxxx format
*/
    public static String convertPhoneNumbersToDisplayFormat(String input){
        if(input!=null&& !String.isBlank(input)){ 
            if(input.contains('(') && input.contains('-') && input.contains(' ') && input.contains(')')){
                input=input.remove('('); input=input.remove('-'); input=input.remove(')');input=input.remove(' ');
                input='+1 '+input;
            }         
        }   
        return input;
        
    }
    public static REG_Result insertSoldToData(List<REG_API_PortalContactTools.soldTosWrappper> soldTos, string honId){
        List<SAP_Contact_Sold_To__c > soldToIdList = new List<SAP_Contact_Sold_To__c >();
        List<Account_Contact__c> accList = new List<Account_Contact__c>();
        List<Account_Contact__c> queryList = new List<Account_Contact__c >();
        SET<Id> accidUnique = new SET<Id>();
        REG_Result result = new REG_Result();
        list<String> soldToToolAcc =  new list<String>();        
        Savepoint sp= Database.setSavepoint();
        try{    
            String conId= REG_PortalContact_Service.getContact(honId); 
            if(string.isBlank(conId)){
                result.handleError(404, 'Contact details not found for the given honeywell id', 'Please provide a valid honeywell id.');
                return result;
            }
            
            for(REG_API_PortalContactTools.soldTosWrappper soldtoAcc :soldTos){
                if(string.isBlank(soldtoAcc.soldToId)){
                    result.handleError(400, 'Please provide Sold to Id', 'Request Body : soldToId is not provided.');
                    return result;                     
                }
                if(string.isBlank(soldtoAcc.soldToToolAccess)){
                    result.handleError(400, 'Please provide soldToToolAccess', 'Request Body : soldToToolAccess is not provided.');
                    return result;                     
                }
                if(soldtoAcc.soldToToolAccess != 'OrdersReturns' && soldtoAcc.soldToToolAccess != 'WarrantyClaims' && soldtoAcc.soldToToolAccess != 'ContractsReporting'){
                    result.handleError(400, 'Please provide correct value for soldToToolAccess', 'Request Body : value of soldToToolAccess can be either OrdersReturns, WarrantyClaims or ContractsReporting.');
                    return result;                
                }
                soldToToolAcc.add(soldtoAcc.soldToToolAccess);
            }
            if(!soldToToolAcc.isEmpty()){               
                soldToIdList=[SELECT Id FROM SAP_Contact_Sold_To__c where Contact__c =:conId and SoldtoToolAccess__c IN :soldToToolAcc];
            }
            else{
                result.handleError(404,'Please provide soldToToolAccess','Request Body : soldToToolAccess is not provided.');
            }
            accList=[SELECT Id FROM Account_Contact__c where Contact__c =:conId and Account_Name__c not in (Select AccountId from Contact where Id =:conId)];
            if(!accList.isEmpty() ){  
                Delete accList;
                accList = new List<Account_Contact__c>();     
            }
            /*if(soldTos == null){
result.handleError(400, 'Request body is missing', 'No input provided to insert SoldTos');
return result;                
}
for(REG_API_PortalContactTools.soldTosWrappper soldtoAcc :soldTos){
soldToToolAcc.add(soldtoAcc.soldToToolAccess);
}
if(!soldToToolAcc.isEmpty()){               
soldToIdList=[SELECT Id FROM SAP_Contact_Sold_To__c where Contact__c =:conId and SoldtoToolAccess__c IN :soldToToolAcc];
}
else{
result.handleError(404,'Request body param is missing','Provide required param in request body');
}*/
            if(!soldToIdList.isEmpty()){
                Delete soldToIdList;
                soldToIdList= new List<SAP_Contact_Sold_To__c >();
            }
            for(REG_API_PortalContactTools.soldTosWrappper scs :soldTos){
                SAP_Contact_Sold_To__c sapConSoldTo = new SAP_Contact_Sold_To__c();                
                /*if(string.isBlank(scs.soldToId)){
result.handleError(400, 'Required Param is missing (SAP_Account_Sold_To__c)', 'Please provide the required inputs');
return result;                     
}*/
                if(scs.soldToId.length() > 7){
                    string lastThreeChar = '';
                    string firstFourChar = '';
                    lastThreeChar = scs.soldToId.substring(scs.soldToId.length() - 3);
                    firstFourChar = scs.soldToId.substring(0, 4);    
                    if(firstFourChar == '0000' && lastThreeChar == '-01'){
                        sapConSoldTo.SAP_Account_Sold_To__c = scs.soldToId;
                    }else{
                        sapConSoldTo.SAP_Account_Sold_To__c = '0000'+scs.soldToId+'-01';
                    }
                }else{
                    sapConSoldTo.SAP_Account_Sold_To__c = '0000'+scs.soldToId+'-01';
                }
                sapConSoldTo.SoldtoToolAccess__c = scs.soldToToolAccess;
                sapConSoldTo.Contact__c = conId;
                sapConSoldTo.Name =  scs.accountName;
                // sapConSoldTo.SoldtoToolAccess__c = 'OrdersReturns';
                soldToIdList.add(sapConSoldTo);
                accidUnique.add(scs.accountId);              
                system.debug(logginglevel.info,'soldToIdList'+soldToIdList);
            }
            if(!soldToIdList.isEmpty()){
                insert soldToIdList;  
                
            }
            system.debug(logginglevel.info,'accidUnique'+accidUnique);
            List<Account_Contact__c> recList = new List<Account_Contact__c>();
            Set<Id> existingAccountLink = new Set<Id>();
            if(!accidUnique.isEmpty()){  
                for(Account_Contact__c accContLink :[select Id,Account_Name__c,Contact__c from Account_Contact__c where Account_Name__c in:accidUnique and Contact__c =:conId]){
                    existingAccountLink.add(accContLink.Account_Name__c);
                }
                //if(queryList.isEmpty()){
                for(Id accId : accidUnique) {
                    if(!existingAccountLink.contains(accId )){
                        Account_Contact__c acconlist = new Account_Contact__c();                
                        acconlist.Account_Name__c = accId;
                        acconlist.Contact__c = conId;
                        recList.add(acconlist);
                    }
                    
                }  
            }     
            if(!recList.isEmpty())   {
                //insert recList;
                Database.SaveResult[] srList = database.insert(recList, false);
                List<string> errFieldlist = new List<string>();   
                for (Database.SaveResult sr : srList){
                    if(!sr.isSuccess()){
                        Database.rollback(sp);
                        for(Database.Error err : sr.getErrors()) {
                            //errFieldlist.add(err.getFields()); 
                            result.handleError(400, 'Incorrect Account Id', err.getMessage());   
                        }
                        //result.handleError(400, 'Incorrect Account Id', 'Errorneous Account Ids are:'+ sr.getMessage());
                        return result;                     
                        
                    }
                }
            }
            result.status='Successfully Inserted';
            result.resourceId=conId;                    
        }catch(exception e){
            Database.rollback(sp);
            result.handleException(500,e.getMessage(),  e);
        }           
        return result;  
    }    
    
    //Delete contact
    public static REG_Result deleteContact(string honId, string userName){
        REG_Result Result = new REG_Result();
        REG_Result conToolData = new REG_Result();
        List<contact> conListNew = new List<contact>();
        List<Id> delIdList = new List<Id>();
        List<Contact_Aircraft__c> conAirList = new List<Contact_Aircraft__c>();
        List<Id> resSerProgList = new List<Id>();
        List<Contact_Tool_Access__c > conToolList = new List<Contact_Tool_Access__c >();
        List<Portal_Honeywell_ID__c> honList = new List<Portal_Honeywell_ID__c>();        
        List<Portal_Honeywell_ID__c> honListNew = new List<Portal_Honeywell_ID__c>();
        List<Account_Contact__c > accConList = new List<Account_Contact__c >();
        List<Id> userAirList = new List<Id>();
        List<SAP_Contact_Sold_To__c> SAPConList = new List<SAP_Contact_Sold_To__c >();
        contact conObjAdm;
        
        Id conId;
        boolean isInternal = false;
        Boolean isCompanyChanged = false;
        List<Messaging.SingleEmailMessage> FinalMsgList = new List<Messaging.SingleEmailMessage>();
        Savepoint sp= Database.setSavepoint();
        try{
            
            Portal_Honeywell_ID__c contactPortalLists = [SELECT Contact__c,Contact_Status__c,Contact__r.AccountId  FROM Portal_Honeywell_ID__c WHERE Name =: honId];
            //conId= REG_PortalContact_Service.getContact(honId); 
            conId = contactPortalLists.Contact__c;
            System.debug('Con Id:'+conId);
            
            if(string.isBlank(conId)){
                //throw new stringException('No data found for Honeywell Id');
                result.handleError(404, 'No data found for Honeywell Id or honeywell Id is already deleted.', 'For the given honeywell Id, contact does not exist or is already deleted');
                return result;
            }
            
            //New change
              /*start of SCTASK2679963*/
           //if(contactPortalLists.Contact_Status__c != 'Inactive'){
                conObjAdm = REG_RegistrationUtility.getAdmilemailData(conId);
           // }
            /*
            else{
                result.handleError(400, 'Bad data', 'Contact Status is inactive');
                return result;
            }
            */
            /*end of SCTASK2679963*/
            
            //System.debug('conObjAdm:'+conObjAdm);
            //System.debug('conObjAdm.Contact_Tool_Access__r:'+conObjAdm.Contact_Tool_Access__r);
            List<Contact> conList=new List<Contact>([SELECT Id,Primary_Email_Address__c,Portal_Temp_Primary_Email__c,Temp_Portal_Company_Name__c,(SELECT Id,Portal_Status__c  from Portal_Honeywell_ID__r WHERE Name =:honId),(select Id from Account_Aircraft__r),(SELECT Id from Contact_Tool_Access__r WHERE Portal_Honeywell_ID__c =:honId),(SELECT Id from SAP_Contact_Sold_To__r),(SELECT Id from Account_Contacts1__r),(SELECT Id from User_Aircraft_Associations__r),(SELECT Id from Restricted_Service_Programs__r) from Contact WHERE Id =:conId]);
            system.debug('con list'+conList);
            String domain = conList[0].Primary_Email_Address__c.substring(conList[0].Primary_Email_Address__c.lastIndexOf('@')+1);
            system.debug('*****domain' +domain);
            list<Account_Email_Domains__c> results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name FROM Account_Email_Domains__c where Account_Email_Domain__c = :Domain];
            if(!results.isEmpty()){
                isInternal = results[0].Internal_Email_Domain__c;
                
            }
            if(isInternal){
                result.handleError(400, 'No action required, since user is Internal', 'Contact will not be deleted if user is internal');
                return result;    
            }
            
            
            for(Contact scs :conList){
                //Contact Object
                Contact conObj = new Contact();
                conObj.Id = scs.id;
                conObj.AccountId =  System.Label.REG_UnidentifiedAccountId;
                conObj.Portal_Encrypted_Verification_Code__c = null;
                
                if(scs.Portal_Temp_Primary_Email__c != null){
                    conObj.Primary_Email_Address__c = scs.Portal_Temp_Primary_Email__c;
                }else{
                    conObj.Primary_Email_Address__c = scs.Primary_Email_Address__c;
                }
                if(scs.Portal_Temp_Primary_Email__c != null){
                    conObj.Email = scs.Portal_Temp_Primary_Email__c;
                }else{
                    conObj.Email = scs.Primary_Email_Address__c;
                }
                conObj.Is_Portal_Super_User__c =  false;
                conObj.All_Aircrafts__c =  false;
                conObj.Assigned_Aircrafts__c =  false;
                conObj.Has_Restriction__c =  false;
                conObj.Access__c =  null;
                conObj.Temp_Portal_Company_Name__c =  null;
                conObj.Portal_Temp_Primary_Email__c =  null;
                conListNew.add(conObj);
                system.debug('****conListNew'+conListNew);
                
                //portal Honeywell Id object
                for(Portal_Honeywell_ID__c honObj : scs.Portal_Honeywell_ID__r){
                    // Portal_Honeywell_ID__c honObj = portalHonewellMap.get(scs.Id);
                    //  system.debug('map data:'+portalHonewellMap.get(scs.Id));
                    honObj.Primary_Honeywell_ID__c =  false;
                    if(scs.Portal_Temp_Primary_Email__c == null && scs.Temp_Portal_Company_Name__c == null){
                        honObj.Portal_Status__c = 'Deleted';
                    }
                    if(scs.Portal_Temp_Primary_Email__c != null || scs.Temp_Portal_Company_Name__c != null){
                        honObj.Delete_Contact_ID__c = conId;
                        isCompanyChanged = true;
                    }
                    if(scs.Portal_Temp_Primary_Email__c != null){
                        honObj.Email_Address__c = scs.Portal_Temp_Primary_Email__c;
                    }
                    honObj.Claims_Admin__c =  false;
                    honObj.contracts_admin__c =  false;
                    honObj.Dynamic_Catalog_Admin__c =  false;
                    honObj.Tech_Pubs_Admin__c =  false;
                    honObj.Deleted_By__c = userName;
                    honListNew.add(honObj);                
                }
            }
            
            if(!conListNew.isEmpty()){
                update conListNew;    
            }        
            
            if(!honListNew.isEmpty()){
                update honListNew;    
            }
            //delete Ids
            for (Contact relObj : conList) {
                for (Restricted_Service_Program__c copy5 : relObj.Restricted_Service_Programs__r) {
                    resSerProgList.add(copy5.Id);
                }  
                for (Contact_Aircraft__c copy : relObj.Account_Aircraft__r) {
                    conAirList.add(copy);
                }
                for (Contact_Tool_Access__c copy1 : relObj.Contact_Tool_Access__r) {
                    conToolList.add(copy1);
                }
                for (Account_Contact__c copy3 : relObj.Account_Contacts1__r) {
                    accConList.add(copy3);
                }
                for (User_Aircraft_Association__c copy4 : relObj.User_Aircraft_Associations__r) {
                    userAirList.add(copy4.Id);
                }
                
                for (SAP_Contact_Sold_To__c copy2 : relObj.SAP_Contact_Sold_To__r) {
                    SAPConList.add(copy2);
                }
            }
            
            if(!delIdList.isEmpty()){
                system.debug('****delIdList*****'+delIdList);
                //List<Contact> delObjs = [SELECT Id FROM Contact WHERE Id IN:delIdList];
                //delete delObjs;  
                database.delete(delIdList);
                
            }
            system.debug('SAPConList' +SAPConList);
            if(!SAPConList.isEmpty()){
                delete SAPConList;
            }
            system.debug('resSerProgList' +resSerProgList);
            if(!resSerProgList.isEmpty()){
                database.delete(resSerProgList,false);
            }
            if(!conAirList.isEmpty()){
                delete conAirList;
            }
            if(!conToolList.isEmpty()){
                delete conToolList;
            }
            if(!accConList.isEmpty()){
                delete accConList;
            }
            if(!userAirList.isEmpty()){
                database.delete(userAirList,false);
            }                                                
            
            //change for admin to email delete contact:03-05-19
            if(isCompanyChanged){
                FinalMsgList  = REG_RegistrationUtility.getEmailMetaData(conObjAdm,conObjAdm.Contact_Tool_Access__r , 'Email_Change_Activate','');
                System.debug('FinalMsgList:'+FinalMsgList);
            }else{
                FinalMsgList  = REG_RegistrationUtility.getEmailMetaData(conObjAdm,conObjAdm.Contact_Tool_Access__r , 'Super_User_Delete','');
                System.debug('FinalMsgList1:'+FinalMsgList);
            }  
            if(FinalMsgList.size() > 0){
                Messaging.SendEmailResult[] results1 = Messaging.sendEmail(FinalMsgList);
                system.debug('inside result1');
            }
           
            result.status='Success';
            result.resourceId=conId;
            REG_Resource finalData = new REG_Resource(isInternal);
            result.data = finaldata;  
                             
        }catch(exception e){
            Database.rollback(sp);
            result.handleException(400,e.getMessage(),  e);
        }  
        
        return result;
    }
    
    public class REG_Resource{
        String contactId{get;set;}
        String honId{get;set;}
        String toolId{get;set;}
        String toolStatus{get;set;}
        String message{get;set;}
        Boolean isInternal{get;set;}
        List<toolsWrap> tools{get;set;}
        public REG_Resource(Contact c,List<toolsWrap> tools){
            this.contactId=c.id;
            this.honId=c.Honeywell_ID__c;
            this.isInternal=c.Contact_Is_Employee__c;
            this.tools=tools;
            
        }
        
        public REG_Resource(boolean isInternal) {
            this.isInternal=isInternal;
            
        }
        public REG_Resource(string honId, string conId,List<toolsWrap> tools,boolean isInternal) {
            this.contactId=conId;
            this.honId = honId;
            this.tools=tools;
            this.isInternal = isInternal;
        }  
        public REG_Resource(string toolId, string message,string toolStatus) {
            this.toolId = toolId;
            this.toolStatus = toolStatus;
            this.message=message;
        }  
        
    }
    public class toolsWrap{
        String toolId{get;set;}
        String status{get;set;}
        public toolsWrap(String toolId,String status){
            this.toolId=toolId;
            this.status=status;
        }
    }
    
    
    public class REG_AccountMessage_Wrapper{
        
        //public REG_AccountMessage_Wrapper(){}
        public REG_AccountMessage_Wrapper(String AccountId, String PortalSignInMessage){
            this.AccountId = AccountId;
            this.PortalSignInMessage = String.isNotBlank(PortalSignInMessage)?PortalSignInMessage:''; 
            
        }
        String AccountId;
        String PortalSignInMessage;
    }    
    
    public static REG_Result getContactbyHonIdList(list<String> honIdList){
        REG_Result result = new REG_Result();
        try{
            system.debug('honIdList****' +honIdList);
            if(honIdList.size()>1000){
                result.handleError(400, 'At a time only 1000 records can be queried', 'Please provide list  of honeywell Id less than 1000');
                return result;
            }
            list<Portal_Honeywell_ID__c> contactDetails = [select Contact__r.FirstName,Contact__r.LastName,Contact__r.Email,Name,Contact__r.Account.Portal_Permissioned_Content__c from Portal_Honeywell_ID__c where Name in :honIdList AND (portal_status__c = 'Active' or portal_status__c = '')];
            system.debug('contactDetails***'  +contactDetails);
            list<REG_bulkDetailOutputWrapper> conDetails = new list<REG_bulkDetailOutputWrapper>();
            system.debug('conDetails***' +conDetails);
            if(!contactDetails.isEmpty()){
                for(Portal_Honeywell_ID__c phi:contactDetails){
                    REG_bulkDetailOutputWrapper bulkDetails = new REG_bulkDetailOutputWrapper(phi);
                    conDetails.add(bulkDetails);
                }
                result.data = conDetails;//contactDetails;
                
            }else{
                result.handleError(404, 'No data found', 'No data found for provided honeywell Id');
                return result;
            }
            
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
        }
        return result;
    }
    
    //wrapper class
    Public class REG_bulkDetailOutputWrapper{
        String firstName;
        String lastName;
        String email;
        String honeywellId;
        String portalPermissionedContent;
        
        Public REG_bulkDetailOutputWrapper(Portal_Honeywell_ID__c conDetails){
            this.firstName = conDetails.Contact__r.FirstName;
            this.lastName  = conDetails.Contact__r.LastName;
            this.email = conDetails.Contact__r.Email;
            this.honeywellId = conDetails.Name;
            this.portalPermissionedContent = conDetails.Contact__r.Account.Portal_Permissioned_Content__c;
        }
    }
    
}