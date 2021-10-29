/**
  * @author Garvit Totuka
  * @date 11/13/2017 
  *
  * @description - Contains entire case trigger logic for common methods used in Insert and Update. 
  */

public class CaseServiceForCommonMethods {
    static map<id,string> mapCasesupported = new map<id,string>(); 
    static map<id,string> mapCaseIdACTname = new map<id,string>();
    static map<string,list<case>> Mapgroupcase = new map<string,list<case>>();
     //vkt SCTASK1144727
    static map<id,string> mapCasesCustomerSupportFocal = new map<id,string>();
    static List<Messaging.SingleEmailMessage> bulkEmailsAVSAT = new List<Messaging.SingleEmailMessage>();
    static map<id,string> mapEmailTemplateids = new map<id,id>();
    Public static String GDCGroup;
    public static Map<String,GDC_Accounts_Groups__c> mapGDCGroup = new Map<String,GDC_Accounts_Groups__c>();
    Public static list<String> mailToAddresses = new list<String>();
    static Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    static map<id,List<string>> mapCaseDetails = new map<id,List<string>>();
    static map<id,id> mapContactIds = new map<id,id>();        
    static Id templateId;  
    static Id orgWideEmailAddressId =null;
    static Boolean blnSendMail = false;
    static List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>(); 
    static Map<id,Case> lstCas = new Map<id,Case>();
    static string MTOTemplate = label.MTO_Inquiry_Confirmation;
    static String spexTemplate = label.SPEX_Exchange_Warranty_Deferred_On_Line_Order_Notification_Template;
    static String OtherHoldTemplate = label.Other_Hold_Types_Deferred_On_Line_Order_Template;
    static List<Contact> contacts = new List<Contact>();
    public static Boolean isEmailSent; //to stop multiple emails updated for SCTASK2560584
    Static Map<Id,Boolean> mailsend = new Map<Id,Boolean>();//To stop the second email send in the update case on a single transaction
    //******************************************************************************************************************//
    /* Created By : Garvit Totuka   Date : 03 Nov 2017
    ** Trigger : Case_ProvideAccess     Line of Code : 170 - 180
    ** Description : set the values for Resolution and sub class if not null
    ** Trigger Event : Before Insert and Before Update
    ** Parameters : newCase - Trigger.New
    ** Return : void set Is_Resolution_Blank__c or Is_Type_equal_to_SubClass__C field values
    */
    public static void caseResolutionAndSubclass(List<Case> newCase){
        String casetype, subclass;
        for(Case cases :newCase){   
            if(cases.resolution__C == null){
                cases.Is_Resolution_Blank__c = '1';
            }
            else{
                cases.Is_Resolution_Blank__c = '0';
            }
            //field for case subclass
            casetype = cases.type;
            subclass = cases.sub_class__c;            
            if(casetype != subclass){
                cases.Is_Type_equal_to_SubClass__C = '1';
            }
            else{
                cases.Is_Type_equal_to_SubClass__C = '0';
            }
        }
    }
    
    
    /*******Below method added for SCTASK1616257**********/
    
    public static void Sendemail_TCT_TechnicalIssue(Boolean isInsert, Boolean isUpdate, List <Case> newCases, Map<Id,Case> newMap2 , Map<Id,Case> oldMap2){
        String old_resol_tool;
        //List <Cases> Processingcases = new List <Cases> ();
        //List <Cases> Processingcases2 = new List <Cases> ();
        
        System.Debug ('Inside Sendemail_TCT_TechnicalIssue Method');
        Id technicalRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Issue').getRecordTypeId();
        Map<Id,Id> caseToSupportProdEmails = new Map<Id,Id>();
        
        If(isUpdate){
            
            for(Case c : newMap2.Values()){
                System.Debug ('Inside for loop');
                
                if(c.Resolution_Tool__c!= NULL) {
                    
                    old_resol_tool = oldMap2.get(c.id).Resolution_Tool__c;
                    
                    //old one doesn't contain TCT
                    if(old_resol_tool!= NULL){
                        if(!old_resol_tool.contains('TCT')){  
                            if(c.Resolution_Tool__c.contains('TCT')
                               && c.Supported_Products__c != NULL 
                            && c.RecordTypeId == technicalRecType ){
                                   caseToSupportProdEmails.put(c.Id,c.Supported_Products__c);
                                   System.debug('old_resol_tool = '+old_resol_tool);
                               }   
                        }                           
                    }//old resolution tool
                    
                    //Earlier case do not have any resolution tools
                    if(old_resol_tool == NULL){
                        if(c.Resolution_Tool__c.contains('TCT')
                           && c.Supported_Products__c != NULL 
                            && c.RecordTypeId == technicalRecType ){
                               caseToSupportProdEmails.put(c.Id,c.Supported_Products__c);
                               System.debug('old_resol_tool = '+old_resol_tool);
                           }       
                    }
                }   
                
            } //for loop end
        }//isupdate
        
        If(isInsert){
            for(Case c : newCases){
                System.Debug ('Inside case creation - for loop');
                
                if(c.Resolution_Tool__c!= NULL) {
                    
                    if(c.Resolution_Tool__c.contains('TCT')
                       && c.Supported_Products__c != NULL 
                    && c.RecordTypeId == technicalRecType ){
                           caseToSupportProdEmails.put(c.Id,c.Supported_Products__c);
                           System.debug('old_resol_tool = '+old_resol_tool);
                       }
                }   
                
            } //for loop end
            
        }//isInsert
        
        System.Debug ('Before sending Email');
        System.Debug ('caseToSupportProdEmails size: ' +caseToSupportProdEmails.size());
        if(caseToSupportProdEmails.size() > 0){ //added by kayal for 101 soql error
            Map<Id,Case> caseMap = new Map<Id,Case>([Select id,CaseNumber,Owner.Email,contactId FROM Case WHERE ID =:caseToSupportProdEmails.keySet()]);
            Map<Id,Supported_Products__c> supportedProdMap = new Map<Id,Supported_Products__c>([Select id,Technical_Core_Team__c FROM Supported_Products__c WHERE ID =:caseToSupportProdEmails.Values() AND Technical_Core_Team__c!= NULL]);
            
            if(supportedProdMap.size()>0){
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                
                
                for(Case curRec : caseMap.Values()){
                    
                    List<String> toAddress = new List<String>();
                    if(caseToSupportProdEmails.size()>0) {
                        for(String s : supportedProdMap.get(caseToSupportProdEmails.get(curRec.Id)).Technical_Core_Team__c.Split(';')){
                            toAddress.add(s);
                            System.debug('toAddress = '+toAddress);
                        }
                    }
                    List<String> ccAddress = new List<String>();
                    ccAddress.add(curRec.owner.email);
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(curRec.contactId);
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setSaveAsActivity(false);
                    mail.setWhatId(curRec.Id);
                    mail.setTemplateId(label.TCT_Email_template);
                    mail.setOrgWideEmailAddressId(label.Aero_tech_support);
                    System.Debug ('Before setting CC address');
                    mail.setCcAddresses(ccAddress);
                    mail.setToAddresses(toAddress);
                    
                    mails.add(mail);
                }
                System.debug('>>Mails>>'+mails);
                Messaging.sendEmail(mails); 
            }
        }//ended by kayal for 101 soql error
        
    }//method end
    
