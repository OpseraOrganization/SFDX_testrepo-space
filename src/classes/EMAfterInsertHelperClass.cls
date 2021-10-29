/*******************************************************************************
Name         : EMAfterInsertHelperClass
Created By   : Anusuya Murugiah 
Company Name : NTT Data
Project      : Fix for SOQL 101 Error 
Created Date : 22 December 2014
Usages       : This Trigger is to replace the set of Email Message Triggers split across 
               into single trigger call.  
Usages       : Changes done for UFR Pricing to update case details on Customer response  
Usages       : Changes done for INC000008986324  
       
Modification History  :
Date            Version No.     Modified by     Brief Description of Modification
23-Sept-2016     1.1            TCS             INC000010658740 - Auto close cases with subject: case transferred to you  
09 June - 2017   1.2            TCS             INC000011776534 - Added Code for On-Hold Response Functionality for R&O-Dod-Need Contract
06 Oct 2017      1.3            NttData         10062017 - Added the code to update the IncomingNewEmail checkbox as true in the case object 
                                                for the FSS Activation record type.
08 Feb 2018     1.4             NTT DATA        INC0000143918 - Added the code to capture Email sent date and time in case object                                               
*******************************************************************************/
public class EMAfterInsertHelperClass
{
    public static void emAfterInsertMethod(List<EmailMessage> listObjEM,Map<ID,EmailMessage> oldMap ){
        System.debug('listObjEM===>'+listObjEM);
        System.debug('listObjEM===>'+listObjEM.size());
        set<id> UFRparentID = new set<id>(); // Added for UFR Pricing Phase II
        List<Case> UFRList = new List<Case>(); // Added for UFR Pricing Phase II
        String UFRSBU; // Added for UFR Pricing Phase II
        // AeroGSEVendorSupport Trigger - Start
        list<case> clist = new list<case>(); 
        set<Id> parentid = new set<Id>();         
        // AeroGSEVendorSupport Trigger - End
        //Start AeroROExchangeHandler class
        
        set<ID> EmsgID = new set<ID>();
                        
        for(EmailMessage em: listObjEM)
        {
            if(em.ToAddress!=null && em.ToAddress.contains(label.XML_Response_Toaddress)){
                system.debug('test email');
                EmsgID.add(em.ID);
                
            }
        }
        system.debug('AeroEMID==>' + EmsgID);
        if(!EmsgID.isEMpty())
        {
        AeroROExchangeHelper.XMLResponseToAero(EmsgID );
        }
        // End AeroROExchangeHandler 
        // ROActivitycreation  - Start
        set<Id> parentid1 = new set<Id>();
        set<Id> parentid2 = new set<Id>(); 
        string emailSubject; 
        Id recrdtypid1 = label.Repair_Overhaul_RT_ID;   
        List<Task> NewTaskInsert = new List<Task>();
        DateTime lastCreatedDate;
        List<Emailmessage> em = new List<Emailmessage>();
        set<Id> emailid = new set<Id>();
        List<Task> ts = new List<Task>();
        List<Task> tasklist =  new List<Task>();
        // ROActivitycreation  - End
        Boolean advnRunStatus = false; // ADVN Notification changes
        Boolean aexOrderQuotation = false; // Added as part of RAPD-1557
        // EmailAttachmentCopy - Start
        set<Id> sendmailCaseId = new set<Id>();   
        
         List<string> listE2cEmailOrigin = new List<string>{'Email-AeroAirbus',
                                            'Email-AeroBoeing',
                                            'Email-AeroComponents',
                                            'Email-BGAOEMQuoteOrders',
                                            'Email-CPSQuotesApprovals',
                                            'Email-CSO BGA Spares',
                                            //'Email-D&Sorders',  commented for incident INC000008714992
                                            //'Email-D&Squotes',  commented for incident INC000008714992
                                            //'Email-R&O D&S',    commented for incident INC000008714992
                                            'Email-Order Changes',
                                            'Email-Order Status',
                                            'Email-Orders',
                                            'Email-Quotes',
                                            'Email-R&O Avionics',
                                            'Email-R&O MechComponents',
                                            'Email-ROEMEAIAvionics',
                                            'Email-ROEMEAIMechanical',
                                            'Email-RepairquotesEscalation',
                                            'Email-R&O APU',
                                            'Email-R&O Engines',
                                            'Email-R&O FastShop'};
        List<Case_Matrix__c> listCaseMatrix = [select id,Name, OwnerId__c from Case_Matrix__c where Name in: listE2cEmailOrigin];
        Map<string,id> mapOwnerIds = new Map<string,id>();
        for(Case_Matrix__c cmItem:listCaseMatrix){
            mapOwnerIds.put(cmItem.Name,cmItem.OwnerId__c);
        }
        String CaseId ,csnumref,frmaddr;
        Boolean aeromech = false; Boolean aeroavionics = false;
        Boolean aeroapu = false; Boolean aeroengines = false;
        Boolean aeroshop = false; Boolean aerogbs = false; 
        Boolean Owneractive; Boolean aeroescalation = false;
        Set<ID> emID = new Set<ID>();
        List<Case> lstROCases = new List<Case>();
        List<Case> lstRnOCases = new List<Case>();
        List<Case> lstRnOCasess = new List<Case>();
        Set<Id> setRoCaseIds = new Set<Id>();
        Set<id> setCaseIds = new Set<id>();
        Set<id> setCaseIds1 = new Set<id>(); //added for propose to close functinality
        Set<id> setCaseIds2 = new Set<id>();  // added for SCTASK3049692
        Map<id,Emailmessage> CaseEmailMap = new Map<id,Emailmessage>();
        List<Case> p2cCases = new List<Case>();//added for propose to close functinality
        List<Case> updatep2cCases = new List<Case>();//added for propose to close functinality
        List<Case> Fsscase1 = new List<Case>();//added for SCTASK3049692
        List<Case> updateFsscase1 = new List<Case>();// added for SCTASK3049692
        Long hours;//added for propose to close functinality
        Set<id> setContIds = new Set<id>();
        list<string> listProcess = new list<string>();
        List<Messaging.SingleEmailMessage> msglist = new List<Messaging.SingleEmailMessage>();
        Map<Id,String> mpRoCaseEmail = new Map<Id,String>();
        Map<Id,String> mpRoEmailSubject = new Map<Id,String>();
        Map<Id,String> mpRoEmailSubject1 = new Map<Id,String>();
        Map<Id,String> mpRoEmailTextBody = new Map<Id,String>();        
        Map<Id,String> mpRoFromAddress = new Map<Id,String>();
        Map<String,ID> mapContact = new Map<String,ID>();
        List<Contact> lstContact = new List<Contact>();
        List<Agent_Contact_Mapping__c> listAgent = new List<Agent_Contact_Mapping__c>();
        // EmailAttachmentCopy - End 
        
        // updateCaseReOpen - Start
        List<Id> caseIds = new List<Id>();
        Boolean stopemail = false;
        List<Case> cases = new List<Case>();
        list<string> listProcess1 = new list<string>();
        Set<id> setContIds1 = new Set<id>();
        List<Agent_Contact_Mapping__c> listAgent1 = new List<Agent_Contact_Mapping__c>();
        // updateCaseReOpen - End
        Boolean fssactivationflag = false;
        //INC0000143918 start
        Set<Id> stCaseId = new Set<Id>();
        Map<Id,DateTime> mpCIDEMDT = new Map<Id,DateTime>();
        Map<Id,String> mpCIDWebmail = new Map<Id,String>();
        
        //INC0000214866
        String EmailFromAdrs;
        
        for(EmailMessage e1 : listObjEM) 
        {               
             
            if(null!=e1.ParentId && String.valueOf(e1.ParentId).substring(0,3) == '500' && e1.Status =='3' && e1.Incoming == False && (e1.CreatedById != label.aero_default_user_id || !Label.API_User_OwnerId_s.CONTAINS(e1.CreatedById)) && (!e1.ToAddress.CONTAINS('@honeywell.com')))
            {
                system.debug('======== Not default User');
                stCaseId.add(e1.ParentId);
                mpCIDEMDT.put(e1.ParentId,e1.CreatedDate);
                mpCIDWebmail.put(e1.ParentId,e1.ToAddress);
            }
        }
        List<Case_Extension__c> lstCsE = new List<Case_Extension__c>();
        If(stCaseId.size()>0){
            lstCse = [Select id,Case_object__c,Case_object__r.User_Status__c,Email_Sent_Date_By_CSR__c,Case_object__r.SuppliedEmail from Case_Extension__c where Case_object__c IN :stCaseId];
        }
        if(lstCse.size()>0)
        {
            for(Case_Extension__c cse: lstCse)
            {
                if(cse.Email_Sent_Date_By_CSR__c == null && cse.Case_object__r.User_Status__c == 'Active' && cse.Case_object__r.SuppliedEmail == mpCIDWebmail.get(cse.Case_object__c))
                    cse.Email_Sent_Date_By_CSR__c = mpCIDEMDT.get(cse.Case_object__c);
            }
        }
        system.debug('========lstCse=='+lstCse);
        Update lstCse;
        //INC0000143918 End
        
        for(EmailMessage e1 : listObjEM) 
        {               
            /// EmailAttachmentCopy - Start 
            emID.add(e1.ID);
            if(null!=e1.ParentId){
                CaseId = e1.ParentId; 

                if(caseId.substring(0,3) == '500')
                {
					//Added by Shwetha- For TSLI date Logic - CaseEmailMap Populate
                    if(e1.FromAddress!=null && e1.Incoming==False){
                        CaseEmailMap.put(e1.ParentId,e1);
                    }
                    // End of - Added by Shwetha for TSLI date
                    // Start UFR Pricing Case details update on response                
                        system.debug('UFR Pricing starts EMail---------->');
                        
                        //INC0000214866
                        //EmailFromAdrs = e1.FromAddress.toUpperCase();
                        
                        if(e1.Incoming == true && (null!=e1.ToAddress && e1.ToAddress.toUpperCase().contains('AEROREPAIRS@HONEYWELL.COM'))){
                            system.debug('UFR Pricing inside if Email---------->');
                            UFRparentID.add(e1.ParentId);
                        }
                    // End for UFR Pricing Case details update on response
                    //Start propose to close case functionality//
                    System.debug('EMAILFROM:'+e1.fromAddress);
                    if(!(e1.FromAddress!=null && e1.FromAddress.toUpperCase().contains('ORDERSTATUS'))){
                     System.debug('Test'+e1.FromAddress);
                    if(e1.Incoming == true)
                    {
                    setCaseIds1.add(e1.parentid);
                    if(e1.subject.contains('ref:'))
                    {
                        fssactivationflag=true;
                    }
                    }else{
                    //CaseEmailMap.put(e1.parentid,e1);  // commented out as part of TSLI Date Logic
                    }
                }
                    // updateCaseReOpen - Start
                    setCaseIds.add(e1.parentid); 
                    if(e1.FromAddress!=null && (e1.FromAddress.toUpperCase().contains('DONT-REPLY-AOG-DESK@SERVICES.DLH.DE'))){
                        stopemail = true;
                    }
                    //if(e1.subject != null && (e1.Status == '0' || e1.Status == '1') && (null!=e1.textbody && !(e1.textbody.toUpperCase().startsWith('THANKS') || e1.textbody.toUpperCase().startsWith('THANK YOU'))) )
                    //Filter condition added to exempt for Pega Cases if From is OrderStatus Email Address
                    if(e1.subject != null && (e1.Status == '0' || e1.Status == '1') && (!(e1.FromAddress!=null && e1.FromAddress.toUpperCase().contains('ORDERSTATUS'))))
                       
                        caseIds.add(e1.ParentId);
                        
                    // updateCaseReOpen - End
                    
                    // AeroGSEVendorSupport Trigger - Start
                    
                    if(e1.Incoming == true  
                        && (e1.ToAddress == 'aerogsevendorsupport@honeywell.com' || e1.ToAddress == 'aerogsevendorsupport@s-1wazi72hi4ykq56m7fjgh5rdz8ka6fvv5yg4wp1ow3n9m3q9fk.18-careai.cs23.case.sandbox.salesforce.com' ))
                    {    
                        parentid.add(e1.ParentId);
                    } 
                    // AeroGSEVendorSupport Trigger - End
                    
                    // ROActivitycreation  - Start
                    else if(e1.Incoming == true && ( e1.FromAddress!=null && !((e1.FromAddress).contains('honeywell.com'))) 
                            &&(e1.ToAddress!=null && (e1.ToAddress == 'aeror&oavionics@honeywell.com') || (e1.ToAddress == 'AeroROAvionicsQA@honeywell.com') 
                               || (e1.ToAddress == 'aeror&oapu@honeywell.com') || (e1.ToAddress == 'aeror&oengines@honeywell.com') 
                               || (e1.ToAddress== 'aeror&ofastshop@honeywell.com' ) || (e1.ToAddress=='aeror&omechcomponents@honeywell.com')
                               || (e1.ToAddress=='aeroromechcomponentsqa@honeywell.com'))
                           )
                    {    
                        parentid1.add(e1.ParentId);
                        emailSubject = e1.Subject;             
                    }
                    else if(e1.Incoming == false )
                    {    
                       parentid2.add(e1.ParentId);
                       emailid.add(e1.id);
                       lastCreatedDate = e1.MessageDate;
                    } 
                    // ROActivitycreation  - End
                    // Modified code for INC000008976667
                    if(e1.fromaddress!= null && e1.fromaddress.contains('embraer') && !((e1.fromaddress.toUpperCase().contains('patricia.rosa@embraer.com.br') || e1.fromaddress.toUpperCase().contains('hany.almeida@embraer.com.br') || e1.fromaddress.toUpperCase().contains('douglas.zamith@embraer.com.br') || e1.fromaddress.toUpperCase().contains('andressa.leite@embraer.com.br')) && (e1.ToAddress!=null && (e1.ToAddress.toUpperCase().contains('aerocsobgaspares@honeywell.com') || e1.ToAddress.toUpperCase().contains('aerobgaoemquotesorders@honeywell.com')))))
                    {
                        sendmailCaseId.add(e1.ParentId);    
                    }
                    if(e1.FromAddress != null && e1.FromAddress.toUpperCase().contains('BOEING.COM')){                    
                        setRoCaseIds.add(e1.parentid);
                        frmaddr = e1.FromAddress;
                    }           
                    if(e1.subject != null && e1.subject != '' && (e1.ToAddress != null || e1.CcAddress != null))
                    { 
                    mpRoEmailSubject1.put(e1.ParentId,e1.subject);
                    mpRoEmailTextBody.put(e1.ParentId,e1.textbody);
                        if(e1.ToAddress!=null &&((e1.ToAddress.toUpperCase().contains('AEROROMECHCOMPONENTSQA@HONEYWELL.COM')) || (e1.ToAddress.toUpperCase().contains('AEROROMECHCOMPONENTS@HONEYWELL.COM')) || (e1.ToAddress.toUpperCase().contains('AEROR&OMECHCOMPONENTS@HONEYWELL.COM'))
                        || (e1.ToAddress == 'aeror&omechcomponents@k-10n60g0bsiuqo2imva4ap1wdklmh1a4xwogqweaj3fbrxse4b8.18-careai.cs23.case.sandbox.salesforce.com')
                        ) ||
                           (e1.CcAddress!=null && ((e1.CcAddress.toUpperCase().contains('AEROROMECHCOMPONENTSQA@HONEYWELL.COM')) || (e1.CcAddress.toUpperCase().contains('AEROROMECHCOMPONENTS@HONEYWELL.COM')) || (e1.CcAddress.toUpperCase().contains('AEROR&OMECHCOMPONENTS@HONEYWELL.COM')))
                        ))
                        {
                            setRoCaseIds.add(e1.ParentId);
                            mpRoCaseEmail.put(e1.ParentId,'Email-R&O MechComponents');
                            mpRoEmailSubject.put(e1.ParentId,e1.subject);
                            mpRoFromAddress.put(e1.ParentId,e1.FromAddress);
                            aeromech = true;
                        }
                        else if(e1.ToAddress!=null &&((e1.ToAddress.toUpperCase().contains('AEROROAPU@HONEYWELL.COM')) || (e1.ToAddress.toUpperCase().contains('AEROR&OAPU@HONEYWELL.COM'))) ||
                           (e1.CcAddress!=null && ((e1.CcAddress.toUpperCase().contains('AEROROAPU@HONEYWELL.COM')) || (e1.CcAddress.toUpperCase().contains('AEROR&OAPU@HONEYWELL.COM'))
                        )))
                        {
                            setRoCaseIds.add(e1.ParentId);
                            mpRoCaseEmail.put(e1.ParentId,'Email-R&O APU');
                            mpRoEmailSubject.put(e1.ParentId,e1.subject);
                            mpRoFromAddress.put(e1.ParentId,e1.FromAddress);
                            aeroapu = true;
                        }
                        else if(e1.ToAddress!=null &&((e1.ToAddress.toUpperCase().contains('AEROROAVIONICSQA@HONEYWELL.COM')) || (e1.ToAddress.toUpperCase().contains('AEROROAVIONICS@HONEYWELL.COM')) || (e1.ToAddress.toUpperCase().contains('AEROR&OAVIONICS@HONEYWELL.COM'))
                        || (e1.ToAddress == 'aeror&oavionics@w-11gjhn64og8hvjs3ifrr86kcr1m2h4pu82ea8k1j8cv4yybam3.18-careai.cs23.case.sandbox.salesforce.com')
                        ) ||
                            (e1.CcAddress!=null && ((e1.CcAddress.toUpperCase().contains('AEROROAVIONICSQA@HONEYWELL.COM')) || (e1.CcAddress.toUpperCase().contains('AEROROAVIONICS@HONEYWELL.COM')) || (e1.CcAddress.toUpperCase().contains('AEROR&OAVIONICS@HONEYWELL.COM')))
                        ))
                        {
                            setRoCaseIds.add(e1.ParentId);
                            mpRoCaseEmail.put(e1.ParentId,'Email-R&O Avionics');
                            mpRoEmailSubject.put(e1.ParentId,e1.subject);
                            mpRoFromAddress.put(e1.ParentId,e1.FromAddress);
                            aeroavionics = true;
                        }
                        else if(e1.ToAddress!=null && ((e1.ToAddress.toUpperCase().contains('AEROROENGINES@HONEYWELL.COM')) || (e1.ToAddress.toUpperCase().contains('AEROR&OENGINES@HONEYWELL.COM'))) ||
                            (e1.CcAddress!=null &&((e1.CcAddress.toUpperCase().contains('AEROROENGINES@HONEYWELL.COM')) || (e1.CcAddress.toUpperCase().contains('AEROR&OENGINES@HONEYWELL.COM')))
                        ))
                        {
                            setRoCaseIds.add(e1.ParentId);
                            mpRoCaseEmail.put(e1.ParentId,'Email-R&O Engines');
                            mpRoEmailSubject.put(e1.ParentId,e1.subject);
                            mpRoFromAddress.put(e1.ParentId,e1.FromAddress);
                            aeroengines = true;
                        }
                        else if(e1.ToAddress!=null && ((e1.ToAddress.toUpperCase().contains('AEROROFASTSHOP@HONEYWELL.COM')) || (e1.ToAddress.toUpperCase().contains('AEROR&OFASTSHOP@HONEYWELL.COM'))) ||
                            (e1.CcAddress!=null && ((e1.CcAddress.toUpperCase().contains('AEROROFASTSHOP@HONEYWELL.COM')) || (e1.CcAddress.toUpperCase().contains('AEROR&OFASTSHOP@HONEYWELL.COM')))
                        ))
                        {
                            setRoCaseIds.add(e1.ParentId);
                            mpRoCaseEmail.put(e1.ParentId,'Email-R&O FastShop');
                            mpRoEmailSubject.put(e1.ParentId,e1.subject);
                            mpRoFromAddress.put(e1.ParentId,e1.FromAddress);
                            aeroshop = true;
                        }                        
                        else if((e1.ToAddress!=null && (e1.ToAddress.toUpperCase().contains('ROQUOTEESCALATION@HONEYWELL.COM'))) || (e1.CcAddress!=null && (e1.CcAddress.toUpperCase().contains('ROQUOTEESCALATION@HONEYWELL.COM'))))
                        {
                            setRoCaseIds.add(e1.ParentId);
                            mpRoCaseEmail.put(e1.ParentId,'Email-RepairquotesEscalation');
                            mpRoEmailSubject.put(e1.ParentId,e1.subject);
                            mpRoFromAddress.put(e1.ParentId,e1.FromAddress);
                            aeroescalation = true;
                        }
                        // Added code to by pass future method for ADVN Email Notification 
                        if(e1.ToAddress!=null && e1.subject.contains('Repair & Overhaul ADVN Notification to Portal Customers')){
                           advnRunStatus = true;
                        }
                        // Ended changes for ADVN Email Notification
                        // Started changes RAPD-1557
                        if(e1.subject != null && e1.subject != '' && (e1.subject.contains('AEX_ServiceOrderQuotation') || e1.subject.contains('Aeroxchange Repair Error Message =- AEX_ServiceOrderQuotation')) &&                        
                           e1.FromAddress != null && e1.FromAddress.toUpperCase().contains('AEXMAILER@AEROXCHANGE.COM') &&
                           e1.ToAddress!=null &&((e1.ToAddress.toUpperCase().contains('CRC-EDI@HONEYWELL.COM')))) //e1.FromAddress != null && e1.FromAddress.toUpperCase().contains('PRAJNYA.MANDALA@NTTDATA.COM') &&
                           {     
                             System.debug('Inside of AEX_ServiceOrderQuotation');                        
                             setRoCaseIds.add(e1.parentid);
                             aexOrderQuotation = true;  
                           }
                        // Ended changes RAPD-1557
                    }
                }   
        }    
        /// EmailAttachmentCopy - End
        }
        /// EmailAttachmentCopy - Start
        if(emID.size()>0 && advnRunStatus == false ){
            system.debug('emailcopy entered');
            EmailAttachmentCopy.attachcase(emID);  // Calling Future Method
        }
        ///Email service Callout to Pega Service for attaching SFDC Emails to Pega
        if(emId.size()>0 && advnRunStatus == false ){
            PegaEmailCalloutClass.CreatePegaEmailRecord(emId); ///Calling Future Method to attach Email to Pega Case
        }
        if(setCaseIds1.size() > 0)
        {
        p2cCases = [Select id,Origin,contactid,RecordTypeId,Case_Record_Type__c, status, closeddate,isclosed From
                              Case Where Id in :setCaseIds1 ];

            if(p2cCases != null && p2cCases.size() > 0)
            {
                for(case objCase : p2cCases)
                {
                  /* commenting to rollback CSO case re-open functionality
                  //New conditions added for cso cases re-open functionality 11-11-2016
                  integer DaysBetween = 0;
                  if (objCase.isclosed){
                  DaysBetween=(objCase.closeddate.date()).daysBetween(system.today());
                  }
                  system.debug('DaysBetween '+ DaysBetween);
                  */
// Added Code for On-Hold Response Functionality for R&O-Dod-Need Contract - INC000011776534 - Start Code               
              if ((objCase.status == 'Propose to Close' || objCase.status == 'open-Rejected' )
                /* commenting to rollback case re-open functionality  
                ((objCase.Case_Record_Type__c == 'Internal Escalations' || 
                objCase.Case_Record_Type__c == 'Repair & Overhaul' || objCase.Case_Record_Type__c == 'Quotes' 
                || objCase.Case_Record_Type__c == 'Orders' || objCase.Case_Record_Type__c == 'OEM Quotes Orders' 
                || objCase.Case_Record_Type__c == 'Returns' || objCase.Case_Record_Type__c == 'ReturnsPRO') && 
                (DaysBetween<= 90) && (objCase.status != 'Closed' || objCase.origin == 'SAP Interface') && objCase.isclosed)
                */
               )
                    {
                    objCase.status = 'Re-Open';
                    updatep2cCases.add(objCase);
                }else if((objCase.Case_Record_Type__c == 'Internal Escalations' || objCase.Case_Record_Type__c == 'GSS Escalations' ||
                objCase.Case_Record_Type__c == 'Repair & Overhaul' || objCase.Case_Record_Type__c == 'Quotes' 
                || objCase.Case_Record_Type__c == 'Orders' || objCase.Case_Record_Type__c == 'OEM Quotes Orders' 
                || objCase.Case_Record_Type__c == 'Returns' || objCase.Case_Record_Type__c == 'ReturnsPRO'
                || objCase.Case_Record_Type__c == 'R&O-Dod-Need Contract'|| objCase.Case_Record_Type__c == 'Exchange') 
                 && (objCase.status == 'On Hold' || objCase.status == 'On Hold CBT Z7' || objCase.status == 'On Hold – FCOE Rejected'))
                    {
                    objCase.status = 'On Hold – Response Received';
                    updatep2cCases.add(objCase);  
                    }
                    
                    //Added by Priya - 10062017 - To update the IncomingNewEmail checkbox as true in the case object for the FSS Activation record type.
                    if(Label.FssActivationCaseRecordTypeId.contains(objCase.RecordTypeId) && fssactivationflag == true)
                    {
                        system.debug('case status------'+objCase.status);
                        objCase.IncomingNewEmail__c = true;
                        if(objcase.status=='done')
                        {
                            objcase.status='re-open';
                        }
                        updatep2cCases.add(objCase);
                    }
                     //End of - Added by Priya - 10062017 - To update the IncomingNewEmail checkbox as true in the case object for the FSS Activation record type.
                }
            }
        }
    // Added Code for On-Hold Response Functionality for R&O-Dod-Need Contract - INC000011776534 - End Code  
    // Added below strings as part of TSLI  Date Populate   
       List<String> StringLst = new List<String>();
        List<string> InternalTO = new List<string>();
        List<string> externalTo = new List<string>();
        List<string> InternalCC = new List<string>();
        List<string> ExternalCC = new List<string>();
        List<String> InternalBcc = new List<string>();
        List<string> ExternalBcc = new List<string>();
        List<string> strCC = new List<string>();
        List<string> strBcc = new List<string>();
        string CCstr;
        // Ended the variable declarations. 
        if(CaseEmailMap.size() > 0)
        {
          list<case> Cases2 = [Select id,contact.email,Case_Record_Type__c, status, closeddate,isclosed From
            Case Where Id in :CaseEmailMap.keySet() and (Case_Record_Type__c = 'Internal Escalations'
            or Case_Record_Type__c = 'Repair & Overhaul' or Case_Record_Type__c = 'OEM Quotes Orders'
            or Case_Record_Type__c = 'quotes' or Case_Record_Type__c = 'Orders'
            or Case_Record_Type__c = 'ReturnsPRO' or Case_Record_Type__c = 'Returns' or Case_Record_Type__c = 'Aero Customer Support' or Case_Record_Type__c = 'Technical Issue' or Case_Record_Type__c ='OEM/Spares' or  Case_Record_Type__c = 'XML Orders' or Case_Record_Type__c = 'Exchange')]; //Added recordtype XML Orders for below.
            //Added RecordType Exchange in the above Query for TSLI
            if(Cases2 != null && Cases2.size() > 0)
            {
            boolean tsliu;
            
            //Added the below code to populate the TSLI Date if the outbound email has external emailID -by Shwetha
                
                for(case objCase : Cases2){
                    tsliu = false;
                    if(CaseEmailMap.get(objCase.id).ToAddress !=null){
                        system.debug('entered internal if');
                        string internal = CaseEmailMap.get(objCase.id).ToAddress;
                        StringLst = internal.split(';');
                        system.debug('internal string==' +internal);
                        for(string str :StringLst){
                            if(str.substringAfter('@')=='honeywell.com'){
                                system.debug('equals hw');
                                InternalTO.add(str);
                            }
                            else{
                                system.debug('else hw');
                                externalTo.add(str);
                            }
                        }
                    }
                    
                    if(CaseEmailMap.get(objCase.id).CcAddress != null){
                        string CCAddress = CaseEmailMap.get(objCase.id).CcAddress;
                        strCC = CCAddress.split(';');
                        for(String sCC :strCC){
                            if(sCC.substringAfter('@')=='honeywell.com'){
                                InternalCC.add(sCC);
                            }
                            else{
                                ExternalCC.add(sCC);
                            }
                        }
                    }
                    if(CaseEmailMap.get(objCase.id).BccAddress != null){
                        string Bcc = CaseEmailMap.get(objCase.id).BccAddress;
                        strBcc = Bcc.split(';');
                        for(String sBc :strBcc){
                            if(sBc.substringAfter('@')=='honeywell.com'){
                                InternalBcc.add(sBc);
                            }
                            else{
                                ExternalBcc.add(sBc);
                            }
                        }
                    }
                  
                   system.debug('internal size' +InternalTO.size());
                    if((InternalTO.size()>0 && externalTo.size()>0) ||(InternalTO.isEmpty() && externalTo.size()>0 )){
                        system.debug('entered size');
                         tsliu = true;
                    }
                    if((InternalCC.size()>0 && ExternalCC.size()>0) || (InternalCC.isEmpty() && ExternalCC.size()>0)){
                        tsliu = true;
                    }
                    if((InternalBcc.size()>0 && ExternalBcc.size()>0) || (InternalBcc.isEmpty() && ExternalBcc.size()>0)){
                        tsliu = true;
                    }
                    
                    if(tsliu == true){
                        objCase.TSLI_dateTime__c=system.now();
                        if(!updatep2cCases.contains(objCase))
                            updatep2cCases.add(objCase); 
                    } 
                }
            
            /*Commented out old code for TSLI Date
                 // The logic is TSLI Date will be populated if the email has been sent to primary contact
                for(case objCase : Cases2)
                {
                tsliu = false;
                if (objCase.contact != null && objCase.contact.email != null){
                if(CaseEmailMap.get(objCase.id).ToAddress !=null && CaseEmailMap.get(objCase.id).ToAddress.contains(objCase.contact.email))
                {
                tsliu = true;
                }
                if(CaseEmailMap.get(objCase.id).CcAddress != null && CaseEmailMap.get(objCase.id).CcAddress.contains(objCase.contact.email)){
                tsliu = true;
                }
                if(CaseEmailMap.get(objCase.id).BccAddress != null && CaseEmailMap.get(objCase.id).BccAddress.contains(objCase.contact.email)){
                tsliu = true;
                }
                if(tsliu == true){
                objCase.TSLI_dateTime__c=system.now();
                updatep2cCases.add(objCase);
                }  
                }
                } */
        }
        }
        if(setRoCaseIds.size() > 0)
        {   
            try
            {
                String strEmailSubj;
                lstROCases = [Select id,Origin,Description, OwnerId__r.IsActive,ownerid,R_O_Case_Origin__c,Emailbox_Origin__c ,contactid,contact.name,subject,RnOSAPCases__c,RecordTypeId,CreatedById,Customer_PO_RO_WONumber__c,Product_Serial_Number__c,IsClosed From
                              Case Where Id in :setRoCaseIds and Status != 'Cancelled'];
                
                if(mpRoFromAddress.size()>0)
                    lstContact = [select id,email from Contact where email =: mpRoFromAddress.values()];                              
                
                for(Contact c: lstContact )
                {
                    mapContact.put(c.email,c.id);
                }
                if(lstROCases != null && lstROCases.size() > 0)
                {
                    listProcess.add(lstROCases[0].R_O_Case_Origin__c);
                    setContIds.add(lstROCases[0].contactid);
                    
                    if (listProcess.size()>0 || setContIds.size()>0) 
                        listAgent = [select id,CSR__c,CSR__r.Signature1__c,CSR__r.IsActive,Contact__c,Process__c from Agent_Contact_Mapping__c where
                        Agent_Contact_Mapping__c.Contact__c in: setContIds and Agent_Contact_Mapping__c.Process__c in: listProcess ];
                    for(case objCase : lstROCases)
                    {
                        // Added code for INC000007037567
                        if(objCase.RecordTypeId != null && objCase.Origin != null && objCase.Description != null && frmaddr != null){
                            if(objCase.RecordTypeId == label.General_RT_ID && objCase.Origin == 'E2CP Test' && objCase.OwnerId == label.aero_default_user_id && objCase.Description.toUpperCase().contains('THE BOEING COMMUNICATION SYSTEM')){
                                objCase.Origin = 'Email';
                                objCase.RecordTypeId = label.TechnicalIssueId;
                               objCase.ContactId = label.Boeing_Comm_Sys_Cont_ID;
                                objCase.OwnerId = label.TOC_Team_ID;
                                lstRnOCases.add(objCase);
                                String[] toadd = new String[]{frmaddr};
                                String body='<!DOCTYPE html><body><table border="0" cellpadding="0" cellspacing="0" width="950" style="position: absolute;right: 50px;"><tr><td align="center" height="45" valign="top"><img src="label.Honeywell_document_image" alt="Logo" style="border:none;display:block;right: 20px;position: absolute;top: 10px;height: 30px;"/></td></tr><br/></table><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-top-width: 4px;border-top-style: solid;border-top-color: #ED2028;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"><tr><td align="right" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="left" height="60" style="font-family:Times New Roman;font-size:16px;padding-left: 24px;" valign="middle">Thank you for contacting Honeywell Aerospace Customer Support.  Your case tracking number for this inquiry is provided above.  If you wish to communicate with us further about this inquiry, you may reply to this e-mail -- please leave the Reference Case # within the subject line for quicker responses.<br/><br/>Visit the exciting new options on our improved, easier to navigate Web Portal at www.myaerospace.com.  You can now obtain real time price and availability, place orders and check order status online for avionics, mechanical, wheels and brakes products and exchange programs (SPEX), globally for all of our customers. Additionally, you can access Technical Publications, database updates, R&O capabilities, and other support tools.  BendixKing Dealers can obtain price and availability, place orders and check order status online and Wingman Services customers can utilize database services at www.bendixking.com.<br/><br/>Thank you, we appreciate your business!<br/>Honeywell Aerospace<br/>Customer & Product Support<br/>Web: <span  style="font-size:16px; text-decoration:underline; color:#679afa; ">http://www.MyAerospace.com</span><br/>1-800-601-3099 or internationally at 1-602-365-3099<br/>ORIGINAL CORRESPONDENCE:<br/>'+objCase.Subject+'<br/>'+objCase.Description+'<br/>'+objCase.Case_Ref_ID__c+'<br/><br/></td></tr></table></td></tr></table><br/><br/><table border="0" cellpadding="5" cellspacing="0" width="600" style="position: absolute;right: 50px;border-bottom-width: 4px;border-bottom-style: solid;border-bottom-color: #ED2028;"/></body></html>';
                                csnumref = objCase.CaseNumber+' '+objCase.Case_Ref_ID__c;
                                
                                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();            
                                message.setToAddresses(toadd);
                                message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
                                message.setBccSender(false);             
                                message.setUseSignature(false);
                                message.setSaveAsActivity(false); 
                                message.setSubject(csnumref);
                                message.setHtmlBody(body);
                                msglist.add(message);
                            }
                        }
                        // End code for INC000007037567
                        Owneractive = objCase.OwnerId__r.IsActive;
                        if(objCase.recordtypeid == label.RnO_Automation_Record_Type &&
                        (objCase.Customer_PO_RO_WONumber__c != null || objCase.Product_Serial_Number__c != null)                           
                          //&&
                           //objCase.createdbyid == label.Portal_API_User_RO_Automation && objCase.ownerid == label.RnO_Automation_Default_Owner)
                           //objCase.createdbyid == label.Portal_API_User_RO_Automation
                           )
                        {
                            Case objCaseToUpdt = new Case(id = objCase.id);
                            if(objCase.ownerid == label.RnO_Automation_Default_Owner){
                                strEmailSubj = mpRoEmailSubject.get(objCase.id);                       
                                Decimal intRnOSAPCases = objCase.RnOSAPCases__c;                               
                                
                                if(intRnOSAPCases != null)
                                {
                                    objCaseToUpdt.RnOSAPCases__c = intRnOSAPCases + 1;
                                }
                                else
                                {
                                    objCaseToUpdt.RnOSAPCases__c = 1;
                                }
                                system.debug('SAP Interface --'+objCase.origin);
                                if(objCase.origin != 'SAP Interface'){
                                objCaseToUpdt.origin = mpRoCaseEmail.get(objCase.id);
                                }
                                if(objCaseToUpdt.contactid == null || objCaseToUpdt.contactid == label.RnO_Automation_Default_Contact)
                                {
                                    if((mpRoFromAddress.size()>0 && null!=mpRoFromAddress.get(objCase.id)) && (mapContact.size()>0 && null!=mapContact.get(mpRoFromAddress.get(objCase.id))))                                
                                    {
                                      objCaseToUpdt.contactid = mapContact.get(mpRoFromAddress.get(objCase.id));
                                    }  
                                    objCaseToUpdt.SuppliedEmail = mpRoFromAddress.get(objCase.id);
                                }    
                                if(objCase.isclosed)
                                {
                                    objCaseToUpdt.Reopen_Case__c = true;
                                    system.debug('checking if our test is passing'+objCaseToUpdt.Reopen_Case__c);
                                }
                            }
                            if(aeromech == true){ objCaseToUpdt.Emailbox_Origin__c = 'Email-R&O MechComponents';
                                                  objCaseToUpdt.R_O_Case_Origin__c = 'R&O MechComponents';}
                            else if(aeroapu == true){ objCaseToUpdt.Emailbox_Origin__c = 'Email-R&O APU';
                                                      objCaseToUpdt.R_O_Case_Origin__c = 'R&O APU';}
                            else if(aeroavionics == true){ objCaseToUpdt.Emailbox_Origin__c = 'Email-R&O Avionics';
                                                           objCaseToUpdt.R_O_Case_Origin__c = 'R&O Avionics';}
                            else if(aeroengines  == true){ objCaseToUpdt.Emailbox_Origin__c = 'Email-R&O Engines';
                                                           objCaseToUpdt.R_O_Case_Origin__c = 'R&O Engines';}
                            else if(aeroshop == true){ objCaseToUpdt.Emailbox_Origin__c = 'Email-R&O FastShop';
                                                        objCaseToUpdt.R_O_Case_Origin__c = 'R&O FastShop';}                            
                            else if(aeroescalation == true){ objCaseToUpdt.Emailbox_Origin__c = 'Email-RepairquotesEscalation';
                                                            objCaseToUpdt.R_O_Case_Origin__c = 'RepairquotesEscalation';}
                            if( mapOwnerIds.size()>0){
                                for(string emailBox : listE2cEmailOrigin){
                                    if(objCaseToUpdt.Emailbox_Origin__c == emailBox && Owneractive == false)
                                    {
                                       objCaseToUpdt.ownerid = mapOwnerIds.get(objCaseToUpdt.Emailbox_Origin__c);
                                    }
                                }
                            }
                            if(listAgent.size()>0){
                                if(listAgent[0].CSR__r.IsActive == true && Owneractive == false){
                                    objCaseToUpdt.ownerid = listAgent[0].CSR__c;
                                }
                            }
                            lstRnOCasess.add(objCaseToUpdt);
                        }   
                        // Started changes RAPD-1557
                        if( aexOrderQuotation = true && (objCase.origin != null && objCase.origin == 'email') && objCase.RecordtypeId == Label.Order_RecordType &&
                            objCase.RecordtypeId != label.Repair_Overhaul_RT_ID  && objCase.Emailbox_Origin__c == 'Email-crc-edi' && objCase.ownerId != label.CSO_R_O_Team  )
                        { //&& objCase.SuppliedEmail == 'aexmail@aeroexchange.com' && !objCase.status.contains('open')
                            System.debug('Inside of aexOrderQuotation ');
                            Case cs = new Case(id = objCase.id);
                            cs.OwnerID = Label.CSO_R_O_Team;
                            cs.Status = 'Open';
                            cs.RecordTypeId = Label.Repair_Overhaul_RT_ID;
                            lstRnOCasess.add(cs);
                        } 
                        // Ended changes for RAPD-1557      
                        // Start SR#419758
                        /*if(objCase.recordtypeid == label.RnO_Automation_Record_Type &&
                          (objCase.Customer_PO_RO_WONumber__c != null || objCase.Product_Serial_Number__c != null) &&
                           objCase.createdbyid == label.Portal_API_User_RO_Automation)
                        {
                            Case objCaseToUpdte = new Case(id = objCase.id);
                            if(aeromech == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O MechComponents';
                                                  objCaseToUpdte.R_O_Case_Origin__c = 'R&O MechComponents';}
                            else if(aeroapu == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O APU';
                                                      objCaseToUpdte.R_O_Case_Origin__c = 'R&O APU';}
                            else if(aeroavionics == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O Avionics';
                                                           objCaseToUpdte.R_O_Case_Origin__c = 'R&O Avionics';}
                            else if(aeroengines  == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O Engines';
                                                           objCaseToUpdte.R_O_Case_Origin__c = 'R&O Engines';}
                            else if(aeroshop == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-R&O FastShop';
                                                        objCaseToUpdte.R_O_Case_Origin__c = 'R&O FastShop';}                            
                            else if(aeroescalation == true){ objCaseToUpdte.Emailbox_Origin__c = 'Email-RepairquotesEscalation';
                                                            objCaseToUpdte.R_O_Case_Origin__c = 'RepairquotesEscalation';}
                            if( mapOwnerIds.size()>0){
                                for(string emailBox : listE2cEmailOrigin){
                                    if(objCaseToUpdte.Emailbox_Origin__c == emailBox && Owneractive == false)
                                    {
                                        objCaseToUpdte.ownerid = mapOwnerIds.get(objCaseToUpdte.Emailbox_Origin__c);
                                    }
                                }
                            }
                            if(listAgent.size()>0){
                                if(listAgent[0].CSR__r.IsActive == true && Owneractive == false){
                                    objCaseToUpdte.ownerid = listAgent[0].CSR__c;
                                }
                            }
                            lstRnOCasess.add(objCaseToUpdte);
                        }   //End SR#419758
                        */
                    }                                  
                    if(lstRnOCases.size() > 0)
                    {
                        //update lstRnOCases;
                        lstRnOCasess.addAll(lstRnOCases);
                    }
                    
                    // Added code for INC000007037567
                    if(msglist.size()>0){                        
                        Messaging.sendEmail(msglist);
                    }
                    // End code for INC000007037567
                }
            } 
            catch(Exception e){
                System.debug('Exception occured while assigning values based on email subject '+e);
            }
        }
        if(sendmailCaseId.size()>0)
        {
        Case csConId = [select id,ContactId from Case where id=:sendmailCaseId];
        try
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(csConId.ContactId);
            message.setWhatId(csConId.id);
            // The email template ID used for the email
            message.setTemplateId(label.Orders_Acknowledgement_Template_ID);
            message.setBccSender(false);
           message.setUseSignature(false);
            message.setOrgWideEmailAddressId(label.Yourresponse_OrgId);
            message.setSaveAsActivity(false); 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
        }
        catch (Exception exc) 
        {
            System.debug('*******************'+exc);
        }
        }
        // EmailAttachmentCopy - End   
        
