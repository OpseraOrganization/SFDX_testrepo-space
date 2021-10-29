/** * File Name: UserAssociationWebserviceController
* Description Rest Webservice class to fetch Fleet Asset Aircraft and Restricted Service Program details for a particular user
* Copyright : ITC INFOTECH Limited Copyright (c) 2017
* * @author : ITC INFOTECH
Ver Date Author 1.0 10/03/2017
* */ 
@RestResource(urlMapping='/AerospaceUserAssociationServices/*')
global without sharing class UserAssociationWebserviceController{
    
    
    // To fetch Fleet Asset Aircraft and Restricted Service program for a given user.
    
    @HttpGet
    global static void getRecord() 
    {
        String honeywellNo = RestContext.request.params.get('honeywellid');                //Get Honeywell Id of user from the request URL
        String requestType = RestContext.request.params.get('requestType');                //Get Type of request from  the request URL. Request Type can be either aircraft or service program or aircraftandservice.
        String externalId = RestContext.request.params.get('externalId');                 //Get if  user wants external id  from  the request URL.External Id can be either true or false.       
        // String loginType = RestContext.request.params.get('loginType');                    //Get Type of login from  the request URL. Login Type can be either portal or manageAccount.
        RestContext.response.addHeader('Content-Type', 'application/json');                //Passing content-Type of response as JSON String
        REG_Result.requestURI=RestContext.request.requestURI;
        REG_Result.requestInputs=JSON.serialize(RestContext.request.params);
        REG_Result.headers=JSON.serialize(RestContext.request.headers);
        REG_Result.requestMethod='GET';
        REG_Result.transactionId=RestContext.request.headers.get('transactionId');
        String emailID = null;
        system.debug(logginglevel.info,'honId' +honeywellNo);
        if(honeywellNo !=null && honeywellNo !='')
        {
             List<Portal_Honeywell_Id__c>  portalHWContactLst = [select contact__r.Contact_Status__c,contact__r.accountid, contact__r.Access__c, contact__r.All_Aircrafts__c, contact__r.Assigned_Aircrafts__c,contact__r.Has_Restriction__c, contact__r.firstname,contact__r.lastname from portal_honeywell_id__c Where contact__r.contact_status__c = 'Active' and primary_honeywell_id__c = true and name  =:honeywellNo] ;
            
            if(!portalHWContactLst.isEmpty())
            {
                system.debug('at 28');
                if(portalHWContactLst[0].contact__r.Contact_Status__c== 'Active')
                {
                    if(requestType!='' && requestType !=null)
                    {
                        List<FleetAircraftRecord> FleetAircraftRecordsList = new List<FleetAircraftRecord>();
                        List<RestrictedServiceProgramRecord> restrictedServiceRecordsList = new List<RestrictedServiceProgramRecord>();
                        List<Account_Cross_Ref__c> ExternalIdAccList = new List<Account_Cross_Ref__c>();
                        list<String> extAccList = new  list<String>(); 
                        list<Contact> conList = new  list<Contact>();                        
                        Set<String> extAccSet = new Set<String>();
                        conList = [SELECT Id,Account_Name__c,Access__c,All_Aircrafts__c,Assigned_Aircrafts__c,Has_Restriction__c, Account.GoDirect_View__c FROM Contact WHERE Id IN (SELECT Contact__c FROM Portal_Honeywell_ID__c WHERE Name = :honeywellNo )];
                        if(requestType.equalsIgnoreCase('aircraft') || (requestType.equalsIgnoreCase('aircraftandservice')))
                        {
                            //Fetching Fleet Asset Aircraft details from User Aircraft Association object for the given User
                            List<User_Aircraft_Association__c> userAircraftList = [Select Id,Aircraft_Make__c,Aircraft_Model__c,Fleet_Asset_Aircraft_Name__c,Serial_Number__c,Tail_Number__c from User_Aircraft_Association__c where User__c=:portalHWContactLst[0].contact__c ];
                            
                            Set<Id> FAASet = new Set<Id>();
                            Map<Id,List<Fleet_Asset_Aircraft_XRef__c>> mapFleetxRef = new Map<Id,List<Fleet_Asset_Aircraft_XRef__c>>();
                            
                            for(User_Aircraft_Association__c uaa : userAircraftList)
                            {
                                FAASet.add(uaa.Fleet_Asset_Aircraft_Name__c);
                            }
                            
                            List<Fleet_Asset_Aircraft_XRef__c> FleetAssetxRefList = new List<Fleet_Asset_Aircraft_XRef__c>();
                            
                            
                            if(requestType.equalsIgnoreCase('aircraftandservice'))
                            {
                                // Fetching Fleet Asset Aircraft xRef using Fleet Asset Aircraft detail
                                FleetAssetxRefList = [Select Id,Name,Serial_Number__c,External_Source_Nm__c,Fleet_Asset_Detail__c from Fleet_Asset_Aircraft_XRef__c where Fleet_Asset_Detail__c IN: FAASet and (External_Source_Nm__c = 'SIMS' OR External_Source_Nm__c = 'BMS')];
                                for(Fleet_Asset_Aircraft_XRef__c faax : FleetAssetxRefList)
                                {
                                    List<Fleet_Asset_Aircraft_XRef__c> faxList = new List<Fleet_Asset_Aircraft_XRef__c>();
                                    if(mapFleetxRef.containsKey(faax.Fleet_Asset_Detail__c))
                                    {
                                        faxList = mapFleetxRef.get(faax.Fleet_Asset_Detail__c);
                                        System.debug('faxList'+faxList);                 
                                    }
                                    faxList.add(faax);
                                    mapFleetxRef.put(faax.Fleet_Asset_Detail__c,faxList);
                                    
                                }     
                                if(externalId == 'true')
                                {
                                    //List<Contact> conList = new  List<Contact>();
                                    //conList =[Select account.name from contact where Honeywell_ID__c =:honeywellNo];
                                    
                                    ExternalIdAccList = [select External_Account_ID__c from account_cross_ref__c where Account_Name__c=:portalHWContactLst[0].contact__r.accountId and account_status__c = 'ACTIVE' and (not external_account_name__c like '%do not use%') and (not external_account_name__c like '%reference account%') and (not external_account_name__c like '%various%') and account_name__r.name not in ('HONEYWELL UNIDENTIFIED PORTAL USERS','Honeywell Default Account',
                                                                                                                                                                                                                                                                                                                                                                                                        'NO ACCOUNT FOUND','FSR TEMPORARY OPERATOR','Portal Missing Users (Do not use)') and  (external_account_id__c like '%-01'  or external_account_id__c like '%-02' ) and  XREF_Type__c = 'SAP_SOLD_TO'];
                                    Integer i=0;
                                    Integer checklength;
                                    for(Account_Cross_Ref__c cr : ExternalIdAccList)
                                    {
                                        string str = cr.External_Account_ID__c;
                                        checkLength = str.length();
                                        if(checkLength == 13)
                                        { 
                                            boolean lastTwoDigitsOne = str.endswith('01');
                                            boolean lastTwoDigitsTwo = str.endswith('02');
                                            if(lastTwoDigitsOne || lastTwoDigitsTwo)
                                            {
                                                string str2=str;
                                                string removeLastThree=str2.left(10);
                                                Integer j;
                                                string cutstring;
                                                String newExternalIdAccList;
                                                for(j=0; j<removeLastThree.length();j++)
                                                {
                                                    cutstring = removeLastThree.substring(j, j+1);
                                                    if(cutstring != '0')
                                                    {
                                                        newExternalIdAccList = removeLastThree.substring(j, removeLastThree.length());
                                                        break;
                                                    }
                                                }
                                                //extAccSet.add();
                                                extAccList.add(newExternalIdAccList);
                                                extAccSet.addall(extAccList);
                                                
                                                i=i+1;
                                            }
                                        }
                                    }                             
                                    System.debug('extAccList:'+extAccList);
                                    
                                }
                                else if(externalId == 'false')
                                {
                                    extAccList=null;
                                }
                            }   
                            
                            // Adding Fleet Asset Aircraft details along with xREF to the wrapper
                            for(User_Aircraft_Association__c uaa : userAircraftList)
                            {
                                list<String> xREFSIMSValue = new list<String>();
                                list<String> xREFBMSValue = new list<String>();
                                if(requestType.equalsIgnoreCase('aircraftandservice'))
                                {                     
                                    
                                    if(mapFleetxRef.containsKey(uaa.Fleet_Asset_Aircraft_Name__c))
                                    {
                                        for(Fleet_Asset_Aircraft_XRef__c faax : mapFleetxRef.get(uaa.Fleet_Asset_Aircraft_Name__c))
                                        {
                                            if(faax.External_Source_Nm__c=='SIMS')
                                            {
                                                xREFSIMSValue.add(faax.Name);
                                            }
                                            if(faax.External_Source_Nm__c=='BMS')
                                            {
                                                xREFBMSValue.add(faax.Name);
                                            }
                                            
                                        }
                                    }
                                }
                                
                                FleetAircraftRecord   far = new FleetAircraftRecord(uaa.Fleet_Asset_Aircraft_Name__c,uaa.Aircraft_Make__c,uaa.Aircraft_Model__c,uaa.Tail_Number__c,uaa.Serial_Number__c,xREFSIMSValue,xREFBMSValue);
                                FleetAircraftRecordsList.add(far);
                            }
                            
                            // Sending response for aircraft request Type
                            if(requestType.equalsIgnoreCase('aircraft'))
                            {                                  
                                if(!FleetAircraftRecordsList.isEmpty()){
                                    AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Success',null,FleetAircraftRecordsList.size(),FleetAircraftRecordsList,conList[0].Access__c,conList[0].All_Aircrafts__c,conList[0].Assigned_Aircrafts__c,conList[0].Has_Restriction__c);
                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse));
                                }else{
                                    AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','There are no Fleet Asset Aircrafts for the user.',FleetAircraftRecordsList.size(),FleetAircraftRecordsList);
                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse,true));
                                }
                            }
                        }
                        
                        if(requestType.equalsIgnoreCase('serviceprogram') || (requestType.equalsIgnoreCase('aircraftandservice')))
                        {
                            //Fetching Restricted Service Program details for the given User
                            List<Restricted_Service_Program__c> restrictedServiceList = [Select Id,Master_Service_Program_Name__c,Restricted_Service_Program_Name__c from Restricted_Service_Program__c where User__c =: portalHWContactLst[0].contact__c]; 
                            // Adding Restricted Service Program details to the wrapper
                            for(Restricted_Service_Program__c rsp : restrictedServiceList)
                            {
                                RestrictedServiceProgramRecord   rspwrapper = new RestrictedServiceProgramRecord(rsp.Restricted_Service_Program_Name__c,rsp.Master_Service_Program_Name__c);
                                restrictedServiceRecordsList.add(rspwrapper);
                            }
                            
                            //Sending the reponse for Service program request type
                            
                            if(requestType.equalsIgnoreCase('serviceprogram'))
                            {
                                REG_Result.api='Get Service Program';
                                if(!restrictedServiceRecordsList.isEmpty())
                                {
                                    serviceRecordResponse serviceresponse = new serviceRecordResponse('Success',null,restrictedServiceRecordsList.size(),restrictedServiceRecordsList,conList[0].Access__c,conList[0].All_Aircrafts__c,conList[0].Assigned_Aircrafts__c,conList[0].Has_Restriction__c);
                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(serviceresponse));
                                }else{
                                    serviceRecordResponse serviceresponse = new serviceRecordResponse('Failure','There are no Restricted Service Programs for the user.',restrictedServiceRecordsList.size(),restrictedServiceRecordsList);
                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(serviceresponse,true));
                                }                           
                            }
                        }
                        
                        //Sending the reponse for both Service programa and aircraft. This will be used in portal for all Users
                        if(requestType.equalsIgnoreCase('aircraftandservice')){
                            String strMes;
                            String strErrorMes;
                            if(FleetAircraftRecordsList.isEmpty() && portalHWContactLst[0].contact__r.Assigned_Aircrafts__c  ){
                                strMes = 'Failure';
                                strErrorMes = 'There are no Fleet Asset Aircraft for the user';
                            }else if(restrictedServiceRecordsList.isEmpty() && portalHWContactLst[0].contact__r.Has_Restriction__c){
                                strMes = 'Failure';
                                strErrorMes = 'There are no Restricted Service Program for the user';
                            }else if(FleetAircraftRecordsList.isEmpty() && restrictedServiceRecordsList.isEmpty()){   
                                strMes = 'Success';
                                strErrorMes = 'There are no Fleet Asset Aircraft and Restricted Service Program for the user';
                            }else if(!FleetAircraftRecordsList.isEmpty() || !restrictedServiceRecordsList.isEmpty() || !ExternalIdAccList.isEmpty()){
                                strMes = 'Success';
                                strErrorMes = null;
                            }
                           
                            Portal_Honeywell_Id__c  portalHWPrimaryId = [select contact__r.account.name,contact__r.account.GoDirect_View__c, contact__r.Access__c from portal_honeywell_id__c Where contact__r.contact_status__c = 'Active' and name  =:honeywellNo];
                            system.debug('portalHWPrimaryId - '+portalHWPrimaryId);
                            system.debug('Access__c - '+portalHWPrimaryId.contact__r.Access__c);
                            system.debug('goDirect view - '+portalHWPrimaryId.contact__r.account.GoDirect_View__c);
                            system.debug('primary acc name - '+portalHWPrimaryId.contact__r.account.name);
                            List<Portal_Honeywell_Id__c>  portalHWId = [select contact__r.name, contact__r.Is_Portal_Super_User__c, contact__r.Primary_Email_Address__c, contact__r.Access__c from portal_honeywell_id__c Where contact__r.contact_status__c = 'Active' and contact__r.account.name = : portalHWPrimaryId.contact__r.account.name and contact__r.Is_Portal_Super_User__c = true];
                            system.debug('portalHWId - '+portalHWId);
                            system.debug('portalHWId size - '+portalHWId.size());
                      
                            if(portalHWPrimaryId != null && portalHWId != null && !portalHWId.isEmpty())
                            {                                                        
                                    emailID = portalHWId[0].contact__r.Primary_Email_Address__c;                              
                            } 
                             system.debug('portalHWId mail ===- '+emailID);
                            AircraftAndServiceRecord asr = new AircraftAndServiceRecord(FleetAircraftRecordsList,restrictedServiceRecordsList,extAccSet);
                            System.debug('asr'+asr);
                           
                            AircraftandServiceRecordResponse asResponse = new AircraftandServiceRecordResponse(strMes,strErrorMes,portalHWContactLst[0].contact__r.Access__c,FleetAircraftRecordsList.size(),restrictedServiceRecordsList.size(),portalHWContactLst[0].contact__r.All_Aircrafts__c,portalHWContactLst[0].contact__r.Assigned_Aircrafts__c,portalHWContactLst[0].contact__r.Has_Restriction__c,FleetAircraftRecordsList,restrictedServiceRecordsList,extAccSet,emailID);
                             System.debug('asResponse'+asResponse);
                            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(asResponse));
                            
                            
                        }
                        
                        if(!requestType.equalsIgnoreCase('serviceprogram') && (!requestType.equalsIgnoreCase('aircraftandservice')) && !requestType.equalsIgnoreCase('aircraft'))
                        {
                            list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                            AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Request Type can be either aircraft or service program or aircraftandservice',0,aircraftResponseList);
                            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse,true));
                        }
                    }
                    else
                    {
                        list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                        AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Request Type cannot be blank. Please provide a valid request type.',0,aircraftResponseList);
                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse, true));
                    }
                }
                else
                {
                    if(requestType.equalsIgnoreCase('aircraft'))
                    {
                        list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                        AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Contact is inactive',0,aircraftResponseList);
                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse,true));
                    }
                    if(requestType.equalsIgnoreCase('serviceprogram'))
                    {
                        list<RestrictedServiceProgramRecord> restrictedResponseList = new list<RestrictedServiceProgramRecord>();
                        serviceRecordResponse serviceresponse = new serviceRecordResponse('Failure','Contact is inactive',0,restrictedResponseList);
                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(serviceresponse,true));
                    }
                    if(requestType.equalsIgnoreCase('aircraftandservice'))
                    {
                        list<RestrictedServiceProgramRecord> restrictedResponseList = new list<RestrictedServiceProgramRecord>();
                        list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                        AircraftandServiceRecordResponse asResponse = new AircraftandServiceRecordResponse('Failure','Contact is inactive',null,0,0,false,false,false,aircraftResponseList,restrictedResponseList,null,null);
                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(asResponse));
                    }
                }
            }
            else
            {
                if(requestType.equalsIgnoreCase('aircraft'))
                {
                    list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                    AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','There are no contacts for the given ID. Please provide a valid ID.',0,aircraftResponseList);
                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse,true));
                }
                if(requestType.equalsIgnoreCase('serviceprogram'))
                {
                    list<RestrictedServiceProgramRecord> restrictedResponseList = new list<RestrictedServiceProgramRecord>();
                    serviceRecordResponse serviceresponse = new serviceRecordResponse('Failure','There are no contacts for the given ID. Please provide a valid ID.',0,restrictedResponseList);
                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(serviceresponse,true));
                }
                if(requestType.equalsIgnoreCase('aircraftandservice'))
                {
                    list<RestrictedServiceProgramRecord> restrictedResponseList = new list<RestrictedServiceProgramRecord>();
                    list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                    AircraftandServiceRecordResponse asResponse = new AircraftandServiceRecordResponse('Failure','There are no contacts for the given ID. Please provide a valid ID.',null,0,0,false,false,false,aircraftResponseList,restrictedResponseList,null,null);
                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(asResponse));
                }
                
                if((requestType=='' || requestType ==null) || (requestType != 'aircraft' && requestType != 'serviceprogram' && requestType != 'aircraftandservice')){
                    responseValue response = new responseValue('Failure','Request Type can be either serviceprogram, aircraft or aircraftandservice'); 
                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response,true));                
                }
            }
        }
        else
        {  
            if(!string.isBlank(requestType) && requestType.equalsIgnoreCase('aircraft')){
                list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Honeywell Id cannot be blank. Please provide a valid ID.',0,aircraftResponseList);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse,true));
            }else if(!string.isBlank(requestType) && requestType.equalsIgnoreCase('serviceprogram')){
                list<RestrictedServiceProgramRecord> restrictedResponseList = new list<RestrictedServiceProgramRecord>();
                serviceRecordResponse serviceresponse = new serviceRecordResponse('Failure','Honeywell Id cannot be blank. Please provide a valid ID.',0,restrictedResponseList);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(serviceresponse,true));
            }else if(!string.isBlank(requestType) && requestType.equalsIgnoreCase('aircraftandservice')){
                list<RestrictedServiceProgramRecord> restrictedResponseList = new list<RestrictedServiceProgramRecord>();
                list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                AircraftandServiceRecordResponse asResponse = new AircraftandServiceRecordResponse('Failure','Honeywell Id cannot be blank. Please provide a valid ID.',null,0,0,false,false,false,aircraftResponseList,restrictedResponseList,null,null);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(asResponse));
            }else if(!string.isBlank(requestType)){
                list<FleetAircraftRecord> aircraftResponseList = new list<FleetAircraftRecord>();
                AircraftRecordResponse aircraftresponse = new AircraftRecordResponse('Failure','Honeywell Id cannot be blank. Please provide a valid ID.',0,aircraftResponseList);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(aircraftresponse,true));
            }else{
                responseValue response = new responseValue('Failure','Incorrect URI');   
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));             
            }
        }       
        
    }
    
    
    // Post method to insert/update User aircraft association and Restricted service program objects
    @HttpPost
    global static void doPost()
    {
        RestRequest req = RestContext.request;
        RestContext.response.addHeader('Content-Type', 'application/json');
        REG_Result.requestURI=req.requestURI;
        REG_Result.headers=JSON.serialize(req.headers);
        REG_Result.requestMethod='POST';
        REG_Result.transactionId=req.headers.get('transactionId');
        REG_Result.requestURI=req.requestURI;
        String body=req.requestbody.toString();
        REG_Result.requestInputs=body;
        List<contact> contactList = new List<contact>();
        system.debug('req'+req);
        REG_Result result = new REG_Result();
        try{
        userRecords userRecordDetail = (userRecords)JSON.deserialize(req.requestBody.toString(),userRecords.class);
        REG_Result.logTransaction();
        
        if(userRecordDetail!=null)
        {
            List<Contact> lstContact = new List<Contact>();
            List<Portal_Honeywell_Id__c>  portalHWContactLst = [select contact__r.Contact_Status__c,contact__r.accountid, contact__r.Access__c, contact__r.All_Aircrafts__c, contact__r.Assigned_Aircrafts__c,contact__r.Has_Restriction__c, contact__r.firstname,contact__r.lastname from portal_honeywell_id__c Where contact__r.contact_status__c = 'Active' and name  =:userRecordDetail.honeywellID];
            if(!portalHWContactLst.isEmpty())
            {
                lstContact =  [SELECT Id,Contact_Status__c,Access__c,All_Aircrafts__c,Assigned_Aircrafts__c,Has_Restriction__c FROM Contact WHERE Id=:portalHWContactLst[0].Contact__c limit 1]; 
            }
            List<User_Aircraft_Association__c> aircraftInsertList = new List<User_Aircraft_Association__c>();
            List<Restricted_Service_Program__c> serviceInsertList = new List<Restricted_Service_Program__c>();
            if(userRecordDetail.honeywellID != null && userRecordDetail.honeywellID !='')
            {
                if(!lstContact.isEmpty())
                {
                    if(lstContact[0].Contact_Status__c == 'Active')
                    {
                        if(userRecordDetail.requestType!='' && userRecordDetail.requestType !=null)
                        {
                            System.debug(' === requestType - '+userRecordDetail.requestType);
                            if(userRecordDetail.requestType.equalsIgnoreCase('specificaircraft') || userRecordDetail.requestType.equalsIgnoreCase('serviceprogram') || userRecordDetail.requestType.equalsIgnoreCase('allaircraft'))
                            {
                                List<User_Aircraft_Association__c> aircraftLst = [Select Id from User_Aircraft_Association__c where User__c=: lstContact[0].Id];
                                List<Restricted_Service_Program__c> serviceList = [Select Id from Restricted_Service_Program__c where User__c =: lstContact[0].Id];
                                if(userRecordDetail.role!=null && userRecordDetail.role !='')
                                {  
                                    contactList = [SELECT Id,Account_Name__c,Access__c,All_Aircrafts__c,Assigned_Aircrafts__c,Has_Restriction__c, Account.GoDirect_View__c FROM Contact WHERE Id =: lstContact[0].Id];
                                    system.debug('contactList' +contactList);
                                    string managemnt = !string.isBlank(contactList[0].Account.GoDirect_View__c)?contactList[0].Account.GoDirect_View__c:system.label.REG_user_manage_godirect_view;
                                    system.debug('managemnt' +managemnt);
                                    userRecordDetail.role =((managemnt == system.label.REG_user_manage_godirect_view) && (contactList[0].Access__c == null) && ((userRecordDetail.role == system.label.REG_full_access ) || (userRecordDetail.role == system.label.REG_select_access)))?system.label.REG_assign_access:userRecordDetail.role;
                                    system.debug('userRecordDetail.role' +userRecordDetail.role);
                                    System.debug('role not null - '+userRecordDetail.role);
                                    if(!userRecordDetail.role.equalsIgnoreCase('No Access'))
                                    {
                                        if(!userRecordDetail.requestType.equalsIgnoreCase('allAircraft'))
                                        {
                                            System.debug('requestType not allAircraft ');
                                            System.debug('userRecordDetail.requestTypeIdList - '+userRecordDetail.requestTypeIdList);
                                            System.debug('userRecordDetail.requestTypeIdList - size check '+userRecordDetail.requestTypeIdList.size());
                                            System.debug('userRecordDetail.requestTypeIdList - empty check - '+userRecordDetail.requestTypeIdList.isEmpty());
                                            if(!userRecordDetail.requestTypeIdList.isEmpty())
                                            {
                                                System.debug('userRecordDetail.requestTypeIdList - not empty '+userRecordDetail.requestTypeIdList);
                                                List<Fleet_Asset_Detail__c> faaList = [Select Id from Fleet_Asset_Detail__c where Id IN: userRecordDetail.requestTypeIdList LIMIT 10000];
                                                List<Master_Service_Program__c> mspList = [Select Id from Master_Service_Program__c where Id IN: userRecordDetail.requestTypeIdList LIMIT 10000];
                                                System.debug('fleet asset aircraft list - '+faaList);
                                                System.debug('fleet asset aircraft list - size - '+faaList.size());
                                                System.debug('fleet asset aircraft list - isempty - '+faaList.isEmpty());
                                                for(ID ur : userRecordDetail.requestTypeIdList)
                                                {
                                                    System.debug('requestTypeIdList - in loop - '+ur);
                                                    if(null != ur && userRecordDetail.requestType.equalsIgnoreCase('specificaircraft') && !faaList.isEmpty())
                                                    {
                                                        User_Aircraft_Association__c uaa = new User_Aircraft_Association__c();
                                                        uaa.User__c = lstContact[0].Id;
                                                        uaa.Fleet_Asset_Aircraft_Name__c = ur;
                                                        aircraftInsertList.add(uaa);
                                                    }
                                                    else if(userRecordDetail.requestType.equalsIgnoreCase('serviceprogram') && !mspList.isEmpty())
                                                    {
                                                        Restricted_Service_Program__c rsp = new Restricted_Service_Program__c();
                                                        rsp.User__c = lstContact[0].Id;
                                                        rsp.Master_Service_Program_Name__c = ur;
                                                        serviceInsertList.add(rsp);
                                                    }            
                                                }  
                                                String errorMessage = '';
                                                if(userRecordDetail.requestType.equalsIgnoreCase('specificaircraft'))
                                                {
                                                    System.debug('Entered specificaircraft case - ');
                                                    try
                                                    {
                                                        System.debug('aircraftInsertList - '+aircraftInsertList);
                                                        if(!aircraftInsertList.isEmpty() && aircraftInsertList.size() >0)
                                                        {
                                                            System.debug('aircraftInsertList isempty - '+aircraftInsertList.isEmpty());
                                                            System.debug('aircraftInsertList size - '+aircraftInsertList.size());
                                                            System.debug('aircraftLst - '+aircraftLst);
                                                            if(!aircraftLst.isEmpty())
                                                            {
                                                                System.debug('deleted ac in 1 - '+aircraftLst);
                                                                delete aircraftLst;
                                                                System.debug('deleted ac in 2 - '+aircraftLst);
                                                            }
                                                            System.debug('aircraftLst - 123');
                                                            insert aircraftInsertList;
                                                            System.debug('aircraftLst - 1234');
                                                            lstContact[0].All_Aircrafts__c = false;
                                                            lstContact[0].Assigned_Aircrafts__c = true;
                                                            //update lstContact;
                                                            System.debug('Success- '+aircraftInsertList);
                                                            responseValue response = new responseValue('Success',null); 
                                                            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                                        }
                                                        else
                                                        {
                                                            responseValue response = new responseValue('Failure','Fleet Asset Aircraft updation list is empty. Please verify and try again.'); 
                                                            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                                        }
                                                    }
                                                    catch(Exception e)
                                                    {
                                                        errorMessage = e.getMessage();
                                                        responseValue response = new responseValue('Failure',errorMessage); 
                                                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                                    }
                                                    
                                                } 
                                                else if(userRecordDetail.requestType.equalsIgnoreCase('serviceprogram'))
                                                {
                                                    REG_Result.api='Update service programs for Honeywell Id';
                                                    try
                                                    {
                                                        if(!serviceInsertList.isEmpty())
                                                        {
                                                            if(!serviceList.isEmpty())
                                                            {
                                                                delete serviceList;
                                                            }
                                                            insert serviceInsertList;
                                                            if(userRecordDetail.hasRestriction != null)
                                                            {
                                                                lstContact[0].Has_Restriction__c = userRecordDetail.hasRestriction;
                                                            }
                                                            //update lstContact;
                                                            responseValue response = new responseValue('Success',null);   
                                                            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                                        }
                                                        else
                                                        {
                                                            responseValue response = new responseValue('Failure','Restricted Service program updation list is empty. Please verify and try again.');   
                                                            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                                        }                                           
                                                    } 
                                                    catch(Exception e)
                                                    {
                                                        errorMessage = e.getMessage();
                                                        responseValue response = new responseValue('Failure',errorMessage); 
                                                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                                    }
                                                    
                                                }
                                            }
                                            else
                                            {
                                                System.debug('== Entered else case ==Failure');
                                                System.debug('== Record type list empty');
                                                if(userRecordDetail.requestType.equalsIgnoreCase('specificaircraft'))
                                                {
                                                    if(!aircraftLst.isEmpty() && aircraftLst.size() > 0){
                                                        System.debug('deleting aircraftLst == ');
                                                        delete aircraftLst;                                                       
                                                    }
                                                    lstContact[0].All_Aircrafts__c = false;
                                                    lstContact[0].Assigned_Aircrafts__c = false;
                                                    
                                                    responseValue response = new responseValue('Failure','There are no Fleet Asset Aircrafts for updation/insertion. Please provide more details.');   
                                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response)); 
                                                }
                                                if(userRecordDetail.requestType.equalsIgnoreCase('serviceprogram'))
                                                {
                                                    if(null != serviceList && !serviceList.isEmpty() && serviceList.size() > 0){
                                                        delete serviceList;
                                                    } 
                                                    lstContact[0].Has_Restriction__c = false;
                                                    responseValue response = new responseValue('Failure','There are no Restricted Service programs for updation/insertion. Please provide more details.');   
                                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                                }
                                                
                                            }
                                        }
                                        else if(userRecordDetail.requestType.equalsIgnoreCase('allaircraft'))                               
                                        {
                                            try
                                            {
                                                if(!aircraftLst.isEmpty())
                                                {
                                                    delete aircraftLst;
                                                }
                                                
                                                lstContact[0].All_Aircrafts__c = true;
                                                lstContact[0].Assigned_Aircrafts__c = false;
                                                responseValue response = new responseValue('Success',null);   
                                                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                            }
                                            catch(Exception e)
                                            {
                                                String errorMessage = e.getMessage();
                                                responseValue response = new responseValue('Failure',errorMessage); 
                                                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                            }
                                        }
                                    }
                                    try
                                    {                                       
                                        System.debug('RoleCheck'+userRecordDetail.role);
                                       if(!userRecordDetail.role.equalsIgnoreCase('Assign Access')){
                                       System.debug('RoleCheckInside'+userRecordDetail.role);
                                              lstContact[0].Access__c = userRecordDetail.role;                                        
                                         }
                                        if(userRecordDetail.role.equalsIgnoreCase('No Access'))
                                        {
                                            lstContact[0].All_Aircrafts__c = false;
                                            lstContact[0].Assigned_Aircrafts__c = false;
                                            lstContact[0].Has_Restriction__c = false;
                                            if(!aircraftLst.isEmpty())
                                            {
                                                delete aircraftLst;
                                            }
                                            if(!serviceList.isEmpty())
                                            {
                                                delete serviceList;
                                            }
                                        }
                                        System.debug('lstContact'+lstContact);
                                        update lstContact;
                                        System.debug('lstContact1'+lstContact);
                                        responseValue response = new responseValue('Success',null);   
                                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                        
                                    }
                                    catch(Exception e)
                                    {
                                        String errorMessage = e.getMessage();
                                        responseValue response = new responseValue('Failure',errorMessage); 
                                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                    }
                                }
                                else
                                {
                                    responseValue response = new responseValue('Failure','Role cannot be blank. Please provide a valid role.');   
                                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                                }
                                
                            }
                            else
                            {
                                responseValue response = new responseValue('Failure','Request Type can be either allaircraft or specificaircraft or serviceprogram');   
                                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));
                            }
                        }
                        else
                        {
                            responseValue response = new responseValue('Failure','Request Type cannot be blank. Please provide a valid request type.');   
                            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response)); 
                        }
                    }
                    else
                    {
                        responseValue response = new responseValue('Failure','Contact is inactive');   
                        RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response)); 
                    }
                }
                else
                {
                    responseValue response = new responseValue('Failure','There are no contacts for the given ID. Please provide a valid ID.');   
                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response)); 
                }
            }
            else
            {
                responseValue response = new responseValue('Failure','Honeywell Id cannot be blank. Please provide a valid ID.');   
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response)); 
            }
        }  
        else
        {
            responseValue response = new responseValue('Failure','Request cannot be null');   
            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response)); 
        }
        }catch(System.JSONException e){
            //result.handleException(400, 'Input parameter in the request body not in correct format.', e);   
            responseValue response = new responseValue('Failure','hasRestriction/requestTypeIdList in the request body not in correct format.hasRestriction should be a boolean vale and requestTypeIdList should be Id');   
            RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(response));          
        }catch(Exception e){
                result.handleException(500, e.getMessage(), e);
        }
        
        
    }
    
    // wrapper to fetch values from the HTTP request.
    public class userRecords
    {
    
        public String honeywellID ='';
        public List<ID> requestTypeIdList = new List<ID>();
        public string requestType ='';
        public string externalId ='';
        public Boolean hasRestriction;
        public String role = '';
        public userRecords()
        {
            
        }
    }
    
    //wrapper to send response of a post method
    public class responseValue
    {
        public String status;
        public String errorMessage;
        public responseValue(String uStatus, String uErrorMessage)
        {
            status = uStatus;
            errorMessage = uErrorMessage;
        }
    }
    
    
    //wrapper class to send response of Fleet Asset Association List to Manage by Admin
    public class FleetAircraftRecord   
    {
        
        public String fleetAircraftID;
        public String aircraftMake;
        public String aircraftModel;
        public string tailNumber;
        public String serialNumber; 
        public list<String> xRefSIMSNumber;
        public list<String> xRefBMSNumber; 
        
        
        public FleetAircraftRecord(String ffleetAircraftID,String faircraftMake,String faircraftModel,string ftailNumber,String fserialNumber,list<String> fxRefSIMSNumber,list<String> fxRefBMSNumber)
        {
            
            fleetAircraftID = ffleetAircraftID;
            aircraftMake = faircraftMake;
            aircraftModel = faircraftModel;
            tailNumber = ftailNumber;
            serialNumber = fserialNumber;
            xRefSIMSNumber = fxRefSIMSNumber;
            xRefBMSNumber = fxRefBMSNumber;
        }
    }
    
    //wrapper class to send response of Restricted Service Program List to Manage by Admin
    public class RestrictedServiceProgramRecord   
    {
        public String serviceProgramName;
        public String serviceProgramID;                    
        
        public RestrictedServiceProgramRecord(String sserviceProgramName,String sserviceProgramId)
        {
            serviceProgramName = sserviceProgramName;
            serviceProgramId = sserviceProgramId;
            
        }
    }
    
    
    //wrapper class to send response of Fleet Asset Aircraft and Restricted Service Program List to user in portal
    public class AircraftAndServiceRecord   
    {
        public List<FleetAircraftRecord> fleetAircraftRecordList;
        public List<RestrictedServiceProgramRecord> restrictedServiceProgramRecordList;
        public Set<String>  externalaccidlst;                 
        
        public AircraftAndServiceRecord(List<FleetAircraftRecord> uFleetAircraftRecordWrapperList,List<RestrictedServiceProgramRecord> uRestrictedServiceProgramRecordList,Set<String> uexternalaccidlst)
        {
            fleetAircraftRecordList = uFleetAircraftRecordWrapperList;
            restrictedServiceProgramRecordList = uRestrictedServiceProgramRecordList;
            externalaccidlst = uexternalaccidlst;
            System.debug('externalaccidlst'+externalaccidlst);
        }
    }
    
    public class AircraftRecordResponse
    {
        public String status;
        public String errorMessage;
        public String aircraftAccess;
        public Boolean hasAccessToAllAircrafts;
        public Boolean hasAccessToAssignedAircrafts;
        public Boolean hasRestriction;    
        public Integer count;
        public List<FleetAircraftRecord> recordList;
        
        
        
        public AircraftRecordResponse(String sstatus, String serrorMessage, Integer scount, List<FleetAircraftRecord> saircraftRecords, String saircraftAccess, Boolean shasAccessToAllAircrafts,Boolean shasAccessToAssignedAircrafts, Boolean shasRestriction)
        {
            status = sstatus;
            errorMessage = serrorMessage;
            count = scount;
            recordList = saircraftRecords;
            aircraftAccess = saircraftAccess;
            hasAccessToAllAircrafts = shasAccessToAllAircrafts;
            hasAccessToAssignedAircrafts = shasAccessToAssignedAircrafts;
            hasRestriction= shasRestriction;
            
        }
        
        public AircraftRecordResponse(String sstatus, String serrorMessage, Integer scount, List<FleetAircraftRecord> saircraftRecords)
        {
            status = sstatus;
            errorMessage = serrorMessage;
            count = scount;
            recordList = saircraftRecords;
 
            
        }        
        
    }
    public class serviceRecordResponse
    {
        public String status;
        public String errorMessage;
        public Integer count;
        public String aircraftAccess;
        public Boolean hasAccessToAllAircrafts;
        public Boolean hasAccessToAssignedAircrafts;
        public Boolean hasRestriction;         
        public List<RestrictedServiceProgramRecord> recordList;
        
        public serviceRecordResponse(String sstatus, String serrorMessage, Integer scount, List<RestrictedServiceProgramRecord> srestrictedProgramRecords , String saircraftAccess, Boolean shasAccessToAllAircrafts,Boolean shasAccessToAssignedAircrafts, Boolean shasRestriction)
        {
            status = sstatus;
            errorMessage = serrorMessage;
            count = scount;
            recordList = srestrictedProgramRecords;
            aircraftAccess = saircraftAccess;
            hasAccessToAllAircrafts = shasAccessToAllAircrafts;
            hasAccessToAssignedAircrafts = shasAccessToAssignedAircrafts;
            hasRestriction= shasRestriction;
        }
        
        public serviceRecordResponse(String sstatus, String serrorMessage, Integer scount, List<RestrictedServiceProgramRecord> srestrictedProgramRecords)
        {
            status = sstatus;
            errorMessage = serrorMessage;
            count = scount;
            recordList = srestrictedProgramRecords;
        }
                
        
    }
    public class AircraftandServiceRecordResponse
    {
        public String status;
        public String errorMessage;
        public String access;
        public Integer fleetAircraftCount;
        public Integer restrictedServiceCount;
        public Boolean allAircrafts;   
        public Boolean assignedAircrafts; 
        public Boolean hasRestriction; 
        public List<FleetAircraftRecord> fleetAircraftrecordList;
        public List<RestrictedServiceProgramRecord> restrictedServicerecordList;    
        public Set<String>  externalAccountIdList;
        public String emailId;
        
        
        // public AircraftAndServiceRecord recordList;
        
        public AircraftandServiceRecordResponse(String sstatus, String serrorMessage,String saccess, Integer fcount,Integer rcount,Boolean sAllAircrafts, Boolean sAssignedAircrafts, Boolean sHasRestriction,List<FleetAircraftRecord> goPortalaircraftRecords,List<RestrictedServiceProgramRecord> goPortalrestrictedProgramRecords,Set<String>  goPortalexternalAccountIdList,String sairEmailId)
        {
            status = sstatus;
            errorMessage = serrorMessage;
            access = saccess;
            fleetAircraftCount = fcount;
            restrictedServiceCount = rcount;  
            allAircrafts = sAllAircrafts;  
            assignedAircrafts = sAssignedAircrafts;
            hasRestriction =  sHasRestriction;      
            //recordList = saircraftandserviceRecords;
            fleetAircraftrecordList = goPortalaircraftRecords;
            restrictedServicerecordList = goPortalrestrictedProgramRecords;
            externalAccountIdList =  goPortalexternalAccountIdList;
            emailId = sairEmailId;            
        }        
    }
    
    
    
}