    /* Created By : Garvit Totuka   Date : 02 Nov 2017
** Trigger : Case_ProvideAccess     Line of Code : 421 - 480
** Description : set the value for Case owner  as Queue on basis of Compliance attributes
** Trigger Event : Before
** Parameters : newCase - Trigger.New
** Return : void set OwnerId field value
*/
    public static void beforeCaseOwnerQueue(List<Case> newCase){
        Id idComplianceQueueCSO = label.Compliance_Queue_CSO; 
        Id idComplianceQueueGTO = label.Compliance_Queue_GTO;
        Id idGeneralComplianceQueue = label.General_Compliance_Queue;
        
        for(Case cases :newCase){ 
            if(( cases.Government_Compliance_SM_M_Content__c == 'Yes' || cases.Export_Compliance_Content_ITAR_EAR__c == 'Yes') 
               && cases.IsMemberOfCompliance__C == false
              ){   
                  if(cases.classification__C != null && cases.classification__c == ConstantsForCaseWFDelegate.CLSFN_CSO_SPARES){                                   
                      cases.OwnerId = idComplianceQueueCSO; 
                  }
                  else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id
                          && cases.classification__c != ConstantsForCaseWFDelegate.CLSFN_GTO_DS_TECH_ISSUE
                         ){       
                             cases.OwnerId = idComplianceQueueGTO; 
                         }
                  else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id 
                          || cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id 
                          || cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id
                         ){     
                             cases.OwnerId = idComplianceQueueCSO;
                         }
                  else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id 
                          || cases.recordtypeid == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id
                         ){    
                             cases.OwnerId = idComplianceQueueCSO; 
                         }
                  else{     
                      
                      cases.OwnerId = idGeneralComplianceQueue;
                  }
              }
        }
    }
    
    /* Created By : Garvit Totuka   Date : 02 Nov 2017
** Trigger : Case_ProvideAccess     Line of Code : 481 - 520
** Description : Throws an error for closed case until assigned to individual owner 
** Trigger Event : Before
** Parameters : newCase - Trigger.New
** Return : void add error of closed cases , OwnerId for re-open cases and individual owner
*/
    public static void beforeIsCaseOwnerQueue(List<Case> newCase){
        Id idQuoteTeam = label.Quotes_TeamId;
        Id idBGLRPubsAccess = label.BGLRPubsAccessGroupId;
        Id aeroDefaultUserId = CaseServiceUtility.getAreoDefaultUser();
        Id myAerospaceWeFormUserId = Label.MyareoFrmUsrid;
        Id ConnexiumPIAPIUserId = Label.Connexium_PI_API_User;
        for(Case cases :newCase){
            String owner = cases.OwnerId;
            if(owner != null){
                owner = owner.substring(0,3);
            }
            if(owner == '00G'){
                cases.Is_Case_Owner_a_queue__c = true;
                if((((cases.status == 'Done'  || cases.status == 'Tech Issue-SR Assigned' || cases.status == 'Approved' 
                      || cases.status == 'Completed' || cases.status == 'Closed/Collected' || cases.status == 'Closed with Credit' 
                      || cases.status == 'Partially Accepted' || cases.status == 'Denied' || cases.status == 'Closed')  
                     || (cases.status == 'Cancelled' && cases.service_level__c != 'Unauthorized Dist/Brkr' && cases.Case_Record_Type__c != 'NavDB')) 
                    && (cases.OwnerId != idBGLRPubsAccess && cases.Type != 'WEB Portal Registration') 
                    && ((cases.subject != 'ARINC Update') && (cases.subject != 'HONEYWELL FLIGHT TRACKING REQUESTS') && (cases.subject != 'OCD Updates 620')
                        && (cases.subject != 'OCD Updates 623') && (cases.subject != 'PDC Update') && (cases.subject != 'Sat Updates')
                        && (cases.subject != 'SITA JetBlue Updates') && (cases.subject != 'SITA Updates') && (cases.subject != 'VHF Updates')) ) 
                   && !(cases.Reopen_Case__c) 
                   && !(cases.ownerid == idQuoteTeam) 
                   && (UserInfo.getUserId() != aeroDefaultUserId)
                   && (UserInfo.getprofileId() != ConnexiumPIAPIUserId) 
                  ){
                      cases.addError('This case cannot be closed until it is assigned to an individual owner.');
                      cases.ownerid__c = null;  
                  }                 
            }
            //Update the Case owner to "Quotes team" when the case of type Quotes get Re-Opend  
            else if(cases.Status == 'Re-Open' && cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id 
                    && cases.OwnerId == myAerospaceWeFormUserId 
                   ){
                       Cases.OwnerId = idQuoteTeam; 
                   }
            else{  
                cases.Is_Case_Owner_a_queue__c = false;
                cases.ownerid__c = cases.OwnerId;
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
** Trigger : Case_ProvideAccess     Line of Code : 74 - 82
** Description : Create a task list from Cases
** Trigger Event : Before Update (No calling)
** Parameters : newCase - Trigger.New
** Return : List of Task - Tasks queried tasks belong to case and return them
*/
    public static List<Task> tasksFromCase(List<Case> newCase){
        List<Task> tasks = new List<Task>();
        
        try{                                        
            tasks = [Select Id,IsClosed,whatId from Task where whatId in :newCase and IsClosed = false];
        }
        catch(Exception e){System.debug('Exception occured in Case_provide Access '+e);}
        return tasks;
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
** Trigger : Case_ProvideAccess Line of Code : 724 - 763
** Description : Update the tasks when owner changes
** Trigger Event : After Update (No Calling)
** Parameters : CaseAeroList - List of Case Ids
** Return : void update Task owner
*/
    public static void updateTaskOwner(List<Id> CaseAeroList){
        List<Case> caseTaskList = new List<Case>();
        Id aeroDefaultUserId = CaseServiceUtility.getAreoDefaultUser();
        List<Task> taskList = new List<Task>();
        Id aeruserId;
        caseTaskList = [SELECT ownerId,Id,Classification__c 
                        FROM Case 
                        WHERE Id in :CaseAeroList
                       ];
        
        for(Task ta :[SELECT Id ,ownerId,whatId,ReminderDateTime,IsReminderSet 
                      FROM Task 
                      WHERE whatId in :CaseAeroList and ownerId = :aeroDefaultUserId 
                     ]){              
                         for(Case caTask :caseTaskList){               
                             if(ta.whatId == caTask.Id){                
                                 ta.ownerId = caTask.OwnerId; 
                                 if(caTask.Classification__c == 'CSO Repair/Overhaul' || caTask.Classification__c == 'GTO D&S Technical Issue' 
                                    || caTask.Classification__c == 'GTO Field Service' || caTask.Classification__c == 'GTO Product Support' 
                                    || caTask.Classification__c == 'GTO Tech Operations Center'){             
                                        ta.ReminderDateTime = datetime.now();              
                                        ta.IsReminderSet = True;                
                                    }  
                                 ta.Task_OwnerChanged__c = True; 
                             }
                             tasklist.add(ta);         
                         }           
                     }
        
        try{
            update tasklist;       
        }
        catch(Exception e){
            System.debug('Exception occured in Case_provide Access '+e);
        }
    }
    
    /* Created By : Garvit Totuka   Date : 02 Nov 2017
** Trigger : Case_ProvideAccess     Line of Code : 603 - 634
** Description : Insert or Update Case FSE_Name fields with Account Team Member user
** Trigger Event : After Insert & After Update (Calling)
** Parameters : newCase - Trigger.New ; accidlist - List of Account Ids
** Return : void set FSE_Name_1__c, FSE_Name_2__c, FSE_Name_3__c field values with Account Team Member User Ids
*/
    public static void caseFSENameByAccountTeamMember(List<Case> newCase, List<Id> accidlist){
        //Populating FSE name fields based on Account Team members
        if(accidlist.isEmpty()){
            return;
        }
        integer flg = 0;
        List<AccountTeamMember> lstaccteam = [select id ,userid,TeamMemberRole,accountid 
                                              from AccountTeamMember 
                                              where accountid in : accidlist
                                              and (TeamMemberRole = 'Field Service Engineer (FSE)' or TeamMemberRole = 'Field Service Manager')
                                             ] ;   
        for(Case acccase :newCase) {
            for(AccountTeamMember accteam :lstaccteam) {
                if(acccase.accountid == accteam.accountid){
                    if(acccase.FSE_name_1__c == null && flg == 0){
                        acccase.FSE_Name_1__c = accteam.userid ;
                        flg = 1;
                    }
                    if(acccase.FSE_name_2__c == null && flg == 0){
                        acccase.FSE_Name_2__c = accteam.userid ;
                        flg = 1;
                    }
                    if(acccase.FSE_name_3__c == null && flg == 0){
                        acccase.FSE_Name_3__c = accteam.userid ;
                        flg = 1;
                    }
                }
                flg = 0;
            }
        }
    }
    
    /* Created By : Garvit Totuka   Date : 02 Nov 2017
** Trigger : Case_ProvideAccess     Line of Code : 363 - 376
** Description : Throw an error if Case Owner belong to different country
** Trigger Event : After Update (No Calling)
** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; ownerIds - List of User Ids
** Return : void add error when Owners belong to differnt country
*/
    public static void userCountryVerify(List<Case> newCase, Map<Id, Case> oldMap, List<ID> ownerIds){
        //If there is change in Owner , check for User's Country , throw error if users are from different Country
        Map<id, String> userCountryMap = new Map<id,String>();
        for(User usr :[SELECT Id, Country__c 
                       FROM User 
                       WHERE Id in :ownerIds
                      ]){
                          userCountryMap.put(usr.Id,usr.Country__c);
                      }      
        for(Case cases :newCase){
            if (userCountryMap.containsKey(oldMap.get(cases.Id).OwnerId)){
                if(cases.PreviousUser_Country__c != userCountryMap.get(oldMap.get(cases.Id).OwnerId)
                   && (cases.Government_Compliance_SM_M_Content__c == 'Yes' || cases.Export_Compliance_Content_ITAR_EAR__c == 'Yes')
                  ){
                      cases.addError('The User selected belong to different Country');
                  }
            }
        }
    }
    //Added by Anvesha  UpdateOppProposalCase Method From CaseClassForPublicMethods
    
    public static void UpdateOppProposalCase(List<Case> listObjCaseNew,Map<ID,Case> oldMap){
        set<id> propids= new set<id>();
        list<case> calist=new list<case>();
        list<Opportunity_Proposal__c> proplist=new list<Opportunity_Proposal__c>();
        list<Opportunity_Proposal__c> proplist1=new list<Opportunity_Proposal__c>();
        for (case c:listObjCaseNew)
        {
            if((c.Opportunity_Proposal__c!=null && oldmap==null )|| (oldmap!=null &&
                                                                     oldmap.get(c.id).Opportunity_Proposal__c!= c.Opportunity_Proposal__c)){
                                                                         propids.add(c.Opportunity_Proposal__c);
                                                                         if(oldmap!=null){
                                                                             propids.add(oldmap.get(c.id).Opportunity_Proposal__c);
                                                                         }
                                                                     }
        }
        
        if(propids!=null &&(!propids.isempty()) ){
            proplist =[SELECT Id,(SELECT Id,casenumber FROM Cases__r ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1) FROM Opportunity_Proposal__c where id=:propids];
            for(Opportunity_Proposal__c oppprop : proplist ){
                if(oppprop.Cases__r.size() > 0){
                    for(case cas :oppprop.Cases__r){
                        oppprop.Last_Opened_Case__c = cas.id;
                        proplist1.add(oppprop);
                    }
                }
                else{
                    oppprop.Last_Opened_Case__c = null;
                    proplist1.add(oppprop);
                }
            }
        }
        if(proplist1.size()>0)
            update proplist1;
    }
    // Added by Anvesha  UpdateOppProposalCase Method From CaseClassForPublicMethods
    
    //Added by Shilpa - ACSMSendCaseEmailMethod From CaseClassForPublicMethods
    
    public static void ACSMSendCaseEmailMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap,String strDMLMode){
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> ACSMbulkEmails = new List<Messaging.SingleEmailMessage>(); 
        List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
        String body,Sub;
        
        Id aircraftContySerMgntUserId = CaseServiceUtility.getAircraftConnectivity();
        for(Case acsmcas:listObjCaseNew){
            if(TriggerCheck.ACSMMailsend){
                if(acsmcas.ContactId != null){
                    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    msg.setTargetObjectId(acsmcas.ContactId);
                    msg.setWhatId(acsmcas.id);
                    //msg.setSaveAsActivity(true);                                                     
                    msg.setOrgWideEmailAddressId(label.ACSM_FSS_Tech_Support_ORG_ID);
                    if(('Insert').equals(strDMLMode) 
                        && ((acsmcas.Emailbox_Origin__c == 'Email-FSS Tech Support' && acsmcas.RecordTypeId == RecordTypeServices.getRecordTypeByName('FSS Technical Issue','Case').Id) 
                           || (acsmcas.RecordTypeId == RecordTypeServices.getRecordTypeByName('GDC Accounts','Case').Id 
                               && acsmcas.Origin == 'Web' && acsmcas.CreatedById == aircraftContySerMgntUserId))){
                                   msg.setTemplateId(label.ACSM_Request_Received_Temp_ID);
                                   //templateid = label.ACSM_Request_Received_Temp_ID;
                               }
                    if(('Update').equals(strDMLMode) && acsmcas.RecordTypeId == RecordTypeServices.getRecordTypeByName('FSS Technical Issue','Case').Id ){
                        
                        if(acsmcas.OwnerId!=oldMap.get(acsmcas.id).Ownerid && acsmcas.Status == 'Open'){
                            msg.setTemplateId(label.ACSM_Case_Owner_Assigned_Temp_ID);
                            //templateid = label.ACSM_Case_Owner_Assigned_Temp_ID;
                        }else if(acsmcas.Status == 'Closed' && acsmcas.IsClosed == TRUE && acsmcas.Status!=oldMap.get(acsmcas.id).Status){
                            msg.setTemplateId(label.ACSM_Case_Closed_Temp_ID);
                            //templateid  = label.ACSM_Case_Closed_Temp_ID;
                        }
                    }
                    //system.debug('msg is @@ '+msg);
                    //system.debug('msg list is @@ '+msgList);
                    msgList.add(msg);
                    
                }
                TriggerCheck.ACSMMailsend = false;
            }
        }  
        
        if(msgList.size()>0){
            try{
                //if(!(Test.isRunningTest()) )
                //{    
                Messaging.sendEmail(msgList);
                //}
            }catch(Exception emailexe){
                //system.debug('excep while sending is @@ '+emailexe);
            }
        }
        
    } 
    
    //if(!(Test.isRunningTest()) )
    //{ 
    /*  start
Savepoint sp = Database.setSavepoint();
if(msg.getTemplateId()!= null)
Messaging.sendEmail(msgList);
Database.rollback(sp); 
*/
    // }
    
    /* if(msgList.size()>0){
for(Messaging.SingleEmailMessage email : msgList){
//system.debug('email is @@ '+email);
list<Emailtemplate> et = [select id,Name,subject,body from Emailtemplate where id=:templateid];

if(et.size()>0){

//body = et[0].body.replace('{!Case.CaseNumber}',acsmcas.CaseNumber).replace('{!Case.Contact}',acsmcas.Contact).replace('{!Case.Case_Ref_ID__c}',acsmcas.Case_Ref_ID__c).replace('{!Case.Resolution__c}',acsmcas.Resolution__c);
//sub = et[0].subject.replace('{!Case.CaseNumber}',acsmcas.CaseNumber).replace('{!Case.Case_Ref_ID__c}',acsmcas.Case_Ref_ID__c);



EmailMessage emailToCase = new EmailMessage();
emailToCase.Incoming = false;
emailToCase.Subject = et[0].subject.replace('{!Case.CaseNumber}',acsmcas.CaseNumber).replace('{!Case.Case_Ref_ID__c}',acsmcas.Case_Ref_ID__c);
emailToCase.MessageDate = system.now();
emailToCase.ParentId = acsmcas.Id;
emailToCase.FromAddress = Label.ACSM_FSS_Tech_Support_Email;
emailToCase.FromName = 'Aero FSS Tech Support';
emailToCase.ToAddress = acsmcas.Primary_Email_Address__c;
/*if(body!=null && body.length()>0 ){
if(body.length()<32000)
emailToCase.HtmlBody =  body.substring(0,body.length());
else
emailToCase.HtmlBody =  body.substring(0,32000);
}*/
    /*   emailToCase.HtmlBody = et[0].body.replace('{!Case.CaseNumber}',acsmcas.CaseNumber).replace('{!Case.Case_Ref_ID__c}',acsmcas.Case_Ref_ID__c).replace('{!Case.Resolution__c}',acsmcas.Resolution__c);


listInsertEmailMessage.add(emailToCase);

body = null;
sub = null;

}
}
}
} */
    
    
    /*   Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
emailToSend.setTargetObjectId(email.getTargetObjectId());
emailToSend.setPlainTextBody(email.getPlainTextBody());
emailToSend.setHTMLBody(email.getHTMLBody());
emailToSend.setSubject(email.getSubject());
emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
if(emailToSend.getHTMLBody()!=null)
ACSMbulkEmails.add(emailToSend);
//system.debug('ACSMbulkEmails is @@ '+ACSMbulkEmails);

body = email.getHTMLBody();
sub = email.getSubject(); */
    //system.debug('body is @@ '+body);
    //system.debug('sub is @@ '+sub);
    
    
    
    
    /*  if(ACSMbulkEmails.size()>0){
EmailMessage emailToCase = new EmailMessage();
emailToCase.Incoming = false;
emailToCase.Subject = sub;
emailToCase.MessageDate = system.now();
emailToCase.ParentId = acsmcas.Id;
emailToCase.FromAddress = Label.ACSM_FSS_Tech_Support_Email;
emailToCase.FromName = 'Aero FSS Tech Support';
emailToCase.ToAddress = acsmcas.Primary_Email_Address__c;
if(body!=null && body.length()>0 ){
if(body.length()<32000)
emailToCase.HtmlBody =  body.substring(0,body.length());
else
emailToCase.HtmlBody =  body.substring(0,32000);
}
listInsertEmailMessage.add(emailToCase);
//system.debug('listInsertEmailMessage is @@ '+listInsertEmailMessage);
} */
    
    
    
    
    
    /*   if(listInsertEmailMessage.size()>0){
try{
insert listInsertEmailMessage;
}Catch(DMLException emailex){
//system.debug('excep while insertion is @@ '+emailex);
}
}  */              
    
    /* Created By : Swastika Rajkhowa Date : 03 Nov 2017
** Trigger : Case_UpdatePrimary Line of Code : 57- 448
** Description : Update the Initial values of the case and Assign Case Ownership 
** Trigger Event : before Insert and before Update
*/ 
    //static Profile profile = [Select Name from Profile where Id = :userinfo.getProfileId()];
    static List<Skills2__c>  Skills = new  List<Skills2__c>();
    public static void onBeforeInsertAndUpdateAssignPrimary(Boolean isInsert, Boolean isUpdate, List<Case> newCaseList,Map<ID,Case> newCaseMap,Map<ID,Case> oldCaseMap){   
        //Commented the below line to avoid recusion of query
        //profile = [Select Name from Profile where Id = :userinfo.getProfileId()];
        string profileId = userinfo.getProfileId();
        string customLabel = Label.Data_Loading_Profile;
        //Commented by swastika on 05-Jan-2018 to remove SOQL query <start>
        /*
string profieName = profile.Name;
string customLabel = Label.API_Data_Load_Profile;
*/
        //Commented by swastika on 05-Jan-2018 to remove SOQL query <end>
        Integer arrLength = 0;
        String[] subjectArray,phoneArray;
        List<String> phoneNumbers = new List<String>();
        String subject,phone;
        Map<id, String> phoneMap = new Map<id,String>(); 
        List<Contact> lstContact = new List<Contact>();
        Contact objContact;
        List<Contact> lstSelContacts = new List<Contact>();
        List<Contact> lstSelContacts2 = new List<Contact>();
        List<Id> lstContactFnIds = new List<Id>();        
        List<Contact> lstUpdtContacts = new List<Contact>(); 
        List<Contact> lstUpdtContacts2 = new List<Contact>(); 
        Map<Id,String> mpCaseFunc = new Map<Id,String>();   
        Map<Id,String> mpCaseFunc2 = new Map<Id,String>();
        Id idATR_OEM_Boeing = label.idATR_OEM_Boeing;
        Id idATR_OEM_Airbus = label.idATR_OEM_Airbus;
        //if(profieName != customLabel){  
        if(profileId!=null && profileId!=''){ 
            if(profileId.substring(0,profileId.length()-3) != customLabel){  
                List<String> productArray = new List<String>();
                //Commented the below lines to avoid recusion of query
                //List<Skills2__c>  Skills = new  List<Skills2__c>();
                //List<Case_Matrix__c> casematrixlst = new List<Case_Matrix__c>();
                //casematrixlst = getCaseMatrix(); 
                for(Case cases: newCaseList){                           
                    if(cases.Origin != null){
                        if(isInsert){
                            if((cases.Origin.contains('Email') && cases.Origin != 'Email') ||cases.origin == 'Web-Pilots Corner Avionics')
                            {
                                cases.Emailbox_Origin__c = cases.Origin;                    
                                cases.Mail_Box_Name__c = cases.Origin;
                            }
                        }
                        else if(isUpdate){
                            if(oldCaseMap.get(cases.id).RnOSAPCases__c != cases.RnOSAPCases__c 
                               && ((cases.Origin.contains('Email') && cases.Origin != 'Email') 
                                   ||cases.origin == 'Web-Pilots Corner Avionics'))
                            {
                                cases.Emailbox_Origin__c = cases.Origin;                    
                                cases.Mail_Box_Name__c = cases.Origin;
                            }
                        }         
                        if(isInsert && cases.origin=='Web-Pilots Corner Avionics')
                        {
                            cases.origin= 'Web'; 
                        }                 
                        if(isInsert && (cases.origin == 'Email-Pilots Corner Avionics'))
                        {                    
                            cases.email_id__c = cases.SuppliedEmail;
                        }
                    } 
                    if(isUpdate){                
                        if((cases.origin =='Web' && isUpdate && oldCaseMap.get(cases.id).Ownerid!= cases.Ownerid)
                           && (cases.subject!= null && cases.subject.contains ('ELT Coding')) 
                           && Cases.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id
                           && (newCaseMap.get(cases.id).Ownerid == Label.aero_default_user_id)){
                               if(oldCaseMap.get(cases.id).Ownerid == idATR_OEM_Boeing){
                                   cases.Ownerid = idATR_OEM_Boeing;
                               }
                               else if(oldCaseMap.get(cases.id).Ownerid == idATR_OEM_Airbus ){
                                   cases.Ownerid = idATR_OEM_Airbus ;
                               }
                           }       
                    } 
                    String usrstr = Userinfo.getuserid();
                    if(usrstr != null)
                    {
                        usrstr = usrstr.substring(0,15);
                    }            
                    if(cases.IsWorkflowTriggered__c == true && usrstr != label.Sfdc_Admin ){
                        if(cases.Mail_Box_Name__c!=null){
                            if(cases.Mail_Box_Name__c.contains('Fax')){
                                string[] stg=(cases.Mail_Box_Name__c).split('//',2);
                                cases.Origin=stg[0];
                            }
                        }            
                        for(integer i=0;i<casematrixlst.size();i++)
                        { 
                            if(cases.Origin == casematrixlst[i].Name && cases.Origin_Check__c == false)
                            {
                                if(cases.Origin !='Email-R&O MechComponents' && cases.Origin !='Email-R&O APU'&& cases.Origin !='Email-R&O Engines' 
                                   && !(cases.Origin=='Email-R&O D&S' && cases.Agent_Contact_Flag__c==true)) 
                                {   
                                    if(cases.Origin == 'Email-Spex Order' && cases.createdbyid != label.AERODEFAULTUSER){}
                                    else{
                                        
                                        cases.Classification__c = casematrixlst[i].Classification__c;
                                        if(cases.Origin!='Email-R&O D&S')
                                        {
                                            cases.Detail_Class__c  = casematrixlst[i].DetailClass__c;
                                            cases.Sub_Class__c = casematrixlst[i].SubClass__c;
                                        }
                                    }
                                }
                                String ownerId;
                                if(cases.Origin == 'Email-Spex Order' && cases.createdbyid != label.AERODEFAULTUSER){}
                                else 
                                    if(cases.Origin != 'Email-AeroRepairs'){
                                        ownerId=casematrixlst[i].OwnerId__c;
                                    }
                                if(ownerId != null)
                                {
                                    ownerId = ownerId.substring(0,15);
                                    cases.Ownerid = ownerId;
                                }
                                
                                if(cases.Origin == 'Email-SAP_CustomerMaster' || cases.Origin == 'Email-SFDC_CustomerMaster'){
                                    cases.Origin_Check__c = true;
                                }
                                
                                if(casematrixlst[i].Type__c != null && cases.Origin!='Email-R&O D&S')
                                    cases.Type = casematrixlst[i].Type__c;
                                
                                if(casematrixlst[i]. Government_Compliance_SM_M_Content__c != null)
                                    cases.Government_Compliance_SM_M_Content__c = casematrixlst[i].Government_Compliance_SM_M_Content__c;
                                
                                if(casematrixlst[i]. Export_Compliance_Content_ITAR_EAR__c != null)
                                    cases.Export_Compliance_Content_ITAR_EAR__c = casematrixlst[i].Export_Compliance_Content_ITAR_EAR__c;
                                
                                
                                if(casematrixlst[i].repair_location__c!= null && cases.Origin!='Email-R&O D&S'){
                                    cases.repair_location__c = casematrixlst[i].repair_location__c;
                                }
                            }
                        } 
                        if(cases.Origin != null)
                        {
                            if((cases.Origin.contains('Email') && cases.origin != 'Email'))
                            {
                                if(cases.origin != 'Email-SAP_CustomerMaster' && cases.origin != 'Email-SFDC_CustomerMaster' 
                                   && (!(booleanclass.enableemailorginchanged.contains('Fax')))){
                                       
                                       if(cases.origin == 'Email-Spex Order' && cases.createdbyid!= Label.AERODEFAULTUSER){}                                                                
                                       else{
                                           cases.origin = 'Email';                  
                                       }                            
                                       
                                       if(cases.Export_Compliance_Content_ITAR_EAR__c==null || cases.Export_Compliance_Content_ITAR_EAR__c=='')  
                                       {
                                           cases.Export_Compliance_Content_ITAR_EAR__c  = 'Undetermined';
                                       }
                                       if(cases.Government_Compliance_SM_M_Content__c ==null || cases.Government_Compliance_SM_M_Content__c =='')  
                                       {
                                           cases.Government_Compliance_SM_M_Content__c = 'Undetermined';
                                       }
                                   }
                            }
                        } 
                    }
                    //for Fax - Setting origin to fax
                    if(isUpdate && cases.subject!=null){
                        if(cases.subject.length()>3){
                            if(cases.subject.substring(0,3)=='Fax'){
                                booleanclass.enableemailorginchanged=cases.Origin+'//Fax';
                                cases.Origin='Fax';  
                            }
                        }
                    }
                    
                    // for the cases originating from fax
                    if(isInsert && cases.subject!=null  ){
                        //checking whether the subject contains Fax
                        if(cases.subject.contains('Fax:{')){
                            subject=cases.subject;                   
                            subjectArray=subject.split('}');
                            arrLength=subjectArray[0].length();
                            phone= subjectArray[0].substring(5,arrLength);
                            if(phone !=null){
                                phoneMap.put(cases.Id,phone);
                                phoneNumbers.add(phone);
                            }// end of if
                        }
                    }// end of i
                    if(cases.Supported_Product__c !=null)
                        productArray.add(cases.Supported_Product__c);
                }
                
                //Code for Cases from fax
                if(phoneNumbers.size()>0  ){
                    try{
                        If(contacts.isEmpty()){
                            contacts=[Select Id,fax_web__C from Contact where fax_web__C!=null and  fax_web__C  in:phoneNumbers];
                        }   
                        // if the fax Number Matches to contact record
                        
                        if(Contacts.size()>0){
                            for( Case casesFaxUpdate: newCaseList){
                                //for Fax
                                if(isInsert && casesFaxUpdate.subject.substring(0,3)=='Fax'){
                                    if(phoneMap.containsKey(casesFaxUpdate.id)){
                                        integer contactSize=Contacts.size();
                                        for(integer i=0;i<contactSize;i++){
                                            if(phoneMap.get(casesFaxUpdate.Id)==contacts[i].fax_web__C){
                                                casesFaxUpdate.ContactId=contacts[i].Id;
                                            }// end of if
                                        }// end of for
                                    }
                                }  // end of if
                            }  // end of for
                        }//end of if
                    }// end of try
                    catch(Exception e)
                    {
                        System.debug('Exception occured '+e);
                    }
                }
                
                integer flag=0;
                if(productArray.size()>0){
                    if(Skills.Isempty()){
                        skills=[Select Contact_Name__c,Contact_Email__C,Supported_Product__c,Primary_Secondary__c from Skills2__c 
                                where  (Primary_Secondary__c='Primary' ) and Supported_Product__c in:productArray order by Primary_Secondary__c]; 
                    }
                    for(Case cases: newCaseList){
                        flag=0;
                        if(cases.Supported_Product__c !=null){
                            for(integer i=0;i<skills.size();i++){
                                if(skills[i].Supported_Product__c==cases.Supported_Product__c){
                                    cases.primary__c=skills[i].Contact_Name__c;
                                    cases.primary_email__c=skills[i].Contact_Email__C;
                                    flag=1;
                                }
                                
                            }
                            if (flag==0){
                                cases.primary__c=null;
                                cases.primary_email__c=null;
                            }
                        }
                    }  
                }
                
                for(Case cases:newCaseList){
                    string leftpad ='';
                    if (cases.sales_order_number__c != null && cases.sales_order_number__c.length()<10){
                        for(integer i = cases.sales_order_number__c.length(); i < 10; i++){
                            leftpad += '0';
                        }
                        cases.sales_order_number__c = leftpad +cases.sales_order_number__c;
                    }
                    
                }
            }
        } 
    }       
    static List<Case_Matrix__c> casematrixlst= [SELECT RecordTypeId__c,repair_location__c,Name,Classification__c,DetailClass__c,Owner__c,OwnerId__c,
                                                Record_Type__c,SubClass__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Type__c 
                                                FROM Case_Matrix__c 
                                                WHERE Email_Public_Group__c = ''
                                               ];
    /*private static List<Case_Matrix__c> getCaseMatrix(){       
List<Case_Matrix__c> casematrixlst = new List<Case_Matrix__c>();
casematrixlst = [SELECT RecordTypeId__c,repair_location__c,Name,Classification__c,DetailClass__c,Owner__c,OwnerId__c,
Record_Type__c,SubClass__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Type__c 
FROM Case_Matrix__c 
WHERE Email_Public_Group__c = ''
];
return casematrixlst;
}*/
    public static void RnOCaseOwnerAssignOnCreationMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap,String strDMLMode) 
    {
        if(TriggerInactive.AvoidRecursionCase==true){
            Boolean bolChangesPresent = false;
            Boolean bolChangesPresent1 = false;
            List<Case_Matrix__c> listCaseMatrix = [select id,Name, OwnerId__c from Case_Matrix__c where Email_Public_Group__c =null];   
            Map<string,id> mapOwnerIds = new Map<string,id>();  
            string origin;
            integer strSize;        
            List<Id> lstConID = new List<Id>();
            List<string> lstProd = new List<String>();
            List<string> lstProd1 = new List<String>();
            List<string> lstProd2 = new List<String>();
            String DSRO = 'D&S R&O';
            for(Case_Matrix__c cmItem:listCaseMatrix){
                mapOwnerIds.put(cmItem.Name,cmItem.OwnerId__c) ;            
            }
            List<id> listAircraft = new List<id>();
            Map<id,Fleet_Asset_Detail__c> mapAircraftName = new Map<id,Fleet_Asset_Detail__c>();
            List<id> listCaseOppDealer = new List<id>();
            Map<id,Opportunity> mapCaseOppDealer = new Map<id,Opportunity>();
            List<id> listCaseContact = new List<id>();
            Map<String,OriginCheckChange__c> mapOriginChange = OriginCheckChange__c.getall();    
            try{
                for(Case objCase:listObjCaseNew){                
                    if(objCase.Aircraft_Name__c!=null)
                        listAircraft.add(objCase.Aircraft_Name__c );            
                    if(objCase.opportunity__c!=null)
                        listCaseOppDealer.add(objCase.opportunity__c);
                    if(objCase.contactid!=null)
                        listCaseContact.add(objCase.contactid);
                    if(objCase.Requested_By_HON_Internal__c!=null )
                        listCaseContact.add(objCase.Requested_By_HON_Internal__c);
                    if(('Insert').equals(strDMLMode)||(('Update').equals(strDMLMode) && oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c))            
                    {
                        String neworigin;
                        bolChangesPresent = true;
                        lstConID.add(objCase.contactid);                
                        if(objCase.origin.length()!= null){
                            if(('Insert').equals(strDMLMode))
                            {
                                strSize=objCase.origin.length();
                            }
                            else
                            {
                                strSize = objCase.Mail_Box_Name__c.length(); 
                            }
                            if(strSize>6)
                            {
                                if(('Insert').equals(strDMLMode))
                                {
                                    neworigin=objCase.origin.substring(6,strSize);
                                }
                                else
                                {
                                    neworigin = objCase.Mail_Box_Name__c.substring(6,strSize);
                                }
                                if(null!=mapOriginChange.get(neworigin))
                                    lstProd.add(mapOriginChange.get(neworigin).CaseOriginName__c);
                                else
                                    lstProd.add(neworigin);
                            }                        
                            lstProd1.add(objCase.origin); 
                        }
                    }
                    if(objCase.R_O_Case_Origin__c!=null)
                        lstProd2.add(objCase.R_O_Case_Origin__c);
                    if(('Insert').equals(strDMLMode)||(('Update').equals(strDMLMode) && oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c 
                                                       && String.valueof(objCase.ownerid).startswith('00G')))
                    {
                        bolChangesPresent1 = true;    
                    }               
                }            
                Map<Id,Contact> mapCaseOrigin = new Map<Id,Contact>([select accountid, Contact_Function__c,id,contact_status__c,
                                                                     (select id,CSR__c,CSR__r.IsActive,CSR__r.Signature1__c,Contact__c,Process__c 
                                                                      from Agent_Contact_Mappings__r 
                                                                      where Agent_Contact_Mapping__c.Contact__c 
                                                                      in:lstConID 
                                                                      and (Agent_Contact_Mapping__c.Process__c in:lstProd 
                                                                           OR Agent_Contact_Mapping__c.Process__c in:lstProd1)) 
                                                                     from contact where id in :listCaseContact]);
                if(listAircraft.size()>0)
                    mapAircraftName = new Map<id,Fleet_Asset_Detail__c>([Select id, Make__c,Model__c,Tail_Number__c,Serial_Number__c,Base_ICAO__c from Fleet_Asset_Detail__c where id in:listAircraft]);
                if(listCaseOppDealer.size()>0)
                    mapCaseOppDealer = new Map<id,Opportunity>([select id,dealer_account__r.name,ownerid,Opportunity_Number__c from opportunity where id in:listCaseOppDealer]);            
                for(case objCase :listObjCaseNew)
                {            
                    ///////////////////// Case_Prevent_Creation  /////////////////////////                             
                    if((('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && (OldMap.get(objCase.Id).Aircraft_Name__c != objCase.Aircraft_Name__c))) && null!=objCase.Aircraft_Name__c  )
                    {
                        if( null!=mapAircraftName.get(objCase.Aircraft_Name__c))
                        { 
                            objCase.Make__c = mapAircraftName.get(objCase.Aircraft_Name__c).Make__c;
                            objCase.Model__c = mapAircraftName.get(objCase.Aircraft_Name__c).Model__c;
                            objCase.Tail__c = mapAircraftName.get(objCase.Aircraft_Name__c).Tail_Number__c;
                            objCase.Serial_Number__c = mapAircraftName.get(objCase.Aircraft_Name__c).Serial_Number__c;
                            objCase.Aircraft_Base_ICAO__c = mapAircraftName.get(objCase.Aircraft_Name__c).Base_ICAO__c;
                        }
                    }
                    if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && (OldMap.get(objCase.Id).Opportunity__c != objCase.Opportunity__c)))
                    {                       
                        if(mapCaseOppDealer.get(objCase.Opportunity__c)!=null && mapCaseOppDealer.get(objCase.Opportunity__c).dealer_account__c!=null)
                        {                            
                            objCase.BGA_Dealer_Name__c = mapCaseOppDealer.get(objCase.Opportunity__c).dealer_account__r.name;
                        }
                        // case_creatingcaselineitem  //
                        if(objCase.Opportunity__c != null){                
                            objCase.Opportunity_Owner__c=mapCaseOppDealer.get(objCase.opportunity__c).ownerid;
                            objCase.Opportunity_Number__c=mapCaseOppDealer.get(objCase.opportunity__c).Opportunity_Number__c;               
                        }
                        if(objCase.Opportunity__c == null){                
                            objCase.Opportunity_Owner__c= null;
                            objCase.Opportunity_Number__c=null;               
                        }
                        // case_creatingcaselineitem //
                    }
                    if(mapCaseOrigin!=null && mapCaseOrigin.get(objCase.Requested_By_HON_Internal__c )!=null)
                        objCase.On_Behalf_of_End_User_Status__c=mapCaseOrigin.get(objCase.Requested_By_HON_Internal__c).contact_status__c;
                    if((objCase.type==null)||(objCase.Time_of_first_Type_Change__c==null))
                    {
                        objCase.Time_of_first_Type_Change__c = System.Now();
                    }
                    else
                    {
                        if(objCase.id!=null && ('Update').equals(strDMLMode))
                        {
                            if(oldmap.get(objCase.Id).Time_of_first_Type_Change__c!=null && objCase.Time_of_first_Type_Change__c!=oldmap.get(objCase.Id).Time_of_first_Type_Change__c)
                            {
                                objCase.Time_of_first_Type_Change__c = oldmap.get(objCase.Id).Time_of_first_Type_Change__c;
                            }
                        }                   
                    } 
                    
                    if((('Insert').equals(strDMLMode) ||( ('Update').equals(strDMLMode) && OldMap.get(objCase.id).Sub_Status__c != objCase.Sub_Status__c))
                       && objCase.Case_Record_Type__c=='Engine Rentals')
                    {
                        DateTime currDate = System.Now();
                        if (objCase.Status== 'On Hold')
                        {
                            if(objCase.Sub_Status__c=='Shipment')
                            {
                                objCase.Shipment_Sub_Status_Selected__c = currDate;
                                objCase.Shipment_Sub_Status_Ended__c = Null;
                            }
                            if(objCase.Sub_Status__c=='Removal')
                            {
                                objCase.Removal_Sub_Status_Selected__c = currDate;
                                objCase.Removal_Sub_Status_Ended__c = Null;
                            }
                            if( objCase.Sub_Status__c=='Other')
                            {
                                objCase.Others_Sub_Status_Selected__c = currDate;
                                objCase.Others_Sub_Status_Ended__c = Null;
                            }
                            if (objCase.Sub_Status__c=='DSO')
                            {
                                objCase.DSO_Sub_Status_Selected__c = currDate;
                                objCase.DSO_Sub_Status_Ended__c = Null;
                            }
                        }
                    }                              
                    if((objCase.status=='Open' || objCase.status=='Re-open') && (('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && (oldmap.get(objCase.Id).status != objCase.status)))) 
                    {
                        objCase.SLA_Flag_Case_age__c = system.now();      
                    }
                    // PortalCaseAutoClose //
                    ///////////////////   Sprint 5&6 Common methods -end   ///////////////////////////
                    if(('Insert').equals(strDMLMode)||(('Update').equals(strDMLMode) && oldMap.get(objCase.id).RnOSAPCases__c != objCase.RnOSAPCases__c))
                    {
                        if(('Insert').equals(strDMLMode))
                        {
                            strSize=objCase.origin.length();
                        }
                        else
                        {
                            strSize = objCase.Mail_Box_Name__c.length(); 
                        }
                        if(strSize > 6)
                            if(('Insert').equals(strDMLMode))
                        {
                            origin=objCase.origin.substring(6,strSize);
                        }
                        else
                        {
                            origin = objCase.Mail_Box_Name__c.substring(6,strSize);
                        }
                        if(mapOriginChange.get(origin)!=null)
                            origin=mapOriginChange.get(origin).CaseOriginName__c;
                        if(strSize > 6)
                        {
                            Contact objCont = mapCaseOrigin.get(objCase.ContactId);
                            if(null!=objcont)
                            {  
                                
                                List<Agent_contact_mapping__C> listACM = objCont.Agent_Contact_Mappings__r;
                                
                                for(Agent_contact_mapping__C objACM : listACM)
                                {   
                                    if(objCase.ContactId==objACM.Contact__c && origin==objACM.Process__c &&
                                       (objCase.RecordTypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id 
                                        || objCase.RecordTypeId == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id 
                                        || objCase.RecordTypeId == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders', 'Case').Id 
                                        || objCase.RecordTypeId == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id 
                                        || objCase.RecordTypeId == RecordTypeServices.getRecordTypeByName('GSS Quotes Orders', 'Case').Id
                                        || objCase.RecordTypeId == RecordTypeServices.getRecordTypeByName('GSS Technical Support', 'Case').Id))
                                    { 
                                        objCase.R_O_Case_Origin__c = origin;
                                        lstProd2.add(objCase.R_O_Case_Origin__c);                                   
                                        if(('Insert').equals(strDMLMode))
                                        {
                                            objCase.Government_Compliance_SM_M_Content__c = 'Undetermined';
                                            objCase.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
                                        }                                    
                                        if(origin == DSRO){
                                            origin = 'R&O D&S';
                                        }
                                        else if(origin=='D&S R&O Internal')
                                        {                                        
                                            objCase.Emailbox_Origin__c = objCase.Origin;
                                            objCase.Origin='Email';
                                            objCase.Classification__c='D&S R&O Internal';
                                        }
                                        else if(origin=='R&O Canada')
                                        {
                                            objCase.Emailbox_Origin__c = objCase.Origin;
                                            objCase.Origin='Email';
                                            objCase.Classification__c='CSO Repair/Overhaul';
                                            objCase.Sub_Class__c='Toronto/PEI';
                                            objCase.Type='Repair Inquiry';
                                        }
                                        else if(origin=='BGA R&O Internal')
                                        {
                                            objCase.Emailbox_Origin__c = objCase.Origin;
                                            objCase.Origin='Email';
                                            objCase.Classification__c='BGA R&O Internal';
                                        }
                                        else if(origin=='ATR R&O Internal')
                                        {
                                            objCase.Emailbox_Origin__c = objCase.Origin;
                                            objCase.Origin='Email';
                                            objCase.Classification__c='ATR R&O Internal';
                                        }         
                                        //GSS INtergation
                                        else if(origin == 'Aero GSE Orders'){                                                                                                            
                                            objCase.Emailbox_Origin__c = objCase.Origin;
                                            objCase.Origin='Email';
                                            objCase.Classification__c='GSE Orders';
                                            if(objACM.CSR__r.IsActive == true)                             
                                                objCase.OwnerId = objACM.CSR__c;
                                            else{
                                                objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                            }
                                        }
                                        else if(origin == 'Aero GSE Quotes'){                             
                                            objCase.Emailbox_Origin__c = objCase.Origin;
                                            objCase.Origin='Email';
                                            objCase.Classification__c='GSE Quotes';                             
                                            if(objACM.CSR__r.IsActive == true)                             
                                                objCase.OwnerId = objACM.CSR__c;
                                            else
                                                objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                        }
                                        else if(origin == 'Aero GSE Support'){                             
                                            objCase.Emailbox_Origin__c = objCase.Origin;
                                            objCase.Origin='Email';
                                            objCase.Classification__c='GSE Technical Support';                              
                                            if(objACM.CSR__r.IsActive == true)                             
                                                objCase.OwnerId = objACM.CSR__c;
                                            else
                                                objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                        }
                                        else if(origin == 'Aero GSE Vendor Support'){                             
                                            objCase.Emailbox_Origin__c = objCase.Origin;
                                            objCase.Origin='Email';
                                            objCase.Classification__c='GSE Vendor Support';                             
                                            if(objACM.CSR__r.IsActive == true)                             
                                                objCase.OwnerId = objACM.CSR__c;
                                            else
                                                objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                        }                                    
                                        if(origin=='D&Sorders' || origin=='D&Squotes' || origin=='R&O D&S' || origin=='ATR R&O Internal' 
                                           || origin=='BGA R&O Internal' || origin=='D&S R&O Internal' || origin=='R&O Canada' || origin=='R&O Engines' 
                                           || origin=='R&O FastShop' || origin=='R&O MechComponents' || origin=='R&O W&B/Greer' || origin=='R&O APU' 
                                           || origin=='R&O Avionics' || origin=='R&O Bournemouth' || origin=='R&O Toulouse' || origin=='R&O Raunheim' 
                                           || origin=='R&O Basingstoke' || origin == 'ATR OEM Airbus' || origin =='ATR OEM Boeing' 
                                           || origin == 'ATR OEM Components' || origin == 'Aero GSE Orders' || origin == 'Aero GSE Quotes' 
                                           || origin == 'Aero GSE Support' || origin == 'Aero GSE Vendor Support')
                                        {                                    
                                            objCase.Agent_Contact_Flag__c = True;
                                            objCase.User_Signature__c = objACM.CSR__r.Signature1__c;
                                        }                            
                                    }
                                }
                            }   
                        }                    
                    }
                if((objCase.Case_Record_Type__c == 'AOG' || objCase.Case_Record_Type__c == 'Exchange'|| objCase.Case_Record_Type__c == 'Orders')
                       && (objCase.Sub_Class__c == 'SPEX/Exchange' || objCase.Detail_Class__c == 'SPEX/Exchange')
                       && (objCase.Sales_Order_Number__c != null) && (objCase.SPEX_Exchange__c != true)){                  
                           objCase.SPEX_Exchange__c = true;
                       }                
                }
            }
            catch(exception e) 
            {
                SYSTEM.DEBUG('Exception '+e);
            }
            if(bolChangesPresent1){   
                Map<Id,Contact> mapROCaseOrigin = new Map<Id,Contact>([select id,
                                                                       (select id,CSR__c,CSR__r.Signature1__c,CSR__r.IsActive,Contact__c,Process__c 
                                                                        from Agent_Contact_Mappings__r 
                                                                        where Agent_Contact_Mapping__c.Contact__c 
                                                                        in:lstConID and Agent_Contact_Mapping__c.Process__c in:lstProd) 
                                                                       from contact where id in :lstConID] ) ;    
                for(Case objCase:listObjCaseNew) 
                {                
                    Contact objcont = mapROCaseOrigin.get(objCase.ContactId);
                    if(objcont!=null)
                    { 
                        List<Agent_contact_mapping__C> newACM = mapROCaseOrigin.get(objCase.ContactId).Agent_Contact_Mappings__r;
                        for(Agent_contact_mapping__C newObject:newACM){
                            if( objCase.R_O_Case_Origin__c == newObject.Process__c && 
                               (objCase.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id
                                || objCase.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id
                                || objCase.recordtypeid == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders', 'Case').Id
                                || objCase.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id
                                || objCase.recordtypeid == RecordTypeServices.getRecordTypeByName('GSS Quotes Orders', 'Case').Id
                                || objCase.recordtypeid == RecordTypeServices.getRecordTypeByName('GSS Technical Support', 'Case').Id
                                || objCase.recordtypeid == RecordTypeServices.getRecordTypeByName('Rotable Core', 'Case').Id))       {  
                                    if(newObject.CSR__r.IsActive == true){                                
                                        objCase.OwnerId = newObject.CSR__c;   
                                    }else{                                
                                        if(mapOwnerIds.size() > 0){
                                            objCase.OwnerId = mapOwnerIds.get(objCase.Emailbox_Origin__c);
                                        }
                                    }
                                }
                        }
                    }                
                }            
            }       
            TriggerInactive.AvoidRecursionCase=false;
        }
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
** Class : AfterUpdateHelperClass Line of Code : 876 -894
** Description : allow users to select only one value for Reason for Hold (INC000011232884)
** Trigger Event : After Update & After Insert
** Parameters : newCase - Trigger.New
** Return : void update related case objects
*/              
    public static void InsertReasonForHold(list<Case> newCase){
        Integer count = 0;
        List<String> values = new List<String>();
        for(Case cas :newCase){
            if(String.isNotBlank(cas.Reason_for_hold__c)){
                values = cas.Reason_for_hold__c.split(';');
                count = values.size();
            } 
            else{
                count = 0;
            }
            if(count > 1){
                cas.addError('Please select only one Reason for Hold. You will be unable to save the case with multiple reasons selected.');
            }
        }
    }
    
    
    /* Created By : Garvit Totuka Date : 27 Nov 2017
** Class : CaseOnHoldPublicMethods    Method : CaseOnHoldMethod
** Description : This method is used for Case Status : On Hold
** Trigger Event : After Insert & After Update
** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap, strDMLMode - Insert or Update mode
** Return : void update the case on Hold log and related fields Sub_Status__c , Reason_For_Hold__c
*/          
    public static void CaseOnHoldMethod(List<Case> listObjCaseNew, Map<ID,Case> oldMap, String strDMLMode){
        Set<Case> listCas = new set<Case>();
        Set<ID> listCas1 = new Set<ID>();
        Set<Case> listCas2 = new Set<Case>();
        list<Case> listcase = new list<Case>();
        list<Case> listcas3 = new list<Case>();
        Set<ID> listcas4 = new Set<ID>();
        list<Case_on_hold_log__c> listonholdlog = new list<Case_on_hold_log__c>();
        list<Case_on_hold_log__c> listonholdlog1 = new list<Case_on_hold_log__c>();
        Set<Case> removeDuplicateIds = new Set<Case>(); // Added to avoid duplicate IDs
        List<Case> ActualList = new List<Case>(); // Added to avoid duplicate IDS
        if(listObjCaseNew != null){
            for(Case c :listObjCaseNew){
                if(('Update').equals(strDMLMode) 
                   && (( null != c.Status && oldMap.get(c.id).Status != c.Status) 
                       || (null != c.Sub_Status__c && oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c))
                  ){
                      TriggerInactive.avoidcaseonholdlog = false;
                  }
                
                if(('Update').equals(strDMLMode) 
                   && !UserInfo.getUserName().contains('Approval Process') 
                   && (c.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id 
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Returns','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('ReturnsPRO','Case').Id
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('R&O-Dod-Need Contract','Case').Id 
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Customer Master Data','Case').Id 
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('GDC Accounts','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('HAPP MPP Contracts','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('MSP Contract','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Tech Pubs','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('GSS Quotes Orders','Case').Id 
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('HUMS DATA SERVICES','Case').Id 
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Engine Rentals','Case').Id 
                       //RAPD - 1823 (below 3 BK recordtypes added)
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('BK Sales Support','Case').Id
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('BK Tech Pubs','Case').Id
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('BK Warranty','Case').Id 
                      )){  
                          if(c.status.contains('Hold') && oldMap.get(c.id).reason_for_hold__c != c.reason_for_hold__c /*(oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c || oldMap.get(c.id).Status != c.Status 
|| oldMap.get(c.id).vn_name__c != c.vn_name__c || oldMap.get(c.id).reason_for_hold__c != c.reason_for_hold__c)*/ 
                             &&  c.vn_name__c != null
                            ){
                                listcas.add(c);
                            }
                          if((c.Sub_Status__c != null && c.sub_status__c.contains('Customer Hold') && !c.sub_status__c.contains('Customer Master Hold') 
                              && c.status.contains('Hold')) && c.vn_name__c == null 
                             && (oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c || oldMap.get(c.id).Status != c.Status || c.vn_name__c != oldMap.get(c.id).vn_name__c )
                            ){
                                listcas2.add(c);
                            }
                          if(!c.status.contains('Hold') &&  oldMap.get(c.id).Status != null && oldMap.get(c.id).Status.contains('Hold') 
                             && (oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c || oldMap.get(c.id).Status != c.Status 
                                 || oldMap.get(c.id).vn_name__c != c.vn_name__c || oldMap.get(c.id).reason_for_hold__c != c.reason_for_hold__c)
                            ){
                                listcas1.add(c.id); 
                            }
                          if((c.status.contains('Hold') && oldMap.get(c.id).Status != c.Status) && 
                             ((oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c && c.Sub_Status__c == 'Rented') || (oldMap.get(c.id).reason_for_hold__c != c.reason_for_hold__c && c.reason_for_hold__c == 'Order Placed')))  {
                                 system.debug('@#$ debug engine rentals update');
                                 listcas.add(c);
                             }
                      }
                
                if(('Insert').equals(strDMLMode) &&  c.status.contains('Hold') 
                   && (c.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id 
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Returns','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('ReturnsPRO','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('R&O-Dod-Need Contract','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Customer Master Data','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('GDC Accounts','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('HAPP MPP Contracts','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('MSP Contract','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Tech Pubs','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('GSS Quotes Orders','Case').Id 
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('HUMS DATA SERVICES','Case').Id 
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Engine Rentals','Case').Id
                       //RAPD - 1823 (below 3 BK recordtypes added)
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('BK Sales Support','Case').Id
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('BK Tech Pubs','Case').Id
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('BK Warranty','Case').Id 
                      )){
                          if(c.vn_name__c != null){
                              listcas.add(c);
                          }
                          if (c.Sub_Status__c != null && c.sub_status__c.contains('Customer Hold') 
                              && !c.sub_status__c.contains('Customer Master Hold') 
                              && c.status.contains('Hold') && c.vn_name__c == null
                             ){
                                 listcas2.add(c);
                             }
                          if(c.status.contains('Hold') && 
                             (c.Sub_Status__c == 'Rented' || c.reason_for_hold__c == 'Order Placed'))  {
                                 system.debug('@#$ debug engine rentals insert');
                                 listcas.add(c);
                             }
                      }
                if(('Update').equals(strDMLMode) && !UserInfo.getUserName().contains('Approval Process') 
                   && (c.recordtypeid == RecordTypeServices.getRecordTypeByName('AOG','Case').Id  
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Exchange','Case').Id
                       || c.recordtypeid == RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id
                      )){
                          System.debug('Sneha++');
                          if((c.status.contains('Propose to Close') || c.status.contains('Open-Rejected')) 
                             && (oldMap.get(c.id).Status!= c.Status)
                            ){
                                listcas3.add(c);
                            }
                          if(c.status.contains('On Hold') 
                             && (oldMap.get(c.id).Status != c.Status || oldMap.get(c.id).Sub_Status__c != c.Sub_Status__c )
                            ){
                                listcas3.add(c);
                                listcas4.add(c.id);
                            }
                          if((!(c.status.contains('Propose to Close')) && oldMap.get(c.id).Status.contains('Propose to Close'))
                             || (!(c.status.contains('Open-Rejected')) && oldMap.get(c.id).Status.contains('Open-Rejected'))
                             || (!(c.status.contains('On Hold')) && oldMap.get(c.id).Status.contains('On Hold'))
                            ){
                                listcas4.add(c.id);
                            }
                      }
            }
        }
        if(listcas.size() > 0){
            list<Case> listcases = [select id,status, Sub_status__c, reason_for_hold__c, vn_name__r.email, contact.email 
                                    from Case 
                                    where id = :listcas]; 
            for(Case c :listcases){
                Case_on_hold_log__c cohl = new Case_on_hold_log__c();
                cohl.Case_Number__c = c.id;
                cohl.Action_Owner__c = c.vn_name__r.email;
                cohl.Hold_Start__c = system.now();
                cohl.Reason__c = c.reason_for_hold__c; 
                cohl.Status__c = c.Status;
                cohl.Sub_status_hidden__c = c.Sub_status__c;
                cohl.Sub_Status__c = c.Sub_Status__c;
                listonholdlog.add(cohl);
            }
        }
        if(listcas3.size() > 0){
            for(case c: listcas3 ){
                Case_on_hold_log__c cohl = new Case_on_hold_log__c();
                cohl.Case_Number__c = c.id;
                cohl.Hold_Start__c = system.now();
                cohl.Status__c = c.Status;
                cohl.Sub_Status__c = c.Sub_Status__c;
                if(c.Reason_for_Hold__c != null){
                    cohl.Reason__c = c.Reason_for_Hold__c;
                }
                if(c.vn_name__c != null){
                    cohl.Action_Owner__c = c.vn_name__r.email;
                }
                listonholdlog.add(cohl);
            }
        }
        if(listcas1.size() > 0 || listcas.size() > 0 || listcas4.size() > 0){
            listonholdlog1 = [select id 
                              from Case_on_hold_log__c 
                              where Hold_Stop__c = null and (case_number__c =: listcas1 or case_number__c =: listcas or case_number__c =: listcas4)];
        }
        if(listonholdlog1.size() > 0){
            for(Case_on_hold_log__c lhl :listonholdlog1){
                Case_on_hold_log__c lhl1 = new Case_on_hold_log__c(id = lhl.id);
                lhl1.Hold_Stop__c = system.now();
                listonholdlog.add(lhl1);
            }
        }
        if(!listonholdlog.isEmpty()){
            try{
                upsert listonholdlog;
            }
            catch(Exception e){
                system.debug('Exception in Case on Hold method '+e);
            }
        }
        if(!listcas1.isEmpty()){
            for(id cid: listcas1){
                Case cas = new Case(id = cid);
                cas.vn_name__c = null;
                cas.reason_for_hold__c = ''; 
                listcase.add(cas);
            }
        }
        if(!listcas2.isEmpty()){
            for(case c: listcas2){
                Case cas = new Case(id = c.id);
                cas.vn_name__c = c.contactid;
                listcase.add(cas);
                
                if(('Update').equals(strDMLMode)){
                    TriggerInactive.avoidcaseonholdlog = true;
                }
                
            } 
        }
        if(!listcase.isEmpty()){
            // Modified code to avoid duplicate ids error
            removeDuplicateIds.addAll(listcase);
            ActualList.addAll(removeDuplicateIds);
            if(!ActualList.isEmpty()){
                try{
                    upsert ActualList;
                }
                catch(Exception e){
                    system.debug('Exception in Case on Hold '+e);
                }
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
** Class : MSPContractsPublicMethods    Method : sendEmailMethod
** Description : This method is used send echo sign document
** Trigger Event : After Update
** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap, strDMLMode - Insert or Update mode
** Return : void send email notification with Adobe echo sign document
*/
    /*method deleted as part of adobe package uninstallation*/
    
    //start of Email Message method from AfterInsertHelperClass
    public static void afterinsertMethod_emailMessaging(Boolean isInsert,List<Case> listObjCaseNew,Map<ID,Case> oldMap){
        
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>(); 
        
        Set<id> acctidset = new Set<ID>();
        Set<id> contidset = new Set<ID>(); 
        Set<id> setList1 = new Set<id>();
        Set<id> setList = new Set<id>();
        Boolean bolChangesPresent = false;
        Schema.DescribeSObjectResult CaseDesc = Schema.SObjectType.Case;
        Map<ID,Schema.RecordTypeInfo> CasertMapByName = CaseDesc.getRecordTypeInfosById();
        Schema.RecordTypeInfo casertName;
        
        for(Case objCs : listObjCaseNew )
        { 
            if(null!=objCs.accountid)
                acctidset.add(objCs.accountid);    
            if(null!=objCs.contactid)
                contidset.add(objCs.contactid);                  
            bolChangesPresent = true;                                
            setList.add(objCs.id);
        }
        Map<ID, Account> accountMapMain = new Map<ID, Account>();
        Map<ID, Contact> contList = new Map<ID, Contact>();
        if(acctidset.size()>0)
            accountMapMain = new Map<ID, Account>([Select id,owner.Email, owner.Name, CBT__c, CBT_Team__c,Strategic_Business_Unit__c,
                                                   (select userid,user.name,user.Email,TeamMemberRole from AccountTeamMembers 
                                                    where (TeamMemberRole='Customer Business Manager (CBM)' 
                                                           or TeamMemberRole='Customer Business Director') ) 
                                                   from Account where id =:acctidset]);       
        if(contidset.size()>0)
            contList = new Map<ID, Contact>([select id,Account.Name,Phone_1__c,Honeywell_ID__c,Email,Address_Line_1__c,
                                             Address_Line_2__c,Address_Line_3__c,City_Name__c,State_Code__c,Name,Country_Name__c 
                                             from contact where id=:contidset]);
        String[] mcoreAdmin=new String[]{};
            List<Contact> superAdmins=[select email from Contact 
                                       where id in (select CRM_Contact_ID__c from Contact_Tool_Access__c 
                                                    where (Name='MCORE'  or Name = 'MCORE (Maintenance Cost Reduction)') 
                                                    and MCORE_IS_Super_Admin__c=true)];
        for(Contact conts : superAdmins)
        {
            mcoreAdmin.add(conts.email);
        }
        Account acctTemp = new Account();
        Contact contTemp = new Contact();
        List<AccountTeamMember> accTeam = new List<AccountTeamMember>();    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
        String strOwnerName ='';
        //EmailTemplate templateIdMCORE = [Select id from EmailTemplate where name = 'Registration Case Assignment'];
        List<String> atrToAddresses=new List<String>();
        for(Case objCase : listObjCaseNew ){               
            casertName = CasertMapByName.get(objCase.recordtypeid);                            
            acctTemp = accountMapMain.get(objCase.accountid);
            contTemp = contList.get(objCase.contactid);
            if(isInsert){      
                if(objCase !=null && casertName.getName().equals(ConstantsForCaseWFDelegate.RT_WEB_PORTAL_REG) 
                   && objCase.Tool_Name__c!=null && objCase.Tool_Name__c!='' && (objCase.Tool_Name__c== ConstantsForCaseWFDelegate.MCORE 
                                                                                 || objCase.Tool_Name__c==ConstantsForCaseWFDelegate.MCORE_MAINTENANCE_COST_REDUCTION )&& objCase.status=='Open' )
                {                       
                    List<String> accOwners=new List<String>();    
                    List<String> ccAddresses=new List<String>();
                    if(null != acctTemp){
                        if(acctTemp.owner.Name == ConstantsForCaseWFDelegate.OWNER_NM_SALECUSTMAST  
                           && acctTemp.Strategic_Business_Unit__c == ConstantsForCaseWFDelegate.STR_BUSIN_UNT_ATR  
                           && acctTemp.CBT__c == ConstantsForCaseWFDelegate.CBT_AIRLINES )
                        {
                            if(acctTemp.CBT_Team__c == ConstantsForCaseWFDelegate.CBT_TEAM_AMERICAS ){
                                accOwners.add('rocky.advani@honeywell.com');
                            }else if(acctTemp.CBT_Team__c == ConstantsForCaseWFDelegate.CBT_EMEAI_ATR ){
                                accOwners.add('dan.wisniewski@honeywell.com');
                            }else if(acctTemp.CBT_Team__c == ConstantsForCaseWFDelegate.CBT_APAC_ATR ) {
                                accOwners.add('joel.miranda@honeywell.com');
                            }                  
                        }
                        else {
                            accOwners.add(acctTemp.owner.Email);
                        }
                    }
                    if(null != accountMapMain.get(objCase.accountid))
                        accTeam = accountMapMain.get(objCase.accountid).AccountTeamMembers;
                    if(null != contTemp){                            
                        if(contTemp.Email!=null && contTemp.Email.toUpperCase().contains('HONEYWELL.COM')){
                            accOwners.clear();
                            accOwners.addAll(mcoreAdmin);
                        }else{
                            if(accTeam!=null){
                                for(AccountTeamMember atm: accTeam){
                                    ccAddresses.add(atm.user.Email);    
                                }
                            }
                            ccAddresses.addAll(mcoreAdmin);                                   
                        } 
                        mail.setToAddresses(accOwners);
                        mail.setCcAddresses(ccAddresses);                       
                        if(accOwners!=null && accOwners.size()>0){
                            String addr='';
                            if(contTemp.Address_Line_1__c!=null){
                                addr=addr+contTemp.Address_Line_1__c+'<BR/>';
                            }
                            if(contTemp.Address_Line_2__c!=null){
                                addr=addr+contTemp.Address_Line_2__c+'<BR/>';
                            }
                            if(contTemp.Address_Line_3__c!=null){
                                addr=addr+contTemp.Address_Line_3__c+'<BR/>';
                            }
                            if(contTemp.City_Name__c!=null){
                                addr=addr+contTemp.City_Name__c+'<BR/>';
                            }
                            if(contTemp.State_Code__c!=null){
                                addr=addr+contTemp.State_Code__c+'<BR/>';
                            }
                            if(contTemp.Country_Name__c!=null){
                                addr=addr+contTemp.Country_Name__c+'<BR/>';
                            }
                            
                            String serverURL = URL.getSalesforceBaseUrl().toExternalForm();
                            String subject='Request for MCORE Tool Access';
                            String body='<html><body><table>'+
                                '<tr><td colspan="2"> Dear Administrator,   </td></tr>'+
                                '<tr><td colspan="2"> The following SFDC Registration Case has been assigned to you:   </td></tr>'+
                                '<tr><td colspan="2">'+objCase.CaseNumber+'</td></tr>'+ 
                                '<tr><td colspan="2"><U>Below are the details of the request:</U></td></tr>'+
                                '<tr><td><b>Tool Name :</b></td><td>'+objCase.Tool_Name__c+'</td></tr>'+ 
                                '<tr><td><b>Honeywell ID :</b></td><td>'+contTemp.Honeywell_ID__c+'</td></tr>'+ 
                                '<tr><td><b>Contact Name :</b></td><td>'+contTemp.Name+'</td></tr>'+ 
                                '<tr><td><b>Email Address :</b></td><td>'+contTemp.Email+'</td></tr>'+ 
                                '<tr><td><b>Company Name :</b></td><td>'+contTemp.Account.Name+'</td></tr>'+ 
                                '<tr><td><b>Contact Phone Number :</b></td><td>'+contTemp.Phone_1__c+'</td></tr>'+                    
                                '<tr><td valign="top"><b>Contact Address :</b></td><td>'+addr+'</td></tr>'+                    
                                '<tr><td colspan="2">Click on the link to access the case:</td></tr>'+
                                '<tr><td colspan="2">'+serverURL+'/'+objCase.Id+'</td></tr>'+ 
                                '<tr><td colspan="2">Thank You,</td></tr>'+ 
                                '<tr><td colspan="2">Self service registration team</td></tr>';        
                            body=body+'</table></body></html>';                                             
                            //mail.setTemplateID(templateIdMCORE.Id);
                            mail.setSubject(subject);
                            mail.setHtmlBody(body);
                            //mail.setTargetObjectId(contTemp.Id);
                            //mail.setWhatId(objCase.Id);
                            bulkEmails.add(mail);                               
                        }
                    }
                }                          
                if(objCase.Contactid!=null && (objCase.Origin!=null && (objCase.Origin =='Email-Quotes' || objCase.Origin =='Email-Orders' 
                                                                        || objCase.Origin =='Email-Order Changes' || objCase.Origin =='Email-Order Status') && objCase.Origin.contains('Email')) 
                   && objCase.SBU__c=='D&S' && objCase.Service_Level__c=='Refer to Network' && objCase.PFECN__c== '')
                {
                    mail.setTargetObjectId(objCase.contactId);
                    mail.setWhatId(objCase.ID);                        
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    mail.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                    mail.setSaveAsActivity(false); 
                    mail.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                    mail.setTemplateId(label.D_S_Refer_to_Network);
                    bulkEmails.add(mail);
                }    
            }         
        }         
        if(!(Test.isRunningTest()))
        {
            Messaging.reserveSingleEmailCapacity(trigger.size);
            Messaging.sendEmail(bulkEmails);    
        }    
        list<String> nsn,PN,nsnPN =New list<string>();
        list<String> nsnall =New list<string>();
        list<String> pnall =New list<string>();
        list<String> lisnclt=New list<string>();
        list<String> nsn2=New list<string>();
        list<String> pn2=New list<string>();
        Map<String,Id> Mapofcaseid=New Map<String,Id>();
        list<Case_Line_Item__c> insertlistNSN = New list<Case_Line_Item__c>();
        list<Case> cas,casupdate= New list<case>();
        set<Id> casid=New set<Id>();
        for(case cs:listObjCaseNew){
            if(cs.NSN__c!=null&&cs.NSN__c!=''&& cs.Recordtypeid==RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id){
                nsn=(cs.NSN__c).split(';');
            }else{nsn=null;}
            
            if(nsn!=null){
                for(string n:nsn){
                    n=n+'\\\\'+cs.id;
                    nsn2.add(n);
                }
            }
            
            if(cs.Part_Number__c !=null&& cs.Part_Number__c!=''&& cs.Recordtypeid==RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id){
                PN=(cs.Part_Number__c).split(';');
            }else{PN=null;}
            
            if(PN!=null){
                for(string p:PN){
                    p=p+'\\\\'+cs.id;
                    PN2.add(p);
                }
            }
            
            if(nsn2 != null){
                nsnall.addall(nsn2);
                nsnPN.addall(nsn2);
            }
            
            if(PN2!=null){
                Pnall.addall(PN2);
                nsnPN.addall(PN2);
            }
            
            for(String nclt:nsnPN){
                Mapofcaseid.put(nclt,cs.id);
            }
            
            nsnPN.clear();
            nsn2.clear();
            PN2.clear();
            casid.add(cs.id);
        }
        
        if(nsnall!=null)
            for(String nclt:nsnall){
                Case_Line_Item__c clt= new Case_Line_Item__c();
                if(nclt!=''){
                    lisnclt=nclt.split('\\\\',2);
                    clt.NSN__c=lisnclt[0];
                    clt.recordtypeid=RecordTypeServices.getRecordTypeByName('DS Clearing House Proposal','Case_Line_Item__c').Id;
                    clt.Case_Number__c=Mapofcaseid.get(nclt);
                    insertlistNSN.add(clt);
                    lisnclt.clear();
                }
            }
        
        if(PNall!=null)
            for(String nclt:Pnall){
                Case_Line_Item__c clt= new Case_Line_Item__c();
                if(nclt!=''){
                    lisnclt=nclt.split('\\\\',2);
                    clt.Part_Number__c=lisnclt[0];
                    clt.recordtypeid=RecordTypeServices.getRecordTypeByName('DS Clearing House Proposal','Case_Line_Item__c').Id;
                    clt.Case_Number__c=Mapofcaseid.get(nclt);
                    insertlistNSN.add(clt);
                    lisnclt.clear();
                }
            }
        //below methods are comented by Anvesha till the below methods are optimised
        sendCaseEmailMethod(true,listObjCaseNew,oldMap,'Insert');
        CaseServiceForCommonMethods.ACSMSendCaseEmailMethod(listObjCaseNew,oldMap,'Insert');     
        if(bolChangesPresent)
        {                
            
            ROAssignOwnerNewCase.updateCaseOwner(setList);                                
        }
    }
    //End of Email Message method From AfterInsertHelperClass
    
    //SendAOGAlertMethod
    public static Messaging.SingleEmailMessage setEmailMessage(Id targetObjectId,Id whatId,String[] toAddresses, string mailBody, string mailSubject, Id templateId,Id orgWideEmailAddressId){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if(targetObjectId!=null){
            message.setTargetObjectId(targetObjectId);
        }
        if(whatId!=null){
            message.setWhatId(whatId); 
        }                               
        message.setBccSender(false);
        message.setUseSignature(false);
        if(orgWideEmailAddressId!=null){
            message.setOrgWideEmailAddressId(orgWideEmailAddressId);
        }
        else{
            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
        }
        message.setSaveAsActivity(false); 
        if(toAddresses!=null){          
            message.setToAddresses(toAddresses);
        }
        if(mailBody!=null){
            message.setHtmlBody(mailBody);
        }
        if(mailSubject!=null){
            message.setSubject(mailSubject);
        }
        if(templateId!=null){           
            message.setTemplateId(templateId); 
        }   
        return message;
    }     
    
    public static void AOGAlert(map<string,list<case>> Mapgroupcase){
        list<string> MailToAddress=new list<string>();
        List<Messaging.SingleEmailMessage> bulkEmailss = new List<Messaging.SingleEmailMessage>();
        for(string grpname:Mapgroupcase.keyset()){            
            if(grpname=='Airbus')
            {
                List<airbus__C> airbus = airbus__c.getall().values();
                if(airbus !=null && airbus.size()>0)
                {
                    MailToAddress=new list<string>();
                    for(airbus__C a:airbus)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }
                    }
                }
            }
            else if(grpname=='Boeing')
            {
                List<Boeing__C> Boeing = Boeing__c.getall().values();
                if(Boeing !=null && Boeing.size()>0){
                    MailToAddress=new list<string>();
                    for(Boeing__C a:Boeing)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                }
            }
            else if(grpname=='Bombardier ATR')
            {
                List<Bombardier_ATR__C> Bombardier_ATR = Bombardier_ATR__c.getall().values();
                if(Bombardier_ATR !=null && Bombardier_ATR.size()>0)
                {
                    MailToAddress=new list<string>();
                    for(Bombardier_ATR__C a:Bombardier_ATR)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            else if(grpname=='Airlines')
            {
                List<Airlines__C> Airlines = Airlines__c.getall().values();
                if(Airlines !=null && Airlines.size()>0){
                    MailToAddress=new list<string>();
                    for(Airlines__C a:Airlines)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            else if(grpname=='Helicopter')
            {
                List<Helicopters__c> Helicopter = Helicopters__c.getall().values();
                if(Helicopter !=null && Helicopter.size()>0){
                    MailToAddress=new list<string>();
                    for(Helicopters__c a:Helicopter)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }    
            }
            else if(grpname=='Gulfstream')
            {
                List<Gulfstream__C> Gulfstream = Gulfstream__c.getall().values();
                if(Gulfstream !=null && Gulfstream.size()>0){
                    MailToAddress=new list<string>();
                    for(Gulfstream__C a:Gulfstream)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            else if(grpname=='Dassault')
            {
                List<Dassault__C> Dassault = Dassault__c.getall().values();
                if(Dassault !=null && Dassault.size()>0){
                    MailToAddress=new list<string>();
                    for(Dassault__C a:Dassault)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            
            else if(grpname=='Pilatus')
            {
                List<Pilatus__C> Pilatus = Pilatus__c.getall().values();
                if(Pilatus !=null && Pilatus.size()>0){
                    MailToAddress=new list<string>();
                    for(Pilatus__C a:Pilatus)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            
            else if(grpname=='BombardierBGA')
            {
                List<BombardierBGA__C> BombardierBGA = BombardierBGA__c.getall().values();
                if(BombardierBGA !=null && BombardierBGA.size()>0){
                    MailToAddress=new list<string>();
                    for(BombardierBGA__C a:BombardierBGA)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            
            else if(grpname=='Hawker')
            {
                List<Hawker__C> Hawker = Hawker__c.getall().values();
                if(Hawker !=null && Hawker.size()>0){
                    MailToAddress=new list<string>();
                    for(Hawker__C a:Hawker)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            else if(grpname=='Cessna')
            {
                List<Cessna__C> Cessna = Cessna__c.getall().values();
                if(Cessna !=null && Cessna.size()>0){
                    MailToAddress=new list<string>();
                    for(Cessna__C a:Cessna)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }                                         
            else if(grpname=='Embraer BGA')
            {
                List<Embraer_BGA__C> Embraer_BGA = Embraer_BGA__c.getall().values();
                if(Embraer_BGA !=null && Embraer_BGA.size()>0){
                    MailToAddress=new list<string>();
                    for(Embraer_BGA__C a:Embraer_BGA)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            else if(grpname=='Embraer ATR')
            {
                List<Embraer_ATR__C> Embraer_ATR = Embraer_ATR__c.getall().values();
                if(Embraer_ATR !=null && Embraer_ATR.size()>0){
                    MailToAddress=new list<string>();
                    for(Embraer_ATR__C a:Embraer_ATR)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            }
            else if(grpname=='Components')
            {
                List<Components__C> Components = Components__c.getall().values();
                if(Components !=null && Components.size()>0){
                    MailToAddress=new list<string>();
                    for(Components__C a:Components)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                    
                }
            } 
            else if(grpname=='Miscellaneous')
            {
                List<miscellaneous__C> miscellaneous = miscellaneous__c.getall().values();
                if(miscellaneous !=null && miscellaneous.size()>0){
                    MailToAddress=new list<string>();
                    for(miscellaneous__C a:miscellaneous)
                    {
                        if(a.name__c!=null)
                        {
                            MailToAddress.add(a.name__c);
                        }            
                    }
                }
            }
            for(case cs:Mapgroupcase.get(grpname))
            {             
                string SubjectLine='';
                string body='  <!DOCTYPE html> <body><table border="0" cellpadding="0" cellspacing="0" width="100%" style="right: 50px;"><tr><td align="center" height="45" valign="top">               <img src="https://c.cs23.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D180000000cAr" alt="Logo" style="border:none;display:block;right: 20px;top: 10px;height: 30px;"/> </td> </tr><br> </table><table border="0" cellpadding="5" cellspacing="0" width="100%" style="right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"> <tr> <td align="right" valign="top"> <table border="0" cellpadding="0" cellspacing="0" width="100%"><tr>               <td align="left" height="60" style="font-family:Verdana;font-size:14px;padding-left: 24px;" valign="middle"><br><br>'
                    +'- GTO Owner Name: ';
                
                String field1 = (cs.OwnerName__c!=null)?cs.OwnerName__c:' ';
                
                body=body+'<n>'+field1+'</n>'+'<br><br>'+
                    '- Customer Support Focal: ';
                String field15 = (mapCasesCustomerSupportFocal.get(cs.id)!=null)?mapCasesCustomerSupportFocal.get(cs.id) :' ';
                
                body=body+'<n>'+field15+'</n>'+'<br><br>'+
                    '- Mechanical/Electrical: ';
                String field2 = (cs.Sub_Class__c !=null)?cs.Sub_Class__c :' ';                
                
                body=body+'<n>'+field2 +'</n>'+'<br><br>'+
                    '- Case Origin: ';
                String field13 = (cs.Origin !=null)?cs.Origin :' ';
                body=body+'<n>'+field13+'</n>'+'<br><br>'+
                    '- Subject: ';
                String field3 = (cs.Subject !=null)?cs.Subject :' ';
                body=body+'<n>'+field3 +'</n>'+'<br><br>'+
                    '- Description: ';
                String fields1 = (cs.Description !=null)?cs.Description :' ';
                
                body=body+'<n>'+fields1 +'</n>'+'<br><br>'+
                    'Additional Webform Info: ' + '</n>' + '<br><br>'+
                    '<font color="red">- Current Actions Provided to Operator: </font>';
                String field4 = (cs.Resolution__c !=null)?cs.Resolution__c.replaceall('\r\n', '<br>'):' ';
                String field41 = (cs.Expected_Update__c!=null)?String.valueOf(cs.Expected_Update__c):' ';
                String fieldCreatedDateInString = (cs.created_date__c != null) ? String.valueOf(cs.created_date__c) : '';
                
                
                body=body+'<n>'+field4+'</n>'+'<br><br>'+
                    '- Date and Time of AOG: ' +'<n>'+ fieldCreatedDateInString  +'</n>'+'<br><br>'+
                    '<font color="red">- Next Update Due: </font>'+'<n>'+field41+'</n>'+'<br><br>'+
                    '- Supported Products: ';
                
                String field5 = (mapCasesupported.get(cs.id)!=null)?mapCasesupported.get(cs.id):' ';
                
                body=body+'<n>'+field5+'</n>'+'<br><br>'+
                    
                    '-Account Name: '+'<n>'+cs.Account_Name__c+'</n>'+'<br><br>'+
                    '-End Operator: '+'<n>'+cs.Account_Name__c+'</n>'+'<br><br>'+
                    '- Location of Airplane: ';
                String field6 = (cs.Aircraft_Location__c !=null)?cs.Aircraft_Location__c:' ';
                
                body=body+'<n>'+field6+'</n>'+'<br><br>'+
                    '- Aircraft Type: ';
                String field7 = (mapCaseIdACTname.get(cs.id)!=null)?mapCaseIdACTname.get(cs.id):' ';
                
                body=body+'<n>'+field7+'</n>'+'<br><br>'+
                    '- Aircraft Tail Number: ';
                String field8 = (cs.Aircraft_Tail_Number__c !=null)?cs.Aircraft_Tail_Number__c :' ';
                
                body=body+'<n>'+field8+'</n>'+'<br><br>'+
                    
                    '- Aircraft Serial Number: ' ;
                String field9 = (cs.Aircraft_Serial_Number__c !=null)?cs.Aircraft_Serial_Number__c :' ';
                
                body=body+'<n>'+field9+'</n>'+'<br><br>'+
                    '- Customer Contact Name: ' ;
                String field10 = (cs.Contact_Name__c !=null)?cs.Contact_Name__c :' ';
                
                body=body+'<n>'+field10+'</n>'+'<br><br>'+
                    
                    '- Customer Contact #: ';
                String field11 = (cs.Primary_Work_Number__c !=null)?cs.Primary_Work_Number__c :' ';
                
                body=body+'<n>'+field11;
                String field12 = (cs.Primary_Cell_Number__c !=null)?cs.Primary_Cell_Number__c :' '; 
                
                body=body+field12+'</n>'+'<br><br>'+
                    '- Engine/APU Reported Serial Number: ';
                String field14 = (cs.Engine_APU_Reported_Serial_Number__c !=null)?cs.Engine_APU_Reported_Serial_Number__c :' ';
                
                body=body+'<n>'+field14+               
                    '</n>'+'<br><br>'+'If you wish to be removed from this distribution'+
                    ' or to have another person added to the distribution, ';
                String encodeddlname = EncodingUtil.urlEncode(MailToAddress.get(0), 'UTF-8');
                body=body+'<a href="'+system.label.AOGDLRemoval_URL+encodeddlname+'">click here.</a>'+
                    ' <br><br></td></tr></table></td></tr></table><br><br></body></html>'; 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(MailToAddress);
                mail.sethtmlbody(body);
                
                SubjectLine='AOG Alert - '+' '+field7+' '+cs.Region__c+' '+cs.CaseNumber+'  '+cs.Case_Ref_ID__c+'';
                if(cs.Detail_Class__c==null|| ( cs.Detail_Class__c!='AOG - IFSD Commanded' && cs.Detail_Class__c!='AOG - IFSD Uncommanded'))
                    SubjectLine=SubjectLine+'  ';
                
                if(cs.Detail_Class__c!=null && cs.Detail_Class__c=='AOG - IFSD Commanded')
                    SubjectLine=SubjectLine+' '+'AOG - IFSD Commanded';
                
                if(cs.Detail_Class__c!=null && cs.Detail_Class__c=='AOG - IFSD Uncommanded')
                    SubjectLine=SubjectLine+' '+'AOG - IFSD Uncommanded';
                
                mail.setsubject(SubjectLine);
                mail.setOrgWideEmailAddressId(label.Aero_tech_support);
                
                //below 2 lines added for SCTASK2498433
                mail.setWhatId(cs.Id); 
                mail.setSaveAsActivity(true); 
                
                bulkEmailss.add(mail);
                isEmailSent = false;
            }
        } 
        
        
        if(bulkEmailss!= null && bulkEmailss.size()>0)
            Messaging.sendEmail(bulkEmailss);
    }
    
    public static void sendAOGAlertMethod(List<Case> listObjCaseNew,Map<ID,Case> oldMap,String strDMLMode, Map<id,Case> lstCas, String strIsBeforeAfter){
        Id aeroDefaultUserId = CaseServiceUtility.getAreoDefaultUser();
        list<case> Cases =new list<case>();
        
        for(case c: listObjCaseNew )
        {
            if(c.RecordTypeid!=null && (c.RecordTypeid==label.TechnicalIssue_RecordTypeID) && c.aog__c==true)    
            {
                String Uid =userinfo.getuserid();
                if( Uid ==aeroDefaultUserId &&( c.Sub_Class__c ==null || c.Resolution__c ==null || c.aircraft_location__c ==null 
                                               || c.Supported_Products__c == null|| c.aircraft_type__c==null || c.subject ==null 
                                               || c.Aircraft_Serial_Number__c==null || c.Aircraft_tail_Number__c==null || c.Expected_Update__c==null)){
                                                   c.addError('If AOG check box is checked Sub Class, Expected Update, Resolution, Supported Products,Subject, Aircraft Type, Aircraft Location, Aircraft Tail Number, Aircraft Serial Number are mandatory. Please check and fill necessary details');
                                               }
                else if(('Insert').equals(strDMLMode)||('Insert').equals(strDMLMode)
                        || (c.Sub_Class__c !=oldmap.get(c.id).sub_class__c || c.Resolution__c !=oldmap.get(c.id).Resolution__c 
                            || c.aircraft_location__c !=oldmap.get(c.id).aircraft_location__c || c.Supported_Products__c!=oldmap.get(c.id).Supported_Products__c
                            || c.aircraft_type__c !=oldmap.get(c.id).aircraft_type__c || c.subject !=oldmap.get(c.id).subject 
                            || c.Aircraft_Serial_Number__c!=oldmap.get(c.id).Aircraft_Serial_Number__c ||
                            c.Aircraft_tail_Number__c!=oldmap.get(c.id).Aircraft_tail_Number__c || c.Expected_Update__c!=oldmap.get(c.id).Expected_Update__c 
                            || c.aog__c!=oldmap.get(c.id).aog__c)){
                                if(c.Aircraft_Type__c!=null)
                                {
                                    mapCaseIdACTname.put(c.id,lstCas.get(c.id).Aircraft_Type__r.name);                       
                                }
                                if(c.Supported_Products__c!=null)
                                {   
                                    mapCasesupported.put(c.id,lstCas.get(c.id).Supported_Products__r.name);                         
                                }
                                //vkt SCTASK1144727
                                if(c.Customer_Support_Focal__c!=null)
                                {
                                    mapCasesCustomerSupportFocal.put(c.id,lstCas.get(c.id).Customer_Support_Focal__r.name);                         
                                }
                            }
            }
            if(mapCaseIdACTname!=null && mapCaseIdACTname.size()>0 && null!=mapCaseIdACTname.get(c.id))
            { 
                if(mapCaseIdACTname.get(c.id).contains('Airbus'))
                {
                    
                    Cases=new list<case>(); 
                    if(Mapgroupcase.keySet().contains('Airbus'))
                    {
                        Mapgroupcase.get('Airbus').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Airbus',Cases);
                    }
                }
                if( mapCaseIdACTname.get(c.id).contains('Boeing'))
                {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Boeing'))
                    {
                        Mapgroupcase.get('Boeing').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Boeing',cases);
                    }
                }
                if( mapCaseIdACTname.get(c.id).contains('Bombardier') && c.SBU_w2c__c=='ATR') 
                {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Bombardier ATR'))
                    {
                        Mapgroupcase.get('Bombardier ATR').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Bombardier ATR',Cases);
                    }
                }            
                if( mapCaseIdACTname.get(c.id).contains('Airlines'))
                {            
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Airlines'))
                    {
                        Mapgroupcase.get('Airlines').add(c);
                    }else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Airlines',Cases);
                    }
                }
                
                if( mapCaseIdACTname.get(c.id).contains('Helicopter'))
                {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Helicopter'))
                    {
                        Mapgroupcase.get('Helicopter').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Helicopter',Cases);
                    }
                    
                }
                if(mapCaseIdACTname.get(c.id).contains('Gulfstream'))
                {
                    
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Gulfstream'))
                    {
                        Mapgroupcase.get('Gulfstream').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Gulfstream',Cases);
                    }
                }
                
                if( mapCaseIdACTname.get(c.id).contains('Dassault'))
                {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Dassault'))
                    {
                        Mapgroupcase.get('Dassault').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Dassault',Cases);
                    }
                }
                if(mapCaseIdACTname.get(c.id).contains('Pilatus'))
                {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Pilatus'))
                    {
                        Mapgroupcase.get('Pilatus').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Pilatus',Cases);
                    }                
                }
                if(mapCaseIdACTname.get(c.id).contains('Bombardier') && c.SBU_w2c__c=='BGA')
                { 
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('BombardierBGA'))
                    {
                        Mapgroupcase.get('BombardierBGA').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('BombardierBGA',Cases);
                    }
                }
                if( mapCaseIdACTname.get(c.id).contains('Hawker'))
                {
                    if(mapCaseIdACTname.get(c.id).contains('Hawker'))
                    {
                        Cases=new list<case>();
                        if(Mapgroupcase.keySet().contains('Hawker'))
                        {
                            Mapgroupcase.get('Hawker').add(c);
                        }
                        else
                        {
                            Cases.add(c);
                            Mapgroupcase.put('Hawker',Cases);
                        }
                    }
                }
                if (mapCaseIdACTname.get(c.id).contains('Cessna'))
                {
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Cessna'))
                    {
                        Mapgroupcase.get('Cessna').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Cessna',Cases);
                    }
                }
                
                
                if(mapCaseIdACTname.get(c.id).contains('Embraer') && c.SBU_w2c__c=='BGA')
                {
                    if(Mapgroupcase.keySet().contains('Embraer BGA'))
                    {
                        Cases=new list<case>();
                        Mapgroupcase.get('Embraer BGA').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Embraer BGA',Cases);
                    }
                }
                
                if(mapCaseIdACTname.get(c.id).contains('Embraer') && c.SBU_w2c__c=='ATR')
                {  
                    Cases=new list<case>();
                    if(Mapgroupcase.keySet().contains('Embraer ATR'))
                    {
                        Mapgroupcase.get('Embraer ATR').add(c);
                    }
                    else
                    {
                        Cases.add(c);
                        Mapgroupcase.put('Embraer ATR',Cases);
                    }
                }                                       
                
            }
            
            if(mapCasesupported.get(c.id)==null)
                
                if((mapCasesupported!=null && mapCasesupported.size()>0) && (mapCasesupported.get(c.id).contains('TPE331 - Controls')
                                                                             ||mapCasesupported.get(c.id).contains('ATF3 - Controls')||mapCasesupported.get(c.id).contains('CFE738 - Controls')
                                                                             ||mapCasesupported.get(c.id).contains('DEEC')||mapCasesupported.get(c.id).contains('DEEC 731 Digital Electronic Engine Control')
                                                                             ||mapCasesupported.get(c.id).contains('Electronic Fuel Controls')||mapCasesupported.get(c.id).contains('HTF7000 - Controls')
                                                                             ||mapCasesupported.get(c.id).contains('TFE731 - Controls')||mapCasesupported.get(c.id).contains('Air Turbine Starter')
                                                                             ||mapCasesupported.get(c.id).contains('Anti-Ice Valves - ATR')||mapCasesupported.get(c.id).contains('Anti-Ice Valves - BGA')
                                                                             ||mapCasesupported.get(c.id).contains('APU Fuel Controls')||mapCasesupported.get(c.id).contains('CF6-80C2 / 80E1 Fuel Controls')
                                                                             ||mapCasesupported.get(c.id).contains('EEC')||mapCasesupported.get(c.id).contains('ESA')||mapCasesupported.get(c.id).contains('Flap Actuator')
                                                                             ||mapCasesupported.get(c.id).contains('Fuel Contols - RR250')||mapCasesupported.get(c.id).contains('Fuel Controls LTS-101')
                                                                             ||mapCasesupported.get(c.id).contains('Fuel Controls PW')||mapCasesupported.get(c.id).contains('Fuel Controls - PWC PT6 & P108')
                                                                             ||mapCasesupported.get(c.id).contains('Mechanical Fuel Controls')||mapCasesupported.get(c.id).contains('Oil Cooler')
                                                                             ||mapCasesupported.get(c.id).contains('Starter Control Valves')||mapCasesupported.get(c.id).contains('Thrust Reverser Actuation')
                                                                             ||mapCasesupported.get(c.id).contains('Electric Power Generation')||mapCasesupported.get(c.id).contains('Power Distribution/Conversion')
                                                                             ||mapCasesupported.get(c.id).contains('Electronic Fuel Controls')||mapCasesupported.get(c.id).contains('Air Turbine Starters')
                                                                             ||mapCasesupported.get(c.id).contains('ATA 79 Heat Exchanger')||mapCasesupported.get(c.id).contains('ECS Controllers')
                                                                             ||mapCasesupported.get(c.id).contains('Engine Bleed Air - ATA 75')))
            {                         
                Cases=new list<case>();
                if(Mapgroupcase.keySet().contains('Components'))
                {
                    Mapgroupcase.get('Components').add(c);
                }
                else
                {
                    Cases.add(c);
                    Mapgroupcase.put('Components',Cases);
                }
            }
            
            
            Boolean b1 = mapCaseIdACTname!=null;
            Boolean b2 = mapCaseIdACTname.size()>0;
            Boolean b3 = mapCasesupported!=null;
            Boolean b4 = mapCasesupported.size()>0;
            Boolean b5 = Mapgroupcase==null;
            Boolean b6 = Mapgroupcase.size()== 0;
            Boolean b7 = Mapgroupcase.keySet()==null;
            
            if(((mapCaseIdACTname!=null && mapCaseIdACTname.size()>0)||(mapCasesupported!=null && mapCasesupported.size()>0)) && 
               Mapgroupcase.size()==0) 
            {
                
                Cases=new list<case>();
                if(Mapgroupcase.keySet().contains('Miscellaneous'))
                {
                    Mapgroupcase.get('Miscellaneous').add(c);
                }
                else
                {
                    Cases.add(c);
                    Mapgroupcase.put('Miscellaneous',Cases);
                }                
            }
            
            if(Mapgroupcase!=null && Mapgroupcase.size()>0)
            {
                
                if(Test.isRunningTest())
                {
                    isEmailSent = true;
                    
                }
                if(isEmailSent){
                    AOGAlert(Mapgroupcase);   
                    isEmailSent = false; //Update to stop multiple email for SCTASK2560584   
                }
            } 
            
        }
        
        List<Messaging.SingleEmailMessage> FssEmailsList_new = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> FssEmailsList_closed = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> JXAccounts_Msg_List = new List<Messaging.SingleEmailMessage>();//Added for JX Accounts
        
        String FssRecordType = RecordTypeServices.getRecordTypeByName('FSS Activations', 'Case').Id;
        String JxRecordType = RecordTypeServices.getRecordTypeByName('JX Accounts', 'Case').Id;
        string conid=Label.UFR_Cont_Id;//Need to change this id for contact
        string emaiTempId = label.FssNewCaseTemplate;
        string emaiTempId_fssclose = label.FssActivation_Case_Close_Email;
        string emaiTempId_Jxacc  = label.JXAccountsEmailTemplateID;
        for(case caseobj :listobjCaseNew)
        {   String str1=label.FSSActivationNotificationswitch;
         String str2=label.JXAccountsEmailnotificationswitch;
         
         if(Test.isRunningTest()){
             str1='on';
             str2='on';           
         }
         if(('Insert').equals(strDMLMode)  && caseobj.status=='New' &&(caseobj.Emailbox_Origin__c == 'Email-FSSActivations'
                                                                       &&null!=caseobj.Emailbox_Origin__c || caseobj.Origin  == 'Email'&&null!=caseobj.Origin) && caseobj.SuppliedEmail!=null 
            && caseobj.RecordTypeId==FssRecordType && str1=='on')
         {
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
             
             String[] toAddresses = new String[] {caseobj.SuppliedEmail};
                 
                 message= setSingleEmailMessage(conid, caseobj.Id,toAddresses, '', '',  emaiTempId, label.Yourresponse_OrgId);
             FssEmailsList_new.add(message);
             
             
         }
         if(('Insert').equals(strDMLMode)  && caseobj.status=='New' &&(caseobj.Emailbox_Origin__c == 'Email-JXAccounts' 
                                                                       &&null!=caseobj.Emailbox_Origin__c || caseobj.Origin  == 'Email' &&null!=caseobj.Origin) && caseobj.SuppliedEmail!=null 
            && caseobj.RecordTypeId==JxRecordType && str2=='on')
         {
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
             
             String[] toAddresses = new String[] {caseobj.SuppliedEmail};
                 //INC0000498173
                 //message= setSingleEmailMessage(conid, caseobj.Id,toAddresses, '', '',  emaiTempId_Jxacc, label.Yourresponse_OrgId);
                 message= setSingleEmailMessage(conid, caseobj.Id,toAddresses, null, null,  emaiTempId_Jxacc, label.Yourresponse_OrgId);
             assignValues(true, caseobj, emaiTempId_Jxacc);
             JXAccounts_Msg_List.add(message);
             
         }
         
         if(('Update').equals(strDMLMode) && ('After').equals(strIsBeforeAfter) && TriggerCheck.firstIntEscRun 
            && caseobj.IsClosed !=oldmap.get(caseobj.id).IsClosed && caseobj.IsClosed == TRUE && caseobj.status=='done' 
            && caseobj.Origin=='email' && caseobj.SuppliedEmail!=null && caseobj.RecordTypeId==FssRecordType && str1=='on')
         {
             
             
             Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
             
             String[] toAddresses = new String[] {caseobj.SuppliedEmail};
                 message= setSingleEmailMessage(conid, caseobj.Id,toAddresses, '', '',  emaiTempId_fssclose, label.Yourresponse_OrgId);
             
             FssEmailsList_closed.add(message);
         }
        }    
        
        if(FssEmailsList_new.size()>0){
            try
            {
                Messaging.sendEmail(FssEmailsList_new);
            }
            catch(Exception e)
            {}
        }
        
        if(FssEmailsList_closed.size()>0){
            
            try
            {
                Messaging.sendEmail(FssEmailsList_closed);
            }
            catch(Exception e){}
            
            
        }
        if(JXAccounts_Msg_List.size()>0){
            try
            {
                Messaging.sendEmail(JXAccounts_Msg_List);
            }
            catch(Exception e){}
            
        }
    }
    /* Created By : Swastika Rajkhowa Date : 02 Nov 2017
    ** Class : CaseClassForPublicMethods Line of Code : 452 - 461
    ** Description : Bulk Email Send
    ** Trigger Event : After Update
    ** Parameters : IsAfter,Case list,Old map
    ** Return : void send email
    */    
    public static void sendCaseEmailMethod(Boolean isAfter,List<Case> listObjCaseNew,Map<ID,Case> oldMap,String strDMLMode){
        set<id> recordtype = new set<id>();
        Map<id,Set<id>>recordmap = new map<id,set<id>>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();   
        List<Messaging.SingleEmailMessage> lstMessage = new List<Messaging.SingleEmailMessage>();
        list<case> caselist= new list<case>();
        List<Messaging.SingleEmailMessage> bulkEmailsNavDB = new List<Messaging.SingleEmailMessage>();
        list<Case> listCaseids = new list<Case>();
        Case exceptionCase = new Case();
        Boolean checkCond = false;


        try{
            set<id>caseid= new set<id>();
            map<Id,Case_Line_Item__c> caselinemap= new map<Id,Case_Line_Item__c>();
            list<Case_Line_Item__c> caslinelist=new list<Case_Line_Item__c>();
            list<Case_Line_Item__c> cliupdatelist=new list<Case_Line_Item__c>();
            // case creating line item
            list<String> nsn,PN,nsnPN =New list<string>();
            list<String> nsnall =New list<string>();
            list<String> pnall =New list<string>();
            list<String> lisnclt=New list<string>();
            list<String> nsn2=New list<string>();
            list<String> pn2=New list<string>();
            List<id>listToAddresses = new list<id>();
            Map<String,Id> Mapofcaseid=New Map<String,Id>();
            list<Case_Line_Item__c> insertlistNSN = New list<Case_Line_Item__c>();
            set<Id> casid=New set<Id>();
            lstCas = new Map<id,Case>([select  IsClosed,contactid,Contact.firstName,SuppliedEmail,SBU__c,account.Orders_Next_Wave__c,Contact.LastName,Owner.Email, 
                                       Contact.Primary_Email_Address__c ,Supported_Products__c,Aircraft_Type__c,Case_Ref_ID__c,
                                       Aircraft_Type__r.name,SBU_w2c__c,id,ownerid,owner.name,account.Do_Not_Send_to_Portal__c,
                                       account.Service_Level__c,Supported_Products__r.name,Emailbox_Origin__c,account.name,
                                       account.Orders_Next_Wave_Check_Time__c,Customer_Support_Focal__r.Name,
                                       (select Case_Number__c,Accident_Incident__c,Aircraft_Type__c,Effect_on_Operation__c,
                                        Engine_APU_Replaced_S_N__c,Event_Date__c ,Engine_APU_Reported_S_N__c,Engine_Removal__c,
                                        Event_Airport_Text__c,IFSD_ETOPS__c,Maintenance_Action__c,Maintenance_Agreement__c,
                                        Operational_Symptom__c,Product_Models__c,Supported_Products__c,Report_Date__c,Report_Type__c,
                                        Shutdown_Details__c,Field_event_Report_count__c,Field_Event_Report__c from Field_Events__r )
                                       from case where id =: listObjCaseNew]);
            
            if(isAfter){
                sendAOGAlertMethod(listObjCaseNew,oldMap,strDMLMode, lstCas,'After');  
            }           
            for(case c: listObjCaseNew ){
                system.debug('!!!!c.RecordTypeId!!!!'+c.RecordTypeId);
                if(('Insert').equals(strDMLMode) && c.RecordTypeId==RecordTypeServices.getrecordtypebyName('General','Case').Id && c.Type=='CPS BGA Process'){
                    checkCond = true;
                }
            }
            List<User> usrList = new List<User>();
            if(checkCond){
                usrList=[SELECT email, id from User where id in (SELECT UserOrGroupId FROM GroupMember WHERE GroupId=:Label.GroupAeroCpsBgaProcessITeamId)];
            }           
            //case creating line item      
            for(case c: listObjCaseNew ){
                if((('Insert').equals(strDMLMode) && c.Status=='On Hold') || (('Update').equals(strDMLMode) && 
                (c.Status!=oldmap.get(c.id).Status || c.Sub_Status__c!=oldmap.get(c.id).Sub_Status__c ))){
                    caseid.add(c.id);
                    caselist.add(c);
                }
                //case creating item
                if(c.NSN__c!=null&&c.NSN__c!=''&& c.Recordtypeid==RecordTypeServices.getrecordtypebyName('D&S Clearing House Proposal','Case').Id){
                    nsn=(c.NSN__c).split(';');
                }else{nsn=null;}
                if(nsn!=null){
                    for(string n:nsn){
                        n=n+'\\\\'+c.id;
                        nsn2.add(n);
                    }
                }
                if(c.Part_Number__c !=null&& c.Part_Number__c!=''&& c.Recordtypeid==RecordTypeServices.getrecordtypebyName('D&S Clearing House Proposal','Case').Id){
                    PN=(c.Part_Number__c).split(';');
                }else{PN=null;}
                if(PN!=null){
                    for(string p:PN){
                        p=p+'\\\\'+c.id;
                        PN2.add(p);
                    }
                }
                if(nsn2 != null){
                    nsnall.addall(nsn2);
                    nsnPN.addall(nsn2);
                }
                if(PN2!=null){
                    Pnall.addall(PN2);
                    nsnPN.addall(PN2);
                }
                for(String nclt:nsnPN){
                    Mapofcaseid.put(nclt,c.id);
                }
                nsnPN.clear();
                nsn2.clear();
                PN2.clear();
                casid.add(c.id);
                // case creat item               
                if(('Insert').equals(strDMLMode) && c.RecordTypeId==RecordTypeServices.getrecordtypebyName('General','Case').Id && c.Type=='CPS BGA Process'){
                    String userMail='';
                    for(User u : usrList){
                        userMail =u.email;                        
                        try{                            
                            String casMailSubject=c.Subject+' '+c.CaseNumber+' '+c.Case_Ref_ID__c;
                            String casMailBody='<!DOCTYPE html><body><table border="0" cellpadding="0" cellspacing="0" width="950" style="position: absolute;right: 50px;"><tr><td align="center" height="45" valign="top"><img src=https://c.na19.content.force.com/servlet/servlet.ImageServer?id=015300000018fo4&oid=00D30000000dWxY" alt="Logo" style="border:none;display:block;right: 20px;position: absolute;top: 10px;height: 30px;"/></td></tr><br/></table><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td align="right" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:Times New Roman;font-size:16px;padding-left: 24px;" valign="middle">'+c.Contact_Name__c +' <br/> This notice is to inform you that your request for '+ c.Subject + ' has been logged with the Aero BGA CPS Process Team.<br/> '+c.Description  +' <br/>Thank you for submitting your request. We will contact you if we have any questions.<br/><br/>Aero C&PS BGA Team</td></tr></table></td></tr></table><br/><br/><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"/></body></html>';
                            String[] toadd = new String[]{userMail};
                                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                            message=setSingleEmailMessage(null,null,toadd, casMailBody, casMailSubject,null,null);
                            bulkEmails.add(message);
                            TriggerInactive.avoidRecursion=False;
                        }catch(Exception e){
                            System.debug('Exception' + e);
                        }
                    }       
                }                
            } 
            if(nsnall!=null)
                for(String nclt:nsnall){
                    Case_Line_Item__c clt= new Case_Line_Item__c();
                    if(nclt!=''){
                        lisnclt=nclt.split('\\\\',2);
                        clt.NSN__c=lisnclt[0];
                        clt.recordtypeid=RecordTypeServices.getrecordtypebyName('DS Clearing House Proposal','Case_Line_Item__c').Id;
                        clt.Case_Number__c=Mapofcaseid.get(nclt);
                        insertlistNSN.add(clt);
                        lisnclt.clear();
                    }
                }
            if(PNall!=null)
                for(String nclt:Pnall){
                    Case_Line_Item__c clt= new Case_Line_Item__c();
                    if(nclt!=''){
                        lisnclt=nclt.split('\\\\',2);
                        clt.Part_Number__c=lisnclt[0];
                        clt.recordtypeid=RecordTypeServices.getrecordtypebyName('DS Clearing House Proposal','Case_Line_Item__c').Id;
                        clt.Case_Number__c=Mapofcaseid.get(nclt);
                        insertlistNSN.add(clt);
                        lisnclt.clear();
                    }
                }
            if(booleanclass.creatingcaselineitem){
                booleanclass.creatingcaselineitem=false;
                if(insertlistNSN.size()>0)
                    try{
                        insert insertlistNSN;
                    }
                catch(exception e){}
            } 
            for(Case cas:listObjCaseNew){
                listCaseids.add(cas);                 
                String[] emailAddressArr = (label.BGA_Case_Creation_Notification).split(','); 
                boolean check=false; 
                for(String s: emailAddressArr){
                    if(cas.SuppliedEmail!=null){
                        if(cas.SuppliedEmail.contains(s)){
                            check=true;
                            break;
                        }
                    }
                }   
                boolean emailDomain = (cas.SuppliedEmail !=null) && (check)? false : true; 
                String[] emailAddressArr2 = (label.ATR_Customers_to_the_Send_to_Portal).split(','); 
                boolean check1=false; 
                for(String s: emailAddressArr2){
                    if(cas.SuppliedEmail!=null){
                        if(cas.SuppliedEmail.contains(s)){
                            check1=true;
                            break;
                        }
                    }
                }   
                boolean emailDomain1 = (cas.SuppliedEmail !=null) && (check1)? true : false; 
                exceptionCase = cas;
                Boolean excludedemail = False;
                Boolean includedemailbox = False;
                String checkemail = (cas.ContactId != null)? cas.ContactEmail : cas.SuppliedEmail;
                system.debug('Checkemail-->'+checkemail);
                system.debug('Origin'+cas.Origin+cas.Emailbox_Origin__c);
                String incluemailboxorigin = cas.Emailbox_Origin__c;
                List<GCE_CONNECT__mdt> exclemail = [Select Id,Excluded_Email__c from GCE_CONNECT__mdt];
                for(GCE_CONNECT__mdt em : exclemail){
                    if(checkemail != null){
                        if(checkemail == em.Excluded_Email__c)
                            excludedemail = True;
                    }
                }
                List<GCE_CONNECT_INCLUDED_EMAIL__mdt> inclemail = [Select Id,Included_EmailBox_Origin__c from GCE_CONNECT_INCLUDED_EMAIL__mdt];
                for(GCE_CONNECT_INCLUDED_EMAIL__mdt em : inclemail){
                    if(incluemailboxorigin != null){
                        if(incluemailboxorigin == em.Included_EmailBox_Origin__c)
                            includedemailbox = True;
                    }
                }
                system.debug('excludedemail,includedemailbox'+excludedemail+includedemailbox);
                Boolean validEmail1 = ((checkemail !=null) && (checkemail.containsIgnoreCase('@honeywell.com'))) ? true : false;
                if(mailSend.isEmpty()){
                    mailSend.put(cas.Id, False);
                }
                system.debug('mailsend1-->'+mailsend);
                if(('Insert').equals(strDMLMode) && validEmail1 && includedemailbox && !excludedemail){
                    List<String> toAddresses = new List<String>();
                    If(cas.ContactId == null){
                        system.debug('Contact is null');
                        Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(Label.Inquiry_Template_Case_Id, null, cas.Id);
                        toAddresses.add(cas.SuppliedEmail);
                        message.setToAddresses(toAddresses);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        lstMessage.add(message);
                    }
                    else{
                        system.debug('Contact is not null');
                        Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(Label.Inquiry_Template_Case_Id, cas.ContactId, cas.Id);
                        message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                        lstMessage.add(message);
                    }
                    mailsend.put(cas.Id, True);
                    system.debug('mailsend1-->'+mailsend);
                }
                else if(mailsend.get(cas.Id) ==  False){
                    system.debug('mailsend-->'+mailsend);
                    //Create bulkEmailsAVSAT map for avsat autoresponse
                    bulkEmailsAVSAT = CreateBulkEmailsAVSAT(strDMLMode, cas);
                    //Create BulkEmailsNavDB map 
                    bulkEmailsNavDB = CreateBulkEmailsNavDB(strDMLMode,true, cas,oldmap,lstCas);
                    if(cas.ContactId != null)
                    { 
                        boolean validEmail =(cas.Primary_Email_Address__c !=null) && (cas.Primary_Email_Address__c.contains('@honeywell.com') 
                                                                                      || cas.Primary_Email_Address__c.contains('@HONEYWELL.COM')) ? false : true;
                        //Create BulkEmailsNavDB map 
                        bulkEmails = CreateBulkEmails(validEmail, emailDomain,strDMLMode,true, cas,oldmap); 
                        if(('Insert').equals(strDMLMode) && (cas.Origin!=null && cas.Origin.contains('Email')) && cas.Service_Level__c=='Unauthorized Dist/Brkr'
                           && (cas.Origin =='Email-AOG'
                               || cas.Origin =='Email- AerospaceWarranty' || cas.Origin =='Email-bga-orders' 
                               || cas.Origin =='Email-Disputes'|| cas.Origin =='Email-Order Changes' 
             || cas.Origin =='Email-crc-spex' || cas.Origin =='Email-yeovil.spares' )){
                            blnSendMail = true;
                            mapEmailTemplateids.put(cas.id,label.Unauthorizedtemplate);
                            mapContactids.put(cas.id,cas.contactid);         
                            List<string> caseDet = setCaseDetail(cas);
                            mapCaseDetails.put(cas.id,caseDet);
                        }
                        else if(('Insert').equals(strDMLMode) &&
                                (cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('JXSupport','Case').Id || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('AeroebizSupport','Case').Id || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('GSS Technical Support','Case').Id
                                 || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('ERB Management','Case').Id || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('ISS Invoicing','Case').Id 
                                 || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('Orders','Case').Id  
                                 || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('NavDB Prod','Case').Id
                                 || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('NavDB Accts','Case').Id || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('Software Tools (SWT)','Case').Id
                                 || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('Aero Export Holds','Case').Id 
                                 || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('Repair & Overhaul','Case').Id || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id
                                 || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('EMS Orders','Case').Id || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('Quotes','Case').Id
                                 || cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id  || cas.RecordTypeId == RecordTypeServices.getrecordtypebyName('FSS Technical Issue','Case').Id
                    || cas.RecordTypeId == RecordTypeServices.getrecordtypebyName('Warranty','Case').Id || cas.RecordTypeId == RecordTypeServices.getrecordtypebyName('JX Accounts','Case').Id))
                        {    
                            system.debug('@@@enterifcondition');
                            try 
                            {
                                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                                if(cas.Emailbox_Origin__c == 'Email-Aero GSE Orders'){
                                    orgWideEmailAddressId = label.Aerogssorders;   
                                    if(cas.Agent_Contact_Flag__c == false){
                                        templateId = label.Order_Response;
                                    }
                                    else
                                    {
                                        templateId = label.GSS_Response_Template;                            
                                    }                                
                                    assignValues(true, cas, templateId);
                                }  
                                //INC0000498173
                                if(cas.Emailbox_Origin__c == 'Email-JXAccounts'){
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.JXAccountsEmailTemplateID;                                                           
                                    assignValues(true, cas, templateId);
                                }  
    
                                else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Quotes')
                                {
                                    orgWideEmailAddressId= label.Aerogssquotes;
                                    if (cas.Agent_Contact_Flag__c == false){
                                        templateId = label.Order_Status;
                                    }
                                    else{
                                        templateId = label.GSS_Response_Template;                            
                                    }
                                    assignValues(true, cas, templateId);
                                }  
                                else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Support')
                                {
                                    orgWideEmailAddressId = label.Aerogsssupport;                    
                                    if(cas.Agent_Contact_Flag__c == false)
                                    {
                                        templateId = label.Order_Status;
                                    }
                                    else
                                    {
                                        templateId = label.GSS_Response_Template;    
                                    }
                                    assignValues(true, cas, templateId);                        
                                }
                                else if(cas.Emailbox_Origin__c == 'Email-Aero GSE Vendor Support')
                                {
                                    orgWideEmailAddressId = label.aerogsevendorsupport;                    
                                    if(cas.Agent_Contact_Flag__c == false)
                                    {
                                        templateId = label.Order_Status; 
                                    }
                                    else
                                    {
                                        templateId = label.GSS_Response_Template;                            
                                    }
                                    assignValues(true, cas, templateId);                                                            
                                }
                                if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' 
                                   && cas.sbu__c!=null && cas.sbu__c != 'ATR' && cas.sbu__c != 'D&S' && cas.sbu__c != 'BGA' && cas.Region__c != 'Asia/Pacific Rim')
                                {
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.Order_Status_Inquiry;                                                           
                                    assignValues(true, cas, templateId);
                                }
                                else if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr'  && 
                                        (cas.sbu__c == 'D&S' && cas.Service_Level__c != 'Refer to Network') && cas.Region__c != 'Asia/Pacific Rim' && cas.PFECN__c==null)                            
                                {                                             
                                    try{ 
                                        orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                        templateId = label.Order_Status_Inquiry;
                                        assignValues(true, cas, templateId);
                                    } 
                                    catch (Exception exc) {
                                        System.debug('*******************'+exc);
                                    }
                                }
                                
                                else if (cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr'  
                                         && cas.sbu__c == 'BGA' && cas.PFECN__c==null)
                                { 
                                    if (cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                                        || !emailDomain || cas.Region__c=='Asia/Pacific Rim')
                                    {
                                        try{
                                            orgWideEmailAddressId = label.Yourresponse_OrgId;                    
                                            templateId = label.Order_Status_Inquiry;                                                            
                                            assignValues(true, cas, templateId);
                                        }
                                        catch(Exception exc) {
                                            System.debug('*******************'+exc);
                                        }
                                    }
                                    else if(cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' && emailDomain && cas.Region__c!='Asia/Pacific Rim')
                                    {
                                        try{
                                            orgWideEmailAddressId = label.Yourresponse_OrgId;                    
                                            templateId = label.Order_Status_Request; 
                                            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                     
                                            assignValues(true, cas, templateId);
                                        }
                                        catch(Exception exc) {
                                            System.debug('*******************'+exc);
                                        }                           
                                    }
                                } 
                                else if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Region__c=='Asia/Pacific Rim' && cas.SBU__c == 'D&S')
                                {
                                    try{
                                        // The email template ID used for the email                                    
                                        orgWideEmailAddressId = label.Yourresponse_OrgId;
                                        templateId = label.Order_Status_Inquiry;
                                        message = setSingleEmailMessage(cas.ContactId,cas.Id,null, null,null, templateId,orgWideEmailAddressId);
                                        assignValues(true, cas, templateId);
                                    }
                                    catch (Exception exc) {
                                        System.debug('*******************'+exc);
                                    }
                                } 
                                else if(cas.Emailbox_Origin__c == 'Email-EngineRentals')
                                {
                                    orgWideEmailAddressId = label.Yourresponse_OrgId;
                                    templateId = label.Engine_Rental_Inquiry;                                                     
                                    assignValues(null, cas, templateId);
                                }
                                if(cas.Origin=='Email-DS OEM & Spares Internal'){
                                    templateId = label.Internal_Escalations_Case;                                                             
                                    assignValues(null, cas, templateId);
                                }
                                if(cas.Origin=='Email-DS Repairs Internal'){
                                    templateId = label.Internal_Escalations_Case;                                
                                    assignValues(null, cas, templateId);
                                }                            
                                if(cas.Emailbox_Origin__c == 'Email- AerospaceWarranty' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' ){
                                    orgWideEmailAddressId = label.Yourresponse_OrgId;
                                    templateId = label.Case_Creation_Template_ID;
                                    message = setSingleEmailMessage(cas.ContactId,cas.Id,null, null,null, templateId,orgWideEmailAddressId);
                                    bulkEmails.add(message);
                                }                          
                                else if(cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('NavDB Prod','Case').Id)
                                {                        
                                    String[] ccAddresses = new String[] {'AviationServices@Honeywell.com'};
                                        orgWideEmailAddressId = label.Aviation_Service_OrgID;  
                                    message = setSingleEmailMessage(cas.ContactId,cas.Id,null, null,null, templateId,orgWideEmailAddressId);
                                    message.setCcAddresses(ccAddresses);                 
                                    templateId = label.NavDB_Prod_TemplateID;
                                    assignValues(true, cas, templateId);
                                }                           
                                else if(cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('Aero Export Holds','Case').Id)
                                {                        
                                    orgWideEmailAddressId = label.Yourresponse_OrgId;  
                                    templateId = label.Export_Hold_Inquiry;
                                    assignValues(true, cas, templateId);
                                }
                                if(cas.Origin=='Web' && (cas.CreatedById==label.API_User_My_Aerospace_Portal || cas.CreatedById==label.myaerospace_webform) && 
                                (cas.Subject!=Null && cas.Subject.contains('Webform'))){
                                    orgWideEmailAddressId = label.Yourresponse_OrgId;
                                    templateId = label.Portal_Inquiry_Confirmation;
                                    assignValues(true, cas, templateId);
                                }
                                if(cas.Origin=='Web' && (cas.CreatedById==label.API_User_My_Aerospace_Portal || cas.CreatedById==label.myaerospace_webform) && cas.RecordTypeid==label.Repair_Overhaul_RT_ID ){
                                    orgWideEmailAddressId = label.Yourresponse_OrgId;
                                    templateId = label.Case_Creation_Template_ID3; 
                                    assignValues(true, cas, templateId);
                                }
                                else if(cas.RecordtypeId == RecordTypeServices.getrecordtypebyName('OEM Quotes Orders','Case').Id && cas.Emailbox_Origin__c == 'Email-AeroComponents')
                                {                        
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.Inquiry_Confirmation;
                                    assignValues(true, cas, templateId);
                                }
                                if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status')
                                   && cas.Service_Level__c != 'Unauthorized Dist/Brkr' && (cas.sbu__c == 'ATR' || cas.sbu__c == 'BGA' 
                                                                                           || cas.sbu__c == 'D&S')
                                   && !(lstcas.get(cas.id).account.Orders_Next_Wave__c) 
                                   && cas.PFECN__c==null )
                                {
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.ATRNextWaveCustomerPortal;
                                    assignValues(true, cas, templateId);
                                }
                                if(cas.Emailbox_Origin__c!=null && (cas.Emailbox_Origin__c == 'Email-Edinburgh' || cas.Emailbox_Origin__c == 'Email-Garden Grove'|| cas.Emailbox_Origin__c=='Email-Raunheim' ))
                                {
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    if(cas.Emailbox_Origin__c == 'Email-Edinburgh')
                                    {                                
                                        templateId = label.Order_Confirmation_Template_Edinburgh;
                                    }
                                    else if(cas.Emailbox_Origin__c=='Email-Raunheim')
                                    {
                                        templateId = label.Order_Confirmation_For_Raunheim;
                                    }
                                    else if(cas.Emailbox_Origin__c=='Email-Garden Grove')
                                    {
                                        templateId = label.Order_Confirmation_For_GardenGrove;
                                    }
                                    assignValues(true, cas, templateId);                            
                                }                          
                            if(cas.Emailbox_Origin__c == 'Email-Orders' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' && cas.sbu__c == 'ATR' && (cas.Do_Not_Send_to_Portal__c) && !(lstcas.get(cas.id).account.Orders_Next_Wave__c) && cas.PFECN__c==null){
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.Order_Confirmation;
                                    assignValues(true, cas, templateId);
                                }
                                if((cas.Emailbox_Origin__c == 'Email-Orders' )&& cas.Service_Level__c != 'Unauthorized Dist/Brkr' && cas.sbu__c == 'ATR' 
                                   && (!cas.Do_Not_Send_to_Portal__c)
                            && (!lstcas.get(cas.id).account.Orders_Next_Wave__c) && cas.PFECN__c==null){
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = setCaseDetail(cas);
                                    mapCaseDetails.put(cas.id,caseDet);
                                }                             
                                if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' && 
                            cas.sbu__c == 'ATR' && cas.Do_Not_Send_to_Portal__c && cas.PFECN__c==null){
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = setCaseDetail(cas);
                                    mapCaseDetails.put(cas.id,caseDet);
                                }                            
                                if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' &&
                                   cas.sbu__c == 'ATR'
                            &&  (!cas.Do_Not_Send_to_Portal__c)&& cas.PFECN__c==null){
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = setCaseDetail(cas);
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                            if(cas.Emailbox_Origin__c == 'Email-BFESupport'){
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.BFE_Case_Notification;
                                    assignValues(true, cas, templateId);
                                }
                            if(((cas.Emailbox_Origin__c == 'Email-AeroRepairs'|| cas.Emailbox_Origin__c == 'Email-ROCAPS' || cas.Emailbox_Origin__c == 'Email-AeroBizSupport' || cas.Emailbox_Origin__c =='Email-ISSInvoicing' || cas.Emailbox_Origin__c == 'Email-SWT' || cas.Emailbox_Origin__c == 'Email-Bournemouth Repairs' || cas.Emailbox_Origin__c == 'Email-Yeovil Repairs' || cas.Emailbox_Origin__c == 'Email-AeroIDO') && (Null!=cas.SuppliedEmail && (!(cas.SuppliedEmail.contains('@usairways.com'))) && (!(cas.SuppliedEmail.contains('@aa.com'))) ))
                            || (null!=cas.Emailbox_Origin__c && cas.Emailbox_Origin__c == 'Email-olatheservicecenter')){
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.Case_Creation_Template_ID3; 
                                    assignValues(true, cas, templateId);
                                    
                                }                            
                             if(cas.Emailbox_Origin__c == 'Email-NavDB'){
                            orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                templateId = label.Inquiry_Confirmation_We_ve_received_your_Inquiry_honeywell_forge; 
                                assignValues(true, cas, templateId);
                            }                          
                                //code starts for JXSupport
                            if(null!=cas.Emailbox_Origin__c && cas.Emailbox_Origin__c == 'Email-JXSupport' ){
                                    mapEmailTemplateids.put(cas.id,label.JX_Customer_Support_ID1); 
                                } 
                                
                            if(cas.Emailbox_Origin__c == 'Email-EMS-Norcross'){
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.Case_Creation_Template_ID_1;
                                    assignValues(true, cas, templateId);
                                } 
                            if(cas.Emailbox_Origin__c == 'Email-AeroRepairs' && cas.Status=='Rejected' && cas.Reason_for_Cancellation__c == 'Redirected to Portal'){
                                    system.debug('Inside Email-AeroRepairs=====>');
                                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                                    templateId = label.Case_Creation_AeroRepairs_Template_Id;
                                    assignValues(true, cas, templateId);
                                }
                            }
                            catch (Exception e){ 
                                System.debug('Exception occured while sending mail');
                            }
                        } 
                        if(('Insert').equals(strDMLMode) && (cas.Origin!=null && cas.Origin.contains('Email')) && cas.Service_Level__c=='Refer to Network' && cas.sbu__c=='D&S'
                && cas.Origin =='Email-Order Changes' ){
                            mapEmailTemplateids.put(cas.id,label.D_S_Refer_to_Network);
                            mapContactids.put(cas.id,cas.contactid);         
                            List<string> caseDet = setCaseDetail(cas);
                            mapCaseDetails.put(cas.id,caseDet);
                        }
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                        if(('Update').equals(strDMLMode) 
                           && cas.Survey_Sent__c == 1 
                           && oldMap.get(cas.id).Survey_Sent__c != 1
                           && cas.Survey_Type__c == 'Web_Support'
                           && !((cas.Emailbox_Origin__c=='Email-Orders' && cas.SBU__c =='ATR' 
                                 && (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && null!= lstcas.get(cas.id).account.Orders_Next_Wave__c && lstcas.get(cas.id).account.Orders_Next_Wave__c==true)      
                      && (cas.Do_Not_Send_to_Portal__c)))){
                            try{                
                                orgWideEmailAddressId = label.Myaerospace_Org_Id;
                            }
                            catch (Exception e){
                                System.debug('Exception while sending mail for ebiz web survey '+e);
                            }
                        }
                    
                        Id checkOwnerId = Label.Airbus_Queue_Id;
                        if(Test.isRunningTest()){
                            checkOwnerId = UserInfo.getUserId();
                            //cas.Ownerid = checkOwnerId;
                        }                     
                        if(('Update').equals(strDMLMode) && cas.RecordTypeId == RecordTypeServices.getrecordtypebyName('Weather Information Service','Case').Id && cas.Ownerid!= oldMap.get(cas.id).Ownerid && cas.Ownerid == checkOwnerId){
                            templateId = Label.WIS_Email_Temp_Id;
                            mapEmailTemplateids.put(cas.id,templateId);
                            mapContactids.put(cas.id,cas.contactid);
                            List<string> caseDet = setCaseDetail(cas);
                            mapCaseDetails.put(cas.id,caseDet); 
                        }
                        if(('Update').equals(strDMLMode) &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.SBU__c == 'D&S' && (cas.Service_Level__c != 'Refer to Network')  && cas.Origin!= oldMap.get(cas.id).Origin && cas.PFECN__c==null){
                            if(cas.Origin=='Email'){
                                try{
                                    templateId = label.All_Concierge_and_D_S_Owner_Operator_Quotes_Notification_Template_Id;  
                                    mapEmailTemplateids.put(cas.id,templateId);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = setCaseDetail(cas);
                                    mapCaseDetails.put(cas.id,caseDet); 
                                }
                                catch (Exception ep) {
                                    System.debug('RRRRRRRRRRRRR'+ep);
                                }
                            }
                        }
                        else if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-Quotes' && cas.sbu__c == 'BGA' 
                     && cas.PFECN__c==null){
                            if(cas.Service_Level__c != 'Unauthorized Dist/Brkr'){
                                if ((cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                          || !emailDomain || cas.Region__c =='Asia/Pacific Rim') && validEmail && (Null!=cas.SuppliedEmail && !(cas.SuppliedEmail.contains('@linmarr.com')))){
                                    try{
                                        templateId = label.Quote_Request_Confirmation; 
                                        mapEmailTemplateids.put(cas.id,label.ATRNextWaveCustomerPortal);                                   
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = setCaseDetail(cas);
                                        mapCaseDetails.put(cas.id,caseDet);
                                    }
                                    catch(Exception exc) {
                                        System.debug('*******************'+exc);
                                    }
                                }
                                else if((Null!=cas.SuppliedEmail && cas.SuppliedEmail.contains('@linmarr.com'))|| (cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' 
                           && emailDomain && cas.Region__c!='Asia/Pacific Rim' && validEmail)){
                                    try{
                                        templateId = label.Quote_Request; 
                                        mapEmailTemplateids.put(cas.id,templateId);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = setCaseDetail(cas);
                                        mapCaseDetails.put(cas.id,caseDet);
                                    }
                                    catch(Exception exc) {
                                        System.debug('*******************'+exc);
                                    }                           
                                }
                            }  
                        }
                        else if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-Quotes' && cas.sbu__c == 'BGA' 
                    && cas.PFECN__c==null ){
                            try{
                                templateId = label.ATRNextWaveCustomerPortal;
                                mapEmailTemplateids.put(cas.id,label.ATRNextWaveCustomerPortal);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);
                                mapCaseDetails.put(cas.id,caseDet);                                    
                            }
                            catch(Exception exc) {
                                System.debug('*******************'+exc);
                            }
                        }                  
                        if(('Insert').equals(strDMLMode) && null!=cas.Primary_Email_Address__c && cas.Emailbox_Origin__c == 'Email-Order Changes' 
                    && (null!=cas.SBU__c && (cas.SBU__c=='D&S' && cas.Service_Level__c != 'Refer to Network') ) && cas.Service_Level__c!='Unauthorized Dist/Brkr' ){
                            try{
                                templateId = label.Case_Creation_Acknowledgement_D_S_Order_Changes_Temp_Id;
                                mapEmailTemplateids.put(cas.id,label.Case_Creation_Acknowledgement_D_S_Order_Changes_Temp_Id);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);
                                mapCaseDetails.put(cas.id,caseDet);
                            }catch (Exception quotexc) {
                            }
                        }
                if(cas.Service_Level__c != 'Unauthorized Dist/Brkr'){
                            if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c == 'Email-Quotes'&& cas.sbu__c == 'ATR' 
                               && cas.PFECN__c==null){
                                   try{
                                       templateId = label.ATRNextWaveCustomerPortal;
                                       mapEmailTemplateids.put(cas.id,label.ATRNextWaveCustomerPortal);
                                       mapContactids.put(cas.id,cas.contactid);
                                       List<string> caseDet = setCaseDetail(cas);
                                       mapCaseDetails.put(cas.id,caseDet);
                                   }
                                   catch (Exception exc) {
                                       System.debug('*******************'+exc);
                                   }
                               }
                            if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c == 'Email-Quotes'&& cas.sbu__c == 'ATR' && cas.Quotes_Do_Not_Send_to_Portal__c && validEmail && cas.PFECN__c==null){
                                try{
                                    templateId = label.Quote_Request_Confirmation;
                                    mapEmailTemplateids.put(cas.id,label.Quote_Request_Confirmation);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = setCaseDetail(cas);
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                                catch (Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                            }                   
                        }  
                        if(('Insert').equals(strDMLMode)  && (cas.Subject == Null || (cas.Subject!=Null && !(cas.Subject.contains('MTO')))) 
                    && (cas.Origin=='Web') && cas.recordtypeid == RecordTypeServices.getrecordtypebyName('Quotes','Case').Id ){
                            try{
                                templateId = label.Quote_Portal;
                                mapEmailTemplateids.put(cas.id,label.Quote_Portal);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);                            
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            catch (Exception ep) {
                                System.debug('RRRRRRRRRRRRR'+ep);
                            }
                        } 
                        if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-RO EMEAI Internal' ||
                                                             cas.Emailbox_Origin__c=='Email-RO Americas Internal' ||
                                                             cas.Emailbox_Origin__c=='Email-R&O APAC Internal' ||
                                                             cas.Emailbox_Origin__c=='Email-OEM Internal'  ||
                                                             cas.Emailbox_Origin__c=='Email-ACTinternal' ||
                                                             cas.Emailbox_Origin__c=='Email-APACACTinternal' ||
                    cas.Emailbox_Origin__c=='Email-EMEAACTInternal')){
                            try{
                                templateId = label.Internal_Escalations_Case;
                                mapEmailTemplateids.put(cas.id,templateId );
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);
                                mapCaseDetails.put(cas.id,caseDet);
                            }
                            catch (Exception exc) {
                                System.debug('*******************'+exc);
                            }
                        }
                        //Added by Swastika -IBM on 14-Dec-2017 to send email and insert record in email message object<start>
                        //Added by Anvesha
                        //changed for INC0003201720
                    if(('Insert').equals(strDMLMode) && (cas.Mail_Box_Name__c =='Email-AOG')){
                            try{
                                templateId = label.AOG_Case_Confirmation;
                                mapEmailTemplateids.put(cas.id,templateId);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);
                                mapCaseDetails.put(cas.id,caseDet);
                                mail = setSingleEmailMessage(cas.ContactId,cas.Id,null, null, null, templateId,orgWideEmailAddressId);
                                bulkEmails.add(mail);
                            }
                            catch (Exception exc) {
                                System.debug('*******************'+exc);
                            }
                        }
                        //corection in condition made for INC0003274868
                        if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-AEROPRO'  || cas.Emailbox_Origin__c=='Email-AeroBizSupport')){
                            //change for INC0003274868 end
                            try{
                                templateId = label.Inquiry_Confirmation;
                                mapEmailTemplateids.put(cas.id,templateId);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);
                                mapCaseDetails.put(cas.id,caseDet);
                                mail = setSingleEmailMessage(cas.ContactId,cas.Id,null, null, null, templateId,orgWideEmailAddressId);
                                bulkEmails.add(mail);
                            }
                            catch (Exception exc) {
                                System.debug('*******************'+exc);
                            }
                        }
                        //changed for INC0003201720 end
                        if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-AeroRepairs'|| cas.Emailbox_Origin__c=='Email-Aero Export Hold' ||cas.Emailbox_Origin__c == 'Email-ROCAPS' ||
                                                             cas.Emailbox_Origin__c=='Email-Order Changes'||cas.Emailbox_Origin__c=='Email-Aero GSE Orders' ||
                    cas.Emailbox_Origin__c=='Email-EngineRentals' || cas.Emailbox_Origin__c=='Email-Aero GSE Quotes' || cas.Emailbox_Origin__c=='Email-AeroIDO')){
                            try{
                                if ( cas.Emailbox_Origin__c=='Email-Aero Export Hold')
                                {
                                    templateId = label.Export_Hold_Inquiry;
                                }
                                else if ( cas.Emailbox_Origin__c=='Email-EngineRentals')
                                {
                                    templateId = label.ERB_Inquiry_Confirmation;
                                }
                                else if(cas.Emailbox_Origin__c == 'Email-AeroRepairs' && cas.Status=='Rejected' && cas.Reason_for_Cancellation__c == 'Redirected to Portal'){
                                    system.debug('Inside Email-AeroRepairs=====>templateId');
                                    templateId = label.Case_Creation_AeroRepairs_Template_Id;
                                }
                                else
                                {
                                    templateId = label.Inquiry_Confirmation;
                                }
                                mapEmailTemplateids.put(cas.id,templateId);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);
                                mapCaseDetails.put(cas.id,caseDet);
                                mail = setSingleEmailMessage(cas.ContactId,cas.Id,null, null, null, templateId,orgWideEmailAddressId);
                                bulkEmails.add(mail); 
                            }
                            catch (Exception exc) {
                                System.debug('*******************'+exc);
                            }
                        }
                        //Added by Swastika -IBM on 14-Dec-2017 to send email and insert record in email message object<end>
                        if(cas.Subject!=Null){
                            if(cas.Subject.contains('MTO') && cas.Origin=='Web'){
                                if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Subject!=oldMap.get(cas.id).Subject)){
                                    try{
                                        templateId = MTOTemplate;
                                        mapEmailTemplateids.put(cas.id,MTOTemplate);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = setCaseDetail(cas);
                                        mapCaseDetails.put(cas.id,caseDet);
                                    }
                                    catch (Exception e) {}
                                }
                            }
                        }
                        if(cas.Subject!=Null){
                            if(cas.Subject.contains('Webform') && cas.Origin=='Web' && (cas.CreatedById==label.API_User_My_Aerospace_Portal || cas.CreatedById==label.myaerospace_webform) && cas.recordtypeid == RecordTypeServices.getrecordtypebyName('Orders','Case').Id ){
                                if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Subject!=oldMap.get(cas.id).Subject)){
                                    try{
                                        templateId = label.Portal_Inquiry_Confirmation;
                                        mapEmailTemplateids.put(cas.id,label.Portal_Inquiry_Confirmation);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = setCaseDetail(cas);
                                        mapCaseDetails.put(cas.id,caseDet);
                                    }
                                    catch (Exception e) {}
                                }
                            }
                        }
                        
                        if(cas.Sub_Class__c == 'Deferred Online Order' && (cas.Subject == null || (cas.Subject!=Null && !(cas.Subject.contains('SPEX Warranty'))
                                                                                                   && !(cas.Subject.contains('MTO'))&& !(cas.Subject.contains('WebOrder; SPEX; Warranty verification'))))
                           && !(cas.Emailbox_Origin__c=='Email-Orders' && cas.SBU__c =='ATR'   
                                && (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && null!= lstcas.get(cas.id).account.Orders_Next_Wave__c && lstcas.get(cas.id).account.Orders_Next_Wave__c==true)
                    && (cas.Do_Not_Send_to_Portal__c))){
                            if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Sub_Class__c != oldMap.get(cas.id).Sub_Class__c)){
                                try{
                                    templateId = OtherHoldTemplate;
                                    mapEmailTemplateids.put(cas.id,OtherHoldTemplate);
                                    mapContactids.put(cas.id,cas.contactid);
                                    List<string> caseDet = setCaseDetail(cas);
                                    mapCaseDetails.put(cas.id,caseDet);
                                }
                                catch (Exception e) {}
                            }
                        }
                        if(cas.Subject!=Null){
                            if(cas.Subject.contains('WebOrder; SPEX; Warranty verification')){
                                if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Subject!=oldMap.get(cas.id).Subject)){
                                    try{
                                        templateId = spexTemplate;
                                        mapEmailTemplateids.put(cas.id,spexTemplate);
                                        mapContactids.put(cas.id,cas.contactid);
                                        List<string> caseDet = setCaseDetail(cas);
                                        mapCaseDetails.put(cas.id,caseDet);
                                    }
                                    catch (Exception e) {}
                                }
                            }
                        }
                        if(cas.Service_Level__c != 'Unauthorized Dist/Brkr'){
                            if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c == 'Email-Orders' ) && cas.sbu__c != 'ATR' && cas.sbu__c != 'D&S' && cas.sbu__c != 'BGA' && cas.service_level__c != 'Unauthorized Dist/Brkr' && cas.Region__c !='Asia/Pacific Rim' && cas.PFECN__c==null){
                                try{
                                    templateId = label.Order_Confirmation;  
                                }
                                catch (Exception exc) {
                                    System.debug('*******************'+exc);
                                }
                            }
                            else if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders') && cas.sbu__c == 'BGA'
                                    && cas.PFECN__c==null){                   
                                        if ((cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                                             || !emailDomain) || cas.Region__c=='Asia/Pacific Rim' ){
                                                 try{
                                                     templateId = label.Order_Confirmation; 
                                                 }
                                                 catch(Exception exc) {
                                                     System.debug('*******************'+exc);
                                                 }
                                             }
                                        else if(cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' 
                                                && emailDomain && cas.Region__c!='Asia/Pacific Rim'){
                                                    try{
                                                        templateId = label.Order_Request;
                                                    }
                                                    catch(Exception exc) {
                                                        System.debug('*******************'+exc);
                                                    }                           
                                                }
                                    }
                            else if(((('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders') 
                                      && (cas.SBU__c == 'D&S')
                                      && (cas.Service_Level__c != 'Refer to Network') && cas.Primary_Email_Address__c != '' && cas.Region__c != 'Asia/Pacific Rim') 
                                     || (('Insert').equals(strDMLMode)&& (cas.Emailbox_Origin__c=='Email-Orders') && cas.Region__c=='Asia/Pacific Rim' && cas.SBU__c != 'ATR')) && cas.PFECN__c==null){
                                         try{
                                             templateId = label.Order_Confirmation; 
                                         }
                                         catch (Exception exc) {
                                             System.debug('*******************'+exc);
                                         }
                                     }
                            mapEmailTemplateids.put(cas.id,templateId );
                            mapContactids.put(cas.id,cas.contactid);
                            List<string> caseDet = setCaseDetail(cas);
                            mapCaseDetails.put(cas.id,caseDet);      
                        } 
                        if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-R&O MechComponents' && cas.SuppliedEmail!=null ){
                            try{   
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);                    
                                message.setTemplateId(label.Case_Creation_Template_ID); 
                                message = setSingleEmailMessage(cas.ContactId,cas.Id,null, null,null, templateId,orgWideEmailAddressId);   
                                bulkEmails.add(message);
                                mapEmailTemplateids.put(cas.id,label.Case_Creation_Template_ID);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);
                                mapCaseDetails.put(cas.id,caseDet);
                                if(cas.Description!= null)
                                    caseDet.add(cas.Description);
                                else
                                    caseDet.add(' ');
                                mapCaseDetails.put(cas.id,caseDet);  
                                
                            }
                            catch(Exception exc) {
                                System.debug('*******************'+exc);
                            }                       
                        }  
                        Boolean isCaseClosed;
                        if(cas.IsClosed!=null) 
                            isCaseClosed = cas.IsClosed;
                        if(Test.isRunningTest()){
                            isCaseClosed = true;
                        }                                         
                        if(('Update').equals(strDMLMode) && isAfter && TriggerCheck.firstIntEscRun && cas.recordtypeid == RecordTypeServices.getrecordtypebyName('Internal Escalations','Case').Id && isCaseClosed  == true && isCaseClosed  !=oldmap.get(cas.id).IsClosed )
                        {
                            try{
                                orgWideEmailAddressId= label.Yourresponse_OrgId;                   
                                templateId = label.EscalationCaseClosed_Template; 
                                message = setSingleEmailMessage(cas.ContactId,cas.Id,null, null,null, templateId,orgWideEmailAddressId);
                                bulkEmails.add(message);                                  
                                mapEmailTemplateids.put(cas.id,label.EscalationCaseClosed_Template);
                                mapContactids.put(cas.id,cas.contactid);
                                List<string> caseDet = setCaseDetail(cas);                            
                                /*if(cas.Description!= null)
                                    caseDet.add(cas.Description);
                                else
                                    caseDet.add(' ');*/
                                if(cas.Resolution__c!= null)
                                    caseDet.add(cas.Resolution__c);
                                else
                                    caseDet.add(' '); 
                                if(cas.Customer_Name__c!= null)
                                    caseDet.add(cas.Customer_Name__c);
                                else
                                    caseDet.add(' '); 
                                if(cas.Sales_Order_Number__c!= null)
                                    caseDet.add(cas.Sales_Order_Number__c);
                                else
                                    caseDet.add(' ');
                                if(cas.Customer_PO_RO_WONumber__c!= null)
                                    caseDet.add(cas.Customer_PO_RO_WONumber__c);
                                else
                                    caseDet.add(' '); 
                                if(cas.Hon_Plant_Code_del__c!= null)
                                    caseDet.add(cas.Hon_Plant_Code_del__c);
                                else
                                    caseDet.add(' '); 
                                mapCaseDetails.put(cas.id,caseDet);
                                TriggerCheck.firstIntEscRun = false;   
                            }
                            catch(Exception exc) {
                                System.debug('*******************'+exc);
                            }
                        }
                    }
                    // If any new user is Added/Removed to the GDC Accounts * group, the custom setting GDC_Accounts_Groups__c has to be edited with email ids of the user in group.
            if (cas.Recordtypeid==RecordTypeServices.getrecordtypebyName('GDC Accounts','Case').Id){
                        GDCGroup ='';
                        if (('Insert').equals(strDMLMode)|| (('Update').equals(strDMLMode) &&  cas.classification__c!=oldmap.get(cas.id).classification__c && cas.classification__c =='Activation'))
                        {
                            GDCGroup = getGDCGroup(cas.classification__c);
                        }                      
                        mapGDCGroup = new Map<String,GDC_Accounts_Groups__c>(GDC_Accounts_Groups__c.getALL());
                        if (GDCGroup != null && GDCGroup!='' ){
                            if (null != mapGDCGroup && mapGDCGroup.containskey(GDCGroup)==true){
                                String[] emailAddressArr1 = (mapGDCGroup.get(GDCGroup).EmailID__c).split(',');        
                                if(emailAddressArr1.size() > 0){            
                                    for(String i : emailAddressArr1){
                                        mailToAddresses.add(i);
                                    }
                                }   
                            }
                        }                
                        If (mailToAddresses.size()>0)
                        {
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                            String subclass;
                            if (Cas.Sub_Class__c==Null)
                                subclass='';
                            else
                                subclass=Cas.Sub_Class__c; 
                            String strSubject = Cas.CaseNumber +'  '+ Cas.Status + ' ' + Cas.Subject;
                            String bodyText = '<html><head>** New GDC Tech Issue **<br/><br/> </head>' + ' <body> Class : ' + Cas.Classification__c + ' ' +  subclass + '<br/><br/> ' + ' Priority: ' + Cas.Priority + ' <br/><br/>' + ' ---' + '<br/><br/>' + Cas.Description+'</body></Html>';
                            mail = setSingleEmailMessage(null,null,mailToAddresses, bodyText, strSubject, null,null);
                            bulkEmails.add(mail);    
                        }
                    }   
                    String strbaseURL = URL.getSalesforceBaseUrl().toExternalForm();
                    String casUrl = strbaseURL+'/'+cas.id;
                if(cas.RecordTypeId == RecordTypeServices.getrecordtypebyName('ITEC Quotes Orders','Case').Id && (null!=cas.Classification__c && cas.Classification__c == 'ITEC') && ((('Insert').equals(strDMLMode) && cas.Ownerid == Label.ITEC_Orders_Team_Id) || (('Update').equals(strDMLMode) && oldMap.get(cas.id).OwnerId!=cas.OwnerId && cas.OwnerId == Label.ITEC_Orders_Team_Id))){
                        String itecbody = '<!DOCTYPE html><body><table border="0" cellpadding="5" cellspacing="0" width="550" height="400" style="position: absolute;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td><table height="400" width="500" cellpadding="5" border="0" cellspacing="5"><tr><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" locked="0" aEditID="c1r1" ><font face="Arial, sans-serif" size="2">Case '+cas.CaseNumber+' has been assigned to ITEC Orders Team. Please click on the below link to view the record.<br/><br/>'+casUrl+'</font></td></tr></table></td></tr></table><br/><br/></body></html>';
                        String[] toadd; 
                        toadd.add(CaseServiceUtility.getITECUser());                    
                        mail = setSingleEmailMessage(null,cas.Id,toadd, itecbody, 'Case transferred to ITEC Orders Team', null,label.DSRepairs_Org_Id);
                        bulkEmails.add(mail); 
                    }
                }
            }
            if(lstMessage.size()>0){
                try {
                    if(!(Test.isRunningTest()))
                        Messaging.sendEmail(lstMessage);
                } catch (Exception e) {
                    system.debug('Mail Sending Exception '+e.getMessage());
                }
            }
            if( bulkEmails.size() >0){
                Messaging.reserveSingleEmailCapacity(listObjCaseNew.size());
                if(!(Test.isRunningTest()) )
                    Messaging.sendEmail(bulkEmails); 
            }
            if(bulkEmailsNavDB.size()>0 ){
                if(!(Test.isRunningTest()) )
                    Messaging.sendEmail(bulkEmailsNavDB); 
            } 
            if(bulkEmailsAVSAT.size()>0 ){
                if(!(Test.isRunningTest()) )
                    Messaging.sendEmail(bulkEmailsAVSAT); 
            }
                
            if(!AircraftNotificationsTriggerStopper.hasalreadyExecutedNavdb())
            {
                AircraftNotificationsTriggerStopper.setalreadyExecutedNavdb();
                if(listCaseids.size() > 0){
                    map<id,EmailTemplate> mapEmailTemp = new map<id,EmailTemplate>([SELECT Body,HtmlValue,Id,Subject FROM EmailTemplate WHERE Id =: mapemailtemplateids.values()]);
                    List<EmailMessage> listInsertEmailMessage = new List<EmailMessage>();
                    for(Case c: listCaseids){
                        EmailMessage emailToCase = new EmailMessage();
                        emailToCase.Incoming = false;
                        if(mapEmailTemplateIds.get(c.Id) != null){
                            EmailTemplate emailTemp = mapEmailTemp.get(id.valueOf(mapEmailTemplateIds.get(c.Id)));
                            if(emailTemp != null){
                                emailToCase.Subject = emailTemp.subject.replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);
                                emailToCase.FromName = label.Yourresponse_Email;
                                emailToCase.FromAddress = label.Yourresponse_Email;
                                emailToCase.MessageDate = system.now();
                                emailToCase.ParentId = c.Id;
                                String strtemp,strTextBody; 
                                if(null!= mapContactids && mapContactids.size()>0  && mapContactids.get(c.Id) != null){
                                    if(null!=lstcas && lstcas.size()>0 && null!=lstcas.get(c.id) && lstcas.get(c.id).contact!= null){
                                        string contactName = lstcas.get(c.id).contact.FirstName + ' ' + lstcas.get(c.id).contact.LastName; 
                                        emailToCase.ToAddress = lstcas.get(c.id).contact.Primary_Email_Address__c;
                                        if(mapCaseDetails.get(c.Id).size()>4){
                                            strTextBody = emailTemp.body.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]).replace('{!Case.Description}',mapCaseDetails.get(c.Id)[3]).replace('{!Case.Resolution__c}',mapCaseDetails.get(c.Id)[4]).replace('{!Case.Customer_Name__c}',mapCaseDetails.get(c.Id)[5]).replace('{!Case.Sales_Order_Number__c}',mapCaseDetails.get(c.Id)[6]).replace('{!Case.Customer_PO_RO_WONumber__c}',mapCaseDetails.get(c.Id)[7]).replace('{!Case.Hon_Plant_Code_del__c}',mapCaseDetails.get(c.Id)[8]);
                                            strtemp = emailTemp.HtmlValue.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]).replace('{!Case.Description}',mapCaseDetails.get(c.Id)[3]).replace('{!Case.Resolution__c}',mapCaseDetails.get(c.Id)[4]).replace('{!Case.Customer_Name__c}',mapCaseDetails.get(c.Id)[5]).replace('{!Case.Sales_Order_Number__c}',mapCaseDetails.get(c.Id)[6]).replace('{!Case.Customer_PO_RO_WONumber__c}',mapCaseDetails.get(c.Id)[7]).replace('{!Case.Hon_Plant_Code_del__c}',mapCaseDetails.get(c.Id)[8]);                                             
                                        }
                                        else if(mapCaseDetails.get(c.Id).size()==4){
                                            strTextBody = emailTemp.body.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]).replace('{!Case.Description}',mapCaseDetails.get(c.Id)[3]);
                                            strtemp = emailTemp.HtmlValue.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]).replace('{!Case.Description}',mapCaseDetails.get(c.Id)[3]);                                                
                                        }
                                        else{
                                            strTextBody = emailTemp.body.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);
                                            strtemp = emailTemp.HtmlValue.replace('{!Case.Contact_Name__c}',ContactName).replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);                                                
                                        }
                                        
                                    }
                                }
                                else{
                                    emailToCase.ToAddress = lstcas.get(c.id).SuppliedEmail;
                                    strTextBody = emailTemp.body.replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);
                                    strtemp = emailTemp.HtmlValue.replace('{!Case.CaseNumber}',mapCaseDetails.get(c.Id)[0]).replace('{!Case.Subject}',mapCaseDetails.get(c.Id)[1]).replace('{!Case.Case_Ref_ID__c}',mapCaseDetails.get(c.Id)[2]);                                                
                                    
                                }
                                if(strtemp!=null && strtemp.length()>0 ){
                                    if(strtemp.length()<32000){
                                        emailToCase.HtmlBody =  strtemp.substring(0,strtemp.length());
                                    }
                                    else
                                    {
                                        emailToCase.HtmlBody =  strtemp.substring(0,32000);
                                    }
                                }
                                if(strTextBody !=null && strTextBody.length()>0 ){
                                    if(strTextBody.length()<32000){
                                        emailToCase.TextBody =  strTextBody.substring(0,strTextBody.length());
                                    }
                                    else
                                    {
                                        emailToCase.TextBody =  strTextBody.substring(0,32000);
                                    }
                                }                                            
                                listInsertEmailMessage.add(emailToCase);
                            }
                            
                        }                        
                    }
                    if(listInsertEmailMessage.size() > 0 )
                        insert listInsertEmailMessage;
                }                
            }  
            
        }catch(Exception e){  }           
    }
    /* Created By : Swastika Rajkhowa Date : 25 Nov 2017
** Class : CaseClassForPublicMethods 
** Description : email values assign
** Trigger Event : After Update
** Parameters : all the values for  Messaging.SingleEmailMessage
** Return : assign values
*/      
    public static Messaging.SingleEmailMessage setSingleEmailMessage(Id targetObjectId,Id whatId,String[] toAddresses, string mailBody, string mailSubject, Id templateId,Id orgWideEmailAddressId)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        if(targetObjectId!=null){
            message.setTargetObjectId(targetObjectId);
        }
        if(whatId!=null){
            message.setWhatId(whatId); 
        }                               
        message.setBccSender(false);
        message.setUseSignature(false);
        if(orgWideEmailAddressId!=null){
            message.setOrgWideEmailAddressId(orgWideEmailAddressId);
        }
        else{
            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
        }
        message.setSaveAsActivity(false); 
        if(toAddresses!=null){          
            message.setToAddresses(toAddresses);
        }
        if(mailBody!=null){
            message.setHtmlBody(mailBody);
        }
        if(mailSubject!=null){
            message.setSubject(mailSubject);
        }
        if(templateId!=null){           
            message.setTemplateId(templateId); 
        }   
        return message;
    }
    /* Created By : Swastika Rajkhowa Date : 25 Nov 2017
    ** Class : CaseClassForPublicMethods 
    ** Description : create a list of string 
    ** Trigger Event : After Update
    ** Parameters : case record
    ** Return : assign values
    */ 
    @testvisible
    private static List<String> setCaseDetail(Case cas){
        List<string> caseDet = new List<string>();
        if(cas.CaseNumber != null)
            caseDet.add(cas.CaseNumber);
        else
            caseDet.add(' ');
        
        if( cas.Subject != null)
            caseDet.add(cas.Subject);
        else
            caseDet.add(' ');
        
        if(cas.Case_Ref_ID__c != null)
            caseDet.add(cas.Case_Ref_ID__c);
        else
            caseDet.add(' ');
        if(cas.Description!= null)
            caseDet.add(cas.Description);
        else
            caseDet.add(' ');
        return  caseDet;    
    }
    /* Created By : Swastika Rajkhowa Date : 25 Nov 2017
    ** Class : CaseClassForPublicMethods 
    ** Description : assign vales to mapEmailTemplateids,mapContactids,mapCaseDetails 
    ** Trigger Event : After Update
    ** Parameters : case record
    ** Return : void
    */ 
    @testvisible 
    private static void assignValues(Boolean isSendMail, Case cas, Id templateId){
        if(isSendMail!=null)
            blnSendMail = isSendMail;
        mapEmailTemplateids.put(cas.id,templateId);
        mapContactids.put(cas.id,cas.contactid);
        List<string> caseDet = setCaseDetail(cas);
        mapCaseDetails.put(cas.id,caseDet);
    }
    public static List<Messaging.SingleEmailMessage> CreateBulkEmailsNavDB(String strDMLMode,Boolean isAfter, Case cas,Map<Id,Case> oldmap, Map<Id,Case> lstCas){
        List<Messaging.SingleEmailMessage> bulkEmailsNavDB = new List<Messaging.SingleEmailMessage>(); 
        if(('Update').equals(strDMLMode) && cas.Type!=null && cas.Type!= oldmap.get(cas.id).Type && cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id && cas.IsClosed == False)
        {
            system.debug('typeCase@@@');  
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
            string conid=Label.UFR_Cont_Id;
            List<String> typeCase = new List<String>();
            List<String> typeCas = new List<String>();
            String[] toaddress = new String[]{};
                typeCase.add(CaseServiceUtility.getCaseEmailId(cas.Type));    
            system.debug('typeCase@@@^^'+typeCase );   
            if(typecase.size()>0) 
            {  
                
                for(String s: typecase)
                { 
                    typeCas = s.split(',');
                    system.debug('string SSSS:'+typeCas );
                    
                }
            }
            /*if(typeCas.size()>0)
            {
            for(string st: typeCas)
            {
            toaddress.add(st);
            system.debug('string SSSS:'+toaddress); 
            }
            }*/
            mapEmailTemplateids.put(cas.id,label.AeroBiz_TypeChangeTemplate);           
            message=setSingleEmailMessage(conid,cas.Id,typeCas, null, null,label.AeroBiz_TypeChangeTemplate,label.Yourresponse_OrgId);
            msgList.add(message);
            try{
                //if(!(Test.isRunningTest()) )
                //{
                Savepoint sp = Database.setSavepoint();
                Messaging.sendEmail(msgList);
                Database.rollback(sp);
                //}
            }catch(Exception e){} 
            for(Messaging.SingleEmailMessage email : msgList){                    
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend = setSingleEmailMessage(null,null,email.getToAddresses(), email.getHTMLBody(), email.getSubject(),null,email.getOrgWideEmailAddressId());
                bulkEmailsNavDB.add(emailToSend); 
            }                
        }
        Boolean isCaseClosed;
        if(cas.IsClosed!=null)
            isCaseClosed = cas.IsClosed;
        if(Test.isRunningTest()){
            isCaseClosed = true;
        }  
        system.debug('typeCase@@@');     
        if( ('Update').equals(strDMLMode) && isAfter && TriggerCheck.firstIntEscRun && cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id && isCaseClosed == true && isCaseClosed!=oldmap.get(cas.id).IsClosed )
        {
            system.debug('typeCase@@@');    
            try{                          
                system.debug('typeCase@@@');                        
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                string conid=Label.UFR_Cont_Id;
                List<String> typeCase = new List<String>();
                List<String> typeCas = new List<String>();
                //String[] typeCase = new String[1];
                typeCase.add(CaseServiceUtility.getCaseEmailId(cas.Type)); 
                
                
                if(typecase.size()>0) 
                {  
                    
                    for(String s: typecase)
                    { 
                        typeCas = s.split(',');
                        system.debug('string SSSS:'+typeCas );
                        
                    }
                }
                if(lstCas.get(cas.Id).Owner.Email!=null && lstCas.get(cas.Id).Owner.Email!=''){      
                    typeCas.add(lstCas.get(cas.Id).Owner.Email);
                    system.debug('typeCase'+typeCase);
                }
                typeCas.add(cas.SuppliedEmail);
                mapEmailTemplateids.put(cas.id,label.AeroBizCaseClosureNotification);
                message= setSingleEmailMessage(conid,cas.Id,typeCas, null, null, label.AeroBizCaseClosureNotification,label.Yourresponse_OrgId);
                
                msgList.add(message);
                try{
                    //if(!(Test.isRunningTest()) )
                    //{ 
                    Savepoint sp = Database.setSavepoint();
                    Messaging.sendEmail(msgList);
                    Database.rollback(sp);
                    //}
                }catch(Exception e){}
                for(Messaging.SingleEmailMessage email : msgList){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend = setSingleEmailMessage(null,null,email.getToAddresses(), email.getHTMLBody(), email.getSubject(),null,email.getOrgWideEmailAddressId());
                    bulkEmailsNavDB.add(emailToSend); 
                }                 
                List<string> caseDet = setCaseDetail(cas);                            
                if(cas.Description!= null)
                    caseDet.add(cas.Description);
                else
                    caseDet.add(' ');
                
                if(cas.Resolution__c!= null)
                    caseDet.add(cas.Resolution__c);
                else
                    caseDet.add(' ');
                if(cas.SuppliedEmail!= null)
                    caseDet.add(cas.SuppliedEmail);
                else
                    caseDet.add(' '); 
                
                mapCaseDetails.put(cas.id,caseDet);
                
                TriggerCheck.firstIntEscRun = false;   
            }
            catch(Exception exc) {
                System.debug('*******************'+exc);
            }
        }
            if(cas.ContactId == null && cas.Origin!=null && (cas.Origin=='Email-AeroBizSupport' || cas.Origin=='Email-Aero Export Hold' || cas.Origin=='Email-ROCAPS' || cas.Origin=='Email-JXSupport' || cas.Origin=='Email-Raunheim' || cas.Origin=='Email-NavDB' || cas.Origin=='Email-Edinburgh' || cas.Origin=='Email-Garden Grove'|| cas.origin=='Email- AerospaceWarranty') 
               && (cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('NavDB Accts', 'Case').Id || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Aero Export Holds', 'Case').Id || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id 
                   || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('AeroebizSupport', 'Case').Id 
                   || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('JXSupport', 'Case').Id || cas.RecordtypeId== RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id) 
               && (Test.isRunningTest() ||!AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO()))
            {
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
                string conid=Label.UFR_Cont_Id;
                String[] toAddresses = new String[] {cas.SuppliedEmail}; 
                    message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
                if(cas.Emailbox_Origin__c=='Email-NavDB' || cas.Emailbox_Origin__c=='Email-AeroBizSupport'|| (cas.Emailbox_Origin__c=='Email-Orders' ))
                {
                    templateId = label.Case_Creation_Template_ID3;
                }
                if(cas.Emailbox_Origin__c=='Email-Aero Export Hold')
                {
                    templateId = label.Export_Hold_Inquiry;
                }                                
                if(null!=cas.Emailbox_Origin__c && cas.Emailbox_Origin__c == 'Email-JXSupport' ){
                    templateId = label.JX_Customer_Support_ID1; 
                }
                else if(cas.Emailbox_Origin__c=='Email-Raunheim'){
                    templateId = label.Order_Confirmation_For_Raunheim; 
                }
                else if(cas.Emailbox_Origin__c=='Email-Edinburgh' ){
                    templateId = label.Order_Confirmation_Template_Edinburgh;
                }
                else if(cas.Emailbox_Origin__c=='Email-Garden Grove'){
                    templateId = label.Order_Confirmation_For_GardenGrove;  
                }
                else if(cas.Emailbox_Origin__c=='Email- AerospaceWarranty'){
                    templateId = label.Case_Creation_Template_ID;
                }
                mapEmailTemplateids.put(cas.id,templateId);
                message = setSingleEmailMessage(conid,cas.Id,toAddresses, null, null, templateId,label.Yourresponse_OrgId);
                message.setToAddresses(toAddresses); 
                bulkEmailsNavDB.add(message); 
                List<string> caseDet = setCaseDetail(cas);
                mapCaseDetails.put(cas.id,caseDet);
                AircraftNotificationsTriggerStopper.setalreadyExecutedPPO();
            }
        if(cas.ContactId != null && (cas.Origin == 'Email-Orders' || cas.Origin == 'Email-Order Status' || cas.Origin == 'Email-Quotes' || cas.Origin == 'Email-BGAOEMQuoteOrders' || cas.Origin == 'Email-CSO BGA Spares') 
           && (cas.sbu__c == 'ATR' || cas.sbu__c == 'BGA' || cas.sbu__c == 'D&S' || cas.sbu__c == 'Intercompany') 
           && (cas.PFECN__c=='Portal' || cas.PFECN__c=='Manual' || cas.PFECN__c=='Refer to Network' || cas.PFECN__c=='EDI' || cas.PFECN__c=='Winshuttle' 
               || cas.PFECN__c=='Customer Funded Manual') && (Test.isRunningTest()||!AircraftNotificationsTriggerStopper.hasalreadyExecutedORdersRT()))
        {                            
            AircraftNotificationsTriggerStopper.setalreadyExecutedORdersRT();
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
            string conid=Label.UFR_Cont_Id;
            String[] toAddresses = new String[] {cas.SuppliedEmail};
                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId); 
            if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Origin == 'Email-BGAOEMQuoteOrders' || cas.Origin == 'Email-CSO BGA Spares') && cas.PFECN__c=='Portal'){
                templateId = label.Orders_PFECN;
            }
            if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.PFECN__c=='Portal'){
                templateId = label.Order_Status_PFECN;
            }
            if(cas.Emailbox_Origin__c == 'Email-Quotes' && cas.PFECN__c=='Portal'){
                templateId = label.Quotes_PFECN;
            }
            if(cas.Emailbox_Origin__c == 'Email-Orders' && (cas.PFECN__c=='Manual' || cas.PFECN__c=='Winshuttle' || cas.PFECN__c=='EDI' || cas.PFECN__c=='Customer Funded Manual' ))
            {
                templateId = label.Inquiry_Confirmation;
            }
            if((cas.Origin == 'Email-BGAOEMQuoteOrders' || cas.Origin == 'Email-CSO BGA Spares') && cas.PFECN__c=='Manual' || cas.PFECN__c=='Customer Funded Manual')
            {
                templateId = label.Order_Confirmation; 
            }
            if(cas.Emailbox_Origin__c == 'Email-Order Status' && (cas.PFECN__c=='Manual' || cas.PFECN__c=='Winshuttle' || cas.PFECN__c=='EDI' || cas.PFECN__c=='Customer Funded Manual'))
            {   
                if(cas.Status=='Rejected' && cas.Reason_for_Cancellation__c == 'Redirected to Portal')
                    templateId = label.Case_Creation_OrderStatus_Template_Id;
                else
                    templateId = label.Order_Status_Inquiry;
            }
            if(cas.Emailbox_Origin__c == 'Email-Quotes' && (cas.PFECN__c=='Manual' || cas.PFECN__c=='Winshuttle' || cas.PFECN__c=='EDI' || cas.PFECN__c=='Customer Funded Manual'))
            {   templateId = label.Quote_Request_Confirmation; 
            }
            if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status' || cas.Emailbox_Origin__c == 'Email-Quotes') && cas.PFECN__c=='Refer to Network')
            {
                templateId = label.D_S_Refer_to_Network;
            }
            mapEmailTemplateids.put(cas.id,templateId);
            mapContactids.put(cas.id,cas.contactid);
            message = setSingleEmailMessage(conid,cas.Id,toAddresses, null, null, templateId,label.Yourresponse_OrgId);
            bulkEmailsNavDB.add(message);  
            List<string> caseDet = setCaseDetail(cas);
            mapCaseDetails.put(cas.id,caseDet); 
        } 
        return bulkEmailsNavDB;
    }
    //code added for avsat autoresponse
    public static List<Messaging.SingleEmailMessage> CreateBulkEmailsAVSAT(String strDMLMode, Case cas){
        List<Messaging.SingleEmailMessage> bulkEmailsAVSAT = new List<Messaging.SingleEmailMessage>();
        if(('Insert').equals(strDMLMode) && cas.ContactId != null && cas.Emailbox_Origin__c!=null && cas.Emailbox_Origin__c=='Email-AVSAT Orders'&& !AircraftNotificationsTriggerStopper.hasalreadyExecutedPPO())
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
            String[] toAddresses1 = new String[] {cas.SuppliedEmail}; 
                message=setSingleEmailMessage(cas.ContactId,cas.Id,toAddresses1,null ,null,label.Case_Creation_Template_ID3,null);
            bulkEmailsAVSAT.add(message);
            AircraftNotificationsTriggerStopper.setalreadyExecutedPPO();                             
        } 
        return bulkEmailsAVSAT;       
    }
    //Create map for BulkEmails
    public static List<Messaging.SingleEmailMessage> CreateBulkEmails(boolean validEmail, boolean emailDomain,String strDMLMode,Boolean isAfter, Case cas,Map<Id,Case> oldmap){ 
        List<Messaging.SingleEmailMessage> bulkEmails= new List<Messaging.SingleEmailMessage>(); 
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        string strSurveyTemplate = label.Web_Support_Survey_Template;
        Id orgWideEmailAddressId = null;
        Id templateId =null ;
        if(cas.Origin=='Email-DS OEM & Spares Internal'){
            templateId = label.Internal_Escalations_Case;
        }
        if(cas.Origin=='Email-DS Repairs Internal'){
            templateId = label.Internal_Escalations_Case;       
        }                            
        if(cas.Emailbox_Origin__c == 'Email- AerospaceWarranty' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' ){
            templateId = label.Case_Creation_Template_ID;
        }
        if((cas.Emailbox_Origin__c == 'Email-Orders' )&& cas.Service_Level__c != 'Unauthorized Dist/Brkr' && cas.sbu__c == 'ATR' 
           && (!cas.Do_Not_Send_to_Portal__c)
           && (!lstcas.get(cas.id).account.Orders_Next_Wave__c) && cas.PFECN__c==null)
        {
            templateId = label.ATR_Redirect_to_Portal_Orders;
        }
        if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' && 
           cas.sbu__c == 'ATR' && cas.Do_Not_Send_to_Portal__c && cas.PFECN__c==null)
        {
            templateId = label.Order_Status_Inquiry;
        }
        if(cas.Emailbox_Origin__c == 'Email-Order Status' && cas.Service_Level__c != 'Unauthorized Dist/Brkr' &&
           cas.sbu__c == 'ATR' 
           &&  (!cas.Do_Not_Send_to_Portal__c)&& cas.PFECN__c==null)
        {
            templateId = label.Order_Status_Request;
        }
        //code starts for JXSupport
        if(null!=cas.Emailbox_Origin__c && cas.Emailbox_Origin__c == 'Email-JXSupport' )
        {
            templateId = label.JX_Customer_Support_ID1;
        }
        if(('Update').equals(strDMLMode) 
           && cas.Survey_Sent__c == 1 
           && oldMap.get(cas.id).Survey_Sent__c != 1
           && cas.Survey_Type__c == 'Web_Support'
           && !((cas.Emailbox_Origin__c=='Email-Orders' && cas.SBU__c =='ATR' 
                 && (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && null!= lstcas.get(cas.id).account.Orders_Next_Wave__c && lstcas.get(cas.id).account.Orders_Next_Wave__c==true)      
                 && (cas.Do_Not_Send_to_Portal__c))))
        {                           
            orgWideEmailAddressId = label.Myaerospace_Org_Id;
            templateId = strSurveyTemplate;
        }
        if(('Update').equals(strDMLMode) && cas.RecordTypeId == Label.WIS_RecordType_Id && cas.Ownerid!= oldMap.get(cas.id).Ownerid && cas.Ownerid == Label.Airbus_Queue_Id){
            templateId = Label.WIS_Email_Temp_Id;                     
            orgWideEmailAddressId = label.AeroNo_Reply_email_ID;
        }    
        
        if(('Update').equals(strDMLMode) &&(cas.Emailbox_Origin__c=='Email-Quotes') && cas.SBU__c == 'D&S' && (cas.Service_Level__c != 'Refer to Network')  && cas.Origin!= oldMap.get(cas.id).Origin && cas.PFECN__c==null)
        {
            if(cas.Origin=='Email'){
                orgWideEmailAddressId = label.Yourresponse_OrgId;
                templateId = label.All_Concierge_and_D_S_Owner_Operator_Quotes_Notification_Template_Id;  
            }
        }
        else if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-Quotes' && cas.sbu__c == 'BGA' 
                && cas.PFECN__c==null)
        { 
            if(cas.Service_Level__c != 'Unauthorized Dist/Brkr')
            {
                if ((cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                     || !emailDomain || cas.Region__c =='Asia/Pacific Rim') && validEmail && (Null!=cas.SuppliedEmail && !(cas.SuppliedEmail.contains('@linmarr.com'))))
                {
                    orgWideEmailAddressId = label.Yourresponse_OrgId;
                    templateId = label.Quote_Request_Confirmation; 
                }
                else if((Null!=cas.SuppliedEmail && cas.SuppliedEmail.contains('@linmarr.com'))|| (cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' 
                                                                                                   && emailDomain && cas.Region__c!='Asia/Pacific Rim' && validEmail))
                {
                    templateId = label.Quote_Request; 
                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                }                     
            }
        } 
        else if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-Quotes' && cas.sbu__c == 'BGA' 
                && cas.PFECN__c==null )
        {
            orgWideEmailAddressId = label.Yourresponse_OrgId;
            templateId = label.ATRNextWaveCustomerPortal;                         
        }                  
        if(('Insert').equals(strDMLMode) && null!=cas.Primary_Email_Address__c && cas.Emailbox_Origin__c == 'Email-Order Changes' 
           && (null!=cas.SBU__c && (cas.SBU__c=='D&S' && cas.Service_Level__c != 'Refer to Network') ) && cas.Service_Level__c!='Unauthorized Dist/Brkr' ){
               orgWideEmailAddressId = label.Yourresponse_OrgId;
               templateId = label.Case_Creation_Acknowledgement_D_S_Order_Changes_Temp_Id;
           }
        if(cas.Service_Level__c != 'Unauthorized Dist/Brkr'){
            if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c == 'Email-Quotes'&& cas.sbu__c == 'ATR' 
               && cas.PFECN__c==null){
                   orgWideEmailAddressId = label.Yourresponse_OrgId;
                   templateId = label.ATRNextWaveCustomerPortal;
               }
            if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c == 'Email-Quotes'&& cas.sbu__c == 'ATR' && cas.Quotes_Do_Not_Send_to_Portal__c && validEmail && cas.PFECN__c==null){
                orgWideEmailAddressId = label.Yourresponse_OrgId;
                templateId = label.Quote_Request_Confirmation;
            }                   
        }  
        if(('Insert').equals(strDMLMode)  && (cas.Subject == Null || (cas.Subject!=Null && !(cas.Subject.contains('MTO')))) 
           && (cas.Origin=='Web') && cas.recordtypeid == label.recordtype_case_quotes ){                   
               templateId = label.Quote_Portal;
               orgWideEmailAddressId = label.Yourresponse_OrgId;                                                   
           }  
        if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-RO EMEAI Internal' ||
                                             cas.Emailbox_Origin__c=='Email-RO Americas Internal' ||
                                             cas.Emailbox_Origin__c=='Email-R&O APAC Internal' ||
                                             cas.Emailbox_Origin__c=='Email-OEM Internal'  ||
                                             cas.Emailbox_Origin__c=='Email-ACTinternal' ||
                                             cas.Emailbox_Origin__c=='Email-APACACTinternal' ||
                                             cas.Emailbox_Origin__c=='Email-EMEAACTInternal' ))
        {
            templateId = label.Internal_Escalations_Case;
            orgWideEmailAddressId = label.Yourresponse_OrgId;
        }     
        if(cas.Subject!=Null)
        {
            if(cas.Subject.contains('MTO') && cas.Origin=='Web' )
            {
                if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Subject!=oldMap.get(cas.id).Subject))
                {
                    templateId = MTOTemplate;
                    orgWideEmailAddressId = label.Yourresponse_OrgId;
                }
            }
        }
        if(cas.Sub_Class__c == 'Deferred Online Order' && (cas.Subject == null || (cas.Subject!=Null && !(cas.Subject.contains('SPEX Warranty'))
                                                                                   && !(cas.Subject.contains('MTO'))&& !(cas.Subject.contains('WebOrder; SPEX; Warranty verification'))))
           && !(cas.Emailbox_Origin__c=='Email-Orders' && cas.SBU__c =='ATR'   
                && (null!=lstcas.get(cas.id) && null!=lstcas.get(cas.id).account && null!= lstcas.get(cas.id).account.Orders_Next_Wave__c && lstcas.get(cas.id).account.Orders_Next_Wave__c==true)
                && (cas.Do_Not_Send_to_Portal__c)))
        {
            if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Sub_Class__c != oldMap.get(cas.id).Sub_Class__c))
            {
                templateId = OtherHoldTemplate;
                orgWideEmailAddressId = label.Yourresponse_OrgId;                         
            }
        }
        
        if(cas.Subject!=Null)
        {
            if(cas.Subject.contains('WebOrder; SPEX; Warranty verification'))
            {
                if(('Insert').equals(strDMLMode) || (('Update').equals(strDMLMode) && cas.Subject!=oldMap.get(cas.id).Subject))
                {
                    templateId = spexTemplate;
                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                }
            }
        } 
        if(cas.Service_Level__c != 'Unauthorized Dist/Brkr')
        {
            if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c == 'Email-Orders' ) && cas.sbu__c != 'ATR' && cas.sbu__c != 'D&S' && cas.sbu__c != 'BGA' && cas.service_level__c != 'Unauthorized Dist/Brkr' && cas.Region__c !='Asia/Pacific Rim' && cas.PFECN__c==null)
            { 
                orgWideEmailAddressId = label.Yourresponse_OrgId;                     
                templateId = label.Order_Confirmation;  
                
            }
            
            else if(('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders') && cas.sbu__c == 'BGA' 
                    && cas.PFECN__c==null)                   
            { 
                if ((cas.Account_Type__c == 'Owner/Operator' || cas.Account_Type__c == 'Fractional Ownership' 
                     || !emailDomain) || cas.Region__c=='Asia/Pacific Rim' )
                {
                    orgWideEmailAddressId = label.Yourresponse_OrgId;                    
                    templateId = label.Order_Confirmation; 
                }
                
                else if(cas.Account_Type__c != 'Owner/Operator' && cas.Account_Type__c != 'Fractional Ownership' 
                        && emailDomain && cas.Region__c!='Asia/Pacific Rim')
                {
                    templateId = label.Order_Request; 
                    orgWideEmailAddressId = label.Yourresponse_OrgId; 
                    
                }
            }
            else if(((('Insert').equals(strDMLMode) && (cas.Emailbox_Origin__c=='Email-Orders') 
                      && (cas.SBU__c == 'D&S')
                      && (cas.Service_Level__c != 'Refer to Network') && cas.Primary_Email_Address__c != '' && cas.Region__c != 'Asia/Pacific Rim') 
                     || (('Insert').equals(strDMLMode)&& (cas.Emailbox_Origin__c=='Email-Orders') && cas.Region__c=='Asia/Pacific Rim' && cas.SBU__c != 'ATR')) && cas.PFECN__c==null)
            {
                orgWideEmailAddressId = label.Yourresponse_OrgId;
                templateId = label.Order_Confirmation; 
            }
        } 
        if(('Insert').equals(strDMLMode) && cas.Emailbox_Origin__c=='Email-R&O MechComponents' && cas.SuppliedEmail!=null )
        {
            orgWideEmailAddressId = label.Yourresponse_OrgId;                   
            templateId = label.Case_Creation_Template_ID; 
        }
        /* 
if( ('Update').equals(strDMLMode) && isAfter && TriggerCheck.firstIntEscRun && cas.recordtypeid == RecordTypeServices.getRecordTypeByName('Internal Escalations', 'Case').Id && cas.IsClosed == true && cas.IsClosed !=oldmap.get(cas.id).IsClosed )
{
orgWideEmailAddressId= label.Yourresponse_OrgId;                   
templateId = label.EscalationCaseClosed_Template;
}
*/
           if(templateId != null && orgWideEmailAddressId!= null){            
            message = setSingleEmailMessage(cas.ContactId,cas.Id,null, null,null, templateId,orgWideEmailAddressId);
               bulkEmails.add(message);
           }             
        if(cas.Emailbox_Origin__c == 'Email-AMDB Production'){                            
            list<String> toadd  = (label.AMDB_Case_Creation_Notification).split(',');                                                    
            List<Messaging.SingleEmailMessage> AMDBbulkEmails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();              
            orgWideEmailAddressId = label.Yourresponse_OrgId;
            message1.setSaveAsActivity(false);
            if(cas.contactid != null){
                message1.setTargetObjectId(cas.ContactId);
            }
            templateId = label.AMDB_Case_Creation_Template;
            message1.setTemplateId(templateId);
            message1.setWhatId(cas.Id); 
            AMDBbulkEmails.add(message1);
            //if(!(Test.isRunningTest()) )
            //{ 
            Savepoint sp = Database.setSavepoint();
            Messaging.sendEmail(AMDBbulkEmails);
            Database.rollback(sp);           
            //}
            for(Messaging.SingleEmailMessage email : AMDBbulkEmails){
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setCcAddresses(toadd);
                emailToSend.setPlainTextBody(email.getPlainTextBody());
                emailToSend.setHTMLBody(email.getHTMLBody());
                emailToSend.setSubject(email.getSubject());
                emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                emailToSend.setTargetObjectId(cas.ContactId);
                emailToSend.setWhatId(cas.Id);
                bulkEmails.add(emailToSend);
            }
        }
        return bulkEmails;     
    }    
    @testvisible 
    private static string getGDCGroup(string classification){
        string GDCGroup='';
        if (classification =='Activation') 
        {
            GDCGroup = 'GDC Accounts Activation';
        }
        else if (classification =='Cancellation'){
            GDCGroup = 'GDC Accounts Cancellation';
        }
        
        else if (classification =='MyGDC Training')
        {
            GDCGroup = 'GDC Accounts MyGDC Training';
        }
        else if (classification =='Renewal')
        {
            GDCGroup = 'GDC Accounts Renewal';
        }
        else if(classification =='Technical Support')
        {
            GDCGroup = 'GDC Accounts Technical Support';
        }
        return GDCGroup;
    }
}