        // updateCaseReOpen - Start
        List<EmailMessage> elist = new List<EmailMessage>();
        List<Case_Extension__c> extlist = new List<Case_Extension__c>(); // Added for INC000008986324
        Integer emlist=0; // Added for INC000008986324
        if(setCaseIds.size()>0){
            elist = [select id,parentid,CreatedDate from EmailMessage where parentId in:setCaseIds]; //deb // Modified for 101 error
            // Added code for INC000008986324
            /* Commented code for INC000009239767
            String t = String.valueOf(Date.today());
            String today = t.substring(0,10);
            String emt,edate;
            Date dt = date.valueOf(label.Created_Date_31Aug2015);
            if(elist.size()>0){
                
                for(EmailMessage e:elist){
                    emt = string.valueOf(Date.valueOf(e.CreatedDate));
                    edate = emt.substring(0,10);
                    if(edate==today)
                        emlist++;
                }
            }
            system.debug('emlist size-----> '+emlist);
            List<Case_Extension__c> ext = [select id,Case_object__c, Eight_Emails_Count__c,Eight_Emails_on_Case__c, Eight_Emails_on_Case_Date__c from Case_Extension__c where Case_object__c IN:setCaseIds and (Case_object__r.Case_Record_Type__c = 'Orders' or Case_object__r.Case_Record_Type__c = 'Quotes' or Case_object__r.Case_Record_Type__c = 'Repair & Overhaul' or Case_object__r.Case_Record_Type__c = 'Internal Escalations' or Case_object__r.Case_Record_Type__c = 'OEM Quotes Orders') and Case_object__r.IsClosed=FALSE and Case_object__r.CreatedDate>:dt];
            if(emlist == 8){
               //List<Case_Extension__c> ext = [select id,Case_object__c, Eight_Emails_on_Case__c, Eight_Emails_on_Case_Date__c from Case_Extension__c where Case_object__c IN:setCaseIds and (Case_object__r.Case_Record_Type__c = 'Orders' or Case_object__r.Case_Record_Type__c = 'Quotes' or Case_object__r.Case_Record_Type__c = 'Repair & Overhaul' or Case_object__r.Case_Record_Type__c = 'Internal Escalations' or Case_object__r.Case_Record_Type__c = 'OEM Quotes Orders') and Case_object__r.IsClosed=FALSE and Case_object__r.CreatedDate>:dt];
                if(ext.size()>0){ 
                    ext[0].Eight_Emails_Count__c = emlist;
                    ext[0].Eight_Emails_on_Case_Date__c = system.now();
                    ext[0].Eight_Emails_on_Case__c = TRUE;
                    extlist.add(ext[0]);
                }
            }else if(emlist!=8 && ext.size()>0){
                ext[0].Eight_Emails_Count__c = emlist;
                extlist.add(ext[0]);
            }
            if(extlist.size()>0 && !extlist.isEmpty())
                try{
                    update extlist;
                }catch(DMLException e3){}*/
            // End code for INC000008986324   
        }
        for(Case cs:[select id, contactid, R_O_Case_Origin__c from case where id in: setCaseIds])
        {
            listProcess1.add(cs.R_O_Case_Origin__c);
            setContIds1.add(cs.contactid);
        }        
        if(listProcess1.size()>0 || setContIds1.size()>0)             
             listAgent1 = [select id,CSR__c,CSR__r.Signature1__c,CSR__r.IsActive,Contact__c,Process__c from Agent_Contact_Mapping__c where
            Agent_Contact_Mapping__c.Contact__c in: setContIds1 and Agent_Contact_Mapping__c.Process__c in: listProcess1 ];
        
