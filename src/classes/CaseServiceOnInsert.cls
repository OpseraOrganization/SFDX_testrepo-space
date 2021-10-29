/**
  * @author Swastika Rajkhowa
  * @date 11/10/2017cas
  * @description - Contains entire case trigger logic on before and after insert. 
  */

public with sharing class CaseServiceOnInsert{
            
    /** Created By : Swastika Rajkhowa
      * Date : 02 Nov 2017
      * Trigger : S2S_CEC_2_Aero_Case
      * Line of Code : 46-67
      * Description : added setcaseValues method to assign value of the Export_Compliance_Content_ITAR_EAR__c ,
      *               Government_Compliance_SM_M_Content when case type in ('Technical Issue',Orders).
      * Trigger Event : Before Insert 
      */
    public static void setCaseValues(List<case> caseList){
        Map<String, String> caseType2RecordType = getValueofCustomSettingInMap();      
        for(Case newCase : caseList){
            if(!String.isBlank(newCase.Type)) {
                String recordTypeName = caseType2RecordType.get(newCase.Type);         
                if(recordTypeName!=null){     
                    String recordTypeId = RecordTypeServices.getRecordTypeByName(recordTypeName, 'Case').Id;        
                    if(recordTypeName != null && recordTypeId!= null && newCase.CEC_Record_Type__c != null) {
                        newCase.RecordTypeId = recordTypeId;  
                        newCase.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
                        newCase.Government_Compliance_SM_M_Content__c = 'Undetermined';
                        if (newCase.CEC_Record_Type__c.startsWith('C3'))
                            newCase.Origin = 'Honeywell.com CEC';
                        else if (newCase.CEC_Record_Type__c.startsWith('C4'))
                            newCase.Origin = 'Honeywell.com.cn';                    
                    }
                }
            }
        }   
    }
    
    /*Method to update portal status and request type
* Owner : Hemant 
*/
    Public static void updateFieldsOnCase(list<case> caseList){
        //updateFieldsOnCase1(caseIds);
        system.debug('caseList***' +caseList);
        /*if(caseIds !=null && caseIds.size()>0){

list<case> cs = [select status,Sub_Status__c,recordType.name from case where id in :caseIds];*/
        //if(cs != null && cs.size()>0){
        //To map the portal status value
        list<case> csList = new list<case>();        
        map<String,String> portalStatusMap = new map<String,String>();
        list<AERO_PortalStatus__mdt> portalStatusList= [select Status__c,SubStatus__c,Portal_Status__c from AERO_PortalStatus__mdt];
        for(AERO_PortalStatus__mdt portalStatus :portalStatusList){
            portalStatusMap.put((portalStatus.Status__c+'-'+portalStatus.SubStatus__c).toLowerCase(), portalStatus.Portal_Status__c);
        }
        //To map the portal requestType value
        map<String,String> portalRequestTypeMap = new map<String,String>();
        list<AERO_PortalRequestType__mdt> portalReqTypeList = [Select Label,Portal_request_type__c from AERO_PortalRequestType__mdt];
        for(AERO_PortalRequestType__mdt reqType : portalReqTypeList){
            portalRequestTypeMap.put(reqType.Label,reqType.Portal_request_type__c);
        }
        system.debug('portalRequestTypeMap**' +portalRequestTypeMap);
        //To map portal status for any substatus value
        map<String,String> anyPortalstatMap = new map<String,String>();
        list<AERO_PortalStatus_Any__mdt> anyPortalStatus = [Select Status__c,Portal_Status__c from AERO_PortalStatus_Any__mdt];
        for(AERO_PortalStatus_Any__mdt anyPortStat : anyPortalStatus){
            anyPortalstatMap.put(anyPortStat.status__c,anyPortStat.Portal_Status__c);
        }
        
        for(case c : caseList){
            String portalStatus = '';
            String portalRequestType = '';
            String anyPortStatus = '';
            String key = (c.status+'-'+c.Sub_Status__c).toLowerCase();
            String key2 = c.status;
            String  recTypeId= c.recordTypeId;
            String key1 = '';
            
            system.debug('Schema.SObjectType.case**' +Schema.SObjectType.case);
            system.debug('Schema.SObjectType.case.getRecordTypeInfosById**' +Schema.SObjectType.case.getRecordTypeInfosById());
            system.debug('Schema.SObjectType.case.getRecordTypeInfosById().get(recTypeId)**' +Schema.SObjectType.case.getRecordTypeInfosById().get(recTypeId));
            //system.debug('Schema.SObjectType.case**' +Schema.SObjectType.case);
            if(String.isNotBlank(recTypeId))
            key1 = Schema.SObjectType.case.getRecordTypeInfosById().get(recTypeId).getname();
            
            system.debug('key1***' +key1);
            if(portalStatusMap.containsKey(key)){
                portalStatus = portalStatusMap.get(key);
            }
            if(portalRequestTypeMap.containsKey(key1)){
                portalRequestType = portalRequestTypeMap.get(key1);
                system.debug('portalRequestType***'+portalRequestType);
            }
            if(anyPortalstatMap.containsKey(key2)){
                anyPortStatus = anyPortalstatMap.get(key2);
            }
            if(String.isNotBlank(portalStatus)){
                c.Portal_Status__c = portalStatus;
                c.Portal_request_type__c = portalRequestType;
                system.debug('c.Portal_request_type__c'+c.Portal_request_type__c);
                csList.add(c);
            }else{
                c.Portal_Status__c = anyPortStatus;  
                c.Portal_request_type__c = portalRequestType;
                system.debug('c.Portal_request_type__c'+c.Portal_request_type__c);
                csList.add(c);
            }
        }
        //update csList; 
        
    }

    /** Created By : Garvit Totuka
      * Date : 02 Nov 2017
      * Trigger : Case_ProvideAccess
      * Line of Code : 88 - 103
      * Description : Get Account Ids 
      * Trigger Event : Before Insert
      * Parameters : newCase - Trigger.New
      * Return : List of Ids - Account Ids set IsExpectedUpdateChanged__c field value and return Account Id List
      */
    public static List<Id> beforeInsertGetAccountIds(List<Case> newCase){
        List<Id> accidlist = new List<Id>();
        for(Case cases :newCase){
            if(cases.Expected_Update__c != null && cases.AOG__c == true ){
                cases.IsExpectedUpdateChanged__c = true;
            }
            accidlist.add(cases.accountid);          
        }
        return accidlist;
    }

    /** Created By : Garvit Totuka
      * Date : 02 Nov 2017
      * Trigger : Case_ProvideAccess
      * Line of Code : 233
      * Description : Verify the Compliance and set Is Compliance before inserting Compliance Case
      * Trigger Event : Before Insert
      * Parameters : newCase - Trigger.New
      * Return : void set Iscompliance__c when Case is compliance
      */
    public static void beforeInsertComplianceCase(List<Case> newCase){                 
        Set<ID> conIdSet = new Set<ID>();
        Map<String,String> primEmailMap = new Map<String,String>();
        for(Case cases :newCase){
        
            if(cases.Government_Compliance_SM_M_Content__c == 'Yes'
                || cases.Export_Compliance_Content_ITAR_EAR__c == 'Yes'){                               
                    cases.Iscompliance__c = true;
            }
            
          conIdSet.add(cases.ContactId);
            system.debug('@@@'+conIdSet);
        }
        // For Internal users as Honeywell email address  
        for(Contact co: [Select Id,Primary_Email_Address__c from Contact Where Id IN :conIdSet] )
            {
                primEmailMap.put(co.Id, co.Primary_Email_Address__c);
            }
        for(case c: newCase)
        {
            if(c.ContactId != null)
            {
                if(primEmailMap.get(c.ContactId) != null)
                {
                    if(primEmailMap.get(c.ContactId).contains('@honeywell') != null )
                    { 
                        if(primEmailMap.get(c.ContactId).contains('@honeywell') && ((c.RecordTypeId== RecordTypeServices.getRecordTypeByName('Quotes','Case').Id) || 
                        (c.RecordTypeId== RecordTypeServices.getRecordTypeByName('Orders','Case').Id) ||
                         (c.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id) || 
                         (c.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id) || 
                         (c.recordtypeid == RecordTypeServices.getRecordTypeByName('Returns','Case').Id ) ||
                         (c.recordtypeid == RecordTypeServices.getRecordTypeByName('ReturnsPRO','Case').Id) || 
                         (c.recordtypeid == RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id )))
                        {
                            c.Requested_By_HON_Internal__c= c.ContactID;
                        }
                    }
                }
            }
        }  
    }
    
   //Added for RAPD 2707 Continuation- Attaching acknolwedgmenet email to case
    public static void AddAckEmailTocase(list<case> newcases1)
    { 
        EmailTemplate emTemp = [Select Id,Name,Subject,Body from EmailTemplate where Name = 'Case Creation Acknowledgement To Aero Tech Support'];
        Set<Id>acctIdSet = new Set<Id>();
        for(case cs: newcases1)
        {  
            if(cs.AccountId!=null)
              acctIdSet.add(cs.AccountId);
        }
        Map<String,string> techSupportMap = new Map<String,string>();
        for(Account att :[Select id,Name,ATS_Redirect_to_Portal__c From Account Where Id IN:acctIdSet ])
        {
            techSupportMap.put(att.Id, att.ATS_Redirect_to_Portal__c);
        }
        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
        List<Case> caseList = new List<case>();
        
        for(case cs: newcases1)
        {
              if( techSupportMap.get(cs.AccountId)!=null && (techSupportMap.get(cs.AccountId).contains('Phone and Email') || techSupportMap.get(cs.AccountId).contains('Email')) && cs.Emailbox_Origin__c=='Email-Aerotechsupport' && cs.ContactId!=null)
                {
                    Case newCs = new Case();
                    newCs.Id =cs.Id;
                    newCs.Status ='Closed';
                    caseList.add(newCs) ;
                    
                    Messaging.SingleEmailMessage  emmessage= new Messaging.SingleEmailMessage();
                    emmessage.settemplateID(emTemp.id);
                    emmessage.setTargetObjectId(cs.ContactId);
                    emmessage.whatid =cs.Id;
                    emmessage.setTreatTargetObjectAsRecipient(true);           
                    emmessage.setSaveAsActivity(true);
                    messageList.add(emmessage);                 
                    
                }//if ends 
         
        } //for loop ends
        if(!messageList.isEmpty())
        {
            Messaging.sendEmail(messageList);          
        }
        if(!caseList.isEmpty())
        {
            update caseList;         
        }
        
        
    } //AddAck method ends
    
    
    /** Created By :  
      * Date : 02 Nov 2017
      * Trigger :
      * Line of Code : 
      * Description : 
      * Trigger Event : 
      * Parameters : 
      * Return : 
      */
    public static void beforeInsertMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap ){
    system.debug('Size:'+listObjCaseNew.size());
        list<case_lookup__c> Lookuplist= new list<case_lookup__c>(); 
        Lookuplist=[SELECT subject__c FROM case_lookup__c];
        String sub;
        Set<ID> finalContactId = new set<Id>();
        Set<ID> setOfAccId = new set<Id>();
        Id aeroDefaultUserId = CaseServiceUtility.getAreoDefaultUser();
        Id Norcross_CSR_Queue_ID = Label.Norcross_CSR_Queue_ID; //[SELECT Id FROM Group WHERE Type = 'Queue' and DeveloperName = 'Norcross_CSR_Team'].Id;
        Id CSO_Quality_Team_Queue_Id = Label.CSO_Quality_Team_Queue_Id; //[SELECT Id FROM Group WHERE Type = 'Queue' and DeveloperName = 'CSOQualityTeam'].Id;
        Id Portal_Quotes = label.Portal_Quotes; //[SELECT Id FROM Group WHERE Type = 'Queue' and DeveloperName = 'Portal_Quotes'].Id;      
        
        for(case cas:listObjCaseNew){ 
            finalContactId.add(cas.Contactid);   
            setOfAccId.add(cas.AccountId);                 
        } 
        Map<Id,Account> mapOfAccountandFocalFields = new Map<Id,Account>();
        for(Account accObj : [SELECT Id,Customer_Support_Focal__c,Business_Focal__c FROM Account WHERE Id In: setOfAccId]){
            mapOfAccountandFocalFields.put(accObj.Id,accObj); 
        }  
        Map<id,Contact> lstContact1 = new Map<id,Contact>();
        if(null!=finalContactId && finalContactId.size()>0){
            lstContact1 = new Map<id,Contact>([SELECT Contact_Function__c,Service_Level__c,PFECN__c,SBU_Formulae__c,account.Prism_Redirect__c
                                                    FROM Contact WHERE Id = :finalContactId]); 
        }
        
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        Case exceptionCase = new Case();   
        for(case cas :listObjCaseNew){
            
            //Updated by Radha
            //Service Task:SCTASK1191446 Start
            System.Debug('Customer support focal:' +cas.Customer_Support_Focal__c);
            if(!mapOfAccountandFocalFields.isEmpty() && mapOfAccountandFocalFields.containsKey(cas.accountId) 
                && mapOfAccountandFocalFields.get(cas.accountId).Customer_Support_Focal__c != null /*&& cas.Customer_Support_Focal__c == NULL*/){
                    cas.Customer_Support_Focal__c  = mapOfAccountandFocalFields.get(cas.accountId).Customer_Support_Focal__c;
            }
            System.Debug('Customer support focal- after update:' +cas.Customer_Support_Focal__c);

            //Updated by Radha
            if(!mapOfAccountandFocalFields.isEmpty() && mapOfAccountandFocalFields.containsKey(cas.accountId) 
                && mapOfAccountandFocalFields.get(cas.accountId).Business_Focal__c != null /*&& cas.Business_Focal__c == NULL*/){
                    cas.Business_Focal__c = mapOfAccountandFocalFields.get(cas.accountId).Business_Focal__c;
            }
            //Service Task:SCTASK1191446 End
            
            system.debug('cas.Emailbox_Origin__c: '+cas.Emailbox_Origin__c+',cas.Origin: '+cas.Origin);
            if(cas.Origin != null && cas.Origin == 'Email-Order Status'){
                if(!lstContact1.isEmpty() && lstContact1.containsKey(cas.contactid) && lstContact1.get(cas.contactid).account.Prism_Redirect__c==true){
                    cas.status = 'Rejected';
                    cas.Reason_for_Cancellation__c = 'Redirected to Portal';
                }
            }
            else if(cas.Origin != null && cas.Origin == 'Email-AeroRepairs'){
                if(!lstContact1.isEmpty() && lstContact1.containsKey(cas.contactid) && lstContact1.get(cas.contactid).account.Prism_Redirect__c==true){
                    cas.status = 'Rejected';
                    cas.Reason_for_Cancellation__c = 'Redirected to Portal';
                }
            }
            system.debug('CaseDet===>'+cas);
            if(cas.Contactid!=null && (cas.Origin!=null && (cas.Origin =='Email-Quotes' || cas.Origin =='Email-Orders' || cas.Origin =='Email-AOG' 
                || cas.Origin =='Email- AerospaceWarranty' || cas.Origin =='Email-bga-orders' || cas.Origin =='Email-BGAOEMQuoteOrders' 
                || cas.Origin =='Email-CSO BGA Spares' || cas.Origin =='Email-Disputes'|| cas.Origin =='Email-Order Changes' 
                || cas.Origin =='Email-Order Status'|| cas.Origin =='Email-crc-spex' || cas.Origin =='Email-yeovil.spares' )
                && cas.Origin.contains('Email')) && lstContact1.get(cas.contactid).Service_Level__c=='Unauthorized Dist/Brkr'
                && lstContact1.get(cas.contactid).PFECN__c==null){
                    cas.Status='Closed';
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.setTargetObjectId(cas.contactId);
                    message.setWhatId(cas.ID);                        
                    message.setBccSender(false);
                    message.setUseSignature(false);
                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                    message.setSaveAsActivity(false); 
                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                    message.setTemplateId(label.Unauthorizedtemplate);
                    bulkEmails.add(message);
            }      
            if(cas.Contactid!=null && (cas.Origin!=null && (cas.Origin =='Email-Quotes' || cas.Origin =='Email-Orders' || cas.Origin =='Email-Order Changes' 
                || cas.Origin =='Email-Order Status') && cas.Origin.contains('Email')) && lstContact1.get(cas.contactid).SBU_Formulae__c=='D&S' 
                && lstContact1.get(cas.contactid).Service_Level__c=='Refer to Network' && lstContact1.get(cas.contactid).PFECN__c== null){
                    cas.OwnerId=aeroDefaultUserId;
                    cas.Status='Closed';   
            }  
             // added by abirami for SCTASK2412249  
            
                 if(cas.Emailbox_Origin__c != null 
                && (cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status' || cas.Emailbox_Origin__c == 'Email-Quotes'
                || cas.Emailbox_Origin__c == 'Email-BGAOEMQuoteOrders' || cas.Emailbox_Origin__c == 'Email-CSO BGA Spares') 
                && cas.PFECN__c == 'Portal'){
                cas.status = 'closed';
                }           
            
            if(TriggerInactive.blnCaseWFDelegate ){              
                CaseWorkflowDelegate.caseWFDelegate(listObjCaseNew);
            }
            if((cas.subject!=null) && (cas.origin=='Email-GDC Accounts') && ((cas.subject == 'ARINC Update') 
                || (cas.subject=='HONEYWELL FLIGHT TRACKING REQUESTS') || (cas.subject=='OCD Updates 620') 
                || (cas.subject=='OCD Updates 623') || (cas.subject=='PDC Update') || (cas.subject=='Sat Updates') 
                || (cas.subject=='SITA JetBlue Updates') || (cas.subject=='SITA Updates') || (cas.subject=='VHF Updates'))){            
                    cas.Resolution__c='None';
                    cas.status='Closed';
                    cas.Sub_Class__c='';
                    cas.Export_Compliance_Content_ITAR_EAR__c='No';
                    cas.Government_Compliance_SM_M_Content__c='No';
            }           
            //Added From Process Builder
              if(cas.Origin!=null){
                
                if(cas.Origin == 'Email-ACTinternal'){
                    cas.CSM_Region__c = 'Americas';
                    cas.Workstrem__c = 'Spares';
                }
                if(cas.Origin == 'Email-EMEAACTInternal'){
                    cas.CSM_Region__c = 'EMEAI';
                    cas.Workstrem__c = 'Spares';
                }
                if(cas.Origin == 'Email-APACACTinternal'){
                    cas.CSM_Region__c = 'Asia/Pacific Rim';
                    cas.Workstrem__c = 'Spares';
                }
                if(cas.Origin == 'Email-RO Americas Internal'){
                    cas.CSM_Region__c = 'Americas';
                    cas.Workstrem__c = 'Repair and Overhaul';
                }
                if(cas.Origin == 'Email-RO EMEAI Internal'){
                    cas.CSM_Region__c = 'EMEAI';
                    cas.Workstrem__c = 'Repair and Overhaul';
                }
                if(cas.Origin == 'Email-R&O APAC Internal'){
                    cas.CSM_Region__c = 'Asia/Pacific Rim';
                    cas.Workstrem__c = 'Repair and Overhaul';
                }
                if(cas.Origin == 'Email-OEM Internal'){
                    cas.CSM_Region__c = '';
                    cas.Workstrem__c = 'OEM';
                }
                // Added code for INC000006991156 
                if(cas.Origin == 'Email-DS OEM & Spares Internal'){
                    cas.CSM_Region__c = 'Americas';
                    cas.Workstrem__c = 'Spares';
                    cas.SBU_w2c__c = 'D&S';
                }
                if(cas.Origin == 'Email-DS Repairs Internal'){
                    cas.CSM_Region__c = 'Americas';
                    cas.Workstrem__c = 'Repair and Overhaul';
                    cas.SBU_w2c__c = 'D&S';
                }
                
            }
            //Added From Process Builder
            String usr = userInfo.getUserEmail();        
            if(usr.contains('@newslett')){
                cas.addError('Case cannot be created with mail id contains @newslett');
            } 
            if((cas.SuppliedEmail!=null && (cas.SuppliedEmail=='georgereaver@fgrrb.org' || cas.SuppliedEmail=='notifications@owler.com')) || (cas.SuppliedEmail!=null && cas.SuppliedEmail=='easeadmin@ocr-inc.com' && cas.Origin !=null && cas.Origin=='Email-Aero Export Hold')){       
                cas.addError('Spam Message should not create case!');
            }
            if((cas.subject != null)&&(cas.Subject.contains('How to Get Paid by Uncle Sam - Many New Topics and WAWF Demo'))){
                cas.addError('Spam Message should not create case!');
            }                                   

            if (cas.OwnerId != aeroDefaultUserId && cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('EMS Orders','Case').Id 
                && cas.OwnerId == userinfo.getUserId()){
                    cas.OwnerID = Norcross_CSR_Queue_ID;
                    cas.Classification__c = 'CSO Special Programs';
                    cas.Sub_Class__c = 'EMS Norcross';
                    cas.Detail_Class__c = null;
                    cas.Type = 'Orders';
                    cas.Repair_Location__c = 'Norcross, GA';  
            }  
            if(cas.RecordTypeId==RecordTypeServices.getRecordTypeByName('Pilot’s Corner Avionics','Case').Id){
                cas.type='Pilot\'s Corner Avionics';
                if(cas.Contactid !=null){
                    cas.Web_Portal_Avionics_Pilot_s_Corner__c=cas.Contactid;                    
                    if(null!= lstContact1 && null!= lstContact1.get(cas.contactid)){
                        cas.contact_func__c = lstContact1.get(cas.contactid).Contact_Function__c;
                    }
                }
            }   
            //Added From Process builder
             if(cas.Emailbox_Origin__c=='Email-DIBBS_RFQ' || cas.origin=='Email-DIBBS_RFQ')
            {
                
                cas.ContactId=label.Contact_DIBBS_RFQ;
                
            }
            if((cas.Emailbox_Origin__c != null && (cas.Emailbox_Origin__c=='Email-CSODefects' || cas.origin=='Email-CSODefects')) 
                && (cas.SuppliedEmail!=null && cas.SuppliedEmail=='DDIC@honeywell.com') && (cas.Subject!=null 
                && cas.Subject.startsWith('QN'))){
                    cas.RecordTypeId=RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
                    cas.Type='CSO Defect';
                    cas.Ownerid=CSO_Quality_Team_Queue_Id;   
            }
            if(cas.origin == 'Email-deferredordersweb' || cas.Emailbox_Origin__c == 'Email-deferredordersweb'){
                if(cas.subject!=null && cas.subject.trim() != '' && (cas.Sales_Order_Number__c==null || cas.Sales_Order_Number__c=='') 
                    && (cas.Product_Part_Number__c==null || cas.Product_Part_Number__c =='') && (cas.Customer_PO_RO_WONumber__c==null 
                    || cas.Customer_PO_RO_WONumber__c== '') && (cas.Reason_for_hold__c==null || cas.Reason_for_hold__c=='')){
                        String strEmailSubject ='';
                        Integer intStartIndex;
                        String strFieldValues;
                        List<String> lstFieldValues;
                        strEmailSubject = cas.subject;
                        intStartIndex = strEmailSubject.lastIndexOfIgnoreCase('[');
                        if(intStartIndex!=-1 && strEmailSubject.length() > intStartIndex){
                            strFieldValues = strEmailSubject.substring(intStartIndex+1,strEmailSubject.length()-1);
                            lstFieldValues = strFieldValues.split('\\|');
                            if(lstFieldValues.size() >= 4){
                                cas.subject = strEmailSubject.substring(0,intStartIndex);
                                cas.Sales_Order_Number__c = lstFieldValues[0];
                                cas.Product_Part_Number__c = lstFieldValues[1];
                                cas.Customer_PO_RO_WONumber__c = lstFieldValues[2];
                                cas.Reason_for_hold__c = lstFieldValues[3];
                                if(lstFieldValues.size() == 5 && lstFieldValues[4]!= null && lstFieldValues[4].trim()!=''){
                                    if(lstFieldValues[4] == 'SPEX'){
                                        cas.SPEX_Exchange__c = True;
                                    }
                                }
                            }
                        }
                    }
            }
            if( cas.recordtypeid == RecordTypeServices.getRecordTypeByName('CAMP Issues','Case').Id 
                && (cas.origin == 'Email-trandsupport')){
                string slno = cas.subject;
                List<string> hits = new List<String>();
                String[] Patterns = new String[]{};
                Patterns.add('([0-9]|[A-Z]|-|_){4,15}');        
                Patterns.add('([0-9]|[A-Z]|/){4,15}');         
                Patterns.add('([0-9]){7}[\\s]([0-9]){2}');
                Patterns.add('^(?=.*[0-9].*)([-|A-Z|0-9]{4,15})$');

                Pattern p; 
                Matcher m; 
                for(string pat : patterns){
                    p = Pattern.compile(pat);
                    m = p.matcher(slno);
                    while(m.find()){
                        hits.add(m.group());
                    }
                }
                List<string> hitsTemp = new List<string>();
                for(string h : hits){
                    if(!h.containsAny('1234567890')){
                        continue;
                    }
                    hitsTemp.add(h);
                }
                hits = hitsTemp;
                if(hits != null && hits.size() > 0){
                    cas.Serial_Number__c = hits.get(0);                
                    cas.Status='Closed';
                    cas.Resolution__c = label.Resolution_text_for_CAMP_issues;                 
                }
                else {
                    cas.Serial_Number__c = 'N/A';                
                    cas.Status='Closed';
                    cas.Resolution__c = label.Resolution_text_for_CAMP_issues;  
                }
            }
            
            if(cas.subject != NULL){
                if(cas.origin=='Email-CPSQuotesCOE'   || cas.origin=='Email-CPSQuotesCOEANNTMPTUC'||
                    cas.origin=='Email-CPSQuotesCOEDVCR'   ||  cas.origin=='Email-CPSQuotesCOEPHX'){
                        if(cas.subject.contains('has sent fax')){
                            cas.subject.addError('Email Message having success for Fax Creation not needed');           
                        }
                }
                if((cas.origin=='Email-GDC FS1')||(cas.origin=='Email-GDC FS')||(cas.origin=='Email-GDC GFO')) {
                    if((cas.subject.contains('Reservation Details'))||(cas.subject.contains('Acquire Reservation'))
                        ||(cas.subject.contains('Confirm Reservation')) ||(cas.subject.contains('Blackberry Summary'))
                        ||(cas.subject.contains('FAA Command Center Message'))||(cas.subject.contains('Global Data Center CDM')) 
                        ||(cas.subject.contains('Global Data Center FS Daily'))||(cas.subject.contains('ITF Trip'))
                        ||(cas.subject.contains('Flight Plan Summary')) ||(cas.subject.contains('Undelivered Mail Return to Sender'))
                        ||(cas.subject.contains('Western Service Area Outlook'))||(cas.subject.contains('[NBAA-GADesk]'))
                        ||(cas.subject.contains('Email/Manual Fax'))||(cas.subject.contains('Scan FROM a Xerox Workcentre'))
                        ||(cas.subject.contains('FrontierMedex'))||(cas.subject.contains('TRC Report'))
                        ||(cas.subject.contains('Western Service Area Outlook'))||(cas.subject.contains('FAA COMMAND CENTER MESSAGE'))
                        ||(cas.subject.contains('Mail System Error'))){
                            cas.subject.addError('Spam Message should not create case'); 
                    }
                    if((cas.origin=='Email-GDC FS')||(cas.origin=='Email-GDC GFO')){
                        if((cas.subject.contains('ADNS MESSAGE TO KSNAXGXS'))||(cas.subject.contains('FAA ICAO FPL ACK'))
                            ||(cas.subject.contains('FAA ICAO FPL REJ'))||(cas.subject.contains('Updated Manual Fax'))
                            ||(cas.subject.contains('New Manual Fax'))||(cas.subject.contains('Fax Status Alert'))
                            ||(cas.subject.contains('Manual PKG:'))){ 
                                cas.subject.addError('Spam Message should not create case');   
                        }
                    }
                    if(cas.origin=='Email-GDC FS'){
                        if((cas.subject.contains('XOJET MSG'))||(cas.subject.contains('FS MESSAGE'))){
                            cas.subject.addError('Spam Message should not create case'); 
                        }
                    }
                    if(cas.origin=='Email-GDC GFO'){
                        if((cas.subject.contains('NET JET MSG'))||(cas.subject.contains('OTHER MSG'))
                            ||(cas.subject.contains('Flight Plan Request'))||(cas.subject.contains('Weather Request -'))
                            ||(cas.subject.contains('Submission FROM'))){
                                cas.subject.addError('Spam Message should not create case'); 
                        }
                    }
                    if(cas.origin=='Email-GDC FS1'){
                        if((cas.subject.contains('New ITF trip for'))||(cas.subject.contains('ITF trip changed'))){
                            cas.subject.addError('Spam Message should not create case'); 
                        }
                    }
                }
                if( cas.origin=='Email-SFDC_CustomerMaster'&& cas.subject.contains('Contract Expiration Mail') ){
                    cas.subject.addError('Spam Message should not create case'); 
                }       
                sub = '';               
                sub = cas.subject.toUpperCase();          
                for(integer i=0;i<Lookuplist.size();i++){
                    if(Lookuplist[i].subject__C !=null){
                        Lookuplist[i].subject__C =  Lookuplist[i].subject__C.toUpperCase();
                        if( sub.contains(Lookuplist[i].subject__C)){
                            cas.subject.addError('Email Message with subject Out Of Office Cannot be created');                    
                        }
                    }
                }
                if((sub.contains('USER') && sub.contains('HAS DOWNLOADED') && sub.contains('MORE THAN') && sub.contains('TIMES')) 
                    || (sub.contains('ACCOUNT TO INDS') && !(sub.contains('RE:'))  && !(sub.contains('FW:')) && !(sub.contains('FWD:'))) ){
                        cas.subject.addError('Email Message with Junk Subjects Cannot be created');                 
                }
            } 
            if((cas.SuppliedEmail=='george.risinger@honeywell.com')||(cas.SuppliedEmail=='APISConfirmNoReply@dhs.gov')
                ||(cas.SuppliedEmail=='news@aviationnews.us'))
                    cas.subject.addError('Spam Message should not create case');  
            if((cas.SuppliedEmail=='gfo@mygdc.com') || (cas.SuppliedEmail=='gfo@v-30fe36sg7jwdbs9uz1oysh36.3dwxyeau.3.case.salesforce.com')){
                if((cas.subject != null) && ((cas.subject.contains('Flight Plan Request'))||(cas.subject.contains('Weather Request -'))
                    ||(cas.subject.contains('Submission FROM')))){
                        cas.subject.addError('Spam Message should not create case');    
                }
            }  
            if((cas.SuppliedEmail=='CTSEFTCW@HONEYWELL.COM') || (cas.SuppliedEmail=='wawfnoreply@csd.disa.mil')){
                if((cas.origin == 'Email-GDC Accounts')){
                    cas.subject.addError('Spam Message should not create case');    
                }
            }
            if(null!=cas.SuppliedEmail && cas.SuppliedEmail.toUpperCase().contains('DONT-REPLY-AOG-DESK@SERVICES.DLH.DE')){
                cas.Subject.addError('Case cannot create');
            }

            if(cas.RecordTypeId== RecordTypeServices.getRecordTypeByName('Quotes','Case').Id  && cas.Origin=='Web' 
                && cas.Total__c > 0 && cas.Total__c!=null){
                    cas.OwnerId=Portal_Quotes;
                    cas.Classification__c='Portal Spares';
                    cas.Status='Portal Quoted';       
            }                      
        }
        try{
            if(bulkEmails.size() >0){        
            Messaging.reserveSingleEmailCapacity(trigger.size); 
            Messaging.sendEmail(bulkEmails);  
            }
        }catch(Exception e){
            MainCaseTriggerUtility.handleCaseException(e,exceptionCase);
        }  
        CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(listObjCaseNew,oldMap,'Insert');
        caseGDCTechIssueOps.updateDueDateonInsert(listObjCaseNew);     
        
    }
    
    /** Created By :  
      * Date : 02 Nov 2017
      * Trigger :
      * Line of Code : 
      * Description : 
      * Trigger Event : 
      * Parameters : 
      * Return : 
      */
    public static void beforeInsertOwnerAssignmentMethod(List<Case> listObjCaseNew){
        for(case cas:listObjCaseNew){
            if(cas.Subject != null && cas.Subject.toUpperCase().contains('; SPEX') && cas.origin == 'Email-deferredordersweb'){
                cas.ownerid = label.Spex_Orders_Team_Queue_Id;
                cas.Sub_Class__c='SPEX/Exchange';                      
                cas.recordtypeid=RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
                cas.Classification__c='CSO Spares';
                cas.Detail_Class__c='';
                cas.Priority = 'Normal';
                cas.Type='Place Order';
                cas.origin = 'Email';
                cas.Emailbox_Origin__c = 'Email-deferredordersweb';
                cas.Mail_Box_Name__c = 'Email-deferredordersweb';
            }else if(cas.origin == 'Email-deferredordersweb'){
                cas.ownerid = label.Deferred_Orders_Team_Id;
            }
        }
    }

    /** Created By : Swastika Rajkhowa
      * Date : 02 Nov 2017
      * Trigger : S2S_CEC_2_Aero_Case
      * Line of Code : 69-116
      * Description : After case insertion in Aero, save the CEC case id
      * Trigger Event : After Insert 
      */
    public static void AfterInsertUpdateCaseCEC(List<Case> listObjCaseNew){
        Set<Id> sbuCaseTypes = new Set<Id>();
        Map<String, String> caseType2RecordType = getValueofCustomSettingInMap();
        Set<Id> casesToUpdate = new Set<Id>();     
        for(Case newCase : listObjCaseNew) {
            String recordTypeName = caseType2RecordType.get(newCase.Type);   
            if(recordTypeName!='' && recordTypeName!=null){
                string recordTypeId = RecordTypeServices.getRecordTypeByName(recordTypeName, 'Case').Id; 
                if(recordTypeId!=null) {
                    if(String.isBlank(newCase.CEC_Case_Id__c)) {
                        casesToUpdate.add(newCase.Id);
                    }
                }
            }
        }
        if(casesToUpdate != null){ // added by kayal for 101 if condition
        List<PartnerNetworkRecordConnection> receivedCases = [SELECT Id, Status, LocalRecordId, PartnerRecordId
                                   FROM PartnerNetworkRecordConnection
                                   WHERE Status='Received' and LocalRecordId IN :casesToUpdate];
        List<Case> listCase= [SELECT Id, CEC_Case_Id__c FROM Case WHERE Id IN :casesToUpdate];                                                         
        if(receivedCases!=null){                                                      
            updateCECCaseId(receivedCases,listCase);
        }
        } // ended by kayal for 101 if condition
    }

    /** Created By : Garvit Totuka
      * Date : 02 Nov 2017
      * Trigger : Case_ProvideAccess
      * Line of Code : 204 - 231
      * Description : Create a compliance Case (SR#426679)
      * Trigger Event : After Insert
      * Parameters : newCase - Trigger.New
      * Return : void - insert Compliance Case
      */
    public static void afterInsertComplianceCase(List<case> newCase){
        List<Compliance_Case__c> complianceCases = new List<Compliance_Case__c>();
        for(Case cases :newCase){
            if(cases.Government_Compliance_SM_M_Content__c == 'Yes'
            || cases.Export_Compliance_Content_ITAR_EAR__c == 'Yes'){
                Compliance_Case__c compliance = new Compliance_Case__c();              
                if(cases.classification__C != null && cases.classification__c == 'CSO Spares'){
                    compliance.Queue_Name__c = 'Compliance Queue CSO';
                }
                else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id){
                    compliance.Queue_Name__c = 'Compliance Queue CSO';
                }
                else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id 
                    && cases.classification__C != null && cases.classification__c != 'GTO D&S Technical Issue'){  
                        compliance.Queue_Name__c = 'Compliance Queue GTO';
                }                               
                else {
                    compliance.Queue_Name__c = 'Compliance Queue CSO';
                }
                system.debug('Creating CC');
                compliance.name = cases.CaseNumber;
                compliance.Subject__C = cases.subject;
                compliance.contact_name__C = cases.contact_name__C;
                compliance.Account_Name__c = cases.Account_Name__c;
                compliance.Type__c = cases.Type;
                compliance.Origin__c = cases.Origin;
                compliance.Classification__c = cases.Classification__c;
                compliance.Service_Level_Status_Flag__c = cases.Service_Level_Status_Flag__c;
                compliance.Status__c = cases.Status;
                compliance.created_By__c = cases.CreatedById;    
                complianceCases.add(compliance);
            }
        }
        if(complianceCases.size() > 0){
            try{
                insert complianceCases;
                system.debug('Insert CC');
            }
            catch(Exception e){
                System.debug('Exception occured in Case_provide Access '+e);
            }
        }
    }
    /** Created By :  Ravi B
      * Date : 03 July 2019
      * Trigger : CaseTrigger     
      * Description : Passing Case details to SAP 
      * Trigger Event : After Insert
      * Parameters : List<case> newCase
      * Return : Void
      */
    public static void afterInsertCaseDetailstoSAP(List<case> newCase)
    {
      system.debug(System.LoggingLevel.WARN,'***Entered into afterInsertCaseDetailstoSAP method****'+newCase);     
     
      Map<Id,Case> mapOfCaseDetails = new Map<Id,Case>();
      for(Case cas : newCase){        
         if(cas.recordtypeId == RecordTypeServices.getRecordTypeByName('Orders','Case').Id &&
            cas.origin == 'Email' && cas.Classification__c =='CSO Spares' &&
            (cas.Emailbox_Origin__c == 'Email-deferredordersweb' || cas.Emailbox_Origin__c == 'Email-OrdersWeb'))
         {
          mapOfCaseDetails.put(cas.Id,cas);
         }
         
      }
      system.debug(System.LoggingLevel.WARN,'mapOfCaseDetails=====>'+mapOfCaseDetails);
      /**if(!mapOfCaseDetails.isEmpty())
      {
        ID jobID = System.enqueueJob(new CaseDeferredOrdersDetailstoSAP(mapOfCaseDetails));
        System.debug(System.LoggingLevel.WARN,'Running Job at After Insert Case Details to SAP Id:'+jobID);
      } */
    }
    
    /** Created By : Garvit Totuka
      * Date : 02 Nov 2017
      * Trigger : Case_ProvideAccess 
      * Line of Code : 565 - 578, 676 - 707
      * Description : Provide CSO or GTO Access 
      * Trigger Event : After Insert
      * Parameters : newCase - Trigger.New
      * Return : void insert CaseShare for CSO or GTO
      */
    public static void afterInsertProvideAccess(List<case> newCase){
        List<ID> provideCSOAccess = new List<ID>();
        List<ID> provideGTOAccess = new List<ID>();
        List<CaseShare> lsshare = new List<CaseShare>();
        for(Case cases :newCase){
            if(cases.recordtypeId != RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id ){
                if((cases.Export_Compliance_Content_ITAR_EAR__c == 'No' && cases.Government_Compliance_SM_M_Content__c == 'No' ) 
                    || (cases.Export_Compliance_Content_ITAR_EAR__c == 'Undetermined' && cases.Government_Compliance_SM_M_Content__c == 'Undetermined')          
                    && cases.IsAccountWebform__c == false){
                        if(cases.recordtypeId == RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id){
                            provideGTOAccess.add(cases.id);                
                        }
                        else{                
                            provideCSOAccess.add(cases.id);  
                        }               
                }
            }
        }
        Id idCSO = Label.IdCSO;
        if(provideCSOAccess.size() > 0){
            for(Id pcsoaccess :provideCSOAccess){        
                CaseShare s = new CaseShare();
                s.UserOrGroupId = idCSO;
                s.CaseAccessLevel = 'Edit' ;
                s.CaseId = pcsoaccess;
                lsshare.add(s);
            }
        }
        Id idTech_Issue = Label.IdTech_Issue;
        if(provideGTOAccess.size() > 0){
            for(Id pgtoaccess :provideGTOAccess){        
                CaseShare s = new CaseShare();
                s.UserOrGroupId = idTech_Issue;
                s.CaseAccessLevel = 'Edit' ;
                s.CaseId = pgtoaccess;
                lsshare.add(s);
            }
        }   
        if(lsshare.size() > 0){
            try{           
                insert lsshare;
            }
            catch(Exception e){
                System.debug('Exception in inserting share records '+e);
            }
        }
    }

   
    /** Created By :  
      * Date : 02 Nov 2017
      * Trigger :
      * Line of Code : 
      * Description : 
      * Trigger Event : 
      * Parameters : 
      * Return : 
      */
    private static Map<string,string> getValueofCustomSettingInMap() {
        List<CaseType_RecordType__c> list_CaseType_RecordType= CaseType_RecordType__c.getall().values();
        Map<String, String> customSettingMap = new Map<String, String>();  
        if(list_CaseType_RecordType.size()>0){
            for(CaseType_RecordType__c objCSetting : list_CaseType_RecordType){
                customSettingMap .put(objCSetting.Case_type__c,objCSetting.Record_Type__c); 
            }
        } 
        return customSettingMap; 
    }

    /** Created By :  
      * Date : 02 Nov 2017
      * Trigger :
      * Line of Code : 
      * Description : 
      * Trigger Event : 
      * Parameters : 
      * Return : 
      */
    private static void updateCECCaseId(List<PartnerNetworkRecordConnection> receivedCases,List<Case> list_Case) {
        Map<Id, Id> caseSBUToCEC = new Map<Id, Id>();
        for(PartnerNetworkRecordConnection record : receivedCases) {
            caseSBUToCEC.put(record.LocalRecordId, record.PartnerRecordId);
        }     
        if(caseSBUToCEC.isEmpty() && (!Test.isRunningTest())) {
            return;
        }     
        List<Case> caseToUpdate = new List<Case>();
        for(Case newCase : list_Case){
            if(caseSBUToCEC.containsKey(newCase.Id)) {
            newCase.CEC_Case_Id__c = caseSBUToCEC.get(newCase.Id);
            caseToUpdate.add(newCase);
            }
        }
        if(!caseToUpdate.isEmpty()) {
            update caseToUpdate;
        }
    }

    /** Created By :  
      * Date : 02 Nov 2017
      * Trigger :
      * Line of Code : 
      * Description : 
      * Trigger Event : 
      * Parameters : 
      * Return : 
      */
    public static void afterInsertMethod(Boolean isInsert,List<Case> listObjCaseNew,Map<ID,Case> oldMap){
        CaseServiceForCommonMethods.UpdateOppProposalCase(listObjCaseNew,oldMap);
        CaseServiceForCommonMethods.CaseOnHoldMethod(listObjCaseNew,null,'Insert');
        CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,listObjCaseNew,oldMap); 
        Boolean bolChangesPresent = false;
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>(); 
        Set<id> setList1 = new Set<id>();
        List<Case_Extension__c> cextlist = new List<Case_Extension__c>();
        Set<id> cascextid = new Set<id>();
        Set<id> casidforExt = new Set<id>();
        List<Case_Extension__c> sbucextlist = new List<Case_Extension__c>();
        Date dt = date.valueOf(label.Created_Date_31Aug2015);
        Date Createddatee;
        List<Case> onholdcaselist = new List<Case>();   
        Map<id,String> onholdids = new Map<ID,String>();
        List<Technical_Issue_Case_Extensions__c> caseextlist = new List<Technical_Issue_Case_Extensions__c>();

        for(Case objCs : listObjCaseNew ){ 
            if(objCs.Status == 'On Hold' &&  objCs.Sub_Status__c =='Waiting for TCT' && objCs.Case_Record_Type__c == 'Technical Issue'){
                onholdids.put(objCs.id,'Waiting for TCT');
            }
            else if(objCs.Status == 'On Hold' &&  objCs.Sub_Status__c =='Waiting for Customer Feedback' && objCs.Case_Record_Type__c == 'Technical Issue'){
                onholdids.put(objCs.id,'Waiting for Customer Feedback');
            }
            else if(objCs.Status == 'On Hold' &&  objCs.Sub_Status__c =='Waiting for EPS/Engineering' && objCs.Case_Record_Type__c == 'Technical Issue'){
                onholdids.put(objCs.id,'Waiting for EPS/Engineering');
            }
            else if(objCs.Status == 'On Hold' &&  objCs.Sub_Status__c =='Waiting for Honeywell Internal' && objCs.Case_Record_Type__c == 'Technical Issue'){
                onholdids.put(objCs.id,'Waiting for Honeywell Internal');
            }
            
            Createddatee = Date.valueOf(objCs.Createddate);            
//included record types for Case EXTN creation from AOG to Warranty            
            if(Createddatee>dt && null!=objCs.Case_Record_Type__c && (objCs.Case_Record_Type__c == 'Orders' 
                || objCs.Case_Record_Type__c == 'Quotes' || objCs.Case_Record_Type__c == 'Repair & Overhaul'  
                || objCs.Case_Record_Type__c == 'OEM/Spares'|| objCs.Case_Record_Type__c == 'Internal Escalations' 
                || objCs.Case_Record_Type__c == 'OEM Quotes Orders' || objCs.Case_Record_Type__c == 'AOG' || objCs.Case_Record_Type__c == 'Exchange' 
                || objCs.Case_Record_Type__c == 'WEB Portal Registration' || objCs.Case_Record_Type__c == 'Customer Master Data' || objCs.Case_Record_Type__c == 'ERB Management' || objCs.Case_Record_Type__c == 'Engine Rentals' || objCs.Case_Record_Type__c == 'ISS Invoicing' || objCs.Case_Record_Type__c == 'ISS Orders' || objCs.Case_Record_Type__c == 'ITEC Quotes Orders' 
                || objCs.Case_Record_Type__c == 'ReturnsPRO' || objCs.Case_Record_Type__c == 'Warranty'                                                       
                || objCs.Case_Record_Type__c == 'Core Recovery')){
                    casidforExt.add(objCs.id);          
            }
            if(null!=objCs.Case_Record_Type__c && (objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('General','Case').Id 
                || objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id 
                || objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders','Case').Id
                || objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('Returns','Case').Id 
                || objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id 
                || objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM/Spares','Case').Id 
                || objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id 
                ||objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('Core Recovery','Case').Id )){
                    cascextid.add(objCs.id);
            } 
            if(objCs.recordtypeid == RecordTypeServices.getRecordTypeByName('Tech Pubs','Case').Id 
                && objCs.HIPI_Opportunity__c == true){
                    setList1.add(objCs.id);
            }
        }
        if(setList1.size()>0) {
            CallServicetoCreateClass.classService(setList1);
        }       
        if(!onholdids.isEmpty() || !casidforExt.isEmpty() || !cascextid.isEmpty()){
            onholdcaselist = [SELECT id,CaseNumber,contactid,Contact.Name,Subject,accountid,Account.Type,Contact.Address_Line_1__c,
                                Contact.Honeywell_ID__c,recordtypeid,SBU__c,Contact.Account_Name__c,Contact.Fax,Contact.Email,
                                Contact.FirstName,Contact.Middle_Name__c,Contact.LastName,Sub_Status__c,Case_Record_Type__c,status,
                                    (SELECT id,case_object__c,Waiting_for_TCT_Start_Time__c,Waiting_for_TCT_End_Time__c,
                                            Customer_Feedback_Hold_End_time__c,Customer_Feedback_Hold_Start_time__c,
                                            EPS_Engineering_Hold_End_time__c,EPS_Engineering_Hold_Start_Time__c,
                                            Honeywell_Internal_Hold_End_time__c,Honeywell_Internal_Hold_Start_time__c 
                                        FROM case.Technical_Issue_Case_Extensions__r), 
                                    (SELECT id,Case_object__c,Date_Time_Stamp_of_SBU_Determined__c FROM Case_Extensions__r) 
                                FROM case 
                                WHERE id in : onholdids.keySet() or id IN:casidforExt or id IN:cascextid ];
        }
        for(case cas:onholdcaselist){
            if(cas.Case_Record_Type__c == 'Technical Issue'){
                Technical_Issue_Case_Extensions__c CasExt = new Technical_Issue_Case_Extensions__c();
                for(Technical_Issue_Case_Extensions__c ce : cas.Technical_Issue_Case_Extensions__r){
                CasExt.id = ce.id; 
            }
            if(onholdids.get(cas.Id) == 'Waiting for TCT'){
                CasExt.Waiting_for_TCT_Start_Time__c = system.now();
            }
            else if(onholdids.get(cas.Id) == 'Waiting for Customer Feedback')
                CasExt.Customer_Feedback_Hold_Start_time__c = system.now();
            else if(onholdids.get(cas.Id) == 'Waiting for EPS/Engineering')
                CasExt.EPS_Engineering_Hold_Start_Time__c = system.now();
            else if(onholdids.get(cas.Id) == 'Waiting for Honeywell Internal')
                CasExt.Honeywell_Internal_Hold_Start_time__c = system.now();
            caseextlist.add(CasExt);  
            }
            //included new record types for Case EXTN creation(AOG - Warranty)
            if((Createddatee>dt && null!=cas.Case_Record_Type__c && (cas.Case_Record_Type__c == 'Orders' 
                || cas.Case_Record_Type__c == 'Quotes' || cas.Case_Record_Type__c == 'Repair & Overhaul' 
                || cas.Case_Record_Type__c == 'OEM/Spares' || cas.Case_Record_Type__c == 'Internal Escalations' 
                || cas.Case_Record_Type__c == 'OEM Quotes Orders' || cas.Case_Record_Type__c == 'AOG' || cas.Case_Record_Type__c == 'Exchange' 
                || cas.Case_Record_Type__c == 'Customer Master Data' || cas.Case_Record_Type__c == 'ERB Management' || cas.Case_Record_Type__c == 'Engine Rentals' || cas.Case_Record_Type__c == 'ISS Invoicing' 
                || cas.Case_Record_Type__c == 'ISS Orders' || cas.Case_Record_Type__c == 'ReturnsPRO' || cas.Case_Record_Type__c == 'Warranty' || cas.Case_Record_Type__c == 'ITEC Quotes Orders' || (cas.Case_Record_Type__c == 'WEB Portal Registration' 
                && (cas.Subject!=null && cas.Subject.contains('Maintenance Advisor')))) )
                || (null!=cas.Case_Record_Type__c && (cas.recordtypeid == RecordTypeServices.getRecordTypeByName('General','Case').Id 
                || cas.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id 
                || cas.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders','Case').Id 
                || cas.recordtypeid == RecordTypeServices.getRecordTypeByName('Returns','Case').Id 
                || cas.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id 
                || cas.recordtypeid == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id 
                ||cas.recordtypeid == RecordTypeServices.getRecordTypeByName('Core Recovery','Case').Id  )) ){
                    Case_Extension__c CasExt = new Case_Extension__c();
                    CasExt.Name = cas.CaseNumber+'_Ext';
                    if(cas.Case_Extensions__r!=null && cas.Case_Extensions__r.size()>0){                    
                        CasExt = cas.Case_Extensions__r;
                        if(cas.SBU__c!= null && cas.SBU__c!='Intercompany') // added by kayal for 101
                        CasExt.Date_Time_Stamp_of_SBU_Determined__c=system.now(); // added by kayal for 101
                    }else{
                        CasExt.Case_object__c = cas.id;  
                        if(cas.SBU__c!= null && cas.SBU__c!='Intercompany') // added by kayal for 101
                        CasExt.Date_Time_Stamp_of_SBU_Determined__c=system.now(); // added by kayal for 101              
                    }
                    cextlist.add(CasExt);
                    /*if(cas.SBU__c!= null && cas.SBU__c!='Intercompany'){
                        CasExt.Date_Time_Stamp_of_SBU_Determined__c=system.now();
                        sbucextlist.add(CasExt);
                    }*/ //Commented by Kayal for 101 error
            }
        }
        if(!caseextlist.isEmpty()){ 
            try{
                upsert caseextlist;
            } 
            catch(DMLException e){
                System.debug('Exception occured in After Insert Helper '+e);
            } 
        }
        if(!cextlist.isEmpty()){  
            try{
                upsert cextlist;
            }   
            catch(DMLException e){
                System.debug('Exception occured in After Insert Helper '+e);
            } 
        }
        if(!sbucextlist.isEmpty()){         
            try{
                upsert sbucextlist;
            } 
            catch(DMLException e){
                System.debug('Exception occured in After Insert Helper '+e);
            } 
        }                    
       // CaseServiceForCommonMethods.afterinsertMethod_emailMessaging(true,listObjCaseNew,oldMap);     
    }
   public static void OwnerAssignmentForCSOCasesAfterInsert(List<Case> listObjCaseNew)
    {
        Map<id,Case> lstCas = new Map<id,Case>([select id,Account.Type,Account.Is_Bendix_King_Dealer__c,
        Account.Strategic_Business_Unit__c,account.Service_Level__c,ownerid,SBU__c,
        account.name,account.Orders_Next_Wave__c,account.Orders_Next_Wave_Check_Time__c from case where id =: listObjCaseNew]);        
        list<case> updateCase = new list<case>();
        for(case cas:listObjCaseNew)
        { 
        // start orders, OrdersWeb email-box//
        String[] emailAddressArr1 = (label.ATR_Customers_to_the_Send_to_Portal).split(','); 
        boolean check1=false; 
        for(String s: emailAddressArr1){
            if(cas.SuppliedEmail!=null){
                if(cas.SuppliedEmail.contains(s))
                {
                    check1=true;
                    break;
                }
            }
        }
        boolean emailDomain1 = (cas.SuppliedEmail !=null) && (check1)? true : false; 
           if((cas.origin == 'Email-Orders' && 
           (
           (cas.SBU__c == 'BGA'  && (!cas.SuppliedEmail.contains('@equipaero.com' ) 
           || !cas.SuppliedEmail.contains('@aarcorp.com') || !cas.SuppliedEmail.contains('@triumphgroup.com')||!emailDomain1) 
           ) 
           || (cas.SBU__c =='ATR' && (cas.Do_Not_Send_to_Portal__c || 
           (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && lstcas.get(cas.id).account.Orders_Next_Wave__c==true && 
           lstcas.get(cas.id).account.Service_Level__c=='Unauthorized Dist/Brkr' && cas.Do_Not_Send_to_Portal__c )))
           || cas.SBU__c =='D&S' || (cas.SBU__c !='ATR' || cas.SBU__c !='BGA' || cas.SBU__c !='D&S')) 
           &&((cas.Subject!= null && (!cas.Subject.contains('BFE')||!cas.Subject.contains('SFE')||!cas.Subject.contains('bfe')||!cas.Subject.contains('sfe')))|| cas.subject == null)
            ) 
           || cas.origin == 'Email-OrdersWeb' 
           || (cas.origin == 'Email-Order Changes' && 
           (!cas.Subject.contains('BFE')||!cas.Subject.contains('SFE')||!cas.Subject.contains('bfe')||!cas.Subject.contains('sfe')))
           )
           {
           case c= new case (id = cas.id);
               if( cas.Account_type__c == 'Leasing Company'){
                    c.ownerid = label.Leasing_Team_Id;   //Leasing team queue
               }
               else if(cas.Work_Team__c == 'India Team'){
                    c.ownerid = label.India_Orders_Team_Id;   //India team queue 
               }
               else if(cas.SBU__c == 'D&S'){
                    c.ownerid = label.DS_Orders_Team_Id;   //DS Orders team queue   
               }
               else if(cas.region__c == 'Asia/Pacific Rim' && cas.Account_type__c != 'OEM')
               {
                    c.ownerid = label.APAC_Spares_Team_Id;   //APAC Spares team queue 
               }else if(cas.region__c == 'Asia/Pacific Rim' && cas.Account_type__c == 'OEM')
               {
                    c.ownerid = label.APAC_OEM_Team_Id;   //APAC OEM team queue   
               }else if(cas.SBU__c == 'ATR' || cas.SBU__c == 'BGA')
               {
                    c.ownerid = label.CA_Orders_Team_Id;   //CA Orders Team queue
               }else if(cas.origin == 'Email-Order Changes')
               {
                    c.ownerid = label.Order_Changes_Team;   //Order Changes team queue 
               }else
               {
                   system.debug('InsideOwnerAssignmentForCSOCases2'+cas.Subject);
                    c.ownerid = label.Orders_Team_Id;   //Orders team queue 
               }
               updateCase.add(c);
           }
        // end orders, OrdersWeb email-box//
        }
        if(!updateCase.isEmpty())
        {
            try
            {
                update updateCase;
            }catch (exception e)
            {
                system.debug('exception in OwnerAssignmentForCSOCases class'+e);
            }
         }
    } 
    
    //MT-845 Ticket 
     public static void emailMessage(list<case> newcases)
    {
    
    //list<case>caseList =[select id,subject,contactid,Type,origin from case where id=:caseIdSet ];
    List<Messaging.SingleEmailMessage> mails = new List <Messaging.SingleEmailMessage>();
     for (case currentRecord: newcases) {
    //Mt-1297
    if (currentRecord.contactid != null && currentRecord.origin=='Web' && currentRecord.subject.startswith('Order Number') && currentRecord.subject.contains('PO Number') && (currentRecord.CreatedById==label.API_User_My_Aerospace_Portal || currentRecord.CreatedById == label.myaerospace_webform )) {
   
            EmailTemplate ets=[SELECT Id FROM EmailTemplate where DeveloperName='ADE_Case_Creation1'];
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
     
        semail.setTargetObjectId(currentRecord.contactid);
        semail.setOrgWideEmailAddressId(system.label.AeroNo_Reply_email_ID);
        semail.setWhatId(currentRecord.Id);
        semail.setTemplateID(ets.Id);
        //String[] sendingTocAdd = new String[]{'Arpitha.U@Honeywell.com','Girish.Shevire@Honeywell.com','Sachin.channabasavarajendra@honeywell.com','amala.xavier@honeywell.com'};
        //semail.setCcAddresses(sendingTocAdd);
      
        mails.add(semail);
   
       }
     
   
   if (currentRecord.contactid != null && currentRecord.Type=='AOG' && currentRecord.origin=='Web' && currentRecord.subject.startswith('MyAerospace AOG Order') ) {
   
        EmailTemplate ets=[Select id,Name  from EmailTemplate where Name='AOG Order Acknowledgement (Auto)-Portal'];
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
     
       semail.setTargetObjectId(currentRecord.contactid);
       semail.setOrgWideEmailAddressId(system.label.AOG_OrgWideEmail);
       semail.setWhatId(currentRecord.Id);
     semail.setTemplateID(ets.Id);
     //String[] sendingTocAdd = new String[]{'ramsfdc558@gmail.com'};
       // semail.setCcAddresses(sendingTocAdd);
      
       mails.add(semail);
       
       If(mails.size() >0)
       {
      // Messaging.sendEmail(mails);
       }
       //system.debug('finalll:::'+Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail}));
       
       
       }
       if(!Test.isRunningTest()){
       Messaging.sendEmail(mails);
      // system.debug('mails:::: '+mails.size());
       }
      }
        }
    
    /*
    * Description : When an Case is created for Email-to-case scnerio. This method will update the File Details field on the Case object with the details
    *               of the attachements sent in the email.
    * Created By  : Swathi T
    * Inputs      : caseIds - List of Case Ids for which Dile Details will be updated in the format FileName:FileExtension:FileSize
    *
    */
    @future
    public static void attachmentUpdate(Set<Id> caseIds) {
        
        List<Case> cases= [select id from Case where id IN :caseIds AND status='Open' AND Origin='Email' AND RecordType.Name='Orders'];
        List<Case> updateCases=new List<Case>();
        Map<String,EmailMessage> mapEmailCase=new Map<String,EmailMessage>();
        Map<String,List<ContentDocumentLink>> mapEmailConDocLink=new Map<String,List<ContentDocumentLink>>();
        List<Id> emailMessageID = new List<Id>();
        Map<String,List<Attachment>> mapattachment=new Map<String,List<Attachment>>();
        Map<String,string> mapEmailToaddress=new Map<String,String>();
        
        //Query EmailMessage linked to respective case records       
        for(EmailMessage EM :[select parentid,id,Hasattachment,ToAddress from EmailMessage where parentid IN :caseIds ] ){
            if(mapEmailToaddress.get(EM.parentid)==null){mapEmailToaddress.put(EM.parentid,EM.ToAddress);}
            if(EM.HasAttachment==true){
            mapEmailCase.put(EM.parentid,EM);
            emailMessageID.add(EM.id);
            mapEmailConDocLink.put(EM.id,new List<ContentDocumentLink>());  
            mapattachment.put(EM.id,new List<attachment>());
            }
        }
        Map<String,ContentDocument> mapContentDoc;
       
        if(!emailMessageID.isEmpty()){            
            //Query attachment linked to respective EmailMessage
            for(Attachment attachmentObj :[SELECT id,Name, ContentType,BodyLength,ParentId from attachment where ParentId IN :emailMessageID] ){
                mapattachment.get(attachmentObj.ParentId).add(attachmentObj);
            }
        }
        List<caseComment> commentList=new List<caseComment>();
         for(case caseObj : cases){
           List<string> mailBoxs= Label.CaseManagementMailboxes.split(',');
           if(mailBoxs.contains(mapEmailToaddress.get(caseObj.id))){
           string filetype='';
           //Update file details in Case File_Details fields from ContentDocument in the format - FileName:FileExtension:FileSize
           if(!mapEmailCase.isempty() && mapEmailCase.containskey(caseObj.id) )
           {
                for(attachment attach : mapattachment.get(mapEmailCase.get(caseObj.id).id)){ 
                    filetype = attach.Name.substringBeforeLast('.')+' : '+attach.Name.substringAfterLast('.')+' : '+attach.BodyLength +' ; '+filetype;  
                } 
           }
           else{
                //Update None if no Files attached
                filetype='NONE';   
           }
             caseObj.File_Details__c = filetype;
            updateCases.add(caseObj);
            CaseComment com = new CaseComment();
            com.ParentId = caseObj.id;
            com.CommentBody= 'Case forwarded to Data Analysis';
            com.IsPublished=false;
            commentList.add(com);
             }
        }
        if(!updateCases.isEmpty()){update updateCases;}
        if(!commentList.isEmpty()){insert commentList;}
        
        
    }
}