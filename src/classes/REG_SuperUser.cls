/** * File Name: REG_SuperUser

* Description  Service class for Super User API

* * @author : TCS 

Date 01/16/2019 

* */
public with sharing class REG_SuperUser {
    
    /**
*Method used to fetch super user and contacts related to super user
**/
    public static REG_Result getSuperUserDetail(string honId){
        
        string contact_ID = '';
        List<contact> conList = new List<contact>();
        List<Portal_Honeywell_ID__c> conListSuperUser = new List<Portal_Honeywell_ID__c>();
        List<account> AccountList1 = new List<account>();
        List<REG_PortalUser_Wrapper> wrapperList = new List<REG_PortalUser_Wrapper  >();
        List<REG_PortalUser_Wrapper> wrapperListIden = new List<REG_PortalUser_Wrapper  >();
        REG_Result result = new REG_Result();
        //to find if honid is associated to any contact
        contact_ID = REG_PortalContact_Service.getContact(honId);
        if(string.isBlank(contact_ID)){
            
            result.handleError(404, 'Contact details not found for the given honeywell id', 'Please provide a valid honeywell id.');
            return result;
        }        
        //to find if user is super user
        conList = [SELECT Id,Honeywell_ID__c,Primary_Email_Address__c,Is_Portal_Super_User__c,Account_Name__c,account.GoDirect_View__c 
                   FROM Contact WHERE Id IN (SELECT Contact__c FROM Portal_Honeywell_ID__c WHERE Name =: honId) AND Is_Portal_Super_User__c = true ];       
        //system.debug(logginglevel.info,'conList[0]' +conList[0]);
        if(conList.isEmpty()){
            result.handleError(400, 'Provided honeywell Id is not a super user', 'Provided honeywell Id is not a super user');    
            return result;
        }else{
            String emailId = conList[0].Primary_Email_Address__c;
            String domain = emailId.substring(emailId.lastIndexOf('@') +1);
            //flowVars.superUser.Account.GoDirect_View__c when flowVars.superUser.Account.GoDirect_View__c != null otherwise p('user.manage.godirect.view')
            string company = !string.isBlank(conList[0].account.GoDirect_View__c) ? conList[0].account.GoDirect_View__c : system.label.REG_user_manage_godirect_view;
            //to find the contacts associated to super user, by using the domain of super user 
            AccountList1 = [select id from account where customer_status__c= 'active' and id IN (select account__c from account_email_domains__c where account_email_domain__c=: domain) and name NOT IN ('HONEYWELL UNIDENTIFIED PORTAL USERS','Bendix King UNIDENTIFIED PORTAL USERS','Honeywell Default Account','NO ACCOUNT FOUND','FSR TEMPORARY OPERATOR','Portal Missing Users (Do not use)') and (not name like '%Various%')];
            //system.debug('AccountList1'+AccountList1);  
            
            for(Portal_Honeywell_ID__c phid : [select contact__r.firstname,Contact__r.lastname,Contact__r.primary_email_address__c,name,Contact__r.Account_Name__c,portal_status__c, contact__r.Access__c,contact__r.All_Aircrafts__c, contact__r.Assigned_Aircrafts__c, contact__r.Has_Restriction__c,contact__r.Is_Portal_Super_User__c,contact__c from Portal_Honeywell_ID__c where  Portal_Status__c not in ('Deleted') and Contact__r.accountId in :AccountList1]){
                
                REG_PortalUser_Wrapper  porUserWrapper = new REG_PortalUser_Wrapper(phid, conList[0].Account_Name__c, company); 
                if(conList[0].Account_Name__c == phid.Contact__r.Account_Name__c ){
                    wrapperListIden.add(porUserWrapper);
                    //system.debug(logginglevel.info,'wrapperListIden' +wrapperListIden);
                }else
                    if(conList[0].Account_Name__c != phid.Contact__r.Account_Name__c){
                        wrapperList.add(porUserWrapper);
                        //system.debug(logginglevel.info,'wrapperList' +wrapperList);
                    }
                
            }
            wrapperListIden.addAll(wrapperList);
            //system.debug(logginglevel.info,'wrapperListIden1' +wrapperListIden);                 
            result.data = wrapperListIden;
        }
        return result;
    }
}