        if(caseIds.size() > 0){
            try{
                Map<Id,Boolean> emgCheck = new Map<Id,Boolean>();
                cases = [Select id,isClosed,RecordType.Name,Status_changed1__c,Status_changed__c,OwnerId__r.IsActive,subject,
                classification__c,Origin, Status,Case_Record_Type__c,RecordTypeId,SuppliedEmail,closeddate,OpenTask__c,service_level__c,
                Emailbox_Origin__c,Sub_Status__c,Case_OwnerId_After_Close__c,ownerid 
                From Case Where Id in :caseIds and ((isClosed = true  and Case_Record_Type__c != 'Technical Issue'
                /*and Case_Record_Type__c != 'AOG'*/ 
                /* commenting to rollback case re-open functionality
                and Case_Record_Type__c != 'Internal Escalations'  
                and Case_Record_Type__c != 'Repair & Overhaul' and Case_Record_Type__c != 'quotes' 
                and Case_Record_Type__c != 'Orders' and Case_Record_Type__c != 'OEM Quotes Orders' 
                and Case_Record_Type__c != 'Returns' and Case_Record_Type__c != 'ReturnsPRO'
                */
                )  or ((Status_changed1__c =:true OR Status_changed__c  =:true) and
                Sub_Status__c =:'Waiting for Customer response' and
                        (Case_Record_Type__c = 'Customer Master Data' or Case_Record_Type__c = 'Warranty'
                        or Case_Record_Type__c = 'Web Support')))]; 
                 if(Test.isRunningTest()){
                    stopemail = false;  
                 }
                for(EmailMessage emg :  listObjEM){
                    if(emg.Subject.containsIgnoreCase('https://ease.honeywell.com') && emg.Incoming == True){
                        emgCheck.put(emg.ParentId,True);
                    }
                    else{
                        emgCheck.put(emg.ParentId,False);
                    }
                }
                if(stopemail == false){
                    for(integer i=0;i<cases.size();i++){                   
                        case tempcase = new case();
                        Boolean blchk=false;                    
                        for(integer j=0;j<lstRnOCasess.size();j++)
                        {                              
                            if(lstRnOCasess[j].id==cases[i].id)
                            {                                
                                blchk = true;                                
                                tempcase = lstRnOCasess[j].clone();
                                tempcase.id=lstRnOCasess[j].id;
                                lstRnOCasess.remove(j);                                
                                break;
                            }
                        }                         
                        if(blchk==false )                            
                        {
                            tempcase=cases[i];                  
                        }
                        

                        if(cases[i].isClosed == true || cases[i].Status_changed1__c==true ){                              
                            if((cases[i].subject == null || cases[i].subject == '') || cases[i].subject != 'ARINC Update' && cases[i].subject != 'HONEYWELL FLIGHT TRACKING REQUESTS'
                               && cases[i].subject != 'OCD Updates 620' && cases[i].subject != 'OCD Updates 623'
                               && cases[i].subject != 'PDC Update' && cases[i].subject != 'Sat Updates'
                               && cases[i].subject != 'SITA JetBlue Updates' && cases[i].subject != 'SITA Updates'
                               && cases[i].subject != 'VHF Updates' &&
                               
                               // TCS Team - Added for INC000010026498 Starts// 
                               //cases[i].Emailbox_Origin__c != 'Email-EMS-Norcross' &&
                               // TCS Team - Added for INC000010026498 Ends//   
                               cases[i].SuppliedEmail != 'aexmailer@aeroxchange.com' && //added for INC000010165264 
                               //!(cases[i].subject.contains('OneNav')) && //added for INC000009829508
                               !(cases[i].subject.contains('Case Transferred to you'))   &&    //added for INC000010647025       
                               !(emgCheck.get(cases[i].Id))   &&
                               !(cases[i].classification__c == 'CSO Spares' && cases[i].status == 'Cancelled' && cases[i].Origin != 'Phone' && cases[i].Origin != 'Web'))
                            {
                                
                                if((null!=cases[i].subject && !(cases[i].subject.contains('FAA COMMAND CENTER MESSAGE')
                                                                            || cases[i].subject.contains('FrontierMEDEX – HOT SPOTS')
                                        || cases[i].subject.contains('GA DESK') || (cases[i].Emailbox_Origin__c == 'Email-trandsupport' && elist.size() == 1 && setCaseIds.contains(cases[i].id))))
                                                                            
                                        || 
                                        (cases[i].subject == null || cases[i].subject == '')
                                        )
                                { 
                                    
                                    // Added for INC000006348757 Starts //
                                    
                                    if(((cases[i].status == 'Done' && cases[i].Sub_Status__c == 'Approved') ||(cases[i].status == 'Done' && cases[i].Sub_Status__c == 'Rejected')) && cases[i].Case_Record_Type__c == 'CP Outside Purchase Request') {
                                        tempcase.Sub_Status__c = '';    
                                    }
                                    // Added for INC000006348757 Ends//
                                    // Added for INC000010165264 Starts //
                                    
                                    // if(tempcase.Primary_Email_Address__c!='aexmailer@aeroxchange.com') {                                  
                                                                  
                                    //tempcase.status = 'Re-Open';
                                    //INC0000214866 
                                    // Reopening the case if got an email from non Honeywell domain and case is closed for below RT
                                        if((cases[i].RecordTypeId == Label.Case_RT_R_O || cases[i].RecordTypeId == Label.R_O_DoD_Need_Contract || cases[i].RecordTypeId == Label.Case_RT_OEM_Quotes_Orders ||  cases[i].RecordTypeId == Label.QuotesRecordID || cases[i].RecordTypeId == Label.Order_RecordType || cases[i].RecordTypeId == Label.Case_Return_RecordType || cases[i].RecordTypeId == Label.ReturnsPRO_Id) && userinfo.getprofileid()!='00ea0000001ZVRP' && cases[i].isclosed == True && system.today().daysBetween(cases[i].closeddate.date())<=7 && (String.isBlank(cases[i].Subject) || !(cases[i].Subject.toLowerCase().contains('credit') && cases[i].Subject.toLowerCase().Contains('block'))))
                                        {
                                            system.debug('====enterenddd==tempcase.status='+tempcase.status);
                                            if(cases[i].status == 'Rejected' && (cases[i].Emailbox_Origin__c == 'Email-AeroRepairs' || cases[i].Emailbox_Origin__c == 'Email-Order Status'))
                                                tempcase.status = 'Rejected';
                                            else{
                                                tempcase.status = 'Re-Open';
                                                tempcase.Reason_for_Cancellation__c= cases[i].Reason_for_Cancellation__c=='Redirected to Portal'? '':cases[i].Reason_for_Cancellation__c;
                                            }
                                                
                                            system.debug('====end==tempcase.status='+tempcase.status);
                                        }
                                    
                                        //added by kayal
                                        List<case> Listnewcase = new List<Case>();    
                                        if((cases[i].RecordTypeId == Label.NavDB_Accts || cases[i].RecordTypeId == Label.Tech_Pubs_Record_TypeId || cases[i].RecordTypeId == Label.MSP_Contract || cases[i].RecordTypeId == Label.HAPP_MPP_Contracts || cases[i].RecordTypeId == Label.FSSAccounts) && cases[i].isclosed == True)
                                        {
                                            if(cases[i].closeddate.date().daysBetween(system.today())<=90){                                           
                                            system.debug('Daysbetween : '+cases[i].closeddate.date().daysBetween(system.today()));
                                            system.debug('====enterenddd==techpubs.status='+tempcase.status);
                                            tempcase.status = 'Re-Open';
                                            system.debug('====end==techpubs.status='+tempcase.status);
                                            }else{
                                            case cs = new case();
                                            system.debug('====new case started=');
                                            cs.parentid = cases[i].id;
                                            cs.RecordTypeId = cases[i].RecordTypeId;
                                            cs.ownerid = cases[i].ownerid;
                                            cs.subject = mpRoEmailSubject1.get(cases[i].id);
                                            cs.description = mpRoEmailTextBody.get(cases[i].id);
                                            Listnewcase.add(cs);
                                            insert Listnewcase;
                                            system.debug('====new case inserted'+Listnewcase);
                                            }
                                        }
                                        
                                        //ended by kayal 
                                        if(!(cases[i].RecordTypeId == Label.Case_RT_R_O || cases[i].RecordTypeId == Label.R_O_DoD_Need_Contract || cases[i].RecordTypeId == Label.Case_RT_OEM_Quotes_Orders ||  cases[i].RecordTypeId == Label.QuotesRecordID || cases[i].RecordTypeId == Label.Order_RecordType || cases[i].RecordTypeId == Label.Case_Return_RecordType || cases[i].RecordTypeId == Label.ReturnsPRO_Id || cases[i].RecordTypeId == Label.NavDB_Accts || cases[i].RecordTypeId == Label.Tech_Pubs_Record_TypeId || cases[i].RecordTypeId == Label.MSP_Contract || cases[i].RecordTypeId == Label.HAPP_MPP_Contracts || cases[i].RecordTypeId == Label.FSSAccounts))
                                        {
                                            system.debug('====enterenddd==Other.status='+tempcase.status);
                                            tempcase.status = 'Re-Open';
                                            system.debug('====end==Other.status='+tempcase.status);
                                            
                                        }
                                  //}
                                    // Added for INC000010165264 Ends //
                                    System.debug('****Now the status is set to re-open****'+tempcase.status);
                                    tempcase.OpenTask__c = true;
                                    tempcase.Reopen_Case__c = false;
                                    if( mapOwnerIds.size()>0){//SR#419758
                                            for(string emailBox : listE2cEmailOrigin){
                                                if(cases[i].Emailbox_Origin__c == emailBox  && cases[i].OwnerId__r.IsActive == false)
                                                {                                                    
                                                    tempcase.ownerid = mapOwnerIds.get(cases[i].Emailbox_Origin__c);
                                                }
                                            }
                                    }
                                    if(listAgent1.size()>0 && cases[i].OwnerId__r.IsActive == false){
                                        if(listAgent1[0].CSR__r.IsActive == true){
                                            tempcase.ownerid = listAgent1[0].CSR__c;
        
                                        }
                                    }else if(cases[i].Emailbox_Origin__c == 'Email-R&O Avionics' || cases[i].Emailbox_Origin__c == 'Email-R&O MechComponents'){
                                        if(null!=cases[i].Case_OwnerId_After_Close__c){
                                            tempcase.ownerId = cases[i].Case_OwnerId_After_Close__c;                                            
                                        }
                                    }
                                    //End SR#419758                                   
                                    lstRnOCasess.add(tempcase);
                                } 
                                
                            } 
                        }
                        else if(cases[i].isClosed == true || cases[i].Status_changed__c ==true)
                        {
                            if(cases[i].subject != 'ARINC Update' && cases[i].subject != 'HONEYWELL FLIGHT TRACKING REQUESTS'
                                && cases[i].subject != 'OCD Updates 620' && cases[i].subject != 'OCD Updates 623'
                                && cases[i].subject != 'PDC Update' && cases[i].subject != 'Sat Updates'
                                && cases[i].subject != 'SITA JetBlue Updates' && cases[i].subject != 'SITA Updates'
                                && cases[i].subject != 'VHF Updates' && cases[i].service_level__c != 'Unauthorized Dist/Brkr')
                            {
                                if(!(cases[i].subject.contains('FAA COMMAND CENTER MESSAGE')
                                    || cases[i].subject.contains('FrontierMEDEX – HOT SPOTS')
                                    || cases[i].subject.contains('GA DESK') || (cases[i].Emailbox_Origin__c == 'Email-trandsupport' && elist.size() == 1 && setCaseIds.contains(cases[i].id)))
                                   )
                                {
                                    tempcase.status = 'Open';
                                    tempcase.OpenTask__c = true;
                                    if(mapOwnerIds.size()>0){
                                    for(string emailBox : listE2cEmailOrigin){
                                        if(cases[i].Emailbox_Origin__c == emailBox && cases[i].OwnerId__r.IsActive == false)
                                            {                                               
                                                tempcase.ownerid = mapOwnerIds.get(cases[i].Emailbox_Origin__c);
                                            }
                                        }
                                    }
                                    if(listAgent1.size()>0 && cases[i].OwnerId__r.IsActive == false){
                                        if(listAgent1[0].CSR__r.IsActive == true){
                                            tempcase.ownerid = listAgent1[0].CSR__c;
                                            
                                        }
                                    }   
                                    lstRnOCasess.add(tempcase);
                                } 
                            }
                        }
                    }
                    //update updcase;
                }            
            }
            catch(Exception ex){
                System.debug('Exception on case Re-open '+ex);
            }
       }
        // updateCaseReOpen - End    
      
