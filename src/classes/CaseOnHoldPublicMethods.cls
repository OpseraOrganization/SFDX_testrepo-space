/*******************************************************************************
Name         : CaseOnHoldPublicMethods
Created By   : Siva Nannapaneni
Company Name : NTT Data
Project      : CSO Case On Hold Time Caliculation 
Created Date : 17 Nov 2015
Usages       : This Class is used in AfterInserHelperclass and AfterUpdateHelperclass.    
Modification History  :
Date          Version No.     Modified by     Brief Description of Modification 
19/7/16        v1             NTT DATA        Added the Record Type for R&O DOD Need Contract On Hold Age Calculation
22/8/16        v2             NTT DATA        Added condition for Customer Hold record creation
*******************************************************************************/

public with sharing class CaseOnHoldPublicMethods
{  
    public static void CaseOnHoldMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap){
        Set<Case> listCas = new set<Case>();
        Set<ID> listCas1 = new Set<ID>();
        Set<case> listCas2 = new Set<case>();
        list<case> listcase = new list<case>();
        list<case> listcas3 = new list<case>();
        Set<ID> listcas4 = new Set<ID>();
        list<Case_on_hold_log__c> listonholdlog = new list<Case_on_hold_log__c>();
        list<Case_on_hold_log__c> listonholdlog1 = new list<Case_on_hold_log__c>();
        Set<Case> removeDuplicateIds = new Set<Case>(); // Added to avoid duplicate IDs
        List<Case> ActualList = new List<Case>(); // Added to avoid duplicate IDS
        
        for(case c: listObjCaseNew )
        {
            System.debug('****'+c.recordtypeid+' '+c.status.contains('Hold') + ' '+c.status);
            if(Trigger.isUpdate && (( null!= c.Status && oldMap.get(c.id).Status!= c.Status) || (null!= c.Sub_Status__c && oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c))){
                                        TriggerInactive.avoidcaseonholdlog = false;
                                    }
            //Modified below line for request INC000010402020     
            if( Trigger.isUpdate && !UserInfo.getUserName().contains('Approval Process') && (c.recordtypeid==label.Orders_Rec_ID || c.recordtypeid ==label.QuotesRecordID || c.recordtypeid ==label.Repair_Overhaul_RT_ID || c.recordtypeid ==label.OEM_Quotes_Orders_ID ||  c.recordtypeid ==label.D_S_Order || c.recordtypeid ==label.Internal_Escalations_RecordId  || c.recordtypeid==label.D_S_Quotes_Orders_RT || c.recordtypeid ==label.Returns_Recordtypeid || c.recordtypeid ==label.ReturnsPRO_Id || c.recordtypeid ==label.R_O_DoD_Need_Contract  || c.recordtypeid==label.Customer_Master_Data_Record_Type ||c.recordtypeid==label.GDC_Accounts ||c.recordtypeid==label.HAPP_Accts ||c.recordtypeid==label.MSP_Contract ||c.recordtypeid==label.NavDB_Accts || c.recordtypeid==label.TechPubs_RecordType_ID || c.recordtypeid==label.GSS_Quotes_Orders || c.recordtypeid==label.HUMS_Data_Services))
            {
                  
                if (c.status.contains('Hold') && (oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c || oldMap.get(c.id).Status!= c.Status|| oldMap.get(c.id).vn_name__c != c.vn_name__c || oldMap.get(c.id).reason_for_hold__c!= c.reason_for_hold__c) &&  c.vn_name__c != null) 
                {
                                        listcas.add(c);
                }
                
                if ((c.Sub_Status__c!=null && c.sub_status__c.contains('Customer Hold') && !c.sub_status__c.contains('Customer Master Hold') && c.status.contains('Hold')) && c.vn_name__c == null && (oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c || oldMap.get(c.id).Status!= c.Status || c.vn_name__c != oldMap.get(c.id).vn_name__c )) 
                {
                    listcas2.add(c);
                }
                
                if (!c.status.contains('Hold') &&  oldMap.get(c.id).Status!= null && oldMap.get(c.id).Status.contains('Hold') && (oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c || oldMap.get(c.id).Status!= c.Status || oldMap.get(c.id).vn_name__c != c.vn_name__c || oldMap.get(c.id).reason_for_hold__c!= c.reason_for_hold__c)) 
                {
                    listcas1.add(c.id); 
                }
            }
            //Modified below line for request INC000010402020 
            if (Trigger.isInsert &&  c.status.contains('Hold') && (c.recordtypeid==label.Orders_Rec_ID || c.recordtypeid ==label.QuotesRecordID || c.recordtypeid==label.D_S_Quotes_Orders_RT || c.recordtypeid ==label.Repair_Overhaul_RT_ID || c.recordtypeid ==label.OEM_Quotes_Orders_ID ||c.recordtypeid ==label.D_S_Order || c.recordtypeid ==label.Internal_Escalations_RecordId || c.recordtypeid ==label.Returns_Recordtypeid || c.recordtypeid ==label.ReturnsPRO_Id || c.recordtypeid ==label.R_O_DoD_Need_Contract || c.recordtypeid==label.Customer_Master_Data_Record_Type ||c.recordtypeid==label.GDC_Accounts ||c.recordtypeid==label.HAPP_Accts ||c.recordtypeid==label.MSP_Contract ||c.recordtypeid==label.NavDB_Accts || c.recordtypeid==label.TechPubs_RecordType_ID || c.recordtypeid==label.GSS_Quotes_Orders || c.recordtypeid==label.HUMS_Data_Services))
            {
                 if(c.vn_name__c != null)
                {
                    listcas.add(c);
                }
                if (c.Sub_Status__c!=null && c.sub_status__c.contains('Customer Hold') && !c.sub_status__c.contains('Customer Master Hold') && c.status.contains('Hold') && c.vn_name__c == null)
                {
                    listcas2.add(c);
                }
            }
            if( Trigger.isUpdate && !UserInfo.getUserName().contains('Approval Process') && (c.recordtypeid==label.Case_AOG_RecordType 
                                                                                             || c.recordtypeid ==label.Case_Technical_Issue_RecordType) )
            {
                System.debug('****'+c.recordtypeid+' '+c.status.contains('Propose to Close') + ' '+c.status);
                if ((c.status.contains('Propose to Close') || 
                     c.status.contains('Open-Rejected') ) && ( oldMap.get(c.id).Status!= c.Status ))
                {
                                        listcas3.add(c);
                }
                if (c.status.contains('On Hold') && ( oldMap.get(c.id).Status!= c.Status ||
                                                     oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c  ))
                {
                    listcas3.add(c);
                    listcas4.add(c.id);
                }
                
                if ((!(c.status.contains('Propose to Close')) && oldMap.get(c.id).Status.contains('Propose to Close'))
                    || (!(c.status.contains('Open-Rejected')) && oldMap.get(c.id).Status.contains('Open-Rejected'))
                    || (!(c.status.contains('On Hold')) && oldMap.get(c.id).Status.contains('On Hold')))
                {
                    listcas4.add(c.id);
                }
            }
        }
        if (listcas.size()>0){
            list<case> listcases = [select id,status, Sub_status__c, reason_for_hold__c, vn_name__r.email, contact.email from case where id=: listcas]; 
            for(case c: listcases ){
                Case_on_hold_log__c cohl = new Case_on_hold_log__c();
                cohl.Case_Number__c = c.id;
                cohl.Action_Owner__c = c.vn_name__r.email;
                cohl.Hold_Start__c = system.now();
                cohl.Reason__c = c.reason_for_hold__c; 
                cohl.Status__c = c.Status;
                /* if(c.Sub_Status__c=='Contracts')
{
cohl.Sub_status_hidden__c='Contracts';
}*/
                cohl.Sub_status_hidden__c=c.Sub_status__c;
                cohl.Sub_Status__c = c.Sub_Status__c;
                system.debug('substatus---->'+cohl.Sub_Status__c);
                listonholdlog.add(cohl);
            }
        }
        if (listcas3.size()>0){
            for(case c: listcas3 ){
                Case_on_hold_log__c cohl = new Case_on_hold_log__c();
                cohl.Case_Number__c = c.id;
                cohl.Hold_Start__c = system.now();
                cohl.Status__c = c.Status;
                cohl.Sub_Status__c = c.Sub_Status__c;
                if(c.Reason_for_Hold__c!=null){cohl.Reason__c= c.Reason_for_Hold__c;}
                if(c.vn_name__c!=null){cohl.Action_Owner__c = c.vn_name__r.email;}
                     listonholdlog.add(cohl);
            }
        }
        if (listcas1.size()>0 || listcas.size()>0 || listcas4.size()>0){
            System.debug('****'+listcas4);
            listonholdlog1 = [select id from Case_on_hold_log__c where Hold_Stop__c = null and (case_number__c =: listcas1 or case_number__c =: listcas or case_number__c =: listcas4)];
        }
        if (listonholdlog1.size()>0){
            for(Case_on_hold_log__c lhl: listonholdlog1 ){
                Case_on_hold_log__c lhl1 = new Case_on_hold_log__c(id =lhl.id);
                lhl1.Hold_Stop__c = system.now();
                listonholdlog.add(lhl1);
            }
        }
        if (!listonholdlog.isEmpty()){
            upsert listonholdlog;
        }
        if (!listcas1.isEmpty()){
            for(id cid: listcas1){
                Case cas = new Case(id =cid);
                cas.vn_name__c = null;
                //cas.sub_status__c = '';
                cas.reason_for_hold__c = ''; 
                listcase.add(cas);
            }
        }
        if (!listcas2.isEmpty()){
            for(case c: listcas2){
                Case cas = new Case(id =c.id);
                cas.vn_name__c = c.contactid;
                listcase.add(cas);
                // Fix for Customer Hold Log creation during update INC000010317862 starts 
                if(Trigger.isUpdate)
                    TriggerInactive.avoidcaseonholdlog = true;
                // Fix for Customer Hold Log creation during update INC000010317862 ends 
            } 
        }
        if (!listcase.isEmpty()){
            // Modified code to avoid duplicate ids error
            removeDuplicateIds.addAll(listcase);
            ActualList.addAll(removeDuplicateIds);
            if (!ActualList.isEmpty()){
                upsert ActualList;
            }
        }
    }
}