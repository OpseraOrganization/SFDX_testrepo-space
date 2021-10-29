/** * File Name: AccountAndContactWebserviceController
* Description Rest Webservice class to fetch account & Contact details
* Copyright : ITC INFOTECH Limited Copyright (c) 2017
* * @author : ITC INFOTECH
Ver Date Author 1.0 06/02/2017
* */ 
@RestResource(urlMapping='/AerospaceAccountServices/*')
global without sharing class AccountAndContactWebserviceController {
    @HttpGet
    global static void getRecord() {
        String honeywellNo = RestContext.request.params.get('honeywellid');
        String requestType = RestContext.request.params.get('type');
        String accountname = RestContext.request.params.get('accountname');
        String accountType = RestContext.request.params.get('accounttype');
        String dealerView = 'HAPP/MPP Dealer';
        String contractToolName = 'a0G30000004LNhy';
        String crmContactId = '';
        system.debug('@@#Honeywell ID@#@'+honeywellNo+'#$%#Type$%#'+requestType+'@@Account name!!!'+accountname);
        RestContext.response.addHeader('Content-Type', 'application/json');
    
        // For Fetching the Account information & Contact Information
        if(accountname==null){
              
            Portal_Honeywell_Id__c  portalHWContact = [select contact__r.id, contact__r.firstname,contact__r.lastname,contact__r.primary_email_address__c, contact__r.phone_1__c, contact__r.phone_1_ext__c,  contact__r.account.name,contact__r.account.Type,contact__r.account.GoDirect_View__c , contact__r.account.Report_Address_Line_1__c,contact__r.account.Report_Address_Line_2__c, contact__r.account.Report_City_Name__c, contact__r.account.Report_Country_Name__c, contact__r.account.Report_State_Code__c, contact__r.account.Report_Postal_Code__c from portal_honeywell_id__c Where contact__r.contact_status__c = 'Active' and name  =:honeywellNo];
            //[select contact__r.firstname,contact__r.lastname,contact__r.primary_email_address__c, contact__r.country_name__c,contact__r.city_name__c,contact__r.state_code__c,contact__r.postal_code__c,contact__r.account.id,contact__r.account.name,contact__r.account.Type,contact__r.account.GoDirect_View__c ,contact__r.phone_1__c, contact__r.phone_1_ext__c, contact__r.address_line_1__c, contact__r.address_line_2__c from portal_honeywell_id__c Where contact__r.contact_status__c = 'Active' and name  =:honeywellNo];
        
            system.debug('portal_honeywell_id__c - '+portalHWContact);
            system.debug('portal_honeywell_id__c - '+portalHWContact.contact__r.primary_email_address__c);
            
            crmContactId = portalHWContact.contact__r.id;
            system.debug('contact__r.id - '+crmContactId);
            
            if(requestType == 'account'){
                   Account acc = [select type,name,Report_Address_Line_1__c,Report_Address_Line_2__c,Report_City_Name__c,Report_Country_Name__c,Report_State_Code__c,Report_Postal_Code__c from account where id=:portalHWContact.contact__r.accountid];
                   ResponseValues accountresponse = new ResponseValues(null,null,null,acc.Report_Country_Name__c,acc.Report_City_Name__c,acc.Report_State_Code__c,acc.Report_Postal_Code__c,acc.name,acc.Type,null,null,acc.Report_Address_Line_1__c,acc.Report_Address_Line_2__c, null);
                   RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(accountresponse));
            }else{
                String contractToolAccess = '';
                //[select contact__r.firstname,contact__r.lastname,contact__r.primary_email_address__c, contact__r.country_name__c,contact__r.city_name__c,contact__r.state_code__c,contact__r.postal_code__c,contact__r.account.id,contact__r.account.name,contact__r.account.Type, contact__r.phone_1__c, contact__r.phone_1_ext__c, contact__r.address_line_1__c, contact__r.address_line_2__c from portal_honeywell_id__c Where contact__r.contact_status__c = 'Active' and name  =:honeywellNo];
              
List<Contact_Tool_Access__c> toolAccess = [select Portal_Honeywell_ID__c, NAME, Request_Status__c,CRM_Contact_ID__c from Contact_Tool_Access__c where portal_tool_master__r.Id=: contractToolName AND CRM_Contact_ID__c =:crmContactId];// Portal_Honeywell_ID__c =:honeywellNo];
                system.debug('### toolAccess data - '+toolAccess);
                
                if(toolAccess != null && toolAccess.size() > 0 ){
                    contractToolAccess = toolAccess[0].Request_Status__c;
                }else{
                    contractToolAccess = 'NO ACCESS';
                }
                ResponseValues contactresponse = new ResponseValues(portalHWContact.contact__r.firstname,portalHWContact.contact__r.lastname,portalHWContact.contact__r.primary_email_address__c, 
                                                portalHWContact.contact__r.account.Report_Country_Name__c, portalHWContact.contact__r.account.Report_City_Name__c, portalHWContact.contact__r.account.Report_State_Code__c,
                                                portalHWContact.contact__r.account.Report_Postal_Code__c, 
                                                portalHWContact.contact__r.account.name, portalHWContact.contact__r.account.GoDirect_View__c, 
                                                portalHWContact.contact__r.Phone_1__c, portalHWContact.contact__r.Phone_1_Ext__c, 
                                                portalHWContact.contact__r.account.Report_Address_Line_1__c,
                                                portalHWContact.contact__r.account.Report_Address_Line_2__c, contractToolAccess);
            
                //ResponseValues contactresponse = new ResponseValues(portalHWContact.contact__r.firstname,portalHWContact.contact__r.lastname,portalHWContact.contact__r.primary_email_address__c,portalHWContact.contact__r.country_name__c,portalHWContact.contact__r.city_name__c,portalHWContact.contact__r.state_code__c,portalHWContact.contact__r.postal_code__c,portalHWContact.contact__r.account.name,portalHWContact.contact__r.account.GoDirect_View__c, portalHWContact.contact__r.Phone_1__c, portalHWContact.contact__r.Phone_1_Ext__c, portalHWContact.contact__r.Address_Line_1__c,  portalHWContact.contact__r.Address_Line_2__c); 
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(contactresponse));
             } 
        // For fetching the auto suggested accounts
        }else{
            List<Account> autoSuggestList = new list<Account>();
            string tempInput = '%' + accountname + '%';
            system.debug('Search input - '+tempInput);
            if(accountType != null && accountType!=''){
                if(accountType.equalsIgnoreCase('operator')){
                    autoSuggestList = [select id,type,name,Report_Address_Line_1__c,Report_Address_Line_2__c,Report_City_Name__c,Report_Country_Name__c,Report_State_Code__c,Report_Postal_Code__c from account where (type = 'Owner/Operator' or type='Charter Airline' or type='Helicopter Fleet' or type='Temporary') and Customer_Status__c= 'Active' and name like  : tempInput order by name limit 200];
                    list<ResponseValues> accountResponseList = new list<ResponseValues>();
                    for(account accrec: autoSuggestList){
                      ResponseValues accountresponse = new ResponseValues(null,null,null,accrec.Report_Country_Name__c,accrec.Report_City_Name__c,accrec.Report_State_Code__c,accrec.Report_Postal_Code__c,accrec.name,accrec.Type,null,null,accrec.Report_Address_Line_1__c,accrec.Report_Address_Line_2__c, null);
                      accountResponseList.add(accountresponse);
                    }
                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(accountResponseList));
                }else if(accountType.equalsIgnoreCase('dealer')){
                    if(accountname == ''){
                       autoSuggestList = [select id,GoDirect_View__c,name,Report_Address_Line_1__c,Report_Address_Line_2__c,Report_City_Name__c,Report_Country_Name__c,Report_State_Code__c,Report_Postal_Code__c from account where GoDirect_View__c INCLUDES (:dealerView) and Customer_Status__c= 'Active' and name like  : tempInput order by name];
                    list<ResponseValues> accountResponseList = new list<ResponseValues>();
                    for(account accrec: autoSuggestList){
                        ResponseValues accountresponse = new ResponseValues(null,null,null,accrec.Report_Country_Name__c,accrec.Report_City_Name__c,accrec.Report_State_Code__c,accrec.Report_Postal_Code__c,accrec.name,accrec.GoDirect_View__c,null,null,accrec.Report_Address_Line_1__c,accrec.Report_Address_Line_2__c, null);
                        accountResponseList.add(accountresponse);
                    }
                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(accountResponseList));
                    }
                    else{
                        autoSuggestList = [select id,GoDirect_View__c,name,Report_Address_Line_1__c,Report_Address_Line_2__c,Report_City_Name__c,Report_Country_Name__c,Report_State_Code__c,Report_Postal_Code__c from account where GoDirect_View__c INCLUDES (:dealerView) and Customer_Status__c= 'Active' and name like  : tempInput order by name limit 200];
                    list<ResponseValues> accountResponseList = new list<ResponseValues>();
                    for(account accrec: autoSuggestList){
                        ResponseValues accountresponse = new ResponseValues(null,null,null,accrec.Report_Country_Name__c,accrec.Report_City_Name__c,accrec.Report_State_Code__c,accrec.Report_Postal_Code__c,accrec.name,accrec.GoDirect_View__c,null,null,accrec.Report_Address_Line_1__c,accrec.Report_Address_Line_2__c, null);
                        accountResponseList.add(accountresponse);
                    }
                    RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(accountResponseList));
                    }
                } 
            }     
        }
    }
   
   public Class ResponseValues{
       public String firstname;
       public String lastname;
       public String email;
       public String country;
       public String city;
       public String state;
       public String postalcode;
       public String accountname;
       public String accounttype;
       public String phone;
       public String extension;
       public String addressline1;
       public String addressline2;
       public String contractToolAccess;
       
       public ResponseValues(String fname,String lname,String mail,String countryname,String cityname,String statevalue,String postalcodevalue,String accval,String acctype,String phonenumber,String xtension,String addr1,String addr2,String contractAccess){
            firstname = fname;
            lastname = lname;
            email = mail;
            country = countryname;
            city = cityname;
            state = statevalue;
            postalcode = postalcodevalue;
            accountname = accval;
            accounttype = acctype;
            phone = phonenumber;
            extension = xtension;
            addressline1 = addr1;    
            addressline2 = addr2;
            contractToolAccess = contractAccess;
       }
   }
    
}