        // Start UFR Pricing Case details update on response
        if(UFRparentID.size()>0){
            system.debug('UFR Case details update----->');
            List<Case> UFRCaselist ;
            UFRCaselist = [select id,Ownerid,Classification__c,Origin,RecordTypeid,Type,Sub_Class__c,Sub_Status__c,(Select id,Case_object__c,UFR_SBU__c from CASE.Case_Extensions__r) from Case where id =:UFRparentID and Origin='UFR Pricing' and RecordtypeId=:Label.Repair_Overhaul_RT_ID and Ownerid =:Label.UFR_Owner_Id];            
            if(Test.isRunningTest()){
                UFRCaselist = [select id,Ownerid,Classification__c,Origin,RecordTypeid,Type,Sub_Class__c,Sub_Status__c,(Select id,Case_object__c,UFR_SBU__c from CASE.Case_Extensions__r) from Case where Origin='UFR Pricing' and Type = 'Unfunded PO' and RecordtypeId=:Label.Repair_Overhaul_RT_ID and Ownerid =:Label.UFR_Owner_Id];
            }
            if(UFRCaselist.size()>0){
                for(Case cs:UFRCaselist){                    
                    //UFRSBU = [Select id,Case_object__c,UFR_SBU__c from Case_Extension__c where Case_object__c=:cs.id].UFR_SBU__c; == Commented query for eliminating 101 error
                    Case_Extension__c CasExt = new Case_Extension__c();
                    if(cs.Case_Extensions__r!=null && cs.Case_Extensions__r.size()>0){
                        system.debug('---->If');
                        CasExt = cs.Case_Extensions__r;
                    }else{
                        system.debug('---->else');
                        CasExt.Case_object__c = cs.id;                
                    }
                    system.debug('&&&&&&&&&&&'+CasExt);
                    if(cs.Type == 'Unfunded PO' && CasExt.UFR_SBU__c == 'ATR'){
                        cs.Sub_Status__c = 'UFR Response';
                        cs.Ownerid = Label.RO_Quotes_Team;
                        UFRList.add(cs);
                    }else if((cs.Type == 'PO Mismatch' && CasExt.UFR_SBU__c == 'ATR') || ((cs.Type == 'PO Mismatch' || cs.Type == 'Unfunded PO') && (CasExt.UFR_SBU__c == 'BGA' || CasExt.UFR_SBU__c == 'D&S'))){
                        cs.Sub_Status__c = 'UFR Response';
                        cs.Ownerid = Label.CSO_R_O_Team;
                        UFRList.add(cs);
                    }
                    system.debug('----->Caselist '+UFRList);
                }
            }
        }
        // End for UFR Pricing Case details update on response
        
