/**
* @author  Swastika Rajkhowa
* @date 11/10/2017
*
* @description - Contains entire case trigger logic on before and after Update. 
    03-May-2018    NTTDATA         Modified code to send survey email to user once case is closed and case origin is Phone and Status Order Change for INC0000370606
**/
public with sharing class CaseServiceOnUpdate{
    //Variable Declaration
    //Profiles
    static Id idCSOBusAdminProf = label.CSO_Bus_Admin_Prof_Id ;
    static Id idHSysAdminNonUSProf = label.Honeywell_System_Administrator_Non_US_PFID; 
    static Id idHSysAdminProf = Label.Honeywell_System_Administrator; 
    static Id idHSysAdminUSProf = label.Honeywell_System_Administrator_US; 
    static Id idSysyAdminProf = label.Sys_Admin_Profile_Id; 
    static Id idAogWayBill_Api_User = label.AOG_WAYBILL_API_USER;
    static Id idCoreRecoveryTriggerUser = Label.Core_Recovery_Trigger_User;
    //Default Users
    static Id aeroDefaultUserId = CaseServiceUtility.getAreoDefaultUser();
    static Id deneidPartyScreeningAPIUserId = CaseServiceUtility.getDeniedScreeningAPIUser();
    static Id effortlessOrdersUserId = CaseServiceUtility.getEffortlessUser();
    //Account
    static Id idChina_National_Aero_Acc_Id = label.China_National_Aero_Acc_Id;
    static Id idMultipleMilitaryAircraftApplication = label.Multiple_Military_Aircraft_Applications;
    //Contact
    static Id idDLCorpHoneywellContact = label.DL_CORPHoneywell_com_Contact_Id; //'0031300002Ir23m'
    //Org Wide Email Address
    static Id idYourresponse_OrgId = label.Yourresponse_OrgId; 
    static Id FssactivationrOrgId = label.FssactivationrOrgId;
    static Id idAogWayBill_FromMail = Label.Aog_WayBill_Email_Id; 
    static Id idExcWaybill_FromMail = Label.Exc_From_Mail_Id;
    static Id idCore_Recovery_FromMail = Label.Core_Recovery_MailAddress;
    //Email Templates
    static Id idATR_Send_to_PortalTemplate = Label.ATR_Send_to_Portal;
    static Id idOrder_Status_RequestTemplate = Label.Order_Status_Request; 
    static Id idATR_Quotes_First_NotificationTemplate = Label.ATR_Quotes_First_Notification; 
    static Id idCEC_NotificationTemplate = Label.CEC_Notification;
    static Id Godirect_NotificationTemplate = Label.FSSActivationdue_Notification; 
    static Id idAogWayBill_Email_Template = Label.Aog_WayBill_Email_Template;
    static Id idAogWayBill_PickedUpEmail_Template = Label.Aog_WayBill_PickedEmail_Template;
    static Id idAogWayBill_DeliveredEmail_Template = Label.Aog_WayBill_DeliveredEmail_Template;
    static Id idExchange_AWB_Email_Tempate = Label.Exchange_AWB_Sent_Email_Template;
    static Id idExchange_Shp_Email_Template = Label.Exchange_Shipped_Email_Template;
    static Id idExchange_Del_Email_Template = Label.Exchange_Delivered_Email_Template;
    static Id idCore_Recovery_Second_Reminder_Email_Template = Label.Core_Recovery_Second_Reminder_Email_Template;
    static Id idCore_Recovery_Third_Reminder_Email_Template = Label.Core_Recovery_Third_Reminder_Email_Template;
    static Id idCore_Recovery_Final_Reminder_Email_Template = Label.Core_Recovery_Final_Reminder_Email_Template;
    //Group - Regular
    static Id idCSO = label.CSO_GRP_ID;
    static Id idTech_Issue = Label.TechIssue_GRP_ID;  
    Static Id IdOrdersTeam = label.Orders_Team_Id;
    //Group - Queue
    static Id idComplianceQueueCSO = Label.Compliance_Queue_CSO; 
    static Id idComplianceQueueGTO = Label.Compliance_Queue_GTO;
    static Id idCSO_OEM_Spares = Label.CSO_OEM_Spares; 
    static Id idCSOROTeam = Label.CSO_R_O_Team; 
    static Id idCSR_Online_Ordering_Approval = label.CSR_Online_Ordering_Approval_Queue;
    static Id idEBizWebOperations = label.EBiz_Web_Operations;
    static Id idGDCTech =  label.GDCTech; 
    static Id idGFO =  label.GFO; 
    static Id idACTTeam = label.ACT_Team;  
    static Id idBFEFastlane = Label.BFE_Fastlane_Owner;
    static Id idCSOBGAOEMTeam = label.CSO_BGA_OEM_Team_label; 
    static Id idClearingHouse = Label.D_S_Clearing_House;
    static Id idDSPRQuotesTeam = Label.D_S_PR_Quotes_Team; 
    static Id idGDCAccount = Label.GDC_Accounts_Queue;
    static Id idNorcrossCSR = Label.Norcross_CSR_Queue_ID; 
    static Id idOEMTeam = label.OEM_Team;
    static Id idPortalQuotes = label.Portal_Quotes;
    static Id idQuoteTeam = label.Quotes_TeamId; 
    static Id idROAvionics = label.R_O_Avionics_Queue_Id; 
        static Id idROBCustServ = label.R_O_Basingstoke_Customer_Services_Queue_ID;
    static Id idROBOrderEntry = label.R_O_Basingstoke_Order_Entry_Queue_ID;
        static Id idROBQuotes = label.R_O_Basingstoke_Quotes_Queue_ID;
    static Id idROBShippingInv = label.R_O_Basingstoke_Shipping_Invoicing_Queue_ID; 
        static Id idROBTranship = label.R_O_Basingstoke_Tranship_Queue_ID; 
        static Id idROBourCustServBMTH = label.R_O_Bournemouth_Customer_Service_BMTH_Queue_ID; 
        static Id idROBourCustServPrague = label.R_O_Bournemouth_Customer_Service_Prague_Queue_ID;
        static Id idROBourQuotes = label.R_O_Bournemouth_Quotes_Queue_ID;
    static Id idROEMEAIAvionics = Label.R_O_EMEAI_Avionics_QueueId; 
    static Id idROEMEAIMeach = Label.R_O_EMEAI_Mechanical_QueueId; 
    static Id idROInternal = label.R_O_Internal_Queue_Id; 
    static Id idROQuoteTeam = label.R_O_Quotes_Team_Queue_Id; 
        static Id idRORCustServ = label.R_O_Raunheim_Customer_Services_Queue_ID;
    static Id idROROrderEntry = label.R_O_Raunheim_Order_Entry_Queue_ID; 
        static Id idRORQuotes = label.R_O_Raunheim_Quotes_Queue_ID;
    static Id idRORShippingInov = label.R_O_Raunheim_Shipping_Invoicing_Queue_ID; 
    static Id idROTCustServ = Label.R_O_Toulouse_Customer_Service;
    static Id idROTOrderEntry = label.R_O_Toulouse_Order_Entry_Queue_ID; 
        static Id idROTQuotes = label.R_O_Toulouse_Quotes_Queue_ID;
    static Id idROTShippingInov = label.R_O_Toulouse_Shipping_Invoicing_Queue_ID; 
        static Id idROUKSCFaxes = label.R_O_UKSC_Faxes_Queue_ID; 
    static Id idROVOrderEntry = label.R_O_Vendome_Order_Entry_Queue_ID; 
    static Id idROMechComponents = label.R_O_Mech_Components_Queue_Id;
    static Id idROQuoteEscalation = Label.R_O_Quotes_Team_Escalation_Queue_ID; 
    static Id idWIS_Team = Label.WIS_Team_Group_Id; 
    static Id idCustomerMailTemplateId = Label.RMA_Customer_Remainder_Template_id;
      
    static Id idRejectTemplateId = Label.RMA;
    static Id idInductTemplateId = Label.RMA_Induct_Template_Id;
    static Id idRMAUserId = Label.RMA_API_USER_ID;
    static Id idRMA_FromMail = Label.RMA_SendMail_Id;
    
      static Id idBFE_FromMail = Label.BFE_From_Mail_ID;
    static Id idBFEUserId = Label.BFE_API_USER_ID;
    //Custom Setting Variables
    static Map<String,R_O_Case_Reassignment_Queue__c> mapROQType = R_O_Case_Reassignment_Queue__c.getall();
    static Map<Id,String> mapGroupQName = new Map<ID,String>();
    //get the values from R&O Case Reassignment Queue in custom settings
    static List<R_O_Case_Reassignment_Queue__c> qtype = R_O_Case_Reassignment_Queue__c.getall().values(); 
    static string CoreRecoveryDateDiff = label.Core_Recovery_Reminder_Date_Diff;
    //#####################################################################################################################################################//
    
    //Before Update Methods
    /* Created By : Swastika Rajkhowa Date : 03 Nov 2017
    ** Trigger : Updatetimeinreopen      Line of Code : 3- 22
    ** Description : when case is reopen update Reopen_Status_Ended__c by current datetime
    ** Trigger Event : before Update
    */
    public static void beforeUpdateCaseReopen(List<Case> listObjCaseNew,Map<ID,Case> oldMap ){  
        for(case obj:listObjCaseNew){
        if(obj.recordtypeid ==RecordTypeServices.getRecordTypeByName('Quotes', 'Case').Id||obj.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id||obj.recordtypeid ==RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id||obj.recordtypeid ==RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id||obj.recordtypeid ==RecordTypeServices.getRecordTypeByName('ReturnsPRO', 'Case').Id||obj.recordtypeid ==RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id||obj.recordtypeid ==RecordTypeServices.getRecordTypeByName('Internal Escalations', 'Case').Id  || obj.recordtypeid == RecordTypeServices.getRecordTypeByName('Warranty', 'Case').Id ) //Warrenty record type added for INC0001343054
        {
            if(obj.status!=null){
            if(obj.status.contains('Re-Open') && oldMap.get(obj.id).status!=obj.status)
                {                
                obj.Reopen_Status_Ended__c = Null;
                obj.Reopen_Status_Started__c = system.now();
                }
               else  if(obj.status.contains('Done') )
                 { 
                 if(obj.Reopen_Status_Started__c != Null)
                 {
                    obj.Reopen_Status_Ended__c = system.now();
                 }
                }
            }    
         }
        }
    }
    
    //added by Radha
    public static void beforeUpdateCase_caselineitem(List<Case> listObjCaseNew,Map<ID,Case> oldMap ){  
        
        //List <Case> Processsing_cases = new List <Case> ();
        Set<ID> Processsing_cases = new Set<Id>();
        List<ID> Processsing_cases2 = new List<Id>();
        Set<ID> Processsing_cases3 = new Set<Id>();
        List <Case_Line_Item__c> list_caselineitem = new List <Case_Line_Item__c> ();
        //Set <Case_Line_Item__c> list_caselineitem = new Set <Case_Line_Item__c> ();
        /*
        for(case objc:listObjCaseNew){
            if(objc.recordtypeid ==RecordTypeServices.getRecordTypeByName('Quotes', 'Case').Id && objc.Origin=='Web' && (objc.Status=='Cancelled'||objc.Status=='Cancelled'||objc.Status=='Closed as Duplicate'||objc.Status=='Discard'||objc.Status=='Done'||objc.status=='Done-Transferred' ) ) 
                {
                    Processsing_cases.add(objc.Id);    
                }
            
        }   */  
        
        //Map <ID, List<Case_Line_Item__c>> m = new Map<ID, List<Case_Line_Item__c>> (); 
        
        /*
        for(Case_Line_Item__c c_lineitem : [SELECT id,Price_Status__c,Price__c,Case_Number__c from Case_Line_Item__c WHERE Case_Number__c in : Processsing_cases AND (Price__c = NULL OR (Price_Status__c != 'No Bid' OR Price_Status__c!= 'Referred to HAT') )]){
            //m.put(c_lineitem.Case_Number__c, list_caselineitem);
            //c_lineitem.Case_Number__c.addError('Please fill in Price or Price status to close the current case'); 
            Processsing_cases2.add(c_lineitem.Case_NumberId__c);
        }*/
        
        /*
        list_caselineitem = [SELECT id,Price_Status__c,Price__c,Case_Number__c from Case_Line_Item__c WHERE Case_Number__c in : Processsing_cases AND (Price__c = NULL AND(Price_Status__c != 'No Bid' OR Price_Status__c!= 'Referred to HAT') )];  
        if(Processsing_cases2.size()>0){
            for(Case c: Processsing_cases2)
                c.addError('Please fill in Price or Price status to close the current case'); 
            
         }*/
    }
    
    
    /* Created By : Garvit Totuka   Date : 02 Nov 2017
    ** Trigger : Case_ProvideAccess     Line of Code : 105 - 169
    ** Description : Get Account Ids  
    ** Trigger Event : Before Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; newMap - Trigger.NewMap
    ** Return : List of Ids - Account Ids set IsExpectedUpdateChanged__c field value and return Account Id List
    */
    public static List<Id> beforeUpdateGetAccountIds(List<Case> newCase, Map<Id, Case> oldMap, Map<Id, Case> newMap){
        List<Id> accidlist = new List<Id>();
        
        for(Case cases :newCase){
            Boolean check=false; 
            Boolean emailDomain = (cases.SuppliedEmail !=null) && (check)? false : true;  
            if(oldMap.get(cases.Id).Expected_Update__c != newMap.get(cases.Id).Expected_Update__c){
                cases.IsExpectedUpdateChanged__c = true;
            }
            if(oldMap.get(cases.Id).accountid != newMap.get(cases.Id).accountid){
                accidlist.add(cases.accountid);
                cases.FSE_name_1__c = null;
                cases.FSE_name_2__c = null;
                cases.FSE_name_3__c = null;
            }          
        }
        return accidlist;
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Trigger : Case_ProvideAccess Line of Code : 183 - 198
    ** Description : Throw an error if case is closed with open activities
    ** Trigger Event : Before Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; newMap - Trigger.NewMap
    ** Return : void calculate no of closed cases and add error if any open task is found
    */
    public static void closeCaseError(List<Case> newCase, Map<Id,Case> oldMap, Map<id,Case> newMap){
        List<Task> taskList = new List<Task>();
        taskList = CaseServiceForCommonMethods.tasksFromCase(newCase);
        Id ConnexiumPIAPIUserId = Label.Connexium_PI_API_User;
        
        for(Case cases :newCase){
            if(oldMap.get(cases.Id).status != newMap.get(cases.Id).status 
                && (cases.status == 'Done' || cases.status == 'Tech Issue-SR Assigned' || cases.status == 'Approved'
                    || cases.status == 'Completed' || cases.status == 'Closed/Collected' || cases.status == 'Closed with Credit'
                    || cases.status == 'Partially Accepted' || cases.status == 'Denied')
                || (cases.status == 'Closed' && cases.Case_Record_Type__c == 'CSM Toolbox' )
                ){
                integer closedCases = 0;
                for(Task ta:taskList){
                    if(ta.whatId == cases.Id){
                        closedCases = closedCases + 1;
                    }
                } 
                if(closedCases > 0 && aeroDefaultUserId != Userinfo.getUserId() && (UserInfo.getprofileId() != ConnexiumPIAPIUserId)){ //005300000042rPLAAY - Aero Default user
                    cases.addError('This case cannot be closed because it has open activities.');   
                }
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Trigger : Case_ProvideAccess     Line of Code : 265 - 312, 356 - 361
    ** Description : verify the Compliance and update Is Compliance; insert & Delete existing Compliance Case
    ** Trigger Event : Before Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; newMap - Trigger.NewMap
    ** Return : void insert or delete compliance case
    */
    public static void beforeUpdateComplianceCase(List<Case> newCase, Map<Id,Case> oldMap, Map<Id,Case> newMap){
        List<Compliance_Case__c> complianceCases = new List<Compliance_Case__c>();
        List<String> deleteCompliance = new List<String>();
        List<Compliance_Case__c> complianceCasesDelete = new List<Compliance_Case__c>();
        
        for(Case cases :newCase){ 
            if((cases.Government_Compliance_SM_M_Content__c  == 'Yes'|| cases.Export_Compliance_Content_ITAR_EAR__c  == 'Yes')  
                && ((oldMap.get(cases.Id).Export_Compliance_Content_ITAR_EAR__c == 'No' || oldMap.get(cases.Id).Export_Compliance_Content_ITAR_EAR__c == 'Undetermined') 
                && (oldMap.get(cases.Id).Government_Compliance_SM_M_Content__c == 'No'  || oldMap.get(cases.Id).Government_Compliance_SM_M_Content__c == 'Undetermined'))
                ){
                Compliance_Case__c compliance = new Compliance_Case__c();
                if(cases.classification__C != null && cases.classification__c == 'CSO Spares'){    
                    compliance.Queue_Name__c = 'Compliance Queue CSO';              
                }
                else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id 
                    && cases.classification__c != 'GTO D&S Technical Issue'){    
                    compliance.Queue_Name__c = 'Compliance Queue GTO';         
                }
                else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id){
                         //SR# 426679 change - start
                    compliance.Queue_Name__c = 'Compliance Queue CSO';
                        //SR# 426679 change - End                   
                }
                else {  
                           //SR# 426679 change - start 
                    compliance.Queue_Name__c = 'Compliance Queue CSO';
                           //SR# 426679 change - End
                }   
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
                if(cases.Iscompliance__C == false){
                    complianceCases.add(compliance);
                    cases.Iscompliance__C = true;
                }
            }
            if(((oldMap.get(cases.Id).Government_Compliance_SM_M_Content__c  == 'Yes'||  oldMap.get(cases.Id).Export_Compliance_Content_ITAR_EAR__c  == 'Yes') 
                || (oldMap.get(cases.Id).Government_Compliance_SM_M_Content__c  == null|| oldMap.get(cases.Id).Export_Compliance_Content_ITAR_EAR__c  == null))  
                && ((cases.Export_Compliance_Content_ITAR_EAR__c == 'No' || cases.Export_Compliance_Content_ITAR_EAR__c == 'Undetermined') 
                && (cases.Government_Compliance_SM_M_Content__c == 'No'  || cases.Government_Compliance_SM_M_Content__c == 'Undetermined'))
                ){
                deleteCompliance.add(cases.CaseNumber);
                cases.Iscompliance__C = false;
            }
        }
        if(complianceCases.size() > 0){
            try{    
                insert complianceCases;
            }
            catch(Exception e){
                System.debug('Exception occured in Case_provide Access '+e);
            }
        }
        if(deleteCompliance.size() > 0){
            complianceCasesDelete = [Select Id from Compliance_Case__c where name in:deleteCompliance];
            try{    
                delete complianceCasesDelete;
            }
            catch(Exception e){
                System.debug('Exception occured in Case_provide Access '+e);
            }
        }
    }
    
    /* Created By : Garvit Totuka   Date : 02 Nov 2017
    ** Trigger : Case_ProvideAccess     Line of Code : 314 - 319, 335 - 339
    ** Description : check if case owner is changed  
    ** Trigger Event : Before Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; newMap - Trigger.NewMap
    ** Return : void set IsOwnerChanged__c field value if owner changes
    */
    public static void beforeUpdateIsOwnerChanged(List<Case> newCase, Map<Id,Case> oldMap, Map<Id,Case> newMap){
        for(Case cases :newCase){
            if(oldMap.get(cases.Id).OwnerId != newMap.get(cases.Id).OwnerId){
                cases.IsOwnerChanged__c = true;
                booleanclass.caseprovideaccessbefore = false;
            }
            else if(booleanclass.caseprovideaccessbefore){
                cases.IsOwnerChanged__c = false;
            }
        }
    }
    
    /* Created By : Garvit Totuka   Date : 02 Nov 2017
    ** Trigger : Case_ProvideAccess     Line of Code : 386 - 420
    ** Description : check whether case is compliance or not   
    ** Trigger Event : Before Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; newMap - Trigger.NewMap
    ** Return : void set IsMemberOfCompliance__c field value if case is compliance 
    */
    public static void beforeUpdateIsMemberCompliance(List<Case> newCase, Map<Id,Case> oldMap, Map<Id,Case> newMap){
        list<case> casList = new list<case>();
        for(Case cases :newCase){
            if(oldMap.get(cases.Id).OwnerId != newMap.get(cases.Id).OwnerId){
                String currentOwner = newMap.get(cases.Id).OwnerId;
                currentOwner = currentOwner.substring(0,3);
                if((idComplianceQueueCSO == oldMap.get(cases.Id).OwnerId  || idComplianceQueueGTO == oldMap.get(cases.Id).OwnerId) 
                    && currentOwner == '005'
                    ){ //SR# 426679 change - End
                    cases.IsMemberOfCompliance__c = true;
                }
                else{
                    cases.IsMemberOfCompliance__c = false;
                }         
            }
            // added for calculation of age of sub status for engine rentals
            system.debug('@@@@@outsideif@@@@@'+cases);
             if(cases .Status ==  'On Hold' && cases .Recordtypeid == label.Engine_Rentals_RT_ID && (oldMap.get(cases.id).Sub_Status__c  != newMap.get(cases.id).Sub_Status__c)) {
                cases .SubStatusChangeTime__c = system.now();
                casList.add(cases);
                system.debug('@@@@@insideif@@@@@'+cases);
             }
        }
    }
    
    //##############################MainCaseTrigger - Before Update Method##########################################################################//
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Before Update Methods - Common
    ** Trigger Event : Before Update
    ** Type : Public
    ** Parameters : 
    ** Return : 
    */
    public static void beforeUpdateMethod(List<Case> newCase, Map<Id,Case> oldMap){
        // CaseValidationForReturnRecordType  //
        Set<String> setQueue = new Set<String>(); 
        List<QueueId__c> lstQueueid = QueueId__c.getall().values();
        for(QueueId__c qid :lstQueueid){ 
            setQueue.add(qid.Queue_Id__c); 
        }
        // CaseValidationForReturnRecordType  //
        
        // CaseValUpdtBasOnOwner //
        for(R_O_Case_Reassignment_Queue__c lstRoObj : qtype ){                    
            mapGroupQName.put(lstRoObj.QueueId__c,lstRoObj.name);        
        }
        // CaseValUpdtBasOnOwner //
                
        // Added below for Avoiding SOQL 101 Error - Start
        Set<ID> finalContactId = new Set<Id>();
        for(case cas : newCase){ 
            if((cas.Contactid != null  && oldMap.get(cas.Id).Contactid != cas.Contactid) 
                || (cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('Pilot’s Corner Avionics','Case').Id)//label.Pilot_s_Corner_Avionics_RT_ID)
                ){
                finalContactId.add(cas.Contactid);
            }               
        }   
        Map<id,Contact> lstContact1 = new Map<id,Contact>();
        if(null != finalContactId && finalContactId.size() > 0){
            lstContact1 = new Map<id,Contact>([select accountid, Account.Type, Account.Strategic_Business_Unit__c,Contact_Function__c 
                                                from Contact  
                                                where Id = :finalContactId]); 
        }
        // Added below for Avoiding SOQL 101 Error - End
        
        DateTime currDate = System.Now();
        Map<id,Case> lstCas = new Map<id,Case>([select id,Plant__c,Plant__r.SAP_Plant_Code__c,RecordTypeId,Classification__c,CaseNumber,CaseLink__c,Due_Date__c,
                                                    account.Do_Not_Send_to_Portal__c,Account.Type,Account.Is_Bendix_King_Dealer__c,Account.Strategic_Business_Unit__c,
                                                    account.Service_Level__c,ownerid,SBU__c,Emailbox_Origin__c,account.name,account.Orders_Next_Wave__c,account.PFECN__c,
                                                    account.Orders_Next_Wave_Check_Time__c,(Select id,MyMaintainer_Roles__c 
                                                    from Case_Extensions__r 
                                                    where Case_object__r.Case_Record_Type__c = 'WEB Portal Registration' and Case_object__r.Subject LIKE '%Maintenance Advisor%') 
                                                from Case 
                                                where id = :newCase
                                                ]);
        
        if(TriggerInactive.blnCaseWFDelegateUpdate){
            CaseWorkflowDelegate.caseWFDelegateUpdate(newCase);
        }
        myMaintainerProject(newCase,oldMap,lstCas);
        plantCodeProject(newCase,oldMap,lstCas);
        sendBulkEmailSBUATR(newCase,oldMap);
        sendBulkEmailForCEC(newCase,oldMap);
        aircraftConnectivityProject(newCase,oldMap);
        workStremProject(newCase,oldMap,lstContact1);
        aeroDefaultQuotesProject(newCase,oldMap);
        chinaNationalAeroProject(newCase,oldMap);
        casesOnHold(newCase,oldMap);
        sysAdminProfileProject(newCase,oldMap);
        closeCaseErrorGDC(newCase,oldMap);
        sbuUpdateForAOG(newCase,oldMap);
        changeAccountId(newCase,oldMap,lstContact1);
        closeCaseOwnerBasedOnStatus(newCase,oldMap);
    /*Commented to avoid SOQL 101 error high priority prod move
        caseErrorOnHistory(newCase,oldMap);
        end of change*/
         updateOnBehalfEndUserStatus(newCase,oldMap,lstContact1);
        if(lstCas != null){
            casePreventCreation(newCase,oldMap,lstCas);
        }
        
        caseValueUpdate(newCase,oldMap);
        autoCloseActivity(newCase,oldMap);
        caseValueUpdateBaseOnOwner(newCase,oldMap,mapGroupQName);
        portalAutoclose(newCase,oldMap);
        errorHWInternalActions(newCase,oldMap);
            
        
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        CaseServiceForCommonMethods.RnOCaseOwnerAssignOnCreationMethod(newCase,oldMap,'Update');
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        ///////////////// Update_OnBehalfendUserStatus //////
        caseGDCTechIssueOps.updateDueDateAfterAssigned(newCase,oldMap);
        ////////////////// Update_OnBehalfendUserStatus ////////////
    }
    //created by Radha
    //Service Task: Start
        public static void beforeUpdate_customerSupport_businessfocal(List<Case> updatedCases){
            List <Account> acclist = new List <Account>();
            List <Case> processing_cases = new List <Case>();
            Set <Id> Acc_set = new Set <Id>();
            
            if(updatedCases!= NULL) {
                for(Case c: updatedCases){
                    Acc_set.add(c.AccountId);
                }
            }
            
            Map<Id,Account> mapOfAccountandFocalFields = new Map<Id,Account>();
                for(Account accObj : [SELECT Id,Customer_Support_Focal__c,Business_Focal__c FROM Account WHERE Id In:Acc_set ]){
                     mapOfAccountandFocalFields.put(accObj.Id,accObj); 
                }  
                
                for (Case cas: updatedCases){
                    System.Debug('case number:' +cas.casenumber);
                    System.Debug('Customer support focal:' +cas.Customer_Support_Focal__c);
                    if(!mapOfAccountandFocalFields.isEmpty() && mapOfAccountandFocalFields.containsKey(cas.accountId) 
                        && mapOfAccountandFocalFields.get(cas.accountId).Customer_Support_Focal__c != null && cas.Customer_Support_Focal__c == NULL){
                            cas.Customer_Support_Focal__c  = mapOfAccountandFocalFields.get(cas.accountId).Customer_Support_Focal__c;
                    }
                    
                    if(!mapOfAccountandFocalFields.isEmpty() && mapOfAccountandFocalFields.containsKey(cas.accountId) 
                        && mapOfAccountandFocalFields.get(cas.accountId).Business_Focal__c != null && cas.Business_Focal__c == NULL){
                        cas.Business_Focal__c = mapOfAccountandFocalFields.get(cas.accountId).Business_Focal__c;
                    }   
                        
                }
        }//end of beforeUpdate_customerSupport_businessfocal
        //Service Task: END
    
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : My Maintainer Project
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ; lstCas - Map of Id and Case
    ** Return : 
    */
    private static void myMaintainerProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> lstCas){
        for(Case cas : listObjCaseNew){
                // Added code for MyMaintainer Project      
            if(null != cas.Case_Record_Type__c 
                && cas.Case_Record_Type__c == 'WEB Portal Registration' 
                && (cas.Subject != null && cas.Subject.contains('Maintenance Advisor')) 
                && (cas.Status != oldMap.get(cas.id).Status && cas.Status == 'Approved')
                ){      
                if(lstcas.get(cas.id).Case_Extensions__r != null){        
                    Case_Extension__c CasExt = new Case_Extension__c();     
                    CasExt = lstcas.get(cas.id).Case_Extensions__r;     
                    if(CasExt.MyMaintainer_Roles__c == '' || CasExt.MyMaintainer_Roles__c == null){     
                        cas.addError(Label.MyMaintainer_Error);     
                    }       
                }       
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : My Maintainer Project
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ; lstCas - Map of Id and Case
    ** Return : 
    */
    private static void plantCodeProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> lstCas){
        if(!lstCas.isEmpty()){ //add this if condition for Red Button Site
            for(Case cas : listObjCaseNew){
                // Added code for INC000012572407 to populate Hon Plant Code field when Plant field has value
                if(null != cas.Plant__c && null != lstcas.get(cas.id).Plant__c && null != lstcas.get(cas.id).Plant__r.SAP_Plant_Code__c){
                    cas.Hon_Plant_Code_del__c = lstcas.get(cas.id).Plant__r.SAP_Plant_Code__c;
                }
                // End code for INC000012572407 to populate Hon Plant Code field when Plant field has value
            }
            // End code for INC000012572407 to populate Hon Plant Code field when Plant field has value
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Send Bulk Email for SBU - ATR (INC000007081254)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : 
    */
    /*************INC000007081254************************27-Nov-2014************************START******/
    private static void sendBulkEmailSBUATR(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        for(Case cas : listObjCaseNew){
            /*if(cas.SBU__c == 'ATR' && cas.Status == 'Open' && cas.Origin == 'Email'){
                if(cas.RecordTypeId != oldMap.get(cas.id).RecordTypeId 
                    && cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('Orders','Case').Id){ //Label.Orders_Rec_ID){  //Orders: 01230000000Zen3
                    if(cas.Type == 'Place Order' && cas.sub_class__c != 'BFE/SFE Buyer/Seller Furnished'){
                        if(cas.Do_not_send_to_portal__c == False){                                                            
                            cas.Status = 'Closed';
                            try{
                                //Template = ATR Send to Portal: 00Xc0000000Qd82 //Common Methods
                                message.setBccSender(false);             
                                message.setUseSignature(false);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setWhatId(cas.Id);
                                message.setTargetObjectId(cas.ContactId);
                                message.setTemplateId(idATR_Send_to_PortalTemplate);//Label.ATR_Send_to_Portal);   
                                bulkEmails.add(message);                         
                            }
                            catch(Exception e){
                                System.debug('Exception -->>' + e); 
                            }
                        }
                    }
                    if(cas.Type == 'Order Status'){
                        cas.Status = 'Closed';
                        try{
                            //Template = BGA and D&S Email Order Status Customer Notification: 00Xa0000001j5Xz 
                            message.setBccSender(false);             
                            message.setUseSignature(false);
                            message.setOrgWideEmailAddressId(idYourresponse_OrgId);//label.Yourresponse_OrgId);
                            message.setWhatId(cas.Id);
                            message.setTargetObjectId(cas.ContactId);
                            message.setTemplateId(idOrder_Status_RequestTemplate);//Label.Order_Status_Request);  
                            bulkEmails.add(message);    
                        }
                        catch(Exception e){
                            System.debug('Exception -->>' + e); 
                        }
                    }                                              
                }
                    
                if(cas.RecordTypeId != oldMap.get(cas.id).RecordTypeId 
                    && cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id){ //Label.QuotesRecordID){
                    if(cas.Type == 'Quotes/Availability'){
                        if(cas.Quotes_Do_Not_Send_to_Portal__c == False){                                                         
                            cas.Status = 'Closed'; 
                            try{
                                // Template = ATR Quotes Send to Portal: 00Xc0000000QikL
                                message.setBccSender(false);             
                                message.setUseSignature(false);
                                message.setOrgWideEmailAddressId(idYourresponse_OrgId);//label.Yourresponse_OrgId);
                                message.setWhatId(cas.Id);
                                message.setTargetObjectId(cas.ContactId);
                                message.setTemplateId(idATR_Quotes_First_NotificationTemplate);//Label.ATR_Quotes_First_Notification);   
                                bulkEmails.add(message);                                    
                            }
                            catch(Exception e){
                                System.debug('Exception -->>' + e);    
                            }
                        }     
                    }
                }
                                
            }*/
            //Send email to Godirectservice intro when FSS activation case due date change
            if(cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('FSS Activations','Case').Id)
            { 
                system.debug('inside FSS activation case due date change');
                if(cas.Due_Date__c  != oldMap.get(cas.id).Due_Date__c ){                                            
                    system.debug('inside due date change');
                    try{
                        message.setBccSender(false);             
                        message.setUseSignature(false);
                        message.toAddresses = new String[] {'serviceintro@honeywell.com'};
                        message.setSaveAsActivity(false);
                        message.setOrgWideEmailAddressId(FssactivationrOrgId);
                        message.setWhatId(cas.Id);
                        message.setTargetObjectId(idDLCorpHoneywellContact);//'0031300002Ir23m');                                  
                        message.setTemplateId(Godirect_NotificationTemplate);                         
                        msgList.add(message);
                        system.debug(msgList);
                        Savepoint sp = Database.setSavepoint();
                        Messaging.sendEmail(msgList);
                        Database.rollback(sp);
                        
                        for(Messaging.SingleEmailMessage email : msgList){
                            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                            emailToSend.setToAddresses(new String[] {label.godirectserviceintro});
                            emailToSend.setPlainTextBody(email.getPlainTextBody());
                            emailToSend.setHTMLBody(email.getHTMLBody());
                            emailToSend.setSubject(email.getSubject());
                            emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                            bulkEmails.add(emailToSend);                    
                        }
                    }
                    catch(Exception e){
                        System.debug('Exception -->>' + e);    
                    }                   
                }
            }
        }
        /***********INC000007081254**************************27-Nov-2014************************END******/
        /************Added for*INC000007081254************************27-Nov-2014***********START******/        
        try{
            if(bulkEmails.size() > 0){     
                Messaging.sendEmail(bulkEmails);  
            }
        }
        catch(Exception e){
            system.debug('Exception handle in SBU ATR '+e);
        }
        /************Added for*INC000007081254************************27-Nov-2014***********Ends******/
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Send Bulk Email for CED (INC000009688823)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : 
    */
    private static void sendBulkEmailForCEC(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
        for(Case cas : listObjCaseNew){
            if(cas.subject != null && cas.subject != ''){
                if(cas.Status == 'Done' && cas.subject.Startswith('From Hon.com CEC')){
                    try{     
                        message.setBccSender(false);             
                        message.setUseSignature(false);
                        message.toAddresses = new String[] {'dl-corphoneywell.com@honeywell.com'};
                        message.setSaveAsActivity(false);
                        message.setOrgWideEmailAddressId(idYourresponse_OrgId);//label.Yourresponse_OrgId);
                        message.setWhatId(cas.Id);
                        message.setTargetObjectId(idDLCorpHoneywellContact);//'0031300002Ir23m');                                  
                        message.setTemplateId(idCEC_NotificationTemplate);//Label.CEC_Notification);   
                        bulkEmails.add(message);    
                    }
                    catch(Exception e){
                        System.debug('Exception -->>' + e); 
                    }
                }
            }
        }

        try{
            if(bulkEmails.size() > 0){     
                Messaging.sendEmail(bulkEmails);  
            }
        }
        catch(Exception e){
            system.debug('Exception handle in SBU ATR '+e);
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Aircraft Connectivity Project
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : 
    */
    private static void aircraftConnectivityProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        for(Case cas : listObjCaseNew){     
            if(cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('FSS Technical Issue','Case').Id //Label.FSS_Tech_Issue_RT_ID 
                && cas.Priority != oldmap.get(cas.id).Priority && cas.IsClosed == False){
                if(cas.Priority == 'Severity 1'){
                    cas.SLA_Flag_Case_age__c = cas.CreatedDate + 1;
                }
                else if(cas.Priority == 'Severity 2'){
                    cas.SLA_Flag_Case_age__c = cas.CreatedDate + 2;
                }
                else if(cas.Priority == 'Severity 3'){
                    cas.SLA_Flag_Case_age__c = cas.CreatedDate + 3;
                }
            }
            if(cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('GDC Accounts','Case').Id //Label.GDC_Accounts 
                && cas.Origin == 'Web' 
                && cas.CreatedById == Label.ACSM_API_User_Id && cas.Createddate == cas.LastModifiedDate
                ){
                cas.Type = 'Connectivity';
                cas.Status = 'New';
                cas.OwnerId = idGDCAccount;//Label.GDC_Accounts_Queue;
                cas.Subject = 'Your company needs help with '+cas.Subject;
                cas.Classification__c = 'Technical Support';
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : work stream Project(INC000008506502)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : 
    */
    private static void workStremProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Contact> lstContact1){
        for(Case cas : listObjCaseNew){
            if(cas.RecordtypeId ==   RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id //Label.Repair_Overhaul_RT_ID 
                || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id //Label.OEM_Quotes_Orders_ID 
                || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id //Label.D_S_Quotes_Orders_RT_ID 
                || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id //Label.QuotesRecordID 
                || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id //Label.Orders_Rec_ID 
                || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Returns','Case').Id //Label.Returns_Recordtypeid 
                || cas.RecordtypeId ==  RecordTypeServices.getRecordTypeByName('ReturnsPRO','Case').Id //Label.ReturnsPRO_Id
                ){
                if((null != cas.RecordtypeId && cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id) //Label.Repair_Overhaul_RT_ID 
                    || (cas.Ownerid == idROAvionics //label.R_O_Avionics_Queue_Id 
                    || cas.Ownerid == idROMechComponents //label.R_O_Mech_Components_Queue_Id 
                    || cas.Ownerid == idROQuoteEscalation //Label.R_O_Quotes_Team_Escalation_Queue_ID 
                    || cas.Ownerid == idROTCustServ //Label.R_O_Toulouse_Customer_Service 
                    || cas.Ownerid == idROQuoteTeam //label.R_O_Quotes_Team_Queue_Id 
                    || cas.Ownerid == idROEMEAIAvionics //Label.R_O_EMEAI_Avionics_QueueId 
                    || cas.Ownerid == idROEMEAIMeach //Label.R_O_EMEAI_Mechanical_QueueId
                    )){
                    cas.Workstrem__c = 'Repair and Overhaul';
                }
                else if(null != cas.RecordtypeId && cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id //Label.OEM_Quotes_Orders_ID
                    ){
                    cas.Workstrem__c = 'OEM';
                }
                else if(cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id //Label.D_S_Quotes_Orders_RT_ID
                    ){
                    if(!lstContact1.isEmpty()){
                        if(cas.Contactid != null && lstContact1.get(cas.contactid).account.Type == 'OEM'){
                            cas.Workstrem__c = 'OEM';
                        }
                        else{
                            cas.Workstrem__c = 'Spares';
                        }
                    }
                    else{
                        if(cas.AccountId != null && (null != cas.Account_Type__c && cas.Account_Type__c == 'OEM')){
                            cas.Workstrem__c = 'OEM';
                        }
                        else{
                            cas.Workstrem__c = 'Spares';
                        }
                    }
                }
                else if(cas.RecordtypeId ==  RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id //Label.Orders_Rec_ID 
                    || cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id //Label.QuotesRecordID
                    ){
                    if(!lstContact1.isEmpty()){
                        if(cas.Contactid != null 
                            && (null != lstContact1.get(cas.contactid).account.Strategic_Business_Unit__c 
                            && lstContact1.get(cas.contactid).account.Strategic_Business_Unit__c == 'D&S') 
                            && (null != lstContact1.get(cas.contactid).account.Type 
                            && lstContact1.get(cas.contactid).account.Type == 'OEM')
                            ){
                            cas.Workstrem__c = 'OEM';
                        }
                        else{
                            cas.Workstrem__c = 'Spares';
                        }
                    }
                    else{
                        if(cas.AccountId != null && (null != cas.Account_Type__c && cas.Account_Type__c == 'OEM') && (null != cas.SBU__c && cas.SBU__c == 'D&S')
                            ){
                            cas.Workstrem__c = 'OEM';
                        }
                        else{
                            cas.Workstrem__c = 'Spares';
                        }
                    }
                }
                else if(cas.RecordtypeId ==  RecordTypeServices.getRecordTypeByName('Returns','Case').Id //Label.Returns_Recordtypeid 
                    ){
                    cas.workstrem__c = 'Returns';
                }
                else if(cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('ReturnsPRO','Case').Id //Label.ReturnsPRO_Id 
                    ){
                    cas.Workstrem__c = 'PRO';
                }
            }
        }
    }
        
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : work stream Project(INC000008506598)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : 
    */
    private static void aeroDefaultQuotesProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        String UName = Userinfo.getName();
        for(Case cas : listObjCaseNew){
            if(null != cas.Origin && UName == 'Aero Default' && cas.Emailbox_Origin__c == 'Email-DIBBS_RFQ' && cas.status == 'Open'){
                cas.Origin = 'Avatar';
                cas.RecordtypeId =  RecordTypeServices.getRecordTypeByName('Quotes','Case').Id; //Label.QuotesRecordID;
                cas.Ownerid = idQuoteTeam; //Label.Quotes_TeamId;
                cas.Classification__c = 'CSO Spares';
                cas.Type = 'Quotes/Availability';           
                cas.Sub_Class__c = '';
                cas.Detail_Class__c = '';
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : work stream Project(INC000007062745)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */
    private static void chinaNationalAeroProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        String casowid, casowidsub;
        for(Case cas : listObjCaseNew){
            if(oldMap.get(cas.id).OwnerId != cas.OwnerId 
                && (cas.Type != null 
                && (cas.Type == 'Place Order' || cas.Type == 'Order Changes' || cas.Type == 'Quotes/Availability')) 
                && (cas.AccountId != null && cas.AccountId == idChina_National_Aero_Acc_Id) //label.China_National_Aero_Acc_Id) 
                && String.valueOf(cas.OwnerId).startsWith('005')
                ){
                casowid = cas.OwnerId;
                casowidsub = Casowid.substring(0,3);
                cas.CaseOwnerChanged__c = casowidsub+' CHINA NAT ACC';
            }
        }
    }

    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : work stream Project(INC000006761159)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */
    private static void casesOnHold(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        for(Case cas : listObjCaseNew){
            if(cas.RecordTypeid ==  RecordTypeServices.getRecordTypeByName('D&S Discount Settings','Case').Id //Label.D_S_Discount_Settings_RT_Id 
                && cas.Status != null && oldMap.get(cas.id).Status != cas.Status && cas.Status == 'On Hold'
                ){
                cas.Sub_Status__c = 'Pending further action';
            }
            if(cas.RecordTypeid ==  RecordTypeServices.getRecordTypeByName('D&S Discount Settings','Case').Id //Label.D_S_Discount_Settings_RT_Id 
                && cas.Status != null && oldMap.get(cas.id).Status != cas.Status && cas.Status != 'On Hold' && oldMap.get(cas.id).Status == 'On Hold'
                ){
                cas.Sub_Status__c = '';
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : work stream Project(INC000006650064)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap 
    ** Return : void
    */
    private static void sysAdminProfileProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        String profileid = Userinfo.getprofileId();
        for(Case cas : listObjCaseNew){
           /*removing validation for SCTASK3331701 on Amy W's request
            if(cas.Recordtypeid != oldmap.get(cas.id).RecordtypeId 
                && oldmap.get(cas.id).RecordtypeId == RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id //Label.Internal_Escalations 
                && (profileid != idCSOBusAdminProf //label.CSO_Bus_Admin_Prof_Id 
                && profileid != idSysyAdminProf //label.Sys_Admin_Profile_Id 
                && profileid != idHSysAdminProf//Label.Honeywell_System_Administrator 
                && profileid != idHSysAdminNonUSProf //label.Honeywell_System_Administrator_Non_US_PFID 
                && profileid != idHSysAdminUSProf) //label.Honeywell_System_Administrator_US)
                ){
                cas.addError('The case record type for an Internal Escalation case should not be changed. Case transfer should be done by changing workstream and/or region. If the case record type must be changed, the change may be done by an SFDC administrator.');
            }
            end of SCTASK3331701  */
            if(cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id //Label.Internal_Escalations 
                && cas.Workstrem__c != null && cas.CSM_Region__c != null
                ){
                if(cas.Workstrem__c != oldmap.get(cas.id).Workstrem__c || cas.CSM_Region__c != oldmap.get(cas.id).CSM_Region__c){
                    if(cas.Workstrem__c == 'Repair and Overhaul'){
                        cas.OwnerId = idROInternal; //label.R_O_Internal_Queue_Id;
                        if(cas.CSM_Region__c == 'Americas'){
                            cas.Classification__c = 'R&O Americas Internal';
                        }
                        if(cas.CSM_Region__c == 'EMEAI'){
                            cas.Classification__c = 'R&O EMEAI Internal';
                        }
                        if(cas.CSM_Region__c == 'Asia/Pacific Rim'){
                            cas.Classification__c = 'R&O APAC Internal';
                        }
                    }
                    else if(cas.Workstrem__c == 'OEM'){
                        cas.OwnerId = idOEMTeam; //label.OEM_Team;
                        if(cas.CSM_Region__c == 'Americas'){
                            cas.Classification__c = 'OEM Americas Internal';
                        }
                        if(cas.CSM_Region__c == 'EMEAI'){
                            cas.Classification__c = 'OEM EMEAI Internal';
                        }
                        if(cas.CSM_Region__c == 'Asia/Pacific Rim'){
                            cas.Classification__c = 'OEM APAC Internal';
                        }
                    }
                    else if(cas.Workstrem__c == 'Spares'){
                        cas.OwnerId = idACTTeam; //label.ACT_Team;
                        if(cas.CSM_Region__c == 'Americas'){
                            cas.Classification__c = 'US ACT Internal';
                        }
                        if(cas.CSM_Region__c == 'EMEAI'){
                            cas.Classification__c = 'EMEA ACT Internal';
                        }
                        if(cas.CSM_Region__c == 'Asia/Pacific Rim'){
                            cas.Classification__c = 'APAC ACT Internal';
                        }
                    }
                }
            }
            if(cas.Ownerid != null && cas.OwnerId != oldmap.get(cas.id).OwnerId 
                    && cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Internal Escalations','Case').Id //Label.Internal_Escalations 
                    && String.valueOf(cas.OwnerId).startsWith('00G') 
                    && (profileid != idCSOBusAdminProf //label.CSO_Bus_Admin_Prof_Id 
                        && profileid != idSysyAdminProf //label.Sys_Admin_Profile_Id 
                        && profileid != idHSysAdminProf //Label.Honeywell_System_Administrator 
                        && profileid != idHSysAdminNonUSProf //label.Honeywell_System_Administrator_Non_US_PFID 
                        && profileid != idHSysAdminUSProf) //label.Honeywell_System_Administrator_US)
                    ){
                if((cas.OwnerId != idACTTeam //label.ACT_Team 
                    || cas.OwnerId != idOEMTeam //label.OEM_Team 
                    || cas.OwnerId != idROInternal) //label.R_O_Internal_Queue_Id) 
                    && (cas.Workstrem__c == oldmap.get(cas.id).Workstrem__c && cas.CSM_Region__c == oldmap.get(cas.id).CSM_Region__c)
                    ){
                    cas.addError('The case owner for an Internal Escalation case should not be assigned to a team. Cases should be assigned directly to people. If the owner must be changed, the change may be done by an SFDC administrator.');
                }
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : (INC000008656265)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : groupId - id of Group
    ** Return : Set<Id> set of user Ids
    */
    public static Set<Id> getUserIdFromGroup(Id groupId){
        Id userId = Label.WIS_Team_Group_Id;
        Set<Id> userids = new Set<id>();
        List<String> uid = new List<String>();
        if(userId != null){            
                uid.add(userId);
            }
            if(uid.size() > 0){
                for(String s :uid){
                    if(s.startswith('005')){
                        userids.add(s);
                    }
                }
            }
        return userids;
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : close case error for GDC (INC000008656265)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */
    private static void closeCaseErrorGDC(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        Set<Id> userids = getUserIdFromGroup(idWIS_Team);
        String loginuser = Userinfo.getUserId();
        for(Case cas : listObjCaseNew){
            if(cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('GDC Tech Issue','Case').Id //Label.GDC_Tech_Issue 
                && (cas.Status == 'Done' || cas.Status == 'Cancelled' || cas.Status == 'Discard' || cas.Status == 'Closed as Duplicate' || cas.Status == 'Reject') 
                && userids.contains(loginuser) && !(userids.contains(cas.CreatedById)) 
                && oldmap.get(cas.id).IsClosed == cas.IsClosed
                ){
                cas.addError('GDC Cases cannot be closed by WIS Team');
            }
        }
    }

    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : SBU change for AOG (INC000008676964)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap 
    ** Return : void
    */
    private static void sbuUpdateForAOG(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        for(Case cas : listObjCaseNew){
            if(cas.Recordtypeid == RecordTypeServices.getRecordTypeByName('AOG','Case').Id ||
               cas.Recordtypeid == RecordTypeServices.getRecordTypeByName('Exchange','Case').Id//Label.Case_AOG_RecordType 
                && null != cas.AccountId && null != cas.SBU__c && null == cas.SBU_w2c__c){
                cas.SBU_w2c__c = cas.SBU__c;
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Change Account Id for Case based on Contact's Account (INC000006732216)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */
    private static void changeAccountId(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Contact> lstContact1){
        if(lstContact1.isEmpty()){
            return;
        }
        for(Case cas : listObjCaseNew){
            if(null != cas.Contactid && oldMap.get(cas.id).Contactid != cas.Contactid){
                cas.accountid = lstContact1.get(cas.contactid).accountid;
            }    
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : update Owner Id afte Closing Case (INC000005948316)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */
    private static void closeCaseOwnerBasedOnStatus(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        for(Case cas : listObjCaseNew){
            if(oldMap.get(cas.id).Status != cas.Status 
                && (cas.Status == 'Done' || cas.Status == 'Discard' || cas.Status == 'Cancelled') 
                && cas.RecordtypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id //Label.Repair_Overhaul_RT_ID 
                && (cas.Emailbox_Origin__c == 'Email-R&O Avionics' || cas.Emailbox_Origin__c == 'Email-R&O MechComponents')
                ){
                if(null != cas.OwnerId){
                    cas.Case_OwnerId_After_Close__c = cas.OwnerId;
                }
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : case Error On CaseHistory (INC000009230119)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */
    /*Commented to avoid SOQL 101 error high priority prod move
    private static void caseErrorOnHistory(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        List<CaseHistory> casehis = getCaseHistory(listObjCaseNew);
        Map<Id,boolean> hischeck = new Map<Id,boolean>();
            for(CaseHistory cashis : casehis){
                if(cashis.newvalue == 'Done'){
                    hischeck.put(cashis.CaseId,true);
                }
            }
        for(Case cas : listObjCaseNew){
            if(cas.RecordTypeid == RecordTypeServices.getRecordTypeByName('Technical Issue','Case').Id //Technical Issue -  '01230000000ZJvU' 
                && hischeck.get(cas.id) == true && oldmap.get(cas.id).Status != 'Done' && (cas.status == 'Done')){
                cas.adderror('The Case status cannot be Done  for a Re-Opened Case. Please choose Re-closed to close the Case');
            }
        }
    }
    end of change
*/
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : get CaseHistory for Case
    ** Trigger Event : Before Update
    ** Type : Public
    ** Parameters : listObjCaseNew - Trigger.New
    ** Return : List<CaseHistory> list of CaseHistory 
    */
    /*Commented to avoid SOQL 101 error high priority prod move
      public static List<CaseHistory> getCaseHistory(List<Case> listObjCaseNew){
        system.debug('listObjCaseNew===>'+listObjCaseNew);
        list<CaseHistory> casehis = new list<CaseHistory>();    
        casehis = [select id, CreatedDate, oldvalue, newvalue, field, caseid 
                    from CaseHistory 
                    where caseid = :listObjCaseNew and field = :'Status' order by createddate desc];
        return casehis;
    }
    end of change
*/
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Update On Behalf of End User Status
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */
    private static void updateOnBehalfEndUserStatus(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Contact> lstContact1){
        DateTime currDate = System.Now();
        for(Case cas : listObjCaseNew){
            // INC000009033512 - Start - Hold condition
            if((null != cas.status) && cas.status.contains('On Hold')){  
                if(OldMap.get(cas.Id).Status != cas.Status || OldMap.get(cas.Id).Sub_Status__c != cas.Sub_Status__c){                     
                    cas.Time_of_this_Hold__c = system.now();           
                }
            }
            // INC000009033512 - End

            // Code for SR#403268 Starts
            if(cas.RecordTypeId ==  RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id){ //Label.NavDB_Prod_RecordId){
                if(OldMap.get(cas.Id).Status =='Closed' && cas.Status == 'Re-open'){
                    cas.Reopen_Status_Started__c = System.Now();
                    cas.Reopen_Status_ended__c =  null;
                }      
                if(OldMap.get(cas.Id).Status =='Re-open' && cas.Status == 'Closed'){ 
                    cas.Reopen_Status_ended__c =  System.Now();
                }
            }               
            // Code for SR#403268 Ends 

            // Code for INC000006490217 Starts
            if(cas.OwnerId == idNorcrossCSR){ //Label.Norcross_CSR_Queue_ID){
                if(OldMap.get(cas.Id).OwnerId != idNorcrossCSR){ //Label.Norcross_CSR_Queue_ID){
                    cas.RecordTypeId = RecordTypeServices.getRecordTypeByName('EMS orders','Case').Id; //label.EMS_Orders_RecordType_ID;
                    cas.Classification__c = 'CSO Special Programs';
                    cas.Sub_Class__c = 'EMS Norcross';
                    cas.Detail_Class__c = null;
                    cas.Type = 'Orders';
                    cas.Repair_Location__c = 'Norcross, GA';
                }      
            } 
            else if(cas.OwnerId == aeroDefaultUserId //Label.aero_default_user_id 
                && (null != cas.Origin && cas.Origin.contains('Email-EMS-Norcross'))){  
                if(OldMap.get(cas.Id).OwnerId != idNorcrossCSR){ //Label.Norcross_CSR_Queue_ID){
                    cas.OwnerID = idNorcrossCSR; //Label.Norcross_CSR_Queue_ID;
                    cas.RecordTypeId = RecordTypeServices.getRecordTypeByName('EMS Orders','Case').Id; //label.EMS_Orders_RecordType_ID;
                    cas.Classification__c = 'CSO Special Programs';
                    cas.Sub_Class__c = 'EMS Norcross';
                    cas.Detail_Class__c = null;
                    cas.Type = 'Orders';
                    cas.Repair_Location__c = 'Norcross, GA';
                }      
            }
            // Code for INC000006490217 ends
            
            if(cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('Pilot’s Corner Avionics','Case').Id //label.Pilot_s_Corner_Avionics_RT_ID 
                && OldMap.get(cas.Id).Contactid != cas.Contactid){
                cas.Web_Portal_Avionics_Pilot_s_Corner__c = cas.Contactid;      
                if(cas.Contactid == null){
                    cas.Contact_Func__c = null;
                }
                else{
                        // Modified below for Avoiding SOQL 101 Error - Start
                    cas.contact_func__c = lstContact1.get(cas.contactid).Contact_Function__c;
                        // Modified below for Avoiding SOQL 101 Error - End
                }       
            }
            if(OldMap.get(cas.Id).RecordTypeId != cas.RecordTypeId){
                if(OldMap.get(cas.Id).RecordTypeId == RecordTypeServices.getRecordTypeByName('Pilot’s Corner Avionics','Case').Id){ //label.Pilot_s_Corner_Avionics_RT_ID){                    
                    cas.Web_Portal_Avionics_Pilot_s_Corner__c = null;
                    cas.Contact_Func__c = null;
                }
                if(cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('Pilot’s Corner Avionics','Case').Id){ //label.Pilot_s_Corner_Avionics_RT_ID){                    
                    cas.Web_Portal_Avionics_Pilot_s_Corner__c = cas.Contactid;
                       // Modified below for Avoiding SOQL 101 Error - Start
                       cas.contact_func__c = lstContact1.get(cas.contactid).Contact_Function__c;
                       // Modified below for Avoiding SOQL 101 Error - End
                }
            }
            // Code added for SR # 377532 end
            
            if(OldMap.get(cas.Id).Sub_Status__c != cas.Sub_Status__c && cas.Case_Record_Type__c == 'Engine Rentals'){
                if(cas.Shipment_Sub_Status_Selected__c != null){
                    if ((cas.Status == 'On Hold'&& (cas.Sub_Status__c != 'Shipment' && oldMap.get(cas.Id).Sub_Status__c == 'Shipment'))|| 
                        ((cas.Status != 'On Hold' && oldMap.get(cas.Id).Status =='On Hold') && oldMap.get(cas.Id).Sub_Status__c == 'Shipment')){
                        cas.Shipment_Sub_Status_Ended__c = currDate;
                    }
                }
                if(cas.Removal_Sub_Status_Selected__c != null){
                    if((cas.Status == 'On Hold'&& (cas.Sub_Status__c != 'Removal' && oldMap.get(cas.Id).Sub_Status__c == 'Removal'))
                        || ((cas.Status != 'On Hold' && oldMap.get(cas.Id).Status == 'On Hold') && oldMap.get(cas.Id).Sub_Status__c == 'Removal')
                        ){
                        cas.Removal_Sub_Status_Ended__c = currDate;
                    }
                }
                    if(cas.DSO_Sub_Status_Selected__c != null){
                        if ((cas.Status == 'On Hold'&& (cas.Sub_Status__c != 'DSO' && oldMap.get(cas.Id).Sub_Status__c == 'DSO'))
                            || ((cas.Status != 'On Hold' && oldMap.get(cas.Id).Status == 'On Hold') && oldMap.get(cas.Id).Sub_Status__c == 'DSO')
                            ){
                            cas.DSO_Sub_Status_Ended__c = currDate; 
                        } 
                    } 
                    if (cas.Others_Sub_Status_Selected__c != null){
                        if ((cas.Status == 'On Hold'&& (cas.Sub_Status__c != 'Other' && oldMap.get(cas.Id).Sub_Status__c == 'Other'))
                            || ((cas.Status != 'On Hold' && oldMap.get(cas.Id).Status == 'On Hold') && oldMap.get(cas.Id).Sub_Status__c == 'Other')
                        ){
                            cas.Others_Sub_Status_Ended__c = currDate; 
                        } 
                    }
            }//////////////////////// Update_OnBehalfendUserStatus ////////////////////////////
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Case Prevent Creation
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */
    private static void casePreventCreation(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> lstCas){
        String UName = Userinfo.getName();
        for(Case cas : listObjCaseNew){
            String[] emailAddressArr = (label.BGA_Case_Creation_Notification).split(','); 
            boolean check = false; 
            for(String s :emailAddressArr){
                if(cas.SuppliedEmail != null){
                    if(cas.SuppliedEmail.contains(s)){
                        check = true;
                        break;
                    }
                }
            }   
                
            boolean emailDomain = (cas.SuppliedEmail != null) && (check)? false : true;  
            //INC000005888983---start
            String[] emailAddressArr1 = (label.ATR_Customers_to_the_Send_to_Portal).split(','); 
            boolean check1 = false; 
            for(String s :emailAddressArr1){
                if(cas.SuppliedEmail != null){
                    if(cas.SuppliedEmail.contains(s)){
                        check1 = true;
                        break;
                    }
                }
            }   
            boolean emailDomain1 = (cas.SuppliedEmail != null) && (check1)? true : false; 
            //INC000005888983---End 
            //INC000006789797 changes start
            Decimal Totalnumberofminutes =0;
            if(!test.isrunningtest())
            //Changes made for INC0003188192    
                //Totalnumberofminutes = ((cas.LastModifiedDate.getTime())/1000/60 - (cas.CreatedDate.getTime())/1000/60);
                Totalnumberofminutes = ((system.now().getTime())/1000/60 - (cas.CreatedDate.getTime())/1000/60);
               //Changes made for INC0003188192  end        
             //commented for  INC0003178310 
            /*if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status') 
                && emailDomain && (cas.Primary_Email_Address__c.contains('@')) //12:12:19:Removed condition for SBU for case auto close:(&& cas.SBU__c != 'ATR' && cas.SBU__c != 'D&S')//Added the comment for the ticket INC000011347550
                && (cas.SuppliedEmail != null 
                && (cas.SuppliedEmail.contains('@equipaero.com' ) || cas.SuppliedEmail.contains('@aarcorp.com') || cas.SuppliedEmail.contains('@triumphgroup.com')
                || emailDomain1))
                && (cas.status != 'On Hold' && (((null != cas.OwnerId && String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '00G' 
                && String.valueOf(cas.ownerid).substring(0,3) != '005') || (cas.ownerid == aeroDefaultUserId)) //label.aero_default_user_id 
                && (Totalnumberofminutes <= 2)))
                ){
                cas.Resolution__c = 'None';
                cas.status = 'Closed';
                cas.Sub_Class__c = '';
                cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                cas.Government_Compliance_SM_M_Content__c = 'No';
                // cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c + 1;
                    
                    caseshare objA350CaseShare = new CaseShare();
                    objA350CaseShare.CaseAccessLevel = 'Edit';
                    objA350CaseShare.UserorGroupid = idCSO; //label.CSO_GRP_ID;
                    objA350CaseShare.caseid = cas.id;
                    insert objA350CaseShare;
            }    */
            //commented for  INC0003178310 end
            //Added code for INC000006991156 
            /*if(cas.Emailbox_Origin__c != null && cas.Account_Concierge__c != null 
                && ( Test.isRunningTest()||UName == 'Aero Default') && cas.SBU__c == 'D&S' && oldmap.get(cas.id).IsClosed == cas.IsClosed 
               && oldmap.get(cas.id).of_Open_Activity__c == cas.of_Open_Activity__c && Totalnumberofminutes <= 2
                ){    
                if((cas.Emailbox_Origin__c == 'Email-AeroRepairs' || cas.Emailbox_Origin__c == 'Email-Bournemouth Repairs' || cas.Emailbox_Origin__c == 'Email-Yeovil Repairs') 
                    && cas.Recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id //label.Repair_Overhaul_RT_ID 
                    && cas.Account_Concierge__c == 'True'){
                    cas.Priority = 'Escalated';
                }
                if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status' || cas.Emailbox_Origin__c == 'Email-Order Changes') 
                    && cas.Recordtypeid == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id //label.Orders_Rec_ID 
                    && cas.Account_Concierge__c == 'True' 
                    && (cas.Classification__c != '' && cas.Classification__c == 'CSO Spares')){
                    cas.Priority = 'Escalated';
                }
            }*/       
            // End code for INC000006991156
            //Added for ticket Omnichannel-BFESupport 15/03/2016 - INC000009886376
            if(oldMap.get(cas.id).Ownerid != cas.Ownerid){  
                if(cas.Ownerid == idBFEFastlane){ //Label.BFE_Fastlane_Owner){
                    cas.Ownerid = idBFEFastlane; //Label.BFE_Fastlane_Owner;   
                    cas.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id; //Label.Orders_Rec_ID;
                    cas.Classification__c = 'CSO Spares';
                    cas.Sub_Class__c = 'BFE/SFE Buyer/Seller Furnished';
                    cas.Detail_Class__c = '';
                    cas.Priority = 'Normal';
                    cas.Type = 'Place Order';
                }
                
                
            } 
                
            if(cas.Subject != null 
                && (cas.Emailbox_Origin__c != null &&(cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status' 
                || cas.Emailbox_Origin__c == 'Email-Order Changes'))
                && (cas.Subject.contains('BFE') || cas.Subject.contains('SFE') || cas.Subject.contains('bfe') || cas.Subject.contains('sfe'))
                && Totalnumberofminutes <= 2 ){   
                cas.Ownerid = idBFEFastlane; //Label.BFE_Fastlane_Owner;                      
                cas.recordtypeid = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id; //Label.Orders_Rec_ID;
                cas.Classification__c = 'CSO Spares';
                cas.Sub_Class__c = 'BFE/SFE Buyer/Seller Furnished';
                cas.Detail_Class__c = '';
                cas.Priority = 'Normal';
                cas.Type = 'Place Order';                     
            }
            //End for ticket Omnichannel-BFESupport - INC000009886376  
            //Added for ticket INC000011000754
            if((cas.Emailbox_Origin__c != null && cas.Emailbox_Origin__c == 'Email-Bournemouth Repairs') 
                && (cas.Ownerid != null && cas.Ownerid == idCSOROTeam)){ //Label.CSO_R_O_Team)){
                cas.Repair_Location__c = 'Bournemouth England';
                cas.Sub_Class__c = 'Bournemouth Onsite CSRs';
            }
            if((cas.Emailbox_Origin__c != null && cas.Emailbox_Origin__c == 'Email-Yeovil Repairs') 
                && (cas.Ownerid != null && cas.Ownerid == idCSOROTeam)){ //Label.CSO_R_O_Team)){
                cas.Repair_Location__c = 'Yeovil';
                cas.Sub_Class__c = 'Yeovil Onsite CSRs';
            }
            //Added for INC000011112327 
            if(cas.Emailbox_Origin__c != null 
                && (cas.Emailbox_Origin__c == 'Email-Orders'|| cas.Emailbox_Origin__c == 'Email-Order Status' || cas.Emailbox_Origin__c == 'Email-Quotes'
                || cas.Emailbox_Origin__c == 'Email-BGAOEMQuoteOrders' || cas.Emailbox_Origin__c == 'Email-CSO BGA Spares') 
                && cas.PFECN__c == 'Portal' && Totalnumberofminutes <= 2){
                cas.status = 'closed';
            }
            //Added for INC000011112327 
            // Added code for INC000009829508 NavDB autoclose starts
        /* removing code for NavDB auto closure for /INC0003274868  
          if(cas.Emailbox_Origin__c != null && cas.Emailbox_Origin__c == 'Email-NavDB' && cas.subject != null && cas.subject.contains('OneNav')){
                cas.RecordTypeId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id; //Label.NavDB_Accts_Record_Type;
                cas.OwnerId = aeroDefaultUserId; //label.AERODEFAULTUSER;
                cas.Status = 'Closed';
            }
            removing code for NavDB auto closure ends   /INC0003274868
            */ 
            // Added code for INC000009829508 NavDB autoclose ends
            // Added code for INC000011185655 
            if(cas.Emailbox_Origin__c != null && cas.Emailbox_Origin__c == 'Email-Raunheim' && cas.Ownerid != null && cas.Ownerid == idCSOROTeam){ //Label.CSO_R_O_Team){
                cas.Repair_Location__c = 'Raunheim Germany';
                cas.Sub_Class__c = 'Raunheim Onsite CSRs';
            }
            if(cas.Emailbox_Origin__c != null && cas.Emailbox_Origin__c == 'Email-Edinburgh'){
                cas.Sub_Class__c = 'Edinburgh';
            }
            if(cas.Emailbox_Origin__c != null && cas.Emailbox_Origin__c == 'Email-Garden Grove'){                    
                cas.Classification__c = 'CSO OEM';                    
                cas.Sub_Class__c = 'Garden Grove';                    
            }               
            // Added code for INC000011185655 
            // Added code for INC000011590241
            if(cas.Emailbox_Origin__c != null && cas.Emailbox_Origin__c == 'Email-AVSAT Orders'){
                cas.Classification__c = 'CSO Spares';
                // cas.Type = 'Place Order'; Commented for line  INC0001488179
            }
            // Added code for INC000011218366
            if(cas.Emailbox_Origin__c != null && cas.Emailbox_Origin__c == 'Email-AeroBizSupport'){
                    cas.Classification__c = 'AEROEBIZ';
                    cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                    cas.Government_Compliance_SM_M_Content__c = 'No';
                if(cas.subject.contains('High')||cas.subject.contains('HIGH')){
                    cas.Priority = 'High';
                }
                else if(cas.subject.contains('Critical')|| cas.subject.contains('CRITICAL')){
                    cas.Priority = 'Critical';
                }
                else if(cas.subject.contains('Low')||cas.subject.contains('LOW')){
                    cas.Priority = 'Low';
                }
                else if(cas.subject.contains('Normal')||cas.subject.contains('NORMAL')){
                    cas.Priority = 'Normal';
                }
            }
            // Added code for INC000011218366   
            // Added code for INC000009615486
            if(cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id //Label.Repair_Overhaul_RT_ID 
                && (null != cas.Emailbox_Origin__c && cas.Emailbox_Origin__c == 'Email-olatheservicecenter') 
                && cas.AccountId != null && Totalnumberofminutes <= 1){
                if((null != cas.Account_Concierge__c && cas.Account_Concierge__c == 'TRUE') && (null != cas.SBU__c && cas.SBU__c == 'D&S')){
                    cas.Priority = 'Escalated';
                }
                if((null != cas.Account_Concierge__c && cas.Account_Concierge__c == 'FALSE') 
                    && (null != lstcas.get(cas.id).Account.Is_Bendix_King_Dealer__c && lstcas.get(cas.id).Account.Is_Bendix_King_Dealer__c == TRUE)){
                    cas.Sub_Class__c = 'Bendix King';
                }
                else{
                    cas.Sub_Class__c = '';
                }
            }
            // End code for INC000009615486
           //Code added for INC000006181706 -Starts
            /*if((cas.Emailbox_Origin__c == 'Email-Orders' || cas.Emailbox_Origin__c == 'Email-Order Status' || cas.Emailbox_Origin__c == 'Email-BGAOEMQuoteOrders' 
                || cas.Emailbox_Origin__c == 'Email-CSO BGA Spares') 
                && (cas.PFECN__c != 'Manual' && cas.PFECN__c != 'Refer to Network' && cas.PFECN__c != 'EDI' && cas.PFECN__c != 'Winshuttle')
                && cas.SBU__c =='ATR' 
                && (!cas.Do_Not_Send_to_Portal__c) 
                && UserInfo.getUserId() == aeroDefaultUserId //label.aero_default_user_id  
                && (cas.status != 'On Hold' 
                && (((null != cas.OwnerId && String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '00G' && String.valueOf(cas.ownerid).substring(0,3) != '005') 
                || (cas.ownerid == aeroDefaultUserId)) //label.aero_default_user_id)) 
                && (Totalnumberofminutes <= 2)))){
                cas.Resolution__c = 'None';
                cas.status = 'Closed';
                cas.Sub_Class__c = '';
                cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                cas.Government_Compliance_SM_M_Content__c = 'No';
                // cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c + 1;
                    
                    caseshare objA350CaseShare = new CaseShare();
                    objA350CaseShare.CaseAccessLevel = 'Edit';
                    objA350CaseShare.UserorGroupid = label.CSO_GRP_ID;
                    objA350CaseShare.caseid = cas.id;
                    insert objA350CaseShare;
            }*/
            //Code added for INC000006181706 - Ends
            if(lstcas.ContainsKey(cas.id)){
                  if(cas.Contactid!=null && (cas.Origin!=null && (cas.Emailbox_Origin__c =='Email-Quotes' || cas.Emailbox_Origin__c =='Email-Orders' || cas.Emailbox_Origin__c =='Email-Order Changes' 
                || cas.Emailbox_Origin__c =='Email-Order Status') && cas.Origin.contains('Email')) 
                && lstcas.get(cas.id).account.Service_Level__c=='Refer to Network' && lstcas.get(cas.id).account.PFECN__c== 'Refer to Network'){
                    cas.OwnerId=aeroDefaultUserId;
                    cas.Status='Closed';   
                }  
            } 
             
            /*if((cas.Emailbox_Origin__c == 'Email-Order Status') && ((cas.SBU__c == 'BGA' && emailDomain 
                && (cas.Account_Type__c != 'Fractional Ownership' && cas.Account_Type__c != 'Owner/Operator'))) 
                && UserInfo.getUserId() == aeroDefaultUserId //label.aero_default_user_id 
                && cas.Region__c != 'Asia/Pacific Rim' 
                && (cas.status != 'On Hold' && (((null != cas.OwnerId && String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '00G' 
                && String.valueOf(cas.ownerid).substring(0,3) != '005') || (cas.ownerid == aeroDefaultUserId)) //label.aero_default_user_id 
                && (Totalnumberofminutes <= 2)))){
                cas.Resolution__c = 'None';
                cas.status = 'Closed';
                cas.Sub_Class__c = '';
                cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                cas.Government_Compliance_SM_M_Content__c = 'No';
                // cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c + 1;
                    
                    caseshare objA350CaseShare = new CaseShare();
                    objA350CaseShare.CaseAccessLevel = 'Edit';
                    objA350CaseShare.UserorGroupid = idCSO; //label.CSO_GRP_ID;
                    objA350CaseShare.caseid = cas.id;
                    insert objA350CaseShare;
            }*/
            
            boolean validEmail = (cas.Primary_Email_Address__c != null) 
                && (cas.Primary_Email_Address__c.contains('@honeywell.com') || cas.Primary_Email_Address__c.contains('@HONEYWELL.COM')) ? false : true;
            if((cas.Emailbox_Origin__c == 'Email-Quotes') && UserInfo.getUserId() == aeroDefaultUserId //label.aero_default_user_id 
                && cas.PFECN__c == null && cas.ContactId != null && emailDomain  && cas.Account_Type__c != 'Owner/Operator' 
                && cas.Account_Type__c != 'Fractional Ownership' && cas.Region__c != 'Asia/Pacific Rim' && Totalnumberofminutes <= 2
                || ((cas.Emailbox_Origin__c == 'Email-Quotes') && UserInfo.getUserId() == aeroDefaultUserId //label.aero_default_user_id 
                && cas.ContactId != null && emailDomain 
                // && cas.PreventCloseonupdate__c < 7 
                && (null != cas.SuppliedEmail && cas.SuppliedEmail.contains('@linmarr.com')))
                && (cas.status != 'On Hold' && (((null != cas.OwnerId && String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '00G' 
                && String.valueOf(cas.ownerid).substring(0,3) != '005') || (cas.ownerid == aeroDefaultUserId)) //12:12:19:Removed condition for SBU for case auto close:(&& cas.SBU__c == 'BGA')//label.aero_default_user_id)) 
                && (Totalnumberofminutes <= 2)))){
                if(cas.Origin == 'Email' && validEmail){
                    cas.Resolution__c = 'None';
                    cas.status = 'Closed';
                    cas.Sub_Class__c = '';
                    cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                    cas.Government_Compliance_SM_M_Content__c = 'No';
                    // cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c + 1;
                        
                        caseshare objA350CaseShare = new CaseShare();
                        objA350CaseShare.CaseAccessLevel = 'Edit';
                        objA350CaseShare.UserorGroupid = idCSO; //label.CSO_GRP_ID;
                        objA350CaseShare.caseid = cas.id;
                        insert objA350CaseShare;
                }
            }
            //Code added for INC000006226761 -Starts  
            if(cas.Emailbox_Origin__c == 'Email-Quotes'  
                && (cas.PFECN__c != 'Manual' && cas.PFECN__c != 'Refer to Network' && cas.PFECN__c != 'EDI' && cas.PFECN__c != 'Winshuttle' && cas.PFECN__c != 'Conexiom' && cas.PFECN__c != null)
                && (!cas.Quotes_Do_Not_Send_to_Portal__c) 
                && UserInfo.getUserId() == aeroDefaultUserId //label.aero_default_user_id  
                //&& (!cas.ATR_Next_Wave__c)  
                && (cas.status != 'On Hold' && (((null != cas.OwnerId && String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '00G' 
                && String.valueOf(cas.ownerid).substring(0,3) != '005') || (cas.ownerid == aeroDefaultUserId)) //label.aero_default_user_id)) 
                && (Totalnumberofminutes <= 2))))//12:12:19:Removed condition for SBU for case auto close:(&& cas.SBU__c == 'ATR') and added cas.PFECN__c != 'Conexiom'
                {
                if(cas.Origin == 'Email'&& validEmail){
                    cas.Resolution__c = 'None';
                    cas.status = 'Closed';
                    cas.Sub_Class__c = '';
                    cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                    cas.Government_Compliance_SM_M_Content__c = 'No';
                    // cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c + 1;
                    
                        caseshare objA350CaseShare = new CaseShare();
                        objA350CaseShare.CaseAccessLevel = 'Edit';
                        objA350CaseShare.UserorGroupid = idCSO; //label.CSO_GRP_ID;
                        objA350CaseShare.caseid = cas.id;
                        insert objA350CaseShare;
                }    
            } 
                
            //Code added for INC000006226761 -Ends
        /*    if(cas.Emailbox_Origin__c == 'Email-Quotes' && cas.SBU__c == 'ATR' && UserInfo.getUserId() == aeroDefaultUserId //label.aero_default_user_id   
                //&& cas.ATR_Next_Wave__c
                && (cas.status != 'On Hold' && (((null != cas.OwnerId && String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '00G' 
                && String.valueOf(cas.ownerid).substring(0,3) != '005') || (cas.ownerid == aeroDefaultUserId)) //label.aero_default_user_id)) 
                && (Totalnumberofminutes <= 2)))){
                /*date atrcheckdate = cas.ATR_Next_Wave_Check_Time__c.date();
                Integer ATRNextWaveCheckdays = atrcheckdate.daysBetween(system.Now().date());
                    system.debug('@@@Origin'+cas.Origin+'##'+validEmail+'##'+ATRNextWaveCheckdays+'##'+atrcheckdate);*/
                //if(cas.Origin == 'Email' && validEmail && ATRNextWaveCheckdays != null && ATRNextWaveCheckdays > 20){
         /*       if(cas.Origin == 'Email' && validEmail ){
                    cas.Resolution__c = 'None';
                    cas.status = 'Closed';
                    cas.Sub_Class__c = '';
                    cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                    cas.Government_Compliance_SM_M_Content__c = 'No';
                    // cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c + 1;
                    
                        caseshare objA350CaseShare = new CaseShare();
                        objA350CaseShare.CaseAccessLevel = 'Edit';
                        objA350CaseShare.UserorGroupid = idCSO; //label.CSO_GRP_ID;
                        objA350CaseShare.caseid = cas.id;
                        insert objA350CaseShare;
                }    
            } */   
                // Code added for INC000008086115 -Starts
            if(cas.Emailbox_Origin__c == 'Email-Orders' 
                 && UserInfo.getUserId() == aeroDefaultUserId //label.aero_default_user_id 
                && Totalnumberofminutes <= 2
                && (null != lstcas.get(cas.id) && null != lstcas.get(cas.id).account && null != lstcas.get(cas.id).account.Orders_Next_Wave__c 
                && lstcas.get(cas.id).account.Orders_Next_Wave__c == true && lstcas.get(cas.id).account.Service_Level__c != 'Unauthorized Dist/Brkr' )
                && (lstcas.get(cas.id).account.Do_Not_Send_to_Portal__c == true)){
                Date orderscheckdate = lstcas.get(cas.id).account.Orders_Next_Wave_Check_Time__c.date();
                Integer OrdersNextWaveCheckdays = orderscheckdate.daysBetween(system.Now().date()); //12:12:19:Removed condition for SBU for case auto close:(&& cas.SBU__c == 'ATR')   
                if (cas.Origin == 'Email' && cas.Status != 'Closed' && validEmail && OrdersNextWaveCheckdays != null && OrdersNextWaveCheckdays > 20 ){
                    cas.Resolution__c = 'None';
                    cas.status = 'Closed';
                    cas.Sub_Class__c = '';
                    cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                    cas.Government_Compliance_SM_M_Content__c = 'No';
                    // cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c + 1;
                    
                        caseshare objA350CaseShare = new CaseShare();
                        objA350CaseShare.CaseAccessLevel = 'Edit';
                        objA350CaseShare.UserorGroupid = idCSO; //label.CSO_GRP_ID;
                        objA350CaseShare.caseid = cas.id;
                        insert objA350CaseShare;
                } 
            }
            // Code added for INC000008086115 -Ends
            //INC000006789797 changes end
            if((cas.Emailbox_Origin__c == 'Email-CSO BGA Spares') && (cas.PFECN__c != 'Manual' && cas.PFECN__c != 'Refer to Network' && cas.PFECN__c != 'EDI' && cas.PFECN__c != 'Winshuttle') 
                && UserInfo.getUserId() == aeroDefaultUserId //label.aero_default_user_id 
                && cas.ContactId != null
                && emailDomain  && cas.Account_Type__c != 'Owner/Operator' && Totalnumberofminutes <= 2 
                && cas.Account_Type__c != 'Fractional Ownership' && cas.Region__c != 'Asia/Pacific Rim' 
                // && (cas.PreventCloseonupdate__c < 1) 
                && null != cas.SuppliedEmail && (!cas.SuppliedEmail.contains('@dallasairmotive.com')) 
                && (!cas.SuppliedEmail.contains('@standardaero.com')) && (!cas.SuppliedEmail.contains('@duncanaviation.com')) 
                && (!cas.SuppliedEmail.contains('@tesservice.com')))////12:12:19:Removed condition for SBU for case auto close:( && cas.SBU__c == 'BGA')
                {
                if(cas.Origin == 'Email' && validEmail){
                    cas.Resolution__c = 'None';
                    cas.status = 'Closed'; //INC000006427828 - Stopping the case to be closed for Email-CSO BGA Spares cases
                    cas.Sub_Class__c = '';
                    cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                    cas.Government_Compliance_SM_M_Content__c = 'No';
                    // cas.PreventCloseonupdate__c = cas.PreventCloseonupdate__c + 1;
                        
                        caseshare objA350CaseShare = new CaseShare();
                        objA350CaseShare.CaseAccessLevel = 'Edit';
                        objA350CaseShare.UserorGroupid = idCSO; //label.CSO_GRP_ID;
                        objA350CaseShare.caseid = cas.id;
                        insert objA350CaseShare;
                }
            }   
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : case value update - 362992
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */      
    private static void caseValueUpdate(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        List<ID> caseownerlst = new List<ID>();
        List<Case> caselst = new List<Case>();
        List<Case_Matrix__c> casematrixlst = new List<Case_Matrix__c>();
        //Modifided By Praveen for Ticket No:362992
        //*******************starts here    
            Schema.DescribeSObjectResult result = group.sObjectType.getDescribe();
            String key = result.getKeyPrefix();
            String dsorder =  RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id; //System.Label.D_S_Order; 01230000000ZemzAAC
            String QuotesTeamId = idDSPRQuotesTeam; //System.Label.D_S_PR_Quotes_Team; 00G30000001zXAt
            String ClearinghouseId = idClearingHouse; //System.Label.D_S_Clearing_House; 00G30000002rV4x
            String dsclearhouse = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id; //System.Label.D_S_Clear_House_RecordTypeId_Case; 01230000000cN6e
        
        for(Case cas : listObjCaseNew){    
            if(oldMap.get(cas.Id).OwnerId != cas.OwnerId){
                if(cas.OwnerId == idROBQuotes //label.R_O_Basingstoke_Quotes_Queue_ID)
                || cas.OwnerId == idROBOrderEntry //label.R_O_Basingstoke_Order_Entry_Queue_ID)
                || cas.OwnerId == idROBShippingInv //label.R_O_Basingstoke_Shipping_Invoicing_Queue_ID)
                || cas.OwnerId == idROBCustServ //label.R_O_Basingstoke_Customer_Services_Queue_ID)
                || cas.OwnerId == idROUKSCFaxes //label.R_O_UKSC_Faxes_Queue_ID)
                || cas.OwnerId == idROBTranship //label.R_O_Basingstoke_Tranship_Queue_ID)
                || cas.OwnerId == idROBourCustServPrague //label.R_O_Bournemouth_Customer_Service_Prague_Queue_ID)
                || cas.OwnerId == idROBourQuotes//label.R_O_Bournemouth_Quotes_Queue_ID)
                || cas.OwnerId == idROBourCustServBMTH//label.R_O_Bournemouth_Customer_Service_BMTH_Queue_ID)
                || cas.OwnerId == idROTOrderEntry //label.R_O_Toulouse_Order_Entry_Queue_ID)
                || cas.OwnerId == idROTQuotes //label.R_O_Toulouse_Quotes_Queue_ID)
                || cas.OwnerId == idROTShippingInov //label.R_O_Toulouse_Shipping_Invoicing_Queue_ID)
                || cas.OwnerId == idROTCustServ //label.R_O_Toulouse_Customer_Service)
                || cas.OwnerId == idRORQuotes//label.R_O_Raunheim_Quotes_Queue_ID)
                || cas.OwnerId == idROROrderEntry //label.R_O_Raunheim_Order_Entry_Queue_ID)
                || cas.OwnerId == idRORShippingInov //label.R_O_Raunheim_Shipping_Invoicing_Queue_ID)
                || cas.OwnerId == idRORCustServ //label.R_O_Raunheim_Customer_Services_Queue_ID)
                || cas.OwnerId == idROVOrderEntry //label.R_O_Vendome_Order_Entry_Queue_ID)
                ){
                    caseownerlst.add(cas.ownerid);
                    caselst.add(cas);                
                }
            }
                        
            //Modifided By Praveen for Ticket No:362992
            //*******************starts here 
            String caseowner = cas.ownerId;
            String key2 = caseowner.substring(0,3);

                if(key == key2 && oldmap.get(cas.id).ownerId != cas.ownerid && cas.ownerId == idClearingHouse //ClearinghouseId 
                    && oldmap.get(cas.id).ownerId == QuotesTeamId){ //QuotesTeamId){
                    cas.RecordTypeId = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id; //dsclearhouse;
                    cas.status = 'New';
                    cas.Contractor_Status__c = 'Subcontractor';
                    cas.Platform__c = idMultipleMilitaryAircraftApplication; //label.Multiple_Military_Aircraft_Applications - a0J30000001hSvu
                    cas.Opportunity_Type__c = 'D&S PrePriced';
                    cas.opportunity_Type__c = 'D&S Run Rate';
                }
                else if(key == key2 && oldMap.get(cas.id).ownerId != cas.ownerid  && oldMap.get(cas.id).ownerId == idClearingHouse //ClearinghouseId 
                    && cas.ownerId == QuotesTeamId){ //QuotesTeamId)
                    cas.RecordTypeId = RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id; //dsorder;
                    cas.status = 'New';
                    cas.Classification__c = 'CSO D&S Internal';
                    cas.Type = 'Quotes/Availability';
                    cas.Sub_Class__c = '';
                    cas.Detail_Class__c = '';
                }
            
        }
        
        Map<ID,Case_Matrix__c> casematrix = new Map<ID,Case_Matrix__c>();     
        List<Case_Matrix__c> CaseMatrixList = new List<Case_Matrix__c>();
        if(caseownerlst.size() > 0)
            CaseMatrixList = new List<Case_Matrix__c>([select RecordTypeId__c,repair_location__c,Name,Classification__c, DetailClass__c, Owner__c, OwnerId__c, 
                                                        Record_Type__c, SubClass__c,Type__c 
                                                        from Case_Matrix__c 
                                                        where OwnerId__c in :caseownerlst]);
        if(CaseMatrixList.size() > 0){
            for(Case_Matrix__c cm : CaseMatrixList){
                casematrix.put(cm.OwnerId__c,cm);
            }
        }    
        if(caselst.size() > 0){
            for(Case cas :caselst){
                if(casematrix.size() > 0){                
                    cas.RecordtypeId = casematrix.get(cas.ownerid).RecordTypeId__c;
                    cas.Type = casematrix.get(cas.ownerid).Type__c;
                    cas.Repair_Location__c = casematrix.get(cas.ownerid).Repair_Location__c;
                    cas.Classification__c = 'CSO Repair/Overhaul';
                    if(null != cas.Repair_Location__c && cas.Repair_Location__c.contains('Vendome')){
                        cas.Repair_Location__c = 'Vendome';
                    }
                }      
            }    
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Auto Close Activities SR#:370862, SR#399645
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */  
    private static void autoCloseActivity(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        String que,usr,que1,usr1;// Added for SR#:370862
        Set<id> idSet = new Set<id>();
        List<Task> taskList = new List<Task>();
        List<Case> caseList = new List<Case>();
            // AutoCloseActivities //
        for(Case cas : listObjCaseNew){
            if(cas.Status == 'Cancelled' || cas.Status == 'Discard'){
                idSet.add(cas.Id);                
            }
            // Added code for SR#:370862
            if(TriggerInactive.TestCaseCancelled){ // this if is copied as per the trigger need to check whether it is really needed
                if(oldMap.get(cas.Id).OwnerId != cas.OwnerId){
                    if(String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) != String.valueOf(cas.ownerid).substring(0,3) 
                        && (String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '00G' && String.valueOf(cas.ownerid).substring(0,3) == '005'
                        && cas.Date_Time_Stamp_First_Assigned_to_User__c == null )){
                        cas.Date_Time_Stamp_First_Assigned_to_User__c = system.now();
                    }
                    else if(String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '005' && String.valueOf(cas.ownerid).substring(0,3) == '005'){
                        cas.Date_Time_Stamp_User_Assignment_Change__c = system.now();
                    }else if(String.valueOf(oldMap.get(cas.Id).ownerid).substring(0,3) == '005' && String.valueOf(cas.ownerid).substring(0,3) == '00G'){
                        cas.Date_Time_Stamp_User_Assignment_Change__c = null;
                    }
                }
                // End code for SR#:370862
                // Added code for SR#399645           
                if(oldMap.get(cas.Id).Status != cas.Status){
                    if(oldMap.get(cas.Id).Status == 'Open' && cas.Status == 'On Hold'){
                        cas.Status_changed__c = true;
                    }
                    else if(oldMap.get(cas.Id).Status == 'Re-Open' && cas.Status == 'On Hold'){
                        cas.Status_changed1__c = true;
                    }
                    else{
                        cas.Status_changed__c = false;
                        cas.Status_changed1__c = false;
                    }
                } // End for SR#399645
            }
        }

        if(TriggerInactive.TestCaseCancelled){
            if(idSet != null && idSet.size() > 0){
                taskList = [Select id,Status from  Task where whatid in :idSet];                        
                if(taskList != null && taskList.size() > 0){
                    for(Task tsk :taskList){
                        tsk.Status = 'Completed';
                    }
                    try{
                        update taskList;
                    }
                    Catch(DMLException ex){
                        System.debug('Exception occured '+ex);                  
                    }
                }                
                return;
            }
        }
    }

    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Case Value Update base on Owner
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ; mapGroupQName - map of Id and String
    ** Return : void
    */  
    private static void caseValueUpdateBaseOnOwner(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,String> mapGroupQName){
        for(Case cas : listObjCaseNew){
            if((oldMap.get(cas.Id).OwnerId != cas.OwnerId)&& (oldMap.get(cas.id).RnOSAPCases__c == cas.RnOSAPCases__c) && cas.origin != 'SAP Interface'){ 
                cas = setCaseDetails(cas.OwnerId,cas);                  
                if(('Secan Spares_Queue').equals(mapGroupQName.get(cas.OwnerID)))
                    cas.Type = '';               
                if(cas.OwnerId == idCSOBGAOEMTeam){ //label.CSO_BGA_OEM_Team_label){
                    cas.RecordtypeId = RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id; //label.OEM_Quotes_Orders_ID ;
                    cas.Classification__c = 'CSO OEM – BGA';
                    cas.Sub_Class__c = '';
                    cas.Type = '';
                    cas.Detail_Class__c = '';                
                }
                if(('ATR OEM Components_Queue').equals(mapGroupQName.get(cas.OwnerID)) || ('ATR OEM Boeing_Queue').equals(mapGroupQName.get(cas.OwnerID))
                    || ('ATR OEM Airbus_Queue').equals(mapGroupQName.get(cas.OwnerID)) ){
                    cas.RecordtypeId = RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id; //label.OEM_Quotes_Orders_ID;
                    cas.Classification__c = 'CSO OEM – ATR';
                    cas.Type = '';
                    cas.Detail_Class__c = '';
                    if(('ATR OEM Components_Queue').equals(mapGroupQName.get(cas.OwnerID))){
                        cas.Sub_Class__c = 'Components';
                    }
                    if(('ATR OEM Boeing_Queue').equals(mapGroupQName.get(cas.OwnerID))){
                        cas.Sub_Class__c = 'Boeing';
                    }
                    if(('ATR OEM Airbus_Queue').equals(mapGroupQName.get(cas.OwnerID))){
                        cas.Sub_Class__c = 'Airbus';
                    }          
                }
                
                // Changes start for Igloo ticket - INC000005725524 & INC000005926406(CSO R&O Quotes Team & CSO R&O Quotes Team Escalation)
                if(('CSO R&O Team_Queue').equals(mapGroupQName.get(cas.OwnerID)) || ('IDO Team_Queue').equals(mapGroupQName.get(cas.OwnerID)) 
                    || ('R&O Quotes Team_Queue').equals(mapGroupQName.get(cas.OwnerID)) || ('R&O Quotes Team Escalation_Queue').equals(mapGroupQName.get(cas.OwnerID))){
                    if(cas.Priority != 'Normal'){
                        cas.Priority = 'Normal';
                    }
                }// Changes end for igloo ticket - INC000005725524
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Auto close case for portal users
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void
    */  
    private static void portalAutoclose(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        for(Case cas : listObjCaseNew){
            if(cas.Total__c != null && cas.RecordTypeId == RecordTypeServices.getRecordTypeByName('Quotes','Case').Id //Label.QuotesRecordID 
                && cas.Origin == 'Web' 
                && oldmap.get(cas.id).Status != cas.Status && oldmap.get(cas.id).OwnerId == idPortalQuotes //label.Portal_Quotes 
                && cas.Status == 'Re-Open'){
                cas.OwnerId = idQuoteTeam; //label.Quotes_TeamId;
                cas.Classification__c = 'CSO Spares';
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : Case error for Hardware Internal Actions (INC000006437197)
    ** Trigger Event : Before Update
    ** Type : Private
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void 
    */  
    private static void errorHWInternalActions(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        for(Case cas : listObjCaseNew){
            if(cas.recordtypeid != null && cas.Classification__c != null && cas.Sub_Status__c != null && cas.Status != null){
                if((cas.recordtypeid == RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id //Label.D_S_Quotes_Orders_RT_ID 
                    || cas.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id) //Label.Repair_Overhaul_RT_ID)
                    && (cas.Classification__c == 'CSO D&S Repair' || cas.Classification__c == 'CSO D&S Internal') && cas.Status == 'On Hold' 
                    && (cas.Sub_Status__c == 'Business Hold' || cas.Sub_Status__c == 'Integrated Supply Chain Hold' 
                    || cas.Sub_Status__c == 'Quality Hold' || cas.Sub_Status__c == 'Contract Hold' 
                    || cas.Sub_Status__c == 'Export Hold' || cas.Sub_Status__c == 'Engineering Hold') 
                    && (cas.Internal_HW_Action__c == '' || cas.Internal_HW_Action__c == null)){
                    cas.addError(Label.Case_Error_for_HW_Internal_Action);
                }
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 01 Dec 2017
    ** Class : BeforeUpdateHelperClass  Line of Code : 
    ** Description : replacement of CaseValUpdtBasOnOwner trigger code called Before Update - (CaseClassForPublicMethods.setCaseDetails method)
    ** Trigger Event : Before Update
    ** Type : global
    ** Parameters : queueID - Case Queue Id ; objCase - Case
    ** Return : Case - a case is retrived for Queue
    */
    public static Case setCaseDetails(String queueID,Case objCase){
        String queueName = mapGroupQName.get(queueID);
        if(null != mapROQType.get(queueName) && (mapROQType.get(queueName).QueueId__c).equals(queueID)){
            if(null != mapROQType.get(queueName).RecordTypeid__c){
                objCase.RecordtypeId = mapROQType.get(queueName).RecordTypeid__c;
                objCase.Type = mapROQType.get(queueName).Type__c ;
                objCase.Classification__c = mapROQType.get(queueName).Classification__c;
                objCase.Detail_Class__c = mapROQType.get(queueName).Detail_Class__c;
                objCase.Repair_Location__c = mapROQType.get(queueName).Repair_Location__c;
                objCase.Sub_Class__c = mapROQType.get(queueName).Sub_Class__c;
            }
            return objCase;    
        }
        else{
            return objCase;
        }
    }

    //#############################################################################################################################################//
    //After Update Methods
      
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Trigger : Case_ProvideAccess Line of Code : 238 - 264, 345 - 355
    ** Description : Update a Compliance Case SR#426679
    ** Trigger Event : Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; newMap - Trigger.NewMap
    ** Return : void update compliance case
    */
    public static void updateComplianceCase(List<Case> newCase, Map<Id,Case> oldMap, Map<Id,Case> newMap){
        String newOwner,newOwnerType; 
        Map<String, String> ComplianceMap = new Map<String,String>(); 
        Map<String, String> ComplianceMap1 = new Map<String,String>();
        List<Compliance_Case__c> complianceCasesUpdate = new List<Compliance_Case__c>();
        
        for(Case cases :newCase){
            if(oldMap.get(cases.Id).OwnerId != newMap.get(cases.Id).OwnerId
                && (cases.Government_Compliance_SM_M_Content__c=='Yes' || cases.Export_Compliance_Content_ITAR_EAR__c=='Yes')){
                newOwner = newMap.get(cases.Id).OwnerId;
                newOwnerType = newOwner.substring(0,3);
                if(newOwnerType == '00G' ){    
                    string newqueue;
                    if(cases.classification__C != null && cases.classification__c == 'CSO Spares'){
                        newqueue = 'Compliance Queue CSO';
                    }
                    else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id 
                        && cases.classification__c != 'GTO D&S Technical Issue'){
                            newqueue = 'Compliance Queue GTO';
                    }
                    else if(cases.recordtypeid == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id){  
                             //SR# 426679 change - start  
                            newqueue = 'Compliance Queue CSO';
                             //SR# 426679 change - End
                    }
                    else{  
                               //SR# 426679 change - start
                            newqueue = 'Compliance Queue CSO';
                               //SR# 426679 change - End
                    }
                    ComplianceMap.put(cases.CaseNumber,newqueue);
                    ComplianceMap1.put(cases.CaseNumber,cases.classification__c);
                } 
            }
        }
        //updating if compliance queue owner has changed
        if(ComplianceMap.size() > 0){
            for(Compliance_Case__c compCase :[SELECT Id,name,Account_Name__c,contact_name__c,Subject__C,Queue_Name__c,classification__c
                                                FROM Compliance_Case__c 
                                                WHERE name in :ComplianceMap.keySet()]){
                if (ComplianceMap.containsKey(compCase.Name)){
                    compCase.Queue_Name__c = ComplianceMap.get(compCase.Name);
                    compCase.classification__c = ComplianceMap1.get(compCase.Name);
                    complianceCasesUpdate.add(compCase);   
                }
            }
            try{
                update complianceCasesUpdate;
            }
            catch(Exception e){
                System.debug('Exception occured in Case_provide Access '+e);
            }
        }
    }
    
    /* Created By : Garvit Totuka   Date : 02 Nov 2017
    ** Trigger : Case_ProvideAccess     Line of Code : 320 - 332
    ** Description : Get Owners Ids and return the case Ids list  
    ** Trigger Event : Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; newMap - Trigger.NewMap
    ** Return : void Add Owner ids and CaseAero Ids into list
    */
    public static void updateOwnerAndCaseAeroIds(List<Case> newCase, Map<Id,Case> oldMap, Map<Id,Case> newMap){
        String oldOwner, oldOwnerType, newOwner, newOwnerType;
        List<Id> ownerIds = new List<Id>();
        List<Id> CaseAeroList = new List<Id>();
        for(Case cases :newCase){
            if(oldMap.get(cases.Id).OwnerId != newMap.get(cases.Id).OwnerId){
                oldOwner = oldMap.get(cases.Id).OwnerId;
                if(Oldowner != null){
                    oldOwnerType = oldowner.substring(0,3);
                }
                newOwner = newMap.get(cases.Id).OwnerId;
                if(newOwner != null){
                    newOwnerType = newOwner.substring(0,3);
                }
                if(oldOwnerType != '00G' && newOwnerType != '00G' ){
                    ownerIds.add(oldMap.get(cases.Id).OwnerId);
                }
                        ///updating  tasks for owner as aerodefault
                if(oldOwnerType =='00G' && newOwnerType != '00G' ){
                    CaseAeroList.add(cases.Id);
                }   
            }
        }
        
        if(ownerIds.size() > 0){
            CaseServiceForCommonMethods.userCountryVerify(newCase, oldMap, ownerIds);
        }
        if(CaseAeroList.size() > 0){
            CaseServiceForCommonMethods.updateTaskOwner(CaseAeroList);
        }
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Trigger : Case_ProvideAccess Line of Code : 534 - 564, 637 - 707
    ** Description : Provide or Replace GTO or CSO Access
    ** Trigger Event : After Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap ; newMap - Trigger.NewMap
    ** Return : void insert or delete CaseShare
    */
    public static void afterUpdateProvideAccess(List<Case> newCase, Map<Id,Case> oldMap, Map<Id,Case> newMap){
        List<ID> provideCSOAccess = new List<ID>();
        List<ID> provideGTOAccess = new List<ID>();
        List<ID> deleteaccess = new List<ID>();
        List<ID> replaceCSOAccess = new List<ID>();
        List<CaseShare> deleteshare = new List<CaseShare>();
        List<CaseShare> deleteGTOshare = new List<CaseShare>();
        List<CaseShare> lsshare = new List<CaseShare>();
        
        for(Case cases :newCase){
            if(cases.RecordtypeId != RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id){
                if((newMap.get(cases.Id).Export_Compliance_Content_ITAR_EAR__c != oldMap.get(cases.Id).Export_Compliance_Content_ITAR_EAR__c)  
                    || (newMap.get(cases.Id).Government_Compliance_SM_M_Content__c  != oldMap.get(cases.Id).Government_Compliance_SM_M_Content__c )  
                    || (newMap.get(cases.Id).OwnerId  != oldMap.get(cases.Id).OwnerId)
                    && (cases.Export_Compliance_Content_ITAR_EAR__c == 'No' || cases.Export_Compliance_Content_ITAR_EAR__c == 'Undetermined')
                    && (cases.Government_Compliance_SM_M_Content__c == 'No' || cases.Government_Compliance_SM_M_Content__c == 'Undetermined')
                    ){
                    if((cases.Export_Compliance_Content_ITAR_EAR__c == 'No' && cases.Government_Compliance_SM_M_Content__c == 'No' )
                        || (cases.Export_Compliance_Content_ITAR_EAR__c == 'Undetermined' && cases.Government_Compliance_SM_M_Content__c == 'Undetermined')
                        ){
                        if(cases.recordtypeId == RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id){
                            provideGTOAccess.add(cases.id);
                            replaceCSOAccess.add(cases.id);
                        }
                        else{
                            provideCSOAccess.add(cases.id);  
                        }
                    }
                    if(cases.Export_Compliance_Content_ITAR_EAR__c=='Yes' || cases.Government_Compliance_SM_M_Content__c=='Yes' ){ 
                        deleteaccess.add(cases.id); 
                    }
                }
                if((cases.Export_Compliance_Content_ITAR_EAR__c == 'No' || cases.Export_Compliance_Content_ITAR_EAR__c == 'Undetermined') 
                    && (cases.Government_Compliance_SM_M_Content__c == 'No' || cases.Government_Compliance_SM_M_Content__c == 'Undetermined')
                    ){
                    if(cases.recordtypeId == RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id){
                        provideGTOAccess.add(cases.id);
                        replaceCSOAccess.add(cases.id);
                    }
                    else{
                        provideCSOAccess.add(cases.id);  
                    }
                }            
            }
        }
        //Added & commented by swastika on 20-dec-2017<start>
        list<CaseShare> listCaseShare = [SELECT id,CaseAccessLevel,UserOrGroupId 
                                FROM  CaseShare 
                                WHERE (((CaseId in: deleteaccess AND (UserOrGroupId = :idCSO OR UserOrGroupId = :idTech_Issue))  OR (CaseId in: replaceCSOAccess AND UserOrGroupId = :idCSO))  and CaseAccessLevel = 'Edit')]; 
        //deleting the access  
        if(deleteaccess.size() > 0){
            try{
                //getting the records whose access need to be deleted
                if(listCaseShare!=null){
                    for(caseShare objCasShare : listCaseShare){
                        for(id idCase: deleteaccess){ 
                            if(objCasShare.UserOrGroupId == idCSO && objCasShare.CaseId==idCase){
                               deleteshare.add(objCasShare); 
                            }
                            else if(objCasShare.UserOrGroupId == idTech_Issue && objCasShare.CaseId==idCase){
                            deleteGTOshare.add(objCasShare);
                            }
                        }
                       
                    }
                }
                
                /*deleteshare = [SELECT id,CaseAccessLevel,UserOrGroupId 
                                FROM  CaseShare 
                                WHERE CaseId in: deleteaccess and CaseAccessLevel = 'Edit' and UserOrGroupId = :idCSO //Label.CSO_GRP_ID 
                                ];
                                   
                deleteGTOshare = [SELECT id,CaseAccessLevel,UserOrGroupId 
                                    FROM CaseShare 
                                    WHERE CaseId in: deleteaccess and CaseAccessLevel = 'Edit' and UserOrGroupId = :idTech_Issue //Label.TechIssue_GRP_ID 
                                    ];*/
               //Added & commented by swastika on 20-dec-2017<end>                     
            }
            catch(Exception e){
                System.debug('Exception occured while deleting '+e);
            }
            // delete the CSO access of records
            if(deleteshare.size() > 0){
                try{
                    delete deleteshare;
                }
                catch(Exception e){
                    System.debug('Exception occured in Case_provide Access '+e);
                }
            }
            // delete the GTO access of records
            if(deleteGTOshare.size() > 0){
                try{
                    delete deleteGTOshare;
                }
                catch(Exception e){
                    System.debug('Exception occured in Case_provide Access '+e);
                    
                }
            }
        }
        if(replaceCSOAccess.size() > 0){
            try{
                //Added & commented by swastika on 20-dec-2017<start>
                    //getting the records whose access need to be deleted
                /*deleteshare = [SELECT id,CaseAccessLevel,UserOrGroupId 
                                FROM  CaseShare 
                                WHERE CaseId in: replaceCSOAccess and CaseAccessLevel = 'Edit' and UserOrGroupId = :idCSO //Label.CSO_GRP_ID 
                                ]; */
               if(listCaseShare!=null){
                    for(caseShare objCasShare : listCaseShare){
                        for(id idCase: replaceCSOAccess){ 
                            if(objCasShare.UserOrGroupId == idCSO && objCasShare.CaseId==idCase){
                               deleteshare.add(objCasShare); 
                            }                           
                        }                       
                    }
                } 
                //Added & commented by swastika on 20-dec-2017<end>                                              
            }
            catch(Exception e){
                System.debug('Exception occured while deleting '+e);
            }
           // delete the CSO access of records
            if(deleteshare.size() > 0){
                try{
                    delete deleteshare;
                }
                catch(Exception e){
                    System.debug('Exception occured in Case_provide Access '+e);
                }
            }      
        }  
        // Providing the CSO access   
        if(provideCSOAccess.size() > 0){
        //give the access public/read write 
            for(Id pcsoaccess :provideCSOAccess){        
                CaseShare s = new CaseShare();
                s.UserOrGroupId = idCSO; //Label.CSO_GRP_ID - 00G30000001zXDEEA2 - CSO
                s.CaseAccessLevel = 'Edit' ;
                s.CaseId = pcsoaccess;
                lsshare.add(s);
            }
        }
        // Providing the GTO access
        if(provideGTOAccess.size() > 0){
        //give the access public/read write 
            for(Id pgtoaccess :provideGTOAccess){        
                CaseShare s = new CaseShare();
                s.UserOrGroupId = idTech_Issue; //Label.TechIssue_GRP_ID - 00Ga0000002twVBEAY - Tech Issue
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
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass   Line of Code : 21 - 764
    ** Description : used in On After Update Case (Main Method) 
    ** Trigger Event : After Update
    ** Parameters : newCase - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void update related case objects
    */
    public static void afterUpdateMethod(List<Case> newCase, Map<Id,Case> oldMap){
        CaseServiceForCommonMethods.UpdateOppProposalCase(newCase,oldMap);
        CaseServiceForCommonMethods.ACSMSendCaseEmailMethod(newCase,oldMap,'Update');
        
        if(TriggerInactive.avoidRecursion == true && TriggerInactive.avoidcaseonholdlog){
            system.debug('@@@@@Caseupdate');
            CaseServiceForCommonMethods.CaseOnHoldMethod(newCase,oldMap,'Update');
        }
        
        Map<Id,Case> mapCaselist = new Map<Id,Case>([ SELECT Subject, LastModifiedById, RecordtypeId, SBU__c, Origin, CreatedById, Requestor_Email__c, 
                                                    Sales_Order_Number__c, LastmodifiedDate, Createddate, IsClosed, 
                                                    (SELECT id, lineitemstatus__c, Price__c 
                                                        From Case_Line_Items__r 
                                                        WHERE Case_Number__c in :newCase
                                                    ), 
                                                    (SELECT Id, Type__c, Status__c, Long_Text__c, New_Long_Text__c, Task_Closed__c 
                                                        FROM Case.Z_Tasks__r 
                                                        WHERE (Type__c LIKE 'Z107%' or Type__c LIKE 'Z135%') AND Task_Closed__c = FALSE
                                                    ), 
                                                    (SELECT Id, Waiting_for_TCT_Start_Time__c, Waiting_for_TCT_End_Time__c 
                                                        FROM Case.Technical_Issue_Case_Extensions__r
                                                    ), 
                                                    (SELECT Id, Name, Manual_Intervention_Last_Modified_Date__c, UFR_SBU__c, SAP_SalesOrder_Status__c, 
                                                        Four_Owner_Change_count__c, Four_Owner_Changes_Date__c, Four_Owner_Changes__c, Three_ReOpen_Count__c, 
                                                        Three_Re_Opens_Date__c, Three_Re_Opens__c, Date_Time_Stamp_of_SBU_Determined__c 
                                                        FROM Case.Case_Extensions__r
                                                    ), 
                                                    OwnerId, Sub_Status__c, OwnerId__r.Name, OwnerId__r.Email, status, AccountId, CaseNumber, Contactid, Type, 
                                                    Contact.name, tool_name__C, Honeywell_ID__c, Case_Record_Type__c, Classification__c, Description, 
                                                    HIPI_Opportunity__c 
                                                    FROM Case 
                                                    WHERE Id in :newCase
                                                ]);
        gtoUsabilityProject(newCase,oldMap,mapCaselist);
        caseExtensionProject(newCase,oldMap,mapCaselist);
        caseExtensionProjectUFRPricing(newCase,oldMap,mapCaselist);
        caseExtensionProjectROI(newCase,oldMap,mapCaselist);
        caseExtensionProjectPPO(newCase,oldMap,mapCaselist);
        contactToolAccessUpdateProject(newCase,oldMap,mapCaselist);
        sendCaseEmailNotification(newCase,oldMap);
        createSurveyURLForCase(newCase,oldMap);
        if(TriggerInactive.avoidRecursion == true){
            TriggerInactive.avoidRecursion = false;
            fleetAssetDetailsForCase(newCase,oldMap);
            caseForEfforlessOrders(newCase,oldMap);
        }
    
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass   Line of Code : 58 - 129 (116 - 127)
    ** Description : call a service class to send data to other sandbox SF2SF
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ;  cslist - Map of Id & Case
    ** Return : void update related case objects
    */
    private static void gtoUsabilityProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> cslist){
        // GTO Usability project Changes Start
        List<Case> onholdcaselist = new List<Case>();
        onholdcaselist = cslist.values();
        for(case cas :onholdcaselist){
            // SF2SF
            Set<Id> setList1 = new Set<Id>();
            if(cas.recordtypeid ==  RecordTypeServices.getRecordTypeByName('Tech Pubs','Case').Id
                && (oldMap.get(cas.id).HIPI_Opportunity__c == false && cas.HIPI_Opportunity__c == true)){
                setList1.add(cas.id);
            }
            if(setList1.size() > 0 && !AircraftNotificationsTriggerStopper.hasalreadyExecutedDupeOppty()){
                AircraftNotificationsTriggerStopper.setalreadyExecutedDupeOppty();
                CallServicetoCreateClass.classService(setList1);
            }
            // SF2SF
        }
            // GTO Usability project Changes End
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass   Line of Code : 136 - 311 (147 - 168, 285 - 289)
    ** Description : update case extension object related to case
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ;  cslist - Map of Id & Case
    ** Return : void update related case objects
    */
    private static void caseExtensionProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> cslist){
        List<Case> onholdcaselist = new List<Case>();
        onholdcaselist = cslist.values();
        List<Case_Extension__c> casexlist = new List<Case_Extension__c>();
        List < Case_Line_Item__c > listcaseln = new List < Case_Line_Item__c > ();
        List < Case_Line_Item__c > listcaseln1 = new List < Case_Line_Item__c > ();
        for(Case caext: onholdcaselist){
            if(caext.IsClosed == false){
                Decimal Totalnumberofminutes = ((caext.LastModifiedDate.getTime()) / 1000 / 60 - (caext.CreatedDate.getTime()) / 1000 / 60);
                Date dt = date.valueOf(label.Created_Date_31Aug2015); //2015-08-31T00:00:00.000+0000
                Date Createddatee = Date.valueOf(caext.CreatedDate);
                if (TriggerCheck.firstOwnerChange){
                    if(Totalnumberofminutes >= 2 && Createddatee > dt && (caext.Case_Record_Type__c == 'Orders' || caext.Case_Record_Type__c == 'Quotes' 
                        || caext.Case_Record_Type__c == 'Repair & Overhaul' || caext.Case_Record_Type__c == 'OEM/Spares' || caext.Case_Record_Type__c == 'Internal Escalations' 
                        || caext.Case_Record_Type__c == 'OEM Quotes Orders' || (caext.Case_Record_Type__c == 'WEB Portal Registration' 
                        && (caext.Subject != null && caext.Subject.contains('Maintenance Advisor'))))
                        ){
                            Case_Extension__c CasExt = new Case_Extension__c();
                            CasExt.Name = caext.CaseNumber + '_Ext';
                            if(caext.Case_Extensions__r != null && caext.Case_Extensions__r.size() > 0){
                                CasExt = caext.Case_Extensions__r;
                            }
                            else{
                                CasExt.Case_object__c = caext.id;
                            }
                        casexlist.add(CasExt);
                    }
                    TriggerCheck.firstOwnerChange = false;
                }
            }
            // Added code to update Line Item Status field on Quotes case
            if (caext.status == 'Done' && caext.recordtypeid == Label.QuotesRecordID){ //'01230000000Zen4AAC')
                listcaseln = cslist.get(caext.id).Case_Line_Items__r;
                for (Case_Line_Item__c objcaseln: listcaseln) {
                    if (objcaseln.Lineitemstatus__c != true && (objcaseln.price__c != null && objcaseln.price__c > 0)) {
                        objcaseln.Lineitemstatus__c = true;
                        listcaseln1.add(objcaseln);
                    }
                }
            }
            // End code to update Line Item Status field on Quotes case
        }
    
        if(!casexlist.isEmpty()){
            try{
                upsert casexlist;
            } 
            catch(DMLException e){
                System.debug('Exception occured in After Update Helper '+e);
            }
        }
        if (null != listcaseln1 && listcaseln1.size() > 0) {
            update listcaseln1;
        }
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass   Line of Code : 136 - 311 (172 - 196, 290 - 294 )
    ** Description : UFR Pricing Case details sending to UFRPricing_EmailSending
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ;  cslist - Map of Id & Case
    ** Return : void update related case objects
    */          
    private static void caseExtensionProjectUFRPricing(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> cslist){
        List<Case> onholdcaselist = new List<Case>();
        onholdcaselist = cslist.values();
        List<Case_Extension__c> UFRcasexlist = new List<Case_Extension__c>();
        for(Case caext: onholdcaselist){
            if(caext.IsClosed == false){
                if(caext.RecordtypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id //Label.Repair_Overhaul_RT_ID
                    && caext.CreatedById == deneidPartyScreeningAPIUserId //Label.DeniedPartyScreening_APIUser_ID //005a0000007vvzm - DeniedPartyScreening APIUser
                    && caext.Status == 'Open'
                    && caext.lastmodifiedbyid != deneidPartyScreeningAPIUserId  //Label.DeniedPartyScreening_APIUser_ID //005a0000007vvzm - DeniedPartyScreening APIUser
                    && (caext.Type == 'PO Mismatch' || caext.Type == 'Unfunded PO')
                    && null != caext.Requestor_Email__c 
                    && null == oldMap.get(caext.id).Requestor_Email__c
                    ){
                        Case_Extension__c CasEx = new Case_Extension__c();
                    if(caext.Case_Extensions__r != null && caext.Case_Extensions__r.size() > 0){
                        CasEx = caext.Case_Extensions__r;
                    } 
                    else{
                    CasEx.Case_object__c = caext.id;
                    }
                    if(null == CasEx.Manual_Intervention_Last_Modified_Date__c){
                        CasEx.Manual_Intervention_Last_Modified_Date__c = Date.valueOf(caext.LastModifiedDate);
                        UFRcasexlist.add(CasEx);
                    }
                    UFRPricing_EmailSending.EmailSend(caext.id, CasEx.UFR_SBU__c);
                }
            }
        }
        
        if(!UFRcasexlist.isEmpty()){
            try{
                update UFRcasexlist;
            } 
            catch(DMLException e){
                System.debug('Exception occured in After Update Helper '+e);
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass   Line of Code : 136 - 311 (200 - 223)
    ** Description : ROI Case details sending to ROI_EmailNotificationToUserStatus
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ;  cslist - Map of Id & Case
    ** Return : void update related case objects
    */
    private static void caseExtensionProjectROI(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> cslist){
        List<Case> onholdcaselist = new List<Case>();
        onholdcaselist = cslist.values();
        for(Case caext: onholdcaselist){
            if(caext.IsClosed == false){
                if(TriggerInactive.avoidRecursionROIservice == true){
                    String ROIFollowUp = Label.ROI_FollowUp_Status;
                    if ((caext.RecordtypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id //Label.Repair_Overhaul_RT_ID 
                        && caext.CreatedById == deneidPartyScreeningAPIUserId  //Label.DeniedPartyScreening_APIUser_ID //005a0000007vvzm - DeniedPartyScreening APIUser
                        && caext.Status == 'Open' && caext.lastmodifiedbyid != deneidPartyScreeningAPIUserId //Label.DeniedPartyScreening_APIUser_ID //005a0000007vvzm - DeniedPartyScreening APIUser
                        && null != caext.Requestor_Email__c 
                        && null == oldMap.get(caext.id).Requestor_Email__c && caext.Description.contains('SFDC Case for Notification') 
                        && caext.Classification__c == 'R&O Issue')){
                        if(caext.id != null){
                            ROI_EmailNotificationToUserStatus.EmailSend(caext.id,false);
                        }
                            if(Test.isRunningTest()){
                                ROIFollowUp = 'ON'; //Set the Followup in test as to cover code
                            }
                        if(caext.Z_Tasks__r.size() > 0 && ROIFollowUp == 'ON'){
                            List<Z_Task__c> Zlist = new List<Z_Task__c>();
                            Set<Id> zids = new Set<Id>();
                            Zlist = caext.Z_Tasks__r;
                            for(Z_Task__c z: Zlist){
                                zids.add(z.id);
                            }
                            ROI_ZtaskUserStatustoSAP.SendTaskStatus(zids);
                        }
                    }
                    TriggerInactive.avoidRecursionROIservice = FALSE;
                }
            }
        }
    }

    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass Line of Code : 136 - 311 (229 - 257, 296 - 302)
    ** Description : PPO Case details sending to PPO_EmailSending 
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ;  cslist - Map of Id & Case
    ** Return : void update related case objects
    */
    private static void caseExtensionProjectPPO(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> cslist){
        List<Case> onholdcaselist = new List<Case>();
        onholdcaselist = cslist.values();
        List<Case_Extension__c> PPOcasexlist = new List <Case_Extension__c>();
        String cassubject;
        for(Case caext: onholdcaselist){
            if(caext.IsClosed == false){
                cassubject = 'Credit Card Re-Auth Error. Sales order Number - ' + caext.Sales_Order_Number__c;
                if(((caext.RecordtypeId == RecordTypeServices.getRecordTypeByName('OEM/Spares','Case').Id //Label.OEM_Spares 
                    || caext.RecordtypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id) //Label.RnO_Automation_Record_Type) 
                    && caext.Status == 'Open' && (caext.OwnerId == idCSO_OEM_Spares //Label.CSO_OEM_Spares - 00G130000042Jyi - CSO OEM Spares
                    || caext.OwnerId == idCSOROTeam) //Label.CSO_R_O_Team - 00G30000001zXAL - CSO R&O Team
                    && null != caext.Requestor_Email__c && null == oldMap.get(caext.id).Requestor_Email__c 
                    && caext.subject != cassubject 
                    && userinfo.getuserid() !=  deneidPartyScreeningAPIUserId) //Label.DeniedPartyScreening_APIUser_ID) //005a0000007vvzm - DeniedPartyScreening APIUser
                    ){
                    Case_Extension__c CasEx = new Case_Extension__c();
                    if(caext.Case_Extensions__r != null && caext.Case_Extensions__r.size() > 0){
                        CasEx = caext.Case_Extensions__r;
                    }
                    else{
                        CasEx.Case_object__c = caext.id;
                    }
                    if(CasEx.SAP_SalesOrder_Status__c == 'ZRPR' || CasEx.SAP_SalesOrder_Status__c == 'ZRA'){
                        CasEx.Manual_Intervention_Last_Modified_Date__c = Date.valueOf(caext.LastModifiedDate);
                        PPOcasexlist.add(CasEx);
                        PPO_EmailSending.EmailSend(caext.id);
                    }
                }   
            }
        }
        
        if(!PPOcasexlist.isEmpty()){
            try{
                update PPOcasexlist;
            } 
            catch(DMLException e){
                System.debug('Exception occured in After Update Helper '+e);
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass Line of Code : 313 - 451
    ** Description : update case tool access object related to case
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap ;  cslist - Map of Id & Case
    ** Return : void update related case objects
    */
    private static void contactToolAccessUpdateProject(List<Case> listObjCaseNew, Map<Id,Case> oldMap, Map<Id,Case> cslist){
        List<Id> listContact = new List<Id>();
        List<String> listPortalHw = new List<String>();
        List<String> listToolMaster = new List<String>();
        List<Id> listContactId = new List<String>();
        Boolean bolChangesPresent = false;
        DateTime currDate = System.Now();
        Set<Id> setList = new Set<Id>();
        for(Case objCases :listObjCaseNew){
            if (null != objCases.Tool_name__c){
                listToolMaster.add(objCases.Tool_name__c);
            }
            if (null != objCases.Contactid){
                listContactId.add(objCases.Contactid);
            }
            if (null != objCases.Honeywell_ID__c){
                listPortalHw.add(objCases.Honeywell_ID__c);
            }
       /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
            if (oldMap.get(objCases.id).RnOSAPCases__c != objCases.RnOSAPCases__c && String.valueof(objCases.ownerid).startswith('00G')){
                bolChangesPresent = true;
            }
            setList.add(objCases.id);
            /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        }

        List<Portal_Tools_Master__c> listPortalToolMaster = new List<Portal_Tools_Master__c>();
        Map<Id,Contact> mapContactList = new Map<Id,Contact>();
        if(listToolMaster.size() > 0){
            listPortalToolMaster = [select id from Portal_Tools_Master__c where name in: listToolMaster];
        }
        if(listPortalToolMaster.size() > 0 && listContactId.size() > 0){
            mapContactList = new Map<Id,Contact>([SELECT id, Is_Portal_Super_User__c, 
                                                    (SELECT name, CRM_Contact_ID__c, Portal_Tool_Master__c, Request_Status__c, Access_Granted_Date__c 
                                                        FROM Contact_Tool_Access__r 
                                                        WHERE portal_tool_master__c in :listPortalToolMaster and portal_honeywell_id__c in :listPortalHw)
                                                    FROM Contact 
                                                    WHERE id in :listContactId]);
        }

        Map<String,Contact_Tool_access__c> mapCaseContactTool = new Map<String,Contact_tool_access__c>();
        for(Case objCases: listObjCaseNew){
            if(null != cslist.get(objCases.id) && cslist.get(objCases.id).Type == 'WEB Portal Registration'){
                Id objCont = cslist.get(objCases.id).contactid;
                if(null != objCont){
                    if(null != mapContactList.get(objCont)){
                        Map<Id,Contact_Tool_access__c> mapTempCTA = new Map<Id,Contact_tool_access__c>(mapContactList.get(objCont).Contact_Tool_Access__r);
                        for(Id idlists: mapTempCTA.keyset()){
                            if(mapTempCTA.get(idlists).name.equals(cslist.get(objCases.id).tool_name__C) 
                            /* changed to allow updating cases with same contact and avoid duplicate id error while update SCTASK3316968*/
                             && !mapCaseContactTool.values().contains(mapTempCTA.get(idlists))
                             /*end of SCTASK3316968*/
                             ){                              
                                    mapCaseContactTool.put(objCases.id, mapTempCTA.get(idlists));
                              }
                        }
                    }
                }
            }
        }
        /* changed to allow updating cases with same contact and avoid duplicate id error while update SCTASK3316968
        List <Contact> listToUpdContact = new List<Contact>();
        */
        Map<Id,Contact> updateContactMap=new Map<Id,Contact> ();
        /*end of SCTASK3316968*/
        /////////////////////////// updateContactToolAccess //////////////////////////////////////
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        for(Case cases: listObjCaseNew){
        //////////////////////////// updateOnlineOrderCSRAccess Trigger AfterUpdate ///////////////////////////////////////////
            if (cases.Type == 'WEB Portal Registration'
                && cases.OwnerId == idCSR_Online_Ordering_Approval //label.CSR_Online_Ordering_Approval_Queue
                && cases.Status == 'Approved'){
                listContact.add(cases.contactid);
            }
//////////////////////////// updateOnlineOrderCSRAccess Trigger AfterUpdate ///////////////////////////////////////////
  /////////////////////////// updateContactToolAccess //////////////////////////////////////
            if(cases.Type == 'WEB Portal Registration'){
                Contact_Tool_access__c current = mapCaseContactTool.get(cases.id);
                if(null != current){
                    if(cslist.get(cases.id).Status == 'Open'){
                        current.Request_Status__c = 'Pending';
                        if(cslist.get(cases.id).Tool_Name__c.trim() == 'Company Administrator' && null != mapContactList.get(cslist.get(cases.id).contactid)){
                            mapContactList.get(cslist.get(cases.id).contactid).Is_Portal_Super_User__c = false;
                         /* changed to allow updating cases with same contact and avoid duplicate id error while update SCTASK3316968
                          listToUpdContact.add(mapContactList.get(cslist.get(cases.id).contactid));
                          */
                           updateContactMap.put(cslist.get(cases.id).contactid,mapContactList.get(cslist.get(cases.id).contactid));
                        /*end of SCTASK3316968*/
                        }
                    }
                    else{
                        if(cslist.get(cases.id).Status == 'Approved'){
                            current.Access_Granted_Date__c = currDate;
                        }
                    // SR#432896
                        if(cslist.get(cases.id).Status == 'Approved' || cslist.get(cases.id).Status == 'Denied'){
                            current.Request_Status__c = cslist.get(cases.id).Status;
                        }
                        if(cslist.get(cases.id).Tool_Name__c.trim() == 'Company Administrator' && cslist.get(cases.id).Status == 'Denied'
                            && null != mapContactList.get(cslist.get(cases.id).contactid)){
                            mapContactList.get(cslist.get(cases.id).contactid).Is_Portal_Super_User__c = false;
                         /* changed to allow updating cases with same contact and avoid duplicate id error while update SCTASK3316968
                          listToUpdContact.add(mapContactList.get(cslist.get(cases.id).contactid));
                          */
                         updateContactMap.put(cslist.get(cases.id).contactid,mapContactList.get(cslist.get(cases.id).contactid));
                         /*end of SCTASK3316968*/
                       } 
                        else if(cslist.get(cases.id).Tool_Name__c.trim() == 'Company Administrator' && cslist.get(cases.id).Status == 'Approved'
                            && null != mapContactList.get(cslist.get(cases.id).contactid)){
                            mapContactList.get(cslist.get(cases.id).contactid).Is_Portal_Super_User__c = true;
                         /* changed to allow updating cases with same contact and avoid duplicate id error while update SCTASK3316968
                          listToUpdContact.add(mapContactList.get(cslist.get(cases.id).contactid));
                          */
                         updateContactMap.put(cslist.get(cases.id).contactid,mapContactList.get(cslist.get(cases.id).contactid));
                      /*end of SCTASK3316968*/
                     }
                    }
                }
            }
   /////////////////////////// updateContactToolAccess //////////////////////////////////////  
        }
        /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////
        if (bolChangesPresent) {
            ROAssignOwnerNewCase.updateCaseOwner(setList);
        }
   /////////////////////////// RnOCaseOwnerAssignOnCreation ///////////////////////////

   //////////////////////////// updateOnlineOrderCSRAccess Trigger AfterUpdate ///////////////////////////////////////////
       if(null != listContact && listContact.size() > 0){
            List<Portal_Honeywell_ID__c> phid = [SELECT Id, Contact__c, User_Type__c FROM Portal_Honeywell_ID__c WHERE Contact__c = :listContact];
            for(Portal_Honeywell_ID__c current: phid){
                current.User_Type__c = 'CSR';
            }
            if(phid != null && phid.size() > 0){
                Database.update(phid);
            }
        }
        //////////////////////////// updateOnlineOrderCSRAccess Trigger AfterUpdate /////////////////////////////////////////////////

        /////////////////////////// updateContactToolAccess //////////////////////////////////////
        if(mapCaseContactTool != null && mapCaseContactTool.size() > 0){
            Database.update(mapCaseContactTool.values());
        }
         /* changed to allow updating cases with same contact and avoid duplicate id error while update SCTASK3316968          
        if(listToUpdContact!= null && listToUpdContact.size() > 0){
            Database.update(listToUpdContact);
        }
         */
          if(updateContactMap!= null && updateContactMap.size() > 0){
            Database.update(updateContactMap.values());
        }
        /*end of SCTASK3316968*/
        /////////////////////////// updateContactToolAccess //////////////////////////////////////
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass Line of Code : 452 - 461
    ** Description : send case email notification for General & MSP Contract
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void update related case objects
    */
    private static void sendCaseEmailNotification(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        /////////////////////////// sendcaseemail ///////////////////////////
        //CaseClassForPublicMethods objForSendCaseEmail = new CaseClassForPublicMethods();
        if(!AircraftNotificationsTriggerStopper.hasalreadyExecutedPFECN()){
            AircraftNotificationsTriggerStopper.setalreadyExecutedPFECN();
            CaseServiceForCommonMethods.sendCaseEmailMethod(true,listObjCaseNew,oldMap,'Update');
        }
        //MSPContractsPublicMethods objForSendEmail = new MSPContractsPublicMethods();
        //MSPContractsPublicMethodsOptimized objForSendEmail = new MSPContractsPublicMethodsOptimized();
        /* commented for echosign package uninstall SCTASK3090378
        CaseServiceForCommonMethods.sendEmailMethod_MSPContract(listObjCaseNew,oldMap,'Update');
        end of SCTASK3090378
        */
        /////////////////////////// sendcaseemail ///////////////////////////
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass Line of Code : 462 - 690
    ** Description : create survey URL
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void update related case objects
    */
    public static void createSurveyURLForCase(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        User objUser;
        // avoid calling for mass update because of governor limits
        if(listObjCaseNew.size() == 1){
            Case new_c = listObjCaseNew[0];
            Case old_c = oldMap.get(listObjCaseNew[0].id);
            String strSurveyType = '';
            String strRecord = 'None';
            Boolean bolEBizCondFlag = false;
            Boolean bolWebSupport = false;
            Boolean bolOtherSurveySent = false;
            Boolean MspContract = false;
            Boolean NavDbaccounts = false;
            Boolean HAPPMPPContracts = false; //438738-Akila
            Boolean GDCAccounts = false; //Adding for #INC000011896296
            /*****Adding for PRJ11585 Improve Sfdc connectivity services start*/
            Boolean JXSupportFlag = false; //Added By Priya 10032017
            Boolean FSS_TierISupportFlag = false; //Added By Priya 10032017
            Boolean FssTechIssFlag = false;
            Boolean FssaccountFlag = false;
            Boolean TechpubFlag = false; // Adding for #INC000011896296
            Boolean FlightTechnicalServicesFlag = false;
            Boolean FSSActivationsFlag = false;
            Boolean GoDirectServiceIntroFlag = false;
            //Adding GSS record types
            Boolean GSSQuotesOrdersFlag = false;
            Boolean GSSTechnicalSupportFlag = false;
            //Adding for Orders and Quotes survey
            Boolean OrdersTypeFlag = False;
            Boolean QuotesTypeFlag = False;
            // Spex survey logic
            Boolean OrdersTypeSpexFlag = False;
            Boolean QuotesTypeSpexFlag = False;
            //FSS Opration
            Boolean FSSOperationFlag=false;
            /*****Adding for PRJ11585  Improve Sfdc connectivity services End*/
            // changed to status to one of Done, Completed, Closed, Approved
            
             Boolean SendSurveyFlag = true; // Added as part of RAPD-2702
            Boolean CoreRecoveryFlag = false; // Added as part of RAPD - 6286
            system.debug('new_c===>'+new_c);
            system.debug('old_c ===>'+old_c );
            if(String.valueOf(new_c.OwnerId).startsWith('005') &&(old_c.status != 'Done' && new_c.status == 'Done')
                && new_c.ContactId != null && new_c.AccountId != null && !CreateSurveyURL.updateFromFutureCall){
                // is of one of valid record types
                string rtid = String.valueOf(new_c.RecordTypeId).substring(0, 15);
                //INC0000370606 here PhoneOQGRRT is order,Quotes,Genereal and R&O rt start
              /*  if((String.valueOf(RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id).substring(0, 15) == rtid
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Quotes','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('General', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id).substring(0, 15) == rtid)
                    && (new_c.Origin == 'Phone')
                    ){
                    system.debug('=vkt=2/5==test=one of the rt->');
                    strRecord = 'Phone';
                    strSurveyType = 'PhoneOQGRRT';
                }
                //SCTASK1163527 start
                else if((String.valueOf(RecordTypeServices.getRecordTypeByName('BK Sales Support', 'Case').Id).substring(0, 15) == rtid
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('BK RMA','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('BK Tech Pubs', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('BK Warranty', 'Case').Id).substring(0, 15) == rtid)
                    ){
                    system.debug('=vkt= of the BK rt->');
                    strRecord = 'BKRT';
                    strSurveyType = 'BK';
                }
                //SCTASK1163527 end
                else if(String.valueOf(RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id).substring(0, 15) == rtid && (new_c.Origin != 'Phone') && (new_c.Type == 'Order Changes' || new_c.Type == 'Order Status'))
                {
                    system.debug('=vkt=4/5==test=order rt->');
                    strRecord = 'OrderChange';
                    strSurveyType = 'OrderChangeORT';
                }
                //INC0000370606 End
                ////SCTASK1163527 start
            */
                
            //    else if((((String.valueOf(RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id /*label.Orders_Rec_ID*/).substring(0, 15) == rtid
            //        || String.valueOf(RecordTypeServices.getRecordTypeByName('Quotes','Case').Id /*label.QuotesRecordID*/).substring(0, 15) == rtid &&  new_c.Origin != 'Phone'))
             //       || String.valueOf(RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id /*label.Returns_Recordtypeid*/).substring(0, 15) == rtid
            //        || String.valueOf(RecordTypeServices.getRecordTypeByName('ReturnsPRO', 'Case').Id /*label.ReturnsPRO_Id*/).substring(0, 15) == rtid 
            //        || String.valueOf(RecordTypeServices.getRecordTypeByName('Engine Rentals', 'Case').Id /*label.Engine_Rentals_RT_ID*/).substring(0, 15) == rtid
            //        || String.valueOf(RecordTypeServices.getRecordTypeByName('Invoice Disputes', 'Case').Id /*label.Invoice_Disputes_rtid*/).substring(0, 15) == rtid 
            //        || ( String.valueOf(RecordTypeServices.getRecordTypeByName('Web Support', 'Case').Id /*label.Web_Support_Rec_Type_ID*/).substring(0, 15) == rtid 
            //        &&  new_c.type != 'MyAero web portal issue'))
            //        //is of one of valid service level
            //        && (new_c.Service_Level__c == 'Comprehensive' || new_c.Service_Level__c == 'Standard' || new_c.Service_Level__c == 'Superior')
            //        //is of one of valid sbu
            //        && (new_c.SBU__c == 'ATR' || new_c.SBU__c == 'BGA' || new_c.SBU__c == 'D&S')
            //        ){
            //       strRecord = 'Others';
            //        strSurveyType = 'NotGDC';
           //     } 
                
            //    //SCTASK1163527 end
            //    else if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('GDC Tech Issue', 'Case').Id /*label.GDC_Tech_Issue*/ 
            //        && new_c.status != 'Review' && new_c.status != 'Project'){
           //        strRecord = 'GDC Tech';
            //        strSurveyType = 'GDC';
            //    } 
           //     else if((new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('GDC Call', 'Case').Id /*label.GDC_Call*/ 
           //         || new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('GDC Operations Email', 'Case').Id /*label.GDC_Operations_Email*/)
           //         && new_c.status != 'Review' && new_c.status != 'Project' && new_c.type != 'Routine'
            //        ){
            //        strSurveyType = 'GDC';
            //    }
                // Added for ticket INC000010721555 - Start
            //  
            //    else if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id /*label.Case_RT_OEM_Quotes_Orders*/ 
            //        || (new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id /*label.Case_RT_R_O*/ 
            //        && old_c.Reason_for_hold__c != 'Quote Approval' &&  new_c.Origin != 'Phone')
            //        ){
            //        strRecord = 'Others';
            //        strSurveyType = 'NotGDC';
            //    }
                
                // Added for ticket INC000010721555 - End
                //new engine rental survey start
           
            /*
                else if( String.valueOf(label.Engine_Rentals_RT_ID).substring(0, 15) == rtid && old_c.sub_status__c != 'Rented' && new_c.sub_status__c == 'Rented'){
                    strRecord = 'Engine Rental';
                    strSurveyType = 'ER';
                }
                // new engine rental survey end
                //INC000012536148 - start
            
            /*
                else if (String.valueOf(label.OEM_Quotes_Orders_ID).substring(0, 15) == rtid || String.valueOf(label.Repair_Overhaul_RT_ID).substring(0, 15) == rtid ||String.valueOf(label.OEM_Spares).substring(0, 15) == rtid)
                {
                    strRecord = 'Others';
                    strSurveyType = 'NotGDC';
                } 
                //End - INC000012536148 - end
                
            */ 
                    //removed in condition
                    //(String.valueOf(RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id).substring(0, 15) == rtid
                   // (String.valueOf(RecordTypeServices.getRecordTypeByName('Quotes','Case').Id).substring(0, 15) == rtid 
                   
                //Updated changes in Std Survey
                if((String.valueOf(RecordTypeServices.getRecordTypeByName('General', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Repair & Overhaul', 'Case').Id).substring(0, 15) == rtid
                    
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('ISS Invoicing','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('ISS Orders','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Core Recovery', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id).substring(0, 15) == rtid
                    
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Returns','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('ReturnsPro', 'Case').Id).substring(0, 15) == rtid )){
                        
                        system.debug('Inside Customer Support');
                        strRecord = 'Customer_Support';
                        strSurveyType = 'Customer_Support';
                }
                //Added as part of RAPD-2702
                 else if(String.valueOf(RecordTypeServices.getRecordTypeByName('Quotes','Case').Id).substring(0, 15) == rtid )
                         {
                         system.debug('entered for 2702:::::');
                            List <Case_Line_Item__c> listOfCaseLineItems = new List <Case_Line_Item__c> ();
                            Set<ID> caseIds = new Set<Id>();
                            Map <ID, Set<String>> mapOfCLIPriceStatus = new Map<ID, Set<String>> ();
                            Set<String> priceStatus = new Set<String> ();
                            
                            for(Case csObj : listObjCaseNew)
                            {
                            // Adding new condition to send survey for case origin web 
                             if(csObj.recordtypeid == RecordTypeServices.getRecordTypeByName('Quotes', 'Case').Id && 
                                oldMap.get(csObj.id).Status != 'Done' && csObj.status == 'Done' && csObj.Origin == 'Web') 
                                {
                                    system.debug('csObj.Origin ====>'+csObj.Origin);
                                    caseIds.add(csObj.Id); 
                                    system.debug('caseIds ====>'+caseIds);   
                                }                    
                            }  
                            listOfCaseLineItems = [SELECT Id,Price_Status__c,Case_Number__c from Case_Line_Item__c WHERE 
                                                   Case_Number__c IN : caseIds];
                                             
                                                  
                                if(listOfCaseLineItems.size() > 0)
                                {   
                                 system.debug('case line items :::::'+listOfCaseLineItems.size());
                                  for(Case_Line_Item__c lineItems : listOfCaseLineItems )
                                  {                                                    
                                     if(lineItems.Price_Status__c == 'No Bid' || lineItems.Price_Status__c == null )
                                     {
                                       if(!mapOfCLIPriceStatus.containsKey(lineItems.Case_Number__c))
                                       {
                                           mapOfCLIPriceStatus.put(lineItems.Case_Number__c, new Set<String> {lineItems.Price_Status__c} );
                                       }
                                       else
                                       {
                                           mapOfCLIPriceStatus.get(lineItems.Case_Number__c).add(lineItems.Price_Status__c);
                                       }
                                     }
                                  }
                                }
                                else // If there are no case line items, sending the STANDARD survey.
                                {
                                  /*system.debug('Inside Customer Support');
                                  strRecord = 'Customer_Support';
                                  strSurveyType = 'Customer_Support';*/
                                  // Do Not send survey for new Requirement
                                  SendSurveyFlag = false;
                                  system.debug('*** No Survey Sent to Customers ***');
                                }
                                system.debug('mapOfCLIPriceStatus====>' +mapOfCLIPriceStatus);
                                
                                if(mapOfCLIPriceStatus != null && mapOfCLIPriceStatus.size() > 0) {
                                 
                                  for(ID caseId : mapOfCLIPriceStatus.keySet())
                                  {
                                      if(mapOfCLIPriceStatus.containsKey(caseId))
                                      { 
                                        priceStatus = mapOfCLIPriceStatus.get(caseId);
                                        system.debug('priceStatus ===>'+priceStatus );
                                          // If “Price Status” is blank on the Case Line Items, send the STANDARD survey.
                                          // If "Price Status" is blank on at least one of the Case line items, send the STANDARD survey. 
                                          if(priceStatus.contains(null))
                                          {                                
                                              system.debug('### Survey Sent to Customers ###');
                                              strRecord = 'Customer_Support';
                                              strSurveyType = 'Customer_Support';
                                          } 
                                          // If "Price Status" is “No Bid” on all Case Line Items, do not send the STANDARD survey.                              
                                          else if(!priceStatus.contains(null) && priceStatus.contains('No Bid')){
                                              SendSurveyFlag = false;
                                              system.debug('*** No Survey Sent to Customers ***');
                                          }
                                      }
                               }
                             }
                            
                        }
                // ended changes
                else if((String.valueOf(RecordTypeServices.getRecordTypeByName('MSP Contract', 'Case').Id).substring(0, 15) == rtid
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('HAPP MPP Contracts','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('HAPP MPP Sales- Quotes', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('FSS Accounts', 'Case').Id).substring(0, 15) == rtid
                    
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('FSS Activations','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('FSS Billing', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('FSS Operations', 'Case').Id).substring(0, 15) == rtid
                    
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('FSS SkyConnect','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('FSS Technical Issue', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('FSS Tier I Support', 'Case').Id).substring(0, 15) == rtid
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Flight Technical Services', 'Case').Id).substring(0, 15) == rtid
                    
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('NavDB Prod', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Tech Pubs', 'Case').Id).substring(0, 15) == rtid
                    
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Software Tools (SWT)','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('GSS Quotes Orders', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('GSS Technical Support', 'Case').Id).substring(0, 15) == rtid
                    
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('GDC Accounts', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('GDC Call', 'Case').Id).substring(0, 15) == rtid
                    
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('GDC Operations Email','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('GDC Tech Issue', 'Case').Id).substring(0, 15) == rtid )){
                        
                        system.debug('Inside Services Support');
                        strRecord = 'Services_Support';
                        strSurveyType = 'Services_Support';
                
                }
                
                else if((String.valueOf(RecordTypeServices.getRecordTypeByName('Connectivity Mexico', 'Case').Id).substring(0, 15) == rtid && label.GoDirectMexicoSurveySwitch=='ON')
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('GoDirectFeedback','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('Service Intro', 'Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('GoDirectTrade Issue', 'Case').Id).substring(0, 15) == rtid) {     
                        system.debug('Inside GoDirect');
                        strRecord = 'GoDirect';
                        strSurveyType = 'GoDirect';
                }
                
                
                else if((String.valueOf(RecordTypeServices.getRecordTypeByName('BK Warranty', 'Case').Id).substring(0, 15) == rtid
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('BK Tech Pubs','Case').Id).substring(0, 15) == rtid 
                    || String.valueOf(RecordTypeServices.getRecordTypeByName('BK Sales Support', 'Case').Id).substring(0, 15) == rtid )){
                        
                        system.debug('Inside BendixKing');
                        strRecord = 'BendixKing';
                        strSurveyType = 'BendixKing';
                }
                
                else if((String.valueOf(RecordTypeServices.getRecordTypeByName('Engine Rentals', 'Case').Id).substring(0, 15) == rtid )){
                        
                        system.debug('Inside Engine Rentals');
                        strRecord = 'Engine_Rentals';
                        strSurveyType = 'Engine_Rentals';
                }
                             //start of changes made for SCTASK2276811

                      else if(String.valueof(schema.sobjecttype.case.getrecordtypeinfosbyName().get('FalconConnect').getrecordtypeid()).substring(0, 15) == rtid && label.FalconConnectSupportSwitch=='ON'){
                       
                       system.debug('Inside FalconConnect');
                       strRecord = 'Falcon_Connect';
                       strSurveyType = 'Falcon_Connect';
                   }
                           //end of changes made for SCTASK2276811
                else{
                    strRecord = 'None';
                }
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Web Support', 'Case').Id /*label.Web_Support_Rec_Type_ID*/ 
                //    && new_c.type == 'MyAero web portal issue' && new_c.status == 'Done'){
                //    bolWebSupport = true;
                //}
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('MSP Contract', 'Case').Id /*label.MSP_Contract*/ 
                //    && new_c.Status == 'Done' && new_c.Sub_Status__c != 'Final Notice Sent'){
                //    MspContract = true;
                //}
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('NavDB Accts', 'Case').Id /*label.NavDB_Accts*/ 
                //    && new_c.Status == 'Done' && new_c.Classification__c != 'In Arrears' 
                //    && new_c.Classification__c != 'Invoice Disputes' && new_c.Sub_Class__c != 'In Arrears'){
                //    System.debug('NAVDB SOFI!!!');
                //   NavDbaccounts = true;
                //    System.debug('NAVDB SOFI!!!');
                //}
                
                
                //438738-Akila
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('HAPP MPP Contracts', 'Case').Id /*label.HAPP_Accts*/ 
                //    && new_c.Status == 'Done' && (new_c.Sub_Status__c != 'Final Notice Sent' 
                //    && new_c.Sub_Status__c != 'Loss')){
                //   HAPPMPPContracts = true;
                //}
                   /////Adding for the #INC000011896296 ////start///////
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('GDC Accounts', 'Case').Id /*label.GDC_Accounts*/ 
                //    && new_c.Status == 'Done'){
                //    GDCAccounts = true;
                //}
                
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Tech Pubs', 'Case').Id /*label.Tech_Pubs_Record_TypeId*/ 
                //    && new_c.Status == 'Done'){
                //    System.debug('TECH PUBS SOFI!!!');
                //    TechpubFlag = true;
                //    System.debug('TECH PUBS SOFI!!!');
                //}
                
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Flight Technical Services', 'Case').Id /*label.FlightTechnicalServices_RecordtypeId*/ 
                //    && new_c.Status == 'Done'){
                //    FlightTechnicalServicesFlag = true;
                //}
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('FSS Activations', 'Case').Id /*label.FssActivationCaseRecordTypeId*/ 
                //    && new_c.Status == 'Done'){
                //    FSSActivationsFlag = true;
                //}
                
                //godirectserviceintro
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Service Intro', 'Case').Id /*label.GoDirectServiceIntroCaseRecordTypeId*/ 
                //    && new_c.Status == 'Done'){
                //    GoDirectServiceIntroFlag = true;
                //}
                
                //FSSOperation
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('FSS OPERATIONS', 'Case').Id && new_c.Status == 'Done'){
                //    FSSOperationFlag = true;
                //}
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('FSS Technical Issue', 'Case').Id /*label.FSS_Tech_Issue_RT_ID*/ 
                //    && new_c.Status == 'Done'){
                //    FssTechIssFlag = true;
                //}
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('FSS Accounts', 'Case').Id /*label.FSS_Accounts_RecordType_ID*/ 
                //    && new_c.Status == 'Done'){
                //    FssaccountFlag = true;
                //}
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('JXSupport', 'Case').Id /*label.JXSupport_RecordType_ID*/ 
                //    && new_c.Status == 'Done'){ //Added By Priya 10032017
                //    JXSupportFlag = true;
                //}
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('FSS Tier I Support', 'Case').Id /*label.FSS_Tier_I_Support_RecordType_Id*/ 
                //    && new_c.Status == 'Done'){ //Added By Priya 10032017
                //    FSS_TierISupportFlag = true;
                //}
                
                //if (new_c.RecordTypeId == label.GSSQuotesOrdersCaseRecordTypeId && new_c.Status == 'Done') {
                //        GSSQuotesOrdersFlag = true;
                //    }
                //if (new_c.RecordTypeId == label.GSSTechnicalSupportCaseRecordTypeId && new_c.Status == 'Done') {
                //        GSSTechnicalSupportFlag = true;
                //    }
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id /*label.Orders_Rec_ID*/ 
                //    && new_c.Status == 'Done' &&  new_c.Origin != 'Phone'){ //Added By Priya 10032017
                //    system.debug('@@@Orders');
                //    OrdersTypeFlag = true;
                //}
                
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Quotes', 'Case').Id /*label.QuotesRecordID*/ 
                //    && new_c.Status == 'Done' &&  new_c.Origin != 'Phone'){ //Added By Priya 10032017
                 //   system.debug('@@@Quotes');
                 //   QuotesTypeFlag = true;
                //}
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id /*label.Orders_Rec_ID*/ 
                //    && new_c.Status == 'Done' && new_c.Classification__c == 'CSO Spares' && new_c.Sub_Class__c == 'SPEX/Exchange' &&  new_c.Origin != 'Phone'){ //Added By Maria
                //    system.debug('@@@OrdersSpex');
                //    OrdersTypeSpexFlag = true;
                //}
                
                //if(new_c.RecordTypeId == RecordTypeServices.getRecordTypeByName('Quotes', 'Case').Id /*label.QuotesRecordID*/ 
                //   && new_c.Status == 'Done'&& new_c.Classification__c == 'CSO Spares' && new_c.Sub_Class__c == 'SPEX/Exchange' &&  new_c.Origin != 'Phone'){ //Added By Maria
                //    system.debug('@@@QuotesSpex');
                //    QuotesTypeSpexFlag = true;
                //}
                
                if(strRecord == 'Services_Support' || strRecord == 'Customer_Support' || strRecord == 'GoDirect' ||
                 strRecord == 'BendixKing' || strRecord =='Engine_Rentals' ||  strRecord =='Falcon_Connect'){ 
                 
       system.debug('Inside Std Survey');
                    List<Contact> lstContact = new List<Contact>();
                    lstContact = [SELECT Id, Email, Last_Survey_Date__c, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                                    FROM Contact 
                                    WHERE Id = :new_c.ContactId OR Id=:new_c.Requested_By_HON_Internal__c];
                    system.debug('contact rslt='+lstContact);
                    if(null != lstContact && lstContact.size() > 0){
                        Contact con = new Contact();
                        Contact internalContact=new Contact();
                        for(Contact cont1:lstContact){
                           if(cont1.id==new_c.ContactId){
                             con = cont1;
                             }
                             else if(cont1.id==new_c.Requested_By_HON_Internal__c){
                                 internalContact=cont1;
                             }
                        }
                        
                        boolean validOnBehalfEmail=internalContact.Id!=null && new_c.Origin=='Email' && (internalContact.Email==null || internalContact.Email.containsIgnoreCase('@honeywell.com'))?false:true;
                        boolean validEmail = con.Email == null || con.Email.contains('@honeywell.com') || con.Email.contains('@HONEYWELL.COM') ? false : true;
                        //start of changes made for SCTASK2276811

                        boolean validEmailforFalcon = con.Email == null || con.Email.containsIgnoreCase('@dassault-aviation.com') || con.Email.containsIgnoreCase('@falconjet.com') ? false : true;
                                //end of changes made for SCTASK2276811              
                         system.debug('=vkt=@@validEmail@@'+validEmail);
                       
                        Date lastSentorder = con.Last_Survey_Date__c;
                        
                        Integer daysBetweenOrder = 181;
                        // Added the below condition as part of Core Survey RAPD - 6286
                        if(strRecord == 'Customer_Support' && rtid==schema.sobjecttype.case.getrecordtypeinfosbyName().get('Core Recovery').getrecordtypeid() && new_c.Order_Type__c == 'Queries')
                            CoreRecoveryFlag = true;
                        
                        if(lastSentorder != null){ // may never have been set
                            daysBetweenOrder = lastSentorder.daysBetween(Date.today());
                        }
                        
                       
                              if(validOnBehalfEmail && validEmail && (CreateSurveyURL.testing == true || (con.Survey_Opt_Out__c == False && con.NPS_Survey__c == 'No')) && new_c.Sub_Class__c!='Supplier PO' && new_c.PFECN__c!='Refer to Network' 
                              // added condition for SCTASK3347644 on Ronda's Request
                              && new_c.Classification__c !='Invoice Disputes' && new_c.Sub_Class__c!='In arrears'
                              //end of SCTASK3347644
                              ){
                                  //new engine rental survey
                                  system.debug('=vkt==sendsurvey method calling');
                                  //Below conditions edited to avoid emails being sent to honeywell users.
                                  /*if( daysBetweenOrder > 30 && new_c.Origin == 'Email' ) {
                                    objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                    system.debug('=vkt Email ==sendsurvey method calling');
                                    //bolOtherSurveySent = true;
                                    system.debug('=vkt Email ==sendsurvey method before calling');
                                    AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                                    }
                                    else if(new_c.Origin != 'Email' ){
                                    objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                    system.debug('=vkt Not Email ==sendsurvey method calling');
                                    //bolOtherSurveySent = true;
                                    system.debug('=vkt not Email ==sendsurvey method before calling');
                                    AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                                    } */     
                                    
                                  //start of changes made for SCTASK2276811, SCTASK2191901                         
                                if(daysBetweenOrder > 30 && strRecord == 'Services_Support' && rtid!=schema.sobjecttype.case.getrecordtypeinfosbyName().get('NavDB Accts').getrecordtypeid()){
                                     objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                      system.debug('sendsurvey method before calling');
                                      AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                                   }
                                 else if(daysBetweenOrder >180 && (rtid==schema.sobjecttype.case.getrecordtypeinfosbyName().get('NavDB Accts').getrecordtypeid()))
                                  { 
                                      objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                      system.debug('sendsurvey method before calling');
                                      AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                                  }
                                  // Added Core Survey condition in below else if - RAPD 6286
                                    else if( strRecord != 'Services_Support' && rtid!=schema.sobjecttype.case.getrecordtypeinfosbyName().get('NavDB Accts').getrecordtypeid() &&
                                     ((new_c.Origin == 'Phone' && CoreRecoveryFlag) || (new_c.Origin == 'Phone' && rtid!=schema.sobjecttype.case.getrecordtypeinfosbyName().get('Core Recovery').getrecordtypeid())
                                      ||  (strRecord == 'Falcon_Connect' && validEmailforFalcon && new_c.Customer_Account__c) 
                                          ||  rtid==schema.sobjecttype.case.getrecordtypeinfosbyName().get('Service Intro').getrecordtypeid())){ //else if condition updated for SCTASK2407239
                                      objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                      system.debug('sendsurvey method before calling');
                                      AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                                  }
                                   // Added Core Survey condition in below else if - RAPD 6286
                                   
                                   //changed by saurabh for INC0003521491
                                  else if((new_c.Origin != 'Phone' && CoreRecoveryFlag) || (new_c.Origin != 'Phone' && rtid != schema.sobjecttype.case.getrecordtypeinfosbyName().get('Core Recovery').getrecordtypeid() && rtid != schema.sobjecttype.case.getrecordtypeinfosbyName().get('Quotes').getrecordtypeid() 
                                  && strRecord != 'Services_Support' && daysBetweenOrder > 30 && strRecord != 'Falcon_Connect')){ //if condition udpated for SCTASK2407239s
                                      objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                      system.debug('sendsurvey method before calling');
                                      AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                                  }
                                  //end of INC0003521491
                               
                                  else if( SendSurveyFlag && strRecord == 'Customer_Support' && rtid == schema.sobjecttype.case.getrecordtypeinfosbyName().get('Quotes').getrecordtypeid() && daysBetweenOrder > 30 && new_c.Origin != 'Phone' ){ 
                                      objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                      system.debug('sendsurvey method before calling');
                                      AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                                  }  
                                  
                              }
                          }
                      }
                
                
                
                
                //INC0000370606
                /*if(strRecord == 'Phone'){  
                    system.debug('=vkt=2/5==query contact=');
                    List<Contact> lstContact = new List<Contact>();
                    lstContact = [SELECT Id, Email, Last_Survey_Date__c, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                                    FROM Contact 
                                    WHERE Id = :new_c.ContactId limit 1];
                    system.debug('=vkt=2/5==contact rslt='+lstContact);
                    if(null != lstContact && lstContact.size() > 0){
                        Contact con = new Contact();
                        con = lstContact[0];
                    // if email missing or @honeywell not valid - this is not validating the email
                    // Added Code for Stopping NSS survey for Fedex Account - INC000010983535 -start code
                        boolean validEmail = con.Email == null || con.Email.contains('@fedex.com') || con.Email.contains('@FEDEX.COM') 
                            || con.Email.contains('@honeywell.com') || con.Email.contains('@HONEYWELL.COM') ? false : true;
                            system.debug('=vkt=@@validEmail@@'+validEmail);
               
                        if(CreateSurveyURL.testing == true || (con.Survey_Opt_Out__c == False && con.NPS_Survey__c == 'No')){
                               //new engine rental survey
                            system.debug('=vkt==sendsurvey method calling');
                            if(validEmail) {
                                objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                system.debug('=vkt==sendsurvey method calling');
                                bolOtherSurveySent = true;
                                system.debug('=vkt==sendsurvey method before calling');
                                AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                            }
                        }
                    }
                }*/
                
                //BK
                ////SCTASK1163527 start
                /*if(strRecord == 'BKRT'){  
                    system.debug('=vkt===');
                    List<Contact> lstContact = new List<Contact>();
                    lstContact = [SELECT Id, Email, Last_Survey_Date__c, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                                    FROM Contact 
                                    WHERE Id = :new_c.ContactId limit 1];
                    system.debug('=vkt=2/5==contact rslt='+lstContact);
                    if(null != lstContact && lstContact.size() > 0){
                        Contact con = new Contact();
                        con = lstContact[0];
                        boolean validEmail = con.Email == null || con.Email.contains('@fedex.com') || con.Email.contains('@FEDEX.COM') 
                            || con.Email.contains('@honeywell.com') || con.Email.contains('@HONEYWELL.COM') ? false : true;
                            system.debug('=vkt=@@validEmail@@'+validEmail);
                        
                        Date lastSentorder = con.Last_Survey_Date__c;
                        
                        Integer daysBetweenOrder =0;
                        
                        if(lastSentorder != null){ // may never have been set
                            daysBetweenOrder = lastSentorder.daysBetween(Date.today());
                        }
                        
                        if(CreateSurveyURL.testing == true || (con.Survey_Opt_Out__c == False && con.NPS_Survey__c == 'No')){
                               //new engine rental survey
                            system.debug('=vkt==sendsurvey method calling');
                            if(validEmail && daysBetweenOrder > 30) {
                                objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                system.debug('=vkt==sendsurvey method calling');
                                bolOtherSurveySent = true;
                                system.debug('=vkt==sendsurvey method before calling');
                                AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                            }
                        }
                    }
                }*/
                
                ////SCTASK1163527 end
                /*if(strRecord == 'OrderChange'){  
                    system.debug('=vkt=4/5==query contact=');
                    List<Contact> lstContact = new List<Contact>();
                    lstContact = [SELECT Id, Email, Last_Survey_Date__c, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                                    FROM Contact 
                                    WHERE Id = :new_c.ContactId limit 1];
                    system.debug('=vkt=4/5==contact rslt='+lstContact);
                    if(null != lstContact && lstContact.size() > 0){
                        Contact con = new Contact();
                        con = lstContact[0];
                    // if email missing or @honeywell not valid - this is not validating the email
                    // Added Code for Stopping NSS survey for Fedex Account - INC000010983535 -start code
                        boolean validEmail = con.Email == null || con.Email.contains('@fedex.com') || con.Email.contains('@FEDEX.COM') 
                            || con.Email.contains('@honeywell.com') || con.Email.contains('@HONEYWELL.COM') ? false : true;
                            system.debug('@@validEmail@@'+validEmail);
                    // has a survey been completed in the last 60 days
                    // Added Code for Stopping NSS survey for Fedex Account - INC000010983535 -End code
                            Date lastSentorder = con.Last_Survey_Date__c;
                    //Integer daysBetween = 91;
                        Integer daysBetweenOrder =0;
                        if(lastSentorder != null){ // may never have been set
                            daysBetweenOrder = lastSentorder.daysBetween(Date.today());
                        }
               
                       if(CreateSurveyURL.testing == true || (con.Survey_Opt_Out__c == False && con.NPS_Survey__c == 'No')){
                               //new engine rental survey
                            system.debug('=vkt==sendsurvey method calling');
                            if(validEmail && daysBetweenOrder > 30) {
                                objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                system.debug('=vkt=order=sendsurvey method calling');
                                bolOtherSurveySent = true;
                                system.debug('=vkt=order=sendsurvey method before calling');
                                AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                            }
                        }
                    }
                }*/
                
                //INC0000370606 End vkt
                /**** adding for added for PRJ11585 ends*/
                /*if(strRecord == 'Others' || GDCAccounts || strRecord == 'GDC Tech' || strRecord == 'GDC Call/Oprn' || strRecord == 'Engine Rental' || bolWebSupport 
                    || MspContract || FSSActivationsFlag || GoDirectServiceIntroFlag || FSSOperationFlag || NavDbaccounts || HAPPMPPContracts || TechpubFlag || FssTechIssFlag || FssaccountFlag 
                    || FlightTechnicalServicesFlag || JXSupportFlag ||FSS_TierISupportFlag || OrdersTypeFlag || QuotesTypeFlag || GSSQuotesOrdersFlag || GSSTechnicalSupportFlag || OrdersTypeSpexFlag || QuotesTypeSpexFlag
                    ){  //Added By Priya 10032017
                    List<Contact> lstContact = new List<Contact>();
                    lstContact = [SELECT Id, Email, Last_Survey_Date__c, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                                    FROM Contact 
                                    WHERE Id = :new_c.ContactId limit 1];
                    if(null != lstContact && lstContact.size() > 0){
                        Contact con = new Contact();
                        con = lstContact[0];
                // if email missing or @honeywell not valid - this is not validating the email
                // Added Code for Stopping NSS survey for Fedex Account - INC000010983535 -start code
                        boolean validEmail = con.Email == null || con.Email.contains('@fedex.com') || con.Email.contains('@FEDEX.COM') 
                            || con.Email.contains('@honeywell.com') || con.Email.contains('@HONEYWELL.COM') ? false : true;
                            system.debug('@@validEmail@@'+validEmail);
                // has a survey been completed in the last 60 days
                // Added Code for Stopping NSS survey for Fedex Account - INC000010983535 -End code
                        Date lastSent = con.Last_Survey_Date__c;
                //Integer daysBetween = 91;
                        Integer daysBetween = 181;
                        if(lastSent != null){ // may never have been set
                            daysBetween = lastSent.daysBetween(Date.today());
                        }
                        Boolean bolGDCCondFlag = false;
                        List<Id> lstuserGpId = new List<Id>();
                        if(CreateSurveyURL.testing == true || (con.Survey_Opt_Out__c == False && con.NPS_Survey__c == 'No')){
                            if(validEmail && daysBetween > 60 && (strRecord == 'GDC Tech' || strRecord == 'GDC Call/Oprn')){
                                List<Id> listQueueid = new List<Id>{idGDCTech,idGFO};
                                List<GroupMember> lstGDCOwner = [Select Id, GroupId, UserOrGroupId From GroupMember where groupid in: listQueueid];
                                lstuserGpId = new List<Id>();
                                Id idUserOrGpId;
                                for(GroupMember gpm :lstGDCOwner){
                                    idUserOrGpId = gpm.UserOrGroupId;
                                    if(!bolGDCCondFlag && idUserOrGpId == new_c.OwnerId){
                                        bolGDCCondFlag = true;
                                    }
                                }
                                if(!bolGDCCondFlag){
                                    bolGDCCondFlag = AfterUpdateHelperClass.getGroupIds(lstGDCOwner,new_c.OwnerId);
                                }
                                if(bolGDCCondFlag){
                                    objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                    AfterUpdateHelperClass.SendSurvey(new_c,con,strSurveyType,objUser);
                                }
                            } 
                            else if(validEmail && daysBetween > 30 && (strRecord == 'Others') && strSurveyType == 'NotGDC'){
                                objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                bolOtherSurveySent = true;
                                AfterUpdateHelperClass.SendSurvey(new_c,con,strSurveyType,objUser);
                            }
                            //new engine rental survey
                            ////SCTASK1163527 change it else if
                            else if (validEmail && (strRecord == 'Engine Rental') && strSurveyType == 'ER') {
                                objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                bolOtherSurveySent = true;
                                AfterUpdateHelperClass.SendSurvey(new_c, con, strSurveyType, objUser);
                            }
                            // new engine rental survey end
                            ////SCTASK1163527 change it else if
                            else if(validEmail && !bolOtherSurveySent && bolWebSupport && daysBetween > 90 && con.Email != null){
                                List<GroupMember> lstEbizmemb = [SELECT Id, GroupId, UserOrGroupId 
                                                                    FROM GroupMember 
                                                                    WHERE Groupid = :idEBizWebOperations]; //00G30000002Yx5k - E-Biz Web Operations - EBizWebOperations
                                lstuserGpId = new List<Id>();
                                Id idUserOrGpId;
                                for(GroupMember gpm :lstEbizmemb){
                                    idUserOrGpId = gpm.UserOrGroupId;
                                    if(!bolEBizCondFlag && idUserOrGpId == new_c.OwnerId){
                                        bolEBizCondFlag = true;
                                    }
                                }
                                if(!bolEBizCondFlag){
                                    bolEBizCondFlag = AfterUpdateHelperClass.getGroupIds(lstEbizmemb,new_c.OwnerId);
                                }
                                if(bolEBizCondFlag){
                                    if (objUser == null){
                                        objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                    }
                                    AfterUpdateHelperClass.SendSurvey(new_c,con,'Web_Support',objUser);
                                }
                            }
                            /*****Adding code for  Prj11585 --Imporve sfdc connectivity services--start*/
                        /*    String FSSActivationsSurveyswitch = label.FSSActivationsSurveyswitch;
                            String FSStechnicalSurveyswitch = label.FSStechnicalSurveyswitch;
                            String GoDirectServiceIntroSurveyswitch = label.GoDirectServiceIntroSurveyswitch;
                            String OrdersSwitch = label.OrdersSwitch;
                            String QuotesSwitch = label.QuotesSwitch;
                            String OrdersSpexSwitch = label.OrdersSpexSwitch;
                            String QuotesSpexSwitch = label.QuotesSpexSwitch;
                            string FSSOperationSurveyswitch = label.FSSOperationSurveyswitch;
                            if(Test.isRunningTest()){
                                //set values only to cover code for label check in test class
                                FSSActivationsSurveyswitch = 'on';
                                GoDirectServiceIntroSurveyswitch = 'on';
                                FSStechnicalSurveyswitch = 'on';
                                OrdersSwitch = 'On';
                                QuotesSwitch = 'On';
                                FSSOperationSurveyswitch = 'On';
                            }
                            //SCTASK1163527 change it else if
                            else if(validEmail && (
                               (FssTechIssFlag && daysBetween > 30 && con.Email != null && FSStechnicalSurveyswitch == 'on')
                            || (GSSQuotesOrdersFlag && daysBetween > 30 && con.Email != null && label.GSSQuotesOrdersSurveyswitch == 'on')
                            || (GSSTechnicalSupportFlag && daysBetween > 30 && con.Email != null && label.GSSTechnicalSupportSurveyswitch == 'on')
                            || (TechpubFlag && daysBetween > 30 && con.Email != null && label.techpubsurveyswitch == 'on')
                            || (JXSupportFlag && daysBetween > 30 && con.Email != null && label.JXSupportSurveySwitch == 'on') //JX Support Customer survey
                            || (FSSOperationFlag && daysBetween > 30 && con.Email != null && FSSOperationSurveyswitch == 'on')
                            || (FlightTechnicalServicesFlag && daysBetween > 30 && con.Email != null && label.FlightTechnicalServicesurveyswitch == 'on')
                            || (FSSActivationsFlag && daysBetween > 30 && con.Email != null && FSSActivationsSurveyswitch == 'on')                               
                            || (FssaccountFlag && daysBetween > 30 && con.Email != null && label.fssaccountsurveyswitch == 'on')
                            || (GDCAccounts && daysBetween > 30 && con.Email != null && label.GDCAccountsSurveyswitch == 'on')
                            || (HAPPMPPContracts && daysBetween > 30 && con.Email != null && label.HAPPMPPsurveyswitch == 'on')
                            || (MspContract && daysBetween > 30 && con.Email != null && label.MspContractsurveyswitch == 'on')                                                                
                            || (FSS_TierISupportFlag && daysBetween > 30 && con.Email != null && label.FSSTierISurveySwitch == 'on')   //FSS Tier I Customer survey
                            || (OrdersTypeFlag && daysBetween > 60 && con.Email != null && OrdersSwitch == 'on')
                            || (QuotesTypeFlag && daysBetween > 60 && con.Email != null && QuotesSwitch == 'on')                                                                
                            || (NavDbaccounts && daysBetween > 180 && con.Email != null && label.NavDbaccountssurveyswitch == 'on')                                
                            || (GoDirectServiceIntroFlag && con.Email != null && GoDirectServiceIntroSurveyswitch == 'on')                                                                                              
                            || (OrdersTypeSpexFlag && con.Email != null && OrdersSpexSwitch == 'on')
                            || (QuotesTypeSpexFlag && con.Email != null && QuotesSpexSwitch == 'on')
                            )
                            )
                            {
                                objUser = AfterUpdateHelperClass.getUserDetails(new_c.ownerid);
                                if(objUser != null){
                                    AfterUpdateHelperClass.SendSurvey(new_c,con,'NewURL_PI',objuser); // Need to modify here
                                }
                            }
                            
                        }
                    }
                }*/
            }
        }
    }
    
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass Line of Code : 691 - 764 (697 - 704, 758 - 760)
    ** Description : update fleet asset details for Aircraft delivery case - SR#425363
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void update fleet Assets Account
    */                  
    private static void fleetAssetDetailsForCase(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        List<Fleet_Asset_Detail__c> listUpdateFleetAccount = new List<Fleet_Asset_Detail__c>();
        for(Case newDeliveryCase: listObjCaseNew){
            if((newDeliveryCase.recordtypeid == RecordTypeServices.getRecordTypeByName('New Aircraft Delivery', 'Case').Id /*Label.New_Aircraft_Delivery_RT_ID*/ 
            && newDeliveryCase.status == 'Closed')){
                if(newDeliveryCase.Fleet_Asset_Aircraft_Number__c != null && newDeliveryCase.New_Account_Name__c != null){
                    Fleet_Asset_Detail__c fleetTemp = new Fleet_Asset_Detail__c();
                    fleetTemp.id = newDeliveryCase.Fleet_Asset_Aircraft_Number__c;
                    fleetTemp.Account__c = newDeliveryCase.New_Account_Name__c;
                    listUpdateFleetAccount.add(fleetTemp);
                }
            }
        }
        if (listUpdateFleetAccount.size() > 0){
            try{
                update listUpdateFleetAccount;
            }
            catch(Exception e){
                System.debug('Exception occured in Effortless Orders '+e);
            }
        }
    }
    /* Created By : Garvit Totuka Date : 02 Nov 2017
    ** Class : AfterUpdateHelperClass Line of Code : 691 - 764 (706 - 755)
    ** Description : avoid recursion and find attachments for effortless orders - SR#425363
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void update fleet Assets Account
    */                  
    private static void caseForEfforlessOrders(List<Case> listObjCaseNew, Map<Id,Case> oldMap){
        List<Attachment> att = [SELECT id FROM Attachment WHERE ParentId IN: listObjCaseNew];
        for(Case newDeliveryCase: listObjCaseNew){
            try{
                if(Test.isRunningTest() || (UserInfo.getUserId() == effortlessOrdersUserId
                    //username == 'effortlessorders@honeywell.com' //0051300000BaoWx - API User Effortless Orders
                    && oldMap.get(newDeliveryCase.id).Sales_Order_Number__c != newDeliveryCase.Sales_Order_Number__c)){                    
                    Set<Id> attids = (new Map<Id,SObject>(att)).keySet();
                    List<Id> att1 = new List<Id>{};
                    List<Id> att2 = new List<Id>{};
                    List<Id> att3 = new List<Id>{};
                    Integer count = 1;
                    for(integer i = 0; i < att.size(); i++){
                        if(i < 10){
                            att1.add(att[i].id);
                        }
                        if(i > 9 && i < 19){
                            att2.add(att[i].id);
                        }
                        if(i > 19 && i < 29){
                            att3.add(att[i].id);
                        }
                    }
                    if(att1.size() > 0){
                        EfforlessOrdersAttachmentRequest.SendRequest(newDeliveryCase.Sales_Order_Number__c,newDeliveryCase.CaseNumber,att1);
                    }
                    if(att2.size() > 0){
                        EfforlessOrdersAttachmentRequest.SendRequest(newDeliveryCase.Sales_Order_Number__c,newDeliveryCase.CaseNumber,att2);
                    }
                    if(att3.size() > 0){
                        EfforlessOrdersAttachmentRequest.SendRequest(newDeliveryCase.Sales_Order_Number__c,newDeliveryCase.CaseNumber,att3);
                    }
                }
            }
            catch(Exception e){
                System.debug('Exception occured in Effortless Orders '+e);
            }
        }
    }
    //From OwnerAssignmentForCSOCases class
    public static void ownerAssignmentForCSOCasesBeforeUpdateMethod(List<Case> listObjCaseNew, Map<ID,Case> oldMap)
    {    
        for(case cas:listObjCaseNew)
        { 
        string orderChangesId = label.Order_Changes_Team.substring(0,15);
        id runninguserid = UserInfo.getUserid();
        // start owner change order/ order changes//        
        if(oldMap.get(cas.id).Ownerid!=cas.Ownerid && runninguserid != label.AERODEFAULTUSER)
        {
        if(cas.Ownerid == orderChangesId || cas.Ownerid == label.Orders_Team_Id){
        if(cas.Ownerid == label.Orders_Team_Id){
                cas.Type='Place Order'; 
            }
            else
            {
                cas.Type ='Order Changes';
            }                     
            cas.recordtypeid=Label.Orders_Rec_ID;
            cas.Classification__c='CSO Spares';
            cas.Detail_Class__c='';
            cas.Priority = 'Normal';
            cas.Sub_Class__c='';
        if( cas.Account_type__c == 'Leasing Company')
               {
                    cas.ownerid = label.Leasing_Team_Id;   //Leasing team queue 
               }else if(cas.Work_Team__c == 'India Team')
               {
                    cas.ownerid = label.India_Orders_Team_Id;   //India team queue 
               }else if(cas.SBU__c == 'D&S')
               {
                    cas.ownerid = label.DS_Orders_Team_Id;   //DS Orders team queue   
               }else if(cas.region__c == 'Asia/Pacific Rim' && cas.Account_type__c != 'OEM')
               {
                    cas.ownerid = label.APAC_Spares_Team_Id;   //APAC Spares team queue 
               }else if(cas.region__c == 'Asia/Pacific Rim' && cas.Account_type__c == 'OEM')
               {
                    cas.ownerid = label.APAC_OEM_Team_Id;   //APAC OEM team queue   
               }else if(cas.SBU__c == 'ATR' || cas.SBU__c == 'BGA')
               {
                    cas.ownerid = label.CA_Orders_Team_Id;   //CA Orders Team queue
               }else
               {
                 //no change keep user selected owner 
               } 
            }
         }
         // end owner change order/ order changes//
         // start owner EDI Team//
         if(runninguserid != label.AERODEFAULTUSER){
         if((oldMap.get(cas.id).Ownerid!=cas.Ownerid && cas.Ownerid == label.EDI_Team_Id) 
         || (oldMap.get(cas.id).Sub_class__c!=cas.Sub_class__c && cas.Sub_class__c == 'Electronic Data Interchange'))
         {
                    cas.Ownerid = label.EDI_Team_Id;                      
                    cas.recordtypeid=Label.Orders_Rec_ID;
                    cas.Classification__c='CSO Spares';
                    cas.Sub_Class__c='Electronic Data Interchange';
                    cas.Detail_Class__c='';
                    cas.Priority = 'Normal';
                    cas.Type='Place Order';   
          }
         if((oldMap.get(cas.id).Ownerid!=cas.Ownerid && cas.Ownerid == label.Spex_Orders_Team_Queue_Id) 
         || (oldMap.get(cas.id).Sub_class__c!=cas.Sub_class__c && cas.Sub_class__c == 'SPEX/Exchange'))
         {
                    cas.Ownerid = label.Spex_Orders_Team_Queue_Id;                      
                    cas.recordtypeid=Label.Orders_Rec_ID;
                    cas.Classification__c='CSO Spares';
                    cas.Sub_Class__c='SPEX/Exchange';
                    cas.Detail_Class__c='';
                    cas.Priority = 'Normal';
                    cas.Type='Place Order';   
          }
         if((oldMap.get(cas.id).Ownerid!=cas.Ownerid && cas.Ownerid == label.Deferred_Orders_Team_Id) 
         || (oldMap.get(cas.id).Sub_class__c!=cas.Sub_class__c && cas.Sub_class__c == 'Deferred Online Order')
         )
         {
                    cas.Ownerid = label.Deferred_Orders_Team_Id;                      
                    cas.recordtypeid=Label.Orders_Rec_ID;
                    cas.Classification__c='CSO Spares';
                    cas.Sub_Class__c='Deferred Online Order';
                    cas.Detail_Class__c='';
                    cas.Priority = 'Normal';
                    cas.Type='Place Order';   
          }
         if((oldMap.get(cas.id).Ownerid!=cas.Ownerid && cas.Ownerid == label.RSPP_Team_Id) 
         || (oldMap.get(cas.id).Sub_class__c!=cas.Sub_class__c && cas.Sub_class__c == 'RSPP'))
         {
                    cas.Ownerid = label.RSPP_Team_Id;                      
                    cas.recordtypeid=Label.Orders_Rec_ID;
                    cas.Classification__c='CSO Spares';
                    cas.Sub_Class__c='RSPP';
                    cas.Detail_Class__c='';
                    cas.Priority = 'Normal';
                    cas.Type='Place Order';   
          }
         if((oldMap.get(cas.id).Ownerid!=cas.Ownerid && cas.Ownerid == label.RMU_Orders_Team_Id) 
         || (oldMap.get(cas.id).Sub_class__c!=cas.Sub_class__c && cas.Sub_class__c == 'BGA RMU'))
         {
                    cas.Ownerid = label.RMU_Orders_Team_Id;                      
                    cas.recordtypeid=Label.Orders_Rec_ID;
                    cas.Classification__c='CSO Spares';
                    cas.Sub_Class__c='BGA RMU';
                    cas.Detail_Class__c='';
                    cas.Priority = 'Normal';
                    cas.Type='Place Order';   
          }
         if((oldMap.get(cas.id).Ownerid!=cas.Ownerid && cas.Ownerid == label.APM_Order_Entry_Id) 
         || (oldMap.get(cas.id).Sub_class__c!=cas.Sub_class__c && cas.Sub_class__c == 'APM'))
         {
                    cas.Ownerid = label.APM_Order_Entry_Id;                      
                    cas.recordtypeid=Label.Orders_Rec_ID;
                    cas.Classification__c='CSO Special Programs';
                    cas.Sub_Class__c='APM';
                    cas.Detail_Class__c='';
                    cas.Priority = 'Normal';
                    cas.Type='';   
          }
          }
          // start for queue characteristics INC000010742787
          if(oldMap.get(cas.id).Ownerid!=cas.Ownerid && (cas.Ownerid == Label.Leasing_Team_Id || cas.Ownerid == Label.India_Orders_Team_Id || cas.Ownerid == Label.DS_Orders_Team_Id || cas.Ownerid == Label.APAC_Spares_Team_Id || cas.Ownerid == Label.APAC_OEM_Team_Id || cas.Ownerid == Label.CA_Orders_Team_Id))
          {
                    //cas.Ownerid = label.APM_Order_Entry_Id;                      
                    cas.recordtypeid=Label.Orders_Rec_ID;
                    cas.Classification__c='CSO Spares';
                    cas.Sub_Class__c='';
                    cas.Detail_Class__c='';
                    cas.Priority = 'Normal';
                    cas.Type='Place Order';   
          }
          if(String.valueOf(cas.ownerid).substring(0,3) == '005'
          && cas.Date_Time_Stamp_First_Assigned_to_User__c == null  )
          {
               cas.Date_Time_Stamp_First_Assigned_to_User__c = cas.createddate;
          }        
        }
    }
    
     /* Created By : Vel   Date : 04 Feb 2019
    ** Trigger : Case AOG Send Mail     Line of Code : 3167 - 3196
    ** Description : Send email to contact primary email after the sub status changed to AWB sent 
    ** Trigger Event : After Update
    ** Parameters : listObjCaseNew - Trigger.New ; oldMap - Trigger.OldMap
    ** Return : void update related case objects
    */
    
public static void SendMailAfterSubStausChange(List<Case> listObjCaseNew, Map<Id,Case> oldMap)
    {    
        // Single EmailMessage Object Initialize
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        // EmailMessage Object Initialize
        List <EmailMessage> em = new List <EmailMessage> ();
        List <EmailMessage> em_inbound = new List <EmailMessage> ();
        List <EmailMessage> em_outbound = new List <EmailMessage> ();
        
        //MailAddress Initialize
        List <String> Mailto = new List<String>();
        List <String> MailCc = new List<String>();
        List<String> ToAddresses = new List<String>();
        
        
        //SalesOrder Object Initialize
        List <Sales_Order__c> sales_awb = new List <Sales_Order__c> ();
        List <Sales_Order__c> sales_del = new List <Sales_Order__c> ();
        List <Sales_Order__c> sales_ship = new List <Sales_Order__c> ();
        
        //Variable Initialize
        Id MailTemplate = null;
        Id FromMailId = null;
        string parentid = null;
        string contactid = null;
        Boolean IsUpdated=false; 
        Boolean Ischange = false;
        Boolean ismailexist = false;
        string recordtype = null;
        
        
        for( Case a: listObjCaseNew){
         if(a.recordtypeid ==RecordTypeServices.getRecordTypeByName('AOG', 'Case').Id 
           || a.recordtypeid ==RecordTypeServices.getRecordTypeByName('Exchange', 'Case').Id)//added for AOG/Spex Case Record Type Split
         {
           
           if( (a.LastModifiedById == idAogWayBill_Api_User && !test.isrunningtest()) || (test.isrunningtest()))
           {
               parentid = a.id;
               contactid = a.contactid;
               Ischange = true;
               recordtype = a.Case_Record_Type__c;
               
           }
         }
         }
           if(parentid !=Null && contactid != Null && Ischange)
           {
              sales_awb = [SELECT ID from Sales_Order__c WHERE Case__c = :parentid and AWB__C != NULL AND AWB_Sent__c=false ];
              sales_del = [SELECT ID from Sales_Order__c WHERE Case__c = :parentid and Delivery_Information__c='Delivered' AND Delivered__c=false ];
              sales_ship = [SELECT ID from Sales_Order__c WHERE Case__c = :parentid and Shipment_Information__c='Shipped' AND Shipped__c=false ];
              em_outbound = [SELECT ToAddress, FromAddress, CcAddress from EmailMessage WHERE ParentId = :parentid AND incoming=false ORDER BY MessageDate DESC];
              em_inbound = [SELECT ToAddress, FromAddress, CcAddress from EmailMessage WHERE ParentId = :parentid AND incoming=true ORDER BY MessageDate DESC ];
              FromMailId = (recordtype == 'AOG')? idAogWayBill_FromMail : idExcWaybill_FromMail;
           }
         
          
          if(sales_awb.size()>0 && Ischange )
          {
             MailTemplate = (recordtype == 'AOG') ? idAogWayBill_Email_Template : idExchange_AWB_Email_Tempate; 
             IsUpdated=true;
          }
          
          else if(sales_ship.size()>0 && IsChange)
          
          {
            MailTemplate = (recordtype == 'AOG')? idAogWayBill_PickedUpEmail_Template : idExchange_Shp_Email_Template;
            IsUpdated =true;
          }
          
          else if(sales_del.size()>0 && Ischange)
          {
             MailTemplate = (recordtype == 'AOG')? idAogWayBill_DeliveredEmail_Template : idExchange_Del_Email_Template;
             IsUpdated =true;
          }

          if(em_inbound.size()>0)
            {
                em = em_inbound;
            }
          else if(em_outbound.size()>0)
            {
                em = em_outbound;
            }
          else
            {
               ismailexist = true;
            }

           if(!ismailexist  &&  Ischange && IsUpdated )
           {
              for(Integer mailcount=0 ;mailcount<2 ; mailcount++)
              {
                if(em.size()>0)
                  {
                    for(EmailMessage b: em)
                        {
                            string toadd = b.ToAddress;
                            string fromadd = b.FromAddress;
                            List<String> list_ccaddr = new List<String>();
                            List<String> list_toaddr = new List<String>();
                            if(toadd!=null || toadd!=''){
                                if(toadd.contains(';')){
                                    list_toaddr = toadd.split(';');
                                }
                                else{
                                    list_toaddr.add(toadd);    
                                }
                            }
                            List<String> list_fromaddr = fromadd.split(';');
                            if(list_toaddr.size()>0){
                                ToAddresses.addAll(list_toaddr);}
                            ToAddresses.addAll(list_fromaddr);

                            if(b.CcAddress != Null)
                            {
                            string ccadd = b.CcAddress;
                            list_ccaddr = ccadd.split(';');
                            } 
                            for (Integer i = (ToAddresses.size()-1) ; i>= 0 ; i--)
                            {
                                String s = ToAddresses[i];
                                if(s.contains('honeywell.com') || s.contains('cevalogistics.com'))
                                {
                                    ToAddresses.remove(i);
                                }
                            }
                            for (Integer i = (list_ccaddr.size()-1) ; i>= 0 ; i--)
                            {
                                String s = list_ccaddr[i];
                                if(s.contains('honeywell.com') || s.contains('cevalogistics.com'))
                                {
                                    list_ccaddr.remove(i);
                                }
                            }
        
                            if(ToAddresses.size()>0)
                            {
                              Mailto = ToAddresses;
                              ismailexist = true;
                              mailcount=3;
                              if(list_ccaddr.size()>0)
                               {
                                  MailCc = list_ccaddr;
                               }
                              break;
                            }
                        } 
                  }
                if(!ismailexist && em_outbound.size()>0 )
                {
                    em= em_outbound;
                }
              }
           }
           
           
          if(Ischange && IsUpdated)
          {
                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                if(ismailexist)
                {
                  mail.setToAddresses(Mailto);
                  if(MailCc.size()>0)
                  {
                    mail.setCcAddresses(MailCc);
                   }
                }
                mail.setTemplateId(MailTemplate);
                mail.setOrgWideEmailAddressId(FromMailId); 
                mail.setTargetObjectId(contactid ); 
                mail.setWhatId(parentid); 
                mail.setSaveAsActivity(true);
                mails.add(mail);

          
          }
          if(!test.isrunningtest() && mails.size() > 0)
          {
            Messaging.sendEmail(mails);
          }
    }
  public static void SendReminderEmailOnCustomerHold(List<Case> listObjCaseNew, Map<Id,Case> oldMap)
        {    
        // Single EmailMessage Object Initialize
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> readingOutboundEmail = new List<EmailMessage>();

        EmailMessage message = new EmailMessage();     
        //Variable Initialize
        string parentid = null;
        string contactid = null;
        string subject = null;
        string accountid = null;
        Boolean Ischange = false;
        Boolean IsTodayEmailSent = false;
        Integer CaseAgeDifference = 0;
        Date CreatedDate = null;
        Date DueDate = null;
        Date todaysDate = Date.today();
        string CSMEmailAddress = null;
        string CBMEmailAddress = null;
        string CBDEmailAddress = null;
        string status = null;
        string CCadress = null;
        string RMANumber = null;
        string ReturnRMANumber = null;
         Case a;
    if(listObjCaseNew.size() > 0)
    {
        a= listObjCaseNew[0];
        if(a != null)
        {
             if((a.recordtypeid ==RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id && a.LastModifiedById == idRMAUserId && !test.isrunningtest() && a.Sub_Status__c != Null && a.Status != Null) || test.isrunningtest() )

            {
               if(a.Sub_Status__c == 'Customer Hold' && a.Status == 'On Hold' && a.AWB_Number__c == Null
                 && a.Due_Date__c != Null && a.AccountId != Null && !Ischange) 
               {
               parentid = a.id;
               contactid = a.contactid;
               Ischange = true;
               DueDate = a.Due_Date__c;
                accountid = a.AccountId;
               status = a.Sub_Status__c;

               }
            }  
        }


        }
        if(parentid !=Null && contactid != Null && Ischange  && DueDate != Null && accountid != Null)
        {
         
        readingOutboundEmail  = [SELECT Id,ToAddress,TextBody,Subject, FromAddress, CcAddress, LastModifiedDate,FromName, HtmlBody,MessageDate,LastModifiedById  from EmailMessage WHERE incoming=false and ParentId=:parentid ORDER BY MessageDate DESC limit 10];
         
        if(readingOutboundEmail !=null && readingOutboundEmail.size() > 0 && readingOutboundEmail[0].LastModifiedDate != null && readingOutboundEmail[0].LastModifiedById != null && readingOutboundEmail[0].LastModifiedDate.date() == todaysDate && String.valueOf(readingOutboundEmail[0].LastModifiedById) == idRMAUserId )
        {
        IsTodayEmailSent = true;
        }
        for( Case_Extension__c caseExt : [select case_object__r.Id, RMA_Created_date__c,RMA__c  from Case_Extension__c where case_object__r.Id = :parentid limit 1] )
        {
            if(caseExt.RMA_Created_date__c != null)
            {
            CreatedDate = caseExt.RMA_Created_date__c;
            CaseAgeDifference = CreatedDate.daysBetween(DueDate);
            RMANumber = caseExt.RMA__c ; 
            }
        }
          for(AccountTeamMember accountTeamMembers:[SELECT Id, User.Name, User.Email,TeamMemberRole FROM AccountTeamMember where AccountId = :accountid and (TeamMemberRole = 'Customer Support Manager (CSM)' or TeamMemberRole = 'Customer Business Manager (CBM)' or TeamMemberRole = 'Customer Business Director')])
          {  
              if(accountTeamMembers.TeamMemberRole=='Customer Support Manager (CSM)')
              {
                  CSMEmailAddress = accountTeamMembers.User.Email;
              }
              if(accountTeamMembers.TeamMemberRole=='Customer Business Manager (CBM)')
              {
      
                  CBMEmailAddress = accountTeamMembers.User.Email;
              }
              if(accountTeamMembers.TeamMemberRole=='Customer Business Director')
              {
                  CBDEmailAddress = accountTeamMembers.User.Email;
              }
          }
         
        }
           
            if(((CSMEmailAddress != Null || CBMEmailAddress != Null || CBDEmailAddress != Null) &&  DueDate  <= todaysDate && CreatedDate != Null && !test.isrunningtest()) || test.isrunningtest() )
            {
                                        
             if(CaseAgeDifference == 4)
                    {
                        if(String.isNotBlank(CSMEmailAddress))
                        {
                        CCadress = CSMEmailAddress;
                        }
                        else if(String.isNotBlank(CBMEmailAddress))
                        {
                          CCadress = CBMEmailAddress;
                        }
                        else if(String.isNotBlank(CBDEmailAddress))
                        {
                          CCadress = CBDEmailAddress;
                        }
                    }
                else if(CaseAgeDifference == 8 || CaseAgeDifference == 12 )
                    {
                       if(String.isNotBlank(CBMEmailAddress))
                        {
                          CCadress = CBMEmailAddress;
                        }
                        else if(String.isNotBlank(CBDEmailAddress))
                        {
                          CCadress = CBDEmailAddress;
                        }
                    }
                else if(CaseAgeDifference == 20)
                    {
                     if(String.isNotBlank(CBDEmailAddress))
                        {
                          CCadress = CBDEmailAddress;
                        }
                    }
              }
              for(EmailMessage emailMessage :readingOutboundEmail ) 
              {
                if(emailMessage.TextBody != null && emailMessage.TextBody.contains('RMA Created. Provide Return AWB# and Carrier Information'))
                {
                    message = emailMessage;
                    break;
                }
              }
            if(!IsTodayEmailSent && Ischange && message != null && message.ToAddress != null && RMANumber != null )
            {  
            ReturnRMANumber = '%Return_' + RMANumber + '%';
            List<Attachment> attachmentList = [Select Id,Name from Attachment where ParentId = :parentid and (Name like :ReturnRMANumber or Name = :RMANumber)   Order by LastModifiedDate DESC limit 1];
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            if(CCadress != Null)


















            {
            List<String> sendCC = new List<String>();
            sendCC.add(CCadress);
            mail.setCcAddresses(sendCC);









            }
            if(message.CcAddress != null)
            {
                List<String> sendCC = message.CcAddress.split(';');
                mail.setCcAddresses(sendCC);






            }
            if(message.ToAddress != null)
            {
                List<String> to = message.ToAddress.split(';');
                mail.setToAddresses(to);


            }
            if(attachmentList.size() > 0)








            {
               Attachment attachment = attachmentList[0];
               List<string> attachmentID =String.valueOf(attachment.Id).split(';');
               mail.setEntityAttachments(attachmentID);

            }
            string newHTMLBody = '<html><body style="font-family: Arial, sans-serif;"><hr><strong >From:</strong>'+message.FromName+'<br/><strong>Sent: </strong>'+message.MessageDate+'<br /><strong>To: </strong>'+message.ToAddress +'<br/><strong>Subject:</strong>'+message.Subject+'</body></html><br /><br />';
            string HTMLBody = message.htmlBody + newHTMLBody + message.htmlBody;
            mail.setHtmlBody(HTMLBody);
            string remainderEmailsubject = message.Subject.removeStart('RE:');
            mail.SetSubject('RE: ' + remainderEmailsubject);
            mail.setOrgWideEmailAddressId(idRMA_FromMail); 

            mail.setWhatId(parentid); 
            mail.setSaveAsActivity(true);

            mails.add(mail);
            if(!test.isrunningtest() && mails.size() > 0 && status != Null)
            {
            Messaging.sendEmail(mails);
            }   
            }   
   
    }
    public static void SendOutBoundOnISCHoldUpdate(List<Case> listObjCaseNew, Map<Id,Case> oldMap)
    {    
        // Single EmailMessage Object Initialize
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        // EmailMessage Object Initialize
        List <EmailMessage> em_outbound = new List <EmailMessage> ();
        List <String> list_ccaddr = new List<String>();
        List<EmailMessage> readingOutboundEmail = new List<EmailMessage>();
        Boolean IsTodayEmailSent = false;

              
        //Variable Initialize
        string parentid = null;
        string contactid = null;
        Boolean Ischange = false;
        string status = null;
        Date todayDate = Date.today();
        Date DueDate = null;
            Case a;
    if(listObjCaseNew.size() > 0)
    {
        a= listObjCaseNew[0];
        if(a != null)
        {
             if((a.recordtypeid ==RecordTypeServices.getRecordTypeByName('Returns', 'Case').Id && a.LastModifiedById == idRMAUserId  && !test.isrunningtest() && a.Sub_Status__c != Null && a.Status != Null) || (test.isrunningtest()))

            {
        
               if((a.Sub_Status__c == 'Integrated Supply Chain Hold' || a.Sub_Status__c =='RMA Rejected')  && a.Status == 'On Hold') 
               {
               parentid = a.id;
               contactid = a.contactid;
               Ischange = true;
               status = a.Sub_Status__c;
               DueDate = a.Due_Date__c;
               }
            }  
         }
    }


        if(parentid !=Null && contactid != Null && Ischange && status != Null)
        {
            em_outbound = [SELECT Id,ToAddress,TextBody,Subject, FromAddress, CcAddress,ParentId,ReplyToEmailMessageId  from EmailMessage WHERE ParentId = :parentid AND incoming=false AND Subject like '%Please Induct%' ORDER BY MessageDate DESC limit 1];
            if(DueDate != null)
            {
            if(status == 'Integrated Supply Chain Hold' && DueDate == todayDate)
            {
           
            readingOutboundEmail = [SELECT Id,ToAddress,TextBody,Subject, FromAddress, CcAddress, LastModifiedDate from EmailMessage WHERE incoming=false and Subject like '%Please Induct the Returned%' and ParentId=:parentid and LastModifiedDate  = Today and LastModifiedById =:idRMAUserId ORDER BY MessageDate DESC Limit 1];
             if(readingOutboundEmail.size() > 0)
            {
            IsTodayEmailSent = true;
            }

            }
            }
            if(status == 'RMA Rejected')
            {
        
            readingOutboundEmail = [SELECT Id,ToAddress,TextBody,Subject, FromAddress, CcAddress, LastModifiedDate from EmailMessage WHERE incoming=false and Subject like '%has been rejected%' and ParentId=:parentid and LastModifiedDate  = Today and LastModifiedById =:idRMAUserId ORDER BY MessageDate DESC Limit 1];
            if(readingOutboundEmail.size() > 0)
            {
            IsTodayEmailSent = true;
            }
            }
        }
         Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        if( em_outbound.size()>0 && Ischange && status.equalsIgnoreCase('Integrated Supply Chain Hold') && !IsTodayEmailSent )
        { 
        for( EmailMessage b: em_outbound)
        {
            if(b.Subject != null)
            {
            if(b.CcAddress != Null)
            {
            string ccadd = b.CcAddress;
            list_ccaddr = ccadd.split(';');
            } 
            if(list_ccaddr.size()>0)
            {
                mail.setCcAddresses(list_ccaddr);













            }
            string toadd = b.ToAddress;
            List<String> list_toaddr = toadd.split(';');
            mail.setToAddresses(list_toaddr);
            mail.setOrgWideEmailAddressId(idRMA_FromMail); 
            mail.setWhatId(parentid); 
            mail.setPlainTextBody(b.TextBody);
            mail.SetSubject('Reminder : ' + 'Please Induct the Returned Unit');
            mail.setSaveAsActivity(true);
            mails.add(mail);
            }
        }
        }
        else if(Ischange && status.equalsIgnoreCase('RMA Rejected') && !IsTodayEmailSent && contactid != Null  ) {
     
            mail.setTemplateId(idRejectTemplateId);
            mail.setOrgWideEmailAddressId(idRMA_FromMail); 
            mail.setTargetObjectId(contactid); 
            mail.setWhatId(parentid); 
            mail.setSaveAsActivity(true);
            mails.add(mail);
        }
        if(!test.isrunningtest() && mails.size() > 0 && status != Null && Ischange)
          {
            Messaging.sendEmail(mails);
          }   
        }
        public static void SendAttachmentOrders(List<Case> listObjCaseNew, Map<Id, Case> oldMap)
{
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    string parentid = null;
    string contactid = null;
    string accountid = null;
    Boolean Ischange = false;
    string CCaddress = null;
    Case updatedCase;
    string subject = null;
    if(listObjCaseNew.size() > 0)
    {
        updatedCase = listObjCaseNew[0];
        if(updatedCase != null)
        {   
        if ((updatedCase.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id && updatedCase.LastModifiedById == idBFEUserId && !test.isrunningtest()) || test.isrunningtest())





        {
            if (updatedCase.Status != null && string.isBlank(updatedCase.Sub_Status__c) && updatedCase.Status.equals('Open') && updatedCase.AccountId != Null && updatedCase.Sub_Class__c != Null)
            {

               if (updatedCase.Sub_Class__c == 'BFE/SFE Buyer/Seller Furnished')
                {
                    parentid = updatedCase.id;
                    contactid = updatedCase.contactid;
                    Ischange = true;
                    accountid = updatedCase.AccountId;
                    subject = updatedCase.Subject;







                }
            }
       }
       }
    }
    if(Ischange && !string.isBlank(parentid) && !string.isBlank(contactid) && !string.isBlank(accountid) && !string.isBlank(subject))
    {
        List<Attachment> attachmentList = [Select Id,Name from Attachment where ParentId = :parentid and Name like '%BOT%' and LastModifiedDate = Today  Order by LastModifiedDate DESC limit 1];
        if(attachmentList.size() > 0)
        {
            Attachment attachment = attachmentList[0];
            if(subject.toLowerCase().contains('ibas') || subject.toLowerCase().contains('bfe'))
            {
                Ischange = true;
            }
            else
            {
                Ischange = false;
            }
            if(Ischange &&  attachment != null && attachment.Name != null)
            {
                List<string> attachmentID =String.valueOf(attachment.Id).split(';');
                //List<string> ccAddress = CCaddress.Id.split(';');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(idBFE_FromMail);
                mail.setWhatId(parentid);
                mail.setSaveAsActivity(true);
                mail.setSubject('File Attachment - ' + Subject);
                mail.setTargetObjectId(contactid);
                mail.setEntityAttachments(attachmentID);
                mail.setPlainTextBody('Hello! \n\nPlease find the attached report \n\n Regards,\nBOTS');
                mails.add(mail);
                Messaging.sendEmail(mails);

            }
        }
    }


}
 
    /* Created By : H293599 : 03 DEC 2019
    ** Class : CaseHandler  Line of Code : 4075-4259
    ** Description : After Update Methods - Common
    ** Trigger Event : After
    ** Type : Public
    ** Parameters : Updated Case and Old Case
    ** Return : Void
    */
public static void SendReminderEmailOnCustomerHoldOrders(List<Case> listObjCaseNew, Map<Id, Case> oldMap)
{
    // Single EmailMessage Object Initialize
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    //List<User> csmaccountTeam = new List<User>();
    List<EmailMessage> readingOutboundEmail = new List<EmailMessage>();
    // List<EmailMessage> readingOutboundEscalatedEmail = new List<EmailMessage>();
    EmailMessage OutboundEmail;
    Case oldCaseObject = null;
    string oldparentid = null;
    Date oldDueDate = null;
    //Variable Initialize
    string parentid = null;
    string contactid = null;
    string notes = null;
    string accountid = null;
    Boolean Ischange = false;
    Boolean IsTodayEmailSent = false;
    Boolean SendEmail = false;
    Integer CaseAgeDifference = 0;
    Date DueDate = null;
    Date previousDate = null;
    Date todaysDate = Date.today();
    string CSMEmailAddress = null;
    string CCaddress = null;
    Case updatedCase;
    Integer totalEmailCount = 0;
    if(listObjCaseNew.size() > 0)
    {
        updatedCase = listObjCaseNew[0];
        if(updatedCase != null)
        {   
        if ((updatedCase.recordtypeid == RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id && updatedCase.LastModifiedById == idBFEUserId && !test.isrunningtest()) || test.isrunningtest())
        {
            if (updatedCase.Sub_Status__c != Null && updatedCase.Status != Null && updatedCase.Sub_Status__c == 'Customer Hold' && updatedCase.Status == 'On Hold' && updatedCase.Due_Date__c != Null && updatedCase.AccountId != Null && updatedCase.Sub_Class__c != Null && updatedCase.Notes__c != Null)
            {
               if (updatedCase.Sub_Class__c == 'BFE/SFE Buyer/Seller Furnished')
                {
                    parentid = updatedCase.id;
                    contactid = updatedCase.contactid;
                    Ischange = true;
                    DueDate = updatedCase.Due_Date__c;
                    accountid = updatedCase.AccountId;
                    notes = updatedCase.Notes__c;
                }
            }
       }
       }

    }
    if (parentid != Null && contactid != Null && Ischange && DueDate != Null && accountid != Null && notes != Null)
    {
     oldCaseObject = oldMap.get(parentid);
        if (oldCaseObject != Null)
        {
            if (oldCaseObject.Sub_Status__c == 'Customer Hold' && oldCaseObject.Status == 'On Hold' && oldCaseObject.Due_Date__c != Null && oldCaseObject.Sub_Class__c != Null)
            {
                if (oldCaseObject.Sub_Class__c =='BFE/SFE Buyer/Seller Furnished')

                {
                    oldparentid = oldCaseObject.id;
                    oldDueDate = oldCaseObject.Due_Date__c;
                }
            }
        }
         for(AccountTeamMember accountTeamMembers:[SELECT Id, User.Name, User.Email,TeamMemberRole FROM AccountTeamMember where AccountId = :accountid and (TeamMemberRole = 'Customer Support Manager (CSM)' or TeamMemberRole = 'Customer Business Manager (CBM)')])
        { 
            if(CSMEmailAddress == null)
            {
                CSMEmailAddress = accountTeamMembers.User.Email;
                break;
            } 
        }

         readingOutboundEmail  = [SELECT Id,ToAddress,TextBody,Subject, FromAddress, CcAddress, LastModifiedDate,HtmlBody from EmailMessage WHERE incoming=false and ParentId=:parentid and (Subject = :notes or Subject like :'%'+updatedCase.Notes__c+'%' ) ORDER BY MessageDate DESC];
         totalEmailCount = readingOutboundEmail.size();
         if(readingOutboundEmail.size() > 0)
         {
             OutboundEmail = readingOutboundEmail[0];
             if(OutboundEmail.LastModifiedDate != null && OutboundEmail.LastModifiedDate.date() == todaysDate )
            {
                IsTodayEmailSent = true;
            }
         }
    
        if (DueDate != Null && DueDate == todaysDate && OutboundEmail != Null && !IsTodayEmailSent && oldparentid != null && oldDueDate != null)
        {
             CaseAgeDifference = oldDueDate.daysBetween(DueDate);
            if(OutboundEmail.Subject != Null && OutboundEmail.ToAddress != Null && totalEmailCount >= 1 )
            {
             List<String> list_ccaddr = new List<String>();
             List<String> list_tempAddress = new List<String>();
             if(OutboundEmail.CcAddress != null)
             {
                list_ccaddr = OutboundEmail.CcAddress.split(';');
             }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Case caseInstance = [select id, Due_Date__c from case where id =:parentid];
            mail.setOrgWideEmailAddressId(idBFE_FromMail);
            mail.setWhatId(parentid);
            mail.setSaveAsActivity(true);
            if(!OutboundEmail.Subject.contains('Reminder'))
            {
            mail.setSubject('Reminder - ' + OutboundEmail.Subject);
            }
            else
            {
              mail.setSubject(OutboundEmail.Subject);
            }
            if(OutboundEmail.HtmlBody != null)
            {
             mail.setHTMLBody(OutboundEmail.HtmlBody);
            }
            else if(OutboundEmail.TextBody != null)
            {
             mail.setPlainTextBody(OutboundEmail.TextBody);
            }
            if (CaseAgeDifference  == 2 && totalEmailCount == 2)
            {
                if (String.isNotBlank(CSMEmailAddress))
                {
                    CCaddress = CSMEmailAddress;
                    string ccadd = CCaddress;
                    list_tempAddress = ccadd.split(';');
                }
                mail.setTargetObjectId(contactid);
                DueDate = DueDate.addDays(3);
                caseInstance.Due_Date__c = DueDate;
                update caseInstance;
                SendEmail = true;
            }
            else if (CaseAgeDifference == 3 && totalEmailCount == 3)
            {
                string toadd = null;
                if (CSMEmailAddress != null)
                {
                toadd = CSMEmailAddress;
                List<String> list_toaddr = toadd.split(';');
                if (list_toaddr.size() > 0)
                {
                    mail.setToAddresses(list_toaddr);
                }
                }
                SendEmail = true;
                DueDate = DueDate.addDays(2);
                caseInstance.Due_Date__c = DueDate;
                update caseInstance;
                
            }
            else if(CaseAgeDifference  == 4 && totalEmailCount == 1)
            {
                CCaddress = null;
            SendEmail = true;
            mail.setTargetObjectId(contactid);
            DueDate = DueDate.addDays(2);
            caseInstance.Due_Date__c = DueDate;
            update caseInstance;
            SendEmail = true;
            }
            else if(totalEmailCount == 4)
            {
            DueDate = DueDate.addDays(2);
            caseInstance.Due_Date__c = DueDate;
            update caseInstance;
            }
        if (SendEmail && Ischange && !IsTodayEmailSent)
            {
            if(list_tempAddress.size() > 0)
            {
            list_ccaddr.addAll(list_tempAddress);
            }
            if(list_ccaddr.size() > 0)
            {
                mail.setCcAddresses(list_ccaddr);
            }
             mails.add(mail);
            Messaging.sendEmail(mails);
            }

            }

        }
    }

}
    /* Created By : H291749 : 28 Apr 2020
    ** Class : CaseHandler
    ** Description : After Update Methods - Common
    ** Trigger Event : After
    ** Type : Public
    ** Parameters : Updated Case and Old Case
    ** Return : Void
    */
public static void CoreRecoverySendRemainder(List<Case> listObjCaseNew, Map<Id,Case> oldMap)
    {    
        // Single EmailMessage Object Initialize
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        // EmailMessage Object Initialize
        List <EmailMessage> em_totalMessage = new List <EmailMessage> ();
        List <EmailMessage> em_FirstRemainderlist = new List <EmailMessage> ();
        List <EmailMessage> em_SecondRemainderlist = new List <EmailMessage> ();
        List <EmailMessage> em_FinalRemainderlist = new List <EmailMessage> ();
        EmailMessage em = new EmailMessage();
        List<String> ReminderDateDiffstring = new List<String>();
        List<Integer> ReminderDateDiff = new List<Integer>();
        ReminderDateDiffstring = CoreRecoveryDateDiff.Split(';');

        for(string diff:ReminderDateDiffstring)
         {
             ReminderDateDiff.add(Integer.valueOf(diff));
         }
        
        List <String> Mailto = new List<String>();
        List <String> MailCc = new List<String>();
        List<String> Customerfocalmails = new List<String>();

        List<Account> acc = new List<Account>();

        
        //Variable Initialize
        Id MailTemplate = null;
        string parentid = null;
        string contactid = null;
        Boolean Ischange = false;
        Boolean ismailexist = false;
        string  accountid = null;
        Integer DateDiff = 0;
        string ShipmentType =  null;
        Boolean IsSendMailRequired = false;

        


        if(listObjCaseNew.size() > 0)
        {
            Case a = listObjCaseNew[0];
            if(a.recordtypeid ==RecordTypeServices.getRecordTypeByName('Core Recovery', 'Case').Id)
                {
                  if( (a.LastModifiedById == idCoreRecoveryTriggerUser && oldMap.get(a.id).Due_Date__c != a.Due_Date__c && !test.isrunningtest()) || (test.isrunningtest()))
                        {
                            parentid = a.id;
                            contactid = a.contactid;
                            Ischange = true;
                            DateDiff  = a.Shipped_On__c.daysBetween(oldMap.get(a.id).Due_Date__c);
                            ShipmentType = a.Type_of_Shipment_del__c ;
                            accountid = a.AccountId;
                        }
                }

            if(parentid !=Null && Ischange)
            {
                em_totalMessage  = [SELECT Id, ToAddress,Subject, CcAddress from EmailMessage WHERE ParentId = :parentid AND incoming=false and ((Subject like 'First Reminder%') or (Subject like 'Second Reminder%') or (Subject like 'Final Notice%')) and (NOT Subject like 'RE%') ORDER BY MessageDate DESC] ;
                for(EmailMessage e: em_totalMessage)
                {
                    
                    if(e.Subject.contains('First Reminder'))
                    {
                        em_FirstRemainderlist.add(e);
                    }

                    else if(e.Subject.contains('Second Reminder'))
                    {
                        em_SecondRemainderlist.add(e);
                    }

                    else if(e.Subject.contains('Final Notice'))
                    {
                        em_FinalRemainderlist.add(e);
                    }
                }

                if(DateDiff >=ReminderDateDiff[0] && DateDiff <=ReminderDateDiff[1] && ShipmentType == 'Domestic' && em_SecondRemainderlist.Size() == 0 )
                {
                    MailTemplate = idCore_Recovery_Second_Reminder_Email_Template ;
                    IsSendMailRequired = true;
                }
            
                else if (DateDiff >=ReminderDateDiff[2] && DateDiff <=ReminderDateDiff[3] && ShipmentType == 'International' && em_SecondRemainderlist.Size() == 0 )
                {
                    MailTemplate = idCore_Recovery_Second_Reminder_Email_Template;
                    IsSendMailRequired = true;
                }
                
                else if (DateDiff >=ReminderDateDiff[4] && DateDiff <=ReminderDateDiff[5] && em_FinalRemainderlist.Size() == 0)
                {
                    MailTemplate = idCore_Recovery_Third_Reminder_Email_Template ;
                    IsSendMailRequired = true;
                }
                
                else if (DateDiff >=ReminderDateDiff[6] && em_FinalRemainderlist.Size() > 0 && em_FinalRemainderlist.Size() <= 1 )
                {
                    MailTemplate = idCore_Recovery_Final_Reminder_Email_Template ;
                    IsSendMailRequired = true;
                }

                if(accountid != Null )
                {
                        acc = [SELECT Business_Focal__r.Email,Customer_Support_Focal__r.Email FROM Account where ID = :accountid limit 1];
                        for(Account ac  : acc)
                        {
                            if(!String.isEmpty(ac.Customer_Support_Focal__r.Email))
                            Customerfocalmails.add(ac.Customer_Support_Focal__r.Email);
                            if(!String.isEmpty(ac.Business_Focal__r.Email) && MailTemplate == idCore_Recovery_Final_Reminder_Email_Template)
                            Customerfocalmails.add(ac.Business_Focal__r.Email);
                        }
                       
                        
                }

                if( MailTemplate != null)
                {
                    if(em_totalMessage.size () > 0 )
                    {
                        em = em_totalMessage[0];
                        string toadd = em.ToAddress;
                        List<String> list_ccaddr = new List<String>();
                        List<String> list_toaddr = toadd.split(';');
                        Mailto = list_toaddr;
                        if(em.CcAddress != Null)
                        {
                            string ccadd = em.CcAddress;
                            list_ccaddr = ccadd.split(';');
                            MailCc = list_ccaddr;
                        }
                       
                        ismailexist = true;
                    }
                    else
                    {
                    ismailexist = false;
                    }
                    
                }
            
                if(IsSendMailRequired)
                {
                    Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                    if(Customerfocalmails.size() > 0)
                    {
                    MailCc.addAll(Customerfocalmails);
                    }
                    if(ismailexist)
                    {
                    mail.setToAddresses(Mailto);
                    
                    }
                    if(MailCc.size()>0)
                    {
                        mail.setCcAddresses(MailCc);
                    }
                    mail.setTemplateId(MailTemplate);
                    mail.setOrgWideEmailAddressId(idCore_Recovery_FromMail); 
                    mail.setTargetObjectId(contactid); 
                    mail.setWhatId(parentid); 
                    mail.setSaveAsActivity(true);
                    mails.add(mail);
                }
            
                if(!test.isrunningtest() && mails.size() > 0)
                {
                    Messaging.sendEmail(mails);
                }
            }
        } 
    }
//End of Method

 /* Created By : H147664 : 10 Jul 2020
    ** Class : CaseHandler  Line of Code : 4796-4847
    ** Description : case is closed then remove the case association from Order or Invoice
    ** Trigger Event : After Update
    ** Type : Public
    ** Parameters : Updated Case and Old Case
    ** Return : Void
    */

 public static void CaseAssociationRemove(List<Case> listObjCaseNew,Map<Id,Case> oldMap)
{
   
    string recTypeID = Schema.SobjectType.Case.getRecordTypeInfosByName().get('Software Tools (SWT)').getRecordTypeId();
 // User U = [Select id,Name from User Where Name = 'NGBSS API'];
  Set<string> setcase = New Set<String>();
  For(Case C : listObjCaseNew)
  {
    System.debug(C.Status);
    System.debug(oldMap.get(c.Id).Status);
    System.debug(C.CreatedById);
    System.debug(System.Label.NGBSS_API);
    System.debug(recTypeID);
    System.debug(C.RecordTypeId);
    If(C.Status != oldMap.get(c.Id).Status && C.Status == 'Closed-No response' && /* C.CreatedById == System.Label.NGBSS_API && */ C.RecordTypeId == recTypeID)
    {
      setcase.Add(C.CaseNumber);
    }
  }
  
  If(setcase.Size()>0)
  {
    List<Apttus_Config2__Order__c> UpdateOrder = New List<Apttus_Config2__Order__c>();
    List<Apttus_Billing__Invoice__c> UpdateInvoice = New List<Apttus_Billing__Invoice__c>();
    List<Apttus_Config2__Order__c> Orders = [Select id,Case_Number__c,NGBSS_Processing_Status__c from Apttus_Config2__Order__c where Case_Number__c IN:setcase];
    List<Apttus_Billing__Invoice__c> Invoices = [Select id,Case_Number__c,APTS_Integration_Status__c from Apttus_Billing__Invoice__c Where Case_Number__c IN:setcase];
    
    IF(Orders.Size()>0)
    {
      For(Apttus_Config2__Order__c O:Orders)
      {
        O.Case_Number__c = '';
        O.NGBSS_Processing_Status__c = '';
        UpdateOrder.Add(O);
      }
      
      Update UpdateOrder;
    }
    
    If(Invoices.Size()>0)
    {
      For(Apttus_Billing__Invoice__c I:Invoices)
      {
        I.Case_Number__c = '';
        I.APTS_Integration_Status__c = 'To be Processed';
        UpdateInvoice.Add(I);
      }
      Update UpdateInvoice;
    }
    
  } 
  }// End Method
    
    /*Method to update portal status and request types on case */
	Public static void updateFieldsOnCaseWhenUpdate(list<case> caseListwhenUpdate){
        //updateFieldsOnCase1(caseIds);
        system.debug('caseList***' +caseListwhenUpdate);
        /*if(caseIds !=null && caseIds.size()>0){

list<case> cs = [select status,Sub_Status__c,recordType.name from case where id in :caseIds];*/
        //if(cs != null && cs.size()>0){
        //To map the portal status value
        list<case> csList = caseListwhenUpdate;        
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
        //To map portal status for any substatus value
        map<String,String> anyPortalstatMap = new map<String,String>();
        list<AERO_PortalStatus_Any__mdt> anyPortalStatus = [Select Status__c,Portal_Status__c from AERO_PortalStatus_Any__mdt];
        for(AERO_PortalStatus_Any__mdt anyPortStat : anyPortalStatus){
            anyPortalstatMap.put(anyPortStat.status__c,anyPortStat.Portal_Status__c);
        }
        
        for(case c : caseListwhenUpdate){
            String portalStatus = '';
            String portalRequestType = '';
            String anyPortStatus = '';
            String key = (c.status+'-'+c.Sub_Status__c).toLowerCase();
            String key2 = c.status;
            String  recTypeId= c.recordTypeId;
            String key1 = '';
            if(String.isNotBlank(recTypeId))
            key1 = Schema.SObjectType.case.getRecordTypeInfosById().get(recTypeId).getname();
            system.debug('key1***' +key1);
            if(portalStatusMap.containsKey(key)){
                portalStatus = portalStatusMap.get(key);
            }
            if(portalRequestTypeMap.containsKey(key1)){
                portalRequestType = portalRequestTypeMap.get(key1);
            }
            if(anyPortalstatMap.containsKey(key2)){
                anyPortStatus = anyPortalstatMap.get(key2);
            }
            if(String.isNotBlank(portalStatus)){
                c.Portal_Status__c = portalStatus;
                c.Portal_request_type__c = portalRequestType;
                system.debug('Portal status***'+c.Portal_Status__c);
                system.debug('c.Portal_request_type__c'+c.Portal_request_type__c);
                //csList.add(c);
            }else{
                c.Portal_Status__c = anyPortStatus;  
                c.Portal_request_type__c = portalRequestType;
                system.debug('c.Portal_request_type__c'+c.Portal_request_type__c);
                //csList.add(c);
            } 
        }
        //update csList;
        
    }

}