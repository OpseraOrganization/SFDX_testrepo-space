/** * File Name: REG_PortalUser_Service

* Description  logics regarding Portal Honeywell object

* * @author : TCS 

Date 01/18/2019 

* */

public with sharing class REG_PortalUser_Service{
    
    public static REG_Result updatePortalHoneywellIdObject(Object portalHonObj, string honId){
        REG_Result result=new REG_Result();
        List<Portal_Honeywell_ID__c> porHonList = new List<Portal_Honeywell_ID__c>(); 
        system.debug('****portalHonObj'+portalHonObj);
        try{
            Portal_Honeywell_ID__c porHonIdObj = (Portal_Honeywell_ID__c ) portalHonObj;
            if(porHonIdObj != null){
                porHonList = [Select Id FROM Portal_Honeywell_ID__c WHERE Name =:honId AND Primary_Honeywell_ID__c =: true];
                system.debug('****porHonIdObj '+porHonIdObj );
                if(porHonList.isEmpty() ){
                    //throw new stringException('No data found for given Honeywell Id');
                    result.handleError(404, 'No data found', 'No data found for given honeywell Id');
                    return result;
                }
                porHonIdObj.Id =  porHonList[0].Id; 
                update porHonIdObj ;
                result.resourceId = porHonIdObj.Id;
                result.status = 'success'; 
            }
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
        } 
              
        return result;
    }
    
    public static REG_Result getUserStatus(String hon_ID, string Email){
        REG_Result result = new REG_Result();
        String domain = '';
        Boolean isRequired;
        List<Account_Email_Domains__c> internalUser = new List<Account_Email_Domains__c>();
        try{    
            List<contact> users =  [SELECT Honeywell_ID__c,Account_Name__c, AccountId, Contact_Status__c, Alternate_Email_Address__c, Attention__c, Birth_City__c, Birthdate, Citizenship_Country__c, Contact_Birth_Country__c, Contact_Function__c, Fax, FirstName, Id, Is_Portal_Super_User__c, Is_US_Citizen__c, Job_Title__c, LastName, Market__c, Middle_Name__c, Middle_Name_not_Available__c, MobilePhone, Name, Permanent_Resident_Expiration_Date__c, Permanent_USA_Resident__c, Phone_1__c, Phone_1_Ext__c, Primary_Email_Address__c, Portal_Temp_Primary_Email__c,Temp_Portal_Company_Name__c, Product_Updates__c, Portal_Company_Name__c, Salutation, Suffix__c, Organizational_Level__c, Account.ATR_Portal_Access_Template__c, Employee_Number__c,Contact_Is_Employee__c,Email,Verbal_Security_Passphrase__c,
                                    (SELECT Id,Name,Contact__c,Email_Sent_Counter__c,Portal_Last_Accessed_Date__c,Portal_Status__c,Primary_Honeywell_ID__c,User_Type__c,Claims_Admin__c,contracts_admin__c,Dynamic_Catalog_Admin__c,Tech_Pubs_Admin__c,Delete_Contact_ID__c FROM Portal_Honeywell_ID__r WHERE Name = :hon_ID),
                                    (SELECT Id,Address_Type__c,Report_Country_Codes__c,Reporting_Address_Postal_Code__c,Reporting_Address_State_Code__c,Reporting_City_Name__c,Reporting_Country_Name__c,Reporting_Street_Address_Line_1__c,Reporting_Street_Address_Line_2__c,Reporting_Street_Address_Line_3__c,Is_Primary_Address__c,Address_Postal_Code__c , Address_State_Code__c, City_Name__c,Country_Name__c  FROM Contact_Addresses__r WHERE Is_Primary_Address__c = true AND Address_Status__c = 'Active') 
                                    FROM Contact WHERE Contact_Status__c != 'Inactive' and Id IN 
                                    (SELECT Contact__c FROM Portal_Honeywell_ID__c WHERE Name =:hon_ID)];
            
            system.debug(LoggingLevel.Info,'user ***'+users);
            if(String.isNotEmpty(Email)){
                system.debug(LoggingLevel.Info,'email ***'+Email);
                integer d = Email.lastIndexOf('@');
                system.debug(LoggingLevel.Info,'domain ***'+d);
                //start changed by saurabh for SCTASK2892063
                //string emailRegex = '^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
                
                string emailRegex = '^[a-zA-Z0-9._+\'-]+@[a-zA-Z0-9.\'-]+\\.[a-zA-Z]{2,255}$';
                //end changed by saurabh for SCTASK2892063
                Pattern MyPattern = Pattern.compile(emailRegex);
                Matcher MyMatcher = MyPattern.matcher(Email);
                system.debug(LoggingLevel.Info,'emailRegex ***' + emailRegex);
                system.debug('##### validEmail : '+ Email + ' -- '+ MyMatcher.matches() );
                
                if(MyMatcher.matches()){
                    domain = Email.substring(d+1);
                    if(string.isBlank(domain)){
                        result.handleError(400, 'Invalid email Id', 'Please provide Email Id in correct format');
                        return result;               
                    }else{
                        domain = Email.substring(d+1);
                        internalUser = [SELECT Internal_Email_Domain__c FROM Account_Email_Domains__c WHERE Account_Email_Domain__c = :domain];
                    }
                }
                else{
                    //system.debug(LoggingLevel.Info,'internalUser ***'+internalUser[0].Internal_Email_Domain__c);
                    result.handleError(400, 'Invalid email Id', 'Please provide Email Id in correct format');
                    return result;               
                }
            }
            //code for revalidationflag
            if(users.size()>0 && !users[0].Portal_Honeywell_ID__r.isEmpty()){
                Decimal emailSentCounter = users[0].Portal_Honeywell_ID__r[0].Email_Sent_Counter__c; 
                if(emailSentCounter>0){
                    isRequired = true;
                }else{
                    isRequired = false;
                }
            }
            
            //system.debug(LoggingLevel.Info,'user email***'+users[0].Primary_Email_Address__c);
            if(!users.isEmpty()){
                
                
                List<Portal_Honeywell_ID__c> porHonIdList = new List<Portal_Honeywell_ID__c>();
                List<Contact_Address__c > conAddList = new List<Contact_Address__c >();
                List<Contact_Address__c > conListelse = new List<Contact_Address__c >();
                porHonIdList.add(users[0].Portal_Honeywell_ID__r);
                List<Account_Address__c> userStatus = [select Denied_Party_Status__c,Account_Name__r.License__c,
                                                       Account_Name__r.License_Valid_Date__c from Account_Address__c where Account_Name__c =:users[0].AccountID and 
                                                       Denied_Party_Status__c = 'Blocked'];
                for(Contact_Address__c conAddType : users[0].Contact_Addresses__r){
                    if(conAddType.address_type__c == 'Office'){
                        conAddList.add(conAddType);
                    }else{
                        conListelse.add(conAddType);
                    }
                }
                system.debug('conAddList' +conAddList);
                //for multiple office address
                if(!conAddList.isEmpty()){
                    system.debug('inside if_____!');
                    REG_PortalUser_Wrapper porUserWrap1 = new REG_PortalUser_Wrapper(users[0],porHonIdList, conAddList,userStatus,domain,isRequired,internalUser);
                    result.Data = porUserWrap1;
                    return result; 
                    
                }
                //for multiple contact adress(without office)
                else if(!conListelse.isEmpty()){
                    
                    REG_PortalUser_Wrapper porUserWrap = new REG_PortalUser_Wrapper(users[0],porHonIdList, conListelse,userStatus,domain,isRequired,internalUser);
                    result.Data = porUserWrap;
                    return result;
                }
                //No primary contact address
                else{
                REG_PortalUser_Wrapper porUserWrap = new REG_PortalUser_Wrapper(users[0],porHonIdList, conAddList,userStatus,domain,isRequired,internalUser);
                system.debug('porUserWrap '+porUserWrap);
                result.Data = porUserWrap ;
                }
            }else{
                
                REG_PortalUser_Wrapper pUserWrap = new REG_PortalUser_Wrapper(internalUser);
                pUserWrap.honeywellID = hon_ID; 
                result.Data = pUserWrap;
            }
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
        }                
        return result;
    }
    
    public static REG_Result emailChange(string honId, REG_API_PortalUser.inputwrapper reqdata){
        
        Id conId;
        contact conInitiate = new contact();
        boolean isInternal = false;
        conId =   REG_PortalContact_Service.getContact(honId);
        system.debug('conId' +conId);
        boolean isDomainChanged = false;
        REG_Result Result = new Reg_Result();
        Savepoint sp= Database.setSavepoint();
        try{    
            if(string.isBlank(conId)){
                result.handleError(404,'No data found for given Honeywell ID: ' + honid,'Provide valid Honeywell ID to fetch contact detail');
                return result;
            } 
            List<contact> contactList = [select Primary_Email_Address__c,Portal_Temp_Primary_Email__c ,Temp_Portal_Company_Name__c, 
                                         (SELECT Id,Name,Contact__c,Portal_Last_Accessed_Date__c,Portal_Status__c,Primary_Honeywell_ID__c,User_Type__c,Claims_Admin__c,contracts_admin__c,Dynamic_Catalog_Admin__c,Tech_Pubs_Admin__c from Portal_Honeywell_ID__r WHERE Name =: honId) 
                                         from contact where Id =:conId];
            String domain = contactList[0].Primary_Email_Address__c.substring(contactList[0].Primary_Email_Address__c.lastIndexOf('@')+1);
            system.debug('*****domain' +domain);
            list<Account_Email_Domains__c> results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name FROM Account_Email_Domains__c where Account_Email_Domain__c = :Domain];
            if(!results.isEmpty()){
                isInternal = results[0].Internal_Email_Domain__c;
            }
            if(reqdata.requestType == 'initiate'){
                if(isInternal){
                    result.handleError(400, 'No action required, since user is Internal', 'Email-Change will not be initiated');
                    return result;    
                }            
                if(string.isBlank(reqdata.newEmail)){
                       
                    result.handleError(404,'Param : \"newEmail\" is not provided ' ,'newEmail is mandatory parameter.');
                    return result;
                    
                }            
                if(contactList[0].Primary_Email_Address__c == reqdata.newEmail ){
                    result.handleError(400,'New and old emails are same and no change required' ,'New and Old emails should be different');
                    return result;
                }
                result = emailChangeInitiate(conId, reqData.newEmail);
                
            } 
            
            if(reqdata.requestType == 'cancel'){
                if(string.isBlank(contactList[0].Portal_Temp_Primary_Email__c)){
                    result.handleError(400,'There is no active email change request available to cancel' ,'There is no active email change request available to cancel');    
                    return result;
                }
                conInitiate.Id = conId;
                conInitiate.Portal_Temp_Primary_Email__c  = null;
                conInitiate.Temp_Portal_Company_Name__c = null;  
                if(coninitiate != null ){
                    update conInitiate;
                }
                result.status = 'success';
                result.resourceid = conid;
            }
            
            if(reqdata.requestType == 'validate'){
                if(string.isBlank(reqdata.newEmail)){
                    //throw new stringException('Param : \"newEmail\" is not provided"');
                    result.handleError(404,'Param : \"newEmail\" is not provided ' ,'newEmail is mandatory parameter.');
                    return result;
                }
                if(string.isBlank(reqdata.oldEmail)){
                    //throw new stringException('Param : \"oldEmail\" is not provided"');
                    result.handleError(404,'Param : \"oldEmail\" is not provided ' ,'oldEmail is mandatory parameter.');
                    return result;
                }  
                
                if(contactList[0].Primary_Email_Address__c != reqdata.oldEmail){
                    result.handleError(400,'Old email does not match our records. Please provide correct old email' ,'oldEmail is incorrect');
                    return result;
                }                      
                isDomainChanged = emailChangeValidate(conId, reqData);
                
                result.status = 'success';
                result.resourceid = conid;
                emailChangeWrapper finalData = new emailChangeWrapper(isDomainChanged, null) ;
                result.data = finalData;      
            }
            if(reqdata.requestType == 'activate'){
                if(isInternal){
                    result.handleError(400, 'No action required, since user is Internal', 'Email-Change will not be activated');
                    return result;    
                }                   
                result = emailChangeActivate(honId, conId, reqData);
                REG_PortalContact_Service.REG_Resource finalData = new REG_PortalContact_Service.REG_Resource(isInternal);
                result.resource = finalData;
            }
        }catch(exception e){
            Database.rollback(sp);
            result.handleException(500, e.getMessage(), e);
        }       
        return result;
    }
    
    
    public static boolean emailChangeValidate(string conId, REG_API_PortalUser.inputwrapper reqdata ){
        
        String newDomain = reqdata.newEmail.substring(reqdata.newEmail.lastIndexOf('@') +1);
        String oldDomain = reqdata.oldEmail.substring(reqdata.oldEmail.lastIndexOf('@') +1);
        boolean oldDomRec =false;
        boolean newDomRec =false;
        boolean isGeneric = false;
        boolean isMatch = false;
        boolean isDomainChanged = false;
        List<Account_Email_Domains__c> oldDomList =[ SELECT Account__c FROM Account_Email_Domains__c WHERE Account_Email_Domain__c =: oldDomain];
        List<Account_Email_Domains__c> newDomList =[ SELECT Account__c FROM Account_Email_Domains__c WHERE Account_Email_Domain__c =: newDomain];
        Set<Id> accIdSet = new set<Id>();
        Map<string,Account_Email_Domains__c > domMap = new Map<string,Account_Email_Domains__c>();
        if(!oldDomList.isempty() ){
            oldDomRec =true;
            accIdSet.add(oldDomList[0].account__c);
        }
        if(!newDomList.isempty() ){
            newDomRec =true;
        }
        system.debug('oldDomRec' +oldDomRec);
        system.debug('newDomRec' +newDomRec);        
        List<contact> conList = [SELECT AccountId,Account.ATR_Portal_Access_Template__c FROM Contact WHERE Id =: conId];
        account acc = [select name,ATR_Portal_Access_Template__c from account where id = :conList[0].accountId];
        system.debug('****acc' +acc);
        system.debug(' conList[0].Account.ATR_Portal_Access_Template__c' + conList[0].Account.ATR_Portal_Access_Template__c);
        if( (!string.isBlank(conList[0].Account.ATR_Portal_Access_Template__c))&& (REG_Is_Generic__c.getValues('Is Generic').Id__c.contains(conList[0].Account.ATR_Portal_Access_Template__c))){ 
            
            isGeneric =true;
        } 
        system.debug(' isGeneric' + isGeneric);
        
        accIdSet.add(conList[0].accountId);
        List<Account_Email_Domains__c> domList = [SELECT Account_Email_Domain__c FROM Account_Email_Domains__c WHERE Account__c IN :accIdSet];          
        for(Account_Email_Domains__c aeD: domList){
            domMap.put(aeD.Account_Email_Domain__c , aeD );    
        }
        if(domMap.containsKey(newDomain)){
            isMatch =true;    
        }
        system.debug(' isMatch ' + isMatch );
        // boolean oldDomRec =    
        if(oldDomRec){
            if(newDomRec){
                if(!isMatch){
                    isDomainChanged = true;    
                }else{
                    isDomainChanged = false;
                }
                system.debug('isDomainChanged1 ' +isDomainChanged);
            }else
                if(!newDomRec){
                    isDomainChanged = true;  
                }
            system.debug('isDomainChanged2 ' +isDomainChanged);
        }else
            if(!oldDomRec){
                if(isGeneric ){
                    if(newDomRec){
                        isDomainChanged = true; 
                    }else{
                        isDomainChanged = false; 
                    } 
                    system.debug('isDomainChanged3 ' +isDomainChanged);
                }else
                    if(!isGeneric ){
                        if(!isMatch){
                            isDomainChanged = true; 
                        }else{
                            isDomainChanged = false; 
                        }
                        system.debug('isDomainChanged4 ' +isDomainChanged);
                    }
            }
        return isDomainChanged;  
    }
    
    public static REG_Result emailChangeInitiate(string conId, string reqdata ){
        contact conInitiate = new contact();
        REG_Result result = new REG_result();
        conInitiate.Id = conId;
        coninitiate.Portal_Temp_Primary_Email__c = reqdata;
        system.debug('reqdata+' +reqdata);
        if(coninitiate != null ){
            system.debug('coninitiate+' +coninitiate);
            update conInitiate;
        }
        result.status = 'success';
        result.resourceid = conid;    
        return result;
        
    }
    
    public static REG_Result emailChangeActivate(string honId, string conId, REG_API_PortalUser.inputwrapper reqdata ){
        
        boolean isDomainChanged = false;
        REG_Result deleteResult = new REG_Result();
        contact con = new contact();
        Portal_Honeywell_ID__c porHon = new Portal_Honeywell_ID__c();
        //List<contact> contactList = new List<contact>(); 
        object conObj;
        object errObj;
        reg_result result = new REG_result();
        List<contact> conData = new List<contact>();
        List<Messaging.SingleEmailMessage> FinalMsgList = new List<Messaging.SingleEmailMessage>();
        List<contact> conList = [select Primary_Email_Address__c,Portal_Temp_Primary_Email__c ,Temp_Portal_Company_Name__c, 
                                 (SELECT Id,Name,Contact__c,Portal_Last_Accessed_Date__c,Portal_Status__c,Primary_Honeywell_ID__c,User_Type__c,Claims_Admin__c,contracts_admin__c,Dynamic_Catalog_Admin__c,Tech_Pubs_Admin__c from Portal_Honeywell_ID__r WHERE Name =: honId) 
                                 from contact where Id =:conId ];  
        system.debug('conList[0].Temp_Portal_Company_Name__c ' +conList[0].Temp_Portal_Company_Name__c);
        if(conList[0].Temp_Portal_Company_Name__c  != null){
            isDomainChanged = true;
            system.debug('isDomainChanged' +isDomainChanged);
        }else{
            if(string.isBlank(conList[0].Portal_Temp_Primary_Email__c) ){
                //throw new stringException('Please Initiate before activating.');
                result.handleError(400,'Please Initiate before activating.' ,'Email Change needs to \"initiate\" first');
                return result;
            }else{
                reqData.newEmail = conList[0].Portal_Temp_Primary_Email__c;
            }
            reqData.oldEmail = conList[0].Primary_Email_Address__c;
            isDomainChanged = emailChangeValidate(conId, reqData);
             system.debug('isDomainChanged***** ' +isDomainChanged );
        }
        if(isDomainChanged ){
            //call delete contact API
            system.debug('isDomainChanged ' +isDomainChanged );
            system.debug(LoggingLevel.Info,'calling delete contact api');
            deleteResult = REG_PortalContact_Service.deleteContact(honId, null);
            if(deleteResult.statusCode != 200){
                errObj = deleteResult.Error;
                
                system.debug(logginglevel.info,'errObj' +errObj);
                Map<string,object> RegErrMap = new Map<string,object>();
                RegErrMap = (Map<string,object>) errObj;
                Object RegErrObj = RegErrMap.get('error');
                REG_Error RegErr = (REG_Error) RegErrObj;
                system.debug(logginglevel.info,'RegErr' +RegErrMap);
                system.debug(logginglevel.info,'RegErr1' +RegErrMap.get('error'));
                result.handleError(RegErr.errorCode, RegErr.errorMessage, RegErr.errorDescription);
                return result;                
            }
        }else{ 
            //preparing email body 
            contact conObjAdm = REG_RegistrationUtility.getAdmilemailData(conId);
            //string subject = 'User Email Address Changed: Review/Revoke Tool Access';
            FinalMsgList  = REG_RegistrationUtility.getEmailMetaData(conObjAdm,conObjAdm.Contact_Tool_Access__r , 'Email_Change_Activate','');
            //contact and portal honeywell id object update
            con.Id = conId;
            con.Portal_Encrypted_Verification_Code__c = null;
            con.Primary_Email_Address__c = conList[0].Portal_Temp_Primary_Email__c ;
            con.Email = conList[0].Portal_Temp_Primary_Email__c ;
            con.Portal_Temp_Primary_Email__c = null;
            if(con != null){
                update con;
            }
            porHon.Id = conList[0].Portal_Honeywell_ID__r[0].Id;
            porHon.Portal_Last_Updated_Date__c = system.now();
            porHon.Email_Address__c= conList[0].Portal_Temp_Primary_Email__c ;
            if(porHon != null){
                update porHon;
            }
        }
        if(FinalMsgList.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(FinalMsgList);
        }
       // system.debug(logginglevel.info,'success'+ results);
               
        conObj = REG_PortalContact_Service.getContactDetail(honId).data;
        system.debug('conObj '+ conObj );
        conData = (List<contact>) conObj;
        result.status = 'success';
        //result.resourceid = conid;
        emailChangeWrapper finalData = new emailChangeWrapper(isDomainChanged, conData[0]) ;
        result.data = finalData;
        return result;    
    }  
    
    public static REG_result companyChange(REG_API_PortalUser.emailChangeWrapper emChngWrpr,string honId ){
        
        Id conId;
        boolean isInternal = false;
        contact conObj = new contact();
        REG_result updateProfile = new REG_result();
        REG_result companyInitiate= new REG_result();
        REG_result companyActivate = new REG_result();
        REG_result result= new REG_result();
        system.debug('emChngWrpr'+emChngWrpr);
        Savepoint sp= Database.setSavepoint();
        try{    
            //get contact id from given honeywell id
            conId = REG_PortalContact_Service.getContact(honId);
            List<contact> conList = [select Primary_Email_Address__c from contact where id = :conId];
            if(!conList.IsEmpty()){
            //check if user is internal
            String domain = conList[0].Primary_Email_Address__c.substring(conList[0].Primary_Email_Address__c.lastIndexOf('@')+1);
            system.debug('*****domain' +domain);
            list<Account_Email_Domains__c> results = [SELECT Account_Email_Domain__c,Internal_Email_Domain__c,Name FROM Account_Email_Domains__c where Account_Email_Domain__c = :Domain];
            if(!results.isEmpty()){
                isInternal = results[0].Internal_Email_Domain__c;
            }
            if(isInternal){
                result.handleError(400, 'No action required, since user is Internal', 'No changes done');
                return result;    
            }  
            }  else{
                result.handleError(404, 'Contact not found', 'Contact does not exists with input Honeywell Id');
                return result;    
            }
            //update profile
            updateProfile = REG_PortalContact_Service.updateContact(emChngWrpr.contact,honId);       
            if(!string.isBlank(conId)){
                conObj.Id = conId;
                system.debug('emChngWrpr.contact.Temp_Portal_Company_Name__c' +emChngWrpr.contact.Portal_Company_Name__c);
                if(!string.isBlank(emChngWrpr.contact.Portal_Company_Name__c))
                    conObj.Temp_Portal_Company_Name__c = emChngWrpr.contact.Portal_Company_Name__c; 
                if(conObj != null){
                    update conObj;
                }
                system.debug('conObj' +conObj);
                if((emChngWrpr.isEmailChange == true) && (!string.isBlank(emChngWrpr.contact.email))){
                    //REG_API_PortalUser  = new REG_API_PortalUser();
                    system.debug('inside isEmailChange true');
                   
                    if(conList[0].Primary_Email_Address__c  == emChngWrpr.contact.email){
                        Database.rollback(sp);
                        result.handleError(400,'New and old emails are same and no change required' ,'New and Old emails should be different');
                        return result;
                        
                    }
                    companyInitiate =  emailChangeInitiate(conId,emChngWrpr.contact.email);
                    system.debug('companyInitiate  ' +companyInitiate);
                }else
                    if(emChngWrpr.isEmailChange == false){
                        system.debug('inside isEmailChange false');
                        REG_API_PortalUser.inputWrapper reg = new REG_API_PortalUser.inputWrapper();
                        companyActivate = emailChangeActivate(honId, conId, reg);
                    }else{
                        Database.rollback(sp);
                        result.handleError(400, 'param \"emailId\" missing from request body', 'emailId is mandatory input if isEmailChange is true');
                    }   
            }else{
                Database.rollback(sp);
                result.handleError(404, 'Contact not found', 'Contact does not exists with input Honeywell Id');
            }
        }catch(exception e){
            Database.rollback(sp);
            result.handleException(500, e.getMessage(), e);        
        }    
        result.status = 'success';
        result.resourceId = conId;
        return result;
    } 
    
    public static REG_Result getPortalPermission(String honID){
        REG_Result result = new REG_Result();
        list<String> roles = new  list<String>();
        list<Id> accConId  =  new list<Id>();
        list<account> relatedAccounts = new list<account>();
        Set<string> sblAccountRowIdSet = new Set<string>();
        List<Account_Email_Domains__c> internalUser = new List<Account_Email_Domains__c>();
        String accId = '';
        String primaryAccSblId = '';
        try{
            if(String.isNotBlank(honID)){
                //code to check inactive status
                REG_Result conDetail= REG_PortalContact_Service.getContactforHid(honId);
            list<Portal_Honeywell_ID__c> listPhi  = (list<Portal_Honeywell_ID__c>) conDetail.Data;
               if(listPhi != null)
                if(listPhi[0].Contact_Status__c == 'Inactive'){
                   result.handleError(400, 'Bad Data', 'Contact Status is inactive');
                    return result;
                }
                
                String conId = REG_PortalContact_Service.getContact(honID);
                list<contact> conInfo = [select Id, EMAIL, AccountID, FirstName, LastName, Portal_Company_Name__c,Primary_Email_Address__c, contact.Address_Line_1__c, contact.Address_Line_2__c,
                                         (select id, Account_Name__c from Account_Contacts1__r) from contact where id = :conId];
                System.debug(LoggingLevel.Info, 'conInfo ***'+conInfo);

                if(!conInfo.IsEmpty()){
                    String emailId = conInfo[0].Primary_Email_Address__c;
                    String domain = emailId.substring(emailId.lastIndexOf('@') +1);
                    //checking if user is internal
                    internalUser = [SELECT Internal_Email_Domain__c FROM Account_Email_Domains__c WHERE Account_Email_Domain__c = :domain];                
                    accId = conInfo[0].AccountID;
                    System.debug(LoggingLevel.Info, 'accId ***'+accId);
                    //fetching portal permission content
                    account porContent = [select id, name, Sbl_Account_Row_Id__c ,Portal_Permissioned_Content__c from account where id = :accId];
                    System.debug(LoggingLevel.Info, 'porContent ***'+porContent);
                    if(String.isNotBlank(porContent.Portal_Permissioned_Content__c))
                    roles = porContent.Portal_Permissioned_Content__c.split(';');
                    if(String.isNotBlank(porContent.Sbl_Account_Row_Id__c))
                     primaryAccSblId = porContent.Sbl_Account_Row_Id__c; 
                    //getting related accounts
                    for(contact c : conInfo){
                        for(Account_Contact__c ac : c.Account_Contacts1__r){
                        accConId.add(ac.Account_Name__c);
                        }
                       
                    }
                    //accConId = conInfo[0].Account_Contacts1__r[0].Account_Name__c;
                    System.debug(LoggingLevel.Info, 'accConId ***'+accConId);
                    if(String.isNotBlank(porContent.Sbl_Account_Row_Id__c)){
                        sblAccountRowIdSet.add(porContent.Sbl_Account_Row_Id__c);  
                    }
                    //getting crmId for related accounts
                    if(!accConId.isEmpty()){
                        relatedAccounts = [select Sbl_Account_Row_Id__c from account where id IN :accConId];
                        for(account acc: relatedAccounts){
                            sblAccountRowIdSet.add(acc.Sbl_Account_Row_Id__c);    
                        }
                       }
                    REG_PortalPermission_Wrapper porWrap = new REG_PortalPermission_Wrapper(honID,conId,roles,sblAccountRowIdSet,internalUser,primaryAccSblId);
                    result.data =  porWrap;
                }else{
                    result.handleError(404, 'No data found', 'No record found for given honeywell ID');
                }
                
            }else{
                result.handleError(400, 'Honeywell ID not found', 'Provide Honeywell ID');
            }
        }catch(exception e){
            result.handleException(500, e.getMessage(), e);
        }
        return result;
    } 
    

    public class emailChangeWrapper{
        
        boolean isDomainChange ;
        contact contactDetails = new contact();
        public emailChangeWrapper(boolean isDomain, contact con){
            
            this.isDomainChange = isDomain;
            if(con != null){
                this.contactDetails = con;
            }else{
                contactDetails = null;
            }
        }
    }
}