        // AeroGSEVendorSupport - Start
        /*if(parentid.size() > 0)
        {
            List<case> c0;
            c0 =[select ID,ContactID,Subject,CaseNumber from case where id=:parentid and RecordTypeId =:label.GSS_Quotes_Orders and Emailbox_Origin__c = 'Email-Aero GSE Vendor Support'];
            
            if(Test.isRunningTest()){                                                
                c0 =[select ID,ContactID,Subject,CaseNumber from case where RecordTypeId =:label.GSS_Quotes_Orders and Emailbox_Origin__c = 'Email-Aero GSE Vendor Support'];
            }
            for(case c1: c0)
            { 
                  if(c1.subject != null && c1.subject !='' )
                  { 
                    string test = c1.subject.toLowerCase();
                    if(test.contains('purchasing') || test.contains('purch') || test.contains('carol') || test.contains('grace'))
                    {                                                      
                      c1.Sub_Class__c = 'Purchasing';
                      c1.Classification__c = 'GSE Vendor Support';
                      c1.ownerid = label.GSS_USER_ID1; 
                      clist.add(c1);
                    }
                    else if(test.contains('engineering') || test.contains('engrg') || test.contains('engineer')
                             || test.contains('bryan') || test.contains('vanlandingham'))
                    {
                      c1.Sub_Class__c = 'Engineering';
                      c1.Classification__c = 'GSE Vendor Support';
                      c1.ownerid = label.GSS_USER_ID2; 
                      clist.add(c1);
                   }
                    else if(test.contains('quality') || test .contains('qa') || test.contains('joseph')
                             || test.contains('olszewski') || test .contains('joe'))
                    {
                      c1.Sub_Class__c = 'Quality';
                      c1.Classification__c= 'GSE Vendor Support';
                      c1.ownerid = label.GSS_USER_ID3; 
                      clist.add(c1);                                                                           
                    }
                    else if(test.contains('receiving'))
                    {
                      c1.Sub_Class__c = 'Receiving';
                      c1.Classification__c = 'GSE Vendor Support';
                      c1.ownerid = label.GSS_USER_ID4; 
                      clist.add(c1);                                                                           
                    }
                    else if(test.contains('drawings') || test.contains('dwg') || test.contains('dwgs') || test.contains('erfq'))
                    {
                      c1.Sub_Class__c = null;
                      c1.Classification__c = 'GSE Vendor Support';
                      c1.ownerid = label.GSS_USER_ID5; 
                      clist.add(c1);                                                                           
                    }
                    else if(test.contains('follow-up') || test .contains('follow up'))
                    {                       
                      c1.Sub_Class__c = 'Follow-Up';
                      c1.Classification__c = 'GSE Vendor Support';
                      c1.ownerid = label.GSS_USER_ID5; 
                      clist.add(c1);                                                                           
                    }
                  }                                                      
            }  
               
            if(clist.size() > 0)
            {
               
                lstRnOCasess.addAll(clist);
                
            } 
        } */
        // AeroGSEVendorSupport Trigger - End    
        if(parentid1.size()>0) // ROActivitycreation  - Start
        {
            case c2 ;
            c2 = [select ID,ContactID,Subject,OwnerName__c,R_O_Case_Origin__c,Agent_Contact_Flag__c ,RecordTypeId,OwnerId,CaseNumber from case where id =:parentid1];
            string CaseId1 = c2.OwnerId;    
            string que1 = CaseId1.substring(0,3);
            if(c2.ContactID != null && c2.R_O_Case_Origin__c != null && c2.RecordTypeId == recrdtypid1)
            {
                List<Agent_Contact_Mapping__c> lstAgent = [select id,CSR__c,CSR__r.Signature1__c,Contact__c,Process__c from Agent_Contact_Mapping__c where Contact__c =:c2.ContactID and Process__c =:c2.R_O_Case_Origin__c];
                if(lstAgent.size() > 0)
                {
                    for(Agent_Contact_Mapping__c agc:lstAgent)
                    {
                    
                        if(agc.CSR__c != null)
                        {
                            Task t = new Task();
                            t.whatId = c2.Id;
                            t.Task_Subject__c = c2.subject;
                            t.RecordTypeId = label.R_O_Activity_Label;
                            t.type = 'R&O Activity';
                            t.OwnerId = agc.CSR__c;
                            t.Escalated_To__c = c2.ContactID;
                            if(c2.subject != null)
                            {
                                t.subject = 'Activty on '+ c2.CaseNumber + '-' + emailSubject;
                            }
                            if(c2.subject == null)
                            {
                                t.subject = 'Activty on '+ c2.CaseNumber;
                            }
                            t.Status = 'Open';        
                            NewTaskInsert.add(t);
                        }
                    }
                }                   
            }                                               
            else if(c2 != null && c2.RecordTypeId == recrdtypid1 && c2.OwnerName__c != null)
            {
                Task t = new Task();
                t.whatId = c2.Id;
                t.Task_Subject__c = c2.subject;
                t.RecordTypeId = label.R_O_Activity_Label;
                t.type = 'R&O Activity';
                t.OwnerId = c2.OwnerId;
                if(c2.ContactID != null)
                t.Escalated_To__c = c2.ContactID;
                if(c2.subject != null)
                {
                    t.subject = 'Activty on '+ c2.CaseNumber + '-' + emailSubject;
                }
                if(c2.subject == null)
                {
                    t.subject = 'Activty on '+ c2.CaseNumber;
                }
                t.Status = 'Open';        
                NewTaskInsert.add(t);
            }
            else if(c2 != null && c2.RecordTypeId == recrdtypid1 && que1=='00G')
            {
                Task t = new Task();
                t.whatId = c2.Id;
                t.Task_Subject__c = c2.subject;
                t.OwnerId = label.AERODEFAULTUSER;
                t.RecordTypeId = label.R_O_Activity_Label;
                t.type = 'R&O Activity';
                if(c2.ContactID != null)
                t.Escalated_To__c = c2.ContactID;
                if(c2.subject != null)
                {
                    t.subject = 'Activty on ' + c2.CaseNumber + '-' + emailSubject;
                }
                if(c2.subject == null)
                {
                    t.subject = 'Activty on ' + c2.CaseNumber;
                }
                t.Status = 'Open';        
                NewTaskInsert.add(t); 
            }
            if(NewTaskInsert.size() > 0)
            {                
                //insert NewTaskInsert;
                tasklist.addAll(NewTaskInsert);
            }
        }    
        if(parentid2.size() > 0)
        {
         em=[select Id,Status,MessageDate from Emailmessage where ParentId =:parentid2 and Status = '3' and id !=: emailid];     
            if(em.size()>0)
            {
            }
         else
            {
               case c1=[select id,CreatedById from case where id=:parentid2 limit 1];
               ts=[select ID,status,First_Message_Date_Time__c from Task where Whatid=:parentid2  and case_Origin__c='Email' and status != 'Completed'  and CreatedById=:c1.CreatedByID limit 1];
               for (Task tsk : ts)
                {
                    tsk.First_Message_Date_Time__c = lastCreatedDate;
                    tasklist.add(tsk);
                }
                //Update tasklist;
            } 
         } // ROActivitycreation  - End
         
        if(lstRnOCasess.size() > 0)
        
        {
            update lstRnOCasess;
        }
        if(updatep2cCases.size() > 0)
        {
            system.debug('updatep2cCases'+updatep2cCases);
            update updatep2cCases;
        }
        
        if(tasklist.size()>0)
        {
            upsert tasklist; 
        }
        if(UFRList.size()>0){
            update UFRList;
        }   

         
           
           // added for task SCTASK3049692

        for(EmailMessage emmsg : listObjEM) 
 {
 if (((emmsg.ToAddress=='FlightServices@Honeywell.com') || (emmsg.ToAddress=='flightservices@l-1do9z9w290v47ut49gz3fb93xawx4giohx3xkw4la3uf7wi8f1.2g-io8eai.cs35.case.sandbox.salesforce.com')) && (emmsg.Subject=='NET JET MSG') && (emmsg.FromAddress=='gfo@mygdc.com') && (emmsg.Incoming == true))
 {
  setCaseIds2.add(emmsg.parentid);
  System.debug('setCaseIds2 : '+setCaseIds2);
   if(setCaseIds2.size() > 0)
        {
        Fsscase1 = [Select id,Origin,contactid,Subject,Reason,OEM__c,Type,Classification__c,Sub_Class__c,Detail_Class__c,RecordTypeId,Case_Record_Type__c, status, closeddate,isclosed From
                              Case Where Id in :setCaseIds2 ];
                              System.debug('Fsscase1 : '+Fsscase1);
                              
                    for(case FSScase : Fsscase1 )
                    {
          
                      FSScase.RecordTypeid= '01213000000AWre';
                      FSScase.Subject= 'NET JET MSG';
                      FSScase.Reason= 'Tier 1';
                      FSScase.OEM__c= 'Other';
                      FSScase.Type= 'Task';
                      FSScase.Priority= 'Normal - P4';
                      FSScase.Classification__c= 'Flight Services';
                      FSScase.Sub_Class__c= 'Other(FS)';
                      FSScase.Detail_Class__c= 'NETJETS Relay';
                      FSScase.Status= 'Done';
                      updateFsscase1.add(FSScase);
                      
                      }
                      update updateFsscase1;
    }
        }
            }
                      
              // ended fro task SCTASK3049692
    
           
    }
    
    
    
    }